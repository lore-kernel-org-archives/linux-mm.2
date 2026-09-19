Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003FFC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 16:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63BF6B008C; Sat, 19 Sep 2026 12:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BC86B0092; Sat, 19 Sep 2026 12:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A531D6B0093; Sat, 19 Sep 2026 12:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DAC66B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:08:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CB701402BC
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:08:17 +0000 (UTC)
X-FDA: 85230993834.19.F2BCD42
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2B6CC1C0002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:08:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kpGajnlg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kpGajnlg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789834095;
	b=06m7K8fB3FhWtku3XqpHLMoMciivSaVPLdzwOd7FnAb1vIuQQHsZGSZWXvYD50Z9GENqxc
	6bvmvUfGCRs6djc1ZUcK/GqyV9p2n3Mr2POaiUjDwLFLO26h8lamBNIY3XZDqUlBVRphjK
	PvV8+Hq2HtFYcCflBohukzi1u6m7Fbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789834095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1ENvgPhr2wkBzngQIEflRDSjK2asd8jt545To7DKdg=;
	b=mdyb5DOq28o0oEa9TG/btcjpsb50D9eR6St5B34uh6tffMRrPDCed6eID/PjvjYg63Dx4O
	Q00nA9SU1KQts+35kP8caNlqNNq5C2K7lx8HL0bKlWjo8RDCQOxzHLdYGSZFNmdaYTUk9G
	lDKJIQdMtsehvXONso5njPtT5rAfauY=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910cc46c4so155983785a.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789834094; x=1790438894; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v1ENvgPhr2wkBzngQIEflRDSjK2asd8jt545To7DKdg=;
        b=kpGajnlgCwcHWP0A12ip9zB88++iZyG4BicknWZAq7HT2fa36vsIeSzZtztjskEzgp
         fC17Jnlu6DQudDu6hptcJotscxdHzpziFxxAjc/cc35Jg0YtFb9Wq7Jbw41Usgo1AK5r
         uZIbHW8J6su49U7e9gRQIgXxbAem+S9QiKW43DAEQDV04N8R04Bvd1AZlgEWLIqgRfUz
         tuHnbxqEiG0Sg5qHcFHrlZo+zqihcTEe8mTmKa2bOlhDZhxfgLghuuxdvZEYuWS6DkDj
         iDFDDlTZ6ej5eIdr+4H8cgfn79ks6IVgEkjrgvTAY+Nx7ANwY1I6sJtnhNlvyFk7M9/8
         HBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789834094; x=1790438894;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v1ENvgPhr2wkBzngQIEflRDSjK2asd8jt545To7DKdg=;
        b=pHMYXzX6wA8TICP2Sn1IeZm8PZSBBPm5yoG46uNdbwvo/obngA3n6PzB7o0jzSRfOa
         VSx6I/cFhwUMkxFUFECpxkhfZCLhFzcgsyfJA046oVoeUaGvjHXTYnXxpjgO1xgyrTU2
         lH6rGvPa8jK8PR7W4B9KOciHQX+uLmc6GsaneAt+nRQMRr6KeOYSVmmTqunvOBB0JeN9
         yGq8eV//WtYQVoDT8M7lag4lqrZipiGCZCjyBOI1mRVprrTVOUHbUnob7WIn/trU55EW
         VuKUQqqQ9Zq2b+TKHlUOvwk6lki5EPGoGlwqPgdk8mZNvMKe6cMik/wmMxpWVGaWDWus
         GK6g==
X-Forwarded-Encrypted: i=1; AKwUvByvMtXg6/WPBS6jLgSVdbvtvCK4k8ob0shv6Uvsi9Q4oCP0nJeTurw0pOpSqCDhRiA6o0Oa2D34Mg==@kvack.org
X-Gm-Message-State: AFuF++n2XFvDJ9KBAUP+oRWDOh+7TVP8SrGy76XCzyM6Vs0+BLDbT/I/
	3E2AYthjyyEXnEA/STOL/uzQP4fyWae60BPL4fX8fG2EH4Zvsb4qC7ZZgJZep3NSNw0=
X-Gm-Gg: AYBFou1FqmfpJQZsYyT+KMantMPmmZaB2mHuufOn9CDX2okOCInnztw6F/PIOcNQk90
	QQABEzAY6v8bGuFDa5fx8gLWj3FDad+NUk/RlzIaTEkZkSnwQ97I1YUsAT6wehrzi8oqXKec+kO
	tKy6g3ZmLHkCRNtLaoP2IYOoQcK1qkh80DbBTizv+vUHwV7Tv5X2/KgVqj1Y28UqoyEwAsgQhCa
	b5BVh2U/LmpNcC7f4JXjcR0TL/CsN4Fk7HRF7W6dqMWKUTtZbE1xSgP+zhry5OlNnUCgbkIPhKF
	nhVBQ3xTOkYsEEt0DwMYoEq+BXuwr44iTdaLk1TeEMRYUwbI0tp4djs9+Ab+T5c9EBQDqYNzwwQ
	d/2S/Vb6rRfm6Hpk09niF1Nb4UoUunRGg2scq0eSwt+KmmLVFV8GXXXNgGluCHZzxOSTq/4cg+W
	5VkD6310rjFjubhR9Gfg/zJBBFwiOWg3BB6yWtCWgIvx/kRsAs4fsQfsCnzZAHCHkJ4J/kV1aE6
	XkarvvLT9BBdp09ln9M0Xztm0cvC8OdbhikrVi3gYBa8Wj+7cRBsNQ=
X-Received: by 2002:a05:620a:371e:b0:939:10dd:9c01 with SMTP id af79cd13be357-93bf5731121mr233734485a.38.1789834094077;
        Sat, 19 Sep 2026 09:08:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedb05a2esm213660485a.33.2026.09.19.09.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 09:08:13 -0700 (PDT)
Date: Sat, 19 Sep 2026 12:08:11 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Rik van Riel <riel@surriel.com>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B6CC1C0002
X-Stat-Signature: tmurtd5z673d8sm66zxnagxe7j3qszup
X-Rspamd-Server: rspam01
X-HE-Tag: 1789834095-774939
X-HE-Meta: U2FsdGVkX19K9eUDbitUN7e1oR5ysUxlPN80218io6CvRoXGU550KY7FbjhOr6PAa1YBumyUEtNFnnP570Z23xaQmvlpHhW3rx/zEN7rBoXthtiYcJps0g3kbLfh5yf6zZy9RPJjMLBLaj+QD56L1D0oa3Ug0Um5aJH9ixcsxdlFww5mV5lRrgn6md/zussOFHB1qrQT+xg1636YX/VfyN2R88V7ttImL6Fu+c3XI8BuQbP1DtYdg/fnRRQ44k8Plex6qg9ZSBsc2aqaDXTliVTSoJrns3uokQP8GQDRxuNEpHFQvuApULdBZsqimZjEDFz1NxEKvWP6Kek6eAmEBPKeRXgpKwiyMxJlx8VzPSAX91yEdcKtWOvClswvEZE0iv5eAu34RPLrsQw6B/xwIs6leDbI2zvfIK42tQWkYz1pCpyC4dATJtkzJRihjxVxOB+d8prN/xtfBPSmEM3xxkLGkKhvxH9gqa3/QQO1ga8P82ttRNLEt32LizTmCNNvtQYOCGHsyDEm4BiGHwFx4BiGDobuVQLMehlbGBy4JhoXMeYzcbiMOYausOPtrEJ0HYnv+Dhv4ZC37Mze1fbg6cSo1sVNc9hlgDPFplpFBig581zSJnrxYUF4NfK6Fa71Dso0XVdfDrPeVp/TdyCx93XTSO3f2bc2zdg9GbOcT3w/iA5VXxj9RF6hJAsfve4jt7dpU7rAQbv2b9K3B4y7U9hpsVXU4lwNESQUt0F5CIezb4b0pUzdEJKyqDyJGh39FIEXxkSsTkKjjf9B0Ey7jaRIbcz/5VxRt2YeuVjFaDyFMObzwpXQCWoAdPrWMEZxi2G6PzhY3lAohCH/Mxqp1bUrLocOX1X/d48V0OeZ8ICT4r6CxaCsXKw8EE2UkCZErsvsLdNn6zUETvJkoXE0QX95TQRmvZ4TX9MiRJGkQ7d/JBM0Vsd3OQgZR/wrKcd4Cz+BNO6EChMUtFg1S1e
 I+q7yJho
 NcP9JHnK/A01d0Z1p9K7keSg7gytBoow1tefBoaEyt5l5Abr8FxzSsGJIr1EO/fKdhq2iTkUQIg3FnGM4aLeoeAp1rDksbOjUOpi3nlXOKJyca7iZ7KXLbkVlUqoPwsLf3KRyF48hDqnb4f2KctFCejta8FvuX2UaVN4dZTgHlFINY5JHBXULlBaeC8WSis7cwu0vt9/3c5sz4R0q5B2F7K0aTaDPiuL8T7rCdOJMpDJAVijbqQFVldu0pNSTwkMsbZGIAfCWGPz/KvL9tbMCBfF+QLp9V0VwKz19BYRLu8c3+A3sOZERevd/koqSFuqItGiwC/8BqoHu/dKFu/tKuZYnXYRs2g7aaiVVrcas2HeL6NNzlZL7XavRO5ZEMXRuvLa8+33tmboic79IbKIh1iQukhpDaqjev3ng2CY/tnt4OYJGwM+9OoioPZNZ9GpVGCxV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> 
> I found this new concept of "compression space" very confusing to me.
> Can you explain the swap behavior and problem using only normal memory
> usage reduction and latency without introducing a new term or new
> metrics?
> 
> The normal user doesn't even know what compression space is, let alone
> what makes it transparent.
>

Sure they do - it's the amount of memory consumed by compressed data,
including the metadata associated with it.

converting Johannes statement to diagram:

>> Compression space is not a separate resource. It's page tables,
>> backing pages, and swap descriptors. It's just MEMORY. 

                          Page Data (PD)
  [page tables][                uncompressed page                  ]


                        Compressed Data (CD)
  [      recovered space     ][pte][swap meta data][compressed page]
                              |                                    |
                              |---------compression space----------|


                        Memory Pre-Compression
 |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|


			Memory Post-Compression
 |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
   ^----------------------------^
         Compression Space


It's actually really confusing to represent this space as a traditional
swap device - built on the assumption of a pre-defined size limit - when
that size limit has already been defined (the memory itself).

Baking any kind of pre-defined limit *into the infrastructure* (whether for
an optimization or ease of implementation) is what requires users to know
what compression space is.

Even using memory capacity at boot as a limit is wrong - hotplug exists.

> Why does the user need to care about compression space again?

They shouldn't need to, that's very much the point.

~Gregory

