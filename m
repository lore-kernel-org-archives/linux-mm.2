Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28DCC44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890316B00D5; Wed, 22 Jul 2026 20:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842706B00D7; Wed, 22 Jul 2026 20:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759EC6B00D8; Wed, 22 Jul 2026 20:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3696B00D5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:36:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B93E1160354
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:36:43 +0000 (UTC)
X-FDA: 85018175886.01.B591285
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC168140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:36:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I1rExJ7H;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784767002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fHddoiy2ssGES1+pkTKa3f6U/9rZANITkdG9dYpmkM=;
	b=g4PcrG2YJ/6/cbWIWHxt6IpaworxuYwc8YuWJbMtooshvUewh+pvJKiKg7+mhes/DfiaUi
	9HruixNaUjNumAA5xrW8FyhD/9TvIrQsX/EthNsPniTGPHjsMWlwt8L8gf1niigcIc332z
	muF7YvX5oLyV+qUKjOfUdCbeGaDMtn0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I1rExJ7H;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784767002;
	b=ZoE9wJ45vis7hEs09L/IZBcM9id3iFWNSA7rShJPFe/Bj5s1TZKpAIWFcAJj2pcnRGGNuQ
	HYgAOZIt7Jud8FVySIwOKELZLPFU4nBv54A0oaJqDYOr8lG1OjDUIW8Ahvqa4DWoqeuD87
	0alafsHbvKc0Zup2b3G6WHGmigpeqt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA74B43D71;
	Thu, 23 Jul 2026 00:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168AA1F000E9;
	Thu, 23 Jul 2026 00:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784767000;
	bh=8fHddoiy2ssGES1+pkTKa3f6U/9rZANITkdG9dYpmkM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I1rExJ7HbucjG8Nn1+3y6cPgEqcv0oeMs54cOuvhn1mFD3lhLjY4JHzpWproZDE9g
	 3v/GM6QlOwfpWIyAPWR46bGgxgNP0+Q4Da3I2NVtdmcJPsSwfvX5SbyX0g6Y/bYVZO
	 g5ghIaYOOe3OhWBMxnJkY100QK2m+8yxOBG6LgE4=
Date: Wed, 22 Jul 2026 17:36:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Link Lin <linkl@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, "Michael S . Tsirkin"
 <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com,
 duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, Ammar
 Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com,
 ahwilkins@google.com, Greg Thelen <gthelen@google.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, jthoughton@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix
 UAF during suspend
Message-Id: <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
In-Reply-To: <20260721005603.1710551-1-linkl@google.com>
References: <20260721005603.1710551-1-linkl@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC168140004
X-Stat-Signature: q56cko8gzcx3finersqtjimnpaf796hq
X-HE-Tag: 1784767001-508842
X-HE-Meta: U2FsdGVkX19v+OVOy3GqPHYBwB6R4jYxPqtkwzbb2b4PuqLfTGQBVYco7ljc6GlvqMWn7Obav1XR7p1ZyWUHKoQpMHqOVHVJkdXaqoRUVfHlvyAE8ATOHww6gt52AlE5Z4LM7qAJ7nkG/+gWsEXbE1CZgOQG71VmTMPe2JKrz+b3ExRxcHmFVTiZh+e9Dyf7PcGRn4gYeTxDXpgAoaa4Gc6Dnt8oDi7Iiy2GzvrHCmhrJUPIpXO7zEU2m8hg0PyjekCHp2rvN2AxFGGipU7yxZC7gbpJOtDKwHI2uVEZydJznLXRyGB7wuMs+p3EKiom8sSQ5gM7tFUlB+vBUepMKmtZNN2RTDnMbotxEmgpAgA0HbzqG93T7NfIzO2Ymd3nXi4h74V2qitf5zB5eSBHipB9Shg6cNDcrctnUVuSl+XOKfz3YvoR3u9QtgqB+eNqI3xgV/AgfRijjcIP2JoTdGnDeyIomr9x/rBjkuwA1gL62BdUh4ARb5Omguta2m8E2SoMNznDcSU+NrfR66egyil3Afj8PaZLvpBWIBsJ5qC4vHd73/f8euLSeJuVs+/Nvf63+CbSYEPB/RwRk1m+dvdk0w6hNwfk7tgW+im5iA2XSexpd8gc55etXLCXv71hgMdRgN+qsmzuG+++g8dRNpo5rJgv7dMSPxR8DObRIPrlG0vrGvG6nqiNdSoHYhHrQpcw/IyyBcoRVpIt7d5TghQHqjIc5QdusM90wPTG+UYPD59BVP1XHq1DQoD61f7m7IWpmS1EtDfWPRbCUAPc+WdZeHkC5sj15zT/Kh1gJS18kAIQXoP1eo76HlL2t+XjT8F7VFAQJffnIVGjKu1Xkqt98iXSOxuOS2UEJWR8WtqbF25Gyu537kjJpCjquQ6gj6Bm3ShhLyG7D0SbefgGX2+F3RzK9m458fcwLXGzBcehMsbOsuU54nsCqKu9jYQEkVL/JwehvgxO3MC+NKU
 9TRIbImt
 Po0tiDcDIMO3+H84hJ949q5/xNDycEMBIQeOz30CGCfhKqGqibYgFIy17cf4XLE9DQedcWl12AcErbNQM+lXaUqZhlxYa4Z8UQR/IjsMkhudjUt7NRTWvEinsKuDRYDno0yFr9E4IX3QOCNXkHoj9EgImmXcpUCf6WYwqUnKwPv/KNtWKpZ4Gf5os2WtXsQGaLJ0+tcRPaNt5N3r6z5+zM13XtlIcPyihHRxegCSnl9++ehV5CI/MasLyuj5PYIRI98XkQ/Rt7GsINNY54YXqdaes0tgsUVqPMgLikT2bjGZwUPZGTtS7mlkpMzFUxD14V74dK41ewZnb2mRhlu3Uv0iTYfdFl75qF3h6Oob4yQsvzPDsuUHnOHTx2p2JuRrICmlLKekQxo6b+wGnk/p4huArZe/T7mj+SactZ2CCjEUxpvDq7WH9Z+U4VuzVEtsqxcdA14bF7l6cFc4MRR6J+B45t/51G+6rgq63
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 00:55:33 +0000 Link Lin <linkl@google.com> wrote:

> During PM freeze (e.g. S3 suspend or S4 hibernation), device drivers like
> virtio_balloon reset their underlying virtio devices and delete their
> virtqueues via vdev->config->del_vqs().
> 
> ...
> 
> Fix this by switching page reporting work to system_freezable_wq.
>
> ...
>

Thanks.

> Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")

hm, now where did that come from.  I can find no such commit and that's
the second time this very unusual thing has happened in 30 minutes!  I
wonder what's going on.

I'll use

	36e66c554b5c ("mm: introduce Reported pages")

OK?

> Cc: stable@vger.kernel.org

The bug is very old so I won't fast-track this fix into 7.2-rcX.

AI review pointed at a possible pre-existing use-after-free issue,
related to virtio-balloon.  But I think this is a rephrasing of the
issue it flagged against your v2 patch.

	https://sashiko.dev/#/patchset/20260721005603.1710551-1-linkl@google.com



