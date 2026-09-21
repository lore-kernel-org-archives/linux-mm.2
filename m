Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F170EC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB506B0099; Mon, 21 Sep 2026 15:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C576B009B; Mon, 21 Sep 2026 15:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3836B009D; Mon, 21 Sep 2026 15:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85A396B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:45:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 116B8C02B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:45:41 +0000 (UTC)
X-FDA: 85238799282.10.320AE7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4ACEC1A000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:45:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vGeqROWP;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vGeqROWP;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790019939;
	b=qQ0K7tnGppF7Zt2w2QsVd6CURWXOcI6sC4+EOkyTBXrLgGVOJ3f5r3zdP75qYN0U9AvQ9k
	LCyiMn58ng6T003lZMDag3ovxWk3J3Pdj0H0kps3DGPKykz3y7f3otZYzr0E+p3xujqyw6
	Bil6UlpAq7oTc1a2E9wTQbSEZya0KtE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790019939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmdfqmBH4jrhaxwTCYSeFkpBAeDxBk63Act7QDZ3RcA=;
	b=jciINWjF7PaCYTkY3UYZvbcEwzf4bexDGB1t33YY4ND31ccum56sYEuBbQ1MFCHU99v+OU
	WEZRFIntIByc028UHLoS0COyDkl+eLvk0S5oHsP4IVpj3iW6MByrQlv4qz4bLowL6xx9m4
	YHhlpTq0ashmW7glE0ClhwGzgvdZ1QM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A2AB60008;
	Mon, 21 Sep 2026 19:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450941F000FF;
	Mon, 21 Sep 2026 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019938;
	bh=VmdfqmBH4jrhaxwTCYSeFkpBAeDxBk63Act7QDZ3RcA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vGeqROWPC+MoRonoRVJLURAv4yAo8Fhxj7II7mEW8uh5O2dmMGBK1DkNsf3qD1iYP
	 F0t2Nh9vLrlUE39++lWcI0DY/IMFfOT8G7kyPI3ZjX5X0FyMvGJa95n08kCprxcZof
	 Vkoi1X4y8Q2RfEB2jsGN29k+a9T5AOyE4L5tr7Rc=
Date: Mon, 21 Sep 2026 12:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Qi
 Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu
 <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, Kunwu Chan
 <kunwu.chan@gmail.com>, Tal Zussman <tz2294@columbia.edu>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] mm: zswap: free cold writeback folios promptly
Message-Id: <20260921124536.7a1857853ad7629f061a106b@linux-foundation.org>
In-Reply-To: <20260921151306.625134-1-alex@ghiti.fr>
References: <20260921151306.625134-1-alex@ghiti.fr>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ACEC1A000B
X-Stat-Signature: kygmqi4tc3gxgyj5ozk3xrapf6kz7mkc
X-Rspamd-Server: rspam01
X-HE-Tag: 1790019939-922013
X-HE-Meta: U2FsdGVkX19YVkW6csq/0TZ2LfMjNjiS7pdpCFgt6S+Wi/3jB8a6ocucPTaxeMETuFVQjsXiwN6vusJlhTOHr4TOABg9Zk9N/TRRQXFtKhp72FBnGPZVaxdqOUQ7M/2OUQIpWj+chWnz2kbtkDiMvOkwBs7iXlq9aUh+7FqriRs/zzVI5UCIPPnB4KGQbsRj2T/Tv+4PqsmfH1354ivzXQ3bERDtVK1y55MA6mmo6C9xVZoTQxmhs207OYRwk9/TY1ObPqRvKTtvofP8i/upbyUJjUBCF03l1oxCMOUcitPF9nGL7LBag1efIn8QpjSzJIWz0RSZlgYlSmA5tvjPqtfot8C5IWLus6CUUk7PI1g6G6GCl78b9vmdPHp/ZwndLDyKJQL60KG/z2MrEQi0YrL09nJnHc3GiJE9pKNHjr/RfOxpgo4MwnDNUnys9N9kJM3iwR1aAuq781fIa/ba5HZKTiMGCbaQ5PtrTNFP5+34Z0F/G8jOU2ekeOi+auFIZWY6tceNa8bkXp24CkJq4HmKCunr7SQmcdaogxqUMILtJLQc99txytXeCSh5tnddHUIX4LkiRT6r9w8iiDtYjHBGwDzBr9sdl0g4UIqjxMUWSdId5y/roUKkYymeA1lH4mlHfuIYDb1EAoTLKu8BZosfrP3xnIX+0HkXzqwe6ef4cj6VryyNGi9z8uCVaKOv+iuMmH2BFAbBC/hYo4RRh+eQmqYfkbFMbsRm+dq3ChpVwFhkNwFmE7zXcz/kjMZyJ3FKYTMB1bfhGkSvWFNSZ+cOCqUVdFbRabTTJqJhasrZhsq0+EhvD57b1yQ7j2/fBMmH9HblCF+6pPEeR8zaCqUbC2x3M2WlV2j5pAGFb6XLvnImT/QB5XtU+I05jS+JPE9zRjl+PYNArCXXwezew2v4tpJdIEDSFJnrBFbCES//aIMuHEvE7sZ5d5+eKaWARhOnp6FLr7ECVbDfB4o
 giAlA6Ni
 jmuajtqX6v0R6h6P0erRh+iZLPt6+MDtC8xRRcyevb1LbqsvbdXk1zx6YU/rQdWZBqmyydY+/HT9BEknmX//khT2kKJpxjtF3R14/rpgQHIeDUbttPWlsDvkwx/DNrEK1XJvCxBmeaPl5LYEH+q5q7yRYat10XzSO2BANoIq3B44e/EjR/koXam8dcPO9MDUJS0dZsbeOKmFiS4kpl+UkDmFryYRtjbMXHMZaShRcVRho9vvDHoAu01VZcpP252DNudlT6ksovXbcnH1J4KASlXvWACFsfJ2Kx880q2WhgzHmCqEpkF2Ujxq0BUn2MQkEpo1gyGZNCMzjQ38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 17:13:01 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> When zswap writes an entry back, it allocates an order-0 swap cache folio,
> decompresses into it, and issues the write. The folio is cold by
> construction, yet today it is left on the LRU for page reclaim to find and
> free later. That wastes a reclaim scan and keeps cold memory resident
> longer than necessary.
> 
> Rather than implement this in zswap, extend the existing dropbehind
> mechanism to swap cache folios and have zswap opt into it (Yosry). A
> PG_dropbehind folio is already dropped from its cache once writeback
> completes instead of being left for reclaim; for a swap cache folio that
> "drop" is removing it from the swap cache.

Thanks, I updated mm.git's mm-unstable branch to this version.

> Changes in v6:
> - No functional change: this version only updates changelogs and collects
>   tags.

Confirmed.

> - Patch 1: fix the changelog. The first paragraph describes the behaviour
>   before the patch, so it must name swap_cache_alloc_folio(), not the
>   __swap_cache_alloc_folio() this patch introduces, and the last paragraph
>   now says the helper is renamed as well as that the LRU insertion is
>   deferred (Kairui).
> - Patch 2: fix the changelog. The swap cluster lock is a spinlock taken
>   with interrupts disabled and does not sleep; the folio lock is what the
>   drop blocks on, and that is why the completion needs task context. Also
>   spell out why it blocks instead of using folio_trylock() (Barry).
> - Collect Reviewed-by tags. Thanks to Kairui, Barry and Nhat for the
>   reviews! Kairui's tag on patch 1 was given on the posting of the zswap
>   writeback refault series [1], which carries the same patch.


