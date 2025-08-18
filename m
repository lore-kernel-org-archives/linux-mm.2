Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDA3CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97C26B0099; Mon, 18 Aug 2025 08:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C486B6B009C; Mon, 18 Aug 2025 08:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37406B009D; Mon, 18 Aug 2025 08:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A20B06B0099
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:02:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3400D1DE224
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:02:50 +0000 (UTC)
X-FDA: 83789741700.10.C665B1C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA0A2C000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:02:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JIZIkc02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hXpd5nL3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JIZIkc02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hXpd5nL3;
	spf=pass (imf10.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755518568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+3lGak+12Vl27FVM2SSyx0kSJAGYOUNyyYt5Oy3FxA=;
	b=5eFjRYsAy5MGyyO3AbD4h594vV7CGKhaIMLDYSnJjCTLPbLA4c0521OFHfYusHm//DAvNW
	/OHoc98fhWui/L7hHp6u8llVJ2TNA1/GjLZmq7F4rr7VoFuI2zuTPeq6eCRF4pjG3VEATZ
	g3t0d+wxRzNgne3gCsUilwHQe5RtEQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755518568; a=rsa-sha256;
	cv=none;
	b=wE9b9K9cCP9lop+4l9Zfb1OsQYAjd9WJCWsQApSTRguVqU/Rb8PlW/FcCvrhyHaML4c6M+
	oIaLVm6NYmFoHfVSqGFpRuBvUdxhJE/K1m8oDVkEt9dfiwKpBzaX4Yov16xGNWDVG1IYcX
	sDRKeNKt9e017+O6GcYZBgBRDGCPUVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JIZIkc02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hXpd5nL3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JIZIkc02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hXpd5nL3;
	spf=pass (imf10.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C9FC1F387;
	Mon, 18 Aug 2025 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+3lGak+12Vl27FVM2SSyx0kSJAGYOUNyyYt5Oy3FxA=;
	b=JIZIkc02a8dlmuExIatpt2ibFt1oHaVgpfYJlzavqpHiN63uXU3zsBHjuPYfqIMpR4mVG1
	SJp8AbTMrdjoYyQ4qK8k1fLJwJoVyEBOG3Jsgt3171NJo8DOukjDlkf6n1TiH8+MOsCatu
	Uzr5aUuu9imvUiEuaKTrR832xM5X4w0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+3lGak+12Vl27FVM2SSyx0kSJAGYOUNyyYt5Oy3FxA=;
	b=hXpd5nL3/MIuI8ZUT7MUGVF7scVkEDjhZHYAWXWWH9MtMDpgE5Y4CT3gVGk/sTAvpyc0ul
	6QHbKQ9UAUUmsgDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+3lGak+12Vl27FVM2SSyx0kSJAGYOUNyyYt5Oy3FxA=;
	b=JIZIkc02a8dlmuExIatpt2ibFt1oHaVgpfYJlzavqpHiN63uXU3zsBHjuPYfqIMpR4mVG1
	SJp8AbTMrdjoYyQ4qK8k1fLJwJoVyEBOG3Jsgt3171NJo8DOukjDlkf6n1TiH8+MOsCatu
	Uzr5aUuu9imvUiEuaKTrR832xM5X4w0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+3lGak+12Vl27FVM2SSyx0kSJAGYOUNyyYt5Oy3FxA=;
	b=hXpd5nL3/MIuI8ZUT7MUGVF7scVkEDjhZHYAWXWWH9MtMDpgE5Y4CT3gVGk/sTAvpyc0ul
	6QHbKQ9UAUUmsgDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4984313A55;
	Mon, 18 Aug 2025 12:02:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RUFWB2EWo2gSbAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:02:41 +0000
Message-ID: <ff1dcd4b-db64-4982-bfc5-78db033f61d8@suse.de>
Date: Mon, 18 Aug 2025 14:02:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: add persistent huge zero folio
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
 <20250808121141.624469-4-kernel@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250808121141.624469-4-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA0A2C000D
X-Stat-Signature: 5qsczcjik86xjwt6ibyi1s75mbu9b6q1
X-Rspam-User: 
X-HE-Tag: 1755518567-322561
X-HE-Meta: U2FsdGVkX18ZVsovPZr0vr5FaREW+/NXTGg2hnqxVkJ3vYEKQVCOsSzVJNOxf5xWhgkIJ9Lb+M5FbKeXpHLgxmA9v6xnqs3/XCbcg4uaxt33HKvL+miRzHK9EVOuPA72N4NZWVTBsOfwAv/c2N2IKaNk3CA7lT3d584TWl9U5agmqxOzVmSUFpRotYzRKoG7JCfqgHw191GsRia7r1QrOA5/h8nw9QSXe6rkKYkxejZRIgy5v2qCpnqlnPM8cnZrmltqnuaFUeNxsDottzFms3VRODmdgrvh0zUHNuVJoo8kHYLxNhl8ALZAVn6Sw8Bao7gaOB5VOZS5Ix4HycrUuttzc2YMlqeT4yUr9F+OwU/QwwKydZbHTM+rV1sQQrVi+RphsdccqTikCEYdBcrG7jI6cTyU1j86xnh55efwLNUAqG80B5pI2+V1wGRSs84feySlc+puh4bEtjR4nMs4uy9kjYaYpM9WBWtvkJNRwDmWpg1TuA1FYrt8HCIjWUZGXsrWbnyD/hNeIZLPBtl3G2SWrMYRqDcV3m33eTt0ZPICuhtoPesgIf2vTQY0qzpPirSJkDuJeME6vAHzmTOJpFraxqQcMm5RA4tPYo32IkXnd8v8OYvPKw6aPvcDRIREKIOXNC1v/2UJxx+nesyvCyg03941P9oVfcybpe9zBHhbirRb3umAZxy2PqQKrblbQCFL9xKqch7tUHK1MwBxPIaklHnC/3sQeewyeNUY3P+q/05Fu2rwAVC0u7Reiir8QsGdpED1tstiP4FqLXbWkFe0UoFxAziC6Ll02KvjtHEM2oALJE7EVdoCDYCd1zHHv/2y/SXxRAVI/jbovPLvI5FKyhCjmgeVWJIzCGScVPHi6RNypo6sfJiwoGlmVN522GcKxSlbSFWiggnnjuXN5qoF2mqC1tp/s0VqkP8vVwVp5fWhgCljamF3XBJGOYY/irKOAIZeiaR24wEDaTf
 ojosNa9I
 HAOYiRSbzCDahztgkzP4TIVicYKUAIAiAkDArA6WnVHkokUfifWlPYZJbvrJew45OcB47GPwXznHZdxGNCjdhthwvhseajFIfLoJzwDNmrFN2sXX/IIIggtr2/8A0PvvExYK4oy2jqoLsqGNfzNCMCYg6OOoCaygi+k7izMFclMtENcCWGfiKKxmWu/LtZzEZKXQJvJn0LaukUt2ASCm2Jla4fIUWK++S1/dtuYo01zQ/lmf+PPyzh1hh4vv+QKvjGKaHrx4zsaWfdBsPv3VU09XfZ21IQmfk3KbLsW4Ula3UusZz2NiElUCnEQKH620A4pk2n4eLQU8ujqw+blu2pP0kJzmlRWkqjZXO6iR/wzU9l1sNXt9EG6yeKQ+mzw3xWXqqd+sDx4rctlCctp3oXVF63dBQz+bzc/x+0yVh/BgQisqlWOpruXN3F4v/6GYMOfDj+XjJBWgcy6Wq6ci3YvWZ4RkgJnqaSdgs7bUV9ws9yKEHcL5yif5jFmsMjxbrJmSfnegA+QzD3QQKCC80zvBFDw==
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
> Many places in the kernel need to zero out larger chunks, but the
> maximum segment that can be zeroed out at a time by ZERO_PAGE is limited
> by PAGE_SIZE.
> 
> This is especially annoying in block devices and filesystems where
> multiple ZERO_PAGEs are attached to the bio in different bvecs. With
> multipage bvec support in block layer, it is much more efficient to send
> out larger zero pages as a part of single bvec.
> 
> This concern was raised during the review of adding Large Block Size
> support to XFS[1][2].
> 
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main points that came up during
> discussion is to have something bigger than zero page as a drop-in
> replacement.
> 
> Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will result in
> allocating the huge zero folio during early init and never free the memory
> by disabling the shrinker. This makes using the huge_zero_folio without
> having to pass any mm struct and does not tie the lifetime of the zero
> folio to anything, making it a drop-in replacement for ZERO_PAGE.
> 
> If PERSISTENT_HUGE_ZERO_FOLIO config option is enabled, then
> mm_get_huge_zero_folio() will simply return the allocated page instead of
> dynamically allocating a new PMD page.
> 
> Use this option carefully in resource constrained systems as it uses
> one full PMD sized page for zeroing purposes.
> 
> [1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
> [2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   include/linux/huge_mm.h | 16 ++++++++++++++++
>   mm/Kconfig              | 16 ++++++++++++++++
>   mm/huge_memory.c        | 40 ++++++++++++++++++++++++++++++----------
>   3 files changed, 62 insertions(+), 10 deletions(-)
> 
As mentioned, I really would like to have a kernel commandline parameter
for disabling huge zero folio.
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

