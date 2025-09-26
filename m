Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1266CCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A098E0005; Fri, 26 Sep 2025 11:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552228E0001; Fri, 26 Sep 2025 11:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4687F8E0005; Fri, 26 Sep 2025 11:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31EC48E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:11:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B939F1606C9
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:11:17 +0000 (UTC)
X-FDA: 83931739794.23.B9F8070
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5DCBE4000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:11:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=toKBHnIQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c4ps0enJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=toKBHnIQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c4ps0enJ;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758899475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=986YSdZ63TRLCApNuNU8EYeSXZ1GOmUToFRwipg+suY=;
	b=WhFOdxE9JisXsyKVbAoT8fsc3pd/kelEqJoWLEXC8HGZOIYWizg6rokKBLCm3sDQX9L5gc
	Qi1IbuyyyEhPST+ljj0K24gWSy9OpyVTGclKKrK8f4iwzpYeAznpTnd42uPDAk17PWptBK
	mZR4F/1pF/gWXDHeb9j+jlGzzPENluA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758899475; a=rsa-sha256;
	cv=none;
	b=2LcpTemtEDivqhokDkFyu5Ov99ZJL3if73YqtD5H3ibK9ku0LntJcVPbZptLzu8asGj6j/
	eXEgiCB61psk1jA6Rxp3X6ehsFmJDfk7w4xC7LSGqlkygrNrca+/M26/Ra1FeytpgIqC8k
	UAsbkORMVGFpCMsh2O/fRTY7f7OzOvk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=toKBHnIQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c4ps0enJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=toKBHnIQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c4ps0enJ;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C2AEC24343;
	Fri, 26 Sep 2025 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758899472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=986YSdZ63TRLCApNuNU8EYeSXZ1GOmUToFRwipg+suY=;
	b=toKBHnIQOADg0YlIj1IEKiwnpolpG/6GM9ixelGoyDuP0wYIkajeENWxyuAgHozsXNlwym
	4UVwN6d8S99L1SQlge+Eg3fxoZxk0tNzwvofZNXkdBj8XoAlN1+zxYwc0YiiCZet9vT/Il
	ixcZ3figMWMo1uzqt4SYLnrkB54ykSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758899472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=986YSdZ63TRLCApNuNU8EYeSXZ1GOmUToFRwipg+suY=;
	b=c4ps0enJY0SxVH/bhoRe5g35OcPtUDiJn48ABRQRNmrbe5TcSQTBydndN8rQaN+QtlnNqE
	qtXCjW+tiP89soBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758899472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=986YSdZ63TRLCApNuNU8EYeSXZ1GOmUToFRwipg+suY=;
	b=toKBHnIQOADg0YlIj1IEKiwnpolpG/6GM9ixelGoyDuP0wYIkajeENWxyuAgHozsXNlwym
	4UVwN6d8S99L1SQlge+Eg3fxoZxk0tNzwvofZNXkdBj8XoAlN1+zxYwc0YiiCZet9vT/Il
	ixcZ3figMWMo1uzqt4SYLnrkB54ykSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758899472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=986YSdZ63TRLCApNuNU8EYeSXZ1GOmUToFRwipg+suY=;
	b=c4ps0enJY0SxVH/bhoRe5g35OcPtUDiJn48ABRQRNmrbe5TcSQTBydndN8rQaN+QtlnNqE
	qtXCjW+tiP89soBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E8371386E;
	Fri, 26 Sep 2025 15:11:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HSVYJhCt1mgOegAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 15:11:12 +0000
Message-ID: <f6777d66-a55d-46ef-b972-951eb48337b7@suse.cz>
Date: Fri, 26 Sep 2025 17:11:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH Next] copy_process(): Fixed jump logic error
Content-Language: en-US
To: Edward Adam Davis <eadavis@qq.com>, kees@kernel.org,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, akpm@linux-foundation.org
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DCBE4000B
X-Stat-Signature: 81urajhu448tr9kj8uwss1bhu77b6ztx
X-Rspam-User: 
X-HE-Tag: 1758899475-992958
X-HE-Meta: U2FsdGVkX1/TrY9b0wz9PSCVuqV/rJC3aQk1OFB+uN+lM7zwXyv83BUHCHiUAo4Qm2Uz8VYQ5bLkETb/QKOxd/Il3KGMxGf3nPeF8iys2IdB+kEFoJdR+g7QZpArih8ugDk65x0g9RJQ2gN0xTLxn6LlYuJJ9hC+RYKlNA/i8g0Wro+cVUcezWOFzHxazkUgZOeGQIhzaIff7D4jBjsyI64rdjE5dzL7ONxyJ9dDLcGy9xE0Q2wD1aSkydtx+BGUmDd86Sk95b7ZLUqGh9lmtIzXdmyymeVGqD+Ocldd02enkXmx1+ZSZEwbI7bkRkHikTHC1f/w1IXjiRbmddgN7PdiYHFtYXKxe2b4ZZHvAwVPP2bMw6B9cKY8IWGC/ZbSQvJ4gCNhXVkw3Im1sR1ag9+oU7kGCRfHCXw6qOAdaQFW54uM5sQ0oJgoFAfyA/Z07xTvzkOXKxFD8nngH2VlJcSqtz4yyuqoqlRjRQ5XHThtf+DOXqtJn6XNhjCXLApUrgezIzuu3HEuneWHpQGHtZQwYP1exWvIMWT7K7Rs49shv2lUiXxBtwIYGtcgBJUQjf5kwWTQsyTcV4Sk9C+rrsHRH//YfL0GqMPEZaxx+a8c6/oxJmz3YlpFiEEe1zDfMCXPV5un4MyKcLYGLryd54GZry60euq9lq5A5z4nozsi3lZ5sxlO/oHimkcw3/QOdDPawSLJ38qZggqXnhuiz/0L93jTIJI42+SNveNltI1M9eJDLzHlZQgDEXC5oBbSKCQ031iEXAWW/9lMlBwUOQafmZh7sMDPTLOw2x+amJv5ic4+v/ujIjv/5AXo07b5X+Fct7recoPJ/N2Q87F9ZlJ9UXxjgxjhoK0yNiREM8pHHY5gzd+/gaUNfE5M5QVgPwggSw02j4drEu8Xht3qeekHhOGuSDf2Axkf84xDPo57OFO1qG9loh+/B6bpvTn3cm2gf1SUijF7IZgGJkz
 EiVAjBWI
 HSxO3K5pGivYou4xwqEuW7oAb5tjfh8PUy0p5HUlZ+ZbrZI8s+hSBa+cyBlgO+Viy3qzb+mdK1yO+X3Aqp/9rvCpCdfYr+JPrXqt/vm6vrvWBUHd12iGmuQqtV50mRzJsQ9J+v5TW2Beg6M8IuhVJ073ixTGH5isCHcmVFGLQMWwo2qOVh5GK66/JVz1uvwjHrQVUgbVLXtaUDsDK7lohQnSDpylUl0ikoi4hTFj2DwMeHSpv1fszIAf8OiTZGvsQJS0vO49uL9aMkslsMn2CpiuU54KMl1XQLdQrzVhpYGG89+RxkqGC0pL+Q4WyM+EWNvpUsGQummdA+VMA7RLzIdJzgLrTAqx8+Fa+b1B3B5lY/TjGhNYVMNNDe6IAMXIAZ441tHicW8eob1lhXQAF+AITgl/nna+Mwbb1Pb6esh0OrgHb+JRwY6iO2brwbPlUynUPLnBeNxytGlOPqhOzb2CH3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 14:06, Edward Adam Davis wrote:
> After futex_hash_allocate_default() fails, the logic should jump to
> bad_fork_cancel_cgroup, not bad_fork_core_free.
> 
> Jumping to bad_fork_core_free would cause a siglock imbalance.
> 
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

Sebastian already fixed this and it's in tip: locking/urgent

https://lore.kernel.org/all/20250918130945.-7SIRk8Z@linutronix.de/

> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e9a7fb5c3e49..a0b8eeeb1d27 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2349,7 +2349,7 @@ __latent_entropy struct task_struct *copy_process(
>  	if (need_futex_hash_allocate_default(clone_flags)) {
>  		retval = futex_hash_allocate_default();
>  		if (retval)
> -			goto bad_fork_core_free;
> +			goto bad_fork_cancel_cgroup;
>  		/*
>  		 * If we fail beyond this point we don't free the allocated
>  		 * futex hash map. We assume that another thread will be created


