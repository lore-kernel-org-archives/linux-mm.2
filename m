Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9402606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Px/pcQDJ
Received: by kanga.kvack.org (Postfix)
	id EC0496B05C7; Tue, 10 Nov 2026 00:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70C66B05C8; Tue, 10 Nov 2026 00:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12F16B05C9; Tue, 10 Nov 2026 00:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91CEF6B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E53F1C4243
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:24 +0000 (UTC)
X-FDA: 85418013408.28.7A42876
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49F02180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Px/pcQDJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3XKXyagkKCM8EvCF8Dv2F19916z.x97638FI-775Gvx5.9C1@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3XKXyagkKCM8EvCF8Dv2F19916z.x97638FI-775Gvx5.9C1@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3seM7JJG/qIc4h+h1T0VWvSmXn/fwRDakjk9Gf7qDBQ=;
	b=5ws6PgU+C1F8SpmhNrB9I3g8Dpc++tB4rrVjgzYoUfohsp+30I5vcl19vHXVSwPuYgnO04
	L+OIqOjW1RBr66c51QL0FCs6caY5VeaMUmx+hy5lXDPdAtis+cRwdx7DpFApUdkgHCcgGl
	V7cEL6abEppz9DpySTXPd8NSx7D5A6A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Px/pcQDJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3XKXyagkKCM8EvCF8Dv2F19916z.x97638FI-775Gvx5.9C1@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3XKXyagkKCM8EvCF8Dv2F19916z.x97638FI-775Gvx5.9C1@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286942;
	b=KCo46cb+VI22xm8PMqk+mt2yFLlKtK+4rRGEiKLaf049vbn3HFfABPm+vn9C5jjE6TzgN5
	laprHLnGwW1xVSvTLfbvQ+DW7r5rszxLEjqsFlTmnbFbyh9k/7NY9F+GyAQnhh6GQ7GuNn
	6YpVSuPm+gKuUwnQjJhGV1NHScLA6wI=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b570b713cbso2126882a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286941; x=1794891741; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3seM7JJG/qIc4h+h1T0VWvSmXn/fwRDakjk9Gf7qDBQ=;
        b=Px/pcQDJnzNWUDgCfd79s1psC5mSu+5KOjULNaoeLMEWZIcOeeD5ERsIW6ISNImxll
         msMydeLvZGrChhfh98/OvRPfNEDPaS5oN04SCdsGpnko3bBoFW7tjyXAeZwFbNOMbjew
         anpfKDIYbgCINMOOgc1QXPWN6QO73MkdQTSjv+0/o9NNoQkr6fa4ekSBFjvT1ziaMpKM
         IelVoCZlRffzL0z8aajhQDwJj3AnNetLTAZFTU/qrvSiAaGmXCSB6C1ygjKOf/yivOyA
         r4eztgo8IVsTg9NBVrQ1xG/JWK7OshRGnq5rqsP8XUlYDfPi9VLuej6hLOAvpy4+KvCV
         TGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286941; x=1794891741;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3seM7JJG/qIc4h+h1T0VWvSmXn/fwRDakjk9Gf7qDBQ=;
        b=rjpM2ZkqIb8UeI/9d+bLUtFVspHOWQSncHDhG8/RXvgtaJUZod9XFh/i6kld2klkNV
         0C5ytAiD35eJa4Xka+kS61zU5SX9kAWU3rfJgtk0xf2bkL1aacRSBY6oOiaME9pF4wOn
         0cC5s9z1dz4ZVoQBYvFesRrSz3w/Q00NMBgGRRHexuS/6hGVFeqtUJm0S1wOIZQth7Rz
         is+Bgco3JtY0pxM+yByQAPzmqotKvBhHtN5MqncT+AEgJb6PEFfs/yJ/J0kZcNVM8wdE
         LzSv0Rj7yKFkpJYN0kuxqrGAR6XxX+E2C0ztZ0H06voPOi981lk1KNdbK3DCJVvewyf/
         48kA==
X-Forwarded-Encrypted: i=1; AL+hErFClJqtRqnOj7N5AbxIL10r2CDSBCZe4jnlm0btAjS9OfIeqHpC15uUwm12wwkfRoM493hRIM/IMA==@kvack.org
X-Gm-Message-State: APuU4Z/n0jGfRQaYZvp9VJtABZzgN07U56k6acNyDUtHId7VpqmQ8YvW
	CZ9llBTQzbwS/eGCJUm7WA8JBZjhnFp33lRgh6HAmpkhlNNrG2qZmjO5/XJiu9r7cdhZGyDX8Le
	+bn7KnDY/MbnAE+988A==
X-Received: from edl8-n1.prod.google.com ([2002:a05:6402:4248:10b0:6b1:a845:1d31])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:d896:0:b0:6b7:2969:a2b4 with SMTP id 4fb4d7f45d1cf-6b756aeeca3mr787329a12.39.1794286940631;
 Mon, 09 Nov 2026 21:02:20 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:57 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-15-tarunsahu@google.com>
Subject: [PATCH v4 14/19] liveupdate: Add feature header to struct luo_flb_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 49F02180005
X-Stat-Signature: jtk3gprwcjw6dpe4kz39z7feu1yzn9iu
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286942-755016
X-HE-Meta: U2FsdGVkX1+6UzyJF3U7nneIfC6MpAexK26ooKoJcz+4lN9dXRZKe1xZRoBszwNudIJfEntIYShrnULfD41fgEyAGTwOlRpeTDIF7q+29MVri5tHgM14rLMG0B7KZuc2DhbluJFqD6FozEl1Tjut7Zjp9nCvbjBlW+LxNLapfVtzTO3YyD6V/7rLti0f7HU7oS8kDFsWk+1Qop0juK3tQCXQyYpLCam5a5GDtN/WVgH7G3QmCc1goate0XBrS5MAmbXK6SExLT0oixhAHT80lTOeBBDMWPiwci++MGDiNsb80rcuGNLZEmkjvjgGzoUK9atOd8eKO7Bg21gGSDO9FalSn+9pf78rgwQEupE7C7MiytUTfFuwWB91ZKzpbg9biRqar4JVwrx2xvoIbYIW3i9HLPGq8RdXP4ccd65wy06Trv1J+xyWlSIDSM7L+nzpHF1SjoDaHCDKEETyUL61Er9QJ3HSJDCeqM0/T8lmUNAgByBmIvaAmsuwOa552HYx7kqhdtE8w9MnMa6kOsV865DQfxkT9QaxQHj7Eu8BSaldw2YAKsVgVXvrEuvHBlVCpowy5CUYrRJTj3psKgs3fy8i60YgpRRv/YVVT7yv36xXi1RlnGv82dCJhO2wCR7Zky7FgOAeBeNhMYjzMkVXdzIkVkj6VzKNKVnaM9biwyM+ACPnUBPLySNdrc1H1Jm+nm0HSXn80LPPLK/1rICxMeCPtPgMfBGDpvfMSlgYvOFNbUbqtsewaKHq8NZj+1KCtwjd+i0x7XSQQtKWzZq8QlARskl4ODvNZILcn7LQGTKlrmDKGLrLN0Q5hKOT44/bDxUURRD1HFHK6uhmfm9U11pnXIafuHjbxtqPIwcdDaKm+lrSP9PNY3ieK1JsVhhV1pUMaX2jK2+tTy4pCeqCOlz9HYBPCZSp3GBCJRr2ZT3eYIh6OGmagCNbC9QA+7dklnmSkK0mESc7M1NCwGF
 fICGf7l9
 HTmvGJCLCmpqujFFe8n065DbvJSn7CNlC2ibVaZAkXtln5HUPDNkzxpZ0q6XT9Z0dtfULWsudhij53bRmjwlAy9d4fCVEZk35ux9wYhIVogOUG2PpM+8aG/wm1/UAX0HDYSyD5ZNEc/AJ6Qa27NWSB+xIpJoFcsvP5QCABrXGMLG5pOBSHpm6ZH19SwCTmD/4dQpuFzB7WpZi4dEUX1VH6CxXAtGCZcLGCtEvgQ92dUG2HCTJ4UZb5mWV9RPjjUqI055wK6SYyvE6tlPzNRPZaReU7bWHxQa83aFyl1QG5VpYAbuwK75Fj25mDE511dZ7wnnLhvBzH7Bw/Lfa/U3cwMLaPyA6cDkesDpa01Xsg0Zgp+8kMV/VTTWX9pfxuYFSAKnefXk34WFkO9hPuMkIOF6obil40YVcadAiv/WX3vOHNGVerJhg00VwFHRc5wcA5EWM7MOTmKJPgt9d5GuZbnSQTL61TV+UtDQBtRAZd22CJBAuWW2PNjAJYWkoSxbrFa3hvUPJJz6tOCULiuGpm930LwERft44KmTzbFCwokzG7luk8Alv2XLQq1AV7rCNUI0GBaF6/4EJsnDEUmNN3j1gPImyGszNC/f6n1I5LS9R6RQ/aArWmVe2z5E0ov4NSTK2XKTftKnumj4Q0NY6wATPeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede each serialized File-Lifecycle-Bound (FLB) entry in the preserved
FLB array with struct kho_ser_hdr via DECLARE_KHO_SER so future FLB
metadata features can append fields to struct luo_flb_ser without breaking
compatibility between adjacent kernels.

Compute LUO_FLB_MAX and outgoing entry offsets using
kho_ser_size(luo_flb_ser), and initialize each entry feature header in
luo_flb_serialize(). On the incoming path in luo_flb_retrieve_one(),
validate each entry feature header with kho_ser_validate() and advance
between entries using fhdr->size so entries written with a different
feature layout are traversed accurately.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h |  6 ++----
 kernel/liveupdate/luo_flb.c | 39 +++++++++++++++++++++++++------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 4913707ba0d3..1b660d41bb90 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -181,7 +181,7 @@ DECLARE_KHO_SER(luo_flb_header_ser, 16, 0, 0);
  * passed to the new kernel. Each entry allows the LUO core to restore one
  * global, shared object.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
@@ -189,9 +189,7 @@ struct luo_flb_ser {
 	u64 count;
 };
 
-static_assert(sizeof(struct luo_flb_ser) == 64);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_flb_ser) == 8);
+DECLARE_KHO_SER(luo_flb_ser, 64, 0, 0);
 
 /* Kernel Live Update Test ABI */
 #ifdef CONFIG_LIVEUPDATE_TEST
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index a8dcdb8456fd..d38c223741ff 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -53,11 +53,11 @@
 
 #define LUO_FLB_PGCNT		1ul
 #define LUO_FLB_MAX		(((LUO_FLB_PGCNT << PAGE_SHIFT) -	\
-		kho_ser_size(luo_flb_header_ser)) / sizeof(struct luo_flb_ser))
+		kho_ser_size(luo_flb_header_ser)) / kho_ser_size(luo_flb_ser))
 
 struct luo_flb_header {
 	struct luo_flb_header_ser *header_ser;
-	struct luo_flb_ser *ser;
+	DECLARE_KHO_SER_HDR(luo_flb_ser, *fhdr);
 	bool active;
 };
 
@@ -159,6 +159,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 	struct luo_flb_header *fh = &luo_flb_global.incoming;
+	DECLARE_KHO_SER_HDR(luo_flb_ser, *fhdr) = fh->fhdr;
 	struct liveupdate_flb_op_args args = {0};
 	bool found = false;
 	int err;
@@ -177,10 +178,18 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (!fh->active)
 		return -ENODATA;
 
-	for (int i = 0; i < fh->header_ser->count; i++) {
-		if (!strcmp(fh->ser[i].name, flb->compatible)) {
-			private->incoming.data = fh->ser[i].data;
-			refcount_set(&private->incoming.count, fh->ser[i].count);
+	for (u64 i = 0; i < fh->header_ser->count;
+	     i++, fhdr = (void *)fhdr + fhdr->size) {
+		struct luo_flb_ser *ser;
+
+		err = kho_ser_validate(fhdr, luo_flb_ser);
+		if (err)
+			return err;
+
+		ser = kho_ser_payload(fhdr, luo_flb_ser);
+		if (!strcmp(ser->name, flb->compatible)) {
+			private->incoming.data = ser->data;
+			refcount_set(&private->incoming.count, ser->count);
 			found = true;
 			break;
 		}
@@ -573,7 +582,7 @@ int __init luo_flb_setup_outgoing(u64 *flbs_pa)
 
 	header_ser->pgcnt = LUO_FLB_PGCNT;
 	luo_flb_global.outgoing.header_ser = header_ser;
-	luo_flb_global.outgoing.ser = (void *)fhdr + kho_ser_size(luo_flb_header_ser);
+	luo_flb_global.outgoing.fhdr = (void *)fhdr + kho_ser_size(luo_flb_header_ser);
 	luo_flb_global.outgoing.active = true;
 
 	return 0;
@@ -594,7 +603,7 @@ int __init luo_flb_setup_incoming(u64 flbs_pa)
 
 	luo_flb_global.incoming.header_ser =
 		kho_ser_payload(fhdr, luo_flb_header_ser);
-	luo_flb_global.incoming.ser = (void *)fhdr + fhdr->size;
+	luo_flb_global.incoming.fhdr = (void *)fhdr + fhdr->size;
 	luo_flb_global.incoming.active = true;
 
 	return 0;
@@ -626,10 +635,16 @@ void luo_flb_serialize(void)
 		long count = refcount_read(&private->outgoing.count);
 
 		if (count > 0) {
-			strscpy(fh->ser[i].name, gflb->compatible,
-				sizeof(fh->ser[i].name));
-			fh->ser[i].data = private->outgoing.data;
-			fh->ser[i].count = count;
+			DECLARE_KHO_SER_HDR(luo_flb_ser, *fhdr) =
+				(void *)fh->fhdr + i * kho_ser_size(luo_flb_ser);
+			struct luo_flb_ser *ser;
+
+			kho_ser_init(fhdr, luo_flb_ser);
+			ser = kho_ser_payload(fhdr, luo_flb_ser);
+			strscpy(ser->name, gflb->compatible,
+				sizeof(ser->name));
+			ser->data = private->outgoing.data;
+			ser->count = count;
 			i++;
 		}
 	}
-- 
2.56.0.506.g506a7eabc5-goog


