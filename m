Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E786A606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/EKTTkr
Received: by kanga.kvack.org (Postfix)
	id 1CD966B05E0; Tue, 17 Nov 2026 08:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DA46B05E1; Tue, 17 Nov 2026 08:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C066B05E2; Tue, 17 Nov 2026 08:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D51E76B05E0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:08:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B70BA711F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:08:34 +0000 (UTC)
X-FDA: 85444640148.27.3C2351B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D288440017
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:08:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/EKTTkr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS0imCMGjfHQIl7YcMlSSRR5WwouJwY7rnnH2z0iY9k=;
	b=gejlk3cBufXddhIcDAlOC4TiEcgNKzGLpzZib1/yrx4j92/WtRrADkg5Q5wo0UYPJdfTRr
	TMa3OItEgvOlCB50EnE8t/5BF9/YBJH8ilyFQiwM52wFMbANzNR6gekUONfrUzyS2wwVOa
	TpBVYlgKOUkUOu8JEFmtVRBoeF2RW4c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920913;
	b=QIlJoEi8qMzBzbG2sVpXa5VFXKom1aHEdO4lOlQ+2DfGZ47rmBw9kJuS99HKbtrWmMxiRf
	/YXpNlEYwzNjn6iKgOHH0d2NvfXItLKITrKsSNxQwLEJNb8RPw6R9fJo6yhq5FXRvtBQIF
	dTIZZdvxDmTXEnydwbu5p5bHdITGvDM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X/EKTTkr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1659340416;
	Tue, 17 Nov 2026 13:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA861F000C5;
	Tue, 17 Nov 2026 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920912;
	bh=BS0imCMGjfHQIl7YcMlSSRR5WwouJwY7rnnH2z0iY9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X/EKTTkrhL7VBc+MAtvhnoiN6TlDDymKZP3H635lhyaJgXZPXq+CGFoCJaYsQeErf
	 n3rH0EVLDsvvQA8N1q/GAMK75x8van3jVyPbUSImS8uutMMlB4oQbgD0Y9uw8VjkZU
	 uPIG/3VvO19OnQn5StEm9+ThFHK5ZQkWsFAn3Ecz3ZgxTg5Ck0p5om26ccLjDsESJQ
	 RvbUZ9QWTglB1cpSYnGDBxd0FAA6LWYxmBIVNo79dRHflXW3SHth55c7/sr/JaebYl
	 tgwXWbE0fJj8Ls1x+6B/ycBHC+Tl8CyyLn9bAzgksVp11MM69PmicD7KGPFMrZRgFP
	 Md+FWgg1UZ6IA==
Date: Tue, 17 Nov 2026 15:08:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
Message-ID: <avxRyt00VGvWlKea@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
 <545cec68-2444-4dcd-987d-cea05ffe3362-agordeev@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545cec68-2444-4dcd-987d-cea05ffe3362-agordeev@linux.ibm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D288440017
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kajmqyn3io9us7799y9hp75j83omr6b4
X-Rspam-User: 
X-HE-Tag: 1794920912-149856
X-HE-Meta: U2FsdGVkX18Ifx/m+N5m/X/yCPu/7+jJhG9YVimF7HhXUGBsWkOVA8g6bnfVoV+UwmNjplt23kXUEIapMDjvZsan5kmSWvcUeENbKdAVTeV92B9oOm+8xW8JsHXtouLhk1cS323PfmKKkmiVapIUxxtgdVK6MAxLAy2l790NJYsy0x5j+oNkOMZJtlN212FoLxjtYgpWkQzLxY06f+t023i+V2Sgct4QF8+eOPRotjtER7Ir9Eg5yQwiizVKWjrhjnVHuEa7/5DlIWks2lEv/IUO/RaoK0U0S1pP539+ZG+V3RG0wkEJuHQtecgKAOp7TUL25wVQpml7nKKP0/7Uw7YOjZ97pOlGN0g/ngL3omfCyjRaRjXhp6Y68e3R+dg5Ux0jhLtU/XiasDbHzMqLqHbVb9xmqtC5J036rx12O0+2uDlQd4iMGgu94k6KdLS6xeY/wx1hj+/MipgIOZb8mIxd5H2GecDm8wUPFkcd5zj9C+1urzE7W6VvI61hmtGGxwFZWDe4Z35HhsT5rhZlfIeFE5xTUiI12dJuT5fN6UiRnhm8+9RTSUL5r6vw7pXvgKguFe+ql81+GDk3fuOoYkx6W/J1Wy+TJElWKLi+r+qXSv1nXtwNfqJEI9JRl+aVLALm7bBfi+EEtFtTsD22dK4YJOJ+QTESN4HQScZp7UJEaPL4oHmg1I+twyOhKO0NHem3aKHcqQ6Z4+rIeAADa2H6DGYCxo1zUWpu3ZfXxkfdvW3bqZLxUNDLDNfgnYZkc5bOBiPfw6PSVfakNR/N+KCZhz6w0AcSN+oJUZESCKizOl/bJ36R7ubhU1FhspgeZQtbY8NBfk2ceqTUIRGzwOfNTkJ/N29zJaWTLnoeVjV28MMqcfdNZoufmgQhRNk3qQf9OPA6hlfD9fR3Pgz+YqJ7E8vGf+dR9tCe1OzgLCecRxoLDbdvhvd4DgeqIt1xpzP3Ir/1zidpt/ZDuZm
 nR/M0cEa
 y9zdeBk4i5YQe9/QiNBbM/yjHhv2/dQz9L9yug9n8oy+QuayMNbp6ErTWtun2RtR/WL/+ceUW7oJWrDbz1pDZI2NjzkmYgwx9basuXOYEj5RHKb2kDTieBXnAfRACbyUqt46HJaIa8k3j7IDfMPQz3AUEqLbCuHKpZ9gFVSLY9zghPMyg983VWn2YhYYQyjkf5V2ou5ASWsv86zHMvpUKP43yMkIdDIAuVwwzwL/9juB6lFTnGn0rpUpz0SRAuMWJ7EnVNvYo8p+m3YRv9Zff6C8znHUsyupdF4fBX0B271t9o6dGJHThzUshhlWRmsd/u9AJRcEIyyfbawM8JylOuPXsDlYIzBPwiqlI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:12:56PM +0100, Alexander Gordeev wrote:
> On Sun, Nov 08, 2026 at 10:58:41AM +0200, Mike Rapoport (Microsoft) wrote:
> > _sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
> > allocate the SCCBs used to read the CPU information, to configure a
> > channel path and to read the channel path information.
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
> > While on it, allocate only the amount of memory the SCCB actually
> > requires in _sclp_get_core_info() rather than rounding it up to the next
> > power of two.
> 
> This hints that the SCCB size is less than PAGE_SIZE, which is not the case.
> 
> > An SCCB must be page aligned and kmalloc() guarantees that
> > the alignment of an allocation is at least its largest power of two
> > divisor, so the extended SCCB is still page aligned.
> 
> This implies that the slab size path was taken, which is also not
> the case. Yes, the result is still aligned for PAGE_SIZE, but for
> a different reason ;)
> 
> I would suggest removing this whole paragraph. I can do it if you agree.

I'm sending v2 anyway, will drop it :)
 
> > Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
> > and free_page[s]() with kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  drivers/s390/char/sclp_cmd.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
> > index 1dc93d945be6f..6aaf1f6a3633f 100644
> > --- a/drivers/s390/char/sclp_cmd.c
> > +++ b/drivers/s390/char/sclp_cmd.c
> > @@ -102,7 +102,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
> >  		return -EOPNOTSUPP;
> >  
> >  	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
> > -	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
> > +	sccb = kzalloc(length, GFP_KERNEL | GFP_DMA);
> >  	if (!sccb)
> >  		return -ENOMEM;
> >  	sccb->header.length = length;
> > @@ -119,7 +119,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
> >  	}
> >  	sclp_fill_core_info(info, sccb);
> >  out:
> > -	free_pages((unsigned long)sccb, get_order(length));
> > +	kfree(sccb);
> >  	return rc;
> >  }
> >  
> > @@ -173,7 +173,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
> >  
> >  	if (!SCLP_HAS_CHP_RECONFIG)
> >  		return -EOPNOTSUPP;
> > -	sccb = (struct chp_cfg_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
> > +	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
> >  	if (!sccb)
> >  		return -ENOMEM;
> >  	sccb->header.length = sizeof(*sccb);
> > @@ -193,7 +193,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
> >  		break;
> >  	}
> >  out:
> > -	free_page((unsigned long)sccb);
> > +	kfree(sccb);
> >  	return rc;
> >  }
> >  
> > @@ -236,7 +236,7 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
> >  
> >  	if (!SCLP_HAS_CHP_INFO)
> >  		return -EOPNOTSUPP;
> > -	sccb = (struct chp_info_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
> > +	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
> >  	if (!sccb)
> >  		return -ENOMEM;
> >  	sccb->header.length = sizeof(*sccb);
> > @@ -253,6 +253,6 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
> >  	memcpy(info->standby, sccb->standby, SCLP_CHP_INFO_MASK_SIZE);
> >  	memcpy(info->configured, sccb->configured, SCLP_CHP_INFO_MASK_SIZE);
> >  out:
> > -	free_page((unsigned long)sccb);
> > +	kfree(sccb);
> >  	return rc;
> >  }
> > 
> > -- 
> > 2.53.0
> > 

-- 
Sincerely yours,
Mike.

