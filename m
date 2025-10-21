Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1708DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD058E0003; Tue, 21 Oct 2025 02:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABF58E0002; Tue, 21 Oct 2025 02:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1508E0003; Tue, 21 Oct 2025 02:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C62F68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:01:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70ECB13AC56
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:01:11 +0000 (UTC)
X-FDA: 84021073542.26.DB205D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD81080010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:01:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="D/YtPR7h";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761026469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlOudwXbTuKZP+65to2yB8CDDxaRkCIlLFB+OW1i+Kw=;
	b=HoEd0NzLiFeUa7LtBd8byVNeDqOtpXG9otTKcgVm9y8yo3gHrDy3siJV+SXaX3f6LMjk1L
	P3qWPYAPQKIXL7+hjxIUTbUsFv+U7PWlEimdpI4yNQ9qUBeeEshSHt5jB8YJKBJITF+NxQ
	cp8CuCFvObI9rAoY7Knf2vgleNKt4cQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="D/YtPR7h";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761026469; a=rsa-sha256;
	cv=none;
	b=BL9wh3zhUu+bvz4jGN9NcGEUTHL3og8YELJtni5R0jcsPB8vpmJzC6wkiWOWR/lOz9Yd1a
	10j6YBZrC9um8XqoW1kAo/o+KSL2jkWswab0ZMNlVLIQHGXjHBMILrLKk7UJzmyl2QySjC
	g/XHQ+h6cniii1tuGozUfdq6Z/lcN8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3793B6227B;
	Tue, 21 Oct 2025 06:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF29C4CEF1;
	Tue, 21 Oct 2025 06:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761026468;
	bh=leVGy3m3C0ox1KihNTxl75c7yMvX5DhCdvZGegMEpSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D/YtPR7hXr7HDYt3kwPIwQPPNZ6foZPGaPyKfbiAINADLKI5mwi4LlejBVPhcUBwu
	 bKaR25r+8BksQ8fC1qOhTsdzRK1slwhQmhp+ixg7UWtAGcLi1Dfn93utOJZm3TW4z7
	 dT7Mk1jvCUk3ylCAkaMWSBW2NAQHWMd5ctkBjmxHWPGyywMiDgrmFGWL7ApjX7hNHZ
	 x6iFh5GR6qfZxk44boaJTNw/qwT/GhlVuof5/JMnSy+FC/Ocq7lIpWEACwFFClYMRL
	 l1Dagf7YKFTg7HOh+3/5j6tdi6k6m3L+sjM2u6l+FvIYMVt5t+Srji/bLytBb6WkT8
	 ox893izM8aQvw==
Date: Tue, 21 Oct 2025 09:00:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Message-ID: <aPchmxfh4ACM0vY2@kernel.org>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD81080010
X-Stat-Signature: tuy174xz9yonmfadoxmapos6xuhjgkfs
X-Rspam-User: 
X-HE-Tag: 1761026469-986810
X-HE-Meta: U2FsdGVkX1+luYHdMIl23880IYZiy+lDbuuf9c5JhtCVYcl13xPWx7CqPf9kzfZ22DV4m/Sq0gxrR09mnYFnQPtcpOU+0DXEjbo/vOVWdXdBuJx5gsj05OrHeT/x/zWZlw8spvXwwHUQDXMSbQZfH826Lctqw/JAxYT9+5ehqZYesaXyTIF0rK0JzW0zalKQzjCo/r65N95H9JnpHU5uKXEkRrLuZxhATwc0eKzHKh0Iqmsuilcrz3tcIi3aWxZgsnbx8UF5dWu4zljUq8WMjYb59NDRNyE5vD5O2HyosI7zw4bVbTKVdIhbfokoCn1WfppJwdw5zbOgaOXXdrge+oGKj3ZurpAXNQR0Wl542DVautlw4URv45hplMVghWLn3WAfasAisQOI/SHewaWrvgPTOxl9NgBnCArY9/8d6kTvsuY6wkqMTuHeDD1MAPd7oI32H4eTdJPAt0hMwIFY3h3ymrAnVT/hTtkiFDuETLAwRiV4taN7xsAi5YhOAshz8z+b0Kz8YhG4au3qtmcDqYntJHW1wmbtf2miwVgYeZtEoFvoM+MPgiaFswFUxtzvGF5Uj8KbfJulFbdno/3J2SKTSTynFSYgNariT3bsRF/wPyi424ww1qsqRMfPn+yMqX5sDeH1cMm7WhRD7Udfm4FE73jl4yYGr/RFHTJd8QTwftrkz9XVvlW46pvdkHsBNhU1Q4XPumZYrikZysvsFhtwS6MpAwDqlFr9EJtecDQaCWDTr2RaSrYNbCZcmxujTT7wVZppZpfWe3ClmcnmRc2qWX2YpNJrfYGQ/fVJbBIiGYoc0svnxZB5eNZU+jg5wPrmpdV0uLXI4CDHCJj+3f4TCBY5av3SjX6mIVXY0UdI/usxQRgvyBCT97Bqc9n7Tg1tGmd+TGDCYrooM7ly+0ea4QLxMeMaQvGz34+6H8ccsLAwH1HZfncPRFebeWd+MSq6eY555/oLiSWZTMD
 vSUKzMS4
 /oAY/wi9ofFXKnQyZn3aYCy+ogjjCE2wze3eYWtINvEqoTjACGTg0weEwBv/NSlce9XA1XJZ6gPlsjAqdsv1eq6VvcKcMVMBhSC2M9uvXuiyemhrHLJWKKr0pzvjhrIs3aJ4q82ip2Yi30BclOxiUTdpaYQruvws/fh2PTtty/B54YAcVIg0ZwixJob2KcF85l5kOCT2VGMmCZxVcyeQAxeoKLFDaTJ8eAFH28t4lJVp2EoiSnGwDAN5u2alUqlijX7FaPZ3IjubcKZxDXChEyH9Q2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 08:08:49PM -0400, Pasha Tatashin wrote:
> This series fixes a memory corruption bug in KHO that occurs when KFENCE
> is enabled.
> 
> The root cause is that KHO metadata, allocated via kzalloc(), can be
> randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> early memblock allocator is restricted to a "scratch area". This forces
> the KFENCE pool to be allocated within this scratch area, creating a
> conflict. If KHO metadata is subsequently placed in this pool, it gets
> corrupted during the next kexec operation.
> 
> Patch 1/3 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
> that adds checks to detect and fail any operation that attempts to place
> KHO metadata or preserved memory within the scratch area. This serves as
> a validation and diagnostic tool to confirm the problem without
> affecting production builds.
> 
> Patch 2/3 Increases bitmap to PAGE_SIZE, so buddy allocator can be used.
> 
> Patch 3/3 Provides the fix by modifying KHO to allocate its metadata
> directly from the buddy allocator instead of slab. This bypasses the
> KFENCE interception entirely.
> 
> Pasha Tatashin (3):
>   liveupdate: kho: warn and fail on metadata or preserved memory in
>     scratch area
>   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
>   liveupdate: kho: allocate metadata directly from the buddy allocator

With liveupdate: dropped from the subjects

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
>  include/linux/gfp.h              |  3 ++
>  kernel/Kconfig.kexec             |  9 ++++
>  kernel/Makefile                  |  1 +
>  kernel/kexec_handover.c          | 72 ++++++++++++++++++++------------
>  kernel/kexec_handover_debug.c    | 25 +++++++++++
>  kernel/kexec_handover_internal.h | 16 +++++++
>  6 files changed, 100 insertions(+), 26 deletions(-)
>  create mode 100644 kernel/kexec_handover_debug.c
>  create mode 100644 kernel/kexec_handover_internal.h
> 
> 
> base-commit: 6548d364a3e850326831799d7e3ea2d7bb97ba08
> -- 
> 2.51.0.869.ge66316f041-goog
> 

-- 
Sincerely yours,
Mike.

