Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2216BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 21:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45328E0010; Tue,  5 Aug 2025 17:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5878E0001; Tue,  5 Aug 2025 17:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDC08E0010; Tue,  5 Aug 2025 17:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89E7E8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:09:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 408AB135587
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:09:17 +0000 (UTC)
X-FDA: 83743944354.01.7620785
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2930180009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:09:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p9aEjxJw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0+h2pSwz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Rlry1KhR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7St0oHkK;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754428155; a=rsa-sha256;
	cv=none;
	b=FCIFsN6Ku+LxTlxXOeCcGAvBFDaNj5IPiYz6VNsVMl3jKus61Rv/muGS+U6jZgZmnHTBA7
	cRuoN3nKcovweuHRuSrswmG4AiO8sq/cwZBlPQiflN/DHvEpNLzFvEg31oXRicPW6uZwKb
	6265Fgr4u0p7szmW0yqRZxRxAe9vmw4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p9aEjxJw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0+h2pSwz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Rlry1KhR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7St0oHkK;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754428155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNClJXYCT5XCWlcWvf+P0euVhQkljwm42ZjsxOdKTwE=;
	b=t03d8Sg6SoAThZ30Z+em2bNPC/vDbEVYnCg6+mVDSsprFawqpOOEgGTbFphz2Q+KZdv12m
	Wv7fGOBFUa+cwxlp+m8K9FSoiNTkDnQKgHh0ngMtFRWSrHJEImMjNCvYO+MigSdvb2gBu6
	4czTcZbstZoYp8frqqvXBQ56ZaPROBI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF4751F38C;
	Tue,  5 Aug 2025 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754428153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MNClJXYCT5XCWlcWvf+P0euVhQkljwm42ZjsxOdKTwE=;
	b=p9aEjxJw7HB9J2y3uwU1S6vwz0xm2N9udm5CG9zy8uIDv9pQXZba1tOWJTV1H2VEXw2E18
	m+CS1lLrr+Vmzw3fBVc+esWPK0Vrxe6wKePHEPztNTU2myATpYlmzXD54JCRtqN2Oywy1n
	vsfMBN80jhOdPeorfuab4hBlr87BWaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754428153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MNClJXYCT5XCWlcWvf+P0euVhQkljwm42ZjsxOdKTwE=;
	b=0+h2pSwzPpAL5tjkWpN7UIdpFNtE+U/r1q00OOJIk8vBX00ubtfn+PCNmTlrTad+YQupPt
	4jKeKuTsNptQVUBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754428152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MNClJXYCT5XCWlcWvf+P0euVhQkljwm42ZjsxOdKTwE=;
	b=Rlry1KhR+rCVQORBJtVPWHI3iL0iE5YW3tP01npuVbXcheF+iLCWfNJVz57Gbp5jqzsSkP
	ugtMDKXQq3DV/0gOyia6MqaigghctRnG4BTY9QqVYJKmFwPuOmsTe33x/2QMwsLkddd8DS
	Sg8rXRgJeUET+wOYhdX44Au96I0fthE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754428152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MNClJXYCT5XCWlcWvf+P0euVhQkljwm42ZjsxOdKTwE=;
	b=7St0oHkKevZmpkxADTFWi3gQQHxHNBvES3gmnnzW4h1AL11Y4nYxQvJ48xHC5H0skiC5oW
	Tnp44b0fVriojIBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADA7513AA8;
	Tue,  5 Aug 2025 21:09:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HLH7Kfhykmi0TgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 21:09:12 +0000
Message-ID: <ee7ba479-4917-4d83-8130-8c247c08d2d0@suse.cz>
Date: Tue, 5 Aug 2025 23:09:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Juan Yescas <jyescas@google.com>
Cc: David Hildenbrand <david@redhat.com>, akash.tyagi@mediatek.com,
 Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 wsd_upstream@mediatek.com, Zi Yan <ziy@nvidia.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
 <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
 <CAJDx_rjvYdjPYHbBDKvkaWV=-OPJG=oRdSAugaOyJAXaOVu-9w@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJDx_rjvYdjPYHbBDKvkaWV=-OPJG=oRdSAugaOyJAXaOVu-9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: pwhknr9a78n5185ywg8xs8tcsmwaohq1
X-Rspam-User: 
X-Rspamd-Queue-Id: E2930180009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754428154-543114
X-HE-Meta: U2FsdGVkX1+uCmwUOME0qHIBea4FFkMbRwmJItq6/9yO/8wtvAiX6mMuzwANIWkrCIVYsJJxAiYjsIP/jPVY47NVik7F2UefIIVEiQxMvTY6o1u2XTN1mh62awEl2NLDu7PMBtPqUL2H7Nri7ZO4gtc3c60FnYlTjG3WVBdnDTno2vAPqEVfJTmc0PekttO096Z0M9OoVjZDcl9XC1qaGWpCsQXxtgpl2aHCBALnNP/+6/LXUBHrOSu/g6dpNI7RIy3RlaHH9BhTQYM6tFwLIFyWXkQUKC03QdCWsF0Y9Q3DdlD02pQrc4DwJLYHH60reOTVqAYx4/DgT2rmbJkhvJGhEuu5SX4/KGHlMbtMRuzCO3nNAYAQ7wZXHcaiZ2e1J6X7SfZZs9miTPzH4r0N73oB+jDyncRtId6+CwGvgqDcbGPRVwl0thCaKz19MJZ4Xhj7SSCoFHqUlFvt1vcvyeSOJyN9TMYrC5weyB2DZsqSOzGgNRj21FyPsiorE1UB8/lq4VtHaInKgvYoF/ryAnDspBRLIWllMvdSlXzMhsotqVnCPZFuj5ZtkVSE0UuzIChkxvsKf8c8lE7TrDV/sb9AkR1B53JjiY14sO/riuR7zOBiaNkJa9G3Ezph5uNzvZ7v3l8Lftj+lLMx40ph+vBoDzIh0yFAJtwgY0PhXs5l7ukLb+QJO4cR8UpcwPXZpXDggX2caMWmOn5oXvKfNn9lkN25tTJ8Q742Ou1MyU2TDghcdLBi0rc2d5QtqxW+iJdJSzTLwMXYtIh12yreOFF5PLhJWsOIiN/arE2athWGdn0ASnU0+6xgqlXlqU+geD1FWvpckiHmNgRWfNvC2s/ZEinxSQx8xnnlNSzIUNT0WVaRbbrZmRYFHuVcekY3DasQSllRk/vdjOEQ1WELnf7qXfnVzvv/5P2tSqh4ZJODQsGNsH8NP54OoqLG6Jz5h3c+p8c3VFEwMgzlcNE
 gqOdCtO4
 yu4VdtZ2IvHlPiuz6fsqi30DZjEV/8F1UmwO6v9ZcMpKHxaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 19:12, Juan Yescas wrote:
> On Tue, Aug 5, 2025 at 2:52 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> >
>> > Thanks David for the quick overview.
>> >
>> >> I still have no clue what this patch here tried to solve: it doesn't
>> >> make any sense.
>> >>
>> >
>> > The story started with this out of tree patch that is part of Android.
>> >
>> > https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T/#u
>> >
>> > This patch introduced the __GFP_CMA flag that allocates pages from
>> > MIGRATE_MOVABLE
>> > or MIGRATE_CMA.
>>
>> What kinds of allocations would then use __GFP_CMA?
> 
> The __GFP_CMA allocations are used to allocate userspace anonymous memory. This
> was done initially in the alloc_zeroed_user_highpage_movable()
> function, now it is done
> in vma_alloc_zeroed_movable_folio().

So that means you perceive the risk of anonymous memory being temporarily
pinned and thwarting a alloc_contig_pages() device CMA allocation lower than
for file pages? The pinning can be a gup(), or a compaction migrating the
page, etc...



