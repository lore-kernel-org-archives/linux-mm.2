Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37AACCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378FC8E000E; Mon, 20 Oct 2025 12:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3292A8E0002; Mon, 20 Oct 2025 12:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218938E000E; Mon, 20 Oct 2025 12:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6488E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:35:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B34251DECDC
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:35:31 +0000 (UTC)
X-FDA: 84019043262.25.6CB5323
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id C4A0D4000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:35:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nor6K7x+;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760978128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6jVHb7ezLC5hsANkudCILXiAJL70RDGwYPCifMHsG4=;
	b=CMccRahYPXxwbbMck4XRUKu0u8zRdum5rw9rwjY2YtZoXIn9WfsoqRfsHN8ZCQCRncfnND
	v53OwPtjGyDRLWZSMqsfkJ+c3ZmyAWC8S0V8tVibLgGV4T3okE5iUnDuIGZbmuDcbOfQ39
	PVnFLoq00Jk+gyA9L9nSdKQvAtVkymA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760978128; a=rsa-sha256;
	cv=none;
	b=KraOxSOqEBUUMojhfLw5H+LyefRpWDt85BKXNiDK0ncy7jrvnuCTcFzel7gu3cnflWsZaX
	Qi1eNgNzSnpOKNMX6xiU2GnyohhcbwqvuFD/gMkz9RZihhIw+RBPdTYVCNXBdmH9lZvivx
	ywiR/Y2LF0qze8s4sgm4yI0pShEJIWI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nor6K7x+;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-87c1ceac7d7so70385256d6.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760978128; x=1761582928; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6jVHb7ezLC5hsANkudCILXiAJL70RDGwYPCifMHsG4=;
        b=Nor6K7x+OhM1bFfpVd3c3lr4vEGQNePN0qs3VTfy67xgh/xoTnsPJhabtfAzY97Ay6
         m5iCJWQ13XN1+RIzaQ7O1u2MLO3Xkk0IrbkOeCBNtXpyWtnguWugumh7Jq/FSYtr9wsb
         eK09UDGIq8YOM1BC28ji33dDb5DKdvyHD+d1jMKYewC8/u8KJPeEm226esEQl77P8GCR
         J7SPj2+VOgvK0KHnfFwjpPz2k5hdY9IQ2fyVE2jTzO+OGApRTjbIgBSE5XuTdW6s+OwY
         lkuKFyVFHn8QfL+o4xlhfU+oCuu12gIfCojwt0vRzYraRb7rOma+r7KcJ1Vaygmte7eA
         x1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978128; x=1761582928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6jVHb7ezLC5hsANkudCILXiAJL70RDGwYPCifMHsG4=;
        b=lxEbwmF7LjQrKhDL9JKyi5uun3ysbitItBwbnYp73dVrdnwKG3iMyGR37qPz5Q8e8w
         8mfnfk7zVyaa3iSYCDphZwchKcap1uJHsSvHYOgMVDU/J7/RwA/diz4Is2XS8XCfSCrY
         4tGqqzcykz7NI1CUXPbEPf5W7+kkwzXO5+knMgYKHGIHnwptWfp5MyEGPWeKxrolUREz
         6FCkjHejd6ay9Zlnizl39IBU9O9A5Lw8gU0oo8KDXhIwKXj1q53u4iU2clOuLu5crTeo
         NTTmjpUM+2o5dK5uot9gsI1Z8FA/eFTF0G/aQleLiBbWXJtVnSpTKY81o9H7O2I0twAm
         YPQQ==
X-Gm-Message-State: AOJu0Yxj45aOd2wAjr63CW40BxCpUheiGd+6wahtY4shdbJPUr5Z8g36
	j399NjRl+dCHIW+g9jhPjS7f3lpKSDRs1Fubh4cC6nOAtfojF5SXwtl4oihG9+1Pvcg=
X-Gm-Gg: ASbGncttiUkF49uK4G/+z1Vv2rR7xvOoDv3kU5ubfs83cnuFU7+yZ7OYu3u6XNpljdg
	I/tSoTC1KmqeZ29MPz16Pl/t1UnQoj+h8svt4QdFbmAcc0SJxRnnanAh30x600jWbeUILd4OhdF
	cSRerpgNjRtLCh2xsB++Wh5K+wjqHPQV1MQ+lLIabbtSWc3Obhax/xoRjwnhal2qDwu8wQRkFY5
	vweJRoGGbiHjV1XTsv7J53c8+xf7pOT/Y3MJT/7KMr73x1TXJrWxWA7v4Vfw6sHAjC3lZavNhW8
	UW2wY4z54SPkqZy9OorlGYLp4vwPCAhBgWB79xublQt3I7MiJHS8xqgXx/jY8Hx7KI1PtOsfCTe
	KKf9qaN1tHOjUThZrxfbs2rC6/Okt89sZPElrslmCqBjD0LL2Ofl/54gc9IV6nLEYTcJUpvAfH4
	YnH9ndDv7bmFMbF97aVhI20089mfxZbUs1Tb5FIGpJ3lREDcoQ5GpCHAyTsus=
X-Google-Smtp-Source: AGHT+IGyom00LhOrlga+gwQAQ7ZtNc5cObbKCtXH8k1bXmEvQN3xISJWYitE42OrQ56dVinEXqIIkA==
X-Received: by 2002:a05:6214:4e83:b0:87c:2213:ee81 with SMTP id 6a1803df08f44-87c2213f473mr139696046d6.33.1760978127833;
        Mon, 20 Oct 2025 09:35:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028b4316sm53736976d6.53.2025.10.20.09.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 09:35:27 -0700 (PDT)
Date: Mon, 20 Oct 2025 12:35:25 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, osalvador@suse.de, corbet@lwn.net,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, mclapinski@google.com,
	joel.granados@kernel.org, jack@suse.cz, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aPZkzY6cGfdKo8K8@gourry-fedora-PF4VCD3F>
References: <20251009161515.422292-1-gourry@gourry.net>
 <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
 <aPZd1dAIzAw7Ii8E@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPZd1dAIzAw7Ii8E@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Stat-Signature: tfke5n1tzwkpskdpc49hw6mczc9a5suz
X-Rspam-User: 
X-Rspamd-Queue-Id: C4A0D4000D
X-HE-Tag: 1760978128-700751
X-HE-Meta: U2FsdGVkX19dhDKZsxhzbzEmNxavrJUgLLWF7n7mtMBy0b+XiH5FQYoKvjrRciQ8PvSKsvITILXi80gQntkeXZsomrNwg4oblgTUQwUGDPAosvulXIISv61lJcbrlRgLgmx+F83Lx0fmFF5F8Z/j1jwuh4HH9OpzF4pL4xtN6IWCu7eQXlxhFE+xQJ79bcMfdOPTVNxiYuYeI32fn/2N70i5egskLfgZqTNFO+W93gsKUET6uxBON5B/P8wTbVdjnqgWOgvK7gqaAEpvrjbclFd6JjU5FneR5XvbGaDuIUaQaMxsuj9ALiVhwtFS8ebjMZhxQ7P/0Q73waEpQiibjUPvAcyHzPiuDiKl6p+mNOHEFQDltg/Ur7mN9RJ1dWtCGFviprgIYNPhfnSbIJgDFBZ+XvppRwNz8jEHPq4gX+IvPPorXSA9ljCFE60CgLyr3B082ZuNksVgx00zd7PdCtBARX5joRI2Rh3vhee9v76ET3ft4EZG+A4WlfZlL3Q4PtZ7D6UFEteG37s9r/32JRPf6UF7wV8O9QXFk9039Jozs1dkhB0Yjf6RyLE+UoPIRWSg+PvUxnQKe+06GmK8nqkDq3P3GIV2Vv4VbRTz3xyQmXsibR+dNAJEBZjESuKLJIoZOJQzBdvY3wA0vhO8Kwg+vJHMJW79IFTXX4cI3hhHyxJrgYk4dZXXdI8DL6dFryRdRfMUZYs65qVE+WBwdDw8n9hFhe908mpwvGn/3MGKKjJCTrDzCOdPYQHdYxmEMdXkozp3s1an3nXrvcRc0qx1UAgQHgpiKgtGhTnDfgqAFs67KbpNITyV4XZFnv135lZP+cZ3TozeNFpL9rDH6yRUVhoYpPp6ecj+YSb/PtosDYfh3MjtZnBbZtpIu8Ak/CazKB7CxcB0HqrOG9vuuTd0JLjqTV9T61mlKf6JLXycp+o980oWox9yHv768XbV3gSeibgPbRltNFjfO/1
 xVsJvP2j
 6ySCKmv/7f/w81vTg6TOe3m8ZytAuM/f0lI9nOvctW6LXM1LRiu4e5Y35FJ4fujMgHjRQOGGy1tHyVCgvOhff0v6AlYmWQQGDvdmG2w8NPBcD1cpqlQrShWg8mdLNKA6BBf/t+QFJ6ryLahi89cR5K9GadMCQ2fXIRvy2aVgIKE+obH+dSMNY6Q629T5wRvo9Bb6nh2fuy3rltd9eriT6ecBMfLB6hFatKNWuwa05pkXQv3msMPCkwvhdBX5iTgnYUf2LlqwBJlFDXvmC0JHrKOdbUqlEyJnq9p2zfSYOPXyt5qTZaEeh3l0NFJIgjafd0dpLUcgtYD070A5fvOjYyAAkC69iovh2gP1TrcnqUaYYWZy54xTa6eWNePaHwy3zcOk2eWkf+m2e3zZe8nuSUEkhjzDrzqNzCHPssJt4CRLm5oqIwRuFfkyXwHaX4/lW6T6S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 12:05:41PM -0400, Gregory Price wrote:
> On Mon, Oct 20, 2025 at 04:17:06PM +0200, David Hildenbrand wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5549b32cdd31..5def2c53092e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6922,8 +6922,12 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>                 if (PageReserved(page))
>                         return false;
> 
> -               if (PageHuge(page))
> -                       return false;
> +               if (PageHuge(page)) {
> +                       /* Don't consider moving same size/larger pages */
> +                       if (!CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION ||
> +                           ((1 << compound_order(page)) >= nr_pages))
> +                               return false;
> +               }
>         }
>         return true;
>  }

Quick spot-check of the compaction code suggests this is handled
essentially the same way - and in fact compaction expects
alloc_contig to be sending compaction requests w/ hugepages.

So I'll go ahead and submit this separately for discussion.

~Gregory

---

->isolate_migratepages_range()
->isolate_migratepages_block()
{
...
	if (PageHuge(page)) {
		const unsigned int order = compound_order(page);
		/*
		 * skip hugetlbfs if we are not compacting for pages
		 * bigger than its order. THPs and other compound pages
		 * are handled below.
		 */
		 ...
		/* for alloc_contig case */
		if (locked) {
			unlock_page_lruvec_irqrestore(locked, flags);
			locked = NULL;
		}

	 }
...
	/*
	 * Regardless of being on LRU, compound pages such as THP
	 * (hugetlbfs is handled above) are not to be compacted unless
	 * we are attempting an allocation larger than the compound
	 * page size. We can potentially save a lot of iterations if we
	 * skip them at once. The check is racy, but we can consider
	 * only valid values and the only danger is skipping too much.
	 */
	if (PageCompound(page) && !cc->alloc_contig) {
		const unsigned int order = compound_order(page);

		/* Skip based on page order and compaction target order. */
		if (skip_isolation_on_order(order, cc->order)) {
			if (order <= MAX_PAGE_ORDER) {
				low_pfn += (1UL << order) - 1;
				nr_scanned += (1UL << order) - 1;
			}
			goto isolate_fail;
		}
	}
}

