Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14446CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F48A6B0005; Thu, 28 May 2026 13:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB786B008A; Thu, 28 May 2026 13:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1846B008C; Thu, 28 May 2026 13:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0BC6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:11:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEC871A010B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:11:17 +0000 (UTC)
X-FDA: 84817469394.02.4E3D01F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 690C44000E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:11:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hF3g3JtQ;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779988275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ihUpxCim2Hwyu43MMJlIX4H1ID4hW1kFB98h6S7dK8=;
	b=CUNO2F6nuFnOwRqcHDjXFgzwEnuk4blpNKCq6cA2cN5JgAkrpMRWHuWdZrrCXXmAggW89T
	KyzvDReSA4b0zl7KTxA8pyyrC6B83ktfh80s4u5wD8ltj+pyephz5uOfqYDcgEQv7vuxHt
	aChOZzghVAhss+ms+o29MRJ/pKSLEpI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hF3g3JtQ;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779988275; a=rsa-sha256;
	cv=none;
	b=x2xfwAaPDgxXm3YmW33v1pYVTLTxDfKHpQcT4IcalNkCS53nmYnEf2iYkAOuXjCDr+79wO
	LAr2t0vgHD00oIe45usGGcahOO96W42Sk+iNY6c5caQKb8BG8iEdIIgDUvLrpmrF1xumz1
	polkgNjJDZ+35r/2SdNTRh6VwMb5eOo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779988274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ihUpxCim2Hwyu43MMJlIX4H1ID4hW1kFB98h6S7dK8=;
	b=hF3g3JtQpCeEN8y62CVzZdM1xjaXNQcBrB6bdRO50AlmUJHdNyeJC/T9Le4VSqJVMcbSn5
	FMunuxLkFN/fzHVbiH8eEOm0G7/Vh88+jeGIFlxr/1uAbPxrRcvr7en6EqnHBRA032nkfe
	RQoI52B9FdhIOognYw2M5FqJkjTCpVs=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-mmN375B5MPGaxs0GZwmnzA-1; Thu, 28 May 2026 13:11:13 -0400
X-MC-Unique: mmN375B5MPGaxs0GZwmnzA-1
X-Mimecast-MFC-AGG-ID: mmN375B5MPGaxs0GZwmnzA_1779988272
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-65c65a0bec2so19000496d50.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 10:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779988272; x=1780593072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ihUpxCim2Hwyu43MMJlIX4H1ID4hW1kFB98h6S7dK8=;
        b=mDcMf6PGDc8pm/VgHQbyiH8lfHdPiNS4J7WdBUESuWMhcOl5ZXXlaozQC6tT2Y6d80
         fHTEDyBGm+ipq17Gumy4lMZ4q0NRwm6BaArX6pP5HYciwJCYcPYdOEaf8LHsYDOBqrC8
         Dz+Qgpn/BHdgRhE4mmCBAEuRqF69ec9NZmE8LKS9bM9JrmjlNNnBvHbBLtj9ktcwS1Ya
         lmM32s+MSqboLjEve6gp8TVE3p0xxQ8KphGLNn0EQX6oo/oqHkNoPhhwLBDhcmppKEBI
         duxHImh4GeOL7bAcPttX0Zc4IiOkjRwVtbN2sGH6+DwROqOE0mRfrXEZwr6nDqkyn//K
         pObA==
X-Forwarded-Encrypted: i=1; AFNElJ++07fC235VEcz6HYaHA2F4SpbhRRy81cO5cr1v7h4s/FQxoLMDvMTBztSLFES5VXmn49xB5R/NpA==@kvack.org
X-Gm-Message-State: AOJu0Yy8u1hY0xW8C8fFnSg8cVLPg9XrCIj8ugQedng9oSUPF8wLkajs
	5W979UG/ZJr+D+kGckz+KapyGbiPceLzy8eYlTiXnOPqwzJdDKA+pqvwHVLr8LetgjCRVdYTvRq
	tEHy6weazdGvuzsPfFboO3fLgF11g+Ypi2JiNyezcPlOPwlCid+mYWkWKmRTJGZGoTWdKBnMnw/
	RUoz2HN1YscCvPNJj4uq9kGSwOl5w=
X-Gm-Gg: Acq92OH2r5oEG3f5ztXRTnp411KuQsXwAGrNVBu7/fD5r/85k7QlL4zYurbDNgz5tjQ
	fW+IplRIaTjuUsQ0WBXF0F3xDzZPo2PSVcEQB88EoRq70x73ESydOwWCeiesVCxVON68YKBs7/V
	2KH33m9dsGCX0DMnalkuadyy5C5ZeDWanFKLh1LbNYTb9LdiX8zspfRH65WftPUzJldaZM0Ex//
	B+iFMQW4OOZAYmq
X-Received: by 2002:a05:690e:1544:10b0:65d:bf4b:f16b with SMTP id 956f58d0204a3-65ec96129d6mr21884147d50.3.1779988272429;
        Thu, 28 May 2026 10:11:12 -0700 (PDT)
X-Received: by 2002:a05:690e:1544:10b0:65d:bf4b:f16b with SMTP id
 956f58d0204a3-65ec96129d6mr21884113d50.3.1779988271977; Thu, 28 May 2026
 10:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-12-npache@redhat.com>
 <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com> <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
 <20260526065708.oyyddmt2zgfwu2q7@master> <CAA1CXcDXyDhMyiVAb8XbusqMU10JXA8nOUw6b4_2i9H-kV2vwQ@mail.gmail.com>
 <20260528084211.wsdrvbvxvkddokb5@master>
In-Reply-To: <20260528084211.wsdrvbvxvkddokb5@master>
From: Nico Pache <npache@redhat.com>
Date: Thu, 28 May 2026 11:11:47 -0600
X-Gm-Features: AVHnY4Ix-JM5FCWg2fh8KtuGbuZClmx1qOAN3nLQNHVscERKje9jLsvBNl47yHQ
Message-ID: <CAA1CXcDSuD8D8S98=-zqh12CwrD8dATpzaV+usNvgF-RC-anvg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fLfXar-ui_aZ7uGMacXfAea7zKkRgdpnaZTRB6qBxug_1779988272
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 690C44000E
X-Stat-Signature: bk9owot7qokyydae6i6zbxni5f8pcdtw
X-HE-Tag: 1779988275-241500
X-HE-Meta: U2FsdGVkX1/VksFRasbFcIVOULSgTIypUUfM+ZsshmGYfACjW3NaDWK4uij4ZNnkqrjsL3OVT7ntQ5OSQ44pVyFrgxRwWMOF1b77v7QwwXxEhlzJav3aK4zB0SF+ANkRHvDyjXLlWISpQocwJZhUDvDJh7fywv+g8+r1oMZjFlQK7OZC6D5Gg1gHQloancbRfA6qYIlH0YvKWoQq9B3wpxNxHBtbg1EaAGcf1mnkXFFs8m63QAZn03GOOLDtTMrCCnYRDyfwc7wWAsDG/U0zhefYswB4pPZSSm5zBf6sux+Mn+VHiVjboqEkH+U2hXruquR8nZdB4yMyhIiUMaQXXYmfKbcbD4O1Ai9FjhmtM1D+lwQlbYoYLine+zzDy4oCPutdtH3/xfao/k0t5wj5jxUCMkzbZQ3hA2lXpLD4lK9ubLySL2TxDwJdB1GIQ9eDKpSiUlTwdD337NH8tv9YIkZ/1w6s6xrqYxNJl0FKhx4EtVyix466PKXjorLGmKacQc2Qjgcre0sagu+by/+QI5xp85bH/668zqa//K8HogtmwylvPofoDmUyUdkSb/LsZi4ixHsHSHmR061uh66k4H1zo5z/vqnsbqcLDFMjNtO+aPRv+LqUsUEYHdiGBEdeUpIplw8RS7+1cw2STls3XnACsI4QDXWLg7RQPOHWgosGFqmRWp8AKCreLw+uP3mHO6O3aB0+EBdT3YI797lAWng19vPJI2boc4L6Mz39772KuTgd31Ulfm+/D3db91OFDqstk1Qw8mTgesmE2XUGCSeijWpD5hSA/pTOjruuVTvHKqsw7dwhY/MO3upPJCQW6yAoMd1cg8qV817MZ5EWaU6X53UCPrbSh1tmcSCfQbVuKWmzhGs6m37svKLE74BQVFImb2Y99j3VyAdO6gHX//cpZxkcAnMowX1Wkz1UZ6U65sPeSJ5a72d5XfGprXhylGA7MH4qSKFvB/2kQXD
 cSKwFLde
 iy1XcocqVbHq1cUoD+CVjHZ89En/xCLF+qECMHrC153qgLdh8/w0/ZChqVfwfdbMb/P0C6fq6OhQN3KfDSA1wginWBBosk7AW5Ym9LhVyWBsW0WogcHArZ/sTCY/t5xkXSM4JO+QOdloNdKh800OtfyEH/G/YwncIiXqC0x5yyJ3+Mr+2AX6o5nY87HdX0b2wtrSuXuNddC48XcGo696+IaG00/DR/dfQNtMmKxeIWTLeNROR1D8NRbcvy5zyCyN13rZ91YyAF3YCjLz+vc1q6OnxRW5X1iqqaVG66dC5ls1VQUnKh+jHXEp/oxTZ1a4ZcN4hG7i7J5q9Jdx/KBn18YE2XptqRxPDhMNbCwtS5bR0R7M2dEU2d6S7kejFPMq+5z3KWDc7JRuRBIJDUa9jBpXYXBKS9eGGP8LB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 2:42=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Tue, May 26, 2026 at 06:07:38AM -0600, Nico Pache wrote:
> >On Tue, May 26, 2026 at 12:57=E2=80=AFAM Wei Yang <richard.weiyang@gmail=
.com> wrote:
> >>
> >> On Mon, May 25, 2026 at 12:10:41PM -0700, Andrew Morton wrote:
> >> >On Mon, 25 May 2026 08:15:53 -0600 Nico Pache <npache@redhat.com> wro=
te:
> >> >
> >> >> Can you please append the following fixup that reverts one of the
> >> >> changes requested in V17. The issue with the change is described
> >> >> below.
> >> >
> >> >OK.  fyi, what I received was badly mangled: wordwrapping, tabs messe=
d
> >> >up, etc.
> >> >
> >> >Here's my reconstruction:
> >> >
> >>
> >> Hi, Nico
> >>
> >> I tried to reply your mail, but found it has some encoding problem, so=
 reply
> >> here.
> >
> >Yeah sorry I didnt properly configure my email client after getting a
> >new laptop.
> >
> >>
> >> >
> >> >Author: Nico Pache <npache@redhat.com>
> >> >Subject: fix potential use-after-free of vma in mthp_collapse()
> >> >Date: Mon May 25 07:38:59 2026 -0600
> >> >
> >> >Between V17 and v18, one reviewer (Wei) brought up that we are not do=
ing
> >> >the uffd-armed check until deep in the collapse operation.  While not
> >> >functionally incorrect, it can lead to unnecessary work.
> >>
> >> So we decide to tolerate the behavioral change?
> >
> >Yes, I believe it is ok for now. Either way we needed to remove the
> >potential UAF. It only affects the behavior if mTHP is enabled, so the
> >legacy behavior is kept. And the uffd case is limited.
> >
> >My future work involves further optimizing and cleaning up khugepaged.
> >I'll make this part of the goal too. My first thought is to do the
> >revalidation at every order (between the locks dropping); but that
> >essentially pays the same penalty... I can't think of a clean solution
> >at the moment.
>
> One way come into my mind is add a @was_uffd_armed field in collapse_cont=
rol
> and updates it in hugepage_vma_revalidate() when latest vma is retrieved.
>
> Still not elegant enough.

So our issue is that userfaultfd_armed is at the VMA granularity.
Ideally we want PMD/PTE granularity, but we only have that for wp. I'm
just still investigating all the nuances of uffd and its interactions
with khugepaged (something I've been meaning to understand more of
anyway). But from what i understand so far we actually can use the
bitmap and the was_uffd_armed to optimize this further. It solves the
issue and has a rather small race window, which can just be handled by
the revalidation later on, probably eliminating most of the potential
cases.

IIUC, filling a region with previously empty/zero pages is only an
issue for MODE_MISSING and MODE_WP with WP_UNPOPULATED set as well. I
have a work in progress commit to improve all this uffd handling.

I think what i have is a good middle ground. It improves the current
functionality and closes this gap we have with the new mthp_collapse--
best of both worlds. If the race window is hit, we will pay the
penalty, but that should be greatly reduced. I will send out an RFC
for this targeting mm-new once I have everything verified and cleaned
up :)

Cheers,
-- Nico



>
> >
> >Does that sound ok?
> >
>
> Not sure. I can't imagine the impact it would have.
>
> >Cheers,
> >-- Nico
>
>
> --
> Wei Yang
> Help you, Help me
>


