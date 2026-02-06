Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1263CE9129F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D8D6B0092; Thu,  5 Feb 2026 23:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7179B6B0093; Thu,  5 Feb 2026 23:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A6E6B0096; Thu,  5 Feb 2026 23:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51E8A6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:31:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAA9F1373EA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:46 +0000 (UTC)
X-FDA: 84412758612.12.15AB2F6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf22.hostedemail.com (Postfix) with ESMTP id CCC37C0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cKpH4D4H;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770352305; a=rsa-sha256;
	cv=none;
	b=8jMASqE5bbhsbuYRL9hgdCFSGN93k0ahTNoAZasK4ZZ3ctK7sW0t4eJxGbAsmVwDTcewcQ
	udF+8oyuaDJqC2iIlEqmmAi034NmyaPDxa35lAFrREx9tWOuAbNsh4vFeCcHbshVIOkMxq
	X2MI2ZO3B/QyCZihxSvbQkRVCCdMAVA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cKpH4D4H;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770352305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nM3Kd1dcWbNtOCwB4Z0eTREwnVVuKbCgjD1cpzKymA=;
	b=Y3xrGN6y2lvDuZMS9fvvA6sgiuzXEMH6nnq9rs+b/ZL3U7WnOmUuKIlIQQrdsp/+iAJdtk
	vp/ph/AmWcWtah3hUGHdS/8gzdRiKUrb3AteHa3odXXujtvFYeydhksfL6vc7kHzIKnI4m
	dSk1W2sOKICDAGjNkBvtltMIQAVXY74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9n
	M3Kd1dcWbNtOCwB4Z0eTREwnVVuKbCgjD1cpzKymA=; b=cKpH4D4Hx9iNY/B5BW
	kUjm7WtCX0HKyg/scUGbmFZa3O5xhwCunsL6p7OAHhe8hCevx5J6o80ubZx/F5EZ
	0B+we51uE4yg/Cq6yYyx8DRzKHBI7Djf0ATuP1S/Koss+nf3UConQJlu/fKZTXah
	dbteSueETLGWDTkO+VO9kcvko=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3sLWbboVpASh5QQ--.27597S4;
	Fri, 06 Feb 2026 12:31:29 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH -next 2/2] kho: remove unnecessary WARN_ON(err) in kho_populate()
Date: Fri,  6 Feb 2026 04:31:21 +0000
Message-ID: <20260206043121.197564-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206043121.197564-1-ranxiaokai627@163.com>
References: <20260206043121.197564-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3sLWbboVpASh5QQ--.27597S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1xXw17Zr13Jr4DJF15twb_yoWfKFX_WF
	4xtw40kr4q9r90vr1Yk39aqFW5K3y8ZFyqvF13XFWxJa45ta1j9a9rZwnrAFnxW34qkryq
	yr1qgrZ8tr4fGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRAOzVDUUUUU==
X-Originating-IP: [117.176.242.230]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxQF-y2mFbqGCcwAA3i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CCC37C0005
X-Stat-Signature: zxcihbe7xsihubg8pio4ct8iuch84aq8
X-HE-Tag: 1770352303-251224
X-HE-Meta: U2FsdGVkX19UloUJ1dAy8FMHgiLhXmEpH8FfKty/wbJcVMWzFfj3sU8FFBu87F6O97qNT5SQD4rnwow0RWkoz0cH4uUvGQsiRGYmoPLLWbvcARSYlmZLFdqdVjuYB2V/IWf8/vwcE8PDpHiCtR/QM4bgfHesb6khAr+JkbsmhWRWx1yNDc8DedEVbK9tqe1fAJ2Jl7ij1ERjqCVyYf+Vby8Jn5+TxKN7EEDAB8VxQemygtl6UXPZLEHMOB09wRbS/gzlcSk2DjwCaMGMAd0tSRZhi/a+YUFLTyEYWSAKS8PLQqDdxGwVC4V0iL+12Qi46v06rTK4zUwnlGKpJ7T2C5YcQq6VmR/E1HE/ZSOs+6mooPk/JEZO35uXznox1IT5SkOwFjZEyquauVJfNSRAgl3U7U8xU/d05Y+roKm8ydLbFscuB8JCUAreAVCpYzf9kG1p8Qf+pbVtKhaJoj176SJYLWpIbcXlNHEZy8pgj7UJt+h0WZ/W489AMgnF+/x+FiW+G4OmM9LxQ/M0gAlJLGaNxI8pNpWWWt1h4C5upFHtxQ1+lij9S0k70By3qix0vCisSbGuKirKgb5X8NE4ZKY4/2c44po/AyBkFGZSZrh46fivZg+cYwueQemqZi0IBJOr9F6WzoPu2nK4Nb1AEdhWLT0Z7Tnw53VKohQ9h3+RwUKHD2KJUfR876CPwtbiGKZNqCe9B1BBeSLty/ydRFN6MLT8orWnVkdIu+klbL69FookKDGBXT4evHIU8Gcm9ihi03yTwJLuFteq4oHXMMbO9bW5TCPlShYb3054GMcD5V3uRJG/bp2i4TkAO1QktV7C3pp8oJjR6q0vJ+soXjA2x2q872UQ2TFj45WuboeXMWUlgEI0R44D+cnxMsP0xn/Kr5No/Ue8Rmr0uEvirkP/Hlvjpx5yAf6TGzd1BMFL9UlEjeZtfYQcZGf82tPF3aGSlWmfbGozTooDnA4
 rXK42amw
 wxPFHf0VPiNr98TC8ME2zTp6OrQG/Q7ehUpJUKE6M0PSeaD1fE+7GyeP9EF4grh+Q0iHtH0Q90CX44ADGR2FiLE8TGTGmjKE8/PPDLldsAlBkBTRIYBQ4vcJ+YxG7s5OAqFnYPo0RoaEwSBIzOG3eVCNH836ZPjXKW4ADS5feBhdFBQMDkpYb/Z/MTCOCBZ2EQH9weXbwLTxk3ydSQfAk2h241t3eGDHiyC4tY9QyxN3SpoaeJaPKAHP7Ab/pqy9UTlDl3O8PVnzpHuhHSjnEoCEzSXh/wYSg96tyo5TO5WK+0w5XKHj/Tq1g3jZ1lCy6ZKFjhYy8krwVV6HqdXWIN7sx0xFt3g/Vj/aBxFlWBkRiKJMpFzpaW1mKgEV7m6AUVDd8EAEPFjdCYFo/MtMcUm3QfWDAMcpSi9EozFNVrOdOlL5rNFqXzuJSG2H2AtktdRbD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The following pr_warn() provides detailed error and location
information, WARN_ON(err) adds no additional debugging value,
so remove the redundant WARN_ON() call.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 76b714db175d..b851b09a8e99 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
-		if (WARN_ON(err)) {
+		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto err_unmap_scratch;
-- 
2.25.1



