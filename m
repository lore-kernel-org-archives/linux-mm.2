Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C96CA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 00:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E2C6B008A; Sat, 10 Oct 2026 20:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8F26B008C; Sat, 10 Oct 2026 20:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905D66B0092; Sat, 10 Oct 2026 20:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637E16B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:31:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4177405AF
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:31:10 +0000 (UTC)
X-FDA: 85308465900.17.8E602CD
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 26A1340007
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:31:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KmeHDlsI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791678669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Texf7avohcxbJhjAidkKzynfx9gkSXyM44DuVmdFRSI=;
	b=b3LyimlMTJe0/gaqztll2PVS66Vp9oBwQONuhT3tjc2MQZPbz4cav38OLtfTn3+t5E8vNX
	0R82hOiVxDnpGHNGrMrA+j4TUYUYcGLzgT+PyFS/ivoCn/j2RvADKVIsaQR+qDJmGI7GNq
	ZUH0MGGN0zGdHIUTpLMT/n4VS/i8taA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KmeHDlsI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791678669;
	b=JummLl798ekp/PuJl94OpSTOkEkVXw2Y7kZwUHaiKLYRTo7yab2B6IBqxHE+O4VSXtF9bQ
	rUsPaDIIdzBMP6vqqx4fw+bWzNav/i+Jqorj5SuE61IBBXUdwdZs46wE+khBsW1qKpYz3p
	Iq8Ng1eZ0T0+zunagVvI7QM9brlyY0k=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-381b831d535so928148a91.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791678668; x=1792283468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Texf7avohcxbJhjAidkKzynfx9gkSXyM44DuVmdFRSI=;
        b=KmeHDlsIkW50P9YYb7XRxlwsIBvWPWC9zfUnipd1c0LJCtkYbXKhEcYgWS2jnfdnE4
         tNfGft5GU/tb+bAcnlqno1KlBRAmsKkTU23CELd6jklMCPqY+Dpims5GcbFZLrtdC49b
         olbg4PbOr6Om0MVmH17A53XVxZgo06cvMcFrbPSSOf1i9cz2hbBkPLOZuaW0vk1A0Ztr
         6ux1mekyVdhhIYFFZZQgGPQVtqLb5/RpRQUP1OXIem+nBHVUtxsMANedQQeNNsEKGXBM
         kxTDhG5hPHotzrNKmj5hjPYDmiWZ+n4OGo5QiSxJxAy3XIT8ptmXYuwxxRCyP+d1oyX5
         fLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791678668; x=1792283468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Texf7avohcxbJhjAidkKzynfx9gkSXyM44DuVmdFRSI=;
        b=BfnLvvzmbXKb3yYRniezpUaCPkD9zSr9ZH6q6UegQizbuO775vUyWv7g6W/vdmFvfw
         pyg9yYJKpY5+4jpz6hLooMrjwphiem9zQb4H8G5irzuk/NdHGFCHxC42/EsDh6YjLgT4
         icbXhNmTniW664Rgcmu45iaw9H4A6P61xmkpKmIFb3bdA9GDSRzWn90I5aeJJmd93uOK
         joD1lE2jWF3M+T6VWXuzNg6buXBybMgfh2rtCUUsbuubYVak36Qc4x/7FwDXC3ZHhXQE
         HyN+w+SgDMiql78vC/JglK47lZ2D3Khp519qJ3dekY/GfmdybQr/rs8hVZmH5rdMdJdD
         yzsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzRMx+cpZiL8FMhPfr/7NRknLnXwGQ2+0vEqycwsKRj3ey7Rosj6YmGEuPhnfwcOcHp+SBpHkVnhg==@kvack.org
X-Gm-Message-State: AFq9FYKpHMXymaSHADEQbFWSICGGaQiFh+5tBLh6t5PTOWEhpXBycQBj
	lse0nJz7FDje5EVKAoW6VMICS6FTAPZflCsqRhmiSPFfT8WHFzE/7bhv
X-Gm-Gg: AYBFou3saoxr99TtbsJcGUXlH/yLeLvyOTU9laV6qVKkv7znCPlOLtToDcNZh09TR5r
	KHrI1n1p4wD7WF0bzCMAhqTOXlnlLQ2coenSWh46eJtwsBlYx7In618G8zb+eGzYpHSgg3TtAPy
	X5dWPhj9ovdP8x2me+kKoFBbsTlqJDamWT1yBlQFQWuzklwHivV46zBc86VIsVRbVHWAYl1Gq4P
	rdoLi9qkhl+6M78uy+n5VllhFxlqxG6foTRRnTfTWdakz7OniY2mLUYSc9G/uRYHTCh6VC7qLnL
	Ju2hbbhiRvYWWNyfq50pVB2NKLn5n3Z058f8QA3KnQTGJ0QbplBOFiL8fUXLzjFl3E3Y7YVlgPe
	YcV8v4nWUQeKU2xyyhdEdrNiFHCaaiGPb+Xc5NzcBHc5yaEMINuzP/xxyjm0ExMyxTa9C/sIrS3
	2MlgA9iV+ryj4tvO17FmXwOitSR2YixpnhBNeXx7F+CQ9FBQVdfE+M2DPohHNx8XVoTFWE5TaYw
	24ZlZFMyp6a37TXr6pgai+FU05W+rEMk+DuR5ts57UO91HYx/tD5h6Ll1irvwxl
X-Received: by 2002:a17:90a:ec87:b0:3a8:c0cd:57fb with SMTP id 98e67ed59e1d1-3ab3ac9a1b0mr4922031a91.42.1791678668019;
        Sat, 10 Oct 2026 17:31:08 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::a891])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm9681761a91.16.2026.10.10.17.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 17:31:07 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm/cma: do not count skipped ranges in cma_declare_contiguous_multi()
Date: Sat, 10 Oct 2026 18:30:59 -0600
Message-ID: <20261011003059.169430-2-skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011003059.169430-1-skunkolee@gmail.com>
References: <20261011003059.169430-1-skunkolee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kpg59ng8sxx6ackrtrd3d97t5xph8yrp
X-Rspam-User: 
X-Rspamd-Queue-Id: 26A1340007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791678669-52253
X-HE-Meta: U2FsdGVkX1/ApR/EcqSHfPhOdXEXUm0B43+iz7dffyPxezkN5O/XCaYL03cwLr1dCyVRcU3fX0yu3xQhiqcyN8KlkImXOXwi8r5cUGkRm0dYzZByNlLHQtAa64sJ/RzP47WuqVsW18XIeUhk7wH2iNbNWhid0R8BPzjyRESLEZd90YQgKOesAovRUlLvdsHpNl2k1pzGNXvDhWyVVuLdgCJgK0Pg66mBDsSaw7vFSWNhdBxeTrH5zw/foh0Ln79wsf+PqyDeeIttsam1T8wPu7AdAVu//QKAlzGrTubgSHg2M0xriTTvAnTq2tJGuuf5P2zEkDxgLt66Yel5l5mJhU8CcbZkfgHEJ90+gCBh5O5yBCw05/UPGgZlHStHLEXJOkrJLoHZJUhFZxag+3Jhp47XDl85AvnYEIQoThJVRsALyCFijf0HGKUoAycqPqc1+JFKr2xgGQOAN7jq5EsvXpDxnsYC+ct+4v7k4oBEWYeEi82U5TtnR5CCEehPdYLrvGLmri5AvsEfuF0SyiHFZRA+ICOPOA+C1dpnRw8dFu4mhSYTV+sMobqT/IX4NvRmHxmCuXITyt2Ro9HSQ2GSSy/dv8sFMeJn+t2/FiV/CCYsQLEexLkbsveyS8XioeXAf+mYzJ1X+lrSpdB7WNxHF/YHKPhziF7SMZj+tfO05DksxcBEZ2qRNexCqjD9qgmxBFUdCDUtjwN/tUP/1kdzQtIYzJT46dHvqOV8z5IlfcE1qmXpAquSGFEqcf2Lou+SmTDj7huk8DpFpCjygmFgOomDIE1zJQv/L7EjyVsMaH83gWxxmYN8Sd0it9brDirmxXEMwUM+VkLndS5/JLDbcKXGiCJMykkg1SFBHsHTvq6kVSNEvwBGfURJrQUkugwHbauO/5LS4UBmSjZOrgTOrGf0ewgG1DyxPRMiqHjXS+oM+C84Ti29oPPjNWYoRwkOiswr2LWvf7Ynb8Gaeis
 CkNmcUfL
 SkkywzPMypMAAq7eqdRgECg9gOY2VMXIOwcFiMMC2+C2HUGDSH0tCAeOrWsTzTCsphd5lDKosVs9EelpUK12/v8dbvFKaKXbx0Dlr3GS8pSAjfJEFR9FqBeyUGU7QVuTjAdA2V/9rhnNm7Fx3obYZPJ5IYCl+1ub32mrtlkHxp2rDHVeha1uHbcb76OfmQjic4mO1vSljxS5WpcUGYNMVc+LDju2yhJvMPTZLu69KYurVi9CCbS6xjjY263PkSAou3Z79niE4nEJrCayS0onIPiTLTuAv7mQHcXNOFjQE8KBJ/VOhp2o0qmRE5rVqGE6DSkgUwYg6fN3u+1jz92oAOoE0Xp/HuFW9GoEJmJ3DetBttC4dx55t3+11Na2xdpZVuJsJJn8UITPb+OJ5hQro7yI5QDriVMudDn+rlRX3EpeYGsjyoZOXdp6rYsl87yq3jWDAbMuhhlJga1LHO56m/IsXLLuNppzCTYHmva68X4bb26uifAcYU7Y64A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_declare_contiguous_multi() adds the size of every candidate range
to sizesum before deciding whether to record it. Once CMA_MAX_RANGES
ranges are recorded, a candidate smaller than the last recorded one is
skipped, but its size stays in sizesum. The replacement path already
subtracts the evicted range, so sizesum is meant to track recorded
ranges only.

When more than CMA_MAX_RANGES ranges exist and one is skipped, sizesum
can reach total_size while the recorded ranges cannot. The sizesum <
total_size check then passes, the reserve loop ends with sizeleft
nonzero, and the function returns 0 with fewer pages reserved than
requested. cma->count, available_count and totalcma_pages still
reflect the full size, and the final message reports it as reserved.

For example, 8 free ranges of 1G followed by one of 512M with a
request of 8G + 256M reserves 8G and returns 0.

Only count a range once it is recorded.

Found by code inspection and checked with a userspace copy of the
selection loop.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: <stable@vger.kernel.org> # 6.15+
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 527b2d894f3e..c2cdef953ee9 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -594,7 +594,6 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		size = ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
 		if (!size)
 			continue;
-		sizesum += size;
 
 		pr_debug("consider %016llx - %016llx\n", (u64)start, (u64)end);
 
@@ -620,6 +619,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		}
 		mrp->base = start;
 		mrp->size = size;
+		sizesum += size;
 
 		/*
 		 * Now do a sorted insert.
-- 
2.56.0


