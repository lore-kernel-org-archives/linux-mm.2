Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88592CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36E96B008C; Wed, 13 May 2026 04:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D166B0095; Wed, 13 May 2026 04:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23036B0096; Wed, 13 May 2026 04:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2D766B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:38:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8296C14060E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:38:14 +0000 (UTC)
X-FDA: 84761744508.26.4005BF6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F4DA4000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:38:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eESrrdIQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="AVvHt1//";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eESrrdIQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="AVvHt1//";
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFYUNIKWR8lBV9D7NdoA49JgvZy8oV3qnwW3azqf9oU=;
	b=JE/GE9sjk4iB3Ovx7pz+h9oScyDnTGG/oEnqgDr/9G6GiJfJgOjLCkGVrU7cR3+RM9CqeK
	SpnG3mH9eJGpEiH9njmZyGAFt9v6Mv96zwFA9JCtTmhLI6fJgZyjilTC3foD9kETI0JekW
	AV44w/+PUY8YJZss+PzjfJ1g0a3r3qg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661492; a=rsa-sha256;
	cv=none;
	b=MysLKwClC/CNfidDujULHmDgB77lA9faD+DGGmkAq6t6fD9XKcRc148eanEvKQtX0tsLxt
	N4GvEpPvFecmqby4+2ebeXyggi45cNgt4WJUpyUmFgYr9O0/IMJE4fi077jDpap9ZDgoF1
	k6I4RMJk9mpYzm36yYmBsmoNUo+Ha+I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eESrrdIQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="AVvHt1//";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eESrrdIQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="AVvHt1//";
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2252765C3;
	Wed, 13 May 2026 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778661490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gFYUNIKWR8lBV9D7NdoA49JgvZy8oV3qnwW3azqf9oU=;
	b=eESrrdIQWbkVSDlKpqwOCcUWgq9uS88uUIuh6n6rH6TUMspTeVhsCBxg7CDG8q1dFKUtfo
	3MWI0CPoLxPKW52W39uHJFvmVbvauuHfqSWwJiuid3JDujFSJBv0hkn5aOHH/QZEZGv0oG
	vB0voXZduOwMv/95z2hBgCGWbfZDDcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778661490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gFYUNIKWR8lBV9D7NdoA49JgvZy8oV3qnwW3azqf9oU=;
	b=AVvHt1//N8d7snBwLLYL4JUZ9mB8l3CiE2fHOI8u/aAW++xvcP0x6IlYXhcL+e+ZTcIE0p
	SDmkDnsSe+RDkDDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778661490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gFYUNIKWR8lBV9D7NdoA49JgvZy8oV3qnwW3azqf9oU=;
	b=eESrrdIQWbkVSDlKpqwOCcUWgq9uS88uUIuh6n6rH6TUMspTeVhsCBxg7CDG8q1dFKUtfo
	3MWI0CPoLxPKW52W39uHJFvmVbvauuHfqSWwJiuid3JDujFSJBv0hkn5aOHH/QZEZGv0oG
	vB0voXZduOwMv/95z2hBgCGWbfZDDcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778661490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gFYUNIKWR8lBV9D7NdoA49JgvZy8oV3qnwW3azqf9oU=;
	b=AVvHt1//N8d7snBwLLYL4JUZ9mB8l3CiE2fHOI8u/aAW++xvcP0x6IlYXhcL+e+ZTcIE0p
	SDmkDnsSe+RDkDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EC19593A9;
	Wed, 13 May 2026 08:38:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w7e5EHI4BGpcNwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 13 May 2026 08:38:10 +0000
Date: Wed, 13 May 2026 10:38:08 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/memory_failure: use bool for hugetlb indicator
 in try_memory_failure_hugetlb
Message-ID: <agQ4cAK-QOvy0otT@localhost.localdomain>
References: <20260513024853.65566-1-ye.liu@linux.dev>
 <agPx2woN458Co5Us@localhost.localdomain>
 <fe1f36ac-84f1-4557-9411-41497737224d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe1f36ac-84f1-4557-9411-41497737224d@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F4DA4000D
X-Stat-Signature: z59hxigbk9gsarymx8g71smc5qebj5pe
X-Rspam-User: 
X-HE-Tag: 1778661492-770262
X-HE-Meta: U2FsdGVkX1/BFQT8N6fM3uGJbZc9j+6KKsHVAJUIAJv/sLEHIKYlgdP5IRFOKVWhk6wth2VyDMtj60KBF2VgiijLiyBMViMoqXrXj5ke2tNjUVBwpL1NiIFX7rVXcE1AUhjlCf6FwyUCBo+gbcn5/hhGcrjSipVHittvaTMlKtlJMruQ4cRzpjP7limlA46NEriAWxGpdBO8cGtUW1r+YcrffhUMLHrjN5E54Oa0B1F+0iEQ9OBKsz1y0j2vPFydrI9u1LkpzYX0nyvjT8XnCDV3ycus27YsTeDb48RWPq1j8l5SSPs/0boWeOWvOBQU28FDY1LAS5VWeWAVQhKt9aJ5bi/cFJKnteNIlCKs5S8GwxFDFhRx2lm5mDmaWiSGgfWI68mB6RcrKOcs0jiNEBUirqRPe7q2FApCawr5TPibIcenmqdeTBrvVLPn9+p1DpdDc9SohklN7kQI4pM1YfePQ3aKbzQVc2KnxNZQ/JBOcOVGYn5BJoyxWjbrkykucU+SxNNrXdPwfBnfrSYQe8xtiNL8UZ6u6o/7vvbTcfshv0GK0s5keceP7tJzahZPJ0SSQwem/7qjGo57OG8Tx3ZNt6qOsIa+IXla76WK1lADZmP+DbubGjcJf28AgIgnFDuDGMqqnL73C664RB3jV2WeUJdNvrqH6+kgVtRJQk814yNRfxjk9X5xP5cvGT5fVMw4BlgD3gNcP1TWYd1UzZJqzdGoD5fSkn8BIyamMjJix1MrdiMOMHEO+WGmNSJSDnx4BNxU5iRdQgI6YYHHxt0mM0FUa0kmtD7myuJVbMFR+jLxGIechjM4UVZ17iTEA9i2pEGwLLNPOjQ7wjjWGuWTqlgM5N9XQaycCSmMhnpt1whbmBbMOp01cC4vB2djiT0HcAG2c6/qGg34egoz1oluSB0zH3ywr8cuOzApunmMOChsRkh3RI7RhIsakAAYa7nJvFQ34a4h6RI8UFq
 pY5EJQHn
 Xm+TJNpmInAlIItI4wl86pz1fuOFgBiHvOxYbRPFG3SZQ+SKygZ4mVyF2YJyrTLEE4ZycLVoep4zmRSzhI9fQV8e8Yg50iX/BUf7Iu447zf+99PQrQ4wlteEoXtsIPC15Mc9WGauSusJugQX1OcJmPYyTwoG0FBwxSpVgOFQO2uJri7/VfhX+h+H4cYz0Pc01+ez+UzAcIf1doDrk262zZef9buMmhOLNB1XFfm5YnAxKFx9UXybeehg2nhaHDMS+2OxgcjXjouYBRkNUMeEo91OpRRMVyidvjG4Lhoz1j96k+ivFTtO66lnYGkgb3/0SJiAV/jNsE9ts3tJTA/KlT0JiYIPTRoVcTg/HLPxlqEFGQUJ/4cz2jzdFBb3q/Tp3XTat
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 02:50:56PM +0800, Ye Liu wrote:
> >  -static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
> >  +static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
> >   {
> >          return 0;
> >   }
> >  @@ -2386,8 +2385,11 @@ int memory_failure(unsigned long pfn, int flags)
> >          }
> >  
> >   try_again:
> >  -       res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
> >  -       if (hugetlb)
> >  +       res = try_memory_failure_hugetlb(pfn, flags);
> >  +       /*
> >  +        * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
> >  +        */
> >  +       if (res != -ENOENT)
> >                  goto unlock_mutex;
> >  
> >          if (TestSetPageHWPoison(p)) {
> > 
> > 
> 
> 
> Hi Oscar,
> 
> Good point.  Using -ENOENT to distinguish "not a hugetlb page" from
> "hugetlb handled" is indeed cleaner than carrying an extra output
> parameter.
> 
> One thing to note: the #else stub when CONFIG_HUGETLB_PAGE is not set
> currently does:
> 
>     return 0;
> 
> which with your change would mean "hugetlb handled, skip normal path"
> instead of the intended "not hugetlb, proceed with normal handling".
> It should be changed to:
> 
>     return -ENOENT;

Right, let us see if Miaohe sees any issue with that approach.

 

-- 
Oscar Salvador
SUSE Labs

