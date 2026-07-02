Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C261C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269AC6B00B5; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AA66B00B8; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BE66B00B5; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD79B6B00B5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:24:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90177140121
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 14:56:07 +0000 (UTC)
X-FDA: 84944136774.07.135E3E3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7A99160015
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FhWJEmba;
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783004166;
	b=6XFN20B59GZXc+vjZEMHYDojRgeL8qJlCTVgVQ1tmQLzz0CSeKiewAYYHBAd6spTDpwiuA
	adNJkRUzFsnzdoF680UE886+Lb4fGcNSxOGtI0pl+vnL+T9CS/3OeXPa/TuWs3ahOrb6vm
	AZc46Kr5LZ7gzAt4wQlsNA2Y4nRbgRY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783004166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5zfo7gwxlXsH8BZgYvGWYJB1jbxdG1g9whcrQZbPWA=;
	b=j/P5Oo9oYsE90kZQbzWIt1AhZUel27kn6Q4kJc7pdlN1p1H6fSVTAR/06fpUmM9Cjv0zdm
	jWXNeU0aK+UhuDoZpGUUYwDkzFTgvhtMWZUIqsaUvxdKCAeKTfvfD3w2BjdAyWn6hrFT8D
	YWsSXxwVK2fTatXMCevGfNuHk32a9XY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FhWJEmba;
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T5zfo7gwxlXsH8BZgYvGWYJB1jbxdG1g9whcrQZbPWA=; b=FhWJEmbaGn6UtsXhnqmiUSuk42
	oACCjFIyGz/kt/5rJT4X3y6beox60aT2V75XC1G+ptDHmqjKnSAmjOx2x1h6TagiUA5nKXTRYTbTS
	imggaPZaZHVbnLkjVW+RW6xdGKAP34AdwblxmWNJ1gFZvOfOZbtM7aDTqztig/cb/Htcdd90dVBHC
	hSrfA3aVx1FdAl8cYGJkP2igPo1dG67yeNpwKdc4qe7Ajk0A8yC+XZeskDbjuXgh8fVMLgyXaxHyI
	gAPqHLvOCIIEaH3cB4/QD88kOkCcovhVZvjgYFO/S6JpaGDHYSVi9juyoSJbNjtNXrPSXCeY7cGm8
	eRB4QPPQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfIpQ-008heR-1v;
	Thu, 02 Jul 2026 14:55:48 +0000
Date: Thu, 2 Jul 2026 07:55:42 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <akZ4tzQw70x3RR2D@gmail.com>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
 <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
 <akYkKgWOsYnw6ETE@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akYkKgWOsYnw6ETE@arm.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7A99160015
X-Stat-Signature: acopf8pxo5r5kw54b5n9k1c93nb6u8i1
X-HE-Tag: 1783004165-224270
X-HE-Meta: U2FsdGVkX1/mT3oyDyiJqivT8xIct70MWvuOt4s7vF2WhbMrh89aPMCf1ztGb2tU9M/ADnVbqDmUndQ9RrLOfSFHTQqljiGLhHS9lX9f0Qs/8RcPDOxDPUuB0pTS0vEKkEfX3W4kFcWtiT5mMicsGEN6BO4m3/w5YN8UUcAyMiCF0tk0/GN4L5SMV8k41KFI4YW5apnJovtqqVJ9fV7IC/dafq2NC2mgXgOqlBgjj3qFTp1OkzT2SS8qKie0WBwc5nFfRNXa99odQkbT6iHNrbJc2M5CXbxuZCuM3K9nUcPU2k4gP6jmRgEvUQ7bQAF2S5/v1BUTgiByGuKjIy9IkaoiD0OVeNHG0biDjvo9nOVp6LAs86ZWRoR58w1GCH4ccRFQg1qrPUqPzWAXJ8i4NYfIKOjOZHDBvvJgPU6zVUVFphuWLff5vyqVpk2iJRAjDmqZKt4+sEv8EodlJPh34lQL9zhKixtYe84uN2ztWQWkIygBbghY4KfOQu8RFO+TpwZLheVWVeGQjfP69TLkOQWm5xTmenslPcaATf8MvqpM3WmikgGC93B9idaEBsXVLBtdPoEOTae1GqA+J8Dj8MK095E4SHWLqadv3twQgcvf8WW1k8mps3xOn5XFV0Q3kA1FiLDI+RulAh8iTTVtcdFbF+E+WjzTvvdGET1UBkBM7Zl+5LlRUqxXTfvr3xYy2fWP9VQ2U+vLiuPk7eBE02fSKVObJY7Ba1Yl7uBKA+XQijFdiQTHIQH5qqQDNXnVS1hr6l7qYViYw++SDdxKV6oQNRJb4K3bhkZlFsxTa1MNQIMEvrPmRk+gzuGtOVJS6m3tIq3i0QPx0+nv8plXjlfYiRz9no0RPz3gWghBK4wLP5Eov8v8rmZq94SqPA7MgBUVNaJkbImq3SQvUqCmeJsBiZuKtx9/NE1RxloQSAgZWVygqmZniiUnTervh7eCWN6SELrfS2mbOZuOd30
 f16yl4Xx
 5h4CSfgdRtwk6az8aTqUKKRBAXq0u+f9F+oB3HgeGqbCaBVoDJhB2+Wze3knb2p0Xv5JSE7Aja5LOul3p7JvnU/o0Vp7QcsewWsIjnePfbU+waBH1dVkFAeBV+wh6X6N9ZJx8/jwXRLvu5Bn9HJGZ+RBd4/OXiUdO/8xkNrYGmel33Tj58tetodx0aWekJXBJXqwZ/0kMkmbSj5eudyRxjcgPwvrvbq2YSjf2ttjcYu8EAD1EAZZ17oRby2WOpCg1n3tq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:41:14AM +0100, Catalin Marinas wrote:
> On Fri, Jun 26, 2026 at 08:52:03AM -0700, Breno Leitao wrote:
> > +pass "min_unref_scans=1 immediate; =2 gated to 2nd scan (counts $first/$s1/$s2); param read-back ok"
> 
> Are these off by one?

They seem to be OK, and I've tested it multiple times.

> Kmemleak has a mechanism to detect live objects
> via the checksum. A side effect is that on allocation, the checksum is 0
> and only after the first scan the checksum is changed.

I got the impression that checksum continues to be zero for these
objects during the whole life time? (weird). 

If you think this selftest brings value, let me investigate what the
heck is happening here.

> On checksum mismatch (i.e. the first scan), we mark the object gray
> temporarily and won't increment unref_scans. So we already have an
> implicit two scans required to report an object as unreferenced during
> its early life.
> 
> I think this test needs a priming scan to update the checksums
> followed by the actual check for min_unref_scans (with scan=off,
> otherwise random scanning will skew the results).

I tried a priming scan and it actually breaks the min_unref_scans=2 case

