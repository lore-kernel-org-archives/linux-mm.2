Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E7FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1478E000E; Tue, 11 Nov 2025 11:46:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478AD8E0002; Tue, 11 Nov 2025 11:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B60A8E000E; Tue, 11 Nov 2025 11:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 260C68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:46:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7A161DBCFC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:45:59 +0000 (UTC)
X-FDA: 84098903238.28.BAE64A5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 345971C0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:45:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F9eTogNq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762879558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwOueIDR7iQLq0yktgbr0XMz1VzOnqj2R/QpQ9bY1ZU=;
	b=DgAlnTySTNljubjt+geZW47usRgNd08b1NK5BWRmPhyCfAT5jR8Vkb+JrXVuj5ycS2+0FF
	pajG7NgdNUmd5J5WDbRm+LQuoR6mvRmwRzjTvCwj6N1tEoz0Ah/5mGKkO+V4m1udjned+J
	LjYfJH/ySaiNDhQxDX5VfxcEV4VWaII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762879558; a=rsa-sha256;
	cv=none;
	b=tCmut0I7ylN9l43GHm7XYAv/AoLedjgVPhhCgs8S0qU/KvN/idTckE9H83YBhJnUxyepyq
	dB6L+VJd0ZErw3PXVAkdiFW4otvmJ5ycGPmRjbZ1+eSNFOoD6PHmShcNY59GtHsd/71MsL
	IcSa+Sb3CgfxCgBkyG7tAnEPiAiyWLo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F9eTogNq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 11 Nov 2025 08:45:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762879554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QwOueIDR7iQLq0yktgbr0XMz1VzOnqj2R/QpQ9bY1ZU=;
	b=F9eTogNqMIrPlvSuExmQ7EbcOmA1oJ69tHiAS8UUnOhVS46t4pAhkZk06/DWTS/NIUIpNb
	+/DQ/LxknjCDPtzBy6dEgLfsIALH8ubWqhQMCDNWkTDOMj881YgTFWO1j7vJ0gKl+Up/1a
	D1/ypSEWvsjRVuIdcvJ94kIBOg8oezU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <xjwmyqdjynpeuqtgxiz3igynjl4ywopdc33lteidgmp5yez2ed@pbdfsekytezn>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <0618ea79-fed3-4d4d-9573-2be49de728cf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0618ea79-fed3-4d4d-9573-2be49de728cf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fkiwuxadai3ma4hjjkgsj9rsgtzyexbk
X-Rspam-User: 
X-Rspamd-Queue-Id: 345971C0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762879557-339225
X-HE-Meta: U2FsdGVkX1+I8NAHAiX04AGF4qMu/oxMwd53POD7cnva7f3PoFUQnuOD1ZcS9qeXOtbogdzWomJE6KFkxZ3AX4y1+n7sLTuCbICdMKlEWXWIsWgLHjEjUJJ7rRegyKDHnOWybOomoyARHZdGxWtERjb+8jk7oYtefi07170/EeEEHidFOdDLgg5Uj7+dJ+PPt7vOIPg34YCy7avRRhg8sTh1uZc4B91uGqvOnv9FUwO9PHOvHe8ExDmliXu53UAYjcAi/hFPIp1s21N5mo2fW8TesikJBrnMSK2wQNE/i9athAmQPA8tlzXCWNJpnLLmyjlA7x+S0cY1cnUUDNfZzv6V7Sbs1hb6INRunRNDIgjefHk3n4rEEBJU3utsakm5aefFzHMhF876EOgqXzW7EL2dyUknevYlU9W+6ZjPdQgqbmznzJMaXkYNO8bUO+RJpvYryXFUfcSRdFok7A1AHzF3dj6Rh8jCOnCvXiam3fb8/XCiYQdtaJsSqnWnh2jgJ6B0lKZjyQFqhFlkCiYNW3WRIHhC39HO8UC30DFh69iEp2EQNNQLrCEf3LitX2jO2DRvNvSv55OZs0O4Phhs+upVQpMZheKjDKkw2AuBAP00WdXpP6SrfW3GS+pOEqCowCcfX92yJEkb/yDqWdlZMLngjxLFjalGGfCBfLBfTjV4QHqgsnBgimTpHm6a4aiVQkFKBXIjQn/e9uLFzt4LjKYLwUStGm0oRkI8FFlsWLTnpjSr6+Y4nXy36eIYNcd4/1189Haw8TL8XD9ohNAoLShxBAy5Avw2YkHKxcWvbKovv8u5zico3W3igJyM6MGZNTFj3cJKOzH0cSDo8dH3FQ8xR6jNCcWMaQYiYxv8/HRjEWdPbapKpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 04:36:14PM +0800, Qi Zheng wrote:
> Hi Shakeel,
> 
> On 11/11/25 7:20 AM, Shakeel Butt wrote:
> > The memcg stats are safe against irq (and nmi) context and thus does not
> > require disabling irqs. However for some stats which are also maintained
> > at node level, it is using irq unsafe interface and thus requiring the
> > users to still disables irqs or use interfaces which explicitly disables
> > irqs. Let's move memcg code to use irq safe node level stats function
> > which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> > (all major ones), so there will not be any performance penalty for its
> > usage.
> 
> Generally, places that call __mod_lruvec_state() also call
> __mod_zone_page_state(), and it also has the corresponding optimized
> version (mod_zone_page_state()). It seems necessary to clean that up
> as well, so that those disabling-IRQs that are only used for updating
> vmstat can be removed.

I agree, please take a stab at that.

