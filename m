Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933B5C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 11:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192826B009B; Tue,  5 Aug 2025 07:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A4C6B009C; Tue,  5 Aug 2025 07:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080536B009D; Tue,  5 Aug 2025 07:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC0336B009B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:41:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D48F54E60
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:41:05 +0000 (UTC)
X-FDA: 83742512490.13.03596A1
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8ADB1A0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:41:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=m3praHCn;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf25.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754394064; a=rsa-sha256;
	cv=none;
	b=txu2ftD9ETWC6KpUTD8qfs5SdMYsPT4qUS2LK7uMiJPGv53Typ08FyMezWvqfl3WQfhp9a
	JvT5dFX1v2cvtSNjF9vHr+/AIpzjj/cj6kSBog8bx9twoAJDHrZlqLeuBJF0Zx4k5VaY6z
	NG4cZ9DiIhBu2RfOcMSbIiBZU4uny5k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=m3praHCn;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf25.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754394064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmEnKsY11qSmqnHzHIwJADtWs59gB0JXO/b+GAgtrX8=;
	b=H9HxKqv3u73TZXB3LEssuuK5fSpt9evhSjpuHHmOctLt5/048QvGEuqOHxTdmJ/O8Y5ZqK
	J4/RBjhEhDJbrbyn9SE6nfnwPGntmkksIcvu2/RItLQf6vSNN2UKrD/1zsP3qwPND8cL1U
	+bRndU9zW0ngwJ9SRBYF2yjdUIekjaU=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bxBMH4rKSz9t6B;
	Tue,  5 Aug 2025 13:40:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754394059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NmEnKsY11qSmqnHzHIwJADtWs59gB0JXO/b+GAgtrX8=;
	b=m3praHCntM/p3xOI6zdjvjnxW8gQopf/zzPO6ndH3fXwgubVWgSr1ZbH5Jw0cV05Yn6xot
	hrYPn5XEMFYGJUyBqvh75jmM3UHRKvRC6VW55w9fZip21gotUBMJn/Fn5VeLcbiK1ymJUw
	rL3tZLd/io/ut39fnW3OdGrZT/hFCUaB7UKqzmEqUp3yVKMkg77gxUigEPNcCsFfshY/GK
	ukvvxjDeQ7F3mfHr/XThHYuhgnaOFbIWu2UwufT5PSxF+GBZWtT0Em9L97u1g/27uTIkx3
	1oUs5llRqGuFEBkd+5FxH1aU+u3VFKS1Tad9BZvAND99rLhbKUT9vIM0lJVp3g==
Date: Tue, 5 Aug 2025 13:40:47 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
Message-ID: <dwkcsytrcauf24634bsx6dm2wxofaxxaa4jwsu5xszmtje3gin@7dzzzn6opjor>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8ADB1A0005
X-Stat-Signature: bzogz3jrnbmp6riwb53cjgafhxkcs4ut
X-Rspam-User: 
X-HE-Tag: 1754394063-175275
X-HE-Meta: U2FsdGVkX19Ke7YKszsBmWwUXMhDBh7vlZux/mpZqH4s9FWArzfVWz8cd116YJqFF8F8d1ANTyW1iyzPTJ7rXCtzux4kYOMtuXbej8mCEfZ5PypqmFfZV3dYZZgACT1QJGRifEZKEzWlXsR81oX/bh5eODZQh5fViuR6nJmzaELlvktGp8IngDKUaSljLg8UCepBO/Qt0LT8F470GsrdvjVp9SZVB0zMqhLfY6VwrVHa8DqBxJ+rvfCUNWi3xB9zbdD1rAS9l2lwO/+UPN3HILuXGPlfNLQDXKVoRsrt9iavnc03rFq5pVRdNdL/tot00fqHrSD+V6X+Q7nE0mR1IL8W6h7duoAnWewIkpu9o9KMEUdkvydjcq4MS+EQGgCYy6IuRc4FCF12XseazxEfz0jK21ujVV3/IL00c0gJpduWDehsr5yI+Sp/xx4LH7CNCtyZ3Rn2GCp7UXS5eSuah8k/pIqGXd8BaSA4/wW2czPoXTb92vWcRMnu6j5QYYHtqcmxT7W55UR0YZZeJKu9IGVsmvGvKw1I4Iiqxh3ZadpBBSIJGBZhmZB0nsM7gbqpLC4/OVnyiEfy633U/segbH9WQK+JjKxbhciRD5/rOH6/I0ufVIBywDfDODiBgfjbsY75Fd8+5YGMhy/9axtHW/1A73sN3ZO/G4znL31Q078bedbFfNeGqcoIMIcesnhf27MlSKnQpKNpZ5iUQ5YGOPdCpYlQ5bCDwsbovQV7C4fHbTGQOKtqbWtsfnVpzmsNV/KFA4LgdA/qod+a9riOwsChMlctrdZQ6CPfDg/nIYXhB7oWNc5WH794xpFopS6mQ/IG+A87DViV/EanVR8VQAR2AAZvp8p0EB6LPQQEwAEdgzRVAskxyGYWV8YngwOs6m3FAoYUZt88ovN8zRfvM1l1hlDmSN5H5JgM8T7QP04Yjp33pDy96yh97o24mLDcYxfu2q1pm0r3mxFZM3x
 QcS6JNb1
 GiWQ29M3M/azaB2lwm9EbsqHNFbcZM8vBXWgQtD7Jcp6nKP0W196BzXTXelOf0KY4YzHsDzF+6zBiHL3rtMf/OHHLxIslwcdnqeO7CCvcZrc11X7Uok2GtLZcK32bzZyXejDkfUo7gwV4n+nfWA8Ro6YnQn0AbVrWobf1OqWuuzfhxMkvHig9GgzstnQU/504xJQUbqx8Y+qvTQ9vmeP4JyW+tti/5jI73yZWAbpB5kTCEVC/BGpWxWh57oh7+sj/sfDfk//S6k4clbbarGAOPAanmmRXbma7XL0F3zeyodypXEqv9pFbSFNWS+8Gjt5rAhf9x/wZBrZpzxFUI1lc2E2wmgl9t857A76eKrhCPul930qxN8xzzpICrqTqJR8cI9VL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks a lot Lorenzo and David for the feedback and quick iteration on
the patchset. I really like the number of lines of code has been
steadily reducing since the first version :)

I will fold the changes in the next series.

<snip>
> > > @@ -866,9 +866,14 @@ static int __init thp_shrinker_init(void)
> > >   	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
> > >   	shrinker_register(huge_zero_folio_shrinker);
> > > -	deferred_split_shrinker->count_objects = deferred_split_count;
> > > -	deferred_split_shrinker->scan_objects = deferred_split_scan;
> > > -	shrinker_register(deferred_split_shrinker);
> > > +	if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO)) {
> > > +		if (!get_huge_zero_folio())
> > > +			pr_warn("Allocating static huge zero folio failed\n");
> > > +	} else {
> > > +		deferred_split_shrinker->count_objects = deferred_split_count;
> > > +		deferred_split_shrinker->scan_objects = deferred_split_scan;
> > > +		shrinker_register(deferred_split_shrinker);
> > > +	}
> > >   	return 0;
> > >   }
> > > --
> > > 2.50.1
> > > 
> > > 
> > > Now, one thing I do not like is that we have "ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO" but
> > > then have a user-selectable option.
> > > 
> > > Should we just get rid of ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO?
> > 

One of the early feedbacks from Lorenzo was that there might be some
architectures that has PMD size > 2M might enable this by mistake. So
the ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO was introduced as an extra
precaution apart from user selectable CONFIG_STATIC_HUGE_ZERO_FOLIO.

Isn't it better to have an extra knob per-arch to be on the safer side
or you think it is too excessive?

> > Yeah, though I guess we probably need to make it need CONFIG_MMU if so?
> > Probably don't want to provide it if it might somehow break things?
> 
> It would still depend on THP, and THP is !MMU. So that should just work.
> 
> We could go one step further and special case in mm_get_huge_zero_folio() +
> mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
> 
> Something like
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f091..9b87884e5f299 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -248,6 +248,9 @@ static void put_huge_zero_page(void)
> 
>  struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
>  {
> +       if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> +               return huge_zero_folio;
> +
>         if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
>                 return READ_ONCE(huge_zero_folio);
> 
> @@ -262,6 +265,9 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct
> *mm)
> 
>  void mm_put_huge_zero_folio(struct mm_struct *mm)
>  {
> +       if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> +               return huge_zero_folio;
> +
>         if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
>                 put_huge_zero_page();
>  }
> 
> 
--
Pankaj

