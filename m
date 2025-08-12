Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498A1C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7128E014D; Tue, 12 Aug 2025 11:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F818E00B0; Tue, 12 Aug 2025 11:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4DD8E014D; Tue, 12 Aug 2025 11:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9FDD8E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:09:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B056B8977
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:09:28 +0000 (UTC)
X-FDA: 83768439216.12.C1A3ED5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23EC640009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:09:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KaCVOFic;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755011366; a=rsa-sha256;
	cv=none;
	b=7qudc7mQ7XyxSmE/UsK4w7eUcrRaRO2XJpBL1rY3vbJzu157ucOIqwRoTUtb5bWqS8lrFW
	QJm1ymdDFcZUkfxpAGVTtodc2KhiP/dLTyjx7W2McDWiVyNjlCysP2JM4i9puiDCi/wGXu
	LjWMQGwtHtC4RyY7wthDDJHAJ7HBQ6E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KaCVOFic;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755011366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IUkjo8HZfEXK/EdcBKh2T0TV/YpgV777bpWawcqGj0=;
	b=Ck0vcpnWDv1WR01FqLw+GlDU17yFHNrowiuKRe4piXc0yqH+MzxEIKL6vEXVH6E2HdnsUk
	cr7BXHRyunLbufsrUCWsc7fnTEZ/h9IOa8jvAM9XR1LVxo4j8kxPpEcPp+jRocsGosizte
	/JJIEAim2facyvmyn7zy2nAEqEAA92U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755011366; x=1786547366;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x9Q2uf+Vcwv+UGHML2zmP1ZdgpCoiBIGCjX2Ui0X2/w=;
  b=KaCVOFiclizgIEBFari6JY4mYoHFqQPfzAeFcJYMT0ZXRPrH57JgzLJx
   YGM/boIH7FU/AzqrViDBTfh7GTiQ7DdcgjKOn9cZ0ldC0b8rSVbLzzp2l
   97lgSsVCND+Y3wBtB5YYmk+iLJ6mJhzdrEU2jrq2FTpnts+luRFNQ7PC/
   q9W98yCj52zmN3w6hxJe6B48Hv4n7SIyYiuZXmxbuq+euwwo3dWmqIL8L
   2qI9hlSwbWqm2zInT0mylrTWjEgc/PLH79K8lTAfnO38xFJ5Th2Jmtjj5
   /lsEuWMRizug2CjHljERBzCVWSCbIkFQ7+9xlHvM8IWG0dIESj9sISDBE
   w==;
X-CSE-ConnectionGUID: JVnuSQZJT3qE15Of9SK/qA==
X-CSE-MsgGUID: S5W+g7dBRDy/ETyi9NJu4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="67554589"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="67554589"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 08:09:24 -0700
X-CSE-ConnectionGUID: rS845/2TQf+XLHduchzOWQ==
X-CSE-MsgGUID: c+qvQ3xoQPqHerCxvYIYcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165444512"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 12 Aug 2025 08:09:18 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ulqcl-0006v9-2T;
	Tue, 12 Aug 2025 15:09:15 +0000
Date: Tue, 12 Aug 2025 23:08:38 +0800
From: kernel test robot <lkp@intel.com>
To: Kuniyuki Iwashima <kuniyu@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>, mptcp@lists.linux.dev,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
Message-ID: <202508122213.H31XXZsm-lkp@intel.com>
References: <20250811173116.2829786-13-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811173116.2829786-13-kuniyu@google.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 23EC640009
X-Stat-Signature: qxnpg3qmtg7xs4smojmpktx55qz6usfk
X-HE-Tag: 1755011364-172584
X-HE-Meta: U2FsdGVkX1+I7rGmGQze23GYxROnDDg5d72l6538g1hosqFQoFLMQMrj141BOv96++wg5Bx3GshHT2zJHska4uPzhMl7EuthUuB7pIoGvY1hDrxqolCTLTYnKT/uPHEGnCUc06lJBfX/H65UUsdAxjkpYXr0n7Nhxf4TJmxYQOLTBzCKgOWULJ23XxVHlpO/k3nm0sPjiuHyW8ROEpEniclyXjP52lqMr4lyI0vDqQ+AtLoEc38flUecRfyFn2Lh+CpI8T3Tz1pJy1e01W+XZEk5dC+iLv05m+toVBp8uthh7jZwnhyKteUEuOudOsiW5y/x1f5OLQ5qSisISEdabp3mNLVF+FFCvz08+tCcWBlMLF5aRqzS6qsKwmb4L8eCAyENAaIrD0lUWFINtLnjoybavw6FckZT3yYuOUB9tnZWVa6CzAi5UrZIwxOwM1haH3jzjPoFTwptF3Ai+JIEG9CWGD+fELdF3GZhklp3WvNJWu5W92pySVEAItK402ywP5zfLJ0vha2KNRxg5b2niHfsimJWnvR6IazdG/d2oQtmvi9NQYWjmZJA6OoXUYJQ8ZqLp+tg7n03gjDsKAVaopbP+UQ9G9ZK6olruJIxS6+elJFCq+T6FvHC363g0saP2ytKb7PSsl63W9BUZggQtDJIfuJoVDEdZcRl8a6O75BJ0K1dsvohciuFP1xFHO0ArTve9idEXeJ6Q7XoUQ1xGmgukL86sUv7ViNPPq1csXLxo19Uc+ZkNe4pKlRmZGXZh/rpiWUwqkzeHzMCj/ZErgQ+VoHREHhqm9MvVvGW9V+txFWZE24H3MNvjH4tEP+ExsGbTEAiZjJScYQveUYGHvBxM6pi9AVZ3mObtvBiyvvYhqOYMcT+qdp/Gl17wCeHxy9o/dnWZtNLmovfIt+PLDmDbowvRmOg6maaCmVh4SWBgkvJ6nVltoUSjg3E5zA+yP4BThY0PhY40ThhXRS
 HDvFoo3Q
 43zirqxm2NYyqk329f/0ZLtGj749WjmndaKGUjBm1L8nLSjdiXYI0909mwrHGaNl8aWAKf7at9gR0A734z+nN38Zg/EiYdOx7MlGCzLuuEi41Ex/NXK34TRM5GYeD3yzjmZ9ggGxS2cQH5mXi0yKILoaMf0FokzQq+JALaP+pjLeRUAe7+9jWZaWdZm5WAgf+UKPLjGf7RDYC/QwQtX5oClqDhfcmX10x5zBDIdDG75U/w2xjBbAWThnfDThGoFr8hMtebo7PaGStjjexK0okJp7mU7M+9xWtP/WRZ4msLG/3XDl27qujKehOyBKWJQmk9gOieK/HMQBksMr3EX48PXgJu2sywW6M5S8U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kuniyuki,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/mptcp-Fix-up-subflow-s-memcg-when-CONFIG_SOCK_CGROUP_DATA-n/20250812-013522
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250811173116.2829786-13-kuniyu%40google.com
patch subject: [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from global protocol memory accounting.
config: csky-randconfig-002-20250812 (https://download.01.org/0day-ci/archive/20250812/202508122213.H31XXZsm-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250812/202508122213.H31XXZsm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508122213.H31XXZsm-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/cleanup.h:5,
                    from include/linux/irqflags.h:17,
                    from include/asm-generic/cmpxchg.h:15,
                    from arch/csky/include/asm/cmpxchg.h:162,
                    from include/asm-generic/atomic.h:12,
                    from arch/csky/include/asm/atomic.h:199,
                    from include/linux/atomic.h:7,
                    from include/crypto/aead.h:11,
                    from net/tls/tls_device.c:32:
   net/tls/tls_device.c: In function 'tls_do_allocation':
>> net/tls/tls_device.c:374:8: error: implicit declaration of function 'sk_should_enter_memory_pressure'; did you mean 'tcp_enter_memory_pressure'? [-Werror=implicit-function-declaration]
     374 |    if (sk_should_enter_memory_pressure(sk))
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:57:52: note: in definition of macro '__trace_if_var'
      57 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                    ^~~~
   net/tls/tls_device.c:374:4: note: in expansion of macro 'if'
     374 |    if (sk_should_enter_memory_pressure(sk))
         |    ^~
   cc1: some warnings being treated as errors


vim +374 net/tls/tls_device.c

   363	
   364	static int tls_do_allocation(struct sock *sk,
   365				     struct tls_offload_context_tx *offload_ctx,
   366				     struct page_frag *pfrag,
   367				     size_t prepend_size)
   368	{
   369		int ret;
   370	
   371		if (!offload_ctx->open_record) {
   372			if (unlikely(!skb_page_frag_refill(prepend_size, pfrag,
   373							   sk->sk_allocation))) {
 > 374				if (sk_should_enter_memory_pressure(sk))
   375					READ_ONCE(sk->sk_prot)->enter_memory_pressure(sk);
   376				sk_stream_moderate_sndbuf(sk);
   377				return -ENOMEM;
   378			}
   379	
   380			ret = tls_create_new_record(offload_ctx, pfrag, prepend_size);
   381			if (ret)
   382				return ret;
   383	
   384			if (pfrag->size > pfrag->offset)
   385				return 0;
   386		}
   387	
   388		if (!sk_page_frag_refill(sk, pfrag))
   389			return -ENOMEM;
   390	
   391		return 0;
   392	}
   393	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

