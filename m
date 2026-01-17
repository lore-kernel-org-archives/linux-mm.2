Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B38C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 19:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6126D6B0005; Sat, 17 Jan 2026 14:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFFC6B0089; Sat, 17 Jan 2026 14:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECC86B008A; Sat, 17 Jan 2026 14:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED1D6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:07:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA56CD1DA7
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:07:31 +0000 (UTC)
X-FDA: 84342389502.23.E0BDC9E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD0BE180003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:07:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZUj950c;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768676850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9AsgKoyuk5x5jqoqUUIpz4N+GGQWQ6kYKehHA6kLds=;
	b=s5E/nyRsiYP1UsIiq45bp8GNA1Fszh4d8vVsrX0R5Z11MmU00ig2ISec4mZKS94Uj7KEQh
	MQDkouGHEBCJqhC2JcQIFHMkpJyjxW7bCJsfh8d5WF+JLsGKxxSfl+MsIvtvh/29sXGfnv
	W1N4kXvJ4p1ZUGR7+TS3Y1ueJ1J+vJ0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZUj950c;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768676850; a=rsa-sha256;
	cv=none;
	b=1S4a+PdCxVeangUV2vjqUvFPkfrCXuqWAIN/Y6G94kC7h/PTUskVtwOIqYHTvcSqTra6BC
	v9zC7sJu3S5bx/BZMPtJkyMpV9IOT1cpVI1htlEKFHQv69WqQDUnqB5883/AqP98LEM/Zn
	HmlfoMacWeueNik3IlGc8sieuJDAChU=
Date: Sat, 17 Jan 2026 11:07:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768676847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9AsgKoyuk5x5jqoqUUIpz4N+GGQWQ6kYKehHA6kLds=;
	b=UZUj950cYM2sG20WuMnfBLNltdFlln/CD5j6vZQXpuBTpi9FW+vhC6TBKMzhqgKjcqCBA5
	0mMrHzOBQ2mUM6b6fm6AfAuvFHFCipucaZOaq4cg3arU/XUoZutB9BGyaLCxJ0KCQq+SM5
	fCyds5QIg5zAVFS+AHxYdi7LaExhBW8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Restore per-memcg proactive reclaim with !CONFIG_NUMA
Message-ID: <nqhi5o3viu4dv7wgjklmh6ssvpimjuecnmsf4hhjxvr3u23epg@iaau6lairrkb>
References: <20260116205247.928004-1-yosry.ahmed@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116205247.928004-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: peqiaii3z1gbqszrjtwbrunzmct4ewzq
X-Rspamd-Queue-Id: BD0BE180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768676849-12002
X-HE-Meta: U2FsdGVkX196bA8xQpV5HHGwLKC1BG5/KW6sbNTGyHGEoZV9H0dkWozurAY7MU0vkrEx53qaLbFwlQyQgY5Tv3c9BjCdA0LS+LrM3AhSe/tWd9IqXPfeOlQBiiDlUeCQ/jawRzGARynO7/nVKzvrC1hIFbltUa/R0qJgeNAw7teKeeL9hrVDASC+JCFzQZiUO6W2khe62Yg3cY4i1Gn31VjBKes6tb1jO3bZ0Fg86Gb3t53txjIUGVcyl7dPZFaItyE/1ABKgj0UOuEdA5wqrrwLk3E1CwBErKXNVsw0+lNwugrzo5u4Rayj/8yHLSuc4uv+J0TLkHeij7/eoWkuOk4d2W5vF17OqfX+anT3yeVue5ZGoNLgdawiGbsdCCGEgUP0k+ae5zGiXNWn1ZNk24xzqA890Nun4W34ju+OUQnhAvj7goF4/BOVeRnmOnY6ZjZWtooELgfalYotBLpxc+ltCT2Grdduv2XDG6/lki6e1Eh/TNbn5xrCIDUXqyftVI/jkCUt8mQ6bE0SbmHLdCeXEUw9vNV3qBsEb7QsLafgJ36RfzLGbOVR3OoQOlS14ykRQHoptVmoq5FDbGSGUqbdwFx8WcKUuaqWK9vINQ8OKEA5S8wQIF6uQL2kT718A17PJiLYQs+w1fhxf+h54FJ16jV+3cLeozl7tgIcoS2NoIgUoG3LcHthXuLzoOrc09qFseaoAvqzvbrAymBsZjsKsgHqNLLaMdzzDSWfl+lLRCVEij4jdw8wZDXfcKbJy+4uMh34pjEYtroXgD6aOim2Gli3B67MNgEWw6u9TLwPXO7eDEmlscbdo5gO/SP5SSG2V4Wqv1Pb6LRTEeeQPdKDKhn5S99UWNYPVdEqMuMG8r6dSzoWuXGAgaCMiQToylpVQyAiwFG9PZUVNu325GP2pH2ixqa6m1eaEOgj/Qt3u48zdK452KDtIm7kNcwkb+/aFUwjrTAHwI7mrwD
 Ei+LWTGz
 HhYqIHfgdCGeQBV9u+HnwmS93ivzoYtKSPsfLM9tFnYqEy5zKqkEor8Agxs1O3sySMDz1ncC/egtldZBOT3M/reyu38jvhGGSPiG2meK00zK/k3QC6j/rktlrrJdIuQcNqV8NrLmogZQn5LbmrAzCSB5DogGYbYz61kkXMZpKfCIReU5sYkVSeSDFg3dex0dc7/JkAT8/YjXnkgoPIsaBbgnzatR4LGXPwkpqbhfQMKlxSZQLSoJd8UC6wMVIzvP54n5X9K4abkA7Fhie3xUPvLp+FmavGknBYx1FyjbEX6gfoRbYof22Z+4Z7lveiKzPV6jZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 08:52:47PM +0000, Yosry Ahmed wrote:
> Commit 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
> moved proactive reclaim logic from memory.reclaim handler to a generic
> user_proactive_reclaim() helper to be used for per-node proactive
> reclaim.
> 
> However, user_proactive_reclaim() was only defined under CONFIG_NUMA,
> with a stub always returning 0 otherwise. This broke memory.reclaim on
> !CONFIG_NUMA configs, causing it to report success without actually
> attempting reclaim.
> 
> Move the definition of user_proactive_reclaim() outside CONFIG_NUMA, and
> instead define a stub for __node_reclaim() in the !CONFIG_NUMA case.
> __node_reclaim() is only called from user_proactive_reclaim() when a
> write is made to sys/devices/system/node/nodeX/reclaim, which is only
> defined with CONFIG_NUMA.
> 
> Fixes: 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

