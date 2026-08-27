Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0F3C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F596B008A; Thu, 27 Aug 2026 14:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D104A6B008C; Thu, 27 Aug 2026 14:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25C96B0092; Thu, 27 Aug 2026 14:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 993AB6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:50:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12039140182
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:50:34 +0000 (UTC)
X-FDA: 85147940388.27.8924F3F
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DD81180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:50:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SrI5cHEz;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787856632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msFJqjtLZA54o3SsVIL9LxyTHRQJCU32uWQJGDxK100=;
	b=O8gzP3UEeTTVuVZnDKse+4eHjj+6x7subqctuMOpSYzjLs6QWuL9WxZbRyPhAr9aHmO79o
	49qSAp2Guz1Kiu9ZyaRUHBtRc5BTwoqIvr4YgM4zKDceuiWEtJZZp8EWwMh71ffy9tAaTM
	zsf8o7tgJs0lKyDLE7VaEGt4jGEfJS8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SrI5cHEz;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787856632;
	b=3kR/+fZYkefN+Eliowgv7Ft2SBfvrgS0EZze8JyeLC7ANtYHrOcEbY4AWGNUHnbJ47LTxz
	LWfimk8VT7YL0/b/axOWLLoGJZovwzKDv/5GaqssSPkVIdeYUSA8r1lvkZsIylSOp7zm7p
	TuKcTM6NyZAfPfnQT628qcdaTGcpkZo=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8efef6533aaso2322716d6.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787856631; x=1788461431; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=msFJqjtLZA54o3SsVIL9LxyTHRQJCU32uWQJGDxK100=;
        b=SrI5cHEzuJIbPhjG/enFNMuWgy4COsgalWvx87B4KXJgHr+zQNwSXmxK7kFj9bDeoh
         e/1RfA1jjsYzaMtpZfXmAMecfB/dvdMy4L3Uciaui/VybHj1g9YerfIqN99M14bK0mRc
         0OPTNOXKMciq5fJJhsRqlImsVu1HJr0f5jMamIYC/Yk8745j0TCvt8YQEHx3KPtxmDrP
         qSzcWHZeBZSDaoTp80NHQrv1dCd4bur+lwRcUVkRZGkrV4jEOCT3YtTJIB+RUFWl6lRF
         BTaFm43ThrMzcPLTlXO5ZtCHYbLHagRK6o1/wxFHUXeor9cxjn3twrwkEuGAAIDSWN8C
         1ycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787856631; x=1788461431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=msFJqjtLZA54o3SsVIL9LxyTHRQJCU32uWQJGDxK100=;
        b=gflGP6PmI+/+XVmAcFQmOIfU6pNjQP+Flvw9dLA1o1tU4abyUxP90+tthUITe/+vAo
         bycficE1L0YRDJl7cvABClV7S8pGfVzYjI5CPldY12dUL4R9XUbdk/rf3NJG7RBYf2E6
         GRSmAZ4/q0kHvtfYT6AA/dZcmmFndKgHJWbb6rHyj36p8wxI2TTCd+Mx+/a8hWSO9XQF
         m5pH2dlWWzwGNIZk1qcCCkvUdzhvpsNZAhlNsG8oAYMvRVk8qM3OML5V8oZ8MZp4Oy9+
         0eB7amb9LvEux/lZSLl3awPFwuwhut45z54FImXvapq9WnvToGq3Yr0ATZSRsAjdPgjA
         UZ2g==
X-Gm-Message-State: AFuF++lh5TDUXtyMoUeoT94ZUkqDeVQ4UJENdOo/AZMl0Ax/I7ZqxPOE
	uYHlks7n9qVd4yUkCG2E0AjLjUmmXP8RxPL8MpTkStwSdd5fabMo9ogYxodtk0Mq3mM=
X-Gm-Gg: AR+sD11YY2mhVILIeN5YEe3TGv2tTr5a8Kp1x9WdmdTcoA5UilGOjH/O45biju5iuI0
	0+tiTSBpxsAnEvtvvkdRIVrAxpF5j9shJ47sVmjY38IW5fA5CtJya4RE8ANrBggRAMUeIVO+Sl1
	VfajkqerzcaIkHWdrC6nKrLMaB5pO2etozPEuvmoxYUJHtKP8NrO9xFInpBMR85lsfdJ2538gQ8
	o4gg/nfcT6f5xROJblk85lMXPf2JZc58bD6eKZDDWeo5h3lr7vLaWM/Hy+ttdflakNrbLSUId7p
	+bVaAgy3mco12ZIMeckVppxVxRh9X0lRVu0GMOUfVUnKUq5KYarYjPFFj19zwD1MdUyd3kMPS7i
	CFrXL8mZS97ZfV539Krsab3XD8WbHP1YtNPc03W3h7PbDggOSGaVr1r1/Vm7Yx5ap8I+udUIMy3
	fHVlrGxp3EhqFq6Tg6josMRi22J5Nh71GYhvgLWSsJxErNRCfNWAdOb/pgCPxmHIla5wBL95fPM
	OUa80Zx/LLRKeOrvYNra7dHx+d25ibdjB7CQXK3Oahj
X-Received: by 2002:a05:6214:5883:b0:90c:c6fd:e8fd with SMTP id 6a1803df08f44-90ce0c4348fmr19428846d6.2.1787856631396;
        Thu, 27 Aug 2026 11:50:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cd73e3261sm23067036d6.32.2026.08.27.11.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 11:50:30 -0700 (PDT)
Date: Thu, 27 Aug 2026 14:50:29 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/madvise: use vm_normal_folio_pmd() in
 cold/pageout PMD range
Message-ID: <apCGrJthAhZ_A1B6@gourry-fedora-PF4VCD3F>
References: <20260821144947.167382-1-gourry@gourry.net>
 <20260821144947.167382-3-gourry@gourry.net>
 <01865a13-2c18-464e-94eb-466613de7bb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01865a13-2c18-464e-94eb-466613de7bb3@kernel.org>
X-Stat-Signature: tz6ihgg6aabfwthym11gnfbhk59ca8ex
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DD81180006
X-Rspam-User: 
X-HE-Tag: 1787856632-987446
X-HE-Meta: U2FsdGVkX1/oFmyJPY+tInRqDrF4oLtj1/BLnoUPSaoutn5izu4avaWsFG68ykak9AiCUoTx30tWcU4q02CPuBxdce9WJ7cJ0uyyi6xdXssrqKApEAoIfucI2TV8tCAp6qNB7BPeuDbwn4V66NR+YZ+iU1BS+eq8ZuBz3D5FUd1NdHMP5we1XffhlpsFUT8KPndzjeZY+zwl9JmPdnm0n5IzMasiQLLhp/CWahh0lHIHUJOPrJCPIzy9bORWZC/FhzDQC+jeBiXnS8tf4vQBN0Sh5t989cdD0nuxCzq/HvDdO3ysNA5V2LBb1fWd0se4XjvEHbGXrDEw8Y1wQCbnFPkOX2wDOoDiFtL9+tWR6lfFJZh0WbfQAEnoFiFpMUP03q3n1giuObkP7NXDQYHjnAyhuU541AGZsafIIHaSPBtt3WWqKvsMxe8WG/nLkht5/hjU9WuRuO5l6H/VH4lTqH4wTkzpT3Ds8diHkqajjUSSgAM/TIc47sLXrNSeO/7CxM5HtSDD4bTD2FQ4k1hGY4vmiFbfQ8m2eppmJFP474enEXPLx7LwFr/0LDUH9Fod90hNMdZyeJFgnem6ArKnaeEMrfRmtPOLkRnlMS1U/dgIctPdGz1ifKMR5w7OMVVKznjaej0M35/H+q31H+ZdaUJEHcmB2dBkg52+O12bgTCwEsHr8X3MT6ra6ts90M3kxVUZRcaGWfCUFWGJ/H+w/AQfG3ZmzyTODOw+8JDSypZCjCCdkRDlaRPettfIDYZ+WC+mRX1SNvhNjE1xZBq0ZIEvTGdZ4zXDE0zfDFwy1v9pSvc5oH/lsMmQMSb79BjRRMXPAhxZZVr3nJCsRTs3UEI37e5NrhC7Ylilo0wDJRyCAgCnMgS71YGffa5VAty9FfqT9TXxjNBJ8Vz1/xn36tlB86wYKzkpAu9AWem2IB4qAsTEQ6mRcCnPx1jYPeSbtm8R/BrnpA03YOzXDZ7
 5uog5mPT
 EnUNopxijzTmuU5wBkdT+y8b0nzbDaUYMlofunU8yMY28XP5YMmvn6+ckFG50Guuqf9MmsK2izegBXNUBwfGUaUzq7RUgTckYTUKvS53kqyZYi4r2cCzmAy3HCClimqygbwW3BgtV84XAwoO7K5OdExglQVK/ZItMw0+lNpS1wkuLkua77BsI6HSPwgpcJLWb1HaqiQnWovMclHziNLgAIyqinRlDSWmqU2+jz5UNwrD4EKvmc+bSEtiDWOuo7sUBmmyOMqs61XAh0ERyhZvEX92Qcmd3GcfQhgg02jykNgMBNAsdExDHfeFi21kg8L158oFhugARBLWIEeCD3zfMVcQ5ZjaLogMIeuHvMJFcCkJfM6At933AeffThRDvC2wU/J2clDiQMZfabggUA7dVbpubABzx/U7JOH85EMFWPCJP2e0iDQD47mZwyLg6CD9LZn1fEg8accU5X4M7IJE2Q9Q6GPDjq+RgQsZEvQDAMT2RkxP2SfV8/d6YUxZzGM3QZ07KG8q7x1MYcWmrtIIxKu+c67ihhK2KwuE4cJqrULLWG8RvEaPlrdJ9L/SetRgDpX2p/37e2bIJqaIsdOiiNVleAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 07:07:38PM +0200, David Hildenbrand (Arm) wrote:
> On 8/21/26 16:49, Gregory Price wrote:
> > 
> > Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> > Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> > Cc: <stable@vger.kernel.org> # v6.19+
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  mm/madvise.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index ffd6a68320a8..ab362bc482a5 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -393,7 +393,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  			goto huge_unlock;
> >  		}
> >  
> > -		folio = pmd_folio(orig_pmd);
> > +		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> > +		if (!folio)
> > +			goto huge_unlock;
> I think you can now drop the is_huge_zero_pmd() check, because
> !vm_normal_folio_pmd() includes the huge zero folio.
> 

I was err'ing on the side of not removing existing checks, but I can
take a look.  Trivilially - I think you are right.

~Gregory

