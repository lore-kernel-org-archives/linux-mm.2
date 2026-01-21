Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5901AD262B5
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718076B008A; Wed, 21 Jan 2026 09:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6196B008C; Wed, 21 Jan 2026 09:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D496B0092; Wed, 21 Jan 2026 09:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46A886B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:30:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DEFC0C1C27
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:29:59 +0000 (UTC)
X-FDA: 84356205318.18.E92026E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 586DFA001B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:29:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBB7CzWA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39idVx3n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FE8gmbsl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N9xRFMEt;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769005797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIKrSdOKFX1Ry2BJW14V2EgsIVuZhU3Kvixf452GPhc=;
	b=vSmzTLybGd7miD9l8JL7TnZrgyjXuwh1wPwTQGSO+0vbHwQDxPrcu0NYJBKCHTS0482sCj
	1fieG/UAtIRWAluT/O2kxt8OdgZoQU74fe7DENJrbeiso4VbudH/ZMJUcYAg35Ac9hxR/i
	8gvZW5v4A/VgLzyY1iciq7o3DyO4v1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769005797; a=rsa-sha256;
	cv=none;
	b=oRvnfdgnyN8zkI2yO/ZnTjm70h1P+aE6YMoZblA1Dxe8codOrfbAonl1bOO5pPqA7XfZL0
	T+pXNiBfd3i5mkEN87knZwD4iZ0f1ADCz0WsrYZIzhZp3GLTdBRPwr4kosdJayRbvhkwRX
	tkbdaaSHpz/mxv5OfOJrIRY9HXszfHM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBB7CzWA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=39idVx3n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FE8gmbsl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N9xRFMEt;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D2685BD15;
	Wed, 21 Jan 2026 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769005795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIKrSdOKFX1Ry2BJW14V2EgsIVuZhU3Kvixf452GPhc=;
	b=xBB7CzWAouJ0kG95KKwkW546C9uL5czxUsBVovivJalqyIkjof5v8vYNHpDiwle256xtFA
	TtNyw/QyQ/7d7Zwk94WTbrO1lXZRM3bnqq/NXF//AhHQKLcAveJDHd/+uagzKrL/Aa3toe
	PE7bplHFEE3uJToIJ7dC5tF0BTMhKac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769005795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIKrSdOKFX1Ry2BJW14V2EgsIVuZhU3Kvixf452GPhc=;
	b=39idVx3n6h5+DXybmopkhyO0nGh/uYxuixQ1s3bdUAxxoo8Jp2cGghBRN2iUuOl/oSkNF/
	MTwsJaZbnrIUVvCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769005794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIKrSdOKFX1Ry2BJW14V2EgsIVuZhU3Kvixf452GPhc=;
	b=FE8gmbslymHFJlFqwlCRhTDsEMxastWZuOrGMdE2QXKVY4qVv4ObD2wpGvjXrrf5BuWVil
	t5toaRDd7Hn+16fR4bF804yylPnRb1qcK5bJzS2kW5OX47UPGcs0C7ffq6SaGAoqE1Io3r
	SW/cUTe/mnlz1YkbScLENDhtH1mCGoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769005794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIKrSdOKFX1Ry2BJW14V2EgsIVuZhU3Kvixf452GPhc=;
	b=N9xRFMEtPfyQfMgDc3dnTYtpKgx++e71L/jfDP5y8wulUCncRiaEpEZKY7M4ESp9XTVoEq
	+0Oee3+VY86EdUBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 306623EA63;
	Wed, 21 Jan 2026 14:29:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kut6CuLicGkwbAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 14:29:54 +0000
Message-ID: <6a814aef-7b81-4b9d-a0a5-39f7dd7daf3d@suse.cz>
Date: Wed, 21 Jan 2026 15:29:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/21] slab: remove struct kmem_cache_cpu
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
 <dxrm4m545d4pzxmxjve34qwxwlw4kbmuz3xwdhvjheyeosa6y7@2zezo6xejama>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <dxrm4m545d4pzxmxjve34qwxwlw4kbmuz3xwdhvjheyeosa6y7@2zezo6xejama>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 766c7k588zdbqyf7uaphwn4ponuqtq5w
X-Rspamd-Queue-Id: 586DFA001B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769005797-706930
X-HE-Meta: U2FsdGVkX19M9ieHl9nsgXiyHmkFR5MHjMicG3FWg4fjh3URfy5eFV5SWdyqgPQiXexQR7UqDQ+aofBQBJTd7rB5t7Gz0nct7HnfAtOBDUyUwhLh4LlynXA3a/GFJk84o0CU+yDXXtMX+TjlhRM/n0OCucnLisivQJjcyaOp4aDab/o/44B5zBRFA2/qjP2ikODfeXUhmwwz7l6fW+0gl7CWKkdAgUAi6dhQWxwdCuhe5zd2mfM8rDOak7WsXMVVKDgyy1NiYFu+aMAPi3QMfRRbzZbGaeW9Do91mOgRgh5UlOUMvaNoGlJKI2vXl3ObsNwcNPNnW3xF8wh4+2K65Zn2M+Y4yptM6K1HGqFqDXCCqa2IhidIllLivPmh+TcsG/sGLKuzdbB0VXhmORK3KyZp7g9Eazs8AjP539YXVDSuKje9nu/LMFpmfed/tFewZzs2crYHxnoepij6wszgqb9rqzW4oxjU/0zPwi2QuzZBetf4enn5s9U8inn7RxUuqKTnc5TAfn08+vcy4yjsSb5P4qM8UZ/RwbO9RvE4AGZRjDVB+nFqcPuG3Y9t6g6mtdHwX3T+HGRHGh5kC1SnfS127OOZxImYiQlCYjrX/aHSbUOe0IMeS2r5x/g9vWzzzRcDrZ1dM6WlxJUQmWwjLgXiiM06L7IW/yt3mZZJ9hA6Qn8pVTXbhhwuK2cTRqwbLIzcqZ8lXVtQ7Z3NQfT8Nr0nDdBYds+BibG4cKAwIQcrUqfsBw/3bMyhWXjoW+959Z0Uw+FecEvSeXxDKRXYTvD39o8AV939uJaT9/meqMKtuWtYSNkhIgWsL+/R6ne+GONcy+qxcTq6mbcOTzN/4/nYHz/IzQlR9CM1Jkor2cBj9v0207N50XpkusuuxHe+sLoCU0B6Q4kX+RnX2cPlNLKNKOT76yaEf3GA6+SsTd/tfsidUE3Qa9BvQK/WL5o3jFJcONzZhb4kWqzcyU1
 y5fCzxkA
 8c1Xk4EJ/nu1LeTmOqkTpfi/P6u5uwZ9GHEAkQ0E1DPhTD501OY0GRSrSiTtBGeM7u99oMT3AFUOfMfxSUH+z25GhCkYJgzZHEFLl1oGXj/RWy75FjTIHyEHtdWMke0IEoN1iO1//lTTiCWbjWD47s9pa0RUYQ4EFMZpP0Sw9JgdFRqHr9USoMLFpokv4vOUagnQrMPF9VXyyWxaPbI8dTsBj6YjlRauKtI/KYGudE6qxtRQntq6OognskpzKt3INQ16QSXaHxD3IS2hScrJ9mnztKXY4LNz8eGtzgUgxhq+ne80tIpQBgh2cn8BIElsb4uABsdDBRVl9dtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 13:40, Hao Li wrote:
> On Fri, Jan 16, 2026 at 03:40:35PM +0100, Vlastimil Babka wrote:
>> @@ -3853,7 +3632,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
>>  }
>>  
>>  /*
>> - * Flush cpu slab.
>> + * Flush percpu sheaves
>>   *
>>   * Called from CPU work handler with migration disabled.
>>   */
>> @@ -3868,8 +3647,6 @@ static void flush_cpu_slab(struct work_struct *w)
> 
> Nit: Would it make sense to rename flush_cpu_slab to flush_cpu_sheaf for better
> clarity?

OK

> Other than that, looks good to me. Thanks.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!


