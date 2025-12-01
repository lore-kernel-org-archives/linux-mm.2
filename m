Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D0BD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CBE6B007B; Mon,  1 Dec 2025 04:09:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3343B6B0089; Mon,  1 Dec 2025 04:09:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271136B008A; Mon,  1 Dec 2025 04:09:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 165C16B007B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:09:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C21E7BCD4B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:09:46 +0000 (UTC)
X-FDA: 84170329572.14.B5C6C98
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id CBCA91C000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:09:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UeLoA7ZZ;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764580184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+fc2m4iUG1wiZG+E93U0Pi2aQIPVm7WNHMpYnRyX3A=;
	b=fCMqQaGC4C/LfOxXUUA3ij9KsJWHIzfQxrE9FRCh5UMk6PZWrh0/lh3cBuraG42xFvWW1G
	o0EQrq5K6AKDUL4s/ON6Uufq8oaRScYtnp4ixysXiOtEqcS/ZFP303ZDdoyWkYOmOjnYlw
	XR884JFXGI56wkPajIESopuq2fXlCY8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UeLoA7ZZ;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764580184; a=rsa-sha256;
	cv=none;
	b=T4kKBnuwtHPbtbpElm/ZjL2dnEs3VbS2hd4JUgqPqb5fEBO6tgEMEUmJWqcoPe8zwtIqma
	0X8r/YuUvjizyVU7LAUyu9zuS3lkZSoceZWchf0Jiivu+6OXeAzxAkuP5NjORfBEo7MJdp
	2FzJyGaX2FR67yAXprVk51q5h0vxU50=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so4026616b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764580184; x=1765184984; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z+fc2m4iUG1wiZG+E93U0Pi2aQIPVm7WNHMpYnRyX3A=;
        b=UeLoA7ZZMyeqBSH/1CfjH1g43rcr61ai0EASjSvfcupBLmQTJnhIhEkaqJGi067zlb
         GabTL1yg6CU3gRb+9JKBajSa3YZvG5rXK0fF/SxGas/JsssCoKcM+RtUis17/Bhj6S8I
         ERnhMk2/YyJG/7Hkwmxhf3ZchAhF2a48Gklpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764580184; x=1765184984;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+fc2m4iUG1wiZG+E93U0Pi2aQIPVm7WNHMpYnRyX3A=;
        b=uwNJ/Qo7WPPxWyMgAtM+qLjbEXvNiR09rkxXt+OuYJB4EtFxANnszZhe+10A4x/4rt
         5IiGhXDrFf7JvuDZyBKTE0T2By3+IO+rgQe8eOTpRD/5Xj93xKaU6o3l5HvxHKFXAME4
         gg6sHTi+6en4o+MjxJ/uD0GOUWyv1TSrPiqgzX5AhKeHWpCjXwxdbHjZWxcGoopJqzVG
         HP8cL7ER44sU8vweQ5nlt0fn0DHYuP0aRkq9/O5impCD5jrcBtavGJXgkIReUKgTxL48
         aa9zSg8PJZLfmYMHOwzYlf/cWBg0GMGFoenB0zmoEh0KdTbSZcUd0CiQKVFbJxBxXaZN
         +oCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVebDw6vSREDmTnOc6/8zQEj0hMUYxNVmTBgKRE7J9vhetEFKF2svSUAPRX7wD0ZUhdMscQvrLjaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8rmyalTPOd42nc/P4t2heBR8H6jnyqW0585PMgySX5k/ffUDn
	vUGFPDv+5laf0YdTWFPzbXN7K3e5MER/ZQeVIRoDTvhYtm71yy4sFstURImBEMsiow==
X-Gm-Gg: ASbGncv3abziUfoHeAYK0K1CSLaGLM38d0cBmoUIwR351Ok5kOVQ+SJQuDnF8jo4URk
	X2oi22DXeCaO/T/3rmndv9HX968LRj1UuoaXjYiXAuEpix5Y/i2S0Wk/+RkLWXyr1mniFU7KIdy
	3SC0bpdAsJccbXAjZ4rGXIbPmtFTuIGrf9yph+kk90FeXWm1qgoD21RYzy9v0O+M4UE5PJ+vub8
	nRLlYwkFEib2Kv1Q+WkJTEH3gXXHNtn3cbWuV/yavscARkRf2x/BdJ/dYdl6+2LRWZOMCym38zt
	i3g5gPentBN1sgzMNszoz28AM/iADXlpHwp+w+I7/koaySIGULb8XraP4yfQijOjfjSjUzFJkfY
	melJWQJGWkMVov6h5f4zXlq9NU5NPLKNB2fL/+VyyjSlyc1oTYgZcHJdedexzUjJ4Kl/790Gu2K
	jnkjZ+C8WiaCc6iBzo+J5i0fJeIGxqOUZTe6sSQfs+3Hce7Oxr4MY=
X-Google-Smtp-Source: AGHT+IGX7ImaHb79oWVYq1C+OQ311g0NlH0NigBQ5PHru076OlZHENu05lVhfiah4JQXAmi8jU1qLw==
X-Received: by 2002:a05:6a21:898b:b0:363:b976:8f79 with SMTP id adf61e73a8af0-363b9769000mr9534581637.43.1764580183494;
        Mon, 01 Dec 2025 01:09:43 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be4fb24872fsm11628836a12.1.2025.12.01.01.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:09:43 -0800 (PST)
Date: Mon, 1 Dec 2025 18:09:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
Message-ID: <dt632m4jh2jt5fhnddcbgtdndxh6552hcbwpqeklfx6z7oaihz@lnhskip6whc6>
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
 <20251128170442.2988502-2-senozhatsky@chromium.org>
 <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
 <hgk3zp5hwlcxo6ufiqasvte3hoksy2wb2kta3fime5rprq4org@xaprrqdabvgh>
 <CAGsJ_4z6kSvA+Yzqx=JQ4n3jhQRWn4zYMr364-V2Wjyb2wXE0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z6kSvA+Yzqx=JQ4n3jhQRWn4zYMr364-V2Wjyb2wXE0A@mail.gmail.com>
X-Rspamd-Queue-Id: CBCA91C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: r3uq7quyxrha8fwcyxpu57hnb1wqx8wr
X-HE-Tag: 1764580184-699659
X-HE-Meta: U2FsdGVkX1+NEmMKHeD3LeQpOebKte+e8+FUAszjzA2WJo2AFC9tlVoTqut9JCIgVN8x2VjwXUICbUZS4f3yi83NHA+P9Md+Nv6pJ5jtQDrzi1eS40Lp6khir1ZPjQE5JRhhSYVQ98hyheDD5zJsM2oK3ME/3hLWTC9gdjO6CTokCi2/mrbJAp6iQsTd0o6K8jaby+NFueAGeCzR0uDsIVsqddwVadcp24bGBWtqWP/TCPXBkXop8N3jb0SYtYXJP5ZW5ji2rn/zd+4opRuCDlIa+6ZP3fSQ/5xNW/93znoYcTXXTBhft7pRBvllNkw9A4nOeOKBd/cVW73d4owAWHovLHdDufQkh8bapul4SnQ+Srat2dzj4xvlVciOb+IuFO0Dop1w0z8YWRTM58blgxzBIzWIGa/HkTu3tO7dg/fFjs4XUXvqe7Q0zRtJdRIjpOfiNc7NJMR7P00an3+96RsWocWebUjVDQqWn+q5rZqq17d/zfH1GDrxTeYJeVVOzh/98DMjfP4vhSFrjVWWb6076vJVj4eSutESxBFe8MThef9JqTjrd4OxcrWjxepKLs9L3tJGrfnWrnjYv6ViCZgPlJhMVJhke6pSL4P/e6wNdhfoWbSr8exkcG9CejXwYPJir3asCacB9/NhdDpbl3kkVByEaTq3gL3iL00HPsaVfaGcczrnQgl34gAZfJ5DqJTE2rKLV13dgGbY59N3isx2hjlxHs/+4yNRAbt/6tYSeyWiATKvndSKi2eI8b2DGzpuwR2lmbZZUdex7wCFO6ApN2n89a8CjZtmGOrsYAa/n95wicWh486OuPM2ZUsjLPkAMWg98aoxOg+3RnKymVAynS0CwKCV4Y+DJAowv/JObfZWypTrmpnjAlz1sfdefqvGBZbCl+2nC4HOZN8bgW9m/k8goyA4fAmI/LS/Jiin5/nFSsw5hfxG3zkUKSep9sGiwYcxDdZTVHU0MM2
 jx80WSkd
 GkfjFFkJ6orfr9+CqNBmIsNsHTCkkLQwllqEEzQu/Im3kYkmey6nGHlkMqQirnirQS1Ruef7nU/C9CulA4pTNrJDbOHvlcS8d04LVJfJk8aWCz9XsSVGxrCFeo9WftWqeyD0kWfA7eT/M41Qx5ECxzb8s7tBoUcGT6y4ACdwxfyB11ah53RVPHEm36+tTKc2qvScsi0hHV6Pzc/VSdYRyFU2u95wp0HxWCDR7wAoXbObokUWDHrNjD628XgpyNuQoWkWaCad6giDYGH+0Dfvra9qptTBZ3nwsDJwAWXkv492kyvbSIMkLEGiLJyCV+eg9IWG1xvmMX/ZwY6oSOSX/FG8WyIH1mugWzNABgfaZgKJWYOXOPtGvLgTRjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/12/01 16:59), Barry Song wrote:
> On Mon, Dec 1, 2025 at 11:56 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> [...]
> > > > zram stores all written back slots raw, which implies that
> > > > during writeback zram first has to decompress slots (except
> > > > for ZRAM_HUGE slots, which are raw already).  The problem
> > > > with this approach is that not every written back page gets
> > > > read back (either via read() or via page-fault), which means
> > > > that zram basically wastes CPU cycles and battery decompressing
> > > > such slots.  This changes with introduction of decompression
> > >
> > > If a page is swapped out and never read again, does that actually indicate
> > > a memory leak in userspace?
> >
> > No, it just means that there is no page-fault on that page.  E.g. we
> > swapped out an unused browser tab and never come back to it within the
> > session: e.g. user closed the tab/app, or logged out of session, or
> > rebooted the device, or simply powered off (desktop/laptop).
> 
> Thanks, Sergey. That makes sense to me. On Android, users don’t have a
> close button, yet apps can still be OOM-killed; those pages are never
> swapped in.

I see.  I suppose on android you still can swipe up and terminate
un-needed apps, wouldn't this be the same?  Well, apart from that,
zram is not android-specific, some distros use it on desktops/laptops
as well.

