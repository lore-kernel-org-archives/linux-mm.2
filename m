Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C675606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lXkmmIR+
Received: by kanga.kvack.org (Postfix)
	id 6E5CC6B05B5; Mon,  9 Nov 2026 12:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6970D6B05B9; Mon,  9 Nov 2026 12:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586686B05BA; Mon,  9 Nov 2026 12:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23D636B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:27:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 449F14078F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:27:47 +0000 (UTC)
X-FDA: 85416262974.24.3C5F643
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5DA6D4000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:27:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lXkmmIR+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhmRB7esHut5KbVGfBjpe6elS1XmwcgPIN6spuYJlxA=;
	b=75lt37YLWpqZFDWMLVsPU3O9Z5wJzi9si30zQQxK8alFRN8TesmrZZDRJ7g5wXXbxv1dLT
	Y52uVZGvnI8tVnE/u+wsHFKzeeVDDVUhESStdDWIKQ4otntvtJ0HRsie6sDYIBMfK3rwhp
	b+fjy5NpjWqWwm4r2fPf/+nSY54RgE8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lXkmmIR+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794245265;
	b=2LxPpKmduZu6BYgofWM7qYyiYs9HM3yOqv5VnuiwIP7bLb/qeDHAO6+ZGkmVp6YhBwYnt9
	CEdgex8Vq/WauORMGYq1ATOyOmE3LJaQmEB+Xm98ef1XEzRSjOZGTFf5T7UImE6/U0/NN1
	qzuGY0lEu6hkftsK/RwSHpqqsfjE1SI=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67bef25eb92so1553943d50.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 09:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794245264; x=1794850064; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GhmRB7esHut5KbVGfBjpe6elS1XmwcgPIN6spuYJlxA=;
        b=lXkmmIR+P9HMVRrtoANcwDhC42PBqRM2ec2T1zXEStibnU2eTHq1x0yF+hYVojOwo0
         c3X8Oi1z/kbtXbPftowe3e6GMyNduSKlv6e32vmj0Pa7MuXP97VFt7AfKqCrcvhK2vWC
         mAFjZsDxhrQiF++7ucMnPBbNR03rm9oFJIq9rFG/xcHLEu7JfNjuxJ3JACgxYobYvpcG
         sM25XE0PjLwLUGMDBUuIpwOb9Nm8AKvh+wMJhlXkIY+ItgZBM9i8by4yCQ75JHeJRU/v
         bwHlz8UWJcYCb92ZkOgavWwMfLPWso3b545g54/pItCOt5ioyN5uZyGcItZApE6bCqVH
         f5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794245264; x=1794850064;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GhmRB7esHut5KbVGfBjpe6elS1XmwcgPIN6spuYJlxA=;
        b=ejB1y3718SDVC9zd4QOYJep21knPdEMQo+q7OVhFa8elkFk2cAM2YCxxHii3OTuvHo
         4SHrvMWRluCDkuvxWiL8kvRyvrK3L7y6VxqfpcP7ymhp3dpIwjqHG5PKuh/sEGxjThGn
         Kos8ZfKFZ10F2oXRriieoxXwP9QpXksnkxejRxmh0LaLjpZWuwCUrVhuFZ7ZvHZOpIsU
         z8IU814FvsqpuCEtOBYhU93cufppnkbNdF6mg6N+uJ6M45mTMeIUFsJqU4smv39YYQpj
         Jfuw1FqnAhOkJrUYLuBEHpQKUGymFA/lSl8QsJ/+nT7H2HhGadrO37CxN3WvCFu97efU
         73Mg==
X-Forwarded-Encrypted: i=1; AL+hErELPmqKr+EwciHeBWaWUmcndSjD0SLNHFIGhVt23D4qf7GTQq67NC5BrqTE89eT5xjIv1T5tp7iGg==@kvack.org
X-Gm-Message-State: APuU4Z8zXsF7x60oIeUG24cT3ZpETV1CPUYzEexueVhqfc5ORIA0XAD/
	uqZMwPepF2GuinNk+OLIefdILDh1sArt9OiYDGGNaFx6MyfsHHiza4iS
X-Gm-Gg: AYBFou2o42VH6Vvvh3KtQaS/DxrSrJJU/e0FwG87hqhEjHPUoMiLHTCJUE3sLOY8IwK
	YphHlNVIfChZAheYjlPUbOw3q2adBxOh37Kx0Oe1PlzkH8Fw9p2YrlocKjbcyLV34vITgzwg80D
	yjpZF8h6ZJctuTaM/UWwbOpQEzJCng5SOK0XBDK1Y1JlgRDieX6u/IJZc2Y0t9rQwpYxqUY/PiD
	uhr0oDxZgjTbKeLPYnYzHHu9f1gA3Vj4u98HbkK5ZS35dnu3V7kW/C2Pki9y+ozjuaMMnIV2AA2
	O+pzaNonr1VAIYBWgK056wUbGKliPI7x2oj3O/WRy3+Yyk4EunfH8zP00JUcsG39ufnSamLfFnI
	BzWZpjwyWJh/V2hw7dkAn+J/qWoZwC28DGkI4fLDX5FK9/VFy6ekqlTqXqWFiQa/AoaDZC4rqbY
	GxrkWJk50BlbLOw3aaZ6/N4oxrTpbS0A0NBMkFpVvYvl7C6LL2S1KUDZqBwe8byZo6IIun6AZgW
	JfLY6ND+4jH7z0c05foDfD0Zzg/mYEpzu+bK2UvCqaBGJCCXTZqoq2JT5/rzTNboVaxdgXrPWc2
	Ibrzp9nIdU8DRxc1JT6e5gD936a8NR7Bp5I1Du++O7GZ99FZKEws53SN0YSP
X-Received: by 2002:a05:690e:480a:b0:67b:f249:5aff with SMTP id 956f58d0204a3-67c5710e60amr35349d50.23.1794245264309;
        Mon, 09 Nov 2026 09:27:44 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c3b90b06bsm4490034d50.5.2026.11.09.09.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:27:43 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: sashiko-bot@kernel.org
Cc: "Joshua Hahn" <joshua.hahnjy@gmail.com>,
	"Johannes Weiner" <hannes@cmpxchg.org>,
	"Gregory Price" <gourry@gourry.net>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>,
	"Brendan Jackman" <brendan.jackman@linux.dev>,
	"Zi Yan" <ziy@nvidia.com>,
	"Kairui Song" <kasong@tencent.com>,
	"Qi Zheng" <qi.zheng@linux.dev>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Barry Song" <baohua@kernel.org>,
	"Axel Rasmussen" <axelrasmussen@google.com>,
	"Yuanchu Xie" <yuanchu@google.com>,
	"Wei Xu" <weixugc@google.com>,
	"Baoquan He" <baoquan.he@linux.dev>,
	"Baolin Wang" <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their kswapd watermark
Date: Mon,  9 Nov 2026 09:27:36 -0800
Message-ID: <20261109172742.774437-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <sashiko-outbox-203103@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5DA6D4000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: tei1db65hqrtzyecmf447mtdb15699bz
X-HE-Tag: 1794245265-419532
X-HE-Meta: U2FsdGVkX1/w0qgVIpAGJpeTXTkvY5i5257aeVpfKez/8lgzbiLH3bQGYbExnhX/7jA3NyMnNMNdGnUkq1dPtlDkvoEHtNNGzi4jBW9Hl9ajS5z2jFcgs0fCHDHYLQ0XG4CFNMuN0NsUuHXDYlSel6kB4bVoq2fKUoz+Z3ulLSev3gpn2Bq9eAO9gPcOW0JQSu/p4T9428dUB+pSI5OPnKjXncdhegx+6d8gOnh4i7SnCZEo0XnuJOhPS/db3XC/dosUkfzemFnX8bUIrVVkggQMm1D1uOzrd4aUANYYSAgFSpumh9fn3Iv89FSWbv6SOUmmjvfwMc01kcSqNF1Yll2WMQwGKrNUyfW4wUFDRS7tQVsNxTkbbwBJ/ieWr9wJtO/gugwNGUoougXAjMdzUUiYmxUK7SS9KF2dPtE1eefY9NXQ2luX8M1oV+1nFA9ESmMvk9FCYf8gwWnZ2rn4x6mg5guaQDoKQs3D7P6s41K0THmmR397GaxVWvAN6wgKGoOpMZwARl4PkG3c/CB9P6oSjXRpnvdPeo9tDAl6TDpQ8Q0mNmfHuh6XgKAjsCgTRTXAggxPhVOre1+zRxAdU+X0xVz02QX0em/uHDXFpkOW4kRxAaANmpSWx8SQu5zT2Ez4OU6JZmYoe1JDLSIn3Wauyt8QDuVMMoX/WGavz3dLl9hnWKqXFHa+n+hNOg7kmytg4ECgWJtPoND3dej2xLc6ESInO72zzuMAAkaQrE4EFsgZTcv5LuCBs2+IbbcM/m/3rXdMfr26I/+jT7caBQ3m4ZVzAskMdZgUGeo8IoQnhWQgZfAJsmYFEBMgFRcH9bDf7x1oXL22yN1bMnnyKlFmIpup/MWvShyZV7HDDhR2zBgc9i1Bepnh4WV4xtYhM6L554iDxKMIYfYMxTxphK3tWMFFJRkofAsMelKPsaKorvNp0U5DKXwNTK92BbkymgChpv7lbJn6hE6/Y2U
 ICB2z98k
 DG7pp6RexghX8yQ49aZF8QCVRy2UZyOz+ZBGcjdb39F0Zgi70g4ZrwvZKAt8u2D2wW1RzJACkXoqCm+4K3gVjS2n8dmHlp+CtzS22bG3wfHET68AXth0RWZKyVkDOzffu+MaR3MVSmLnu5tKmJ552nEVFv/9J48MT/3t97MslH9yUX3AW4hAwXYw1PzxYqIzgENAW6Rl9zobfNG8wSz2R4jTxBpdAiszmUbS+1kyGLUpwICKeV11sw2PiQ/BSlI2u8xzpjmD+Ke8TuoDSGMoxtRdt8ctWea3myfGicvgVw1hzI4g2UEiCno9T+biWqE6DtX8tu3UAvqOlQaFBRXxR5wr8GyD+EKI7S7IAWvObced+0prN0QvhKc05h1tdYBveqLByEH0yHXFABGMZWOwRkq5gQOiRC5vxHAh9J7sFvOKwFJklkn3KcGFFp5AKq9i6Ro22H2C6cPjm8wRnnmnniwCc0+mRsmciALz5292X9Z8eThZBAMTXtYr4R51NXJ3t7p3FyQ0aA+BsSVqJfzHNeLps+6fCnlKo7SJTQ8tluCny4f8YvW1nBGyQ8Vi10KNGPFnQafI8OegffnFmrcHqu7TbgrvBwvIaIyyS4PMoSzik3iNgpJOVAbelVk0atslgOh4nUgZJCvzMVBsn2gcO5hmP149Ou7bPdmMlR1i4/9kIIvt2nU0FtH0aQ5ljl7yzSLSxbiTYVlBm1kaCRtOHNrDhXX5XqoIGuWKBR8A7drPMlRp4VJHOhyJDC5fyNlGXDAoaWO/tL/JYBp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 17:26:37 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/page_alloc: missing Fixes trailer for commit 19c5fb83f2a4
> --
> 
> commit e932dd681884969a67ea7579103c6a9f74477b89
> Author: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> > mm/page_alloc: only skip kswapd nodes below their kswapd watermark
> >
> > Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> > NUMA restrictions") makes get_page_from_freelist() skip any node whose
> > kswapd is active to avoid piling on an already-pressured node that is
> > constantly churning to make free space that is immediately consumed.
> >
> > But kswapd can also be woken up for order 9 requests with THP defrag
> > set to defer. This means that a fragmented node with plenty of free
> > memory will have a kswapd thread continuously spinning and preventing
> > order 0 pages from allocating on the node. This causes the opposite
> > problem of piling on pressure on all other nodes.
> >
> > This behavior was observed on some Meta production workloads running on
> > 2-NUMA systems, where processes with a preference for node0 allocations
> > continuously allocated order 0 pages on node1, despite node0 having
> > hundreds of GB of free memory.
> >
> > To prevent piling pressure on any one node, only skip a node during
> > page allocation if the zone also fails the watermark kswapd is
> > reclaiming it up to. This is the high watermark, or the promo watermark
> > if NUMA balancing memory tiering is enabled. Make sure to mask the
> > reserve flags so that __GFP_HIGH / atomic requests in the slowpath
> > do not get a relaxed version of the check.
> >
> > This preserves the existing fix to prevent piling memory on the local
> > node, while also preventing memory pileups on non-local nodes when
> > the local node has memory.
> >
> > On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> > and defrag=defer, I ran a process that prefers allocating on node0.
> > With a fragmented node0:
> > - Before the patch, 66% of faults were served from node0
> > - After the patch, 100% of faults were served from node0
> >
> > Suggested-by: Daniel Hodges <hodgesd@meta.com>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> [Severity: Low]
> Since this fixes the unconditional node-skipping behavior introduced in
> get_page_from_freelist(), should this include:
> 
>   Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")

So initially I did not think this patch did not deserve a Fixes tag
since it doesn't really fix a correctness issue, it's just adjusting
a heuristic thatthe page allocator uses.

But thinking about it over the weekend I think this might be worthy of
a Fixes tag and a CC: stable since it just completely strands memory
left unused on one NUMA node, which is an unintended consequence of the
original fix that was proposed.

Lorenzo, if it is OK with you I will opt to send this as a standalone
fix, and then send the other fixes as a follow-up to make it look
cleaner (like hoisting this check out into its own helper, and the other
neighboring cleanups that I found). That way I won't have the cleanup
patches blocking the fix from getting merged and it will be easier to
backport in the future.

Thanks, Sashiko!
Joshua

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261106172620.318113-1-joshua.hahnjy@gmail.com?part=2

