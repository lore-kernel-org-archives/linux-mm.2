Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37BCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F396B00B9; Tue, 30 Jun 2026 12:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF7E6B00C0; Tue, 30 Jun 2026 12:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615806B00C1; Tue, 30 Jun 2026 12:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30EFB6B00B9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:12:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A24BE120589
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:11:56 +0000 (UTC)
X-FDA: 84937070232.16.12889FC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58B50A0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:11:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJEZDtyz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P+CEYhK7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJEZDtyz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P+CEYhK7;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835914;
	b=Z4fe9ILjy4B9JYax0HWNoEZSVeehOjsnS+KcaTQ7SPMaH0XlAPamfKkFUOoi5h9Vy3WTXg
	VTjs0coYcU8SHYJctcN8ZkaFHSlFqD2GRefz7GpEeZRyVW8zGeISNXiYv1tmvQIKLXMgDV
	Kq3xZAz5uF4RcynZd8S07Wn0y+B/Mhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY5THPpUuMSWi33cp4QWQJ7vrkyhd4o1Sg5j5DYwZDk=;
	b=dxm0Quc0o+p7MqyUrU70MPII+nYWiRqQ2HskOTUVPTUl7PIX7H1nblPcCfPLBJo/DvWv6f
	2b6vxCF9eeVr/n+fa5KFQKv9kdEX0m1Qkoctw9L+yaHwqwif7UqpqNbIS5YmOer/8dfzqa
	dwoha4NE0E3TZVzgYq13l+63ns/k4KY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJEZDtyz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P+CEYhK7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJEZDtyz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P+CEYhK7;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B10575E44;
	Tue, 30 Jun 2026 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SY5THPpUuMSWi33cp4QWQJ7vrkyhd4o1Sg5j5DYwZDk=;
	b=oJEZDtyzkYQkrGhwnxtGHnhOo7bYxdA63QTPwsyrnm2UE7Nio/E1aTyLgCLXErhnWpp8Rx
	49g0c9VzvexG5exp+lAUzk7TUXJQ/jz1fRShUVKtzbsgifT5/ALPxZa6cVO60DX/IPm4aC
	byBKPweYI61NYpfgX78jqKkE1emVXx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SY5THPpUuMSWi33cp4QWQJ7vrkyhd4o1Sg5j5DYwZDk=;
	b=P+CEYhK7lXDMGc7eHblLRCTsoajxG0CXQcjaWlDFgN4q8j7Gn4WmnVTevaOpJBs5PHImQL
	0qLG6lFj4DIFjtDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SY5THPpUuMSWi33cp4QWQJ7vrkyhd4o1Sg5j5DYwZDk=;
	b=oJEZDtyzkYQkrGhwnxtGHnhOo7bYxdA63QTPwsyrnm2UE7Nio/E1aTyLgCLXErhnWpp8Rx
	49g0c9VzvexG5exp+lAUzk7TUXJQ/jz1fRShUVKtzbsgifT5/ALPxZa6cVO60DX/IPm4aC
	byBKPweYI61NYpfgX78jqKkE1emVXx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SY5THPpUuMSWi33cp4QWQJ7vrkyhd4o1Sg5j5DYwZDk=;
	b=P+CEYhK7lXDMGc7eHblLRCTsoajxG0CXQcjaWlDFgN4q8j7Gn4WmnVTevaOpJBs5PHImQL
	0qLG6lFj4DIFjtDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E9B7779A8;
	Tue, 30 Jun 2026 16:11:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a3EWCMTqQ2qpZgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:11:48 +0000
Date: Tue, 30 Jun 2026 17:11:46 +0100
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
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <akPqry2BSCU858M7@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58B50A0007
X-Stat-Signature: jeumhk1c78ykmw6k8kxi543z9jaconis
X-HE-Tag: 1782835914-848198
X-HE-Meta: U2FsdGVkX19vBCsb3QbbECVsid0DSvUWrZfC46SDZMbqaEC2bleygchhxV49toI/LnVJnqw09rIoVz6jCWcs15UxrXixeHVl2Gv41TOgFtadIPT//PI0EWRR70R8y+omuqb6RLbDYqYBZiYuDMo30j5XnGqFuzwR5E0JFBM07LzbZo+Iq1Hu3oiqx6eMqhUVl7/mIZ4ad+UJ3e71qvv4ZOSOOZW/bPzrQIVmdhex26hbjlXF1oyPSGUkY105uWLCIM5ylc1Gbhdcmn9RGlPrZMcPEByqPWNPa5dZt8oihYcpswUul5f5TAM+drc8lurBOCxFXlDVNsTp+e4tUBUmaVJzHERJJN19uW9Xh78SGwTS7p9uWlYkAwLtm4T7Wwi4gB3U3PrbOvzgxcuhbXrVDO6PpPsuqrDqhZ2VaD3KnlEkdmmMlU3StGfa6pH621ETNa2oaiA67tO9Air4yBvjCfpT3h7B9srKOXDJi/xMeNxX5iQf4USnbMo/nbqU/zlllN3IWk53b4ToMx8ULmDSWSc4fstZxIKR+wP7eTzk8+viVbCbIWjJE5DG8gkm9+055+u3GoyzQvayzdiyTySqNPlKyz8cOQZyHAnYisuPTUziejfy8+qJfnTFQSAVbCVENssmFYqjZmPfN12T1THCM5a8RvONbMcdBPVc4hHa2l0wV9Mh7nQYc8L5At57H50JmSvuGMJtGt9ehHVpbkJdzXuHLtZeYAFU54Kh3w378wJUzZ8q7xWpf/6X7vItvf8jFbu93NpoDrRmXqUBf9QjAf/iaTmfbBs6e3/M+NI5+qdzBOCJgyT8hm/RwZSF4L4cpv4HbfTiEgGkXfkUbKuFjieAkKCc6ia6i6W3XQlq+rjdZmrDbL0LJNCWLCSiWw3DzLjn0BJ9o0+cn7/aP92kNqrpzebO4i/XmMGOPQouwPRSuRk66dDBRoFSXp3QVisiIY9nYKbqYYpQfeci+fB
 nJZRqMyr
 7rCP+cwqHqYdGC1HB0RhIE0eMVMJ8QHTyYEoIp3DD5Xd+0hS2z8LBK6A3IzCjPn+Vurhz610LWGIhq4RLbqPSL0Xf2Y3qvBDs6Y99aId51P69IVmjQhGELqBJBs9hD4gz+snnAnSgUZVEUQfmvtIBWN0sQDYFasFejiQGQ3sKwx9OqUi71q5mt3sz2+d1Ks789KAknAQ0r1Ebq+3X7UGZ5yiF4RAqCADbBJAN/8QRIAxpe71TETN2a6a7cG+iXKHvHnTv6pCazjfGQ6/IDeKJ5txwwkew3rT4Z01Vuf08qbocttzB/TkHmflw1CGmALNHd3V8ectN6/7wS/FqfX8wrEy74o2jzLeBy97lCDEHCrdpZ1nJRMouxvFljXxfMPx4hzjNhp0c4eSaZsQ/UQSdBHlvsGi5Ng0D3zJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:13PM +0100, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

