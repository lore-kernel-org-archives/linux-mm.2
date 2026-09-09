Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D17C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D2C6B008A; Wed,  9 Sep 2026 09:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7946B0092; Wed,  9 Sep 2026 09:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00986B00AB; Wed,  9 Sep 2026 09:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C27CD6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:43:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE4391201F6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:43:11 +0000 (UTC)
X-FDA: 85194340182.24.60BE445
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17DFDA0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:43:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bYS5kG7e;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788961390;
	b=DiFZS4ClxVMeCH2H8b3ckhoj2fOFERYh/hW6StBNRZhKiosXUfzKmShzJHLXNRslh9Wc/2
	/TV8kcrWKR6/lKQEtqX3usB8jxcpl/OsGFLsjS93RnuwhcM2Mv4bUzBFiHxseZgcmD3yMo
	vE3sc/fkhSNW9Xknuc0LVVhwWt/G8MY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bYS5kG7e;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788961390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9IzuLqDULcD860ya5R4OSTfR5VByrothjUZYfYv1/w=;
	b=w4FogBZpEhYmC6+McuknoUE2N292rZfhiMd1ltB8nSY9yLJH+6+MguQWaez9ZglWPIAjxX
	F98CccPrN/CxgJJyBSsaxzTs81oG1mVsmr8N4URFeL5086Z42CnQrrqGY9SorkvRuoaU4I
	HzrBUDNWEamCNuw0fWXoZ5Cd2r/HDpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3823C433ED;
	Wed,  9 Sep 2026 13:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA481F00A3A;
	Wed,  9 Sep 2026 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788961389;
	bh=u9IzuLqDULcD860ya5R4OSTfR5VByrothjUZYfYv1/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bYS5kG7e4E5j8HFOwgf2LIOyXcy4a25Yvc6Y3XLeFu/8a6PVFx5B8WYOyEcjewUmN
	 jW04ZRymPTZpVDoUmqfDccKEUeB5BYifKEsEnkZLavCGdl1YJoXuSFHw5/iP4rh8bm
	 b/MvS25hdYpQcmIDoxo8wNMc49Zag720BJ14WBnnXFMhIepMzJnC6cVPmBbqAGBmae
	 L+O75kGdtiB9bCj3zQ3gHtPxeNhkWWZj3f/pVVO0w/X01GKjqpyFz119ULV9Ni8qKL
	 GVGRjlcWOpw/1/1Wtk2u5XncOGCx2VsNxZiDLmLDr0/u7EhyVPP+jieu+t+3X8AojC
	 Q4XS3SO9cicrw==
Message-ID: <c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org>
Date: Wed, 9 Sep 2026 15:43:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for
 compound folios
To: Hui Su <sh_def@163.com>
Cc: Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Balbir Singh
 <balbirs@nvidia.com>, Zhi Wang <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gourry <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>, Alex Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260817120758.669807-3-sh_def@163.com>
 <4ead5df7-f000-4087-83e4-13aae036e0b7@kernel.org>
 <apESOAPVzggWmbcJ@gsse-cloud1.jf.intel.com>
 <5ae7a11c-1db4-44cd-bf67-a98cfd5ca08b@kernel.org>
 <20260909112049.3202956-1-sh_def@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909112049.3202956-1-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17DFDA0006
X-Stat-Signature: tak19oucd6tw8kwqhaugpit7ppiag4m1
X-Rspam-User: 
X-HE-Tag: 1788961389-123724
X-HE-Meta: U2FsdGVkX19GqKXLBNM5uMy6r8c44yygB86ZCUNcuJgQ25ZmIUZDPpcPMnq86ZjLMUup7oLHiDBIDHhPEjNuBAOFz/QzfsjrstfPriaQ0yTqn/BRfw2l1cYG1HGhlnCXrKTRLPuhzOSScwjkZCpc77XWXpkcahLVMpnAuVtxo/jasauIuAXSCmcgFANCE3P1GT0PrZ8/w7wEbhBO09izmA0l3Dc8AqmDlqIoFvRO8oq494p7WTXnjUzehizFF6ACBuR2w4Mv8KIRquQpUhdM113dV0w8X646VeS9pN/NBz7STmSKPtmh9ApY3WVUWTix+uF7efWPK86747jgzcBwL+LxPExkeiEzqdeEwexJO1FG9hLzM9UzSgJJ5GmbulUkFofxYcFsnWN7jp1lzCMykTRehIbo2HlistspzbJ3j8jbMNum/Zfxao7pigZWFxJkijgKTSKQ1sqTKYuf+sn/+HZ+LNRISNatAh/+uvMHh6pZ8j70lCpMqLRBpgVhPbBIcOzkqS2txccvEr+HqnIv+b+o0Vc1CqErwZvEYJ09h0cYbfA61hZcT/RejHM0kpsZ4/XzhSrI3j8LQeCDOHYpkSfTySPPVwDWm9hoHUMtgf2IGj+6IfPzp7vn29UrAJEEdQaJf7/ZdabPWNg3IrgPGqbUOcGH8vv4iy0dPFH03xhV0ZUdHIQ8YwzGYR5vH67IN9ESbc5C9w7iaxIphvnGFfmevQK7Rwi78Rlw5iqf+f6EWy8utiNEGDs+Aydj8AF050aEpnpJO8PNhLYgsBSRb0fpt5gG5yiZHcPhZv6hJgeN8W8ufL7JGgee1AaYPJ7VWfL4cbU6LckZPK643vmED/3pU4j4iwt+1WHSDkamePYjOoygqZuwR4hEamBrjLoAmHvWXu/Wqv5MTmrFXfsR4qk/e9Z5TR2clMoXU+JZrJZNlLBl4CojGLoixVK+PJ+PhLJH+DPyo31wjKq18Y+
 KuvgFDED
 JOy6aRyUTeIz/qhZ6Qkmq2uH1UC7hh3YSDEncYD8A5ZHeyoclPGajAftuqjs6Zeoj//ZdsgiTd++9+l8sRO9+9ylBdJ5SlMGf9zltUmNWh5s/3SrMr4RY8ilwG61uvCmNhJAEykTDCPvrb9CpUrLITQFzdg3ksootJ02+QkOF2wzC4YbuA61i4UUJdPouqmOuXbyYrKtCc/njBEAMdFrgGz31MU1VvVDVunsUGK5KfQD84lz9ShXpmTTzeqYEZp9hC92bGZJQ2Iiz5HgbBKXJEi2Kras1Imq3mxAwvQe6Kse27Ixyohsfa++3HsQ05QSrHBHo9LAZmwY/rcz6cBajQKQqi8n9PiCxqVD7qkL3yHWXN8REBzuZ2a5Z04mW8wEDG08h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 13:20, Hui Su wrote:
> On Mon, Sep 07, 2026 at 02:23:33PM +0200, David Hildenbrand (Arm) wrote:
>> That's what I was thinking: because how should we partially migrate folios?
>> Doesn't make sense :)
>>
>> If this cannot be triggered today, neither Fixes: nor CC: stable is appropriate.
>>
>> Agreed that we should just warn.
> 
> Hi David, Matthew,
> 
> Sorry, I missed this earlier.
> 
> This fix has already landed in mainline, but I agree that the API semantics
> should be clarified. Partially migrating a compound folio does not make
> sense. If the intended contract is that callers must not provide a range
> that cuts through a compound folio, then treating such input as caller
> misuse with an explicit WARN/error path sounds reasonable.
> 
> The reason I added the Fixes tag and Cc'd stable was that I observed an
> actual KASAN out-of-bounds write with the HMM migrate_anon_huge_zero
> selftest. The path was:
> 
>   dmirror_fops_release()
>     -> dmirror_device_evict_chunk()
>       -> migrate_device_range()
> 
> My intent was to prevent migrate_device_range() from writing past the
> caller-provided src_pfns array when such an input is observed. That said,
> silently stopping the collection is not necessarily the best API semantics
> if this should be treated as caller misuse.
> 
> I will rerun the reproducer on current mainline and report back with the
> result. If the preferred direction is to make this an explicit WARN/error
> path instead, I can send a follow-up patch on top of mainline.

Yes, and please clean up the code in any case; the duplication should be avoided.

-- 
Cheers,

David

