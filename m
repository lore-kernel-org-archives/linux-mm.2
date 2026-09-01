Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE42C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86D06B00B6; Tue,  1 Sep 2026 03:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37FD6B00B7; Tue,  1 Sep 2026 03:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28B16B00B8; Tue,  1 Sep 2026 03:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 751306B00B6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:27:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0819A02F6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:27:50 +0000 (UTC)
X-FDA: 85164363900.06.95B4C60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4FA7AA0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:27:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZpOB8u4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788247669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGa9MdY2HmilFhv3h7yAxaNr+XC2/lGA469m5Lsc+Ow=;
	b=o2dhrjyYqLybmd5r4kRmSGhfqa4/J3XIus40weCnT7Oc6bcTvBwfynCfj5gvWJmhHLMY4b
	XfTNWMp5lmuXQ3Uyi0LN8JZNxySmxpPHMFBhI1kLefAvZ1NQa3jOUSKtuWk8qg7tMVKTre
	JYJspMd1i6CJZoaSRTzY8TwpI0sYLd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788247669;
	b=YolAi4K2sqraLCMn0yDN+XE86RLcbCINVhMuR4Qd+Mn/iiXNUWGwu/SE/Bozo+qwWrHzpL
	hTglKK0Xjn8NMASjS5ADa/oMl4njkgfaS0u/ejgoU6miBBVjLqDw3G1rwRzxAVIGsNL0l/
	ZzFWHh9B9CLeUwODXFXoPS6HEDgKiQI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZpOB8u4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7D6E600D1;
	Tue,  1 Sep 2026 07:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB951F000E9;
	Tue,  1 Sep 2026 07:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788247668;
	bh=YGa9MdY2HmilFhv3h7yAxaNr+XC2/lGA469m5Lsc+Ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZpOB8u4FARtGbaeK+Zktx6F83IhDjixUWt+slRUvUXoCndjlaLxtFgKCavyv558i
	 XMavzFhNg/6vhef3/+YX633G8e9jxWeDyVexxctyKidec2NvcfKyo/KeFnUW9Uq25/
	 yTat+Ht/BsQAZxKuzrhoUwMiAa+rGu+9JxG0qdh2YyPgHRgr5hm8rEFM5VSp2pfOYd
	 yseektNF4aXsRGgyF7tr+7iBeGSW9HYpZXd3A90vAwvhCWfjTHFbK8fI64tQNj6E6P
	 WGQwJQzGDwhmzMnjCMkcebYa2pu1BlrcZymirMHkQv1I0CzQrNKpBvYfveBC6cvvFw
	 2a6tBJq8DNUvQ==
Date: Tue, 1 Sep 2026 08:27:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
Message-ID: <apZ99NHTmNI_nIwz@gremlin>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
 <apEx0wT_hWs1Q5Wp@gremlin>
 <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
 <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FA7AA0007
X-Stat-Signature: 441atpjrkh896nppatjq3zbh4xsdi1sj
X-HE-Tag: 1788247669-380097
X-HE-Meta: U2FsdGVkX18xwjp0Cy2gBx65a1aztptAOkWM9M0zu8w1os7wipI4EqNeouVJ80JESh4+7k+UaJYeeuF8Cd4SJVVfq7MndCeq2F2ii3tKDapc4y568wgSMsxUNqRAX2s6/gzP4TB2EgPOYfP1YiQzmytXwA87x8jgoLxUJKfZlmMDt1w5Ri7bUgtCW0P10OnVbo9dzJ5ijxDhTprSq43txAAoy2rm116kYaKqqMErEDpdMddYuugx12Ee6W2yL3vrDtdqb/eklfGRFHK40b2prNCc0DyQiRvwmTYjJg56P8aQeBhBl7yGU/o4VoGgnnVRQnlXOcq2YoYK2SurnPXtFwC3M3uMZO1OlAoYxaldNYEZCGDL4I4e++YeFqnO2zdpkCSGLGPqlnXtPb8ZQPXocVr91//Miu310kjyO6sn+xQsfkuDucfqqrWQLeG6ahelUYugCbZ9HaQ4SqJyVzD5Uy++BlcRGuijmpDu7p4g+wA9n0Hy9v7nQa1925xdCH7ANI7JisCO+6TeXCN1C9b9cUG7NT7JfgRG4Sa7lmLEcCapd0t08SZQt+pegT8urdjChpOoweWxjwzsaEDTr9omKYqKx2zsHGcApGQ6FfUQeQyc9J+77BF5PF3OU3Z66SXLLMCuYAA7o/3ZIsCE168s8oU/UzIwhW3uWDZkEVbg+zAX+d1QdTE0xaHDwQ0V4zX/S70GDp+j3PdacegT/mxlq+v+I/yJGMFsgOGMWZLbnaqftvUgI1naD/t5MOvWiTEIxsUTFQpUVOYH8m6eghT5EnpQDKHyAY8JzD91ETZXyPitjqM5DTTb1HaX6kp1OTbfHoZdahVX5EWGofkXOLwsQdOzh5rcy6i5kZgbG2zPQgDt6Mb/9eYXXsdR0qX6UcyAkoxvXuzmLOR+0o90MPf6ZomASL1ZKV2zBBNs1y5EfoPEAv5L3m0RRTN7dTbK/m/TT05tQ4Lnlxo9co8Bf0w
 G9DeighF
 yJA/FT1qfIbhKXU6Iqj1fzo3/1PCPzf/1a55L1Z45UTFk/xBGKR9V45yVfuGnnDe631zYZXjjfivDdt+/FzDA1sF8tvaGUL029CbAATRw7mtICgPCznBP6rHiV8uNyeLTpGFH38CkWrdjOfHGuGuQmxCLCD4ehuqyCQMRmf+CzCB7k+UAmWh3PZIWl2oLzKyBGLkGDP0t9jiBCC1WPQqkMqd5eGYt4mUgio1bPvIDVYScf8vO0j0Hv7F5m/4rUhR/588pP/JzgpsCsuCgu8/6jPRh94l59342kve41yXAfqySFvDJT6dGpFcbdfi4bE5Ps9iKDJ712tbxYRTfxJLcURvn3ZVHbWWg0JkcCUMYCwSIA67a0OP9/N5k009KoNHycv++zaKXHCRZ3E82iyO34zZ4VyhRuIYot3QLnXn++L/Wpds2+VrKj3hytAj/nZ9u7Zx1ECHZGz/Cyss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:34:34PM +0800, zhen.ni wrote:
>
>
> 在 2026/8/29 02:36, Andrew Morton 写道:
> > On Fri, 28 Aug 2026 08:03:38 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > > On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
> > > > This patch series adds process and memory cgroup filtering support to
> > > > page_owner. Following the previous series that introduced print_mode and
> > > > NUMA node filters:
> > > >    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> > > >
> > > > This series adds filtering capabilities to page_owner, allowing users to
> > > > filter output by specific processes and memory cgroups. Users can now
> > > > filter page_owner output by PID, TGID, COMM (with wildcard support), and
> > > > memory cgroup path. This makes page_owner debugging more focused and
> > > > efficient for tracking memory allocations in specific contexts.
> > >
> > > The majority of this cover letter feels like it should have been
> > > documentation put somewhere :)
> >
> > yes please.
> >
> > The only thing longer than the cover letter is the Sashiko report ;)
> >
> > 	https://sashiko.dev/#/patchset/20260828031339.1270699-1-zhen.ni@easystack.cn
> >
> >
>
> Hi Andrew, Lorenzo,
>
> Thanks for the review.
>
> I have analyzed all the Sashiko report findings. Some will be fixed in
> the next version, and for the rest I propose not to fix them, with
> reasons below. If there are no objections I will send v2 accordingly.
>
> Will be fixed in the next version:
>
> - mm/page_owner.c: drop the kstrdup() copy in parse_pid_t_list(); the
>   token will be parsed in place. This also fixes a leak on the success
>   path and a kfree() of an advanced (interior) pointer on the error
>   path. cmp_int() will replace plain subtraction in cmp_pid_t(), and
>   pid values exceeding PID_MAX_LIMIT will be rejected.
> - mm/page_owner.c: PAGE_OWNER will select GLOB so glob_match() is
>   always linked in; parse_comm_list() will drop its kstrdup() copy the
>   same way.
> - mm/page_owner.c: the cgroup path buffer will be allocated once per
>   read() outside the page_ext RCU read-side critical section instead of
>   per page inside get_page_memcg_info() (GFP_KERNEL allocations must
>   not sleep there). The memcg= parsing branch will be guarded by
>   CONFIG_MEMCG so kernels built without memcg reject the command
>   instead of silently enabling a filter that never matches.
> - tools/mm/page_owner_filter.c: user-visible input errors (empty
>   -p/-t/-c/-g arguments) will print error messages instead of exiting
>   silently.
> - Documentation: the wildcard pattern in the -c example will be quoted
>   to prevent shell glob expansion.
>
> Proposed not to fix, by design:
>
> 1. Shared-fd concurrent read/write races (READ_ONCE around the pid
>    passed to bsearch, torn reads of pid/tgid lists, glob_match() racing
>    comm rewrites, concurrent write() leading to state->memcg_path
>    double-allocation): multi-threaded sharing of one page_owner fd is
>    not a designed use of this interface. The filters are per-fd state
>    meant to be configured once and then read, which is what the
>    page_owner_filter tool does. Adding locking to the read path would
>    put overhead into the per-page scan loop for no designed benefit.
>    This matches the semantics of the original filter introduction.
>
> 2. No "clear filter" support (empty pid=/tgid= lists partially clearing
>    proc filters, empty memcg=/nid= being rejected): write commands are
>    incremental -- "keep the unmentioned filters" -- and there is no
>    clear operation by design. To start over, close the fd and open a
>    fresh one; the page_owner_filter tool already works this way. This
>    also matches the semantics of the original filter introduction.
>
> 3. kcalloc() vs kmalloc_array() for new_comm_list: no consumer of the
>    list reads past strscpy()'s NUL terminator, so uninitialized bytes
>    are unreachable.
>
> 4. char cgroup_path[512] in validate_cgroup_path(): acknowledged that
>    the kernel side accepts paths up to PATH_MAX (4096). The userspace
>    check truncates an over-long path with snprintf() and then fails
>    access(), so it is rejected, never silently accepted. Bumping the
>    buffer to PATH_MAX would only serve pathological paths; realistic
>    cgroup paths are well under 100 bytes, so 512 wastes nothing in
>    practice.
>
> If this plan looks reasonable I will send v2.

Sorry but this kind of 'summary', 'do you agree with the plan' email is not
acceptable.

You have your feedback, reply to people like a human being directly to them,
thank you very much.

At this point, based on past experience, I have to ask if you're using an LLM?
If so please disclose this as per kernel guidelines:

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

>
> Thanks,
> Zhen Ni

--
Cheers, Lorenzo

