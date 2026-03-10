Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B9AEB1057
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100516B009B; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021EC6B0098; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76A86B0098; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938046B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 612D3160134
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
X-FDA: 84529998378.17.9653413
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35029140015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31cDH4wEE8DkguxOQJCHJDJ8IjlqlTHXxGMfQIFEu3g=;
	b=xiX1iv5InH4bBkWBmChxotjI5ihdLP7cJZSaoRpeQWfs8QH9/0azbKhQe9D9uB64QWi2CE
	itXnRWdy42iXJ/OO6cr+6xiWYEr8h5pVJ0e4JFZu+QfyYl4g2dCq78+EcFO0sxvBvaBUSK
	4fGiATeDygo9XsMrySmH8hU060dtWFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=wFiBbr+lVb1Zjp8zbPAcuNpjl8+ZcPDwcaOUPfmKFlEMpy9IppKBqFJZJ8DgJ0y3EoHbBc
	0sRUtbT8Yz7Qc8uPFP7hmFG52wcCXXJve1c+nvE+UoSxqiMAs2aXX6rBkJhoiRZIC4LLgJ
	DEtvnZSbnzeoe8YyWqK7lkV4ONx9k6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-e21d-7f0000032729-7f000001d9be-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:36 +0100
Subject: [PATCH 10/61] gfs2: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-10-bd63b656022d@avm.de>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=893; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=OPqqHdKZkEBOTA9s0xCv07joTtAqSJfXU2nXlSYlnvo=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX4/dv49K4j89zI86N9JpAw6t8eU0kmPVDxm
 PT/7+a10hGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF+AAKCRA0LQZT0ays
 2zIKB/999m4RLBdXe9kckM0CjKr4GcE3BeYjqHOf9Mb/fXRspIYiRhfK/0d76B0wUZ9vMlV+kHN
 aPugbL3mxS3VAKy9S9eV+9mHhq2ovSgAXuPOSy8/qOTGHUqDaNzk/2uQki9ZfnbI3N1QVu0zj5x
 8blYFqhhVL5JzTcz+RG+KziT6t1xXKbIKoya+t7T6UrNg4H5H2bWy4EaQ7+S0qT/OwwuCndJ5uT
 z17dIMTDIfQoeXt9rkvrr2Ft1Brl0Ry1Iiv5kD+CcJTipZJNdlQgICgttnzL/8iG0G6ksTSjehE
 819EPypp6/ZxNz8oLOAo07gCKojS6jLLwc/BvUWqoKOgacEb
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-363F1F2F-29C6BAA2/0/0
X-purgate-type: clean
X-purgate-size: 895
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35029140015
X-Stat-Signature: hr4rzo5mnwb5zuojfgwmfb6ntnafyw3x
X-Rspam-User: 
X-HE-Tag: 1773143726-271729
X-HE-Meta: U2FsdGVkX1+ESl9kSNVLKGsM22QlC5RW6MPHZq8URm4mxsWiyWnS5GJKCK7U09TFWgatjWefegGH9A3FBiFxcb2VoQwR7mwGFW/brSaTNqkytnioFHDLfJJgyvieDfbQLJt0u+W3oZSA3flBb9G838Dkdf/+j8fPNxdu9H5WB4o0MxPSrSr0eJiYmys9RgXcJVzOQktSnoGzk8O6AX+0xjJSBPGbNHLPEP6OBVPSsh4XUM35ZXYyvTAzSHrSClPG9uOtPworYjxlW2mRyLH/DpE0O1VLeceBFGLQlaHdqFlYnqN+rBW+dtdAxSlomeZhyu1V7cu1J6tGoXcO/+MV0pNT0Nx+I9dv36tFN+pYGUMsws0t7WiUaGao1X81isvraCKrLuTc4nYdfwIuR+tmHOxnMGQ2YH7Z+X0OIlnZF6V5/2V+Caa3toqGSTKsN8SSvbXLW8PRZ+Pwfcyy+oAyfHlpaRKzq5cXcX7O/P+OUIBvYhDUI5FarpOqCfwmnebeiC6ZzSjAawUUwYlEEiXvB9Lc2Dh0vPiRd/fRFWGouJMuVVHaQ0D89S5jcAKWh/jg/d572yK7+7Bx1mow5QwNi7V16hQkY/Cp6xfpT3ch4NbLVIsQxRpj+BGo/kjRPjXHpj3CNmOlvDYA3zopai1MgOPVjfnMkwGv0wipwmUs8wTVLZ//yVFjsjK9cA9UT0STWnvLEtysIsxyxZTNaVlBZdDFh7A65joOnEisqlPmvEZkUQ76rowobkwIv44cS3G2sgrKMLZe1E7jzMNTB2oZaNPsYMV2aUXFY/UPWhD+iN1brbjqgdVe0xOeqEmjkCSYPLh7NZt+rt2UFDF5ABg4rc3456MBikUhZx0coqpPD0TL+6cmKU+NdfXCIU5iOGu3dqHbsGmAmDFlsP7Nb4pWcgUqSlunm/h/ACdCuIK1UZXuBRzLNUADXw6a3dqzEUmBfkz9H+JULU5U0GMlkL7
 cxSq/LsH
 p3+Fj7B+T8TfUcFOhixZeGMUQG1UEne+FWAhFgkunlycDMZTKminL4SPvwNOhxgF+YOBpOu3vVi4lZdzWZIS2PcfW/BUV3BZUVJVIWqgnOU9T8BzQ/n9qumaNnLdNMwcURwCX5k09E/FzR6z3apSNaJRunBSv2iCbE57iPbZfjJRw8oYd9QBF1fNAWIxS/gbTcMAJgjrXWw5X29+DpgoWH2x0X/LdS7oAEcZ7ZQXM7usOxrrwTco5xWQCiirtVPLzddxGjnH2B2YhPQV3FfzSS2wHCy9wRYX4DyrcRZLASeRmP2lnnKpdZ0ahWyJ2bbV5OE50FuC7OapiFO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: gfs2@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/gfs2/glock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2acbabccc8adf957e02845041193502a96370a6d..8ed6b4535a728e217e5cec7b64488583b5737c58 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2013,7 +2013,7 @@ static void glock_hash_walk(glock_examiner examiner, const struct gfs2_sbd *sdp)
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((gl = rhashtable_walk_next(&iter)) && !IS_ERR(gl)) {
+		while (!IS_ERR_OR_NULL((gl = rhashtable_walk_next(&iter)))) {
 			if (glock_sbd(gl) == sdp)
 				examiner(gl);
 		}

-- 
2.43.0


