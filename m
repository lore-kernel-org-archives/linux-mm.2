Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E5C606A885
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBwzihIj
Received: by kanga.kvack.org (Postfix)
	id 4859F6B05B0; Tue, 17 Nov 2026 07:44:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436DD6B05B2; Tue, 17 Nov 2026 07:44:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CF06B05B3; Tue, 17 Nov 2026 07:44:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 099BF6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:44:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CD301203F7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:44:53 +0000 (UTC)
X-FDA: 85444580466.03.DF78580
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D4ABCA000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:44:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBwzihIj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w951ovg3w2Vsfylh3ccdzN6FDyrcXZTYdvPxHdlj9QY=;
	b=vuMqZAOgGS+FXRj7Ujp6qFbDCCd8K0zyuVVoWy9SEspuhp7XJIWaIC61O/scOJ9OAWds1o
	EM9ZW5kMpJmFOi9Lg2CM8LDvp/1mfaheIJcBYXEVggv6+GVBBs04uoPwdzjKSzpfO5qgVo
	L0PumEVmRh+mnn9vSWmHZvdRmUNNN8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919491;
	b=xuPjtobfEKF1rkHJm3aPD1TYEmsFa74DWQkZE3a84KplkuzAjCXOoiGb7oes/ehjUuL1gr
	g9ccR6r9OXXKYXqroQdFb8OVD8MNYtDNaFBHYrjkl+hmLeuKfk/RGVsZXyf6iB1TNMUJcC
	1NMDqUpqvEl0CZmQRUkAT63Bh8J+1As=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBwzihIj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 557FD63090;
	Tue, 17 Nov 2026 12:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9431F000C4;
	Tue, 17 Nov 2026 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919491;
	bh=w951ovg3w2Vsfylh3ccdzN6FDyrcXZTYdvPxHdlj9QY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YBwzihIj9Shh17NXGQFTAEvDovM8+5df3UglwbIP4LhlDO72jMNqyPF0WYqaMxoE5
	 l5OzmmQDWs6bndpK3tF6rQ3lBt1zG/W2Vr4hLKm0xMK5Q3tuGJG1nrSyzrUsBppXaW
	 SGkiwCNY7E+RlbeAppGntzan52lAp84hU06UHxtci+ahGbgAeTdRtu45d26OC8ja6O
	 3fEkU5hLUtqSGA/TZDUwg1RsB15zGb0qJLGToS4ZL8Ufc4PY4HfNys3VnAcnlDfQwK
	 nJPevvKsk4LSoOAzEx/JixDM6Bfp0Lr62Bqpj8jf8A4v/ui+HRG2kw8vE7zZM/LEt8
	 9JwP4xNMylkVQ==
Date: Tue, 17 Nov 2026 14:44:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 5/5] s390/hmcdrv: Replace page allocator calls with
 k[mz]alloc()
Message-ID: <avxMOsbgkaC_kQA_@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-5-3db507722530@kernel.org>
 <20261116134656.125125Fdc-hca@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116134656.125125Fdc-hca@linux.ibm.com>
X-Stat-Signature: xwyehfd3gio7nfme4135ztw7tim7aeha
X-Rspam-User: 
X-Rspamd-Queue-Id: D4ABCA000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794919491-265529
X-HE-Meta: U2FsdGVkX1+v+NHa+MeWYtSfi16FJ9Da+NVxmL0mE0+gfMDjCx0flMAHHY9yhsZpdjdiuSgDRQEvOipHsNMl2D6Wbwvw0oywM9hgmtHzvnSXGULGudodfAQDNVTNAHlraE7UsGT+oURzGzlUx+ZKtiZrYV+Bq3o0zgHr6wElK0/hS/AXFhaWUJay749pmGs27OdV0GnYnujhy/KO30M/d5Fleglt6LrfAKAq4cwui9wvIwSFdXYmNIdMARiuSthf9R4gZzf439BsGvlLlNojXw6qo87jdZU83AugcR23lk2qTNM2ONnrFveeJgctEdv06vK2zpHDV6z94R1AYIX/zuDmsunwCd8GYKa9utPuMM8TjfzY/zB/tR0FhxDHFrWsqgjgaoGcDqg60DSWrWChAq1//3VarHU/+lQxiUUFZI0JYdto3VyuFym7OqSwWJUdClHoDMZz9vR52r7Zhri4AjwTkpNFAS8zgJQzWSSDkk1eYDwUO4T6DY/zbVmvvv4dgzfhaq1uQjUopaySg6TQM/fNosZVIx3jw+n70CEbR6lPGHT2XltfiD4ScT/7CWTP/TVHsorUfM2X2HVriweLnmLsGQEhk0niIRqfNAtF3PFO1dGyJryDAoan9wIumBjkT8IiE3FcTZIQ09Hirn0EU9+8bILrCwiwMXYcOlwUF2mAWfSHoisM8HE6pVgdAXEa1ji4ptzFjD6d4U/UGIs/8ekB3m9RukCKYBNg7HY4bsggXiFmd+4p8PKrQhG8yswOshZlhQZ5VUatYLyXcHla+2fBpI9mcbAqlMMxAwW+mA0YsMVkCXU91/SFSTohvTPw0GCiO6HljCxWPSz+1+LzMCNw7LKegw3RZfafN+gyVKd8opIqs/yOh3UmyO3Nx6rFJtoyYRUtLinI0TeuN5W10c5D1ETFFNb1J5xHztGo8c/p8jJgn+kDV9kBPEoav0sZFd/Td8/4clZIohnblPS
 caMAluUN
 LtoMwVyP4tiMjRWQgZL+nX0WXRU0bvZAYTLm5I8SOi+V5+VbNETMccM8SOFlhuRDryyQl/1q5NRfHGNkE0UBxWPpuhzCOL6hLFU5jdOrHGFTGq7j64cdesMiSvxKBd0zW+7xKqv/wjSMELCRi9s7ShxvPAco5hKJYUUnEAhwAL8TNRU9KD3gVobLcK3AWIN7aydJXUZV+7RZe5jZY0U+Ab9DyRC3lT0VB8LwvvQFBBgVX+PDauZZa2SOeOVx9NCZA4gV0suPDEWVAiBL1IKTsLlgu5cQRNap50UQcmWoYi8dlx4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 02:46:56PM +0100, Heiko Carstens wrote:
> On Sun, Nov 08, 2026 at 10:49:02AM +0200, Mike Rapoport (Microsoft) wrote:
> > diag_ftp_cmd() allocates the DIAGNOSE 0x2C4 parameter list used for HMC
> > file transfers under z/VM, hmcdrv_ftp_probe() and hmcdrv_ftp_cmd()
> > allocate the data buffers used for the transfers and
> > hmcdrv_cache_startup() allocates the buffer that caches the contents of
> > the last file read from the HMC drive.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > Replace use of get_zeroed_page() and __get_free_pages() with kzalloc()
> > and kmalloc() and free_page[s]() with kfree().
> > 
> > Round transfer and cache buffers up to a page for the required 4K
> > alignment, without rounding to a power-of-two number of pages. Reject
> > unsupported sizes before rounding.
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  drivers/s390/char/diag_ftp.c     |  5 +++--
> >  drivers/s390/char/hmcdrv_cache.c | 18 +++++++++---------
> >  drivers/s390/char/hmcdrv_ftp.c   | 14 +++++++-------
> >  3 files changed, 19 insertions(+), 18 deletions(-)
> 
> ...
> 
> >  int hmcdrv_cache_startup(size_t cachesize)
> >  {
> > +	if (cachesize > KMALLOC_MAX_SIZE)
> > +		return -ENOMEM;
> 
> What is the reason for this check? I can see that this seems to be a
> common pattern, however the buddy allocator would warn as well for
> allocations larger than MAX_PAGE_ORDER if I'm not mistaken.

Since cachesize is a module parameter there's a very corner case when it
could have value within a page of ULONG_MAX. Then round_up() wraps to 0 and
kmalloc(0) returns ZERO_SIZE_PTR rather than NULL and does not warn.

The module would load with a bogus cache instead of failing as it does now.

While it's really unlikely to happen in practice I'm sure Sashiko will be
unhappy without this check :)

> > +
> >  	if (cachesize > 0) { /* perform caching ? */
> > -		hmcdrv_cache_order = get_order(cachesize);
> > +		/* the buffer must be 4k aligned, hence round up to page size */
> >  		hmcdrv_cache_file.content =
> > -			(void *) __get_free_pages(GFP_KERNEL | GFP_DMA,
> > -						  hmcdrv_cache_order);
> > +			kmalloc(round_up(cachesize, PAGE_SIZE),
> > +				GFP_KERNEL | GFP_DMA);
> 
> ...and that check wasn't here before.
> 
> > diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
> > index 3312b2ac00a9d..e22789b532de2 100644
> > --- a/drivers/s390/char/hmcdrv_ftp.c
> > +++ b/drivers/s390/char/hmcdrv_ftp.c
> > @@ -238,16 +238,16 @@ EXPORT_SYMBOL(hmcdrv_ftp_probe);
> >  ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
> >  		       char __user *buf, size_t len)
> >  {
> > -	int order;
> > -
> >  	struct hmcdrv_ftp_cmdspec ftp = {.len = len, .ofs = offset};
> >  	ssize_t retlen = hmcdrv_ftp_parse(cmd, &ftp);
> >  
> >  	if (retlen)
> >  		return retlen;
> >  
> > -	order = get_order(ftp.len);
> > -	ftp.buf = (void *) __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> > +	if (!ftp.len || ftp.len > KMALLOC_MAX_SIZE)
> > +		return -ENOMEM;
> 
> Same here, and as far as I can tell the Sashiko finding seems to be
> valid as well, even though it looks to me as if this worked only by
> accident. Also, as far as I can see, the reported "delete" command is
> currently not used at all from the only existing user space
> application that I'm aware of. But let's not change this, please.

Sashiko is wrong about get_order(0) returning 0, it actually returns 52, so
__get_free_pages() returns NULL and we end up with -ENOMEM anyway :)

So it's either keep if (!ftp.len) and let it fail for "delete" like it does
today or have

	size = round_up(ftp.len, PAGE_SIZE) ? : PAGE_SIZE;

and allocate at least a page for ftp.len == 0.

What's your preference?

The ftp.len > KMALLOC_MAX_SIZE check seems bogus indeed.

-- 
Sincerely yours,
Mike.

