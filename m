Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C50CCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 16:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627748E000B; Wed,  1 Oct 2025 12:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE458E0002; Wed,  1 Oct 2025 12:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AC28E000B; Wed,  1 Oct 2025 12:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 406388E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:23:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 131CFC0142
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:23:55 +0000 (UTC)
X-FDA: 83950066830.17.B26B3F8
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17763180008
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:23:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=DC+jM09S;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759335833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtSz92xfp0z5FAFfCkpEorqCZtizHpWeCxJ+OLFh6+I=;
	b=aYRiWCcElLpBLO0d4ettaui+6wn4EkbHVD3UzZcog3hQurKfs1BZ9jA7JwF+pr6ejWHs1e
	2iiZ5HuM7MjzcKf4qDd1R/l909Jv3ufsSI3nxNi+IcZbZ6KHLj+9JofiZZ2SOmaShAhj3K
	4LJ6eTAFpNEJ8zFR53getpz+DYmjsQU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=DC+jM09S;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759335833; a=rsa-sha256;
	cv=none;
	b=dNih75YpTTuXjLi99DmGqG+708TF6m8u3+DIT8tqSkqEfRyT0TPOGLlr1cMDOLzhc4YSjc
	EkLOrLuQ4ggNcCmuABmiTEKvUMXF9UGzOts0x443WjVxRbbZhI6o/GdHOpwxSRhtVxDepf
	smJgriIKcDaRzU954CJmZWEtxU9yUDA=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-7e3148a8928so811726d6.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 09:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1759335832; x=1759940632; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtSz92xfp0z5FAFfCkpEorqCZtizHpWeCxJ+OLFh6+I=;
        b=DC+jM09S2enDoXKvHlKI9Xp2MyORUO9I5jVT0M1H27x7yAzY/+Qia2HRHYd9AmUS9j
         i+dcrMR0b75jcdqBdDMVlNcw3mj7lxnY0hSE7t8hjwP/hJVou4ZNlZeo+V6omIi4urpW
         fYVElLMSmmicFhoAs0FC81PMAhmWXiu1gd1aOgkS+KqIJXL8DJyHjx2Q551wyHOmxo7q
         C5ILxOG519FM+ZKzpsMsfdjyTGTOAA1cZLgRQDtcSs1b7Wo69EUuro9gJOO3A5YL0gv8
         wUORMtJtE3QQ0+dJ4Wkk73CO5g8iQ47RL/DuPpXeUXOMXUA2UwCRclrXNKji0IWxB5Ms
         h8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335832; x=1759940632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtSz92xfp0z5FAFfCkpEorqCZtizHpWeCxJ+OLFh6+I=;
        b=Ni+BqD+Pnh3Yf/r/KViUr0R36sqzdmRZLUyZZSmL7JBHS2eHIDXIB/EShU7S+InYvw
         MsGZWY9bP3J828jyc6eLu+t1UtdeCY1pr+6NKa31n/xvaOHqBq7Ur6xUZaFBcVGXva2R
         NgyKRqqr5kn5cruMyyDn9wq72EBFC0ZJuBdupIM7GLPdLQQwsIV8kCyuI3JT/l/nsV0K
         K2oVhJ+xvcrhyHLWuBDWUPtNZVhWDkOs1/yEc5fe3Dvey7h6Uf2msYj76JVkaqDkrNa7
         WLMIeeAvm+NXtEhyqZJSaSDXZo7W+NKSFm+u1tC/sJlcFdRnvoUT7KShL7ICFx70iRY5
         yb9A==
X-Forwarded-Encrypted: i=1; AJvYcCVyMD1V/tFHmvp2ruWWn2KlebChmCkb9t0Pyi6wnTnX/XGM/TIJX2x3IWApDuTLn/Rx3Eh2mge9/A==@kvack.org
X-Gm-Message-State: AOJu0Yw+KO/BXZbk1LCpeYEnPZQCZZ7UDSxc9mSOwypB6jIjSZLxvtDd
	bp5onxn3y0pqJhpYftSxhC1N8k31f1FVEy9XLx0sSeGO+daLom0DOQo1HkLdwozD/5hUf1Xo2r5
	I5yIk
X-Gm-Gg: ASbGncsXXgZjWEAC8zOhHUi4JNlKQIbcK4VOsAsAA+ldcaoY72qOdIUrTd7AEQJfh7G
	X9F/oNUZHGN4xgmVyYlemgerK4r9Y2jHoiff4TCz4dUXPfmmXehVTcMHBE2Xi5gsryAu3hxEWbV
	OdbU24Ka6GPS9szBrjL1R+v+F55hRxr9d52GPtByhCc1xseo6esc6P0blvN1NIBd64RjDi0/lnm
	H8C1C5c9Ao9/mW8h/Y6iPbAdAghV5RdIs01XLHr3vuemAKqcVzJ9oGjlXYTbBmXQmoDSuWf5WFJ
	h5Qf+KVeTdfXiytE22LI7cNlr3iuccxzkVRC0JVjNlrv5lCBm+FVRP+Td7458gWzpxYVFCY0Q74
	G5+aUsozO6S4l8010Jy2QGlYlxBfrNFuhsDGl02SW70J6uw==
X-Google-Smtp-Source: AGHT+IFDH7ieVM2AheaHk8sAZnU7O28AmWII1fzXYLrDz43DEjvw/hV5xRCTCYfjLf+80FEaCh6AyA==
X-Received: by 2002:a05:6214:410a:b0:812:c072:db14 with SMTP id 6a1803df08f44-873a704d499mr67800036d6.50.1759335831817;
        Wed, 01 Oct 2025 09:23:51 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-878bdf52e64sm598746d6.52.2025.10.01.09.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 09:23:50 -0700 (PDT)
Date: Wed, 1 Oct 2025 12:23:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA
 restrictions
Message-ID: <20251001162347.GA1597553@cmpxchg.org>
References: <20250919162134.1098208-1-hannes@cmpxchg.org>
 <6B65DE2D-3A40-4E48-9F5F-8E807066DD5A@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B65DE2D-3A40-4E48-9F5F-8E807066DD5A@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 17763180008
X-Stat-Signature: xy41739sfqifhj8ypeqn3mmafab8kydj
X-HE-Tag: 1759335832-101216
X-HE-Meta: U2FsdGVkX1/3zLyD+DCJiZPPO88VsI5YUNdE7VI0sZ9l/Y7cDwrpJIL1KzhNlB+xriRZ6rlwCo8gDdwT4sP72APZW3ZYLrRVK5ygyNC5w3pZsJw1UDvSoVFIKsyPwNGHQDEO2WqSAMHbJcaKeezO/6yLI6DNoKgnzN4rJH2xcSmS3LK6iFJu6fTpTZIgZQha9OtTCgDveYHlVMqmSLS2Rf5IzRqmOYRQ5f4jswKNl6q6YZclERoI23PjOmCWkZY9/VO8DKOqtfZP7IL5xL58GSJUDKcZbhK02NSPY3136F1IBIJyCLnhRXcnU3WsXt5R8DZVr0ckoKAY4N8NNF7TUEeXRji+CteE3v6GuAg4fTjJaVaYNVNLuvHPv+ldAIooeXRZ+/kPcThAaelRSKtwSibne3nWp2r0MBsfl2gNdA0x6y5pQLEnMzPjyp/lBU/3uzP1z5fukWehzshaxg4bAlD+g9XMYwQi8Pv/fbbrEPiJ65hCuctVwbdBrAgoxaN1ZVXiEmdeueXma6rW3WpypS5ZcYx4Q+YxLmN9cQLf9Se37UD3GsVfhY91D5KcrXPWqNinQm2fqEm3ir8rv5TYmnaSZ2nkkdsv/6pydtvNxC7++0FiJ4PS1hyZEe+QmBxrE6S+QUCs4bhJanl0JT1myqMNMS0l5WPiFp3wkUxEc/xNHOXkYwHVjrS7SPU1HqmOMc1rlcJfX6NV+T3873i7P1pB/AJZDhJ74k35SQa7aIIQFQK1D1mO41CE16b3grz8eM+d70bT4+Q71/+hXih+qJUY84ve71pvF9gn2E+o+T9lRucAJFkNLpK+erZ7K8NkwgxXse5w9CFj2XeQAQVW2W9nZLoF1RkNeyqYCaFkbaWlpMC3nlHsFYYz9wRAlcUg0dpd86x53GHaMw6npgeZtRxv8DjKPrcp1bPDGuFInOASb2w4SuiFychX23N89MwvV4nP8VmWxDiHrM/8i5c
 LXBrGhNc
 t53KT5xTRqIxYZ1WpUpJqsAwn0v0ZxHsQGADdYMjFSw78JtCpC9Er59V1+itTTDYvi8f8/8M6wdUFZMZuhr0rpYauzbOvu2abMoHgC4wBdz+iJ8B1CwmO++68T+07HZZtbfcRvUXLoC7a9g/FEZeQePJr82aSZY+gy9ASE9cDaeDVpuKzmLuiD7Yjex62l96nbFiIog27LLT6o0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I missed your reply :(

On Fri, Sep 19, 2025 at 01:18:28PM -0400, Zi Yan wrote:
> On 19 Sep 2025, at 12:21, Johannes Weiner wrote:
> 
> > On NUMA systems without bindings, allocations check all nodes for free
> > space, then wake up the kswapds on all nodes and retry. This ensures
> > all available space is evenly used before reclaim begins. However,
> > when one process or certain allocations have node restrictions, they
> > can cause kswapds on only a subset of nodes to be woken up.
> >
> > Since kswapd hysteresis targets watermarks that are *higher* than
> > needed for allocation, even *unrestricted* allocations can now get
> > suckered onto such nodes that are already pressured. This ends up
> > concentrating all allocations on them, even when there are idle nodes
> > available for the unrestricted requests.
> 
> This is because we build the zonelist from node 0 to the last node
> and getting free pages always follows zonelist order, right?

Yes, exactly.

> > This was observed with two numa nodes, where node0 is normal and node1
> > is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
> > kswapd on node0 only (since node1 is not eligible); once kswapd0 is
> > active, the watermarks hover between low and high, and then even the
> > movable allocations end up on node0, only to be kicked out again;
> > meanwhile node1 is empty and idle.
> >
> > Similar behavior is possible when a process with NUMA bindings is
> > causing selective kswapd wakeups.
> >
> > To fix this, on NUMA systems augment the (misleading) watermark test
> > with a check for whether kswapd is already active during the first
> > iteration through the zonelist. If this fails to place the request,
> > kswapd must be running everywhere already, and the watermark test is
> > good enough to decide placement.
> >
> > With this patch, unrestricted requests successfully make use of node1,
> > even while kswapd is reclaiming node0 for restricted allocations.
> 
> Thinking about this from memory tiering POV, when a fast node (e.g., node 0,
> and assume node 1 is a slow node) is evicting cold pages using kswapd,
> unrestricted programs will see performance degradation after your change.
> Since before the change, they start from a fast node, but now they start from
> a slow node.

I don't think that's quite right. The default local-first NUMA policy
absent any bindings or zone restrictions is that you first fill node0,
*then* you fill node1, *then* kswapd is woken up on both nodes - at
which point new allocations would go wherever there is room in order
of preference.

I'm just making it so that iff kswapd0 is woken prematurely due to
restrictions, we still fill node1.

In either case, node1 is only filled when node0 space is exhausted.

> Maybe kernel wants to shuffle zonelist based on the emptiness of each zone,
> trying to spread allocations across all zones. For memory tiering,
> spreading allocation should be done within a tier. Since even with this fix,
> in a case where there are 3 nodes, node 0 is heavily used by restricted
> allocations, node 2 will be unused until node 1 is full for unrestricted
> allocations and unnecessary kswapd wake on node 1 can happen.

Kswapd on node1 only wakes once node2 is watermark-full as well. This
is the intended behavior of the "local first" numa policy. I'm not
trying to implement interleaving, it's purely about the quirk that
watermarks alone are not reliable predictors for whether a node is
full or not if kswapd is running.

So we would expect to see

fill node0 -> fill node1 -> fill node2 -> wake all sleeping kswapds

- without restricted allocations in the vanilla kernel
- with restricted allocations after this patch.

