Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264D7EB105B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2986B00CC; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0BC6B00D1; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690906B00BF; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C89426B00C2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AD90553DF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.29.E83A848
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A742140012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=BoFkjZya;
	spf=pass (imf26.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lvZfuNFeBGCQTG9VmwycsVe3kjmL+ED4p3via/ahr4=;
	b=TktuD650on3n0655tGOlaRNk/YbXYoMODzr4QNwgDVP/q7w1nwSkV2uvbmXQGoZWOo1sE4
	jMyGbnY3hH6bBz/ApGrZWPvkCoQk3PNei6PVTTIjMg6JPCryZRLSaS0wgPAoQyXypeonm3
	ZWqKWbCP+qvJOolhg1rYhasRdDdUYcY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=BoFkjZya;
	spf=pass (imf26.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=tLfTjyPrbEZvJTXe9A9NCGuvWDcEkLD0O2Otaivy9EqR4mOr/vcDI0KLHtCzZu8dhhYAuv
	bEQxjI72cH6DWDhcAiFS5Ddqqfmu18qSZKQy/eGKbbmGIUfIJcpkBSUXK8I0dF2F7sGyVA
	poyNbfbJq7e0N/db35BVYnzWG1j7Fx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=a1YtuPUr/A4Jokjiqoyr22dEN0gVE+OOIk5/iCzuB9k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BoFkjZyaKFG4I+0my0U16P/ZlsfjMrTgDD1a+wOsKM3wW6Hyckunq05e6+k99D3Gi
	 4kV+7om5pC/Efx3ZEKmiJFTqpv4USFiYyuVuVp1V1iQJ18dYlrQIte47hFcyWAgg5r
	 KM84isD0nokr7A5umpY1I9BsMYrFHMDwFBwVekfs=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001baa4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:13 +0100
Subject: [PATCH 47/61] nfc: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-47-bd63b656022d@avm.de>
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
Cc: Mark Greer <mgreer@animalcreek.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=a1YtuPUr/A4Jokjiqoyr22dEN0gVE+OOIk5/iCzuB9k=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZ1Y/UGouoeQcc9WQ8MxrI8d8MHBXHMF2nKS
 xW2sTsLmvSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGdQAKCRA0LQZT0ays
 20jSB/99EGQGPGXfwgc9aoZkEd87WlbZAw/E49hsk8skwCBZpOQIbZBOjpLkfsW3KBFKwpYL6hr
 zj+vjAPS0Kbx/wu/htgTOseyb8dlXJs2DJCBqPrRUWk2pbJhfh9SL0jieoNOSPl5SCoElM11Tk7
 rVQVkuo82qw4WSlg3liLUmo4Aasw+ALrReSJUM+VyOL2Xm/NrCTSIkyRe46UeXgqxXym8K01Jiw
 UcwLAnfIONTcOH9YPD1gA7uZh9C/pYgWe8DkJu23THTdXZuc/7KopxZDLw5gOH2D1JgCmfeTZcx
 ZHAC2ZLeQRVUrAJ1qKHgI4k8WSRe11aWcTzhA96+gLBGdLHb
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-8161EF2F-9C4586C8/0/0
X-purgate-type: clean
X-purgate-size: 1021
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 3A742140012
X-Rspamd-Server: rspam07
X-Stat-Signature: bhb8cidajb6k7xm4yoaksfuy663edewj
X-Rspam-User: 
X-HE-Tag: 1773143732-858833
X-HE-Meta: U2FsdGVkX18QRU1MRxsX/0jfEF1cgxCn71JoWIs++ysDelphhfh7sLv8W1syoaufF1aLzzDj/XnvgaYkv5yZPFkVKL0Ksu+aSwA9AK2EgzLcL0JjjPGLPbh3xKimSUQsrLHdj9NOxtAALo1AsU2w3RBvX5quDJMpVAKGqXNjmJu4maujrWjety3sCikgVhnI4VndQw/iSONm5ZaT6L1KfHjp8eDC154Nndt/dDCuLYTql4R8xI9opAUXXW6PMZnCn4bbefvukwbQgWN8j1vrigDzCCXZz835k6B5uszCXCQFb2wtFGdkn7GM4KZHFOQtaQI6MksbXjxJav10HqpOpRQ2g3idEtdKbYSzxxymbI2nyytLVv8K0pQiD1pQTieg//LF0zjFIhbuVvImqtu8wdLUdmcfVN4oj8ej8tf7DQPoR+LEACV75O5RGqZ92xPiMsQqpm4vMAFwBxe7qW1/IrG1liby+UFzlHztgxSbdnveX/Qf61I8uULzoOpnV1PU6PVm+wPAJuWu4Zs+ee+EuLZR0a/Fsr20fBXXPOomPNsSi6Fd6dm/ZCxDDcLsC/w5AkhDZ2zDQxijB/ZnJCAa5q+a98khJj7bFRV5jRHayyem14pl1YYQHzxSEHams2CsdMDqL7RBBs/WmWY7fVYY9NHE3vDmp81wH6mdqOstCQr1D1jVUE9uqp7CdHVGreoAidJHvj1Uhve+vE3A52ldYPTw2ky/XAuLOrcmKfPW1wNNSW18pKlYjTUJYhX1o8Yp8WIOakdMkiBH0fdrN3QC0W9F8R4kde41rCIBzdmH4LN/XfOi8k10/9WeWtFq3GUobkEbmbx4qN/TC7noFZXFm+vALPUphhFtS60jTiOypfUR95EeQBFZvMwnQpkMbx2BJEejCDazjzq4B+dVsQYBibnDK+hSfMPLOplGfkdvDEkj+DAideA60QMY7cib/NvNfBpCvo3JwDKGkoYHm1y
 8Pne6ZWz
 eypXDuDdRayDPUY6Kii6UTfWKwH+uDEagATZr/8XkFnbfZarTJW8faZ7ZRAanCeXm3/Adyv9PrvxLX0+3ouMcgy+KTo2olt8rdVFLiRpjc0iL9pWRqVpFlu+MSvzjqAuXL/G2tQypct0WqIFfFjGKfnvFM6QbnBwjbhnphO0Z91FF6FQFwQ51v+Vb5Ia2rS1pUQR/kMvoZIPlhPJSOwiJZ3VIENPEaTHweG2LwJ0N8xPezWhcc85R0YyPTCE344GuOUqCzvbBH+cBZKhSmeem3xGxVzvE4zteAH5+8pInCXoXqaIY0ZwDGEUbGDKOgLEQYg1VWpijh3YNclQMqT80JeuBURe3TOgoszgFrf8+mhmgxEzEVxQNJYjby//lJMqk0ICud74QSG7EEpfevryPb2+HtD2t6nw6E8z8fILpENgZeI4Oo8pXLprgQyEOSzPXWodp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index d17c701c7888b3be0b46cf95c4b77182313c97c0..f62fc2b80b05bd7a82269334d7f50e6394bfe80f 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -651,7 +651,7 @@ static void trf7970a_send_upstream(struct trf7970a *trf)
 	dev_kfree_skb_any(trf->tx_skb);
 	trf->tx_skb = NULL;
 
-	if (trf->rx_skb && !IS_ERR(trf->rx_skb) && !trf->aborting)
+	if (!IS_ERR_OR_NULL(trf->rx_skb) && !trf->aborting)
 		print_hex_dump_debug("trf7970a rx data: ", DUMP_PREFIX_NONE,
 				     16, 1, trf->rx_skb->data, trf->rx_skb->len,
 				     false);

-- 
2.43.0


