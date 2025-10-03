Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBECCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 06:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C828E0006; Fri,  3 Oct 2025 02:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD5E8E0001; Fri,  3 Oct 2025 02:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6DF8E0006; Fri,  3 Oct 2025 02:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D21D48E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:52:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A865C04C3
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:52:34 +0000 (UTC)
X-FDA: 83955884628.06.2192492
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3275E40002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:52:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MdFVV1md;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Sa4XqljA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MdFVV1md;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Sa4XqljA;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759474352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX6RiGL+cjgZpJxdzOC3lAgawx+FysoKFUY5TPIj1e8=;
	b=AeHzdeTNVFO5kytLRh5QNaLapGr5adR7NQu5IZA7xNOH51TTY6PRWJgxRuZGs14YDJpDJJ
	RqC2hSSjRe67+0pHevRuVtTDbw51nloHCbCoTphuSS4gmvUmLkfZgx/ne8ko39sXcACo3b
	6cHsQdTOHC8HPg/aNJoxJct/kAnX6A8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MdFVV1md;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Sa4XqljA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MdFVV1md;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Sa4XqljA;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759474352; a=rsa-sha256;
	cv=none;
	b=H32CjX93F+Pt2BzLnuoJzgrTJ8pCgOd2UGFXPZ+Au9b4qBJOthTDlG1ZRkCOFl5/aa5odG
	Jgs/qzBViOBD+BfV1SPjgE8Ub3vnT4hvRjl4SqrHocyrbFg4FMaiBnDvj/IKs6tjslovRd
	JDASWw7RrONbxuNI2/I2d36+tHUCQ6E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 797531F455;
	Fri,  3 Oct 2025 06:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759474349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BX6RiGL+cjgZpJxdzOC3lAgawx+FysoKFUY5TPIj1e8=;
	b=MdFVV1mdWjpX5Voooy4m4FqOooqAMhlkKLrM49tVjyAcdMnTtBQhdRT+HJej/prwv9tHx+
	SmHDUAI8IhJ7aNlUBLVRry43mPqEo6QnqOxpTCxMGkDPZ1BmF1qSDmtLvPYKFifMJy5bTS
	4xGRP7jNRBQqyzhsp1ZfWftFVLG5jXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759474349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BX6RiGL+cjgZpJxdzOC3lAgawx+FysoKFUY5TPIj1e8=;
	b=Sa4XqljAPKqvAw6iNfLjzOKJSoc/jgG+cbFP38zUR3P2qToue2mR49IHT/moFZAExLmK/M
	yhx+R5Sg2+9Y4rDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759474349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BX6RiGL+cjgZpJxdzOC3lAgawx+FysoKFUY5TPIj1e8=;
	b=MdFVV1mdWjpX5Voooy4m4FqOooqAMhlkKLrM49tVjyAcdMnTtBQhdRT+HJej/prwv9tHx+
	SmHDUAI8IhJ7aNlUBLVRry43mPqEo6QnqOxpTCxMGkDPZ1BmF1qSDmtLvPYKFifMJy5bTS
	4xGRP7jNRBQqyzhsp1ZfWftFVLG5jXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759474349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BX6RiGL+cjgZpJxdzOC3lAgawx+FysoKFUY5TPIj1e8=;
	b=Sa4XqljAPKqvAw6iNfLjzOKJSoc/jgG+cbFP38zUR3P2qToue2mR49IHT/moFZAExLmK/M
	yhx+R5Sg2+9Y4rDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D89013990;
	Fri,  3 Oct 2025 06:52:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 11QUFq1y32h0VQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 03 Oct 2025 06:52:29 +0000
Message-ID: <be2a3a3d-395d-4a0a-9c32-488212710c92@suse.cz>
Date: Fri, 3 Oct 2025 08:52:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, ranxiaokai627@163.com,
 Andrew Morton <akpm@linux-foundation.org>, cl@gentwo.org,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, ran.xiaokai@zte.com.cn
References: <20250930083402.782927-1-ranxiaokai627@163.com>
 <aNu2xJMkEyYSdmW6@hyeyoo>
 <CAADnVQJ-bkd2UVsZmhdb1L5ZrXjZbTnRcaJ-D=ojsoiRHmHwaw@mail.gmail.com>
 <b9fb0a69-6cfb-4285-8118-ef5301115948@suse.cz> <aN4_PeDcDQUhv6N-@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aN4_PeDcDQUhv6N-@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3275E40002
X-Stat-Signature: py9pcz7a7k9y6ohmjiq8dus8oe8scs5w
X-HE-Tag: 1759474351-291066
X-HE-Meta: U2FsdGVkX19vpmT/JVFxfZavWma4G9X2cviieo7G3haLjrgS4L3GZdcQnIcJ0x0ZT2ZVn6hzYhm9KWsWuXgK7b52w77EB/cV7cEp/UqDvg1Q//2gd/I2Y/XZ96a2bKQqC2/FyxJuWeCd4+t6b5PQnj1xiudjaI0ElfraUrUSi11l8Tlv13wuetvOaZTanzoELYFD6Cm+eEBTU/JR94gMe9sHgTOLU1REJjHqeGb6gPxiWTyog+l8MW5PSHHjPZJZwPGvGr53uJz5nP1mm6llO9r8MdKZ6srKKvlNlt6Yw49nSMMuqfjKWHPY3apVa0N7JLf4B7nQ9oemWSGn4Avjth5WlZUFdm3xKpWmZFha2SEJU1Xf2F6LoTYxsQKPSOfg7S+ejXwyDwLQ3NCr0wwH4JeqA6pWyQZ7JAgwrnv94K7YnoR8If64H4ucxrxdMjJLPmU1KoSaE/8yrQ5/cAjCno/J1OSXlIlSghti/3C+H5f2rtGci7+z+wxsmdRyewMkb79b3dvc4mqAFKBbuzynHS6ixqhqKs05fM6bCgPln8VxSay/gAihrL6GxjZIE8/9mh3Q1c/MlDqq4sxmIGIAazoM3vN6Wh/7AeUozyG3YeOjls/khZ0S6ejkEPZ9RwJnleDFPvyEOkDjAAQM1AYzfZ6LNwHyO/bMRpyj8vYi7T2hojaT3yDBjG+l5B4VSlrN3OTwqrk7GXwK/Lc1LZBMl7j9coIEmFx57AG/w2tsE8TdhCqDcYInNxCrQaN6Y3g0uCpT6pzOEfg6+GWaa1NcVVt5KsXTUMGcSz7qh/bho0SmbXBvV/dkE/81esU68NyJsd2PORHhtowKiSjdibYabsPDHNwAU3YD/cfHkySSaIVB8OpyTW1u+LvfobAoiWKWG5ZxraaRzf0ZT2S44g09m5Lw3R8D2ln0YAwn3o84QIpvQ7gFs2k86voUIDIvtE907oFPkhfaOfRjLxBcR/D
 6RJXoY3m
 c42GYizGgbAk9tL4c0XZIKlvDi+io0Eo697M2Z1kZCNbdZLO+R44zqwTr8d9otKmhfJJaaiKJ7R4DsU8i25jPA3x8rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 11:00, Harry Yoo wrote:
> On Thu, Oct 02, 2025 at 10:14:55AM +0200, Vlastimil Babka wrote:
>> However...
>> > Is this PREEMPT_RT ?
>> > 
>> >> >  __alloc_tagging_slab_alloc_hook+0xa0/0x300
>> >> >  __kmalloc_cache_noprof+0x1c4/0x5c0
>> >> >  __set_page_owner+0x10d/0x1c0
>> 
>> This is the part that puzzles me, where do we call kmalloc from
>> __set_page_owner()?
> 
> It's
> 
> __set_page_owner()
> -> inc_stack_record_count()
> -> add_stack_record_to_list()
> -> kmalloc().

Thanks, missed that.

>> And in a way that it loses the GFP_KERNEL passed all the
>> way? I don't even see a lib/stackdepot function here.
> 
> Oh wait, we clear __GFP_RECLAIM on the first attempt to allocate
> high-order slabs. so gfpflags_allow_spinning() returns false.

Ah right! Dang, that's suboptimal that we intend to do an opportunistic
attempt, but limit the allocations of supplementary objects this way. But I
don't see how to avoid this without inventing new gfp flags.


