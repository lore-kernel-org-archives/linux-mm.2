Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414FEC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3676B009F; Tue,  7 Jul 2026 20:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277CE6B00A0; Tue,  7 Jul 2026 20:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BC96B00A1; Tue,  7 Jul 2026 20:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB47E6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:31:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49FFD8E484
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:31:39 +0000 (UTC)
X-FDA: 84963731118.03.726B685
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08BB81C0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:31:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wZd7chiX;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783470697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zryoqLpY5XcbZJXngdfeetx+hhc/I/xTEt/aoCxXbTw=;
	b=XcLHu1QAK4CvgEtdwopEc2aD3BO0MZM/JNy5WWFNER9qtsxDrhlwnAKpKai7ASgMR7hdzK
	gU+X1VphMJS8Q4TJu8NmvsjkYE43zpvZdOcr5tQA8HeUkGtT1+kJf6AUKQAYtit/lD7Y+y
	vifT3K6Q0xCQhtOA2ZQe6cvwQS3LDCI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wZd7chiX;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783470697;
	b=YQQ0hrJhblKPjcOdm2Z5IBuCa3AEYRDSwg2mM+i4upfjDU7g+yNwmSyRdCQyCrU13A+Scq
	qn2WOHhZap0t6qF3d7qjA3FidWEo8TmxuvrIp400kESnIfiNpKdt7nATTk7c5L/Ic6Crle
	fyd3fE91IxStjB8JgArB9SpYaporhhc=
Date: Tue, 7 Jul 2026 17:31:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783470694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zryoqLpY5XcbZJXngdfeetx+hhc/I/xTEt/aoCxXbTw=;
	b=wZd7chiXqMIHJ5/8OfDPYrJ7LFoLqsDa7aEOq7QpzXPekS3QnHdYiZNSWF1vz8+QF4LbKg
	bWuVsOIsC2ByfC7tQZvhUVEv702FwmStEl9Fl/muJOPeOwG1Wt+KJchE+EGSWO2toNpgOv
	+8rkP1aaO7Fl54Svwvr0VdVVdt6SFSM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Ziyang Men <ziyang.meme@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
Message-ID: <ak2Wpk6OnhTyon65@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
 <akxW5dzvR9e2CfGq@linux.dev>
 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
 <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
 <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zz7mqu8ty99a81xs9pty8j5yqr3unzcf
X-Rspamd-Queue-Id: 08BB81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783470696-102293
X-HE-Meta: U2FsdGVkX18rRLaoxCkpZ0+Pnnh3wscVKlYQ24VMTUHFujq8LVXLZk3J0lt1QtSEJ42I1HEA5pqzASBwUqVCfjlgrguC8MmpIwSY9IWPB6w4YHJrqV2FZaZKNLjsk/CpPvAVBBX0AHtrit/ZgPz7JuTcrJi8fvXXUUM5HM9cnPlMt57BJgEMprzFB76KZG987Xd5Jga4CcrfMheK/4yXWzHlNM9Nk//NDtvlmhN+YH55KDS2RJB8BvSN0GXSMZP5tZNcJWfqUJOmAYgXN84SZbcuGeJziedkgiryKhFoT5seS+a+ktEvRYxI5rMWRxkBoH0NTUlxkIg9/U9YZ5pRwgNWdmoMiKk7L9nI07fIADPyAz4eH7WFKoSchKNpe3G52bBq+ngbR8FIMK3EcIZFaXM3CGGKmcWxZaOvYg7O49g9hH6oOaHI1eLfFJcNTUBfpfvDDfVOGV773JapXofG65Vfv8qo84tZD62othG2YYbA0qtnnA5nxl6uiQozl9pyO+tk8Uk0HEP0OmeJrnDBFjmuJYCu+mm0ukn+HGnXoNGEBLB0WMgvPtjQF9iIqGfqmkRWhi21wbUZZkBvqCab9BR20MXLo7hSSBS2MPbrf9f1fHc7SVLXcuY0m+CHSmyk2JmnErZywvxUsEb03m+ddOkCfThxcfwN4quEQk0sxgoGPKttoU8SuGIgVG69mvdfKeXP6QN4dRmIp2VNGCZwS0G910WZUA6X/BEdX35OKq/iMNwv1n9DQK0yatYklH/mUicjyYQABbwYaXVvzZmASoxGT0mQqnFpk28Ngf3+QRrDOxNOCuCbFK+0tGOmi3EnEcKIT4pnDFo+zZhoSxJRTXr4IsbDsMcb4qTca5uq/NJEt6O+I4QahXmo/+7nZjkNKFwBa4CNmHeiWMFW/hGxP8f1u/eXCFSvd/vCRIv/wHDboAvrWU+n7ahSSPmi5sHYpV6gS9tOGflUTjbKB+M
 K/XXp2c2
 42DaHjc0CEdPubzw5/l8QlRb8EIOG5hrsk4XW8zk1xVYtPBaKSsVaiV91gISonKB7BIZmOapajgfebD4rkHurFnE1xXu5wm6NwLBVsYBn4FQM7pSUTBjszTkwRdWy6vOyNx5XfYj85S8eR/1vN8J5Bgy7goszubVYzR86p01YacZryxo5V+qGuRFWjqoa9Ev/U27p4bntnXKNtrafsKQ0Alx/bZwm7uZEGXRx9wBZ+T29dLPwCEb5b8v/oyDaH4yvmuyrD+qQMMXJEWhbGN/pV1XdmIn8EqgdDYOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 04:50:11PM -0700, Eduard Zingerman wrote:
> On Tue, 2026-07-07 at 16:27 -0700, Ziyang Men wrote:
> > But the patch also carries functional value: alongside that comparison, it
> > checks the correctness of the stats the kfuncs return.
> > 
> > Let me first answer the main question -- what these tests add over what we
> > already have -- and then lay out a plan.
> > 
> > First, the static test (memcg_stat_reader) vs the existing cgroup_iter_memcg.
> > 
> > The existing test calls the kfuncs, but for each value it only checks whether it
> > is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:
> > 
> >      memset(map, 1, len);                    /* dirty some anon */
> >      if (!ASSERT_OK(read_stats(link), "read stats"))
> >              goto cleanup;
> >      ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
> > 
> > It never checks the value is actually correct -- i.e. compares it against the
> > value in cgroupfs -- only that it is non-zero.
> > 
> > Besides, it also walks a single cgroup:
> > 
> >      .cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
> > 
> > and reads only five fields.
> 
> Arguably one of the the cgroup_iter_memcg.c tests can be extended to
> allocate some mem and check if the value is reflected in the stats.
> But there is a line between MM tests and BPF tests.
> All BPF kfuncs except iterator logic itself are thin wrappers on
> top of the existing MM functionality. Hence, I don't think that
> BPF selftests are a place to stress-test these things.

That is actually a good discussion point. Where does such kind of tests (i.e.
testing that bpf based memcg stats read functionality is equivalent to
traditional memcg stats reading). As more subsystems are exposed to bpf, similar
questions would arise more often.

In this particular case, IIUC you want only tests for bpf related code (wrappers
& iterator) to be present in bpf selftests, right?

Personally I don't have strong opinion where this test should live.
Functionality wise as it is testing rstat infra, I think cgroup selftests might
be better home for this.

