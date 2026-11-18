Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A7A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Z6IJn/EZ
Received: by kanga.kvack.org (Postfix)
	id 7600D6B00EF; Tue, 17 Nov 2026 23:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7113F6B05B0; Tue, 17 Nov 2026 23:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600B46B05B1; Tue, 17 Nov 2026 23:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36F476B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:21:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60BC91C3FDE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:40 +0000 (UTC)
X-FDA: 85446941160.01.FD35C77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95FD7C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Z6IJn/EZ";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794975698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDxOq3MFeqPRgslRS9KcBTPZ5rg8SlBfNM7oWoWdBfI=;
	b=PHa65hSWPawv+hEB0cqxKkGwU8JGeYsv8Oa/VcN/y/x6L/omzd/YgwRnLzg7gq9LQdLwyp
	+OmahkblyxqxNRaU8JS+YnMsOQ/iDxEabjqguNGpOp83ie+BU8MiiAtGsMEuPfuguqP8Iq
	daANE6eqpEXV2R922s0CLlj5t6Ay+zQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Z6IJn/EZ";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794975698;
	b=INEih6ypprh9oFIt8z7L7uZsTQ3u0QhuriHUf52ZCuvM6wCGQfbtL4gZ36wC62Yx0OynkF
	N7INrsNwSeIqnU+1WbzZyb/kw2jzJxxtNGhE2F75fBbnGDsmUzE7c/irvV6JWP/tYkcgZV
	R1Kb1TNDJaqlmcLqfp0Vi/o95Z4oyF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 938AE602C4;
	Wed, 18 Nov 2026 04:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F501F000C4;
	Wed, 18 Nov 2026 04:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794975697;
	bh=mDxOq3MFeqPRgslRS9KcBTPZ5rg8SlBfNM7oWoWdBfI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z6IJn/EZLhpVf7Bpg4j6edLYiqsuySU/IeCVjnL+K+BMCndtR8dEQl5AFmlurEHkG
	 Vsi40neJA1iNlrVgmZUO8K2zEcC+8AZAi+a0hQwtt0Qs7/k8nS98+PK3aIHGTC6IDP
	 8HsdqFV95BrDVTK6YzVrb7+e4c0YXGd2qlRDzGM8=
Date: Tue, 17 Nov 2026 20:21:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>, Alexander Potapenko
 <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov
 <dvyukov@google.com>, Chris Down <chris@chrisdown.name>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu
 <baolu.lu@linux.intel.com>, Pranjal Shrivastava <praan@google.com>, Ketan
 <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Message-Id: <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
In-Reply-To: <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
	<20261117120627.50601-3-songmuchun@bytedance.com>
	<sashiko-outbox-219498@kernel.org>
	<20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
	<F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95FD7C0004
X-Stat-Signature: o81bs138zm5gbsdudhtxtaf6rebqupdg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794975698-62166
X-HE-Meta: U2FsdGVkX1/hV8NM+5wDnHg+yhbj8uK5YAFfpSx4sT4G9QMBHbJ0+zFqnPkc6l1J5rYyPKERANAzYx23he2TpGNxwJJfM38cmCO0G7Xe/IVRTOwMJ6gJZMh9EQH/q7rJuh2j07e0LTx5J+AwSgdHLvZ2fQwiA9jD1RWAdPG3Q8ML9ZS/YgAS0cF9mJ1Sek7sS0xT0NE7o6nyjuTMtqBmuXjLnudHhv+k4o1AakJpXPDT6w5NS52wW/lynT/aF6kcfmKF7DMQA4t3KKuEGM+vGY/wpq1bRe/0kCcRn24397clTixE4MZBphI5OcldDiASP3NC2EHwKTpI4vzE7kajsZKjqvmj3elYU0e7MCOjUtc//Do4QTzTeqTzgsT6kDGXq/YhMq9bp963JoOc3ihxd7V15Bpy5yJ0iyYI8L+6rfO2kuJnMSfcNCNLNtZWrJLHUNKtrLJHROe79Ff1GTiXnt8fJU89c3Ji7taCyDesfN3w88vkPPozCR7j47UZs6oT0OjS5+NgGjl3IswWLVZjQyj6LwY36atLyjix1eKTDBgGCyEU0XuMaIp4GiazMmMz353Kk1BikVy0wBcsQUktRi0U9yuzWDPYn6MU261Bv1AzwKx1TZCjlmeJ8PFM4azF1fyF54E9tqtN+Cb0ra8bKMQJ+IXHxNWVkpQrMdUyT50yCpxxUiqmViSZ7ePx8fBPYRSKz5v9jPKViSY0L13nTfO5qsfSvMdQwOxL3akSsnt8aw80Tb704hg0Rg/cZZrFgIcODtk06XICTKgOYNp+AV8Idcer25UyO/l2F9AahFSI5f8pb9YhBHUUlc5tiQ41sXjcXdHkg8yeIAwk9ZiKrhYQijFj1YfyEsK+p7EW6CMusCLbylTTwSTA0VdjinxoNG7gXdG/jwWkn9gk5U04zT6mBe2qPX9xbUsLv9UrjmZ0MdJIIEq7mSoAt2pUQj7Qp3ixE43//Imw95kNxmM
 dkSoq8U/
 Bjls2Nh0LDNcJLLEevdOzCOK51M57KTLXp0kP1cc6LqdckbDK/UrW7dx5AWZqs6ns13cGVPyp81CYXXtcQ3b9wxITmvxVrvc122CVO2RYDxwMa66098oSTo0wRqnBrbXCpU2KlCYa4lboLGO0LL7+9jySQlflCbou/ItvRTfKXV+bFXl0jtHTvYUTyy7dlCU+GDB3K06BYk0mSK1+9IucZ7i8PEzvtll7ebVIx2OIvhXbUls/2EDzQ6dqr+E0YRRFly5BO/TtbxsXpaUhlXPYsQ+oicePkKBh128sMZCIT3JsgFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 11:49:58 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> 
> >>> +}
> >> 
> >> [blah blah]
> >> 
> > 
> > Yeah, but the whole expression is quite reader-hostile, as min/max
> > things often are.
> > 
> > How about doing
> > 
> > 	/* comment */
> > 	if (this1)
> > 		return that1;
> > 	/* comment */
> > 	if (this2)
> > 		return that2;
> > 	/* comment */
> > 	if (this3)
> > 		return that3;
> > 
> > ?
> > 
> > The code generation will probably be just as good and it's __init-time
> > stuff anyway.
> 
> Something like?
> 
> static inline size_t page_ext_data_alignment(size_t size)
> {
>         /* No client data means no alignment requirement. */
>         if (!size)
>                 return 1;
> 
>         /* u64 has the strictest alignment required by page_ext clients. */
>         if (IS_ALIGNED(size, __alignof__(u64)))
>                 return __alignof__(u64);
> 
>         /*
>          * A type's size is a multiple of its natural alignment, so its
>          * lowest set bit is at least that alignment.
>          */
>         return 1UL << __ffs(size);
> }

Well I prefer it!

The final bit-twiddle could be (size & ~size) but I'm not sure that's
any clearer.

We should have a handy helper for this operation but I can't find one. 
max_pow_of_two_factor() is close, but only works on uint.

