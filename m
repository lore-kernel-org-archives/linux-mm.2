Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD4CCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669366B00E4; Sun, 18 Oct 2026 22:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F6C6B00E5; Sun, 18 Oct 2026 22:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555F16B00E6; Sun, 18 Oct 2026 22:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A90B6B00E4
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A8291205F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:20 +0000 (UTC)
X-FDA: 85337748720.20.54C28C8
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id C1F801C0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6M8k9ck;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qJK14zquZVZQXJj1ZTJgob9CLSSkOEckqrXS5MxL0I=;
	b=yfa9a6/lhJv7uENATwvEVlEhfWKTBR8kklIqylZdzN5hDcTQLaVb9LGJ+Mw0mGncYn8tl0
	Z+o88e9RZMTLv8iqhNaWFObkJfJc+GErd6+3U7nCAg+uhvaTn1rjk/tHrA2KIeN4wThvhF
	QE6i/9XRNVeechp4ZExcHWBLYz3k6Fg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6M8k9ck;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375878;
	b=4/63ZRHG5zHk7+nb5l5zepMCGp8LEGdHjDeL+P39Zt6imTjSSHCrsBcpI5a46kszFHZGky
	Hkef/4dK9WqQWpcH6ixJwxOvT2WBPinfEt53QQf0Adg6g0UFQVCyufN2buwfiA6ShsQjo/
	qGQflvCBzbeI2aS2GTtYibdSibaMwLc=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eac3b6b2ceso172484e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375878; x=1792980678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1qJK14zquZVZQXJj1ZTJgob9CLSSkOEckqrXS5MxL0I=;
        b=I6M8k9ckV3CxzeGRGHWaATVjVtV3odXJ+LMyZelal33gycIY+sCz80XCwGflgi8+ee
         syxRnltgTnJ6tHoE7iuulaY+drPOEo8nSlKw38bdzcptbFkgGyLpe4X6s2PUHDOS2BA1
         mIhmfx8gJRDsUONMly3VsT8vOsx00O4v1nB383slkmUu++wH7moP35ZPegdRoXYMQduQ
         5E9gaTuMlrDfP06I/gKNUouNI9FluBg04THDh3rtd/8v8pKxFrE8m7MJJiMWQ5Hr84Z6
         pm9TBJZtEi8DQm2Kg2i6fQ8rCkq6VY0MMGDAkochIDUgxxHLnkGax1fKIHsuLUwjjpE3
         ylzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375878; x=1792980678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1qJK14zquZVZQXJj1ZTJgob9CLSSkOEckqrXS5MxL0I=;
        b=LUbcqzz3Hk3jCWwyOki8lIWZRysbb/WbNcHWk0Bw7CJQmB/YURNHsZJZCaq2oQ0Ulz
         WSKF1eVN1F/QpE5X47OA0626MJ362KafBdliK/hnKAVMvnkxiPDnSFxeL55KCa/X/f+I
         7lyIKomf+OC34IlMMlYV4ATc9/yOT60UIyVFC0DlEENxj6Q5poj9qx5rjbu4V//iIPRm
         pNktENQemtxXX+ERfRojc6TUL6lzbaxXGnbhiTf37f/hpjKN1wiPXdmq5RgxlpGgB98t
         4EeMPQji5w101hcpSVdzRGIMHjHX3wiZ0VDpASrVLYkbEVsna3DniR5RV9gLvL7nF4zp
         a+FQ==
X-Forwarded-Encrypted: i=1; AKwUvByCYF8+/cm0sGSUYxyTxZUUQ5visl3Jaf/ZMbQ7afKhepNnHNBF7oAywxZY4Ky6KA8v4qkNBMgO6Q==@kvack.org
X-Gm-Message-State: AFq9FYI46uWn8pSrM5CYLetichIXOZZ9EwGEpxMVeeG2//gr7kNtyWzM
	HVk1+r8EaS4NzBRAA45xiMXAkspeu2P+syoBygRB5ljkdhNPXxOt5WdQR2BGkkLUB28=
X-Gm-Gg: AYBFou1nYZhCE3XXM+BUloZ+3iJo6HORUnYaQzlvhoaVCeJlsGgQ4fsLxH7yLPVm7C7
	UBDH1vOFUNTQbiHy8D9e7l1nqKeBwvF/BrabkFcO18f4VWyRaEy4oYGW/KmN0+1DjkX3jeB4LaS
	rsXthEJSlq9mXgpGl5Xox8E9oNHuEtmBjXeVBWw9UzHUGnZTtqu5Aa+1DRUXGKFpjPZjdTtowUf
	DUiIHR00AzUp6AQBbKQ4JZ4CLP/JsRl74/xyczkFhUr681qJdqk4EwfPYGqhyL305JgC/ybEZ5B
	YKb114FccnXN0qkogLO3zHLVWK3BrRfcwPOk4vCnq1LDmmSdxVwuaH3s8vELtfCpTBAtFiftdKH
	sXgnzPW22QrKRTchtUxWnmhNaW8Hr3eV5B+FoYtpasoOL2ZP6A1Po3+7fHo3w4xO/AiLwEnmLJ9
	qW7gbgsnSmNbPd/oHTtaTWR/KT0kEyiG71F6o1pQnhBllFBelZQwO4KNvKqmSehLSDeYTj1d8Ig
	kQN5ZikxBYUxLbHmJQZMM1cUaCVWOCGGJcNboWwprEiL2U7tQ7F2CZ+mLhkVIIagUGVeby4t7Lj
	4pyHHfTz2jK/ExAbuSntML6yYOKm9w==
X-Received: by 2002:a05:6122:4b1a:b0:5c9:c60e:3a44 with SMTP id 71dfb90a1353d-5eaaa8b81a1mr2041402e0c.22.1792375877949;
        Sun, 18 Oct 2026 19:11:17 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:17 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 1/8] kho: expose physical address of outgoing FDT
Date: Sun, 18 Oct 2026 22:11:04 -0400
Message-ID: <20261019021111.990394-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1F801C0007
X-Stat-Signature: uxa3g8bp7oi7o9hpj8gdxxtq1o37nu3q
X-Rspam-User: 
X-HE-Tag: 1792375878-811339
X-HE-Meta: U2FsdGVkX1///h+z07+BB/xlfUICTByijaevTc/e9wAHm+h0772g9Eq+uomGRyQT2SCqt46/Vm8oiROkrJeyvv78k//r1QLGalEqa03aUdGo7hLeOZ0ZpLw3uhQETBHFmiOI2Trnm+EuJgtbgx7uqIJx6y9yPMomlKvBhdX3j/TAjIAcLsYIlpdvUtURcsQ1cDCCD4ia3i50i8eSJgBqAWgeEruwfZiwKe3EHk8bdEtp5xAo4vHng8Y/h/C4jXlP3PO5/4hrHUBmDTmLRIbs0uJ8edE1RuKoCpgnGhMbWzTjTPSAy45aRZEGUvvOV5eu/on1nkVF28MEFbPbPgeRKfetntZihCXPKJC3mrdmvyVNeeE0R5DJnkJLWiZ7rNa6i1LRBE4Y9wvPU6bWrLe9KQzhFS9Ng+QSF5QaOWVWMFHpL93qRjrh+3J64AQFi4ORLhVWBpnogglJdVSOHqfNIC32SWzHWtDswxPuzjOSY6UsmWMsiVaP0kY7q0n2y1IxMy45dI5S4XwDXjVQ7J44VSJmmQIQcXV5W1q9C+OWsVJpJjXliMBpLot7fMqlFvCESN4LbTM96HpP3Je59/TXq3LveSS1VrC8LjhdVn5w+tgpnEnWMAZo0twgcrya1wmhhfwh4aR1WpbFKDLXJPPoNfbTpuDg7x+chhdZFNi1Q5f9QpKUCzAzXBizyc8XD/emGsnHPx9EyityMdAnUxfWoGuysZGWuolv139m2qHtw77dW7+MZRoEXGLkki4NNXacVXIMRehpgfRCEi6Cnw4SR42wvWanULhn8UYJeFIM4t17lXmhuuL4b90lu8pe+UuFbRAILDTIMqgy9/GYH20tgVodm70WkkYMI7jVT01f+5HB4mar7/0ls8T+GeXlOb/Im9iN+qkHS8PQyxDf7VDiaIRQqamQdCO1L6j05O7k406X45erAjRMW5k+fCETSNWAKbiqZBgixNtDl4yDJ0L
 cbX+/dFR
 mKogu9t7Cuk1CqEgNoyVCcmTGnH1IL+XFaHNzUtkb9ng8L3bXnPlAmv4vhECTnbiYj3KeIdkC6evbt8VmsxtxoiSYnnKTSRLi6oQmqqZoSabTiQs7viHVixzbZi6py4lofnxWX4b8dkq+Om7SOGM9oZVNWK0dbMouwruwI1J3bsx9+BdPs6BEX/e/2tdVyjaaGjUKFuD3BWjEwDW1XwwfrpUvWw3Xt/tYi3D3w+3CS7PJA35lf/SvHBqdx5k0fGTkeCmVlGILeoec2LrAsPeY4cWZKKEpvUlifugw3EIEYuWxApGaFNpvHpZBfQUGBwTX8FFUgJmn52tMSh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose the physical address of the outgoing KHO FDT via
/sys/kernel/debug/kho/out/fdt_phys (analogous to bootmem_phys) so
that userspace tooling can locate the root KHO FDT in physical memory.

Also add kho_debugfs_cleanup() and remove the KHO debugfs directory
if kho_init() fails after initializing debugfs, ensuring fdt_phys
does not retain a dangling pointer to a freed FDT.

This is going to be used by the upcoming KHO read-only mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/admin-guide/mm/kho.rst        |  3 +++
 kernel/liveupdate/kexec_handover.c          | 10 ++++++----
 kernel/liveupdate/kexec_handover_debugfs.c  | 22 ++++++++++++++++++++-
 kernel/liveupdate/kexec_handover_internal.h |  7 +++++--
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..2ba884c620c5 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -96,6 +96,9 @@ stabilized.
     current KHO state in this file. Kexec user space tooling can use this
     as input file for the KHO payload image.
 
+``/sys/kernel/debug/kho/out/fdt_phys``
+    Physical address of the outgoing KHO FDT blob.
+
 ``/sys/kernel/debug/kho/out/bootmem_len``
     Lengths of KHO bootmem regions, which are physically contiguous
     memory regions that will always stay available for future kexec
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..ce5983abf181 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1851,17 +1851,17 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	err = kho_out_debugfs_init(&kho_out.dbg);
+	err = kho_out_debugfs_init(&kho_out.dbg, kho_out.fdt);
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	err = kho_out_fdt_setup();
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	err = kho_kexec_metadata_init(fdt);
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
@@ -1893,6 +1893,8 @@ static __init int kho_init(void)
 
 	return 0;
 
+err_cleanup_debugfs:
+	kho_debugfs_cleanup();
 err_free_fdt:
 	kho_unpreserve_free(kho_out.fdt);
 err_free_kho_radix_tree:
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7d74477da0b7..db3830829398 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -95,6 +95,15 @@ static int bootmem_len_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(bootmem_len);
 
+static int fdt_phys_show(struct seq_file *m, void *v)
+{
+	void *fdt = m->private;
+
+	seq_printf(m, "0x%llx\n", (unsigned long long)virt_to_phys(fdt));
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(fdt_phys);
+
 __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
 	struct dentry *dir, *sub_fdt_dir;
@@ -172,7 +181,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	}
 }
 
-__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
+__init int kho_out_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
 	struct dentry *dir, *f, *sub_fdt_dir;
 
@@ -196,6 +205,11 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 	if (IS_ERR(f))
 		goto err_rmdir;
 
+	f = debugfs_create_file("fdt_phys", 0400, dir, (void *)fdt,
+				&fdt_phys_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
 	dbg->dir = dir;
 	dbg->sub_fdt_dir = sub_fdt_dir;
 	return 0;
@@ -212,3 +226,9 @@ __init int kho_debugfs_init(void)
 		return -ENOENT;
 	return 0;
 }
+
+__init void kho_debugfs_cleanup(void)
+{
+	debugfs_remove_recursive(debugfs_root);
+	debugfs_root = NULL;
+}
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index e9685e1ef6d7..38181076f603 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -24,16 +24,19 @@ extern unsigned int kho_bootmem_cnt;
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
+void kho_debugfs_cleanup(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
-int kho_out_debugfs_init(struct kho_debugfs *dbg);
+int kho_out_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
 			 const void *blob, size_t size, bool root);
 void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
+static inline void kho_debugfs_cleanup(void) { }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
-static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
+static inline int kho_out_debugfs_init(struct kho_debugfs *dbg,
+				       const void *fdt) { return 0; }
 static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
 				       const char *name, const void *blob,
 				       size_t size, bool root) { return 0; }
-- 
2.56.0.176.g3575e65682-goog


