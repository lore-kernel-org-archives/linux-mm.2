Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340E7C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309656B008A; Thu, 24 Sep 2026 06:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1056B0092; Thu, 24 Sep 2026 06:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0066B0093; Thu, 24 Sep 2026 06:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEA456B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:31:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE5561C23DD
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:31:29 +0000 (UTC)
X-FDA: 85248289098.15.7E64A7F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id A81362000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:31:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zNfNCSPZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vbDmVdxb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J74NF9iY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MsZq+Mkj;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790245887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=a8qqmh9Lte295m4reGCL977qABgOWk4xep+a2SFJQNKXlFydowPp5P9034qw/VAqil7WW+
	oFjvz7ZI0EtL71Flt/VuY0QHdyaroUU45LEiqCQ1SjpZMaXED6stJ7nAhTYLeXO1s51nig
	oPoqcDkEz5Q65fHEPsyxVua3Sx+DSh4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zNfNCSPZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vbDmVdxb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J74NF9iY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MsZq+Mkj;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790245887;
	b=spqNXBK3jTpulnzgpK5G1wsG1zif2ytdx0HsIawyJ0j5XKxrySX+Vs1JT3apuukYJOyQ/w
	17qnX6hyFD5atrAKMFxA9Rw5Y+A7/tjbG7jNd7O2CiaurQ/3F9UF/UWaE0YK2SvzPtdReb
	vsDOp93xHnBUiKwP8KxjmQ98YdQA2QA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 133AE200A5;
	Thu, 24 Sep 2026 10:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790245882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=zNfNCSPZP0SpkAQkGRLD6HgWA9MwVhUV9X1/tV5qkI692+o7URF7e4dX1uEAUZgtPMavcB
	if0P/jkGtttcVECmfFbHSvoOf378SoaaTzY4+pMPMHACCKXtDpos8V/GdzNYyxPaPTAwiA
	r2rvcdi0884Mn8BvWzj5nvEZ+aWwb1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790245882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=vbDmVdxbh0zA0K5bCCtx7id/XYCLqY//kwcvC6UvMdM2ZD6NKcR/f/mgtEvdcHaiDA2Gmp
	k+4ABwVHA2AGi/Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790245878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=J74NF9iYNLw5mH55CkajqTlC/paZFBur0mteL3FY5qDyKTMST/n33MfnOubGm+SOVG1YQT
	WSh/fD9eeAqwaB6KP9OcYTA//ZVw8+9f9M8B5N0C84XQOAPIqaYG57BpYlliPKTkIGrBf8
	gWAwgZCbloeUK8U6F9CA0hqLrsqvPlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790245878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=MsZq+MkjM49BpLXHFHghPNwTWPQf3HqylNIAJ3f859xZ/rnO8sgd1KkkGp0RBdVyu6tJMr
	e2rMfRaEY1qIUOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAC8413354;
	Thu, 24 Sep 2026 10:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zs+eLPX7tGqQZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:31:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 61D80A132E; Thu, 24 Sep 2026 12:31:17 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:31:17 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	bfoster@redhat.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Message-ID: <ui2ybt3gdynpxiwz6z56u6vedv6ic3npi726yndba3a3u7rqqj@owkcfnjnbvtn>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
 <5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com>
X-Rspamd-Action: no action
X-Stat-Signature: 48aydw15rcnxkce4zib51xititzwtyej
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A81362000A
X-HE-Tag: 1790245887-317065
X-HE-Meta: U2FsdGVkX1/lrK/KciROtUDtu+uQvZuRAHey5SdQqk3YJ0sdZ0xl98e8Cu26sPoSIa3VU0rWI5aBJOKpomOdkt8eKiyCgVaJnhjboXvtteeh7h5Cwo3MoBYf7mgyLavlmYebYkZX3e/txCAwOuJt8iV4KGs0MPrXZxFFFIt4G9sFan4njiGld10mFvjsu5KnPMMqrm9ZmidxLytm4KH1I/p1o6aHpiFQtnaIGblSr8JdfDHIUbrIb6v/ASvGs/FcjPQZ40MxrdNoD7WDDBo31RTaunigo6iUfvo1H4eAFB3OPj4bTcJjmZY9S8NXbQ5Mu17s4Qiq1kfbepZLuphhYTKLKD6STxAFVJcqRMLs2KkKuVGASwCcqXfsw5SndzfEllRHmdgB01ivMiQl7zQ+nvF27ELSGm6fvTFrnVD0tmFPkSP+KMOmXhvcOMSf/n4m4Kh26wBc7fUt8IEfOyoVRpLzl/Qb0YKIMdMseiK7gVrodE0R+9XSWjQgGCrPrxDdna7aFhO6APfvThXxAYBe2+Fuzwvb5cWUa56xNvCtKX8ILzr9aUhVxx8g0yIuogpvyAOp6czYux4wFBSCZYmj3O0bup5Z/5P09cJ3AScGrV+xkI/kuRwEOgAVXbfuKfoRvTe4tVuQaTBO96XewEFCxcDTuCD2AwLcKWKvz2JQz523rD3k7ghUq4U3Z/6Bk5iZrTLI1zD5eC4AjvdoUkZlFRUibfZSFPApbCulo7AMJnURcifub6SHUw1M8VO9ANL8Qlxme8/HQohOZ+ifeDnMi4D4HpYyShqHl1kQHMe91HnFcrhOG/qfz5bBI4ZKGflzWuFtsgKtjCqJTfQblercK4h9UXU+JcZ+KnuIk9BzzVx6icWCnqijj4bKZojffpO+nrtnzxuUkLW8sSjbtS7PPnRDuhf92kFb19SpVrdpw0nVhgRG5xRyGecD/IAOFNRiJN25TbWPTauMlxStdEU
 SPTtmIpb
 7iwwKx5qVPJ8fXa8LBb5+Gn6i8pcgRN/vfX6EHgpJgL0lmLNHWgBpYitMQHxB7wkWJNp+TMOwochkm6RryJ+n+9vA3ASgBxzTmDRkALuRq+VeUpOOZj4V7hdOhO4yLaRZ3QPcxO3dCzz9iwKV1bFXoEug+f4hLr4cBzNKq9XTcRUOdbziuLLvZWm5GjWDnyU/GqGygTqqQafLwNqQNzVBk6PN6L4KUojEg4uCwi6cZaZLPbq8rCivq2RvE+bydw45G1QewFZHnA6ylQ0zA7P5BBpxLYCz5TZF+ZfRi+dsRTnWwOBVxoRRwwJPPzBGSKYOZhEksU2H0KfOb0P4JJ461o5C+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 24-09-26 17:31:40, Zhang Yi wrote:
> > @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
> >  	else
> >  		end = (lend + 1) >> PAGE_SHIFT;
> >  
> > +	start = round_up(start, min_nrpages);
> > +	if (end != (pgoff_t)-1)
> > +		end = round_down(end, min_nrpages);
> > +
> Hi, all
> 
> The sashiko pointed out an issue on this patch:
> 
> > [Severity: Critical]
> > Can this integer overflow on 32-bit architectures?
> >
> > In truncate_inode_pages_range(), pgoff_t is a 32-bit integer on 32-bit
> > systems. If a hole punch or truncate operation occurs at an offset near
> > MAX_LFS_FILESIZE, the start page index will be close to 0xFFFFFFFF.
> >
> > When min_nrpages > 1 (e.g., on filesystems supporting min_order > 0 like
> > Ext4 with bigalloc), rounding up this index wraps it to 0.
> >
> > Would this wrap-around cause the entire page cache for the file to be
> > truncated instead of just the intended tail, leading to data loss?
> 
> This is a pre-existing issue, and it is not specific to the truncate
> path.
> 
> On 32-bit systems, for a mapping with a non-zero minimum folio order,
> the last min_order-aligned block of a file of MAX_LFS_FILESIZE is also
> the last block of the page index space, so the folio covering it ends at
> or past the last representable page index.  All places that do offset
> calculations on such end folios carry an overflow risk, e.g.,
> folio_next_index() wraps to 0 for that folio, and the values derived
> from it are wrong.
> 
> For example, on a 32-bit environment I create an ext4 filesystem with a
> 16KB blocksize, where the maximum file size is 0xFFFFFFFF000
> (MAX_LFS_FILESIZE). If we run:
> 
>  xfs_io -f -c "pwrite -b 0x10000 0xFFFFFFFC000 0x3000" /mnt/foo
> 
> The last folio starts at 0xFFFFFFFC000, but its length is 0x4000,
> so calling folio_next_index() on it will overflow, leading to
> unpredictable errors.
> 
> 
> I think the root cause is that sb->s_maxbytes is set to
> MAX_LFS_FILESIZE, which on 32-bit is (loff_t)ULONG_MAX << PAGE_SHIFT.  A
> folio is at least min_order pages and min_order aligned, so the file
> must have at most ULONG_MAX + 1 - (1 << min_order) pages for the last
> folio's next index to stay representable.
> 
> I suppose filesystems that use a non-zero minimum folio order should cap
> sb->s_maxbytes instead of using MAX_LFS_FILESIZE directly, something
> like this:
> 
> static inline loff_t max_lfs_filesize(unsigned int min_order)
> {
> #if BITS_PER_LONG == 32
> 	return ((loff_t)ULONG_MAX + 1 - (1UL << min_order)) << PAGE_SHIFT;
> #else
>     return MAX_LFS_FILESIZE;
> #endif
> }
> 
> Any thoughts?

Yeah, I guess it makes sense.

> Besides, I understand that since this is a pre-existing issue, it
> shouldn't block the merging of this series?

Right, I don't think this belongs to this patchset.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

