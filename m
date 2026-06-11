Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C489CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 23:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDD76B0005; Thu, 11 Jun 2026 19:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6076B0088; Thu, 11 Jun 2026 19:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712376B008C; Thu, 11 Jun 2026 19:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6320F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:00:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDC3DC2C0B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:00:56 +0000 (UTC)
X-FDA: 84869153712.15.8A47F8A
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 055BB1C000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:00:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y+WxwI3i;
	spf=pass (imf21.hostedemail.com: domain of 3JD4ragkKCKUFQNHJWdMQLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3JD4ragkKCKUFQNHJWdMQLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781218855;
	b=u0YVCT4CdmlfJrwX5s7NZKkgqtaHt6Y5vm48o19HB+PfiehPBeUWA6+JXffN/1f+KRwcKB
	YQs6T3Q++3XKk+sD751bg6Yjb9/4vL2kn50Ze/I8FF48ToQvwQ2uMWKs1q543sW9Fp5U5J
	fopWPGAvx5Uwk4kGLZ7DUw5NJ4UwxAo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y+WxwI3i;
	spf=pass (imf21.hostedemail.com: domain of 3JD4ragkKCKUFQNHJWdMQLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3JD4ragkKCKUFQNHJWdMQLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781218855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb1Ioaj4F6x+XQyVE0Qd1l+h3NgQ/NDHANFncCV/m9A=;
	b=DG7NECUXtF5VUgtRhALC+FN5696brzZjzR7iBWHXE/8nERuOU0FNMqOmDc/w9Z3hUWuyGM
	TwpaIwSZN98q/cLEhgBlTFNDf9hG1jt/zfFnsAehv7lYra/YwdQVrIEICEqQB0kQOQgAsA
	QGxUV/VGuIicsC5ntNgwN2O/bOUCroc=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68fa01a88f8so252158a12.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781218853; x=1781823653; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nb1Ioaj4F6x+XQyVE0Qd1l+h3NgQ/NDHANFncCV/m9A=;
        b=Y+WxwI3ir5Nq+J3URbnrbPhBj7ctbcxI7f3vEstj/lCJsmMU2OV0JQ0F+yEUhO80XH
         pkeQN6wZUntRwsgKSscoCKLbqxOir2iuGWs80o5OldgilMlZXThmvmS65IA8sxIhyan3
         9cvum9mqkKY+AONEPCdmAZayStvGjwU3n1oeho6pSJnKmd9NpSJMDRKAt+gSQefSPj3F
         vVEQeKEQoAsi+PA6Tbcg4Ayyh4ZDvsKgwquxMEgXpGKYNtn1SezevZtcR6EGQl4Bqmq/
         MSCRMj7tJRiB2zgPjntRAM5aRXNYWss9lg198Av8NbNpXlDLmmPhQ2XEzQkXV8Ab5qKV
         UHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781218853; x=1781823653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nb1Ioaj4F6x+XQyVE0Qd1l+h3NgQ/NDHANFncCV/m9A=;
        b=PTRraFALPP5XAASD3QzvN/clYg5HBo7vBsEiE6HFmhujRm+N08ytFWrgy+rLaYC4fJ
         bFWyn43QyeRo72BPlHZgHZXOff2Uz8jsms9IXupUmUHF4TIgd3O+stM2/LjhiVsBYfJX
         TxQbuIhnZQhxkjAV4At7pjDhUTJfUf3lPVNertVS0rgwGZHbgu55Wi599hnQ9RZ+IPqt
         ei6L6h0yZRvgIeCvkifZ94FMeVWcaWOJjQsV7CwJ1tCP/hCXcGu7jdbM4JSjQqsTYIZy
         gO6zw/bKke9Ml/c6RJj87MYxy4ZiC7AT+ZPQu3bFa3QbJc6sgZ53KNPj9pcdsDppRl7O
         jtig==
X-Forwarded-Encrypted: i=1; AFNElJ8M2156pMu+ZMpW9oJEghvN87U9ajAuok5+zFSYH6/vA+Q6aJVKJSrWFwpkiqjTcvk6A3Q2LoWxRQ==@kvack.org
X-Gm-Message-State: AOJu0YxzhPsDmxmoHaP6gVM4EFZ8gdRfbE12rmbJqdXCLvSzKK1AGkiq
	YCsJMzjxWqJjpTJipFYme8yZTpr9fep2NE1U/0VU50pLZNC3tQqXW3ATBqA5plb1P1q0RdixpGC
	o/ARFl+jnWNgFWr3/rg==
X-Received: from edup20.prod.google.com ([2002:a05:6402:10d4:b0:68d:af88:b33b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3222:b0:68b:a17a:f368 with SMTP id 4fb4d7f45d1cf-69377c11e90mr87675a12.0.1781218852922;
 Thu, 11 Jun 2026 16:00:52 -0700 (PDT)
Date: Thu, 11 Jun 2026 23:00:51 +0000
In-Reply-To: <20260610220905.99860-1-enelsonmoore@gmail.com>
Mime-Version: 1.0
References: <20260610220905.99860-1-enelsonmoore@gmail.com>
Message-ID: <ais-I1P55RoHwG6h@google.com>
Subject: Re: [PATCH] maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
From: Alice Ryhl <aliceryhl@google.com>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 055BB1C000E
X-Stat-Signature: upsx5dpy8baqads8ggkzspkb4mzuw33a
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781218854-261906
X-HE-Meta: U2FsdGVkX18nkNz4UaOHnH5yEnNfB/IEtkyfW3v/W7DN7kfYLFxKCT6GRDOJKfsmftw4vKWdk5462d4nv/M7Y658h970/p5xf9uWFXMePgaEJihRQiuH/XoVXXG3EvAVIO1JNXOdAFwMdvEriMBtD8aXSyK0EjJ2tk50zrqluOhtdpWj0mF+98A3oY7MCzmi8ZSS+C3THtrn+wRHUPJHWw6EL6Gvkkf7FnK5idNUL35K8E7PkU3U16TIn4u6CgSIrSXaApP/GcSP03+ryWhf+GCsA3sViI3aWhkjn94gIaDZHx3lVW86OPZ6gcEclChL+JWRP7oi0B+2DTwWGqCJSAnbDUD7Nvs4blf3v0o3kCyc+HB45uGn5gKTxyoKTK3HwN6RlKkAgG4lO48lWy0/FOCbWVEIGPSZ+aAI69/IZO+QJkj3m3rLc+mUlSaTAOH4te+QFgZNIEgRBu549scg4dMDiTwOnsfg5Ze0B7PIVHtbn0RbRphmhAve1nSNHHpqO//vjZDo7qlmqUocDaoZtEZgjhdrfR5WLVfCHACJpq/ejNVjwc6GRAgJuiohc/sKNvfpFhrI4D4MyvPcBDg7+5g5d7g9lb4u+SNsDnGCbGZY3u/E98GhCKY8Z6VzaKMLpDKTJsjyEcoDVdXsn1BW7WZbI8eRDE65434HQhfN+I4YK+VBkw2NmPK9Zcpv5ONXRP7l0fNg56jI3sBeM/eObzhyVd0M7BZa47RBSmGK2gZbGwdYZ/MX4HFmd17nv7m3Ve+A7wHxNx4PXirhd8EQ7cyMyDQ5KQBLy6Fr7r5/f/KPoEal4V8qQjj2myr4CVrEMKVC8ZRVThqxOHJR4P7sGxTm4NBexOUPrCZwygdeHy9d/GFFjfJC9+UJhhVk/FgbFfD0iIkv4c3NQO/4ey4LHrfDhfPAbqnu9Xf7PFEQ6pjF5apX40E9j1zm264Wyfu9kA22bt1XmBQLTjv3SQw
 pjO6W3pu
 aA40kasyyhzEH9AIXWHsvCUh+AVDO0h6SsuhdqgP9cJ1I+S5QgnrEmf+X36Lr5DHwik+wDfNG0tghHyVl2rJKQ63z0H08XtvXhm/pp7qsp1qdXlE8b/ki25PCMovXGiCim3SqEjvhKjU5WgvR2yiUg4uHOWQcyB6PuYMt8fGN1wKODNTsJ/Bf4iOl0Rha0QxPoVmd4l36w0G5OYN+Dz22W5PhkXkq4EHqY+sPX4qfvsLwm3nsej7gsiJ9FOVp+/jC31Br6LOPf2SVSGMVY5q6pSRnM103upcbj8aVNLMiA8cvENCZ6mYELS0ht6ar4d0Ufuvs8b1xUo/o+ZjqA8BCVEtrGI8/b/ERWNOsDpHXG8VgiybM+HCPL4XuwXHybfrB7ZNPsWMjZFjrgRqjdalJgJRcsIrWuu4IJKldNejnzPwEsLvnn0ZGTN6cYeWo1aU/FBu9fO/nrLFGwuV6OQM3ou+4Sb5HoaKXpz2k72NPCXD6CVtTsxkJdq9GetBv3rxU3a0sdTjfXpm2YyqxM5zyGfcdu2yDfOxVJ8esbLKU2oT3vy+y0Zj0hGKNNEEOCuI+OA4lnI+fQ+Ccu6rWFwNVXwBF0nwZULNUwFVWKQQAJR/nOP7PpCm4OLtQN1dbdthIHt6vJejEjgpbJ6hI+Are1Ggb9RLFWnqIU7qp1OVjgJCklHgSOUrM/jQwgVi0MVcvc9DPlpBNDH0Gpv9SZBSDQKiH6X8mir7UipjDPWmRASrgoPZ2fp4nR5W0Kwwoyk9D8e8OiEyLmXcnsgAZ9cX5VOxCIqK68BU7D6OZpgogCtKzpSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 03:09:04PM -0700, Ethan Nelson-Moore wrote:
> <linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
> determine whether to disable the mt_in_rcu() function (by making it
> always return false). This macro is not reachable via Kconfig, despite
> its name, and is not documented anywhere. Remove it to avoid polluting
> the CONFIG_* namespace.
> 
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

