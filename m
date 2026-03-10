Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D38BEB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9046B009F; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B046B00A3; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451A46B00A1; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3315E6B009F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA49E1B5132
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
X-FDA: 84529998420.15.8F9776E
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2E4912000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vGHDpooj;
	spf=pass (imf29.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGmSA97P5zoUAPVKt40UlhgFAMOY9j0jHxmE1RUkWWE=;
	b=JZuBdDopPXLimzJdQNYw6+/Dma9E20MwEy5JFo2X8wqgoXHetTydxIurMHANzjUFXJZpRQ
	ZfgH4u+6M9wl6rWq3outmBfdpxBqmBBdm60iWainmfHacnmYdpIshoxl8dMALSaBb2Wib6
	GfGsEIizKBlZgQj1EsN70euCSnAPbBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143729; a=rsa-sha256;
	cv=none;
	b=h+bIgdPCb3QbwoTFP7xmHnsxHNRPhYS0gSUI5q29/XXjUO5aVIWTglbDN/zSMTQM8WBjT3
	Y6HK6KvFFk46ofJU/dqNRtsJlhrGs9cM41fpl28LB73mSNzWlZPvyh5OZvAiV/64vmELs8
	hiXEaRX9nVD2YGXL/S+Uf3/0p/hgJro=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vGHDpooj;
	spf=pass (imf29.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=vGrPLNOiClPR9kf2JYtGEgONwIn4sxqTHiWcc1kKKyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vGHDpooj3kbLZ+8D0plCbMeYqQhZctChcZoWM2Oz3ppzOc10y+IZamI2t1Up6x5Oz
	 ZOQWpS5VxsHODQ5E0bYLhrVtG85jFVZABrb+vIZU9NfiYqywilzOFMSb7wFF9KlZxk
	 XMjhpb+uZFDFGYC7810AK5hKKVXc3NZ47/tNCbvg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019cec-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:31 +0100
Subject: [PATCH 05/61] smb: Prefer IS_ERR_OR_NULL over manual NULl check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-5-bd63b656022d@avm.de>
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
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2182; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=vGrPLNOiClPR9kf2JYtGEgONwIn4sxqTHiWcc1kKKyY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXmFi2noeXj0abdUjIB9kKoSnFcuerTTnqGw
 aIV0JkIMuiJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF5gAKCRA0LQZT0ays
 25ZYCACJTZVo2gUPO+X2etWPNlTUp7ClEwWSNg3dPZBa5w0Z7EuwahYUGGyy8BKX2Xr3Nw3eStQ
 sVKw7MXxWmXWt5UTxCuTdRP3F8qkFihhAcyZGnaWXtsHW80RrqCOvZyrn/d1kQqYEpMpKbZIZxv
 /EpbwmWT4XeRvGuaEWqQ2bbe/QDrikm2suvUw6m77AVK8ag0Unhi8yF7km5ZQPmNxRG0b7wRfDu
 f9v8qAqM0yTILYLsa5pGAGuQ+9RoWhRyw/Vp6w7DPGkGl5Ft2gyZ5dwPzpx69OognVNti4fm1g6
 tztjOPF3hTnYGvxjbl6RQZRancjyqct71KnXaO98GUCNnx9j
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-8ECA1E1F-59018045/0/0
X-purgate-type: clean
X-purgate-size: 2184
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: q6hskfykziumz5f888ua7go8yew9skkk
X-Rspam-User: 
X-Rspamd-Queue-Id: B2E4912000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143728-244369
X-HE-Meta: U2FsdGVkX1+0t+dw/UfIZMcge8R12Vo77WNU7dxeiuV/Fei1eMDmqjxsLQiR0DJ6J5ifGc0By8T69p0xtbcChvrVFdxMPz7Rzb2s7ai55heK1HmHVxiDXIohFiBzkLyplKxL61FvT8yDhyDctH/aL0JTU9/Nnx5ipe1cKUeVSTCJG03ZTGo+Z2SSQPgmDnls1gWwEqYOKvPn2m6n5FWU9z6xDUrM/fYJ7wyewjvqi106TEZWSmPr6G6hsRc4H46bx1p4s8Z47xo9BMIXyzl/pyEbZ8ytoBgNPMXM3PuVoh73qG0uokbXYqQ0j+rltQVfez+aaK2vB91iUdhJwfUTrGaPkwUSScTlLXiSL+6IGcUeIpwnqg5+QGiEt/KJ334gS/OWP2zPq6ol5H0aqk70btfDKMHH2spucuAOtfIP1fiBmBx3BbJchNm3QelOeTG2e1klzj9ar4GcEzKCyRwftb0zjxIw15fQ5a0URQxEcm20tvcaesV9yllAtFdLjjnSyGBdoEwl6gX/lqsqXaPHVPQr7GG2yg3Czuib8qG0D5P8Rp/1C6NrWJqrYGnJL6YO9x9LyfJzcvD7mpSgcid7YODd9JXl6ny5hcilgoi8vXUZzIUFbTWx4tCxbYnERb/WN93XG0yxB7VWuBbfW+Xj4jGBWHqz84BbOX6WuzTkZv7HaQKIkG3jBLWnuhktxUTZxzY/IWpiYR97wXOooVhXRWQzezDd1g+/1OObZfs3IGI2wCDjiRpAraCiA+lFqZMojKtnXR7GCCm3gxIstOQdEPrF5UW2HGURORroVESQwei/UcvKB+tyzCVHv1UzPhwRUjPerOjhdXJctJ39PsAQrxN/2Tmqv7KLYdlQI8YvWf8kkp/mMoghs9UjnAfI2Vy9HVztdgdlMrggksUiG+7L1+MBLp970eQyW7QklNJTtRACLsSvSOxlWTrgpeSfeyQf3j+XrwyKpupukHanuKQ
 8lMuSYsS
 ARHCEwq7FIWRuyOPo7VFWp36RNFPqsNprLJiYXVdG0NaWozUrW5B1olYRHhQ8MdSzOhJElj0405C9QQb1LQsdO2SgyEF2xDInLkNqhgAmpmsLLA6iaIpRnzULhCw1vsTH5ig3uN1AQA25S4KuH2dOKrif8BSOu4M0qdHGOld8YPYtS64yWI5xejrwM5mCvZOBa/LqmEBuxFmkbxf2vX+1gWtjcIMbJDIePH0W6Fa/DirDgVRKD27GKv3Szrsl8EeVd2YlT9MDvdw9Wvxv9Rb3RJZBBY7Y/GaqLJYv49LdK26dLkSypYa3h1rabmKSqBlJJmwWzuAqzy/E2sciLb2sL/Tr/KUOPH1vAJs017EmdbaRqia5odMH8HRB2dSGMe89lVmges0R8QjeCCrOhS9nx5PFSlorvDdQNMS//46O8lQjhvRJgSkbUKA3QfH1rk4woDT5XuGsGK2BSEH3JDGu011C6HsQMlEWCSH5/dFffhyR52E1f7li0bUVnfP7Voo/lbBd1EZwnoSAw/q+RckhkrIEGmBkdqM0fmzLkix8Y8slD6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Steve French <sfrench@samba.org>
To: Paulo Alcantara <pc@manguebit.org>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: Shyam Prasad N <sprasad@microsoft.com>
To: Tom Talpey <tom@talpey.com>
To: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/smb/client/cifsglob.h | 2 +-
 fs/smb/client/connect.c  | 2 +-
 fs/smb/client/readdir.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6f9b6c72962b09260542b711d4c64e7dc42c7845..fb731b2609465ebe50742936b458aba210ecbd4a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1336,7 +1336,7 @@ void cifs_put_tlink(struct tcon_link *tlink);
 static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
-	if (tlink && !IS_ERR(tlink))
+	if (!IS_ERR_OR_NULL(tlink))
 		atomic_inc(&tlink->tl_count);
 	return tlink;
 }
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3bad2c5c523dbd1d4b1ab253567984612be0f348..aa12d327894b270b59ea30be0e6d77b4188fc98f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2895,7 +2895,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 void
 cifs_put_tlink(struct tcon_link *tlink)
 {
-	if (!tlink || IS_ERR(tlink))
+	if (IS_ERR_OR_NULL(tlink))
 		return;
 
 	if (!atomic_dec_and_test(&tlink->tl_count) ||
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index be22bbc4a65a03ec64b87d8505d1496279f22efc..3e9260cca196ea8ab17aad82c4824ec5e468e2e7 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -165,7 +165,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			inode = ERR_PTR(-ENOMEM);
 		alias = d_splice_alias(inode, dentry);
 		d_lookup_done(dentry);
-		if (alias && !IS_ERR(alias))
+		if (!IS_ERR_OR_NULL(alias))
 			dput(alias);
 	}
 	dput(dentry);

-- 
2.43.0


