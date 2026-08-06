Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C20C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434F36B00BF; Wed,  5 Aug 2026 21:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDA86B00C2; Wed,  5 Aug 2026 21:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210D06B00C4; Wed,  5 Aug 2026 21:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C02DF6B00BF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2E09C0617
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:51 +0000 (UTC)
X-FDA: 85069070142.25.E5D314E
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 29B018000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Km8Vx20Z;
	spf=pass (imf30.hostedemail.com: domain of 3kN9zagcKCHkgvbpZXpdlldib.Zljifkru-jjhsXZh.lod@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kN9zagcKCHkgvbpZXpdlldib.Zljifkru-jjhsXZh.lod@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978770;
	b=EqMu8/O4RuiXoRspj8zK/rnK3s524Oc4rS34SRP+5jyCdnM15mI7B+1fo+j4NKyTI1D/Rb
	xveU0U3WeBmRTgzuC1yWXRYCccgyqK+e+U22ZiI5AlrV5yOgYjvs0ohdw7w/ve8Fv+tyAd
	7A8MqGKUOgZ0O7abXoBTJIqCr7ZAmgQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Km8Vx20Z;
	spf=pass (imf30.hostedemail.com: domain of 3kN9zagcKCHkgvbpZXpdlldib.Zljifkru-jjhsXZh.lod@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kN9zagcKCHkgvbpZXpdlldib.Zljifkru-jjhsXZh.lod@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN8q6fisIIgd75G0Jqfk36UVrl5SrSLb7qi04o0MNbA=;
	b=DdZtGFyqyDFOwmu8Nnyd3IsV50cS/xp6Tmg2lWyJ2gZ8LlW49R9cA0ikrYHIzUnYJ/igLW
	SaaL/SuiqPmrFcYMjXHpr+DNIA8Vp6DeZmAnWRteilapb0BTRHam3/Ktr8q78iXAfg7La7
	0FaHTcwpubvAUoGZ73FgvGsH4+RnIwk=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb733fc5024so2186942a12.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978769; x=1786583569; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sN8q6fisIIgd75G0Jqfk36UVrl5SrSLb7qi04o0MNbA=;
        b=Km8Vx20Znx6Vj1C6IRpcHvtwN0XT2ULcg3oAmC86/gEJqCylKsjekwC7hFH0MvS+GD
         LBD52sIuyuTLjwIAsBMoWaktXTR5sAr2xeDLb1bIWtE6TkKLzgW6wGs7dlBCwl6RB4AA
         VCp0NDr0et4J3AEk6lNbg6zC9whPop4aP00QdSSwwpkJAncm7kqKqixZSlb5ml6p89we
         JfC1Ti6V4h/7qQHaadBFsBRQsfzsXyWoRUKCChXD2e0l3z5DVlYLvr55/TRm5tShVF6r
         QL+uoMES762bOMX2vI/ud7231zeyao5XxG0fsdn5x+PmWwgPGf3K4lDCzZrlkz9SJEub
         DnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978769; x=1786583569;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sN8q6fisIIgd75G0Jqfk36UVrl5SrSLb7qi04o0MNbA=;
        b=l3U2vZbJoZr88+QtTxDYGh53qOQ+STJzUcGIicXxh7sZ+jBGKMAhpQY6RRdS6kexuf
         Zs3vaLa/2HGL2477NpnXYj/YL1lu+n9Q8UR7c6K3buwiZ2S+QtbzI49Z1jmgQ+AhXz22
         NZhLFhzLmvgsB+/T7hhgC2scogrCOu6XITWIDO7Ja6DKncMLXZAEGTdulG7tHl1ku903
         3CiXmnTEp84eGCRU1BEaChFHdNfZv7WEwS3lhXCEqcYUTdnH+PJxFFcbfsnJLlYmoyrv
         3vgqHL+YoihFRAHqDsFIKz515dYzKjUsiSPdzxmpir4Vnio17ZfoL4r4/kEWXpZp8wZT
         YDmA==
X-Forwarded-Encrypted: i=1; AHgh+RptruHgnRUeLyRlb0xLYFu4I+FHePF07MnUv/HTothFC1Q2WYdxKv6dF0Vom1wH+RytFWKmRi7cgg==@kvack.org
X-Gm-Message-State: AOJu0YzQV9pKKXJtTW90RCcjRSefOstK61VbiB3V4f7wpgloXS7DiID4
	2xR2zbxBxq+ZtZSqUcE9K+WfhZnYvAVYB/zHYSlFFbX1N5BeH+p0GQUsGjqSINfOqU6kfmWOB8v
	35vqXr9IObg==
X-Received: from dlbep6.prod.google.com ([2002:a05:7022:1086:b0:13d:2ef5:67be])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a107:b0:3c3:8d86:9856
 with SMTP id adf61e73a8af0-3cb85ded96dmr12416899637.14.1785978768797; Wed, 05
 Aug 2026 18:12:48 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:12 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-12-jyescas@google.com>
Subject: [RFC PATCH v2 11/16] mm: Sets the migrate type in gfp_t flags
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29B018000E
X-Stat-Signature: u3qjq5f9gh756s53ted7bqfr9se5x6c8
X-Rspam-User: 
X-HE-Tag: 1785978770-739759
X-HE-Meta: U2FsdGVkX18Uz7zOWmKD0kmMo3jp557QANwBKBkX8qtDUEMM1MGY43HtkqbYR2a92gljjlaeX33VeJLnV8uRsEQrcqQ3sQj0qO4XbRT1gr8nHrL3v8P/gdD+BMcHNPy1V1qTwBp5N4pgISdE3OK6jUXehcipN3TyrXINHgrJxP8Hmjl/z8ShAS+lNT5Kbtak5LAY4j3u87zgFyB49W2WIbn8By3gMvWxbwTRxAWJT6E3Cz5ZLVSwCl1nuLNOkgrslrmhSAsFdggBZeFR0vO12FlG+Bu2yGYI/+7WKykGA0/mqYXbylNmBMLbc0k/yVOFXnFppIjFjPiSUwMS9SGNcQXkZWE+uVPpD2DmHS3X2w092yNzlYz+G/E5RCD31gQ6Dc3b3Y3bz8NE/kKUzK36aqICA+5yxJkXVGr5mHXfGUKVDro+BbMRMJBe4ujtn+JcWDSDgz+q7kseiTfGzUpNCvf1OvW+4hKN4HcnO3bVIt0uVtnHpMk+5pqRkZuyAoaTheJknBRCGOo85yAwBiUbjYcTaFV2MCVH7s1yztckeMLHHgXVWEVY7RK6mxea+TSXF/xEE3rtF+y3TNUBprAW/+tZbbI8h/bJsTdwW/HyGFt7Q/l93+DdeE3lSyUSu0CQvxkoU9LuhaSkC2VW+Cg+dYF/nOAHkwYs8Gx27fcVAm9kw+WjakGBmr2AcX0taxye3m1AqIcFLGUeEt/pfGYscunkMLDqv3YJSIxdPFaTNkOJG6DkRC6wYSMabiMz1XIurCIF0gUkWPmG9XRmmzbMV46KdbWYPJmRM5jSe/8O2FvWWROddaxHA3NXwLOZuAq7TAjkgr0qnvqf4qfzb5DamzlayaQyo4GVrkPCV33IJ+ol5SGp1UE+lbplPzhu1su9VTUVE+UrOPewVT33gEd2VFgJHeEAX8wV+qFn6ZZQpebVq18y332HpW2+ZkuPJaCyU3jWZdRgGeYG1E4jpob
 b3u5m9eu
 pk2y3wADAC4cZ8Is9x10f+vzmCRYGpuSdUa1DxAyF02a2bTv/Pctk0TBp59/q2Fj8skknLjPDqIz/JiD0vKRAdljej3z/1FDxk9OrFAMsfUGK98UvZDwl7u0pmiANibH5TtaxYXAEU+FJ5Gu5YBC7XWtCB4JLG6vtVR9ZE/yuVB2lZvDlu4uvJTtzi5QxcDxm056tEw7glnK8WVm7FMAMjM7t9VLSMTAs6HUuUU7E0Y9FRMARyjGhy5aV425vRZ/5m+xAkbC1eo2THjfTJLTsF6EDSyPoDeYaTCCfeYTsvlKcjFhOUcuCFD7RxYzNowPwhsM8now5bPVh5l936At6ciOdetzxltc/+9BbYapIiYoD0I7hnio7vMB71wVm3De8pU8Z3ASB/2X85CuQ3PE7ApGvNZn5nDkKFgL2yZGcrjwEIEasYuKWss7Pbs67iPdGa3jMLUtNNDkx5ew1SbmYoYVL8IWJPa/wPoeyuZ+ZaLtdiFE7FypfNOlYqYeVgNzNPMGxycubn9nbwIHl5jXJziDyManv5pCr/mqmeuOivHPke0c2lGRY84sDNmEcNcYnOVCh037yr6/AvJd+IdAjgcGD+3ozOL3jqIcZ0qd1PkdueoPokceWI0QVeNjU6zXZVapME+FEu/IAW5MOwVDwyLnnc0DqkOCqnB16dQKC6wwe5d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change sets the selected migrate type in gfp_t flags.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Make sure that ZONE_MOVABLE is only used by MIGRATE_MOVABLE requests.

 mm/page_alloc_hogger.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 0e9ac43e9868..4b72acfbc087 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -155,6 +155,24 @@ static inline void set_zone_to_alloc_from(int zone_idx, gfp_t *flags_ptr)
 	}
 }
 
+static inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags_ptr)
+{
+	switch (migrate_type) {
+	case MIGRATE_UNMOVABLE:
+		*flags_ptr &= ~(__GFP_RECLAIMABLE | __GFP_MOVABLE);
+		break;
+	case MIGRATE_RECLAIMABLE:
+		*flags_ptr |= __GFP_RECLAIMABLE;
+		break;
+	case MIGRATE_HIGHATOMIC:
+		*flags_ptr |= __GFP_HIGH;
+		break;
+	case MIGRATE_MOVABLE: default:
+		*flags_ptr |= __GFP_MOVABLE;
+		break;
+	}
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -179,6 +197,7 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 		return -ENOMEM;
 
 	set_zone_to_alloc_from(req->zone_idx, &flags);
+	set_migrate_type_to_alloc_from(req->migrate_type, &flags);
 
 	kfree(allocs_ids);
 
@@ -248,6 +267,9 @@ static inline int create_migrate_type_subdirs(struct dentry *orderdir, int nid,
 		if (mtype == MIGRATE_ISOLATE) /* can't allocate from here */
 			continue;
 #endif
+		if (zone_idx == ZONE_MOVABLE && mtype != MIGRATE_MOVABLE)
+			continue;
+
 		snprintf(dirname, sizeof(dirname), "migrate-%s",
 			 migratetype_names[mtype]);
 		migratedir = debugfs_create_dir(dirname, orderdir);
-- 
2.55.0.629.g250fe7f194-goog


