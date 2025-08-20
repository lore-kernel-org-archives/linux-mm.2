Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B67CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7AF68E0039; Wed, 20 Aug 2025 04:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52428E0037; Wed, 20 Aug 2025 04:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68BA8E0039; Wed, 20 Aug 2025 04:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A58B68E0037
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71DD71174B4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:54 +0000 (UTC)
X-FDA: 83796440028.30.8AC724F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E139A40006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oD4rECWn;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIhJS+qV0HEjPxscJj4E1pYztwxEESljU9V7YVyocZY=;
	b=rfjSfMIZpfa7sTTW5j4SnNGhVSR+6UW0v6KrbTtHAKd0mmGj/s5yH5tAOEDJkOGIYRC2NV
	xQGcxmJSaNu5OhLuYTtd+5RubIvm0cbuMjIRkEQtnnwbc8jGWQ2IyxD+AEEHwhtK6lsxyp
	zl31Tfi3mGSxJVe+MysVfiRGPz+jVqY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oD4rECWn;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678052; a=rsa-sha256;
	cv=none;
	b=mP2vRJajf25XGnY0i/gWRX7cmtMJrFCk5utYI2kBHnxV+86B+QklsENLDei2+4InjiqZxL
	2l+TOMYteWSGQDgfNfUxlfHJV+OUk82q2If1PM5fvRfJ1EzUcRLnojBOGqa+w8zvyOZyAG
	bCwv5q5fDjvswqkn1JJP7O72TsmA9U0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFBD161428;
	Wed, 20 Aug 2025 08:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477B1C4CEEB;
	Wed, 20 Aug 2025 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755678050;
	bh=F2is9zfwLMGTq7xfkgAalDyZte6T3DvSchJ62PdSzbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oD4rECWnKxGis9qi02Vw4EZJJf6aHsdLFojZnMJh7ZquqKdZ0wuyZgD6pAwCRLWGK
	 VhvMM83b+X4a15JnGeQLjSFRIBakJbjp0WPVbTfhnCIexW76mS4jbaRroP7CgIKzCz
	 Ycuo36/5Plzwz0if77Dd3AG6UGjI86yEE+D7ctWWpIiplNP16CZqCedYPYwnHLOZ8T
	 qOV9TOkmxnXpDJQf+HQyg9npiG7OMbMeSNY8q25t4qgZWiuscep7LvoVnNM/BJvWFy
	 KHdPN4SYvY3V56XaGzPRd+pa/2h9bGQxp2sQng3TXHvuew4n4Dii7cmHpXr8IjFYmJ
	 HyGfv75T5Ixcg==
Date: Wed, 20 Aug 2025 11:20:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2 0/2] efi: Fix EFI boot with kexec handover (KHO)
Message-ID: <aKWFWsk0mPPQFDyk@kernel.org>
References: <cover.1755643201.git.epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755643201.git.epetron@amazon.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E139A40006
X-Stat-Signature: 488mnde3us4u4348d8mkazi4hdj7iyfq
X-Rspam-User: 
X-HE-Tag: 1755678052-950062
X-HE-Meta: U2FsdGVkX18jXQxeVlvBTkmixvnCl7e36hosRco5zG+IyicFtETmgEYC1R7qPY6vGTqiGdUsxbHwglB6qV8RVHlq4qBdgNMmxeyW3s9HPU34phbvGKimnnhOIJ1Psg3xQAw+LEMrUPqGqePJEkllb3LEPY9AXkxAS5Ih1UaVGn0TZ+FzD5wHlWxNBDAQsB0HFngXcjicwOrQNiGSR0z0UGQw2fpztJY57TYm9hV7jJqg9M71zYGDqfZno05FF0pnrqeYPImFBFMks+riwe1ZSiociSBOvxnQRHwFEyzbIdpF5YJSDgWQ5M4iMAOKjJzpdTA5f9XQywNoVBcBqfHdutDsOVyFOPajFtpwHRRYNT1NTh3PYYGRuW8MnHovxGb+9KiwzTrCuP+PZOnf5qwo90roFESUkBlJyW7KBDWhZOZtqRCbp8b5S4E7hCDZUXblw5tay5kuWsjv72SOGrd4GuPL63Dn+dskkAnreTovicbqeU5ro2Er8OD7dWAXGP1m8BNDVz29wYyHiW651+mRi18jNqk9wQ2TDgV78NYM3XQ8V1DEzi0ynOW6yvhWaBuPhdCnVauvTs7PuWCYHCBuwiQlhuQ8kv+5WwfzlF8WKTkxltzWGyN2ytGunCJSvV/CJAk1rPAdLU6ErOAvnCW/XHPZnjdh9glfcu/WL3t8sHS72H28RrN5P3M7AdeEv04nBeqyITyj1w5ZoDSADEX9iLJ2ZVbDtmuHhtnqeo/ltl53FH9h3++e7qo6Xy87JTYh9bQwKV0KM/6Mbqyxv3hwC0hP0xMjswESJhkDaSjQpIEtl0mZ+oPXtfJs4OqBPf3q2YYBqvQZ6b7cAbr65vx3hZG7IhDdOyRSTqSWeu9SksfZk0/d2hOmy19IhGhCn+nyOfWwSLHrT/OqKY8zgrA08hxnczDWovflC709pJtY9GZZUUMlfaJkrcCEId8QF21mGRz8VpUgqh8I+g0YXDc
 vBwfwDun
 8IWFmByNkLYDbCobW761Hu3mRXWYuGCD3JKaS/yFL+B9aXQ+MPoeqjL2i/5MxGF6Q4+/dsj0qRgdp5kQMv0OeO8FZ94beMz9yLsUs0SZ2CRHFITLbCB7ePSbKHHgOo41cMvmL0dYwCSUbz7ncb26dtwVzmkMJX6zdvCHP75xckRly8+Lu0FIXjxMFgkPq/EYuNCCjQZM9az3sF++jgsGWdNmsobYCdfXeyJH4/+fea0tnc1HalJIQfta4V9Ob+ksWXY/N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:22:44PM +0000, Evangelos Petrongonas wrote:
> This patch series fixes a kernel panic that occurs when booting with
> both EFI and KHO (Kexec HandOver) enabled.
> 
> The issue arises because EFI's `reserve_regions()` clears all memory
> regions with `memblock_remove(0, PHYS_ADDR_MAX)` before rebuilding them
> from EFI data. This destroys KHO scratch regions that were set up early
> during device tree scanning, causing a panic as the kernel has no valid
> memory regions for early allocations.
> 
> The first patch introduces `is_kho_boot()` to allow early boot
> components to reliably detect if the kernel was booted via KHO-enabled
> kexec. The existing `kho_is_enabled()` only checks the command line and
> doesn't verify if an actual KHO FDT was passed.
> 
> The second patch modifies EFI's `reserve_regions()` to selectively
> remove only non-KHO memory regions when KHO is active, preserving the
> critical scratch regions while still allowing EFI to rebuild its memory
> map.
> 
> The patchset was developed/tested on arm64.
> 
> On a side note, I have noticed that `kho_populate()` calls
> `memblock_set_kho_scratch_only()`, but the `kho` cmdline option is
> not checked until much later. Therefore, memblock will use only the
> scratch regions that were passed from the outgoing kernel, even if the
> incoming kernel doesn't explicitly want that. I am not sure if this is
> done on purpose, but in any case we can discuss this in another patch,
> as it is orthogonal to this one.

kho_populate runs earlier than we parse the command line, so there is an
implicit assumption that we are going through KHO-enabled kexec if FDT was
passed to the new kernel.

I believe the best way is to document that and make it more explicit that
kho command line parameter only affects the "out" part.
 
> Main Changes in v2 (smaller changes can be found in individual patches):
>     - Introduce is_kho_boot()
>     - Replaced manual loop with for_each_mem_region macro
> 
> Evangelos Petrongonas (2):
>   kexec: introduce is_kho_boot()
>   efi: Support booting with kexec handover (KHO)
> 
>  drivers/firmware/efi/efi-init.c | 28 ++++++++++++++++++++++++----
>  include/linux/kexec_handover.h  |  6 ++++++
>  kernel/kexec_handover.c         | 20 ++++++++++++++++++++
>  3 files changed, 50 insertions(+), 4 deletions(-)
> 
> -- 
> 2.47.3

-- 
Sincerely yours,
Mike.

