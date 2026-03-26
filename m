Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D819310AB81D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2728D6B0005; Thu, 26 Mar 2026 16:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249FF6B0089; Thu, 26 Mar 2026 16:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186DF6B008A; Thu, 26 Mar 2026 16:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF0D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:09:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 845975D0A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:09:14 +0000 (UTC)
X-FDA: 84589303428.06.EE37AB0
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id B3F031C0010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:09:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hIFdrVbq;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774555752; a=rsa-sha256;
	cv=none;
	b=Irc3AkqsutexTRz2MdbT7cPcwkpCg2XTAAkfOUGmT8D5Zwc4cNeS0XG96NYkmORX6dJt/a
	rDwPTS0E69Fl3C4+qLr911UpmJONi0Zh1t+FxPjnYMAjyrjLCdKJ7JBYZ6KfPDWTH/A9wZ
	jF8wjxAYZWKghdEP1I+zEj8l7FkGnBY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hIFdrVbq;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774555752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayPORQNh1ZJY3KlTlGuZGlkLSPgnYGKfyoymf89E6/4=;
	b=qLfD3Rq6Py6mLvnYaz5+vgQ0br+qSqNDLpsJaGGl+HTndn+KwvgZk+JkYdTeXrR4a/4vZH
	GkyP5T6Fg8m8COFsgy0clUt/sSZAX1yMY52Vbo9tMmnNp1F8rAqc+DI11mV7l9brnZsqaW
	XM7S8tCSFzmXhBM+nC69g9IMjKjMrTU=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-509061dab77so12839471cf.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774555752; x=1775160552; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ayPORQNh1ZJY3KlTlGuZGlkLSPgnYGKfyoymf89E6/4=;
        b=hIFdrVbqhmnYJ03R6tdHcJVk+HKOTVAzGAj6FJwxZlSf9muQ/vJoMFQ05UD0xXZSBL
         t1a4ofdlb/apAg1wnQrgcfXwJYmt15NxlY9auk/bdtrBmxQJI4Fqenp5mBEZDWLN4Z/+
         6sqO8+bu99LeuUCj4vrgugCpwGgacgA21bFkGWGlLxBVXPUGtTc9fOxZxVEXTAijg05C
         CFqJsPqrEnrOns+oVXaLdw0UUFmApxU7fbz0VC9amHM4IdQbS2iPkhKTjWLVtpdwYbeV
         anQuqNu3Jpd+cPxx0EKbLgPrGnPgNypCCc1e79S+Vqu4vCqjneBNlOURd+ayCDDKIImB
         R+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774555752; x=1775160552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayPORQNh1ZJY3KlTlGuZGlkLSPgnYGKfyoymf89E6/4=;
        b=VIN8hovETzCRAtVQXKDkDMN5IrXJiEccNFjDpj/PrJDrpBRySH+mIf+LmfHWCkrvE/
         YXvBwmMEa3iNstZcJhdz74a0Lhmf0KMxDfYmNbED+0KFbBzRwhpTcQYCYexc6usnSykV
         E8qBPHLPWIYrlUKr8cFqujFPdXmDT/n1+0utEi7wOTyDorHjKQkHp44aSWbv2M3E0ZE3
         cUWHvVxziokXewfyxVHKwvcrUHNuvji6MffuYxeEaB/vhQCa7nL9S3CgLVjg5QmGzDPs
         AkNl47dKiQA2S3EDtNPqSqFXn3qijV5Lx197OhPwDQVXj7KvIfovxD9aqVffGeWPVilo
         SYIA==
X-Gm-Message-State: AOJu0YxmHW2o5ew42JHDvfknk7fXgWGzGTnL3XRxSL5GDboxLF7ITcb2
	30nRl0CctQiEVojAMY9CaBvXa7PlEhPN7M0XEfShbEUx7cZM6ETF32HOkYyVDFoBNP0=
X-Gm-Gg: ATEYQzwOW7pNZ87RT6He/IYx3JD6+MMYJLAy6LEp6aFaUsV6QFa2/aon2YdAfOqzllO
	0G9ivDHEeivRpG8YoFutqzGUqtRnSrWgm2c14CN0p5zNiQrExB9RVcavmRgu0/eaPFwDmdemBMh
	shVJfTSjyH2gAI3uh4El6L72Sjt+TXqDJSEfu9SUyZ7vvHgnCykGHnHbm0A8oZMvqjUMKXQ7wRu
	9ejaBkrET3YJslRcTCbAPrnzhJC4eG1lv2UF+ieHV2xJWNmf+2IRqlhnC0bH/kan5IV27s1bzgs
	u9H1c+ppzDG/QXi0gEl6B2B3w7uOFvGlE3B3L8IRNOTjf0Lmkjr4Dlvwx/sEcjl5+n4r6HojGyr
	QIO1TnC7BsPMTdVy5Zm5ezlSL4lGO/wllF9AAN1WXl7npybJ9b1zGse6ASoD3k/Rwq2Zazl2HO3
	2QwrOtoxT0AKddxnOu7WCAHjkaehh8RAY=
X-Received: by 2002:a05:622a:20c:b0:50b:4778:ac60 with SMTP id d75a77b69052e-50b80cd380fmr124966951cf.10.1774555751762;
        Thu, 26 Mar 2026 13:09:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9237a40asm31637111cf.21.2026.03.26.13.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 13:09:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:09:09 -0500
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <acWSZZ1MPGZi6PH8@gourry-fedora-PF4VCD3F>
References: <20260326162611.693539-1-gourry@gourry.net>
 <acWHMQ2MPFjOSq5T@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acWHMQ2MPFjOSq5T@casper.infradead.org>
X-Rspamd-Queue-Id: B3F031C0010
X-Stat-Signature: 9bj1yus4qrbhujnwbbwkdqwickmemi88
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774555752-730555
X-HE-Meta: U2FsdGVkX1/gcKh2pgd58MtnzdS0tN5wc++bZJ9E+fj65mRrS3LvSj31DEVyDiTsPciCHM056Aq/spJS7j94EmuzrThHxZMluKRk/xnMKNT0+S9AIXsxDCsBBVWK3WOADI2BVIXD528SeBlln8ahjv8pBLyxngQzAnf3ooq+22B/DbYYw00415iIiqL3pAp5jx2ZYVUo3l4u6e7RpeRFImYoxSxQrEts2eV5em2+tdm6AwncCla3I3kcuANkxxmyr3gpIcu9w0w5domO9QQYz0iREAl3P9efylij5JhV//lalO4KHT7O4r22IW85GpJP8LhfugKCJn5tSlVvCZPymvK98E9nSxB8DBLFjoaqbUp5p6W9167OISaKEpHoMWjw8bbS4IjhZ9Z0U9/I6fvFDUnUIubLNS1QzS0hmumsiAThIS4xiF2hS+7c6rfOnnIrxzbXHuKV4ycFAHIZIHXDeKTu0ZV2bXqiCE4W81A7acLPX3jEQLXIJ3hPXsJ2cHcvi4ajN+Q3J1ETzvW+wsv9kNMZxIvE5orn0KoPLa04SJDiyAuosoZbRnzM9U6YLvyzMYJY/Zgde0IFfuzeY5CfoTSatmnfxSZx78vzZnLfGtgJTydhogO7siYc6U75KpAmvWhgRoyPwLRMlAaC8hgMBa+veBMh5p7VuUVeCQEsFLZYTFmYpeMtIA3S0yNK4pA3ZFB7PWSsnzVT3hUikxiYOjijlmEO4fRzHA1o2hH+RLhtt0bjOU29DuhIhVhtVeJEoqo+T39NG0ZiHYiopysWRSYIaQfutE2HNl6ySo1tzGxIdgVUHaeKg/UQ7thPSPNOB4nJ/QkWxVGucGG8XE9Lth36hUnIrVDTB+axKz9vsFE0X+U0QW9Nl5j5jHsFrj/Re8ptCFS+doDA+d1UNB0uHSKAUCkinv4jU4ZH+L6rVdLHDhD+ECC7LrwLAhi/J8UozzdNB/1BblCHEcLAjPo
 8+tCvjAH
 FZyqRnjqg39FEW5iM/3h6OO1/vMk5Z/ugJr2JmD5ywdcfUNi+kmf8624LgOsxm4j3Nm+VHtUhQT3K28p7a6Ez3keqdk07j2GscHjLqL+4qnt6crQzjxL9A8KlLKt4YWRl82bq8au2LIjTahzvgEQPpZ6mmKpEzhnDH7hb3ofDaJ/k/czlWQp4YsfRKHrONOK8F9GR1VEyDBVbZr7Ev6MZEM38GW1C/rLjYriWCumKC028zICfC+jO4+KbX+9ki0AjnlRrtFnEmDBALSIUznJgg+Y8R+nmhKFu+mpGZgDaRjEM3D1zzemGIOANSNyaLgMybivOjFjznAzpno2Xx4owmeErWBSMQuc77Ra9khHD1UJ5L6Zy2S/yXUHIjDGPxj5twOHxFiw+viYjA8gVBM0fDyDGR7W7uq1uMFAoxoXAWag1vAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:21:21PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 26, 2026 at 11:26:11AM -0500, Gregory Price wrote:
> > This also requires removing the rcu_read_lock() from
> > do_fault_around() so that .map_pages may use sleeping locks.
> 
> NACK.
> 
> ->map_pages() is called when VM asks to map easy accessible pages.
> Filesystem should find and map pages associated with offsets from "start_pgoff"
> till "end_pgoff". ->map_pages() is called with the RCU lock held and must
> not block.  If it's not possible to reach a page without blocking,
> filesystem should skip it. Filesystem should use set_pte_range() to setup
> page table entry. Pointer to entry associated with the page is passed in
> "pte" field in vm_fault structure. Pointers to entries for other offsets
> should be calculated relative to "pte".
> 

Hm, I follow. I was originally thinking this was scoping issue given
we take the rcu_read_lock shortly after the call anyway, but I see.

If the invalidate lock ends up being needed then i could leave rcu
and just use trylock/fallback to fault.

But I need to test a few things, nothing else protects filemap_map_pages
with the invalidate lock at the moment but only shmem appears broken.

~Gregory

