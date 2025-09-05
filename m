Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41E4CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6B18E000B; Fri,  5 Sep 2025 14:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE868E0001; Fri,  5 Sep 2025 14:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4AD8E000B; Fri,  5 Sep 2025 14:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC4B18E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:02:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9DDB1DCA32
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:42 +0000 (UTC)
X-FDA: 83855966964.17.0166EA9
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF1022004B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ala/+Qej";
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757095360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyvqbUDXebspKl35FIPJk0lFngkuMldmVpFc1O8R/zI=;
	b=PhMCt4XRQmY7mFGdxjG8QTAc6YEMRyEjxvkKUeMB6JO4C3RKuoX/JyJb4AdR9+sCqkfVVZ
	NBpkfeUl5qJP93I377FrOLVZwgc6txgNxhrp4O4ltfYaoO10a3ZpTfG8sJ1XpJ6/5eG5FQ
	xG3Y1tWyKRVCaRgy/Ll+wx8yoomJ6nI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ala/+Qej";
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757095360; a=rsa-sha256;
	cv=none;
	b=0QK9IAeKGlzRlh8iXvp0IP/mS6P/k4U33PWp7HHcPFbTD5CG2pWgBd4Njt0qoMy6MV1Ry4
	6xotPJCFfjC307MUU+KH9XWxTJL9VEXRYCo5g4oM338cXhMta98EBzpXLV/Bfu0tWKr1dg
	xD0mzp5GkoKrhH+FiR9BFDyumfe3hw0=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b520c9c291dso764946a12.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 11:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757095360; x=1757700160; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vyvqbUDXebspKl35FIPJk0lFngkuMldmVpFc1O8R/zI=;
        b=Ala/+QejW+yWG1fO8gShtN/pvEfAksPgHn4qs2gXMC6jwekSYLwGj7tsyuMxVOJNYb
         1JS2ZoJPgITpzDDO7Bj5bpxJNbU4rNTFSqHoi7qjWEOqswIFQSKfN+syvPcQq/vWlI5A
         0K3Is/azS8rNTZy4c+RdsSsgKqd1agi02silKmq1eHDlm79OIIgKlNw9AizWPCg1TgMB
         8991KX6XcN7fpJ2xALR9zI7dtcdohhWlqtWq/geyD8DbbF+OP8gBQ/BIzspxg6QodivO
         L1TJ8tAk2WD8bvdZwt7xuTWYxKbhmVrXb4qUj0GIhpjFuWZoH3RAoQGbyP9r7ming5U/
         f4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757095360; x=1757700160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyvqbUDXebspKl35FIPJk0lFngkuMldmVpFc1O8R/zI=;
        b=NSHCRB8ooKxtFGD2ahEGFxDYTivKoEIKIL209NH5zmMZfT+chiy8fGAikK24i5tTMX
         0DFKMfrCkkzYtHSiuMbKtVOLeq7fB7BzobvN6zRd4sTPo867cZZ75rt+oWvmCfPa0/Ds
         Nm4yq1jwS6U2pBxoQMySBHsaKEvxAlUpb91oKrFzM/y5WLhkRLIe3W7ywmfDtWprxXHA
         AKe6AlRjIYQuura991kUvhFQsbqmy59lIU1lzMqhQHr9x4wDk8cnuMlB57KYod4ekc6J
         a6K4WBUPuvGDARADAPCUdP0z0DiOOanbRU7nXwXI6Mv8JGfZEw2VT6hzqIpo1m4PfUZK
         K1Mg==
X-Gm-Message-State: AOJu0YzZEQqZJ62Oz/rEM8zRgRXGGnFvQ3CBbRGU9fJ3vjMkIVXLdxfd
	1bytQC6TUUETOeDWmed0wFQE3yNKk6wWEwtp23zmCtmRzEtfHEm7Db3i
X-Gm-Gg: ASbGncuzw8xS2OtPg0j6VxI7skifPBtUNJ5ui17AJI5+GcZrHj3hesWzFv5bcMMDsai
	6hFUoQwXQV4UEOXs9X65pV3swOpfzq3bcH74kdYn2Ip7QT34ebM4jiY9JfJf6oQuoQYjKxVNrF1
	aKGKRIsRQVYf54s4HdLRIuVLr/8jXuLLHAXPDrUfbF7BWlEY6jaV76C4ungquEUj6CyM1KaZCCF
	b76IWRlCtGtAbkXQZKI0wJff7ltDSyOzJHoFN5kpeJ1vJ5npAStccYiPtKMN/g6Ng6dqkCPZOId
	MbHG/t2AgFn3UFy4452x27Li6LBOE9smCBUMz1gufMf1N7eXVI2W9i7VqXpjozRirwSI1btVL0G
	33CasQNJ4lpLo+mKXpJSa95J9rjYkgGUbNYixVUGLxBdrOuEnUqL7NB0s3EHzBP6DcgUU2aN0Pb
	A=
X-Google-Smtp-Source: AGHT+IH4BIuCOkufR5zpdXWK9alIlYMnPti5eXH+01WmcFERf5EmF47R3LvTkLS7gssMCY0/Uh9xug==
X-Received: by 2002:a17:90a:d64e:b0:32b:5c13:868d with SMTP id 98e67ed59e1d1-32b5c138af9mr13139268a91.1.1757095358574;
        Fri, 05 Sep 2025 11:02:38 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b95d31976sm5409595a91.22.2025.09.05.11.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 11:02:37 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:02:35 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/7] x86: Stop calling page_address() in free_pages()
Message-ID: <aLslu1yKPNgoz1OU@fedora>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-4-vishal.moola@gmail.com>
 <aLl9KneqOYTujcCh@kernel.org>
 <aLl98MQs-FlHo6bW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLl98MQs-FlHo6bW@kernel.org>
X-Stat-Signature: goybiu9z5rg14cufp9xzt36fgmschjso
X-Rspam-User: 
X-Rspamd-Queue-Id: CF1022004B
X-Rspamd-Server: rspam01
X-HE-Tag: 1757095360-533690
X-HE-Meta: U2FsdGVkX1+A/ggxnjD/9sI4WwsfZi9Y98vCIu0zlzAoZYgdoET4qpBNBjDpCHV+HphPJN4mi3eKqK3HntnFzc+Df4vKW3AI4JT99oWEQiZFSfZmvyBvmkmHPR7ZJlByX/SAOrqIsMClfm+uFswS84prXGvCyIMXaEXuBt77qfMx6rO9IDX93fJAr6N47TgRFXvNAiywU2HbkXcE9U9pn8enwGQ5uHEfhGZ4cCwApWeJssM+vT1WImvmXHxWNUFr8iMdgzPHWEZEFnGoLeNf5mqx2wNaoXImLuicaQl4mtyRuWvc9OAZ7xGpVcJBag1qHK8Hx0zSo7QX1tzmHKme2zBSH1mClGuKTynW2lPiTeHr9AIIQeQvKagUhpYLNc/XmhNGgjx/DmRMKfgeD24Ohja0RHlf0nv0KPgnXfNWKrZ8tdBrI6iGZJKM5EtTUURe3UX9EFJGFz7wgndgl3w4tWe1/SaAsPY6cYemuOD4HG/4Inojvv5V+DkBcW15ugTJMMB3S7mvVTu/798oGggLJxsTeHHPGiKqYP3nYeA4iVJ2XotgmCfUDxyEdNz1WHseNCdNvDT6xtarmaf4RIk9cNua03PPd4eLeMZorEPCqFjF3sE8jpMU01PfwUZDcrfFgd1KfdckGWCrBCAD9srSNnAw31cK1XZmveeZ/lvaCWSjlJBRC1hUwxGBKBr23Dug9LsvEatFxv+avHvBa+/RO0EN+Ev1A0XgNmZ5DhjIKKYGpgQxUYxnpPuSS1G4DD1fprq2/eAYDtCc8LdyG6pKwm5VsgGcAaTRFt6asEiQN5T9GSVgtfpQOjVqzYbX/im0LTb1FjHdQll+X1xUoRlfckUWkhMYIlQp9qBPMdK95vVHLmB8ygFSLT4TcmhbWCd2VaT7Bbq4+g1u+EmNSVncMQECwbj9qaFuC8ymHhrz8k/RpNZAI2xfHdR+Xd8VgWxO0u5/OkqxBRzFSNeaFi0
 eHY52qYD
 TRJvkrX+SLGOZTPpvkrqSuqDLghPNVYQ/dXE7fxVXr8Uc5TAbe6YzikcRW+loE9uCGmJJsZiA5bKky4UoowxmCR78XeoqWYm/c800a5aw1XdNvDB/Qa2TxZkED/5/nPBN2VrAygX67PfBYCHLVx/fX31TYnfNLv1rUOublYClQpS4s7xzUm9UNojAqd7CsBnOanPg4ePEcYfV2OGWM6tm3180Jr6nm4NSRQwCV1r1IUlt1lfiFL9vQqG2lCLQxA3VoJg5RX6OS0W3tnXO/vC8amY3jQR62vCZoNVODikPdddkRTBK+zxUBxQG0cS79L/4Cj2Fz7jFQt+7DK4Z/n/LNUBk7rPqbGqTgZiwN6pp7NGEhFrlFQu2zD2c3nnI5Oh/99N3uoChONf04NM5RbAxgv2RbLvNZAKD1nkodxMdvRvSPFZSfLaeFyMCRkEGKRsLHGI4Y0r03/Lwvm5Z5lpNhagsPEjXpRRUOxzPFLTmSgZ63qD/GD6l4PLURVoeMQuL3oVWv1oIGmPRbYjFW5WLjJVcr1yFhhUFYclD2LswwkRDZwozgyEY4DW+9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 02:54:24PM +0300, Mike Rapoport wrote:
> On Thu, Sep 04, 2025 at 02:51:14PM +0300, Mike Rapoport wrote:
> > On Wed, Sep 03, 2025 at 11:59:17AM -0700, Vishal Moola (Oracle) wrote:
> > > free_pages() should be used when we only have a virtual address. We
> > > should call __free_pages() directly on our page instead.
> > > 
> > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > ---
> > >  arch/x86/mm/init_64.c          | 2 +-
> > >  arch/x86/platform/efi/memmap.c | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > > index b9426fce5f3e..0e4270e20fad 100644
> > > --- a/arch/x86/mm/init_64.c
> > > +++ b/arch/x86/mm/init_64.c
> > > @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
> > >  		free_reserved_pages(page, nr_pages);
> > >  #endif
> > >  	} else {
> > > -		free_pages((unsigned long)page_address(page), order);
> > > +		__free_pages(page, order);
> > >  	}
> > >  }
> > >  
> > > diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
> > > index 061b8ecc71a1..023697c88910 100644
> > > --- a/arch/x86/platform/efi/memmap.c
> > > +++ b/arch/x86/platform/efi/memmap.c
> > > @@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
> > >  		struct page *p = pfn_to_page(PHYS_PFN(phys));
> > >  		unsigned int order = get_order(size);
> > >  
> > > -		free_pages((unsigned long) page_address(p), order);
> > 
> > Could be just free_pages((unsigned long)phys_to_virt(phys), order), then
> > the page is not needed at all.
> 
> Or even __free_pages(phys_to_page(phys), order);

Right. It actually looks like we could inline this whole block if we
really wanted to...

__free_pages(phys_to_page(phys), get_order(size));

Should I send a fixup (or v4) with this change?

