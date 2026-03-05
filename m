Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AEDF30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA3D6B00A0; Thu,  5 Mar 2026 04:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AAC6B00A1; Thu,  5 Mar 2026 04:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0FB6B00A2; Thu,  5 Mar 2026 04:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66D616B00A0
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:41:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12511140867
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:41:33 +0000 (UTC)
X-FDA: 84511516866.05.71C03FF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id A3184120003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:41:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vr6rx4O1;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJLa5Y/X4VqnhxQsoLxL5obFDspxDX+hb5cuh+74gPE=;
	b=iJLa2985GyduRAZjC7MDUvtoC8uoqo7ez7i/8KqA8QJvxMkLyihvCy/tKcssj6C9l3uVJq
	zKvuq8Rt8aCbebN2vt5n9SYkZCRcfb1Z9oZqktYEIZKjL2E3FulReiEtKXZG8hDqdBrJyw
	cuNZIo6RE9XDgcm2jly6ooUMC5ilBWM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vr6rx4O1;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703690; a=rsa-sha256;
	cv=none;
	b=rYal6EYDoo0Mpx6E9WoReARpJAP+COOdf2zAvBnYBuur0jK+n3aP6E/MqOa0hukpoxT0Oy
	5hTe0U6aeVoBuH2d4GWOwa4iE1F+LlT8epHIUKOshsHFe+CKv4LDx3lzAMLZTg1p9RgX6p
	qbctPIsvomW8OwhDFMHiJvA9jb9WyXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703691; x=1804239691;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2qvm58VUYoOuRXtSihFKCPOXnuEdrSrdpWG97mxkXvE=;
  b=Vr6rx4O1asln4PfkpiPI71RlZZ7wUaXKV6LxPO19Hbc/3I61+yVJOcQ5
   JxuFcNUg6NMODJDiE9s3wyKQUdCV+xJHlf4Yvu3l/gc5EB6+e/3ASJ/lb
   mEtJ/GvuhYZ7BYl5AhjiKIw96eZx1M/+s8dvMBjGLVvyNXXPp+WlpVG7Q
   PL1QjOPByx74q8/PsxHiRDrdBURkG1oCg8ZxKmnZ8Hu22wUvc6euKCQD4
   IVTl+OXg3EW7f2H+fno118i0A8AIAsBg2wdOaniRoj3coCa/esGX8GLNk
   cVV128hGQDJhMtIbCWDjJojiR6TdPwO+Yw4Daua7UDCZ1HMDPbE2IBIWQ
   g==;
X-CSE-ConnectionGUID: hfkOmOLPQiGwWKEzrVTTsA==
X-CSE-MsgGUID: cu3C7XEZSfGZlCU3MqCm5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="91176472"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="91176472"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:41:30 -0800
X-CSE-ConnectionGUID: YJs9GVqJTXerL5EoUNoTXg==
X-CSE-MsgGUID: op1wlOsBQL63b3Naw2fmVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="256511713"
Received: from vpanait-mobl.ger.corp.intel.com (HELO [10.245.244.71]) ([10.245.244.71])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:41:27 -0800
Message-ID: <1976868a95fc08323100ad3a863695768aaa2152.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	intel-xe@lists.freedesktop.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>,  Simona Vetter <simona.vetter@ffwll.ch>, Dave
 Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>, 
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>
Date: Thu, 05 Mar 2026 10:41:23 +0100
In-Reply-To: <f8ff2118-73b9-4f2e-ad36-b6de6164ef45@kernel.org>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
	 <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
	 <f8ff2118-73b9-4f2e-ad36-b6de6164ef45@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: A3184120003
X-Rspamd-Server: rspam08
X-Stat-Signature: 4ecbx7z53brwm5fy8s896nirzxxkz49q
X-HE-Tag: 1772703690-334015
X-HE-Meta: U2FsdGVkX184DJWHDz2k5ujJhAk3g6LDXPa8KmyIUC+v+9UZ80ah7ZiZHG6VYsdQOPoWyPprr0Wa7ZxvnFyCU9wGZmjc8LCJ1qTWQwHFCL7+mQB84TVHqK76W2/rnCDCGE+76iVuSwizynNBasu2E6FYYzcAoku6Scg14XFMKdnR59yQO0hiKHr62qnFzAsmtqvKtQWHvU9ZVK12F4wysS7Cifna+riCxLfX1dxhXXOHMFKvCu12zMzTARjMEDjXpxG0J7mTjixU1tGJK1CmKQ1hiG0nIVrVl28aAg+1BO4g7TgIwmDkmUONNBMA/sFRN0mGaNXSc5kFkTEgBC3NuM97iVxm9VK7Z3F2P9zuPjP5bCtHkHd/ScjRNDVFS+hfLLFLVmY9VwMsFVwE77lXixc8w/i782XdYnbAsDzWnGxyq13Fo/JUvNysT6PlzRz6DSVQ4llYRDkkIDTJ7ALoMXI3OsXKPAMB897kVGyXUKekM3rRhMbOpd8flXJM6WgyCeTUvg0g7cor3gie4b8n7LMHkSeHU12IxCrQNBPaK0IzOAuwshn9Am4K9J4rpYLgT+CZBXSWNOSPhkUyJNvIE97zq09bt6StCo9eI0hc+bm0rueRQ1OJWU9hjs/7eZsHOuLid1ABT80acHJhF+GE/k2tnSSDO0cCOD0mFkzD7adgmf613TaVGGjKVPhhq6RgIKtbdBJR4HgNklku8rFDTx+hR59yTjkjD/fCvkI29+6xeBp9Jbltw0qisQ7GhNU5Nav/llygZjxBZy031uugeVRsPM/pw7x0amilWyyzi99dZR561jdak5reAjWvqOQn8EeJjSjCWttUAqIkY+UNbVe1qB2wcgy5tTmpyJ2Kg3xQ3zXdkSTIYf9URqNAkIoAAmVv1XvKCEnzO8Q31SEDJtYprQ1KcAIxPsPOrSXibwiUKy66sF9p6XYhDUC18Pdn4rM0AnC5xgU9YaZoc9w
 8uACR4Ty
 /dE6ei3Y+RSkyL0ZYzCaGpmB+6Mth0lCIc2mK0LjX1SIC9IHXM2x6kIXRnW6oEOZw/salnS7XhweS69JWd+GlC/fVLH7lMC6uDE8C1Gx+x82eqpwu6tmzc4W7I8TYV7+MkcV6wy/m6stcRB1WIx/khP9fKXH9kSz/4tkp0DNZ2Uz+hkaOqGsMEJG3JVStYNLTl+bQT4BKp4suTKvMGvC9y7dPvJtvqaJ+E0sHuyB6Wbtdlq/4Z5zBaGV2d0PAu6nFpYtS7G7PI/hM50cWrG6NpWarOg5kawYWyhZtp870jHf26vJmq+iKSI0q7T4rF9YO5o1TeMVmv6In25UXdrz6i2xsr20aOFqJUF3Ag4IVcAy9OOQHBkELqeW3npDHXgn8WLyd8u40oIcP6M8jtnH+Geh2K9j+LpE7o8lKy586KbVWZZNH8xsQJqIbKhh4mZYn0sGGuyJA4xbb/35kkF/lTJPcPJaRbf4OCX2RtqjlZSDkAa54RkRy0lqlFgijVIxJ9yDUsaovUN5Zr0llK16P0TUw0cm+xcZlGYv5AIYQXxmBTgB9Mu2IRCohisz1FnKUHxflu4gs1OzggjawN4t6okExHb8mbaFuZkNnN9b8DumPkMKJk+2M3bwLjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-03-04 at 20:45 +0100, David Hildenbrand (Arm) wrote:
> On 3/3/26 14:34, Thomas Hellstr=C3=B6m wrote:
> > GPU use-cases for mmu_interval_notifiers with hmm often involve
> > starting a gpu operation and then waiting for it to complete.
> > These operations are typically context preemption or TLB flushing.
> >=20
> > With single-pass notifiers per GPU this doesn't scale in
> > multi-gpu scenarios. In those scenarios we'd want to first start
> > preemption- or TLB flushing on all GPUs and as a second pass wait
> > for them to complete.
> >=20
> > One can do this on per-driver basis multiplexing per-driver
> > notifiers but that would mean sharing the notifier "user" lock
> > across all GPUs and that doesn't scale well either, so adding
> > support
> > for multi-pass in the core appears to be the right choice.
> >=20
> > Implement two-pass capability in the mmu_interval_notifier. Use a
> > linked list for the final passes to minimize the impact for
> > use-cases that don't need the multi-pass functionality by avoiding
> > a second interval tree walk, and to be able to easily pass data
> > between the two passes.
> >=20
> > v1:
> > - Restrict to two passes (Jason Gunthorpe)
> > - Improve on documentation (Jason Gunthorpe)
> > - Improve on function naming (Alistair Popple)
> > v2:
> > - Include the invalidate_finish() callback in the
> > =C2=A0 struct mmu_interval_notifier_ops.
> > - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> > - Use lockless list for list management.
> > v3:
> > - Update kerneldoc for the struct
> > mmu_interval_notifier_finish::list member
> > =C2=A0 (Matthew Brost)
> > - Add a WARN_ON_ONCE() checking for NULL invalidate_finish() op if
> > =C2=A0 if invalidate_start() is non-NULL. (Matthew Brost)
> >=20
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Simona Vetter <simona.vetter@ffwll.ch>
> > Cc: Dave Airlie <airlied@gmail.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: <dri-devel@lists.freedesktop.org>
> > Cc: <linux-mm@kvack.org>
> > Cc: <linux-kernel@vger.kernel.org>
> >=20
> > Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > ---
> > =C2=A0include/linux/mmu_notifier.h | 38 +++++++++++++++++++++
> > =C2=A0mm/mmu_notifier.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 65 +++++++++++++++++++++++++++++++-
> > ----
> > =C2=A02 files changed, 94 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/linux/mmu_notifier.h
> > b/include/linux/mmu_notifier.h
> > index 07a2bbaf86e9..37b683163235 100644
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -233,16 +233,54 @@ struct mmu_notifier {
> > =C2=A0	unsigned int users;
> > =C2=A0};
> > =C2=A0
> > +/**
> > + * struct mmu_interval_notifier_finish - mmu_interval_notifier
> > two-pass abstraction
> > + * @link: Lockless list link for the notifiers pending pass list
> > + * @notifier: The mmu_interval_notifier for which the finish pass
> > is called.
> > + *
> > + * Allocate, typically using GFP_NOWAIT in the interval notifier's
> > first pass.
>=20
> Might want to make it clear that the fist pass is "start" and the
> second
> pass is "finish".
>=20
> Two-pass makes it sound like we'd be calling the same operation
> (e.g.,
> invalidate() ) twice.
>=20
> > + * If allocation fails (which is not unlikely under memory
> > pressure), fall back
> > + * to single-pass operation.=20
>=20
> Do you mean that the core will fallback (calling invalidate() ) or
> that
> it's the responsibility of the notifier to behave as if invalidate()
> would be called to then return finish=3DNULL? I assume the latter.
>=20
> Maybe this should be documented for @invalidate_start instead.
> (behave
> like invalidate() if @finish is %NULL on return etc)
>=20
> > Note that with a large number of notifiers
> > + * implementing two passes, allocation with GFP_NOWAIT will become
> > increasingly
> > + * likely to fail, so consider implementing a small pool instead
> > of using
> > + * kmalloc() allocations.
> > + *
> > + * If the implementation needs to pass data between the two
> > passes,
> > + * the recommended way is to embed struct
> > mmu_interval_notifier_finish into a larger
> > + * structure that also contains the data needed to be shared. Keep
> > in mind that
> > + * a notifier callback can be invoked in parallel, and each
> > invocation needs its
> > + * own struct mmu_interval_notifier_finish.
> > + */
> > +struct mmu_interval_notifier_finish {
> > +	struct llist_node link;
> > +	struct mmu_interval_notifier *notifier;
> > +};
> > +
> > =C2=A0/**
> > =C2=A0 * struct mmu_interval_notifier_ops
> > =C2=A0 * @invalidate: Upon return the caller must stop using any SPTEs
> > within this
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 range. This function can sleep. Return false only
> > if sleeping
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 was required but
> > mmu_notifier_range_blockable(range) is false.
> > + * @invalidate_start: Similar to @invalidate, but intended for
> > two-pass notifier
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 callbacks where the call t=
o
> > @invalidate_start is the first
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pass and any struct
> > mmu_interval_notifier_finish pointer
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 returned in the @finish pa=
rameter describes
> > the final pass.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If @finish is %NULL on ret=
urn, then no final
> > pass will be
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 called.
>=20
> Is @finish guaranteed to be set to %NULL before the call? The
> existing
> code does it, but is it something notifiers can rely on?
>=20
> > + * @invalidate_finish: Called as the second pass for any notifier
> > that returned
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 a non-NULL @finish f=
rom @invalidate_start.
> > The @finish
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pointer passed here =
is the same one
> > returned by
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 @invalidate_start.
> > =C2=A0 */
> > =C2=A0struct mmu_interval_notifier_ops {
> > =C2=A0	bool (*invalidate)(struct mmu_interval_notifier
> > *interval_sub,
> > =C2=A0			=C2=A0=C2=A0 const struct mmu_notifier_range *range,
> > =C2=A0			=C2=A0=C2=A0 unsigned long cur_seq);
> > +	bool (*invalidate_start)(struct mmu_interval_notifier
> > *interval_sub,
> > +				 const struct mmu_notifier_range
> > *range,
> > +				 unsigned long cur_seq,
> > +				 struct
> > mmu_interval_notifier_finish **finish);
> > +	void (*invalidate_finish)(struct
> > mmu_interval_notifier_finish *finish);
> > =C2=A0};
>=20
>=20
> Nothing else jumped at me, and the idea makes sense.


Thanks. I sent out a v4 addressing the above and to a wider audience.

Thanks,
Thomas


