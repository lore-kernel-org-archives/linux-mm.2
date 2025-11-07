Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFBDCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C010B8E0009; Fri,  7 Nov 2025 08:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD84D8E0002; Fri,  7 Nov 2025 08:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15908E0009; Fri,  7 Nov 2025 08:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF198E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:37:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C4944B9BE
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:37:50 +0000 (UTC)
X-FDA: 84083913900.26.A3AFD91
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 90A52180010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:37:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762522668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4fW4ByonwXrt8CCQV5evrDbXfC526l8bUSvhPi4LoTk=;
	b=NNdXeWnoR9kPBPSAA/ZCdsl5bxsnTQhkOwoUYzrvgWFEO4NgwGtb01OHiOyvgK/I0EGirU
	h4OhrRxKKponzgr0P8+vPagVML1WTWol/mhBXt9FjvYblCrXmS4kljzTlbD7KTxQ/Uwr6F
	1RSkbgabeAAtJgIXbB6XULWJLuBMmzQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762522668; a=rsa-sha256;
	cv=none;
	b=higOLwgXG6AnUNMy3Hl0bw0Wqez6M+uD5AgcKZpIoJk9dfC74MRiDi0sbZ4CqIFjQTVXeJ
	8B/2xCNcX+pe/BiwHoJiFb1JHgR54+Zo6DlEo6kjwiEq4sdEt36qc8RduRxG4ChYULyaYq
	+lRLQQOeXA4Ej8BLzBZPXf2/pAIXVQs=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6E374227AAE; Fri,  7 Nov 2025 14:37:42 +0100 (CET)
Date: Fri, 7 Nov 2025 14:37:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, jaegeuk@kernel.org,
	chao@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <20251107133742.GA5596@lst.de>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com> <20251014120845.2361-1-kundan.kumar@samsung.com> <aPa7xozr7YbZX0W4@dread.disaster.area> <20251022043930.GC2371@lst.de> <e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com> <20251029060932.GS4015566@frogsfrogsfrogs> <20251029085526.GA32407@lst.de> <91367b76-e48b-46b4-b10b-43dfdd8472fa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91367b76-e48b-46b4-b10b-43dfdd8472fa@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90A52180010
X-Stat-Signature: 8zj5sz4hpxnxe1omxa811g1ooh7mipdn
X-Rspam-User: 
X-HE-Tag: 1762522668-416296
X-HE-Meta: U2FsdGVkX1/Ty+eoE46xHjlrIk33Zrrg1YOWavYOOeG2Md8/ZRB/D26mKNjDUlvxYXww2DLsS0s/n0Bbt3jbxqxIOXQFyJoMI8pBI3odgejY+yPeBc2R621dvNpLOPQNOgT5srEAhl/IyGrIZv2JMo1ELrHoiOsqeR8KLH2aAt5UtA73I1xpnUXiNykSjVVo4zmXiN01ND4A1DAzYT2xgAy30rj+D3PKdav/HlDKb/XG9+DuBGjN0nmbxvXaSDCB0EA4U30DCW5avwuCt4Wpz8+MbUniDvhR/NiUqCGaIXTh0Hf/sMlqn2CSs3NNFwzW+3ba9Iirr4k8f3pwcjLn5OkmuxldyvezMhATJU+UQbKcq6Mjbbf+V1Gh5po8O2qWQgVTk4xswqdPORQFkrTIP1AkI32f75cqErGdftVZkXrcYDNOY1F17MBg2db86Lwamd24bLBbkrfEUJa+ukmxetc7NpErpa+pYfmOypPmVQ02kGpiNzpiP+KvUjDqPk3o9MM9jQzM/ghfqtOSN/TU22D2xiBDROmMM/WnT1KOW2uOMCXEl40h5Hnsoaz5tMTOi6u7ZnW5ZrS1BVcR0pkUxxgljsJmePnx8nrZ6xFwo3p/27/a+H4EJJfLtL4wFepGjQes35W7rJILZXjoHH0Pq0q96ue6fMLOUIwsSdD25lKEqY/NdMCx7lXDsHLX/vnjjCvYzSKqZ1HXv8emTX254DI1Dc9qN+5u+f1L2lsI9kUq0g6HhM2q2lClZWgmhEAKPU8kWdyRa9VlNl+3fnHW99AwgziStEVH1kXU6lchZpCSR+wc3JBCkcDpIjqa/YLoDj0+tIJOdHT2C34jZF170gKIMIuez45GDmaVKT4BnQ17E54EaiL7UfbjPtE7iz7Yf1eFTu1p3uvMLeSMlNyS73PbCAG5aZNtV4yy5Dyt7dzOE1cl0AZgMxDpsVQ3TM/XUF43o6h7xkDGhbPOewd
 SDv37hCv
 6GMuc/csK9/3c5V/nnbCE4HUr57eF+F56tLrl7uOIji6pHFvzDnTKAhu9ijdL7Uj81oP+BjMyY94CCi+0u/91OmiLELDwnn8InQNT4gOz/f8oUJ5GqKSLf2SA8NDC0YxU2RswCPxm3TEREqwPnCHi5RLssPU+Xwl+V3D0vRvyatogVl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 02:54:42PM +0530, Kundan Kumar wrote:
> Predicting the Allocation Group (AG) for aged filesystems and passing
> this information to per-AG writeback threads appears to be a complex
> task.

Yes.  But in the end aged file systems are what will see most usage.
Fresh file systems look nice in benchmarks, but they aren't what
users will mostly deal with.

> To segregate these I/O requests by AG, it is necessary to associate
> AG-specific information with the pages/folios in the page cache. Two
> possible approaches are:
> (1) storing AG information in the folio->private field, or
> (2) introducing new markers in the xarray to track AG-specific data.
> 
> The AG-affined writeback thread processes specific pages from the page 
> cache marked for its AG. Is this a viable approach, or are there 
> alternative solutions that could be more effective?

Or maybe the per-AG scheme isn't that great after all and we just
need some other simple sharding scheme?  Of course lock contention
will be nicer on a per-AG basis, but as you found out actually
mapping high-level writeback to AGs is pretty hard.


