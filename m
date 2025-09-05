Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D52CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403A98E0006; Fri,  5 Sep 2025 05:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB588E0001; Fri,  5 Sep 2025 05:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3168E0006; Fri,  5 Sep 2025 05:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19E958E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:21:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE73F1DEDDD
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:21:22 +0000 (UTC)
X-FDA: 83854653204.05.5469AAD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 394F540010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:21:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lCFxCcPX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Elsm7G2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LdVt/R+0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xib63Lfw;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757064080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rg3QKWs9uU1kouyVm2UkSG/lcnvMWp/nur8uOfA5dks=;
	b=JuxxHICngN04l8CjeLUpnvZnlPcpeE6XXt9aJf1XI7xIp+ux1jd74bf4ZmM9uokn+sjVE0
	2T57EJt4nk3Hqkxb0xhgwWTEV5l7Zi0r6jfyGOrI2ZZIqAm/u7lZETmcn3QH4XlqIfiPME
	XDDOpBNO5HqayyD3klMQmUYjO/tZKvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757064080; a=rsa-sha256;
	cv=none;
	b=VMjqfE4IqI+Yof/xte8p1IArQqa4xf+1p3CSY6r7iXzZlr3A+nMdbfQ8x0tpXed7EMfnu+
	Zei4oIoawjRQsXrAsJk8tyUC1kome2zv7MCkCBG8Lk2jqNyErDEZ8uLPVZMs4ZgW3X/tuw
	NHvZ1FJiIqcnnuNZn2AxqudL56ybzwo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lCFxCcPX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Elsm7G2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="LdVt/R+0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xib63Lfw;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DD934DDE3;
	Fri,  5 Sep 2025 09:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757064078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rg3QKWs9uU1kouyVm2UkSG/lcnvMWp/nur8uOfA5dks=;
	b=lCFxCcPXzckNK0oMR9ftp0nJM8WnQKAg1Mdh/YftdrxP5DkEdohTCnOUgeNiP0vBTFcK+t
	CHbEjBgQuf2vNoaAhZQXjGMvWNiAC5dzS+LO7/KciwBT3GMVFATCg9bMH7dv5E2RBGx5m+
	gitBC1kSB/8fOv2BPWaIqIuHhx8WO7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757064078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rg3QKWs9uU1kouyVm2UkSG/lcnvMWp/nur8uOfA5dks=;
	b=+Elsm7G2wGU4B5UOQlMR/l7dHnW8ud577ayqhJ9Q/hyH9zRJe8xWZNIPXdcWKxPagebYJS
	Xp6eEdlKMG+lLPAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757064077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rg3QKWs9uU1kouyVm2UkSG/lcnvMWp/nur8uOfA5dks=;
	b=LdVt/R+0dYTTDAo8q7+KfPjf1cYAiWqzOd4txT0eDCGViKehrjT+AzAQ5fKe/v9Ilxlqa8
	2LikQU+XkeUUWtgW7mrM1JZoBSk2G8ePZ3thD7kDDkIesUO8CQCbXX/8nQYx/oqeVtuV2E
	JIq0Bn7jLG0B+MkT7i3tRLyKH1C6CvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757064077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Rg3QKWs9uU1kouyVm2UkSG/lcnvMWp/nur8uOfA5dks=;
	b=Xib63LfwF7CRtzoz7AXoF4l1eOf+5zo87oHZsaG+ROQG8vWUt3P+kx4ZY7qwDvDCtI7WQz
	Jyay+k1iJw2hgEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5676E139B9;
	Fri,  5 Sep 2025 09:21:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Dj5eE42rumgOKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 05 Sep 2025 09:21:17 +0000
Message-ID: <3d9a2e2c-8081-4298-87d4-a4c023b3687e@suse.cz>
Date: Fri, 5 Sep 2025 11:21:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add tree entry to numa memblocks and
 emulation block
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250905091557.3529937-1-rppt@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250905091557.3529937-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 394F540010
X-Stat-Signature: uwt8tssf14qsxa3p7ywiwgie8fktm33u
X-HE-Tag: 1757064079-746236
X-HE-Meta: U2FsdGVkX1+wcssrxADiMpolKZ8jysnK1XlIx+s78RtLQinuedUqfYuKq9+dL4g6uG38DcMuWiPVrNFbOyf2vcalbW6gLeD9F9YYW3IWt3BmDxrCaw8iJS4FIbTU0ubmYQ3pOJtdryS0kHHlHjbMXE2/HvoywxBSwlEbFLvz8F2nNkc67rztLJiuXXKVblFB9Cy05K0YjE8RTGqFt0ESejoxeuC+4SX0ywnNMLUuWIAwZy01pDk9VLMzgrBmxB5tElp5zWH/m4y7GzDIjdojobP/N+Zq9rjC4aWlT+u5S68Xyir8w3/zJBe87M/2/CdcEZ4coeXSOmFgQZk+h+e0/D3nWVDh7AeDUqhQy4+AKM2lAZ+wSdhLg+KAxz4RTQ8xPhZpDp+zJGVHVqmFt3DSB/WQWO5XGhGRxK7xYE9w2EzIp4Y3znAj1lxS+fOg/N2M/eYUbNVHr7BY9IiQN/giFQvKA1dZ+1N1rnTedfLej8e7CoISnsG4f7KGtvgG/Jl3ZedGV1Chn9x9QwYD0MGRm3PIusco38x5887vRT4nkdLCuqVQsh94iHcu00+2gsTRDj2vzWARboXIwfgV1CaHc69QFWfdVMKRbNRmkDjDfZCSfk/3jRRd3aZXWIFjcNRyJKklGbwTPrFPJ4bpMYYvF4eJKLPgt3IVqG26jOxjFbRgJtr/VFCN25mC6+WLXtNHK7ETCW56D2QST34tynOmEaKgO/OuDNH8e335Oa1fnP7Oa36TH8xpX4SVwRZhzwj3FHIqX4c+C35vzokBAJAP1TxXbrXIgIMgxzzK8ruA9uyKCCzhYFjV4+zTQMoSZPUFvoiA8VY5Imq3y7YRnj2Ev6hwgOgHS3ruBRUkQ9sDdNUeeJX+vIHeQpbMQ4uYuamPn37zxfIXRNJIqvWEqAw4/ndtgFIzNfx+rDftZoHWoeP1Ut+4TEul4CW0JoyonsXQ74IYv/ZhclEdkcGmD6M
 e4e5GUKu
 hJG2lWAYOgeP6KToaMSpgftxiXmAAPT4d4wIfFz1E4OPilgLQmPwlMd+W6hG0rDjCTc3bmw0sFPOR0yH0b0HbUwV9Cdlu4taTIFeLZEO+ehGSKVn7D+xjjHmqp3XCc9+sHTklXwhfb5w+rIatot9ITp+m2NHdpfLknjBSKxzLN1/buNG+Tdr4PH1iCgxP8bdSTS0kbAv+nkZFQXcI1YoXPDbYaRuWoGaFmiMtv7dwJaB9ta5SqVov7/etnb5Hqh1XYLKGZfGmsWUBgML76JakYhyOlKnF4BoueIxNK4OsUlV4RHIv351me2v4UovX3LewIYX+z18adxx1fDzNmhoNckxEYddX5xw745/O8nBAR9thkGDzmolfLuKg7D0sAmNjmCpf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/25 11:15, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..fbdbf7c012a0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16127,6 +16127,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Mike Rapoport <rppt@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
>  F:	include/linux/numa_memblks.h
>  F:	mm/numa.c
>  F:	mm/numa_emulation.c


