Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3DEC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B6E6B0088; Thu,  6 Aug 2026 09:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC026B008A; Thu,  6 Aug 2026 09:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD20F6B0092; Thu,  6 Aug 2026 09:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1A206B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 231C314076F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:36:39 +0000 (UTC)
X-FDA: 85070944518.09.94A666E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76599100007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:36:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0K7nAtp;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023397;
	b=lJdtKrvSKwIBEl05HkuaKWCBnwHYJQFxJjt3sgSS9y4xip72Zzqf8rEDjFj1DNiZVu/lcF
	gCAxpVoqvvnN6rbXM6LF13NoUQHBKmvAZHtphTXmBomgu1J6dM5WwZ+CcKHxIs3Ycuq+mx
	sxyy2dOzbcHD63qUjQsSLpNPwK5DB8Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0K7nAtp;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQumHfwaY/YrSY76B6WqcEr/ChsXY+iPspGhZHQSCTc=;
	b=QzkgaC/VyORXohjyY7xc1JIkJwnpT27uk2fci9LkmQMmfb2KetJ/84xNLJwQmjx0zDxUg+
	3dRrwIcOYgkqsEBokZDJQnlO84u61ImPMg8+8VJ5CeIa0OEASGalrO1IHeKmzYUQ5U/XIs
	O3mLrJJ3XF/XOiQlgmKPybwJb4rEbFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC7CC40AF3;
	Thu,  6 Aug 2026 13:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C81F000E9;
	Thu,  6 Aug 2026 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023396;
	bh=GQumHfwaY/YrSY76B6WqcEr/ChsXY+iPspGhZHQSCTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H0K7nAtpciJ8wdGpR8lTTM2rX9eAPV7qsC2rrbl884CgU6DADjqsdkUjAzawChFHC
	 5kSxQV2of2YrG0KfB9MCpYcjFd5VOVB2LOdA8iQdu7e/6GJgWmEQqfWyjOKjccqFZp
	 bovA9je4hE1quNfTdUX7KMJ13AdCnWqumnsplnCng9D+FcacW5TJRPuMzdF38PBUQv
	 QUPftNKcPC2m/R5zeTNgNHYFPpc34cI49lirDgDsYucwNyLdN7uF793Y0VLIz5M1hQ
	 o1Gy+ljdRbEVN/QW3aCtSWZAAYuY+ZqHWUlDQQXkYhQivec7ujqlDpwzjTTxqWh+pX
	 6SpkRvoNZN3CQ==
Date: Thu, 6 Aug 2026 14:36:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	sj@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing
 folios
Message-ID: <anSNk7zgoGj62CWk@lucifer>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-5-gourry@gourry.net>
 <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org>
X-Rspamd-Queue-Id: 76599100007
X-Stat-Signature: 9wq8p71p7o71cy4suyt76iry1p4nehsk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786023397-595106
X-HE-Meta: U2FsdGVkX18SGdLeAe2i5R1zjs/GGETamVlIP3uIZ5rlHkMnKqgCb/PjVS3JvC5S1f/X5AeV5tte7R6Y8FuBD7kLi/zciFcrATRYjeSusWP7MbSMh/8PrYSCIBKasSW5FK3V+9f9ESvUhCDAbYzYOGWtYtMl1QKbxP21GilVqQdAYhXuFzUTsr6vJLex5JnvPzim67+hbh5si14o9Esm+I1a1eb9c+QYZlC6a2Q/2B9UE0slfElDiL6yA9TbEPZRyryttyNIu0GGFoz23oSsqSsC1UrLNhRineWT0WgIUlA1hXh9glECyw5Bzps28rHOvkJ8Y3j2vQFcc1TCNW3ZUQ6tzK8PAWYbfGauKpCHNUcIHhgJr61uLmxCkNtztpodaTToP/k3OeQ/dFolieRDqreSO+v9NYDH2oYnP3ioBFZBz1PWFly0hCzz0bSrLm3mNS6uvwK8b9c3UTvkLbnVSNuSswl3lYkKazQHPHzh8G/EszyUOjBgRMsf8dYxWeeyI+Olrjx8P8E1MrZdRfohyPLKSNvAMUq8gbn1kt4ZoL+pn6/elrIy5oxEKQua0Vkp1IonY9TEZ/4D4i5WYxYKUNCVUgzdhtnnZOpnS58uamAiwlBKMylpvM1fw2zQXm9WmV33oHOJvpQ1oMFQJV8WSTFn3m82aKqGn9wjr05HOkDUrmRg6ae5gV0zy18slJmH6yR0wlfxHYOimPe+ncQMDVaYvfUSiIViOUXT3jqW4yFn105mNCjQnWRo+BnBGGJikBxnXePNjbVKbQi5D4u9ZDuW5IhTKHiAvKj6Zr7zKVIBg+NyV4ITsxwZfe35XORoCKjuLaSN52aUbTLyhCFRLGVvGMRkITtWtDyG0J6A8VsQMbb7fkBLQQyjL6tyRaRiFl7zA5bv3Wq+MJyUIEm1shswiqFKRqUrAsMluBRz+sZ3zjQ13Pw0gqZRzYvLur615T3Qgqu9vkOm9MD9p1O
 1OScQhFm
 IGCLYtFdYltQIRWLzEetUkEAaMMXgcAodV0XMIOwnmYZXOJblYlFvsiIrh+IQ+opW7cN5JMIvmiQOPZOljAkYGVjDNveax5+B2QDYLrUkniOYmAvtkX/5HxEx7InEjIYNGHTMZmoMNhYHE6TDadFv3mncxvXTlMwtoMI2hq249uZXn0FOSmUKroGHQo7/Fq/Nqk/Y3OnNqQUBSerx1yPxrA5xDUdRrUwpciNzYTL/gKZEWAM9Z/mPPh9Wv7fOxMZxRkP2WxYyTdRjUJUrV/YLcfJqPDkV9cWsmbLIzc04cTZOzePEsvJl1R06EgGk+CulwHDmKmPF6BUkU3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:25:50PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 21:47, Gregory Price wrote:
> >  mm/mempolicy.c | 4 ++++
> > @@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
> >  	folio = pfn_folio(pte_pfn(ptep));
> >  	if (!queue_folio_required(folio, qp))
> >  		goto unlock;
> > +	if (folio_is_zone_device(folio))
> > +		goto unlock;
>
> Leave the hugetlb part alone. hugetlb folios will never be ZONE_DEVICE.

<Insert leave Britney alone meme here> :P

But dear God we have got to find ways to stop hugetlb being this big stupid
nightmare that every single path of mm has to put an asterix next to itself
about!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

