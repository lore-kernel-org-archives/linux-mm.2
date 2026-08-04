Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE975C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6042E6B007B; Mon,  3 Aug 2026 22:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5706B0088; Mon,  3 Aug 2026 22:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAAF6B008A; Mon,  3 Aug 2026 22:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20C6A6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:03:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FBAD120843
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:03:31 +0000 (UTC)
X-FDA: 85061940222.23.F6FFB8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D8CDA0012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:03:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdxtIEh5;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785809009;
	b=4K2Rq35GqoAhKP1xsweUy9b8ZOvWYdjusPGLwQwbTrZMTU0gNk9XfT0778SiIC+VUl0RyM
	o28Yh3VNa9cwsf6lKUMYQObJc0NzEH7KJ8mZZ7bRV36U5rO+7B2lu1nhY2OK2OGrHi8HBt
	/x2iGJJ+m7RCazDC0nzEOCuyOxqRSAY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdxtIEh5;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785809009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSc4Uw5Xqh9ZeGdTyyeW3oEwdtGmi1JwnwyGIoORKj8=;
	b=PyHjEA8Mgrb9r4PsgHBbqX0eB1AR6V7xsRIDSssSSdF+QxZPhvtF9Rt3lXdPNHdDHvRzrV
	oWGURPtwuFi9E3Ty44SmsJiPrhF9mZmE/CrIUL5H+PkD9xKLMfIHmB4ykhgo6tmJ4bz/wy
	OOVx3bVQPHF5+CFy857/j5GAw/Bo8DM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8E9B60A59
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9299C1F00A3D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785809008;
	bh=dSc4Uw5Xqh9ZeGdTyyeW3oEwdtGmi1JwnwyGIoORKj8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MdxtIEh5PlpwFasslRvb6n6w/sPeQo7tCLxcmudKSnMoEXuh6K+lVzUUEmQbpp5d/
	 ixupwCUlgMiLWjdE8Sj50WUfJ5Uadvk4mmnY7LSU7AWIIdhBJRP+M5/nBrfq8lCT23
	 +VR1A9eA80YrcLJqgUVmOPN6AneOc0MQiLOw4AQBJ/N+VIk4OjRxVyL8uxdzSJIu6s
	 gf0WU5rBkMsZkKPGelH/nCO3IuZCUtvzFzgx/6r+r7v35eBv+E+WpAozt/+QM/0W6V
	 OFgiosk1LUhGfCs4NUO5Tot1KVFMnG1OraEMzqNAVaXA7x2hckpuRteDllgbDbfZrM
	 f5vQDv0cWFXDw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92ed19f4d60so35344485a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 19:03:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rou6l3fcJZm1DHDIwCblabYLmWBD7O8vdLqXDVtClFJijMfZUBamivOFFsIq/JqZwQMtS/JXTTlfQ==@kvack.org
X-Gm-Message-State: AOJu0YyKlNHEe2e71uITf6u4wnFDnuR3kCJdNhpnnOStJCX6HBP+YRnh
	5HhZ/aLu2x5W9Fklalwu11Ft41ySXWdMDVlBO7i3V3rOXmtFlUppF4QFXPK6qDWI4kN4f+ofOO4
	u5s7THCWt9SmabUFHARee0ZwBsurG/Pc=
X-Received: by 2002:a05:620a:44d0:b0:930:e82f:7bd1 with SMTP id
 af79cd13be357-9363180373cmr344354285a.1.1785809007961; Mon, 03 Aug 2026
 19:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org> <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org> <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org>
In-Reply-To: <anE27CtvCFx7sAuO@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 4 Aug 2026 10:03:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
X-Gm-Features: AUfX_mzYrtzSk7DonRwb13-6njPtAjHgbw091CmXhuCAKLObudyTcslwXuU6Wa0
Message-ID: <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D8CDA0012
X-Stat-Signature: ng9g918d541wjrr5xnx8xysoycp4tzan
X-Rspam-User: 
X-HE-Tag: 1785809009-158781
X-HE-Meta: U2FsdGVkX1/CTkDTD3Gh91hqzyksHXbZCn1Ggj5ML0PUt/3mJo3yVvNmzzJp8uslxgVXV5p4tNd18kuISo7P2GagBkz6LdjLNxIb8KnoQTSkfA1GZ1/KTjzOZV8SEV1gbG+vtC/RadCe2mx+jy3pjFKeR+5cuFo22SNVAITkSVQh5wquTRGV+/rESD+ZOxAhgKz9CLEHrL7Baa7/k/jo0MKkfnNs2X8oYBd8vuuarF7PKakbOUKJnsvAxpue4t0u8RjfTZOY5gOFL6e7ykeLCXTuBlnxmMPlG9e87SXYvM05xZW+GqYXW8iKa39vCyNGkW8JbaIT1BeJQyIBKVaL152C370Ja5lp9xeyVj78f8WyQ2jdvNPKg8Ullt/X9jrMFZol5lcm73GE3qoi/qVbm+VhtGs4KoMCq/2g2cKHrRP4CFrA8jc8N3qRlbCyCP5os+pV7KrSaQFzHpeLIF5n11trvcOGWq+gSWFgrTxFZhxqGccsWFmvys+YbIooPTG2pKEM5W084sWdO7oml3EBMBM2BxHwd4UJg7YY6f2zxX+TCYI5tHqpQR0B/9ERysFBHd+JC7XZwvNyB9HFVRKeFg2WxQWjZ+7dQOgt9Wg6SnvGfev5Z0zK76LQCW8LqrKkDWEzgY4mUs0+3lgz0N1yimyWQzLOiViOBqntP4vgrFPP8zGpABOvOlgp01Yz9WcAEHAoeeOyC9rV22QR2FmmqsRTi0zJTJdbPvfPOKCLxdhC+5rW2lXmHl3/WSeAafoIZFxN1jas2ZnumJjQ8sWbsxHUE8dhGHx5wHX847S4LLdp8bcG2/YVuMaWfl2sl7DT8M1gY6ME5IrOKuU4qgv24vgo+/Gxcn07o/f5WHgbuYbAuyU2/ri1OlZxY23UX3d4t9O3nmx69UEErhJ0A7ArFj3IKhrbcQhEAq0KFH0JfQniEh20GEFYu5EvRTum7l4OEUMcPYDvfz37U6A85M3
 sH4PNfhO
 5hOhMdvAKN3g4ZF5ROaTz4vJw0kCLMinLJpUqeMpmrqBX+ReO9UQh/XGMObqryshdfvf3qPtjR4lFeDwIWswLN2KIk8d7WtkI6jV50era2R6xpdDYVB0jXY96S7BrnNZ5jcAAwIQ797HhUULVwvQBv/8aaxV+KceQtzM6KbC/L0CdGaeGhSP+s3HpSPb6+Tc7O+jV5en3FlKnyKJTWu0CSkd/NsxzN2w5IFowXaxCIjc2fY2UNqJsYqn6Ie21kosLerKAOg+XkUkWRbtqkG+VLo5jQh7jtVMtvBzoznz+g69ZdGLy8OOj24gyFbb3Io49IBh/Qjhh3j4FUcKmqaeSrj+S1kACn1CxM6AQ4ez+4r4Nzw72Br533Nusgge3RbfPbzjd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 8:48=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
[...]
> >
> > #define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
> >
> > if (folio_size(folio) >=3D LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
> >      deferred_split_folio(folio, false);
> >
> > If, someday, people find that 1 MiB also helps, they can provide
> > data to support it.
>
> I am very confused. Did you not see my proposal above?
>
> Why not this?

Hi Johannes,

For arm64, if the base page size is 64KB, a PMD would be 512MB,
and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
order-5, not PMD-1 on arm64.

BTW, I assume khugepaged_max_ptes_none is intended for collapse,
not splitting. I am a bit concerned that reusing it for this
purpose would be quite disruptive.

So maybe just

#define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
if (folio_nr_pages(folio) < LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
        return;

>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..1670e9869bd3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool=
 partially_mapped)
>         if (!partially_mapped && !split_underused_thp)
>                 return;
>
> +       if (!partially_mapped && folio_nr_pages(folio) <=3D khugepaged_ma=
x_ptes_none)
> +               return;
> +
>         /*
>          * Exclude swapcache: originally to avoid a corrupt deferred spli=
t
>          * queue. Nowadays that is fully prevented by __memcg1_swapout();

Thanks
Barry

