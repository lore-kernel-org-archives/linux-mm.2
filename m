Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF28CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCD76B008A; Wed,  3 Jun 2026 08:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67236B008C; Wed,  3 Jun 2026 08:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E5E6B0092; Wed,  3 Jun 2026 08:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEDE6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:16:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B9181C02DD
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:16:18 +0000 (UTC)
X-FDA: 84838498836.09.B35E27D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id AEAAB40014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:16:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENoDXXJy;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNEtlb9dNSrrLzMMlCD/oxjjgcgHEDwsYx0ryDudzQI=;
	b=FeN+Dv4QAQGrP3D9nOhf4rUvamntupBeeDDNwrghrXefopNM4lgVbce0yfpghH9I1ciP+O
	SBGbgxdZo41P1t/qQSPsn+p3kBntuo8AhQ2SqEWClLkc8/uhrYbgWJnuS1Q7Bm08r8i9sG
	fQ41+Dlst2k5jJRNGpyXqspm0lXmsPQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENoDXXJy;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488975;
	b=WHcNTtn0kVXrNiu3RLPBfKmh2rCxp78vF/plCGDafAubx89J0mcrwzECCe9MmTKnvyWhEI
	EHIc+2MhxyD/p7S7gkPzxkOwZ/I2YiF0aEmLb+Yjo7X3Nu5DTa/m+zlaQYPnPKccyVo3QQ
	HCvWkpsW2vsK7ft35LR+XXF3XpPNWGk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780488975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNEtlb9dNSrrLzMMlCD/oxjjgcgHEDwsYx0ryDudzQI=;
	b=ENoDXXJygJMzCTYM6HIcPLyIHubSDtglALegnTLSmqCWSr24wbrg8FxVQjeNJQxiJb2+2W
	v8qQgRMoAiD/XRGpFLeRbqH+xOAlJ/N9fAgdGkzY1l5cwIiYGIXNoJinRgzBLZXjAuU9kS
	ixmjpWbO425DMdJElvBgU0feI7pcrT4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-wlqaPjbmOpyGkM4vBMI2KA-1; Wed, 03 Jun 2026 08:16:12 -0400
X-MC-Unique: wlqaPjbmOpyGkM4vBMI2KA-1
X-Mimecast-MFC-AGG-ID: wlqaPjbmOpyGkM4vBMI2KA_1780488971
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7dbe4c01345so7173957b3.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 05:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780488971; x=1781093771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wNEtlb9dNSrrLzMMlCD/oxjjgcgHEDwsYx0ryDudzQI=;
        b=BxESI+c4ZSomslxnBed/qj+20PDlyG+5h5ELUzSrJ0SRHwVnM1kaG3et7WFDFsefWb
         8QvTgmXTiK6KdPK41YB116x8dqPYzfVRgPdqHkEWEoDavd9re8QvUf++LBU9rI2n9MN7
         gAJOvUdmckJYBxaOuAHXAJA/RyyE8sZ8DdI/L5hpZcd2gvMBHEEQJSInZ1VkdqosRLKc
         EawObpwAXXuNWJqZ9ByYkvYP6WeZMl2Ct/pUCfHfeehWWCKcg8TPmLorbkCTIvfjPlz4
         ScEz1W3U5r+oQRrMU3GF0LmjopNWfS5my+G5sWTj+YWPr9+NL/5VPSAppULtP/F6bjsC
         wUlw==
X-Forwarded-Encrypted: i=1; AFNElJ/eHStbd8uhO9E+tskU5/1qFT6Mn5yqZA+Y+/CS7pTPs3KhWx5cIgXDzAflydzYjGNz8T6g82yEkg==@kvack.org
X-Gm-Message-State: AOJu0YzfdEhf3y1iQHGvCCs8DZwfFN4Z/8WWy1A5QLCBOGAQX2gwxe0w
	8fXLSmy4wb+4hHjP6FnuRW/WtL5wZlbYO/6uNQLxz6fg7+dYuEX3x7SVtOpvkPfZ/cD7Gugw+ak
	I1t5Aas9az+NAZVDHzRRaLTbEAHxlTrR6HjgCrpbkLGHzLsg1L73J/Gs1ShM+rVtQ8C0gmixCl5
	62gW92Qhk7AikT+Hqzbub/MTkk+KM=
X-Gm-Gg: Acq92OGk7+i8VGniC8aa/ZzVXkx4dRLkZk89ac3lJjWQAiMC5yP3ffVWkhw1bobPSfh
	/x0ZJ1ATmlghz8aopi4T4ky6dEQlgkrvATj5TyHqWy7mm4+lLkjTFLv2BJ1SIheW7EQHJsdHb9x
	imTt1M3JPN6UMTWbhr8vSvaK3SsCr0wCm9XSxDytbSHshIvopHX2MOpuxHal/LzXqb7N28GUQbo
	Sd5JNpKKjD7z3z6zg==
X-Received: by 2002:a05:690e:440c:b0:65c:58d2:18a5 with SMTP id 956f58d0204a3-660dcbf56cfmr1408273d50.41.1780488971400;
        Wed, 03 Jun 2026 05:16:11 -0700 (PDT)
X-Received: by 2002:a05:690e:440c:b0:65c:58d2:18a5 with SMTP id
 956f58d0204a3-660dcbf56cfmr1408255d50.41.1780488970976; Wed, 03 Jun 2026
 05:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org> <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
 <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org> <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
 <ef5c470f-3c32-418d-9566-17ec01b691bb@kernel.org>
In-Reply-To: <ef5c470f-3c32-418d-9566-17ec01b691bb@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 3 Jun 2026 06:16:52 -0600
X-Gm-Features: AVHnY4LAQaiaHNznOXVI6g4R-yc6NKejy8321oN1JhGLTXQQA6dG-VWPanP8lA0
Message-ID: <CAA1CXcD_Bz=Si+vP0Sg_FhAHVjbeAJ4VdvtWGM-jVYiRXFHAnw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com, 
	will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Usama Arif <usama.arif@linux.dev>, usamaarif642@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IAjPT7xWgPZkL5EGK1lel_3M0f1wB6LmWzISHpQdsnQ_1780488971
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEAAB40014
X-Stat-Signature: kgocx7c7wjc7c1433gqbouujnte7kcmt
X-Rspam-User: 
X-HE-Tag: 1780488975-604771
X-HE-Meta: U2FsdGVkX18Sx3SBPV2yj2tYueVXPrxiCQhbbr/kuZkX9UCf0wPYeQdpIda1NsmSO9KSAocVPYwwTbAwsvmpk1bq37GbuwtgIxGnpz5rzuouIHuGjjSyv/4nBSQu3l+yGYm00sEgrKEfz1JtFxvhFywgyESfSEhk1xrKH0LwgCx4vbnMYANYPMY2rRDqEUqtDa6fl6Cc1rL72R/wqKtfYj4LUanyval8yDrZwnPI8v1TmX5q/MWaCv/k8sChTmNHf8NlGI5mv67D3BW70aan7XRvsmU0E0xJ79FjiewU1urHL9V1pmcGbTBpqE+BVJbcWhXz6hD+Q1eW0I1bwGHG73cyoKkpCgg6ug92IyoNZeRcHuvvEWgS1y22ZQZ2gDFAK+ZYu4CR8Dqun5nZaaKkC9L0dl9vOFHLfRKkzZqWd6qccxW70o1U8kr0m256X7QklQFZaVasRZAh2QafHzcTeE555ufUN1I1dHNfGr/Sr5SmmFXZ5HDxSgBmJl/kfp7Vc9bTygOCiDFBtZMLCDmtJatuvIwrDvw4tGTjLizwRcWN++DiOmIRxWNp69iSf2+R02OIMLfcnIqlOu2BG5HlBO4xLErEBlnqrFLc/KHDKUkG1xoAE0oCJIxYHTlHZ2FRtwSH+IHjcRelQcC6sqwNDb6gJsGKU1IMAuTIqeSYhxHTzw1ueWQswWMpJx7JbQ+9d5GZ4j8PnT+vaR9L+agbi0TL3KBQ2DYQUn4rwzdVQSvBgEo6g3v3aNo12Dy4xwYImjDhX6asOuj4stWUJo4TwFSWGfB5wnHm87z8PSkSt1Hs2Rj6LPPRQjHEGG5gHojn9DTXXDg99JnoMZNr1bTPjA1JaWQi+4jRcWpDRMmlQ3MWjiNxM+BnbeY/Dep6YrzJo6qz4f+cYqNOFf80uR24TubL4/EfOfdEElCoQynSdrEv8LaY93zu2+Lo5w9kz/rJgwU4rA7+x0pXH77N1a6
 xtudLZ9M
 GhwvHDQ4NqjEhMnlu7cjwrkUh7mXUMfyReFM0U0xOizhXL/kg69cb46enLZ4X8dm7no/XX/ArzhlYp9E4rChKxvZxMcG3H4IEqO4msLUpt7aDizJX8zI2UykTi80XBL0eqqA+65SKXCTrENKAVnAYxdVjUa9AgNc+60T3IjO/sCylrzb/gGUzhxH5ynKbDIifn38jknmukGNAnXskvQuDFB4kllULk0RYMwvADhi5q7+5WFtkQe8/kIqOnBjNMjuSFCWA9dCY7xbdTPe3XSreBj+3CBViZ9MNv5KZc+5X2yS0XAIKszfPZJFlCqdByzwXsPiSr3ooROSR3VcOXSrHi5Q4WLg1NoGmw3UkUch4sx24zZF2tzlXpCAt2A9QxsN/Ip7xwdbawmhEDzSyYH3idNr1lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 4:01=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
>
> >  next_order:
> > -             if ((BIT(order) - 1) & enabled_orders) {
> > -                     const u8 next_order =3D order - 1;
> > -                     const u16 mid_offset =3D offset + (nr_ptes / 2);
> > -
> > -                     collapse_mthp_stack_push(cc, &stack_size, mid_off=
set,
> > -                                              next_order);
> > -                     collapse_mthp_stack_push(cc, &stack_size, offset,
> > -                                              next_order);
> > +             if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> > +                     (BIT(order) - 1) & enabled_orders) {
>
> Why not a test_bit() ?

The test bit is at the top of the loop. This adds a exit if the lower
orders are all disabled or we hit the last order.

>
>
> But, wouldn't you want to skip orders that are not enabled and try with t=
he next
> smaller one in any case before you advance the offset?

We are currently iterating through each order (not skipping them).
There may be optimizations to avoid iterating through every order
(like your changes suggest), but currently, every collapse, whether it
succeeds or fails at the bottom order, must also iterate the offset.

lmk if that makes sense!
-- Nico

>
> --
> Cheers,
>
> David
>


