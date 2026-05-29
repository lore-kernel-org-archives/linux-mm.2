Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60ADACD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F596B0005; Fri, 29 May 2026 02:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C571C6B0088; Fri, 29 May 2026 02:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D306B008A; Fri, 29 May 2026 02:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A64C66B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:17:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 700691C0FDC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:17:27 +0000 (UTC)
X-FDA: 84819450534.30.91CC937
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4AEAA40006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:17:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkzkhmIP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TZYlZ58k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkzkhmIP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TZYlZ58k;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780035445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=uduim/yB1ZfCyrJ1ZGnNhQzeAFxH9eRrRVTIjdy/pZvGkbLAqptIkmnONDaBhqfc0BtBU9
	UFzP47rbOEg3RAKxbfS5XOwmv22RIlL4j3mbgDzZppB5TArYO3v0CDYsTXkdHwGNmJYsP3
	UsGQ/bC+ZP71zxaze2Fbk2M79leuvCg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkzkhmIP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TZYlZ58k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkzkhmIP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TZYlZ58k;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780035445; a=rsa-sha256;
	cv=none;
	b=Z710HOih/lV0wejLMCbacOmqGN+OnNFMc/U1+tyMse7YmoWuRWLFQWa1CWTGvb72OJ/ZH1
	yI2b5aY0NSHVpaRsgXSAQ2OQUvbvEcagA0msyz+U0+mNB2uh7Vol1Qj6eyQWtN9gLQmvok
	JU3z3l5Rx/tebalwAMLq6BGKj4KtcV8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3F546ADFC;
	Fri, 29 May 2026 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=bkzkhmIPM1k+uqvO/DWR4X7xY2psViNf1K6x+RYuE0JEAMkYqTRFzbrdr/tb5EkDHjvqB+
	hNFu7KEcAE4gm1p9r0DzoLHly45JBcg+alpe0MLpMg8L6ftQv7QAMElPgG9sHnRlBpE3Zk
	5fAjjZRzKrXK8DmV5hKllJ8iiBO8zk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=TZYlZ58k999uRr99rmYwif3aPsN6aYeks/D3M/sevnjYUb/Z7jUJN+zYJU3AmoyDjz+fpH
	YZa8vidu0Oav2sAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=bkzkhmIPM1k+uqvO/DWR4X7xY2psViNf1K6x+RYuE0JEAMkYqTRFzbrdr/tb5EkDHjvqB+
	hNFu7KEcAE4gm1p9r0DzoLHly45JBcg+alpe0MLpMg8L6ftQv7QAMElPgG9sHnRlBpE3Zk
	5fAjjZRzKrXK8DmV5hKllJ8iiBO8zk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx4YswAc1yVXQsKvAiXfezzli9FVMB1COPrkwMvq7mk=;
	b=TZYlZ58k999uRr99rmYwif3aPsN6aYeks/D3M/sevnjYUb/Z7jUJN+zYJU3AmoyDjz+fpH
	YZa8vidu0Oav2sAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D2B05B1C5;
	Fri, 29 May 2026 06:17:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5dFCIXMvGWorFAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 29 May 2026 06:17:23 +0000
Message-ID: <4f02694e-1d99-473f-8ce4-2b263efe8138@suse.de>
Date: Fri, 29 May 2026 08:17:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] block: Include bvec.h kernel-doc in the htmldocs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-3-willy@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528175905.1102280-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bj7z66o5fi3edizdq3zkeaazee6xt6ws
X-Rspamd-Queue-Id: 4AEAA40006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780035445-642086
X-HE-Meta: U2FsdGVkX18pdARKrN+TsL0tfUEkadpdHjBbv81akgjJWbAyxydokLbwNocUFGKWBcFhkOdTxOPON3MwWe3ZZLKS4irRaEZ5YzC2uI6v0dJ3BjYLMBbG8VXsnpXTqE28+0hsZZBNeD85TtVZa7DxOIBr2jmhCTx+iZ+yzxLcJyD2ZLgZfymKcgaHfVA3JMB2a6l//ZYsQAS8bOwzr9cuAwgG7UZRY0zUAhRNB2eShAN+ZvHOuKTnC/LJFS1JiBqkWO9qAGUWYsmHfXxa0vR047VuBOUq4jJk/zLY163ZAToLrX05q4g64v+EWIbizR7Xvm9lc13/argl/Vv77AGeEsXw+n9wpaVKUwDpWrMWkKgWuwlnZw9pTcL5Pu216k35vTxHF2L1EyYr1ldtrrFUSZrD3WxuzRS1dPxVt2YqEZss9v4ji0C3CRt9vDCz6AyBGiEIwqJh9a8ZOL+st6uCMdn9i8ruvKjnKc8m9sUqQRRrt5NoLihg6RShV7mqC/vB78GEZ2cP93niYbYUx/doXgeOwGn4B84OdZtlLcdSRJF+2ilusNggtx9E2ZzRNsZUaeIxsxgddbHQJzAFNnWe05OIONKeHS30iJndatF2tbE1YndY5znvRhyoLwzekXQk1m7Er7cnoFYA42dd7DWf5anf8shJWtJO9wNVefReGTJSwQeznoNpl9UEUljsmtkX3XNfQ9HFH6c+l8xwsiG/2jamIMmQbW1XFAr5tFAaQjn4j3rxbnvWI7r9SM9mavc4QArVcdKz5bs3ljvpUbs1HzwARzZpeBVNSjkG0Q4KixweT3A4ABnREtAl7rTRluy019b7+HrKRlmNODpfglTJmK/usw2BE5LeoIu7TsjXYRt2T8718WjplMCWqSDhdi/w2tbaBYN+PkYUlSbwrzt6gU+laAv8aA8R8td+eJ8ztfTsqz5RJkk0VLbQZiZoqYFcWEMqVyeDXzK1pNRoQ6e
 mCXFZ4LK
 R9VFvcdxPtpXgfxpnkejmOxIHCLO1bEUHsDo8Sa1sYIOly1Sljs44uq407IG/k4UlM1gHnZ9+Q3tnTAcJvowpREgyU+Uk2BMwDh88/PlcjtrfNOVrOTG+Zo/LNyhwI4YG/X6oUuuZaEnhWjzFDk145UrPqDQ7W+PmE6Elcq+Q8C3tE1/aLZSjaxyVQWzc56c3kewCQ5alPjbDFYcu7mtsqXL8FkLjXPUSMUEnyLJMia33dWtgBNIzfq26XelEPTKP46LUHvSbFir+W4Hu1K+8f38+xrdvfCTKhA0q0rzBCjOKd3nxdt73AiVkhRHX2XASOuqBtYO3ontLVZWJzRYrQK8s9eiTgu6dQqIV3MYzuF3OYarBRi+URKC8uyjODlWtqOoZN9rEJIS0sCmdpYjGqG2aS/SCg96Lxdvp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 19:59, Matthew Wilcox (Oracle) wrote:
> People have gone to the trouble of writing this kernel-doc; the
> least we can do is publish it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   Documentation/core-api/kernel-api.rst | 1 +
>   include/linux/bvec.h                  | 2 ++
>   2 files changed, 3 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

