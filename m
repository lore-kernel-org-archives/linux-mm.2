Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C17FD6ACC7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB02D6B0089; Thu, 18 Dec 2025 04:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91086B008A; Thu, 18 Dec 2025 04:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5446B0092; Thu, 18 Dec 2025 04:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90E286B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:04:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C3745D529
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:04:13 +0000 (UTC)
X-FDA: 84232005186.06.15DE37B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9EB36A000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:04:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gh1ZAxfw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048651; a=rsa-sha256;
	cv=none;
	b=AGf/FZXEm0DmE7f48bu1621AmKIv4Wsdo/n2zZtW07Lhl/0zDfA60+VZsxDUaBboY8Ms8G
	eahBErSD44w3lw0GwoC2LC6G3/D9niZB/1+8e99uCeN7++jXaW9MLuK2Jagskj3o1etfJo
	u0yZZK8mJQz2fT5uNicoWgMRvOTOs9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gh1ZAxfw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtLyY4WKMN0apBgF5g/lMOY4d/JrKWkdoi1WOKd+3LI=;
	b=IriUB+21vPQi5JuQ+GY4t2Hgga2QFn0RdMJjCJNjUXHwg53s9whaoZ+vvl/dIPnA24P1II
	ehX6lpkfrIzatc9I//+tpgYDddGUsMGgzRJiym6j/dfYxpzuckHxJuw3P8ysXTsDYvDYWZ
	L0PiCaEAnfZpWYIPcxTmAtNK0x3g8QI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91C4B43AC2;
	Thu, 18 Dec 2025 09:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB66C4CEFB;
	Thu, 18 Dec 2025 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766048650;
	bh=K7sTzImfm/ZlD+BwDyLC75278tg9lbuRtHhwrRkkXVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gh1ZAxfwbsO5kkKLAFARVWdAfKe/XY/yd5XTJu/i3WKX+vCgqYh99HDC0JLqwiryE
	 3SqpGL8wPV595zKDmSfDUKlAylJ1gYl3qIo9Q2cHiAYU/YaAlgERnnzV8r1ZYIJTHT
	 qkdTB8fmsnFJ5pSfb8qIHJcCiLsASoEsc9ko5Ep6HFZScBEa+X4g0huhx4bHsLCdiE
	 t/zpwKTewKWtI+ND88OhKI3ZqeW0IRc1ZGesJBB1lXj+TeDIBV6htkCmmBGa6hbNGY
	 yyIuJm24mTGl+PmGqAAhfYuiuw4cyxzl2IVTuf9ZmoTQOppob5abO3OKFcTB95aRIZ
	 pj7jntYOGr3TA==
Message-ID: <87e59cd3-a554-4911-aaca-21be2080e2c6@kernel.org>
Date: Thu, 18 Dec 2025 10:04:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EB36A000F
X-Stat-Signature: idissxanczo43r8t7e75jyxkjo46gg7w
X-HE-Tag: 1766048651-561470
X-HE-Meta: U2FsdGVkX18C5YiSUaI1n36k36th/A7EBZM0GOSz9oi3RqjRvgApjZtKcOr6gyHa6a/H/5q/8aTJvu0x2mDz1J8Dh/AcfdH92QSLJTUgMrZ3VCV6J+A/1rjuCFXmt++3y96eVfdbUrTHUTwUnAYh84opm9QnL8O0dJYkge/Q/K5Aho7K9XFzMxPToxRGMLxcAhcdMNJDhTRCOTezRFO2t0pUOeIivnkl6T4g0aNSBkD/7AFctyerLGSRlYTdk+ymV4ARy55Bl9M/3lB4n8YUB5KxkzaixUW0qqnf/o1Wx5JgzQrXp18H73A6jHElzoJ8747olH82XRwh0CqnLi6Ig1k9jrg5ntLbqDp5s1Q6XxysXvJ0VYjhKwYNgDr5z71jnBhhdtow3WoFmNYImW+YAAcdIb7jg1EL/zgsKn/4KBP5i71Bmkx8JdRMRKFUWu0F6X/KJSbax958i454BeH8Z1wS4yLZGOvnDNBhR8eF2GPCZAqhF0gunbhJph1U1gNSxpTH5p+4cxit0W2ACf5S4sLRJgWzJYlg1ff+CbYcAoVLMtsmvRBkWTR+uQUehHD0aPZG2gWPKhhmCNqEQpHhmTH/g3cD6mWpM/9MlPw7sT/ZgJ78wbqS2FFFY7y3YMKveJ1ITb6msCBL5PJj0Uyj7wtMv+9v8jePFwUUz7pU9Agwsgjd3yNrAC7y1Cwqip53JA5aXhyNWyHUrGu6e0yJnY86kT8rJs90NbHeKDZaDnxNzhrKpCgdSaNq8dsNlnPxiDjEUcvu2lyC+lPPvpXH10Z0SKkLi1Jbd4HyR9ilMWbXixHpOG3MDCmh0/bqDfe4br4T5WXssJ5H66XUaqUJnNLv2vdBMM2vMz5XchC5p34qYVEH9KIZ1cgMdsX49A8GPzJ9GnzScbav4xCWRk9dPmt/xysSlWviMTN0pw4zHR66g/8Vcnwwas3ndKRCtBVQx8vyT7D3IAfyYyFmUSw
 l+MDvR/u
 2nwnapNhwWCQR6dQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 08:27, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> After refactoring the move_folios_to_lru(), its caller no longer needs to
> hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
> and __mod_node_page_state().
> 
> On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
> avoid using local_irq_disable() and reduce the critical section of
> disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
> count_vm_events() and mod_node_page_state().

The patch description is a bit confusing for me.

I assume you mean something like

"Once we refactor move_folios_to_lru(), its callers will no longer have 
to hold the lruvec lock; disabling IRQs is then only required for 
__count_vm_events() and __mod_node_page_state().

To prepare for that, let's $YOURDETAILSHERE"

-- 
Cheers

David

