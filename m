Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CA560A2623
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Y+zjWGKn
Received: by kanga.kvack.org (Postfix)
	id F1E2D6B070E; Wed, 21 Oct 2026 09:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4ED6B0710; Wed, 21 Oct 2026 09:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31D86B0711; Wed, 21 Oct 2026 09:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA80C6B070E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:42:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45FDD14051F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:42:25 +0000 (UTC)
X-FDA: 85346747850.04.422B371
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B34E1A0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:42:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y+zjWGKn;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792590143;
	b=0w9UxhlyqN6Dry3tYLfU+zvoFKjE4HFeVPhL3bcPmkJw0be6ZNobpDQuQtucQjOz4YKP4/
	Dcg31TwJ1R2f2gyUZ40wzvozsybDQElE2Ud9eyMdtOPvfzQ2/ZVrxgMBFgk+3Mhd/hHbyD
	SfZX2L9FDypAzrAs0Oe7YEp/Qej0lgg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y+zjWGKn;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792590143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bibqzip471YCJrx0iwEaAHwRkbbTyOfLVqUM8nPUu1Y=;
	b=UUVIehhl9QowKpstsYJRc/bjhWaHr3zgqyZIIWWThYEKNUQET3knLKmiITrFz+rQwxxVC8
	ADzBaZiXNJUBu7VsbxqILAE8qCialmv00Ca16ghtfwzWg3DVOvfVI+M08B5J7f3IhQjB0t
	2LfacBWRU/1lKSkrUePjHeMXkb6TZEI=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f20b304c0so84926685a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792590143; x=1793194943; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bibqzip471YCJrx0iwEaAHwRkbbTyOfLVqUM8nPUu1Y=;
        b=Y+zjWGKnBmLzKQAXiQOloUgw0S9NxG7ZERVCHF7WTALikVtNevQS9w7lGHXLD7x5GO
         ytP8Mm3dRBQafZ6wXhQpyjq8hbLQ1P9EVIfMyH83XFuHApRGzYbFo8MtqKLGXiGvInC5
         wQkX8LDztD5MTNB9kVqmDITOhFwQc56znxUMEjIgkERbV6zcZumZ+ZFOkRAo/nCiOdps
         twGtqD4uSjID9cJufP9rWNisrg2W45HBN37ZXPom0H5h/9wEnTuNtRnS/uLUHzlbozcY
         LRuA5D7UZhhH5CgDSy1AFa0X5kEch40nIPmsZ7aWBtqHGlyneSgXCLJiirM4k+pEsQqk
         dOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590143; x=1793194943;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bibqzip471YCJrx0iwEaAHwRkbbTyOfLVqUM8nPUu1Y=;
        b=J/vJN5rt96gihPqkY+49dNA8WtM+/62aX8G/xZ8YPRI7AU+S61itAOGHEwuhLQ/Jxt
         inxBsOvNQ49R0RX+n8QjWz4xmdzzUzlKs+Ty4G9JmAEb0xJx2aqf4TdX7INgMEUIgCu9
         W+Ce0WMuYKg16cPcK8KzGf8cNy375NjhuOuZuBUIZgTOnnkuxyF23lfbC5o2kYjTpUvV
         TxDHLin6J4aamr8l2eC2En0t0XpHWPzcWzHtpxnocKfSBILxcBEpBP02bOyC8Z5fBgDZ
         UbP6IcdHv4+BzfxulOBTzlevveFXhIr8eXN2wyUw9e0x5p8sJ8lq3SQ2onjLZWus/3PO
         IBkg==
X-Gm-Message-State: AFq9FYJ1Tjudeh9aNuqh4v2nwLC7880rYkjScpFJuR0HnbAHdgRtDBpq
	izi2qdGZQukK7fZGFqrxtBU9OAr1lGK+AFpF+Fdc06lMDhQSq2GQWNV4J4+JHxll7UrZL3YB1W6
	24QoM
X-Gm-Gg: AYBFou1S9muWmg2aZj3NXwqmXHvO2fbz8p8f2dRYA4eNJ0UeEXPCDg7l77Z6LODH8yB
	d4OwPq5d5Sv1/LDV2Xtq63n78NGP8eoYulqEQBXhMRDLFnpkaGeno5NezfCCtirEIPxvgriZZwQ
	MfUSTYt18Htebrrt+RcKlCS2FEchsuYFwtW3Oa6wVdDjhdmYWsS1Arg71ZPu+jnD9umNlPZqgcz
	WpmHduLpqgHblCvaFIXSFKp+/UQp3wE4ilaYmzK1hR09jF9adJ8nzfmxk9KjS6Mgu28HGcoHA8u
	2Biinmqh+g+DODGX2FMN66eDYk8zeyMntRzjzZaGGDO3qzP/sTTutcLBPDa5LEHP7w6K73v+QwQ
	U8LX6/HMt0ZAXTME7zHfIr5V/QE599H/kiqHNFNBe5av1gKHv5uDEzy+ifEA9G48Fy7wWQgxDvd
	3YW2neeuzuq1Xt9Ysdz09v6ObprXadh9dUlOb0LMYUiCc/yrDg8j6ASWsnCyIs1xiG1N1rG3qv5
	gnY+/Jlz1wqUPUhp/dpYHl8F2LTWMSW7OrWYMo+u2W+pIVuA8Hq9nz0NKlMKHdiFtyQ+LyxEJ0v
	CEZPdHR+G/v4YkFsHo0fV00M1orsq47o1IRm
X-Received: by 2002:a05:620a:2556:b0:93f:258e:502d with SMTP id af79cd13be357-93f57f5eeaemr425264585a.63.1792590142562;
        Wed, 21 Oct 2026 06:42:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c6ef4dsm261445385a.3.2026.10.21.06.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:42:22 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:42:20 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atjA_SOLnihm1TmT@gourry-fedora-PF4VCD3F>
References: <20261019185002.3428594-1-gourry@gourry.net>
 <atiwhEIudhnK0pmQ@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atiwhEIudhnK0pmQ@gremlin>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B34E1A0008
X-Stat-Signature: 1a4irxnmnn7cxbi5nfjrx37boxhhj18z
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792590143-585005
X-HE-Meta: U2FsdGVkX19MTgy5tZytuoarpmPBJxOsTTKmS0RGpHEz4z7gLmep/y2YtUCZ0qxcx3XIgYZg9dwwMpAYN7PTYZhGR9sW639N7rhd8Ma2cDpkkwt2zeL0WrlFnVLqfpV1P0ErdQmpdZFQc2kJOO826kgfSrdw/DNXKsZOoPMs27wh8x83Mih0U+gAcyQfpWh9Hom8JOOTuvtp9gKVFUzxOxkFZOjcBX4B3EvTOR/pvbVjNIvpjklWpGlx+RsZKPGHmYEjgGvc8xuX0Hg3ZKeXXfqTvZoun8DWJeD/r/QuB1Gpdp9Vc7q9OyLLS/sUyY45cBWVOPev2Gd9Yu6yl85rFoc92KtcDZ4rDqE47FxAb+U0kCVMrHrlkzj7MIR3J4kTEObuiYzSWCwMjJ2CKEBm3EdNGxe4TTlbPQXdDWAoMPIgy48+EBb5K9OJC62bPX9axrP0Ytx/GlgYB7mEbKB+wK9WnbJJYgor1F9KjxJ0+Cj9hAE9+9Wt8qFiUAibSY9nzPU8wxfw0iwGpmlKYklF0DCgf+5Vs9VcMneGKo2j1bSxOM4/bZROwvpuDdDenaAxRfOJgf6KujwvccEkztKJzLbhD6Jgdri1gL8g5JLT0B92FZHSN5MATEoYyjp4c4rrPCWaqPgTHi4r+gBK4YyyPBH2ztarxud8hplp/H4/Enmi15KNnsOnss4K9bOWMW+ofdzo6yNJ+krVylx6Z9jdPfH/hgrRq8M2YL5bJ99zxKvHxMVe4sKwUjbO7DeDGZFtlElnKGa+qsnXyd9/RrY3BTvPCozrZ5qnOkJ9e48OTsjrEa1XW5DjMfzo7zGuoRQYShrTMw0XDLhFK/XUxl1PeW8Cg+TySD2NY/GDnAGwJvraPe91lcGjs2BlJv198LOEGBdtRfq/r7468PIfPApzWe3I4Xc+iKRAD137Wk/ZWzumzaRZ6PWpzW1m4UOpUfXCqxAqUrXgMySwflV6H1u
 e0gH195K
 cjdsgZpI2yWeOsxPOzcyCUmP/PEYGRiLbuZGW0guuP2+NumhaWl7XqiyfvH0ZSTod05aK5Q83eSLTp9E9ZGJfQ6mOfQHAhVFpOQ+lM4RevaHNuYSaYIubAf6JTm2Jegu9c0yeOqRZdeXoQgnKTGpzdPNZyQGRoN5h8H3ajYma4Ls4butoaX+lvq8u2Sd3+XVFzIKbuOBGyku8v7CZY78rq7jfa4tS2L/sYI7CsGi+7eOAtJHDvIojRoVYw8XG2LPbqO3NsVKKXYF8wtxMe6rR3mh1Y4cpCK6AzfG0KOnRCHJp8TSgtKvoqfqbbamW7tNNgtR/uS+pdqA3Y9tfQhwRgvHrY0+RTZNnpzziRInUVXcHkJAG1j1oC66b4HglQHqg4kUIGjF1vdBM4TYN5YYp7O2naO4NerS0yVEm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 01:31:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> > user_proactive_reclaim() limits per-node reclaim to
> > gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> > allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> > folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> > reclaims a node's movable memory. A movable-only node, such as dax/kmem
> > or hotplugged memory onlined movable, reclaims nothing and fails with
> > -EAGAIN.
> >
> > To reproduce, fill a movable-only node with clean page cache and write
> > 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> > cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> >
> > Scan every zone, as memory.reclaim does.
> >
> > Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Seems sensible to me, and since it's become the review of the ages (TM) let's
> try and get some kind of tag record here :P
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

1 line change
20 acks

This is the way.

~Gregory

