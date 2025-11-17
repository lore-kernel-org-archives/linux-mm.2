Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F82CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA698E0013; Mon, 17 Nov 2025 17:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E32F8E0002; Mon, 17 Nov 2025 17:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2875C8E0013; Mon, 17 Nov 2025 17:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 19BF98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C303058438
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:19 +0000 (UTC)
X-FDA: 84121586598.17.87AB4AF
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02F0412000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NVywDGKZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 39KUbaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39KUbaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419638; a=rsa-sha256;
	cv=none;
	b=1Z3VhSV/u+8ouU5Nc9Cs3KC0YJFS5uK5c3GDTPedgSKVmzr/HOleGwq+KUWUGPK/RmDukq
	U6ukvbtsSKFJT3JJbIOi9tpsqz/+EaiExrwPy5WKyijBJBPmC/DbyXU0LnbD69orykawlk
	IuMcWGFbmvTMOlXy83rLus5NgK38Fto=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NVywDGKZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 39KUbaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39KUbaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYrCejxRy7zqyBcb6FQMxX806Q+d7GZ40YGLARpuYbw=;
	b=q+L1fen3tdK56cfAab4IoM0hY05CbOkJ07R2B60bB9y9HeHG3p8hoEwQCkO1IJ0lKzVN6L
	x/ZA9JvJjGJTEfNi+z4Egdj1rrXZQGJ8zZCyvvpZOXYeff4eXGzd674+1Hl1J9A079ykPQ
	sqP0ZDHtlQC8YIEEaekThKYhP+iivbg=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b82c2c2ca2so7211211b3a.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763419637; x=1764024437; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYrCejxRy7zqyBcb6FQMxX806Q+d7GZ40YGLARpuYbw=;
        b=NVywDGKZeHCwqYoLIVGWB0XKAJ0fm7gSzDitIk6SNpG8pHD8yamtp+jCw3uvQFOP8N
         /NO+G8EaJyU6380neiIjUCZj/Q05lrcJOfewstaZaoW4v0pOmLV+QlL8Q9P8JN04TFiE
         X6wCEQGIlaaQXEABmgS6mY4yNcNBk+a9Y64yaeOS6Bk8/70a4KJYN/7JVV5sjooQcMaf
         jXmlstMifLfm/BcTtNG4irr6cCXbEZ9rLuiOoowcb1i68iKghk+HGYBFo1Vwa/jL6grE
         SAx/Nmhx1qGKgxDdADxw9aDlh6YQGOY3aqouANnFqcVVq7U2lLBJhrn0tHlnVd1Fujpa
         fDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763419637; x=1764024437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYrCejxRy7zqyBcb6FQMxX806Q+d7GZ40YGLARpuYbw=;
        b=c7tPRUXhUd4Jk9fuETXRGr3h0jbVn4ZnOiwF2k3gOk6oNj8/I43uxbhNifEGrZj84T
         BiFyUy6ShHUi1/F7ZyvUCMoXcR4zNFLdZwaN1MseZZiAbZZ4+Ijq2psHGXUGJhCaWbmN
         ZT2Z8030Eunbzd4XvdhYOPqkXGkx8eCtGh1yT/olV2nYisK8SLGDuTeQZfewIDAPHhua
         nNlPOBVu3T2Q3k+yKJVMbBD1DoBeerQItjeoLFxWem9u5SGdeNG7i9ZE7FEPOUhTwGGl
         TvhqX4n7xo0CQ2t0qhHrs6atMmnE0BvdTB4FEJXelxXPaB6NFrcJCqIQHyNxYMxFB4yc
         O+qg==
X-Forwarded-Encrypted: i=1; AJvYcCVUoyJKR3fHbzHJNh3ArWOg0idQGaLSlEMIeNaQseGmIJ5lE05oCzA17uwtQpIEus64Gn5uJA+idg==@kvack.org
X-Gm-Message-State: AOJu0YyZFX4ymw+r3F2gvObvgo608lj2qtajI+3wlAAnsZ2ikeqUOHLq
	hm3zy/2dPYYx/BPQf96ItAwCbJCHHyDBkzDHdvzDmaLZo5hKa3Rg61JSxObVBiFoC3p5PRHipMw
	xBfht4p9s16Qq+qZdBF8G2f481w==
X-Google-Smtp-Source: AGHT+IF6X8M1O0ViseXJqknBCFgh9mD5b/95Oi6jmON/74K3wmmst3PfgAJtVAD5wgeUf0evNnb0s3MpsbBQZ/irZw==
X-Received: from pgbfe13.prod.google.com ([2002:a05:6a02:288d:b0:bc8:cea8:200a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:33a1:b0:344:8ef7:7a03 with SMTP id adf61e73a8af0-35ba2992e6dmr19087812637.56.1763419636821;
 Mon, 17 Nov 2025 14:47:16 -0800 (PST)
Date: Mon, 17 Nov 2025 14:46:58 -0800
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117224701.1279139-2-ackerleytng@google.com>
Subject: [RFC PATCH 1/4] XArray: Initialize nodes while splitting instead of
 while allocating
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 02F0412000D
X-Stat-Signature: gqecxcmq1q9xj6rh8f7kqki97uodghqp
X-Rspam-User: 
X-HE-Tag: 1763419637-832108
X-HE-Meta: U2FsdGVkX1/2UNnShffxmbMb19+CeepxYktSrBfr41MqgB2yKQW9uBBZODsnjv6yC9y4J6AkG0m1T16Dpsn5oSEXSYxL4z3EXeIB9PWLQGei0BjKXl/d0eL7NCXW7muLMDIn7JSkAy8xzovtNkqTH0RxKXiF6AYqTHpYcZM9oiX9t0r7wCuWtjljnYPDmMhe99c0DQubRMZvY9S41wEyF7EteB1INrMIiaJ0DtNshkZPLil026VaNUZHi3xvI4XHNLet5DmdMyxCnIX4twSJIUFpqzULE0CjfrqaA2UoFsT6ZTPo5GzY3YJ8WP9YU2OguzS/hBVZXFvvnDFf5InE9jthxA79xthl8X6KFp7mYNktAWqa1Qrr+WT8JmHwLENc28PIIJ4Jjnnjkma5mvl2yFqrkvv/vO7e+hLdHkp+L/9lXyodd2wps3KPLHCozyqS1j4TTIKNt7YIN/N2EWsEVdvD4mjaCSaf2xPiHtuTM/0jrpnot5FlQjocjXYIWqmGcEh6N9LOL6urjBpHTD16rcyGAGYBElH5MDauH+XEAlbyvomqJmCJ6EkQjS2Vi1wF5qDbdk8uMZxo39TfCtn4A+OfHtZYSbkT1DzqoBwdpvYX6a4Yas5EN0h0pIJSbfGkVdXoNiPqTzef9UHv1VQGi8i5SP8WkfyeQ1NWUA2qnSLsHgnoIO+89v0cz3vJViq2+h+5Cm9IHRYLuvev2XMYt5eWTyck4V/UA1rfJPBrdvUAyDF0TXdd0f94YGDWD15quGk7gRkBUmfRxhhncXgEQaRUng2ag6M1GQcVcQtmaMf93Ad2a/yFz37JoJgciXRB4sDSp7ya8CZvFLyEWa1w4jzjOQgNP5JyZ+wbkgFSkerz1LFEhD09xGzIaDc3VQ+mbnC+nEu7WDR0jzX1jM3hNAJqX18jr+Od9ionZPLt4azFEyeNcOLJzIqH6s1t5+ukFUS35yYd5cJuBdR43mp
 tXfsskSs
 jj3DyCoG1op9zviX9QxDd29wmFTGRRyOJyGLKSuUbAhDKhLyFAhkv32W86qTkpTFAmC/83881GPH+YGz8b4izBFkPdYhc63J3hZLsFk49WgkOk3eujETFDMuFb45P8c5ZMkBJvEXMvxma6i1LBFPnbTivKG5WGztTtOxEKzqkjPQpqSh+NhpmGfiYpcK+pLu+gAgMi50mSKKhFDNscyNfY/8D6p0Zy/V6AZa32LuPIZSyUpwj/VoWAlO95YotjPgqpR8ckhpTlC6+TpqimXVZ3VNYqkvkVr4YBA6BCbPeGJpWVmLz3AHdhSIG5bstsakujA96637dDIQHoNU694rrD5VcPbPpy2LWgnYolenszHLQl6FQ6BPrTqhO1n75cyv2g0o5V8aEoHxtIhZHsb1TEZo6o/5Sa6lN6ZHxEFf4XvrCSZeLJJ9yb0pdXwJ3uTuEyYzcXEGhrEqSp8SG4eHzrKAQP2g/824nGo1FrRL1Y99B/6kum0byMn0mV6rs7vKSSp99CdeizDsRyAFVoZlFsNxIKyI7DzfLji2NZoGTIsU9gMmXCYws1dBLlujV3nzcl4UWpYELZ5zhsdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, newly allocated nodes in xas_split_alloc are initialized
immediately upon allocation. This occurs before the node's specific role,
shift, and offset within the splitting hierarchy are determined.

Move the call to __xas_init_node_for_split() from xas_split_alloc() to
xas_split(). This removes any dependence on "entry" during node allocation,
in preparation for extending xa_split* functions to support multi-level
splits, where intermediate nodes need not have their slots initialized.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---

After moving the call to __xas_init_node_for_split() from
xas_split_alloc() to xas_split(), void *entry is unused and no longer
needs to be passed to xas_split_alloc().

I would like to get feedback on moving initialization into xas_split()
before making a full refactoring to remove void *entry as a parameter
to xas_split_alloc().

 lib/xarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index edb877c2d51c..636edcf014f1 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1060,7 +1060,6 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 		if (!node)
 			goto nomem;

-		__xas_init_node_for_split(xas, node, entry);
 		RCU_INIT_POINTER(node->parent, xas->xa_alloc);
 		xas->xa_alloc = node;
 	} while (sibs-- > 0);
@@ -1103,6 +1102,7 @@ void xas_split(struct xa_state *xas, void *entry, unsigned int order)
 			struct xa_node *child = xas->xa_alloc;

 			xas->xa_alloc = rcu_dereference_raw(child->parent);
+			__xas_init_node_for_split(xas, child, entry);
 			child->shift = node->shift - XA_CHUNK_SHIFT;
 			child->offset = offset;
 			child->count = XA_CHUNK_SIZE;
--
2.52.0.rc1.455.g30608eb744-goog

