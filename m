Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419C9D73E9E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69666B009F; Thu, 29 Jan 2026 17:51:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16E46B00A0; Thu, 29 Jan 2026 17:51:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D1B6B00A2; Thu, 29 Jan 2026 17:51:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80CA36B009F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:51:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E3938B46B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:51:40 +0000 (UTC)
X-FDA: 84386499960.15.7B22212
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4858E160004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:51:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=V1CO8pm5;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769727098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uEP+gJiAzlwp00B1A4dOGcokvvRCbpgoelaDUUk+rQc=;
	b=mpp04rCROcrX4l/9qj05xN6R3yBiR1ImL6Ea/RYB1Y1B6QYj3USjJw6Gx5E2vMUD2SKJyy
	8Dbw83DE04Xfge/FbdCXBIf6rZK5zVJkZ/PHfBvV+6l2vrOi5yNFfemZviegCWOPmXfTYi
	vflnMrn6A83ZHaGbetOJxAJIZqJfRjU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=V1CO8pm5;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769727098; a=rsa-sha256;
	cv=none;
	b=nh1YcNYXoTGwtcLmIskqBS286KwH6rwctPwAiKgSPU7Gof1b+7y/V31jnwioRHec91Qs5b
	oDs8z5hJ1/uJlBQ6XMpPnBvMqK58ioFt1thGS8iB2/+T9129iE7fimurFxaKprVAsTQS34
	j0VKWqQUkaCqm8OIX/onBzTvIj0I4h0=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89461ccc46eso24594946d6.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1769727097; x=1770331897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uEP+gJiAzlwp00B1A4dOGcokvvRCbpgoelaDUUk+rQc=;
        b=V1CO8pm5lx1ubcg0WXW9eTdLB9AlbkVRWSHBGzQpB6ThfyNkTzCJloM3Mcj18NjJXQ
         FRXtcaWWNjYV5L/u5QXCGeMmhNvbyWv1aG/MImKKUq0Ki/mutU7jQ8bktYfw5jOHINDr
         9uN1ooWN2ByYyV5cjIPRsBOyUqRe/r4z0yVm5ebbU8O7g3Hhcxg7cyjV4hhkPzBSDZx2
         QfaJ/r4UItAf948asnnEavpcH0+YXVvcRdytyQdiYWEMFGC/eqCaX+1E8NVPpQzygsVx
         oLKh1+SRfncSusgUJ/T37jtd5TFEfGDU7blaaxjRppVPAG+rY4555kxXoUrn0f5v9TmH
         T8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769727097; x=1770331897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEP+gJiAzlwp00B1A4dOGcokvvRCbpgoelaDUUk+rQc=;
        b=FnbdMy7NLjq4R9GntqPHSNhT92mzyb6xY85G1f9elvpYzElBm/AYEH8VPYgoLaVpmw
         FqMe3b3lUVJatsJtOSFHclZ8CdvKvLevxgSMvp7giul+aDKk5WpCSb1iB3Dxshe6LV5+
         JsTxB11HUuECuTNH0XzaZ8ywxXsB3Pv7leh3QLXY4V5jPKBIyDSFDuAE/DcJegD4aBoV
         fZCfB+9XQR2JK6jb1Zm1iWtvk2yJBn0Rw9EYs+8XHVDxwrVs5ne3uwqrKDk3Xq7vuO1N
         V6av25JiZj86clCMuZ2EK/bAwKDeJ8xKeUabft3IkJj6m3IfTyJVL/frPi4bnwJEFvG3
         g9Wg==
X-Gm-Message-State: AOJu0YwfJo/KUVNkTPAV+RpRV+HKq483uiDsppMvsXBPanbKRZ1bGDcZ
	D1c8vuf+ISicWWKbd1TB73wPWBTdfNjCRtferhVITMvJOpphSnbALxT0fANkHoyYkld1SEpdexN
	qG630eA==
X-Gm-Gg: AZuq6aIHBk8uVyqpb/rYOhZxMNigSL8JmYflqxr+fV4cVUcck5hxSss9uxjLWs0yIrx
	mvfiHKnITlXqE/wcAjfFlS8OLolGIuwS2Q5Wkq+5YhalmY7+iES77XhXQZGy/2phthpsuqE4RQX
	iOfkbGZyRcTpkvhds+iG4ADDKvQvmtusCgG8W6Y5d1SoSF7yTsa+DoGRNeZNNlwSsgHUKHkO/I/
	aBUDHtwgAiegsC/JeoJn1kAM5FLFOBjaRTcVDrPOP2Cr66d8NqSiI1sTljfwlCEmvp9eQ3uXHqd
	Zx/M+fNXIMJfGt2Hzp6VCFaRzXemnCV9mx2H5O2onRgcSwjxuPmLp7sX1yqdOASK3wRuJtST8ke
	b9vnbK1p0+RKPxqk19uH4fIgGlTP4cuFiphV2Doy44rz+LunCJ6bSu2krowBJlyfxbllekfZSeV
	t1/m+dray79pNLI1MQmkGRLqWuNwfCd5gd6NSFlpU06eneanKBpwUhhOwM
X-Received: by 2002:a05:6214:29e2:b0:894:6c8e:ed10 with SMTP id 6a1803df08f44-894ea0618b5mr17277646d6.47.1769727097273;
        Thu, 29 Jan 2026 14:51:37 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d47f92sm493658085a.42.2026.01.29.14.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 14:51:36 -0800 (PST)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org
Cc: linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH] lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
Date: Thu, 29 Jan 2026 17:51:33 -0500
Message-ID: <20260129225132.420484-2-paul@paul-moore.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2528; i=paul@paul-moore.com; h=from:subject; bh=jNcQkI5lVA7LwC9/vCuDXRmjKKHFGdLPOmtZAer45UI=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpe+R0dStdMaTc8Lfm5qFDGpBQfKxtHEEtyER/O XUTmwfdj8GJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCaXvkdAAKCRDqIPLalzeJ c9afD/9DxXkYDZT/uoxwuPoLhwd+ey5hAd8FJbSnOKPAf+CyWIKU7uUdeGuwRzpaCN9DhzmF2Oh pcac3xMhz0nLUewgQ2H0WNuQX2yYAiPqumoj3Ap9DfLNCT+CDGoyUYjJ7PmXHyc67DDlo35SRek /R5yDaed34LudFzTfc1XRX8Xkbb8tcKngy3snRd3RQTpLpikgZ8pqchNtSPJIt2ELQZKAK/pcgT UBkF0SCOjL38785FGqiFWPzcDtzoYOIoWJhDHGALcxJ5/C/WEy/mLRB2szX9+QeHatepYjnMIrd mKjt45TisSfPIXizI1F24dKnGHbrLPmm72bXT68ZC1sbHnK3RQvi7NDrW8VDhSxEXVFgd8sOTxX HzDiAZxaY7I2tb4IH4/8vha8r4pfklG7OtcNmbj4EdjwdUBcFjqCCbGbzfCY+xn+4I85l14404T M5kEJLyKzg+snlv5ew0PnfMtyXWM4Y/SJQw6PRohgNBq/GeFnllmevAJdE/lNtVQ16eqA/magEu Xvf6r9jSxp83obf/q/oiEBi6cIyhXEzRD/Kwhz9ad9Q8IDcKI+4Si6CmmuE4eZP59scaDzseW4k 0bu6Ai9AnBl8z6PmxPht9bwVBu++iQTKaqbDzIMBvP/L2f9m4ccSoQpYl3Hq4zt2OJuh34D6Z4G KOR7Gpa1Clfw
 cBA==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 13b4td3k8ddu5ebtdhosmq78eww6y4f1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4858E160004
X-HE-Tag: 1769727098-660647
X-HE-Meta: U2FsdGVkX1+MeKd8WpHOmTTBn1E/UyNCyY6m4I9ON9VVrvNmxk25Y1LIAzXPmbtibOa7QUJ/FjRjyFRuFWikJANOJmRP6W2ooXZoUblRvTp6KiycGKD3+9BDy8k4rZgDzghyvo5EOs8u2LEAEuEpdSszJ6wOhQ77fo77JX0XPrk1yVEWbjHYg2F+D+k85K2Fpy7NyOejevP7BkFKG7Yu8l6uuTAKqWOF57eWCGHTrp66DJrsuIoV4XTq+tsN2uqoGwTx8FNWdjd2IeCHtKTw3bxfDyMgaNwrO+j6v8sw4Oeoz1aqOhERZ4TI5aSa+8MKLF2qJHqqQefqEwEPo6L2h7w6vrJ1eY6+Yhz06aIzs2eekK+xBr6iXOdd1diu4GuK0HB7emRZrVs1RZ/tIl5rlIHgwNOmS7AVLz+4kOJtWaTnjjV0bm7So7mVGC2AuGPT5Da8vBN7+FAyCoQeD8S2Eh4tnOwKFiRofuzbWDexQYisD2pnHvxLelNLHb4oCsCqTbCAWZFNdL5UrksusbjJD8hlFzX7bADgn5t9W16jbPpZGaKX+k3a6XNhs11YKQDI+pNLq/UFQtZGN0U+FOOE8zdOOW6HOCVCYz9CKCKqgmGI9LzXlXqOvF5UUmvP+xJl6k1UUd4hnXvflNNwDYBp8C+iElMnjFenXo92j85UoQU2IMMFFXeUqZIfq+nX0HGitbzXZvSJCZh8B05AvvfvCYAgQFerAeMn3Rsymf4XA1vNWz6ifLZ8GI4+GFLl8RhWrr2GvGD6w/d0IWPspuqNOh+Y49ZrmHRlzAu9reQAOLFIyAeVo316oyu0UNQCQR2lll4cAgfHxNg+QeClBspaxZT/Tma5R13niQAUF2k4SuI2rl+hU66jm7mocJlzsIo2P80IGLga33qINjWTmSok3PCVf7VrxNov8iPd5nO0n+1dHOEG5lvZ22B/s0xkxcv8g/AzpUmai6/O+RfBigH
 +QgqsWQW
 pIcUAuI4UI55mLTqMcaDWc6xQjnfvT1NIsH6T24T26qHIApKerQxaC/d+h8MFVHYdhyp5UrftYimMA3Sq4Hv3KYFtcgu3URnaBD+1yt2qA/nHTQkVVVcZ+92Sb2L70FPAQ3mcKxsQ0IDyGTNSCISv2MNU11/ZkVJhfQbQtlNoBjNVB5vj8sJskou1BUUpR//hCEdps+L84tqoauYZyJXumurISIfgOeM0CqVAgYzVlsxQ+BtRZvDvdRsbKqBOUekoYUIBCReIDkifw9Fbiv3o3iDv0Xxpftx//qakaieTAovWCWk4GX0pnsqDknHg1l44d5yTZEbhpaULBJqP/tRrcbCPgdWfZPnJ8z8XZnJxuca3PPVC6gIlX9TduDaLvCM2rxGSnkXThA2/MsZrRoXpQEcQAVOH1RsKP2CIz69RV6Xp9JDlMSsUSsj0fRsWqTY2jsNCgHpXe63QPubEzuYxdVGxt+Dosbe7dV9mW6n602Yo/BKB7t6AZASmFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While reworking the LSM initialization code the
/proc/sys/vm/mmap_min_addr handler was inadvertently caught up in the
change and the procfs entry wasn't setup when CONFIG_SECURITY was not
selected at kernel build time.  This patch restores the previous behavior
and ensures that the procfs entry is setup regardless of the
CONFIG_SECURITY state.

Future work will improve upon this, likely by moving the procfs handler
into the mm subsystem, but this patch should resolve the immediate
regression.

Fixes: 4ab5efcc2829 ("lsm: consolidate all of the LSM framework initcalls")
Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/lsm.h      | 9 ---------
 security/lsm_init.c | 7 +------
 security/min_addr.c | 5 ++---
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/security/lsm.h b/security/lsm.h
index 81aadbc61685..db77cc83e158 100644
--- a/security/lsm.h
+++ b/security/lsm.h
@@ -37,15 +37,6 @@ int lsm_task_alloc(struct task_struct *task);
 
 /* LSM framework initializers */
 
-#ifdef CONFIG_MMU
-int min_addr_init(void);
-#else
-static inline int min_addr_init(void)
-{
-	return 0;
-}
-#endif /* CONFIG_MMU */
-
 #ifdef CONFIG_SECURITYFS
 int securityfs_init(void);
 #else
diff --git a/security/lsm_init.c b/security/lsm_init.c
index 05bd52e6b1f2..573e2a7250c4 100644
--- a/security/lsm_init.c
+++ b/security/lsm_init.c
@@ -489,12 +489,7 @@ int __init security_init(void)
  */
 static int __init security_initcall_pure(void)
 {
-	int rc_adr, rc_lsm;
-
-	rc_adr = min_addr_init();
-	rc_lsm = lsm_initcall(pure);
-
-	return (rc_adr ? rc_adr : rc_lsm);
+	return lsm_initcall(pure);
 }
 pure_initcall(security_initcall_pure);
 
diff --git a/security/min_addr.c b/security/min_addr.c
index 0fde5ec9abc8..56e4f9d25929 100644
--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -5,8 +5,6 @@
 #include <linux/sysctl.h>
 #include <linux/minmax.h>
 
-#include "lsm.h"
-
 /* amount of vm to protect from userspace access by both DAC and the LSM*/
 unsigned long mmap_min_addr;
 /* amount of vm to protect from userspace using CAP_SYS_RAWIO (DAC) */
@@ -54,10 +52,11 @@ static const struct ctl_table min_addr_sysctl_table[] = {
 	},
 };
 
-int __init min_addr_init(void)
+static int __init mmap_min_addr_init(void)
 {
 	register_sysctl_init("vm", min_addr_sysctl_table);
 	update_mmap_min_addr();
 
 	return 0;
 }
+pure_initcall(mmap_min_addr_init);
-- 
2.52.0


