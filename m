Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8AF60A3828
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=NAGOWLGK
Received: by kanga.kvack.org (Postfix)
	id 017246B05B2; Wed, 18 Nov 2026 10:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30816B05B4; Wed, 18 Nov 2026 10:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47626B05B6; Wed, 18 Nov 2026 10:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6E76B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:25:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C7B01A07C8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:28 +0000 (UTC)
X-FDA: 85448613936.03.518832B
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74CBB10000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NAGOWLGK;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015526;
	b=TF6ND4ilbLfFZs6sGLr1ajvSV4rBb4cmoL/jbdYPINg8ghX/39vFbS0rUbQnmcU2G2dlIG
	5RNWQmSXg4xzxEnBHTHNaECQ/uttC41KL1xd/rp0wMbcUDNPgVunYX7IqfoAwsYAnv8+r7
	GsVP6J/7rBlQBysB8J2ZItXNMyvO9Zs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NAGOWLGK;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhtDXpbRWCIEhu50xIx6ItwVhQLsPfY15TO/C9JpkIY=;
	b=gRofDfaAcbXopt65f/MmFMXTs7gVO6h4Gfveio87PcirhkVrPTOGrEalO1Adwt09XNFO5O
	BtNQRo5lM2aTILXB20e0Z/IFZMKqYocverlhpHlLkzU2xtut3P7k1OvVItT41AD6qAs3ux
	CvwLZ1CG+FBdZHFCdGSYxZVuWZNE0Os=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-9211bbce3abso4282156d6.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795015525; x=1795620325; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MhtDXpbRWCIEhu50xIx6ItwVhQLsPfY15TO/C9JpkIY=;
        b=NAGOWLGKtY1GhLslNseqwqxNh9evTHLc9ZNGyiDpAbxsVy8zY53DuK2hE1sJiiekOM
         0EFQacbFE86O8qOqmTPtojY2H2J0zQoZyP+xmaOMqJ1mc7mNGoatx+C4u/uWbUTuCGvh
         yTorqaiXpHC6avezHLAHQU1D/r3gqZy4EWmJqxIlg/oSg2A6d1R1Y6bAhCziY5sekZU3
         hfGjuqTtKxuQAJQ/+4cT8GZylMw67n5/wTFHzzFBgURFX3SqPKOD4OeBCYM/o3caqRfX
         6WHKwQwxlw347kdflJNvC0Zmqp8EQ0ijQRPjTpoOZDVMdGwJUFI2mioiwljpn5n6kCo8
         INig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015525; x=1795620325;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MhtDXpbRWCIEhu50xIx6ItwVhQLsPfY15TO/C9JpkIY=;
        b=CMbFrS9Y6bbg/J+cX1e7qy/N43TYcbGpQiJCdCcfyC1jtRhl30ca8nCUW62tdHTvxU
         D3rFcWh09s0YChvG6x2mBJYvMoHd0qL43dzpgONqyeoh410zTAj4179cO7cZuw1pcxKI
         sW5cZuQOCmDjbVlJC6+g+8v+JQZot5rryXzMX6Kyk+ep/FD+COzjPZz5UXAfFEzI4GK3
         yms1Y4Nrx+OopLFuqvN4te/JGqwt75YJwjybgixhG9BodHQf8zCbRZl7iXCtsW6m8NJE
         pqIMxuH8iLzeKaU6eJV7Ss0+qhN247J/5k7B7dQPZ/HWCzekvMHGPMFY1tb2DOcaOeyI
         nDkg==
X-Forwarded-Encrypted: i=1; AL+hErG2e+piNyuCV6EcOpl2hv5L7Pzj0OLHf80vqV8ADxpVX2BgaEO58g0nlG/UCYq9X+0NEQQlhKSFkA==@kvack.org
X-Gm-Message-State: APuU4Z/T84hIqXF+0A6sxereZ+EAtFkAjbZcfUWYwal0ahiEpwe6Uy9f
	kmsQfchMu6xQW/dCj25VHqPwVg1ntuEK/m2aE1Q+XYwq1fdYBmy1ci7Q242L3Qh4jgQ=
X-Gm-Gg: AZFdTZfNVueU/TYfEj2Acs8Y0qgrlBBSfrgIGomEW+HZDcZxXXgBxtWJuPQbLih+3Kn
	6e8mMLAKKSzIBYd12p0svy0usVXjVaFodptioQFUorWU2TJXxkHr8UJsYCkf5S1T9cWNdSH+/Q/
	4gm7f1OFT27xiQltQmIPMdCLJxpZQyt8lhVNspmmvWOLLYmM9N/x9VOQpZ71qH7gSWHVa5MfNK8
	X5+9OvkKySX7jlFK5gNvaru82J1S8WlsNloPvB9BzwtrziwwGjMpi6Yi73KO6RmxnJL12/k1eiS
	uRitIP+oWJX9MFu2h8yJzHi1eTc7sYewel0C2HF5I8cwyIL7544+MdiijOiw5eJSv/5PtS/qnO2
	dqwMQ8Q4/isuar4vvp2fnfQ/GJn8/qNpdcSv+iomMQ8QpHvtKGVEkemZg+0+mEWzPWEGOGcBvSe
	dM1gqKL7rZEL5zzyqRshmKYSDfcOQ24D1s+tPSvTMSvENXcZOR4l8L1OdIKOvjKNpWZ/xA4sUm5
	s50Sb83GyO6HTRm6YXd6cVpcGPpWbqUsQYpxPYyWLRtfTQcQDDPrVBxYy/BlAstnEY1ZNmK9gPm
	enheMt+opPSKS9O5q7XxLVBRUXFc1+8s4SqnyKa5X7zHO0qzbvranb8f5BVBWRDx4LdOVCyf4id
	xtqTr3+Y=
X-Received: by 2002:a05:6214:240d:b0:91f:12a4:27f2 with SMTP id 6a1803df08f44-92114c4e8f8mr45557396d6.6.1795015525386;
        Wed, 18 Nov 2026 07:25:25 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921149f9c36sm24415306d6.5.2026.11.18.07.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:25:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 13/22] mm/hugetlb: restrict pool growth to common
 memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av1PyBvUVJcy_Psd@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-14-gourry@gourry.net>
 <av1PyBvUVJcy_Psd@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:25:22 -0500
Message-Id: <179501552287.1206716.17381960047395782233.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 74CBB10000F
X-Stat-Signature: u8n7a9toc171aym1bgeyykjwrnbkx6a7
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795015526-110269
X-HE-Meta: U2FsdGVkX1+otQpneWl8ngkpxM/V4Qc623Z49BKiqm2mlTtqfjSIe6HitjdN4wGXt+jwDRSiDjkfzm2Mpd3xuwjUgsq2AKgg8pEqgVt8x7zZEPB9iONejOcB8wOlGIVljxgPgcdeLgpkgaDMLL/KpBr4F//XJw+UlXwYNq3H7nJDQFQtiVeeiqbGxrx07gUyqVZi0vpCDcJPKNY4vKmNG4oBsJMCizZ8UCeezEjvhQTwgNmTj/G1l5rigq19Q0pecD2pTQEFzSUGo1MnjCGd3pUl6zaH49NfmOk+jSqL7WIrVHD0o29Cy5cKOnBTpbNwSKTJSMkLZD2sidfzZWaDM6SuaGO4lKQzI2f0Ej0qyPctyYrxUnM3tWYWwDU7Gkmg/v/IxKdhU8B3bAX+qyfm/O9wBDgaXfQzJMOTGsllV/TxAEK+XvZqG3WqpAlrNtgJG/qdNHGNfwm3AReF2HXxPQHqA49ArrRLXYbvrlQNrQ/KU02J+wr8hHufVJ0cXd3qpr81z4FyWHTGspSSkyOPpE36b4W+t1kVRSS1x10ZaFOoIU2TY614xYomtsgguTM6lezjEwQvL90lLhVnzSp2z2N4oPn6WJf5LrgmcA4i1ijDMbpcDc6N3m2Qh1fVo9kI2KUr9lBSkENpEFd6fOO4ssOX7v27rMvvQjOnhCUbmn8x0HfSfJegCt2g7AE+vyLWwGej2PJAM6QcFhDQ8yv6Xq6EoLNO8QEltBcrZPUJqIPJ0mg7z28sga+zKOXSSkOmS9DtJHO07Q3LXj8EorPDu4UxqxKxpJNmO4DvXCVYPJjQiU3maxBSfEYYRNfZClS0Bd+mJsbsSAfDR+qtDLemGxWFoXhJUjF12jmNz7lH424lz8GCaGzO9xTVDeTO/pKY/V1bKDtxexvPnjRcfe7lJqfYGX0v6NvjnlEcKQDp6wwAF+XZQ+qiKBPuHeeJHu/BlHdN36aea4imyft8wxr
 X1NjWBZL
 mhGkmIQGUkUG29Kar6dz3FrliGZa05VtLESy6386EB7rhZYU6spTuNLX/eQg6VPJMXeb7l4SQy9pFG4pag/ZxVSxG68vX5c/I5HdgOXNPByHVFtYmeyfojO2IWlku95BFTaKDJOoIaZ8AihxHgQWRPAqwgWikMmQZx6VPngf8PHZjgGcMY7TWoGOQ+46F+xIwi5gl+MwU7+C8aT8JieC7XW4RCyhFd0F7b6ZD0E37Z15vSN1rXjn9rN3w3Qg+ZLLbJvfs5zM8Whna+R9COtrH48xmkF+haYXU8vQTFpvljJm0B+DqrikYFFJUwhYIuYeVaAk3cDoRvcShnEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 15:32 +0800, Richard Cheng wrote:
> > @@ -3802,23 +3801,21 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
> >  	unsigned long allocated;
> >  	struct folio *folio;
> >  	LIST_HEAD(page_list);
> > -	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
> > +	NODEMASK_ALLOC(struct nodemask_scratch, scratch, GFP_KERNEL);
> >  
> > -	/*
> > -	 * Bit mask controlling how hard we retry per-node allocations.
> > -	 * If we can not allocate the bit mask, do not attempt to allocate
> > -	 * the requested huge pages.
> > -	 */
> > -	if (node_alloc_noretry)
> > -		nodes_clear(*node_alloc_noretry);
> > -	else
> > +	/* Scratch masks for allocation eligibility and per-node retries. */
> > +	if (!scratch)
> >  		return -ENOMEM;
> > +	nodes_clear(scratch->mask2);
> >  
> >  	/*
> >  	 * resize_lock mutex prevents concurrent adjustments to number of
> >  	 * pages in hstate via the proc/sysfs interfaces.
> >  	 */
> >  	mutex_lock(&h->resize_lock);
> > +
> > +	/* Fresh pool pages come from the ordinary allocation domain. */
> > +	nodes_and(scratch->mask1, *nodes_allowed, node_states[N_MEMORY_COMMON]);
> 
> For a global request the caller passes &node_states[N_MEMORY], so before this patch
> the grow loop read the live mask on every alloc_pool_huge_folio().
> Now the mask is sampled once, before the loop.
> 
> The loop drops hugetlb_lock and can run for a long time. If a node gets its first
> memoroy in that window, the old code would start using it. The new code won't, until
> the next write to nr_hugepages.
> 
> So the pool can end up uneven, or smaller than requested if the other nodes are full.
> 
> I think the nodes_and() should be placed inside the loop to keep the old behavior ?

I can make the adjustment, but the concern is that previously we'd
start spreading the distribution of hugepages differently when there's a
race between hugetlb allocation and memory hotplug?

That seems like a pretty innocuous corner case to be worried about.

I can see about retaining the old behavior, but i'm not sure what you're
describing is reliable behavior already.

-- 
~Gregory


