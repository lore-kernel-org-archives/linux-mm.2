Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DC6CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE316B0088; Tue, 23 Jun 2026 14:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F4E6B008A; Tue, 23 Jun 2026 14:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6282C6B008C; Tue, 23 Jun 2026 14:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 370A66B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:18:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B82FB1A05E7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:18:22 +0000 (UTC)
X-FDA: 84911987244.29.8859838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2208BC0018
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:18:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782238693;
	b=kJyUrovXDCkTslQAw48TSbC5KDLlt7378mhEuLb9KYMGGMZRjSaR+o0EWnXvx+hFk2Va0c
	/F3OpyPPMtH306Ssrj1RE3KmFTxuvhsL+DlQfafLH9vX3yur7MB1ZZ1dCQwH91IzIa2sDn
	q63QhhZeHjYu9Xrbxjs58cei/VDB5rw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782238693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGo7jsa0z5bGAjnw8+UYFQWCBJbRAWPtpG1kEYRil0Y=;
	b=Af/8eWp2DDj64F0cL8UiXX1G3EoKbsRxaFJn6HvAHlbXlqqqBJC0zw4wtFeDvCwSHBFhS2
	PdPccJTZ/eS6igPX7kM4Ft1qXQDhE38NpyHhw7IoofcVv2TP1WKGU01Q96Hkwu6aprnp0P
	H3zkpjbKGfyUsCAtKoV06PvQiM3BTbU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cswXgtWY;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44A11444B1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B4E1F00ADF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782238692;
	bh=HGo7jsa0z5bGAjnw8+UYFQWCBJbRAWPtpG1kEYRil0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cswXgtWY0xG6YvKTRPM32z+O3mxYc3CAiwmLGtv/6mJyGgXtGV8sKegeFOWXOrR7H
	 Mt8CgyrUiha2MBWMnHiYRNh6PW6jpd7OK3unt/mAy2wWsq3V+PxL4V2thvztVCB0VX
	 gJJE//oVk7nXdB8Het/6fNwkqNfdD97Y/Co+OPuZ0NNEveij2hOzJbML4ZruZirQBM
	 7gdCkasqiJfzXhePaEEorhtZMijTPNFMmVrI9uKyATbeVslN2MnJfqaeoyoJ+qVyKo
	 4xEW1rycCV/1eLJEvyTgJIX5YoEJfHgwjqmDjyAhY+aBBGwmNMx9Uzn1SP04we0Fy8
	 iK66FCyiatALQ==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-697df404e32so209917a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:18:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+jsfSRlw49AVxnQcTsCyAfmy5zQYvRzoSYsQl43ux0T25V+HKEYd82cUvGWuJ4G3UQJ3tgG2KT8A==@kvack.org
X-Gm-Message-State: AOJu0YxvT54jmaUs9mEY0bLeG2XD3ccdmOrXBQil6+2L82DVfudxsNBW
	Ivngv+7z4GJC7RLvctSHI/Fp+0LdWCQPo/EAsQpY+hyJKWDuDzamo3XeNwHe3y9ixGi3mwCOAf3
	RgLkG5ZWfX5yVRtLuhBezUqMCwF9VBJM=
X-Received: by 2002:a17:907:9628:b0:c0f:d987:444f with SMTP id
 a640c23a62f3a-c108ecf8d57mr247144966b.28.1782238691095; Tue, 23 Jun 2026
 11:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-2-jiahao.kernel@gmail.com> <ajnB8IZrFZwbIr9P@google.com>
 <d0f05c35-457a-4b2c-6faa-7a83d4bdec01@gmail.com>
In-Reply-To: <d0f05c35-457a-4b2c-6faa-7a83d4bdec01@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 23 Jun 2026 11:17:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMgaqP=n6rmhnMU+qhp1Www1Y5kdbLTLX1v=fj_ybHyiw@mail.gmail.com>
X-Gm-Features: AVVi8CeWbi9xozE3IgWvakuBVZiX3iyiSg_u18BJ2jTIomReldLs6eE9A54a5PI
Message-ID: <CAO9r8zMgaqP=n6rmhnMU+qhp1Www1Y5kdbLTLX1v=fj_ybHyiw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback capability
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782238692-383326
X-HE-Meta: U2FsdGVkX184NDMSUnenNYyQ1CIi3v2nqT37T7fonV2gLuG9vbnYAowHXQKXbs847473A09FHRukok4dy05uiyt0MWmrc4qhOh2khKRekhaT2M15AEJdGf0m2uFGACRGL6Zr42uH1YdU3cb4J0TmzkGrLbZQDXChCKRhTEKBhVNCuggpdWwFogzXoZV483TlaeUCnRfEk0Hrt3K5+WjNQFhn5nlovyCdQ/ww5byy8297JQqk9hRf6gtRWIseEUnV7l6zTNfcvU0LDWymK8p7CcbFgXlWqvSfpbZcIkNC45Llv6MvbQ33cKxCiUdo6kOXAxXP915ncfhP8y5EouGojCkylma2XAKepJynltmzRFftZLdnouh31Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> My initial thought was that if cold memory is evenly distributed across
> nodes and we are doing a large writeback, it would be better to balance
> the zswap entry writeback across all nodes rather than just draining
> node 0 first. However, since we currently lack a proper metric to
> represent hot/cold memory (such as age-based tracking), doing this
> probably doesn't make much sense right now.

Yeah let's start simple and go from there.

>
> So, perhaps we want something like this? Please correct me if I'm wrong.
>
> static long shrink_memcg(struct mem_cgroup *memcg,
>         unsigned long nr_to_scan)
> {
>    struct zswap_shrink_walk_arg walk_arg = {
>      .bytes_written = 0,
>      .encountered_page_in_swapcache = false,
>    };
>    unsigned long nr_remaining = nr_to_scan;
>    bool memcg_list_is_empty = true;
>    int nid;
>
>    if (!mem_cgroup_zswap_writeback_enabled(memcg))
>      return -ENOENT;
>
>    if (memcg && !mem_cgroup_online(memcg))
>      return -ENOENT;
>
>    for_each_node_state(nid, N_NORMAL_MEMORY) {
>      unsigned long nr_to_walk;
>
>      /*
>       * Cap the per-node scan by the current LRU length. A referenced
>       * entry is only rotated to the tail (second chance) and may be
>       * revisited within a single walk; without this cap those rotated
>       * entries could drain the shared scan budget on one node.
>       */

The comment here is a bit misleading. It's not just about draining one
node. One call to shrink_memcg() should only scan entries once. The
caller can then choose to scan the memcg again, or scan a different
one. In this case, the caller should iterate all memcgs first before
retrying memcgs again and reclaiming rotated entries.

>      nr_to_walk = min(nr_remaining,
>           list_lru_count_one(&zswap_list_lru, nid, memcg));
>      if (!nr_to_walk)
>        continue;
>      memcg_list_is_empty = false;
>
>      nr_remaining -= nr_to_walk;
>      list_lru_walk_one(&zswap_list_lru, nid, memcg,
>            &shrink_memcg_cb, &walk_arg, &nr_to_walk);
>      /* Return the unused share of the budget to the pool. */
>      nr_remaining += nr_to_walk;
>
>      /* Bail out once the whole scan budget has been spent. */

The comment is unnecessary.

>      if (!nr_remaining)
>        break;
>
>      cond_resched();

Did you observe a problem here or did you just add this due to an
abundance of caution?

>    }
>
>    if (memcg_list_is_empty)

Do we need memcg_list_is_empty? Can we just check if nr_remaining
matches nr_to_scan?

>      return -ENOENT;
>
>    return walk_arg.bytes_written;
> }
>
> Thanks,
> Hao

