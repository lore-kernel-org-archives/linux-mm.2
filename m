Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C72CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA05C6B0088; Thu, 15 Oct 2026 08:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51706B008A; Thu, 15 Oct 2026 08:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FB16B008C; Thu, 15 Oct 2026 08:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2D7D6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:51:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 498A9409AE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:51:05 +0000 (UTC)
X-FDA: 85324845690.18.AEAAFEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F518140002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:51:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hu6C2j30;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792068663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Um6CkdFgFUiyKYnZ7yOGgIt/JttBH/B2psH8qXvtys=;
	b=rW5RY9XYnG4+EFrRKUBc7XyQD4ftAXY0qx4RfPXM2oOcRIgz4Xkoo1cUMPjGPeEagAupCB
	e/6REVlG4RTga4qlRT+QeWgEnIOQggHlABiskkMNQqZqY1ocNWQcK6OCbkJIkwHDGSFVj/
	vJpWYcjS8Co8wFYc7PUXwUSr4+pQwH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792068663;
	b=hKXnKe1sMlxxvhajWAC9YxuX2qXziCuLuCNIm5eUGc/AyAQy64p21PjJf+naTtEjX+SJAG
	FPAUR1UAuYdMXujYb+iANsc+ugKgZ8jRCMnCv6SR3kpDe3erWOPNBYyYJ/xNp4PwBYbQOA
	LWMT/y61tYMRHxoLXh+yi8t//JucSms=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hu6C2j30;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C5344055E;
	Thu, 15 Oct 2026 12:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A71F000C5;
	Thu, 15 Oct 2026 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068662;
	bh=7Um6CkdFgFUiyKYnZ7yOGgIt/JttBH/B2psH8qXvtys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hu6C2j30wXNnbuczWidEmYA2tYA8h0HL/8ogd9tRkF4Is0v1xLiH26FObqD9Fi3gc
	 3DT603vtut5x6vtlR2/ZZErENSa8sCgBksufnasaVoaN6Aa7afy6Iy1kYrSHtiiF92
	 QV+U3JmV/SLApJOhRXO1nyLX4w1QuJolPip19JNP9m9WGhd8A9Xm1Xo2O1Ko9MQQjt
	 jp1nVPxnbCgPTp5/enFIAbrNo9v/0gXo8SOB/3ywYUgxVBZRMAsoOGS6aihEDWKHnD
	 ZT9nRULIIwhjlNLVcAIDyg5DFmM44qF/i5QrFZv0DH/J49ja6ahtRy8qBgag39NQJZ
	 x8IyrVAYCZ5QA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 91CEA198003A;
	Thu, 15 Oct 2026 08:50:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 15 Oct 2026 08:51:00 -0400
X-ME-Sender: <xms:MMzQakR0IF72dlZ4HsQ_UigfElwBAi5-kJG2Nq8h4ZXejiLJjUPl2Q>
    <xme:MMzQakK_aEbQ6kWUpJa1nzJHnnKLzCyroXZz95EqNc9TnAbI1XaXXz1ZuyD5bR-Ar
    _uU7o8esZeIVOJjrggfxTLwY320zY_YFSk6qhodR84cFWBvO4TCeEk>
X-ME-Received: <xmr:MMzQarG82ZwlLWm36rWKCazDk8rqnagziOZx8ZQ_TVqLFyi9qyRsZpanYgw>
X-ME-Proxy-Cause: dmFkZTGYpibDVUZ03mxVIum9EHYrtGYOQn4TWhgXWuWTE8ALD1yvxSQ55vrA6jOaYpis1s
    eS1Fo8Mjgi7ucTvYo9aIaXtOB/73L1YM4sCtarqJZqvGWCcTaMxfc7HBxZVtKcb4wJvczJ
    DhWGHrpbBlLD6ge7X4kHBWKewvm6YVYsr45UakZ5Q7HzmsGDeJz5eRFyJToaZGUUTIwjiJ
    yalidQOWiPKcNzTs9pKQ7mOgU4SCuGwVAYQlV41nKioPZgy9HanYgoNCcWM2YM4gaw9TNP
    mdJ72gP3f6FG12kya8a+TGGjVcnp9Lok8H/20qPi80IexeX8J/hf2KI4CDbytSCd4F1mUJ
    JtvWfWJX2J+PDTRIpyCkiU/p4ZK7j0ildAASL/a4jisJUFqvA4VooHn9uNFYYxKsEJfI4S
    rSwrV6wUbwsYIIn3tVsZtpasauV73VGEZRZ49ngUE2b99FDhpIoAozH7GXQOiogAcJNS8+
    DnEgDZwKE1awDWKAuQDYMum9QqRIqsDhcMiFIctw1LcpYZV64AULTeIbHGkp7o9Gm+YN7B
    ZxW1Z6zG1AUjtItBDbdXd/IgJBVpwju24VFpuMr/5Q36mi3uRQVxEUAI9YGv1U/0XJJHuj
    JeCbMLrTA/D6HN1LcLdhop93y+fiheEVISd3AcyjLbPfd44aCxTbDXevs0ig
X-ME-Proxy: <xmx:MMzQarIIKWVPhU3P_F4pN9US7en8m23-GcvRTeu3GHEyQ60xBGTfOg>
    <xmx:MMzQav6o05HUtsc2wfRc8TCtA3LTflDIv9sxh0CUNo8Sp6yis9mgEQ>
    <xmx:MMzQaslX4HyepFWK6-873Jo7lrDtezkVNsh0vFLzjDqFly4d9tvpTQ>
    <xmx:MMzQasSMTjuKD4Y9V6salpe5zd1tz5X6igUYJdJtebn83pv0dO8ygw>
    <xmx:MczQahhKbGrNgwbwiREVVR_uNxM75mkZDGAeDd9HN_mewaIWNneCvGLz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 08:50:56 -0400 (EDT)
Date: Thu, 15 Oct 2026 13:50:55 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <atDL-nSFP2KVU7cI@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014202936.GC371161@cmpxchg.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F518140002
X-Rspam-User: 
X-Stat-Signature: bjcracctx7yt6rt3xahd1adya533399i
X-HE-Tag: 1792068663-920006
X-HE-Meta: U2FsdGVkX1/lTOE6p61y5UEXOIvL+3jUj/kB+xY9zMMPGGIPL8b148OrIPk+XI2XemgkUjJBElemm/f/mn2ows3tAepxhVp0zSeUJPQdhEejuBga43WbfXBquJqVCr1BnNhPUYeCc965c/UnMoHn3Pq9irExYACet1wzrH/SF3TKuKJmSlJHlL4wKYI8S0HjwamS/pQfyxxYDU6220cYn8bxZ+EWXsIGc8P62vS4hUGZGuQ5JE8Z18fPy2ObczIblZGfzsSwCh/Gke924cJRnAMULmLKV+08wG5Y1UNfve8C7wi9LIrloA8lK+BY8TgpLNx6b7wVupfCToVR0/d1lCLroB62CICOfzA1SI3n001B+qb1x0wNVrOLzCl1H/32i4Gf9BaxpWCx22VJq0m8bwhi3TWJ54mICBszfK5Gako0wN8MH6NJt3PYXS8o+CTljlLuFHKyBzAEqv1Bh5ASk29ZqBA9+x+5vfOr9wL6g4kYTu0/M9dbOMVTEa4Ny0VZiOxRDInC3jajrMRWgajW0XjS3NSC/0GpZfb4T6j8v/ORtYE18VkXXh4fnE77iWX2vvIDL9KjeDGWeI5J2jguw5mUACoF8ZRFTsM+b0+1pLyOYRPhbpa4HInSfZ+9ljkwYGEjX4WgdgAZH/lHGzu0ong1TpdA+NmL7snvUhxCichSdv+71CDt92IemcRmbKtvTeHkc3NAXksAqadA+9MpdPOVjuvF5kPscSiUi63e1yGVMcpqvJzZK98kE2exI25MCT8YJWE2loYDmx9+GAXj+GqTvK+33m0NIGl7Y8HIBOdGArxHqx7+rq6K4Dnx7wWiL0qXoPxmgClgDAecclhZgIxgVpigPiRLXi4M3mfkGsAJlErcmFaiPCx1l7+J/VfsMQX5ezZRb14wrVOCmGt8U2MnERH4SEoynX/yd71K9Xb/TaGRk5BokRjvSE83Nusl1rxU0QGPxooMYQ8b1Z2
 M/knBX3l
 5QPFgeoHzRUXmrlXe3OF2ls8SYKW57cphjmu0ubU8KgGbVly2rnkrT6OA0JWbfvN+zcYGPVElQIV6jEB163otKEzSiVK0JrLs6iWv1nmMMRfzWFli1hW+QebYbDd66jlSz16pbhROjFEbjxBZ5q7BpBj4cvKkhR6JsWeRydV388eEamq2iqzFtG+rQvXiDLc6Gi1hkYxBuXiPhsjJ7u390DhcbM6SH86FfJZ8TvcE31PQ2yO0fJ6Q+44T95rDF5rdxfP3TxuEQ1nA2krPQ6PEA13FnkwlUoZE/S4+oVHHhgqdNXtILD6TLPE9lqzFnevkbS95mdOSiLXcR6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 10:29:36PM +0200, Johannes Weiner wrote:
> On Tue, Oct 13, 2026 at 06:37:20PM +0100, Kiryl Shutsemau wrote:
> > @@ -4127,6 +4127,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> >  	return page;
> >  }
> >  
> > +static inline bool order_nofrag_promoted(unsigned int order,
> > +					 const struct alloc_context *ac)
> > +{
> > +	return ac->reclaim_compact_order != order;
> > +}
> 
> order_defrag_promoted?

Works for me.

Andrew, could you fold the fixup below?

---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c593913a14f8..440e515be50b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4127,7 +4127,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-static inline bool order_nofrag_promoted(unsigned int order,
+static inline bool order_defrag_promoted(unsigned int order,
 					 const struct alloc_context *ac)
 {
 	return ac->reclaim_compact_order != order;
@@ -4260,7 +4260,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
 	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		if (!order_nofrag_promoted(order, ac))
+		if (!order_defrag_promoted(order, ac))
 			ret = compaction_zonelist_suitable(ac, order,
 							   alloc_flags, gfp_mask);
 		goto out;
@@ -4642,7 +4642,7 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	 * for compaction without freeing anything.
 	 */
 	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
-	    !order_nofrag_promoted(order, ac))
+	    !order_defrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -5024,7 +5024,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		/* Retries went into making blocks, start the fallback afresh */
-		if (order_nofrag_promoted(order, ac)) {
+		if (order_defrag_promoted(order, ac)) {
 			no_progress_loops = 0;
 			compaction_retries = 0;
 		}
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

