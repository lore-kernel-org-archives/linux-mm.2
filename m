Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89EE9D70DF2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B2F6B0088; Thu, 18 Dec 2025 15:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F1B6B0089; Thu, 18 Dec 2025 15:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827E46B008A; Thu, 18 Dec 2025 15:43:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7128F6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:43:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E225140300
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:43:03 +0000 (UTC)
X-FDA: 84233766246.24.51705F6
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 34400100003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:43:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VXtfdIrw;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766090581; a=rsa-sha256;
	cv=none;
	b=VKgsjeb8syofK8/ULyR4toQCQYNdk2YIUfHK5sKFU60vzC/QTWXktXRkoQu++DD3W49Q7w
	viuV/eesLZOc5xxAAHKrLmncvJQkBmwoOY2KKK2pSTI8G3klqE1OFMd4WoVYgOaofzUMgE
	12ZzmuEeT5PI2BMrbdcY+TpoRclZYZ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VXtfdIrw;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766090581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJtWtYdyXJo9JjOuJovQNKlx0p9HWjikwGNiH4lGFaI=;
	b=3n27X/NiCYrkIzT0FXoIZbNr8QJO4SarcC1lzexIcQs7DuR9qozZ5Lvu55nSmGoqLDOkxO
	IrPNdBZHNX+5++Qwd+Se0OYnIS2MYlGTmW77gKDrLMPM6MgPhX0YCVmgoh0xjyC7UIDSQt
	n/W6o5c1yWRpWIuXzoH/3Hft/CSUEaw=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-88a37cb5afdso25711676d6.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766090580; x=1766695380; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SJtWtYdyXJo9JjOuJovQNKlx0p9HWjikwGNiH4lGFaI=;
        b=VXtfdIrw2prNpOA7eT2rHjnf9V2ECUrOS9PfYK9+FlrkmIpz39259iJcMWs8KSofzg
         3HWlyX3GM2HS3pHdb2HIhOwbTkvrjEASq7zaGhlRVggslC3qrl8BC7Yet7hhZdx7imwZ
         P7VOIJgU78qkhXjRbqHx1S407tOEPw8wG+EraUf2qO68n//SXIJWsvTzWjm4u1Mm46FG
         dLJTNjvuERVZxYxmYuW6mxwh7+ILyH9RJe4sWV5zN3VQrBeISoYBamazVI9GMmlGsaI0
         yMYGohKcIVsbgsXCbb+TKfTHWv7TWlatpJV3Q6hfTBI6SqrheOJ7irAGFRS+u6ws+ARK
         SNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766090580; x=1766695380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJtWtYdyXJo9JjOuJovQNKlx0p9HWjikwGNiH4lGFaI=;
        b=bTu+6Pa9hlIdKnolQyh9p7ju+Jky8+1MMlJGoJ/0rdb3qSeYecMV1wxvCSZFuX/eAR
         7Sx7luJlU0f3VyJHtXjQqBfmI3+InvIc2AolxQFBlse9nPnogijN+qGA8Yl696J2hi91
         Q6uFJx5enIlO+BcaKUASEhLQEepEOHt0C8wVD6NvQVmW695SwQERBgx8e/89+iA5jKwB
         zQEgXtLeo9SArK8X5WZHQE6Q2PJJ4YhEUguYO/s9Q42nkMjqS4m1u9l6cvY7ke3OmeiZ
         Tj8MmvBDGhf4QJVyyLyh/HoYTYUhc2fSECHlDucC1uN8kQpv/WhTg26ZtIJmHSSgTpfc
         vY0A==
X-Gm-Message-State: AOJu0Yz2HBsxXrySq5otTAiV3Z3a6PLQkTa1IlQxGYwKSP93wh8kQdmd
	TH0ulMZY403IiWaAdTHtMgivWTAkXn8wxoU1/6O8FyVaXC3z5TKDKoD+7TvDnM8NusY=
X-Gm-Gg: AY/fxX7ht/76klAcvNu3RIqi3FBFTmwTG706ZcLFfW4R8FkXPdNXN/MpsTIU5KzEUTq
	Myj8Vd8QL0iZluo2bupMqeH9Xv9j+JxJhD1+Tcd31gn84Umge8FxK3V70oZMh1YrFBE0UELXHrC
	nIP3jGcotcRJOPPR5ke2oekjd1l9oYMka15n8qjPPMb5FPRo90vymNJ8ftbZvSQ5miMpxUN8NWx
	X7Q05EJcAKhVmg8vMfhGz+nsP6G+MymIhzNIdYkd9YMpHQYbyAt4XPO7i0pCcFtC0UFseioZMC4
	HyB9uqmlHPZ3yzqqOat3rFDstjJi1rOp+7RFktOsayEl8Zih97cMSzNwqjfI8bd3clN8Qt8hDVu
	2yT0slhNHPRTBlCvWeQGpwcV/g11BaBsEgoGSLQDpIC3CVwRAo6/kn7bUrt7yI/pudOrYALYu9i
	9u3AO5r7wrX5pBPYmCXdzNXDfc9ZB5AcDOHM60YYpapf84JscZq73EL1rjYoNZe195Mf1P7g==
X-Google-Smtp-Source: AGHT+IHe+/76VfBRWfz9lM8LGjmwX7vteYD1kOK/9DSfcBkIo4Wnhl65RcEQlUT7EV8J2ngMFpIHqA==
X-Received: by 2002:a05:6214:413:b0:88a:31e5:80fa with SMTP id 6a1803df08f44-88c50bdb5d3mr73839626d6.16.1766090580209;
        Thu, 18 Dec 2025 12:43:00 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623fdfdsm3934746d6.5.2025.12.18.12.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 12:42:59 -0800 (PST)
Date: Thu, 18 Dec 2025 15:42:22 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aURnLqMziaOilLCu@gourry-fedora-PF4VCD3F>
References: <20251218190832.1319797-1-gourry@gourry.net>
 <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34400100003
X-Stat-Signature: px8nxjcncu3bzb9dbrif1xdznt55prqc
X-Rspam-User: 
X-HE-Tag: 1766090581-600211
X-HE-Meta: U2FsdGVkX1/6QO4PdKv/YmkK8Gv9mvEdkPRy/WwkpTlSBvfmzDLx7/Q8xwYdxtt1OL7SzpdIYewliaaYMe/NXyLCpVTZUvTHMeDGloJYIiRICUC3XggzQRwWW1mgg8AsvOBAxeV1LRjGQMPQgvJCNuis/kG0YBR15veC/RSxE/WilaoQtTQQbQBxKalsqNGHNZMkETzHBar5ogG/6VnJwvBVjYzvACsmedFMzCf2uOLkU7xp2UC1T/xn/WD6LfFUk/KomoU1diBN348j1H6/CcVXMJIaKBqqcLt56c9Rvy32mY/RZfLLMXKyRqS4BiWRDrUOrgFFK3WK+CgXHRDzYUHzgAAvv2Efu982Fw5tgd3OEp8oH1N1ip89I+onhhHsXJ2z6ZCfZv2VivwesBSLNq8d+H81MUnPEBv2EgG0dIti6YQKrCQB2LPL3W2th4xueIQQWCu67Ctz8kWL8gUHcwtAGdMPOKb220EqLWW5IXrmM14UGtS63JCuEL+zcfbsAiwQ4W7kGygS6N7GXX8PY/MfFcjuUXEYOELq9bIqkWsBDMNwcsUFb68sHFU0g/OZYGws8+qI88Jlfuotia0I/qfJmsM9I/ap/JQ/eQ8RavBHu76FZSc9cohME1rX4Ohg3AWeYrY5HUWfRIsd2kgADG+umhzEad4obn4vE6bVDQARBW4DEMrVOz1mGO0xxaTFvX0s0bzce8oHU8nsg9pNLnmOu1LTjW5hxIf2zFfi326G667FcpJKrWZP+s6B/99TtbdUCCzK3k/8adoW/dOztnhFN5slEXERJeGI7iHMW3CYmQNGmREpUPwA7lH3DVQzh95CZ7x4YWc6LumkUn/EAQhJhgDauLqh4wKf0KVF7iVJpb2nWRg+xtKFXqdSgTb+/WBZZ6AXo79jmkd03c0rxEVOi8TVA0ZRGdv9cC9zxPk+L3HjQSPxhoDOBWlRwzd2ARKMjNA1d4ve7fZtqVJ
 nz+PZd2f
 ekcF3olh42BbNo3TodRS/YjzBqp86cTs6GL4sMo3LE4XlYR7vKYmnUgtVyUbLw/m+IxvihjSo+qmK8OwU5PhhhOgOxfqPlwI+nG0rsHetBiKW7iUKa5IlFl+6v1+8xG6uWF77PMjfk9Xlnqy25k0FzWDcMkUwus5W4nv60XztcYN7JJi5RtEKHaJXKjG7JONXG1OlBdyPHzp1BdLza/2fUst7ypY0zFp9Yw2R1V9t0UFxD/+BRJOorAqMXqio82xcl6YBP+dKcC9eC94Mo71BgyzzbZkGnLcTdT1bHQazg/1fudDDXVtg3TuxPyG1dRpCy5YsJqPL7cXo5aNt4sOAeskzRTjhqydNYBXi5KKi2+BmTMVpzRVv5oQz3ksS+p5z5OyPnchMeSBOfUplfjoucyNiTt2BpbpUyX9BIY/mbR3T+kxA8OEMN37bbLJ0s4IIS4Zz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:45:37PM -0500, Zi Yan wrote:
> 
> That can save another scan? And caller can pass hugetlb_search_result if
> they care and check its value if pfn_range_valid_contig() returns false.
> 

Well, first, I've generally seen it discouraged to do output-parameters
like this for such trivial things.  But that aside...

We have to scan again either way if we want to prefer allocating
non-hugetlb regions in different memory blocks first.  This is what Mel
was pointing out (we should touch every OTHER block before we attempt
HugeTLB migrations).

The best optimization you could hope for is something like the following
- but honestly, this is ugly, racy (zone contents may have changed
between scans), and if you're already in the slow reliable path then we
should just be slow and re-scan the non-hugetlb sections as well.

Other than this being ugly, I don't have strong feelings.  If people
would prefer the second pass to ONLY touch hugetlb sections, I'll ship
this.

static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
                                   unsigned long nr_pages, bool search_hugetlb,
                                   bool *hugetlb_found)
{
        bool hugetlb = false;

        for (i = start_pfn; i < end_pfn; i++) {
	...
                if (PageHuge(page)) {
                        if (hugetlb_found)
                                *hugetlb_found = true;

                        if (!search_hugetlb)
                                return false;

			...
                        hugetlb = true;
                }
        }
	/* 
	 * If we're searching for hugetlb regions, only return those
	 * Otherwise only return regions without hugetlb reservations
	 */
        return !search_hugetlb || hugetlb;
}


struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
                                 int nid, nodemask_t *nodemask)
{
        bool search_hugetlb = false;
	bool hugetlb_found = false;

retry:
        zonelist = node_zonelist(nid, gfp_mask);
        for_each_zone_zonelist_nodemask(zone, z, zonelist,
                                        gfp_zone(gfp_mask), nodemask) {
                spin_lock_irqsave(&zone->lock, flags);

                pfn = ALIGN(zone->zone_start_pfn, nr_pages);
                while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
                        if (pfn_range_valid_contig(zone, pfn, nr_pages,
                                                   search_hugetlb,
                                                   &hugetlb_found)) {
						   ...
                }
        }
        if (IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION) &&
            !search_hugetlb && hugetlb_found) {
                search_hugetlb = true;
                goto retry;
        }
        return NULL;
}

~Gregory

