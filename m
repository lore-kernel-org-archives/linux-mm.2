Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E67FCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074618E0012; Wed, 12 Nov 2025 06:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015DF8E0003; Wed, 12 Nov 2025 06:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E470B8E0012; Wed, 12 Nov 2025 06:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4CD28E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:57:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 548251A0401
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:57:00 +0000 (UTC)
X-FDA: 84101803800.22.201EDB3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 315E01C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:56:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w9nOhYJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jAac+cRE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w9nOhYJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jAac+cRE;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762948618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0g2ZQGhI6iBBn2VcyWKzEcG+U4eJ7lGhaFDWj+BTHYQ=;
	b=NRgXsWh27t3tBFqPev7qqCMxaEyeGq0zOwz/2RpSX9hQrnV30dddzk+ih82OPKLVQBcjN4
	i2aUBdT2l3+GbeVVh+iG79E2Ud0xXkb6Ye5WGA1lsOe4GeKzPb9w/4Y1ros0PZlK1W2kDp
	EMKyvA2TqQROKAm4TMwzvj0zHcdC5z0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762948618; a=rsa-sha256;
	cv=none;
	b=EeoddvvWM95mtFPFmQCJvmhtUUSBgpP3iEfes6Neek9/a8RH320U2kLTQ42F0pckKJc3bC
	dxnb7p3ODrqM46tH6jx8DFKsCRSVllCch0GZEh5drk/GE/WjO8N3YfsONseC+NTWJ92gaR
	yaM3YKg/3gM7jAozGocL1QxFJw1OZpY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w9nOhYJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jAac+cRE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w9nOhYJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jAac+cRE;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7CAEF1F45B;
	Wed, 12 Nov 2025 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762948616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0g2ZQGhI6iBBn2VcyWKzEcG+U4eJ7lGhaFDWj+BTHYQ=;
	b=w9nOhYJeRdw9nlV17PNOpINUgL9gTQyOFMOsYdfybI8OGqvUCcUmK6lzPmOYXCh0GVNJkv
	w8akBR0W0u0ovF5ITBxrgJxuvM2PzyfoUzQhfldntgG2qOHjkBvEryb4T8dXK8yh9IbFfz
	8MMc2FS6UBh06sng3Hz35XVKB75Iisw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762948616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0g2ZQGhI6iBBn2VcyWKzEcG+U4eJ7lGhaFDWj+BTHYQ=;
	b=jAac+cREUcPC2hYeqBGKcKTu0WDrmg+Qr74YJjX7dmSW3tT/4wz6itAyP6ydhSxd3dDYZm
	EDXH4FSXh8+pyVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762948616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0g2ZQGhI6iBBn2VcyWKzEcG+U4eJ7lGhaFDWj+BTHYQ=;
	b=w9nOhYJeRdw9nlV17PNOpINUgL9gTQyOFMOsYdfybI8OGqvUCcUmK6lzPmOYXCh0GVNJkv
	w8akBR0W0u0ovF5ITBxrgJxuvM2PzyfoUzQhfldntgG2qOHjkBvEryb4T8dXK8yh9IbFfz
	8MMc2FS6UBh06sng3Hz35XVKB75Iisw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762948616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0g2ZQGhI6iBBn2VcyWKzEcG+U4eJ7lGhaFDWj+BTHYQ=;
	b=jAac+cREUcPC2hYeqBGKcKTu0WDrmg+Qr74YJjX7dmSW3tT/4wz6itAyP6ydhSxd3dDYZm
	EDXH4FSXh8+pyVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD9823EA61;
	Wed, 12 Nov 2025 11:56:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6YJwLwd2FGmJFQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 12 Nov 2025 11:56:55 +0000
Date: Wed, 12 Nov 2025 12:56:49 +0100
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Muchun Song <muchun.song@linux.dev>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
Message-ID: <aRR2AV7_R20i4qi8@localhost.localdomain>
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
 <aRRPvn4DYAhuGtq3@localhost.localdomain>
 <6a63dbb8-58f7-4511-8090-18a58c3206d8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a63dbb8-58f7-4511-8090-18a58c3206d8@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 315E01C0003
X-Stat-Signature: z4jni4ijcdsrsxseihibmnnm3anetkut
X-Rspam-User: 
X-HE-Tag: 1762948617-171062
X-HE-Meta: U2FsdGVkX1/iH7Qf7Pi+J41vaTiHciapRybAfDMKceAueiB+R+2C5ricKw54NPQzg++OOM3kTc6h0JHIuOuJwI3eTc4PCPHfdHikFPrznCCMqVDIRzc91PPYFlMFC20S3kC4If6jRwuCs4zudr0+7sepoX8580lbEHr+pymxatmi81JwlxTlYW1rcX3xooOrxu8VvisL2j64T466TyREzok18A1HVAvuqGJgVrqhwYuZwFYUR6hkxhWheFPU5ab2LCUIkItoTOST5eu2fuQExvbevnnQ0ybA++FKxu9e67e/VcyVcjgj80VBrqWsBrxV4kmoF79agCnwuhECpwhuDhMtWMisPGIDpDbZG8kI8WbcZk4cPtPaqIMd1SZfqDVWnJb1OlgVF9T+oU4WTdaDtZo98KSBHj59JOW8FKHbxnqmg8cLzNezfVVv+3xieQFJrNghvDkQFUK02/FzJw9e1dSVmgMWOTqODEyn2WA3viWgKYZu/EP8ae4hRCpH38dRSSIMq6KewX70GGbYnuJWt3Up76xQbqfKD6GRJolcYeVD2VrL76p8WWN2J5dVIMygXJCYVAIuNxf1A00/gqh0Sfv0ogFgzfoiCBdLm1YBiLXPojj1mUwhJ2Bx6k5QcT0fnoOh6/w3Z5w8diiSD8237yMn5LElCXsOJYtRt3q+MH9s9NtWcr4QEGhLsrCpYcFybJW/7OS1Q1tI55g7xc3qquFMDd2hhlGO9tdb/tLfglj/83aiIwSZ4dy5omoK8ct/+hso0zd0IXfuNFBu4LEoUOcSPJ+NhwsA7k0iTbsClySco8hP6fYkW1n8hUdZHgmUtS5LaboBxsOUHjg+0SHC+oVtPlWg/ezvF89FleYxmq9AmhMqRjNN2afWT2DBeLxghFIZHHwavaqsTVrEC99xXJZmJ+TCDQzl2hhhgLKOvmuPKSnhexdpYNNHpNSI7DWRa2vsKIFGlaDHp98/I+E
 1gfCHX+k
 CM96uVNY3tJULNBVN7TCC7e/xLMWiWaBBBFROAYM8ufoDQc9tvvjgZGlPABxlFpDKPjP5jtxASNPVQhA0M1HlCW9UHueeI23IenBi4ZmEo+jr7JzFNbVE5QlTpq+oTG/cH6L9/D0DOsXmFpZqtQIkLLRroidkncbP5eLzfER7rk1ARM+x7sbrclE0flqrJNgwgTjVDyp1mcrsymzKVhazXHtfi7wtUaLF7OIxzdDp3AQOyOPNIL+XJIQAds9OSfKmuAJTsQs+O0iixkQjJABxzfJYkaD9yT/S639JZ3gkwqwLzig6Bs+zCmm520IEvh5T0h1jzVq1Npz41mKlzEFc7fWr0IjcWF3hQWfQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 11:09:51AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12.11.25 10:13, Oscar Salvador wrote:
> > memfd_alloc_folio() seems to try to recreate what hugetlb_no_page()
> > would do (slightly different though).
> 
> Can we factor that out to merge both paths?

I guess it is worth looking into it, I shall fiddle with it.

> > Regarding the uptodate question, I do not see what is special about this situation
> > that we would not need it.
> > We seem to be marking the folio uptodate every time we do allocate a folio __and__
> > before adding it into the pagecache (which is expected, right?).
> 
> Right, at least filemap.c heavily depends on it being set (I don't think
> hugetlb itself needs it).

Yes, you are probably right.

> > Now, for the GFP_ZERO question.
> > This one is nasty.
> > hugetlb_reserve_pages() will allocate surplus folios without zeroing, but those
> > will be zeroed in the faulting path before mapping them into userspace pagetables
> > (see folio_zero_user() in hugetlb_no_page()).
> > So unless I am missing something we need to zero them in this case as well.
> 
> I assume we want to avoid GFP_ZERO and use folio_zero_user(), which is
> optimized for zeroing huge/gigantic pages.

Yes, I would go with folio_zero_user() as well, to match what we do in
all paths.
Maybe if we can factor it out, we can simplifiy it as right now seems a
small-duplication of hugetlb_no_page (and more so once we add what is
missing: mutex, uptodate and folio_zero_user).
 

-- 
Oscar Salvador
SUSE Labs

