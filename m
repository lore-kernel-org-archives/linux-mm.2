Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6175CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B008E01C0; Thu, 30 Oct 2025 08:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2B28E007D; Thu, 30 Oct 2025 08:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008358E01C0; Thu, 30 Oct 2025 08:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE19C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:01:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9658E4A56E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:01:33 +0000 (UTC)
X-FDA: 84054640866.05.3310945
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3919740025
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:01:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lDTOC4SA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761825691; a=rsa-sha256;
	cv=none;
	b=mqWL4Qz+LB09T9y7VEb5GDZUG6QSEXSMFIskPkxCixqpVIKsr1DRTgu9ar6NEhYaPjc3O1
	mj7YBreEvVu2O7TE6ByjuoiChSBK3y5pL9A8x0v4yL1sP31lzE2NzTFUyfPmmVmy96flXu
	hLblWJlREyLHn06g/vx0FZHj2kR366U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lDTOC4SA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761825691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCqsTP6WO8xa6bcu1HyLOprfOOc/QQz4vxykmNqr+x4=;
	b=21vRB+UVFV1i5hah5d4PqWSqgakCw9JRZB4OuxjdnOqTkkKYDz4k3dy3CfojBUphImOYWF
	5TQkarWAPRf++AR9ePj5t6pqHYClxVHB+jf5whgZJOKG45SxXqlsxJYzY+ZSl5ZbyxD0P9
	ua6N1KQlCpaPSNe6LgPziqN7klqi59g=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33d962c0e9aso926948a91.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761825690; x=1762430490; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hCqsTP6WO8xa6bcu1HyLOprfOOc/QQz4vxykmNqr+x4=;
        b=lDTOC4SAmf6735wOKWqSijP7iMGPocGkhefp1JzKpiD87FAP1F/RzF2mQWLQf6g9wc
         qjQ+ILBuFmZZfZjD4yIIjuM9XKfd76m9XCPLKo7oPKT+sadZLhZRMHbmQARdOsuG3Wd+
         W/Ic5Jl4E1YFb7QrdSETktFnG821Hg0Sa3gx3VgmimgQZJhWLEZ+T/EJgn9SF5O6weCK
         hAIJft3Dlgq5BgKhmlpSDiwHP1VQ/4GdxweThTaUBAaVE+q2vJzH5/Afx18NrBThnJB9
         3Y8CVYmQthnnMefPv2kB5deIeLOpl6Y+ao9VkS4SQThuLMuqrEQ/bJyvlYV1eFoXyPDA
         BSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761825690; x=1762430490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCqsTP6WO8xa6bcu1HyLOprfOOc/QQz4vxykmNqr+x4=;
        b=LwOnxzxI4A//TwX/95XgXQEjrU65R6fWhZktglserSutvCEa64Ll3T3JnVU21ESuvh
         efWXZYFGto0WLHSWdvQazlZ2SRiQQVR8HqlJniNCB608Odj3lvlxvjdpAQhgYOQWyC2A
         8Pr7cywtrMeS4bF7MO6NajSdqFeppFKKNLeXZ2JjBYveN48mpt8l0ZAikOY6lRzSu/d2
         nlDwtBkjIrYKooNqmmryIYQNl8b7X/tcz1ta/MfPr9InHPbQ00bE+9oL43Bw0tDk1Xu5
         iGpM03ch2iu/KqHZ+xI8qMcnOF/wamdbtz2gbOKZGacybbGIFt1VfW88PDP8xFl5UKPf
         dMcw==
X-Forwarded-Encrypted: i=1; AJvYcCXk8ZSqH54lqPA1zbotPgrYbBDL7ll1luQpuavN2uaH1h6W41i4aFi+ZDWKlITJoiYzCO2m1rZDqg==@kvack.org
X-Gm-Message-State: AOJu0YxSyH+NjskkkMPR30gxEHXIBYqnyUeOooahGeh2w/rd+qPsyyTR
	Rou5L7fh/2juu05QU+Xki5TlDbdLZQukAxOXq3pqZkRXQ+yivzNSDpWu18TShrqBmTE=
X-Gm-Gg: ASbGnct8r150FqRMOZmqatZSzY3OPJa9iYy4ER4HZHkx+8nF7yK7PQgN64SgFxpvzjJ
	T1eZL2a8Oauxf0Nc1t7PpmNV0Tsn3psjXTfL8iKBUAPbvEecAWekJZkkxFw1oxbcXGU+B0otGSe
	k8IZ9QFgoZ2W231xUviAG82rmUkNlJ4lXAQ+POKxuwIgCPBJFutLgxkZkWQVJJYMDkl2Golhiqe
	k3qDjfzgUz7iI+6sSUfqcVJW5rZ/jPT+WI1odEigFvla/2n94Yr6AyUFvZJXhrUuGwhcPcXAmYR
	+DqmFNLCE84Buzk/E5L5zkj22x7mcJlL8m2uG3opxnpWsPWVp9pKPbEUzIOBkseJjzUesI4OItx
	qcyWKqOxRs6q7LhPLvYCVM3EkZHhBRlwcGk7O4tJonQDVUbLxE7ptoBCFNHMMzbpPckFXG2gNss
	mLFm78Qzlq4jpmcdFGOXGHus7HXnRLYlzb
X-Google-Smtp-Source: AGHT+IFQonX24JTyLfZWsxFGjgrZZNRr20CiGs3KUyL71nd3BmA5oWK9NNDrPOive4p1cvJyGQN5mw==
X-Received: by 2002:a17:90a:ec83:b0:340:68ee:ae5e with SMTP id 98e67ed59e1d1-34068eeb00fmr1335110a91.4.1761825689493;
        Thu, 30 Oct 2025 05:01:29 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2 ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340509e940bsm2419685a91.17.2025.10.30.05.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 05:01:28 -0700 (PDT)
Date: Thu, 30 Oct 2025 08:59:37 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
Message-ID: <4ft4r4sh7gercwpmurgjpovzv6komoknbwvenzbxugx37ozrdp@x3i4vnacabyh>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-2-pedrodemargomes@gmail.com>
 <57b83fd3-8a6c-4d98-bd6d-1c97c71b91a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b83fd3-8a6c-4d98-bd6d-1c97c71b91a3@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3919740025
X-Stat-Signature: tcgyqisgo6fo5jonigy3a98f6kf9ij85
X-HE-Tag: 1761825691-510013
X-HE-Meta: U2FsdGVkX1+n400teRyb5nRjQ16RLaxPYgws9vbF1BGPjqn/nVJwj3HTBiLCpMT445PikCwTDGjAlgQxRf3UXCGZaFpF6ou+WLV/kCQkUFMkgxalZEnsCzMtqFR8knZ1r4c1gnEDQumC2dQ5+Ti1tWo7PtpzTyd5vfvTvJkPeBGVXa/l2eQ8M+dI6Ov2SGvTt/p+7I3iTQlppe8raRX855Ezv4MhnqiK3gW+4H00u2UwRzcvsKv3wvTzJ8STq+yJv4A8XohTvcMhCYbBAJ9IMft/2Rzz9zOKWaVa/VxTyC76KmB6peT0Fh2uBfqzVxMrK4Qt27GG1uCjr3rMOcX6x33Mxeq16Ud+Uu4RuoD55P64BCMI04/6GWlGM9eFb1X0b6vJIglqGWHHTpGozmOpsiALBQd3Cda+uletpEYjbyKec1VIYK8g7c0CqisgOMiS1rSSguh7F+FnpO8Aihg32vVnzNDybygs50KJ10+9reA8fos0vHbxWyJ0aSSg6UNGUKKFE4sQSMpZvZvHmlMatsGa+7bXbbrGwBxIFJ6lWYWcmb4bDNbR8dUgX5o/oMbsTYy9KU3H2WGgD3FgMpLQKRNvZrz7wIcARBipJURL8LnBe5+fp+esDgkIiCLOApsvBG+3oRktPURRG4ULk6EzO6F6+iHx53I5OZQK2W6D2Bm3Of20PNUQ9zHvVGykJhcalxVBjCrwqG40xsmxNpNn5Xtf0iG07+1b4AFC4hfixN0bvCfn7L6l+d23tcdgcQcrnnH4J6G3SAFQ5CHuxuyvKYtGf3JTknoosvv0Q2clMXrMqXNa7QLwWDxcpZZclVNCZHpGzSCZpO2SJjt2stI7kv4AhK7reV31uUTYwHwB2+55GbT4bXK1QVrtJnefAYUe1P/i4XsI0GvhxpEmqAATCMnWI1zwm4CoD+OkNYMy6bp0JuhdccbgkkLynuv7HSUnlwxqD8eqoJdxFSCWxH/
 mtoSTgt5
 jhU1xMxNsLRZzO/dScCFvH32o0NgPy89hiTJidMahTtYBL4jOwcLKuAwYNPomqPJlEyxHdaDBQmLNW85lQw91kFw1BvQJ1mIpBPmwkP/coUu15a4H/o8d67AoREV87GDKRdJHMCXH/3/cacuhMYblcgZYj/celO5QUvc5edlMrVbuGbKA+n/uGK6883RShnXtMpQu6QsKyLKabTPCExJjmb0c1l/V3uPinWRqs5QZd8YXM7Idqkdalnt5sxpMQqoKUWC+HM6M2vMaSW4H5bgZb7LGLeDEi1y78qaXNYx2XgBV8SuLCsMe0b5Mvezpe45HxkNETXWN+XjQS9xz/lTBCbAwAiwoaIfo4cigHWfq+SLemsy742VEtaTv+A8ecYmtmE3rE71Qvcv+OpGI0DIxZjlvOYn4FHvc7qIE22GPNb8G+u8JpcXXhOvP5MRNBiVLTZLDP8t7dYbgrZj4rfKWLrLDdqCgm2I96G5v7XE425RPxOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:34:23PM +0100, David Hildenbrand wrote:
> On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> > This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
> > PageKsm(page) to folio_test_ksm(page_folio(page)).
> > 
> > This reverts break_ksm() to use walk_page_range_vma() instead of
> > folio_walk_start().
> > This will make it easier to later modify break_ksm() to perform a proper
> > range walk.
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
> >   1 file changed, 47 insertions(+), 16 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 4f672f4f2140..2a9a7fd4c777 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
> >   	return atomic_read(&mm->mm_users) == 0;
> >   }
> > +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> > +			struct mm_walk *walk)
> > +{
> > +	struct page *page = NULL;
> > +	spinlock_t *ptl;
> > +	pte_t *pte;
> > +	pte_t ptent;
> > +	int ret;
> > +
> > +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> > +	if (!pte)
> > +		return 0;
> > +	ptent = ptep_get(pte);
> > +	if (pte_present(ptent)) {
> > +		page = vm_normal_page(walk->vma, addr, ptent);
> 
> folio = vm_normal_folio()
> 
> > +	} else if (!pte_none(ptent)) {
> > +		swp_entry_t entry = pte_to_swp_entry(ptent);
> > +
> > +		/*
> > +		 * As KSM pages remain KSM pages until freed, no need to wait
> > +		 * here for migration to end.
> > +		 */
> > +		if (is_migration_entry(entry))
> > +			page = pfn_swap_entry_to_page(entry);
> 
> folio = pfn_swap_entry_folio()
> 
> > +	}
> > +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> > +	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
> 
> 
> The you can directly work with folios here.
> 

Ack, will do.

> -- 
> Cheers
> 
> David / dhildenb
> 
> 

