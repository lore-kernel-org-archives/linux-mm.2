Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D4ED711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7026B0088; Mon, 22 Dec 2025 01:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A3B6B0089; Mon, 22 Dec 2025 01:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66806B008A; Mon, 22 Dec 2025 01:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A473D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:00:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55431BC640
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:00:57 +0000 (UTC)
X-FDA: 84246058554.14.F0080B7
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E64540016
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:00:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCJCZ7o8;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766383255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YnoYetntYAKPTmqMpJsArUchXzDuI0E7C6KJhIP8qU=;
	b=lHDyclf+a+fB7cS9F8mUFROx6XlfsUd7yf8wjdx7DBsviINL2/h8o4BnQjnx9Sw9suT5xq
	w+96iQOSlDP5U0HpbjlvNcPMzNi+HXAfIuxiGDbzX0J+8xKsiHXcfgpwmclKukht+vZb/+
	jH/OYrhSFni5Mst8+ZPVKltmqdFMthw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766383255; a=rsa-sha256;
	cv=none;
	b=kt5uPhA2a64t3Bork/Co9daqONC6+UIQGE+mcOgDaxLnozcSvVWRbrbgqzXlN5W17bfBZC
	72dP4xwsPkMWS3VHmFcssM0yWQaIlKPV8mpD5vu6EiHBjaL9JUoes1Vu6eEIjfa+XMDxlQ
	9Nt5lGC8vQmMZ2sU9JczBFofM+Ko8aE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCJCZ7o8;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766383253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0YnoYetntYAKPTmqMpJsArUchXzDuI0E7C6KJhIP8qU=;
	b=vCJCZ7o8DllOX7DhHQAOSMjpud6aq+CN2IihG311TfQhv+av3UubulNaD4JSFsSEdBcOGh
	k6nDd5vsE24k8HuNJMnH2bXYy5zpCtpbg1nq0o9pDRlpJWTM4CW5OBrhkChuZpY23svjWc
	C2qAK0G5/0NANd9hQtXBveEyohdXQb8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 11/14] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-12-kas@kernel.org>
Date: Mon, 22 Dec 2025 14:00:09 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <48BA4DA6-DE9D-4F07-B347-19D2F68B357A@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-12-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d7iff5cufibmor5qbujd6h99xps4y4am
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E64540016
X-Rspam-User: 
X-HE-Tag: 1766383255-927578
X-HE-Meta: U2FsdGVkX18F+IUzWYr4C06osi7UfN9elr59suRambl1r6VDX6AWhbr0tx45dQAHuZ0trkIiWRUA6GcMJIWiFhrZUWM13W+hm5z1Rv4tn4CzzthdpybMRb2Z8ojvgDOQ6fyiCr0R5djHy9qqvfenJu+M7bdt1fmdCoAYvUzgqv1Mss5Ffsqhnc9IG//uYZaLB3k+aoJCsJ+X5tQVnWcFbmysQTA8Dw6U18nmebqmdp48mxg2Mkw75QJKlf0DV959eQBxlPM5TuyJsYvgxtRskjsOCB1v5RnJppmL0WD/c/nGYj1qYMJYcZRGPQvKFIE9Ogksus0lPy/OpDwrmuga8V8KuRdju6tDq2VpsTokWXWPjcvSViNT94vVfZ98w0Iwsy+nnFAGpuO+wxU5jmqYGVUsovqA1945oXbjPwtOpHsydsjUbbBfeSdsbmwrPtWKTZybJXxTbHGgJBJuVOEm0/bGkedg/JX+1TtPW0/iHfr1kuG2sBsKnExacWwH6CuKJTsi+fNgQDb77TbDOnV80jTWS5pGXaZD7NgAn4aY+SOyXABBxk3v+NCC039UhkFZ9kmDLiA8s3TwLDSF2U1CFbvh5BXP+lZYeALxNNxki6pt2LgSi9TtNYI6VsHwFxGcahT7dvSycI3d2qpGJqZD1QuqyaR/5esKfJFvujpGLSn7XvjcmUnsvN0fsr89tre67YqN8eJGHqHAPBcovTaUdsjos9GR7if9UEHvANN99f2ivljtkJ6mjc18Ed+mmqcXwx1sqXB773F7GmWR26s1docuwaq4RmSe/0yu7EzqSSbkjHcxcNCX27vX0tUS0EpI3iQt+ruQ/r+qgz/Xo+wWzTg9dwHacKMtFrq8oPDlWtrNSWFOaAXDqrdt6ujS7vyTZg4rN6G9iJT3Bt+tCw0V8OjwfL8Msad1mCOZ0OgYYbnPVIlbQKDX4X3KYzl7VfC01jBy0/l9mEd3b8yz848
 hIMmhV6h
 JGjIP6bY/SDwJe48sPXf9WhwJjETUVCBw3TbO5Gpy3y6eaZ6V+WA0Z66fW4ATLlfNhDowKv7kwAX1DdEVx5bMPmQimkY0dRt0IraiRccXOrQMGGk1hIDKQN1ea5D5ktu8UymPSDEAQZ1396o9vMW3eXuFIGLqxCkeXl/wvt97mh+igxjDsk7CFWjcUF/nyNdrpzmbZOSMBZs55XptOvJHZTrKhesK1sFgjuiUAIPFynTZV+9MohzSCH+Mn8kbTUEap+DaEJd3E9BevCl//4h+/9JXLr5KvvBVrtBdHJ6XCngM21wTnVbWtu6ZRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
> prevent a race between HVO remapping and page_ref_add_unless(). The
> race could occur when a speculative PFN walker tried to modify the
> refcount on a struct page that was in the process of being remapped
> to a fake head.
> 
> With fake heads eliminated, page_ref_add_unless() no longer needs RCU
> protection.
> 
> Remove the flag and synchronize_rcu() calls.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


