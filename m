Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC6AC5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4910C6B009E; Thu,  6 Aug 2026 18:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3236B00A0; Thu,  6 Aug 2026 18:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CCC6B00A1; Thu,  6 Aug 2026 18:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D592C6B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A556805C3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:58 +0000 (UTC)
X-FDA: 85072359036.29.A85E845
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id B32C2160009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJuBUJua;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057075;
	b=SSguQRjUNXgKy/izWGosrhGu2l/v+teNgZ9g88yl9eu/vjlllKlAv83PF57KykzbwVGlYP
	jIvGAKjP6ce4GHbpco5ssT6mizjux5jkFw+mK7tm92twwA+PG+m3SFhhcolA3thuZPsMT5
	dSJF3kLfzY/3viynLeRyi4NKPTy1uxQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJuBUJua;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ub1KUb7if+gs21AzBt8YVgkd+mkgYy/e+EEwrtHe3aY=;
	b=UBPyhLBgdMkj8jlPMqmce2LWblZhlhG9FprZV5rs5HQClzc1z/RgITsT93/gdNmxHhIKGr
	CaG26AmOgLG/l6xmoqyDr2x0hFRcHk5cxF1Ui3WSuLG4XnEmt7IzonaKaLQYR5dz47YZYV
	vN17ZajCFJTBdC16Jg6KNgfgq2VTlvs=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676MbQEm916960
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ub1K
	Ub7if+gs21AzBt8YVgkd+mkgYy/e+EEwrtHe3aY=; b=kJuBUJuaanVVM3eOoLsN
	7CXYROSaT7KdmrBrDS4ssUDSc01Gxl8TYbFbAEmyr1CMuTZX/71rSOewTMKkUUlz
	rOFrZyzk0d+mKzvY/DC7c3KOVdnnCcNn9lncZl+KDVoFKmqVyC2khFLw7ktVPj5F
	zZbu/GpUmSeEFVPDTRUelESRechdQLisuvQp+1YRluhXfXw2AO/M8B+YNNw8KFVk
	fv+OLgqDLfswT9fJnPy9g2aEHY0H3aviduheVmoSbNJHP4ocGi1GAZ4i0UFgwVCJ
	fBJTl9Q3x641x/4Gr7kE8oU3eGQMFBNCM72sz1apvWlaDymhl2Yt8n/YibrG/aE6
	Hg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvvqruk1a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:54 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ce64c41efso46467031cf.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057073; x=1786661873;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ub1KUb7if+gs21AzBt8YVgkd+mkgYy/e+EEwrtHe3aY=;
        b=fZI2NWU4LE2KKGGWiEa7k/xpVWhFHt6ulKIxmvHbyj5Yrpqkft5vO6ybwIv9ortlXe
         P51yTkJoblz2u7XL+jA0xuXGdOSroft7J3VDOaJpl9883vzJWB8v2/Dlyf/2oTD+zQfs
         IQl0HFvhNmUgY9uDLKXo2p/AvRObZV1ypO8DegzIZNQirY3ZWBpEDgnTrdbMXTiYkpXK
         kMMoGCS8mtVINqMgsq4ih9pQUqLpKXYCiUKpizJFovTlWtUPAjGF4dwhXlxao9FXQhWH
         jI/C1q6VL9w1Z38OLQXBFWz853tQQerWTuRnFF1XhqjalOf6BQ8kPv8JqP1v6VB+8Cv9
         /2XA==
X-Gm-Message-State: AOJu0Yw2uHnh1SOl2JMVZYUSSkAWBXU3PflVkMoDgdEF1hLOXCWoccVL
	aW0RJJe3gN22RpUfbVDqwbXJcE5A2JjNtEii4fPhX386jUJ1mN/DJE6+Rv9gYHdQa86pDcOcMT6
	7+vnhgttfyf0z7szWLw9wiqwsmgHv8Mcg2/ewGkTPhOIA0VxH
X-Gm-Gg: AR+sD12Az04ViaN4TsntEaAcJHAlTtlLJ2ghX4/jl4isKoGCtlirifuA9qxKdFd63al
	5GPckcQ1Lxcdvyu6jlqwop0NvrWqZoRD4fQfGF8HG0aOqsCHkjzgFeAE9cnoEan2P5iDpZla4UK
	O3U4N0Df7sdS5yZq2pdyNqcU3WtoWlXQQ06T6Z7lwR3H1WylrqnLhZKsSjx7viUnGJliA0hwHLr
	O2HDXMWcB+KK/7VYZxDiqAM8V83jWg1ulUz0/sI9E0TP/uHB2MZyKD/gY4qMKSPu+pgM6zkMSQR
	yNUW2j5Wnejk4m0Yt9V/XTdBW5oC4Nuu21L+ecMJZQyKhvUsrGQYilIPasJrsB8zDz4zu/jqWKP
	VquVYIWbpi7ue
X-Received: by 2002:a05:622a:986:b0:517:9f43:4732 with SMTP id d75a77b69052e-52ce5fbd06fmr209298871cf.11.1786057073249;
        Thu, 06 Aug 2026 15:57:53 -0700 (PDT)
X-Received: by 2002:a05:622a:986:b0:517:9f43:4732 with SMTP id d75a77b69052e-52ce5fbd06fmr209298381cf.11.1786057072817;
        Thu, 06 Aug 2026 15:57:52 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:38 -0400
Subject: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
In-Reply-To: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=2748;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=1PKHkxhG8FirRaVg6eUhQjfX/h67l5IV5n+FiE4fMq0=;
 b=LaYIsHVWpwYb/E4liQkXl3uoxIqT77+VYU165HQMf12mm+fVAmPoL3b8oeU5kB/oIpD1BCKBX
 YNoKJAENtWGD9KC3ZXIJB+fPHZ+aWZrSczLZIN3orHoap6KhJHbtJun
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Mv9iLWae c=1 sm=1 tr=0 ts=6a751172 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=v-ZhwRCNMDFCt6n8jOEA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: q6lPhavApn67blNbOBDDu47UhIpnppau
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX9PGAPgLmDU+M
 jhcCW/fK66xrFkcPyiDJLzug95M/ktfDk1WvklVBJCbCIN9BGivWWXVuRlBpVfH0FzX9c6qMqn+
 sljEEgi7VJzBxTPJEtxBWB5VbdPOPKQMAXUFLFVpCNvCASJtPEcB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX2HnzfjI6ecmO
 wJwSCS5kHgBNufT8NoLEzVPCqvX4LBY+eAHs31iVJvqAsJ6HWY2CnK6IZradGg5ftMzaGLsSkqZ
 RXwjIlvoHfIhG0WEM8t9efTQIIzrNyHMAGoiPMsEAu58hZOUdNsyGydrTtDwwCpYD9mM5HyGb9M
 T25B2QR4cHE07a45w2O9u2DOR6n7dnWQ6ogD2rOLz4evOHbOm7mqk9Scm+oohVld/8GfbLV0PnA
 0lkYL0l1T1JWV7RkJMq8k/v1lrwNmf5gaoFWHwJpNepVuhGMTpHA6Jf/W513urEjAIqIihVOPno
 RI9T2A1Zmpah67jJn97w745925L7YgURwAsk8MovczXFbHFSXdMV1+UTHCjpIZJ98Z9SVWRWrb5
 rKD6GCqHsOcTgnSrm9gppX5TMSu1YMFdhgRbjIoSxYbPLlE4ee+wH1bIVGA1QiWuCRnGdj+puSQ
 YG3lmTXOCQpFrYWYYvA==
X-Proofpoint-ORIG-GUID: q6lPhavApn67blNbOBDDu47UhIpnppau
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=10
 lowpriorityscore=10 malwarescore=0 phishscore=0 spamscore=0 impostorscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060180
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B32C2160009
X-Stat-Signature: dwehofa84rwb369jxpwsdazp8zxutwre
X-Rspam-User: 
X-HE-Tag: 1786057075-10778
X-HE-Meta: U2FsdGVkX1+yC+cHCKPe6vjs0laWbfqbPuhKY31bG2gKhXjzPoMqSk9lgLK/yzh1WtWk7q+UMTKMg+HsBIU5LkC3XTdF7lkHLRItw7mLGIJLNmj9VByak4wlDoPfDheQ3JDLvYwQlXo9iiNh9QA6dqXSdkm/nWjJl/B8alyOJA9G32azS7vFjceQleD7baKqWh266X/EBmk671bBfOGh6Bi3OT8dGWOiGSq19yCYfUq8tklRoXZewPJ4EkLmGjkRkDGF8Sm/7OjcPUOASWrZ3IRddCqstfcSmwX5wI9csE+GdwfXUeyCUjSJHYiYutuwwyID/Sb/lpt8jTerr8kX2ZK/+jRntDZ+Lyk5dg2Mdp1pgsITL+cgLgp6igCk7PeuQLlWOmQz6iLJCYUyzEzfKQ0woobzBtJ4XYSIQxdEBmX4jEDpZUwmzK5Fap/fhlAZ+gU6yhR5xmYIRrVkNFmRApb5rq1xLR4ouXIbIgf15PXhpooaIfrMSTglKMO+uu8Ppvswv8n28R6i/FME37NCPEr2+DbumGL2T2LgIyo/5/gb1TMB3Y5CLgGZO3o3DVQx7K1noX5aC05dFzhsUJjlSM4LyawWnafdgKOv4/8EySCDWv91AgA3a3OD9HlXkyYOyvnvMXm4SB1P9UQ9PSwIfOO7/bjaX4JftyqjiJWHR7tG2+jOvfr8qW0kL6G1Xyb3qwGLzah/ldQUR5ZMYa0q2No2EKuuPyn8gxIDaPB41mUQA1E1HLHr00eFhhTcYdwkai6pA/13eqqaYLsY1bSGALsGMxNd4g1Dfv+wQUw1EPlzf6sBRXpjx8UCEaXwP991SrT9hwR6ArvR5S2sCj8NBvx7gTIVQyQdxCjG5dGsC5cFnZ9U8FEfrYNoKS2j+mkJE43qiQ6ZA+WhDl/G4wNy1AWo76EYj8kBZ2VMPlW2BZSuIzGY+lwvaRc6p6T17h5fFZfop3Y+yMcmA8BnMJu
 9/1Tfs2J
 1pEOuvgttduD5vf4X0ooNSBFp/Z3dFpXokol4GRXOE+AtHm6zR0Jx9cVJbUWsSsxSBeWc7/1YnMUv1XzH9cDKMm+r7+QnQYalg5YEfFeL5FrEIoEICGV7Ao+pAU3A9rOJ6HYcDo9jFCJzmMPnOEFt1xk3ryunRqSblx9/cZuXLjxkkPNcQFy+rec+zwEheY1u2l44QU/yPgQm4HmGL9wXOWvXC2Mokf4fNGo0vqur6nvxqEowSXdRWTe0cl0Zk136Ze2GIK6ivWUr2SflpqOteB6ARC6Kax5FCA/GLGGTtbcxn0rl5KY+mMDc7RzjRvjSXKk7aD2Esn1gzFfISqK3H4NL2sAgf497La+Z+2EB/2kaIWv4978O4abXTEj2P/1gLzp6nRBApeWo1Rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 84798514db50 ("mm: Remove swap_writepage() and
shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
__swap_writepage(), which operates on a folio, to match its caller.
Update a stale reference to swap_writepage() in swapfile.c as well.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c  | 4 ++--
 mm/swap.h     | 2 +-
 mm/swapfile.c | 2 +-
 mm/zswap.c    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index b18d3b7d853c..e2a269425ac5 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -247,7 +247,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(ctx, folio);
+	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -368,7 +368,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index ec580c713204..c3ff9132de5e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -279,7 +279,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dea2d3b36e06..2ff6de0a8c36 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2982,7 +2982,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
- * built at swapon time and is then used at swap_writepage/swap_read_folio
+ * built at swapon time and is then used at swap_writeout/swap_read_folio
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
diff --git a/mm/zswap.c b/mm/zswap.c
index f7c9c89f6449..38cb6a8318a5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1050,7 +1050,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writeout(&ctx, folio);
 	swap_write_submit(&ctx);
 
 out:

-- 
2.39.5


