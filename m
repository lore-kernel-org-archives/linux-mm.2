Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42832CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FDF6B0010; Mon, 24 Nov 2025 07:39:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907A86B0011; Mon, 24 Nov 2025 07:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D8C6B0022; Mon, 24 Nov 2025 07:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E27D6B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:39:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A85E313AA9B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:38:58 +0000 (UTC)
X-FDA: 84145455156.14.A52E839
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8986A000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:38:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PKeqZ0JN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987936; a=rsa-sha256;
	cv=none;
	b=itLG0HV47/Vcr9JcU0crI/k2ar4QwMmoOCmUc0J1xMv+h44S7GsJzhri6rADS1UrPLNBBR
	yRMyCm6GZcNVYaBYEZ0UGHBqeD253rWAnYLCsKIP1tunHINvb2HBwmCm4WJSDD5ZQJG230
	vWi6b2JJEEJLI99sjflaqGl5ErNjmCU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PKeqZ0JN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hKcjz4CEQtKu1cZ8SM9PbIexDlVU/R+LQLODvCo9Dg=;
	b=gBQ32vp4+Ug0y8t2ZRwmjz+AGnHK45aUParByRbXVpp2BvRm8mn1XPvRIit8dCHe2lUkmC
	zicTuvq5VUXsZNBx6gd3kEpuXZy3s0MjNP5U1GiiiCL7l4kJykTeg6fS6HnKe7CcngaEoz
	YDTVpNLZ6NzrO6Nnf2+v66eVrtmPL9o=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779a4fc916so93225e9.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763987935; x=1764592735; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+hKcjz4CEQtKu1cZ8SM9PbIexDlVU/R+LQLODvCo9Dg=;
        b=PKeqZ0JNWargezxcy27su+sbjnEK3ZKrEYXqZyFDym5Df+4f0RxkYb3mpeW9SqorVU
         EGdp1ExuCCwqdHwCTIvTjJG467mmKzvh2uhXZJ/Pqh0eEr8QO/Gewv4U5WrAf35opirF
         j73DeYBVzQAvdslmwdIY90NQqKmnVd+tGuf63iMw70PNtz7ZdeJA0cNQXwR6WLV0kP6/
         900h4H6qEYkAnkWOQQa4MqrZwRwSAbbh49riq92VM8sE/pE+kdAkROJ64qGjRbMJYB36
         gTS39pWVsbXGp5c6ZEw5NZjEzNbqZiGvuPqqGs+LbEegMoqSXAJPlL9n/jrawnkcy+2l
         oXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763987935; x=1764592735;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hKcjz4CEQtKu1cZ8SM9PbIexDlVU/R+LQLODvCo9Dg=;
        b=cRFrVM0C6XunOu371vqxwmrQK6onOfVaY9LGqG9jPORS4nu9gXjcN8IZ2hG3/koAa6
         Kp14nl03fvSIbVjZGwl0vrAPR8NQxMyeE3eBpEkJ0N+ARa21Bw/EBKINClQ5p0n4JNx8
         b0hPRs6MygJNFmdOd2b3/jg1uIJfclpKlsMFyblvu+3jdZZnFnuYQytczMKxZFvSeudB
         6h1RjR1CsMdaXI+4qvSFOfwMHCF5vLWvl8qWy4IQPiHXWKgtXzUl0I/7D5EZj05aYGVs
         ymOdvsU6qi/xKH3kqF6ZtBBSYwcRe7m/h7ozhHphoGxztLjxUefyfWCYTBtu7ZVRNQS6
         narw==
X-Gm-Message-State: AOJu0YzpI8QY6Q8XCFmUYV4DMvu6elfkGCGyXNRFmFNHISs4wY2epF3q
	iqNqALb1+MnuScaj1sMhiaqxVd9GbS4TdBB9Q5sxbzvP/otF4Z/iMFwYOB/GxDR5tg==
X-Gm-Gg: ASbGncuwIvBCFVzJkefnszMkpJWdd1s1x8Pd1igJngJuDG9xB2Q4Fy8Kqqhm3DfdP+8
	e95uEi1J/dYurPnDpU7BUmv4UyOA51QC34pRNaJPeGfl8TZCQVO9QQoD0fQMjSCfyWg8yOLpRxp
	rhUHUor03zzvsai89YZYFl4hfXCzzLMdOWTDDvEXC/4PWVdtxgGeclaVVM1+XBf2qm/q0zF9tbB
	NTW7HFiLqXak4GAKG5X+igd67FADUqqpxKo5+GYCC9dQrlI8bEW4XbwImr+r4EjauOIpr4p4rrw
	LAdPC7yVt/t1oFTsUVCF8lDHlbTcwzaHWs8Nx+8iR1wZV0XIXbmEB4lrpzwQD1gMwsDb6/UfmU9
	GmpwVxoOJF6ANP/8XITnz0w51v5zn0JWHy06mHJZuMY/P4/cUA2RrBQJbLPpK+fPpetyg7lhiy5
	X3uY4BAr1dK1unptn3lszK/I/LQbrmCLDMwcq5nrCOrRfIxrbDzQ==
X-Google-Smtp-Source: AGHT+IEZgUg1bUbdAI5VMl92UmNgBFeGgbcBg9hYsUoLQBWM96FEzs3PepDjVAB17q+bUwBOhS6TRA==
X-Received: by 2002:a05:600c:8a8:b0:477:86fd:fb48 with SMTP id 5b1f17b1804b1-477c5e9b0e9mr810065e9.9.1763987935133;
        Mon, 24 Nov 2025 04:38:55 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f34fddsm29238614f8f.14.2025.11.24.04.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 04:38:54 -0800 (PST)
Date: Mon, 24 Nov 2025 12:38:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 4/4] drivers/iommu-debug-pagealloc: Check
 mapped/unmapped kernel memory
Message-ID: <aSRR2h68l9LRn3iZ@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-5-smostafa@google.com>
 <aRW6LWh_1lTce7kU@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRW6LWh_1lTce7kU@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8986A000A
X-Stat-Signature: tzizcic8ai5tpjxkr1aidkka8g3xhi9h
X-HE-Tag: 1763987936-976341
X-HE-Meta: U2FsdGVkX1/qcYwTv13lAtCeB9Dr+hrxtXwWFrhmixdQn3gJbhSYMsqAt5pes4JXLG1B9bn5ph5Wiw4ZQVLnRWwiRSSIFjhga/ZG78Z4/+0tEYG0kjoZaJbpvNkYkB0AAu/PHOhsYFCaLYhgySozd+UwGDftGUkCjEhf1lIc2ilPKpGp31Qu67DbvyXuZoYcZkGr1def/inxG7xVI0bvjuLnYs7MfA1oz7iWCCH0Ivzjio1VguK6GbErBBxFQkqriJmjUJKSV7/1pa5/kOBl8/FVTAA6+jjuq0B+3T1B5nZVPp7h+Q4lzNWyj8Hm7uIw35dOrGf991jaSNKk7I20PdKtLzYAKE4CUxnZF2cqh5ZKVfh+VjIFbPHYBqZ8kK8aWt8FmFJTO90DF2tfmWdmhqgrV6IGfkzZP9nBR7YAh/FIQwyb6BNKcnu2GRGHZMUlHVA4xBiequfRZ7HdM0CAv9umKvKkNSlHBTwSNr+BcmgN1fvDfBmjvR7RrkbP8rM4v91islCsr6aHO6oNtsGDIWZqBJPZ4lavWmMlUjcSkOP/VQGsucn4GvC6PjUEwtLtEfL4XC3wf0Su7JLaXKZwJ2ysOTf2XB2oAIL7+iY/wLtpcPbYQcn27uS4AW+rMRAuMtVbmPSF8Hbf3Or3gSmSdChawdPzv/IyPK55+YD7B2m+zKxjN2+Y6ohEkZiYlGpEzmsDtkbnWpF8YDRDQQIo7rbo3fyLGCMTSH0j3Wv1AvCcEe0d57fl4x4EExHM+cEkvmntPohm9AxuXBbJOs6B/qU1vvE6K/u2okJUHouYsjcw3ad3Jd3KgXbEHeC/g4+HkWl9rGCSYo9y1ij5h3WABnzn1l1Ajuehu4MDMJngAsIHhWxSGQz/tdA8clN2+6w69EPcX1Y6o6VHrmHMpOBk3TK8gYfKrlf1q5jdw3+EmqptfsIpN5bnN/tcci8RqZEAfVMHzFw9tygx9f1efFb
 WJF/0mDz
 JADs1EAl5wuwn1iXc9fR9XOcpeTXwSR7mmHMl8nJG0L+2iL865PggWAJWd4QLywuNbIXQncvhVa4MZkYPSEFSeSbvDsCnwYyrKUV9H3qBoMZbmkZhMaiK+r2UZnICDp7WvSszNPJ514w/vUNJZGcXQVj5MfOunc69krLJ9/t68RDZsx5zz2vY8Ep6KOkfob/4QYsYKPGokxRhNB9BMA16/ruI3bR0ytjn3UoPbuqGBr7A3FQcna+FjyyaNdS5OhGj1zeg1+lTVxY0h7oJCmCHbUzGL57D2bEHoXl6LbwR3cjvBVZnidAx0L/d/ECJxIsXueKPIc5NeAEfGE3Jwj330EyOONq0aetI1BJDJdnjYYs1CZatrn3/CVSYx3m/T6P3MCMnnlVMWlHDcKOAuCxeI5ggJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 10:59:57AM +0000, Will Deacon wrote:
> On Thu, Nov 06, 2025 at 04:39:53PM +0000, Mostafa Saleh wrote:
> > Now, as the page_ext holds count of IOMMU mappings, we can use it to
> > assert that any page allocated/freed is indeed not in the IOMMU.
> > 
> > The sanitizer doesn’t protect against mapping/unmapping during this
> > period. However, that’s less harmful as the page is not used by the
> > kernel.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > ---
> >  drivers/iommu/iommu-debug-pagealloc.c | 19 +++++++++++++++++++
> >  include/linux/iommu-debug-pagealloc.h | 12 ++++++++++++
> >  include/linux/mm.h                    |  5 +++++
> >  3 files changed, 36 insertions(+)
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > index 0e14104b971c..5b26c84d3a0e 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -71,6 +71,25 @@ static size_t iommu_debug_page_size(struct iommu_domain *domain)
> >  	return 1UL << __ffs(domain->pgsize_bitmap);
> >  }
> >  
> > +static unsigned int iommu_debug_page_count(unsigned long phys)
> 
> 'phys_addr_t phys' ?
> 
> But having said that, wouldn't you be better off taking the
> 'struct page *' here rather than converting it to a physical address
> only for get_iommu_page_ext() to convert it straight back again?

Will do, we will need the physical address anyway for the error message.

> 
> > +{
> > +	unsigned int ref;
> > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> > +
> > +	ref = atomic_read(&d->ref);
> > +	page_ext_put(page_ext);
> > +	return ref;
> > +}
> > +
> > +void __iommu_debug_check_unmapped(const struct page *page, int numpages)
> > +{
> > +	while (numpages--) {
> > +		WARN_ON(iommu_debug_page_count(page_to_phys(page)));
> 
> Since you only care about the count being non-zero, perhaps tweak
> iommu_debug_page_count() to be something like:
> 
> 	bool iommu_debug_page_referenced(struct page *);
> 

Will do.

Thanks,
Mostafa


> Will

