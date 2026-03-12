Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B43106ACE3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873166B00A5; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A1C6B00A6; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727286B00A7; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62A016B00A4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:44:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 185F21C447
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:44:57 +0000 (UTC)
X-FDA: 84538439034.13.8ACAA85
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2974C14000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:44:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fy9lDL0I;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHoIsTG7IVfAzcG8vtVaG2KfMTAKD1Mf8pCRYcgobfc=;
	b=NN+z/gXnr2//ctQIMEdPkKSSXCYnDlMZz+QZaiFgnKY8126oMTC9wSEEKLdNYE8nAAemvM
	wDMd8PJjJK6L0i0ZjaDDt8LI0ka23PXhjFki/vMGAxvV1O1HTIL2QCcCyiYUngyGHK+AvK
	x2j8wuHul8PguWjOzm+5dEIDfjz7Xcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344695; a=rsa-sha256;
	cv=none;
	b=1ABBuI3Tof6qJ1h9jfu4V7j5W8U3A8hvnum0tVgOaYBBVrwp0na63aI8BxpvR/F4WRfhRR
	TZrPUkNoq6pmveLucrzT707b+LJlJK07Jin+cHRYAItGSD5L1ELGKnCPqPOB9uRVfklhRw
	DJAOIK0H0OxF6V5I1NBm9I5F/4ysVzo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fy9lDL0I;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41729dc7d7aso637893fac.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773344694; x=1773949494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHoIsTG7IVfAzcG8vtVaG2KfMTAKD1Mf8pCRYcgobfc=;
        b=fy9lDL0Iy8lWiLSWbJtxmxYg/m1o4LFBPZm7oRWeBOckDCvLG7pzMTmSAbhdtFgMaD
         GpLaFE72U8H19YWzu9c0EzTOECJPSvCU4CoTNQpN7xxmeUifT13H3ioutSs5IlIrL4kF
         KZFm1cdrTVRh114OBiWuIEpkm+mLbSCko6NkecPFD0IYHNn7GQsfIk4HrQ9A5Cf425ao
         d1NNNmkjzJkS25RqpU8Ju7rDtO53qMLeTKKQikIQhVpE0ixM0xbqF2H1q30wz9YLY7Gl
         XOwaNLMFJOwlT0+khNGzwzJatBCaag2vRf2LGYE+uU8ebrdL4WUR+tqk1WN5moqvTm1k
         SNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773344694; x=1773949494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EHoIsTG7IVfAzcG8vtVaG2KfMTAKD1Mf8pCRYcgobfc=;
        b=E+b1OP1VxsayNy5oRrBt97YwNlL9B3hGFnkVp8nNY0j+rAF7sRe4DwNAALnOih4bE/
         md36enqzWnrqcViHGFlFAG5pN5VNsD5K9PTLUd84Sn60+heYIBVIkaFdDVhOlEbOJMnH
         0nLthcSFgXKdmOtOmSzovoVJfVVnWW36mFTsHjwj3LRFWZH9Z9whgG3dU8K9E8zIRZls
         WTh3JNvxtchCusOeipD2ywYfCWA9k0UJFRc852E1qbeC40esWS12fuoW9wDO+Y6FkBGE
         q5MUn/mWUzXarAHvmoqyXghsd42yAyhumLb+A3N6VhEgkIOYRLG0sJ7sSMXYpYW5jj1w
         n2Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUQI4iEWpXucP/fa+aoKWHcTB5iOO4T4BqMaHs7R6IvExHgnstiBy5mamdHfBXodTAaY1UmHkBFUQ==@kvack.org
X-Gm-Message-State: AOJu0Ywgq7ejmOfbU3TFJJ8pfF7cbGnLC9425MIncd9Zhe7fdpj6BFpG
	ululzH6uHRQ39lEQZ+tzq9ULxsy/0R+DQajEeZE3SmO7CrIeClE9x09s
X-Gm-Gg: ATEYQzzwl25/iVpIuHiqx0AoWVZ4uBIT3JsFGnO0wGM7cL4pypdc5cVkeG0xLUSTgBX
	piDS+eCt7aARX1jTLFklxaCEmLyw+YUfkP/jgzgbdgkYgrzfLVxNzYdqLAu2T13RJGdQTbsstJJ
	5fxEeorgM0EAnWH+hqLh5lCrSUrkFyx23lkN0PwSt8MHi7hec4GNXaCpif330z4Vp3Q1QXuRFkF
	B66d4C7X1VgEJVKIHxV8qPnMGo1cqcJX+6bVC094cK6s1RLPfKNFXQgqyaDtMaERpMFc7/WXDK2
	ELREDwWb/TlyEfQ3mtyCUDyRawEVmJoIuPtD06/DWa5Q9i/Hk1+dJsjIyWfoQE69e02ldFhQa1h
	O/XyE98HwegItV8k5AjtyTcddf165lDwj2afuM7UxTFgKqS2i08+eojQi5hDZ7cSnFWAW7k5Epp
	qGItmRoUEsPWnKnOj9QAbh2w==
X-Received: by 2002:a05:6870:8e15:b0:3fa:a43:1f0a with SMTP id 586e51a60fabf-417b93f3d61mr527488fac.37.1773344693894;
        Thu, 12 Mar 2026 12:44:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6c7885sm5549386fac.17.2026.03.12.12.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 12:44:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bing Jiao <bingjiao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
Date: Thu, 12 Mar 2026 12:44:51 -0700
Message-ID: <20260312194452.3418042-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <abHnHN74V3okn28D@google.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2974C14000E
X-Stat-Signature: 9gw6b7e7jqirgp84s6qhbyqox6bwff3u
X-Rspam-User: 
X-HE-Tag: 1773344694-2078
X-HE-Meta: U2FsdGVkX19IYKHDMZRlqpohuxruuDTL0B2jrDX+QjRWcbfd1FSJmxMbowctZ4Kf98WsUIHdP2gZr8Aji3Frqc64s/11OVFU3BZf1wNQ20haHTHrlW6shnwLETq8CB6IDTNh9FQ0ap8cO4cE7Q/rTgPa2S6GtHLvNX9RwA66sOEwPJBitOgIGON3M8wwenULsaEikjCuLtMQDSNwFFM2VmXYP1SEIpCb1e1GpC63zh0CzIP3+XZ+n5rs9xHKDrd7LgYqctdBx23AKhmaNUlyawFAQg/XlTlFFoWCIFl8R+hTopErULnab4SJ6dl+d4yJb3P4Y/ZQ0ravyJq9OANp4QGAAgtmBtFDol0UB/0bgel5wvl9EA1btpBXmNOYXr+KW5B15Sxii+6eWKIxxaoNTTb6MfE5QGhvObs9ZP9OD1kBYBfuyD5d27UXXmom1sD1Y5FqZrmWSVzsxV2pDrTNjZbdj25PGiPe/KEvvwXIArr96qIVoVa94qPgZP+G7vTKYwSwqyvwIb78CC78uUS2Ex7SJMD3t83QMo/KSCnUuZYR2StSqg7LJiyfI2BzN5cT4wfPJ0w3+E8pZB/H8jqJ2jZhL3COhxKFfls+8UzglHpHR229h0E50WISpxQCTNUPmJiOu58kfEmQkK8SUezfToUb2cfsh62Q6yrukbVAwKzoiM/gHh7bb/ZjLA2vrjazGVxfi80K4L2/LcVs64Bhnf4h1KYQlWjgtYLgNaGk5DKbGg67YVCm6aNgH8RfrPKmPNFfIlEMr+Sb1JAy6AJnlmn1thpd9gHIrWyqEKjMlae+Nnec2sm/xn6dMJFkT0O5G5heySvRJwnzaiYF8lZMqBsTQnatVsjYPPpo1CNjBN5vhW73Nx+fFEUsqctqDJidmUA/B2JJUDgSkjcl/PHHA/onHixq0lrzjSei2dgB39kBkX07zNWtyCsUG8Hwmoe9f4BVtpvOYbfQM6W1crn
 Kv5Cj8VV
 QofIMvawl/YmIuZYwkjsjlhqdzd7I7Z4xJZmg7xKZcAQf/hVUpty0RQJyDhedit4AbGETfbYyZo7r2o2uNIzeAzvJWNL1bI9fWUTlSXytkJ0RHB9VAYTFRLUmZaOS3IPFi/ID5d0xjXMNV0VbJk25bCQwCMan9oh/BM0ITyt0vqRO9QttkqBqOju1u744a7P5Bft+vdhOuE7sN/P1DkKGLIvvl9SMDTp9ifO/9JQJetGXOWf101Ygm+8yVzlnYDDdtzPPFGVcfmKoRKdFczX7lOB5n19G00A8Uvd0FlXWITw1rdHvx+0OXkb6c+lId7zEyiMUiq+9TV3Y77AKjPjO5EskavsuDZoqGCzdadLqr/b0n9+SSozou4sgv1nfoq2ApiP0VApDX+ftyUnl5V9m/ObUK63URacIZrJiJejbG9G7Lkr7/mPS77MDmxcm1YjLmCTxL9dWIvl/ZdMSQEXG4uc7tQ8gUoglIVL66A0vSs6gOfnai4/nKC/GhmxLlzMKgbLM7v5xxdtosmuG1LlRxtFoQ/Un+KSf+baLo0FSO9SfzDAyNpztF7wYtnoLUor7X/0t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 22:05:16 +0000 Bing Jiao <bingjiao@google.com> wrote:

> On Mon, Feb 23, 2026 at 02:38:29PM -0800, Joshua Hahn wrote:
> > @@ -4485,15 +4527,22 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  		return err;
> >
> >  	page_counter_set_high(&memcg->memory, high);
> > +	toptier_high = page_counter_toptier_high(&memcg->memory);
> >
> >  	if (of->file->f_flags & O_NONBLOCK)
> >  		goto out;
> >
> >  	for (;;) {
> >  		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > +		unsigned long toptier_pages = mem_cgroup_toptier_usage(memcg);
> >  		unsigned long reclaimed;
> > +		unsigned long to_free;
> > +		nodemask_t toptier_nodes, *reclaim_nodes;
> > +		bool mem_high_ok = nr_pages <= high;
> > +		bool toptier_high_ok = !(tier_aware_memcg_limits &&
> > +					 toptier_pages > toptier_high);
> >
> > -		if (nr_pages <= high)
> > +		if (mem_high_ok && toptier_high_ok)
> >  			break;
> >
> >  		if (signal_pending(current))
> > @@ -4505,8 +4554,17 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  			continue;
> >  		}
> >
> > -		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
> > +		mt_get_toptier_nodemask(&toptier_nodes, NULL);
> > +		if (mem_high_ok && !toptier_high_ok) {
> > +			reclaim_nodes = &toptier_nodes;
> > +			to_free = toptier_pages - toptier_high;
> > +		} else {
> > +			reclaim_nodes = NULL;
> > +			to_free = nr_pages - high;
> > +		}
> > +		reclaimed = try_to_free_mem_cgroup_pages(memcg, to_free,
> > +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +					NULL, reclaim_nodes);
> >
> >  		if (!reclaimed && !nr_retries--)
> >  			break;
> 
> Hi Joshua, thanks for the patch.

Hello Bing!

I hope you are doing well, thank you for reviewing my patch : -)

> I have a concern regarding the system behavior when both the total
> memory.high limit and the new toptier_high limit are breached.
> 
> If both mem_high_ok and toptier_high are false, memory_high_write()
> invokes try_to_free_mem_cgroup_pages() with reclaim_nodes set to NULL
> to target all nodes. Under these conditions, the reclaimer might attempt
> to satisfy the target bytes by demoting pages from the top-tier to lower
> tiers. While this fulfills the toptier_high requirement, it fails to
> reduce the total memory charge for the cgroup because the counter tracks
> the sum across all tiers. Consequently, since the total memory usage
> remains unchanged, the reclaimer will likely become trapped in the loop
> until it reaches MAX_RECLAIM_RETRIES and other situations (e.g.,
> both !reclaimed && !nr_retries–), leading to excessive CPU consumption
> without successfully bringing the cgroup below its total memory limit,
> or causing all top-tier pages demoted to far-tier, or causing premature
> OOM kills.

I agree with everything you mentioned above. However, I would like to note
that my series preserves the default behavior for when memory.high
is breached (since toptier_high is always <= memory.high), so
memory_high_write() would previously have this behavior as well where
shrink_folio_list would prefer to demote as opposed to swapping and
lead to the infinite loop.

In that sense I think that it might make sense to introduce a fix for this
that is orthogonal to this series. AFAICT I don't think this is introducing
any new harmful behaviors.

> Given your tier-aware memcg limits, I think it is better to reclaim from
> lower tiers to swap to satisfy mem_high_ok by setting the allowed nodemask
> to far-tier nodes. Then demote pages from top tiers to ensure
> toptier_high is okay. This also prevents reclaiming pages directly from
> top tiers to swap and ensures that demotion actually contributes to
> reaching the targeted memory state without unnecessary performance
> penalties.

If I understand this correctly, this would mean that each loop would:
1. swap out low tier
2. demote top tier

And repeat this cycle until we meet the memory.high limit?

I think this makes sense. I will note that once again I think that this
change is orthogonal to this series, as it deals with the memory.high
violation case and not the toptier violation case. Note that if only
toptier limit is violated, demotion from the toptier does make sense,
since in this case it will shrink the metric we care about.

> To address the issue where a memcg exceeds its total limit and demotion
> cannot help to relief the memory memcg pressure, I am considering to
> introduce a reclaim_options setting that prevents page demotion by
> setting sc.no_demote = 1. I have a local patch for this and am preparing
> it for submission.

I think this makes sense. Please do CC me in the patch if/when you do
send it upstream!

> Please let me know if I have misunderstood any part of your
> implementation or if you see any issues with this proposed adjustment.

I think you understood my patch completely as I intended : -)
From my POV though, I just felt that the issues you mentioned actually have
to do with the standard memory reclaim infrastructure, and not necessarily
with the toptier high semantics.

And please let me know if you feel that I have not represented your
perspective as well! I hope you have a great day!!
Joshua

