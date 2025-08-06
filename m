Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2F9C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF788E0001; Wed,  6 Aug 2025 08:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6506B0099; Wed,  6 Aug 2025 08:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCD28E0001; Wed,  6 Aug 2025 08:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE0EB6B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:18:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DE3C1DCC1C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:22 +0000 (UTC)
X-FDA: 83746235244.23.F67B876
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 434481A0013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=vCHDdWya;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754482700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5O1ajgOeaeiocA+1U0rfXnrWE+rOnG3cAc3QPkT9QLo=;
	b=A3LlDkmEMgGMsoFYUF6Cs/kHRIeY9ejzErPfB1c3b22/dhy7V6pkfYin3hkA8kFYl7sUe5
	u0zh5s9MkgTbPYelPymjOXa2jkJ9wMWaUrr8sPYhZCpY0f2dmbSD1+zXH3LK9koZTvaBp/
	xant8tOb1U1JqOyr4inXvwSBRjQhuak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754482700; a=rsa-sha256;
	cv=none;
	b=abXbGbjeyJfBW3pElqELWHO6ChJ4w4xh56gJe+sY82VFPcPoIeqTwkiHMxA31dJUmPaez/
	ACf3jucj4EL/hlRpterrvDscal2fJuQFoqmQxz/rlbu0eWP2xN7Mw+SDblwDFGtglFLPZh
	yHqdtvnuYis2N6Zc756FemGV25aZYg8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=vCHDdWya;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4bxq7q45K8z9tQW;
	Wed,  6 Aug 2025 14:18:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754482695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5O1ajgOeaeiocA+1U0rfXnrWE+rOnG3cAc3QPkT9QLo=;
	b=vCHDdWyalXiuBEyJq8kQbTmBAy2dZK+IDjgzL9AGeiz2+QY/PFSNGiGNDY3zz/6CKHp7DB
	LVzdMTpLXPMunqiyw2H1me2Z7kL7UKcWArXCTnhH21NeuZGxQRKrKdk+JxHzXOSKaMo/LG
	IFWNVtY5tAB9Gsb0QF3K6mGoVFREF6YB7gRjl9fy7qOjaODPvxNHKhZY/1JtAcXjJMglMv
	pWDreyV54K+S44Q2KU5AIqBNCZmqcfJEzooJ8f5OmjPNoz0pKEDfnBpD6QKyhzU4p12kqZ
	kEBLmNbvUyTPtcYFsd2yJZAVMIAk/EdrrlH8S/e5TuZ/Crjrb2Q3tArR1o5PXw==
Date: Wed, 6 Aug 2025 14:18:05 +0200
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
Message-ID: <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
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
X-Rspamd-Queue-Id: 434481A0013
X-Stat-Signature: e7p6ms8hwkhxotedwcitdqndwopiw3ho
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754482699-210471
X-HE-Meta: U2FsdGVkX189TBx0vYDVXCt2sRktT2O66x8ZaagT7QnASm4/Us3IVVP05CCbIiJhIWI9pjEbngYOsqTBNd7aXXjuTkzW2cQP1CyV4Bz8QO2XxElVhRAzmsyD+Q0wXsLGEP8lzDlczYstM1gUd/zp75L+QOlXkfcdoNXPrSFdxkMfe6auGtQJinj0iGPE23vyrxYgubBvKaWBtHYCypXS4JGNxOPhAePy7h9T/Z7ez2RZv034CIN4NvLGqIPrMajHW8Fp1QNvbmVIf22JF8IDXQ3K+MwPw2YZk4XnmfuMWuU8MKOQ9Ec3F4hcVIC+Im7UhoC6fkEK96GF3ssSDDcDK1rh84+Hb464hMz5YCQCyNzFuTQAoCxMZ7aI/UuXspL9BLtNDz8Y1NgBp7TF3yJoLnLbska/jcHwx1eN26Y1lSF6dtRXAwZYH3tmhEqdQHCiAle0zsgWdQvfP9YoMvQC/kZkInerZaJbRW2KafgWRhD+/PwqrMe9ASMJJplX6/AOh7tfasIa700zkOzs8/rt1pY6uBuHS9U6ULTHuArP1Q7kUeLitKCJqbuzU11wIvi+3tGGLQzQRw6jNGNwALrFvBiS54TYFFvYulcqHpkvNjmAStqobxCuT62K2nEFEEzHi4nHBpGYtqTVHGfC1YbxiQ39iUhcBCTgDO+2mVyBbPZKGKLAG120bBPFjpkNIokoNTbbjK0BEEOu6DLbiy6GIg5skOPH+GLoum7xJ1i4x2mJRl/VEOWVNxO5JuGmb08aRZXoTu3ZqEOEwPmJv497zKKRObjXZB5E5PYQW+NiB8vFTlBrVIC8tT9h3kennxlzOmpRO/fvgnOS367zMpmKG14W4vqYWhL962sLXlXJYs7CliWBVvpJeHCFYeYf/YZE8/0FC+7Ak3JWnWAtExVnDJqc5iyHW3o8nbOFNuTYL7TrZp0zOrMUbKCBu0Hkl95gHG1TIcdmhgJ+rnnxv9e
 D530R6iI
 P6xp5mSDmdK0ly9SVFLMAaEzsbBxLbyTHMwb1e10mJcXxgkwg4wgJ1jzQj1QQ99Ek2Vq+2Tfigm723R9DOFRKMf2y3uylVS/6S97t7IDarhrrb6YS8lt0f+gqyH9/vYkK+rwVQZLaKrT3yxuL0jzmZ8sv1WuySqtUn8G4EeF7gJqU0XQzrKht919AFzqgPFJbXXAMZhtxWUoSsHznuYZWHiapVqvX86W37I0tW3EmdBGM2L7sYBOF0lQOpleZykBk1HPAxnSpZ8fAKWN+x/PXO4CvnVVPrfOAufz7SAiTpSLF5xX5TRjrptabm3p8EoRkA5V5OjHqE38Y96vY0tZinM7n2ftia5rhAOIzCCLbrDvt7mycv4KEG0fH8Y6dDeYbweT7afnCS00cCax0acMm/dxcDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We could go one step further and special case in mm_get_huge_zero_folio() +
> mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
> 

Hmm, but we could have also failed to allocate even though the option
was enabled.

2 options:
- we could do: 
if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO) && huge_zero_folio)
  return huge_zero_folio;

or
- As dave suggested, we could do a static key and enable it when the
  option is enabled and the allocation succeeded. The same static key
  can also be used in get_static_huge_zero_folio().

I think the latter option will look more clean and slightly more
optimal?

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
--
Pankaj


