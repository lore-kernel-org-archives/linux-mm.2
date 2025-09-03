Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C81CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C408E000B; Wed,  3 Sep 2025 05:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CBC8E0001; Wed,  3 Sep 2025 05:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BCF8E000B; Wed,  3 Sep 2025 05:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D99F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:22:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5AE511A3A0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:22:09 +0000 (UTC)
X-FDA: 83847397578.21.DEC7D2A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7264440008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:22:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DeRmRlRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N920d0aS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DeRmRlRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N920d0aS;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2D2+rCzSUZgm8Y/w1eAdyWKsVtEEi0m1d1CduX9pFIE=;
	b=vOr+Jm9xf5hdOBfaELiPyOdk3PJoSyLFibr6cU8Jmc2aID8wGLMHo57mND4CjgcEuULl4m
	J+RzLi9jLbK66t7JVCtavWVtIs8XSbsN7+av2yuSi0iUuNDoqQDg3BuPZXRUz60qfR5bQ4
	WJ3kNDWXLTJGewkKsVs5TpRLJ4Rnxys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891327; a=rsa-sha256;
	cv=none;
	b=2F5A/oGv2TqsVy33TiFpL55tfY4ovm8P2fpdNpCCPBtZu6ntJFvqu+UA7nZdp53SNqAh8h
	K9ioRyNsYOAzNXzoVenBGyJkcvSjEcu7NqH+KT9RTVWRJlCTsVAixw2fnjd8clPKebpoEc
	nIxZg4/jZwzwhlSEinNhmLkDPpE3+RQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DeRmRlRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N920d0aS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DeRmRlRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N920d0aS;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C95121244;
	Wed,  3 Sep 2025 09:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756891325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2D2+rCzSUZgm8Y/w1eAdyWKsVtEEi0m1d1CduX9pFIE=;
	b=DeRmRlRVrNmcVf7+nDiTve1nnirLQxqHNbn0FW8j1CJA2m2f1V8IDkHoXlibpKgDsrcdk0
	jJVqTKNmwRrGylXXgSjSoX9k7LO/ZdeWB/Y4Ru1b9BFmMHmzmLzDTuvLROOaa46csSUCMn
	5a3bOsYzh8eKujGDoICzfx/c3JXgDRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756891325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2D2+rCzSUZgm8Y/w1eAdyWKsVtEEi0m1d1CduX9pFIE=;
	b=N920d0aSZ+3tGBOweymglgMbQU9i8FYjgqADjmEXTR4e2aAvVb8tQ0MGR0Tl/D7tC+S95h
	8GmDPyadoi3sS2Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756891325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2D2+rCzSUZgm8Y/w1eAdyWKsVtEEi0m1d1CduX9pFIE=;
	b=DeRmRlRVrNmcVf7+nDiTve1nnirLQxqHNbn0FW8j1CJA2m2f1V8IDkHoXlibpKgDsrcdk0
	jJVqTKNmwRrGylXXgSjSoX9k7LO/ZdeWB/Y4Ru1b9BFmMHmzmLzDTuvLROOaa46csSUCMn
	5a3bOsYzh8eKujGDoICzfx/c3JXgDRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756891325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2D2+rCzSUZgm8Y/w1eAdyWKsVtEEi0m1d1CduX9pFIE=;
	b=N920d0aSZ+3tGBOweymglgMbQU9i8FYjgqADjmEXTR4e2aAvVb8tQ0MGR0Tl/D7tC+S95h
	8GmDPyadoi3sS2Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DCA113888;
	Wed,  3 Sep 2025 09:22:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EFi/Hb0IuGhuZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 09:22:05 +0000
Message-ID: <2c9d2e2f-adab-4bd6-a03e-a327a4c5d6fe@suse.cz>
Date: Wed, 3 Sep 2025 11:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756827906.git.pyyjason@gmail.com>
 <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7264440008
X-Stat-Signature: bpaxdejm1jeapo5oug6maidcxj7onsdf
X-HE-Tag: 1756891327-107002
X-HE-Meta: U2FsdGVkX1+sI5zh1kTnJ9YdAqiFYOFk6ILvgurfS3i421VseE0C2Pel6mbfLPzyQj9InjXMBRjL7b/zgTOp0Kb6csBLhk5yglD7ZCNGxBkyyOZ74SHXUpBSdEUyEDPWv1pV87kbnQUm2KqRzURuh8IWxSyTFVt8VFpkEeepX9CQ0xgyI6TRGmqxCOTMubh7ixlcAQ00JYcE0NspOa+b2JPBYjGn2PW1sBFGCpfWO/tF78Gs4GY0tdQAlbLhjN23BbVDfSywAOPh5nYEHd6SujhoVfnI5Fb8DjcNQj6RRtRmZQjYhTbi1OxOypGv8URgTyp+aeR2Bi5bJw5BieA0C+iW4hmPvPMgLGqgxtVq4GsNGGZEymJN1pNQrMNvwU8qE5O3dpYSW/4vefEQ5cQ8DsOJic1XPCjJdSIL2iP5DYEBiYfAXyaUw4hbPHSGcZBlQtzDGYQqsbQ33jsShRFcWMgGsQCv3lYJ96qxGx0be67xNYWPVvzLseYhQ3bQy/wkQwk6TSpVvRGtrb+YenKnmRn11NWaotJWCbNL3yyIQFSBZ3gaUHTL9udznjUK7HlMRXM+R0QLGoVEC/9WHugtudi+tuetEwy6ouaS3l4/DY1HoaG95nGgx6GnkGHFcncdMHTAIM7elL5RnOaw71YEXDbI2y33DbpD69AImm2bSeM662EO8P/SLwS9ARCwoo+hzirC5gavegs2lPZrUPEeRP+dVO79B16NFRDRZr5l19+IJ12IVmgmg7CwquuZLlNLzxhMnCmQqiJHkIwbTtohQc9sq9613U3l4ztl0hZ/rIjXcpI7OdTk3NpyIvokJlOCgNbZLzVZmxYuUbHvb4d29yrjiFG6e4kJydPdmtRWpY1ASes2CNxfrYmTHfDvI0KEj76/8qfJzxm7XJq4TbDNmPN83vgN0d4NeM03oAzU7h/inBbJ8og6htu0WV0/oCxiOxrp3cmCvfo1gOIlC6X
 VCeO+tmu
 64MUzF7ByavwuL1CaM9Vo7hw4s+BzhZZL1x3olsLVMZq1yI6z8aeZDEjcyRLMWkK1FYf2yQEAdXqtb0yIvRBf/aSenGd2cgH1GoATqGvu5wX0qs1kInPwujdT1uF0ucxEdMu11xDmru27WoJkkfMNOlAzIuLavC12PrWB2pI+bQG5d14AkJQ2VjBK0szlRWDTko5klkA1nCmBwqkWB4xIZIBtIgJHIxnouM6/g19yYDiQJHb8nUxX/X2uCsSA0r98KCAqEERScAy4NPdsdBP+O6xnbDDvsrqpw2E8YHQQcvlL+j6u6HPy9o4mBH+CkuDwBgDUhUUS4bmlJ1mQqi4+i6l7s+6u3sH26uhEVei2r+KZglJfI4Djn0XwCLkz7wDHFebtHJqgLhd6aTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 17:57, Yueyang Pan wrote:
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
>  mm/show_mem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 51892ce2efc4..4c876ea2b66f 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -396,6 +396,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  
>  void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  {
> +	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
>  	unsigned long total = 0, reserved = 0, highmem = 0;
>  	struct zone *zone;
>  
> @@ -421,7 +422,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	{
> +	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
>  		struct codetag_bytes tags[10];
>  		size_t i, nr;
>  
> @@ -449,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  						  ct->lineno, ct->function);
>  			}
>  		}
> +		spin_unlock(&mem_alloc_profiling_spinlock);
>  	}
>  #endif
>  }


