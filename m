Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8577606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=c8C3R6P5
Received: by kanga.kvack.org (Postfix)
	id C6A856B07A8; Wed, 21 Oct 2026 16:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B296B07AA; Wed, 21 Oct 2026 16:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58A96B07AB; Wed, 21 Oct 2026 16:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945776B07A8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:40:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38021A06A0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:40:06 +0000 (UTC)
X-FDA: 85347800412.26.0FB5E89
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 620F7120007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:40:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c8C3R6P5;
	spf=pass (imf29.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792615204;
	b=oomkG0RHTHXkaJUDyqWLFVw9nyjD+IEnm8ac434GrHr2O3Q6ST9aRukQffuNp30yRe2h03
	SJSWv/3h2/sCDoOBSXHk5HDZ808wTCkuJhido9lixUc17yDLEDzHznVhPlFDRoyv3H6ltC
	wHhORKc19bc11oLa3iWhBL/iu1lLeoI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c8C3R6P5;
	spf=pass (imf29.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792615204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juErZhvjoSkm5e8GzLZMCvXuam8Gd7RIkFvc7uAIv/w=;
	b=g45PvARqAyM7kcpWOaOqaiv6UaUgOTlssLleKXI/1b6C57wjwJuQsB8KjIDSGTVRIImEWi
	ZjmsmEA2XMDI6I0CipnJrvYRaPZnjVZ0dE2ZcfuN2A78ksNGcBj6XxbaBETH1JleaknfE0
	LftMLf30y7Pa6DL3kBpfEDOzk9jtp2E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792615204; x=1824151204;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J5q7gxHb9njBGGMG4RpHoR7VIzzwmBGZbkkvnhJBKA0=;
  b=c8C3R6P56SfYYYpv5JB3yw+2y+POPiEJ9U3WvHJiHmWaosw2cDrJ37LF
   yOjDDKONxjAroUTIiCFSgbLn2uVrWpjrOBjsXNz+9u5VOjed3IQf0jxKd
   uniulLptGKs7GhqEsvnMk/CCzrgE9NOP+YVmIQj+03cTS2zQpIp9cNPJP
   lv56yfCCK7GlAkb+r5bkS8Etu29UCLoLvicRwyR7k00U0RopOU3BzE4eK
   UdY2Fba18NpVBtvPrnqwURX6/UFkWgLrj0jL/AUlffg7BaZGbraAi7voK
   9X0d1ZfND0TNzn3z8ofc5VdDcUZRg86EAAsp1r7ZErS8n2q0h00sbti+z
   w==;
X-CSE-ConnectionGUID: GosAbcSPQp2iWLfLiHO0NQ==
X-CSE-MsgGUID: Hw3FuWMKTkuxGn84NXPqBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1257295"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1257295"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 13:40:02 -0700
X-CSE-ConnectionGUID: x2Z9GKP8TG6vbIsZ4Fic/A==
X-CSE-MsgGUID: 3/BEZK9pTXOVpTGnUawn+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="4982516"
Received: from unknown (HELO [10.241.242.209]) ([10.241.242.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 13:40:02 -0700
Message-ID: <cbf93381e02861620b012ace93c816f2c0822fea.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc()
 stub for !CONFIG_SCHED_CACHE
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
 daniel@iogearbox.net, 	andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, mingo@redhat.com, 	peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net,
 tj@kernel.org, 	hannes@cmpxchg.org, mkoutny@suse.com,
 shakeel.butt@linux.dev, 	roman.gushchin@linux.dev, yu.c.chen@intel.com,
 zhao1.liu@intel.com, 	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 21 Oct 2026 13:40:01 -0700
In-Reply-To: <20261019064157.29885-2-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
	 <20261019064157.29885-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: gjr6unjzc35onjpdnqhj55yzgcwubrs4
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 620F7120007
X-Rspam-User: 
X-HE-Tag: 1792615203-296095
X-HE-Meta: U2FsdGVkX18do/O6SEVPgEu3bzafRR8RqpGIiCtU/jBhPaFqJjw3r3FD7OMCZyj64koETMPw/FzUxEm68JNGnJYzgMQQ3h0ppzo6IgavVkPAdJUiXbYwaxr3ugqB0URr8sfDu+HlKxwMkl2QfMPiTk9jtym1g/6ePK+r0PzXseOeVfXCWO+lCa01ts7Iks8U2VKDdJuIeCTXURnbVWQvqsxl7JvcaoUuijOj633zvLBHVAN+zbfvI0ucESSvdGFgc3sKhyIr1CEVdWWXOJ56MS6/v+zzSJUN2SmTuyzC1saB7RELp1f+E1ZO2SV6OAqHrmNgbMcs00+Pxl2dy7Qo1jqz0eLmaO8Y1ykpXs3l5xQfwFHVcuupZPNzaflzHCdeMc9xV5hCeKbBUqrWy4KC0J1ghmZl21/P/Pq/3rEWXBYNao8ObgHsxcBeZKaGBx/zsLVlYPrinECEaw1bLa3vAL+gPp41sJjZF2ZZZQAEywTeAiqN9UvVyt2OBzqA7fQofEKfHsg1pomw3c4XEVRhCnpORdFo1SX3Jef8PEVpf+7Hs5w56mpa7qruyTsLZGAybFB+aAmOUqIrWKhU7WVvaaXR1vxRzOJjN+ZHQixzv1HIcqI00hGJk5FReXbwxGKg7ZPwrKevRtc/4HLTrX60FeGTK3VZ8ok/wifYAXhtxqObogFIClaIO1E1WAXdROCZZLbBVw5BPLTWaQEsFNIBIDI5V/HL8Pkhwx8bVIIuY9zIp6uWSqM4FUwaMgrmTIXHcsgrX9UZHqfRkPI9P6tVzp40JsMHC6ALYBB2X8v2/lDF2HyFfM4y3mWL0HcBXrXNH7Yyg7sYEN59QXQV8mIfZgsgC/tMJIjkLeMk63dG5ztKXd1NCGx/H3KB62o9qzyGHkaiVUBlAFV9AouYmQX8D5+s4b4g9fKgaGLtlYYRxAF24WKDsGzCOelqa2UriLYpN5dENBxu4Qa7e+THfD+
 8wFxcHsB
 3afgX29KaDp/GayVeSFa7724tIWllSVV4zotZTACR4MihYHkXcDG11nXFGKm6a7/R36cJHMdhfD2Y4OXD9NNSOHjB8JA8VTh8rfKg4vf+GabK/VpsmszpA9B27OjFHkCz0r/nRo//xe7rWIrncWAT7cNYdbQ84++nvEjnVwwALpriAJ8Tuofi/rJ6mVJ8b41T3hrFCC82auibGIDC6ALaP0o1YnZuJbRwEvOKWX9/g7QEqk6uYcPQvSzTfmeILIphf6gdQFCQkfSYwmzukLdwdE3VSvP65GnEacepgsg8jSYMQ2kbkYNn+Xv/djmN7bup4rlpCwBgFPCuuBhokXTfpmb8NVmTgwWRnB4bBWZyeEFd/qdInqmHKBwy1riakXV2tv+KF46lxN7AFk6FMKplwpZvPuQCorAnmxZW9XxtBTpg3KsG5e5965S7lKdSO6EPW6s3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-10-19 at 14:41 +0800, Yafang Shao wrote:
> Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
> to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
> taking the task's struct sched_cache_group *, but only updated the
> CONFIG_SCHED_CACHE definition and its caller: the stub in the
> !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
>=20
> Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp=
 to fix UAF")

Cc: <stable@vger.kernel.org> #v7.2.x

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Chen Yu <yu.c.chen@intel.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 57360f5cdde4..973647ad6c2d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2194,7 +2194,7 @@ void init_sched_mm(struct task_struct *p) { }
>  static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
> =20
>  static inline int get_pref_llc(struct task_struct *p,
> -			       struct mm_struct *mm)
> +			       struct sched_cache_group *grp)
>  {
>  	return -1;
>  }

Thanks for catching it.

Should be backported to 7.2.x kernel as commit b636fef85bda
that this patch fixes has been backported to stable.

Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>

Tim

