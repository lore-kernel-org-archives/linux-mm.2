Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467D4C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B966B00A1; Thu, 31 Jul 2025 10:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33426B00A2; Thu, 31 Jul 2025 10:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76D96B00A4; Thu, 31 Jul 2025 10:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9C926B00A1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:08:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 749E911459C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:08:00 +0000 (UTC)
X-FDA: 83724738720.13.E4200B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E317E40003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:07:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCB+20pL;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753970878; a=rsa-sha256;
	cv=none;
	b=J1ugy8KPy2rzVBZU3Xwz9y0lWDtxEKFSi+r+7ZanvCdR/3LPJgDCya7LX1tMHr4OG9mboM
	1bxpTa7AjVs/fe7ZmaEeZZ6puRVIV80OYoKLJLLLqRyjBh+hPiMvRYpPJYzEWTiR76GreO
	VMzsPgnyoXCPtpmLcCrvpt+hbXm7J/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCB+20pL;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753970878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbc2DrbSiTTrIoXJHAByMM0irL2veEFJckB7Em01Ui8=;
	b=ZZ45Ph0AzJakzqEmInrRtXXMeQ42Ls/S9QsE0rNCJdmosUj9ON02ikOdSncQzN4wG+TdNY
	COfH5ZQaQhE2FVQVq6Dzz7YmtzFrRIaHE8hx2UA0uYQlUzFBdn30Lnp2dEqrK4HmbduFQ6
	YZ4nLmNvl6sdt3rsv4Zyy92KBdrKkps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5065960205;
	Thu, 31 Jul 2025 14:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B976DC4CEEF;
	Thu, 31 Jul 2025 14:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753970878;
	bh=dq5v2NDF3NTRtANE3dKDajFM0GfR/3q7L6e1ofIf3dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCB+20pLYf9de5+XuKmJN597tlHYk3SXSPXruYkgcuGXvBQ5M5VQOyU56QTHQ5KM+
	 HEwTLIxFDryUryR0B+omPc2kRsk33/7dZ8EGT06//n2wcsYRxVtw2J0L2o81O9DNdP
	 9fVfsQPmnhG3JwEreQhmF+Ad6aMQPLYtr+39Elp3bQGmbUFIdRC7/F+G9f+aqwYiyP
	 d2aNPFEFo2fxl/VwhoxfU+NttTsel6X+t8he1mOqp1SidVub23BKmykTc9KxJ6x8h7
	 d28B2ZnzqzkCaiMKEsJ6tnDwjVXra0AYh/vz6goGBEjvPzifmtxCLOW43uFsQS6o3v
	 5ErJTtCfB9W+A==
Date: Thu, 31 Jul 2025 10:07:55 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aIt4u9gzwGOtjXPi@lappy>
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
 <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E317E40003
X-Stat-Signature: p3s3h8gja7hdpboxjwq6f7beb7j6bzag
X-HE-Tag: 1753970878-844405
X-HE-Meta: U2FsdGVkX1/3XW7cRY7MrI0ern0IOvoMOq8hvnEnfV7bSMN/TTSyuQ1RIMF74gOwEEPUZRQBLubNNz2rPPINS+H4DdzzLAPPlfBpcL3p3Hf7mG2WINPdZlaipp4ByQzTNzeb1u/9/lP3fByFdUQz3KgTvJUHM3l81kfvsSWPFpUFk0x21JrkaXwTlpym8TN6KG8/08LLUcBtlj0waxZXotDJXfGp7dvNOzPvDb7Vv2wtrJ00T3P+IHjm2oeblsCMqqJjP8EXb2JzSt8h0Tlmv77bqASH40A/r7a1JRJQVm0MbE4RW6OlguO3pzLGU6E6LCY73kYj8oe9UNoLsGTN7ztZhSNR7+I+TeQ80vx1+Yf3bFaGfMq0JI7rN9NBoxIVttTAiWF49o+ylICgpl3NlZEODABhw5lf7qj3ATaUetJamxMmvzySzmMgn2OTg288aovgnFI7pslWv+KmOAgxv4utM+SJ7HdcJMawizgImeFJzbMHEj5R8YM6Os81gGnsCsbAmaMvmESq4ShYAOVhjuj4xbBJVhyvGjunPCZy2smmRJ8tERj9NBg7oUW+9OuuGayVIiWnb5YXwLiiFloN+OVO43rqYyUNmY6vTMPoj4p/9OgJolECf72yAfkNC/IQ85p1iqggSErcQD4HzszEeZrRLd52TE9BwuoSu22lwRWLpNNOY3INnbZrZ7hOVRHqgqaI+DnTRBi7CICrbkepKUnqXwgwWukdb7I7zNA9y34Bh2t1aKG1nQKfkXObJIXQ5//M0d/lP4v6lVhNwUzQUEpoF2mE4txSDmz4/+42wfbqYOArJnGnnbfNFfwulEeRyTk5l/pemdaZOLgFvMOBoOFR3EgMAu07En1tmDydWjnY5JWckqf76g3yLBmpUBBHPturwAeosPW5YaTRe/nXdeWsywV4tdH/2uisHNAlnNJZe+A9vJ+L5WPNJ3aMJwVhoy5GLdgiORnxqeQ7kAe
 kBoajaUs
 A2RwLQUtQd5AWkakdFdqaRDqab8MPS3lOqQEfr5s3wfUyNvGAkAEvuBuijf/vOGRPTVOF36s1R7I3lhQ2HBwhLCDbYrrqyz8NLzvJQdxUtL5rdFsX8+/tRV2szuxfOYwS8IlrEnPpOGxfTsu93/MC5MvcomIABAKAqcXiiWGddvJK2p9C3OwMzCiaidAi4ctdH1Qgbva9wVTVWjgJ0pgvbRQsmbl3o0jnK0ybXYJ5knu3TcdJLwV7boLKeqMaPsvJF0+xqseFsmXiRifcE5rIPAIz+VGE1mFJ8je+TpGVH8idLfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 02:56:25PM +0200, David Hildenbrand wrote:
>On 31.07.25 14:37, Sasha Levin wrote:
>>On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>>>On 08.07.25 17:33, Sasha Levin wrote:
>>>>On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>>>On 01.07.25 02:57, Andrew Morton wrote:
>>>>>>On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>>>
>>>>>>>When handling non-swap entries in move_pages_pte(), the error handling
>>>>>>>for entries that are NOT migration entries fails to unmap the page table
>>>>>>>entries before jumping to the error handling label.
>>>>>>>
>>>>>>>This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>>>triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>>>corrupted.
>>>>>>>
>>>>>>>Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>>>   WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>>>   Call trace:
>>>>>>>     kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>>>     move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>>>     userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>>>
>>>>>>>The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>>>frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>>>PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>>>path more commonly executed during userfaultfd operations.
>>>>>>>
>>>>>>>Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>>>paths before jumping to the error handling label, not just for migration
>>>>>>>entries.
>>>>>>
>>>>>>I don't get it.
>>>>>>
>>>>>>>--- a/mm/userfaultfd.c
>>>>>>>+++ b/mm/userfaultfd.c
>>>>>>>@@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>>>  		entry = pte_to_swp_entry(orig_src_pte);
>>>>>>>  		if (non_swap_entry(entry)) {
>>>>>>>+			pte_unmap(src_pte);
>>>>>>>+			pte_unmap(dst_pte);
>>>>>>>+			src_pte = dst_pte = NULL;
>>>>>>>  			if (is_migration_entry(entry)) {
>>>>>>>-				pte_unmap(src_pte);
>>>>>>>-				pte_unmap(dst_pte);
>>>>>>>-				src_pte = dst_pte = NULL;
>>>>>>>  				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>>>  				err = -EAGAIN;
>>>>>>>-			} else
>>>>>>>+			} else {
>>>>>>>  				err = -EFAULT;
>>>>>>>+			}
>>>>>>>  			goto out;
>>>>>>
>>>>>>where we have
>>>>>>
>>>>>>out:
>>>>>>	...
>>>>>>	if (dst_pte)
>>>>>>		pte_unmap(dst_pte);
>>>>>>	if (src_pte)
>>>>>>		pte_unmap(src_pte);
>>>>>
>>>>>AI slop?
>>>>
>>>>Nah, this one is sadly all me :(
>>>
>>>Haha, sorry :P
>>
>>So as I was getting nowhere with this, I asked AI to help me :)
>>
>>If you're not interested in reading LLM generated code, feel free to
>>stop reading now...
>>
>>After it went over the logs, and a few prompts to point it the right
>>way, it ended up generating a patch (below) that made sense, and fixed
>>the warning that LKFT was being able to trigger.
>>
>>If anyone who's more familiar with the code than me (and the AI) agrees
>>with the patch and ways to throw their Reviewed-by, I'll send out the
>>patch.
>
>Seems to check out for me. In particular, out pte_unmap() everywhere 
>else in that function (and mremap.c:move_ptes) are ordered properly.
>
>Even if it would not fix the issue, it would be a cleanup :)
>
>Acked-by: David Hildenbrand <david@redhat.com>

Thanks for the review!

I'll send this patch out properly.

-- 
Thanks,
Sasha

