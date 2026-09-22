Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0205C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BC36B008C; Tue, 22 Sep 2026 19:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E7D6B0092; Tue, 22 Sep 2026 19:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34106B0093; Tue, 22 Sep 2026 19:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C35E36B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48F8C1C302D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:40 +0000 (UTC)
X-FDA: 85243065600.20.711DA7C
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89F76C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XBhJep9n;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cv67mS8beABpbmQAZ394RKqHc9TebilH66SXRMDKuYM=;
	b=jl262DcsBnNFLlAB4Q99qfSClD6KPfDqCEKAYfkWWu8wFYvITgLrsEb6hwwM+i0biRV2iu
	K2m6nBvDgkFvX9zFihlxpAaU/ChAY6WgGVLD7kpEYnYVxcw6saGRe81bFsV3mRwWLl0GZe
	B4cHBhbLIpWZ11alFlyV1sRLLWmGBZs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XBhJep9n;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121518;
	b=BvgPxvWQaXGqjXy1ZZ54TliUB6OZKAadOoQUmPzp7V/GTjdeOKHy2xM1Ql7ctv7+w5gMN4
	r18lPufpGFiFN3dydDzgAZNSzkagTZEiXZa0XofQJwoQzG1Lgz5vNkpi1ZWzGDQspMnAuF
	pm1ztfDJZ7M4x6XmNsm0AWOpTg80/5k=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb76ec395so4199231cf.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121518; x=1790726318; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cv67mS8beABpbmQAZ394RKqHc9TebilH66SXRMDKuYM=;
        b=XBhJep9nkCfxe2go4xC0e+mChnY4ELOPZypHhZeF470tUCi0MBppLRjZenHvpZH2XT
         tubnimogNu0GWvcMhjYsCfkuoDuaRIsvwvdxO50T5NfdeJuMdQ2+jNGhNsosdSenCsao
         WTkTJ9mhduGkOBS2B3/qbSLzExSgXMUlRCu6J80OZ8Gqua8mlYHtE3joFmSwOT+N+GJm
         v66TaucpIe9oRFUrF0U7MSoLmKNg1283LocSB4VlyKU6B7NhR4LnF0YCz7RYXOsUKbPy
         peKdqS1nG46QsMaGnEX0/K8ZRKPCViuWVLQq5AtCUYus/UuZwSXTJF/ZnrWcydLCGbH9
         YSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121518; x=1790726318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cv67mS8beABpbmQAZ394RKqHc9TebilH66SXRMDKuYM=;
        b=QtEncynATFI8eNR4GYVVjUPfRXqrFdeUoV0B9pS89HVIrAfNeT9ucBAatsN3CzD2IO
         2ViWdp2BQ8RBVUnnepSVdGVQQPqlNX0UoozDJboNmdGy+Q0STpsFOd3/bvV36Sh6Aq38
         aUPddFl7DSpkpnJcPyoKnLZlkrDltrHXWojkgvIkGeg3AOTUUPQqVsGbVxGYAdp0vQtz
         zXg76EALJyraEXyarrYzyQiDLPZq8oSNcnsbMnO3c15unRUpVbY7BPL5/TgsBoywnBUm
         VSxl/GigApgWdyxCuz1ZNALNLm/Bm8541LAuWIrrPzTa94r8Ap4mWTHmDXyO8Ttv+CfF
         rV/A==
X-Gm-Message-State: AFuF++nJ9mIkwwmXYOsGPwDaWGTtVFaduryCrMRicxXwueChDNgz10L2
	wpY+wmNMrOIEX7kqoMm4Pe00Q5tVabL7Nk3rCZpjHNahp8RA3rg5NXNythZR4RHXLele5kIQlpI
	jCvAfPlA=
X-Gm-Gg: AYBFou2vEnP+ezDpdrmnEoL+U16or1dNJPnL9HOEJ6YkUNtC+HJRzahTLMF5R9QDMyK
	LELkSwrdfWthdfOD8BPRrnLopI1UnpeRtGQjpu4u0mqwnZdMr/ufdX4kYc6h4qhFgFPhaGpsRR3
	NBL8gNvMllaxrkeNjtIVsC7mscoU3veTMh/s3pv+Tu3PAgz5F0XExhdJWkYa8NNWruFGYHSHrD5
	OvW6dkVBZfCVc0jzh3Cm28cNUInMY0sJ9n/11cv0O4fh+sWRsZ6UTsZ3qpKPMbOd6KX2chDwVaI
	cLv27IL9UK1zuoIUj2grEwnoE7WCB0Y7/vucf6QBLMZPE8wM8TnG/CsAXuDsNBJ3Gd4937XL8kI
	M9o5DnVtNCWMqKZ5TjBYZiAqxvt1chhWCXH1U1NE2GGnhNGv22VLbLPyVG2NZHlsA0ExlDey7LW
	zi5KChroNBmDlxy5vUDb+xch9Xd9igFBrS+psae03D72ZO7iuv58QofH4h/7uhpysYT17K/SIjR
	/0A73PxHAXPSzUPL9dk+6lMFet4BKI1iGDrpwPxmF5J1dcbVbpqPKQcaTij
X-Received: by 2002:a05:622a:6101:b0:532:b08b:45cd with SMTP id d75a77b69052e-532eacd610fmr16957421cf.31.1790121517717;
        Tue, 22 Sep 2026 16:58:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:36 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 02/10] mm/madvise: name the shared LRU PMD callback
Date: Tue, 22 Sep 2026 19:58:22 -0400
Message-ID: <20260922235830.2350770-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4h9cwf8mowknke6wqt4fpmy7pe4765kk
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89F76C0002
X-HE-Tag: 1790121518-116266
X-HE-Meta: U2FsdGVkX185gpfk1sW449YhnflUTChiWqV1ZpfevYvkmgLndkdoZXUCTCzqesKNTIRWdUTeyhhL3OqAKpKfn3Er900RKYKuolnW2Va8qjmhnG8AlMTypIjrlbmW2y8cofjFIX0Q3Mhq3kmYTjuLRHLuU8qbY9nyAU1r39+fvWlqu2RcWMqzoubTuCp9leVOsQo1TzuIaBhK4Kdh6wlx3QQwptc+hO8eDZLK26fSL8DAB6KTqMsbst1qtISDiO5NMzhx5VUMWdpqjOdumk8BGMpXw27ccVgzlKmyJ33h2fforapTN47LkmxDV+fTlbS04cI0Tg5S0uNd2luh2bk4W/P3pIPcl7Lw5EJ8CLSoco2Pon/D9vLBgG4gqCCrNElGXf2+ij/Fz0PFpKYA7U/+9vaJmJ+KB4BsSIVwTdjVwXuYcy6q5u9zPm3evG0tcoUmvr54fJFHd+YtS+hUp8xnDmJ6f9CpVewJb84+jgd7qei8Cl4ximGH9xGPLmNQey0WijM6/6g9qbBno7BNrHTFVvmD2+X/iMV+X1IqVKVTcHWKF9hEtkATcAx1koijwQpiwUEN+t+a4Jj1a8r1Uzac37PrB8kiAmWfb8chrY5RROpZa2mYEAnTNJ5Mv5hDW/nr2OhREV6emJ6uU0Bo0FpMVbZ2pEHY3NBGg3BecJ4OCuupnlG77k+mM15TmWO8rjVEpSQvsM/YNzs4WLPFxgwJ0vJuddxDVxtRw288qw5d87ZpGN11ZyFuTHoWfMeihL68kis8wnWzM8qb+VMgl++joWeb5JjZcCSYCl5U/zPHUMiOE6o8LqZKy5M4cbHhYveGpinhXFIM3kJFXq8BUvKJzDDC2vYie8UOn0XWshzqPbyIoZ1hoJyl3Chjjzo6ph/JeAVY+VCNJk9QHiO8fFMM8n5aFW2bgXq1dnd17o9zHHIwEwoJ9k2GffPZKdCuiVFYcqUY8ETxo2KmF8TgXqz
 9UdvLvyj
 dczw8rqg8m+OfkmQAJsXHlr0FtUVlAwCpSNoG5eM0RjzNkVnCtWIJ2TM404Mtn2pH+pDnvGMgvQlnZ7i5z9t8xtmHMmWc0A5JglA+G6H80AEcvFrUoSTXj7nER9okzRpf2G3kK0zEGahLD8ySAdi+puiIne3+vLQIhGahFcySwUXrbcbNQzyRxmskN+GjP7MBeq9b6o1vP7FuFpg2o1uKSB9fOdQK66FCfsWqk1ArSKf2xJGNFDLLe2D2gEYm+YfUa0fcvwcw6cnnmVVyTEyMSOenIj2VM3tz7mIHVWLnFjps0lE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MADV_COLD and MADV_PAGEOUT page-walk callback is named after its PTE
implementation even though it is registered as a PMD callback and serves
both LRU operations.

Rename it to madvise_lru_pmd_entry() before separating the PMD and PTE
paths.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 00b1be655a8b5..83d54ab385da8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -361,9 +361,8 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
-static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
-				unsigned long addr, unsigned long end,
-				struct mm_walk *walk)
+static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
 {
 	struct madvise_walk_private *private = walk->private;
 	struct mmu_gather *tlb = private->tlb;
@@ -581,7 +580,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 }
 
 static const struct mm_walk_ops cold_walk_ops = {
-	.pmd_entry = madvise_cold_or_pageout_pte_range,
+	.pmd_entry = madvise_lru_pmd_entry,
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-- 
2.53.0-Meta


