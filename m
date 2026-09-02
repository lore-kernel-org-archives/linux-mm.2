Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13E0C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932866B00D0; Wed,  2 Sep 2026 18:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBED6B00D3; Wed,  2 Sep 2026 18:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0D56B00D4; Wed,  2 Sep 2026 18:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4797C6B00D0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:42:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABCAB140169
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:42:39 +0000 (UTC)
X-FDA: 85170298038.26.199F396
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EC06E2000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:42:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=prHzxbiE;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788388958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqO5LZhvHBtRdvbWaz/wBxjW/GfD1kqiQ2C9og7aMqo=;
	b=4M6uOGJeYVZOciUuuuCjC/1wrzU/kKayatbHgsXGVz6SxNQYk4afhO+DY/uESLG9+cKu1q
	t/+S5S6GRtJL7vpJzJkLzh1ewuCeNTRAyVSlKNhrt/Oh7WHwo+IE5fdJ8eS6fdiM0I9joF
	+AxCTpmqfUdnN2Ojw3GVkbb4TnKXrZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788388958;
	b=40WeM/fUUwonX3Jv9RRdDeJa84K/8H5xO/NmK0SFylMjeFpQ3ae1+EeqEvoFNdxLkAwDx0
	LHFGBbof+mwr/arRLP8Pvz3wILS54UzX9Nr6XD4TPcOtfMcqUogwzK87CZX6QCNUtaDs2o
	0CmUSXa+zsHtUc0mruYzUBvrzyNmBzc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=prHzxbiE;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B3DC601EF;
	Wed,  2 Sep 2026 22:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62C1F000E9;
	Wed,  2 Sep 2026 22:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388957;
	bh=pqO5LZhvHBtRdvbWaz/wBxjW/GfD1kqiQ2C9og7aMqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=prHzxbiED94HyIQ7ik1B7ECmS7zcOCMeXkIHkC818VXVBLbk/R/jMpD/lxm7iERyM
	 uoGFJiqDb8MLxSYNs7OcvlydDZAkz2sGR1uqYT6kYhsuDJciw9PQ3XGs22Z8U+dk6k
	 K/AjesgeV+b5K/D0P3ZrrQXATJNrGeukzLcE1iAs=
Date: Wed, 2 Sep 2026 15:42:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Brendan Higgins
 <brendan.higgins@linux.dev>, David Gow <davidgow@davidgow.net>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/12] mm/damon: cleanup code, add test cases, and
 update guidances in docs
Message-Id: <20260902154236.3f59f36fb51f3345a0f21906@linux-foundation.org>
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC06E2000A
X-Stat-Signature: tfea7a7fodri8ib8u4m3sa6pdp1o6o3e
X-Rspam-User: 
X-HE-Tag: 1788388957-367615
X-HE-Meta: U2FsdGVkX1+DdIE57t2qPTpnem7lmAaoPJJRiYNoCUEWr4Jg6FOdaZ3gNIcR0M56+SWcsKhWODeMo8jMH2LyG4Us4WlXKZyB7fY5QXYUIZg3D9F4dHXLHixvi15Lo9aZPVFcS2UMOsLqb8lfY77c+mMfLO+xvHygp4S0gElAV/NuF1x8aYmQJ80JbopOnKOS8/mQ6zbaN9FeZ0efubxfrP9CywV3qNgczcMNc1Hr+YrP8xVUVMYYQ9jBpVf/4daxX/8jx0k/aDICt/n+wcpZLvyAJXLevlI7iaa4AvlSFU2N8pnMjlfMbEkePZ8lgm0qSCYbSc6JEmq9UWjSPC6CU8F7OtrxW0wSua/kK0+EWGPmDRSnSS7f6SsjH3FXTvfBoanlmtirPJ7yJU262325kXvgrxNtD7Opeojln84UjPD96dLbM6yidqtfc3gXaJEd2V2JFT0rxXxgvLhIro0CZwYDivfBpuswe0nnd9sHJV7bgCFBV8VAnVxgRmPYdz7+e+/tNb+OFhs+7d0RBGcNTp392XcD5+rnzV062zxSWd1aISnTwK3mYnFQW98cMl8Dvpc+ANStAMUUuC6juYmdSqTQQfzHR/wKlXKLfdM4CMc9OS/O03yLw+XD/twUy7arDK36s9KxUyWerA59r9w8Rt9A0zxGWKPtnVaJhpIrZCTapEe3Ce+qXmEGubS2LKSAA2yOrcUUmRmdK4+G7m2t/qYx1QiHVh74NH3NFHhhWMVA0gE7UU6DcjegEgngDpzMcn0AKDV7uDv3GmhFm4OmLU9W8wZNyzlET5M3MtHsGqsIfkXD3L6T1VCpRd1NOC6KNGwfbFwS++erZIF1RQq7h9ZXydbhLbC36D/CQcnHEA6puiWHiUlV4OtXmtauBfTLma10SW7hzeiN4CJRdcl409O+AWkTwCAPfBVY5blqicoAfp/fIn0KcSAYoB9lWQn1zu2HtM0UmSDLEkA4Opa
 nMMyODxY
 sbqe1PrdIgyp+9Yo5pbZp/MgXSd7lc75vMkVNa2FO7PPNgEyoJrjcMDle4yhpsKz89ymNTaU5v18Z6J2+eeff6t+8riEHCTpXi4GzsbGANcfbum8WlaBhFIbY2Z8n8oIb5GvFqJllbhamALgpd2MXztllxTvyy/8g2BjVb6+1wOarmJ3S4CTy/QXid37WdqqcCmX5GwIAPqIY5UbBighSWmwQ6QZj+4pJT1mPqKpFH9pqw1YrzJj2kQAndFX4/zr4kwP9ozAQKLBTni5eXyXNdURqnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:33 -0700 SJ Park <sj@kernel.org> wrote:

> Misc cleanup, improvements and updates of code, test, and documents.
> 
> Patches 1-5 cleanup DAMON code.  Patches 6-10 adds kunit and selftest
> test cases for recently fixed bugs and a new feature.  Patches 11 and 12
> update guidelines for AI review and what document to read, on DAMON
> documents.

Thanks, I added all this.  Along with the fixup for [02/12].

