Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14716CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509116B00E4; Tue, 13 Oct 2026 11:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E03B6B00E5; Tue, 13 Oct 2026 11:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3811D6B00E6; Tue, 13 Oct 2026 11:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 120526B00E4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:26:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82D7880B3F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:33 +0000 (UTC)
X-FDA: 85317979866.01.7C52894
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf03.hostedemail.com (Postfix) with ESMTP id 41C2920006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oiXib1pj;
	spf=pass (imf03.hostedemail.com: domain of "prvs=739a28f01=itazur@amazon.co.uk" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=739a28f01=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58rhhcexDgMk2SYcHRrbfJU4LmZDNf9c9uP6HmDCZ0M=;
	b=FzUnLWVILczZqWzs368FaRFzuRiKK05rsorvG6apDEovDbQW9A+gtsCWCg7R9ldsxP67BB
	FYX6PuX39B2JKNN33UIOaLcPBBl3X9hIZr9qJSiAoeQQrxQkHPA6SJTu0H+z5eUVaPB28s
	6oiNY35b6aVCU90w6i1Y6pyQUtvNkek=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905191;
	b=fBJiLgEEKHjMYZce3C5HNST56yjmGjv0fdTTGzkmN3DwL39PUT38Ubx7vZP3v64Tl4uL5E
	++331t+7Q5DmZuyrfTaQiZafZ/peMZ91qsCkTX4NPCsZbDmuHZIt9kDhZpDNIHo9E8pGWA
	dsWp1amN715eaf5cRGS8DgCPyP5TsWA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oiXib1pj;
	spf=pass (imf03.hostedemail.com: domain of "prvs=739a28f01=itazur@amazon.co.uk" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=739a28f01=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1791905191; x=1823441191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=58rhhcexDgMk2SYcHRrbfJU4LmZDNf9c9uP6HmDCZ0M=;
  b=oiXib1pjKw3IJHcngJeb5Y5ud3VkSVZv7aWu9SDs1G5BhbL5a+iF4JuX
   KjvT8g1KYrBm7fGwSIZtlWsQjHLoR1eplHe55IBuTsaeQ7qriL5AnuftW
   e2c8R6G1Nq8ntpUlGBje20bkIxma9m3ZlAG+msoG0ftJO+fuM+zo4fQSd
   lxx3FUC7drn5eJ02hqTlGPdsikab+B52UVw9RM0K5WGyRYz4774sh6paT
   2KJIgQghtMv23ND6jUxrMpgHZpHcU8Wqn1q+JSnL0SNT+SxHXpscKiFdW
   mWmu6NYW2f2wL+9NXveSkOEDmUstJj2YaVjbHuWpXozuCXTYy9OgMzLws
   A==;
X-CSE-ConnectionGUID: QNr8tit0Su634Je3FESKKw==
X-CSE-MsgGUID: taFEz58CSvCZwrQ9VLnCQA==
X-IronPort-AV: E=Sophos;i="6.27,155,1787011200"; 
   d="scan'208";a="31173283"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 15:26:27 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:10673]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.175:2525] with esmtp (Farcaster)
 id 13393493-f492-42db-9553-1d180b22329e; Tue, 13 Oct 2026 15:26:27 +0000 (UTC)
X-Farcaster-Flow-ID: 13393493-f492-42db-9553-1d180b22329e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 13 Oct 2026 15:26:27 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.29) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53;
 Tue, 13 Oct 2026 15:26:20 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: Yosry Ahmed <yosry@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu
	<weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, Sumit Garg
	<sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
	<rientjes@google.com>, Roy Patrick <patrick.roy@linux.dev>, Andy Lutomirski
	<luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, Thomas Gleixner
	<tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, Reiji Watanabe
	<reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, "Ackerley
 Tng" <ackerleytng@google.com>, Takahiro Itazuri <zulinx86@gmail.com>,
	<cc-open-source@amazon.com>, Kevin Brodsky <kevin.brodsky@arm.com>, "Gregory
 Price" <gourry@gourry.net>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Date: Tue, 13 Oct 2026 16:25:53 +0100
Message-ID: <20261013152553.39287-2-itazur@amazon.com>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
References: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.106.82.29]
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41C2920006
X-Stat-Signature: 7ak5ioyjzmtwy7epzyjnkp7d5xip7fki
X-HE-Tag: 1791905191-488879
X-HE-Meta: U2FsdGVkX18OhPTOfqjA6KAKLjFX5sdl5L/BsjuA5k2Giu0kAqnYMAt7B6BSS7nDAV7F784aAp0ZchH0Im3xkV7/mhLVXCSrJFIQYlM1LAYG4OF3lDdPTDCZHbrSwKulrM3ar5yLZBThQIkPD4n8NlBJJWzsQf9AaZAxL6EML2TvRUjItM7PSYB9RjhBBOzNhec03lRV0JSe8wdyWJr25YecRH4JMu/FXwRbzqJtr6ggEV756a0ck2tTHwo4/NRMiu5SaBZEqBpdR1UpaKna1rXsn2aZ/hz/9K0Z5XnOvbh7T21xBLjr5sge1XQIy3hRhPYePjs3vkgDextMVrTI8KXSkVaXeDUdKCkMdbjqFN3OkyhxzoCxmf/CcLN8kHxVhlPDDUqFDktGQDd+5pKAwAxVUpF794MEydnocO/AIYjGPjhGTRLPolixfG9iJGJ9CotU2omLhjA1rJ+9VPyryn/yDcFGHq1iqublV5hJCxEhh0qvMwtQ9+//1azngyK/Pqs9lrEHrRNuhlwPZrjAvUy6po2DDCNJABSkCIIt4Mb1bcnxMG+LQjNmk/ZioktRZQx8bsd8PDC6XtmCrXZnSJhd93W9ifO7xBHTM0D41r7mlHPT7XAabv5NMt7TkFyRGLWT6tIDnOldDS782GyBs9caD6ngDX3nh6zOD+0qLO382gQkoJEzvuCC/ezbWulB1aHKUB0ORSqCxbWn2CQgnM4WkZJPEsGl30M+tdX85PqHjiu0UUWbcgpkT8yzrdQA5uKXzT0GfPTN1IYrp8lGdD+SZrx+QsTKoTqCr/HFkRIa8MscaiWH0lVhKogDFvLqO+djbsf9sl6Qwse5AHzgpbiNkega8IdWTLwGmv9Dj2o15SAHllTS5vzjZX7mO+0UlJuj0pdqP9opWakCMuMC5wKhOc8siUkQKrrHAvr20ike0cHzasyO3CTypquZW7QK4G8AXAk6CvdIrJA7WPI
 QLaQ5qXG
 Zaeo1sM9NQDL/BOzHNShqGeP02E+BM2Ea1Qq4NaJi2RAZCJlyNmzZIp5M6Uwc5rY6N4345hkqW4k50oZBGvSsCKUOxtSjzvEiUaMOtHMfDsiYfriz8XkUwDvk6A2Fzu5d3nLDB4+AgrpuqnouNIQvbB7CRBoaocayke5ICA3qsCiIpriRL3Lq0OnSXSGNV6EqWwHBrsxvL1rPqQL0LLCvERyDTRazyP5jhE57j39l851Ju3M3b8NFAyqCaSdAueCf1WcN85PEBKiZbCf3MoPoAqLZZk87tOwT4X6beDnDe1Ssy01v6iD1Kz77hVfcDfZL9Zy+cYEv06H/IFz7CGkIng/Y3CbNzfQWmlYmaenn5Bq9pEGWvfvTHSlwM7o6mnkwmhuHX6AWuFWn57mn/sYTIepc6kKtKJm9aFwHXjThTXuQw8oP0TPtqzkVThwmsQht3d0vAdGj1WYEjalHK/aVh62rk9hXWEUpowSuWvbnb1fA4lzdPb7gASlwwjrlz3BAtGHR4xc2DmXEg6NDk9oTxs+tnlpbI6f0SHYbcpFWmAKDskthleWpjOVy+cm7CYXJLv5iCb/Dls8KLCF6mASDfei/sOFb1niAdQD30hDJBk5BD3pWva4TZALayXbOrFJs3QhuDj6Dr6ofSAI2Ab2OP63wjUFgCpEegJVnSIPBJjwGU+GtBjJL1w63ODvPMLtEkZRo4qxJyj5ur8aWzYs3e4YL+3swgMHThcMc+O+5lU6YG5pDYyf+MUtaGgWaKo54krppE/DiIT2xcnJcM92wviQJTMIzQme3k5HNwg9ow9A9z2Dv1T3yVV6pAoOP5o0bpHpCmvekcaGCuYw9eDtMHgQh5/sPs1iMmwfr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 07:06:02 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > If that work is not already underway,
> > I would like to respin the AS_NO_DIRECT_MAP introduction and secretmem
> > adoption as a standalone MM series, separate from ALLOC_UNMAPPED and
> > mermap.
[...]
> Perhaps wait until I send the new version, then we can discuss if we
> want to split it based on how the feedback looks like. Does this work
> for you?

Following up on this with an update. Yosry let me know off-list that
ALLOC_UNMAPPED is on hold for now (quoted with permission):

> I wanted to give you an update. I was working on v4 of the
> ALLOC_UNMAPPED series while our team was simultaneously working on
> integrating that design without internal ASI implementation.
> Unfortunately, there were multiple complications with that
> integration, and we will be holding off on sending new versions of the
> ALLOC_UNMAPPED series until we have higher confidence that this
> approach will meet ASI's requirements (ideally in a production
> experiment).

Since the integration with Google's internal ASI implementation needs
more time, Yosry also agreed that I pick up the AS_NO_DIRECT_MAP work
for guest_memfd, separate from ALLOC_UNMAPPED. Here is how I plan to
proceed. Feedback is very welcome, especially from Sean on section 2
below.

1. MM and KVM parts together

I'm withdrawing my earlier proposal to post AS_NO_DIRECT_MAP and the
secretmem conversion as a standalone MM series first. secretmem
removes kernel access to its memory entirely, but KVM still needs to
access some guest memory from the kernel. If the MM part lands first
and the guest_memfd integration then requires a different design, we
would have to rework it right after it lands. So I'd like to settle
the design with guest_memfd as a real user, and post the MM and KVM
parts together in a single series so that both sides can review the
whole picture. Once we agree on the overall design, I'm of course
happy to split it up so that each part can go through the MM and KVM
trees.

2. Kernel access to direct-map-removed memory

I agree with Sean [1] that the way to access such memory from the
kernel, whether it ends up as an extension of GUP or a new interface,
should be generic rather than specific to guest_memfd, so that other
users of direct-map-removed pages that may come along can use it too.
It is also still open who should establish the kernel mapping: MM
could do it transparently, or callers could create one explicitly on
demand, either with existing MM mechanisms or with a new one like the
mermap. I don't have a concrete design in mind yet.

As a first step towards that, I'd like to:

  - List the use cases that stop working when GUP rejects
    AS_NO_DIRECT_MAP mappings. On the KVM side, these are mainly the
    gfn_to_pfn_cache users (kvmclock and the Xen shared pages) and
    kvm_vcpu_map() (mostly nested VMX/SVM). Accesses through uaccess,
    such as kvm_read_guest(), are not affected.

  - Look into each use case and sort out its requirements, e.g.
    whether it needs only the PFN, a short-lived kernel mapping, or a
    kernel mapping that stays valid for as long as the vCPU or VM
    uses it.

and then work out an appropriate design based on those requirements.
I'd only consider supporting the use cases incrementally where that
doesn't leave guest_memfd with a list of caveats or an ad hoc
interface.

3. ALLOC_UNMAPPED and the mermap

AS_NO_DIRECT_MAP itself works without them, by zapping the direct map
of each folio. However, guest_memfd will eventually need a temporary
kernel mapping to populate guest memory via write() [2], because
folios are already unmapped once they are added to the page cache.
The cost of TLB flushes and direct map fragmentation also matters for
performance, so I'd like to keep discussing these with folks
upstream, building on the direct map fragmentation discussion that
Kevin led at LPC [3].

Thanks,
Takahiro

[1] https://lore.kernel.org/all/anZfv81jLSU2qY9G@google.com/
[2] https://lore.kernel.org/all/20251114151828.98165-1-kalyazin@amazon.com/
[3] https://lpc.events/event/20/contributions/2420/

