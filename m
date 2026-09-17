Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8CEC982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151726B008A; Thu, 17 Sep 2026 09:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A3F6B00A1; Thu, 17 Sep 2026 09:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0181E6B00A2; Thu, 17 Sep 2026 09:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D000D6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:49:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1704BA0398
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:49:59 +0000 (UTC)
X-FDA: 85223387718.11.E92B149
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0ED6140014
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:49:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hrI7XStB;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRIStKi2LZ8v+jiCS8rV0NQyhsz0Xqewo2THt2Su17w=;
	b=6hY9oEFjaCpeU6m9m5LD24ScSRVM10lIriv5KENJqawP6tZlp6cqhrLlnTauD81ZacK21i
	5yQUzsTNbhrdIufLb1gFkpZ99vknl6zsbesT4rurK77n4igik1RdozpqsRixI46maTgbb4
	sGcRIRRcJdnODzP+8YP/TG85iK6Fykk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652997;
	b=UQp2f+Ug8C5RsKfXt2EYYgYiPboNcJsoZoCCqbRTp+GA2Md+ikBkBFwBZ465FriiFifuc5
	/6TU22oBgEV2IfuPCGtkQrMyEjT4muU/PLhTaxSGUd36dJmOBQGRSs9k+yiJzHe/VilncE
	iX2xXIF1cUN9SzJG78YwGlj3XVWN068=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hrI7XStB;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cc46c4so54467685a.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789652996; x=1790257796; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XRIStKi2LZ8v+jiCS8rV0NQyhsz0Xqewo2THt2Su17w=;
        b=hrI7XStB9FudLgm8vBrMUK9dk0jJTifQttYABcJ4B5AOsB9F07TGFG8niF5sz7Xtb9
         UWPnzwWkrVfvYPEwutUirHs8vj1qfqZLlrWAgitEN90/AsKb5xtuiZTFJI7kfp5rE9ld
         MK95aR7jEGIKKsC9ts1lOdeXLNLjJS53fFOJiOyLOWai9shFSammsRpYEOyc7WaVYHEa
         QUC432TDMvEASho3Wk+6MY4KPn0xf9tT+BavKMz8BEhKAE/dRcy9RX5EGTLkXqIwMcq0
         j7IiFkh6E7ztmwxHx+eqR9C3qBvRlmKdF0eJY+rMJTAg5wxW3Fo3JEUg3x32sUCd5Z5J
         BM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789652996; x=1790257796;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRIStKi2LZ8v+jiCS8rV0NQyhsz0Xqewo2THt2Su17w=;
        b=Fpx5m+hMKuDF7/8ZIHvR01DVbduj1Vif9jffFYlplawhaDzyb2B1cFeFadPYvwvjgJ
         VdEhJaSJ0yBCdZulm/IRKXPsjFnjyoy//MdUziCCfqM7sSlWll6y4DgN+HibmAUxJRas
         xv5BYn9omfPhbOBIsKTnd35kjJBbo1zBBhfG5mTnarWHlCB90QyiYc+Ry32QcKr3bhBu
         OM4YA5FDqvC97ChscYUlwhlz+wE7QLMIhZI6Wh6kGuwqpYRDfgpXgDe02WFKM87OlOWI
         MfoXU+Kwcs+GKI5h/3XPARn4Yx6UPWYaCqRRJvhv05uK/DNlltPcfIJZBzJkjbWyXSsz
         TGPQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1GEQ1iiudSx6w46tLxKQH0v1tY+17DaGR9bky5Jc+vpAdN5Q6eAQnB3Tf1icBVIMRc0LQjk2tyw==@kvack.org
X-Gm-Message-State: AFuF++k/2StJiOVe91DGVgyN1YUdJQ1T+18Jujnbw7bwp8D4AHl2e+xj
	ja6GQc6Bs4qvPq4aXG0rZKgrsM6lGNVJFVyv6668iEKfxaXY6JHry/dCHl/U5ol9Cds=
X-Gm-Gg: AYBFou0cQJABp8kZTQ5sr48SeEj+EnIDDDOjH9x1HdLxTahEXKPpITS+kT5OX+gpYMd
	nefhksKx1stT3WAlnLkwVkHyZuHHYsQXf+wJA+E4b4dJrCIRwLUAUHh4EpIsl5am5W76scMRRl9
	dKHuVR5BrBET9rsMDi2rdL493pagz13WU6gr9fuUe8c0dbBYmWdO+d6yV1JDwKLqfzY3hQZe4xt
	ZitpSq5XQqgsTnI5vorPYJO2atUarn4opzOWxh1jeaUNVvS0e2fBdmsMET1GQDtOR2eQ5ZCDK+L
	qvJbYuYnM5AqxJIPwcaVvfXe7+iAMfA/K9L8v6+m+2J08ru9Hzw3RYmBiePM2NeMvaegMjU/7Uf
	GTMRacjUOBB4BuefIzwX/7i9fAb9QNj+cNduy8qlAL9LT/6EoamqXkRPSDT9m3+kir8N4VgBy68
	RHPbyQUHF8Bs2fHY6uNV9eBJILA+BaEjWHAKHq0LenJiQHKClLu3TIFblv/TkgsLTW1U3LiQf3R
	vm/RvgpdQ==
X-Received: by 2002:a05:620a:6489:b0:939:6c96:af6c with SMTP id af79cd13be357-93bb76dd1demr1109294885a.7.1789652995812;
        Thu, 17 Sep 2026 06:49:55 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:1f35:22b6:fe30:2a34])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81cf2568sm451922085a.36.2026.09.17.06.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:49:54 -0700 (PDT)
Date: Thu, 17 Sep 2026 09:49:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260917134949.GB1344@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
 <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
 <a1f19a59-7dd5-4fb1-b5db-3efee8d249e7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f19a59-7dd5-4fb1-b5db-3efee8d249e7@nvidia.com>
X-Stat-Signature: 7ra6mwx1kyoaxf993k7yhgumh6ryenxt
X-Rspam-User: 
X-Rspamd-Queue-Id: E0ED6140014
X-Rspamd-Server: rspam03
X-HE-Tag: 1789652996-918835
X-HE-Meta: U2FsdGVkX1/J9GgXe3w/HpKLtEhJ5QlJmzSmqr4yAk8xbVeHRKTeJnvb2TrN8zadXImZ+Cp8lMz311vPScRuZRaQIvo2fEG6tAUh7T4aTCrxdVx9K5bnEUlepgCbfbruUWXn1MPXHdYm6B3aojLLSHcT/PEP7TTmMyDY/jV0PeFdan9meMIHTJRLb90d9HZNe7AjJg7cBidBgYOPgC9TeA49+rXxkZkMwrDqkcxf74X0qQdUwbDoQlpIgq1YqMjB+IuWR7rXzxX3F+6xVEXIwZG4YKySkAYrCSJ+lrlu4v2Ad3YoOsPUP7IqtFlHyRxT9AiCAhkEoDKTrGFoEv40OJt2j3vjfPinbpKCd3v22rMscZH7eJT4kNpPDnTafZ0ictblrOMM3vEhsjQhSp1ZtnPKF0v5o+/5r5WdK0qaMenLVN9lcfCy7RqlKYtfE580EbaDjaDBr1NbSkmfEjGy9Pbu/2vc35ZtTQRHBnOKehu+yVFG8Rmn05GR7WQdF0E350NY1pmXGtaQTwFaYxjpFJ+fja0oDuJrVk9DW3ZRU+KgAXwg8xRZQ8jlGjbhJWlP2StRwC5ypsq8npz8jot/81WGtqhtrkiShXcc9esaUIlOLAJZnjLXv8llOAf/PAuEESACYilB9nKvQBgO5mcO0AJNHwqs/KhgRCSnUlZV2snbharzWo5uknBjAwAdmmV8tn9lAYh1Z9z4DT3WYitlqGvaE2jpG0wZrY1qO8cpZu+RsLVMGZCrMKSspTjgSwaPxBNP7gOLWelUwj72d3hoEznGnmGwV6PnrLxYTyfXQvsVTTae5VzfnZwDgCiEnPW9//0BMTk+3ZYCgJ3vR1vJKf+nqQ7IBnQqpxEZHiM6cb5LiFsQhAqH5kJaffyT+WEYQm+N25tNxKbb3mxv92ISfBLtlDUpXyIanmxIfKSDHGDFuVqhIj0iHv/ryOsKLoaNS3UbkRgmNRl6NVDFZxD
 3bORiFGP
 XXlWmxYxNgIFkasqZQOkkd5hOvqEi5EOpuL3LS4Hmx/b2G6bchuNqY7JT+NdRPSINC/TrF59wi/0srHMc+MPqEGxh+2pO6B9sy/FbV8qCntU81HED8nT8P9q0hMgbBiX2Z7dAZwpWD8/gts6hBE6tyl+5C/bcTucVZl6ZUecE+ppxpP6hAqO/jrbC3dAubYc5YinVOfFmmp2LqIayXeWT/Zw54YpCQjzKZu5vxnMaBaxNRBjT4/nXzmWD0Ra7pPThDCZL//bWX52GWEjTkRiXNllme5c1j2f730Aq+y+oSD9QPdLYnvrX3ov63aKDsWP3TLDzrMQmJ/ye0VUyUhmGg5xn7OYepe9nuPpdld9XPaKpVk5903A/5oXZ5CIci75Z1o4UAH8nHthy1mMczPDZ2aWgP4rQyJxx2xaVjzKwZqU2b1++rk+k1VDi69B57k989Ouc4WAXS+RyNMGXarSijnwWa9Veaq4X3BxI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 01:19:12PM +0300, Nimrod Oren wrote:
> On 02/09/2026 21:37, Johannes Weiner wrote:
> > On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
> >>> I'm not against carefully evaluating and testing out today's need for
> >>> set_recommended_min_free_kbytes() in real world examples. But this is
> >>> not that.
> >>>
> >>> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>
> >> Isn't every possible change to address this kind of issue subject to
> >> exactly the same kind of constraint?
> >>
> >> I'd like to know what not rolling that dice looks like :) or what
> >> constitutes 'careful evaluation'.
> > 
> > Usama gave some great examples in his other email. I'm not really
> > arguing to keep things out of tradition. But I think it's fair to say
> > let's at least test the common 4k/2M THP setups under memory pressure
> > before and after the change.
> 
> Hi,
> 
> I tested this on an x86-64 (4K/2M) virtual machine with one NUMA node
> and 16 GiB online memory, using mmtests config-workload-thpchallenge-fio
> with THPCHALLENGE_MADV_HUGEPAGE=yes.
> min_free_kbytes was 16 MiB patched and 66 MiB unpatched.
> 
> I ran each kernel 30 times, rebooting before each run. The results did
> not show a regression in THP fault success rate or latency:
> 
> Average THP fault success (Percentage Faults Huge) increased from
> 13.07% unpatched to 13.34% patched, and average fault latency
> (Fault Latencies) decreased by 6.5%.
> 
> In contrast, compaction metrics were higher on average with the patch:
> 
>   Compaction stalls:          1,635 -> 1,713        (+4.7%)
>   Compaction failures:        1,350 -> 1,416        (+4.9%)
>   Compaction migrate scanned: 4,812,254 -> 5,587,587 (+16.1%)

A 2% increase in THP success bought with a 16.1% increase in
compaction work looks like a sizable efficiency regression.

A scan efficiency drop is in line with expectations of what happens
when non-frag placement reserves are taken from the allocator. A
comparison of trace_mm_page_alloc_extfrag rates could be instructive.

Why the 2% success boost isn't quite clear to me. Allocation latency
improving suggests the extra work is primarily picked up by background
compaction. Reduced reserves could be making proactive compaction more
aggressive. But the improvement is unlikely to hold once you run out
of idle CPUs and the additional compaction work actually eats into the
workload. It could be useful to look closer at who is doing the extra
work and based on what triggers.

