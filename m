Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF4B104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF856B0005; Wed, 11 Mar 2026 06:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B927A6B008A; Wed, 11 Mar 2026 06:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ABE6B008C; Wed, 11 Mar 2026 06:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87A576B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:48:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2402D1C98C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:48:45 +0000 (UTC)
X-FDA: 84533459010.28.EE329A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7161B8000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:48:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uu+F6xCI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773226123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iI0Y8OCqpatH5PQ6fQUiMS3OKfY0KsP3vA4irqAbNak=;
	b=TmMJZnVPqJYpdHDTSFjLdA+1r9M2CUKyxx4R+QkVYcWV2q74L52uNyhbZM66FmnHkJrmsC
	0JVO48TMumFPZLsg79d2+6AtghBFIPuVM6tWl5a6lhXihpOfx8FRrKgcWYj4cDh0oxO8jj
	SZBgxs4i24ddNRvx700AwQ3v0ojr5aQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uu+F6xCI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773226123; a=rsa-sha256;
	cv=none;
	b=esulzBQGcLCAP9yu8PzboxwOEGW5RZtAhHX1MEhavSQY/0aq0Ulh+8zdmksCQv6UFng2f8
	luzB+EdU/gco6fn1Xe7oviYJRb6qOtscOcxLA+HqArXSDRtQlrtMrzap5zyEjU7hiqe0Yi
	LnACnnLv8106iD8zbHGf6Ig9DuUjXIo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D3A744047
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E128C2BCB0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773226122;
	bh=8Dgof/Z7x1Qc9gRxnBoa99P7lAcsBojgHpheLsI+VQo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Uu+F6xCIilv+2+ugGLjKVWecSvbtjDTATAU1+6QaKqllCqeMFAlfXpa+xLQOLHc17
	 kyV2nyl6GTjvN2sQEOcEGE7e4EqjNwEwoGUlLHDPdQCgOKiIacai5MxWlAO31PSw1a
	 xOteKOnJtBA0vgkaLQDsJ1DawRRfqBYX1VSLpR5+2eqUUsMTxiiLUlbHrjxw36+LtI
	 1v3/ZEveMgzEPnqBadyU65kQxD/GqlayfjrMmgYihl/X21UXwh3QlV3oUrxJ3aLD8N
	 d2ItxhTw+FyyRfGvkmxqEmqlVbyRGU/6EUXNqXw/kYSUAQYbN88HkUYB2oeamfy6Cr
	 ATgN1ZCOSbMfQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b96da7b2e2eso588496666b.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:48:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHkZiz96H80ruwjVOZXjHo4Qt/i1QZCs5w7+zBUCZhUjBzSPIb2Zqp+OM/p00FKB/6iRycuR9WTg==@kvack.org
X-Gm-Message-State: AOJu0Yw0rRZF93z2en4oodFdUh3pO73qRjmWUYlC1es4E0l9eQulzU5f
	0YuAYdlfGVbFDvQAco5+7wreQBsYxf6FjPBvsko5eYBy+PZz/RIJlcNuPIGDxxIFX43n6BSSj+C
	Hi17dWiom2GAO59DTqh6Q1ycqSekoAgc=
X-Received: by 2002:a17:907:26c5:b0:b90:ba21:62c2 with SMTP id
 a640c23a62f3a-b972e604280mr92627866b.61.1773226120836; Wed, 11 Mar 2026
 03:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <57fac928.7af6.19cdc162036.Coremail.luckd0g@163.com>
In-Reply-To: <57fac928.7af6.19cdc162036.Coremail.luckd0g@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Mar 2026 19:48:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8BPPrEiD+F7LkiFwXo360-VGqADw93ptwCwp5ZVWkGYw@mail.gmail.com>
X-Gm-Features: AaiRm52zNbsQ4AjZ3BM5nUvsyqQmAWlDZXO6qpuDcu2dtSoJgolzDKM6VaA7H34
Message-ID: <CAKYAXd8BPPrEiD+F7LkiFwXo360-VGqADw93ptwCwp5ZVWkGYw@mail.gmail.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Write in vfree_atomic
To: Jianzhou Zhao <luckd0g@163.com>
Cc: urezki@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7161B8000C
X-Stat-Signature: jujg8n4ejy1kcje6krznt73utybbhf6y
X-Rspam-User: 
X-HE-Tag: 1773226123-617118
X-HE-Meta: U2FsdGVkX18yOi2X78T35ygVhWPXSxu0XGFor8rf8nWBCww/lb1sg5Pzvp3j9a9UKgkD1CPq0esjnzjfNAGmg5xdC1y7nqUSUHmFW65XoVoO7AX0yi354qoZqOZQpRenkjUyaNRghqXZw38/qO4jboUZurAHaCkVNMbd0Nj3XOH6yPxomwpSJEaGzLJIdAxqNqbCr0US+5DEo01l5LiBsVKRna8v+GbHkSTH+9yxQQUhQHGnaQjjBe0Y1pAAeEZew9JGxj4K89lEFToXBo7zNt6QPlYLbaILcM3yCfu9J9h6SqhL/r/n0XETHfgjQ7HI/3ASJJIyDgS1G8oKEYd+5dKguzZSvM1IhtZEjgwqNdsbBD9yKQQQh2hSHDoiHu7hTePC/Yy5VZd0RTmBujyWXOKmIemwER0PdkbuBZ24/V/ZIsjXS2QrPRs3gJdG/Muv/sVLwkxyoDOCtBjGp1AQkKw/TAonbr5LgIaP8xv8IxDVx0Bdut9Xpe/jKTy353M2KVOq43RS8XqajVyuH2IeJPxTy1VfL3KLLaI3ZtysaTaZuqf3IytCGpakSrv/2KXVadDdADFuYut/MQNghHQEzqa7krKfRxeM6lF+CvJdtY2tIhBj6C++t+2CZ6GBN/p/cF/2pPs66Cw0FehBVSmpQuTBY9nvdrsXISSiS4dSy3APdCK53n6+PbWT9b4yy4muWIFPuY9yc3HuM8zO9cJBr5Mr9BL+kIoiyHrViNk3d8CYR1FTVlEB1bq8gD1v7tLYI7QtrmSzVoY3k83sdvCY2ubSVGYe00sUNhSH9nHATbeJK1x/GFnqoQ2597uFpZ8fCoo9GJzBJHA/gbPafYL6GVQpTRiXBC19IFlHwDjqPOTQjI/y4spN2hFuW08/QwoJPZ/dGjyaXFUMCfKw6lyn6ZkRliDEioH2lN7G9uUUu7TGl9YiydAYesKBrJjYwQJPd4FlYVUu651g2mIusEk
 dG5AItAT
 IltuUkVEsS78ps6s8wIQOvJyv7xO0aPqupL63
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ### Proposed Fix:
>
> The solution is natively simple: nullify `sbi->vol_utbl` directly inside `exfat_free_upcase_table()` after freeing it. This safely converts the secondary asynchronous `kvfree` into a no-op.
>
> ```c
>  void exfat_free_upcase_table(struct exfat_sb_info *sbi)
>  {
>         kvfree(sbi->vol_utbl);
> +       sbi->vol_utbl = NULL;
>  }
> ```
It was already fixed back in early 2025 with commit 1f3d9724e16d
('exfat: fix double free in delayed_free').

