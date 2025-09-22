Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59531CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797CF8E000A; Mon, 22 Sep 2025 19:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FB38E0001; Mon, 22 Sep 2025 19:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6853E8E000A; Mon, 22 Sep 2025 19:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 509BD8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:40:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2E281399D1
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:40:05 +0000 (UTC)
X-FDA: 83918506770.11.99FF48F
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB7AA1C000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:40:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ksO/eRpK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758584404; a=rsa-sha256;
	cv=none;
	b=6eTqMENhU4jxYjDBfj7JanfFni05/MYGM27fcNAFlZf8hD4L795qpcODOQHBELDMRYh2IS
	n2kf31L7NUH0/NMGIX8k7LLFtZcPuI0pWCwIBgwTlvArdKaaN+xsx63vkmkwe8OSfSaV+c
	PP1DTaQdvfI9KiODCmomPh2/n75PI58=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ksO/eRpK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758584404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UQ6EfbCYepok3ceoUDeJ/x6bFVJ/E+q/zzBwjTLLp4=;
	b=yze6Vl535PZzEY9B7UZ/5+v6i0lOmrOezmKxouxbALBO1m4WSzJ/GlEfwv8hXc3Z0goRrs
	dMsgzbxfVWYHiy3Njptk+X2jLe3bHwQ8p49ol60/ngCaMVSLbEsI9qFylr+cxMzdzH1zkQ
	8be5QLIAv2nQGVJj59cAJOIOQTE5uOI=
Date: Mon, 22 Sep 2025 16:39:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758584401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6UQ6EfbCYepok3ceoUDeJ/x6bFVJ/E+q/zzBwjTLLp4=;
	b=ksO/eRpKDXXynNESrLmMo1u81CH/LwY9blsXfMRvkA6O6cPUQuZ0v5Nzq6INeIbeJcqmbI
	Bv6aLttCnAEx2rrt/l3Qumlpjdp4ukS+cXgCd5odAtNGUWw7827V3Noc4C076aDAEus9Lh
	zY5U6BKC5S3WXSc1AeIrIIDLwp/lrOA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-ID: <552lz3qxc3z45r446rfndi7gx6nsht5iuhrhaszljofka2zrfs@odxfnm2blgdd>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
 <20250922160443.f48bb14e2d055e6e954cd874@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922160443.f48bb14e2d055e6e954cd874@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB7AA1C000D
X-Stat-Signature: b9wrhiq9fohzjfmk7q4fcygmrcf9m1b4
X-Rspam-User: 
X-HE-Tag: 1758584403-30611
X-HE-Meta: U2FsdGVkX19RxJDf2p3gAz3RrSui33/0EPMYECLUUYCiEP2Y0gddzOd7lPqAt/R+jQF+XOe18HK3jOR36p2ibQ6RkracHMAj/HSzo/f18+/qCEQ33TCCeBK8OsvjZ52PfKdjQtbsMshlX4wXchp3TDJiHo+DjP8w80t3SWITVoqJnHy8egNMGW0zts2tTQX4oiEoV53+fkAlk+z3SFMGvyKCGJzUOnebVytmBF8o6etPx0ZZRKaah39y2o6k9+O12w7paMw26ZpRcMf2M2e1+pIhBqh/TpUXFHS94E3/w2tKTS1ubhjhwrU42cR1vQCfeWPFBDKnnG7P7gFPNUrurks58lv7oWNev3QxGW3/1Dkz67BPRER7IY7h2deZ3yTvVGmE/ntnWMHV0TrmdBhtw8mUE4jIE4H9yXFQYl0JkjLwFIVTp6/yA6GQiP0pO4+X9Eki28ZZ7le0nJD4OHPLtB5GJwK11XuJ8mLWe24GUm6ivFOF8uQweltpCMxIE7xgbZPkq6/SRsWsjK7pKVJ0Z9RUBCjdI0fGTXAoLi8CBZg/NWHKgOaMqWacGbzEL1CJ+UKYgQCUNe+4g5zYgWpqCy+bvPZ2Mwvohf7Nmjgm98yrASeAzZB2o/8WV4fqZGVH+RHOX357OXpPGYqIKqWTWH9WqKBjyflp/5DedlH1TZfkFXtNeL48IvecY15Xyz0WnJFTqT0H4jEm4hqLHd0y2qe4/lzCmxw58UjZZbr8V/JuO3qeAFvoD0uMWZdnogLBG4j8nMf1SH8pTzv/AQqG1GXcWRrLtw3he/MaLMRYpmKbAu4yZ9QB+wwadKuz5Ebp4nWTnbN0KNAUtoUk4zvs+Fzbn6+ZegdrpBr/17m9RyEdEWV/V+TdWIcuOZpPPwVMVKndgkYcexKf98Q4s47YLyN45AP7E5RzJ5h7Iw9X188Bpt7gsZPIVxtpLs+3iFvZ466dG6J11qKwzgfde1Z
 sdbT+icX
 TEDwGHVoKwGqwUoWQ5GXJD56n5p4If923DS7nCPRlb+272aoNUQHUTn/j/PgRjT2BxfrFUG1pbYCPqk1iCO2vABK1cD7Drh/0CusjGAi7JL5YcrFPAR3aSS0DLktQHye3BxZtKnJXCAIfAXwKPPM4nNnejykvln+5eiKr+JOekiG69OUvksStkt5XEYYJLtOg3PVSGsuaXLhO3TcfyR/d0TE62LsqMfMmeoz1u+BAP7IIH6ftvGYoicxv2uoMz+hOFmChgcEW5wTrwDeuDFEwQO5kRnE3IlI93eXJ3tPzZ8AFfM20k8tWBO4YulsbO4Vosv3LA+cqFBg0s4MQ37gMx/WoiKXugY35HfEX+kyjjvAxj2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 04:04:43PM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> > 
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> > 
> > Alternative approach was also explored where instead of skipping
> > cgroup_file_notify(), we defer the memcg event processing to irq_work
> > [1]. However it adds complexity and it was decided to keep things simple
> > until we need more memcg events with !allow_spinning requirement.
> > 
> > Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Fixes a possible kernel deadlock, yes?
> 
> Is a cc:stable appropriate and can we identify a Fixes: target?
> 
> Thanks.
> 
> (Did it ever generate lockdep warnings?)

The report is here:
https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/

I am not sure about the Fixes tag though or more like which one to put
in the Fixes as we recently started supporting memcg charging for NMI
context or allowing bpf programs to do memcg charged allocations in
recursive context (see the above report for this recursive call chain).
There is no single commit which can be blamed here.

Alexei, what do you suggest? 

