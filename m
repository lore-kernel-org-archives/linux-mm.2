Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FAFE8784B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107AD6B0098; Tue,  3 Feb 2026 11:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D68D6B00A5; Tue,  3 Feb 2026 11:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC836B00A8; Tue,  3 Feb 2026 11:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D30676B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:55:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AEC9B9E3F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:55:33 +0000 (UTC)
X-FDA: 84403746546.09.ABCB0F0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF0AB1C0013
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:55:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vnOxzGke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kzx4JW5y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vnOxzGke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kzx4JW5y;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770137731; a=rsa-sha256;
	cv=none;
	b=pD33W22jSTSkYX0ccGu+mQhfZuO1TVQgrjl9S3nP7nuekvJarHylewYYZDZzRkUohcg3WK
	qw8x+zFQMkZtdjktIpUezw7GOqQrM0Ctkd44wx49NZJsLtOvocqStQDq9u2pjsqsvnXQrm
	YkTjrFloNklI2SRoxCYP17rFPAHaNqo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vnOxzGke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kzx4JW5y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vnOxzGke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kzx4JW5y;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770137731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAsMcsDcP+60ZFI1po9ogSRlrXLckgTXhc7SCnWEk0o=;
	b=dzvR8/Ph7dYsXVWJnUupMAGcWPROnhYfrXXYB5QUCX4gz5X4UW5mwWO+QT4MPTM+YSHRR7
	QgA23GiGVVJ3v805XoUtWbz15sJ/lI1wL7wMrP7lS9INnjWANt39Qy7yifqBN8nlPFFdYh
	gSSNcHa7oC8+ewipOHRHwtoLxtvGUGg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9AB43E6E1;
	Tue,  3 Feb 2026 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770137728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tAsMcsDcP+60ZFI1po9ogSRlrXLckgTXhc7SCnWEk0o=;
	b=vnOxzGkeFq4s65we7tF5VsBboxg8j06dAdLkjRtLdzagGNB/fMyAOCSUXWTfKYtcQOQOxD
	q7ecZdBL8tbfdIQv+VZi0V8Z0D/rld/jERxF/X47e4UTWHeo+GvXyRtX9Ufww7cwqxIgp1
	IwvCW5QrfLCTtnJ5jm8NZMiflMtV07I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770137728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tAsMcsDcP+60ZFI1po9ogSRlrXLckgTXhc7SCnWEk0o=;
	b=Kzx4JW5y/ra38hAu1aC/dkz5RDJbezpERGLZ1aZkcdOa3a5yoPq99H/J7Jvkh1UsDnavrK
	V8BVSvrBN6ISIdAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770137728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tAsMcsDcP+60ZFI1po9ogSRlrXLckgTXhc7SCnWEk0o=;
	b=vnOxzGkeFq4s65we7tF5VsBboxg8j06dAdLkjRtLdzagGNB/fMyAOCSUXWTfKYtcQOQOxD
	q7ecZdBL8tbfdIQv+VZi0V8Z0D/rld/jERxF/X47e4UTWHeo+GvXyRtX9Ufww7cwqxIgp1
	IwvCW5QrfLCTtnJ5jm8NZMiflMtV07I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770137728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tAsMcsDcP+60ZFI1po9ogSRlrXLckgTXhc7SCnWEk0o=;
	b=Kzx4JW5y/ra38hAu1aC/dkz5RDJbezpERGLZ1aZkcdOa3a5yoPq99H/J7Jvkh1UsDnavrK
	V8BVSvrBN6ISIdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD2B53EA62;
	Tue,  3 Feb 2026 16:55:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SgO1MX8ogmmkPQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 03 Feb 2026 16:55:27 +0000
Message-ID: <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
Date: Tue, 3 Feb 2026 17:55:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, =?UTF-8?B?5p2O6b6Z5YW0?=
 <coregee2000@gmail.com>, syzkaller@googlegroups.com,
 akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo> <aYIh1wPm7BrId9dk@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYIh1wPm7BrId9dk@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF0AB1C0013
X-Stat-Signature: uctxe3x73wow1mic1zfs7cj83yfqmb1a
X-HE-Tag: 1770137730-511614
X-HE-Meta: U2FsdGVkX1/ALM+kfs2xWd4ENmomtj7bYt0jXCgn8LrXeek1Bh7u1k8C2ulS1XSfk/J/VSXkGn/LeSar73r9ywgiWxB5BI+Z0dTQMu5fDbPjiYU4yCB4VEwSfqIMkbGzVd6vmL8FfyaIhWMg2sP5g3JBBViMUjnCG5/iK4/ZksheOSaIbp9mBeFyDHk3aP5pYm92WFxzu7mDdRo4aXJygdQKh4nXVXFIs9qodpFUitpy4vFZ2PMXchICxnzoZNb3yG+z2dfGP5+iGC9RXaaQII4CYluPf2GCs+XFE5/vcfMCHsdCiokKTTzYE06jQ/8qSHLp+g/fdlMbNJp57qIKhdiHyyM27OikiucysnkbxEmi3mAG+uvVokSZnBphe++FVdoCbBTeyx+q4BGDmfnUYFt3y+sEl3ztLPTVggLh9J+dm9CPS4uUUT+K6Im+JHfHxi2r9z/N1AS0r2c/1kCk+kvejud2Cvyw0lDEzvYu7h1PQmdbV2FtIWg/GaCiv4HEbgNaJXYPKKMEV/dITcs1nJyzhsfgcBNxzq89ZdKa5qeL9OXdm/xrnz7xdnDXl5w6W1JbAZMLrHBh3vS6X9S3mUfy73RrKt0ZKVWb8Jnihyz+LJo5F1w6znINApRAmazMmmJ4mQ7PNbVg3hvcZJ5Yw/z6PwYuo2yXhSs8wkt14sGP//lSdYmsBxGMpURHa2mRMMP+S6VGcNw2N2QJfKu4O5YcP9iozfAeoeaQO47Ae1z872Lf57TV6H75odghqkoSfT4cbJ8lj5AFHV0FriA0JRh8VwFMEwb3mCCVDE1XhO2ArIJsrgt9dbiP2vFqxJRTRVr6zPLYhGzhvuFsaGp/hP8VSwVc7/y2U11ihY898OJWKsGDHZJalw0lGf3NpFoBBjX7g95Do4+x8mDAzhqy4NNK0Mg8mSM2tty2wb0uywO5aSeNvHk1b14NqA2/MWseKTnowrwELVYwRcuz/9e
 fEVuiKLp
 6yLqpUR+fxzBpl43a7Y8JTQm7zdR9Etp9IG9vXGdt88sk6ozNxEFkbBQ12PzBujBENk2NP4AnkIVux4Eq2UfCtU2DpSMOfaV1jP90rF8pXBEGHH5yGSL1GTVvMpM2ScmLd+8mZ/lFFzfQ91/p8r9XOJuYAsg9+srJuJOnmbCX9InuQa64wY6HyvWTkLgStmHckq2ZSPWjdf2Nf8XOHW/xoeh0ppVOGZvI6nvNQ8J4RQ2cf/2sIDhTWWpImZk+5QT/nL55b3meWoX7t+EzbRFyp4JxoPqwj1u8vaZu6EgbqTLkwpFhWBxKE5u6X5CQuoXsC1aChhIamEevqek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 17:27, Christoph Hellwig wrote:
> On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
>> Maybe the changelog could be rephrased a bit,
>> but overall LGTM, thanks!
> 
> 
> No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
> the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.

So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
just redundant.

> So if there is any work in mempool_alloc it's that it should warn about
> GFP_NOFAIL.  The fix is in the callers to not pass the flag, assuming
> current kernels still do this.

We could just tolerate the redundant. The code would be simpler too. But I
don't feel too strongly about it.

