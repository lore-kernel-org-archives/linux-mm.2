Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D1BD38FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5B36B0095; Wed, 14 Jan 2026 12:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4901A6B0096; Wed, 14 Jan 2026 12:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C616B0098; Wed, 14 Jan 2026 12:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24DE96B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:07:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F024C1AE2EE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:07:40 +0000 (UTC)
X-FDA: 84331201080.26.6FECD9B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB4AE140011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:07:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="qbujS/ET";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768410459; a=rsa-sha256;
	cv=none;
	b=XI2C8YgBoJDFZj+5IR5C2PaN+V27azyV108n+9KJ4CIMkgEOeswhV5zJP/CrVT4AvTfLxm
	Ymi1MQKlK+KHNUa97iaZ1EwaScfKiVzmXde4D/uS1a7Gv80W1pVR1+OYVV58y5AaUL4fuV
	KTvlzQRNNk5JAnOOZugimsnSQjDOEGI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="qbujS/ET";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RFOwDQBVEpg9rej94TvEUAdCP3OvqZFUczDhVsj6Jg=;
	b=4V7TjTOm6rOlxMQlGCvkwQ6s2KSsyb7Ax8ipepP6HvqmSNMPxcJ7VT9EGxg8OwkgmKwpZh
	irba+BrpbvkIJvvP1U87K6/THHjATaj5JRvWRcobwCIdjeoyHBQpvkgxAEzyyLVrWg2MKF
	vZuoIfJ4V+Osvh8F10TGEYvHLInmnNg=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ed82ee9e57so167871cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768410458; x=1769015258; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8RFOwDQBVEpg9rej94TvEUAdCP3OvqZFUczDhVsj6Jg=;
        b=qbujS/ETtPT199I0kdf9oqJ+WXB6XZ5R6NIa2M5oxLI96ODbClIe4p2nP1Qw8vf8Vh
         Vw/euuw1fsLHFkkBVthUpoBnZbLX31jhS2dewqXO5Vmoy8ax32kWi7Gy4qe6XsLFArK2
         EMvtAAEDFx/6xU8qRpi9gfoDUJFlyQ5JgnHSeOpMjSJOVCQtiwrxWABP1xpOZLmazBaa
         V86SJ9QAB0sGo5jxrfkSCUdpgeR4YKsMt5odaEyLe+gYyiIxuRCzKyGrV3BfAOd/3tGo
         Pvfxhhst9PMaZ5Et5s8lUGgca1KYlhrpgfHDd4BNjj2o4vCkknWwPLBW+R/rdCWLBmfY
         Pf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410458; x=1769015258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RFOwDQBVEpg9rej94TvEUAdCP3OvqZFUczDhVsj6Jg=;
        b=w9hqqeQG5MU4CATRnAfvNd+j+vUg/OBuCSc7rzFx3NlNfoCvXCrgOn5Jxu9e682J3B
         0mOZ6J/i0LQABjO3ZayruXbd9ocRg+QzSPMpqs2J0t1j9iOi+/8vlu3Ucl6gpBHEj5xd
         KVxK6jDa6nmyamHfLOA4K7DG0ZlHuOsuq/UIgr16emFyHm/YGGUrghCA2k66Bbh4Iu8d
         tFzQBdsyCWQeaiOZnlQNYQkwceYOKNloSPn84n9FhZaSn/0ufP3Rpnzk3z+c8UoHcGva
         cJnLmWQiwiKMKcM391Waf25+x+z2/HRAGcRbjaz0Ti21d4YYTnvLMrSaUaFIk+HyyxSH
         tliA==
X-Gm-Message-State: AOJu0YxM04JWf2VuI8jzl3kqBBUBYFivgY9lUUqvZi9yxJ+AhwRfu1Fc
	9lpDfp6qaRXzZSVkDJmV7XtTF6XyTO4ULtDUV9UFCB1+I95QYbK6YLXVY00SUUs8hoI=
X-Gm-Gg: AY/fxX5d2tZ8THXMpG+JSgyGaNjGht/b5+AwvfKMaDu4eZryKTE0LvsnMPz0hg0Atj7
	u5X5d6cpvQTOgsPlKrCvPy6WjS0SKoAbSuMIlP38aHLQ0SwRPpVBus7F9Q1XMBbI/1wDn3KxmBy
	y6mPRMo9VU8R1Lkn2AEYgwynUJrQdHvpSEsMnOUc2jHwgEm61pzKNg67Ue8t52UVBV46DDjhXkR
	WwjzuAkgQ4OjFJY5cuagDY0TVY9tP2lpvEUw87HZeNyB4tmdufXnQBfVY4EKQnD2Ipqs78zj1Gm
	cPdrm4jLRetjRwtXFuiloHPBzSDXVP5yciLOibsgPNkLQZL5o0IUYktMuaPPUmGIfiLe0/1W+3P
	7u2C49oaKxGj5Q2VgEtGynxjmtSvk2eZyo33gR3cXhNy7LQ12hq+4PwyPlNLoSC74pqDcFmrJh7
	7qYa7jk0AP0ws27jl9cG7v2x3nR/BJXuxlfamUSIVKzt48klIaxzeaK2H7AspKk1bbru43Ww==
X-Received: by 2002:a05:622a:4203:b0:501:3c88:131 with SMTP id d75a77b69052e-501481f8ff5mr39550561cf.22.1768410456999;
        Wed, 14 Jan 2026 09:07:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148eccd7fsm17076341cf.25.2026.01.14.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:07:36 -0800 (PST)
Date: Wed, 14 Jan 2026 12:07:03 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] dax/kmem: add memory notifier to block external
 state changes
Message-ID: <aWfNN-hy64bGw6p2@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-9-gourry@gourry.net>
 <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB4AE140011
X-Stat-Signature: 6t1q7r3u1q8zqmj7h3oboo4bokfbq3c7
X-Rspam-User: 
X-HE-Tag: 1768410458-215710
X-HE-Meta: U2FsdGVkX1+Z+LkqGNFgGAUGLAvYl6Ar0swR/YUwJI7DionHBa1LkOM71PyAahBVCWTcC9qwSHKperEjqLgWr+ljrRIXBZ0ptyVjFMXD9w3I4R2av5flophwkWkHGdIcI7v+yf896DsueeOCFnQbl1O+5tbaW6yCgol1nz+feNV4F7qmFhg/qhRbzx0KZ2g1UMWWfHiQ7IRgtPz9k4YvW8QXcdwZNEC3hqR32xQCoZpoWsE7XEeKcmRFcsfjYmB5bNfKEMm+QOex2Joqs/DxX9HNnKESVB9RrU60I2f2CIrJoKJhVy/5izClsP5jBHMJ4/6EBCZm0zoCaaIcSVbmE1v2Kw3VatahoEpQEH2HxN8xRf4O1WYLt/2ZM61igZFxC9s0Q/Pd60yZ1KjCYwHxkslUEmAOhSQ92h3AFu8BTEKNwnYfgv2HtpC3N2UXG6kI6hGDHnNzYBw42HDEKcHxXewICIMZo5cKvHlOOHNRFw6lJ4bqju4z8i+dJPuDd/i4SMi2MAMpMtpUJWxT4Po5uo/4tSVWsByMYvkXs9TP4TXc4TYFoQLWwtJSFfbnFF4Ohu2Zuhxf8oGeiSo4mSahj/7iX0r5iO2sjHKHLz0GbMZbtMoKXa1OyOdIuoyp+pyXAPoPD9XCPVUjVl3jOFBcQoTJNPJMmB6s4Ck5F7gwlT/G2vciz6S897NmNf+rHMKA6Z3TAevOIWAh/we04QMKB/NtL3rSM6t2CwRBCOYAo0BvWtPbl2/tHaTHWdRjkn/fM82GswyRalvLiUFXmd/u+Vj53Ilp2U5LI1y/0jLbKUQKVWoWlNovH4aKaOCzT93igarc6MA7pBJ88s+iOnN4Z4q3tAA/sQvfpV+HplrYpUFWYwOcFYw3P+i/0P4EXoAqi2hDlHEFFzJslBGWq2ZW3OmxGw1ElUf/2NMlRVkSsi8Gp6ExqK7IEfcPWjDu+bCI/YP2oFLtnE32XaSi/7T
 Iw8awCT7
 3Q3qt0mGX4SCb+94ZEhAgsk12LS/zRSP7/zshSdXCS983XcxPVy8vDoi0Sb88h2JNGU0gE/jnbmNtX1MTljndmEtVOE1GM3QWmJzMqwerOZi4x3FRbYXXAM4pCFAlMU6etetKFPudOXtn6ztUGXF7UlDCF414R+zhmg3OLW+WRPXd7Ywgp/ZnDMBFrd667VHYQzLsELMResKLNKIjGhHrW2DJRyx6ogckR+OryDVGllbqBUu/Rdpw71LqmpOHpxdADS6xnQcpsmo1sGvMprEdxXaVcYZPjuBPdFa1FOvdwhelCHua0zSCEBZd5ZYTLBrZbmiJdIqhGKWbAPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 10:44:08AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:52, Gregory Price wrote:
> > Add a memory notifier to prevent external operations from changing the
> > online/offline state of memory blocks managed by dax_kmem. This ensures
> > state changes only occur through the driver's hotplug sysfs interface,
> > providing consistent state tracking and preventing races with auto-online
> > policies or direct memory block sysfs manipulation.
> > 
> > The notifier uses a transition protocol with memory barriers:
> >    - Before initiating a state change, set target_state then in_transition
> >    - Use a barrier to ensure target_state is visible before in_transition
> >    - The notifier checks in_transition, then uses barrier before reading
> >      target_state to ensure proper ordering on weakly-ordered architectures
> > 
> > The notifier callback:
> >    - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
> >    - Returns NOTIFY_BAD if in_transition is false (block external ops)
> >    - Validates the memory event matches target_state (MEM_GOING_ONLINE
> >      for online operations, MEM_GOING_OFFLINE for offline/unplug)
> >    - Returns NOTIFY_OK only for driver-initiated operations with matching
> >      target_state
> > 
> > This prevents scenarios where:
> >    - Auto-online policies re-online memory the driver is trying to offline
> 
> Is this still a problem when using offline_and_remove_memory() ?
>

I suppose this commit more than the others is actually an RFC.

DAX might not want it.  Other drivers might.  Now at least I have the
code to do that.

> >    - Users manually change memory state via /sys/devices/system/memory/
> 
> I don't see why we would want to care about that :)
> 

Absolutely critical if we have something like a CXL DCD region that
wants to try to protect hot-unplug.  But that is probably an argument
for implementing this in a cxl region driver than DAX.

> >    - Other kernel subsystems interfere with driver-managed memory state
> What do you have in mind?
> 
> Not sure if this functionality here is really needed when the driver does
> add+online and offline+remove in a single operation. So please elaborate :)

See above - so yeah I'll probably drop this and come back to it in the
sysram_region driver in CXL.

~Gregory

