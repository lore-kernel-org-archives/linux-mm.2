Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6985C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 11:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434BC6B0005; Sat, 27 Jun 2026 07:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BF16B0088; Sat, 27 Jun 2026 07:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349256B008A; Sat, 27 Jun 2026 07:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2C16B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:41:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8660E1A02FF
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 11:41:52 +0000 (UTC)
X-FDA: 84925503264.11.EC7D354
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9AD6740002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 11:41:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bGhlW43j;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782560510;
	b=NoRk82dgwdfc/zWlN/2vLC539Zp7g1SgORZROvFEmVK+IgMILRF63DDu8mQikklDs8fVic
	4kl8065ClFrOryIoAGSv45yFI238yADsCy8gcJpHddMdjWrrDML316ZvPMbgh4cVxVToHc
	9Eog9fKX0cXoYASZlc6AmVyLLgvU8sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782560510;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MsGEy5Adg9XX//QZzyVthhl1GGb0HZKXz/vMlwCOV0=;
	b=cqkmdRE+SqSswYA6ISoxR77rjqlXfd5yKNjuZ2O8S6HPf4Tz1sNWF+ba5RzS38i3RU1X2o
	0Oc/T4YZgMPkfUkYD6h9CjmAoU3RnkEOxCg9OmejKmYuO/RA1NaHk6+epv0LGF7h9KEF3S
	guqgnLCEgpGyx9kBQJhSOkDeMNMsGVw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bGhlW43j;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1214dc027cso191969566b.1
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782560509; x=1783165309; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MsGEy5Adg9XX//QZzyVthhl1GGb0HZKXz/vMlwCOV0=;
        b=bGhlW43jG6p2zaoI3XiIPWtdD15bpaScYBjf7LKS50g77xvm/UgHFuMiaFgvjB2NeJ
         qVMCOLBCxovbDh356KgdPHjg97HD4AA0Li9RTHvqVOfr3j0YLPOFUkh8phlvS0yb/1tw
         NLLcd0Mr57liEcYtVTsa1H236HfVZqyy/evss/AU2V/Rkro043/o5Lts4ASB7+FDbETZ
         nfH1nWTu0gx9M2ezcKukj9kJ/ZSqh9WaZcobXAWnm8gIKJWg8U+qXL0I2SsvwaIkb99+
         4TGkJUO1/ddzVgwJrQT/4/5tyAoGzfRcby5Yr4Llvi81DxoeIEt3b7n840tsWewnZxEV
         6mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782560509; x=1783165309;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MsGEy5Adg9XX//QZzyVthhl1GGb0HZKXz/vMlwCOV0=;
        b=F6hwVNYIx3/2yA8dClPQTPJp1RAeJ8AaQz2GAcvQOXL4RLLs9g/CznjSEdXtmCPAFT
         YvJrCpQOh1GfVVLiFf0rK2IzzTznGShLJAhmxJjeJw59Vgma9w4aUoKrWdDONnOZcnO4
         MJg9bs8V+XfH41uH9xOW4B9rdRHUFbiIx9P6h4FTZS3MVHTAzPEKrtmASoPMDARpAoWb
         FFihYWJxafJTS9gf9am3xHtCA95AxrTpbW6H996VOLBfSo8muBRhzOzt7LS7NeQT6xvo
         j+Wq/BdTbGMiHCImPNe1ls/2tFKXfI65omaVcrDqJyOmjajZ32MizKkKGWpyA5L/KQLE
         bEHw==
X-Forwarded-Encrypted: i=1; AHgh+RqKvZ5oB1UtwcfZ26uLdtSC7ZspTqdhFgQoiPSAYghlolHBtooeJ4jKXcnBSoJFwyaVTEEXRkKhCA==@kvack.org
X-Gm-Message-State: AOJu0Yxy0NqQeREy8L5YK9jbEgN8zSA2TEPqO/syVtxFb3I1roVM1iSr
	OjSOu16IORRr2sSX4rS+kYdR/lpXKa4VCo3A2JRGcXdpQr0iOODqYlas
X-Gm-Gg: AfdE7clf8MyjdtSXtlBhW8J4786XAXd7mHz1suUX45fhLQiZ7Wa8JtEkKadpud3j96y
	UYpLiner/wtgvEZ9nf2yGn4G/ZCkTcd3erydAYxdjyO0T1OfwzfdbWtoT7QFbZetL9N2gUcREPY
	3N8GJzJkLLvJJYyySPg17M/emEaG0DKHIRim5WPLq5n65WgXrXvKdIGok84ygngQvWpU+cxk7F+
	Tq8B0l68d4QiZj4fMLGbp450pEAJkgmuW7C4aairvGH58aPB4s5kWRSolzp511m0p7yp870TEjf
	if2GKSzBYpMwoUVE6cD7jm0gOzOPj8K7JoBRM5JKTI5SauHqipXQCyjsv3xJx1SCKezc9tfWHt6
	88mTkrO2TnKhQfs1vutKD7NLeKiq5NensmYladUcpJMX93I7g6uHHKhqk6MtKpGxtfcbkyiQ6Jy
	gqkrLqfzHh46I=
X-Received: by 2002:a17:907:c705:b0:c12:3d5e:65f8 with SMTP id a640c23a62f3a-c123d5e7db2mr75082266b.4.1782560508661;
        Sat, 27 Jun 2026 04:41:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbec3514sm467854066b.57.2026.06.27.04.41.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 27 Jun 2026 04:41:47 -0700 (PDT)
Date: Sat, 27 Jun 2026 11:41:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260627114147.d6csxmiha6whfyb2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <20260627020719.ipzfrlhfbvr6ac35@master>
 <b7cfc04e-7a57-489e-9459-82d7eb818675@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7cfc04e-7a57-489e-9459-82d7eb818675@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9AD6740002
X-Stat-Signature: 1jbr4gk8wyg7yr74sstqc4c1xkjhbo3m
X-HE-Tag: 1782560510-871899
X-HE-Meta: U2FsdGVkX19ty0Y0XtlYgaXvNVBJcNRkF31bFl8+dsWHijNAdraLJv9fmxn0haKleNm7V5cpBzw1Oycgz1Lb7q4cRLTYQBacW0JCe8BmVU1XpQT6rbkzxA/27CnfCVPnrOmAnaCIJQb4FSehaBc1e4EuJTemX8x4S5/D2JKKS3Nykt9QKmJc0Zc/sEKLo5mdjfu0QQjq9XnIv3eAeSlixvTKpi6PEGTuAXwWuLr6D6TNr691xzYhmZqJHKPku50EQpvkcpdtOFxmYbw9DQGbP/gsRurmH8wA8CE0/nPJAlyQ1S44XrmOUQUqrQR3nAzbaDQiNZZrCZHam5qmrNJUpAGsaNu5k+A9JY2VQC57yfmnU9JqhlPN1GxNaQGmQ8TCpDghKEX8e+JtNgaTqp2Qh2iOewPbIO8tw6gCZ087cOJcbMqzZqxZCHXrdPx8PM7Su69Cl+81jb7n157Swh8GzIn+dScxo6ZWAfoFweBRADdu2wjl5p+izh4JP65Q+bFKr4KbODOOjNMOKEO8NE93ady74cbkb7QdNkevJB+b1U0/+7jNOndI/VAhNBYYpkAeQM/DhbKKTjlG/pn3cZkSfZ32k5NsdmuJefFm0c6w8ICY6YjYx3n7UHE/1R2h8KzHFKd/Nb6KlrbhvjsZfe96g+3ekT6IBYGqWelugLY7d0wkVn0oBTKC8ALkVAOMYMMoIQoFYdxhALIvaXovOSz2xr3MDM4L6eQsD/5Y5zuz/AJPzaasgO41yF4zcuPmbvy9W6qGnlBGUAszEu/O5TaLCQ1PaiCCuNMZ3OMhtCj8TTA8+sunovrrZx7AiGPGMoYczUxzZHh+BNwD91vEHqJMgiQgYNGxgDJXUf/WlSxV9lu36NvGUxNng6jF9flRCMqtDDMbjbWxhCbXnQJjV4+7XftH2awv43BUadHyOQ6/tIltAY4k/NLlvTLAbE0PyaXxtQ5bZb0qnP7H2TM3l0o
 mGlYMuRR
 dnTgjXr/BjFW2Bwggvopcs1zyjPM9xlFIuDhG2W4eQL12qi1FNhuEOb1CfWoXIgwZXH1mDdppyn+dDYZvPI1D9IHnzLXpkJRWePRykQFbVP9ceW5R6bJeAHEgF/oXlRpw21efx8a1aRAY3osI1A3ssvxHqo4KqftWucANKLxgS4mUmaIf8e/BlYwrl65FGKQ3Lheq2R1q6Q0ANR4ET/wlW+3swFDr2XuaCFAdVwTiS4b/3L2yEMj/KOO3KX40/6fwKBfwfAr4g7c97SzPSAn2wNCWFKaN4stFuolqnYLz52eBI+/Jc0XPeGalw6kFRRcqpisHDwbOwthKkbyrGB0tibHFF1e6DPzGHUV04hNEbmf3xzI4OvWpAO5f5OI0POdqpU0190V3KXnxv46rwtM7jSqGsvsE74HxW7QdYRT26LkB1kC/mnhLD+3Gbzj5ygIGBTuAj2Jmtq4N4Y36iIgbMLTYqg7MXLm/a2nXEmZZ8vXH5HTVnOfl/veH2hVuIhpNLv+XQfwal77AZLmwhfv6utAt9bTcoTllZoMfuztcfRQHVl6GomtapKrM/W4fCMydgq/9Pz5Fbn4C6q/cC8dn7pX8m0+c11j421RBrsjocYLpkKe/+izLhRqaw7eNj3LaL/DQEBehHEPt73nYE9Y0HLV7nEce8haNwrYC/Yr2wUaU4Nas4lwCS6AuWxhipKMwcfIIVh8I4+j30UtSwODroS7crnAO6xXR00EaZapGE7oF1v3I3C9Mh4hyIypmUo9J5SQw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 10:59:16AM +0800, Lance Yang wrote:
>
>
>On 2026/6/27 10:07, Wei Yang wrote:
>[...]
>> 
>> Hi David
>> 
>> I did a little adjustment like below. Want to check with you at first.
>> 
>> > 
>> > >From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>> > From: "David Hildenbrand (Arm)" <david@kernel.org>
>> > Date: Fri, 26 Jun 2026 12:03:40 +0200
>> > Subject: [PATCH] tmp
>> > 
>> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> > ---
>> > mm/page_vma_mapped.c | 29 +++++++++++++++++------------
>> > 1 file changed, 17 insertions(+), 12 deletions(-)
>> > 
>> > diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> > index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>> > --- a/mm/page_vma_mapped.c
>> > +++ b/mm/page_vma_mapped.c
>> > @@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> > 		 */
>> > 		pmde = pmdp_get_lockless(pvmw->pmd);
>> > 
>> > -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>> > +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>> > +		    pmd_is_device_private_entry(pmde)) {
>> > 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> > 			pmde = *pvmw->pmd;
>> > -			if (!pmd_present(pmde)) {
>> > +			if (pmd_is_migration_entry(pmde)) {
>> > 				softleaf_t entry;
>> > 
>> 
>> How about:
>> 				const softleaf_t entry = softleaf_from_pmd(pmde);
>> 
>> > -				if (!thp_migration_supported() ||
>> > -				    !(pvmw->flags & PVMW_MIGRATION))
>> > +				if (!(pvmw->flags & PVMW_MIGRATION))
>> > 					return not_found(pvmw);
>> > 				entry = softleaf_from_pmd(pmde);
>> 
>> could be removed.
>> 
>> > +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> > +					return not_found(pvmw);
>> > +				return true;
>> > +			} else if (pmd_is_device_private_entry(pmde)) {
>> > +				softleaf_t entry;
>> 
>> The same.
>> 
>> > 
>> > -				if (!softleaf_is_migration(entry) ||
>> > -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>> > +				if (pvmw->flags & PVMW_MIGRATION)
>> > +					return not_found(pvmw);
>> > +				entry = softleaf_from_pmd(pmde);
>> > +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> > 					return not_found(pvmw);
>> > 				return true;
>> > +			} else if (!pmd_present(pmde) ){
>> > +				return not_found(pvmw);
>> > 			}
>> > 			if (likely(pmd_trans_huge(pmde))) {
>> > 				if (pvmw->flags & PVMW_MIGRATION)
>> 
>> How about merge this with above? And put at the first case?
>> 
>> Below is what it looks like:
>
>Why add more churn to a fix with a stable tag? Cleanup can come later no?
>

OK, will leave it for future cleanup.

-- 
Wei Yang
Help you, Help me

