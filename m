Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CD0FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5446B0092; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97ECB6B0093; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1C96B0095; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57E2D6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:47:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07F3D16074B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:48 +0000 (UTC)
X-FDA: 84703254216.15.B784C5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 51A33A0003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cUBNH1Da;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777268866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5hrwim/hNXfhNtfYHkmQC0PpZKbYNPFezxtkPUxjDs=;
	b=b/0+U5QTXqgqW3jsAnS/c/J0W1YA1lgEC1e+JfBfAY3VXyq/xKYNpU0rCci9HS7qdDtK2G
	zCGHOb94PwJCFySH2+qFeSo1ypCqXmw1DaarKRCmh1w79AOlU0rbqNL2F9mZXtxjd8pVF4
	djGW6kB+DbW23VdRf9k8Pi5MqnZrC0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777268866; a=rsa-sha256;
	cv=none;
	b=loXUnBw8I8XguYfeoYNPz/IuO/mf580YycPAqXXJteGyL/9HaZLdWBzb1av+QiibyNdMRV
	eoE8R5YDqyNmg5DO2UZHEw6MvxVmdxi9QpWlwqO27lOXfJBRpIeXlfnYUKrJaGSK7/dWoP
	nFX1p5IWq5mLpvwgyLph66Og3Uo2v4c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cUBNH1Da;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70D37445B3;
	Mon, 27 Apr 2026 05:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E985C2BCB4;
	Mon, 27 Apr 2026 05:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777268865;
	bh=s6RWkj+HUih9pUmMqw2vjrtv/MWn2+njvQOUZJznKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUBNH1Da8+rgcNrWLu/NS8WKGa50Nfcmuq/qgpI0tS114WnTsOpODhMiCubEqJOv+
	 DY8eK0USdbnNsPHRoAsbxIrek+eLAti5oijZpfZDu3HTbgw03OyaM7F5iMfuEU/1I1
	 yw1vXE0rW/iLqTA1GWfmoV9RewEExjj2BxJvth/uH/4xpVrajB9GWgseBX1QFNLLNy
	 3m6ZadlQB1q9Ziuounl2qn2BF1fO0NbMl1EqEtXUnYz8/hxsg55Pc0MQ28cn4QNtdD
	 h5NdPjidWU+BuPTD5Bnh9dLYOKmF1clsELiKndcnp8pcJ5PVmLag3BtOFA8hYJK6xI
	 GLtMDrattAWsA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes 2/2] mm/slub: return NULL early from kmalloc_nolock() in NMI on UP
Date: Mon, 27 Apr 2026 14:47:35 +0900
Message-ID: <20260427054736.566559-3-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427054736.566559-1-harry@kernel.org>
References: <20260427054736.566559-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A33A0003
X-Rspamd-Server: rspam04
X-Stat-Signature: ggz1jxcd3fw847k1jneemrxzizocqqx7
X-HE-Tag: 1777268866-312276
X-HE-Meta: U2FsdGVkX184FEoPXpXJoRF4fZ6pGbhiaoidqHUKYDQ/WYv3B/IGkSjZ8nPUAOKHSZX/7zLE2egLzSMvDNCqWXo8tyrVn2dDatDE0QyQ8Rd+baRYF+08aurYTawmuXMPd18qs6nyoPvzSV+h1FyGZ+bEjUT1esVOV5cLD30Vb5B5z6RfSztSD1aoN2pZjUZgehwtdRLH3SE0hwDbhn401RI7vXUL2GZGfR7ydFIoPgYT0yRV6uwwey2iZjxMhaAZUNEMQzbgyMgIL71L/UlRPNrX0vy4znPqIg7/eUE6Tz89lOJ/bUUe+RsbN3+milVjFaRddoFS9Hp8hGlWXhUBxTiOmxMVSPP6laso9zRGCoRTSnI8KG6WQ/cMy1YOXNXZJsR9tC8Mhbp/FkvPrDgre0l4aQZ6nu0EgM5By/haFktDD/3OXykHORZFGVIqm4junnZEDzbfBF2+O5YN188a/dRa3c7Q/2sQ+voT1hCgj4GlFbtYS2UVPtrTkf59gy2qJK+agw7f2vWm4T1k/dVZbyG0YB2U0RY1pwGfANirpqlDUFk/HDRIyct+3i/hMdHVi5jOZnCYEssZPXISEC7RfRZQwDQ2NNL1UXsqHA0584msETzFs7zJRhpJ8X8ZHJO9LUZZgoJBfblCsirflUlwOrRHm5KOIZ4qVxHBRbmB1dJcOVFPRHagt6tHa+mRjfLKFm9XFuiO0uCDuTGn5YuiCu4iKHFsr2OwGX3VmQDetMZwpYUrklL3hK7rfJbUGBd2cSriOTE45W/CKT6NHQ/7OKA5vS6uKVr0gaPtK/UucfMyFMdnrTtfQiWuDLM+ImCLH81CWW4fzA1ucG5ONsQChfWJxY3PD+w+6ucnK0IqZ//Q61zfaBMi7oJTfWeEFDpnTFCG+6+mPm9MyYqXUiXNbZEdDBUfZ6u+T0Mi61FieczTYhXGdS8qPXacV03HgmUyvgg4+KaPKzNW0XdT945
 B+uDFTNk
 PM0rvhdBaUPto51NXSWUo6RPMKl/2sjrAeUPNOdWuIkn3XjBwXHk4BMt/+dyaaqV1z6yfqM1/AiyZ35GR58WDfeYzFORymnHRLnkKCVDeRK760T72fJLP+jf35ALjq56fMrNAf5nZ+azHl7Dv8UZzfF7UXuK8vCpSrgGLS11nmfCTPYY1qoE6+Di2NGJH9iYaP0X8YFZ/W6A5tI2KokpRkBwFnaI4aEGQ4pUepx3yPj4aVGj8mfb/huGJnvQ0tWdu2Y/dodyZZUM/8sZC4dAXPKFsow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, kmalloc_nolock() called from NMI context can re-enter the slab
allocator and acquire a lock that the interrupted context is already
holding, corrupting slab state.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   get_from_partial_node+0x120/0x4d0
   ___slab_alloc+0x8a/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 92362eeb13e5..b4ec15df92f6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5339,6 +5339,10 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-- 
2.43.0


