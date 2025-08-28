Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5BDC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26378E0001; Thu, 28 Aug 2025 08:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD4A8E001A; Thu, 28 Aug 2025 08:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAB88E0001; Thu, 28 Aug 2025 08:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD9E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:28:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6886B1174AC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:11 +0000 (UTC)
X-FDA: 83826093582.14.242C5AA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 971541C0002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="v/aENElF";
	spf=pass (imf20.hostedemail.com: domain of 3WEuwaAgKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3WEuwaAgKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6dT2kIzhUObfcC4J3vqd7faAhyAUusYo8WMwaL7OG0=;
	b=NEw7v+IExPahShkOyunbwCKlCfja9BR0C6iKYzHq1WRUZCKy6XyUidqzOjIMCTGrvViZsC
	PZQ77MYB1R9RwkdUJzZ6hsZUJnz4P8HpDN5VJJDpyzB2mUmRjXQM2F9/2Eow2UGNXwdhB7
	G6zqXe+uyL7c2bWfThdPCoa4Y25hIB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384089; a=rsa-sha256;
	cv=none;
	b=lOY+qsWzRka76oToPxXoSd5eOFohnNSi9e9Vj5dfcGxjTjZbOP7UJUcL+XOXL2jezWXdoQ
	aa4wD4UekfzZc3r73V6Ze7mKhP+j5cpeTCXN0tPvkeGcRjHOJCxuailCwt3DKYCk72fjlr
	/vSQ0bRM1g8sduzPqKqu4dgL/k89c48=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="v/aENElF";
	spf=pass (imf20.hostedemail.com: domain of 3WEuwaAgKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3WEuwaAgKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so5776475e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384088; x=1756988888; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/6dT2kIzhUObfcC4J3vqd7faAhyAUusYo8WMwaL7OG0=;
        b=v/aENElFadOV37EXc4kOhqvEyjMz5hjvegQn2ZWK1v0UHUO9dP9x7iFMuugCNCY4w+
         3I+jMtidyHm4ZyqI0A94Uxke0bLFp9yPXJ03RKmr1FVs2reu0T9Utf7eM7RUKD7rLCNN
         R6m0PCywATMBx7A90xZO37OSNoC1ubMe9WCW+TBCys8Ru64qRKHurXtqvBV1tQpsno2R
         wUdgyVRhwCW8CEz75VBXxfXz58fzafB07h+r38uplxMVyKjUV7/TCPIm7GCOjk/7NrxN
         sXaSh/lmH5FzS++3vg+jcZRGY2mA6NT0dKNS2cgRosh+fElajzHgc1e5/iLy/az2t3dn
         VBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384088; x=1756988888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6dT2kIzhUObfcC4J3vqd7faAhyAUusYo8WMwaL7OG0=;
        b=TRZkmskTWCKjl/9GGhWlMSbYmNlTIT7ASR9xpxFug0pUyqf+/4K773ihT+oMIhvLYD
         wMrfxs2Rf967qWvc5FWYrb9RgzADfjPR+V/diiiXZY993o5qWI1NeX++5cfP/MItgCxF
         YaXw0U3lx2YwwwQd6SF7jTk2MGDJ62QnC0L6eJOgXPOk4FGrB4p7V9YsX+sVt6xtJFzB
         pVipjA02Sw2nOUVgLZW0JrkxAiqKOPJaBzh/uNyn0IrWPZQlbPQXgim2Q49WJqFizT6U
         t0rEiX2T4tb4jKMzw59jpL1l3yrWL4KrImr6GW9IbAdiU/UN4GrZbSU1DSzAB+LR/W5K
         I0mw==
X-Forwarded-Encrypted: i=1; AJvYcCUHbDt3ZAaP1psEykUwlxQpJIzmPI8Ozfyf8vWpypZFul4nz/VYCNaYXmHnvc5DiOfEjD6X2UjpTA==@kvack.org
X-Gm-Message-State: AOJu0YyR9cwj+f5iwNd6wx06/gQ+zDQp/bsR/dTYFz1joDaB86p/7xmZ
	QOV9sC2kSrW6EXQ50Y2f/yT6TGvxXkG33ts3VPuOwcp95AS3E42Vi5GATqAbGG2j44JN0PoBiUu
	H3ioVwxB3MamiYQ==
X-Google-Smtp-Source: AGHT+IHKlzslKK7RObgYwxB2Fi8fBbrlynksOPFwGRWJ5LPhLhzhqfjYPPoqRNKcPdh8DdvfOT2SAEyk1oi/WQ==
X-Received: from wmbay6.prod.google.com ([2002:a05:600c:1e06:b0:459:e01c:3d6d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b15:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-45b517d4580mr224468945e9.30.1756384088185;
 Thu, 28 Aug 2025 05:28:08 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:28:00 +0000
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
Mime-Version: 1.0
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250828-b4-vma-no-atomic-h-v2-3-02d146a58ed2@google.com>
Subject: [PATCH v2 3/4] tools: testing: Support EXTRA_CFLAGS in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 971541C0002
X-Stat-Signature: i8bykeuf3gbh4dzen44sjwi8pc84gsh4
X-Rspam-User: 
X-HE-Tag: 1756384089-715199
X-HE-Meta: U2FsdGVkX1/IM3CZ/VEAUoVt31nTW736mdMdfmv1cTaIHd3WvdVdH3WiOGKgVsV5poxgpCmFwZYaWGLe9enuz62GlI3GvWh4oz+diPD9s6mixEckKOCtFhGOIG57RXaB7s4RfT22Cj3ZhK/pVUcu8/Ft4SERLLEvLOKPKUSv+IVpeM3RCEY/eIQvVnrmiVziw8yN2jnzZjsykCouCobk0KVV8foaBE2aE2Dh4ek1Vo6dv1gi57caumUMqGwrxLgMAH2/oYj6K9wgAqGAxEDU5KA7XLq1+wQ0ScOhbe5ebtncxyTV00fVYgCHIHFn5u06UnDDc2wOUpM3LOXKdEzSNLJA4rWsvS8T1pp6+T/vBp+BKzxCu/OPH54ya27CqFRdEvrTgwdeM/GCXuyRV4rr3Lt0gCbKN4Qwq3//uvKqhxxJHPmXyzQn/NBrDimK/2pzqmmUud+JFc/aj/+YDzpiefmeh3NCQeL5eVr5Q6rR6iQzWPsJsdClY1iGmAh5CIKKwHw+o45JDGd2JldlQG5A5gg3K8F3Yg2eGLjUJZGhy5WRmLveke/92Eqc4N9ATBn7cHCKoxTJe8hp4jeajLtu2HeDH4P6h+Pc/m7x0PXK3lz/VZEONzJ6rEgazDV2+nZyJZ6qVFRMOLoU1frgrZq/dAx66RqEl2WITHBAtbeMebM/a7ZyS57VsWw6WdvTmfxq++iI5NM5RCaNARnvlVD2J5/2AY8A9/SCmjOcXFyvkxiVRi+Abwlfsex+XPBUtWaw0guifSTN/3udX+xO2udSpiQ4m03waeWABnJ0w0xAK6npPzUfJ7dh8sBrIP5hhtJpRgwdeZlYJj71Fo6y5KqSgXfoDIdhfeLRAae4SsuFZpyg4hpLTJNqXYfznqX+010J5N2ClT4RJ/4fZK1nSN9YsR0th7wikatpdTh1gzJumDj7ECdWcuTXfDVsb1/WCrDhhS6iLkgkclWSx+1dZSJ
 kxIWvKIi
 68hf0mDEGqm7HPgQY7TTler1udHS9VgAc6AOQmh6ggD6a/gYIyIEJUTKpfuh64IVtdozphJGAcH79GkBPtX1bHOc+axNqAHzvmBTIU/VcB/1gO48Q2t274upgsEgeBDlbf4N9ap/G6FYbfHkm9Ozne/AE0hNaji2QsS/7V99l6asaDRcyzpAzITi0cnS876j7DWwvVhgNelkEKhoBFN6EXg3nB6b2ZNrG3sJK4t8iaAvQTP7C8+iXxTke9qFsUdj1L0DqiZKRKiuaFNSDzNf9jqaqODCYNI2zQoZSwwUIxTH3VkqJbTij9UMx96ilSUqtzLVOSbHt1Bp8yf8jOLfsFH6AN52fX9SOkD4upgVigHIzcnSxVnhDFaHDezM6PvDdtbAdSIEM1R1PsYEV8/PblF8pjZzYa9tG+J233qByBMXGxTnti8tHiIg9Gi9ZJVdtaphaD8E9dToYXDXUDVyxaDTkmeY2p6fB5V6Fbgm5X0fN6qeoEWT/PD0DMf9wMr+b40zcRf5R4Aat4FpYLnB2uV5dWbkzhhtrJqcOh8sUfvegygzEzdMl2AYarNio3RhWNnN/EJ8OD98GR97RGo0tkRURJpTkuw9C1FC0sMWXzthyqiegg9S8OwiYXYC6xmt41aOP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows the user to set cflags when building tests that use this
shared build infrastructure.

For example, it enables building with -Werror so that patch-check
scripts will fail:

	make -C tools/testing/vma -j EXTRA_CFLAGS=-Werror

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/shared.mk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
index 937aaa7623320da1085a8e0f43f6a728ddd3ab1c..5bcdf26c8a9d51ab2cbd264f2f8a7445d7c036e3 100644
--- a/tools/testing/shared/shared.mk
+++ b/tools/testing/shared/shared.mk
@@ -4,6 +4,7 @@ include ../../scripts/Makefile.arch
 CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
 	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
+CFLAGS += $(EXTRA_CFLAGS)
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
 LIBS := slab.o find_bit.o bitmap.o hweight.o vsprintf.o

-- 
2.50.1


