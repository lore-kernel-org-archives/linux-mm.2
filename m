Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E251CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB418E0144; Thu, 18 Sep 2025 10:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BDA8E013A; Thu, 18 Sep 2025 10:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A778E0144; Thu, 18 Sep 2025 10:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 826128E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:20:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F26FB6FFB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:20:08 +0000 (UTC)
X-FDA: 83902580496.12.736FDEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1DE0D140002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:20:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AGZFAI/w";
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758205206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWZhryAvRQtDyjeStvoQhj1ITDFDPTCq/irqjRsFVR8=;
	b=bNqp7G0Fj2b5gX2K+GiPd7xFW0TnRKNO18SXnzt28laFFwWGIBNH3OI+KMqKAzw8i9PoNn
	hu/74++mQIdsZ5FvPTf1XL3xzvsg6s1ZmUsdjUHc+upwlUp6vyPHcK8As1fGKrQNNJOvhz
	fGMBeRCqD8czgPCrWTisNuE4Cd4j0EM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758205206; a=rsa-sha256;
	cv=none;
	b=R0uTM/pVE33k7NGoOtVVJv5Ebgj/wL4Usfe4BLzsmbHQWJvaPaPoCchQ5lsnt1d5j3J8oO
	K4K8IIgle38Ofb/it8hUztteZ/P/WoVaDOTf2Zar56SgayoKvOSIyYHDuQEzERwq4u9Nip
	dy6uSnocO5MXWCl7j+zjzgHP6fWB8bs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AGZFAI/w";
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A06DA44CA3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73688C19422
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758205204;
	bh=OWZhryAvRQtDyjeStvoQhj1ITDFDPTCq/irqjRsFVR8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AGZFAI/w3PnQAru63me4ay9jcaUlh2xe9SKRc+AnrbhbOSWIHnJULSpTHXF8mBdH2
	 g1CCR4xfum6T5US/0VPAFJg9rWMbHWRhVxHwdWRD8/lTly0KGojQ7dCoAlHOa/FzxO
	 gGAGahj1CzvbfPpzYutFt3Ll+KLdEaJ1U4/8WyjBgtsrtRQuzew+MswdAHxkqW91H0
	 f+YEdfxz3vDTr8sBecc5GQN1oBiJPLbed4JAiRiI5tLUxpMzCguyaDqgi+1WU4RPR/
	 wSamAdiZcSXghDtYJgSpz4sAY9J2XDizVueMNCzf8uasuTaiVDFzECHmYBGJQXg7Mc
	 w9AU5drGotPPw==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d71bcac45so7484637b3.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:20:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUGBxSQGNw8vsGGX10wsOK3GPvZiX0r8uCKNpeltFnOXWH6Mkx+IypW57Dap9/w31CikV5+HpmVGA==@kvack.org
X-Gm-Message-State: AOJu0YwNUN06HZKxfynMhxdDHEJNYtxGVIp6cKyWijyGuxou2cVxyiU3
	tur2yss9/M5UYVpJPQRqr8sKX12I66vamEAJeMrZZ1Wv3W43SoA/EFnvCNgUCvCdtF6kPGZKnGE
	fW0wwWMi3A7PGQ33Y2gOJoOjY1uMJlz6WC3TkVr8IzA==
X-Google-Smtp-Source: AGHT+IHJ5VJ815IdenFpro8uYXEfzkWvkvnL+QTGV/q4zXxuxIvJR5FbvI/qS7bEiRnQ3lj33uFOCWbw2B2cpQMqPjE=
X-Received: by 2002:a05:690c:18:b0:71f:e430:666b with SMTP id
 00721157ae682-73892a49056mr46759697b3.32.1758205203651; Thu, 18 Sep 2025
 07:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
 <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
 <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com> <CAGsJ_4zmkibM_Ex7kGMsr2sni85H-cnxQvh0XwkWiALNQy+zAQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zmkibM_Ex7kGMsr2sni85H-cnxQvh0XwkWiALNQy+zAQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 18 Sep 2025 07:19:52 -0700
X-Gmail-Original-Message-ID: <CACePvbXae0zymE_BHydXtA_pjZ2NqabVyqxu1xKxLjLKmeYH9g@mail.gmail.com>
X-Gm-Features: AS18NWAMcE25uboInmnLpD0pUJ78wF8y-VpV56txG6Fyry-vKnC2XHT05OGiLaE
Message-ID: <CACePvbXae0zymE_BHydXtA_pjZ2NqabVyqxu1xKxLjLKmeYH9g@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DE0D140002
X-Stat-Signature: egykr57ymzkx6qj4ttyzn4981nuw38ho
X-Rspam-User: 
X-HE-Tag: 1758205205-74101
X-HE-Meta: U2FsdGVkX18+CzoIIOw7ovRB7625EjRaMiCNrW9fibJqk/Jhvsk3OsCnEC4+mYS8hUz5gmVdO6UoM4Cj2N2VtxSFN/1ZmcL95o8cxRK01kK5OlvUjjCsEWnTtzDbjwekZf2crzdns/XCcY1oCYflGeGdj/0ZYi6mIS3pOmEkaEym1PtZ4gDRGMgCX1HpjSPGnxea33KTlWaYhD9Wkw1coCfzNY1homwTIhaJ5pGyyR13wPSgSG8spXiXT7I8Ur/oic6LMzR7dY8H9zxyEBRWtJsPC+gJTfYpQ2JYSGERBvv1pxV8+NmCMWFEFSyJDgatIlGVy57JvXi0tUbxu/IL8r2v+8/wqXD9jdH18hoal8Cl8nN+2q2jdC9Zcx44dQCpxYUn8sra9H+beqOLUYYOLMgrPvqd1VW2L64LrLMOCxnMGGgpnM4uwVUz7x2g6RsSR7IzpVoHIGuh7xGEeyChDVZZujmBUCiVwZRnpCLG9dMo+fMZsmT3BMw80z1vOQCJT9DCFT60quzRUFB73jLVzG//e4BRzj37P2FanvdZm+bSOMyQNcWpzj6yxvEActbTGksnDUZ1GebpjEzZD7wEfNR9efV59892iWzP5/eFdXeveocbH7F5qF2s+3H/wXXKR5+bSB+uYGXBpveaVIM6MP+WsW5S9tXV5qtewFTLHTbe3Lf7md4QLGMzxVDr+B1V4rWFLwXLkQ6oCGz+PPw6b93y/ns9CBlTLr5pXHjPRso/7veXyS856YTZeS2sp7W3ea4JwTK6//CiwzyJ0vMs3Z67KzC1mnojXX7qmozBOCRpIViwxGU5UJUivsOokQuqqvZypj0KdSCmr8YNIKGA5LjLv7BipixTzL+49X4gS8LFednFQuEihdU3y5ft1uncIZbiUpRF/3BS0ufLh5X+chMYhjFs9g1e2kiFMBZfd65gV3f1ZU2PIiDC389hixmGNr/+OrFPWC8loYIZT6J
 7jKEyX31
 kJkWsbTIci3DN/P9ry4gJaZYuyOZEjZXD++TwOS76iAPFtGm2JrGkgikPzj1OXcDOrSJQDcjw/oEtRpsccRAzuTuaB7oUdEiZ9EJ7WPrLogT1n1yJYJXVORsG23b6g+LWmX1yKis/JVi39f8/qaE32pl+VH9DFy9KR8PJ2J/m1oLF2lhJSu5PVfWTJKuLeOgAhPtLkKMbh2YBpbNuNRFwRUZ8H++3q1Cb39GwTGGHSiIKw9JTvMO3eG/F2SotnTWKSKk0JtGxAQsLWnv8Aly84T/Qb+Wsjabdk4Nlc848ief8tkzdSvnpadH7UBupi5GYZYOqOTafs41jLWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 1:59=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Thu, Sep 18, 2025 at 3:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > Hi Barry,
> >
> > How about this:
> >
> > A swap table stores one cluster worth of swap cache values, which is
> > exactly one page table page on most morden 64 bit systems. This is not
> > coincidental because the cluster size is determined by the huge page si=
ze.
>
> I=E2=80=99d phrase it as =E2=80=9CPMD huge page,=E2=80=9D since we also h=
ave =E2=80=9CPUD huge page.=E2=80=9D

Good point. Will do.

>
> > The swap table is holding an array of pointers, which have the same
> > size as the PTE. The size of the swap table should match the page table
> > page.
> >
>
> I=E2=80=99m not entirely sure what you mean by =E2=80=9Cpage table page.=
=E2=80=9D

The page that gets pointed by the page table, or the page that holds the PT=
E.

> My understanding is that you=E2=80=99re saying:
> The swap table contains an array of pointers, each the same size as a PTE=
,
> so its total size typically matches a PTE page table=E2=80=94one page on =
modern
> 64-bit systems.

That sounds good. Thanks for the suggestion.
I take your suggestion with some small modifications, mostly to
clarify the total size is the total size of one cluster of swap
tables. The total size of all swap tables in a swap file is much
bigger.

How about this:

A swap table is an array of pointers. Each pointer is the same size as a PT=
E.
The size of a swap table for one swap cluster typically matches a PTE
page table,
which is one page on modern 64-bit systems.

Chris

