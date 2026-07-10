Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF550C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DE66B0088; Fri, 10 Jul 2026 09:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844B56B008A; Fri, 10 Jul 2026 09:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D6E6B008C; Fri, 10 Jul 2026 09:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53E0A6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:24:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5E00C1E23
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:24:23 +0000 (UTC)
X-FDA: 84972936006.23.7D3154D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 414F31A000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:24:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVnYB7qs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783689862;
	b=Ttem4iQ7mQTb/Dpv8wZuOaqEGwyABWM152Qyc/OvF1HvITotJbOb1eWUzR9d5dmFQtXUcR
	c6sNF4pCuoP422YNnJpNAiDBrEQdSYc1o2MHjF6Bcm+KeneGGQSlD66xOsVdHziXpC9OM3
	9nt0+QWA4aUX4p+CmPnav2oMddyUIbw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVnYB7qs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783689862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Fon9jg74hfJtQTNtNZd+Uj09wB/Cwtq9F9KzsKn9B0=;
	b=gwREaaovwgLH4OEy8uJLYtehAmttiaYfhrOude8xpjg3inTyc36W/BKTlXrTDDfT722fK6
	JSUsVYaZkUkQ1l5kmNPyjOkCZmFAuNHNpJhAdUCI5HY3KIZAjp39A0JwALZhV4/xP6B6QH
	WPmNxf+TMNChvg+90nMXwrD2bGYOavA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C438760052;
	Fri, 10 Jul 2026 13:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395931F000E9;
	Fri, 10 Jul 2026 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783689861;
	bh=1Fon9jg74hfJtQTNtNZd+Uj09wB/Cwtq9F9KzsKn9B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NVnYB7qshocoVxRV8CxAk3K1UiaS25s7tEAanIJNDA0I+JhoP1Fdjd3uEVUjDb36f
	 WAkdzxMki0U8Yxx7+84NqkzZYRg/fGDafcjw9CNYFfOueZcufTkoWVGJYRlmobzoKy
	 nYraqm8HB5NmLtu5MlKgLyM/1vNol7ynal2bQYMTCm/kXHbgnivt+hvgAzi3/9Vq4i
	 gs3bjvFfBU+pXvomK/gXFBg4whAGb6xa+9+JrOVyavRclkvqHHZQFI9xlERNwbUcB/
	 mTX45vQQ37tkfW1L4CdrW2xMXK/lcfHZS8UtusMYO7awfwKSvmQ55gzJnMiMD8/LOa
	 /T3YJLc8QfACQ==
Date: Fri, 10 Jul 2026 14:24:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
Message-ID: <alDyT43CLwtBtsAa@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
 <alDnFGncVvcjsvTg@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alDnFGncVvcjsvTg@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 414F31A000B
X-Stat-Signature: ci3prtpauytd5ad6rsewsjqrh4qytkhd
X-HE-Tag: 1783689862-297417
X-HE-Meta: U2FsdGVkX1/ne7ulfGutMuUygSEb5r48lUiejztirKLYt70v8HRwWRKHEsueWpxMvg16rNteB2aikohAaMxq9nZNbSfcm0bx2HZkPu9syvCQ3mv9h5hnNXd4tg06J+xlipnVixfBHgJYE8lTdOe+nPubL3Zb/lv7IpLI+R0U2LLuONdmDYY9uIcFF7WMnYKlBKGizY8jCEWVbDJYi+I+AFqoS1VEJUn1305j6Gr479Nh58jMfYqnxm58nu/BrOSpwptIYGQRxVxZ4CaHzQ2fbwgdzTw3SIxeP52PGYSNQeDsTi2IAX9q9+MoYAihxU8FVob7+gwjxJl3Q4ZzJUOZUQI9xOf/AlLuDqBl8dRAZiiWA1DgBMJdIgmPM07p2TWAULfjs39/Tn8NbAZDgsq4pbP83cLK2c+gu7vT9LPJHOg3OkboOS8u8S7Hu/BjPNpgYk9mNGj9WG5Ke5STCNDC8sax6EwVhcGrRuRgh75RVWj8JUnmJrNfTnvKDp8yML8JnLEAm5kAQFSRXV+6SB0SBNkGut59wsVaQgL50gGdqsmaM1+Oz2Kb9/xeYJV16EzPYG53gfZdVguH1KQTtA4VZHh9euLYnoGx9SctPzWYBLCW/WGQZt2mWpdMat1kRwW+xzgto39k2g67XxjU0boBPkEEU6CLC+5FRFFZSaUh85NK1e/+hhxLmLEdEPshRLf9DwMFAI8fcJT3ukuFn+H6UGRREPrLHD69wnZUCDwCin9MYX4BGtlbfsQOkGgPXRBfWc72w2qf1CVO8ofZy5jRVAhFMd3agsuDOReCkC+YW+5DtJ4v6whnf2z0t9UHUC6syL40+H+/mYVY3P9a4wEuj0S9mTwXW14Uq9ivSMePhPY8kYpg/7XA3sr5BQjfLiYQ+rpROTVZcWmBVWAHnT9ibiboseKzTaAphFTLJYuXkgmtV8QG0k3AO5wx1Ja/QA+xMmjtaTiQP32jdftAcyT
 pmhw+6r3
 AsL4GKf1u50I9X6B9nxU2Z+qNWYUNNFokgvBQMF3Jr9J1db1nk4+uDRoeQVc3YKmvV6rfStismEMgTNcxlodW6ue6gbMIcEqSye63cn9lmX+GPxW10/qgcwhoXvrVUfNSsk68ni7TyfU9zLhI+NB6ewCRUaVJ4cErl4VFYxrKGrxhjUdTgBbbpP1HVeIQ7FQ/T0N0l17VrEG2vbARTiIXzCNQq6sJ9VTQhLmHQtOylPRIkLcC9KeVKRfzAEInDlV2Wr3FDaVh6x7LZLxqCef1NUftj5W2+Y8I148J8POLw/RvmSXf7EHnQ7c4flTz8Eap2p2S8xhXn0G22tc5aIW34hNMIfmcWojmn1b2Wkf59ebmUrrfNPSckkegT27Ce8VDa+yDDiUVg/KJzFefRE6ZuSnmID0OYxlDT9BSYW9cjmgpS9E6rOq72cQyprb26iJoTlNxncZ+D/pfi6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:57:46PM +0100, Lorenzo Stoakes wrote:
> As per Sashiko, we need to account for x86's slightly bat... interesting
> ptdump of non-init_mm page tables.

Well it turns out arm64 also traverses EFI ranges which is kinda the saner end
of it ;)

Patch incoming in any case. Will send separately as each patch stands alone and
this series is fine as-is.

>
> The fix is to take a nested init_mm lock in ptdump_walk_pgd(), which is
> safe as nothing depends on an init_mm lock prior to acquiring an arbitrary
> mm's lock.
>
> I think this could potentially be sent as an entirely separate patch, as it
> doesn't change what this protects against, nor the x86 CPA patch, both of
> which stand on their own.
>
> Cheers, Lorenzo

Cheers, Lorenzo

