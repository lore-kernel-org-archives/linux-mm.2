Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41B6D711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613CA6B008A; Fri, 19 Dec 2025 00:24:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C12C6B008C; Fri, 19 Dec 2025 00:24:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C43D6B0092; Fri, 19 Dec 2025 00:24:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1716B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:24:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0E2214040E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:24:23 +0000 (UTC)
X-FDA: 84235080006.17.ED44303
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0269820005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:24:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1upw4vF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766121862; a=rsa-sha256;
	cv=none;
	b=2ibgv+6IQilJMEhW03acTmEaoCPrfat8DkMBmX6EsGUXX3roYNx4SBhra79c40yAwvX3Bl
	hGmGkjR3OvGgIeXGHu2AZamfH2z3YGMzXcu0EUlbOX98wkLVDZk3zBydGbjt2N1QMPcZp+
	QIz2CPD2VzqAYpmpNVjNekrfgTnMa0U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1upw4vF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766121862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygwcSlI33CB2fhLfmohyj6FgHYgictohqKO64tjKkgw=;
	b=6T0hSX1MEsFAgyqAokLK0xc5Fe8Iq5dRG2cLAUEt4JradWC/RNcItts9v7yL0Meo8hsDRR
	YF6ucNQhggC1h6RJ8fwmbP3qpV8eG2TkDeQgx/ZDSMGoY9l71jWtJs6OZ6hLQmLyZS8pj4
	BoVlrZw9F21SGIVeL8Au84e2Qi0it3w=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso1640437b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766121861; x=1766726661; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ygwcSlI33CB2fhLfmohyj6FgHYgictohqKO64tjKkgw=;
        b=k1upw4vFB9GzWEtHOdHmAOiapuoWDaUuD7xum0k8GvqyddUhv6zI/WX8A5h+gS5OR5
         hPOvSkcVZIvwyVuhL8nS3gVuNN1XhxyJbWBEd2FaUUB+ybN+6XKs0ccBvNtB5189LQo6
         iRmGrQr5Hex2X5L2xir23mvCJJA9GfPoxdFI95JviwPUQkgwnLMJRMztU7MRxE5AzkFb
         gfHOkfnqq+C0xJ9eKRcgDimFkn9DZctRq/9vx8M8PSfduAxvbzuLkvJIChpDbDC6M9bC
         DTl/yCME4QyjNoNGVbx1y0m5yJCbiaIsnFxQmBtfhH9U6MAnoqMyjGNqQbP/K2NGolUF
         KU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766121861; x=1766726661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ygwcSlI33CB2fhLfmohyj6FgHYgictohqKO64tjKkgw=;
        b=XxOIuNkNQKPRehHb/nASzLFjmLQN999yUeoqA3W25kEDY7wBWex8nPRBX5PMsVXRBU
         E69r0575r/3XYKf28qXtTJvdk/7QeHjjrd0So7CLauw7vqIcOf8/tm936Lw8rG7oJ6h2
         xpUJeoEFAXbY/Ryna6ezby3zeFJgYZXq6Wg5/itMqlJG5dnRxLDEUKBgXsgluoBZ7XUx
         KIExPa2cgNxSvaY3tSulrX7TTpr7trs12DSatdZCTUIkuXrjVTfXpuu7luw4AxAdsX6i
         sdKkjHLXC4LManxegs90sXjoPJCTS8RlFN+AAdR4VnT1ZXf4mRJou0rrnF9r1vcHjvzF
         gYnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgsYsYX8Qi9+txKKMhHhJPwhh0k8Lz55kOVpsdc1yJbcGOVpzOg3ZRnuuFWazgHtmNWEh8OHnJ2A==@kvack.org
X-Gm-Message-State: AOJu0Yz9gh86caheDWrrPcNYClSyskCzCfLE8kY50QJSBikPhxckStMa
	vpNx+7q68FszNU4pT5ih4RwPCnO0sqaukxwoE2C8ddY1NxLtzBPNoWuT
X-Gm-Gg: AY/fxX70iQmyPjYvX7fnQ10zUughUiiTExZeg/poCYwnStB6l1diWwcgG6bkCcZEKOD
	OqOypljc7yDrHmWOoHvydn2adNUPmao01NSZQG+s8DQMT+3Mnygt8/ZCR6tEhZAB8e9nst4o8Nq
	cTXKN/guy7xrLBSRE8uuwGL74hxdh67+6eM7hLOpJ7kHYQfHi4Uv5yBxZ9U9gMw3XDKcGxFdrWl
	MxQs4zLBaUSzKVTPx+//ZHDVv7AfAyBZ3BMK6Gu8j38Ete3n1IUG9N/k0SMsEoF6WTFipPVRZeU
	OK6hvhd2MyDvBdOh4eokjJWxbtXvfjiEqFteOkX0r9Y55dA1cwO1TQGjvjs6ZuukNTmp0ksDTBS
	yyHmY+5tj5fOocWn5ijsD6m3UEhRxXvlShktEIiB1MoTWBkrCiJpoLnEHSy67AK+ZhN5OJdqFEN
	dAEVGV4Cd9n69jXZasWGiodLJg
X-Google-Smtp-Source: AGHT+IE3rMlIsGeQlXr59UP6F8wHJ9EU3MdNmwDW7QNruDNdbRxT+t5KbQdS1v9jHFDovp9eiKQWaA==
X-Received: by 2002:a05:6a00:ac85:b0:7f6:3d1a:7272 with SMTP id d2e1a72fcca58-7ff65c8796bmr1618370b3a.18.1766121860801;
        Thu, 18 Dec 2025 21:24:20 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a939ea2sm1029972b3a.4.2025.12.18.21.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 21:24:19 -0800 (PST)
Date: Fri, 19 Dec 2025 13:24:14 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <qjrahvphdjzbptb4k7lzxbp2encmejvxumuzqiu6au3n3zwr2z@a2gxh37ba3ix>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
X-Rspamd-Queue-Id: 0269820005
X-Stat-Signature: fjz5szufpuqq3xqxqiezz1xkxs5obi3h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766121861-612186
X-HE-Meta: U2FsdGVkX19KgK82rVEVmbf1huJSlOXdXkPTkeR8IbrX9HG66Ry/43bAkMXfZr3KrZIVEFSd9Rlcn5gARebs6ltaoWeVSMZdBl+ivE7G57qevsFo5fpv5S++42VAWXsxRkFbOxKHqcGdBDQljIF+zYgTWG4d7vcDesSsUsXOJW8qeZ3bxzWmOvweFhx0EfzKrZI8BqBFgk8SNqOzoH+SkaPEaVVxpN6NY3VPs0/DA1Mjh/LbvY/Re1HHtCegviLuM9QjvdV7/ToYzD31jpB2Mw9hzy7rgHBC1YTTapFhXLchQVrczgHmXJjHJem95mQOtrbM59eHsypKhIeuVbeE9yau+jqei1RceZAR3mh4Nq6EHZMJ16Rrp2CmOiIQNl0PTBZppDlXwV8s4YEZ+3kxs0Sxl2TsgF4Z6CP1w1oGRwqxAVY4Cx+cxD+hkTJ1RiojNFc0XZOxphn9QXgdEl4vu4BrPK3gpinYfXmBVlxBjdDjwhEZR+i+OD4ajyHerXVij1se9ted2Fuh3JIGHnFxfHzsdXzomdff6Z/hOZI9sZvWcef7M0rhUHsnHQcAcQqXKuwiyTwHyupY82abYmbntx1E1tN19g4oVckILFTvFgulH+X8IA2tgV5Oj+g1Cz+7k0HhSyTseEkh8dL+9wfd7LwpbHvMf+dggpOS/YrJmNRMJs7nDUWgRog/wDRZAM3bOM+/40EKQiU2QjoCSX+HRXCTtVjstd5p0ZKcT3TZNu2u/C2UYEz56ZVmYl3rJaRPrs3mubW9B9CCkB64S8DPKEaiS+a0xEL4n+6FVZHVEDZ2MAinlMrA8q46xJTedpD3fEV4jJ5ztia/Y4pw5UmoMHZfapVKnks7daurDXKk9zSzwZH6CemY6mV2RkwPSTRPDCHRFnZkdIur7Q4vKrz3FyqYyFvV7I9klE86jl22LkitaShbs+IoIVVecDewSv6xWPgx4LiivClHP+HrgQs
 wOnxgRXz
 Z3NAO3/W+Li2okL8rGT2BBjsdxrWcsdYrmfg4AXBTUlib8DJ59Mi1lcldaldZ+BGhmqD9x9nuGkRKmfwxzMQXG/EFhkG95vxN5KjIDYv+s16O/8d/8IQjx6ZqKEd+HDT1PRpJ/jEienSbijjV2t4zjK7aLIFmX/44VoIoCNGUhPFnvpLfBZ53cWgzszWaRnw6PSa+o24M/rgdhX6HstDuFEVjXLZxqF6qE5fVxEFXwdkgKVYbp5vyvZ4zABwLEnDdNSrMbTtG6Xub9VyR5wLSe8yYgTSDFF8FBlGppxOA1J932vgCIVwHxWB6tg2tC5FRTKEOFZN7W486k87IjaE7lGWSKMiAW6I3lDPs23FVSDA+Jhba+ExYTFzhdew3LaUHL0UcGdHu3szkIuyK09c7I8TgT122TJjYEJlYrs7VXhqdZY1phYAs8o2bIIcQ/jvCbLG3wUbeFUIz4j+z9SzHIJlozPOo8LZN28mWlyGg2e9Yfu/U+lmLObUPiQfNLlv12Or3IpEfTwxA4u0rBJg7cfbMDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 10:04, Vernon Yang wrote:
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> > khugepaged.
> >
> > @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> > @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> > @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> > total progress size: 701 MB
> > Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >
> > The khugepaged_scan list save all task that support collapse into hugepage,
> > as long as the take is not destroyed, khugepaged will not remove it from
> > the khugepaged_scan list. This exist a phenomenon where task has already
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> > SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> > list. If the page fault or MADV_HUGEPAGE again, it is added back to
> > khugepaged.
>
> I don't like that, as it assumes that memory within such a process would be
> rather static, which is easily not the case (e.g., allocators just doing
> MADV_DONTNEED to free memory).
>
> If most stuff is collapsed to PMDs already, can't we just skip over these
> regions a bit faster?

/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
static unsigned int khugepaged_pages_to_scan __read_mostly;

The observed phenomenon is that when scanning these regions, the loop is
broken upon reaching the number of khugepaged_pages_to_scan, thereforce
the khugepaged enters 10s sleep. So if we just skip over these regions,
will break the semantics of khugepaged_pages_to_scan.

I also think this approach is great because it is simple sufficiently.
If we can skip over these regions directly, that's excellent.

> --
> Cheers
>
> David

--
Thanks,
Vernon

