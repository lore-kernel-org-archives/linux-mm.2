Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CB6FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D147D6B0088; Wed, 29 Apr 2026 09:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBED6B008A; Wed, 29 Apr 2026 09:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C026E6B008C; Wed, 29 Apr 2026 09:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1F8C6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:31:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CC084020B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:31:39 +0000 (UTC)
X-FDA: 84711680718.13.96D61EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B9BD480013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:31:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZyWwFsx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zuq/w3TaXff21OSey842+qhd0VBP6fb9qsimCqyBTwg=;
	b=kVSPyTTS0wJrLVxOZ75NRdOMox43aYWEk8PHm47XS/fVX7cD+U9dIeZN2KLGZHwT+MxcOh
	VxBkKWvaUt8jGTO56dPFNKlQ5wb9v/himY1v1O+eOWStC1OMNCRXHky/h4AH+SIHYy+qgY
	qBmVURmtTubBXTZ/RWAvgzecIllPDPA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZyWwFsx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469497; a=rsa-sha256;
	cv=none;
	b=RVOE1YvZTQTK6DZCMBfAZZyqc89eQ4oP6AZJn7BW7D+/zRPQ5fuozRj3dpi33PYeocnOQK
	1+uIa2Pfr13CRNSWHdZudGDxPUd3MH1FpuswTVbq/aBHiNCddwSuGAiT6B/oHnx6wLFJQM
	k33c9W2CjpWnS6V3KcU4x/TOEW6hVVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1276A60139;
	Wed, 29 Apr 2026 13:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82326C19425;
	Wed, 29 Apr 2026 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469496;
	bh=TyNwwgGZSaQ5uL41nEjLXgK8OXpxf8GlXcLnI51RXSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gZyWwFsxbl9VO4ExQ7RswjDD98S4DYNllnrro2IpwpXiDJhyehCp3w1quVs6/vnj7
	 BuicI92tEkOUJXDM0IGjZ2HKg1hUEdgGEOlH0JaJIKvKUINYb9omTyuI6mHU54X8kB
	 YKeexiahHyt07jEM1tBa5j4kj9e45kU0AT5bl/6zZpHUxuotbiyZdtxZ9jA48Px9no
	 mUK67MPxfltdVdqxioaOh2P1m4c2+FFmwtuim7WkcoG87/gNl3XHHVNqvuXl4Tkbxy
	 39b2pcO3eCv/HQ0Ou5l/SvQ8Hm5QlOKCDIORxAdGzHIofWoOzz3AJPoyw8zmcgMry1
	 UClQ96VFlf7Ww==
Message-ID: <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
Date: Wed, 29 Apr 2026 15:31:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
To: Darko Tominac <dtominac@cisco.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
Cc: xe-linux-external@cisco.com, danielwa@cisco.com,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org
References: <20260429131522.4049054-1-dtominac@cisco.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429131522.4049054-1-dtominac@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ib77p8onmqppbdxywac4ijk3pwd8e6hu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9BD480013
X-Rspam-User: 
X-HE-Tag: 1777469497-599846
X-HE-Meta: U2FsdGVkX1/PHEGg+dJQnYL8zigO8Xb9A4q1UWAOOIvy4a6n7xfLen3Vlvzz1ox1rucLyu/8a/wb2MIhJ1iNRvkDUNDCD52IbVyZ2VYqfUX+36B/IbJaLEfjUXa8ig6nvfRA5y2fLATlek7IAbfY59+ENKNL/YfJXUfpZ1JTVPyNFEfsCO3NXTfXEf7ZKEqsIf3EzdYyrkzWmiPL7wLIeYgZ0Cw+td5gsgDHkcv3e+v3FAkbeBveolcjWnQujeItyS+ukq43lgnN6h2CV8w1wNIp/1rhiSHozpYaKrOdRW4E/Tt34zcyMjbg+qY1H9n2po7ZoV+q9NE/tZDpdrXLQXxapZ5I1sU3z1gyBLCLGLvt0NFJxXn1RzGmqAKcDu/r98mKYh5uq0SQHmM+dsPRLlBGlIun/LFHgu/1RrlC7D3tuj6A4TxB7N7Aolyiu3OHZDQHC7WAsW35BALQ67NbxAbqTw7rhmv1WkWlFwzoiJNqOdzusOQtaurA9OxffAEPkGX2r40SgXsTiS608QMQuoMibW8XXtWfKolbkewBixjtc4dv2SDejE98xGht97UXR77GL/5eNJRtgJO7sMRw4VWEoqXl4vR4+JD2JhGkHug8v/QtTOmz2FVoQLVh11atqg2MoDYKJ5wGGxZ0JIpvzBmciAdC6tJrOEvB38n/OY3L0ToZQ0fJwRMbPVkHQEuZ9C4xfTQPcK19yEDBW0N7Ej4ziZbzvdfGcCOkZYN+stWPor/u0jXvClr2wea1rsMrTjpDrZOtJr0oG5AcH1zafejbpNG4MEuBoBcGlPBe7J0vvKJudq067G43+ZqzCQxwqemcwuq/PYy3GicgS40i6nfvyz6wYWf4ae28PmZTRWKXkF9mkCbHQ3EN8bx7IjaLFb/oBk6C6rr3N8BYxErqJQuRXiojG5elM5dTG/fpp+a/gYEEtRoCSO5f4KqLxWNsYrzyuIicMsLZRQB3gUe
 pepBfKxb
 Ed6N33VYEY20a5/ZiLK3sH3c027gL+KmeYWCrX7GV8CQJujCrRPs1NxW8DP5QI4JtgYVSDa5tupTNAslsEZwC6N/0wVFCsPxzvDApuW49vUexjUQ7BsXKZIRXvPkmIdh2dKPDKf7jTdiZrxYm8Elwk17ExVqsLO+3hVbCk1P/RGN7KOwLIAbfyEeo3IHmzS3zJ3hKOJd/W5+EuiB+qpVXEFx4P3wA9t/DfkgOruQiAjXo+HrX8KQWsD/HIHgF5bY3XzeYV4OPgouWMXUgx4nC2K28no0B/K5Hk6INPNQCN4qjF3XHKzhjx/mkpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 15:15, Darko Tominac wrote:
> When uprobes are active, MADV_DONTNEED can discard file-backed pages
> that contain uprobe software breakpoint instructions.  Because the

If my memory serves me right, uprobes can only be installed in MAP_PRIVATE fil
mappings. Installing a uprobe breaks CoW by installing an anonymous page.

Not a file-backed page.

> uprobe infrastructure does not re-instrument pages on individual page
> faults (uprobe_mmap() is only called during VMA creation, not on
> page-in), the breakpoints are silently lost once the discarded pages are
> re-read from the backing file.  The probes stop firing with no error
> indication, and the only recovery is to unregister and re-register the
> affected uprobes.

Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to
MADV_DONTNEED debugger breakpoints/set data etc. :)

> 
> Note that MADV_FREE is not affected: it only operates on anonymous VMAs
> (madvise_free_single_vma() rejects non-anonymous VMAs with -EINVAL),
> while uprobes only instrument file-backed mappings, so the two can never
> overlap.
> 
> A concrete example is a userspace memory reclamation subsystem that
> periodically calls madvise(MADV_DONTNEED) on file-backed text pages to
> release memory. 

It shouldn't do that on a MAP_PRIVATE file-backed VMA. It breaks the programn,
including uprobes and anything else that breaks CoW in there.

If it's using MADV_DONTNEED, it is damaging the application.

MADV_DONTNEED is not for memory reclaim.

-- 
Cheers,

David

