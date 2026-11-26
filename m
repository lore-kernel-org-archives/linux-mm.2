Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA92606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A+nXzGi6
Received: by kanga.kvack.org (Postfix)
	id CD3366B05B0; Thu, 26 Nov 2026 06:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D406B05B1; Thu, 26 Nov 2026 06:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24346B05B2; Thu, 26 Nov 2026 06:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBEF6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:10:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AF24C03E6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:10:56 +0000 (UTC)
X-FDA: 85477002912.07.E0FD323
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCF92160007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:10:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+nXzGi6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691454;
	b=2TS1a+ScUThLbjnjTWofUUuRIA2PlK3WFzEVSJ1DH0SnRmiwf8xfuBZTZYdt2AnjVCW6BL
	dAGtGuJeQfDU7a6PkR1Du73LEaF2rH9Yki/UAVlTGLb3V+94OIQLAEbh0cDQ675MagQmDC
	h4Egc8WtBumJweZU/sirPXH0nBqxnKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzhfHYOTAiWX4/4QQvlE4sNDOxtXiB/zhUzzBPto7Gg=;
	b=W5464dBukP5BaZ2IRivea8T5rgoz8jHi/A1/OIuf81uIlkyadWXFC6xm1gARQcBaF2VFiQ
	Sgr2GXX6inBA8HPTksA2gcDDdSFMzS3JsQMF6KF5266GA6sPsCW+3qP5qMgs9Rze3MzUg4
	on+MsrzJJFD9NcHSvfw/ESaejuzWXyk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+nXzGi6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CD9E61755;
	Thu, 26 Nov 2026 11:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5161F000C0;
	Thu, 26 Nov 2026 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691453;
	bh=mzhfHYOTAiWX4/4QQvlE4sNDOxtXiB/zhUzzBPto7Gg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A+nXzGi6hA1waDmMchthGQIFQF53hls5vuEY0MNWl8ro9oCLwWl1SiqufjiNXVqyA
	 KlZtB/DTEanOQ9KDlavO2hm+TxpBobgPkG5aecpDsqcXjDGn0xJFFghvOMZhQMRE4s
	 MpZmDd2noaNyR23VJVt5hIQdE96YwmPNeOEj9jUZojYIM+GlSv3zI4ZTxCwlraux2R
	 bZPSQATVGWzO2K2FAvf6zXqNmKAs9WIKiMhICBCwMRIpfEmEgfNdwzrGvQrpHsDqaH
	 v7Lkug97REhA8Gqaa7sjCAy0Cf6na6PQqzu2a2lgjSD8xz8t3VXexLak/FXubRTfHG
	 tX4ad4XqZ1deg==
Message-ID: <sashiko-outbox-235347@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH slab/for-next v2 14/14] mm/slab: do not set
 SLAB_MAY_ACCOUNT for all caches
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Hao
 Ge" <hao.ge@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com, "Liam
 R. Howlett" <liam@infradead.org>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "David S. Miller" <davem@davemloft.net>, "Jakub
 Kicinski" <kuba@kernel.org>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Kees Cook" <kees@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>, "Robin
 Murphy" <robin.murphy@arm.com>, =?utf-8?b?Sm9lcmcgUm9lZGVsIChBTUQp?= <joro@8bytes.org>, "Amir
 Goldstein" <amir73il@gmail.com>, "Casey Schaufler" <casey@schaufler-ca.com>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org, "Richard
 Weinberger" <richard@nod.at>, "Anton Ivanov" <anton.ivanov@cambridgegreys.com>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Eric Dumazet" <edumazet@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-14-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
 <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-14-7c680f02a734@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 11:10:51 +0000
X-Stat-Signature: cr86955daasczpgphxfn8nm1uzc6dak8
X-Rspamd-Queue-Id: CCF92160007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795691454-433642
X-HE-Meta: U2FsdGVkX18cxLmyf6sIfGSgQ0SS5VM6KJUPi3+jzms4FWnlhDxqk9A/qySp8uF5C8EU5Pc7UOmBktU//ZCShVLf7sJPSli0CD55wyk87KNEz5aQ4naMr8nhBnN8NrCEqDUcjL6nBzQdHpR/LTZoRha9A4q/RsSaXF2DGh03qFACNWsRhdo9XLXUHEo0ffK1q8U6YkjeUuAjYO5WCLygcvp9FHhd0k9C1Lr5UCGwXb9AHtsANjob4hX1LqdU/Nv5gNFcG7opnBJKRMLcZYV6J9FRPuQf1AZC3OYcxCT0vZBWVLoRV9IJM6E/+RQguSJLQj0HetOX4MjtTfGFB9d7Rm1A2LcklzK4rBTknndZRGBmqB8ck4ZCPLuH58IANwexB8Q9kuF0jTHoAVpEmst2984edX/b3vgpfOqIYfoQ690IUuhlaylBS5cETLOuK5NE6sZnXIwx7MOswe0aHgD1Xo3Qzgimpg61aWkeQUaVjOCOtBV9O3Yb4JaakzS5lLyxNf1vhGky7UBtg2zzLlVDx8zGQclftBfOVlkLfn+h5TpP0qQaGynHyP1syrCEBitLiIuqFOEsWWHjcbXatpetCuyZrGEoksGwl4uH4cGwEgOgMZNxypPuhe5tXGaemCGFreAHJO3XZiG4vuZ/Zgi2uRni1dBZx8Cig00zmSDQhkjesrMTC+CcTIqQp3+JtIJHHCgFjsp65pavVYbo53V92oB7DJfu2JRnrJHy61r6su4XQE7BoALOvMDG+iG1b3UXnQYMyn/TC/wqqHhjZk+//OKFztyngC/A4HIWgDPDFd2ZZTUskYcxco0g3JRfiI2+uMVJDLiedWdudYMU1/zsz485ifYehmGDcRRUmAg4JqFezIiiZBiXV1yt5iEx5srPrGhPiAKQUpWqjBOsJ5h1BcPCwAI8OdH4pps8I/LldWwL05Pp/faSvpLd/SlYONVxCXuVCPhZv1cfeWLx2hw
 1x/bk1iO
 jErlWwFhwiikpIIV8AENMiGpBxxadEKfkHL4wZEkXITJKlTDIW1VdUxhlW64NhYd2zMTk+bX1rXoI1aUVK+6N3acV8gTZM9wf1Lr77m2crtDyl+ws0GnKjWFkEqLJdCsNfwpM7Z/XbnK9DmfNGmdR+JCgvv0VXxjUL6Hv+QAXK3369Qvhp9DTyPbh4qXfUtyy6OPstoYCFFnTvfSq5s0di6zFXrL3C954NE54/B+Il/P042Yg45WnzccAziOkppRGwyOdSr0x1TchB5ghNqcqR4PXMNCigK4YvS/4vLk4C5URxLvz7/j2K9tl3UdwDGytkIE3+Y+xcJy3qF33Ybb7CtA77Ey0vd2VVDEncN3xvB70IOfFbbnmc8Q2Bsm2t2GwwM30IIGGUjRdhqtjbl5qS6DsnELaYHy2p3dF/ajN3SPOFbeksEPCzti3a5KBvZG/W9V3ghAu+US1NuT04aC6hJteuRGjKoOOKvKrE/mhRay0kS1HcHlJcZnEuterd1nJnqz+xIrvUmMuXVQwrdjYqWCoEyG+OYl7nBxzpqTw0X0tABR3Ye25gjVJw/ZzbsUmZaeAMUR2zKjXcpns8NRPjqqueLv0fE5JXrNbDSxmqM848SmZpt1ymBBjg7piXdDq//J1I79Lbw4K2Y4nDxV5HsLS/a7PndVNjoPzCjxIsmhQIfEIuhmgFm38aRc/FoucX1IyrARTHZDXQ/Ynl/aAYs7mx9Lg0tvMTdOXah9F3/SqAiFqPt+CsUUawkuqeMJSAHb0zo17Z8pdLYwDWIPrjOpf4AhimlLAzvwicvnuLul8PcDDIDfK0o8mI1vl5oqvEgZnBUjIMnQM8lLntA8CujKgRl0GwucqrquyDxc61UNfH3QWqRNme1UcqJFvjHWWM/y6wAT89pdCQKgYUdSOANHBKzpi+tA8qd9tlXB0E7DcNukUK8WOd9+ARw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/slab: missing short description in SLAB_MAY_ACCOUNT
  kernel-doc comment
--

commit b34eae19fad88ae1a8ba755676d1139c330f19f8
Author: Harry Yoo (Meta) <harry@kernel.org>

mm/slab: do not set SLAB_MAY_ACCOUNT for all caches

This commit stops unconditionally setting SLAB_MAY_ACCOUNT on all slab
caches and updates the kernel-doc comments for SLAB_ACCOUNT and
SLAB_MAY_ACCOUNT.

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ad645967a3eea..8525e70eaa76b 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -201,14 +201,24 @@ enum _slab_flag_bits {
>  /**
>   * define SLAB_ACCOUNT - Account allocations to memcg.
>   *
> - * All object allocations from this cache will be memcg accounted, regar=
dless of
> - * __GFP_ACCOUNT being or not being passed to individual allocations.
> + * All object allocations from this cache will be memcg accounted.
> + * SLAB_ACCOUNT implies SLAB_MAY_ACCOUNT.
>   */
>  #ifdef CONFIG_MEMCG
>  # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
> -# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
>  #else
>  # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
> +#endif
> +
> +/**
> + * define SLAB_MAY_ACCOUNT
> + *
> + * Objects will be memcg accounted when __GFP_ACCOUNT flag is specified.
> + * Requesting __GFP_ACCOUNT allocations without SLAB_MAY_ACCOUNT is not =
allowed.
> + */

[Severity: Low]
Should the identifier line for SLAB_MAY_ACCOUNT include a "- <short
description>" suffix, like SLAB_ACCOUNT above?  Without it, running
kernel-doc with -Wall or -Wshort-desc warns about a missing initial short
description.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-memalloc-p=
rof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org?part=3D14

