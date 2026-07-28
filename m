Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1A4C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFDC36B007B; Tue, 28 Jul 2026 10:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87126B0088; Tue, 28 Jul 2026 10:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A519B6B008A; Tue, 28 Jul 2026 10:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 678D46B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:10:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B10A7403B7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:10:04 +0000 (UTC)
X-FDA: 85038369528.11.8500B93
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF02E1C0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:10:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLWwoE2D;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785247802;
	b=CxdFsbEMdBuaLpVSITSjbotKRxnKkU2ka9qLyAeTQmroG+yLN32Z0KkvS6sqzB1gZH9YzC
	eU4VkX1XW9T5dntg5WHJwiUShtjd2/WsbNtrDDuSZHRS/qANo2/20JWxMyIZwQg7yHWJ1L
	hHyKO7zs0uxDEG6V3vdHdFqeu6HAL1w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLWwoE2D;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785247802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrD8ygHhYerz0DEj7rZWmow1dfxEDcUpsFk06vyQsjE=;
	b=K9ryGK35IX6L+wprokYnKwEwUwfRZu/HVvhJc50x9TfeRdm48AfBTYw3oFm+2o0EVyxR1R
	0gKlioouO2c1QDRDHKpQJqRBrVSWWzgkNTJ8OkjRGZ6jQlg0k70SiUNr22kPX4u4xcu5ip
	8FVpMMHESxOtwNnUksJvn4YZBaVu3iA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so42026355e9.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785247801; x=1785852601; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YrD8ygHhYerz0DEj7rZWmow1dfxEDcUpsFk06vyQsjE=;
        b=hLWwoE2DBbOcsHCD4DW7Jdv6NssavUxyFvsyo7pLp32Lh6mFI5FPuO6nBZ04sLk8c6
         vGB2kO1lC3L5//s9Z24OimOlRwUJBgYwlH/1Us8vpD0c+Cz+y/7sF3pL5xc0vM34jDgB
         114r6ttf9KUEpAwBjxYjTfIwOdrUBBqnI/kv8IRHD2AT+FbS28mCtqKwOjTgVXCUgdUd
         Q+igAG+FXuoXOsG8zVTqJU5OMzPPMpgh/3FN1xLfg3PXu/eDyhpGwBbmvBnr0pmiy/n9
         uVz/cEW4wWo6Kfmt9WvYbp1x5WaHZ12P4JeWNwDsZA8fDEs7Fy2lvG8yq1cAMuySH43c
         bSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785247801; x=1785852601;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YrD8ygHhYerz0DEj7rZWmow1dfxEDcUpsFk06vyQsjE=;
        b=bYx+UT0BrJ7RHDseuxMNJ9m++x25beE5fzmWa9LWksQrS2vGVn9CEHWwq/6h5EEA0s
         OkD9ImffM3uq/mAeVoB4fuxizq+96fB6a5JVEogmBrXVWQmhd7o2iUYP+KnYd+mDisUZ
         5Djxcp12O2HWFoWrxTxXd+CyWFXAOJpHwOT8WaNAkksFqE2A3yGUHzFjKpuAbvTwgfBj
         XDs5GFbN7jOc4e71Vf5tqxv5N+U9Rmp3TOubxUa0vzTnQbGnJm/8xWaWJLgbgk5aWqvY
         I3Z4AbAVoWHR8CArzfcpk4ZJqAxduI0ePwh9py2RxcuB9vUrJqQCLGJvQ04Ggc0cBTj6
         +v+g==
X-Forwarded-Encrypted: i=1; AHgh+RpuLSk9egWXxpg+Dphr8Af+GhSWe69x7UMbb4hB9QpqPo+3HgOsFNe9AVUXHswHOvDBwKdPpbNLgw==@kvack.org
X-Gm-Message-State: AOJu0YzdW4VU0uqlu+sa7jSDOyq69GXfrslCJV1aLVtvxLG+Vt7MizSC
	qnnGKKjGA5cuf7isxp206slestTMu2JfPnuGPHzdCb79JD7d8zqMZyt8
X-Gm-Gg: AR+sD11r61a8NFKKTxIauq8TtcsGKMttDrvfE1m0H6IGmHPf5wDxPyK7vaG396kNQ1U
	+Jzn/KMsXRdtzz5qJqyJBTVDxH/YXUWtDT+VhVvptH4luiviTLnVLiNOVQX+vuWJVCliTGKN6xO
	bZ/BMkjJh5Kn9WfjN7A7mfcjz5/7tlNK9QqA1ycPOe4wd9Yx+cosaPwWapycEG3+aU+GuDTwDk7
	6SBaEDk1I9nTyM9o0wUsJRYFQGRLyZRF0n6bCpxDlMn/gI+a2ESZNHbvLAMOTI2ylYCZnOv+P5h
	wb0W1gtYRWu405H0gxqQwWMjL41FpRnvCMc1WuZzmDmw+e7G/C/LNb/1Nbk54g3DI7fFku7ipmP
	dzB9Fl3hUK/EJfWRhCJBwSvd8Z1L8Ks8QGZaT0B6/0sN2Ee+MiD2h6RwUcFmigFA1+4Zg6tvJRq
	gpupsw6R0nVAys3ULHdTuPezMTzVcp7gMVCosJC0N5bdrZXrT5Ty1MlUiThsmK/cY1hoTvDqdC5
	YCfZA==
X-Received: by 2002:a05:600c:a44:b0:495:4856:2659 with SMTP id 5b1f17b1804b1-496c6439442mr28377265e9.9.1785247800886;
        Tue, 28 Jul 2026 07:10:00 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45b1c2asm82737265e9.5.2026.07.28.07.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:10:00 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: pfalcato@suse.de
Cc: fmayle@google.com,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	kaleshsingh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	oliver.sang@intel.com,
	surenb@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Date: Tue, 28 Jul 2026 22:09:42 +0800
Message-Id: <20260728140942.3849047-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <amiCX6kcQneMZu3-@pedro-suse.lan>
References: <amiCX6kcQneMZu3-@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jyqc8syp83ja1oogcpy7wxja1swn3wtb
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF02E1C0009
X-Rspam-User: 
X-HE-Tag: 1785247802-764368
X-HE-Meta: U2FsdGVkX1+H/Qh5EApPnBN84K13H8BoBiFdMR0XPaEeK5nEU3g8SOCs/sKUm8G6lt38RhvpJ6Ag1bHpS+0Ca89eVmlLyxXu66eL0D921ikKWyVTJbnQxarmbZQoh23sku6hcG414nPNrkKIJ5L4oarN8AjvimFlCJ6YKfpnICC3a6JNZ9wPpmdv3BKXcx6hAxoa557FlK7KF0f6i6zL9v91MDige7gls22p5Us9yXYFcL7CSyLOhKFA3k9/DgBKpyXTPynLwH4lZ/CpkwBEiWVlK/OxQ5H/evASg2187le7ZJB7PZ8VXTF/pI9gOGmaMjygraUskRvQyRW9e55569OZcqK6q/epTAl5L/oKOeILZpvrXL9h5Z2DEnL+Gn7IOdXpDhL6T4bTrKsrZB4dy8Pahzq3HYxqv+2hLJjGKxQYL8cKzz0nFmX/vA2w7Z0hAp1QI/PXO7on83ZbUad/GtH+pjeplLgRiFYRwgUVtjFQz1bvWalA9jN80/598vSuSeWJ12hlJRmi3V81a8F/t03FMV0CUhYcDiOap2ok9MjIQ6Pa01zmMWNM7Yk6wMkwtOy9qKAZH7y/7cfCvFOYSpBCbMoemxt3bRWklezus64TAIy3xlRjusvkXgExczZ6pe0daSJxqTBHOjn0UoKDkluoNuQFXLottH2I/Ugz1twnmQXFx2rwwjXgdhutcxwfo0sxKAzvXvpilH5wONx11qutDwvDjcb89jcb/ZJeUNUx89b6wgH5nqAs7Pr/GaA/4hX5XDWgYP02ikliy+mTCGFdc0mq6YHmSg3lOga2f19LCNb93+le2iwDwP6tpdu98fDQ53y6uVWhQjYkwYW2AY7r50v1ToJPCwOq6oGu8frC5a6SA1SYHaeZhlobzImcACpLjrwefgf9QWu7j97iBTj+5VCM4bckFnL2LX1J/h8konq3vtk/041Psus765tpZulc3Wqiif5ObULdvK7
 AamgLqii
 YmZLNRHz9WghC3+KG291O3c1/9GPxbBTWz+1yQaYLLXANZtn3DLHayYKbGXlmRLOh1AMrK6I+UQBHbTyhzn65LSsiwiZRWkm7V3AZR1UskWSGzeXC3GRi+Osx1FOcWancf7B44g+/bELuxY02YtY7fK1VQk/JrD0redHGoc99aPjwVyCC81fo9DvVarlv91bDZOYBpfatghNDxYhrt+0MvsTIGmw88b6vEPgZDcrqEMkqSoL0eqKKvAoAplbZcUZCXKo9g0pFcsLNH5Jr2pWMoueF1CufCia99W8tv8W+sruRpsgB/V5f8Vx3fVXCeMBrTmb2ZM241vq0VDc+eLxsVZJjKRp8s0pOFbZtLGx4h4PaoWBnoMr6p6tF6Q6TTHe3Yd3sHf3dpzPjVPooLaoj8GV93JoHfW2bkkGM0S6l6jMf6lGk4wGyl3/90Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 11:33:22AM +0100, Pedro Falcato wrote:
> > With my conditional approach:
> >   At step 5, vmf->pgoff=896, vma_pages_left = 1024-896 = 128
> >   128 < 128 (the condition is false), so _max_index stays ULONG_MAX
>
> This is exactly what we're trying to solve.

> > The key point: when mprotect splits a large file mapping into adjacent
> > VMAs (common for ELF segments, or read-then-write patterns), there's no
> > benefit in preventing readahead from crossing the boundary, so the data is
> > still sequential in the file. The limit only helps when we're actually
> > near the end of useful data (within ra_pages of the VMA end).
>
> This is completely missing the point. This change tried to back off from
> reading _anything_ past the VMA _on purpose_, due to ELF file spillage.
> This patch reintroduces spillage in a very obfuscated way.

Hi Pedro,

I understand the ELF spillage concern. However, I think it is better to
distinguish two different scenarios:

1. ELF segment loading: .text is typically a few hundred KB to a few
   MB, access is random (e.g., instruction fetches jump around), and the
   data beyond the segment boundary (e.g., .rodata padding or another
   segment with different access patterns) is not useful to prefetch.

2. Sequential mmap of contiguous file data: SVT-AV1 maps frames
   sequentially from the same file, and the data beyond the current
   VMA boundary is the next thing to be accessed. Same applies to
   mprotect-split regions of a single large mapping.

In your earlier message on Jun 18 [1], you noted that SVT-AV1
"progressively mapping the file data for a given frame" and that the
old behavior of "page faults for a given frame starting readahead for
the next few frames" looks "reasonable". I totally agree, and my patch
tries to preserve exactly that behavior for the sequential case while
still limiting spillage for the ELF case.

Here's why the conditional check still handles ELF spillage:

For a typical ELF .text segment (512KB = 128 pages, ra_pages=128):
  - First fault: vma_pages_left = 128, 128 < 128 is false, no limit
    (but ra->size starts small, won't reach boundary yet)
  - When readahead ramps up and approaches the end:
    vma_pages_left < 128, _max_index is set, spillage is blocked.

For VM_EXEC VMAs, Frederick's patch already has a separate code path
that unconditionally limits readahead to VMA boundaries (the exec folio
order path). So ELF .text spillage is already handled regardless.

The regression comes from the non-VM_EXEC sequential path (mmap read
of data files), where blocking cross-VMA readahead has a real cost
with no benefit, the data is contiguous and will be needed.

The 45.8% fps regression and 870% major fault increase are not
acceptable tradeoffs for blocking readahead that would have been
useful. My patch preserves the anti-spillage behavior for the last
ra_pages of each VMA, while allowing the readahead machinery to work
as designed for the bulk of sequential access.

[1] https://lore.kernel.org/oe-lkp/ajQbXthzbr9xgUIM@pedro-suse/

Bo

