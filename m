Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0448FD58CAC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B599F6B0005; Sun, 22 Mar 2026 18:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A426B0088; Sun, 22 Mar 2026 18:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FFA6B0089; Sun, 22 Mar 2026 18:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 943AC6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:35:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB9E013BD97
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:35:02 +0000 (UTC)
X-FDA: 84575155644.07.1F0B32B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1680618000E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:35:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BZKlad+F;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774218901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OAu+QDQuFU4a+fK8GFb5GMqKgS0xBWS+YkYTun6CnQ=;
	b=7RVeGMewTip6O2XoN4/gdUFdPiv2i1hcySa3WJqQ37APzdx0sEOnIhdh3stV9tMx1BOtgE
	oJ2GClxKkur5Q+6xWKwJ78kNPVwSBT+rmX/eYZbybzKwQiImpLJBDApoLnjvWNQh+zRaI4
	QziAnGUVVoNI+sWUrbnICB90HpHHu4I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BZKlad+F;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774218901; a=rsa-sha256;
	cv=none;
	b=6dnqJryz/txt5IPDJXenifT3T+sBCizhkfyPdsAzCkCDXR/G2M031Fk/4nRSTVMhYDHi88
	/RQM4PVAt7mIxI8Cg/EfRLHns6rnuMg4RxHiSG+91rvGWGRZwj6O6AMnr82ixmrJPJkONv
	+d+HVtmlR5XQoy2Zg+lZwl2r/cNzZUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B22A4441C4;
	Sun, 22 Mar 2026 22:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA97C19424;
	Sun, 22 Mar 2026 22:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774218899;
	bh=Savqoq+1da5mlltJawsJ0m3iwpbknkmSXsByhCsojJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BZKlad+FQFaJnrsAKYEbygGXQNLKDbYqZXaYDEQKe+02JfQPkL81VfHswVMEapP2D
	 6yZ2LeH/m4bbfY3AYe7X/h+lYVLxNeViVA/JEXK8jr8q7aKkwui2g0rG+IzS844m5m
	 T4BoTh0d40xZcq0g88AaK6G/nez3laDJOtRJ0iRk=
Date: Sun, 22 Mar 2026 15:34:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in
 mem_cgroup_css_online() error path
Message-Id: <20260322153458.245cf0eae46bf8f57d6fe4ce@linux-foundation.org>
In-Reply-To: <20260322193631.45457-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
	<20260322193631.45457-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1680618000E
X-Stat-Signature: mx58q59wwch74dyqkw5hezrh3oqghpsz
X-Rspam-User: 
X-HE-Tag: 1774218900-355937
X-HE-Meta: U2FsdGVkX19ez+eHy+/Q4mIMX3Mxlho8McyqWFBk9WKfNHznvG5x4dk2EALcC9DYVOZ4qC7gS3EqQivihvevt3ZYeFvw6B3b45k228rEwPuCaW9zJccEQRLt/t1dnoog9e9bbRqoiC78RykVX0KSS/C+wYAx4p38lUnK2CnYbBWC7GpqxfMNUW5UXZZ58GvK1Pj00YIiW3hg1+OgqshR7O9L9a5JZK1zgytjZ+k4esBD/hhdLJdLORq4Rm+ijDPmVbOcZV5jHnEjICMtOLOD0jQmqG6hHmfEDJYfOpXIYRSgcipDDbYOCIewafQTwGfQS7f/IMK52lNdPmhGDrqWZcypBYxcTX01UUK9THxX7fO9sd+XMKbHhoJKmZK57gNNTCpJm6MtpXaKyveKc6yOe0D2wDsKBrvnhplf0atbQPrMUHPmPhfXCSmBvWMyCKGbT7ai0C0N6Xo8hP1CDE9CpewJoJgMr5AI3un7jNrk+XtGwLJuyrLwlRvpTbZMgeT2cJKO0ZmyVksRj2ouV2tqs5pKLaGUO+svnkinZOUHjcHygqzzh2KHmgIDFfxt9EdAvoLh5eqmlZmK0/WLg7Sk/tNLek6ZPa12njJAAz7ol5kffK/ZUkl3/emJdce3Th83Ctmvcdh1Yb/ms7tHAJhwqrKq3FcGAm9Z7piv5s8+W1YqHS3ju2Or9qB9A+ttwewqBIMVLZ7MB/sm4L89IoHBTV/NzbIO4CSO7RlyZkvKWBzp7RnOCFc9m2VNoVdmhgeMQl8GNJJ7cn3E8nYwGS53RijGYbGkZemIBShQFL886hkPD67CkwUb3zlbnn8i1LvBFRzeFp6FqWKimgFTlESz2IgkdBwmNsVHULQnGiqjMKqaXdSBt+dd70v/WvnEvnEEglHuX9Q2ojWZ4b1MZFUJklQViOFd7Sx/kFtjhl4wT97iIG9Yq0y+HJCMMaEGFJebm5kf6SeJaZOlMZ9tUl6
 H15r7cGu
 s0ObyynZljsPCVHeneBb2cy2l7zDYQYqXgXQZg3t6xoJ82jrU2GlOCJhpoVuFNVXGs1FAiTjPs0jhbuZmYDsfC4G0S084Dm2wYzGBQHXPVgeWJzbxQvvOpVqIkeygfMg71qGj212hpOoOhugYHwFdHHKbVWOn/+/bNB9PUWX11/OPfrvY0C4CsgQMgpkUJSlnzZAkg904EJ8e634dNr6Rqy7Ly5cVc1NpzVEH3ouo3JWxlY1HyDpsqfAF2b1bihmZTOr+1WJPtYVx9d9xk1gIFY6jWDn6BAkiyMIxlHhVqFE/w/Dac5s53wNF897OoaayJghBp92P7py3QJkvBIffJcevyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 19:36:31 +0000 David Carlier <devnexen@gmail.com> wrote:

> When obj_cgroup_alloc() fails partway through the NUMA node loop in
> mem_cgroup_css_online(), the free_objcg error path drops the extra
> reference held by pn->orig_objcg but never kills the initial percpu_ref
> from obj_cgroup_alloc() stored in pn->objcg.
> 
> Since css_offline is never called when css_online fails,
> memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> normally drops this initial reference never executes. The obj_cgroup and
> its per-cpu ref allocations are leaked.
> 
> Clear pn->objcg via rcu_replace_pointer() and add the missing
> percpu_ref_kill() in the error path, matching the normal teardown
> sequence in memcg_reparent_objcgs().
> 
> Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
> pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
> through the node loop in mem_cgroup_alloc().

Cool.

> Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")

This is presently in mm.git's mm-unstable branch, not in mainline.

> Cc: stable@vger.kernel.org

So the cc:stable is inappropriate.


