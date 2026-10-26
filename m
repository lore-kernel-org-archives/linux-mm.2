Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22182606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=evaYlFvL;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=evaYlFvL
Received: by kanga.kvack.org (Postfix)
	id 49A156B05B8; Mon, 26 Oct 2026 09:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449C26B05BA; Mon, 26 Oct 2026 09:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360B46B05BB; Mon, 26 Oct 2026 09:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2D36B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:28:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FD60160799
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:28:51 +0000 (UTC)
X-FDA: 85364857662.16.6A1AA7A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 809A02000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:28:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evaYlFvL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evaYlFvL;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oty3F1v8cHRij6MsFcAkM4dOfnw3za3E009u5RN2KoY=;
	b=RtBAxK/7NZvvTvl2y49a7z6G8BZY05sPwBhWJdqEzlk1HbukcW68g8JXlLqmdSYCEZyZkV
	ovLlzcgV1jrBRiRLbyEo7tsXnf3O/YkidDl5e+SpDDxqIUeksxIW1HNs2iUDJMmDMDtiJL
	kWXyQvPAzB+kfV85nAfqaQVn4+Y4oqk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evaYlFvL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IrNCpGg3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=evaYlFvL;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021329;
	b=CsuekGdo6d1Ncr8WPuZUZg6s3oOLoUc8zmOSAtYeBDzsyMynyURpOP45UK2clWyugg8tci
	8fuXueIGetocv2SoHoVVFKW5cxvoyC+Wp1Q8p8T75EKLwxF413bi2Fyjm9y28Mc+yzIqxB
	3H5/kEGTqoRcit3mn49mkUU/j94rw0c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 144D91F43B;
	Mon, 26 Oct 2026 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oty3F1v8cHRij6MsFcAkM4dOfnw3za3E009u5RN2KoY=;
	b=IrNCpGg3PmRU3tVVIsdu920TKWXWQhTySyyL3oNlqSBN/yPWpGeH+rCVlsGISw++vDmtKK
	KfDZkTFyGrDjqMcGOxfaU+DhRgk0cju6QATu6wElZ1cJap3WN/4F5MqjDnIndqQ/lF4AWp
	Nkn7vrFk1EPUDNhaYZnjU2MyN8yfeOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oty3F1v8cHRij6MsFcAkM4dOfnw3za3E009u5RN2KoY=;
	b=evaYlFvL3iFuuisfPphGwmzMbdy5aGQP9Hy+/2QZ42qhcYVNFO8uW+cgQaAGynniU1GyFh
	x2VCs6PXZhvIESDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oty3F1v8cHRij6MsFcAkM4dOfnw3za3E009u5RN2KoY=;
	b=IrNCpGg3PmRU3tVVIsdu920TKWXWQhTySyyL3oNlqSBN/yPWpGeH+rCVlsGISw++vDmtKK
	KfDZkTFyGrDjqMcGOxfaU+DhRgk0cju6QATu6wElZ1cJap3WN/4F5MqjDnIndqQ/lF4AWp
	Nkn7vrFk1EPUDNhaYZnjU2MyN8yfeOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oty3F1v8cHRij6MsFcAkM4dOfnw3za3E009u5RN2KoY=;
	b=evaYlFvL3iFuuisfPphGwmzMbdy5aGQP9Hy+/2QZ42qhcYVNFO8uW+cgQaAGynniU1GyFh
	x2VCs6PXZhvIESDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3850A13408;
	Mon, 26 Oct 2026 13:28:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KpbhAI9V32q2dgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:28:47 +0000
Date: Mon, 26 Oct 2026 13:28:45 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Luiz Capitulino <luizcap@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Message-ID: <at9VEGvlpDwiV1tx@pedro-suse.tail5790ac.ts.net>
References: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Queue-Id: 809A02000A
X-Stat-Signature: wbdkurus9xqjmprajtuu68s431n6jrbd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021329-844154
X-HE-Meta: U2FsdGVkX1+vjO9plUM4ud8VbqECf67ucAyowbK0Wvkp1DXPAZZxq5WlVe2QeBgfisZsccuGZjc7PsjfExQj5GRHhROyvTvvmxoKBOlXXFOD1yslLuGtMD78/YPmG2v1G5v4amTZ8W+Zmi1xLvkCA3pAbiHXlDxsh16BXYIdYCzSrk4L77Km7o4Rb3cEgPbzkeD0MgBcld/6CynouylOhGkwGVQRgVPgHAWQA+Wj7rNuRJeIdmetPJWQWq8RVm8IsTsjcpY2rNlZEG2E/cpMez8tPJ2lU78oNxD/7maGeYnpt2Jmb4nJwWOWEmH3ZA2MmdQbFNU+alvPV3CeHN9Mwk9h6BccxcwGHyqyOytP5ZeK3SHhZAwu4WExB9SKSIzR61Og+HSXYuksGw2GHuzl+oG0BeYCEEAHd04wBySXkvxBYPhcmwv71LwMWrHTAsu0qMnl7Wxa9rTk+9bX3NjU8J7igGOwisCHGs7csgaR6ZwAKo6oC120I6ggZpLWkh0vv7JcqWDI08E3U8WiYQZrd60H8wfZuWbf7YlaqRLNsBC5RQaG0UbT66C+pqSGgBy6kevuZlfgfQFGCasEu3IaJHEbO9zYTXk+AASTU6cq2bfbiz9Jylj5M3g9V7S8ogp3Nss7asy5LHNT0ViJ3eIAxGqvDDSm7rBrW/M+AZn3XVnYs0l0dcpLtKepFU2u6/4ukIwcZUAPQ/m7ldqUpjZqwUE1ubnyLWkQsX0no+EZvfWDbnt/gp2GX5hm05VXKKF2oO1Ubczu4beS7h2eHyjsXaG7aGvSO5w+penzhoOiGgWNorEJzWHmi5lUH85ZzurRSyMLnsBF88BHzgAE4EDFCIwLiqL5D/BB9g/ANA1xcZtjtfq/M/0qTMhf8MqDvhz/XKzPzU71FYo4fe2v2uaUAd6SbFQVH2Ba1GxiIeZe2uktxo+l9ySATtgKOiHiBd5ql3kBYDKLl+mtifUC8Nw
 bo4oDd7n
 sY0hj8hUNW6o0fP9GXKG1M1T4/J1vpGqxHlgkQzl5AIrxPl1wqQK5V8Po9okl0/QR9a7E8HFoYPqNGR2GkOC9Hy7wHgDNnFdzAQv5eFlwSj3E/HU+J5+Oj8VZ7PqRo4pseXcSr473o79plilmrN5jxyl0M5D3+DinfqYwz0bvQIHJVK0/NpYJuM4YW9Lhw12Ttvck34Dl+Z8wGxGacmHYA7+xgtjRzvy7xnDtc5z6MjtQ58Ju6kFi6xD+bOFuxcv0RTkRYjnjQrERjRXx+C9ovQzCB2l40k9mhTvAGiU2+dE7jVLfBc8Q5ogTTYfIRJ8/Qh8lW91XnBR+rguOebE1r3LdkNuRbTK5wxFAtwFz5RqVeFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 04:17:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
> merging with expansion of mremap()'d VMAs, however it also unintentionally
> disallowed the expansion of unmergeable VMAs.
> 
> Previously it was possible to expand a mixed mapping which mremap() had
> already ensured was a legal expansion.
> 
> This is clearly seen in the mremap() logic, as it checks
> vma_is_fixed_mapping() to determine legality of an expansion rather than
> vma_can_merge().
> 
> Additionally, copy_vma() allows for a failed merge to result in a new VMA
> being instantiated if MREMAP_MAYMOVE is specified.
> 
> However, this is not attempted, as a failure in vma_merge_extend() is
> assumed to be an -ENOMEM failure.
> 
> Since vma_merge_extend() is used exclusively by mremap() to perform a merge
> and/or expansion, resolve the issue by invoking vma_expand() for
> unmergeable VMAs there.
> 
> Explicitly assert that the VMA is both non-fixed and a mixed mapping.
> This provides double insurance against broken changes in future.
> 
> Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
> redundant in this case, as a mixed mapping is not subject to khugepaged.
> 
> Also update the VMA userland tests to add a required predicate.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

As much as I think this is smelly and filesystems really shouldn't be
using MIXEDMAP:

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

