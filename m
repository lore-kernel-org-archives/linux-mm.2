Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB21CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8326B008C; Mon, 28 Sep 2026 20:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968CE6B0092; Mon, 28 Sep 2026 20:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6B86B0093; Mon, 28 Sep 2026 20:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7023E6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:57:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F922A0385
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:57:40 +0000 (UTC)
X-FDA: 85264987080.01.D0CCDAD
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf09.hostedemail.com (Postfix) with ESMTP id 59923140006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:57:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N28GiIEP;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hh3I/m4orWpsUVsDP4+Yh/0I6vIU4pHHsleLblqGjQ=;
	b=gZEgaZgqzgHMS8jwFxDq8qEPqTtKrKxC2Wnw5v+EbB9x40pG7MIdL/etSWAAbUWXxebF6e
	yDxi07vs6cs25Rwye1/+3zT7SE9tEyd4MHiOXRdSnyut4bzkx+vuqXLkJlOeaLz7jRPXRV
	iU/jC0sFsNhLbuRVF0rN/iTFHCRa5KI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N28GiIEP;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643458;
	b=uDqwkhgA8D0+wSatdeNEOxTlO6T8P7/V4OpYRI/TfzR2a4CZNGEDkHP8D/WGneJ2QDZOEe
	q66vBTwfbziAYIsZUdvzHAMCTBa4bwimzYuNc49mSsTnWh1eIea0R59Cw2U6/pKvP7Uc5r
	GxICDZUrI8IZAjGrz/0Yo0RM2PbwxFk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5hh3I/m4orWpsUVsDP4+Yh/0I6vIU4pHHsleLblqGjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790643457; v=1; x=1791248257;
 b=N28GiIEPRF1vGiZ81ffZ9p1faHc1blJESjVHFUFEplNPEdUvXGvJ2X1suy0kKb3vmRHNpNZC
 K6YeiNhB9bGJ9huwLcqk7WRi58rszp/MN9kwOkH5AxT5WWdFwJH5wwV0zLdAqS2E323fzkRnJ+y
 /0TEVKGLSq2QBaUCAx5teD2E=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 318fa190a6eb30d5;
	Tue, 29 Sep 2026 00:57:36 +0000
X-Mizu-Trace-ID: 318fa190a6eb30d5
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <se2tjmpk.ritesh.list@gmail.com>
Date: Tue, 29 Sep 2026 08:57:16 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <655A7615-5885-4733-9E4E-3BDA1FE39362@linux.dev>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
 <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
 <se2tjmpk.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 59923140006
X-Stat-Signature: dfms63oik8m4gfetyax34s6et66dbkm9
X-HE-Tag: 1790643458-823569
X-HE-Meta: U2FsdGVkX1/F4IHUbAc23TUmF2+mrqvo3r7CKmWrlfOVM7LSysOxt6wH89LP3T/2HNoTcutUuyvp/pVS2bhjTzXiPG9lHJYwMc0bHE0/7Y1besrvYhmPlTI/CDzG+UDfo5gk3BQcL7Tpzizxq3fYLn+ZB6shQGcaPbsHn2Uzj+A1NicUFezUW6eyfGxiNlB/Vx1+1OiIurOnclvR54uBCPESfp4LKs7PcCjOO7tgi6xvwg4UWgnoWP3bVUS4JikJdPtlayKaevl3o8c14JbmEEiR1eTerxUyzZ3gSITXVlKs8Sncwha8t9yGwdHrjHbkO3WKNDLXRXGuTenSzee2NIDL0WMW1dvr9T7Cog6hqz0pyEdxcHnlKt4TJiFRnQbluyJ/zZGiGaAYkDI1Z7VKxOR2WftaNxjREMPzOBTfStdjU/2qxhVJKYQd4wbS/FhWfEvqDk1o9DkXvdkGOLPanP+5Gk1bY97tD7xAXWqroVJmffHhml4stCKPlypv15Q4Cnij+DYYzWdazPtdONTRMk453ED0rOH1+7eN1y0wYAvQ815l4Np5aFUtP7pvJG6qRBAI73uac/8PygTLoKwwA6aF3djcNhsIEsV4fXZYSWeOiBK6f/BAMjwCKatwig6aeIefdT9PNLPfsecdmhE8zgwYlh/6hLuGIHrZpchCBat69Dnx8cLXRnt0o02p0YCI4zpdIqVLZQAv8Uy/zrc2AhIjehhZOKKyTxBOoQBpwQ/W58HXlhcdqxUHvDpvy2MnItbXuOwI3H7JWs0zomACyX0X4fS76NMzPrPK2ViWXTVCaWB9RTYh4JRzK25z4T+sw6QMicn1FkvU45yCfzg3CjUt7r6jsvZ+jjd1QwgO4fbW5qaHW0gUNTklhrGUv1ejJf3FLvUZpn6s1laH88mB5hiF/aQBs+MRvFU8gSE4p3IUMrD/LQ/Zqf8xN5Iy/jY3J4Q/3FexERaSQyp20Yd
 ID4nrDCs
 HURKaZQMR2IuXQQAKv1UThXKcTAFfOp208PhIr+/iDrGtfVBZ+ow3n6tFiUDrmPHoM90ppLNPfQSE/XhM6FOygUsekn9PG/kWJpwvAva013paPBSLEuuWdn6YD9201tOCvDQfBpsiaqEjQOFoYSPWMezbF9rtjHR22gF6ggRRU0sle8Kb1YMte2iG7T5uw2iGy6ygnnDvl/hhYc+/qGGI1Ol5dE8+T232+Bg+Gzn9EEcEVor+3WpU0MU9Op+pPyQaCZNV/7n1QKMXm8yWPAFSp035J0yrK5+XTdkXHnbuPJsGnoMLr8Y41aII+sy7BK8jKXqjyyrMPJXI9o8Uf0Go+roFY9zgYvAlLXh8+twY8hc4wVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 01:43, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Muchun Song <muchun.song@linux.dev> writes:
>=20
>>=20
>> If you're planning to review this series, I'd suggest waiting for my =
rebased
>> version.
>>=20
>=20
> Hello Muchun,

Hi,

>=20
> Thanks for taking care of powerpc side of the changes. Is it possible =
to
> share your git/github tree somewhere? Sorry, but it's hard to follow
> which series is based on which and the overall multi-series is based =
on
> which upstream tree. If you could share your updated tree somewhere -
> that would make my life simpler.

Thanks. For now I'll follow David's suggestion and explicitly note which
MM branch each series is based on. That should make things clearer early =
on.

I'll also try to set up a tree later and share it once it's ready. Until
then, let me know if a written summary of the branch/dependency order =
would
help.

Thanks for bearing with me while I get that sorted out.

Thanks,
Muchun

>=20
> Thanks!
> -ritesh


