Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8749CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1459B6B00B0; Tue, 30 Jun 2026 12:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DF26B00B2; Tue, 30 Jun 2026 12:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035AE6B00B9; Tue, 30 Jun 2026 12:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4A486B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:19:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55AC5A05AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:19:27 +0000 (UTC)
X-FDA: 84937089174.13.FB0D4AC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D3EE20007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:19:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bp88J+lh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBVZJHTz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ypAxO1gK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tO9woAdD;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836365;
	b=aEpLaCJ0EgHiRoCsUdo+PsZwrsTxbFyowbM0Xe5J/CZ0MC7t40EXKxrCoq50V+hozz9pFi
	/YWmWUHTAzHgy8n9S8ideuE8G62iYIBjS1/dIazNsc8Fkq8Ly3bLs+TDvqixwMmd2AKPVR
	H6UGsSbUqRFpQZgib3E17FJSKLoBH/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwxxOysWKobPD5UlF8mjIU0+j6+KU4KiqW7uzYDC/ek=;
	b=BKiKeAL/z/kMrsVnCJE/+eDPbFDhKNNJOJFJ1cOjFltPcJUuE4BvynYJg1aZXCzavWsGXh
	ho0KtDMsEX8MYb9ZX6ng5my2+AGNycIURc/CZrPdwghzEsHhd/cDNstOeWW8zdVULmS90J
	bD0EEfXPERebaVSnDd5AmyJJur1qeYk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bp88J+lh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBVZJHTz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ypAxO1gK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tO9woAdD;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE1BB73684;
	Tue, 30 Jun 2026 16:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwxxOysWKobPD5UlF8mjIU0+j6+KU4KiqW7uzYDC/ek=;
	b=bp88J+lh4Ld94QLb/FgxSc78EMcIhQAsR8PDfC2OkzpEPkYI12ZSgnttOpJkZGY73S0x/Y
	+7bgS2BZHogPBH5J1FJpmwzYjtavfVf6uelEie7YrbKOXGK3LSeBHpJY5h07tuDudJDiWu
	jh98BikBWca7bsCsXuf3A7wH5JsyjM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwxxOysWKobPD5UlF8mjIU0+j6+KU4KiqW7uzYDC/ek=;
	b=jBVZJHTzVzoE0M2g+PcL1BZzDdNmv+XSGT2v6Wu9el0LCF815lqezYdA5vJfGmUyjSnQid
	W06sQywmqiDF22Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwxxOysWKobPD5UlF8mjIU0+j6+KU4KiqW7uzYDC/ek=;
	b=ypAxO1gKMdIHQ8+ywHHuDwYNcjoy9rSDILpeGDU1FomJu6ky3ZQGryK4UvLVW1g9pfP1Au
	L/5zy9jUtBQg1Dfz9gtdqXOt+qSlZgJ3kOyrpuB2VvuSo+Vcxb8rewchUhOO4ShufwgYYo
	7+BE+yEMVAdC5umL8fl/GyJn6nE+y48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwxxOysWKobPD5UlF8mjIU0+j6+KU4KiqW7uzYDC/ek=;
	b=tO9woAdDVgqM8KEyW+ULw4DreASg4B0YhphL0oz7tBKd3s5SUtC4zeWGlkFFQsRsvp058J
	YqK5R1Lt3StFr7Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 539FA779A8;
	Tue, 30 Jun 2026 16:19:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pVf+EIbsQ2rzbQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:19:18 +0000
Date: Tue, 30 Jun 2026 17:19:16 +0100
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
Subject: Re: [PATCH 06/30] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
Message-ID: <akPsGrmaOd3JMlC2@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D3EE20007
X-Stat-Signature: 3gdjpg8ostegh4h6xrqbjr7fbwkzy4ag
X-HE-Tag: 1782836365-46904
X-HE-Meta: U2FsdGVkX1+jz/lQrjC1TvxhB25+PN5D68aLmFmCvj6rkgELAYgVIlx/goq1ytCBPqnMUd1DB+CzjykFaMsFrJcB0PYfiOoJ2T8wJVAAz2GeL48YTB2AOQ0yxwNcsZ8en56n3MHVNQqtWMtrnT5vr1DPNx0CWVOuh1RQHpgxr6mYWMb+bKG/fWa4ZAuWgNRMjcvuD4BEZJ2t5ViwnscHBpISSEvYM//IZTwchjSHMTYhSMvS+aGJoh89yG0qVgFWl14+WzwUN3eJNpAv6wV+6lRSS8m1ppKn/SoMmC5vR/FSbZjLHlW2WzNc0vcHU8ntywWd1Zvb8nel3v5LblM2A3aCfwOqS9BFLT3bBkHDCvmUH+pE3+tFz6JXhAthm6XMl3KlyJ9bplCxBE5bXUyQv97cBmX5/k+pgvb0jurhd6f8QSNTrTQri23Si1vbV6Oi9G4SH9xFv2B9UHAlfVCjCIVq/5P0F8CNgzlojA1e94Kdfiq68oKm2Gl9QYV2P52rX79YdUn5mXWcq+nwpXpoZC4g/113TxZOt23kA7fsbGtMoC16jLriDmyLHErhOFJWdF2BEMv4sZd1vDZlHl3QLdA/6Z9WWpYB875qycxSVxAkaWEK9+4I9+ZnKCOAKknIlEVt1373xJ7sjdU5gBBt1aEThsniETU83ASFoXymbqyTfqHbGMhCFDiHQGvVy2CtKGQtGrjYqJmye8gHMGjaJEs6UqwxnnE1b3Uo3T/LPiMQVUrcQ2qaHpHxD1s2fuEhLIIOgrYiz+ELrqsSTdmKvd/VIEEPdNJDKEepyKe0FOLkV3LQQRMLBa+vibHZWqvow9FAQCNcbvdBLbwibCM0K8ZVZXkiu2iQ2YzSMn9tq/T3ut1d2HrXM1IS/gQpMBgWZ5CsdnppTrzRxJOgtez60D+baSaVZmi+hQzGrDCLzm8T50guSoQLeJJ5DX88wS38HAnIcdET2zCL1FxRJ3Z
 s4rT5IlC
 whvAfu6mCdrytvI1Ov6swAv1KuhQahEbumRBAbLySYBrx38BZOa7Ra1QHQ4/pXlwFgqzhIgCVI3mFgEb+KF9YL1/vADAphyAZQPxGngyluUpf3xGkfgKn/zMh+EY+rmrL+HMmwyXVJHwznYDVRXT8/yqRjCDLwx3B/RpLo4Qb34ITF6vPKO/RjOqCuL/XKcSOTbaxHLd4IBYNaRjt91W7VOrjQgLVXGmOM6tE2/SKL4cLQWhTd0sNPU9kvrlG4ETJqzKdsdRA81tYsn2ibOEQRtRTxB70mB18NgDoEwUK7W656yIGfx3ZW4z3Mbwiws4lM1KUjDTmfb0ujIqgOjdqbre5dIwhQ/PXPnLwOlcziIXyO4VFyEm3+oAsRrtWyf0d7Y91gFGr90y0MnwQeYkupU/zYobxubbFUBdx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:17PM +0100, Lorenzo Stoakes wrote:
> The file-backed mapping interval tree functions vma_interval_tree_*()
> accept a raw rb_root_cached pointer to determine the tree in which they are
> operating.
> 
> However, in each case, this is always associated with an address_space data
> type.
> 
> So simply pass a pointer to that instead to simplify the code, and more
> clearly differentiate between these operations and those concerning
> anonymous mappings.
> 
> While we're here, make the generated interval tree functions static as they
> do not need to be used externally (any previously existing external users
> have now been removed).
> 
> We also rename VMA parameters from 'node' to 'vma' as calling this a node
> is simply confusing, update the input index types to pgoff_t since they
> reference page offsets and rename the parameters to pgoff_start and
> pgoff_last.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

1) This is fantastic
2) I need to rebase my local work :)

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

