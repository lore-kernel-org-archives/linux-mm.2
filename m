Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDA5606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CtzFlieS
Received: by kanga.kvack.org (Postfix)
	id DBA006B05C5; Thu,  5 Nov 2026 00:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92AC6B05C7; Thu,  5 Nov 2026 00:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31E06B05CB; Thu,  5 Nov 2026 00:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949E56B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71CC080648
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:05 +0000 (UTC)
X-FDA: 85399866090.07.3B587C3
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C8A94000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CtzFlieS;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x15wonZx4YKLKAV2h6RvhaJYvivDTh63oWX01b1gV+8=;
	b=0EjlhJrCOGQ/LYLweUaYsXnRbvUSX/i/4pf9FYhxk/FMCnw8Jz+UzmxS6MKJaDXUTWA82j
	lsu7zTWAu0GzNDfms7NOKsVJNWfgjKXcZ1P/J7cDWVjxIx1BHGveZc5ACUMWNCpe2xEMpA
	kc/afD9BxAvQQN78l1V3c5yQK9HdE/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854863;
	b=YgKeAIE0cVvcP90K9RZC3DsyVQnuPZJYFLNwvOZ+KMWasc1BHc7MNJ43CnNtdYzE3kJDJy
	XboRhYAQsf7ArOi/1LykUFLlRAgeHUAcri6+BG9+7RBFAspL8FyPCKIj0PJF2u4Zq987VN
	+5awXf5G8yYwdqzp+LONAV47/TOS+DU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CtzFlieS;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7d06ecaf709so780708137.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854863; x=1794459663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=x15wonZx4YKLKAV2h6RvhaJYvivDTh63oWX01b1gV+8=;
        b=CtzFlieSEhp/MAmrz6uOf2TfoAnaSupBKSf2AiuHvaj5PbSaOrCF6J3oitBYZ3eiSq
         nVmcBzk9nu+xNrVR1oAVWiBUC685zAcgtKEOPXKArSGEcELtVt+EqPYw69hie6FtwuAN
         Jx7xHsmD8wlTEU2qRXSAO/NzUj8t15BTPhyn020N1wO/35UOilvkJyisAGixXnhu5l5k
         c67o8kZAj6VDL0kmkszj9NPXgTNJS/tE0hZSG01xkf9r4tnegJaPCh2uEff20YzY+O1o
         V2N3NjKnfAyfJBObcnmKuRKl6o4CC2OB4rYLxGIGN7Qd1HebAAdoYvTU8kY+E/f9EI/B
         h4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854863; x=1794459663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=x15wonZx4YKLKAV2h6RvhaJYvivDTh63oWX01b1gV+8=;
        b=hnMykWD+jmQI7nB2K9WMQ8UVXJJNYmrl1tWd4p3x0+PBkFAzOmGzr5j4TyeOHNCuSj
         i6yRl17b69Oee1Ld3nwucD2EqIxFQ1QYOPbLo3CA2Ags3dzxJFWah305/8kO8nPgDK50
         DMyroL6vkcBoHHS1IrDF1j2EC/ue1v5cWtLtOdeksh8X+hrzLl5hhY4P/AXRg8vCh1Re
         AaJHKg0u1YcxktzTO5PUA1aHfTGlu09Qp20A7hDlH01WnzOB12Gj/FCq1wApgDjKassg
         Htpm5G5c/SH/uZ+vZ7cggtkBeUa8t0aPgYwjXAvK3uci5CCAzztl5ZaknG/Otq0MfK3J
         rYCw==
X-Forwarded-Encrypted: i=1; AKwUvBwKszuYfzdvYdEO1h49yfXxQqVwHfG8y89Su4XTonoEbl5n++IYBqriq7bPQRo+dQaHbbiMnCrcdg==@kvack.org
X-Gm-Message-State: APuU4Z+i/CIau9l/kgqgYgkCSVNQmOamI9ZZRXndLOOpRAdbKOs0X0uL
	BjpCV9lurpnoZQL/eWXKnNanKqblP2R9mN1cnPdRPI6+IjIYlRsDH1VuIjAi2ykhEIU=
X-Gm-Gg: AYBFou0dX4YAhC2OyujsGPE9RYxEjmHOb3lqUicHWjTuOYphpUkJYqbGd0NeGottpYd
	QP/aynrYUpzSNnPjCRKwd/pLqx9n7SGnc7+Yj96AwrCHFpLrTudhvqCfL2kFHmswX/NUwn0Eeso
	gExEjcZU8cdRepVZkpugyeQiPitQvSrpleNUhHzaJvurIvfrCCH9UYlGdT9IgMROYpesRV9Nf/6
	PP+ElGjBaMn4HGouPAeNfSrE5IVhkQ4ATvlfDY+tBx0p+tf6AZf8IsQEHn9ATm56I2/dgbZQ/y7
	/Gz5qUnI6UTcxmyee0W5vWMmAmYAQI8kUh8ldxt73jE1VrGXcOs/vgP9CvZxxnOGpCKyWgMngf8
	rtxacHZEoMHfo6TTHiA00BctdhB+1RDDseytzpKy8XDzQqwSy4Qyh9dhIOCcSDOTTjeT7DSsv4z
	nFKTMEv3AESIjlINnWtthGf/KqOiF7NtACtxOFTWhrLX/4t0DtBZXCQd7eo0h27k7Z0civbdWGS
	+cE/kSb7QUaOR/xn1D+B1jHy/cd1QAllToVXO6oydEz3s2vbhtVkfx0qkXg1g6bD1kr1wjkyDzD
	Wnc0gXs2ZJ0VjY+tFmkqsZqC5X1d2vNdq8PHFk8U8tGalYABDkwiEWnMoFNqfsPwLtBgTTb69s4
	uMkQ7F4QlYTctvherUHBrXmXcqUTFoxI0km/roxso7bZHbr8svA==
X-Received: by 2002:a05:6102:2d0e:b0:7cc:174b:f7d8 with SMTP id ada2fe7eead31-7d072247ab2mr8278473137.1.1793854862693;
        Wed, 04 Nov 2026 21:01:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:01:02 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 4/6] liveupdate: luo_flb: support incremental outgoing FLB publication
Date: Thu,  5 Nov 2026 00:00:50 -0500
Message-ID: <20261105050053.3063001-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 38931fw5wiccgajp9acasnjmhhjcrprd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9C8A94000B
X-Rspam-User: 
X-HE-Tag: 1793854863-621309
X-HE-Meta: U2FsdGVkX1+U9NH0zA5xYmncR7e4Y6YTUt/eR7IaQc19j668KkFakSGF0uMeCiM3ETIQwlAG/Y16xRbhLt/Jik6aTgiXj6qM1YHdktfHGwRSbgUiJHb9hF62xN/7yNo7Ju/cuJJq0ysAtgPfHWDlVcU16hF/IrDlITMQMfwkAxQDFzjn/m8c/T1ZM0FOLW41ePHq7RAE1BwF7+n6nn+s/jOxiNoKO9TE+NgFXT3rbGX5HKAxFsJGZThuwJCsnff9edIKawq8zw7QZ9T/H1ML/o8WQyR/FjmaO3Qr2QTUvzQUIacKAfcpwDuH0V5p9eYRtMS6q8qMAZ89PsF+9FMYlSGDUnZRl4iJU01VzEP/+RBkatKgtDtA63M8ZuFjRZLrOcNDkqnNw48bl7GgQzK3cAdQlke1TfG6nYNSBjlTTMawZ0zzHAvbENK5IbNPt2B3kLjOJ0llUX/A7Z6QdVbn4V+qvddC6eBsFdq2m5DJwsOU66cNqpQ9z48z3wVGTpsKg98R9YsCpoYR8R/ai2RSXZJ7blDKet579ez5UJ/gjZKdi33icou3ODx+yXR0PFtQPoA+0V3rTS4+UzFEhCvuOjGm+/YQacO1wntMLouMn3iQ7MxD1/8UHorb3arNAKHcw8mfPyq5P21UpamjSBZ1+PjLGCWjuAqa/vM5C4cxa56RIBcehED+rTKSYGMvKLcNg7WasyiK0yOeVOxqDUNihJpPdg1YTrAlgVTlW34DZeOno29hlzxT10Dbe4jpAcBUoC508vVxcjbzvHl6cWdGxu0tsQ1OIKrNbpxcjyOJ5Ppqx+f/etJtnskkYDbPix3LuUB0n0DdhlYTAfROrbR9f3Xz0hRlvKrnMDAnrLyD09jgX2jOSTCFnWn8wLrIhKtgDrqDG6+0qikW45tjYcyr3Ecx4AW4i7jTVis/+iciLAb0trQbrruqtYQ1aSlTBESpzb+fj6v9oxjIUGnzFBk
 SiMkqGpK
 ADnSBYfC8i2HMAm/5GM7rQdBZQ2LZY+NmJPAV3Zb38z9oSKfIimg5Tx9f/MeVMUNnjrpR9TmBaZkZdGVFVv3sJ/HEFWV7Hm/U7iJh4uiFqiLBC1FwiFrnpWncVe2LxLMbqJEsL7wed5neAqyVUnTHy+D0WSl/iCuz1WgUDWrgvOQO8652v4ZBrlWKuC/Smu3Qk9Dt20bBBGV/W0nRZWj0iWqyWQWWV0OQxSPSYO89XP1WfD4GvG+ycNQT00AjgXmvqaoivCVkAKoRulYO0oY+NIzXuvAsezxAFMvtnUNFtNdJLaqB2SlPmA8a8U25vnKkwMT7bm6VOtjuLew4QUgdoF//0K8fcTdTs3Qlld23SSlUahzlq6Ej2jd53Ikt65e0iI9uAKNOSVZCZqyENZUOvyjNytXHxF4bdaFltifP6dRZOxQCsehg20F551poCwet1Qrz3EogYGT4BqDyxCIGpuJeEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a session is published to KHO via luo_session_publish_one() ahead
of reboot, any FLBs that its preserved files depend on must already be
present in the outgoing KHO FLB array so the KHO tree remains
self-consistent.

Currently, outgoing FLB metadata in luo_ser->flbs_pa is populated only
during reboot by luo_flb_serialize(), leaving luo_ser->flbs_pa empty
when sessions are published earlier.

Publish outgoing FLBs from luo_session_publish_one() via
luo_file_publish_flbs() -> luo_flb_file_publish() ->
luo_flb_ser_publish_one(), and drop the now-redundant
luo_flb_serialize() pass from liveupdate_reboot(). For each published
file, luo_flb_ser_publish_one() either appends a new luo_flb_ser entry
with count = 1 using smp_store_release() on header_ser->count or
increments the existing entry's count in place, keeping the serialized
count equal to the exact number of published files in KHO without
including uncommitted sessions or transient
liveupdate_flb_get_outgoing() references.

FLB publication is one-way and never needs to unpublish: before reboot
it runs only when a session is committed, and a committed session never
unpreserves its files, keeping private->outgoing.count >= 1 until
reboot so flb->ops->unpreserve() is never called on a published FLB.
If more FDs using an already-published FLB are preserved later,
flb->ops->preserve() is not called again; file handlers update the
shared live object via liveupdate_flb_get_outgoing(). Consequently, FLB
handlers must:
- return a stable root KHO handle in argp->data from .preserve() whose
  address does not change as FDs are added later;
- synchronize concurrent mutations to outgoing.obj with their own lock;
- support per-FD rollback when uncommitted sessions close without
  disturbing already-committed entries.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     |  10 +--
 kernel/liveupdate/luo_file.c     |  16 +++++
 kernel/liveupdate/luo_flb.c      | 111 ++++++++++++++++++++-----------
 kernel/liveupdate/luo_internal.h |   3 +-
 kernel/liveupdate/luo_session.c  |   2 +
 5 files changed, 95 insertions(+), 47 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..9fef5161a1f3 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -219,18 +219,10 @@ late_initcall(luo_late_startup);
  */
 int liveupdate_reboot(void)
 {
-	int err;
-
 	if (!liveupdate_enabled())
 		return 0;
 
-	err = luo_session_serialize();
-	if (err)
-		return err;
-
-	luo_flb_serialize();
-
-	return 0;
+	return luo_session_serialize();
 }
 
 /**
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 988eb313a135..611b9967a3a9 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -380,6 +380,22 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 	kho_block_set_destroy(&file_set->block_set);
 }
 
+/**
+ * luo_file_publish_flbs - Publish FLBs for all preserved files in a file_set.
+ * @file_set: The file_set being published to the outgoing KHO subtree.
+ *
+ * Iterates through all preserved files in @file_set and ensures their
+ * associated FLB metadata is published in the outgoing KHO FLB array before
+ * the session itself becomes visible in KHO.
+ */
+void luo_file_publish_flbs(struct luo_file_set *file_set)
+{
+	struct luo_file *luo_file;
+
+	list_for_each_entry(luo_file, &file_set->files_list, list)
+		luo_flb_file_publish(luo_file->fh);
+}
+
 static int luo_file_freeze_one(struct luo_file_set *file_set,
 			       struct luo_file *luo_file)
 {
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cd715a7c1d99..6cd87a9f8307 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -34,6 +34,15 @@
  * This reference-counted approach ensures that shared state is saved exactly
  * once and restored exactly once, regardless of how many files depend on it,
  * and that its lifecycle is correctly managed across the kexec transition.
+ *
+ * Serialization: Outgoing FLB metadata is published into the KHO FLB array
+ * incrementally as sessions are published to KHO (when committed early via
+ * LIVEUPDATE_SESSION_FREEZE_COMMIT or during reboot). Because a committed
+ * session never unpreserves its files, FLB publication is one-way: once
+ * published, the FLB's .unpreserve() callback is never invoked and its root
+ * KHO handle from .preserve() remains immutable in KHO, while later sessions
+ * may still add or remove per-FD state in the shared live object under the FLB
+ * handler's own synchronization.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -72,6 +81,13 @@ static struct luo_flb_global luo_flb_global = {
 	.list = LIST_HEAD_INIT(luo_flb_global.list),
 };
 
+/*
+ * Serializes updates to luo_flb_global.outgoing.header_ser and .ser[].
+ * Lock hierarchy:
+ *   luo_register_rwlock -> private->outgoing.lock -> luo_flb_ser_lock
+ */
+static DEFINE_MUTEX(luo_flb_ser_lock);
+
 /*
  * struct luo_flb_link - Links an FLB definition to a file handler's internal
  * list of dependencies.
@@ -104,6 +120,36 @@ static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
 	return private;
 }
 
+static void luo_flb_ser_publish_one(const struct liveupdate_flb *flb, u64 data)
+{
+	struct luo_flb_header *fh = &luo_flb_global.outgoing;
+	u64 nr;
+
+	guard(mutex)(&luo_flb_ser_lock);
+	if (!fh->active)
+		return;
+
+	nr = fh->header_ser->count;
+	for (u64 i = 0; i < nr; i++) {
+		if (!strcmp(fh->ser[i].name, flb->compatible)) {
+			WRITE_ONCE(fh->ser[i].count, fh->ser[i].count + 1);
+			return;
+		}
+	}
+
+	if (WARN_ON_ONCE(nr >= LUO_FLB_MAX))
+		return;
+
+	strscpy(fh->ser[nr].name, flb->compatible, sizeof(fh->ser[nr].name));
+	fh->ser[nr].data = data;
+	fh->ser[nr].count = 1;
+	/*
+	 * Ensure the serialized FLB entry is visible before exposing the
+	 * incremented count to concurrent KHO readers.
+	 */
+	smp_store_release(&fh->header_ser->count, nr + 1);
+}
+
 static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
@@ -296,6 +342,34 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
 		liveupdate_flb_put_outgoing(iter->flb);
 }
 
+/**
+ * luo_flb_file_publish - Publish FLB metadata for a preserved file's handler.
+ * @fh: The file handler of the preserved file being published into KHO.
+ *
+ * Publishes each FLB associated with @fh into the outgoing KHO FLB array on
+ * first publication, or increments its serialized file reference count by one.
+ *
+ * Context: Called when a session containing preserved files is published into
+ *          the outgoing KHO subtree.
+ */
+void luo_flb_file_publish(struct liveupdate_file_handler *fh)
+{
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter;
+
+	guard(rwsem_read)(&luo_register_rwlock);
+	list_for_each_entry(iter, flb_list, list) {
+		struct luo_flb_private *private = luo_flb_get_private(iter->flb);
+
+		scoped_guard(mutex, &private->outgoing.lock) {
+			if (WARN_ON_ONCE(!refcount_read(&private->outgoing.count)))
+				continue;
+			luo_flb_ser_publish_one(iter->flb,
+						private->outgoing.data);
+		}
+	}
+}
+
 /**
  * luo_flb_file_finish - Notifies FLBs that a dependent file has been finished.
  * @fh: The file handler for the finished file.
@@ -587,40 +661,3 @@ void __init luo_flb_setup_incoming(u64 flbs_pa)
 	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
 	luo_flb_global.incoming.active = true;
 }
-
-/**
- * luo_flb_serialize - Serializes all active FLB objects for KHO.
- *
- * This function is called from the reboot path. It iterates through all
- * registered File-Lifecycle-Bound (FLB) objects. For each FLB that has been
- * preserved (i.e., its reference count is greater than zero), it writes its
- * metadata into the memory region designated for Kexec Handover.
- *
- * The serialized data includes the FLB's compatibility string, its opaque
- * data handle, and the final reference count. This allows the new kernel to
- * find the appropriate handler and reconstruct the FLB's state.
- *
- * Context: Called from liveupdate_reboot() just before kho_finalize().
- */
-void luo_flb_serialize(void)
-{
-	struct luo_flb_header *fh = &luo_flb_global.outgoing;
-	struct liveupdate_flb *gflb;
-	int i = 0;
-
-	guard(rwsem_read)(&luo_register_rwlock);
-	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
-		struct luo_flb_private *private = luo_flb_get_private(gflb);
-		long count = refcount_read(&private->outgoing.count);
-
-		if (count > 0) {
-			strscpy(fh->ser[i].name, gflb->compatible,
-				sizeof(fh->ser[i].name));
-			fh->ser[i].data = private->outgoing.data;
-			fh->ser[i].count = count;
-			i++;
-		}
-	}
-
-	fh->header_ser->count = i;
-}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 01a172cd9d7a..a7253b48df80 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -103,6 +103,7 @@ int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
+void luo_file_publish_flbs(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set);
 void luo_file_unfreeze(struct luo_file_set *file_set);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
@@ -115,11 +116,11 @@ void luo_file_set_destroy(struct luo_file_set *file_set);
 
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
+void luo_flb_file_publish(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
 void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(u64 *flbs_pa);
 void __init luo_flb_setup_incoming(u64 flbs_pa);
-void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index caf0e85081e8..713b9b400f07 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -233,6 +233,8 @@ static void luo_session_publish_one(struct luo_session *session)
 	if (!sh->published_count)
 		kho_block_set_it_init(&sh->it, &sh->block_set);
 
+	luo_file_publish_flbs(&session->file_set);
+
 	strscpy(entry.name, session->name, sizeof(entry.name));
 	entry.file_set_ser.count = session->file_set.count;
 	entry.file_set_ser.files =
-- 
2.56.0.398.g882cbad275-goog


