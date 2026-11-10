Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAA2606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=li9W2jHU;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RTsnqhdh;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tovQQbFU;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Z1UIzdV2
Received: by kanga.kvack.org (Postfix)
	id D6C646B00EF; Tue, 10 Nov 2026 05:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFD46B05B0; Tue, 10 Nov 2026 05:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB70E6B05B1; Tue, 10 Nov 2026 05:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9071D6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:37:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3013A1A04E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:37:56 +0000 (UTC)
X-FDA: 85418858952.19.81CA3D8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE78CC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:37:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=li9W2jHU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RTsnqhdh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tovQQbFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z1UIzdV2;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794307074;
	b=EqVrIUF9fX0WO3+yiuTehfeS08SzIAbVdrQpm0NxGZcG8bGM+0DyMd4+6/4LI5Bdv8/VsC
	FGa4KnVF++3TWhwJE+dZyJ4rLg9UV8Ig2XUPqUXwyIHl+LmvxeY42AQOtl98PJtAdoMbto
	Y25QXCA62wEeeXB15SM/n5OMiZXV03k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=li9W2jHU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RTsnqhdh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tovQQbFU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z1UIzdV2;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794307074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlV+p7Ntb3+w27D9HU+z/TWwQDK7MyawCat5dRFi5NM=;
	b=aIsIZ2+c6g/iWdYxZIg9+AMMNCcylvKK9LUUpj4tndRE+pclSM5RJiy3bMYtAWVxbK3SAy
	LimQil2b9q1XqbH4SUaSKM8htHVa+612Bs728kNCfLTgoWAelUytryOQK2np/rMVj3//YR
	/lfifQRMzOOWGw6LngAU0Fw552wAuWk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E701D21D9F;
	Tue, 10 Nov 2026 10:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794307072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlV+p7Ntb3+w27D9HU+z/TWwQDK7MyawCat5dRFi5NM=;
	b=li9W2jHUQBd8RF/mnIdAvDFGeOiTFnpMBUfryhtYKGN+o/AboED3XJpT6teCcrfnBljg06
	VIMmX88Fmu9f4dJoEcCcB8uw3XAm+FJ8TKFBfOL25wXa04QWnGhgmdYoYzlR29eURCk+Sv
	Gx61YrQxgt2Bw4QvTvCK2Oj0lGykOxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794307072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlV+p7Ntb3+w27D9HU+z/TWwQDK7MyawCat5dRFi5NM=;
	b=RTsnqhdhTgKVgkdt2CCeVQ6GrHLrS/wKLyJEGkbvqXQYZQ8BcZY4hh3cif5ogfotYB2Z+D
	tiooSCRlFQZyCsDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794307071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlV+p7Ntb3+w27D9HU+z/TWwQDK7MyawCat5dRFi5NM=;
	b=tovQQbFU/F6wNXLEsnCezRZ9VBPvbjiXFYg/arT6r3gP1F0Ha7TVBbDTX0EmcF92VQaPN+
	eHCAl3qCl+XE8CjXLTpE7WPQnk5Xavez9V3lCqc1Roj5OaV+RLFBTd3gh62njXYPZl9+85
	sn4rnpsSmuRrK+DEpgVbPz+l4pu+B64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794307071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UlV+p7Ntb3+w27D9HU+z/TWwQDK7MyawCat5dRFi5NM=;
	b=Z1UIzdV28HX3HA/oFk93aVP0slCgu+1wQXXSLucK19h1jFXZRVVHKNky5zmkLo4HxAv82X
	zyNbKYs8l+AbThBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDF0A1339F;
	Tue, 10 Nov 2026 10:37:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZrdcJv/z8moPNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:37:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4FFCF22485; Tue, 10 Nov 2026 11:37:47 +0100 (CET)
Date: Tue, 10 Nov 2026 11:37:47 +0100
From: Jan Kara <jack@suse.cz>
To: Alireza Haddadi <alireza.haddadi@it.uu.se>
Cc: Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Message-ID: <vna2y3gpsdkntml6fzfvhf55vjbetoitnqv5bitfkh24gfecz6@iihzrvi2g2kf>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
 <gewwqi2kcu4nsitueyw2nd6g6eqjb3wqh4mks5lqcbkc6re4sn@eaqpgn2hxls5>
 <5310BD2F-6626-44C9-A156-3B985552030A@it.uu.se>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5310BD2F-6626-44C9-A156-3B985552030A@it.uu.se>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Stat-Signature: mgngtx4ez18ec6wznhzbmtb3gabr3e9f
X-Rspamd-Queue-Id: CE78CC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794307073-585638
X-HE-Meta: U2FsdGVkX19G7J2MUtMCy1zc0/ZiDjVaRjtPhEDs1cWvb78KC6fMloNB3ZYkSg5vAixBKGeVoYUNdMJk/T/7RomkSPDAyn0xFtl6iIsDzfFNQ411pN1k64bEgu+CjfODNU2/Hvtg7hyw8sy1QRVE+DIUmV/8iWP+habLiuDXGMmK/OeT/KQXcbtXmoXdD4HOrvLMBId4sl1zBCaKcf7guGwH0iopcK4fGd+A/LVf3bdfszRIv/sIbkEzs9GjEsbn6Z/s6zlfJa1y4olmC92St404yeYLq2ObvSviNeI+C64PWjY66Od/q1dPvs1JFsmdifDncllPDStjihoXPDg+5w7FuOeeQ/Sq/kPb1lYJ4NKj3/NS/hMMw/83PUjwRoKfqL87GYYEYdFgsJrYGxILjK4yzKROdptCjdCzMqPf0W5bhjcj7UYJM1aQUhe267oWLbcsjElHT3i6PNL5il1VHjDeE6UzpWHZonCH3iBjBuaVNz3aF5hJTSZBNd8QKrZNs34CRt3zGKJzNTlnYlIQxMdwtV3waN5y5kuvInJhAI3T0C+voD7tkzgsIXmqs3ay9IlNHaK3DGnK86T78dF9phO5gioTChKXmcd8AJ88P8L2VdFWOH7aEScuB0PJNMa7fOxr3Ke2RbWt/mM7FA6y5Bs1rLuigw7UAqfTvDFz1gnEr+LoYu6YJ6LtZOSGUGBfRQ8lzkwi+XiEh+n23lLM5D+yHQz1rVkBMzRHFxJVklh/cAbDGyWqYYEvUunAF4gyVbf0adrBK1WlBePR6bfD73JLB3vlNbjlffF4NwJxbjRQ+tQe1jFSr2sJFHqeAa/dYzkzRCu3LugQoWw+yGBAlHoA8lRZfEBaKpDTiUEpMS6w/bordAsY04oDLEXcFvQ0n1vHl0f+D8iDuijEVV7v2ma7QSFd8SdDL6OqgYi/NA2zAcTNW04MRStA+NJWE7zUwkMdXDAMHR6lVWC4VQA
 anSpeH4P
 eKQfYrenjxTEAZ2XBZEwPO+I+z5rChN7j7h7D5yTr2Zovk/90OZe1cmCG8oSyz0T3ZGDktB2bJeKkJoxdyYaN9j9JqGZ3aylfnoe1yA7ZKxN9upI0dx71k01lssLRNpN+wQVCSNHpo9bSD3nXUDFBqwT7TVBHy5phdahV/AWg+fG6BwMFdE2nOzMSP/ezw8Sep6xeTb9VM8T2bcfag3GOEuOkG9B6DsbDxNG/lTz7oBbgcsSNizVF1TiaP/x4FGR+wyRAKxg6ecDsguvBOJ1sJGZZksQzw7aXyUl49Tk8ld3yp91d0QW8Xp8WcQqOc0vMyQ/fcUChwlgNJ/TfXumHdEcbUQnAPCWtJIHAdF0A0wUBLdHR9Nr02KR3IbnPPELB1XhTpMRYf1jO5RBkE8r2bO1U+x8u56dslwVvGXgPPUI7JCscXMQ+ZXjK+OjS47lEwg64rRJYurfjfYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 09-11-26 20:23:29, Alireza Haddadi wrote:
> As Sashiko noticed, with a minimum folio order (large block size
> filesystems), the 2-page request ends up as a single folio with the
> mark on the faulting folio itself. That folio gets mapped in full on
> the retry, so the mark is never hit and the readahead does not
> restart there.
> 
> I checked it myself, and it's right. In v2 I'd read two minimum-size
> folios instead and mark the second one:
> 
> unsigned int nr = mapping_min_folio_nrpages(mapping);
> ra->size = 2 * nr;
> ra->async_size = nr;
> ra->order = mapping_min_folio_order(mapping);
> 
> With a minimum order of 0, this is the same as now. The cost stays the
> same in proportion: a miss that follows a cached page reads two
> minimum-size folios instead of one. I'll also test it on XFS with 16k
> blocks before sending v2. Would you be OK with me keeping your
> Reviewed-by for that, or would you rather look at v2 first?

Yes, I agree with this solution so feel free to keep my Reviewed-by.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

