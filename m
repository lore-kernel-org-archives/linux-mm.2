Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6962CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66746B0005; Wed, 20 May 2026 02:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E176E6B0088; Wed, 20 May 2026 02:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D496B008A; Wed, 20 May 2026 02:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C25406B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:16:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60186A01A6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:16:59 +0000 (UTC)
X-FDA: 84786790158.02.2E7BE0F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB3E9140005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:16:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hy47G6KX;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779257817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sp2pJ+82XHyKehOHniPHwM9kegm9WKiZRGipSAFGfRU=;
	b=vNvhIjRUi40wPsOlDse+98+i6TwBXzKRnWijvFIyZEaMDt9DpbdZRLxrEJtTBJKId/IuOG
	EhSVbhjFvvPRY14PqRFCgrUeXc7QQoD+59OS2M/fAexjH1pSendAejk44koSZJfumLntz9
	wo/YnCY0PfkOhcmEDjuqw0PcvxBZhck=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hy47G6KX;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779257817; a=rsa-sha256;
	cv=none;
	b=U9r/QgTiW/oZtSh6jkZbRBn/hcqbN5eUXSo/wR1JrwxLvyPX43RXfRSNHXxmzreDJ273m0
	79j3oks0MXPSynVZSYfiuH1qDQg3t0gQYaOv4wOmJ/dnKbudMEt9KhcteEOYBCIMIGsF8T
	I4wjkpkAWXj1j6n27ifN9donl/CwAko=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779257815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sp2pJ+82XHyKehOHniPHwM9kegm9WKiZRGipSAFGfRU=;
	b=hy47G6KXzrCGiCNcSHgbc/erLXASNRjikzSb1Zx4XJo3mU2UlRDtXANw3L+qlTCLFz6LQJ
	lvHczjf3rHYuF/wOTg990Pn8owSdQba9VFWJaP3f7XAGn4sw/ayhKhTKhGwhccHGEicS4G
	9Cl2k8QJfc3hQ4GtG8sEC2ZyzE77cXg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v3] mm/hugetlb: restore reservation on error in hugetlb
 folio copy paths
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260520044912.6751-1-devnexen@gmail.com>
Date: Wed, 20 May 2026 14:16:07 +0800
Cc: akpm@linux-foundation.org,
 david@kernel.org,
 almasrymina@google.com,
 osalvador@suse.de,
 yuehaibing@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B3586132-590D-4472-8A4D-A76B0DA9E105@linux.dev>
References: <20260519230503.121293-1-devnexen@gmail.com>
 <20260520044912.6751-1-devnexen@gmail.com>
To: David Carlier <devnexen@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fjcmqnkiybfzurgzqq4oojofihkkgkhd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB3E9140005
X-Rspam-User: 
X-HE-Tag: 1779257817-714462
X-HE-Meta: U2FsdGVkX1/HScJArQnf59HnRHgZibuvRjB+42sn+172qJ/OKYOrJy448c3DDxR0ig6gJUODifCqafMVUMn2idfqbTWf0CvmLC3bZs1wtVuMIBDSsWIFMThd91nvHf0SQt+IfB0LzxKngEocUPE4DZoQpZgn8zbqMJygXPZwehn3iUXh61OvlysrskRp/p4UhCv1nZY0poGo0w9dvMKDnwR+u9gCeCWfWsiOqt57pXOWYIH+ujrQVLSJ4s26T8i5cWtob6MCV9TPz3cW+Ar9AVs/bNyStRmSoqG9YQ3Ndg+7PcuWc46AbU2PDZnArKXoftyHRs71CXJbTZ33kWvP7c/Y7bV+abzglzaNrcbd2XgxslGWCNU20h+jr84YGNE18pBIsnU+vASL0rAdcrbBTsOmGkqr6MnKv0BNnNp5HbYowHuUcbhzk+SOAXdNwNT5dZK0rjjQcZXqQkKtfNySmIostVVuTg3pzofZDKGtdUYw28/C3fB/inIPD3S03Pt0KuPbBsXEE61fIIaHKEAy7DteZsnmfUM3yDaXAbkNU5rPihEm4KyelohCIyUo5Rb7X6Qpf9IrDHT7+42/Z+N7u4x78Q3nCmCDO/KJacmFgJkZ1AvRIAxTrKru9jtxEHtDTKX8M5xhkBqPZ68pPV58pcMQopMXxXNzQwYm4TJk0dhtgwX2jukdfVha1nIpDzdElGsPxpCOl4uN1hz7J/b1dDCk+8Wx+hSUc59s/paIbDkrywSDQLbHaQPh4BbuY/6qTo5mb/sy+X5t35kbE44eHeD/k0IkwjpFQyPhfQB+0RzJJ9SJvDcXEYMl2nRZ085tdHxPlEDRkQPceCWKMZSQbKbeWnSteniCK7i3XxZZEaS19YZyNXciJNuk7qomVgmvsKlJ116zwx53171Am7qIlbwD9pJuvHJIyGQgwdTrpZaD+jYfegEnTytx50GGf2j+4B7TKpAL2dhRrEwuiCj
 iTzKNcBm
 drl/weOILEuSiLgcueWaFU4iDW72EHxyujE5nGdVq734FNohyHhycqI5PZpVPPBxjM29KdCfCJZuOvpZmrSFAHftNEm0zyYSXsO0k3mZdiP7+unw+45VR8rZYoZ0phDfopypEOIvpJZVy3YFYgkSwZPcy0bCw/iGjc4VC/94h/zEaqtjsGKKmOCugBOcaUkjBlVpvSbhYJS82pCSXELFrcAwUQpWXRg+UuP+MRhR6hdrWQoqaEztcfWTU7rF1DEZetDjHVMZM26xa2IHk4kJMKQfaaIlqTtc7EzJz6m6w6QOBahBFeSAnpkoQqFl/hU/WT9QQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 20, 2026, at 12:49, David Carlier <devnexen@gmail.com> wrote:
>=20
> Two sites in mm/hugetlb.c allocate a hugetlb folio via
> alloc_hugetlb_folio() (consuming a VMA reservation) and then call
> copy_user_large_folio(), which became int-returning in commit
> 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage
> copy-on-write faults") and can now fail (e.g. -EHWPOISON on a
> hwpoisoned source page). On the failure path, folio_put() restores
> the global hugetlb pool count through free_huge_folio(), but the
> per-VMA reservation map entry is left marked consumed:
>=20
>  - hugetlb_mfill_atomic_pte() resubmission path (UFFDIO_COPY)
>  - copy_hugetlb_page_range() fork-time CoW path when
>    hugetlb_try_dup_anon_rmap() fails (rare: pinned hugetlb anon
>    folio under fork)
>=20
> User-visible effect: on UFFDIO_COPY into a private hugetlb VMA where
> the resubmission copy fails, the reservation for that address is
> leaked from the VMA's reserve map. A subsequent fault at the same
> address takes the no-reservation path, and under hugetlb pool
> pressure the task is SIGBUSed at an address it had previously
> reserved. The fork-time CoW path leaks the same way in the child
> VMA's reserve map, though it requires the much rarer combination
> of pinned hugetlb anon page + hwpoisoned source.
>=20
> Add the missing restore_reserve_on_error() call before folio_put()
> on both error paths.
>=20
> Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage =
copy-on-write faults")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


