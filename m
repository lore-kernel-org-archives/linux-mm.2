Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19684C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C016B0024; Thu, 28 Aug 2025 09:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBA76B002F; Thu, 28 Aug 2025 09:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAB76B0032; Thu, 28 Aug 2025 09:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 163BD6B0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:23:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B812C837B5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:23:49 +0000 (UTC)
X-FDA: 83826233778.11.5451E79
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 304DD1A0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:23:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hBEXn8KX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kEcZSECW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hBEXn8KX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kEcZSECW;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756387427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzA3RrGXg+BwZI8mI1kN1SfcK7fhlP/WEoccBcHeAV8=;
	b=q2yeZHXvThQ3T8nrLfQZE0G4/iWU+08HiSXL8PVhDpPFTurmidriVvzc4sciiR6vJ5p6gr
	mSXJ4U0ziPjHI71b3py54L5l4sXK0WhuQC+igoRoBTO0+kRi57phlQT0WmT2pVsmgUhm7t
	D+8bE3wzgcduGVaEPQzCn8Ct4TI+yBs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hBEXn8KX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kEcZSECW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hBEXn8KX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kEcZSECW;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756387427; a=rsa-sha256;
	cv=none;
	b=Qz+GCanTWnnugXvmsBttug1y4KRS7h/m0qkSIg5KMYOIAPYm6ve50x2zdu+JzPgitF9HrW
	UNx0/8F8FRL7pTbWuEdkiMuECMUEixhBjPu5mybmvpVPc3aDQXuHRmZt6Agv5VqWgKyFwd
	g4hKwgY2cWL3kuWrmpn9kRCTjq/1nok=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55C2D22C04;
	Thu, 28 Aug 2025 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756387425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzA3RrGXg+BwZI8mI1kN1SfcK7fhlP/WEoccBcHeAV8=;
	b=hBEXn8KXVONCs1W4kHSavJsGwVqDTAYcmib39rJfykta9UwUXDOCFliQo0VDvVqRaBPRqc
	B1eSxl3tw9kC2UFkvJUm9BQJKs2kbEzdLFB8fd8y7Knrcvt3+gKepgm973NGMKKRyUPS65
	3GisMlhklCtnAiGlAV1pQsjs4qxPQzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756387425;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzA3RrGXg+BwZI8mI1kN1SfcK7fhlP/WEoccBcHeAV8=;
	b=kEcZSECWlNzxQbGuEwkkEL7KIh1sdx6BP1HH+5SaQGioLPcOsF5a7HVPIJ3YOG8NScBk7b
	NC55gFBzdzom+ODQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756387425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzA3RrGXg+BwZI8mI1kN1SfcK7fhlP/WEoccBcHeAV8=;
	b=hBEXn8KXVONCs1W4kHSavJsGwVqDTAYcmib39rJfykta9UwUXDOCFliQo0VDvVqRaBPRqc
	B1eSxl3tw9kC2UFkvJUm9BQJKs2kbEzdLFB8fd8y7Knrcvt3+gKepgm973NGMKKRyUPS65
	3GisMlhklCtnAiGlAV1pQsjs4qxPQzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756387425;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzA3RrGXg+BwZI8mI1kN1SfcK7fhlP/WEoccBcHeAV8=;
	b=kEcZSECWlNzxQbGuEwkkEL7KIh1sdx6BP1HH+5SaQGioLPcOsF5a7HVPIJ3YOG8NScBk7b
	NC55gFBzdzom+ODQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E9A113326;
	Thu, 28 Aug 2025 13:23:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dN/9DmFYsGjODAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 13:23:45 +0000
Message-ID: <c1f290b7-b4e0-4ec5-b60c-b1e6d3e0f21d@suse.cz>
Date: Thu, 28 Aug 2025 15:23:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] pagevec.h: add `const` to pointer parameters of getter
 functions
Content-Language: en-US
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250828130311.772993-1-max.kellermann@ionos.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250828130311.772993-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 304DD1A0010
X-Stat-Signature: obqwf55x5357y4zrq3jyqk3aefd6der6
X-Rspam-User: 
X-HE-Tag: 1756387426-796321
X-HE-Meta: U2FsdGVkX19Rrsl4S+HDhZQ+eXkgBfpuASg2L1DCr6Gokym8Pz+7TU0g2JxzYPNAzvqfJn3lP34MdsgTPIK1Aq5PWAGBmooG5DEOEaFsZbm9KgMvZoUhJwQz/6wLruWR7B+jcWDNvtVX1RYS49Z6XTVWxQyZfWpE7uC5wyAlsDuinWXDZifgof9W/1l6RasARUTv7q8QxN3AgE7z6+wcw2PLEMcsN3iid+wx7vXhEgdD12KGO6VZjxACny6TPglRnyJPLPCkZiGjlA/EXg9X4JGDUS37gRZ/smZxs8u6g9JhwLujnjX5mFUi1z/L34sMgOgxMW1RVDTRPvXwt9sklSzieZcrFAO+Axi7/gvUOY6sw9alw3I9WzHcF06XMa+Jc0GLfQ1Mi4qCWg2LH52Bta9LRVbc90OSeorNRA2OPxwma3mZNnDSXclmNNf5lYmKpaNaIjMGnNa5IvzQ/8ywq6DcVuyHtAt9yHt210jNPsxFCQXPLHZb+NPg3a+Jf+XQCKmAlxTCqm7CPEcWoxs0n0RSdLOMYwDw85IecuEDTVtvE0gKZSv0kDY6mxn4W/sAijoIuQVNzB0ROcmAI6hVUQzMPl3IkVBaIaQ7oIzcumdoTrMjkvvzRRth5oshBgOOe6iHJkKWx8s0CssDfRNvumPi8T+70+EJK7oiJyWVwSfDCSnE3yDSYHVd22koahcQjh4cQiVRWac4zRn3BCoHhWwYui8RA/SBUrKpe0DMgrDpcM95f5JhsE1a6DZUZah10wTbdsnNOZYweUYw9HEJWYQ59S2Wr+syT4/SaAm3uA4+CFJ6YtvrYYcRvZlQIKDqzZJwTo2ESjuaCyJnwMtJCNeMhdUT/UwdcXcFvQAjcQotNcSCUjFnWw4JgtImmk9ZE2tXx41KJD4M2pWEvyGpVMKQXIYWfW5CGUy3e4z/O/kQHReqZ3mYTa244myzR4f3NKsGugyqmJtHF/6BhWb
 UW4trwxB
 WaJED2NIyLA7UF/54u8i4MHkgOZlQrwYc2efY2OlFt6mUqgI8F29goNxofsLkv/1R2bVRCtO6WVbqY0PDxwpp0QB/V8G1qiZWoJudGgmz3jNzU6uPLm5RJhkQHvTm0GeK0P/Rn54rw3Y5coYWpsWWySh0MHhaFVVLIgnD1PiZDYCxHIr/1vj6L6B4JxoVGtSHIVvTLL3evCj12RaRX2aZwlMattWmZU7Pfi2j9AO+Wx9Le992jrUyVQDQvyXIf30S3oP75Jo+pAdF5Za7cnE6urFzMr5tMbfYyNCDjdMOc/6m5cYtHxeWP2CMTg0A1uvkJ53MNrUwWfrpOBQ0JN96kGtOp6sftjxEca5ZdjhY/R+caTmfozJaNF7XqDCp+upk9TD5CjWz6LCHaV2lfa8PC7KqoK85AC/1kHKxGvheKqBofgeZxssdZSbz08bbk4IRCKKIyyvhRMOK1kVBQBKwnpiQ7fTovSNLffkJ3zqAfDP5uscJVsLHcAqWNnwt3tR1bwUmMwfrzdURMIol24plb+22Z9RzUAU+kGqmiqTALnabHwifYTI+Nb6MQh3GgI35w5sPHJmw6uZtmNnEZnkcWW+PWL+yPn+CsQit4wmb0IF8JUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 15:03, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Note that your Cc list is still not according to MAINTAINERS:

./scripts/get_maintainer.pl -f include/linux/pagevec.h 
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE)
David Hildenbrand <david@redhat.com> (maintainer:MEMORY MANAGEMENT - CORE)
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
"Liam R. Howlett" <Liam.Howlett@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
Vlastimil Babka <vbabka@suse.cz> (reviewer:MEMORY MANAGEMENT - CORE)
Mike Rapoport <rppt@kernel.org> (reviewer:MEMORY MANAGEMENT - CORE)
Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - CORE)
Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - CORE)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
linux-kernel@vger.kernel.org (open list)

> ---
> v1->v2: reduced patch to just pagevec.h upon David Hildenbrand's suggestion

Assuming you don't intend to stop here, a series with multiple patches logically
gradually expanding the const scope would be better than sending a single patch?

Thanks,
Vlastimil

> ---
>  include/linux/pagevec.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
> index 5d3a0cccc6bf..63be5a451627 100644
> --- a/include/linux/pagevec.h
> +++ b/include/linux/pagevec.h
> @@ -51,12 +51,12 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
>  	fbatch->i = 0;
>  }
>  
> -static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
> +static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>  {
>  	return fbatch->nr;
>  }
>  
> -static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
> +static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
>  {
>  	return PAGEVEC_SIZE - fbatch->nr;
>  }


