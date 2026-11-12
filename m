Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17488606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=EbBhSSYh
Received: by kanga.kvack.org (Postfix)
	id 34FCC6B05B6; Thu, 12 Nov 2026 13:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301766B05BB; Thu, 12 Nov 2026 13:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E9B6B05BC; Thu, 12 Nov 2026 13:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1CD46B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:15:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 656331A07E5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:15:34 +0000 (UTC)
X-FDA: 85427269788.27.8783587
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1666240012
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:15:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EbBhSSYh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec7ksqE5j1xr/gXWS49S8KE9vtv5SLUNhac3dhFnc4w=;
	b=4v7kGaCNz1HhiblMD1ypsh110XKiUISTdHTqnqyj6G4hlSZ3fmKX5LqpRho6SfGAshVCuL
	fYZA2fUUvmgWNBiVrCIY+LCVOgLput0o4hgoaaL9+RU1MSkbqDzfWAwtHghiGD1wuh47ZK
	kMLYHeXeNIRmVx669gjWgaimzhpRxfM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EbBhSSYh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507332;
	b=S1e46EuyaoNNz5+QRCffjja68S1vIC0IPKE1nerKnu/GicgfYfgIxVFzzvY4eFTDrCrswS
	I8ApW3711McAlH//Fybhu5m1kfqJplid9clB4pD44+qw2cvCSmJNL3hZFA/yH1PJBXLcSj
	LA4BLWJuMV8OWqim84WjWRJGdjXX9GI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ec7ksqE5j1xr/gXWS49S8KE9vtv5SLUNhac3dhFnc4w=; b=EbBhSSYhiUr1r4pefun4FGpnsq
	7/UasVlP4zd+Edl+hqoAfKFDoBMx6RUk3SkmaEreYrp8HRCjKawMZ6kPRbsEnCchjYhPh4TSbJe+w
	sMFLgYz5pt6qdb69Ccngi2KjlR0uUqDTkbMZzAGEyDQSvbW2rU/W3Gdgnjny5bBXqfJzLZXILUXyt
	+Fd7BK5GjiV3yJTkv23yOJD5eGo4qCLs+Bx9ASpYsEbcKZyQ5Lz2hhrywwhP7J90NjG9g8V3RCmaF
	dkA08F0PMUFNwewouccIs8GGboV+wJLKdn7UQcswQk+zATK5qQBL5JAkaPfCVBiSjFU5/4M1A3Wvg
	YFlgFTvA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRZKb-0000000A4en-2Sbf;
	Thu, 12 Nov 2026 18:15:29 +0000
Date: Thu, 12 Nov 2026 18:15:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	William Kucharski <william.kucharski@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH RFC] mm/filemap: fix lseek() skipping a new large folio
Message-ID: <avYCQdIFg5EejtDG@casper.infradead.org>
References: <20261110-lseek_hole-v1-1-c089c960b846@kernel.org>
 <wkpls4kiwl3ktyu5ekahlchabnaqq45o4tgv26cmrs552ljse4@oczec23ankdt>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wkpls4kiwl3ktyu5ekahlchabnaqq45o4tgv26cmrs552ljse4@oczec23ankdt>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1666240012
X-Stat-Signature: ca4so87aipbjoe9rskh315wn3uw4eipb
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794507331-715806
X-HE-Meta: U2FsdGVkX1+jnyKG32LpcjCueGZ1mYYr3z67/lL7hCHhYIimHQBP3zqk7iprkNlnAsZy6E652H1iI6FlEO1rqAX3CKnuXq4K5FYq7SROPOU+9Kt7SmFqHcpAyua+LopgX49j+lKolEnR9Wg8je6QB1dYAA4PodETbzPtpde86jWQT6P7rOi4ER1FEo7mesHcP3XrKF9ve9RCgnh7ttnRlkO+kGoj/m2mMPJsjTgRE/jnsM4VTYnpQm75j4nrH8urSSaEY+yZyYCT1B2/YDe8AStVYlnEEtxmssjCdKcSVs2/ey7i1l7HvQ1dy7oipXfYQc7b44ZmaovxJiLd5lyZSRTQ9+49SZT6tZjGkVLKI4fid2CbLCl6LeODk05cKDFIDq+2LaBjBOwnH9pcTaNq/kjB7Wobg9ru+L9QO/jpvAnDnbo+EQCopC2uHdkV+Xz41PofcE8qdNaoHtDiregT6GbvdzdqBh40TqsRTaDl4vtMKns7ipH9gAa0lQDeSmuA3hgdQzn9w4OvunBdw/AngaXARyz5+8frqralXQYYVK4g66tNeYCVJ1WC7dzvTE7Xlnxs19mSLLN9cMgo2IOABl2k80UFiVsFnV4e2E6fw4uqsaQi8Zqo7R0e/lQRr8N0gZHROeotNDWEfO8BeVc/OhqRy4L0VEJO8iBJNWCKCxarnzezQcg8PlPg5g/p9b3Iw9UUVCgXKQfhi91Z4n/QYv06YLehz3dxDoR7i58mv0kyZ4M2hcKK4CKMjacDrd7KGIwOM7OCfBOlYWCsSqxm/AqpyUQS8hj/+yjnDb1v38kP3Z0p7THlizayZaiRvZQTzASFtvv/iM9UgORyf+IQd5ic6kMde4k0rWuuvsjMv0/4764jgQi8hOq+e4YXe0GtJpJYuIDyHN3uWNvdcI/aCEfPvvSBFNaznlULWc4s/9RgRGcmXn4aacHk/8qd/vO9t6JuFZQ5Krl2rIF6Kvs
 PPTnxbvE
 u5Gp7MWouNYxIGVXQUgMOYD82+J8Wp+Jk9UPu0VjUNQrqPxqCA+2vnwnnkuX45fz6SLxRIMOm/9JFfbSuFasmcfY/4jfaa178EKw+Y+qma2rWbqKx2z5NqBPxWeNfvQ6PDbVTIG3QeBcxZWt0OlJLm83L148k+TUMJMv/6wNpRrIy+E1+KOwsDDM9TVG1JUDdIkgwtdMChCHjboEUEf+SmQjMARZycGX6pUKIkSVJscmG1inzkx/qZ8jn7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:45:45PM +0100, Jan Kara wrote:
> I just find it unfortunate that we have to play complicated games like
> these for such a simple operation as sequentially iterating over all folios
> in a mapping. And it is not a first bug of this nature trigered by
> compaction. So longer term I believe we need to provide saner apis
> shielding pagecache users from these nasty details.

I think the long-term fix is to switch to the maple tree as the backend
of the xarray.  Then there is only one slot for any folio and we should
be able to unambiguusly iterate over all present folios.

