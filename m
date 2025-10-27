Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA29CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 13:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CBD80050; Mon, 27 Oct 2025 09:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4658000A; Mon, 27 Oct 2025 09:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121D380050; Mon, 27 Oct 2025 09:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0123B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:09:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 917EB12A6FB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:09:16 +0000 (UTC)
X-FDA: 84043925112.16.822A9E2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6930A180004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:09:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UfC2n8RW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761570554; a=rsa-sha256;
	cv=none;
	b=Ut3EtaGYIA/fgauhbl1iPA3PsQng6ubJi8+yZCpkv7yauibj2+IqjrJF/BoZPER6MWgM19
	IDowm7fH1tYNcXazEKTah0wLnFb72/hVzhn+4wDZQkhhoodCio/WOL9e+oHB1PbT3pNYQ+
	ARyeERRvxaCguiTsdNIPNJJm+vcIKCA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UfC2n8RW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761570554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ar+OO8r4g/ZD5Pwf2pSeyV8HbqM6sytt882/CK4QNMM=;
	b=Ph4ylhf6CO0JrxHhODhZWhRDjb9YM94fL5zoNkTyIbidjcB3LLl0Do+e2JAPy0TTyQ9j3D
	YQUOxz0V7YqhYmOoHwHShMOfcnSG6M3Avu1fW9vXFPUn/UQknh5WuHv1yE5m7yzqfvg67H
	5Pwl5WsWRRBkN4k8t//ICIF30WwONeI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ar+OO8r4g/ZD5Pwf2pSeyV8HbqM6sytt882/CK4QNMM=; b=UfC2n8RWapYSmEGSopI5s/E/1H
	8LWs7bTf9r2yjxEdeK4mx9/U1mieIqme//WDJfAmeLGdKPdnYWt3okDVRt1HtBbMB+J5eRWGMDf+k
	2rPxl929A4zUQWZsPrQukea280b7g06Ln6EDrOz12qEdgosuJMWTOAOqrbMeZD7kP+66Q071bskce
	m+3HEFdU2MVgspKyLjaiD6z8kK+vVlQsMM0Kz09dPQesChvwfMAvMgkUisyAWCxFumyckqFsyJdtZ
	POisQqBISRAmG84xJqpjNdqXHDB7q9gDlngSdWnuNZ0ZWUE8lWiXPc+6jrwYxIsw/4VqgONFo+toL
	7FzOgOnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDMyB-00000001vAy-0BYF;
	Mon, 27 Oct 2025 13:09:07 +0000
Date: Mon, 27 Oct 2025 13:09:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Message-ID: <aP9u8lFBvzEzmuHh@casper.infradead.org>
References: <20251023080919.9209-1-hch@lst.de>
 <20251023080919.9209-2-hch@lst.de>
 <aP6QX_gNpY9UDtub@casper.infradead.org>
 <20251027064728.GA13145@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027064728.GA13145@lst.de>
X-Stat-Signature: ocwmo6rmifurog3nwrsszfy59bwg745u
X-Rspamd-Queue-Id: 6930A180004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761570554-791344
X-HE-Meta: U2FsdGVkX1+Fy8Vlf4ibNcKdOjlctCvSBSwcw3f6N0lsDjv7huMExgBk4ZWm2UbjxKH8hgSotrDCzaZTuRd5i8c9nzOgqtWkgwokl9/sbOjUFYVinak7Dfqqj2jQe38tbeiPPItKiMDR924U+B5uXHhHaPE8+G7BxOwGJCYq85TOVfHIzOKqHJH8j2Z+h9fsfUN3KYyd8mytkRIxvjV96KjzzFnxTkkvqUG0EEeimXZXa0Zo8MSt7qqpc08L1ktQb3FHruOk3ymI+jGpfqEXOMp8kpfDNxl7lFBF+vgxo5uf/b4JJmqxRlZEUFCJ0K/IT85eQ1Nn+85sGqrOB/+AfaiCXhej75HLD6wCcOiFtNi7Va9yrSk85S3SV82D6u1bHZy4ZIz7nU1jIH/kgv4aPY5tlo97iGhJ3JHNBfiBNl/28rwvdzy1Gh98lUdNMl+J2scKbd+Or3zT63WE17Bvnu1xl03HXpthnRTDK71kP+7dAnaASFTAEc0nXcHcPb5m06JKtG3zHRrtu7VdE/95wqknDbTiylgKB7dMK0Vm7epDTqbV2fB2RzHqnQeORLztauW2Pch5DU/qRuxShnF378TN+p8dIeMGV9YmWCuwIedesUYk0c07jJnPAwPvtImSQ6IPCrCqyU1TDd9FdGUhMUdddnzwQNrx2ebzkPwElJsQScfepwjxfd8g0VjMbqGGBtBm3toc9fTZfDfa2qFxlV71g1xw9aasiiKywjyuRM/zEwPG2DkhPytHbjvYVuqK2Eu6Jk3OXHtz4e3aV2BuT6RlJVpXpSrs3A+eB8VEnM3XabN8PeHY3yQI1N1dLooc20v3Y/pqmcvTrHpK19FHjRH7TugI+YZp2nPk9Iy090PosnDTFD1t7LH16sRVIEHW2Wqwv/Vqa2UTgCs9zuVy1uC9IqAFMJgoZRreXgFGaFoHWsWGS3HnFgRnjUXkJcA2aLsf04d5YThuD2SeEHg
 n+EifDeI
 ZRlCTMnrvUnTqvcW4/FblzY6IKbsbDVb60uDGC7t1+Kbf0AzU1IpyBGI4HGNrjHj+hzJNIQaKjwUJ5QWVYaDasEugpI9DRnR7fl1xNqaFF4KUQYnRvbjIdTTlfZpnGyQ4iChb93Y2d79SYyhK9IQh6mn8FBMPGHPm28JKBPXVyfwHmjUO8s6r+pTRunUwcqifE3m5ibXMRPTPgHienEjJmEEr8xTQX/B76Ge1JDXWpbUqo9OhM+OSvEQn8g+fdx17ZQwoQ1UlSpPLPxe81LKBV+RU+d7KaodKhC09OOLO8r74tSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 07:47:28AM +0100, Christoph Hellwig wrote:
> On Sun, Oct 26, 2025 at 09:19:27PM +0000, Matthew Wilcox wrote:
> > it's quite different.  I am by no stretch of the imagination a GFP
> > flags expert, but it seems to me that we should make the two the same
> > since they're both "try to allocate and we have a fallback if
> > necessary".  I suspect kvmalloc() is called with a wider range of
> > GFP flags than bvec allocation is, so it's probably better tested.
> > 
> > Is there a reason _not_ to use the kvmalloc code for bvec allocations?
> 
> It's using a dedicated slab cache, which makes sense for such a frequent
> and usually short-lived allocation.  We also don't use vmalloc backing
> ever at the moment.

That's not what I meant.

What I was proposing was:

+static inline gfp_t try_alloc_gfp(gfp_t gfp)
+{
+	gfp |= __GFP_NOWARN;
+	if (!(gfp & __GFP_RETRY_MAYFAIL))
+		gfp &= ~__GFP_DIRECT_RECLAIM;
+	gfp &= ~__GFP_NOFAIL;
+
+	return gfp;
+}

