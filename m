Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB8310854B2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 22:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2925F6B0088; Sat, 14 Mar 2026 18:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216376B0089; Sat, 14 Mar 2026 18:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122F66B008A; Sat, 14 Mar 2026 18:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFA6A6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:27:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5834B13BE66
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:27:56 +0000 (UTC)
X-FDA: 84546107352.07.1445484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 967AC1A0005
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:27:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sjn+o12p;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773527274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsRDSGMBdcqy1a733cmDri7gtj+ClvCP0c1sjjW79x4=;
	b=NNTEzYGezG6tvhHTLOxpR4IDCfD+L4r+b3v2LxOfwT9Ewsq/dveutj4FlUY8sQ8stlTr6C
	6mJcLJRFRGRXC3WCR566P9wrGsBK/Ma+tRVd9D9UfF53uMGM5yhDh9KpOrNoPsMlgvnDtM
	geD8VEctlHYjkxP8bTlm2z1wscW/cZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sjn+o12p;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773527274; a=rsa-sha256;
	cv=none;
	b=7iL+rai8q9rAaM8hqRUJ6DnzBdGe+P6QvT4FbTOlzlf/5qP9HzIYNZ7vAMIo3IIGtEE7Q7
	TUBkrucR2oTaDWYZd4qBufK9zsWRENdpdWykCmWkemkTz3hUjBFJc5t4hqdJbi9Icn13jA
	aXFkHw/M2viYyemakyJcibVRVcODaMg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37D8F440C1;
	Sat, 14 Mar 2026 22:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECF2C2BC86;
	Sat, 14 Mar 2026 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773527273;
	bh=X38QD4+JyXnbtGHLHFF9MNkaPpIwI09kD0O+bLsHuws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sjn+o12pPgun6HUvrDrwzcQoQeLDcZZpgkEXZ7PKu7/yBSWp15sPVc5oqNahiQ29K
	 DkoMISlpj0nlBMuSRWVRb8qboVs0ApNzzkzD/7R7dE9bqNEjTaugZiWeqNh7XInBbr
	 mj9J5LKlZUITc3HqFOulrx6blNpkLRXXHfKpwR30=
Date: Sat, 14 Mar 2026 15:27:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
 <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, Eero Kelly
 <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, Adam
 Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add folio_split() and filemap_get_entry()
 race test
Message-Id: <20260314152751.101b5d04d3753f75027b9cd6@linux-foundation.org>
In-Reply-To: <20260313114037.3593642-1-ziy@nvidia.com>
References: <20260313114037.3593642-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 967AC1A0005
X-Stat-Signature: pg8jn39b9rr79zgt57fdw5p9b7351xh9
X-Rspam-User: 
X-HE-Tag: 1773527274-39883
X-HE-Meta: U2FsdGVkX1/vOmhmQkBSmbD1qLgS4fAFQufY6M3zJ5sJhj4uvaKR1du8AUsNv+aycLmmYhuReftg10FLC6t7FVxKFzn4WCTzjx7YdFn4AWo9aMQNI7FFKgdX8DpBrvUzM4wSMt+oD84Qmbn6rk5LbMfvsCh5ZtWaE4qSRF//0XzUEqavdFuVOyyDf0ptucgnEziTzJhtyEd7pFCKg4fMlOxNeXsCAg4CG3hEuAJACWq7pRHplOn/G6YbKl8XEAT8OTXtA16PW/HBa0dscidMm3bW0OwVxlrjZ/+nsgiVBuPFBQCKUKHN0s0P9JWFfdPhNhf4qbYlbfusDFuERGLJ3cZ1NhWKzXHzK+p2MihZiNvgjFdqSYHzql5baehF2coYlyhm7/s/wngI+OFz/QgYofOLRCD+bcQJwFX94NOMrAambLU4yns0vyaIZtmgp7VTv167G9RO3HtoYl1HAs9JZdKLG3EQ1N+Bv0ltoNBV/jYapSpToI4dniezRXy4tZ7DevoOdBDCIeLgQlBG/uqAENyBHPCYn4uiMQztREzufnoL2h8zPARxIwTbxxnb3jnz23xs3D57L9Ec9QCTXAQTLWvxek0fHebhpVw1TyDR4zKSOiU18Ugqfh1F2tp9o3qoHBYFJqNhQs2aXRD9b2rPmqEaNhJ+IrxCI4LkPKiR++ebCNjsOlrtuKxRHYGCIIwy7zWIJCopVGlSA0IrEu+hCIp4f2iJ34fkrHhG7mKaafRjUcNehdy+Y7MSDMt+ZUd6ZHlOI+zfzZwlKb26QCrf/NTwC9nwqxCMjJIy8B24IUjUdEtzx4/newtIRF+Le0oRxq5Ot8yG8vJTR2kIQpC8Tn84PPHsV1e8gcxGm7jBO0W/X3AT8PFby7N/2Kw4sem/6na8pzerGwRSKuOPCDPIeELWQwFveFHDuKg8aG7Hm7WjK4KSyKp1aluu7jxbOSxuawTpH4Kcjl1n/KVJgVZ
 xk4TW49W
 fPc6nqbaGfAwFb8EKNXpgInYxWnme31tEMNrcxmhu3TvVRB7jR50NXwaxERCq1BzNG9Vy9tPupslvtOZ8kP7JLI+TZ0l7FOGVEWX3x5JOlOS1n+6xFaYMFx4AdwhqH1rWW7KtL5onPI3d8gdZtxxQ4M+GoSlAB6CQc/lHf8+0uAQRUEwPumbITwMwgxAfjWwVRLUpfWzAdU+TXt/xZR4VfWqrq/i9iQcPhrw902u4JVzDuosb7XgI1URPoLaWZywhJ856rpqAEi3knDhE0984K3QVZgQzmSWabGG5B3DnKp4Ai6S+/u34dZP6RG1/aj8S+UsYQqI71pekPnSae4UiCG36vn0rbezwP9P4PrjbcUF0gxpNVI4yKenYy1lAZ3IjYK+Yxu/eCeWPjH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 07:40:37 -0400 Zi Yan <ziy@nvidia.com> wrote:

> The added folio_split_race_test is a modified C port of the race condition
> test from [1]. The test creates shmem huge pages shared by both a parent
> and a child processes, where the parent process punches holes in the shmem
> to cause folio_split() in the kernel and the child process reads the shmem
> in 16 threads to cause filemap_get_entry() in the kernel.
> filemap_get_entry() reads the folio and xarray split by folio_split()
> locklessly. The original test[2] is written in rust and uses memfd (shmem
> backed). This C port uses shmem directly.

Cool.

> Note: the initial rust to C conversion is done by Cursor.

Hence the CaMeLcAsE "struct SharedCtl".  Fair enough.

> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]

I couldn't immediately find any licensing info there.  Bas and Adam,
please advise?  And sending your Signed-off-by's would be appropriate.

Thanks.


