Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F6CC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FFF6B0095; Thu, 24 Sep 2026 16:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77026B0098; Thu, 24 Sep 2026 16:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EB16B0099; Thu, 24 Sep 2026 16:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79F4A6B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:40:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D1D61A04A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:40:09 +0000 (UTC)
X-FDA: 85249822938.12.D62B601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6DEC840009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:40:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FamxgVkd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790282407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlGcEMzcjTLozgQ20Llz9sQekvSUQelUVLMzmAiWMJM=;
	b=zDya9aaGyHuzKbR1Fg4yk81cMuafOZcc2FsZU8etE0Cm9k3Zc876/NoVcIx3NrkuRjcIwW
	AzB0m4ShIMoFuBKlWls0e+y6GilqEnIx7RpzgQDW4A6LGohUajJhUiz/oikRH4iN9pYMZj
	Qbtw5nq3TeA3Y6fuTgp2LnyPLZgbEIs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FamxgVkd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790282407;
	b=vbBaZwcmyuWAGlPJbDUv1A3dcvY1IBEgF/qDgYa4l2m6d/m6qPFs1zejl6RQJqzeskYf94
	WNxfCHLhqnkS1st+veolVCDRizYLnwg+oztSA+pUdingfYurAgF5O71RpFOu4quvDnIho5
	jm+sve/wZ4xd3ux9VvKSUBydW3EOkv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCD9C600D4;
	Thu, 24 Sep 2026 20:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F491F000FF;
	Thu, 24 Sep 2026 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282406;
	bh=xlGcEMzcjTLozgQ20Llz9sQekvSUQelUVLMzmAiWMJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FamxgVkdLEEmbveMA8pTCxCu1c6ZAb2VAOytitnlu3ysj1jxXOW4qM9zV76xAi6oJ
	 BWK7L0L/k7vNj5JbdYPFR4PzT7WeQIguM7IyZA2bLGzVzaypUv8ZdbGHtuhT1zPMWt
	 GuLt1eHSoXYfZezrE+6yXodubV7sb1ZWdIoCb5p7H6Xs4s/0dvMOneS8xXvikSNxFa
	 kMtIg8Bp1Rgu++ym0EQaX98WCju3eB+ceIf+CRBo9h/owvW3uQ4vj1mGOzIxm42p7+
	 5TbpxkZQEU8G7buktVirdE4Fond48Ur/j8A70OzayBOaQNxbwlcrT8RLAhqyiIn6zu
	 Dab0eQZp1mqTw==
Message-ID: <3710ab57-035c-4914-9fdf-0827b1144c97@kernel.org>
Date: Thu, 24 Sep 2026 22:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: use VMA flag helpers in NUMA balancing
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-8-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fugcue1a6s6aadfaboja8tnj79dxuor3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DEC840009
X-HE-Tag: 1790282407-315446
X-HE-Meta: U2FsdGVkX1/GPhnW42W1Bhl5+hGBzZz6JxE/NNrWt/lmhjcg2I4hl1M0tL+9fTSuG32t8L4HEwd8fa9CGiAwIe0xbGDFFPYWlc88ebyojUv34byDiJFaKNANcELrG/ONZIiVKNIMcBS0lwSFNzDZZqPhksOgbz4061kevnBoqXZ6oipx2CWxg/ddA6FzeC3VzUeIt13zxnQxbR+xV8ngVuh+AvV3u6buiaw9wx8jSO9OX5HPhxE6QuOyMF6PsbOZ4AwjpLa5ttsZ9sf3yDi9Gt5Tl6DduMgGnzHwidnLl+cetzuMyKi6vY1gvzlNhC+4Idp9tFsW9nWgnvu/muZs06ScV7fvH97paWZem+9HZmDa9Mf43ZYp1/xzyeXFDL2Kb0PY3iVtOkCskyuGgv/SeV5YcOOLut0pVWu3M11jIAFH4hRljDq37tJ/MrNrtNPLjSYoe95nKESNhpvJdkYlYV9usGqBGNV1A7o2O/rU7jNExfrhx5uf67xFzrJfllR+Gq4YVVRzrzJhgUcKc0khSC1O1vKWGfOdPxfrzjodMr/TCXLhd9XsBerVMoMvU4jeW2LB9l5oLihr1KHpfc8b4SdEy6iqlYT1O5jBA9eBNaow9WmLuqUspOLlty8Z9JdmdXfHuxC1IyXQwt21CdanZX4NLqH6PexmTuZ2BHrrPUWyrmTi5fNzDZlKQkZE0gbMWekAMr7m7hLnsPX/yshaeCRZpQ0w+1WzR7G1q2iURJuZ0fenYjDH4UPX3qs8iyvxpuvJWQt2V+GAeW4B3VcrBBw/nQHzO9Bpb4uqTmYgTHDmeDbk71JHiavk3ULRyFfzz2WTIbd5WuokkIgRfrlXwiBRazN+vTJOX1dwSyPyKzbTiykFpGfBY4E+O8crzKySPE2//MXnD0eAh3JJcqaOzUCL6GO51NfjV5AUlw0akfyCQVrNyGmz47KGVbQ6H4Zfv51mPlSp7e9HkJmcH1j
 vaiLy3bO
 uObxfRgqRFQ83qzRS3dWrzQnoK9FEsbd9Vg6oKTau+t1TtxjApu2SPVVcwc24uCzsU4lEs07dQoxXC1rOlCKmhrVx/I4g2auXFrNwmv4W7pB/9pBQI0YObVZ2tIlbKpQROPNmT7VzRGxFWoSj9/k3dVMaFzSN6wHEqzxW5uLbyIXBMrETc2sbHKL+Zw45fTjviCg+Dcjfd9Cuv7qlmLo0VYSmR/W011gQLWUn7/1whqdqFVLn6JT0zU10eApcqvWelf3YtXzpuhHiKl/kwss7r3LEgg8DcayDuhBnd2Z3EkRWXEo6MrBY9caQ4OiTEs9FHJ2oB8sMUFrP+i4jkLWG1Z5+eu7Xd+vYZmKAZJbsFqg1iwuxFhYFG1xbg5G2bv5wm3XGy/6zCQ+4IxRPuLkYpxOofMnYZJSP7S45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Use vma_test() instead of accessing vm_flags directly in the NUMA
> balancing code touched by the preceding fixes. Keep the existing flag
> predicates unchanged.
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  kernel/sched/fair.c | 3 ++-
>  mm/internal.h       | 2 +-
>  mm/migrate.c        | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 412c72084a63d..0d48d595740bf 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4224,7 +4224,8 @@ static void task_numa_work(struct callback_head *work)
>  		 * under cache pressure can drive considerable bandwidth.
>  		 */
>  		placement_scan = !(vma->vm_file &&
> -			(vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ);
> +		    vma_test(vma, VMA_READ_BIT) &&
> +		    !vma_test(vma, VMA_WRITE_BIT));
>  

Indentation looks wrong.

Apart from that LGTM (did not check if there are other cases).

-- 
Cheers,

David

