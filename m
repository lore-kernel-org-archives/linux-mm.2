Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FC4CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075B1440154; Fri, 22 Aug 2025 13:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026F28E009D; Fri, 22 Aug 2025 13:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E307C440154; Fri, 22 Aug 2025 13:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE7A98E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:07:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A11211756D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:07:51 +0000 (UTC)
X-FDA: 83805025542.20.B488039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A80740015
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:07:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSplAPAb;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755882470; a=rsa-sha256;
	cv=none;
	b=Hm2JiKZcK+D+zj6rdquBzfaDSLYOmKxYnLFLYa/BHMB5hq7gv8KXSot6gKntrY5eHsZ2Iy
	VxRX0F4sVBEYwFYI8bePOWpepjYSveieCFh6rR7nEz2t/3XZTLPBbXVBDpfsMn4YAhjIRM
	VPHjNNzKjMeCU6bFGhlD2cP79YTaW6U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSplAPAb;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFfb/Sn4tzsBL8+lFf8/4nSkR7hbOY5oXUR5CVb78zM=;
	b=jF3RAO1vc4plFBI3zMRQR/3krwwTRu4l3mC76YiFc7J9F9QOycfact1mnL6JAL0HEptmT0
	cQJCLUrf7k/U/3r/dBxMokLipdA3wAxg4KvAoy1bX5fMBWdELZotKfjPtmrdMGHb82hI44
	Nf3nmfSm3GR083od1PHDpfJlEQ3JFFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DE1360203;
	Fri, 22 Aug 2025 17:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1D1C4CEF4;
	Fri, 22 Aug 2025 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882468;
	bh=vZLAjgh0rHfPoMdjN4T/8EdoC5/y95Yj/31fEqm5lgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSplAPAbcqCwXrc73KaBOQNzaayHHHryXHEfz/QvCIP5+OLUcuUqhayGQU30an1Hx
	 YGDC2ch0190J8ZS7lR1jUdP6OQwlEiLMILXs/CkC/SlPI/9/wAF5EXwIZ0nb0Uecnj
	 UA9Ha7hLdu3BvCtDoUnTti40P6RP3bVkvwZuA5UDhaj8Dob3g32dp2vkLL6LUz2Uga
	 JrNca6OOm6CtiYGSnyjbJHFyuYTMa9sirnIIEndUMU2kE26IZfHRAqBcN1+HEuWJKI
	 iH1nd0618aV38WN9VJmQt9ibmxV/jw/X7xirOs3F2GwN8kBuIL5KMKravrNObUYubi
	 MyQ+vWsMpUjxQ==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Fri, 22 Aug 2025 10:07:46 -0700
Message-Id: <20250822170746.53309-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821200701.1329277-7-david@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A80740015
X-Stat-Signature: mxdk1ndyiwh5pmkmicdjyi7mrsa7mfmr
X-Rspam-User: 
X-HE-Tag: 1755882469-420833
X-HE-Meta: U2FsdGVkX1/3KUX2HSrW1B7v7uqQgUDoI6eE4Ay3SU6yNxl+h7oADSOsFpzqJw4wRFG7PxlIPv+3VbALGPXE6yWGkLCOlxISyfWwjgCGral3661BynExJ0tkXZ9jXRYICxqUm5ItIT3YD6CS+i5QFc54xQBXvwuIEClHsOl4LrNixhscDeBey6lGEO+VLDEmFGlw9H825FIhLjEthGHxXczJ1RWpD+5jUuBl2T9sGVX3k0r2kaSkaEQo+8s6dpJa6aq5xwEi7o0NdfkbDp++g6AeoevQcZietAt+uHibYzoenm6ohnEkLUuj+hv4JT2u0MsgtgPSfZAJOtNTWacSQjJvDkp2PlseoIbRUUvOa4GEyvQ9AckVlXqaN5p9gXiDVtDeG5fPxOu3omo9q6Lw9coAGhD11OOUI5CERqwy8hlM8ytOj3s4vfcc+H3bDUxTgWaHAfQ3Tyb4k4YkdAKjTxhtbbG8Ho28r+cyQHck5g/QqQqUPNJsTTPxiBbJrU2d504ctGNV0GAEmRwDrVmxJMApBi9fEcy4bg55skfymRjPlbR4RKdJNBnhC/+BM2YUOVtwvMFr5+xYOVpd5u1Qpl3JTbh3iIY5S0mmvWSw8xnnKIrUHirkXvxQ9fh5h0uqxUcbwmdrNO/u4GBKw+hzy7Rl56FQfQUs0AXT4MdjgvBmzsUKgGsfLjMgXrLUseDRKjiTikZnQfGeU1zCDCjv9DSTsnrYkljOo9mTf4PaqJpAY9Rwwc5gPtTaPGR2Tbjx+hPbHlJuvZd4TDDTp7hDczaqZFyNyoPUuooIrlLNNJ6h6CM18H9wyE8rGNs3fwK54vx8PwhMbGU2bNOOLESWLxT42bWKMmeEQGKcMWNjVX/o1nGS8yhaeCEvq71rLr5dcSOzD21Dx3CaTcv4W90AQ75bed6ArM0/qGbW6IMoCiVle6Q7czOQnRvayScdK4sJp2lScedvSgrZq9IlQ1K
 Ko+iosp0
 JZRehE3YVRwxrn28QpmiR12xqTfNQYkdR0u8zSa3+pyZXftxSOeZEEFayqmnPsbdrk8g/fwjcNfUfSe1zUB9Cm9rDbqqAvDyDEPyOB2SHwMDX0Pibei6KfLebgBROscd8J8t0hRGhxCcoGkXQDrIwbeyOY03wnM1LIpa8bokAmw4KMmuwwQ4qrF9OxSSH+D+h5MIk3P0lMpDUnVGZkyhWTZPFjFWWG5hda5P49se66mI7QupERYztGGFHrVdPvT2Y9LWSRedLHSjvfbPIhprkgo673u6xjDw9/J9JFo2mAYI1EzR/JTwLasLTkwrVguibG1NsiyOFo9SQjWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 22:06:32 +0200 David Hildenbrand <david@redhat.com> wrote:

> Let's reject them early,

I like early failures. :)

> which in turn makes folio_alloc_gigantic() reject
> them properly.
> 
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

