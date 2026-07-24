Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5004FC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588036B0096; Fri, 24 Jul 2026 12:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FF16B0098; Fri, 24 Jul 2026 12:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4764D6B0099; Fri, 24 Jul 2026 12:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6686B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:31:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97D321403CA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:31:58 +0000 (UTC)
X-FDA: 85024211916.30.D8DCFE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A2E5140002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:31:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnAylZo5;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784910716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGnfLXs8/3ZZXMJGYBJ/MC8/fm2UhceZPaA8h6BrZ2U=;
	b=PrFT0Ptp1r9DKr75/yGikFEGPZkQ9WfmjrWbmzxspSlyRqpZ2aquOLhoBx3+ZkBWqd+5Oi
	lrAa1quoCvcovOstJyRM3BytUheffllLwTL5GGraHSa+eBgv/RjXHHaSWh6+tKoz8TdrSs
	JlF2SQ+182Cw9UkLwl6TplBtdRRt9cU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784910716;
	b=DZKjV29pOHdZbWPg+N7mOFsQh4AxH0/oL9rUJUpmR+qzF0hJCl7Gjn2YXED9UZ3QR4pv8S
	WCpOjjc0ZlzYFpi1GQANZqlJXg3ETjVkdn0Mh3Bg/7eX8RXKGLuO6cuG7HLgpCLmRrDP4L
	Z83Bj7aH55J3OZHNhKHyjIWr5hpIlpU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnAylZo5;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A19943ACD;
	Fri, 24 Jul 2026 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA661F00A3D;
	Fri, 24 Jul 2026 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784910715;
	bh=ZGnfLXs8/3ZZXMJGYBJ/MC8/fm2UhceZPaA8h6BrZ2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WnAylZo5Q+efUUv2o4we0ojdl5IB/PfmSC2SdGJXKGIWWSFyDS7DILVY8LlqYG7l1
	 Sy8LG5Oem3ob7C49glLpBJGDH1xeGVyzdnsvKW2m79gw3cOs2eO88kJhfeTFI+w57W
	 dPe2GKoxvgQZ9ggXMvvIpU++ahr/qkNS9XZRpKOHhCR/+AWiuVGuInFqXDPNRMer8w
	 x7YFYzp84YlKN2m3i0itoRfgndqjaiOhHAiU8kh5CRtmuA4EPV799crK0fXIF8pU5l
	 sn3L/tJZNS4cXZfCWA3sXJeZND7IDn0NpyqhbZd+aJqwQNmU7I3FWahBqq8JG2CM8t
	 w9027hws69c3w==
Message-ID: <df871664-09ea-4e83-bff0-bbd3ff9f3ccc@kernel.org>
Date: Fri, 24 Jul 2026 18:31:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amMt7baftCrU-OJq@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amMt7baftCrU-OJq@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2E5140002
X-Stat-Signature: wpeomwtsw35zaoozs6oi3pnxzxqkwody
X-HE-Tag: 1784910716-385408
X-HE-Meta: U2FsdGVkX19Lc3HryEntEoBndG4/nnQv1MLItrVCWtqTXUGTk5VZuV2MGyII+JkBx4D5M9Bn47lfxoM3COvL83Wa5bYsaxDPf00re4e5YQDgiJIPcUZIO/12Yg/lDxYNHaTN4TikdSG5hPiFys9N+5Y9Ov+vDYvm/RhvoEXm1hJ94Bs8EYl/0qEcsVSvQc9CmgABhY2eknGv9L8a+7zdaD++9lM38ulCeVbGk56+kbVjJKcunGPJq677N3yxIq3yRHYwXeFnFXma1BwT3zR0JnZUKbJ5zHMGn+7rvQJzdbVLz+lDaNrtnW5SNSsZ/gwzH0vtJvNnHzlt1QFXGCgwlGqTBmHeZzcIJwjWdnSKqK7ZlaPU4+ffyORgzv2q5XhkYv6boVhzejxmtT6cTU6SWzA68sssJQKFrD2s2bGhrTzkkNB+MelkIkB0tjgpr9oaMdM7cau46rLH3m4bV3RnbB5lZswZE/yY9XDJn6LAe796mXF10jCkxUPp+eMPP+iRgjHQRN6V6lR9zWkD3PieP/A46qnvgyfTAkhlg8FjhHMYj8G5ovRdvJtYmu8zFOLGu0S5SqO32M03ZHe2Jgi/dlaD/YSSMisAW+3it85VWzVbayx8jLCuFcpbhQ1yJSrrCwVPNzOpSp4OG6tznJL5Og3YJiYU8Wb/CYlrBIGDUK8jscaOIYMYC2p03VNfqpLQoAU7c7HUZxk4Rt3KpHkK7vrIC9XX5Vd78gW0YxRBSmdv6L9Cr1cbx3QQq/RVOQe2UkxpHHmgGCRpvXibYBommgXb6pyNxrvXlbTeb43Q6QM3mn5ePygEshhrbDdx3A1MBH5CGCwtxFlB8PdZ9dFROIqCCafV54s86RApS65MhLyd2Z8Adxo+AMGOpfoSxsDl/LDlH19v78Pv1SG4iQxHTh/RykkY+sNjQV3BO2wyRXryjzH461Ey2s2pL+TK9YUxdimyMu9EQQ0jeClRSmJ
 fl4w5DeB
 D6dbS8zh77fqvJheI1LTpIvF/s+5veDNVAHxdBk1L+9kiuPChI8rH7JSNUgfWal2UUMWOT7gHpotvthnGS9gXQQ71q1S0Wgp6q/Wh8fybpY0QJ7WVdeUydXcI+INjXxQCGiGCr3h0qkMKEAZBnShInMw29L1a4fJp4JjqTHmyHeE4enxZadAw0R5dVuLTucKOYJs806O4g8kNfR5LheEkj/AY4waiyAn3dds6TgFWBUSucndYmzc+X+rLuKW58QQSJAOcpkD+CTpIXHPjyMyATD9s3e8iWQFjkoh5GqiWO0rIJQsuzLtkLl3JlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 11:41, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
>> Slabs of some caches never need the objcg part of struct slabobj_ext.
>> Introduce helpers to query this for a cache or a slab.
>> 
>> Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and only
>> is_kmalloc_normal() caches don't have the flag.
> 
> it seems this could be "only type == KMALLOC_NORMAL caches don't have this
> flag".

I think not, because with SLUB_TINY, a KMALLOC_NORMAL cache can have
SLAB_RECLAIM_ACCOUNT flag and thus is not is_kmalloc_normal() and may need
objcgs?

Yep it's subtle :/


