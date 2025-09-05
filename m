Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6206CCA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9E58E000E; Fri,  5 Sep 2025 15:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63E38E0006; Fri,  5 Sep 2025 15:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952958E000E; Fri,  5 Sep 2025 15:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82E128E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:57:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 387CA57724
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:57:45 +0000 (UTC)
X-FDA: 83856256890.15.5303D04
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 50C9A4000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:57:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k5QdP2dm;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757102263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C88HDehPWivD9EUSvKkxXMxjXSeia8HK43L6jBuUCCM=;
	b=Pk6gRCOriuJpKbVxXIHp/B5pgUuMnR/yOfrYwmvqPMkcOBtr4K67cwl6ECHo0aW3lFkj31
	GHLz86tNN2HajBDn2miZCcQl2OkMcTYogn87wMAMpRTE+ueG9d+cyBh4Y6rXotmneMRtq4
	h8fACqv94UXaJv+0BW5I018u6L+3H5c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k5QdP2dm;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757102263; a=rsa-sha256;
	cv=none;
	b=Evpfz3Lct2LJ/EdWOV/BzEthkr1SwQuLv3OHRWBafqDlL60ygAv/1DeFZYowBwEHlOrI/j
	G9RhtzrWB7ku/zQyZBeafFVhjFCsr7MlGaiexjLaFoxoBQ+tsscxHTLXVKKh/IL5fsoc2j
	9iFTLun0A8F/A2yNX3Vq0GkXi5e4oyY=
Date: Fri, 5 Sep 2025 19:57:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757102261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C88HDehPWivD9EUSvKkxXMxjXSeia8HK43L6jBuUCCM=;
	b=k5QdP2dmq/1Ek9qMCh+byWehTbaBVFeSYl4SdH/jqY9gj46HWhi3IIEOEhOJyeA+k70JII
	1ExSzHoZnEmaDRNMgT0mcb1eD0KlvPvVIMKN8hYqiRT8ciWSv5fjiyMpzlWV5GKdrldXKV
	EIZ5cJon/uPV4AqhDtLsZr4PD+NgryQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6o6kqwwm661rg614696ok5k438t9ch6n
X-Rspam-User: 
X-Rspamd-Queue-Id: 50C9A4000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1757102263-290796
X-HE-Meta: U2FsdGVkX18vb7+0A0ZgU9M4WX9h1q5mFPe7JaR28c98pJSxc/Jscs93vFQp4Q6MUNR9DdNTMMuPqVrM1Qx0z36NB+lPUZwe/XKamjZAFx/Xyle15VA4i2zc2uPbNAwrgAvoML79KJAkDY8IhPKkgbSBv8kIDfSx10vJx8uY7X4g1AhL1Lnz0rk8w4IiaJvjSWSSx5V/eK/LbZxhCm+w/lZ4LmRoZ0UGpf0bTvydpP4/yjoRAvjPJHHO6+bP138VsnLqDCdTJKcYQgREPAs94yKIxlpkPLiAeJty9iFTK35YwNi3e8GmsGO+KvgZuU0JLGi0dOxlmQpzgLWJHTwGQKE6zQHwRfxm+KEDjwV9BxcPymMLuhz3d/cNbPuXHkfT61Cs1ck01k9S8QWdWur87W6FCcWzHoylCTxisoX2ucy3sg1AzGLfjzu1Ytay2jeL+aiVY2vbUKM5HvxlxNKTTgOqq+/y/xULAtdp2mIkv0JOBxYj0D4B2wrUgZrsjndnppDDXBBBG3TwitvmY66hKzNmZFVKeYh528PxUuB4oXKMK+w2eSARNFR7tYpITOOqQyOiKv/sWCKmvmzeUeDoVJ5K0Ql+kAKCBxA+0MmURz5exhPEp/lf5DjC9OvTw5aesLFqcFUqGAoanOqYLfOY/y0xFrXBUnaXtJkhBX9FwFWcgjAPWAFy01VAuU/d0N0ywy3BFPPaSYWd0Z3vxVEdgzqZHFxCL7xoz3w1+WQS2TDeZi5g4Ghhvx6qL5nEBecZr7F85LHGJrUytiye0blRuM5GTNnLc3TU7nLGvWvm/vo9svXjeiBOhSOMI+5iVnjXFFFP6syWzwJFMqkJFOyPvIn41Lg+jMkgshP3bblDNokQnxCYzd3XI0pJbKmiBZJPWnvd+ZvfI6qeYPAHLjvNTG2A1XiNopWf/ZmrXyueMJ9M6GgcAVnfKaLYqgJM9WebaPRnfusAEcxJCK0H/QH
 a7+krZ8w
 8z5G+K/c8PpMrMjXghJu93WP7bmzY4DX63ehapv1PxJHlAVRNSKBOFQ5dn2ui5F9zikKN2tt/yf672OJPk2DGn5/5QFvoyxS50NcLLAXtQ/G6HrE7ZmWgMroGDMxyQxtrc16MthVFbcKWx6B8ZLQ+oFZl9f+izzHG5SxWMJjUpEc7Dmie3vM7CzSRK2cVKeuFn/NUhivdQVsg+g6nMES5vtM4S0Ul2aMoIJEShJBnEVeZe3hVtTTUgHpjjp/Ws1eN4Ks225aDZdPtrVTLTWssWLS1+9xdLQkeg4Xz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 04:11:04PM +0200, Vitaly Wool wrote:
> 
> 
> On 9/4/25 12:13, Vlastimil Babka wrote:
> > On 9/4/25 11:33, Vitaly Wool wrote:
> > > > With zswap using zsmalloc directly, there are no more in-tree users of
> > > > this code. Remove it.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > 
> > > Per the previous discussions, this gets a *NACK* from my side. There is
> > > hardly anything _technical_ preventing new in-tree users of zpool API.
> > > zpool API is neutral and well-defined, I don’t see *any* good reason for
> > > it to be phased out.
> > 
> > AFAIK it's a policy that unused code should be removed ASAP. And that's the
> > case for zpool after Patch 1, no? It could be different if another user was
> > about to be merged (to avoid unnecessary churn), but that doesn't seem the
> > case for zblock?
> 
> For the C implementation of zblock, no. But there's another implementation
> which is in Rust and it's nearing the submission.
> 
> > My concern would be if the removal breaks any existing installations relying
> > on zswap. Presumably not as a make oldconfig will produce a config where
> > nothing important is missing, and existing boot options such as
> > "zswap.zpool=" or attempts to write to in the init scripts to
> > "/sys/module/zswap/parameters/zpool" will cause some errors/noise but not
> > prevent booting correctly?
> 
> I don't expect heavy breakage but misconfigurations will definitely occur.
> > I mean if we were paranoid and anticipated somebody would break their
> > booting if writing to /sys/module/zswap/parameters/zpool failed, we could
> > keep the file (for a while) and just produce a warning in dmesg that it's
> > deprecated and does nothing?
> > 
> >  From Patch 1:
> > 
> > > Note that this does not preclude future improvements and experiments
> > > with different allocation strategies. Should it become necessary, it's
> > > possible to provide an alternate implementation for the zsmalloc API,
> > > selectable at compile time. However, zsmalloc is also rather mature
> > > and feature rich, with years of widespread production exposure; it's
> > > encouraged to make incremental improvements rather than fork it.
> > 
> > With my history of maintaining the slab allocators I can only support this
> > approach.
> 
> There was the time when slab was the best option and it was more mature than
> slub, which is now the best and only option. Thus, the "maturity" point is
> indeed valid but not being backed by anything else it doesn't weigh too
> much. Besides, zsmalloc's production exposure from all I know is limited to
> the 4K page case, and zsmalloc is truly struggling when the system is
> configured for 16K pages.

I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
confirm.

