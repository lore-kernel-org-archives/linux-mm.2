Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56BDFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC1E6B00B5; Fri, 24 Apr 2026 10:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284036B00B6; Fri, 24 Apr 2026 10:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A206B00B7; Fri, 24 Apr 2026 10:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04FFD6B00B5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:04:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E2E51201BB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:04:47 +0000 (UTC)
X-FDA: 84693620214.30.BEBC1A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FC8C18000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:04:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=MZZTlo9u;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HiUZbAqn1KyFv+NahOMdBiWbYc2ioZ3BnAvL8eUZdY=;
	b=i3ttXsiAfe/AQw8tQVrEVZey0nChG39PF9dTk5eTBJRlq8pKUPR+ff+X60RcI8tzqttdAp
	tKHatoBVUNUnJVNO0u27d6fxv6rGIrLX5FM03h4M9iUK0PABpdtbOhLvAV3fSPilBj/1K5
	Y7jrI00gwWW3e7tSJq1azZoBamPw914=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039485; a=rsa-sha256;
	cv=none;
	b=LzWR2AyumutC6ylMfEwH4Wj2U2RRbW7B4OHYOFU+TxY7kjDZkJc4enSr7CyUq/MDCD04WE
	hm9QR8wrQEZ+HeuGC934eqfelYQnCqmHxF+K3uloSfUKuMcTtJ4AtcWcvkIoXaZmWdGP/0
	Vc7FcnKWkbDozTmLYJJVFw7upPjd1ec=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=MZZTlo9u;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A99A841E56;
	Fri, 24 Apr 2026 14:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BBDC19425;
	Fri, 24 Apr 2026 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777039484;
	bh=SO7bu4Vm6Jfq2usB8FujQrfzdLbxnKL5FBIA6ufdnJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZZTlo9un/36T3NeFLTE3v1e9mrOtneILLaBx+/DA5CWK5k8yQ4YQDraUoqChAmCM
	 QHz/6VzayChM7XN1aNwuRdV9Fgp0oCQMNOAvYk/QMqzT02ik4FGSY5R0WNOktJu/9l
	 al4i4K7Tg85QeB7K1ZCQpQh0XOHa13xWUcyS7Yo4=
Date: Fri, 24 Apr 2026 16:04:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026042418-facing-viewer-c7d9@gregkh>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
X-Stat-Signature: mg9e4tk6fkru4r9hfwbntuataqda1pen
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9FC8C18000F
X-Rspam-User: 
X-HE-Tag: 1777039485-409848
X-HE-Meta: U2FsdGVkX19bY17HCNEUqWzOi0XGGD3pcM1OoWhnhekrPIPKdcbkWC7mOfVsz+xx6q1otDWMNvytAsap16z5UO0k653U0NcBqlq1ih7+A7YNwAg1g3el3XIVWQzx6GkcEx43Iq+qjqXbwR8cJdxfQfkwJ5VzqxFAtfov5DCHnvB/EJSTtOXaVaVfOD9u1YxwG+/qO+VbJQhbqBhsutpzQ/dzqBx0Rob0w4M5e9bUigCz7WWDFZeYlimnz92SygFmosRx4AmHI/IbFt4SHmuyL1s6eNSA2GHVRnGqX8Fc0FP5NCYVM/cHTxZ/m5Nu2AFehBgcUoZ4T2K581kW6S8rMKwvccjmYcRNey/BX4rHOQ6qDy6GfmMJZ6+ddCXuF9wk2ZTF+Xj4fFe86EAXisnVOtQok/wlfhS5DwmLzQe119JVqt72D4IbkazEfCIrOlb8DNkupif83Y+siaOGHImpe5BueZ8+739kR6fbfTr69mxXK372+/dynNIbMVUFvIpH4Ym5FUVr7K6EPnzs/2iMl1eCjojpmmD+WnfSKKEtV0ppG4F9k5C9ZN7JT1Z1Qzevzq78MQvLE9UwhYL2DNRCnLKhNPU/O73IqSMpxMBjg8GVwfgii2UFQpT6qJPR0nGyYQ3OO/TLysZ600l0Yh74hWtU7+r9RGO7j/k5MqsT2bs5S4C9rYd6xOR+b8Tuo5AaHDYjD1IAHumtLMElxE90Tkdz6BEVVI4kPl6T5rno6W21EWlhPx3wzUYbmKNLfTvIFQ0tJFlCMIvaZtLzeNpj63lYY/VBsLGIRlOrWawEC+GGVp3Fvur6jmkm9e5LeLs5nEaWrZScPX2FgVfbaPFhLadqfmSSm3UDlQFqpsUxU449b0rtDNJwIM+1UoBUaN1aqt3s3UGPdJI9PkF/d1OpJxowjAYrLwH3P3pPNpL6dKIWtCCUjov9LProvVgUylzq/jA+EMq5I5t+wCN4fKL
 hrT+yl/0
 KXz6MDyMufvG0HekA8utKcBTUd5qowCU0rep4+QElO6NyAlsBlkQiQD94KflhC5eBkYW/hiOoJ6+ngnID9DbwiyiNxD4tf9OKwBNSZU+YVdBHtH6Ur8A2e+gPWkvWyJEghvtQW9Zb4XW0QL9C9Umj4DuTlcd0rQSuQ6L7yeRnWbZGMibPTuZNLthrrdDRt4G5K/WjMkIQt+oyOLsPJlPAvg5GTVs0xpP0IZbflyjb49wsM3q4MVCG1QgvPL7tU0rSIeRNgmx5ENZjBh3k1E2nVk+MRD6Sausmc1jpEjyMqhn9U86OX8eI54X/2+kxSEyVURbZuGC3idjXnhPUbe+nrptW+vtt6s70xaW8z5vxJoodr3t7X66p93iWmmDak07t+Mj3tjDYxfodE02MPxlYruzliYK9aKbtQz29pd2pt6bAGd2tuwERv+JMG7KRGIpMGYvzmGgHVt8clb8S3zLvlZiK9geNzbVXk3zrtKnEbKpDcXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:38:17AM -0700, Andrew Morton wrote:
> On Thu, 23 Apr 2026 16:28:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> > get_page() reference for each page regardless of foll_flags:
> > 	if (pages[i])
> > 		get_page(pages[i]);
> > 
> > This is reached from pin_user_pages*() with FOLL_PIN set.
> > unpin_user_page() is shared between MMU and NOMMU configurations and
> > unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> > GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> > 
> > This means that pin adds 1, and then unpin will subtract 1024.
> > 
> > If a user maps a page (refcount 1), registers it 1023 times as an
> > io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> > unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> > the page is freed and returned to the buddy allocator.  The remaining
> > 1022 unpins write into whatever was reallocated, and the user's VMA
> > still maps the freed page (NOMMU has no MMU to invalidate it).
> > Reallocating the page for an io_uring pbuf_ring then lets userspace
> > corrupt the new owner's data through the stale mapping.
> > 
> > Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> > for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> > symmetric.
> 
> Battle of the bots?
> 	https://sashiko.dev/#/patchset/2026042303-vendor-outright-b9d2@gregkh

Odd, I really don't know the answer to that.  I can provide my
reproducer if anyone wants to tell me this patch is wrong.

thanks,

greg k-h

