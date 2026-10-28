Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C3A606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE716B05D6; Wed, 28 Oct 2026 05:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95936B05D7; Wed, 28 Oct 2026 05:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2266B05D8; Wed, 28 Oct 2026 05:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 765FE6B05D6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:59:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAE39C0BCA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:59:05 +0000 (UTC)
X-FDA: 85371586650.03.507B913
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9AA2180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:59:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=EKCDzW0U;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf06.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4v1koaYCedVk/4Qr3RSyIVEy9SCXdn2NBPrmVyCL58=;
	b=cqZ2VwGiPViLPTTJJgFphiNH+u0Sbpt+xDFtdEFNWlwzCebYtld/gx/e/NJ/l/xTUoeK4+
	a7Xhl1a+c1A7HSVfI4ixgatuOfBB0BSw6eJwGr0K7Rmk8j0s+oxOlzlnhbCInMa7gCnhg2
	Wva7rhIj+qBXq6O4O+Xs6pBp2Wuo1q0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=EKCDzW0U;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf06.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181544;
	b=qdNAOdTzwUCZZOYzboXGRtU0wsOiaV/lB/8ozFNJRUTvzLIPCCwXuDfdYDQ+uyVOdQtRZR
	0WTCc5D8frsx+WiHa8N23yekBUhcJbnS0RsjrM1hweq1Wun7XfDIHrvAWs1EGn//5lbPpZ
	vXebm17RzHR0woXomu2NtAu0rrzd920=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=W4v1koaYCedVk/4Qr3RSyIVEy9SCXdn2NBPrmVyCL58=; t=1793181543;
	x=1793786343; b=EKCDzW0U1BrPPdioZBhNfzRDVpdfsatHFrJsJ/wWCZeeReQj7RAeUG0ych3Xz
	um78B/d4FAr6WCkjsCiWgsj21BxEGYp8ixRpMOkrDvRS/rk8kPM6zmS1PzqFDu+KmI+yuppyg3V30
	buplhjnntthVh+Zq9/yhXPcXuZmagXPSey1QQBd9yqM01mWoUMEmbsAKMKY/I1HREs1YjR0j+Dw6F
	ENmCr/gH51j0XRlVbGKXPZEYrlDBDSfN9hL4DHHgD27IxKeMRgcLAi6WbGHepyuB2xfXknCwVxKJM
	3rF1woaR1YRhOqv5wElDcnzUM9hc32R6niOi+gPh51Oylpy3wQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xM0Qr-00000001bPL-1ezN; Wed, 28 Oct 2026 10:58:57 +0100
Received: from dynamic-077-183-189-206.77.183.pool.telefonica.de ([77.183.189.206] helo=[192.168.178.50])
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xM0Qr-000000029hA-0ZlA; Wed, 28 Oct 2026 10:58:57 +0100
Message-ID: <8d4993cb2f2e5c3300514f1e2616e4a101488883.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Imre Kaloz
 <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Andreas Larsson	
 <andreas@gaisler.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 "Mike Rapoport (IBM)"	 <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka	 <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato	 <pfalcato@suse.de>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 28 Oct 2026 10:58:56 +0100
In-Reply-To: <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
	 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
	 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
	 <20261027212610.6798-1-kaloz@kernel.org>
	 <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
	 <20261028091631.8072-1-kaloz@kernel.org>
	 <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: B9AA2180003
X-Stat-Signature: bn36s1ogpdi63kihss5ksue1xhsk4iaz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181543-442000
X-HE-Meta: U2FsdGVkX1/GecgQu3vLqY6jHA6zH2WGkHWUQOiFAgQhXKk4lVXsbX8/MsXzavrzdD3k6IdjvFv/FhshedUDQaBhcCJ2w9rmWB2myq2+WTknbYaG4hJ49TzSSKMWb4IJk3z1782vgki46Lv9E6zPe/j190IWuiCx1I/3qXCcqpCxj1n+akXTAhabWh13UpRzSJ18uDd+4eZtBIs6vduCa0uW0/i5H9WC3XVhDzkhN0PXhdv0tWwsiXiGwdOUCPIfDa8KQPaEFePve/qaz+vTVswHL9uNcmB6avSBk3gnV5fM6yWznE6XlEQfnmxVVMQ71Ftjt1M+1O1BYJi4nI9s5XneIG9qP/541v8nxd3B8JjoIHItlQ33ye5+lE3jkXyU3iN/c4IW1TYV56LXt5J0wbRnpZzBBmecTpXl4as9y/d41NHzxGIBck/63O2dTwsrbwizKgak0AOMAvkPJQWPAN833NHPb268ZoV3ccIpNDZUpv6q/gh85xoNXlsCQZZlFHypW3PERBSEBeJIj16V1OMckT24gKPsuy9jRPJGSJTeaXXOGpHAhix5YJN1hJ/K9ab75vJJLEcxHQw2b+F3R3CdJYRAQPVlj7Y4EY3HOHvshyxTOQ4CBKl3ygYp3VSg/4rEy9bsRFBzVUMV8FAceWnDAUMpE9LKrw5zrGM02rByS4Ji0Bhg0i0JN32gexjQxNZsWHV2o9n8i/dYeqsWj0iFJTx33sUY2As6ouHoqOESEvWDT0x25e6lg7s9gW4ovwl0PFbPm1r4Jeb2cfsSow48d6mc9rMIrt4vDkVCXLNZy0PmILXFQ8kVFLdxrogQGf29mnDN/aDuQoso9lNxPEGacCJZwyaJSxGZE2YLrXlPWz4QwdewZeYimgfZvU4kN8N59DWnUXJLsC0QShzmaDy/N5+j287MVQ2KKN0CQmP27boVxvUI9bd19LTwvqkFNcT+zhqyRzEK4SVkaed
 zaTOq0rs
 oHIQiTQdYb7wCbk/1CkZ6/r4miL3I/2vfYtZ8O5Oy0tw7LcehZig8haL6z5RzqVkwzh6fMsARzd2NuQOMtl81pxPGl3CgM+ZGiP0gAca10LgkkreOOiVPe4jvFk53/Cn+q0cBmpDHJSWcGalQJGumbrRWsMIt/v6g8eJ3Mm61uJNoEx0X8e1kzKH9aXBmABE5jMVOeTbQQvh8BIioV3rwsqjncD854RdBgJ0LKrF9aiq6EcZYdtgYvZ3PrfIOyS8LiBlJZd4Jirkql2EnqBK3rbes9j/0WStHZRt0skDRgR0RG3cN1Wghg+gcXeymONySdoiU+OWhbaOlfkydFQzZdxwI5bk+y5EjJ/D77XTwqWV41aqf74EvKE1qO3EXr9vlVx+kYthVtQDOLKbrIVDZzcLxIW6wVEWAY34R/a5pGy3noZfMnOf6nvyFrpqTZERQmYVs3enB+EpMeAgaeUQ7mROi+ZqrVp0oAvJTsDntcmipkREoa2P2tgPJ5ZUCC5cSr5vPvtcG/LmWny/5A59AmvLdpFt8lfny6pDhaB5+BPeV62U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Wed, 2026-10-28 at 10:22 +0100, David Hildenbrand (Arm) wrote:
> On 10/28/26 10:16, Imre Kaloz wrote:
> > Hi David,
> >=20
> > On 10/28/26 09:49, David Hildenbrand (Arm) wrote:
> > > But that's too complicated, requiring page table walks ....
> > > People running museum piece hardware and complaining about performanc=
e of mremap
> > > or memory reclaim should reconsider life choices.
> >=20
> > I'm one of the museum folks myself, though more the kind who loves
> > running a modern kernel on old hardware than the kind who complains
> > about it :) A lot of these machines are still doing real work, and
> > these days not everyone can, or wants to, just buy a new computer.
> >=20
> > Some of us spend our time keeping these platforms working, and I'm
> > not asking anyone else to carry that, which is why I tried to keep
> > all of it in sparc.
>=20
> Okay, so mremap() and reclaim memory performance concerns make you sleep =
bad at
> night? :)
>=20
> Don't get me wrong, I know that running new kernels on old HW is fun.
>=20
> Last week a got upstream Linux running on a 32bit x86 notebook from 2007 =
with
> the snap of a finger. Everything just works (using Alpine).

That's cool!

> I couldn't care less about performance. Nobody should.

Well, try to put it into some perspective: For some people, old hardware
is all what they have and given the current high prices, I assume many
people will be stuck with old hardware for a while now. Think of developing
countries as well.

> The biggest problem all of us with supporting old hardware is the maintan=
ance
> cost. Not just core-mm, but also things like ad-hoc page table walkers yo=
u are
> adding we (from core-mm) might have to touch at some point.

Well, but if people are using it in the end, I think it's justified to supp=
ort it.

> If there is no good reason for the complexity, out it goes.

The patch doesn't really look that complex though. It adds an additional pa=
rameter
to move_pte() which adds a few more lines of code. Not really overly comple=
x, I think.

> Because otherwise people will push more and more for removing legacy supp=
ort
> completely, and that's not what you want, right?

I don't think it's fair to make the kernel exclusive to very recent hardwar=
e only.

Adrian
>=20

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

