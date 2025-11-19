Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E825CCF3959
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564FC6B00A3; Wed, 19 Nov 2025 11:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C2C6B00A6; Wed, 19 Nov 2025 11:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452556B00D1; Wed, 19 Nov 2025 11:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337AC6B00A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:36:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5F7E14058A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:36:27 +0000 (UTC)
X-FDA: 84127909614.01.F6B84CD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96D7F12000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:36:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QoyUzQy0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qKhmmQci;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vc917aBD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EhVk9XM6;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaJrljRuHzsSahjPRFPX05pBvERQqP62JHa1SezYFP4=;
	b=NoUnqc6RIYOjja3T5p1TpAiCQ771u+clfUMUkputW0k5Scs6QwrB21zk7fqvKFLiNFN3mC
	0WjnnhRrug0aiPkNwNv+q7tjdGYwfWUnV8D9m0AppJiM98MgrHLEWyeB8pVIYjGnIun7dp
	eVv2NncRFwvH5W3md4yclA2fSsNARLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763570186; a=rsa-sha256;
	cv=none;
	b=DQG7ca5E4qKMz3Hx/cOgDpx5wgs0fQftGbMVubS5dBkQPSUuOJnMkQK0rR+lKhFH0un4PS
	2gMRg2yZZu9fm1RBmMbyZU7LbU/yNf139kMzXxB9aNRWTQNBlnKQemhwiaRdXvg36RxPxt
	7knzKvd+ibuwDhS+KGidUSvc21iQkpM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QoyUzQy0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qKhmmQci;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vc917aBD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EhVk9XM6;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDBEC20595;
	Wed, 19 Nov 2025 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763570178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaJrljRuHzsSahjPRFPX05pBvERQqP62JHa1SezYFP4=;
	b=QoyUzQy0kfEnmwEH9C+WMNmv2fIw6SyxdCjQ48Vph6uLgnt2FyRgxRi+IrojladgxuGPqF
	lgOx9Sp0Tpe3VQugorn8fo9va7mWPEshkF5wl7IVuODe649vFAspPCCre792HbRoNJzDIp
	Zsj6cN0scu/Ujuuk/8iqe7SUORJ33/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763570178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaJrljRuHzsSahjPRFPX05pBvERQqP62JHa1SezYFP4=;
	b=qKhmmQci2mtPc1l8hRYQoJB2MunsPpcPUwoTjghLy0f/8UeUoZhRpC1t2aDUlTvlNwmWKY
	fYhvv+/I+Q/GNeDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763570173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaJrljRuHzsSahjPRFPX05pBvERQqP62JHa1SezYFP4=;
	b=Vc917aBDIOVnaGybQq9G9o6Sw5JDPY9DXNjg0SB3wCL9/7z05/g3dtOdqldVWKeio8A1fU
	wT1TjOnfdFdWRvoysS8piGh9prn0ffObfab8alRHuZuoxYbw9OSLk+320MTkYfLmaGZQRy
	BHalF4F3Bja+m/sVwTPFNLNMHeB6gLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763570173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaJrljRuHzsSahjPRFPX05pBvERQqP62JHa1SezYFP4=;
	b=EhVk9XM63H+CBv9exjU6w0Z1ugfyJBtkpRPI4mnv+0FmkorsOQ8RVVkrkiFOGJk/Vx4DlA
	9BIe0uuvHC5zHVBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DD143EA62;
	Wed, 19 Nov 2025 16:36:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kx8ECPzxHWl4cgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 19 Nov 2025 16:36:12 +0000
Date: Wed, 19 Nov 2025 16:36:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v4 3/9] mm: update vma_modify_flags() to handle residual
 flags, document
Message-ID: <vr45iyduvak3wpzmos5l4jfpzticerlnxuhnpvbzb7fpsvanqx@rsuogv5s6brh>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 96D7F12000E
X-Stat-Signature: d8byffhkbzcziezzrgq7ankkgfqbfa8x
X-HE-Tag: 1763570185-546285
X-HE-Meta: U2FsdGVkX1+QhRh0XXdjdQV6W959dCKo1OGaFt9JIFQkT0pffZSg+Sgza4gm8HPKT/2UM0wgZO66HLF68K/PXivsmr7cR+BVzcg2EAtKOiAsKIkRIoXj7XtVYxSUyFbj+jDGDPXBb9MjrLd3ApqlmcKnzE8r6vaqTEhY05mF83mNhn0z+fHTF3OJWOTtU9YU/S5wUNUGX3DtcfoIzeqSf6FWNmVCnbLqgBngOoUKr/w+7RPMLkKuB0CuwSSlStsSwsWn92wXzbr2mNNTp1U02bI+I/1cbWkYS1uA6P87gkN5nFrotX8/WtCkGyaksQ1t1b0CCpRt8ddLjVL/zbi512sjQd9GohTZf69X7TYWIgBErVO4XjBF0BSDnBPJBujat193IN55ci4Z6cMejKgVnjUak0RVVvrtz0EqG2R2/e9NaB0mXPjuHFZB6v6y1XvWmyqXq6C+W/+Y0vf04okQzk7k+LAw5N7S/Micr2apqlTy78hh+cxknuNsKLfwBdFS0LLnGSbAtnF2qUMxwD/No4BJsI3WBT+GXmCvgkI2KMiwmsmA5zcodgAO0snMLKarUdcGK8B6HWKamF8KPYo7k1FsXfu/bhvSo19eCf/+ChIEAsgLbzcmd0bROgjSX9Jl0iX+rLp45v3/jOwKQXSu9RLINgA/eRHUWybBexHQ+Q36tGkgWdBv6uUNN3JKjQ2ofhpaxChQkAIgq+oM4pJZ0nnIbaKekrrgLViiUnvpse9QA9ObtHFiJEp/86HpldD+IKU/gtEPhqkxCPtMANGUZyltqnBrJbhshJMzLFrHSndtWMQe13KFSz1aamq9Y+U+7WqUUKWO/YGSzDI8xNWodm+Bqu7qFx3XTPYmobjn7F7CaFv1VqmjW8ZrODL89UzYUHzsir2SRkxQ8c/SPyCFbdp8uBgAJLaQ0GCFFp7v9gnS5z2BJlaUZEoXHnwdyBflrc1js8daHf7MBJPPrSS
 RjE2962/
 oulqqCm9I5kXe+t8ruXla7Pc4rn4+N4dnwkZcFLytKudPdD8wZXL2gNqaWyw3qAKsWSvJ4wd/m9JC7ZkAog7zLvB3WL1l2jy89JFr5N6mMXgAPJzZuzD4rOQPMoKDhYCSbTDObofV/hBfIIVMuf9x+6kM1fMf8yzHo12ddVJn+lK4KgXzReyJOJ8aBpx53EGWxzFGl9E9kFJR4ZrdKtAMzhNqBdTnaM0kRO5PSBFT1f5QL9jFq97CUgO+4kU/WpIaBBEvCfjiiL1U+oLF0G4kijhLNjP6TgiA9pPgFaIxj59H05tb/wsASqxes9TShhwXy7aozmCt+aKoq8kXiFTN7jw7Je4mcsPNljkC9wf4WEiYRHMlw2+su/wGdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:17:45AM +0000, Lorenzo Stoakes wrote:
> The vma_modify_*() family of functions each either perform splits, a merge
> or no changes at all in preparation for the requested modification to
> occur.
> 
> When doing so for a VMA flags change, we currently don't account for any
> flags which may remain (for instance, VM_SOFTDIRTY) despite the requested
> change in the case that a merge succeeded.
> 
> This is made more important by subsequent patches which will introduce the
> concept of sticky VMA flags which rely on this behaviour.
> 
> This patch fixes this by passing the VMA flags parameter as a pointer and
> updating it accordingly on merge and updating callers to accommodate for
> this.
> 
> Additionally, while we are here, we add kdocs for each of the
> vma_modify_*() functions, as the fact that the requested modification is
> not performed is confusing so it is useful to make this abundantly
> clear.
> 
> We also update the VMA userland tests to account for this change.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Quite ugly change, but for the sake of brevity I think we can live it
Temporarily(tm).

-- 
Pedro

