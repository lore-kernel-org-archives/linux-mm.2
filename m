Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB96C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADD76B0096; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0ED46B0098; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAD76B009B; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50B7F6B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDA3A406B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:08 +0000 (UTC)
X-FDA: 85219429176.26.F153A6B
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5C71C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=gHofv133;
	spf=pass (imf22.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqg9x/CbnxWRg1XoOeSbVUm5gC6oMxT5FXnTgFbG49Y=;
	b=5y4qTr1MFV1pgh92TngGk3vECbiAEPLxzM8eCcRfWsISxzgHCQncahtDMdm85HXF8dzDLT
	ZgTql9+nw77RnXkW/OMYD3JehkVBDKsYlCaewfyk37hZoxua55GjsOo0Vfe1LDUqOeRZIW
	vWBWZrL61/Dc65oMw4qBLSW6sLkKtDU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=gHofv133;
	spf=pass (imf22.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558747;
	b=hrE0N2co4oti/O90qbGqQ5/bsD7yhcCnYztFYYqNjQp83CtVyxjTZmWHF0/+rDGponTsay
	N9n1unbMvCNLYkAGJPUeveNa+ti5SIR0DXfqa/VysKzlqYS86zKnSJhxdbncu0f9c+v54G
	+LXQP3xobSB2mNyWgKTzoVMByZ9TGS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789558744;
	bh=taknttCU6rJMJ8zwyv9vXK3jlIjsPKMRnLZRjFDfX5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gHofv133TPvlF28+QEpcaM5JgD7JoZleuStXVi1KHcOLwqKyEa5RdlsZZijH0/hzi
	 vkcqb/cTlti/McA1gqgIZT4VB9hPkgpKuf8VD+/+Gn9Lrt/G0Px87DFavqMyfUDLG0
	 ieXEKDd1DCFTaVa6Ly9TVv2+QyThQdan3ZewjYso=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 282A9120BFD;
	Wed, 16 Sep 2026 14:39:04 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Wed, 16 Sep 2026 11:38:45 +0000
Subject: [PATCH v2 4/4] test_maple_tree: test a maple_range_64 metadata
 slot in RCU mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-fix-maple-tree-range64-rcu-v2-4-0b09de37eb69@cslab.ece.ntua.gr>
References: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
In-Reply-To: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5C71C0005
X-Stat-Signature: dyskofaj64ip9s11peexm9c7e5nwyi67
X-Rspam-User: 
X-HE-Tag: 1789558746-629785
X-HE-Meta: U2FsdGVkX19n4IdD9/TQAkF73kUI8u9gd/qCk4DxaHMJq7dciF4B/kIA08Pr8HQHAcFxX9GyYfdeiHt1j+vFMc+pt+QkIBQZHyG7vD9OOPaPBwfKGWuM95ZL/jJv1psgvozAUj35FFr16IpESZdQgBW3oFyPpcNPpTGpGSoiQk9gKNfX+FPZoIrRwfSa2uwhkt9ut+nIpIFW7oi+WAfJMWEg+U4s3fwWJYhmB9w7wjTKm8NaPJu7ETTfQdiBHHz/OkQoBW7QRJ0kEtkdvyqVJTeVerFdcA55Cyq1uPq8UNxwNByCGtf6DHRnQ+MTTNOLe0rRUHd32jtsTrcD2lOEtOgwaSc2B/RCTCb2TUeI9PT/bDwJ0+zRf2buV/0/TE12CuSROUEWUbtKyPrb6W0irmTXGD2b7AavKs8rk/QiTkxVBx/h7xeIpsjE6quu2rjudWUsdjZpp4jCYQJ+20ef/KMYfcPafyiuEm2l2U03q59S2cv1H6foNpOZ2yqTm0COKhVbrgN7TGWnE8Xs4F/7pZrLL3ba86r3S5wkZ3s0RbP+MpzHjvXWHLykL99yAj8Z9CZ/G4sPnKIVvVZPlxW1JJew93Yj10BOipIngOuMyD+dgRwdNw7vHDIHLBjy/IQ4d1J8gz8APuZIYy499D62JKDJ34nGtRdxjg2099RJtNuPBnXuarhWKBDv+MueMwOct0xQlxU/EBupsTdZbBb41IRvUw0Ysf2GjFkQS4Zc0dbqlnRK/hwOWG74JfigqYb6FzaC7W3/6k5XIFRlcbd03i5R2nGzNnayYH8zsf00Zz7gn1ieDREeKlFn3bUMhLy37sM+T96uutFvB1qfwDXkfSvOy2/Vy3ZNQJ1jqAVBMimP0lFJPAzfc5p6EsHMR80X3hUnaY0CbuSBJ6MIctCRSKGQDGJhk1SftvEUwWZUl9Jk9GKTkC4fOJoeGOzLxlkuCoVDIN1r2+ygiKGAvMY
 5bnjXdlL
 nUJElbbJ5GJIgKzLKJTTOq+L2wZ67OZ9KJ9rk5lvbdfVQKLZOcG0I1OSB13L15SFBwyCWFkwbi2DTWEaMVq6Sx1QXc0itZY8g7skVa39mWSu+xE7wdkHZdq3XbpuSnAEH6uFdJhLwwv7TkU+8E7L2Ha1hgH8lvCVvIW9NRhFQZ437UusWt3bPODFfuXDxwCjnGJyM7Gc0M6IunGIpcUWODpfebHfB5aO2Lf/Jhf/lY82t6Mtu+uzo+ykKr7+Dgu09fL5MyLuKsRfWzBiMCPf4AkacfY7Zxuqo8yeVTYhD24QqvEEer+zRkAcKdRTUqomCQ5cCS0ykK3oEt4mqUAO2Qyfydz7oc8lQ4i+gDoMC4wq/WN9N8Uyw7tPoPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that builds a height 3 tree whose root holds 15 child
pointers and metadata in its last slot, so every slot is non-zero.
Ensure the destruction under RCU does not descend into the metadata
slot. 3166 insertions produce such a tree on a 64-bit build.

Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/test_maple_tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 461bb0e4816ef6e9c670018a13a88a0e5d0cf89e..fb40e193a3cb76f0eb02af3aa4a38630692a4a9b 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3725,6 +3725,19 @@ static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
 
 	mtree_destroy(mt);
 	rcu_barrier();
+
+	nr_entries = 3166; /* Height 3. Root has 15 children + metadata */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 
 static DEFINE_MTREE(tree);

-- 
2.47.3


