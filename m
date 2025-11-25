Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6659CFD368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CEB96B0088; Tue, 25 Nov 2025 06:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27EC16B008A; Tue, 25 Nov 2025 06:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146EE6B008C; Tue, 25 Nov 2025 06:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F28166B0088
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:35:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7347140804
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:35:32 +0000 (UTC)
X-FDA: 84148924104.03.AEE0AF4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id AFA2D10000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:35:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LfO26gNv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/i8315q";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KZLlVqOD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7k2SPKNs;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764070531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p6QrTPqrcjFGMk+Yo9ek0ZjatJ2Isxpx46M53PclhY=;
	b=i6I488hwe5IrPcFpbQLJ5w5NsoIBuJCbvzo1nD58v0ZXucxVPveC/mfTmVaqwKR9r/x6H8
	KE+Q3JQ9ZqYYnZPj3t8amIIIjUm7m7h5aWo27GwQr5zJkmOHMYSUohX4Dd0WqeKvxoFaCB
	1BmEHWYwrA3VEygTtORp6yEYpO10RS4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LfO26gNv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/i8315q";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KZLlVqOD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7k2SPKNs;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764070531; a=rsa-sha256;
	cv=none;
	b=QOpk4qNyyzSkHNz3lOewhEhAsJDCCTBHIXmoCDMNJ9LkZIaRlXQH0kkf/ZG2gN7rYLnTzy
	9FZRhWxxsquU0vYzCRAbVdgt/zNnFJPfEDBluhEEgv0PXu86ZVkz7j9CoVtxpDtcaLbgYA
	JrmnB/DGat173fWGkB9w5khVKgMaRlY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD5D522809;
	Tue, 25 Nov 2025 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764070529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p6QrTPqrcjFGMk+Yo9ek0ZjatJ2Isxpx46M53PclhY=;
	b=LfO26gNvL6i3mOBxxltDOa7Mm8VYGeVURJ/3KZq8KDwKBrG2ZfN+rQH/RaI2Xq6LVHf7AB
	W+lultHVLM9DVlNhWfH57ujd9eGjL9RA1vK8QnAqLaWNi1eN1pCXLobZHm7wc9uRiRBzYf
	gHviVPB3Xl4NSeomC/8dAFiG13X59wg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764070529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p6QrTPqrcjFGMk+Yo9ek0ZjatJ2Isxpx46M53PclhY=;
	b=F/i8315q3n2XsXBKkr5MMX6YasmzsZ3i5KG+4+YC9UpV4zAoZar/3IFE8WIvIb791nmF6k
	JYqZc95yasQHUGDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764070528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p6QrTPqrcjFGMk+Yo9ek0ZjatJ2Isxpx46M53PclhY=;
	b=KZLlVqODwAsFVuNlLAzLgXP+M5fclnuwVfNHpzlK2jerDk0ZIINfp/sEZRsrFAYJ+if39h
	Uu3QS1WmbFQ8EYNLs+Vk9ZdEvujDOib/WdPuIoZNAf+zCjAmigdofRkFltvGqW25Rp/8mS
	lIm39GnDc7lDOQm7F/DtoqxKcdTRqbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764070528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+p6QrTPqrcjFGMk+Yo9ek0ZjatJ2Isxpx46M53PclhY=;
	b=7k2SPKNseROSvP+kBu7RQTgUWctv/U+y1dfvjtbO+X9wX4AcP8UFci2JYR7NWpAo0zviP0
	y3vgbbznHHpwxgDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D70063EA63;
	Tue, 25 Nov 2025 11:35:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yWcWMXyUJWldOwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Nov 2025 11:35:24 +0000
Date: Tue, 25 Nov 2025 11:35:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm: introduce VMA flags bitmap type
Message-ID: <brej2b4dxfyuxojzgu2ge7ybk65t234bjstfzfo63izf2woagm@dd5vwcr3d3dg>
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
 <bab179d7b153ac12f221b7d65caac2759282cfe9.1764064557.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bab179d7b153ac12f221b7d65caac2759282cfe9.1764064557.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFA2D10000B
X-Stat-Signature: u1bmxfn3q5sckuy14a738gmhpdu5r4dn
X-Rspam-User: 
X-HE-Tag: 1764070530-125201
X-HE-Meta: U2FsdGVkX19GHmmo2u1SPmAkdHJC2gaKFngCAj/26MVGeeW9L/FDlgG6RKTGx+a8lL6zmcOd/fhZCyLi/ZzsobITIT+AXcFzjD+2ZTCT0CLEUODkeSPNYsTfa84Goy7YFwrjTyGyAXfrLKFxiPrrp5tWotKmcKK6cU4IbeK9wWEPS1f+u/lJ3S072liWw9IKa0xSZyd/ssDTEkh/qTlgCsBTvNpF+/Wtp5bArXjwRqrNAJ2ZfwEa+4+eqdFWR6LXn4YKaaMgYOmdw+tjtCk8D3xkEw6g9WUTTNl1TX4Ezjgx454ItsasmVCwSlaSWu9JVBFwI1ph4q01PxH4TNNZV0Bw283ordnOfWDHOw47XHVLKcAhj3idocelvoAchFYDB27ULzx02qnWOVLn7gQPdUbWoTJn/jN4PjmfKxFUq596ouDm2IoNsIEyMAGtFPSrQjWDn85uL//X+bC5hw1rztq5p3zFJ/qOpgz49XABgOJmrpl8huRmyUM3FTBKb23d2Czx5zZLGpht7kKADxalrWQ9/C0+ysmNRJf6hAEvnvPlYzy0xpvRM1eKLjZTxv6G2ZZYKjEpWHwnmnKqzovf8tMj14pksguKahqFCvBTmrmsCS+8QJXV1Tg41rqPFYeYnmM9atuBxKcQW+kn9meKKYunf9pF9r4s9b2Vm3DovjEk1GhxWGKlRbdQk6HhVts+9uc4uJLxOe38NUyHIDMFD2ihXBqKZz+NgvjFiVuJF+43kKYDbDCk9PzEL+hj/9nw0KvyXMbdN3hZWM1wX216CWqBObVwAr/Ye5y/yONwJokn/RHIh/Z5N15GRrQTiKqGlCHeqhjO3aLk1BGUSs8T6iypUm2puvs0K6jSxWHFWnbiFWlwk0EYdG0AOl5W/oNRDUy+w2ki8C2lpQXVwfXLkPDMrHpbbjW5UpWjOiZoM7LwNZQnCkua7v7HoyPPTpOVPPHZ1bX9OOkln3PJpbh
 ykFXbw/X
 H3sQaFF0LBwvo47XikC8bIDSprSX323XtvOhUqtnnuv5K5zRZ7bLrHo+jFt9B23SyZ0f/YXQQgmWk4YwHkZgIQvJZwyiRFCRpxYx2pl5nKRN5qWlIr2WyEBgsPF5DYgcGJSO5zDfniAnCB6ZtwNxJIjF+RWzgySKSyc2wY4fyZ0c1imtmRc2d7oskow9NOAJcSeqynvrByB8GvTjyrioPD2LrMniBN8DolXmkMk3Z11mf7/BD6mDoARaIJCGG5R2HoMnP0L8WiQpgHQWY+krh0xN1hUnOAxRWfBnoTQrNB8h9kkFEtFqICttY+llItn6p/aZ3LuyM/600kwGzPg0xax8LaXlcCq/D5PKcTEDPJDcuyQQcBpCzY/9yfLbP/GOV36PYZh/A4rUIHmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:01:02AM +0000, Lorenzo Stoakes wrote:
> It is useful to transition to using a bitmap for VMA flags so we can avoid
> running out of flags, especially for 32-bit kernels which are constrained
> to 32 flags, necessitating some features to be limited to 64-bit kernels
> only.
> 
> By doing so, we remove any constraint on the number of VMA flags moving
> forwards no matter the platform and can decide in future to extend beyond
> 64 if required.
> 
> We start by declaring an opaque types, vma_flags_t (which resembles
> mm_struct flags of type mm_flags_t), setting it to precisely the same size
> as vm_flags_t, and place it in union with vm_flags in the VMA declaration.
> 
> We additionally update struct vm_area_desc equivalently placing the new
> opaque type in union with vm_flags.
> 
> This change therefore does not impact the size of struct vm_area_struct or
> struct vm_area_desc.
> 
> In order for the change to be iterative and to avoid impacting performance,
> we designate VM_xxx declared bitmap flag values as those which must exist
> in the first system word of the VMA flags bitmap.
> 
> We therefore declare vma_flags_clear_all(), vma_flags_overwrite_word(),
> vma_flags_overwrite_word(), vma_flags_overwrite_word_once(),
> vma_flags_set_word() and vma_flags_clear_word() in order to allow us to
> update the existing vm_flags_*() functions to utilise these helpers.
> 
> This is a stepping stone towards converting users to the VMA flags bitmap
> and behaves precisely as before.
> 
> By doing this, we can eliminate the existing private vma->__vm_flags field
> in the vma->vm_flags union and replace it with the newly introduced opaque
> type vma_flags, which we call flags so we refer to the new bitmap field as
> vma->flags.
> 
> We update vma_flag_[test, set]_atomic() to account for the change also.
> 
> We adapt vm_flags_reset_once() to only clear those bits above the first
> system word providing write-once semantics to the first system word (which
> it is presumed the caller requires - and in all current use cases this is
> so).
> 
> As we currently only specify that the VMA flags bitmap size is equal to
> BITS_PER_LONG number of bits, this is a noop, but is defensive in
> preparation for a future change that increases this.
> 
> We additionally update the VMA userland test declarations to implement the
> same changes there.
> 
> Finally, we update the rust code to reference vma->vm_flags on update
> rather than vma->__vm_flags which has been removed. This is safe for now,
> albeit it is implicitly performing a const cast.
> 
> Once we introduce flag helpers we can improve this more.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

FWIW, I'm not a huge fan of this vma_flags vs vm_flags and hope we can
get rid of this ASAP. But it's a necessary evil for now, anyway.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

