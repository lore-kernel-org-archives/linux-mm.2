Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A03CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304576B008C; Fri, 19 Jun 2026 06:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B56A6B0092; Fri, 19 Jun 2026 06:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17EC66B0093; Fri, 19 Jun 2026 06:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E56C36B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:48:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EF941665A8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:48:34 +0000 (UTC)
X-FDA: 84896338548.13.3BD017E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEE5C140004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:48:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orMKanpl;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3t8vaOn0ix0MngUTweZ6TuSJVXEvQJYIrEY291l3SUA=;
	b=Q+aYymsLDle1pAfch4sjFDYDF2aSQWwQZ/kttOgiKhx63TSQYIH4+j8qDCPXvrKHZ5ZQE+
	OB+27Uq2wTkOYQMwTgiuq/+DB6QI5PbzL7E8/gg4R6b9BDx0UoKFN9uxEkr5ZMw0bNjHMt
	UReMQWOPfHGKTuc9VoNLvCwX0dv9mQ4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orMKanpl;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781866112;
	b=waFdIscFpiIJZVkFkmnmJ9vPG0dfKj88RlPc2nyT8ZTUYOWynTysulkj7SY8Yx+PcF8YMD
	uHklRUisOFvPXsXxBpfQ0mrGyBk9SeKJIjYe7yKeAkElYHMiBI7ghWaJgWb7Hv+aGbt7MC
	F3ApC/rxWUxe7+4ycJeWIG/1hgmKLL4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 383F6601E1;
	Fri, 19 Jun 2026 10:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9F71F000E9;
	Fri, 19 Jun 2026 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781866111;
	bh=3t8vaOn0ix0MngUTweZ6TuSJVXEvQJYIrEY291l3SUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=orMKanplhr04Ue2dQdlPYJh75rfY2yFQ+e7j669JBW3ox3e29moA0PscyJWPf1QHv
	 m7G1srxg5cVBtTsDg4ydRGik4OKdgWFcntrvGsIU7OlKaJR3QCfa3FAe0KFz8iFJjK
	 F9AajabPet0dVjYoDNj9+cr/4XuK7g75fxQ/0WNpNpejByglbBSpa3Kh42RtpiiYQo
	 XK/wbYmTkSOrpyRqbA/7qrF1GphpDV6QC6dzZqXjKpGpNA+huPaNRJXjZ7A7UAkl3l
	 ksP5pZ/kS7Ifn94d086LQaEqYNIH+HcEbkxcChk7Ke9GUNQWeydfprp4bl5mIlM5Ic
	 XAeh7FiqaVTBQ==
Message-ID: <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
Date: Fri, 19 Jun 2026 12:48:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
To: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, balbirs@nvidia.com,
 ziy@nvidia.com, sj@kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajUXNjRMraKb6k2n@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEE5C140004
X-Rspam-User: 
X-Stat-Signature: apcurxzmiku9ssbbmk8aqg6xphs1tyar
X-HE-Tag: 1781866112-304850
X-HE-Meta: U2FsdGVkX18OggOf7g5q6CM1yAJt98T6bq6JekUDR1LkTFGbfIOFMXr8HMsq4eluJOOU92t1ulT8TydU0HmjhHQfK5GMmGoJnPNBh5t/oMOwMzcGGMC7SV9RFK/vX1ULwJ8CnnUrEDvXMVAuC3hhp4uaRmgo4lORy3hr3r/rlBQRkthLCSpIL5WrxvW4PzOrtJ48mkpJLJP1OyzwO1f8c8c7gCo/L85w2klKDU3ez2XlbqJoGAcr3x3t7OczhfvtNqs5+x1JmgbUu6YWqyHAJMdtrj46ClvCk/ZL/2TiMkFJ9ZypgY0nexxH6DZ/AtrDm/mKYR3ZVXYSdgmFb+5ZM3WGsHJCFsvDfb1VAIds+6QxXMJneAGU1jRTlNIfEgm0fgaktRjswmc6m0Iqgc8GLZTWkuPRT3Lloi1k+T/o8DybWNkJ5PaBOp14FiKNxNWW1DrVWxC6W+wAS80ZN2fSJ09jrrq5EY3CCcjvnP6cgP8MkZYHXIX+BPZseR+tcVsfXLfjGYdXtFboA3j/p3VvRTr8Fauo8bfXsT5qW6JeZ+n+7NccQ3ZZFAy1aufBqlz9ytsZecArjGDNhWLkWOoPAhLmv8KVhBO30hSv0GTV0BDWfzbVvkBtnvw+cH3csV49CJ6UeI6XHITU+MH7bEE3/41LJWI/uI7XlZvTvkU8MBKbcCfsb60bH7g2WXLn64/I4oQy+/P0n6Np+6EOg3II4bu3gvEtDUFFt96gwL911SBpuXlWK6J07wJ9XhE3d4iIY986WRMQ5XBFTsigyk7kagY5gAmHzuSpzMjTkRALrzH/SXvQyPDe63UeN2gOSJ2B+2RAHYBvHzRIr6KuZI+6SBwQKv7tBf1K0FIXGRCEx0T05SrU5Fs2eAPLFf4GfA6VH+pB0BOtTzP5b/RutwBvvq6FXVdnDrze0jwdJuCZsXMtScM8zO321+BNmt6rzD9j6txcjblTP2drlChwC+p
 FdUJtxy4
 su8BMyw3ynrRoPfbknP5pJELsDOjE4bBxRXbx5q5eu9lyXXmaffK1vAX9hbOnkNtD82qfoggbMKdNUS37YOJ/STGpoCjSoTyp6HVj/cnybzL2kSUeb6hKSTY8/O1gJ0v8yhDsot7Pu+d4AZ6BPkMM6XhABjc0VJ1Ylc8PqJBgGe78dbIcNTymRzQiE5rPLCwGOixvofNcomlEvrhV0q2G0CJkf1ZmhqAo5ZLzTEU/p3/BTe5bgBKlN9wBTsL6U33HdyAKE1Dv6i15ezmB8tvDu9pzgDxeX5htUTOCLN5DeRPa3OcqOFK9oaZVlsv9yJTGCYybeW3XjVaC+48gNL7fOnpKtv7fBpFF3SdGJ/ype+K4/++KHuL5164Et8iznjYAsBoBLZLKxNsF30A738K7j6GEXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 12:44, Lorenzo Stoakes wrote:
> -cc wrong email
> 
> On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>>
>>   * re-validate pmd entry after PTL
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>>
>> But for device-private pmd, we just return after pmd_lock().
>>
>> This may return improper entry, e.g. if we are looking for a migration
>> entry, device-private entry could still be returned, which leads to data
>> corruption.
> 
> I don't thik this is quite clear?
> 
> How about:
> 
> 	If a softleaf entry is present, the existing code simply acquires the
> 	PMD lock and returns success even if PVMW_MIGRATION is set (indicating a
> 	migration entry is sought), meaning that the caller can incorrectly
> 	interpret the entry as something it is not, causing data corruption.
> 
>>
>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
>>
>> While at it, it cleanups the pmd entry handling in page_vma_mapped_walk().
>>
>>   * Instead of handling trans huge/migration entry/device private entry
>>     in a mixed manner, we put each case into its own if condition and
>>     handle with the same pattern.
>>   * Also we grab PTL and make sure pmd is not changed under us after
>>     above check instead of do the check with PTL hold.
>>   * restart the process if pmd is changed under us
> 
> You're doing quite a bit for a fix and you're putting it all in one place.
> 
> How about do the fix as 1 patch, and then cleanups as other ones? It helps with
> review too :)
> 
> It's a general rule of thumb that if you do more than one of moving, refactoring
> or changing code, to do them as separate patches so a reviewer/somebody
> bisecting can clearly separate each.
> 
> Also PLEASE do not add new functionality (this lock recheck) in a fixes
> patch. We'll end up backporting new logic that way.
> 
> Make the fixes bit _minimal_.

To be fair, I asked for this

https://lore.kernel.org/all/2d48ef0d-1110-4a9d-adcb-f701a1ce2cfa@kernel.org/

But given that Wei mostly used my quick draft without properly checking the
implications, yeah, let's fix it first separately.

I can then follow up with a proper cleanup.

> 
> I think in general Andrew prefers separate fixes patches so I'd just make the
> _minimal_ change that fixes this for the backport, and the cleanup stuff as a
> separate series.
> 

The issue is that the existing handling is just crap, and to fix it, we're
adding more crap. But yeah, let's add more crap first before we clean it up
properly.


-- 
Cheers,

David

