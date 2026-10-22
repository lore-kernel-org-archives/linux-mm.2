Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32FC606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXEM4jb4
Received: by kanga.kvack.org (Postfix)
	id CEAF06B0975; Thu, 22 Oct 2026 11:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3206B0976; Thu, 22 Oct 2026 11:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8BA6B0977; Thu, 22 Oct 2026 11:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4376B0975
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:35:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0002140198
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:34:59 +0000 (UTC)
X-FDA: 85350660318.11.656D5D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0EF3BA0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:34:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXEM4jb4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU+1Xu6Ic+cCmwqZl6X3dsTo05EzJQUM/Qh7OBA1YMo=;
	b=P/dZOy5ABEzhBtRhqWIqn8VMBCF/GpgGgjOLxq1oye5cGE5niV5ydmyeUa9DsdZ9Qzv8mR
	sfkyzAnfLtinjYBZ4HQjef9LAKUj836RIyGUZm01eWAGzsWkgi/W2Dyv9H5gS5GaoqJJzF
	MU8vKc9A9/0jWFE9+nXMyg3s8UUWUBM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXEM4jb4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683298;
	b=S02UcocHs+IMPrsR8cQINN7Md1LNEg+kq4sKmQDA4DMeeTWKHd0ZzKFKJIv0XFE3RymPaH
	0Xxjk6k9i7eZG+WzeNVMUFOd+jrE2wz5gD9/35262eqkOxAz35gE5W8PZBe1tdSersuXqf
	iGp48pqd+Kkgf21bnF7eWWHP97ICmuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B77163E30
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458D61F031E5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683297;
	bh=XU+1Xu6Ic+cCmwqZl6X3dsTo05EzJQUM/Qh7OBA1YMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nXEM4jb4x91hA6g2oPH9+gj5iw1zh7+UiP1ovTc0VXERNDtNwokstWvTR9+UuRgnI
	 BA8IKE/1y24Hta2uiqu9T+UxtmmcFtehu+wYOPFDYZsfXZtv2dMJq1wzPkUB2JyTS0
	 3pjzHo+3RIP4BHC0/4X4zvo2lBshjUsnqyGt4sm8vLyTauwpNe+X5EIn8EpyNdHkxZ
	 5EkfUTVOyKDG1uUjTU4/GBPa8cnhM0rh+SxvxvaTxUKOGyCx1nHlUh6ojj/EB05bda
	 xHjpN78VNWTIdBF7W6P1jWHHRXEuKJ8MkW2Jiafu6V8TRByHoMBSWuTNH3ZsBW1Z7M
	 AgT2SCJZg/ggg==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f1cf92c9eso201229085a.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:34:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcHx2kUacnYK0H9PLRSSIGbo+NRbg5v90gf+VpAW5QkWmgu8K80u51A9dwRPcCC4X79+WnOfSkVA==@kvack.org
X-Gm-Message-State: AFq9FYIkletiKyAU47L7mOWvLV0+GoIQ5aQFI9VW2eWYLJ2mZgP30nEH
	QKWS0ZOoS3ftfEZD/4smgtDnfQpr0/b8KbicDcXFp/q7Vr6OD2fRThftQmsYz1pzu9OzL3odL4g
	ngSmStcyKXt3TGQeOO2IosvsGeJNLl7c=
X-Received: by 2002:a05:620a:2a08:b0:93a:c102:1123 with SMTP id
 af79cd13be357-93f57fa19edmr1039679785a.15.1792683296623; Thu, 22 Oct 2026
 08:34:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com> <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
In-Reply-To: <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 08:34:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
X-Gm-Features: AclHuK9hNd1VMCyShZK7DRDesHpC0FNMFn7GHNLvz60HgwBJpHACrRofH5TH57I
Message-ID: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: return -ENOSPC on compression destination overflow
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0EF3BA0009
X-Stat-Signature: szq1xktkm5c534nkf5qj7p3hchwkuys8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792683297-386340
X-HE-Meta: U2FsdGVkX1+ouxak4Pu+Y9De7U3o0gKiAHnQK1jnwLd4cNMqVP+vX393VaO0SDOOa/Nryl8p30n4gFlVnprXKiMR8UZoABkOpZ/Gtq7YjyvjhIBqhcKZF6KZGctUr+hUZhbQ7RDXpGu/d+DnQyu5hMES74bPloo6qmKdNWYIvbEnM59TTM8xgL6PqU/1arcd+ev2ksuAbSwyS+CONv/svlpDkIGtSiZQxOuX/wHLtbuDnhtpU8LQJu16+nGieJeuaFizoQkeGcnbhPEk++Xl55LQQkKT6G3tXBqE8Ru4eZfWKuSbHuXwqPAY9R5v8tDJaFjU0R3HZWRBeLyJtYDget8yePZ60QVHV1QtN6bSx/RD6WDLb1NZ4bbMMyoNwIz/vuOppkPVSjBDkAxiUhJgTmnDeVw/2h8gPzTm3UVaiyWta04PoicPTZkkmgnZNk5VB6gbxrVtLcuqc020hxPDEbQD6axWuy0doL232qHaRx/Yl7co0RdQfwRXdSxXKS+bSX1LdDTP2oy2Npk+AgmQnIQNFDm953N5nGAFt9GKjTD5dyOAa1JXYE0ch2Tc3PogD3cApSIiSlIF1pHrIrQEdmDNrGV5CzgumTdihd+f3quYp5GnnJ2QJ7H/DL9DlVEGZsmX6VGBCRJPvWVKEgEaQgLqeJdtDzLkNJzRjlGtwwxocvNM8u99ZnIl0atkQ+3bMe6HfyqOs5RZfxeaABDtdEBmPSojl79M+prwghV1hP+x25VYVr2xe7BC33ffT1YwcGDC4mK6zx7BTFfm62H76YaJtGz3EbigHonm0s4g1bgZqIEXX9zPZK5nJQBwHNkp0LDJKTZU/hTuKLXLurQSLSh92C2HFxJ4knXgY4PefaGxz/xmGh4OIXFA3jKOrMKuBLnZGICLFQntNKGjp/tT0hOWjPWOoTzHT3I8Udmp8Z2bolJgtWpchX51lQmxA9VJWsSNjhdb1zVjeYFfhbN
 R1FJBkfq
 aCyFZB6eB83CAq8btD5srbTK0SRBc/Uf1V+KZ1zAHbjp6SWGkI080vUc8+elPQ6OoamgOS4VgZlAf7nZafr6iJXgC/LMVPH8f+qoAqsiFU1eYXLbUuqjUFaClFzctAQbG0DbYFfcV5v41DNDUsl47XtwqKqpaUZ2MUve2er/wFooCz2M/3eeZzIz99kWZqi8f0A6Gl+/bwDWXlgyDRNtaEnUZ/5JT4TFJAV39AhB16wY2rtfBzoPLKEpijIwi5TZMO6DoCF22OPaS9Xgg/EtZsLUSM/YvM5JHtfa95O6Owf95e/ldQuM7Yi0v06Hkia9SI29Yp28q9r0SkjqKb3u8OccwEPmuOQeCaw74BDVHVKSxtHANUm4VXi8AUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 1:14=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> > In the acomp/scomp compression interface, callers pass a bounded
> > destination buffer and rely on the return code to distinguish a
> > destination buffer overflow (incompressible input) from genuine
> > compressor failures (such as invalid parameters, uninitialized state, o=
r
> > hardware errors).
> >
> > While the multi-segment streaming path in zstd_compress(),
> > crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> > destination buffer runs out of space, the single-buffer path
> > zstd_compress_one() (taken when input and output are contiguous single
> > pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
> > -EINVAL instead of -ENOSPC on destination buffer overflow.
> >
> > For users such as zswap, which reduced its per-CPU compression buffer t=
o
> > a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> > compression buffer to a single page"), incompressible pages typically
> > overflow the PAGE_SIZE destination buffer due to compressor header/toke=
n
> > overhead. Because these compressors return -EINVAL rather than -ENOSPC,
> > zswap cannot distinguish a destination buffer overflow from a compresso=
r
> > failure, causing broken debugfs error accounting (reject_compress_fail
> > vs. reject_compress_poor) or masking real compressor errors.
> >
> > Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> > -ENOSPC when the compressed output overflows the destination buffer,
> > matching the streaming path in zstd_compress(), deflate, and 842.
> >
> > Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> > Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> > ---
> >  crypto/lz4.c     | 2 +-
> >  crypto/lz4hc.c   | 2 +-
> >  crypto/lzo-rle.c | 2 +-
> >  crypto/lzo.c     | 2 +-
> >  crypto/zstd.c    | 5 ++++-
> >  5 files changed, 8 insertions(+), 5 deletions(-)
>
> I can take this patch through the cryptodev tree.  Is that OK with
> you Yosry?

Thanks Herbert. I think we should wait to see how patch #2 turns out.
If I understand correctly, as of now patch #2 keys off -ENOSPC to make
a behavioral change in zswap, so the zswap patch would need to land
*after* this patch. Unless you want to fast track this to Linus right
away?

