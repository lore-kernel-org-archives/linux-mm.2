Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6428E87854
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126516B00A8; Tue,  3 Feb 2026 13:30:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB0B6B00AB; Tue,  3 Feb 2026 13:30:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E963F6B00B2; Tue,  3 Feb 2026 13:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B356B00A8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:30:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71814BA022
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:30:12 +0000 (UTC)
X-FDA: 84403985064.30.5A92224
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id D79A9140014
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:30:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMp0LuU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/jianvj6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1xqZqDho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZGVRnDb4;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770143410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=m0Im05rGtUwKRYauTUOvZn/0OfUsScwkvtRsqlF/8MUhrWdqqAt1R2iHFl0h76nXYSVZAm
	RU6QPCIPPInzekT+dL/S/Yfm8Fgm+qo6g2GB2Jo1WAO8YxcRHOpCc6fPQh7+5FTDYhyDpo
	Zqj0XjeO2pBafiYYCK9bq5LjvpmMkv0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BMp0LuU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/jianvj6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1xqZqDho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZGVRnDb4;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770143410; a=rsa-sha256;
	cv=none;
	b=Mw2xeyONui/4A9saC8B7MWsQ8ZQ/4fI6J8pmL5XCvZTNiU6cJKuJXJSfLu2mHqi6Lr0C4p
	5eP9DwyFPAUsrqjRTm8Ip7F7J0YuUglKjgwMvjGHITSQX57dNkKPIxpWuHsmEhGi18NXDY
	t7ZeL2zNJ6XS+d0/VY8jBA9kqxrCNO0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E41443E6D0;
	Tue,  3 Feb 2026 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770143408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=BMp0LuU6c7tESb/HwI8YWgpAgaqRM5VBaoTI6PpyN0hEz5nmO+0wBRFXL0LFTD4wf+qHav
	HFVzs0iDbjc/XPiPXKkTO1zWZClkqF2sH5FvInXKlmhvsGEjJQ8RuPD3QhRmVT1UYA7Tni
	Rd2jPvgI+blpt3ZXaDKFfCi17HJ2OMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770143408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=/jianvj6eZ6jroFLLEXpskoB0on5wdunnaNV675eJ7wsLUsBcK3tmtWPpjizl0wWmLefyw
	IPfUQFEQGp2DWyCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770143407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=1xqZqDhoroY+aWb+YP4sj8N2OVG7zUUNNQjcEDfMDroz2db8qqPhEd5RTMpB8ZzmWPsW8i
	yykjFFC9sRAtSIQzcwXcoc1g5j/hZbe5I2culWruG7Xc3pbo6OiF/2hlDg4pVI8tNvjiPv
	z/AJqvkwcLdwEd+i9yUq8ZGd5+PD5KQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770143407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=ZGVRnDb4u8RrkKi2WfehmiHmUmk2lo4RNtEV2jf0cLif9mz7nx3rFYHFNCcIAP0Si240n4
	Rx6uIlrZPg6ZeiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6EF73EA62;
	Tue,  3 Feb 2026 18:30:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IGVOLK8+gmkiJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 03 Feb 2026 18:30:07 +0000
Message-ID: <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
Date: Tue, 3 Feb 2026 19:30:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vernon Yang <vernon2gm@gmail.com>,
 =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
 syzkaller@googlegroups.com, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 linux-fscrypt@vger.kernel.org
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo> <aYIh1wPm7BrId9dk@infradead.org>
 <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
 <aYIpVq-jTKyTQE8G@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYIpVq-jTKyTQE8G@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D79A9140014
X-Stat-Signature: 1deoof9nojqkumo76c7mhbt1trx5a8qm
X-Rspam-User: 
X-HE-Tag: 1770143409-422912
X-HE-Meta: U2FsdGVkX1/+t95h4o97bqoLvMMXqAoy/smA60xAu0G9ocKI95GffwFMUaLxVbyN4/hgiRELaALXg+3HJ4ZXv/uPufsQjNPlV9odZFxQpfY5A1HvTBRUa6YQIb5aGUfCWQizUl5owMHh6DbbVYrZltJtLTtoRo3w3uuSeiJmJGkSmsjT3oW1Oe+xbLw2k9f2YSDr301x0zDWwNv8CLGb5OaV/YhG5bMMFwyP6q9kV4fICU+iu1oD+XcFCOUbJ/xhwCGMKQ3mh1vLK71FtAIzteF9vAcy0jsp4LRdwXbStlIWC6uaGeRKLaEAozi4yS159MjwF1pqlhFc0IfrC7RwYpmqJSMxeJhSB9jEElAKUgn56PMznHra0PVdZIoohJFOwcicacvcsEBCpr8gWpFiVhvzdTekvuulm9t9Ekxjf3c/HN0SKCB920m6M4liptO+czbt1OYcUyN8hxWXcbG1q3PqH8qvM6yKOS880CptTfxsJUYSYP5fAJnhrqkqtRM5M5k+Con45a654Sv3lFTa2g0kd788JawrJwSC35tHu4LZMz9mJWwQpZBrNNCK2USc117QPbFzSfJ8pheug85jzwgCsbjZRA/RIYjUR2Zt0oAqOQebFJF4ZbIk7Bt8gmfVjuZp9u29dXww6z5jZvbJ1MQ0slVmHFyYdjC16FxQp/4zL9TZrmdIcD3cp/+5qWH1c8l4l/TnwSxKejtEAejEFAf/y7y0ErlenETY2/5MXbidzCKSkZCtS1e1mlQuurw6Vz69sQlX4riCBLNg2WCOg7kzPTv3nJra6SKQyD8qj/b7v1Xmvg+3iM+J5FTAYBp4WE0f9PkSMoVB/wE71IQk8flR4Hdbf/TAgRTcL7B4xum97yvu39NofEiquPaXberfneTm3ac9MZoQYlcayu0IXGNQlJdzy5EApCMOV8C89qImNWZOklFzD1VGleAPj7SpQDmOalJcFFidQBJDmZe
 SNQJIMnu
 6G4uWjSE3a3OPfeZV7IcQEULueUoZuyLrqCuVrJM2GQuUOyVdMKq3XbbDX/S05zlqac/U5r2YsNs6Ye6MlzYIagmIk7XqbIKBHsDakfXBxA73bGcQCMTxXWmszgdrcgqk4YCOMG4ytWs6s5go2qVC/1xYpI0eq/4cuGdYz6ZnQm2UtPSCYri1GKYpuojP19x3Nz7V9hdvc7GbY11I/H8a3h7T/TrEIr+wMLq7mtemWZquJZ9Lp1qzetVyT6k6es06YpbMYAUgs73cgCbylZD7soQRs0Ub4la8p2sFFLW+ZYNvtrxm/6ldgl6jlLrwOq6y65aEuebrJa+Wlkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 17:59, Christoph Hellwig wrote:
> On Tue, Feb 03, 2026 at 05:55:27PM +0100, Vlastimil Babka wrote:
>> On 2/3/26 17:27, Christoph Hellwig wrote:
>> > On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
>> >> Maybe the changelog could be rephrased a bit,
>> >> but overall LGTM, thanks!
>> > 
>> > 
>> > No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
>> > the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.
>> 
>> So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
>> just redundant.
> 
> Given how picky the rest of the mm is about __GFP_NOFAIL, silently
> accepting it where it has no (or a weird and unexpected) effect
> seems like a disservice to the users.

OK then. But I don't think we need to add checks to the mempool hot paths.
If somebody uses __GFP_NOFAIL, eventually it will trickle to the existing
warning that triggered here. If it's using slab then eventually that will
reach the page allocator too. Maybe not with some custom alloc functions,
but meh.

This f2fs_encrypt_one_page() case is weird though (and the relevant parts
seem to be identical in current mainline).
It uses GFP_NOFS, so __GFP_RECLAIM is there. It only adds __GFP_NOFAIL in
case fscrypt_encrypt_pagecache_blocks() already failed with -ENOMEM.

That means fscrypt_alloc_bounce_page() returns NULL, which is either the
WARN_ON_ONCE(!fscrypt_bounce_page_pool) case (but the report doesn't include
such a warning), or mempool_alloc() failed - but that shouldn't happen with
GFP_NOFS?

(Also the !fscrypt_bounce_page_pool is therefore an infinite retry loop,
isn't it? Which would be truly a bug, unless I'm missing something.)

Ah but fscrypt_encrypt_pagecache_blocks() can also return -ENOMEM due to
fscrypt_crypt_data_unit() returning it.

And there theoretically in v6.12.11 skcipher_request_alloc() could return
-ENOMEM. In practice I assume this report was achieved by fault injection.
But that possibility is gone with mainline commit 52e7e0d88933 ("fscrypt:
Switch to sync_skcipher and on-stack requests") anyway.

I think the whole "goto retry_encrypt;" loop in f2fs_encrypt_one_page()
should just be removed.



