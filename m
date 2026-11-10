Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D743606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UmKduHwW
Received: by kanga.kvack.org (Postfix)
	id 5BFB86B05C1; Tue, 10 Nov 2026 00:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549036B05C2; Tue, 10 Nov 2026 00:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410BF6B05C3; Tue, 10 Nov 2026 00:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEC36B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DA30A85E1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:19 +0000 (UTC)
X-FDA: 85418013198.18.DE21702
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id A921D80002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UmKduHwW;
	spf=pass (imf02.hostedemail.com: domain of 3WKXyagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3WKXyagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QH3sulygYhhWPnxKAIiCVfW20U0EPZtpLbJ/h67Rp6Y=;
	b=lNQEuMjCWJNjgCMEenntDrOjKIOaXey9UEPmrkqwa6GBhfSJ6BRH5O7eaa7iILKwt5lh/r
	lt7eEgxgMwomvFNnAsS+D4NjLBjpMyb72xf2IHWsPM5OyIayamE32DCugW2yKctxr8Nw7q
	ofA2ckQ2Te9ejUOBo37hHrVLgpmG61I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286937;
	b=WednW4Q2FxpHkDlMuIwhMkhQvM2ACkhGsnuuz/FSfLsu1bLAwDC/ZHGADLEIOqghJX9qjh
	vtapFjNcACm7UPcblSY4EC0g8gsV+WqR8vkUAF/s+QyroQuJoCjAur/NdIQVC5NciwJv08
	eFEdQQWrYO5ILNnz7Z+49BChVsPz9CI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UmKduHwW;
	spf=pass (imf02.hostedemail.com: domain of 3WKXyagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3WKXyagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so11744045e9.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286936; x=1794891736; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QH3sulygYhhWPnxKAIiCVfW20U0EPZtpLbJ/h67Rp6Y=;
        b=UmKduHwWze9wCPYpyqMnni4AQGyYJa3UveN2T04zgpA6CEfOi9mgYfEy7/rGVysUm6
         8PJ/JbGQnzGRwDaKtU03XxSTdCR6pblS5BsAaYtnGj1EBNhy9z3+CV0J9a8TxHDAi3pT
         NbglPFrJCeDOCJeDJYPBYMatfCYDgEm0l0L8z2+u8rCzIRjB5Oed8hleHrV5XlGmUoXF
         MN0q1DSJmxpm425pjyZncJ72WCzY+3wWMdgrlLVdfVS/nCXNpjMdDof6IcRMsjYnQvA7
         sGMs62D9IHeCn1a5y3nJV7wAZvEcoQoGupCweM1yDvIGDqN7g25CWUyASwK2V8uhjEtU
         OTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286936; x=1794891736;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QH3sulygYhhWPnxKAIiCVfW20U0EPZtpLbJ/h67Rp6Y=;
        b=SSaKDI4CEag7+4vXip5e424+8XjGFmSwfXEt15dfQACXa5k2Sz0EOFfxH1NSpQk6o1
         /DIlSJ9BmAW6rrmwd4subp6wQ6S9uTAhow0u2yJ2WCuWB78IiW65K2HqM8XQDWeT7Dkz
         H0zM3PHI3oJ+iBtPbOlAnocSMGEKK4ipDiZFspWhjtpZOOKXJ0a72qdOzGc0d3XgbWRl
         G/ZEHLzPpcidtALcrS/wZx+Hgp6QONXUD1j0eKF8GXhob2r09lgaG6Wp4kL0a8/vqlCb
         loMdHD0WbdpCc62+1GKdyk5DiF0OYkXf6BQ+nMwotU3wQUueRiSWqxszSS1zRflpl1Rg
         c1xA==
X-Forwarded-Encrypted: i=1; AL+hErHEQIJVdd22ugKq22/YRY39cIRAoUO/bWbAKu+ZiCMBzjqMqY65pnjeG+XbqTxZVNzkZbdLX8ozMQ==@kvack.org
X-Gm-Message-State: APuU4Z89GDwFsvfCaHWpKMgqHyAMeVEWXcLrHZjHAoB4L02dBskKUynL
	m2kzrn6efLL3yDqrImAXxK/1RYpcPlHlgC32Tvr8wa7gxpLdn7/G9HerdSdz1QRABS0z0+0SjMv
	HvC1iMtckV7WzscKcgQ==
X-Received: from wrvd15.prod.google.com ([2002:a5d:538f:0:b0:48e:1449:1f6c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b9b:b0:4a5:a5ca:de1d with SMTP id 5b1f17b1804b1-4ba023577bfmr24128895e9.30.1794286936085;
 Mon, 09 Nov 2026 21:02:16 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:53 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-11-tarunsahu@google.com>
Subject: [PATCH v4 10/19] liveupdate: Add feature header to struct luo_session_ser
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
X-Stat-Signature: c1zykzgieyrux4fe5bworayoqaeqrrpm
X-Rspamd-Queue-Id: A921D80002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286937-379452
X-HE-Meta: U2FsdGVkX1/j18uMfdE3iRKUePa7Gd0k5Ld370RXKuKlftI0mozKVARzHBcB/MRw7E3xe3RPv583M631LuskcMlCPCNf8AJxyIr7jZH/nEhb9x6nGR1tZDQszpsC4dXOAjuSa5aN5bb49e9pBYDJKmEV27VopHJZnS6PVllC/rs0lX+oJosGOhry4f5s2B/PC4y0BSAxr82MezpodrD5qFWHbmSohf+Jgw6IkcVyF/uX10Kj2tAuwEMXBChuxG4dWX56pgFaq+yNONOFVu8Xlq/a7olDJkjLAqftbmZwz1DZCtDxAFOYqWKUsz1jpE/bqkq/6mRkWfpn4ot6f1sAb301R4UN9xfdtKxrYQZAAtTwzArR4uexOzcopQdldoHoKQgRKp+NRla5Jbrq+KWer1Qv2ZHHM/0wgsqq8dnQPNPwccsXCzSjO9bfuFjpIX3PH6VCVc+GjSM7GFGAuq7KqfOgrU0NgevbbaOuob8zWlrUz36SO5kx8mEeyBKxiSJ84jbKBjjVOf2wkSKBL0qMWz3qeYQetr1WEemtWlRQd+9eEG5njIDmgR344GagtncPYNDoUEODgEj9+sD610hQmOwuBwhqe4ceUkg2eNpi10XMDDJBLSpKw4F6kL06/rRb2rLf6Ia+pZRacl6JN0xk2FFHFqgqWVrChh/Dm83W9erjfZAEIyKfaEjFV1RzccNXDup71vBEe0f6CL8zEg6F3HkipG67sRT94lhiPeGmJV68ADfSjI8jMYXvGEiMj13M6VgS0sndRkye+zCIQ4ABNKARhR7POeNYbvlSsqL9lgvX1RpSrhJC1CiNo2k/ainvND6vxfMpEfrtbG2ZB9t9vhsaBLx8QzBqwTjGJi9eARnAbkC281cmOjoqK0EQmjHACcqQMRDblLg9D6O6eZNXaO9dO182e08/q2VQd4AO8LFc/u45IuabD2ZzUnLc+hQCCKGhZvWYBizWHmCi+Qw
 7WBEICq4
 rgNwlrSDnsZ/VKQcV2iXbvAlR7YP3xR8NNC53X3vQRBWg7bLFPDEFpAs0sEnLMyaFaYF95s3uQmOWIccCbiJg6mhPXEfJEhB/jtgbA3wAqlJBshRNDxwh6Y9NkH10dtxxbeuqnZbfaaaN8iMYNPiUx4BmqMTs2bdM5KIriiimTapdT/leJiIK2uN8L137pC+O9orLMvilJ8mRkQwgTZqHgCoRsxWOzEXgeFZixTSZfBB0VSoGWMBqmbDEdUSilKlhe/qwWqtklgH8C88hfJhZs57V5eIZxR/C0RCel476goF0hMWnOftCEvH4IrBkmyFVqKMEhMbjUkajs07rT6hKREKIBy1mLsHvU9yTglJk/rz12n2nEfgCYUdFReeEE9gKSgJ7OA96GjI5VS1I/LflJJAz64MGafhAcvL1vbzbg3b382CMPvfDWOL+X7RTn5BId+eLL/lnpyXVOsbZ5FPR8UL3u0MvLWwEV+94Fu3IDSdx6rMh7/Lqvkr12pMxKnnjVkQdHJVqrChFsV/+XnEJEWcZ5gcWqeoZkUMeD/NcJlKX39KOBTC7cE+Io4GAflfCZ8+enAO0D2KikjiyVhmmUsjcvNtlIp3SRrAqyitn8hhMS1uUik0e5u7c3ys6CsKMLERd+C+1e41wK15ks5NiK8ZW5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede each serialized session entry in the LUO session KHO block set
with struct kho_ser_hdr via DECLARE_KHO_SER so future session features can
append fields to struct luo_session_ser without breaking compatibility
between adjacent kernels.

Size session block-set entries using kho_ser_size(luo_session_ser),
initialize each entry feature header during luo_session_serialize(), and
validate the incoming feature header in luo_session_deserialize_one()
before accessing the struct luo_session_ser payload.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h     |  6 +++---
 kernel/liveupdate/luo_session.c | 38 ++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index dfa7ea434d0d..425c52c494f1 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -132,15 +132,15 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * between kernels via Kexec Handover. An array of these structures (one per
  * session) is created and passed to the target kernel, allowing it to
  * reconstruct the session context.
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	DECLARE_KHOSER_PTR(file_set_ser, struct luo_file_set_ser *);
 };
 
-static_assert(sizeof(struct luo_session_ser) == 72);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_session_ser) == 8);
+DECLARE_KHO_SER(luo_session_ser, 72, 0, 0);
 
 /* The max size is set so it can be reliably used during in serialization */
 #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index df667fe15fb2..641bd67ce76e 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -131,7 +131,7 @@ struct luo_session_global {
 	struct luo_session_header outgoing;
 };
 
-#define LUO_SESSION_SER_SIZE (sizeof(struct luo_session_ser) + \
+#define LUO_SESSION_SER_SIZE (kho_ser_size(luo_session_ser) + \
 			      sizeof(struct luo_file_set_ser))
 
 static struct luo_session_global luo_session_global = {
@@ -557,23 +557,33 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
-static struct luo_session_ser *luo_session_ser_init(void *mem)
+static struct luo_session_ser *
+luo_session_ser_init(DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr))
 {
 	struct luo_file_set_ser *file_set_ser;
-	struct luo_session_ser *ser = mem;
+	struct luo_session_ser *ser;
+
+	kho_ser_init(fhdr, luo_session_ser);
+	file_set_ser = (void *)fhdr + kho_ser_size(luo_session_ser);
 
-	file_set_ser = mem + sizeof(struct luo_session_ser);
+	ser = kho_ser_payload(fhdr, luo_session_ser);
 	KHOSER_STORE_PTR(ser->file_set_ser, file_set_ser);
 
 	return ser;
 }
 
 static int luo_session_deserialize_one(struct luo_session_header *sh,
-				       struct luo_session_ser *ser)
+				       DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr))
 {
+	struct luo_session_ser *ser;
 	struct luo_session *session;
 	int err;
 
+	err = kho_ser_validate(fhdr, luo_session_ser);
+	if (err)
+		return err;
+
+	ser = kho_ser_payload(fhdr, luo_session_ser);
 	session = luo_session_alloc(ser->name);
 	if (IS_ERR(session)) {
 		pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
@@ -606,7 +616,7 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
-	struct luo_session_ser *ser;
+	DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr);
 	struct kho_block_set_it it;
 	static int saved_err;
 	int err;
@@ -635,8 +645,8 @@ int luo_session_deserialize(void)
 	 * reliably reset devices and reclaim memory.
 	 */
 	kho_block_set_it_init(&it, &sh->block_set);
-	while ((ser = kho_block_set_it_read_entry(&it))) {
-		err = luo_session_deserialize_one(sh, ser);
+	while ((fhdr = kho_block_set_it_read_entry(&it))) {
+		err = luo_session_deserialize_one(sh, fhdr);
 		if (err)
 			goto save_err;
 	}
@@ -665,15 +675,17 @@ int luo_session_serialize(void)
 	kho_block_set_it_init(&it, &sh->block_set);
 
 	list_for_each_entry(session, &sh->list, list) {
-		struct luo_session_ser *ser = kho_block_set_it_reserve_entry(&it);
+		DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr) =
+			kho_block_set_it_reserve_entry(&it);
+		struct luo_session_ser *ser;
 
 		/* This should not fail normally as blocks were pre-allocated */
-		if (WARN_ON_ONCE(!ser)) {
+		if (WARN_ON_ONCE(!fhdr)) {
 			err = -ENOSPC;
 			goto err_undo;
 		}
 
-		ser = luo_session_ser_init(ser);
+		ser = luo_session_ser_init(fhdr);
 		err = luo_session_freeze_one(session, ser);
 		if (err) {
 			kho_block_set_it_prev(&it);
@@ -691,7 +703,9 @@ int luo_session_serialize(void)
 
 err_undo:
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
-		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
+		DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr) =
+			kho_block_set_it_prev(&it);
+		struct luo_session_ser *ser = kho_ser_payload(fhdr, luo_session_ser);
 
 		luo_session_unfreeze_one(session, ser);
 		memset(ser->name, 0, sizeof(ser->name));
-- 
2.56.0.506.g506a7eabc5-goog


