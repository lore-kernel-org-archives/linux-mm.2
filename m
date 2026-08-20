Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DC7C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 20:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162906B00A0; Thu, 20 Aug 2026 16:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A8A6B00A1; Thu, 20 Aug 2026 16:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0772E6B00A2; Thu, 20 Aug 2026 16:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0B936B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:22:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CFE01A02A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:22:29 +0000 (UTC)
X-FDA: 85122770418.04.562D8A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B29C1C0007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:22:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1FXaAFP;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787257347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pz8QCpPSO3ogvQ4JHJS7MyDFtkTH0N2jETHMbR5/AwQ=;
	b=Lxbxp5AS5rCxJlWrLirjer6T5qdvMw6PxayDTwgciFk0MWG/4gLOkzyc0prETJVwyrj05o
	A8w9PaIN/NPR1KTANg9gSLLOOoD4PHQGAQumhpmxaM7ZkXjj1Vz4nWuvX3kMb2e3z2Nc7+
	+WVRRCKYkD/d9q8vzjLyoFYquovwX6s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787257347;
	b=xfgIcWEMmzNvw80cJlMmSWbpG5/AbvUuFf/MrzRHe9A0yRZxyqkn3Kh2I25065fyV1micH
	Mj2dg2WaEcrUh7Ts9MfUIde7WNUVLvf0WJUx8zQrvNDGjWXlnovszP1FKdrO6u09VLAgLX
	0upLC6cO4jVRuPow7AHwsbkv+QDLqXk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1FXaAFP;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6891043BE4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3BF1F0155A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787257346;
	bh=Pz8QCpPSO3ogvQ4JHJS7MyDFtkTH0N2jETHMbR5/AwQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A1FXaAFPqNx99NNpam4HpjcBd3+JghFPZivbqO/NplTFdgZA76AAIKhDYeb7c3pgX
	 HsxrFT/N6TaHIRhyVq63/aPI8zRfLpO0u7HFJVAxr1c8HBzFfgFOqSjlZfM8EdWf90
	 zogqwNMG+hIoT54ymvLEXytjIM6T338NbpBVgCsn1f8gr//6BLZs5jcMdlpiGk7zxY
	 UQogCXLIvsg2yI3Xg6QCDqJwmXAhay45agfZYlvNqTDLqD2WHwKI3EuAp8QGSf9Yq3
	 B/MK8ADzhBQ3PfU5eV0cujLHS27ocgvjEZThWW0GHu8JLpcO/W2hKWuIu4XR7jKJQJ
	 iSW/AAR3blxfg==
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c1372f84dso1532821cf.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:22:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpv5MwNQ//ITSEll4varxr2deiPVvgWvzR0A21ddBpXg3cXbvXhBVKiwiKYZ+pYvTAKW1vQTzp1Hw==@kvack.org
X-Gm-Message-State: AOJu0YyfXr3Jq3ksLHpqUtbTyVJZL9JayjeUPQfq6Srfm7qcqlxQk08O
	I0hjFvdTwbmB/MR9FZ8Wwq3A4+olkSuJXSQJcguoJcClQKBWZjlg6yecWylR80wJCHMYjixAdC5
	zdV1di2ndFfrhMeBlXqUnnI9UPFtQfGI=
X-Received: by 2002:ac8:5cca:0:b0:528:f72:a986 with SMTP id
 d75a77b69052e-52df5bc6e10mr10519831cf.44.1787257345641; Thu, 20 Aug 2026
 13:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <c8287b5a-8f8b-4110-ad47-996842f01bfe@kernel.org>
 <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
In-Reply-To: <CAGsJ_4xT-Nga9yCa_QtbmFQ3tm0LJF0doCsV3pJpO0i+2z4yww@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 21 Aug 2026 04:22:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x+-FtP2oMRapzf3Dhu4B4wXOj1XQi+HbSSAma2Cbwz+Q@mail.gmail.com>
X-Gm-Features: AcwNN1UvWexqHmJyks0gmx3p7vLLeAoX6RERbp3fmcxUoOpTgVNzY1dM_cQAbmY
Message-ID: <CAGsJ_4x+-FtP2oMRapzf3Dhu4B4wXOj1XQi+HbSSAma2Cbwz+Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, hughd@google.com, 
	ackerleytng@google.com, usama.arif@linux.dev, joannelkoong@gmail.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: urnpzb8m5ztsjpum69ee3bga73i8f4of
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B29C1C0007
X-HE-Tag: 1787257347-882463
X-HE-Meta: U2FsdGVkX1/uypbJYehC0XqcJZDPiEdlgCPRh7pszW5vp+fkA7TX/ueOCmaJ2aDU0geKIAHXDKAJlzj05DLUlDmkPGJnzrZZ5W0BnMZQ2rlv396UjteQ7uut/Qjf8QJjNsHvMTPZlu8nkWwL18kgJyoqsveydDhOz1rPEYGZSLiaAQrLMTrEtrwgQfTbTQcsbwjPTXeBl901F5KR9WnP5O0QV+5JnXhl1EXiRdztcmptZ2lCanefwJ3ZBUD6WPaEsrK9sCHTGcbpksYYG/KFB6TlBoD24WDt75LCPFubB5HenBJas4qQ4toMdguj9QDSmOFsiPo5uUjWtu7trFmYq+rB2nl+lscfvfIb3mMdqElo5iQhZX1QbqiH0Ku4QoI01bEXanjTRqIL1Wv3R/7TtURWosqiNdeeYe1r/moJlG3BUh09JbQOrtvdRJASVND2mRXuieBmEi9phNGG4Hmno67MlfurZlS62nhcuQfCU4nf7S2MY6K0cAdCwjFACoXXQym2cpD3W7+WoH6sdeHxChZoZ3XUEu5UGHP0RYGMgzxXpF5zed8S9uajR4gMgAVxN/geXtDNhbyC6tLihLHfgHQ84K6WP8iBaHkFkAcc0tQr5oB+Uijs0YlDeJfGE48vHQMqG/S/qr9kSnf0C/STWeupTmr5IAEmIb4JnXhZoRWyDHGSABeNXiMgET5D/K65tmogfoTnyceRhy2sQcH+0IMpOq+OR2DRZuFoe3VDhJIWdUv7t+Xk7Rmc8ppjMCTpDehTmG9JXw3eBE8+Ur0Gu1Tk5AlwHl5C4q1Jt6EaX2vMBDuxtPMvrxZ+fKoPWNXq4omvoajpUcfyqImQTRXTvGPZ9f4EtNE8mK0GzFEG5a/Bo6spKq5aROU51STuD7SZ6NjMr52igXGzAzpj9j7PxeEDcwmSdQqTuI2D3pgKashXvj2AKYZr+NDT4BopLtZQcZlnJTvByf9ZpsjNpKy
 7j9lqgiv
 b2Ly4Qs+WoU+okMgwGewmAHgF3dGJvLzwkRHxJMWZ5KK+cNCcUB5nC9TMmp1dFP72rMg4Jr18T0+ZMw7z62pQwiNp/guSn8LymwerR5CjvxidrjQHw2NW8LfRQMXIA5hfJp73UuK5kZJrJP+vqI5L8WWVdanEr8/UzIfYqQuinq9dgkT/pLUQidQDXUxvKf+BwUn4D+4fwMtlQ5xoMYh/uvpvHSk7/S4sr5ljfEtpVY3CKqYr9vQFumsOSiIqrLPmkHARgtvxd1REb+jmBDbzZ+6AWgvzumUhF/t8twA9cBMXC0omDLR5qtXv3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 4:18=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Aug 21, 2026 at 2:23=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 8/19/26 00:59, Barry Song (Xiaomi) wrote:
> > > This patchset enables the per-CPU LRU cache for large folios with few=
er
> > > than `FOLIO_BATCH_SIZE` (31) pages. It also limits each per-CPU LRU c=
ache
> > > to at most `FOLIO_BATCH_SIZE` pages to avoid negatively affecting
> > > accounting and memory reclamation pressure.
> > >
> > > This is particularly beneficial on systems that use relatively small
> > > large folios. For larger folios, the benefit is likely to be smaller
> > > because far fewer folios are expected to contend for the LRU cache.
> >
> > As raised, there is this problem with collect_longterm_unpinnable_folio=
s()
> >
> > (see
> > https://lore.kernel.org/r/20260806-lru_cache_drain_for_folio-v1-1-c6287=
d295e99@kernel.org
> > )
> >
> > whereby we don't know how many refs we actually hold. Certainly not 1.
> >
> > We might have to wait for Hugh's cleanup to handle that cleanly (and av=
oid all
> > the other LRU cache draining).
>
> Hi David,
> Thanks for raising this.
> Yes, I saw your comment and took a closer look at it. I think the
> best approach for now is to leave that part untouched until Hugh's
> patch lands? We might end up doing some extra draining in that case,
> but that's safe=E2=80=94any value greater than 1 might not be. We may jus=
t
> drain more than necessary?

BTW, David. This is also why I didn't move the below checks in patch 3/4[1]
to lru_cache_drain_for_folio() as we are not safe to do it for that "1" in
collect_longterm_unpinnable_folios():

+ if (folio_ref_count(folio) =3D=3D folio_expected_ref_count(folio) + 1 +
+    folio_may_be_lru_cached(folio))
+ lru_cache_drain_for_folio(folio, 1, NULL);

[1] https://lore.kernel.org/all/20260818225904.55236-4-baohua@kernel.org/

>
> Best Regards
> Barry

