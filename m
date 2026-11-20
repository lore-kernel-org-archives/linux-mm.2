Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C03A606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=guqi0fXa
Received: by kanga.kvack.org (Postfix)
	id 9FF5D6B05B1; Fri, 20 Nov 2026 08:17:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFE16B05C5; Fri, 20 Nov 2026 08:17:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C52B6B05C6; Fri, 20 Nov 2026 08:17:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0B06B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:17:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCA091C4A79
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:17:41 +0000 (UTC)
X-FDA: 85455549522.16.806812D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C025320009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:17:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guqi0fXa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180659;
	b=qUSHBncGr/V4GmBY1G5yJnhkDqlnYeZcbOsO5le8pV4343RMAyRespmDkcVASdBzlqbmEE
	hQNassdrPKO+p2uxmz4Jpi1yr/z6LjG5PjRqBV6E8EtdfzNogsYWkOxGuCEnV4YcVMH4Ku
	vtWEkrMdb7T6KZMtxFSsToROk+zR4cU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1r2RPLiYFSIogaEoUkz4XwYUZKQoUko/pKRdi08cxM0=;
	b=0h+KJursR3azhEr2kIL4AcAzWFLVSFOWcGG6nDtao0bYJ1l6Hh9kU5nDLxzSpoCmbjqjl0
	64Z7TpTBQbOtAD9ESiN3ii+LpfW6igr3leesAnMY3oKMG2X5ncJb5+VyZjueGrdh2dgQne
	H58tiGRJfF5DQqVDgtS37ynCuu9tAR4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guqi0fXa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E860E4580B;
	Fri, 20 Nov 2026 13:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FE91F0089F;
	Fri, 20 Nov 2026 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180658;
	bh=1r2RPLiYFSIogaEoUkz4XwYUZKQoUko/pKRdi08cxM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=guqi0fXauTN8zbzqLH/hjYfH1/O3Rf83KBV8HsteSyuP0tvTivrY6Uw9WiOSq52qH
	 Irqj1q2baX+DzLVjmMu2xGBU5e/vFEOsiRYGYHNwWxMxBEmHan47+hcbKX9cTrlAfF
	 DU0aP4zbQZa06SDs+gdSgQtg8HW7FTVhinp2G4yiPiD4LLEyEaCMRICzI5KOght7w0
	 a5Aj3JII6KfxuN8sKNu6BIVGltWGdNmYZXzWM9r8z/WEcdAfRSD72DNhO9r7uvWI6I
	 MHLgIUSeGtmiESn1onURbDVtiAJ1UfgLb8sbWqGe85OR1k8BhMTMl6u6J8WL/MLcVL
	 rkkuPTPcCb4Sw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id E3EF41980047;
	Fri, 20 Nov 2026 08:17:33 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 20 Nov 2026 08:17:36 -0500
X-ME-Sender: <xms:bUgAa0Ss467GVnDhyoa5GLJvJ3Qkb6jHpBysa7UtJwMHKBxrb5rknQ>
    <xme:bUgAa_Jn5SAa9Gm26aQ6PCluN4Igj4Xbu-1eShGyKxR4qD4s9mbJsthGMUuBhDiiJ
    DvPsGIIO4AzG_TK8e7R8mLHjv9E9hWIE1EgDfNtY4sRYb_WfmuVqNFO>
X-ME-Received: <xmr:bUgAa92iCqHJb79UKYNhTmSvtYLPj7oT62s31rdeiXpMYGt1_RtpnZNe0lI>
X-ME-Proxy-Cause: dmFkZTEMslbIUNDm8LIh02IXJPPGaz8x9nStkoY2McUqfXdvc0zDAMNuwAdNk567GWqWFb
    Ue01QIrqSlGhLD7aTRxcawP+AUSNewklEcq6PMC9JP8w32Vkz0EAbVZ2QFm6NbbycGqrOT
    4Vb8re4U7agTXekt+mqlS2xCpK9NpzTwr+ErpQ3XVKIL+uqfYPpDVYCLRwfuz8aG4ZROa7
    Xd1wxnnT9IcNmrmTW/L61gTt77vLm2hbvmmHDGa2LHM3iddXj9bf/9phFNGmR4hUZZM7Uc
    ZJ9oEFeNgt22uQRjW3Wdih7LGzmvCPCrT/2DICvgDeLsnE5QRBd6+NlZnMM7O7XfT7q9Do
    MkQJtlimT0MHz0XKCwD/pqeSVQTF9nQB6fmaRrIBniyooZx48Wp+fOdjkpjjfy1M74AB0h
    vS3M9aDC5BqCGS+vBnYumDdMEN6m0xvfiEIP84KP4vUCXEzzfRXpY0HUEEr7Ux+TLE0CvM
    8mfzIpvGacxcLQSZU2/0i1GMY7jfN3hn3SzrJ9D9XCXiD5LzrcLQeHCkaf88rKLabxTIfx
    MK6n/B4O2fmC0h6UK+8FsX8/QUZPhtXvSb6VY/dDu82xZH1mgNTNYlAD8mYnORC1N2N/Kt
    9BSKREudmnRmc0072qjsdqwInnjVlm+WtP0N1OdHG4S5m3ZYPrjrL8R/k2Sw
X-ME-Proxy: <xmx:bUgAa7toYIuLcOc32pRwV-nsWDZX_L4XKKyWqDVC59SHUuoImBWT_A>
    <xmx:bUgAa5HlJOmSY7P5WSFjnY6uqz8LobY_WUwzQM8wba5A2rgz9WGBCA>
    <xmx:bUgAa1Jqwm68KOU2wpFhGSlDAH1XL0GVrygZ1G3sIJWJupOyMB2yEw>
    <xmx:bUgAa0GHctFKPFG36KsYueFTUiK1wxmIM_ROA7NlIGuYWQMr6gettQ>
    <xmx:bUgAax7INTnv3udfOUXtVTWi3rt4nW4moV6FhuG_CrgEs7tK_rv3kZad>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Nov 2026 08:17:32 -0500 (EST)
Date: Fri, 20 Nov 2026 13:17:31 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andi Shyti <andi.shyti@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Andi Shyti <andi.shyti@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references
Message-ID: <awBIB3vjr_o-gfCn@shutemov.name>
References: <20261119134243.3745282-1-kas@kernel.org>
 <av8n42vx3Q7zvQK8@zenone.zhora.eu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av8n42vx3Q7zvQK8@zenone.zhora.eu>
X-Rspam-User:
X-Stat-Signature: aye388g1xbri7unpcn1qgo9szhychnzx
X-Rspamd-Queue-Id: C025320009
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795180659-12376
X-HE-Meta: U2FsdGVkX18wUHPb/MFYOCrFuMEgSAbYLTr0BcPL6ua7s4CDMMWd9zwAOaKDhWFUvV7mSp431D6/p1YRmDlhlRTp2OERaCjf87JLeQa9VyQDtUMCxykM+qMjBoLV0Cy+dj4j70lvWR9ET1aT9mfubAxopT/cLjY2nJ7jYu1F1shl9pJN4vSVk9HiHnFnr1qXrND2VLD6Vofp/bYJBra6dC5MAoHsrXS86UcoN+blbWIWgMdwJLCU+5dGlnLmSjF+bp2VjHDYTYtC5E3oJhWP1ZakkxmMzAzPYDKkz4BjEU2pfaG9nGJJI2ecAoWSKdagld9pr5GohcQHj2duxI6dsPJZtjdI1DrugoiabRO9DlVpWT/pQdiP8x9uZOi20Tn9xztalMWRGf8j1IXbpWxBNZOAx0ga2qWACWepuqbXTpgWS3KpNzSJYwE0wFN6PY5uYd99cZOLJsovVO8TqxN4Y1nSjSTMwLxsXENK6ot69IVGDtbsmqt3C6DtdWN6NfFKclMukGMxqPuSPmg0+PH3s9Nm/wmjUreFUFJvjoJ39y9JazkRgSd7scRu8iw/vfHkxjivuxyepyXwPiwvVzSMvV4fCZQmYfBe1b7NQ4x7xvwnAUJVvm2qzf7vkT1mdiSCEkJfPu9XHNd1d+PU9Zlc6ycnPM+b/kAbjuC7Nv3n9nfV2YrsDHitmVlmddFWufGyifwcy1U6tJkz7XyFrNlm7RFovDiVc5HCH2UrN9sxBDGB3OWWBV6PCgJgDqSnwc+vT5dJ1EqsIKCKO947NdS+SxhOW3znckoTrA92591dUfbbAE7Tpgkwrcj5TQcpraWLr3vMVPp0wxkyxzTno7M8X2rxFIoaTMfxbtCAyeK+R1ZYjXQjCmrCBB0bKOAVEv4HpgHmve6ZaDDDvHA42Kh/PYHslj2zfmTZF5TS/DhrAGbkVUDfbYB6o3W43bt+wBuYO6qj+3xupien9hBFZZA
 m88QG1TJ
 SKK718YZ9JNoTnpwog9GgzsQ7svE4DLaGHTzudFBEYakY18HhGVyiF+FdFgsSOO/JGz6yjinIVwdndocP+w5VT6hMlBZx84P+4qEmbipcZGjAmeZ9UsYkfeAmcQnv2yWWANHSK8uv7oshIF67kAIJ/oGftd5pefSa0pqvdxun/HW+kEaaRjgrQoEtPurHnRo1akuNj9/jt2ixzCQeJpGq5qti4q8WPbJU8lpn3uCkMnqU85Mmqdgh0v/GjBELZYmA3vq8JaU00Q0/CHQooIJkEgW4hX9WA0tUzFlNoB3xMeShEgtpaFobcgAfr8EScgE6/yb6utM2hkYePMl7UoaU/7RAp4rtXBtVv43DJUcgWqUfe0e4bGZrLMdDJvvJ4QgO8TtsN9dTsVcVT46JLc/gn284OzZHnIaiEYdQZeKnAosTjmRw9PBr5WVulAc1Q6hqcNcqn7wtjl/PlykZ8nDED1C2WL2lZr4D0TcEABFRqFgSAOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 06:43:08PM +0100, Andi Shyti wrote:
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> > index bf9e7480f0f5..748772c358ac 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> > @@ -316,9 +316,15 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
> >  	 * leaving only CPU mmapings around) and add those folios to the LRU
> >  	 * instead of invoking writeback so they are aged and paged out
> >  	 * as normal.
> > +	 *
> > +	 * The same goes for a folio with references beyond the page cache
> > +	 * and writeback_iter(). A folio that was just unmapped can still be
> > +	 * written through a stale TLB entry until the unmapping side flushes
> > +	 * the TLB and drops its reference. pageout() checks the same.
> >  	 */
> >  	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
> > -		if (folio_mapped(folio))
> > +		if (folio_mapped(folio) ||
> > +		    folio_ref_count(folio) != 1 + folio_nr_pages(folio))
> 
> I don't think we need this fix in the current tree. The i915
> writeback iterator already skips the shmem folio in the case you
> describe, so the new refcount check doesn't change the outcome.

Oh. It took me a while to see why.

__shmem_writeback() asks writeback_iter() for PAGECACHE_TAG_DIRTY
folios, and shmem never sets that tag, its ->dirty_folio is
noop_dirty_folio(). So the loop body never runs for any folio, and
hasn't since 776a853a43c9 ("i915: Use writeback_iter()").

That makes me question the whole writeback thing. What's going on
there, and what's the plan?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

