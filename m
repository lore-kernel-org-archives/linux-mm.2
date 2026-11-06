Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23074606A935
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZMj/Wldg
Received: by kanga.kvack.org (Postfix)
	id 43C196B05BB; Fri,  6 Nov 2026 04:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC1A6B05BC; Fri,  6 Nov 2026 04:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305556B05BD; Fri,  6 Nov 2026 04:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C63D6B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:42:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 991791A0D44
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:42:52 +0000 (UTC)
X-FDA: 85404204984.17.0605021
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id B8C8640003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:42:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ZMj/Wldg";
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K7jOVqAETJcaglRqxXxRgOA2nRul8j6+4Z7YUWOjC3E=;
	b=rgudXIFAp5G8zUOWsbvidcNSqrhx3CZQIO+X8n2XmPa7RncyQcgWUnusAT/75mJ3oj4tFJ
	dxjkvZ8Je2zMgN6SZzQP6emiWNkArK97U48JEl76ZVwHTQS5AGZHTUnL0ObwMwK5eV0kzj
	Uq32OiChOFizFPiJz6F1UEx+5G4e3og=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958170;
	b=IOolQX3FFyCTDQGYG8kyp4+T0HRQnmdKgxDymMHSikX/VXnGMG/cKw+KcNEhSZ9PnUrd+Z
	9erOtaZzH4KllKSeQKKuqy97UX/RKYs4rUoFESkD57xqrU2Rr8Y3MKAPL8BNUjijT0nEOi
	lQEtWUeFB9ToGr7l3N0ObaZODxu/40w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ZMj/Wldg";
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e93e0d86a0so525975ad.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793958169; x=1794562969; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K7jOVqAETJcaglRqxXxRgOA2nRul8j6+4Z7YUWOjC3E=;
        b=ZMj/Wldg8R4MpLRlaLZ39vj2A89KfJkSkHqqujRWABqBiQ3Hg6MoWAlcxvt0sNC5v+
         rIQlliyvZdqbV6JH+LYSWkp90C5Lf6NlfQdoVkbOfm1b/jJKC4sTIklzMs513M2M5LoV
         43XzGTx3S3e4QZvjmIz2sHuRbCWJZfb0zuM1txQoeaNcCInD+sIR51A6U6uCgqNk/oGP
         fgAwHpnXSYRzrQGSRfbV54V5w/zFUGQ0EdN+2ugqtTUFKAfIZzdDFwe8G1FLZvcWURSX
         kyMXciMhqToIMfYxRYzG2SNq8te7daL1OO2ZaN8ppZxS/eRbPnnD9nmmWgCeYYLMeCzx
         BAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793958169; x=1794562969;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K7jOVqAETJcaglRqxXxRgOA2nRul8j6+4Z7YUWOjC3E=;
        b=ENlj28c0RptxO1cjKS/L1QDxppBVRlzMMnplyXiJeMWX9q9feXBlTTSIWR0hQQWieO
         Y/Qu7TZbT1zoVEij7NncfjxmtBjSVONdLjtZIHqtxM4TFJZd3u8TxxftZtRYMF/VPWcG
         bSswYEf+ohK+1bA+ZqUbJcyfIbU/b9jRinC0NuOLg+nTjvQz6HzjamWDJd2i2Sx6w6LD
         EcUZiwdV02eOwMDJ/LaHHhfIXBFy5R8KiGFy/6Makq4gKMw1EsixQI1bTWn+CAdMPm6r
         CC/N97EhVP12h8HDZDZXtCVZw7wrrjYTMY0NmPf3askGdvfENPQqd7kIyWEW72ShFA3E
         qjTw==
X-Forwarded-Encrypted: i=1; AL+hErFG/DDVrJH1Upi5S4j0jTVx4rE2HyIDMvbAq786rYw2lloyvCngdBvYyqQ9nERbX1Rez0aF9DvRMA==@kvack.org
X-Gm-Message-State: APuU4Z9exyosVPtdnXELTRxTJ5mSphER829iDMs981DlVh0uK49kV+TF
	dn09EftNNwdv/JTJhCg6Qq+dmQvD7HUNfxGS+Sy7b6D3ROFhU9nGTqwD
X-Gm-Gg: AYBFou1U12MeLWJxvnLRe3NzGK8l+PdbA2VjSJ/ccAOD1Fdv/VZSZdmnb1wrnx2KgRO
	7IkzJD3cdMZKVd4i2f5CacCckakVONhMPkS75X0GB5xNZ3YptkUhGzSDtB82RcwlDiI98PsyMrk
	3m103Xy+pWDYIuTzVuEd15NgEnJZ0SJul9EaWOetapeioXNUfSYUZ1PxPznwUeFERuUgd618CZf
	bPlglnc2WRXyXA0QP1e2jb2bzp/EI/rTBS5+DC+wmS5ldhOBOQSH6j4hCa1tnYBY5JJTRuGOVde
	YP67I9egm/XBJp7biaf/3omD1fkht83WkYQ2sTHpJEH7VSwnscHZyV6CaiDtLnNSv0uC9zXlwwN
	Befjslao7jQWbKMk17jp7rSFTROUaSOk6R7MetIxUm2rOfluJaWlrxEjXuiFwuhkQ5iHtUaWVYY
	sCbSIrkXcnekQ3BhwUY01Z1OpD1CTP/xJNJyzHds11CAuOujP4uC8f95f8YkM9RhNObxYrYKg7l
	GSoJXCu+liZkBxbNCA6iXpfl7pr4TPjpCcc8CptydHFhzX67FW38bXAh2Bx97AKAXWolV778Uqd
	CrHwWF+DGA21VPzES3Fu/n7ELOjhFMAb5onzh9taqCQhw2gKjhbdGXcW+yEJDq3IJy8=
X-Received: by 2002:a17:902:d4c8:b0:2d8:f4d4:7044 with SMTP id d9443c01a7336-2ed41854f4emr38856425ad.3.1793958169104;
        Fri, 06 Nov 2026 01:42:49 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa9ed126csm5080993eec.18.2026.11.06.01.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 01:42:48 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 06 Nov 2026 17:42:43 +0800
Subject: [PATCH] mm/zsmalloc: keep fullness stats consistent with
 CONFIG_ZSMALLOC_STAT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com>
X-B4-Tracking: v=1; b=H4sIABKh7WoC/zWMUQrCMBAFr1L228UmlAheRUQ2m9VGairZKGLp3
 U0UP2d4bxZQyVEU9t0CWZ5R45wqmE0HPFK6CMZQGWxvnTG9w7feaJpmPmmhglJtGAIbu3NQP/c
 s5/j69g7HH+vDX4VLi7SFJxX0mRKPTfkBm9n+s9iysK4f0xIJ65kAAAA=
X-Change-ID: 20261106-zsmalloc_stat-e261d4dc1276
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: t1tega54wbcoj35nqm4ch6w4pub4af5i
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B8C8640003
X-Rspam-User: 
X-HE-Tag: 1793958170-67452
X-HE-Meta: U2FsdGVkX1+fVMrgmc9w/uHPOCFjOUA/Tm7fcaY29eI3WeZdNxVTNWW4zMgdo8orbT6XtbGwG+3zuvcjQhmLUd7PFb7NrT5YXWp73snBvp+BnO/72mYkrHZJ7KZyd+6OIbFX1NI7rgQZX5zPEF83BWF2cTUtZwXZiMu0IhkqC/fpYFGWJL/UXm0YWXVGXqPcPayGp9PeB1LSU24j7ELKGGRhpGZIOwEyUqxfi/IpQHCKMSzROtKND15lFVSbk8LNpYlFKjqmn7UQZKUVfozDfE+AvGtvbLsdQfzjbeE7lvKO3kOGsor3Z2206lytBTuAh2qBwQ89KURDeET+z3wyDGvX+b3YkuLpuiZjMVjtH5PRMIZFb0zgeJWBL4UQ9X9QGVpYiC/+g0Ouk77pmb0VcG6jnmoaen8+G86cFNJtawG0VvUVp+/RMsK3olWyqStbyffd3qWNz8B1ykvtkYUiqbWsYdUpvK4m4fT3zLlD6+1GWA8fem/pRDMhD51/cA7i9ntN8WBPNnJxTLpsq6RAvPK/0rfu2DHvj/HLVw6aQhiMq999VcVqserUUlnhUFiEUBvnnPK8fsrlTAGFuqbpfOlRwS8ABowT+QesNC8dRwqDyoY+5S5tKwjoer3FQKEWCMmnX/YCzKAG83ZUnu+r3UXTVo6cW3NZZIuRf/BoyEibyGfZakYb0zXsBpmye1Lgv9qDhmFZqpETfLEeYmVSyqe4VfjvLL7MKw135SbS/whfWt160tri1jjOqKYc0ahnj8bhPUQ1HnITcq9Eps0GGvBUjPG9skJSaxHyyYG+42JOurHWB0Ntcnb75UqdzR9FUdf4J8mxeN/ABUuJ7Q1BmUYW/PNMVBGAJoZnWnbBFX/41oM3AFNjdYAW0dMajJZSktFjY0LkQs4jgL62xYxZ2vRSrhpchp8+PtL/8iz45PbioXOX3woRGFZgOrQfunGzD9rstweLspefb0kERHU
 pulGfNMG
 DkEovrJb2DHwgvizsiImUHtzdQEMNqYD9G1Vl/DJgothIVo3rnkszNSrsHlcnajQ9gOvdnxQJTQGHWLbFKW/5g/dFerFa5PsmuIZENjExBq+fY9v5fpLqMCMsFKqbPPl+KjjYHBsdQfUSX7S6SLo3wa3ZAL64ojvGdCNF1XMBK8w5XWDPQhu2lQGC5Xz/PqSdcMP2pKrdX4MZCrCeNIrpvl4g2UWGA1HAYsy9gmOiGu0Nv3gcrmmux1ei+hipPOoU0PgUQuv89ZdtBhUN+iKipoy+hYT/rdJSU74C05QICfM7+G9T7eGJg8ZJzvLswpTHac4U2VB0Uzh1oofXtw6v5pKi62a/VYkozkaYq5EFqX3JhBpFr988SVHoG1je7tw4sIm/W6bSZ3rzhu70wXdqU5W293lPeE1r61JdWGCDLAP8P41bHiAmRhe/+CR5a52g2TfRFzd5gwkwd4UQXsXaD+1ELbtJLXBil9dCRz1tBT76B4el3PIA+pO/q1z3cmTecLSFeAriSsVc/aUjfP3p3JtEPOfEyEoor0/VYoc4GwDE0xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fullness-group counters are only used by the debugfs classes report,
which is enabled by CONFIG_ZSMALLOC_STAT. However, these counters are
stored and updated even when the option is disabled.

Make the counter storage and updates conditional on CONFIG_ZSMALLOC_STAT.
Keep ZS_OBJS_ALLOCATED and ZS_OBJS_INUSE, since zs_can_compact()
still needs these counters.

The behavior with CONFIG_ZSMALLOC_STAT=y remains unchanged.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/zsmalloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..eb77d7cd948c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -212,8 +212,12 @@ enum fullness_group {
 };
 
 enum class_stat_type {
+#ifdef CONFIG_ZSMALLOC_STAT
 	/* NOTE: stats for 12 fullness groups here: from inuse 0 to 100 */
 	ZS_OBJS_ALLOCATED       = NR_FULLNESS_GROUPS,
+#else
+	ZS_OBJS_ALLOCATED,
+#endif
 	ZS_OBJS_INUSE,
 	NR_CLASS_STAT_TYPES,
 };
@@ -721,7 +725,9 @@ static void insert_zspage(struct size_class *class,
 				struct zspage *zspage,
 				int fullness)
 {
+#ifdef CONFIG_ZSMALLOC_STAT
 	class_stat_add(class, fullness, 1);
+#endif
 	list_add(&zspage->list, &class->fullness_list[fullness]);
 	zspage->fullness = fullness;
 }
@@ -737,7 +743,9 @@ static void remove_zspage(struct size_class *class, struct zspage *zspage)
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
 
 	list_del_init(&zspage->list);
+#ifdef CONFIG_ZSMALLOC_STAT
 	class_stat_sub(class, fullness, 1);
+#endif
 }
 
 /*
@@ -1896,7 +1904,9 @@ static void async_free_zspage(struct work_struct *work)
 
 		class = zspage_class(pool, zspage);
 		spin_lock(&class->lock);
+#ifdef CONFIG_ZSMALLOC_STAT
 		class_stat_sub(class, ZS_INUSE_RATIO_0, 1);
+#endif
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&class->lock);
 	}

---
base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

--  
Best regards,
Xueyuan


