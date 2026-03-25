Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E34BFEA833
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFDA6B0005; Wed, 25 Mar 2026 04:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897106B0089; Wed, 25 Mar 2026 04:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4346B008A; Wed, 25 Mar 2026 04:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5DD6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:41:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A9C913BA8B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:41:08 +0000 (UTC)
X-FDA: 84583940616.12.C5A6111
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DD87140004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:41:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y4jFv167;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGEC3+QRRV++u6fm1ROky4+idWPwyJ0Hf+Nyi5mqsVA=;
	b=32Xv2VYwS1S+dkNfUmal3rkTfMo4zy+reNJuhvrhd09DtiFvEpf0IBTjhQw33bo5Rsdkwq
	lOINOdjfcA3nSr9Z6dPFi+ikZLnys1LDlA2ZsIkPoXU6zKqjVSXswiydrTA0dsqkiq4Fts
	+Mg3tzZHlKeXBkhDqaVJXX8waj0vVfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428066; a=rsa-sha256;
	cv=none;
	b=bMDysAPvQtFCeMmtV/raAoHiVQPlqCxg6b3DelYiNn4alXCwpx8oJIJsEdSSxhJm5mKexK
	W5wVCBn9aYDbGs1JwzS6prEhilh4Bso2FRFZv3AbFtB/0jFEbR5N8kw4JxqFvk+XrYYoFv
	0d4xltVRQWT2YIf+8LXkrHcInLsMu6w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y4jFv167;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAF504322E;
	Wed, 25 Mar 2026 08:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738AEC4CEF7;
	Wed, 25 Mar 2026 08:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428064;
	bh=VoCiz3ON/XRxstQzyULut+tSmIRHjLrwWfAkX9hDBNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y4jFv167vNjvFKyMG21F9RFl83kEBTAPdr0uiDYB1d6HBPHx3BLTOjCvh/zXm6J6l
	 t/lvzvxt9tQnQqGXp5RQIfmlCl3+eoiJunwtNPaDhqaYFt0XO/sWtfXimjSqg80BQt
	 2u2rldl0O/UOe5Fx1IA+TT+rpLCZwG0qXhqLe35bHuDSITtH92zp9MC1pawOrtUKMz
	 awULzxr3hKuWlQnLj79eLRLboJHo1OyYqOV3WOUMBWLfe2yCiw+kekz1FwICRGGoc5
	 U3D5B+aHxRD1PChTl9tUDH38NtXNVXyleODdzFGiJoc9Uevu7ReAGA+cIB4FMiVjng
	 AaBPV1D/rP2XA==
Date: Wed, 25 Mar 2026 17:41:02 +0900
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
Message-ID: <acOfnpjoj0FIGXKc@hyeyoo>
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
 <ff139493-1964-4285-947d-1b43fe40f8e5@kernel.org>
 <acOa8ErxLgbj0Uer@hyeyoo>
 <de209b21-a39a-4c8e-8f13-458d095c1325@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de209b21-a39a-4c8e-8f13-458d095c1325@kernel.org>
X-Rspamd-Queue-Id: 4DD87140004
X-Stat-Signature: aeetnnkf6cr84axsqc6wukycoastbyoq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774428066-224310
X-HE-Meta: U2FsdGVkX18wDVFwhBbcpj4nEntKQgEFyUpbWu2ksdnbfJB2LGW4zG4dDkZ6d2q4kvDEr6ZCQEx8RwvElQFcAYGPEvqOna60ntgEfidsuQ8Vnx/1BpjDAPlU9nKIvpUfnWBstB7UK67PtykozOiXtYKjn9qLGgzQvv8nfwcyGMUTfUmZIDQfywx65Fnm9pkfuHeNcuS1M5AKC5vG9szphMZSvMT2MqIKMT55a7we9yWUWuygrNjJuXcxk2doAncfLUnm7StDTGESEhgUCnkjt1oJDljZTjxWYg2gJln/fzPVAeV5ULe6neIOSa0kPlgj3nFmMmHs34JZFK3hNSwRW9qK1VTZi9xTcaUZy6bpp2XXkzL4uOzsJtEMBaWLSOzJKnREHwgalSnVss87MNpAPxT66tptwXGlNJ+x4G4XkwnlkXWtQvHEi9aKxPmFC09C40930Q8f7dTqxwGX+i7PgsWrH2ujLiDZsZrnVew95OX2oW4+RJPbk6PTOuTluHUZW5Jx2bXk/8Psmake8uno3JzkAOkW4+sQIjjTPZ2Xe54XF8D+NWia326Nc+sfznWvQkvFM1Lb+PnpMuaKKd08npXyefPL8iJF/9H9QsKMwJyQjdoYY8XeY9CXlQOPdiNUQOiNFWlqyRG/CbSuBBfxdZ+o2V3p/NWQ/2lV77kI8CdLFWaSTZmy/VCidkk89qKrinJcj6XuVjFVKMx1BjAgEbZRPqdzFt7D0XCRoM5gyAKg0usV/Mtqp2aZjbKIAA+p0Z1kShKhscs7qFb/HtdbMKrri5JwfyZI5GoyJb1u043MnpbIjEQG72C1LZHoKZhjM4kvkxUt+60tBO20Cn2FVVMdjRH2eMsUmFIGIbEJC7j1tY/coVBB7FOHiAsNNDPek528USYpZ8vAUxDFjWnPPMTt9pY8U4npf3+xA8H8wSAwbSG/aXSAZZC9QfCYj0WaVH30T3FSps/o4Nkk3r1
 itKmEOJM
 vWdOenVNj6YUrU5V68ydkkg9L76YAQpm3G/kV8MmlV/Ybs02d5AvH/cwmJMiEGwn9JmSWkaJH276PruJwUyWQKrcO6XCy0MsYQDtVfEROyQZR+IiHuX8UwYkaAk/L/xRK8WA3fECmh4s0sRuNx37DfyMcwh3/o8wdm8F9ub7zP5ASCP4NzGw28mCql9XcCyci+4gC8ePvS9Hxy53A7vA1W0MBhZMzC9blp77JDkQZs6enrZgMOz7z5VoI6a9vtjqVi3MPH12UQXPCQCpHzfdZ4C82dRMvOOEHR/u0DrpL1a9l8VOk5TJrzT14gtvyjkOw5k3O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:34:40AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/25/26 09:21, Harry Yoo (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 08:50:07AM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 3/24/26 22:35, Jann Horn wrote:
> >> > Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> >> > so that kernel fuzzers have an easier time finding use-after-free involving
> >> > kfree_rcu().
> >> > 
> >> > The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> >> > callbacks and free objects as soon as possible (at a large performance
> >> > cost) so that kernel fuzzers and such have an easier time detecting
> >> > use-after-free bugs in objects with RCU lifetime.
> >> > 
> >> > CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> >> > RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> >> > expedite; for example, the following testcase doesn't trigger a KASAN splat
> >> > when CONFIG_KVFREE_RCU_BATCHED is enabled:
> >> > ```
> >> > struct foo_struct {
> >> >   struct rcu_head rcu;
> >> >   int a;
> >> > };
> >> > struct foo_struct *foo = kmalloc(sizeof(*foo),
> >> >     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> >> > 
> >> > pr_info("%s: calling kfree_rcu()\n", __func__);
> >> > kfree_rcu(foo, rcu);
> >> > msleep(10);
> >> > pr_info("%s: start UAF access\n", __func__);
> >> > READ_ONCE(foo->a);
> >> > pr_info("%s: end UAF access\n", __func__);
> >> > ```
> >> > 
> >> > Signed-off-by: Jann Horn <jannh@google.com>
> >> 
> >> Hm but with 7.0 we have sheaves everywhere including kmalloc caches, and
> >> there's a percpu rcu_free sheaf collecting kfree_rcu'd objects.
> > 
> > Right, but only when CONFIG_KVFREE_RCU_BATCHED=y
> > 
> >> Only when
> >> it's full it's submitted to call_rcu() where the callback rcu_free_sheaf()
> >> runs slab_free_hook() including kasan hooks etc. If there's nothing filling
> >> the rcu_free sheaf, the objects can sit there possibly indefinitely.
> > 
> > Right.
> > 
> >> That means CONFIG_KVFREE_RCU_BATCHED now handles only the rare cases where
> >> kfree_rcu() to the rcu_free sheaf fails (and I still owe it to Ulad to do
> >> something about this).
> > 
> > Right.
> > 
> >> So to complete the intent of this patch, we should perhaps also skip the
> >> rcu_free sheaf with RCU_STRICT_GRACE_PERIOD? (or with !KVFREE_RCU_BATCHED
> >> perhaps as it's also a form of batching).
> > 
> > Maybe I'm missing something, but...
> > 
> > by making KVFREE_RCU_BATCHED depend on !RCU_STRICT_GRACE_PERIOD,
> > selecting RCU_STRICT_GRACE_PERIOD disables all uses of rcu_free sheaves?
> > 
> > kvfree_call_rcu() implementation on !KVFREE_RCU_BATCHED does not call
> > kfree_rcu_sheaf().
> 
> Ah yeah, I missed that there are two kvfree_call_rcu() implementations and
> kfree_rcu_sheaf() is only used in the batched one. Sorry for the noise.

It's confusing indeed. I was trapped by this yesterday, thinking...

"Oh, why doesn't kvfree_rcu_barrier() on !KVFREE_RCU_BATCHED flush
 rcu sheaves? It's broken!"

and then realized that I was confused :)

> Will queue the patch

Thanks!

-- 
Cheers,
Harry / Hyeonggon

