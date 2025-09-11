Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842F2CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D044A8E0005; Thu, 11 Sep 2025 12:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBCE8E0001; Thu, 11 Sep 2025 12:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA358E0005; Thu, 11 Sep 2025 12:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABA2F8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:38:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AC6E59410
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:38:20 +0000 (UTC)
X-FDA: 83877527160.20.C3D2332
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7709100012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:38:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qStGHcRR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bLNs7O4N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wZNsJn9x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B+r4iCSD;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757608698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1aWG7EXWx9OEMM427alJ0JFszpvoAEDfexiWNEc7IE=;
	b=P39U/wJeGYmAULPXhYHxqSRH0JvPcF4WmVVto6DUJ4q0kB7gFscaOEzXT3Tlwhpwqhdla6
	O70Fz4xaNqfPHE2XNe7tZYonRitSXcIddCE90dYhmmfTB/MdsIkMiWRfOf+N1DPrmpkxhh
	UULx2qZxcCrsPf/eypbcGLn/DgA7i4U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qStGHcRR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bLNs7O4N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wZNsJn9x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B+r4iCSD;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757608698; a=rsa-sha256;
	cv=none;
	b=g4Q7HJodpY0lTmIwKDQAMOqmRD02IjvVL3yh+nr+UdkcqwCOmg/dz0azapk9iD0v2yMUod
	IVYCUWhLpZDWV5Znk5zcOwPmTjharH+7fnkzdlHokEMKbDBUL2w5MAPIuboSO/OgWq8K8e
	vZ+yeIBVGPZ90aqtyfY58FJ0sLXd6DA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6B0E33DA4;
	Thu, 11 Sep 2025 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757608694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W1aWG7EXWx9OEMM427alJ0JFszpvoAEDfexiWNEc7IE=;
	b=qStGHcRRQikPQroAuzAJ+Wo8/hJeUb/9iWFqg7/fvQm35kV8ZpBPOYsDD/gYdMdQ5OnnFC
	/zAAClo45ab8cAJE+VsS4RGTUnp6mawcDsaSamMkWBC0kHHdkEYVktAiuCeglEpRaZLM/w
	mu5OlhUPu5TiKBnUSClqLMPiZNB+8Ug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757608694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W1aWG7EXWx9OEMM427alJ0JFszpvoAEDfexiWNEc7IE=;
	b=bLNs7O4NRHkIvrJS3+pM6XHHg/L8fdmF7bf0AMHX9nMkz+LFPBI7RJF+27K+0C49tzNLUt
	+/vIAJYgCUHHovDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757608693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W1aWG7EXWx9OEMM427alJ0JFszpvoAEDfexiWNEc7IE=;
	b=wZNsJn9xIlW4R8LiEUQprbXoNTquua0PlIjiVn24VehUqHIAeWWMKamweS89YphkIDPuca
	/umbsUN8Ua+kIkv0Gq7Mqr07MmlDKB13tBO2aU97DX/lDFsyyYmMgjHHWXzVmYSjJHmQ/P
	OAyGX8KWOCc7IkQi/nMUsazzjmcLjbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757608693;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W1aWG7EXWx9OEMM427alJ0JFszpvoAEDfexiWNEc7IE=;
	b=B+r4iCSDNQd+nNrGc8AnldTFaB1tDNWkascaxX54Z/gdA87wbpSwpV/q+tNqiLSG1gC4qD
	R6KHr7ArYht00YAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E6811372E;
	Thu, 11 Sep 2025 16:38:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lnnqIPX6wmhCHAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 16:38:13 +0000
Message-ID: <ee57e179-798d-424f-b84a-b9f6b3bdbeef@suse.cz>
Date: Thu, 11 Sep 2025 18:38:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/22] slab: Remove unnecessary test from
 alloc_single_from_partial()
Content-Language: en-US
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-3-willy@infradead.org>
 <52418c79-5a06-67b8-3925-d635e9c0a894@gentwo.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <52418c79-5a06-67b8-3925-d635e9c0a894@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D7709100012
X-Stat-Signature: 88ucwief4hjn4b4sphtqqurcd3wkmz5u
X-HE-Tag: 1757608697-649550
X-HE-Meta: U2FsdGVkX19NMp3Uo4cqmDryOaW80CwlE4k9zD0ZH1M78CSYLxM3OmvLwOpg3knPo7h/9XcEsbp53x0YyRHfUx1xOoU0RgJO4Qq3pL0NNH3Mxj9KshNDfNFHEERfNQKChjJV3jPUCRfXn9hCrrfHOYXSMawrNjZIJR6fOX0npnqU7K9vLvOA5XYR6EKozxbL+UdcZof9ltPgNJd3HIcAOnA/XVLBkhYDezS0bPFc5FGh/ZnshGpK+YWUyFyxmKa4YQV9EFlk7Bgl8op34jV7Zl/OWQqWLUdgozcwIRErUcbalBr3ACSwB5JuriYt2j4ESyt7NUNKZAVkrySzMJjYo2A8YvciR9ZpV9Dk1DYgAett6pr8OAsJT0Zr4MYRHkUwNLI57XITi9+6vCaBg6eW6KrnMEZ4LI/OtLxb6V7m+ljmhQ8l5FZ7yqcICMyOzKqwaR0G77Yx96+CL6ILJUdMMbc7gSjnLHA7Id+3Gu1cfSvJg3ckjW4a1afPaq+WiWhQ5QY+7rrQXqbTjPS6cRXIoyaOcBQKjIcgRVZAd3sICwB0KerrHtXysW4nNW0ODBQaaJubTDZhB4QILiHlNHC5Gq95dWmYUn+cHv5DVS9bLhhuoNvC/eQMmmyinlKVCh4JyR3TnAvajlR7JdAe/9HKj1PN5KjEjXPG9FAVO8FJ0zdqBK55Ua0Ts1urAS6JajQkHRzASPXHHXAK/A8Lg1Y9UqAR1N095QVtRC0/qnvUGN0lb0Ej9V5Og4MUK7HBUUgQEAgLntTWHgbj4LLLlMfkXsEINvzVhZqI+zsh92/BDCW6U/okX6bFnIDXG7vkB8x/3vLB65DwRJmw2Q61MDiPOc0h0vWttPRW4GKJ0qN0ASAt0U/3uH1CwbyEwKbYK9Jx0JQNPgEavYqVvNVElnDNBc9kaPg3zxQ/ADTz+54SFseNwtDLG/vu48nrHnTNHMgFhLSkYndPuqzicPcKrzD
 Tkr9ukqb
 ulOd3AuyULCJ/o3QU0BfqfaRXBKfenPuPNZo5KEJuUbNgQuLDP9YenHQ3uoJXxHGIIXJQUAT6ovTOZNIeBgfspWM3iQTQ93eEFMzMdGW+CEdoyR8NX9HqxrQKuTnlRNoyQiIVFe5ST2h/bqGHF/R3Bp6AlAlKrsE6d7QPN9YhdOpATOid5yJhGAjQ0yYk4Ql6s7AzoWAMLNW2lLIKmhVU8ksvVSW3DmsWF2zl5o7S3ilwT9mNZqkIcljGqfSRDIzzzXIlM0RWLzAeTtzeAvhHCdyMNztS+QUrBzSZS5q6Q/HTjXGnw3qCmFHSUHrXgXlP8iKPFJMZTJOXd+VJbZUaG+WSLVS4QVM3sgEX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 00:23, Christoph Lameter (Ampere) wrote:
> On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:
> 
>> We know this is a slab because we already modified slab->inuse
>> just two lines earlier.
> 
> Yea looks to me like we should do the debug processing before we modify
> the slab metadata.
> 
> If alloc_debug_processing() fails then we know that there is something
> corrupted and we better not do further modifications to the slab metadata.

I'm going to handle this by checking struct slab pointer first and
terminating immediately if it fails, but alloc_debug_processing() assumes we
already obtained the object pointer, modified freelist and incremented inuse
accordingly, so that will stay.



