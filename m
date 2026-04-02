Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596A1D3943A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B55A6B008A; Thu,  2 Apr 2026 11:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D726B008C; Thu,  2 Apr 2026 11:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C96F6B0092; Thu,  2 Apr 2026 11:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71CC16B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:21:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 180818C4E7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:21:10 +0000 (UTC)
X-FDA: 84613979100.21.E47C1BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A8841C001A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:21:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmkF6trv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775143268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEsuj9tAW4S2EEcwEEUDGnMb8ph7JuO6sY0cnWJPU3I=;
	b=D+oa8uQTAD5Ox9l6rDeAYXYZEgZCmX1uQXpy+9yQyTUSQuoiNEm+L28cr4DCaOT0zBFqG7
	P+lhcVa3WYjG+IAPIXOO2WhTzrdY9vAm3xuhMeVthB9Ax43XGHL4iR3OuWeoyreM/Z3gSy
	SVHJ0EaK4XR40NxjgMLh7tNpCe9rM+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775143268; a=rsa-sha256;
	cv=none;
	b=HflO1Ln0djMg5zkbzlhh1H5C39XTrrZQe5STCFrBTTXpAHU95EhcYySbHo4onezRxbqWG1
	i+3HWPKnr4/M89nkapmZEgTN2Av3UelHmgEK2BVDiTAtwCzFFmw41h7/karK0Fl8JGwd3B
	2oImKrt6Ne0c/uQXGscADR1XsSzp0uI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmkF6trv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBBD5444E4;
	Thu,  2 Apr 2026 15:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CC9C116C6;
	Thu,  2 Apr 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775143266;
	bh=Atdp2Yq+vZCgGPsLZHwP7QsHnIJ5JB+7tYSeJ6kp9l0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XmkF6trvPGaoNBOFUq8cHYVKBAwUkaJ9Ml+6u4twA2M2M5s3Q6gHycRVNkBOMJjZB
	 mbJouLW2pyMHlWJQ7JdWPQnFRo/vp0Vkn9bLOdvDDPPUR3leEvl/Dv2uQP2PSfY3M+
	 k+L0/3DJGyLdJ2GwMM6e2GTcFrgl3Kgdm6W4G41Hk3qtvFmCzlH1kj3Oni0AyHqcEE
	 av0fuXi5U1/HM1hXHLInEx9wPVU1obh20gFaNy9M7IPSoXJ9XyuTHxDJzZCNp8PndC
	 5mJWGTC4BEtruMawXBNMLaaO0NzykwxkDaig/BLYfl3uEhemeirthSRK+EeO9yehVF
	 qdeNrnho5hDzg==
Date: Thu, 2 Apr 2026 16:20:53 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
Message-ID: <2ecac69c-9fe3-4c29-aea6-c20d21773940@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
 <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
 <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
 <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local>
 <CAJuCfpH2eomYbZ0DzKpkae5DKVF69aRsfXx3HzMfPc6cTT5fTg@mail.gmail.com>
 <495a4331-6575-4eb5-91a5-245ab0ad3637@lucifer.local>
 <CAJuCfpEn53AgKkjLBN2AeaHxxV8vHVj697Cb=Hb-U8LisNztxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEn53AgKkjLBN2AeaHxxV8vHVj697Cb=Hb-U8LisNztxw@mail.gmail.com>
X-Rspamd-Queue-Id: 1A8841C001A
X-Stat-Signature: jszecf8m69wggquedgobe4ok7me5nsjf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775143267-898520
X-HE-Meta: U2FsdGVkX1/IvD4tOjFGkI64IWIppGCaOQoOrhybV9AHHRDZnZRrNXCTSzd66N9lejUgWdSqd1C/2BkW8KrsWf0ZRWqzibDEnbhKwAfd6r4nr18cF2HWAzSok2X6UV1cb51ANnDEVR9eKLM85xQsGK0Z6tGsEuZ+E4upbyKpKC1h9Bt5vLrJBXdRwVs4zCWH501xRYVMqHm+JuLV2OKZuwyl/icuTXIJAzFJ3ijz+kv0P67m3EYwjb/l8ykKFEpXlGJzFm6ibyQA6S4tdtfeVThWE5xBD1utlOtEW1gqDEzf7cykp0bMEtrz8Ys/wSHZ2WTPSqrnuB9x+DsD3geGYLnXDX1Q+xGjbB5EcDMzIPaC+dLYwJ3Vr1PVXSwFBvf89i77tlwuU8gI92V8xuULV6/X9EBYsg9g2jklxj03/Xh66xVeJRV7EhAF3BfxKtRzQTf1Lcou6QQAUuX3+B5hxLrSqfSmLfY2cg49j+qmLQbqUZ9UV7JwAqY4J9CAo1RC7tSWUCqyW5jzRWoha82hWyfcpxdaJUxFiEhG6WVbjAv4s7/FFcgQY9MSIgAy3qTc2fDofP/PfK5suUOlPD3vbVVNL7l0wDnXiBwNODiR+20mTVqqPPKVH64hj/WqD4IwPuo83fcf14boZxUncRRtaSUyc1fZ2zB1ocKF2MI9BePXC4AwP2VljoOkS4oSKtQRz6kip0gMcPyNM8D8aMr0/69vXfaUOvjD8M7GqY6OKNU2U2Cv3RfEQ0lXsXfX5oqBzlFWmr04mZQSrPevY5kRKgPg3V3S0Ve38eZ9XZlKn0GxEQs4gtq/0XJOO5bELjSDHOo48BHsZCAYzPVFzEda7SQ3INcBDKtziorV4PmqfqUJZl3rrUlDK7C2w1TO4kUGFEMmSn4jLYsa35Z7yNsVDR0CDoBpsNJX4u9VX28AIOVbMkUOAGl3303FHvjuQTlTAwGDTeop44WSMO6vucG
 8XX5at29
 tbuKcjsL9MOm3m0UoDn6ipYQ6urnPSMXOlaw9mTGjfaCb/DBgQ1urDvvfhqBvL4dYfKG6C4Srrx8mFD20hbhI6e/jbrIcZbJfWOlvHvjXvvScsbxz5zONUjhPztuBjoHjmN0HhB2ZGhOp7mVxuusBkta3OVaD40kgzBgF8NNP9fIMqUQTxVbxPVSIhwF5DzkTJW1wb0hpODv5tPIUDonapDe/QXNk2HpMhmKaMhdaYQKzReGJW8Q0zGZj+m5WnERaxgfO+ZBZfyiOFG30/gx4dJGuEX5EtSD2Qmrc/uJickuc6tW4/jFG2BbtPQ1JGKLpv8d/GPS/oLwYJ2lLqpFeHjrVJ6JZa8WcI4070xvwbDV8UR2j4tcjvSXZ+7GuvhL2dBxRmqsxr+CRMIp88Uq1IaPoQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:11:44AM -0700, Suren Baghdasaryan wrote:
> On Thu, Apr 2, 2026 at 6:19 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Tue, Mar 31, 2026 at 01:14:51PM -0700, Suren Baghdasaryan wrote:
> > > On Tue, Mar 31, 2026 at 11:47 AM Lorenzo Stoakes (Oracle)
> > > <ljs@kernel.org> wrote:
> > > >
> > > > On Tue, Mar 31, 2026 at 11:29:21AM -0700, Andrew Morton wrote:
> > > > > On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > > > >
> > > > > > > Instead? That is, assuming we really need to care about this at all.
> > > > > > >
> > > > > > > But I think I don't like this change at all?
> > > > > >
> > > > > > Yeah, this was the part I wasn't sure if it's worth adding. With your
> > > > > > vote confirming my scepticism I'll go ahead and remove the parts I
> > > > > > added to avoid extra vma_start_write_killable() call (3 instances in
> > > > > > all) and will post v7.
> > > > >
> > > > > Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advice on
> > > > > v7.
> > > > >
> > > >
> > > > Ack, if we just drop the problematic bits we might still be fine for 7.1 :)
> > >
> > > Let's get your cleanup first and then see where we are. I also hate
> > > the way I have to report a fake error code, so with that cleanup the
> > > patchset should be much nicer.
> >
> > Ack, yeah it's horrid, + _my fault_ :)
>
> No worries, I can wait.
>
> >
> > I can put something together now perhaps that can potentially be queued up for
> > 7.2 at 7.1-rc1.
>
> Thanks! That would be appreciated.

This might not quite be 'now' as of course it's grown into something much
bigger :P

Cheers, Lorenzo

