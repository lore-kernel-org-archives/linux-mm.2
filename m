Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB31CF65D3
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB066B0088; Mon, 26 Jan 2026 05:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578BE6B0089; Mon, 26 Jan 2026 05:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430DC6B008A; Mon, 26 Jan 2026 05:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319AC6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:25:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D49DA1B0796
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:25:55 +0000 (UTC)
X-FDA: 84373734270.05.364917E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50DF11C0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:25:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="VJeg+/aK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3+uD1OrF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="VJeg+/aK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3+uD1OrF;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769423153; a=rsa-sha256;
	cv=none;
	b=khWa2hQFzTllGBIwUUvB3gLiT1wumw0vAAhgx6fZoWthlgYYCYtc3uYtuE3fD80d+TGWF8
	7+r6g2MhwkCetbmw3Bh9dDAb331wlDRHXXE4CaA4iPPwkunh+4GOPQXxB7ztBlXeiY3fgK
	FuCHWrBfSYRutPQsonsyv1X25Oc74jY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="VJeg+/aK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3+uD1OrF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="VJeg+/aK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3+uD1OrF;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769423153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrreC9Aa5mIt2Nw/HfIy8WgG30xAVRkrNKue5+B5Jms=;
	b=0pG9YMZVKZWeMJcZQ03ppGkCS4eQF/bGPlQHuY7s++EAM5Hv0ldJzyW4PlYyQzbvpruv6i
	idNUqa1NvFimr4AVbyDspJMl/4vQAKwbfgm+llp/COd4s2VP6nydPOLaNwMU8k7umPXUVV
	uMMrrFDcL90lIS2v5F3blkB/Af/oXDk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B45F53374C;
	Mon, 26 Jan 2026 10:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769423151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WrreC9Aa5mIt2Nw/HfIy8WgG30xAVRkrNKue5+B5Jms=;
	b=VJeg+/aKqOZomXAACB9FUDzVrm/k1watp+pan1kzkKzwTgL7T8MnhMR0KQxGIiOHA2x60B
	yR5S6lDRIognyjJcYB5ijRyxVZgaUA5xZS1EoJq/c5KxhfVVCID/vvZ9ILNxNjAYHIu7+E
	8NuHam5+qGq/9AavrHwThdf3Kugen2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769423151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WrreC9Aa5mIt2Nw/HfIy8WgG30xAVRkrNKue5+B5Jms=;
	b=3+uD1OrF35UP1NRW5WQBG8WdSsgjQQ5GqI4OGmt5rPzle1nHmGae6EOAG9QdNljsgDFfXW
	pKDy6tjqKUK9cxAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769423151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WrreC9Aa5mIt2Nw/HfIy8WgG30xAVRkrNKue5+B5Jms=;
	b=VJeg+/aKqOZomXAACB9FUDzVrm/k1watp+pan1kzkKzwTgL7T8MnhMR0KQxGIiOHA2x60B
	yR5S6lDRIognyjJcYB5ijRyxVZgaUA5xZS1EoJq/c5KxhfVVCID/vvZ9ILNxNjAYHIu7+E
	8NuHam5+qGq/9AavrHwThdf3Kugen2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769423151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WrreC9Aa5mIt2Nw/HfIy8WgG30xAVRkrNKue5+B5Jms=;
	b=3+uD1OrF35UP1NRW5WQBG8WdSsgjQQ5GqI4OGmt5rPzle1nHmGae6EOAG9QdNljsgDFfXW
	pKDy6tjqKUK9cxAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83852139F0;
	Mon, 26 Jan 2026 10:25:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fHTIHy9Bd2kiGAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 10:25:51 +0000
Message-ID: <a71b7529-bf1b-477b-8e66-644f38b0c32d@suse.cz>
Date: Mon, 26 Jan 2026 11:25:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/10] mm/vma: clean up __vma_enter/exit_locked()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 50DF11C0002
X-Stat-Signature: aq4tomtezbd5nrac4xawf5q6irmfpsh1
X-HE-Tag: 1769423153-157635
X-HE-Meta: U2FsdGVkX183vnSLsykL7cFYK1FMh6JHJmCaKNd1i/P5aGzNu+qtaGobmdV7R1CgtY7imgEgYqY/c5IOJhDOIIZ/hk45DZauRg5V2UdKNenV1QezP6AbNBLrfqcBWqvMBNPuhNHIbl5pRzr4hePU3cC7/8lJtdu39mhmEpVeN00ZFLruD9UtsSpRsKCvDD2xrCHsGD+g+iu5H9xj36QI7NvagNe5B/g50HA0NmYXtlQBmzUYoRUdnrWc/GS0JqNmNj7TEBSEhClAfCJjkbeGJmYdJiCGf5LEGzNFOXgj1+mKLRIqSW6N/v+rZ4GfZ5U/Va/6RHhn75EBIXRYAugXqGviZzMn55rBNelAPOR7lnGb5Owci1MCtXbtgftcOD4daezn819GQVtuCaDTR+0mpKivQopc3q48/ydYOzCt7muzrdikjlpaXjqDBlXCfOmnQDXkXY6H1V2C+PKDk/IeBpxtLRZnL3U8YofjwtSy/nzRlnXYC5LP8jUi12XqFGG3jlRxa/QfWEaevb3YsBNvXKxPnB1PQOA7lVeS6aSEq5Nc1QvS/ln9w41OS4xTHnWjHQUrsOqPzTMqlcRX6ixZbyHMapH1SxmupeD9hinldOgHObM5A4L7spbfuZpaoEund2O9ZgFVJtlNURY82jQ4LMLSCInk0xpFuw3b7arxbBdzQ34Fcyloh5OkZE98g45gFFkmgbaXuy6tl+/eZ/1OLwVbveUSRSdoY46un+wx4GJx1kROhskq7jT//ffOU04lZgN9kRVUhShK+VPvQKe1u7shCaSKpMUfJUGyLM5zQO3nxToxTzVlHKEnT94m2dHR2PTyrKULGXicGNN5dDqtRcu8ae/OznFgu4E6ieMncC4CVc35nvYdx2ohBsC8DwYm6pbFINYTczm2U/xRmRbbuciHbIznffriOF/CTXp/TzJWMIoYFErTdvrVeXY1uZQQEyXpR98PrNJD5mdSWg6
 SJyKxDn5
 eWDtrVu7K4j7y6wD8nhzKk9+a3Gas4TxXTxq+8wzOlBiDVIFRs3B8dKXTjt20CR5PkvY4T2XW00DUM0k+sYdDcG6CHntTXnkMckEulZeshTjPeOnHo9KmrWB1g6N/urSCkAX/Sg5uYIT0oMVQMMOER9a8DvNBxavKmSHixi/+z2o9WrdsuQlrMMT4ulPk3Q5qCseR+ASoqD9p5pvbTQvZN+hTntvBk3ZR0FUOkTGL3uRuhbdgK2IN+1+rp6TTFwWg8VBDoIYheIZXkBK1OxcQ3hEozBSsX3f1fFSRBCxzKdoM1e/YgRGDUOlnVbUU2KCCfIiy1D2fmWM0JuN9pQzkBx8dcXIrCKlOsgxrID3C2NOGgPlNlnBUSJtyTlCWiAbX9r3OPZ0Zm7Wcqu/5XQWOIvjN0G/UCoUqapEP7znCwopsGKQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 21:12, Lorenzo Stoakes wrote:
> These functions are very confusing indeed. 'Entering' a lock could be
> interpreted as acquiring it, but this is not what these functions are
> interacting with.
> 
> Equally they don't indicate at all what kind of lock we are 'entering' or
> 'exiting'. Finally they are misleading as we invoke these functions when we
> already hold a write lock to detach a VMA.
> 
> These functions are explicitly simply 'entering' and 'exiting' a state in
> which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> as being write-locked, or mark the VMA detached.
> 
> Rename the functions accordingly, and also update
> __vma_end_exclude_readers() to return detached state with a __must_check
> directive, as it is simply clumsy to pass an output pointer here to
> detached state and inconsistent vs. __vma_start_exclude_readers().
> 
> Finally, remove the unnecessary 'inline' directives.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


