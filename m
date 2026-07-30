Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4EFC55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45C86B007B; Thu, 30 Jul 2026 18:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6306B008A; Thu, 30 Jul 2026 18:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C8C6B008C; Thu, 30 Jul 2026 18:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3016B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:01:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 185641C07DF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:01:20 +0000 (UTC)
X-FDA: 85046814720.29.9112F68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 17B86A001D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:01:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nYyYhBj8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785448878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BFJV6uQFbGn9LFU5AuqsdMUWFPna2C4fVGSZvBQfUw=;
	b=fKprN5pQ4w0oOB1+g3zXOcTLo1gjrswLYMtY7UcI8/os1lijNfzjyNURN5ezwVxereSzpU
	8EzFQaP7inK4ELcOomZi/+662vCNw1M0ZdbChHI8lCFgzZgCFDfYUCKb93O77ZujQ1P11n
	deeSr4Amu1dbO6nYDn8Kms5BA46/DJc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nYyYhBj8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785448878;
	b=402yg9ucNb1Fj3FO4PjyYthdGee8pTV2pgZyYy8chJVEnrG24cf57PbWjH1/cXZXiJzFJS
	adlQOyHufQjunqq3DLxiR5GJ+Sn8XrO6aDeiCdl3ltc2SBviB8ruxqtPiEEWNQBoUAC8Ll
	I3+eEGn6ImixRHEYsMYuajSQ8rIcwAw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A757F600BB;
	Thu, 30 Jul 2026 22:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3468B1F000E9;
	Thu, 30 Jul 2026 22:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785448876;
	bh=2BFJV6uQFbGn9LFU5AuqsdMUWFPna2C4fVGSZvBQfUw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nYyYhBj88aV/Fv4t3Hft6PLNTseVTZAcmjI4kuNuFh1GzQYPkdWIc/JvwnhoDl2n3
	 k7yYmoICC5hOA3efVV79+Es1/BQKBNmtjdf+jVm/vR/gIFT6jpY8nn9GCV8rC6EU5H
	 p7pTqGo7UI9PUiRKVl26M2A4bOuKTOLrxeGL5GCQ=
Date: Thu, 30 Jul 2026 15:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, Breno Leitao <leitao@debian.org>,
 muchun.song@linux.dev, Rik van Riel <riel@surriel.com>, david@kernel.org
Subject: Re: [PATCH v3] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-Id: <20260730150115.37de0d2306820eaf72834743@linux-foundation.org>
In-Reply-To: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
References: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17B86A001D
X-Rspam-User: 
X-Stat-Signature: cxaaadysmsfbz4b55as6bnf8zbjjf4ec
X-HE-Tag: 1785448877-990302
X-HE-Meta: U2FsdGVkX18sDloRoNbo6ziuLiskJU6AZNMQNsriNktVRf9dRiiQdEx7F/KcrLRcLeuNikCs1hNc8BKojOeeWtIlcGaH+43QAvdo4sWJCYux3UWc1bICkRsl5K6zWvBtFl4XdZk59O49zATOuSWFo33zgf9FNJSxDpDa+nNB4DeSd84tVter/jPKn937uqdyahj2nhAey96qXAXGMXUCa5mQQYVUo8EC4H7PEcDwiiLkMnKWQ7GImHY7RzscAhv6Upb4Zvh7+u5zF/n1DjribAcWug0QCqtqrkFIEFvauZiWS2cxThzKclXiGtPgd8y1g3dBVkQCn6N70eimOjN5Kzj+ArOdW+ZDBXfFqmUCGP253uvarFpD64t9TVjLRmWM0SlHvJrEpyohSdNvyZMzTPIiLvoGcimt98TKgEzi5chp15+O3BMCO5XI473oP2q4HnkDVV812BTDp/EPpVhUX1mC1XDtCje1rgXPKtNYJIeb6BTzLCBwVqFsKwXeF9k7xfNyigZsE31QYAOcv9x92q6ZxLp5gV4VwEZ+6N5sJ0RkRZOmR9qoJM24Zd2SUETLziPTmSDtzX39wR0ebWTfzCN7vYJON0WzfdM7fnWqn/RQbYpbbZQuv5ww+fIoA2Hd5DS5f0ncj6TIK5eklqC5Her/C91jzwubIyDuQ9rE2lQgl5IGJvV8rJksOZHn6gDXZ2pkqdcNBmnH5bZvim09bojOpbzcCE3Ur0+lmKc0rw24pKISzBZHI03bewWIenEPrE+KPSYWCT9NE4+CM/mV39ZwNbimQwjPLwEo05JxeF3EYY3PqrfZ+pIRj715cUsWWQN4YbJmAp1ZMngEpn1kouz9a9ZXFVf/jZWFFA0LSX2qOWGa3n38nRetJJ7AbKxV0LBJ2X6qITsxYng7RdlwCAmQssQcVAplBVCyLRxc+jXyJU5UbhhzQ9wOmumf8+psosY8RkMo+txcjActB8/
 WApcIYQO
 ypBH7uEOn3rLJbgkyCP3O0sAHHgq5rwEsbhAJzHupP14JHBFS70BR8EnpNXUZeckA34iUprYxUU2HSJeWPoG7S9PdAeBpFMHV2TTXLr+crvSjyK7tAZQ8qIYE+1kGe+gXnVqsXyMA4U9isDEZ+4t3DmQB/2n4tXCyWFxrFoCNCfoPbh7riaPqrrZ9gDzXpHu0AYyqtj+leBUU5Ly2nzcRbwQ7yyyByHX48IwGbnDvA6gC/6Y9OOJfDuy/wkvmfEqhqyz8R9u6RoA3ujDm+iMMGduNgmrnkOOeJgCKCTEYthfHsWhosDFAJttXlA4LPIoj1Fyr6mw9Dhzujbdkb9eq129+DhF4LANypHmajUU3yTOkVU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 21:29:03 +0200 Guillaume Morin <guillaume@morinfr.org> wrote:

> Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
> the case of folio mapped in both a parent and a child, if the parent
> unmaps the range first, the reservation adjustment will result in
> an underflow of the reserved count. Once the child unmaps the range, the
> count is restored.
> Change __unmap_hugepage_range() to check the mapcount before adjusting
> the reservation.

Thanks.  AI review mentions a couple of things, one pre-existing:
	https://sashiko.dev/#/patchset/amkC_1Ya6OiUoiLZ@bender.morinfr.org


> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5256,7 +5260,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  
>  		spin_lock_irq(&hugetlb_lock);
>  		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> -		    folio_test_anon(folio)) {
> +		    !folio_mapped(folio) && folio_test_anon(folio)) {
>  			folio_set_hugetlb_restore_reserve(folio);
>  			/* Reservation to be adjusted after the spin lock */

I assume that meant "after the spin_unlock".

What are the locking requirements for vma_add_reservation()
(__vma_reservation_common()), btw?

