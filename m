Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C83EC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868526B008A; Thu, 17 Sep 2026 00:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818B66B008C; Thu, 17 Sep 2026 00:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EB86B0092; Thu, 17 Sep 2026 00:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3C46B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:02:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F19C1A020A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:02:43 +0000 (UTC)
X-FDA: 85221907806.22.C0BF920
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E3CC100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:02:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mBJ1WsLF;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dS/3xl587WkmsMSn7jSfCRAJknBipZrHMmNnsRrAvn0=;
	b=cT8kXjTI1n7zahgWeXGbu6ufdffcRpC+tSHfjNW2o5rShzM1F7IP+QVfbaMvB8+7Gj+v4a
	YviCtdGOf2mWRx87oowCeaNimB45n/rWxJnxHF4dsK9aCIDMu0zPmOvpWIc+oT90qP9DlP
	/Kj49KchPqdpHGL1k9hnbp/5og+XYPg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mBJ1WsLF;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617762;
	b=43IWhs2+NzpgAMcK/Fn+hZIFBjiXZepGerb3E/0EvnhzxN+/JW/Ahncmq1GE7jJ2rj/KbA
	lhxUpt0XTmiUG+iDMGnVBE0V3BnUZ+O7H91Sztv2VNdVPnTtTDYhccp14phRs0M3QVIF6v
	uGOg9Dz4zVaS2oHS+K61DK6JrGV7d8k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7ABF1476;
	Wed, 16 Sep 2026 21:02:36 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7FC83F7B4;
	Wed, 16 Sep 2026 21:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789617760; bh=pvRE23ivxd9BXCfxEuHJgM+rJ6GOZz+syS/Pgj8gpR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBJ1WsLFSDfD9zO4hIbZuImbAbY2/Ig1hMvMo3Wbk7+hngEkxgy28wy/ZxxPf5vI0
	 d+zOHmasm2jaRAfC67ZhqbOytBK3+dNgBBgQFSdXdQpx9G9kndvMqNwamAqXhQpcWs
	 b0yuJgaUEjzp51JEEt6yp3d8Spvn1PHwYnv9ZeVM=
Date: Thu, 17 Sep 2026 09:32:36 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH V2 01/14] mm: Add read-write accessors for vm_page_prot
Message-ID: <lhvfz6htwibeee2xgnp2sdfh474lmklooep3e6c6467kegtxu4@jejzhb4jlekh>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-2-anshuman.khandual@arm.com>
 <69a7987f-15fb-4793-81b6-cc436525224e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69a7987f-15fb-4793-81b6-cc436525224e@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E3CC100003
X-Stat-Signature: pxf5563sfcwbaa6cxdifjsy4u71pck5b
X-Rspam-User: 
X-HE-Tag: 1789617761-373253
X-HE-Meta: U2FsdGVkX1+OXb7SfDbAMIUU6E/VP1OVlH0LC5B7LQ+YfIphLsvtE8uh7AtGW2PnyEfYledndS4cnghdQGrscvzgebK2LCfCY8OGav5Q2By866nYwl/Z3PVVyalzC4T28h5kyhjSdSmApNzkZZYI/ClE35rjYNtS1jMXkYEnAp9DjVU1SUYEUwbBjw0Wu+GuWSSYvyRX9yrxrBNk5dV0n9aUc16TxEZ6xUlWb7imUczLCUZ9nqw4js2tgYQhXN0Rmz/5QQkPmEkg8QT7FvkbTicmhGLhSR/+ssFBoB4nYatYA+CiX9hgzAtD7DeS1zyE6fZLltUShwcx8EO/j4mXigWRTs+yzNRSlzzjFPvj9hcyFDN9xkKo2jHDoCku00tny00uCp8oh9rALEzMZ80+hd6cs6nrtNNUhs1+5VwAAvmyiiEm433tDlBwzImFv7P+J+2qB2Cz5/Ed2rAeu7S5P0azdQoYv3gt4DdgPhRk3FRYgo5xKGLJCtdvm1iGWcRyvaIXgNw+O+UiF9fA3joBSFtDRRlNs08Xhdvvov6TecEY8wwoFi9wH39Cul5xi8BXEFa9uY3+dW5a1sOHB3WKp+6xEB5qXVrRxyUISqXKVqt4fLPrkrkMNE9DoUOnuARRf54/1duiQ6j6VQCAOdO2bddPkI59MewQXeI0Vx3ZRX2asw4ZmGqKGE+20Q/rqNrIzJc/MtrHxcS0RkEXFnyo/BAbUnNnZBH39FyRkHLmKHHMHoV3cuJhL2pdX5zHaoX1Xv53B/wGwij9z9B2gLCCGLNJgXn1Hl3fbB2YP777wLBBihdBVabFefD9WQ8XdW1Okg2eWWBjzMdxBOqKQR+AnxiTAgRfeNJHye4jzvMMcnDM6FtWXJe7VVWlPYsxNrKRZM+jvskoWpXZGRJNzGyqnW2ri61gfx8UTpgKjpzCkYND6ot23DMT3KY7CO48E8MhV0aURLTkH6lIkbxzADt
 0Qh8WtW2
 ASG2zKwieN9tM10n+P8HcF4OEt26y8JBUnl/S4u8T4lDlzcxbQcjyKBUuTlatU8A397b/K4dtm0ml86KAFgrwSTotoypWKEf+z9XqWh5UPjlNgmrcqDtrL2+SQhUqYy8wOan7TFFQdOxUH1COYanO5OS8RXaN9mRXdupejnYt0/m1AmFV5Yc7xh2n641rDNcRNlwMt8YYrHFpW3/GwHC/7AGn+LVlHJofrHWkv1Xk1YgIzs7F+UtZ7bS5GoZugUbmAOuFpRoYV7FH3QJDSjAPEiEoDw8FVObmWBMI9/apVy3ORwqlrumqVDHcKb7sDudQBgNccLVb/NfMV5oSIHVBthJGleZ0/iH9H2QXh4W8saGoVkHTy6MvoaQlX4/TewOW3uyK1dJvOAb2CFcBxVIxV6My13Yn5FEGGv13n0QW/r1UCdYUijTIdyfGGOSeDZ3dYfTihDp04PATuRJ2QhgXjweQHjkB516SkBuOEd3k9luOyPNxrXvfPWcubHvR9UCVtFe2C2mE0SU22QI9u5jigexCFRbvooeHg0ukQ2U2uOauwSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:23:13PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > Currently vma->vm_page_prot is safely read from and written to, without any
> > locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
> > tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
> > be handled with READ_ONCE() and WRITE_ONCE().
> > 
> > Add read and write accessors for vm_page_prot like pgprot_[read|write]()
> > which any platform can override when required, although still defaulting as
> > READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  include/linux/pgtable.h | 14 ++++++++++++++
> >  mm/huge_memory.c        |  4 ++--
> >  mm/memory.c             |  2 +-
> >  mm/migrate.c            |  2 +-
> >  mm/mmap.c               |  2 +-
> >  5 files changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index e3c8ab96941c..0df57a5c19ef 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -524,6 +524,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
> >  }
> >  #endif
> >  
> > +#ifndef pgprot_read
> > +static inline pgprot_t pgprot_read(pgprot_t *prot)
> 
> Try passing "const pgprot_t *prot" instead.

OK - will change.

> 
> [...]
> 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 15b45832bcfa..579152cce502 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -387,7 +387,7 @@ static bool remove_migration_pte(struct folio *folio,
> >  
> >  		folio_get(folio);
> >  		new = folio_page(folio, idx);
> > -		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> > +		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
> I do wonder whether a
> 
> ogprot_t vma_get_page_prot(const struct vm_area_struct *vma)
> 
> where we hide the pgprot access would be a good complement for vma_set_page_prot().

Could you please elaborate ?

AFAICS both these helpers vma_get_page_prot()/vma_set_page_prot() are already present.
Are you suggesting to change vma_get_page_prot() instead ?

> 
> Just a thought.
> 
> 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 4bf26b0f1e6e..729bc244b317 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
> >  		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
> >  	}
> >  	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
> > -	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
> > +	pgprot_write(&vma->vm_page_prot, vm_page_prot);
> >  }
> >  
> >  /*
> 
> 
> -- 
> Cheers,
> 
> David

