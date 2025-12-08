Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D7E3D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12116B0005; Mon,  8 Dec 2025 06:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AC26B0007; Mon,  8 Dec 2025 06:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BCC6B0008; Mon,  8 Dec 2025 06:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8791D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:07:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4413BC0A96
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:07:06 +0000 (UTC)
X-FDA: 84196026852.06.C259682
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id B52B6140002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:07:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uvVGmJPF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+bKPYHgm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t2HE9luv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAAp537e;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765192024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WjBghSU5cybVuNWVFQf0RboaQHsBf4dPXN/4v+tGXQ=;
	b=3DZ5UYgl7qbm4HS0xpXXokBSEsXygc2IsTZ9+XjUAD3FIDzD4AKrMnJkoj6TfRQg6N65uO
	1/diOfQm6cq/ysTYtP5tjGnyPn2B/nj+0k/NcmHik68guUGCQYfuZunnNPEehC1kz8W76c
	SGlOCLN9/+8D67kSbYhKL5Lz4C/GzUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765192024; a=rsa-sha256;
	cv=none;
	b=SrPxrxzB4OaQHH59JliXFpTyHzYx4K55DvENxWpYahbxeydZyzMOLF63zFXiigiwtIquAt
	RSZyaN+94hyBD4YgbfSakXr/4+wWRFahKjMdkvnXiT2dLqW55T4PsZ3hjrqMXA8+4MGi/d
	b314VAx41cuMLW/WTkkN5I5EYdvtsDg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uvVGmJPF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+bKPYHgm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t2HE9luv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAAp537e;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B49D05BEAE;
	Mon,  8 Dec 2025 11:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765192022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3WjBghSU5cybVuNWVFQf0RboaQHsBf4dPXN/4v+tGXQ=;
	b=uvVGmJPFJ5/wdertQ2fxjHO4IKZehROBaU1yuFt6i/OExjCI6tAZ9ZsaG1yR+13vep9gEK
	b5CgOayS7JDsh8rCaFxjJkpiU4RGwwViZoXmamJU4oD9mjKjTBEnOcPuP64SIXanmkcVmV
	9fR1hXiE/revnG7A270jrD699RfSUVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765192022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3WjBghSU5cybVuNWVFQf0RboaQHsBf4dPXN/4v+tGXQ=;
	b=+bKPYHgmc008xRvDGE1Z/pqEUvLUqWoiv5ieKau6cK/GQoGErpeCGz6rDsue3e5MMC5LpQ
	IiXoaD75Ylje9HDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765192020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3WjBghSU5cybVuNWVFQf0RboaQHsBf4dPXN/4v+tGXQ=;
	b=t2HE9luvKuTJd0pKq+mDtJFXP4i45e85SA3ueHlgM3JfMieZOb9MXeTAgnUthWz+t6R8JF
	8zoleo13eByKYI+9SC4qLtULwPhRJfwJJY2zuliXyjm3k7j6j3XUsedtUp5P/rfnI9KYew
	2gIoWlfd7JNh2KvEcF4iejtOZpYalks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765192020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3WjBghSU5cybVuNWVFQf0RboaQHsBf4dPXN/4v+tGXQ=;
	b=cAAp537e5t+w/ygfx4FbubBaid5sJqoO1aZFCf/1SpW9HqmqCHf4TJszLackcezVJ8ZA2w
	XbE4Ws5C1T7qTIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 926A03EA63;
	Mon,  8 Dec 2025 11:07:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id POYKI1SxNmkpeQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Dec 2025 11:07:00 +0000
Message-ID: <5649e224-bb6a-4b63-bb27-5541216df0b6@suse.cz>
Date: Mon, 8 Dec 2025 12:07:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>,
 FirstName LastName <vannapurve@google.com>
Cc: ackerleytng@google.com, aik@amd.com, ashish.kalra@amd.com,
 david@redhat.com, ira.weiny@intel.com, kvm@vger.kernel.org,
 liam.merwick@oracle.com, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
 seanjc@google.com, thomas.lendacky@amd.com, yan.y.zhao@intel.com
References: <20251203142648.trx6sslxvxr26yzd@amd.com>
 <20251203205910.1137445-1-vannapurve@google.com>
 <20251203231208.vsoibqhlosy2cjxs@amd.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251203231208.vsoibqhlosy2cjxs@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B52B6140002
X-Stat-Signature: 53gz3dozq7saokbwzaqp6ykbu3cbj693
X-Rspam-User: 
X-HE-Tag: 1765192023-895244
X-HE-Meta: U2FsdGVkX19G9xknUCjd0QrgyBZeJwR+6YlX/Ytx5qe2ZjocrjgCSOkK0P8bqTPqsXHTOxI2axCp+zhXu0yrDjhCnWqMqq+l2GKCL7Je+X79kQ5hUQ6l2Z2k3a938ND4S/XQduSlUUgvDbknER0ootY2FV9i/T5dpF0GprgqInesN9zfWXSrUsTIMdYmSYjqBYLhxiRGgn6Cbd8On+jOUuE1Bz1KzIvdXJ4i2UOHB4IIG8iMs2mYFC0S8/olML0UlwTVWNyyyDW8466F7XXShUCb2qnQsQL+/9HG424WMrpN/QxfSFy0Ud4ylsH7Rbw6eV/n66tDho3eF164I3f/SFeqCVqLaqQBLBLFn4UoTuZcplF/eBHf8ppAOU/JWV17R/83ofJMT3Vb7ylH5YCgwEu9snjml2YX6MDCobXNh1sfPJd7qVTP+DdtpioynP7ID5eoq60XEG1yKoeFf2u2OA1kfC+360VYYNt9K+lNMIE6o9qJF4h8lF21bYjVJJvuxF+xA5sIw2413zF3kFZ3bTvagRk6w1VcIng8H6irXTrPNNbzM3sDQzJOfH8/4bmuZ9ZAGMlh/HJZ+0Ajqt4Tmj7XgVSKvrkPaND8Ze2OKnp5Gu3O0kzwpjfdc+mzN4H++YSh9Dn1d9WquXsdta7Eyl4QjxoKGhXM/zDodbnO8u8jZlY9GOyB0RV5ndv+uV7RNQ7qmBKEQwovMAOiMHzU+lL6c/MyoBOo8JVEGxzpWvVTJlKybL8RnT3zi6JHqO9VFHBVTNP4QlmxECl6+vhg/J2irn7icnfgHSzsc8Tp/vt0gG1LaVA9mfBT6dKL9ZGGsF/qT1D3CJYAOQ7mpqijoaaeRVzNW8QTxguh6Jedh3bay68q0urYpgKV7vGUOTOckYh94igs6lvkSgKugnwiynjRbEjgwmix89AIIGFT27m7Ppl1OCwWQGpDnVgt5Zu9/IjECWB4mCQlIZYKo5M
 XEqU5Ox0
 BTnwGNtDwYghgngL42shghl2aemoCXH73eR/JZ74gnwUcdwYQWv8WzR/ZqdgeMGydKPSuADMc0/9c+1QkPd50VHGLA7ewfu2Er6xzOYmHcYBSvKYNj5iCYSKjtYTbOlX/4Bw50CnhHUd/sI8kHeO+Vh7A2RJjs7/GfX6N0SbFCpjMVdCgYYgzjpgcuH7GLRgcipuK57vNbmDvq1PstP7CtXh3B92hYK8Kebz4aeuIrilP9+170AoWQAqPE9sm1GpWvJUpBY1CeDXd1mvq3sQibkktq3X7mdkkt9E6lfa8sEYDXbpFtU+WJm+2ep0EEFtQrEWfpzLoP4I8YVbaWt7bRYB6rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 00:12, Michael Roth wrote:
> On Wed, Dec 03, 2025 at 08:59:10PM +0000, FirstName LastName wrote:
>> 
>> e.g. 4K page based population logic will keep things simple and can be
>> further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.
> 
> I'm still hesitant to pull the trigger on retroactively enforcing
> page-aligned uaddr for SNP, but if the maintainers are good with it then
> no objection from me.

IMHO it would be for the best. If there are no known users that would break,
it's worth trying. The "do not break userspace" rule isn't about eliminating
any theoretical possibility, but indeed about known breakages (and reacting
appropriately to reports about previously unknown breakages). Perhaps any
such users would be also willing to adjust and not demand a revert.


