Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46CFCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AF26B008C; Thu, 11 Jun 2026 11:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA726B0092; Thu, 11 Jun 2026 11:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9F26B0093; Thu, 11 Jun 2026 11:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC3F26B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:53:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78A9E1406DC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:53:14 +0000 (UTC)
X-FDA: 84868075908.30.6AB2325
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB98D40016
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:53:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRtpZ5ki;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781193192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWWQcnr5s3ZKYSOjuOdhQYovdi3ZfrWWs+mggmJcT0A=;
	b=sR1xuC4WkFdPa1Hv1vtepJjWXM5dzdfLLjyMy+mLT5TNisMXFAbd2mf3QvKM9h5fqQcF2G
	JsCI+roePXlultwQG3gp/8nbfwYB/7c0BudeUvE+K2unlpi0fDhQi7e2txmpOq33e7kJBq
	NyEUR5NY1sfDeR1gYlmqjpdbz6/Drzg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRtpZ5ki;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781193192;
	b=lZysNj/AST6qExD0k9dUajqcpDeasYv0M4Uy+zkCkcje99CVD7DqePisJSCgsGPoMhIBiX
	7G0MIgdxig/v/7DZ13AnAJQ1ITF0nVEdGSNhHQZft8KnOPeecP9fdU533otzEqTtK9hVgk
	XIRCbQqfbXntIYyHkK91FJRQj4p8YZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E079C6001A;
	Thu, 11 Jun 2026 15:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472281F00893;
	Thu, 11 Jun 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781193191;
	bh=nWWQcnr5s3ZKYSOjuOdhQYovdi3ZfrWWs+mggmJcT0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iRtpZ5kieFw5S9ITnjIH6j0aWcKNh5JeuF+zK4u3Gb5BHGjXDX+63qYpICXZOqKKf
	 FMpn/eSPdZ3uUDY2hsCqbr+TZrG/QR3UZsXMiEpeUFOJx1TvgaWPpU2Sve9CrFxXl+
	 FPqFy7tIGDmG52exo9PstHq6ST6VxUMQd8EOxUjVYsICVz7IejXX1Gsp7Nm89bi+jK
	 mGw7lODaN60ngB2FLEwNaIgnCWslUjDqMZ+ZD+N8Eh+psAFgBJrySRm3icp1ZA6RjP
	 0zyMAq/g3K9uC6d61CATLKH+E8nSZtrkkgmOOG/Fc7JJu4bfrSi9nkah1Wa+lwiqQ1
	 d8kGPcHyRzcdA==
Date: Thu, 11 Jun 2026 16:52:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, linux@armlinux.org.uk, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	djbw@kernel.org, willy@infradead.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	james.clark@linaro.org, mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, jannh@google.com, pfalcato@suse.de, riel@surriel.com, 
	harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <airZn524Ip8VsWra@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Rspamd-Queue-Id: AB98D40016
X-Stat-Signature: 14ty94jcnbqanob5ho69sjik6zjepyb9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781193192-20956
X-HE-Meta: U2FsdGVkX1+KbTCddQ5A7BJ/PPf2e6TTvjxQpz5LLGnZK6VH8dH4R2ntcJWaW2scu63X2vy/+SKk4nGqj5VoeFrT1e3pOCHTZWIjfGoyGkJHQ9S4pmgN6SCu+lQxWd60N89SreJcExQAovrv/QAjXZYf0JMURX4Oc9j7xINZS1MNp5JTB0TBsacc3VXkE3+QJ+gCQq5MGYzpSU82c94UI3PYP+XpPkRFaZ3ZH9HvFpZJ9hhRlTeeDrPl5hOnbwCMIcOsfjX3RDAvbn7OsMpUDZOG3uZSLqhxaG+0GOTqmA9yGtPuqSwQ4If3UQCsthIPhnYWyfvnHF4gE7nxAIl3aJFV5yW/mPh3HNbgkhrfCWPs7Is+Xo/c6C6f2d4JViImiJ/G7reqlMDhoWLYd3arZvKz6yb3Uicg5LoLw2TC//Mx32srLEy76JQwfym1VGVGD+ix80Gy1qXOuKVmQ+LHMbsqVp+c1kPXuHDiOkPhZdL1+7dllS28GDdtC/U0UddL9tT3ON3jqfTEepdZKESN3kkhk6TnRyZBY3S5VbUVx6We2fn52pEzgj80OCk81xzjJyuQa/8wH5QzeEziBmCHswbfK6bo2aGA/mDo0TIOkoNyl/6iatPTYxHK9+q12H7WLJNhiLBtoAtvMY2YzMpJkWA6cIyUUQJ1Kn096VpBGZ1NnqUAcpPbknFrMqjkDoU2H6d9VPJgGHLTXhlOwp6PwtdGS2EL6RwevmqLl8Tke/E4lI71JLUpP9wxUZ3Rxp6ZMS0d0844uPqLUp3bvUF24jzdO1zq9qEyZ+uC+AQCCLC5497bPS6uWs97sf8winEa0vgxbGV1LijXtMZIT//MG8kH/eHP6v/kRxE9phIX1ZdputwrooOwDVIuE32HmQog0qOn/lssbC7k5cv/E5B4OulRqopGIPQ5q6huQLnTVyoG04+lHvaVCQApH/eMLjWgKh3zB/iYezjQC4KJgLl
 ULUKLdDQ
 OJJEA5x9yDa0C4fNbjUc96W9EiUEt3LctqjwTFXiwg0kprfa01r5XeFOUU1iSg/LwGWzXfjfj6p0wSEDiwZRmV5VWmhFoqCVZ3mz7VRlsnnMqX+itiJqoDfjJa/17x6xae+ldLABoB283snN9Vn1yRwA1iDJJiLZf/Egb+GSk1V+HhOW+7dYDDthTkxbH+M2yiH1UAbzo695vTUXrm7UJUDHoT62btgK09+e+DtrZ3N5k119lUdFrKiXrEdzJ9othZN1/mLybTtq/KGJBswcFpEw8EC8o4gH5WCx+iiQOMw76O8aDvuF47TM1ACDToUAd/PSYZUyXistLvgVxrmVN6up7oMDkjvJju4a4ssFRpAaKbJYNBevJ8d4JxvP91FsiS7eko2iRxTtCp1j2StvxLtxftKC2xDAiwRXMRO52p6M4KmCSAglmAD2CfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
>
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Yeah as Pedro said this one could just be sent separately, and I in fact
suggest you do that :) So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  fs/hugetlbfs/inode.c | 4 ++--
>  mm/memory.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 78d61bf2bd9b..216e1a0dd0b2 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
>
>  	i_size_write(inode, offset);
>  	i_mmap_lock_write(mapping);
> -	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +	if (mapping_mapped(mapping))
>  		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
>  				      ZAP_FLAG_DROP_MARKER);
>  	i_mmap_unlock_write(mapping);
> @@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>
>  	/* Unmap users of full pages in the hole. */
>  	if (hole_end > hole_start) {
> -		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
> +		if (mapping_mapped(mapping))
>  			hugetlb_vmdelete_list(&mapping->i_mmap,
>  					      hole_start >> PAGE_SHIFT,
>  					      hole_end >> PAGE_SHIFT, 0);
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..5335077765e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
>  	details.zap_flags = ZAP_FLAG_DROP_MARKER;
>
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> @@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  		last_index = ULONG_MAX;
>
>  	i_mmap_lock_read(mapping);
> -	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
> +	if (unlikely(mapping_mapped(mapping)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
>  					 last_index, &details);
>  	i_mmap_unlock_read(mapping);
> --
> 2.53.0
>
>

