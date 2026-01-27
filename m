Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 595EFD25931
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D576B0088; Tue, 27 Jan 2026 11:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A926B0089; Tue, 27 Jan 2026 11:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1CF6B008A; Tue, 27 Jan 2026 11:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9FC6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:59:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBBC41B0125
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:59:06 +0000 (UTC)
X-FDA: 84378353892.06.205E56F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 48E1C40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:59:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wclOPg1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4NrdL5lA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gyv8sEDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FfYEy5mb;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769533144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WljwI07n2+POd5G3jOFC1Ra4Hx+nfwNNAlR4m7oDBUQ=;
	b=GRqPgYZSguS/yPDkJK92PFDncLQyLniDsKHD5Zh+hD0qtn7zRNlIV/IadT0r/QwLkBBxJu
	uhAMA8TNwmXai2+K+3fOo+E+3eZYWYbQDf7LrWEWi3GAjZA/HPTQnUjZ0Wis32S3E2PJ8c
	gq+CIVbMEvwaeikOClTztxgLOi/NI6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769533144; a=rsa-sha256;
	cv=none;
	b=TVInXruAWdqXHdK8KjhEKSkb2PPce94WPu3fbYbO3nLGYdneU82dCnkvoTOuvXoHC7uMf9
	ufGu74OL6ccTSDT7zXG6ZJfuVb3kquBmNKJCVOcsCs/C5mE+KeMOZ1iES5WyJmdLBSFvpp
	8AvAzMZLvwiHlo7fzq4JoYS20R+a1Pg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wclOPg1p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4NrdL5lA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gyv8sEDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FfYEy5mb;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BC585BCEE;
	Tue, 27 Jan 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WljwI07n2+POd5G3jOFC1Ra4Hx+nfwNNAlR4m7oDBUQ=;
	b=wclOPg1pp24mnxrxFgHXJx4YOYJ4KYEQzv6aSLWVtEGC/zM2OQfuBQnsVPy8c35YVLX8x3
	ZHKc6DED1OjbQdwAScYZvGXk1cP7nAAQTlINoq+9mwYlSVG5/BHXLBAhwEo6MJvXUdkeau
	ykyUoD7bV/fwB2MJkX6727GCDMOWCdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WljwI07n2+POd5G3jOFC1Ra4Hx+nfwNNAlR4m7oDBUQ=;
	b=4NrdL5lAiHURuttbPkkPdPrtbZJF1usezAvMgvbYul+v+pm1MBGGuzcZM0cJlMbZ7Px53b
	AmAsYOmq2BxT6uDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WljwI07n2+POd5G3jOFC1Ra4Hx+nfwNNAlR4m7oDBUQ=;
	b=gyv8sEDjoBdKWF6uAEAPHVl/yaIG3YNnycYw3LJkS6RfOj7cTSYkta/agXutI4uyItIVgu
	9yzvlcRmKM2GA/bdGh5HWfCIpR5l4M+A7D8MM/WtnbAPeEQ2Y3c8eIL4FwFap3nK4MprTZ
	pRBMgn+p/mUz5aUX9IqouQQMKqQZEQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WljwI07n2+POd5G3jOFC1Ra4Hx+nfwNNAlR4m7oDBUQ=;
	b=FfYEy5mb7cyZZavjKh0+k9XKucMuT10QiqGK+I0P3FQCvwyZhT8FwqahkNEaT9QBmC4EOa
	JRnvs5sJp2DiVKAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51F9A3EA61;
	Tue, 27 Jan 2026 16:59:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RFauE9XueGmgVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 16:59:01 +0000
Message-ID: <0c7b552f-c494-4d0e-b956-38b5e235917c@suse.cz>
Date: Tue, 27 Jan 2026 17:59:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/22] mm/slab: move and refactor __kmem_cache_alias()
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-4-041323d506f7@suse.cz>
 <xvdhietnpfl6ait3kjwxu3nrrzdpwvt3zp5ui4l6o7t7yps55g@wygbtepochfg>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <xvdhietnpfl6ait3kjwxu3nrrzdpwvt3zp5ui4l6o7t7yps55g@wygbtepochfg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48E1C40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: auasmiiwfo9a9xbtbd97sjxqgd1ea9o8
X-HE-Tag: 1769533144-500025
X-HE-Meta: U2FsdGVkX1/fw1dyZ5TiEiiH/u1GtYVkGy4DgQw/DUfXs+nDQogCt+utDCJbKHx0YbCRvz8Ym4eChvCgwPxojg7nIEdH7icKNHwVcyEZq+TygrTRLBo2AwBD2NEWYs3w+BJT/tKLLWjwTQTmuZ04PltxrfthBauTyf9gkIRYXL5MaRWdmsmGBjEuMzopbB+mqgcltkZHDVU7NAhN8X2j2xtDRD7pvzFXcycmDZqOF02X53fvp7SHMl61h0JgucJyHNiLuVbYlkipXQr4Dabc1XrMYB7AMZb540bDU0hXP9MeldCKQNtvAk+4QhJwmWo3/LrsxbBugpNPA+z7FVE452fFlxoa9QBMltKhc3FsCsSK+GRzFsfgfHZk3Hdjw5nyfmQU5SZHGcEVJKXErYTxUaRHI9HM2H92MA1jo97rE5d2zltZ7CN2/I5j0DhZuKKyo2Q0UcwtKbHU7xeTpCrpORl4AnsyyKYzRAHVVxoZO7w4IZOpqE04CjpfQZbQPgMilMCBFRiIOdARHJTCEKQt+4ejidfXFlrnkGfm8dlsc6a5oaKcJFFEN8C7jCf6pdsSJXb6SlfV3LkSMDFJT8rU/XoLisaNuozagFvl5ikqP4aId+cfmTf8g1T7Y+Uq1Y7K9IJ4/U9sLJ2upDM4RLUxAr4AXpGpbLcrg+3QCxrldgjLvnpPSV5c8P/qYyQ3f5exEnodGs/gsbYMq7SrE9dT4gghiys0GPCOp+92vAtJMTSsYFs2rxDl9Hrif2MzAGrI1G9iykGKz25ywPBxsrO38Am8DFNLPe1g3x16W1vdEJKGhTXPTk/pRdCjgc9Gb4QdYKrftoEAvlMGkVRAuWpEfVhOU5ESLN2NS1NabVhh9gw/FGqQIlw2frMkabKD7INc4gGXojpJHEkjS8Le+F/54vPbHghZXsYrH9kTdNXDqBW52Q/GNuwJ0k/Jor39K9Ghqegd02IKj9BpSXKy4Ux
 G7PTezNZ
 00WP9h4S8Ik8wowUzJtOU6yoE/NQadecuXvEUapFV8iliZyDA/k2lZjzJ0HrDZLV49WXFuLzB0hy6RsOCy0CnwdXO69R4RJXVOpygyG/unRZ8S73XHvc70hU4+DEZGEX879Zuzn1ZS6MLRSXNzVytRjC+LySuet2G+gmuVT044oZva79KMHuounEV+8kZdrMSme1S8ju7Ft28QTX3PuqlIDezhRyYRQdlJlFxjsfpIXdH/j3DEo1gCCbIRfk9TpK70mAkR6+r3/KeRsT2VycfWOR21rjVvELh6VlAB+dwon3NlFgLrGVaMPnVxd7PL9a3qfmtFSCXct5NUDbx/e8TsSbdU3SRaY1qWSsaET2gYDwdbLD2unemLod6YSsuJ5o8psn0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 17:17, Liam R. Howlett wrote:
> * Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
>> Move __kmem_cache_alias() to slab_common.c since it's called by
>> __kmem_cache_create_args() and calls find_mergeable() that both
>> are in this file. We can remove two slab.h declarations and make
>> them static. Instead declare sysfs_slab_alias() from slub.c so
>> that __kmem_cache_alias() can keep calling it.
>> 
>> Add args parameter to __kmem_cache_alias() and find_mergeable() instead
>> of align and ctor. With that we can also move the checks for usersize
>> and sheaf_capacity there from __kmem_cache_create_args() and make the
>> result more symmetric with slab_unmergeable().
>> 
>> No functional changes intended.
>> 
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> One nit.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks.

>> ---
>>  mm/slab.h        |  8 +++-----
>>  mm/slab_common.c | 44 +++++++++++++++++++++++++++++++++++++-------
>>  mm/slub.c        | 30 +-----------------------------
>>  3 files changed, 41 insertions(+), 41 deletions(-)
>> 
>> diff --git a/mm/slab.h b/mm/slab.h
>> index e767aa7e91b0..cb48ce5014ba 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -281,9 +281,12 @@ struct kmem_cache {
>>  #define SLAB_SUPPORTS_SYSFS 1
>>  void sysfs_slab_unlink(struct kmem_cache *s);
>>  void sysfs_slab_release(struct kmem_cache *s);
>> +int sysfs_slab_alias(struct kmem_cache *, const char *);
> 
> nit: the names of the variables are missing.  I guess because they were
> missing before.  *s and *name,  I guess, although they are *s and *p
> in the other declaration.

Yeah will change both to s and name, thanks.

