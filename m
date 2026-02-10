Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572D1EA3F26
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE87D6B0088; Tue, 10 Feb 2026 03:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9F96B0089; Tue, 10 Feb 2026 03:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C97F6B008A; Tue, 10 Feb 2026 03:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7C26B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:46:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5ADF958B6A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:46:19 +0000 (UTC)
X-FDA: 84427915278.02.AA7C4A2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E7AD1C0004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:46:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OaudNJgA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6qoLW18;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OaudNJgA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6qoLW18;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770713177; a=rsa-sha256;
	cv=none;
	b=cD1ECK4dNrXedBJ4OYT9UYEzBQ+pUbjRe17W90O0BA56h/8oN27yJDr4aqDflpz/KSrtqo
	M8NrswO6HojLUi9F7b015t4QS8bFjG2LG0XLJivmwFZanOCyJefEAr/3F4rxKbZaDag42A
	udK43fG2W9xaJbNaIy32pNpeKo/5YIk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OaudNJgA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6qoLW18;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OaudNJgA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y6qoLW18;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770713177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qfWWQweNaX0tLiMTKZRqHymOJ6QykFioB+nkaSZz8U=;
	b=Ega5RDcSoslMAh/3n/gh9PMYOd/9Ed+WiSpTPPFbWoytvTWFDRDFdUhFWvcGA8KI1sYNIV
	B5BbenFPpD8sHzMBnWLkrGwu20gQisYzR4Wl7WCJ46KVzrvnhuI+OlfFm62LfstciWEBNc
	Xu3iIjRjVDOZfj/SZLso5u8+jtD9CoU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B57F5BCF7;
	Tue, 10 Feb 2026 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770713175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qfWWQweNaX0tLiMTKZRqHymOJ6QykFioB+nkaSZz8U=;
	b=OaudNJgAxqCNKDPA4INmM5D1TsU4v8imhezc/I75swUNwEVd6xBlalHI0mPRjw57eljqeJ
	YPHoPuKg/eEcgI75FLYJNgqShfwpKrstgT6lQcaSwhrbRKD08Efygq9BTDYBNb9vB8i2Dm
	KqYuA/VoACW18CjpTjbD/7anzEUxF/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770713175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qfWWQweNaX0tLiMTKZRqHymOJ6QykFioB+nkaSZz8U=;
	b=y6qoLW18zfPk/tMz0GlXvz+ifEBv8Y8ff+XlUxWqVQPJ4oSluwrK/JtlicCubjvU97yF1J
	8uxbkf6k15vtTxAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770713175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qfWWQweNaX0tLiMTKZRqHymOJ6QykFioB+nkaSZz8U=;
	b=OaudNJgAxqCNKDPA4INmM5D1TsU4v8imhezc/I75swUNwEVd6xBlalHI0mPRjw57eljqeJ
	YPHoPuKg/eEcgI75FLYJNgqShfwpKrstgT6lQcaSwhrbRKD08Efygq9BTDYBNb9vB8i2Dm
	KqYuA/VoACW18CjpTjbD/7anzEUxF/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770713175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qfWWQweNaX0tLiMTKZRqHymOJ6QykFioB+nkaSZz8U=;
	b=y6qoLW18zfPk/tMz0GlXvz+ifEBv8Y8ff+XlUxWqVQPJ4oSluwrK/JtlicCubjvU97yF1J
	8uxbkf6k15vtTxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30FCC3EA62;
	Tue, 10 Feb 2026 08:46:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KZuZC1fwimniEgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 08:46:15 +0000
Message-ID: <84ed07ad-8c31-4505-9ded-24a10ec5df20@suse.cz>
Date: Tue, 10 Feb 2026 09:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] slab updates for 7.0
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
References: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E7AD1C0004
X-Stat-Signature: wes1u1zy1gzozjhc8suqisqqkohwo9yd
X-HE-Tag: 1770713176-787450
X-HE-Meta: U2FsdGVkX19Kb5b5Xr7IkteuhI4KZ6t2ixWBl4ViDxMWT6/kyAHS3MQOCKLR641NI/I5y/ZmjjFQ4Jr9/653gH6J5GecpyFN1tiGHp1EktkWnbuh2lAK6gPPIoK2eAUSbtQ/Ah/akO5QlUMJwdwSUuTyxPf3rr2r0I+8rIHkxO/PCm3XJJENVKPfTAv3jUPoPhyGp35KqZX8HJeif+agECu91+AE5liNcx+X/vXni1/y9s+ZC4ENQGziAO+83Pn+qJLWe5cbTJE7fyy3DobMVmP9/7Ep8iBSYa6d0vjXx2vVe6CKK+DsEqGrroiiKlu1kfc9y2/p82t7/Q4g7i+t/xxKRBhSIiX/1jN8WYGsqBZx7FruIvBqkrErr1iqrUHvw2EneX4ukYpxxbhB/uNCDojLgGzF5MyldrY6RemSrEJ1xnLalwPaXf8FyboS4ED6pHU9VR3dZXQyTvahw44ir26DFrSGfgxEPxBHy1TEBsQoW4P0zuKevCy9EqJBtSiJBSqy9RvboucNU0ducDSgMd5mIXUbtGs2TFE4lTbdGPItr1Pr5y2qq/4PXwDpLragrJagtO3k1zfLnNCT2WOdGSBzwjO//i0x5UJ7vY7K6zATpB6MvYeeRc4+syes8IP4pQ4AtgbLGFJmcuKfi2xSxnnS2g4Rtm/WTwUXMt9+z4P5u9Tvzuj6xmSUEMSHweVk1sxDAlBYRNO3FEUaQK4OwvCOohoXEm0yCQxA1Ex5Isip0Yq6hRk9N9ePlURzHqJ25BMbLjMMNt88fpTHcNtNcfHw226KNvy1XvK+lOp/d0TE/S7mc/Mce8rJnwJ1z10Gc2AwgaJH6VlaW6YJ1MYiX/ADlBdZi1fHv7JhXCFfvVhQvKj21BeafV7pflXF2Ck00101ZpkJqIxpLatcKXV1D1L4/3nx2WxdctxPg9KGnQxJUcPouTed7KxsfXBPIMlSCU6SmGffEdfdRVTeLoc
 k0fiI8I3
 Dnd/uCcBRKVGVa1Ki1/evudrNPd1S2evNpTR2BuinDLQFhg0OqvV+kdHnYJiAyIkGK4FbRgza1EWrSXh9CjNBN0LCmqtLzz/6yYYMH7oOBXMaFQSUdcTdBOk9MBXmV3kqIUMfI551/wZcLJ7lSya3ASJ3Modqa9SLO7wpfkIVyAQq34xM+acgdfDMpmyyRuV1B6rWac2ZKPPlyp/HcRkq7n/vfcntCrmROMREALVnXUG5s43LIdiHNDiGEZxcFsSnsM8HiUTfN/r0Y1R8x5m63ogL5WQDtQdU58jANZI0kzq6BedhvrP3bnOVLJBN0s8T7+7ZpYRXQPkNjT1RlIw98mVzEzC5OJtPB03PgthmfwfD7N4BYOqU5I5NSNzNHBJfZSYLOqMKFhUKl3YDluQt9B48/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 09:43, Vlastimil Babka wrote:
> Hi Linus,
> 
> please pull the latest slab updates from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0

Forgot to mention a small conflict with the last week's slab fix PR, as
noted by Mark: https://lore.kernel.org/all/aYShOPWbajIlXx_i@sirena.org.uk/


