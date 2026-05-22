Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0B8CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2B16B0093; Fri, 22 May 2026 06:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D830B6B0095; Fri, 22 May 2026 06:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98776B0096; Fri, 22 May 2026 06:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B79BC6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:53:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C3A11C06F1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:53:08 +0000 (UTC)
X-FDA: 84794743656.26.87DEA53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFA2140005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:53:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b3Fe/bjJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=df+CnhR7qpLSx3MofrRRzoieB1WIujbtjKTlvAegvQc=;
	b=IDzJ1JajiBmOOqHaIBqvBO8mTS3fAX/yJt4+RqtHpKvBaHfYbURssfcF2ugEanpPC3Skqz
	J/2Yv5uba30XDkYn2dSMF05s9MIcn1SsoQ0ZGJun0fzhMh0HVO6sBnN/R3J4UFitG3k/Xv
	becyxADUkjqW/1M0RAGJOSwD1k8pBw8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b3Fe/bjJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447186; a=rsa-sha256;
	cv=none;
	b=wm10l5PFX3qzZNHgI4DiBAcOIx21lZE9zRrlsKSKbdqn5BSkCzlEo46ThBSwqQYPeSG5yy
	201JbAqIOZJSA32bYp25JKokTAP/KCp7i1nuQQwhNweMDJ5ZAnPLtazN06GbZNIdzWaeA7
	mr1HyEKBJhxIhbCpGxZcFbhe/tnVn7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4804560136;
	Fri, 22 May 2026 10:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ACD1F000E9;
	Fri, 22 May 2026 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779447186;
	bh=df+CnhR7qpLSx3MofrRRzoieB1WIujbtjKTlvAegvQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b3Fe/bjJOppVTRuUr5XBA7dad6C1xDYzY1VKxTzqHdqxadyFt7x63EoKvJkoeOW1D
	 NlJd2A5YO5pXIvfylGIX/Ln3UWadEQ5ddrrpMmDW22pS+/Yuh+7Nn3hzsW5aNsUt09
	 D0uYnarbZ4QI8ieVDjPZ9OOLTfi3goNUjDd5thJ2nI/E4hDYsOEzwoePTt5AYbIh20
	 dlO7XNE37FjLGj1+/PHV2Wj9y5lRLCjtwmll5lvwPVvdt+Xsu7InbcGp18XH+eVqZd
	 KF5M+WMRIuEtByV8OCbwLLHqIXkDC8s5WnBpzyiAPNvW5uYViy18X5BnH2tO1bz2pH
	 Nc4LotGO1kHlQ==
Date: Fri, 22 May 2026 11:52:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <ahAzPTUMwMZfW2kx@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <ag7pFxHpMGU0zLvq@lucifer>
 <ag8cvjwDGCt_14pY@lucifer>
 <CAHp75VcJJtfnSYFA8vhtsuZs1gLo+Jpne3TU2WgMZxLiB+95yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VcJJtfnSYFA8vhtsuZs1gLo+Jpne3TU2WgMZxLiB+95yQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BFA2140005
X-Stat-Signature: 9ybe69x57xeu47xs7raoicyu9gkc7smi
X-Rspam-User: 
X-HE-Tag: 1779447186-251632
X-HE-Meta: U2FsdGVkX183JZ8aqU7P4vNQAbCCLv79L65wrYOd3VG40p4KPaKR4gZN4D0JtJFV0xeows9iY3rfvUJiKDE3gFFsaMnDxKbeP7XwOt7eCuyA4gmPOMfdUvHEof2RQtm5TkLi2DZXSAHAoSucCCgttpBGu4JvwWnz3K8ejEIotIJ/9tRYFiyLCOIW2rSdsV1dLSjmQYwHa6IFVB3aM2e+CGnMxfSsEPROKDywtBejAxn0oABMAetxVLd0gROqNf/tzrn+1doI6sgMgyKAsh0LQcrgr2J5AMIJkdPxJFfDtYpwRrMB21bWXKRNaLcfRB6elm7ucr8NsTqRMAs4pBmYFL7Q83LouuuFv0kh1lR+DBZfSqEtC5gNj/nbSG9CILqtOC7xtXrtLCr+CHg2Fuui0hR7zHZm6916f07chBgDLpGXfSe4quzFmGCdG68J1KpoMdHjh07vuJ6aBxOIggpZLW06+UuwblNrcF1NlAsLwxg2QYqAZlYwZHkFEUXADXniA313zLeuPYe4nFWBg+1xk6p7Jpn9B/tB1EuFyIfFLddk/LCK8V7PIz1nj9PWi3b6h6UaxyxF1BuaXl+CnlSJle/8kUG/dYtRFQpun0nRlCXruRimnpOF8rK5J/YAXBy9FoIZzGU7Q9hU4MhDBljPbDNiD8wfM0eK9/KhwAFgIq65N+c72llC6IwIAyP/XR+LV5BGR4iH3Y3qs/SAyP4En86sia5CHIMRoMHfz1CwO9WWefTv++2wMGNnCvLuGhXpCRDQcr6rsvSXw9qYWASnFpwHU6WWMoKJtRjEYJi74bvb4kKz/I0MujNbX+4UFoxHPa47dJ+m4ZCuMZxnmMJuUXh6j2bW3nrqbjpS/rdOOg2mEYllNoAeqlVciFy4GGsQRcePyChTKQOXL/hn+wZH8wfj+kGKFQjnd3/ziBp0GV7DvtMiXhD8NFt3ksZIyWT642fwW1na6GlF0oYydcU
 xCZD7s0X
 aclskiAaT3zbeRyQVNGCGt+tYVbUHrz26Rj0/Wzj9IqqTtBlhl70ENtRXKvNJe+qRkg5Bf4ZLsVmSHoIC7M1jt45Fxkm/3LAoiQnVYbmKX4mpFM18fhR8yjoeirsCReXmFL+ooAmzzxywv0GsXTcYgpSeUkKypzUD2IaGPPYtwiOBeoytZ+plbsbT5Hnio8fsT4LnmElP7RdNnW5oBZJsMM1HF8xp0cSUnOOcQLGgQzpQEcsO36i1dhjslLNm4FPoVOcblBOP7kC1mmJyVHGwrjhFY074dsrGNb0/RgMMGvaTl4dLimLytKMlhoejcvI7o6AxbKVTWWHcM2xHigv86QoSx7/NTS9hSthIiQt2tkHi/UFjTl3syp78kDU7jwlp7IGJKj5ih76BBbtO9wJqeIKf7udewICSPJl5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 09:34:57PM +0300, Andy Shevchenko wrote:
> On Thu, May 21, 2026 at 4:56 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> > > On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
>
> ...
>
> > Unless a series can be put forwards that sensibly justifies this, not some
> > random change somewhere, I'd rather we not take it.
>
> The problem is not only a compile time but more generic - the mess in
> the Linux headers. People who want to use this match need to include
> mm.h which is a bloated header with *tons* of unneeded dependencies
> (for those pure users) and increases chaos in how the headers are
> split.

No question the headers are a bit of a mess, and I've had absolute headaches
with dependency chain stuff there.

> If we don't care about it, then provide an "INCLUDE EVERYTHING" header

That's a false dichotomy - the series isn't upstreamable as-is. I've provided
feedback that's not been addressed so we won't take it.

> and let the driver just include that. But of course, we don't do that,
> we do modular headers for a reason. Currently I see no reason to have
> that simple helper to be mm.h as its use is much wider in the cases
> where the whole hell of mm.h is not needed.

We also don't want to have wildly divergent overly-specific individual headers,
and series have to be upstreamable.

>
> So, the best course of actions I see now is leave mm people alone and
> simply duplicate what we need in the headers we want to see
> (util_macros.h as a rough approximation, but maybe something better).

I mean I feel engaging civilly and constructively with people who have taken
their time out to provide feedback is a better approach, but obviously what you
do elsewhere in the kernel is up to you.

>
>
> > Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page() is
> > really an mm thing so that's another reason not to move it.
> >
> > (A justifying change would show actually build time/binary bloat/etc. numbers +
> > involve actual substantive changes).
>
>
>
> --
> With Best Regards,
> Andy Shevchenko

Overall this all feels like a storm in a teapot, this is a very trivial macro
and the use case seems nebulous at best.

A series actually addressing header issues with _a justifying reason provided_
(I am astonished that it still hasn't!), would be more useful, as long as it was
upstreamable and didn't cause other issues.

We in mm are friendly and accepting of good series, engaging positively will get
a positive reception :)

Thanks, Lorenzo

