Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5219FD5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F6A6B008A; Tue, 16 Dec 2025 03:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DB56B008C; Tue, 16 Dec 2025 03:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489BB6B0092; Tue, 16 Dec 2025 03:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9396B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:00:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E171B13B283
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:03 +0000 (UTC)
X-FDA: 84224585886.08.A65E1F1
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1EE42C0004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W/LOt5VP";
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=slnlPNW7ZFiweGfosqsIY25zUAdDsINOIoXDoR6h3ys=;
	b=HCvhkcmgQqfNH3qbpVbMmJx0qhxs7Vo1bCquL5RWjg63xdIq1WDjv6U8eh9rTfYpM3ifVV
	IkOqawDAwheh+CgrMvn1+bG1yQIZFiRBM0w3+zcD3qajRA7ENGWKsSslk2zK/qTRxNr8iK
	T6UkfNc7K0BV6HJRZppP8dXYnsJKAWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872002; a=rsa-sha256;
	cv=none;
	b=fiIpvlelNrdk14CBN8VruSTk9dkWsB+nl0IZx5oC+Wa6Ea0+DPftWXM+Du8nvEJeNzM4Do
	OPkFEq77Rx5BMZeFMKWBF0MoVx0YrNJr5vU2I4QjRIOcpE/Q/2PM6atmpgYeLGIkqRc0OL
	SWe8tx/U7yGCmA+j0qKz7AKhveUgk7o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W/LOt5VP";
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7355f6ef12so827555766b.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765872001; x=1766476801; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=slnlPNW7ZFiweGfosqsIY25zUAdDsINOIoXDoR6h3ys=;
        b=W/LOt5VPX2lsCNudJ1CY/Ms9bFMzdrvvpo86kEP+/QtaQizGTViEQ9mPnygAzyU2Kx
         3rhlg1ba7sPHJcp6egn2Y4JSbs98awTieeQaOfhLcmqo4lLVIFUhXn2FG87nZDYlz75o
         EoHA/6PyGhQeJ3Xi0hpcxmjawog38hRJAs/C05ZWINqwmIE/G6FD9dsjKvF5Q3L0vpa5
         eTFv9jXhIqyCqhQ2I+9UR3UAq3MN1y+2/E5iFIJ2mMLihFoO5NQNkargo0XEKowfq3xf
         48rfgKrMjULtWhvZa9XUGLahi1G87FnCV0r5TasfQw31cHWwEv6DLDJLGY9XTdxbx4Ji
         DZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765872001; x=1766476801;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=slnlPNW7ZFiweGfosqsIY25zUAdDsINOIoXDoR6h3ys=;
        b=TdbgcFTMr9tzY6c5VhKmks3hyQGTJiTON4HW6LCW1AyFNF44BnlSAR15tCKJm8lDIr
         +UGBCR3IGNQ/GXl4lam9o3Kt48EVuPzIV+T4ge2mZF8szIIVjEsRYf2pJkcBkPQgGfEq
         a5DWxqt9JB9wc+dF/A5T9IXc5VL3D1ix2dgjovAT/by7piwGVGb1f0rE1tlQld/pFDVV
         v5k7CsK0EBG4shLkuh11oFov/e1XbzmcqvYVilAfdadGmHPPgvgqtoJoijN2bw6NuXK9
         8cCQDZrripcQfcnGOUXL4jbYDRXILCmmwdGrCE4/vu+NVzhmkBgpnTDkwNkRffExqtaD
         5k3A==
X-Gm-Message-State: AOJu0YwNIAvHF/GAY/eEyYwmG9R/wKZHz+so0D0Ye+nIzbrxGIW9b8te
	3LXz3MYk2FrsUaYSwRyXG8Irnw4wYrhFQKyhnzN4ZiaDjgS/y6mi34s0m2M//lVQ
X-Gm-Gg: AY/fxX5B5pDk9pqcYoM5ErZwjw7vy497FYnVemmDDI8j+tnLGzUSf1YMiFXbqJR1h6S
	f+0YVhylt+v5zULO3ncpTngziy0y3dIRXlatTvi6K+0FKDOEi+Kh30F7s5a0SPVwUlPi5gxnxjW
	HStug2CYFwnNvkHdZMNR+dHuWw4AxhyVz9fwptcM6t3K2Mood2MqmEWoEsfmVghMJKMdTvandSd
	s9ghA0C6wxUEcghCV1myZ2DGcDlOAUI/cfoj9WEK5CtAo32OQL1MKYwHjgQ5hnDBMis2F8FY3SO
	GsbVybdG0BmKiO50Fgm4SHe7+7MRIn93Ll2jCMiDlcyYReEpVaQOU7b6vi3sJIAcSX0K25JFbr3
	AMcqGY4pu11jUmjiTC7+aIj4ZHH8ciUXCAmSLglkUrHB2XVeB6C0Ysq/DCDfZ5Iw8DzF0woQZBM
	sbR593a5wXcN8lYZRU7geS
X-Google-Smtp-Source: AGHT+IHU57mz/ghERfddEz7QcVoq8G5fqRAm19+0sWt2mfD39HtYkFu3YCwDfCuzptpTedKGWm9wfA==
X-Received: by 2002:a17:907:7ea5:b0:b4a:d0cf:873f with SMTP id a640c23a62f3a-b7d238ee6d3mr1425344866b.2.1765872000453;
        Tue, 16 Dec 2025 00:00:00 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa29bea0sm1624522666b.8.2025.12.16.00.00.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Dec 2025 00:00:00 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	hanchuanhua@oppo.com,
	v-songbaohua@oppo.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/2] mm: avoid unnecessary PTE table lock during initial swap folio scan
Date: Tue, 16 Dec 2025 07:59:43 +0000
Message-Id: <20251216075943.29593-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251216075943.29593-1-richard.weiyang@gmail.com>
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
X-Stat-Signature: iyp9npfnyam3xybsz4xafab6jb9qbgex
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EE42C0004
X-Rspam-User: 
X-HE-Tag: 1765872001-764958
X-HE-Meta: U2FsdGVkX18SeBQabw5bb4hrcslwYEPxCqbRBw9m9V0/gcj8HknDCdHbtGP2FAPJATFyiZJYhOuHnASUBhVQE+5mghR2C7YVpggh9NtF2+lvR02jE56YsIW+l8gFH/DlJCNi6vZ2n1fPQgKiJOE1dCElimuQiQ4Wu7vpVhIA1yfWb8v8C3noFv1DO28K3Vskpo6WWtdA5KL0jq6uvhuLMOkJmejeBAFLWcOUBGT0yN2KfS/ShwynKSm2jMI2kROezsB9Z+Yk8c7RJeJIFdRtHJs/QG+/2zOFvo8n58HnrAdiSkw9g1PkQfFQd8sa5+WovEyvsAUrVbj82RoIsV4xR3C5L4KiI60yrlhwEdaSa+vxpRg0b5kIw8zaNqmtMU1hb/RpV7LuS64aCApnYNRgaeE/gOiFuqpfFTxgnA/Fxh0pvStE8+tLoPdZg152togvQRU7l6CwumFeol06k7Gk0wlFim42Ut/fRWJQn+haTOi23a1D62/f7uC3Mrdzh/3fUjJzSLGbOh85HuvoR/ttIPbB8HqhWcnm6mdpnAcyQAfKa6EccTWxNfztDwqGUXMNKdUWvWtBlBDsl9kAqOcMckp1f1leRnzgPEb6w44mTNCCaq/6lez4JdXC8uLEi4ZNHYPzQj3+nfr3OQq/dmf7avONNhpyvEdFDUOxR7vhi/vithZTPXjZCi9MklPIC6mV1iZiiUZsN5Fa9njElQs1tZHxMFmVMqnGVFTIay7zndOy+g/PL31VmhfTLOAuZjph2hmZ6lSoHyb0c9G7L9i3WDQqAer3RyNIYsCfjdKq7tjdgIK1EGLNQYMIBQQF8PuEXSsH/pEmAjty0CHn2KCZhenfJDJ5btC75XDqepWiY8ui8DEjSx41esX61+bYnfRRDbGJlQCHPE48GoVjRnBGAJp+6KdhAxIEQAemdkeZuHkMbQQf/jZvL3UJI4l8zM51aMXq6cY95XIUB6MV7XM
 6k77Rc9g
 YQ8tQ+yYm1qJh8vC5ZfQTH6c6OGCXt713l1tbrVX2hdnTwkIQ2DTpHZYQ9D78qCAkani+RNj9NtjEUv4gXSQDHBLpXIjDjiMPWG5V06xyCMVbmam6z/EQDeUwfC31kPpEqexeiU5x6ASYxkWoLFj268Lkr/9MbTxtUlTLrDW9kHq9aRTrcK3fm3jIZ6rYl80lhPnxPzrU38DB9DdO9nuyow8fNrLo1V+ecFAlYqGscb/7rbVM9tSuHYZMpHeUBCQ4uuGAQoAuzIZzcJxA2bO9Ndbgpr9tvskKlOSktMLA5TDIRlRVsdOOSnPDQ+XS0iHclwg+cf+tlw+O39lrWY4JPFVOOXRN19B5IYa1i5JqwUULvCOQdD16pv69YJTwJI38TNnfGJh7JFSUj+HdZqdLKZffKI98FmL8fY1FclWUHRjmEb/Buei0tUF8hhOR3yRskPiAHgQayJhsqATyMltiY9FGcsfvTR0el0N3Uh1bWCqWQ12+i9xa7XFN0P2bklYAuPoLcsBS20ieT+stgqiYLpfLJlaQl3eHdrlTbmG92OSq54swWrkTLUoxtTEDLRre077gM5XGoyPp8ArtsAwxXhaHZkXc9DAGJSxeJy3a4D1OamktAxZzYw83Vg8V5iqjIpAl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_swap_folio() function performs an initial scan of the PTE
table solely to determine the potential size (order) of the folio
content that needs to be swapped in.

Locking the PTE table during this initial read is unnecessary for two
reasons:

  * We are not writing to the PTE table at this stage.

  * The code will re-check and lock the table again immediately before
    any actual modification is attempted.

This commit refactors the initial scan to map the PTE table without
acquiring the lock. This reduces contention and overhead, improving
performance of the swap-in path.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Barry Song <v-songbaohua@oppo.com>
---
 mm/memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1b8ef4f0ea60..f8d6adfa83d7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4529,7 +4529,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	struct folio *folio;
 	unsigned long addr;
 	softleaf_t entry;
-	spinlock_t *ptl;
 	pte_t *pte;
 	gfp_t gfp;
 	int order;
@@ -4563,8 +4562,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	if (!orders)
 		goto fallback;
 
-	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
-				  vmf->address & PMD_MASK, &ptl);
+	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
 	if (unlikely(!pte))
 		return ERR_PTR(-EAGAIN);
 
@@ -4580,7 +4578,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 		order = next_order(&orders, order);
 	}
 
-	pte_unmap_unlock(pte, ptl);
+	pte_unmap(pte);
 
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
-- 
2.34.1


