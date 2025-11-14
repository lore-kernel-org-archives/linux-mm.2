Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786ECCE7B08
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBFBA8E0007; Fri, 14 Nov 2025 08:18:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96D88E0002; Fri, 14 Nov 2025 08:18:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4388E0007; Fri, 14 Nov 2025 08:18:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB1A48E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:18:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6899F889BC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:18:20 +0000 (UTC)
X-FDA: 84109266360.05.6C23526
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE676C000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:18:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl0AhYmQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763126298; a=rsa-sha256;
	cv=none;
	b=rQzA8zvQEbggDL42wbLkZWh8lel0xvvlyA1hKND4opRRVW6NEC56kzuSth+tgihl7P+gKj
	3NadsTPrFrQmgDXsG57D0FCUGXB9bZOhJTKrip3g8wvEkXOqkC5Q4LKSIqg86vc2OC4f+L
	9Nf2oK1KCerEIv9P2pQbmBqi20nJ8K0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl0AhYmQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763126298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmVNfXV6oyQABFYC6/ma7wXURuBWKP2P48qcOd0qnCc=;
	b=Yc8TnzaIUh+0qi8BZflLcPEJ3wtYGHwEvygFOV6jstm1a/QhvhU7TDrO+4if+EPx4tsdIa
	Y4mPYDPjhkK0jHJ/gprqdfMZ4ZLNzW55+GfU8ijgwewEeD37ge8V2B2l/WaW6nrym0BblX
	a+n0llOcnF/22Mclpyt5oM9LdZtpMzs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hmVNfXV6oyQABFYC6/ma7wXURuBWKP2P48qcOd0qnCc=; b=dl0AhYmQpaaVm92D43c89MJTqg
	15iItLJULDTf+hYKkhp4788x6bFlulpBjbCa+UeFxstvvcOvD19ohAhWrAvbv0MpmfN9dSI3JJ0gh
	RRFNwM5nkGgTaPzFRGKmWlOPTxzw2EPPdSSKURyZvuaDh/u5caoheTcBFwHmdVpFD2VJn0YlpGBR3
	iF9f2Bk8Yx1jygcopP1xvAuoGcK5kXI6FbSqLaAHw//n5e6Wo7vGXJbBBMy2nGe4dLf68Zgs11TO0
	Hx6LnTivTI4+RWBwX0FUVNgCVqL8nEvWlHKS/OK9PC4oY9SbAQh9LQOheJKSFtRiLmytwquIFBVUb
	4+XIGdlw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJtgq-00000009Mvx-12tt;
	Fri, 14 Nov 2025 13:18:12 +0000
Date: Fri, 14 Nov 2025 13:18:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRcsFF5eCCsx5kYh@casper.infradead.org>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <aRUCqA_UpRftbgce@dread.disaster.area>
 <20251113052337.GA28533@lst.de>
 <87frai8p46.ritesh.list@gmail.com>
 <aRWzq_LpoJHwfYli@dread.disaster.area>
 <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE676C000E
X-Stat-Signature: 6k6wys74nng7qaquphx64a7ahretqcjh
X-Rspam-User: 
X-HE-Tag: 1763126298-169033
X-HE-Meta: U2FsdGVkX1+t+1D/dYQJjzImPw2HMa/1ShthQCLhy6yV/ipyY+SMp94OnlnUbLI+onREkHVtHCkPq1753VHc7p/uHUqp16esic+ztjnB/b6IfkM3vZfZo+wB9ZMjwsctNc3qEWXng2qlXYBH1bE65YZTSeOFFgkl26OIOi1Ftp49X7i/nkTRIErEXSNfwT3Hk2se6kxCg8LiFA+zea4eO/D0rN8h++Bn+wAZvi1mXnYdJPo0WQ56st6Zt7l4aRufGylQ7T9zj7ZbxyWTZ3aYmB+Fo9v427wJvue9Dh47ZZyzZ3SBgRqHNJ3RXKmb9JCak639qpxPw1iAfvcc5ZAmJQIZm/GDS6Bfp9zREW0M8bmW6fd5w3y5Fikdpi+fBO1M3Qpty03EY2Lj363/SlXvq3Qn5ojUj6QN8yZxg3+WWeiL9mS7aPTgtg/gXVof9BCMf2lyB0hPZ9pOnWRD0JCEkiH3h97wHIKYE5nsCHBG2Kc7JBLEIKFIrhRSfwcB4ieNMxDEDEYSoPhkd2yzHdUSqotXuFGVUa3/IMhbKqQEZEnE2IHUXT6gCWlbZOy5/KBz7j7Wkub9uGm7WAhXV/rUg6bfnEi5Rd9AJaQtqdkjSNjCfbLfXdbHvP6HN5Tbc25P5fgxjprmGSLqLbGZ58QmUzTxST2SWLirfoKZcOqYXFnS6NNSgLmTNnCzBGAo2ZjjehldrfT5M89cQgBappoO7dlKhZacUgupMvTUtzAjbW/Lm0Ftmm0JOTDEqNagzUipgzh+9y3tTt+viD9Ye0Fcbze8+f8YlWGlw74eRHPI0T4eQdekeliblA6vZoctU1xdJkdV2oo9ccnlwYPCVMEEW4l4llaaibV48XO8TYHs8KlSrtnvhvwFc1qseO1KfwsK/YnqLFK+EbKDhqdt7yAZvQBCW2eHjCUcNAjiNRiiUVBWrGelsuPuA/d9IMiRaycofnw1KdmODDq5J6WyTwX
 mynLQQNz
 l2kzEQ2zGhbjQet31iXH2iOs/c5M2vcLYlv4dU2pbLBowRkkGrn+vxTfZrZ14+/3wNHNBHQ33eWz7eXUgY+aC0pkSWgs1iOW7NL50NEvrThZAC/o7wtltwv/1tg2Jpl0iWMBOhDPFEpGZkQnR8WZlPmR/TbsWd6CKhAZyUvDowwARPwAvYd4AnV0kqVzNSWZm8ojHJC0xiXFRNFjpznQ3XIlYHhEqDR3w2PsAutmFeriaH9s6tkN4zwGNBff9NTlEDbRcQpCbh5YgKuhgMlhIHTB3Cp6Dp9Ila4JuZLSDFDPD78VB1qu7nh7yBlZshccAraee
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 02:50:25PM +0530, Ojaswin Mujoo wrote:
> buffered IO. Further, many DBs support both direct IO and buffered IO
> well and it may not be fair to force them to stick to direct IO to get
> the benefits of atomic writes.

It may not be fair to force kernel developers to support a feature that
has no users.

