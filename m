Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17EBCCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A69E6B0088; Thu, 11 Jun 2026 13:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E676B0098; Thu, 11 Jun 2026 13:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB2B6B0099; Thu, 11 Jun 2026 13:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD836B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:16:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 169151206F7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:16:19 +0000 (UTC)
X-FDA: 84868285278.03.5CFFC5E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id CC9F91C0015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:16:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ODRoseYr;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgG0Gw9eXCNHh8+LRwDpsNE1bd1teRP7IZXpmnVvslo=;
	b=H7OKzd7m2X0zHowVXJqKMPQQUIO9y6OK6/7wuUAMSSOCDn3Po9fApdhbMGHyAROeNTwPhj
	3Nnij66drWbj/7ykKWPb+02e5uISG8ZM2v+qG4XTeqmOigi/M2bcvy9qZHJuf+lBKBqxYO
	xNcjwVTh0RKtHeU/lUz7Mi/o8fuszCk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198177;
	b=5VzpWq/mgkqAqPTiReCUKRm77Mvj+65sKfzoSKg9TY+xM0GTdipDsrpW6IE+uHyBfs06Ar
	qjrajHzCchYJE/hvYiWQzDiig+pA9tz3Hhhyz92wHyQxFGMcEAQZ1fsYUWPXu9j6GzBMAC
	Hq77GYaSNTJoxYqkfnU0CSyJqOO4DJ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ODRoseYr;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kgG0Gw9eXCNHh8+LRwDpsNE1bd1teRP7IZXpmnVvslo=; b=ODRoseYr2ZignuHLgjJzAXJVFX
	l5GCfdLeTrXCh/HZG3xjUuSizYoCbRxBb1JMeLkBVTTYI9/WKn1zV1kd7qMVuMOgIIYii/FyA3F4T
	J76bMOIYUHZUgqgOGt5COriCO1o6x5P1Ebhi9vFdRI0KsYZKbNrPRlKygDi67haCuKheSzGVczBa3
	ZMEyAVVrxFIQn0QMjTX3zegK1xWmByMqbLDhQVc0L3eG6/T3Lz3QoeJP8tuRofTaeSbdxefeUoXnk
	Dt2Y/oTJBUOSTEeDpyo1QF78nJnMRWLISSfsMWE14rO9yaVK5EDK6II6iRxuAgYIHvBprseYwv/xD
	ao/RT6oQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXj0c-00000002IYf-3HH8;
	Thu, 11 Jun 2026 17:16:02 +0000
Date: Thu, 11 Jun 2026 18:16:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Karim Manaouil <kmanaouil.dev@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Nico Pache <npache@redhat.com>,
	Luka Bai <lukafocus@icloud.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <airtUk0t08o63me5@casper.infradead.org>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
 <aigktfOjYwxhzEhb@lucifer>
 <20260611092313.7d4knb2irt2rtswu@wrangler>
 <BC930D36-A35E-4D68-9DA1-914E4223FB6B@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC930D36-A35E-4D68-9DA1-914E4223FB6B@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC9F91C0015
X-Stat-Signature: 3hgkqs37snx6wut6jgg9baonigcoa1on
X-HE-Tag: 1781198176-424176
X-HE-Meta: U2FsdGVkX18/FUaAOPtBva/ttH0JM4ygvBnrxDr48Lq+dYFH4aodG/tDImwRHQbRJpkGG//ZXQeMo0un5C9YcfhlrmVTIIrad34sPYTxd/x9Q0ekk4+fkhLgVamcEamNorzSziFFFkO9AWLxXAV9EzvBXXxxeDgqEyZlqHVNETgGT3b86QOWOLW9eDTC87dCHQxmBfdW3b3ty5+eUnaTZWDMdu80MeAyeEqWv9yoEGV9RNiYTbh3jgLzyYzcd2dNLdnVPiNjnFei0dL1ytPUJUpmrDYYoCla1zcY7fbhXUiVHm/LwgG6n52uaxTfBD8hVLg7CVX26+LVLj6AMKEszSRqESEsGO+CqTsXg9vMLtrpd7x7VntQPreZcSDZc3oHfC7Ls3LTBfhNn80k6Fr67oD2lbMPXlnughGM4cjwwMGU/qDFLxYZ08aQ251TZPLZpS86JsoRAsCCGagXAC4Tvw81C6dQmqiMeYQAC17lLMtGWg+L0aW85JUpYhYlwESHfv4fcaDWR9NpWA1g/DktR/o0wanss9gksb1qP9BjzQiOiXfKMwlY5WeJV/ZbzzBYYoQrVlT2AXWtency0NM8rRIv5RDM+sIi8xBl7Qhuje/si+/bZCGUeOUXXTIVIBjseiJbbGHV3S4cilfbTwdzwoeQDB4oFDhsf8Z5OGkrDz3l7v8PXdZykl2ZMaAGJEwPjI/cO91RcEQaFmAhaKa1Kgm7TdFnaxP84pCGVXxobsmA2LJIANRoG5lLsZKMgV9AzOyMCPAP+sUCKV+U3qaFiWgb2u/HZ0xrWR7JdN2G+NGjVaWNLc1ls3/QevlNVJVrqsv/0lyY+2ZGm3uSZro2N2M400VxLjWVAb7xODsKZdGAQ8s3v8Vw9sGg/STbBztMcXtsRPtcRuusc1hWcIIDwCzxqoxLRphVaWodxsQ1n5I55AU3jGIHlAY5vqNJLDqONNNI4XPbu7vi/RWuJ9M
 2VGIC55f
 CgZPTuwDVER1TwmLJi+em9Wwlk1FjeqeszvqFHte5CIypIE7sMdA8XmVzjUlJkH9kXj3D6wdCt2Pwu8gVet7YSliTkdnHIWl4ygpla8dt+E3IJZ5lsYWXhuj09ijmOfjxV+MspGIllvps1zcDA6J4pP+XWO2SLYEb0NgmsXrjWo9r0WfXZoxo6i0yYoqitSNQG3TnRP6EO/AIjmtklLF80GIJl2V3b8LXdKMf9MOQ5NgCJMY/YREeKdTSSBzxOvnuuWgxG9MJNTQoCtFEsNunyVQCdWYPw8V5+oW4moZj4F0TIeqAa5wiKFM+Xdj6A7HW/JTOR1DlZCLTRt8MsW/vIWvEi2YCkI9qz9k8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 11:14:06AM -0400, Zi Yan wrote:
> On 11 Jun 2026, at 5:23, Karim Manaouil wrote:
> > How to participate in the THP cabal meetings? Is there any public link
> > to join? I'm working recently on anti-fragmentation, which is kind of relevant...
> 
> Matthew is hosting the meeting. You can ask him to send you an invite.

Sent.  Thanks for the heads-up.

