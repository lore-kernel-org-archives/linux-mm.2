Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA72CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 02:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59FF8E0003; Sun, 19 Oct 2025 22:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AF78E0002; Sun, 19 Oct 2025 22:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9CB8E0003; Sun, 19 Oct 2025 22:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77F1B8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:23:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D10D0BAB50
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:23:11 +0000 (UTC)
X-FDA: 84016895382.07.7FB7D6E
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2512C1C0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:23:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P9HITLYs;
	spf=pass (imf20.hostedemail.com: domain of 412752700jyf@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=412752700jyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760926990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Bgp43BYkKjjjKSTHmt3Hs9T9t92+4A5IAgPpLT+lZBw=;
	b=W4bJiN2TG3R1RHJ1ivSHx2DaEz3baDWyNDYkVwgunG9GnZnTBV9vdq7fDYPB/EnpWH2gVj
	bDTbTr/qgahn9EQQeZW8i6tBWfte9c/FPnyp/JHoZMUKNu76lJJFn1kBQSa8i1+K5mfB02
	X37/2n/G6w1YV70gCkyVEdQjitzdG4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760926990; a=rsa-sha256;
	cv=none;
	b=whAwFdVqHV+ftmfvI1kX7x10kzqGgpduskk26IDxxIXmbzWdCP5rnv4MzX2QDF4YpzLlKx
	MNYNkpTW+pyP/UEELzW1k1hs1Iu2ABXoRopjw3HGOgb+0ZDsaUGtRX2R7ak3BHyozhk7ub
	FufXAA8jO+ddx3zXbfgNvmUXj+8mS5o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P9HITLYs;
	spf=pass (imf20.hostedemail.com: domain of 412752700jyf@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=412752700jyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso6388196a12.0
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 19:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760926988; x=1761531788; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bgp43BYkKjjjKSTHmt3Hs9T9t92+4A5IAgPpLT+lZBw=;
        b=P9HITLYsdToOteeesCobCKf0NwvYRQZnhHd4KgSrwgh30fJ7VfUVpBb5BY9Y/d8mfC
         b/hQUcBEl2eqtLJJRWatxmFPg9UUYX3ilWDUDxd1XL75Px1UH7dlBzrZAz5k5P3wJwVV
         ItXEMIMnsQEXVc2BFaSxwUqdNB8ycDxrLHltwPo+i5N6kNmNwpCE1AggJtlqhTvDuiSe
         mcT6wVJmjLg0PbHCly4/eWlxrB1iuKJ89MI9liDzRrnwGxFz8u9/178YB+s03zks/SH7
         fBad/g3jU+fXGzzHpyY1/eszDvNIadLv4tM6GmusTVfqMRHSCP24nfyhnHtg0VJV6YNM
         ulxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760926988; x=1761531788;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bgp43BYkKjjjKSTHmt3Hs9T9t92+4A5IAgPpLT+lZBw=;
        b=v6GPa45Kr3PwpAWsllKMe0MJHnIfcACKD46KE1psj6GcrFtawN89TCTGBx6KJZxzmW
         5xEFP/pnfEiNDOH12YKL5MteopxAvgia3CABAy7P5ZapZOS/TMz956k/2+SsYmLt8a2P
         XcLo+Kxxm5T3KGuxdJ/u0h8HHLCNLRUig7v2h07u7+Y5vOxC6m17Xgi+bnXpPJjl5xsJ
         uD9hYhFmZOITAsyd1AO4PkAyqxInzzAZGYzxsP82M8W+u5dkzKBCledK84wW0XDDlzP/
         987PAW1paSPOa7O5ONUjuG/Dv8nZUzcl6QiYHajl+OiK0VcNOF99joN7246fLK8XTluf
         Kovw==
X-Gm-Message-State: AOJu0Yxd5b2cToaFlkylMt13IqIVzI3vXX7GAwO7GIDrG30uTlqqkr6/
	umwZxW4y16rJec+4QL7/zZTf24vTknBYQ8znDBsWymO+piyILImsdNe1wCI6Q6KlZMScVqP7d4S
	cOUCKEaGGEGFqnXVyNxguUJzEzfNOu5SFwEpIV7+15g==
X-Gm-Gg: ASbGnctUYQUXSR4Bi/jFthmqUj6RFCYG1si8iqsmxS107jaSdkhvq8ZD62p40HTdlax
	+HcsmxOqPTyvOz52zLYV9viyP71iiQ54GtdsQ3tpQ91/8surpTMMv7PYA5Qco9a0BVmq5WVA+md
	0922tZ9DMoPjJKkrkRjzdReIenQecuOrdp+ZgTvuavQ89S+gbWZGt7RWEnKoWXdXTBSk/wt9JGN
	oAuuZbFQjSc7PxD7IlBcdQTLyCFgQm16QV3Lmxz8zdxrxbiBB8JpgattohkLttY4AHOZkwB
X-Google-Smtp-Source: AGHT+IFAnotMn1a+HkpQRSL9oMcAYj2bMv3VAIza4Bj7ZwRedHx85zohicwgxT+9kUq4T8N0L1yyDO1k21cOWoaI2vA=
X-Received: by 2002:a05:6402:2813:b0:63b:f0b3:76d5 with SMTP id
 4fb4d7f45d1cf-63c1f6f615emr11464055a12.35.1760926988174; Sun, 19 Oct 2025
 19:23:08 -0700 (PDT)
MIME-Version: 1.0
From: Yifan Ji <412752700jyf@gmail.com>
Date: Mon, 20 Oct 2025 10:22:57 +0800
X-Gm-Features: AS18NWDq8BnkBA_kGouHvm8ol7P6_2jM2OSHoOqvgtwF2DRlPDa9YQaeEYFHm1E
Message-ID: <CA+9cq0keWt5GP7=U_JrUEzw_wQzG_BHnM+n96vLwfMCK13r5Gw@mail.gmail.com>
Subject: [DISCUSS] Proposal: move slab shrinking into a dedicated kernel
 thread to improve reclaim efficiency
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: multipart/alternative; boundary="0000000000009b0a2506418dc393"
X-Rspamd-Server: rspam05
X-Stat-Signature: emjp9rtftt8dc5n5usuu6rishqm8to7f
X-Rspam-User: 
X-Rspamd-Queue-Id: 2512C1C0002
X-HE-Tag: 1760926989-848114
X-HE-Meta: U2FsdGVkX1/MrvRsICSDL5YHOULyj7MqDIAYEN+9Lx5JOqexx2vs4l8dMrqI2EcbzIkl8iUXf9rio8zo5CaWDdvAJEm7nAuvXGMlbQh9RXgzkt7P/ustuMu7A9+ufQECbi/x50LrbnzmcwyAy8xtWUzJB6E5DGQborSWz6IIvI1rAO0tOsLm3CJziqM7ujY5Wpez17pCfzAwJtydf4eYYwKekFuI6uIGwbMDwVNXxgOPcusO/6dajdaNe+d3IJ0cwxRxaghhgqoAN8bet5fMPHXit0MHKW5/Ch5vFsog25WJVvUYg59sVwvbRrfCuJcw1BKjnUbhAzk7QvF7YKCSa98ZQSXvSCIke8iV2j7IUV2qrQhs7l/fFo6+lmGoHWDVa0OyXm/mShfmTY/O2y1TJzCGAmK80yhXEW6ju6JgAY5eSNqFle+X/7iPnVB3kjQPSQ6N7ic5YRAd6CwABat3vGNbo/ccMGCw1pklm/BkIiTx1uThcbJX1jBErdHyMm40nB8/2xvlaKBccfBxdEorAzfr5wIluOEEIzL/uYYFLMyNr+l/0JM8cRNFdOX43EMB6BdYvYKrkOUfAusZKQduNMwWsoXk0KjhwthLlChZVNzC/MKbZRQQsPxzkWX4p3vPthxCJcZeGQEfSYTYrvkSk2pA7KIKQ8/VesHPRWxsWkpmhdxOsiSE9tZYM8TrjmwWIYLWX7CFOXUSRAMajlXWS37xDDimZgLf+BS5Z06OcQnLepZX6Y+oYxKcfq0Z0o0Z6bZsYFpr9xkM1lV3l/07XM+Azq/oTqtNmiK2PmmO0RceKNaiUMGCqWcvU2/8AGzKUEld+UxoxMQ1BKLLpAUgrZvNVAQlZAbflzgmFp2hy8eiUJ2KqCbTHb/sblGK0Qi0vrq6WqLb+5G5nFAvXjB8pbYtMpZun8AxpMrATHoLzaXFZEdEssUBEB4md0mNAUAnDRiX3j8JGD1kzWI37iq
 OjYlEwAq
 MxB/QRo7+O6oup5tD4Z7nlT6dCTGPYynBUOd8jealiBMTovH3PL7l2XHIGwwmK3KgwfSHeH2MnUDqbjBp419fRUB/t4C/+/j/EIm8dD8IGVjAQofK14IUv4XUe8MuN2yCqFlkgm8+TIYpmrOeXV9k4rv9MEudpHK24gVcBD9h3H7fzA1HlzifmN7QLvaep9fXVIewiD74E3VPMDqkX0YrOahardK6lwiyZTx4YKV9LGsWq9wFoRSlxe999O4m4ptxrCvTM8nib1z9G75F72xEW/P/3cRLD8ZEC3BarO7pnsE7u9mt1yr7Nph2fWLIQx8Mx1deMMHWppIAtEVJCqPuoSkvrSnG7kaIoaYnoxfHc2aOOSgOaUUk6LWslTN56xLqrgCbmWZdQwmr+FqQ6Fs5chzs9la1+L/stckgMxSXdm86GyVWHJb/YjdiOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009b0a2506418dc393
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

We have been investigating reclaim performance on mobile systems under
memory pressure and noticed that slab shrinking often accounts for a
significant portion of reclaim time in both direct reclaim and kswapd
contexts.
In some cases, shrink_slab() can take noticeably long when multiple
shrinkers are active, leading to latency spikes and slower overall reclaim
progress.

To address this, we are considering an approach to move slab shrinking
into a *dedicated kernel thread*. The intention is to decouple slab reclaim
from the direct reclaim and kswapd paths, allowing it to proceed
asynchronously under controlled conditions such as system idle periods or
specific reclaim triggers.

*Motivation:*

   -

   Reduce latency in direct reclaim paths by offloading potentially
   long-running slab reclaim work.
   -

   Improve overall reclaim efficiency by scheduling slab shrinking
   separately from page reclaim.
   -

   Allow more flexible control over when and how slab caches are aged
   or shrunk.

*Proposed direction:*

   -

   Introduce a kernel thread responsible for invoking
   shrink_slab() periodically or when signaled.
   -

   Keep the existing shrinker infrastructure intact but move the
   execution context outside of direct reclaim and kswapd.
   -

   Optionally trigger this thread based on system activity (e.g.
   idle detection, vmpressure events, or background reclaim).

We=E2=80=99d like to gather community feedback on:

   -

   Whether decoupling slab reclaim from kswapd and direct reclaim
   makes sense from a design and maintainability perspective.
   -

   Potential implications on fairness, concurrency, and memcg
   accounting.
   -

   Any related prior work or alternative ideas that have been discussed
   in this area.

Thanks for your time and consideration.

Best regards,
Yifan Ji

--0000000000009b0a2506418dc393
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p>Hi all,</p>
<p>We have been investigating reclaim performance on mobile systems under=
=C2=A0<br>memory pressure and noticed that slab shrinking often accounts fo=
r a=C2=A0<br>significant portion of reclaim time in both direct reclaim and=
 kswapd contexts.<br>
In some cases, <code>shrink_slab()</code> can take noticeably long when mul=
tiple<br>
shrinkers are active, leading to latency spikes and slower overall reclaim<=
br>
progress.</p><p>To address this, we are considering an approach to move sla=
b shrinking<br>
into a <strong>dedicated kernel thread</strong>. The intention is to decoup=
le slab reclaim=C2=A0<br>from the direct reclaim and kswapd paths, allowing=
 it to proceed=C2=A0<br>asynchronously under controlled conditions such as =
system idle periods or=C2=A0<br>specific reclaim triggers.</p><p><strong>Mo=
tivation:</strong></p>
<ul><li>
<p>Reduce latency in direct reclaim paths by offloading potentially<br>
long-running slab reclaim work.</p>
</li><li>
<p>Improve overall reclaim efficiency by scheduling slab shrinking<br>
separately from page reclaim.</p>
</li><li>
<p>Allow more flexible control over when and how slab caches are aged<br>
or shrunk.</p>
</li></ul>
<p><strong>Proposed direction:</strong></p>
<ul><li>
<p>Introduce a kernel thread responsible for invoking<br>
<code>shrink_slab()</code> periodically or when signaled.</p>
</li><li>
<p>Keep the existing shrinker infrastructure intact but move the<br>
execution context outside of direct reclaim and kswapd.</p>
</li><li>
<p>Optionally trigger this thread based on system activity (e.g.<br>
idle detection, vmpressure events, or background reclaim).</p>
</li></ul>
<p>We=E2=80=99d like to gather community feedback on:</p>
<ul><li>
<p>Whether decoupling slab reclaim from kswapd and direct reclaim<br>
makes sense from a design and maintainability perspective.</p>
</li><li>
<p>Potential implications on fairness, concurrency, and memcg<br>
accounting.</p>
</li><li>
<p>Any related prior work or alternative ideas that have been discussed<br>
in this area.</p>
</li></ul>
<p>Thanks for your time and consideration.</p>
<p>Best regards,<br>Yifan Ji</p>
</div>

--0000000000009b0a2506418dc393--

