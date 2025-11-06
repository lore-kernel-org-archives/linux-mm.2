Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A316ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7278E001C; Thu,  6 Nov 2025 10:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EBB8E0013; Thu,  6 Nov 2025 10:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DE88E001C; Thu,  6 Nov 2025 10:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7E558E0013
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:09:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71AB01A0127
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:09:18 +0000 (UTC)
X-FDA: 84080515596.03.3431EE3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id DCE19180013
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:09:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m7MMjd1G;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JmJMCiB5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ABpgyi+n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gQkYWHBI;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCE6f76rkg2/aR1Wph91+yp6JG5AubzQX1uMuOHHqWo=;
	b=Cq96Ty/s2ro/bBMozqJjSkO1aibYeyq9x+z/beOkerKqHUgAqr1SMhNpZQ8RfXqX6hYaHI
	ErcdWAA2+pfph0J8UssoMo5bqwSiGm7Q1sgRh6x+5rsTYEz/7p0uiGWDNQfJ36H894STBO
	2arbF8ZUP225v0cEvvGmwq3gKVCbR0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441756; a=rsa-sha256;
	cv=none;
	b=HhAEhWqL/9JVHIlKId0glVbz2QJIdCbymlO7ti7NYeESZXHayp41Q23FP1AjAILr31ZVjs
	f02/uAYtsxi7XlW+Rw5Apeqy+vT2+u0RUS7c8xSHQA++BUaOSB3doy9jq3Vqu5IA0+uFqo
	yAliT9GBXufjjGmFjcakCW371qTpPNA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m7MMjd1G;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JmJMCiB5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ABpgyi+n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gQkYWHBI;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CFA3B1F747;
	Thu,  6 Nov 2025 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762441754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kCE6f76rkg2/aR1Wph91+yp6JG5AubzQX1uMuOHHqWo=;
	b=m7MMjd1GCA5PZpL6wkokDhsPwPsim7/KJYP3C5yCAw3QSTPIGxYEVLwBmiZtTV4FLHSsVW
	MXplXZSm8SRaqcvXQKaAZuTzWt8WkpYnNIuGAntNpHH/iFmGvAb80BsBBRWqIzVF8L2Evx
	HDUgiwrkv2KMZ84URpiiIHwR6ZLF3S0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762441754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kCE6f76rkg2/aR1Wph91+yp6JG5AubzQX1uMuOHHqWo=;
	b=JmJMCiB5Yi1XC73GaNiuyz09QoY4nhy7pzfmfOrxeDH341kWBksAKx56Sm7zB1zX9UblaN
	y4kSHczL+vHuBVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762441753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kCE6f76rkg2/aR1Wph91+yp6JG5AubzQX1uMuOHHqWo=;
	b=ABpgyi+nopb1SONyLKRVik+zSoaBgoIxIqK0EVsD4avvliGVpGEk2HU0Kf+HomZvi3X5O7
	ieNFADEeuC1jEofW4VC+XLq0RDWO4Pb3mCbRo6OKb8TrmfzvChjCbQXt6cHdVxvPBNTBql
	lKeX3lUvDFXZMFQPtn8U5rMELuZCYhI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762441753;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kCE6f76rkg2/aR1Wph91+yp6JG5AubzQX1uMuOHHqWo=;
	b=gQkYWHBI2LO7mwYSfSUn+hJihak7Ek9I18WNlXYToD+SwW8MWteRnwBo7PHHWcITTZYCHp
	z57CfpurcT6giyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B041B139A9;
	Thu,  6 Nov 2025 15:09:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ILu3Khm6DGlObQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 15:09:13 +0000
Message-ID: <6dfd365d-e827-4f7b-b2eb-92a227d2c0e6@suse.cz>
Date: Thu, 6 Nov 2025 16:09:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-4-hch@lst.de>
 <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz>
 <20251106141306.GA12043@lst.de>
 <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz>
 <20251106144846.GA15119@lst.de>
 <f933b80c-0170-4c0c-bf91-7c862127e96d@suse.cz>
 <20251106150049.GA16252@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251106150049.GA16252@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: dytwzg8jno3epp5ehgoanx3awokbxzur
X-Rspam-User: 
X-Rspamd-Queue-Id: DCE19180013
X-Rspamd-Server: rspam10
X-HE-Tag: 1762441755-903265
X-HE-Meta: U2FsdGVkX18YaOYlB7nPoeJ9380cJdz+CdNxZfBa/YTyOJWHtwft+Tl9ayILk2Mc9R3VtD9i9S26VOH9xlgLgfQOU5T4wjx9Bwpxpc7mKDnu5hJZsWhsFH1RJ3LMGq4mttwYgXICNm1aLuKXiihPFAg5+Gae7Bl97qElbt36qShY1tv0WOPVoPQPWWDMH5MyTiU4f3IciyySEbFL27SvfXoeT8RFKqTsuiY+pydzxhJPqSbo0cKutcUNsiVuu4fvF65DRSalPdLCyxFlLQyqVRPqrV3xo9/39KU/kWEG9dWkP+3CNR+e1qW5CFztWJW9BfxPJ8X3SMmyBHy+XnVmvjKzPMOuZc6oel5loGhLQQiAdpDwMlZxKLGEHnKLD2cxJ+C9zm6NQ5eLZ8opM8SUUiQD+7JJ69ieHHjnMy2yGnhF8FNXlPSGx2itePRTrnWkMcetvb6mCxe46VTv/LN7dIjfTTSnCcu2kX5uNDmdAFCQdbXiFSDgZp2OAB+vp1HeKRDe65KeZDJDOyy+h7e5gFm0v3Lz4AH9kPquAujhSfS7dNRY485g/JtNm3o/Z8sAyrGor26bxXLbRvxMsGA93A6Dikh2emaWPKjbbTv4Lfdzd/NDe/mSgjwuYqI01bCQIfNijX11sVkGapKFMF4UBSLxfB1Dp0KoSdm5rlJqyhsLRIwkKzHlOYkKRoj1T0SQ2VMNna5TUyPHHBxSK0JcByvXmat3jvTXRz04RkCoXW3nj5asthzr4u/20iHtSuL4+d4Z5QZJZgr8T6Pr0z/9x3+uboAtTdA6Jglc/7g3+jjY6qxuBa8zLeTibPzPRud8GqbPtscHbtHv2ClhfOAsd1Mjr5uK0fE7qlmtRAJbziXw4v6wP+Ow302MuEbi5oxKyU+Lo9fjPMspBTxAJbMlKw3p6AKhBmGCDQg+C5mUB4XW+te1FaCIeLIS0ej2b+9O2tqmR3HK/bkqtp0snHu
 SPrWgzmM
 SMrkgtxtM/ZLWMaBAoeTr6RVS5MgsIlSLfmd5EEpTQg2jLdeq8ZtuEB/yzj45qo/Cq2OUWS6yUNz0y7vEX3g2q7ryfBuzqDJt3/4eKKwkgrS7qKQpeXYkyED9yZaa4xkkAD8g8pfUvE4rWZVDWwip1FVa3PMrVmb9zC8V5ZogT4TOsGZa/eShm07xyXdI9kYXl0yP+BGu/qgPH7RFzzHuOUgATYcghAiJ+QgEf60C/bVnyXyIQDYKRHoGFUl9c4WJYfdybFKGNGsvPnCnCzS7WgUSv8OGpxSC2KHTSOaGSf9enfMmxTi4hfme5P5kLbsUGvFImsKjDDDgyhUHanLqLZ+sk8JvlpUBoOvowVVviGgur6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 16:00, Christoph Hellwig wrote:
> On Thu, Nov 06, 2025 at 03:57:13PM +0100, Vlastimil Babka wrote:
>> > I think the only reason mempool_alloc even allows !__GFP_DIRECT_RECLAIM
>> > is to avoid special casing that in callers that have a non-constant
>> > gfp mask.  So maybe the best thing would be to never actually go to
>> > the pool for them and just give up if alloc_fn fails?
>> 
>> Yeah, but I guess we could keep trying the pool for the single allocation
>> case as that's simple enough, just not for the bulk.
> 
> Doing that will be quite a bit more complicated I think.  And given
> that the !__GFP_DIRECT_RECLAIM handlers must be able to handle failure
> I'm also not sure that using the pool is all that useful.

Fine, as long as we don't break some existing users that became dependent on
it in some way.


