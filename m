Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0071CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70856B0088; Thu, 28 May 2026 04:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21DC6B008A; Thu, 28 May 2026 04:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36C16B008C; Thu, 28 May 2026 04:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3ECC6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:11:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67A9FC27D6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:21 +0000 (UTC)
X-FDA: 84816108762.23.58CB678
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F33140004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Vzt2yiV2;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJmNoPx3oaeA6PqMQ34pEZkGLLkXi0yOR8EY4hpMPHE=;
	b=o+WDkQQwbvqv/mmI16ETT8gevskf/lVo7rYXq6O36t0HxUM6aLK1uRx2MPdgkaXwa1WEeA
	TJrM/JNCQKh+Efbyl5iX8jn+9FtOWkLOBvte7Uv3DPVhhAzFqqPzFnYMBDBNUUUTKF8C//
	n1R4wreutsUS1p6tFOqP+1aeXMvNMk4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Vzt2yiV2;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955879; a=rsa-sha256;
	cv=none;
	b=R1+Z3Oye7qpVhnGQ+fLrL69Dy39AKAqYZWS5nsWokEaIAHN5TCWnAt/pQPrvISRQo9xMm5
	7xv8lhFrCnStHGsIJvZbsNywnuydM2SfjcdqAEnvG28WXNPYJEhdmW3u67OMoktt23/nXk
	qh+T0I0Z9HFg78JA2hnCZMPiz8YSeYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779955861;
	bh=yJmNoPx3oaeA6PqMQ34pEZkGLLkXi0yOR8EY4hpMPHE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Vzt2yiV245oaZEy+00DqMKw2DFAUlWyO9X25zJbHDIpHAuDBZ5Cm9nZbNC+OJFQGW
	 LIXGFie37/PztMztdDdD5PxWkwrQtjqx69+VawEYalp7iGHG3xHah0YHISRh/Xra+E
	 JoVRvwaWW0yLiPK0T/b5hwyGRBwE3uLHX2IlCtBQ=
X-QQ-mid: esmtpsz17t1779955849t1d49df90
X-QQ-Originating-IP: nZ4UXvetsIyyKOSyybdUT3u/PhenXD2LCe9anBkoWec=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 28 May 2026 16:10:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7792598639397190847
EX-QQ-RecipientCnt: 8
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH 1/2] selftests/damon: fix DamosFilter memcg_path assignment
Date: Thu, 28 May 2026 16:10:38 +0800
Message-ID: <9B7A70233DF773F5+20260528081039.1192194-2-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528081039.1192194-1-niecheng1@uniontech.com>
References: <20260528081039.1192194-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MoAHuhB82TZgToQTVHt3NDbioWJedjP1nMSJAQ4NgqlJ9mz/3Pey+t8+
	D+L3CU1X/u7ohkhKnb+ebFv5YD9ix3moFjRKVeeMYce2QDwZRifIaaCUL8vTuJqotW42M+J
	dnl9yHbQBYHXORM2yNtGn6B3222ayVeh2AmOKpHFl2mLpI8fPFAkaAamwBSDV1ovnw55EXl
	Z+7kYv5bDhwRjNEFdLvXpdSm4AImdcjbbvgDlPS0jVzR56Jzmx5RvxcqRjEKrxznKW+ZAvQ
	ZZqnUiUm5Uk8l7OqmziSk4y1On3E7noRsY+y8H/v7qh8O0MImbiTloprMZaR06mVJumxpcW
	JpOiwF+1HOpsGtXNvFtjdStRhbJn63fN1/JiCLJJjJGA0Z7QdsPNrzS2cH2Sp951nkxdjIo
	R2g9tztasbqoqbnxrxPV+0tMBXZqs0mDoVwLIgRVvq239whqLo0RP7fxYx49/kEjk94MOOc
	FFbyOo90LvfQpvTCiHUigr5w79xd8zqwV4j4vzVDY6m4y6g958BspPQNO07C6mSgE2TJ+Or
	/7JhDlqJgrAYLYWeA18EkDLdZdk4EfS/rONH2aKBc694kX/hskXk4yr4kLsqhGKtLFQG6t/
	2wDPzSsc1mAy1vJHv92I8AVmapR+zcm3MBXNxcQgAB+vmMaLjujIZOqrpHRkKcuy4IsDnWO
	QCFlzcKLUpurtXPq14t3T0CGWq0nuH2E404J9y6VDFL3lILdCfK73I1p2ZVtx7By54k0BTM
	M50GAhGT1GCoiWrM1ApHRPZW5OSRjRmQ5E0rg+WTeAJNP4zIkRQ4CvPBkyf1nc4zRu/en+l
	lnIjztkCDB3Hs2O5AUNx86qXfGqvtZY/4+5tvZc7ttC04Jr3IJyvcITfURRDiehEkOdRDYO
	/f/M/rf2PjyQckYSzvsAetHSQjVVG0e3F/JCcnCKJkbkgAnC9pUMgS2FFgzusOMHo7zfsuk
	xRY0T6fAE403UAUU+OfIgzgwPcu7q312+t8mZi0BOnv56bKsUNHD2aehUB6cwPvDh1x21mp
	K18elLMyB6AEbl3zUjLjRibyGq3IqI4GYSf/Vwd3VcZ102yvn8bwuh+QCSZ5BPh5u/OzkJS
	nr8/FtqE0QMp+ttWFhq5ol6ynq4iXbRQTnpuXH+9GAbWaOrhhBN+nfzXPMd85bfrBrZJm7h
	SEl09+yngOt7UHI=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam12
X-Stat-Signature: jrui1hskfe1foehdg3k44jkxocsfrz1b
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F33140004
X-HE-Tag: 1779955878-669728
X-HE-Meta: U2FsdGVkX1+EuzXOG8uAbIhjT/Mxs25xZji3TCyVNt9aS9AZR5DW7oPULUT6+iPOlseKUqMta4DBIsiw53WLlyBgMlbWdmsoWlLan+zOMoXiEESjZ/dWCsK+t5hvpXScGAx1lZcE2+vHuL3ASs/AWQCxFlMz+3OWdnleorEHpOK7VEUH+MR6Pxa/MJNQhQjvBdLdeCAaWOqB/JdapENdSi5fOl5EeJPAmDfTXfWmT0m4HfSaWt/BWTamPuNFShvR2cDV5h3NTcBw6mPiZnSycyaS9jHetUtUHmTEgleyqnoTgGdcKR7PX3lTX7vvWcPx/lg3BZRBPgwD8ooIwP4v8iwMQh+8Gv2pqwDkt6OudyTCJbT1PHEAhjs4U8g4X+MeSBFqZV624XLg7HtspoM+zyqZKJsjtTpVfPtJe3zmIkSb96n9putawD/FPWwV7fK8ecd4rOXWvwQ9fi05sAorXnIc4GObqz4BwGekvLTqXKj76GbWCVqf2UHikAr2M1ndoNaMR7KzS/4Vm3uUiWIj9KAoEFIytwI+PasvLBDGu50ccyxeAKqF9Akh52rAWvvOuF2/CnXl8UankGQypk3X2qY5q9iir43kqlyM+Pk7GQGcMN8Teoc8qgCEKm1yU00r0fiSlxm2EirgOrpW66sDf8E1f1yhRWqPLgjpHluCwRlPFtCCa97VBkiEbpk+QWWL17O79R4YPnl2+FH4uPtFwJyOf7Sjy5BGRuJbJ5F85eg5nntX1X7pgZ+C5S4jNyjmpRSxwG4YhdfmK+pxGTy9cONgc8k6IqqkoZV4w+Sn/4yxIn2hFLrrH7yUR36Za9Op1hfgN3FThPIf2eji86R7FGbHOs4DYfMtpBXm+ogRgITLmTve2aflaxa2xaKJefOM4DEaR5vb8pRrWeGv/RpIBJJn29rsh1D2zEofQl3Cd3eHWokZKetzo9JDNkjG8KdpqVjNbrncJOTvYAE1BiA
 IOKWcBLF
 yFhPkiJMv/Co7Js4bIlomOZA6PRZ5T/vg6UAx+j82YERDHrG3lpUtgYLJMJpEOY9oJtUbbJO3eCXUBC0wqFzTGgXNRyjfC/QF4mCoNZ/zFvX8LtKuyPzwMIZHMp1/CPBPgI+V1hb4O+xHxxsoxwzvam6RHxVOVTwvt+xKZLfrjusLdkCCTK9YK6LBJC88relzjlHfBeBSmrWxFP7nQOl6R+Cw0xN5MPL0thkArFUcXj3C7g2ESSucKBQoyADPNZjPI1ZWXzl4Duk86X2eezPOzR9YgEsIisMxlJQ3SxEutPLFn0gwZK3y75g1OeOAKRQmb+nwMsj8BGoajHkhGyYSlulV8zKxStZzygkdD3hDfCVtPPY6soaQ2CHlAlEMG8ROt4c59IyeqOtYjIXtBl2R4ToRE5sBwxrPBTxqKLP00Y+KAhE9mUeGy5hAqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.
This makes memcg filter staging and follow-up validation use the
written path correctly.

Signed-off-by: niecheng <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd..022f0d392204 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -254,7 +254,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.51.0


