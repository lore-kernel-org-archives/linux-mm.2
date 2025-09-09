Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08735CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D498E001F; Tue,  9 Sep 2025 16:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7888E0019; Tue,  9 Sep 2025 16:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3589C8E001F; Tue,  9 Sep 2025 16:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6C18E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCE07140574
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:44 +0000 (UTC)
X-FDA: 83870817408.15.01D6474
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF58018000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=uEzS3uie;
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCmAQ9E1zzf2oww3L+0ScmydA57h//TWKN5Ptw1aNtc=;
	b=EGsJaIqw7yRbir2ZTnxlZ889jogxZp7zwtqyKa71XPEQSoNQObA6CfAngbD7ykA0SnAD0p
	PP9xpwYVVMo4GMrtP4zLe4pa6vUNqdPCC9U0o35U7tgHH/LxOPdt+fLUmY0HLmvmld5NnW
	UFV2HcDvmoLygH7oq60P4MHEqU8HyAc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=uEzS3uie;
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448943; a=rsa-sha256;
	cv=none;
	b=6fiQiEkVrPTysMhgVWF+9ie0ZUpqpA4TLcOHSb3Ys7/QuxTaQ0L0wcfpr+Zj0Q+QkV02cS
	n/o6LSWHk5/iiCl4ErMeIVx0oJd7P06yYOEAB38EG1N1+IUXByuEvLKJITbwxH6BQM+Yk4
	dJqoJb2Sab66TT0wMtdOZN0BVOVpzG4=
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 7FC46C01A1;
	Tue, 09 Sep 2025 23:15:41 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-KRuqVmhs;
	Tue, 09 Sep 2025 23:15:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448940;
	bh=zCmAQ9E1zzf2oww3L+0ScmydA57h//TWKN5Ptw1aNtc=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=uEzS3uievKUGgVzVo0XM3CO7O2ofI0YqYncCVzgEakehhvnc4qFhCFRVQGZevHwi7
	 CsQOMPEcV3YUF+z629p8DXGKYRKMBn5aPJVuffYv3pT3WEedSZtyRhs7RNlM2tFIQO
	 Rai9V/CC6os2Ibdv73XbRLEYv8Q0/+Dnk2oRckgk=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v3 4/7] kho: replace KHO FDT with kstate metadata
Date: Tue,  9 Sep 2025 22:14:39 +0200
Message-ID: <20250909201446.13138-5-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF58018000F
X-Stat-Signature: scj5qx7ymd1rmngbc5fdz4ecskrk1sio
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757448942-454915
X-HE-Meta: U2FsdGVkX196EMtemZBvcSgtaFrUdJQVYrz2xFaU5wzKwYVzW6+wchlBLlTbGEAKT0sR37K3rR5hqPwT0CIvXcQ5NvfnJnfv+KfTW4h+z/Wm1XCeGWa0gZq9uOVkulLCAYq/F3VM9y+FCB4SJ6vorzUE2zg235Ozu0fYVpltVVuaKwQ8PSwO97mUvWfARZ4u4LdDOobDvdA5ksgggWSvdUHg1L6sz+fixy6r/u/9dkW5OlR28SqIgfwnOd3DfuvoTE4SfyQ6ZRT6JXKvvHPokGjKtPAQiQ0OptWSC9k4nzqC1UPkTCYOW7iEw4uW/kA5AZDrU6YDwEcYqSiroxymXUeGkBXr/EvMnIJ3Q13OSM04mBTAnf8HsP6BOkawJC5i/rHbpeYhx4ANVi5ETXZ4BG2kjQDNub9i2kOli3owNKNJAcrqrMXE8CnmP1DiA/h2SXzPJceH7Wj3ufmhTKIH4kphPe37HfO/Zp5O28IEeWipiniDGk97dgSRhGPxZKeEJY7WaLGlDpG13hKB9K8g1enhzG633KRjk7Y4Q3fvwC9xN920NxuZMYXIx2yb3TyPtK190hLX7UIt9elDIaXwuXPEevzDHhjXqRhlbm5VJHeoL5UWwInAS5pFjckhoqJdqjlVggiIjRINOElYT/L6iYEuOw0U/ttVG4nS1LSqBa0bOBsxrfHrVGHMRghS7LcNfGnaFXIYqR1T9RGga2ZrVo8FbLJHIktAcN4kYU8zgIarT5pSmuBBVdFOdn2voJIA2QZi2aLZS6cCxUTT7pqArMn8Th7oGZvLSQZGxM6dc0lEcovpes8dxG/+zzA5gbbdZMt+axKYUpUaUQAHsTEO2tLRu/ttHX4bvU1DlGfW02ndWXGpBFZ886rX98kRmYwprzEK0MY3A8DNmvGoxLSWSk9nLxjGoGwDktm7TpVGGUYqBYeC0g/mScTq3atR7Dzzgnns7NQFbq0zbfawFMg
 O2kHXMiI
 urni+BoCmZ38j08AHuWBs80F//XuoJVlPe2Ght3QdmbU6qkpiSBScK0p64MboKCt78zgpO6lOYLv9R666TybSLuISokCHpqqPUQfAkfYCGL+yrT3OegXPCexTwAvevTLuwfOHZ34au9QoamHyKrQTBgVLtd/VMs8tGayQdheWkeMZ/CJ3Te5yNxih3OnikEMOZZ9AEFmmSn8Uc47bVdWsjJurMzmhPC6h0kekZ8NDB3C7pNLqIxhP05n0ezEwL4xb5phPbGxRzlsWz+2sKBxxGkg4uV/7Q5ABCRQhPudBXHEhszmMXip9o5znJ9JXJm45szEZEJcHeOcv3o1Uw9htIpM4puP4q5Mxaes4ZHqLBriYpqSvqh/04EYg4AlJgnWndCMf5UXtgz9FyflkwfnvzATSX6LRDxdwty2Rmi0Dt9fvJEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Store KSTATE physical address & size instead of FDT in kho_data.
and initialize KSTATE from kho_populate().
To be able to use FDT in parallel with KSTATE place FDT
address&size into 'struct kho_fdt' and save/restore it using KSTATE.

This finishes wiring KSTATE with KHO, making it fully functional.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 arch/x86/include/uapi/asm/setup_data.h |  4 +-
 arch/x86/kernel/kexec-bzimage64.c      |  6 +--
 arch/x86/kernel/setup.c                |  3 +-
 drivers/of/fdt.c                       |  6 +--
 include/linux/kexec.h                  |  2 +-
 include/linux/kstate.h                 |  1 +
 kernel/liveupdate/kexec_handover.c     | 60 +++++++++++++++++++++-----
 7 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
index 2671c4e1b3a0..844f5b93473f 100644
--- a/arch/x86/include/uapi/asm/setup_data.h
+++ b/arch/x86/include/uapi/asm/setup_data.h
@@ -83,8 +83,8 @@ struct ima_setup_data {
  * Locations of kexec handover metadata
  */
 struct kho_data {
-	__u64 fdt_addr;
-	__u64 fdt_size;
+	__u64 kstate_addr;
+	__u64 kstate_size;
 	__u64 scratch_addr;
 	__u64 scratch_size;
 } __attribute__((packed));
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 24a41f0e0cf1..1bf9474d4286 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -253,12 +253,12 @@ static void setup_kho(const struct kimage *image, struct boot_params *params,
 	sd->len = sizeof(struct kho_data);
 
 	/* Only add if we have all KHO images in place */
-	if (!image->kho.fdt || !image->kho.scratch)
+	if (!image->kho.kstate || !image->kho.scratch)
 		return;
 
 	/* Add setup data */
-	kho->fdt_addr = image->kho.fdt;
-	kho->fdt_size = PAGE_SIZE;
+	kho->kstate_addr = image->kho.kstate;
+	kho->kstate_size = PAGE_SIZE;
 	kho->scratch_addr = image->kho.scratch->mem;
 	kho->scratch_size = image->kho.scratch->bufsz;
 	sd->next = params->hdr.setup_data;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b2edd07a3e1..eedcf4be8985 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -467,7 +467,8 @@ static void __init add_kho(u64 phys_addr, u32 data_len)
 		return;
 	}
 
-	kho_populate(kho->fdt_addr, kho->fdt_size, kho->scratch_addr, kho->scratch_size);
+	kho_populate(kho->kstate_addr, kho->kstate_size, kho->scratch_addr,
+		kho->scratch_size);
 
 	early_memunmap(kho, size);
 }
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 0edd639898a6..f682ef6a1187 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -893,8 +893,8 @@ static void __init early_init_dt_check_kho(void)
 	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
 		return;
 
-	fdt_start = dt_mem_next_cell(dt_root_addr_cells, &p);
-	fdt_size = dt_mem_next_cell(dt_root_addr_cells, &p);
+	kstate_start = dt_mem_next_cell(dt_root_addr_cells, &p);
+	kstate_size = dt_mem_next_cell(dt_root_addr_cells, &p);
 
 	p = of_get_flat_dt_prop(node, "linux,kho-scratch", &l);
 	if (l != (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32))
@@ -903,7 +903,7 @@ static void __init early_init_dt_check_kho(void)
 	scratch_start = dt_mem_next_cell(dt_root_addr_cells, &p);
 	scratch_size = dt_mem_next_cell(dt_root_addr_cells, &p);
 
-	kho_populate(fdt_start, fdt_size, scratch_start, scratch_size);
+	kho_populate(kstate_addr, kstate_size, scratch_start, scratch_size);
 }
 
 #ifdef CONFIG_SERIAL_EARLYCON
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 39fe3e6cd282..ebf70361269f 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -416,7 +416,7 @@ struct kimage {
 
 	struct {
 		struct kexec_segment *scratch;
-		phys_addr_t fdt;
+		phys_addr_t kstate;
 	} kho;
 
 	/* Core ELF header buffer */
diff --git a/include/linux/kstate.h b/include/linux/kstate.h
index 53992593cb19..5a95960e5b03 100644
--- a/include/linux/kstate.h
+++ b/include/linux/kstate.h
@@ -94,6 +94,7 @@ struct kstate_field {
 
 enum kstate_ids {
 	KSTATE_FOLIO_ID = 1,
+	KSTATE_KHO_FDT_ID,
 	KSTATE_LAST_ID = -1,
 };
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f1c6378b2657..216cb58553d6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -806,6 +806,10 @@ int kho_abort(void)
 		goto unlock;
 	}
 
+	ret = kstate_abort();
+	if (ret)
+		goto unlock;
+
 	ret = __kho_abort();
 	if (ret)
 		goto unlock;
@@ -984,6 +988,25 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+
+#define KHO_FDT_INSTANCE_ID 1
+
+static struct kho_fdt {
+	phys_addr_t fdt_phys;
+	u64 fdt_len;
+} kho_fdt;
+
+struct kstate_description kho_fdt_state = {
+	.name = "kho_fdt",
+	.version_id = 1,
+	.id = KSTATE_KHO_FDT_ID,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(fdt_phys, struct kho_fdt, phys_addr_t),
+		KSTATE_BASE_TYPE(fdt_len, struct kho_fdt, u64),
+		KSTATE_END_OF_LIST()
+	},
+};
+
 static __init int kho_init(void)
 {
 	int err = 0;
@@ -1000,13 +1023,20 @@ static __init int kho_init(void)
 	}
 	kho_out.fdt = page_to_virt(fdt_page);
 
-	err = kho_debugfs_init();
+	err = kstate_register(&kho_fdt_state, &kho_fdt, KHO_FDT_INSTANCE_ID);
 	if (err)
 		goto err_free_fdt;
 
+	kho_fdt.fdt_phys = page_to_phys(fdt_page);
+	kho_fdt.fdt_len = PAGE_SIZE;
+
+	err = kho_debugfs_init();
+	if (err)
+		goto err_free_kstate;
+
 	err = kho_out_debugfs_init(&kho_out.dbg);
 	if (err)
-		goto err_free_fdt;
+		goto err_free_kstate;
 
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
@@ -1025,6 +1055,8 @@ static __init int kho_init(void)
 
 	return 0;
 
+err_free_kstate:
+	kstate_unregister(&kho_fdt_state, &kho_fdt, KHO_FDT_INSTANCE_ID);
 err_free_fdt:
 	put_page(fdt_page);
 	kho_out.fdt = NULL;
@@ -1165,24 +1197,30 @@ static int __init kho_scratch_init(phys_addr_t scratch_phys, u64 scratch_len)
 	return err;
 }
 
-void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-			 phys_addr_t scratch_phys, u64 scratch_len)
+void __init kho_populate(phys_addr_t kstate_phys, u64 kstate_len,
+			phys_addr_t scratch_phys, u64 scratch_len)
 {
-
 	int err = 0;
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
-	err = kho_fdt_init(fdt_phys, fdt_len);
+	err = kho_scratch_init(scratch_phys, scratch_len);
 	if (err)
 		goto out;
 
-	err = kho_scratch_init(scratch_phys, scratch_len);
+	err = kstate_early_init(kstate_phys, kstate_len);
+	if (err)
+		goto out;
+
+	err = kstate_restore(&kho_fdt_state, &kho_fdt, KHO_FDT_INSTANCE_ID);
+	if (err)
+		goto out;
+
+	err = kho_fdt_init(kho_fdt.fdt_phys, kho_fdt.fdt_len);
 	if (err)
 		goto out;
 
-	kho_in.fdt_phys = fdt_phys;
+	kho_in.fdt_phys = kho_fdt.fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
-	kho_scratch_cnt = scratch_cnt;
+	kho_scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	pr_info("found kexec handover data. Will skip init for some devices\n");
 
 out:
@@ -1201,7 +1239,7 @@ int kho_fill_kimage(struct kimage *image)
 	if (!kho_enable)
 		return 0;
 
-	image->kho.fdt = virt_to_phys(kho_out.fdt);
+	image->kho.kstate = kstate_out_paddr;
 
 	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
 	scratch = (struct kexec_buf){
-- 
2.49.1


