Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428A0C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392216B0092; Mon, 20 Jul 2026 14:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343D66B0093; Mon, 20 Jul 2026 14:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235D66B0095; Mon, 20 Jul 2026 14:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA51C6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E141C160284
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:29:44 +0000 (UTC)
X-FDA: 85009993488.17.F797529
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22BC718000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:29:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d88fxvTa;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784572183;
	b=fhTt5mWlyFC2hPZaiEOi4MXwadgehQIncjs8mb1TmG+UXENbPnuTUH5/+2lWWjYRr5CfD6
	ryIoKLXF5Z0KCaVDyDUiDJUpU4PNd0D1KK+rDWoynmbLxXdZJrnPRMxpYfbTx/g3TL8F4o
	awNLb/V/AxKnUfj1Gv9/3HrlLz24NVw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d88fxvTa;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvlY+ZnuMunvG4k74l6eGWIXWbaZN9lfqhpu+ESLMPs=;
	b=zK1nQPI+Xjt/pe+CZG51mzsWfEUNbtX8g39FjGihoRcVMhuHhMyIzWVt3xkAiaPkB5YNmh
	Nks32TF1TwuIh7SoVdJxz5XAVtnel+D+iDSjCwaJagrzzLQBsXxo2ayS37G1SuJiEelyOL
	bHRWlG5F1VUb3W1iZIZBiv4JUJR13e0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0c45c580so90814121cf.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784572182; x=1785176982; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EvlY+ZnuMunvG4k74l6eGWIXWbaZN9lfqhpu+ESLMPs=;
        b=d88fxvTags50Q5UY8Ka8lBoYLjue5p2Dr0XLw02LW2t6920NZHd8tFdNdOfaVHvfS4
         wdZA2ytGbWPcKepBen3022yg4CzqdOZsvNSqJ6sa3G0WGzOf0D1nZWfdTEjQixsnpuOt
         I9ysh0d2adLrUnhmaZcJo+LPKNKMYwSth6MRvWLDNdamkPUKdjCQ0QH2EzgsJtbHPVrT
         fvEAzdW73IQAFYGe3VLPxQ/UrEYQ6kWl7zeTMpkcTEd8G56VWUnSJ0k1v/UROCTVmZ2M
         FG3k9tTpJpgYyAM+RQdc7xyPyXa2HiPUptheAeGZnfZZp5ZFf85UuRUyVuaMqe4MIJOq
         poyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784572182; x=1785176982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EvlY+ZnuMunvG4k74l6eGWIXWbaZN9lfqhpu+ESLMPs=;
        b=Bggt3ccepdVSJtqLFHtrHqPSufzMMai5pP0B4zOuDpAwn4PqfqFd+S03CCyuAKJ5jU
         pOpEYtLNQc8siA857n6aH9jIn98rrhqzFIe1qImCkcaBiZ3nQAOVbsxthS0pvt4ceOZe
         xyo6k4FNj4jk+ye1tIdEqXYxmAVgRKdCZ6cQS6DUQgyX6avvBy8kYBVpecfB/aZ/F5iK
         foRCfzMYQFe2q2S5emT/jntGGDjb+AMJ5MkrOt78c9Z1mfBgEQfzfy7U34iDnVpxrP3s
         pCg2gJXjSxgqUtGHbVquByD5vEuiiM89cfSvjk5u6PUAxXZGm961W6fGdkAaIZD4Vp5K
         ymtQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCnm6yOIQEms+bFwijQmK67En3TvFJrAh7L35QcTM2FTMLzYfYSbNsEU+x6CQWoS3H20quDznpMg==@kvack.org
X-Gm-Message-State: AOJu0YxH8eeK+KOHqv0D27Ix6Y8MC0lnerZD9rWYas/g0QS8/N/5a1fO
	dtXQqsErQKpjVj+IyTZogwMIVK7092ifgR7WH5m+hR5HcxFNcGF2CPmQnFk3uEIwuAI=
X-Gm-Gg: AfdE7clupECLPpl/SV011a45h6V/CeTiuo+rOCmqtISst5V1D7x0HL3644Gxr95MHoi
	jOkuey5tz6DnEZRoDUVfe8JHMO//6OvoewmY9L0bDkpJNOjVou/DO355ETSQO2e2aWwUPV2NxpS
	l7gQACHHEEqlIC7Hfk9V+0JITxP5KO+cTmPQ7tEf0zNwpWbzArNe6e+84jXCNRR6bXtBbfrLqIp
	uM5TgWjc4i7GnAeqgTeGMSD1Zzj8cZ0AxY1lGbZ/OpYpQwzt5XWIw2q76aUzUzPD4hkR+dlsftI
	uKhQTGSUxv9QO+ZjTD1sKzHklbbgkad/x1w0NlwmZ7w6ZD8kXli7N9fPYykc5/QenD2NZX7a0TF
	9MSZgQGT/Zu4JA1nh0yT+PT5GbhK3+ml5n1Kk0wT1BWlWBqBtt/OOFILHOPV4VZMHki4JO2RxQe
	EC4j5XpfYdXOmBQ2du9OCN2AY+oyaPG6/mXRh2kGegNWbJx+0++/fTG8nnmuTHdxnIm93p
X-Received: by 2002:ac8:5714:0:b0:51c:1857:b622 with SMTP id d75a77b69052e-5213e082210mr141591671cf.54.1784572182072;
        Mon, 20 Jul 2026 11:29:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214c5cc8d5sm80304611cf.6.2026.07.20.11.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 11:29:41 -0700 (PDT)
Date: Mon, 20 Jul 2026 14:29:36 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, 
	Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Message-ID: <al5ldslYontDDKPJ@gourry-fedora-PF4VCD3F>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org>
 <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
 <al5gQgnBCjNCSD_4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5gQgnBCjNCSD_4@casper.infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22BC718000C
X-Stat-Signature: okjq7wisrbs8iihosir1jdhjn34zx7b3
X-Rspam-User: 
X-HE-Tag: 1784572183-354981
X-HE-Meta: U2FsdGVkX1+24vs8klqOAT+1VF5q3S1Ss8knpgOvyt219DJ6HqPAQi3jb5GxBWw4bP+ASuMDcIHzWocsrAg1lMEkRY1YNKr9cWJTgJ26zzcWA3kH0SR2ZkG23Cd6uZeozHlAuo5fWrb6eGuriGXzRxrFrIbhPWcC6tyh9FpQ776Z0B7flgQ0TySktxyQsl7cl2MdLJS2OFeXDRRa/mYbfLX12DUBwog6pgoSlP58Eiri+4FycC7cbooV0CtvNoF133yTXbXr7ZO/qMpWtBL4YbgMhewaNalwMjAaujxMwsFQlHuZ/Ap06KVOByIjbk9EESqAafo+pwWh85nMPrIxZLqZyR2kiX+GFO+dS6v3dzSwh4HxJnXMUixCHIUFrfOG75O8HwIyyIOgJs+gI/jQjQwrAuUUQgdFD8NnrZqO18ZtGCBi5WsSouns/l6sO8wpXlaoX8y5kfZYYxiNZK3WZ7rU/Lzm4MAVotOjhEkdxQtl7YjjBC6Af/FJjCuLxdqZ3qImZGs3YrNsf9gSpEFWcYDfqxTB+6LPqtVGTx+Dao/Cer30SYb6CPhD+xoxihl1nAkGJTRidwvGuCsePzbqtJdJSZD6vY6fHYXloEIMX59tszwTDmwbzX+kotYPuGu/naNTGQl1J4YOHxGVD3oYIHm4AbhK6Qa0dWjd90TiV3+AdDTyGaiezHMSwjJU9J8+TcRuapBLusO2R+uA9hsJdMhRmxeS6fRDRGG6ch+vKzOusT85DAIJZfpDzGG7Isnm+HPM42dgMMyXSRnnP5362OWiLa85b5Yv/RAITW9k8C91xmcaXQhzrSjZDTomlZ+uo14nrBvCMWOyUgzt0AhsvqL8dvOTygazr6xt8hux/hqtkaifHLjdpJHwqoJepXllsbOJr9t/r3WjBNMJc6zLsnadQ1j+Uo+ljMkYZIK3r3i4n6QC3KqFlyjeiEOMIXOJOCoMz3LNNr8JJ5thVuj
 lULf3pef
 aqQ0gmyk0ky4EhXpKPUuA5XvsS7XOoHZbepZbfc8Pj8tr0pfOE8Fvdi8WbhtehyMLZ4FO3WTRc76oFS9+QnQ/gTQezJ+dFwE3h3+L/Cq7DXcH7bPaRruSNDs4Kz+uU5UtO5y4NY7yCcDuTkmuubuGH7Da22BuywLowNZ9W+pDdjc91dJCsdpcBLTfr9xra4BanqR6o0yAhKeNVHMy6O9ObmdZOEBxwDr1lBfp0Ty/TOy9Qw9jQYPnDMN95HEs47kAznyDiCrF+XKZI+bK2lhZViM/TiipdX4ddlfzPKCilk8DnG/SV7a7het0Vb5FX+DK8yjXZZD9f1TIGzZGI3VwQJ3lh4cmWiwLOLeIcFKHl6X4WEVpV3JSkoIwTBhlsX/naRG092eNnWC1a4Saw5793XA7Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 06:52:02PM +0100, Matthew Wilcox wrote:
> 
> > ... With the ulterior motive that I want to add a new parameter to it
> > that actually _is_ mm-internal. Namely, alloc_flags, so I can add
> > ALLOC_UNMAPPED to implement AS_NO_DIRECT_MAP, i.e. the next iteration of
> > [0]. So basically this is
> > about trying to extend the allocator without creating a GFP flag.
> 
> Yeah.  I'm not sold on the whole alloc_flags thing, but I'm too busy to
> sit down and think it through properly to get involved in a proper
> argument about how it should work.
> 
> My entirely unresearched and ill-considered opinion is that the __GFP
> flags should _be_ the ALLOC flags.  We shoudn't be translating GFP flags
> into ALLOC flags that are what the allocator actually uses, the
> translation should be done at compile time.  So if GFP_KERNEL and
> GFP_ATOMIC need to be composed of different flags with different
> semantics, then we should do that, not invent a different set of flags
> that special people can use for special purposes.
> 

alloc_flags is putting me between a rock and a hard place.

I figured out a clean isolation mechanism with zonelists (new rfc is
posting today, i'm doing one last proofread), but it required me to
extend some of the mm/ internal interfaces with a zonelist selector.

Since Brendan's base work made it in mm-new, i decided to replace
the zonelist selector with ALLOC_ZONELIST_PRIVATE as the selector
to avoid *yet more* arguments.

I'll be posting with ALLOC_ZONELIST_PRIVATE on top of mm-new, but
the churn is getting painful.

It really seems like we just want an mm/ internal interface that
exposes struct alloc_context for specific *mm/* callers
(see: compaction_context, migration_context, etc), and interfaces
that keep this nonsense transparent for everyone else.

Then if you want access to alloc_context interface, you need to get
export approval for that component (similar to EXPORT_FOR_MODULES).

Just spitballing here, but the churn is killing me.

~Gregory


