Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66A9CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533FE6B00B6; Mon, 18 Aug 2025 02:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4A36B00B7; Mon, 18 Aug 2025 02:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACAA6B00B8; Mon, 18 Aug 2025 02:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2607B6B00B6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:39:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C59731A07F9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:39:24 +0000 (UTC)
X-FDA: 83788926648.23.A002D88
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 910D620002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:39:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=udasneBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=I5SpOzL4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=udasneBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=I5SpOzL4;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499162; a=rsa-sha256;
	cv=none;
	b=icCRFNgwxo3rWcDZf8YJaOrHDLsRw4ihbB/QAhuJlLn1i9GCTJDSN7LptwqtxGS5JlXbTd
	cVT5+Oy19rGbtRA1OVqbdknZ9/KrpHQhZDpWmkHqU+AajJAirSfv56HWrfkgJFDE0qQZBu
	SQnOx8e0Tx0bo/5d4U6jsLIecc5r9ic=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=udasneBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=I5SpOzL4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=udasneBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=I5SpOzL4;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GdNbUyDP+DT1aNEcPmDrED6jZJOeFHolY9S590GiyI=;
	b=w6vtmq5r/p7e0xJULHzWz7K+JfyTo8jLLrVC+CJ4pA0c0SxMvZ8Z5dt79NLBMN1iBGeUFz
	7D6fnvyZ7v/Y38MIs1f2L7FN7RkFgCNJ3s2KLiXRDoe1izE0e3e7KsSiq3UbiX+lDH7s5x
	LWw6G/v3RiFt/zAl6Ys31qSMfIXZXWQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D1511F387;
	Mon, 18 Aug 2025 06:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755499161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GdNbUyDP+DT1aNEcPmDrED6jZJOeFHolY9S590GiyI=;
	b=udasneBHThsYZgO61XJ29x+6AH8Nf3gzF0OZ+dhXWC+vrDlhV411xqfXHbnBhjZ0VVdtEs
	8bEy6g7xoJOAsEhft4dKEMzncAINM5XIOQaogy6oHEPgNJIVOpSjZRO1TRwnCLRp1NZ9OL
	xU5lmcHRGHnVLEMTFtOv6bt2+H+8dKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755499161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GdNbUyDP+DT1aNEcPmDrED6jZJOeFHolY9S590GiyI=;
	b=I5SpOzL4fmgjUAbWRShMIpwnchYuXH92LNZHpLSs6+KAbwvbWTmkfNfbmhI2m+bPgU7cAw
	NRzp6oBE4xCOyfCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755499161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GdNbUyDP+DT1aNEcPmDrED6jZJOeFHolY9S590GiyI=;
	b=udasneBHThsYZgO61XJ29x+6AH8Nf3gzF0OZ+dhXWC+vrDlhV411xqfXHbnBhjZ0VVdtEs
	8bEy6g7xoJOAsEhft4dKEMzncAINM5XIOQaogy6oHEPgNJIVOpSjZRO1TRwnCLRp1NZ9OL
	xU5lmcHRGHnVLEMTFtOv6bt2+H+8dKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755499161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GdNbUyDP+DT1aNEcPmDrED6jZJOeFHolY9S590GiyI=;
	b=I5SpOzL4fmgjUAbWRShMIpwnchYuXH92LNZHpLSs6+KAbwvbWTmkfNfbmhI2m+bPgU7cAw
	NRzp6oBE4xCOyfCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30E5E13686;
	Mon, 18 Aug 2025 06:39:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PbYRCJbKomhIBAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 06:39:18 +0000
Message-ID: <d7586866-5a41-45c8-88c5-ab6416d27123@suse.de>
Date: Mon, 18 Aug 2025 08:39:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: rename MMF_HUGE_ZERO_PAGE to
 MMF_HUGE_ZERO_FOLIO
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
 <20250808121141.624469-3-kernel@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250808121141.624469-3-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 910D620002
X-Stat-Signature: 6169pr1ogartqermk5h5mms3r9rjbc65
X-Rspam-User: 
X-HE-Tag: 1755499162-400125
X-HE-Meta: U2FsdGVkX18GDVGcLTmOb+KG+l5tM4IdlvNt3WAOEofSaeKGXut8uUZ2D4FHaVb9W0qctCYPDvJqUc8qPEsFI2FLcAiMDkyDTHNTkxfRoZ/nXeIS3uLI/4UZiH3aD7OL8uwoVIAfhHZHsPZpw/YE4n1eSLd1E1ZaDn4tsqO8b7XxPYx9fn/8g4qHoJ+pa+NJWxsTDU8uqU9on7qPklLQtq+J7wP9COBRXtD2f9o9T/Poz1f68ef0PeLVd+o3UdnT1KBckfJAMYeiakN4JK9EpmRMYmnSgglSd1IP5xSsfhh7cTQUu1vApPWQs4iLUkUQKoQ/lkNw2tISPRVLsxcJZJhjIZwAIHMrWBW06XArE9eCCOqqQ3+Xwov2L9A+/D/U9pZD/ur00pLDujvTqJ7LefnVqfMjcNqBatTH6MyL4KwVP7l2DKuDk0yxZWJGwScTb8O3mz1TIUoB7g7Cm0s5GGwPFq/rJpQbalrPWE+g4eSH9XbrKtlK+iRFkMmGCHyYq95NDcHrm5U8dKzfk5vHyImPuE02YuDNLyIwCDBZFEALpCXwrUSe2nDl+OAKuXxdzPc2LWcXmT7Gs5BTAfhgJFlErOkLWMC0nh/i61QtSxcLjpYRWi6xhTj04W4/5mWcWWSsj0JZna3SJ8OD85vTZwTZuLhsP3E+hDiNdJjzZ52Qc7X7XTsQjuvdBAcp7GlXW5vH1kvu1SrcJxiJRGUwrwbufY46SMYEzOkJS8cWkTroNKthNCX8nAtEZPR99B9lSzQynW4aHSsjllsMXUSjHzPA6Oy7rYUH7PUus+67U9iAu+kEFOopH0EivJBtNq9yMiA5zvVljV7ksEWiZTOsmM2IxHjKUBxUE4X4PcFUBONw23i0ZYDRAWLahtRbfo6kcaHEDcSKe5SvWW3tTFpuwwxwjnA5bXxcJGo0qAVpsPK6AX1UK8gfzL/dYkjS+MPjm3NHq48Wqpnjn7vHRjN
 sj5vwjKd
 4liJ3HL7Md8bdX521NdEAPSPnKDLID4Oc9vx10yte+dKFFAOMudEWH6+sB8NntHIi4nqZdDDn4S0aD9hs2E+5vMMpdA7iYorYD9Eeb+7J7Zkrsi7GnqT+oc3LwEx5W9kyAlRDRnNomhn9/2ckVAVd+JKvQdpeYlxOzrD+coGEZ3YkHeGDiUi8cQddh3iBB036Rl4Xlh3z3Bql4KGtiGm/Il3RlN9GaaQd5ur0hBhY/qMvgLD8AtChjLm8py7iccu9IR+oJB048yOsaCr8kXKSX/9WXThF1Fsp4qrxzBhHRb/novx+APc8iNI+GE2glA7UYbvWpbj6N4fO/VQRyd9LoFps3/eivwI5+DwBlhiA9P9NjrAzYohZS0+pEnJNOzjVTYYmGl1KodqEdoTEH+QT8MjyPlesSCrWq5cYNfvUb+5rUSVjSyH21Bv+Sn68WEHUf39flhoRryq2/Xc1Y5EKdEH3a2mzqvI7mC210WpLi8K5Gdp7SAVwdfcuZ6x12lgQvrv36wFhWrcTSH86/znsfjiyae4+Xe/KzNfF
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
> As all the helper functions has been renamed from *_page to *_folio,
> rename the MM flag from MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.
> 
> No functional changes.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   include/linux/mm_types.h | 2 +-
>   mm/huge_memory.c         | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

