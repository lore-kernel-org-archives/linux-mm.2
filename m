Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FEB0CD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 00:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20FC6B00CB; Sat, 30 May 2026 20:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1D76B00CC; Sat, 30 May 2026 20:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0DA76B00CD; Sat, 30 May 2026 20:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C25196B00CB
	for <linux-mm@kvack.org>; Sat, 30 May 2026 20:12:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EB2E161B86
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:12:12 +0000 (UTC)
X-FDA: 84825787704.03.61B29FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C630A4000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:12:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fHOhsAuR;
	spf=pass (imf04.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780186330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYvRVj4ATb1VjPqyrKnbeBCWG0iaq3Bc8et+a/muwak=;
	b=fCEQuyNadwsh/K0eGIgT3aoV+6toX/uwHFbp5E3wm1BZOADVuqwUV/e7IJeto+I/TC7VD4
	UqSjlxcoLzUjYQXdBQ6UN5vKgRP0BDH0UyV2VYELhzu4zGsh3MwhA+6SLIPeK90RgaQqDt
	/odzjCU19P/RaIU+Qo9ajbZBjkuWtX0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fHOhsAuR;
	spf=pass (imf04.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780186330; a=rsa-sha256;
	cv=none;
	b=thi6yPS+iCNhPWK/UJX/BYvs6ufSFiH6O116VFa5Re+a/gyycZXtYDTFy0u+OMBFwShB/E
	80W7Kg4jBFhVnhrs2rjPDhycKZy4tK6Nqf30HC72XYJW07RF+NJmkm+G9e7c9jMKMNVvi+
	oGQVggcWJ+2JbhLYvKBigBSvW0jO3xU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FFDB6001A;
	Sun, 31 May 2026 00:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C321F00893;
	Sun, 31 May 2026 00:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780186329;
	bh=OYvRVj4ATb1VjPqyrKnbeBCWG0iaq3Bc8et+a/muwak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fHOhsAuR4ScpU7RKty78SP/q0nx98PvpFWPIMukzAHEP+/dxNLJI95BYxZOkZRH8b
	 0vvtGETBPj6snAsl5sZla2ANtjpOu4hsZ5T9xZfqKEMyFTJ+hOr94AJt2anvzGK+2I
	 UUkR+VjHrS2bRTK7MRYAYRcbwjVawM7kdJGKgjfyVuHrHvzAsPTa4LYjInu5Z7qURl
	 uNsap2grrmNTO60WkFlgwkIZCj4q1gkDfjY+QhvWLXJjz4UkmrfX7fYLTkcA4ucLZJ
	 K8wxewMF4nOOu52EePN9R+PXM0YUBOJ2WgVAEF3VTJ1jlevVgFJhgTDaF6fDHUvvrK
	 pcE0/tyMGqKtg==
Date: Sun, 31 May 2026 00:12:07 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <aht812OhSPFqIBPK@google.com>
References: <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
 <ahcU5xbVy7xjps02@google.com>
 <ahkl52N3RDcusCNd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahkl52N3RDcusCNd@infradead.org>
X-Stat-Signature: ijqb9ekimyqhyu9xzip86cz8bbp11czq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C630A4000B
X-HE-Tag: 1780186330-582224
X-HE-Meta: U2FsdGVkX19cb9smYEOB6xXDc3x2mAhrZlG7o2OnaPYSRzYOKiSUxIyXMLDSEWAAyvQZeWb4yz7InDRipooXXcAHNK/i3/z3lzZv/5uzwVdN81cEGxU6pVpT+X2zhmdAGTQErDQGPhqNiQOy2bDCTGYyCrqd3clq1RyLOihfARR54ivAUINqoyueStX3set81/XKn6p75DqjZTJIOStJKsZFecTrA4bJwKs2/Z5EqMw4gF1EmX3RcKqpel8DwiYyENqH3x4XI2opBkRhUwMeUqAsJqEtpQrhuTqbAdrfCmGs0h7z/1mE/1DtH/mhwOGrSSU3+mih6dPQ0xI1gKThw2x4x1reqf4Dy+lXlSyrCr3o//ULmgrqyxFSnjs5QeqtlMO4HMHzRvWcE7cRpWh0RduoRNqlDKIxxPil37sSzrWgNQFgw7boSdo8X9y+nAN3ZZbrXJMIv3FrAHU1LIRjHD2HMJBDWgp0e4eSx+nuQ1hTnvquEu7NPjiM4Hug3d8nmg433lznLsvk1CtbTyJMtdMgY6ME/xsNvGHybWOuGmJg5JYTC/TYT12RM1Hbq6b9tVZezyB3P1TToutG1l5E78FPI/AOGrxfMe/wJq9ZuzJlZuGqN6yuDSGHeniJ3FbbPLXyUTBNYeYUcSD5/lnLozzL38t3ZHmQhI8o/AN89jbTwv4WYqzBMoXyMGfmkFMMcPrvGtnwmB6SBU+UrhLZXdby+ZtWQsjfn/An8+IwMmihtb284pRRpifvX9/2vluj5Qb8K2tian/OAAV+3Bv2vYxljXSRiMxbau6SKsqy8lTG7TMxurHwd9Wt+Pkf4seLScB4GWkKNliieVbYvbugl/KBx7Z6a03e23fry2aotWO28BTxwKn2NVMn2i6dHfhB1FS/C5CbaI1WQiAmDQfUio/VRnTcZfGjmnWmP/bILb7Flul+43z8NSNPeVCMplNBXTjm+XY0QaImNb+Qm2P
 k6DGcCwv
 qv4Xa3Kkgykl/bnqvfJ25LCgxhWuFO55CqPcWAYVG2Vwb9d2+f+bE3NMepIRyZ00mllD1xpaEbpoNFLqaZHtNPa3vfmAT8LJ1pnyL0YPAB2JTsIP7z05CtrIP2SPEiCKEEoGerR23c6z8RaR6FcshkK1pRDFNS5KMZdQ7QoxkaiZOuELFmjwX0yRi2AZBn7G38Q47v5JaXF6WOLGWKzHhKNn2TgbupSEMh5Q5g4PobVJ1DyQ4CWP7Uhcb40uTCdkNeMWfMYsHpsQ4GmyjRS0OLDY/cQFGMLa5Bmji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/28, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 03:59:35PM +0000, Jaegeuk Kim wrote:
> > F2FS merges bios before submit_bio, regardless of small or large folios,
> > since the block addresses are consecutive. So, I think IO subsystem was
> > working in full speed.
> 
> As does every other remotely modern file system.  But that merging is
> surprisingly expensive, which is why using folios gets really major
> performance improvements.
> 
> For one doing these checks to merge touch quite a few cache lines.
> Second, devices are often a lot more efficient if they see fewer SGL
> entries.  I.e. having a 1MB bio a single SGL tends to work better than
> having 256 of them.
> The same is true in the kernel code itself, both in the submission path
> (dma mapping and co), and even more so in the page cache handling
> both before submitting and in the completion path.
> 
> See Bart's patch about how long the walk of the bio_vecs in the f2fs
> completion path can take.  We had similar issues in XFS even in the
> workqueue completion path due to lack of rescheduling, and these simply
> go away when you do the folio manipulation in larger chunks (LAZY_PREEMPT
> would avoid the need to explicit rescheduling these days, but that just
> papers over the symptoms in this case).
> 

I see. That's also super helpful. Let me kick off the large folio support asap.
Thanks.

