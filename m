Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F08D46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12B36B0089; Thu, 15 Jan 2026 12:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC4D6B008A; Thu, 15 Jan 2026 12:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA17F6B008C; Thu, 15 Jan 2026 12:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C50386B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:22:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AD431403F5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:22:36 +0000 (UTC)
X-FDA: 84334867512.15.37255FE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 077EE80005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:22:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EAtr4zbT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=htmAa3Xt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EAtr4zbT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=htmAa3Xt;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497754; a=rsa-sha256;
	cv=none;
	b=x6QJhh9+wmT4Hdi2QBbX+4lcBdNhXiBR6keWCgfephldh9MfQZApe8VGs02L62rFDKZjlQ
	6HQj09PkZ3pigJN48YLcpOyw29vbsIrL94knonlk7mJt6kYO61p9KQATEJnyq7T5XOSgfB
	YLhxaN1UwFGmPVLat3ZKlo8RU34T94k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EAtr4zbT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=htmAa3Xt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EAtr4zbT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=htmAa3Xt;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQkTbSOqov3gFGYP77dR9tb9xxqrfKQr/r07REBkWp0=;
	b=qp8fv+n+3jirOSvFIp49tNR0YtsIDpiFWzYSQbwXht8zq6fsIDpY3vnzlYt46FAyDsapBv
	QvcGCgZqK/Q/CgyWNLbrM5m8OCD8oLiGOnd/B73u9ER26cOEc+y8b8cozlFq40f/nds/X1
	tLOT252mD/nMWcBE6FIjROd29W8joC8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B9455BD4C;
	Thu, 15 Jan 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768497752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kQkTbSOqov3gFGYP77dR9tb9xxqrfKQr/r07REBkWp0=;
	b=EAtr4zbTquzNS66eexwnv3w2SnYkOdAxhtja89ESCPzhXUQo723mRsQOzOsHrT6PdMM3L9
	8onP3ajBm3DIdgIQVzHNxOBcD3cKtSSgV03AXkouRAmTDcPob/6Qm45lXTPNqynpdrXlOh
	Lu7JuxYwXqZSNpfkq4dS1rxo2k+l80Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768497752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kQkTbSOqov3gFGYP77dR9tb9xxqrfKQr/r07REBkWp0=;
	b=htmAa3XtModxVehRTDKrHQhV7nQdZ4VrbI7EcM4oi/HSYfQjSexYqvCfPZ/AE+YGIEo0pC
	Whm8gKRAcNKAraAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768497752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kQkTbSOqov3gFGYP77dR9tb9xxqrfKQr/r07REBkWp0=;
	b=EAtr4zbTquzNS66eexwnv3w2SnYkOdAxhtja89ESCPzhXUQo723mRsQOzOsHrT6PdMM3L9
	8onP3ajBm3DIdgIQVzHNxOBcD3cKtSSgV03AXkouRAmTDcPob/6Qm45lXTPNqynpdrXlOh
	Lu7JuxYwXqZSNpfkq4dS1rxo2k+l80Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768497752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kQkTbSOqov3gFGYP77dR9tb9xxqrfKQr/r07REBkWp0=;
	b=htmAa3XtModxVehRTDKrHQhV7nQdZ4VrbI7EcM4oi/HSYfQjSexYqvCfPZ/AE+YGIEo0pC
	Whm8gKRAcNKAraAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 563BE3EA63;
	Thu, 15 Jan 2026 17:22:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LMW8FFgiaWmFDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 17:22:32 +0000
Message-ID: <88beb165-cb8a-4c13-af96-2a7e39653f17@suse.cz>
Date: Thu, 15 Jan 2026 18:22:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: use nodes_and() return value to simplify client
 code
Content-Language: en-US
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
 Byungchul Park <byungchul@sk.com>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Waiman Long <longman@redhat.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-3-ynorov@nvidia.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260114172217.861204-3-ynorov@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: pjdexbm5adddc797pjjp1zictce3r3n3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 077EE80005
X-Rspam-User: 
X-HE-Tag: 1768497753-173955
X-HE-Meta: U2FsdGVkX18QHKzHOHEhI86GTXBvw4TMMGtLRm7+P2ECPoIR3hj3OZ2f7kWDRpMwqurRiWMUL4HX311DpWlN2P8UMKurwR9iUxGUKLZsToveNC6q3vvrXbRc2OSkMqI3lr15UUvn5JJH7UtShqO+NbB7VOQu6wcOiz42sHx3C0jAqfr8F81oFfJePzipjwT4ChkJSw1yeGULTd+ZeS7hkMijJSurMOLNqjb6AQ1hpkYT+PYIYGClFgLhBpI/pUXZKtsbBdrOBExqzOlRPcHlAuzH9pi18nEhPWLSSh3L9hgB4dsJUn1WRSlmOKsgiILVfpGLsBM9y+C0SjJV13rFEpVeWFYbHw+Zpu42rPDPOtnt/DFHrPSTJOvrAlUrYFgY6fY+jMHvUalnVHQDh46TyhKQfcZsJlZxKOHC8/iyE4x27kvisdpoELhQyVp6HNOwOylJluUkcD/ZMjm/3aVlCIBOIeGjXSzbvrGYjHXdXH0lKJSMt5vo+bUXqj0z3shNdNBe172X98IyL84fKJiXzebfleQG3Ckkmo6IxYpP5gUhxeb+j9zCPZW+Bh1RuOAXyahtECcLKRxw1a4cXMGj94P6/dzZQy+n178K2g9l//iL4fXtm2YQbxLIrGJjFFN3cQL7WIBpgbqAYZqmFkH1nnaLXFoC/RDweIYnev6hgzySsmOchESU8grFMvcwVT8EMmMDBVKSNC2FuOEKE1DOcSjdoIQwJDJ3Em4tVHHn3h3yWsT9PLcrO/9wkX9AZ13/isoMgEHTkhavqvJEBMsNFyyTEbUP2xqnQ8to5mecSuD30GxFecTqgESjMQSu0jPnrL12b62clZ9fv/ANuLKA3X/qzBDOrUGkEq3ouncl1NFZNt2wUA5SoGcQpZsv6OMrmI8Jt0J2OxcpJYRiI2Jk+Vq3ps+p9be4e+xyasnKLiqvIhobfGAuk2pzIzHG3o6nxiARUqkwAtQZlQLZo/f
 cHXQ/V/9
 iVgAxKUgyOeDvJTUwh32LAbGlkeDvu4vf+wMzyS5pVPm6o8M83QqAlsVwOIeI+l2Wu0cH9rPPxAXCeeGUiKHgYvWx8wCOmwC/kRj0e072Fk8Gse29uE3iDltR/1RQO3Q+c0yOs/LCuUx5zb2uCll4D9TLqOySELHYuTkHGGo2CTPllXUwhVZkYoZM9BhU8QrflTCZpwjmdxeNMRuVkugqGJVjVzQHu8rol1ywMTrCmc8HfRpAn3ncVay+WEnUOq0B6EmXVKOjFZquyLE5dgNbjl4ypIepPtj+GYzk1GW4B8Un4rRwelPuxkPdYEmZswFwgRb6JeEPSC8z47GyGyHIxEuZ08l8R4abjOoLwtvl/oq+YumRp81HtFx83vPmQz8CslkD388R80DYu3rcc26r1IMTIK1nofKoXNF8XcrbbCAJzIc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 18:22, Yury Norov wrote:
> establish_demotion_targets() and kernel_migrate_pages() call
> node_empty() immediately after calling nodes_and(). Now that
> nodes_and() return false if nodemask is empty, drop the latter.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/memory-tiers.c | 3 +--
>  mm/mempolicy.c    | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 864811fff409..2cbef49a587d 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -475,8 +475,7 @@ static void establish_demotion_targets(void)
>  	 */
>  	list_for_each_entry_reverse(memtier, &memory_tiers, list) {
>  		tier_nodes = get_memtier_nodemask(memtier);
> -		nodes_and(tier_nodes, node_states[N_CPU], tier_nodes);
> -		if (!nodes_empty(tier_nodes)) {
> +		if (nodes_and(tier_nodes, node_states[N_CPU], tier_nodes)) {
>  			/*
>  			 * abstract distance below the max value of this memtier
>  			 * is considered toptier.
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..92a0bf7619a2 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1909,8 +1909,7 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
>  	}
>  
>  	task_nodes = cpuset_mems_allowed(current);
> -	nodes_and(*new, *new, task_nodes);
> -	if (nodes_empty(*new))
> +	if (!nodes_and(*new, *new, task_nodes))
>  		goto out_put;
>  
>  	err = security_task_movememory(task);


