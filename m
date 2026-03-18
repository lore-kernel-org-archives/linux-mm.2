Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62E910854DA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5986B0149; Wed, 18 Mar 2026 05:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376C96B014B; Wed, 18 Mar 2026 05:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265316B014C; Wed, 18 Mar 2026 05:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10BDA6B0149
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:21:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B208B58F56
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:21:04 +0000 (UTC)
X-FDA: 84558639648.17.A313A95
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0DF4A000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:21:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RUx9E2VT;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773825662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCsWM+qtYn9cziDx86CoZ1L1lXbooAdYKLink0SGuB4=;
	b=cjtoo8RmQtWXOzEFOd8uggjmueTjRGePMtSUHuQpYR+TRqAnO3GkxbCo9eFsMxepwDSwkS
	E9myRqrNPDyKQvnkdUY/Sw1evwp2Bl6cap4al2hstLYDbSDhE7q1C+0Z6UvBb4e9/5Wmaw
	5V5jKcy28wPH+QS/Utk8FyZLfygolHc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RUx9E2VT;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773825662; a=rsa-sha256;
	cv=none;
	b=sYba/u0npTCwN5/G8wEH4G0brRkupZ6lm/OoA+/80n8UH47IqG7TsHUQwHOhJxB4Dr+xUv
	gN74mIX8T7Yp38aIf0Zxhyaf1z+jfi4GWyMzpZzvYVbfMdkDwSf+NcwnOrhKreiydCL3TY
	Ijl7yIzoYegZ5Z49LXsauVpZy/+CSFU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso74749845e9.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773825661; x=1774430461; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCsWM+qtYn9cziDx86CoZ1L1lXbooAdYKLink0SGuB4=;
        b=RUx9E2VTWjyXx/Pc2yN9ZnQidIGsXPRVyNU6gYpj8XORDhuVY0B82KDiiW8uM7cHSz
         CiqhA5uw/KKtqntnqyM9CcRNKb+MoxwA65FrRTDI7pyJewBUgUT29lWqzUqKqsz09Z/u
         35OHE5+h8Z3F/6r6NdXELe5nxfpeH9FPdczrSj4SpH7NgXvZstOiqzK9Y95f5N7HOTpX
         iT56lYwbKWHA2svApt7V90nfxgFZeBy/lgEqpODuLOthaolNKM4ltbmrJc8dG+SGH7AT
         lbuyMB3NiO67H07glmrReSXg/rGC/+jh44UEpRJ3jxV2aZAlL9+7LOwRP45Zf7xdTvVq
         6lCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773825661; x=1774430461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCsWM+qtYn9cziDx86CoZ1L1lXbooAdYKLink0SGuB4=;
        b=hi5sWgx4Uv0NhBkS5761iLdW+HYaqTEejIqnJAQDvAG29wsj/EHM9PgWvNDUcsEVRc
         dD5ewe79tYp45iybGJ+RzBMU+DYMMLdzk+Ml4BpM825ucM0ikInBWXRm5YfZ/RrbNCzH
         FOak2e+8zcBbRqzMJvOpoVswq/588c3dcbi2n3MhNQTv0DtVC9ZDhL032LXwyHv7OlTW
         /zb2JmjwZ839All7+bkPQYO+ERWQ9JI3CVaPJiEZu2mhNjLzygtyggl5vd22lsD8tC7h
         1qWAYvjlSvCob/w4fxSYYsp1fAgqg/dsfBsdq5OR3pHWWxM6cRNTdiJ4j4mL9gEjzV9T
         qNvA==
X-Forwarded-Encrypted: i=1; AJvYcCWFUwlvNLVemtMC6xD+rxvd6IZO97mJf9tTIiGsw4KQpKj2FWhkcFamT0qWyzNyA8STEAjJFBN0qQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/SR8kIH4yv411rBbT3BR0Nehdfp8MYLwFY6Cvc3W0HD3A3TQk
	8jULgDkhdvzP2KaNT6kmqjGz/32G0PqVgOWAGenVn8alu69GS5LeSrne0+541K2QQwg=
X-Gm-Gg: ATEYQzw0JlBSro8RaDpASQaHcySClXZBomXTY7+Hb/6XsEmIAxssmlto9T7MdiLbzD2
	u5uurSeg99nQpEHhe8d3X/+2bSkbq66bQ4/frFJIBEcd/Pvp4fiRplFopj9O4wpc5eMsB07rsRR
	fJqBvV3roZ42P/S9O7LZ1r3q8/4q8whS/mDitCOp2i12zbrJLJwwtYyZ2fQQn3m3ABiUFmOFdAZ
	LJ2pm1hB6llgNLkt1A/I9i6M+W5ArsZsYq1WIJmshRE9aqo96ogWtqMNFIiZHDVrVS4rrBFPAYz
	9vLh7U2gBN31gjR4/VwkfNq0aU5/w71coKfzO6lCQAoY0ueTxUJA5J+3CSc4ktY0rcyla+gitEy
	xFaNQx7TjE+faU63/QZg9VN2SSqy8Ur7uTFEWh3VtiHR5fcDXtVPQ41kr8APrKDiFPiCxNuaDrw
	2VPej5Wz/Vrm6ukFJyQ2lEBy+LxxFiVEWvqMru
X-Received: by 2002:a05:600c:a20e:b0:482:f564:d613 with SMTP id 5b1f17b1804b1-486f443d48cmr26793045e9.15.1773825661196;
        Wed, 18 Mar 2026 02:21:01 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4623a26sm16508605e9.7.2026.03.18.02.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 02:21:00 -0700 (PDT)
Date: Wed, 18 Mar 2026 10:20:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <abpue_k_9mjQAP6X@tiehlicka>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
 <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0DF4A000E
X-Stat-Signature: mj45cupaibw5pgzw3r8pidbn9y5jxtuz
X-Rspam-User: 
X-HE-Tag: 1773825662-706053
X-HE-Meta: U2FsdGVkX189ouUzAdNzx8dzD9rqxEQ/Gcynw3+gHlm4dzXR9lEaigKbzrRHt0F4H4M107+7LIzuCIApbx5UN71u2JnpRBdsfnNVgoA6oS6vZmV1UYTeInNFOv0ZYKoYU6WJRDv1uIg1FQY5mW411V3t1K0bibTCA3kKSdauYk+9g4MerJ9c8S0KAekLdb5Qdq8p0cuJu+pYerDWK4FR9+hfnRu6BBkchUK7IG+5vxwuV4oEF8syawXrnny5vUhm4FEX5Ezf3S84kVOqiAXCAL8Jl2367c2aoHYHwPngtrY9VfbemrcPxRf9SbSCriAaWSS7iqB1BeD11/Cx2PRMdELheAsAp/NyFdO1V41BwlJx9SgGCUGlshwZQ0AQUv0ZZgHmX6ygWAlQAYqN/+L7IjatIJlJZJANehVOZV7yt7QliVQzMI8IG8ELfVXZizOLNIdfSpDWVrbZfPQLFtSmn/14CaCNMGtYCNh5FYpdQ0JgRXGTf1BbfTMRhBOfVcrhgFtHp1xMCt4w3c9ccWndvxp41kFw/7exR0338T2GsWeQyIryhxS7W1gHSOz9dHhPasBqYDx1bYb/CqqE1azmbuKBNWSnBknoR+tlrHC9X3Nn84EMIGSmMhQYh/AGHphzj8PWqIg5d93AeQfIJvA7o3IS45yvWJEHAKu/FzVmudwLSF1nPY4U4BtBV6nEnMgOT6URTKk3Smw+kI4MbcnsJE5EPXV8jAJADEzvSPUioEMwDBkLqdpDEE8c/1KOrf1Nj1BAoNj1l7A9UhxSvivH3kM9NfuRrhNRcw3SfON8wlK2jJkWhaNOGC+zElXrX4UiMXpSMZxDFApnlux7VCacnON5zf1ss8x5UidEcPSqPNncPcXwyttny1pvFNW0Cot+44TcGJsyc8jl0fvigel9vaLN8FeAr625G1Rdme7+q7xxKRlWd/6bzOIaYQU7O/X/4C0CciPZ/+w/a9O0EO3
 Rboy23iC
 tSGwpcMzn8oXgI9EODOMpfvc3vOh+5NnLZ54hCkLRboYN3Tev11khUOQ6uvy5kztsEipC1P8cQhngqoHlGZ/37jdpg38Qdnw0R5CCwpkzPumxjsgJkvw9jHw1v6c5zAl54vpMohNJojtM1xRV1gwuZZ7UDNaIxAMDQA1izahhgIlGkW9uYdSp607BzGvYnTFyngTBIIOLnbPjRAXm5lOjogB0RJioY4AOxfHxYavbP0AnCWfQYR59ft17aFpcP1oL0YSuKRRV506iXY5HwkImtxbiYzH8+zeDKNUxZpKdqn7f0YDUp/QhEwdgxtcK4Xn6WY7YDMEHr44AMD25hLQydYaD5z1RVXM5LX4B6ABAJH7lyhJ37am6el01PaLZ7zixMKkQhUUKR2ObokviR/FYqCNwel1yiMDCE70CkzPe/yoXPJPsjsfik0V7Br64ynN7Ua2GsGCL9hJv/rN6z12Hqn1Fi1hgbGNTEI3/QZ96Gmk4LZgrqkcx5xIZ8vXdydpMsHeAuLBhbSExskA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 12:04:10, Daniil Tatianin wrote:
> 
> On 3/18/26 11:25 AM, Michal Hocko wrote:
> > On Tue 17-03-26 23:17:28, Daniil Tatianin wrote:
> > > On 3/17/26 10:17 PM, Andrew Morton wrote:
> > > > On Tue, 17 Mar 2026 13:00:58 +0300 Daniil Tatianin<d-tatianin@yandex-team.ru> wrote:
> > > > 
> > > > > The current global sysctl compact_unevictable_allowed is too coarse.
> > > > > In environments with mixed workloads, we may want to protect specific
> > > > > important cgroups from compaction to ensure their stability and
> > > > > responsiveness, while allowing compaction for others.
> > > > > 
> > > > > This patch introduces a per-memcg compact_unevictable_allowed attribute.
> > > > > This allows granular control over whether unevictable pages in a specific
> > > > > cgroup can be compacted. The global sysctl still takes precedence if set
> > > > > to disallow compaction, but this new setting allows opting out specific
> > > > > cgroups.
> > > > > 
> > > > > This also adds a new ISOLATE_UNEVICTABLE_CHECK_MEMCG flag to
> > > > > isolate_migratepages_block to preserve the old behavior for the
> > > > > ISOLATE_UNEVICTABLE flag unconditionally used by
> > > > > isolage_migratepages_range.
> > > > AI review asked questions:
> > > > 	https://sashiko.dev/#/patchset/20260317100058.2316997-1-d-tatianin@yandex-team.ru
> > > > Should this dynamically walk up the ancestor chain during evaluation to
> > > > ensure it returns false if any ancestor has disallowed compaction?
> > > I think ultimately it's up to cgroup maintainers whether the code should do
> > > that, but as far as I understand the whole point of cgroups is that a child
> > > can override the settings of its parent. Moreover, this property doesn't
> > > have CFTYPE_NS_DELEGATABLE set, so a child cgroup cannot just toggle it at
> > > will.
> > In general any attributes should have proper hieararchical semantic. I
> > am not sure what that should be in this case. What is a desire in a
> > child cgroup can become fragmentation pressure to others.
> > 
> > I think it would be really important to explain more thoroughly about
> > those usecases of mixed workloads.
> I think there are many examples of a system where one process is more
> important than
> others. For example, any sort of healthcheck or even the ssh daemon: these
> may become
> unresponsive during heavy compaction due to thousands of TLB invalidate IPIs
> or page faulting
> on pages that are being compacted. Another example is a VM that is
> responsible for routing
> traffic of all other VMs or even the entire cluster, you really want to
> prioritize its responsiveness, while
> still allowing compaction of memory for the rest of the system, for less
> important VMs or services etc.

Shouldn't those use mlock?

> > Is the memcg even a suitable level of
> > abstraction for this tunable?
> 
> In my opinion it is, since it is relatively common to put all related tasks
> into one cgroup with preset memory limits etc.
> 
> > Doesn't this belong to tasks if anything?
> 
> I think it would be very difficult to implement as a per-task attribute
> properly since compaction works at the folio
> level. While folios have a pointer to the memcg that owns them, they may be
> mapped by multiple process in case
> of shared memory. We would have to find all the address spaces mapping this
> folio, and then check the property on
> every one of them, which may be set to different values. This may be
> problematic performance-wise to do for
> every physical page, and it also introduces unclear semantics if different
> address spaces mapping the same page
> have different opinions.

Yes, it would need to be something like an implicit mlock. I haven't
really indicated that would be a _simpler_ solution. But as this has
obvious userspace API implications the much more important question is
what is a futureproof solution. Also we need to get an answer whether
this is really needed or too niche to cast an interface maintained for
ever for.
-- 
Michal Hocko
SUSE Labs

