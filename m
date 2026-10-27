Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC44606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnmuDiL+
Received: by kanga.kvack.org (Postfix)
	id 6310B6B0873; Tue, 27 Oct 2026 13:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6083D6B0875; Tue, 27 Oct 2026 13:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E046B0876; Tue, 27 Oct 2026 13:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9B76B0873
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:43:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9A5140AA7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:43:12 +0000 (UTC)
X-FDA: 85369127424.25.968D735
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28BD380002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:43:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SnmuDiL+;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122990;
	b=ufKSjmzlxSABVTolgrilvqrlfJs1kYjTR26n82HpJZSVTlIQHja6v8slYrAQGPP/nblBxc
	IgXRBBHpd72mC5hG4JR71bn/1P3EyIsOFwKWjhZeQPJnPwhJdW1zpIksLNwPiDcvGkcB16
	icus5/by56MJYLAVMBVGJIZJWJ47DAg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SnmuDiL+;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rIPaOGkz4dA6rLpWkpTWRnAekHyjd26NnKIbMaNQKk=;
	b=i+JqKkDiKTKLYLY5aKAP4UotfP8m/rt8OYCDISY90MMEJGr0yv32q1T2vdg1XHQNt0Meoe
	ovg/wC1aB8UfQKjy06xwjW64ZcjPddxhN6liVOFKv6IclZdglhHznwllwaKfFuLspYgFIa
	ihI2BwAoqAs4xTRn45WgVg55g7NL5lo=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c418e215671so12038766b.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793122989; x=1793727789; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4rIPaOGkz4dA6rLpWkpTWRnAekHyjd26NnKIbMaNQKk=;
        b=SnmuDiL+3D9hwnao8+XSPk6BM4wp+NTUsyOjWc5cGG2p6qqgMA+yoxWoOxtEuGggo9
         lnPRXkN9rd5hXBu9v/3Kt6r22vaudxdyFSxDVJQGypS8WJNknwEA8sZA48xehz7NRUAu
         IcOMlTbKO+09+EoLZK4bV6zfJlL2HpyhohDhLvRhshggFMeAiv9kGF7wOa3Fve2PcfHX
         IYvDx8sZdh1RrDPNkujL1wsCQ7Jyrb2OK2dIChjrVmb1MgD7hEv9euPUsR87ZCRVcmFR
         H8xzFvzI/l7N7NS0X+CRODeQVkAH8X+W3Y1DEVdb1y5gLysSClVdSt0w4/CNdxllSQ3y
         /G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122989; x=1793727789;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4rIPaOGkz4dA6rLpWkpTWRnAekHyjd26NnKIbMaNQKk=;
        b=CEiVBtekK+Neapb0CAFYhf0pu3a/jGSzc/k6aypPaytsOp4XNlXwjR3+nzROIpKGAF
         4oxAQ/qLfFOAptwFOQJJyA3RBB3HInrwyKVfw0lvW3xEQ2MjEktLi6S4GwY3c4EvgRyv
         sxv1y7vL6JRvyNETS9dTN4N67GNXVTWoTf8QtHBRBuoc3kb76qKH1WuaHk1uxrrmZa9r
         2BAIjA/V/gxfS+XZqQxMbHZer0Tnv5CbPKi5Bf8atPElpcNz4/pIaZrxQXMb37UzL600
         OMXsY1yzsStTWQfK83W2HBgDp2EyuFauC3H+yd+noKAMMyhWYRP37IqaeSfkBF5wshFO
         MQXA==
X-Forwarded-Encrypted: i=1; AKwUvByMvsdWeJe9nOuPnZcCGKi3S7jU0SFy/S9EENsuAfhbkuK6z/7qeBJl1y2+V4CCA0kbn5BDGgRObA==@kvack.org
X-Gm-Message-State: AFq9FYJw+k+hVv+SuqYeJmeEGxQ5jS41ZWleiX2+skVyFhavZ4FrqGSO
	P2t0ImAx/fkIQ6RcqoOpzUJWNAwYGeestQbrqJrHgWZCFHnSMyHKwnP2
X-Gm-Gg: AYBFou0Q9dfRtPmc/hFHZWg2V3oFWcX5Sfbz0fUZIdkQNffJT2uajC83D8xDfBpS9r0
	mKkwJ/VWTFDwULa+rrGeRfqAkGV4InkXM3XjIscBKbZ87cvQ2e/Gdkivm8pxbvovKxHsrGhwJ9l
	ExGiMo0BSgcTu7shgJtJkj3loXMEomm++Quh9hRhhepRECHkmvdNTf4UL3tngi7wqXnKAZE/wFA
	d3X00x0/N6sUCDKLNEUVM4fohNWkpvja9yNzPL1h2CD+5swOKakC6Lg099BHsPerAuaXVwsrn6m
	Rj1FluHZCqaqmULRQ9avbnK+lO9i+dmirTCTCXEkz3h2lyec7sgNfrdS1ETGqH5lWGZeDRoEAzP
	HYSjKfWaqQGIoE41mfrCLZdlblYf4x2vHgrF72G9WuFxiXCgyPXvX/WwsFl4nJXyHix+417PnS0
	SjRXVKazTA4c8yBbE3CBzWf26m9nvQuNrbSvI5zYV4Q1S9ADUKw02GQ6psRaydi29I2zW7Ncmc0
	fki9gtCOvW4a0uOQ2Us
X-Received: by 2002:a17:907:3e07:b0:c27:420b:7c79 with SMTP id a640c23a62f3a-c46bdec7fa6mr1214967166b.48.1793122988624;
        Tue, 27 Oct 2026 10:43:08 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd7a7c2esm484748666b.80.2026.10.27.10.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 10:43:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 27 Oct 2026 18:43:04 +0100
To: sashiko-reviews@lists.linux.dev
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Message-ID: <auDiqLSjI1qrn3rd@milan>
References: <20261026102503.30860-1-urezki@gmail.com>
 <sashiko-outbox-186354@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-186354@kernel.org>
X-Stat-Signature: q3beux9een86og6ijr847aze1ruhyaxy
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28BD380002
X-Rspam-User: 
X-HE-Tag: 1793122989-331007
X-HE-Meta: U2FsdGVkX1+//YXWHREcNNiOQQHvBePmmJPwD4BCX28t65bZYZGFb+Eo4rRkm3DMWSqjJxedFH3r795F3Oy3TSVD6wnOLhkl/vFkwLXtLCQvXARChItJerqxLTTb1jmYJsGkBfPkfD3kySgysd1rpx9NVOsYdvM6qTYIH3i9EMZ5fSSATF6KzJSn/OA4o8z5fX9+qUEy8G6s0fs0a5jSE0fs/n77+UslvwZweWtxJI84LcDInzknLdaJYsP8HT+7nkyNnSQoq3EPS5EGtKuExdh/IUC8NvHd1kW2n1v15WZ13Fk1X1l60Hdy2w0Cx2IMIQbfJBCaYKfJeuiKGZTUVl++O1eOB2PiWAQEZAlYZan0pmg3FQ3tEadJWO58D0e1IdoHra9hoYYVjK6RkQngO2+2n3lg1BK1xx/qozSf/4VqkYLTEne/L7dlr/mS0lxetVoIxmXZBtowo3lZ7h8U8ygG0C/pQd/+1aUwehK44Tc3tjSnnnYy286lnu6HyHdLyuC7nAh00TnovbFkFwPfXHe+5HhQ7gQrmnM3NV17z4Sk0gA4Rg/5jCQFS5vgUHPnw/2+Yw98J2FOd3xHV76Ao4ZxmOQ11/WDgk8cBcukv82u2s6rmR96rNDAdnvYuJdvsoKOWQRisPQVir6X8AWaIqs+a/3dvtBY5Ofk8uJyd+HH8Jli1sNZQvuBaoQNEBelSZZsEeqbPF4njF+6HAZzMasLdV3y/1KQXSyS2+JIUoPDG3kVPyef78qy7Q4E3ScYbGi/dq4cOVlqt9ewnxNNhqkLVjq7lOS51zShmnWXEVM3sPCqbh/kMy3Qt8GBff262+XKZdakJp6LkD86jcxYYtq/gSjZDO+3GsHbBgo6VAZAhEvcxm7tGH7yuA1PvCrGY/+zWFP4Azx9H81sfKv1SFehxHj+cORWtL2iag434pmDrem7ANKevoPyiwEMh28kdmlnwIXTEVEu0CpcJZC
 X3+v6eI6
 3JmfeNDpj+n5xAwTgO3n5eYjQTbkmFW8HttVB3V1JoP8qSXWqYkik9iWpVMcYH4vx97dSU4gR7aU2bYaZv8BTVHSVx3hB0UlldeADgvCyYQ6m54EEIxkLr7S/YSgA1qO92jESyXeT9zD1rh9Z/WV/yxYwX/b3c/jancuLgIZHz0LeEqWMOY2rvXTQWZ8rI1UrI+KGSm0zegHVrJGj8vlRUeFNp7luL6N8kmMa/fi8JNCVYvXEcRH1tEm80gXmZV6/nw7f67SmPbAxxZQsiK2+pRxA07UNHR4kDcAQB3tsxLJ7ZsT364g2/xgM6d9odLll13FuIiI/LXcJc7W8H+p7gNHpVnF7vcduq1BPEn2LtY67ODIRlcXrmiOxNmkrPr9lMNp0SyVJ8O0MN8fNTrpWb8aSXht9jusiltI44aP5LhgzxK9v7214aIgbd63ZB3b//fHph9eqU9GGAIcQC6yNerdO7vjknoM0cjTSHI6iuuTs8G8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:25:23AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mm/vmalloc: ABBA deadlock when calling vmalloc() with BH or IRQs disabled
> - [Medium] mm/vmalloc: __get_vm_area_node() irq bailout triggers warnings and retry
> --
> 
> commit 9fea18279139941aa247a1a577dd5e101116871a
> Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> mm/vmalloc: Bail out if in softirq context
> 
> This commit restores a softirq check in __get_vm_area_node() using
> in_serving_softirq() so that vmalloc() bails out when invoked from softirq
> context while still permitting callers with disabled bottom halves. It also
> replaces BUG_ON(in_nmi() || in_hardirq()) with a WARN_ON_ONCE() check that
> returns NULL.
> 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 44e0eb32708f1..5a949525b9db8 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3271,7 +3271,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
> >  	struct vm_struct *area;
> >  	unsigned long requested_size = size;
> >  
> > -	BUG_ON(in_nmi() || in_hardirq());
> > +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> > +	if (in_serving_softirq())
> > +		return NULL;
> > +
> > +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> > +		return NULL;
> 
> [Severity: High]
> Can allowing vmalloc() in task context with bottom halves or interrupts
> disabled still cause a multi-CPU ABBA deadlock on vmalloc's internal locks?
> 
CPU_0           CPU_1
 vmalloc()       lock(B)
  lock(A)         vmalloc()
   soft-irq        lock(A)
    lock(B)

Such callers have to be fixed at their call sites. __get_vm_area_node()
cannot detect ABBA deadlock which involves a lock held by a task-context
caller.

--
Uladzislau Rezki

