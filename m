Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BDBCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA6A6B00A8; Mon, 18 Aug 2025 02:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2AA6B00AC; Mon, 18 Aug 2025 02:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B86A6B00AD; Mon, 18 Aug 2025 02:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 595906B00A8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:38:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 064A911856D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:38:53 +0000 (UTC)
X-FDA: 83788925346.12.C73F19A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id A591E140004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:38:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vNrZ5qvK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bcxpf1FF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XfryVcvv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eX8tHYxx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499131; a=rsa-sha256;
	cv=none;
	b=AOgp2GCxcPwqYbB8chCrfjsG9gilD77Av7vdwWpPAAXuyXfU4tePE946a7HqmtR6tDw5b3
	/0TinN0JJXP+p5uqldEF168It6PeVGr4cFMIazpd0tqv4g5nKm7pKXaoYwgsORZf6jltMD
	JdC+rVU4o2/ZJLcfsEQx3t9sqNqpj+M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vNrZ5qvK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bcxpf1FF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XfryVcvv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eX8tHYxx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1+7D85kOQ97EVvudAvVmc/NF5mfjwf/0sAeafgfM4Y=;
	b=WDZ6MyC6+eUtXmkprImG7/Dz3w1iXDRYNQvqrq3LgvEVzE4t1/upLHanTZ1s+5xD8OONfk
	3mKyaxuxUhOmiz+Trn7/F4n2WET2XkW7DvU/qr93KNYRlXJ1l95qwhQ/uHEfFoRMQVLcvw
	TLI5Yt/SdjiOlULaB4rmJ9kPuRt8hVc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1E49211A2;
	Mon, 18 Aug 2025 06:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755499128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1+7D85kOQ97EVvudAvVmc/NF5mfjwf/0sAeafgfM4Y=;
	b=vNrZ5qvKXndkMLAoznbqyLSTFePX3kh6KnRZbHoB9C2zjNYPRlSZNqV1rs87VkIN/NFGA0
	epO2K8Z7f0c9H8dsf/cWUbqIgfkSDfNRGRDND39rNvY8/xCfs/tNHRHV7tNN0+ADyD5VlJ
	bdOli6rKzBHRDtEdMB6qsFlPXB5BZNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755499128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1+7D85kOQ97EVvudAvVmc/NF5mfjwf/0sAeafgfM4Y=;
	b=bcxpf1FF5NsMzd0krz+WQR2MFA9E1G0HxMmkiuXlc9+WUvsPrOT8Vm8rqnMZYOF+i+Rb/N
	aHIjWw3qaa96IUCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755499127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1+7D85kOQ97EVvudAvVmc/NF5mfjwf/0sAeafgfM4Y=;
	b=XfryVcvv/Xm/N5A4Mnz0Ajiv+Cf6ifBCBsKqFJtZs8dq+AT/GoxM9groiQMa4kcylxrOVz
	/94/ult5O2fshQOyeuqzB/qaKTN9maaE/Th5IqJBkGyK8d4LsS7cE3058t21c4tAq1JhCX
	G4TCi10TJ/pTuH29hHszkqfIeg52AYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755499127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1+7D85kOQ97EVvudAvVmc/NF5mfjwf/0sAeafgfM4Y=;
	b=eX8tHYxxj3BHjPj961nVeOjzv++ZbhA1I1wWTvkD1AwqIaG9B5HtDESZSwNrDDdPYl9phW
	9jBS4Iek66isxuAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DB6413686;
	Mon, 18 Aug 2025 06:38:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V01TAXbKomgdBAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 06:38:46 +0000
Message-ID: <bbf3759f-c337-4084-80f5-170e6f1ced34@suse.de>
Date: Mon, 18 Aug 2025 08:38:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: rename huge_zero_page to huge_zero_folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
 <20250808121141.624469-2-kernel@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250808121141.624469-2-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A591E140004
X-Stat-Signature: 713mhw1afcinzrbab8t5y8jh8fcehubx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755499130-128850
X-HE-Meta: U2FsdGVkX1+03HMnN+cH6KYvUkk6W8E6mwV55efWEsraJcynJEL7Bi+MI5DEBVbqXMszvun1cuMW54wsp9/AWdPSVh6zB36v+175fuFwN1xnU0breVrHfnzTJu1GXUe+FN/OPsXqYQHbiEX8r8+UV1ERdn0hIqnOGwQc6tXucau2FFryXfl44qXsJFjWJkxaf1HO8KKOwg/K0UXgyi/FuZpr9SMH+6yrlVbJHghIa1YrDNSUhsrph8t0h8q+OPDwXiLTvDKNY41aIaoQnqpPLHELoDkAJqZytGu6So6ZsmmBNlPPuMGxI86YE4K1S28OlPeIhO3lyGE6v70JQWT7NDxFYb5Dt2YHpVtSwpRgCqZxEc9p6mw+Uj9vol3VjH4rZWsOmZueiF9aWAk1sJLTzlWkbPeLzvX7gjQgqm63j/flMn9B/nqS+rtmf/pwBb8PEbDz+nqbd1/PAo/f/c0a9TYvGSPXqFY4QzVBHVMnX5CXDfHbzWFkEUSIcJQrVdJOoybVJSoNtIfqcFiqm9q3QHSwYAtMOvCqnvZZjNxXLRMK23keeXYmhkNY0JTMAjVzEf6CW56NswwNK6N8oWcBnq1hyrA71pTs1ShaiILM9mYJWuzyJ/iLrV1LvRiZMfcSgckq5gJkygBt1jebTSsrAn2usW3BF2nTfow76c89NMpQS7Kzu3+hqI2gSDAJCtUnlkEJnsnrR1b5zz9An6EDHEHjkPEM+jBY5Rba9/+T5561wXRJxJ3EpCJI0uc84r5yNu1Isi9sjdNfCxCxB0EQj5lgpRCSNLOYgA9H2lNc5iG4dGakEjDqXlVhRF/uDJ2YSr7sQE4TKfAEhB9WdqAHq9SSb9HJNViJ/WqS3JQ+i0Jpe5u7wKXM85Iz6CoRCbF6WzTDJy3auYUVVz6J0zzha8zqlRQef2OzCqW6mEDXx/MhfKXi5tIE5HTaWyQXjeTfiY8yviA54pPSbbbBODo
 8Vq3dYA6
 njkWTxPmoUUP/ivSgJnnYD0YRFhdMVvMEUoU5/pg6wDL148IgVC9MbqXSfZmkyypFGIYK0dhlyzS3dtatZ7R2wQ86rTmNvjdDIL1TWg45FH/Mqd9vFRelcC/qMMen8uwswxTycmGKQNYkE/QWR5lAvLEKCNlNYZDw6Yy6SMo2gFq9RJSi6od9s1a9O7FAXubWDz1uB4iqywyFqHEzAIXrk+pi1EZ494asDcerzmShHskp1US3H3hxfGsBifR5q2SLgYKrwfXFAUE8sW6vr4COhIGkTMLA4OUNQu04z7KLfA+T+cxIJWlcHysCSlhQ9llsvRAjAcuKqxwKF15rTaN58ZrPkg+ekxQyisPQsgBXTRyGBhul+cYZUblQcGIVadBLnm0DGkoU05QLzYXPuC1fXX1rzD7T+dEe1jFdVUyKUp0NfZaS44SKwuj6xZXROZ6mZnLPYEr93QSn/kybO/WlZ4mGUJiIsUauMagAUaeoqyU5Dw5GXCrLFmdN9emZp5+c3aP2sQdVff3EErjKY6lQawseRlhX0ZlftyJU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/25 14:11, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> As the transition already happened from exposing huge_zero_page to
> huge_zero_folio, change the name of the shrinker and the other helper
> function to reflect that.
> 
> No functional changes.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   mm/huge_memory.c | 34 +++++++++++++++++-----------------
>   1 file changed, 17 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

