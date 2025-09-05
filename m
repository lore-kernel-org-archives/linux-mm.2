Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42B4CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 08:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95776B0007; Fri,  5 Sep 2025 04:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45E86B0008; Fri,  5 Sep 2025 04:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C830A6B000C; Fri,  5 Sep 2025 04:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFE1E6B0007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:08:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5254411ABF6
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:08:28 +0000 (UTC)
X-FDA: 83854469496.30.0D69489
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1FED28000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:08:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O5PYICXI;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757059706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gP1Oa1dtVoph+OtwRFRXp38raU9/CZE1G6wgb84MLI=;
	b=gAuhA3rnphjGokHPInTLRK8UNKXNksjfGEaTTxsBkXSNStebs3u00/oacBJvRH7v2PE1ZI
	JIZnj/zOVCAnZZkgXoY47liTAq4JmSNWX/DQ46NKH2M4KJCVY3x842OLBxYfQgdtLQ0HsZ
	jK1Lt/7z3bhPLAgDTsF3wE86CkLEV6I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O5PYICXI;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757059706; a=rsa-sha256;
	cv=none;
	b=hJgtxCa9J6znBLEGGN3SDcpNDGiNYCtjxYCfkgbGhCAvcK4j3mpwvXdc/2uhIVHbRevXuC
	GxfgCQ1Tg2b5Xj5yZWDLmuZk9fLHWv06Znr/ymTbzKXsXPviXh8CR1dkAxVdp6DhHnKRlf
	pO3GuQfY6gGF8TtSeQaNf+/WZFaQ1As=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so6065975e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 01:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757059704; x=1757664504; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6gP1Oa1dtVoph+OtwRFRXp38raU9/CZE1G6wgb84MLI=;
        b=O5PYICXIXXU7wrjbVMHX+72nLa1iKH5aA5rMhIhdZNQgFQ2pcEULtHMILzLv1bukWR
         vbOWaT/IGJ/Y87v7D+n38AHG4aszXJ81B6VKML+kye1UaTjYfdBwsldY40x69ScGBcY0
         +9BkDk92ln5OEciHKkJXikxJCbQQ9pGaI8PGZMK82Q90qsGyaYvXBg2GFAqMl9C29lYK
         OaKzwKt0vPdG6kziRZ7vNQRlfbTkQh8Ke1Q+c/Dz7SXX5C9GqcVnldciW7Bco4vtZlHs
         g4CZJjhVFs1DRoO1fybBVCWQU8t16Ri7z7SLK/g+pxWCa/CugN+nkDBKrMOr1aCaJeme
         gN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757059704; x=1757664504;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gP1Oa1dtVoph+OtwRFRXp38raU9/CZE1G6wgb84MLI=;
        b=I1gvkxwGuFhrY5yKbyF7B9e8ZQzmuzB9/5cEZahDGU6HFKMGQgvAmQj/qaa6A78Y7R
         l3/v8OOrf8/4pwWjTqq8BEwf4RydBAMnXh9H1jO4uqvvOZiIq48e7zU7juIkhuMkuETp
         v5H1LUh9uBzW7oS00RXAreEdJvDgl9CcQzjc4M8o/XMWnUyipkbxXlrol6M6XPkXeiJ7
         4IwX7LWzpKaIURZs9Ri5RrTaJRIflNIX/4TUsH2km5pg3HgDpPPv76Ki8YOuBKG9DeJm
         m2ngRNTuUTsLWcGzMs0G/8fX2ElosxC2GNhCQAXuB5yJxHB7GANrPEdMXEh9OtEvOzQS
         EVBA==
X-Forwarded-Encrypted: i=1; AJvYcCXGOyRjIbrHeNWoOG6s11ugYwH+9+MaGzUuaHDPCTN0C7BB8dMKncH6YNDGOpKFE/o6N0JxpMVQ0A==@kvack.org
X-Gm-Message-State: AOJu0Yxg1YcxGjaSN6OJtvCZJxHUSh+EIuvGu3znOKWnkOjnvfFebJoP
	rSjb5xOthOr3wC5K07YlW7J7n1uOBUtjaLTf320d+Xyaj9Xl9hIJq6N2OWSklh+JvuI=
X-Gm-Gg: ASbGnctDjZcqc/VQA0xy85gBx35ZsFnNk8ozpO99t7mUkUdfCqhWefWC8dUnD1lpwDw
	MoqBCU/39QCfNRxJXLIIaGWuZ9K62Y0HCv239WeVjkSKl89tHGHa2Vp2fZ/d2NuieA2PEdTt+Gj
	RrjFF750azjunLRRSwqqVBq/eb0SrvLoVzoXgSt/jCrr/QGDfYlB8pL/HeoF37Cavws7bAB2RBR
	aknXck96NtL9bKi0BwcgPKu4w9MKEPSDs75uvEMwxnilsvBJwNKN3/vUBfg7/7HZ4fT1eNkAg8C
	RLP6hCDSgu4CDC/ayOFgp/tnn1odC9FxYz2ff1nTi5qJctVigQK+fWoQiJm81g81drAxamPi99c
	KNawY1Mn4O2gWMZJAQro8qfG0D6/6px1Q
X-Google-Smtp-Source: AGHT+IFjOYj3SYMvJO+Y1ay+CpzJfc6JYY1b+f6oOONDAXnFptmd82btRrMeXpujrcdgf6+/9d29Yw==
X-Received: by 2002:a05:600c:1f0e:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-45b855335a8mr193909085e9.11.1757059704339;
        Fri, 05 Sep 2025 01:08:24 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b9ab7c7dbsm139571875e9.11.2025.09.05.01.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:08:24 -0700 (PDT)
Date: Fri, 5 Sep 2025 10:08:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLqadzgmyGGjSck6@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1FED28000A
X-Stat-Signature: khumctaz4tnfygc88zaobwt8b4nfb8mh
X-Rspam-User: 
X-HE-Tag: 1757059705-996908
X-HE-Meta: U2FsdGVkX1/S04jnEsWz6lhygwMNs8XaEW18PMuN1/gluScEBRWW58abcy3X1SJxtWMa1M1sOgEn/svGgXQcG/ZvympJrAQ4aUQS50HI8pNbsh2Dq08J/2XPElJpph0qyUrzjmNL4O+7ebQIjVEWgMTWZwK5t2M3fB8eg7txmzvINmufhqZU+pef2d7NKxa7vR2cgt9XuTq3Hsao97EjHqtaIUvyKvT6YqxNOQv3rDm91D7mjikBklky9ab7H6WfpTI7Kx78BDN45UzTZNXxZWynK5Jw1SQuSRb7iiBE1blWXsmtEuP9sLMHWsu0YXOhboXMM5I75fGu+/oXQzMxP5VYtk8AHnu7jMc/9kmfC6RrjACdW24m5CiCnjOwJAR/NA7ltTmAKWmirbEjIhC3OtW4GYNa+oCXpep8MGXj49v2dl8ESwEDADK4pzdy7Ocb4nVvlLLS16YeQC2W8v/3/c+TA7sxdeamDdVg6dGT6Vd/HS+7SQSgk7pIRJDip666R+6nYpLjjer4IN5dyPGbBhob4tQjssLYR2GC26XHhVmGlzx4F1ZNtGac47UPZrpCPkimkoXDmOVNk+bk0aySBbAOqKN0D89UGaXy7563RNTdn5rWNWnD7L1Q25R1Dd/y0NLUrbLpYvxZtW8TVvE3k61Ldvrk3yQeU5TuvxJ66Edvv4tBu+vXnQ6ljcX9f7px37XWG+pQxZtn2I8YyPwXg7iUXyPHMFVAi1adyhvf/+p9ve6nSdbEJUZRLsXihBT/0SffOctRVYiD+DWsidzaI4bgXGcOhraTg3DacxMznNC/b2mGpCMjHkpSDFBKAUic+oxan5yJcxJbZJIdXiI1m/HcKAFq6j+zAK6kEQ/E5+QejMyd6NJu45frPRnyrdUoFFKmsVDKCS22CNxuxIPwGvDu5KoJLINYNniMgtZiD0xEh8tZJ6vMiKtJCX2yQO4HynHLeHuDTcrLw4MHOAF
 /48oZjzY
 fosU/5NjlXdcGHZ3xSVrmIHsdbtCPApcFSiblBehj2am5O1vLx+KXxBN0EPlbxE7RLgJFcRr1pAJgkkeEfKc1JSmxn0ScLUF7On9jUU51UW+QFz87A0Asb/DCC5/Fim4vnSiVaYJAfPNc6rZvcBifEQ4AD0wItSZctDf7lYGkLwGsFFT+bIp2ntrWZeT8/5FXztXV/h3GddgSMW1EDKDHf7WjSkth+hJn11tH/jndq0JPHViZS+4trfglyLMEsj4fwd9C545Hj8hqZgttMQbQv+QBP+d+yjgapJJE0O27h88Q9jEfHSDGpGsajgAtbw3hG5J/biJBgnQM0SXD/SiO74xbpeOS0p4jQifz5dC935iCw3Ztf9LMTQFrNXZxBgcwsXk3tTDhZ86gPW2NzKGxXGw6ELZVDYChpMH2+bSJ7B+u47JP06887+oN+QvWgEHNmKI1fR/ArVoHuXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
> 
> 在 2025/9/4 22:25, Michal Hocko 写道:
> > On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
> > > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > > tasks may be killed wrongly that don't occupy memory from this Node.
> > I can see how a miconfigured task that binds _only_ to memoryless nodes
> > should be killed but this is not what the patch does, right?  Could you
> > tell us more about the specific situation?
> 
> We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
> is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
> we want to offline the NUMA Node.
> 
> Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
> allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
> when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
> won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
> cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
> leading to OOM with large amount of MOVABLE memory.

Right, this is a fundamental constrain of movable zones. They cannot
satisfy non-movable allocations and you can get OOM for those requests
even if there is plenty of movable memory available. This is no
different from highmem systems and kernel allocations.

> To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
> When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
> according to rss.Even worse, after one task is killed, the allocating task find there is
> still no memory, triggers OOM again and kills another wrong task.

Let's see whether I follow you here. So you are binding some tasks to movable
nodes only and if their allocation fails you want to kill that task
rather than invoking mempolicy OOM killer as that could kill tasks
which are not constrained to movable nodes, right?

-- 
Michal Hocko
SUSE Labs

