Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A408DCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F838E0007; Thu,  6 Nov 2025 19:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A674A8E0002; Thu,  6 Nov 2025 19:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A51F8E0007; Thu,  6 Nov 2025 19:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88E1A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:32:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08FE758481
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:32:31 +0000 (UTC)
X-FDA: 84081934902.07.C994E2F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 191D54000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:32:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eNzBkg6K;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762475549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yS+MdoGbxE+vBEvrR0CnerAzSJJp4Z3mqFdZ5Yqa+T8=;
	b=4DsJrEpzqlprOVLdfYHZ+kS4h12Ha++ERg1c+fKRZ6gyUgz3vfOHpyz6jWyha6y/ev1Qz+
	gLn6P4BAeflPTVykvfGMOC8G0RZ3vUqVQOfjEqYr8f5IjE48ockwSv8MRagLZ4FiWvOTm9
	jmrb/SdNDTFrsWBge0m25jBBK+26FOU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eNzBkg6K;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762475549; a=rsa-sha256;
	cv=none;
	b=tkiLZukOvR+wt1bnxd2LTLZqHG0I6rQOrvs9zkd+bxnn7r0PN/EMk2yJ/aYMzFgyogsBsO
	G2AK+2OM86LP3T1JQuyWYYqoAK9Yo+Eq4rmWK3dGwB1mtHkq0fLosnit5sAQBd+ds/+Aky
	fJ42Odk/yBMVXHX879/5unyCPGmQpm8=
Date: Thu, 6 Nov 2025 16:32:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762475546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yS+MdoGbxE+vBEvrR0CnerAzSJJp4Z3mqFdZ5Yqa+T8=;
	b=eNzBkg6Kp9rQ0bVoqyfWj29RngbJ3M1n/97CJR9Q36ISS02qWfS1JkYlK+aDrdOwTdJH2i
	XjFHIdUCx4np7ciNjWCqoFw1MMs6lO4am2h3v3Wr+emlfOMM1TtBzEaqaNbgDUI2Ifzq5V
	O0JzIJJGDKpHnupigi96k+Bnz64SUro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <oliver.sang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	oe-lkp@lists.linux.dev, lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>, 
	David Rientjes <rientjes@google.com>, SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <liam.howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, christian.koenig@amd.com
Subject: Re: [RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large
 many-core systems
Message-ID: <6hmgutxgdchs4qz6hprwsecwoygwszn5ywixxrvnereilegcsx@mxroaotaw2me>
References: <20251031144232.15284-3-mathieu.desnoyers@efficios.com>
 <202511061432.4e534796-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511061432.4e534796-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 191D54000A
X-Stat-Signature: 8y15nycwsckozjxhwxw5gmmndswznyje
X-Rspam-User: 
X-HE-Tag: 1762475548-313079
X-HE-Meta: U2FsdGVkX1+qpbe06E0hDrXLXgfkW0rOBU7cPPlB5z10a0Qoobmu9nwvMRDRfCzO+LgEr332svAVKBkqfCJ7v1sKzQ9bnsOWC1GpEup7Obd05QsWDR+Rl/IQabD7O7gJWr1hhn4MYDH5U+CliwVqhfl6vRCWXnZ3RmqceHDXgBD1E+2B6qgNb4qlnZKdkKzgymOpr860lme1dxEoMsU87BVg0i3VClVAJ9K2OZyJAGcVlsGYMRxzCKQiNmNEI7RhXcNw0VqS42NzrYnMPe4GxPPodeVlw7aHtXwnwijhy1kp5FhlXcAKa4QjuW+liOwX2X0/WuBX9KoCdCw7DvZQUMxr6z2t5AiXkPeJQsnQapawHZpGjLUY+2ZCSDxL1BytpaUd+LfREOyyc3cmeBp0Z7474QykfFf3QYwOxmtNsquyfgByagJE0Pm2RcEwtp//bg6TtHVBwVC3gJBeXQ/CPH+z9iZOWWjtmO43z8AJarsBzz6iINZZiHEPqhA8HCLbCG6CbmhA1ENBtyjrZ84C/5scNJgJeB+5Tvdou01YDKt2xh+hdkT97NEpZlIg4nEdHdgQ6J/Zp5fb26BYQrfLdpE4C69Amb06tsFLI0/te2cTsi7nvWelH4P988LXD1kFakPgpOQisl9DlMMsVi3xIBVDFX4iZv/ceZIFaiG88AgBpDD2vzBBersSuN+kKatKQApMoywxlEvZO9iR5KPL0pEudz0Hzb5cLr1vumetNmZePQQgFX0/shDzwbN7pVAAyxlStBI+p9S8SBg+DZFip5kIdCCapY0wihUZ4n05E84yb3IwfIpxjyaH78H1q0sJ7o8TYwl3+scxpshyuVhwyrMdPDBEJou8XQy0/TvykCBq/UGP1Atg8Rm2u1lRa+2HLyg5tvs1XA+Kg/0z9b3Rlj3RTjmM3rUEnYQkslT5/F8eFx3fLyYEhqSOIwmhvGVz+sLNFHjqvJU4xSz3f+l
 py2WKqGg
 v0HjuSLAxQvwVnMW5VboYM61Y5rz0ihv8Lul7VglzLP9rwcPEdL+gTotJD1i5pGbX7Px1vqAu5Wug50GjLz390/B7En+LyWGUrXDTmSlaTYrwyDSMPGT1jZTmwvHs8MCr09kJoa96eltHUfa1muFm5+bXCiMTk6YP5cfkwA/2gGWrFFQYrbNgq3dgKYI6GCSoLcxX8mANSxooORZF8ZfYR57Zel7giOZ51yzghR3pf625h95tXdDrmZOxvb9/TkzHTJ5SboqwcRMFMpmuvd4N1HEC/NuiH5mTqkdY+wPj41Rr0HQ7Ac3nhDxawrkmNI9WnzwgNkp88/bATTYGiyAe6rat/b3D2b1OJiEC2QIqaFb74ccWjUlrLbj6l4yYVnnL4X78856VhGQ1gK8i5AGReIToZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 02:53:09PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:Bad_rss-counter_state_mm:#type:MM_ANONPAGES_val:#Comm:kworker##Pid" on:
> 
> commit: 25ae03e80acad812e536694c1a07a3f57784ae23 ("[RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large many-core systems")
> url: https://github.com/intel-lab-lkp/linux/commits/Mathieu-Desnoyers/lib-Introduce-hierarchical-per-cpu-counters/20251031-224455
> base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
> patch link: https://lore.kernel.org/all/20251031144232.15284-3-mathieu.desnoyers@efficios.com/
> patch subject: [RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large many-core systems
> 
> in testcase: boot
> 
> config: x86_64-randconfig-002-20251103
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> in fact, we observed various BUG:Bad_rss-counter_state_mm issues for this commit
> but clean on parent, as below
> 
> +------------------------------------------------------------------------+------------+------------+
> |                                                                        | 05880dc4af | 25ae03e80a |
> +------------------------------------------------------------------------+------------+------------+
> | BUG:Bad_rss-counter_state_mm:#type:MM_FILEPAGES_val:#Comm:kworker##Pid | 0          | 10         |
> | BUG:Bad_rss-counter_state_mm:#type:MM_ANONPAGES_val:#Comm:kworker##Pid | 0          | 17         |
> | BUG:Bad_rss-counter_state_mm:#type:MM_ANONPAGES_val:#Comm:swapper_Pid  | 0          | 2          |
> | BUG:Bad_rss-counter_state_mm:#type:MM_ANONPAGES_val:#Comm:modprobe_Pid | 0          | 3          |
> | BUG:Bad_rss-counter_state_mm:#type:MM_FILEPAGES_val:#Comm:modprobe_Pid | 0          | 1          |
> +------------------------------------------------------------------------+------------+------------+
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202511061432.4e534796-lkp@intel.com
> 
> 
> [   14.858862][   T67] BUG: Bad rss-counter state mm:ffff8881000655c0 type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:67
> [   14.894890][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 type:MM_FILEPAGES val:0 Comm:kworker/u9:0 Pid:69
> [   14.896108][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:69

Hmm this shows that percpu_counter_tree_precise_sum() is returning 0 but
percpu_counter_tree_approximate_sum() is off more than
counter->inaccuracy. I have not dig deeper to find why but this needs to
be resolved before considering this series for upstream.

