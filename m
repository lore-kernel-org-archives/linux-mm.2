Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA905C98302
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 23:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9C76B0005; Fri, 16 Jan 2026 18:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D166B0088; Fri, 16 Jan 2026 18:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F7A6B0089; Fri, 16 Jan 2026 18:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA90B6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:15:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 780BD57D3B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:15:04 +0000 (UTC)
X-FDA: 84339384528.16.8375202
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D4F1040003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:15:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TfRQjOtL;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768605302; a=rsa-sha256;
	cv=none;
	b=XgEcUES26TBu0CuSVoXB1Bq3mmRl3Gk5JKfvZn7TjWbLn9YS5AvH1Ovwtfql/2laEA3lOF
	lzhQCPC3SnQU+IpdrDd7lZJQ4vvmFnu0futEBEzmaqLZBWRoE5ZOY/EwXerrOuoPIvtUtL
	Pbw5hZz9r+vP5XdToQ0SyHHyrT4S5Y8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TfRQjOtL;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768605302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXTJ15YRAosOP/HwtGw87XiIfZqk5pMWiCX3J0rmlCI=;
	b=7fVY1YFHF+HsjrHmuAG3yItyWplIjXUF+2z3IwZE3xlJGLsUYNXd4f2SOsuiwsytKVvtbl
	TvsLKrTq50bgq9zQvUUkeESID2H/Epx64yVu9SaMOSL8RKLJMgflUslFQXmGcpcgdiUSuI
	/gu/HnTm7SahIkumhdJGyd0C3a0M4vM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37A7F60160;
	Fri, 16 Jan 2026 23:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61204C116C6;
	Fri, 16 Jan 2026 23:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768605301;
	bh=+0CNKwKHffjPLmqUX+TzPn4+iKRnH11I0K5ejqSDu5k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TfRQjOtL4rSSQvu8aV2jJSu5THwCjnEUAVm0VwaK2ToWV+ONPhsz14b5ZHcvvuKIf
	 XDKokYSXlVCIMuQt1oc8/m8PXJrrogzxEnV5XFViBVnDndqeWjnsMch8/xUD6uvP8V
	 7iUPcTO2ajsfjvPOoYXrLOBdUozU9/mbKQdyE3bs=
Date: Fri, 16 Jan 2026 15:15:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Byungchul Park <byungchul@sk.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Pavel Begunkov <asml.silence@gmail.com>,
 =?ISO-8859-1?Q?"Toke_H=F8iland-J=F8rgensen"?= <toke@redhat.com>
Subject: Re: [akpm-mm:mm-unstable /301] net/core/page_pool.c:713:71: sparse:
 sparse: incorrect type in argument 1 (different base types)
Message-Id: <20260116151500.b56d0cc2525072123ad2d86d@linux-foundation.org>
In-Reply-To: <202601161606.8RuyUh2k-lkp@intel.com>
References: <202601161606.8RuyUh2k-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4F1040003
X-Rspamd-Server: rspam06
X-Stat-Signature: xar5i46omgrxknriq4j3pfibhaoh6jar
X-Rspam-User: 
X-HE-Tag: 1768605302-83531
X-HE-Meta: U2FsdGVkX1/lo4wde1ViwGApJEoDKsozwqD8CYPVxBymxTwuzYRBflUp0q3zbl+cqNyW9dPWpWfZ5AsYmuOeLToNw5qj8Mkj455JblivrKWFocdfE5TwDDfiqIGZ95zpHio0o0uJ83Ef0DrCkvDQm3iv08asrN48+5DBifg25t43mgaJK3C1AQxEw9IdX2PmKVo+nr7XprRd9lDpoW20zZVzFd/aJi9uiJ4SV4CWuXW/a7eyKgeK3E6PopAHlAMaYF8lcsoEiyOcDsA9lo/vO1d3u8AlJVLZRVbE0a4WEpIwLv3nF7QB3z1mxh4diyd8PKb6L9f+dp3wuyYPQKbQOTtmeL6Fl6KzOTQ2wYmGix09Py1+JZdilCheb58anE4f5phtnWONf2q6AkyI94Yg/M3ggNprH++nbfRRubey8VuFXsLfI7qZk/liQpN2fJNiLfU4nKMiD72FI1J/3yZ1MudHWYYGFbfoIWsSkiR/kZvsKDhgwr9mUzEi0w+q1VCxDX5SWPSqE21QpOplUlBSK3E1LgkZO1OAKmDezKNzpkeyLqDQc7Zrv6jKEKc5L4bS6oqnyXCXx+2/9s8O2FKGYbcjPeO7l/hd7bcOIHzZuesTfMnXS33C8VoHCfbqbXz22kBUF0mjwX2+oRRQOK7DmQEc0vPmdghIkbLBsut8IefKuaQSEf6nNtvMyUeYeyDN1KI5VrYt7V+YJK4JiJa+SkpR0LZdu0uRtIfR6NjK3BTA8IqQ/zG7EcULZxAnIGTLCOd6819wgnONXiCXls0l3RtOtPQ05kMfCZ9H95LK7ak4dMJe6Y0q2kAA3StnfrNHIC9MQDmNd9QeV8UKpS+GrNGO0GK2Kaua+kxSUterEtgYQKg8LCdv5dPzx1bnzHtRNhZkK1Tdl7RRN1kLzsCZAvf7UlEuMQg0a1dMs2J41HhOuWx/dHArOgwvPtzazpl8s8IMyU2Oo+/LQkbeacx
 nMJnNGYj
 gfCY7tny++nnsgPyghafjrLX7Sy8iBMC7CNjNqQ3jCXkc/iJDQJxFtm/jl4Z8RurdvHSeRDnbUUo0rFw8zQooi0QVbQz7gR/3obDi/pb8iEv2/ynAb89M61lvZ+koO+zncXKqi/g18bcamnpIu0Lkcn8xP8je4MbIJ7bWYsqWAQYdyZoyAyVzAdb3S873cw477ULK0pHLYhxBjXFMASQXarGlKjeu+FtdSggbhxRAncWXSk8mQISUe9o9syLHDOzj47k1fziwseIzHjpApQqr+jrH6Ho8+rnDdaEijdTIUqOteZwbZrN+QDxCkOBaLYOkNOWREQ5B48/aRItOG366Zjk1FpaYv6CkBiwik8Z17Z67TDtldmMtdlhdd7vwqBrQxEEhk9IIUhC9EQH4krk+V4GZ2zwAKfxx/7JmVppWO8qj7H2/8nz1YrRu2YmgYAkd0VFelR+3KbWNumctCQ/iDyN/rn+bghA5tGJNs5vXPKJ8DTrXZhw0F94eanz0s8UJzBL0jKfKc+/WOuO39r8T1baiGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 16:41:32 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   fe2c34b6ea5a0e1175c30d59bc1c28caafb02c62
> commit: 7699fe82442a62ea29a3745b29dbb8ef8c42d8db [/301] mm: introduce a new page type for page pool in page type
> config: x86_64-randconfig-122-20260115 (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601161606.8RuyUh2k-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> net/core/page_pool.c:713:71: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
>    net/core/page_pool.c:713:71: sparse:     expected restricted netmem_ref [usertype] netmem
>    net/core/page_pool.c:713:71: sparse:     got unsigned long
>    net/core/page_pool.c:734:73: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
>    net/core/page_pool.c:734:73: sparse:     expected restricted netmem_ref [usertype] netmem
>    net/core/page_pool.c:734:73: sparse:     got unsigned long

Oh, OK.

Byungchul, please remind me why I'm carrying a page-pool patch?  I
applied it because email headers and because Suggested-by:David, but
these things are usually carried in the networking tree.  

And I never applied [patch 2/2]
(https://lkml.kernel.org/r/20251215071001.78263-3-byungchul@sk.com)
because "kernel test robot" reported a build error.

In fact, I'll drop the patch - please let's have a redo.

