Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE50BF54AAE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625816B0088; Tue, 24 Mar 2026 09:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD096B0089; Tue, 24 Mar 2026 09:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A0F6B0092; Tue, 24 Mar 2026 09:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 424146B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:07:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA8DE1A0A01
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:07:50 +0000 (UTC)
X-FDA: 84580983900.25.DBF84F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD71E20008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:07:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQ7BZOZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774357669; a=rsa-sha256;
	cv=none;
	b=SnYW50P5qEh0nDrCnSjLVuaVbbtVwl3jrWtV20T+Pn8uds9VB4gYldxs9dnjyQrstMYxCE
	Lw/Ghc3XnVdTJBdw9aGYgZkj/r0c/q5Cra18b+Ed9eQYZbQDGS7sNH8KIQCPCNGqSRH9FO
	CwxSDkyuDyEwatkT9dqGjLQICpC1hsY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQ7BZOZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774357669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRGbIUb0EQm0rctywk7+xt7O9tRl0h0TGcp7300WUQU=;
	b=Q9RTNVZleEqDbAesttBINcfDZKb2ur/k9GMegQUj9glXzWSc0guRLyFNkFSqYbA94TQRd5
	zffHrdXVCtEgS+B48o2J6+PVIPx4OYULuO2DfMqF0W3RfIbxaGokoBbH3AwtqFQYHYeg/v
	p5yESxVBiqcrU0+U+IQQAebzMdAZoEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABD2541986;
	Tue, 24 Mar 2026 13:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60BAC19424;
	Tue, 24 Mar 2026 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774357667;
	bh=B/Us/uOYeoEX4+nVZGmaQnHlVPKI4SH/p55yVCY/ql4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CQ7BZOZ9qGuCpvkMvx/CkKv/Bpd/0yNDNmoy38tW59w0wZqYaxcfMGgEsvApFS3TZ
	 GvkLV29oJxWB1g6zZS8Q99SV/2waKTl9Au4EqDa5YV7i8RXe5BDvad/yXgE8jgBgRJ
	 9Q+O7hxyjoNTaBsZQlnIVYxJZAPPfzP80rz1SK8vpSp5I0NU6lQCt4/Gozb76KLqHr
	 OwgUblG2jzYkxHr0CdvGvZUWY/kmFif8Aqa9rGggHTtAt6nQHzbrZIfdNgEiZl/HEF
	 CRrSVpDAj4KooWbqQ55j/OW/TTjeyKvaZl85v13gKJKjFnnKkaVnTAAqODr4blKYlg
	 3mgk+oGiYqxDw==
Date: Tue, 24 Mar 2026 13:07:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build
 option
Message-ID: <0dfd659a-f4c8-4356-9b14-960ca70c0d68@lucifer.local>
References: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
X-Rspamd-Queue-Id: DD71E20008
X-Stat-Signature: 96gc4qsuf1d9ed5gakcrnw4rqo4koxcs
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774357668-112210
X-HE-Meta: U2FsdGVkX1/5A1BMa0C4ZWsLrPO+n/K0XbjinvNKHsnBlCaIFBtOK80hHwsC0LpATiUJeFNkbiQDsQNqAfPJyn+f1aQ4cPdYIpUVYQtXdLswzUIbDo9RfL/cJeYQM8RphD6nzFpJIa3JQ1kEJW07rpXyWBvqrtUU5JVeqazWvBYHbnQaVM0QUB+7vKj7BCVMiZivzljB5YnzuUfDmxotE5eBKl3SHWk7LeLnIEHMBTAVF98l3yFzxnCVnTwB0obACEvUBOzWssePIJWMbajlFnv/MY2Y+1wYCWjvaJqET0LIg5NgSQ1SATA6Fi69w1SScEGMCLO0Jj0zfKWbZWK+SHEeX2OZlIsl/gHlbXQhiP14bjT8hmudwS/7CIF/5sz7CGizKuovPDh15QwYy5unwVGUd1GmnTuk+1eDw5bKxAbMEbu2Xyne3ARXM33eCR4rabNu5+sf8R6jSziU12jeayHUECey5/0vdGkcM0z1ctcZ5+eJAFZIaZ4JVWEr9IKNJDXRlPEDkU3c6nNt8PCHeOtR4KFbwwZARZlXPxgD0KhYEoVyWFNbC10fOdanq8iFHbQU3jXWdSqplG5DuOZLz/ySELr3SmClSdR+JmGbuBXF/R/rxaj0twVeaq1wm6nyCWxXS0HoMdz4R+oWOwXjKy3/NSl00/gHoBbmhcnI3UBQT/DCo86vAZpkmgCfH3EOWn1gH+rX/0e34AHbgWCpbbDjjSHrZ1MDU9xCYa29jjeYp7d2lVHeRYM+22Rm3TOhwWNqk8e1ei25YiBxnc4nJPFxPwfqIboXXTc+zhEXA/c/sKQfnMNFmlwpAK9Hk23nQOWohawYQbdtnyyEH74kmVSJbamCJyy48D5I0aP1H1w4pWL7ITG3Al71lWDzG8EcEGxx3a5Anre7MFN7Km4gUYHnEWUDR0kAg2poWsgXv+5cbuhnsevwnQcJSUtyTjHGF2Fq1/cUxvPwZ/hFoVL
 AI14G+Xp
 5f4tHSSGuJNcvufs8FfnWo+KNMXTJeV7zJ/BzCXgkqqiGszLc0bvaTGkcVxadDs59WMmz3XHcq1O/oP81y/jfCkzB52LYDR/QGhGha0pMiDPeGZaYFBv3oNj4wQEZylcn3sR4aRrFNTDCPjL6+OuO4UE7S0xRZuYoq/U2wKIUVSkElWG01BPhcGvBKs471g97NAoW0S54Uale4+7bvYRv4oLeqcQtOCb2zVlDS2Wj6X/VTj52WmVWh1LweZxQxiDTMUVUlIOhNcy3Y3PANw5sU5hTxrhNtpeG8j3n4aUVXzTWtSA12Ub9A7zuPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:12:13AM -0700, Breno Leitao wrote:
> Add a Kconfig option to default kmemleak verbose mode on at build time.
> This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting
> is only meaningful when the automatic scanning thread is running.
>
> When enabled, kmemleak prints full details (backtrace, hex dump, address)
> of unreferenced objects to dmesg as they are detected during scanning,
> removing the need to manually read /sys/kernel/debug/kmemleak.
>
> Making this a compile-time option rather than a boot parameter allows
> debug kernel flavors to enable verbose kmemleak reporting by default
> without requiring changes to boot arguments. A machine can simply swap
> to a debug kernel and benefit from kmemleak reporting automatically.
>
> By surfacing leak reports directly in dmesg, they are automatically
> forwarded through any kernel logging infrastructure and can be easily
> captured by log aggregation tooling, making it practical to monitor
> memory leaks across large fleets.
>
> The verbose setting can still be toggled at runtime via
> /sys/module/kmemleak/parameters/verbose.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

This seems reasonable, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  mm/Kconfig.debug | 11 +++++++++++
>  mm/kmemleak.c    |  2 +-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 7638d75b27db8..91b3e027b7535 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -297,6 +297,17 @@ config DEBUG_KMEMLEAK_AUTO_SCAN
>
>  	  If unsure, say Y.
>
> +config DEBUG_KMEMLEAK_VERBOSE
> +	bool "Default kmemleak to verbose mode"
> +	depends on DEBUG_KMEMLEAK_AUTO_SCAN
> +	help
> +	  Say Y here to have kmemleak print unreferenced object details
> +	  (backtrace, hex dump, address) to dmesg when new memory leaks are
> +	  detected during automatic scanning. This can also be toggled at
> +	  runtime via /sys/module/kmemleak/parameters/verbose.
> +
> +	  If unsure, say N.
> +
>  config PER_VMA_LOCK_STATS
>  	bool "Statistics for per-vma locks"
>  	depends on PER_VMA_LOCK
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index fa8201e232221..2eff0d6b622b6 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -241,7 +241,7 @@ static int kmemleak_skip_disable;
>  /* If there are leaks that can be reported */
>  static bool kmemleak_found_leaks;
>
> -static bool kmemleak_verbose;
> +static bool kmemleak_verbose = IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE);
>  module_param_named(verbose, kmemleak_verbose, bool, 0600);
>
>  static void kmemleak_disable(void);
>
> ---
> base-commit: 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
> change-id: 20260323-kmemleak_report-a9a103ee0c8c
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

