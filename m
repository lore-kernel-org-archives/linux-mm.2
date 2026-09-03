Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14AAC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFAE6B0099; Thu,  3 Sep 2026 03:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7D76B009B; Thu,  3 Sep 2026 03:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7576B009D; Thu,  3 Sep 2026 03:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98A7E6B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:27:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5034A0474
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:27:09 +0000 (UTC)
X-FDA: 85171619778.09.294E341
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CEF3180007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:27:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ig9TJowG;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6995cc46d=itazur@amazon.co.uk" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=6995cc46d=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEDL0hSWB2zeGwWJtgzgRDFbNtGe7V0habGCOAlNjWw=;
	b=BR3YGPSRRx9fW2iZGWn2rWlhYKWcNGkcBPoQK9rolbKkz1UBphQeJ/eLOgvcsm8v8bwOip
	/ZzDRvoXzgq3Rc1hRo6X5I8dZGRhjYIrdSIrRhZtB+80B5jPgLd+cN/VR0WEmSabbR4J6s
	Djv1JfDggqlaKBTV4qdUhZFUnza52yA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420427;
	b=iWppxUkl8wkfbT2ruRP+84nTEb51PteCgsotezkgnwGEfHdrpb36C/3EQLgwWDUuYIYsLb
	VLNvawLU9I9M4tAH5lSIf0cI5Mo3B7d1hafjod9hIYCi7jaZYS/EXb7EkrSJhlMYiJZI8K
	c+N4opmOcviEWlNAJLS0IgdFhByyd1g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ig9TJowG;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6995cc46d=itazur@amazon.co.uk" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=6995cc46d=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788420427; x=1819956427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XEDL0hSWB2zeGwWJtgzgRDFbNtGe7V0habGCOAlNjWw=;
  b=Ig9TJowGaPaez6ifUs7wBJLewtNCxQGaP88zuIFSQYk3COesikj/Ly8Y
   Z2Vk3CNIYjfCu1Xw1AzXmzKJjtFNp222lSe43S+W9hBMqqOY8L92uMSFE
   WzdqpjaIpQ5xHGpzevBM6fSeTYoDuLZAcOVcVV+/JNhvaGv83r0DWEcNb
   Z9Hul3e8QrUS0Xt0qsgZkfuT4zxhpx4pDKvw1uCHvXQ+saE34O+mYRPDO
   K/4nwFoKHhgJE2b/4/I4JRXGPq2k/wgPL591yx+Hyja6nl5qFHtYUBHDG
   iqyI5gOayZ2ajbDzyfv589wF4M2GdUR2ZYUFqSR50IwFsd2XGmbVTCerY
   w==;
X-CSE-ConnectionGUID: a9V3tmWSSHWMehpCtylDug==
X-CSE-MsgGUID: zLigg53MQCWK0KP82k5/Pg==
X-IronPort-AV: E=Sophos;i="6.25,258,1779148800"; 
   d="scan'208";a="27681160"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 07:27:04 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:14068]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.85:2525] with esmtp (Farcaster)
 id 31c43739-7d7e-4b18-a143-798b81c75300; Thu, 3 Sep 2026 07:27:03 +0000 (UTC)
X-Farcaster-Flow-ID: 31c43739-7d7e-4b18-a143-798b81c75300
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 07:27:03 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.23) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 07:26:57 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: Yosry Ahmed <yosry@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>
CC: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra
	<peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Wei Xu <weixugc@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes
	<ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon
	<will@kernel.org>, <rientjes@google.com>, Roy Patrick
	<patrick.roy@linux.dev>, Andy Lutomirski <luto@kernel.org>, David Kaplan
	<david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi
	<derkling@google.com>, Reiji Watanabe <reijiw@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>, "Takahiro
 Itazuri" <zulinx86@gmail.com>, <cc-open-source@amazon.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Date: Thu, 3 Sep 2026 08:26:26 +0100
Message-ID: <20260903072625.62694-2-itazur@amazon.com>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
References: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.106.83.23]
X-ClientProxiedBy: EX19D032UWB004.ant.amazon.com (10.13.139.136) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CEF3180007
X-Stat-Signature: nwiad16en7yfjnhgywgr1kw3nqu71axy
X-HE-Tag: 1788420427-383399
X-HE-Meta: U2FsdGVkX1/2tlO03/FqGTI1pYC1D1m9mZ6+PjkYRRwilZMf+sROtHHxk1bGR+71PCayKkC7UmbEQkKYTzruQvr0XY76F92I6apW2nrzWC+b5fwT0o2JdXEnekvX98z6cb7qSAaLT4+RSDZt+joMQHVUFhz8Y7ao30bxKHl8X/VCNd9nHojspCPgteo7wFt1atC5OKK987lftah/tLA2X2Dmf/zQyhymRyxfSQQO09nkE6EfHI8Hlj4GtkAdXvMl61MhrcxIg3ItVQakayCG72Vgpxk5pkzr24drE9iZ4Uv3vhObkLMYsmqcBuOrrhnv9MAvQ43oq/OXuV8+2Z0PuTOWOaSQGPAZ8J6G9JdGvNPAW4oSgIU96mE+iZHD/aIu+MBWb0meBQ4fjmU/7XeKlqdLylKJmhG340FywRiSTVuvZsrZxS8OpUTs00WjUOumIPvQn7weYVlWuzGF+EdNctee1f/jEkgf0N2aK3hbeNF0jf1PrnewxYXYI/+d6zT2rpCNlUoyFnF3PlE2sxwWWhoShkIbrRwRo6avb5WywJvpOAL8ps2wfRFQBbbuLc2GKyKW9h94jRR5MEy1JxVNv0q2ZntNbQhSXdrnXDaLPxLkCXKgmP5poGK4YoahfOSua+PNP+1VmVTlw0H00crHQ0h0G7NeGJ0fOoZ1Qwl8Fgal0ti6yViGKAm9UlgNqFci8DTtjmnIU+CcYQ+XM9LvZgFgFya1ZgrfPdTPqlo2bta5u3A1aFBuO5SOADGhYEB6Pr5YZ3phg0Hhg0ei54UgeBez4+9q7ujx/dzFZtY5GAdi6CGmqpD7Dnb0TCFt61r9Neu6bTl8o238kCNWKu8l5s+fxZJOiM5e7opu+8oEYW86IfQrjfeapwHJeZO4fve4EB/frxkZl+eboTomOhsG2hZeXTjQPNSowROLeL4yCipbUMV1rI3cTLqEx9ALKNSuOTUVx92aOCH7zLm+2O2
 whA3l/ER
 xiS8rozThy/BVAfoUN8LyGJZylq6WjOQuA54HjQ9X2D/v6hN8dUEcSQxrX1H7LP2fqybF/Dk38G3iq/a/LTczHk9mRqF5mjXpm7Rv46H800/SHJ2vm+UjtT8FJng4ZcqrfZybrpx/lIYMUabgLMlrDzX0FCo9W2+QGuVD9qHJwJ+8gPIgYEqcaZ/33UG/B94r9yO8jk6P9oaXubGd91LLG4/p3WcDEUnHdwCE99WvkIX/kLW4kZA0qkF7I/dHyUQGnU6TkGrJrp8FWQGOre+duvMg1NlrMde53rywDcCNfxgzzq4tOFQpWUybmyiQ1KlhBxJsCuXQa8ahgEKvx85kPrh76fqN5sxge+ZXSKCoN/x1wE7GGHiAD7eLJuIT0EcmusWrSZbfabbhGdIkSZCEMTr7ZzSj3Gae0MEbC5uk/3ZB6bzlgNXTiTSgAgn3UFLj5wY0ic4Y7IQIz8NqiMNiUQ/yEHALUfR/akDwEs0a5WGUiQIDHN5pqaoStUgw7//1XlEfo4pdOJx92YqOOXIn4RSc7IuB4VmvfWqPlzqdiHs0JeiVH9DOPaAe8W9uJFtRVXE0cay9zN1AzP1XVWY2V0ibJERBvhs3vOyDsgARTbXm63Z/S0BUx39sbgu+Nc4Fp8sTXZrWTyAX1EcywDigwVSftQQ91izgad9RMMtEnOCWPkglbyCXHnK7nQyoenTJdbjshtU9zF7mdswN3+OZlxaThRa5YzmRyxAA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some of you on the KVM side already know this, but for those on the MM
side who may not, I am taking over the guest_memfd direct-map removal
series.  I have finally caught up with this thread, and I sincerely
apologize for joining so late; other commitments kept me from catching
up sooner.

On Fri, 7 Aug 2026 15:48:24 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > I'm not ok punting on that, i.e. whatever we come up with needs to land=
 alongside
> > AS_NO_DIRECT_MAP, or at least before guest_memfd tries to use AS_NO_DIR=
ECT_MAP.
>
> Yup, I meant the latter.
>
> > The only way KVM can use AS_NO_DIRECT_MAP without GUP is with a massive=
 list of
> > caveats and addendums on things the VMM and guest can't do.  I'm not ok=
 merging
> > guest_memfd support for AS_NO_DIRECT_MAP with such a list.
>
> This series is not adding the support in guest_memfd, just adding the
> generic AS_NO_DIRECT_MAP and using it for secretmem. Followup work is
> needed to plumb it for guest_memfd anyway, and I am proposing that we
> also punt the GUP story to that (when we have an actual user).

My reading of the discussion is that the generic AS_NO_DIRECT_MAP support
can land with GUP rejecting such mappings, provided that a generic GUP-like
access mechanism is in place before guest_memfd starts using
AS_NO_DIRECT_MAP.

As far as I know, Brendan is no longer at Google.  I do not know whether
he plans to continue the ALLOC_UNMAPPED / mermap work, or whether someone
else at Google has taken it over.  If that work is not already underway,
I would like to respin the AS_NO_DIRECT_MAP introduction and secretmem
adoption as a standalone MM series, separate from ALLOC_UNMAPPED and
mermap.  The AS_NO_DIRECT_MAP changes originated in the guest_memfd
direct-map removal series, and splitting the MM and KVM parts was already
requested during review.

The proposed MM series would include:

  - the folio direct-map helpers;
  - the AS_NO_DIRECT_MAP flag and filemap lifecycle;
  - the current GUP and build-ID rejections, while keeping the mlock
    check specific to secretmem; and
  - the secretmem conversion.

I would leave ALLOC_UNMAPPED, freetypes, mermap, the allocator fast path,
and the KVM / guest_memfd integration out of that series.  This would not
change the requirement discussed by Sean and Yosry above: the GUP-like
access problem would still need to be resolved before enabling
AS_NO_DIRECT_MAP for guest_memfd.

Please let me know if this work is already being continued; if not, does
the standalone MM series described above sound reasonable?

Thanks,
Takahiro

