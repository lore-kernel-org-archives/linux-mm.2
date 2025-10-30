Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AE2CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C785280001; Thu, 30 Oct 2025 10:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EC68E007D; Thu, 30 Oct 2025 10:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4578E01D8; Thu, 30 Oct 2025 10:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE928E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:57:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E178AC0132
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:57:41 +0000 (UTC)
X-FDA: 84055084722.04.9E55FAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58081A0012
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:57:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qyOcKUG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761836260; a=rsa-sha256;
	cv=none;
	b=N2deSYK6Ff+FEuQshES3BfxMcm1WPEVvE7frm7IwR9hqZB2sT3NqtjIowg7SHvLDSfpkvn
	6HHgmRYEubKXIm5ZWhAzimPq7BPJye/MB3ZZebPaI4DQ0hnkYMxv6yLSkheWQ5d7YYTSZy
	Zh1+DdGgK8Woss/jozjjm1kTC/QlYtk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qyOcKUG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761836260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TKgFNg44NDxjhDB9aJngB9wyPtxG2nTi09h/aKk880=;
	b=IOxWFWX2j7una9/7RWi2cueJv2q5zLMdc5h/bXTaSVaIUYQA/LZPh4zFihKcUru8dGi0Q0
	BzfDNw2b9JqaK4SGPKmhpkOEXEk+cg4X9waLbsuSjhjEC4VecyeVBmaTE3l/ZsIkbgtfKV
	YnBD/Jvj4xu/srg9WWjRkg44brG1mZ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B20FA61E2A;
	Thu, 30 Oct 2025 14:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43774C4CEF8;
	Thu, 30 Oct 2025 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761836259;
	bh=Lxi83mnenqLXD/dEkFyBMrWO5ZOIAm9IWeX/LclGy1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qyOcKUG62E+yPf6Qu8h8SVxChOl/54Ncxu1UhBo6qIUcWOg7Tfm8PKDrSR8u0wcFW
	 AXPERmKPm8Jyf2jMk2J5PMehc9X4/UxiYGfpAq8yYv3DcbUFQdQxO1Mj23g4F750++
	 Ll+Nuq5E3vn6qgR2A1homCiXBPQJj1uL2lJE/bJlCD37mZsQAwO2NRnSZIvgZ1qCW3
	 ps+PUo2j+Z6eSFxSPYeCkxaNHqlcAgdMo78VKk8YW1SOnnHmRFeZtj+/uGpjGECNk4
	 MeCGUp1yFJa9spTLErk+XJRiNI0Vesz42IuV13X/HCJHV7a0v3MGK1vZkDMZn+aVNo
	 tH6vfNMzDLX9Q==
Date: Thu, 30 Oct 2025 16:57:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, osandov@osandov.com,
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm: Convert memory block states (MEM_*) macros to
Message-ID: <aQN83UYU60nVnEcc@kernel.org>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029195617.2210700-1-linux@israelbatista.dev.br>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58081A0012
X-Stat-Signature: ha1odafjweaaogr84zjhgjktndu1kyhr
X-HE-Tag: 1761836260-197871
X-HE-Meta: U2FsdGVkX19+ruqibpGWy22ChKpo+owwEzVqTJPW/fppw0//PV4BTF7Zn54qVZYyF9aFPxoHMIuD3WvdQLF+NPt6gPoCIKGMov/5Wz/bnOznn7mpYYk/U5ANrfI9+E3dw4/Ikr1uLLH8hEYuayhlltUzTksGb5aZQDKDmP8icI6/z6/Hjo1qP/GkoP9AixS20G19OX9VozNMyEH+GwXHBycgXlzw3qet9U0dk86itFusvnitXb3ABlYuEaKYQM7rmvmRwrsJwTzB+Kk7ojt+28mxMOXu4pb5JJGvj3cVYc8Tc176caAoVdjoPPEvFTsOHyJHdTfmfpgNlOX5sc3aUi/z2mCtGiqwAw//RprY7dahs3psVqkAAYi5t2/c6v6eDdbOgKEzFPSL2XoQiY1sJvQ/MHhS0S1oGLxoYz69aZrS4MvdT2HEYUO/xG0/Vyze4LvGBB4QnnF426H5Dnm/j+gUm2n81x23hHHomD2oeyLzRVeytuuf3hoA28bIeM6341EpdpkSHFl3smVV+11f+ZigQ8QXdvkStdsk2/cRHvMix561VrDAaG8iknrPFMbrPHmajvbZ8WSCeHGCmMI0xxLGVqigrRfJnBhLZ2WmhXbh9LtXXLRTlZy07zHNnQpjz8QpT4daPAbZZpsiRlWU8xOfhhuHU58kunltUSuNuy3iQu9Q7H2AZBaAntwUyBMLrESwcxPy8AkhC4dz5PCNkZ42yXhs0br2LPvO5H7z9xhsYJF+dbztsKyD0njzLn6C46F1z7QruRiUTCpz30QJw4WAd9QOfogrhmKkEYDoG4LRGAN/PZZb8aOncDYPdhdFjrIH5i7RKR/Ln6S8xVLesj7U5OgLYM44S2NQNLcLsrLAGLYZOQ+mnX2xdhHp6NWIEVay15G+YWlEhzD1Dqobtuun4R4wRDqGHJoT71X+eZL1y09epXZ6R4t49YH+/eklCXqJk/lvI6YmrAv6Go+
 TekFEnpz
 OdkiVX/MT9JrFTmBKVoepPBNy0cIDclrc+6fZptteWeMEUPsKbsYfLS53J1xhyMgMdzVDwj2g2KppPWG3WUg20CUMYt0f47/0nfy4s91LYimSCbR4+v8N4u4zHmWA7fUEdFlDO+Y5HtWoQOrrYhhQOG/klwzW5x/wvv2eQnbzx3opdA9QlpmwBqQUiKLfYlof53vG4oD1Qv4sICwb3I5w0GZ5JHo2cuMPJx2Km6IaDFCu6/gvbHiRP4WuD83dYfNLqAdEszAdnDIuF8P89e67Y97eYiQiP/Gok6ytbbhCRKPExSgcMAowU83CQCJvV3qbgnij
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:56:26PM +0000, Israel Batista wrote:
> The MEM_* constants indicating the state of a memory block are
> currently defined as macros, meaning their definitions will be omitted
> from the debuginfo on most kernel builds. This makes it harder for
> debuggers to correctly map the block state at runtime, which can be
> quite useful when analysing errors related to memory hot plugging and
> unplugging with tools such as drgn.
> 
> Converting the constants to an enum would ensure the correct information
> is emitted by the compiler and available for the debugger, without needing
> to hard-code them into the debugger and track their changes.
> 
> This patch series aims to replace the current macros with a newly
> created enum named memory_block_state, while also taking advantage of
> the compile time guarantees that we get when using enums.
> 
> The first patch does the conversion of the macros to an enum, while the
> 2nd and 3rd patches use this enum to clean up some type declarations and
> make sure that only valid values are used.
> 
> ---
> 
> Link: https://lore.kernel.org/linux-mm/20251026162156.12141-1-linux@israelbatista.dev.br/ [v1]
> 
> v1 -> v2
> - Rename the enum to make it more descriptive.
> - Let the enum auto-generate the values, as the (1<<X) pattern could be
>   misleading and they're not exposed to userspace.
> - Change the type signature from unsigned long to enum memory_block_state
>   where suitable.
> 
> Thanks to everyone who took their time to review the first version.
> 
> This patch series applies to commit: f30d294530d9 (mm-new)
> 
> Israel Batista (3):
>   mm: convert memory block states (MEM_*) macros to enum
>   mm: change type of state in struct memory_block
>   mm: change type of parameter for memory_notify
> 
>  drivers/base/memory.c  |  6 +++---
>  include/linux/memory.h | 28 +++++++++++++++-------------
>  2 files changed, 18 insertions(+), 16 deletions(-)

I wonder if we need three patches for this, but regardless

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

