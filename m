Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6FDEB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C886B009D; Fri,  6 Feb 2026 05:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736DA6B00A0; Fri,  6 Feb 2026 05:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1346B00A1; Fri,  6 Feb 2026 05:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA076B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:03:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 026F01B2D7E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:03:14 +0000 (UTC)
X-FDA: 84413593950.01.E6F21AB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AD571C0007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:03:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kTE0OWlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hRfFyKvz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t0uXKtS8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VsbNk6cO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m4hRENV6Qi2+EFaSdK45nduQDaaEEMijGnDDFn0cS8=;
	b=G6KO0pPkGSFVkTMsfXj57hLb/LG3c3mhn1B3WMGwjIcfTK+UQ/L7c7NPknPw1e7BVoKgeG
	B8OSQGKRO5jl5WgJn0UxNM0zucJTyrB6ILTCgohpN3O9N4OGVbIjneDHDu7O4SzGM7auf0
	8bvTFf7u+mETZw8UReWGKPRQgvxyAJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770372193; a=rsa-sha256;
	cv=none;
	b=7HbIYERo3TbqJmMreuJUEI6QRYL/GB5mY17xWm41IKjQc+qZk59rrzZF3mZZRArNx7EHad
	fMvaP+5PlzJs3WMrSJRsdx5tO1RXKoBFP9qhPSNolM18bUYg+DkZhBDgKYlaZlUZ0FdNlY
	Rf2HYcYLI+ReJrVaRq1OZMqim4PiE3A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kTE0OWlX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hRfFyKvz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t0uXKtS8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VsbNk6cO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AE535BCD1;
	Fri,  6 Feb 2026 10:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770372191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0m4hRENV6Qi2+EFaSdK45nduQDaaEEMijGnDDFn0cS8=;
	b=kTE0OWlX43omvQagnz3csrLOmjR+a56zzIk6KbmjAfM6B/o+40FL/gjoE36CQSmjie+BBY
	KGc2ontBK8Sfr/4Y/e9QdoJ4ArZopLb6kisSqq6CjIcy94dDyAb9MngcqAH0XZ4UXyOc11
	3mPEjVwBk9WRUIL6lJfxc687wB6kMzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770372191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0m4hRENV6Qi2+EFaSdK45nduQDaaEEMijGnDDFn0cS8=;
	b=hRfFyKvzthTzRrapssO+AvTmcEDtWn8sk5sqlanur27VYqDE1aJ95DoyYDLnj0JQYEqXvx
	8ZPYcIi3to4RScAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770372189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0m4hRENV6Qi2+EFaSdK45nduQDaaEEMijGnDDFn0cS8=;
	b=t0uXKtS8SWlA9ckngzvk1Nz01CvThdYtv0wOv5ASfjK4uLdkIQfadOXhYdOb525U6XTYoA
	9tfBZ4F6hcHXQrM3Zi5YMiUqZC1K52lsq0IvcuyvI9H/tSoKXchmT89mznHm5YY3mA4xsk
	7J3G44/ODteE6Q7kfL0Gy5tlwviF+fk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770372189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0m4hRENV6Qi2+EFaSdK45nduQDaaEEMijGnDDFn0cS8=;
	b=VsbNk6cO4gc2gGLTMWqUhbT9FwDfSm6fOIQqgMqnI4Vic2PFKeE9c7R587qt5B15k94Qed
	vbxi3NaVEvh8KwCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8D133EA63;
	Fri,  6 Feb 2026 10:03:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wgnzN1y8hWktVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 10:03:08 +0000
Message-ID: <e924ce7e-29c8-4853-b1c2-3495b8cf8427@suse.cz>
Date: Fri, 6 Feb 2026 11:03:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260205120709.425719-1-hao.li@linux.dev>
 <aYU7l6P2ikKvnrWT@hyeyoo> <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
 <aYW732VZACRIzr-r@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYW732VZACRIzr-r@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9AD571C0007
X-Stat-Signature: hi4cykjsqq73949ign34r8ejrruuwot4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770372192-685383
X-HE-Meta: U2FsdGVkX19NlDdfr58K3mqgXfsX93+00AI2KgnoClwSjarEZkjssuckPJoWXMvXl5SDdoaDVj3AK9NxA1wA1pBqtzonJ494EGS6Whe3QtJXAaIMiBJGJfcN+oP/eV8d8cMi+JK0MBlFTs44O63Klk4jq8Ay3PYWmBIB87kXE0B3FxBflD2V2iUrUB3rAbe2CW4KucXVl1hFAhpObFrdHM6WXDpP0DiX3FL3NX5fz5oGYudtqz866PyA9bc0GWAqrNoKvoQdZxGWvRWF0lLtkZ0TQLF9jrKJFv3V2YOVs8PbKEoCbIfVGA1SpUloHC1ayu76uWm41dpKUkKlKrv/HQy1h1DQy+cqODGeocCEwsGeK1U/ZjAMSbRwj/hRSFvCjIDDkTxg/VaZC/t1jpgJM/airrX3J4m67XXQR4u+xGmSF265WP2Ix/omo0q0z+KvZvpTL/dBIjbIMwKVGPbRw1/yE/jXo0rTCiddPuRCypfwlD55++vbglqhrNWvZ5DKplBKGKCKvyYgMwFZdbJspD6c7ZwHNkEcrAbFXRhLLD32cIgeWAfOmzPel3zCVF3ZcYnym6oopXQVOEarGpdY9N0AH77bGFhFVet0s3KxEwSGwoZtxU/0aD5YoZfsN2wqou/4E3toWCT0j7rn6cBDaM7JDRsUSjJVxmiApvZGHqqZ6ubdeuprYu4OhsFMOL0NSB5p4FA1rEXyFWiGx0/cERW+RDBAiAjeWkBRJfV7decNt1QYx5vE4MQb7p8pDtUEG/y/4pd+3lZ3Xac6mrhz8PHtFal2qd5nc397aMvWrr2mr57w6IO1keIGEcke2HpZQslmI5MLxw8de1ylz0pAgeuSOC4CRuqJazo3XKf+wQ1I/J4pQZuDm4IeVx/QbdNstPKMEb3tAzULqI/lX1WF5mZurf6uR/QG0WpKbsZezU4tOp6ccUIAofi1vug6XEdS/tkJoriMQg3aJdC+On9
 lExJ4mpT
 qpIll6PaGkLDBf4OmrpAIdU8Nkx6QH4i+jGbo89VXbBkj5+HrXKER772Newig0hP0ep6HZu96tgwM0b8UBwVKeMeAfPiMHqabyDgRUMO4w7ZoCNaZ5NiWB1pBaSmXDFoFO7wSZ6DUP7x1Zmi6uFoa7XI6B6/VRtPqkPnspKKC6M9KSBeU6flZbWSbCQw+hB/kCUTI5WPDufutui2dfnf4X8OUZhyqDuWtqk9sNUXG4gE/I5EQ+3N0r9QTmRLc26kqGe4M897/K0Zf/I0EOHlyghXlnsLMDKViWXyoROoeC61Eprl8xqcaIN/gh5ISjE/eaRfqQ5Odj+mGsoWe8jgpwPQWbxt8xn4QRsR/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 11:01, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 10:40:54AM +0100, Vlastimil Babka wrote:
>> On 2/6/26 01:53, Harry Yoo wrote:
>> > On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
>> >> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
>> >> check this flag. We should return false unconditionally when
>> >> SLAB_NO_OBJ_EXT is set.
>> >> 
>> >> Signed-off-by: Hao Li <hao.li@linux.dev>
>> >> ---
>> > 
>> > Looks reasonable to me,
>> > Acked-by: Harry Yoo <harry.yoo@oracle.com>
>> 
>> Thanks, added to slab/for-7.0/obj_metadata
>> I think it doesn't change anything at the moment?
> 
> ...unless you enable memory allocation profiling :)

If I do, would kmem_cache or kmem_cache_node caches gotten obj_exts in
leftover space?

>> But a correct thing to do.
> 


