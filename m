Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA94CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C099D6B0005; Mon,  8 Jun 2026 23:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE18E6B0088; Mon,  8 Jun 2026 23:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7636B008A; Mon,  8 Jun 2026 23:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0E66B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:58:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67895164414
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:58:43 +0000 (UTC)
X-FDA: 84859017726.25.136B935
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61A51A0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:58:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KVlTeVzl;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780977521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDehR9KUPqQoyrvx8dJ31pkODcCvkj2FH2Lxm05cnXs=;
	b=7Xpe5kt2CmanmDaclAahA1QrbaLDgPEn92USyDn5C0bvaw35oD4hJtZ51RKjMilkNvzHGO
	fw7hCMhP8lLT+eHW2Qiryi0hjLWpevijSeoBjuj5ELGacSKqakwDRKbjycvSvfOPwz/B0S
	8TnITBHYo3Pshp6+++Fgf1eQnkipaUw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KVlTeVzl;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780977521;
	b=ZiIuiHpKurViOGl9Dkjcs2Yzp1JWK0CoSde9AYEI8ohfmnRhy47Eu40R1kNkD/CRJZlqLh
	iBtk4NLPiJhdTXkCiiHugkCfM5TOZTmiZhwD69f1jjsBBAfsbweIZmwbsNPTcOogr7mDEE
	qrq76BNAP1kDalhAPcU7Cr4MVpLSBQA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xDehR9KUPqQoyrvx8dJ31pkODcCvkj2FH2Lxm05cnXs=; b=KVlTeVzl9gptlTf4cf7ti0YqgJ
	7kk+WIHxe9bLMr9/Hp/bFKPomJ47VM1tIeLfJ7rJQUI08BwrhmkvK6qFmt6IMUzZYsoYkIxw3B7zi
	JWPXVCZ7AISi190rWHuQ09w56bLkkAbrvCWACJPXO/yATVyEjvqpfYE2Yp0GFLtYEOfte24XHgzJE
	+0tiFEB2S+OtQv+0nDJeD+Qz/XFxNL2jSOmqPh7RGxbo2rHbqO350yEC2x/aITEp3N8tYGySUI4zH
	YH4iSQtf+HUkHagh3FteqaTUXJVBL8b9ARb1RHHDhWxulKlgxlRbKKv8+cPZuIYWZcFexiH9GmPHc
	W8Iz1jWg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWnbS-0000000Ewtw-1GGB;
	Tue, 09 Jun 2026 03:58:14 +0000
Date: Tue, 9 Jun 2026 04:58:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: New design
Message-ID: <aiePVsiV-w-IZ8A4@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 61A51A0005
X-Stat-Signature: 9gmtj74maor56by3edstzpu1a7jfifs6
X-Rspam-User: 
X-HE-Tag: 1780977521-996961
X-HE-Meta: U2FsdGVkX1+RrSXhIH72fZxR+XtB3hyJkqzZznxCuELwGbTpUKBmxj4KWtAnsbQP+B1J+kriMleWyYEZ1U2iZJvqaxzidvnBqBNKYwx9Wepz9VofQ+eLcCPYkLScEHvO7XjZ1QhlcJVn3ASynmNUEbSAR/hkRCmzg7toilLShk4LZVTs2o4GtnSuWq12R+sfkDZAJ9Sp0NS2HHjFxM0YVTPNtwcwgaqL3rvt6PlZ4aVvBUuMApQlkKfKWN1QJewnvW/osc33UEUuUixlRr6XCNxx8+yJf1xq2KYM6MU4poAlTsZumRRShBPdoIRCSKqDb+idhrf3GvliPHoMvl4bzprf02kRFwsw+cji1ndNb4IByqGiA4DKT4oAzmBJOpicFrHRHd7rJQToKiLqAUQVld2lmIZ5St6eWivTd2vgOtkq14MLxJiZHmTQBE0m/nTLhCpuBMAMLTYNg0lMrSd/TfMjPTkCvulGuqa/VkrphiLFUfmEPSJOsIiKmuzD0xjHyKQMAPgmvxllmgfBHJt3Ne1e0kQn8CWUDYku4GI/KP+v9sFe9w2VKzbgKc3zUuGcoQa0lzc76zYbiBpUKkMUWJyWd6cdgVJubZNQ832AzuMLTjK8OYs0PGPGsP0KpWgC6XgPicd3agSEK2hswHjns5FqgMF5D7hXCTeC6hbD38/H/Q6v93Dd7Np9mTg8wXuUJrR7/aXbSNa75d8g3dB7X1hd+5yNsGLbcVC36mqL/4g3GG8lvs8s6AH1mdKON9AScSdFCz5pBskQJGQkCWIpvpzvVK0j2mrsOAUknWDEWl8aSFFjoP083qWmTB+sQmZUVOhEh/uq+4vsbe7Jd1km/4bIJBQufmg4kAJmLwHD0dwDJzXlSM9tyeVGcQj5sblZ38n9AbToAu+mtf3xSSQ5Ml89IxEVzRQts3BmUeUiqz/Ic+8WKLriEvMq7StOdDsYVn5SumwDfZFSWl1RZeS
 89SYags+
 wFgAWPaTuBB1+RedDg8cLb7pCwPTCjk1WvXs9lE4SURcFkpYuBswh0vpdpEF6VSFTTF69vDotYQ/fj5FtI79y/VKmevY0mGaPtF9qLbZZxyV7L9QjVZ346xp6RrK57NdFB8LBkWlvcuMp/9Aqq6e3m7DGAsTsKRmK49SigS3yWTVfG68o7JOkAbrLlpihHUfoRgeHFxJHcJGCJAqImawaEHZ1z4PXTc38gy/AR6qpVx/rhUjwFTlcpX/Y8/3wf/jvCIdQAIBTcezGJJeVeWvPAM1D/JIQvCL+Wmr5jF3N9Blw1rUIihfMbsAq9v6LfXXA7PTpgHJ90pNDRYTtDykycDD/v2mXSJV6IAbbIph0sEOhXPAVo68haD4NtQt1KApk1NOw212cxfZINr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK, here's how I'd structure this:

1. Introduce PG_zeroed for buddy pages
2. Set it if init_on_free is set
3. Set it from balloon driver

https://lore.kernel.org/lkml/c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com/ 

but add FPI_ZEROED instead of an extra bool parameter.

4. Introduce page_is_zeroed like this:

static inline bool page_is_zeroed(const struct page *page)
{
        /*
         * lru.next has bit 2 set if the page is already zeroed.
         * Callers may simply overwrite it once they no longer
	 * need to preserve that information.
         */
        return (unsigned long)page->lru.next & BIT(2);
}

(you'll notice this is similar to page_is_pfmemalloc() but it doesn't
need to be in mm.h)

This step is going to be a bit fiddly.  We weren't expecting to return
multiple flags in page->lru.next, so clear_page_pfmemalloc() just sets
page->lru.next to NULL.  So somewhere we need to make sure that
page->lru.next is definitely NULL, and then allow both the zeroed and
pfmemalloc flags to be set in it.

The important part of this is that it allows the zeroed flag to be
returned from the page allocator without introducing pghint_t like you
did in v2.

5. Now you can start skipping various zeroing steps higher in the call
chain.

I understand David's disgust with vma_alloc_zeroed_movable_folio()
but that is surely a separate cleanup and nothing to do with this
patchset.

