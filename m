Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59519CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7068E000B; Mon, 22 Sep 2025 05:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEA18E0001; Mon, 22 Sep 2025 05:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4D78E000B; Mon, 22 Sep 2025 05:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89A1A8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:37:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CD2C1605B9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:37:38 +0000 (UTC)
X-FDA: 83916383796.12.22DFF2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97C29A000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:37:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opOEENje;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758533856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jr3uIB6H0PHcPKKhvF1ntrfDmn1EveRwwMEDNWfiB+Y=;
	b=1RNT2vqvDy9ULs3r6w+s1MGJT7t70uWRMEhXNlqFXpUQgt906Jt62Rh+psxpy2nqfDgCfS
	qpuJvUeklpa+VyTDk+PdeLKl7STmf0JpKUdPD+6DMtedi7neRm5MGkoeA8un63H9W0G2fN
	y+M6EDvyEc0jZ4ZylWlkDyiMmZK8/U8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758533856; a=rsa-sha256;
	cv=none;
	b=xPKUX8//JPkeMDZhlXI4k9qmwde3I+hF73elWScNhm7A7MD1rL3OrNU1AqfffZ5Wb8EWI9
	0ynJ3kHFniy7vKOKNl6aSQ14o+Do54qCDfNqewkkXbnRK6vhJCQo7VUJ6+3KO7VgbQSHHV
	aANgHX8kB92AJaZhDK1p+jZPc55MB4A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opOEENje;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0E4A60228;
	Mon, 22 Sep 2025 09:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36686C116C6;
	Mon, 22 Sep 2025 09:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758533855;
	bh=HJeRlZPOw7nZfv+kvN8nLxEbf6fepYdAIw5OELv5WXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opOEENjeoa+WRCjaQYZI0+QpNEPEx/5t5AIIOlliY6yOqKP9duG1BEy1tbWtVFiL9
	 +6KAMpfNB69MiKvtnHC3OMRb8Gpl+Osx+ZNzjDK6aclg+1dSpOEne6SMBtGjCXd4Nm
	 cC/XS5mfTHdd2kHhnvFL1C751yxmQLu9jNjCei9dljtIbUnvSC5WthyNW1vRxHAdOL
	 zpy7QXcmDr4ZqYta3HelJi/BPBKfUtLJLueX2B0pTSz5OOjX4K3+K3IZPWVIF8LLn3
	 BTSo6HZ6IOHKf0r2WLrV/MPakaHFwRXSaDO4btjksvx/LtQHAs8Isea88ICaERmwzw
	 iAx4OHRMdWc3Q==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	xu.xin16@zte.com.cn,
	linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Mon, 22 Sep 2025 02:37:33 -0700
Message-Id: <20250922093733.57991-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250922002834.vz6ntj36e75ehkyp@master>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rzzjhxrh4wc8u1sbnatekqm6kk4jj5e1
X-Rspam-User: 
X-Rspamd-Queue-Id: 97C29A000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758533856-493331
X-HE-Meta: U2FsdGVkX1/wpeMM57M+FK9clYVwmZ8SSqvOUm4w0baxbrcQR0T7SzK4qU+NngE/L4WuEXJzCRhL/WNwqr+p5RQT9b50t66E2kp5vGqH8WOwJqa2BhPJ7PWgQyMkuDH4AMCu155UQq/vD8wPT1HZfjKnTkTanPg//B7rFe58XXw2nC85cN/ljdITx95SvvfnmRSYnnUyATqvHHMrvvoCq+8eyCx6YFq45AJMotvgE4YTs3nu+/XfwdmdRhwon1V2FavRlvFm8LW+r5jp7T8oO8boILLBH1R1KccfXwEBn1DGdtZITx2Ngj2+1BqeUulh8PDMZrpCdpw7a4MLwknKYmYypMh1WpdkycC4XWiK5lTx/9MRi8Hn/0yLZcG/bThhum1SDU/aEQ53d6/7SJ+lyKycus2CZWaLoqy7/ENNhqCFDvYBWO9PFK31s7qjAvsK/KpJ4UxW0vFZYkFsLt9Apqyuk5Up+TIZxPp4wdDXi7Iww5uphWqOSekcr4Z9atw1Rtbkx3XSlWbNtJTWIVyA1lUxEJtTIwBwi7/NEHk1ROKwnjK1js4wZlKH5dIS5XLlYC/DnivYdUVd7elG1U4c3GSSku4z6VaTFJyJu4NlAO2bZRrySPQ8Hwial01hVU6CkOZ93yFVxYPpY95U6Jx51NPhDTQiqxinMBk0snxLEeU3zmNc/CX8Lls4Z5GnMh82ryXFESHvqafy+RI5iNE04AMVvwJ22HvW/iOYwizE54dXMy7tFhNO2u6v96zGEzBL2GfLFrNr7bPvJ0NnvC3gSNZ+7gP41+I9o5kEcaR0gU4/K3ZURHlY+xi+91NRLaqELMmPH89gJqbYPWKtNNostc+rihQs82YZQTH/Wp1qqlNX/94C+qOOnbe6qesfTw7ZW7tI3RKhvA5jND8bddN7km9ddbBWLmM87IjA9Q8o4dreIKcy0A3fEhHxUVZ8lNGoz0X2Ltu89Rd229V6h3L
 /TdaLpYM
 pdtnlXVMC8d6avQ4SdxFaDjo/XMuEH0DJvkwGOr24GQX+GxO8m+/63Hvr91xsFMH29lBeUL4Wp2nh23VDod4LJNfiajlUj09kwNIKJUCFQ5zrO5QCVG6qRSz8DXZPxV2GWlTrGKSDLxy6YrL2zSCbPR9HdR9VahMoYct9+3vT+AswaFFZEC1GxLU4pFR+GrhkL7HFSBsA+gjpQ9miw6jZYXqGK3MWL5WrQpH88wVLIXFcTEtOVQ+44JFFpxjMNEzUX9KUBoSyMt5jEowzmQgM+36ilpNAUcXuBql5HloUllHhqm08eI+Y7fe6HN+ye7y6H06nKNqCpQZ5Fz8ngX2g5eyY/w187dEk9BIw0xWhEk86zz/N87FL4q8lOjqAb204ZM9/lkncC3q56kpXHDrA6JCVSZ9PXr6643i9CTIAQy9ft2kD/NFqGprvhNehCvG07CNkIBkWemiPPXc3Ad/cdD6y/0IwONbWOhtAsJRN14WEKpeI9R12ntBW8L3XQIfHo04015EjaiQBUyfVu04b65Pt4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 00:28:34 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> On Mon, Sep 22, 2025 at 12:07:32AM +0800, Lance Yang wrote:
> >Good catch!
> >
> >Looking at the crash report, this seems like a use-after-free bug
> >introduced in khugepaged_scan_mm_slot(). See below please.
> >
> >On 2025/9/20 19:52, SeongJae Park wrote:
> >> Hello,
> >> 
> >> On Fri, 19 Sep 2025 07:12:44 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> >> 
> >> > Current code is not correct to get struct khugepaged_mm_slot by
> >> > mm_slot_entry() without checking mm_slot is !NULL. There is no problem
> >> > reported since slot is the first element of struct khugepaged_mm_slot.
> >> > 
> >> > While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
> >> > there is no need to define it.
> >> > 
> >> > Remove the definition of struct khugepaged_mm_slot, so there is not
> >> > chance to miss use mm_slot_entry().
> >> > 
> >> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >> > Cc: Lance Yang <lance.yang@linux.dev>
> >> > Cc: David Hildenbrand <david@redhat.com>
> >> > Cc: Dev Jain <dev.jain@arm.com>
> >> > Cc: Kiryl Shutsemau <kirill@shutemov.name>
> >> > Cc: xu.xin16@zte.com.cn
> >> > ---
> >> >   mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
> >> >   1 file changed, 21 insertions(+), 36 deletions(-)
> >> > 
> >> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> > index e019ea2cbab0..88ea92c64bf0 100644
> >> > --- a/mm/khugepaged.c
> >> > +++ b/mm/khugepaged.c
> >> [...]
> >> > @@ -2376,7 +2365,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> >   	__acquires(&khugepaged_mm_lock)
> >> >   {
> >> >   	struct vma_iterator vmi;
> >> > -	struct khugepaged_mm_slot *mm_slot;
> >> >   	struct mm_slot *slot;
> >> >   	struct mm_struct *mm;
> >> >   	struct vm_area_struct *vma;
> >> > @@ -2387,14 +2375,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> >   	*result = SCAN_FAIL;
> >> >   	if (khugepaged_scan.mm_slot) {
> >> > -		mm_slot = khugepaged_scan.mm_slot;
> >> > -		slot = &mm_slot->slot;
> >> > +		slot = khugepaged_scan.mm_slot;
> >> >   	} else {
> >> >   		slot = list_first_entry(&khugepaged_scan.mm_head,
> >> >   				     struct mm_slot, mm_node);
> >> > -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> >> >   		khugepaged_scan.address = 0;
> >> > -		khugepaged_scan.mm_slot = mm_slot;
> >> > +		khugepaged_scan.mm_slot = slot;
> >> >   	}
> >> >   	spin_unlock(&khugepaged_mm_lock);
> >> > @@ -2492,7 +2478,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> >   breakouterloop_mmap_lock:
> >> >   	spin_lock(&khugepaged_mm_lock);
> >> > -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
> >> > +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
> >> >   	/*
> >> >   	 * Release the current mm_slot if this mm is about to die, or
> >> >   	 * if we scanned all vmas of this mm.
> >> > @@ -2505,15 +2491,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> >> >   		 */
> >> >   		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> >> >   			slot = list_next_entry(slot, mm_node);
> >
> >In the original code, we used two distinct local variables.
> >
> >1) struct khugepaged_mm_slot *mm_slot:
> >mm_slot consistently pointed to the item being processed in the
> >current call.
> >
> >2) struct mm_slot *slot:
> >The local slot pointer could be advanced to the next item.
> >
> >> > -			khugepaged_scan.mm_slot =
> >> > -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> >> > +			khugepaged_scan.mm_slot = slot;
> >> >   			khugepaged_scan.address = 0;
> >> >   		} else {
> >> >   			khugepaged_scan.mm_slot = NULL;
> >> >   			khugepaged_full_scans++;
> >> >   		}
> >> > -		collect_mm_slot(mm_slot);
> >
> >At the end, collect_mm_slot(mm_slot) correctly operated on the
> >original item for that scan.
> >
> >> > +		collect_mm_slot(slot);
> >
> >However, this patch merges these two into a single slot variable.
> >
> >When slot = list_next_entry(slot, mm_node); is called, the slot
> >pointer is updated to the next item.
> >
> 
> Oops, you are right. Thanks for spotting it.
> 
> @SeongJae, would you mind applying this change and try again?
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d28d1116e83f..fb517b5ad277 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2508,8 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>                  * mm_slot not pointing to the exiting mm.
>                  */
>                 if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> -                       slot = list_next_entry(slot, mm_node);
> -                       khugepaged_scan.mm_slot = slot;
> +                       khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>                         khugepaged_scan.address = 0;
>                 } else {
>                         khugepaged_scan.mm_slot = NULL;

Thank you for the investigation and the fix, Lance and Wei!  I just found the
above change makes my repro quiet.  I didn't have time to read the
investigation and your fix thoroughly, and my repro is not stable, though.


Thanks,
SJ

[...]

