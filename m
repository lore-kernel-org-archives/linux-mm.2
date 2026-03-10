Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD2A6EB1055
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E076B00A0; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE496B00A4; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CC46B00A3; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF656B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 539E51BD3E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84529998462.17.8AAF140
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf18.hostedemail.com (Postfix) with ESMTP id 291981C0010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=pkZgS6E2;
	spf=pass (imf18.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awwiZWdQD63BruGvltZFRwj8p2Y5WEoFULKdNAbwIBo=;
	b=0/rhHRLi/6EAFAWaJ5ThWfyl+kXYhZdL+xq/2esyGQTvG8QoCCWmbOztRNzmBvAU3nGTiy
	zt/JH9ZqlHf7rdd/E2p3yp1gShsbePxBDOEscU0W3szAydBoGbiGwXmu09vL8rOBD5dauk
	60mW4NV4+aTRLMW0H/CfLQ8GM0R37Lc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=pkZgS6E2;
	spf=pass (imf18.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143729; a=rsa-sha256;
	cv=none;
	b=6xj6sbfXehQgwuEqIYbNrTF0GrP4h9t6JNIiQPwt/8J3S3RSlfdI4n0805D/vmPFBtbW7s
	4VIp/odEHesR9Y+SVv7nNAgO0QnWBscw2VvurWm4F50BxGTzs4/FaQms9HEYb606tJBBrq
	EdMZc+2WrRsNyEtLnNPUmxalcapI3w0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=U4MQ2UyTEtTm9FfUFN8u0E2v86RR/vLyOkwrg7Rl0HM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pkZgS6E2b6HyMFIjBzS/B+8+S0biV0Szf5QLvjvxmALO/k+UU3HGuHgtEcUK6r0hT
	 l3sidqEaLmVC6CjiI74oRmEKxGfUqB5EqeVLendnLbzsQ2HomXxjkzlaNLXsRLIGkS
	 uT2G4P9Dig0e7DdWmJ/gJ1GOA6l1sZgQVMwHxKoY=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c046-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:51 +0100
Subject: [PATCH 25/61] net/bluetooth: Prefer IS_ERR_OR_NULL over manual
 NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-25-bd63b656022d@avm.de>
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
Cc: Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=U4MQ2UyTEtTm9FfUFN8u0E2v86RR/vLyOkwrg7Rl0HM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYq6Vp4tN82O3UqmYAB2rCpxamSEi8qzxQbQ
 a7J5ECg00uJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGKgAKCRA0LQZT0ays
 2zTjB/4mjCTr3iXgM6OBkpfxhcEN7EQQZ1y9EXzSAaaFnPJ4J6dbscyHQ/vrwihzqSCkid2ehYX
 PXWgLr3enkVF+dbM8V9NRPpLg6F53eMyK7CDWQG9AEEJdJq5IDVkThiVxeIs2iOyPBRVnnYWh+Q
 FhA5NtTEwVLOnsWfWahJLqDe7jVY+yfeXhrX4z5N5WnqSQs4m5vScZRnTkdBPMBPzYgMtNL5igV
 SF/croNsrnotNJXtafaXYhWm05HCgfm5TNLHJLZIRe+0bC9Er8RwnfgRXEDKBgK6ljnqVy3QgCk
 bdr+gnx+ukbOMXU8jf2GxeDozNZ6NjdS7QCYNHlx/c+fJCr+
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-27DC6A3D-212813DF/0/0
X-purgate-type: clean
X-purgate-size: 1524
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 291981C0010
X-Stat-Signature: ejyytdoa74sbjx8n8s43ib198xfj9j9b
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773143728-32879
X-HE-Meta: U2FsdGVkX1866GZDTmgzrMbGXsNyXP1xK1e5zYoIvs5LGwJiMWEIRmZjr8Bcx5J5qkR6ZOJYsFmiN3IqyqzPQ+xvk6tT+pcCDNnLizX5axGKTcoDuLNspi+HbPCRxcuiWntZYsFtVfrnpmAGEInCYHwBJfk3yU/nwxCfSgyKzW/AbRN3CJhvsawVhsPqHJFSkGwVUJBFA6pwtvQnKdOw8O2lJxV02phq5QX7YSARhlaWize3MNRL43MWuklC6W40ZJDBSWc9HxvbdoP9dtf1T+2n4VhGVVhDhgiV0/eh9LyjwyMw12JHMWJxC2ddGWnFYuyOeHKsUyXOCrTxfLKCCaE7Bg4dAirUqICRcyW4GyzH0LERkM4RfPlq+uOZQznNcgKwB0WphSRpbqX7ur+PH9K5yd8j6ZYDoiF74zSGrpssiczxPWIwqISu2Eh8ydLEJtbnMynbZgzRu+6zl5HZi4wn8nBzazIUoamQK1EBM3ooSRDjV3SF9+W3VFWrcH2Uun/NKUF3rHiMmI1P2SXshv0V984S6lqANxCp9+FIA5B5j+zE53EgLO9ka9qdkIK9JqegkTceu8lhDuVCA8006gjk3HorYDBa4P3YqRRBr+z7YFMBbry5SmYOyEO9f2pcecLFN1hBxbY5sT3ejCd8PotRde+w6Sqx7I8kCjZmu9rXcsVnrp5QeERxYEBIW4EfDLUKfSW/r76q9+3DButP87IKBdCnaUIhU2I2pVUhIufD72V1U1r26XW/GWspbKfpW++FBOSBVAkqtU2oXDHrWGo+2D2kgjTpX7H+hSDjhaleOJKOV/4q3qeLvZNF64GIY5OSu+im/Nz+ltJMIVIRF7yKZdHncgPJB/CSbCtRHNx5SnwgjCQkwHqclMQg9cD08SOPbowB2NyGjsRxz7Kj2ZVnbUrk/IIwdfAuW+6PoK5srgOLBa8I8iZnlsNsyXnGkBtQudlGODvKZ6mgU0B
 jtZwJ+MR
 yrTcZnvaQMn575ylpYcX3U7+cBi3jkhlpzCCLNHlrtlIi40q4Nqp8YzEpWE9PDAekz/P4F1UbcAP3QO+khgPOIzagcgnfvBd/pUZiBwd7dmz4Hd4ZQiRJATjWvHF6hjgooZ0aMkTyADvmxzsV+53eVEbtD1hy047Z0lvQgnXRrjIUQQiLkF7KzIGL36MWJc1NRNI26y4D6Ca3onfjHSb2NEN0Zdhc2xMhwgHGXSa45B2E1hPzPhaiwWourxCHeOaTRK0xted3tFqCVGMbPexPkSAQ5hmzpWbtyZhGGqOoSXWzrvL42OwDrwGR1XHfeEB2cnIAYleWItXoTD5879O4IZZEFq2bgm+BpXm/6LYaFno/a6MNaAyE8g/Dh6TcbLLh9QghCVPbCV4ZKHEn8Y3iG2dydRLDFnqSWYutoFJdKMldsiOJVUUQAt0PCjsFj+Ei24bI1SZdsnxZ8s9e24M8KEgBDleRLkJhLATDHUzqEcx5At1kmjVP5iL3+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Marcel Holtmann <marcel@holtmann.org>
To: Johan Hedberg <johan.hedberg@gmail.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/bluetooth/mgmt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index a7238fd3b03bb54f39af1afee74dc1acd931c324..06d2da67bbe14e17ee478aa939de26526c333d91 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4169,7 +4169,7 @@ static void set_default_phy_complete(struct hci_dev *hdev, void *data, int err)
 		mgmt_phy_configuration_changed(hdev, cmd->sk);
 	}
 
-	if (skb && !IS_ERR(skb))
+	if (!IS_ERR_OR_NULL(skb))
 		kfree_skb(skb);
 
 	mgmt_pending_free(cmd);
@@ -5730,7 +5730,7 @@ static void read_local_oob_data_complete(struct hci_dev *hdev, void *data,
 			  MGMT_STATUS_SUCCESS, &mgmt_rp, rp_size);
 
 remove:
-	if (skb && !IS_ERR(skb))
+	if (!IS_ERR_OR_NULL(skb))
 		kfree_skb(skb);
 
 	mgmt_pending_free(cmd);
@@ -8277,7 +8277,7 @@ static void read_local_oob_ext_data_complete(struct hci_dev *hdev, void *data,
 				 mgmt_rp, sizeof(*mgmt_rp) + eir_len,
 				 HCI_MGMT_OOB_DATA_EVENTS, cmd->sk);
 done:
-	if (skb && !IS_ERR(skb))
+	if (!IS_ERR_OR_NULL(skb))
 		kfree_skb(skb);
 
 	kfree(mgmt_rp);

-- 
2.43.0


