Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C96CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 19:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25E76B0098; Thu,  8 Oct 2026 15:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD4E6B0099; Thu,  8 Oct 2026 15:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16AD6B009B; Thu,  8 Oct 2026 15:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8702A6B0098
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:14:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1333D160493
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:14:55 +0000 (UTC)
X-FDA: 85300411350.17.053029A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 813C3180002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:14:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2FMifRh;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791486893;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8KQeNifzJDkfTub6uCXp9RKMHqJJTc0kuS7L1xFNWM=;
	b=I53jJ+5galGBepg6CYGEAoXhD0ykBJ70N78inf4RrLk5eo6efLzxicJehufVo7YugnoOFj
	Y4D95ME7qPzqs3kENhdziZhdesYD6SIN+jnpJmHwHF2m23HBiazAsu6qlnzXRnIiTjCXM6
	AcR0fV8LijbTqoHU9yw6xuArXL8S35s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2FMifRh;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791486893;
	b=nG+Hj5JErcTqUk2HMNiDHnMEOXHTfjxkYnnGkSl0PLz1VJUhfB10elFf5z6CMEh2cktcQS
	vKJpzb5XATzQWDOdp5b2GnXYOB+hcwUhhKPPQYYowegBc3ut6buMGrtbkexngkOSjTxR3w
	729GQxEIu4V0ORMSEpi1ZvCWQCc8xes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A20E160267;
	Thu,  8 Oct 2026 19:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FDC1F000FF;
	Thu,  8 Oct 2026 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791486891;
	bh=g8KQeNifzJDkfTub6uCXp9RKMHqJJTc0kuS7L1xFNWM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L2FMifRhEDoiYaA/Dnn2ugNRparTpm3x5ZCC1vqmTwUiiOxVVPC+onovRHhZ5h2QH
	 7taU5pl2DUzoVki4fstwIEh+jmSkXIZvalkchzyzk6y13DQYNaI8xjXCQDfrWPmFJu
	 UGr5GEKkSrEWd6VGjM27xlJekcT26snY+yy1eJNOSPfc8AXLYiNGJSiakQX1G1zieE
	 8/IvER3rxJ3fsGTj6C+NZsE+yeuVbk0CY/kbIpq/a1LhvgWuPx+RVwaRMA+sKKdGkT
	 o3KKtjVYrZmcm6C//CkcvvWtCLDkzIISvC7+9+vZ+f5iUb1mBJqhm1WPThn92spuoh
	 5o0pLdCPueGcQ==
Message-ID: <sashiko-outbox-164506@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] memblock: use binary search to locate candidate
 regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Tarun Sahu" <tarunsahu@google.com>, dmatlack@google.com, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261008190828.3221718-2-tarunsahu@google.com>
References: <20261008190828.3221718-1-tarunsahu@google.com>
 <20261008190828.3221718-2-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 19:14:50 +0000
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 813C3180002
X-Rspam-User: 
X-Stat-Signature: 3s7sm788no3tkhb5wjs5z1h1zw88esdp
X-HE-Tag: 1791486893-5610
X-HE-Meta: U2FsdGVkX1/qLqhnBmPdUVNg6g8nn3AMlyk7iGZB7akDBsgRLcrsULQcEoKKt82vUPZEAVmdbWwsj7SDBXca1WV4f1mc8BR5qkhOItSPpIjKQHYgz7HxImg9Bpj560y60tLxoXLVWtx76eye+i7MzZLchSc7o3QlTHgNQ0m+7sk3pWThcoLHjmHwKCFCxvs52KGTSceVE1BYH1N05tMMhHHROBUUzkTefQ7hWueXqwECc6Kmniw8aenKZ9FCHaCJm9buP7R0foCeu/wtHTy4soN0H9xrmTC9aG5GG0HQNPouGuoSUn0R7zS5FlklS0rsl0UwiuTkpmPy7esCX3ZaE9NC0Q3YBgSYL6x+O5cHaiTvJEBjJWj9jzlHY2kAMELZ/lgebVoCA1rp+DMU7MMYMPj9+lG2UxTl+f+7KXak15bZ43XFn//g1TxDbRSxct0lTwn7g5o8qhaM/YhOwhKsgmn7ToBuVWzBHumI7KIg40eXjjgSGa1WtykKiYvkIXWKeXBn6D8QrEZzI07wcuqwmcLRXMaWwqE72emEpN9e2hpKRG6x/UsCWFGwjvXqouN8qpEsb1pIq9PmN11A7Wyzzaj4JOqDXiSfTrG0RA4XmJ09GUr6eNiAvWz8hYj04VmPN6x5y3W3se9f7Qb9VqSkGSsgnpNYNngIUDAFJ2KjjKrK6kBxmyFnkzu0CUybro8/X0KX2PO5OZAAYrPYfdTIavIlbzWeMvYwsNHdiwv4KfUYa7YF/Y5anw1fW4LmnYMk80Ijfkl3UwiYrGsemjiS/30mb9GIrETBExgu3OGKt8bNJBA0RyszyQWdGZVjVV2MQ48ZJQCFYm2/IA//YQETDKUxEJPZ7Ibi5+m3LLpeNf2wqEm00CyTIlT6s1TrB3bZr42ZY4Qkh+Hofjrr3ruYf3hq181qQ32O7fqiKYbENtOz4Id9f50yiJMzuqUqH4OY3nwTum7/sLrT28cI47k
 nvemkzBB
 eRKtdIoOqZd4UQiukGBkZPpoNRZDJHDHAk1MjvRk9hDmxiHPbOziQFQCnRWvdJortEotAk186lYlOAbHxDLGA1XPxDJ6NOom9Q5gtFL6j1NYXElj8bjQ/0ttucXZ77Np/mQ39bCq4LgVC5jBNmmzVy6IulcHxcfWLmfKd0npzVIccZKK1PuUhuzlGWqUh/SfjMpMxLI6jabyRDFXZEbMnVc0UhTjKQZLLzwwcKNWY2QIBJ23UlQdXe2lraBFjnXEG2VZWkH12NwhYoUuJg/vod1lOBl9KVCFyPa8MEw3DEJKf+lKScF9Q88nELJUoyfayz2ooD0omTTBS+604jWwKgQwaWt0skY9n1dTnRC47RzniPI5zS5yQ2Fi9oZio/nHpyymK6G3FmTDKNt8drHdyn5NWwBRXod+zEgTKEt5cwdOcsBx6W69Z4M6qYAzjCt09We6lTdvK26usd/dpTaBDF8DxVUhlnG/a/sAqD++IwzypzTO3s0yTmCeqYEIASN0bhK3g1tvGXgd6YxClj3nFOSRXyiyMvXgu8egUaT/7WXkvBbktU/Kqd+Y67G1HWxGrTi3TYNLZjUsBuYWEMiFKyJ77fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Use binary search (memblock_bsearch_start) in memblock_add_range() and
> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
>=20
> Under heavy memory fragmentation (such as KHO page preservation registeri=
ng
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
>=20
> Using binary search reduces the candidate search complexity to O(log N)
> (from O(N)), cutting KHO memory retrieval time from ~268s to ~50ms.
>=20
> memblock_search() open codes the same binary search, so reimplement it on
> top of the new helper.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008190828.3221=
718-1-tarunsahu@google.com?part=3D2


