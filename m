Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D900AC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF9B6B0088; Fri, 26 Jun 2026 10:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96636B008A; Fri, 26 Jun 2026 10:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A874B6B0092; Fri, 26 Jun 2026 10:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77A506B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:15:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5A151A04A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:15:35 +0000 (UTC)
X-FDA: 84922261830.01.ECB305A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1848E40004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:15:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ptpS7SPO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782483334;
	b=dZtslXWKgfKl/mSnoapiFjsdUyfoBq3ZPzPS2LKEVvV18HQUH1BE78C8NeVX4t9TYHAfpw
	qIe7dRxBb1OqQ8hSkAXNm1NamX9Zsw4408cbCgE2UQr0Tcg1R/YtrVDtgCFdDPpuev4VeQ
	XasWvhIM7Zxyprdr6sItHxU6p1KJw4E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782483334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk23Dy4ZIc61XYKtH81zEfyaoMPF2yWZmOGN1C30DSY=;
	b=E2p4WKNYPudyoONt5yPK2OvBXwRr0SxTllYRe1Sf+PWrQoJzvu9BRAbwuRK/Rpdwk0hVAX
	3Ks+CDUo7AUoNvYsYu25POMxYZQ2E+15mtOBDTZ44WD9xmlDAzxpcih5tac+LvpPSAkT3R
	4zEXn+sM2CKemSDHlTrsHcEy5kIWtkI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ptpS7SPO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fk23Dy4ZIc61XYKtH81zEfyaoMPF2yWZmOGN1C30DSY=; b=ptpS7SPO8KrxMt8IaYVlZ4Zn2D
	4r9VnoW06/NoZlCKiKfiBWTVJkxsCvLwBnIOmDZQMF5YBqXGi5Q+E3FNyEhl0h0J6BxooH0qpBXXy
	gwDAxiSr/RaFQ9nGw8tGxeRRNvstWM/3h3fBoIos7vr7+yJj9BuzmftTQMWBDKG7eHVXMZYoejtRD
	cWBrmR6//Oxd+cjFgObvz4lTWQ2CVY+bSUJ6q3OB87WIU3ufmMekEg7JWCRB1fEk68MZV6ihVx7QD
	gVxD/g6Gi+U6+Y2iOn8T+Zp6+mK0tH4obdHvjerDebPqDm2uJUEvUf3WBituFBor7aEdSdFN7Phsn
	5iCyMUJw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wd7L2-0000000BxKA-0uSb;
	Fri, 26 Jun 2026 14:15:24 +0000
Date: Fri, 26 Jun 2026 15:15:24 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Shuah Khan <shuah@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Brendan Jackman <jackmanb@google.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Message-ID: <aj6JfHxWGbJr0WPZ@casper.infradead.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
 <ai_LVreyRWx-RDEd@pc636>
 <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
 <ajPDDkV7yqWlhPIh@pc636>
 <e65e6153-10b4-403e-ac40-10687ea5cb68@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65e6153-10b4-403e-ac40-10687ea5cb68@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1848E40004
X-Stat-Signature: jqw9o54cwb79o3ngx1ktw4ujddueydhb
X-HE-Tag: 1782483332-456952
X-HE-Meta: U2FsdGVkX18M0cDAFIeFEt+1QCyp1tzTSgBxrZEaq8AEsZBeSPUfRJ1gFnRAOUTGiJNb5Lbv+V0Ze7aU0wNYv9tzC65QffbpsdxuXRfg2ZhhoqYplGH4neLgRWYlz9Vc4s8NeSAM48Ps+yWN2S2lLZBFydLDJ30ymYgJeaM5/bK3WINILT7g/tUgbVFZBuT3ZhK8YlfmUhq7awYbTvxzVGbToXg4LTaNw0SoyxHKDuhBcJO+tzEGNNLX7pjUfia2QHp+LhLehIAKLdSFKbtvmgegLI2lDENm0s9EGmWzrfBQ5w9kw68nmA1/eBzFLxh7trehh9jH9Pm21z+q6s4asFg2s1MCQUijsDz/VjwlbOSWkOCFTbL+iCcp8oAtM3FuSiJReLPQAn9Yq7wTlbKXxi0oLFszYMAg86jbwwUMxcjjtIj5AlI268ZkL0VuY/Qm/yMlgGh/AMYuE1ewLGpfwhfkiSiA4EP7QdmkNi4W6HRae7UbIQDAMqy3XiE7ihNSBOFuWPSWX4LpUNjg9yAdzFEnQMiLjzqSwGXJifyTUTIM1ia1Fo9q+ocK3EszuapyHy1RrtCZrvxAthsilrMnn77Tonu8vpfUwNKaVkUJstUKEPKwIOcV5RW7Bq7JlpPGPGUd0ilaPjuIxKZRzupl9olqo3N90aCVWIPMjJOOGbS06H9rD94xDzqS2u6EHEG+ENdLb+UUS43JHNG57+50KRjLfcuYpBJpY6FTqsS2KBtUCOYPknTsQcDtAQHLpF5ueRBAfX6Wnw8ridRGEAAfj+C6LwZaoSHB290LyifucfCB6Orcoj3VKOoxS85ckopDDwOJjO/Wv15GTlw4VSL13/sMLdojFvj/KxPa0BPBZHvTX4xP7ut4+jO8s6w9jkMj7EsYom8Y25aOm9uwjsdaHCTfUl+D1ZEyY77Mob4yLYNsnH70tcd/uJxudmfVq/P3Z9hIr+tJxnMfRpHG6C5
 DVskzcBl
 QrZGEse4DIQGZUeo2kNet8KV6HsuVsUcjkES3KcQANragNoJupff2ULpK78kG5Ip84PaG83BN9haYCAKnJibuyHAgPjuZWzWtRS6xhxE4kf/B477AXABlFVuBaD5aHQpBVZL/3b9//qMueiXlKNOdPZLiOxnfDhVylYEzN2BzKbF/u2Yb/P7CSHjXyngXG49D5isDaCdV2tvOxXlL8Xv2HaCWT53bvFYEdw3XwX5oW6ruFH5Ls29CgKB/eE6Bu4wDYjkgqKL7OdSN3Wij0KaVuSf/fq3BxsBua2lDIyTjgcZQlOUozGytbcwYpAdCGD+TgX6rZa/VoBIJPUXWWvh26DTVc2w4IlflbOX255MKJyNPj4KWTEnE80YGSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 04:17:08PM +0530, Pranjal Arya wrote:
> I am planning to have following approach on this:
> 
>   1. mas_preallocate(GFP_NOWAIT | __GFP_NOWARN) + mas_store_prealloc
>      will be fast path. The preallocate attempt will be non sleeping and,
>      if it succeeds, the subsequent store won't require allocation.
> 
>   2. mas_store_gfp(GFP_ATOMIC | __GFP_NOWARN) fallback: if
>      preallocate fails (rare but possible under memory pressure),
>      GFP_ATOMIC will make a non sleeping allocation attempt inline.

This isn't how you're supposed to use the maple tree.  The intent is
that it's protected by its internal spinlock, and so it can drop the
lock to allocate memory if it needs to in order to balance the tree.

If the user needs to also use that spinlock to protect other things,
that's allowed.


