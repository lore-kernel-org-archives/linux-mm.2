Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822CDC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1026B008A; Thu, 23 Jul 2026 19:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451DA6B008C; Thu, 23 Jul 2026 19:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A7B6B0092; Thu, 23 Jul 2026 19:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9626B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:32:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79BBF12021C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:32:37 +0000 (UTC)
X-FDA: 85021643154.17.E41312C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 62DAB180003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:32:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="f/SknRcI";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784849555;
	b=nIM5jkQrni7gJZVyrQwgRigmc78xLk3l9GXFI9g5L7+BJAm7t30ROq5itX184UP5lay+Ew
	nOcT+RIay6s6X6xIx2+nEII3mw3+UVrb7OeUpBF1xfIiJC+dy1y/vKlo6v2iGV48WNYEfO
	s4alwoUFWZvybAsDcOzSS+5UbJ7L5O0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="f/SknRcI";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784849555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hnn7yL0Nr/R1HUS7NQmyspKVad9BEXrUGyw69tYwFFg=;
	b=8cgBgyTVG/8MvnmbiUvgyN3dtQClPbngzxkF4wj629YWYA6DKkdCjtu9OILeSadsZIPT3q
	UJXRh/9As0xWyV6BdjyrxBZiM6Bd/IgyrQSFdTZftOUoJ1ztiQZIXZs9aO43s2QKFatwwn
	ORdazJc+HbutZSG3QmiXZErRnXPjPVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9981600AA;
	Thu, 23 Jul 2026 23:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3451F000E9;
	Thu, 23 Jul 2026 23:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784849554;
	bh=Hnn7yL0Nr/R1HUS7NQmyspKVad9BEXrUGyw69tYwFFg=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=f/SknRcIQDU4nSUdLwTCBM+cM+91dauPs197nxRVx1N0wb3jnV3jCafryW7ZOFFW6
	 mpHT5EbCorhe2AhynbP7TbxpHlTRIDogQW4O+ytb05thuP2OtJXAZzs0IZuCW5mmz3
	 fqGiOHS6IgLSc55WYASy9ioVTGMC6KCSVKazcJ9U=
Date: Thu, 23 Jul 2026 16:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Toshi Kani
 <toshi.kani@hpe.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Kiryl
 Shutsemau <kas@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts
 <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>,
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
 stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v6 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-Id: <20260723163233.54b38cfc682a25eb6edf7cc7@linux-foundation.org>
In-Reply-To: <20260723162646.350cf3bf415a0855140d139b@linux-foundation.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
	<20260723162646.350cf3bf415a0855140d139b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62DAB180003
X-Stat-Signature: mjj6n7fapp5who4adeguk79f56zbx4dm
X-Rspam-User: 
X-HE-Tag: 1784849555-234121
X-HE-Meta: U2FsdGVkX18BiQJnQwHhl5PV0/UYKwDO6QQezUzYVvp82EQHZkoRPQoAZUD++evClNcouUmPayWdSYpZc667FRC3oR2T9eBCPEkUQkxLeayikG+ZIvuz/ene4Qv92UrpMfdym92Z7pAZgF+Ro6gjAY5VWDH3TbOMelRKsEx/5EK8wLQPyBRJ3MLbov7LbPbCELIS4F0h1vd2rYQAQf0/mlIEFFQ5gz+v/JvsY7KC8ynzrVjbLjqEl5PxEYLywPdeB4/i4a7ffmvQOI/DQvTR9rO0zOJl7olHzS6jjow1oR43gyha8PMqAY45Vr0v+P8alxnLeGWrJWE6GSiGVPOVmfuvObjpzhXdPTc7581++iQHN7PP6g/0G7qX7VnHkPsB6V8yNytudTv42MRvU1V4M6XPwL/aysZkNFwgwr7vV2nGX9PXMUresns/3fggN+cYZS0P8Jb4oOpmuoOD7SUTtE+PcCMEECq+ZkePYy4Admn0NvuEWNDDOm8ujn/8vlyvm+v0hYendhNfAS9jssQsEzHPxnXs4qFMQRbp5LXXoy0wn4SE6dqnZwwZ8PWunzTLraelT7jZG5wX00kQESLQpbQQV6b0VSJs0HkaJcksBBtxadBaiUjzIRei0Sj2t4CGG5cBG7YKFiZvFXHG1qZZb+rQ1ChXTRQlArmtEiny0hkt+1MUunTKY7pw+fOqnanNk6NvDGoL3DdfXCGcG1VpElnoOgl57e5HKsBV8843RDh+wwIPsSqKJD5ELGOqqJEM/VVofAhsxCDljRWacVIn/w+Eet9xVC61HJR4jN5MV0KYxvOQ9o6eeUi9h7tIJJ1m7sze6+kZ0CumPIF02TvdUcCe0jhTUr6pnHNoXoK0c+G+Lx33ok1ub+wt+l9XSDNdPq9TijryJWqmqEW/kdmNbnz4ytGb2EyzUzokb1Av8FDfDrC1NLDJVjZfwNuIk9gB1iWb/vjxEz65755gpy6
 YOoLZB0I
 NjPoafERBEYcQDrhZUPtrSPB/3NpKoLbVxIZ+8cILI2JkUw1XvLCjRSaXse9GcVbbUsjjKl2l04Do9wmu0xFNSekgibOWm0RXkKMw3z2f6P4y4g0AP2LqfI2qP0kFHYiABoyn/j0Le7mx0uCg7nPgSCvldyUlBgu8n5Upy9FJ3ZEhdMge6fyWlRswt0OXB+53ozoB+KEeJCjm7vfsSW4jC/gs0NtIlWP8JOFpa2VoJJLee1EzkaONXpjWEUBoszN9KQ7HIL3d3r8VybvSvAPc1Vudgy47Flm9r9SgCdrLOJDrBUeq1ZyONjHRVHHxHsfktyenI7zExKdzaR7y18VGYosB25hTqwlRIwvmhwyrNsGnFfBOSKYBj5n7Svnm1z/l9HkXf1o1T6u/+olyyOdfFf8jvk8iX7yz/wNdN+iw2OltVAIGqzR3KeJjej8Xe9WxksZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 16:26:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> @@ -1250,7 +1251,11 @@ static int split_large_page(struct cpa_d
>  
>  	if (!debug_pagealloc_enabled())
>  		spin_unlock(&cpa_lock);
> +	if (cpa->init_mm_read_locked)
> +		mmap_read_unlock(&init_mm);
>  	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
> +	if (cpa->init_mm_read_locked)
> +		mmap_read_lock(&init_mm);
>  	if (!debug_pagealloc_enabled())
>  		spin_lock(&cpa_lock);
>  	if (!ptdesc)

btw, this affects your later "x86/mm/pat: allocate split page tables as
kernel page tables".  Which I resolved thusly:

static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
			    unsigned long address)
{
	pte_t *pte;

	if (!debug_pagealloc_enabled())
		spin_unlock(&cpa_lock);
	if (cpa->init_mm_read_locked)
		mmap_read_unlock(&init_mm);
	pte = pte_alloc_one_kernel(&init_mm);
	if (cpa->init_mm_read_locked)
		mmap_read_lock(&init_mm);
	if (!debug_pagealloc_enabled())
		spin_lock(&cpa_lock);
	if (!pte)
		return -ENOMEM;

	if (__split_large_page(cpa, kpte, address, pte))
		pte_free_kernel(&init_mm, pte);

	return 0;
}



