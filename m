Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A941C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D9C8E0013; Thu, 28 Aug 2025 04:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A456C8E000B; Thu, 28 Aug 2025 04:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D2D8E0013; Thu, 28 Aug 2025 04:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA678E000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:41:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02C71853AB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:41:27 +0000 (UTC)
X-FDA: 83825522256.19.2381203
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id B98E21C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:41:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0zugYSPR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=livtRXkE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0zugYSPR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=livtRXkE;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370486; a=rsa-sha256;
	cv=none;
	b=tlyTsqNCXyCj43kMvRUapo4PUl5i46xzUDebf763jf0Y4rUHG5Z3sS6Aah/CQdZRIibuib
	7BeLsXujCmKf4FtkzO5iW6zyaVD3lfH50iEUwYj4pjNUl6GvCFfVTc4Q9PsR9vZDuPwP4C
	IvarNm05cscyZDf2n0v/iXjRjx5a9YA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0zugYSPR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=livtRXkE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0zugYSPR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=livtRXkE;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoT3WpLXuS5g1YdpdWEcQMKSsUF2k8LBxp9VlBICog8=;
	b=QhjcsnQ98Ej8p6O866DUE4mMfyZHQNh9x/7zuHPBNp+rwf70VOBvlZxaLE+CNm6fI5cZjC
	cjfmRtvkJK2FsQays8XqespitSsWX25rsCEF29RhopiO+w2RedS/YGU7em5v4IczZDoo9P
	Id+yxdywR5GbgEPwvEqVTNZ4GkNvzXI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 03F5820ADA;
	Thu, 28 Aug 2025 08:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756370484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xoT3WpLXuS5g1YdpdWEcQMKSsUF2k8LBxp9VlBICog8=;
	b=0zugYSPRaDN/zgfsqne/WIBUJnnRNvcwknLZS9R7BTqnI3lNm1eyv8hPg5oU6tlC2sU2ih
	2Cst6vYKW5xiYW5NHJAYTGNqz7iUqkD8nJoxmrdoHu7+Kw65QC7ayD4K6qeNNhgaLtPJ0q
	FZMWM+6Ik0UvU6662B0RiL814UCYZg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756370484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xoT3WpLXuS5g1YdpdWEcQMKSsUF2k8LBxp9VlBICog8=;
	b=livtRXkEUtDMGHtTSzI/ZxyJIz71e67buIPw5OyZfpU7Gq2DJ3hT/GWZTM/Y/Y4uIFV+dP
	Z83H3Dpnp36H1cCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756370484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xoT3WpLXuS5g1YdpdWEcQMKSsUF2k8LBxp9VlBICog8=;
	b=0zugYSPRaDN/zgfsqne/WIBUJnnRNvcwknLZS9R7BTqnI3lNm1eyv8hPg5oU6tlC2sU2ih
	2Cst6vYKW5xiYW5NHJAYTGNqz7iUqkD8nJoxmrdoHu7+Kw65QC7ayD4K6qeNNhgaLtPJ0q
	FZMWM+6Ik0UvU6662B0RiL814UCYZg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756370484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xoT3WpLXuS5g1YdpdWEcQMKSsUF2k8LBxp9VlBICog8=;
	b=livtRXkEUtDMGHtTSzI/ZxyJIz71e67buIPw5OyZfpU7Gq2DJ3hT/GWZTM/Y/Y4uIFV+dP
	Z83H3Dpnp36H1cCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D30BB1368B;
	Thu, 28 Aug 2025 08:41:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vqqAMjMWsGikLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 08:41:23 +0000
Message-ID: <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
Date: Thu, 28 Aug 2025 10:41:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
To: Yueyang Pan <pyyjason@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B98E21C0007
X-Stat-Signature: jieqataj4jcbfy5a1bqgd7onu87r6rpw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756370485-550914
X-HE-Meta: U2FsdGVkX1+wfZF3ovcS8ZFDgPo/JRMHFsZ+Q+OR1ZEfOhJH3JIvo3JWSpcRNyo73UkJlehNpwI4+9WnFpd08rGkW+2g7dMGUozUyrKWjKWtxbeyjeKqyp3QyUuiSDqSq151fMAl60iyni/f+oSUPoI9pc1nNK+akx4+9kHVPFckCJcpa94jKc1LnljRELOwnzWd+qLMg+Q3lch24etwA2o+YFF7QZYjgSKhBfskDMkIXmJ/QpiEFxEvpYRMfMD8S+gQAuO+elzNRufHeGyMYY+WiJ9PNk/2+pQPdFKD7WXbr1MzcHZVoOC3C1apB7AG6GuU73NdcLeYN/aJ6qll0ICFWDr2j0P0ucEaOcGIno0bGetL8aLjlRnvUuai0KGEY8FqYHnrp2Nc2alZHpGIsmV8ll39BkpWxjd9S557ZPsD8Pi83HjmAWSc5jZdyHHLrRr38eXWTLjSDoog4KcJNAHmaoxdlnHaRhmU6zLVJJvIHoMj2ncDUQXgtKWkBJmsraxJlKTT6bJFY3KhLp00erqkn1y3XscxSYj0Wd0xP2eU5ZL1S73fttMSG2FSbM5whQwg8pMoA97haHNK+rsK5VTXUyOc5okZATmOmDS09bTYhdKSwSfYimsWiBk+ZIsAJnEu2Cr6q0M7ctjQR8w9+ZPAcxDbxVAipfPswOeFqwcbqP+ju6ZXnpGjGwHdwARnKtkURGlvcXNIRbDJiJL5s9qxY+ErXGGPXijqM5sjmwOUiPdyh9/adXfZ9cvv7mulrcXepFoywqA5/vzQF7uQfYXIkITy3tdMjRrqMUYdHTsBZtg60cRd4hFjb+DxbueFKMQNTuHct0ecqqfbeO6rnW6udphbiyMYENM390FpM9dtkV06kKYh7dCB4SiQpetnBBOKQf5IvfsA6ukH6tOABDlBuY67CHOLDmR0XBGu1GAxIYFO3k6Ma+8MA/TFIftzWEJPVS6eFVpUnvQ0hTB
 BaPV6XfO
 fLCe6+rxxeEA6NfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 10:34, Yueyang Pan wrote:
> On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
>> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
>> 
>> > In production, show_mem() can be called concurrently from two
>> > different entities, for example one from oom_kill_process()
>> > another from __alloc_pages_slowpath from another kthread. This
>> > patch adds a mutex and invokes trylock before printing out the
>> > kernel alloc info in show_mem(). This way two alloc info won't
>> > interleave with each other, which then makes parsing easier.

What about the rest of the information printed by show_mem() being interleaved?

>> > 
>> 
>> Fair enough, I guess.
>> 
>> > --- a/mm/show_mem.c
>> > +++ b/mm/show_mem.c
>> > @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
>> >  unsigned long totalreserve_pages __read_mostly;
>> >  unsigned long totalcma_pages __read_mostly;
>> >  
>> > +static DEFINE_MUTEX(mem_alloc_profiling_mutex);
>> 
>> It would be a bit neater to make this local to __show_mem() - it didn't
>> need file scope.
> 
> Thanks for your feedback, Andrew. I will move it the next version.
> 
>> 
>> Also, mutex_unlock() isn't to be used from interrupt context, so
>> problem.
>> 
>> Something like atomic cmpxchg or test_and_set_bit could be used and
>> wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
>> here.
> 
> I was not aware of interrupt context before. I will change to test-and-set 
> lock in the next version.

Perhaps simply spinlock_t with spin_trylock()?


