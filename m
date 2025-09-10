Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567A9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 21:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3AF16B0005; Wed, 10 Sep 2025 17:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13A86B0024; Wed, 10 Sep 2025 17:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901D26B0028; Wed, 10 Sep 2025 17:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5D66B0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:12:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3372D1602CA
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:12:54 +0000 (UTC)
X-FDA: 83874590268.18.9324B42
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0C4814000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:12:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Udvhuw91;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fRq+NBMe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Udvhuw91;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fRq+NBMe;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757538772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQDheAEH01zbsD6rXDtTMA2VTv72WyB1znjhA5nW7qw=;
	b=J+2qB43u5PK6cJKMZREmJkj1O9WeARnddjD4G9fvpm8uN4221LjBwrSAJM9sNHFUeKtMZk
	qo0t5681YAzPlXlyRTv0X71HEH+8hhMRUhMwTvb5sptiKHvXeBBWn9qFIV2wSq4hx+227i
	XaKK6xw0itQner6aaWbfNgNG9Bkb5pE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Udvhuw91;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fRq+NBMe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Udvhuw91;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fRq+NBMe;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757538772; a=rsa-sha256;
	cv=none;
	b=UlJt8lKF/RqtnzWDstRDBu36jd+c1D4drSMqwASilGwfGEpHmeenKPBR3P57mjRuDqunY4
	pArGZ/ITEn4aQRERpZ4WQ+Am9tVA90ct/Rnra33Ptj4laI1JkiUr63ckDQYq0cmfnH6U7q
	tte0cYWOHLOaAAnLJrv4aYIT9g5m5JA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9425C34905;
	Wed, 10 Sep 2025 21:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757538769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aQDheAEH01zbsD6rXDtTMA2VTv72WyB1znjhA5nW7qw=;
	b=Udvhuw91LaOXTn1J1IJMmqwXtwfVvKS0fJ7vyVl9m7Dgb9hyHQZGo97pmCsc3/mTsRH4aD
	Hs7XOR/qjjYxbUCimr8oIxUS40ZBZPjPUedUGwipCxmu07EGHFvfLP9axNMuw9Jw0gz+XB
	J+7UWRP0S62Sg+Dt7ZUX21ktEZg/y9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757538769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aQDheAEH01zbsD6rXDtTMA2VTv72WyB1znjhA5nW7qw=;
	b=fRq+NBMe+TtHC/YOzYZva7aWBuM7v5jT3qKlp2n2EKT8gPpK5AMDVpssYeHWJlgROXIVst
	XP+kRqsZf4EKs2AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757538769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aQDheAEH01zbsD6rXDtTMA2VTv72WyB1znjhA5nW7qw=;
	b=Udvhuw91LaOXTn1J1IJMmqwXtwfVvKS0fJ7vyVl9m7Dgb9hyHQZGo97pmCsc3/mTsRH4aD
	Hs7XOR/qjjYxbUCimr8oIxUS40ZBZPjPUedUGwipCxmu07EGHFvfLP9axNMuw9Jw0gz+XB
	J+7UWRP0S62Sg+Dt7ZUX21ktEZg/y9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757538769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aQDheAEH01zbsD6rXDtTMA2VTv72WyB1znjhA5nW7qw=;
	b=fRq+NBMe+TtHC/YOzYZva7aWBuM7v5jT3qKlp2n2EKT8gPpK5AMDVpssYeHWJlgROXIVst
	XP+kRqsZf4EKs2AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77BB413301;
	Wed, 10 Sep 2025 21:12:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id srKPHNHpwWhMGQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 21:12:49 +0000
Message-ID: <d82c935e-1569-4ba7-9e9e-13b22dc2e4e5@suse.cz>
Date: Wed, 10 Sep 2025 23:12:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] slab: Remove dead code in check_slab()
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-4-willy@infradead.org> <aMFfLqkXcZTNv_p5@hyeyoo>
 <aMFjYbaUaQq1GA4c@casper.infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMFjYbaUaQq1GA4c@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A0C4814000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o4gakkcz587yyafhdm6a5hwgiienm3h6
X-HE-Tag: 1757538771-424965
X-HE-Meta: U2FsdGVkX1/4tfg06Z9wSmS5TfPEuSoO98EV9d3vIlzku+59L3nRRuR25K8KZZEDiVVgNv+v3PVdo7FeHKgOP4MvUKwqz03HibTP8uAz6dstOY7/MErmoyPOheXaXgSmPHFQ1/VYzr/1qnjJywcCSHJIPMSXSWMNa/VGGcywQ9Y4Q0qqk2JFCKjtft2b882BY33NWYHtsVfzxRHQ69izbG/F4N5TfNI1U4jucnu/4m50pJ1n1opL71RMPVUgwW/c3ruKKzOirv7Co6tvobXWk6mttd2WVBphe+Tfogu8fhhEX0MxEVa74CCRK/0z4MpCmCvakxcX/sol37puFJbRUoytikjvBsAVICY1ypV7HHhnOqtxwT2ubgMO23xYL/6EZt6kqqI6MIWkOVizr9QRn8iVA6YCyGvju88FwUlGHqdgkrnWUX8MtuYNZfys/QNiqnLZSIiPhE6gFA5aFfFqplXTBoNi6lss5ir8HcEBdQ5WYxJxJdLSBkuZx7a1efUvSNNRBfof7a2sLENdMk4h671jBSQqnvinmUsk+LEn9ChbChD1MJ5SI/nO9l2DGcsyZLAVylUfl8FhoqbJ1KoZYkbp6ESDPJf5aRdMz89OvY/F7axbaPuCvUKQJ3BR1dA6GhumwsGzKmOByLLUFl3pJYPT/5aImbHCGDlxfOvwpXBcsJylkob/RgIuGBqrrub6YRNhPT73N90j19t7iGMa2X96+YjUPGsh7578K4BirSy04ckPATy/o+r/rJa9wY/1SmRyYvucZ/rha68Jh5CIK55+nV0BInOBDEQmvFnmebLY8MQd7mVzG45441oNUzDX86ZS8lhvRwZh29sDTWqiMAARvrfjWQn24mvUZrvGdS3Y5u+gEsW5jVSoqognrv6ErTiq1RBuElfvNEktdvUEo0lUaA8yIImdmhDfvOjYWRNR8eK3Q8skn9Il8s/cnP7OKcRqcjB1pPoSTWPWzmJ
 Tbyk5cwq
 7KRLrJ8EMEoOYWcIx7VQ+dPuRaAf/LugqMA7tPUISqFnMDv8PHnvgHIcpghn69Io57RM07536tR+jIZLrCpXFK/pSz3eA+R+I7cfdJIIaW/km2XsRh9DNJ61vqlY2B5Hmkjs2uQl1I3mkNr7nydWhtnm5zoPxZ1A4CZI4Ro/K0QX2t4W15q7fpxIIyoBZaWK6AziuL009n6Ssky5s9UBS0AtDKMkPKY+IX6XGoU9gqt94ikR1VtXRtYEts0ZpByIiMq59x4DhhGoA7nYUOltwTwZI2+ATGo9L4lqRmtBqhzgTo9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 13:39, Matthew Wilcox wrote:
> On Wed, Sep 10, 2025 at 08:21:18PM +0900, Harry Yoo wrote:
>> Side question: if someone wants to (though I don't see much value in it)
>> iterate over n->partial and check whether a slab is corrupted and no
>> longer a slab, should they convert it from slab to page and then check
>> PageSlab()?

Your question sounds like a hypothetical scenario, but that's actually what
writing to sysfs "validate" file of a cache does, no? One could say that in
validate_slab() we don't "already know the slab passed in is a valid slab".

> I don't think so.  There are probably other objects allocated from the
> corrupt slab, and they might get freed at some point.  If they are,
> we'll want to handle them gracefully (after all, the caller of kfree()
> probably did nothing wrong) and not print a warning suggesting that
> someone's calling kfree() on a non-slab pointer.

In case of validate_slab() it wouldn't be triggered from a kfree().

However once struct slab stop overlaying struct page/folio then we simply
can't have this validation via page/folio flag anymore, so it's fine to
remove it. Maybe there will be a different way to reintroduce something
similar in the memdesc world.

