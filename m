Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E16C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551886B0095; Fri,  4 Sep 2026 08:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528DA6B0096; Fri,  4 Sep 2026 08:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466376B0098; Fri,  4 Sep 2026 08:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 212CC6B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:21:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ECC2C0E04
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:21:13 +0000 (UTC)
X-FDA: 85175989626.03.D96E9B4
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3D8E140008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:21:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pBHkpg1z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788524471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkiCyCvi2P+iZbARVukdTb/KqWgHgSHrWQF85+jAN58=;
	b=vYpwqWOcjcnsqEfJNhNH9Oh0xLoVyJ8YBd1Un+ZYZAggIbHozJUgP2vAMCpkDrjHoicJZ3
	x5ca6U+VnBELLwetM4WPlBG8Z7xDTvs8FoI1nu3C1GvLoz1IEtOX4cWSBXQvX/Y8jabSPu
	iwzd57RwWEvxdtE9owlQYVqoN63ftuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788524471;
	b=EtbZh+oWyLyYN6RS4JUbqxJFs0H7xTFdVMNsf2V7xbFyOfncFsUIft6wpPD+sJL8Syc0oP
	viKcjEPerpcTNNLbuzVbxYkKpTuEN7AuNhWbH97BabwCS+Xd67lHr+OrAFY8a7pEnziXzP
	TRq2USljI6FW/mn6ifHl1VQcV7PN+eM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pBHkpg1z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc147d86bebso967962a12.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524470; x=1789129270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lkiCyCvi2P+iZbARVukdTb/KqWgHgSHrWQF85+jAN58=;
        b=pBHkpg1zbEJlKInXNSZ1Ec2GTHfXkfTLa0wwNpDNNa4dagSGsHAGAzeHiFTU1Yvx36
         1bxQS2+vzpIcP6jGAVr5WXu991E+qnnfWxRAdtHa+80uso0xMaR0eFAXyWKZyWpMZCRJ
         n0hCXDI/uoODppmq7KhqKPj53PFDahADjYKH+upW7QKBTJ7Got9fyBuwq2T5NKBUU1c8
         2XNP6uXsG1tcMNMmdJqe7jIhAnDTrHenKcwSYwu+7a5+1kjGfQ6GxhilEfsclgRapyaa
         1/q9Go/6ZNd71QoQiS7a+TLqRSHZGwRZVVXiLiLKGXO9mY2rNrxgMqWHG4r/4nc2t4bf
         d2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524470; x=1789129270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lkiCyCvi2P+iZbARVukdTb/KqWgHgSHrWQF85+jAN58=;
        b=J3jO4HozMwhC5Nj7gKL7m9kE0KBqpYcFw4vUyu8yOxARfyU2CQqx/lw7b/imfHx8Vh
         IjumsaRyqy+uhiO9XVOd6ABApcDT8NMjgCFBVTS0jakqKpCeNRQoVY7lFl925QmCk6JZ
         nBa6qvxkMLGZLl2wc+q68xMNSW+cl2n28PkZAw3Ao8vxMUgJ9PIlA/4n3TQf2G/4MTST
         erkCLlW2AyoJpCSjx4kfb03C6h79yWCurAZJ9XLEqzdz51BnqCeLD7YGRHuL8aehlzAQ
         n0TEelDoiKvq/VpRQAV03Bndg2b13RPiFm2ckd/8iuVd/MkW60hu1Zgc3DJw+2DxhHhJ
         8Niw==
X-Forwarded-Encrypted: i=1; AKwUvBxYlIZkOxmehqMMdhvxanmSO75+V1VfriA0SSOZMHMFYWS3/ZEsOWwgZVg1Rh21u1iK2w5Kxs+YJw==@kvack.org
X-Gm-Message-State: AFuF++ko3FEmvsdfohl9Zk718Lih55d6Kei8I/NDrZ66z8rB7nR8kLdZ
	lOfwKINH/uGdOoyONGv2ebwq7m6Y+qMD18wPaRaVOYuMhm6GIqTo6rcS
X-Gm-Gg: AYBFou0xEOa7YwVxKJVE+09yPmcEZ6ydRehGh5lrTTDgBT5o2sN6joU1mXQp1UP3ZZt
	hJkIOrtDyKDgcZ6UNR+FbwvzMV00ii1a/RPj0vp3FUxskRv+aRI8WmXZjVSsyse1MVE62NZDnJn
	l0Ni7vJSZYKmjEi7L5YW5khV09rZ2CAPeLfjcjUq45mhpS5XqzxRW0cxHjzCVzDRn0dc360eOAD
	UfAlncD8eD6MwVRyZSfnUSfA1bSz9APC5ZVi8mgpQrjK5XZgZlbvnSpuuePUUnUGhWlyqcKiQYD
	PV2S9kztM36XWRtBm97WPmn5upq+GBcGz4Aeii2hnoJDGsXc7N2iSVBpZDgkrQcU4ZD3kmMv8Pu
	6lp2AQNdZX8rHUaOoquXFeVT1rFb+LhWFJ/VkgCagS4ho8bEGhqHX0pn35/+9kgRU4kwT1hMtr+
	LwYHdhPe1nU/oChRux8LQG3736gsavXYXV+EXWCNLO6iSqyDLo/tyyk7TeS/WGpL2O+h6piIhe7
	ZTEPOA9SvxHGac=
X-Received: by 2002:a17:90b:2e46:b0:38f:a81:15b1 with SMTP id 98e67ed59e1d1-39b08653554mr16531593a91.19.1788524470541;
        Fri, 04 Sep 2026 05:21:10 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm7116019eec.21.2026.09.04.05.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:21:10 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] kernel: fix typo "overriden" in comment
Date: Fri,  4 Sep 2026 17:50:52 +0530
Message-ID: <20260904122054.28531-4-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904122054.28531-1-hemanth.selam@gmail.com>
References: <20260904122054.28531-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3D8E140008
X-Stat-Signature: b9x6m6wu9gbru6oq768qy6fwy8tu8tpk
X-Rspam-User: 
X-HE-Tag: 1788524471-196406
X-HE-Meta: U2FsdGVkX1+bwy/8jTVB28SnBFq48fer/LS6Pb1qANb0j8fG+OGqKiwuxpKB2BzM+g+3EbVvgX4hZBAVpOsYLxmCtAL7IZMXwVhA9brQNAtjUpK7SJujL9RkXfjHw9+hmTTqGrQwga2rYUAEFqw4c50Gzel1ajjUtahsTo6LQ/qeDI0k1e0qWZTE+qNbVe6fkCACmeoh5aigo4985t58QksbZDXwQfpouYGyKEi0e/w7PCr0mglLepHc7BUvOsv+2C++l+fatyhroH4nDsEE30WKWhD57MREIAAWffIAa9uuM1ELGxgHPHKVG2s4QoeeApD8wud/LuCg/NnUSj+cbSd/DaKtaKEfq3b1ByfPFYFqJmiHRTzw78JzRZteuje8W9ggplUDLJja9FCKMfRBzV/JZSvOotNs2+xvAFBpDnYt80mUaLOV/Qj02ZTSK5tbj3yik7BruME3ctXYOnp9Oo2H3tX3knH1qL5MzDp+DJQn0cH067Z9av9i0Q1M5qAWWcJOfL3hQ7tOvYRq3Cbm81BorrF0zo2Znk8EjevGVdDKE9un/Pm0dl2X5p5S7D3bKeYavAdmEiub7lslW2uBtOA8l4mBnqDLDynDh8OfXDrPyE3gZoYOiCJHuQsiLTpJZpemUUisWkjsgL+JfUnvsGHpui4SVPIRTpLVJsNy5lwMas5kawwc68/dYenGvMCAcfNaPvIvvwhzDGnP/lumqELTTVxqfFhna06iLAG6rKnl5tj5+WDhVmLVBqRP/xyWlsGcTaQX6DC17dItVKJxNmJlVCGt56q8o3V74CdpcIatJvVGNBsRwcm7V+RA2lBq1YY5ujxk36+y2e76Qa7j/dxWYMVTPHUeWoFEAG+/Wb/XL+AONIqYCHw2gSoU7wgcWTqGQo3CStqtdFsrKvH2wS2YkshDaeSIefaSAJyDZYt5NA3LCSF7EdWh9GwcJ9IG7jfm1bZ5fxbgpN0b3Gm
 fAYEAwJ+
 NyIKwwIAHydoEdLuJzzun3cqXso3N/2J7cbqNkDtyGboQMOHiqjyKM5/WwM2ikFAQaK/1qAtPQqwjebUvKorPn7Yrf5b1mVAjpvayUeYMi3xrgY1t1IJDDlAz4rLY1wx9HaYzHmCEQVB8C/SozE/tMqs4GhO1uz6+UinX921r6wnjqNCKotlLa9zEHQvXYdZpxeB7TD/DAfW36tqTnUv61hwjA0P4uV7gMkl5aZSJCy//dqw9OtQQXLbMViEQ3PJGqBphfVgIql8vO+SWaUO4mcdsOjVz0SzccCX5R+sBf331yB+xHfr6g3NBFGPJR4OTtXXBi8PeWgMBwuJPYf8cT0Is+jyT645LxLFSUP06j6Of4bgBNFnKT75ueQyqk47kcho6UCOLU6L+5/THLqZ7aSzjRKEfliN49+pq6zx14HNhPaE2ESpQ3Dn1eRGwRsyzg98d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "overriden" to "overridden", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d4..6d3340d34234 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3266,7 +3266,7 @@ int ksys_unshare(unsigned long unshare_flags)
 	if (unshare_flags & CLONE_NEWNS)
 		unshare_flags |= CLONE_FS;
 
-	/* No unsharing with overriden fs state */
+	/* No unsharing with overridden fs state */
 	VFS_WARN_ON_ONCE(unshare_flags & (CLONE_NEWNS | CLONE_FS) &&
 			 current->fs != current->real_fs);
 
-- 
2.48.1


