Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BBEC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E126B00DF; Tue,  1 Sep 2026 12:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44FA6B00E5; Tue,  1 Sep 2026 12:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75D96B00E7; Tue,  1 Sep 2026 12:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C36E6B00DF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:47:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08D18A04E5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:47:50 +0000 (UTC)
X-FDA: 85165775100.05.15D3F73
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB97B40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:47:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Hi5JbF3Y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZG1Y/lCpTOfNL04ELiR/+tH7Q8YET/r11fYlIJBd10U=;
	b=aLj/4LXsmqy/4AiHhzY1VoZnCdjeI6Rnu9SYi1SRk+OVTwzIcJOBcV6ud2ZEDjCyu5pOXg
	JQD48zehszBTu6yC/0dP3eAk6EHH9JeOWbqCkNCpB9DmubJDNUYrZbWMeTccf9mFdiBMrK
	00vjapca3jcMJfN7gfdmBJ/3Y6cPGvU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Hi5JbF3Y;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281268;
	b=oPoNTgukF7ctXEWiPIkOmBNwsWGstLgd4yZiIkR3/5UKtESbhs/seXHJU51ecyMDCKH7Bx
	sDjhfyiQJTlVcqeMf37plNusew2McgAHZ4mIVGAjtmE87oilael1eJiyi0d0tSXusdHgN5
	AVHoQdytzEy+tKN6VAZxNm2sjlKF+SI=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-855c26cf490so2077267b3.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788281267; x=1788886067; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZG1Y/lCpTOfNL04ELiR/+tH7Q8YET/r11fYlIJBd10U=;
        b=Hi5JbF3YRSwExUCXxESz/H9Dpp7PZfAk8dU64KufR/9rw79dbzPB9o/9iMZyR1cs67
         N/2KqMx/Hedjqn5t7bQB7R8FJc1WXWpRgDxK82pqyDWvibgu8B4N1LwjlMxr0PN1qWbD
         VWcmEUo+qFBG5KPUWO/5rfc9vuUTKQN3cZ/tTaqjT3Ekte/uD1lvb685I/LNWBmns3Kx
         eCYBzhbtNugKZZza7P3tuhdo8HpV3tl2ZogAyiy1Ry8OHe58GUZb/MER5MGdDj24Gzte
         cNYOdA3fgwz5pyYzq9mpcnkX+rKgiBjYE7ALQTIldTT+qmu8YlThJUhcr4m9ABSR3ceb
         3d5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281267; x=1788886067;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZG1Y/lCpTOfNL04ELiR/+tH7Q8YET/r11fYlIJBd10U=;
        b=WxEmV+k/eeJkWu9py0MsTgREUf+KWXa5pye35kvgpNa1NyPl5Xa+RDu36FwE8bFAIJ
         aGvRzd5jKKZ8yMLqTDyO+f1MuZbB9C9K1pEJwccf3JrVpvXvY6F2qBJPJJThRybyr25I
         EqJNHVXwnySosDp6ZnLRs7KTdNICGd7VJ9Hw2AtlaJdoDKG8HZUOWfByamZJSUX+yHnf
         ciArqCaVQRJQNrQvfAWL98efzzHnQ4ztKPItqiSYLxa55Ln+0jfcPnEwD47/UBukoJs/
         jEi/Do2u1V7Ga8Xypdg75u0Q5ZGSl7Hp8DhVwuJZoKwSn7ThB3RS2cnKovWAEVJIeisT
         VSqA==
X-Forwarded-Encrypted: i=1; AKwUvBzWUsIVK+k2xrPPI0A6xugHr0tBTKOw0skDmcEBNfVbiHtWFVezq3nIqRaO0qtB7h4YrKD5rqxDew==@kvack.org
X-Gm-Message-State: AFuF++mTRpMe0ZhGhEjBgULGDfL0SO9EkyQbO8Twm4H6TJwZ95g24Rkv
	jpug5z8wUH4Fq46rD1G6h5xinaMADpr+dAkuQRQMjPbHUsORROB6C9wHBQnppCUbG6E=
X-Gm-Gg: AYBFou363iIxEZjFrtlufmG3GhvwrVnDg6RfCxJICHn+8oI2UCsXZnDGtlwlhedfACv
	ljDwmSlOfkd9+RfvupYLO0k7CcRr9o55hTXqPHdxm3+/gNQA8YW7mMQNdSGJJSX57IG7eHKWhQe
	j9sDlRaI5mCy1PbMUtXwKCuGYUx15PcoYXaUDpH0iMCqWgOmyEyCdy0UR2pgd4OgowxFrx/F0b9
	VHYJbJV5+qxSpjz58N5eANYNTum4uXIEQocys3ZUoFwmxnNQPgSCyZpL9UYIA/8usxrumhuZyLz
	41ByJhuLakWeo8iKfnNejE+yu8/bwz9PGZ9Bjp51JFgnzg8s9T1NxSzKWUTh4qooEtF/3Gubu6Z
	Hccx7F+cQ5eE2MGiQUxv4XOAecPbzKyzA0Wqnr0okExncXvAvwoFUXbhelwsvcDuTO+ld8glvZT
	dCVynBIRsxsced9nXKSE7ORNluEA6UDYVWxo4hlYNEGzwHUAhAY3XH7FfQjai4
X-Received: by 2002:a05:690c:f14:b0:81e:9826:942c with SMTP id 00721157ae682-85d625bd769mr138767767b3.0.1788281266714;
        Tue, 01 Sep 2026 09:47:46 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e65f146f8sm78197607b3.29.2026.09.01.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:47:45 -0700 (PDT)
Date: Tue, 1 Sep 2026 12:47:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: avoid charging the root memcg from
 obj_cgroup_charge_pages()
Message-ID: <20260901164741.GJ3004@cmpxchg.org>
References: <20260829023251.474083-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829023251.474083-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB97B40003
X-Stat-Signature: ibhcx8wny1ieoab77zirqhkyyqsmncxk
X-Rspam-User: 
X-HE-Tag: 1788281267-513033
X-HE-Meta: U2FsdGVkX1/dj+FpBaIMY8Bc9EJw8IbxRaW80Oj3EFSfDsrQjGWTicp0YcA50d0y2xZRnp+ljTIiVFCaPASXmlF/zjohmNUTLmvqq3RwjIjQ6purSvQwJ1edUVIVg50VL/xmFKoATSkv4CZGZvtiZRlrDCGjeQpcMMWM1/j9Ge5uPdlIlNdWbRuLO9je4SZ/xCOkcN+Yaj1JDUwiCs/vqeP7100HZGqFZH5DTxD1eIVMgtMxjATDNcpQ1r9hXBLPW04QKu68sgIwo/YN/JkkkxW73CMl3NT0rfSkML5L9EZNYLBPv/OM9oTdXqINpOffZwVh0W6s+PdbS5QM327fHOjJ4hF4AmWIde4/luEWfFZhJPKbvsbuH+oNF0DVbn1KxcmFtchNfzX3+n3U9mZFbnYaZbArF0/odC3kEh63lSy9XhBurTP6OGux6mhNoqz2cLKv46kG0pwsg6U5+/fAp3MA6KD/wlrskIK0gKX8/BDgyCF/a/9A0JyHRvdvzZVjY7wllwaw0lfOT2mEAllCEW83LmzE1HOhmuZeZRwOfs4jNcjBLDv3OUgKBGFJwXmaHC0t1a7N5oU0ScsZ4w5dlIIpp+7g1TaPXpGt1jqugcdVDPSG3xIj6w2HhSRZuENM1j7XdP8oE+0DKWBaPd6G+8mhecPEgvEm+nJ7Ik62pKbNQ2jt9LFDQc85ZRLOsHapdh4n4AuY+IzKENHQV0UxoJwn2dKqJlMxBEXf7H5tUbWoBSADk6Zo015AksdBBEQLG+x/4S65RTxF+Y9PIV016urXAws70kDGNtPHXKkRAE84wxNt4Z1l0GBdmgOEKheGHaVMPNTPRzoVQVehGfsQTM7FvTXpUazJgc0TtE56FGF6yfAnXTYmqaNkkJ7JeyMuAWlkrFxATvxr8lvqbhT8/v4OFOBExK48v6sykWpGuSS/RhU2w7nRop8ZV10QGzANQqd6MJWR5W9x+C0Op0q
 a0N9JoDI
 Cw2zFfKlle0bOBuNExcwUftcZKLpVZbu0l4lWuEKd0hawFh0/vqLIFmZdZqFxq8J2JotYRI4vQXLYmlZ+KEfKxEqAKE3+yDToJRnDfurb6oEVYNZpLgO+eNFdzYGSWvGmund6z/qXzfoou2BpLEaNsiTnaC4kRKgqs3YtnEoMLk/SN5bqae3Hj6LDi2yfSJOVcjIdcfyk8q628nYG8i5tECKCkzsAyv9sB7hP59ig7dGCaEcXMygIw570tHprmLXjqxDj87LvmGeEn0ioIFTWJEz8ISWISfJ3OxbMl1EMlnKbPlsf4kR7BK1TMG409q/Piothg10cOo3zInDs6kFcCWUvL2yxgi34JzMJ3IqPQPVGiJcvLOIwSdLMwTr3/vES0w4KmYgtakNsosu8L2FL/e0toLVh40494D46pVbZslspw526ATWpudSc52fcMkJHyF02RHnKOgfkQNtBoQtvLVknykHhUJet9YCjCsQPe2PBN2VqYA74AnnwEqP+D8MiL4ExVt0RKR5Xpq46J/OR568vWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 07:32:51PM -0700, Shakeel Butt wrote:
> obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> try_charge_memcg(), which does not short circuit the root memcg.  That
> memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
> objcg was created for and is never updated, while memcg_reparent_objcgs()
> does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
> child of root therefore passes every obj_cgroup_is_root() filter but
> resolves to the root memcg.
> 
> Folios keep the objcg they were charged with, so this is easy to reach
> through zswap: allocate anon memory in a cgroup, move the task out,
> remove the cgroup, then write to the root cgroup's memory.reclaim.  The
> reclaimed folios are charged through the reparented objcg and end up in
> refill_stock() with the root memcg:
> 
>   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
>    refill_stock+0x644/0x940
>    try_charge_memcg+0x12d6/0x1570
>    __obj_cgroup_charge+0x35/0xf0
>    obj_cgroup_charge+0x1de/0x210
>    obj_cgroup_charge_zswap+0x83/0x270
>    zswap_store+0x1620/0x2000
>    swap_writeout+0x94c/0x14c0
>    shrink_folio_list+0x3388/0x52b0
>    [...]
>    try_to_free_mem_cgroup_pages+0x30d/0x830
>    user_proactive_reclaim+0x504/0x840
>    memory_reclaim+0x1f/0x30
> 
> Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
> skips refill_stock() for the root memcg, so the root's page counter grows
> and is never uncharged.  It is not user visible, since memory.current is
> not exposed on the root, but it is a leak.
> 
> Use try_charge(), which returns early for the root memcg, restoring the
> symmetry with obj_cgroup_uncharge_pages().
> 
> The above sequence was scripted into a standalone reproducer (zswap on,
> swap on a virtio disk, 512MB of anon memory faulted in inside a child of
> the root cgroup, the task then migrated to the root cgroup, the child
> removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
> root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
> first zswap store of a reparented folio, with the same call chain as the
> report.  With this patch applied the splat is gone while the zswap store
> count over the run is unchanged, so the same path is still exercised.
> cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> failures.
> 
> Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

