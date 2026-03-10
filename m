Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65773EB1055
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587846B00CA; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED986B00CB; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E356B00B9; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8DC6B00C2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22957137501
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.23.B0E24A6
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf17.hostedemail.com (Postfix) with ESMTP id 82D494000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="g+N0/sgS";
	spf=pass (imf17.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3ysDg7oU3Ik8LJ7AkFJ4IpI0srzE03Ecj3qWGQ34tM=;
	b=xlySwbZs62A+xXyQ5bi4bEVRfXWccmCvcDxF3Q+luTCD8ckfSG3egfYkZoQFNX8PI2TrNi
	CxRgKK4tN5BDnhYfy+FWgSIPd8PZjFjZit/3MwJMGres6GtSGsfj/oNq5FbMAbflDP5E3B
	lejnMHtQetuZ5EFVpnpcTUSStWHorno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=HT9sHvPMRKCrxhyJ5HPazzCiHGATAUrrEr3S734Ti412bDJagLT6vizf3bGHlAd5J1+JgL
	ABx9GsgbSHb6vO4kOJGmI3NOGdfEVbuU9HU6sSo/UL9UOZ3FVhRXXaw1AkNQOvkkOu2O3d
	1J+HZL7O3/WHVBpkHbMDYk+ZXwg/GDg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="g+N0/sgS";
	spf=pass (imf17.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=iG/6Gbypjz2OmWQb0dXEIiFm2wHO3xZ/QJrRffJjoq0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g+N0/sgSQ8SRQky5YcCPVvBqWjz0hDf6/mz5MXtIt5pp3nndKwnydeDBFFaGciw76
	 fK8hCsX2XQfm37mz50EiEfGo9ClFJDaFX6LRzTWB5+xeibMvG/0El8aLjh4dU3qpIV
	 pdtzYGFmANh8kH/hW7lr12MBHwTlKf1PiSqCWud4=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c052-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:53 +0100
Subject: [PATCH 27/61] net/netlink: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-27-bd63b656022d@avm.de>
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
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=iG/6Gbypjz2OmWQb0dXEIiFm2wHO3xZ/QJrRffJjoq0=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYxKX27oPhhgjZ9L2aN+uf2Pkd/lJuV0FZGx
 7sT5NeXxfGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGMQAKCRA0LQZT0ays
 2910CACA5AX3Aqq6mMRjUqWLJkwISGQ/SClIom7gyl5y4YdXmFh365btAW6CDMrujm4g2yYHKMn
 icMIaMalhr2gJPGai/SU/Cr5CZi3ZY+4gua5T+uq+HkP8vLsixdy6MzBKvC4YJ7SQ9u1y3suTJ2
 dXw3LfFbSDyXJK4eAmt3Q9xLN+IDoqMq7+VyONJtkwZmjMDy5iHAJpd4FamMBrqSwy4GaDMKKm7
 glgw85FRb142AMKifN1ghWcWZj4AIrKdQR8M3/bZ64Q5ElxSWaeaZ0coUuPBsdwn1welLaCtuOr
 MNnjMGoWnx945CHnVYBBpgGh+sR8NWsokX9o62B2ZLaEYpxG
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-DEDD0A3D-09A71CC5/0/0
X-purgate-type: clean
X-purgate-size: 1047
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: 5wp74hxi3i14r11f9oy1npjxchkzjxjp
X-Rspam-User: 
X-Rspamd-Queue-Id: 82D494000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143732-370353
X-HE-Meta: U2FsdGVkX1+6tZn+rVDDXQLqdoP5mpmOPFHRAoiaoLpkjwunGeyOtrvbAk86qyRu29WnsbxOh3DjJmv7YRqKredYTGMSUKkzsUPLwtl6YMdL6RHiGClPw8aUlS7AXNc/RTdhbwH37l90N4W7nSzyth0qCRH6nedoXxdbuXvtIG7L0ga3Bp0QenPX1Tq5hjsBTEufVV+GM91b0AsEvG53YzobtK9gm/kminY7tUDOPyWU45FjO7iM7oqSiqxGXNbUGnfG2zC7qmgqz/ntKYu7+wM2/kUBouPrQ4/XF9btBc94ETbxU/lIHH2urjhBGp1yOwKl5Xvkk105bcae/CVbe1wT+BBGXhaUgQcuF7w6ZQvMm3O3p2SpJ5/6Ued8AZsy4Cd3FOPkrY2T/77Mbso8mDKTQc05qoJgOnSrCoiJvzj+C5AlF5QUY/y8kAVo1Z+h0SIt2WJTEpm08t5T8BjWoGjffSYiUUOGCtixgZMM7CB/BO8ddpkIYHiM6tv4Rc/vnfLhQgpo/3sljsGgWdDVmNZOxhm4dR+NuMWzq0J+iMmFRCVn01tV7+Pl3yQPvsICH0ragMR1h6fLEYmlSCp4aW1Gu5VnvqKFxa1z8I7zEA5XWWJQVCmT5PSYUg+O+bwQ7FVxgTZobMCP6A4dey8c3eYgS2ihoDZ6boLc2RJ/rYM/mZFaLMsuv/dbquXfvKxCijlqvZr0Th1IA6O+q6w2QZvTphll1ge2oLPO89zMnwYETd+gLpHkMu3pR6J8hrUnwx6zih4rBxj7EtRLVnNFztuzLPfpccsAXGtSlDMxOExrhZkAAdZKq6ewEMGSmfGcKysgMh/c9k0SLzwBLFKsMLqHu+YfVtG3zcOcT2f0wdh6KwEOIqR35/Htv5bAOH7ABbYSnHTA7jgm3U8vDQmPltxcypVDHvvi2mVuPIQwsD2ohYUggecsFI0sDjhd3UcrBB/+AHbRJFFFNvtJJjw
 pHdeyY8c
 XAdSTUhqVvX+pDRe4w0IPZerMqJiKJVFUNNNv58fatdPRXR8nyGL/dDYiLfHAMnxHxQ97MERn2d5kMsSNgDzYLAZjlETkUXuPEKfkNCFlT1qFi3GSONY/7BIxWCmZ2ZTS5EOVTt2vO8QjALYiBujEEBb3hJtpCRAylJa6cm3kMNElQ6CU1Tl6HY9rNPdft+BghggDJ/HQFc4AAqZqaCQMXVks0taFDrdrZI+sKdsEVUORlCJSXNHkwF+3h8RGATicqiRhn+eTMwE6EQO3ZyBMvqFh4dGQNUfJld8tbPWsAQOxvJw1SO1CpdcGRcGt7Fd9soWwXDAPFkX7biPFP5XI/y2T2crERCvnqSBIRbrBD0AYLJT+klpPIMoBEk7zOCfWfAO/Rz2GJytCr/OHNEcVRD+DR8INCxYONAxoYNktPT4yPR5S8KChye0OevnK1Cz6j/wjPn3z0lh4EsG/mdTC7FD77W5rl/EtaEuGJvH/o9WR2Fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4d609d5cf40653e04de60f2d28ee26b8bdcdc2ed..58707b9da84adf1002ab9eff9401fa2083374189 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2667,7 +2667,7 @@ static void *netlink_seq_start(struct seq_file *seq, loff_t *posp)
 
 	netlink_walk_start(iter);
 
-	for (pos = *posp; pos && obj && !IS_ERR(obj); pos--)
+	for (pos = *posp; pos && !IS_ERR_OR_NULL(obj); pos--)
 		obj = __netlink_seq_next(seq);
 
 	return obj;

-- 
2.43.0


