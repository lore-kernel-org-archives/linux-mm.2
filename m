Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA55BC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978636B00A6; Wed,  1 Jul 2026 06:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928926B00A8; Wed,  1 Jul 2026 06:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818B26B00A9; Wed,  1 Jul 2026 06:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 556916B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:18:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C70F7167D17
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:18:48 +0000 (UTC)
X-FDA: 84939809136.09.8AD1585
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B71740010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:18:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXQrg9P0;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782901127;
	b=kI3x5qjK9l6Le5pSiI4/1ZZ/FfQRV8kzl1n6LW+yVFD96C1DddWYeXK1pdMEgWhyRR2pnv
	Y/7tva9anyf2vUluzpGunc4/kG4Da64aqMhy9XLi3MdFpmBRcUjvn9AV4PxW4cVDru7m7s
	UXbVk5A8infq99iMrTosVBRVzahwrb8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782901127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM9/CaIlMkjQdFefjm0dVPPjkG/0+O7+5RX4p75h0x0=;
	b=TyOJa5LMS8FJsoe3+VRfxf8r2NBIEwmJucrVlneBnobrdUfU34f0VQlG+QvmQZiB3J+ys3
	nNV2CKb8p9sthj78z95yoIcBiLeWnejYE1W2joJi/qUF/OqZU1Gg9k2WwUQK8aXJhZnk4W
	i6VFwpkcekyxX6XbVH0SjhGFf6O5j5M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXQrg9P0;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED32C44063;
	Wed,  1 Jul 2026 10:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783341F000E9;
	Wed,  1 Jul 2026 10:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782901125;
	bh=JM9/CaIlMkjQdFefjm0dVPPjkG/0+O7+5RX4p75h0x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXQrg9P0AZleFkeFS51+PjUo+B8xcdDVE6tYWDlNGuGdgBpLyKHJD6elc2v/kcqUE
	 8Pcm+GcqRx1k66nL9Uz+zEQ1FGgN7fgq6+QHDdXkD+Pdz0aJff6p2k0V+rzm+2Z3nu
	 iSsIViklzABlCCMKzkBXtJrZyVFo2V4IsTINTz9RKasIkvyuDEwuSlPRQaN1JPh1Ph
	 4s6fRT7pOmRvUznm5PfN3Qg8RbN5uvU10x5Z/rpOw3czvOGlanwtN8QcTVROHG707e
	 UmVvX7bqHJU1MBVNsmN1D97wgCCjA1bFiUR7kEt/Ogvvig/eVyWKvzrNW1JuZ23oNU
	 HGzRMycOX4fdw==
Date: Wed, 1 Jul 2026 11:18:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akTpXVhj3unHRH8o@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPvI4r1rnxxSbzW@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPvI4r1rnxxSbzW@pedro-suse.lan>
X-Stat-Signature: qwhcts7dmbsk5xybtdf945wus9wzsp7u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B71740010
X-HE-Tag: 1782901126-730670
X-HE-Meta: U2FsdGVkX1+2VxZRdIzszUf+efOkAQ70K9LU6xeH+lEaMdBsTDETSXZY7tcHZXanf53UNbO2k102Zq2TGVa2cjPJX8tzVO8sRXJ3QtCtnHVlzSp+9h92cPdAC7L+HR1PscV+WwGMqIfYDDNPM9nfN/tCuHDTyLkWAPGl+R/2+5T4GMZgi4Fwn73dlMSG6zTzEXR+jkbIwnKKYNuCAW6G2zzuskhyD0EfSKJzLxvL7Rp79CM7kXkP3qI6G4DLZo/tAMYreiNDDZD1PB3iPbPJYI3ztY/knbck6IfedWk5Y1Z2ssacdDWp8sIW7cyFRc6J5iI2WhlHrNgfbgOcDb+YvCewDsIa6eg8jrvPBD4WEsSDIajyxGQBnnpMf+YDgZ8rlzSSp/+dpPf5cGcOrMJvLfEJNEA+erLA3Lv/SRz7dSRaibhbxSZcVHfDvad37GccgFv2/+AnkuMhhhjlfHhgFWVBTfJerOiZ130a41Kno6I9JSnWL7LmrR0K7/LcjpFJORtsY8C+o5NStBFQtoi3lHZegGHcHcvB+ZAY565bUfkd/nKl7j3/ffrSSGqf9vl2cHSDm4sR1jo8GsaaGNIZUHQW5mI7/SzxAhP/OJY8mI3IBRacOvzp7eBTfEXiFYRPoDqsRrxO7DJ9CGmsdbYo55KmR3NCNBEwAEU3N3i+CAdTP1rHFMKD3Fyl5IOJwjJEr34g+/nXM1h46ct6RoPsezLVBurpuPkax+yL2T6TCI3n34QunGyoBsbTZCcpg0UawZdwH+fqzDSHjy5Icq7NEBXLFIf2tQiFuc/EBWEUvTlS0uEC+9DEsUrQvB+HUhrovLRVz6olTheO0nqFa79BqtcCcKv/BSRp7+GLskKcVWzT8qjCJyTUW9BdLJYKZwWYG6z2fOg0gC5bQq4lsJ7zPg9OAjfyJC5qmlT99QYhd3rHrFOo7T+I7EaCF6Wf341M/D1c+WmfrWvbZKgF7pD
 W22WmSdU
 umKMm2d9V/NUJKDHH3adMxpwKezBuHCgB4D54+vWB4B01q+oeW8o9XNSEDHCNgDqei6y9O7pMTlEj+agtSimSswxtwsPq9XsyrEVq0LOw1rMlIsv+jFd3r5WmWpFzJDyQ68R0OPdp+WIonlVIvXXk5LZ8g1bfsEIaysJZwmg2fYL9AldkBXLmmAid6VG3pQ0MqyUFja1a/RccSTjkho0/s6cQKGyMlFYZaDIDzHra+0noRaQyw5OFU4a+Bmsux/cOwizhcn5TBEAlizLYB0VyQLuVwRwIp6mo1uzia0fRLDc+eQwvfIf6WIsOr3GlJnYuZZ7jlK8z/MTt9bjomPGn/dVpgA+rRQMCsOaXLVimHKoG8M0/2Y3/tDrzizrte586tiW5tGk19djd1ZJwZIckaRrXBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:32:03PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > Similar to what we did with mapping_interval_tree*(), let's declare
> > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> >
> > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > anon_vma and the functions can figure this out themselves.
> >
> > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > to 'pgoff_last' to make clear what is being passed.
> >
> > Finally express page offsets in terms of pgoff_t to be consistent.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Yay!
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks :)

>
> I have a vaguely similar comment as for the file part (names could be
> simpler, doesn't really matter whether it's an interval tree or possibly
> even a tree), but I care less strongly about anon rmap :)

And yeah ack, let me agonise over that a bit :P

>
> --
> Pedro

Cheers, Lorenzo

