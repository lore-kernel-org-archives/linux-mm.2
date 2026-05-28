Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB66CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBE76B00A6; Thu, 28 May 2026 05:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC856B00A8; Thu, 28 May 2026 05:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2906B00A9; Thu, 28 May 2026 05:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC1DD6B00A6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:55:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 996391C1FB4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:27 +0000 (UTC)
X-FDA: 84816371094.01.94F9C45
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7BE45140008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BF5pBjQa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gtEmH9yd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfkimMzQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eWcZZWs8;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=PeZkIv9upeWL18vuOeMti++6lWq0EVcszlAP1UZWsc4zts4cM56FyyfOwr5T/usp9xtyGi
	5O751OQIVm/vqdSANqO1DakeF8V5Ms+E8c0i1dH5/cRIckC2/ykrFPX0QusCaZBhXzf2iD
	HMO1u0RGAhMSxajNFH1jCBcuOqwC6F4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BF5pBjQa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gtEmH9yd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfkimMzQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eWcZZWs8;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779962125; a=rsa-sha256;
	cv=none;
	b=bxghMzVlKNA17exc5LSzHiXyRifDHUIBqpp2HD1JjuJC6oRbQebQggZOI5c/PmQ1onr+FM
	SQXRhPs8DmjMRmG6kWOc6WieAlVsKkra73esrJ8V8rCrHa/NqJACuw2WQ+U9xESQzBzUGb
	4fGryNIqrndYqfGKqRCWu7nks/vCxDM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD9066B13A;
	Thu, 28 May 2026 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779962124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=BF5pBjQaCl2e1Rm8D+C+apxY1lOd/N58rwkBf5jv/216FwXdroWEjeZmPLmTKojKt3eR2Z
	aydpArZ5tRp7vUT35rbUO+WTXFRT4xhMoDDHvbt//K6lb2TR+MHyIRb2NNeN/quBM4Vnrg
	pA3CrFpw3LlKVYqN4tzENaUpeXCo43I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779962124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=gtEmH9yd1llte+EHO3fqErzp7rmioNwyJsOMXvUqMC9+eppCro3Z+06jCWPXGpxvqOBXVF
	rH2itovxFNZ8p4Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779962123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=MfkimMzQMNvrw+Vgdg0ivpq8Gmkgeg9Q6Q1uMy5Zz9SBJSnl50fuDbaSqCL2pfY0V5hr0I
	9sVOzn9fe4yl2EpWD+4MbJI8cUJ2PNJdscx7Z6snLamed1dLvau5xSndCxLYkdpLshf5v1
	2wghgXxixlMhg0rJr2HC/EBVEOmJ/e8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779962123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=eWcZZWs82aMKWWk3/yQ8+ZvriQyMgUB26C/K88sIBhrDvCqJCuCjZiX/bJYBu0L8w2LDJX
	JtV9oK3q3wOlGRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA0F55AD12;
	Thu, 28 May 2026 09:55:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0sLaKAsRGGq/YgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 28 May 2026 09:55:23 +0000
Message-ID: <9e491e1f-b544-4cbc-9319-8f75cf0b2130@suse.de>
Date: Thu, 28 May 2026 11:55:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>,
 Song Liu <song@kernel.org>, Xiao Ni <xiao@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
 <20260528-lib-v4-1-4e3ad1277279@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: s16hmsh114ptdi8o5bjmnynq7hbj7xd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BE45140008
X-HE-Tag: 1779962125-72431
X-HE-Meta: U2FsdGVkX187rEXiYSqGqdapgl8ZgVqpVAQFjwE2Vou/tP6bStStoZBYwucMj3QLIGiRFtAsmHAoyINJTUXKb70QJieoPDwgrEYunU2+RbpfxlELmcMQAK8o3jgpAWcco1K/H6M6LVjS+kLiYalsURvIMzsQA2hL3aIueTV1glUUyAHZltYtnm5ISzcR3/uIGzk59GgMBhjTvxLDDDmcPrBuvN8lbdEMt9t1aOeOwI9BYJ7TCcFhV65jXc54O1IgCexhlEj4SEwdL2GL4hUykWa7j9HjO0JlxiCNgbx9DjEbE8s9x+4+bYQ1PoF0IRH9sDHY+JAKVfQtblW7zcuH9a5UCOojCxx0S2VoQhr6Xk/y7/5xQy1hTu4ALMsg7NdC7UmS8By3cM89sSyjYD95rZKFxWIvpRV4irnNQtUpFZ12cHm/QDTjtPlRZ0+3ULWOOAPAqQ548yNVerCvRP280Q9A+aS3N0meKaOrhNkythKZxqv9WV/22rpSqKJttVdNYyESSE7GrnA4EsBQuP2zjo6DIQXmgFPqaEu/VbT4YnpSrWHLhmtpU+RFiCbQIoyuq0ys+S4Ewd7kj0zSgXRRAcACUjv29Ooiwe+oHt2ReO6AO658Wlv1j4/+XL8q8YxlSUE47MzHMNhJECR0fdzfSApwfG1ScaG4snYjaeU8zRFmZorQtFK3vMw2Je1wV5L8/POJBycL3FeD1iqKnA0Wvxo4lEk1QtimwMuZ2Wepl8xZETXJ0a7vRdyt7jinQV/UVANf6VbfRlGTqvpaxRpUooWVRv72ouNzSKLk9ePXO4cZX7C6Htuur0SYrNxgkV1cf+n533QZobAWBvZj52Y1OLtkxssg96S4od2+tGUz5MlKBQEZOTVOIf88re4dHIL57lcS0d1FLTI0kWN2XjYWyFUygwO+UsDK387r4yOabHSuh0zf2l9enJeGgJbhGqWD8NSMhoYUkbMCYoFEhix
 sICxFOZg
 kj2yIl6ecHZCdbCA4COpKbH4IgQOtSp76QLJTXfVDaYUqhCKreHRQyDFqPpYi9PFZxXOe4aAHt0pa3oBjLN8dOFfjSxbcT5Xpi3SeCL0C7i6EpGZwNhY+mwzix70W0MafqGTXBYAbd4POZ1ZdUcEoGjx6Rr3vnr2ScrIaa4QpCkJCUPqb+Nqe0Pxq4W+t2yhkgQcWO9JFTCyWGCR4XtzhizAKJBteIqRRdXvRmcKnAexmpj3I6CX79xpC1zHrFT5Z4rZ6SmCpFynIAxFAN66OpHtEHcqKCWfhoJneExf7YFtCCGhFtcwZNHmS8GA4GMf8UGNCLoz7c1YyIJ+yYEArVBti0gDCojSprxD8UAH0/nTevBku25Y7z+RpelkUl6HLGl47Y4d4ohTDel2tAk8ps8KisKFUQ2EwWC/Xc2HnLB+h7cENplEBP5XJpZL80j+cvHSpiJA2YwrVRIN9eFZYJ/xDWvVEdu8S4AVG86/p+9nxx72XeLvb5lBjdyASQs22+wH93XI/u6U3YccvMrwMbA8U3sKmR+nRc1au
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 11:53, Mike Rapoport (Microsoft) wrote:
> The xor benchmark allocates 4 pages for a scratch buffer that is used
> purely as a CPU-only XOR working area.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API than ancient __get_free_pages().
> kmalloc() does not require ugly casts and kfree() does not need to know the
> size of the freed object.
> 
> There is no performance difference because kmalloc() redirects allocations
> of such size to the page allocator.
> 
> Replace __get_free_pages() call with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   lib/raid/xor/xor-core.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

