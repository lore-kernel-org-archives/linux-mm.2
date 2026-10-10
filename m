Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770B7CA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 23:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B616B008C; Sat, 10 Oct 2026 19:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCFB6B0092; Sat, 10 Oct 2026 19:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2856B0095; Sat, 10 Oct 2026 19:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4F26B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:16:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8261740689
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:16:26 +0000 (UTC)
X-FDA: 85308277572.23.2B4FE48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C899FC0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:16:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VBlNlNSM;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791674184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4FKaZsTFL7dv9xDZsglaUZE3yjODs2W8eaIAJRxFvA=;
	b=PEo+5uYp5PDPke9bKTe3fnS1IjSLL7a4YYh0LLY6SSyNVT28u0QfGYrBviIGvKGAGno9I5
	kH4Vun7pjHi8AjtlmmqGYIzhEKZdICpPReX7itvM/For16EQxmc+I+ogKN8ukJi0e3rtwI
	v29ND96jhZpRNwn/niy/bnSn/uKrgO4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VBlNlNSM;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791674184;
	b=DAH7rod6ktRTQuPTbQlDJrmLxGM/gZI8E3TGZz/BM5GIrNNh6qFy3PgVXY1Pbyni3JRL4w
	+HfTzbK2/zygwc7kQL3JgjyBaqm0aFCy6z58nKDb6GNxpE4dGD8bUssbR0dfcDDWuNL8+k
	KW5qdmDZV6T5LjPyu7vSxGmKGxBk6pE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94AC7600E2;
	Sat, 10 Oct 2026 23:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29C71F000FF;
	Sat, 10 Oct 2026 23:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791674183;
	bh=b4FKaZsTFL7dv9xDZsglaUZE3yjODs2W8eaIAJRxFvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VBlNlNSMcmKRYn4t1jPWAfBrC/8zjJ3zbhiE1wLyOjGqOJ/WpGbdzTYCKsiKF4Xch
	 UnSDcj0Zrh8qc6LGV5MfUpz7otcaGLf25ZcRG1o/xrT6rbSgeczK9mVMThZvNpih0n
	 Dqiu+Hc00Oi80ajYya/KB2ywNbGDOP9GZ42lBy40=
Date: Sat, 10 Oct 2026 16:16:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Qi Zheng" <zhengqi.arch@bytedance.com>
Cc: "kernel test robot" <yi1.lai@intel.com>, <oe-lkp@lists.linux.dev>,
 <lkp@intel.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Christian Brauner" <brauner@kernel.org>, "David Hildenbrand"
 <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Qinyun Tan"
 <qinyuntan@linux.alibaba.com>, <linux-mm@kvack.org>
Subject: Re: [linux-next:master] [mm] b9b1861d4f:
 WARNING:possible_circular_locking_dependency_detected
Message-Id: <20261010161622.3a460fdbcd6765adb5c1eb7f@linux-foundation.org>
In-Reply-To: <36a0604d-b0ff-4f14-9203-0ffb36e0917b@bytedance.com>
References: <202610091403.d1d8080b-lkp@intel.com>
	<36a0604d-b0ff-4f14-9203-0ffb36e0917b@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C899FC0004
X-Stat-Signature: iqiwycrrhpom8mha9e9jz9oaabjzxpuc
X-HE-Tag: 1791674184-575426
X-HE-Meta: U2FsdGVkX19WKp0OzX0Ikx2yjJHg9pgcjAaOmJFH3IHIP9RF+LbZjLHsRovRZAla85jvotS1CwGnZIspvePAjQEOybpU4fvp+2tiz99L6kyccLXb6ckPvZubyWu63HzxBtrqot40vF1m+SJMav74Um3yRvFmV1JZtukhb3qSPtwAybW+XIGuq/bWLJaT63wYKOd7BcPxEoTSydjHola8Bpq4m+oPPS5xH9Vxltuv/8FcmSg3vLEFg1Ti+l3GoBvJind/cf8T36vJ7fYnPZzZBlVpN6TPsyHM/Zu0lyjfGStn+d3a6VHWlZF05cCh1FmOYjPM1qdAfckOBT0jAYuABUvzeywIqXWNodIrYqEp2qhM1hq/ZEs9J4xQi559soHxjdUqMWVjidQTd96veOqglZXoitjtstAfJSeX5+tUt9TmxDAl6OizHtSqxZ6oUWMmmTBcUa6UGMwMGXvBnR/pZTxQnNBlkaYCkeEAWzgNYLUTrDSd+w1LtCMqXR5NmGmfsx8X3MESx4//1KmkIdY1iV57pC3VxDg67Vkon+hBAlUJT0KS/jUxahiKWcGbo9tD0hAzNI3L0IY3BeXRDYYt7Xo0B4KO7A66NlctkgshSzmH6UADNYeaUCaapuL3VKH5oKSuNbd/oMwcViGMqZpnZy6/8sshjx70VfnOdujejrUHy4hE/I5re9irG8k1F6XUfzSujhRQN4ohKuDi5SmJVHJQNHNoHQFVnyA26bCM89DbTscb7Trw/iR8yitQqradBIDXfuaLIhrvSoClRUz+K1w/g4tXBnzogN5FliFXVSu4gVBMfVCFXoHhl9e9gViq3TKIJOSuRB4EmGkb3mEJRBky3PGvoxyL+ZrOJxjKcP4HIbGZwzYkNt7Z6QmivqfMsodlnOoGVom/rCe8yxB4xxfJhXDkJB8kRov0d6LHgnkfNCFqZ2HYK0WQG34cZyiVbh8vEdcKstoo/IRRCgB
 nB6J364Z
 T7JDqyLxyB8QWvXEWSepFg0KvH2GYMVmFL55EfWVNFUaQWHe0ki0VxoJmSpBc58cbW59atbVhgoY1JEo2qbnXb9G6xB4QQS47ig5qWB6CCjymo7ihKY0Tvisn4EQxoOAC+WY4jdluwSZ+6Z0rQtpQ3mBmT/H/t6Dj/LfNJ3COTtfXoY8Wg73kJvmOG4dtZlcbRC4oZPFizEhMGxpG7+xrsO8OZz0U8UEbBqcmTs3d7o3gB9ii4rTIQL2IpJKX8EPgO5gqDMpK94dsdlCt9xeU47OU6ae/cxQcNVle6CJxKRYdXtAN2SRjHOVKQEgArUMB/wip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Oct 2026 15:58:46 +0800 "Qi Zheng" <zhengqi.arch@bytedance.com> wrote:

> Could you please help test whether the following change makes the
> lockdep warning go away?
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5a9bcc7c66926..8ee767dccc1f6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5162,6 +5162,8 @@ static const struct dentry_operations 
> shmem_ci_dentry_ops = {
>   };
>   #endif
> 
> +static struct lock_class_key shmem_unused_huge_lock_key;
> +

This could be local to shmem_fill_super().

And inside #ifdef CONFIG_TRANSPARENT_HUGEPAGE somehow.

>   static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>   {
>          struct shmem_options *ctx = fc->fs_private;
> @@ -5243,7 +5245,8 @@ static int shmem_fill_super(struct super_block 
> *sb, struct fs_context *fc)
>                  goto failed;
> 
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -       if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
> +       if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
> +                                   &shmem_unused_huge_lock_key))
>                  goto failed;
>   #endif
> 

Thanks, I'll await a formal (non-wordwrapped!) patch.

