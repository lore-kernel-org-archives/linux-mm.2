Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07392C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44B36B00A6; Tue, 30 Jun 2026 12:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5E36B00A8; Tue, 30 Jun 2026 12:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E67D6B00AC; Tue, 30 Jun 2026 12:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670386B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:11:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AE0A8F3F6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:11:05 +0000 (UTC)
X-FDA: 84937068090.20.E019407
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4649C10000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:11:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwF0sdvk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bgYhnYR3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwF0sdvk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bgYhnYR3;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835863;
	b=gifGsGQNHEKUNH1oKjQySmJcOzXGqFRo5TeRc6jeZ+9WK5L7LEA/0Hz//GNH817VI7uwXZ
	P3OO19tnMZ1O+hfd9GNyoinLnN1nf4L8pP+t3vX7z1w8trAlj97OpAbqs12KIPsnia2ZBW
	3M4nTVxhLWtzzq5H147c9+1/AbZxi1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enh86INh5aPyeQRC5FbGcxm3ol0yZA5m0JCiaGOsbqQ=;
	b=sPGS+LyKi7kIIQbFHzY3FburhRFBtPMvgnIK3Gi+rwJqe0oufiBO+wfzbAPMxuKdeRtpVv
	KNh3wRzh6g37/meZr10HiOaWM3H1GWGcUYxtm7JbTEnbT3IMD3o1PRFB5YcxXJ2Aqjg7pS
	TwIdfLMQf8wT89kB2fXqWfrIOsSDvjI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwF0sdvk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bgYhnYR3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IwF0sdvk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bgYhnYR3;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD78C71A78;
	Tue, 30 Jun 2026 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=enh86INh5aPyeQRC5FbGcxm3ol0yZA5m0JCiaGOsbqQ=;
	b=IwF0sdvkgDT0ywrxORuihJFKtyA1KHRCoDOKzKbvg9BIDJdqdODF5iWwzOmsBi+F+KjbaQ
	O6cLrLHNox+vjLvZvZ+dqbhG5JVZryHRMGWpS8jEGrlEBgOI+QVjnv8uq3GseiV1Q2mzmR
	dtPpTgbksxtcY6XH3YoglNaLWh3fHvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=enh86INh5aPyeQRC5FbGcxm3ol0yZA5m0JCiaGOsbqQ=;
	b=bgYhnYR3d6f1m6ge64B/dD6u41RcMeo/cCcwHeLVoY/3II2h+7UNg4nFxHHb7bL9zQTB8S
	A6ptz4JAATsUE9BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782835861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=enh86INh5aPyeQRC5FbGcxm3ol0yZA5m0JCiaGOsbqQ=;
	b=IwF0sdvkgDT0ywrxORuihJFKtyA1KHRCoDOKzKbvg9BIDJdqdODF5iWwzOmsBi+F+KjbaQ
	O6cLrLHNox+vjLvZvZ+dqbhG5JVZryHRMGWpS8jEGrlEBgOI+QVjnv8uq3GseiV1Q2mzmR
	dtPpTgbksxtcY6XH3YoglNaLWh3fHvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782835861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=enh86INh5aPyeQRC5FbGcxm3ol0yZA5m0JCiaGOsbqQ=;
	b=bgYhnYR3d6f1m6ge64B/dD6u41RcMeo/cCcwHeLVoY/3II2h+7UNg4nFxHHb7bL9zQTB8S
	A6ptz4JAATsUE9BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE1AA779A8;
	Tue, 30 Jun 2026 16:10:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VCclJ5DqQ2rmZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:10:56 +0000
Date: Tue, 30 Jun 2026 17:10:55 +0100
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
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Message-ID: <akPqIfmQLOs4gI7h@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4649C10000B
X-Stat-Signature: ox5xwa3915j6cp5k5tpfyuy4pt8x9utt
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782835863-199530
X-HE-Meta: U2FsdGVkX19Rx8rIiZK57mu2hvRlRGvc/0sXegabbZGjCrn2TQgNc5QYds7l3gQwKNbg9hehUVQ2v3Ch7aIvhggEsHHIrGk7XXtu6eTQAozF+KiJWaTj/Gl3GQYDddmrLPWZ53Tbv+o/l062n/pJqx8LvY4TvAhVUfAjRGB28+NslQdRnpbM1pYFew5vfHhLhS/p3q/yAuKzXGwbdxP3WPKtQcgZ4isLG6Qi2ZS++c7JZxAq5gGnoKfE35gpSleHwuVE7QnHI91rD7mPkS0EfNPZKtgs6rECwO4Ne1Y911zh+TJrdgripWt4d5evinKFegnnkeRcfcXFVM9NaIdXpRfzey5DYj7RYs7tKqGEgrimiSjOwkHgdsggwX08ifXW+QPdffzk2QGHA+Zz52lm7RLzGvOE/h97+vsmu3EzH3XC2DLgeW839nHUuAvhCQMSgnUAVrHVnaaZMdr0GSYMvgmSEEHLlD/EIKrFSSNAh7aZEm0xJDrEO9GwmdnyGzLg6GNqR4poY38gY7+UqR3kCpFC4vtrP60rBo0uk0mW6fvu4k1STohC/jCBNN/NVlYaO2xxqHaYMp07BXnqJV3XTBt8Gpmmu2MkxHxckf+3sz9Vx6FdypUQmNroB77DmLRR+x07VaQ5Q68v+8svkQDCSodW/QLrez67B39q3LqH6nW5mzBjFFf+pZ1QJQ5JUTcyuCb7IosLQHhar6ap/B0b7HJpWYnhMr9odSnnxYLy/JzZlt4d8OKV4EAMeT/DVklirGA7WXnhRW2Gt8uNS78pzGerx1Kn5ACWaTqZhevF/p7RTGiUEQPNUPitzLZtoCJmYG/o4T9rKkfm81K4lCXB/vkqQVpQEcDydFkXbMKPvl+XbxesOwrsc/JXB54Ox6CqFycP2/2q7b6SqEWft4rTs30QcfgT92ibYka/xnRPOCLhoWJeeg63xtFdbWdHN/wmWNP+Vgo/7UqQeOiqp6x
 Jhnkz3vC
 6XjCsTihX/oURO/BgguxcCiP0KPzWlQDHOX6wCT4GkxIo4k3SmHwyGms0/Lr30Bu+umCE1P+4vqcbOzLAAcA/UaLQh9prPtfecQkVFYKa7CL86A2MpyYSOlTOVgcE40/mkEJKpnuUhChfJs2rWZ+W6KhcTItE1og8KTzN2JJB8tDlkS9TYFvryCwbWZit1wfgirNZzuEL48fF/N7K1lqSUapHts1biTP/pUW9O/Cpsy3wBaJjefEc4Tf9v4BZMMTqiDpgtWSwvweXno3SKQL6wUyLrEX5d4WUi98lL5cbI885W+iW9ZTpBfqc9edyYmqUs7pizaj6N9pv+to2AeDqGFYC+ytyx3t7ZSkIYpPhfQyxbQ12AlWl2AlPFAgt5w+6APwPPRhsl4kSKPXRSs/yX5XSBXJ6b/Jr9c/ltKi9gZuJC+WZi0yGTUAeyfR3f13t6cVx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:12PM +0100, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.

Hmm, a part of me wonders if this is the part where we should start cleaning
up mm.h into vma.h or something. Probably not, it would be extra churn right
now.

> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  include/linux/mm.h | 9 +++++++--
>  mm/interval_tree.c | 5 -----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..059144435729 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4278,9 +4278,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> -static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
> -	return vma->vm_pgoff + vma_pages(vma) - 1;
> +	return vma->vm_pgoff;
> +}
> +
> +static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
>  }
>  
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 32bcfbfcf15f..344d1f5946c7 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -10,11 +10,6 @@
>  #include <linux/rmap.h>
>  #include <linux/interval_tree_generic.h>
>  
> -static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
> -{
> -	return v->vm_pgoff;
> -}
> -
>  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
>  		     unsigned long, shared.rb_subtree_last,
>  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> -- 
> 2.54.0
> 

-- 
Pedro

