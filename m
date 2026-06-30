Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53511C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5666B00C2; Tue, 30 Jun 2026 12:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5516B00C3; Tue, 30 Jun 2026 12:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCC76B00C4; Tue, 30 Jun 2026 12:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E17946B00C2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:12:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C099C2F75
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:12:36 +0000 (UTC)
X-FDA: 84937071912.28.83C9FDF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39C30A0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:12:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IScDJw93;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ORLdVwHL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pE501suj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5khlqeX8;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835954;
	b=3v5+wKTxiA+bN4neEe4CftFx6GbaeC6JI0NgCVJHNPeDWM6lUbnM8rDnbX6gm7IvQDiUGs
	J4Z2wjPiGhKYJ/hNROFmKcVY3AM9vFPrVeVW4t7V0w19p7DKdJIRpYDU1V8tuKnSMF4/wG
	0I56FckUG9IL+BdAkHWhpbwVIkTlDZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmoXTjYHNW6fEkwTOVqrfzFYBz/Pk+L1OlG8eUPMS+E=;
	b=lihpofjzQPQ9sNMpZw5xLxQvcx6tdJU4g+DxmNn4jSfqDLtFovFBF/D9ATdeuTNtl5Ob64
	ZnmBOo0s65R7lnQpmt06vI1bsEOwJFj97mFt80cSL8KWLX7SSrPihyZyqY1YrRmL0mffMu
	c+/fcwBgk5sGdBkD0xUgZcHOo7eA+fM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IScDJw93;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ORLdVwHL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pE501suj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5khlqeX8;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DDFF471B6F;
	Tue, 30 Jun 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmoXTjYHNW6fEkwTOVqrfzFYBz/Pk+L1OlG8eUPMS+E=;
	b=IScDJw93PvTgItBHE/tZLJ0dHILMkLtL4CoHQRpJlOmOTEmI4MraRl+UYKUgkaoFz+Q1rZ
	xKGHBe5XCAVKnB+cmZcniY8WGchkcDjM2gf25M6llAdnCfwMRIbcQHqB8H2iOcAFQTXTC7
	8Z/Dotoo/7tF1IX8iP2hoRz8k3x18Zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmoXTjYHNW6fEkwTOVqrfzFYBz/Pk+L1OlG8eUPMS+E=;
	b=ORLdVwHLlcAxk3pomO43lH3edNfnTnGE4BX7hXDRqlcFkjhYztEL28ZzCsEr3/uO4LXIkx
	3MsoovGRHUbXSfCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmoXTjYHNW6fEkwTOVqrfzFYBz/Pk+L1OlG8eUPMS+E=;
	b=pE501sujFQ4sE7TyM1f0sanxmlsNc0WhBH50LIYnI5f3zrxRnsI9UMAvqymIlLWfWK+T9Q
	R7k+Eo5U3K5fSceD71CK2awK2Me0N/dFMRGFq0dLVTDR6Nfawl5ZOcGpPqm3sIXfzsqUH+
	ewBeQjjH595mCAm+bw9KrGzfF4oA9O4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmoXTjYHNW6fEkwTOVqrfzFYBz/Pk+L1OlG8eUPMS+E=;
	b=5khlqeX840GFNxsFksacPRH+yDfGG0TSn9iobZxVq0iZQzRfoTsD3cgLMeQXz/4StOoVdz
	OcPg64NLZZ1WrSAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FC41779A8;
	Tue, 30 Jun 2026 16:12:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oKQYFOvqQ2rcZgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:12:27 +0000
Date: Tue, 30 Jun 2026 17:12:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
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
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Message-ID: <akPq1JCkD5JBkFT5@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
X-Stat-Signature: t7x7hzcetb6sadtozcegjarfcmghggja
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39C30A0009
X-HE-Tag: 1782835954-974517
X-HE-Meta: U2FsdGVkX19Cnq3bVc4cM5AlUxB2OUaizKHM8A/fT+NmRPKIOc3HRlJSTWbGcdWcPLh7OasPG6F2RNHRxiB7pJ0P2dRZ1PTx2X+Gkm9eQGjhdRjlBJjlLI3P4p6AZCSzuAFCvWuJjhmnDTj/KzewwuADrIA53QP+5ALn5GEYNQsml53RNMEHCDKKDO6t0F8u+zIfIDc8XmKO5d17LmY1xuWoL8YdRj8vMyiEpx2Vd+AQ62nEaoPeFeYDzdiXLYfvMGOys+JbR96HBULBTx4epnCC9HGREVqVnwCVBN1E1Tud2iIgLAaSxQJcxokal7pJ7rC7NQOt/e+T5LZiruGv1mQgYIKtxc7OCbvENCdLvQg1MiwIcFixuFuw0GLcloQ1HcIr10bN8NGMkpJyjiPw7bqh57BC9laOZ0ccm7wYpv2g3wENA7JrWPXIfcwT4neRsdKGEcqaEhH81EjIaWz9Kbc+WyA92gb8VjYwUtjdaTcQGktvH8Zjl6pWKhcV1sEbd5Wt2o3ep/vNvjo8wZOJ/+Vv7pvIzkTPJ/5CGLnSABxv4hbZnNx0grr8QmhMu1B3cZnfqnqlz/VbgP/mL5ObBn8BQ13KdMY39ZnzLDhq6SWLF6TMLrLcY58iGodpzoJl6Djt6T0w8WQ9AoLDRIpkribkSNZv3Xz9YM2QNZDXIO75X09Dpi3koMKcKU/hqi0Ha1Jamke5HshRPfn51EVwSz1PHazuk/i08eBw9rKVACgwSuw/1c0nsttLuNcCPXZEqCMU5Y9e3O2S3z/ERer2H86vyl3c3+XQ5hn5eggLDPnCXayJHIorVbtDIUJnC77XXGkNxqU+1KdkrSelmASVtLKjL8T0mK4nNbEppbt/6Ng+sPwz4pt28MY5DgkPFIh1WZ6h/8tZVOWw+QJXVlhEvfzRtM7y+0a+wxNcCdZVR0cUTIfZgUzN0vlWgHiEVWUkb13acfVCpydOWWanlZp
 K6keeN1h
 Mi96Gqld+iYGHVraqIpy+sLbqyuDuA59cRFwFsHq7pTKLOIM/U9uVYNsXmAFijBuPvhmzqEOHyiu5/Q4i2PC2ZIH2J+Ki0guTEnGabrlGacIQRpkfSWCy9Sm9FYN3na2qXpUUTEJC/aoNyscTiBllutelXDPB8suP0HXdny1tgz17w+zN+nl38Of1msFudivTnBik1SNJQHL/WL/k7wVd6YyttNEQraGZzEXCF7xZsCXM0T6ZWNuHKA+WXR6IrrfROK49beSxddhHZ7Co+kb7rL+Ov3YsoC0y8WuYflYhxwIZuwVva44BunP/kWSMdea8OpI3kj4hCP6g0jlPj6OjgfW7k4NQWb1KCdtXjI2CuTDSmnb/exVugTM6V51SawjL2umqyiyMUBe+VlsoLKc3aYN31PoDAzTU3gmjnWQ87XP9sYfcHkkqBEM3/LC6FgazBnl7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:14PM +0100, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

