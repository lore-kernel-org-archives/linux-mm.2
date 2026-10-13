Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA5ACC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8C36B0088; Tue, 13 Oct 2026 12:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A506B008A; Tue, 13 Oct 2026 12:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAA86B008C; Tue, 13 Oct 2026 12:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCE896B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:07:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F9B280D17
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:07:00 +0000 (UTC)
X-FDA: 85318081800.11.A000E69
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id E351EA0006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:06:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ruIeTRbO;
	spf=pass (imf15.hostedemail.com: domain of "prvs=739a28f01=itazur@amazon.co.uk" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=739a28f01=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791907618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RGsatsPAyQIBEtdraUseJGGZDIDfWt4LgToyJkkY0g=;
	b=CxLBCox2AwS9KSWirb6W0IRmClcptTmiBWErztS3rXEJdSAyeYxKlEEhScTRZaRLeoUhcX
	ATQZHArV54eO5bnK388scMRohUI9pQs3u4QTLjTiskdQp7axHWKpvp687q2p1PrtBExW+m
	dWkisoAXZMBc1vuwHJUKgs9rGk/0Cmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791907618;
	b=5SFBKHEsA3SlH7bePft/jaAGtgU05Ul6i216sXlA84Fb2aQpgM7NQCnwOVrmIAFIffpINI
	r+WJE/3c3PF1Q3Cr2ypbieL2qH+GH3ZAk56783QcprWdYFI5PnWm3omlM4QZO5NiGlDjdD
	GIbT/ny7K21DqmqjAkhMVi10Cw8bW20=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ruIeTRbO;
	spf=pass (imf15.hostedemail.com: domain of "prvs=739a28f01=itazur@amazon.co.uk" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=739a28f01=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1791907618; x=1823443618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5RGsatsPAyQIBEtdraUseJGGZDIDfWt4LgToyJkkY0g=;
  b=ruIeTRbOkK656ethvMJQ7Mm7CtxnPk/VLs0ywFMWnYd9OkVaQ6PceKOb
   onBXHkvztNg+BrBYgribp6+8hKLk/Y3VyZUA0G9G2HSM3X9hs3iMjV6ec
   Ftk42+7swHdFNS4xoM5S5zBsUhTxPWMiBaGqE2vw1ZgemEsQi/lyG2PeZ
   7euWcOqXF4Xg0cxyRfzAam8xueS0XvyY0cNwA57q+yUoPcX3quxpoi17w
   EtLduMESBgmOv15Wdyra4tN3xFqJ5+6wh9nWy+HZvcLk7XjEn9SrzXEqm
   c145pubLhgYhfh7owEUxzPRTh3XDySw+ccN/XQB94UWg3WqRytgFR6QYZ
   A==;
X-CSE-ConnectionGUID: EzT8FQ1qRkitCh9eAqylmQ==
X-CSE-MsgGUID: 0N5fJEVHQK2EpK1JLFPKKQ==
X-IronPort-AV: E=Sophos;i="6.27,156,1787011200"; 
   d="scan'208";a="31138648"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 16:06:53 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:15933]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.46:2525] with esmtp (Farcaster)
 id 95bf7a0b-1374-49ed-916d-f238717f74ff; Tue, 13 Oct 2026 16:06:53 +0000 (UTC)
X-Farcaster-Flow-ID: 95bf7a0b-1374-49ed-916d-f238717f74ff
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 13 Oct 2026 16:06:53 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.29) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53;
 Tue, 13 Oct 2026 16:06:47 +0000
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
 Price" <gourry@gourry.net>, <kvm@vger.kernel.org>, Derek Manwaring
	<derekmn@amazon.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Date: Tue, 13 Oct 2026 17:05:58 +0100
Message-ID: <20261013160557.54828-2-itazur@amazon.com>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <CAO9r8zPOkuRGv0X=nBbAzTUjUyaB7zAJLUigetSXEVPxWpyGxw@mail.gmail.com>
References: <CAO9r8zPOkuRGv0X=nBbAzTUjUyaB7zAJLUigetSXEVPxWpyGxw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.106.82.29]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: E351EA0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rj9qu3s3oog1ic9s1g3modu4d75h71it
X-HE-Tag: 1791907617-869100
X-HE-Meta: U2FsdGVkX18FXlkYFROj9pfXlbfdagTfnI/Ce/KpP5/hdMBqauFNKj/zXzQ6j7X7Fj74Z3VUZ3F7gytmovqUIX2hmXfXE377i4JjK1RYMhnY+DaRrO9tmQjl99bmgE3EtJkgpxWfO05LznxoONycXCGZJq0Wfa3CNB0DKCTh19NH/sVdoETsLNX1ht515UVu0RUA31cbDGmAZCTBCwiedJNWfQE1WLU3rJfAt7MkBP+uzPaj2+TmhEeZK+FyBtug/OxXwooiRcijV9P89e8tz4klXKtu2GCxGEtJqqO2OvOirpBlpQVZGcbeY+5TJ3pGs+upRHotBcHtZOUKXmDKwjFFV/gjemqjCm1xYh2N0LcVOaT13I9Dg+IvfDXpXCNbqoVZiRkk3ftawZOihAMJV0SJSKS2/Di1d/4XDuPnUOHgcS55Bl8ElUExfYOQDrIFRFhX4s7yL77o74s1++9gMk5I5vrwCZHTWIAT3TE7viW7j6Umz0KKsmBFN/zmXA8TSN1LE0DRHHbMLQ7KVIEKgq+w59KOubqutcyoBt1CJEoiOrcouC+Qat7b0fWhW1OI49EkpwzPvl3g0+A6yyOkR6K0Vl0Y7MZLJn74/yFqb/LeuoMF2FFaB8gIVczXiTvku6p6TaBeK3yhvgtZsiQ1TvPhNrapDUaFzTZSuTnrooxTWfJoBJKcn8gotuhqHEtO5pF4Cv5f8lNaP4HHgA1VE9dfBUbNo+oMlQbYI+SjdWqe1sB20m1swfgyz/ZjyldUZ4GqD6UCFGCXrxODZmbazNHXZPvBpIQ3q8oDU+RwO7U4J6y0dGm1IBPTlHrv1nir5VqC1t6NAgAnhgsM9g6j3r4VrgMPMnlc3a1OOQ62gyHdAWZBXbELkcVFjGu5vxonRc2hOQXFi/ttPqAtvIhNN1d5gxQzPUI0qyyr2ouVnwT239Gw8+eKHSIiIjWSXjWX20m21J5FZXbkpzjlQLK
 Mt2T07ji
 rGIQSkQw5X9+JpM0ylTcT9/x3ZtejPXXwstzPRGY7VlNOaGfSV5Vh7U9sgdrEj5ksmuSCU/tvHSRpcEmGQOHc4MGX02zE0wQiyHkcuprA+wPPMEToXODshGy6cfAKkUU225Neh53gTGyvzHLiNny2/5VuRSh/2CgjFujkRyVmKnBs5IazZMg+SmpQrehb/WDvyJ3eNko8PcOzmV/KigQwOFjqhwdFOjtIJrB1PUmUDwzK0zM62gW1UaefcgKngxhOtqfCoNJ2fF8ni9wSR+BE2dAC3Oui0jJlECNuhSwDiNpgIsd62wUhxrQOl6rp0M7ikgKhjoFxLp1OxFwOjWrHCAx64X65PD8bGhFqXijfdMIxyLHtdPECM3Hw4hzimYfXvdKqEYzLy8vDrWcVT+8YBMpxAdSo5tIE16na8Xl/IYb8oRJUmHsd2H+tR3nJskWiD68FLAW68L0foaUYk48guASvLgWzpRD4ua2CL9cbJRJKbIJedztnXI+UV7bReokseHEEg1ebnHs1ewUDmpyQ/YzD+TvFqLnHh9lNUGoGGqDT7id74HN7mPlv4ca0AgPS6jcnB8Koqs+F6zvgZewsLSMU69/tzNAwJSWTILGq5/SENJWHz6vTst8BPLJdiUV3vIa6wXRQjtJa2o8o2O9W5lM8HWELk4i4/WZlvOsnMc759CtuLLQB7rB5Cp9DcOAVyG6fXofMnByFonmU1Ec3sG4THGEY/teY0LXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 08:36:54 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > 3. ALLOC_UNMAPPED and the mermap
> >
> > AS_NO_DIRECT_MAP itself works without them, by zapping the direct map
> > of each folio. However, guest_memfd will eventually need a temporary
> > kernel mapping to populate guest memory via write() [2], because
> > folios are already unmapped once they are added to the page cache.
[...]
>
> FWIW, I think the mermap can still be used without ALLOC_UNMAPPED, and
> I did have a newer version of the x86 patches repurposing the LDT area
> for the mermap, and simplifying the mermap implementation a bit. I can
> share them privately if you want to take a look.

Yes please, that would be very helpful. Thanks!

Agreed that the mermap can be used without ALLOC_UNMAPPED. To give a
bit more context from the guest_memfd side: I can't say anything
definite until I've gone through the use cases, but as far as I can
see now, guest_memfd needs the mermap only for write() support.
write() is an optimization for populating guest memory (e.g. when
restoring a snapshot) and isn't functionally required, because
userspace can also populate guest memory through its own mapping of
guest_memfd. So I currently plan to keep write() support, and with it
the mermap, out of the guest_memfd direct map removal series itself.
Since ALLOC_UNMAPPED is the main user of the mermap, it may make more
sense for the two to land together later.

One thing I'd like to look into is arm64. Firecracker also runs on
arm64, so write() needs to work there too, but the mermap currently
relies on the x86 mm-local region, and it sounds like your newer
version relies on the LDT area. Kevin, do you happen to have any
ideas on how something similar could be done on arm64?

Thanks,
Takahiro

