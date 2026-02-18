Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1BEE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 23:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443956B0088; Wed, 18 Feb 2026 18:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE0A6B0089; Wed, 18 Feb 2026 18:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD9A6B008A; Wed, 18 Feb 2026 18:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3DC6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:42:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3ED51B4855
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:42:17 +0000 (UTC)
X-FDA: 84459203514.21.E964F80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E905C1A0011
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:42:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V482Ob1R;
	spf=pass (imf19.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771458136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxPlQeRdMk8JOjh70O/8u5ycTadfbZDnhc7IuD/dB+I=;
	b=RNPBbCWIY37xN1zniGiCrnSdd6+SE/dh0PfrEyLFeqD4ymReO006TVow28+0Tx9fy7Hr3N
	ss8DhDSDodKFcEnjiqF1/2z6QpoAbtgs8F/VexlMRptXhI5JtWkk1M6gFm2XQpCSsSt/5h
	OGLVDurm9XY0NQ/Lc7OYkTPQDXzVrVU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V482Ob1R;
	spf=pass (imf19.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771458136; a=rsa-sha256;
	cv=none;
	b=r2wxR55YwY/BIHE/6vq2GU78AmwOecOX2/qgGoS66s7U8+pJfFBdv7JEAq3Il0ctvBAXk9
	CkSeHzF0nI6L6LxspsvvQgsBfaCICrxIZCpjDnUpcqd/Oh7AJOC7Zkuv+4lQDKvhmOBIJa
	cNUk+A8MWZNWw+UfXlY7qL3eFtVUCbw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC108404F0;
	Wed, 18 Feb 2026 23:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BAFC116D0;
	Wed, 18 Feb 2026 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771458134;
	bh=wCbI6wj7oxCUGmf8RRxMZeFQ8W8q98rrl9MHtnRP6jI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V482Ob1RXXUzn81PwKknfj7zFSM//p1O8HjqzzfwWdYy1c36IW7SYGt4KfeDAHGtG
	 iKZ+UaU1YzcsbouN6WtYesHztcMAxrjzxHH8+Ld7a0l9Qvq9M1JaXFzmR/Aem9NJfB
	 fNMli9L16D8GygPMO77W3Un9Kd93UzFoP7I2e+4B7r1JGCNuE/7CFpIASwzB0Y7TqF
	 dUEvqViPc39jgHBIDtaxVVXXSCZRcbXp6L82sRgzRfMjSwycsGRFj8p1QPEhY0J2aA
	 TKoPoxozyRhyjSityUtYqM8fbMy9QyobU01DTGOh61T5J4JbgQEtQKjpssD2kaMAOX
	 4dY6Jl5xEvcNw==
Date: Thu, 19 Feb 2026 10:42:00 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andres Freund <andres@anarazel.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZZOSFdL_L_EoU34@dread>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
 <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf>
 <aZUQKx_C3-qyU4PJ@dread>
 <20260218064739.GA8881@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218064739.GA8881@lst.de>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E905C1A0011
X-Stat-Signature: k99e6pu1m1jbt4dkg977eew9ewdeztfr
X-Rspam-User: 
X-HE-Tag: 1771458135-636899
X-HE-Meta: U2FsdGVkX1+J0ig/0OrPAPhzP25+I358qEaaoJkPAMgqJVnOSR0UL/mmubX/jUgW3+1qQAIxI4/TqJcJE5eTipD8eYFcQsgkC4w4EsHfOTHfXIg0tMpY9/zt9lGMk1RBzBIEQ8+A1iYKqM/ZTjD9sXT9KeQ3PBH+o100uKh4PIeb9snUx1108Zu9/akmto8upknIOyG2ICvDnIdDDIVcg8qb0F8XEN9+ktCD8T13ZdeTeYuvqcSBX++zPbc/M9fzlL9GwiujNmepjMKzz5njqDOgpmCGfOK6t3coal4eZ7dUMJYR3TDIlg/yD5M9jhSjKSJVXpqkOntDBbsKPdvaEYDBe5o1DCeEC6msmyrXmx1nZdcQCfYFsRS8+3c1Jw1oiIXWW8Yh0rRmlMItz0VwXtvtibUxQkff8nk3ejazIH+tPBiuinO3cI0zzLWJTCYIuz3OHjlrp9SQdt0H3k92cqzSQcL4IQVSCAwDkDgL+4bxUYqeNcJT1cqm2lS4YBUdoNBvSdg1fVYWE8xKmfExJKIlIPjFcyHTcUILULcPK8rR7i7emNreX12N7muR+iyOWt5+NX/21GmharIdtNKlcDzUGiSxxNKrHwESyaA04Xu1yco3qMiYd6h0s3YKBUpnb+gORBrrBRBSAw3xBC7nTYO9DBLXwz4ECC6qjoOElqFiVaZicbCZ9NqYcxR6ayCv7JkWsJ9Mv6UQNPGrhswq2OaV62iZawmH77KCvIq7ramE8FiGVg0xQVy/lPDdEejcP/MEG/vh/rkRKxiI9yCeZfumKx1W6EzpxT3/oO5zj9NOcvSqzRHsSeatY9GaCcZDofiFrLnxF8xaOOr+z2tFPG+gsQkOlYdUoO0G6Bj+J2V6Hu6LCWGOBZolRcvq15xmo2sr0wOKe2Y7+R9V4eJskJ6lgP14EbJAVXcODTz3d5EYZ7KXzvrFkwvrow6emlOmmIRXxhyFeqJhRHozJMc
 myypbTno
 jnXQdEuwn6/z4DrP6xV3D7hYtxDiGCY03eX9WyG5bym5IDSGz3soIH9eZEpYxcPYSNCQ3VRk0dRgDXS/Tr17K5f/9lI1oBI5yYo9VCw1kwwS87751mGCdzYIZDJakn6CfdiTrC6lE/NJV5aH5PjlFvoYY6Reg2C2bz+E0t2EhPFuvApz0NE9sfN7qkGYG/XtBr9J8Lkgbw/2+jwtjH9sFpbZZRr883d6up7dhRNEVx8QpyYARbRDXdOZJUnK7fGB4KQ3uUIFeMUhAfQJOyhYsqrsP+owOW53zQagceiHMH4vO/ZuswGvnR/t+NzZz4x6ynJMmnVmfqjnMtqjm945NFPCNMIOGzdarHIRk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 07:47:39AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 12:04:43PM +1100, Dave Chinner wrote:
> > > > > I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> > > > > 
> > > > 
> > > > One naive question: semantically what will be the difference between
> > > > RWF_DSYNC and RWF_WRITETHROUGH?
> > 
> > None, except that RWF_DSYNC provides data integrity guarantees.
> 
> Which boils down to RWF_DSYNC still writing out the inode and flushing
> the cache.
> 
> > > Which
> > > wouldn't be needed for RWF_WRITETHROUGH, right?
> > 
> > Correct, there shouldn't be any data integrity guarantees associated
> > with plain RWF_WRITETHROUGH.
> 
> Which makes me curious if the plain RWF_WRITETHROUGH would be all
> that useful.

For modern SSDs, I think the answer is yes.

e.g. when you are doing lots of small writes to many files from many
threads, it bottlenecks on single threaded writeback. All of the IO
is submitted by background writeback which runs out of CPU fairly
quickly. We end up dirty throttling and topping out at ~100k random
4kB buffered writes IOPS regardless of how much submitter
concurrency we have.

If we switch that to RWF_WRITETHROUGH, we now have N submitting
threads that can all work in parallel, we get pretty much zero dirty
folio backlog (so no dirty throttling and more consistent IO
latency) and throughput can scales much higher because we have IO
submitter concurrency to spread the CPU load around.

I did a fsmark test of a write-though hack a couple of years back,
creating and writing 4kB data files concurrently in a directory per
thread.  With vanilla writeback, it topped out at about 80k 4kB file
creates/s from 4 threads and only wnet slower the more I increased
the userspace create concurrency.

Using writethrough submission, it topped out at about 400k 4kB file
creates/s from 32 threads and was largely limited in the fsmark
tasks by the CPU overhead for file creation, user data copying and
data extent space allocation.

I also did a multi-file, multi-process random 4kB write test with
fio, using files much larger than memory and long runtimes. Once the
normal background write path started dirty throttling, it ran at
about 100k 4kB write IOPS, again limited by the single threaded writeback
flusher using all it's CPU time for allocating blocks during
writeback.

Using writethrough, I saw about 900k IOPS being sustained right from
the start, largely limited by a combination of CPU usage and IO
latency in the fio task context. In comparison, the same workload
with DIO ran to the storage capability of 1.6M IOPS because it had
significantly lower CPU usage and IO latency.

I also did some kernel compile tests with writethrough for all
buffered write IO. On fast storage there was neglible
difference in performance between vanilla buffered writes and
submitter driver blocking write-through. This result made me
question the need for caching on modern SSDs at all :)

-Dave.
-- 
Dave Chinner
dgc@kernel.org

