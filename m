Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C31DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540DA6B008A; Tue, 28 Jul 2026 14:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519DB6B008C; Tue, 28 Jul 2026 14:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F316B0093; Tue, 28 Jul 2026 14:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 270636B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:15:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA75616038F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:15:14 +0000 (UTC)
X-FDA: 85038987348.01.6FA0043
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80ED140017
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:15:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tbnXTxsI;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785262511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfLF7mqnjfhVZ6mNYMfhMtjyLHsLVBucTBizJSDdT08=;
	b=4/dfQ51ZlBFtevbDjIliv1CRdeVspk6LuucdLysNsTRVfv7pfqSBdLOwArvikDMFhCbrlL
	gRRZLleFAQqfBaC3NRItkggiUVDXmfETn7dO8gfmsAzVD/yb4JJ9pMDDPJSs09LovNxgfe
	Shcode+Tq5+Koppc8mKNo+kuB5HdQp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tbnXTxsI;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785262511;
	b=5xbwP5qpohIWzhPZ9LV4t9KzuSBPLedX5uVOwzs3SwSnVyi8mJCawuNuqCEIZh2wHuyrOK
	95yfKcOeFOOosk9xKPJW1ARSLcanW1VgQ4zehZ0qKdFmrWlflHbCylsWEyYrjuw6eoxHlF
	/4sJ0RJkuNCtrL4XRixBKCoQeUaWGH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88A22403DA;
	Tue, 28 Jul 2026 18:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F31B1F000E9;
	Tue, 28 Jul 2026 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785262510;
	bh=tfLF7mqnjfhVZ6mNYMfhMtjyLHsLVBucTBizJSDdT08=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tbnXTxsIdrPeQzZZsgT1xzf8SmaRoFK8BDcv/zW6vHZKJHzEmkJAzTUD1iHFWwR+z
	 0UTejys414ULQoJityXlxPAvxsL5rtb/0sB9MKMoJMuo3fsXEvk/F2t+Q4mW3Y4BmO
	 BPpwGrQLkFakBaeIDUV8PnuUJOpacAJKaJYI8JDs=
Date: Tue, 28 Jul 2026 11:15:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Chang <richardycc@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Martin Liu <liumartin@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: fix release order of locks in
 zs_page_migrate()
Message-Id: <20260728111509.7662e385aea0b055d2066e1f@linux-foundation.org>
In-Reply-To: <20260728055333.421080-1-richardycc@google.com>
References: <20260728055333.421080-1-richardycc@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80ED140017
X-Stat-Signature: t38otf6nifno4xtc3ju7cs59mo6wxkux
X-HE-Tag: 1785262511-898340
X-HE-Meta: U2FsdGVkX18Yh9SEYjILC0Y0AiUH29mVdDekh4+YSKx8t0X0stUyYabDxwzL4upz7Ucb6oaoWTXkm03roVV0m5VSd5aW9Zvh5Fs/8CExD8K9mDUfqZ977tKOkt1hOr4wcKsmu7b7qMN8xOcr8DbtxO+Uqmcs9WYnr+S6qmpXW8Mfadc84LHY5VLAOzxMKuz99N8ymOb5ho25rvGsfF/h8y6GPDCzTP7XmEk+HfjOzV2qVeO64N6CumjFoJ+gL6r5RwP7ru+bug4Oej78f45in4U1FSU/FwOZE031ctYXgfILUa1A7l6E3fXzIbSjVlqhQbW+A7LbbDu7ZDPoA6AgvxqOlWc7GN+5D/Q2kmBfV1z6rWwGPaEUvrjSDeKH37C5UT+lyCAcTt72XjsPpP3gjvWdoyVjHm/9LIZl2z0b16jxydUwZDG4YWpMv3+6g88HC5yv82gyEI81gW4F+Y5dP55rNNOIbj4ynX2eHTT/oIqoRONRsO7uaUxSbr6KbkdpdTN7XScS0KEtnZJW49zT7PaAwqc0P0cJHvECzhjkmJ/3yWhBVDGZ6jUr076Y7VwENOb3mUVFzaPBcSmRY2lskR1anGycnWXrLc21xRpfwvjamh+QX7/nKPkaKbsx4gfhYPAUNAooEJvZJ1coPL+he5r99J6gxWcgd6JB2J4w2MOtJSrl37ELp/8wHdNYioY1yPMs6Q444oJMYTrTqp2n36EkrHEHdiZfzfqyvv7NGI4AkQDdEDfGRTqSd9Zbr69MgSHtQk5yRkRdGTNZq/nlOt5lqX912CO89Q1J5s/tEfa0RLfOwO0oXpRbAh7Qe37CKC8aitMou+R2I0//8FORCjgqIrf0a3NnfXGZXGc4ud3lpCCd6kJmBwirzJEQuQK9ov5/SwjCB3yQv8MvXnn1ommkUxmI2Oz7O46Szz9K2BSLDJf+HjA40eZD/1D1cTaXYF0qVH9fmkw+WmV3qT1
 UPUbXC3X
 8MwBkmDkEF06MjfALyjjbgPE8ZWW3J79NY9i2wVbojoMbfekCwup+gepK0aEND/33mmKL0fGNUtvw3i4GRPVsQvA4QFqIjfldGqSvI8xONpOI5s1pEAg2KZrSgz6T+Y+2LiOiAX1X9yX9CEY1FKD6J0hv7QPM8P+aVF5QaO9GTMPrw39h6UnE8S+TuhsdauEUBrKp5hjuxDxIYDSLZQy7XQB7+AOko0DgqijL5xvTmCfwV6GpcnwWg4JqbZbZaZBDp4kZ8x2iipYLTNp6N4/Hx4L1u9s6RzRsaYXEgl3F9SVEDeqmgNu9f+3zysL0ghcsdmP4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 05:53:33 +0000 Richard Chang <richardycc@google.com> wrote:

> In zs_page_migrate(), locks are acquired in the following order:
>   1. write_lock(&pool->lock)
>   2. spin_lock(&class->lock)
>   3. zspage_write_trylock(zspage)
> 
> However, upon successful page migration, they were being released in
> forward acquisition (FIFO) order:
>   1. write_unlock(&pool->lock)
>   2. spin_unlock(&class->lock)
>   3. zspage_write_unlock(zspage)
> 
> Fix the unlocking order to release locks in strict reverse (LIFO)
> order of acquisition:
>   3. zspage_write_unlock(zspage)
>   2. spin_unlock(&class->lock)
>   1. write_unlock(&pool->lock)
> 
> Releasing locks in reverse order of acquisition adheres to standard
> kernel locking hygiene, prevents potential lock ordering and lockdep
> inconsistencies.
> 

Thanks.

Does this actually fix a lockdep splat?  If so, is a link available?



