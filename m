Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4298D41170
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4BC6B0096; Thu, 15 Jan 2026 06:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F166B0098; Thu, 15 Jan 2026 06:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77F16B0099; Thu, 15 Jan 2026 06:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B848B6B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:07:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D2DD1B239
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:07:08 +0000 (UTC)
X-FDA: 84333921336.05.8E0AEF1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 830EB4000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DzIHnt6o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PhtbcgpZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DzIHnt6o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PhtbcgpZ;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768475226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMDfavExPfC/FICQX2UPPaUz4Jt0PBH/HWBal9RBdsk=;
	b=C6yHLJqAACOs2MTCAQTS0iNYtXg4p+xbNPRDgbVLF0/DaLUqXGtbUT/Ol5UdzvD8o9bRW2
	kjvEbQ1e5bbYCiEQPgCiJy+uqt59+BOwgnlNglcnCSqpHNJGsMBr4KfT1PVtzPsmZLFPis
	+Js9V94YsvqJ0ThUez1nD4YrVmV1mPQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DzIHnt6o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PhtbcgpZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DzIHnt6o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PhtbcgpZ;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768475226; a=rsa-sha256;
	cv=none;
	b=yxOTyfIOfVC8eTjjpveqImIjWOJlY5WeR93nAclAOl+ndlYOHUGEis7wmYwn/WdK0KyfPe
	f3ZXu/VGsnEOHQMrXnIIjt9qT07gFChTKRbHqSH60MhTZ/d6kEyg7Goc/+jr5R097GhZCc
	DzFheK3zq9T5gsdgaCaZ7IGJasBl44A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98CF55BCF8;
	Thu, 15 Jan 2026 11:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768475223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMDfavExPfC/FICQX2UPPaUz4Jt0PBH/HWBal9RBdsk=;
	b=DzIHnt6orUzRCjYb5JLGvRIpeE2yHI8uAaXqF1/buvFeALUtevEkxBKxl5pX+3iw7H8IS1
	SMeuEAJLgYFCFOrv9ypOg1zRnLXB2bqmUO+1etfT3Hceu2BHVCm8vs/hirEG7qCOlvSwCp
	YtTspVNOwogdFPGqgn4QvWJjEH0dcU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768475223;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMDfavExPfC/FICQX2UPPaUz4Jt0PBH/HWBal9RBdsk=;
	b=PhtbcgpZ28KPLRtLV9294kHuGiy0/i83FiDqUxx9XESVkVGJz7TRpW09X1o1ZA4GyDKJ3j
	xQsQVuAuh2fYYrBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768475223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMDfavExPfC/FICQX2UPPaUz4Jt0PBH/HWBal9RBdsk=;
	b=DzIHnt6orUzRCjYb5JLGvRIpeE2yHI8uAaXqF1/buvFeALUtevEkxBKxl5pX+3iw7H8IS1
	SMeuEAJLgYFCFOrv9ypOg1zRnLXB2bqmUO+1etfT3Hceu2BHVCm8vs/hirEG7qCOlvSwCp
	YtTspVNOwogdFPGqgn4QvWJjEH0dcU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768475223;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMDfavExPfC/FICQX2UPPaUz4Jt0PBH/HWBal9RBdsk=;
	b=PhtbcgpZ28KPLRtLV9294kHuGiy0/i83FiDqUxx9XESVkVGJz7TRpW09X1o1ZA4GyDKJ3j
	xQsQVuAuh2fYYrBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 784253EA63;
	Thu, 15 Jan 2026 11:07:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +OwJHVfKaGlmKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 11:07:03 +0000
Message-ID: <d0f5f72d-77de-4be7-990c-a5e47f326dd9@suse.cz>
Date: Thu, 15 Jan 2026 12:07:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
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
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
 <2hsm2byyftzi2d4xxdtkakqnfggtyemr23ofrnqgkzhkh7q7vc@zoqqfr7hba6f>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2hsm2byyftzi2d4xxdtkakqnfggtyemr23ofrnqgkzhkh7q7vc@zoqqfr7hba6f>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: c1djodhkdouttb4rt7kbi3pfjyosk8o8
X-Rspam-User: 
X-Rspamd-Queue-Id: 830EB4000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768475225-674322
X-HE-Meta: U2FsdGVkX18yCPy6Kwc2Xmi9cS3eFit4DSiwZgy5jb3kR3WNP6JcHsME4rvZ/lw00O0q7N+MP0fhjvvqA5wK1nsHICKsSj1/P+MMqoZ+iJmXTp9x0043ia03g3NfZ9WMBdbVtRLIQj6pzwY8AbVy6seZoN+/YygmGrRwq+1Dxvl+gBKjYCfqCJIw2lTdgk31ZFFWcZF0Pam8Uw2G2hZcTJ+VNAEOpHdlBuyHhXD4I6yzpdSDYYXp16K114zzJY8vODC1UVM9meTUH3yw5Y9zdl+QsRhdNtzmgdIfbpSaO4bSs4gTvegQDFrROR0N1TfrUy718Dyfe/4F4qVOJ6sEJpUM5VnUniPaao+XXNdaHsZ5AOxUw48LSqZ/CDMCVjOo62gTX2ze+vuN8Kaxy+qP08/CayuFWnYkmhFOYwnaH6i2oWKL7FSozNZKTobQGfTw4hErVRhb55LphzBKrXWxkVr7iUziOSOiuonNvooEwBRlJo1U2BZmx7GbTfFOXXdXuEGil+jU1ne7xCQcgluRyE9aEPbspvlQdKh+MjaP++AieLvwd3dpnKR+WAT0Q1hTgwICCb1uFfu0CV55y7zO4JdWxE6+T6z7w5vmjMRNSCtEbVF0eYBbXl3YIb0DkoVHevAZXEI81gtnBSRpBovT3wWxfw11igSeY12UPbqssSGF72/EXKu9PlJndwtCAGs8jDWnVt9qUS8tX9/crLbXsbT1/0DE7PYFd3zYjfGs5ujogKxiWFAEQEE4FRPjwrDQ7CgqmUqU/Xut/2vLMIm0CjgcOVNS0RVPKUhina+C9Cc5TndtXzZ0e7QV0AefcA4lKzI5UYXJSnpC8xQlSBp0Ea0kx1Mr1pUEdQxFzrmBr0/lObK72DJEqfR3cr+p2gQpUqyWItwHF5GiiVHvbQeTd5EvjfmRCow8ks+xPU/p888tBuwjNXbWWVkxi+nhbHGCsmTtOrnzpSCeqgBxdB2
 jMAo5pqL
 gLwzxewG/N09mbrgxKe+wr7kQGzigVXLTHNdBqzHY3tj00EQx+68J0ha5sTsd6OOzeAvlZwTdh5WooetBx2gFFrHgDCNW5xg91/Co6UkWLFNPrI9AbNe5eI8nd+UC9p1SOAT624AldbV1cF1LkoWlKWRGaPaptq2pr1FJA6vocog8AD/pypmsHx8cMhibrcz03gNaxI+3bKt6J2sI6dyvigctal5p6GN9r0+iMQxii6alkNZz5Qz6z+bwaNV92NXFi5RTJ8i4MIgh037uhlh126bmV1kNn0vR8MPjwc0Z63y9HNPeayXTLmUMc8MIV/iiCAnFI2WTjv0opOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 16:42, Hao Li wrote:
>> @@ -6129,6 +6152,17 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>  		return pcs;
>>  	}
>>  
>> +	if (!allow_spin) {
>> +		/*
>> +		 * sheaf_flush_unused() or alloc_empty_sheaf() don't support
>> +		 * !allow_spin and instead of trying to support them it's
>> +		 * easier to fall back to freeing the object directly without
>> +		 * sheaves
>> +		 */
>> +		local_unlock(&s->cpu_sheaves->lock);
>> +		return NULL;
>> +	}
> 
> It looks like when "allow_spin" is false, __pcs_replace_full_main() can
> still end up calling alloc_empty_sheaf() if pcs->spare is NULL (via the

Oops your're right, we can't allow that. Thanks!

> "goto alloc_empty" path). Would it make sense to bail out a bit earlier
> in that case?

I've reorganized the code a bit so it shouldn't happen anymore.


