Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D02C88E7B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903736B008C; Mon, 26 Jan 2026 04:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887896B009B; Mon, 26 Jan 2026 04:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EFC6B009D; Mon, 26 Jan 2026 04:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622556B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:10:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F26BA1605E5
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:10:35 +0000 (UTC)
X-FDA: 84373544430.27.FADDB54
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91B4E1C0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:10:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K+vIhKn9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ts+J3OBF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K+vIhKn9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ts+J3OBF;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meQJjQyuJO3NU28O3lrl1FUzWKftKcjG1W6T9QBNnWM=;
	b=hD46X7ikgd/HaEU93xe9MyAufH7mwYZlw6i2TmOVT7jOJKmXjw+98p6HKBs6UNwRbOpttq
	KxXyl8DG1J0OZN/VK12QM4Q+Fo2ne3MpOd+hUerlVOG3NnY3jIbPiRY0ORB3mBMYk6Q9cY
	1zbgjKB/mICdyYPdF1vAQdGuvlY8zX4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K+vIhKn9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ts+J3OBF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K+vIhKn9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ts+J3OBF;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418633; a=rsa-sha256;
	cv=none;
	b=ygWbVm7VAs+J8G89bicYaSYOnfPC6xWjnM07rGt9aIcgl3zwSHGNdV/hmsMdTX3Hev8eaU
	bhz7cPeOHtsflZK+u1jqpXVRl0AvdaaQUkAxdX5AVIUtsYo4XX+CTmXyblmVO8/8AEgDcs
	d85JFkerqInFrbj28uKOa553/4JVPUQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD12E5BCE0;
	Mon, 26 Jan 2026 09:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769418631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=meQJjQyuJO3NU28O3lrl1FUzWKftKcjG1W6T9QBNnWM=;
	b=K+vIhKn9WL9jrdsGhGyb39+D393WgEYQ9A67xvMD1me0xdHCVg0jSE0ROiDSJcBvq4KXF8
	fRal1gugcLVv6rgSl8/rPbxos2apScYcx8xqo+udXJ92m3N4wlB5wDT6FgAdSYgzV3P9jj
	RasF2Cmhn5jFKx5/goKIAi4FOWrMX2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769418631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=meQJjQyuJO3NU28O3lrl1FUzWKftKcjG1W6T9QBNnWM=;
	b=Ts+J3OBFjIGc+d7N8lkQXJfCF47XFB0eIKBpPnPT95jhZNVd2y0f+Vg2Gka44/z9XZaBPe
	3aXV3zBKieJpbyBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769418631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=meQJjQyuJO3NU28O3lrl1FUzWKftKcjG1W6T9QBNnWM=;
	b=K+vIhKn9WL9jrdsGhGyb39+D393WgEYQ9A67xvMD1me0xdHCVg0jSE0ROiDSJcBvq4KXF8
	fRal1gugcLVv6rgSl8/rPbxos2apScYcx8xqo+udXJ92m3N4wlB5wDT6FgAdSYgzV3P9jj
	RasF2Cmhn5jFKx5/goKIAi4FOWrMX2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769418631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=meQJjQyuJO3NU28O3lrl1FUzWKftKcjG1W6T9QBNnWM=;
	b=Ts+J3OBFjIGc+d7N8lkQXJfCF47XFB0eIKBpPnPT95jhZNVd2y0f+Vg2Gka44/z9XZaBPe
	3aXV3zBKieJpbyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F309139E9;
	Mon, 26 Jan 2026 09:10:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yEmHJocvd2ltSAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 09:10:31 +0000
Message-ID: <7ff42564-9c21-41b4-88fa-9733387fe4f4@suse.cz>
Date: Mon, 26 Jan 2026 10:10:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own
 slab
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cl@gentwo.org,
 rientjes@google.com, surenb@google.com, hao.li@linux.dev,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260124104614.9739-1-harry.yoo@oracle.com>
 <2b116198-b27a-4b20-90b2-951343f9fff1@suse.cz> <aXcmGMlH3sWO03rv@hyeyoo>
 <55ab1a9b-1d7a-4e7e-b6bc-ee327197dc4b@suse.cz> <aXcsjyKFsmeVggp5@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXcsjyKFsmeVggp5@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b1zpq8yd3ordj1m36beff9im7ciy6i93
X-Rspamd-Queue-Id: 91B4E1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769418633-299095
X-HE-Meta: U2FsdGVkX19psbIPwHB8/WsZyGV+gtUVxhdgejTDOrPC6eda0qtaZBHM7v4TsrYTGQHwp3IVFqOXS0V2nve07Lc6o0g3Pdl/1Xs2SlH0qnF8Z6lBwZKp0rSI4FSccjg5U6wve/4iPAofRNG6BE2qhMoqfnmuzY4Sn9Np/PzDyuHlBdeDNeFzTPpIscyR/8Fm/Jvm0TV0yTJxHxykOIWWMpTNa2/GN5NfHC0pK0DgypYJZ2mT0HinHNyn8PIG3kKbAezhS0ZJkmOtPEvh//UTjY27J52vM2dxy0QViI29RDosv8N9E4+aqZmIry55tSorrcj2HaeUfSM7kjf7FPl/Cwjd6Hx+jO1SUeW0wfW66p2ury8vD018lcf83IGIlXjXNj1VzwGBoi1Wld27+15N9JN2cHv/i3Hmwotb/hP47LMlEx5mvauEuuTFVYIfLnlyVTdas8zqwsFtYUjbl2cTMYSrr4789CdFmUQK7eFIXbW9J9nMoDHnX9MwFj1cyesAbawzzv6zDhlSXGnpG+83umgxkyAGPGbSX+gKfmOhsgpFXoZXebqRnCMVCsogDAFvqP4EkNdwtj7/9flEHuRmgn3IQOdpdo0OP6td4iN+QGfVkPMH89gDjGvwZHlp+JPcOA4TWDvVGCmoE1dbeDSKtI0zUy0naaEkTK4hGfK6qe+qr+1I9W3tpsh448+2bB5JjI9ffi1nqtVU8XFK4Zhqqy7fsdXeFJ10GWq53zDO+MrG8Cx93ryJoMGVgqeEjOASJ22JLHa50GqEmqaFOkRBZC4FqyZ53OaXJ0wnR+l9VMZ7TZaANTeBSWBR7WXtDNj3/spOn1NOq0bCrpH8/2QXJUzAqzfPQb/F2qzz9ICwjzMAf0laZqEZaelgebQQL4gpFtAwssURAGKaxnwSOwqD8IDTMeIM/zQUdx8NztSZAdWnzJ3+3oGVvhd5aVe9q3qdT0BCLp28quh5UG2noKz
 CZgUvFAX
 mCm7PBO0ctWlW/0DumlZnboK+kIMn6siyqYaMZ88WVCmGmZlnLmsWjNgexi3qnNLETt2wGMrN90aEGvZVjIh2oAp0JIiIhebg9pxKaIIn+xwhVx8fIFT8KFIfaQg9Ts4gvmFFi5x8PgwRNqzzfTSbgrG3KjZQ5Sbk66/mBTcAbyymKeSy2kGbLMlcWjB9/3K1Lchv8S0OLgVD6CHRpQcK1m5InN8Co4YLc11bvB2ir/1Lpu2b7bQHq67IoNbgGxGljwX9FbyXNNlCmbpjUGX7qGhoNV3taYlwIMuARfKF9QudGh/SQkP265pVmUvVSu1+EqBa93Pygnf9rcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 09:57, Harry Yoo wrote:
>> 
>> Maybe start with something like "We can't simply compare s with
>> obj_exts_cache, because..."
>> 
>> >          * is selected by the caller address. Since caller address may differ
>> >          * between kmalloc_slab() and actual allocation, bump size when both
>> >          * are normal kmalloc caches of same size.
>> 
>> As we don't test the other for normal kmalloc(), anymore this now reads as
>> if we forgot to.
> 
> Ok, something like this:
> 
> "We can't simply compare s with obj_exts_cache, because random kmalloc
> caches have multiple caches per size, selected by caller address.
> Since caller address may differ between kmalloc_slab() and actual
> allocation, bump size when sizes are equal."

LGTM!


