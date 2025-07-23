Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD3EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683DF6B007B; Wed, 23 Jul 2025 05:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634466B0095; Wed, 23 Jul 2025 05:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC1B6B0096; Wed, 23 Jul 2025 05:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 356056B007B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:42:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D86821DA097
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:42:13 +0000 (UTC)
X-FDA: 83695038546.18.F717740
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 789BF20009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:42:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4bEBCj7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZrVh1UIE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nigw4flJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Km+OrjSE;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753263731; a=rsa-sha256;
	cv=none;
	b=AQxFhFPhk02+ivd7ODnkTdf6zBM2cuSFQXibWtjepPZrm1p+XXPbQQgrYkldbUtdci3nr9
	kitsFAwvHxGew+zMG3qt2il6EBbizLccRjbw50dGKgr0ucNKNcDtBkjJsf3RW6jUcEbkCQ
	3L317fZhOSGFiRBWySFERjfwiWLhwko=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4bEBCj7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZrVh1UIE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nigw4flJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Km+OrjSE;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753263731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6e0oYfSmhk1vpAzcB9KYh3w+HHjNFd4D8pmNPbAL1oM=;
	b=rL/jxLtNwak0goxBENNo/5Rj/kl6Fi+ShcY/F1Rd1binD0CgLasn28mEL1MXg000BGFUhd
	VlIqoA0yREUm+AgelEh9EXB+9CPgx8kwCC7R6Gk5skMjLvBiW83MEdwGBFqtuJadpYZlOQ
	IN4FdGWPoz1ma6QSCOHroIXuC/TSoB0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA7E2218D5;
	Wed, 23 Jul 2025 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753263730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6e0oYfSmhk1vpAzcB9KYh3w+HHjNFd4D8pmNPbAL1oM=;
	b=q4bEBCj7AFQW8kjp2rssc7FgHugzBS+u7tKVDL4ySIqhj3lwtisU+pjXcIAi/qu73Ii/5t
	oezZF8yi+IR9QlIsAMKKcDZDGeAljeI6TNBp960ylpnSOFl303Xrbd9dpaRiX92eS1IhxR
	Vj1LjkmOQuBM5kAgV65HgkGmOpikDS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753263730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6e0oYfSmhk1vpAzcB9KYh3w+HHjNFd4D8pmNPbAL1oM=;
	b=ZrVh1UIE4tjMnrHPbxHDQJNaDB7GDxHnnQtjqebQWWJHP6z+8U39h3soz55gojlagyEBRu
	k+2D5sScgewOQ8BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753263729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6e0oYfSmhk1vpAzcB9KYh3w+HHjNFd4D8pmNPbAL1oM=;
	b=Nigw4flJ+LVggunln2cMQrvb69s+bP0lOmiu5vft09zxqW9w0YlXr9SDlqpI8GZmV0viaw
	xLlYsHD/DahjA3ndFsg+80iAl7+roRi5juZaqv1y9u2PZnwixiCWakClaWjVl8xRA8yTVW
	DuoAs2k4y2VonkiOjspz9XRxNSwv4tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753263729;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6e0oYfSmhk1vpAzcB9KYh3w+HHjNFd4D8pmNPbAL1oM=;
	b=Km+OrjSEay5QPgXIhTrPlZW9fVSTu+OsVHLhsZx3QnxDIq3UJuivZ3NB183qJVLdQTExxj
	RQLFclycMMwXpeBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A07D613ABE;
	Wed, 23 Jul 2025 09:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cF/BJnGugGgZWwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 09:42:09 +0000
Message-ID: <66daf9db-ce97-4345-886c-3f8ab111b4fc@suse.cz>
Date: Wed, 23 Jul 2025 11:42:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: rename MM to MM MISC, add missing files
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20250722192704.164758-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250722192704.164758-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b4w6ig9mwi39iicy3rg918nkdhb7rb1c
X-Rspam-User: 
X-Rspamd-Queue-Id: 789BF20009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753263731-947123
X-HE-Meta: U2FsdGVkX184pus+o5pj7gWqmXU6kPvNSjVTfk8Mfbo8YV5274qXLmQ1/FUxBJ9jeNjmfYwPdPfl6FRBzMcHzlwvjxcteWPEoLheAyWnOt8ySPH20cCw4KQrEmIjumt9MggmHoIUVese9Lrh0aUYxwVTOqEbcjdISSttV8Miw5OschmP4tmGTUoU178i+qMyNtarO9i0t1F6300Veckz9G6Z89jgDpoWzXOdB96O/16ZNrzmlIntqBvMcrIxauvLUcrqk/5Qh/rjQaG+CkeJ2Y8IaPuF1YjXLNIMDIJ1GYvfdp16ZiYdCNGqm5kjN+Y8qpDV8sspd+ylJjX8xFtkK4T0YJ1DWmB47QBD9AU8S+KSJL//6M6/MI8oimpBgOaJMFyIDXS2C6HssPlStw5/FYvAAXd+Yg733LjU5jB0ZLyDjM8EdjNHOl6RGmfiS4/9GFh5mqYrzHUwE9FnfH5cZDnr0z4fCiuisoNOPAe9xHGS1xzctgUaY5N7F6gVDmp7OAuZrBEAijgROYYNnDJjJ1vf+rFDbx6tOEVr7qd16eIH160OUfcvoWisHxnBtmytWDCJVoY41nX5KClAC89TepGFEyNfv0mOmAB2r0HWUDO/5L4N4Dhg5xtlDGy6Y7ASVguoU6M0Ea0Ag6m8QHYUrnox1VxdaOLGsZczb3A0nrbOZGz293oTpnznzn+5PsqNRZTH6m2G2bV34ZEGkXr3ZHcnj6NlPi7Z7jR9q+ElWvaPcwPYuY3/cTSg44LYNrVt7hvUIRtR0DreteXiU+/EgCqR1lZpFNqXUCwgvdvNQgFyngfXonZFXmiJZia4P8ZgQtH/qevcTxSczQDsyxCfZYpSwRrOExlx6LqIgFRZBQ4UFFz6ZIVSxPEn12MzTOeq4lmCFV9yHBX5M8BcY3ya6gSXJ1GjAi5C7u1UE52p1R1nQv8Gwq7xbq6QxMksCYCzkhXiTpdHzaUkCPoreJy
 5R1pTjJ0
 8SblQIMVqitKPP2Ch52ANv8DcXSsMZUHv4G5dP9LL8Jrunlc9WGG9HthqKa1pGlGCIW7WG9z8yRO88qYmCi+rqUAGasXAsamCLjWuD1zF6rVOfV5ad8HdkgnawY+GAjp2UW+kO5gz3qNPGT+lRECd1ZUS+SsFoI/opwgDfE9H9polSZZelU6g6bFt7Q5edcHLeYMt22Em54Oyng4920zanaYevFBo21o9fJGevZA+RRLA0G+P8HHqduBIskrJ1af+ps2aFa16cOD8WWr7lH3aBVvM7+ePCyxgkUq2CaiWL6wvOwjE5kiMq2YCTF9ZlQsck7kTHKwt4MofjISyk+xuYFNAIBlZoGnKfbcsaS6rs2JOsOCZdUgHyN5HL929M785d57LEmrMz6zY16jnVvTg/fm7Yk9kZX1Mmo8qwhvMezFF4bxt+0BVQ/gyENzFG/5IeALduO6a+06PUaGY6z56w8ReluOP7HNnBWa3lTs1yMADad6gRK9UZ93iAGTZ5N9QPhpAFOH0peaTCERfShPIuFMh6D2Ho0Gb+gr5xwq/SaghcZJcaBsnRKrWMV0g1Q3GgBt8iSIcWJ9Sh1k9MzNhc9UHiEe54/GXB5+9BeoWXPUpkEM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 21:27, Lorenzo Stoakes wrote:
> To fit in with other sections within MAINTAINERS for memory management
> files, rename the MEMORY MANAGEMENT section to MEMORY MANAGEMENT - MISC to
> contain files that are not described by other sections.
> 
> We also add missing files to MEMORY MANAGEMENT - MISC and MEMORY MANAGEMENT
> - CORE sections.
> 
> Move over appropriate files to the core section, and in both sections add
> remaining missing files. At this point, with the other recent MAINTAINERS
> changes, this should now mean that every memory management-related file has
> a section and assigned maintainers/reviewers.
> 
> For the time being, we maintain catch-all mm/ and tools/mm/ entries for MM

This...

> - MISC, though in future we may wish to remove these to make it obvious
> when files don't have assigned entries.
> 
> Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
> CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
> related for this to be sensible.

... together with this means the pre-existing reviewers of CORE will now get
CC'd on everything under mm/ - I'm not sure if this consequence was apparent
and wanted, so pointing that out. Myself, as long as whole mm/ is there, I'd
rather not be one of the R: purely for volume reasons. The misc files
themselves would have been fine.

> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> 
> Andrew - apologies, but there will likely be some small conflicts here
> given other MAINTAINERS patches move stuff from the MEMORY MANAGEMENT
> section too.
> 
> I kept patches separate in case one ends up having push-back we can still
> have the rest putting missing files in place.
> 
> Note that we also have [0] going through the slab tree, as it seemed a more
> suitable place to do that change to minimise conflicts on that front.
> 
> [0]: https://lore.kernel.org/all/20250722175901.152272-1-lorenzo.stoakes@oracle.com/
> 
> REVIEWERS NOTES:
> 
> This is based on discussions had in [1] both about this newly renamed
> section and where David indicated he was open to maintainership of the misc
> section.
> 
> I am sending un-RFC'd as, while a lot of files being moved about, it seems
> relatively safe to put these files in core/misc and we can move them around
> later if necessary.
> 
> Additionally, on the reviewers being added, these files are broadly files
> that could have been placed in the 'core' section, so this is more or less
> an administrative decision to split into two and so it seems reasonable to
> maintain the same list of people.
> 
> Apologies if this is overly presumptuous, the intent here is for us to
> finally reach a point (with the other patches applied) where (as far as I
> can tell) every memory management-related file should now have MAINTAINERS
> entries.
> 
> [1]: https://lore.kernel.org/all/20250616203844.566056-1-lorenzo.stoakes@oracle.com/
> 
>  MAINTAINERS | 82 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 57 insertions(+), 25 deletions(-)
> 

<trim>

> +MEMORY MANAGEMENT - MISC
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@redhat.com>
> +R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> +R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +R:	Mike Rapoport <rppt@kernel.org>
> +R:	Suren Baghdasaryan <surenb@google.com>
> +R:	Michal Hocko <mhocko@suse.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/mm/
> +F:	Documentation/mm/
> +F:	include/linux/memory-tiers.h
> +F:	include/linux/mempolicy.h
> +F:	include/linux/mempool.h
> +F:	include/linux/memremap.h

Weren't a bunch of these moved to other sections already?

> +F:	include/linux/mmu_notifier.h
> +F:	include/trace/events/ksm.h
> +F:	mm/
> +F:	mm/backing-dev.c
> +F:	mm/cma.c
> +F:	mm/cma_debug.c
> +F:	mm/cma_sysfs.c
> +F:	mm/dmapool.c
> +F:	mm/dmapool_test.c
> +F:	mm/early_ioremap.c
> +F:	mm/fadvise.c
> +F:	mm/io-mapping.c
> +F:	mm/ioremap.c
> +F:	mm/mapping_dirty_helpers.c
> +F:	mm/memory-tiers.c
> +F:	mm/mmu_notifier.c
> +F:	mm/page_idle.c
> +F:	mm/pgalloc-track.h
> +F:	mm/process_vm_access.c
> +F:	mm/ptdump.c
> +F:	tools/mm/
> +F:	tools/testing/selftests/mm/
> +
>  MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Mike Rapoport <rppt@kernel.org>
> --
> 2.50.1


