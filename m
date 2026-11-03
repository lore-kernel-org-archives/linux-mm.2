Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA60A606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FM26aawt
Received: by kanga.kvack.org (Postfix)
	id E2CCE6B05B2; Tue,  3 Nov 2026 16:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05296B05B3; Tue,  3 Nov 2026 16:11:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CB16B05B5; Tue,  3 Nov 2026 16:11:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B64D46B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:11:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 198C91C3DA9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:11:08 +0000 (UTC)
X-FDA: 85395053016.25.C11D453
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4771420002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:11:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FM26aawt;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740266;
	b=ybkPxRVBDd6wRUoh+GYTpaepEXkUQBRkZbkmstqeiybtkwhr8utOOWkYwUPYZ6XqBz2QMa
	aNEnLLI+nOAYhhkI5ttBlN7YeQwwZ/dJ7vi9Bo5o+Uit8FQ3nH3K6o0sPU62QvazHBosUw
	ubmX3a4jM5ax+V0RMHdwf8dkPmSyWG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FM26aawt;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
	b=1TwFm98EOie6H3EtReXogkoK3W7IvAO/srEeEjGD5eWlT0Ki88DKe2f747emKWFzy7v6WK
	GwVpCC4oabRpubcEbvEdexHbESXZDXTXzpXNXX9oagFGFgInEQWNWQLr8eVpAhd+FTvu4X
	iiw4JuLJ610uoolXOU04ZQVJYQxPu7E=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so759417a91.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740265; x=1794345065; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
        b=FM26aawt+lvJKN6LLCKqk0nw8eFj2h1t37/90684rJtOQ6NSEktTVU3hecztKqUG2t
         PyuQZTCwox+w9pMbzIhIlujJELb2IyNpUAKdRf5288HfsgRRR5F40famnq+EuTvFlYIm
         t4/Qfg7tGEvNQLViZThsTk6+HxZ6Ylfg/sheUi/h9EXdnTmIi21D1QApij8CkdU0ne0S
         j3aJnyTakxJCFXVuVgBR9dl2QxhzsS4GJ2B6QmcI91BNqcS+p58BHK3mHv9qvBcsjo7a
         Mv+KEGcee7+FLQhVuBs5MTjMIDlO5/WXJPphDZDTjIIC9gNNDUhMbn6pt+JdIj/Xbe72
         m2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740265; x=1794345065;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gwb0yhNA8ovJvghC21bfjrqEFSJ/3LvirO9QqnwCwDw=;
        b=jyPR69vl7jKEaOCzGD/xm4pMDx0GqFmt1LH50qD64cWrnkpxAN0OH+UVn0XLPjfYJ8
         5Xi0VF6jFPfabAY5dg2obsQUwP1h5rkHF7Q5K1gBQ51qJNnzzO01bwd41BWNjBIFwSCG
         4ybHymeTd0sNDzIacz7AtmJESgiuF1FUVWgZ4GXVJy8tTWMLpl/j2zxcQ1ijjVZzNeMQ
         Wu4Eh3fUNmOyUlRh6PKn1Si+5jrwA2VufkL5a+jLQ6hXm1b8QgkA8AwF2Oj4MFDsKCN3
         NlU54Y06a6ZmYNKDDHie5m0QmrPgsTpitt9SGbtiClUIIw+Cog2nOpEDvj1imHCWBlWH
         PbuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxejGYKfvWf5vsgTfYUUCElJGrzJngalY69Q9MvZGhxdkk4ZvVaPAtFvH06rFD7Veo84pTgf6dkuQ==@kvack.org
X-Gm-Message-State: APuU4Z+IXEbx+ArTxQLouBaN2YhYZAktOlwip//7spd7n3ZIfHAtXb1q
	q0ldnkJMguqfQxXdI2DytnI0LIgTKJoH3WnxZWDhgDQNMhQNkDYE/MzZ
X-Gm-Gg: AYBFou3A5b/Wgn2sKQX96vR4P6hxxYvIIYGMpAazcbSEQm4MloY6i8yoBygP8RDmp2G
	bEWZlV/TyKHutgeTcM3Y1S7J9zo5E8CEihCRQoLVJL4GAqD2fPs9az5E81gDJ658ZMOJSQClvU1
	KhOvUqToKxuyLBf/AgiBtpm8IXM7VCYRXMczD2J0njdwECCdYBrWUp724W1HOxCDxp+CzS5Ko5+
	uywLOZ4T/FOZdnay84s0trtUgV7PViMl2LIY/A5YFm2wC6RfnhpCoq3GihyXxmSRODZhBW8Veil
	QL7YI7WnGmATQbddkV8Y/bcaeO2tx4kltcigqLTtg6LP9j/guTMN6D8b3+ciRB3uHBri0uAUyWn
	qBfvBxK+2B5nqE7fYPYT6Z9X4GQtcF9s9Rnj8g/o+tA6uvMRJ2RxsE4jQkrO4g/aoWOoKB8DJ0U
	G8pwUMrIsDUypwS5JFoD7bHA/qyF2fnJ+btq3Q5JNj0buWNuKIh7J1hu9lSqtrcFyiLMaqXidN3
	0KDKdn0cgyYf7MhsJnB1V1Bxr5QNGABkPKHLLZFS6CmyPPIY+ClBA9CcmflH2wy9NY23Olg3vZQ
	GbNgPNGFVzcUWp9R6A7snwA1l9rqvFuTwySc51uJT1kMBlTu12xqRajUwx2YvOrpZF4POxaTEaF
	OYz94K59D/i2UuIsU5tDqD9+cmRSZgP6Utg==
X-Received: by 2002:a17:90b:5624:b0:3ab:d26b:c2df with SMTP id 98e67ed59e1d1-3ae89758b67mr7781961a91.27.1793740264860;
        Tue, 03 Nov 2026 13:11:04 -0800 (PST)
Received: from localhost ([153.61.198.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944ee6easm336849a91.2.2026.11.03.13.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 13:11:04 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 21:11:03 +0000
Message-Id: <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter"
 <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, <kernel-team@meta.com>,
 <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Sashiko"
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo" <harry@kernel.org>
In-Reply-To: <auo5G__ac1qA9JRs@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org> <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com> <auo5G__ac1qA9JRs@thinkstation>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: qjnccfh31eo3hsteq3kmbrr3in7adf3a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4771420002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793740266-799628
X-HE-Meta: U2FsdGVkX18U4uNM/P53PQAcVAi54I2U4RbSzk8OW/8zPwkkbB3jGCf7NAuA1kk9XXwieux8rAE4B1qNSlovkDWrCL38BBdi17XFCvGkZ3z/ZtYAYmkSuhPBYycJDewUqq410w24LbkUqMxjLpB4UqT0w13b26yTZ/x2Y2v+68bICg8sPXrhphSd/abNXsZMmSRRkaSelKM85WJfg1O1ymhC7iugpzL53h6ULpi21CiKl3UAAhFjZvhkh82XckAQiC4kbboEm8jm4+efPDw5BXckodsexVnZYbhSYVFkM82XhpEvnrDrLUwMVImhByWcncrXAPjv+ZoUi4fyaw9g6O97z46T7D30Fby9RcTvOCjhKnHZY4pAMSe9/6cQQhfOqd9Uf5QgATGKXSHu5CIEWGUqCqQwIADRBIaaVRY9r+s2Q3ebYIR11WtHwONZRxpiYV0eEeEacU3ri2EHg8G+rz6sRFOPfmnZq+4eB+uOX5tuHfuPchpgH6ZW/InJs7eA1Hv+BIR6auDJnVcX/oa7ERPv7uRpovEk/m8UD5UQmTt51/PDjRYAWwIg8rR0qkQNF9cfxYU5h+OnbrH/aeVI2b+3E6kLEG0ZNRWTQI0QWDKHdrKtWfiWtdvm29DEgxS58e8IFgumseBbq/NDchpW1fVIkRLSIeRnqH9E6H9dhmZiSRisipOg4iQMNy3FbuBZ6wh/p+rjdlb/Pckp6QysajEZuWSRK6PrbM1VfC2GVvsNsNWtMRWE/93Wrd422LehFPgeOZ0H8vaqXIUSJ8AAsMbYL5EQHdYE0+ddyC6un0LR6PgdPzlPBYfvQn1VifVvVmZbcC/pmI2f/u6rVbeDYXesiRXKi/GhnNPIvPWB/PG7MtztYm4POrTbELU2M9grnZ5gP7Ac0EcFhnebzXgdlGX5ac30W9gF1Olu+TJskPo66v8IykMtKsa7jx4+aVcxj3ZaLKvD+RzS6ydlmBA
 pQKY9x2d
 LESN3bNtl3Pne47fkt7NpFgg6xII89drmcxmhHNGaMyrgGhKXKww27xcIKMM7TUbRZ3wlz8gAJ0t8RXx+N1Wy7IOx1Rti5lHV4uhMBlDGkkiDfkzy1KzufagC5kgFO3YsDNzXhPrzJLiNL+O/08k6v0gftg3cuT3oSltTml8GUvAjQwnp8llvxJJS1Yhg9aX8XXC8ibOsMr1Xby9N+6ltWSiHtnrssEp6i+fdP1Dllc6Fn2LvdAXAUKSX90yvXfH57pGLBGNmkr2/p4+buOtZAnLt3RKr8SdqxGwihYgpY4yMo5cYSou2NylZRjJmfJE8b6gE6wViEO4vFL2d1DXWzd88lEuV5i/uuxALWpnGT8gaB9uyYqplRAuivZs8iPjPD8Viy+A8f2s/sJDTvoNvDavRBJywRtcfFmxVH0mqU3o/xHvSgOLOQQ2YFvEPVpQUp+mjbfiB2WIO5XpeaQfET+TjV9LhxMOBm0Uhaokkvkcbj1LwP8m9LhWCGnqix0OY9hWdR2o0ydtxulVM/rgbJnzvqPA6fNXsCkt4IsstD5osgKxQqBCIQiMwyH1k1tROBnCkdez8LiQIuC0QR6T9h/+OWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:21 PM Harry Yoo <harry@kernel.org> wrote:
> While this is technically true, this relies too much on the current
> implementation details and makes the code hard to follow.

Fair enough. I don't insist.

> Patch 2 is an independent bugfix as-is already. We should really stop
> open-coding slab_free_hook(). That ended up missing init_on_free handing.

Right. No objection to patch 2.
With patches 2 and 3 the !allow_spin side of memcg_alloc_abort_single()
is an open coded kfree_nolock():

  kfree_nolock()                    memcg_alloc_abort_single(!allow_spin)
  --------------------------------  -------------------------------------
  memcg_slab_free_hook()            -
  alloc_tagging_slab_free_hook()    alloc_tagging_slab_free_hook()
  slab_free_hook(!allow_spin)       slab_free_hook(!allow_spin)
  free_to_pcs()                     -
  defer_free()                      defer_free()

I don't insist on kfree_nolock() there,
but can we try free_to_pcs() before defer_free() ?
Like:

	if (likely(allow_spin))
		__slab_free(s, slab, object, object, 1, _RET_IP_);
	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
		defer_free(s, object);

