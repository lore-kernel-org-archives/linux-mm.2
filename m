Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED5CEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DD16B00B1; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC496B00A7; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35986B00AA; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9659F6B00A4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 437711BEF0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.29.0DB507F
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11BC4100012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=AHWaJPiB;
	spf=pass (imf14.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMYuXsAwXlZPj+pNBI19fXQVyelGTABQZdwu3TAkE2A=;
	b=NTz1p9Py+T6qiYkdDFJKb7WpGEuqtJqkPHaPw1e2PFTQuQbOoFqV077iGJZxgpmjMx/bvo
	JcjPb7Mw+ULf3sU5DDR9vo8ysLhwZbrGDxwcY823OhoXbB8u8fNjEoR6BhfjEzah/CjAsg
	U7pE6u8ZILAXGpgxu0Gzm9NkTo/XwQw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=AHWaJPiB;
	spf=pass (imf14.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=Z20uRkrHc/c3jOYhXxJ46LLcLRTs6M/mhHNgX22oSSIrKgPImdyqiog9ZWziFo5aXgeNXa
	czJTsdX/6xrzuyYUqdL6SUkRwKoIsbxljNertdu+gNr3eAgkrY82Y9Btcvt7r6EbDctTuP
	hj1bKE6gKSNMi9f4430kMrjYzQf0dEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=lEmCou71DQIv3rJiH+2ZIvzOcBQ45/hCLHA8fjFTjEM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AHWaJPiBsL+GwFoetOExpKLG9cmnqvpt8xMBxHRmuFnKfjqJNAZAD1Wuu27hEzCjp
	 yo/8LH57/iizP+bjiVmoMZwTMOiCMC/XLDqy5SSCcm+OQZZ/0iP8EPctZ2sQqxK7Ab
	 XT9/JQSyTpsDOlLEGnKt3l1avwq96+RDdo3lipF8=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d40-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:41 +0100
Subject: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2257; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=lEmCou71DQIv3rJiH+2ZIvzOcBQ45/hCLHA8fjFTjEM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYJfb+qOowLIkUmfJbwapQWgbBrCmoY2MGV1
 kQO676TIO+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGCQAKCRA0LQZT0ays
 264GB/0ePCsoEZ4dvusK/+59DK+nFUG4TMYrwfcQ9Aw8geb+nDTbFBXmGXKhwNE0FGNMoZ9u6w0
 6Z8ff6aHriAkc9Kt7Cgo70KOX6BjUy2bKgpnqJ9UCEmLABUocGsnikIoRM/S+kmqBXC+hSxD7sM
 X70l7rxeP1jyVHxWJrxfa6E/R35lI3vjpmjnsYcBxz/fgBeGY30s+ys1gafR9RwiFHF5/fl9jcb
 Y3J+3Pom6JCnaZYPGyS2UG84plp5l+rENGjhP2UWug9tGkZ5pwYbuR79z7QaUT6EEnR3YbR314t
 8SpG12KL4Vc7ZU5W2GsSc9E64021CyFWbNdSoNZGwreTwyp2
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-764F0E1F-76E75FCD/0/0
X-purgate-type: clean
X-purgate-size: 2259
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 11BC4100012
X-Stat-Signature: g79zcmtuca88rc7bfcppd15zir68w15r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773143729-426212
X-HE-Meta: U2FsdGVkX1/D97STZ6iLMrKKtg1Az4Y0gG6YfXKkEG7vRUNaLJJW9dHEAhqaO28dDSH1QciBpkBMvMu3A/K+FBwkIuCu35NiYeS/mm8keA3ssr844JD0Eto5iyU61Rhe6IIlP+ubeiYKQHbeBOaubt2VY1GSTahtIcF32s2NT/HTBTyG2VhGk863Ha2sK4z6sinXAqWCqUJQPDyFcqDdRElc/8bmKt30ZfFDf81L0nuTUQPIZ4LljIkYv0t1hjTBZVQuSeSTP6T3Tiw9EjW2/EaE0yOXqZrSpGr5szqWUvUJVO63/sg7/UpPgcUsx0VJqCOtsItg2QfwWJ6tEl3BORQqQp1caWuYImPM2scRP0/XDCcIcoLmJAUMOo5LDV4zm7NtvaRSUjGLhYp8P/s0R84KbDRuzinVi2PacMEibUH1tpWgUrXb3w/9y3k/useh8a0ten/HD7BwXGN3/iK84JfNPVpbWZJ5q3VkUSu+c/+ovD2+fxX5fZ7ZppkA0daB7AzeEXXF8jJesELA2yPzsXe0gtqdURQKNGUgiT3YSY2U11aWTqgG3jQkpMYxnMfOwwqD2rfXfnuATzbZs3xM5xzxpPmMqF+/eZbrxjSEpR/HeHehFX1GhBfS29ySiGDidFDw9+CVXLJkYaE1RprqzLd0pusc0+tMnYy3l5iNeTWqyBNoRXwNYh7UDRkO5ArFmd3C2Ce4SfeyFUsYwZLe4IhWAoPoomDBztFx8WMNlSRphfm2qZymKuT17477y/iwi+zlzLj7s/vLDHkSWWbS4s5WsQwJ/8TFIT1E97DgjRQ/v5quGuQRKnvGskLqtNcYN0xTiNv8nZmT3HWf9qUgICarhJinfxOIyEJIsV7WVTb4ItsFO049gJAi33FJ922EAM6rsgH1LK9JQtCcmYEj46PBK/39t8MbDVVBuQ6n0I0dEqcycnK8Vb1hNO0ohOQA0V5JOM2zhpzR4IOTiat
 ZuE6W+nM
 mNmikjI6/L1BoXERyoZun+yv09aJI9qf2HdZBOZFeyFo6RLRsy6RSlN59IWmzqcjPhk3klF1qWVcHDtIvxFvGEQD7jo64wR+grj63yqn4SWXhUbdLiqY9uVKEB8xupS8TGWCeYcCcJblMymHhBGf0HUQc0hkd1hrFJTgSMFJUuqHlUkyWsWh6idnudZnKu67AcWNUa3nvJVDPD3TTc2oVrUpYdU7JfymmbglqB2ZJivQMDGsN1bcs9IlOikfdilONQCgSSO0jqmFjbmqu0o6oMDFL6+H+ZCSwSnX1j9QmnOWYCVaigSENc2iIQ+1n9JdTC+GgiqZWKZFmFGnXmRld8X3G60ETpo3fEGFliT7E+VE7he/oXwD9VL+xtJm4jwOIJPYFRT8HNYtv4Ma7i5RMvBznoAQz5RrLw0VO0dBLlScywm4FotVvQHGgK6qe8xQQklbuwqsl03JdGWOiwqdIQqLD2YGXgsLtoDGvg7RAOmTRVlzXbVpW68TC8TITsX30jtzw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 kernel/trace/fprobe.c                | 2 +-
 kernel/trace/kprobe_event_gen_test.c | 2 +-
 kernel/trace/trace_events_hist.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index dcadf1d23b8a31f571392d0c49cbd22df1716b4f..a94ce810d83b90f55d1178a9bd29c78fd068df4c 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -607,7 +607,7 @@ static int fprobe_module_callback(struct notifier_block *nb,
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((node = rhashtable_walk_next(&iter)) && !IS_ERR(node))
+		while (!IS_ERR_OR_NULL((node = rhashtable_walk_next(&iter))))
 			fprobe_remove_node_in_module(mod, node, &alist);
 
 		rhashtable_walk_stop(&iter);
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index 5a4b722b50451bfdee42769a6d3be39c055690d1..a1735ca273f0b756aa1fcfcdab30ddad9bc51c5f 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -75,7 +75,7 @@ static struct trace_event_file *gen_kretprobe_test;
 
 static bool trace_event_file_is_valid(struct trace_event_file *input)
 {
-	return input && !IS_ERR(input);
+	return !IS_ERR_OR_NULL(input);
 }
 
 /*
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 73ea180cad555898693e92ee397a1c9493c7c167..59df215e1dfd9349eca1c0823ed709ec7285f766 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3973,7 +3973,7 @@ trace_action_create_field_var(struct hist_trigger_data *hist_data,
 	 */
 	field_var = create_target_field_var(hist_data, system, event, var);
 
-	if (field_var && !IS_ERR(field_var)) {
+	if (!IS_ERR_OR_NULL(field_var)) {
 		save_field_var(hist_data, field_var);
 		hist_field = field_var->var;
 	} else {

-- 
2.43.0


