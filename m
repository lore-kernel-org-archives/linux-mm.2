Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F265B606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Pu88DpG8
Received: by kanga.kvack.org (Postfix)
	id 6B45F6B011F; Mon, 19 Oct 2026 22:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6656D6B03E2; Mon, 19 Oct 2026 22:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556FD6B03E3; Mon, 19 Oct 2026 22:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5006B011F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:14:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 912BE1407F6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:14:42 +0000 (UTC)
X-FDA: 85341386004.17.3ECF942
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF7851C0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:14:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pu88DpG8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792462480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
	b=Y9Q0+IvofvpF8qVLo9Ax/Ih/sNerPyI4qwCapU5FTl/tCXdlKLoBcspuXt0V4bxTHzlycY
	SZ3DnGMFseo2b/f0hT3CRNCC7stosITMDw/PS1xrUdZAMXWsazi54lM5m9HE/w+DwiG2/D
	bUlyfQnQWAm9AieVtxwvtbCfShlLb3o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pu88DpG8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792462480;
	b=7yzWRoRZW6z4t1hDyJxrKwW9XfoE7+WyZd0cRSNa/wJRR2wMRgbvv9KI3aW6DNpdG6aCbf
	qz4lR94me3/jR68w7RTUksKdsJPsBshT3lRdfp/RXDxFcwXo4sRXsrYM2Z//ppGpD90cZU
	jUzOui4FSqmQgaISoBJjTI7Xqkx2YyM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso1668622f8f.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792462479; x=1793067279; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
        b=Pu88DpG84/ogA3MtwXPZ+zDcgAvsWU664QIMEq8QcECd7fT/FlT+pbSzoykiA60byS
         2fr1B2D0ghy2jVo22n4FmUmW/7ZZExYv9Dli4ZzRp8EF5upY2bQeEMWU81/AlAaX02v1
         IBjlZZB/Cz8NGhNClle0cvYl0gEeORar+j9X1lAPVgPHhTW4ds65U7NUXqjz2gDWgG1c
         qL8sVZzyjXe7mDVlJOE3dippEqyXKbMwKJsjq64VOnODef80yx1MKVUkDBDwNaqIk0yF
         FyFtiPIJhFh8uCwte5O2Mf45OmkHIcHA5LgsiGdJcVld62/GycSy4134EDENeVXRG16h
         vmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792462479; x=1793067279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Iwx53FddK31aCeF3yTsYcRGG3DAdKI2xVbjXFtQkwA=;
        b=fC1qtDgqC26hERmbztKcd9L+yGP8mwCP34mJ88GG5AkRIRIRmM1XmGQtpB+M48j/8t
         qXq1nTQV/Zz3WsEhWxKCcabvZV0ufl4YBpibirx15b4FU4IApy9NLBpvBF3+Txwfw57I
         DfZ5egH0fFlLAZJT3cvHjxqeO5c0sN0stbbmdlZU774UypigQ8EpWW9oE/7cFF2zu6l8
         frnS+ni9RzCZoPBsUugOskIJlLpyNdVN8HJcPSKVVn5syAvoEeoP1nH/pn7gxnYGpGB9
         CE92uZBMV95UeRi21QtEMqeopCXqcHBhC9+0tGwfPKK+ws+pqABOCaslgnnT2iX+7JOe
         EA6g==
X-Forwarded-Encrypted: i=1; AKwUvBwjD/8BgElIZpRKucCRubCb5GSbkPH6t7Of55JRKY5NPt5Usk0IpfeHk/ApMs7CFYqrEhEnkZ0KIw==@kvack.org
X-Gm-Message-State: AFq9FYI2MM4mjkA1GhU0OK2x/jKX3JT2/tOFyTxOAECD1AGQR2wI1x5x
	E3RZPpOa3fqiOAVMtOeWjf8wamnM/eSnoiAtiiqgRy+43oGZ4JF+oTHB
X-Gm-Gg: AYBFou3WOJIYpZFSISKeZ0UR+cttLlAUGHRY72G38BvBRidRrUkwLRmXX9BwukmRVZ1
	4uZXe32/e9M5lEEFdGxd0Gw0sjqM0Uy3gqWNorEItl950fJOo0UGp6sk08sucyf1aUJyNyfM+hB
	TIiF24s6s4RgJ9ERgGnpwdob9xq7gdLv8vLMvpojqP4RPK2Tqar0FO6Wioq/ud80Yp/70lSqqTr
	TFqQwqVEwUhvew6e/FNrhRiL39PuzNBJHDYAa1mITPWZUk2zZcGQ3gycfpYp437udqy11x13Zpe
	mG/CvLGjbR7kfsw2dUfuJRyKvOTNHyg/mQoJDDuHUsfBVxzAJjntuLuEz4eNKs99Ay02u1lwnjt
	VwCSsvuem55YHvUem59nnDH5byH/t1se33JDbvcPvEMlR4AO8GsJCb6gibl+lVmHdLr+6UQpOd4
	NMVWn7w3R6r4PWQaEJL8m1wpykdWccs3lc5/qLJes+mSrKDVLeISRc3aux+/DUVxC2/nRTh4Ngs
	3JuMqiBbFIwXFECbafYuJ9jBRcTzkEOoHkE33e645qOgZfTTMFGTSQ7aMEAjo6qHaFgc7BxqRMf
	4G+gtmy4xE8/+xgCTRq3RZ+sxL+awzhe5de+OnpPK/cMeVei5h0lvIoGs14tQXOGglqyUrfGR6v
	soiFHV87cgA==
X-Received: by 2002:a05:6000:491d:b0:488:5852:6ee3 with SMTP id ffacd0b85a97d-48e07bc2f43mr19882172f8f.34.1792462478968;
        Mon, 19 Oct 2026 19:14:38 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-9c92-6501-cda9-90cd-4e49-75d9.310.pool.telefonica.de. [2a02:3100:9c92:6501:cda9:90cd:4e49:75d9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d8208b1sm2879816f8f.33.2026.10.19.19.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:14:38 -0700 (PDT)
Date: Tue, 20 Oct 2026 04:14:36 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Stevens <stevensd@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <atbOS2rs94fB2red@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
 <asZ8jmWNoGk5tYce@thinkpad>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asZ8jmWNoGk5tYce@thinkpad>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF7851C0005
X-Stat-Signature: s3x971s9amwn5hzeshcudubt7c3eak1i
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792462480-682420
X-HE-Meta: U2FsdGVkX19OYmaPXlqyZ8RBzqa8dT50f2iZhEuj2szFwadhvT8N6Wh3FWwZlhwdoFE7VhCUYkfVYkKTCNPJgFCqzACjRJhCrUd2K+YyMCEqMqygVKY5mNwENsy9tZJVvTjvvo5YaRwJns1fJ+ZF6MhZTKcZqGoF19yprgE7+bLK3eJS4YVBxQx/a1DqPk5Ei97gDmSu4uOXQXaQBga5Y90SuHnHjXFjbVErNOQvFx9urZdNanvHGbNvSjRuMy2tfnH66PeEdNcM/VCf7p3PcJl6EPDnOeBTMuoUzkwfv1j2/gKC+EZRuGqhzr2dLi5oLuqwwKFaT6TynzJtI8XokCsCwr1FUEP4BVVtZs5S4MIsHhrAREDb9x/nlwR7i4TLODotY6FmFShoWdq837vp3SnmjEpxh38t5c5Fgien44EIkuZ8reuBa1AWZArZ5yQIg072egfjb6PSTD50VO2sQL0lt9jGwmnA7iN06G7iWk/8dGUjx2+jbaaepYbYjEvw0FB/Xv0S1y46okbBFodxuTyBqQ1SpLw642tmK1K78KS+7sc9kyj/pZVVR/UEweYbqrTy0SIFNtrSqfmuIAXeauNo8xhmYjnz1TZrQKNHJY8iSLPrKu5XAzzmb/2NpvAPnY7/gjCv4/dCe+6WL/84o3RB7rCypYzyCrpQFsobI+P0VYikOsYiW4X55lCVQKtElHMurJF2c7C5kAfFseRZ9i2bSP6XKy/rgMRymPP00JYKIz8KT+QiG9d56s7eckL2OQrJ5c1V7ZQ64gTNyEUAHqLN9ltILfAPJPUulrSqSGUGaYYBDkcvbkyrxSOR88Or7VRA693eOdi0NEUIl9h4oa8I5DfSnuDRC3jbad687mOeL+c9+t2bB2R+kdx/GqawCmPxKfO8/cPPjpmET8hnv9RNbyZcNVLw8mmUhq+4BRTPMeFuzazhV8Okp3H+ZEJAVfs2R2SrtqjWDhQ6Tb4
 2p0ByhVG
 5VIAsy+m8MEKLuZZ6DufU+rHMqCCLn2wyk/dDwwlNimE6CWzjmGCf2vL7uCfVUFr5RT/UxuTdYqzPn1gyB5/Wmg6pbFjo8ZawMQ7Yvn/hckC6i06KqFkSVbkQfD+6/2fqDOZPz+B9xRVBuTcuaP30oBY3gmbmOHS01FoXgcmPpml3jq3DCbN8MesBy5Yh8xenxl6D8vjnC93kDSRe6zzR4g2cpDls4/vcIe2zJVG86Xyx9Kc8AIUGiXeD04bUwxkoRN/RuZZgqzmB4bIIUw4sWu9bMhSZYFTQs8uQZ6voH0fdKt+E7p//KXPoI0gsqxpVvOAnltjvcFpZEeDX/JQpDiTcs/9OzUTtlv9CqSeYZJrVO/EHQVTjHwRA++oVkwysOL/LKz81tNFnajSHS57Z5YUp10A1ms/ba4M+wKa4zCiBA7hJ+fBREezyt9/4dcDoEOplib3YVZOAFkYLxh33mmVDTZGJYlKsmuTk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 07, 2026 at 07:15:29PM +0100, Harry Yoo wrote:
> On Mon, Oct 05, 2026 at 09:06:22AM +0200, Karl Mehltretter wrote:
> > On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> > can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> > spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> > lock can enter priority-inheritance or wakeup code and re-enter scheduler
> > locking.
> > 
> > The first RFC [1] rejected every non-preemptible caller. That prevents the
> > deadlock, but it also rejects BPF arena allocation and faults under the
> > arena's ordinary raw lock.
> > 
> > This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> > trylocks. Atomic acquisition succeeds only from the completely free state.
> 
> Please don't skip discussion stage and jump into submitting a very
> intrusive change across locking and mm, assisted by LLM? :/
> 
> I don't think attempts to tackle this problem will make progress without
> discussing and getting buy-in from (PREEMPT_RT) locking folks.
> 

Sebastian, Peter, Thomas, did you have a chance to look at the locking
direction here?

Thanks,
Karl

