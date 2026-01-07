Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66ACFCFD63C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 13:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9760D6B0095; Wed,  7 Jan 2026 08:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9290B6B0093; Wed,  7 Jan 2026 08:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1376B0095; Wed,  7 Jan 2026 08:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1526B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:54:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14944C19F0
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:54:22 +0000 (UTC)
X-FDA: 84305312364.14.7825D05
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A10240017
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:54:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NUi+xZcW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I2Zb2Tnw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=STmjf0fs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="446vAx/s";
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767794060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGuntV3J1idHYlamoG5JcaZ3RKqpek8czi0dvq5gqps=;
	b=jHRtz3UbZifUF7lErCOojT7fNFyOMnlqQ2bKS+R9AL0z+6Ey9k8Yy2qwmhWE7xx6XpyU3P
	KgiHw7U8Eb5+P8eFGZh8CB+RKM2xI4aQBiOERQqi4Y64nrtV/eSeP3GxWUigvNyBCS8ozs
	ygSBGqoDO3h8xuz8Ci8ThSURyq2osJY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NUi+xZcW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I2Zb2Tnw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=STmjf0fs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="446vAx/s";
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767794060; a=rsa-sha256;
	cv=none;
	b=BQOHOmBaL+gVK6b1aVk6532YRhCsQFARJjSPxDuFl95S4w5Gccm+w/Kp25a/HIfLP8oQRX
	zFBUVuoYQiLr9g8/oU8lCfs89eEkcLqcAcN+iVV43F9tET2criLz9U4V1gde8EZdbIIOYg
	6GHbBandN4sfOWTKm5WeamJmQKAQBdo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76F535C123;
	Wed,  7 Jan 2026 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767794057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UGuntV3J1idHYlamoG5JcaZ3RKqpek8czi0dvq5gqps=;
	b=NUi+xZcWM6llmAE3Js0C5j62nlWXEoYaCsdOxNbqSH7t6J+6afLJsVG7PPRHqJmRmD5my/
	svsAkjFUGzTM89W3Bx3hIJN6M1mLvpxPTBcLOrzHipXfhE/yZ/bbugdAHgPHBfKuHUon15
	SugQ1vJqZgDWqTJ96PRhnb0t1SN/TEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767794057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UGuntV3J1idHYlamoG5JcaZ3RKqpek8czi0dvq5gqps=;
	b=I2Zb2Tnwks/vNrIxu3CJYRBQXTxoMXt11zJr0hfZmipQ+vc3ae3bQOeeNR9Kguc5HGsuew
	70LqEko7PkrdSoBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767794056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UGuntV3J1idHYlamoG5JcaZ3RKqpek8czi0dvq5gqps=;
	b=STmjf0fshgU821QuLzB9IQCeTzOTfjeZDbqNRxxh0azeCAoX9DsdzSdE+0IHdwcLvd/B9U
	4k/AaqQ2agbwDNPilH09YXH1oC3eReDiSyMF2OaPkPaITjaxu8ahFhd0vvjPyyf+lwiK5j
	PQWhy3z4s10pgPxXEviZNaGdG2OGVkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767794056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UGuntV3J1idHYlamoG5JcaZ3RKqpek8czi0dvq5gqps=;
	b=446vAx/sOr3QbHgE+/e4MkYKT6AEemfBAQM30r+Ybs96pXndLkdflt0KWNaOHJp1I/2FWi
	k3ap2N9i/vxAHbCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F3293EA63;
	Wed,  7 Jan 2026 13:54:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Wz38EohlXmkxIgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 07 Jan 2026 13:54:16 +0000
Message-ID: <e28c08e4-5048-429b-97a0-8d51e494efcd@suse.cz>
Date: Wed, 7 Jan 2026 14:54:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 3/8] ext4: specify the free pointer offset for
 ext4_inode_cache
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-4-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260105080230.13171-4-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: g5pizmjtsc8xjgrj4e9atdaqo548xxh9
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A10240017
X-HE-Tag: 1767794059-8390
X-HE-Meta: U2FsdGVkX1/9r3t4xACieS4+U8EEfdJK8x9H7BkLRAl4S7wfpqS4oqBxQFa3mi8UvddFd22H1ZQGGmuIuTi6Qg5Xug6+20OkzibRUMh0pty3BL3Lp5VYeB1NT71ScyrBgWu6serPWFEmTf2YnluLJxxivusl6qyUGQprG1suFm2vCGQdfqMdNEVDNqYNdAYMVd9gnacg51uaWq9zb1/Kwj/DOAL3f48/qOgW2od5Bd9vmZCFccn3k5HZdzYZ65QpX4bxDdwmwURgVXvqpu6GSR/DM1Bo/pOKKdlna8hIkOiNH6EF2QCGIRej0XM57eizKbyJ2iGuCASjcUOkUiwVd8tluk31zQSa9mGsQHMLBMQQWfskvagZufAQ6CDnD2dNZYKV5iOMwBP9/0VGKszQ/52pH4Tk+OiIccWhFC3j/nou/7KhaCkddOj1BNH2sd544W99+8T9l4A1H1LA0XXUbqWNlhy08GoToNDuRrgqKYIVDfaU3rsP7DsBCnVIbqBDiE6H+utTTNWhLw6znk6Ox61jX8v1cRJsM1JUddMG3W6+tDwrWdtd3Qbp3zkdzEUmzPqrKtAqFE/gVu98xQcgmV2+yUS6jfbb/jnq2gv8alT6CsGRH8dyStp7/QzrfsX4E9lhXjg6SiBG70nNOUsPXERjOJmMXcYtC/Z0+T7NyW380ymBQa9lyeYV/pqmnYocpppN0NvaV9DUqAemwzB5b1afCYN7AhXt5yXcXGhK37grUqDds7vhuY0HPMDxxm0fsK1pzalimhGPR1f5HKua4IMry/VJBSrZeEZmJiZXwneffLLnsRVTKwSguvgTqX5Z2S/suepQp3v29b4dt448EuassCkF0zclw0c100eKGSGpfMnY4gXQeoNhpY0FufDSlPUo+oANze4hYZtKr6PvcOa6vVG99jlKQl8J0NkT0KrqLpaS+/7u2f+4r2nO+YabP6nn2xuQ5Nee6UtJVg1
 6nOTY6CU
 07BYewoVm+GCjU4PDUwBIaAq1SRhxYfy+XJmr1OhFQo30oZ7xGcuw3D2eECZQmU1rF9Y6w+7drKmNDw10pCAEwyeRIw/mVrsWhS7R07LsXuiaDdTVzJ4VLhthoi5ic0audrq1RpezthCeJvqEq0YCUDJ/mWQtYEA5q0jgnuwf23Qvf+50QsgRnyXPt5WGDFgIQMJWwj7GKBfLquzXtQAHsqw6X1PLVI5v1jzcMXZpTs9Ajcq+o4QVyvZNy1S3VsV7jlP3f+cjavMFjlariBihdybOPxJ/WmVgkhM1smKplUMcXgbKg83dpUkcnjzuCJ/CgoMNSEwTzRS8qowfxqT2ZlhfMlIsan6hOzHncOLBAFLH1HdObVH1pZNr5Tsd3DK8Yy8QLgcXj0PWtdb6hNJbUF7B5WGQ1LVduCBLrIkzn3cFn8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 09:02, Harry Yoo wrote:
> Convert ext4_inode_cache to use the kmem_cache_args interface and
> specify a free pointer offset.
> 
> Since ext4_inode_cache uses a constructor, the free pointer would be
> placed after the object to overwriting fields used by the constructor.

                             ^ prevent?

> However, some fields such as ->i_flags are not used by the constructor
> and can safely be repurposed for the free pointer.
> 
> Specify the free pointer offset at i_flags to reduce the object size.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  fs/ext4/super.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 87205660c5d0..42580643a466 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1491,12 +1491,20 @@ static void init_once(void *foo)
>  
>  static int __init init_inodecache(void)
>  {
> -	ext4_inode_cachep = kmem_cache_create_usercopy("ext4_inode_cache",
> -				sizeof(struct ext4_inode_info), 0,
> -				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT,
> -				offsetof(struct ext4_inode_info, i_data),
> -				sizeof_field(struct ext4_inode_info, i_data),
> -				init_once);
> +	struct kmem_cache_args args = {
> +		.align = 0,

Nit: it's implicit so not necessary.

> +		.useroffset = offsetof(struct ext4_inode_info, i_data),
> +		.usersize = sizeof_field(struct ext4_inode_info, i_data),
> +		.use_freeptr_offset = true,
> +		.freeptr_offset = offsetof(struct ext4_inode_info, i_flags),
> +		.ctor = init_once,
> +	};
> +
> +	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
> +				sizeof(struct ext4_inode_info),
> +				&args,
> +				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
> +
>  	if (ext4_inode_cachep == NULL)
>  		return -ENOMEM;
>  	return 0;


