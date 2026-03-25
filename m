Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E63FEA830
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20E76B0005; Wed, 25 Mar 2026 04:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1936B0089; Wed, 25 Mar 2026 04:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7196B008A; Wed, 25 Mar 2026 04:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDF536B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:21:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B59BE0B21
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:21:09 +0000 (UTC)
X-FDA: 84583890258.29.01CE26D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D5A9A1C000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:21:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CgfwjAPA;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774426867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4NtsManVG/+YA5fe+q53eiXn98nWivTtqAzBoa8DNw=;
	b=fI51s8cft+zcuKsPbJGR0mCW703jxohceotOacMd/IbGn8guZ+mnDdZG1JQj6ImvK9ZJca
	skje4636vFsbWfRz+9H+AiechMOYhkJWDCU5YYaKSjVXUpVDifypJdfEMBB5wlglpxvpxM
	iZ5hpE2HEoBaF47u41al1tWumcyWuAY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CgfwjAPA;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774426867; a=rsa-sha256;
	cv=none;
	b=UjGsz9/08H90wXYW2SFFEdJspXPqIDvyQc2K64qiY7mpEiGQvKND1GE3OWIWvQJtYrYnLN
	gIFBPvJOq075Hulo9gSpVmWDLWa0FB5FFwQRYkePzreRrzBjTKfvJTzZ+Zax6NmE8+vjVv
	M3iQkTorVAROSVgM9xNKBVCgE/42ZI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E26600AC;
	Wed, 25 Mar 2026 08:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA6DC4CEF7;
	Wed, 25 Mar 2026 08:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774426866;
	bh=xtTqnitu3TW48SKq+KlTXctNXAybsV4dU5ERnJ2rg7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgfwjAPALc3vJtvk9P/WA4ZHnZCgtKjZq57MtcMFdQBGa4Q5Hr5uGHpd4JJYMHgHw
	 xNG4UXwNkp2n6/Q8u3YHlKNRoX8xEdyGtn1eA/qvX0Nz5ycfMtzrAZ6jJJ27l7j2Rp
	 qfKvvuIT1gbIY1YBFtAUC2L6+EijPtgrPqZtFSFNFteGTDGezz/Q2gOXjdbkAL1tk2
	 NouhzIJsE0LVLOEy3RdLXv0kFTU1AP6zdnlW/X/6ROLlkVsTFwkasWDqfheNa8VSQl
	 aOf+uL/TU198y+Xy7fgUBelvXgp72+62cBTIdpJ7cUfyoz2b0xOa0R6ZGvOSs+W7Oo
	 UoGHU8cdX09bw==
Date: Wed, 25 Mar 2026 17:21:04 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dmitry Vyukov <dvyukov@google.com>,
	rcu@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
Message-ID: <acOa8ErxLgbj0Uer@hyeyoo>
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
 <ff139493-1964-4285-947d-1b43fe40f8e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff139493-1964-4285-947d-1b43fe40f8e5@kernel.org>
X-Rspam-User: 
X-Stat-Signature: gpide6edmmkib4ucape639judzebmein
X-Rspamd-Queue-Id: D5A9A1C000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774426867-699382
X-HE-Meta: U2FsdGVkX18BkeCQAvaOYrB7VFKk5MxItEKnVdXFpAc3z6IyQR3LmI9VkKCq6zuxWL39ZPzyKv357c3nn4MEcH0/CuStlpHzj6hlkDsuHGmwZL5GWEucD/8dGvxRgozh5QM18j5vtGm2/qQbZghRLKE6kpQ0fDhs89gFXk6qCqpEjC+2IdHrfKsoR+wStA/az3sVkqMI5uw+IpVXtd6sUuZaxgsMe+xXZFsaW6SW0vbPKKvURcxuhNZdfIptgEviy3gHkG/bQxqFFX8etR30kdXy6wpajvbQqBqK7iYXQFg+ekL2BI/ItkLvJZ0U0toFvpCUNC2n40RrG5v7xcHdVWm0qAAM3mUrHoh0fZXGwVP5tjorzh/snRcDTU204qkNf7eoI+fP/DE2RhbSz9QR9HPGUmYNpSWGiTjxWY0oFuzj8NWt7ftIFtOk52nvGjfbfKR4tiDKqzKfvbWVk9oiBI6ejNjRXsZYrfNUFgoB+EPLzpktxSdOO/sxN0EHW9/Ich4NR3N97i7PbK/9x+Eq9uz7jGb6EoZTG8dpsBWK4bQm/xAwRNyfwdk7RLA4gy1fBnH/YRKF3Euf6+5sqBVH4pcmeoZ2ctqa81jjuO5X6YjeLJAfihX+ftZj6GV2qzVcZfGOrCGKSSWq3fS/155jZWjdV4hlOEozs//fz/U9PhQu2yI140o4ujNMw0WDMN0izT47FeTCa0sbzGgHJnSmg/7wx2T61LXPJeksMbBtUk3QRelb28xpXMVLpes+rtxD3Ba58N9G46eyRnQXPrm78CyEwW0VG67WRSOrQFrSBxN3I3wccCvL9gK+tKVgNTQLR1X4jRlhBOa0X4dTXgrPKFavXjocvShoZQLB6yc3Zosgy25cHQ7Saf/LG4Mvr+3yiAuj0OC4Yoy1+HlhoMAPxBlB0x48wy5sQS8I6kbkzi1pmyj03uVoNTl2+FdznSFBGimr/KYUviIdU+sHHBV
 OrDu2pym
 nvnebYp7IY+ndyyydBudZ4VmtdUIpPFguEn30+l6Qgd1Uj8n/ivfQC2jGzAkikqM9xweBhwoW87n4PSQm4B7yAqzdH9UKrYUw9TlawamlqaxYEms69ab4OVimmpXsOH7AW8pGcG23xjJp3sR0XjKkRfU0CgiNpVFYewgBDzx25QG87q1dFdj/fQRSH0+0A9v7ixneN+Ul2mlZcejS6k6fBL3fBFqnGw4pnDG1P06mVR8T3L24Y0jgabIqlfzos0bKYsSzh/kHdu6prr339T8l2LF8QH6hh7GfAz+aPZT0oYx5/78d0pc1MQT/ESaW7JcqyOz0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 08:50:07AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/24/26 22:35, Jann Horn wrote:
> > Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> > so that kernel fuzzers have an easier time finding use-after-free involving
> > kfree_rcu().
> > 
> > The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> > callbacks and free objects as soon as possible (at a large performance
> > cost) so that kernel fuzzers and such have an easier time detecting
> > use-after-free bugs in objects with RCU lifetime.
> > 
> > CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> > RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> > expedite; for example, the following testcase doesn't trigger a KASAN splat
> > when CONFIG_KVFREE_RCU_BATCHED is enabled:
> > ```
> > struct foo_struct {
> >   struct rcu_head rcu;
> >   int a;
> > };
> > struct foo_struct *foo = kmalloc(sizeof(*foo),
> >     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> > 
> > pr_info("%s: calling kfree_rcu()\n", __func__);
> > kfree_rcu(foo, rcu);
> > msleep(10);
> > pr_info("%s: start UAF access\n", __func__);
> > READ_ONCE(foo->a);
> > pr_info("%s: end UAF access\n", __func__);
> > ```
> > 
> > Signed-off-by: Jann Horn <jannh@google.com>
> 
> Hm but with 7.0 we have sheaves everywhere including kmalloc caches, and
> there's a percpu rcu_free sheaf collecting kfree_rcu'd objects.

Right, but only when CONFIG_KVFREE_RCU_BATCHED=y

> Only when
> it's full it's submitted to call_rcu() where the callback rcu_free_sheaf()
> runs slab_free_hook() including kasan hooks etc. If there's nothing filling
> the rcu_free sheaf, the objects can sit there possibly indefinitely.

Right.

> That means CONFIG_KVFREE_RCU_BATCHED now handles only the rare cases where
> kfree_rcu() to the rcu_free sheaf fails (and I still owe it to Ulad to do
> something about this).

Right.

> So to complete the intent of this patch, we should perhaps also skip the
> rcu_free sheaf with RCU_STRICT_GRACE_PERIOD? (or with !KVFREE_RCU_BATCHED
> perhaps as it's also a form of batching).

Maybe I'm missing something, but...

by making KVFREE_RCU_BATCHED depend on !RCU_STRICT_GRACE_PERIOD,
selecting RCU_STRICT_GRACE_PERIOD disables all uses of rcu_free sheaves?

kvfree_call_rcu() implementation on !KVFREE_RCU_BATCHED does not call
kfree_rcu_sheaf().

> But then I wonder if the testcase in the changelog appeared to be fixed with
> this patch on a 7.0-rcX kernel (base-commit: below is rc3+) because by my
> understanding it shouldn't have been. (unless there happened to be enough
> kfree_rcu() activity on that cpu+kmalloc cache combination, so that the
> rcu_free sheaf got submitted withing that msleep(10)).
> 
> > ---
> >  mm/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index ebd8ea353687..67a72fe89186 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -172,6 +172,7 @@ config SLUB
> >  config KVFREE_RCU_BATCHED
> >  	def_bool y
> >  	depends on !SLUB_TINY && !TINY_RCU
> > +	depends on !RCU_STRICT_GRACE_PERIOD
> >  
> >  config SLUB_TINY
> >  	bool "Configure for minimal memory footprint"
> > 
> > ---
> > base-commit: b29fb8829bff243512bb8c8908fd39406f9fd4c3
> > change-id: 20260324-kasan-kfree-rcu-4e7f490237ef
> > 
> > --  
> > Jann Horn <jannh@google.com>
> > 
> 
> 

-- 
Cheers,
Harry / Hyeonggon

