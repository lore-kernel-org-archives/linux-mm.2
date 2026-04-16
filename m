Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECF1F8A15F
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30506B0005; Thu, 16 Apr 2026 07:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1086B0089; Thu, 16 Apr 2026 07:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6E06B008A; Thu, 16 Apr 2026 07:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C114F6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:48:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ADA0E45B6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:48:46 +0000 (UTC)
X-FDA: 84664247052.06.722A1C0
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E9EF10000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:48:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776340124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hyAKoaUrWVN/s3zuhKLsCGJnZpFTtwjmUwQCRO+jL98=;
	b=MR5RyAVrRPgfKPobAKEsdHOqFerAzzzlCc/0uti+r4s+9hi+Kr4sSEGk59PhaeeyG0GwWb
	mkQUuLrZqIXJ7O22bDxVq+TiOrFgKe+lcvndnmCoGERi/lPu4IzcWS89Un4L7eaviMQMAu
	vr7mWG0Wum6pLkQwep99/PRCcNs+F8w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776340124; a=rsa-sha256;
	cv=none;
	b=H8iEWfRAdvWfPMsrP1zFydah2BDx/Ixtm+1cnKJ26MKET+T0Kv03l77F5AGUmt6m223Mn7
	N+/TEIdKM7hyFYU3ny9VYKHGM5HmDWJBz50aWuvH/a9o1z23ppeOav3iJK6qWnEuSoD6vf
	mXMHIJUJTqdDL8M3OPVMtp3MCabtwzM=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fxGVj1kD1z1YQpmX;
	Thu, 16 Apr 2026 19:48:29 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fxGVh5pwfz1YQpmX;
	Thu, 16 Apr 2026 19:48:28 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id CC695300D1F6;
	Thu, 16 Apr 2026 19:46:31 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 16 Apr
 2026 19:48:27 +0800
Date: Thu, 16 Apr 2026 19:48:24 +0800
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
Message-ID: <aeDMiBqscm-CZA6D@SH-HV00110.Hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
 <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
X-Originating-IP: [172.19.26.208]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1E9EF10000C
X-Stat-Signature: r89cfd948nifodtkaotwfckx474aj9rq
X-Rspam-User: 
X-HE-Tag: 1776340118-99599
X-HE-Meta: U2FsdGVkX1+l7o+fRBsafDnXCgBch9QBlg+d/dSarB4zqm6znmM+ySlsEnKAy+yNdE8RaVleLpCiYtHKACKDNC7uXvM3uaD3RrQYJFNByPdyFgD718ak9QwCQOfa3b0d70rjvQ36LI46ggdSedMIQrHM8grNkIcynshzK4JeF8rBtQzgnwJrKIWDR4EV+sVyJ0FHsDum61dHhFUGduOiYeONbWFQMgItNEN5qYpN8oqOfIFz2Vsbk/iv2Xdczbzk533lYorbPW9+HRtO/JVjRN6+B+MD3kNbgnF2gUCsLMgpRXlF+qXvA3cxeb8IzpfwrEf0w0ZXbbM947mzVnBEnVSuVKHlOzz/oVn/uxrWJF7RtMyNXVBtITU5sg3m0O/YcnFV6rYcEpxKCwPg1Mcbf2ISRK0SNwT5v0u5j2Xf29T1FWiqtdHKihBl2SRKChVLesHegBUsxGdXce1/cvcXZLuzRgf4Uv+3fmVGLtuMgDsET160AYkdf3kfTKXvNcV9+fAutvQbOTS/ZKopy9YtvxWoiEL57qDS4SOtBR0lpRKxgWtIYi2AYz/a2BBBp+oBfk2+fJPsBIAGpvmNw/M2mYN6lKsckpjD7TT0EigifeNQF2Lt8UrJkdNm7daPdhkRhA8oA55j8BBdfb6E+D0+9r0++EW+yza0kmuxcLqflX5OjI04jLlrrvrwAidwr1fzmlK4OBtOAW/M/8vvk5Lm9M+JElB9YvTxChphg/CVVHMioOw5XGH8UR/3MBdlo85kUC4BhSqYFl/aBjeUyB8ubU9xMyNOVrf6Wr4qu2phepFJ9CNpbEQpDH/F6Add3N7es07kalChVjbTJkxPCGJwC/MTlsP+A9LyMrbb+uWv8tfQ/nbzQ0Xgy1GTY52FEq5JQCX3WHFoywlweBR5M3uAvvgRxr3IVHfaADYakmqmmiQiBFTp4Q9zfCz6Mar1iTkF72kH8lhjG3L9QYMXk0h
 tBomQtQl
 i4f/5VHqdXbPWQDRhxTuUpm8xh+Vt3VgWkHBzPnb1Pv0ZX28sc5cjFdy8wVHboN+O3c58GIGm9wpXtdQxPfXLPorHok7b4WmYoTup6BDKkRnl355iItm+m3DqAS24XeEwl6au45mV+AMS8kbjvVW+DcDej0AdAuYKPtTrHhOxdPDxS06YDhuO1NkQYEqO7jppBeC871WCIf+gZklFi3Z39Q7i2+hlaeYqSTyzaQZzPPdNLzOVE2DCucyxzwC3/giYbEfA52LIih978ce7c9buH5FSDwRB769nNmUeqOByj/gu0JUcqyoQw5cnD7cDxDcESeJJeYSxpI4AAJGlPX8o80W2t6faJ1AevUGTKM6d0zu1JLEOsaeYAPSUnmWsDdAzvyHfoQCfutNWO//4JjBBsXHNRzvZZ6Cbswo6Bl2iSOfh5Lnjb0xJ4AU1uMunsWjYTK85CuYFo1eq0aG2+RVsJ9CgN0EsmL32ZqG5d3J+JZMDS6CjEnQy1Ln48y8/rFnE5/kG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 12:29:50PM +0200, Mateusz Guzik wrote:
> On Tue, Apr 14, 2026 at 11:11 AM Huang Shijie <huangsj@hygon.cn> wrote:
> >
> > On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > > In the UnixBench tests, there is a test "execl" which tests
> > > > the execve system call.
> > > >
> > > >   When we test our server with "./Run -c 384 execl",
> > > > the test result is not good enough. The i_mmap locks contended heavily on
> > > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have
> > > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > > The insert/remove operations do not run quickly enough.
> > > >
> > > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > > patch 3 splits the i_mmap into sibling trees, and we can get better
> > > > performance with this patch set:
> > > >     we can get 77% performance improvement(10 times average)
> > > >
> > >
> > > To my reading you kept the lock as-is and only distributed the protected
> > > state.
> > >
> > > While I don't doubt the improvement, I'm confident should you take a
> > > look at the profile you are going to find this still does not scale with
> > > rwsem being one of the problems (there are other global locks, some of
> > > which have experimental patches for).
> > IMHO, when the number of VMAs in the i_mmap is very large, only optimise the rwsem
> > lock does not help too much for our NUMA case.
> >
> > In our NUMA server, the remote access could be the major issue.
> >
> 
> I'm confused how this is not supposed to help. You moved your data to
> be stored per-domain. With my proposal the lock itself will also get
> that treatment.
> 
> Modulo the issue of what to do with code wanting to iterate the entire
> thing, this is blatantly faster.
> 

I tested an old lock patch yesterday. It really helps a lot.
The lock patch is from this link:
  https://lkml.org/lkml/2024/9/14/280

The test results:
   v7.0-rc5 + (lock patch)                    : improve about %60%
   v7.0-rc5 + (lock patch) + (this patch set) : improve about 130%			   

						
> >
> > >
> > > Apart from that this does nothing to help high core systems which are
> > > all one node, which imo puts another question mark on this specific
> > > proposal.
> > Yes, this patch set only focus on the NUMA case.
> > The one-node case should use the original i_mmap.
> >
> > Maybe I can add a new config, CONFIG_SPILT_I_MMAP. The config is disabled
> > by default, and enabled when the NUMA node is not one.
> >
> > >
> > > Of course one may question whether a RB tree is the right choice here,
> > > it may be the lock-protected cost can go way down with merely a better
> > > data structure.
> > >
> > > Regardless of that, for actual scalability, there will be no way around
> > > decentralazing locking around this and partitioning per some core count
> > > (not just by numa awareness).
> > >
> > > Decentralizing locking is definitely possible, but I have not looked
> > > into specifics of how problematic it is. Best case scenario it will
> > > merely with separate locks. Worst case scenario something needs a fully
> > > stabilized state for traversal, in that case another rw lock can be
> > Yes.
> >
> > The traversal may need to hold many locks.
> >
> 
> The very paragraph you partially quoted answers what to do in that
> case: wrap everything with a new rwsem taken for reading when
> adding/removing entries and taken for writing when iterating the
> entire thing. Then the iteration sticks to one lock.
> 
> The new rw lock puts an upper ceiling on scalability of the thing, but
> it is way higher than the current state.
Could you tell me the patch about it?
Is this lock patch merged ? or not?

I can test it.

> 
> Given the extra overhead associated with it one could consider
> sticking to one centralized state by default and switching to
> distributed state if there is enough contention.
> 
> > > slapped around this, creating locking order read lock -> per-subset
> > > write lock -- this will suffer scalability due to the read locking, but
> > > it will still scale drastically better as apart from that there will be
> > > no serialization. In this setting the problematic consumer will write
> > > lock the new thing to stabilize the state.
> > >
> > > So my non-maintainer opinion is that the patchset is not worth it as it
> > > fails to address anything for significantly more common and already
> > > affected setups.
> > This patch set is to reduce the remote access latency for insert/remove VMA
> > in NUMA.
> >
> 
> And I am saying the mmap semaphore is a significant problem already on
> high-core no-numa setups. Addressing scalability in that case would
> sort out the problem in your setup and to a significantly higher
> extent.
I am afraid even the lock patch resolves the scalability high-core no-numa setups,
we still need to split the i_mmap for NUMA.

> 
> > >
> > > Have you looked into splitting the lock?
> > >
> > I ever tried.
> >
> > But there are two disadvantages:
> >   1.) The traversal may need to hold many locks which makes the
> >       code very horrible.
> >
> 
> I already above this is avoidable.
> 
> >   2.) Even we split the locks. Each lock protects a tree, when the tree becomes
> >       big enough, the VMA insert/remove will also become slow in NUMA.
> >       The reason is that the tree has VMAs in different NUMA nodes.
> >
> 
> This is orthogonal to my proposal. In fact, if one is to pretend this
> is never a factor with your patch, I would like to point out it will
> remain not a factor if the per-numa struct gets its own lock.
Yes. It is orthogonal to your proposal.

Thanks
Huang Shijie


