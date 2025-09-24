Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCBACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74028E0013; Wed, 24 Sep 2025 16:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23EC8E0001; Wed, 24 Sep 2025 16:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECEE8E0013; Wed, 24 Sep 2025 16:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 964DB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:31:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41D93C019E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:31:19 +0000 (UTC)
X-FDA: 83925288678.11.8286FD6
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id E44291C0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:31:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fJ3gZJpe;
	spf=pass (imf21.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0+dvx2lYJR8T1XW8VPNBKmpFkkDU6diMas9sdwovb0=;
	b=Pe/4n632F7cMmdmUVaFfy/UWEeOMYus2zQ0wpRXiS4RZk1+M/bYRBof9iJ7N/VLWi0sXAM
	EzLAwZ4NJq+LsNwk+KUKPzjkLTBAgXBIRxcVPJ9U721m24uUIxopbLNt+O4H1AkfHIQT2B
	XnuyA3iWKVZbNizPNJLgbE3c2OthqNQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fJ3gZJpe;
	spf=pass (imf21.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745877; a=rsa-sha256;
	cv=none;
	b=kTV1GYqN9Y6Jhy94fWZzYYybt3DUuHhjhJSBP7YI/tPO9I/flawOVeMeTHkYaDrZq9ghp5
	/zLQ6ep3T38HNyzVGOvBlVV1O5OHlHdYfJaw0zJx5bRVWAYXuoaHtycwyQDl9LUhz+in7S
	GobkgNsNRSaueSNskE8Ae9KxCX3NtxE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745877; x=1790281877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v0+dvx2lYJR8T1XW8VPNBKmpFkkDU6diMas9sdwovb0=;
  b=fJ3gZJpef2STK6rwZu16WqZptuU7sIO1XG6XrrQVBthDt+iqlM65MUqw
   rF9qcqrGNU8AnUTjdO/mD8sIxXlczzjSpv5Gy2YY5Z8bT0TM9LYuptUz7
   2g2SMBknbiPSsjxiXzf/xIwH99sD5FxYaBg1VDjJOw9x6KK5wfowear5G
   hU4DujRbkUVkrEzJV0uXoUWlinPkJAQk5l7XX+4v1B8F58Q5kYvG1lpRO
   t15CkqXAp8WhnGy/J3+91f/2V/7aXTlXXh2xgLkFk9YwkcgyRE3aSRuTo
   JXZKWa9/NycdH1X3XfOhzV+29tCWcTH5aTKG+mXeu+1YiVRdp4evxupZm
   Q==;
X-CSE-ConnectionGUID: Uw5j4F4JTfeGqUgItqrpUg==
X-CSE-MsgGUID: eU2vq0CsQVOuEQdYe4Os0w==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2630141"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:31:15 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:24720]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.97:2525] with esmtp (Farcaster)
 id 0cd3d026-f1b9-4f1f-8262-2448e8915340; Wed, 24 Sep 2025 20:31:15 +0000 (UTC)
X-Farcaster-Flow-ID: 0cd3d026-f1b9-4f1f-8262-2448e8915340
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:30:58 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:30:22 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann
	<arnd@kernel.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH 11/19 v6.1.y] minmax: improve macro expansion and type checking
Date: Wed, 24 Sep 2025 20:23:12 +0000
Message-ID: <20250924202320.32333-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: E44291C0012
X-Stat-Signature: toeh99mtncj9waegp1tz4wz7ig35jent
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758745876-232822
X-HE-Meta: U2FsdGVkX1/IeuLBJpaZKnxIsXQFYfoc5teawJTGvZzvPQ8cDs+LzBD3Vp2aCaYgOjyDeTzTFvDJ1hFpaJHToEAhHAnGqrIuMlp9a1BnMjkrZQlhRQ+Flfj/WclLJYEW2fqQM3viob4rx7k4DkNYQuuz17q00iCWGVTthBxMLeHTF/+x/3Xw5Z3AxBmobRGgaLlaOFg/ZF3bmGqhtSuZx0vqL94YSXY2QfPNZCrNL3RXU/uCuvDfWxpj+oIxgjRmCyZiE3kic8/qh/GXnyNr/fVzXCNRQW0v61ZiVjvOg1H2mR2/822d8RrZBthJw5s46Ybr0Il1/1ldpBD0dx4a/kKPOmCQGnmPxRmExfdL+oI3GpDsMbHzgYracwxANS3X2ZwdQFR5z4biy7GtVeqctMqtUVWObACNU4l9mDQwqTPGP1fN8beghsWyap9l2cF311tuPbW4XsphNd8ovtcrGqAyhTcgQZqkbGRbEQZxSc3ooL/AyfcWvvZPif20uhFf57UqR5q4jvDTFQJRJKiIN/JgnO++oEOm5vKvXi8LzVZY+vgSunIrh3fXzeL4U2Xkp+HoIUYGRcMK6Z6b+2GVZTj6DswQjziQzO1h3bd69nhPD8bvGxVOlGsC439OzNoaJmdaK/zYNsehGOpWGEA1W6wsYK9tGQ5hK9oLdhWVDv0C43zTgdRjD29TBOVpjCslx3JSxaYjSQKQAj8mGqLo2OM/q5wDj51JtzSCGfDqZ9Jfdo3dbx4/6OlsCu8zyyBF+zRKduEjo2n6sZLnRR+SWfpwmPPaVb5QcMb/ZmR+/i6imkAjUTlKUmbBmHNbyH5nX5ihqg5nj4EdbAXhEU+Z/EZK83YSTFLw5JgP/hS2RrkQEc+qG1agdYhINnG2oQRy9WU0wbp40lNmhSRaeFfZwq/5O0RGsA6oRTy3Fh0cXNVxk5MZrVkU8Yh+3/Ln97q4LQFL2v+8Eq/qyFiwT3x
 4dFCqPWz
 Icb1ZYZ+w62JiBub7oGFmdXnYVuDj/1WSsVaohTn0PqzJyA8A8ooA52qKP9WkTMHP6doi7/bZ5yMMG44/aEiHf8gF7eKnsq0FHySls6xh6DqfcBFzgEgrsxjSjT/hGHddzSSMyexDds+1u6+tHjFmGz4C4TkJ5dwPtEoe+e6L5NwttBfuQdu39moxBjN99Dkc7QxCw7TddkQpKFfD0kpUISo1/sfDHviEjtYNerovPfZCUwhtPeGJ6MpMxgcr9IgFNe0b30Xf8zrFhqvHHhv4iGBafJmRvukHFoSd+yvtMsv8T+rDbKsR8MXTnj/LEdZ4x/jkNWdh1IKf59Ce7z0fdgeHK8EEc1QHga0j8DCZsauh4Y1YYsvFvbiyrgbmVjJBzb4wzXqE2FtOPK26yPXp677Mqzl2aQvN2syFl/x7nFadKvtFFmIilMBshXZXY/RxJxI9FlxAPzrzeMaTMEuOphSga8AQcwDwY6aZBl0S0eWmrc0IY6qIlNyDtrYbZbW0H2b4id/YsWOx+F7I6kjb2SxHCxf8uoRFF181bW1S1LujMNX1FbECK1zvVQcOyYqLBvyigFkBvBZUJySe6EjE5YpJl5mDGpBA7F1p6UOCRNSxgIqGOGK8VZrXH27PXaWNflqIINhFUExgI/wFK6GB+LD2WFpniCFPUB48ZsqU3Ax1eHShaBZC5kbf/aWkSsAbJk0L9BMawd9UoxSUOt8hQyvf5/nGfaKgKcoPOZw/4kLymiWhKgC7e/oYkZpe9H7+no8nvEgCf4qlYWthZmJ2Ok+c6hyv3ZbLBxqexAd1a1vMf6IMA4G0d0kbvrJV7HjFzdwvS8gv1aDf2rYL87hJA1IDUwi/ndQu+OWfSHnGgp31zmLhMSpad6k34VNEGuY5Qzp7Gvg7+otys8ma7gqLtbiCKpdeOt8sKOrQbPqI3MLCMulCaCRNXf+tT1UzCo8Thp6YXB/dJLXVmkJ+HxfrV5C8W+Sa
 1I4uyn0+
 lgVxbA36Euo0kwLoB7cklqPIZFdUfkyAESMP0UAYAmAr1eOijNNxf97mgHE6IOl38g1P6NiAACX18+NRxZpf9+j8IXmagR5lKAD3VM2325JxA5qXMdDp90toWTASYjTPD1J3ld6cgItEc5Nh7UuCTeB7pAPhV+lvXibrzISWZ2ip/jb1iriDsLqE6+U+faNNEOT12eoKBh1fE58MHcwPvhleaTlp1EiwPC4ABJYzY99x5u84EtpwoclQTopuLlmhiazxV/ykpqcXOUvEQ/TPeuqDI/JIaCWGdgAXNXbiHBoWjnnLuDj8MwbPeid68Je51xFE1UeHVsNxOLtAIsIZN/e1+FocvRgO+NyqMm7ClZUbxZcS830/YOoRWfNBIJdanpYAtPTJ3svG6qap4ZkOgdur5G0ZnZ4Izd+1hlmN48erdrbw/4PKs9a7ojZBuiidP/wHkkoAubnGSLu8Jha3Wfqh/HlmqPh+bQSlH7217ZuvdIGijrVFDWQ0Gwaad/A6lA628j47+5A5/JOdHpxDlCe2tarpbesT8X8vOjhUfm5eJI/lSweOrUjHRb210Sw82tfIQn7wPM+KuyvwRGOF5MuUK5T9ZOCVAM0jiNzLWgz44WyceAi/zk34N5XydAvuSvjfZ/w2IPsNRdZuRcbt876JPYdlNdfk3pFLfngYEL0kGVFnQZ1+6IlmBSGKQNwFdEGOuftiRQBJvsrNV/fmFDfn0NP3U1CQGtx4Y++zZ8GL0pcIzjosNANB7yIlhwwQgcP25yaxyA1dvXSJfLRhXYi6m4iLM3XdjYGQDb8Wa46ydJkV885h/HgfE9DL+Y3oMT0Z8YAdt8gsC/tE0N3HRAamT0OYiEpYhbD/GNWkn41THg0eOe7EZ1lkyZXZU300coyQUa91tanAVkSzjF4L29W9rXAVqHztKUwzpzI38Qk4XXyUJCIkHltSWFU17q2k+a5oVUoWUz2WJacTi+aVm3p10qVwb
 Y7sFvSK4
 4JzH+LpRqfyEy6OagPHm11rjpJP7nqA9HGngeNZ18AzhjkN2Y8Zz/T5IGa2liAi7Cmd3OOwRfroITljP+vbBmunJnA7gSCZ1u3oUODOIckWH1RNUX135bEROcAXUanRgLw3Ys7oVoASGkjx/o6ZWBMRbq7x6RxEASA096YkpXdi7RXxD2gKMkywaQti1NY1UVsDlWrMCtxmpo8dJtfJQKe+8mKEdTUXtgpcIHVEVy18zYU0HdbNq1SkVzgMhDB7G7oiVtLZvIpDhqSL6OA3/qfvw/VmD4ehhWLT4+zW1hCa63ZCn8Z/QcTeC2DkQcN40LhkKpP8RukyrgCbRiqPyq26x+Yjvd3vvLi3s/m2NJjxz4+EgyIz8QYC4OPoFScyjCHfV0bQM77qh2aXjpxA43Bys0XUH4TLBIJhmsVHLWgT09Bj904HooKdxZym7uOPHeQjsZuAMhyTCByvqmCb89vDumK2vTO+xf1kSWvn4MzZYRNxhPLEEpZ7skH9Svrlaes+xlKjZ9XZvg40lSPihUMecoxebaZJdjwRhxNatT9RJ5n3CekzKXiqsLvHG7RG7FPeZvTbQ3u4nrbSNeAH6Gni+zxMvH6gU/YmugTHHIqdaZObmkr32w1lzrT78gI8a16Ui7hQpGtsOu7KVh+ft4c4yZfRFam4Bh6wVRDAK5nR7o6sOiNi8jk8MWY1ilWChd28PffKvkQE5AJDmE3RY4RQt3hxulix5CMZQQxWT5Pi4mO5WEMB501GZp5IuA91uPExErXqQ6zik8O09+xF2ITE5D5dfvkL9DOLbCP8wGFuAO1/1cbxIdoQjhLm8JoAd4aOUkpbQM0joLFKiVBk5GyPzt3RLJeJrtV38nr9i989vf9Y//Ei9RTEsHNipLPbsUF9/plenOYn1Fp3X4HSmEStmMcyL0mZI4NK1zailqdV3klqdpT/Pw9GKyA3hzRhNSUnnQRsftAXeTo4JVoUv3kDEMhbBr
 zLL2NOmS
 XWydsaeZThMqaHI82Y6/ZvO0/dKW/4aDDJQYV27XIK9ZB+T7L9FiGhfzMcv0+dPyfzr6aYBOG7VmjHU0Jq11RWrLs4Y19KDhUIZtD8oLqYJqmPBTW/p9pmgf0YVf8KW48SHY045VKWAPFUxheJ6H0Y91vWFZQ/gn5wKSJOe3EPLdMPP3JEnu09jNj3aPs1WOBScd9xqo0unEjApz3wBIast0FpW5qts+ItdtuBWvCqg4a03pbtH7oKa0A65nCx/a0bSNiTvu7DBohchAQ7Gev8oCKtonRD9UD4BW18TxzAJi/9sDuUMxlFkVtZu1GeATJfAHWhZEpyDGU6LqPFM9ArjsMqxcP6em8x9HVypqJjGzTTPv8nYk76fWgWQjHs0F7QzMaox/cy0F/TjTVIhxKHXdiEmsDluKxNAdc63qTt/NHE+YzFTHutW6qGzZAJ0wI4akcvXlnG8MvPJF3UB1VP4JUrJOC36Kaun3iA9fpEl8EuB4KgcPElk6sv/ZUZSFknCbwYoHBLDVMPRolDEMdlJh4lIZvxJPiebqKhriPuGvKUe1aeMy8sZBQTlB43Dp5aJFaPc8vlt6ZYBSZNHskhwv6pOSayXfwJCjhDNfTeeBS6EfnWCxcHdNN+HN4U5NgiJseK13yA1Y22vikPUOLiZvo5/5rcXWbiO13HTvFPfm5K4J4/zDgO+UrHZx79d/ztQBMDgDgMbSsdAiZ6Q4V3CH3JInHsDe6Sf4vC8rYg2nmg5NmJ+H4N4Eh34GdQdAn41571heCbCKHkPmy5V0KY5c3WGdc9/5u33C3wrvkBhjG9Ubei5tVZaMUWE2rTFFH/vXwUPTPSPYeJRCqdtJ2AeDauz1scMpa+EhUr3l3iBqy/PbP/j6wsRw2S+Vpd1lONlL5RNXUZ2WyT8y/6gBNyJo9rvlRlXptzzMuTX68Yp/dwhowdKzwm8tgQHG2G7xfuzaJRk4pOZenfu6HjKDMxvcH6p4H
 E/hxZv3t
 XXS/d5u/3JAYDUrybafUTEp9caew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/compiler.h |  9 +++++
 include/linux/minmax.h   | 74 ++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f6ea15821cea..a6a7be83fae6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -244,6 +244,15 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
+/*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index e3e4353df983..41da6f85a407 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
 
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
 
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \
-- 
2.47.3


