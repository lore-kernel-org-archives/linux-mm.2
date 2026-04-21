Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3B5F327B4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 07:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F7A6B008A; Tue, 21 Apr 2026 03:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0A56B008C; Tue, 21 Apr 2026 03:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE686B0092; Tue, 21 Apr 2026 03:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8987F6B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:29:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14F5613C155
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:29:58 +0000 (UTC)
X-FDA: 84681738876.24.785A3F3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id D3842A0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:29:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xEksfWTK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qUQJoihJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xEksfWTK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qUQJoihJ;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776756596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmpWofTIlMRvaJ2R/6EdvLQ0b7yTNFErU+2L4jvVqZ0=;
	b=D0gbC3aAOH4kllVpsFIxw/7q9KVok+/vaZ57pvanohL6oKHCU/PwE0F1ZbATQkMmrWmDwg
	BWzKTNvQxCov2CmGlCkOqhP8/feAzQvb1t2ZUgNGPXZLCujx8MASUctbOWCq69lbhxV3m6
	z915BasNOsqnCxvg0wkfoc7vfFEtfso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776756596; a=rsa-sha256;
	cv=none;
	b=TFc20FkPM3SVfuOCmXcj0qk26SZz7X0ITrIMoClg10dMIpyMf+R0RKqJSgc0zCHGLeZu/g
	SI7mRnMrb0Y2QqTLeQBBt/zebmFwWvc2Au9sG/jGd7lqztCIFQzh2K19Db0qb01J6e32c1
	PcgjMoY5nHETIxEcNR7rQcOAk6nwgjM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xEksfWTK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qUQJoihJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xEksfWTK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qUQJoihJ;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D01F5BCDE;
	Tue, 21 Apr 2026 07:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776756594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmpWofTIlMRvaJ2R/6EdvLQ0b7yTNFErU+2L4jvVqZ0=;
	b=xEksfWTK1V92y20VMkyzbGQOjYDBcGO/gWhbuEyYcKEa+ycQJF5wp6W1MB99niJpWx84bk
	W102vN7KyOIr6MqHMYJybMDcZq3J2H9McFMkisag+oyd1sTqcBj297x6+VRYxdvpWNxDqR
	KE+NO28lRXCJDE79c/TuvwYc7Xv70SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776756594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmpWofTIlMRvaJ2R/6EdvLQ0b7yTNFErU+2L4jvVqZ0=;
	b=qUQJoihJzeuHaNAO0HLLA7EYBdbRP/1+UK8T4zmec7ce/r6WXBask/Hk9tiJ3dN4AMFxNZ
	FodFjuFZWHSg7QAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776756594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmpWofTIlMRvaJ2R/6EdvLQ0b7yTNFErU+2L4jvVqZ0=;
	b=xEksfWTK1V92y20VMkyzbGQOjYDBcGO/gWhbuEyYcKEa+ycQJF5wp6W1MB99niJpWx84bk
	W102vN7KyOIr6MqHMYJybMDcZq3J2H9McFMkisag+oyd1sTqcBj297x6+VRYxdvpWNxDqR
	KE+NO28lRXCJDE79c/TuvwYc7Xv70SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776756594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmpWofTIlMRvaJ2R/6EdvLQ0b7yTNFErU+2L4jvVqZ0=;
	b=qUQJoihJzeuHaNAO0HLLA7EYBdbRP/1+UK8T4zmec7ce/r6WXBask/Hk9tiJ3dN4AMFxNZ
	FodFjuFZWHSg7QAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29EF1593AF;
	Tue, 21 Apr 2026 07:29:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h3awB3En52n4KQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 21 Apr 2026 07:29:53 +0000
Date: Tue, 21 Apr 2026 09:29:43 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
Message-ID: <aecnZzXiFf2n70K6@localhost.localdomain>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-5-songmuchun@bytedance.com>
 <aeb50jwoCBvgEnec@localhost.localdomain>
 <9343F329-BCD4-4D64-94CB-A94F0E9E4400@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9343F329-BCD4-4D64-94CB-A94F0E9E4400@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D3842A0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 61cq4xk1i9w1619zq5w9wuourep63u54
X-Rspam-User: 
X-HE-Tag: 1776756595-335178
X-HE-Meta: U2FsdGVkX1/8guwDlNijWmzwQl6Qgf1SoRwS22Ueq7EX4gC+tIEgQqEHlBzgloM6DcJYXf4ePz7b7CBu/kO5twEfUCg0nBhnhV4iR9hIAsCwmeZARPeuAmB8kB65TxzKmTiTwmf7WNFGeVGhm/KGqjr0u1txxlLH/+nK90jR5zxORJFuL3nZH48+H5A66rLbajEWqf4U59UI9cyg8fo5F4+otO87u49EdQ7kAmyCLL4m2IJUH7Lj5LjzK1PqiwluYdFdGzV3ysjqdjy5Rj72IKPqAhhVROs8rYP5rI4AzCCUAQvvEsg4ud6tC+cCbmmQoekQzhmjWofqOg8WyXHYdz6sZoNUXlJNT0v+K4G+w4NrVgZ+sDaHbLZCz/C01gJS5AZ0bG+O6ztf6PHuduPRYAsrYXojFf2DSZcw9httdRTLEIykGPwOL38LG+uiVbKpls7c9VyIdtqFUi/4r7QVW4NHLypMVvaWGZv5HfB23INoVB1iBrf+uopPWr3hZa2djmRXFRGLuPBW/agU4ROCrKGZxYZFFB/KjyatZl2XtUTPebay8XaMjucb0VjmGaxLypGe3j3/khY9gnWN7r0yz3R1bVZJoreM0PQgT6pDfR17u8x9c4IBnzPhWk1E8fqMBpSwz4hBlkzCD5CZ/kMrLaWFRPYkq4WDH+K4uq5Pwg9usQjwJyASol4vlYlnowk3QfPbvYXV1lctZj2gTLBkZTUm778HILbIJ3jotuF01mAxxwtTiZmbld4KGnthR4Wipyk6PI+4Bu4gbjwuTVD8UK0lQTdtcUYz3OoAlBVw26oMp8342lO57cd57GGVs60KZ8vII5GcyTMtqArFiHfncPsxMWf6rrjebsu6WyF4o4m4R8zyPobvHwLmmx6blI6VRxzW+MUl1tyk5UPnPzOslchjZLrw3PkjUZpDuuiJaq6FPQo7IGYufj1oFQqvS1ykw8pWoH+N5BSAvkMP+L2
 nniCDph5
 H/k05MKK/1h/Ox+ayGmQHFvyk2229ira9kg//Afpf5UbIY2cfo1E2+iLFeuPT3JEnTgwdvHYMB1XDPAYEeqR5TMwYPLXZzJAR1r4PAO7zzxy/hS+KOiAErBZYPz6+boWXcjLmOf1Gem41UDHwdJm8RCZVYTzWCEKT9GEzuxXsx9LNg7yzb6BFMNxv5HHNNdhYd+coH19HyjJjbeGlgwE87RnKJfBg4jHFLSfnFug+Zwjyj0XMEH037C5lpND7kf+jwA4+x4wuBQHIWlz1ApFnaMrXlv+vi1VHklwiiKxhhHgq52uh2wxyaoy/lFDLGS0elarVg/2HVv6AiRaF1cCZfvjkTuNJ3ILJsqimAPPWNPBxvuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:54:35PM +0800, Muchun Song wrote:
> 
> 
> > On Apr 21, 2026, at 12:15, Oscar Salvador <osalvador@suse.de> wrote:
> > 
> > On Tue, Apr 21, 2026 at 10:20:44AM +0800, Muchun Song wrote:
> >> The memmap_init_zone_device() function only initializes the migratetype
> >> of the first pageblock of a compound page. If the compound page size
> >> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> >> subsequent pageblocks in the compound page remain uninitialized.
> >> 
> >> Move the migratetype initialization out of __init_zone_device_page()
> >> and into a separate pageblock_migratetype_init_range() function. This
> >> iterates over the entire PFN range of the memory, ensuring that all
> >> pageblocks are correctly initialized.
> >> 
> >> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> > Would not the call to __init_zone_device_page() from
> > memmap_init_compound() take care of the subsequent pageblocks?
> > 
> 
> No, it won't handle them automatically, as the page count from
> compound_nr_pages doesn't cover the following pageblocks.

Ok, I see.

 

-- 
Oscar Salvador
SUSE Labs

