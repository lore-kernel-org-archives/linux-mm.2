Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A997CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC438E0005; Mon, 10 Nov 2025 11:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C8A8E0003; Mon, 10 Nov 2025 11:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B818E0005; Mon, 10 Nov 2025 11:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955378E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:47:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F16B1601D9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:47:18 +0000 (UTC)
X-FDA: 84095277756.24.59DBA67
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0BA110000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:47:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jmR9vB3C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yi3kbSny;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jmR9vB3C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yi3kbSny;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762793236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0o4cR/QIKNwMr9gQ6XYldm8m+A5IaM06kIrGj5uVkvU=;
	b=iYgqEQfgSII+kAj0HbG/F0OacZulBevJFgafI4qmYrUHBxPzuhrkFMWcIR2R5UHf7TM3O6
	snmbh6DpttlfeTEglgboCkDORnV4M70QHnzLtzFIsPVl7Ld6ZSnBjv5fllAd60OTHR94HU
	K6h2DOIZHdA62gQ6Azj+GeIYg830tM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762793236; a=rsa-sha256;
	cv=none;
	b=K924QxwmulHHtGo12pUKZ1yxVgqBvBulKIEXjujTrHXkev9K3meOROqoaaqxX3Q6RUImLL
	Hfr+mwefFfEgK/1eOX7Y4kiWCCRI6KSjgRqSp790OFKOUdia17EBo49zSv4/hYaw51IIAb
	zoHzQH/+kujGXqzbckxnB6Aijm+6I3E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jmR9vB3C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yi3kbSny;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jmR9vB3C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yi3kbSny;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EC3D1F7F4;
	Mon, 10 Nov 2025 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762793234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0o4cR/QIKNwMr9gQ6XYldm8m+A5IaM06kIrGj5uVkvU=;
	b=jmR9vB3C/4IJHwDe5el+xGIHyxDrNpTAs5i07yy2YCs7/PCbNp8nFsD8elSbOIA1h/y2GK
	PnbhyXgm1DqUW4gmqaHfV1aSr1x4lCF+k2d3od9X2Fo7uBdz7cooSNVIMuh0K6/Q8ZjJma
	PYNFpBfNHiBzI8rD60hHjppfqRaBCRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762793234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0o4cR/QIKNwMr9gQ6XYldm8m+A5IaM06kIrGj5uVkvU=;
	b=Yi3kbSnyLKZFlz1PJLzSNBAgnO6X9gmH2kQt8ghDYpIR8b1sQHx7NDgvQfqYRA8d/4YGqw
	PGa4NXkN27O4+vDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762793234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0o4cR/QIKNwMr9gQ6XYldm8m+A5IaM06kIrGj5uVkvU=;
	b=jmR9vB3C/4IJHwDe5el+xGIHyxDrNpTAs5i07yy2YCs7/PCbNp8nFsD8elSbOIA1h/y2GK
	PnbhyXgm1DqUW4gmqaHfV1aSr1x4lCF+k2d3od9X2Fo7uBdz7cooSNVIMuh0K6/Q8ZjJma
	PYNFpBfNHiBzI8rD60hHjppfqRaBCRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762793234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0o4cR/QIKNwMr9gQ6XYldm8m+A5IaM06kIrGj5uVkvU=;
	b=Yi3kbSnyLKZFlz1PJLzSNBAgnO6X9gmH2kQt8ghDYpIR8b1sQHx7NDgvQfqYRA8d/4YGqw
	PGa4NXkN27O4+vDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 024F0144C0;
	Mon, 10 Nov 2025 16:47:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fa04ABIXEmnNGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 16:47:14 +0000
Message-ID: <025d73b5-8947-43b3-a85e-c112667c030f@suse.cz>
Date: Mon, 10 Nov 2025 17:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Memory leak in 6.18
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Tytus Rogalewski <tytanick@gmail.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
 maple-tree@lists.infradead.org, linux-mm@kvack.org
References: <CANfXJztHS4t=w+2Ogq=fHe4WS8CwOJgxog0ZSVf8C=9-4Xx0RA@mail.gmail.com>
 <aRGAUjkKe_H1xc7H@hyeyoo> <aRGDTwbt2EIz2CYn@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aRGDTwbt2EIz2CYn@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0BA110000C
X-Stat-Signature: 7hstmq7bh7krxoy3dqg19g91wq5tpby1
X-Rspam-User: 
X-HE-Tag: 1762793235-606033
X-HE-Meta: U2FsdGVkX19Whlo4Wm0vs7sy78dPjcPfV1gkiNz4xVQjp4NnF+7iyY+/6IM40CG/ShezJGq1BcEeZhjEtC+mfd0TVbc9APAT5BIoTm9Udxy2GDZu5ulJnxv3/azAkyRVUjbcoMD47n1PVUWHk48AYywL5puUekOxwvtvnr9E9uLFZUrNxf1HccBnQls/46CbOJBBPqzm3EsQElwVhu4L93MkBZA/R6YWDOjShqEZIYxJNUoFubsxXxfFyhmNdkBNoNyaMESiP6yav3dOrQgqwMgovUt+rp50MRVuR+RtA+wPO2V84QfpZSD8BCuTbQ+qvN67RHh/QUCZasm9T26etWXTqL0el3ldz6nDiMVavo6Z56WQOJLy3YjlXpeG1Y094jEoohlabQqfhUDaHyFEOwN9fnMARMkr0oSj/mOQ2BMS1jvXikiFMlyZKoa2+ehIPeflnhGAaj0SC5dpQP0fnnSC9mirTuoun1q6eriDismgUN+G98pVyzOKik12877CQQV2yN75scfUVX5tJoXcznEx3e2llCbgACZgqkWfeLFV6sYQD6CdkdJDVRuDBcnnb9TR31kJrG8NbkhH4EZAx9ngYLtNUK59prfnQ9b8udqPF/qFgUk81Ir3IEfT/2XfR533POfb0XCE7bHRqO4v05kCDI5F3vWjwo0Cpbo1bEzmM4rayX65MiX0LW1UK8SfBbQi7q1HfEYmmdASVLVsMMblKVKfu0Mw7t3Bm0XeTCcY9BbZRs3f3yqhbuCvCs2YfMime6DU/Pb9C33KAxGLDStPDG9ahD10PGUuwjztswbEZGClXSXTpq4gFDtI7zI+3cU5Ag3sPi9SsJF6IKmQjh4yoqQKQkw5erp8KaGnvI5Hko+BYDSfKgMhM8qtnnT6oRE2WtcWpnySXTl67staLm69OWcWGs+Uo+qudzMH/OqdJuVcUW7JurVdYZKW+NP2YoEwUp9ONe5gNg40//J
 T9IlzkFy
 rYgc1Y7zd1kh6PQaZQ7uFz1dXoSWd3eXx7Rew3i6QxLswe/ImQ4EETdCrDlT7Zfv7fQxJt41BQkmGzfeEK3komCVEBd0+N0hYbdDXQ045H8OW5y3YLKc1mosgpW86JUcRjmYzwJ6mNMVqTCgBhI3u21DhtaWcw+71ble1YFCzj1NlvufKAD3ttxvQgfMcCNEDfrP6vhFQlNSHW0jnhPKn+6nCZiPzDdq1GTaPFdNlUGWk3de78ez/o2x5xLvcSbpiHmidlIAcsP/DCiRJk1dbI7wuXh5JuaG4ZUfq6Lu68Z2JHGE9NeO+pP4YvaEER9vPxlzpaUytK1h9D7nXx4yxIAVEtphYuEYdc2Jdu7rgjc3HRFwTU/mvuBLyrqbAiQjQgrj0pOVYt/8pKj2Ul6y2pV85WtqMYK9URHL0UcensBca/1+s/n3RSRzE8RXSmmBC96w6zgrGOeTYNZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 07:16, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 03:04:02PM +0900, Harry Yoo wrote:
>> On Sun, Nov 09, 2025 at 11:36:26PM +0100, Tytus Rogalewski wrote:
>> > Hi guys,
>> > 
>> > Been using 6.18 kernel and i have noticed that there is some memory leak.
>> > Currently mapple_node takes 86GB when server does not do much.
>> > I do not see that issue on 6.17 kernel at all.
> 
> Cc'ing linux-mm@kvack.org properly as I modified the address by mistake.
> 
>> Hi Tytus, thanks for the report!
>> 
>> Could you please boot your machine with kernel boot
>> parameter slab_debug=U [1] and run
>> 
>> $ cat /sys/kernel/debug/slab/maple_node/alloc_traces
>> 
>> and
>> 
>> $ cat /sys/kernel/debug/slab/maple_node/free_traces

Agreed. What could help in addition to above is also enabling
CONFIG_SLUB_STATS and also providing the output of:

grep . /sys/kernel/slab/maple_node/*

Thanks.

>> ?
>> > Total 1000 GB memory
>> > ASRockRack GENOA2D24G-2L
>> > 2x AMD EPYC 9654 96-Core Processor
>> > Running Proxmox 9
>> > 
>> >  Active / Total Objects (% used)    : 472110239 / 472257124 (100.0%)
>> >  Active / Total Slabs (% used)      : 7385489 / 7385489 (100.0%)
>> >  Active / Total Caches (% used)     : 164 / 231 (71.0%)
>> >  Active / Total Size (% used)       : 95486861.00K / 95528053.72K (100.0%)
>> >  Minimum / Average / Maximum Object : 0.01K / 0.20K / 8.06K
>> > 
>> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>> > 345907216 345897683  99%    0.25K 5404801       64  86476816K maple_node
>> > 120873408 120841337  99%    0.06K 1888647       64   7554588K dmaengine-unmap-2
>> > 224256 223324  99%    0.01K    438      512      1752K kmalloc-8
>> > 224040 224040 100%    0.13K   3734       60     29872K kernfs_node_cache
>> > 196608 196608 100%    0.01K    384      512      1536K kmalloc-cg-8
>> > 196160 166455  84%    0.50K   3065       64     98080K kmalloc-512
>> 
>> Not sure if this is because of sheaves or maple tree changes.
>> Let's see what's in the alloc & free traces.
>> 
>> Or it would be great if you could build the kernel and perform
>> git bisection [2] and give us what is the first bad commit.
>> 
>> Thanks!
>> 
>> [1] https://docs.kernel.org/next/admin-guide/mm/slab.html 
>> [2] https://git-scm.com/docs/git-bisect
> 


