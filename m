Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53EDCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186408E0006; Mon,  8 Sep 2025 07:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E188E0005; Mon,  8 Sep 2025 07:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0742D8E0006; Mon,  8 Sep 2025 07:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9D0A8E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:26:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E9F113BF3F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:26:12 +0000 (UTC)
X-FDA: 83865854184.20.1EA47A2
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id CDF4B1C0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:26:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ESKCuL+B;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757330771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjaNZ8WCue5JMPE+X6CKeyJoyDEhfXm+zUGpDnfbbRk=;
	b=ZvnXzluOi4b/Fl7+/sv58i3xF22j9p0OlrEyazIiXKsNf6GB1h4SWbfhvnbvNyshK5Pzgg
	cdgEYtrnfBOi2TfVHMKSQaV/EoqR3GrBcpsSJvjwUCs33VDpaiB55+MVRXpmyL5bcGcFeA
	wl9xG9tI50Sbcqdosf+TqhScp3otGsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757330771; a=rsa-sha256;
	cv=none;
	b=QtXmNClHK6z7zFekZnJ+GnzFht5BRlbAEaKHVNDlXxVClEvC32ZSHaA/VBeXxeE+Dagkc+
	fhFucVbUV4l1BcZrlOI68P0uihYjvfoJiDwqLx9Vzdw4ac9qygw4j7La4BS8TVOCP7YprA
	oWSINb4zKKUVdXkgWyTI3f9w6rY2aCo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ESKCuL+B;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3e07ffffb87so1959237f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757330769; x=1757935569; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GjaNZ8WCue5JMPE+X6CKeyJoyDEhfXm+zUGpDnfbbRk=;
        b=ESKCuL+BtUp0uKlAPp+LIz7lf0OroYMcIE1N0I4ZOUo8sT819M9EDAtW6aNc6NtEHh
         xuM/8DaIT2LOibYD0dVzZ7BunpP+ahMAuD1VBNE2DDnEqzIZ40u46NjmWdRPr2PQFGic
         s1Fd0TgtKPt8bW33zu8D2ovODH5p5oHOQr/OECQs0+iOPQnhxdziw5rBtLnVhBy2MA/1
         BjhqcDMMlajrXRd5TDOA5poQcCXk/tlIv2k0Diiaw2nI4fouhiI+U0Czkko1fuBEInu4
         eDWQXn7c7weRza7jtV1XEhucg0fhpvkLqD2EA9DhmT8iPNZserZUSjQRjkSXvf72QOV1
         D16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757330769; x=1757935569;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GjaNZ8WCue5JMPE+X6CKeyJoyDEhfXm+zUGpDnfbbRk=;
        b=dOTZYvw3WAmAvjt80SVT4B3MptRZViCHxnYlBfWtKPKwnqLUarVjOc+/4n25CeD8Hl
         t9S/EkbfmeB5jE4MFQdsiykPv3pbtqQP1BA6xyqXZh3OKBqh8dnAf7A/+0iSiwHogTJq
         r3bbSUlOhlSXCma0ZM7kBPVwyaxmBcR7kNQRDhoKE0fcOHB0Al0IePbZaj47xrMQKkqn
         ge/WP10jMggIcYAdlPutKBS3/L3GOM//C5UmSn6hWFhJjNCd6eiqHid5lypqopYJim5r
         miuvcbWtv6G54vQFLGBgtHyPETbVsi44dOZYUlyep7rZSrq96JbF70IHZOe6C9fxA2FB
         gB9w==
X-Forwarded-Encrypted: i=1; AJvYcCW/3ObNjGxZMtWZbLPIvklpWYGZpCmruo6IWo8bZ0yiZej13+NsNK0a1P/JkFjBTL5mrMb1znHc2A==@kvack.org
X-Gm-Message-State: AOJu0YyIKjGsi9FqInddisGn/Z+3USA5BjjuUem7mqydDPUhnybYPiep
	Mfc0MIPAw06Z6/2vzt48lseBv8oKU1fcpf/CD+gXbbcRtU12e8zD+BWyBzJbo910UzI=
X-Gm-Gg: ASbGncuBi2dGa0YotHWV69VCE66R06HENGekO8RrXBtq7ADHpeZlrHancdhjvy7jLZq
	XDVDbDnGqFN6I4tX2642Q8tKp/pUnSWDBnfFcnYJ7hxUd7ICp6cQdwugBIY7dMC39nNo9DmlkBK
	aoxUHfZFpPstyjSpI4Tbh0DH3iRSPVBVD2tihnXV07wi8WqHFCvaPj3GRz18Es0oqu312sxwb0s
	qd7EvNBnosvXIGUjIQQVOZtMlRIRB7qkYGV5UKRwbgJv2azRJnWlDbGe53JudbwyKeyc79clgSp
	MNGRzLQ7kwsFyDCQkAMQDlZrmrB33lG1Rs/Z4pa+G6Vtg5ukvSrHSzU8zm/ZnkjE8mkT17go2Hh
	rxLU8RWcuQp/zh6/GtFTlPsnRpZloaLc=
X-Google-Smtp-Source: AGHT+IHXT3z9GPf/ooFChVF2PBAkVd/6gN7XULkgXHTGpKazPylVQN3av11gyphwP2cw2DM2y7CFKQ==
X-Received: by 2002:a05:6000:22c7:b0:3e2:804b:bfe9 with SMTP id ffacd0b85a97d-3e6428ccbaemr5410008f8f.15.1757330769164;
        Mon, 08 Sep 2025 04:26:09 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45d468dbf48sm201498075e9.11.2025.09.08.04.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 04:26:08 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:26:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aL69T2Dbdw-l2hUS@tiehlicka>
References: <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
 <aLqwcXHzsaTxN3dM@tiehlicka>
 <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
 <aL6JzhRjQWFQB0DI@tiehlicka>
 <47c4e0c9-9719-4dae-94c8-3a1863b1b321@huawei.com>
 <aL6dtpEQL1A_PcOh@tiehlicka>
 <ed3823fb-01fb-498e-8248-f4628d258276@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed3823fb-01fb-498e-8248-f4628d258276@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDF4B1C0008
X-Stat-Signature: 1rgrks79dut7mqeg7j79skjeaym56h48
X-HE-Tag: 1757330770-279794
X-HE-Meta: U2FsdGVkX18j+smods3BjTen0GPViK4y4dTPkBXDP9tZ0Gn7+piVyLouBqrP8sx8mVeOz2d/EVPlw8oESxTqROwETqJN0U/uWn3JFhb6FpynTyjP+6odRrIXNC0IBZmVbKH+97zxL4iIWXqd8XLu8SnsESaNAYZr0rNbIxol82SN1k+SwN5ENzT7tM4kgLwHoezzoP87aOFQE7iGZrqEBehGO0Re/JbH2QCktIAPG/cb9IS49a9yiL75e4TCgVHEKwW2BKGGsxhsQJcOL94reQlsBPRkNlmVAonRbGTM/DiCm+IhIWNl15BeTY0UEXSvp1I5TmHiq2t8QLq4eiiP9Fm+A+h6AtrGXXSEjPcKipB0ZXkYWV+FwY2iedg9Ntmcn0KvLPzL/Mhw0hO5QoNa0kxJdJANWvPhmV1vdeEORq2GVrDQBudM3mjvejERMvXsW9d1Q7+PTOZHyciouR5AJ2IJQsCfv0SpsEWNiInd9mDCJV9fea0kGdDl+dCLWfGPjn7zMq0oCQRYSK0K+gg695SmGZUjMzEsBjfdsBOMgx5+7dkWLZTSv+yU8nx/jmcw+wI/a6FN5SVxptcWvHT7dsRK30Emko25uUrleEWxpEfYX/QX+HnxYGpJWXFrp4Y/3TrgLhNacSMavTvI5JSlgTm+YDACOxo4ytUc74ZnHR9CT3mkCd/CnOaBPS+hOtDAs/Qh8A7lhRBeVwPXF1rUu7p7YVkUXjNusdEQtSxZjAF4HoOwwFZiRD5ClVIU+JZrQA1nPwoJWJ0uyh4wZXP2kGQEXDIXxvw5TdB35v7b9CJZQYlDZhsxXAjlxLVw+u0XsJo+Hxzgj1hL4cl+g9WqPRDN7ybcAqQ1G7J2q4rqPMjvI8JbLfGC63+Oujz4Ui3UHl4WcqZEjBqQBrJ4xEARkbweRSq8rrNdbTgZDGao4O7BAvc0Wq6+ZWkozzmQOpVddFIsdKMeZXyR6ALp3lp
 IyOoq+Tj
 UJKtyGoEyqjwbrh6eJFqB0b92gshQFu06MNl/QlpKXYqvGFltAmIwWBX5q1CHU8gBmCmTZgKMfCpWfpWX0Ae2fUEDv7ilGMplSYPt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-09-25 19:13:52, Jinjiang Tu wrote:
> 
> 在 2025/9/8 17:11, Michal Hocko 写道:
> > On Mon 08-09-25 16:16:38, Jinjiang Tu wrote:
> > > 在 2025/9/8 15:46, Michal Hocko 写道:
> > > > On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
> > > > > In our use case, movable nodes are in all cpusets, so that movable nodes can be
> > > > > used by all tasks. Even though we move tasks into cpusets that only allow to allocate
> > > > > from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
> > > > > all tasks.
> > > > Right but this is because you allowed _all_ tasks to allocate from those
> > > > movable nodes so why would that be an unexpected behavior?
> > > > 
> > > > > Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
> > > > > Like the following:
> > > > > 
> > > > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > > > index eb83cff7db8c..e56b6de836a6 100644
> > > > > --- a/mm/mempolicy.c
> > > > > +++ b/mm/mempolicy.c
> > > > > @@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
> > > > >           if (!mask)
> > > > >                   return ret;
> > > > > +       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
> > > > > +               ret = false;
> > > > > +
> > > > Nope, this doesn't really make much sense TBH. I believe you should stop
> > > > special casing cpuless nodes and look into the actual configuration and
> > > > check how to make cpuset based OOM tasks selection. Your underlying
> > > > problem is not about no CPUs assigned to a numa node but an allocation
> > > > constrain based on movability of allocations so you need to find a
> > > > solution that is dealing with that constrain.
> > > Many tasks are in the root cpuset, systemd for example. The root cpuset
> > > contains all nodes, we couldn't exclude cpu-less nodes.
> > > 
> > > If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
> > > still be selected.
> > If you start by killing tasks from the cpuset of the currently
> > allocating task then this shouldn't really happen, right?
> 
> Do you mean we should put the tasks into the same cpuset, and then limit the max usage
> of the memcg, make it only trigger memcg OOM, to select tasks from the same memcg?

No I mean that you should partition your system by cpusets and if there
is a mempolicy OOM situation then you select oom victim from the cpuset
the current task is allocating from. You can imploy memcg cgroup
controller as well but this is orthogonal thing.

-- 
Michal Hocko
SUSE Labs

