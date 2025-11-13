Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F1ECD5BD2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7219E8E0003; Thu, 13 Nov 2025 07:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1A38E0002; Thu, 13 Nov 2025 07:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0C48E0003; Thu, 13 Nov 2025 07:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47ABF8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:04:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E01B3C08DC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:04:19 +0000 (UTC)
X-FDA: 84105451038.12.1AD0428
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F9E54000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:04:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrGvUOCX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWByH5oU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrGvUOCX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWByH5oU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763035458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4cIyQEDcX8IYtapSz3cwYnB1AEHvylAazd0oOZJHbE=;
	b=h3ZtIDPFkV5XAkgIKGgMviwO3exFeBO/7xZxV0liHvmp2+thJzBYYO02VKIWyaeW8D+8v7
	U350i+BKJnp8NLNJcAlcM2SNSGP80hhRsTKaAFhPN6T3CsS+OCVcWc/3ZL0HtrsiIKw+Rh
	KqIH1Qhxh69dVuxsEvjyWjbHcVjFeQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763035458; a=rsa-sha256;
	cv=none;
	b=bVPpkOHbpxqwNc88fftM/arpkFNW0xoC3MtdK5jbkScHEP+qB2fkmQMikBPDEn3Ntu+A8R
	mnj5fLvmrIDnyMzvw55onEb4NuNwSsQPy6qpgFEvzv1DfXg23aRIFO284c8phTdxpJeBAw
	KVPIDmtv196w9Fz1SUmBgCMPuXlUu2U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrGvUOCX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWByH5oU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TrGvUOCX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWByH5oU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90FE31F395;
	Thu, 13 Nov 2025 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763035455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4cIyQEDcX8IYtapSz3cwYnB1AEHvylAazd0oOZJHbE=;
	b=TrGvUOCXOs7QH+PYeNPFvHAjxdbuXMoqiFrtYnA6FVga97LTv59g87y10uPCpInRkt9xMG
	di4+EuW30F3iYLY1TcmH1EFqbwBtwoXgmMCYMWyVpn2bMeu2QyHBE39GEi4eb+Fera4LSR
	L1/ule3HpZ3pRHHv0kwPbp+5ftsWwdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763035455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4cIyQEDcX8IYtapSz3cwYnB1AEHvylAazd0oOZJHbE=;
	b=cWByH5oUpIspG+wv+pyu95wcBOxFKb/gmooUgkcMDoujQfkBdYmM8CaeO32N2xtZb5Ll32
	5rvGvm1VxafLUlAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763035455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4cIyQEDcX8IYtapSz3cwYnB1AEHvylAazd0oOZJHbE=;
	b=TrGvUOCXOs7QH+PYeNPFvHAjxdbuXMoqiFrtYnA6FVga97LTv59g87y10uPCpInRkt9xMG
	di4+EuW30F3iYLY1TcmH1EFqbwBtwoXgmMCYMWyVpn2bMeu2QyHBE39GEi4eb+Fera4LSR
	L1/ule3HpZ3pRHHv0kwPbp+5ftsWwdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763035455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4cIyQEDcX8IYtapSz3cwYnB1AEHvylAazd0oOZJHbE=;
	b=cWByH5oUpIspG+wv+pyu95wcBOxFKb/gmooUgkcMDoujQfkBdYmM8CaeO32N2xtZb5Ll32
	5rvGvm1VxafLUlAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB4533EA61;
	Thu, 13 Nov 2025 12:04:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BAugLj7JFWnzEQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 13 Nov 2025 12:04:14 +0000
Date: Thu, 13 Nov 2025 13:04:07 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org, david@redhat.com, muchun.song@linux.dev,
	kraxel@redhat.com, airlied@redhat.com, jgg@ziepe.ca,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	vivek.kasireddy@intel.com,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memfd: fix information leak in hugetlb folios
Message-ID: <aRXJN2WHvfAwoAFE@localhost.localdomain>
References: <20251112145034.2320452-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112145034.2320452-1-kartikey406@gmail.com>
X-Stat-Signature: sy8hrhzmzmk9te1eroceej57ztsiipun
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F9E54000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763035457-639957
X-HE-Meta: U2FsdGVkX18ubgEG8NiCpze+e9N8qnDz8RKL5ouZjMtZemq2zvSIccJl4tRhJh40qx/l2thYE0t+XgUwR8iQVl0+2EINYVQQqTBxLx/ehqcW2GjiouycJlFzyDsQz1ZaFVP1OZOwxJYLDwlqZkx525KOIb3mh5Q8RU2zfPOkmaiyPEVE3E4c6cprLREE0y6bQWvVXPQEB9W/8Xlt6VVfCfEzw0IvCrJY/s3QzHVbiYJm2snm/JDIzCy5dDRxoNJvYtzznjmxcwaXiA3pwrx6T7PrFCB+oJrer8KUtcjB0ojlhiLkGaYyheO7w6mUenEL5LcKrvK1nKVh5N1545Fdi+7wxPCIrW7YAhSI5NYONi92K98MDxckzykAFhoptBaWOzpEJC0ZxmQX94dTDcSfeKmCc81Iii3t7V5LBmtIUoaWr9TFYM5ZSRHwy2mBKUA7+QUL05008asY4Bvk1x4i85sNvKkWdrbeLVK7la1767sZ9iUWQ5jbQ/RhtQR64ZnFanuIT1xkgClsiqhUI7ACfWXhMHf7h2FoVl+XABi75R2+uFCN3kxcJ1Uc5BcDtCNYJkkIqg1X+JhkeN0BiK5VhZKne7twsrBjM6x6aBtx33XBGeCzthCluBzk+k421FgcMLO0HnUwjQy7iw5+P8wGhqS4mH+Q0eRa+9Z3YRz0rfcvgMYV1CmiexJ2OAm6UFB2ifY4/e5aE366CyzrUWW4TYoNTyDsptZPfZT/ti+fpo/EbtRnpbxZ5eygXp8dzS43JgilYPz+B8BP0zkh04uI5tFdYh91BuAjVAK/hKIdMtaR+r1kpTVMW0nukSrUTRv7XOusIWEzGPGFCQtnODfeOEODk84M9LGwrCcpDM5HUeNwKUASLeCfFuBTxviIrldZ8SMzWqW80XB8DwxUAlw/SjefB9l8fLkb9Yu/h1xbg74PeOsNLJ3CIEfBIha+hpuFPUflxZyifOhsngeMdfz
 jbl7Wod7
 KtK05fiN1kL7TZFw8aZFvEcnZcsC8vLi77OU2gG/Iofc8+ikpkGnE9fc1a5v9MHGJ0Sgaxl6SQyTersBUr9DUgAS4yW+0/TWrcm0AJ4OCdrPrb/JVcNg/sFUjNa6bzE2M03k90gyH6W+kXE9T+cy13VUinDnw0UaKUO3mCFX0W7ZilXqG3UPJLNArya24+Ac/Z+Ekxb2gBbMCDPsezSSvjbzs24uRwUfmgDwLmc2zDfBWrow2tUANzBy2y2/dCDyFT6KQdEJKS/hb2yFih5ZpB5tf/jx1QXhsk/RPtc+pcI4ewRSTrgToyuYh3v5QR1KLfbeiw5SN9db0tdvKWww721pisJXv0w4SHiQsMF/vCg/La29gdremkaiz7izFA7kjAox5MhrvlfmG05upGssuYIaL17PDB+S+F9ZTsCGAqIZTDB30duRyas6rF/Kp4R28rPkMpTpj6T7huD4E5hnkY+VvQ9QauGNEOFsfMARKbVkP8QY1182+kQButzrOyXoTSJG2ELr0xHJ18GtRBOqNyGQ5JEerJxeGva1GMCw2NqnU5IQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 08:20:34PM +0530, Deepanshu Kartikey wrote:
> When allocating hugetlb folios for memfd, three initialization steps
> are missing:
> 
> 1. Folios are not zeroed, leading to kernel memory disclosure to userspace
> 2. Folios are not marked uptodate before adding to page cache
> 3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()
> 
> The memfd allocation path bypasses the normal page fault handler
> (hugetlb_no_page) which would handle all of these initialization steps.
> This is problematic especially for udmabuf use cases where folios are
> pinned and directly accessed by userspace via DMA.
> 
> Fix by matching the initialization pattern used in hugetlb_no_page():
> - Zero the folio using folio_zero_user() which is optimized for huge pages
> - Mark it uptodate with folio_mark_uptodate()
> - Take hugetlb_fault_mutex before adding to page cache to prevent races
> 
> The folio_zero_user() change also fixes a potential security issue where
> uninitialized kernel memory could be disclosed to userspace through
> read() or mmap() operations on the memfd.
> 
> Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
> Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@vger.kernel.org
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

As David mentioned, we can drop the comment wrt. __folio_mark_uptodate.
As for the addr_hint in folio_zero_user, I do not think it makes a
difference in here.
AFAIK, it serves the purpose that subpages belong to the addr_hint will
be zeroed the latest to keep them in cache, but here it does not really
apply, so '0' should just work?

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

