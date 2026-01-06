Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8B8CD0437
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08FF76B008A; Mon,  5 Jan 2026 23:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D506B0093; Mon,  5 Jan 2026 23:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E621B6B0095; Mon,  5 Jan 2026 23:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6C8D6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:36:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A4921603D5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:36:33 +0000 (UTC)
X-FDA: 84300277866.26.0AE5D6B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24C3C1C0003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:36:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hgB4giA+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767674191; a=rsa-sha256;
	cv=none;
	b=wz6mkg+Ec+kJOBmBejlz+cmhq8oMIqYrb4x+Szw1/ONGt9gEenwYPRuvsXnrVrTyxn5Ocf
	tksBIMzoKoBZ0eujlb3X4luc+7aXLfby4GF1f0Rn3LCsqerEy8OlGrohiVw4vcqD1LogqR
	ivdy5KUUuPPy7aJKyr3B096b8ngR+sI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hgB4giA+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767674191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCqnCUlOtKBvjGl2QuwECZj56qaExF+6jInKwQCN3dM=;
	b=Jhn78hG4oTTO0imHWMqWEor9OfGnVc/04O/5TtLkRs2NOljdyMV6hKK218a7zx4EO6dtep
	g8ulm6a2P1CmdKQkwpExT/PzxGr/9g3Sh3WKi3Y/YSfSt+EPWZdb1n/aVuCs+GVM9Ve7Ah
	6dmUxEL06x39NvkOTYvTGQvo9W8LdjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SCqnCUlOtKBvjGl2QuwECZj56qaExF+6jInKwQCN3dM=; b=hgB4giA+DWeoQmOHIaA5k1Oa1A
	g+wO9FLQ6BnOIDVxW60/sDhtyyqBItmEOOfGyZdpBUZnsYblPE/n06j2engCg1uOJGzkp9BncECq3
	c+k6FuuI/sJMDh8LWid+LpsfUFn365vaRbB/ZQYW+rnpKpr0k+2318kn54IMguKqlaHAASjWnTT7s
	oS3C+R/Zboi3wlmC+putpGegMUONDkOxgr5Xb5vQSikTx5pTYuY2/rwRMmhLmUxohi4PkGSjtY0B3
	Mt+FwEAikiPUBCQHVQKPHEuGoBUGw45q8nFcRNrG7W7HXei5s3eNUZVxkaCgNyFHuamR0KxL+VUKy
	lH+fQRvw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcynw-0000000BJvR-0m6Z;
	Tue, 06 Jan 2026 04:36:24 +0000
Date: Tue, 6 Jan 2026 04:36:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] vmalloc: Optimize vfree
Message-ID: <aVyRR2-fdvJ_9JNy@casper.infradead.org>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-3-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105161741.3952456-3-ryan.roberts@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 24C3C1C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 4krb6aye1cqncd137mnbfebky848ee98
X-HE-Tag: 1767674190-103694
X-HE-Meta: U2FsdGVkX19OkVFZkbr6sYOiGI6zIohs9Td+MA6cy8L4J51BxsSnvdZCAbNYy2In7b4464DxME9fF0qSRSlmoS9OhBHmGjosqVJaZkGDhJkiS2bDbvNnJFZ0hA/b/d9BiZOEo0y9ABy7VKYxLhbAuIWGXgmmiemLY7St6E4qCEnuciD0ZF5rGNUNBGPRHFWfLQU1TZ6bbM544jkSle5rX42cuKJxIppTwJdk4PFpnmOomu+BZnBSSSXjsNsRFKyHQUqnp2hr+FZn7PlfyQGgd5OSe+3GP4ORPOfYmXhIxzjDeUO4FZ0l1TwQUz4RWZbh7O7kx34NPsSeFN+tB3tXvtlj5Cgjq+Ecqynm82DPI+Ld0SbGYysv0mNEcSfhSiF/AEOAovDPjuO3DrRr8ZrJXzmfS9uelEKtjAw1LbyodnMMB+vj35HKbs92vI8NXOnLEf6by/skY0aMX/ebqGh+AiN8+bUXVGQrvtvk/Omp0+LCBbf7a6KsZOt3PAtjuetIpW9dSULXrjX11OV+HqrJ0T+xNfXdSfPZTViBdCyDU9YOKmP9lNiOy/1KRxVzLnyB94KgUcqsSOxI5sFhK9WFsV6enlFV7s06QcFOpp6ahe8agb48EUe5NaHVjGSFFSuIg7cHUp4w/GGhddD+A5y+kbS4TCgUhy52A6hqvhoEt44oc5zvGAaCXMQcFOWWfbdPpfYx23qnZvkUKRLLpZMh3GjsOy15Zf1wCE7h4LT4CvCDuuWoXVNGFo5GJBM5qn8WubQtLOrRdcehUXNTqNqbgNMi43Icuc+OkeyEiPY3CLkyutMhVIiELj3j3v3OFYkMdvJuTcsVd2SHTlfXcP6iUcjIM0QpshqHT/zsCU5IV507bfYyTY2WCLbFiypNboZMxwJ/LRrQc0yvRfgD0bHYHL5yn6Z6+zC1kg660KWNW9vdqJlolfva8aNH6M96X/KPVqFSX8vjIHjMXQGgXBG
 357pQc98
 XJLCt5J3eXMUPdZXaWddwW7L5Q/dCk00tTfzACsWfMByIVMDLY9d34FZEq/WO9y5nZM97tIcC/rwCVivO6TmeZSCXntB8UQ8hQfp2blAZt0FMoaoOPtH4Ek6RaAbrDPFexbbYczk4ozFoxlsG6tzMiR8zzAGDOJP/1t1hGuIIBcPKLlezRVxD2Yfr3Q/GkqAfC21pc6kriQCbU0TAL6ECrlwm3xK1W0L9i2BQtzbA+vdcl7Z9EMQZGYoFIKgFT8s+d8ED6zZfZzBOBJpferwuew6GArrgZY/dvyYWFVTXcmgNBuFmSg05AwKDMCW6iqzvcC4Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:17:38PM +0000, Ryan Roberts wrote:
> +	if (vm->nr_pages) {
> +		start_pfn = page_to_pfn(vm->pages[0]);
> +		nr = 1;
> +		for (i = 1; i < vm->nr_pages; i++) {
> +			unsigned long pfn = page_to_pfn(vm->pages[i]);
> +
> +			if (start_pfn + nr != pfn) {
> +				__free_contig_range(start_pfn, nr);
> +				start_pfn = pfn;
> +				nr = 1;
> +				cond_resched();
> +			} else {
> +				nr++;
> +			}

It kind of feels like __free_contig_range() and this routine do the same
thing -- iterate over each page and make sure that it's compatible with
being freed.  What if we did ...

+	for (i = 0; i < vm->nr_pages; i++) {
+		struct page *page = vm->pages[i];
+
+		if (!put_page_testzero(page)) {
+			__free_frozen_contig_pages(start_page, nr);
+			nr = 0;
+			continue;
+		}
+
+		if (!nr) {
+			start_page = page;
+			nr = 1;
+			continue;
+		}
+
+		if (start_page + nr != page) {
+			__free_frozen_contig_pages(start_page, nr);
+			start_page = page;
+			nr = 1;
+			cond_resched();
+		} else {
+			nr++;
+		}
+	}
+
+	__free_frozen_contig_pages(start_page, nr);

That way we don't need to mess around with returning the number of pages
not freed.

