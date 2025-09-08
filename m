Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC94CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1E08E001F; Mon,  8 Sep 2025 09:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6885E8E000E; Mon,  8 Sep 2025 09:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DF28E001F; Mon,  8 Sep 2025 09:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 496558E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:38:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6FFDB69D2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:38:50 +0000 (UTC)
X-FDA: 83866188420.03.097C69A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id B734F1C000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:38:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tebhSr7X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sEKoPZZx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tebhSr7X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sEKoPZZx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757338729; a=rsa-sha256;
	cv=none;
	b=bOw6wHPJlzbNwaqtNWMK/R7ncAtnxTnvf4uEPHOVgruL6lCoKCUkUgKHFYtCtT047bxtdr
	KslIJjXc9PFUecsFoLgClkb1eAVUa+woCmdLczt1i3t4XguoocltwWPTZq08tNE/hChxKX
	xgFLRaDg+r/kOwLzPg7XpHbVULdwb2Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tebhSr7X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sEKoPZZx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tebhSr7X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sEKoPZZx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757338729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OC3qfht8SvtbaeX7sO90i1+33209HXROWnR5CQnpPd0=;
	b=P6LTBBbBwKiRPax2RpuSJKy8YKYu3aS7EWOoK3xZcGJaecrITqRt/hURrGmZyIBgNwZuCG
	7/w0Ng8PVwGMr1V8pJvYyRkWK09e13eMnZXctvGG9LyViqF4uXP1RBayFyvHbxZ87R3iTS
	0MHHeehwRRXfSCCa7onn5CiXowondtI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43AC7274BE;
	Mon,  8 Sep 2025 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757338726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OC3qfht8SvtbaeX7sO90i1+33209HXROWnR5CQnpPd0=;
	b=tebhSr7XL1VTIE3sUhwSvBIk4jRXjSUDsZNC66fiSj8DVBexhFaHyrvSCeH7Mq53HejA2y
	0Hn/jsC4SQXbS172e4EFVs8sUx2YFQLzRsdCHRYEE1f6CdtwfuYlNtWlvTHU3P0lTHShfh
	La16zwMLCZDyD/a0ZdjV9N6ueak1PTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757338726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OC3qfht8SvtbaeX7sO90i1+33209HXROWnR5CQnpPd0=;
	b=sEKoPZZxipKwmNJSJh/9h6cBRi42WDLBwp5WhHR7Ia3gQ9ec3B+hiWGhr9StAgrXafBmvp
	ASsyyvdYqOIBxUDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757338726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OC3qfht8SvtbaeX7sO90i1+33209HXROWnR5CQnpPd0=;
	b=tebhSr7XL1VTIE3sUhwSvBIk4jRXjSUDsZNC66fiSj8DVBexhFaHyrvSCeH7Mq53HejA2y
	0Hn/jsC4SQXbS172e4EFVs8sUx2YFQLzRsdCHRYEE1f6CdtwfuYlNtWlvTHU3P0lTHShfh
	La16zwMLCZDyD/a0ZdjV9N6ueak1PTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757338726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OC3qfht8SvtbaeX7sO90i1+33209HXROWnR5CQnpPd0=;
	b=sEKoPZZxipKwmNJSJh/9h6cBRi42WDLBwp5WhHR7Ia3gQ9ec3B+hiWGhr9StAgrXafBmvp
	ASsyyvdYqOIBxUDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DFE513869;
	Mon,  8 Sep 2025 13:38:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QPfOI2XcvmhYOwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 13:38:45 +0000
Date: Mon, 8 Sep 2025 15:38:39 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/9] mm: hugetlb: convert to
 account_new_hugetlb_folio()
Message-ID: <aL7cX7ayQLqt_T00@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
 <aL6hUFNImBtW8OdL@localhost.localdomain>
 <c4e05935-ebb7-41a7-a86e-07e00106bb56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e05935-ebb7-41a7-a86e-07e00106bb56@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B734F1C000E
X-Stat-Signature: gdbdwjc9pj7ye3fodspcyphgw8eb5agj
X-HE-Tag: 1757338728-684963
X-HE-Meta: U2FsdGVkX18O8f2R1Z80LeWUDzKC2CqTZo7x9nK57PIcIRsyLvaeJnLWGJiavFQmrUuQrxVpYOpDLt5+NuWcQnHzV5wO6zFcRDGYGD+GYSuceJBvlHJaaeTlfpEvdyaBaXcaJbPCIDjXsckUiYjD5qtxwNjX0bmPEZtupcLagwRFOmDU5NiQQMUuCD/+mts6LzOQ3QOO1yEx2K81ftYB0f4njncEsqtW2EjeXaIfczxyOJemIzPxgJIwFqhUzyx3pSkQdcNE5t79GOcZoGaMp50shLcdnpSM05MEMr2s+Eu+TCJ/nwwDnDu/kkkVzG2YFNLR/8uVvpZeO7r4qhLNsnK7SYfD0w9ij9PlRWkxFgUCin015ByLOTSb6tyaY51BtsAAVITy5QI1QdSxhA32Edi4J0BfRh3VAKiTJ2BrJwg5Zo9hlfiPAgSfl+D3W6rzVZqBzTrFO6+Y7G5up9RNu5toYvGhR01af8AdR/ZzAvPoFYZzDJ7Z8ewLzLeLj7G+M8JpYl07Qo/p3XykMB/V5GiaFQlI7wO9te/yx41X/hBWmsMrh0xTytoCMRUMJJehm02pupvyABneT/ZBOsLI8UfpDZG0IHOzCTkY9ZJGgW1xK8r9rYV/V8yvD4Qz2J51X754aZH5T6Ha1OdEfTY+csyTqcWuPe4YjTasBbtPo5t2LabJmZ9Bfzjvnk9XYhKJv+oc5kqt4w9qns2+yC+gQxQ7T6n9/D4JtooDX3IOfjwRndJyAfpmVhNfl0Wp6jImD2qtkBbGSilmFg3bBZbjQAaw80kvVp7NBjDujPYm3mfAeOKM2AM8Fop/MN022XetXMYh+4sF8CnC18b6+KXDLABUpJIEqJ9vKOBz4mr5OfngxwXFVFKG6pKu+IVS9nwbFIhtWeiVYvT1yjXTWmJpBuc2qazpE9Eu0ZJgfKJRfJ7sXDhbla1W1QqaB2SohaBm4DKdktOV7DjbzjSon2O
 TjWlXu/9
 VK/JiopC2ilETT8ppvgy5S63+1JGrTrzDp5ZqFwZ29aZgNzTt/8I9ezXj0wA8VHaeI5AY0BgBoLR/F1sDFXoJpIDtdUKCsk3Nq/z5hnNQ7DzC61gUy95IXbGgYDyyzBHWvIqyFyK11iL4wjBA+ziXNeQo3U4FAJlMq/kXg7hiLefk5JtxVn7KqabYzmXFfjWhyChKIbFBoXaTJzwk0EdSvU3PsaaUl785lfYTJALlWcGvCXU8pP4cllVDGhb5JQ/yH7FrurEZxlJC+XKX1w/5ybsSBhmZMZYtRdysDTsxqdaguBnjkEI7N93qnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 09:20:16PM +0800, Kefeng Wang wrote:
> We did make such mistake before, see commit commit 382360d289c1 (mm/hugetlb:
> fix nid mismatch in alloc_surplus_hugetlb_folio()), so it's
> better to move it inside.

Ok, I see, I forgot about that one, thanks.

 

-- 
Oscar Salvador
SUSE Labs

