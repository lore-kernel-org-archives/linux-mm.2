Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CD7CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976FC6B0093; Thu, 14 May 2026 04:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E926B0095; Thu, 14 May 2026 04:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8658C6B0096; Thu, 14 May 2026 04:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77DA26B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:15:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ED9D1C0EEC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:15:53 +0000 (UTC)
X-FDA: 84765316986.26.9D19198
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id F33DCA000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:15:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Yn7op8mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="33hUj/VH";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Yn7op8mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="33hUj/VH";
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYHvhQh+aU5YKMg1lnuWAy6/GMx5Fj4JhjQmk8/RJkk=;
	b=y3lZ8tIVeetPBNalc705xEqqmeiKgvQv/gWQLQg1fVJB/XdFq9KpZBgkQvHP4J1/Nfirza
	4p4trE7IsNCQ+xDs339ohkypmnRQm56avhZNdiPzn5h7dfJ9NXzlyL2mrry6ggQkwtpJ/K
	qRKPzS6GbeFWMBkdOPkT7ZflOdPQj6k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Yn7op8mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="33hUj/VH";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Yn7op8mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="33hUj/VH";
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746551; a=rsa-sha256;
	cv=none;
	b=B4DUo3APYT+F/lybgaWexDwletRRP1HMcMhyLc/q3fFUZzzLk2ne+JEqOdeuGqB0gEioa0
	IWAXUh09Uk1U3FVdrniNQZAi+hN7l6/uHSQq+kf2K4BjofVzwOASuWsYQyn3KfZLFTfFFt
	iF1pH5zzVdieDldPnTTiAwhqrO9W/Jo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8DD535E0E9;
	Thu, 14 May 2026 08:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778746549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYHvhQh+aU5YKMg1lnuWAy6/GMx5Fj4JhjQmk8/RJkk=;
	b=Yn7op8mE2TAPVKVIpe9TijF6q8yc2mzF0AWBa8NOZ9bVRX7EtTlVdWm0s2eYsQUChIXqYV
	xzv3stRGxlkbwAYEIfM1n4YnEGu8gr6z3JBuxQsOekiRw6iNOqmDUttRnfg3fXEMeYx2Tg
	Cn0wdfZR//P1bZ4TxBjtiQ1PZzz6iN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778746549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYHvhQh+aU5YKMg1lnuWAy6/GMx5Fj4JhjQmk8/RJkk=;
	b=33hUj/VHkqcsJmfiuh7Ram0jOGYgvYjUOcsSaqakySsXvlWo9WD6kZCVsUEE5FS2z+AJrG
	1aw6x8T4G5/L9qAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778746549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYHvhQh+aU5YKMg1lnuWAy6/GMx5Fj4JhjQmk8/RJkk=;
	b=Yn7op8mE2TAPVKVIpe9TijF6q8yc2mzF0AWBa8NOZ9bVRX7EtTlVdWm0s2eYsQUChIXqYV
	xzv3stRGxlkbwAYEIfM1n4YnEGu8gr6z3JBuxQsOekiRw6iNOqmDUttRnfg3fXEMeYx2Tg
	Cn0wdfZR//P1bZ4TxBjtiQ1PZzz6iN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778746549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYHvhQh+aU5YKMg1lnuWAy6/GMx5Fj4JhjQmk8/RJkk=;
	b=33hUj/VHkqcsJmfiuh7Ram0jOGYgvYjUOcsSaqakySsXvlWo9WD6kZCVsUEE5FS2z+AJrG
	1aw6x8T4G5/L9qAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8338D593A9;
	Thu, 14 May 2026 08:15:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +oCGHbSEBWoGHgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 14 May 2026 08:15:48 +0000
Date: Thu, 14 May 2026 10:15:47 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/69] mm/sparse: Panic on memmap and usemap
 allocation failure
Message-ID: <agWEs93xurZIRQRK@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-7-songmuchun@bytedance.com>
X-Stat-Signature: qp5caw3aczko5y6ajm8qihxartd7z5hp
X-Rspamd-Queue-Id: F33DCA000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778746550-220697
X-HE-Meta: U2FsdGVkX1/D+YjwQdmibjrWytyIP3B5gi9HYe2ZsomHp+NdjENBaTbtbFJYm4w5rr4DdiG2XrrdcDL//TxPpkE5XXPeGXIGWvWvYtzVyLmvg+SwbZ5kCPgCkTu6xkTyTay/3MN/Uo9dQf2iOvwtAzAQBAw7k3RgpIZjcAMeWaPzE1/r6gnNMuGfZwetjWLKQSfNNRcWlx6N3VMHzRA7ssAj31rvXa9xLG7SbravXUtJqqne8zBYf+zqSO/KPj2O9xx7oRt+99zDoTxzeTRuM1LfsvUP9hTgDKyY5hQpKuj36dxEuB/4XKT3nux+mZCUMXtpOo1uotZnHahAys8AOLp9zYKMGWi7JsgjZbIHOjeneJxDwp1O7e5DkoqIwvTzmqamOQ+vkkRqbEhb+cGmGi4xgoX8/kc0YiPkuIVEVgciJVs8NIN+rrgwDOYBo+Y+tdcgZq3+88Nbr1CdS2NSfZpirZ4Iyp+ZU0ulEkwGOfYe9EbB0ou2M9QScpm/BtsrFqQxxPzThoFCqXP0GhGDaVMylFWdCOjwK2xjdb3wsCxtvQjmSdapwLcx1ulaxbzvKdxTSUfcXH7lTvwFHxeW0GFCXFkNhyxHKARUbTD9EbcB11WoT8p3bBJANLhsEB+cnj55k7znsWCPPlZHl57u09BXHgP3BC5uKL3VFviliTSaQzFhEvBpiWw8fRecI6Omx0kbzUXTTIQBHdoGGJSOharrnPMjjOeyoQOI1ks6fXOzUJtba8WzehPIzjSKMozrFbmt6saaDH1fzEAYl3LE2hZV2IOQ7NYQH/e4Kg39cfoz/DAnhUh+HdlOcSOmNEIyU8+GFVBACne957EPNUXddpl5Ed5qCN/YDF9PnYulh8RSfBhdLaZ920b5o0e8mKLGRHSTUIlt2fZjDk+lEDQtpW2WotnSjd/GSq7hhNTZKj9zsMGzAIFHqBeagX/p43ufjbtqXokNn3JhZUXxcJl
 y05DNVJt
 HxKabd8x6n2UO/jZEGZeE7rHmemnDBML9tY2UIHONcnNuCu3H3w7IenMKsPuswuLFXaVSgwz3BGTUg8qyfn/e7D7OQ3HznlA0lCOvT7qs9EAO0QR/AWTnEnc/y2IFRe4iI4Jxyax2TFXjz/DQBC1GblDsdsnYyi81VFFxeYDvH3leh3lkDKFaUPeI8nJ+Jv8K9myqSclOsEUstQIRlrcHS5vl+d0nfu60W3mSyy2WFOrwKk+JK58X0y/c2Ra/8imrm/iTVXoTEoyc9VGi/PAfGtoQwXpFvkz8V0CRL5pQV/kNIjd0/5zACp2UHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:34PM +0800, Muchun Song wrote:
> When vmemmap or usemap allocation fails, sparse_init_nid() currently
> marks the section non-present and continues. Later boot-time code can
> still walk PFNs in that section without checking for this partial setup,
> which leads to invalid accesses. subsection_map_init() can also touch an
> unallocated usemap.
> 
> Auditing and fixing all early PFN walkers for this case is not worth the
> complexity. These allocation failures are expected to be fatal anyway,
> and other memory models already treat them that way.
> 
> Make memmap and usemap allocation failures panic immediately instead of
> trying to recover and crashing later in less obvious ways. This is also
> consistent with how other memory model configurations handle memmap
> allocation failures.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Yes, one could argue that if we fail to allocate memory at that early
stage we are already screwed.

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

