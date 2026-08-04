Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5708CC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185076B0092; Tue,  4 Aug 2026 18:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1363A6B0093; Tue,  4 Aug 2026 18:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0256F6B0095; Tue,  4 Aug 2026 18:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2BF6B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:07:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DE361A032A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:07:55 +0000 (UTC)
X-FDA: 85064975310.11.961A2BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 50F06140012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:07:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRSDaf8A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785881273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1K8MeR43pcYgs7xCjQWaZQWqoBNoVjxGBt+/XlsqQMo=;
	b=vlZf8nIvooWGS2PjmIOEDXbPmnm75JE/O2B+J+ZD1PWurC+UTkBMhXPL8JV2+/iBMDu87r
	4ZiakLLl8KZzx5xCGCRNEMvJLubV6qdQw37IpNofdKpFhCfyK50YwlOE3o2yYl9YVdtSy6
	xOWQ72KwwAL66lVPddxI4uaqjYdC+CI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRSDaf8A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785881273;
	b=g2qH5jp+fsqfddIeD3vc7Czzbd+uwlg9Txr3EH3Erc8g5MpjZXqmkuu2JzMi8zZCpuz7AV
	QhFWG+LovOVy1Ie3WkxWMXCyl04VyGtMsDXgV2qJmGVeBE1OS3WVihnDDPyIW9kjwdg30V
	Xw/65TuVJRQS77fOsiKT2cjYWQLzTI0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7242443EE4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592DF1F00A3E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785881272;
	bh=1K8MeR43pcYgs7xCjQWaZQWqoBNoVjxGBt+/XlsqQMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QRSDaf8AhoGGwyxJTw6E76y1L2glbzNF18r/CUmWEJwfC7T6bhyZcl0tqGbYbj2bA
	 IybxXrO/rcyVNHxcujIVh27/V7k/kmMscc6MJtO0jWPlTbFDq4A1ykn+fjw3bHjo2C
	 fPrjDdUVTWp0SgsFa34Kjr5isVOKGFPqDnSp/J+oWxj5cU20HBDf7h9g6+chz7Hcsx
	 reu46BCaTGTyuVHgmCIjVn9katVKyvxfyZAmd0oUU2HORS26pkaW5Bz9Zg6utaD0ae
	 d0dBdWE61fbUSNxGQrgsZyP+2fqSYhcQNqUA7yoI0R30C27CC/iER8wMHHyHZXXjVU
	 HobjcY4C6ovxQ==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51bfa429aa6so10013381cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 15:07:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqsrYYsqCutYJyijlDL+Fw9buO3EJYjEdaosUuvuJAWfvd2yRfihOJ37eXmldaQt9IlUTIaxqQOFg==@kvack.org
X-Gm-Message-State: AOJu0YwH5OJOMrFHlQ9IHPSfGmUdvSwvWC8ymuLeEYxwvYngbV81d2P2
	wmMfnBjd401MjM1zp6Ruxfdbm4QsiY/8nvruul9b04zWHSOeNQFqIIZDfiQPyRiDH2THJM3LC12
	uKor3TuLKLKvjzZBc6l5QWJU8kVy2BVk=
X-Received: by 2002:a05:622a:148:b0:51b:fb5f:b263 with SMTP id
 d75a77b69052e-52cd3357119mr98710671cf.4.1785881271571; Tue, 04 Aug 2026
 15:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org> <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org> <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org> <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
 <7bb32d25-2c3e-40ab-904a-ba22fff60cca@linux.dev>
In-Reply-To: <7bb32d25-2c3e-40ab-904a-ba22fff60cca@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 06:07:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yn5w8b=YQYHEk==8cEc8psB8NHADyrmjBK+YbKtXbdOw@mail.gmail.com>
X-Gm-Features: AUfX_myIDUb-IuTF3llNOsxo0q5MMkyaKikfEVZ2JFa86kzkXyHArk7dLyIVUBA
Message-ID: <CAGsJ_4yn5w8b=YQYHEk==8cEc8psB8NHADyrmjBK+YbKtXbdOw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Usama Arif <usama.arif@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, ljs@kernel.org, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50F06140012
X-Stat-Signature: udtco5k5j97hbm59ocg7f1hx9itdr573
X-Rspam-User: 
X-HE-Tag: 1785881273-315322
X-HE-Meta: U2FsdGVkX18IzLBtDLmX2p+hZGmqRnvynYPR2dMoit7jr7nvm8lQDo4e7EPBSFHb46mHqGYBFm2OgrXNho74DLpMjB924DPhQqGGIUyHzD/UNpgI6dcfMjOE6jC20qE6YhsYawyDCKNfe7NDpI+yMVyLhTZdd3hfkHOU9ca72CrC7XhlrSJxxE88Pa5BIwh9Ie2nN6qBsx6qYKnbydgRaHq96y416fNPRlQdPTEfemt/+zYkoQ0G+r9ppBibfV7N6t/2188IvVhdUMgnXaHEFx2ZMUIw+Aza6mXRi/4ejE8SbUTAcxTqJWbPjI/8X83pm8vqB/eJpUwaaQIz4dDzbkvTeHZEBU97dgsjwSHZr9MN+KS99YvP+9hgUCLgtAp/09rG1oQ1dUIdA/U7RSBXtyi66QZKU1KZXcju7aV2NU2J5TWi7pnvHBnPHdOi5RUxc1MnQyxyfcB+KYIin3NPKuhJZGDzVUdAo1rKBMUADYhh22Co2NBRugrptKyiS36F/sGW2glDddn/k6X2mdyXDWtwLWGmpOHC6D81WWJtdQT5Wxprsiqww8w8PYXvk0Iz6UCqO9c6lr3CJU5OXcLSlHOpcSMoWUt5ssL7ZdkhWe0bhaTI8k7k2JdWUNZc/wr6HqZS7EcZKAi5cOjRQ3N9dfg8N0iqW5+sA8FVmASH2bQ2Hd+QY0OhIm8s7/c1mKlhpCV7yCahIXSwxA0OTP/mMFFoCriQZyKHGmmlG69lVI0YIFBz3c1tG3BJDEn4ujWOJKQkWjYvnPM/s3mSmfzGLeIZqrSctRdJcJJ+Rt3YxGWeV54FLeQ5eZZ2b6O38+FFwDKj4BVMHJUDdpMA5OGqAL+eE7Ta2M63KNd8GMaim0abUrM6pEp3O3rtHXTbgug/oNwg0rW3z1OdU4SEzQcyJhIzcumSajTx0Cu+v6c80XqeMt6GNllu7sz0TmXQZjzaRTFv+sW6F7QePgFVPrb
 HE9z9Eiv
 o+tWlPie8osPDs0J0+C1QLOWssNfTcNMFQAuUVatqroQEEzJh/GMKLDogpzrvw8ipNqeIRgaa6HCsh4TlKtEqeNSBseN3q64wRKJMrs6CzSSCn9WXBqhBhRv8fLqAVbr1FWYpn/MkGIXSMRdOGuHOUBPNJ2OK9zPLufAA0B+YvHe4tx7t9u6Hf7MduKjRHUmA4A6qh3py/sNsr3gIMn0ZaiAxNQ7bcz0xjR9VNrTgdk9oslm+BRKzGWN/PvRf2yyPVBmHpqwt/T8Zyf/gthhDho/SSQZYEvBfAe9LzCsU24jkE8WXyyNzMHEFhl01/h27J/mGP9R/62au1USVVO9hJxrq9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 10:39=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 04/08/2026 03:03, Barry Song wrote:
> > On Tue, Aug 4, 2026 at 8:48=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> >>
> > [...]
> >>>
> >>> #define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
> >>>
> >>> if (folio_size(folio) >=3D LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
> >>>      deferred_split_folio(folio, false);
> >>>
> >>> If, someday, people find that 1 MiB also helps, they can provide
> >>> data to support it.
> >>
> >> I am very confused. Did you not see my proposal above?
> >>
> >> Why not this?
> >
> > Hi Johannes,
> >
> > For arm64, if the base page size is 64KB, a PMD would be 512MB,
> > and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
> > order-5, not PMD-1 on arm64.
> >
> > BTW, I assume khugepaged_max_ptes_none is intended for collapse,
> > not splitting. I am a bit concerned that reusing it for this
> > purpose would be quite disruptive.
> >
> We have to use the same parameter for both collapse and splitting.
>
> For example if you use a new parameter for splitting which is set
> higher than the value for collapse, then khugepaged and shrinker
> will constantly thrash each other. khugepaged will collapse
> and shrinker will break it down.

thanks for the clarification, Usama, Johannes.

For your case, where the base page size is 64KB, you want to split
a 2MB mTHP, which is order-5. So would you have
khugepaged_max_ptes_none to 16 (i.e., order-4)?

So, for example, once you have 17 or more zero PTEs, you split the
folio. And if you have 16 or fewer zero PTEs, you collapse it?

If so, it seems Johannes's proposal might be the simplest way to
go.

BTW, do you see any issue around 16? To me, it seems more
sensible to use different thresholds for splitting and collapse,
with the splitting threshold higher than the collapse threshold.
That way, there is some hysteresis between the two, avoiding
thrashing around the threshold.

