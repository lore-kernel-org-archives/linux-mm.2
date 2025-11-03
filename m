Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA55CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A833D8E0048; Mon,  3 Nov 2025 04:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59A88E002A; Mon,  3 Nov 2025 04:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A738E0048; Mon,  3 Nov 2025 04:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 810A38E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:01:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 148AE5C45D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:01:59 +0000 (UTC)
X-FDA: 84068703558.11.25D57D1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 858E4C000B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:01:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXAepFFP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MNs1AY1O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXAepFFP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MNs1AY1O;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762160517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x77GvNBfhiPfDJ7+aga7zLx5chZtfUCV8AbA2dIzY/k=;
	b=v2Dg6ax7Bf+ggIKymlAccyjQF85LZXyMahm0r2iBU0tJOJalo03QlzFpc282UNVBeAor4j
	cRiqwlQqXDdf8xtkUXe2rEAA+AfapgJ/dUMF0Y3LRikiea0Dj9EpMdrv9JljDOvcr0gQk8
	z+gdrryGLLRssiF1c0ToKzLWUMqOj9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762160517; a=rsa-sha256;
	cv=none;
	b=hv0dKT/GBHxmlK8t7AggQtEMjUQI3Kw5G97a7+LuYnfiNyrS5O4OjrbTZzg6vi0ziKCGyc
	/z3N3xAYCCHGj4B6Y+cXjsumH7obEkZQNEWsg2irCX/O+p7UJJAdecGeURXm7aceyc1j3P
	kIBfljphEZ/ahUHHB3qFNMq4beAa8Is=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXAepFFP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MNs1AY1O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXAepFFP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MNs1AY1O;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF1C91F7A5;
	Mon,  3 Nov 2025 09:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762160514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x77GvNBfhiPfDJ7+aga7zLx5chZtfUCV8AbA2dIzY/k=;
	b=cXAepFFPjiVhLtUDYa9bvLbB9u3FI3ZX7Q7LMSLvBPg6C4HuEoTUEWEJ1w+1WuxQD3nUfj
	XZ2i15huHb09z+3+jJ7+uiJWh2fLy0FaoSLzxWZyLFvO3jSK2o2PTcgWR8lzrtfZhox0Hg
	6xj7cPYHCym6BTvr/gpmTc8LiP87RH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762160514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x77GvNBfhiPfDJ7+aga7zLx5chZtfUCV8AbA2dIzY/k=;
	b=MNs1AY1OFRwzYq3gFQZzxzP77RoyCOg+nyqYuXe953PP81VVkjdDiE/qGWXG7hVF3Ng6bQ
	fMc06LfpotUKXjAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762160514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x77GvNBfhiPfDJ7+aga7zLx5chZtfUCV8AbA2dIzY/k=;
	b=cXAepFFPjiVhLtUDYa9bvLbB9u3FI3ZX7Q7LMSLvBPg6C4HuEoTUEWEJ1w+1WuxQD3nUfj
	XZ2i15huHb09z+3+jJ7+uiJWh2fLy0FaoSLzxWZyLFvO3jSK2o2PTcgWR8lzrtfZhox0Hg
	6xj7cPYHCym6BTvr/gpmTc8LiP87RH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762160514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x77GvNBfhiPfDJ7+aga7zLx5chZtfUCV8AbA2dIzY/k=;
	b=MNs1AY1OFRwzYq3gFQZzxzP77RoyCOg+nyqYuXe953PP81VVkjdDiE/qGWXG7hVF3Ng6bQ
	fMc06LfpotUKXjAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3F75139A9;
	Mon,  3 Nov 2025 09:01:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id akSXK4JvCGnHEwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 03 Nov 2025 09:01:54 +0000
Message-ID: <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
Date: Mon, 3 Nov 2025 10:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
To: Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
 yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka> <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org> <aQhf5LJJMlvT-rrE@tiehlicka>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aQhf5LJJMlvT-rrE@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 858E4C000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 8fsrkmsapdgtih5i4rqm4u7z66ezx93q
X-HE-Tag: 1762160516-26740
X-HE-Meta: U2FsdGVkX18evg9p9oBeR2Z5N9h5u70af9rUB4cHlxi2uuzdggd52cjnU6XSF1uWU6/16aiB57wjyvXqIsz+DXqtzwk072fU8r5QUVXesX+4cZB9AXWS+sORyt4XELkxfS37IpsroOB1IX9TrNRFLp5X+BwFxGdiFrzV8T5vw9n19Lywop9LtGrND4/WUiGLeUwCDu1xddq2cM0wR26+d9QXKFjIDo7YhTjC5QQlcVKhH71XNrsrVnEo4cb1uoJjgg5UdnnhVzzVnozJEAWn7uNeAYD97+v0zy5E6s7hgrxdo179OMhecWz74heLf7PMzJEDr/TjZhAZ5UIO8cRyfxUdav/1RTeA5q1t6kDiVMb/g5yDJ1duyZk7HUgYaK2fQa9bzC2hmWKWAuG4LnsqiV/UDlLPDPtPezAZmAYzqCuuh76N5XMY3jzjOtaa2HVNY5XbA2Up0No99Y/tl3zlOu5oB+Tg65aM5i0IrtAUVVjhFswqa2+qoFtvaSauxlPG6XPme7ISd2hd98ztjHpOO1I6ezX+Lg11N8l8NYrgMdlU1vRuUk7cn0Y2SiOGl2GyboEp09a66nj2CZsvIPvE0QjSIXS3CGRHcbE08L54axHb9sjZDrensDQ4W2/LGwS3qLe3WGgCWKPaR3WlE3vGCU3e25+VaK3vGT0Y4NowNs2qiTX8hEQlDWlaxnr0B+gtqqh63sp5b1X3JX/3i+VfV9xuffB0vm5epTEt5c/JR64T4SxqCEAV7GNMX1I1JX65a9SSMG0LjH/UUVhR+CWiAc2I8FZ1u1OkQd/C4xdRu85Ip4++kp5koNkiXWzJVSmxpRCGwPuC9SGCGZpOWTW6TkJWwk92nrkZ3yhN+hW+Wi64WIzp47b14uIQHM7qAHVi2vzc+8UGVJ6skpNTbjNaLB+Id4Ka/fNpiErVjoV+aQLwq+yjBEpQOqfdf19IWurV/KXDksB3cV9bE9Ho1TP
 R8Rn7ebd
 MxAibBwEpL803i/SGKNWVn3ys7xz5tntzk77H2lodSy4qyX+gDEvSuc/TsdV1kNvJPg3V1f/evj+HIwI0xl59LZe+DVXf3u5R35uBsB1vdYlE/SW5NhSKS8zKHJY5NJ86JtaHZymRGWkidR+GgmabJ0Ri4lGd0A2Oi5OuYQ6Bfj0Hjg7asRQ3CyUn58VHa2KMIoy4WLp8eom1Oynxz0CbS6FrZY6FRGkjpc02Y2hdWKflFo6mBo729hv/CjjEz5eUMYR/arw2dytdX841g+tOovu2PcojZBzVwkM74xjkgwfw+oBLGzTxchtDr23sf2FwVpGRzfJh8MKEQ6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 08:55, Michal Hocko wrote:
> On Fri 31-10-25 16:55:44, Matthew Wilcox wrote:
>> On Fri, Oct 31, 2025 at 09:46:17AM -0700, Shakeel Butt wrote:
>> > Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
>> > (FS specific) gfp is fine but will require some maintenance to avoid
>> > abuse.
>> 
>> I don't think a new GFP flag is the answer.  GFP_TRUST_ME_BRO just
>> doesn't feel right.
> 
> Yeah, as usual a new gfp flag seems convenient except history has taught 
> us this rarely works.
> 
>> > I am more interested in how to codify "you can reclaim one I've already
>> > allocated". I have a different scenario where network stack keep
>> > stealing memory from direct reclaimers and keeping them in reclaim for
>> > long time. If we have some mechanism to allow reclaimers to get the
>> > memory they have reclaimed (at least for some cases), I think that can
>> > be used in both cases.
>> 
>> The only thing that comes to mind is putting pages freed by reclaim on
>> a list in task_struct instead of sending them back to the allocator.
>> Then the task can allocate from there and free up anything else it's
>> reclaimed at some later point.  I don't think this is a good idea,
>> but it's the only idea that comes to mind.
> 
> I have played with that idea years ago. Mostly to deal with direct
> reclaim unfairness when some reclaimers were doing a lot of work on
> behalf of everybody else. IIRC I have hit into different problems, like
> reclaim throttling and over-reclaim.

Btw, meanwhile we got this implemented in compaction, see
compaction_capture(). As the hook is in __free_one_page() it should now be
straightforward to arm it also for direct reclaim of e.g. __GFP_NOFAIL
costly order allocations. It probably wouldn't make sense for non-costly
orders because they are freed to the pcplists and we wouldn't want to make
those more expensive by adding the hook there too.

It's likely the hook in compaction already helps such allocations. But if
you expect the order-4 pages reclaim to be common thanks to the large
blocks, it could maybe help if capture was done in reclaim too.

> Anyway, page allocator does respect GFP_NOFAIL even for high order
> requests. The oom killer will be disabled for order-4 but as these will
> likely be GFP_NOFS anyway then the order doesn't make much of a
> difference. So these requests could really take long time to succeed but
> I guess this will be generally understood. As the vmalloc fallback
> doesn't seem to be a feasible option short (maybe even mid) term then
> this is the only choice we have other than failing allocations and
> seeing a lot of fs failures.
> 
> That being said I would much rather go and drop the order warning than
> trying to invent some fine tuning based on usecase. We might need to

Agreed. Note it would also solve the warnings we saw syzbot etc trigger via
slab by allocating a <8k object with __GFP_NOFAIL. This would normally only
pass the __GFP_NOFAIL only to the fallback minimum size (order-1) slab
allocation and thus be fine, but can result in order>1 allocation if you
enable KASAN or other debugging option that bumps the <8k object size to >8k
space needed with the debug metadata.

Maybe we could keep the warning for >=PMD_ORDER as that would still mean
someone made an error?

> invent some OOM protection for order-3 nofail requests as OOM killer
> could just make too much harm killing tasks without much of chance to
> defragment memory. Let's deal with that once we see that happening.


