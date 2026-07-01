Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A489C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E493A6B00A6; Wed,  1 Jul 2026 09:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9B96B00A8; Wed,  1 Jul 2026 09:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3EE6B00A9; Wed,  1 Jul 2026 09:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24656B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:08:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6A12140332
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:08:25 +0000 (UTC)
X-FDA: 84940236570.13.2B31CAB
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8089100006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:08:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=OxpHxQn+;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=W5zubF5K;
	spf=pass (imf05.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=quarantine) header.from=janestreet.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782911303;
	b=hNuSaJPHKykMnRoZ/RUSjZVOKWV5sQptG9ijh1GUwSzjFDJHyzsH+ZoVmbJ3/xbu8Ctrlb
	yszZbzeBjPXH3YQuqDPNxjbjMphUIyRMgYmsXzNwKfFDGQkG+6JG8XWuCMuZBgI2hFok6b
	7dbtwDMeZG4nVRd6c01eUc8Z/3NH6mo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782911303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7e/LeiaosEk7gbcvbS8Q8cNOEviS4SeVXYWmv3QOzI=;
	b=k5OnyjG0M+OYG+Q/ZNdZXU4DuNMPtW0Zpvz5lHVkDiVxeuCidnzkqfIhJZJ3OxCMasBsMt
	Z5vnGR9eT76+Cuqlx9STdT6jB4rZpZjKeBfoiJJ86kTC3x04C/D6AaYAfdIaBwaH/jAKz7
	gtooKvX0GXR/QtegMmRN9i36J8cNO3E=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=OxpHxQn+;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=W5zubF5K;
	spf=pass (imf05.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=quarantine) header.from=janestreet.com
Received: from mail-ed1-f72.google.com ([209.85.208.72])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1weufv-00000009vuF-0KCK
 	for linux-mm@kvack.org;
 	Wed, 01 Jul 2026 09:08:22 -0400
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-69848bef5c7so661344a12.2
         for <linux-mm@kvack.org>; Wed, 01 Jul 2026 06:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782911302; cv=none;
         d=google.com; s=arc-20260327;
         b=pgkLGioz7oHQQy+oqS/pEEwI8RYGyU46Z3NIGKfEw0OrDVMTzH1bWV6e6ToY6jUOBn
          nCFWOkQPoKWWhUzFNDyc/S2iQKWzgZGY4w2AxDh0asrAun+e/XRtvp3jcZ6O81aoQek8
          ey6b89Iv7AoDpb20y0vUBL7XTjwGcgwfIRUoV44UgqBcDqUe4a4kGKD3pVqYoms5YQT5
          99004oCJoX/DrVYlXgt2QuEpzO2Z88AWEGbxHYYQXpiQaGsvDgmRzv4B48tXpmB+I/bE
          psSJSV/SVopeZJC/xJgv+sW08DBzc6Av1Cv67Ik2Ft+M9k7zGB77Bwf884GCyT6V20WA
          dgrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=X7e/LeiaosEk7gbcvbS8Q8cNOEviS4SeVXYWmv3QOzI=;
         fh=7Jyt+pvkj6PP8YyUE8cTppp215LQADFBIKYrQlsplaQ=;
         b=SuVdtRqhUiCEx8KV4fGp1kA321bqYX6K6WnLOoNf7297pa/Hj2X5HLtRTxh06t3Ulw
          ILxRAx7FwiYIzbQWLzRsRv2/FCIcT03Fpg7ycGKdFKg7wpHm31BGe4MmlcmwVub7vUHG
          qIeMOOMHQNvZK71ptNfHuW73T6EdqEWa2BAPah+7LvG7/e3xrRD3Og8rGBv09e0BIXbs
          nc+ywngL47Ll5RGEFWg6X5EMCtFzKGeh847wM50tDtKTz7adB/rrOPe2eVO+L4uftV6a
          hKlCDmQad8ZTmMSzMHQTfko7d9QD/lxTOq7zXXmELX+MqyewqSwcwFrLAVw3X4Z5GOqO
          FgJg==;
         darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1782911302; x=1783516102; darn=kvack.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=X7e/LeiaosEk7gbcvbS8Q8cNOEviS4SeVXYWmv3QOzI=;
         b=OxpHxQn+hdVNcnnhO+0mqXEGvVsrIWnjfKZeoKRaUoJqrFd45vLJUoOEU0o2a01rLc
          OPKEYG3kxvYYzTaZwl4SZKdtqqomJFljnhhPGKdDvyUoj4IJRxm4TU7ZBce5ZR0rnDyT
          OsJVfyjnmTZINy9q1Vfcjwl4oTP90MKV6wf8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1782911302;
  bh=X7e/LeiaosEk7gbcvbS8Q8cNOEviS4SeVXYWmv3QOzI=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=W5zubF5K5t2VcP6Z5302fsEYdDRnkNqiy5o8YialEgWobGXeN4VD6w2Ae1xHpuHlf
  B2PbPjpE6vDTVU3xSGqpaBa0mYo+SZCiDrcElYpwqLHzwXHMQ26R8VuKuy2HIqlZhx
  sqMvaAIcawdYhAKQh0gmYGlkOPlcCZNdKgWYEex41Vq8mWAApZYibliUfBNXSSYy6h
  Fjg/akLIX3yPxY5vSvlCqj6BxB4Ah9O8FIZZvtwOo+qZ8Iw6QN0AKIQePa9MlqYk35
  DZspSLeMeW3VxBHMfVH7OOY3E5q6Wx7YasN4YVTW1XbFYm8SPlqJR5hdp72ymVW6W1
  SqLHix+cCJCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1782911302; x=1783516102;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=X7e/LeiaosEk7gbcvbS8Q8cNOEviS4SeVXYWmv3QOzI=;
         b=TP65wdPLeGSNm2Z/uAF0VmqElCokP5AG2IsrqZ/efWqTqkKHIebRDaR784/b6Lj6Sc
          nPJjrGmjz1lCxZYC+VfvgU77TLOX/TgMquR2o2uiKXmCkTv1IpGF0fKuRedHYO9b56Jw
          c5CEJIZlUEsnW7xDYWwhKqbIiAPHdnEqwn7fc4Zm9GTr6ZXIMRNQgx0KP66SNCClaBYY
          OVD/9SfmNtc8er8WeUshlIca2x3fAg1pkymKWRo89FpD7PtLHcSXOJHJWaj9D0aNjssZ
          i4h8IUJ+SIv5CKa5OPDj7IR13lvMGHGLU1hxqOOzHfMcJCWugOXbwu/A/x4CSby1u0nX
          3cuQ==
X-Forwarded-Encrypted: i=1; AHgh+RrC6FDkzw6S/XUlLuU58zrVSZu6vGhh7hcYM2TtzYx+/rBl2nSm1GMAuw3G8W8vfKoMzuzzTqJwqw==@kvack.org
X-Gm-Message-State: AOJu0Yzo4wYV+N9L4ge0ZULos0A53TTZYINY2FDm20Ok+AksOod9ZKw3
 	+ya0nHbUXUN2Ee2QztD0jZQYfsyMaOUJA6G3rwNzbGlK/iS0fBVroLeYQ30HbmekrRHaz7HCozt
 	R3/fbgoaFRh7kVS9Hu6DxWU4/gpbrPEcNCS6xqSDNvVwKy+4fZAgrUzFzfLoSNw91s+SEvAHuPy
 	HFDBs1UblWAaQi3xMDFnk1mLkL8w==
X-Gm-Gg: AfdE7ckd5bc1RlEsOev6jAqbghu9+7DUEHiG3Rnv4l5UcghYDgbQCFbhFkYbVJCxMG/
 	/jwi/uaEI7F0WOgisyF66ZYbU/K31hxvdX0piHJ2cUrsNfo2CxNWD8AWMm73Qqd4pTYgWy0JRIS
 	3xJL5hd21/HklYjK2K2OGgDOSV1/ag15nG2deWgtGjhhqbIRV6kTXy8JCet3UUAeust7E=
X-Received: by 2002:a05:6402:430d:b0:698:3b7c:7e2c with SMTP id 4fb4d7f45d1cf-6989f38f47bmr824656a12.36.1782911302040;
         Wed, 01 Jul 2026 06:08:22 -0700 (PDT)
X-Received: by 2002:a05:6402:430d:b0:698:3b7c:7e2c with SMTP id
  4fb4d7f45d1cf-6989f38f47bmr824637a12.36.1782911301695; Wed, 01 Jul 2026
  06:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
  <akQIIav_zaK6RmIC@pedro-suse.lan> <akQO8JtTxmp89GS8@pedro-suse.lan>
  <akQekZUyoKadiGCH@pedro-suse.lan> <akUADHLWEetveHLp@casper.infradead.org> <akUKty7jsWJrdyho@pedro-suse>
In-Reply-To: <akUKty7jsWJrdyho@pedro-suse>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Wed, 1 Jul 2026 09:07:44 -0400
X-Gm-Features: AVVi8CfbAVtUJ3lTyb378QyJPKoGbZ_N6e1vZmdlCalj-0NGI2vym8M_lSCjDHg
Message-ID: <CAFN_u7EE0ooQsH2JAnYn6EFrxnRToXAqvW_uUE0aqPDEPEmSAw@mail.gmail.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
  dirty page cache
To: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 	linux-kernel@vger.kernel.org, Eric Hagberg <ehagberg@janestreet.com>, 
 	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5resrk9dcier9dyxp6hm661mjoyc8nk1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8089100006
X-HE-Tag: 1782911303-916614
X-HE-Meta: U2FsdGVkX1+sYidm79F32cbpR4/GDaKwdmR5edmEg9SgoqZb7EoQBFICGdm5w/pXGcXMw4YWflizn4oL9Jl2vI80M2Oa4v+T5jAk8HPxyh4WWqRJPx/ZqDey3NiqkcGaJn7/KbzoKdaOMrerekPZyi0IAJJQdrnHmjFPDC5tn0sf708pRxIBmB4J+qhl2SJ29HldcfJ+EoxtlgbOY9XuM64HwVNaQ6R7i1ORpm/c57A92DMKXtP8RsUbvY/MeEo7zsSrBe6ZKKcs4UNaUncq3dPViPVkv/AW1x6VL7CUrnUXnfKi0nKYkhFtgmEIh2hI1n3ZiKc6rbjacPck07TlIX5cXuKrK1Idls52z/GB9tceR4ZMTgS3zycqah7nLAVIFZGe7rsCQiHuoQuYzHClQpDnwMy900D93RaYUDwsbyqhdt7RFGtu5mW1YxTlqXZsHzrvhCoiKRz7Vnx6HK5qvqPGI6j+vO6tVipEc4DRMq7IzvPmcTt9WpJdPB+Tfu4/1PaX/HpKU1/YEByAh6pIcZBBVdlK5n8telM3mDj4KQ2zmyL7OolCeweap2eR62M2jqxL/A/5L8eW7C6u72Kem8UFL4caLN6NEL+TpvK25bDpnyBdymAAKe8jG/a7DY/XQnuPhz2u6gEwxZvf1PPcdh8/tTsI2aCRBJIqFPQqM4etA3f0EBO9VzTibQZ7p3JRvDHsX7Z182v+rmDlscnQW6UAzBp1DYfkyoQ52zBMVam5uhgellGFJAbeU6yrnegd6OfxVLWRnEzA5cDczrJ/Hgpkf8A72ETRP6DX8T0dnPxaqLXCCXUWJqwufkNFIV68+e1kwRURC+S2cxgjKdlE5BCzjHw8n6511b5Nk5R6WCHbbomKBIiAkR86D9oTmpfhSKR4rFSC8N0WJY3q8e0d3dkBMtVDMqCM9GWy2sXXHLBmJ/udUav2FWc8Nr1E1LSHAPaXMRAbt/pOwGvWGa/
 st2pPIXc
 hVGHsKcRKc3srspcfGpafudIvRrq+A++XlXiZ5tyzPnfy7g59aLSXCUE0k7HPYK/McaekT2cc2YPS4CD1ml/h319NjWgDKKybmQOGt4CLja2LIU5b97u4NoOa0M5aXOqu4vmLFJY7p8aLZ/u1LmxEgDnJA8MM/KG1u7hECQ9GHDTbB31tNT21Ypj+wJ+zmFj25w5ZpOsrqB9sELwy3rNmosfDbpAeyF2SiDBNVsGXiNBOuZ3u7Bb5O9l7Nxi7wsxOGMGfoKZWcYUjFyQ2+4WWyVLDaNsXxwGsn360lpBWujpNEnsAbygr6cQn3uhVG9JnyeXJ9/VF7p50rSq5HgKS8rS2piSn7YEqivQ5dkw2pf5dLO7lnt3kcuL3oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks all, it sounds like there is nothing for me to do quite yet, correct=
?
Also Zi Yan is correct, I meant order-0 folios.

Please let me know if there is anything I can do.
FWIW: The patch I suggested did seem to resolve the issue (based on my
testing) and did prevent my reproducer from reproducing (whereas it
repros ~instantly for me on a not patched kernel), but I (obviously)
defer to you all here.

Thanks!

On Wed, Jul 1, 2026 at 8:48=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wro=
te:
>
> On Wed, Jul 01, 2026 at 12:54:52PM +0100, Matthew Wilcox wrote:
> > On Tue, Jun 30, 2026 at 08:55:12PM +0100, Pedro Falcato wrote:
> > > @@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm,=
 unsigned long addr,
> > >      */
> > >     try_to_unmap_flush();
> > >
> > > +   /*
> > > +    * If collapse looks to be successful, flush any dirty pages
> > > +    * out the page cache. With the nr_thps incremented, there won't =
be
> > > +    * any new writers (nor new dirties).
> > > +    */
> > > +   if (result =3D=3D SCAN_SUCCEED && !is_shmem) {
> > > +           err =3D filemap_write_and_wait(mapping);
> > > +           if (err)
> > > +                   result =3D SCAN_WRITEBACK_FAIL;
> > > +   }
> >
> > Oh, the other thing is that this should be conditioned on
> > !mapping_large_folio_support().
>
> Thinking more about this, I don't think it works. On the file open side, =
we
> always truncate the full page cache, even if large folios are supported (=
due
> to possibly max folio < PMD_ORDER). So if we skip write-and-wait on such =
cases,
> it will be possible to fully reproduce this issue.
>
> --
> Pedro

