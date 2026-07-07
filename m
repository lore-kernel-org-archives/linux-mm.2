Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352E3C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9436B009E; Tue,  7 Jul 2026 09:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291586B009F; Tue,  7 Jul 2026 09:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1809F6B00A6; Tue,  7 Jul 2026 09:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC3316B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:03:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D3111C3941
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:03:52 +0000 (UTC)
X-FDA: 84961997904.07.77826BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C74C9C0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:03:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4QQRuVU;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fty/ZIfepQG57aNXhv/nbLK0ZzmGRMvkRFvn0JT9s7o=;
	b=z7cSj9yluHko9jSHxubLT6+msfiHEasWVNRsuFiqCug1UaToAEgK/Ldeo+fxUn8ZakcDiV
	DI18vNUh33D1UKxtCWAhV5Td4sXK/1rN/IP3AQQcObIWzXkskDUc2CSrwu5nKNRa94j4A2
	TSqPaloIrEVOTFdTpu3XvvXAIF3rAHY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4QQRuVU;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429430;
	b=a2D0W1ShharvRTDdXI6y+jrVsfMqfghcx1krQLIjQTCrcSDQUTlzoXZTId8HVA4TqZQwEs
	b7v5J9dyJ3g45TTyXs2TDtFh4ZvmeuYgY+U6B9QXcTxMM13MERttQ6t9j7hZdakUp7QQv/
	3KTARcN21GrKfsqG3wjQ9OXpG0LEjDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 316FE60018;
	Tue,  7 Jul 2026 13:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D7C1F000E9;
	Tue,  7 Jul 2026 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783429429;
	bh=Fty/ZIfepQG57aNXhv/nbLK0ZzmGRMvkRFvn0JT9s7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P4QQRuVUU7hB5m0OOB3wt2KTXJDUFb+y7pu+q34nSSBNFQqRIVc/ytfsQeIPtEOwG
	 v7p/4+97u7FcKN3raLCGhu+7R+R7KkI+NC98EfJOThfJyPphRpn9o0CILTjH2GdAOS
	 COYDg0OZBR5BtiW/Z41pYM0N9niLFwI4vSZrn2A+X7RJndciE0QWZaHZHHL/xDHIMM
	 Hgt+WmRNGpDvrfC/jTok5VoWpIeUgQDUWenQ7dGP1lt/ppfqM/u3o4bolao+2aylna
	 SIGrJmBsSFcxIcIweY0EdWpS/ms2JbXjm8WOO8kqdzzCAJYJEQ1qoR0Xo/pg+gvs8m
	 pEMQV7ipJTDRA==
Message-ID: <56665ebc-a8de-4d59-a4bc-94b42a6b74cf@kernel.org>
Date: Tue, 7 Jul 2026 15:03:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <892b2a73-4dbd-4090-89c5-46929530b855@kernel.org>
 <9beedaa7-0896-4aa2-810e-26042476e7a7@huawei.com>
 <2e749bbc-86d1-4a10-9809-4777bb5061e7@kernel.org>
 <5a097591-5a6a-44f2-b440-44a2395fa788@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5a097591-5a6a-44f2-b440-44a2395fa788@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C74C9C0005
X-Stat-Signature: 7nnx4b4xjh1my8wtnc7pyjs6bfhxpkp4
X-HE-Tag: 1783429430-283762
X-HE-Meta: U2FsdGVkX19pv0ju0lkjs8nxVsKrNZbXl4wRlneFQRpoGkXalXNO0LzCBx2BJqteA3EwuGzKdQ4AYtbE61ol0r9qUZSyruwcYb9Pe3NDcADofop5YvQP2AW2YVTMaf4LFF1fXvySBF0ZstbRJXw9A8gXkel2e4b8e393SnXl0t6w3etlhJCMq+Z098v/7ZcsLaewNX2wznVABzWCpWorofGf4ssEN6G07kdKG30cYpa5Kmo9PU7IsbkGp+pLLwPNB6q5+2gIJzdH/Kj1o+OtvFkblj67Ls/g1DxYxUV7SAkdDKrlyvippxigQ8q0gYUT5RtYoxJghaV3W0AeJEfQsnPu2hvNNIA0aOmdzSckRy0GAuvECB/L7YVHsKB9FzvwqKesxvAT9Ta6E5ERUgKb11lOwY8KJHue/AUWOylx6+5A1/+QhhIIhn4B0E7o0Jqf/dWqIEiQ9KQUypJ6NObwYUx+cmZ1LTwpEOtYvyo1FF12uQdI/LlX2XnrKtXJqsG/qpNvWqHtlxyVUYAA3eMZiFLwQY8Dyi33vvrsBVYfxD/j4hMSJ88ndWvVE/7YadkUbjsvpGzwJHrilbQd1Uu9s4/htgYGGSmSOkn1neGvZTcqTf/de+rOu/oAo3MSDQIaWr2xIFoB1mSvhuNVDpuiWjYcyLm/qMqsIABZ1Urpf0zGeIbg/3hI99PlrRJonE6+lsOizkVEo3psEhlrt8PDFuzOry14upbDY68thfRmHArWWH6ngKlM9WoGlti9zSUkTk6dXUy4VXXGl+ftojskNFpCbY76EyYtsGog84LgjysZih73Ah+ibef4PSoeQ0QMp5Iu0BPTvJqWt2SOB6+i3TO3eopSDWBjcLDWxYdD2BC90xPW/hKRr/4lj/BhqA4REQn8ERxUnMPrdQRas6CtzRkkl8wnQC88MFCpR2efIG5se/3oVH+uV81wYq4ZMAc2Ov5dB5fpMCrcmLJW8Dx
 4xA6iaNr
 SfJkDGjYRf7fu5BQjtOE4MMGQk0rO5c+Ely1+3tumfWxusW248vd86rU7+UMIacdfos2iKV4KCgc6vnrrcnZaXPXT4SRWEsLutUtQvvpYPYi7uXfSVeiLDDzS++tldSN4FNfnCZWJScM4Tfm6WmVnJl24axYqoql7nXlwOxqXkXMzDMJzf43HsuKeD23HxqAOr2rAEFJ7RjWzv+yD+4O1cjjTMEzZRtHmT8L34E+g22cCVq+MKDvspb8jfmznS5IZLKPAj7M1cbZO7xyXZIWBgs0Jabp4IpNuj4C0t6MUzxbQaps7ZSrmkmMKS5cKVMhmQkK2nrrQQ+OBOjPkgo2O1WiDztCb1fNfNfieXCfaGGL5/5qMfmDbNOMCAOcK34DtPzJTuho0dIy/ph4mqOc6NTAuQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 11:33, Kefeng Wang wrote:
> 
> 
> On 7/7/2026 3:04 PM, David Hildenbrand (Arm) wrote:
>> On 7/7/26 03:28, Kefeng Wang wrote:
>>>
>>>
>>>
>>> Yes，device-private entries.
>>>
>>>
>>> I couldn't find a more suitable commit, before a3589e1d5fe3, the
>>> flush_cache_page() only called under anon_exclusive, not a device
>>> private entry, so there is no issue. This is the reason why I chose
>>> this commit.
>>
>> What makes you believe device-private entries wouldn't have PAE set?
>>
>> This likely goes back to initial support for device-private.
>>
> 
> We only need to make sure that flush_cache_page(..,pte_pfn(pte)) won't
> be called under no-present pte, I go back and find the
> flush_cache_page function was first introduced to
> migrate_vma_collect_pmd in commit 6c287605fd56, so maybe this commit is
> better for fix tag? what's your option?

That looks about right. For device-private we wouldn't need the ptep_clear_flush
(ptep_get_and_clear would be sufficient), but that's a different optimization.

-- 
Cheers,

David

