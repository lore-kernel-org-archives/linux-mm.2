Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7B8C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D446B00A6; Thu,  3 Sep 2026 08:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDF66B00A7; Thu,  3 Sep 2026 08:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3876B00A9; Thu,  3 Sep 2026 08:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A87E6B00A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:34:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D521C0521
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:34:43 +0000 (UTC)
X-FDA: 85172394846.08.9A527CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E427B2000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:34:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G0/zDgEF";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uK0Hbb1faKPkbn+cU/4RsAvsMY58CotR+cwVfIyfMWY=;
	b=U1SY0sRXPpbg/XrM7mu3yQRisZZPCD3mmK+soH7sPFUL3A1CHXrNQJreP9V3MbSdZJ+SSH
	e0UbRxgNYUk8b1QKtMqBG/J0MBdnIXwZk8sIfsJ/XjMC/I6YNllqCBXpv+RilPmM6S1PWf
	bmZOMAv1q+uNqvpe2usaP1/OscHmEc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438882;
	b=qcauf3EhMFOtBRG+2/fhEtOysinZFgVqLtN2lxr8I/jHMPzPiQaduWf4UO5ojjOS5dX0v5
	wbcBFCN/KFLx/H1Mfku2JqHKi6osPYYL0USpNDwGm2m0Xi3V7rlvqFSyN5zUJQItVvzez3
	k1rGtsCj2+5jVFXK3iwrFi39ZrJy4Rs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G0/zDgEF";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA624417CD;
	Thu,  3 Sep 2026 12:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C31F000E9;
	Thu,  3 Sep 2026 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788438880;
	bh=uK0Hbb1faKPkbn+cU/4RsAvsMY58CotR+cwVfIyfMWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G0/zDgEFJRV3Fd3FiL6VOiv71LC5tt6dpsEVZ+vUTmxM+NIkfCgQmQCBmUR3efDGs
	 d03+lO5Yzimj4JcFaVVzO2IW2X1IZvoSXrXgIixcVXqV+kWrONGDmqqBS7QC0sjhln
	 8O4USSEsQKziD64eJ0j+N0yOZs67H6km3FbL+OuFzFso7aU11hik0VgMO6mPSJiarf
	 096aqgZsssYcV4yinnALs/mSWYagEgscsV1LbY9kDPbwwxtRqGD+2PZJ53dAh4qbJv
	 2gRW6Hk+qGBW8JNr09rbNX0I9Jkemeaq98CSNtqYud1iuXkknhUDVS9iSXRPLZW8PR
	 OBW163lQPJ7Lw==
Date: Thu, 3 Sep 2026 15:34:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: move drivers/char/mem.c to mm/char-mem.c
Message-ID: <aplpV4lLpDuHQ7pG@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-1-a578c730cec7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902-map-private-dev-zero-v1-1-a578c730cec7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E427B2000C
X-Stat-Signature: 6d1us4c4xd57agcctgxff691zopw1f1m
X-HE-Tag: 1788438881-477081
X-HE-Meta: U2FsdGVkX18/i1rFMRRm5mkZMewta7ErmpAfxzIGunESVEOD88q7a/vmK6dyZyYnOpU8LofZ+dTuCzOIWyJigqQy8tKdS4USl/FI33zg7SUNX7fnmgRSfPfRV3ZpcJm6xem0eRIwCv44XMuR1JfWPh8DaMmBmSiRlIf2rXQKI5t5/KdD5D3u8/ohgs/cAwuj9vq7XiiUtgEO7BL2gRs88AE4mHTTNfO9AHGK0mZKGOqlyEUeVafBTVCpYPqLhreMoSlcLRhlsIC3hNcE8/agZ7SWkyU+faIjWhIKzSQX2oV8YwI+o12ZkdKhxCSVam8KuoLkdf9nvwkiK/RPp3xO51QAlargDLWNdT4XEuTazb7hyVX/abaLajvG7AnCAEm1yhFE7qSOCFA2VhK1urIWEX3BS0P16az6GDwJZV9JZ43emvjaho1EHeHncKSRt2t6ov2FiBNRstFbXfQlt82i2B6xCsK7yUcwvLgLmC4vWBHPaWjCZX/sj7M/KkG9+Sx5Y1GbVjGPnalNIVhWUHvvR/g7VeCMeY82k21M1CLs15/DKMENsmUlDWz5EjgPO6xdXIXOYCntC25A2BUtaUcSzsAxrk1dgHoOQNJyRt0UpUhN+MXJ3pr0YEFlCOovG1ObYmgXE3FkCAFSnObBpPmUgho+F9L4LkwgSjwWgP5XI/Ex1oVBoyVZY1X3ylmwraghozGkBwQ+F663wVt/O8I6D3yp3e/iLkaeiMqhy/VE2/B0HwtgsAtZXWAkfWxyM081j5s9lTZOEhCOPmUVioGeC42dSE39Rd5/jztIDxRgQHtqy9teknEeacN2AP71iTFo47BpitUDi6ORzxlO+VpZqQXB5tVl7z6M2s8IBGpmz1zjRKXReuU3ijMdECXbVHxnB2JxQbGDRFbeCQIZJ/Qzw1j2SxR01BhE1RFa6eUG+kbLI/+P03fUiogmfB2OvXkMKbWpJauRDANRfW4Qcbw
 xzXcU0uf
 wDyWfblPSKKyD5tIjjJpChWhHNh8xD87mp+OQ9bNxL0cCekfTKnUXumxogMY4FQYJ+pNAoc8VSSc5cTt5QjjpIgyMEWB/NcjWUtbDLZA/Ml+OviF9yb9TnoqLECBDnGKoADZQyTTHifcLeaHuM4gpe0ydIaGUELw8BCqCSuWv0PZyzZ3vfeNhtX+4PwgmWPH1vpm0dUa6pnmq4jDAEaGYkdpr6A76Q4igom4wcW8DMMbuZPiKf7IGO6Z3PiwNrUqreVr6EjI+REeMkRf2LlXvOAXo7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 07:00:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> The memory character driver implements several mm-specific features and is
> always compiled into the kernel, so move it to mm/ where it belongs.
> 
> Among other things the driver implements /dev/mem which provides raw access
> to physical memory, and /dev/zero which either allows mapping of a shmem
> region (if mapped with MAP_SHARED) or, uniquely, anonymous memory (if
> mapped MAP_PRIVATE).
> 
> This change lays the foundations to allow MAP_PRIVATE-/dev/zero to be
> mapped precisely the same as anonymous memory is mapped as currently it is
> an edge case within mm.
> 
> Also update a couple of comments that reference 'drivers/char/mem.c' to
> reference 'mm/char-mem.c'.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS                         | 4 ++--
>  drivers/char/Makefile               | 2 +-
>  mm/Makefile                         | 3 ++-
>  drivers/char/mem.c => mm/char-mem.c | 2 +-
>  mm/shmem.c                          | 2 +-
>  5 files changed, 7 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

