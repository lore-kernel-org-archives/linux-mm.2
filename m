Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E373D1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592B56B0120; Fri, 20 Mar 2026 15:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569936B0121; Fri, 20 Mar 2026 15:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7006B0123; Fri, 20 Mar 2026 15:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38EE66B0120
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:01:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4B3D58625
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:01:14 +0000 (UTC)
X-FDA: 84567359268.18.0FE0A60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9AF88120018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:01:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILLXPG4y;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRzwBVB0zy+xeJPrWoPBH63WlZlvsdY9Se2uWMFPHws=;
	b=qmq1yz8EaH+T8mywC/hmIuo0n/geK58g+HE64oNwdVLFILuwhONL2CKHXB9afLT100o6zw
	xxUeF1WO0VSdKk0j78xBKVxTuqzYO+lyxuPmN25M/AlPSytqlrVc6esOx52nrmMINZblAw
	z5+FZI9BcUBOci8qGAFyLQtOvvr1bow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033273; a=rsa-sha256;
	cv=none;
	b=S+HrN96ZFNl/CI1XgxGZkfnTkw/ainqzVzGcq/VTcgxq26wu1eQ/pnE0ZG2RFnEHKmvI/r
	NbrO/VCwbUtxIcToJS96n/RW83kxSpUd/ZLgMd4eIxV2ccYQEQjbpBouZkBWtDjuxiXbdI
	rz7iOuDV5l4UtfBExiI+W7tnDRVAgfg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILLXPG4y;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8403D44062;
	Fri, 20 Mar 2026 19:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07F5C2BCB0;
	Fri, 20 Mar 2026 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033271;
	bh=IRzwBVB0zy+xeJPrWoPBH63WlZlvsdY9Se2uWMFPHws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILLXPG4yVPR0GDfMIEVi2nln57yMPmACXQ1ivP8/+4v6ApWNPyZQVwcO8Ue5pPxiS
	 WK47pP/CTV5GnZSDg9N7cRjDlm27drFIsN77fBPEKn69UM7rB3USrjXIpPU2eOzGve
	 Nkqwyv6CkOKOeMknBTVOFTUl8fBFKgSTkggkKbQSAoA8NV0Wo7fW0+IGGcJGZS3z5Q
	 9+W0rb/lNybrKvjRjIS1QOugOJs5rOwU2otS9o0FsUQBTvRurI+3cnIanWccwlJfP/
	 t2BXlSjTo8PA3OZzTO5QTr1SoETkBdeDcVadNFWdNARo1E/k++QeAE0RT40ZxwdQBF
	 7+sGFqHZzkj5g==
Date: Fri, 20 Mar 2026 19:01:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 05/16] fs: afs: correctly drop reference count on
 mapping failure
Message-ID: <995afd70-d7c2-42af-8012-589b3319d31a@lucifer.local>
References: <cover.1773944114.git.ljs@kernel.org>
 <018cd0d8b2dae44de6d3952527e754e52ef02da8.1773944114.git.ljs@kernel.org>
 <608ba54c-f19e-4e27-8142-0870f91d6514@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608ba54c-f19e-4e27-8142-0870f91d6514@kernel.org>
X-Rspam-User: 
X-Stat-Signature: a3sz9z7itrj5toop9qhddmk9bhnhxu17
X-Rspamd-Queue-Id: 9AF88120018
X-Rspamd-Server: rspam03
X-HE-Tag: 1774033272-902514
X-HE-Meta: U2FsdGVkX19ox6nogZWhSx7x0IEK1PGOKKyB4K/0dmGQe0NOSmnN8L7i90njAim2952vyq09OtXumlXcJ36ZHA4AGlXYEhg1umhxVXadPHKP1wzI7mh8dGXnm0cpBtVxz9+3SioV5edaVD0weIhxspdKpdFnvBlCe19FCKtICqSSnJIEnrBWkbMCYatULbInpQLIYfGqwJgsLzEdSmrOBqWvMsfnfKYxbQ0QJgxyB6fw0etJZzQDwN/QbB++nfBLrYNU85/LH5xfYFYpD2TjChR3DwUvZ8Zljfu3HWsngZivdUN9zsYU9uHM5jejq9AzSQn7pTbX2AJi8WUrM/WV/0maNDE1UuyhFU838n1jkf4sG6rF3pYvx/5gLTALWg2GYQKg0H7osB7tsxte/rt55hAIEnbv+ppHQb6hN2ALoAiR4NJvI+XYSUQ9ZiXXgHWgIyTQR4M2bkApzn2g2f/65pE6Yx7gXCHmzWQKcriu/ITRPrjpG+knjqn1+xZBRnXwixPentUpcR6N8UKFQ9DtAeDL8v3Xq7uDttSN9XA84uiD+w0ZXvn5xKlEjuuG/Dv6YIhWk/tqh321m4c2NTC0HBFfRRuIFx/KYZuHWh12IBaTCBrOQmcClGezzpBafdYAmgh8H4n5XPGeJUHbZrf3VlWxZmgaWOWyie5bzxeM0XPXk19QQ8AL2DKYhXf032vxnnV9nWnnhCcq+f8dr1EarFbKQqWdQkwG0hlCMyJN44jVjvGck0SSvstb1LAX0vslTxlX1mf9jagqENu6dQ0DYJ/lH8M0jtMcRBwJJbeR2wi4ovPblDr8Dgvh/q36QuCvTYAvdBTq/RBRbgxSYSSLUEnPpT/reJq9EQ/eiq9ZMH5LjVrsn7fRpo+1dY/JHS9gsETyvLO3AeOBRi3jZi2A7NJmU9L+Jb/9t2zAOoJnnG1uIzq3KCHMYXwXqSByx/EvUxpm7arN1V0RALWApOK
 FZJjGJcB
 CZXNLc5diEt94nmk9qkEKnzUb7+9DNGnK5kV27U3gW0ytJDimp0CUocHV3h1gdVUESvNFdm2zaQ0614f8vZ48SmyAJMRbAo35OUQhWAicDg9+LAM1+WsiHSJ4gCeFiSFBW8vdCFcZMOVlxVD/t1ZQd04tItk4uVvFR4H5QcL5xflzV/nkFc6JVaxjBP5xhw38t+SvKv7NMCL8Z84LRt49yU4T0uwEpg3D/r9IZA7r+OXeD7KfrLGXJsDXVWyUPQDeNzA9hJxGEAacZeXbAD2G0b7V3IG3vw+oYWvRAErzUTZREBVFkHOZfbm9Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 07:57:29PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> > .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
> > of the deprecated mmap callback.
> >
> > However, it did not account for the fact that mmap_prepare is called
> > pre-merge, and may then be merged, nor that mmap_prepare can fail to map
> > due to an out of memory error.
>
> So that means a file can become pinned forever? OOM is probably only a
> problem with fault injection in practice, but the merge case can happen. And
> 9d5403b1036c is pre-6.18 LTS. Are we going to need Fixes: and Cc: stable then?

That'd require backporting all of the .mapped functionality and half of this
series, I don't think that's really practical.

I guess I can do a manual backport of a partial revert.

Thanks, Lorenzo

