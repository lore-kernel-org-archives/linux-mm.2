Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA81CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCA38E0015; Thu,  6 Nov 2025 06:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8946D8E0002; Thu,  6 Nov 2025 06:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782D78E0015; Thu,  6 Nov 2025 06:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65AE98E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:12:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 236B914067B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:12:15 +0000 (UTC)
X-FDA: 84079918230.08.0446779
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id BCECA180004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:12:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GgSHYy8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tmwQdEI3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a+7J0YEo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DQpCF2KO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427533; a=rsa-sha256;
	cv=none;
	b=cAuib6NLM1C+9lMXSjHhi8ic7OjyUu5mBng7h/aVsVpNyLTubwIlyxHdsctGOwdzi7f1/t
	QOPiwNgSgkvKuNk3+kRmh4IDQEUU9b0l9H7B1efrsh2IMx/mTJQUJdQFYegD053bc9bYWr
	jBBjufsiMJon8hiZXTpu+zP6VZIW1wg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GgSHYy8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tmwQdEI3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a+7J0YEo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DQpCF2KO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf1GcIW4R42rh6x07bHB1E92bG+Oe+p3bJUAn89P8Mo=;
	b=8SlJlkqLvW3ZZ2fgHZws1NWBHZqoChWUJWnC9FAn7qQ7rlzU3mBUSvCXnpq7/qW2Fk54Nz
	ShLtaidzrZz+P1DXYKc/R2nxoJkwd+gjJXhjyN0BDO0ISKqkgJ7JGJp95NL4/WOxaXiVje
	KB+07uVq0hXypYFGtpBmVWx/FYv08b4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E63311F46E;
	Thu,  6 Nov 2025 11:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762427531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zf1GcIW4R42rh6x07bHB1E92bG+Oe+p3bJUAn89P8Mo=;
	b=GgSHYy8fCTZeB5Ig84HPSlxMQ6YnIBLfup+s+eizrAXpD6Ctj0D9+5PLZgq5aMVXgEUFIJ
	Vmua/paBJ9or8VBVJKn13RCy5yxIAlviSa8c2haoRQJJ2HJTIOTTObuaqwV9RFw1GoC7l1
	ZAezACFgpoi3lS/GRLrffEQUVc0AyNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762427531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zf1GcIW4R42rh6x07bHB1E92bG+Oe+p3bJUAn89P8Mo=;
	b=tmwQdEI3+PGo6Tvr6+g6K6DiLtjrUn86BpHjwhOeMNxuW/izXddxgXg/3hBLb1xuLeD+/R
	Dz1weXlzm9JJK2Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762427530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zf1GcIW4R42rh6x07bHB1E92bG+Oe+p3bJUAn89P8Mo=;
	b=a+7J0YEo5O/6jwnJaCuRXHtqK00xsP6g7Ep+SCdIlGu/Rw2gamKLMDaPRna+BRYeFmXzgx
	0E6XjhEH7hdNn9UU3d/Sdy7ebRxoGP5Yhgm6ZIhC/X4gC2WW3U80kGauKjTHMg2uVfHPQv
	xcJzmB+Z1CkT5obTiFaY20r1usYXMPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762427530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zf1GcIW4R42rh6x07bHB1E92bG+Oe+p3bJUAn89P8Mo=;
	b=DQpCF2KOF5LhwneUPnrs97iUc67JVE2y/W1bK6VIfWDw45R8CgELYw/6Cc6/+Tfzw9tHdb
	A4kz4hd9I5cZnpAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1CA9139A9;
	Thu,  6 Nov 2025 11:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QKfwLoqCDGl5fQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 11:12:10 +0000
Message-ID: <30a9baa7-5368-4ef7-9091-80d170cfb5c6@suse.cz>
Date: Thu, 6 Nov 2025 12:12:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Andrei Vagin <avagin@gmail.com>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCECA180004
X-Stat-Signature: 5bdj141arpdhydrxdur64bc81yt4ebcx
X-HE-Tag: 1762427532-398022
X-HE-Meta: U2FsdGVkX19CpHGitxqoX3nZmpsNwvtZ4Vl5zc+lfBkCArtYkpH1ZgiuhLXDuwRBplQ8fkJ5AMYT10LoCEH99oE/Q59cgx2Mm1tbTmtdFnUMNmlxTE8XAGlmS+YB6vCuHyH8LsFwhVkauX9dC1kIVG/7ss3iWJyyCTxsoAXl2ok64Z2g60+m286F//+S4SZQ+gWjJ7awTfuuR9ZNNlO0HOupUZzMNnuwzmbE+REyu8WN7Kxgv8tSS5Dn2rwMfwnbz2+7IbBWATxK6xTBxJNPVazJIHUiqNHqS8f+wamz/YmIhP9tTHrzpSDfPaJgtIBVm1bBiOBvOMyFd7aGfrxFoH8rhN/U8Bd2jR5CrAIN9tv7Sr9H5H/Mz2P+0VVYHHdAHa0UZ7erA8x9jMwLS9i4bwfovBlzcxIksHbMKCkU/qO8Ml3T+tVRQxrOjGb3BOahuOlZu4+QqdLTAKTTkDNHJb3qq9PM8dHl+nCBjJY/f3L382VyGIhpvZu75cl5i7w4ccFRS6divRHqmBdsC8Z9oOWR2s6lMrXTuTF9LMPPgMOPvnu+9nB+gsVW/i/KaBmYVU4pfk0cZgukTsshtERqbvfLwwZkiEYRxplysex5Xv6DhPYsNuwk+uxievgK+YRjNZByCb6gUUmlfwpT+tKh8r53al8lo/C8xMCwRRgasrgQrwQ+IfQqBrjq4AasRM+SylVZS4OKVq6G32pMMKyqB+qlwHyg5ftIyaGvgQNp8SDXZk6AkdwUky//WSp8T/9TFUJoE7EhrchCMMeC0FB+GA4qvmResmdUFZ+DaqDYADkfMM2issOIL97Uh1U4KB953rLpVq5tdaqD6Jv5D2CzysMs8t4iXwuEq1XqI4ASoLMAtBABnO1bGBk4Cy2i2nnhDJmVWRbxe01z2GZZZ5nzp+pOOehu3mwuLItXT5++kvlITstO+yIz3uGPLZNQaYyHzVXQxXJctw0jV9zxVar
 9gFbAimq
 uFhB0626WNi3LIJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 11:46, Lorenzo Stoakes wrote:
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
> 
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
> 
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
> 
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).
> 
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, which
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.
> 
> We also update the smaps logic and documentation to identify these VMAs.
> 
> Another major use of this functionality is that we can use it to identify
> that we ought to copy page tables on fork.
> 
> We do not actually implement usage of this flag in mm/madvise.c yet as we
> need to allow some VMA flags to be applied atomically under mmap/VMA read
> lock in order to avoid the need to acquire a write lock for this purpose.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


