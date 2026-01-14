Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B79CD37E27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738A26B00A4; Wed, 14 Jan 2026 08:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6B46B00A7; Wed, 14 Jan 2026 08:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB416B00A8; Wed, 14 Jan 2026 08:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5996B00A4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:02:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0006F1604E3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:02:47 +0000 (UTC)
X-FDA: 84330583974.20.EEB50CF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9194A1C000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:02:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjublQkv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AY93PE7k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjublQkv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AY93PE7k;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768395765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6bMmRw2R7L6Dddrqe3bLvaJdceLum7kKPXQ4mHzLIM=;
	b=mVOq8qPOx4Zxawo3TZi19NAHr4VcqGa3xL9tnS4f1ObKveY3Pv52NqzfsPaOmPgQhaSFLw
	6WDFW9bkuVnEe983vAMzQJFNvaKPxMdTbP99Go/Xc5RfSvbtAwQLAar1ZKaqmqOcLFIeQW
	MUrWZG56TfhEfSGsfObKbXjt4a7XD8k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjublQkv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AY93PE7k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pjublQkv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AY93PE7k;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768395765; a=rsa-sha256;
	cv=none;
	b=ylsJIFtmbUVoGWrtTmKmXdIoJlf+DYeMpv7D1HtZsxjOHaso+5/GNZNUhQdf2k5tqSwVUl
	5mpn7a5A8AIKt8IZnbCTRx03T/9zVAP3/uwLcDMTm9K/BDwjg7FCgP2tRRc4oMAxzC5dCK
	9N1l8Zy5n3sWFmBqludm8bEjZK8pUQ4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92FCA33A8B;
	Wed, 14 Jan 2026 13:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768395763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p6bMmRw2R7L6Dddrqe3bLvaJdceLum7kKPXQ4mHzLIM=;
	b=pjublQkvvHd56C+po15LjZKz3tSPWaIG6u6FAuJn2Uw7HJDGC6kzSbri5uuk0Ewb6k9yRY
	0OYf0AQYAU1pxRUL1VPvC6+7jlIxghz+rQ3e3VDXnqml+aV7BtNKLnxNFQtbDyC6XmbJan
	bpOUL6BawVTR/kYt55faffuAELJNMmM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768395763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p6bMmRw2R7L6Dddrqe3bLvaJdceLum7kKPXQ4mHzLIM=;
	b=AY93PE7kaHfF0U+caDjA65/GPvvbUa5EQ4DPQkAV5vrkbmuHSzOPjRkqH0dEOHh/e8Ep5T
	fiBjP2KgpBO9YeCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768395763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p6bMmRw2R7L6Dddrqe3bLvaJdceLum7kKPXQ4mHzLIM=;
	b=pjublQkvvHd56C+po15LjZKz3tSPWaIG6u6FAuJn2Uw7HJDGC6kzSbri5uuk0Ewb6k9yRY
	0OYf0AQYAU1pxRUL1VPvC6+7jlIxghz+rQ3e3VDXnqml+aV7BtNKLnxNFQtbDyC6XmbJan
	bpOUL6BawVTR/kYt55faffuAELJNMmM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768395763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p6bMmRw2R7L6Dddrqe3bLvaJdceLum7kKPXQ4mHzLIM=;
	b=AY93PE7kaHfF0U+caDjA65/GPvvbUa5EQ4DPQkAV5vrkbmuHSzOPjRkqH0dEOHh/e8Ep5T
	fiBjP2KgpBO9YeCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 618563EA63;
	Wed, 14 Jan 2026 13:02:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gRh7F/OTZ2l5cQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 13:02:43 +0000
Message-ID: <3d05c227-5a3b-44c7-8b1b-e7ac4a003b55@suse.cz>
Date: Wed, 14 Jan 2026 14:02:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/20] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-1-98225cfb50cf@suse.cz>
 <aWWpE-7R1eBF458i@hyeyoo> <6e1f4acd-23f3-4a92-9212-65e11c9a7d1a@suse.cz>
 <aWY7K0SmNsW1O3mv@hyeyoo> <342a2a8f-43ee-4eff-a062-6d325faa8899@suse.cz>
 <aWd6f3jERlrB5yeF@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aWd6f3jERlrB5yeF@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: mcs3hu65dq7r4g5bbe98zf8jt71awb1g
X-Rspamd-Queue-Id: 9194A1C000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768395765-363363
X-HE-Meta: U2FsdGVkX19LVrjs53MqdJ6oBRiQEe7dgG8W0Oyqkt8J1duWUF8QyZEdivxOXQvJ/kzHDIjzvZCK5EHN2MO1T1/UPjWZ6MUF562InhzYtAkxBLu77kyAe/NMAoZncaxra+phzV+8LpjIfPpzZQMRcD7RoNC6P0q0BF1WkV1mDbKiu40X0N34l4Kn/Es71zytFnLQv2st+i8/1/NcWqKfRqL0pV5pnif3Ed4pw3FYERQRHOMb+XvUpbG2lXQHnbQWIaPXLk89I1Ymq+8eg36K2tQvjWrFqyje6a4QQqlRqMmMiocxrh//NRa210LpilXxnpDUzK14psnFVpJArHU8Fhps4WEMrTJr5hdC88NDLdI24cQKKyXo1Esgm8dz+ejrv8tlqefUj0SfBRKG5ZrmPPiXEfBP6yE2wdVgrNq/UfqYuiWXqeN4g5TJ3a/svunc2aW3gHwMpmKEdiROo3MNac81J03zw2VGRlgUttUj9tmRUIajnM/itguDRHMp8Fz5QCE8UQUE1+2T7iW76wGvgzfK4VkuaioEsyEw9MlEPKhgnm088bgg1HFrXNuMWFhPF+yqdTWSlvDUMw2zhWmLrkD7aV7UPDOUPYib5T0Mi0E4ExCb6HHu0Ky1r3vxaWlHO3z8HLtq/AQtsMa8GdJJll6Qzom5XOVojNu9vgpym31XH1qrQgTxbUbFPi/0l73L6LxIJ8/bB1TNIDL3PmRnDu5amKabV9G2T5LRDmCj8ej0Fe5pZ8QuEJ+i01anAPcO2r6m4Ueo2BlNYLEdnArZ0Qz3evzwkKeOwieKG4A1LrOQ6+z5mgEDd5jGHAsvV8dqTILTE0sEGLMrZ7SkvmINGvRvD39kzwCbgWKJyDDJBZMVoGHPwW0DkV5ItPSHNW5pGQ9zBvAx0okqHRo3XaHCnTZL0anz5/gh3iKuTVHiFZV/iD4q2XUeVQ3nk7wsHej58XIB+uZH6A4j2Mo2k6F
 AA8gLAIV
 AMa3uB34zXHW0Jo1CEUjbHYjPEBnhselQcq493hY5NVgn7O9zkaBM0yqCryVe7J+7fFaOPc0dWxTtFtD47RhfUFhwrzQChEtIsWclC2sZwm1Yn7faAvpxfK0yo9TADfilt3DDa4bA9wUfliEeu9g1Vv10ApvDNRRQiB+Q0wuq0EBPfpOrl2O1F7D8P6fSxTsQN4PukOJpyfPwoNweV5euMyc5LyljKQZsKOaEWx55nYA3ejbBBJkEFnHep/XIpANnCu1w6vbxa25l0fltmDKW8MduNZjc97puLUgF5n/vmQlMLcwQ/QHyOCLbqtlg1wWvB/TJPcdqbjKlwcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:14, Harry Yoo wrote:
> For the record, an accurate analysis of the problem (as discussed
> off-list):
> 
> It turns out the object freed by sheaf_flush_unused() was in KASAN
> percpu quarantine list (confirmed by dumping the list) by the time
> __kmem_cache_shutdown() returns an error.
> 
> Quarantined objects are supposed to be flushed by kasan_cache_shutdown(),
> but things go wrong if the rcu callback (rcu_free_sheaf_nobarn()) is
> processed after kasan_cache_shutdown() finishes.
> 
> That's why rcu_barrier() in __kmem_cache_shutdown() didn't help,
> because it's called after kasan_cache_shutdown().
> 
> Calling rcu_barrier() in kvfree_rcu_barrier_on_cache() guarantees
> that it'll be added to the quarantine list before kasan_cache_shutdown()
> is called. So it's a valid fix!

Thanks a lot! Will incorporate to commit log.
This being KASAN-only means further reducing the urgency.

