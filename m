Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD16C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CC96B0088; Tue, 15 Sep 2026 19:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2349B6B008C; Tue, 15 Sep 2026 19:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1726E6B0092; Tue, 15 Sep 2026 19:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94AF6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:39:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E6668059B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:39:32 +0000 (UTC)
X-FDA: 85217615784.03.4B04AAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD10A4000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:39:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oOejxibo;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oOejxibo;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789515571;
	b=nc/z+4QZfrWkMvja6ldFJoD7fruAzFU7kwlfBAl6urws/ZoiEKgPlbsk1/b+OIelxWX3FV
	4Jmnai6YuFyBz0Qt8BnDDOSno0nycFYysQoxLoU4IrkCEmcoqAll7QpPVtKwWQ6r7JSlHw
	/IAc2y9zJoZbKT2TfQrNTIJuqnT8bXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789515571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4m6z6CRskb4Hb1ZLGj5f4sRG4VITlSDdQKTs+jezx5E=;
	b=1U1fVIXNhMoPPEdqRo5p+bTV+BhHMlABm/Y3hsuoClEKbTcMkAbGw8gm/dvLhX8Y2is+Vm
	7T1c4Fmm9qaxCX5LCxI/Ckv5zJ5R+7/Y807noupqJKVU3ez8ovFyGPTLM8jZe7l4T2payx
	82Uy6LH/R145Yy3UWA2+g6t8R5jOVEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2A6B408C1;
	Tue, 15 Sep 2026 23:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392231F000FF;
	Tue, 15 Sep 2026 23:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789515569;
	bh=4m6z6CRskb4Hb1ZLGj5f4sRG4VITlSDdQKTs+jezx5E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oOejxiboHlvkVxPn0NeFBbBeevJUCag7z37xbXN/w5CIeoOvk835Wv/hOl+kA09z5
	 i/mlUtuf4DlVmbIU5a4h5a2m9HWWRGSffdZdgKDJNYzH+ub5cE8X3+zCtjGERAyTau
	 RgyOda1PsB32Ob5dwbCdraALkMRWVwi14wMuRh78=
Date: Tue, 15 Sep 2026 16:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: introduce hugepage_size probe filter
Message-Id: <20260915163928.9d6260f445d895429d115fd8@linux-foundation.org>
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD10A4000D
X-Stat-Signature: s7sgiwy8kbew545tkdm7mt645p3k5m9r
X-Rspamd-Server: rspam01
X-HE-Tag: 1789515570-897502
X-HE-Meta: U2FsdGVkX1/MJ808U/nMPjnhh/iLT9N6dON3mSvD8wyutPKxQ8tlErxWtXvcdrLx4vsA7HU2vX6GL1SOO7/bO/ksHHbIbZtRxv4gXWquMghttTsxKwL30VWIeZu1k7T7k7tw47s15JvMx/VqJjlRhUcOhAmuH61gCwpkoEvZQwrGdJwp6VrNCWC76QuiesxBToZNeo9PTVTLAAaD5d8e6H4ZvbdYkzkPBVGYNgpHIwPB9mtzeuwxbMn/VknLLQbvwPLHmHgpf2hABFpja3y/grjY5hv0T2mk0JQpvgJb/h2BSxUs26TXtKIztoKv4KKxjQpqaj68p+sfczr4L0ORzphojx9HhKLSFTm304W2n5rJUvV4NRDQ2mxVHbSKYqTnloL9/UiFsQAJaPf3OV+v4jJ5o5+jkcmE8gDsS7wez2F/VvRpzMLbLKwA0+k2hHEaLCdYKKtuMIn2aUlPdhyqyFKETvdWyaop+7C1uxM4gTAFhM/5QH3HvjIxcY7GEE89o9uag5ZvdbLDw23/iWhEtqoIGNrrkAMfMFXUart/ydJ3bLVi4rIFdeiyDEukLB4pVKlaww9IRdF0Jpy7yucgGMCFVF5wU1DBHqHG7+EO7YY5b+Thee9SFbjNCk7GdOlUDPJSszPz9ADqbWkMiTPZWrsShgm3uzVmffMXtt6AwsGI3wDTON7YLLO0MlvfKuwTVFh366sTYJ/S+ZtvIkuEIqU+OtuiaHlYOTpIJuyhZVcJxCMxiCO3gpJW4+O+srGIlLMRb9gz/V0H26exA7CCmi/Ip3R33zeDL4Tz+vzvMXaUOehZmYnr+lHlDhKsft6ZoqSawDyLQCWp78UAv+lp9BMr6hu1ry+wTBe7YS7f/kw1c7gHTJ2wHyhCceAxJ0CQMpLZNTBvhQVEo5ABdy0ZGjLsZ/m3hnJNLMvCnLTbRw0OEGzE/L0T7sCdBEUVZi/1tzRiudd+SNqZSiKyAt2
 biNwNzAq
 YSic8eL5KrZx0LKvoKzcw+mBomDof+rQFLOxFGC0J/i9NY7XXYnUrGHWcKtcZqEFFthvB3/e91Ef55TGSy8nIPEL2LX9oqaTiBTeSTevsWOCdmVn+TcNVypF46rDn7z1nk87UDi8Hn2N843cJ8IZsPTmVWr2m2AIcx4VRCbnQghS9FycKPAIRYaY70xtfhnErJMLI/qwQoJ0qrWk0yriXm67eHCKG8P/01Uj28+wNbZ3jrM5E8Snt6DUDO+jqFcbANqh/E7wQDGWHYx4jzN9/F81brErR19D9q+WOr24NO1VZ1gsR1nV+3rOK5t8yqox22FKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 07:33:49 -0700 SJ Park <sj@kernel.org> wrote:

> Knowing whether a given memory is backed by a hugepage of specific size
> is useful for efficient utilization of hugepages.  For easy monitoring
> of the information, introduce a new data attribute probe filter type,
> hugepage_size.  It works similar to the DAMOS filter of the same name.
> It works for memory that is backed by a hugepage of a given size range.
> 
> Patch 1 introduces the new probe filter type to DAMON API and extends
> related data structures.  Patch 2 updates probe filter commit logic to
> handle the size range.  Patch 3 Updates the filtering logic to support
> the new type.  Patch 4 adds new DAMON sysfs files for the size range.
> Patch 5 updates DAMON sysfs interface to fully support the new filter
> type.  Patches 6-8 updates design, usage and ABI documents for the new
> feature.

All queued up, thanks.  With a -fix for [7/8].

> Test

fyi, I'm always reluctant to include testing info in the permanent
record.  Because it's development-time info which becomes obsolete very
quickly.

It isn't useful to someone who is reading the changelog in mainline in
2028 (or even Nov 2026) because the patchset will have had far more testing
since these words were written.

It is of course very useful info but I suggest it be maintained below
the "---", where all short-term development-time info is best
maintained.


