Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56922C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 13:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3DE6B007B; Fri,  1 Aug 2025 09:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A748C6B0088; Fri,  1 Aug 2025 09:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AAB6B008A; Fri,  1 Aug 2025 09:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89B336B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:26:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 318E81D83BC
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:26:44 +0000 (UTC)
X-FDA: 83728263528.01.237919B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 912A6C000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:26:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y6GzlzgU;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754054802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/OkpUD2gi07FWQy6VRSHUoBC6nEFv19smz4bceTDao=;
	b=lon+n/vXs7zCRiIFtd4HYqlmnejsKzW2Tbfv24fVCQZctr370NOam+l7ti6h3X1p/QFqWp
	DkD0KB6F+c0L6INNx53YJKwuq0eWIeYSfyH8zIpAgz2QUQN+yUbERcCpkofzL9hrCHLYHe
	IOV7zLUAUhS/U+6m1HfMVJRwtjcV+cc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754054802; a=rsa-sha256;
	cv=none;
	b=4LiAep2Mv40rYY1d2vV1vvIzkTKPdVwVk190LHTDA6I7pnwSSlf7b3OFy4Cw+cRnl600j8
	ZqMCUouUIzMnhKFeljCnvUD+hJukETPv221z+J1e0gIiVyIrooIjPTs5/IdJ/82n2XILxt
	B8GUNAOeoglqtkXsu7BNlB62IugidTQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y6GzlzgU;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id CF858A55849;
	Fri,  1 Aug 2025 13:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F080C4CEF6;
	Fri,  1 Aug 2025 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754054801;
	bh=/ZS8Ia0VupnzJGFGSAG2VKydIIX0xcJaBtsknSGclrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y6GzlzgUA0rcyWqKvroZW0tg8EN52RnGrzprPaOd0jOC+Dvw5E267dFvhKU1xZqBh
	 mMVACQx1kqstD1LAdN7d8bkiAWPjXO7JIRX3zOEkXUwLmuDiLw8Og2mDOcF63b3Ldh
	 iiFIa+ZTRZn4LW9upGOuC2WteE5mKqeWde9dxFDzPzHrvuXESWq23CKygGrQO8aG8B
	 suLa4C7Vqdx14fmIKI75doF0XZQn+cPZrMWiCp+PqpKBpBm/9eEGg5x3wtKjGf/gnB
	 mEWU/daa8yenSITT6K2vVxt0P6ifhKxHDBbCa7NXLpAAfAyMyTUZepQn/6PeVFm1Bs
	 219dGjfygNTKw==
Date: Fri, 1 Aug 2025 09:26:39 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aIzAj9xUOPCsmZEG@lappy>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 912A6C000A
X-Stat-Signature: w9e6xnbu1fbitpk13rbrwh7pq8387mf6
X-Rspam-User: 
X-HE-Tag: 1754054802-318404
X-HE-Meta: U2FsdGVkX19KKA5gGxUYvJUbJk+7uPfYKrzwwX3tPk+t/u56+o7q37j/SP5Kic3eLvRkT38vTb5iNGYOvSni2nfvqdt0EUtC6XH+TUqWR9dtVuUQuZOJSCT8Ak3sVS99g2ox92ZdLqHBgS5qZ9WYcOapkTj2neKWQ5i1zXzVai41szSNMQWDmx1S+EwLPM23XLRRW6+j/Z8vdYUfquAP23BtCcTdBTYn2mdrQyVdGFxPAp7XjOzIwAwyMf1IpmIpGSzNX34+cfmF9m9XqYu3ywhE6nbcDWE7XLKk5GG1JtZCQOqScL6G/XXQbWaBh9nngZHK3/3TUcpq1A51fX6rX92EPEnkO+f/0wI58zo+BGAV2NgqYlwQS4QLdQIzZBe/HWV8YZ10nci/Ra770BA7qMGkR7aXgtfS/oPhap81RO/MjsUBvkFL5RZ+MmF6J36Lpeb41P1lxrJPveGQQn1N1kREiMOMmcMJVsMBXH0gt8wgMophcRxIZ/ji+viKuiQSd9+YEl3be8WKM6Vo25YZk0fOR+6/8vSuXwVkNnc+mXbubvmxkcHnzOAZEM70WoUmvxyEtHz2ZP4Ia5oC47prRFJJ+pjTC3kkt/JlE1gOUuG4KYy1Vs9dkGbFQ9V5AL/zZ3rDcFAbeJF51BEouuWcIbSapJw9XNE0SpQhPJ6I6DeALd5yXqqTBTDiiWqe5ubPVn3NKaEXRB5waGrwqh7s8ALnxzvERbmmsiguayFiEUy+zy1s1RkVYrXFq+7UNN/gSSYPjf/CvMSTCMGnBhZ4jVmy78+rfIPugV6dtvOs1w7XCd416wBM7lgg4MzFfTA1r5ROIbTwACDMssBGQUxZI/1avY9evaRsSsxlSQLUyrnFEOMwF9Wkag7kU3HTcfARYlwO4HouaNP8J839rHBPyrI9WIs5e0EvB8vDPwOpLc6mjeW2dXFWGYTNt1qNsDZaz81im+gNdoU1rkr89LH
 bc84ttA3
 SYVetsTcN2cxpybxJGkFFjj0g7mucp0sOhBxcyx8jH5oomtLUJUjAge7d4/hsBjSxlAOPG2kog2bKacnzv1aPQb4oAZBt4pD0aux4+wTXw/Z3eT7aU5onRurRk9CBVqruNtfptUWVd/5WzkpR8jK879OcRw+xCEquW4BdIbDmqYaardtQ1Ojzxn2X8oiaC0XRLi6qEs0G3bzJk8gUhRfHspjfsY7kbY/qFm3a6uDMyGCVRoh8Y9W/jCZHEa7ekmV5aofxbADWH0BY6jFSfHcwiFZ3ICboVBMglo9TWEiD9CDioUI=
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

David, I ended up LLM generating a .cocci script to detect this type of
issues, and it ended up detecting a similar issue in
arch/loongarch/mm/init.c.

Would you be open to reviewing both the .cocci script as well as the
loongarch fix?

-- 
Thanks,
Sasha

