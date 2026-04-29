Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B41FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24F86B008A; Wed, 29 Apr 2026 04:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCB56B008C; Wed, 29 Apr 2026 04:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39A46B0092; Wed, 29 Apr 2026 04:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C71E86B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:18:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F1C5888F9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:18:47 +0000 (UTC)
X-FDA: 84710892294.07.22485D1
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 80BB88000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:18:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="UHMPTUL/";
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777450725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mYcczxMu07MlbUpDzgqU5H8GryZdhtCkRhAJDByPzk=;
	b=y8MBG45z2xrHu/pOfKy+zrm7CnTyaJ2wJnflkOg+d6HdVOrMArCKb9gQLSsTxmz45cNguH
	EU+ZOANkROtys+X7U4TNktSNtBjyEvPU+hdH4cQFrOqxzui2aA8kTAEnuQ2pWCJ559hzoM
	D1ozOJZyrukUl8YNNF6ygVDPNw80Phg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="UHMPTUL/";
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777450725; a=rsa-sha256;
	cv=none;
	b=XuKcDUi8InVV8zYgLA947Iql4X+9DgW8Dc1pmQ4tdAX7tLUKkxXVJFtg4qpmz6FXNJc6nQ
	bRb8pcD3e3g1ryNStkObNGhNixED7IJXtxIEhLH2wbnopgX131yLBNK/9IOUcLw6Z9tePI
	TP7Tnd+R48vWyAzBTtLxT2zg5RhTKc8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so162143035e9.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777450724; x=1778055524; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8mYcczxMu07MlbUpDzgqU5H8GryZdhtCkRhAJDByPzk=;
        b=UHMPTUL/Nwy+toF/BMa8SRJ4RxzrozGeDzrcFq73vFOybCrNE79jfGXz1/ef+CUu/o
         /AML8pXL3+evtZi53ZnEsa8VuFGaxLk0tcZh676s+i9OOmlhwTwaAfW9Yq3bNyALrOgt
         aO8wyFDzn83t0FpQPPwvRFcGjKvmcOjHJwu0jQ4ZKdFVY1wGQwIKWJaYM/HOYZn4Dpfz
         C1MwslmQ+vWPA8DELegkYpXB9JgJcE9yC+WdLbgj0nTEfxL9SyZdy+qDvr9Ky04RXmWv
         OdroK6t0VomZApAnjoWCyXUwFtXCPwU7Olg9CAKBvd0kEAjC1WwhJ6Tnw6F8O0cEnmd/
         yrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777450724; x=1778055524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mYcczxMu07MlbUpDzgqU5H8GryZdhtCkRhAJDByPzk=;
        b=GQghaHsY2L+i3/1UPc2j1xdBaitmYlx5RTxdxLEZvqsQNoEzoPQ4w8RmL47Z9/ieli
         hZmrVTnno4kes5RZPMUkkn+MLtf52OHjRY8UyqrGMuds98jD5BoCYOJOLLPsoz67Bl6V
         a6POF+ozAFPqubWbhARHvfqlq8Q7iLYd85NXcgC1baxha8ZzPkS9iABDw/jyi7/12aC2
         cOQkZa/iTMv+BCEWuuK/QZEAHU2w2VZZFuioeMMCUmH0zX48nqsIZHWT19aM1gEHDIGM
         N8OiBk6r4pzVCReFwJG8ZHmvLrUfmXgmDQlr34+T0LeFY0uQoNGbbC4Cbv7YgNkO6Suq
         dAFA==
X-Forwarded-Encrypted: i=1; AFNElJ86dLk/pCy/1bmQHyKBggY23UuBlW0pn0SmVsIKmjB5kkLLEzZrt98Dxec9iIDpH88bjv7EKWi2Vg==@kvack.org
X-Gm-Message-State: AOJu0Yy+GYsJAzleWxZ+Y+oP+9MO1/5agFO8fjG0vqRY8Xa3P7eI7X5W
	+Ul/5AS0gUBePbNo9K+euaQjmM+zUHO8aX2zot33TzdwyYgp9bHdls1SyMCYAlnpoQI=
X-Gm-Gg: AeBDietMjPCYgGoxyB83+Ai1fzMj+kTtuFmF2rcMLNKjIZGPNb3AQElm8jM+q1LLTbi
	Gkm08hhcezaC7Z+KOKp9kb/t+19OJx9UeL3XQ2evF8MOQipwG89xJ12ZTqMsrD5/DhxiXBDNWtj
	91OR7HvzIbMsmgLrRNgIV4tpKln6bqdJSA1ss3jt5mpDzIvDkE+q8HtRPVztaudQCpVxeVm6VKS
	y/17Ir2sfXIA8ywnncoRkSkQ6NfGZGfVNEZvUQ3ndGYuzNS1jrTcP0JkqYkNzEiM3TXncW/+Md2
	WthAzXcyYhQ4Irt/+MhrmlKJsTjqJQVFXFb8HAxamApmIBWJosP/MJIkfZCX+3vU97dLuqBztzm
	fd6/W5VbWoTFO5kVuyd0nDy92ykdavqtPTPfz/sBJooyohnJUEJMMPICDwrFwaOXmTTgYoSQ4RT
	k/hH5b15n9XpJr+jJBx5FQPktCfgg0nIDRUFzfeKkMfbgeiimiNVmM2/NtoA==
X-Received: by 2002:a05:600c:c4a5:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-48a77aea521mr100717885e9.13.1777450723891;
        Wed, 29 Apr 2026 01:18:43 -0700 (PDT)
Received: from localhost (109-81-86-177.rct.o2.cz. [109.81.86.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c2f2eb8sm20657925e9.6.2026.04.29.01.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 01:18:43 -0700 (PDT)
Date: Wed, 29 Apr 2026 10:18:42 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afG-4hq7Hr62Uu6J@tiehlicka>
References: <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afFco71vwmpQy3pk@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80BB88000E
X-Rspam-User: 
X-Stat-Signature: jmnn7ytzqaikfip6eihxoyh6p1t9upeh
X-HE-Tag: 1777450725-912706
X-HE-Meta: U2FsdGVkX18MdAZPyM2YVFUfZNfda+ZOVJZvJpx/9OVqcRZtZSyTqgdlEAU3MYsZImomD1x0+63uFHJhV+oT7FA6WUI/sxZ17lUgmvaTA80GVpe15wtkAyfDnEuU3Sp6ukz16TZYKkyz49zNbo2hnD9CfN5AewbN+dg+piLRMvHwjoPeWWsOvEdFQXjFBzhIciIVhIyvaQBdfshStJtxs2uhfWY6L7yPCf5oVNUYFhxBnYs9sgKzZ4Uf6pILbAuv+aMsUlV5iI+LrlVjDpaUI/w5XAE914Ii633KI6rD6MZnGjLcir2vZEuMZ8pTRi4gDZ6L7adGsOeWDjWPieed19Vth8HRb+klWD14W7ehMRSg3FwCPhTmqZVsfeWdOZI7921+hKwMJD0bC5mx/qSYbev/AdpbAEevasDRHR5IJZ7kWuW5vkE9Nq87IgVl1ON+YanZhRCGsOEu8SIfThKM5YtNIYHQKq+gThGF5VSDCWL1mYl89z7PLmprW721hLmrEMUUsXMAzxmbmPO/xTki1zAszdTGlJ0vR3AfDvMLGw0szUhXvDZXcTjU+cuyIk+pPMu85OfSUVKM8Ch4ozgU4Gb0fn9E4R3pyGDOPwGmn3qv8JLP050vKW/L00VwQwW8khWVSL/76RVH2Ie76/UjdyzSd2QYuthTdKsJgFl73d0O0o/Ka8O175I2/VPa7Gr1vNxVxGFc4Dp8QHc57CiJhl4kr1D8b2Es8xhm0M6tyOtgiOsJ9auj2F25698x4ev5cG88OWbDG7JS+f6NB6HyxLnXESmpUVeuNXApGCpRssUypD4T/Cufb8UcAi+jAh0DPExEVvM+iejKLFrir0mctsypxLe4x2Zgy8TkWEUjsNDp74HEOWwIiQAtQLsGLqsj30ZDy/LyevnKMzY19OrH1ziyaHNZ7qXaC2p6IgSf6DzevjqgqwF9HQ+3K/wwI85vlzqdfbufQGW0CmCRLa6
 pf4hRuya
 loRNzC/UwWSgNJDzSgA50Hkg+nSeViVmUkl6gI5y9eMw4K+jFqxd4xlUhAWRy6AK1XP5JMBICTjDwOLJaob3SdcJjCKvsP1J9/2FHohnoqUw8kcTPjFC35EnCkIK2usU2B2CHacYFcslbt0rKcx/2WdHR/a54RVQtXuSeg0S73/St2I295Nwt1gUj3b9aYr3/T6vDbXZqv7QclyFH9eooEaWLKabus27fxFvP4qcfSrM5OOy0CffKd1l4bObup4yUDzgYIgVqt41cIUVeTuj81cdyZj4r9yEXRI2jDOp2MxZuQUlkuIABY7bgZVJvJlimLIwxeqmO9S5V4Nj3J8ahrqRNcVXNMWlq29iKy9l1CJ5n9xvQECq23n2/AXPz/UiN2v0r5AdRbWEL/kquV9RfIvPxZsjcuEi/DJ6t6it2ImBJFgrMLnXbEKFGR/eoZme9lC9vvauMmvxL25lXUR1iT7bSBRqIsHWss2mMSRxaVxIZMRhBN4R8RTRUAGbd8C9sx6qe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-04-26 18:19:31, Minchan Kim wrote:
> On Tue, Apr 28, 2026 at 08:56:36AM +0200, Michal Hocko wrote:
[...]
> >         DESCRIPTION
> >           The process_mrelease() system call is used to free the memory of
> >           an exiting process.
> 
> "Free the memory of an exiting process" implies all memory, not just
> anonymous. User cannot know it will free only anonymous, and I am trying to
> make it work as intended by completing a symmetric reclamation path.

Page cache doesn't belong to any process.

[...]

> >From cf292f8f8ead8df9161aad342c36633ffa90257f Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Tue, 28 Apr 2026 16:39:06 -0700
> Subject: [PATCH] mm: process_mrelease: skip LRU movement and expedite clean
>  file folio reclaim

I will let others to discuss this. I maintain my position that this is a
hack for a very particular use case and you still seem to not explain
non-Android users of the syscall. Anyway, I will not repeat myself here.

-- 
Michal Hocko
SUSE Labs

