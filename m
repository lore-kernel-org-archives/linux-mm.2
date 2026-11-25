Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D1D606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LCxdHv9g
Received: by kanga.kvack.org (Postfix)
	id 0E8B56B096A; Wed, 25 Nov 2026 04:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0AE6B096D; Wed, 25 Nov 2026 04:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F1F6B096E; Wed, 25 Nov 2026 04:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11C36B096A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:45:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A499160D95
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:45:46 +0000 (UTC)
X-FDA: 85473159492.06.C7E13FB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B38C40008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:45:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LCxdHv9g;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of joonas.lahtinen@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=joonas.lahtinen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599944;
	b=pfS+mGkUkA+JDyUsdbDUWXxkL82ymoLWSZV6UMSToyPAdm4h2l7+gMVXLQ0uj8lSvidu3j
	/IqAr22jjS+iCBaEeehdaAAbmAd15i8whIYjrLlePc4oH7t1/ELPQu5THGLzRLmS6+K5ww
	eZs+69c65c/D4WxYkcWeo9NruQ7viIA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+CktZHSqkPxuSEXEAbNZNMCArY53vM9vteTf980DA4=;
	b=CeT5O7i0AYgxnRgtTgV3LEuffTXEDcFxQG/2q2E0uiYi/alcX9isPbm2XbrjdvtVzKiL3Y
	lovAEQgSUZnOA9/IoIRSl9254rMrZESE8mqs5LPUNWQl1DWvLV0MYAKz6pXiGDWvxJE0zN
	2YtaeSqDSlKszIXaJta24SzslIid5rM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LCxdHv9g;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of joonas.lahtinen@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=joonas.lahtinen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795599943; x=1827135943;
  h=mime-version:content-transfer-encoding:in-reply-to:
   references:subject:from:cc:to:date:message-id;
  bh=pAz9QCMK2g+sjrrKzBg/ayJIwQw8c7CEhoVNFJMFDkw=;
  b=LCxdHv9gN3vvVbP+0exvlPRMVIl8JVl7Mer7/HbsgvWxtF6yjmIVjRS2
   vnerVk2QjGCAUJNa9FlTZEAeoxggI+pHMpD3vLauBOWNKm8A2+9u7IK60
   ajCC0KSkMe69m4kvZeqLTmfFRiklPIvcXWsiGNsQ47CRvOBoh2rLbHs6C
   dDu5W61Kvb3Ie6leIfUfP+KqHu5NDUSUHQhm5JapL4k2xpo9/3E8J5F3/
   LleqCtBxei9D+G8gCwf3rnLDKVLb62GVnblNsig48oakCTcY6xJVb7pP+
   +19gxSl4kQ5HFHauFAF0FXbobmQnIcFQ5wo5RYQuihif2b2+RnkYF1+A/
   w==;
X-CSE-ConnectionGUID: GfjJF2N+Q5idxCQufKCx6Q==
X-CSE-MsgGUID: Iuhyh4GFRfW5ml2k+BUC7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4551743"
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="4551743"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 01:38:25 -0800
X-CSE-ConnectionGUID: H4+BfhJURaC6hIFgX5ZViQ==
X-CSE-MsgGUID: 48vOVrHrSKCTSM1ql7iMCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="12252215"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.26])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 01:38:21 -0800
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <awZz6sq_4cjIgUcq@infradead.org>
References: <20261119134243.3745282-1-kas@kernel.org> <av8n42vx3Q7zvQK8@zenone.zhora.eu> <awBIB3vjr_o-gfCn@shutemov.name> <awZz6sq_4cjIgUcq@infradead.org>
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra references
From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Andi Shyti <andi.shyti@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Andi Shyti <andi.shyti@linux.intel.com>, David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, willy@infradead.org
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Christoph Hellwig <hch@infradead.org>, willy@infradead.org, brauner@kernel.org, torvalds@linux-foundation.org
Date: Wed, 25 Nov 2026 11:38:17 +0200
Message-ID: <179559949792.43928.13638993010156007645@jlahtine-mobl>
User-Agent: alot/0.13.dev2+g40c57d620
X-Rspamd-Queue-Id: 6B38C40008
X-Stat-Signature: 76h5mtjqppc8y9ygmz9maqtece7izsrd
X-Rspam-User:
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795599943-632339
X-HE-Meta: U2FsdGVkX1+MNU0E04lB4aLkJsjzknW0x3PnsOyL2Yo0Vsq7ubVhmoGRq+FkAidm58KKuIt1UT+QDhnladikQI7WbLuWlrsJ+/OrY6WEen1ZHlw38Kaq1aglxQnuamzF0XiznQ4Az2dMnr5Q88ghTwN8eEmCb5ZBLFU0mzb+dZ0AXN2AXEBMx+Q/JwUAY8YRRz4BomN+Wxkkr7VrBTXPbA0NMrM4QX656UrXS+u2S8TO3uaE9sfxSr+0tyinWyYYnLsIAuphzx6yx1Uxmm+GHpVst/dFT8mqG3UWSbNpokFfAL5rAESEy63mVkn4R/hfTmjbk2LmwuTaQPMUpCYmu0SRBmRbxfsXPkcmFuNUIUO+5Rx6yKJiPBBc4XDhyGn2WKmtGHwpPN5pBzIQ34QdGPxsA1WIU5jevB11i+UxGe9/Z9jT3Xpsytfds0yhYiTKFz9W/m6W03cHpFosUUi9fapZKKnwRkDoJCj08HrVFe9+XaYo+AgalVGZp3exFuOcmycC6ZKQ/y7bXWGAViHtrE+ND5Vd8gYwr4OJFW6sZcNcAOYpPj7AeDEbEHrszxPy18bBazJs2aztPfaZuQPz+Aia+M19lPIDKQS0I6Sa4K1KPUQaAe18GjEFySadi7Oqv9ctKe4YDBUPlLgoTCy/2cC7KNpySZhcKqRtZItmDt1Mxp9kstDKp7PjE3UTVmlf/u9OhRDLhZIWpDwu1X4bsM3NH/mOkTZ4tkN+1qrIQPiiNM9HA4rH1zAWU2+UEm//fP1Tf3/p1BinsRIZRaYmmrXV1RLLGtf59FIsybYByyih2hoPPilDfmlGH/SsTMIPiH1K2CvL0ubg/pzcXZBvHiCj03a2hoQXF1F9p8vfe2+EmZj90rgsF3le6O5y3wGCaNL/R0nHX0ViZNJk+Ritzh1eEqIK/4B5Pwsug5u7lDgOQm93osHuyibMWOBN35BJqADE6foutAVjSTyyvIL
 i46MPYTn
 PMH/rvzueFwZc0xxMmzK7McTFRSQ2gmTGZiH13VrdxZTiDUuakiGswjuiAnXJE4IOYROP0u2Sur/lK+SNlsJwUYotoAn6KKg6jK1yrOpJiipKzO7tv25vG1P8I0Dy5J/dl5GkHqrju9e4nfT0oESy67U/GWlAgFkZACpglouKoL+M2b+cSjh/5k8zpgq6nCKY9ukwvg1YQFRzzTg5gUlCA29xRdHt/nUBiEPInPS8/l69bFLL0QEgoogp7eCHfKod91w7SHMg6DjHECLgD0jNr3c67qfLxxyDFRHCptYo/5f30AqstqLAbydbTKN4dd+g9AuAuRI21SUKsRlA+kEZOPJy2KDAFQGP/MGKQa2ISypclklduieZbNm0Xu91KpGLVSHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Quoting Christoph Hellwig (2026-11-25 07:36:42)
> On Fri, Nov 20, 2026 at 01:17:31PM +0000, Kiryl Shutsemau (Meta) wrote:
> > > >   while ((folio =3D writeback_iter(mapping, &wbc, folio, &error))) {
> > > > -         if (folio_mapped(folio))
> > > > +         if (folio_mapped(folio) ||
> > > > +             folio_ref_count(folio) !=3D 1 + folio_nr_pages(folio))
> > >=20
> > > I don't think we need this fix in the current tree. The i915
> > > writeback iterator already skips the shmem folio in the case you
> > > describe, so the new refcount check doesn't change the outcome.
> >=20
> > Oh. It took me a while to see why.
> >=20
> > __shmem_writeback() asks writeback_iter() for PAGECACHE_TAG_DIRTY
> > folios, and shmem never sets that tag, its ->dirty_folio is
> > noop_dirty_folio(). So the loop body never runs for any folio, and
> > hasn't since 776a853a43c9 ("i915: Use writeback_iter()").
>=20
> Heh.  I'm surprised no one noticed..

Not so funny to me, you folks are pushing regressions without ever
Cc'ing a single maintainer in the original patches.

I was under impression that Linux development had some rules about
not introducing regressions and also some rules about not pushing
stuff silently to other subsystems. Maybe it's just me not able to
keep up with the vibes of these times.

> > That makes me question the whole writeback thing. What's going on
> > there, and what's the plan?
>=20
> I (and others) have been asking forever to get drm out of micro-managing
> tmpfs.  I guess given that this code path hasn't worked for a year and
> a half is a pretty good indicator that this instance should simply
> go away.

That's not a good indicator in this case.

The writeback for dirty shmem pages took multiple years and multiple
iterations to address the best we could as it's not exactly a race
that shows up frequently.

It's also more likely on the hardware from the era the fix was developed
on, and the owners of those older machines are not exactly jumping to the
latest mainline but rather more likely to run Debian oldstable.

So which one of you will be writing up a revert or fix for the offending
patch or do you expect us to clean up the mess you've created?

Regards, Joonas

