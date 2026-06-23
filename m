Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B12CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631BD6B0088; Tue, 23 Jun 2026 09:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2506B008A; Tue, 23 Jun 2026 09:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2816B008C; Tue, 23 Jun 2026 09:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19DE16B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:29:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40DBF167114
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:29:42 +0000 (UTC)
X-FDA: 84911259804.13.39393EF
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 780F0180003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:29:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1Dm0Lga;
	spf=pass (imf06.hostedemail.com: domain of suhua.tanke@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782221380;
	b=q+jZ5gCcjjia1w6O81lJA5v1NNIUtv/Tbr07mKc2pDUdIABbyoJuekEeo6zqxnUMKrlKXy
	bXe08PjRdObp6So0+XPHGIdITLoleG3/37K+aUsRNsHUmipCG+wgS+eFW3GgGltI7yddTW
	Yd2+/+7bjqFd33d8UPN0k92H0lOqkdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782221380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gnpqyD+GH8UW1M33mJyTVneTSpfc6DkZY6inEYDszS8=;
	b=Hp1kTvjMI4ZDVSYWrhPFFho1RM1zAf2tPSswqP0N1efpsQeqhhudnpwkef/2/tskBizwjI
	5ZCWopPwSxLx+qwLc0D+BZ5joyrE2RVx4cFNwZ2atVuvCNj1P0YGQpgb5FFilr4AFc1rFn
	l/qYXym4yggwvQNU3lbZcq20u56aMHg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K1Dm0Lga;
	spf=pass (imf06.hostedemail.com: domain of suhua.tanke@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6a11c68ae41so149564eaf.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782221379; x=1782826179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gnpqyD+GH8UW1M33mJyTVneTSpfc6DkZY6inEYDszS8=;
        b=K1Dm0Lga6byA/QZX064hYjGs5E9iP60JX/u/2fAMAqRXyVRtdogklxCbJxqvGFrIDg
         s1hfozSK+s3XXlScQ43ylr07kuIGVoUiKWZgmywO6bjyzp3rONzcH7cLo2B4usmN6eI4
         nz5yBAmaJCq7fITPChiEl9wBNGMNVAK5iS75xuDBUEhOpht6qWYSCqmcQuD5MpQu5S+u
         0kqyYu+NlYH+6Gtirj8qgdYss9QKubJkCpIVCj2VqAY/Jzieyn7wPBQfZXPgrxGUzRA8
         PwRbdUuJvrRI8xEGFo45hwsj3TqUhLHTv3pirtYLiZNWQX60dtf4LxnouHZn7nUB4ZRA
         2m2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782221379; x=1782826179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnpqyD+GH8UW1M33mJyTVneTSpfc6DkZY6inEYDszS8=;
        b=fiir1zuSDB2kbr4Wu+kDsuuNiZbUaZ68481+7ukgvohdaMnKQ/VyLhlivbb/oL3/KW
         Q5vfX2t/x1jx3elpjjEs9p8M+mMM96XfoRtsU3elOXM2D9HrL/jyKmnIzCoa/LnGmxkd
         OuvgiCcmDp2cFMbwDxv0Lmzax9zAogIb2k/uJqmtqJeYTppivCFuaqOHuG7VVFV7eDDP
         fDLT0bHvtjTBQ6bxMLo8OQa8ekoMgQh9x7z6PS/JvAX8fwQxSn1CB406nK+50cOmgQzR
         MbVKs6v3RILuyfI83lEVuIz7RaqOmSXjUIdEE74LldrnaaGhFVpErWegpLZp/+nxwl2R
         T43w==
X-Gm-Message-State: AOJu0YywseAT6Guhvm0YX/pbtBTUno20L/Vv1hGtnZxBsJg/w3V2kXWJ
	eqhir+qHiVEx8L+o6d+9X/xDKVoWMHyYnGx3oQzTKD4HRkMVXSBtWh4I
X-Gm-Gg: AfdE7ckbCIq7LhO4rsg2m/e43S9znLeYa8OcOUqLAbtuW3vMU9utv4uqAppJ1msPQB+
	6vZpt4S0h8AIekL/6CM1Aw5FfB9lI1UnmyE7zMLfDb9ZKLDWLnU9tdC7zsvMhDDkRDGVNo1CL+r
	XRlogAmde/P3twzp4WTT+m/V+j1z6ARBeVTuKE6kjYPjpXBD3HQWgUAtq53HMv/IK8EgxyrBvwi
	vDuD9u4kZFwjeS6192fM2MvVI/0Ayg53mLUVMBnhO1JpusvX63hK9r3aBNNT0ko/cqlNnfzPvUY
	V0IeZqjFqNaKnoXcmEn/Wj1fJC+gPXIj+dra7ruIfq7fXwAy0/aPmHNiNcKmGfpKHkxoDPqLKeg
	IUC8GcjfD4xu7go/Gue/wY8+HR/4VKcUcs51FiXQHH8GkW5DOScqgARU9rJWaUeQa9EmeWt7ZRh
	zpNip/6Id2rZJltrCVVoXTj7t2FK6nJe84KCd7w0KCQmtZ8rfhMEZuj1ubwPqLyl0ohlRP
X-Received: by 2002:a05:6820:1613:b0:6a1:158a:6e7d with SMTP id 006d021491bc7-6a115ed7a9amr1541131eaf.0.1782221379312;
        Tue, 23 Jun 2026 06:29:39 -0700 (PDT)
Received: from suhua-virtual-machine.localdomain ([43.224.245.226])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9fae72csm7172967eaf.7.2026.06.23.06.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 06:29:38 -0700 (PDT)
From: suhua <suhua.tanke@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	suhua.tanke@gmail.com
Subject: [PATCH] mm/page_alloc: bypass watermark when PCP has pages for allocation
Date: Tue, 23 Jun 2026 21:29:17 +0800
Message-Id: <20260623132917.104234-1-suhua.tanke@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 780F0180003
X-Rspam-User: 
X-Stat-Signature: a4ame9yytsb7ufuhfuy6t6jthfy9w47g
X-HE-Tag: 1782221380-38150
X-HE-Meta: U2FsdGVkX1+rFbkahTr9woP1IyAdUOFbDuABSwKeinhi06EP+KXwvwrN8i9Vz2H/IFNs/d68T8LAXebpND+iabcG9EtnAm5gkyrKTza/DKcBUNry4WfVpnU/HAooNXJdtK7XwTmJsIRA2E9TugmeFcbBIvzg7AkEEJnC6bYoGVp+DtXscMTW7DSaPQQ2XeuK4kHEymmkefpuV6700r9YE3qnCetrMKoqJBRyTIOmeFWg5rUeluEHRGTPNQn5IYwvRr254MBzqlkFlZUBXywmdkuctlo/C8POiKoI5HWjX0SFfSiHsqtGDPEdovJ2LTiStwJaB3Q2kj80s8RuTbD7pMva7/OIogKhf4nBepoghdW7Lm38qnDllbMWS9GIOTue4GI+lTwlL7Nac1cB/gZ+1/G3vmTFjDUkB32eWJ2ReE+wpvyNhHJpFmkDGUf3v7n4zWmj38U5AcI9cfVlEfPyHC1POn0ado8YKCgmHTOkp/Kp1gNA51a208wtL7Ll10bor7I4kcFiwLZh+rvsBKG6STsuA6k0pl/cxXB4gZsSvKREyI0rfbgsGETvpzcA9y+/7Bs89q8l3mXlFYBFklNxmj/ozQnU4qlvarr24AV890aXnM87Gx1eCLrPanWSWDLtMbg+1LKlFNgflO5lkeUna0k9vib3lzTzS3Eu47n6VboFEyaBaBAhe8IblWT9seIMHVYnIXLXlmj2EHKzgouYLWe4ozJ+cm9+Qr2PgBmH3crZC2R8Uu8gyLzMd5a0+iFR2qUUEBIzXdKydvtTxp8feDplSALh0KssEqEiz0sRPG5VbWGEfUoJuktQb7RVcIyr/T937HU9ibFnwUOmi+uHCR9TQmN7ww23tKHFYfkTec/A/T4r5UFHIBwF8cTfRZ/4OKwGB5ZVyY2RYvP6W3FS4cUNA44WtyqX5n6wa+nIt/WjQF4tIUoRV5UpWMib3PDMwhNBuvtbg9F+knmnSED
 KtGG8SVT
 IczDG+39oFlRPi364MsRF1vd2xhQztcLxz58hDOUP182MxKMx5YQlYz8e8Z03DoLWoz6IjfNBCX4BStKAOxWVJmP2slO0Gz3GUKmLu5VwTcKdIJVMooDcb8uowTwuNvhWX8LfCD/Tyj56SveoUdtYQnGyc9rUl0nCMfQf/Px3Rma4NvDTmjahBdmn2mYgL22NYa1gfSbne6pcpkHHB9g/kLP6LJWelgHpNo0829uhL/0MDGy/LoFgDjm1heS3J2oLogqc23gOgzl+E7BPMDcIaUZn+uhbxmjtI41yNHkH5Enm6bNbz24q2iLl8HBimOHpeyOA0xAEY6oC344L7q2YRkF5Ayj9ACxrHd7LnYTtOgpTDg3QOIB0/Eb1cPsF2ER49/StxPNzhaXTM2yPAG2wO1jRNzlXURg0n9Lm+vTULa1xQpmGv9xiReyXMwqNmIbyr3hdEgf+h4ZE4PZqHbLyMv/VsrgwIKozqK2PJdRs2blOOZqkEvVZAoyGdEMqHU2vVCHnKMwDD3xJRXxvS77SbxLwNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NR_FREE_PAGES only tracks buddy system pages, not pages cached in
per-cpu (PCP) lists. The watermark check in get_page_from_freelist()
uses zone_page_state(z, NR_FREE_PAGES), so PCP pages are invisible
to it. When the watermark check fails, the allocator falls through
to the slowpath (reclaim/compaction/OOM) even though PCP may still
have cached pages that can satisfy the allocation directly.

Add pcp_has_pages() which checks if the current CPU's PCP list has
pages for the requested order and migratetype. If so, skip the
watermark check and jump to rmqueue(), which will try PCP first via
rmqueue_pcplist(). This is more direct than draining PCP to buddy:
no page movement overhead, just a list_empty check.

Signed-off-by: suhua <suhua.tanke@gmail.com>
---
 mm/page_alloc.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..70f5d0dc2485 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3784,6 +3784,32 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
 	return alloc_flags;
 }
 
+/*
+ * Check if the current CPU's PCP list has pages for the given order and
+ * migratetype. This is useful when watermark checks fail but PCP may
+ * still have cached pages that can satisfy the allocation directly.
+ */
+static bool pcp_has_pages(struct zone *zone, unsigned int order,
+			  int migratetype)
+{
+	struct per_cpu_pages *pcp;
+	bool has_pages;
+	int pindex;
+
+	if (!pcp_allowed_order(order))
+		return false;
+
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	if (!pcp)
+		return false;
+
+	pindex = order_to_pindex(migratetype, order);
+	has_pages = !list_empty(&pcp->lists[pindex]);
+	pcp_spin_unlock(pcp);
+
+	return has_pages;
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3912,6 +3938,16 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 				if (_deferred_grow_zone(zone, order))
 					goto try_this_zone;
 			}
+
+			/*
+			 * NR_FREE_PAGES does not account for PCP pages.
+			 * If PCP has cached pages for this order and
+			 * migratetype, skip watermark and let rmqueue
+			 * allocate directly from PCP.
+			 */
+			if (pcp_has_pages(zone, order, ac->migratetype))
+				goto try_this_zone;
+
 			/* Checked here to keep the fast path fast */
 			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
-- 
2.34.1


