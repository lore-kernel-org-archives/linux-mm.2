Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9561CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD6E8E0003; Wed,  1 Oct 2025 06:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B47F8E0002; Wed,  1 Oct 2025 06:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA348E0003; Wed,  1 Oct 2025 06:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7E38E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:56:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE335BC688
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:56:14 +0000 (UTC)
X-FDA: 83949241068.13.6F0A768
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F28EA000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:56:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oasM6Diy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pZNUj2vW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oasM6Diy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pZNUj2vW;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759316171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpePL461P7LsNb38EA5EBCrLN87PvsNeyDTc8FDW4ww=;
	b=a0jEjkYaBzzhelwxK+4wkzd3BWUo5o0pn4mneELe5uXc7FcIl9C7Ix0S6kiCjVyNMA8ubC
	RCgCy2Umk9FIiO7fJwV+OLb2lBo9rSX6MfPMG4q22q4m4W1UaztZ2z6uh0rdReuv2oe0At
	0IqM9o6liTFomAAguxD8YbSktVgqyTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759316171; a=rsa-sha256;
	cv=none;
	b=tnob6io4cZnenznOXeaw0wUY+OGMQ2dHJG6HCjYUqRyx63bFosKxB2zIfbJ8s3wb0b5bLo
	TgDEMt6XBGeiH7CWCWNdYZ2o+4AcyVFGQsCAcMZac8XT5OEJ8kfa397STEFe7jQiE9hdcV
	PBge5Jg7SDzGE//LTG5yvIrec2STYQg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oasM6Diy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pZNUj2vW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oasM6Diy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pZNUj2vW;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0AC922ACA;
	Wed,  1 Oct 2025 10:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759316169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpePL461P7LsNb38EA5EBCrLN87PvsNeyDTc8FDW4ww=;
	b=oasM6DiyM2kyMCNTGIAYlVkqmuNLZi8GAubQecgC+xqhk20yQDljW8iTL9YJmLPw1O5OFW
	z8pBByI1Z/DIrd9ncqSoxwme6OV4WBmIgVTl7F7AP+DSK6y2B/edVMEVU622UH7oq5awIt
	fyWkwEDG/TxDXiK8ToWQ3gNCaXhEjks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759316169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpePL461P7LsNb38EA5EBCrLN87PvsNeyDTc8FDW4ww=;
	b=pZNUj2vWzGza9ZshzzOh9mzR2No65ac/H9H9BRuOMF5WGnimvNxVZNMaGiBeOS2fsIe5HL
	OdWIUP3n5cPmGOCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759316169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpePL461P7LsNb38EA5EBCrLN87PvsNeyDTc8FDW4ww=;
	b=oasM6DiyM2kyMCNTGIAYlVkqmuNLZi8GAubQecgC+xqhk20yQDljW8iTL9YJmLPw1O5OFW
	z8pBByI1Z/DIrd9ncqSoxwme6OV4WBmIgVTl7F7AP+DSK6y2B/edVMEVU622UH7oq5awIt
	fyWkwEDG/TxDXiK8ToWQ3gNCaXhEjks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759316169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpePL461P7LsNb38EA5EBCrLN87PvsNeyDTc8FDW4ww=;
	b=pZNUj2vWzGza9ZshzzOh9mzR2No65ac/H9H9BRuOMF5WGnimvNxVZNMaGiBeOS2fsIe5HL
	OdWIUP3n5cPmGOCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9A6713A42;
	Wed,  1 Oct 2025 10:56:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l3XrLMkI3WgGYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 10:56:09 +0000
Message-ID: <602271e2-86c9-4a63-845a-b84407d3aa51@suse.cz>
Date: Wed, 1 Oct 2025 12:58:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
To: Michal Hocko <mhocko@suse.com>,
 Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka> <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
 <aNY49sdoFVe03m_Y@tiehlicka> <d9af42d5cb9d427632087c5f51e50501@igalia.com>
 <aNvjDsBuw3hqwy31@tiehlicka>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aNvjDsBuw3hqwy31@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: fyci1ckysumrpdkx1yzkxkmx5kmy7fyz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F28EA000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759316171-729055
X-HE-Meta: U2FsdGVkX1/2RzXwMETOtAK/GhZ9gku1/56PQgc9thkI38HlcZwMwQOMIKAVkD7VAl7eWCcRZinceXB4tVeafgyUYMuENwBOSnRH7/y2xEJPlaF50WmXoAA1T7wtA4rqE3aEp/fLAEetJ6Fj9Tr1RGwyZr4lm1GkkivDMbCICwZsDFaf2bRZbe2uAmV8Pme+uVNGyS4dA5f2b5fctGrkYDxXPVZMjQuvsdlQCvkGO9WOvzQF/4Ih41LkG8I8KYSKSNjzI1v691JXR8/Ig9heeZSHBjC7Uibn3/TNA9vcSnsR03/wTY51Sx1aXyPTjnx518jaL6PPxBru4ftWXtCbJX5xT4Y1s1kqift91p0YLJUP4Pxgfe3QVkj6I7CrQDBm5Ry5jjyzdmrf8qMJ37VCRS6lCVbN9MJzBuWifH4dFMeZ0Y2aM0qWHu1TwSMgihewPwGIm10CClLbmvvOPwh3NbBFFghUyPF55PBjA3NJq63abUfzEUfvmnuyPrH7SMmD0MOM3OE0EvGegDnzihFVBP80fW1nX6pYdm+W0jeuMBlU8WZnNtmUaxZywpVhTazYhfimWFHG+0SVbPb0xUGBMzo8+sEivEeioYTsagMWee+J0j+p7CZuuu2/OTcoXispqyCPIWXg384zNBa116sGoLeasIwINnjQSUjeZvpakW0pPlwWHa5ABPgFTyJgigwfFHZaj5byIKMvJxKN57VVaO7ur2vBKgmEQVML+1HpQ+Vj26d5Ts5YKlVEq2dDdMHZwatEIm0qDAHz6+Dcaj8AmOtUhUHs0OPyAQCfCuamAayQpdsZmoqeMFQviRMpN/7Irn6OfFR0c+lmoJxvT4eModK3vQao2rQoDU/snYAxx9XLzeNgf0ZAzIO08SYEN90bje0Xwk7kDx3Fa9FJWwsCpn/UcIyHb6bAVhrhAtxwGRVUTg+Z9hZy/k8Gb280mUf8b8amXt/JJyBHa6N1Pdo
 DPgr5Gyo
 pyJ9Lhhl/IU6GjLGybG1DsbkgUwq+fs+1pzBUaqoo0SKopdbASvli9uealXda62B7n4axxk8+XEZzhV9tg5RHVHBAmCPgr+q7CApt8RdMz1ph+F/i6lajRLEr5OSML1gAN0hnRlcRVwMq6+56mfvhlQyZX3cVWJtWtibdM/TbjA8FvKlqqPqIf07uVtzJSladW6K1a8PvCX6Z/0yFTSGplOgQ77fT3M0/arZYnsP4w2xKg6vjBqGgsYdTYeODjaFdi7kkydhGGqcnRuhW6a7ovGCvnL5yiEl1V29+8WgRegMkZs14DuUH+Fg1rcdwIJA0PlM5Vvgk5wzFpP4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 4:02 PM, Michal Hocko wrote:
> On Fri 26-09-25 13:47:15, Mauricio Faria de Oliveira wrote:
>>> My main question is whether this should squashed into the existing file
>>> with a rather strange semantic of controling the file content depending
>>> on a different file content. Instead, would it make more sense to add
>>> two more files, one to display your requested key:value data and another
>>> to resolve key -> stack trace?
>>
>> I see your point. Either way works for me, honestly.
>> Let me justify the current way, but it's certainly OK to change it, if
>> that is preferred.
>>
>> The use of option files has precedents in page_owner itself
>> (count_threshould) and ftrace (/sys/kernel/debug/trace/options/*).
>>
>> The use of output files needs more code/complexity for a similar result,
>> AFAICT (I actually started it this way, but changed it to minimize
>> changes). 
>> The reason is debugfs_create_bool() is more specialized/simpler to
>> handle than debugfs_create_file().
>>
>> It ends up with a similar pattern in a common "__stack_print()" to avoid
>> duplicate code (conditions on parameters to configure the output), and
>> it adds:
>> - 2 ops structs per file (file_operations and seq_operations, as in
>> 'show_stacks'), for plumbing different behaviors down to different
>> functions, to call the common function with different parameters.
>> - It should be possible to reduce it with private fields (from
>> debugfs_create_file(data) to seq_file.private), however, since
>> seq_file.private is used (iterator in stack_start|next()), this needs
>> more code: a new struct for the private field (to store the current
>> iterator and add the new parameters).
>>
>> So, I went for the (IMHO) simpler and smaller implementation with option
>> files instead of output files.
>>
>> Please let me know which way is preferred, and I'll send v2 with that
>> (in addition to the changelog suggestions).
> 
> Sure, I see. The main problem with the option file is that it is
> inherently suited for a single consumer which is a hard assumption to
> make at this stage. So I think it is worth having a separate 2 files
> which provide the missing functionality.

Agreed, we should prioritize a better userspace API over having simpler
kernel implementation.

Will count_threshold apply the same to the new file that prints only
handles? I guess it will?

Also the handles to stack translation file could perhaps support
"seeking" to a specific handle if you're interested in only a few
handles. Perhaps not necessary though if you plan to read it all just once.

> Thanks!


