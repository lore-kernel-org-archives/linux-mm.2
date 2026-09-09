Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34375C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 22:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FEA6B008A; Wed,  9 Sep 2026 18:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0256B008C; Wed,  9 Sep 2026 18:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9E46B0092; Wed,  9 Sep 2026 18:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744796B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:14:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C21061A0376
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:14:40 +0000 (UTC)
X-FDA: 85195629120.11.4CD8B0C
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF27440007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:14:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Q/AiMuBB";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788992078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5NkJw6oWjdsiphJVaybRhCdoPAeWbsi0cRS0OiEPYM=;
	b=3rymPBR3CVYQHcvCFgdoEN7qU6aDw136c5lGcTemRtiXfPrJgTp/KTsOo8QYphgHhf9lO/
	Apbenkaw199Wi7ILoeUPcPtzjhUsoD2YT8GDJL+/4CzkiOjg4ZDUpR5LHamdYv/E2wAqRN
	O8gW5d8wpMJDcajjO2+g3vqCXITkSGs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Q/AiMuBB";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788992078;
	b=cXT3DhY4AjFibp0oJb4Nhp5UqOuVFFVrK4YJuCQRtoKOTcLxOB3v1eg5vLbMmLKJX1YxKD
	HlXcqKQjzZdHQICpmhVFTbQK9lOX564XpHZJZEFKDcNUnWmTlKB+s3G0vV+pL29j6pMwvu
	u5hMHvmj4dP13l7cRZxVbY1fQG2p93g=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc6db0aso9977366d6.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 15:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788992078; x=1789596878; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C5NkJw6oWjdsiphJVaybRhCdoPAeWbsi0cRS0OiEPYM=;
        b=Q/AiMuBBTne+ulBBiGxwm9R9xdkF22Fe7TpsbuVu+yDDMohGO0TBeSJb8X95ExAaQc
         S3S4e3XNm2GFi4BJBMRrlNridxjKsRQCeQB72ZztzteTW1eGoOzNdUENI6wWyzWLIIjS
         gdVVbUrXoTFFOQehPPpLstws4PI1/7Soh9T4gAA8oSQLG+4Uw5r73KnFQLR9NRsVSyV2
         nkntcOzyn+HzFe33P6qUWeB8csirLt0xMWu06rnCXQ7suQKioRWGVEQTRapKv/7mdgqY
         M/F/a2D3+3OeHKEJjNS+63cNG6IBBcwur5ow8ir9vwuJu8NSQ5veHuwbAQeen8YRwFUt
         7I1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788992078; x=1789596878;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C5NkJw6oWjdsiphJVaybRhCdoPAeWbsi0cRS0OiEPYM=;
        b=tNUQ9k8kQsVb3cLPQNDIsdFM/hviTtxyPikxHB9FAg2gca1VpdyVimVzbOvG8tWalE
         lG0Yvp0YnxNOuCZxJVvvCUc8V+ubF+mfeMifZsaawOzEitbDgUFFllkysUGdOiiCSjIW
         JDWy8iS3JMExZRKxaHrSVUVs+OPGuqan72blm+lFfzT9hQ62FP6ndrr5kAvex1Vz+SGN
         jndZgnGhnCRJEHsnvuhGKaVL41veRKM+eyq1+heb+qOy8zvYj1arSvRZNfxB9bTdHK4J
         foVI/zv9p+47Z5RwsP5OXCD/NAYzJZvBnGAEiJHX9yNq9zN6sOOGYvj5zLlF6ZL4CrqK
         42gA==
X-Forwarded-Encrypted: i=1; AKwUvBwIbBNzWNnlJAmYGQrZMPNd4A+dDtyIhp8d+DRAXhQtbRTHRfsYJYoOiNgS3aRKuRf1hMHfBEfZOw==@kvack.org
X-Gm-Message-State: AFuF++mKud3exx5vSCSnhIoMDLKXgF/bcFzqKhu9ub+DYo9watP9fm7Z
	HXsGOnWmDN6ENEovZ+uZMhnTYJzJdWplDTEULX1ft61d4oZl3uLsHMyEtpgEhjxQjxI=
X-Gm-Gg: AYBFou3IdvDTqEO7skBOGvD1mPFEfDwL/fnvgmpm6/JMmhx1V53mk5SdWuVsQRiTR5j
	eXyHgRRxrg3aO4kNqX58PH9E7qccYZgE4nR9noqAQWBGhOXgb3Rp+BGTOsk7iOLpxR/6SLeE/lR
	c8Jcn+otGKMye/GPLRODx8j7/1HYf+7jcPH0FGS1YbufnJZ6Dcy5tBE8dDbhrR0dfhv5pkHqxZa
	IFab//jYVLxnxRLnIR3L8JlzJYN33/5kvH6Z3hnbhhy4jh/LUD5/0niy8NSI5TMIxi+7ZxiRxUb
	/lxcNQfw63PRXjouB4EdrxyCEr+VtN0gSchOrEWREHIJxBwzr1ezXg0IejpOGAaWvaXyehqLMtz
	d3mj5lDBh1wwQQroeGy2q80QeQjF8lAMcJXc3Odxt0+W4kLygbNNc7W23vO7o9DsYciH91XZSzG
	xG2zg3oRjFHqbnbwYZbsoQ1SFvD0pUJKKuWg090xPifhVLRYc1zshKS2aBfPGyyesbCyDv4uZJf
	fqNgO+ChQtxf6zx3YqGYrCdnJ4uqsPq5ahVKtCWNagbXzS+s12Fwrk=
X-Received: by 2002:a05:6214:761:b0:8f2:fbb1:cec4 with SMTP id 6a1803df08f44-910d104c019mr49748076d6.19.1788992077664;
        Wed, 09 Sep 2026 15:14:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406475f5sm151951376d6.9.2026.09.09.15.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 15:14:36 -0700 (PDT)
Date: Wed, 9 Sep 2026 18:14:33 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, Ye Liu <ye.liu@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	mic@digikod.net, david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org, rientjes@google.com, 
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, 
	pmladek@suse.com, longman@redhat.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, dietmar.eggemann@arm.com, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, mark.rutland@arm.com, 
	Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <aqHZ7lZQnugGJ0ig@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
 <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
 <ap8yoW37GY17pHYS@redhat.com>
 <e618ace1-6a8b-42c5-8a97-44b39dd1a7c7@amd.com>
 <ap-spMNyMvYFga5k@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap-spMNyMvYFga5k@redhat.com>
X-Rspam-User: 
X-Stat-Signature: iboctftp4j1x9e5m1pqzxoao495p7y7n
X-Rspamd-Queue-Id: DF27440007
X-Rspamd-Server: rspam07
X-HE-Tag: 1788992078-289586
X-HE-Meta: U2FsdGVkX1/D9A8tG4QZNIkAQQcoPG4vBidUJlovYWX47aaMN+wYKr5+YxwuDahOmM9XMUtlZFa1OmuJclipAdkps0sdjpb/7Jxnhk9XRSa9IPtbiVtjgTedXwUFOLmzsyOVjXfWhhLVOFEEHGHIwm1DSO/cQE1vNKHpN43iS1y7mU494BiDPpcKSy2KoXEinvMK6Ib84Vkw9K30NEYcX6qqZyIbNPC/OeWF9stje6CKjYCfLidqU8necoH6veTVHXcEM0GIWzESdSNmpbISQ2wDkfnZHVbwju5gHL30NTm2LBihDaT0q1nkXP0AF0RiucBBURisNM+cA5Y3kpfQC7wCo4Pkd41VYCbz5cVYCv9PN/EnQGVjKeLP6xdYlC30do94xC5+Q5QJnguicDOdqoUoySL/0cj5Zc6fEgvOctzHqchFax6jbUs+YW3i2fmYXGlnBFgYkTiGeEH6USfUXLWcEH+Ip/DfBM2IkjFGqbtM67HSpqC9mXaJ4WAlsJLqChK7r6EHCl45/jxpgMYpZRY4TDWrOTgef0JvEqrA6L8/NE9ubeALsDeD9Cq9J+G6xVD6LYxxvxx56V9fudKC5IOWDfkPa2xBrDGZkpVnygfwkFE9C6bY9FsiJ4o+P6HPr2Bg4CSk4lni299NTEHtmh9LRytIptZisYWBCpN6+lDqFuFezKTXNsAiJc4FY/WpZQ78eKSTi5LyJoj/6oo6f5f68RH7F1GL0BKufg7tZGdUCFRZAqwiSJtR0SCpehpGvrIftdj7sEWWUU4gxw8AOO7uH8ZeAl3mr0FiQaDmqbgtaitNX6I5zOJ2RWhUv7ZWcrmSiDpDmlJA4XM8sOf7y0dhSvitNU8C5CxLuUt7yqBYyyIm0A0GBbwtJDXi5O+AIeWDG+cw1Tfcb4AQ91jUWsPDw44IjKZI7KImGDjtuXyPPJJI1rfaRA060nh6vxlSFgHgtYg2n4YlqG2tV/l
 BDcwoduu
 w6oancdOAgioJEGfUuPbaNzRiPuUu5G0yq7efAzH2X971GYZVnRZ4tTkE72nTim1wClRipnfjXSzm1EVu4q34xSszmkmY3VzerECBwBHpz8gsfk9OQepDVv+uwd6Iqv8Tb/buTPeYIqYBAscjEvyNXkuPLal1bY/cmlBycIBnl13dtRS9LsE9xjIUmq6e5Z/4RMkWtGmY44eAAFWV6yGlLye5nreokPfyqg/95HJg39ZFBG0HJMhtPe14MUJeLWvU8Brzm1BqSc1qa9JLZcpUJZ1Y6Vjch5+3TM12euUS+lfPWhBzxOfvhEcUqNFbfpXlHhri0HHyg1YBnjWhTBJC/8tcXXpHb/SHj5H3BR0FehutIqAiqf+2AmRIhdQgFw3Rmxab79uacbdWCAeLRfitip1KWDVnDu9+GIzo5N80zplPzpenbwJ+hVr3FyrO9qttub9PWKd9dwp8ipK2YVpf0//kVZUnTzgdwZ8j2MoKvhd/Drd8rQKlvZ7iPwXPytrEx7wxscfGdFFX8Nc02igH/IMGFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:35:16AM +0200, Oleg Nesterov wrote:
> On 09/08, K Prateek Nayak wrote:
> >
> > On 9/8/2026 3:24 AM, Oleg Nesterov wrote:
> > >> This might be my - admittedly shallow - understanding of scoped_guard,
> > >> but does scoped guard handle goto correctly?
> > >
> > > Yes, it does,
> > >
> > >> and why it's generally discouraged to mix cleanup.h and goto.
> > >
> > > Hmm, why? I didn't know...
> >
> > Apparently older GCC would allow subtle bugs with cleanup + goto to slip
> > by but clang has always caught those bugs and refused to compile so as
> > long as clang builds are happy, things should be good.
> >
> > Here is an older explanation from Peter:
> > https://lore.kernel.org/lkml/20260327154136.GL3739106@noisy.programming.kicks-ass.net/
> 
> Ah, but in this case the code is buggy, "goto unregister" jumps
> into the scope of __free.
> 
> Anyway, I agree that mixing cleanup and goto can make the code
> confusing or buggy, but this particular case still looks fine
> to me...
> 

Seems jump-out is ok, thanks for the confirmation Peter.

I do agree the general improvement is nice, but maybe worth considering
taking cleanup.h all the way if we're going to use it - that's all.

The improvement is clearly welcome.

~Gregory

