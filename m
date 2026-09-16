Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DA0C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B416B0095; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819166B008C; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2FD6B0098; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6BB6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C84EF1206D2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:08 +0000 (UTC)
X-FDA: 85219429176.21.BCB5E3C
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id C423480004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=q6YLEGd5;
	spf=pass (imf30.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558747;
	b=KrWOrjiZNcHUIKyabHrBbnxZBPMSptaSA2LT5Tf04VRVmf6tKsLdyGcHJnlgiF2GjNR+K3
	O+XRHlDeyXpECb3HMQbjEYMBmleyY4+6Kd4cHvsp9NhF89ok5SIuCU5qcb+LeDRz6OXz0P
	QlHslf6T+Slwx/adwKHSKUq5U9gACxE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=q6YLEGd5;
	spf=pass (imf30.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6qQ+AQq8nQcyfmzCyjVjAkZr+iqDkkG0nuJ0EycY6E=;
	b=lz1fqCSQJSa6hDmypGowIYLIY7vjysuDq7r01CgHhcpt2Jm8xW5Fv8FphixGXJrtZ+0qzj
	3ckJaJDZUtYYKvveEOMnHpJ0OCA91fcQ3ciqhrhduckxZvk1saS2CuaDmbgFe+412Vjf2R
	KrxqEVxdCgDFTCkhevGA+ZGP5ScU+90=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789558743;
	bh=UTqsWoNgi0JoUBsTSlLajU9tY0b5om7/Kl+EO4gTmk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=q6YLEGd5JNR6tuPP/xh8EF1H1DVyHK0FubeLeJUEl/f1CZncZkhk59xsfR1i5dpir
	 Nx8nAy9lI/22ss49Pt8aKIzMMwMZSenmNiA0KA5yPJZ5bjet/pxnFX4JSHPPFjaAor
	 dKqDhcd41To2lPMWO22BNMnsU3kreLTlsxXvo7fM=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id EA125120BF5;
	Wed, 16 Sep 2026 14:39:03 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Wed, 16 Sep 2026 11:38:43 +0000
Subject: [PATCH v2 2/4] test_maple_tree: test a full maple_range_64 node in
 RCU mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-fix-maple-tree-range64-rcu-v2-2-0b09de37eb69@cslab.ece.ntua.gr>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C423480004
X-Rspam-User: 
X-Stat-Signature: q19mx5nzbc411m9fjdo4nmthbg8d4p7z
X-HE-Tag: 1789558746-899239
X-HE-Meta: U2FsdGVkX1/IiHhTuBumZcnhR9Zm9NnAUjCeu6BKL0OZo/DjnDgW6BCfvXdCuvjEYixxnPV3ux6KC4fx4QV9yT3TOwZuSd+OzfOfpSY9ZAGGThASpMZHdiDZT0qHkEEr8ix2xT7QnCQkz+F0Dlj+wah+CKVP4enSoNV7EPOJMVosLknjSmtf+9xR2ixvMbuCnd887X3tC3OFAokyq1rhDToqayJKz1hZy+dysmHc4I+Nk9e4b36EsOB/7TK/YfcnpRDaJRKd0uD17m0KvTixM6ld7nqWz+qvaKH7XVsmAecs9L69+0xmYC+q/YGvMEcmMtbxdl8x+wvJ2pzlYi91qib4XXCEa9aB0hEImxSuKxNYYEpbhAjnS6Jsskg2FxdIC1nE6+zP7/pZTdbNYnmVlzolbzeLdDQWhwR3sXkyyrd/DR0ErhAODHbl3MS2Qr09k7ZBMX8iy88DksST0xaegJFSLenVTYtVqBt2Jz0H+tfs3n/Sg2s6tMGQyXJVM6pzhs8x+zZyZw1Imm0om3uWx+ZEKq2ej+Tm/jiPqrHcgWP4hsoDWr9OHLNQEUHCwxHwgMmgxVkMW3IEzvj3jByB/+0gVbO9EbFdv5PwS5CXVYvGaOIMDvyx2OQYhzUTGxuexpgGKCnqOeZBbg2KRFTw9GrDJilZ6AmVOuYuzhxjkmV/1CUCsSgnCDh6J637LwJIJfjcWXsZYDj/KJQObQiOkwT+9+2kQomdoLedlgKvmmSRpdivv1Qvz6Zw31IfuvnKGwjfcEUYhIPFUAP0Ai6Hroou0sPCmoFCy7Ag3+WUNWk0fky1c05SRNCXL63g7ukvO8dtQ17uqrFZ17u37d/XwMM52RzcyHdL9ECFO3sbdCTr0+92O34ZSFuf5G+xA/vYIlITCMXfz3evGEwSaVmFxGRGlCuBNVr3tTQWSQ1sfkpkk2pahKSn5m0kuNWlS/j9alBf+ZdlSZTHhPDx/e0
 JKoTALT2
 InPkK8Z+j64676IG0Gze9IUoCn96MBmtvDqhQbisNYE1sr7Nkn+HvT0g7S0puL7RSyanOk/x3vofAnD6fLuRR+/s/D2fFTDlCoxhKLh+piu1dwk8+eqbPWo9eMPzwrzFVCHqd7swjz6sdLzrubjxs0Mz1fVmoojI/kVSxBGxMi8F+K3RuKfU9wOCA6NTwL6ok7D0bQ5r+9DHylOV8zrSeveHAeudRioD+i0RaoT0rKqZy2PtFgfOZuErmNf++Ty3mmWkWrfB+Rj7AnIxSdoZNFMgtnVvEMxqh77Su+9DLBae/TauwIy4wz2Y0SoWAfFCDCS+ES4Cd5clAA+CswMI/W8SKHcdaJPFcsVA7I9t5hRF5cD221nScXDPoag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that builds a tree whose root is a full maple_range_64 node.
Ensure the destruction under RCU does not misinterpret the last slot
as metadata. 226 insertions produce such a root on a 64-bit build.

Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/test_maple_tree.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index b9367c61e8b50d107ab972fc5222fb6a531fad87..461bb0e4816ef6e9c670018a13a88a0e5d0cf89e 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3710,6 +3710,23 @@ static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
 	MT_BUG_ON(mt, ret != 1);
 }
 
+static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
+{
+	unsigned long i;
+	unsigned long nr_entries = 226; /* Build a full maple_range_64 root node */
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
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -3999,6 +4016,8 @@ static int __init maple_tree_seed(void)
 	alloc_cyclic_testing(&tree);
 	mtree_destroy(&tree);
 
+	check_range64_in_rcu(&tree);
+
 
 #if defined(BENCH)
 skip:

-- 
2.47.3


