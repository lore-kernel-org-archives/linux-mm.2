Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32E9EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B536B008C; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B5A6B0093; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52486B008C; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA7D06B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 807C5160148
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84529998336.04.75A2217
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3889D18000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wXP6inC1ot/jec8Yz2mJDj/4GFF4TcysvA1pHXvsm5c=;
	b=4Zfazb+GXtT8mSlEFZLhoItFJhr4vRiz/kKubE0qMUFCIjsSyggO9Sf49VY7fHH6vz/209
	6tfeDDTBdFiFo4zRsMnV+f++C5jDRCOesh7Tcs9kcqlUJ68cGWCPLqQASZ0OKBdLlxbkm3
	BY2fnHcnidLUrW9ovcZdyYdIVBjr3tE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143726; a=rsa-sha256;
	cv=none;
	b=XJe6uuqqbYkrVGgPRf8tQzDK0BkV2LaD1MjtVtqEFV1bhZOlrnFCZXiAUQpyV8ZAW/IEh6
	TBOiqlBBQOriQ+/Pp0R+wIyZviuDRGr1lV29lJ/Oq7ZRwt0jGviAUiGfhFW/uwY7W6DON2
	wbnft6P0eA9FK0ysDy6A+kebyXEqKaI=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-e21d-7f0000032729-7f000001d976-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:29 +0100
Subject: [PATCH 03/61] ceph: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-3-bd63b656022d@avm.de>
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
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1465; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=FEizU4OZfQ9wQ3wvLqHfhAD95k5qump7I9MIi0BZQKk=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXdroDlhymGqsGkbn1SZv53cw4YuzOIIwtui
 bzXW6sBBQWJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF3QAKCRA0LQZT0ays
 2/1wB/sGTAYBPIahrXD3EXFQ9FcpHqqnw1r9sZLiba/u035gmw5LoaZhwTxHDBskl2iaWkVnIXz
 Iy7Anuu/HF1GBhMkP4ZE553CQedkoQLkwUxzFneqcFtg8dEj/bcSSJoqNhuTbcFTeYPFZ2FuuJR
 mi6wxSHOtk1jHNn9K4y3/ujXKX8zNKkMQCDkESe1H1kZKzWifi4aoEVftzahJtLslDJIa2qDL4i
 OSDOnojL7uRKrSwdvp+XJGBIrrn9XWylS2+dg5zaohBqwfc9ulGK+fMI3nM/n2Gqrv2OPrXEBM6
 17i7pbPmqS6afMN4bPYcsNPNwynB+aJ8jBm/4wPpjycn86fZ
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-7B60AF2F-D466ABAE/0/0
X-purgate-type: clean
X-purgate-size: 1467
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 3889D18000D
X-Stat-Signature: t1thfj5tt6gomo1zau8yc9ymn3jkn7z8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143725-92134
X-HE-Meta: U2FsdGVkX1/mKo55AwphTAAyjlgNN0OC6LnkqasqHwMfZKnXPfofr0PRzgy50FZ5qA9hH/qFAm35P7AXK/AiLRURONxfMNpLKjJWUguTFkr0DW2EnCIR9DKJUMSfCf5YWnYd1m5r28GO6gizSmRvt0O4HUjjKFZXcZw8Q0SQDdhAYWgLUU7vU7ohJGnFWu2RsEYS4HY4D4FSCkg8OG2gGDCsiS27+YV49QAnZGBWpQK6QbAg/xNJFKSntKfc8OSY0lg3HlAFXcCTtR9QbMMwPJVROT4Gun2Zra/7JeRfDiLLLeSQubyGYjg0TLfZbhYZlzdeUDodUQ5yC62DKyiG1JFY7YhLhM4PmBaE/TkEvTpX0JojQJXznaTnj10R+TDiHK0He/mjlgDxWQgilMPx3DjBj9Zvt4zt1n44VddX8tffIP5UhDFx/AN/pFKSKNvKSAASBdrPNd90urLnps2saUZuXN0aOOd4hhP8t/jKFOhfdDfHyag8T9yh6IxoLNXQIjsCy7g2WxmBVkhiI/iidJiBcGS768O1l+1h3W4C5GWIOxA2Js22/6LXxw6RBX6fVkJG5uQi8bpVkIDf8cQxoVLcrx2pq6+3i/rOZ1p0qPomvg+AsxsFheORA2U9nS6Tn4eeUyyI5ns0D4PaclZBAgUwQ+b20Y5hfsY+knxCOgoSe+dQGXqYpvW4t+o6zzfbgV8jMqpHHk1yhN9B6RTBdfe/VLE2XOiLrWYEMNQzTjJgl3tWLTRey1tYwz3vNlg9WC6HpLEvAVitfOh/HB0Z1AmhRMkzLwFjP37vk/7j8cUgMHjv2B7Ap0QU9Lme6ZSSg6H5B3X19/wccCXK6X5QnNXGLvEPO2Y6T/SdPJdeGfCxZ0JcPg1F7a8OxIWbBpyNp/8thepTyyHnSWtjyLxVfBBagpIw8ugNBflqxCoEKQy1qTQo+p/UsZmBGobUXth5YjX5WGwMEUNyzVihjtK
 MebDsoZ4
 RNTeNZpwJe5iGL3IEghXmphO6lTeWz69M+hY1E7NMdsX4TnLSzlgZM0tU5xyP2ElA2iV5lQ1EE9Y+sqzgj/UmTcbOHGj1HH9xZJrv0ZC7qnQ2T9qBhzzp13MGWeVBECFxKoKqnooA/sTPNMDx0upy9onH7FAhivI6O9actG3k5SzvpTT0TVr1TI5d0sgXxEIBKLsAP3qYKPqgQoI4LXdVZ0moTgjEFdfnK/liR3unmHlJrQBKTtR0M08JunKvKw16q41Jx54I3c5c7B9XnmBwq6ZdKFe+vwPapICeIblazFbXvxBlTNMWOdBNIZQrw6oJF/UyhQ0l3SP+Ixc2Ws5cpH4KOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Ilya Dryomov <idryomov@gmail.com>
To: Alex Markuze <amarkuze@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/ceph/dir.c  | 2 +-
 fs/ceph/snap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 86d7aa594ea99335af3e91a95c0a418fdc1b8a8a..934250748ae4fd4c148fd27bdf91175047c2877d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -889,7 +889,7 @@ int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *result = ceph_lookup(dir, dentry, 0);
 
-	if (result && !IS_ERR(result)) {
+	if (!IS_ERR_OR_NULL(result)) {
 		/*
 		 * We created the item, then did a lookup, and found
 		 * it was already linked to another inode we already
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 52b4c2684f922bfed39550311e793bfe3622cd26..528ad581be160713f91416115659e2dc6f259576 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -902,7 +902,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 bad:
 	err = -EIO;
 fail:
-	if (realm && !IS_ERR(realm))
+	if (!IS_ERR_OR_NULL(realm))
 		ceph_put_snap_realm(mdsc, realm);
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);

-- 
2.43.0


