Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0C4CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 03:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1558E001D; Tue, 14 Oct 2025 23:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9BA8E0005; Tue, 14 Oct 2025 23:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01598E001D; Tue, 14 Oct 2025 23:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8B7C8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:21:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EBE1BC02A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:21:35 +0000 (UTC)
X-FDA: 83998898550.19.C3F3177
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 25F4F1C0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:21:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FbGRZ/rx"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760498493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vZhghVmnJMheRu4WGt6Jm2AnYVQSqZVx2x8NSyWD+o=;
	b=bhNM2H5NKxMnLP5XxQRsnwF+oyeFuvHwk4IryYS94lE3wgVDRUi9iEllJEgYT2OBsqy4jH
	tUBWaYC9p13bM7uX4bUgvkZd7jAlI8kbVNsXmXh9UUM/ABD8SQTUCH3+k6XASrJxxAz4+r
	Y/4oLjWGGPKIxd1rC1R4maiJfKcmv6k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FbGRZ/rx";
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760498493; a=rsa-sha256;
	cv=none;
	b=1BxHza2UI6Jy5PQzAGPC1wiA4+batBpOKk7uWaZU1xIAZnaquUqRu2eIlefcmigmTf3uZe
	lZuBgXRHLPZB5kkLXwwGePxn79zzWeqp9H8dny0nj1Q781BDZymlYIpglfJ+8zfaIG6PLt
	kuXKh0H0THP5VTJ0R4yTd9DuRtKHmZc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+vZhghVmnJMheRu4WGt6Jm2AnYVQSqZVx2x8NSyWD+o=; b=FbGRZ/rxcOCURqJcLxsSF/pzLo
	L/v76Zh8y9EcucbcRxZQdiTEwOoRt9atY8AjoeGJovLqc3ZOFKV20A5wK0SYY60r+EKhk9mS2Laj9
	IK/r3Ed693yH/8skGzY3KRygDDWQr55qBEomc9oUWSYVpD772fJuGMjM0vX3TuVog4L9huuLy7t3u
	HYWrPYsdTu2zbRQGeh/qIKgySxuFOf5cHPmVD1MrIiad82QeJOoM0muj/rDGKxmA821nM0ABgA4Yc
	+9D/MgidcOyM5+c9Y3y51X50S26WlC3W73xgXGFsl3Ql9KaRRNlIf4L4Wl+pn2fsQZE822PkVo777
	Iru8YHkw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8s4g-00000006McQ-0QcF;
	Wed, 15 Oct 2025 03:21:14 +0000
Date: Wed, 15 Oct 2025 04:21:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
Message-ID: <aO8TKQN6ifOSMRSC@casper.infradead.org>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
 <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
 <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
 <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com>
 <20251014171003.57bbfd63@mordecai.tesarici.cz>
 <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com>
 <CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25F4F1C0002
X-Stat-Signature: 3nbtixbywxtgk6hy1zi4tg3xb9kgwqmj
X-Rspam-User: 
X-HE-Tag: 1760498492-810449
X-HE-Meta: U2FsdGVkX19LMOT1t8QwdXFmF4yw8+Azc0xr8Pu6uuEfutcly4kXjLAU9HdEGlbmm2RUObfofjwzuYvw9JVa8YmzyTs0DrsvmY64kAgsV0T4F4bnvW7AFUJKXCVXb8aQ/asJUBu8wIh1Q/S1U3uvqvU+Cpy/UHD+1SvoexrAAI6ciaJ+//KbuB3iyn8Xh4LC9QtEm5Vlnuarv9oXFXRBjj9wsI/g5IMsCY9wY0ryW7s77fRVRl94erMh/Ypv36V1xnn0mKylTNgjPL2yf6dc7hKMF9l9xBk+mOBQFm/nR01x7JlPbBlBArtRvS7sy/2zDaUiEqQsS8Xtzrpsl7vNVQPqaTAavkR0RZmEwMdMAgx0HPdoGMb7QDvKjQozIxfNANrc2mkaSp8bbdXrlrDoTAzzcq0iFlVi09zOm1z7ba2OdiHoZp+aPCTcJGyGSA/5SeakmJQ4bK4zkWFyWPkFFpEG9m/Wp7YZNqCv5cCR6pUx+iYDUQfCFeV7teVOUXYG0h+JCVaifk8iWdQ11wIWbJtiKGqz+Tz3BbsncD2qBO7EDyLqZGB/lO6oF/hmmzD5HyAn78zgrZAP7/ax42a7X+n471OCgUsSLDhtEV6NtggcVXfZ4bMWxY7Zd2W+aozBYdzEFkOvYG1Y/Y3FOv2njtVHNaG1HRmhvPhkWJE2UBNYAqEZ6CgsCkdKORJIL2ftDAzk7rjnqKnXbThRRBs/a9hCeQKCSPtKoTCRIYRYbGQldApQCttTlSDogCjh1QOwCse4YK4YV+Rr0vo+1ngURg5s9f0AwTTL45gGTohv7Ns3uUDLqEuFVIZu6pTrxqRfkwp/eaF5jAsKT1mSALJoUM9phNCvhqpHcZMflcWUW0zdaj0nhThnOBhvmRw681MEWxrQpHhn6NhHYvdqJg4TI1KenNdcHCHaPC0CbYiKNL+tYbgpFbM5q8ZbZinnCCHoapL/26eV2FGkyto+gn/
 kzo/+PyT
 n1HyVNVhWWtaxynz1M0YwVb9Q2dOXp1I7tXX3w6jYSxALhOgqlIld68+OHPXjaEh+N2SvF2jCPZI2t9+H5+YbSr2b3pQbddMVXnI5ciGIx1n3KQG9Z7E/Sje9Gm26bignSMuOv9Z+6QG+Nvhynr0fDrXfelnQX9tlKUf8xl18ByYvuntf1D/W9lFookL5ZzbTqMEMc116yHnHBOTOikLQ4l+ZcTepkhbvgdM+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:12:07AM +0800, Zhaoyang Huang wrote:
> > Could be that we need to make this behavior conditional, but somebody would need to come up with some really good arguments to justify the complexity.
> ok, should we use CONFIG_DMA_BUF_BULK_ALLOCATION or a variable
> controlled by sysfs interface?

No.  Explain what you're trying to solve, because you haven't yet.

