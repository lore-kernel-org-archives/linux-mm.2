Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7DBEB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969B96B00A6; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C19F6B00A5; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4CA6B00A5; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 306F26B00A6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0655EC0352
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.26.82E6E50
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf07.hostedemail.com (Postfix) with ESMTP id B306A4000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="f0/sH3vW";
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uooxw3fX5Xhzv20YqKtHhWsi9m/p0oZKhCK7hiSR9So=;
	b=k1xrqD5z+qhgzMA1RHD3IgWNJT8oeqGjTL8ZRqZ5Pa2MyHXBA7aTs2Kglo0lkHXVIlAFNV
	k95XdE51eLdXHfAbe/G2tXabwSGmu8dGTGxQ3UJpONxwaOB5Ws5YelBOq2HwYR4NCTDOdT
	KL5152anYtzhgW8pNJnaI8V56jMDLNA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="f0/sH3vW";
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=0Tk/M2gxbTGahx0pYXQb5aB5Cs1caBgwLR6k/xgvO/kmkL4BIP50ddofOtnhJSj7we/vob
	nsmO7STlS5ZLFShNMfrJhkgqxvegr7+GJMbidGdD4EXdDXIM9kQTlNhQ16ZU5d0pSn6ImW
	lxHJCrE+MKYJXAVQVXxtmRymvetsPTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=N8ytNu1U36GmBgTPXVAE5/A4s2PfdogY1tJY/l2pxcM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f0/sH3vWUtSFTcrY68KbpDRxIZCYT2hIiwDi3Dik93BJCASdZICq9tTWJ3wgjDVyu
	 Jxt6MZXNePDtV4TX0U7P53CBk1XHgvUArUuxPPUnS5hIbTeOVph/0B/h50wymqYtj1
	 3T7/WTJwdzfusP5uEpNMFoKuQUCnMWZUuDcbxKoU=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bfc8-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:38 +0100
Subject: [PATCH 12/61] quota: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
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
Cc: Jan Kara <jack@suse.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=763; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=N8ytNu1U36GmBgTPXVAE5/A4s2PfdogY1tJY/l2pxcM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX+MICb9QGDh9sr8xrXC0GI/+3a26bt3TCKL
 Vjl33LfQY+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF/gAKCRA0LQZT0ays
 26n6B/wNFZznKdxnE0qMd12a2eIuA9+krGiImi7olxEd9wOJhsBf8sKwI0E3QgvpW0h7L8AJ/V7
 YwWi88O6oeBiZ3QDKSUmLS/9VlykYZ97N4eOIEzkOMJxki98cx4PncgKAN9Jy63O/7GoZyteCZ7
 +9i83brafUHJWnhfe2dyfef6pp7LRzaCEfdld6TPIgAENhsi0/zr3Pv5hQfjJiyWTNInkfN/Wc9
 eBcVMsl2Zb6jE1xGE/aNpGFG8dNw74geAiaLniVxheZHeJfqzhWkArPaHQ0SYGtCtwd5smdDDAA
 6BFeqEcljgo2LkEM+gZQjogP088dQYDyFGUkwYA0hLFDBEaT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-435C7A3D-F151BDE4/0/0
X-purgate-type: clean
X-purgate-size: 765
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B306A4000A
X-Stat-Signature: yxgbu97zswskq9s4c9o8pwiojdg7xgn4
X-Rspam-User: 
X-HE-Tag: 1773143729-713271
X-HE-Meta: U2FsdGVkX1/DH01mG9OvfbGY+x4S5xD98kZ9Os64MILGe9uYU9OFC3Z+7jdNtxDeJJrasafFIoLiCpe65p9zq0oQbIn2eE+v4w9i2AVkwKy80qJpQZMUjsd9LXEDwC3jADNXiY7EuUqEHHWXWHNjyRZfFZhBpb3l8c1tjo1TZsEpZG75ZS/Denlvz2tRc0AzqO0xfU2rmi3RBteauk7O0Z0FSIX2EWHkCSNsmsqRlvo4W8JhDmHOR6K6its0Z/qUZGio9cKP9kPGzKF4pnZ7IV+UIAs7SqkR3Tphnn0u/JNgwO/UBy0rJRvX/beQmwh8raHxUeOC8CO6lGlakEkQhF60ZfCXoOIwBWILt9WV856NhZLoLMswQpxg5Uh/wjtsz70VsJzawcDGIwxPgCAv3q4bAv8bGc1IoF8kB45XcI29BX+KCSx8tz5GiuGB8jtSUuBUBh96pRLYHsMh/lpQhDkXmNhDM2a08JcHAsqVy3HeNdbr8jdGtGJaQJ0WEofzmLYoLFbsGt2E29lP6gyTsWLsGs6EYZZTLz1SLmIA4vm/3SH+gkXfOGcJqaj/UaqLF1LkWf+O7kVznn0IwaTJ6z/pgVpjNMnn09HsC0jGq+f6lP+lkNo4THikI+zKHOVXCPv42fPrytOx4v71tM4bMk7nj/jDv+HTsF5qM+QfN58ypeUHBJbVmK+77XMXv6+Hjh3uUk7NxX9tSvF+F1ZIVc5nPIl0/R16c0YjSkhCNmhwE+jOUnqzflfQbKf4QQ+I1RN56aSM4b6gFPhKUrTc9iFmwO08Oz7kUDgauyoQsJCanvgaXxfx9quj3R3CKGy1QocNZpMSQnXYLuRv1+ecuvHJfxn4RGxP2uw7Jvhw+8Gh5OI1N23diSjruFpBM0YxcDETccJvfhDi7b4DAaJpS2kkwfDrdFgmgQkkIAlBCaqwhEHlnKjb5GcSvVX/uIDory3RqeyguNE7bkmLPT9
 GVOxD2d/
 uh5Wl/oLI+sn3nRB5zcC/X4jqrgYagN7s9kQlaV0OPFqJgcpOiGIuwuywD2OHI0tvzbiwvsKTfn9Q8MLz+Rg83bVn7sGqBq4W1tM4yw2nRz42xW7ta3Jwd67R3xC6YVf2TnKMiO7YuMauTBKRAHIoAPRWFlI7sSCFjH5sUqpQM7sfaPUwWUOwgbWHE+Mah5v9mE3bWDyBDNaDVj7IeNgbTFEmnNqOBJ/xJnfXKsF8GUY7/ezdyWlTmptoUZZx+NKJhBbgFCJykFYguIkqTigwutpRJJP8vee1k0KfprzLU/50+M3ryfYsSAQkM6c2LsBOAbxbEurQDDMs1lvGtneE9TpLcN6yedETvD0geAAGh9sisG6RD9CjHtLT1kmp29g48hT0eLeSAiiBHuukcAGncbts+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Jan Kara <jack@suse.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/quota/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 33bacd70758007129e0375bab44d7431195ec441..2e09fc247d0cf45b9e83a4f8a0be7ea694c8c2a1 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -965,7 +965,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 	else
 		drop_super_exclusive(sb);
 out:
-	if (pathp && !IS_ERR(pathp))
+	if (!IS_ERR_OR_NULL(pathp))
 		path_put(pathp);
 	return ret;
 }

-- 
2.43.0


