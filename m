Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4BB10A88E2
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396F26B0088; Thu, 26 Mar 2026 12:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347C66B0089; Thu, 26 Mar 2026 12:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E566B008A; Thu, 26 Mar 2026 12:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166136B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:02:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9E02C433A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:02:15 +0000 (UTC)
X-FDA: 84588681030.10.F8D384A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0088F1C001F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:02:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nZ1sFFnM;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774540934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcAbrX6ODf5LOs8xw/Oiha79DxbZoZEzxKqFT7yoPLs=;
	b=wN4hDPYFGREfonPoOhyVZGmb1HyV5l3rZgad5W15vzN/KNIjom/Su11j6JzRUzz8N3EVSH
	1nTbBtGt5fm/RRkbmOKNK8TXNeWidFezEQ2zR6p1JEi/rtStEvBOVy+z371ijElSRojreD
	Ieqx0JaiOR1n7mV7H1Baz5dbbHpV1Mw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nZ1sFFnM;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774540934; a=rsa-sha256;
	cv=none;
	b=NBTCXgxhAC3Y6s7hRBZV5yM5zrgNvGX/xY1LNTtosVeXWPNjLMW7TRRTMANxPFxOuRLFd4
	MoZGoNDJogqiSPjwNyus9lSDe17n/0C3rrvla/RQ6kJQwbp7itncvanYvHcIQvq8+wBp2R
	jDR3hDAs2rMuXcqhhyV0sCjC9FNpgsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E43C7600AC;
	Thu, 26 Mar 2026 16:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726C1C116C6;
	Thu, 26 Mar 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774540932;
	bh=pcAbrX6ODf5LOs8xw/Oiha79DxbZoZEzxKqFT7yoPLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nZ1sFFnMrIcG1KY87J3HWMSgnEVbgJj9T0BRYhN6Pvv2jsqhhpqyM4PZ76QJRWxTr
	 FGtkM2KAuoNaa2BWv3UuEqqi6X4BOlIduTFT9qtPkieg8bJslfcz30+HKrIevkOojX
	 k8D+dZ73hpWP8GKlSE1zJatC1KcL0KS+EMVqRCTXESQ3j4m9j/hab4p5A9dzGAQAzX
	 cpdWlzdtQeRO9OVaX29evsZ7vRB6ypGLuqv9pEXJC5Otb9m7kSwphAxpXPqFwaaRHM
	 6BFw3Ml2ZY1kUUamiOQXWaP+RWwXp8qVGe8KXNScRboWM8mMio8QV8Co0q9GIH/oPb
	 rWmInPRY03lBg==
Date: Thu, 26 Mar 2026 16:02:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <17b13155-b795-4e00-b9b8-9ab324c72aed@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0088F1C001F
X-Stat-Signature: zeemssx6mzh4acj9kky65cdtcpbc73tq
X-Rspam-User: 
X-HE-Tag: 1774540933-167344
X-HE-Meta: U2FsdGVkX18nmA+c/OnFlxWDkjNv3gPkQGDoOj8JoOIPoD9PDrDzRsg9oez3XORBlpBnakCTSpG0EG9mf2BBUuQxOBScQVGtTRUoQEM2C1sf3HrfMCgsuhFsVDopY33bZWVExEdWhyNzi9v/m+zuKbc7maWSPnofPZCeRqQrxquh4ZUJeSb2KNoMqFy2on9Q6vj22rzjyuu8R2Bl4FIpSivXDV3HZqCQIIBk6DqPFu6b/ly6Xn1T+mReIHxeaorYyJtdyst6mdOhxmPvB2tW+is8VxveshaEqwsnJ974sMyUnZfdAoXv1C9B58d/4NA7fBmM8Eg5uHrgl48YAvaKHIihJegU7Ut/O9NTfL8OuHwzqq31lXMjRlaBUPcKhKjOjY0HCjkGMZFjJgY+76IqowijWkJfzlRohNQPvfNAlR45m3qd5EokqFfxE4C6FZdBEE2gT5Cf/ND9GN+TMbXtz1j7zVW5QkBUGUP1bZBLDFliakZrQTVE2w9rINlcRlhCzkf8kA50CZhtnuBOX33GZ2RE+dZJsOJORV/r2XltUNXiMxaPV/Mn1hM8cuHokslrbrlA0tyDsbdCUKKkf8cFag2vylpUAJQjvKOYiqfG+px0icB7mX9SCD7w6WXhggnq5LX7L4xJxmNV08kOhMc2pYA7/QYUjpB4om3NVyXrBzJoqvzr/1yr1+Fu3eZTu0Z9MfW9nL+LHhkfvJRDX5Spb5p+b36hMP5wZN6066BSpOz6/skvhY5qyy1SrWOX7Sn7St2XdFvOEQ4XVPCmi53gSZuLdjt8rRk2jrCNdOfhXCU9Hm8d5MQITPvGToRYEzNaFbyYoMnLp+32YXfLfq5nOwUU6757hnPuRHUJPB1T0R43FQnkr5H1+XBnmG8xtZoi9DHRYwSbBuim81iiX6MTg+acoH62VvwsniZnGvwpqOzyQqwTvO4iHGbXo+yqprl8azu50gRXftEWwv6L24X
 k035DaZu
 wX/nApF6E4RUUHNS0FtjNMBg+sF+GFloUaXgDbhHb0vfw+ZpAmhuX1QzSIVR0R1lIw0m0JDUEASBDz2vA2sTWvZT4UAggbUKUXw8hg61oQONWO2oS9pKkXjqc7u2mb43FBVCsu2Ht2W3DYLaCLxMJZcY1USVYCBaaDpCJhkc6AHfSwggwreh/hCMluesr+K3Wt8gFKdp/vRdYNfVdiKt5SDCLNSlpm106vEc9z0PcIq/AHD90lnnhpXgi3cqFidkpgAd1N9IzB9rAblo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:37:06PM +0800, Kairui Song wrote:
> For many other typical workloads under stress, MGLRU performs
> significantly better too (e.g. database, build kernel could be more
> than twice as fast), it would be a huge loss to leave it unmaintained.

BTW press X to doubt on it doubling kernel build times :)

Cheers, Lorenzo

