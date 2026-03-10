Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6EDEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECC96B00A3; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F896B00A4; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6C46B00A5; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF4956B00A3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7DE31B6B98
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84529998462.22.8C1F8CA
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf21.hostedemail.com (Postfix) with ESMTP id A70B01C0010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RQt94wsCFG7IJEQyvVRUl8nd2Z953/wokMRXtIM6bI=;
	b=ZHOYk7KZqtauwYGsOZz22cm7kToIQTMB542ZzYvwESXeBb9KE9rIyjkCHIg7f/UO5c7VE/
	Uj/TuLgqr9QR3JP3TqqZ8MYfFKoLhxeR8v/1MkPAU9Ki9TkHlriEiQyjhgqkO90JqyDUej
	kVn8tZy6mPGF51OZBWU9OQFb5M9B0xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=2Me9qfj+R1bdrmrR2s+wBzTiYLghzmcDccJAUqA0ovJUiDkgv9iaq3xebcmPq1/squyNQ+
	1fzgm5G3UcGlfnhT8r8G4DhEqv9y8HNsAH3nb0wG3XnGVpm6+MXxYpvdEIg/k/eHDA4RyG
	PAJR3F5/xUBnQc2OxvpzifDMlqBs25c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-e21d-7f0000032729-7f000001d9e2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:47 +0100
Subject: [PATCH 21/61] lib/test: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-21-bd63b656022d@avm.de>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2236; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=dZgGx+TJ86HynJEVGMrEA5pIsLW37DebkwtATXmSHOI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYdDyn9P9EqiNuLjohkPV9X7iASajPgIoE/Y
 Nuv6AjHInyJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGHQAKCRA0LQZT0ays
 2wT8B/9ExWKAo/Sn9Hy5RU9mMJnGJZfEhSDSh3BrEyzAo8askVVJ9+5gjVv5zubvVRZSl0xsWYD
 ONcBymLUypUnGPDyKoUOhx2btlwnIrxM+A/znjwtFfejlhgahBH8clBf9ppwmWxz+aomfSi8dH0
 gI3DmyyOVIa4OSRnV4I+RdKzJvI1/m5sEwA+61ywfL4pM19NmtFK9XOne0dvmugbwth+SSxAJRb
 vUziX2Dy0AcV+RxD3aCuKKv6tZLzJkBbkKbaQ16k0qyAZb3zbS92hAPdw+yFsGOJMaFjGgEs6OE
 FCCv3wHl+aKzbAwbrH/eK6sw740pLs96xx8NapXtmcrko8Wn
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-98670F2F-CE18AF23/0/0
X-purgate-type: clean
X-purgate-size: 2238
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: c85tuoncct7n5tp6yg8bobrmk5xbdwfn
X-Rspamd-Queue-Id: A70B01C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143729-831229
X-HE-Meta: U2FsdGVkX1+vusp6ZOrDLqm5e28COK00VaKl1qARyh/xzrMASga/Hw09bPnYpSurQBcGoUZyCFpgD/wPJL6bb0UIdb6z79IKoStdokkBvam4ckL7dT2X+Q0f1TCZ3T/YOZcsYUukhQ8FK+z8wf7IB/Qhp4r+ig92anfY/xIqj03RHorAPQQD+VwwV9xbH/MxIW4MYx5MA7oXkg/dELW/k8oKjZE7o4tZBUCGYBQCVL9dZ+tctrjwrkFSPKcTEbIqXEtn6/QRFLe4Yk27YEbQXFnZv2H9xK8tFHyRzXZmnxIAN9VqRau7xWG6DdsiieoGH+xNepG+wEcKc3ilfoLIKWYI3sLFzoB43kOFA0fzbo2DbhK2mUL7Tpnomxk5HKqMN/nArfPVK3DY02Eegi0T2ewO8l/pLG5CzYccH70m9u55uwvR50dan6dyegKQJu2qy8lCIvsh3kcG42lAQYeYHglDh4lIpSztZYCS+5pqTF9L0BBqu3b8PU/A90+WweUC8GUkNmZFKeIBtlcVedM3BQmTlPHjUtHclcbYTvN3hhmvnvB0mP6U0cZudh3zB1xHlm36qqOtHepGA3aY4cw5SN9CAK3ekISnxZZyinNy4BlJOOba1mggBoLbFowCzBa2mVgq8L9Ir5hyor0BISFWi+lP4Ku4YxvqgkJUxD3c5F4ZvcayR2gnGrB/R52lHb3yGTTsdEUeY4rz6EDlRdaKzi7QsjRZCMikW1WevuyFiZ4FAo7pKt6E1ZQWD0GJPr1PFfShC1k9P/CL9/h2S7dCGIvXHvioE71Ib0Z7KtrWKn0Xlh0Qx+BB8ljncRCl+zh5rIC8k4IHchTgN4byGnOKPOYHF95JnQEgXJmb9wKmXZUzbBPSJSZs+rzPKJ94i/ovjR5CQX8FGpyS4rNUGKgnp14GUkUhc3+7Y/FA6yd1knJkbJxYJRSd+rggIUzVjqj7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Andrew Morton <akpm@linux-foundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
To: Daniel Gomez <da.gomez@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-modules@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 lib/test_firmware.c | 2 +-
 lib/test_kmod.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index b471d720879a70c0db82e605960abe69de28ab4b..fc3177927a02e2d7849915309048529395ece0f8 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -955,7 +955,7 @@ static ssize_t trigger_batched_requests_store(struct device *dev,
 		init_completion(&req->completion);
 		req->task = kthread_run(test_fw_run_batch_request, req,
 					     "%s-%u", KBUILD_MODNAME, req->idx);
-		if (!req->task || IS_ERR(req->task)) {
+		if (IS_ERR_OR_NULL(req->task)) {
 			pr_err("Setting up thread %u failed\n", req->idx);
 			req->task = NULL;
 			rc = -ENOMEM;
diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index f0dd092860ea6f9c69a71e10cb1c8b071b1cd1b7..f44a181f6f1ab53cf95a0a0b598b88cb5f8f369d 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -327,7 +327,7 @@ static int try_one_request(struct kmod_test_device *test_dev, unsigned int idx)
 	info->task_sync = kthread_run(run_request, info, "%s-%u",
 				      KBUILD_MODNAME, idx);
 
-	if (!info->task_sync || IS_ERR(info->task_sync)) {
+	if (IS_ERR_OR_NULL(info->task_sync)) {
 		test_dev->test_is_oom = true;
 		dev_err(test_dev->dev, "Setting up thread %u failed\n", idx);
 		info->task_sync = NULL;
@@ -358,7 +358,7 @@ static void test_dev_kmod_stop_tests(struct kmod_test_device *test_dev)
 
 	for (i=0; i < config->num_threads; i++) {
 		info = &test_dev->info[i];
-		if (info->task_sync && !IS_ERR(info->task_sync)) {
+		if (!IS_ERR_OR_NULL(info->task_sync)) {
 			dev_info(test_dev->dev,
 				 "Stopping still-running thread %i\n", i);
 			kthread_stop(info->task_sync);

-- 
2.43.0


