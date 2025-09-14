Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B56CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B408E000A; Sun, 14 Sep 2025 10:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02C88E0009; Sun, 14 Sep 2025 10:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A186A8E000A; Sun, 14 Sep 2025 10:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD6E8E0009
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:38:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35DEC58860
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:31 +0000 (UTC)
X-FDA: 83888111622.06.D5F26E1
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E32FC0008
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757860709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l2AnnhYLx0XSVDCP/fVtCwfPUWPDTutSyX5MbFNBOkk=;
	b=49ZhSOq3iEywVW+BZIvdsgfAxX5R2ZgBWQQVuHP07Y6Fiaa7rGpCHCWG0YZm4yUQlEWWcp
	h+0G0uSyGf1pf/tZ3BR7/dyyxJXj9SgN2/EJgjYkLz7abipluywbwmgXCbO13OoyBKI/hi
	rZ3QVixIvMnzc0ZzN71hR026y/3RcDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757860709; a=rsa-sha256;
	cv=none;
	b=ItBczPh/sBkvnngUHCaNiQ/P2RDQ0JY7t9Ywk5qkwHp9l5zVhbNvk0Oi23r8TbtnVA0Isz
	zu2boJP1+y2hfqsemOa26vFPypUhwZq4M66OdyD9RpIFx5dIlEHBjhk6c0cCtf9zRuOnPP
	yF7Jf7CLdNhy0BJBLNHQQZdn7eoOO8o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b54ad9aaf4bso1834826a12.1
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757860708; x=1758465508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2AnnhYLx0XSVDCP/fVtCwfPUWPDTutSyX5MbFNBOkk=;
        b=Uu2HmDuDlgLnJlr9sqZnxsgZ3qbVTtOlDQGkFcx0F+cDrb3INb8kQUy8D7h/61/Z0U
         gEgVQDWitCmxc+neHaBZJuIYv4kzvcF73sIp4cKZv5AHnwqry4HY5oFjUhwSpR7gTA3X
         11s4fUbeff2EhCX+rwxIMzZx8HPNyg3CAs/FgrDMTQtYEacNmccfyhMpxqrGbHguLG33
         1dFXH3sY4OXpDy9pXSskZlOiCXt9gzb95nCpDlEfsPlUiYxS003XgY9cfvqc5Y/mshRK
         ntKAyhGLS2UN89O31yhWMnDG6IKJgtcDUS4xhHcIOhas95K938NleCUV1GbPye1v+VUb
         gPNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAsZYpa9NJeqQrI+0hJPB2MTxSPeshy73f4xT4Qv5GvIL2ubAGoBQ0t653cqe4wFx5S709WUBdew==@kvack.org
X-Gm-Message-State: AOJu0YxjIFUXPTCrSEENTIgaZwLPRd2XNSeSJPyK8MsL+PcKYDJiRcdI
	kifGyz4qASndv59E57is4sEJGVkYGf02+dNcDuXMru7Y0UQmwe/FZ5qt
X-Gm-Gg: ASbGncvnNEiB61nm6TmIcmWRMip50d2C842eAaTK1bf3qP7RUE2kVSTU/eOwj3LDssk
	7D916UH0aKpveZspXfqITA542E3pqs/UAHttBkcfmRzH0Du2vhTfouExEncT/Z1yMVhkU1Gf8t2
	kk4O3zYB2QoSZiIFX23qYZhISFsK/vLz1XlZxCJmUkoZjkyjIMNhzeGZlpzuKQnyRytSeYKVbtH
	mfyoe0fJhByzAnZd5IYLwE1WJUweiBBPzmrE2sgTDJUPxArVMrHM2RIRipiwZKwWotpv+G7MppA
	rnYz9T4V9j+ESrwDNjabCZ98yOEaCPy02TsoLS1MfslDPoXYXuYXywQ24FM636vYTC318S0Fdwm
	JvW7Mp89+eT04rvLktKy5yQ==
X-Google-Smtp-Source: AGHT+IHWR0yW8e7MCVl+UueUYkz+wRrSuXYr4ZxuaiJD4QlW4H6iqFSdA9O7vMH9cF9eM58m3+6pFQ==
X-Received: by 2002:a17:903:ace:b0:24f:dbe7:73a2 with SMTP id d9443c01a7336-25d27623c65mr118373835ad.31.1757860708231;
        Sun, 14 Sep 2025 07:38:28 -0700 (PDT)
Received: from localhost.localdomain ([2a11:3:200::10b2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b0219f9sm102571545ad.123.2025.09.14.07.38.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Sep 2025 07:38:27 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 3/3] mm/khugepaged: abort collapse scan on guard PTEs
Date: Sun, 14 Sep 2025 22:35:47 +0800
Message-ID: <20250914143547.27687-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250914143547.27687-1-lance.yang@linux.dev>
References: <20250914143547.27687-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E32FC0008
X-Stat-Signature: azmu4juimo5gjfnbtrp66mpjerj3tns8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757860709-933360
X-HE-Meta: U2FsdGVkX1/8SgiwinX7BfxAj1toc3g6nX1nLmochbW3eF0C7avI/4f6r2SXmlfbCUtnmqE3N+L9hFVKsvdDoQuwk1+929xtWxM1Ig30cFc8blDjCP6zkBlUCx9g/UEGeIVD/6+Tx3e/aD4hE4dpTnAXBSC1MVGW/70WcPV6Et1+pbvBZkwNEvtJbZ4EgcDBGLx6D+e9UscfIufi3BsEVYl5ayA0USzsz+X5s38Ct6/IEfb9KRFyeqUa5wxGdk33B6k97O/UyJiUAaw7PQuVaySC6yccmuWtYT/Wi3Q2y/PckzII9RCUrO7ogwzZJN2Oky1FhOoPwYfsPOhBk0IM6Vsora68h5EDlBcnJQaB3uphbRMgBGuu+dGjgPIFUKzaTS06dModV7R/nBWvWwg/tehwyQi5FQf3sJR9SAU8CFQsTw0gf+lgZty2vpJi5T/qJ2yCxvVFzMfo7tL6/5gdAJtVu9aFOelWET1ihXwGYo/fLd9gMOMFEEgzTtA2jpL3Hr3SxzRF9LHoYEDycWRo+UxYA7ynoSHsC91R1bW+4a3T6s0mMfhJLNC+3Sueplj9i0tn1FZvo2xim1fw0urFTS6z4cNtlUrTvvkWqEPIxoMdO/huu7OZ+iUULYKuowingXXNc7CpFpO15Y5IjhAsq527Jzd5k+msXvS95ZrGJBQBGtKdIVz/ot/YCu0Px1+G0wxMPbSCISg958SfrwqJxgBbgaxsGdwcHJKzb4LtJPcd32Cy6YBrJzw3g3zz8wgS8rIrkY8SROIZDevrkM3ssSjLFIParBB6U5kSfwgUpCkOUMNv5M9i0tCthPAGG6xHKgSHhLLHuRm6/FUm8n9pw+/QvIf6gl58jI1TzHjIrcKTvox/VWzi2rMm1FRdtwSRKU1UmB/dVonwTsyhPtEvp6jYOS1t8jBjSDRXu9qyNvLBZqRVZ3zgvLeGqFGbKXiDo9LE/dx2HKBT+brS2EN
 47KYBdxF
 QiWYLF6XPjiVo3O0ih/urt1YlUN8biq5NzQXw4SrGYnj2uxyjZvz3d0EzyEQzaInuHLGURJCpJDkOtLWXWZNMxnyFoVAgoiyBE5uny0trJwblywXNOM4J9NAXRE2ObGvTYRKxjLpDU1NwEo0XgH4puVixAgnLWH0c2uX+NY/d9z0UgoXRQGBBMESB133evdcJHYtUxB6Yfg/nU48/SkAlsl4nHszECAocwjclJko/KqYli2FeJ2xVs/TKrdZyr51G03SLmj/AzqJTyNvtJzhBG9LWgS5N2G79paENiOTfbUZR/tTDgQYOxO8df5vfNc+KqdkZV6TKurYihDMs4E3jk1xlmQ0/BjR7q1MUNhDsZNK2hrpKqHGd+gRScsNDj3V9p3nB/+zc/yaTNMEIgOwFd+KKPW9Q3OTzPfR2RbMmtwMuwtKFMDdHjieWZhtsbzBS0PzJ11Yd17jh6rkSiC/+HI5am7fuzXN8J2xWueccMxf6QuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Guard PTE markers are installed via MADV_GUARD_INSTALL to create
lightweight guard regions.

Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
encountering such a range.

MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
the special marker in __collapse_huge_page_swapin().

hpage_collapse_scan_pmd()
 `- collapse_huge_page()
     `- __collapse_huge_page_swapin() -> fails!

khugepaged's behavior is slightly different due to its max_ptes_swap limit
(default 64). It won't fail as deep, but it will still needlessly scan up
to 64 swap entries before bailing out.

IMHO, we can and should detect this much earlier ;)

This patch adds a check directly inside the PTE scan loop. If a guard
marker is found, the scan is aborted immediately with a new SCAN_PTE_GUARD
status, avoiding wasted work.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e54f99bb0b57..910a6f2ec8a9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -59,6 +59,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PTE_GUARD,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1317,6 +1318,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
+				/*
+				 * Guard PTE markers are installed by
+				 * MADV_GUARD_INSTALL. Any collapse path must
+				 * not touch them, so abort the scan immediately
+				 * if one is found.
+				 */
+				if (is_guard_pte_marker(pteval)) {
+					result = SCAN_PTE_GUARD;
+					goto out_unmap;
+				}
 				continue;
 			} else {
 				result = SCAN_EXCEED_SWAP_PTE;
@@ -2860,6 +2871,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PAGE_COMPOUND:
 		case SCAN_PAGE_LRU:
 		case SCAN_DEL_PAGE_LRU:
+		case SCAN_PTE_GUARD:
 			last_fail = result;
 			break;
 		default:
-- 
2.49.0


