Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9B3CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223938E000D; Wed,  3 Sep 2025 12:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4998E0001; Wed,  3 Sep 2025 12:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C298E000D; Wed,  3 Sep 2025 12:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8ACB8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:10:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0CF711AA99
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:10:30 +0000 (UTC)
X-FDA: 83848426620.14.4735CDD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49654C0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:10:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUnhmb59;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lQbHs7/a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUnhmb59;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lQbHs7/a";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756915828; a=rsa-sha256;
	cv=none;
	b=NT/ZQDpvudFmvnxDaUrXiJvmUrX2MoA0/0vTDJCj3MaYuJ4hDsf/nbXqrYmhjUYXT7WjnK
	VcfMSP7n8B1Cilmkob85WkO3D5FqE0G4CFMZVjnJqqzPoDnsMaSRYF5gww3K8TCm/DIWhz
	AVPRXpKACyfZQ/hZN/PuQCrugBth6A0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUnhmb59;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lQbHs7/a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUnhmb59;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lQbHs7/a";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756915828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h97e+xHdu6d6LbXnSe4e6A6MWQJlLX6y/dA1iEDnMTg=;
	b=fno1lCUoBaBu2uAZ6CQqyIVuJ3/MhGNrRQdoQl3VeHsIXU0ZLZoc797sR68LHLwEHfXkEU
	pyDbbi18LAbrcx1XPlBI4pES7hzTOgID4syQPfq+PpOABkt65+nCe97+eeQZms2drfilIj
	cgfSulIHbNiR4ounrVlfRXzAbw8zuxI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B41F211D4;
	Wed,  3 Sep 2025 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756915826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h97e+xHdu6d6LbXnSe4e6A6MWQJlLX6y/dA1iEDnMTg=;
	b=uUnhmb5951oPr+lmOQkqf9TMWNBXHqh0GqJOAsJ9nD13Is+8ymMDEI8LyQRVNUh35zpona
	EM3da9AuX3Fp+3v+B4inWjMzLUfU6SFxLCeCTji6wO+9/QBp95Mkads+kSJKLuTqFWEtjO
	QA59T5sdzDuBg042i34Us7ZuI30yAxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756915826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h97e+xHdu6d6LbXnSe4e6A6MWQJlLX6y/dA1iEDnMTg=;
	b=lQbHs7/aPFGREwi6ClboaSdsHNgjEN7oCrj+2NKsGaQYYI8Sn0elYTdTFHAjPY73D74TFv
	vXDaNWkFFy7nYVDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756915826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h97e+xHdu6d6LbXnSe4e6A6MWQJlLX6y/dA1iEDnMTg=;
	b=uUnhmb5951oPr+lmOQkqf9TMWNBXHqh0GqJOAsJ9nD13Is+8ymMDEI8LyQRVNUh35zpona
	EM3da9AuX3Fp+3v+B4inWjMzLUfU6SFxLCeCTji6wO+9/QBp95Mkads+kSJKLuTqFWEtjO
	QA59T5sdzDuBg042i34Us7ZuI30yAxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756915826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h97e+xHdu6d6LbXnSe4e6A6MWQJlLX6y/dA1iEDnMTg=;
	b=lQbHs7/aPFGREwi6ClboaSdsHNgjEN7oCrj+2NKsGaQYYI8Sn0elYTdTFHAjPY73D74TFv
	vXDaNWkFFy7nYVDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7345A13A31;
	Wed,  3 Sep 2025 16:10:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jc3TG3JouGgFdgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 16:10:26 +0000
Message-ID: <960bcc7b-2d48-4709-b6c3-4048b32c46fe@suse.cz>
Date: Wed, 3 Sep 2025 18:10:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756897825.git.pyyjason@gmail.com>
 <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49654C0009
X-Stat-Signature: naacbru8aak6homfwuzg7ihsj7mkjkno
X-Rspam-User: 
X-HE-Tag: 1756915828-204831
X-HE-Meta: U2FsdGVkX18YNy0PulnCarRtpF/2KQM0TtGOzTdAdIPWOHNtfOPaK4oW7gyjOUFse5TpBtIwxx2o15n6b++jjS6o21TsJCBo+lFzkfVf5o1US1uz0xssk2WwAz7FrM3ya3XHadupIlm81L1iRjeJnNDMuqBZS25keydz8T6zKeg2qq95f3lksJlciPW0o+2TAWWKmZa5gAj75O+xkchycuc4jAUATE/RzNznz7wS4NQZNXpwMR0yB8BUDiCVzOizB32+rsjtA8DA6r8I97h9Xc4J/9n/1Y4MjaLw7i3tvJy0kXhTBekno9qkCew4DzKtGJvX9qiry5ljJbQQB4Crmn3bh0o1RbVVE11JI0KiHeliXkn8ykdsnNvvS+VAhEE0tKFwSeFEuPoLp7tj9GrAEjvR6KctRFrSH5heQXYe0mx5W2GHUOexKIvdMb+4/moq8E+znG3UHq3hrd+4gQt1VE9DaoaOcK1pO9orxrKdzl9JTIxa0xerCaFzZoPgKwAqLwdEqX/zfHYuogEef7+muFM9J6SG7WAH6oepFM4JXhi8ZnE78W4PiIvMRxJzFP1r7wtKVcndkU9PI696Pzg4l7oKlLLomUenN/K62n434avbZGQm6u7wRyA7oBi2TTOInBNJaD8gQS/ZuiGE0aYnhuVoeR6GmRlFq6WrxZwvhvwFY4hgy+Hl5xuyJdCLu1hfEPF/3ypnVloTNR2C9S7B/oHcy5XDvO/mn5s6ydM4EAvGFnzfVBPlklvXQF51opPCqJ8et49Zd0uagZZY3BIuCKcj4Zn/CKvO3B06NRvByzaeJtSUtGxppC+UnvvfzZSvF5eFSNnbssQaX5/n74del4DNUQLCpLSsiEmRmWcI9+Ap5QpNOOdYd0s5aFTmZLNAuYsfxpFe3EfKlcPJqIViknUfT/kkcdtrGRidEHRNoACvGza+hc9Tr90M09HO5ghHzweLXdB0crg3dR4OlSS
 6OcUgzj1
 +lURDG942RBl6rcu5+OSurcEB3zwCOBo7vU6PF6C6qXwT7RQ1R0Y0LCsvv6PNbUBZt1Dg9XiQBT2za6elR47zrkdSi24pHtEIMrgQQ37dgT0Grg86d7OsgI1IObf/TWXRaEiwz7frVaJh/go9BtbtFLWa/j4PXdOsCxwxvIuXctXKABXBUuE7Ivp+wKAycT6V4sJdz832C2LVesGv+WCVIqnCHYlfu/mFdc/i1HiQeKrDDkH3ETmJlxFFhi5Zlq/JMf9QFuOjAlGUHNN2ZGbaTwI6o1ipGiQc9h7eOkUDttyOITnX9HQKSLiiRTnmDmeGDaog+113uZ1OGaniAxFBIMSqxZIpwqxVTEigyR6erEzclEBqvutxtaYrkQuCgzxuK4lQIRNJuRNqWU5AX/9ubB1KrZW/qYPURfqlg3977mCuq5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 13:16, Yueyang Pan wrote:
> In production, show_mem() can be called concurrently from two
> different entities, for example one from oom_kill_process()
> another from __alloc_pages_slowpath from another kthread. This
> patch adds a spinlock and invokes trylock before printing out the
> kernel alloc info in show_mem(). This way two alloc info won't
> interleave with each other, which then makes parsing easier.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/show_mem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index fd85a028a926..e9701d07549b 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -421,7 +421,9 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	{
> +	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
> +
> +	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
>  		struct codetag_bytes tags[10];
>  		size_t i, nr;
>  
> @@ -448,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  						  ct->lineno, ct->function);
>  			}
>  		}
> +		spin_unlock(&mem_alloc_profiling_spinlock);
>  	}
>  #endif
>  }


