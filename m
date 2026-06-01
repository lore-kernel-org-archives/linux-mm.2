Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4136CD6E61
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091AC6B030A; Mon,  1 Jun 2026 06:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0429F6B030B; Mon,  1 Jun 2026 06:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E735C6B030C; Mon,  1 Jun 2026 06:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7FD36B030A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:09:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 806F6C221B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:09:30 +0000 (UTC)
X-FDA: 84830921700.17.B1C7DDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D07631C0003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:09:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/RSr7+q";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780308568; a=rsa-sha256;
	cv=none;
	b=zvcrsdYuerXqnoXV8sJZ2GomQM5k/IxgNbQeTYOKnh9JKhDkp4gkAA8xAON1xEHPwDvmV8
	kQo0vYkhgGcJF9bKri4OfmV725FOPS6jksNOlEFxbupwhIQnAD/kQz9onvV+QZDUwOANzo
	4eqc+kjdHGrigWd8wocqcgG1T3JF0J8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/RSr7+q";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780308568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=telDdSC7/EI4bm0my2SYNWvjV6/+1WMfaGUydwsM0JE=;
	b=A8rSVEelZC/jVZ053/3aP1AKGxmq8oMFB7Yp2K6Yr4Jf+JhSEMeqnYs3CNb4Qa93nUpiLz
	8QE6AN3d9ceKS/QujBIS85voTGAkunPPDXtlPqX9z/4GPCpaZmt4JJXCrmET279+PJakA9
	2sGqLiETzKBtZN2AVtm9sBJ5KndDD6o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3874F60018;
	Mon,  1 Jun 2026 10:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9011F00893;
	Mon,  1 Jun 2026 10:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780308567;
	bh=telDdSC7/EI4bm0my2SYNWvjV6/+1WMfaGUydwsM0JE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E/RSr7+q/6nIFb+9C6c9jmKbP1es072hXYz1IQTGwUjqaPxnQ3p0yc/KbCu5ZwWW7
	 O4de5CsFCu+YBhZn0/qvFCVmXnhQZ+9bcoLMBeKqREXxlFIr5oU6mXmOrcX6VruVjp
	 j5WG8L1x8M48jYN/AQiG6LpMUDMP96kfuQ5pbitNPPhKrhMEkpVqoLAjig4X1ATvh5
	 l1DeuNTi+4uytvO3r+WRDidfs8pVNImknpTmQZ48FHAhfLQgEP5r/X2x3TH3Ibx3rF
	 WW0u5PA4rvSr7OS8rrXPbpZCp0JRJt7WiTn0MRU8VhZ3ldi28u+HEvu6N0aoZFitOS
	 ihVHv9tWG1ZZw==
Message-ID: <c73fb0fa-f109-4a52-a28f-d558b9445e9e@kernel.org>
Date: Mon, 1 Jun 2026 12:09:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <fb8f24b1-ce8e-4f06-bbd8-f148a9bcaeee@linux.dev>
 <1c99294c-9ebe-4856-bfde-09801701d75c@kernel.org>
 <32751424-8ad3-4fd2-9f07-8a4f5a98d632@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <32751424-8ad3-4fd2-9f07-8a4f5a98d632@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D07631C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: 4h7mo986hzumbou4b5mi7wd1tfj9cb76
X-HE-Tag: 1780308568-314488
X-HE-Meta: U2FsdGVkX1+bJrujpEoV4TLAuH2LeWodi/ClG1sqAGHGVL+gifyk0O0h2ViZbbWh9LfRMDM36ImntH9ZL/qzX7WHAv8psOTwAAOkb72BX0EQ+dUC5AkSw+lLe4VafYYJC9Duws76+cxw91D6ogwfxjP74QOx70MgolepLklgVIcvaOgmgE9K5aiLI/oMhPx9I/JA6Vg3pHbc1kFVAN81xt7iNtlE8tfCxhDeHxT3o5XkX26u3+YkEPQc9NoSrEpH3ooQNY8NXQq6IM0Q9LB2fI8ZhPd4y+7jXxcKsJw+TGHleU859vH8pJAM9JaGiYL2mM1f1A24WrwScVhW7Q+dHRZTX6NIu5T7rcs/ovX8weoUucdlNmnEgTIOxQOeTjMm72fHZ4CTfXGZVXMrO+JD1TmbkSenYJzTk5nJLSB+F2ABuf8mIhOuulTVzf96H8jpSdMoJeU6a5Ms6KPmgbh5ixOvqDA8a5nbWXbXq0ScrVh25VNGb0420LU1laq9AlGrLkrqwpZKVcKGi20Gs/hOphHuVVCeY3GUOyshULdFqi+XD3iYXm/75OwReEolyMW5wbHMG09Z6VxmhXcmNr0/zW63fzJjMpcDran+x6qlT2c+LqGch0fpwka4DJx7QnybQcPB1fqkmeWfrr3ePtFVcD5LSrxyw/EycXTglkmc5wauCpZt8j3bs9nBAqQddEV0qyl71yMlRfGoifcv6HWsdrYy5zckk/VEIuPRJ49o8iRlxGhbF16r2FChLWxqdUPA8JkocZBCJSpiFFWs+lGFzPslLncJtBlajnVjfGFrBxR0SxHf3h27+LomVJDAupdq4w8yls8ZogQq4cuQMbsDisj4kP8KnisPIfZmlosH1B12hl6NDQrzXgN2I9JnreRWsJ1C2sbmzFA2yRMgghLjnWeOFCuu9rswE3mMbJU+VKfe74VWJdjAv5K31ykAcg2+KauoovUinX5dgItMgW0
 LLJp0LFN
 MyZmcT4KMM6FAD/g6EAQCVhNtjPXNxGE4ql86ZZ6Sd9Wa4ZWKWcSflZ9aWlV12YLheM54baDl2jQyAAqV/tIDbAVhziFleA7J/hdqGLuzDJ9zsqYqkrfCOwWDrEyBMvByLr/RBVtox7KJrek+Rh3teB3AuS8YNc4yVZwIAUy5bQcE3rrkKFkdSMyPJCAfQvn+o37aubxsl797IpCsMyvj5dIkAg4cnzZTS0Xs6gsEQbEUhmnQWRb/xMVdw6AGPLQ6MtxQRmaQva3a0tZDN7Xl80i4yUO9x0wcuYU3QGF+RIAZmJpTl+oh6KaI434qtJ9kf0iysRt7z/VLQudljlg52oSmK3eSUYR45zoV+diJGG4aXSyf9pgdI1yAkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:44, Lance Yang wrote:
> 
> 
> On 2026/6/1 16:15, David Hildenbrand (Arm) wrote:
>> On 6/1/26 09:49, Lance Yang wrote:
>>>
>>>
>>>
>>> I had Codex do the boring grep-work through the arch update_mmu_cache*
>>> code :D
>>>
>>> MIPS doesn't seem to be the only code doing a re-walk, but it is the
>>> only one I found that appears to assume the PMD/PTE walk cannot fail,
>>> without checking whether the PMD is none ...
>>
>> Okay, but likely the other code that tries to handle it is also problematic.
>>
>> Best to make sure the page table is already installed when updating the entries.
> 
> Neat, makes sense to me :D
> 
> That way the page talbe is back in place before any arch hook gets to look at it :)

Right. I don't think we could run into a deadlock here (nobody should
concurrently take a look at the page tables in the first place).

Not sure about the memory barrier I dropped: the page tables are already
properly set up (just some entries cleared), so I'd assume that barrier might
not be required.

-- 
Cheers,

David

