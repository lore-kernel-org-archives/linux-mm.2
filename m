Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EFACD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB718E0020; Wed, 12 Nov 2025 10:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3068E0002; Wed, 12 Nov 2025 10:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A968E0020; Wed, 12 Nov 2025 10:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E27A68E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:57:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95EAB16059A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:57:47 +0000 (UTC)
X-FDA: 84102410574.20.E5947B8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4768A40011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:57:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6ZcofAf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fteLK/xn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6ZcofAf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fteLK/xn";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762963065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fy4ID+S4/SX6mxpVfENndsdMlaf45bnvKyDiWnu9Ecs=;
	b=hWmptEwYPQBT7RScIIpWo4xumtQ2+00yyiw1qOLNJwpmlcLLpGgRTf/KMGhe5akcDiXn95
	uC15VQzSuf3Lcm/5ffFAS7muybxJGpRYWcipZ+hToaeG2KmHnfjCJjQhUhJOmJV2sbr4Y+
	pkr0lB8mvDIK6MpX6Iuk9S3oOt8KYc8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6ZcofAf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fteLK/xn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K6ZcofAf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fteLK/xn";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762963065; a=rsa-sha256;
	cv=none;
	b=4dSGspCltCoP01ZfCIcbZgXR9zlK1vfbb0kio/g0DjwKzdcC+W7izP3KG/R8i6KkRG5Boa
	yak+WwxtSjlw0ayq7wDtx+MRWbsNPgyk2+VxExmJimW6t97iqICMay+oRrc+9ItbeGpdCC
	7D3Rvxy59IQEAetHJ9IgfjJXiZcqqeA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE92521B05;
	Wed, 12 Nov 2025 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762963063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fy4ID+S4/SX6mxpVfENndsdMlaf45bnvKyDiWnu9Ecs=;
	b=K6ZcofAfS8Szx5muLFtT9p7+ZC3eIi+MtePof+v71M0Ap14e+7NYLoQI4mi33Jflv0/IlE
	p81a50jOVRfx17IeSxSSqxsc9LTbO6oXAE0RrmbMW1yk/yGvHzwQRxS2nsm7eetqMxISdC
	7cR7EzqN153hYcxfyA1qhJ73c7UmxW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762963063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fy4ID+S4/SX6mxpVfENndsdMlaf45bnvKyDiWnu9Ecs=;
	b=fteLK/xnXRGpgrdpL1xWgUZiouiGEqxkew0oyqngGT7AXujaOvvgl8Fkheb2hqYBqRUhOw
	JEjGbN+GSor78qBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762963063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fy4ID+S4/SX6mxpVfENndsdMlaf45bnvKyDiWnu9Ecs=;
	b=K6ZcofAfS8Szx5muLFtT9p7+ZC3eIi+MtePof+v71M0Ap14e+7NYLoQI4mi33Jflv0/IlE
	p81a50jOVRfx17IeSxSSqxsc9LTbO6oXAE0RrmbMW1yk/yGvHzwQRxS2nsm7eetqMxISdC
	7cR7EzqN153hYcxfyA1qhJ73c7UmxW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762963063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fy4ID+S4/SX6mxpVfENndsdMlaf45bnvKyDiWnu9Ecs=;
	b=fteLK/xnXRGpgrdpL1xWgUZiouiGEqxkew0oyqngGT7AXujaOvvgl8Fkheb2hqYBqRUhOw
	JEjGbN+GSor78qBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 997473EA61;
	Wed, 12 Nov 2025 15:57:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WgcaJXeuFGmmDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 15:57:43 +0000
Message-ID: <454da918-bb53-410e-8046-49ffded8e5df@suse.cz>
Date: Wed, 12 Nov 2025 16:57:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mempool_alloc_bulk and various mempool improvements
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251111135300.752962-1-hch@lst.de>
 <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz> <20251112155011.GC7209@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251112155011.GC7209@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4768A40011
X-Stat-Signature: ho1niwb9tft6fmpgy79hdhi3z9t5xjwk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762963065-118784
X-HE-Meta: U2FsdGVkX1/lYZK3NoAj70O9ECEz8YQQuBXGyKuoFH/EBAC/+bj2ygCuduoOpTruoG+KCfyeJvfNp9upDUdwCp/9mPWP4Cj3yMWD1EjluZVsLjHIYKA+WWvtCp3Bn79P2CFfPIAu1EDMjC3ZbP0RRkfvgbyD2mERQ3ML6MlkW4UHMmLBRo8Izuexkl74wwSzfp4yZYeG9DPE7iBrgJ9H9LWPf4YDcgEFgrR1EcnrSZrCPCHQPjNcadrbXyX/Y+C4/IXCG7TnhQzABRGqnwwBa3mqV34yjFlQsLL3pdkY6ZF+kpoKwkgh3yGjEXqO20bSDKkFwJYmPHf7wyWcpZ4dQoV76pg274Dg6g+gbaZjoV+rZpUpZ8+kbnUIYiV+bxBJOaxIdHBK5bsRq4xbBn4nnOyIzCZkbWUAUI1DxsKjZrg1hU0PQsKYKatdLn3vf8bv88yMQbn49o0lkM1iWLOGnhzJ3i2S73or0iuqJa/dU+lFnt3oaPSyjrKFCQUgCj5OFCXBTSSBo/V3Gu+L1YT1VcSkpDmU/uqgurcGz1SLNtpPcezLG3rfr+B9QdlhmdO5AqDJev8QgKDRlGxmitZ4OBgmEdeZ8NZU0aMwJgAuUru30A59GHC/RDBnm0jEgMgKYumtPOBZLocFHPQptGOsJs1yRr6viwpMi9YHxhP93+vwQ4kP/gHpgbYuASEm1c6Nlv+rNPKNz2fOIFe+Xg2l6KHB8rNvCG+nm5hSxdvRQ694j9EkTJ/nV4QrTmhZAGfL+ZtUM8cZ08PZ5AnVT156Kydfb/eJhWqZJ654Rv3AKfrlPM/5uocXY+KSgwowrFlnsmoLm92fxm9QYNi9/2fYv8w9Ile7vV08D2COhkj8hSd/JOC+rLn3JnemdDkAstbp1kw9an7pdQUUH5/z1ho1udVpWTnVz465c/3dk6PkYqhHmrTPktPE++mVj5DKTw5jZmZ59lxg8imNUZzgD8f
 5cU11fw5
 nb0ukD/mZGFsAC/d9Q4h/BSg7JiS0uP+e4DuUk5zdinE+RFf7QgYAnvZeJlcYp0nXjxj+IADnUe8bLUknfvBRaAVQ/sYQE/TerIKaXz3fGzj9Vui7gQINRPUV44xPzv4LPyP/J8HANwbNI5n1WNe37Mcfo+5DJABdIi8X0R3RTtXU5zUPGBGFatS7JghCiVljX+2DfJu/pBqZUHVSwEjzJr3+My5n+ohNPYFBP2rPGGVqNBL31g2zEaY0o5P7aWUXXTdWuSXGzRV2IqM+9LCS+mTJCrazOckCfwV8f1M4lHC+HO3zk2bceLFmlD0FB3LWG7Qkxt5813SjQln8Gjs84V8MQxNKE8JWAJE9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 16:50, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 01:22:01PM +0100, Vlastimil Babka wrote:
>> On 11/11/25 14:52, Christoph Hellwig wrote:
>> > Hi all,
>> > 
>> > this series adds a bulk version of mempool_alloc that makes allocating
>> > multiple objects deadlock safe.
>> > 
>> > The initial users is the blk-crypto-fallback code:
>> > 
>> >   https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/
>> > 
>> > with which v1 was posted, but I also have a few other users in mind.
>> 
>> How do we handle this then once it's settled?
> 
> Good question.  I think there is enough mm material now for a merge
> through an mm tree.  If we get it sorted out for this merge window just
> merging it through mm even when there is no user yet would be easiest as

OK should work hopefully...

> the blk-crypto work is probably not going to make this merge window with
> additional review from Eric and I'll most like have another user for the
> next merge window as well (block bounce buffering for !STABLE_WRITES
> dio).  Otherwise we'll have to operate with shared branches.

... and we can avoid the need for shared branches that way.

