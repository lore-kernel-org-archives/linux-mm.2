Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD666CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 19:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5138E0021; Fri, 10 Oct 2025 15:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCDA8E000A; Fri, 10 Oct 2025 15:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2798E0021; Fri, 10 Oct 2025 15:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0028E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:55:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D804B140201
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 19:55:20 +0000 (UTC)
X-FDA: 83983258800.08.185E3D4
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf04.hostedemail.com (Postfix) with ESMTP id 804BE40010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 19:55:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=i7QtjhtD;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf04.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760126118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPhA/oNdZoYVHAUf6Erq79uJcMcXf1/DDMPMdaotDWc=;
	b=as/F4cdISk4AOQKa+mi6hJkQ3W4D7szoR1XJgBunjbZBVmqwIECLkNh2AKDu3i7GnlxAfu
	XWkDZ2FEReiGFOZO02q1fuAZBMpd8o8afaqteAJmSg7O0/B7hGF4ODc0cXqW0HT9B0XQ/X
	01UaSVYW2idSKBfuvQWgRQykMb9B8Hc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760126118; a=rsa-sha256;
	cv=none;
	b=3iQUxZDaFANXGpmqS+4IGSpZkRBpAmSrXytR1N3AuCHdiYp5xczjlUBKgz9uiYrXuOWd3b
	MZJG7FaXxVXuHJ1roKqmN/ecmuA8AcANg9ib8PJcQ34+JLiLMREZRh9cKR0rqmBMXieN06
	LSDxz27nGZvDfrH3xuo+wFSo7/vORbE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=i7QtjhtD;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf04.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 598903F7D9
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1760126114;
	bh=kPhA/oNdZoYVHAUf6Erq79uJcMcXf1/DDMPMdaotDWc=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=i7QtjhtDDDMyUzT0k9YybFFk4K9MHOcnmTAcstEnRpga5gtMVMbCUSDlLEq+eUhqJ
	 5XQs+Wzu08h9HHpsIaoBx9RyIBnQmfEqdiswLx1tQe8Fh3hUKDyHn4kgLdx34iNOYd
	 4sREcbUAvIGp1Q5/UQLoDscAkr88ILh3H8F8QhCMG2VmXvJBR6q2LPNEZqiIETnW1m
	 p8gCpO4q7QNq59dSSstPgEt5mM5nJMXid+OdX/c7IbSfVs2zFWxm6oU0Duqg8g+fO8
	 Xts00WvyiD/tOMfGFpwuHM3cKfyRZKYokrdWS7OINvuN20mri60o1Vu1m0rNOdnJmJ
	 jORswfSkjfX2SvtAKo2d9GMmjwcL/g96QaJHsKgt8bK6IUZHYgqCCPmoKP+kIMcN2q
	 aM5I3N5CBgFntyBuwwfpDBREanOD0BSCme1qS31GGNdnATQ48O04Mnrnt3muTqF0cM
	 zzkR8iioGvqRILvj0qY+p3creBeGqfhrF8MjKBLbVUH7jRJrsAvbTgKEGHCA0Ll2jQ
	 x65016tuyIbY/08hljj7SME88bxxODGwWvCUcjXd3sSrGxkM8ICfjREJ2MMFHGTB0y
	 yhxbaSDwJmNg67tDsOTl1eNsMTP3jMnC//LnV1k5DzajF5lGyNPTTmNeUicFkvfrzB
	 iIGjMlvVta1eEmPjJgjxYa8A=
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-50f890ddef8so1844549137.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760126113; x=1760730913;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPhA/oNdZoYVHAUf6Erq79uJcMcXf1/DDMPMdaotDWc=;
        b=tc8dCYy05LaUttUA+Hrxfx1CdH0f6lHHWYqgbz7EO9qzE/6QHiGYDo17BtTKM7e8nM
         IZ7OfeoVpRxf9/qGSFqlqVG7DNW5RCWfgqLiKrZDb6nGPdRNpLDgjSsHIFBl+gCQf/c/
         F/KfjX9BChJ46y/kmnIfTQcYRbsgs7LhM3JkatdX/cigXUPCQi88WTLSEjDR6YHNTgwq
         pxif9xv9NWJt8H4cCUw6naTl5vH0uLwPI3EBSJvK2sPQuQ+ykd8DEq9LKVVsOKo7DVdp
         155O5av6mi7jiKE5Jy5V7R0D1Y546sS16Jr8bV95/poyk1Cc1Z6jwCxxg2LkuCzWFyt+
         7uWw==
X-Forwarded-Encrypted: i=1; AJvYcCVQ6JF6t9X+vadgPte/9MDaaSF9sIpNuFkK26tcdjLkjaJRzO0zIi30+apG8qWuD5OuilJ7PEv44w==@kvack.org
X-Gm-Message-State: AOJu0YxoFN0c/CjgM8Us9wzWRC6noaGGNbcbHeQkeS9xBHy1t7HuBvyY
	/AWDos7Cm5kLp5eXctr+espk0G/7IfnBkadMdiSbh86YUNbtmxsjIkhzziv/72NrjfSrwrSjFA1
	fVmOQOF4jSr/3gdSmibXxPJaBB+PralXLVOekFDZtmBphkHKLvO7v+87UPdadXVqxLPBaH60epZ
	57b+be2Km4bhHVFb39m5e1PgrwZjcHXEQWi0oFykWusoA=
X-Gm-Gg: ASbGnct3vBslIsqcRoPP+sQLjg7xk5YyKY6lSVUlXXubETFq3ksX1bmewpSmU42Hw5A
	6KoBNoUJGz/rZtSMiVk8ZOhdIonIm4Hp4GLB2zgDQtimRFXCdaarEY+cxB2Rj0E0c4kfIVofx8k
	ryCfXXeT6Q/j/zrlJ/jCE=
X-Received: by 2002:a05:6102:162c:b0:5d5:f6ae:74b4 with SMTP id ada2fe7eead31-5d5f6ae7587mr2959674137.40.1760126113160;
        Fri, 10 Oct 2025 12:55:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl7uSNVMd1/CraY5eNdtkJsmXLfjZq71soXKG1D0wdaThXC8TnpM49Ya9Dq+mRSUiBMq5+qPE5yVu6PxXKKHU=
X-Received: by 2002:a05:6102:162c:b0:5d5:f6ae:74b4 with SMTP id
 ada2fe7eead31-5d5f6ae7587mr2959658137.40.1760126112724; Fri, 10 Oct 2025
 12:55:12 -0700 (PDT)
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 14:55:12 -0500
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 14:55:12 -0500
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
In-Reply-To: <178f4daf-c752-457b-8f0c-c6273f3a63dd@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-17-samuel.holland@sifive.com> <CAJM55Z9kRpc53s3Kip=U-CcDxAX0UZD5AbTBy_owU8xPEYH5MA@mail.gmail.com>
 <6fa3c728-5048-4d26-9b6f-21757320caad@sifive.com> <CAJM55Z8masgGn4vVe_2g1e9WXnLu0Vf5oGxbiniGpsbOhYPLRw@mail.gmail.com>
 <178f4daf-c752-457b-8f0c-c6273f3a63dd@sifive.com>
Mime-Version: 1.0
Date: Fri, 10 Oct 2025 14:55:12 -0500
X-Gm-Features: AS18NWAlCRC7l99R73r3woSIp-vlQ76Jq27BWW9v6hsv7x0ENpHaGmY-XmjOCps
Message-ID: <CAJM55Z_wOkC767T1p749aVzAL5uQD5Lw6D6eqHb9wp-f=nAO0g@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] riscv: mm: Use physical memory aliases to apply PMAs
To: Samuel Holland <samuel.holland@sifive.com>, 
	Emil Renner Berthing <emil.renner.berthing@canonical.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Conor Dooley <conor@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Emil Renner Berthing <kernel@esmil.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: wbsto1g9kehbdtn9gx6whkfpbq8wxr5w
X-Rspam-User: 
X-Rspamd-Queue-Id: 804BE40010
X-HE-Tag: 1760126118-916445
X-HE-Meta: U2FsdGVkX18qb3/apUNq+cA8U3WmN/6ZwO5RqnK8zTwImvI6SmU7uj7cnCVYbRJI17xrSfmNHc9qPvE6c4YSV5ODdxzpIiD4X+hSincWB+KEQ1mKcLwMAXvCHk7y+XEw14lq3FmWKIeJziK1kPAHuN1GMWBqivc2OD4MXwsXfiaaX74soBB0YLWqHd4BmOiDApObRMgDA8k+UE7nMyWV9/J9PrZr0abyQsgTPTqU/HZNDZoV34JihmpZTXAlzjrcqmN8z1+mfqwoDx7+ZOhlNsKu5QEN6EJVzadjcgSbC3W81UiI3WFg0QMT8eEPMi3xfDw/6NJNteYqf8hBs+xBDuLDCkYrLM9fae01rponeV9OPRwMDCqN09n6SvVS97964PADhe/63jLkj/thGhxMB0Kjk/aBm+YpM5Zq/j6kmZwy554SlT1srv4ubQrml6Hq0e7HyMINECaQf6paoK6pE3dtAcoDbc6S7SUYdRW8xhmrw6voWXMjd0TXeZMvyIB7YIL/RkgfWR2A+CRnRnba5HC/DkNCdWcHN8hvcSshOp8iQXPLoKmNDmg30vv3LGJh/jSnuj+BJRTCW2dy32an4LsYTiQ2LAtO7fpjGAbBeN2I1j8fX8c02l6gndt0LWKK33ovFtK+nj6oI/AGWHlFWWzjS1mCgW07a5OBlbT4PIFFFZa/6leiNiDqSaYdcibzGK2cvBx7HseXF7jJpn+uYLOzHCgn1X1aoKjDJUvv4kS/zcRtmN8aCy8VT1gY5e2K47qBnxjdIGNtjAYQkpHIr3zf37ad16g2ytUFtFxoGUz0YYXWkoNnzFI51vdjtPsEq/JCLLfndVqR0b2U/vaBcG9FXzzKxxsWeyK2hd+LpoavSX5scJ0XxjmAhJsUB8OZMt+SUYd47srWPP5pfhYpqhzMNvfwz7tGEWagZfmWJgpYS2TCWMcb+fVW1wofG+3LodOm7luIpxIFOlEJj9L
 8iQ/+bEu
 yL0jfoWthJk9cdv1dmGh+Uzju/IWeN9N4UHgBafPipGUG3xp/yktBLLt5V3EA6OOnscT6/k51sdA+/l5eaxnvs/j+90J+FgpLQzabOr7ESGsZBwMunz6aXV34VULlwHjVGKrX48uO0JoVjurPujVFBb49H7BPZYfqIjICB+9xnX/3cz++K5uO8g6pvmqGOttWpaBc7xul1Lwyute60ZjchIHuqvS15NGN92nfeHMECfFiB899ObYmIog+wERij5vwJFe3+8AiFG57VJXMj5Q9chemiNVst9tSU+k9eupmzzX9sdU2TVg0TW62IsW9r2gD6tftvmC4PLogS9NsORZpmdZGWaYyAiPd2U3EOjlSayVXv4Bk447CuZsq/93tF5RmQQIQreQLPpVEEZclYqMdIcuuiMlViQaba2DDp538ggMfsws06jgxs9onbx1G16cVGobS3fQStYTlfcR7hFXHTZp5S8chi2vASSNB9kswznXTh7NihugwIryhGQAowZmLxkXl0ZdT5O4V/T3m+WarpDgUVcAkl5d2qiP0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Samuel Holland wrote:
> On 2025-10-10 12:04 PM, Emil Renner Berthing wrote:
> > Samuel Holland wrote:
> >> Hi Emil,
> >>
> >> Thanks for testing!
> >>
> >> On 2025-10-10 10:06 AM, Emil Renner Berthing wrote:
> >>> Samuel Holland wrote:
> > [ .. ]
> >>>> +
> >>>> +void __init riscv_init_memory_alias(void)
> >>>> +{
> >>>> +	int na = of_n_addr_cells(of_root);
> >>>> +	int ns = of_n_size_cells(of_root);
> >>>> +	int nc = na + ns + 2;
> >>>> +	const __be32 *prop;
> >>>> +	int pairs = 0;
> >>>> +	int len;
> >>>> +
> >>>> +	prop = of_get_property(of_root, "riscv,physical-memory-regions", &len);
> >>>> +	if (!prop)
> >>>> +		return;
> >>>> +
> >>>> +	len /= sizeof(__be32);
> >>>> +	for (int i = 0; len >= nc; i++, prop += nc, len -= nc) {
> >>>> +		unsigned long base = of_read_ulong(prop, na);
> >>>> +		unsigned long size = of_read_ulong(prop + na, ns);
> >>>> +		unsigned long flags = be32_to_cpup(prop + na + ns);
> >>>> +		struct memory_alias_pair *pair;
> >>>> +		int alias;
> >>>> +
> >>>> +		/* We only care about non-coherent memory. */
> >>>> +		if ((flags & PMA_ORDER_MASK) != PMA_ORDER_MEMORY || (flags & PMA_COHERENT))
> >>>> +			continue;
> >>>> +
> >>>> +		/* The cacheable alias must be usable memory. */
> >>>> +		if ((flags & PMA_CACHEABLE) &&
> >>>> +		    !memblock_overlaps_region(&memblock.memory, base, size))
> >>>> +			continue;
> >>>> +
> >>>> +		alias = FIELD_GET(PMR_ALIAS_MASK, flags);
> >>>> +		if (alias) {
> >>>> +			pair = NULL;
> >>>> +			for (int j = 0; j < pairs; j++) {
> >>>> +				if (alias == memory_alias_pairs[j].index) {
> >>>> +					pair = &memory_alias_pairs[j];
> >>>> +					break;
> >>>> +				}
> >>>> +			}
> >>>> +			if (!pair)
> >>>> +				continue;
> >>>> +		} else {
> >>>> +			/* Leave room for the null sentinel. */
> >>>> +			if (pairs == ARRAY_SIZE(memory_alias_pairs) - 1)
> >>>> +				continue;
> >>>> +			pair = &memory_alias_pairs[pairs++];
> >>>> +			pair->index = i;
> >>>
> >>> I think this needs to be pair->index = i + 1, so PMA_ALIAS(1) can refer to the
> >>> first entry (i = 0).
> >>
> >> The code here is as intended. It's the PMA_ALIAS(1) in the DT that I should have
> >> changed to PMA_ALIAS(0) after I removed the special first entry from the
> >> riscv,physical-memory-regions property. Patch 18 also needs this fix.
> >
> > Hmm.. that doesn't quite work for me though. Then the "if (alias)" above won't
> > trigger with PMR_ALIAS(0) right?
>
> Yes, you're right. My fault for trying to be clever last time, where the special
> first entry meant PMR_ALIAS(0) would never be used. (And for not testing with
> the same DT as I sent, since EIC7700 needs downstream DT changes to integrate
> noncoherent peripherals.)
>
> For v3, I plan to make PMR_ALIAS(0) set a flag so it will be distinct from lack
> of PMR_ALIAS, and keep the indexes zero-based. For now, you should be able to
> test by keeping PMR_ALIAS(1) and adding a dummy entry at the beginning (for
> example by copying the first entry).

Great that also works. To be clear the JH7100 also boots with the pair->index =
i + 1 solution above.

