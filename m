Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE894CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2A36B008A; Mon, 25 May 2026 13:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9D06B008C; Mon, 25 May 2026 13:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206FD6B0093; Mon, 25 May 2026 13:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1171F6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:21:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D58921C0C4E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:21:39 +0000 (UTC)
X-FDA: 84806609118.19.B97F409
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9B9240008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:21:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X4csjO/w";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
	b=FoasmBCz3I4D6CJVe8dSVR6CtKYySHXq+kHgk/njfb8qip1HGaAuunCsMfUgPwOejFcCPr
	dIf06Zwzswuxj0YnJp5jEIpi19gat/Y6fLRmzeOnNu5KsF9QTwBAiPlzq5lFpg8hM1JfsK
	EHZvQeT4AJ01Fq3U4jfz/t05EmCm0vg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X4csjO/w";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729698; a=rsa-sha256;
	cv=none;
	b=YBg0GSr5GJcybUsh+1d79M01gooZjF4XiRqJfCjrwQJhOq8U08d1I6zIQqdr4xACYX7udp
	D83hBpAIG+nM3pHsrD0WsRPRN+Yxk7dQrUKGeHN/eZyZ/bLxc6EzgKjL5nhyeHzHAF/bfM
	0Y0zOUO0SzxQooHzHddL7IT1bnNHHjM=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48d146705b4so103170115e9.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 10:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779729696; x=1780334496; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=X4csjO/w6zw0YBcbI+8q9JtO4mH2lvcuWFlrxsfuWMgLQvOjs3VhBCWwVUnRHmij26
         LtdhCLI9aRyxnEThagcOm8BJ++A5ql3/lG1ekEoN5KYTA2jbuqpQkjQbl9EKr10iW2bV
         t+ZwDwktyhMPa1tTbSXWpDSm+/iAmtgEQGllJaVNkIoq6Xecr8q23BJAYrPpJFl9NqKz
         Cn10Q5NqFksCRbG74tzXJbLUyIwGJKmbgxLEFRtXJ/RgSsn/+KGU3/OSYbxXi63FeMq1
         E7FBuUC5S4tbg+3mgih/z8Mj/Ef2RUZgAn9FUEduHGzBBKdvaOnTf27Ib8holyJwGxUF
         3vyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779729696; x=1780334496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=Lz+5J+/HHkwXTqov9Bu4bD6alaou8RGGHaq2Zr2Q0nb3bJTzF+MP25swK+bb+3miKE
         Z9ytwULweE1lOCYY1zQt+/3zyb/ToXEH6/tnECXjNUc84v4EfW0UXUvgqorc5r3mYu+h
         lwi3JRrAUEV/Qj6668oYLzg66jje5mRKet2bnKoQcmZeVUu3LjsCLmP0kQFp7ilZXMWJ
         CDOOYtdNUlzAxR1S2vb6xYgCoO2tKc9hZoTQuab5ijXZZpvJJSKZe0mduqnjHpKXNgRm
         m3tf4Mh/nY8eYyJEdasVFQ54tD6GwI2meRR7/ryK2uzgC4OWdHFFmWA4who/FQypGK+L
         XUMw==
X-Forwarded-Encrypted: i=1; AFNElJ+YsdzHiLxnvl3lCFBS4emekcnSOGQ5K7IRF/ZX8fXLdApVSTFLi4HQURcf3q4TA/CIFj9X9XF+7Q==@kvack.org
X-Gm-Message-State: AOJu0Yz3D3Q/SdFpuWBCACQpwRv0sC6qK9piF5+1CTVajaruvx/gag0J
	JSiJP/jtkpfrSmxsTlI0IV1wKOGecLKeJmrfyC0HiETlLQaFHUCM+lfK
X-Gm-Gg: Acq92OHWhXPEpMGeIUwM3x4d0ArVtHflvWr/1Bt6Kl+6D/d3Oq/q3K8JI/0R9iaW/un
	1dNedKqvAwt9PYtup2ae7aXyJTrjR8PD8qjSQGNQ/BpTCwzWWmFmN04wxogMCRxcneGbOnbx58Z
	QPJVoKotuZWMlfvLEypnXq5EWCSJ0JENhOMH9BKd5gY8lmbYj9fEcbqYnotC1ZP9a/zIa69YHIq
	AxrM5PCxA1cD5v2jYR/JiCdKXqNkVTm2SriO+41V58vvTsrT4tkD4rbCpJQkIy9x8Qw++W7kIWr
	NY7ADaeyk46bUKUQilAlpJ/MCgjfCOOX19tmI4nBsIDB1mulU8oZJhl0ndX+wULFk0Qe2HadAGE
	Wvd4pObD3uc1dk4tkjNUTbL5F+WJiMYHdEyoW79lMsb66gT4ktsBsdE6XLOWvjoKzorItXL66Mg
	pF964pZwoOMzN8yCiS2GwxS3ulPV2OjxxdeNvlzR4J5W1Cryadedpw9Skld22Bj1Y6
X-Received: by 2002:a05:600c:83c6:b0:490:5872:e641 with SMTP id 5b1f17b1804b1-4905872e758mr158057335e9.18.1779729696288;
        Mon, 25 May 2026 10:21:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d63f8sm88577605e9.18.2026.05.25.10.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:21:35 -0700 (PDT)
Date: Mon, 25 May 2026 18:21:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Dave
 Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260525182134.04045610@pumpkin>
In-Reply-To: <2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9B9240008
X-Stat-Signature: xbnnd69qzeq5xzar4jkgtofycdxpuggs
X-Rspam-User: 
X-HE-Tag: 1779729697-645628
X-HE-Meta: U2FsdGVkX19hpb4KGhnb0Nxs0/l+EEYzAdBNYg13VFNgS+PTrjvQUeqzBD06h0l9fefOuqSVJLoW5WIT1Bthgl2UPLU6TU+V44YbIATPs8h7AiQ9bg+a+CFraSdFnbnHOjO/gwzUUqnxk0Vq/rhN8aQSHynHG57NkXR/hx+ko2f6vi0eu/eZaK32swV3lV2Azxumto8JEnoV2AbUW8OOAYUliCWkF/Dm7QQ9qCq7EQ3FlZoyGsRg5qB3SWYjgjm/vZmT3N6VTLbFpaeDQYIHkiWLuWGku7dXPSiOnN8QjQPwSQX4paV3E5EfGK87Cxh8FDOAF/YStQaR7kPblPoVMTqKODFAXF+eWQRg5VYSGTZirjJRPjeyEF0BtiP/4Gs5pdNhHXbqvpoD2n68TxensHlD7Xk1445GBPNGRlECFLVP8VLUhspcvCja3JSY13Ox0Rb54IARE/O00kEEPqWzRaVkIyW8IQlnuE3ne/7BZxekYovu0C1UQ5RUPX7HlYQ0vxqg1JT1ZucVAFPQUPHTanKl4wuX/HVGy/icV34JVS80G6EJEqZxK4TRnG9ECkQLWeKLSGWQ6apoT/WZ20fscLc1pblnGBE6OvcyJGIeu7SNQrZ3JT7taUPS4qEC58JTzLivx4jX+W1LqkzmKXc340nxjY83SI7qkT4pqPBwdknwMPe1FJBwY95XVTAHDOoOadQAgw+mRSx/2jQuxaB8ovLIcFkBwDZswBPJikp3gg3RRorTm+Bhl3mLCDPzuxFKH2B4R3SjYbAF1nGyQ4xgM4JjpVKHwa1y6uTGJ7MRB8D6Gq0kU60Q6ECeWpMnnYwFp4dPR1M6T/W/YlzGSczE2nEvnNHd6GhRz6fqktNaJOAxIQn7Ph/EUPe2SR/N5pos+xudHRTPMYoKOYoTYyjetVxNPh/Vj3d3wTHBv48Pt8n20qvW7HCTblH34wIOTtzyAn5cVAnzcmdhbrsL9nL
 n9tNTgNC
 /6Cw7ptPAvvcH2ow/n5cD3w1iYVuTPbKCB8jcr+9995D3Pw/OiMBdBSQW5BQzWVIg9QCuF7CRQJ8N71U0gb6tqukZxgp8T6vo1Gvc2ZJrWxirJGk8GCiWocS2zmEAbQPJ8BaAwRSvK7968M32t40B1WiLko9twr/INM0hIpFitLrkym6KyxExCh65CKMJwqx+nMviC0TEkzzBj5vJrSUsPr5JGrgmUW2MfBH5B0zncw5qpKE7w+VvGy/x3xDBCSz/nMeSHWGdsHqDpnIgR85HXzSfhQxdz+fbGJt0sN4BGqVt5FA2Q2d7QYmsrKdPl5eJkP4yjCXJ6gBxRECXxbGitvQ6HZyypLwwH8tZMZkGNjVjS65/gvdW1QXT3Ky/eFw2cEGMAwXBFH61Jt5rz9VA4atFRRJeHP5ZoXye+Eblwa3fdE5+cbFslksc1CvAZNRX7PcBikdYgPhJWOohQA6heaiVa1bFPIyPkqmQaLOpQwf1DMnW9C3kwxSWTYcgdQgH8RCJNgdesGGwCHuHy0YaxydnuV3/sx8iVUUdo6G74JNw/GRUQCr788rTnXkcLnUxhSZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 18:17:04 +0200
Jan Kara <jack@suse.cz> wrote:

> On Sat 23-05-26 20:54:22, Mike Rapoport (Microsoft) wrote:
> > jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> > allocations larger than PAGE_SIZE.
> > But kmalloc() can handle such cases with essentially the same fallback.
> > 
> > Replace use of __get_free_pages() with kmalloc() and simplify
> > jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> > freed with kfree().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>  
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I'll just note that we allocate here fs block size large buffer so the same
> kind of allocator as we use for folios would be even better. But that's a
> different cleanup I guess.

Would kvalloc() be more appropriate here?
Does __get_free_pages() return physically contiguous memory?

-- David

> 
> 								Honza
> 
> > ---
> >  fs/jbd2/journal.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 4f397fcdb13c..1137b471e490 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -2784,7 +2784,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  	if (size < PAGE_SIZE)
> >  		ptr = kmem_cache_alloc(get_slab(size), flags);
> >  	else
> > -		ptr = (void *)__get_free_pages(flags, get_order(size));
> > +		ptr = kmalloc(size, flags);
> >  
> >  	/* Check alignment; SLUB has gotten this wrong in the past,
> >  	 * and this can lead to user data corruption! */
> > @@ -2795,10 +2795,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  
> >  void jbd2_free(void *ptr, size_t size)
> >  {
> > -	if (size < PAGE_SIZE)
> > -		kmem_cache_free(get_slab(size), ptr);
> > -	else
> > -		free_pages((unsigned long)ptr, get_order(size));
> > +	kfree(ptr);
> >  };
> >  
> >  /*
> > 
> > -- 
> > 2.53.0
> >   


