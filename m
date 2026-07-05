Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFBDC44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA34C6B00A1; Sun,  5 Jul 2026 15:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53FF6B00A2; Sun,  5 Jul 2026 15:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969C06B00A3; Sun,  5 Jul 2026 15:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3376B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:24:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F260C1C6F5F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:24:13 +0000 (UTC)
X-FDA: 84955698786.22.C20673D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 593324000A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:24:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hpi4V1cH;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783279452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdAOV4jTXETI55ttjbV9xV8cB+fGX14AaRjD6nCElhQ=;
	b=E6dHAcCkR/x8R/GByx6b6dgCqIpaB8iTBLci9h78Cit29kbu/jIMVqbTwZZCDH6U0xg34k
	2AJlA4zMwTQDYSPbxnDw7EQ3h9pFZARynYoo7iq6U8B9OYK3g+WFd1JA+PYfrieUQ7Ra1n
	NxchtBe0J4IKko4jE1zmSeLHIOomkm4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hpi4V1cH;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783279452;
	b=B//8P0MNoDs2R0Ur3HJEMTQgW6Mar/cUAvT8mBq9HOxAYS+YPUMq6SFWJEt7SHxXKYWEPo
	ETS47rWdCjlIy4uZamKKEr5m/zUgunmsVEX1Llo+4RKfDqwlD1aWOnnfpN6LpOLsq1DRZJ
	Gb/lYO79Qag1HA4+QsHcnPAa03K8ERk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8B3560018;
	Sun,  5 Jul 2026 19:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB38A1F000E9;
	Sun,  5 Jul 2026 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783279451;
	bh=WdAOV4jTXETI55ttjbV9xV8cB+fGX14AaRjD6nCElhQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Hpi4V1cHkY4R+5QDU5ssT+41lUT4m3MyuD8IbW9Ls2gqqqajSE3hQsRvQ7zeJmP4s
	 CKklW6srKTS+v7kD7iJ9XkHk+h69LOHo+XWHUPixjSL8CwnV+La1XMQSjxnH/qb8pb
	 mDjmpZaFT6fwGWZAY2obmF/rxn+gXRK7xVWEEz6Q=
Date: Sun, 5 Jul 2026 12:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org,
 dev.jain@arm.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 aarcange@redhat.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com, sashiko-bot
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
Message-Id: <20260705122410.d44328f443b63b96bc6280fc@linux-foundation.org>
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
References: <20260705131231.1499198-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 593324000A
X-Stat-Signature: zpr5a94i4foaoxqk6xz4gcdmq6oxg5e9
X-HE-Tag: 1783279452-198784
X-HE-Meta: U2FsdGVkX18QYuQH5xUbFVIPKqyRak+madfWWtF6WnNP9YCeqNy19qKN2dzrk3FVw7jPlLSsElmRErkFyiqW7GhHor4YOI2Q8y1ok85Whq+verA98AEHkFJps0KtdDngQ6dJcg+l2fCUxlPYVsTUwSdrzceWhlXNcpzretgaOfYOz8LvKaOKCxNjWV6H9kdkkuZpqX8R8XesKWc/f0OMkXM6on2BDd+o4iOJInc4PHlPB9VvgRoUWONfbSk+uKt1FFSoeSJ8idPz1p0OHtjtqau6u+nnU9ra7N5E8c/xXDA5V2owVlzuZes6i3q/Cbavn9yhc0j3vHRLXyOlj0/CVZ8Et4i3RdpfR00TTqWkmeiECrUq1ROeUCdJGoOC22X2wmp+xe08qB1lXfsQVNuU67IQtkEHWH2RK/GKLhMlLVlExIPu3m4FiXEFXHG1c2FuWQ/o2yGxHQ6rfgfz7LyCAfYcngRgTkoJXkiTyn3D2YuThNqIwdacW+xn8nPTSTNdX1ibXA6vI7EjnOpWuPAO/WyoL4hD1kbh+kdtF6RLmD0Xvrb6qW06OSFuB7+XXoGMtmFeZQsUPeYgUM1930LGDTJMppiova1NJN2zGjwKIYYldp9GOIQYqMAV0g+NkynjxNExU3B7hTCDTI57CMG8sdNFm337nHJ4/iUhWfEUmU54X4hFjb4HDsy1LEsIdmVjrRg7njFAYgfycs5ea8vML8gyNx2frzkH1nMsPpK1+lAyd61LC/8Rqbt7WhhFKogvxUE4K7MFYlQzx7qqLvoiYPlhVvSNpWsmFXc3GimojTDCFw7Os+xVtKnFf+5A2iJlgaF7o6MSLiaXKdmG/AffHfJxKTjtKLxaHQMyRExoJsLKjGfPYLhPeyk5LgwO6ynXSc19gPT6bKVbGg5rDK011wmSJGkTfkLhfgrUKQ2iPsYeSlUF+iFWTVSUWf0QITg+msjRBJTa3sHEenWzsjl
 ayt9eVeH
 q/ikW6wHr3sVXm4s3Gw9vDa01bugND1v9rOsiNSKVcW8deI7Eu80sHemjpApa9lNHOgnRUlrpcv8T5ZHk0AmItAu90wr0FSJkI/65jBamm1xoJ7YEyqXUc7jeG6watLNBEhOYJbL9qWyeKBR+2qWj7Lhh1nTH0nw8e821lh9czgAYjBoGwmkk8lAunebDEoe1uy/jmi7CYdBURsxIcX7n+4yVQvRt5yI3ndcZG8etwtrqdKcYDvS17jjKwoayHB/SZLyMq/cGn1KMzZ0GbGAPGhdyf+Ng1NYSxNuUNpPE3v0UBsO8KcLY6v2SYrqQRZUfuO+yLu/4oqw2rYOXYcvg+5nzFb1/23JlSY0hFnlqF0i8+FvDaKA5Pe9ZZCRsdeVlBaow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  5 Jul 2026 06:12:31 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
> 
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock. softleaf_entry_wait_on_locked()
> then waits without a folio reference, which is safe only while serialized
> against migration-entry removal by the real PT lock.
> 
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().

Thanks.

> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8

Sashiko says "wild spinlock acquisition and memory corruption", so I'll
add a cc:stable to this.

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2775,7 +2775,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	if (!pmd_trans_huge(src_pmdval)) {
>  		spin_unlock(src_ptl);
>  		if (pmd_is_migration_entry(src_pmdval)) {
> -			pmd_migration_entry_wait(mm, &src_pmdval);
> +			pmd_migration_entry_wait(mm, src_pmd);
>  			return -EAGAIN;
>  		}
>  		return -ENOENT;


