Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FBD0CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0C58E0022; Mon, 10 Nov 2025 17:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8218E001F; Mon, 10 Nov 2025 17:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB448E0022; Mon, 10 Nov 2025 17:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7E0B8E001F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:23:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70430878E9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:23:36 +0000 (UTC)
X-FDA: 84096125232.26.8BB79D7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0344A40019
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:23:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hhJTEX3K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qi9cuWhO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bWjVmeP9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W7o3Zv8q;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762813414; a=rsa-sha256;
	cv=none;
	b=6wGfvL/+5voGC2kpiYG5dUVIIsMOTKEedFDKi8srrSRnchocSX8X1GvKE9Gyhw/M438BzR
	xJUdviqloT2kggKfl2IIosMBnHVw0mtd+P8Jc9dkuPhKoSYtOJl6Laxyac2xFHCsicH8jQ
	dk9Cqp5I/NpiZlAzJb0y/g4AkYcYyBk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hhJTEX3K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qi9cuWhO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bWjVmeP9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W7o3Zv8q;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762813414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJ5uN+MNad48N217HhdWLsdsGlsR7kLJF+v92YcO6NQ=;
	b=e2/03pnG9LfyI/j10iqhaXWc7pZ3fAvlDD8UurRIltckEPaPJdyZew6giElQx+lfSBVhhl
	3LYZPZJdDitW+RS7mmr4reBzp6Ulvo/NFiOZvH+F1waBndbOA8pN6TgoOlr6A7bHNR0CGn
	4GS+xcOrc2wR/oR5e46fkSTUkJcsxfw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54F6A21A1C;
	Mon, 10 Nov 2025 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762813412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NJ5uN+MNad48N217HhdWLsdsGlsR7kLJF+v92YcO6NQ=;
	b=hhJTEX3KoCse7N7gNqtME5tqzOtcv8hObJM6Xk3Eo1KNfKLlWS/7u8hsgRrYUWZiax1jGl
	18K6f+pn4uo/lzk/FkxjVEtbf+9Sx6TchHh86wDCziB/YelelGfWz2EhptLdMcRogYQLCe
	q7qbA+6wQoLgH8bMP4zO4Sa8DRpMdow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762813412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NJ5uN+MNad48N217HhdWLsdsGlsR7kLJF+v92YcO6NQ=;
	b=qi9cuWhO+A56AiukksilwpYxrnVBD2Cj2seLTU3hwhuxPpafhEVBD/H4z+7p20N7GwOqL7
	wrg2YBMk/8EeA1CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762813411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NJ5uN+MNad48N217HhdWLsdsGlsR7kLJF+v92YcO6NQ=;
	b=bWjVmeP9ytI0UUedY1ez/T69YYM2T+HoQ1GEZmHx7WR0J3qxvhmitMo3ZXi2HwALcawWjk
	r98F3O0C81h1VgI6DqjfdyBWHm+W8eBhrGuy8o+W3oc7DDolTDAcWqDJE0WTzLtHSmauoK
	HRoXALhJMBltEAlpzbm/EMTxqMdv0m4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762813411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NJ5uN+MNad48N217HhdWLsdsGlsR7kLJF+v92YcO6NQ=;
	b=W7o3Zv8qQ+gct5OYiuL6bsIKQWsTaXw1drqrInDno1UvbPfq8VvHJPbwukAHk+jpcOQYp1
	LAInfCdEKCZnSrCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35B4F14610;
	Mon, 10 Nov 2025 22:23:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kbzNC+NlEmkYWQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 22:23:31 +0000
Message-ID: <15905893-cd05-479d-8a96-9b9857e0cdc6@suse.cz>
Date: Mon, 10 Nov 2025 23:23:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Memory leak in 6.18
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Tytus Rogalewski <tytanick@gmail.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
 maple-tree@lists.infradead.org, linux-mm@kvack.org
References: <CANfXJztHS4t=w+2Ogq=fHe4WS8CwOJgxog0ZSVf8C=9-4Xx0RA@mail.gmail.com>
 <aRGAUjkKe_H1xc7H@hyeyoo> <aRGDTwbt2EIz2CYn@hyeyoo>
 <025d73b5-8947-43b3-a85e-c112667c030f@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <025d73b5-8947-43b3-a85e-c112667c030f@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0344A40019
X-Rspamd-Server: rspam07
X-Stat-Signature: r4614m1km8p83ksmyypnci7i5y6mbk51
X-Rspam-User: 
X-HE-Tag: 1762813413-912456
X-HE-Meta: U2FsdGVkX18mfb5ENOnpO4r4ZBgA+DlXZtq4XkFasn3kJoq5TMlnDDFtEIJFLyNC5d07qaqQ5u8NC7UPJhaROeqJxclGP8o3hZuxCtGuJx5YzFiuNcgXOCC06/WLe4fQDYoqJ8e6XUEKKGE7CKzjm0WZ7KOrCmfJcz5n1XJYgkglc7Qw9yGCpZ8N5P2+67Fxq+NFSTBuNJVEq9Tb9S7SvfmrPw89oAF8biokxtJQps+wx/F2PMetNpYc0LQeAccYcvIgA4Urf/1wRe3eqSCr3/dmaIfMFQ6ok5x1VxrcSEI1+lxYk7ExhxoUY0aC5LuIJoy1RsPqFrm2ZegZNdL+G94J/VlGG82KW9Ynr2eqlVta46tUBsAqQsZRkmJJ0zUtyIolWJpdiy3+ZxsbuRcQUgugvRgMJ4Fy9wrSKfkIPZY+4ns46xomo2OV7zXAWr6DoPoZwjh4xKFoqdH0nZxy+loPNtKe6lSqFineSZ4O76TqIhsZJ7DnKMQ+QrE09y5vuB+P/hu/aAoI86jEzfkdDD9flAcQWHzxryeiIM114SmCWBu8o2KF/OPemykuySc9sPB41LzCUbZ10rSsxfhudwhiBM6LhKK9ylvDpCEVZR/J9/+hgTL+GcgiiaQlmCGKYHDrHU6biZbBXEKjYc5u6CZxO8TceaeXgCaMGmOGRj71ACvIn0cwUejsaG7GvVdp575nBXjqtAkrZpASsSkr3zr2QMvpLK8Kkw+AY+sxhgHf1qCBW9CQzMkgldp7hAPpo6QijYt/o1VJIM+lV0ch+GgS5yHxVLE/S3hZfTCThgQ1rvvmY6uOv5kPA3yVdiaPAVXhjrqUuzEa4Ly+EyO4TfmER/5k0lBCn6PO4tPvmUgPLWXbbo1F9mre7JatZbrPGXu4nv7XMkUm3o9wf29TL8axEJ+HV5Ot+GMvnr9NPIxMBv7PzML+q0+S5HXZ5hYmD/x6iw1k9auQki6EzSi
 AlPLQ0Dv
 PwFENCzX0yyJjDx+H/8G7m30Pin4oLayGuiVdfrVEdLIfHji+HUtdXu1pxT5HFEKCtQ/2FDEuYLrq8z4clDpVvONHiflWrnTxrmb0Rdg1DJarzqt6njeIVf0gBA4e2eJOAU/Dr1f2jTdJpF3n+LxHvY77VDlq46eP7swH4R+mN12pnq7nrBokbRBYiFfuvs7bTqBe1Eigsc3nDTQg3jV7GDladL3TL6kFqjgaT3QQtuZ96uIPsA3pWmR8uWs/bCkLxMhh2qj7snfFFyHyGPTWYiBkiBUuv1w3gb0Kl1Y+DCsTGCHAhEUuS5pAtq5dZ6gwfOguPkiGeOKHwNa3SIr1wnZuEMFQYewCfVY0EOEqpURKyhKj1I+Uj6Q6yn2jv08lWztLstKAJO55w7a23IsEP68yT4N6wY5Z07sreZdO4IvDJgNFbcZEIIS7IX8IUBNPvM6X+zmzdxMhygM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 17:47, Vlastimil Babka wrote:
> On 11/10/25 07:16, Harry Yoo wrote:
>> On Mon, Nov 10, 2025 at 03:04:02PM +0900, Harry Yoo wrote:
>>> On Sun, Nov 09, 2025 at 11:36:26PM +0100, Tytus Rogalewski wrote:
>>> > Hi guys,
>>> > 
>>> > Been using 6.18 kernel and i have noticed that there is some memory leak.
>>> > Currently mapple_node takes 86GB when server does not do much.
>>> > I do not see that issue on 6.17 kernel at all.
>> 
>> Cc'ing linux-mm@kvack.org properly as I modified the address by mistake.
>> 
>>> Hi Tytus, thanks for the report!
>>> 
>>> Could you please boot your machine with kernel boot
>>> parameter slab_debug=U [1] and run
>>> 
>>> $ cat /sys/kernel/debug/slab/maple_node/alloc_traces
>>> 
>>> and
>>> 
>>> $ cat /sys/kernel/debug/slab/maple_node/free_traces
> 
> Agreed. What could help in addition to above is also enabling
> CONFIG_SLUB_STATS and also providing the output of:
> 
> grep . /sys/kernel/slab/maple_node/*
> 
> Thanks.

Also the output of this please:

numactl -H

>>> ?
>>> > Total 1000 GB memory
>>> > ASRockRack GENOA2D24G-2L
>>> > 2x AMD EPYC 9654 96-Core Processor
>>> > Running Proxmox 9
>>> > 
>>> >  Active / Total Objects (% used)    : 472110239 / 472257124 (100.0%)
>>> >  Active / Total Slabs (% used)      : 7385489 / 7385489 (100.0%)
>>> >  Active / Total Caches (% used)     : 164 / 231 (71.0%)
>>> >  Active / Total Size (% used)       : 95486861.00K / 95528053.72K (100.0%)
>>> >  Minimum / Average / Maximum Object : 0.01K / 0.20K / 8.06K
>>> > 
>>> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>> > 345907216 345897683  99%    0.25K 5404801       64  86476816K maple_node
>>> > 120873408 120841337  99%    0.06K 1888647       64   7554588K dmaengine-unmap-2
>>> > 224256 223324  99%    0.01K    438      512      1752K kmalloc-8
>>> > 224040 224040 100%    0.13K   3734       60     29872K kernfs_node_cache
>>> > 196608 196608 100%    0.01K    384      512      1536K kmalloc-cg-8
>>> > 196160 166455  84%    0.50K   3065       64     98080K kmalloc-512
>>> 
>>> Not sure if this is because of sheaves or maple tree changes.
>>> Let's see what's in the alloc & free traces.
>>> 
>>> Or it would be great if you could build the kernel and perform
>>> git bisection [2] and give us what is the first bad commit.
>>> 
>>> Thanks!
>>> 
>>> [1] https://docs.kernel.org/next/admin-guide/mm/slab.html 
>>> [2] https://git-scm.com/docs/git-bisect
>> 
> 


