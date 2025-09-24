Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A83CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE218E001F; Wed, 24 Sep 2025 16:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5D28E0001; Wed, 24 Sep 2025 16:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBC88E001F; Wed, 24 Sep 2025 16:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27ACE8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:44:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84BDC1601CC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:16 +0000 (UTC)
X-FDA: 83925321312.26.C67CDF0
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id C60AC1C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhYoK6vJ;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4V1oA69S5/U/dB8iW7L3zhYtpO3CQhgmwVtBdZtozY=;
	b=CfBlEhI1WfNAXRKj1KF5w8hH3Fwsz/US5U8RdsQnzzUNoyhm9jV/SA6GJMF2qt38CuGvWX
	KI5bc6Ph45fyad1gr0ZWGVpYVZ5oT3f4iKf+jRaWLnmCwX8pMCZ7vjFWwdHJzdHnTktlJs
	jsqnif8jYnVXB8lQzkafnsDjXss/ekQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhYoK6vJ;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746654; a=rsa-sha256;
	cv=none;
	b=gaG4Nuk2LQMoH097q76ciAu++r4c6NcNW79O/h6d4W+CKxzQe8WHKf4D/L744CXohtms6k
	1T/jyB/Y+7A1QeM3OzulkwR4Qrw85spkUgtojcJ/QMoYIf+CsApEe4muwG5EQniDpE0syM
	VCU9vM0g1dixS47sVwoMR3p4m6YIPGw=
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-eb37fd9629dso199132276.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758746654; x=1759351454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4V1oA69S5/U/dB8iW7L3zhYtpO3CQhgmwVtBdZtozY=;
        b=nhYoK6vJfpVdyeME31SY1jJv4v5QJDhqqA5d6W+nY4zalw5C/Hwwhx5NiiK/wQlBqd
         19oNERn6BT+mtxfWHUCk0v4ajz8J4XhdaLY5yjEocGYUcDW6AGF6r3PCS+FKDzMKrfYK
         wAP2zLxLz3FRrC/tyBPBvlTBHt3u1RMTm/PLqCV8i8NplCkMQw6NHnfyZKWYVh+R2liG
         erLuGlwXMVuvZHNP2JIvpI8TsFrlNc6RrKVkfEeRXEQ30qGcX/XJw2AjhtjrelTDDkPX
         rJmuQscfjOLOyqiQaJ5A/la4X9vSphdaufXIXjXxkkQ7b/CR5VhVa9zMbbVoZWAE4YC4
         z4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746654; x=1759351454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4V1oA69S5/U/dB8iW7L3zhYtpO3CQhgmwVtBdZtozY=;
        b=Ej694CmqMEBM7FmF+KhI5mUsJ4PJ4LYFnV+h7IEOg4FLUmHBWOzD7HNxUScCKAQ++C
         OEahf7xwTMh39KiiMIMhsm4LutHxCr7InB7AZI9KuGO2bJjlm+GUa+/IoesVUeNm3g+T
         51fZxhVdXEkYsYtfkkYv+mXIeepZW2AIdN8VAFldJLB+3C5emrDx5EhO8HF8EpYb+cgf
         IOUl85u5GHitwEGi+k1AfqyLUCZHXjfdgwLVYCLldF6FuHRdxLn6UPYnYt6Syb4OmMks
         lKkYi/CGWkJGOQcr68xsBfBO68Fbmpy/CdQHDVItg72Hd9esE5l8XveyTXhWonOc2V1G
         TerA==
X-Forwarded-Encrypted: i=1; AJvYcCUJH66N2NeNFUrq4ObSyz9k253/9fWtmYCosrTpo2MyemyUiAkuIAgQZHsyqZLizzBw2an4d/pz/A==@kvack.org
X-Gm-Message-State: AOJu0YyOVWQV3pf2vQ/BKYPwW166H7sdnbqPA+2ixbM47aXL5SK8fnSx
	DqaozshdntZJ4CJjIHTMwJKV4sgBUfBvYmo5XndIeaoqoEforkBqbz+b
X-Gm-Gg: ASbGncv3KfF4AaSfwqNP6C/hzrlxq7UtFJbeUyXU0nc7wq+ynmI6zS8xZz3P5SwJ+rA
	qSVIQIsmCGCc5lJGhPdMNjd/li5IqT9Qk3YDWiR5YaD5NshL6p1jvFnarlUN5iFwt4o9VUUwZwn
	wy9uKnDEJGi7NlWY5hGKhiWaOaak/F6aBrI9OZSY2p8eWoz93pm7rjF3Ld7lAi0bjyeXYV1yz0C
	dg8VMsT/1Alf2BD8Rm62onZTnhJKbF2CiUKk/qXHWxKQtHFoZRRdHMG3UMn5jITxNF3phCmTZNn
	f23jhfF9kV0EPYkyylxC674xnOd+cBu42x/FdNEkC01MuyFvb+6iRetOihkO8yKTyR74DshzCWJ
	xCdBDrXQKy0H2fv6p7RFETb7RdO3coiIyHlJ+aUUL0o2BRkskG/gRUg==
X-Google-Smtp-Source: AGHT+IGLWIGeDS+w6/c7P5M+l3Y7Vr7lTF0TwgiRy/gr0sq1nGvpvip3WbgwHrGGfitCUV+W85wdEw==
X-Received: by 2002:a05:6902:c0d:b0:eae:2d09:81f8 with SMTP id 3f1490d57ef6-eb37faebc56mr1349150276.12.1758746653799;
        Wed, 24 Sep 2025 13:44:13 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:44::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-eb38384dd15sm18230276.2.2025.09.24.13.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 13:44:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 3/4] mm/page_alloc: Batch page freeing in decay_pcp_high
Date: Wed, 24 Sep 2025 13:44:07 -0700
Message-ID: <20250924204409.1706524-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 31trrqf94ae4bu4k75a7ap4fh65pd1u9
X-Rspam-User: 
X-Rspamd-Queue-Id: C60AC1C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758746654-897088
X-HE-Meta: U2FsdGVkX18mG951jnOA8u8KftmoboBkFUOljzlKZQzeI+53cAUSL2swkQ7GFbVHh05gFY337MXDHeGkEfZtsVDlxp0S3wUehoY3F4nAr4p7IMT5JbnsaqV3bpGNnuCZhRiV4zH3Qdw8P20uiVpmzHc4GhFH4GoxHMBTd4uX6N4o7Aqt6sSNk6gF5Tv/iHdAcmyC0C8nkNP+xW3w6tP3xjHBo638UCa3mIICEGZG+MeLmZHEhqVgP3YXkXCk6KweCRnLcRND22LMcAo6We6fRjrOFDIgRi00eMgbXTRoK503/ooX+/NhXxSHf4LQp+EnFwBbrvPRbuJqiHteUJLZIU2rKQ2YYY6fgdk8wzCLiZmdM1D6R7tFteq5yLV1b1bxjnPjpZawmcf4+s8IUTuSEhEJsi/rid5RkY+Fqcc0MsgaLMolNB3Fd0wtDg4bxlbJoYL18yQwh0fWc0hB8sVRCZkomUsreNr31T6tP99lyYNhvmhUv9RLaUktEyDYLiC08vYrrU6TZI+aMTA+7ohrWwwGyTnkjzqaE8V762wpCfwJIC1U2ezo9bl0PmDQ7GwIwx91Blf2F2fTJ33RRwdCSasMdliVzsLQWJDEn8dwEcppMyfzLlMM6jTFqzob4edigPloZdSm5pzWoV3qJmpDRjuzDMa+bs6FaXvLQ0MB0Fa1NKbXU1BVKxXQLlEWEy4xHtB+8nH0DqCr0YJtnbX5/ihO1s+hzvwPeLY8ZPC7ndjkcjZ0nQJATEpXR9/fQnGPB1uAgD5vRNoRMGmk9SuEz3/piOTFMOQQLisbetizHlLq000ZUEccUC2/AofsaH3FpMDTs5Yh00aG4i7Ew2IMBmnmFWlS3ei52g0lzcoYKuOAt0ScrNLey8zvS6+lg9qk7XsZuI7ExctqiKOhNkJIkG125YreCbRgEF283YgkBnl56MceOzImSIC6EWWq8IXnWyiZ0DI9Sn/Sl+UHlEM
 FGizEV4B
 YaAY8QoO6ujlxey2swRzuPkgzZWN0JlbTI+eokRdBRXiw2PZgCz4hANZzKAZODGXNi4RnBWoD4f6dgQSC5uuZASMWBd6GTJhxR/wm86Z83wfPoH3I4IlNyjOtDOr9+KLL7ZGMEXQ5iZqn0/I8O8Cxzs5/fAii6guYUd+2zVjxPqrwc7xf8hRAKxkf3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b861b647f184..467e524a99df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2563,7 +2563,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2581,11 +2581,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
-- 
2.47.3

