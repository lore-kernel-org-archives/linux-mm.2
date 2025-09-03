Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51605CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C7F8E0007; Wed,  3 Sep 2025 06:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C2D8E0001; Wed,  3 Sep 2025 06:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4568E0007; Wed,  3 Sep 2025 06:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A56B8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:12:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4FF21DE128
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:12:28 +0000 (UTC)
X-FDA: 83847524376.18.7AF1913
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 79F0F4000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:12:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ka8DlS8J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IFyZVI5p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TSk2r2yf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6QCIR5q4;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JX2P414we82oQn/fjI5R8Qh1x2tILT3GyyIhOHEW2yQ=;
	b=J4vMte7H1isZKLHRAxT4nCUNYP8Sin6vJXlX/tK63LApR+/1ISgDuezjcAmDxvKgjBiWo2
	GJP7ams6Ng6Gv7MnWvf4zIo2T1zCvuY5t00uMqpXGKp2p9MGnJc7wcJmz3g7PatImBfx/B
	eZf5bp2yCHs8TBO3r3bP1S4smQ1piSk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ka8DlS8J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IFyZVI5p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TSk2r2yf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6QCIR5q4;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894346; a=rsa-sha256;
	cv=none;
	b=dl/2WoEhCf0HZ2o/r2vnmnBcvgZ4WgQWz5Iv//KHqApdinPC1lMOuh9roiidhn0HIpKwYg
	/UlQVvmldxnR2AoZr/dyYN6cHOadLf/l7hDwB6RpCrnHoxKhClUEiuemYyvuUNTD5CFo1H
	Bg1Mo5KzxKg6pu/hGIoiLi6wQJ5hAPs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF6C31F745;
	Wed,  3 Sep 2025 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756894345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JX2P414we82oQn/fjI5R8Qh1x2tILT3GyyIhOHEW2yQ=;
	b=Ka8DlS8J2iPhlxAyx45NPpVpQ4fI6CQAwzYiObY8zfH2s7bzh+I3tnvedfzh61Zv2snPq6
	CXy9q8oPCey8gOjS5c0JJpt+va02kHKjTBkVC3QMZjAJsXCbWPeMSWIQd694t620IiYyBs
	xSJ/p+FJYEsLPCUoQlexBlOpncnOBhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756894345;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JX2P414we82oQn/fjI5R8Qh1x2tILT3GyyIhOHEW2yQ=;
	b=IFyZVI5pSZnAun+of2BkxaL1iZ0EaCDy7s7xEg5gUS0HIv3/tNnq2YJPm60ljOrnMJywFG
	Fo84HHIjbsJ2y2Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756894344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JX2P414we82oQn/fjI5R8Qh1x2tILT3GyyIhOHEW2yQ=;
	b=TSk2r2yf2nSQC7psvlaWPLjN8MSRQA86aaX1iPIH6qws0jz8urAjQw2QEmiHEwJnc+N0j3
	Nke0KyQMnhhIG5gXcZ6JPReGjOPMiR5b5xQh0TjdSq6GBKXl61TBywyCU1BH96fKvlZ7zN
	qEL3ekZ+LvdYL6qBc00fEDZ6VbdIUBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756894344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JX2P414we82oQn/fjI5R8Qh1x2tILT3GyyIhOHEW2yQ=;
	b=6QCIR5q47hG9OxuUw1nTe+Jbk13Pw7hTwC+HRE8yGfu0GGwaiwS40gO28ncd3UZ+AnlXvE
	C8ue/6RxqF8MZMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B69A913A31;
	Wed,  3 Sep 2025 10:12:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1o9BLIgUuGjcfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 10:12:24 +0000
Message-ID: <1e153ab8-57c3-466c-b56d-2c3967aee038@suse.cz>
Date: Wed, 3 Sep 2025 12:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756827906.git.pyyjason@gmail.com>
 <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
 <ef1b79ab-15cb-4720-ab05-d77617143a26@suse.cz>
 <aLgLoal9q7Zx7Yto@devbig569.cln6.facebook.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aLgLoal9q7Zx7Yto@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79F0F4000B
X-Stat-Signature: mquprscj8948bcc6q6d1g6z3k1arny54
X-Rspam-User: 
X-HE-Tag: 1756894346-687755
X-HE-Meta: U2FsdGVkX19jUtK5YWSgRu+YHn1tG1HdFtRyO8wNEbCmcbAvI0MZ3Y+FA85UisHY4vV01RoUo1oQuOLCjRRdPLj9TNwHc3AKtjgpEppkf1jke0RBlCainKjcvwGx6y2c9f/uYk3w5Vz22jkxA/+ONJtsTYS7+kP23QwSM2FVElCNGw/LIYC5Z+NxtKdfQDN2DmEN6gMi4IJZFXDpaAk4g0Xo5mWW60UGGPTECrIkfaBNgEXr114cN1ziuJmNzJVQNxXIM/c8mEYZfdAV3E4HOGeCRIuLLc4YQC6kL3X7FAukFM8byJxQ3TFibgSCeszH+ZanUQ36EM0jNLmyTXTkp/nh1On+51jGi6dYdEjpQo6N6E06EcTzuXt9kDZXlegNMsvHiLfP1uSL9oclbkqCTMfFMEXiV7sLlpl/iwfUnj4S6ETk0PKGIWOsPMIyfD/s9fDC8dEXI3m384jvlbxnORdxgHvmM9XephjWhE4wLKPcSrUE4AkwMEtDVloOLDkChg6ksonfQ9+KdBzaib/RH7OKFBCLb+wzevbSr3TD+Z5W2nPt4Uk0MWdbbWNcJA4izH+HMkeHbNirL4ATc+rRbUPI1MhMJqmJ7XtqSSYYIlTmRH8NbO0Zt/pwLACVv7yXjwzV6m5tryWHjaPLjbDfGCHMTynd3BOsKMNeXj82QlYIGZrY8KoQ59OedHu0PMWZzbY+CUpLaOScQJ1HvSnxKo+ZMWXmHx5G8KNTIrsJpyzNJXLkvAuDeivFh7fcn1MMVtXmf3T22y/Ny2Ry3xdiC4pERL8g8RmJ0OaBkyd23w1+Mm2iMMf+phoFNl8HOOX1tacJfJyLNNqBi6R7rYv13wvg5RoAkNqGy0EwsIeYZ6av7fJpXtVqhSlP6ZCnWibZAByqDdErbnEaslT14H9ntX5p6qpAl0kD+tOgWMvum6wF5JnliJN+h//R3Q4DmjUgg5M11kXXMeJ2Sk9j8m9
 cOGzt5ng
 l3FqeNMxkgxEvyjWjOeD77fUmSxxgmBahlWIN3XoHOPYweJQZP23O5/QSv5/cHjGN+kVxz9ONviDK9wN4iIewRTEo9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 11:34, Yueyang Pan wrote:
> On Wed, Sep 03, 2025 at 11:26:01AM +0200, Vlastimil Babka wrote:
>> On 9/2/25 17:57, Yueyang Pan wrote:
>> > This patch prints the status of the memory allocation profiling
>> > before __show_mem actually prints the detailed allocation info.
>> > This way will let us know the `0B` we saw in allocation info is
>> > because the profiling is disabled or the allocation is actually
>> > 0B.
>> > 
>> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
>> > ---
>> >  mm/show_mem.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> > 
>> > diff --git a/mm/show_mem.c b/mm/show_mem.c
>> > index ecf20a93ea54..51892ce2efc4 100644
>> > --- a/mm/show_mem.c
>> > +++ b/mm/show_mem.c
>> > @@ -427,6 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>> >  
>> >  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>> >  		if (nr) {
>> > +			pr_notice("Memory alloction profiling is turned %s\n",
>> 
>> There's a typo "alloction".
> 
> Nice catch. Thanks!
> 
>> 
>> > +				mem_alloc_profiling_enabled() ? "on" : "off");
>> >  			pr_notice("Memory allocations:\n");
>> 
>> But I think the message would be more obvious if it said e.g.:
>> 
>> "Memory allocations (profiling is currently [on/off]):"
> 
> I can change it in the next version. I saw Andrew gave approval. In this case, shall 
> I send v3 or create a new patch?

You can send v3 (given patch 2/2 needs warning fix too) and Andrew can
replace or convert to fixups.

>> 
>> >  			for (i = 0; i < nr; i++) {
>> >  				struct codetag *ct = tags[i].ct;
>> 
> 
> Thanks
> Pan


