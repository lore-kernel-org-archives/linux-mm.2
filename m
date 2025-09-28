Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787AECAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 11:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CECFA8E0005; Sun, 28 Sep 2025 07:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D828E0001; Sun, 28 Sep 2025 07:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D0F8E0005; Sun, 28 Sep 2025 07:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1F2E8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 07:17:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F5CD1409B7
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:39 +0000 (UTC)
X-FDA: 83938408638.07.2308392
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F2EC40005
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCueEjK0;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759058257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1ekZIO3b9Ttpe972UQJNalil++E0ZqVPkWGV+cChaI=;
	b=CY23ZynRrY2SifuslUT1W7y8xjwBYtskQDQTgTLaQFl2AjNhDwHdfA6/UL9U/o5oHCHXbc
	lSJ899o5prWm/z+4xmWL7jIcstoeGbXQQtew/QX7DUCpWe2AatS/t4VNVaEIn9UWUDY1GG
	lieyG7Z7dQsz7BokEnX35flGtR2XxCs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCueEjK0;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759058257; a=rsa-sha256;
	cv=none;
	b=MT0kJ6f7QXSRpmZsQSzmRop+f3Shgh+/qooYnKKK7SBF3tai7T/XK/VDfsSqZjn5TsLOXf
	aUiSJt2a9AJZQt2JvLlkrtadyIESQCmm82bgJL0mPt55xXszMf1e75+5vky4Vk9O31NWrz
	J2LQQhYrt+dcs28hS7aTe04BxiE7vAs=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-781997d195aso597965b3a.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759058256; x=1759663056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1ekZIO3b9Ttpe972UQJNalil++E0ZqVPkWGV+cChaI=;
        b=VCueEjK0urX8mUHtMk2wyoEP563qYu9yBFbXHmNPCQ8BpWkAl2ZoZe0OMTmjfNCtcf
         JsbzEKX3Y1tdkZ00kSdnXbkxSpnHXrtkN5yG1z7AOneTDj5pOBoiiTAicdxfhBU04F1T
         aI6x6B6uxpM5VCQibFVUHTlJfTfeKF48u0ePZnhbfE889y4D+sPzMp3Y2EJ33lPryTMN
         kDw7los10W0reLsv5BHtSo+wyii35NEKE0bUk0jV8Cj9xNKcdFKzwCOWrpUOlNSu6GZG
         /VorSMxpzOVV/z9oh9BRlHagx/NjivtIeOPxiG+mqF4yNzgK+0zvRDkVR09Iud1sUTru
         qA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759058256; x=1759663056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1ekZIO3b9Ttpe972UQJNalil++E0ZqVPkWGV+cChaI=;
        b=XBOHQKSotYWPK5YWEuaCHTckbX1GuNx5OUct2LryQRw90vpxGTI9YYuVX3d5jGdrUS
         luU4S9FxAc8NKhPNfbyqYK/r33Td5g9GlhV9X0eHwtK1ZEpx4Rq3oqesIVhkVG+MGwsa
         DfdrvnOOEHcl0eWpeP7VKhfgumFN0fQAKFhATnq1UCn2YP35+Nuxl3Tgf/GRZRLbqowU
         eTKCzbnu+MxYtIrwo98NhHtWMet+bZuH2zWZiM6c6fsG+Yfc+WJZ7+JLaXa4T9TAxTbf
         vu4g97SgbnTSLucY4IwKlTdRbZzdlNXrW2dTC6vf8MbLywcGcDip5ClIHRgJ3LQWTPet
         WtDA==
X-Gm-Message-State: AOJu0Yz3r0BA9PyFlzRdw6Be12V0V27fR8FtLaG8TJ6PNYgD7uVh1ylE
	IWqF+ZcEMn+fne5veN5MCZBx0FDp7zzYhjykufwps1GPMxBAXSWLdIdqaiaxD4J6WOo=
X-Gm-Gg: ASbGnctzDIXSWp3RUw+98/oVnlsdP5Li6mpGo99Xs04IETzROzQDFZxuprogy/0REoI
	1WX4rxQLVhpHu+Dl63r3ffBBDlHJCBcLJrHBvWWUu/sE1aPvJqhM34K5S4IU+AfxRKpoDfVVR22
	qpHe2eXSXXieTjMTPDfKJA2vgy0A6ILcSIBcp8RjdTDFuveOY2fJWWYv8DPjRJ4ygvCoLQAisWl
	nLWFifuqOhoH8qWCCsKXWv1SSaL/HyvmesmgSMeMuJXaFfXCweKomKuyp387hxVrlae84EV85Vz
	ao6wI+Jeq6WFO+ozX0+rkV1H8GnXBPambkjDInEWZKC7s7mRrBx4o0lIgwWfhoiHFTdxvEHYwNq
	qT5a6ACzLLTfoUCChNNDFejzC5Xr+LvmybI/XSMVhfpL7D7n8NwxaOr0t9E+GU5VMBr+3zsDWo2
	1c
X-Google-Smtp-Source: AGHT+IHqrAqU+jC+qNEzoF4LOIdPO8yTHXE2d2ywkwGRffVmCfyJBJS1CU2Vm8Q37E39F0I3wqfN2Q==
X-Received: by 2002:a05:6a20:734e:b0:2c6:cdcc:5dd2 with SMTP id adf61e73a8af0-2e7be80995fmr15796544637.11.1759058255924;
        Sun, 28 Sep 2025 04:17:35 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a2c45sm8687451a12.45.2025.09.28.04.17.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 04:17:35 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Sun, 28 Sep 2025 19:16:59 +0800
Message-ID: <488cc8d44ba9ef1ec8ed2b32e7267d83cfd5736d.1759056506.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1759056506.git.zhengqi.arch@bytedance.com>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F2EC40005
X-Stat-Signature: egz9rytwqn8cqg9436jyaf19cy5r8rnk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759058257-232743
X-HE-Meta: U2FsdGVkX1+DwtQWRBkug8hhyP3E3RrUOVOoQ7V4tYdH37OHEM2PzBa2cubEWyZjX8/k7flMOhwTFaVkGEUtLRc1SnMgA92BJPy/0bfydVL3FOMpZcsmF4M9o93D73+uHIHKViFhS1IKXIxAoz2BQL9jNQ0a5J16mxTkjFPP5raR537TxExrT8g5EvglQfcPrjCJ7QRtE+aMjugqjokL6m8JEjybI9hd6caBXWy/6Mh8FF8JskVN46LmLO1zMP0cVMI4p06K22v+WwJps/C6Iu9H4Ux5qZf097dE6325oa1AyZ1uZ7t35ahlg+99B74D5318wlWwGdcU2v78IHCn0djC/fuhedZrXs1OkyrClC1rareNN1otEe6PA4KGbSkbNhFIzkkcKWf08zuJueRRE7iV0Lxt36MoRXDAicdY0ddW0rtpF3d6mUdUiEuCpUiiEVe8RdAge/aw95a320kruKPav5jm8TzShW8uXu5gWzAc8u6bLn0nwvUsBviemM5f0ctkxrXKFoUJk3Nwma/Zv8B5h5oOTcac94T2WPeazdNN3TsICn4i7kG1jbNzpxiRh5dieEkSYMOgVx2toIqV++ACuUxGvDGXpqsdqUznpYs+lip8TwyW3gBtAzu8qelO7GGboFuEnQspB/GpqzNjb7VPF8IeSB9NqLdJaXoSC7vzO5Veaipe0mqVk/mJi/uS9mCUD4Kl2VtxfGYMMN7AEP+j60qa1ROBcEDJ5R7m2tl+gegCOaA8v6WKfIc2+OKGASTq/kPo+6YNPXBuznYEJWyRHPsMbMwt0X8PrPlZoSK2J843sywRizdXpUnDnjMvTto0aYDLTySRnerHSgiPMKdnGfEU9bggdd0P2yDcKo+XEylpOUdw26j+kqZPCEUetP8q67ExXIQEYjn0DGHxcu4rbfzGpbvxjuoxU5Pit8ILJSqyV9muEeQ2q36R8yv+dvdhCguDBE3UJxLDEO3
 6Ri2KEVD
 9CUUas9FhkSXmNFqvQ8++tCNxViHMQtObLOr4n+XeXCpHbFqX3e5kGkSOVaJT+3wEgMwbBf6kUDF2s0ssrYH6vPE5syMXz1xXxc9tjcHZTUjXj1kIgQ72mciN0sIsrfwhLlfSOVeVnCno6h3ooAm4gkWxIym/qFMjqYtzVXp1zb8evFuKOPqyzfLhCQuPKtNRRUNLE/TfQs4x3wGETx4UtkTzLN7S3yWi4YwOK13y6VpwZKlMqq9Ms3f/aaah4pqQ1fBjb8lYbEcspkEj/R/CIvQ35/YY1jtW57g2+yyX7m+UuAhg6wsLgO1iZITvVNTrDBLn+Ls+26bNp44VGK9P8WyvOFF3vcgWFEKD7Eu3Gg2Le3LelIK2LYSHLypCYhAY9lfGXNDojz7S1/Mq9NngW5R5nOWss2fHwLamA3L6QZ5Uc0kNMjJ3jv4pr3Tq6gfcN82FTAXEDQohYMMoEcFclorXdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225f..6db24b3a57005 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


