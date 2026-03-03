Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971D6E67A8D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E716B0005; Tue,  3 Mar 2026 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C756B008A; Tue,  3 Mar 2026 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58796B008C; Tue,  3 Mar 2026 03:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1CBE6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:01:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57C9B58F5E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:01:36 +0000 (UTC)
X-FDA: 84504007392.07.F902976
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C55F20007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:01:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BXqhCwYE;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772524894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGygmojsLtPwlOT4v2cotNZ1hHvskz3elg0StMnNUFs=;
	b=OefhBBu5plBpGWnaMSZ3+Pec1JQw5NDzZwSaLwm7ab7z1/P0eInCy9LUHJvi9OqFrhQdtf
	ZCCL9FNvOdZ65wzH+kKyaKoIkNOg+5HHbnPuvjZDyiUAKr8VHfBi7juJewdqzjxEhC5Ytu
	4J26pEObHVyXWic0QrRu548/NwMZXW4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772524894; a=rsa-sha256;
	cv=none;
	b=50RsL8VAhDqDsfdZJSLILmJzOogAJ37czKOScEWAKZ+N1wHDmNbPlo0MKX8lTioniU6eNZ
	sVf9TVohFk8S904dPM88U0CfbxTOKprLKAB9GsFg/Lt4DTUJz87tQjclyuICac5Au44kuo
	N5nbFabAxNyscHYArQEzfL3HLRfRbJo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BXqhCwYE;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 3 Mar 2026 16:01:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772524887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lGygmojsLtPwlOT4v2cotNZ1hHvskz3elg0StMnNUFs=;
	b=BXqhCwYE2S38CiFbKca5uY00d0nIpLm2ad9nlVUytP1FEw0bJJIuQII3Bzg+L06fmX44lc
	NT+5yFIP1YqUkeKcL8yplHcogpgiv0zEbzj1Oc5hz2lJJ+xhHvPIpNIUGNIOv4p05df69m
	i6azEqah0au/LLCArNfgVXIRqMiV/20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 2/5] mm: memcg: simplify objcg charge size and stock
 remainder math
Message-ID: <xhv6zv5atecuzfsf75cyh4mynbloc56e7ukgwhgdgf2qvrrpwy@x7o7qldvxku7>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-3-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C55F20007
X-Stat-Signature: j88oc3totq9b91538e454c36ki38pqcc
X-Rspam-User: 
X-HE-Tag: 1772524894-861359
X-HE-Meta: U2FsdGVkX1/iwpYHRixgBwb+B7UEi0yVu77S7mknhjlfICB1OMDzLQ8dwtm4cZonT6JbRIvr1463Q4kW05wncUesoA9bq/kXcEP55A07npR++bsRRF1yTtiR8yB2jMs6g1odt/hQTkaF/jmBsEefxBm3S7e5KKKIs8OfOPo2wBX0VIJ2VagBhcO+Tf3K5rjhUbIhv9Af8d0wUgQynibkUAQBu0xwQDn8Z+IPs9zHqkoW/UBBMOgz7EOzkWz8MbQv3e3lQZMbyPZDEvIUIkxm6W5EqlBLIHofCYO7mReHhINDSQB1bD7boIFBl22XeMtiTmOijtZQoFMJnbmEiIZT0gJtw26Q6/3e8W9X7cnNo7aFrQP3G1ABhiyK8URc7aDniSICFOIne6d4Pvgzj3deYkyPkdtAKbIg0JZAPP6VNhN6dmgOFYERk1g5PpC7+/9aVIlXZjQN9rxEtPDRy50lFj0j1hv7HZmFRj2Fz0mlXcSmV5VEYLVoI/1b+tXmi/5np18ql//ivjS8adXjcEtTY6T8mXYljK7ii0liOZQhGOdZ3Clwh0E0aM/QhVQku5p5M6A2FYaYvLX5Jb9IMjUDm/ChdHKQUtxK8hU6i9JSOJs6yteJc0m40CeyzjLbgyOBOL4yLJ2VU2x7WgKJA+ctawVltJaia5zj1pjL5+BOrqAL0qeS3ihsr8U2S4omqjybkS1tqLLZnkYUXgXyMTPVKz+p7ZeS/oKEpU3B/CUzIOjdYVzN4Io2C0f8IPFkEU4TP4zUnJMn7NqPDs/b1sICx1RFv/zGKUqYTfUQp0iE5h24YpZWFLOaOQBf52ym23OwJJsRfyZO4BqWnoc8tQQKFALM9/KOGABEmzG2FnWlnTbPupe1uH5gsFeQPeyDt2UYIliJItlru9SlJJ0AAwyc3WyguFUF1A8fiFzExwY5UbCzv+uEZ9HBoQroKLoTZf8r7ApdgXZP+U55h//Od6C
 O486VWVd
 MJXoOwb+PvcCjFlz1F/wCEcSCVOhigqREj5H667dRqGHucGmfdrQ4uRst7/2AV6EaXKVF5oTEcnosQXF57GUjlr+HMoIbFDFf4vAwMHwd6CKlZZFItkhG3KA8eUSnl/JF7bEZpeJbE2p/ktP74R2cu6sC+sctM0yTpSWqHpPiSuti1qsHEhlBOmYol9ytLlnk9MIJmPTQQ4t1DtoMNuLowC9eXp3dGN28na7J0/xGaRmZ46tLUE4nwo/MRCKMcxJkQy/pdOPBcWOHn3wNLUKe22ZWrrDp0poM0uUZcfe0ahdsxFFVb0bhAP8Iey2Ny2Sbl6ucR1+jADclBks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:15PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Use PAGE_ALIGN() and a more natural cache remainder calculation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 

Nice rewrite!
Reviewed-by: Hao Li <hao.li@linux.dev>

