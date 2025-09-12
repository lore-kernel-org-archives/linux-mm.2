Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C59CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC948E000A; Fri, 12 Sep 2025 03:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4038E0001; Fri, 12 Sep 2025 03:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3148E000A; Fri, 12 Sep 2025 03:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7EE8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:04:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12B4213B977
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:04:00 +0000 (UTC)
X-FDA: 83879708640.26.1EAF012
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA7A82000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:03:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YAw3MQpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r6rquoKC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YAw3MQpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r6rquoKC;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757660638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hb+M6nmwYLobuCedusXEdpwyQSQdI3DZay+vrJXRqEw=;
	b=wDkxhGPGZVsNeAUtNzVITRh5pSdNUZridsoCZrIonJz3LgTqHc8i/VnvcAF9u9JtGjb/yI
	rbnpdecmwMce3ERV5fBDpeWyBVndi+F2+HStTtbON+PpDTi7nUnnTdhJHGCZsKGLMc4fhV
	gfdEqElXVW4urJrhvAi/aIR/KIe2NBw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YAw3MQpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r6rquoKC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YAw3MQpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r6rquoKC;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757660638; a=rsa-sha256;
	cv=none;
	b=Yl+0IHC7MiqzOjVUCHOc+L7HLM5XfoEU4rkb4nhfDbYplWP9mvbya78Dx23OXLWpvOjt7B
	idPaOc1SeVZoj8/SEc8ddTRcDmOqPONiL63SAmuQ0H3y50SogY+NdH4tjZzGs9AB3tqvOP
	GxssgDcvjG5W07OYtfMiK5Fuwl1ZxLU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 235683498E;
	Fri, 12 Sep 2025 07:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757660636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hb+M6nmwYLobuCedusXEdpwyQSQdI3DZay+vrJXRqEw=;
	b=YAw3MQpSQMNJzqxOgp6MXtaLAHbZz3Ns9UKk+gw++Y0CGtMedZTNdmqBZ5OaOlmt76FeZS
	Gd89kNPnplmgrpq1q2eaohYhLZWbuUDasY9eOxbez/fFuEN1n0AUyJot9e1ND0yZcySfwu
	OZ9W1AwBUh6ct91p2NxpJesW4l9K+LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757660636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hb+M6nmwYLobuCedusXEdpwyQSQdI3DZay+vrJXRqEw=;
	b=r6rquoKCeW9A5SHzxgDfenOh5wd44S8lpFMwMWU/8QTAN1wX5hq4CGMX8Pkdiia4VirwdD
	tjhZsKsOa52yKZAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757660636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hb+M6nmwYLobuCedusXEdpwyQSQdI3DZay+vrJXRqEw=;
	b=YAw3MQpSQMNJzqxOgp6MXtaLAHbZz3Ns9UKk+gw++Y0CGtMedZTNdmqBZ5OaOlmt76FeZS
	Gd89kNPnplmgrpq1q2eaohYhLZWbuUDasY9eOxbez/fFuEN1n0AUyJot9e1ND0yZcySfwu
	OZ9W1AwBUh6ct91p2NxpJesW4l9K+LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757660636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hb+M6nmwYLobuCedusXEdpwyQSQdI3DZay+vrJXRqEw=;
	b=r6rquoKCeW9A5SHzxgDfenOh5wd44S8lpFMwMWU/8QTAN1wX5hq4CGMX8Pkdiia4VirwdD
	tjhZsKsOa52yKZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0576713869;
	Fri, 12 Sep 2025 07:03:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /+UDAdzFw2goEQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Sep 2025 07:03:56 +0000
Message-ID: <298f6a92-7bf0-4cf4-afbf-554ef3e8e7e7@suse.cz>
Date: Fri, 12 Sep 2025 09:03:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <iycnfietmsgggxcdjuqngjuzbuygsxfpvkcz2fwm4frdxin42u@pxhmqcgejnov>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <iycnfietmsgggxcdjuqngjuzbuygsxfpvkcz2fwm4frdxin42u@pxhmqcgejnov>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BA7A82000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7drrussaqrkhbb84t8z8rgryb9k5d7du
X-HE-Tag: 1757660637-588038
X-HE-Meta: U2FsdGVkX1/4xDahmJuPK0XH+8Fgl5h1wpyI0X+YCXUrcThfFL10KtpZQ7QaHACwBXjTbcpkJ8em6kr0Hm5jI0G9jxez54cm2+aLR8PiBezHTnDN6ufTWhZJPUtlaioIEaxFjqjrQB4u0AuY+/4QP2AI8AGZRr0hmHyemD8P3R7dJrOefZeluMFT0ZR6e2blNwvAuBOrZWKum1qeiz+TJBdgErDKSobbwgavS0L9mT916OhlH0eEYP6GQwZInIRn7esCsoaZZQu5xzhaJcjhi8RwopMvz3H4qJxBp0Wq9qEgJTekjd7kXM1yO7btHSX8F7We2gKZ/dFR+4ksq4JTeFDtCjQIo/NRmp4MoIgoGSf/W7RpoPbkVrVZkfyxLi7RK+C5ksULX29J6b6yVcnYPXS/nkt54F+8JmTr3tY2D0xFLmrduM5ir/tVgDOozQXlJOMvyVFh7jn4ARnz3ObCz49EET7GVh4AMBVyHiXQgpMr54hPuM0ASuWKM/2+KCJnsVtFTecbG4EkdekvlLeg21iSgYpi+MDntv3+5OPKAx9JPzORuK5O5SkdhPIMRlFPgKjlzYpRMOBI5M7fhVfqGLLd38FXy6Bmrw2lco29F7CLqapgPcqNOivSLq2aPjn5B7pQtXZ2FwKbK0xKEN5N38jifewAp7AN8ZR/KSrZOPV69L1jWTt9R57HY9GOL+nSIQR9gzMtvR7QnVqA2e+1sKIsgnktkFdIRcFlut+6+axcBVUToaV1XrKfha/nWK/fxxWuN/tjT2dRvqFHTBckZrxvr9CqzkMKkhYqJueUygn/pIqEHefgjVcXMpAzRMjoMFesURvHJFtmMj52MFntoOy9FtAgdDbZt5IX9YsN6ykYlC5LUfgEi+tcj17NiDZmd9yeLIGP8WMvdVG4/ONQYnrKzzwwEcCqQLhZmv+bYmBkg5U3xtaEzs7+WiXfc7iHhCY3JBm4JEZfguGG2lB
 /COTAUR2
 zKRmjNCI9kjiZ8uZ5wloGa1fE87TA+7U3++HAUL5fI1AE1A5IBYvCJpMJavN8ijDDQERVItttvehsvYrypalWJEI+O9pm4h4a93Rs3HDpQehMUUWsujDTk7PYuVIbnuoY4Chw3k6YM15I+nMFiKbCCfQJCl+d5xGrWwkuvq4OqoBJYXz6ACkPe1iQrog4lOl0/Zm2+1ZrI6ebt/dVrK9vqIJ1VR5KyGHte/upReSP0+wi+fNaLDVB/lficu/vq7vfA9tcp0hJwFj6y+EAHil+YZuNQ818qM0sq2A0hb9dujXJJCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 02:38, Sergey Senozhatsky wrote:
> Hi Vlastimil,
> 
> On (25/09/10 10:01), Vlastimil Babka wrote:
> [..]
>> +
>> +	if (rcu_free)
>> +		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
>> +}
>> +
>> +
>> +/* needed for kvfree_rcu_barrier() */
>> +void flush_all_rcu_sheaves()
>> +{
> 
> mm/slub.c:3960:27: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
>  3960 | void flush_all_rcu_sheaves()
>       |                           ^
>       |                            void
> 
> ---

Thanks, the bots told me too and it's fixed in -next

> diff --git a/mm/slub.c b/mm/slub.c
> index 11ad4173e2f2..a1eae71a0f8c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3955,9 +3955,8 @@ static void flush_rcu_sheaf(struct work_struct *w)
>  		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
>  }
>  
> -
>  /* needed for kvfree_rcu_barrier() */
> -void flush_all_rcu_sheaves()
> +void flush_all_rcu_sheaves(void)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slub_flush_work *sfw;


