Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE2C606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=DWNTvlLz;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=xUISRKbi
Received: by kanga.kvack.org (Postfix)
	id 398146B05BA; Wed, 28 Oct 2026 09:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F146B05BB; Wed, 28 Oct 2026 09:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2846B6B05BC; Wed, 28 Oct 2026 09:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAAF96B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:27:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C35EA8863
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:08 +0000 (UTC)
X-FDA: 85372110936.09.10245CB
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E5E74000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D WNTvlL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xUISRKbi;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMoLJsAez8jjmfPfOldc+8O9gx8lNYhUeZlbdp1oE2E=;
	b=3bhLT5btga6cbFWf1dcjawTgUqpSUNcGjqP/d84LgLdkTwul1w//w9gEv/WVeitCjt7RjP
	wLV8Zf7bKxKRa6ZQMJoTKcq17sIah3Ez9exVpgElQRQSYB8rRkvTV/YI0hK0FXrXuE/WKR
	seOSbSvRoOHcsEPRs4QrQhtWbbx0C+k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D WNTvlL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xUISRKbi;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194026;
	b=7TRGlKFeyJtvo4FPJ3ajBPQp63gdpch+80Ff+j8zFtdx9Vn9Qvieboum+iYiLc7R6trzc/
	5FRerbgXVzvyEDzJMbImVXLOrhqw8jZdlnfNxf8mUHAHGYyKnNYjnbfmIGHJaICc9z6Zl5
	ybN2JMQwcMCKY1AGC4LQ5onHLaRlJTI=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 9234F1301F07
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:27:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 28 Oct 2026 09:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793194021; x=
	1793201221; bh=dMoLJsAez8jjmfPfOldc+8O9gx8lNYhUeZlbdp1oE2E=; b=D
	WNTvlLzdfRcCYM8TuVsrDXAdGRHXiRs+DSG9PVtvbwWX6b2nmM1lNq7vNlGkA+xe
	RIiT2McFTnxlSAoyx8qjHNW7X5o5WY2+6mOvClSB49LSxnRrHIuMMW+RScM3z3PX
	/AIm1pmYLTNg9Yc38KW/7tChRoEUDtU62Ijb3PHljveZhlFBd+NqsK1bhu557ce4
	awSyE41Kr6eSKJQSFCq2BG6b+mgYkfOaovJJnepquRrZhz/8U4JmWtncxiXMDJ0t
	7LD24ccwQq7qSCPD7Glini5lyS8HFb2iitoSqEDYOACSvKU49VmLRjzLFmqeTyIF
	3YynpV60Jr9aQONNfggbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793194021; x=1793201221; bh=d
	MoLJsAez8jjmfPfOldc+8O9gx8lNYhUeZlbdp1oE2E=; b=xUISRKbi4hf8+7yeF
	36wLNCFmAz3KuPziBq2LdZi1VuivhsQoAVJo+xeQzLRAHAdWzN0OGPwTUwRuinCD
	C+hMd73w1kUVGzG3Jz/K1a2TpLziIHqBeDhmyd4l8jFQc+71Cy7sOhZb3YohtwX0
	1Ut6gYR6lm4tzBUEVJIxAO9B2kAGVByUZzsJPS2tNW6V+Btwz8KTW5tN88hLqbVs
	VBAAHhXyzM+g7qT43oPPyJ95OX3uJLA6ctSI6TxyoMsCsPAkxr6VHAmEExRUdOl9
	hjedh2zbTnQWC6dMv7nCllG1O9g1O8yap7L2Ue/pdl70UFxK3EHTz0OabozfOfxb
	ggNWw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793194021; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:kVZXL+rJKtQSwODE6h1znvTn/EjhAG+ouuQz8wgEXByhX66
	1+jZuMFKg+P7976Omtf1yDd2EcU6ky8O/zes9IE5MPsyq1vcRoLQMuK4gOi8zFT0
	Jnz8p+P6jg04jNl5hY0yA09f8jOztRNXsxOiMT0aRqq9dJlU/yMjLarYqQHjeW0s
	c/HL8KjLQoETYh9s5cR6EhlccoN41g4RUvH4jOtt1WdLrjEDaFyy2wpGOZT8XP1p
	Bnqi4zMc0iv8MNoPTdZMI/cAB3ivK6EK34Q6xy7OMu4ILPET8gpEWcmZSgq4+/AJ
	k5Y0wrp8uEIJ1NHI60Nn/wWC+4TBaFvY44OLqaw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Ya82AYZmWmuTSiNol7evorkh3REZhBuD2npPhpNY9D0=:GVgsKlGU0Tkh+glMpG6kNt+2eKyt7RJpAqO9o5peJRk=;
X-ME-Sender: <xms:JfjhanE-CUW17bYMVYk_FH3L1ZLFVU0Y_Uoedesf8P3DpvfyGJJmsg>
    <xme:JfjhalbT5Sj9-N5kWqID6_CIrg2UHCRz-ApejZe0QOLj73r9zYkT-SGKd2M8dffAV
    ZYKJdI7jcereMKJrzct6nKCQBI09LFP2Ek_8nYZaX-Gu-rMD-U3HQWb>
X-ME-Received: <xmr:JfjhasEUioNrGnYYzE7vVTngaKmgkJNJdi_uDNt28PciFigs5iIC5KIUG7o>
X-ME-Proxy-Cause: dmFkZTFQ3oJtbeS5Xmzxqx8cRlrjv1Yh8slOA2ozsuZRURzU4har3NzvqQfdXDiJJUJdL6
    TeG44YhIKoRSHAWQhAjUNewbSckPVBidLps6p/lpyOE5DjNELMP6y4F2BoYzcRKfeckYz+
    QN2rD94eFek45ZPsG6cPJ21dbZGkHSVUJXD3MvqPypqO/LX7utajemwNzInOiAwQlZEn0U
    lcq8HacUjumEjtK9Zr+sGGFEGXKR87KBhK42gVHNTMRKNYGIEBd6jm9pRkEJnLVUiNttsy
    H45ruMlExqaJ4o+knJBOH2AoAc8JvQgs0Lznf53Md/qAVo+U+x/el2l8xtegqLDmnfy4Jk
    Ht958jHBDobqdbRxy95iKq5t9BFEDlfqAl6LFNm8MWI0w61L5zsp+76FYMH/dZx6+0Idru
    Z0BAxNRAp06ax4Ej8h1L3GDIEtOeFtF/d7zRBRq7rZXRKacJ/SxulAPcTfvlHZnL4VeBrI
    mvmtxn6o2nVwff0K2VVfO6wRRcQHKcCHxovjXLzEglQRtlANe04CDAGMN/t0Dg9H/GBlXH
    jht/enKX2diQm+1YER0wKazCvqMK+oNj/lt+AXqbwjcszLEWITOhF7R2PhGmoAzeoAZ/7O
    F8V/xgG4iNybmDhJaTxg8zptNKDmUOaHjeptIZ2dStau5zZ96nnWjEM60qcQ
X-ME-Proxy: <xmx:JfjhaiyCNuM_6ZbyS-HM1OQ6Gqss82STcb2_QKeUa0N0FW9OaS3_6g>
    <xmx:JfjhamGwCf7OX3bLhdbUAbVMCv7lK-Ybi_Lj3aylpvbK-inCQqHQjQ>
    <xmx:JfjhavvXRwAA_rBTkexAP9nz3XJrx9TEkDcLlWKcraxdUOxLlVfczQ>
    <xmx:JfjhaiXQyprOWBbP-61I0j2NeUoCJf2fEp_5ZmcTGLuQIJyZ4FlciA>
    <xmx:Jfjhaq56wkAUkHwUgz51YI4uuizv0xhSNZ5U0bx9sWrjL-kJntCXTJOv>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 09:27:01 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/3] mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT
Date: Wed, 28 Oct 2026 13:26:37 +0000
Message-ID: <20261028132638.2560361-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028132638.2560361-1-kirill@shutemov.name>
References: <20261028132638.2560361-1-kirill@shutemov.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E5E74000A
X-Stat-Signature: wj5hremhkwyudpgapj88h1s71poi5sua
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793194026-129339
X-HE-Meta: U2FsdGVkX195F0Y3nwhdLWQ+U+M3CyA7xBb1r0dZg5lF62OwILC6hsCZKPZSq2YTmGa1mQWextk+DGAWrlLJIMa3P1tMczMQOXOTeScvjmL1UJc5fPIHhLOmAahL+fOIUhx8/+oeqh49OLyBS26NOxflBzB3gix20lCM6/lihNGGZ98tJ7Jbsn5hpH50/K7R5iEBDWNSYHE+oCrfYlo4XLYS82DhkcgJmZkqdScoScWWXy/T/kmlyZp2dFmE2jPUNAomPRT61Bd6h7m3kvqJFxsH50HhRV1Z+ggbG6b7PPr3Ey6pJ0FQBidlsBTRyg/AaxJVslmNsQuAKCV7NOXkPcpBYeusqNZpyCsV9VwjAGsuwvE7XmGuJOFk/p6RVYfykW4yHA4KUOBD5ZDk28KTUPV+rU/J6lOi5Ghw+/9RkLTpkhGA3KPNeQj8xJcisJ8MNsMiehw8G6J4oj8Yo8I3Ns/lrAJIn219TeNL9BbsUJ8pdT/a+oie0m0a+M6zwCGF+/eQHk4YpIp3GwRgtKjTZ+oQDeW071yw9MjTMekCEIzPfmDDwJj4ghtHuasN9Ny1JFzTgC1l4V9yedetwbk0/1KtC/AFJ29kdiLkN8Oogh8KSj+A0DPe/FX2y4gHjgWqfE1nNhRkaNlT8PUrD7EixOCYmx5PV/4nc4kjRjYGgdO26TKquvuLdrbAFBjUJEqQRLCB7TpexC76W4/QmQ4Ud7lFyDTozgbSXrxc80RzfoWlpMdAgWaBAVZf7HNlcCxpB5M1H6sHuAHokj8j/hE4Rf9DI8OV6vml1XTJzsvUP65q54s83DrxC/Eqb1sWsZ1GOYB1Q453vBD0gp/LQlBrx3HMHDALaFQaOIFZsnMBoi7KtuZaGuRHVsUK3Li8I+tLDdxFuKBoZEF6SZyBTWvT2qSIduZJuBr964q4hjz6PmVyM9b/qC+lnstIufRu/XwJd3/eF5A+6zVpRGmLv0h
 zbNYzhQA
 dPBgeKYIGKEteMQToDZuLu14sw97x0z5rDNJUPo7PylW00GZ9QlPft6daSCXdAVk5Ma7udxr8BJpGOvskmYNag1uKwdQcZaWM4M1aorZHvXOsRSPGnPa7QF7cFahVxYTjufoBCj78HssvF9WZlJaxPf+w4/go1OFJXoSpK3vxEFbTNaeihiSQguTsuO9AUzNzyTlwbBevzS4Rresn2hkMrch2iERJA0inSYS3TgtUNlWFSIMnAC0aM5j7VTC5ZIdNkgQRpnaou3sfh/NRcrRG7KYUHi0Nr3CjNWOGANX6g0W4bAqqprW1WhNMhzsgBPZTf6eFuOsKDcbvcf1mYb0LWsf5va+UaQBEI+KMVE46vjOE64Zs6IGytQLfncptswYBAVZcIur/z3Qkje02/96PEWCjbr3fmzJOe7gsOhcfT+Bn7iDmppRKbo+l1HYAPKtyuHFdC5zp6jhRCp3DNLRWT2TwxARKNKcSfgMiM5zJ59RvoArvo89W7mGtyjUAgEhv+dwfWz8rWLBOCnguKraaaG2IR4VqUC8aXDQH5v5jagTiE+FpiNMiiyytVVf57JDvFK9swj/hb5fZR9V1Y+UzXwhCjfK9Bhx6e6XpxBB+4Rjh3/uIswMCa5h+Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Direct reclaim for a costly order stops as soon as the allocation could
succeed.  compaction_ready() skips a zone and should_continue_reclaim()
stops reclaiming when zone_watermark_ok() passes, and zone_watermark_ok()
accepts a free page of any migratetype.

With defrag_mode, the allocation behind the reclaim is ALLOC_NOFRAGMENT
and cannot take the free pages left in unmovable and reclaimable
pageblocks.  Reclaim stops on them anyway, having freed little.

In Dev Jain's 64K mTHP benchmark, an order-4 direct reclaim frees 16
pages on average with defrag_mode and 45 without.  64K faults get a bit
over half as many folios as without defrag_mode (medians of 15 runs):

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + this patch
    64K faults allocated              20750          11538         19759
    64K faults falling back to 4K       725           9945          1664

Pass ALLOC_NOFRAGMENT from the allocation down to try_to_free_pages().
Both checks then ask __zone_watermark_ok_mt() for a free page the
allocation can take, and an order-4 direct reclaim frees 40 pages on
average.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/internal.h   |  3 ++-
 mm/page_alloc.c |  8 +++++---
 mm/vmscan.c     | 24 +++++++++++++++++++-----
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index ed9d4ed9b847..66f7160147bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,7 +65,8 @@ void folio_mark_lazyfree(struct folio *folio);
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, const nodemask_t *mask);
+				gfp_t gfp_mask, const nodemask_t *mask,
+				bool nofragment);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 			      int zone_idx);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7605ee60df5c..3ee1b706b097 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4454,7 +4454,7 @@ static unsigned int check_retry_zonelist(unsigned int seq)
 
 /* Perform direct synchronous page reclaim */
 static unsigned long
-__perform_reclaim(gfp_t gfp_mask, unsigned int order,
+__perform_reclaim(gfp_t gfp_mask, unsigned int order, unsigned int alloc_flags,
 					const struct alloc_context *ac)
 {
 	unsigned int noreclaim_flag;
@@ -4468,7 +4468,8 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	progress = try_to_free_pages(ac->zonelist, order, gfp_mask,
-								ac->nodemask);
+				     ac->nodemask,
+				     alloc_flags & ALLOC_NOFRAGMENT);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
@@ -4490,7 +4491,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	int reclaim_order = ac->reclaim_compact_order;
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order,
+					       alloc_flags, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fb9f8f020f63..7cfc4b509cee 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -142,6 +142,9 @@ struct scan_control {
 	/* One of the zones is ready for compaction */
 	unsigned int compaction_ready:1;
 
+	/* The allocation cannot fall back to other migratetypes' blocks */
+	unsigned int nofragment:1;
+
 	/* There is easily reclaimable cold cache in the current node */
 	unsigned int cache_trim_mode:1;
 
@@ -6317,6 +6320,17 @@ static bool in_reclaim_compaction(struct scan_control *sc)
 	return false;
 }
 
+static bool allocation_can_succeed(struct zone *zone, struct scan_control *sc,
+				   unsigned long mark)
+{
+	unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
+	long free_pages = zone_page_state(zone, NR_FREE_PAGES);
+	int migratetype = gfp_migratetype(sc->gfp_mask);
+
+	return __zone_watermark_ok_mt(zone, sc->order, mark, sc->reclaim_idx,
+				      alloc_flags, free_pages, migratetype);
+}
+
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -6355,8 +6369,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 		unsigned long watermark = min_wmark_pages(zone);
 
 		/* Allocation can already succeed, nothing to do */
-		if (zone_watermark_ok(zone, sc->order, watermark,
-				      sc->reclaim_idx, 0))
+		if (allocation_can_succeed(zone, sc, watermark))
 			return false;
 
 		if (compaction_suitable(zone, sc->order, watermark,
@@ -6581,8 +6594,7 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 		return false;
 
 	/* Allocation can already succeed, nothing to do */
-	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
-			      sc->reclaim_idx, 0))
+	if (allocation_can_succeed(zone, sc, min_wmark_pages(zone)))
 		return true;
 
 	/*
@@ -6966,7 +6978,8 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, const nodemask_t *nodemask)
+				gfp_t gfp_mask, const nodemask_t *nodemask,
+				bool nofragment)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
@@ -6979,6 +6992,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = 1,
+		.nofragment = nofragment,
 	};
 
 	/*
-- 
2.54.0


