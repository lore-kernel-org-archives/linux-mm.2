Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E29F606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gu+FrPnq
Received: by kanga.kvack.org (Postfix)
	id 9E6166B00EF; Wed,  4 Nov 2026 07:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9971F6B05B3; Wed,  4 Nov 2026 07:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACEF6B05B4; Wed,  4 Nov 2026 07:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67B5B6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:00:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FA3A120699
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:00:06 +0000 (UTC)
X-FDA: 85397293212.29.EA2A64A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0B0840010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:00:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gu+FrPnq;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793793604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ8X7ehvFW1TVL5y6djFbsTpKjfmqXVJak4szFfMMAs=;
	b=lDiFquLH5t2bQeJMdd51GKP47+Z6W80aSc1j4I7Lr4FvW5i0gT96DOZf/LNN8B23XbBBeQ
	JK6ba9kTQEsIVh973mvqwRKmWKvOxxYgroDUlBmglD7l2V23uVlMP9wDUGPjD1CbbafH/Q
	qc4VS1NnacJjFoXpy91yH6sOsMFHwR4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793793604;
	b=zRPnsd6ah6Np13ivhetZoHZd//KveABGMOF+pLenfypxdkBN8hUvimTlk3se+QJlaKz0GV
	5SYyhwbz4nLK9/jNY/uc3i1IcLjQky16ttuVVqXaGSmcBsNkEUKCLm9YIk1hobKMd2raL7
	QsdC6xpJYUpFeDPCtNiAMljPsysZuFw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gu+FrPnq;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8958943639;
	Wed,  4 Nov 2026 12:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A301F000C1;
	Wed,  4 Nov 2026 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793793603;
	bh=jJ8X7ehvFW1TVL5y6djFbsTpKjfmqXVJak4szFfMMAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gu+FrPnqdrGmlJP8rTwsTc3xsSUf+Vsia3jvIyTityWnn8TvjEd+mK9AMtrhRn+ww
	 Pte6DhgOcR/eDe0Mt6yxZ89tc/Q2ZWrfHf8Wj6/AUrR2b3H13C96Sf3TxVSVdZq7Cv
	 7QDLYkvfDZXJV4JnAH6IN/UhbS9j/IzwB1T7vwtaX9pcjv9ncdi+9kodKrsew5MWCi
	 JFVCcZBUybJrplG9sox03+J4OMR3ayamgY0ZpGV1Fsh0teewipxFsSRYIIwOzkzYPV
	 OAeW+lPuicqKYpZ2YKUxnefMLDXn55qr81P0rzYuhK1GdtjwoVzn9soLSlbsTnPRtx
	 DhQzOC2ZEIETA==
Date: Wed, 4 Nov 2026 12:00:01 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
Message-ID: <ausdFvI5XyDNrrR0@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
 <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: ussxa5jyzgx35cne4jrsgwhek5yxj7fm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B0B0840010
X-Rspam-User: 
X-HE-Tag: 1793793604-158806
X-HE-Meta: U2FsdGVkX19XMv3mc+HPNI7kOd7Z8T4uG86qHR641vjsz/ii/wutPkjuC2Ey5ea8Y3RhkHXerQqUAst0hKi6V+VV47pqiGISmZxz66JV81DlH/kPMajoYeMebWJkA8ThnzbgeZsGd7t50WYzQhXnUoG7of/JWDF7EMXeJsLRYP0hY2gYKKpwLeoZOreQkO1ZpXeqb3mJBdFcLHIu9Ny32FJ7xMbZevhcFlAEVRuCSsuw2Mqy69G8+S4+ex5mBwbvERQsI4L1trKAOyfNHTev9USpk+T+lJeiT0oX1VGxt+5UnhpKbPSiKyNSlhKiwLBsXHUU63MuLLPl7KXsFkoAKB+EQcoq1fWymWsA1jcziI43xjCEaXo+rF2UzemjnZhp3HCkyD1j1fUXdTJlCCAsVQiwozCmfRmobsXMRPVBxISDbUO3TyXHRYY9IDEdW29i6tZcqvJzd9LLGbtwcMx7Pfp7QdjC3ACh81mWkafB2S9FgQzsZ8440VQW9IvDa3nxzjLVcwJJzv8fQGPniJTzx3dFZvX8eQoXP7JZ2rrDJGF2yKdktFxt7T5txVKJrut/y2LQTzDSZ8t8fAadWE7by+CvokVjXVFOw7y/ETu3IMBFIIQRq36a+aZYPdo0lpIEcEh8kqBRndSLusYU66fqs75OsQBKj12zUrcFQF1+rqnWBtWpdj+OV6heeAwmfq052eSQiliffWA4JVKT25K1yHMbg+QL/SpJtNm5TqHwS5qnvq2+3Ksz44jgYVb//KRodPtIBiF2hR8jTAzvHwy7E8C7GJpB6sTL50l4PJ8rL2fxOLMiOfiDUMTAxfevbadcGwejODIOBpvvY084iS46+0GaUQOc1ShOnygy7JRCeCwmmnBkHaK9Veh9LMV0dm7S7Bcx8sGpuEZgZf93pqTu7832MH4cbHynG4w36p8L3sHbM65wigUMBI9OK3gyR+w9bUjjsJrNsn4r7B36l8J
 pACMVngm
 shN2syOkhsd1jl/2IMRoIKE/b8ABE5Hc2iwaEj26MESduaOU6IdqLnDLf4TIepqgdGpOxyXDQ0ro75GgLiu/zSOUCun7EL/NUIzDWwXLzF/kJCEqxkOCDV1RP4AL9eg4La7iS8wNvlkq6lGa1pezSpIvS19u1DD3HZqNKOABk+2WQLteUCLEKDx3p3Fr6zyelgWO2Ly6x4FzL6qQ6Jw2z67OOCn3mjrRL/iLq02PrTXmIKmYc6E4VT1pOyatQDVUV0W4JUmT+RiDBo2UcAKj7esmj4HTfSunCWgcq+GvF7q8PDLINmx07q2bPokre6AXYn257pnG7UTjWingqtxdkYIuiITpSMlaF3bXq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:02:55PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> > obj_cgroup_put() can be called from any context.
> > __memcg_slab_free_hook() puts a per-object reference on
> > every accounted free, and draining a per-cpu objcg stock slot puts
> > the cached reference. When it drops the last reference,
> > obj_cgroup_release() takes objcg_lock, frees percpu memory
> > (pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
> > these can deadlock when the current context interrupted a holder of
> > the respective lock.
> > 
> > Defer the release to irq_work. llist_add() and irq_work_queue() are
> > NMI-safe, and the irq_work runs in a context where acquiring a
> > spinlock is allowed.
> > 
> > Add a separate llist_node instead of reusing the list/rcu union
> > because the list stays linked until the deferred release. struct
> > obj_cgroup grows from 56 to 64 bytes, but both are served from
> > kmalloc-64, so no memory is additionally consumed.
> > 
> > Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> I guess releasing objcg isn't too frequent, so it won't matter that we make
> all cases use the defered work

Yeah, objcg release itself uses a global spinlock (objcg_lock),
so I think this is fine.

> instead of somehow trying to do that only in
> contexts that would really need it.

... and this is not easy as the percpu refcount callback
doesn't know the current context.

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> since memcg tree will be used from the next cycle, we can just keep this as
> part of the series in the slab tree?

Ah, I see. Will do.

-- 
Cheers,
Harry / Hyeonggon

