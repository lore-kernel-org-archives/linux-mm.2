Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BFD0FAD41C
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06CD6B008C; Fri, 24 Apr 2026 00:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7926B00A1; Fri, 24 Apr 2026 00:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6CF6B00A3; Fri, 24 Apr 2026 00:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEC86B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:03:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55AA3C2FFC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:03:56 +0000 (UTC)
X-FDA: 84692106072.21.B059D37
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8131D40007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:03:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sTVSOZY2;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0FSatf25bGDOpWwH0IGYTUNBidZ18cuj6W5qCjaLYU=;
	b=HWb+Lsjh81+e2oIuaQRsGycpA7F/GNYRxXiq5Uv0YoqlwsZUudx+eA6tAiuD5T8w5OLezk
	Lmhdf38NaMnSO9xKrGOo2oH8pi5iVOE7pfgFXdpHgvXijM23Ddz2MwKRiYc2sDg0PQ2n/L
	c2LgJoWI9JBPSIlsWFgzgP0USBpKo+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003434; a=rsa-sha256;
	cv=none;
	b=zidTsOPum3KxVYqb8KauBHh5g0Y/wGmm7iyu3vVnynn8YWjntscUGOjhEVuYElw+IvIwBg
	MHSNTtLZlvPDAbnlkGDE9zBmy6OjYJ9+kh3WYLZeIpeEpD5kEC891plB/2qo6QGr+tJqTp
	ink18TzCZp7qnAUCY1+i5HhJ41RrKrI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sTVSOZY2;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso51341326d6.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777003433; x=1777608233; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0FSatf25bGDOpWwH0IGYTUNBidZ18cuj6W5qCjaLYU=;
        b=sTVSOZY2789XEtNvpPc8WHcv/+HPXHqtnlxhQgIrDOHVoJOKaDGsuwDCbjjfxY9SDO
         lXMyh6639f+1yM2p6hXauWeYrbEBoP5jl8n4C+JRNPUQPdChrQQEK4skFGLoeNy0I0FH
         94DdQsRdfUsLvGEbk5n6ZuA35AU9xIwgZM9oGLZeXQ30uCooDp8kxC8YtXIu5TOEXSAA
         7Pvh+kyeTkCsQ/oSOk2vp3BBwtX7xGCySJMgW/wy84RpeH7ClaZlhYPzyWFXR80JmIWs
         28H1t6Ily5beVb5tQL6TE0AxWmf7/PcppV5+RFsoY2Pen2plZgbpJz8FCRTlGpf9F28o
         tCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777003433; x=1777608233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s0FSatf25bGDOpWwH0IGYTUNBidZ18cuj6W5qCjaLYU=;
        b=EGyyxtduCww4y5vsmI0U14SmjZjCF7gKEa2NmQ+FMBGJQY8vTZZYRZ81oZOZ4aTxJo
         I2mnQD8Ux3/1dX1wKdV4j30g4ANdJzBMjDbNuDdXUwZA6LzFSkckIN1ye1BFsZNwKqk5
         beSFjXE38AuqvRl4EY4HRnVmhQyu0ALq7VuvGCFSkoYXi15VUov152vqMRUAwJcdApkC
         60eO6d/KaN36vFHUCYuWXoWkQxbmUrUSiS4uqyPhY/pJkH81NZwI83nsfmhhTqEiLtYI
         7zxLD/LOfG61VMJPTeVAMlgLoHfe4fsxEyexyDf7z4xaJtr77xM350/SqbBmqc0cFK85
         dWgQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LHZ3aC2b830LO4zO9qfAAaIiZQtTsW9V5EZduZbY9F6CJ08XBHhkq4ZL8Bf/dFG9PSuLX9xmbFA==@kvack.org
X-Gm-Message-State: AOJu0YyHw5JC25kXBA9W+DKSoQqt+MF7RLQQVY3MdDn0VYSveq2D7FyA
	7pvK97yxTwnNHGAiwhp4nk6o1S9SNv+VPsXqWwkyTTybhCRfCDP8NVyiYMh9Fq/aSF0=
X-Gm-Gg: AeBDieuEZd9EkwxNi04iKP7gVT+kff+27v9DyHd4SYcdvqE+Jadu0Q1u/GUJ4uqg3Bw
	1VJjweWuPEBEbGyRNRGxZtN21bLk6RMyG5mIJ4mYGxrJPk4PXc3cmZGDFNp4y2wozfYW6dfScLV
	7oE0jqj2UK/zrNMiX/KNHNbo2tMOPRFgclOyxLmMR7E6AoSJL73USidJ0lxHKX2EEAMc1FRTw1g
	9eSBrGwkZOaT40eiWxb2g/7eR7IbMzzdhUcLj4BMbdHcmvRPzwhQQp61l2nMaoiffaKAoys6f95
	HdaiHljizsN/5aWVPt3IKzx2QjFDcbEL8tQDvcW36TgMJ8zfR2cIITw5iYNi029Oi3dHVxc5upH
	3IXC3fp2D+R+XWTl98LivmNKDNHTvxh5qaa8Huc1ivV2B6yZ0dW52GCr8CSpNjrHzQ+dV2ZlAFV
	Yc7O1tZlLNZOiQY332Ffqs4txcJLJd/mly+oblKIA1prZPICt1R0nfiy8iObD+z9G1A3qCR1S9Z
	yFypQajq2vWPV9O4A==
X-Received: by 2002:a05:6214:5b86:b0:89c:cfa9:f1fe with SMTP id 6a1803df08f44-8b028324ee8mr410764656d6.2.1777003433560;
        Thu, 23 Apr 2026 21:03:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-70-94.washdc.fios.verizon.net. [173.79.70.94])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae97d89sm178440226d6.42.2026.04.23.21.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 21:03:53 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:03:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, hannes@cmpxchg.org, hughd@google.com,
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev,
	lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <aerrps94j70MkgdW@gourry-fedora-PF4VCD3F>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com>
 <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
X-Stat-Signature: 68wcrns7fp3mp8h5futpxk4abba3b3x1
X-Rspam-User: 
X-Rspamd-Queue-Id: 8131D40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1777003434-951658
X-HE-Meta: U2FsdGVkX1+loaDPbkRSftE2sPXjYatiKI11Km4H3781705epBk6/zz6FD07Xzai1kBBKt75P5YXr7TNtQDKeC325XtHdcIjIw0w8ptelcClg1LMfDGZRLIim1tUf+iwnk2OzA7lHWVDoByYK/xAWgr+qJna6uGrEi8Mk6dmFiWb+Zghmvha80ACiRi21UI/evnhMWZWthWbTCpL5EDHud3knBUI+c1a3zDb3QjaZebJAxhZuIJZWnqjzwkT2/pmM0Dno0eQAWyfvzbxNSJcCsqDLWYD5HIl8DLKNpT5EthnyhO4qjx4eRLwAHSpBH1pfmQq+fq5eK0TXN4nvYhFWDscRlNjgN8MaceImXlUS566SNKuCx1l2bs2EmCDLUOrxcylZBWlvk1NDL4wdlMKqd0TxWdV4IMtgf7TO9MiV99p6VENLQn33NPO00KSR7EfXixGtJeb0h6WHtgbYg7gCoQRLawahQEYPWwXYDDVguecO28rpQQ0AqO9RNy/H24QupnBEKuD/YQV22XLCeaYuxLuMnn6FlcxA842R3oAGrZ66uNQqW/s/Auz/dM/rFN9QZfpDhp+s0O3cPm8ZrPdKljc8mTCB6huuwsXeWeN5jqOnYFts1mgsy4EHKdC9Am8iUrk2/YerfYTbZFcLDXRHTFP1jhG9RKEISH6ye3glp7QsArcMIdmNvfTCldl/d5BuRNsGQKITYTBkrZvWLlR6LHA+/qFd9DiV/JeCQA9HEue3vzSUXm/A91kWIU15MbFrHLLP8WNU+ZXvpg0sfZapfrS+0jO8yilaluxiJ5bz7q0TylO4D48e6nIiEhE4Ea8shFapVuUkB00b/fSpmC2qq/Z0GgTYks036N+MQ7/zmKMiPHRm5UeO0cH/u4DR6CI9V1ND6Tu4WqAqGNzV6sJdYlB2Wd90QABkFXTE+2dDOVVNPpnQ5Np+X1wjKatyFlsPuNWp2/lOnbHBTxCCOf
 hyI71fc0
 7D9S8bym6ClBVfcspKWE4aVq/ewBtsfj/OtsNeL6bT0Io1alP8iaanB7Xc6WVaTAHuX0IQxhwYDTiYXh4mFdH5ddVOsAtrekDN4dMIqs0ltZkETEGWpKjCynESGq7hF1s/tYs5CENSDgiI0YbB0M6+KrFcPpAinBGn3boJGbRYACE/TinLztoilwkyxWNMlKdfVCBbDvHzseDs9bYEy4uIFHTZsiOGk0vDbTGxy+qFQ/9tGRUnuCmwHvy3mFKVjxm+YS5qSIZH2iK7xYUHHmQUH3hquIeIpkNWPbckT2APNIOfsZGIJYsEZchM3wTYN1dbvvMF63M0NcWJ0v4XlQrmE7O0kqebZ7yLtPa1nBtPvSV/OJ6AgnNwmg3AoLezG0YcpKLP5JEsxlFr4VD8Tg2NBeOhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 01:47:50PM -0700, Yosry Ahmed wrote:
> 
> IOW, I think the whole reason we want a virtual layer is to separate
> the backends, which would facilitate tiering. If the virtual layer is
> itself a swapfile, wouldn't it become one of the tiers?
> 

Sorry to add to the fun, but i do think this is mildly relevant.

I've been testing hardware-compressed RAM as a swap tier (CRAM) w/ vswap.

Will hopefully be publishing soon - but was waiting to see how vswap
would go first.  But I think this is a good insertion point.

With vswap - this integration was so absurdly clean.  We just add
VSWAP_CRAM and being able to writeback the folio to zswap or regular
swap was surprisingly straightforward.

The alternative was to inherit an absurd amount of boilerplate from
zswap, and then the complexity explodes if you have to decide whether to
go to backend X or backend Y.

So I just wanted to say, in support of this series, there is functional
value in the virtualization here that isn't fully represented by just
zswap/zram/swap interactions.

> I think this was discussed before but I still wonder if we really need
> a reverse mapping, if it's only to optimize swapoff then I don't think
> it's a requirement. We can still scan the virtual swap layer to look
> for slots to swapin. It would still be better than scanning the page
> tables as we do today. But I think there were other use cases for the
> reverse mapping, I just forgot what they were.

For the sake of discussion - there may be value in the reverse map for
CRAM, since it can soft-fault its folios into page tables read-only.  In
this case, you can have multiple mappers in various states (softleaf vs
read-only).

In the case that you want to writeback a multi-state cram folio, the
reverse mapping may be useful.  Right now I'm using rmap, but maybe
there's an optimization here.

Maybe not worth it "until something actually uses it" though.

~Gregory

