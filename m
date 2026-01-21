Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3315D2629F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225036B0005; Tue, 20 Jan 2026 20:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D21E6B0088; Tue, 20 Jan 2026 20:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7F06B0089; Tue, 20 Jan 2026 20:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 008E86B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:37:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C1BBC26CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:37:43 +0000 (UTC)
X-FDA: 84354259206.24.2BD1D2A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90E77120004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:37:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ytdh5A20;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768959461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wB0ar56msHKqjRa1uqeS/ISsRg6rFYMOnMYNt5s8M/s=;
	b=cmV7ePWuxot9YRkb4MP2RIXhvGVv54HomgNtj5faEmIErkB5aMRvjnvLYKf1TXxZ+F12jZ
	EN2+XPV5ImZ+hQLE+rMTS8phjZDIubGDBwmRZxJ3p+jwNvV+Vk8pZuoeshLZbQgoJaMEZi
	yUjKoSqKYF5RgDKUEv2JtU4LkhWjiTI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ytdh5A20;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768959461; a=rsa-sha256;
	cv=none;
	b=EKmp9Xcjc7PsWUHJEpZS5H5u5oMemRU+KFJUGIcRSV2XxN8XRb3qktjtR0ZSuo0i1NnP2g
	RsfWGvJEHcjbQkOVGz+kx6Du2fg8Cw6SvyuafjY0p44Fb/Y8ciFNcMYs3IuUGTn6Y1qLuo
	fXahJlJUw+2GzzcKxzdcvhCYuj6Smyg=
Date: Wed, 21 Jan 2026 01:37:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768959459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wB0ar56msHKqjRa1uqeS/ISsRg6rFYMOnMYNt5s8M/s=;
	b=Ytdh5A20WLTLDXxxa3bZ/KzXkP7hMT6zyXmxx5RDMOPHjvb3bD3tvOFrbIyvxXw25auZQ5
	mYGZyeaN3v9tQJH8hJCNYsol07kxSxKJVwCFCK7KjiuehNIg6EI3rUFzP3HCKZPGywUyhU
	MgTaXmaVJg0ccH5I9iwwNrpjQUD5w1I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCHv2] zsmalloc: make common caches global
Message-ID: <3womulcsz4f4ym6cxtzdtv5sa4ijxyqwrbllmqnhdpb2pfrypz@7wcenus2wq3o>
References: <20260117025406.799428-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117025406.799428-1-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 90E77120004
X-Stat-Signature: 8fe487ru8d6y5k8ibby86gtuzrj1tyuq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768959461-99871
X-HE-Meta: U2FsdGVkX1/PzS29GcKzhWTXIDFt9DYk2oX+LuxgvFSV2wTFg/ZptE/qpQfXfqBE3gcBe36wjmoLskGw+GIGEwMT5zjr8KgCYz83Bd9qQa6jngrShD6Po5ZCYGIot3z+Q7tXcY20MQKialUNopOYB1jYvtu1dxMXfL3UJ3PitNl+9g1TflsbdDs3fmu3Lp2mHKMSovCFrJqSNQD9PwRxqePbmAH7Ddtb5MSFdNQ33GejQ5mH0CkEF+b2Z7iJZ5Hh5ILOAnYaoU7TL0ZsQZyFzVqGVYz0BAFy0MPcFml3sdDVqneg14H0yeNuMNdF4TbOza5ZubRZN1Npr21dwnBVDXWdbWfTncqekj3u9kn9r3AHFblQKn7Q65JcE7ua4Qa9Iqs6DQg1kTFy4/S27ffoLUbwniy2Yw9kZYVP6/SrwazD4PyPl53aK6casd6GEssRKbx8XKjYlZwmAq45YzSJH5+neHu6z3IULgD4lzhLcb2NKw8Z55tWElLtUy79twiU8xPyvPTSrbOh7MNgaY9BmmZo4VzoTCUrmOLpsDfaeRPjmNdDwEhlz5Zl1mckj7Fs0hZdldt8hwjglM7M9jJYryVj/glq/2GTq9XBRY3K3nC/AF/94zjsfpxE/FLOYtrsnj/uQlihOgovYvovV7Nlhp9s9eBzRkWuOzFydpmEkoeRJCSUdAopdS9QsXgy2ovflmHDf8l/d4aA8kTQ/Luu9p4G1HG/8kwMaedY+f+cuQ/DDZ7beEfACqzbPtIFykkjxcZ8oUla3NDJQpGQJ7di6EmvfRyFy+eo3QjdyJkFpzW9RTccoQZ8sasq5SOX4TTZ1aF0MkH+r5s3lg5MLf6rO0sjoBXLlR6q7CeNtsyCaEPTbrmQh/czozqpzc1LH6dEya7d2g3DjC2D6gTB0mELIOBJtctSW3GYi0axHn7OrkD6mL0w3gqZhOr9S2ZRoZ2yDI/r+j3zqD2XWp4qnJt
 1tltYpiq
 DaCbUJZUcVew7fr8NrBPtgEhCfyVUIxMxFCxjc1PviU3Db0Jmn63PS9/sEhPyh0OtvZwJAXPqiIiXDMkeShrIy8FDdgir36rgLG7kubaBPTOREZebT9K5eG1a0GLl+vRPqQ9rEg2UfG6nvl+nWpBhdiM2MFkvW6hnUvXzYWN59U5Dc8HPk6CHIUbktZ6xV1HalK9cHqLAFxrjaN4bVvYQbI7DMJnRf9z4AFCLenmz78d+bjganDyIk85WEhvBZ2yDnIAP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 11:54:05AM +0900, Sergey Senozhatsky wrote:
> Currently, zsmalloc creates kmem_cache of handles and zspages
> for each pool, which may be suboptimal from the memory usage
> point of view (extra internal fragmentation per pool).  Systems
> that create multiple zsmalloc pools may benefit from shared
> common zsmalloc caches.
> 
> Make handles and zspages kmem caches global.  The memory
> savings depend on particular setup and data patterns and
> can be found via slabinfo.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

