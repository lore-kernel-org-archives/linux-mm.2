Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCCCCCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 04:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4CF8E0003; Thu, 16 Oct 2025 00:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C538E0002; Thu, 16 Oct 2025 00:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C91B8E0003; Thu, 16 Oct 2025 00:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF428E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:38:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F12551DC071
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:38:04 +0000 (UTC)
X-FDA: 84002720088.13.041DCA2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 467D21C0009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:38:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760589483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAQWpqBi4Y9ARqz/o5TVbnlImi3rzVO7lsHrGTN+Zg0=;
	b=GdLokx9kqHTEjW8bjrKS1O1g3p9SdHm0Vfn4UPbIpYw9gTe0+89pCKk4ZUttx6gwSatFNe
	EI6TNJxVD3m2vs5cH1jal5+QgcVJyzLLuPC67lf8IV/U2OxIptVMDH57MBBsO4oYjUTna3
	7xVwac0qs2xaw44UhyFv0si4E6ysPPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760589483; a=rsa-sha256;
	cv=none;
	b=tEx69X6gmBcGhzc5NNNAmY77KztNy8/0d1pa/fVefzD3e0gvCM6Juk0lRAWRuJtuNGL/Pp
	xf8Qn6hgCW1OD9rq0JL4iGrwIeR6muk/e36XBdwHmf59ddfkr05LJB5wlOD0F7j+9DTzrH
	FkxtJGP9jY2lbJ3UPaI4JTSPErWEtCM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C7DB227A87; Thu, 16 Oct 2025 06:37:58 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:37:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251016043758.GB29905@lst.de>
References: <20251015062728.60104-1-hch@lst.de> <20251015062728.60104-3-hch@lst.de> <20251015155735.GC6178@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015155735.GC6178@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 467D21C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: 51schdbaxoqzsqrak8jmk1axwtajm3n3
X-HE-Tag: 1760589483-826554
X-HE-Meta: U2FsdGVkX18AvAZQl8EWZaSdlPtBU8BzvsNXzpwtFp6cYqaxlbjW27F73yuJ0ShHyYeQe7VWNZkPB+y/blzeayHCb8e+0M1g7r/BV7AMY9owaxjnUAVdzpZVNDfSCYTnVRSEQq+fDGueDkY8x6x7dOf5ys4WYXeJbQFDtux8v3ll7w4FEVyIfS6ynAPBiN8pWuzLfV493VZwvPO9e+2fiFm8jM4UmYVFpJ9omMD0m1ziufcO9B2+bJ7bGmoS0awG3JzF/rRQq5kxhAb0AU9+lHGrpiHsKO+4Idqy8q1MiPh+qGCUcbxHz+AWpACjAEvS6ew7OchuEXAqmyNWyZ4nOwJo8CKcHe9UvZCLUpDpmBDjIh/9SS78lMsLsP6G10YxJfctSN2D8+1tkCeB2skeg3EIqjSXgiZDxI+Ehn0jjc864+UuFcYv/iW+KMzogCeVOeNUSUewx0uRotLOG44mqpmid+t8xn0hZBZyWK182/+ezd2Rp70f4z/2HzKGgzHfM7RXb2nOiyafQIEXPaHH9i0fgVlvVcqAe4FTqvK9ZnMfdu/mJh44ZsZ99lXpeuw5QVtS4EYVYUzhaupmwtr5AruyFbFZhu/C0tYTQ1Cm9HJT9Etqfa0NWfZEraiJz2yZf7NpQQyz7yqTrgyBAqOeMXe9+Myjpmo62ajc6BFZUaJt2koF9JgUn7o8oIYCGVE9lXFVrM6Nks9TPBrTp8WHBWqJc1nY/gGcoXuBL3spBrn4a1KrvSuqjOLUzs6y9LV0RBMPMfC8iawSQFuhTjd+Ueuihq2fKwQP6zguJvdYNJnXbt+a9E7PMgyysC2ilrWwRx3ilMKWDSr4hSuZNdmU/Ox+hOVD3knqgP0+NQXUXvp+QHHaG/DpSOXDObxplbmeF3MdU/DrLdb5N7dIkAwXPjwCJgKZo05lXea/IM/vn10tNlzi/CamphygNiPtCuBKyfCmcJ2xxPGf7aNa3l5
 AW6lq+Lk
 K6wYajEpOThXe4caXnHMewiMt466I1TvCdgPLxrF+5coLVgMbxkpiDHwFl4TlaVcntesGr6yHT4QqFq7EbOY2c7ToCYcEd+Frp8ikAtawoTBhN06qfd0eUtNeYOdguB6SLrBJ91ldXnx2GcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:57:35AM -0700, Darrick J. Wong wrote:
> Should this be some sort of BDI field?  Maybe there are other workloads
> that create a lot of dirty pages and the sysadmin would like to be able
> to tell the fs to schedule larger chunks of writeback before switching
> to another inode?

The BDI is not owned by the file system, but rather the gendisk, so we
can't just override it in the file systems.  I still hope that eventually
changes, in which case we could revisit it.  Having a tunable sounds neat,
but I'd rather get the fix out first and then design something like that.

> 
> XFS can have two volumes, should we be using the rtdev's bdi for
> realtime files and the data dev's bdi for non-rt files?  That looks like
> a mess to sort out though, since there's a fair number of places where
> we just dereference super_block::s_bdi.

Each file system only uses a single BDI, which in case of XFS is the
one of the gendisk that the main device sits on.  Only the bdevfs uses
multiple BDIs (one per file{) and that required hard coded hacks in the
writeback code.  I don't think there is any benefit in having multiple
BIDs for real file system, the parallelization work that just got reposted
works inside a BDI.

> Also I have no idea what we'd do for filesystem raid -- synthesize a bdi
> for that?  And then how would you advertise that such-and-such fd maps
> to a particular bdi?

btrfs allocates it's own BDI.  And I hope that we eventually move to a
model where the file system always own the BDI as that would simplify
object lifetimes an relationships and locking a lot.


