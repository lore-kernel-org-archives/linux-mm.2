Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DA1EF0702
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 03:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11666B0005; Sun,  8 Feb 2026 22:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8516B0088; Sun,  8 Feb 2026 22:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF16F6B0089; Sun,  8 Feb 2026 22:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC9616B0005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 22:36:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EC271B3277
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:36:17 +0000 (UTC)
X-FDA: 84423505194.26.A103C59
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id B72D0100008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:36:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Czw8FdcF;
	spf=pass (imf05.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770608175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s9En1ZjzwdUVaax5PkzJ/h+Wx5WAa9Iy0ficjCV4KD4=;
	b=hb3tk7dlT2xq/S0zkbl6yJs78rOnhWqUTEWiAz2zgEX9bchL6BiqB9NY8Uw0aLhvcNtMMq
	8DMVwWoMfF7dSfzjJwRTIePjtguv3MGHXhLxP11sCsr0bugbFxA2YTLH7wthcDE4G+Hd3l
	3l1XTcQUvhgeFZXOnSKSBHeR6SXqDCg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Czw8FdcF;
	spf=pass (imf05.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770608175; a=rsa-sha256;
	cv=none;
	b=DGsUHZXzyIRwH3nKFV/vc/kwRzinGxCZ+fE0KRCAAAV4oWgap1wnsYBCaL2raZVB7Y7Ho7
	yJ3GAeCXOjY3UrjoWXX9bAKlHKKklG+VnrkSAeA/eFltlMEPcpwrl/erDEJ/jrPeMWEHOh
	CN7H2Ivek/KN7A9cEntiJkO0HxEkaK0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-352e3d18fa7so2203828a91.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 19:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770608174; x=1771212974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s9En1ZjzwdUVaax5PkzJ/h+Wx5WAa9Iy0ficjCV4KD4=;
        b=Czw8FdcF14W5PNiRzoysYElrkZsx+iI5KwBbR+eiQ++lEuava3hic7Smksi6sG63rI
         c8c75lexbCqWxOZMaA8klk2DNkHMyzUuKVgw1A/AwUQe/8u1ogdBmKMg04I0pUw+Rt7F
         /cYHhSjYpRmxKFaJjptluqSw82I/u6DtNzAobvhp/MygKUbgvfgm3Ti/FwYCQJH4/8TK
         4SIbKn7ZwXToL/A9mQas5ZnRWbgj2sgju11Gu2RLb7qX6zlrqgZTUx2uMF42jX6bQBNp
         TYp6QIxe3XjKmnlmk5OFFxnCZXthO2/VTLqQxMHbwuEdsESJbFamkA6qK+FwgYI/aeLt
         udAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770608174; x=1771212974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9En1ZjzwdUVaax5PkzJ/h+Wx5WAa9Iy0ficjCV4KD4=;
        b=RyZ0tlaEzL6LqcSPeQw5lSLVmlYWoSmlmVTtLfH2R0XtfOM+DgNS81VvKcDTscMKDS
         XNOCaWY48pHZlT6qoR+4BVaEKq3CIxQRCDXmG6mxZoUZNeAm78EVX5SytErFOU3hbSF6
         93yrCc/MgK/VG+DAuwuzPDgNKLF8BZNnuAuOrAHFSxX+gnA9J8HaJ9PRMgflPd1cekig
         n6nq7oBq1+6lc63cBuZhOtKfAK4SPhXZvBJyiCL0oHJY4HuSDrwWQTQHCdI7KjlRmXgI
         u6T6P97vo93p353asB/oyu/RyqT7L9R240VR6V9AZRwBkt07sdoMlaw0Wdg/KvZqML4y
         p8vw==
X-Forwarded-Encrypted: i=1; AJvYcCX7zfRwEo25ElVTwBbEzWYktZvXq8bRXGRCo8RtZkTwaRMdGNZd95Bo12quFcinFfiSUHyPdyaFCg==@kvack.org
X-Gm-Message-State: AOJu0Ywc77kgU1+yN8LOpOUhHJFCtGZXe62PZmtsmHZ54lOI7LTQpCsT
	Ouof5X7mJ0ABGoRNmFWPX0JH4W1X8Xm7hR/xCixPWlC8N2Ft5MEM4S3R
X-Gm-Gg: AZuq6aIrFLHmx3LztKR3RVYykltMBTODL0C/rCwsbvvkkmttucxSUjy6ZCu1Mk9TGZb
	QTLgdkJkBK4YlazQXsaO1PyqbULAqCK+x/YeJP0lqoMIAbyRp+WIB0AGCXQ8riQDQvK9EnpPo1u
	nQqkr0gFeBxY9sZgFI/Gf+X25HCbL5sQ5ZA9S7pII4jynBjo6QXGRWJjPDZpF164OgGohAuoOKV
	nzJ5qkXM6xH/Z5HtuFeQz0Uv/y0qizK4BfaR8kvtk/b1vJ/R9k+fWvdRTD80toqjaTXrDeA9K6i
	ZXZiaTAQVc//lCwM371KiG9f+R3Su8CZ9t9T0L4TbkLZKsr4fVK0TdKtakVpq8lHAm3VoV3jenp
	h+LhRLwGtllzmpuuGgq3WhTaG/fyL/fvIP71vM7IlyDcsbB3AO9TTTof777JyJwvlowGpBoQX++
	Zldlo1S5CjG/OYLxPKu0JcuuU+jxEthBdxLSR0xAMtsqjB+SDc84HE1djcY53JWVbSLw==
X-Received: by 2002:a17:90b:3147:b0:340:bde5:c9e3 with SMTP id 98e67ed59e1d1-354b3cade92mr8912752a91.23.1770608174431;
        Sun, 08 Feb 2026 19:36:14 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:8864:6033:780:138b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354b21fb723sm8577308a91.10.2026.02.08.19.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 19:36:13 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ackerleytng@google.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	michael.roth@amd.com,
	vannapurve@google.com
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
Date: Mon,  9 Feb 2026 09:05:58 +0530
Message-ID: <20260209033558.22943-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q7mk97kej6pbgj8yjc1bg63db81zn75a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B72D0100008
X-HE-Tag: 1770608175-596949
X-HE-Meta: U2FsdGVkX18s9XjPGwxrjuGW/fDreg6w0GUYdWnj3NMSecHlCJHVn3kEYq3f4ehRnqpaknhcVqupNbaIpji4Svgh8FRRBk6AP+46WSlGVebW9KhxQuGyZxDKJpUtKihbCU0v4p5TLbULz9SJu6fAA80zsRgFahUGIyZgo622gGh/ZEKWHBOzK++DCfxzeiZdm3e1PV7MbrSS8k9/ufdu5n+tuXrvsljahJupYG++r1K0LJJ2cfANZNTAM2tAN3G37X5G6yDOGgExvLtYfc0pFdC+1fMdFH2MQTsHMLZdZxfDb/+t0ajati7+QpNE1hc5UJps3qfu0pXX1wdHNZXPAmECPyUF+EZfcB89Wz1JwGeVPIB3dLXixx4g93XTqJmxdf6dQcKGlYbD2RsjnxZXoiYKc8VrPnnb+mFCmemFc1X3g3Uee316/PoXTuHKkn4TL1IdE8qHhdt7AUOdVgxAzmfgL4J05fOIDjKojQJrTaN3k8U7uqyIcbaYC9y9ga7cheYLKNv6ompMhSoXjE2Z63Zog/SJxQb00qGeZUszjaW3PLgKy5Dgb2bNjmoGzz9EK4QtjS/omwyMaqvG9ElOqOwMDY+s3bcNDggHsucjtifqM1R6l+nVETkFji/rsg3G8/2EEFFzdRtUf2LOaPftJyqSuapClZ0WRD2mBPDxpxxSacyAf82GX4f55J0GE+BbvV3P1kiJD0i8ynLJwXhixyRr8UpdelowsEeWgEx5+54TfO/X2NFKmBQJ6gpjsfXT63kAqflFOKbes57zhF1roO6NANcGkgdh7wBdg8QZ8FpsUi+hUgL/HI/1VKzjG0QsNSoOjQj8vtHUJtjn5z13/fir81oeb8ZgJ9oESn26JEmCcffhIRq9EwQmAOHt/peA+bim1x6V1eq/SX+9Y9Qw4ZJbT6lMwsLTUm6BwnUMGy3q97bAY8qqdcwaVzgMVknBInw41AD8Sa4gAQ7i0dv
 Oi7yR4Nc
 WoPekdnYV+tjDhol0ritA1sGdva3HqVR3Mj7bVITRKcWigSBQpxp26KRH8pmG5uMHiKR6qgGlensL6w1E5v3lW1s99htafrqPBIgGwurVpPJiOq/PQUC1Xook7Imsfg/5FzMr+6rYJ+BbNKtfpNSUEyRbtCAtsu0iatsnMn8l+Lrv5wGpBzrwZuHaPKXF81tlDhngQvNALtHYwSAcGQvJGYcZvetzylrOTKh455HMjBnu6v2cMjWCSxfZ7rjb9iK3q2rVshzBWutyBfSi3SAjFyb38n6b47mfiJUu/wUQcyxhWgJhWCWtbdPcrKxdJuS+AOqWpBHAklNtNdmTzrn1iWI5RtwL1rC/GtkJhD96jNI1dPVfaWS6BI7fj0ly/Vq0/IT3NHbybDDh5dJUsZnRn17DxV4v9DGACUH9kfrmpXy81uuIiaB1jgeIKseKFyyPFs/U7ugjKBchypHfbRgwgjK3O5nM3JvAXV938hpsSOJOXUzjuCag3o+hVi8AiuLKNULNj0adw687poxEOWT4hRcLtUlrnwrxVTReml8nA596x4MLSeJIsrLhcBo1GuBPam4YIoA6hXszcoVXnbQTlPfMgtjz1HW7Bbvs8C+673IKXFRyNJavWUMM5s8Hbvz60DTJJJ5GoS+gCPBA427yneiEDuZE0gSuDCdk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_thp_enabled() incorrectly returns true for guest_memfd and secretmem
inodes because they appear as regular read-only files when
CONFIG_READ_ONLY_THP_FOR_FS is enabled. This allows khugepaged and
MADV_COLLAPSE to create large folios in the page cache, but their fault
handlers do not support large folios.

Add explicit checks for GUEST_MEMFD_MAGIC and SECRETMEM_MAGIC to reject
these filesystems early in file_thp_enabled().

Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..4f57c78b57dd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -93,6 +93,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 		return false;
 
 	inode = file_inode(vma->vm_file);
+	if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
+	    inode->i_sb->s_magic == SECRETMEM_MAGIC)
+		return false;
 
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
-- 
2.43.0


