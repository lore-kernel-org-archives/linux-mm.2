Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3918FCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DD96B000E; Thu,  4 Sep 2025 10:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE218E0007; Thu,  4 Sep 2025 10:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8147E8E0002; Thu,  4 Sep 2025 10:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1586B000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:43:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14662118972
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:43:07 +0000 (UTC)
X-FDA: 83851835214.29.C6CEEBA
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 18D6D1C000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:43:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=epXxmjPk;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756996985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byAL+gA4VA7ppYt/wgFr0yi78AP5huKcaS1UeJ5aeTw=;
	b=qAqWOKEHAmc67kPjPGT/6/hxhER4ONy14Ol1v/6auK97FXuUfHzsc6Kpsz1sPYoDiyIhvY
	1ltSeRaey2KE/3mZX9egsuPbPocXr49FJSNnGTDYsKS3fhYJp37Bdd2fT8Vh9XIKw4SiTq
	l0NcuXz/TKSoZVxyKuhsjRwSRCwTbTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756996985; a=rsa-sha256;
	cv=none;
	b=LC0SRD58kX1udZeh8sokNLy+AUG71fXRzedibL5JogdELAyCawxZUzHoiwVtj2QYhDoV1U
	7sfmtz7aAsRqu0pF9fLeh73C+wG7hyJwTqHzgZTRuOPKscwf0SAlCK+2zE2ZBL7RJ6KOED
	MORdiz7lKFWU4omSc0Vxw1Zm2GRepTU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=epXxmjPk;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d6059f490so11380107b3.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756996984; x=1757601784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=byAL+gA4VA7ppYt/wgFr0yi78AP5huKcaS1UeJ5aeTw=;
        b=epXxmjPk9nlnDW1l1aJ+PxvfDhVMm2JPtQoqZtQgjYl6mGNfaHkTPpKLsBhPkhVxrO
         kZJxj4K5vUi5gUPW7omEw9SBCc/84OeCgZ6lwW+0dzDxQsIqZ96Ub7g/1/ySYpRRYY4d
         EzDMAhYV7fIPl3Yz9lCJc/DPePOUQFVZR5et09S1wB+DjqbT0Q1rNrfhJ0SntprYlf6p
         ObsFrSEtigQeDPhn0sC3r5Opma5CzEKOxpjx8KrzuBOvELwmofDNXrKCXvvvJX9iOLn5
         Za70wZGbQbawSavEIS76dUApVLjo8sXUSNTasPsiJZyYY0hF5afJXrpU07ULr32pQN/j
         LlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756996984; x=1757601784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=byAL+gA4VA7ppYt/wgFr0yi78AP5huKcaS1UeJ5aeTw=;
        b=DuA+3JUs+kYV8ZxHMigwsC+DiMWwYR5IHlfTXSqLBe5ZUORdj1R/ZfNAIZlqVp+QGU
         OkcNHC7XE9HQK7bdipdq0hRTWEPhvkD7BM1nZY8zX9pWT9R66tv76QC56S5Q66Qej8T3
         v+Kd0FGvXA4a1XjoqO0TlafaS5hSYgLY32kasZvXzEhqlMVWdX7au+f0e9lrLx2O8aMg
         uaXBQxzYVFzuqz/yoy576K2/EJa8ZTW30HePEKNFh3Bvcxy/V8yfia8I/AflbtjHY/jh
         ued+927h52YrOW08Y14AImbrXZwC1K3pCQAePXgJq2qv96p1L0Q1j+FuwZf/+jZjTg3g
         w2tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVctBGwuOWizMLIgFgirAMcOyp/HfqGj31BNJgAxVKJaKzOxUJCNbC02BLi8kaUMjJgsFvLsihWIA==@kvack.org
X-Gm-Message-State: AOJu0YwwBCXNyjjjQ/bybcTKuBsyc7tQ2ULcEHT3D+0aANZUKLVnfvrK
	znlKIe5bJjXa7BXQfDypNO1UdCGYq8gcp28mnYf+lSB5WclFoVMk4aSL
X-Gm-Gg: ASbGnctAl8yMXyr5aWg1fg2esJSz1pTa5C0NJkd9/V153mFpchFlNo2uL7VpzeqMM2b
	sR0mItsaw0NFg/m5hFMMM2HiNox/Nb9LvTIyHHBm9gmWSBneNnNcUcJ1zrBS2EAaquQ7it1yKth
	7vpoMxV2PsXlJimFLIzmuSEjOO6ZEXfM66OvFkyvxh0sOwZNsVv9PRrjhAGyOuvqrsZIsz9x0Tp
	p6sfy49L2hk6qXdFUL5c5J1a0De0mqTsjEbLNGJRLgozJXZ76QZAPc8ePIplWo/J+ZZq+BTmCvH
	CqqRxclhQFSOncEBamKXuCJBM5PVffdE7yExlFaflg4ASkD15RzLXsZLyq+u7auR2nyL+il/L2P
	zM6EneE74pBBAPEFZOkzrPf5A+bSf43kO7ZoLFjcLpeyeWS2bowOOmAWsu+/uBB0=
X-Google-Smtp-Source: AGHT+IEz2RX+l3I4+tmOuo7tcHEeiHyjWBNz7iZfdMboKTA9vwljXkkX9+k2LPsCSTcMnETCAgjSUA==
X-Received: by 2002:a05:690c:9416:20b0:722:7a7f:5381 with SMTP id 00721157ae682-7227a7f6e8cmr181241297b3.14.1756996983781;
        Thu, 04 Sep 2025 07:43:03 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8552a82sm21452967b3.52.2025.09.04.07.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 07:43:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to cpu-less nodes
Date: Thu,  4 Sep 2025 07:43:01 -0700
Message-ID: <20250904144301.1224021-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aLmj7ObmiNQt_6RB@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18D6D1C000F
X-Stat-Signature: s6ue7aisf3tcrqtmtddzoozocw4gp3sx
X-HE-Tag: 1756996984-804420
X-HE-Meta: U2FsdGVkX18uDG2Zylt64FSovroePxY7BqNyGDw0PopsNpmKjqpoULyHSp3YLql9+tKNLnNPvtIPiA6NeCsi07nFfj8hAEUDtthhw/x477PYc4Fgoz68kJI8e1p6H30CyHfVErNYwKey5J/QN37yawkbBXaPPoMJ6k+bOWQkCFEW/3oK1gJ0Mmu+XoYQJt7idQp4HW1iEmtLVYfmHqrL4wP2Q5rIlsfSuubBhA6EVrbwohru6Z9kYxe87cT/GUn5xY2hiqd46Vqs1uHt4N3rQ68EyZZgzxPbz+WBSEDy6UhQYgaFvWAMD1Pz85FJMliK2QTs3KEsJlsHNpoHScxei9EXGBzEvil2SoBRPOAJdPlnDkAFrjll6qw3r56pBFhPfKSG4XDzBliUXVQfL4I+c2c0Fdnmxmf/8y+5nuvdBZ5f6Ep9N8lFjkimcgcW1CTIUTSXT5sqOBUeL8Uh6mLoL8Gle3vAAnLGoYWkF8hg4ndr+evb18lpx3VzYGX4VGFSNlLCB0BDf3X3I7DroBqX5zF6SyuUQadVSFrT/5Cj9bdBAJUwaAxZ0ixGwcFBnjSO5WIsaRE7H0Zx5Z0hMeRQA//BliWdbY5L/cfyX1f8d3Ij2HITJ9pE+oLfOmYxcGJK0dZwcZBFrQJft08jd4dbOnLpsBrlCjEe6Belxi6Yow2pnCc2yj1FvmvQjaHY+G2dvtob9U1xSe/OLWivhWiDCM61ReKqM5j4tJCXeexfiWZRzOGson01QSA0BELFgW3Of5k21+dIwlSIkvSxhZaaOUSmZD5plwHvBDzNpfJ+v2PnrBLYacDBAg/OPfvxnKbcmQQO78p5V3k9u72JquSi2tNseRsaLRv5LnGegp3i8WBN79UOqqektCE08g/4vsxNZSybJi2BlUJFn4UcZV/YAnUqweWzFAvg5w4AOZP0NDS82vvQhjPb9406r1ZkbYxTH9xKxFxc8rqq1zvYkkT
 R9SgFQEg
 scJK5rsJ62y7PXsjWtHo4ZgPSft0F4De5jsGa0LhOiT0KGoRnGZblIEOTddObK6qVSpL5t1g+o3bXve/sOjJ1/SV/O6zl40nFizIypaoJbjBRn14upzlwx+p95c5nU39nR87QtSFay+cAdO69ry6cQ9Hyh4zfkvKmNuofCVghkLdfV9HhsDKf/cc770mMHj86S1IM56efkNcM3nrpuTZVKJCvfZoe1eObjengpkUoiTsNv7kgsTX2Bzqy+x+AoS/hkDaEhlKxTQBhUGEjyDc1yKEA8bkNDDuB4wLvMT77flsiLhRu2GYL/v3aecQ37I9JefkWN8S0zybLPIkq77TEw/HpMrWP3XGKlH0rUCaFqHHrgbiq+kG/3uV14JscM2aw3fCXlBy4oitiBcL4wmYk8kDx6xXbfmB+V0mmWXsTSUOD1og5LJKAG3fQo1vkPpbd2Ocel4xVxUgiLVOhbtimrZvlQUxIf2ZXrDsKljiIP5JpVLhLMm5M+oLLUh93y4g56Pq6ZicamCdyC0Xl8SKflLTNpPJqnxOh/OtMBAoi6MRQW2zq/HRc8J/5N1kP/SHD2V64WlM/yO7TklX719jaXwA0vXoqsd3drMTXN1Cvw+8q1MBYegYPMDtDoY5zibWwlrCkbowh1si1KR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sep 2025 16:36:28 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Thu 04-09-25 07:26:25, Joshua Hahn wrote:
> > On Thu, 4 Sep 2025 21:44:31 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
> > 
> > Hello Jinjiang,
> > 
> > I hope you are doing well, thank you for this patchset!
> > 
> > > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > > tasks may be killed wrongly that don't occupy memory from this Node.
> > 
> > I am wondeirng whether you have seen this happen in practice, or if this is
> > just based on inspecting the code. I have a feeling that the case you are
> > concerned about may already be covered in select_bad_process.
> > 
> > out_of_memory(oc)
> >     select_bad_process(oc)
> >         oom_evaluate_task(p, oc)
> > 	    oom_cpuset_eligible(task, oc)
> > 	    
> > 	        [...snip...]
> > 
> > 		for_each_thread(start, tsk) {
> > 		    if (mask) {
> > 		        ret = mempolicy_in_oom_domain(tsk, mask);
> > 		    } else {
> > 		        ret = cpuset_mems_allowed_intersects(current, tsk)
> > 		    }
> > 		}
> > 
> > While iterating through the list of candidate processes, we check whether
> > oc->nodemask exists, and if not, we check if the nodemasks intersects. It seems
> > like these are the two checks that you add in the helper function.
> > 
> > With that said, I might be missing something obvious -- please feel to
> > correct me if I am misunderstanding your patch or if I'm missing something
> > in the existing oom target selection : -)
> 
> The thing with mempolicy_in_oom_domain is that it doesn't really do what
> you might be thinking it is doing ;) as it will true also for tasks
> without any NUMA affinity because those intersect with the given mask by
> definition as they can allocate from any node. So they are eligible and
> that is what Jinjiang Tu is considered about I believe.

Hello Michal! Thank you for your insights : -)

Looking back, I made the mistake of thinking that we cared about the
!oc->nodemask case, where Jinjiang's patch cares about the oc->nodemask == True
case. So I was checking that cpuset_mems_allowed_intersects was the same as
nodes_intersects, whereas I should have been checking if mempolicy_in_oom_domain
is correct.

Looking into it, everything you said is correct and I think I defintely
overlooked what the patch was trying to do. Thank you for clarifying these
points for me!

I hope you have a great day,
Joshua

> -- 
> Michal Hocko
> SUSE Labs

