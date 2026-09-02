Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5922C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12066B00E7; Wed,  2 Sep 2026 09:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9756B00E8; Wed,  2 Sep 2026 09:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A010C6B00E9; Wed,  2 Sep 2026 09:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2516B00E7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:44:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17DA11A020B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:44:50 +0000 (UTC)
X-FDA: 85168942740.27.507903F
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DB3240003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:44:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kevjb1d3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of idryomov@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=idryomov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dSC4i56GDCKpLLN6Iph6zr29jWx7mFCg/VcjlijsBo=;
	b=xOTo5EjNxfFNyA5M6e8IazC+BmmN5KtwF5/85E2SXN6+ofPo6ynAOL+3mafzzSotGmmQ+L
	xxomkXCkhusXnGmKkrccnTug/cxbnxnMMihhZgDNsaxjmJ3BJPUFnNXOer8l6dFD01/OP2
	2AzN5yqPOVwOeAbq6AVx0v05lr4g7Rs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kevjb1d3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of idryomov@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=idryomov@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788356688;
	b=HrZDZMk1YetsR56i7Ei6dHVrGUQ5KEFGrXUArRhUUe7ABhcV3AUoJKrHedLJhF8bQmaoZK
	IWKEpRzyT1lh2GoQL7HcK0334YYfwaCT8ZefBpbUMj+P8sz3IbnWgeNQ/hMxGa8a1TsgGT
	6nulvodAeW9o9B2zaXaXYOq15dBun+4=
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7564b7a9490so1805351137.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:44:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788356687; cv=none;
        d=google.com; s=arc-20260327;
        b=m40pRWVVs9F6eQyZp+xYbwZFvPkv2PF3nvtyGEBg/EYlQ+GcMoFRe4rEROlpo4ig9c
         bLWITPgg8RrUE/qYjZfeLdvqlFMmcd7bi9jU8hLrsbY3mnJhzQOnuh3qflMDLdSE95Gm
         U1qzGmRGG55aoZtZQfGCDurmiU4V81kC4sNjudYA6qg/3kRjsojYvRlp/UH4xagjqtIg
         Ypu5oQ02jAn9Ez6Vl/CKKXIJGvvdKF8zv6tQnYG7kwOLU6nk9ZSzI1PN+tIwiGDPazy0
         bhTaexrPEXwfY4BJuuA7u6WLUMJIgs3m8vO6G6IUswyLJyCcGY1cn+9YMvRMddP1Z0jf
         tHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6dSC4i56GDCKpLLN6Iph6zr29jWx7mFCg/VcjlijsBo=;
        fh=k7oYAasDFyigT2NMudFSLY7l+FMddWcI87PEIj+J6no=;
        b=olncajRM2NIDR4Q+8C5XAA/nO7SCjFhyqpRy/GTQcbRFP1Xt5Je1U6T0amc/jGonnG
         WWUcieyvlbyqKDOsxpAWro+OuzXn9IpiqHY+9A352o0A41Gtg7ORgXwZje22OwxMaf2d
         3ajNkhmSOQUrfKbe1eENRekPwcytHyy9CgcL6AfFqAao+nP3gVaIvFTLzofwWLbcimX1
         KEZbz4aeecnhXWgHqgcc+dItHjSGkTnCg8mjwMluBt5Zp00r7SKHvi/fSBrq8IGCh2v2
         aXIhbW+Zl5Kri3HbZkphlhWk36e4IbwciqWwo+bKjJttCCDYL8IOn+JHudcXiOCsUIXa
         r35Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788356687; x=1788961487; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6dSC4i56GDCKpLLN6Iph6zr29jWx7mFCg/VcjlijsBo=;
        b=kevjb1d3HQuWFJ/Hy6tX/AATwSOniS8/CgX06vupWNW6u0gFY4mbPhety89bPXjkpy
         0z6WXdiqFqngZrzNgzrKDUBMJ3uq7f3qQUqL4VhFYIpaJxmPh96c+MzuMVmy3FguvZdz
         tSbvslJxU5sjEKPbh7CEpA/FDyiB8SrOulnZY+39kzFrRkYGjtoGCAHMuC2EQvw56T9D
         daeja3rcKz2Ntv0wHe2p8238GrbRY9iReuaShFjDtLSYrk1KC/eQB6gtflgmc3LzHDMY
         Up7MN7muMKPubHQzJBf07xRvohrqeF4IF/xsbir3czB54euOgFjkAsbW52LgE9Y7bEoL
         FTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788356687; x=1788961487;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6dSC4i56GDCKpLLN6Iph6zr29jWx7mFCg/VcjlijsBo=;
        b=ESiQQ71fwt61dyqt5feS5cHTI8hlvmRMCuWd3BaWWnlovhDahbmOnvB4PnlHFHvsU1
         1kCHuMJKArqbT58ufWDpVYoi+TuZCR8NxthgUewVS1ll5a+qBhlaqP8mwaocqB+p1Pzq
         mypUM/TttuTviqdpNPGcPmYi2n7OxVszPkfLeiGEkXq3y1rs2lmicM5ajPDSHZK7terp
         +4AjuON6NX4tHe7cIVuQc0UiEFqgjn+gu6xJTAchVUbA+58PJnhwKRuhnjFyYjscdDS1
         pPqIVweP99rDCsZ/e34Jwrbs0VNc0URnzl7BSShC8cgZ49Euf02r48cJwcRgBJKYt3fC
         Nntg==
X-Forwarded-Encrypted: i=1; AKwUvBxL77MWaAV08MlD0vzHpgfIZACnGTkiq3XB9aBIm6dxPpgVU65oeB3AhdnT/wTeOuPM+N0Uy+ALTA==@kvack.org
X-Gm-Message-State: AFuF++nLIUawVfHijJ8dzg4NQa0c482cAc1FKO6jbp3uzTB1Qakx7wir
	8kTdrLtogXArmYosGAZbVcbZtQMno2fhB/oIzNSncGvkKZewhRLnOmiofWhHqdy2GfBczMYjGY3
	5OhAkXi4dm/dI0kv/d3NiR3hY/kleuMM=
X-Gm-Gg: AYBFou13sGAaozMqWrczS5g1UjrzelEeU9JwKQ58fLgMp91CsqxPMmxCkz3quWfEjsW
	hJwPZlS1rMTpxaFimB963kKWPPEUct9+UANsH1JbCqIWWRrAnQPHKRofrcimPLoCM5wLoLj39OO
	V1xKjE2pSLHpa3hg5aWFDN4qoTaqACp5FiXKLYS7cFM2eBZsmz6aMeHRdQWllHhe+SLGZu6lK4H
	ubZH0iPDEUPnHIc9Gmi1MjuRGzLKim+hKRK6A+WCDHarb0xch6j4TbLyPSdqVs9fSl5TT4/z/wT
	rqAFJdILTpKMYu67iFrxmr3VqGPeGlqPY4pz9mh5g08/fjyOCEgli0+wh+ClIzKZewSOj/Q63kT
	Okkpm
X-Received: by 2002:a05:6102:41a6:b0:779:328:8a2e with SMTP id
 ada2fe7eead31-78a1f725fc6mr950132137.5.1788356687181; Wed, 02 Sep 2026
 06:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
 <20260817-remove-wait-on-page-writeback-v4-1-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-1-0e5e53d47eb0@columbia.edu>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 2 Sep 2026 15:44:33 +0200
X-Gm-Features: AcwNN1Vvf7FpyU1HrqjBI0mng4bI8rN-Wlo5S9DqsAbNDuh3hnayuNaPhBcoE8o
Message-ID: <CAOi1vP8SCZaFTodwm3_c9cFfc4UB5X8J8vF-sxh+4TuhCS8iog@mail.gmail.com>
Subject: Re: [PATCH v4 01/10] ceph: fix error handling when the OSD client is
 stopping in ceph_submit_write()
To: Tal Zussman <tz2294@columbia.edu>
Cc: Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8sxe1qr9oyd3g3j96b6fsjepsxdcnyuq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DB3240003
X-Rspam-User: 
X-HE-Tag: 1788356688-605712
X-HE-Meta: U2FsdGVkX18C9ugChEHcbh/8L0RT2VoH6QtQHxfftOdD7y6sgmu15oIas21/Omvb/xMc/E8ALOlW0jBRpvLlXCf3Rdzm8ZYedYTCt6nF01zDxuliI3I9Wtb55rL64+Nuq7L3VBnZi4XUm6mRt5WNjHWf/LQSfRoVPi/9joV++U1T1SmMrOi/+3I+eqRIBmw9uFHvW/cR7Lma2RF3w9AUlcRiH2qsUSNmsG8pV5Y6SJ5PnKoy09SaUgkuSCAnTzmL65gaRcgyWaGb8XG3OdLiIHqrMXeXY4u2rE5R0I3DMZeRR8OtRBCIWNK4aHlzEUfwsS5bXd8SreFp6/lfGGZaDMBQkLcvJ2Q1zkYY3R0swuRK+ap5FtW8ROVHS0fR3uV/sxynzqWS1ctPR4Gfi5ESSm+D7EAvllEABblq4IEE0Sx7uSWXKZrEsRrsLUk1ACxp+2j+YNQlVYrXluqBBMsEkl9Oxubz9wTN9EUQj9QwEQ/vplgKn8cuCV4iVyRk508wqBM8EEgq26ZaVnefb/7KyRUqeS/MQJDmmFdVBzsnf7Ma8IP33Ef8S6aUOPACfklyyIo8qHhI8RFjrVKNWJngEUBFlI6eirRGNDORVQe/xDanauLRCt5byOGRVnTJJ/mAPSOvID6akoGQw3+yzLWp+iroOhlMUK7U58wYvJzIbDA8t5KtrIrc7M4GZ8b8KRv2DFxui4AKw6fKnoFdCxvsQgjebfyTD/dmxzki2tk8Zadry5SVqV/KrI9hieWerbfelFVu4H7vS2Uc3qYxApGt1sXfg9v/RE+4djlVIqXxf4tcRNmGwvPSmGmbqSp3GhSdWw3G4IivMAQiBs/PCoj5rT6C8gUCxL/60ttuWPHPez94kbBxHG+U1a/s+bGB9Bs/mpEYpWoYqgCs6WL3XQA3YaNX0OFicnAzH4UDyk2+zPPZxU6Lhkuh4IjWDJZFv2WfACCXigIdD6c+HejDIfA
 bk1dDnGy
 pxhxA3FJLe8v/t1NBQNDyXgvsv7/s7nY2x6DglyiCIdYCMppk2t5cqJbhWwyC1Ft94CDjZFuoCr+tNHyU3U4asbdDm/OVlZuiynEQ77UkdeJxT++VJnZsiUUI0JP7niUppsIDmeIg70pUW4Q0QgrNWvpa5Ut+XlcHEBUb16oSq2FXnzB7FhpNH3xCaf+/Zs/CcssbfWvwksb82RtjGtXksDceTFSiOP45VT0lAyzXGGzCHR76OivRM15S2MNii2HmCnS9NFltdCaMHqjnk9W1O4kAfZbY0GOruuPakjDd6nquuQ1z8vjBuSBn6vfVbTTOhop7vUi500434iQM/wj0QOzGfNvHXOstrS1HB9sUIV29Is7KmYRhR8kk/mmegxfYZcvoQIYKs26diZLgKyuICYJwsDMyyldFTHI2iMRH19taEYxQ2lEoYFd8z4zZJEhw2QFvRRU2gGhUuAjEAB3J5q2XlyuftxZsCmvaikn73dZWSgDzORtK26+Q1RCOODVxKCASIcYMKoDpHsNBhAlA5LJdNl6Jr6NGV6TANyvSELF8xC57vvKtH4RstV/o1vC4bhouetVUJuwroWgJ7KeZqzuUnentB/6SDWb6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 9:15=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> When ceph_inc_osd_stopping_blocker() fails, ceph_submit_write()
> redirties and unlocks the folios remaining in ceph_wbc->fbatch.
> However, none of those folios are locked at this point: locked folios
> were moved to ceph_wbc->pages[] and removed from the fbatch by
> ceph_process_folio_batch(). Unlocking them triggers
> VM_BUG_ON_FOLIO(!folio_test_locked(folio)) in folio_unlock(), or
> unlocks a folio locked by another task.
>
> This error path also returns -EIO without fully cleaning up the folios in
> ceph_wbc->pages[]: their references are never dropped, fscrypt bounce
> pages are never freed, the writeback congestion count is never
> decremented, and the pages array is leaked. ceph_wbc->locked_pages is
> also left non-zero, so ceph_writepages_start() loops back around and
> hits BUG_ON(ceph_wbc.locked_pages).
>
> Leave the fbatch folios alone, as ceph_writepages_start() drops their
> references when releasing the batch, and unwind ceph_wbc->pages[] the
> same way writepages_finish() would have. Abort writeback in
> ceph_writepages_start() instead of continuing, matching the handling
> of ceph_inc_osd_stopping_blocker() failure on entry, as the OSD
> client is being torn down and further writeback cannot make progress.
>
> An LLM was used to verify that the cleanup was comprehensive, and
> suggested aborting the writeback instead of continuing.
>
> Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeba=
ck-v2-0-81f0ab065284%40columbia.edu?part=3D5
> Assisted-by: Claude:fable-5
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/ceph/addr.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 1f77aec8e960..d5a349daf4d0 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1482,27 +1482,28 @@ int ceph_submit_write(struct address_space *mappi=
ng,
>         BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - of=
fset);
>
>         if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
> -               for (i =3D 0; i < folio_batch_count(&ceph_wbc->fbatch); i=
++) {
> -                       struct folio *folio =3D ceph_wbc->fbatch.folios[i=
];
> -
> -                       if (!folio)
> -                               continue;
> -
> -                       page =3D &folio->page;
> -                       redirty_page_for_writepage(wbc, page);
> -                       unlock_page(page);
> -               }
> -
>                 for (i =3D 0; i < ceph_wbc->locked_pages; i++) {
> -                       page =3D ceph_fscrypt_pagecache_page(ceph_wbc->pa=
ges[i]);
> +                       fscrypt_finalize_bounce_page(&ceph_wbc->pages[i])=
;

Hi Tal,

fscrypt_finalize_bounce_page() was removed in 7.3-rc1, so this one and
patch 8 need to be reworked now.

Thanks,

                Ilya

