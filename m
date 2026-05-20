Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C600CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6F36B0005; Wed, 20 May 2026 02:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57556B0088; Wed, 20 May 2026 02:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C8F6B008A; Wed, 20 May 2026 02:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89D216B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:01:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 005CA16044E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:01:30 +0000 (UTC)
X-FDA: 84786751140.16.15CAF5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2F8654000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:01:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TC03oqID;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779256889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUuf3KluThhkKceNz3An+1YHqbDqW0wLJBxqsVqxkwM=;
	b=sQv+jhXfEE6v2B9rL9nR3ynpb/rOOin67LNqJQjUj7Yj8A5n2UuI8W3uAp5BwsMngAiSAV
	XW6XJiousL5QrtQDNhAuf7KDg4+vgdrLEXgZh4ZgMuFS/hqdIsMclf44Lpj5vjEFQLDJav
	vNJYUkqKIrHelBxa5jlQl4m4uB5CL7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779256889; a=rsa-sha256;
	cv=none;
	b=yCA14bwdw7Fo8b+dB3NI6no5FjToM0xG8/Dg3GZhzf90R7PUGMbn/XUxLTI3l6WGDPw19l
	g8B/EKW6moZsyPkgBuxtVSEGGawS/34oe/fxY/ECaHgk4KXjKd0Uw0lulnFQ7wGmqR0Q9I
	qRpIn3mohaMkOrz06hlO+AG5duh5Hgw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TC03oqID;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24EFF41993;
	Wed, 20 May 2026 06:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD1D1F000E9;
	Wed, 20 May 2026 06:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779256888;
	bh=XUuf3KluThhkKceNz3An+1YHqbDqW0wLJBxqsVqxkwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TC03oqIDpmgQKcVjw9nJ0KNPdkGUZuF7PCpEoA+pJfAToPjhihGccVLPtvrebIZbH
	 q61MwlIfLoTojg6kBoO1Y9KD8qpDHC/I3K6mMlo7bzwPliW+QDgrn4tmSnyyffr3Qk
	 GOTGOaZ+RdS0NOhXhoUaT681o+mAUSZUWISGAMN+GsYzAcaBN+PBd/deu/ItbHXNB1
	 GYdF8v4jC9wB8nkjjzc7AeGevyKJsQBaPrGET0L14S/ae98BQZlVBr5cEH1Gcp4MtJ
	 ZJYfPYWE0ZTKsC2DYcdAG7T+ZK4uovuYIkaNpNOugb9GRyRcIIbU0q4q0JrN2dW7xI
	 uTmhrtZcP2C9g==
Message-ID: <00a65776-ce8f-49ad-8fe3-797d6e92f51a@kernel.org>
Date: Wed, 20 May 2026 15:01:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: store node_id instead of pglist_data pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-2-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520053123.2709959-2-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F8654000E
X-Rspam-User: 
X-Stat-Signature: rj3p6ah5cb8sqbecnrsqgqm36gzrjk3k
X-HE-Tag: 1779256889-533697
X-HE-Meta: U2FsdGVkX19qUuJCnhVHFY1MJN6gRuSmyUU2zQPdx/V251QK/prFOu1P8+YLKe815+xyu51yfWYpC1AyUXRzL/b8DbEyFaLFB50vzusS3aOVQMMcH+cfYzqKimq01iBQpT7hZTei+Sz9GdeQc5fiY2n++EK/0Nn+LprVaRiYNlkWxzzvhe/ohxi2OvYjOeWb64Z47nOWFMQKTEmfZtyUVldsLWyCkHhFGsqmCM1qKdUsxHyP7HZcJezZ0WfkzEiqtrAJLEb2onaqkGYXwdxpRoKna1b1wFwyvbQCa7v8aRvn8w6nnWEXYMzDYUVWtQ/1skkrM+3D1ymFvxBS/0YRQd8py+ESZFhP5g4gf9RQRkYl2xSxmCQF51JZ2u5RtJaTfwrLhoBa0t2tAxpM5U/R47V1LPfbuDMCswSmG2OQl30tO7HXtsFgpFL70My2SqH3afMzC0/d2E5YOTsn4UHuXyk4IrUW/OJVt5CjkBQ8P3ayaU3DmOiu8UB0bvI5G8jXL4U3OEbl085p40PMApCRHbJrikl0yV3G2YO0AZpzGQz24cchFi37fARejFBW0TlTNGccJ8umRke1tJnyRX4ip5+jH0lC0JJrRxaaX5eEzMCrM074OzZuvxW4iZPtmdrjsAGhpRZDn30cgoKSgGK0euHqQTiETZzWHcc2IdDDrI1ZNCBWd22AdU8LGQyaji7o4JWAG0wXhqXTH4IWlQFx8iz//SELQwIhNyiFg86qf891s3gjCorMBRY0gI7L/6/Klx12acWBuR7rwwWO+J0FBaEj+xAwHyPWsiAFbqzUUUV+hifqfhRpyJUIZ+lmhftCeGaZkijyauSe3fkHfvI0XmXQA4xuktILagIkxviQdob4lsvijdZ9WhtC0y7Ka3ZaDukovHlAimhCcBpgBTY+PNP1+/U3FVmW1ErpJn24N+Jahk2poEfVaoU1ovEzJP3Xt+f7hSh+qLppAbgydMa
 vudaB4wL
 rkFECQZ3usoZYMgMKWfnV/yVwx9ZlQN0tqfETVrfDCKWnEwyoqJpvIMA1HIkgrH2/5Lx2IE59aMGNZOAQyR3AZ6D1E2c0EJojuFYag3tE8YSPWI8/NeB+z8UaNoXah9sysN7HfJYEBLv2eSaV/ADIivBBok88Ut9OM1x4UtMEiouBBWAr3SFcr1tQWTyoNpDOhRQIU0zyngSM77PELZBSynP3Sgi1gG1NYMbRxmVLj9zwaAdjn3ai78/w6p2ZvckV0HLkvw9/3i89/5nzUnzCUzn6/h5BWjXerStTj9zzxz7Ifjmpo9K3XkTzAiILuobd2nSnHvgmbnsxUoeAOq35ABh/ZBM+ym6/CcRSRhVfX7yEjLiGmyTn4U/UzGokwWNuZYjFDtK+3Xa5Tr5UFXQ5qdT4CFn1HgzZW6squDoLXFQDvsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 2:31 PM, Shakeel Butt wrote:
> The struct obj_stock_pcp stores a pointer to pglist_data for the slab
> stats cached on the cpu. On 64-bit machines, this costs 8 bytes. The
> pointer is not strictly required: NODE_DATA() can recover it from the
> node id. Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE
> as the "no stats cached" sentinel.
> 
> At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
> plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


