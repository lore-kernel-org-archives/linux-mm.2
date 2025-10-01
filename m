Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A315CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E07A8E0006; Wed,  1 Oct 2025 11:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5914E8E0002; Wed,  1 Oct 2025 11:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7028E0006; Wed,  1 Oct 2025 11:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37C208E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:52:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDB72117A80
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:52:27 +0000 (UTC)
X-FDA: 83949987534.29.A732532
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 281744000F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:52:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cvvSnhLT;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759333946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHCHbH4bKQ0EEHiyKfm9TsIjUNoXvUiqJ8z77sZHB1g=;
	b=QU6RQlLPkGMZkX8MUs7/EVUjxuW9D37u31/0t/hL/H/zkchb8jlxoInAJe3i8na+KfAyuD
	+Xhh2+iGlv6stMeAfujFlxjjdJB7AFfuJE7VtSqqKufdhht6TEW7DPAFmrBaw8lEsJyAph
	gqRVqaWatuGH1VGix3noqWzAITduJ5I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cvvSnhLT;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759333946; a=rsa-sha256;
	cv=none;
	b=UGQpx09/OttoUzC5cnakrRuJqXdpK4O3//WRRtNmByiZUg2IbZPKuIBlMHSysTXux1Tbdl
	nQgcRRe88poAp8g1QSoBWeEGORCt2ng+TBmOdt+OP/tr7s61aVU42ws0D/TgPww51MMgzJ
	JhZUP4VzYU4+2no7xnI902BLFJlowG4=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-859b2ec0556so954585a.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759333945; x=1759938745; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHCHbH4bKQ0EEHiyKfm9TsIjUNoXvUiqJ8z77sZHB1g=;
        b=cvvSnhLTdfHEgoIzlt+t9tM9G1mWdUFyR3mdjV0lPfhWc6/7Q+tSV7w2GEiJ3vvQ5b
         6FOLKjwvEPUhNEnvw5MuZNSVn4FKqOPxHRrNZvN32UErYaYdDzjPqMiSxC1+bHePwRRJ
         ay40xFe5XztwWr5AplRZroN9SeqReGtWXrzROUI3DrALpDpsezRn4wGRvKdx6JEc0EYa
         LhPxrGV6qMC+yAdKzHupQmAKMqxLSL9ojXZL9dycwNEU1vJVGpxy63g7bK1CvT4LcsgZ
         0FwvxoTF8rczZJC9Z0R3ERHvlB3BbPZIpTU3HuVIrwBziUs+xPbM8Kn1EQDkInNdegCM
         0zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759333945; x=1759938745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHCHbH4bKQ0EEHiyKfm9TsIjUNoXvUiqJ8z77sZHB1g=;
        b=bKDTW6IZxkHxFqTBMkNJ/OKM6LvgHgOWrdy+ZmdQcRJt2vRuka6WKi8y2J2y5hxjsT
         dkksaFTqg4I9z69xsMwlRdBOP18NLio0K0TK6rKLO02NVkE/DPl+/QaaNoornDtqmQIm
         QlEYI3jiHlnzbjclmHK+6TCoqpjBQhsLpaGDTZDjsO91s1o/f5R7mTfxcUDqFFhvHbEh
         NYsc7x2XiDl3JPWcF18VwfOtDjBZds9GkK1Lc36QDFn/dO/6IhhyGUbYy4w6OX+5tHxy
         Au6ACtaKaT3XyDUb6w8kZ/eqczM2f/vxEK3kVf5XjESIR9f7+aFPG2KojoiJsnI6qDJo
         i8TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpVeFZ9zj4Q81Y8yGni3XMVLyUtql5nx1XJ/fqlrH0drKc2HJp3vc9B7rO9VVpzoMHKcVjOXTY5w==@kvack.org
X-Gm-Message-State: AOJu0YwFRt1GKBaQn0Fo7ZnpRtCkCzA52Rgz/bR42jnOSVk+m35b0Gsz
	P+sHBWDg/nYVaW9wPUb8UxH3IFMJ1aHX8qKRqrLw6bp6zMcaJeBEmNWN+34IE1RrV90=
X-Gm-Gg: ASbGncsIgHl2x5n/4qp5ambKox4IF7UugT7Mpu42Dwsk/iGd28pUw6sRKurQE/dr55i
	mqp5UPHK+oxqmsmL0mi/oNe5IP7T/trVzTZFRD9JMAKjAzH8B48yi7vAzHBly+KXBjB4VzLCV4l
	cA5ieh6oPH229BLH5KQC/aHLv4hWsIl1Ihdx3v6fI6LEyTf8iq4KdaHmUaDvTArmlyhBMITIPEG
	ppB4g7q/O7Y1eFVIkLVtYLNjo1La5odmRW9i819KuV217HzAPtQ5QMGmVwtsmr/MIW+otBXpDEB
	0JAM6D+r68HfLLV2Ffc3MHcLpdNTS6JY28HnnqFRNCKDyIoyshnK8q07Es6lonC4UBavjtD/K14
	E89Hdm2L+NqoQJYiSIW8dwzgJKieS4zT5Do6Rn2x2to2UcjNGBZOODl3BnNu1JjxEowsd0N/MJY
	OmDLBb5JAjIghKUWgoi0WRVZ/d81A7/A==
X-Google-Smtp-Source: AGHT+IE9HCW0wyGkJZlnA7Hr0vdt3tar2buiMFkEIfn9/MUkRsZs4AEYdzb/URPhW2fv4DE/k8ZKgQ==
X-Received: by 2002:a05:6214:62f:b0:824:30f8:ed70 with SMTP id 6a1803df08f44-8739d146d6emr53562716d6.9.1759333945123;
        Wed, 01 Oct 2025 08:52:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878be52aad3sm112936d6.59.2025.10.01.08.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 08:52:24 -0700 (PDT)
Date: Wed, 1 Oct 2025 11:52:22 -0400
From: Gregory Price <gourry@gourry.net>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA
 restrictions
Message-ID: <aN1ONiuqoZQTliHG@gourry-fedora-PF4VCD3F>
References: <20250919162134.1098208-1-hannes@cmpxchg.org>
 <4a793133-6cb3-42d4-948f-84eae6fa7df3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a793133-6cb3-42d4-948f-84eae6fa7df3@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 281744000F
X-Stat-Signature: pnu8pibu1gczxmeopwqz33z8uas5beub
X-HE-Tag: 1759333946-954615
X-HE-Meta: U2FsdGVkX1+qyMexBhAdVSHXV9lhMmLb98ySBvSwywAfbC6UKCP50uoDIMug/L9+i8CrE+MIdW9BiMV/b9srmClXL9SbHD95LbRCR54MKDDXj9HHf231+FjVUq+YfpEJk9bjgM8k6iL4fJCp3Q2nfTyA0A4BLVzQYtz/M+abLayBRcB1vGUi3bagx/c59MqrPx3tgXFQnOW5D3ivJD9uUf7XMWbVpW1fRHGZyZNUCzd8YCYS+lDZs0pIz52OfJYF7JaPOl50+HuQ8RjEcasIl4wnBMiwtu/fXa3ztV43bPrXuksV7Am8DA+C4ovXBG0RZenQDbTCuKD7qFjNeNptgzm4NRL6kKa8X4se/elorvxWp/mvN1K+C40H7nb8zbWhbVsId2BCydxnDKGdm+CigH2W94Qf2ZPElb4evBcHMUXoMJyoIIX6zzHv1J/0ricMVJhzaRDEvFr6BH0YpXCb6VtvxOevwGzskNHy9Jbyhsm8uT6DO3DwOJpFwLhKvQUnafuWEj8Eac7hHqTrXbh1ZNkAKBPnE10Ggt1nfifEgPZjKoKNcImEaXlfXWPHJVo71yVCg3R2bgqe2XNkm6sxjBddDLdvSB78jvqJclwKhamrTUfyND8gEHfns/R5/tw6tJOl1CDCHE/TaitL800goKZswqzDmM4g7hgQDky2RIDRPANfcD6dBVhnmb9fw27gveoRuGZD3yo1jD+RPBc+OjfVXUj4LKvU71Emv7kqK4MJVF/Jth09Cp8ENP4k6o4MBgMVsvR4mbVVh354/39rHLyvIMm+33RVjm0ZaWlKvwRoNaaxE0fS60Dw1C7fR4tIEu5vsPDe3iX8WgCwzHVyfxgS8KBda5oIc7gUfwFJNJEdtd8IXhAAaJ/SxhJFVkONPN6iqftax1MdhEK+AVGNSnQ1dkwkNuxLMDzMvb8REc6dPAed7l1Ai074evHxOsjDmi+8pftRuzbHc1432IO
 FQKPWpol
 lnOa15nXC/WUSYQxLzLHS8iwzm2HSb70cVNKEn7ISy28gr3Ukj7UUFtoGyeGGk1dr3rp/Qfi8Qz+8Ts+TuBZHdqVp1N2GaAHcpaV12tPdWA/dLb23SdkcBJFy81DHTM+TpvFWSewE4VG8sKbAt3Xi/LpnWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 04:59:02PM +0200, Vlastimil Babka wrote:
> On 9/19/25 6:21 PM, Johannes Weiner wrote:
> > 
> > Since kswapd hysteresis targets watermarks that are *higher* than
> > needed for allocation, even *unrestricted* allocations can now get
> > suckered onto such nodes that are already pressured. This ends up
> > concentrating all allocations on them, even when there are idle nodes
> > available for the unrestricted requests.
> > 
> > This was observed with two numa nodes, where node0 is normal and node1
> > is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
> > kswapd on node0 only (since node1 is not eligible); once kswapd0 is
> > active, the watermarks hover between low and high, and then even the
> > movable allocations end up on node0, only to be kicked out again;
> > meanwhile node1 is empty and idle.
> 
> Is this because node1 is slow tier as Zi suggested, or we're talking
> about allocations that are from node0's cpu, while allocations on
> node1's cpu would be fine?
>
> Also this sounds like something that ZONELIST_ORDER_ZONE handled until
> it was removed. But it wouldn't help with the NUMA binding case.
> 

node1 is a cpu-less memory node with 100% ZONE_MOVABLE memory. Our first
theory was that this was a zone-order vs node-order issue, but we
found this kswapd thrashing to be the issue instead.

No mempolicy was in use here, it's all grounded in GFP/ZONE interactions.

> > Similar behavior is possible when a process with NUMA bindings is
> > causing selective kswapd wakeups.
> > 
> > To fix this, on NUMA systems augment the (misleading) watermark test
> > with a check for whether kswapd is already active during the first
> > iteration through the zonelist. If this fails to place the request,
> > kswapd must be running everywhere already, and the watermark test is
> > good enough to decide placement.
> 
> Suppose kswapd finished reclaim already, so this check wouldn't kick in.
> Wouldn't we be over-pressuring node0 still, just somewhat less?
> 

This is the current and desired behavior when nodes are not in exclusive
zones. We still want the allocations to kick kswapd to reclaim/age/demote
cold folios from the local node to the remote node.

But when that happens, and the remote node is not pressured, there's no
reason to wait for reclaim before servicing an allocation.

Once all the nodes are pressured (all kswapd is running), we end up
back in the position of preferring to wait for a page on the local
node rather than wait for a page on the remote node.

There will obviously be some transient sleep/wake of kswapd, but that's
already the case.  The key observation here is this patch allows for
fallback allocations on remote nodes when nodes have exclusive zone
memberships (node0=NORMAL, node1=MOVABLE).

~Gregory

