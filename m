Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75338FDEE43
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9196B0092; Thu, 23 Apr 2026 14:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C635C6B0093; Thu, 23 Apr 2026 14:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A626B0095; Thu, 23 Apr 2026 14:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3D96B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:25:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BBD314041B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:25:12 +0000 (UTC)
X-FDA: 84690647664.14.0FF8B8A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23D43140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:25:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VupDhkN7;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776968710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1v7YXfUKlUQLu//wZ3hNgODosNPo4KQOWQbzpNH9LY=;
	b=LU2dEbyWhUA2FHLDY4PyNU12Vfo2geNQyCiJb1TbRMos7gkofiBSWkRert9okuuxSZb7TV
	zl2OFBf5CZ3Mw/1in8hESUjz/5tz39pU1i11p9HXVZIP7XBfWK/dHeLDHQgxnVt9A0al/Y
	AYfq1HK7cAxzSbWxyVy2OXmXiAko/vI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VupDhkN7;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776968710; a=rsa-sha256;
	cv=none;
	b=oqqq8JofmRAGg/wL5bDNI3k4l+hbHSNBke+3EgFdf3Y5DKgipxSmdomOZGTWVbaIlv9pYF
	AdJzTx055ol/LXCHtHcBRPKR+h2Moyzf1mPuHzOfsIWYWWkhCHpCC7pXzYhu6bdBxJMISU
	ehMgzw8hKxFMHQ6YOJUPuNbioiYFiD8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K1v7YXfUKlUQLu//wZ3hNgODosNPo4KQOWQbzpNH9LY=; b=VupDhkN7jh55tw/v8z1nCQCRtS
	a5rwRuyMoi1qLtCB7d4TSwscdnJ5nvfS9mMSjZ/FyucE5+1iUyz8Ueo71f/HvhUlhrHs3ln86lrtn
	nAAu0Vl/sXw3Kx6k839tg5cjhSw4541i9GY9sSZMqsEraACEjvO4Xy7e1Z+8Eh0Lvw9mc0lESdqp2
	FxMzFPxOACahRKO19r4gRtqvUQkikjVEazmEaQDYSGuFrhfQXZwUi4UE/8NAlDgVbms64vtH34yXY
	oTPsioBtZVjBVZcUS09vF9dwJCBKcZZPT0aA5EmiIuupEearHCjcO/VBELR+1DFHrxVqscPsEFO9I
	OtLPloZA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFyjP-0000000DrUt-3u9E;
	Thu, 23 Apr 2026 18:24:56 +0000
Date: Thu, 23 Apr 2026 19:24:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Cc: david@kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, baolin.wang@linux.alibaba.com,
	gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com,
	kirill@shutemov.name, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
	torvalds@linuxfoundation.org, vbabka@suse.cz, yuzhao@google.com,
	ziy@nvidia.com, artem.kuzin@huawei.com
Subject: Re: [PATCH v2 2/2] mm: implement page refcount locking via dedicated
 bit
Message-ID: <aepj9_v_1dYJ_tRu@casper.infradead.org>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23D43140002
X-Stat-Signature: dstfhyac81ju5g6s5gr55rswy4bbqgrh
X-Rspam-User: 
X-HE-Tag: 1776968709-588358
X-HE-Meta: U2FsdGVkX1/jpM/giZxbtf47/Z/jOX0cug8AgUboe87f3c2K9uZj8zCKLB+zfwT7iI2ZPkrh8hTCGAlMBw1oySowPV4IoC0kkJmdbq9l3U67DVg7eOePKINvR8fvwnrLTlK8H3S9W4K2Y0YK8ZKGzC4diZLedUebtsxtrQ0c1YdAgUoo6TDmzTUg+OVaM45YPGihsFyjEP7wLyE8W9jCjz+h/cAm6Rdo0C4hiooj81m/t+aWSCljb8qWR4mQSJCS2Xxz4mMtnwO+StWSc3YQsnY/szu8t3aIfcxlnbIwso73jB6p9va+to/VdRaUnoBfKfu8IKna5DuUKUCgGU+qApA44ooEmmslRIBcfb3fZKZVpMiRglT9J5A79S21+c9uWK1HlIfsJuuifMNHK/E8Ry/8gJfBz/kjStHfHC7oFg8Itl23PcHNZXiFXCAwSYqvTSNe6Prlse1UEZNy22ndwx2RaqkZMPPrFyCQpjc7d2Uhanf782W13uZyjCnfLj4eKKXPryopKBfPkRAnAUYmQWxWjN1x3zjAHEKTqs7iWa10ygZtOFZqFoqp/f1wxNFFskx2Kr0fLcxwK8ORlIdBw1AyfH3PwAy3whz6VR5q0OwhuMaLU8AIou2d8d7gzokaF2ZH2EXaALJmGwbFJ/O57le2ZUwgmtOM0BrIUBWWo7Dtj9WcJvNOy0vidcLresrz2WAtE9D1Q7zJR2pzm7OQwtMYSV1+Hw2sF4f7GEJ6zWjBBUtVyDjA8ac/O6MIFxAS2DPMCbwOpil8wn/e7OeASUh5jO0VFoJ5d9Yxgx6btG9SzYLeC1S71X/SqDhsTOjOxiQ4FwBydOposvcmleW4UHkIe/ffNgjQ1cRxGvAx9p5ppgp0rQcS7exUNlp09OJFzD/L/aF/fndvl3yvLpiSug8aat+SRwr28t1bFBwFSlJhRhSwchaJwERSIRnwpTUmaTqMm6XMy2NxIKMFuxq
 5r9YRV/r
 mOudem1VAt+smyLR/sF/DVuL1f8t3GXuRlSj9170vV3T4TQebyf4cSmhro+NolZEoqK5RjHTfbdkRXcLW8Kv/N2BinCURICNxeV1rI+lR944OAyURAcybrR0/DeAAvcL/vrjUrm8EzYxM6Iy2ciNxVoqjLgD/gU7E+FvsVUhPb+pgdC2koYSCAOnwohFAktMtJ0ClcwObmH8xEwrtb6Zvh22TouN32BeHDDm3Vu1qs0+e1jbyJmz/2PVYjgo5hm+uA2vvoQjVSZ8nzGDiGjZ8bcZp4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 08:01:19AM +0000, Gorbunov Ivan wrote:
> The current atomic-based page refcount implementation treats zero
> counter as dead and requires a compare-and-swap loop in folio_try_get()
> to prevent incrementing a dead refcount. This CAS loop acts as a
> serialization point and can become a significant bottleneck during
> high-frequency file read operations.

If the file read is high-frequency, then for the page refcount to be
the bottleneck, they must be small reads?  Have you looked at this
patch?

https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/

