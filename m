Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B40C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 07:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CBE6B008C; Sun, 27 Sep 2026 03:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852A26B0092; Sun, 27 Sep 2026 03:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B666B0093; Sun, 27 Sep 2026 03:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53CC46B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 03:28:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CDB31209F3
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:46 +0000 (UTC)
X-FDA: 85258715052.17.0C7CC0E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4FA6A40007
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790494124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AYwrFyd00r7uTkbnqYi94uqrXCLHkyfHJ/Hkmj3Fr+g=;
	b=c4u+b7s0ERD/1wLLs1WJKjVtKwydvRpcWOzbVFB1fp3akOg4ssPxXETWpS2isOMEqtzjxH
	6kB5nWySJm9OKv0Wnj2JBx/qky2lA6gbtyjg6PV2PSAkpBGmh4ojmHnFZB/LrCG99vWwKn
	Xn0fuDVcuJTWAnFwtMo2+pPB177o/Gs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790494124;
	b=ozsh3YWef7bDeWVbiUTlMkZJHVIvLS5hrRz3kKpcNhTPCQ3fKK9hskNedBG5XOAK1Y1xEx
	2Rb0wqcyfuI6w5I+XLPrni5ZzTNjTN+ba1Cj9ZT9S0nPaeehM68KHP+u3Y2yjQzrX3LZZv
	FPHoDTRdGTUeXlGU3qvISX3V+dTCKD0=
X-UUID: 0c23f236ba4511f19a56ed5b684f684d-20260927
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2660ce27-5538-4d3c-845d-208cdce73c04,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:2660ce27-5538-4d3c-845d-208cdce73c04,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:02d83635f4541371c5115f0d53ea8629,BulkI
	D:260927151417B1NOXWS8,BulkQuantity:2,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:41,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0c23f236ba4511f19a56ed5b684f684d-20260927
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1652417392; Sun, 27 Sep 2026 15:28:34 +0800
From: Enze Li <lienze@kylinos.cn>
To: ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	sj@kernel.org
Cc: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	lienze@kylinos.cn
Subject: [RFC PATCH 3/4] samples/damon: add Rust sample for DAMON access-aware proactive reclamation
Date: Sun, 27 Sep 2026 15:28:11 +0800
Message-ID: <20260927072812.2393456-4-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927072812.2393456-1-lienze@kylinos.cn>
References: <20260927072812.2393456-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FA6A40007
X-Rspam-User: 
X-Stat-Signature: 4wh9cf8tndquxag3symbq1488akwdf9b
X-HE-Tag: 1790494122-461610
X-HE-Meta: U2FsdGVkX18VgDPQ/NQ3poS6hPnNETw+TNhzO20RFUtZZhPptLwRIF/oFxPRTQB063JFciX1nCiAmdR5dJkjA2yojVNaaB/TINCbJBRcBE58iDBLqGsPnmCRHSeCrVNXA3OWgfLLj4b+N8DJI76MVjuBUTn7QO4rWOr45k6zxaFEAvyFZFv6Au7COlN2jGfs/8FCpmGNH4WLal0s2B7Iqu9I358oWzVqrN0+JQmv8FovXdxJk+7RuMtvxCviHl6HWSz8s7DNU8aXP/hPo7bA2IqS5BhtWuKdUzkjPchljiQ8E54X+6CNzQu7DOSBnfWH41WGoRJrMox9wzA40Mvt1/RXNULagRuI6pLeFtSot/V7234lYaZYZeYzhFs8W1t+E7lDBeOl/usBIqCOWKnftgYamx13hCFqVl7BxBDcUBGjxbt9kb0w6Qexskczbf5CrOCOwSKaJQFcRLtUBkf5eBC88w/Xfid7Pv+XbDYF6CcwCAEorYHspx8Tj5M4cdmokOgz8KlInHKuH7LoIi3nvpkAaZ/5qlg8bRzo54NbAEtfRq2CG4qv02jm3uV/1lBK3+QNieHdW2yw8/ZxLc0L1NIL73W5nwuugqONMnenTocj30yQ3mpO8/hGfABg6xe1Edu7GHzyHZpzdDliippvaegAvAWyt9ZxXpIgnRWcd0UpbvGEafiOj/0/mSlCvtQzG2ZDuOg9dmOf8uaTVHoHiQJIKu977OAakWA751JXDRTH3hWgtHHqp3EiUegC8lAUpQZPJTciwXPbbZC8fmupnO4ooV5Z1JGqhrvrlH1133kUF5Qv2hgT6U67dikomY4hdnyVNcDVFzrifSaE22od4ndGb0IRpe9AuwZXY5lbf1YygD6a6V+EoWbPv+xhOzuJe0etraSBA/WH72ysIpCRUEs+sZVpzgEY+m8WJf65wS8q/mVU116KZWXjD6DEEmWwJlXQSR2doBqk6Wn1Wgy
 NjsEFmdB
 zT0Xh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Rust implementation of the DAMON-based proactive reclamation sample
module, porting the logic from prcl.c to demonstrate using Rust bindings
for DAMON C APIs.

The module monitors the virtual address space of a target process via DAMON
vaddr operations and proactively reclaims cold memory regions using the
DAMOS_PAGEOUT action with an access pattern filter.

Unlike the C version (prcl.c), which is configured through module
parameters, the Rust version provides debugfs-based runtime control under
/sys/kernel/debug/rust_prcl/.  Monitoring can be enabled or disabled by
writing to the enabled file, while the target process to monitor is
selected by writing its PID to target_pid.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 samples/Makefile           |   1 +
 samples/damon/Kconfig      |  12 +++
 samples/damon/Makefile     |   1 +
 samples/damon/rust_prcl.rs | 158 +++++++++++++++++++++++++++++++++++++
 4 files changed, 172 insertions(+)
 create mode 100644 samples/damon/rust_prcl.rs

diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8..df726c0653cd 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -43,5 +43,6 @@ obj-$(CONFIG_SAMPLES_RUST)		+= rust/
 obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
+obj-$(CONFIG_SAMPLE_DAMON_RUST_PRCL)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
 obj-$(CONFIG_SAMPLE_TSM_MR)		+= tsm-mr/
diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
index 00be3e6bdd65..654b62e186c9 100644
--- a/samples/damon/Kconfig
+++ b/samples/damon/Kconfig
@@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
 
 	  If unsure, say N.
 
+config SAMPLE_DAMON_RUST_PRCL
+	bool "Rust sample module for DAMON-based access-aware proactive reclamation"
+	depends on DAMON && DAMON_VADDR && RUST && DEBUG_FS
+	help
+	  This option builds the Rust implementation of DAMON-based prcl sample.
+
+	  The module exposes two debugfs interfaces under
+	  /sys/kernel/debug/rust_prcl/ for starting/stopping monitoring
+	  and setting the target PID.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/samples/damon/Makefile b/samples/damon/Makefile
index 72f68cbf422a..2e3ed8d9dd5d 100644
--- a/samples/damon/Makefile
+++ b/samples/damon/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
 obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
 obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
+obj-$(CONFIG_SAMPLE_DAMON_RUST_PRCL) += rust_prcl.o
diff --git a/samples/damon/rust_prcl.rs b/samples/damon/rust_prcl.rs
new file mode 100644
index 000000000000..1e6c820311e2
--- /dev/null
+++ b/samples/damon/rust_prcl.rs
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Rust prcl sample.
+
+use core::ptr::null_mut;
+use kernel::bindings;
+use kernel::damon;
+use kernel::debugfs::Scope;
+use kernel::prelude::*;
+use kernel::sync::atomic::{Atomic, Relaxed};
+use kernel::uaccess::UserSliceReader;
+
+module! {
+    type: RustPrcl,
+    name: "rust_prcl",
+    authors: ["Enze Li <lienze@kylinos.cn>"],
+    description: "DAMON-based proactive reclamation module for rust edition",
+    license: "GPL",
+}
+
+struct RustPrcl {
+    _data: Pin<KBox<Scope<ModuleData>>>,
+}
+
+struct ModuleData {
+    enabled: Atomic<bool>,
+    target_pid: Atomic<i32>,
+}
+
+impl Drop for ModuleData {
+    fn drop(&mut self) {
+        if self.enabled.load(Relaxed) {
+            damon_sample_rust_prcl_stop();
+        }
+    }
+}
+
+static CTX: Atomic<*mut bindings::damon_ctx> = Atomic::new(null_mut());
+
+fn damon_sample_rust_prcl_start(target_pid: i32) -> Result {
+    let ctx = damon::DamonCtx::damon_new_ctx()?;
+    ctx.damon_select_ops(damon::OpsID::VADDR)?;
+
+    let mut target = damon::Target::damon_new_target()?;
+    target.damon_set_target_pid(target_pid)?;
+    ctx.damon_add_target(target);
+
+    let mut pattern =
+        damon::DamosAccessPattern::new(bindings::PAGE_SIZE, usize::MAX, 0, 0, 50, u32::MAX);
+
+    let mut quota = damon::DamosQuota::zeroed();
+    let mut watermarks = damon::DamosWatermarks::zeroed();
+    let scheme = damon::Damos::new(
+        &mut pattern,
+        damon::DamosAction::PAGEOUT,
+        0,
+        &mut quota,
+        &mut watermarks,
+        bindings::NUMA_NO_NODE,
+    )?;
+
+    ctx.damon_add_scheme(scheme);
+
+    let ret = ctx.damon_start();
+    match ret {
+        Ok(_) => {
+            CTX.store(ctx.into_raw(), Relaxed);
+        }
+        Err(e) => {
+            pr_err!("damon_start failed, error: {:?}\n", e);
+            return Err(e);
+        }
+    }
+    Ok(())
+}
+
+fn damon_sample_rust_prcl_stop() {
+    pr_info!("stop\n");
+    let raw = CTX.xchg(null_mut(), Relaxed);
+    if !raw.is_null() {
+        // SAFETY: raw came from into_raw() at damon_start(), and xchg()
+        // makes its sole remaining owner, so moving it back once is safe.
+        let _ctx = unsafe { damon::DamonCtx::from_raw(raw) };
+        // _ctx drops at the end of this scope, it runs damon_stop(1) and
+        // damon_destroy_ctx().
+    }
+}
+
+fn damon_sample_rust_parse_bool(s: &str) -> Result<bool> {
+    let s = s.trim();
+    if s.eq_ignore_ascii_case("y") {
+        Ok(true)
+    } else if s.eq_ignore_ascii_case("n") {
+        Ok(false)
+    } else {
+        Err(EINVAL)
+    }
+}
+
+fn enabled_read(data: &ModuleData, f: &mut kernel::fmt::Formatter<'_>) -> kernel::fmt::Result {
+    writeln!(f, "{}", if data.enabled.load(Relaxed) { 'Y' } else { 'N' })
+}
+
+fn enabled_write(data: &ModuleData, reader: &mut UserSliceReader) -> Result {
+    let mut buf = [0u8; 32];
+    if reader.len() > buf.len() {
+        return Err(EINVAL);
+    }
+    let n = reader.len();
+    reader.read_slice(&mut buf[..n])?;
+
+    let s = core::str::from_utf8(&buf[..n]).map_err(|_| EINVAL)?;
+    let enabled = damon_sample_rust_parse_bool(s)?;
+
+    let is_enabled = data.enabled.load(Relaxed);
+    if enabled == is_enabled {
+        return Ok(());
+    }
+
+    if !damon::damon_initialized() {
+        return Ok(());
+    }
+
+    data.enabled.store(enabled, Relaxed);
+
+    if enabled {
+        let target_pid = data.target_pid.load(Relaxed);
+        if let Err(e) = damon_sample_rust_prcl_start(target_pid) {
+            data.enabled.store(false, Relaxed);
+            return Err(e);
+        }
+    } else {
+        damon_sample_rust_prcl_stop();
+    }
+
+    Ok(())
+}
+
+impl kernel::Module for RustPrcl {
+    fn init(_module: &'static kernel::ThisModule) -> Result<Self> {
+        let data = KBox::pin_init(
+            Scope::dir(
+                ModuleData {
+                    enabled: Atomic::new(false),
+                    target_pid: Atomic::new(0),
+                },
+                c"rust_prcl",
+                |data, dir| {
+                    dir.read_write_callback_file(c"enabled", data, &enabled_read, &enabled_write);
+                    dir.read_write_file(c"target_pid", &data.target_pid);
+                },
+            ),
+            GFP_KERNEL,
+        )?;
+
+        Ok(Self { _data: data })
+    }
+}
-- 
2.43.0


