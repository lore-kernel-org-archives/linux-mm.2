Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236ECCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A56C6B008C; Tue, 26 May 2026 02:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DAF6B0093; Tue, 26 May 2026 02:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3939B6B0095; Tue, 26 May 2026 02:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24B0B6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:57:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA93E1C01CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:57:13 +0000 (UTC)
X-FDA: 84808664346.18.EDF91F6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id B936B160006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:57:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GaqSg5kY;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779778631;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBNJcSkWDMS2F/o+KqKiAkJP47naY8jIDQxVCXbkfTU=;
	b=F+y1m+xPraW++8yCf9I+155VlQ9Ht7Pnekz1k+rz3KCvTKxL+A/6noPZS7Y25g4sKdMjgb
	ZfG6mkrkG1JXqt3wOmwMYoWTw/d7UHTemw6sqjhOwyviLojqyotuKo0t5kL7MUBU1kCmrl
	7sLep3jzmmu5FH4olH0JoD2G/7Rk7l4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GaqSg5kY;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779778631; a=rsa-sha256;
	cv=none;
	b=0rbhuYcoCuTGS4iXTokg1egoihrR69PihiwK9VgKZJFG/TdvzVRC6V9mWJOLLr3Hd03ULQ
	QnoYJotvE/wPaAXDtvGgpKV7L+S+/upchu32gwZdkEZ3izgLJPOkqi7paoXHfNtBpxt7/a
	+vVErzpbknxoEc9jvkZP5KsIFhalo2o=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso5789730a12.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 23:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779778630; x=1780383430; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mBNJcSkWDMS2F/o+KqKiAkJP47naY8jIDQxVCXbkfTU=;
        b=GaqSg5kYkm/iF+mS23mb1Oez+6Uo9c1PUg7Txg7fh1feqOjFIshrEvgG4d3hyVxY9h
         E6LGtEFId2DR7IfUk+OHsUazITqrudHyFesnKYbOWIAGtafpKBkN4OhNM5YT75Q1cvnm
         ZXGvZDGju3tXkkif7nJOY/JhB4sJfKG/jVU/0e6vRigwd/2DVySbV0IQ7QUcLaiZoV+G
         yMvzVgyAuLF2U3qyRq7Vu+J8aleh3Kzqcw/jhXheJk3BfgQhq3ZxJbMK+DypG8ulxR3C
         Q3l8GScZtDKY81a/SOX5VmX6y88czsBr7TiMNMWgzuixjdTh53tM7tIdsoEXeVaijq1h
         GuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779778630; x=1780383430;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBNJcSkWDMS2F/o+KqKiAkJP47naY8jIDQxVCXbkfTU=;
        b=AOjWOYZ3ULaJUpIjAP9TzCpAoyVyOo6ypCTuEPXTZ93TkytAwdvBXQod7xOZO+wiys
         wjhBJGO3nyiadkc47AuEHnAo1IMD9COHevznyY3/HXzVlJ+JArlO2oMU3vuWmYYDvb2C
         XZMnogkpyEroAHhSGF9RJo0SLWWGAk5U+hutW1sV93Kuv/0g3QnfdwofqgY6eL0pePt3
         EZtKTd5AJ8QqhTfXjYPuJqaUUZok/Sl/QrAP7o4SZ3AgDd/sHeMvc+tEVneIHlPs5Th7
         V5Q1Mc0f+RSdiZzBrcTt54z6XaZOV4/zkPMjP9yFco+bZx4ZkT1ZaSenGpLjt6Hp02Pe
         D/WA==
X-Forwarded-Encrypted: i=1; AFNElJ8sqc4zNLfQms6c/XFO6sfpGBhxCl4Gpx4Ddqv08M003ODtHJw8yrNhlw/suEr1/aLGDxsdx+fnAg==@kvack.org
X-Gm-Message-State: AOJu0YyFQkPP08N5NEFvIUrSz3LsPr2nfr8fFv3iJbYP59UjjF3h+hzR
	eoSmBY+QCf0Pn1tD5y753dSM7y4/Fe4igsbmFimGpKvtP71FIDvQf4o5
X-Gm-Gg: Acq92OG09EF+g6v3HqebDCvhdaEkZnIQ+tEZ2NMphM2PmQ+GJSNEW5jOQuzpqKid9gG
	/wWSYxcbpP9o2XXN5hX787s7xqH8n+Z3xFYeDvZYt6cNuBgZ/0nHgZefCEgcIBri98VPZ6M2Les
	2GUg795HSIfWZ7Kg5rqwspVBKKOgL+B/F8v4IXKSO2UloDAQjVhp/nKK8Fjl2NTeBG7WGRIsm8w
	VsAf1ioMAy6FxAtG4MrMTIFoBN7WvLTKsSR1i1OzCrSQXR1EQUARn4O25z/fmGwdZpSSsRZUqa7
	jl4kzupF+yVXHrwCz/nzePn1z1QOQwfOpbugTYGiwdtaUjEcOshP/jfTkXrGHST3su4NSbePftE
	D9F3MXZTL9xA4Xm5N4OVlioBxohwpXBz1VvnM5QeAyDcpFu6dUZUEJs/GZNIsQ8oss26/74xtwT
	hULmVa1OKor728j9MmB3aN4Q==
X-Received: by 2002:a05:6402:354d:b0:687:3580:fc26 with SMTP id 4fb4d7f45d1cf-6889cb3d24amr9081852a12.13.1779778629909;
        Mon, 25 May 2026 23:57:09 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688baf1e984sm4668480a12.14.2026.05.25.23.57.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2026 23:57:08 -0700 (PDT)
Date: Tue, 26 May 2026 06:57:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, jackmanb@google.com, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com,
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
	rdunlap@infradead.org, richard.weiyang@gmail.com,
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260526065708.oyyddmt2zgfwu2q7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com>
 <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: agdd8xkfop3ui1anfhyq194yye4bsd8f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B936B160006
X-HE-Tag: 1779778631-899380
X-HE-Meta: U2FsdGVkX1+VVCOo14RHAVO3lQmCeP/Z7STeWvvi2e8KCQ4uVk5YSMccbe0HnHxG2ti0ZziWrZdIeTKPuz4EHlQeURiE3V5kfuG0WdiJ2pvOTz+2jbZergJrQJw/FTGyg/TWLCUa78i7L3DNwBe6IAFiuLehU96OKym07wFS+9/rRcjDAsaiYTWlaLlV54YryuQTsYCMVW7AJPgo4WnbtcIDPc3c0+PwhER+4zp68SkQHe1zriSXu3pR7JovcdVJPYKLZw+sqf7RqBoktFucoFqpVx+Mell+nwRdAuTnq1i4yp0APIquhKzI55boA+5c5ZdAolfAGOIFrR4LtMRf9+3bsSjK1RrQYHSsYZa09BqoN/jAU7ZuJbxQX2/BcuT06MLU1T6MTDKe/SzoCwDEothX6mckKrXW8QGngYt5lAbb2btitw3pNBFNKGhchsHWBYf9O5/7gCt5mmn6zt/k+90U9nSuwiiDZ9o4c5wT9nz8OhAGm1M8kWPOJ/dGY4k5SdArrdaPhTZQ7ELHPEYogujoCAi3ZSC2ywf2OfCu2nVkLLWsoax4kdo5lNXUCoBnsgICneWY/1TRHg7Yw3R0zGpgj4LvDFtbyE4zeCQOK2FJIL9ri3wlzzdorSNdDWwJzKXtJJipXE2UbwDSb6lITIvgWivQfimDDCO38OewgUKbwvI15MuEwXjEQLAa4YVYa0qFA/V2HRQtRiGJJBXNRMmG8JDaNhuOzp4/bIwAy/U4oSxmJJ08kAzeLW7TH3zH4Xs5SCc+2zCJphbqxboQlsrsGZX5HtduNb4dsAiTvhdHlRA+Fovt7UMB4aeTJvw72l/C2D/k2cZpr001sFwNqv2kzeFvsfZ+a/BGB7A7QG+y1+CGnEDUU0l0lUcqGOhmqIJA8InYavZM0J6Vdry748jsyHg+EFlJ1Ha+yy9MGR7G7eiuNnmOfl0SgUPYrVwsHoXMLLMeVSBFL8F812M
 6mL/b4iw
 zgyICeksZYQiz0emL4pMHKXxUwkX+yOYZB8kPnPRUvxXRO3FCZtK7hOFM1IRN9PLFvv8FbIASeO7Nov4iXA5CI/rNcKrWu54PHfddukp5DTOVIrbmhJkIhYiM19+1gvCUF/fvmBtFTq/gY+KOwJk2hGtI+Pq/jk59pMWBr3aVmDq8Pir8jx9qBAzzjBzJPtSzheHzT8r2ACUxdCBLSFgB0R0ipH1nrhqmR6l9RlW+i3i3meY2Ii/V+aEFQd9axj7EUFvgnDC+AhRgPCQSSQTaIRH8DaWS5zMksJJPZ8F1Pbs/6yhfY7fUuvag3yW8dURC4ESMgFO3hoHiCfWmmKt+JFMmYxpO2T8IFe4jF2Ihcj6IeRxh7gKALSeoZ5SLW41IsCrLk1aVpRYY8jkODLYg0HP7EGfJqZ/0MzjJ/MGwHGGQHXc3AEyz3K1ZeYWTcs8tqtB7gtPp6y2qGEiOjbiiHq+bFA0hO6bnqUNn0uDm2xaX4JmKQKAUGLO4IABLW8HIAlJ3y6TXmlZVjCRTwI/wOcKZlXqKObzY/PFuj7ixGl36UaU6BuAyeZXP71O+ENwo+5zXO+E2P956eAY7w78TChzXt9+nk6Owx/LDHpj2ibKv9aVARwfNRmit+n1M3VZdCA2t+aptcrjhDyDWFdtCMQjx8su1G07u+iDMm2tnif8u00y54PIcmuJTyaFBQ6jZhagS0Wj+ex/vhCoyiz0aXEtDnOMta3GfQXg08SrKw/Ddj8z0n7atuQ1M6Hno958kSwqpVxS2Pm15XLoHOO8ru3OYL3Rm1lpQl4YgIw4Sx+mWiY7mzpjCyGjcWlVPQTnmbJd+gS9FeQZsgXOk6v3Tcg43EKGCbAbobyvrNzFhwOKF6+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:10:41PM -0700, Andrew Morton wrote:
>On Mon, 25 May 2026 08:15:53 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> Can you please append the following fixup that reverts one of the
>> changes requested in V17. The issue with the change is described
>> below.
>
>OK.  fyi, what I received was badly mangled: wordwrapping, tabs messed
>up, etc.
>
>Here's my reconstruction:
>

Hi, Nico

I tried to reply your mail, but found it has some encoding problem, so reply
here.

>
>Author: Nico Pache <npache@redhat.com>
>Subject: fix potential use-after-free of vma in mthp_collapse()
>Date: Mon May 25 07:38:59 2026 -0600
>
>Between V17 and v18, one reviewer (Wei) brought up that we are not doing
>the uffd-armed check until deep in the collapse operation.  While not
>functionally incorrect, it can lead to unnecessary work.

So we decide to tolerate the behavioral change?

>
>We optimized this by passing the vma variable to mthp_collapse() and using
>the collapse_max_ptes_none() function to check the state of uffd-armed
>preventing the wasted work later in the collapse.
>
>mthp_collapse() is called after mmap_read_unlock(), so the vma pointer can
>become stale.  Remove the vma parameter and pass NULL to
>collapse_max_ptes_none() instead.
>
>Link: https://lore.kernel.org/2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com
>Signed-off-by: Nico Pache <npache@redhat.com>
>...
>
> mm/khugepaged.c |   10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>--- a/mm/khugepaged.c~mm-khugepaged-introduce-mthp-collapse-support-fix
>+++ a/mm/khugepaged.c
>@@ -1502,9 +1502,9 @@ static unsigned int collapse_mthp_count_
>  * If a collapse is permitted, we attempt to collapse the PTE range into a
>  * mTHP.
>  */
>-static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
>-		unsigned long address, int referenced, int unmapped,
>-		struct collapse_control *cc, unsigned long enabled_orders)
>+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>+		int referenced, int unmapped, struct collapse_control *cc,
>+		unsigned long enabled_orders)
> {
> 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> 	int collapsed = 0, stack_size = 0;
>@@ -1524,7 +1524,7 @@ static int mthp_collapse(struct mm_struc
> 		if (!test_bit(order, &enabled_orders))
> 			goto next_order;
> 
>-		max_ptes_none = collapse_max_ptes_none(cc, vma, order);
>+		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> 
> 		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
> 							       nr_ptes);
>@@ -1749,7 +1749,7 @@ out_unmap:
> 	if (result == SCAN_SUCCEED) {
> 		/* collapse_huge_page expects the lock to be dropped before calling */
> 		mmap_read_unlock(mm);
>-		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
>+		nr_collapsed = mthp_collapse(mm, start_addr, referenced,
> 					     unmapped, cc, enabled_orders);
> 		/* mmap_lock was released above, set lock_dropped */
> 		*lock_dropped = true;
>_

-- 
Wei Yang
Help you, Help me

