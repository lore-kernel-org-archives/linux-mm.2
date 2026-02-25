Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B454EFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2026B0089; Wed, 25 Feb 2026 11:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FC56B008A; Wed, 25 Feb 2026 11:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC6C6B008C; Wed, 25 Feb 2026 11:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8BC86B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:41:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B4E61C1A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:41:56 +0000 (UTC)
X-FDA: 84483545832.22.BF83B41
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 94DAD18000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:41:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="JrMI/oge";
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Fxhu6JylkiDzMEjDuKttQE1tDuQQiQGKZbk6dmKVauI=;
	b=GvL+hdLNtLzJEDBY/lNJIp4sVew32Ra/kSSVLM9ncA0eQwNhpX/t8tILXEl1K0NXHZKWxa
	xGIBLjyhA+uwkAOazWW4k1XnNgXfp+yng51YsgU+EWx8HOUPz82Dnb4D4bfxriOTW5JtJB
	AKifTR82P+37/yyDF+dPpSGrnl+qbGs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="JrMI/oge";
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037714; a=rsa-sha256;
	cv=none;
	b=LjeYKC3SlM3AGSBOajl2Jmoc6YtCEIWEdUUJjaZNatpwAYneVm6DeBfsEYDar9yeEipxOq
	34bWmDVtFweVeqiolgLfiYKuwTNn/SlQQOsoV3pa3stRtlVEKiaKlim6j/2r3EbapMGTKk
	4jpu4T36OB24JsxhReP/vEsU04hxZiQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Fxhu6JylkiDzMEjDuKttQE1tDuQQiQGKZbk6dmKVauI=; b=JrMI/ogeMG5ARWoH7nHxTdwz1c
	1WigUWPSDL/tBc6/MJCvGPEsYLso4MDLWEQ67hdA9u6mxgKSfEZck3k0WZpk5nP+XTLv3e4euQ9Rc
	fBhqQppdIDwa8rLrvOx3oqqfp0mFjlpUXwtBa/Rt5TEiE8fhekPjOMYGdm5lZZNShw3QAiNGaoqCx
	KY7VvhUCR/rpICJMpLn+Ge/NN8wawNIhBOfgMY8aq1Hwv71R1U3szl7eankJB9q+tkXgkoeEjXN8v
	RJt6NQU5eOzDbWKskkRx9IIz/tJLs+/KLyMShzZoXtmfMOmbr2uSZCk2hhVovwxujRt+800kJ8VK9
	MOuFv+Ag==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4m-1vwH;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 0/3] Make memcg location more flexible
Date: Wed, 25 Feb 2026 16:22:14 +0000
Message-ID: <20260225162319.315281-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94DAD18000D
X-Stat-Signature: fdpwna9ne8ud8rxg37n3stz1y4d7yibm
X-Rspam-User: 
X-HE-Tag: 1772037713-109607
X-HE-Meta: U2FsdGVkX1/UZjY27FIy0Hhpv2iZ9adfeba22aHQHkZ37ta+GNKO0XSFlRbEGew/K1ZY1vyoEK0ngH6O5dFSSuZA0sa5KICtqWEY7jar8AYCG/9Ccn9zLXkqBd9xbK+JhMUSY2ViU6zeRhkrJfVeymRi5jZPEQi9DYo9mUgIQvMY3xV9Rr+1wo3p9nyQkSgmkPBCctl0xZ0bwRcxi90Q5aQNk7p+cZnO8S4EmS3Uy96R14kH3knaRKYicjauLK+ewMId4Gm5k5m//uqMdA3WY1zqkPUx78znUdEgPBuTK5V0c4/JhpznUNdzKFgBoQA4/4cfN8vUiuoG6Ks5orOT2wNJ6FcSPCCbwmsB0hsVURSSHvZHbXnHXZ7Wq4dfga9aw0fKvZo2xm3wYjCVa4jj/B7A3dWzbfVoECUk3j5XQod7mfaglXwJT8Vz2uW3z3dYzvvWAEet73dGtDfnMHntLXX9ccbKP3ZlLTOdmor42wbP4K5A3j5KQEPMijB7vmc6coJXqJv14f11yBJUmw217GLK5eNWHo+3xc2NfGvYG7/HF3KqLAmlfTMGq5IEzmkg80TE24HN8tYcyPyY0eCTNOQXDvZ0f6TkgIJ8c6+H1Bs0CMi/BXdIRgtC7jURLnOdm7lxpDi+BNakAw3zV4pX1RPA2ErjGyNgrSBPqZytmnorLu/NpcVC4d9lKS7TgoarLv8HSeguBq3BvxZjDpptV8WTJ8Jyuk/K/jQQzXqwnWNMihEWdOT/p1yLVgMVSHNcSxqJM+CrlgFtyea4I6tSJnd3FKRM0EGyZJvNvNN0oEVaNquCY2DJVda2L80P4H7gvjyR3pd00cRJufsLwN0OxehHtpt8q06lue8mztmxek5mkCtIu1ecuhYIya6PbZLsw8zhFQIzk7/tZnX3Gp9wXj8FfEn6OC0RvvphFRQnMdJ3hJGUcHbVZzbRFHxwRPaKfYI1/xNCPGmxxgOKRUQ
 Q7uowp3q
 45zKtDjD037S9N78CsZo/9UB8DgTV50GNc9889w24CcPD5eOgHgRTieH9caz6xyE3CtR1o7yg2LQudFL1S0e62qZxBTM9Na2pzr8XJjWpik5bL2iGLDXiUB606/Lq3JecYqPiE89kIAg7+gwFhr5SII+YhZOjx57APBBB2hpOo772p3GjzETIU8V/YAixv8FrNJgQEKn4gHCRnnZaJo8EY1Y51bSYmP4ZtPISAUJesHX11mOnX0I7oGDtxmNORTnIiFkLgo/aoeVZmdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Different memdescs should have the flexibility to place their memcg
wherever they need to.  That means that instead of indirecting through
lruvec_stat_mod_folio() and extracting the memcg from the folio,
we need an interface which takes the memcg as a parameter.  It turns
out we already need to do that for slabs, and this memcg_stat_mod()
interface also works for that use case.

Matthew Wilcox (Oracle) (3):
  memcg: Add memcg_stat_mod()
  memcg: Simplify mod_lruvec_kmem_state()
  ptdesc: Account page tables to memcgs again

 include/linux/mm.h       | 15 +++++++++++++--
 include/linux/mm_types.h |  6 +++---
 include/linux/vmstat.h   |  9 ++++++++-
 mm/memcontrol.c          | 40 ++++++++++++++--------------------------
 4 files changed, 38 insertions(+), 32 deletions(-)

-- 
2.47.3


