Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7491BCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 14:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBF76B000C; Sun, 23 Nov 2025 09:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C3F6B00AA; Sun, 23 Nov 2025 09:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B5A6B00AC; Sun, 23 Nov 2025 09:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8946B000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:17:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 459D24FA56
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:17:15 +0000 (UTC)
X-FDA: 84142074030.12.27AB5CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9C961A0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:17:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YjeiOOmG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763907433; a=rsa-sha256;
	cv=none;
	b=jov1SrPuWSVgOc/rxN9Bvhalelbi76wc/2EC5kUf7fRfrtZ8Q4nzMUwjHFxnrqVBvXUc/E
	yo/8T4qLZUdseAjT1THO5owpA0qgjhzc3LeMFktygwVXk843GrkRfTyEhtb7RAwKtiBhLo
	Gq0+6t1n8BUQR+15kLVGiXta4Tyst4o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YjeiOOmG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763907433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuwfALRYAHaIDf+Fw1cMbAo23UnevRivvPzaORkuQNg=;
	b=PikPwgjXQ6yRCdTlFdH3hKzgIjOvLNuKZrwu0DF6NeVsn3XUVFXy9eFKKFPS0RYErWLpvx
	+cJXYyBcziJ1nIDh0GfgqOAUMVKsIi9MpGKjWIWU2lqhyIsqf8iVgdqf3GMvCRHNaGtfbY
	cdMAIQASLC8O04rooIywxg7+GRw0DFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03E86601B3;
	Sun, 23 Nov 2025 14:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2161C113D0;
	Sun, 23 Nov 2025 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763907432;
	bh=hlZPMSOQ4z0z/SegnqaJGdOFl8OKu7ej64VHNnxKfOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YjeiOOmGhl+vYDAP5F3PqObgaBOeH09evuz0Mon8ZYyijzYcypbmuTWlbd8UfY7Li
	 JZxMGVMZgNCugT4C58X01ElFJQ7xeyDEkELKARcivirljBnNMlKQRg+eo4HP87DheV
	 d6gwf1Hyzc/jM57nVWZpS0YtC9d8uBqv/keFn2kFLpgIdX+rHTQkJLC5OLqVPJwWW5
	 tFw+JC6n5hxX0w6FpLsk3sxbPfnJ/lP2jbAlrVoDP26ZyJahCDcEO0mYRVCOKUo16l
	 NAzmmdLtATyY2laWAECozqHTeL9Y16n+A4yLTqSpw5/pbcWrbU1j2Epmj8i6sOVzfL
	 rWZi7jYZsMMMA==
Date: Sun, 23 Nov 2025 16:16:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aSMXUKMhroThYrlU@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com>
 <aSLvo0uXLOaE2JW6@kernel.org>
 <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com>
X-Rspamd-Queue-Id: A9C961A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: p8axo91mr6g1fhwtqnouhp3ru7b8zs9g
X-Rspam-User: 
X-HE-Tag: 1763907433-254578
X-HE-Meta: U2FsdGVkX1+VUu8dI+Y7hR5X7F1pOoPH3ra4p0EE8mI/2KhzkUHC9FHZP4Mig3sHcjpygQ0Gx0i2C8R1X+jhex+LdNuGzYLW5WD7yiY94vWBU7No2mlmK6yi06yDtNfBssoZWOb/OBofT6VJ+UJ8+NjXrNUbhaXNGW7+MVJJVLVwWwiwp2ottUMSrTFXnox56fHgVrJAYIcOLjIWjNNhFd/UZJxbZuxW/c52TprkacfdvWHXEWih1hBdMrSTHyTKss7MC4mqBNsmGrZ9asi+IT6obVyX9cxm5jiQJDKEGL0PZTC8AK0E6JvdlK5aWuqKiSFplOaMpz5+pTYC8oef3kg+LzeVr0hQco44q3Da20e7gY0Z9W3v+hIxSJLsiTs3NMpSfCDfOSVNsCcrrEg32fU3VP/inTGQ4Dj12aAKSuLy+e0k5otWTtpgarh9lorSpAgtXTpMCFdFgkSSvo9cxEMIqArM69zgS/UhYxfGjOE0U8QwhQBTdFz69qiYRSNTbfdonB3Wzg5a6XVaVWGN8cj4uyOcnjkyn6cDyI1p6ftri3qFp1vHbYshHPKfNBVXHa0b+S4H+7+VzfYDAD6B5bsSsu77K6RE/giVt/XNf8/oA9sGjBfFYJd7TwjlBEV4bhNx3jqAFLutFyUhMybIfLaPVL9ZYGXkJDoZ1plEDfnKj48L/CISv+ukoYTPsoW4R+LJ5IrbnKcg+nhKGcqTJ4o886b3iXTJzRm82OGy1dxKkRJnXnXVgPujNGpJSZtMx4L4Cl9XF1LFk5llR+zzS/LCde0Z8B7tV09aMNhFmPoK3HmS7mPFdC7wM4L92Ujb9stgl/Fta2whx1v1Dcz+UixbLEICzFGlBiQfeuK+P3Zv6NSxQ5LwXOzqCh75fxVRt6eK4ZTZFtzPbDMjttejyclWe9muu57dbUBJQikUIXgl4OaUa58n56TIDE6E0O62T6+sv43m0SZv7XFjhj2
 KAvRu4MR
 SrzTRS81Mp3/lXcWwtMzZm2uUFm0sYca3egzm4ieCcgzt2/9wH2LT0uZYoc0Z8ZPXPLha2VQLosUePIV7fDFrYeIvwTHb428t9Pcre61ZsuSkC6GdZJH5AsOChsvKT76Xo/CmKMI0NIQ3DzyEkkrWOanRDFUc3ey5e8IBTuk0NoMqg9QO6H8WeZt/nWVFoBNpJ3UGYUYTlGFru+IswHaCEW98j+WMoYAqHz8evfYyv98rM7CZ1pc2z1CJjtsvjr5B37Zea77EKBfJ8AKqFd38QljeNB9zx43NQaimb2HjLMtzdW5OY+Ey2ELXcN9SM/SbuETQFzzp31AjSnS9ogUD74XjoEj3JFwjYirBC33gO3WCLdnmrCvW9OjEnjGAuHhrh8vzkP10lhhtpP9B7CjbdJ+pMleCsVR5f7rxrzAHOfcU1TN3x4b/OXZ4DJTqANDIafTt8lO/6J8bvRq5AirvuDlZZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 07:03:19AM -0500, Pasha Tatashin wrote:
> On Sun, Nov 23, 2025 at 6:27 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sat, Nov 22, 2025 at 05:23:29PM -0500, Pasha Tatashin wrote:
> > > Integrate the LUO with the KHO framework to enable passing LUO state
> > > across a kexec reboot.
> > >
> > > This patch implements the lifecycle integration with KHO:
> > >
> > > 1. Incoming State: During early boot (`early_initcall`), LUO checks if
> > >    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
> > >    "luo-v1" compatibility string, and reads the `liveupdate-number` to
> > >    track the update count.
> > >
> > > 2. Outgoing State: During late initialization (`late_initcall`), LUO
> > >    allocates a new FDT for the next kernel, populates it with the basic
> > >    header (compatible string and incremented update number), and
> > >    registers it with KHO (`kho_add_subtree`).
> > >
> > > 3. Finalization: The `liveupdate_reboot()` notifier is updated to invoke
> > >    `kho_finalize()`. This ensures that all memory segments marked for
> > >    preservation are properly serialized before the kexec jump.
> > >
> > > LUO now depends on `CONFIG_KEXEC_HANDOVER`.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  include/linux/kho/abi/luo.h      |  54 +++++++++++
> > >  kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
> > >  kernel/liveupdate/luo_internal.h |  22 +++++
> > >  3 files changed, 229 insertions(+), 1 deletion(-)
> > >  create mode 100644 include/linux/kho/abi/luo.h
> > >  create mode 100644 kernel/liveupdate/luo_internal.h
> > >
> > > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > > new file mode 100644
> > > index 000000000000..8523b3ff82d1
> > > --- /dev/null
> > > +++ b/include/linux/kho/abi/luo.h
> > > @@ -0,0 +1,54 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +
> > > +/*
> > > + * Copyright (c) 2025, Google LLC.
> > > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > > + */
> > > +
> > > +/**
> > > + * DOC: Live Update Orchestrator ABI
> > > + *
> > > + * This header defines the stable Application Binary Interface used by the
> > > + * Live Update Orchestrator to pass state from a pre-update kernel to a
> > > + * post-update kernel. The ABI is built upon the Kexec HandOver framework
> > > + * and uses a Flattened Device Tree to describe the preserved data.
> > > + *
> > > + * This interface is a contract. Any modification to the FDT structure, node
> > > + * properties, compatible strings, or the layout of the `__packed` serialization
> > > + * structures defined here constitutes a breaking change. Such changes require
> > > + * incrementing the version number in the relevant `_COMPATIBLE` string to
> > > + * prevent a new kernel from misinterpreting data from an old kernel.
> >
> > From v6 thread:
> >
> > > > I'd add a sentence that stresses that ABI changes are possible as long they
> > > > include changes to the FDT version.
> > > > This is indeed implied by the last paragraph, but I think it's worth
> > > > spelling it explicitly.
> > > >
> > > > Another thing that I think this should mention is that compatibility is
> > > > only guaranteed for the kernels that use the same ABI version.
> > >
> > > Sure, I will add both.
> >
> > Looks like it fell between the cracks :/
> 
> Hm, when I was updating the patches, I included the first part, and
> then re-read the content, and I think it covers all points:
> 
> 1. Changes are possible
> This interface is a contract. Any modification to the FDT structure, node
>  * properties, compatible strings, or the layout of the `__packed` serialization
>  * structures defined here constitutes a breaking change. Such changes require
>  * incrementing the version number in the relevant `_COMPATIBLE` string
> 
> So, change as long as you update versioning number
> 
> 2. Breaking if version is different:
> to prevent a new kernel from misinterpreting data from an old kernel.
> 
> So, the next kernel can interpret only if the version is the same.
> 
> Which point do you think is not covered?

As I said, it's covered, but it's implied. I'd prefer these stated
explicitly.

> > > +static int __init liveupdate_early_init(void)
> > > +{
> > > +     int err;
> > > +
> > > +     err = luo_early_startup();
> > > +     if (err) {
> > > +             luo_global.enabled = false;
> > > +             luo_restore_fail("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> > > +                              ERR_PTR(err));
> >
> > What's wrong with a plain panic()?
> 
> Jason suggested using the luo_restore_fail() function instead of
> inserting panic() right in code somewhere in LUOv3 or earlier. It
> helps avoid sprinkling panics in different places, and also in case if
> we add the maintenance mode that we have discussed in LUOv6, we could
> update this function as a place where that mode would be switched on.

I'd agree if we were to have a bunch of panic()s sprinkled in the code.
With a single one it's easier to parse panic() than lookup what
luo_restore_fail() means.
 
> > > +     }
> > > +
> > > +     return err;
> > > +}
> > > +early_initcall(liveupdate_early_init);
> > > +
> >
> > ...
> >
> > >  int liveupdate_reboot(void)
> > >  {
> > > -     return 0;
> > > +     int err;
> > > +
> > > +     if (!liveupdate_enabled())
> > > +             return 0;
> > > +
> > > +     err = kho_finalize();
> > > +     if (err) {
> > > +             pr_err("kho_finalize failed %d\n", err);
> >
> > Nit: why not %pe?
> 
> I believe, before my last clean-up of KHO it could return FDT error in
> addition to standard errno; but anyways, this code is going to be
> removed soon with stateless KHO, keeping err instead of %pe is fine (I
> can change this if I update this patch).

Nah, %d is ok.
 
> > > +             /*
> > > +              * kho_finalize() may return libfdt errors, to aboid passing to
> > > +              * userspace unknown errors, change this to EAGAIN.
> > > +              */
> > > +             err = -EAGAIN;
> > > +     }
> > > +
> > > +     return err;
> > >  }
> > >
> > >  /**
> > > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > > new file mode 100644
> > > index 000000000000..8612687b2000
> > > --- /dev/null
> > > +++ b/kernel/liveupdate/luo_internal.h
> > > @@ -0,0 +1,22 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +
> > > +/*
> > > + * Copyright (c) 2025, Google LLC.
> > > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > > + */
> > > +
> > > +#ifndef _LINUX_LUO_INTERNAL_H
> > > +#define _LINUX_LUO_INTERNAL_H
> > > +
> > > +#include <linux/liveupdate.h>
> > > +
> > > +/*
> > > + * Handles a deserialization failure: devices and memory is in unpredictable
> > > + * state.
> > > + *
> > > + * Continuing the boot process after a failure is dangerous because it could
> > > + * lead to leaks of private data.
> > > + */
> > > +#define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
> >
> > Let's add this when we have more than a single callsite.
> > Just use panic() in liveupdate_early_init() and add the comment there.
> 
> https://lore.kernel.org/all/CA+CK2bBEX6C6v63DrK-Fx2sE7fvLTZM=HX0y_j4aVDYcfrCXOg@mail.gmail.com/
> 
> This is the reason I added this function. I like the current approach.

v2 had way more than a single panic(), then it made sense
 
> Pasha

-- 
Sincerely yours,
Mike.

