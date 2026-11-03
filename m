Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C486606EE80
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=d7+X/pS0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ASgtdplE;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=d7+X/pS0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ASgtdplE
Received: by kanga.kvack.org (Postfix)
	id 7C8DE6B05B3; Tue,  3 Nov 2026 06:38:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778FC6B05B5; Tue,  3 Nov 2026 06:38:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668EC6B05BF; Tue,  3 Nov 2026 06:38:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486F76B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:38:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB693403D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:38:14 +0000 (UTC)
X-FDA: 85393609308.05.8B4A2F9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE48D20003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:38:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d7+X/pS0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASgtdplE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d7+X/pS0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASgtdplE;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705892;
	b=aSj9GeiTvIR3k5na/TpiSVGmfZqx9WpaL6ogv/sYi70N25lDSz9Sk8Kab4WYpXwXc/w98Z
	ap+nztKlAcFYaprQ2uran3KsP92xU18cymtcwt8t+Zt0yeSeFgKBclzffb3kUOEJtQJe+f
	5DQ6PInjd7/OryXOLLxpEVoCHOqQF8g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d7+X/pS0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASgtdplE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="d7+X/pS0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASgtdplE;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCnYm9/ITbnI5evM1y8CyeToRvjgbq+ddnA4xUblF4s=;
	b=iMUDbdksWjka7V7X+2BQK/FJ2d4xzKjP8+zRknFiF7oB6iHiDA7G0+TklvAjOogibrDqWf
	ZTKqssXGA2oVKmiq6Eoz9BlmdTYBpJpRoo8UniIFLS4T33LH6+C0Zzf/e+itQbcoEB6HH7
	Q/5LqgJEa9JHIcuTro2rhJAAnRUIc+M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F5C3228F4;
	Tue,  3 Nov 2026 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCnYm9/ITbnI5evM1y8CyeToRvjgbq+ddnA4xUblF4s=;
	b=d7+X/pS0CC9M+uSAVvmhRjU68AW0lbWddSwJL2mxwIdzVkHOuuMhONLRy1ZTqe2Xwjqz9a
	As2MreadASrACnGsRvr0TP4vjdXpjcwjHCrzKf2m27LlEXVatRjxvOCyujOFsDNa+dmP+s
	BVdfTmcGIjZfCjaVIK/JfT929mNoKVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCnYm9/ITbnI5evM1y8CyeToRvjgbq+ddnA4xUblF4s=;
	b=ASgtdplEe74VqtPmNh2CaiNyAur8jpniosj0dgN2wrjhFXtxd6hEtZd68jRvDNcPGL9peR
	sf1CZbbLpIIqcGDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCnYm9/ITbnI5evM1y8CyeToRvjgbq+ddnA4xUblF4s=;
	b=d7+X/pS0CC9M+uSAVvmhRjU68AW0lbWddSwJL2mxwIdzVkHOuuMhONLRy1ZTqe2Xwjqz9a
	As2MreadASrACnGsRvr0TP4vjdXpjcwjHCrzKf2m27LlEXVatRjxvOCyujOFsDNa+dmP+s
	BVdfTmcGIjZfCjaVIK/JfT929mNoKVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCnYm9/ITbnI5evM1y8CyeToRvjgbq+ddnA4xUblF4s=;
	b=ASgtdplEe74VqtPmNh2CaiNyAur8jpniosj0dgN2wrjhFXtxd6hEtZd68jRvDNcPGL9peR
	sf1CZbbLpIIqcGDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E37E134B8;
	Tue,  3 Nov 2026 11:38:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kVzeDKPH6Wp+TAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 11:38:11 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E7C47B233; Tue, 03 Nov 2026 12:38:06 +0100 (CET)
Date: Tue, 3 Nov 2026 12:38:06 +0100
From: Jan Kara <jack@suse.cz>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Hungyu Lin <dennylin0707@gmail.com>, 
	willy@infradead.org, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Message-ID: <vsuiiidzwh7x2ipjgurdygwebkib6yiisdbucjg5o5eb3wokqk@a2cjfenlo3nx>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation>
 <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
 <at-XtWBQg3jv3H8Z@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at-XtWBQg3jv3H8Z@thinkstation>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: co9r9xqz91dw6uf45xgdqn3oq66goqaq
X-Rspamd-Queue-Id: DE48D20003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793705893-930969
X-HE-Meta: U2FsdGVkX19LIymbgwiL1iHmKJ+F1w8kYXwRHWe8BM0IGkrCnEXIqk9tHLKfvU83rkEFFS42RZerp5l37vvV912zBYJFYKyC0R/8iCYXDj/9VDE/a1ckJHGBIT5rJVlTCbS7GshjrQL9GMdlrFBRBisb9w8SkqnjgVoQkFbu7iITq8od5qmc+76GVcTEfblX+BArKUN7dsATkSk22qLON7C2JcYgKnX1/9CU1pmhIi4elLgHo5XV/8gPFiw1eV0+8bkkiSRioPUyOC2V2cM8U8gy867z1iaEKpRnrEFzIwASx7r44jGc8zyPSkwyME+prYBEzl1zIX34I2AtFgpLTCAcY6HAZ/DALehDnxk09fsqlpqpSeVKULt6X1+PJDbeK6pMmXnkP5kzF41ImDZV264/kJZtgwAqjOZBgDUBQJbkVU9InaWcCBe1Wvyd/lkanm0LZ+xIA/FFCVmjqsqXa0lZB9mAkw5nFTUEdqFPydJvEmbOHAfe+CGkP1+QTkFqlOCqnDUQc4Noe3d88tAV/i2IxSHQScUjzTwguVhgj/8VmFj0Hp9CXCrdo9p4i1raTYV9HuNVSmDzC6wNGTZu9FhkFQyThEGl8Uk+042UBAWczJoebT9tmecDVbCeiWHvzaGiNlBOm5XDAmXys46B71r7+XoO6d6ogMMnJXYXBY1W9hlETQ+tlfsjyxhhUbirGLW6Rld4Y/xWUO0cqZYABuFtxwI5+YxcZawIbRYYVCeJmFXJhty1cNRR3bRz63skwv3vVIcBGWr8RuUP2VdA/h7ZivOHUXFKXSRVzUTvsZvHyExcbsXQHVxJoV2paXJ9+qQUgug6gIbFCWJzP8ncVSYxoADQc4ZvthmxTRMYW941opb6xSweu256IXYnMlq9tKJ8wRv4gYtRK0Z6RV8PvyUoFbsY4bjPeqnNIyRTLYtbiUJmRtLAI51SfpQRgIL4GWzn614SoYOAAy+nkDm
 SBtziDl3
 BgOGv6S7sAn9nf48VG4/L640A2/zUkYc8ZyYGtJCzfiyGI7q4H8gJ6De33ov5GDli8s79z/OB4QTl8dZnCUns0yPFiu8Ui5tYjKOVHT+jBO+0WKAG59iWxiJV3/MBfAQ09PnHYpzUl4bWC383iXwSWYnUcZdeZs/ASKcCuE0M+kqi6GfACR7FFmBUAsVp4bqTVhtPeOOH1O8iOf0hGI7TLHZWv8L3U1n/kSyRLkjQU1dkMi69amgAbOvfrsgShecetbQBWMFEK6lvJhUU5X1xWX41kNPo+cjyVTMRCJ88BHBV83YOvyXEqe9ifNvnVAZRh9RREN3PS69t4Cnn0B11C8+EWa46Utf5vTQmoYza8hPePMTSHPmBvN4tuP89nI7fGhoK77fcmmzttNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 18:18:39, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 04:48:58PM +0100, Jan Kara wrote:
> > On Mon 26-10-26 15:34:08, Kiryl Shutsemau wrote:
> > > On Sun, Oct 25, 2026 at 04:46:19PM +0000, Hungyu Lin wrote:
> > > > shmem_write_end() advances i_size to pos + copied even when copied is
> > > > zero. A buffered write past EOF can therefore extend a tmpfs file
> > > > without writing any data.
> > > 
> > > + willy, jack, fsdevel.
> > > 
> > > This doesn't seem to be tmpfs-specific, right? I see the same with ext4.
> > > 
> > > simple_write_end() and generic_write_end() check pos + copied the same
> > > way, so filesystems that use them through generic_perform_write() are
> > > affected too.
> > > 
> > > It makes me think maybe generic_perform_write() is the right place to
> > > fix it. Hm?
> > 
> > Well, that would be nice. But how'd you like to do that? i_size update is
> > the responsibility of ->write_end and we have to call ->write_end if copied
> > == 0 so that is undoes what ->write_begin has prepared.
> 
> Hm.
> 
> A zero-length copy only moves i_size if the write starts beyond EOF.
> So we can bring the prefault back just for that case, before
> ->write_begin():
> 
>         if (unlikely(pos > i_size_read(mapping->host)) &&
>             fault_in_iov_iter_readable(i, bytes) == bytes) {
>                 status = -EFAULT;
>                 break;
>         }
> 
> Overwrites and appends keep skipping the prefault. It is racy against
> a concurrent munmap(), as it was before 665575cff098, but that is
> userspace racing with itself.
> 
> The per-filesystem alternative is a 'copied &&' in every ->write_end.
> 
> And generic_write_end() cannot take it as is: generic_cont_expand_simple()
> relies on a zero-length ->write_end() extending i_size. So we need some
> replacement.

Yeah, I actually like this. Good idea.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

