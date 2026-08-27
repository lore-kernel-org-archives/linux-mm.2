Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1838AC61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2336B008C; Wed, 26 Aug 2026 22:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9036B0092; Wed, 26 Aug 2026 22:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0536B0095; Wed, 26 Aug 2026 22:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD7F96B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:48:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 572BDA3992
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:48:03 +0000 (UTC)
X-FDA: 85145514846.27.4656BF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7ACA7160002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:48:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=15yFLZOn;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787798881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6ZWZ4mnze1+TrAWnC1NwqdFLlt5leWgM68OC2nnBwk=;
	b=l1bPH7xTlVizENoIbDQhdyC1nxiM07tuLj31m1Hxl9EYTYbc57AVGfeBpScejA1d0VmowK
	dyvlA7rM/aRyQAXIsgOEVr858lQzCnQqksGrPvWp1JpkH8hTcwwjz7+2ZF/tGoD/zREHUt
	oSTtsJHrxAjSW/b5J/99FUUc+4T0sh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787798881;
	b=4vM0ymtgBASHC3KvpUrwiw652uoyWrAzxDye+ipYUFa2EDBKyOrVPMEpn6QbQjLknNe4aR
	oZtCUVgcz7RFuP+WQC3kSnSArt+SLcg497/lPp82J6U66mk4BX/5L2Ga23FqJc87Pe9VEv
	XQx7mQzYUHiXOQqfbwGeUxuI72Xlh7k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=15yFLZOn;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ADE8436F2;
	Thu, 27 Aug 2026 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4581F000E9;
	Thu, 27 Aug 2026 02:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787798880;
	bh=o6ZWZ4mnze1+TrAWnC1NwqdFLlt5leWgM68OC2nnBwk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=15yFLZOn+kXLxVcliUfnTug4xm+hRx2/BH3WZyMFH2Al0IreNPyG4PdoKEWzJdKT/
	 g+5wT+tzanMat/qnV1LX/Y/JHiI7lukHDMZkP7ryzp9k6sSZMnw02ca/Sq8FQ0SgnS
	 KmNPPVhUs7kA0irKvJPFD/u0n/o+9re3picuLWag=
Date: Wed, 26 Aug 2026 19:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 steven.sistare@oracle.com, vivek.kasireddy@intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/hugetlb: fix resv_huge_pages double decrement in
 memfd error path
Message-Id: <20260826194759.88487180eebf728c1df08f14@linux-foundation.org>
In-Reply-To: <20260825021013.25672-1-hongfu.li@linux.dev>
References: <20260825021013.25672-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7ACA7160002
X-Stat-Signature: 8ak9f7e5rpzrhjm34u3jmqfdrqpfr1is
X-Rspam-User: 
X-HE-Tag: 1787798881-919335
X-HE-Meta: U2FsdGVkX1/+3PL4d+2Rtx+LdpCOlRxUBx55Uvs/aybhNmms00kSbVw60woDc6h8HWOwJ2JLK0v4zgUwKkIwsVT01CRIB1DvYdeUgS0HkxMJJNJVJvpw2ngeEvWLJXrlk04WS56y02eXz/06QsVo4nubIWtuukJjaREomVl9BXahao/k72CMIKe91rbx78sh02pM6sRcloUuZ7iw9jsGmky/HvUQ1Mgnoe7QABcMztLf3g4Q6Fo7ditiT1f/pL4zR/1uk7Y8C4nV6XytjdDV9UjpXJJDuZB3BBAUk0KWngXR/GHaXBU+bxLYdKIXW3TF7n9u4e8zHNAhq6wowM6uBKU9RQjfZbEv6LCYYvXDwu3gjEssxJacPfkIe+tgXuXl1eFiuqsVqiRyZYILizQuHvP1VbsUd9U65549QY+MjAeTH/s0+BCGguwKumJInYoSey/CDaczRKxKyu6OhiIMhX2kyqIE++IrIETXBNBKKq7emEYOHR+K/O8Bx78fMwQf2RmGlq9CObUw+rJGbqoa7EU2mAMdn1JHQbVvM12LqLtZAunzR8PbfVfUZCkbaIpVrQmMzOLcFlRn/tz+J72K/p277K4UA1W/WxiTr49cSys+TNKPuBrIKQd8fo6zX59TGL2zee3KO2RK3VVqFt2fY7fL2KrlBs7iMbhqxKYBW99yaKTtGeyf5cchayHBCzf9SI15anwhwJg3YBi0eQgZ9ObjYtTinipRKGouabRpXvsyEupsI/z3wu3BHVjlTtxBBGO0WRxxOtDp9X6pufle9WfBN8kMke/RKkzCasXXQ+IEqUUdYiRFRWJalVXvBJYbp2cc+WxIeqvu9nyYdoMIGVONlo9DEvzvogBKIxP5uOZkAXWLD/36TYOpJkzzZTSsG11LMesAlX66mVf7n55XSKSD6Fong/bwEHtkq1ut83w7mNABGcQ283af23tx0+LVlB2gTUryy4VtjL4cD3Z
 ZNOTMPSn
 TelJWOkEXjYyMIFScvjQ7NDjIMRNirar8NEBL3Omhdgk8pWYP4qV0aQngA6ownQrcRly79A7bDxQvIO9LLjdnleeP9EPHlyfRIg4R+nq4pDKSqtj2LDRK22fRDZShzqwsXf1pk/LiOckpaQGOW90KtmeABdNwTVJtvpAXSxdMLb0gO1fvoCpGlD6VG033bW+ZXbVZRQUIfQug5hOBCVD5klxSDqWk8W1ogLVswjA6VnQ2p07VGiMXkrvLWqu9tY7kpuj6y4PjUHHOR+t1gwuwrYjqUEOn2NUA7vh4ci3xS5C+ela0s1c8rGmkCRv2h92jX61hDz+U7XB5oIzofEDtt/UtmOK1Iq/8/pEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 10:10:13 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when
> dequeuing a folio, but unlike the use_global_reservation handling in
> hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the folio.
> 
> Its sole caller memfd_alloc_folio() pre-allocates a reservation via
> hugetlb_reserve_pages() before allocating. When hugetlb_add_to_page_cache()
> fails, folio_put() drops the folio without HPageRestoreReserve set, so
> free_huge_folio() does not restore the reservation. The subsequent
> hugetlb_unreserve_pages() on the err_unresv path decrements the counter
> a second time, leaving resv_huge_pages off by one for every failed
> allocation.
> 
> Set HPageRestoreReserve when consuming the reservation in
> alloc_hugetlb_folio_reserve(). On the error path, free_huge_folio() then
> restores the reservation before hugetlb_unreserve_pages() releases it.
> The success path is unaffected, as hugetlb_add_to_page_cache() clears
> the flag once the folio is added to the page cache.
>
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2178,8 +2178,10 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>  
>  	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
>  					       nmask);
> -	if (folio)
> +	if (folio) {
> +		folio_set_hugetlb_restore_reserve(folio);
>  		h->resv_huge_pages--;
> +	}
>  
>  	spin_unlock_irq(&hugetlb_lock);
>  	return folio;

Thanks.  I pasted an AI-generated test case which might demonstrate
this bug.  Requires fault-injection so I won't add cc:stable.


Also, Sashiko might have found an accounting issue in the nearby code
(Sashiko doesn't like hugetlb.c):

	https://sashiko.dev/#/patchset/20260825021013.25672-1-hongfu.li@linux.dev




#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <linux/memfd.h>

/* Read resv_hugepages from sysfs */
static long get_resv_hugepages(void) {
    FILE *f = fopen("/sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages", "r");
    if (!f) return -1;
    long val = -1;
    fscanf(f, "%ld", &val);
    fclose(f);
    return val;
}

int main(void) {
    long orig_resv = get_resv_hugepages();
    printf("[1] Initial resv_hugepages: %ld\n", orig_resv);

    /* Enable fail_function for hugetlb_add_to_page_cache via debugfs */
    system("echo hugetlb_add_to_page_cache > /sys/kernel/debug/fail_function/inject");
    system("echo 100 > /sys/kernel/debug/fail_function/probability");

    /* Create memfd and attempt write to allocate hugetlb folio */
    int fd = memfd_create("test_memfd", MFD_HUGETLB);
    if (fd >= 0) {
        /* Force allocation path which triggers memfd_alloc_folio() */
        ftruncate(fd, 2 * 1024 * 1024);
        write(fd, "a", 1); 
        close(fd);
    }

    /* Disable error injection */
    system("echo > /sys/kernel/debug/fail_function/inject");

    long post_resv = get_resv_hugepages();
    printf("[2] Post-failure resv_hugepages: %ld\n", post_resv);

    if (post_resv < orig_resv) {
        printf("[!] BUG DEMONSTRATED: resv_hugepages double-decremented by %ld!\n", 
               orig_resv - post_resv);
    }

    return 0;
}

