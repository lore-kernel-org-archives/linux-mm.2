Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC11EFCE2A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7A56B0088; Wed,  4 Mar 2026 12:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA91B6B008C; Wed,  4 Mar 2026 12:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7FA6B0092; Wed,  4 Mar 2026 12:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A82B36B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:50:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 494CBC237F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:50:49 +0000 (UTC)
X-FDA: 84509121018.17.D8880AE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id E630040007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:50:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kcub9+zD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VWTbUvrP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kcub9+zD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VWTbUvrP;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772646647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkR4+3jIaCPY9qwtcDMw9i+8Ps1yeWwl3r5ZwOISZMQ=;
	b=ki3Zh4vPAd8mbwH8i8mGYHwmjuetka7xcyYJTCKa2ddKCm+gj3YUwniv/LFZy0b2Vi3/7t
	Wuz2dcI6CctghNxe8Ogj6oJL2Gz4LVsPg/L+MzCfDgWW6ebqZCniJDkKZGpnTqo7XvaoRS
	bx+u9HmYmyi3kK1x4RCHZka7VscTlMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772646647; a=rsa-sha256;
	cv=none;
	b=BaiHAJ4y3PNcriNE8gKtKE9AGyUPEg7I/tpnt2UDGlkY5RGxohMLa1LpPaY9R6q536Uswo
	dPbQ3A1OSMzyygW1B8Fl9JVjeK1uDMJpQbAEx6MeZ3WAIPxbfdMCEYS6GcpfJPfH90kFoB
	t4Mzv6VBdi4pzR3QUCk6mXszpk4c9ag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kcub9+zD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VWTbUvrP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kcub9+zD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VWTbUvrP;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 055DB5BDF5;
	Wed,  4 Mar 2026 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772646645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkR4+3jIaCPY9qwtcDMw9i+8Ps1yeWwl3r5ZwOISZMQ=;
	b=kcub9+zD1v15HNboklpu31z9XXXgn3Q8+gO+0yuuYJiT/47bH8fbYtFOgoO51qQcMJqwnY
	w7qpkY8Dd5y03GMb1vfvFmWBjhQ8cXIBTTk8t1aOJMq7C9dFKBrU2Vvz6QF8NWlyvemBwp
	7+t/k6BQ9fZJ/5xp8EXFaCl9xal7D3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772646645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkR4+3jIaCPY9qwtcDMw9i+8Ps1yeWwl3r5ZwOISZMQ=;
	b=VWTbUvrPOQwy7WasuotDZnTuXMxSH6uQGcmByvmOknSrl2UgREuHUjneYGRHn2ztxbx3nB
	yba0JmhtbbUXTDAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772646645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkR4+3jIaCPY9qwtcDMw9i+8Ps1yeWwl3r5ZwOISZMQ=;
	b=kcub9+zD1v15HNboklpu31z9XXXgn3Q8+gO+0yuuYJiT/47bH8fbYtFOgoO51qQcMJqwnY
	w7qpkY8Dd5y03GMb1vfvFmWBjhQ8cXIBTTk8t1aOJMq7C9dFKBrU2Vvz6QF8NWlyvemBwp
	7+t/k6BQ9fZJ/5xp8EXFaCl9xal7D3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772646645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkR4+3jIaCPY9qwtcDMw9i+8Ps1yeWwl3r5ZwOISZMQ=;
	b=VWTbUvrPOQwy7WasuotDZnTuXMxSH6uQGcmByvmOknSrl2UgREuHUjneYGRHn2ztxbx3nB
	yba0JmhtbbUXTDAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3A383EA69;
	Wed,  4 Mar 2026 17:50:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n++OH/RwqGk0bAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 04 Mar 2026 17:50:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,  lsf-pc@lists.linux-foundation.org,  Mateusz Guzik
 <mjguzik@gmail.com>,  Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
  Tejun Heo <tj@kernel.org>,  Christoph Lameter <cl@gentwo.org>,  Dennis
 Zhou <dennis@kernel.org>,  Vlastimil Babka <vbabka@suse.cz>,  Hao Li
 <hao.li@linux.dev>,  Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu
 memory allocator
In-Reply-To: <aaE8rkGzxlB6wCTt@hyeyoo> (Harry Yoo's message of "Fri, 27 Feb
	2026 15:41:50 +0900")
Organization: SUSE
References: <aaE8rkGzxlB6wCTt@hyeyoo>
Date: Wed, 04 Mar 2026 12:50:42 -0500
Message-ID: <87ikbb1o25.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E630040007
X-Stat-Signature: 4rry4c4n93ctbmit6rhts43n4ocyrzfk
X-Rspam-User: 
X-HE-Tag: 1772646646-993232
X-HE-Meta: U2FsdGVkX1+50n4uAkl660JaQPPLMgYPBrtMVBF304LSWxhJgi13Xw8HLheRsyEWvIOtZphqlm71oG8IC0vj7dpwdBnvadCeDjyd53qR+IlikpS8xSL904rdiwgmPJRO6LJQvYe5w/9ZuIb9BY6Ei6Pgt/k+KNjci5stdSsTLgX8OQHDLD4VzaWZjtff9wTZ40wZhAJ5m1mzzCbN5+8eJ0O3YBJYGD3XPSPtwawbMUGEwpmd9zVQp+Pe3+O7nf2o0oOne15nsQyJIG7/U+98X5APOzafPirrUwfiYuZuNfGMyQXQD4Fz7pG9OJZrsIfhmffUL+DTBpQGmYQO2kdU3GsZ8hvOBOc/vynzY/2L74aRycKXkXKHfv88K82TFIPm58NVYL+m8lz0SRJHEwZWtsQQWmdX6Ywx8Dyt3iGhSndmga1F6fjIiEad5sVv67bZ7J6QahpVH6P4cj/aVxhtDXHHKE/OHUauyHj3w0BM4o2JPwCjgLEdBWuxunTUX8n8YKj8tEr1MYIl+ZsiDFK18xYGKVEX7bm/TGstDPQuatC/VhTMUCEDkBR33eb7le2qieiH2T8hbJEC6vwJQtY9O8MiGx/bwa0v7/FprFc9cnvMqMtFscr/fk+FU6bmfP/X9A4f/IS0gqczjj5jxN1EFnzZeO4LROThrpB8GxuUMcKazEVi/HuQQ1NsofS6rjQmoc9hcwxASZeLrTk1dw3Dvw5+Y48uf3KEZRtWo4WS/f6xx0USpN/StdHRU9yHrlsp/gTf1axjPKqAva/DRtsKMdSjschWdKOIH+AVFkZXX/mRmnqnIhaZILsdj1eFulZ+EIcJdx8yMAVeQpJmG8PhzJFvJTLfsIfMJ2Hgu1KnLuumMPJWvPt5LeyXPPUnlUpJuXVj7zBjLejMas8GDbkIkc4qcRa0WHM7ZtOqfqUeCsR1u8MJ6RQC9COC6/OeiHHPb3g7HAEjtMIb4tXmOkU
 bBNYiwhc
 vMVYriYj9ljDocwKLhE3/WsGz+JgPT4vCC0VLbIuhNE4FjL7fzF3ZqhMNprXFQ1hO+WL/VSvGHgPTRghWmGuMvUizdYtCCvy+iNd2m6EH3Ga9PbhBPuy03yLX3CXVtWslknbuDa9XOGbFmNKfhR1/GzsQiwhnFztgtd4APY2A1/JeLNKBer1RiE/dt4uVB67YUtu/XXSTpgOJh7HEO5mP28LjeRJJ2C4TrM51AAm8PFlFPv8ehAB/XhNyy58MZ2K9QN4MV/eVEDgbhienrkHf8NSzmoFK6N3ZfKycgeeroLFym+kh/K7ogxtGCo9C170nvcSQA/U5YE1Or5W4XootDIWEiPQqQGxxXaWh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry Yoo <harry.yoo@oracle.com> writes:

> Hi folks, I'd like to discuss ways to mitigate limitations of
> percpu memory allocator.
>
> While the percpu memory allocator has served its role well,
> it has a few problems: 1) its global lock contention, and
> 2) lack of features to avoid high initialization cost of percpu
> memory.

I won't be going to LSF this year.  But Jan was the proponent of my
dual-mode pcpu initialization work and he'll be around. I'm not sure
this requires a full session either, as it might not grasp broader
interest.  Are Mathieu and Mateusz attending?

>
> Global lock contention
> =======================
>
> Percpu allocator has a global lock when allocating or freeing memory.
> Of course, caching percpu memory is not always worth it, because
> it would meaningfully increase memory usage.
>
> However, some users (e.g., fork+exec, tc filter) suffer from
> the lock contention when many CPUs allocate / free percpu memory
> concurrently.
>
> That said, we need a way to cache percpu memory per cpu, in a selective
> way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
> memory in slab objects and letting slab cache them per cpu,
> with slab ctor+dtor pair: allocate percpu memory and
> associate it with slab object in constructor, and free it when
> deallocating slabs (with resurrecting slab destructor feature).
>
> This only works when percpu memory is associated with slab objects.
> I would like to hear if anybody thinks it's still worth redesigning
> percpu memory allocator for better scalability.
>
> Initialization of percpu data has high overhead
> ===============================================
>
> Initializing percpu data has non-negligible overhead on systems with
> many CPUs. There's been a few approaches proposed to mitigate this.
> I'd like to discuss the status of ideas proposed, and potentially
> whether there are other approaches worth exploring.
>
> Slab constructor + destructor Pair
> ----------------------------------
>
> Percpu allocator doesn't distinguish types of objects
> unlike slab and it doesn't support constructors that could avoid
> re-initializing them on every allocation.
> One solution to this is using slab ctor+dtor pair; as long as a certain
> state is preserved on free (e.g. sum of percpu counter is zero),
> initialization needs to be done only once on construction.
>
> Dual-mode percpu counters
> -------------------------
>
> Gabriel Krisman Bertazi proposed [2] introducing dual-mode percpu
> counters; single-threaded tasks use a simple counter, which is cheaper
> to initialize. Later when a new task is spawned, upgrade it to a more
> expensive, full-fledged counter.
>
> On-demand initialization of mm_cid counters
> -------------------------------------------
>
> Mathieu Desnoyers proposed [3] initializing mm_cid counters on-demand
> on clone instead of initializing for all CPUs on every allocation.
>
> [1] https://lore.kernel.org/linux-mm/20250424080755.272925-1-harry.yoo@oracle.com
> [2] https://lore.kernel.org/linux-mm/20251127233635.4170047-1-krisman@suse.de
> [3] https://lore.kernel.org/linux-mm/355143c9-78c7-4da1-9033-5ae6fa50efad@efficios.com  

-- 
Gabriel Krisman Bertazi

