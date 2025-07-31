Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E79C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B57A6B007B; Thu, 31 Jul 2025 14:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3677A6B0089; Thu, 31 Jul 2025 14:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22DD76B008A; Thu, 31 Jul 2025 14:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1210B6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:14:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AC6913474A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:14:02 +0000 (UTC)
X-FDA: 83725358724.19.C0CF731
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3242B180011
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:13:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEZVT0RQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tnfFpMsP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="wHK/Rw0e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NJcxuv3s;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753985640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw+dB7ipEpqHtBDc8pfVR005esOq9VNlEJZn2+7JoJc=;
	b=EFcOWzajA+QtDX4KqiBFb5/SCPGESl/GfwxYRsDYqUXSvlTIVlJ6jRUBxwMIUJzlIXlrM7
	oyNO+TMt1xP0i0KdX0h3GHXmdEx4CuI5seq8T7bVzfWc3JmesgOETEJ5NYnsqzvfI2tzPx
	HZIFXaDX2/FahwXyFkqQ+vQVv9whYcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753985640; a=rsa-sha256;
	cv=none;
	b=VhBDNkgI+MBwta1vAbm9MRdn3l8XrM/WSoj51zfYOqtdEBBvLV0SPksrBtvTikmjG0VFcT
	6jYctUk+/FYsS6C+ZHCXK3ZC9rDqSu1k00SiSa3kH/Qh01J+vZ7v4VCVt4Yk2Xb3M6ZvIQ
	OPa9ipEGFtlDiWF/FxVLJG/nK/HMY4w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PEZVT0RQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tnfFpMsP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="wHK/Rw0e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NJcxuv3s;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0EC541F7ED;
	Thu, 31 Jul 2025 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753985638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bw+dB7ipEpqHtBDc8pfVR005esOq9VNlEJZn2+7JoJc=;
	b=PEZVT0RQBMGl1GrF5K28duDaKBGAJx0vtCx8RQ66KQ7sqsYlg6fhLwdVbYsAmQBuLUw51+
	fTeY1NckElAjnjeqMOXL1l83ZWrbaXMFjwOyZDGcBBH0r+8Z9XwWKacr5H8VNVRliEtPZA
	DGrGVWLllyooWT93ZNtXzaWsdJ7Yydo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753985638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bw+dB7ipEpqHtBDc8pfVR005esOq9VNlEJZn2+7JoJc=;
	b=tnfFpMsP1rhII/68mZ/jja9Oi8XNIhzo9XO3zliiqLhKX+ae5eAYkIXgUdxNR25B/Au9xU
	YlbOG55fkHrhv4AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753985636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bw+dB7ipEpqHtBDc8pfVR005esOq9VNlEJZn2+7JoJc=;
	b=wHK/Rw0erHGVz/IRvtURk1v9SOeNG7uEc/u/miqZiaE7xypi5gwkxWJ+zwrqcLwd7Nx0/3
	xZGMezwNt2OwIM5eI7KHJr6oFnE7f7qEdANy8PjQSaZy+IU/0eMSzx/JMwC0LzKvMquprw
	+AdAaYaxRnWz0lAZZDl3ZyMSpe+PsNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753985636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bw+dB7ipEpqHtBDc8pfVR005esOq9VNlEJZn2+7JoJc=;
	b=NJcxuv3sRzsMBrnMAy8kTkA7R/QjxAyFdG4oX9sN5Wl3RS+roppasI8KgfeJQIc0oTQngb
	lhBYBnpWFSKKRFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5F0613A43;
	Thu, 31 Jul 2025 18:13:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zoLMN2Oyi2hVQwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 31 Jul 2025 18:13:55 +0000
Message-ID: <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
Date: Thu, 31 Jul 2025 20:13:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 WangYuli <wangyuli@uniontech.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: asib7j3br5xisp6489hnnufjhoehjz4k
X-Rspamd-Queue-Id: 3242B180011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753985639-135143
X-HE-Meta: U2FsdGVkX1/vB3z+rR4VDJbVLoTdu5BH1BvPvjUMjPLq+Y9C7WBLNZQjzo4aQrYNinz8nmCn4Mb4xXE1reJeSBhHnC0gy4NYhwm4O/Wa6RovqRaVJsU2KKokhRi91+k/BSGYP/XTPxYanRW3+cAgbDFGq76Rpa846YISj2MjcCDMJ7j+ZeZizRLw7qj9i1ulctGiGgh7dMvqLfnfcSo4sNKSItgRk03gi6NDWyumJKIW9a1AIDFaRq2wMoEd9xxa2fKfzHZZHURnmJG+lPd8ASZmD0dArFs2TsR/oBoivGrxA6HUJZAvKnnqkEYlkrr0iIj0I5GohxBW8pFSpkTcwGOmTnbVmd3anq6SOJTay2S2bkI7B9a9MDs5unfiIrm0UZORbqwdj3lseR5j/4pKllHBXHOcspWWFDfW1kyPR1wLWP1FaDQshI6eL+3GYgUdEs9Ig4kOp2x9q6a6aquD8mrkRi+NkQ6pksmetDNPhqN4lO6ebTmzTMMDlQrQ5dZNUd3XpAad2sNNziZVq/qWV5lAG9m28tzDN7cF1yKbG7IdczkhP9zTLasbXerMweiYq9PiURboWoiLK4yoRK/lNKLD7du/e/arm9U78greiqKrPkvWaPwlo+yVS2unrQ1mhanWX2qTusXM4GaxJsrOivdcLTZjXk98ggp6eU8NE45IAi9kNNiK4uZDwmWw1gNx4U8QzCKZDN/9ejg1MLb0+P5JBIvu3U7z2B8In6+LbDC/fzGkQmbuVeQU3iXmqpG+I2552z/BwOfDOaSE9qSJRM79U44LsbXLwDxqJXytJpNDPGqJ/0aJ1+0/1e/zXJcut7TXsEnyk/IrWEjgJj2/dbn6O3tXL/ibF+h5YwkCsriZTc6v01MXgCqBC5eFS/HMSsBqbafkU8gnfUGueOzEjYcVFtxc7Vmj8r3R8PwlPOmylEqkYYimPA1nGQS1wT+Jl6H5H22GRpSaVlFKlOC
 pBd8XZYR
 QWcwJsn4j9/mvdNb+vZodaNUjyQNnOuiRJmNPlR6RRRaFNeogZacsil6mUXgNKQZU8wG7yWkm6iEV8AjSW+XPem+Ajyg9u7gKHsGSn/wFx1uuaDx/p+jK2ebYSFRoZXmo26eKVN+/xk/3qEqx2OyinAamz0OXcBqtR/zMKb+kUTi2wNZG2w/bMhYtsI7Dcwd9XGkyUZKeRRjqs5fjkRrjdJacs5ggh6dO3csNa2N/iaGo1ZQn8RW5/HPCJnOF9aRPG1BAw5CnZsxConZPlBF/RRlExLOuip8Now6H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 12:24, Lorenzo Stoakes wrote:
> On Thu, Jul 31, 2025 at 10:55:32AM +0800, WangYuli wrote:
>> >
>> Thanks for the heads-up! I noticed that coding style in the kernel code as
>> well.
>>
>> However, GCC 8.3 (which does meet the kernel's compiler version
>> requirements) can compile the kernel code normally, but it can't compile
>> vma's test correctly.
>>
>> Could the issue be related to differences in compilation parameters? I'll
>> need to spend some time looking into this more closely...
> 
> OK thanks please do check, am happy to have a patch to add a flag if
> appropriate! :)
> 
>>
>> By the way, this coding style has been a GNU C extension until the ISO C23
>> standard. So, until the kernel's C language standard is upgraded to C23
>> (which seems unlikely to happen anytime soon, perhaps years down the line),
>> it actually makes sense to modify this style for a practical purpose...
> 
> Kernel always uses the GNU C standard by convention, so we should be good,
> but indeed I think this is the case!

I think it's not "by convention" but quite explicitly by:

Makefile:KBUILD_CFLAGS += -std=gnu11

I think this is not automatically used by tools/ build?

If you git grep gnu11, you'll find various Makefile's under tools/ adding
that to CFLAGS. Maybe we can simply do that also with
tools/testing/shared/shared.mk
that's included for the vma tests.

I don't have this gcc version so can't try myself if it helps.

> The irony here is that I actually intend to change stubs in this header to
> remove parameter names (previously had review on this :).
> 
>>
>> [ Cc the kbuild list. ]
> 
> Thanks
> 
>>
>> Thanks,
>>
>> --
>> WangYuli
> 
> Cheers, Lorenzo


