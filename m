Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E44BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514C66B00A9; Mon, 21 Sep 2026 10:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC826B00B7; Mon, 21 Sep 2026 10:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401EA6B00D1; Mon, 21 Sep 2026 10:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12EC86B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:38:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99F461C19D4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:38:22 +0000 (UTC)
X-FDA: 85238024844.05.034E45F
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DE9F1C000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:38:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ugiW0wCK;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790001500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QYjUrUl2qml9sF2K+z/e51JYen5+cjRMt5pW8NsvQc=;
	b=Jyh/wKK5WlKE3zGB4g4drfwTJpvcI9YmEGeK7C5SElgwzwEAzmr/1XOLeNohw9R574x2nU
	PYb7/KV2dYtSCJgtFg+VcsGiSNw8YGs/9eEuQ4OVeNii58EUC2TAG3RMZwwwu1WwNEPjWQ
	fV41x40ZhOD0u0srPnqif+j7K3kn7tE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790001500;
	b=YR+YKfd+RXFUs/01xK/yIWEqBsLaKmzXTabujmNv+xTdxUguWXBg/ORmE03JG9itxYoMkd
	XnWEoyG442CqMRKuvS7Vu+WtmtRz0FwAFeQidaMPTzvLOMW7SW7SsuIjnz48so2AGRRUpE
	gCtzwc0Iplf7ZM0jNGYVfAj81i1qxsY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ugiW0wCK;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.204 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530301ff353so40574611cf.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790001500; x=1790606300; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1QYjUrUl2qml9sF2K+z/e51JYen5+cjRMt5pW8NsvQc=;
        b=ugiW0wCKKIpDfuFXIzqz2MP07tavzgCyOsjB6NezHE9tPdk0zKjDhuHwU5HCPJFjKp
         QAvftcemHvcjQSvK0AwXrdYPR+jBcgD3QHSHOtKgLdfWgQqcmq+sBpYIDan0Rav28Ezp
         Qhu5f8JNb7C5r/o4f8qH0kSTL4P9W7hIYH5jWMOoQbAFecmw3jJWONdfyOzaOWVFAypQ
         ThGGCCt6hbnxuQTYEy2nZF40XhxCYvGHPoZI57k7g2t9Vpe0n2sUel6aknuN2yif3GIO
         EbY4glwdFpVBvhjDAxa5a3v4yMHu7Sn2km2j369MKKeOK/qdYHrWf/x3uGtNQo3oX5VO
         lu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790001500; x=1790606300;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1QYjUrUl2qml9sF2K+z/e51JYen5+cjRMt5pW8NsvQc=;
        b=MpI81PD+fJRuQnxIbSnAs/xxUHBB6TcqnjR4bdUDjtlcH8ELZ7Ol6IHEMh5OFg22x1
         ywanPVKOZUJA2dgz24YLl4VQrnhGa899tWOYZ115GDKuS8Iu9clbU3SH2YU4bBFp1bm6
         yIP7XGPre7z1KpctGpB40Q9Dfi3UR3oavd2GY1PWsh2QTBhANPaEftTZWjMQYAfcZA8e
         6ylxMjwGIrtl6Zy/o4sACnvzQiXdWlEwk3ywZReVrEhnX2XEKMyDxYswBOCDRzYNgNJJ
         1ATx4agykbcQ9XkHUfHXGWzqLimfvwWCIsmYF3jO3a2VkJwcdGfe1tkfyq1SJaubioXg
         tVnA==
X-Forwarded-Encrypted: i=1; AKwUvBzN6PXkHCSOOlFOV6MuW5k+dpKaeyT0WEZmEEKAiNu4fmRZvClHqSy711HaBFA5HB2gd3Xl0Iog9A==@kvack.org
X-Gm-Message-State: AFuF++ly0k1zejZ9KD/LMHj5wegYktucvzShcOdeBypmf5lvwmjOJ2Ez
	L0nJxewLKp9+mXSEmRJnLlPzpCDUyBLWsyMOBWtl3c383lRbSTv3k+a5JS4phDSbZww=
X-Gm-Gg: AYBFou3FOfzYMGrU0PmZxxRguboJMbhNnwQIL2Atbxwdqd2lwJxIUpC2qnAUuDxKtpr
	dcwiK8B8DcCSXNnftS31RN13dMSgF0iSGHXCbsSPamNZHI/9viMa7Wmzj80uPu54prxpOHCv2nO
	IYqRURnmaYrvPGM9lONvEl8+MTKlLLtZ6faRFQL5+CynVrRgi2zWNXPO1FUgJCybwRKxGMZ3KD9
	/750NbFNPKaOvQ4rlfJjvu70pCSdBZ+XzW1GIQLH2AeJgv68mS0EgWU2Kckpqw6hqZRYQn84Gwg
	W44MvCyeToXkqCpVJDTxyDwNxTQMKadHyqesZqtoRob1uItGyIshOu8+gmYskmpH/zkkaXFB9Kc
	D1eMTbtK+BJbbTS0nFsq+ex+hv1DV2tROBf0f/BDv6kWYM1FU6aH+joMmukCY6JJQPNC/HE/t5c
	fJz5Qm2Js6K7r8PORwjSUmQxAAAq8fxS8GxkS9Gpb8UYN5eMB7DLF40zyJ754Ez08ieXR9KQ==
X-Received: by 2002:a05:6214:f25:b0:910:3c08:fc6c with SMTP id 6a1803df08f44-913fc8c6d74mr9199966d6.22.1790001499563;
        Mon, 21 Sep 2026 07:38:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a85c7bsm68848416d6.32.2026.09.21.07.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:38:18 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:38:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
Message-ID: <arFBWvzXPYrKuIYi@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFBJdYaRx_iJNDA@cmpxchg.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: o1umtc3spp1t1bihiu3ncasj57sny8un
X-Rspamd-Queue-Id: 7DE9F1C000B
X-HE-Tag: 1790001500-336960
X-HE-Meta: U2FsdGVkX1+9u0U3hm752Jnaz3K5jCG1PqItLtk80tRwEuc7Cn+qzWdkqBODnudFZSdC3orYNgbAD4D6NRS1xy4yT3w0cMmd7SUcafr7d0aK+Vgdc4E4TogTrfP7V6ng19UMV2O31YisbjW/v8IRX6ZqZfH20252T90or6/ABcymMRdpfW3v7WKGgx0kys1GojlrzozeJVe7FkcnsiyuwMHk2oqgwBrx7Z5rCVAlI/0e2I1UnQsp79W6fljbBCpmiRxcBrWrFkNaI/HUGMYw7yXKuEiybBanoiYudjhvzn7Z4n/nzXCzD3TpdhknFpwwfFNtL/7KRSyTb4kgBmzKnfoxYe+Zt2M3ojocBoQ9sJblHDtuk2DzC57EfV/4vJCtWtyrxb7mFX0zXjW1WOXI4ZliNiHKGycZCjCY1OxJe6cVs/ECeKlTYrgesoLdHZmtwI+hYCFNVTBfN8htc6duXBIGY97PPg7GD/AJhHe26k1FuBOO7zUBHTL0uzHSw85DcR4LEjp3LGWW7MYdoVa5vP//8kXxxOmmtMgWaVNpI80CmTXuyWGxi/ubw8l+ZVaC2AX50F3n0yu1m7SySvvvvsOLt2YX5R/tZSvr6tyjgMb+Tv9B41OKPupBLAIaj79JNHXLkQTrnqQVgWLkI4OLTk8gRM1Qyt1OaoPaMtiY00eFlrvvQOWyS+Y1VUjFLzWr7egGlxnXaWr4RFGjFB0Hw2mXOpHw2rHigkI0JetwKm0Jy1fvjQ9JSV81mS9wgVhRbL696B8MvK+miCxk38PIGfNa6aO0emc83EulYdBjLy3wEx+RbBr30kjuYb2REbEyfl1NMMthkf75tN3Lc1VSdEbRe9mCXiJrKzfUc3bDKey4sG6pSnoAG+uBKfdFQzEZ+G6L+QjcdL/igo/ZHLILJd3JmQiHzrt4vILcU1ygERf6DgePoBlfyxP2xMfth+4atgcEJBvrvIyZwQhiQUK
 2Vf+ZCOc
 lv1PBM+2gVvboYQvCCPTBMNlfisNk66MZYh7DtiSiMYORg9YVucFY9DH0V8bAK8M77avdKahs/P5NSwJUvLqMEy30aMmJTaHC9aFMFIEnQhkpznBxK5YVghWL27xv5zS3h70Q9J+3aDRhvGLqtOGE2Evfbj6FF8gR5aqsvX423asWuGZS4iZzEzAfcT5B2amfLyOZFOf1y079YnJ4KLzGYzAOeXx2VzYZSdzoXIpdNUKDVmXvTF40MgLyHGlZYf4XnRyIaaL4BXEOPgowKEPip3FgX0jZBgIr7MhD/hXl2rPZ922kWyBI9t2SQX6K5DSALFCCgwnHxu+CldTRJB3WzDpO1Xj3kHOClcaC8KB63kDeNeu+2kerjB+fljMpckEB01roiKNZWS8ECLUFtew5lsjddJS8EIVzB20CHh9dVm8OgDKymQa75VUXIfBBJcvzUFudqEE2ep8cndMFrkkGboRa0aO7IZj2ZG1zGoMjHW/C9OPVkRm495HxzLN18dx2J5xljCh+D9MPwiY3q1Is2k+tkCjXSiQOdAqHl0iLa9PhbHIe1H5xlSWJx3HQ0v20+KGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
highatomic reserves") accidentally gave all non-blocking allocation
requests access to highatomic reserves, which includes GFP_NOWAIT and
other sites clearing __GFP_DIRECT_RECLAIM.

While this improved atomic request success rate, it's unintentionally
broad and can actually worsen highatomic requests by squandering the
reserves on requests that don't need it.

There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
for costly order __GFP_NORETRY requests, which would have then also
fall into this exemption and deplete reserves even faster.

What GFP_ATOMIC has over the others is __GFP_HIGH, which
alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.

Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
ALLOC_MIN_RESERVE.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 4 +++-
 mm/page_alloc.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..7b46d0ac3a56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page &&
+			    ((alloc_flags & ALLOC_OOM) ||
+			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..ad89f83d1dab 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
-- 
2.55.0


