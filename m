Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4649C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 08:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB246B0096; Fri,  1 Aug 2025 04:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274AF6B0098; Fri,  1 Aug 2025 04:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1158A6B0099; Fri,  1 Aug 2025 04:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF5AD6B0096
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:42:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 883F01360B6
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:42:32 +0000 (UTC)
X-FDA: 83727547344.15.72C2E07
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36D6CC0014
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:42:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dpkW4wDk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YaGSzTTk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dpkW4wDk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YaGSzTTk;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754037750; a=rsa-sha256;
	cv=none;
	b=voHdWSoKVzzOSyVFts5+cuFIaErftlZA+0gfxdT0EhrbxhncSvThetnTkYfKxO9KBrQO6Z
	pINq2lTPc21afR2BWIdApOKzucfCDH5dlk4l5D3HMCvUBotvkJGlVKX4GhYPsm0r/ErSEQ
	d3Vd9cmvBVmr3k8Mum15qf6zkVPEpZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dpkW4wDk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YaGSzTTk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dpkW4wDk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YaGSzTTk;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754037750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1QFIgVB5a2Z2g4OYw2eBao9ZSGPzsh8seRAvE4SjdI=;
	b=XY4223wx+hDWANfSn43H57rpv1SWOWyafQU2S6l+uq2wFevvV3ZUkl1pKNE0WKVfcCVdau
	y77BaQa1EYuHbRZjrjcj0hkk6gjhp4IZzKc1++s3xXOn6+PmCsHJ/9MP0VcRtlUWgVQAIr
	cVdeHo9wkWeNZIHd7/NI7tJCBsLyT+U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77B0C21B51;
	Fri,  1 Aug 2025 08:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754037748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T1QFIgVB5a2Z2g4OYw2eBao9ZSGPzsh8seRAvE4SjdI=;
	b=dpkW4wDkZXaPI77BrPJGWWMYcdbK+KIsJJIxyxONpDeQA+4VWofNejx5URhsgM2CgfVnIF
	q+FBvKp0aSEf96hTUozmXAR9y+TmLIbU1MafzRXFhUfiLEw1Ws/c0lZI0JdxjRhXqTuX7I
	OLlI7irerb4hysTZQx7c0iNrN/W15gQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754037748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T1QFIgVB5a2Z2g4OYw2eBao9ZSGPzsh8seRAvE4SjdI=;
	b=YaGSzTTkz4mxzk6jtK3z9A6GvBp2DNuuxp/oLsOwQi8XinXRIYxm/xDCimQHYVT7FBWOz9
	r4u40csS3G+U43AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754037748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T1QFIgVB5a2Z2g4OYw2eBao9ZSGPzsh8seRAvE4SjdI=;
	b=dpkW4wDkZXaPI77BrPJGWWMYcdbK+KIsJJIxyxONpDeQA+4VWofNejx5URhsgM2CgfVnIF
	q+FBvKp0aSEf96hTUozmXAR9y+TmLIbU1MafzRXFhUfiLEw1Ws/c0lZI0JdxjRhXqTuX7I
	OLlI7irerb4hysTZQx7c0iNrN/W15gQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754037748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T1QFIgVB5a2Z2g4OYw2eBao9ZSGPzsh8seRAvE4SjdI=;
	b=YaGSzTTkz4mxzk6jtK3z9A6GvBp2DNuuxp/oLsOwQi8XinXRIYxm/xDCimQHYVT7FBWOz9
	r4u40csS3G+U43AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B84E13876;
	Fri,  1 Aug 2025 08:42:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oYZ4FPR9jGg9LAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 08:42:28 +0000
Message-ID: <61ef9a4e-cc9d-46c9-94cf-4d9231ded749@suse.cz>
Date: Fri, 1 Aug 2025 10:42:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: limit the scope of vma_start_read()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250731151919.212829-1-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250731151919.212829-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36D6CC0014
X-Stat-Signature: kdpg5yjnnqn44exddt35u7wo6eu7pmk1
X-HE-Tag: 1754037749-207193
X-HE-Meta: U2FsdGVkX1/64zHBpAFNNDWgIzpOagU6welaWI3H6onXGM5z+LTEyKymQUSYqr/F3m8IwHERylzKZr21uIWFvdABkiJ5Q5jpVcnudmFZ5jR6kQ4OfIQsctEIH0FFiQCPF1UVErCixHsCkZO5+U5j8oMsvAUBsb9psZtQK5nxjBe84s8AWT3gcYuWQ3elAU9fXHog9K/dbSvKIIxGgjfCRumHCEQYrIqfMG16+KsLZoSrS4gMeqQS8Xckway4cyUhYu59c+BPPn+yDvJtim9mNdPTFRGBrUmNtSSlMzs1bIiw+LCCwwXYzUR+CoRWz6SxxUtr4Bfxr/ulZF7QlXk6AzCa5zROzgOqLVIgqqA+1c7nDFTzkeMhYljuK+S1pE/OoLzG1zKLikjvzL7sPkqG5RAehGj+D01n/g9uolvUugNFjutNmPUzZEHT/Ve4lbNBP4YTWCsvTgAlcJDdQUc5gSjyW89/FzQ1/AqHmS00MNC7Q0FszvQeTanIO6/rcVzC57Me/My6LPpKXktXFNZaA2CRs755duRdTcN8m5aTst5oaU5qiEeMsMAjlkQlxtKi8Ad5AZ4v3uvzLRyb9dEyMbA8RyPC7FjO1WuJNbWAmkOR2NdcGNSDGsL7tDV0rB9Cm+7OJb4r1utx2043KNa642M3UFrAPOJbuU57LgR0z5plVVg/ZK2EbT0WXhVomFTl/WPuK/ESuuWAR8KzlMx/WlaX2wbr3iJBRXX6uwiGZTxiC+o0lA9T6qPW16PeQ/MwyjhoDK/EABBsmcHR82WvULnzEJcngr2VFQmz/ocgHiw+UCi45a9llZYHYUpnygLmgibG8DmH+TqIPiyWEo4IchlMWAMquDostl9eCxcR9ishyMe4HLs5dKR47cS93/8nzu83AqjUpIWo/88VF/IG2SRZITf53M/B7AA/76VKTewsJdxG4x0XcMMZrcBXw+7NoqnfrqqQKl56y3YkNVh
 NYF3Qg45
 jSbp88xNiTxUwiXS0po4N2Z1tCzrdNEjjrBJ9uQAGwsgwDEfCZrh+lCpyZeJraSyOWDNO2U13KImpArJmHe5CrpunH0GZIJba3nMs7sjkL4kSpYJFdqR/4xDi9t5Zjn9xgiQZXFi3zg1tHhVt+kz+FQtTUVN6dXlt4CjjWxcRGTwp6ikq7nVKCPs0qyJl1cAM0QRgvN9nVVAQyYiU1eoAcMzlLBB6T/GN4v8ar48OirJ2Oezq1EkNkHinGlH8jnh3mR7z4Pi3uSREzvfZCfeqZ4qq6ubR4LiKeB4TY85lJow2trdAy9DoLsptDqSANYE9v7f9oeZALPJFNyw+kc1t59R1c6i4zVW3vash
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 17:19, Suren Baghdasaryan wrote:
> Limit the scope of vma_start_read() as it is used only as a helper for
> higher-level locking functions implemented inside mmap_lock.c and we are
> about to introduce more complex RCU rules for this function.
> The change is pure code refactoring and has no functional changes.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


