Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F9B10F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4277F6B008C; Fri, 27 Mar 2026 15:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEF66B0095; Fri, 27 Mar 2026 15:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C106B0096; Fri, 27 Mar 2026 15:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21AA06B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:42:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C971FE1A27
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:42:53 +0000 (UTC)
X-FDA: 84592865826.27.4854FB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14B95A0013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:42:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PkOvVF7w;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774640572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XreVp1Kv2r82/Qyc1/OwNMOukhJLk7YYdp+mTT+rmN8=;
	b=4mN2HrArPSiXYS36JfkCRlmpD7xqONbjgqzlzsgZdCBN0J1D7TkV5IqXHyUPPEtOeLwN2w
	camZynpluLYNZJP39T06j+777cq/jf6PB5FgqTzeIQ+v01g9VlC6gWz45LGpX/iVPFkEK5
	+kr39cUf3B7muoJYMb8fr+i29MT1mb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774640572; a=rsa-sha256;
	cv=none;
	b=Os+YEoPs5QIKC5c6SfZuY0PzGbJ5VsjhHHKnmTMD13ejUHEc7Kr6D0Izuxu1vmosFA2GQl
	tzYkQbGLKUOnb+UTPEnXfGXI9MM+4zHaPs2PTAYHbSiBQdmiV4W5dA+XldNT1M4aSmoxb8
	FOKMiGBZX6r7vyVUGaGNU7oMZvxMOeU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PkOvVF7w;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02B3B43C8F;
	Fri, 27 Mar 2026 19:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46674C19423;
	Fri, 27 Mar 2026 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774640570;
	bh=5Cf1j8Aqd21BWFIFt8KcYU6fNdKQMFl4Tg4msm+5b/Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PkOvVF7wyyUsOQ5zORNmVnU1qLxV5bvgMiidF4v6v0Wan5C7/xVcA2MjFxe3NJwjv
	 +PDurgOV0/+KiA9o74QEjfFlO9+AHvlRGp4N0f3CWFkJ+uqBPS9TdfSSXs+zbVzvXz
	 QKsjEGu30vz1DQHRt9ciUC9Yoq7VYSRIfNbBCkJ8=
Date: Fri, 27 Mar 2026 12:42:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>, Nick Terrell
 <terrelln@fb.com>, David Sterba <dsterba@suse.com>, Vishal Moola
 <vishal.moola@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v4 0/3] mm: Free contiguous order-0 pages efficiently
Message-Id: <20260327124249.a8de2259cf3438c5f4216894@linux-foundation.org>
In-Reply-To: <20260327125720.2270651-1-usama.anjum@arm.com>
References: <20260327125720.2270651-1-usama.anjum@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14B95A0013
X-Stat-Signature: yyx7kwrm6i6b3j8wcam4b7abikajdb5d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774640571-917549
X-HE-Meta: U2FsdGVkX1+s6ED5oLrQbEsMwlP68fXDvs928GQIMTd6ksBxpvqvA5hzl5WDs5laQpqc2e0cVfZovh/gTexa2nxnx85QZWTP8VZ16Sk/bjXWzULnezHC4pLVX3UJHwrj1wCpWrCnuBzrUDw5XvP8TplloucVlXUhs48QhKsY2v6G4pZVu/s99FTgUPtd61X0gdUzAq3bHt0gxYBYjnc81lg1ewWQnqgvB6M5wJEGE+f6NGD8dT4oAZQsnDBp1A1SBIJ2BgxL5LORv8gCpaCrbL12ErP317mftyiX2Hx9hnTBJA2wuLV0bhPqKlwyMqvvBAYXvKsrqGhM7whmcZy6vrNM5NFOAC/86qGp9ZN09Kp9OhxiJH9/40j1Lj1pM7FYUFj/qm3ySRr1SckAdOb1LXJUWvSRI6v4pbwZ985fYyW/JOnlxzIg2Q3M0nYf8paKIjjaR7rWWGM0yeAMs3/O6MjzyO/rti8AnB8Isx1P7m4XZdv8DAFETW9Cr4sB75FsE0V2wEuIyARyQvGX6GaF58FbGnLSS1CxG+/fezVsokPZ8ee1dojjPSvn5V38ecqFAuusGSk2KAhMX1w1FtugCqhVxPVbUz/V40Un7JMy1jhUTIOMxOQfOtYb0EtRwie4Psr6d7MyrVPEXhGJsFLu9NqnOLXm0moPLspUJlQred38sP30E6OtrMC3x1CNcTwEgYnYaZ3dJZSz/TKXeCJtMF5lsnYb52NJySVj/g7VqLwp9RSahyv+MM4MzUf0FzzFlwWYWDNEWzE5wBeZOI0r3kwQCziqZCkDCMwsTckybqAqMFpDgGFO13wQ9JaF58OT6U4MRhPmrqCOVASwD8i8AqKqliPNB+oZvISC4VP0XcYckHL62srcI+Eey0jDHtl/qZSrPcdhp0oaF4iWkOXDZE+9woukrcC8w8ABNXIk5Dlbm5o2wPLl6c6hJg5NA040khjBPaMN5qiz7uqKt/S
 2fJ6ofvF
 oXwiamoN2P1OAKQ/cPAOJCyj+k4sO+usjBUcYH2zxfoL3rBLo8/FokyyLp47HIAVBpf2Aq4cEuWr+0kzKOnDUx/DNRCBQIDlnWEH2rleYhKad1LLnFyAPo3Wl0p2S60oas+d7raJqdS0M3h6Q1AKcV+dl7Egx9a+ZWkmp6YBLeWKMppoimtvxuJscMBpB9435ZQsuRr0Ssg8xUr3lgIrZrZi6CUTOFQOzdWpNC7bHv0jSFh7Zzs4Ra9Y8zpRyaSJZP8gJ0JdiIUuiNuWjqPepskQwhXMAofk2PsKeyaFv2mXICkxLMSzA3PKum0XBqpP5IBVEWntBB0WwPNVJxgqF9h5P6IWH42+ygTAu3VW/vWAepczV3Q1205BsxTLFf0cHDQqjJ0F2RSjSxsfr1UteyMK39XwMCuSaRBBlnU4I8sjFGsc7OXPj8dqBdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 12:57:12 +0000 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> A recent change to vmalloc caused some performance benchmark regressions (see
> [1]). I'm attempting to fix that (and at the same time significantly improve
> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
> 
> At the same time I observed that free_contig_range() was essentially doing the
> same thing as vfree() so I've fixed it there too. While at it, optimize the
> __free_contig_frozen_range() as well.
> 
> Check that the contiguous range falls in the same section. If they aren't enabled,
> the if conditions get optimized out by the compiler as memdesc_section() returns 0.
> See num_pages_contiguous() for more details about it.

Thanks.  I'm seeing impressive speedups for microbenchmarks.  The
speedup in [3/3] may be a bit more real-worldy.

Do you have a feeling for how much difference these changes will make
for any real-world workload?

Also, AI review said things:
	https://sashiko.dev/#/patchset/20260327125720.2270651-1-usama.anjum@arm.com

The can_free one (at least) seems legit.  I suggest that can_free be
made local to that for() loop - this would clear things up a bit.

