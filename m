Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35509C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874A06B00B2; Wed, 21 Jan 2026 21:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822536B00B3; Wed, 21 Jan 2026 21:24:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E726B00B4; Wed, 21 Jan 2026 21:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61E526B00B2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:24:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0867D1B218C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:24:53 +0000 (UTC)
X-FDA: 84358006866.29.4D7A336
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 428C7C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:24:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xCcG8UHm;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769048691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW9jsyRuBI9zl9ikyUs4U41azYd78tVzdBqcf0Jug7Y=;
	b=rItGkK6u7IOHo8ArcroL2gmYuVGip4yhLFSo22wvVfDnCjUkEKdXfKkk/Olif+YUr+Ng4q
	hFpVYoU5mhagbjyyyXdidOV/QvicjOLPv8W6XdWrB9xHuyhxokp6fgMsBVaaNb87isiR7r
	R7ALkOqhb63j75epky2WcfR/O9S2rfE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xCcG8UHm;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769048691; a=rsa-sha256;
	cv=none;
	b=dvYwj3SKTJysYm8Trt4uWaixJph0SE881t9zRieh5oyzU20u9eDdiuYE9PdtlUlGxo88Ei
	DTqC4CD9z84Y0i8Jg772WZq1GKFRFeHFIZMl0h54joqBMQusyQYGV+LkalHztrbttdZZ8Z
	1sNgrShmpfPZObRMgBToZKdGy8GLWSE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769048688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uW9jsyRuBI9zl9ikyUs4U41azYd78tVzdBqcf0Jug7Y=;
	b=xCcG8UHmJrreH24utr+ksk+03nK1IR3rghgvX0wnZ5j7C1W+gIWUPuffwItlVajJDID0kL
	P8bbKIl+MFeDd35wQFpGGhAd4wEVjZ2wO+IjHwM0fsFygZq0ap0lV7bsq8geQQ+LVwKqQi
	xPKh2uES3qOFtzIbDETqSMTzIZb+oMY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 01/14] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121162253.2216580-2-kas@kernel.org>
Date: Thu, 22 Jan 2026 10:24:02 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9664AA17-6F0A-4507-B2F3-4543ECE52FF1@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-2-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 428C7C0004
X-Stat-Signature: 51oey8wip7eypmu5m5xsrmtkmqaxct5t
X-Rspam-User: 
X-HE-Tag: 1769048691-243945
X-HE-Meta: U2FsdGVkX1/Amq3I3W5LYThWN+vfuk3eunuvE54yQuNB6I6uDpq5Y4HyX3LV6C51t5hQ6ogb2xDUagxdfMUBM6yTadPIsBO1SPB+uO0JNkffgz/l7nQWOzj+xmfqEBqa9D/yJDPt624ycyI5aHYTF4oEeTtFHPbMmVmadZuyCgxkElV8UmfFTM/YHOmos4mIx/s8tsMZl7zgDQDya1exePKuz3bOndMZstBb92pxAr1fdacjGrd+XTszhLvFkaFrlWZOwv3jFhFBJEKI5R7CmgnFoWwFN7dwqdKBFACY9EeiNBeeqTB6IxDkSwcUTheRk48oJ48tg20oDmjRER8VDqlCf3QTlkhjrHpv/Ug4GrCJz9iNt1U29qsuRamQjphvTBhN5eKaENX/Ps73pYOAH2GJika/V5ag+eIrC7PIpWjS7G6F8RJ9OXhxJDrFPSKv+EOMMN5orqaH142Cv9tAOPKdtuYfG0v5J7IZGRjcVVfg46qAGPlNJ/3cibIjsFtXSZFod0bjcqOZhxVjEj0fdGOWWVh5gdeRCx2zfn1XzCUQa/d4c4SWC2uyPLfq19oB0ghRo982+QD6w7PEmqpwHZzGxss/rv2HxhoQVd6AB5BG4BQSANn1SHdCRvWxZdB/WeBXW3w4Gst37u95vtFvme9OcDRb9591fCGORypN/7Gwkiaxc7bNsoFNLS0UMrIv8GQbuTeaefaW05gmlUHP7nQ5co7K9k2m0M8LtcRaANIbzfpz3YYJHDd6/nXgPMF94xLBHRD6aDn+t7YwJBrTqeEHtwGQ80pcEs64voEwOwehhrKVF4Hh3QNd+bEni2vjEC9+xYGS2qyGKo7PEZKW94p2YbIXX6jxwPyTpfxp39ZF4ZWhsrLJSC3vSZF7zDGUTZcEr+x5SrFj/sndoO7w5U2Vgoi7TqgvujWAyo4ccKoCN+bSiDFU2Oj/uCfK/4+d1/momlrEgBu0TZb4CHf
 UcpAjOHt
 f+3kWViwwNmSwof9QS46yV66e/nPyZfQiPRte3O1xdcH5DlQexShBui9N7T+4pLnewfs3YLZMmw4ftJiQPk2guWtY7ynSTyir6PjCnIKNS0Vt8TXOWdRlNJl36K/B6QLFd/3ChWeZ6e+vhfsX+uy6nrsptVxKij7DwsH0+OMLPXNB35lDewnjVNmY2VIkhopvpI7LbvXgi9F0dd0nnIjekx+BkacyPUrVxKPvfxYtluk1yDtczpeS91TIZUBEhSqdrs74c5AFomzjQDpDntkpl7Qv3Cpy8Gi+GVmO2bqfTb4iZ+9wIwHWB7H5YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> 
> This is preparation for adding the vmemmap_tails array to struct
> pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>



