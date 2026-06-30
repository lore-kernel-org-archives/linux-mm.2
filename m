Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EC8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B986B00D2; Tue, 30 Jun 2026 12:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBA86B00D4; Tue, 30 Jun 2026 12:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F1C6B00D6; Tue, 30 Jun 2026 12:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAE46B00D2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:33:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC101C70A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:33:11 +0000 (UTC)
X-FDA: 84937123782.01.702602B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8AB31C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:33:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0jqsM3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jbwOLCaT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0jqsM3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jbwOLCaT;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837190;
	b=3jMgYngoBzDyZs+geKZAmo+1aIx5iDak1uNy55xKyW5vViX27rl+15IvlGENteLs2Mfy/X
	Fw/e/K8ofVewLqmC7irB1SKmQ6lRQptCxMenJLV8LgW/ek5lYfCTX625gNItE2860S3EjO
	wSOmd7OKnz8XD2e0geLDALxog5405Ko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDyW4G4KkvnJFpm6kj2YxbwswbWtSr2YVelIEZ0RQoM=;
	b=XgCF4aqUNgsB6BRlAUoWIVGzfqEiX0uTqr3o/1fSSJNFW30ch7sM4ovG/yLOUFfyruByuC
	xAxkbkgb0Fz70l6BRgrZMX6qKdhYlI6bIE86OqHTXHMpslCDgeIbpVVfRed+UtAQ48eOo4
	EwyWw0ZW027EcOotzwK7FuBehJ9J8wg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0jqsM3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jbwOLCaT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0jqsM3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jbwOLCaT;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B692736FC;
	Tue, 30 Jun 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDyW4G4KkvnJFpm6kj2YxbwswbWtSr2YVelIEZ0RQoM=;
	b=G0jqsM3Uw2U5dFyI7kb6trETpxzY/vWY7kXvixJZsX7PXzXQnLelS/Vp5ENAdV93UwSbQM
	199SvPFl2WaWcPH2PDOdASpJk3YYKhE5hGvFp/BlquzLMCtsYMftLkQfF1/eUqfca5EOaa
	VcAipHUHAZkRKUb/6RSVcpWDErjavJA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDyW4G4KkvnJFpm6kj2YxbwswbWtSr2YVelIEZ0RQoM=;
	b=jbwOLCaT4C6AQNLnPnFokwOIq6AFMXfhKY/DiHavJEMe6z6FAeEYqGwfr6V6n0m/0e7Bz3
	wQ4as9XxXhjCnIAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDyW4G4KkvnJFpm6kj2YxbwswbWtSr2YVelIEZ0RQoM=;
	b=G0jqsM3Uw2U5dFyI7kb6trETpxzY/vWY7kXvixJZsX7PXzXQnLelS/Vp5ENAdV93UwSbQM
	199SvPFl2WaWcPH2PDOdASpJk3YYKhE5hGvFp/BlquzLMCtsYMftLkQfF1/eUqfca5EOaa
	VcAipHUHAZkRKUb/6RSVcpWDErjavJA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDyW4G4KkvnJFpm6kj2YxbwswbWtSr2YVelIEZ0RQoM=;
	b=jbwOLCaT4C6AQNLnPnFokwOIq6AFMXfhKY/DiHavJEMe6z6FAeEYqGwfr6V6n0m/0e7Bz3
	wQ4as9XxXhjCnIAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 378E2779A8;
	Tue, 30 Jun 2026 16:33:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IOBJCr/vQ2q/ewAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:33:03 +0000
Date: Tue, 30 Jun 2026 17:33:01 +0100
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
Subject: Re: [PATCH 10/30] MAINTAINERS: Move mm/interval_tree.c to rmap
 section
Message-ID: <akPvrXtEOZS8LWxX@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <91dde21e9084bd04b626a1f073c3b9b3a23cb663.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91dde21e9084bd04b626a1f073c3b9b3a23cb663.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: uxb5xojh8wso64ugwea1y6unq9dt519d
X-Rspamd-Queue-Id: D8AB31C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782837189-947023
X-HE-Meta: U2FsdGVkX1+wAYF7AaG8SnH4vffWDE+VfBBzWfQer9V/qvRI33jvPUDR7MYCjEMutGcKvrtCCBQGGdI55PBjtiy2WfSXUtsy7L85jEtuaJWNSUZ2G41QCkLmZ5+iPFfSb6rfPrTS2IaIEAsMUEuQ6Qqtpt+M3peLsZ2yM+dfLEjv3/iE7E5lDuQbsu3oRChj7YLZol9ePyd6gi70d9Vv87IZcF/F5duwtPBIfUKM3dSzClpxSHCHy5QMjrLFOz52VtGVmK+aikJtcompvyX8WAc/4ziqPGlxAF5SjaOUpXVCDvWRk4u+gmkCuitLIQOBQlOMYRVWn5lkmgR/x1K+EqqvzfqTf9P7zPP3/pSnWqqN1jAByEU7BnGiRdeDaBOjIlAQ1sIetNXoGncc6KSf48UN0bpJr5DvSykoSIaDsix47mxXX0yq4oZSE9ImABZiqcRnkFho6Ljq31h4jdex5zyucsp56dCOLrKhY526Nq/VhkWAdLA0JuYlHCLKYRnQfOJ8RtREEq1Gdryy+UUjokg1ckfry7efZIEXQo4ykeyrETPn0Khe+hP6RUUGj0lPtGElaxycNCgSxxscSxnHaWdn0r7jNzGJFS/oyrtM3pqPmVZJZUKWLcOcge/k0vQeJAWqXdta6zWYyzXXuQrAXMeUZnGaqmZ14wpP31SNBzPdMW9fo8P3Bd3UmcPMRPMiodLHRJFzr4H3p8jOIGjisdUYIC7iMLjoy1LUcQ+D9EbDk8wUfaYsPZD1BB0Ypg6fCjysiRAt38CnB49lvw2Xuw2dPxzmU4MWb/kDe94xFaHSwBDobJ8GcpVSEfdoVsvHZGodw4RlmuI9qKDgEyKqBRVfBCxz24ESvZj0YD3fOIzn5cJ75maTlTf81y3AGFchJy+ZVR+wJGTYYllDJ8du27PdRGS1cgRXPjsFS2oXaTTbldGj6BnXTLKpObjLsg2lYePG+Ytd826t4rOp867
 e6Dcs9iv
 Bf9wibIoRm+RaAs8dZbMlLnVVWdz7mIQPrN/t2uie51xjsXttHbSq5biuX624Vzo6PPe58NYgfWHWgzN+45suBFmwAVKtzjlpRgih0tPuh28iw/D6MZbJCRSvm/uH3T6N710F2VZdMzFOsyVLwx0sq4lgI9EirHCsg5+vTk5jEfy+t+TGx5+HpcjiTKFU8brT/Pptde2x5OCqZalp3pmD2fzhTyEWWvxKmtyDr9dKYFk5p894/JIVe6tEL+AUNJQFUwvftYAtfficxNJdLwsRzGlbPCa0lJqY/Glwy5tENph59zWiNCsbLVDIl5djvhCCOp7mnAPljGbGPokp+PKkcj40iUNYk4LgQoIcNsF6rkyAYamG06elmgU0C37TGF1aJabr4i1ereco+O+cjM9lL48m0MAJ/Mm3saAN9MEsc+n5PJPRhuhrwylRmdUfOZPkLLL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:21PM +0100, Lorenzo Stoakes wrote:
> This file implements code for the interval trees used by the file and anon
> rmap implementation, so belongs in the rmap section.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

