Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8F3C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BCF6B0161; Wed, 12 Aug 2026 11:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3130E6B0168; Wed, 12 Aug 2026 11:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C936B016A; Wed, 12 Aug 2026 11:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E927C6B0161
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:06:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 535A0A29BD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:06:50 +0000 (UTC)
X-FDA: 85092944580.14.03F97B0
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C13C180011
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:06:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=r00F92aQ;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf16.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786547208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=XDUATBNDii0rNPk0EPcFSgfeQuKfSAIXVv7jigaLJ2w=;
	b=3A7DvWtHw0IdtMHUG1UtF1urQxQ8iQ7+YfgjzyRSKj/3he2bpEjko2jfMxgSuHFqNUTM29
	+rx89UoHuwGM+KXyGcHWzoElSg2qfMstbD+9guTMKqZPlRDiLpL3hA/DMnPhjl5g7CJCrR
	CuAUqiiBPMyby49AyaiHtiYyegzksk0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=r00F92aQ;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf16.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786547208;
	b=neglgVssHZBMd3zNmHt9J2EJnvLQelXyjr22SOpZpDd/oHhhXC+JZSvr7m9xz6R5knXDcB
	EAIcFkl+1/AAQI3v5GBC4I7grAqFbfn3BMTl9r3u0Pcz1s6LX2toCqY33atSDON8x04baH
	tZ6gTcpQvisteBzCIfUoCYCWZt5mn6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786547205;
	bh=XDUATBNDii0rNPk0EPcFSgfeQuKfSAIXVv7jigaLJ2w=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=r00F92aQkFiiqDI4p41cgXIft6pY2N1ydZXbq+hN2+psjMJhAzrMv+g6ybxjuZQ91
	 M4+6YqEHKuDLIo5gh1nSZ2S5iNQObZe3tblnvfIjJ2eXJyyEjSlt/bNTQa3leH/ahE
	 lx/z5KaeGnRpd1pXbU33K40MCrxUdSRkmVct0qeM=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hKsK10jvsz6vLd;
	Wed, 12 Aug 2026 15:06:45 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hKsK04HyKz4y6W;
	Wed, 12 Aug 2026 15:06:44 +0000 (UTC)
Date: Wed, 12 Aug 2026 16:06:45 +0100
From: Bradley Morgan <include@grrlz.net>
To: leitao@debian.org
CC: akpm@linux-foundation.org, baoquan.he@linux.dev, david@kernel.org,
 kernel-team@meta.com, kexec@lists.infradead.org, liam@infradead.org,
 linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@suse.com, nao.horiguchi@gmail.com,
 pasha.tatashin@soleen.com, pratyush@kernel.org, riel@surriel.com,
 rmikey@meta.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_1/2=5D_kexec=5Ffile=3A_stop_th?=
 =?US-ASCII?Q?e_top-down_search_before_it_underflows?=
In-Reply-To: <20260812-kexec_posioned-v6-1-e477887086f0@debian.org>
Message-ID: <5AEF66B9-D749-4E2F-8B24-62988FE9D960@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qmaeh3p99uutizxe463wssat5ej7r3ib
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C13C180011
X-HE-Tag: 1786547208-811761
X-HE-Meta: U2FsdGVkX18eEUqTgHIH+rzs4gnR4H93vzzSXSRzIIQUVHySLPgbAuOcWGCAKsn9ssKK7XJBvg1aBklHSxJ9i7+bHKPXNdpcSnPPcG3u8H++qxomkcEmcl3AZPMVLeMycVvVgmhOi3Y6x1OxKrpOX2fiix5FTAzZNgR2BTX/hJt4v168wlqe1T7/oB0jGrqEmsBPhGSJtkxJvCgmNEqOaEQHRwdeCjyNEozkS6XguSEzKsjo5xPq3eYepqxpXBTqU+hozVC48yvfTAy4XVvIeQhbIN8W46w+nohW8gBojX02CsS8QmjdBn8PlxcFCiPe36lWSm6pMOiRB3F6SWNzgimPAFoz/blzOVBhEEiqB/oLnf/vG5Fh4JXmR3QnMyUVwyMokgdGIvaYzUj83A3J4hBv6YviDZYx3uIqoC+nwLBQrt5slFUNcRrh6O/uxZXajZVbllg1WQA/QjKfMaWZHrY1BmCSqaut+uCFrg5ZkjAzw5R5fJipAe+RmorFw2jm56hhJySB1AhZkaF5VkIuOpx/HCgI6B7ufn3EHXzy9T5k/LjdqwR7AOpwEYOinYL84ONdFkdReyF8TlFFyV+MElX3Q9ZL53ttrlPIobX7sOXdYr2NTOPga/9OmNfqO7ujhw7d8F+hH+jjLFZ3Ckuof8K+8XoVLCQ5MMidwlG1o7+HwUdgnwIGCc4v/QCoZoOyJ5wtuWbgnEgMbiTdLaFnHiN0LYz58WRy1QSgQpnQ6Y1mVXcPB5ns5q2SdsTftA9R6CBCvBerxGW8IumRslYU/lC3otxxZU9NWlEPtTNbvXWiEoVrXaay8KzhfwrTKiySzpWH3ekU9OupNC38fPstff7kT9Oy8m5WrWGRAKlbrcL0GDQJd9gU0IgTvNFkZRj1f/l2H3XmNgzPtQnCMxfVgx8DSKjb8BeBNX0aEjdUrjWfFEXBL22tOWY4LcN0m06qXwuJcl41fsu1qdcGW/P
 VEvoEPfF
 XbdmI56wP/fnYvbkTFkF3Ap1lQWkNd5rmd6XRNec2ia/w8jOVA8wr/WwU8lD1saSXtfTAoCm1dsxSd7V32O3yTwawoCvPGzCf2ubupWlAN8fHfkRJ7LTln2g6r7LH2jzZa83KAgLy6LN9syOGnjErvjETtLfym14/rNvmlO3o9lzIjz3gnH7juLyv1AyiJXXSiOcvWvbUjY8YNHJ4GSUx8WQOZ4K4Nr45bEYNxCgKtROnDs7Ze2IjiEclt705VVnP1zXNDOrU8ICm/UTmH8O9HDPX5z8XsUhVzDdhmGnFri78M3OLLWWtaXO0TMKbwD/VWfBEtVsQ74JlMiNSdJhxZxBblOjxE+Y09QjQfqra9XHfjdTCoHTbeo4vM+Y7lQZZn8Nn65dqdaSBC2tcpVOmjPKOWXF7UyqRzX8l/e4Y41h8FYyphkoA674HSDF8VkwpUAvAJQp9F8N9S0SH8VdQyn3FIidWxF4ZATgekFat1hcTu6jTLoUMmOzQZlyEBpBt9w9ZTks9730aMdyprD9fCFKCenYBHxpT02md
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

> Nothing stops that subtraction at zero, so a search that reaches the
> bottom of the address space wraps temp_start around and continues.

ack, and the wrapped value sails through both existing checks since
it is not below start or buf_min, misses every segment and exclude
range, and the loop breaks with kbuf->mem pointing outside of RAM.

since the walk only moves down... temp_start > end can only be true after
a wrap, so the new check has no false positives. It is also what lets
patch 2 drop the poison < memsz guard.


Please absolutely add:


Reviewed-by: Bradley Morgan <include@grrlz.net>

Thanks!

