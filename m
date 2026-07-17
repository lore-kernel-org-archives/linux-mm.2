Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CB8C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FC76B00A3; Fri, 17 Jul 2026 12:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57326B00A6; Fri, 17 Jul 2026 12:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E5C6B00A7; Fri, 17 Jul 2026 12:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3AF6B00A3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:37:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E3F81401C0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:37:47 +0000 (UTC)
X-FDA: 84998824974.04.AB49DD5
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf31.hostedemail.com (Postfix) with ESMTP id A28C020003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:37:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HYtxESPZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784306265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL/yhXHA9xDChnk74OgVrWXQ2aXe29pUqtPQN+eOWig=;
	b=Kj0qhfd1C7L7dJ0cJmR+d42XVXRIj7NhVRH/lSOpuxXPio6vd2zCP9JgP/kGohlrJugjmP
	Dt5yGv4l9h68kVaHHgKgfkPHTF9EQ4d9A4H2WTMnugS8SfPt7++UmXsT6lBXzWgPduoUU+
	J3oOqM5JZo1hUe0dYI2hbZNNGrwB6II=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HYtxESPZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784306265;
	b=uVkr8Jqh085Ud9KaAfRlVtttuGQ7nSRhakB0FMaEqwOUPQfwMNlPC5d7Omx0gcOeWtL6HO
	aluOEXDrgu2nQxkfZOolMxp9XaheWTmllB1+vxMb4n3d4NQlb73/R9B2I7CvSLUNZN18gO
	Wa27bdnfg2PWxw7zOpaxsHHXoASyeO4=
Date: Fri, 17 Jul 2026 09:37:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784306259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vL/yhXHA9xDChnk74OgVrWXQ2aXe29pUqtPQN+eOWig=;
	b=HYtxESPZoniA+M7wM1pV9JgLeuWl55BKmQOphRsUwI7f7HzHnFgPTtZUykxQLhKUpG2PGS
	9TaS4NSZlmApRp7kCcrLYMAxZEXmR5f7Ek8XxN/T14McUo3lhld4n74EygjfOWiXLhR75T
	AxBYp5MFj39fnqYJ1XipLYlkAHboSgk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zhongkun He <hezhongkun.hzk@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 1/3] mm/vmscan: fix anon-only reclaim evicting file pages
 when swappiness=max
Message-ID: <alpaJU7_NMgz5ie4@linux.dev>
References: <20260717113300.214717-1-ridong.chen@linux.dev>
 <20260717113300.214717-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717113300.214717-2-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A28C020003
X-Stat-Signature: rpz6pbmqw1t4ajsnj7prxim3g1o8ecji
X-HE-Tag: 1784306263-314260
X-HE-Meta: U2FsdGVkX1/j8sPeV859IRT9mseRt7vlfqYll6bBaN5/VVYdS3qQIkgzXscK80JwAQ2tImxJFDgB30euoLbkH1oOhkr6Os3F35IL73gshkoqnC1qlyjxlnaNkuayjisL4joN7v46iTjKRkWG7Na8BwCtTCjsTcG5kzZrK00Pi4lQSs774XbOjwE6ytYw9C2ed7hgJeIpMoKib0aBbW10i41Qcb1aeXee2PZrQ6WP0vYaxXg6V40lAMkSojM5tGk2J4CEtpX2kC/fu5/wuS1Ne3KrQrs+ieFkS9l61p20aVL5T4fHJgynh8SA6CoeEhx5xMSRiGif+iJe9OV9VxdrZkuHLChA8dTzlz8+BDHlmSkqYseNsl3QgBbrUW4qt3pu3EAGNUV7JLVdigmClw0HSLEM984/k9U10vBUXAQ4cz76cTe1FqUg2Ihe+Wd2NDvBlWQ7dlq1Mn4xIMsyMv2MFnFHHNYQEHI23j3wLWLqLCU9DbTDS8Onv4JQauCYCT1o20XqIXrko2baJaX+L1nk/3U1vH1J7pirHi09UW/63LY+b4+gCeuyX3u3ctzfR4jSzgxE20x/h+77CKbViHJrEeDlm8PEf04pOzw3CrWgtSSL3/EwUfTOTcax62I4deognTtckOE51A7XiwNjxmlyKZBXtlVL9Dp2LlecluJk+ewyJbe4wJKARMJAU396no1LpGadKz4tUgf17gpmOrLf/6AzH6TNNkYYpM11JzmsveJrzLMjojDeL4AFU+eCjo4S3QOehGL9zBT/GiTS4yXAS4kp+2ht500if7lZq5bhff2Sdz8tH1hFyn0+R6erKprNR+W59utoH/9F8TALM39yP3JPXWAedvY1EisHnNTLGi48Nn7dOZJANT/qPvgaP13TF03KN7Uud325cr7Wy2XunklGL88/iC0p6T675DG1hMB+cV1NuQtwTvYIO1xTEgQbrW0QajIVbaLZMrUf3y6
 X9v2lltI
 gtlDQOYRAmOP88eMURfMQmY4Lw42MugjZLg3GOQgyP/J8J8WVir8k9CAp7u4rNjFp8bAP7FtPX/qapoV8HJp3x9WG9R0b43PWHsowdf8voT60FmURJANRFnpPgMtUa/a1XEdhEFZ9X9gHOfX72jWvPEpDRTXvyS66pLytmCLtJHJlzD1farnCO3PND1Zj/4kiYK2GZAPB9exqDxWPnjm+ZZZSZYahLU1ciqj0lcoVSQcJof5yjxCQdSSrzGeARNWhrIhB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:32:58PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> the reclaim logic is expected to reclaim anonymous pages exclusively.
> However, due to the current ordering of checks in get_scan_count(),
> file pages may still be evicted if can_reclaim_anon_pages() returns
> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> 
> Reproducer in a cgroup holding 64M of file cache, with no swap configured:
> 
>   Before (file cache is wrongly evicted):
>     # cat memory.stat
>     anon 196608
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=max" > memory.reclaim
>     # cat memory.stat
>     anon 208896
>     file 4096                 <- page cache evicted
>     pgsteal_proactive 16400
>     pgscan_proactive 16400
> 
>   After (file cache is left intact):
>     # cat memory.stat
>     anon 200704
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=max" > memory.reclaim
>     -bash: echo: write error: Resource temporarily unavailable
>     # cat memory.stat
>     anon 208896
>     file 67178496             <- page cache untouched
>     pgsteal_proactive 0
>     pgscan_proactive 0
> 
> Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> anonymous pages are reclaimable, before falling back to file reclaim.
> 
> [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/
> 
> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


