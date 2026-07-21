Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AB5C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836C36B007B; Tue, 21 Jul 2026 01:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8B16B0092; Tue, 21 Jul 2026 01:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA196B0093; Tue, 21 Jul 2026 01:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF786B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:02:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0B691A03C8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:02:41 +0000 (UTC)
X-FDA: 85011588522.15.5C84210
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id C1C93100004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:02:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EV2/+0E+";
	spf=pass (imf05.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784610159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVYv1jY6vQm8iou0Tx0bNvdZzW73gw/syVItxV6jH04=;
	b=bohAp8+Cqvgl4seqTpxEGabqiiRCnVTLJdXv6GA1DbnA3bNPIqzK2j53YELYa6Kqz8UMAS
	tDybdegLpNnQe2bM1jNbXDXGyBSi+m38i5ixY2IZsDoFGmC3uUEGGgRekF4WqL7nCJEla5
	Hsues19kL3MMxNSN4yqRaYKuVYBAzs0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784610159;
	b=M4xO2HcLHZvDBl1Eo1fapVjyMASrpZxMvtfOrKN5/R+YlCgUxYnjsixvVtQaqmxw0KTLBg
	iL/Kcc6nzA9k9VNNPbaina+igP7aBh1PYK/nro+hQ4XgtS06roGed/PWV6+nQ5Prq6m1La
	NFBL74B8ULYtgbUXsLRrqU3wQ575mUk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EV2/+0E+";
	spf=pass (imf05.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b020a70f9bso19848e87.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784610158; cv=none;
        d=google.com; s=arc-20260327;
        b=GAXd0BqmxoMEuEe9XD205q2WuSbAA0tit8Nqxnau+JxAbd111fb4Is3+d7TbKPylmR
         EYSCVxXLfKNGl45RNN7PB5uqfeM9XnSOADUeMQrS0BCv7v30TJDUTT5WJafOFg5o92xT
         7YOTrtlNSrSTI8cWh0j/kNCJucXcjrK+WE315e0LgLD7mnY2buxIryeimxp8s+FwQZjL
         NFssfpmbpuI7B6H1GIJvBabiZnEHKLdIuRkl8Ns3/bT7njEGfepA+0EnHJKGiwD61fDR
         LlCStUeP5mwy4XJVCtYPHP3VgCkuaZs3CjF9LJwZVpSlAnuC7c8dSyJi304sTmTgHAJ5
         2R7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wVYv1jY6vQm8iou0Tx0bNvdZzW73gw/syVItxV6jH04=;
        fh=b+IvxaXiLzJvqnh7AiX/pZxuvOF4dOx9x6RL92ZqJ2E=;
        b=fa3NQe0lq+MmXGEMMXcWxvLkns6+gxfI46HO51+UCMYgRbkPfsn2GIl4BrQz8e4E91
         t9Jd5V4iAviQIj3daO2FUbrK7U4IYZ+r1M8OLyphu2yJdRlKrWy+Q4VkGpahX1SsPmWA
         tCx5EFQqeqgFaThQVygwHXkZ3udVMd9+/3hRx3X560xcB2MzndUfa3gbfd2bTN90Mq9O
         2/bYgVLgcv/76cqsmJprhc8oTdrtoa22LfzRhjcgvKSnRpnQyGjFSEBEZeI2pw7osioQ
         a7ADsQ6of4mdD4mu0ON9ejvnI9J/iUbhywOzC8EYGYQ8NFbskPHIMTVm8g+OZC9GOWTZ
         YqbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784610158; x=1785214958; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wVYv1jY6vQm8iou0Tx0bNvdZzW73gw/syVItxV6jH04=;
        b=EV2/+0E+Ajf2p55P00a1QIzI7uZcvgLhH1W5jLEpVaAsBLWTiqdn3luOin05GVS7Fe
         MzhMZSG+j1lu+wLTFyuIsDBd1PXjF/6DGA66y1cUUPjUuZe5MpQGUgV9M0ApzXK8O/Td
         2FXyQXsj+LbsitRsrkOFYuC8ui9XO2YBZ59canHEVQA5Vj18+GBTT5nG2TqM70HOmPnd
         kUN8D+oPP3sZROi8/zVjeFZfpOyFv5SYcadsPju9e5oZWqBK1758fZvSisXQFeRR5M9g
         kfSGxgdiZ557FoRYn0XR3zJY4AxhEi48oHS94pqZU9jM1RgIOSHe9sFYv0rVOhjq2QZS
         jTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784610158; x=1785214958;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wVYv1jY6vQm8iou0Tx0bNvdZzW73gw/syVItxV6jH04=;
        b=aNhuYE7kVDS3Q17A3m1aLvxljRQETEwZ0k2MDgbnJ0j7/gYqGX8zKoxJL+cGtcGT+Z
         WXBUWVW6YNwAEqVaH2GW6I4Rb8LJhcuho0o6bca7E7lxDF2cfadO62ufXMUsEM0D6gQm
         vRbMi4U2frNZbhBuB/3fmZyZZWgKwh6NuYLyVZKHmPFW/qiJAsGcLlNVim1XsXF+cOBU
         y72vsY38S0cdZBhfNL90dBLFjVFLLfsSC9jGu9qVBbK5PeFgDqWDu7vWn2e9PIHSmtPO
         t0PDfkwqp0LkJpSBmZ35+DQMVGdy1Tp2JwJPl6rKknIA4ci9yKY9DtukY6Yqq1tW+w6e
         CGLA==
X-Forwarded-Encrypted: i=1; AHgh+Rq8p6RcW+BoYeVeG38bgHDX0LByS965wGUbqi3P/FJ0qRdlJG9kxoOigHCijnV/xpawi3SfKp4PzQ==@kvack.org
X-Gm-Message-State: AOJu0YxmA3xN7s4n8ye3yjG3fH6sJQIKCxcJk1FxKCg0DqFNeawhlH/N
	Evzt4aXnQGZXaZMVLnXTYhdwFMFBXTioqAouDgK8TywrGFnd++rYclXdJ6yUv9hc2zo1aL1rsVc
	fq/MU+5XfsWvykXTCY+kBiNwCoSBiGhAHoc1QlvUV
X-Gm-Gg: AR+sD10PffKHoFJfVR5mLBS3D3LIYYDqqL4Z7mZIUezF8pOMB0ZIsinAvc2Y4pPhw3D
	8f0xxwdui63Un+BkkZunZoEXQGy2TJGMp92Y3vr3Vw0NmpZMda99jnaIpx60TbTVDjf0F4xes+H
	PaZEeOudD7On9+bxFLH/CTcQlaT3gujvbf1ha2QdBnv3erwY10ir/AkuU28Z0MNBxx2i3J286Og
	FMQoVI3euAtWfTc8i9VwgG6J1FwFM7cLlnoEIqswC1vlXmR51f3F2lyVjhC2x2ntoNn4j88a91c
	rS64mYDFKvhvDrNjzJ9Hb8WdlH4RHTiDmSgEsO8jwYCnO+SnJg==
X-Received: by 2002:ac2:5683:0:b0:5ae:bfe1:737b with SMTP id
 2adb3069b0e04-5b2a31d1e55mr197564e87.10.1784610157601; Mon, 20 Jul 2026
 22:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260705175119.440599-1-souravpanda@google.com>
 <B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev> <CANruzcTi8+37K=YQwpZ51MxzDUKiX-gF6BdFMXax=ozzZw86eg@mail.gmail.com>
 <20260720173707.47616938378bc26a41650b6a@linux-foundation.org> <E8AB5D4D-E781-45B5-B06C-4AAFB2518977@linux.dev>
In-Reply-To: <E8AB5D4D-E781-45B5-B06C-4AAFB2518977@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Mon, 20 Jul 2026 22:02:26 -0700
X-Gm-Features: AUfX_mzTHSp3G0b6O7xSOaCA-VlORxS038Zcl2wZRjRN4n1VtzMqA4_dd0hSmtc
Message-ID: <CANruzcTCqERLWDiHyPsbWgB+DgoMVwecvEmkUTrBjgeja9r5Gg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in alloc_fresh_hugetlb_folio
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, david@kernel.org, fvdl@google.com, gthelen@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uef7emcuoeqhxpn7fq1stuy76s38h9rq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1C93100004
X-HE-Tag: 1784610159-898619
X-HE-Meta: U2FsdGVkX18Zenb86aiXj1goiYSB+0GGa4plWqhI4d6aELOfrEY12t7D6vXOGG6ieZPOl0Bn8PGbtiJCFTlYKMCfLKsMSBgR4AGqEx7uVg0xr5QiAo6C9bA17phIlGw9NZ8gRsnS09eeAXobl9wGOwKiYlQ4jq6hrTfygniDtBjT2YkXWsUJ6JGkJ9ZLfiftxTFWN2YbvLMXf4w0PphC09tuO0Kn/cwEMi0QoSYm3x58023Mh2FVDJIeJlQMzMb4CZxiSZ3fRAoHtqPMZ1HD1JI1v123hrlGwNwPNT+QKxlstbx9sy9nEvdRC0TVscBMZySyNQGIS5PONsO+AF/hpBopsjYEJUNR2/rpKfPsBBEw408ksSQXMYzuCkMY5uuD2dIdQrpQA8xr7IjA/gghbZ83lv2HZfePmVCV6dACAJlY+kMjV4bvku2b/+LeaFMdLiJCKv1PVRgcF7pwxQ/gaGNziQcRiBsbA0p32iJ3CGWxibEqlZo/RqjhWFjb8ty2JAjqtWnoG93G+EX/VZkUuLVtZ+qXeCxMlWBkH5YaLMhGUPf2gbY0AMKQTDG/hdyu7tWL3rKcXwNqu+pCj0JbnA8IyiPVjU1c8JvedzfdHY+pG+MkHZJW5Reh+qw10Aj0UC7+J5F+MdiwYEIhUGeECR8TkEKmHgFOfMvp0XGRfTCeh7akkDi5pIy0JE3QggFlKF0MMi6ae8PseQ/qC1e98YJLmGJx0aV9X7vgCmx7GLygDDn4ckhYwXa8urMZG3O6sjIhTjFo1gOKE/exIu5fyuSYJb0UAgQI6/ndI5ZP3a24aJVhGEG57tQ7f9Y6iiuiQYgt6VbCmhAooGUkzG/7OmXfRpwDmeg1YBfr4OUl54vqcFVM9dG6ukpcnF8nexJxGuR3XBe2+5oQroHVJxnmry6N75oETXafXTyrdB6q+F8B/aI8NAEtjg/WUUZs2Jrtq6WsQ2CSrEkN1JU6Dd/
 cYc7hvot
 6ib9paK8XODkxlq7D3vasljJuagqoBRFUc+bh5bVTZA+R+SwG8TTERSbo2hIIaSD/g42sJ7JwyxAGIPO2lrxpDUCEIIqtnPzorooGqQU2EaI2OziAlurWzBjk6V5zs3Pa9t/5+w/LhW90k6xngYdiKyGb58ILGS0OPvYO+Fx4YKbj7u6y+0g35pJ5NryDRjjhV7LucDGvb2OqcxcPWvY3hQM9NWLgS9uyr6azxfzpwWwwJNNaQUOehrR1Hzbg9mGh0lD3Nr5iDOdj7yD0OWwDPmRtQWZf5EIWX603jgiChuw3rw7i9NJxquVeXCc5f7szrvNr096nFBsdBkPGSl/gxBf+hDLonQIU0jaREMog0OweYKzVjyAvzEZ/VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 7:30=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Jul 21, 2026, at 08:37, Andrew Morton <akpm@linux-foundation.org> wr=
ote:
> >
> > On Sun, 5 Jul 2026 23:55:31 -0700 Sourav Panda <souravpanda@google.com>=
 wrote:
> >
> >>> - Option 1: Fix it directly within alloc_gigantic_frozen_folio().
> >>>  This would centrally cover both of its underlying allocation paths:
> >>>  hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages().
> >>>
> >>> - Option 2: Fix hugetlb_cma_alloc_frozen_folio() and alloc_contig_fro=
zen_pages()
> >>>  separately. The rationale here is that since the buddy allocator
> >>>  already handles this case internally, and alloc_contig_frozen_pages(=
)
> >>>  is also a low-level allocator, it would be better to keep their beha=
viors
> >>>  consistent.
> >>>
> >>> Both approaches are viable from my perspective. I'm CCing more MM mai=
ntainers
> >>> and reviewers to gather your insights and decide on the best path for=
ward.
> >>>
> >>> Muchun,
> >>> Thanks.
> >>
> >> Gotcha! Thanks Andrew and Muchun!
> >>
> >> I shall wait for the decision and then send the subsequent version :)
> >
> > 15 days: no decision shall be forthcoming.
> >
> > Please code up whatever you consider best then send it out.  This will
> > trigger a great outpouring of decisions ;)
>
> Hi Sourav,
>
> Please select Option 2 first, as I'd prefer not to make HugeTLB a special=
 case
> again.

Ack! Thanks for the direction Muchun and Andrew :)

>
> Thanks.
>

