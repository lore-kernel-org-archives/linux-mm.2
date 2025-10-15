Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6396ACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 10:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3EB8E0006; Wed, 15 Oct 2025 06:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BB28E0002; Wed, 15 Oct 2025 06:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A028E0006; Wed, 15 Oct 2025 06:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 970268E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:06:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30A51C036B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:06:14 +0000 (UTC)
X-FDA: 83999918268.24.E14CDF4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD5FD1C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:06:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BZ9QIIvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ao5rX1kY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E8oEHryM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZajFTR9F;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760522772; a=rsa-sha256;
	cv=none;
	b=FF8PW7u7f0uO2pcFgMJJUttL4misn4X6Tni5gtJW5R01QL31I2FV2dPAPNhzy+uMgabAHL
	/E1ZLSNswlDUrozi0UZs6AWPmuqQ+9gSX9yhY2NMf0dpbJ1w6cupmeDhi/H9uv3UxP5K/r
	ouawiw7D5RZh6R1aGH2A90WmZ4KY/wE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BZ9QIIvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ao5rX1kY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E8oEHryM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZajFTR9F;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760522772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=us8BFgTMys8htTeKZpLMf1ZJnE0zZAGz4+SVy0iyfko=;
	b=KQ7EK4cuP/epPcU/ekytwh0orp5tjnk63XKOcyj8Aa4s/UbiQOyt+jGovGyBjx7jtvtCXh
	COrKiKPvdzgRV93frPASPO/+IbP0xk88xGrAhXMGUqzBLMIQYOdQrjqEzkD2ferhljeRZ+
	npEMqavGbYZJKPgyibC+UjLq5Y3qVTw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0989F1F449;
	Wed, 15 Oct 2025 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760522770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=us8BFgTMys8htTeKZpLMf1ZJnE0zZAGz4+SVy0iyfko=;
	b=BZ9QIIvKdbNd/h378p2rUJ+PBMSguR5g4cscAQAfFjx/UXYWjWB19WEGEI/QSHsMNornJ+
	ddL+h/GL5f5B/7Yyf+9arJvOPH3SxeRjUkOlX2CxXiUS8+aGIeH9G567LWKfRooK4icY4+
	uIvDHQKw0RQ4ec3aj289LZfZRe+6X88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760522770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=us8BFgTMys8htTeKZpLMf1ZJnE0zZAGz4+SVy0iyfko=;
	b=ao5rX1kYnw0iM9kTKQqHwf0nq1VAR43ZrslyDOg/ZPM75qCTYQ3iHOHbDuUdjFwRtYuMeO
	XLx0KxDXZUejI/Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760522769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=us8BFgTMys8htTeKZpLMf1ZJnE0zZAGz4+SVy0iyfko=;
	b=E8oEHryMFf6H4ERXn11tPLrC78sLAgSuNcPB7/IWq2Er6PN18KtlzYqVzXOAQuB1P9HQUN
	S/UokEeQvvWfA3tCfG4p6cEZrvCiATCG3txmRYAw5CBHI0pbpg1GJClDOtnvq3i4XpS+oM
	0fq4w25rwODKGUXaZehxEna+lgZzOWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760522769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=us8BFgTMys8htTeKZpLMf1ZJnE0zZAGz4+SVy0iyfko=;
	b=ZajFTR9Fg0mF6sjPKopAU/3kDtA0F4NsZ7HhUioXd1WjD5QcUvJn+CHsKQa5DYfV41o0m2
	Zl5j1dVlGaLk9cBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA8D913A42;
	Wed, 15 Oct 2025 10:06:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BXPxOBBy72gVfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 10:06:08 +0000
Message-ID: <7b83d4e3-f18e-4c0d-91ad-bf1512f68600@suse.cz>
Date: Wed, 15 Oct 2025 12:06:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf] bpf: Replace bpf_map_kmalloc_node() with
 kmalloc_nolock() to allocate bpf_async_cb structures.
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Peilin Ye <yepeilin@google.com>, linux-mm <linux-mm@kvack.org>,
 Kernel Team <kernel-team@fb.com>
References: <20251015000700.28988-1-alexei.starovoitov@gmail.com>
 <aO8AAD4sJA9ORlO5@hyeyoo>
 <CAADnVQLJ33_az3qK49PDwjh5aeSirUOuiJax+-7p2S3MKziaoA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQLJ33_az3qK49PDwjh5aeSirUOuiJax+-7p2S3MKziaoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: n7g9namtpapgdikufjapns4eiattka3z
X-Rspamd-Queue-Id: AD5FD1C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760522771-658361
X-HE-Meta: U2FsdGVkX1+ustdxz1scDxCZ3Sm1l30DpWx6Gyv/sOtbId62gUXQSliuqgHUniZnhiu+nYhxh8bT98EuaUu65OhfzcRhelxs3iupZrbQS83M8QPDoQbq5r5iAASvPu5ygaTrtfNwFSgmiPve1SKDYiPCwnm0+mClzSedIgpasOIfvx0yQhl87iRtwKQHCGCHxXvcZomNksIA4ADNLt4ZmysfQb4+v1VWyedy1JTP1rXaBhgJqjdIXHOU+VVkidV2PahimhNHN3YUdYPRaK/bO0SXQXDLFEZ+2e43Og1nD1VUBKmmeve0m9uOlYKRMtH4xY+UndR+Z3wlJSkF2nwvE1lfXYD9WGAG0StZBT3naw5f2xG4XJt1wZGYG7Eqc++iWbSDlyq/BQ0zkQWrpKc7w3D7yubwUZ6//jcheSi/llIQNEHnzBAn1OynxPRUAEl4NGz4p9SDPLlu25DRxLAvAKfFHCDRb5Pf9HhMLyigaHUG94dW+JIw7aHcQp3cw92HmtQ7RdV/VYFw/+zDYi24+ptCBph3MKO2jGTeIFZhZsYniDxmhTIMUN31/g4hKp0aJdfsnpg9EcMLR4R9BDbXLrsLGyrK0afwy4YIZtltoITtOPDXe2hgx/qYdE45LyZOYkotrZFNauysoc8hCT8IMxiP0OQW2k4mhgPTc+6mZVeZ5CjjsMsD33T8zdyI8ashIvhu3yF9zSG2lRQ0IBlmeSbmoxftiS5GLe/Pj7puqAzVcgLlx6/nDt+6ty/ybHEhzgUokYVPV06CLK5tJWbIRm0/+zdkgVp7Cv1RAUoLlPvk3fCenTgDXIgBRJSakZv3Yot+p29Oq3LZrH1bycWian/rgLdO3wGiEZ+eyA536shWzhv/cofbFnqIGkTkqtEXaPb/HBlKkX9sJW8lY1Ea0D4mdkavhKHl9ihEpDLToPXVKWIHvmFwrZUZl05kDw3qceQEzPt4fJDm/h1xQdO
 1jH+1oM0
 QgDmgh154gzRk4dEjRecDdsaGFJgpysEpv2Q87A4eMjzeoJ5SltPdzvPZ/ghZmtJd8n6guxXrK5Xn5Ls4LM2dhns6MVJmgOtzDGfI2g0lnncehEz+7NId06ZZARIbrsvPCNgebifFHVCvB8C7A7dGlNX27+FgIUlf6I0iheJVgr2UASL4nd2Qdpsvch7EhZiNvPw4DMjcRU0RsV2Jn0nHLe1tfALj9T40vFwt6tVII5YqpeJMPY4Gemk9bAtVXXeTakf8PigPUp7B0n9Bcaab4YnGuOQMJ8HJWdRsAyI0gY7Wj8cr4UC78msU8IPGG/nC/kFaUnerANAWwSUKj5X9ZQ9aXTHevi028XhfRZ5l4RoXOz0E1dbGdTf2/2arloLc1zt7989a6aoZAZFORUKCWkvbsuKRDu329i8vQ4H6FyQ87732wBcNZVvY2/dEoMoblYKr1+eCDzQ7pih9rvetI1EDAYOb+WHhW3H1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 04:12, Alexei Starovoitov wrote:
> On Tue, Oct 14, 2025 at 6:59 PM Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>> >
>> > Fixes: 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
>> > Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
>> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> > ---
>>
>> LGTM,
>> Acked-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

>>
>> So we're losing benefit of batch-processing via kfree_rcu() and
>> instead using call_rcu(), and I guess it's fine since it's not very
>> performance critical
> 
> yes. Here freeing is not in critical path.
> 
>> so we don't have to make kfree_rcu() work with
>> objects that are allocated via kmalloc_nolock()?
> 
> Not quite :) It's on the todo list.
> Something like kfree_nolock_rcu() is needed, and
> also SLAB_TYPESAFE_BY_RCU-like and new SLAB_TYPESAFE_BY_SRCU_FAST flag.
> The plan for the upcoming merge window is to delete rcu tasks trace
> and replace with srcu_fast. It will clarify next steps.

I'm a bit afraid if this approach of stricly matching kmalloc_nolock() with
kfree_nolock() is going to be a neverending whack-a-mole. Let's see...

