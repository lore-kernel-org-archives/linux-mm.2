Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7C3CD37AC
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846FB6B02BE; Fri,  8 May 2026 19:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E556B02BF; Fri,  8 May 2026 19:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B216B02C0; Fri,  8 May 2026 19:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68FCA6B02BE
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:52:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1520EA0447
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:52:17 +0000 (UTC)
X-FDA: 84745903914.14.818C09C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F4101C0005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:52:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wzlh+gEP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778284335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZrfoZ5tRa0IhSb6xrharpY1aKcCcuVTDXx+HxdTStw=;
	b=YYyjq15lbatk8S7IZylZWlQiTTLNNg3A0iNCGOiGWwFckwQJqVqbGmLDNJR4ZYpC8fmwd5
	Viq1jtVbWgtzFCujsAl+TuakNaV0DO+B5hOHOv064L2sL0S4yXARtP23CR2rVO/foPzsaI
	WGS7LG8DUhqP3mCPKV58TRoQ7uyNRPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778284335; a=rsa-sha256;
	cv=none;
	b=DVMKbQMSAeTVy3Ez1qfWaUFmOtBqaojiR5ZfxGB2C2x7dV7bmP0M3G082hymDMKb0nMZNm
	sU5MlUfJ8C+25MLHdpyJjXAJlRrQgAJl64/q+NUie90gXDv6VxfWCX8xdVqkDKeFsQR2NG
	8G1LYZFkanmC5O8qKyb4sWkT19xgefw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wzlh+gEP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D701B6024D;
	Fri,  8 May 2026 23:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A102BC2BCB0;
	Fri,  8 May 2026 23:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778284334;
	bh=2A7cLXV+8i/TgBjrSYIiWz4AFId2IjKQBmgGj/uotSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzlh+gEPH02pq0GYd3kbFX5f87tKrnkHWpp98MiqGJXFfMQfV/FVfxGStq2n1Icxh
	 at3XXnt4W0X5Z3BEVyZ+zNybdHl56jsrlVGD7IISRFDxSOnOK9tylItg4LH/Dwj+JN
	 zM8zb1dNuY8edXE0P73MWuuL4CLFssFVFp1U4Sg8OXxbrCtiB/PrKmvvzNLjDYkYw4
	 5zbeCegoitDyNyLbDmk3XOZkd/N+64K6CRKjLX6xsQPRTQq6n7Z4X4PogvYYrswWtq
	 73U0PUOs0+g4mN0Bd/S/Qg9eEYGHWSjQbpbYkwx8aZUufBfSBBbnWnnukD3AisI5Nl
	 so3vCz59vsOgQ==
From: SeongJae Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 02/14] mm: rename uffd-wp PTE bit macros to uffd
Date: Fri,  8 May 2026 16:52:05 -0700
Message-ID: <20260508235206.83633-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4ff3508b951ec4879177dd079003c3fa3af0a444.1778254670.git.kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F4101C0005
X-Rspam-User: 
X-Stat-Signature: yzjssnaecyskeny9s1app71pnfcuteaw
X-HE-Tag: 1778284335-830640
X-HE-Meta: U2FsdGVkX19RcsgsDlJn6ksnXVCCBIn0aB3KIVcl9LjsAaoaXxcwUlwx/4wWQG8eFgXFr3E69QSETbxcSl+3W9tNAC4Xb+NuC8Bs6dE9J7U0zlRvo1pM8iWHJc1NEp1BaxADk2ZdaFGwNcVoG5cF/ffEjgVhFXkelppH4206nyhcO9i6Cn3JAB2G/8UXUlcYMKH1RDTY8ldTSAZ1zLAHIf3NEHB1lPoA7Ffh7ocnt0j8G8q7fAQgRu5ew5OrL/LXz8Q952flxW3lVH6oPpCP5c3dV3Kg9ME95fI5iJO3xfnQQRdIYAsKDTdH02dEmvPbpTILGF/evMoOfVKRgj0Q7msmRGz5nr0S7oZgmXevEBWd0N5Sj9Mf07Qkb09ezxT2B5j5WeGdz8TC43Ggp2Bh+6WXWBQNH4cr80zt4aBlBuc1WBQzgEO0uQzbc2Db0Y3G/wX876rhQEz1LqKqDgCAzRU987srl0MNo3Zp8bvRDy/SkrqorZ2mjtMpQ+DkAdXmbAE31sUxIFL1oEgEk/As2/cgxMCdod4rhw3jE1CILgzdt/q/5/Dtj+t1ADDj5xlFyBA0ixam1L0lC2hDtp0BvbE0gAdL3uPbef3K+ViQlJAi7Yf8ePQ+mMPhl024PM8P98ow3GQE8x8AbzsUaj6YQNLtNIdd4Szn8Tn0TD3WTHyiJ4EiISRMpT4Cq1+OYHlgf059wfa9AiOG5ViVXR1/DGupKvFZwERjBnSpNvDt4bF0GnvnMP1pMrrz6IFxnQ5qTp29H3kFjUvdOjeOVSkTX2wtaGA679we/D1F08hvdLXMCU+25cl5VIRLmRwK6XY1Ho4Ar5BEEWR8Z+2FlTDGm4WLDT/nNrbMPeEShSsh4j4mWpd1s06O1gXRJBrk54flipIhwKhPVyZp/EbXV51SVlNnjw1ZOHYphml6GJCU3c4IK9RmZZ3u6en2kgPZjZEab3+4sXgzBfpiq1x7Y+P
 YqQ1Kse9
 UbWokVoBkds7fF20gb9dU3hZF5RoAqXGhLa5/2P8EsL9pn3Arzvu6OrXDldm/n8YWox2jnP1a2VGSK+K26YQJj6MHZ1UP2O8njh/7oz56E5agXGRdo1d5yIE6CBxIzcHGcMxV5twrzA5vRjIEUjovmHdMQS31ejuq5IF9KACY0y2OOUJySNmQHdfXD2blX71T23sc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 16:55:14 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> The uffd-wp PTE bit is about to gain a second consumer: userfaultfd
> RWP will use the same bit to mark access-tracking PTEs, distinct
> from mprotect(PROT_NONE) or NUMA-hinting PTEs. WP vs RWP semantics
> come from the VMA flag; the bit is just "uffd has claimed this
> entry." Drop the "_wp" suffix from the arch-private bit macros so
> they reflect that.
> 
>   x86:   _PAGE_BIT_UFFD_WP  -> _PAGE_BIT_UFFD
>          _PAGE_UFFD_WP      -> _PAGE_UFFD
>          _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
>   arm64: PTE_UFFD_WP        -> PTE_UFFD
>          PTE_SWP_UFFD_WP    -> PTE_SWP_UFFD
>   riscv: _PAGE_UFFD_WP      -> _PAGE_UFFD
>          _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
> 
> Pure mechanical rename -- no behavior change.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

