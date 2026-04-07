Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC96FB5190
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 05:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345136B0088; Tue,  7 Apr 2026 01:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7036B0089; Tue,  7 Apr 2026 01:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147F36B008A; Tue,  7 Apr 2026 01:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0085B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:19:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 859C41A0664
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:19:26 +0000 (UTC)
X-FDA: 84630606732.05.B31D056
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id E703D1C0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:19:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GoQvE2vM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775539165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYfX0e0sGJA1W1y/i1C2RTFkobNEnqp+InsvttluQ8Q=;
	b=RJ3fQQQZiBI0DWYCSAILwbkk2MIgXzG9xzjg2gJS33jzcNUu1NfzpnqA5olWDWL4ZrtqFP
	AYrkwVsN8wNp1Q3PaC5OO28DY4NVCtmamTqUU9G9L4u+NAyDSY02ROSrFKb3DeAuV4jUuS
	AgYhB0Ca6g7TG93FPnX5f2e/X/vT3NQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775539165; a=rsa-sha256;
	cv=none;
	b=OTsPq9e5zg03U3laopr5eNlw1NaH5EA1z+R9XbjnJHL7MS7aXtm+0J2x9sHGe7IrCvmVDh
	i58Dauc5sE11G1FysqN715ukvXQaQgJ+zFy9vBzg0ZvmiLiNE4ocnIhzqvjp6CtAJOvyE8
	gmZPrSuBUxgMUuLrnT6T5Qp4oBuzOAk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GoQvE2vM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kYfX0e0sGJA1W1y/i1C2RTFkobNEnqp+InsvttluQ8Q=; b=GoQvE2vM5lWJEyexT/Xn4xo36y
	Gy+icEYkiOc/xUgQBskvd6d1swvJCsZr2pKip8TOFGo5MO5q9koV92v4XQa0CPz8gQgsYxJ5Tkb+I
	qOAMmT9CNeMLjzInKOKN2JNkC8GEenLnMkFniRPLOsaEugnrRkjW5tDsU/m5V3Xj69sy5hEQB8lK3
	FnQ7W+dbwh0AoPHPigt6T0ir468+a4g4XuEdV3upK+oJ67JMQgm38tN+BPL9q6itc87gyLcgxxoOb
	UE37IzYi+U0Qlp63i9gyssVJO/vs/WIOCuaI/4v/6hQxySnSqHLj/x4/+cGC/BY+09gibVg3J4NOF
	CDuAQLZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9yqK-00000005uGR-2fk7;
	Tue, 07 Apr 2026 05:19:16 +0000
Date: Mon, 6 Apr 2026 22:19:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm: add atomic flush guard for IOCB_DONTCACHE
 writeback
Message-ID: <adST1EjXCDKQxauf@infradead.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
 <20260401-dontcache-v1-2-1f5746fab47a@kernel.org>
 <ac3-SU7BElHJVCEL@infradead.org>
 <629f21c6591903512eb2f3f3c4d6b14a9ac7b91a.camel@kernel.org>
 <adNJZBXeJomWmhdf@infradead.org>
 <a84788c9cb25deb928b126fc9368ab8e4e110deb.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a84788c9cb25deb928b126fc9368ab8e4e110deb.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E703D1C0009
X-Stat-Signature: 1s6uhkmk3x3h3odijezg8eybx763qbc3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775539164-568258
X-HE-Meta: U2FsdGVkX182CfAndqaJP7HABwu7RdgjWJqelEPB7uFjLrxJx7YeKdWybg5q++gk/OKZS98cRz5Zutpp11C6HX2jxhQTNSTGP3+5L1KiXrDtZNbuHCmWK6/h2EYCoaK/XQJgheBSOII0TNHwdTBcXzdn0ysCQApqpKQK5hnOWqvSeLE5jiDtAdpmFlZyluLHRBdrcI8jx4iemPT3fGH2DoZrBTG91XDdfuCx7mDO1AeFuQU0u2iF6ZjSw02gTjIHjPfsOGk5xaJdKODoTVy4VlhNeb3icDhztwwyu6+ei9S3SminM5nLLJaeVLPp7LBhJ4PcyeWXfLf9GTJdtcB2Z+DtS9YDBKMDTEhi16wYnMZaZb7vY6PBY4mmRxrCO/0r9JbnxgSFfJGqKPm3oN/TBCiVxEb0g9tAupjK6aRsJrf3I4i4R4a0hz8Nhm7MS15a2i1JR7he2Oj3HN3qs+9nxdYfC/HfJOUTylKxlbs2zI05N8JNxyX4lj7Z6KQ39gA+2qF4zcDE/Xq7oPmNGBjdojYC3ZhIECwsa/sYtG2VvtOt8/sToFLmg7wkQmn8ilCL0cvMycfI4kwVju1xrNVx9WazdFnwg1zU9QgLIvXz2gDigMdUOF1X0bVexPsBPjK7SUoo3vq13pU3AoC8kYbai99zNj+UJf5a8igV1yRLht3QqJIx0Rfh3kQsaYRLZy+8U2Tp6NWo2x5aQl/LUg+3OdmsUfr1YXNM70NbrXeujmC6f42+equiciC1YR9VxTDkqL7I5/eEppL0fhOKB7zXZdLrS3lRduI9z6v/AJnBHzof+nXDP8iHCGRRNNbulKh9dCwjg/RJgsFsW1dGO671RSMkZLEkuP8PXhm7bYYJwlzPRtfHVr88HJ3d/RKd0iXUvX5UQi5Sp5bnykszm8xtootOpukHG2NTFxo9Zm1xFjB8J6ag2dK0BDLwBGy0dnACf3rTZix3gOrFXuIc3aB
 NyZBYMqT
 LpMeIf4zWKpmhwxNCn8BlVOecMjdshDQcrfnt8ObiCRAf9A7hhBln0lE9bM7//5cFMOrfa7o+Uq5a5G/OxFvg0IKgL4ddMNg1zj53PKts53Reh7XsF04dEtTyUN4tnKQ0MmWxpJ3D0XzguFLKAtnZR4L1miGMJ41ygtIbGqcAn6nFjwBtpmFEGvVPZfaB6MmcwnNFbblvlYgqKomBxzfj8xJHsLFV6OA8uObL8q/cbi0ps6pC+9IxKjTr6Bg3Xf5sWNhznrq3ShqLgGr5M0BvVajfIKd0p+bEPxqQge+GZDNWHCiDcc+rG+hOUKs+Jvnq+WWa0OhoeFHXVMH0nG43Td/8pQyQ+cu1d+SwruZ5KXqn/ijjvU0w5UbcZxYhAYYo/qIfoleLwPutd4vjdBma6pwtFAuRbqHPRvKIyOz6PlZQim6BxhFV+wmIPvdb3Qiw9EcKwuJ/DTiXvsydGL1TlHPPaIG5MHxS1eWQdDEU0RvvEq7NEJyAn5EGc/J8WCWWtOgDxiLgzGJt/GcNErW5F5ZCw4BahNdkx9oZ1iNIx69JnNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 09:32:58AM -0400, Jeff Layton wrote:
> > And that is called the writeback thread.  So what we should do there
> > is to make sure we queue up writeback on it for each dontcache write.
> > Initially queuing up a wb_writeback_work for each range might be first
> > approximation, although we should probably find a way to just increase
> > a threshold if going down that road.
> > 
> 
> Ok, I like that idea. I'll give that a shot and see how it does. I'll
> note that there is no way to specify an inode or range (yet) in
> wb_writeback_work().
> 
> Do you think it's sufficient to just call something like
> wakeup_flusher_threads_bdi() after every RWF_DONTCACHE write, or should
> I extend wb_writeback_work to allow for doing work on a range within a
> single inode?

I don't think we care about what exact data is written back as this is
not an integrity operation.  So just waking the flusher thread sounds
like the right thing, but we might also need a way to communicate
the higher writeback target.


