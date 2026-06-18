Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A368CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2815C6B00D3; Thu, 18 Jun 2026 05:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232306B00D5; Thu, 18 Jun 2026 05:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A556B00D6; Thu, 18 Jun 2026 05:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEF76B00D3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:35:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D4D5A0619
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:35:15 +0000 (UTC)
X-FDA: 84892524990.07.A25B516
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04769140003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:35:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJVdV6Se;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781775314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svnJRlqC7nBj8+wumxi3S0D0nQwN9ygt9ENMd/YHoEc=;
	b=hKVzGESD82ExCpH3OIoXBlnkY73aWSV7uILN8mTAo38eLUaQhfJT+3+DVz9sJEWZecxW6i
	sQLq+/5dl8Xage+Q53z+YU3jMbKuCUYd5HuyDhWfRJC3RKBZO36Xvo+baJ+JQ9oL8BBuun
	A5CK/hhCTS87CPIdPcEzMCd6/b1K7/w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJVdV6Se;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781775314;
	b=KRy4MAo5SGsszmIG6s2lJ4sNBLk7lCBnQZO4I4UY7JU//Sq++d1yGXTexzdHxl35RYADzD
	/xQK0pNZFL4TEw3xpT8YYvMX0evMGCjMkFF6AtQC/UMIfb0cuETpyfmlOJsXubj1sqOJMR
	tHxuTZJbE+nS0ZsinebxD+ddLFsuOeg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EAE2601E0;
	Thu, 18 Jun 2026 09:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA151F000E9;
	Thu, 18 Jun 2026 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781775312;
	bh=svnJRlqC7nBj8+wumxi3S0D0nQwN9ygt9ENMd/YHoEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJVdV6SelfsuOc/iIjycuLFBI9QO16gDia1DU906oY9Ep28XwzavtBGwP1CKqO1tm
	 X/upK8GZWfXwOPQUNWjgYujhlCU/dKGy/emkNdqHKJ0XMZ7PaXR8sJYNhXj9hqI9D/
	 ZyME1MMPXDUgQ8NnAOe03iLKG9Cg+zhJI10/3snoUD1RmCI9lTpG5pnGS0aoxchhMa
	 IcyGmH8Y+MAoYLste+BY/2DzAg9b/lcDp9hdeiGXuJzGG7MwKqT6aoQcIl8VtBUKkE
	 IxY3sKC+z9AJbANQ4BbLx+Jwf24TU9dGs5cKEe3C3t7IVI88dzcgT4YAnu8JbX48AK
	 PBGH1kAftespA==
Date: Thu, 18 Jun 2026 12:35:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ajO7yI541hphWRb8@kernel.org>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
 <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ojzuk41sfuiq19poio9h4epa4bcapuuf
X-Rspamd-Queue-Id: 04769140003
X-HE-Tag: 1781775313-693995
X-HE-Meta: U2FsdGVkX188BFUpBFaB8+m3OvziOKNwNOO8NwqtOVQEGueMTHw1pEfEjGJPweitzrGL4Sy7DxKtVSi1GinFYtJSYwg5+9Z2KRMaYiKFKzsERK04xt99890KgR5edL1kZSAKl5Mmdi6xx0iFt2KjbUmceZsk2T9G1593k6uLz5GShD3B8cF+9EYsARdAIuNf9nl9537+vU69323Vu9odHOjM5AzAUh865pa0DpNCRe6vOzJ/Zue96dVlO38x41//3dbm/HF5SiknCXgZn2mvU3th1JEHFRlACRefPXCmnENCqL6MDYT9fpJ6Mw6YvWw3Q+/1/2BVpkrNsHe706wSU6XT/cucf+99YBSMvz7zYxqKwJo1tgEMGeApqxQrY+WBTRMtmhjmNFp5uTCFLSJf/yFIJvGutYm/xZ8afGeZLsAqaxNvIoRUP+YI/vmYtcBxcKfdElusckoQYL0ptjnp9La+bhzut+qJlpq7yoX2XUD1ALPHqJ408T+QE5zIJWZv9EZbXjiDZuGct6qNrrFflsjy1jzIKt6pt+4uYQJFAuMyyn5i+lXkBken3nQd3r7R9bih3e78zOwCW8oZ9CkA0spc+Ar0DLe9s2pkkStxdaQN79pf11Dd2rQhizocd2I64YlJB5EtFscS+RBad8wrVv7nLMDhlQALwFW+wgtk40IHSXKnPhjmS/EanpLr1hBmr/CzoptLA6I98M++mJ0iHbHkIFegUe08AO4r3sku6RCiFhm8uPh3h2szCq0LlqxgoCzGZNuc6UcSePo4CDVTGQTjIyzpG9ZXg71ql2DEKjcrN0hr5UbQCP62K5UANGN3ewyZh5N94b/coSzBkbw7z7JDWb6WwoyxQ5nYb0NhTQE10zLNsiHUnvqqcaUJKQLBsvk55Z44SnclhnfUUltzBzuEEPMjzdv10gNXgVCBL6VlCGEc6qyxyk4iRW1iEpqyBKnMFlvc3Gxik4uPGgB
 SAw1yKsz
 sPxSYkfwbPcy0d++ytcCsT9o360+0utVIq3y1f0GlZ948SR3IF8rYc93ZXalhrtibPmIkLOJsrS54DtHqbdJs41Bo2rYzulwNb+HPpLBYnto7Ow4hERUPf0oozkep4GOEeeEFqaJKyHGu81maor4GwTma6nm2+syhHoBzkJkIAy50J+Df5fELaIH2twPB2mQhUiAzX5GdIUFSFJRzRdAqZv+v2+DqxF0JP4Biy1kGJtRGED5tw8JFcjxjPsLcIyEJSG/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:25:31AM +0200, David Hildenbrand (Arm) wrote:
> On 6/18/26 11:21, Mike Rapoport wrote:
> > On Thu, Jun 18, 2026 at 10:47:19AM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/18/26 10:43, Mike Rapoport wrote:
> >>>
> >>> Ah, hugetlb sets VM_DONTEXPAND, so it must me excluded to allow uffd with
> >>> hugetlb.
> >>
> >> It would probably be cleaner to just allow hugetlb, and then check for
> >> VM_SPECIAL if not hugetlb.
> > 
> > Cleaner in what sense?
> > Will be uglier for sure, just take a look at vma_can_userfault().
> 
> I was thinking of this:
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..8a6803618a91 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2029,7 +2029,10 @@ bool vma_can_userfault(struct vm_area_struct *vma,
> vm_flags_t vm_flags,
>  {
>         const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> 
> -       if (vma->vm_flags & VM_DROPPABLE)
> +       if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> +               return false;
> +
> +       if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
>                 return false;

In a way that's an extra check for hugetlb, but it will work.
Will respin.

>         vm_flags &= __VM_UFFD_FLAGS;
> 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

