Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86C8606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nYkZT74l
Received: by kanga.kvack.org (Postfix)
	id D3D4C6B0801; Tue, 27 Oct 2026 12:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14F76B0803; Tue, 27 Oct 2026 12:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51D96B0804; Tue, 27 Oct 2026 12:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACDED6B0801
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:03:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3BE21A0A30
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:03:43 +0000 (UTC)
X-FDA: 85368876726.14.5B98824
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 002A31C000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:03:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nYkZT74l;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzW+q10RWKie6Pha9KgepWUrxRSzuZH0wvLMyxYlSms=;
	b=SprJ0IGOsQYTlq/7po53JOm+y9IrF43ao4KVAoWdHThDInoZnlTeVR1GFXuQkSdMHKH5G7
	wNgHvIQ+ZfD9mcpdvJB5qRJ/+1bZUHJXc21v+YPP7qigdXfCNp/nxXg/bHfEAP34htp4Qh
	9DFMfHkITI3KFPP0X9aanH0Cv66A7w4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117022;
	b=grT7pO6sRxw0zHXDOXhhf3DsFch3GDqL26+Xqp35WufASryYcdnGunCA8IUhkoNsA5LUV1
	xYT/GO/tuTt/t12DJwb94QdLD+baE86zF6egreQ+WB0l9BvW661bo9w2wMw0ptouGHR08P
	SSdbwsQIR4YGzIXvM8uIePkO5qfs41s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nYkZT74l;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adf5f6833cso43835a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117021; x=1793721821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wzW+q10RWKie6Pha9KgepWUrxRSzuZH0wvLMyxYlSms=;
        b=nYkZT74lI66yFui1r/CEfqlX+Ui5gC/3crghvWLgIGDQU8/GRTFRMDBV6TQSnoTgkb
         Xijg3zGD6Ee2x18tcQ7h7badhzfBsy9OtZA6ycaL+3pmzuQBXgpCXkBlBB/rtYGIdzHx
         IuVxYRX3rmoMf8hYWPDlRuVwKFWKZCn6kSihkQjnzV919f0Eu2A7B3RUwQzWTFsu4efc
         e6kHwS1iN3mGu3gq0+qByBLd3sBYqDvHPxh3G6YIzschlJLUn1vXjhRHcJJySp+whojw
         awG/b+b5ZOEsyBnaQN79utakQerU6tWyX+GEMz4VbM2FrNowELCjGCaSJFR++EJec9ki
         6ZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117021; x=1793721821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wzW+q10RWKie6Pha9KgepWUrxRSzuZH0wvLMyxYlSms=;
        b=OJ2E+8yrLqbsUWG6664ANs6FVfx/Bla91HBJ4fZdPDJCveNtVWzoUNHRM0fPNkvoJy
         fcZVOznceuGErXYZZHffWprm+J6BdfJWfHkROO4BHMNOJvkyG2D9Zdjz+sSq2DCxTw18
         LDhQCXYaNIz+owDiTBTVGSve0Z02Sbeu/SK9I0nH+U96nbgMntKjCAYSysWXwGpead2b
         qCp/eQ1du5lY2vVvizFxUbFVzKF7AphZ7rC7TSqbtgb/Wwg0gmvNdLkd0qtdwEaC4EVt
         BxjsygWVLdq8J7J6Sj0RTKk05QrErZwnHjdAZ1DzMMzwE2OIarVMcO684efByVI+Ysu3
         z0IQ==
X-Gm-Message-State: AFq9FYIdcEUacUderUkw/l1HDIeDcF67e4n+RSu+g5qEjeRUWS3f1yKJ
	Vb2qYPPelyi/hdTetSFzeqB7yG57ayjRsLvbrdpkYwLoorzruZZEotxkEN2eKw==
X-Gm-Gg: AYBFou1uZBCndOo5fAF8dy5FVm8Is0wyv6Y0i/jXaQYRAPBWfKZzkKrHB7Uvd63BfTt
	pXAIJWxpOeRcXBfwIYBn+FpPQKp/WvrZ+Cc6GvkLep/Rb8mVMEVpKwCkt5s+VA7ex6Q7hIbkw4X
	fJLPe1qtQlsywx0f1lFg6zl+VnE4Hh2Jb3srCF0vGFPUh0morF54aIL/i/OtOZLUoHXHtTnmpWw
	/B9yqovKFyDSYl31NUhU3IIyIMEoznrna63nZCEkMkJT2Vz7nnJUIh83j96LBIcQ2jlhSmoJt8i
	D1DRjvL1AxbkCiIGCvJZWNqPBSJVmjResCEVOQAgc8p8Zt2FGwhiZGi+ef0bSKkqOTdF17tV+mB
	95GV04Rv1/7brcst48in6qGI0zfN1gOpB6BfFJ+ZR9AN8sh6Nf3it7E5CkxcvMdV4fdrsC8E0gU
	8pJ6A/+JqQXeCTCVU/A0dYIZdxDM4c9wbZCjprTUXeDKzDN/kd2L4ldvPqUnQbogUHR/qWFbl/2
	lwNCtjPTTOhtdqhOBJ0waSNJKcQfOErCDezaak2GOM1pqDnxgxvsvQhQ6hG/wpaWm9JGHounZd0
	uMiGeR7vT9D7zDseuKBoQTGRHDSz1OHUv9VQ4+I/
X-Received: by 2002:a17:90b:2cd0:b0:3ac:77c8:ac29 with SMTP id 98e67ed59e1d1-3adea89910fmr7468966a91.15.1793117020581;
        Tue, 27 Oct 2026 09:03:40 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae406519fesm4273776a91.12.2026.10.27.09.03.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:03:39 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 01/18] mm/swap: remove unused parameter for reading swap header
Date: Wed, 28 Oct 2026 00:03:17 +0800
Message-ID: <50b9084b4845d8a93bba7cecd1d65e13808e012f.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 002A31C000A
X-Stat-Signature: 3sotphjsoj7nabkmxpcnuokkhn5yt74c
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793117021-312442
X-HE-Meta: U2FsdGVkX1/KAz3Y1/lzHESzeM1N77UyCuXR4pOPRSCL1n8MXdpRF0psgKqucdNHOWusVNujHAAzO8DCMwqargnRXbrvPCD73x/Sdznw79ydFGdrNRMuaFljGumdzPPgPbC9tNSBiYjLIgmeB0x2O0B1Elc2Hn1LiDRJpvwkSu1RIf61eGGSrrdfoAcI2YhRzRvzDukrCqUoYplyT6yXqlYWZRQRoKj3Qwd3h1oeDwzsD8xBqSESHKwaySpcTVXLI2DU71aGqiju7YDOGFS1N5NAe1jJzE082Gp/51Ys6mU7Lqtn1KHY2A+GHz36MmB5wcrchKwbLIpE7unPXT+Uq/DDH8ev2/gQHKSd9FW58LdsQgmqWI3zIwlsH2KNvQn6SrawjObtzP1c9Koxu2BLRSdYoN0WYSf62+0ABpcMZxRUQj0nykNSifevb/ZJAqZGvHE6t905mAy4o3jdtirftftk8Jk9HB3DMH9KStHDzIk3SM2rjAAjyQokzpcxN0fvCFMrFvswqseukDHj7DHkOZvW2W2Q4a0gjW+QiGrgeU5C6TRi1tmJXC62vjfqUzFsHiXM1mHrYLJVuEVfYjn2d8OrUzK24wsI5K8XUKby+Lh10YImj8PtH+XViG/uoZKYwWcmicLIXFy88TCWclnk8pmGTO/D8Q+sj9M6O9VfJqNPcD3Dfc+MoRXdru3g1BcL6UVPIpecmQxiEUfQrcmRo98AjesQ9nd/dQm688CW1SGgDj9tTIu3HTZW8gOjYZfSVSUubb1CwJ9pbz6yoEK/sL0isR9F++WMjG8qSkAuzs870jOrCKaYMRnFNQVF9abenacWit+Ir10CsVZWYtdpS36Lr09X0jvVgKJpjRjlnjh8vVYpj+RloLKf3uvdKESAM9ToNqRytYraiogNSaRjFc82rORCV7JubzDZV7VtUoLqfkdDuDIIIDAgW7jgOTMfGixX5ZeDMeIQRF5nq0v
 QGBlvRB8
 LrhkeG6VARNcdM1l3CuEDEr73LSWgK5kNmKmYI4QR413oZTXpFkFHQcn/n5j2nlLQSoaWs/W6Ms/Hq1y+2C//VKFDOqJ9i+xB7vedh2GB1JVBfHq8uG0zGhQbqVCxXHrmYleMoSB08uqP3YyNK7WHfYDwFmnf2JDYVAso1MuDUt21isb1ocQ27BPqdqsOeSVNCHMQQ14mW3Y+I3o0OtXX5RSCvAnUFI3FMDNCzQzudpjr05CQ+HN+AVfCEKDIt2oeyg7n9kq0tIsjsIMVaBDtj5j41J94oZtHxMTtSGBvHF6ltlJcgMS88lvnY0SJ0c2xZxrvBI8J5NRn6p7zBQmzBvIB4fv/gCtihxoxXnsTNn8VAphD1IV4FQ7QjnvlivcP1D92HYMZbR3J4ni1sV3+IhtXUzp7tvriI5EdsSZDXRFdrt5ML4kpdaMjsYhkrvbkcwV0n7IXaLx4CAY7ed6n2EN7j6aKro0Pydjf8xsOPcihWq1vRRZMQuUyxHmWH8k+9T3E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

No feature change, just a minor cleanup.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c3288910b3e3..7acb33cd8b71 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3568,9 +3568,8 @@ __weak unsigned long arch_max_swapfile_size(void)
 	return generic_max_swapfile_size();
 }
 
-static unsigned long read_swap_header(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					struct inode *inode)
+static unsigned long read_swap_header(union swap_header *swap_header,
+				      struct inode *inode)
 {
 	int i;
 	unsigned long maxpages;
@@ -3801,7 +3800,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
+	maxpages = read_swap_header(swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;

