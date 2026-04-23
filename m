Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96703FAD3FE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C216B0005; Thu, 23 Apr 2026 00:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECF36B008A; Thu, 23 Apr 2026 00:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC396B008C; Thu, 23 Apr 2026 00:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9326B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:31:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F6368B960
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:31:22 +0000 (UTC)
X-FDA: 84688546404.17.E31F194
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A78B20004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:31:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=N4iUFMOI;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776918680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzBI8Vs9g1xHTdi85g03Pkd08y9g2RbvUpIAv03SBC0=;
	b=mYiIsUP08nzbNV7BhDjaIqUwdiOK6ZYOp77mgzLo07ArukLHYBgBHuEyo1OO1g8nbh5eu2
	6KUxr8vV3Us1HpUQZprcmDTBxJEIgGzlIQz2+Jsiq+3d0KyChsdJbC02R2skP1+7lh37AS
	LrVnMh2LwQ/RD6bW94c049H4NLuw4rU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776918680; a=rsa-sha256;
	cv=none;
	b=yS0btDBUlFROYNkViNrb1obq0khf+hACVaqTjMtUwOK6Zcq/YC/C7mIhgzPBUywhCnaGe3
	oBxZEMJVTocSAlDUlQ66v7natZMdmJTD2046jKJAsQZOZeeoDKbG1dhW8aejkNlYpEG/Ko
	wsBzG0JFowMXCvuvQgzn7BKhVTbvQSU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=N4iUFMOI;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50e63771eb0so41863111cf.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776918679; x=1777523479; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KzBI8Vs9g1xHTdi85g03Pkd08y9g2RbvUpIAv03SBC0=;
        b=N4iUFMOIFPH4R3+1pJBTgCeepnT7dRNjD4qSXH+sa3ar+OO1vtHa5t9K1NWpldUCqZ
         074q0lHs1lfn3+It2AIgjyrIZUgur7XDd1B1vsy15fo1GNVXkwAyyQYgfQMtO0XUOurT
         o4399QMDzSCL0x9fDqgNja7O5Cj9eVH0pNnyVa1HOZX/pE7l9Jf5W+ZLA5qRoATkHweM
         2UwjBGO8lAuZuLevIlww+h9H3G2lTnQHYigykyOErQ+V6DeDjzJzWBjfPlq3q54KqWs7
         5DIHPR+r4+ZcDUmj3sG7oh76dEjjKWMMg3J6VlKvJAE8txtYI1Zm9t39+zOc7W7q2cIF
         L1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776918679; x=1777523479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzBI8Vs9g1xHTdi85g03Pkd08y9g2RbvUpIAv03SBC0=;
        b=MOtMiZgcj1GGLjS5N4bPv0zqcdv7oER+bd/v+FRXfopw5wHUcGJvVpSubi+AhzIRrE
         RGqEa/TPA96E2/nHNVbytM+TmHEL+AxBPRYbNlY02EI/zRDPbs68cMDMSq3Vb49qdHZ+
         M9W3U8u6i3vb4VKPlO1mmTTzrirOCyotK9O2BGZdlTnlaysFx8p7pMhxA78QZLmdo3sv
         6w2V4Qy08RaBTobrEqRiTq5vrxj+B5VVNbzrs1jxSrHs86e9kMoPKYyPkaX7cm1reica
         TH43vr8ywRVWNsAWMVtgOrHccsow+a6k2YP8KgQol+killOurpvQ81y/YFgF2bUwtHvM
         bchQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mIkBb0RmsCVVHVC/WurBEpnidJKmfcyr9j7Vgtoh+eL+3zC/nUTgEQBsq89Qdfi0gq/CTl+y57A==@kvack.org
X-Gm-Message-State: AOJu0YzEVjNLWRQsra9VuXGL1YWcyXqCDNYyQiWg+UH4B9hERy1a9FJA
	Lb5/EAL/fiCRjzffSff1aURLCQ/i8Uq+Uu/m1gPItgYEih5BesTmp9MZo7dZyL+xz+4=
X-Gm-Gg: AeBDiesP5jv5R3JPgzSYQa5qwXOuyE+Rnl8rwVEhD9Cmc7jd57rQsMsByUCidvEareo
	HfesFNrb4sT6F7BrS8ghr07y5IPmxg5yRz4PADWIGpRuh9FbHexhwKNO3LQ8Vx6GQyxJTX85bZI
	HS8sybD4OujkxStlt4wPD6JK3rI9/eatxz4GVjUG3Q8YJ9mZjJgQqxMV2a1U1cPkGu9yF2jHFZq
	gM1EUqVu2P852APwYDi/QCor3Z+Q9wAm1Ie3QVUVSXx0XlCDFqVi7jssygINYsuw7rTYuFCQL9k
	uIpliGOYkac5/1a/X7SLSf/Vy9aBjlKsiIsrhwFbndt+tAQK5JeGfI+GdJLZJ5rfoZiM7W5ODn6
	hfXQ4yQ7FA4iLTU0Y6RPLWlNfyDfvOCuJMHn2EkQ1u4GLXfyjBgvIwIXMtOjdaGhDRvsCZBvImM
	t4aNphLsqFg8NFTPCaxIuk6RTCH1c7QQJGpRJT2B8d23BBizyt6Lfmqs119iRq/aLQrlChDwNCq
	5JbfviTgQG/XAxJb4wT
X-Received: by 2002:a05:622a:409:b0:50e:89e6:669c with SMTP id d75a77b69052e-50e89e6697dmr204320091cf.37.1776918679403;
        Wed, 22 Apr 2026 21:31:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aec3a3bsm147982736d6.49.2026.04.22.21.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 21:31:18 -0700 (PDT)
Date: Thu, 23 Apr 2026 00:31:16 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171315-mutt-send-email-mst@kernel.org>
X-Stat-Signature: ntuf7cp4bucsjewq91d3odt1dd9raicg
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A78B20004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776918680-941107
X-HE-Meta: U2FsdGVkX1/mmyIlewYd/lpWsqenUGWQf6RK5FcegAkEbbmOC2YUDQ25p2V9DnjoZTwFxGbMUl+ySoCxeX9HYHSWZzeKSF91yJFYLGjyXS9qb9uOQE6UXqk4o2Cu7A/qLcOdft+/H4DbcJEqUGMKyEAUij3hrUQosCeEObbC5Dc7HqqqeaRQtIt8TxLWhm90+pOeXhVzM7kclhzlWBsUEvTaU5NlStT6Iwg8OgQcxzpoNQAOh4C28CRMGt4l57CuBSfK3YErV1u4j6MTROr5U4rE8tSRl+vxFWx1CkB/cDHzDbzBAEeCl/Qa63L4nWLr7QPyiK9Q8F9wqBfk876Y/0C8NGEzNTAoKHuxus/GnH33UoxYa0rauIvpc6mmg0UVspZORF+8A3G3J24mzTjeY2cR/0anWKiHXhSbBFRwlSvlj9Q16uGT3xFLW4zKcJPxNI4LlxyLcpmniShZT/If71MeFBalVgwUWkYuKTWVmcqf0YlImCwc4rDdReKdFvaAngEH+6LUx0ZGEPdgL0GLtSeyuE6RXxtBJoBzdqIuVnx+cQz+MoovUQkIM1Lusjq8GULeS6bEx2iIG1G6gGBs6Yy8qvxjiAhcAt3wMKoLv8DNQgfPNcarops6A/Z2dBZxQnmW/U0IABM/eP97ZH1MOu+JR683EjL4ml7qwXQhfDzIl9mPbRs/pH9QvY26O3bVpTUkMOMuePDXqsmfkBaxwTOud9SlLz2h/a19X5bB4H22RLl7SiOv4XCG3VAtIEDhfHH3jF4J7wStPa+gFzdqVm2NsuNev3zVUTRpIx595fq9OHCTwSxtr6NqnWM2tvss18KpcgqNI85xzrpDnJOfn6P559yprrHPWbXb8dpGZbp9mNR/Zf7qN18Azi3ny+F7U3EqRMXpd4xw9hE5w/9K5031fdXj9IugmO8RW1FYAKu4eTIdDdZVPfaVdUXYIDbu/tDMncKQiFGqCKkDbGA
 4eIuwjAJ
 HUXcwbX6Sz4cLpnPQUsQeJ6A+qPnbw+MzdZVy28RfvNWKPAHl3RUq42VnU4//fpxphFjsx79k31rmGp6FJMUMPCTbZRFrJYums92M1CWxwBJdy9GYm1cS+SNIq3WxcBy3/KjnAbBEjz6v6rZ6lUIzWujKgb4qIepePc0i2JvHdJ+tgrhu1DoujeWDwqnJKgaxgGJoJsr5PL/rLdmhkgt8yPu+YRz7PDt7VEPto147SF4ze3J3TV3ne5NzY7AqPR1fSzfGexkRWIkTXaEcSEHTGVHMAlqBh1XclsodhqIaj3p5AiWoEpnJ/ipSlK2g8S1JMFvwq0h57Pe7QDZL6CPgdKBhNHPz4ILIMKe4ztgyYOy4kpgyp5j6zCS1Lz3+5726y4yEiRgvEzAfsdjL/08Zst8PsbamFWTLybHZwc/ZYdVtt1uwFJdJdXhzmXTihGH2mux+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 05:20:27PM -0400, Michael S. Tsirkin wrote:
> On Wed, Apr 22, 2026 at 03:47:07PM -0400, Gregory Price wrote:
> > 
> > __alloc_user_pages(..., gfp_t gfp, user_addr)
> 
> With a wrapper approach, looks like we'd need something like
> __GFP_SKIP_ZERO so post_alloc_hook doesn't zero sequentially, then the
> wrapper re-zeros with folio_zero_user().  But then the wrapper needs to
> know whether the page was pre-zeroed (PG_zeroed), which is cleared by
> post_alloc_hook before return.  So the information doesn't survive to
> the wrapper.
> 

I was thinking more that internally you already have that information
you need to know to skip the zeroing - and so the wrapper can just pass
__GFP_ZERO and post_alloc_hook() would do the right thing regardless

Then on the way out, the new wrapper would take care of cacheline piece.

However, i explored this a bit - and while it saves some churn on the
interface, it adds two paths into the buddy - and that increase in
surface might not be worth it.

So I see the tradeoff here.  The churn is probably worth it.

~Gregory

