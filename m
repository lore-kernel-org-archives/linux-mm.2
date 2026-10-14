Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4E4CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3246B0098; Wed, 14 Oct 2026 09:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB216B0099; Wed, 14 Oct 2026 09:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23246B009B; Wed, 14 Oct 2026 09:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6CDD6B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:16:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71F791404FE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:29 +0000 (UTC)
X-FDA: 85321280898.28.38842CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC0B3140015
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBho0QDF;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983787;
	b=wLmvO9BztPam0X4G/zEIblonHnakLfL1F6G9MlUMSBzCA0m7TQyTdD+3HlA4f2HcBuanLR
	RzFMHkkb6AmGsSe/lWSkehPYFEYnSZ4uEwBjTdOgn0mYd91qBajT3p6D8iD1BG2P9MzXEa
	IcK/my2HnA0NFivJuZyEauVlxDfXc24=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBho0QDF;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrpo4cN83jrj+e2I5RQ50g0XlOIzeJ58mg+PewPmR3I=;
	b=m+/WojZjJsJ7aRTrGf4nvdPz9DNnGQm0OB0hQkV6SmHvFzZ4S6gayd2wCjBSa5amEmKksN
	eKnnpo+ElN3bJb5JmBxq3yIvSaI7cC7ELfDI4v/N32/jNA8R4PYj6UszlZEKBO4YjPFSMT
	HQoCyET94ZtnP7MDxGHnmOUwOIra3bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 246D4600DA;
	Wed, 14 Oct 2026 13:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6051F000FF;
	Wed, 14 Oct 2026 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791983786;
	bh=hrpo4cN83jrj+e2I5RQ50g0XlOIzeJ58mg+PewPmR3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBho0QDF8uf5LQYJduMCtXsQHoR7qkt/9uXjiXsow2im7mQgSGD14LO/UIlh0jYpA
	 bRtbtrnXDJz05sPV/9eEiBlxQwp5PSiN9BkMDJ3he8d/9Icjqj+a/4YdKVXK287e6W
	 MCTrvva80BsCMHIESG2+JqR70b8iJS6KUjxt1B19GBlhZXupMbqsCrXFK6ww8U0XKz
	 B4GygYXRmfEBE1qeQUmtkOgW2WDrJXm5Q1/VXhoWCnQU9rpE4vB8OnKHGHST7n0DXT
	 Qr9KNgC0S1fgR2/eBzpe/4Xq57L6fT8DJKxBJ4IMY+Ojd8Jd3lx9rev/yVUTZDajsE
	 +dkHNMmbi+qpQ==
Date: Wed, 14 Oct 2026 14:16:24 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with
 GFP_KERNEL_ACCOUNT again
Message-ID: <as-AWdUncVtquHdv@thinkstation>
References: <20261014052338.nothing.279-kees@kernel.org>
 <20261014052344.384723-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014052344.384723-2-kees@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC0B3140015
X-Rspam-User: 
X-Stat-Signature: be1uk4rnpri1n8iun3se9tdfkxsihx8w
X-HE-Tag: 1791983787-625639
X-HE-Meta: U2FsdGVkX1+XpNHc1jRK+7P+S5OoYtOLP5ETj8lMcKrmD151OVXTpJQO8jVJiq3MTnz4q1CgDH6B5pb/s7eMqqtLsES+TrX3Eayp/3vEsUxKmAiAcKWv2KCEt1XQUI7MCkxrp4NP6xaaahg30qmRFl8hmdOPaFTq2wCpeWC3/CLAZmJNZt/27RDSUtzhHgOYQ08A3Vy/DXelBbTrORZ1d3PwkwAMSlGC+eXHgXkv0lADHtcbDGHQFmFT5MoNpBqsvysgekAfJ1glPkD861JH3ShdzyVX7AePlfL5aoim0DGcB8fPC2sM07O2o9PN5c4eUS0MOJVoniEoaXcT258zDPF/SoMIe9b3G8Kmlplakc/+jChS6rwuFv6lkfccfLAgZcxCZHeTIvXe9vCcr+660QJIROWarkeWt0Njb9JXNedbu9EcDIvPNzNZU5DecmCDx+SyoT+vM+dAoJ/AbGaMI4PqH9TLh7QUiEI5tWfQgJqvibTgKH69sLWHdmxH//Nq7cjehBH0NmqZ8yXsN68DnuCxlCoww/BWmLXahapqyHnzd/rme+xgbq8VgIxfuzN0soHsg6A7AadgEgiDEYgnDim0F/LIPdCncz4YPOLQOK4SvnHpX7Tlx3/dDe57ezd2x2A5ZhnG1jqNEBMl3IrWSYfTki2Vaxu6OixBNNgjYfPcL1N7hB+pOxDS6uTCgBLWIdSVdldUMXWQXHdwdXl8sRUuZdPg0vBvNliXrJLgXrWxaXotcMHiT5oaff7pbwT47T9fDV97tuBAc0GrbLtSd6cCbhd0zitzs4Wit+b+W92ix1KTkhdvzTobK/lDDICKP9fu2tm/6Ywu5waNYRc0emaTBeow6RF23yAAqWSXwfiakPcUl1u74E7fzOEF+VQZioWqzQYW7bOg80Q/7ZdiA1DclQ9kXm7TS6xhrU6jhfaxXZFf/8yDlN94GMGZ0G8jt9dmiKUvLEN745RklWl
 /h+JRVQM
 6AQWCvUAzUWArPp1oX8XF83/rumC89iQv3Sj2tIhM7Dn8y907zFTs4Fh+wRITKonVu71xyHgRucx7oUWcZg+zMZtpuAg41dIVNugu0M/JpGaKGFJNQMu+rDK9cC7wbOEoq4kZRl6AOYMqvA+CQNq8UZSbar65O1bubkwBufJt+eUHzkZeipBEN9kdRXNF4R4mgW8ZbziqA2uvGgQr7A1rDgf0iIX5Ym4J0BTi8NyHuhET6cAoUqiNWQVTb+/XIMxA/AXhZG67i0Qrg0znGeTP20QdyxABxiJJ4apU7Mmbou+kJQ1Ma4PgixCi4m+PPI3SmDN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:23:43PM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches. With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.
> 
> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
> allocation is charged whichever cache serves it.
> 
> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <kees@kernel.org>

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks!

