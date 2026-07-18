Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083E4C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0BEC6B0118; Fri, 17 Jul 2026 21:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2FF6B0119; Fri, 17 Jul 2026 21:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9256B011A; Fri, 17 Jul 2026 21:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB0556B0118
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:18:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FA86C0314
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:18:44 +0000 (UTC)
X-FDA: 85000137768.09.CC405AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12525C0007
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:18:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="O+aU/otj";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784337522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUNN70ODl1TFOBNZuY9TYjCOWJbM41bDJQxkkXv+zok=;
	b=hcmb2cfO7l4m6jORoF3ZZkB6icFXRRAzqOq0G+HiEfnYo9tM5mr+LSO1HwwTvGKsh2TMqU
	6HMdlfedZlSWfef2Oh3vMI0jrZ3l7F3gDByljR2ytciB58O7vBWPr8Ngp8L6uxB9RjFZjC
	DR/A6nd9Kro9mU3KAHHKhv3MDoKQHas=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="O+aU/otj";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784337522;
	b=1pfZhPdFBqMj5/BhHcFRT7DfKp+1ZhZ1hi9zAsji2Rbo2FNzzAt2NBCjx0PUCwtaiNMSyT
	Ak/IG+X19tpHHKIc6Vh1CVHRb/w+7NFvR6AVQ46W+1Xe0kuIF51m9FsqHD2EM0bCSjKDoA
	l9/rWbR60+DLWYf4cwGBVGczb8mZSgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E16394373A;
	Sat, 18 Jul 2026 01:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AB91F000E9;
	Sat, 18 Jul 2026 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337520;
	bh=jUNN70ODl1TFOBNZuY9TYjCOWJbM41bDJQxkkXv+zok=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O+aU/otjr3mP14zpdPZf+hIYDvWxg6wOLxUWemvdULEN3eYDWcaUxCCgsQao7lzyF
	 YgAfKVx3fbkJNtQPosgZMmvDi6sSViANthXfcWMVSai1HlJySBgwuiCBTMJusmF+Yl
	 RLyeQ8XFVu++/7Hu28BWjqwrdlTc7hwaLKg9058s=
Date: Fri, 17 Jul 2026 18:18:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global
 shrinker
Message-Id: <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
In-Reply-To: <20260717085151.22822-1-jiahao.kernel@gmail.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12525C0007
X-Stat-Signature: 5ouchmiox6e31dqfhpyznx98idyf7dut
X-HE-Tag: 1784337521-586589
X-HE-Meta: U2FsdGVkX180Y1ZEpIXD3nPbSyFB3zU0UheuLOWohtvM6t95H+EZtNQgFhpqOPBSKUvZ5R6fMGVr3DeoSbd7FRWW//ivwOTUbIpe93Cfyvx0yXvyh4VCHKGFZ269RTUEwoX00ONWdTwlywwVj1oqMMH1ffjBD8MBXK6mxq8W5aL2ycUxfNfOU6TwuQUi1fJt+BwpQVFg40SRB/47fPFesJzE81Nl/BHHeEmjdoVzel5xMRqdU/8aG49jTzfpPfvyjTQKd0X2cikjNt6BdhJvb6dqkOR29K79GH9/wLehrsC+0yhaFtsw7whnt0N3AdkHvGbn3raT+p5cQPtdgAoQYM1Gd/41c9QgQ3R+fGSiLtCHH6yt4T1+9FKexw9D1/aoy5QvcG+7PckuKHj1fsnSrcrCifnUh7hLP+uVmrOR6ES7/qLLQ1R+NX7CfVCX5V/2cv2i2NN71oqqQrnGsS4r+zSFgkt3rqUXNbqPI1R7OKiGl6oxYSWgFVmmHFLXCcYMDGEci/bf1eKvDY+5v/IuuZWzAiYpitQz0ddAIiEhOWsEefEeqL06loP3wRRq0KryX7K5jtBRzjCxS3UirgdlEgfCHaedn0k/RaLGLQxV6N1PU9AgKxqkrewFBfooyQerynhnqH04R0Nm5ltjG/cMiX2X0mngVpTYR8dMqblm8Yc7mHfA6zi8cSHGn5s2fRww5eaDEveU/6x8tVq3RnzsuQF7v3gTc20N7RSSzC3Y/6xLC6zGILvLYC922bW06BWUWrp+B8m+Zr8i2dOtQTaJjXZUgeyw6OpW+rTrBq8LWFFdilK9gaFXDg07udQzeNW17ayCPz+4R89l8wYjsRJFgsWouxu2KR0Ws7QVavh08686ZVVKjsWXaAUaBOBtS1267Lqkhw2siI9gLrOjCJo3QEv7ZHSmHqMxHxJCArNDWhlkgSBI+if6dzkJskZRTV0bo7GDg2VTudi1JO/+bdI
 3EdvH44n
 8BTJlP4NJjEfWpuRUyOc++E+CmNlaUjQEfK9/5CkRIufXjT3Oh3hQdxJUkHU21u+oQue4KJO78USv1T80uVRtRHsFR/MaHbhTswWB+BlfnsCtKxu6Ibn5W0xUhXWHBNph/r8T7epHCTly4Yo4RyOwpajqbhURc1mudVUH4oHWdPfL5IE6b8gByy3cMoJr7Wumnxoxf25R1jn6M7uXqr7cRi8Z5ew23G9W82QIcbfVhekK/noeniGmG4B3PTuR3T/CysQum8k0nmYlH+kxjKdg5viPWd5wftrXnuLTDX8pnATsXPghoqLQcj2uSjI7ieXJ1ImlEmg7rIS5XlBDdBMHu5SkdR50NBrZbweBX2602Cd2bSxbu6vbS47aigf3eWs/qvwVuzz9+gduLpisLg6Yhu/2//bJFLMgLYPC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 16:51:49 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:

> This series fixes and improves the zswap global shrinker (shrink_worker()):
> Patch 1: Fix missing global shrinker when memory cgroup is disabled.
> Patch 2: Extend shrink_memcg() to support batch writeback and update its
>          return value semantics, thereby improving the writeback efficiency
>          in the shrink_worker() path.

Thanks.

[1/2] is a cc:stable fix so it isn't really appropriate to combine this
with [2/2] which doesn't fix any bugs.  Because the two patches may
take different paths into mainline, with different timings.  But that's
OK, I can deal with the splitup if needed.

The [1/2] changelog lacks a description of how the flaw impacts users. 
Please describe this fully and maintain that info within the
changelogging.  This info helps -stable maintainers and others
understand why we're proposing a backport and helps myself and others
with timing decisions.

Finally, AI review might have found an issue:
	https://sashiko.dev/#/patchset/20260717085151.22822-1-jiahao.kernel@gmail.com



