Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C98C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 19:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90966B007B; Thu, 30 Jul 2026 15:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40E86B0092; Thu, 30 Jul 2026 15:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A578E6B0093; Thu, 30 Jul 2026 15:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 735B06B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:01:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22096C0273
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:01:40 +0000 (UTC)
X-FDA: 85046361960.27.B9318AF
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD59A40008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:01:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rxD3meFF;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785438098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1yOof5RfumCoH1r75oUvzt/UONr8poJqHsdkRardoM=;
	b=JxEsmC+oN+i+suEtLPDIgp7MAo/14gZON97ghEDPqzI2du+uyhgtWTSpAkxtRKPqEtno6Z
	xCmWbPA1ArmnPPNeOcxqwNSg8+qkrSyj5j4F6EEcMi+c6czjLU4/7z3pyW5Uue1H66iA3K
	8yobvfUlj9c1iG/5wqvjcPnoVhwAJtY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rxD3meFF;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785438098;
	b=m1NfWOYNsNqdpMiypSbmT7eNl9Zmglb4irUr7toj7mC+G+y8lQxbvmya6o+UVuWIL5adlJ
	vAzpeCAZN83KeLBkGbNHuRhKmRYmAO97cANEvdwzSFMXWCpP9tMEi1hKFufh3B3QKXildG
	1I1/ztfUKzumxVEYTzMA0JxUbA28nV4=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e6c4a867cso16351885a.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785438096; x=1786042896; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n1yOof5RfumCoH1r75oUvzt/UONr8poJqHsdkRardoM=;
        b=rxD3meFFMi4WQE35GQES6iele+RO634ksLFFmxzu24yHY2HCjKUKrMfA2SiLm0LhHD
         EXvhYh5bKGKT0wOqjQdlsRvM3t4LGg53pTM2G4/i/j0VxaruffqEGHarLOPTnEnhTKyg
         6onDPMLdJbgjtYr/HscmH1fefPHS2yu7VjPFyETzNzjdiDVNblWPkr7ePgfym8be+uOz
         1ZJqzF8AJZC55CiBm8aREqIZVZbb2ILPLvq3lUWeEbHLy4kxlX3dZ1WcRbeOGDSupME7
         ODc4AiBMB1bAjCd+Kh4JL0UPTgn8FyLgVVgRsSGUoiQL7xCXSvoLlq+/QzNGmttO99J+
         +Zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785438096; x=1786042896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=n1yOof5RfumCoH1r75oUvzt/UONr8poJqHsdkRardoM=;
        b=ZlLKg7Y12LOp++Tj6G4BS79MGNY8aUNZoDM8i5za/JdS3WZdu3M1QYUZfZa3eotsv8
         Lj0cau3XbcZXZxBXuXozJX3okXgzCAEmqWhlYLUf6ubpqX5AaaDjix3D1Czjy1KN4gYX
         Q1tXIeKohkOIleQjWY1OhM1YblnDW4DANFfLAQ5xYnH0fhHZufaxgRycqmqYn1pwgsoH
         3SXwhaaBUfBM9VQJqv7gbStGdOBjBCpdCciy9n9ZX5xd/x6Ae6QfQ8cuAemTMRqjE0i1
         av15dahsi2Fn4rgfxJXgBldo21ksNzkHgsGkN7DMI0A64G8PLqWQmcYBD80+nU53iLC/
         e92Q==
X-Forwarded-Encrypted: i=1; AHgh+RpIGKJ4zoj6XUlCGpbuGvcAGbdoymsn0qNgLZ00LL0q5jO2387+RJXB1oPZCnm2xTE6zhGGhl2sTg==@kvack.org
X-Gm-Message-State: AOJu0Yx9WQDIPEsWyEzyubQOt0bOSOGcTuJtmND/V9tgp8RTQ21OSc+G
	AOUSjMDL1smo6l2z24Z3JHQBs+z9AcTG3zX1qHXFAfqzTikjOmhwITtx6uthdo56nAU=
X-Gm-Gg: AR+sD10OZAQUgua8UnoFI/bmFaF1ASjnJy4o8nUF8DJPJLnp6FW017ty5W09r9kOadw
	5COPLaozeJ7rcetliMVyfdF5vapz64BHpyCSvupzL/AHneioPa6JXHcubtPaQFXF6cLDhctAbOV
	NZxPICRAn5FXIlQIY0kYuLDHggHRHQijwCOLwbdGPb+0ODSyJS7tnBFptWrxOhPLRXabnE/s4QD
	4QDtFfMycM+DGAWir3OeFyqsL2Rg9AopctFmPkug2EUcGcLSCyljzknrqNnDDduXyPrvDPR50hF
	tcI5Xjr9Hu63TRgY16tUajnKlJbCR0bETVlIvFgyG4OjbRH+gRMOF+d5fmTGyJ4I58jIP/tu7A5
	lYuBQoGg3DPnzbkBPQYOeXWrQmiy5Ge0196MxKUzqjsL2Rjge6ETDb6Ld0XRqVAfxgyi8rl7mK2
	pU4/5ocRL9pMxJe12qv/ribxVnWzYJnJCuSaRvFCsn641GynFe1JE+FQGhRw4=
X-Received: by 2002:a05:620a:460a:b0:932:dd83:c54 with SMTP id af79cd13be357-93485ff2ecemr442630085a.42.1785438095030;
        Thu, 30 Jul 2026 12:01:35 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e712fc05sm475477685a.29.2026.07.30.12.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 12:01:33 -0700 (PDT)
Date: Thu, 30 Jul 2026 15:01:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
Message-ID: <amufiuAaZbuDdKkQ@cmpxchg.org>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com>
 <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
 <c4c95102-72e2-a44f-f16e-4134ba6bb060@gmail.com>
 <CAO9r8zOSTYC3D_2CxapgvXGaZRUdnGetPGz2XgdUO8OygfuEiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zOSTYC3D_2CxapgvXGaZRUdnGetPGz2XgdUO8OygfuEiw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AD59A40008
X-Rspamd-Server: rspam01
X-Stat-Signature: pmtkuzu65fkrms6ckc45ectjo33ife4k
X-HE-Tag: 1785438097-937206
X-HE-Meta: U2FsdGVkX19XCebGtL7khABd1SpHItGBsRggP1zEcyPcAiYGhbfNKZJjAVM0OvfEjLBTxZdv4b0vfg0coO36sMTGnHqQQYcw92tC8fGefIJKWgNccGtE0U2ZRXetfU2tmmZm8aD6fluwAZBC51vVcISd2mhnW4INKfAZyMS4Vb1YBFcF4ZGsTVJ8of0cyDDyVDopBIjQlidEn3HiBCOI2Yz5fEAH4/T8Un9Tz/9PRh0C0q0RVdPlmngqlW1TKuo9/Niqn5jno5bn8psWBl99uecFL/1J75Chib0c9HfUk9lXd5lQafluZVHQuowHiKC2fpNYHFkKkcNwqoNVo8WgIDWBV2G2zU9IcFVbulq1ChA24NDVDXQI7ImawvSFo9UQo5mkmr8pJeCdMVRXN9n88Z+eU52wHzsbk91agDY/2h0e5gBLJP5BhR5DJ6ibh6BrLmFAQe3L4lqZPEDSyHM5oE+0qPcBD0bypCAVCu9Nv/zDgFdispCZpVXepfwSsHJTvJi3yZJNIAAu0yHRxOL+GAQ2+1FOZBtYXimx2xSWVUf2I4c+JlO7GLXi8sDztmXjKCY+9t5iXxUG86JyKE5wOWQswebQQuTZrs0/IouYir4QA81fnIUJViggRaalCbQ2puqT6105NeuqzRpt4XnbXiPWjUYDKOYcEZuPr0E5CXgUyn0RD4p+5SFxBb1ZxzLnNJ3S2jSszJhOsTyqC1lc8OFiUomswTq24OUvC5jJMH6+1Dbvx3MbE8d7vxJtjRZV0ZorZygGbymQZiNzqt58cpDVy2pQa8Z0A9TtsVGDcf/+859o7alHYrWEXhMZhFaolO8IZjBbn/sGGCEeeBg2XoqLalDmirgQy+UN1lN6v1bDVorAx5KadvqcDtuMcBWOem87ujYbMWXmw1jBoRrNSTcwwbKTV0AONkLQyj6Owimtkgs2q9boc5SdGGzoZiaFaznJMkaG7NVKff9+08f
 QGc2pep5
 HEbcyjgmBccpv8Yb+WYNRdKai3uPMQlz8PNctH2Thlfnrl7ix90R16gmCfUjT6C0/8j0bjmI3mNRLdiSXOJT02LOlY/57qLMLw9uSY/WqQ/LOV/rcI2iKa5ofbkLBooDprTFQm6ejTCgL5o02zB9P9ys+T2z7ZTfxlvnZgXMpGvqWqI8TERK9e+vwJG1Kp7CHKJUyM4dzUBc2oQboAZJJ/EWk6XpNtdiyfqChXcVDSziKgNSNH1WPA37KvFTt48W0c581+j+KQ9AEGfExwRpcRvwn/T/FW7GpkKQzssyD7WwpkCz/MLJZeXW5iGASqPQNQazoONIEC8zjzRwPxWaJhj2PDpMa91TiQO6X3Ffpo3AP44P9b/LOxo0uEuft7wKdmgmqMSGO1SNQRAUAQvvdXbeDZEnEN9hwZD5qU3I92NKZXAi8QHjoj6pMnw08KVuUnAc0y8w/qNZo5wtZ6QKeHZ25Jkc+0uY2jnD5AJv8Ujv9XNYPiueBhzr0RRR8cqyl+Xf+paW8wHMMMpY9cEGnyZLlNKPIdKmR2+ty6qwh0q7NwfpbaVboQjiooDiMyBS547dPkU0KlWUi1zuXG5wLJ+e3bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:48:38AM -0700, Yosry Ahmed wrote:
> > > Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
> > > it because checkpatch annoyingly complains if you add "Reported-by"
> > > without "Closes", so Hao just linked to the thread where I pointed out
> > > the bug.
> >
> > Yeah, checkpatch will complain if it's missing.
> 
> We often ignore checkpatch if it's unreasonable.
> 
> > >> AI review asked a couple of questions:
> > >>          https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.kernel@gmail.com
> > >
> > > The review on patch #1 is something theoretical, we discussed it at
> > > length in previous versions.
> > >
> > > For patch #2:
> > >
> > >> Does this batching logic break NUMA fairness?
> > >>
> > >> Because for_each_node_state() always starts from the lowest node
> > >> ID and breaks when the scan budget is exhausted, subsequent
> > >> calls to shrink_memcg() will restart at the lowest node ID again.
> > >>
> > >> If the lowest node (typically Node 0) consistently has enough
> > >> items to exhaust the scan budget, wouldn't we exclusively evict
> > >> pages from it while ignoring older pages on other nodes? Could
> > >> this cause LRU inversion across nodes, keeping older pages in
> > >> memory on Node 1 while hot pages on Node 0 are evicted?
> > >
> > > Yes, unfairness is possible.
> > >
> > > For global shrinking, it's probably not an issue. We reclaim until we
> > > hit the acceptance threshold and it's very unlikely this will happen
> > > before iterating all nodes (given that the batch size is 32 pages).
> > > However, with the shrink_memcg() path, we only reclaim one batch, so
> > > there's a chance we'll always reclaim it from node 0.
> > >
> > > Maybe we should just drop the early bailout and accept potentially
> > > doing more writeback than needed. Hao, WDYT?
> > >
> > If we scan and attempt to write back SWAP_CLUSTER_MAX zswap entries per
> > node, it might lead to excessive writeback on machines with many NUMA
> > nodes. Furthermore, I'm concerned about introducing higher latency in
> > synchronous shrink paths like zswap_store()—especially on systems with a
> > large number of NUMA nodes, where it could end up writing back hundreds
> > of pages in a single call.
> >
> > Maybe we could do something like this instead? That way, in the
> > worst-case scenario, it falls back to the baseline behavior without
> > introducing any extra latency risks.
> 
> This basically errs on the side of honouring the batch size
> (under-reclaim) instead of doing more writeback, right?
> 
> I think I prefer erring on the side of doing more writeback, as it
> would ultimately result in less LRU inversion, and we are already
> doing writeback proactively during reclaim through the shrinker.

Yes, LRU inversions are worse than reclaiming a few extra pages from
the cold tail of the LRU. It's not cumulative after all, it just means
we take a bigger bite and can take more stores before the next shrink.

> The other option we can explore is keeping the existing logic with the
> bailout, but start iterating the nodes at the folio's node in the
> zswap_store() path. Basically pass an nid to shrink_memcg() and always
> start there. This will avoid always reclaiming from node 0, and the
> node of the folio being stored is more likely to be under pressure and
> need the writeback. I am not sure how complex this would be and
> whether it's worth doing.
>
> Johannes, Nhats, any thoughts on this?

What happens if simply we do a hard SWAP_CLUSTER_MAX on each node?

With cgroups, we put the zswap entry on the list_lru head of the node
and memcg where the incoming page was.

So if you're going after one specific cgroup, it's not like you
*actually* reclaim 32 entries on each node of the system. You just
write back from nodes where that cgroup has entries.

The global shrinker also does one cgroup at a time (zswap_next_shrink)
before checking the limit again, so that's fairly fine-grained too.

Without cgroups, you could have zswap entries on all nodes. But if you
have so many nodes that this would constitute hundreds of pages,
presumably that's still a drop in the bucket compared to overall
memory capacity. SWAP_CLUSTER_MAX isn't that big a number.

So I don't think we need to get fancy. Just do SWAP_CLUSTER_MAX on
each node. Delete that nr_to_walk carry-over between them.

