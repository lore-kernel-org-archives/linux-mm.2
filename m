Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F9DFEFB50
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA706B0092; Fri, 27 Feb 2026 08:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B246B0093; Fri, 27 Feb 2026 08:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C506B0095; Fri, 27 Feb 2026 08:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326956B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF95E1C83C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:34 +0000 (UTC)
X-FDA: 84490303548.21.CBB9F58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13E1FC000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spNxsULn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198612; a=rsa-sha256;
	cv=none;
	b=Y1dLC9RMRm8id86NXsS26QB2+Q9fvbxG8gucXyN2YRtF34LQEAKK3Wig7jDr+5p3x5lCl7
	eVglw9+FDIWXW26ubEHP/pOcLYKE8k7PfI5xqY+rqy8TigNvz1s9K59u30x7Sd3zvZ3e03
	Hm6x+FZcv12Wr+MEHkyQjWvidE4dsuI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spNxsULn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YChmqxgQEODe7Xkr11BDu5N/02jpRFyysUkivhk9mx8=;
	b=0J+YE62rQiCfXOlUg3ZqJHpXVZ2q9rJDd9/IgMwfmhGfs+CPDqgjQMaV0ujQSFleFbm5Xo
	fGRhI5P36/qOYmjMzD4QnEHsdaBIxy11MheL9s8GPiXGCyrVW9qQM3ST+paCBb9CSIQFlJ
	BcdV1yTOXMMi7LQuMv9UKKUW4RDvtPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9146D600AA;
	Fri, 27 Feb 2026 13:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55AEC19423;
	Fri, 27 Feb 2026 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198611;
	bh=lF+i+xxz8lYHMRYmo1vByp6VuKj6IU9jz++U5QsC7WA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=spNxsULn1c97LGHfoREc9Ejotyp/5sCoG59B6vC9RQj+/XjyarKa3hGB3DhBOdIga
	 +5JqtltDrqUpLXSDXp5d86oY74y75IPN7C99GeFXPFuSIPAiKhJgqDrxZ3+/0VEwOZ
	 Ja3YeZ5oEl8o62bccbXR/JkUHa3HdJ1l+VGYZ58VawsDVE4RmqNF9w9OI9z8vW1P8y
	 WzVVYiJbR18F1kwzNOR3IzYTPFjx3TcyGETrFoJKiW+ilIQQLbyeAs1c2kyoTKJz34
	 +okLqmjo4XyyGZT7glMb0h+miMm7mt9S2PAqvdB2f8BQqzjLrL1WblPemNN+U+pe2y
	 z7sZua2/8u+9g==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:44 +0100
Subject: [PATCH v2 5/9] mm: cma: Export cma_alloc and cma_release
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-5-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1246; i=mripard@kernel.org;
 h=from:subject:message-id; bh=lF+i+xxz8lYHMRYmo1vByp6VuKj6IU9jz++U5QsC7WA=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+3UDXM3YsozKdlkntAT9Pi0ZKBI6evPP/JLvrfmT
 LVoLJreMZWFQZiTQVZMkeWJTNjp5e2LqxzsV/6AmcPKBDKEgYtTACYSPpux4VxNT8HVPpFC/S0m
 TyYt9eWXbA5+9quamb1LatGC59G/5vVpNT8O/O01NaD3cv3045wbGOv9X2872SPgU7PmTpGz+pc
 7IfeFbaaf5F9e9J6jR7M59+jbn01b5n/OXc/gfsbv70qvt94A
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13E1FC000C
X-Stat-Signature: 77zbt8qfwjpd4qabq7zdmztga46eettp
X-HE-Tag: 1772198611-989578
X-HE-Meta: U2FsdGVkX1+KLYr6TZ6iPiJTYr7LFTlZKbJCWvCB0lu+FbnQBO0ZsLWiUt+tuwH4VouKJ97b+CDD3QmHNfjpY19IH7rjAQue+3GxjYMhmk0FVknYUU4+kl/QLEMCuJBFAzkXDtx5mA5NF7oq/uVyzLEL5izQDDXJpQ4dqP+HgKZRFUlOl/F1Sjz8RSyniY9VjY3QMfnvJh4e8BanTfBezq2n36RrPs2eOP4PsL42BmMmnHMCI4TaGwltubd5fOe0lPzGaA/NmkB82a+9cqOtv++AKJmuQrcBqIOsAFCB7pmCWpTLisNf+c9KFqqBtDPplcaMH5EYr7Mb2F9yf9vcWEIInpr5Z0LKWfSKOazeK4VIHyJyD5bJaZVLYHc1DFN/QPNcvkCMfAvYiot4Ls/YwW8Rxqif4jnT8jZLRh3m1ZlFGLGV5eDmhpHjJOUR85Hm1Yl3mmGvV1v7h9nIpAxXmNWgQ/AuLpw1NlXyGaVVytFi3MbyQvfWTf953N7NOjAgCHgljTDnBd1HMw1zixWWe+mgWYh/NbF+9SWHj0NpagQ42c2DWFzPfghhBYvadCdVo3qWSNRyBXxqecqkv+NjnAqioiC4fMKJqDVBtN08WXyOodIr1Js1FnvQZ/EGl7YW2hXjHgViqitalIPEKl8lu8lA8QLJ1WSgV27H6r8FK+g0F3gF7bftzHRHwRXwsI/qHeQxKMzQJR/DUPof5ZAh1Zymju7QcvDdqPfW9BbqYiLADGoVWqNh//OCD9skLdoGoYVsBfaE3qYS61faOag+ggLOBh+tn6YbdyAKPOd3mV6cfxr7FwKGYvhMJCcf1uIofRpA1oUBKmWQQ+6TWcJ0Og9BICqJNlytoxc3LRMDGOYuwsiugtv7ICAnAn6lPklnhFwUKTx1AebdFax+6+TZlVLkszDtsmKsm/JwKYUjZ65Wi8/Mf/O2fN7vCvwamoRab+BPjropgt5UDMORLes
 MAVrHuBC
 N2Cu9ofoPVorOq9goJtFy1kcNueogPEEpWX4Qolk9OTwCaWaVJM6FufcSpICINVl0U4vyYhS9kZwqwOVFE02fd6XREnoqEz9nZwO5wvABwlKJ0kS39In9D9FnT/bMUTCpbf2M25cnGk6z2cgc+Rle5+ltIG9xtkn2LFpYSkxHO+5E5Y3nb69oQtBq2HCDuApxlxexNiSoXG5StCqDT2+ilPMnO6FmmoTLm4Km545JK7IgUaMZVPGkdsmO+HgQSkcQuYaJzWWbvqE40nNp736lknCKUsJ+xDC2Fn8RygHRZ3Ta20ZKL3x7A958q/2cAurvztkU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
free, respectively, its CMA buffers.

However, these functions are not exported. Since we want to turn the CMA
heap into a module, let's export them both.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba4397f018f6993d962 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	if (page)
 		set_pages_refcounted(page, count);
 
 	return page;
 }
+EXPORT_SYMBOL_GPL(cma_alloc);
 
 static struct cma_memrange *find_cma_memrange(struct cma *cma,
 		const struct page *pages, unsigned long count)
 {
 	struct cma_memrange *cmr = NULL;
@@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(cma_release);
 
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count)
 {
 	struct cma_memrange *cmr;

-- 
2.53.0


