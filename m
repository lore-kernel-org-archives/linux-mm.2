Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13752C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB576B0092; Mon, 31 Aug 2026 05:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1BC6B0095; Mon, 31 Aug 2026 05:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7AB6B0098; Mon, 31 Aug 2026 05:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4CEF6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:20:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86C5F1A03D8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:20:35 +0000 (UTC)
X-FDA: 85161019230.02.F9E510B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82D86C000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:20:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MfmFbxeH;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmZRJNMYJ5AXrDCDZCrGMnxri4tZm1nVUIzEyZPjscg=;
	b=qQXCgDZKdoqBJ+cVGY8ulkQpPWKvHv+zS15+jiJXAj7AgcBUa6faK6TiTkkNuMGMBC4iBO
	E84Cqhhwj5fLQixxCDxcmG2gfbshPd3QG5fWanODE0ZgBN6PL1+Znon9BTPOHGRo9JB0ah
	OlTVtJEv4T/776niB2uBhtunTLHQvFA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MfmFbxeH;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168033;
	b=bOwoBMsF8O3j4kkG3SCpfDEl9Zxu0llNh8czb4pJkvGrshoaULs0M5ipYnaMKvWl7DLph2
	2Ma8pWH8Vpt/2reea/+f/yilDAnNJ0nSJGf7QaBeEV90Faq0AlKDXJzZ0JgI8WSs511710
	XmnPq4/uVefb5fSQ1o1e3qHMjY+BTJU=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48433fad54aso808646f8f.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788168032; x=1788772832; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BmZRJNMYJ5AXrDCDZCrGMnxri4tZm1nVUIzEyZPjscg=;
        b=MfmFbxeHEagDXfgXQuqVVYif2eFNdquc+SyWOR56MDRrjHKT7ngN27NdmWhQ81YFEx
         ufux++fGvk3K9f61BM3T2uCUJTL1nsSOPVAElgim8GfUnFUBUpoXkt/PUFUVBks6aIAI
         V6HQ25od0UTjoRhkYUo3WZzhX+hcA2m+xLxK5dyw5rXScivH0oeFsQucoz7EVTgXeXgx
         5SEOKm/xmyioJYx2nAdKSrh+y1RRDhDm5MB3jDmWRPAuYwlOy+Ez1uackLN4bdMdvI50
         3I3HJmrkRFx8TecKL71X3Hr//P6BNtedpiz1g+leKbtuQLC/6qqOtutDS23rfLJZVQgF
         J0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168032; x=1788772832;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BmZRJNMYJ5AXrDCDZCrGMnxri4tZm1nVUIzEyZPjscg=;
        b=WYC4CvpzDqlF/HLDhaspsJay8w7Bh+ZRZFbTdLY1oLAflLYT/ZyKmaFESYojbN7+1b
         TFICtQn26YSu75azmwSThq+lUpXIh5O4sl4sd7gVv4BdDKulimvoy4sFdS1v/bJAN3D1
         ucViBQBlN4RoNIBMoHEv/ib/g91fFbv9uBMBaH38p+RAZKgZLuuTMrbQ1dh03tuj4oG8
         xK7t5t9lrR+a9CJEp6eTFpmPW0wsOTbKPBWsY8ZJqbhgqRRFy4IJcMddz9lEGdf11GaF
         sQu/+ESatvmFVEYEKnIlFfP6GFpyPOwP/5MVNpPAmrJIo0zNYXqju9BZGfGt95BGiQTU
         wNog==
X-Forwarded-Encrypted: i=1; AKwUvBxwk/N0YmLSWBjSwGVBETYOipJ9NLIKfpybTrdRtX97vFr6uQWALv4y6nR57UPjMEnJYtIkI2ZTsA==@kvack.org
X-Gm-Message-State: AFuF++kaCameXhi1y8LUCtL6u+bZQTyzWOWoAr+j4xbE4qYM1o6IZy8y
	syRqawFmlKX8Fbt8YL5VsIAi/7dFukFyPcCZHPAdHWSizGe8C39K9YWlTkET2PTFb5Q=
X-Gm-Gg: AYBFou3tN4oiwLFKSRk4++1CXm2US0Z8pHld3+Tr+2QDPr6l4Vf7kGky5nUDOAw0KHk
	Hoz2PS0EPdtLYFt6PvZ9a6mj8UwOvzLXlDhJCxASpUampdCKhOfQelNVWjdgXmQco4yzHbBdxjO
	15OZMYCulCeGqGM+yv3WJqI/G9DpvTF4+qhxSgPutRYPcmDIjj8xCvF8JBmry0sGQh0Ll+zn64k
	OpM88/CbSeqlk6k6FAsXYqUDpCoyYvUn2ZSoFNOb9w52BQqxBdMPafyDX5n3DO15O1pqLS9K5JL
	W/SFKjWhKZBc9hjErZbMKgUM0B6CIERghd597sY/rWuwV5ihn9WuOMQ/XNrIOtMXUBIhh23Zv0x
	64aq1nsjOwyvcufSd+5S651gUvshAYPVqRsL3xVs7GuVa1wwVIfWbPKhz6tdTLSrBUk9UnjDSJ6
	Ian38kKkmY1T+yko0Q+isSPHlfeSJ8NWelmxyY5NfP7agsF7ofGPxS20nTcCLyRMJVzRkJSgVTS
	g==
X-Received: by 2002:a05:6000:4012:b0:484:3310:710f with SMTP id ffacd0b85a97d-4843f00bb60mr2562328f8f.27.1788168032065;
        Mon, 31 Aug 2026 02:20:32 -0700 (PDT)
Received: from localhost (109-81-17-247.rct.o2.cz. [109.81.17.247])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48436646548sm10478328f8f.37.2026.08.31.02.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:20:31 -0700 (PDT)
Date: Mon, 31 Aug 2026 11:20:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apVHXmSljK8HrIuA@tiehlicka>
References: <20260831075635.2244437-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831075635.2244437-1-noren@nvidia.com>
X-Stat-Signature: h9hpr3p1ic74cybcx74cdjuxgkn4jsjd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82D86C000A
X-Rspam-User: 
X-HE-Tag: 1788168033-232411
X-HE-Meta: U2FsdGVkX1+5cpFgSFf3Gh2hZpsPCPuic0pkm1QAyWemtK1f9+pQhoDQ/Rzlf9SfHsvzd90DghJNrrTZ4L1tcL3hXNd4hWB29DcO17BdUznf5IfEZN9UUCjJijkffTuvT5WInc6DbSwk5jIp/v96tulfGCdeFNJ9GBZdQW5t7G3piCQ7Uyv86qLLaHdaR+kk6gif7C+iiQ27m8MgxEb9YeFEQYhArQYWk3y/d9ib/XILqzLl0CzGmlVNpaeGNSpRq6wJtbiFs7OsgXZbOy7sHOHH0IcUpP507nu/dxRRCcZMWzL2VMEvnEkGtoSfZvdWGROEXcSCCBvL7jxdd1DtdpUGCjWVuLh6awUm9LDpZHCAARSBW/4oCWO4ustHClSqASWo7W7eJ8UDGA5RrZlqqI6hYFs6vv4bz9p2+vMtyf1pEHrAl5TmcRIKKER28wE4/+KpEemQJLt7RYM0JvWKITn4Jc6sv9FK3eaJUHHaNij3dn+gSRacpF/BRDtnULqnafrw5+LInrl3GwrS5YU4HUZkVm45OdQPs5L3kZQY8iwQe1oPR811Kr9w7K/x4J7EjtBOUJHu4OKXqgu88wknh7yPsTJFgkFo5bi3PCWLKT2wFxSmk+N0veNhWXK6iVobej3hDdOUUUzi463hcGu+j6XBc4X9uGAL3I8H9RWygck8SP/ZA7gOQ99Sd6LhW7LtB+lEXbkNFTsN8v2gEpfNv6fdvwojykr43QiOutuEKNXohxBtxV4cyNuNKFnSQWAwQlFRGUhqqMN6hgVnXCZ6UhEHsyahkIC39eD71UFYIpa6WNEnxuzVq6N9EXB8b7wqVvk83PZhA+Bk2yiPig7IuOiBTT13AQFUVfL6wJb9wlGqZe0hOXQHc7BOrbMs4eBu6e/kfJZbyKwtUGmGqrQQWq/D3ars2tBk7Ovs+izA5cNqNQQOdxzSJngLArqFmQ94vrL7WpCVITV79Nj7oXm
 Wy5W6Pkc
 bycnjzPsIjZVhdoj1ErbIKQtVgy8DfecxpmlrMg2ymQAv6RbVklbi9hTK3NkFmYsSOOzj0RTAObbTh2sR33rucju9rpP6h8YVrqRHA53r5VmkC2jpQUXfm9S2vb1iI6TOJyl37vN55NJmXyJJnHfveojjIhELs2opG6U5mMigM8TUBMwfBO2CHoAqvuXLw9nGRCF/UlnUBXbc2Ipbi4EiBJ+PBrUmGQI1ut6wOuyC08KS8ShmpO3itcagwek5qv/XGJsgJrunsxDhw4RbS+HVqS4jKkwe3+djZ+JVEyV9u1ewv++xBS8xHCrpWo5n+LEO08mhPTIgHWAS82bpelHow+3TlUCYGWAQkjx9ObexpAFRWdWP+t1fEOhOXkCLe3Nmq8oiRNm7qvpFn7hgUGvSyRh6gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 31-08-26 10:56:35, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> pageblocks for every eligible populated zone before capping the result
> at 5% of low memory.
> 
> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Consequently, min_free_kbytes can reach excessive and unwanted levels.
> 
> Add an absolute 1 GiB cap to the recommendation, in addition to the
> existing percentage cap. This bounds the automatic recommendation to a
> sane value on systems with large pageblocks while preserving existing
> behavior for typical systems with 2 MiB pageblocks.

I would argue that the whole model of increasing min_free_kbytes for THP
is wrong. This will trigger memory reclaim sooner and make the THP
availability more likely but this was at times where we didn't have
pro-active compaction and many changes in the compaction. So is this
actually needed in general resp. only large pageblocks systems?

-- 
Michal Hocko
SUSE Labs

