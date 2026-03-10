Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDE6EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2526B00C5; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32606B00CE; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7B26B00C8; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B76EA6B00C6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 832BA1BE7D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.22.CD04B65
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf27.hostedemail.com (Postfix) with ESMTP id 494A540003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=YXGm2fdd;
	spf=pass (imf27.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRq2g61wWE1srncME+gnVjuT8yOFss+lGNNn6b4Uit4=;
	b=zjd6acJBdhyrRtZjry3Ejw17T7ljuJFf16s0Ua4cVOvKESWixhK55DtCFLemGHv4yhL6ov
	xev2blGSEfbivvLwd+XYZ0uxM9rLkf7BcZrTak+9JvjxQ/E/yakxWYc6WHeBIGrn7A2Ksp
	rILWCOM1dtdsshDhhLeXNB4DolXd7/U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=YXGm2fdd;
	spf=pass (imf27.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=ZLIlvbNtD60BjrlbE3iOq/VpwoAC6PBDzHbgY2/UxemJuBcPhHR3g81sCcyTxKwH++AY0w
	klr59ejAKlNOFl6rVGYsyCI06GCak3/Foc55KUkcv/iVwTehAFMA7TEmX7yIf6M3d6VGiF
	MZD0vcVEdpnz35BD9VlLNShHuL0FkMw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=r2ZNUyu6wG+N08MfsdquggU1Q5xHuPu+4B/VYVv0t9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YXGm2fddB0bD05XRQUo0zroBzSiXv55w6mXtnC3/rbyTRBzDlz9PWwan2loANEchz
	 3nUHhdwioF2zPrdtj5GGDiz2/RlpAekCz2aZgV1toF9qbrEYEb5oV3jU7h9yUVsShF
	 X4koU5bE7tqGGpl7IdLmkPqUNFFBIWSBlmjRRwMc=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-b734-7f0000032729-7f0000019c66-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:20 +0100
Subject: [PATCH 54/61] aoe: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-54-bd63b656022d@avm.de>
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
Cc: Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=r2ZNUyu6wG+N08MfsdquggU1Q5xHuPu+4B/VYVv0t9Q=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaNWcUAch/xMnI0wAbOgPf41K9NsP36Msk7P
 Nki6xRL5YKJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGjQAKCRA0LQZT0ays
 2xbWCACfzS98X1Mp5R5EwpIK0pTgqrssQIB840NNUj3GRa/d9D29Lch2JFjR2Yy+ldzvSmEDJYr
 +FATwB8i4z+nArVkmYPgbG8vodjj8pep1H5lik7YhU3G9ClazVWr99T039Q+W8sEprULXLQ0dbA
 4Kpe3/L1QfxY1N+GchfqAHMv0rRJq1RvirATmISGmxTg7n0SEymJW83Bn4X8R0ZnvK6kohy5NEW
 2Ii5RKfTmBA8YgN2bfh5HrwrKAUrDiQU4qD40KTADcaRVC7Oxd160l9rFHE0+fB+GiDoct83TcC
 /85+2RTmaR+Iva1VQ69ftJxFcgDmZC/vMk3mknKyTuNPcNM+
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-DADD8A3D-0ED39ACF/0/0
X-purgate-type: clean
X-purgate-size: 957
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 494A540003
X-Stat-Signature: ixtw6hijks8cgqh9hw6x8gns6x37n35z
X-Rspam-User: 
X-HE-Tag: 1773143733-603689
X-HE-Meta: U2FsdGVkX19rTlrcp2qHg6NAiJ1GV3t5LBsVPJHohxSH+c/Yyeox48keQTN+1W/egdAruC1FkcpWqao0bUF4awhxPZplJeiu2Y1XfuE7wm53Szr8zwJO90FVgInMhUqpmv+WNZbwGjmnK8xl4SWfpWvKSHAlvn1i9rivMmoz3dcX1zpWoGI5Ft5aLnlE6HJORrZMeW9JIFU+Vi1BFAybsq1kEprM9kK+yXSzv6bF1M2G1WNItmi0xV5ElELieSfUotfQv+Ua6GbA9v91KgkzYNR8p4obmRfOSo5brhBqwKkB/oEhS1FQM+kdT1Jhdj7HADGDvSkrdYgbl87bgVbGdjRYIXYk42/YtzsEqQN6esPtxdZ4YNPvJ0j6Csu2LRi+OvSOtjAvEnDfsbXZVagyk/DpT+pv90dXN/8hE9X6/WjjFtJ08J7vWhGzr7XHHk3KjBoMTF3CNxiFHJ7lDBo3hojBi/eO7ZOAzCP2lY5oVc3mtyFXNjlETokn7Adbmz1DMmzPy3ThRJuZbrOYf1fbdek1KkP+4TaBGVW0bBWvhiBq/auqnwHo8tQzg5sj1waKG8ESYv2OIrRh9U35wZBaBcsEW4f0unMjdOCe3KSYcaOI0vuCUbQZjWHIW/KVtNhHRX3DPlF3q4fQd3kYlBRIZoGtqaiRgWmDpXzz72yS5pxyXgkyklW9zsKGvLzIlas5GWwu5fK7GZ3iFEcKuwauOdGac1lBRz6t7LOip8l0+byuLPuBE46Fav08au3lnco+AQXo+iPJpaflcsiD5MRlNfaoJ5uMZAu+I58QZcKJb9M+oEMG+lJ+UdXNrkkpmN6HlOIlBUvfDFr5Jmkg2uU6vMf9sG2qoIIOonKSxPlt9/TMNq5mjvXLA8WxvxVeDGU9uuDKH031C+a7jc26OmlQ6ajjZXQiJh5UE+nbItYTYf+qKUJg1pTLP2oOrwmvCmCXdA9y6OyWp94TO2obTzM
 XAMqtmlE
 ys1gEDMNhUrZq/X2Aa1Z54ny3h8lDB7CQDFPDPXF8L/zneWMgAVsjFT1Ia8UgTPqKyqeTN23tEPDHRSyzWe/uvbQMcyQOFNYmXv7sp46c/6lf7GP7rDQ8xKFDKBoP0iNpxxGXf5DrDGzrvmtjpkK3ko/Ozs4OitQtJntXhjM7dV5+/AVNK5VzOAv6A3FjerWFMixiC3MnZm1I9RFFcwgs6DaU5bvII/HYM6fnofwcfP0i9FetRo8B069tWRnysaUL/toMZNKB6Bx8v3MpQi15Tj7c6BQm6wnykg5hGofN7uTKyEKoZU74GUzFKmFgFQj4Ttl1GE6SF4V6yr1sO3MkTlpC0odOQsw5eL17A1fWFD6FZDcT3DTQJh+ovlwVVZbm6Am4xZuO5HtkNXoQ67rMwQ0oQF38PAJQIW+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Justin Sanders <justin@coraid.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/block/aoe/aoecmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index a4744a30a8af4ff05113f3234021eec728265b4f..b31e539a66433a0a5d6e81117a32d12735ffc1bc 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1268,7 +1268,7 @@ aoe_ktstart(struct ktstate *k)
 
 	init_completion(&k->rendez);
 	task = kthread_run(kthread, k, "%s", k->name);
-	if (task == NULL || IS_ERR(task))
+	if (IS_ERR_OR_NULL(task))
 		return -ENOMEM;
 	k->task = task;
 	wait_for_completion(&k->rendez); /* allow kthread to start */

-- 
2.43.0


