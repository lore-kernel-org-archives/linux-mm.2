Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B71CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 10:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1E58E0041; Fri, 17 Oct 2025 06:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272488E0016; Fri, 17 Oct 2025 06:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A3F8E0041; Fri, 17 Oct 2025 06:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F09908E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:50:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BE0A83279
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:50:55 +0000 (UTC)
X-FDA: 84007288470.11.4DEB9EF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8B8B140004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:50:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kEserYOD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pgzi70xs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rdUu+4RH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a9++KeDQ;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760698253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PM4LvESjlxri1zpp6vFK06PmdSmf7nPh7+Rq9mCaMw=;
	b=5+h2cCaHvx2GyAnDUDBuiwTWgj0dNIAsb1LakIROHZxMy8A5vKuuFeARNxS3lbAnAwXlsB
	d1h8dCt6ClFEcI7JQgq1+OwVrS18C1AXAgbkkk2wP66Htx/z7/aa5ah+btixjbQ3yCLbVm
	/VtB86IycRjR9J5er7UK0/43ymEOgHc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kEserYOD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pgzi70xs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rdUu+4RH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a9++KeDQ;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760698253; a=rsa-sha256;
	cv=none;
	b=L5Kxv0T3nynzTsNZkhIuYO80DoZni5QVqmpwnZsAH2PObQ3G8CCdatH9uzrv/rWO1MW6NW
	vw4bpXQiVUxAx4uxkR7llHJlfzPT4VOjK6e7lG5EmApO0Cs1R6xXVF3q9Bbdtc3g+rt+7A
	IbOrNjA2JEt1vyrFTGt9t7x6Gmqn/Yg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 27B5F1FE33;
	Fri, 17 Oct 2025 10:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760698251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+PM4LvESjlxri1zpp6vFK06PmdSmf7nPh7+Rq9mCaMw=;
	b=kEserYODQ1NQlb0UU4M3ueJ3R6GrfFkgYZTUnv3eQNpYBnjdLz/k6F+xzRY5YaRUG2wO/q
	vSImeS8ba/zGf6DVJluKTMoOwwQqfQjI6OLcajSd4+6rlBvlOtIdNtZLqmkd92xB+H9UEp
	8ANMUo1rq68mvWGDQeevgHsj7c+Kuc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760698251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+PM4LvESjlxri1zpp6vFK06PmdSmf7nPh7+Rq9mCaMw=;
	b=Pgzi70xsKmTHTVC//R9Wfu2fSPU/gAFoncw/5Aj1BFz7JHbqcr/YP5kV/9XMLh1K1vkL1p
	Mox1x4/s7/WbpBDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760698250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+PM4LvESjlxri1zpp6vFK06PmdSmf7nPh7+Rq9mCaMw=;
	b=rdUu+4RHyct0iiYy+MA+ak6xf7fpY0IeTeFUFJ5v4swQ0QhXrjVU28wqM0rXueATnCenhp
	GnMQQydafP83DQXzKcik2IXxtlY/VyOdgsAx2T0R4UC1FMjAKUPEXcwDjAFoZMYclKurd1
	JkrJrPPfbPOOhvL/AUseJ76DqNLFiYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760698250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+PM4LvESjlxri1zpp6vFK06PmdSmf7nPh7+Rq9mCaMw=;
	b=a9++KeDQg2WP9ZxiWakCB3cvR+Op92WSkwFBPqR02HE7IokrfB8Awcg3TevD3GfDwIbOXS
	jHEEKhDbWI+I1sDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09EE113A71;
	Fri, 17 Oct 2025 10:50:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mwEVAYof8miWAQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 17 Oct 2025 10:50:50 +0000
Message-ID: <910a1d39-ca72-4e79-9f6d-66415794d9a9@suse.cz>
Date: Fri, 17 Oct 2025 12:50:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: add flags in cache_show
Content-Language: en-US
To: Kassey Li <kassey.li@oss.qualcomm.com>, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
References: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8B8B140004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ejpat36yxj1fkn7mtwprxxem3a8wocrx
X-HE-Tag: 1760698252-192308
X-HE-Meta: U2FsdGVkX1+9vfG0Rw7sLIsa/crDeSyxWVSzb/8lIpTTMt/t723FOoLY1vnOHxybsKLj5+WY1xNDUCvx1ySe+MpJ1OPjvErJC/dFe5WEqU+LQWh7T6KxjsIPAknFvwNW/SMVfinBUKEMdDjzZP0Dg7/gHYxf5ImvVKDvkQ7RDBXreTzU2snHH1HZilEyIl9GlkQU17+lcA6NWf6LJivySH2ObtAWnrW1aMjXdFlDxclqcma2vywk/ykg2yzs12Aq5BiSZN2I20lwPYGQsKMgDGC8dxvKaKu/P6d2eE3QJPdAlpo37FJehlyZ6xdGToIMXxxNEGslze9NFeNVCYkTqR62T4qeTnbesiEU3MoKKCgajhnHUrvoqic4anRrD8Qnd7Wxk0FJRYJg1VGB+Hi+0tmXd5whF9GeOwbYaeoH9GglEh3AgQ0ZQrpP6yt7Vy3VgpRYxrKzm3d2WcbvMFcIPlDr/R93tGW7/3g/coOUWvdfuXaBF0u2jrKPjUgkdEDG8DUKkQWcRTNHtsz6Oxc1QcC89CztF6DgPq/ipITX1+DUK35/dYw3j/JlNXUxXlXiEUjnUOzCIU5i7cgn7KfeufOTvl/STUHOTLi4wQoeavpTNE7s9VlG+9RHPdCVy6byNEAdxyMAkGWZO49fu/MbJ+UGlObY//vPv8+xX+qOvDTgPTdDsZlnotrEjsokpmPmiP/W9g6F2RP8TfdcC4pFwt2jt9DtGuFpxpeKXOdXWo5XpP+wxy2/kYUTz/dQJGPgyDLGTMVIw7CAQUMquMQIWF9saRg4FT0ykoDOz8NPCWYGxA2I04hJ2t5LW+DZL4kL9RekfOUDVqllrGfoNLdmZ5GUm+Rrwo4oe/d5n8ZbNRxPnMNufxxZ07flEf+jwuo9pboNZgv/jGKsRK9PT4lQg95zJ+tN9ukzlDA2QIvwKf/MWKWETFjHSJe9UCbE+PYkG9utDIhFJehgXLC7rI7
 5uxjC+Z4
 glrG9qhMhj0BSpb6ZSLYzXpTxxgnaYMP1sGq+sh8ww+d/c10+2OYenwuHaUK/pXkq+J0T+9CrhDgegY9EC6NCcDaAXhBA4Kj1IQKQvP7GvJaEtdiJjFftXCzZz/SqHdcYCWBkNdUznU1hpimwXPX4u18QbmwzxCFMeTZNj9T2oz+0SqBafKFGN3vC1eAQhA13JtowIEJ5kgMzA1o/AneFG4CFunWr1GMLUaZ7e65TYu120bt9MNNMXGeJ3ToEcKD8OSusAr09vdEjFDIWaGINN+ph+06Q39WXzTr622PoPUDwVuaYiA7RfWkN34XtiqeSXPTDWFaI9Brce3TJn85VhxQSJU26pcesDbBM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/17/25 08:48, Kassey Li wrote:
> Flags info is useful to check the slab type.
> 
> for example, _SLAB_RECLAIM_ACCOUNT:
> 
>     0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE
> 
> Signed-off-by: Kassey Li <kassey.li@oss.qualcomm.com>

Many of the flags are represented by files in /sys/kernel/slab/<cache>/
If you miss some, we could add it there. Changing slabinfo output could
break some users and the raw hex value is not a stable representation of the
flags anyway.

> ---
>  mm/slab_common.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 932d13ada36c..f43239211e69 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
>  	 * without _too_ many complaints.
>  	 */
>  	seq_puts(m, "slabinfo - version: 2.1\n");
> -	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
> +	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> <flags>");
>  	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
>  	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
>  	seq_putc(m, '\n');
> @@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
>  	memset(&sinfo, 0, sizeof(sinfo));
>  	get_slabinfo(s, &sinfo);
>  
> -	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
> +	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
>  		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
> -		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
> +		   sinfo.objects_per_slab, (1 << sinfo.cache_order), s->flags);
>  
>  	seq_printf(m, " : tunables %4u %4u %4u",
>  		   sinfo.limit, sinfo.batchcount, sinfo.shared);


