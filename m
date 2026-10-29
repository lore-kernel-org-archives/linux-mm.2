Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A592606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=LFefzxbL
Received: by kanga.kvack.org (Postfix)
	id 917316B00EF; Wed, 28 Oct 2026 21:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7686B05B1; Wed, 28 Oct 2026 21:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F546B05B2; Wed, 28 Oct 2026 21:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4277D6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:43:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACD7C1201D1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:43:11 +0000 (UTC)
X-FDA: 85373965782.07.C6EEF34
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D04E61C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:43:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LFefzxbL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793238189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnYP2KN7r5kNXfdZbVQA/CFCZuIizGMEZVIhbQvzn8A=;
	b=DzvQM8z3zjbPxPyPiMdgoPgJhpcYOGBSjy50V+fHEoRwEuYV6QvdjpsboPeVT0OFyaoBbk
	MMjf/MGZ0F7M7Ghfix0ZT5N8FE8vPxrwJRQdTWYe+UXVsYPoFooXGic7pVEzcccqpDAD3+
	nYNpxlg2xGs9oVaICOkc4bXyx1+bWoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793238189;
	b=EdLtH4U75urbYX3WXSbzSsaIz2WM8ix3U2w1oCXE3Oo1UR6HzTrtotRHC89vKQaHRvVjNy
	j6e2AzTD77wDJMIJrmiW2wCrcYiC7cAwsdrbDzdxGUznUB/YsxSCWMEVIV8K+5YxlvlMf8
	/nOeiRg9cq1RxLRR8t7TCkINLkK0IMo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LFefzxbL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3535a54bed9so2356606eec.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793238188; x=1793842988; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jnYP2KN7r5kNXfdZbVQA/CFCZuIizGMEZVIhbQvzn8A=;
        b=LFefzxbLXIpBvS95N2skBIMXRDuJwq5sh26mX4q545rrCz2NN0MVaR3N7J90U5l6yf
         x8yskr1SpVnoSGbPcxdV+kSICwoJq/5dWO5nUWNwTg8kbJTZ6Gz3JOajfdeHSxfgcWFv
         BDp6nckpOiQtJM+fGwCaYg84xj9pSlDJdujyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238188; x=1793842988;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jnYP2KN7r5kNXfdZbVQA/CFCZuIizGMEZVIhbQvzn8A=;
        b=gNK0f9+xjk3/x8Yp8P8imOaJ2rIXxUPHJ1UoStOthJK3wdsdXpApPOEvWEF6ID0PP/
         pqOvL1biW6rGrlgTYYRYFw1+uXJYt/KIL7KmQ12CuOPQ/OwZVIsJ2GJzPyLZpOr8JNsD
         BOtZkx3bAGPLOVCpEQsIPgyGMwIGwXfOajG/mDFXQoWqZ2jiHRpzxLqlsjfjtM7858Oj
         3lPyxeyAtoDjFvLLzTaPvyNpfXDhRvOri31wvc/9jRs/b0/u9q2eK8wuSzctrodZ4ZQM
         1K896lk0MYSjrbe7Jq84XQ9KrPvjvlIYjoAHvyrwLpGnJPwsbqgVEm6tvKWGZpkXTTUC
         +yvw==
X-Forwarded-Encrypted: i=1; AKwUvBxoVjdcrCXjrOVL+OrvzyWZ8ZnMcI6a9U7Cz/GQb5VSSW43McFlCXRIa5FkEfFOXZDxQQA4Bv+CMQ==@kvack.org
X-Gm-Message-State: AFq9FYI0fmaQwiYJeGlo9rQpprtxS1i4w5oUL3fIsNhgbR93SsJpqc5q
	ZfccwYaonMHCdVvvFGayahgBVZi5Bjb/WcHIqUTbZKGEuh677RYTjEMIl2cm4x0g9A==
X-Gm-Gg: AYBFou31Yn+TusZEaiBgGn88kGInndb4zpRZh+qHDZc/jHEpxrQYjmJ0Ryo181x2JPY
	9RkujcvcGgHI0Q3WP4lJkFq8rZYVhxppUqYlfwoA2x9LdRUUJj4j+cKogCx7rMJVT4lUcWoISk+
	TEzTaEYTj0U1gNEu0W4QfKlmfydfNonuL4AWFl+FNO3H3hEeD9deoDeVWx0+Mm5qoM32F+tNpdu
	/cq7RtXSkdS+vaNOlfPmQPpIl+W89NaRLxisEgScGF4iwf65lEOcPZSoK3ZP0rk3FoH10BvdYme
	OegGEeiH7IT9MPYrev8toh53ZaQ277JnkcEaxh+vlZX85UgJuDHF7UeqRdUUsj5nmBGXpfXMgVE
	FcpcmKHYZs3M7rERc+Hiy7oubdZbNAJ6PxoZRjj0G2Db2NttwrCFBn0ztQAP+K+yVSMq6ZrUJyL
	pIDGOMYV98m1irnRFEfvKu4KfnoYcy3p5jpPlKEuDQhf582+RmAMKiKLl5UCIydc5On+OWO6j5v
	ZTLRMbb5piz5klYgbDalm7PyKP/PChTQUsrwDIZ6eXR6ByyrqRtyTgNIXYIYovEP114sHgNUET2
	irh26Tsc22yRTK0/goicT/xeFFAJefqtXFwvkaBGNhN8hy+hGj4SonGlpZBwKaWWJmFMIg==
X-Received: by 2002:a05:693c:88d7:10b0:369:f2d6:4108 with SMTP id 5a478bee46e88-36a203945dfmr5136005eec.10.1793238188408;
        Wed, 28 Oct 2026 18:43:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f72e:e03e:c64e:b5b3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239bf999sm11997202eec.28.2026.10.28.18.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:43:07 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:43:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <auKjuiRxQwtsZF_0@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D04E61C0005
X-Stat-Signature: jc7sbn8yhn6dimfxpykk7b6gq53h1wty
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793238189-927496
X-HE-Meta: U2FsdGVkX19P1ViDqTvpmre2ZF1uQy3LDwTsXlUK1uEVzupORimWhiMa7pVF4awK4WBBhidCFuQH1C7jgzyvc2zryneQo4nrZKtnCAkijtNjbHKb2yz98iOj5O+2H0ph43B4rZkPO1Gm9HyE9bVnZgFIY2zUXXg3fhkJVwbNJPJpTjrTbnOtfOVBj58QlZ9OgKEJUX4cibDp26MIIz2iGiHb6HfffvbD5QVxROeH5qXSwuTc0hzzbdISxmO3wvCLpJQ6b1p9w6/HZtynaQj7XRPCspO1O7QLqPZND7fzqt+lKePUBYs4IVFKByxiNExAWCLVZBevGZ44CAOys0EPzuj1gz1bmsfehiPb8fOKAcc9Dd5/37Blq4zMNNpRYs1Qyq3pwGrAY8zrhJFvurRwwberCMqFuUw3pS1r7XHUAkkbsruHZj7r6pjYKMENK729U2/QNEtTGfdq3KJQFhpS9WKKvaK5t6hy6uV2esj5YJjtBd2apoWOHkfTmVPG4ZKb7wjlLU+pwDOEXD7SHsgVwQ8pYZEDYOZqV/H9Kfu+yJKoFW62FAuNk7chpyK8UO4aS1loBO84eVwGghOXHk9hIkEWKpZ1sGjtNV/Ka/5ymM6Gq1raqg0RWMASbtzbten36tmsVMRIz63/i+Yuk9s+42365HQhWm+eBj0zZ+fNwcl0tqMylgW/rHTWcfvL3/TT3kJggUCz7iyxomwcn7JeiRAZR19gzMhG/8Z/9McClJrNQuVNtZInIg14v97q1Gls2zKJEktOdHsk3X4TqTbZkrCIcO7Tvk3Jm66/VgsSOTaIlhjZdmsQCtDsJRdDDbLqXvgJQSkqKxpiPklIKeUdZcXSDL3w8j3UpdvaY8nYFiujoDVvwMYq3TyKTwExzszxRYZVw4HYlZnLjQb/rNUYM7RdbjFVmDyBzVRLqFW4x4w7PhVrSOzgQRYNZDAiSkJ3J9sQMJA5LTEyyk5+mGV
 DxoLdpwB
 dUV9zGsQu3KHJ1aBMVTkO6N2GDMwfe9JaOA8QW+OHtJ2X2bVLHOmcyzp8FRHo1mXPphppqQgNIqugJd9V/vvemEsTmU8QbZVdTYk5g8t7+IacwQUH4VDyo3o7UxjsFEGBVQH7/CrUCkUb5bI+L65MgP9jk5A89X7Ev/lW6jmt7WBoCAhB+O+M2Z8z8cXVqh2zgn0v9PgHligZqe4gsO8X93RtOIK8fdncT2POIhKi3FaqX4bHQwhCESgT9axgvTr+RuIFawG6Su39nORoAOGmY45j+582pb09W/VVYKoIfAuJqlBYcqrFNYMmrj/ef84iIfZCwW4WTu1nkUZdZ1ZaJG3DESaEVxWgvxFyNxIZM5NO+BV+f1C5Dfd9Khex0WDUF80Mo8aTi9Gw6419Y/XHzV+poAecEdZu8SCX4U9Kyb39cWwt1sKr3KWpDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/08/07 09:25), Nhat Pham wrote:
> > On (26/08/07 18:57), Xueyuan Chen wrote:
> > > Hi Sergey,
> > >
> > > Here is some additional data:
> > >
> > > I used the following definitions:
> > >   compactable ratio = freeable_pages / total_pages
> > >   memory reclaimed  = pages_freed * PAGE_SIZE
> > >
> > > freeable_pages is the estimate before compaction, based on the same
> > > calculation as zs_shrinker_count(), while pages_freed is the actual
> > > number of backing pages released.
> > >
> > > There were 264 callbacks in the trace:
> > >   callback elapsed time:
> > >     median:    5.77 ms
> > >     p95:      55.82 ms
> > >     maximum: 271.36 ms
> > >
> > >   compactable ratio before compaction:
> > >     median:   0.32%
> > >     p95:      2.86%
> > >     maximum:  8.33%
> > >
> > >   memory reclaimed per callback:
> > >     median:    3.80 MiB
> > >     p95:      30.45 MiB
> > >     maximum:  92.73 MiB
> > >
> > > The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
> > > and it released 7,650 pages, or about 29.88 MiB.
> > >
> > > There was also a 241.91 ms callback (with 30 schedule-outs) with a
> > > compactable ratio of 0.44%. It released 1,019 pages, or about
> > > 3.98 MiB.
> > >
> > > Based on this data, it seems better to remove the shrinker.
> > >
> > > Would you prefer that I change v2 to remove the zsmalloc shrinker
> > > callbacks directly?
> >
> > Let's bring in heavy artillery to this discussion, in addition to Andrew
> > and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).
> >
> > Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
> > I don't think those buy us much apart from memcpy-s and lock
> > contention.  Systems that want to compact zsmalloc have a sysfs
> > knob (and API) to do so (based on zram mm_stat numbers).
> 
> Hmm we'd need to collect more data in our workloads to determine, but
> if we can compute compactable ratio (freeable_pages / total_pages) on
> a per size class basis, can we just skip the size class whose ratio is
> too bad? Would that at least cut down on the vast majority of
> fruitless memcpys and lock acquisitions etc?
> 
> I'm always a bit hesitant to over-rely on userspace, especially when
> kernel has information to do something smart about it. It might not
> react in time, and many proactive reclaiming schemes back off under
> heavy memory pressure.

Apologies for the delay.

The thing about shrinker compaction is that it's sort of on the
wrong end.  It doesn't trigger compaction when memory is plentiful,
no matter the internal fragmentation rate, and start firing compaction
scans when memory pressure hits.  The problem with this is that, now
compaction moves objects (if can compact zspages) and releases empty
zspages, in parallel with potentially heavy swapping out activities,
which can simply allocate those released pages back.  Which seems like
a useless exercise and needless memcpy-s.  So I was thinking about
either putting it under config or just removing it (this might be a
harder decision).

