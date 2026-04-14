Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFCFED7B8F
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B08D6B0088; Tue, 14 Apr 2026 05:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788696B008A; Tue, 14 Apr 2026 05:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EF76B0092; Tue, 14 Apr 2026 05:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585F16B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:11:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D76A1A0485
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:11:48 +0000 (UTC)
X-FDA: 84656593896.26.7BC2AD1
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1CB32120010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:11:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776157903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pIb+7e3FoSZdsvZo6hNoQggErGHsAXBdIGibmV017wg=;
	b=BeZ1c+Hxk9DsQh3sJaRg270+ja1T8vHD9EVdGCgypjR6dCrB5BISqKd7K8f0HtTJn1+9MM
	F4BvB6AKITiyRhtaEusJpYdAuRbmvrDJRYI9x/B5CC7zbecQaM/aOtlzj5xGJv735GANK4
	1axN3Bv6bJYWyo0pNCnNyPxyQFjZ5hg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776157903; a=rsa-sha256;
	cv=none;
	b=jR0AtOpuoLCD7uUGvpSFOOW350+WyezTalW5MsAVv8J8VYMdv2Glq8x+Zr59HW1O3I+TXI
	ff7Tta7XbGRpWAcV9Ebj1pyWmSsU9TYmpMsT8TOj3TO+5jRVHc1cy/sJzbBhm0uOPnN78z
	KK7j1Pkho3imxbkyCXkjo539J1ZT+Mc=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvz6Y1Vswz1YQpmJ;
	Tue, 14 Apr 2026 17:11:33 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvz6V6YZ3z1YQpmJ;
	Tue, 14 Apr 2026 17:11:30 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 75DAD3005A41;
	Tue, 14 Apr 2026 17:09:35 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 14 Apr
 2026 17:11:28 +0800
Date: Tue, 14 Apr 2026 17:11:26 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Mateusz Guzik <mjguzik@gmail.com>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 1CB32120010
X-Stat-Signature: aj3ffzo15e6b61jogcw3hyn6o9t5cbd7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776157899-672052
X-HE-Meta: U2FsdGVkX1+mX4BEvC9JBh/sFP5N5MQYFiegWwXULL12EvjtEoR7OgkYNIWdYwMMwOoVdN0797rJLtwyT0oa5k/CDUI9cIOBbvOWP2TV+R1fFuFmM/sgfAOn9Xdm5LBvKjdCTawcrKOLLrm1xfDaYJypGH9SoooGSN58ia0vnIvD78twzghJYF36eX70ObG7IZF/KViov9URLp+5OTrUk77Ke7fNf9KW8K4LFMwMZwJjFjj0Q9lYRckiAscysf9DyXMUjxk91dQzlrnhyu8B/J+Yyug/d66nNutN0ew/2FA/+S5Aoczp9ZQwE+7jZsZ87WF8nY2nT5QCj13OZZQ4s9t9vtAjjZ85k2tX2u2tGgh7+V0h3rZxXa7iBsGFbr9lHC6wVaKmWl3pF2ZXj+A9/zDF7M46KtPQ3BO0XsI4w53OYuUt9W0AsodD1T8e2eJbMW+QYQ0dkUct7/rtnMg5liRF85dNRIV23tnqTt3U9XSGQIgc+USMTa+SmzCAK+e8zlel6amqkorvpShJJkX/q+BzVRzLBy+o2LV5wCRsRWd7yo4u8IR9RLPpbJNEIBcIhlLL50YBpqSccEt7IpiybFsXZPJvcWWNr8DC09ScSAnDQAJpDe5Lqm1o0GMEDei3z1dn9DcWWSejkpnLw+zvbvtb8h5aSkVg7NODgAZYWD2mRb6PkbqMLwK6J3iAICKhMxS2fHXqUxFKPCwVxCoHzs3XVmn+8S0Q+cEJogNxqxfVA8EbXtlIy4OXraaujLTujlhR3dczC5/7l4a5L9ArjAzALKSxiCE7aSmqQdRFreDQgYq1Cl28ExRnJk/HPnl7/NZcQaswMmSN39fuZwrHTHoklV+pDDFZbQWgQG+Mojvc8R3hIogdvCDyXi3cqlUhJN6rkSPX3F5WS0TEX0WGa4c2tYJ3gRD8QOj577P7UiBCL+GsYOAPtAmdtMkxAbxvXeqpxyFWNhpziEAc2Pr
 gnIajpk4
 Hptqwu/2xacKvi/omAuNhPN3cN+y2X/YyN+2Z9X24sdHUWy2QdZxr75f+YNcpdg1HqG8bh1dAWaYOkk+yIlE5SyIDJt/45YoFMSEiWCY+nOntBBVqp49OyhqTPQCC+FHb2KvwLPb4HaKUU0m5FYM5FYJP+wjPm95a4k2/V3FC8okEcNgGPL+ad2u9g/1ZSCubN9/7klCe3XSZeMytGBEkoajHKZbfMAwaLiYGXJc0XdumBwQQkl8Sei4hsU1MGovOlT72ZcKl14sH+4YLFVgrFyFthPHo1PidPJ7/cljGFdmhG0cbIns5cvLf4mPZQZ6ZX4nA5F0V1zq9flSBBkJGAIcjvmrBvTH1mXkzlbnVdfRJcta2RokgJX0+HoG6b2tOSPNuZvpaIFcinUseQzc9QL7QTbFNSDVQ71k3svGOZVVqvUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > In the UnixBench tests, there is a test "execl" which tests
> > the execve system call.
> > 
> >   When we test our server with "./Run -c 384 execl",
> > the test result is not good enough. The i_mmap locks contended heavily on
> > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > The insert/remove operations do not run quickly enough.
> > 
> > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > performance with this patch set:
> >     we can get 77% performance improvement(10 times average)
> > 
> 
> To my reading you kept the lock as-is and only distributed the protected
> state.
> 
> While I don't doubt the improvement, I'm confident should you take a
> look at the profile you are going to find this still does not scale with
> rwsem being one of the problems (there are other global locks, some of
> which have experimental patches for).
IMHO, when the number of VMAs in the i_mmap is very large, only optimise the rwsem
lock does not help too much for our NUMA case.

In our NUMA server, the remote access could be the major issue.


> 
> Apart from that this does nothing to help high core systems which are
> all one node, which imo puts another question mark on this specific
> proposal.
Yes, this patch set only focus on the NUMA case.
The one-node case should use the original i_mmap.

Maybe I can add a new config, CONFIG_SPILT_I_MMAP. The config is disabled
by default, and enabled when the NUMA node is not one.

> 
> Of course one may question whether a RB tree is the right choice here,
> it may be the lock-protected cost can go way down with merely a better
> data structure.
> 
> Regardless of that, for actual scalability, there will be no way around
> decentralazing locking around this and partitioning per some core count
> (not just by numa awareness).
> 
> Decentralizing locking is definitely possible, but I have not looked
> into specifics of how problematic it is. Best case scenario it will
> merely with separate locks. Worst case scenario something needs a fully
> stabilized state for traversal, in that case another rw lock can be
Yes. 

The traversal may need to hold many locks.

> slapped around this, creating locking order read lock -> per-subset
> write lock -- this will suffer scalability due to the read locking, but
> it will still scale drastically better as apart from that there will be
> no serialization. In this setting the problematic consumer will write
> lock the new thing to stabilize the state.
> 
> So my non-maintainer opinion is that the patchset is not worth it as it
> fails to address anything for significantly more common and already
> affected setups.
This patch set is to reduce the remote access latency for insert/remove VMA
in NUMA.

> 
> Have you looked into splitting the lock?
> 
I ever tried. 

But there are two disadvantages:
  1.) The traversal may need to hold many locks which makes the
      code very horrible.

  2.) Even we split the locks. Each lock protects a tree, when the tree becomes
      big enough, the VMA insert/remove will also become slow in NUMA.
      The reason is that the tree has VMAs in different NUMA nodes.
      

Thanks
Huang Shijie


