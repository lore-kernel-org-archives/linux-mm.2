Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AB2606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 00:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wxtmXz91
Received: by kanga.kvack.org (Postfix)
	id E8A8A6B05B0; Mon, 23 Nov 2026 19:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14C16B05B2; Mon, 23 Nov 2026 19:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04726B05B0; Mon, 23 Nov 2026 19:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 962546B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:54:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1889C160989
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:54:56 +0000 (UTC)
X-FDA: 85468192992.15.5216998
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D70BC0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:54:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wxtmXz91;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795481694;
	b=BVxnGYi3FAn4hMSWWvGyshwTE0gZ4ZAkxRwnOZPb1fgxjnE1v4g598aPAY8vd6hzvDnwgd
	LNxDGi+ihWPWfppbOjO48pqDI2U3nkkZhcpvXA0kTfZe3fFz9/KtlW9hxOPLpJ8ZCIUPgL
	GGc5qZDPJvROIisx7bRWAmEMIyG8uiM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795481694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ViN0eIHvL0Nbs3ZKsf4/7g5sSxQBxyYI76K+CVQYXQ=;
	b=U0yulOaUBdjP/8wcjiL/AOkaDbJh4aYu4+Y+HaPZJiLxjyTFd5vTUyaIb8jev3XwXVGIfC
	Rt3cc5Sy8MISmobWE4E6bZBQU6ZvIcaclLRN4O8oLo96bb0k7SJZ6qTfP6AxQh2DRXwmt6
	Taoof1Jp+EnGt2ZumsV1ZrOoWfMIkvs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wxtmXz91;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 252DF43705;
	Tue, 24 Nov 2026 00:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052871F000C4;
	Tue, 24 Nov 2026 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795481692;
	bh=7ViN0eIHvL0Nbs3ZKsf4/7g5sSxQBxyYI76K+CVQYXQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wxtmXz91k/hp5vtf2YQn9xalSkOczmFrqpABLN4i4Q3Gi9PQpFSuF1/+2vfingqVP
	 mhcfj4CwpU/NSHMIifdFjYGR7yhN1HdYKoejPXpDmTPTU80nx7nlRWYyJUmxu0Pr98
	 UnIl8Bmc7ZZyjA+avslw/J69aEnmuWliDoYBULdo=
Date: Mon, 23 Nov 2026 16:54:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-Id: <20261123165451.8c30df036f95995316e15047@linux-foundation.org>
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 4D70BC0004
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ouf868m4eyyywrx6jfjoozj9bigxnp6n
X-HE-Tag: 1795481694-744138
X-HE-Meta: U2FsdGVkX19dwxD+2XLTqUFPTvfIrn2/4bAoGOoegXqS2k6i5i4eGbL0oeEpdlMPJFtAOaQ36OT7iGSvOvKp6eHvvmMoBehqUcwzIoYLiF1HT3FcXvtmkGtClcRCW2vXrHqedlEDW+F2JdGedJRQN2GaieeA08vAU3bhwWSUwpnCYG0/+LqpmYSaTa2LH8old/DUcelPXnNBZSh8fDNwtwI1g8krTVjBBLAPZOI2Dz86sVPz9Q42TUvrfYss1k/laFHXmSp2HGlGabthS9fKojvkWavZhwFwnIaBHdhhL+JEAmNeo0UQVEhVNUHLoV7NueMU0v/8bW30+G35ttxUd0/u7qRthc6mJvWwRHJNfSxcKPHONAFFr7J56la8z3G8FUm5P+RyZXnx1Z7505HXLtDiEa2LAOqjn4fTUEn4zsIlY4eW2R/MFahddT9luVXXSvQVWyfxwQcm34o/GuEuxBzamfpJA2GLjktVt51+4VG9he59RxODwhkH5+TVJdZdqczQl5o76mutQkfLv6yeHC8PBjDboj1wk6a1AOcjrWT0pCSXyWpt8MD/VMu2+ZRtJOLwWzd+FiajpKfy8Tas62bztRrQk9o4g93N3mm2kyxIz4zgmd9QmNZZLy6+Wi2VJ2KV0KpvRB6t5uhdEtmer418yenFeefd19NxA22ZeHfjLgo20kDizTEFbUa9oaj82IJl9aLYj7urxowrB+VwfR+p8OX9yiftD5Q/sRCm1VZAiILucG6QwscbKNOJzyqLxG63PNlLi/SQ7OAy1/omY7J4iRiz44k0g5Tv6RBQyfPMRrhp5d2rTTVUvxWasw3BlZDYUvOq9HMgMKOyKb5CHs3qRWJKqXjVIWoyce2ZOyfV01xeLx9VtClFBYlPmrLUG98ID8t6PWJaOINaA5izG5A5JhntumNAJIJsX5/GgeYx92agIkBpZeRx9zC9VgKHyhXlHKXXffeovz7AMcA
 ynQpzk5I
 tW1zwqrXr8DxEG3Hz20qWCZceBUWqHW9Qwg9d8yEzL1tg0sVlbGX7BHr5ouBtd3MjLeLpZ9s62B6Zvk9E/Zr76sxflcJskyF0qDCZF1yYFdWH7/Rf1vGy3IzeevsNjW2I3X3qMProlmqaYpd3lLwASHR4PsBrX1B2abkup06uO92qhTb3/19g4k4EKSD4SbgjvwLbBrgL49U/jd6u9ZppbbxsTpDVogZ97FGFJZeCevCRT7Hxxji1D9+qbwSRFBJTKsxoRTTDqeFI8BH6/cXFmNrZI9vIhBhbmxWw5/z7PPnIlK6nuWFFHPhJFblVcVZqIG5c1B18AVoMuezn7RoqibDh0Ah7RAUyJ6bzYeLYUSSuK3I+xdEtWe/DozES82MV6jbNKMvUZ4Zjd6fpRRre1QcCqiy7fzIKUcMwZlxOUd7xr1oOJkLXMl12TdK87DrcrdPFe8yPZBlqE3Y5/ZQmYXeGefJkeravIU60LTKOs2juHaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 16:04:39 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
> 
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
> 
> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
>
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> Cc: stable@vger.kernel.org

hm.  These allocations are all small and they're GFP_KERNEL so
cc:stable seems a stretch?   But whatever - stable people have bigger problems
than this ;)

> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
>  	return css->flags & CSS_ONLINE;
>  }
>  
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}

todo: switch css_next_child() to use this new helper.



