Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E391D3F09D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915AE6B008A; Thu, 29 Jan 2026 12:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C32F6B008C; Thu, 29 Jan 2026 12:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF816B0092; Thu, 29 Jan 2026 12:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68EBA6B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:04:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 128348A939
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:04:09 +0000 (UTC)
X-FDA: 84385624218.07.3157D05
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35ECE20011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:04:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqVxopvB;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769706247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tud5pIk5DBnqttumTWJSiTcY8mmer/BbkCgSuG/weGU=;
	b=KCYjX4OpnDh6M86/w4TTSomRAf6sMkkYFlbc+562s2z8BMfj3sdb9uF1Fqg41V/aedo+5Y
	pW5Fg6Hk1ya7HkPwQRZlj8V5CG/WrEYPIB0/hEfTK/DHEtqjE1Xuo8JodhHyXvtphHgmF0
	gnW2gFr5FvHIMgMfaOr9auxwofQgUQI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqVxopvB;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769706247; a=rsa-sha256;
	cv=none;
	b=v4U2xkybOTIS6o51B3vJx3dlNj2ImOJrnOXwuc0aKXbEBFwack7HucOPvyxfLrfWGyNiBS
	0zK/YSN2nO2E/nlRO3veLGgpHPtmj1BBGJxbJ63hd8bN3JqDRo+nuWriMr+H2H4N/SE6ju
	lUuUKPzw/5ek4/Wp5rzcHxhwv/svG1U=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b751c8b6beso1340998eec.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769706246; x=1770311046; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tud5pIk5DBnqttumTWJSiTcY8mmer/BbkCgSuG/weGU=;
        b=KqVxopvB+V0lTjgNT+7dTQp2fb0puQoEbSfzFzCSdeIIuLAK4Q+/U3OzNG4CiN3KcN
         ln6nF3dVhQR+pFL9LJaEaNsaA7z6qUChUXxPTYahJFT0wCBgL+fMmU/rFp8E2KsnNPBj
         SQ0ZNWND8wyL0XttJb3mgYRGdgxDc6pwseguInU9xGCiOFbsUU6GYa4yezHse8VPOcrz
         XkUlrxjDODClRHT7syoWNKPcAJsibcRuepkqYG3UEvGhlaGrUZBXi59HU/h1QhVqFlcn
         fT/YGE/cJchtgLJQUHhTt6fYQFAH/TEUpot2inq9gMjmBN6lcfmw3j4/mCfIvc+h9saZ
         vdjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769706246; x=1770311046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tud5pIk5DBnqttumTWJSiTcY8mmer/BbkCgSuG/weGU=;
        b=fbjl1IJBseW7PLvLYanbInpnRX+l8d3S4pD060J2F4GJtd15385Bb9omEyweBM5Ybe
         80iLphMvp9FJxrKyYeUPQtys5h5vwD41B3x7avMa+H79Jrv1Gu7BTEPXO3en6ckWatya
         jP49i60MFBPZdzKKimoscIBp18Bas2VW0dbXqvQyglKuU2gXrs1JFOx9sSrn4N8vLDDH
         voqjL1Kuc88pHfu40bFvfa+FBn2smXwRHMt+/yjSDBuZxfi2IzdxUI6qlCk9VgJu40PL
         JtvKfaFNIp217tfEoIg3VGKr9q2O6Oyb7b5zcWpExdNmdCMngqQwFX/pCm2PrMGbkybB
         UKpw==
X-Forwarded-Encrypted: i=1; AJvYcCVPZFFbs/Nn7Rmh0gRcCm5z4CEedyB4xzyqoBtlP9iV+OMlozhpxKUBt0ykItp5utDARBe3nRquHQ==@kvack.org
X-Gm-Message-State: AOJu0YzNlVsiRmlJ7FA75LiID8HvQ3iuGGnfAwquqwInpFVppKUHFAww
	OlQEMJTWFj5alymxmCUveTAUJ8c49tcH1GfhXMWBpRiauYwoCwbvIQw7O5dapw==
X-Gm-Gg: AZuq6aKT6CS0UjPAN01AiSHb29S6zcuKM3300ymRuefbVeEMM75dcDxotwRewBtHxD1
	rQJV05PqH9pEhjrNScoEj6AINeM2OK90JofeSX3lG0cS+LfPDoOEVbRdLn4JhZX+L6aNkX13VSa
	T7QKh/NAkk6X9qRLf0zc/jH2vSRdFqq1iwYsfl2PlPmdaO2Bn40qNmE8xG0J5smvOKQ6P+uE4BU
	AqQvWb54DyNZN8W5TV5gpOC6Mcn1Pnci9yG1d6ePr5vHUiOfqNSclURiS7vk4LCL5hS6LHbsHhO
	oVY6pQzEjopbGWtz8uoUYWmD0B73cHP4Bgx73bsJtIyLofYBFp2eEW4sDt0PItU/uJUoLqKjQRN
	q4A6RkJX4HeFrxx+1zU3Oq+JhyMwNM3zOh1cWcnnGlc8gWcBw6ZEb3o86B1acNdAL0dPlnSHG1u
	Hxdc7XPluv5D/iWMWz4xRG4kHMLBE7lwlT6x08/GEimbcDE53rsOzbyA==
X-Received: by 2002:a05:7301:9bc9:b0:2af:f2c2:3bdb with SMTP id 5a478bee46e88-2b7b178ad50mr2028016eec.2.1769706245590;
        Thu, 29 Jan 2026 09:04:05 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16ef3b3sm7560404eec.12.2026.01.29.09.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:04:05 -0800 (PST)
Date: Thu, 29 Jan 2026 09:04:02 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/3] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aXuTAtwpSD8IABp_@fedora>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
 <20260128224049.385013-2-vishal.moola@gmail.com>
 <aXsVgUHCnnvxtanV@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXsVgUHCnnvxtanV@kernel.org>
X-Stat-Signature: csaue6waycb4ismq9gpyg9qxut17hmro
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35ECE20011
X-HE-Tag: 1769706246-899265
X-HE-Meta: U2FsdGVkX1+zLXb0NlHFM9vvKQVGnIV3si9V6YcdswkQGCI4L6ellek1D9eMpqHQmy6SPFbblD8EX/z6joKdK5borGBv+Y9sx5roOoL5C+Ruf4rJ/2N20l7Xnx8l3gT1MqTa3Josyd6MZnDcD2WTwC3j9D126Sc3aHDQaCbu4yXDAa53oMJP9UAkPKkNG3md6zcvObeAHhHN34FhLv56EznuAmw8+F67o2I318I8YOjs4Jg8o6lbJnu08DZ95pJyY5kPZeyzd0eAS7tcQ3JKaiQ7OKovRtYm+skemYYVSwjeO2VTOnF58qm3XAQ4YvbkWFrGT1Uv0CcriPo4IkE3UnS0h/WbQ/XRLg6way7LA1Cu0uaO11tscvHQaFadW1uhGTckNbeDQFXi00bOcfiQsSIJinqg3REbV5A0KOo8U2qeDhhEjHuBe2xceXsVrKiFOPYYp9DA6EIMFb2GBjpqroD5NfWscqiUuoo/okwvcraoqk/yrtttPH2qZhEA30OiZGbLkb1kU6q9tiKxfhuwWUoSfAdOPkWA51s+vqRrh1SFnOn8ALZRQR0f5aYFN6CfdwGPGKity47Axdox6A3tLVMog2YZZ69f0etWqDYVL5DPIzJQERahe0EJ3XgDTX5MlHxkKRe0AIxKcXsXWBo72yX4lqSB+xobc0Ks/8+z2IKi7YJMnMj5Gk0HsI+1/0wRW4eTB182cYs7bc07WkbOKAF5TO/wJsTlTBtchdv/y0vr9mQ8XS3SZYNDDgHfyJw5hzRg21ASrLFkC2Lf0vxJ0H7eTWiod9FzccZrL3l5y6B3930MH7UK6n7yub95cfJboOoETR8ZU4Mq2CJp9KZ32yihIhZ4mbNyNxWR+wmEVLapp7wuVO7rH6rohaK6msqnIA47Obc0NArPi+uI7K/oVKiE4rmb+MmedHwoe/fkzPvwOABFnDMbrg0vjU1EzWw9wTasFq17jrLj367/Lfv
 CMo2CcxC
 JliIes/FjQetLLNZ4CKPaYgGvK+GCaSM05HJ2hYcsORLdxcjdRpmJgTwJTxPZY/2+C7W8T+0BVQKlp1bKWv8nVUC2D6UgmlInC0BBsbxmxmsGLz1tLHxRY9yDTelGHRwcfOugyzGw7sFODFwFZX0p1zd2rPPXwbfK6fXheZ4xrY/rXf2et8wLNzhToTORF7zKwYbuu7l+hD4XdWzu+QCFg5nammtn7VZiseCHHlajSJOPC/OL8G9eVdypbYuLMx4WguY/0LX+x2uiZ/SQQnB9jYudmIXgEzKbHlztAa8jQ0/uRYrgcs2UJEUKm9lGIVuqN3mVszSGAVCod5Fp2xg+3qhUqYqWps26gEiMyetjd0RxHtbg03tdyWnRZB3Hu/+9t6S6p/j87mJ+gD7h7oAoF5FOFjrWGo5tEJM+9k/RqBm9DHfSEpgBOdYMFpj2d0Z5Lodo4i8K3mNfmXijH2Q6uf+xWVwyvnIlWEAVV82cK15IMji1Hw4+Cv0guDA9vpRFyCFawpdBVh+p5vPqDoy8NcwTjrJZnTpCPEE8bSQr3CHoUH8N0rRnUCiPX/qYAnU76idC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:08:33AM +0200, Mike Rapoport wrote:
> On Wed, Jan 28, 2026 at 02:40:47PM -0800, Vishal Moola (Oracle) wrote:
> > In order to separately allocate ptdescs from pages, we need all allocation
> > and free sites to use the appropriate functions. Convert these pte
> > allocation/free sites to use ptdescs.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  arch/x86/mm/pat/set_memory.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 6c6eb486f7a6..2dcb565d8f9b 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
> >  		if (!pte_none(pte[i]))
> >  			return false;
> >  
> > -	free_page((unsigned long)pte);
> > +	pagetable_free(virt_to_ptdesc((void *)pte));
> >  	return true;
> >  }
> >  
> > @@ -1537,9 +1537,10 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
> >  	 */
> >  }
> >  
> > -static int alloc_pte_page(pmd_t *pmd)
> > +static int alloc_pte_ptdesc(pmd_t *pmd)
> >  {
> > -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +	pte_t *pte = (pte_t *) ptdesc_address(
> > +			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
> 
> Sorry I missed this last time, but ptdesc_address(NULL) does not return
> NULL. 
> The allocation and conversion should be split IMHO.

Good catch.

> This applies to all instances in all the patches.

Thanks for reviewing, I'll send v3 with your feedback included next
week.

> >  	if (!pte)
> >  		return -1;
> >  
> > @@ -1600,7 +1601,7 @@ static long populate_pmd(struct cpa_data *cpa,
> >  		 */
> >  		pmd = pmd_offset(pud, start);
> >  		if (pmd_none(*pmd))
> > -			if (alloc_pte_page(pmd))
> > +			if (alloc_pte_ptdesc(pmd))
> >  				return -1;
> >  
> >  		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
> > @@ -1641,7 +1642,7 @@ static long populate_pmd(struct cpa_data *cpa,
> >  	if (start < end) {
> >  		pmd = pmd_offset(pud, start);
> >  		if (pmd_none(*pmd))
> > -			if (alloc_pte_page(pmd))
> > +			if (alloc_pte_ptdesc(pmd))
> >  				return -1;
> >  
> >  		populate_pte(cpa, start, end, num_pages - cur_pages,
> > -- 
> > 2.52.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.

