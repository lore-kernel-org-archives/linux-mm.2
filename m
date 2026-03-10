Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F07EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810CD6B00B8; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C82E6B00C1; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA926B00BB; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7926B00BC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1FC2C02F0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.19.780AF19
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41A29160005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=SxQcNNRu;
	spf=pass (imf08.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyslncaAeWGH+IAMQDnkZZVU64Qtu2fjmV6mpXTLLt4=;
	b=Dn5Eoz3iDLtcPidiDL9QeY5qI3FdQP6GZ4uzSPqHTYEv3Htk8lGmmhDuDEmr0rcp5anRVo
	qw8ODNteuMZNtgOWqMvmB4y+3xY6rfcwsAYuFt8D780K4EyOvOhWIa8p/RVIvO2i3FLW5y
	5YO3k7LrST+Eycrh4z5Yt2/ihBvjUQg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=SxQcNNRu;
	spf=pass (imf08.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=5TK6y6T1QlzYLysVpH43OnW4O4pIhDuwlbQknyMJhgX4tJhgBVt8fEMXBbsZ9UDus3cH6O
	n9hql/K90FV8ws1RX2TqS3sINXtf12KwH0BEF+ubHXToInLaBNZa6yOKc/RpmNdJhU0muJ
	XlETulbknGFOob+89uAzJc4eqyHq99U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=zh0NA9cMXwD2DkPFVL0EOnYz45KEbaJC9E9Miol506A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SxQcNNRuEiFwL/5k7L3uNmiPeI5MF2imk5edf5+bENjDS759Fz4qD+/GE8T78XGoj
	 y3Anx7ULmIKK+LqK0b0jH70rnI3ftcXHXYxeZ0UjeUBfUOOob6Uk/Ag51Y5ZWXmM5b
	 3t6vwVKkMaMk0t3qb5EymyzCnKyZ6WtwRBwC159Q=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-2367-7f0000032729-7f000001c9bc-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:12 +0100
Subject: [PATCH 46/61] vfio: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
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
Cc: Alex Williamson <alex@shazbot.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=940; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=zh0NA9cMXwD2DkPFVL0EOnYz45KEbaJC9E9Miol506A=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZyWhsmplRS68Hjc75s841x9LkbYtnoYEUHf
 5sKSdvRLCOJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGcgAKCRA0LQZT0ays
 26J5B/950clmJMa20JiDvd2Y9XUU4IMRZvZhOhN1i+pY6SIYFFSSWrstAJqpIpGOZ3R9V9O+AHS
 +c7Qni9AFhXI7buBYvtSAJWLJA8EJ41+9M8UOXpQoB5DcXO1c0CGt0ajsPjByLrSehp36R5PzH2
 wWu5vJHC6K9Bj9PLCfIhxzyGkz/hL0gcZbuCGZMCsvjzhhK3aqUIEmC2PQzNoj/okoSky7H2ok5
 Weutgt7pTJ9Q0oTr+n0PVtebcJ9O9+q3o9Yrs2sONA2GIXHGzM3vgOrYqV1Xoa6t/eWQHNiKxUs
 zghoWpQpcWwkFeKxopN3kqosmr1/sM4hUF11IDDx0e4ZVVPT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-BACB9E1F-6BD158D9/0/0
X-purgate-type: clean
X-purgate-size: 942
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: f3cb4h4bzyoisenyfojng55mquoho8o3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 41A29160005
X-HE-Tag: 1773143732-366053
X-HE-Meta: U2FsdGVkX1/6q6H/vmaMrz3FeesB8fdP0M3ukf1XUEB+OmlxlHDWfsdwJeZZci/oRpghrUSiOBhmVrhqaEK7qLISpAD/PMjISFELqWiWqzq11nphzVM5+N83p1keDUtODSE8eVyzL1QHDI6+dLWNqtIjXmtuqanodC6vU8/ASlQLY11wzS2mlmjvQNw+qjJLiPjINhgkx+nGryqrhZP4PT6PqpbwDnpNhTZSGPwmJFPyVywkb/eqmFQXZD91h3F7GrkbonD0ZuiZ1syziOs0rGCHJDiKWA/Nj/yTSLySAAonfiXd9cjQVlE8J28soQ2NMKZGp7N0di/zfGDPyMrPJ7c+UiEy8Q05v9yqzBWiy/5kc9j6LT32TMs/hYxFltW03Ofpvp+bvrHpZ8Gf1c7zu8g4LrOENmrz+gRqiTBx04HAGh5ohJ4OXMnRw0n1W+1txLvklCCs/LQs9fwzgaFK70fbF3lnEqRIJTbKrbfWen5280aDN/Snp+RoWhY5AeILGvNk6K78b8vz8F5oNZzEUDFyyYh4swBlJKRpFEg4ww7fw41zMattZ2xQjzlKPS0X2z7D8Eux/pj7T/7tM7Dij2Z5ZwvwVmmQIJF2JNZ1O67/cWojqJEvtHP/l03yPyUromqzzwSkSS49d3tZOjDJ5TchuKZNvESB3gzH1hOGNuUnNePUvjabV+QC+n1199ZSfTc2Ir6U9aCg9qDvquPH/h6avY0Wtk79IJKvtUqLhrTf1WdCgAebMs8LnhfYxbYTN0J6LYum935Qf8yf0U6430KT7YWanLqliY4ljgmnozGpI/oF4MljJvraaKgwv63MEB3m0mZpMog/nbKZXdw/MH++49A1fYuzIbCZZCBRPBnxg2W2A3BmqR++dM1bu2grYaQ3sRq9/QIc5LBOpgawoXEh4JugjZWygr0bKaQ3w9jzHug+Xmg5ivL5tIXs7imYNzFchUGtXz1H7Hzpxcz
 8CzbhUPL
 cK+5ybafDnBE+sMaLarqNi7kj3t86GexmYyGw2kpxr+aZx8tq2Gv1ld57Wt0Xhazl3TxTsRM5tcdBzPqcctCUOVY4A7jK4ywt1/9c0EmnUwMYeNrRyxQC1oXki2GwfbXbQIdL/+qg6qyraSOy+Yb55rs16LEThuwnLyJznzUeqmgNrqV0ZCQaGk06j3ESEtgUQaD/Dgin1t/TqkSf0cNdBcg2Ncw9j0Ko8GnsadYxcdEhi6K+xMJikxTj4H6c0yJ0f5amOZoAILSkUv51j+mv6P+v3VPfODlneaFtkX4gTqBlTPzXFIKasl7MoBCcNO2gno7T/H8E8+HBVi9KqjYOeCUU9Yc0sAxe6Fd9L66z0ew9XhDqfBLXuItl+bnWW8xU1hKIzfBOpR3wURnuvQdUVV8Kkjy/yq5/JeFFT9Sz3ps73p02PUXrzjyZHlq3NEvP6u5p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Alex Williamson <alex@shazbot.org>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/vfio/vfio_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 742477546b15d4dbaf9ebcfb2e67627db71521e0..d71922dfde5885967398deddec3e9e04b05adfec 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -923,7 +923,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 
 	/* Handle the VFIO_DEVICE_FEATURE_SET */
 	filp = device->mig_ops->migration_set_state(device, mig.device_state);
-	if (IS_ERR(filp) || !filp)
+	if (IS_ERR_OR_NULL(filp))
 		goto out_copy;
 
 	return vfio_ioct_mig_return_fd(filp, arg, &mig);

-- 
2.43.0


