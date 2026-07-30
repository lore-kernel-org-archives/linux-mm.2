Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B97C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CF36B0095; Thu, 30 Jul 2026 10:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE356B0096; Thu, 30 Jul 2026 10:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC706B0099; Thu, 30 Jul 2026 10:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9B86B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:23:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2694D1A0168
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:23:20 +0000 (UTC)
X-FDA: 85045660560.12.2911E77
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4075C140011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:23:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUp1LBZm;
	spf=pass (imf26.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421398;
	b=8VK5+mhBxsU7VZNKGPfo8fM6AQj76n27+3dsLjv7hkwoMqpjz8CO2tx5TUdLYlmtB47778
	p0oKzxVGw9w8f4r8PRSU4vz9aIVJJsSeU+1Dc/KHib+ROfA2Tjdm0iSZhyl2Jxb//wLEDh
	Qe1VlCYFWtg7YeETwsBTVIPPu2a4qoU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUp1LBZm;
	spf=pass (imf26.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G74EfrGlVf7uX6WfKSZkQJO5gHzdmhMpULqAQUJlO/A=;
	b=paxSSB9UY1PZSdPPft7PlR89FpeAF4XQgsMn7kBUJapwBi40NRErUpLpmBI5dAbgojiNbA
	icNIVt+vuDDoA0apP448vi4ElLJGhYXmJaVgQaLDgXmmv4yYer4W4on7kI7WDZzquy39C0
	bNuz1ZBNq3Eg3d5be7cKjjgq2HS/ROU=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-97723f98735so1313909241.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785421397; x=1786026197; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G74EfrGlVf7uX6WfKSZkQJO5gHzdmhMpULqAQUJlO/A=;
        b=EUp1LBZmLesaWOG0AGfbMWW1avRZvjyX/r4o0lpK72aTKXKMJEx5j4qAA3IgtQRajH
         lwCwqncDKj6kVVLKgCk+F18OJRE7Eh639DJDWihluj4GO98+svw43ovl+MTgjZSVBduK
         k5C/Bhob/DSifj7oedweaImzsRDtplBgFfcLss2kYRzkh3VbABkh6qY/FFrmVl9Bxr1b
         8Rxj/ZjYeAKdikIIWC05H5z+YXhxJrI1OxKynI1wGR3Rkk1BlAXzXkSkmCQW5rw+7Bwy
         ffVh3eVlCAOLumCulbp6m8IoBKWeH8M6UMpNWv7XoOMrO/VKW9zco0jenudUicB7/NO4
         by7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785421397; x=1786026197;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G74EfrGlVf7uX6WfKSZkQJO5gHzdmhMpULqAQUJlO/A=;
        b=fEBwypERFlFbGyKg4JEvO5/nz3brjJxrWeyqiLrwBRpuYuvcdOvNPbbQi8j2uHQZRF
         LNffhARXw1fLQb9xwuRkyQVtAwfjCvGKsLFyNZ1rU1FVHWDt7luMGapS/oVdANcEzgzX
         syJGEraAIyG3QieIsdXEE0VLuku3EE+5sXmjPv/AGMnhoH7dDNa7/UjxTbL32CGEQTP0
         LsIEtFBWruq/o5Fc24MBGbdjOAr9sMD5EzVlY0goNXtE6rGtpvE6YdG8IiElDa/6u+n8
         Ny5m5Rfg3CYzgtka/BqdnzbvkWK8qZ6CQaHVDhS07+ps1tk58UlvpKAmtUI+IYapnvwj
         LApg==
X-Forwarded-Encrypted: i=1; AHgh+RoGP/mJALUxQXmDoJIY5jKAJ5Y5Cc9W4zg2oSxB0UNCTm6DzTY1Cgf2kfTvaRYQG27uOuMAJWSrfA==@kvack.org
X-Gm-Message-State: AOJu0YwrXDZCyhy4iGQIk4c5PHCsjduqWw8NOdjHtoHXKlJsWSoHUdE+
	3zXrHK+qVCiX5KmKLkSiTrRymx2tnoFB+QfSZh5lHK6Ja5Np3STY2sIHeQun56Yy
X-Gm-Gg: AR+sD13gNCmCRgyxwLCp7PejqOEREdXet0NLN9s16Ra/kowyd4mnrlDsbIVdfJ0pEpe
	rufbXY1JOaPr3j8/lHnYi+TyY2KCx6K5iLPMS2EmIaq2DmhtzpYuF+W2lCNRfxEiNOl16YZlhQY
	qrYyAc03iqHQrALIhzMtnpzmx9AKpJ7qDK8mk44usP0rtKzQao5iL5ISTxMTDxqQdjk0JfcIEzj
	mD0Tlp3qaihPMS8SkO6ePZtJ3TDzkbUoaeKmt7wM5v97ckeXOlif4nAc1lub/tGeWRE2ZQhprp9
	KV7RWLH7qyaYGBGKVDhKekMX6fggptbOlO7qBjbdaxjZ6SjIf/B28eG4ujcAM2cN/R1qcL077++
	NHciQGnuDi0hPgqLw88m0o0YO5tR0SWZzJY1zy/7I5TEZB1NJAxKbvLDH1f7k4zb1VAw0EBlec7
	okJ0IW8oU+l/6wsswPxAoOfNJcmccn2Qfcv9hzv8MfeJMRb8uLSc5B/6U82c9gvfAlyNLep5veP
	C57f8Si/ufzBIw4FpPwmvaFhL/gs1drdeeQ
X-Received: by 2002:a05:6102:304f:b0:737:4cac:52f7 with SMTP id ada2fe7eead31-75750171354mr1067997137.19.1785421397113;
        Thu, 30 Jul 2026 07:23:17 -0700 (PDT)
Received: from fedora ([2804:30c:1f53:aa00:1495:7d0a:c9fe:c63a])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-977cddf7ba2sm1262117241.13.2026.07.30.07.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:23:16 -0700 (PDT)
Date: Thu, 30 Jul 2026 11:22:25 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/ksm: use checksum to speed up page comparison
Message-ID: <amtdj-V6kDlXFhq7@fedora>
References: <20260716122039.679173-1-pedrodemargomes@gmail.com>
 <98c91508-4aa7-4390-b2f0-e39f16bdedef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98c91508-4aa7-4390-b2f0-e39f16bdedef@kernel.org>
X-Stat-Signature: apmzjg9dwj4yzr15fmtpmih4iu1tssxj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4075C140011
X-Rspam-User: 
X-HE-Tag: 1785421398-105570
X-HE-Meta: U2FsdGVkX19X1Sup/63ZwagIfdok5BD5JFrizO9nWOr3f6Pc28/ng5hvoxJ/CC4fwovb7FJmnz7n0nGBVzg9FrGX2bzakl2OmS0D+m3YXL/ROZVQnKSA0+HdPPS27kY4zSBi47O4tl3TIQM6YdMk9JMXl093v8OpFn7n8+/lZd0LDC9pl/JBnoASB0ifMGHfn5QBFQlBp7birz5jXkOGmFYnfB42FoO7RUALc8pvdtE0Du4GcUWuU4vMqu7SoUW9glrRrEaWJ9KhFUOmwzuABu/RksrYUekNxBqNHyanB6kgrDvi4vbnqu9BIsY0CWFzG8xz4kiFOshDmhXcsu3jCn4sb+BpuMQlMvARF2PBjPzbDs03XC9GuNqXhFIXotH9QQigG726gjgISlqe5cXKl2YrBEHoeRZhlM45spXXN3SyVeGgXFD493dWrbX5jZEpsed9f05zYo/qqWKZMhFjnZKW9ZRo/CIIqyQKHOahsbBr0V/fTifuI46uCxgRn4uBqyuET/w8QT7Qjh8u9TBXe0OCpG99kFopwTiAHCgXv0ZpPabNA+kYKQpCspLmczjavXa3QAHsQ5UynTUsYZ78FI9Y2+fFXpL3ZHK0Aa5GSLkDDqYsCoyDlHo0QTNDW4l+s35Rm8Y95fdYQEVTPyN0zn6MJ1Y1JUwj8HDN7aDdgL9Tjr8CQICeVLazsuQq1a4Nud0isXQMTGVDIN7Gu6lqmXRYymGet2rW3LQE5b/r557DzrkV96kDkbliatVlqDq4YzBCRgLjhVvDtfZQsCkviyA4czecghXb9kuCr/DyEiZSomxm8bSq7Ek/yCB2HYPELiuK5n/urFdhUJ0saZL8c+plxVwvavI/kjrDvjQKIAplin/cGA6cN8BiB2imYivInVZtBbkfrRDD8RmaBNIlIf+YGklVQiu5/cJ6mvFWZOQtz5O/BuPXPyJwMijRy7DE6u69PBOL4wf1VdnMWyV
 RTJmSQrQ
 TT5s/078c/aibAZ8QJTbEvV0TpxldHshe/3+b1qF1mr7sR3tn2KhW+leP9b/Q1ByanG30uIBsMURgcyC6fY1P7cyWDh9VodVKJKuJU1cscGM0Ed0xlvGEs7ZM/zsVLogVLx5YAKV8vpejM4zSpkSmGt2W+3/mVG5tm+Eyh8HFndtPlATW8DCpTUH/wbchsy4UjZIHE5nilyGH6XEZSsp8aLGtjr0NgFRhzhK03FSaE52uIEBbo1DN0JkoQdFjfXZUmWRacj6IshlC+99HOwQWlP+yttTbQl6cRdfHm1BwOEUl+Obgxpw6taDwEc/YCeqT7q9Kn2IETH3FvXXitNukp4f279LaIgyu9Tz7IRHUkMUvt5UZ7LnxeK/hChebcwQfwk8oI0igGjOWtgzcH9InreLqJEXxWEd4BJwQwlraXXeTGsgIh5W9DMd2empczjZrxV0XC4iRvz/dwnJc8QVSlnhZgUc4NKYQUWjvHrJKy0cCBi7zw2UvZHibJR+YfNbzamGPVa+1HWqkiwBkNDWQkLWQ5GjIS5S2qCBQuSsu+EnA3OG7hLM6Nk3nKs54OnfiZOse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 11:38:38AM +0200, David Hildenbrand (Arm) wrote:
> On 7/16/26 14:20, Pedro Demarchi Gomes wrote:
> > Use page checksums as the primary ordering key when traversing the stable
> > and unstable trees and fall back to memcmp_pages() only when checksums
> > match.
> > Since struct ksm_stable_node does not have a checksum field, create one
> > in a union with migration list fields, so when we encounter a migration
> > page while scanning an address space we have to recalculate the page
> > checksum. This avoids increasing the size of struct ksm_stable_node,
> > which is maintained at 64 bytes, as show below.
> > 
> > pedro@fedora:~/tmp/linux$ pahole -C ksm_stable_node ./vmlinux
> > struct ksm_stable_node {
> > 	union {
> > 		struct {
> > 			struct rb_node node __attribute__((__aligned__(8))); /*     0    24 */
> > 			unsigned int checksum;           /*    24     4 */
> > 		} __attribute__((__aligned__(8))) __attribute__((__aligned__(8)));       /*     0    32 */
> > 		struct {
> > 			struct list_head * head;         /*     0     8 */
> > 			struct {
> > 				struct hlist_node hlist_dup; /*     8    16 */
> > 				struct list_head list;   /*    24    16 */
> > 			};                               /*     8    32 */
> > 		};                                       /*     0    40 */
> > 	} __attribute__((__aligned__(8)));               /*     0    40 */
> > 	struct hlist_head          hlist;                /*    40     8 */
> > 	union {
> > 		long unsigned int  kpfn;                 /*    48     8 */
> > 		long unsigned int  chain_prune_time;     /*    48     8 */
> > 	};                                               /*    48     8 */
> > 	int                        rmap_hlist_len;       /*    56     4 */
> > 	int                        nid;                  /*    60     4 */
> > 
> > 	/* size: 64, cachelines: 1, members: 5 */
> > 	/* forced alignments: 1 */
> > } __attribute__((__aligned__(8)));
> > 
> > To evaluate this change it was used two benchmarks, bench1.c and
> > bench2.c. The first one allocates 8G of pages with different content,
> > and the second one allocates 8G of pages where the first 4G are the same
> > as the last 4G. The two benchmarks and the system ksm configuration are
> > presented below.
> > 
> > bench1.c:
> > 
> > int main() {
> > 	size_t size = 8ULL * 1024*1024*1024;
> > 	unsigned long long int numpages = size/PAGESZ;
> > 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > 
> > 	// Generate #numpages pages with different contents
> > 	for (unsigned long long i = 0; i < numpages; i++) {
> > 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> > 	}
> > 
> > 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
> >         	perror("madvise MADV_MERGEABLE failed");
> >         	return 1;
> >     	}
> > 	printf("Wait...\n");
> > 	getchar();
> > 	return 0;
> > }
> > 
> > bench2.c:
> > 
> > int main() {
> > 	size_t size = 8ULL * 1024*1024*1024;
> > 	unsigned long long int numpages = size/PAGESZ;
> > 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > 
> > 	// Generate #numpages pages with different contents
> > 	for (unsigned long long i = 0; i < numpages/2; i++) {
> > 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> > 		*((unsigned long long *) &pages[(numpages-i-1)*PAGESZ]) = i;
> > 	}
> > 
> > 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
> >         	perror("madvise MADV_MERGEABLE failed");
> >         	return 1;
> >     	}
> > 	printf("Wait...\n");
> > 	getchar();
> > 	return 0;
> > }
> > 
> 
> Hi!
> 

Hi!

> > Configuration:
> > 
> > echo never >  /sys/kernel/mm/transparent_hugepage/enabled
> > echo 1 >  /sys/kernel/mm/ksm/sleep_millisecs
> > echo 100000 >  /sys/kernel/mm/ksm/pages_to_scan
> 
> Given that the default is 100, and sleep_millisecs is 200 ... and it is known
> that frequent scanning is harmful for performance, what is the real world impact
> in common setups?
> 
> IOW, do we even notice / care?
> 

As described in the KSM admin guide [1], the default values for pages_to_scan
and sleep_millisecs are intended for demonstration purposes rather than
production use.

At LPC 2023, Stefan Roesch described the use of KSM in a production workload at
Meta [2] and presented optimizations such as Smart Scan and Advisor Mode, both
of which have since been merged to reduce KSM's scanning overhead.

This RFC proposes a complementary optimization. KSM already computes a checksum
for every scanned page to identify frequently changing pages and avoid
unnecessary stable and unstable tree lookups. Reusing that checksum as an index
into those trees can further reduce lookup costs, lowering CPU usage without
changing KSM's behavior.

[1] https://docs.kernel.org/admin-guide/mm/ksm.html
[2] https://lpc.events/event/17/contributions/1625/

> -- 
> Cheers,
> 
> David
> 

