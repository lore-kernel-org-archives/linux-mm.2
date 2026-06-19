Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEDECD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17446B0088; Fri, 19 Jun 2026 13:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6B06B008A; Fri, 19 Jun 2026 13:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B69C6B008C; Fri, 19 Jun 2026 13:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 601216B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:18:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3AFCC2234
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:18:26 +0000 (UTC)
X-FDA: 84897321012.25.9841EE9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ADA21C000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:18:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uWBRj2KH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xEFirPK+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmI8JyI5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QbBLgmTW;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781889504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oqPpewONjUG7ValzHPKgr56a2oPjvYPPkirjUicRP8=;
	b=ifQwS6tZ21Hv7soagP/WwSXETUgrBng7HDbmE7MdEBU1QAIXoFizS0vB64WID7aNQYILQY
	ovy8M8Uut+q7BhjGSFjqXW1+455El41mbIY0hF92iuKHtsB2i2ugGkaWyauGiUZUkHbQ+q
	ggjOTnZ9kM2LHb1Fy0OoSd4dws/u5cU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uWBRj2KH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xEFirPK+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmI8JyI5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QbBLgmTW;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781889504;
	b=Sdd8RocPXBIyHJ/wVZR+BMeJNZbc9wxHTY/SiWcH49XHzpapuEJCGqm8+ITEsuQMY4Av41
	RGIaBUFrlMSJsiEwQIXEyk06udRuqJ2ExYjEji1i4PG9QdFAx1XK1YqutxPdKDWH7dOnK+
	jgW7VmK3cLyRZXpp6pKxsaoJKHNkanA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD4A26DA90;
	Fri, 19 Jun 2026 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781889503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1oqPpewONjUG7ValzHPKgr56a2oPjvYPPkirjUicRP8=;
	b=uWBRj2KHeH/VdEln9lE0zJGzrD3Rsjo2qvigFa9RJFnl3W0mRwK4kHc3Aa4fX9C/6aROEi
	GjxjptELaUhb659lHo45VA5bYewDgjlD4ZYprKPlaMHtAA+lzKu/EcvqXnAiERLFLI8pBc
	qcRPSy5OUQZuGPoDSw+kyY/ubczq9uM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781889503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1oqPpewONjUG7ValzHPKgr56a2oPjvYPPkirjUicRP8=;
	b=xEFirPK+ac4gMVnxt0HjyAp0+gUgMbnxLCEgB3ZL1GcHkT/qLmhZVSXltHHsVlPM01+qLY
	bNL+Wqdk0tiVMmBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781889502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1oqPpewONjUG7ValzHPKgr56a2oPjvYPPkirjUicRP8=;
	b=VmI8JyI5c3QN5t0j/8lz0RSLO0cxyyWmDioT/AKIdNasMGrwbKJsMCK3AOEoxyoTWyEnna
	91e2cXEKw91DHAwP5fCdy3gxrbxJs1eS20vP8jwRfvEa7sBhk5q2qJidk/AQLAZ6i/Ag9R
	kHPimRnB9ZRpX7ShT9AUe6OKFW88UYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781889502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1oqPpewONjUG7ValzHPKgr56a2oPjvYPPkirjUicRP8=;
	b=QbBLgmTWa6XvIUrZCT7X88SCJxb2z81dSoArM9vgo36gCqu01H8Zr7XmIH+pdSMIBAqvEK
	HgEIagkEhphrdwCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7620779A8;
	Fri, 19 Jun 2026 17:18:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wWAvNd15NWqnQgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 19 Jun 2026 17:18:21 +0000
Date: Fri, 19 Jun 2026 18:18:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajV49Fyogfa6aIjy@pedro-suse>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajV0TbwEyaKMzoa6@lucifer>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8ADA21C000C
X-Stat-Signature: 31bycpeg4ziagk6xr3nxpbwy9shouord
X-Rspam-User: 
X-HE-Tag: 1781889504-265095
X-HE-Meta: U2FsdGVkX19htUWwIlop0sm4nb+cEThiF5s1r2znBN66geE2CO4DAKd/VV3RiZi8y4pc+6+zvJM6jljC903uqRQ4IO63YFjTnnwLRLarc+VEw8dV5Gy/8BA1ReljegxJxK8JSJohTP8bsFlG08fH/3O94gf1s7MfMkslW/0X04nzVGe95tY6ZyTh/zJHP8bH4P+be81lWDvWhqFbzXzh/r73AFRzn2Q4M7rFoXEH14062xt4Sd/QoUZj8eik8y55C95hMhvuecxwr1Ujc0dHk/xg3tQnhKa+4MnNNUUJPn6WgyjY8YQwc5V3+9mgrRz7ZYsSs4XycWo+01nvDu23qsWlD5SVlmTveikInElnZpMh9qr+1OyQyxv8Mqgu1BKFH7QFfafTdFRMx4MBvmJ1siSQaN3+wVfvKey9bUpLdZE9VjvQ9MDoTCJJnDFWcrwI097Y/pMu5i4lRvwM+DZqBXgXAfyD7VNwcpuA3DEqDGrYM7HN4x/LoSsxOpErGoAX3XmWAXWgtprQmZQm21OimNX5s3UrpbY0mStXlkHLVaEUDsHfnHByG0M9X4rW/5j8k4Sq9J9NqdeVbB4SPEGunlexKQC7z+p3kaPYOcDrD5J+TA3/hDZ2K9hJJoSO4OSgNe0IIVvUI4wKOTNWpgjLQC6OxE8oSVAWp9JixWcHespA5cU+WI2mtL4nWzGpetRPtRyET2MviFlvD3LyXpoBO0bMueo9Ra5gSzVP71ahyBuovk3bGn2/JjmLhfksXJwTUOaPCtLPckWGifKh22fLN53RXU7OvxFXyZ8e/ytnxGXFy8mZWAaDHhJGbGS11xzmGKS8t1wMTCMKlhglUlxKlx7X7Mxa/5TeThwjufpFJrKLCWBqMtY8GhcRyF8Z8ilA5znMJzP4vGl4Z/z6t+thbKRhc5dxY6eRLcoT0fO9p73/33UJ/qviSGeWwIi79tNtDIym8Bl8FAl2oylOxSa
 SAVNhnks
 QNnNHffeIH9Z5+aWjHBVhi9KICcxQ/DK9C/LwxO9ygw2FbWjWvIKf8yAmwGtZ8USRTZ6sf9A/CNU5Aof8C+sbfPzUVisOTE40wz6WDPGqmssZU/ln/AVyY5XHrwFcNyv/Rfy8y2ePsXuJNllUmZRNrrXZPJITNHbSW+1PXwz+cDDXSvtxaNllGNJz5WtuKln617Wiymh108DRRpDUhqeHDi/il9MxdboL1O8Uoy6nXCOG9ROL3XyGo3rwXtuAGdkylEm3o8DiM79oUUo/28Oijw8nyK+zeZjsq9QtmBpwRtbCFD+v0F/lNU6N21V197rhYYPy9YMz9oYEP1hJt/YVzIyJUghPygVkcTrmv+sJ+6gTTLJELOUpkJUFuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 06:07:30PM +0100, Lorenzo Stoakes wrote:
> +cc Suren, Pedro, David - I messed up the cc on this patch.
> 
> On Fri, Jun 19, 2026 at 05:52:38PM +0100, Matthew Wilcox wrote:
> > On Fri, Jun 19, 2026 at 09:37:11AM -0700, Andrew Morton wrote:
> > > On Fri, 19 Jun 2026 12:28:51 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> > >
> > > > This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> > > >
> > > > This patch caused a significant performance regression, so revert it, and
> > > > we can determine whether the approach is sensible or not moving forwards,
> > > > and if so how to avoid this.
> > > >
> > > > There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> > > > PG_readahead on EOF"), care was taken to ensure that the revert retained the
> > > > behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> > > > filemap_fault readahead to VMA boundaries") only.
> > >
> > > I'm a little conflicted here.
> > >
> > > 7b32f64bc512 avoided readahead of "file pages outside the mapped
> > > region", which is clearly desirable (arguably a bug fix?) and we care
> 
> I wouldn't say it's a bug fix? The kernel has always done this with no reported
> bugs.
> 
> > > about performance of executable mappings.  Whereas it isn't clear that
> > > we care about whatever the heck that test case was doing.
> > >
> > > IOW, the revert might make the kernel worse, overall.
> > >
> > > If someone plans to get down and analyse that test case then come up
> > > with a new version of 7b32f64bc512 then OK.  Is there such a person?
> > >
> > > I'll park the revert in mm-unstable for now, but would prefer not to
> > > rush it in until we better understand what's going on with that test
> > > case and what can be done to address it.
> 
> As Willy points out [0], we've identified that it's a real usecase that we're
> regressing.
> 
> There's likely others too in the real world.

Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
pattern may come up time and time again for people doing chunked mmap
reads. I think we need to take a closer look at this change.
> 
> This approach has also not been without debate in the past (see [1]), I think
> this patch slipped under the radar on that front a bit.

Yeah, sadly it seems like the patch _may_ need a rather substantial rework :|
So I would err on the side of caution for now and revert it as well.

-- 
Pedro

