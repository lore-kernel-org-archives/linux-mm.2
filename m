Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54692CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3016B0088; Wed, 24 Jun 2026 09:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472526B008A; Wed, 24 Jun 2026 09:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CC56B008C; Wed, 24 Jun 2026 09:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB096B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:41:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 982F3C1A11
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:41:28 +0000 (UTC)
X-FDA: 84914918256.19.C5F3B71
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78FDD18000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:41:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ojTLct+B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jsl310v6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ojTLct+B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jsl310v6;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782308486;
	b=qvUNH/MbMemXlWgrxCOm5lf2Ot0+R8MEH5011/sDBEbvGS6wLJu1tBvCoGaLc6O2qqEcoX
	MTBY7tq1CdjuA2WIKccORaQ3Wvm1LMAfNCJPT+iwnQazA4+DTiGB2J22/QL3lG7Y7oGipR
	BsNQgFuHvyT0pAMMwU5TVMF1s1m70zs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782308486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR3sJGwujfNLRWW+1TBYQaHSIL+b0DW9aOFZ/atPQkc=;
	b=R5xz9FG5UiEB13RnyXWgdLc5e0MW6e4+66DfSMA1wXHcUTy3U/HRtuRDbl/Y/h8NqJKQj0
	xpT8e3nxqP3PwdBdSP7IlVdgmxSlzB+gEj9UZhXfhz0NzauIAgRHlrFn/OSvR2KVkLW+Z3
	uQbslpXB1bBkzbX1zURXcnYbUepdPXc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ojTLct+B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jsl310v6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ojTLct+B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jsl310v6;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2F8971425;
	Wed, 24 Jun 2026 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782308485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sR3sJGwujfNLRWW+1TBYQaHSIL+b0DW9aOFZ/atPQkc=;
	b=ojTLct+B6Q134cNmxEmKnlNW4Pb1dd55qKYAkyXLnMwKcccVDVIAbU53kcQXsWUTFNxcZU
	f3AbFAVyVqVrPvoh/v1yXrWpnaZg1fGcg77FzYPvMRF/JM06fkneXi6LHW0hCO0+sKSA3t
	+gcNyr7zjUk1MLR5OIZYRAhlxe+cWA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782308485;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sR3sJGwujfNLRWW+1TBYQaHSIL+b0DW9aOFZ/atPQkc=;
	b=jsl310v6c3qVx+TvswUZhMgyeTEJklTDi6CIYB/IJ9khWjX18P2wLJVMQVkAAHNFRDtTjH
	3W6gTUn2NJX1VlCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782308485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sR3sJGwujfNLRWW+1TBYQaHSIL+b0DW9aOFZ/atPQkc=;
	b=ojTLct+B6Q134cNmxEmKnlNW4Pb1dd55qKYAkyXLnMwKcccVDVIAbU53kcQXsWUTFNxcZU
	f3AbFAVyVqVrPvoh/v1yXrWpnaZg1fGcg77FzYPvMRF/JM06fkneXi6LHW0hCO0+sKSA3t
	+gcNyr7zjUk1MLR5OIZYRAhlxe+cWA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782308485;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sR3sJGwujfNLRWW+1TBYQaHSIL+b0DW9aOFZ/atPQkc=;
	b=jsl310v6c3qVx+TvswUZhMgyeTEJklTDi6CIYB/IJ9khWjX18P2wLJVMQVkAAHNFRDtTjH
	3W6gTUn2NJX1VlCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22AC3779A8;
	Wed, 24 Jun 2026 13:41:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FeK3BIPeO2q0FQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 24 Jun 2026 13:41:23 +0000
Date: Wed, 24 Jun 2026 14:41:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
Message-ID: <ajvczSpMOGWFhe30@pedro-suse>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 6t8qmtoxjpp58k7stwhprektb1tkxnh9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78FDD18000D
X-HE-Tag: 1782308486-235645
X-HE-Meta: U2FsdGVkX1/UrkZNFxNgu/9vpW4ph8qIrqVqngFZqD5BfvTDiHEfPdRNtFVJR1Zcl+d16LXnrHr9hc0kEE7/hihzMNi9ap1hF05lt69h0k8us83Thg+XcKxKQPRMHCzvyXBHFX0X3G2l88rwHLcuX923kpMEtkEwTgrrfFeiLJDzvI7r1xvdoX2eKRzA2bCfMFU/VRFLuyCeFk2vUpjVmBcDGXjA7rfZIx1E6KeGZqZMVHROMw2J4VpPJ6B4D49aHjoZ2sHbeYtBWD+LJkY5+ASSIpt3azdNasGYR2zaAegY97F6m0Y/EbVuMHNHd71x2gwX0nLVvNIXrSQmDQnT+3p3okP6zDNGhKH3WaFhktuKyUwl510LZndndDdXNJ6MoEVFNBCzAry066fIWG09RUdPmw6j1mC+Lou1Q34DVhP1gndxSg9mUDi5wT/t0y4+LfIo4p2jpFE90enf2h35mXCsm2EEJY5pFl9J23+ROUMIjWH0w5XkeEOSzKS3OJxKndlLNVKBqr86D/XV7xxbWA1jMAnFaeT/dPldOyN4B6SwmODxxxdjfQ5d5kk7acwUVOD5m2SqBPiHnXmD99z7In2QAxcA7tjwmkLL/u7Qp1kcg1PVGMhupBmbKwl/l/iY5B6qzBn7/pcAeJxI53tTdRO76d8ubREEPChier8r6ns3WOiD6xWYCAXqLsXQSkK/NH8AoznriJuBEolzNwrsabGFuLe9bb2YJN4aq7ueCjGm3g65nW3TsQ40Zz+vfHamudD46SChcnfpbM9gw6WX/lQwyxYJPJQB4gm9J7d2mxFuYuKU3XFQJl+3QubZbiHxFfwLYGjhbfrQRC5lAL11BU8S+juDI57+Eljy+oiLewHZbCiooHu1WzD8j3tKrCos9o2hlm7/nAbvyhWiBE6np+zkh8s0085Gnu0gyESpI4cBntVYPERQuZK9JIY1cu4LU1haSSGAOrChPk4fOiz
 7qwr6ve2
 YxB2BHbWyvZx++Jhvedi8P1acHWwXz7QBtu2bgtj23IhIiKe04M8onqi0AXGVuJjXxVeyjRKSd+k4IhgVdF7AZTOP1SFaP5lIjsx6dEL3wNBFRUUKKjgSyI7AzMU0lmZ6NP3IJPvexn8KZKnvGCFQh+6p4+HHgtY7p8f9X2lXr4FE33j761rx0Z8jZTuB4HqN7LWJYFTxdaC9TVWOxloei9NETQJrGJhPtPyYp/wnFWrzc0thGKZ5RDkrYPHe8Na4d0/YfeBIEL1qvalqgmaVPiB/6g7kxR8a245bwttV0HY4GhxckRITG4MV1pBya0naJvW3D3THCPBCDtGWfPo3iQzEkIdNtnWWWmou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 08:05:56PM +0900, Harry Yoo (Oracle) wrote:
> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
> 
> Register a kprobe pre-handler to invoke kmalloc_nolock() and
> kfree_nolock() in the middle of the slab allocator. However, do not
> register the handler on UP kernels [1].

Maybe explain in the commit message why that is?
 
> To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
> is held, add a wrapper function for lockdep_assert_held() that calls
> a no-op function slab_attach_kprobe_locked() on debug builds. The

Why lockdep? Wouldn't it make more sense to add these triggers after
locking these locks?

> function is optimized away when neither CONFIG_PROVE_LOCKING nor
> CONFIG_DEBUG_VM is selected and register_kprobe() fails.
> 
> The function calls barrier() to prevent the compiler from optimizing
> away its callsites. Otherwise, the compiler may consider the function
> does not have any side effect and remove callsites.

My wider comment is the following: this looks very useful but perhaps should
be lifted to Kunit itself? There's already function redirection (which could
be used for this as well). I don't know if that suits your purposes?
Choosing to say "I want to hook this random function using kprobe and give
it custom behavior" sounds lovely for all sorts of testing.

-- 
Pedro

