Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8F6C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355F26B00A9; Thu, 20 Aug 2026 23:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D826B00AA; Thu, 20 Aug 2026 23:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C996B00AB; Thu, 20 Aug 2026 23:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED0F46B00A9
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:14:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75803160372
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:14:32 +0000 (UTC)
X-FDA: 85123808784.23.D4E6A21
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AF69180005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:14:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lOK/0suT";
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787282070;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nap+rM8Be8DqruXf+C67/tHyR/uuLBbAVCYucfCY/lU=;
	b=fPhQPSkTqzJtWxe2vFTCLjRzvBVWCqCAHCmHe/M3iQPxoElCNtKjwVki9BhmxOGk187UfX
	2a2ehwx7aF579D1Sy2kWFTelOgioNQTF97jP/xJoSNv3Pdobh+G7HFuRAwKMoq4sseD8R1
	bZeYm3Yyguk+XfvPWRmYBkHbYHDLRJw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lOK/0suT";
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787282070;
	b=Zk0k077SsHBSHxGd/ZQ1h1I8ZUK7sXMS0eacR//JMbaxScD5RQpWPLi7dmciuxpgAFBwhV
	n+A5w0czgnGZhtxkdGQBqINRrvhLpljIOJ8d2atDgsPMsxVDSY2QrIN/jf/oydDsPSa6Vc
	05suqkCxfyd1ZM7M/TTBgcHoGhvGHjA=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15f020a223so79352666b.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787282069; x=1787886869; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nap+rM8Be8DqruXf+C67/tHyR/uuLBbAVCYucfCY/lU=;
        b=lOK/0suT8u1plPPfrj+bL6+3bFZxl9r3V0wfuvLMvPl5T/+n0JjRL0v1LXqbN2Krxk
         PopOE2Jr9SLGF5jPooBM+hhPe78M4IZYn3B0wyGCBSVjSaGTvkdrZH9EXj9ZBaJFH7sU
         spc1ekRfou7DXdG5DSV2TgJh29JbpcjTAfooqtcGUtpMMUzAwEv6YLowT6EuUjJSlRJo
         VwJFSex2BB+eWe7MCACs2TrNs9LAj8lo2VUxi3sTMyfU5By69mfYw6sDSqhTf9EUPQc5
         n05nzrd22nspfWgSYb0oSVBvtwolPYLdshHYB0kTDuNu8QY2JLP57WFKWOLMs9AexV5q
         3/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787282069; x=1787886869;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nap+rM8Be8DqruXf+C67/tHyR/uuLBbAVCYucfCY/lU=;
        b=JXERRhJmEsUDsOxGFPtlMS6tlGEEldm/8bMX3P8nIqaDes/rNnuaMDn1LBkJbHOVxk
         hBRTVrSbHQBoQ1NOIs5Iw/nZpOvSrNiCfFBaSbgyW2eO8aTs7M9oUxIocEeM6Ft+rnj+
         XWMifShOUlPgUcqc0ijUWUQhsIZjGGTis/JLP+CCV39zyhiNgKoxOrNqqKrf/WoB3XFr
         wHSNZPKy/erfskF0b2I9biE1E8nVB8G2CUfjZNIfcmWJi0+Hakyg9Ofe4QOaqrals+63
         bL0LuvypF4JBxJnT9edlcU/NUQGZo7FEYxb/oY9tQi6oeac+YN/DJdQvvaZpynRsPn/5
         Y2pA==
X-Forwarded-Encrypted: i=1; AHgh+RqsLe7T7pst+gix4jLa2/EfTCmdyV283gwJ3MLlAveG7+yxHmTiRljeqXs/iVjF1sYp6XXYkoSLvQ==@kvack.org
X-Gm-Message-State: AOJu0YxHXlPO8aCzeQPyolXrjcbWskNk7qjryhIUvW1sfrYn40g5Sc4z
	zpkIJixJYfmXIgDtODeWV4502/UGVUlDNLZyyc1yglHKKbedn1ffLcVS
X-Gm-Gg: AR+sD124xDQhhZjsC9GHa8Kb6f1Dm00i+v5nTZ1/0+70S0rMx8FjyfbIc6B7XguPQfX
	zrQFHx4XvgrVcoCwgqWfo9gtsZXCrDorkm7uGXUoi059ErbgW4MvWDxngexwM+RMVP9mVtZ4UCy
	5rI1J8No9ox7+MSdIjlgaYFuAjgkJaxa0kJ0C33fxiQEt2eRcqrMLDBWzW+Hjdp0gfcFipp1RxE
	mGLBbPGnUySysRMYrQHxvyNxKXCp5uVKyIdEThgqh6nqLBluJxm0ko0hcxd5bgPJ4ogiixCLlE+
	hUMRNOupsVYs6Pch3nBv1c/Ldi/6XI9fk3ngx4tjme/sDXKBeB4BzGhN1rYXjC4S+os2pK3L0/s
	7pckb+QzZNmaNXdMzIfsLmtrHHhZRwANaDe/2gsaqlxHacWQCovCjog/7Rlaj/zqTp86coGicpy
	9Ljn52PWuzbFZnMawpo1fh+5ZwDgXj2iUyRk2FPYGIAFm2Hc91//Hehdkpn6k=
X-Received: by 2002:a17:906:9f8e:b0:c19:5572:d234 with SMTP id a640c23a62f3a-c246a4ac801mr365162866b.1.1787282068936;
        Thu, 20 Aug 2026 20:14:28 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24589e1b0csm241069366b.8.2026.08.20.20.14.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2026 20:14:28 -0700 (PDT)
Date: Fri, 21 Aug 2026 03:14:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more
 robust
Message-ID: <20260821031427.qq6mb3j2zqtzdl3n@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-2-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818085702.3395529-2-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9AF69180005
X-Stat-Signature: qnsgpjytpcx7hqyijdfntnjg14tg95tk
X-Rspam-User: 
X-HE-Tag: 1787282070-564582
X-HE-Meta: U2FsdGVkX1+E/HewQHP3dLRwPyJm/gujDeCevSmNECXaupyVmSP2QdXiuP9qdK61ql3nvYXcHcnCQcam/eIGB0foREhznX4GCmcVW6+cHmO5kadpNXLqAVyFX26GTopgKMM4TP25oas4sDy8xkY+XdWBWx0fAEUBX3oUen6q/U1cBHb0VIO4YlGgv6d4bVGLO2A1blxW0BPWyj4JWYZ+amy597ie/BtRadylxlcjqzYQOXsPxIxk91pYt/sie5ur7NRl9LmW7IRgMX7g8Tqn8F8CaVsp+WYIKQOvx+wpwc52EhIsYzTGc3E3OrYgDLrnBXCsDVTxOttJfRKOmC/0OCwkncfTjM+P/KonyRAtC5SlM2WYdZIoC30IHCWoHt+JPhUfC2GuyGnb8k0skgTy+bKGVSlm/auM+5pADSydsT2rBwpAPNdhi0cYhvlnPHeqE5VVVjvT3CSDXR6L+1lx/AFLBOnXfqzIL9+eJ0mZt7S5Z0Ds7XpoWKddjyxBRBYjQqkkATqu2Z0CYHPByjDvMwWe9DiITyZSl4/p70BlX7LcsoLY4smI7Lo4uNoSBDlsaW6EF5TqrHJ1tI1OcPQpv+2Uux0qEpaCugH7Qsand7NUC++dAJAQX9wDKBh6UXgaLR+4xZfXCcs1mS58upUwgh5bg9yvLKxZfvdIm8sS7VrgsjkNnEhPP6IJVz4CI3Azk/wF++fxaRDmFYAuUG/OVkc+dxtNeyqHavfrH3gCVJJ0eAfFdZi0FHoaKXHIL7vXEYNb8sBgFaYHMQRl1OXAx7zfz6imSn4d+PicuPbm05LDlZ5Twwi0J5kKZSp2KnZ3xwIXBs9nLgpq5vgwfygRclF2FzswEnWItiLwtlz44NKJr21NCG8TstrLBvOKyCO37VKIFhZaLG5IXUrYz3MlBavAF+7IHW/sGZmn1eznwq9XMeMzlPCmjveFy3mR9cIrYJVfOfb0Jlaq62kXdQH
 3+mJAwbT
 5ChRoO31yftVnwOmXbx4C15cJDQNYFL1siDlYm/DvBdqbLOLfHhPrZvLEqEbMHiGOl7wtjr3U6sQOrTtSE3EqPTX1XZvZVnhMQWMpZ0B1l9aItHtRKGLQt//ELr5k/VqCoHv5jbROXQbd3sduVoxNzqICa+ggOs04JdWG2cC1sXWl0ffnTAwAfkrlw4FXCkwqoFJOncdSC81TQxoSiITdjPpsiNnfHwZnfnieHpITJEH5Tewn24iHyQ30v4fh+1hUXlRzD1OFEWsb2ikjC5nZCsskNoLChdrBqusX9lj0hnUB/IN3LwycuozaS3Be8jN/a1KAf3Paz9T0paOJf+oL1DdTCCR/O0SG9lVgaZGR2CcE5mUNSxC4VX+bbKb0C83WywFZyBwEtMHqD0IdUMRolS9avAatX+fT8h6YoyPdUhgvhHf6YFC4x0HaXIOtT4BPnHqYk7sHHeZCHfqBefMr06edqk9YDfQKTNEL7JZnwd/E7gFxh00NVOkdPSKQkeViUKhYes7f08ymai6UApm0sDN6MZyDPI7iU1his8lh0MtftOPEfOesd+qXUewzoMpWEEz8miHCFjGFvs3tFintZ21FEj2qqY+fL8mXLirG2j1DXQeF351nIDILYwk5c0GG2m0md2qddoRw5uH/hnjW0OBdASP3Hs+IkrNv/VaSee8sk2X+ONJ471LqE8zkOCU3TJvrJCT1x64JCrHD4sIfjZR3RQRyunYKAwcEfij/RuT49b05zHityBmjTXfhjybG/uGo5mXqJP+T1PaxsOuAcBZf2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:57:01AM -0400, Yuan Liu wrote:
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>
>Let's make shrink_zone_span() more robust by checking in
>find_smallest_section_pfn() / find_biggest_section_pfn() that the
>start and end PFNs of the subsection are within the zone.
>
>While at it, clean up the function by factoring the core check out
>into subsection_overlaps_zone().
>
>There likely is no need to check the nid first. We require
>SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
>pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
>So let's just drop that for now.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>Tested-by: Yuan Liu <yuan1.liu@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>---
> mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
> 1 file changed, 24 insertions(+), 35 deletions(-)
>
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 7ac19fab2263..cd82e79f0782 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -422,49 +422,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> 	return err;
> }
> 
>-/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>-static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>-				     unsigned long start_pfn,
>-				     unsigned long end_pfn)
>+static bool subsection_overlaps_zone(unsigned long pfn, struct zone *zone)
> {
>-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(start_pfn)))
>-			continue;
>+	const unsigned long start_pfn = ALIGN_DOWN(pfn, PAGES_PER_SUBSECTION);
>+	const unsigned long end_pfn = start_pfn + PAGES_PER_SUBSECTION - 1;
> 
>-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>-			continue;

Would we have a memory layout with node interleave?

-- 
Wei Yang
Help you, Help me

