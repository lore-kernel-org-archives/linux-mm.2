Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CE7CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C66B8E00CF; Tue, 14 Oct 2025 04:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976788E00AB; Tue, 14 Oct 2025 04:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E6D8E00CF; Tue, 14 Oct 2025 04:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 715AD8E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:44:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D0B814079C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:44:56 +0000 (UTC)
X-FDA: 83996084592.24.E478F16
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id C2F9D40014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:44:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lcPnfL/v";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kva2MJ8T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lcPnfL/v";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kva2MJ8T;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760431494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANUC3hKAI0bCABKTkro2jRglDTZyJwKd1BejQWPoYTI=;
	b=5UB5Zg9iFG27ct+1U6rBmBCP/r4SQtj7cQdVHIfO6gga87iJZ/pJDxOKSdtzdB46985YwJ
	xjQdHSFgb6FmGthjV1ViSA0701Nq/eaGh5O1MqNQlIMXvQc0r4mNpH5+mWDXlGQsEbw163
	QZlbUpyqZrUqos5AuK+VoQZ1aBhrU8s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lcPnfL/v";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kva2MJ8T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lcPnfL/v";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kva2MJ8T;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760431494; a=rsa-sha256;
	cv=none;
	b=Mz4MDotvUdTwjO1c1VfX639EyF9NFZBLRN+GLMAwkb5ZxVaB8blBhinSPT++CgdJx+mp9l
	nMvwcPBcgT2z9gxsc/yyQ7CS6NBVfwfrD8gic++jQb86tadIXAQhimN05Wul4u59YgD72U
	N3InTIaeY2JDptBeqCxmyw7x+bFlKTU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2281C21D1A;
	Tue, 14 Oct 2025 08:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760431492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ANUC3hKAI0bCABKTkro2jRglDTZyJwKd1BejQWPoYTI=;
	b=lcPnfL/vprB73w0iDnhG0IUylA/0bCAbyxxtXkTOGDWG3MI0Qdm4yt5633QELtL7ulp4vO
	rVDYgDuvZXjvJu1diMPcf/1dWpdEJzz9R+jVMQSO1Z5LaGykebkBx+iqUZ10NHxFkOq/7A
	R6Oq/Hp2Q+f8/KN+BPkX3Xy5e3+M5kY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760431492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ANUC3hKAI0bCABKTkro2jRglDTZyJwKd1BejQWPoYTI=;
	b=Kva2MJ8TY60MC79d/SjTdFUPC6XgCv5Ayf5uEU1q2Oq3jS5wT0AePwmGMBrGcn5ki8MTeO
	BGNlSlnbnPXtbWAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760431492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ANUC3hKAI0bCABKTkro2jRglDTZyJwKd1BejQWPoYTI=;
	b=lcPnfL/vprB73w0iDnhG0IUylA/0bCAbyxxtXkTOGDWG3MI0Qdm4yt5633QELtL7ulp4vO
	rVDYgDuvZXjvJu1diMPcf/1dWpdEJzz9R+jVMQSO1Z5LaGykebkBx+iqUZ10NHxFkOq/7A
	R6Oq/Hp2Q+f8/KN+BPkX3Xy5e3+M5kY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760431492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ANUC3hKAI0bCABKTkro2jRglDTZyJwKd1BejQWPoYTI=;
	b=Kva2MJ8TY60MC79d/SjTdFUPC6XgCv5Ayf5uEU1q2Oq3jS5wT0AePwmGMBrGcn5ki8MTeO
	BGNlSlnbnPXtbWAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10D6C13A44;
	Tue, 14 Oct 2025 08:44:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lLXQA4QN7mjJIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 14 Oct 2025 08:44:52 +0000
Message-ID: <1dbe9c35-9ce7-47b5-ae32-f406bdff58fd@suse.cz>
Date: Tue, 14 Oct 2025 10:44:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: fix clearing freelist in free_deferred_objects()
To: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: kernel test robot <oliver.sang@intel.com>
References: <20251014-fix-freelist-v1-1-e402301f276d@suse.cz>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251014-fix-freelist-v1-1-e402301f276d@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C2F9D40014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6btjucj6hrunkn7eeu1soc8rtxk9zs4s
X-HE-Tag: 1760431493-255258
X-HE-Meta: U2FsdGVkX1+KeBuugV+AHjyTwBtYTUbdo9W1ssaO2s+FKPX7PVohUe4Pl2AmJQ67+b1GsBSxF5r7803sypIvbeZz3LAWWPFv8PnVdrv6Q2BD8YglAId2GTp1MCJUWshQ8bhCfwkVrHgfKggGrRMk5XzeVdb7tBaBkbnIj9R8YCWMLQTWtaiF4eRiK67sg/qy+QDFki8qoYDGufuLWv6uO+Z8rGLjwTRr5RQDsnk7n/uDufRsmiGEbxWLWhwJiZPBZcYcqra1VIKKsD4qVwj4s9Ng/HkbrGnnua8OoSIWDBOWCErgVXKHckMXKuSa0A5WDxHQlKqQVUzVpz8zH14mlOVUzvnNXz1Ory9GR8VZvAi6b3newHtIf0UAMn30nNH5GzjfH7iDS1qkOXCosMZUDL26Hm1extk9LZC4QoLcImSauld73dLKGb5AxkfUmxvjCaL86PDcvmEoSEoUpIXAHESxSQd0KI3xxwrZc5J6Qm3i43u2yUW4nXXSD3PCfmOdbCnl5fCyrIHsPgdDH4kxpI7h9acZBIYrKd5mBf+/f0/EMpX5U+wO5j43j9q4mvfu/XwHkAcEhdOFi7o+2mReabVpxWLvml5aHBBTRUrAHSgvmXsAeopo02nBBLU/0YYG4yCNLX2glYcSP44NL4NLrJHKDGe4BDLlwviThb54e0vS8w24Tw8wBBccaowE2GXs+k28iXQgm8rp79kdiJxAk55GWSK4sdpMiIsVX1jzK38A2RRLQtZ2YUJarbtCIeKky/NQW7woj2yrUEkA6TnT8N4z+Aemc7XMhgj2qrchw5ibaWgRQkejJd+Qhd0SGOe9LyVvDNdJGRIpIcIniXuYjtczkYebyMl9nI869alG3MSqFRWuw/RGn4NvY8vkAly6upKUtW52e2VRcoIVq5m2GoDtpHB5F6tum2fOfK8FO4iL0o8dgmWPRduEt4EnoUrh2NoKEMHQMgrcfgroLFR
 LWxg1VxK
 dbZtTiFlqhmsQke59Ns4udvzHTMvp3vzXivDf0qTwMa+bmmxJ1WVhqo6XHcEZloueRuLoB73PFoeaB3l+D4YQb63jibuJH97j1xXSW4dG+949tMve8qMTufblmTemJWP2lqWhrenq/cYZ65ZN+4uYrn5ypU1TEGYxw9a/tjT2rsm0IgOv2e3Qkq+7dPuDzvKtXxw/WXPv2wRJD0RafV0S5jJEGIsaTaW1TOf8vbbo00ySEKBeiyvhmlvZwb9uPehsl1qTHAEwaJZ07pvSx0XrM0rC4F/3hT9sQGQBjDbWE+b93rHqr+Dz7u323B7X+Ze46tGtz7hNrHNDUUHz2wqIdz6AjX+zR9tolYa9T6uHPcIE8UhquRlcxFNlyJRhlOGW1+ci
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 10:40, Vlastimil Babka wrote:
> defer_free() links pending objects using the slab's freelist offset
> which is fine as they are not free yet. free_deferred_objects() then
> clears this pointer to avoid confusing the debugging consistency checks
> that may be enabled for the cache.
> 
> However, with CONFIG_SLAB_FREELIST_HARDENED, even the NULL pointer needs
> to be encoded appropriately using set_freepointer(), otherwise it's
> decoded as something else and triggers the consistency checks, as found
> by the kernel test robot.
> 
> Use set_freepointer() to prevent the issue.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202510101652.7921fdc6-lkp@intel.com
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> will be added to slab/for-next-fixes and sent later this week
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b1f15598fbfd..64c17afc375b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6443,15 +6443,16 @@ static void free_deferred_objects(struct irq_work *work)
>  		slab = virt_to_slab(x);
>  		s = slab->slab_cache;
>  
> +

extra newline moved...

> +		/* Point 'x' back to the beginning of allocated object */
> +		x -= s->offset;

... here. noticed and fixed up locally after sending...

>  		/*
>  		 * We used freepointer in 'x' to link 'x' into df->objects.
>  		 * Clear it to NULL to avoid false positive detection
>  		 * of "Freepointer corruption".
>  		 */
> -		*(void **)x = NULL;
> +		set_freepointer(s, x, NULL);
>  
> -		/* Point 'x' back to the beginning of allocated object */
> -		x -= s->offset;
>  		__slab_free(s, slab, x, x, 1, _THIS_IP_);
>  	}
>  
> 
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20251014-fix-freelist-29915edcc2f4
> 
> Best regards,


