Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2B4D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8896B03AB; Tue, 20 Jan 2026 05:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75E56B03AC; Tue, 20 Jan 2026 05:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74C86B03AD; Tue, 20 Jan 2026 05:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B51976B03AB
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:16:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 746E18BA5F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:16:19 +0000 (UTC)
X-FDA: 84351937278.13.B6C2F01
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFFD580004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:16:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=imCXFMlb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R5nUwaFv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=imCXFMlb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R5nUwaFv;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768904177; a=rsa-sha256;
	cv=none;
	b=OpYYv1zhu3kBFsJaLdgV5sV2/emDju4bEFBLoMH2wMNvc2o9CFCZl6mKpIdiZeCTf/5MBD
	JXptSZyErlGEEl29JQI9NQS3ABOTvq8Z+9cnrSUVu1VYKp8oeotLTFx6hJ0EYElKyQLHAL
	cTHPQd2JcxIaDlAtlNF2K51IMQ+nRHQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=imCXFMlb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R5nUwaFv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=imCXFMlb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R5nUwaFv;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768904177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij9HMZHBxG4L87Hf9Nb+LHWEtPk4EOpyvqCky6BrClo=;
	b=cbCXIoSyrZoxhODxNCPrQDFeRQFTXjDdqxEwL1WwQvziJbvxlbcVFsuDn/Mf/UyiRN4Na2
	uNw1qxn9DVYZh6ca00MyIR8v0vzXt95or3L6W7IDZqACCMWu4FKDS+dvftprltFqd3eb7K
	lUpPTWSh6F8R+2y3T9nZA8SpX0xmJVI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FC705BCCD;
	Tue, 20 Jan 2026 10:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768904175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ij9HMZHBxG4L87Hf9Nb+LHWEtPk4EOpyvqCky6BrClo=;
	b=imCXFMlbaAwn54xfRRIN+op2TGXksW/YbDt40MUzG5X022woIoH4PAAn/sZbrO8qCVCb3/
	rlxEYUYmK4PqYWm/hxQvoz90fxXUQJQenFM3xpoc6By+IeBUR0oDcCH3Xf0u12FFKDSzP0
	IpQ3NMa7yajly0FE6PM9WUKW99V/vl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768904175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ij9HMZHBxG4L87Hf9Nb+LHWEtPk4EOpyvqCky6BrClo=;
	b=R5nUwaFvZi5bswFuaMntab5R+cl2qagoHnvAHTV/72SYThrCOacH7MHbTDFscuPP59Fc/5
	M1pVH52XciXBNAAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768904175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ij9HMZHBxG4L87Hf9Nb+LHWEtPk4EOpyvqCky6BrClo=;
	b=imCXFMlbaAwn54xfRRIN+op2TGXksW/YbDt40MUzG5X022woIoH4PAAn/sZbrO8qCVCb3/
	rlxEYUYmK4PqYWm/hxQvoz90fxXUQJQenFM3xpoc6By+IeBUR0oDcCH3Xf0u12FFKDSzP0
	IpQ3NMa7yajly0FE6PM9WUKW99V/vl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768904175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ij9HMZHBxG4L87Hf9Nb+LHWEtPk4EOpyvqCky6BrClo=;
	b=R5nUwaFvZi5bswFuaMntab5R+cl2qagoHnvAHTV/72SYThrCOacH7MHbTDFscuPP59Fc/5
	M1pVH52XciXBNAAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33B4A3EA63;
	Tue, 20 Jan 2026 10:16:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G/HtCe9Vb2nbXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 10:16:15 +0000
Message-ID: <ab41791a-2ffc-429b-ae5e-1853106224fa@suse.cz>
Date: Tue, 20 Jan 2026 11:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates
 in move_to_free_list()
Content-Language: en-US
To: Yajun Deng <yajun.deng@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20260112121614.1840607-1-yajun.deng@linux.dev>
 <aWUKKyBZzsCBELLi@cmpxchg.org>
 <5cda8821bd3ac432a06698fa7eebdab0aff77452@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <5cda8821bd3ac432a06698fa7eebdab0aff77452@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 5351cif5pq9g3m7mzcu94xqp7m57jywj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EFFD580004
X-HE-Tag: 1768904176-638203
X-HE-Meta: U2FsdGVkX1+no+9bVYopF0Dpo1/CaVQ2KQ00vu9/taSPTYsMsONg+X1CKYLU1HUuCBMxHnzolTEPCiazn24e33U9XA8T5591sG5KqfVAWrTZK96huFtN1Dmk6IE+I3hDJL+XjgmCLQarCw5ynzSdHB7YFxVX044tM9L9S6hyIvKxL7dgvOcoxFP97gpwJ3FQc3xxqDhMoNDG9Xa7eC2duDU7PQdXfgAM736fJtbjUaG0uoZfuQN+to6TSNKqjz84HB26PmhnAq7P1zpcpxCdOEjH2KrC6/wp6h/V+tXUIjfB62Ib7CFys8mw46oRTdaLOoWWnCFLDP6lBMuVXxAAgN2PxFzwcl96hMF+eGiqn30c7ohLj+FHs+YaxT5zy4Xa6plDd09LIzjFdczxTiESOoSI/5tIxzRHaYrTlSZlqohvYEIjJhswdvMK5gK8AsCGWnhc8vBz7e0UjKikQ6kSHK7C0T9iaCmW2XEh42YLy2WoOvoAcsH3EwBde4pqztDmyVI+rKY3fvYEz1KDbM1qFxUHSGRxB1PEFi0U31kRWrX6QT0DUTEvlEieh0Agd4gbbIvNBnXPMtppSoW0sn80dTzVYmaHfRFyaSh4FQUMcIX1PoiLEYwyZbdfnMNcrWJO/fYd/Oo0jcywwXO3dFA07Ah17P7XiAbrCKVAu0LzKQxOmKf/C2sw3Pe4L+ow95e68xZ3rWXOVA7XlM4WW90UKUf8QwbXChpSUk9vGy5yg287pc4lD34BVH86a4X3n4OVAWrX6v8xv+O0aKA8pBc//4I7VXgrB6hk+JzRpiGftDOtRbNLJMwbTn1sXL//R1m0mDN2aeQPyuZNPY6Nu6Q2dBwiRlOqMIo+oaLNkdJpGI4teWHDb/f3lqLSfJxLPt/hfeSjJPvy4bhyOvJMnVblWCawyfmV4XaGMvctgjLsgUWp9bpUFdT2pHXg0NcYqFQ5Jop4sMdmEAN+49n3uJL
 0GUsNbJr
 QlfNMW16eGGbjF5A5zohk5m8swo67N9UrzPIiTzHjcAonjdfy3r9e8qdi4Wn4NlWauiSuNWJAtIZh95ChK6TKn49dF79pnP3xPdZPoRWXUl0rLu3rejMZQ/Z5hmNvj83IJxG0An2D8ZdZyvxRTvV7A+l0pJclUThkeXK0R4JjOxbhAIyZpINtToFK1KL0r+axIOSzz73dEZUiev/bVx54R9weU5K0+PjGWj+RFgjUGIAUaTEcYOKfq7EozWz9jesKm17CaDUADGiyPCvDQShH7bfnTLqv2QYAbEqIMQpoI2cMGovj+9adZKVMDDp5iT99WPTcRbnBn+MMgfgh6zb+D3C0tvZe42K4WB/KXmVDefyhBJpvZo6VRqPWS9zt9FwVT0GtRWYLE6FgbP8dIfRl1fX6TC8wrZdH+lqRmhBNC3CBYkXUdcaMzH5tVwO2iYVxf0/TtoeeaK6imyKZaJywOwFepG4ukLXWRGu1fNptJOwLCnD/Q+nAuPUydNjUmgFIV6U5y69Sa2v1Xce9NzzWIuh8kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 08:13, Yajun Deng wrote:
> January 12, 2026 at 10:50 PM, "Johannes Weiner" <hannes@cmpxchg.org mailto:hannes@cmpxchg.org?to=%22Johannes%20Weiner%22%20%3Channes%40cmpxchg.org%3E > wrote:
> 
> 
>> 
>> On Mon, Jan 12, 2026 at 08:16:14PM +0800, Yajun Deng wrote:
>> 
>> > 
>> > In move_to_free_list(), when a page block changes its migration type,
>> >  we need to update free page counts for both the old and new types.
>> >  Originally, this was done by two calls to account_freepages(), which
>> >  updates NR_FREE_PAGES and also type-specific counters. However, this
>> >  causes NR_FREE_PAGES to be updated twice, while the net change is zero
>> >  in most cases.
>> >  
>> >  This patch adds a condition that updates the NR_FREE_PAGES only if one of
>> >  the two types is the isolate type. This avoids NR_FREE_PAGES being
>> >  updates twice.
>> >  
>> >  The optimization avoid duplicate NR_FREE_PAGES updates in
>> >  move_to_free_list().
>> >  
>> >  Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
>> >  Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> > 
>> I'm not a fan of this.
>> 
>> The code ends up more complicated, more lines, and fragile because the
>> accounting decisions are now spread out over multiple places (again).

Agreed.

>> 
> How about V1? It will introduce account_freepages_both().
> https://lore.kernel.org/all/20260109105121.328780-1-yajun.deng@linux.dev/

Also not a fan myself.

Thanks,
Vlastimil

>> Is it worth it? move_to_free_list() is used in page isolation, which
>> has to do the accounting anyway; and migratetype fallbacks, which we
>> are trying to avoid as much as possible. So this path shouldn't be all
>> that hot to begin with.
>> 
> Not all cases are of the isolation type. There are indeed duplicate caculations.
> move_freepages_block() will be called in __isolate_free_page().
> Both old_mt and new_mt are mergeable type in this case.
> 
>> Simplicity & maintainability trumps here, IMO, unless you have hard
>> data showing this is worth the pain.
>>
> I'm tring to do it, but I haven't yet.


