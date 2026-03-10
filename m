Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A4DEB1058
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D026B00C9; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8016B00C8; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD226B00C9; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2E646B00C9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0BEE1B6A69
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.02.714F0AE
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2E4BD40005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=TM6eg5Is;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV72CMYAk6e4y4cmuC6hk2BBYqxn5EFGLbw+817rmrw=;
	b=3mDNeJz7d1Kc45Ww9KQk0IgBShVR2kmmchfmlCgLLXwWT6eR0BXWsn1h+L/EGVO0yiz2sX
	Yp+nDvVglobvjJ03hdnQYggZBt1g6TEkm43Z2eft8Oy1exFi9E8xrOeFLA+Wb4MqjOxPoT
	DEdsujmmocZZ4ltkPR2xuwSXOFGAqkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=eK+u2Oa1F3U4oUnAGk8XIW9kM7dUfw/Yx9SYnjf+s+fkFvcX2D2LFlhV3r6BnArF+hpfq3
	CubWhzDxMo2F7nZ/pMXTC0mrg3ItEmdI5MAiEiXwtrzi2uWyluWO6S41rMupiqPhv5o8x6
	MGXhhcSnWi9BGhwjm95A1PI/zLbzs5Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=TM6eg5Is;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=qcffqXWHqw29zikXSaMyeqsF5SNAPike03t0qIAEHZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TM6eg5IsKDZmgxp7GUG67+/57rD9rEUbWduf95eT5FiKywsNOkOROxJd1HgADueu0
	 XiuppY49OLz9JAJVzWK6kmZAydSEKk8Yfb3LCk0edxsTMHOI+GxxxY6TToBD+hBFBa
	 LA63nSKl0Z508Ju4IKsVgpiypr/7gGuby3A+F088=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-e21d-7f0000032729-7f000001bae0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:18 +0100
Subject: [PATCH 52/61] gpib: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-52-bd63b656022d@avm.de>
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
Cc: Dave Penkler <dpenkler@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=943; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=qcffqXWHqw29zikXSaMyeqsF5SNAPike03t0qIAEHZQ=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaHLW+SPsUXBzKjRGA9Sr6z74iUa0aNCqDAC
 Dpk7k/CQsGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGhwAKCRA0LQZT0ays
 2xngB/9RQuwf5oN7K+t7LSQdZxyrxHOJcTw0116pWThU0XUv9UqQRCLX3DDjBAMUn8ivSrQQu3j
 eCXsK6Di/TiAzICtmQnhlrY1llqErJMK6D3gMknGUqPIUGtryg9JlZS983aqFsnI2NTWJkyhY62
 zoummbxiGOU/XB7LGr2KWmHwNok02P+rt7tXG3k25rPUmB1lXXK0IEKQHC6AYoy/xbYJ43MpYYP
 x2moPKs1et3YrKZ7IUmRwsJyLGDoTojj8VT1rAmn5p4RXjrw+bZItwBB2HSkOSM+PFx6Orfgajc
 95nvtBvD0Mtdm01bQJociZB8XX6BHHZ3h1K5cS12ZujFOnCS
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-84E19F2F-525884AA/0/0
X-purgate-type: clean
X-purgate-size: 945
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E4BD40005
X-Stat-Signature: 7iox5yg3wi7n8dgquqpthc4gm8ujzo5j
X-Rspam-User: 
X-HE-Tag: 1773143732-960027
X-HE-Meta: U2FsdGVkX18NJlLtGV9gRKvVXcT0GWWzeRTIS6QGf3LyEqKfTKcMKLFzVyR08JucqlKoY+4ABqv9wl+rQSoEpORlC2AweeYsNGjprJ03qxlxaaWtotpUd5ej+qyFUZgFxLiBpZ3Ih104M/fV+v5mD03Vz7aAz2vD3XQf1jzc2l8Mff/1Tpq8MU3mbL026mq31RHNzt3kgjck7gy4oHIP6UZ/0UKP233R8SRrRu0daRGSfCnwi3v4cd9l0D0lZZvO6zAp5dHqHUo3vArHAxc6sOI4tdXvvhwq2w8BM/0/JJ+UTh/5oXeMN2As+/jIBUCm5LikjXJtfGHkb0VyNO6NdK05Mtsg/5QL3B29pV+OaB6hyqqPFfszm338mKXxggRsFkrRPkpWyc8A2RJr6dgSkEJPkV5vzhDl+Xdyi79BpR9wEYRKME/zpNVbS/hM2/PMb/weTd0ve73tRQJvjfMGWUt4qvOcywn3bt2eqM6UVkcnoro2APgd508nI8mBg5YFhb7B6AnBFQXRvOM+EHP5lFzezJyoj/OV6Jzk1kwt3XGJpULdjrdxa/rqLadInO2U5Jy+Pb6iOH4u2ip0Qa/N4vYz3M0E8PUwBeLF/1ZpAp+tOvhlsmW5stZtEErfSpZgbaDJ04qaI3zFEE8xwpUuF00yEV20v64txqzT1hTOwIL/VzTi1PqIRZMXZss2goJ/r1RFtBqlHJWw9eC6+pFyJOGc7AHd1gScW5IPR5j7huhovosf2cDQVfiLnH4t7a6Zhu1IgZHGNiemsf1Z1HpQryBaKW7C48S8O8PmAf40zGIDDEuxpO3OUS8wD86RsYN77hBfqJ7ngcFtj+Ihl0HYVzig3avLPpm2AIpbCWO1hX6bMirHrJAGfhdfRMc7uwKzdfyiIe4rgPqpshFP3sBQBk7FB09xu8H4lVDyF+19aAUHoX6OJdcKsVw9LVF+9olQC1T8/fQMmuPU1ii7J8x
 9IEVzYZ5
 X57HQwzJhseTZPpxokUKe3syOs62VmM7wn3ud24347dKdK9chRrhjO1dig8ZPOEMmgKkuueJs2FGk2rWRuApB0HZSVAKCLFqVxXJ/0T0Yvk4YgKVOpM4nIhfY/GgpCHBKIZg/ehxcTQ4DkgFlI2LXxJMGGqPUp8OixGEedEt/FHweLtGjD9GrtDA1INoV5AKR7KAykAGa4fKK7wO8BgZdEYlri3TlApg9FJcLmhLfHugWjmky7SqRJuRxBPVkSDniXNuISyDPBKBNpZNWd9Rq9b0jDdKyD03LEw1tTT+z3KBezc4bHvMFsp9yF4Qr1vpmnUE4zoxNEiEKbSZwg6AbxyvKJqAruQDy2D/HNwLyPoqbk9F8z+S9HmYxzm9QdI/4asW9PBlT3xXB9nJ6YCUsNN38Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Dave Penkler <dpenkler@gmail.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/gpib/common/iblib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpib/common/iblib.c b/drivers/gpib/common/iblib.c
index b672dd6aad25f2f4f36d2a0ed78a0625651ac8ba..18188228a90178ba0bf7c6c923924a99a8ace1bb 100644
--- a/drivers/gpib/common/iblib.c
+++ b/drivers/gpib/common/iblib.c
@@ -249,7 +249,7 @@ int iboffline(struct gpib_board *board)
 	if (!board->interface)
 		return -ENODEV;
 
-	if (board->autospoll_task && !IS_ERR(board->autospoll_task)) {
+	if (!IS_ERR_OR_NULL(board->autospoll_task)) {
 		retval = kthread_stop(board->autospoll_task);
 		if (retval)
 			dev_err(board->gpib_dev, "kthread_stop returned %i\n", retval);

-- 
2.43.0


