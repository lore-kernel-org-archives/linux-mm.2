Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B073606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QUL6W3jH;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QUL6W3jH
Received: by kanga.kvack.org (Postfix)
	id AB03F6B05B7; Fri, 27 Nov 2026 17:15:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87416B05BA; Fri, 27 Nov 2026 17:15:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D4B6B05BB; Fri, 27 Nov 2026 17:15:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78BFF6B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:15:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B86A160516
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:15:28 +0000 (UTC)
X-FDA: 85482306336.05.F025A33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 117142000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:15:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QUL6W3jH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QUL6W3jH;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817726;
	b=s6A/LWXoiM2ssv8jl5QM6WGCAirDdj2vcaL22gxfUdW59Y5iEnTV7xmotLz/8Xt/8ms8d4
	duVYkVODqTNaStdagvgB/BfU985J3IUt0FE98O30dqj2VDVXMlH8eO/ffGgDFXZfn1VdFK
	iCEimwJMcumxH5p/vSF10MyLozqd6jI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RN/B4N8caDlaycAleYE1eEx7HfJ61p5JGE1Xsxo0c2U=;
	b=J3dTAfv7rZfXmMc3EfxTPXK5qrrNRZXxo3x4uacBcluxh2BVFODv0MicxRRnXc4Yi0YxMg
	TaPcT8KZFQ7Dp0E5iApDnZ7rer4wDqwom1b0jmQ92+CgAoeaIIKur76UDKADRI6F7wG3Xq
	O+5WcKrgxKuQLCL1fyG8cmGXiUA+YtM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QUL6W3jH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hKxBmuPW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QUL6W3jH;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0DAA1FE50;
	Fri, 27 Nov 2026 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RN/B4N8caDlaycAleYE1eEx7HfJ61p5JGE1Xsxo0c2U=;
	b=hKxBmuPWjwk1OXmTM4Wm7OwsAF/UcSrNjkeBGyq1seGNljMTKooCco5tV5TIPYOWpcbjLl
	cfVVfzPUtPqsaachD+iuwsYhhfSzqyg///KN2OqugZFfqLytUUUYcgGhlieeEwWl8U/d1F
	TACRCts70EMexEobu4a1zyxXhwZGwKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817724;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RN/B4N8caDlaycAleYE1eEx7HfJ61p5JGE1Xsxo0c2U=;
	b=QUL6W3jHVbLqIEXq1Knc5v0gTslFRVOOZvrbjoASjm7e93tMKDSLr8K7D5Va0hOkP8zFGc
	kO3DoEkJyqKtDKBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RN/B4N8caDlaycAleYE1eEx7HfJ61p5JGE1Xsxo0c2U=;
	b=hKxBmuPWjwk1OXmTM4Wm7OwsAF/UcSrNjkeBGyq1seGNljMTKooCco5tV5TIPYOWpcbjLl
	cfVVfzPUtPqsaachD+iuwsYhhfSzqyg///KN2OqugZFfqLytUUUYcgGhlieeEwWl8U/d1F
	TACRCts70EMexEobu4a1zyxXhwZGwKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817724;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RN/B4N8caDlaycAleYE1eEx7HfJ61p5JGE1Xsxo0c2U=;
	b=QUL6W3jHVbLqIEXq1Knc5v0gTslFRVOOZvrbjoASjm7e93tMKDSLr8K7D5Va0hOkP8zFGc
	kO3DoEkJyqKtDKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C558D134E8;
	Fri, 27 Nov 2026 22:15:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jT/OJPoACmtnKgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 22:15:22 +0000
Date: Fri, 27 Nov 2026 22:15:21 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Andrew Morton <akpm@linux-foundation.org>, David Rheinsberg <david@readahead.eu>, 
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Alex Shi <alexs@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, Andrei Vagin <avagin@gmail.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 3/4] mm/mprotect: fix unpaired notifier start at address 0
Message-ID: <awoA3jdrhuogntQD@pedro-suse.tail5790ac.ts.net>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-3-e46b2b1eb435@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-3-e46b2b1eb435@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspam-User:
X-Rspamd-Queue-Id: 117142000D
X-Stat-Signature: 4deoeiby5jekgaafy4kc7csi9zf44usn
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795817725-832535
X-HE-Meta: U2FsdGVkX195dJqgsTiIZLp7XW5OV4howOrEDmJtEL3kxxQ86UsZnDK1cKylukeJEVdkQhQsuQE5TrAlyUP5zJuDWFPCGYoIZcxspDGO+MdAvWvZPG5oUUTCTXehaaZp3iH4SU5PfzYZGl0xSHDR4I1tZu2FRqjF0B9GLu+DlkmRDEjZ1e3eSS3OjraFgwxLsOz7z75X0YGSBKbsTnQvXotm/8dJvPSazxTBqXYJhQ+dKf8lX9/bO6jL7ca2AXDTmO5e8qTpEqClTqs+tHdJ1RZP5bnaDPqbyzbdrZOgU1oAjnExCLUzzqKA35JLooHiqJ0gQZYcTlo2DbhzsT0dW9vmt+rwGlRLgXeXPXe7SSj1yui76HLUyL8AO/GoOf0SdEO6K71qIK3aM0/2nMRCTqcs4vyZ22DyFmBARQq4dvyDTCJcEtp8EI1o1NW8uI80HZU3fz3g7IB1opvkUFqZtYJ5LZGXRF+C35OV1NJObWlWLfmY/Mi/O/809W2/1mGYRjcUR3wF5Z5atKNi781ZyYjZFB7MQ9ozL+eluCy/66979B3e2r4jFsbMO075IaOSLr6EvyMRmfGS+Tzqh4ltjmafFfWEwG76S9bbCEXix25kOHqrLInfFtILBX1qLr4Utpj+Wu7/AgZM/iCLkXWrLbiYB809R8eo7QBHfgtSXs53A7jWvqgBJUoGqrn2zu3F5U4NZavtu7ttjCftsj9AIELUjz9nh7t2W1BRfiG3RH3bwyU8OZLINK01n7r4ht7glgKeIJrnDcDjx0pc+R8DEtIWADM/wi4r/e2KfxgDThW1QZYSyhXZOWHqkDyUvPfscccyVg6YPD1VwXzstOLPAVunOdQ5tqOYwW41vFXKWiXKaa4YFXKm/oaRuEMKXWw8rcpuUoq3m+PLdrNqPTwrhbgEXwDvdpcXmKYBMf+t0FhKBNAbeeXLxPObb560VzmUu2iehltqkKg+/srMqPr
 SYfGWnrF
 IAiCjm1F/tft+YFZOH4PdkSx+sczznidvSQ10PgAaGwlIL0jeB6X633kjSxROBTmjlYXkIENvIfjS9h2JoU8yRIYtKl4Bj5Vj6r5uOFYKp6SjnrgS2liFlR5jatEqC/K2RgM94SUHtVrWXf7KJ/6gN6mkja3o4UdZVR71U8Pl2w9E8zVSUN1jYMAhFfLZ/Cv87RnUcBmbtv3dW8lxN4l8JINmHSSbJvuLfrmQZQ61RtTDuK6t6kzxrroR9iTpn+9sHVNI2gZoBxkUaEMUwBVpDxybZI/DpgME8f4IZXXUy2efBu7ZsTkIl7V4MiUR2kfeFL+wInLwdrPuVvo7jsHEn6jX8eyUArMjIv9vvlVdViZhdsiEX9c0DU19+rl1Eb9/Ha9EXDNDVueYurbMeMD9RoPy8aPvFvonA/9fjXqGz+a4Mf+5dEdhdMU8IoZ9iE6PuloWhaF6gUpSIACGBL1AH3eGD5FnkQR5g35n+7ywhP7RYU6uSWtO5RDip2b7a/bwQ4lVPovY2g+kELo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 07:45:42PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A protection change on a VMA that starts at address 0 can leave an MMU
> notifier invalidation open forever.
> 
> Waiters for its end, such as kvm_swap_active_memslots() and
> mmu_interval_read_begin(), then sleep uninterruptibly and never wake up.
> 
> Fix by using a boolean value to track this instead of the start address of
> the range.
> 
> Fixes: a5338093bfb4 ("mm: move mmu notifier call from change_protection to change_pmd_range")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: commit msg tweak ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

