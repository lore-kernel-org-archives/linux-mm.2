Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E235960A2609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFIGUSfI
Received: by kanga.kvack.org (Postfix)
	id 0DACA6B05B7; Wed, 18 Nov 2026 08:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2F96B05B8; Wed, 18 Nov 2026 08:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F315F6B05B9; Wed, 18 Nov 2026 08:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46F26B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:41:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75A18A7E69
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:41:01 +0000 (UTC)
X-FDA: 85448350722.12.BD1B07A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D01421C000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:40:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFIGUSfI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009260;
	b=mmak+EUP3BL5XHXc/IYinCKU0EdcF/Tah2crSiBHONjwZ7t/Oa/lDjlhITtSWSz6lgr4qK
	Uq4mCrhhst0vXtWvXuJ3D5gsw8MPCoHNCXlW51Q1yLdWg0bQCCxVeA5BvKD8jl1+IzoL60
	fC6r5iZqvDoNwaGLAT626PKNuOHduJM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFIGUSfI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BALo+4Kg6TAxK4vlJgbnPV/8t94beUsE1Sdo+uMvRH8=;
	b=WXswD6OuwURYqwD9LjHEI4sEdHpmVBl9u8LSiv3Pu2206EbSlqACvnk+EMlhyJrh/iz7f6
	VYQ/QuLlxcj1m59viiG42K+H0/Fgk8g/qQ4wlJDJHuTThSH52BmUkNTKa1K2a3NXbKl3cw
	QHmpUCf/8MUzA4q7TRXx2zg1L9OQLiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF54F40935;
	Wed, 18 Nov 2026 13:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6239F1F000C9;
	Wed, 18 Nov 2026 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009258;
	bh=BALo+4Kg6TAxK4vlJgbnPV/8t94beUsE1Sdo+uMvRH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PFIGUSfI/35m8Ua7f4BVsaqrMghKl4zuRtAbIzKtXIute+iKRBxAzlJUFmC/G7N7S
	 HXewHpvz5HY1unvNcp0UxbMVFK9FfX68Oro4z2qqTOhfVvBQ1F95QfYvQpNaJVAzjm
	 E8QFjkFRhjb+9YIfhSWS6AqlonxffQsQKR9UR7Lca5cLRnXNc+dyr4/b1ceURtj+al
	 yjfU9VA3Ahcopav2U26moJ7zMnEEGvhZe3vUK6jPB49L9gX0QcH6YVgpDHQIjraEls
	 /kX/y4yYnIijIFV8UDhdB9aMcgl3xtem8Q3YV7JuRN4ecYWlbUDFFILz/GiwRTTagC
	 rcxis6dahl09w==
Date: Wed, 18 Nov 2026 15:40:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	sashiko-reviews@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Message-ID: <av2q4RAESvKh0chV@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
 <sashiko-outbox-219498@kernel.org>
 <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
 <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
 <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
 <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D01421C000F
X-Stat-Signature: iznzgqb9y4bj7uii7c8u9e39dbamhm7z
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795009259-669221
X-HE-Meta: U2FsdGVkX1+cveZ9eXwx7/Lmym3kTueG2+heUTCJKx2O+E4ymOHJCqF1Ifh63tmN4wdIZDOHBrWoTDEdwHGNuAV8o8oVimQ08mG5AVsaw2l5Or13sbiUD8edjOzoFseoUl9/Wcg62knSh1U8N63nHUiJl736+ChtvdgMOiOrCaiNWlhZf5xtlr1u93bq7rIGY//wr5Yz38zvAcl1G6laQ+SGJgE4MgSY+ezBxQCxzlkMd9QT1J/gdwCyLH+YUvt3/dcTkvLrXqnubz7zit55DDrMV5fFVniQwNJqbAb6c27OwjxEuI1JMZJC31GZTvR9xKLgj723JjSevbpH0uEl2xyA4lzuXZr0/fnEmA26n+s8IVCcPWpVgWV1kPRqCv147oA7TcgTJDfUczB9s9m+HOjMcTU1kpgguFRakeX5cKs6ZdyOqj56sDcP52rt6PVB+KsVDd11M5GDiQVjIxisUXKWyjTOnHizLnLIGuANJdJhuG2ySzL8srA50kQKE/Y0X6jgpLYmDhbWypLPg1r0tBYm82k21r2KOvf6YrRkmw5trVxoJm8IsZNWjPKptOnF68pio9H0E1MRMnj79cMH4xuFpO5A2j7c6lEcCAob7lU4iJNYRySX/oSKHlh5Qic7pCslJkZlwmuHkPbvtx8W1EJ2Wd5ZoMhlkaUenef4vht1K82GMjtKfhPkz3Y2HIgLaRLi4ShxLDTGrT/wzuOkdT7acyHbGj6hdtiU1vabbzqPzX8syTtAeYfAGN48WzGibrqHB5z32HoORJ34vXqlSh3LZh7z/gGtRhvbBbhIjf69xSvFPSrSRdB+neM0uzJEv7mxlaudTU7z0ThoBlrmoS14AlErvv6rG2VoytyWbvIVEMPMX05ImeZmGFa8SRbS/GDGLXv79g4cOHWbPRPwNTYq04iBAqMS/e3+o90ZhK+QNUXhfEdfnBnvxl6XuCYr5ikAKsDFqxlHBhLqnYQ
 st/lbQ8z
 Q+Vhjuy/I4renWbXG4iAyEWWYncGIo01CKjiCzAkTt7sMPEaOX57w7BqqOmTKbChdOMo9yv0VZBbDkE7tlGkcmcZjp2IW2BFP/Ly3E0FgvR1X0zuPOfJvpEg3zLTf/iAz+f0EFEPIk3trJ2NcTQUP7oZquSyCVi7bswkWSqaNAuhaoh1mv7OPDqll19RRmbiuzEgsYGwShLN55q//Tie0skA71uRhXrF/gRpS7HYoAnmmT0DV+m65uDH3xYTxYHQ5w0FgteLgtGsuqDRN2wRI/xDSLZiP4E/vLlabJOxkTl9OFmT3pOocFPpgbCttC4SHMdIihdABA9aDW+qyFtZeWjG25op/LWGmWC63zMfxw6dTEPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 01:39:04PM +0800, Muchun Song wrote:
> 
> 
> > On Nov 18, 2026, at 12:21, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Wed, 18 Nov 2026 11:49:58 +0800 Muchun Song <muchun.song@linux.dev> wrote:
> > 
> >> 
> >> 
> >>>>> +}
> >>>> 
> >>>> [blah blah]
> >>>> 
> >>> 
> >>> Yeah, but the whole expression is quite reader-hostile, as min/max
> >>> things often are.
> >>> 
> >>> How about doing
> >>> 
> >>> /* comment */
> >>> if (this1)
> >>> return that1;
> >>> /* comment */
> >>> if (this2)
> >>> return that2;
> >>> /* comment */
> >>> if (this3)
> >>> return that3;
> >>> 
> >>> ?
> >>> 
> >>> The code generation will probably be just as good and it's __init-time
> >>> stuff anyway.
> >> 
> >> Something like?
> >> 
> >> static inline size_t page_ext_data_alignment(size_t size)
> >> {
> >>        /* No client data means no alignment requirement. */
> >>        if (!size)
> >>                return 1;
> >> 
> >>        /* u64 has the strictest alignment required by page_ext clients. */
> >>        if (IS_ALIGNED(size, __alignof__(u64)))
> >>                return __alignof__(u64);

Maybe add a const local for __alignof__(u64)? 
No strong feelings about it.

> >> 
> >>        /*
> >>         * A type's size is a multiple of its natural alignment, so its
> >>         * lowest set bit is at least that alignment.
> >>         */
> >>        return 1UL << __ffs(size);
> >> }
> > 
> > Well I prefer it!
> > 
> > The final bit-twiddle could be (size & ~size) but I'm not sure that's
> > any clearer.
> > 
> > We should have a handy helper for this operation but I can't find one. 
> > max_pow_of_two_factor() is close, but only works on uint.
> 
> How about changing the helper to
> 
> #define max_pow_of_two_factor(n) ({					\
> 	typeof(n) __n = (n);						\
> 	static_assert(__same_type(__n, 0U) || __same_type(__n, 0UL));	\
> 	__n & -__n;							\
> })
> 
> ?
> 

-- 
Sincerely yours,
Mike.

