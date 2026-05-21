Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28B8CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272656B0088; Wed, 20 May 2026 23:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A306B008A; Wed, 20 May 2026 23:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186696B008C; Wed, 20 May 2026 23:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0647D6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:01:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4CEE1A04C1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:01:01 +0000 (UTC)
X-FDA: 84789925122.22.7815AF6
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id 779D8C0003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:00:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mksmSm+w;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779332459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSWt6uzZfaEEioJZG86xnGAHhJIk7a5MEe/eyJLSA6I=;
	b=Mp8GPVeCBD3ll/M455ceanJZuRpn7IH9PmxXYC42pAtcc5psBw/5pTef/YthmPGa7BISWn
	QlDU44XtCwzdNnq8szSiz+MZZOZwEv4V7fKb3brLXcKIkY0n/VtN2AXzNI6e53u/mQ8F6w
	xgnxS7kto6CWpS4zfoRHjizyzvZOfs8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mksmSm+w;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779332459; a=rsa-sha256;
	cv=none;
	b=crIbEfmpHp7JJw6ctCJE8yUA5RDc0HqWQh0EBwlvy4r5bI6clqIdii0dF5xddfQ1wqKcWA
	a8KiWGwT+DtUtOlH+SN4X00dx3nmQBLxqbIV/oyDYItCgpk0bm4eH/G+VGv6H+EkX1t2fX
	+p52LzVixeLIh+csQp/9sYTzJuU2FMA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779332453; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vSWt6uzZfaEEioJZG86xnGAHhJIk7a5MEe/eyJLSA6I=;
 b=mksmSm+wRafg4kRpDtcKs3rj2kLdm85I/aH5YyIwrSfk+hA/kPIxf+FBL5TL2RNsQ38IVK
 7A6NIoduMz7xJEwAG+3zr0gN4p8QQtGDQaAp8ltVn1Y1IpHmB+fSOA7getP9qJq3LaeSth
 aj3lV6w3OgYIXVn7kbc50TBTeD9cZDF39vv4vntxCrEAm6U67+oLHzwraB/8ilY/rbQPJU
 F2Y1Z+TKcdjQM3ksqQojDe1gaNMj+krh1pLtBwfOFzl5n1GifcKdKeYGOqX8X2U7tF0bn8
 YUIqXjdqbfXEYXY5UCIh1b3EyMzL6EWlxWVVmAApkxsigkbUXXA5u2RW/25pkA==
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Content-Transfer-Encoding: 7bit
In-Reply-To: <ag41kVX1wky9hNXc@nvdebian.thelocal>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <ag41kVX1wky9hNXc@nvdebian.thelocal>
To: <apopple@nvidia.com>
Message-Id: <20260521030030.3566-1-lizhe.67@bytedance.com>
Date: Thu, 21 May 2026 11:00:30 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a0e7563+51fb3c+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Mime-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 779D8C0003
X-Rspam-User: 
X-Stat-Signature: puoy3s3j5jtoazioyr1pbfec5o8xw3ue
X-HE-Tag: 1779332458-63953
X-HE-Meta: U2FsdGVkX18nVCpbmWC/u5wvAzzL6up+DvjRwuAfG98qWQl45b+oi+P+hYaeWcmJXxL4G7/eRF0p+PZ9E/Sgw6TppayPtTw3F5AAkkiaS+Id0C4Lcw42AIHlGYGqy/6m9qDwRuFC+8VxkLpnT20xT1F5BLrTMnXun9gkebZ9k1hb25USBJ5m0iveGevFGUXpDmd84oBg9oONgq8f4EyYhLA8ObdFApbtJj0Wxli6p6Qm0kjxpD1Y35RTxvNHeMb6Ri6kUMetyU2mqlKaEs2jRf7YZmV0SXNrrbaJJLx/N3UH8RPa7b0br3IJnc6p7qonlD9s1367tdOndFaLM5iODQfuV6kE2EBBCaPALju1VWwUszvXRoZrPrbuK6uk+vGSVn8o7hPn98HW8uxAZeGjwSyV3Wdrexwp+90mNFtw6ivRPBxyIrirAdrDDW3JNRE4MVjqN+7a7COzRgmYmE60OpiNjl6QYG/rDH6bbauXGYsO1CgUa+t8vdeXw+rZsPADpOwBaYg7sR4Tx/QuapRGBKGrTe1b1PHuYR0vS8nCD3Y1ZlheZpXjtRN8p9/VGVceXH4G9egmRcFU2cHj+Ygpax0hd98+iCdJsRJkccvNlnf7L6beKKSfXYniauHViiZ9sj4n+MMeoK23XWP+DCbGLdGBxfKbRQqjwD8XRVwyFtOArHf+T1G37jMXvCTL7LxgO4tYY/CmNzf6stH5Vwd8EOgz0MjJhM4G2L0DJaPK0CRXaIURD9Rae9DyMtAdGKmkUUC+00fTHndFZ8Rwp41ztv+xTnHOLZdATNyXatIWZ3MW4d2b7IsbKmPUEP+G/ICcMD4nCGzt9eUIMqsa2zIm12ZUxQGGjOX/jQZJQhcS4+Ik3n7kCf5ewk+/TMAMq7wFZoAe3Z5dqzn/dEox9IV14MKY4Q3gaG4bD5wsyOU4EZP4qQiPzd05lF8vm0kOqVJPFG6OgCY2FodNXpzmtQS
 odVWwDvX
 dIUVBqldnuO8DUUxjk3zN5+AUyw/0+Q33EH1gEYIwOvNDgPOyED0qIAd5dTpk4oyaDmIEHQVXbG9382q6mB/sp07hkFT1PLYC7iZMxAiak2flMw7iCcJj1Do+05ocw/xdp6QEGBZQWcZ+TEMHV8yLF7yP4/L/ZhsXtJ29+IeSxFR2QyKXbilFiDMz9hruwQhlibGKcwAqYVH1qlxHXGJVNbC1oHGTVbKdtAQHfszS+kBO4tyDNuB01xAr9vPux6fpS7o7wJBzh1TV7TWuHYxPx0Jv4TbRUlHu4nD6xOZQ98ZSiSyZ6U9Xb1yw+i6ATRnBHpCmAOxOVztFBnKszQmlP3oGJxDoUyhb7irx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 08:36:08 +1000, apopple@nvidia.com wrote:

> On 2026-05-20 at 21:57 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > On Wed, 20 May 2026 09:20:18 +0300, rppt@kernel.org wrote:
> >
> > > On Mon, May 18, 2026 at 04:57:00PM +0800, Li Zhe wrote:
> > > > On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:
> > > > > On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> > > > > >
> > > > > > Performance
> > > > > > ===========
> > > > > > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> > > > > >   Base(v7.1-rc3):
> > > > > >     First binding: 1486 ms
> > > > > >     Average of subsequent rebinds: 273.52 ms
> > > > > >   Full series:
> > > > > >     First binding: 1272 ms
> > > > > >     Average of subsequent rebinds: 104.59 ms
> > > > > >
> > > > > > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> > > > > >   Base(v7.1-rc3):
> > > > > >     First binding: 1515 ms
> > > > > >     Average of subsequent rebinds: 313.45 ms
> > > > > >   Full series:
> > > > > >     First binding: 1286 ms
> > > > > >     Average of subsequent rebinds: 116.93 ms
> > > > >
> > > > > This is really good improvement!
> > > > >
> > > > > It would be also interesting to see how the template approach would improve
> > > > > "normal" memory map initialization.
> > > >
> > > > I also experimented with this approach earlier. Unfortunately, in the
> > > > normal memory map initialization path, functions such as
> > > > deferred_free_pages() are invoked shortly after struct page
> > > > initialization, and this function performs both read and write accesses
> > > > to members of the struct page.
> > > >
> > > > Non-temporal stores via MOVNTI are primarily beneficial for streaming
> > > > write operations, where the cache lines written are not expected to be
> > > > reused by the CPU in the near future. In this case, however, data
> > > > written using MOVNTI is immediately accessed again through regular load
> > > > and store instructions. This results in an access pattern that resembles
> > > > a write-then-reuse workload rather than a pure streaming store.
> > > >
> > > > Consequently, non-temporal stores do not deliver the expected reduction
> > > > in cache pollution, and using MOVNTI provides no measurable performance
> > > > benefit for this particular workload.
> > >
> > > We can split initialization and freeing into separate loops if there is
> > > overall benefit, but this needs to be verified on other major architectures
> > > as well.
> >
> > I agree with your point.
> >
> > > > That said, a template-based approach can still accelerate initialization.
> > > > Based on measurements from this patchset, it should improve performance
> > > > on the generic path by roughly 10%. I would appreciate feedback on
> > > > whether such an optimization is still considered useful.
> > >
> > > Improving the memory map initialization by 10% is valuable.
> 
> Agree with that - GPUs have to hotplug 100's GB of ZONE_DEVICE memory so any
> improvement here is valuable. Thanks for looking at it.

Thank you for your feedback. I will try the optimization after finishing
the current patchset.

Thanks,
Zhe

