Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9F3CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AD98E001B; Fri,  5 Sep 2025 15:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A808E000E; Fri,  5 Sep 2025 15:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9B88E001B; Fri,  5 Sep 2025 15:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF9B8E000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:45:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 569D6B7FB7
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:45:28 +0000 (UTC)
X-FDA: 83856225936.21.65AB867
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D6FF10000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:45:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KCj+cC0s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101526; a=rsa-sha256;
	cv=none;
	b=gnnjfyJtenEvnyjQpaEcZ3I8zpbpP/wrfAU5PQ2k3ove1bOFxx+AdvLZfxmmVy9HxEa52j
	BtS4e4xY309ZZ6DwNvtF82ZFNsAGMh8kKDlyw4W4oxUXVJPHtIM+NgVpAa7XMQWsIq4J99
	CtXqCCP4CEopdl/S5yvKcJIwrBjK410=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KCj+cC0s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zThdamV/JarxGl4cUxG9WAPKrvszQh4PaJJmLAyEpBA=;
	b=A7Jbmh3c9Z2rcxYlA3bPHmBnnkOgMRMRnM0MIXL6MiqThLUCb6Q4PQ3ojSE0zm4UEXOEVL
	17xNCZ4V7dRADsZuVJRqtxGF42g+914wzj5MovL70ixtIxLcl7i8KeSkSXjhnvT/mQ6u30
	7HFQLz1cVncPqeH0buuzGJIkwjiEeK4=
Date: Fri, 5 Sep 2025 19:45:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757101522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zThdamV/JarxGl4cUxG9WAPKrvszQh4PaJJmLAyEpBA=;
	b=KCj+cC0slLrUOaDbX8hyEpTfYNkUVkKGyyiVnykcTf0+8NoHtIqCnpp6frMPwhlYNBgaOg
	ogPI8nnitcTX749CWfm12X/PzGopqbDRJgjo6hOqRpBfSIVluMJIeJhdNw8TzxIqMtuQyE
	YMNJ+mNs5YVlXcD+FaspF0MxDF8Z8ew=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <4vpqew3bfs74kesmgd6kaafgm6nr6zbtt2t3hl2khkc6ds4zep@hllgy77hdumf>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7D6FF10000C
X-Stat-Signature: itz7cxd4qaqh9ysdiuaqcc999arid1o6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757101526-980909
X-HE-Meta: U2FsdGVkX1/7yOAmRIC+qHSflB5S1aFcD0zjPI66joBJaQvIrHvoJNSIW5niH+EUON/3wU9Kl73OmpJwvD5U/wjBOkjglsx2asIcFTPSBuBxsgPTDpF9LWjfaZybaI7imf7H+wouFnNTGxwZgX4ErC8zCFhvdG3h+93JRDrRlcj3fNeBZryjcs9PCx16sSCBUrUBkt1vWigqWKIyn6v07G4oIVdnQHoRsnMfZcgHAfbclePZY8ldKvPNge/C0Pb5//FAq3qetvFayoYO4YstfA7j+IZsp8JLVAmbsNTJd/1PxLat4+YXURJm3aPnxm4ThziP42wC98jn6BhEFu/j7PCKG5eDRqPO3PX2mUAB1w+TyNNSnPuPoq0UbrjEuDU+OxJZZ+KO4XhOe3xOHLNjLVrekI1BtHucSzNBoC0MudfAYihRHRft9gW+JWGJatY9P8Tl1ObWGw57yzupTXtHQ0jxukhVTZk9ftErH4+4DOcSFRxPR3+ZX/2vIClqdZmLKM5fyqXqr0Ay9DA41kVibK1wwr23JXCGSs/mKay6heUvOGNLfVTdTQ9q/Am1P++pA02nL66z3K1n46BIPelvO5FCZ/QK1WRYvDATSaU6pv+wC2JKlh8gxWeYjdd5H81nnAP47L1xorNc2iuBZC8JRgCJ+BclBkxEmMmYSxd7z3U+zDyw8xpks3xz1aZqyRHxtFy5l4xxsy3yk1KeYyXqCJVG7MVnuxnkVnyQLuBonTbBVbx6WA1VScLr/YlIuzB1qYWlIFfkH0lHE1+VEu5KVlYhpHN225S7tCNAxr9fYwiE3T5uxO5W6nHvpJWGT7ni8G3BrvgUo5hZbEnKPD1R7BwHlxlmPwz4oTmpNIfAEppmabGK7oECIXBCp4+kbrJcSWGZNP8SKa/e0ZuA3Z5qqRdew5WrT0EZqp0+hWTjSDVcKMHQgedIwRzVlDLf/Udx+I3JO9mHYL9vJfalNrF
 /ONQ53bZ
 Y3i3Z5bMx+zYdX+alpp/sSL4IJnqdy63nh2Oimk/pNPYMtlRNBQ+djidB5RXLYa3TeA05CYGQ+SjOM6XXhxHXNBaqdupF6TcINXcav4Vxp1PV/NfrhhYgRps+tpzeeK3cv3xduN+iaMLJsmLiVixGlJ7RYl+9sKH8HdlNSN0aL2io2s6XMBT3nzb0uu8hmQeiDYLHcKXwkuV02HrFlycnytpN2KTkfYTtBZpSGPua6TCL/XqvSrXVJF6P5/DVR13A95Q2UEfFHshXXPlPgJvZjqSgaRB3o7hEFi6p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 10:52:18AM -0700, Nhat Pham wrote:
> On Fri, Aug 29, 2025 at 9:22 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > zpool is an indirection layer for zswap to switch between multiple
> > allocator backends at runtime. Since 6.15, zsmalloc is the only
> > allocator left in-tree, so there is no point in keeping zpool around.
> >
> 
> Taking a step back, even if we do have needs for multiple allocators
> for different setups, having it runtime-selectable makes no sense.

Honestly I think we should take it a step further and make the
compressor selection only at build/boot time and completely get rid of
supporting having multiple pools. We'd create one pool at initilization
and that would be it.

I believe this will simplify things considerably, and I doubt changing
the compressor at runtime has a valid use case beyond experimentation.

WDYT?

