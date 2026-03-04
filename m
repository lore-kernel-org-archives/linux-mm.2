Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D23BEF8FEE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F956B0093; Wed,  4 Mar 2026 10:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857206B0095; Wed,  4 Mar 2026 10:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7597E6B0096; Wed,  4 Mar 2026 10:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 632E16B0093
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:20:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E545116055A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:20:10 +0000 (UTC)
X-FDA: 84508741380.25.9116134
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2473C40005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:20:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1uqW86hn;
	spf=pass (imf12.hostedemail.com: domain of 3p02oaQYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3p02oaQYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhVDxVUPn4sMysutwLd1doihcMglzApjUEnzyngJQcA=;
	b=tjtnrEzQnAuVR6uwsmbTWXcNu9UYW5G5J3S1yIic62HPY3qfVHezXKNtDvOeSSHGK08xfg
	cBa1k5Fg06hKsFcewDauhJhzfEAXpC54SYyn/S0FhTxy/ephOTT/lvkiH83EbQ2kuP62FT
	j0mZcnJ5fUx9pdki6qQrgqpKaWzNbqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1uqW86hn;
	spf=pass (imf12.hostedemail.com: domain of 3p02oaQYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3p02oaQYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637609; a=rsa-sha256;
	cv=none;
	b=Gx00foz3J+1F/z0mhw2Qq20Rj8e7bm3wGvOwqYoA7i8PLfZIxBDxrt/hSBScc986Y/lX9d
	NbNoDUlYFSbwY4D/4w4D3FKy14DE1Gmncecwkw+dIMVg2FelldDBBwWww3R4PQ7WOIkxl+
	/BHvXzdf3B2byMi8B3gvUafOZ482nBg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so7756582a91.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 07:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772637608; x=1773242408; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fhVDxVUPn4sMysutwLd1doihcMglzApjUEnzyngJQcA=;
        b=1uqW86hn06SHpeajPtRQTVmhiW4Uh5BnwmVMVzTN6c6h6x3PEFipSBUAoFT5wcc+ZZ
         fVwdUJPjfeHqOdnHm02dnU1ddJ/Mi27tpacZtYrZOki/4rVXoMpqnml1l5GjDkryZcc6
         aLz5ReGOa0Z/6N98C7T7ENS7Lmr0SQtvxuzc75aIFF2ovZb3VFG4mEz6IW+AjX6/Uuur
         gwzBVNRy4JH2iwfylLCAJ6SndzdntmqjDB246ZFjkeDIF+NnqdKPLXgjV3ekWKbpWUlP
         8KJrqQerV/HfMZUj8VCYkS/KLfFp42BEtN0mRp42JNV+jQjNum9zC3z5iVL54SMHysKd
         2D2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772637608; x=1773242408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fhVDxVUPn4sMysutwLd1doihcMglzApjUEnzyngJQcA=;
        b=ZdYb+Vkq6+xH1awm7KQM0agfVlc1wS2hVYL+nzEzC/9BLFYJCxp0Ge60+8cQnLpORI
         phRRM5ADfzvn26IdiT4z4muiUPNYl2u8hRXb0JI1p0wff7i9dHm86I+Fj3tjOaOmNx0e
         LSGvqcamdoa2RXRk3WEmh62JDKgMWOCWexQHIDRXiMUPShfYuzBM32NjtFuoUSlNxKq8
         kijAAjXDkLVnp9KyIqjJpwMGPv3G6p4HAcqsAUy2OnrIL1Zad0YFiP0nPaH7UlfjxHkJ
         i5EIcGzrL/jMMT5DOBbIjfaLc8norUsuS3QF+CONuObrRzzTtmk5QV+9L8gwjCN1Lnjx
         7tYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH2iMXat3F+L/7A30ltTJO8FK7NIdWsqHeiiQbHm2+s98uJk/NmZCIKXdF3qXIpVNDXUsL7482Cg==@kvack.org
X-Gm-Message-State: AOJu0YzhchwwZGNvUGRoT578ENczoBHuNgI88drk147NS1ME5NPwcMbi
	zMI4gPSJn9rOuKR/Qthp1BU0LGg7UViilCiqML+aJr1CXz57cw+EuXFz9CjsDCbdqvfD5PWtyp6
	6XZHHgA==
X-Received: from pjbmz4.prod.google.com ([2002:a17:90b:3784:b0:358:fc29:4815])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e4d:b0:359:8ca0:308d
 with SMTP id 98e67ed59e1d1-359a6d8f5b3mr1977021a91.14.1772637607566; Wed, 04
 Mar 2026 07:20:07 -0800 (PST)
Date: Wed, 4 Mar 2026 07:20:06 -0800
In-Reply-To: <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com> <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Message-ID: <aahNprLw0_Cdhzxp@google.com>
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, rientjes@google.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, shivankg@amd.com, 
	michael.roth@amd.com, pratyush@kernel.org, pasha.tatashin@soleen.com, 
	kalyazin@amazon.com, tabba@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 2473C40005
X-Stat-Signature: uzsjucqijqkonijcrnmjj4hyjnud9tzr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772637608-941696
X-HE-Meta: U2FsdGVkX19mESzjarEnmludR/5jvpAvHY9Q7+mw9Ln9FO7ANLbWZ+Iwp3erOQXPRkolOT9RgriBUEQsWs8rwivUt2eTobM/nrNDGL5KqUUpk1lKU+VD++bSTMVc6qJ4Z4f7HlzLCqUPD4Faju3H5w6OpfOEEG/gnK12Hn3mZxBqyOfUQtrcAk52pvQwLR0yS/uf3FHoCeong4YhQ3mLMbNpP6zEkwuRjRkCdzuR0iTYjB4/AicEyDIr2dwij+gLmzVzjY8YHXNHJviloRcqzWPzYbdk7MKBmN9ZouFqzcSq6/9z6pcr7SX8hZAMi0LJJgUxwJ2mO5sgednoE4FXjkFEwYiso7QWmV1BlVVKc2oiZnEFecMJzjSNP81eXtoHy9xlcios0qjkVFvt0Hyi6yJ5sMrFOsUR4SW87JH05lDkQedaZphIASdiD7bAEdDNlAjdARKasrPQQwyCD0cOPssToB1LE/h95Zerl1OisaeCebyZ9ZUmg43WWWRi4kUyHNVmIkNXGtPxOCADDfLVgLSuXZClZUS2d2WsJ4Cue0ssUbvt+3YzEA4ApIiUuu5uHmQFUGZvsufVUVBgLz/d2fIG6tMd6pXgWDULZdGw8PWYrvboPphNbjC3oEHlnWpV0JkcN5qR8k1ov15QmwrYdg3GGmV97YCSN9MiFZID2itzvq3Xz2HNjURpOtv1MXOB6HxJaJUm1BETbUdxWDdS5yPYY+OaYSeL2XhVjCi/WyFtK+v490Yj+DLmKbrGGW4Owp4OSkLaiaV8yCRbjkqTYhjr6+aWd1LgsKOrNZTRfVC0zzN8QtDr+Rodo1g3HT+ByP1wodJbWs0OERdmWwlNXSCD2uQYZ4MqWjOx2mIaN4sYqlU9QTLsk7jiPmEOQ/JFghkNGmsJ6GNC/A1J2SY2WGmsusmei5p8Q0ZzQLSGLFhrfQgd8Wf2gsZz7wfOACw0IZyr+fbd4pbX85AKORx
 B/U4Bvb9
 X5jm5Um2OyuGN74ruhxOQMp/iiEwXgJNhkNLpPGCP/XyeG5Jk0z2nqUkB9CUyP6ucNoQkTe/LJ88jao7brY25JhRLBfJjf+SRdFtjBbkeO7/2Ji9GIZdcTLS1ik6SE52GqXe43M018pIVDF1Mrq6xLZ3Ey5N6EdSHO2mkz4dPQzZjSaKdGHFiuOImd7OS9g1I+ukW3qgC6+L8OSxtT7nLZDzG91feyLV3VR5ZvpisNNqcts2SoU1or8QLLMEEEolcZZZHmIBphmORDMhPBAlviwqCMpRgjBXI7O7lc4QfUgyrDpKqxMjkdAXPCDxbaa5FJB/q43vLXRt6QqTTWVgan8eNSPOcdkb0CCWTJS9YL+rEukrwZ5PK0hmLYdJVRLpBsC1EsjRYymr5svFGp8V15A0PU2ElPbstGQrt5UR3Kzi7DqDx/VdRi4x6DkaUYYMEMVinxl8LhDm6AJbqkQ+DadWGpgqXJYCmTxA7DgXQBv63IYovdBZcYe9qpIaEefTkkEMdG1e+rQdRlBT/+Kno10BryKo8z9kmBEA4hGxSkaDbLIKkQ9gNDdS0PC+l49v3zhYEDwVhb09zoDe8LtJHseCoFaornQ+BuLZ+RFp848ya82jbi6odgZZXa+Ew/nusD/EkRfR3XcJ5s/wLWsHvU5CQbENI1IFwYbxhoj8aegZHmdaJdxeX3DZ0Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026, Vlastimil Babka wrote:
> On 2/25/26 08:20, Ackerley Tng wrote:
> > __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
> 
>                                                            FGP?
> 
> > adds complexity for the reader. Since guest_memfd doesn't meaningfully use
> > any of the other FGP flags, undo that complexity by directly calling
> > filemap_alloc_folio().
> > 
> > Directly calling filemap_alloc_folio() also allows the order of 0 to be
> > explicitly specified, which is the only order guest_memfd supports. This is
> > easier to understand,

That's debatable.  IMO, one isn't clearly better than the other, especially since
filemap_lock_folio() is itself a wrapper for __filemap_get_folio_mpol().  And there
is a cost to open-coding, as it means we risk missing something if there's a change
in __filemap_get_folio_mpol() that's beneficial to guest_memfd.

As Vlastimil said, if this greatly simplifies accounting, then I'm ok with it.
But the changelog needs to focus on that aspect, because I don't see this as a
clear win versus using __filemap_get_folio_mpol().

And if we go through with this, we should probably revert 16a542e22339 ("mm/filemap:
Extend __filemap_get_folio() to support NUMA memory policies"), because guest_memfd
is/was the only user.

> > +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> > +{
> > +	/* TODO: Support huge pages. */
> > +	struct mempolicy *policy;
> > +	struct folio *folio;
> > +	gfp_t gfp;
> > +	int ret;
> > +
> > +	/*
> > +	 * Fast-path: See if folio is already present in mapping to avoid
> > +	 * policy_lookup.
> > +	 */
> > +	folio = filemap_lock_folio(inode->i_mapping, index);
> > +	if (!IS_ERR(folio))
> > +		return folio;
> > +
> > +	gfp = mapping_gfp_mask(inode->i_mapping);
> > +
> > +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);

This is a potential performance regression.  Previously, KVM would do a policy
lookup once per retry loop.  Now KVM will do the lookup 

I doubt it will matter in practice, because on EEXIST filemap_lock_folio() should
be all but guaranteed to find the existing folio.  But it's also something that
should be easy enough to avoid, and it's also another argument for using
__filemap_get_folio_mpol() instead of open coding our own version.

