Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7C2CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73156B0088; Tue, 23 Jun 2026 09:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD06B008A; Tue, 23 Jun 2026 09:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B016B008C; Tue, 23 Jun 2026 09:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4A996B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:39:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27EC712051A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:39:26 +0000 (UTC)
X-FDA: 84911284332.30.2881B22
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id EBE7216000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:39:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=h1MYyj0j;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782221964;
	b=0NeRlkOGgpn9mpEdMZclR0fOJbWuH2BecjgsAZuiayakp9s4JjVIU3tYEET9ZyKqg1EBeN
	1UBZsDvQXK9wTexeTz2x+6j6Rc+tGWuaQy/wlw268ion1tUi8Q8r6mIGBmBNgarxUzd7AN
	WQ0T/F4h+Q5X5gkcy1qP5N6P+Cwk7vQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782221964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2J98377WQS3y16xqvGNUJknuO+TiKvKHCI0DFFHE/W4=;
	b=bFEYilyhYMgM0n8wHpOj5KdutFfq3p907N++ioGKuN5DvhnUaT28BiT15JVHWAppTaupS6
	X0zN+PLBN611teWXWFMI9qh5eN2ySeIH601KA5KMwhmC9XKxmSQ08Z1S/2dKxnaU2Y3Z91
	PQilIaSN4ZfrGxYr8O+NQsKRbn0JcHI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=h1MYyj0j;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8dd6e530061so84338946d6.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782221963; x=1782826763; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2J98377WQS3y16xqvGNUJknuO+TiKvKHCI0DFFHE/W4=;
        b=h1MYyj0jHZAdaLDKfFMq1NtJJ4UWB+LilYbxb4OHQdmY7eDO+ffqZycW4U6eQJ6YJH
         dAc/njj1Nj85W+Ns6SS6pqcCiOz+ZTbid4u9Ut6MVHaZVM2WVh2772lwtI0hNQElSLUE
         HEawsThcv0xGbNFsXa4xWDEKHCfdmHdx6Cyo0ZZMkeo0H1mUn5ppxm+LmB8LaR4/ukUO
         Q1+YEDYGWcseQAxNsEhkhBh050vobUt5G3Zlegj+et+zFd68tt0zI4GcJ6cij5bZhQKv
         21TDeD4U5dbcG1B85pAes6a5f50EQE4Abcth//LTwODMdapP7s1Owpkjg0DgnYgLRUUD
         ltpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782221963; x=1782826763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2J98377WQS3y16xqvGNUJknuO+TiKvKHCI0DFFHE/W4=;
        b=WzMdHq70TgPfNyGfqgIc/1BPmURhxCmgLSh5oIJv5tPfB+zpkciOu3d7isJbhleZaA
         wnBynFGa2HdNWnwCvtk9KMgAditDf9Sfrv9Ig++LNGnxCGfv2wea4rzTFoWxOrk6do6r
         i4IJY3wzKWuRMlMYYwFkxtgBtoyjDoEhe25ZXV2LN/bNvb/w+3uX3CGD71t8aMVbWLLi
         umg2mEoFGDbcn5eBwU9Y5ZgDVqtK1P/sXu0GCW8pNkFYrupXVfqUnOeec2tHzUPZ04ck
         yGUL5Wxl55Vln+blxRDjct3XNhAzLYDCfSBrDnT9tEBJdHABTNWXBr6vVklMsfEuI38N
         8rkA==
X-Forwarded-Encrypted: i=1; AHgh+RqhRF/ikn8DT55WnRG5aKGgDATwWdy+YOMoSsvZvf/b569S4+ai+p74Gm6uUPOG++rpJKOxVnWvzw==@kvack.org
X-Gm-Message-State: AOJu0YwlbtSM5r+uBVqHe2Mxt4fRLPDrKXeLwHuPmnjO1fPGdCWjr3Ob
	KTXirzPeRydf3EHGX1O6cBui6LwyOgojUSBDSi2skPfbjI5AMfK9mhnbuQAaGdub7+k=
X-Gm-Gg: AfdE7clCiJ8W9OX3OLpb5vn94xEeI67VcKZAsN/3Pd4vBG6vfELOCE0apN0AXsJckQJ
	9H9VbklFJhh76MG2ZV9AVYa2Q8m4GwnH/L/pptq7eu1rq9X6JbfEJhLMEZSyaKy/t/OVO9LzgQx
	lRBFadM/FNTCwF1996wxhAiC0GuKwnnAre1b4UNLFCU0NcLdoJoyr94RmN6xBedVQMhdLywgc3m
	UieaWJulMKXyezEg7SQV4CPmRqHuR1YMkm8XCb8gBNZCaGJevoRFEzj2ftlixPoqhAq17bUZen+
	LoNenQ4V6A/WRa6y8ZYCG4K0MyGFklrh7TeysTNK9TlSb8RRvSSiiZM/fO+b1SV6JQ0UFvpZ9Lj
	YJfaUgFrofMFgQRL4I1FXtJsEQRyJZ7faGNm9oKXITD1GlWhMp+3Z1v+4QHLNB4emFo2OMXyS+y
	LHYQu8qMCG7pg=
X-Received: by 2002:a05:6214:da5:b0:8ce:ba04:7bc2 with SMTP id 6a1803df08f44-8e436bae74cmr38533566d6.38.1782221962860;
        Tue, 23 Jun 2026 06:39:22 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df82b67affsm126378406d6.45.2026.06.23.06.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 06:39:22 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:39:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	ziy@nvidia.com, fvdl@google.com, linux-mm@kvack.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: use existing highatomic reserves on
 the buddy fastpath
Message-ID: <ajqMiVO6J49GsSKh@cmpxchg.org>
References: <20260623004600.113347-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623004600.113347-1-jp.kobryn@linux.dev>
X-Stat-Signature: yask14kzbr8x9de5w984tu8dzy8bon4i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBE7216000C
X-HE-Tag: 1782221963-767892
X-HE-Meta: U2FsdGVkX1+SdPo9O8UNiwtPLY2w8WM1MG0FBBIevRBAsPTX01mzbqxNA6M2C4Eb/sdV1WHwua+EuHBZkbaD9qZMJqv5k2YAUlXG1jQpIxDBzBB2jnJoZqOGCmJlvp9OVKueHpnqg/rm3IZ4wcx37ptUyR/69KLDMmVVaGuo+KeX3MxRKuI2Opa6TZ4ice3iRzCfOadcbF4JOMbF+5A5tYVOKRtHQCAL24C72/8jzcL4APuIDpWTUYWH32EY+yzjc8dy/gOKOaESO1xa8co1UKHwyDqXmeTvd6Qhv00iSQfigMnxAZbxwEiixYncnletAEmfAjTC1ran0ec6JF3aVN4G+S0ekU5uEYk0iW6Kcwj1/z+4VzZ2OaMY54OOREgoxan/WuPD1iFbNLQh4AVFYW3aexPQsLm4GqsuDlBmd1Svggm3euvXYd/+pqMAwVYHZh8oi39kL3psUHVmH0kCxVeK/GUUj8grGqq7f+RDKqfgQxfvYhSJgT9mTQfVEUxPFkRXk5i/KgdOG9JqmrE2mWJZwCQ8pqmPMXPtn2+R1gNmgd7oEM5WoVdaS5+/3p4FzDNDM57+eaVotA3yuJw78zNeTcA8oYqRZIZ/msnEgs/eTdZkKBA5Xty2L8RFZC/ROQlq7wkEVCtKpjGAmBd4K+Clh29lqoKY3xCto+DzLwDJfSXXuyMWSIHXcMOXP3vSd3Rq00sW2tYmM7Kagbqsd33rpUqCQFyP7JVxguqrsNHnNYJ8Bbby5Uu45gZSQv9kMAzGOt6wgErGaSmS8QzTLceYboS5GKfER/yJD0dAyB6HEAvKDRhKGNSfNkWI+xB59NPp8FXxPOpFI+WjBnOLG17jEf0Pbwgk3wZ3/7B4wJmAoxcjUgDXax00qRqV/uYM9Nn/HqfslmjT9hyEM9rZTaRQuLpmQ6l05g3wOkWphDUToVUSJRnD5piaU/HKB2l/HI8gQNTkXTKB6yKzM++
 Xr3ToEFy
 H6+0GgYHMvFuvF9Ffb0U8U4lAoDny8p+/cJx060A+NI14BOCNBsXwOLjTfyUXZSkYzh65/+n8fyLqbZ217qN3iz82lGENhZU54WqDmU6auI/YEVPTALKyn6z/RwWZYCBdSzGNbUHU3JejrlcERgApgFymzTJ6/lq4QIPV8qzSNvdNZVgKXau7G+4Lrr2Iiif4ONOj7kwE59HUFUpRyXAH4SvjjwAPgs1DG1li0emMue88dQqrcEwzIkg+d37VyUBGQvBMdxEAeIdH4pNjuX9Wrw+jywdiHaNAm9TbLIlObAOjlmIBVpClrMqRHpG47wyrJbg82HBctgIj+khDV7g7ZQ0dy3ojrnTaT+79bSlhSMGekVIZ9jr/c/gt3igOkTlSCbSy/HVuxgL6xz//f82VekdkO9KRB+OMEHXbLrm+OBh/LFYMga8CXrtDDeCJtVX38rvMMdjEUCGGJU/m4LSlhQ3NdkBZHZMxe6pX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:46:00PM -0700, JP Kobryn wrote:
> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
> pages and permission to create new highatomic pageblock reserves. This
> makes it unsuitable for the fastpath.
> 
> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
> reserves have free pages available. In this situation, the allocation can
> fall back to other migratetypes without trying those reserves first.
> 
> Allow high-priority non-blocking allocations to use existing
> MIGRATE_HIGHATOMIC reserves on the buddy fastpath without growing them.
> First tighten the criteria for reserving pageblocks so that growth may only
> occur in the slowpath. Then allow fastpath usage by enabling
> ALLOC_HIGHATOMIC when the GFP mask describes a non-blocking high-priority
> allocation. This logic has been factored out from gfp_to_alloc_flags() to a
> new function gfp_to_alloc_flags_nonblocking().
> 
> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
> available in the target zone. Before this patch, the workload did not
> consume these blocks. With this patch, eligible order-1 allocations
> reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
> with no highatomic misses observed. The workload did not grow highatomic
> reserves and NAPI page-frag allocations remained healthy with no failures
> or order-0 fallbacks.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

Awesome.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

