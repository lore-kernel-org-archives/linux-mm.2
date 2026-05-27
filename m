Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91187CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED1C6B008C; Wed, 27 May 2026 03:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E8B6B0092; Wed, 27 May 2026 03:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3FF6B0093; Wed, 27 May 2026 03:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A82D6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:02:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B4A61C0402
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:02:53 +0000 (UTC)
X-FDA: 84812307426.19.29BEC32
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF3CD1C0008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:02:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="e//4q0U1";
	spf=none (imf18.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779865371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NvR3YFJF8Y8iU4J/6e3/E0bFFW+ErgeNUyJr96l/GBw=;
	b=4CTeeCHULLtuCaHgKEGiiNOF94oXAIHvCi1ni88eT0NAJX3auSfwkfRsP/23RP55pSS3my
	Y+CRFQARgF/SAZw+aTGvv93GzN51uowQlgZYKbNi4pR6686074+/VOiewZ73diZTUHB/jL
	Pym1KVv5wPyGy7+FmZvGCySyliqgpYw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="e//4q0U1";
	spf=none (imf18.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779865371; a=rsa-sha256;
	cv=none;
	b=wbf2oja/cinjOueSrfDMaBtmSI9rNOd9kLSzlY1Yift6W7qwf/53GGNzsJNrdQEvV0I6mI
	fKsN17YggMePINAhmou8L7sUkg40DVhRSbi8D4QgE5EN2DAVECBCZV5LR0hst5TF2S/Z6A
	HeucdPl/CT1IaUKo3+mLkmi/nwcwpWA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NvR3YFJF8Y8iU4J/6e3/E0bFFW+ErgeNUyJr96l/GBw=; b=e//4q0U1ykdmFjfwjG5D6O4zjy
	bfxRclqUynP5c7s+t2Ui2skJtg/B1qimJCwG3DTT8Vp6ka+DW2jhtnjMYsaOfGhgYU6BJi2GTVB9w
	DQzeLfTY1xBt9ANc4BN3+KI20ekUvh+nJVkAiAg/P9bYHmTgzOHBNPqKsqua8AvKleThe/r+P/nID
	v4BtYCt7OiqLzmaON6udfJDGrHQA3KtsztWHNmqmVlC11unAfXRNP+BpQHqlqDi2Da0kdKX7NxgP/
	xjm37bGqZVbtAHGlQ3XgQ2/euq+aCFIK419NswGCDg/ECo8Zh4F685E5drYjA9VlLDZ+uZJsshRtH
	1eulWmBQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8Hu-00000003R0P-0SjZ;
	Wed, 27 May 2026 07:02:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: improve the kmem_cache_alloc_bulk API
Date: Wed, 27 May 2026 09:02:21 +0200
Message-ID: <20260527070239.2252948-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: 3f7u7suiyuwjjc4qdstfnijopypbsmyo
X-Rspam-User: 
X-Rspamd-Queue-Id: DF3CD1C0008
X-HE-Tag: 1779865370-427160
X-HE-Meta: U2FsdGVkX1/90HmQ5P3+UCc/0vSk/WYt99y2j2+UIVRFCqMqm6OfsjQHmm+lHlqPENRiESLKVjC+eYuFaQr2k+feQqp3Zjbgw+n5p4S5Z2BiX3O1gbTCGLKkLt1b0skVQ6q1lWbYKhx75fGO8mLuh6U6VAwGaRqn7UmQAI43RuuQ0YQK8vBGWunBLJYh7MqBpapwwwng1p0ZLgvv9WiIRRXD0E5vA/S00mBF99v2GjcTxUb8tlBt8ll8uRzvNFoVJ4XLqJhxt6u5ttaGM/7abMOOSZiMvVgSEhyAYiDoOJzh0OVYWXTE1xkSuGQgA2CcEKgHqZH6gdshMKDfF1OHjzd4p7mlkc8u2YnjdH5mrbj/vo1DPXLSbeo6R7mPqYLeYvE3/KMaR1DdV4zqYM/0ki+PNeqmbSZariJ7yYbWSn2lRuefbau+p8POopHgEWKxREjecyekgCtc9asa0WRQdBb6VcKjXBjZMKYVlus2T94RAYTSbiJsFSfQgXYV7mQwXwIDVBZqwFcGasCi87BCa5Ycic7R1AC3ZNHlJ20zoxr5BK5GENPazPrBas0RNAWYlCFX+vYqXpyJPY2L4asA8s9qUhvhaSI+yoPIv0nt+v0OB8fBWao2qWB/hozycSsZox/necPp/dEVIbAcmD4SsLk1yNl7Qpk4h/uI2Tos9cbh5If7WcB5M2s+sl12cGE/7m9BcOe3SVQfur9dXaA63eZTEI0SyicPfmFfrUqY7zD9mexW8z4MADYrwYgX6PrmHHIv/LQsT3xXY9MAOMA4t+2ZT51+uOhoHFOYGMNGK1JPyNXb9z0b3uBw9Sn/p2bVqM1hT+j581s3Vi8E9OS1vKfJwdD2Se7Ql4soxyNir/MjX94iTQgI/RUUgcZKUt7rVTWcY5exLWqbQGZJmblOH2yMRjVUScpfHHSucv5xxTzWwzGZqZAe/dLgTjXC2yEF6LzdXH163YQ72cIUbP7
 64oIyzKk
 YzvPk81MgFXl6pA+Uq/5j7ILAdTiosDcUjvSyUKDEZlJtk8+m8aZ/yNsNca+IM5ulNDS7GJo3WlF7YHxuM/a3P2bIo/848ZMGfCDlYfJq+JoDYhPVxny7g8PwUr5zgDmVBEWY51SxwzHqXi0aRf61o4qVrZKZsxxy0tv7G0m3ASVwg7b+StVz+L5rRCjixjIsVWutUMcTzs4X5jL7TmQLE5bjYDwbf47iEHgPH1RAjNZVhk6DOQSH5UCba1W6ZnhCQy6Ly7q0mW5TCS3/+lnlvi8C0C2vVpKYqmii6EsWLBN+IH31qj0gB2Dlkp4GtkWMqgPf0ZeDRjkYf9woxPeHvsa9O0Uvi3yED8q5WrHF4EK8f5AQP3//rbo7kbBKpvXksFCENQXYMl00CKfc77HjMtYQJt3S/RVZZtACBs4ekFyI0L7DU1Sq4QLx+dkiGWC7sKdeCYBJn6+IxDSmjxzyHCqUIPf/J8TA2vyPn2fracxBWa+Qp+4YViTC0mstBkzGfCBoforEA66y8dZdXZaRL/+eTA8KTBgsvVJkivB1lj0sC5LOQxPEzrIpEXqVdGUJHsOAxpUYRTM60VM9fmQOJjTofLeyprvU0xyS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

kmem_cache_alloc_bulk has a very unintuitive and undocumented return
value convention.  Fix that and add documentation.

Note that the few comments explaining it mention that the gfp flags
must allow "spinning".  That's not really a term used in the memory
allocator, is this supposed to mean "block" or "sleep"?

Diffstat:
 drivers/gpu/drm/msm/msm_iommu.c       |    6 +--
 drivers/gpu/drm/panthor/panthor_mmu.c |   12 ++-----
 include/linux/slab.h                  |    6 ++-
 io_uring/io_uring.c                   |   23 +++++--------
 lib/test_meminit.c                    |   19 +++++------
 mm/kasan/kasan_test_c.c               |    5 +-
 mm/kfence/kfence_test.c               |    9 ++---
 mm/slub.c                             |   58 ++++++++++++++++++----------------
 net/bpf/test_run.c                    |    7 +---
 net/core/skbuff.c                     |   23 +++++++------
 tools/include/linux/slab.h            |    2 -
 tools/testing/shared/linux.c          |   19 ++++-------
 12 files changed, 92 insertions(+), 97 deletions(-)

