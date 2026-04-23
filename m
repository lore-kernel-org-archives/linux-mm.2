Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F070CFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 22:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3BB6B0088; Thu, 23 Apr 2026 18:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193CB6B008A; Thu, 23 Apr 2026 18:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA5E6B008C; Thu, 23 Apr 2026 18:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21916B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:46:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8251D1205E7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:46:06 +0000 (UTC)
X-FDA: 84691305132.29.C55E9B8
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B0D1A000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:46:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=larkBWn8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776984364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0mHKBq61/yarwq4Sa7hTm08Lz676EcU0K67E1wCp6I=;
	b=Zl2GVePgueZUnrJ8KbFVR70eZrTydUXiYv+SvZjxTaXEaH9ESs46641fu/qd8GJ+KD3s1P
	ljB3huNcT/xDKdkC0VyyZ1U5sI9rqNYuuwJqJSLzjoxkgU8nmYkw2+FGmWG1pB+xFyUKpS
	cXhGD126ApjCqbPDS97wI8Ji1ApZZLk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=larkBWn8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776984364; a=rsa-sha256;
	cv=none;
	b=Qp4PLcOK40jsa/ICADjqiZ551b1cwkP2DrAZA/FzkZhP1sAaWaUYv1PbHPwlmL3CZSMwT3
	yj16B8DBfwS92uGd/hNwCEKQk/kMGH/PuWzVOl635v3L32PShFrMNWJYliZ++FECj4E/lu
	209Rw78Xt9B2bSZaQVw7iXqsSOP1bko=
Date: Thu, 23 Apr 2026 15:45:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776984362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+0mHKBq61/yarwq4Sa7hTm08Lz676EcU0K67E1wCp6I=;
	b=larkBWn85qeCAy6AWKBJ82KrrH2khVDU88IR6pNIFm1qvU1ygq1VR9BSotmLKRty/o2hz4
	1ejZlx8hT5hs+K+eQ2NAIS1Wv+QbN+KRVewdkMwkxIZXYHOmZEUuduUFKIUBKo0Fx9p6Mf
	mBZx3n+WWlx/Nt43b3qwNgogXSYWbSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org, 
	mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, riel@surriel.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aeqggiMu87lu8GXG@linux.dev>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <aepdmTw2tPJ9oMc3@linux.dev>
 <31f1f2a2-3fcd-4a65-94b4-f1f2921b2e8d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31f1f2a2-3fcd-4a65-94b4-f1f2921b2e8d@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B0D1A000C
X-Stat-Signature: 8wtzpfpk4etwsff7deuhsh95ngrhqdog
X-Rspam-User: 
X-HE-Tag: 1776984364-414626
X-HE-Meta: U2FsdGVkX18SMrq1Y2UDvganD8ZCGaLz08BSltV8BH2PlyqWR/4hVc55Xkc+bbgzmVDSfHf+XDyMCOFHLrIoOFbfm9Ag8nhFaD21znvtP+IdWHt5JhaX7tFt6PNPbT/PbV0aAJ7p1BjGe8LN1/8X2ftGgQ4UyJAuMbYgn3W9MYFL9EW79LInocr0tb+CfuFMap6RfovhXIV0LcucmEd1W2TQQ+O+rv6g0/ltBSVpGXz728oYAveHiGVTKEPAfGXkRhSuHX7RZD9PNwJu0TMV3Le4uaCB5wbTFh716TKgUMWx+Upem3/r6zt4LV8xQ+xUwUUGsW4lDzTFomZgZS4XYr/2y3WjrSkW1AuOypxUSSN5F8d9ubs+GRdgw3aNR6cAYaKZabS8mjDWEZIQy99ek6R8tZQH0j99SxhKmFIhSGZkriJs+++nBB9PDbCk+sICI9ps8zFh/HZ2T0zQfUuxTHENna/PovaOfKHlHCGCfzcKvVLm194YSIpJQdTZe+zAxiWg1iPsO/zZIYL3XR5SJTySWYR/bxkFpsLBjqC9+EE/fidH1UxIo3g7grFwawqusiWI7ZYLj3WgY9gOW3ECV07brRgxk3gJK/S8khps0SV7ZgHrA1RwIRfFyhkZKmqCY+DZXgc4KZBV1V2YuFWnBVCS+qr0zEX2SltDadHn2MY+r1jQYhp+/SjRbqJicG7kq9CPhMZ0OkR4nl0SMOcciMBuJqwMcRPb4/LOM2ieSrRoqNe334DHcLHsG5VeCszhP9OmcWXgetX1qyaGuMeb5v+pQZ32REBWXPh6LZnJTKQPz3Os6oMVFmDwL+F2U7JWR82iuIIzB8l7lWeAd9GjOHFU14vWy5wF5wMFKsLYviiEebIkVhIzF09wlfgWJ6CiBCpEmjXZqT/IfKRz/Osgo0SrhojcC6oPe2ZOrAzxFYp55D3J4exqADRjuLMu7g+GTgDxplriBlBxzg0QZqY
 xEW2PLg6
 LICxwepBUM0dcNxP2FtxKYAvgTdiQb+sfcEnSy/ewbETksczkQRSI6vgMz3Nm9JglwW64hIOUVBo4AgjJxF3EihLf5BPGBnH/zaZak+CKZ7Yn6p8+I0/LKDWgfq8qaxOCNsSb4XvejaAysf2gKBxfruU8zEMF/GsGq2CBRaeEQQfOu5Xq5o2sv4W7MzVIUD5GefyA6JgDQBEqWAFY3bB+wnkMzn+JqKQOkCaxxZE508HnYeVJRlCD1VTLC381ffpGhTw0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:18:16PM -0700, JP Kobryn (Meta) wrote:
> On 4/23/26 11:46 AM, Shakeel Butt wrote:
> > On Thu, Apr 23, 2026 at 09:43:07AM -0700, JP Kobryn (Meta) wrote:
> > > Of all observable lruvec lock contention in our fleet, we find that ~24%
> > > occurs when dead folios are present in lru_add batches at drain time.
> > 
> > So, when they were added to the percpu lru cache, they were alive but during
> > their stay in lru cache, they were freed (last non-lrucache ref dropped) or
> > somehow we are adding folio where the caller drops the reference just after
> > adding to percpu lru cache e.g. folio_putback_lru() ?
> 
> Both scenarios can occur. Whether all callers put the folio while it is
> on the per-cpu batch or putback drops ref from 2 to 1, the batch ref
> is what remains.

I was wondering which one is dominant.

> 
> [...]
> > 
> > Overall the code looks good but I do wonder if we can add something similar to
> > folio_add_lru() and if that would be enough.
> 
> folio_add_lru() is how it gets onto the batch. But it's still alive at
> that point - at least one caller ref.

Yeah, I was thinking if we do special checking at folio_putback_lru() to avoid
folio_add_lru() at all (only if folio_putback_lru() is the one causing such
scenario most of the time).

Anyways, that analysis can be done later. So, for the path:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

