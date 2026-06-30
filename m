Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCB0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC7E6B00CC; Tue, 30 Jun 2026 12:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CD46B00CE; Tue, 30 Jun 2026 12:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8D66B00D4; Tue, 30 Jun 2026 12:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94466B00CC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:35:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 591D58F3CA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:35:11 +0000 (UTC)
X-FDA: 84937128822.03.0A71BFB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F3168000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:35:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DDehMC0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5nuM8j4g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DDehMC0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5nuM8j4g;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837309;
	b=wXU4txQgrcF23orzq2X27TUa/ES2faC2rfnEZ7D4zb3ZS7uHueJFelKkvCtEnXuLypqXDd
	xq2K1D7c+AgmZdzvd0B/f7vNFT7PcpvcZxY6F783WKK54huB3pO81Mncnmm6LwapO2/4D7
	7I5PZh2YjMxQXWZWrKsgwrK1fZhqhNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL7z05Z2Yz25EK5Nk+C2zAQnWxd+0KF9x6pG+as9VEc=;
	b=WTdTopHlHZ6h30POmsrzCu5nn2M5qiVPlf2RMNTIClUaEmlly00pcLSi2ySyy+ZgBDs3Kx
	5udgvBDAnGE0QToImMgsUvyJ8oD/Ngh2QQ/3YjgsbO53XjUgb+MDJYgEHuE6y149ZsLcqD
	ceLT91LJRP2hieix3FNjqPaMzV3qA64=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DDehMC0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5nuM8j4g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DDehMC0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5nuM8j4g;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B531736C5;
	Tue, 30 Jun 2026 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vL7z05Z2Yz25EK5Nk+C2zAQnWxd+0KF9x6pG+as9VEc=;
	b=DDehMC0yFbKo8KmShmLbqXXCwtYXcRKOPXxAJVSlKEBs4Td0N3G5Z5W6bY3uZLpH84ERD/
	S0mfc82DUBmZdopdshc3KCA6FwWcHVTjvLeQWe229oIuQ5akdpEcCReOMMSbWbBFHYHdmr
	4AsfIhtWjE0Wvm+/AQXwJAnAz3AnjLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vL7z05Z2Yz25EK5Nk+C2zAQnWxd+0KF9x6pG+as9VEc=;
	b=5nuM8j4g9z+4mG1ka4DMjT/WLRKrQIvs/FsA1pcl9NznsCo9eOelHyxK4lbKxBfZnVsyzD
	aqMQFd4+Di63MjBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vL7z05Z2Yz25EK5Nk+C2zAQnWxd+0KF9x6pG+as9VEc=;
	b=DDehMC0yFbKo8KmShmLbqXXCwtYXcRKOPXxAJVSlKEBs4Td0N3G5Z5W6bY3uZLpH84ERD/
	S0mfc82DUBmZdopdshc3KCA6FwWcHVTjvLeQWe229oIuQ5akdpEcCReOMMSbWbBFHYHdmr
	4AsfIhtWjE0Wvm+/AQXwJAnAz3AnjLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vL7z05Z2Yz25EK5Nk+C2zAQnWxd+0KF9x6pG+as9VEc=;
	b=5nuM8j4g9z+4mG1ka4DMjT/WLRKrQIvs/FsA1pcl9NznsCo9eOelHyxK4lbKxBfZnVsyzD
	aqMQFd4+Di63MjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D297779A8;
	Tue, 30 Jun 2026 16:35:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dXYkBzfwQ2rFfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:35:03 +0000
Date: Tue, 30 Jun 2026 17:35:01 +0100
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
Subject: Re: [PATCH 11/30] mm/vma: introduce and use vmg_pages(), vmg_[start,
 end]_pgoff()
Message-ID: <akPwGnOXgrx77hxj@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
X-Stat-Signature: 8yupagp5c6yngmo4jh9awo5f85cy4upk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F3168000D
X-HE-Tag: 1782837309-958419
X-HE-Meta: U2FsdGVkX1/uRpbbVJuPcD87CBHSOfP9rLXiRUmN67Vww02YmOkJHBExH5UAU6wptfs8E0GfH5y6kWJqlOpwIO0Ta6JhENz4DJMPdz3bXZ5lA8rEF8DEDDWbMJRLLGV/NFjvhCzN4UIdHeZnAWx32xE67jNZN2e9wEBcPLwBoPyoR3/DuLamojw1gpuihQIslDsv351BiKvSque8VjTQjsgfVolWiRx0PsDVYEnmQVgbiZguMrQ5JiZXbq/405tddjhw0KYbpxtOXrSlBPH0GbxkmRCNozuWfiLaN5oL8EaMNf2fylN4xNE1rFEbrTo8dJqCDCYFI17sETJOv586H6Eoa421YdmY9PAdfU22iXxHs1p1QrNUMY+ZhbJ6RxdrxdyR3Ji2vqEo99KhyKwLX0Hm7M32wIjza4PiD7ZxY/Pz4fIf4gUBFr8QuT+DeBafU2TvHdG0UXAUFeB9DCAwpD8xTsKZRDB8Z1b5YjqpeyuIC/jPgWSsTFTLJ0/VQIvv2neR/SB9TCOPdDb8+mbrFHQNqYsQbDk/216y4S23cFW2cWPOe/pkUyf1y2+qbDHovAKC3iUdPqwDQ6d9hz8Y6I4bhpm9JJzeGrWOEaXV1OJYggFqQh4BI6fnZLX29elCpQ9kv8Gz2/yVwHFxqSnPzm0VTg+8td8gxLkerLhEqwgb+6zkDAd0z8KFvkg8yhMbBZ3RyvD4YLevU48G6rlGlezNNxprVlxlqYTDco2r9x9G8RfEZ+o+Tzj9ehBkwPUCRmkMSqlUw8UqnQKfcx63RvsRMe97DA+nqoI4xP3j9NBjlySF9Yat4FCRms7IM2ENdp5rosCd+pUTJgnGLMsf4mKI0ojj6cJQjL6EQkvliCAzIzGA9sDoU3LU21Wru4ISy9vvUpR2mXXhso7oI1fTjLMkuw4s9WRHkcBtdzUm4UMsJ7Ym3crW1GKhQKpAuCJYr2hd1WdRLnuUrcCL7XP
 kjloOyww
 BiEAIomVi2b7JEuakejMyMXRLiZlnZ5YS7E8vccUKTedv8U2YwVa4wv+sMEvRkP4zyeUedbeirwFq9WeR4s22iMQvYJEnq9vasR/jzHc2UlpXBeCMJhf/wCZF4d8WvQbsaWA2JF322ckJBVkUbZDETr4mvfBD8piE+KgNtM40N3legxr+5mc3RwkyghUK7mkm12/BQ7XKg4IH0SSq4UtHl6jVo9eNU7v9BsqOM7z2pAbQv+/FBIqWNnmFvCpwDfjvVa5nbahCyt1xKoTjjyH45YDzHr11hxOSla1/kLzlfmGugbB1s5LM6QEC1ygfox9YXEvs9W6F4Kd0jDFNqwSm7bs6aF4qMCoUE5Gfu5cIu9L1L/l/LEl6BnREV9LSJmRN1K3EgpqS/2PYaZsxr9cY/VWSJ+SPs8RApqmr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:22PM +0100, Lorenzo Stoakes wrote:
> In the VMA logic we often need to determine the number of pages in the
> specified merge range, as well as the start and end page offsets of that
> range.
> 
> Introduce and use helpers for these purposes.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

