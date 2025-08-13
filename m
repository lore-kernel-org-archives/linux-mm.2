Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3433CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522EB9000D8; Wed, 13 Aug 2025 17:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FAB2900088; Wed, 13 Aug 2025 17:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437949000D8; Wed, 13 Aug 2025 17:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35770900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:47:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC9E55907C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:47:40 +0000 (UTC)
X-FDA: 83773071480.01.F010B7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 46A0A40012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:47:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BzsGehsF;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755121659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ehvh8MePh5hlLwOPCl48abhuCtcc9carAot7fWhtO4=;
	b=HCGsbI8uYzGkr9R3eAcU5J6z4HbCf8vjHzhioEQTIJa2jLnXConC1mqYuWBdU6sO2SxFIB
	95BPM0E0rJFlnqtndzEL3Gs0IDR1dHYYzfdpMevIpUAbeS0JrE2IxyzBTZIdBxY/dS9eD/
	VDTtTbGHpdaSFexOHyyTpV3YXYmpP/k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BzsGehsF;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755121659; a=rsa-sha256;
	cv=none;
	b=QMqoJ2kTYOPnF5E/SR20zI1djh6W9og0yVpNqBC5aBEu5O+Fm+VEkdWt3gYxFa3S24XvJF
	yfXsPXVcpZfiEJ4ugE+pWCJiBEXFAdhr7BcZhunCqWAw+ZCJ1Od48eilUzSmaHO0ZskyNs
	mMcbRUqmBDUQGd4Gi6Rh8F/NLaFMCu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A78F601F7;
	Wed, 13 Aug 2025 21:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0572AC4CEEB;
	Wed, 13 Aug 2025 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755121658;
	bh=9owTMvtzsi8RT8rpO3avGMKwTlUwvjGyNVoc27VfaMs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BzsGehsFkISgFM9oRKX+a5a0If+eYAOyaabyHYBqp6nLek4af8aNRZLJaNkaSGkQk
	 KidyC7bZOPQc2WnJWgiJcSAJSt3NzqXXp7Yfb4z/wrO232NE3sFnXcsnVcPPtIo8U3
	 X5WxE3Dgurymzqv0280RAxKZgj+fujz25nS16aOI=
Date: Wed, 13 Aug 2025 14:47:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 21cnbao@gmail.com, ngeoffray@google.com, Suren Baghdasaryan
 <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, Barry Song
 <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu
 <peterx@redhat.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-Id: <20250813144737.c3f388313fe13ff44856daf5@linux-foundation.org>
In-Reply-To: <20250813193024.2279805-1-lokeshgidra@google.com>
References: <20250813193024.2279805-1-lokeshgidra@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 46A0A40012
X-Rspam-User: 
X-Stat-Signature: 6ity8kmjs9jfjckcec9ycc9farze3s3z
X-Rspamd-Server: rspam09
X-HE-Tag: 1755121659-459210
X-HE-Meta: U2FsdGVkX1+T74Xw58af+nXTCtWS9HWI/2ALfSD5pYYkI5jRaff5tz2RSP3IKK3V4+s2vPNxaifTssosORMG+aLBrZJK36mqGvUtmT4uS4NfrDvHuTMV+IiT5ta/0Tyeh62g11SxmkDOupnnMATjzsi80Lskdg4pgW66uUD4TH6AD9NJVrs8LA2LUCyud1jKx8JTHW/BfzwKAmK2IHgKxAJaOy4fF9hl1FaCy9WeFlpGIq1y2dIE2tP6suRj9nZcYdkfL8M/KX8xeT5nwuCTNctJGFfOYuWQfaDb8YiHmxxSEOfopMN68y9/nzbLoi9M5KYqsX7C3i5sDkr1xj5/d4x6K77PVsiItCqphf41mg7wZSZE8IuXkXV8Uuj0hObgfSDgrU+L0P++FeNDwbY9sCnC+hzrn1iPm+1E1N3r3FD57DUSVasmRdW+FWWyc2k3cUS2GRUY1HxrE9djnOutH6Tv+//DPvbjkb0Dkrd92uxTaSmv5KaLXvVS7mOwfjviPHr4DxwJbYJsf9aPPtX+rqy2EhPUXa92UMJjPjpIQtTzPizDJU1epeS9sIT9vnCUW22M+egDZ3FAzXhBoWCk/ZNRxBZcNMLmUWjhMTK+IY8ZJlrudVABUIHWiUyt/ZT6CtIAN0k/YB1SOdnvk016c/GNqPaY/ifQo9a3Yq0gKMMj8mV4F0FKk2wtgPhYTjSEj6EK6Xdv6HRjcLJQ5T5Z1ftcY65Ic6Q3msBtM30E7tVKqeXo+i35ivhUStwS1u6Yr2/oDwVpBmTqksPPXYd5OlP0UsUppJ8ok0Lyygm0fTthMk3FlHaJXMTqDiTly5kIb38PV5koKaszh6EM9TZY6JV+dvOhCJzZuoCuIvh6j+lmLGQYHFM6VPptzSLBc9KTNhC28qEtWSvR9doul3PC4sxD6PLFVLSBhkmMw3Uh5ipaOBmPmEZMTgThRbBvIO8k1OAyrPspyLX6GZ1nrrF
 yqqK9fcr
 yi+vrTh8Xo8hMi/2yt25RYL0rvty/x5XmGOirC+5TO6cOZnTrCRiPi0EKGoKzA6x2gVvLXbnKL+iyuNQE/EVFRmQHuqishQVs7I0mcu5ZkLcG7VU9L338fCmD6mjh2qlwVGEOHYd+zHvLhw8zeaqiAWDcMtUH1Zix+GyhEBt9b4bgptNQ9EymeX+ew+gKyNCK3/Yd394cuLps2o8jR2FZEWTLINy3knX/XyvkCA6TRxC4qSl22tS5WZtyAaRSZozj44F8vg/tzcThoIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 12:30:24 -0700 Lokesh Gidra <lokeshgidra@google.com> wrote:

> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
> 
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
> 
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().
> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.
> 
> When the GC intensive benchmark, which was used to gather the above
> numbers, is run on cuttlefish (qemu android instance on x86_64), the
> completion time of the benchmark went down from ~45mins to ~20mins.
> 
> Furthermore, system_server, one of the most performance critical system
> processes on android, saw over 50% reduction in GC compaction time on an
> arm64 android device.

Were these inefficiencies a regression relative to an earlier kernel?

