Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF49EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7817E6B00A9; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681CE6B00A4; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8AB6B00A9; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC426B00A5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E98FE14015B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84529998462.08.BC205E9
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf24.hostedemail.com (Postfix) with ESMTP id AC0A2180005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="HvCb/8oi";
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVRlrvP2vbgXglr+z2zhizXrLgYYAnk6ZwkJlTNfyBA=;
	b=oRDkFv7c8AbWWz9zChDgp7tVfHlbkK5X1UXTIMXCTMyIVOTOoP2UnNilg1ekGUP/ME0kyk
	6X9rDckPSLG/klXA0HExDdiW7Rb6sUhGSuHpU8rGI7vbRJ5zNB97xt/1zRyowtqT6VfVdb
	CB3OumkGG8TLVvHOyNPjzRgfFxl6OnI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="HvCb/8oi";
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=wQTEOCABcvGuyy4kKk+sviETm6lGOE9i3i7+8tNrc5ukYZ7UZQklgJbnniy/S4Dbar+O0V
	BVOHiSh1AMv++e1UrKwi/PV6EQB812FexMvPQOv3Pgan1kEP0Vm2g0zPFJnC1xMYBrlFhA
	M56kdbVJ+mtcFjByX+CmsnULYWjHc0Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=Z5CcgUmxb8TIHuxVENT8+Rdbeolb2IW3uV9KbiLoZl0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HvCb/8oi+QjPTMN2Yg58hVQgISqDho2KSemsYUZ+vy5VD2bnZIm5jRkx5UuokMrry
	 Cd/bADEMvLj4WpFiDDooSYtHMuljYAEx/RujmrWNzucIvLCjqd0TnsL6u3xLqdwjKn
	 SoUF7kcbAi1lGgdxzJJB8ERoQMMzj0TR7iF4FK9M=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bfb4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:34 +0100
Subject: [PATCH 08/61] fuse: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-8-bd63b656022d@avm.de>
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
Cc: Miklos Szeredi <miklos@szeredi.hu>
X-Developer-Signature: v=1; a=openpgp-sha256; l=890; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Z5CcgUmxb8TIHuxVENT8+Rdbeolb2IW3uV9KbiLoZl0=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXxKvlvqCH0DwJSbq+UNs0LTyfOD3vzlRqtT
 2TRtqiRMXSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF8QAKCRA0LQZT0ays
 2xgMCACJUN2JSxzamJUFQvwc92wfvAAIT82LlFBC4CNAPLjUwClhfMFmMBmKAZA8HDz81VrcG/p
 fo2P5eS+rFs83E9iVI/bW+OpSphb7hd9/Pa3DNpSkaQcLQUMHw39s5ltgUYmcwhQdUpEa+pWYW+
 gg+34EAVtKnYkmIuH1aWQKSSPRHXFEEIj8Mu1YI3EnTGvDB+NleQt1zN6UaIksTNUf5+3I2W33b
 Z+hxOEmA2AEpaox3bemtlkSQbWv4qtVtcFYcWHKzhKpkUH0i5WAZ0lUSrDgtHsTI7KM+223fQQ9
 V7CmYp8rYAFlP8Yb8uQbtjIbd9Kw5z3oAZRh0mglz23o1NU6
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-035C7A3D-B44CD0B6/0/0
X-purgate-type: clean
X-purgate-size: 892
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: AC0A2180005
X-Stat-Signature: 6pd1xynfu6x3z73oj4r58h8yaespa8wd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143729-350220
X-HE-Meta: U2FsdGVkX1925i30nShGmw4QolRZwlwwQ7miYrspX8zg3iULzTAdf6uIjuj3OLZCLKvOFyTMTDOCV9vOC+kaO36p2+1NMODK+3O2A+ykzLNieiVYCw25Y4wrYVOZYDcKy0s/Fg1OUr1aqtzng1OIyHDw3Tb4AfzAygQ8O02MJ0S+BghdEPa9Ji1w8fbM6bJs3vyNbHMlbJkcHXqkO3OIjklcNPln/z4c0CaFKE/nOchq1I+6sb0Z4LaNR3GT2xovpoG6ZsCvVMJ2CmrvSsDwPCAD4d255iRmRFhUj2UpmuIxxrZ+tscrP6vFAQ9uRMkZcViTEGKgDLt+w6vCEj/BNS0W8wiaoMRko0JqQYL0YDALS3uhhKaevMKmVN1YezLPXWgmQdylwhM3CV41u4zykfSt69FCjyt0Le0H2RQ5vzIpc7orLQhtprQhzD3FyCc4QU7dQnNu3plbaGlVt/nVqdgwluOCfD+tvWiqzPIPFaxjh3NSqlBXfJ0b1IcAnaiJaU8c6DDtQBvqCTK6l+OpDB4kAV9w0Z7W4JIRvyL6VgcO91RtUSAjS8Dx5HginoVDEmQ+Ydn9Q8zaHFWDEhFbscPyKY2pvAW6jOsPGvcGuy0hgjZFEi88GgGR9iFSjJciYJUfNHAux2pkAME8an0YCsxLfCKEv4/9EHT6H7CEkOwjXHmSjLaeCzh/YRYg3sM8p8BMsJ3UcmAJsvXOtwavm5wdMsh0XaLUEUbthPw2bY66Zgdb8Rd6OajeD3qyqXLJ4lbtT+seJGzVCGWrvc9ZYWDPyU8rXSz72x6BpoopWHZebBa0/padE35MADgspwCdvell9GhC4LPie3g6YuW4beIsTM/2nJ7fopzk00fb8K6tTBDq73Avc4Gsv1Mx8BHSNOpN9hHWjY4vOr69xUUCEWr1T/r70QM4/5jf94VN/K9j5oXK6vu6xs9IPwPbLgB7WuEJ+46L7KKYmqkGaC9
 C3IcqXjF
 4c56O85LhsZZNBXaAdSvsnemmBoJMnP7J9tgnIC483v8oC+jbSYsgMAvnsWBat8lsoW3YreP/o3L8BcYmM3J0YurK6M4q5r9+MTIFzwu/QZkVUJQc2BGbniVXVWWYPi9h7XF+7Ce04f1WcgKkc29j7zamiUf0QYqLkWQQdKIlxWjPjGqy7xua4Iw9CQIC9+lzZD2KS2/IrEQN8tbawKJ3e87u4Kh8JJn6WzaDWf1jp5+MRjdpw3iWFzr34qN++iAcBWGOphUGSSCb6xt1tgxUIh/PSLemlkJdsZ5nk/eEUUZmQa7vupjaox2o17/+Z8/NHd1OufxSe7/LjdXrfNfGTqumZVzJfPFTAG1/hlhuBdR1BaxccxS3rXNXt3SrTucuhFpwDfeJx8OuiRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 7ac6b232ef12323e3afb97b98301f623bce917a4..7b39c013027bd9c4ba6f080bfc9b3ec22bc2dd4a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1599,7 +1599,7 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 		goto put_parent;
 	while (!entry) {
 		struct dentry *child = try_lookup_noperm(name, dir);
-		if (!child || IS_ERR(child))
+		if (IS_ERR_OR_NULL(child))
 			goto put_parent;
 		entry = start_removing_dentry(dir, child);
 		dput(child);

-- 
2.43.0


