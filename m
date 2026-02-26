Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC6AFCE064
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEFD6B0098; Thu, 26 Feb 2026 07:31:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896CD6B0099; Thu, 26 Feb 2026 07:31:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7983B6B009D; Thu, 26 Feb 2026 07:31:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622D06B0098
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:31:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0635213C0AC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:31:49 +0000 (UTC)
X-FDA: 84486544338.11.AC32C33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id A7FDB1C0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:31:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vSIQtv1E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5N5MjjgV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vSIQtv1E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5N5MjjgV;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772109107; a=rsa-sha256;
	cv=none;
	b=ijOlmvk/x35ucwHEZnj390ebA+MkbTzEItfaAJTqbjWjNbYCjYYPb0DNu2hFjoBxs1PyJ6
	kxjXORHrIzSPkoTzEadnddW0NW3MRrztYC+QIAVB9xEu1fDpH6uiPU/WXjZNW/N//D4Sqn
	9bTfW8YmcRt2pKMKWbzr5uZFWIw9mzI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vSIQtv1E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5N5MjjgV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vSIQtv1E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5N5MjjgV;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772109107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=piYT3kqwgWJt1TkDFNiYEcMWLVyAyVVnqvA2cZUEJi4QLlr4jHHkGce30vHoIKOxGGfWrX
	S1DIjaJYrDG0RTHqNSHR31Dnj7izLZIRvnqiCavr8//AkyuSnrCeQtGyM+fs9ZBZaJV3vK
	Hx64DGcVNaBCx2EVFylPBMilu6jB+cE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76C801FA8E;
	Thu, 26 Feb 2026 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=vSIQtv1E7WnqPn0ENIfIOEmaSpvOt9Q0fMqP2kUhYl09j9A20zwA4LTFWE8UHxDzOkQuxs
	5B2qs3tj1TPz7CPUGMBtl06RQNtZ92ZkC6lFLSfnUuiYnk4ZSzLIOa3jWTasYwcfhJW6/b
	w4lg49Z+os+DhYIqbt6kXcOHCIGau80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=5N5MjjgVLaDn8W3omolC50q8cwfMNo9NPN0KBHCWuKhhRO4JrhUZVuXf1uFNS1Jr0BgPqz
	c5zrlc4TlDcKfIAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772109104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=vSIQtv1E7WnqPn0ENIfIOEmaSpvOt9Q0fMqP2kUhYl09j9A20zwA4LTFWE8UHxDzOkQuxs
	5B2qs3tj1TPz7CPUGMBtl06RQNtZ92ZkC6lFLSfnUuiYnk4ZSzLIOa3jWTasYwcfhJW6/b
	w4lg49Z+os+DhYIqbt6kXcOHCIGau80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772109104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f5WEnpROlC9fgWu+KGiqZFKe3oMMY1tyFav7WdEwLBc=;
	b=5N5MjjgVLaDn8W3omolC50q8cwfMNo9NPN0KBHCWuKhhRO4JrhUZVuXf1uFNS1Jr0BgPqz
	c5zrlc4TlDcKfIAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6912F3EA62;
	Thu, 26 Feb 2026 12:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /mugGTA9oGlzHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 12:31:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B3A0A0A27; Thu, 26 Feb 2026 13:31:40 +0100 (CET)
Date: Thu, 26 Feb 2026 13:31:40 +0100
From: Jan Kara <jack@suse.cz>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/6] fs: Add .unaccount_folio callback
Message-ID: <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com>
X-Rspamd-Queue-Id: A7FDB1C0011
X-Stat-Signature: w646azx9yiszka8dsthgphpo5obwuntf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772109106-118059
X-HE-Meta: U2FsdGVkX18bq96XBCJ8UWbdF0Dlf0RfVpyjP99r2G+iUGuXiAlzkhOc4bB0Ok4myTVIugrxP67D/Ba4TTdp6Uosib1Ws3sUhiGrrFfqq4Mfsg6PmJj4kIX3M6Ed06iaox1KqdGb2AjPOjy/mF4sI8RKOHPTuIbRIZ7m10N+B4ohz4iAfx+8SmIwQyopXDx8dS1yrmNXGKX/8h67a5uk1x+ZNiyftNZfwHIzn3QuX+T05Koi/nT6MOcTSn83zjmH0jL6fquaanU4zPbsrhuyDZtEiHSJKb5R9MtkOWH51LPe06HJ0lk2F684bDt7F11Mppg64Kt9u9ApFowuQ5uKF3X0TpOQAMePurYfp/l8SMHlNt82wsD5omJQcnD+kQS16CrEBqgGzucczOjWGwZCRJaajao8fJ3ZsRyh3ztPJ9y905Vgnw4Puo4TI8nGQJvDgDC/ovnI5deSfxmvw5Yf+r7h5nPWrdz5q9940pu+WTNWmmBTu4wDZRrimIB+pZGCcLAfU1ziF79pmG12Pm61GR6UZkDEUHPMmC60YqbaxLqPUXtPeXREkhUSAYdxkvur5BmLUBuKiNabeOGXsRCB2iAM6X0p2M86NPClam5SZxoLdHTFb/Bj20UN/7I3jwZ95WNdojoURWukJe5O64iwYCQdlvt21knHolKhE5pS7p+n2LJrqMJVE9T+W0cenaeg/AkojK/o73iJYF98ZUfqTKAvVgNsGDwfqm6Eutjh84OlpsbXCExAmO1YIy2mwGg0cfIZH7XVgrrEJneuQxlQ8KitnQ2s1zy7UZBNjLvMUzbjbEAL1IedwXYRac3toNbtB1ecmIhaEARs2MxWum6Y4HRUbx8EqIbrUWuarSlew3ggYS6FZ9oI57QaYbRinZSVuZhcenXGY0ShcDvNJ3Oghznslce+/pnaMnVAWwKJeQFx1CKN/JJGyRwkxus5HRK3Z53v7AJdS+zqT+5QxZJ
 XyCcDuaN
 77N2BKPH8UcDnDgmnDeLYbZose3up6AT3nAUD6AOm25aG4Xj+gUtsQFBlJZykhGSVBcRflOlcNYOnBHod5lcHVCrUBTmVhn8a6zAqVfytEsB+lwQAfR2DGpqemKtICmMklVvEyrMGbPXAsJD6fYiaflGFmjlCgFK1RdqrqSTyZr3FnSltPy4AlpFZxmbNQfwyQ/V8pBstqgf/clbm1vM0bhcTmqmPlnIX21Gi1Na0EMWh1l/2Hzr8ywi2z0VAu+ApXJfLAutHi2wU7OPditGsmUw13HH2O0JlJCjv05wBbciEsCBpEAdeQKH8iu8PivwD62P+dqEMftlRZGdB21QX98D77+ggEjnSxyZLcdfx0HGfvGwYm8rbfPkyzYTMVj8po3F1hAyye8HjbAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-02-26 07:20:38, Ackerley Tng wrote:
> Add .unaccount_folio callback to allow filesystems to do accounting-related
> updates to the inode or struct address_space mapping, when the folio is
> about to be removed from the filemap/page_cache.
> 
> .free_folio cannot be used since .free_folio cannot assume that struct
> address_space mapping still exists.

I agree .free_folio isn't the right place.

> From the name, .invalidate_folio and .release_folio seem suitable, but
> those are meant only to handle freeing of a folio's private
> data. .release_folio is also not called in the truncation path.
 
But this I don't quite understand. .invalidate_folio is called when
the file is truncated (or when the whole inode is being evicted from
memory). Filesystem can do whatever it wishes there, not just free folio
private data. Are you pointing at folio_needs_release() check? But you can
mark your mappings with mapping_release_always() - it's there exactly for
such usecases... Am I missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

