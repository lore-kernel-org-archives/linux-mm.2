Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1635CF8855
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C326B0006; Thu, 20 Nov 2025 07:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35906B0031; Thu, 20 Nov 2025 07:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24316B0032; Thu, 20 Nov 2025 07:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFFC16B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:58:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D16C5B764
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:58:07 +0000 (UTC)
X-FDA: 84130988214.02.A271089
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0964A8001B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:58:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPz2W4il;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ti84snLw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPz2W4il;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ti84snLw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763643485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBU/AsUgcSzrIfqjUnDEsEXZDEFHybM/XjPFqhqGKmE=;
	b=E+jNaLMVc4TlpjPq2otzReejXf9HE1lxe6n+WL3ljz8ben4ayOhOhJNimptHKubDdnfJoA
	vj3qn82oaixptiirkHQq1XgwJ5de0MRrk0HEtt7+vhgE3Hxp1b57XnvhmJuHzsq8v395ox
	weCTsvlfW7Ynknpiq4rg+9fVW86CcJ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPz2W4il;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ti84snLw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPz2W4il;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ti84snLw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763643485; a=rsa-sha256;
	cv=none;
	b=l01a18OJ269JXwfgSfjC/zOkAoiFrqXfDvYA9Ovlrabay8lAiCtf64PR9f479EpYIcNXQx
	GQw9zC2QDyQdxIH/44rwMKg00WykdG+HUWUTkFHVFx7+XL2wPBKrF98X5djAy6RXy3u3pu
	e6E/+0IeIoQ45pijBg/iFcH/jYZQSrk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1626520A2E;
	Thu, 20 Nov 2025 12:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763643483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZBU/AsUgcSzrIfqjUnDEsEXZDEFHybM/XjPFqhqGKmE=;
	b=KPz2W4ilySLGgjTbe6p35SMCJKelGbG6GBdPFSbHc+sSyLEjwuLRXgphB4eqYoOJ7IUIGT
	PPj4PcpDzhqRL0LFrorj2xyBulwKxBBCNEatJ4DVRI/Qajlcp4IWrMaXpgbikiXD9VhTO4
	gMBDSGxgdOqbyifNDz6nAQgwr2Gcmvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763643483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZBU/AsUgcSzrIfqjUnDEsEXZDEFHybM/XjPFqhqGKmE=;
	b=ti84snLwzX57cCkc4wju2PuJrWjzezZ2kGAbAfrZb1AK2dHi/u6g+bQI5NFupIJlR1VC1T
	88Vv2zwHxVR9cUBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763643483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZBU/AsUgcSzrIfqjUnDEsEXZDEFHybM/XjPFqhqGKmE=;
	b=KPz2W4ilySLGgjTbe6p35SMCJKelGbG6GBdPFSbHc+sSyLEjwuLRXgphB4eqYoOJ7IUIGT
	PPj4PcpDzhqRL0LFrorj2xyBulwKxBBCNEatJ4DVRI/Qajlcp4IWrMaXpgbikiXD9VhTO4
	gMBDSGxgdOqbyifNDz6nAQgwr2Gcmvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763643483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZBU/AsUgcSzrIfqjUnDEsEXZDEFHybM/XjPFqhqGKmE=;
	b=ti84snLwzX57cCkc4wju2PuJrWjzezZ2kGAbAfrZb1AK2dHi/u6g+bQI5NFupIJlR1VC1T
	88Vv2zwHxVR9cUBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDD303EA61;
	Thu, 20 Nov 2025 12:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T1iyOVoQH2mCbgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 20 Nov 2025 12:58:02 +0000
Message-ID: <7ffb1908-464a-4158-8712-7735100ae630@suse.cz>
Date: Thu, 20 Nov 2025 13:58:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mempool] 022e94e2c3:
 BUG:KASAN:double-free_in_mempool_free
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Christoph Hellwig <hch@lst.de>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
References: <202511201309.55538605-lkp@intel.com>
 <20251120072726.GA31171@lst.de>
 <9e066a2f-28fd-4da7-bca8-c10f7b58f811@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <9e066a2f-28fd-4da7-bca8-c10f7b58f811@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0964A8001B
X-Stat-Signature: agsxnb8hhems7esja97kdq6kxwrnq1dw
X-Rspam-User: 
X-HE-Tag: 1763643484-816478
X-HE-Meta: U2FsdGVkX1/hB9Uezr+/D3eLfoQTqVF9VBwHlSSl09K69rflG6iTiLLwkFF/G/L6Gu+v9iYPzLMvLg2Y1ntUQYOsReXM34r1s2lZLcXQ+hRwft0ML/pRBAC2uHeG/YlhizrMQJNFhT93kgpcmCZP64nWS4JmSWS+T+TlPRIdBY78C1RwoXBds/NJN8ArLkFpsYITZ1rW53KX66LANvamhmLfS7vX/CbI2CNMATS/jG04nlv4Lr9hnVFo25qbr5wr+F6zTuAQBN4uXvHYhDXUDllPFuSziMkRSpE34qbTxwEjbIC8veJoD2Ul36SjTNLGezFcx6WblCCXZeCUlIe4SJwnb+rPcIPwwFTTOG8V+atuK8ZgUbT+TkBHKXUKL7pZB9MlvwfOYbIUJQnYgZ9plyj8XPWZmDlBgkAuaqCJeFP2QJNJU7bLLvwuT8Jpxh3rn44PEHJWg4+t3J1SGIw3nnXnE8QcOlVGrSFtvAtPqtoEurwTATG7XrMGbyjZ2M+EoDZmM9tPixv+H79nlWC+QyzbcKPJT2l/TTIWJxj6WkLb6FMQk/VGNIJhiskPVMh4Kd7c0vcxAjCJTtvEc5TU+Chu/YsTuywC3gCMTLLZm9JWRe/5nARKfZH25qk12JeGRNITCNE3r2jJvAsb0xVpDGfgnSDCLL98dyaSoyKyhAC5V28dntE714xazXWlOojMErAfJXbzK3VW8KEHztRghP76d1O+m3N/SKQcXRU0XAkLs2nV14GLOFiF1WbwXes/MHFOGkxBYZnP/z0zuZyScb87ydtIZfUrPVJBe2VcN1Df51rdIYcb/sNsTHTx6EzjyyTP+N2+SzDJblLnUjQ71y3MPuFwckVvOZ1b1cljMsD8ksQPcBx/ulDgeG0ioZPGRROWUfVLxUKwuC+tVAT5h4OmQtp67G7ukRMmWOajTJOG0GbH9mLpUeETYjUfS5OIDL4PHJi5NpFhhJo3mTB
 jaX488Pq
 sk2bD0vDP8FcvTTu/jWlOhcM/Nio2bLgaphINSdrF0rtV3OLrYW7d2MWeF26viy+Zl0nQ3P3LtckhIDi2MJGdoCG1eH4w6waxeELybLBWWHs3jpg3cJCr9HRorawC8b+OHqGfSpgMd/IsrTIF4i6NyiMETQ/cwTo4x56r3vd9MOZgTd/EfKX6nFurR4Jf9VQuhhcN2t+TUgHWa5bFAVJE3u2IsW1gNsLut4AO7ynXbIxuDtb3vkTramSbBGSERUl3cbLsn6YzyxFrEMvL5Bi2rLzy9tHqc4aGxoBgAXTtLUieaGN2FDtuqV9MMPy8lU3MvTwWgo3raoNkFBoV/G3wzM7oQiTygA6vJZUijbWXBWuyf4OGoXJ07xbF0bFxQPl9Aws3QO8BaltMwnJWTC8/mdklvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 12:17, Andrey Ryabinin wrote:
> 
> 
> On 11/20/25 8:27 AM, Christoph Hellwig wrote:
>> Maybe I'm misunderstanding the trace, but AFAICS this comes from
>> the KASAN kunit test that injects a double free, and the trace
>> shows that KASAN indeed detected the double free and everything is
>> fine.  Or did I misunderstand the report?
>> 
> 
> Right, the report comes from the test, so it's expected behavior.

I assume the bot was filtering those, but the changed stacktrace (now
including the new mempool_free_bulk()) now looks new and the filter needs
updating?

