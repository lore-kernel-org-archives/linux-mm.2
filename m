Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF80CCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF38D6B0005; Tue,  9 Jun 2026 13:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA46F6B0088; Tue,  9 Jun 2026 13:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92C66B008A; Tue,  9 Jun 2026 13:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 951FF6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:07:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED368406FA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:07:30 +0000 (UTC)
X-FDA: 84861005460.09.28819FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A06D1C0013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:07:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z5DA5Ba0;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781024848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKxLl9DbM2QcXWSCGTt3tQ/LWoeMykCtC2R9gW/JHD0=;
	b=R8avgCYAq/R28dAkzM7MgenoHzmEGMPYJMr3AFhX9Qh2cjey37pziuB//pjHtWMNu8mfQV
	w45csiMc36v0ppmNLwixyhN+UH+BpkryCi1bh/o+Kncf0z4cHeSotrskUIrQlEOKqRbvz6
	asCsI4ybw+Lhhx4oSW4FTPUN10vrHVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781024848;
	b=qduQPgWeoKEXE9KMVwM+vXY7NpPbQKtbEmKEIuwF5a3joBPdkMGRb10nDRQ0v2/po+vERS
	dT95L4duQQQ7wyV078kIQqjHoqjMqg82EqUdhjJMmK/Ji5AKzk6+4VRqXKXbVfBBt34Nwl
	e1WnXS35l5kYrHilUE8XDm/A5PaswJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z5DA5Ba0;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781024847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cKxLl9DbM2QcXWSCGTt3tQ/LWoeMykCtC2R9gW/JHD0=;
	b=Z5DA5Ba0UY42nrN5dgpyfAhdIRUFhi5kFEuIMSbr3l5dxg06sHj6gDFJPDDpIM/F1NjvVt
	yRvQr5gkNVG4iHQY1HhgdXkgYDpAXu9ZYflPLo5FINhtKsMlZMlU6Ib4DH4FTg7FRE4Muq
	TjSFkRF1bKPybOtMzNP5QrZ7Quf6I8g=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-O4KA2kTZNEuLTQCAkB9OkQ-1; Tue, 09 Jun 2026 13:07:22 -0400
X-MC-Unique: O4KA2kTZNEuLTQCAkB9OkQ-1
X-Mimecast-MFC-AGG-ID: O4KA2kTZNEuLTQCAkB9OkQ_1781024841
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3969ddebd36so22853411fa.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781024841; x=1781629641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cKxLl9DbM2QcXWSCGTt3tQ/LWoeMykCtC2R9gW/JHD0=;
        b=WRstuH0+K/nHuktKE1Xoj5oszKEB/HdJCwDCAapW22eP3oUs3J23yNl8FRfV39Tjcr
         ToVB0TPfFLTThv7Pj4flbHgE0niVfAqFT6kXV3oeG9w4AF0rk0uYPAIvA9SRdcMp9rxG
         1OI2U905s0ncSw/qoWPGjzEHYOyFThQWpVpp9mkiaOZzLV7Mw9CVBzdJ/92xJuibloYK
         vVUTHvAz4wr00E7Ni0YQrLu5xvWYtZ7q3+ww3oO7tgzmsmn41NEdu3gLDPbtfcrUtRZN
         yLZ/uNSxgCcxJYkQ+fIsFObqF9qK/iKtWTnujsZ1DnizPz+/AlINDGL43w+jLzgRnnux
         PwdA==
X-Forwarded-Encrypted: i=1; AFNElJ8BFm4+pJfDwWi5htfUGqwIjxNHxZdQlczLA2nXglR+uN8tebSDBjxcVivFtibXcGoCDoL3SBoz9w==@kvack.org
X-Gm-Message-State: AOJu0Yz95vw9Eu/fMkDPGtQqt6iorALDHPWbmGQoyIJ4cgSlbu7Cvbkk
	+Iv7RrsKVLuvL0C/Ric4v8fB0EAvXSvhcgKhov9P4FkBQ/Dq+a6bo6r7H2yfXFNuR/oh82A9XI5
	H9+2X+scI90HtcNXP72jsOHhmN2IKW3+u5xBCS3/zxfZKIPKnyV7pzdxFNQqo6M5NUL/lk1C582
	T6EnK+Vm7pxezVkghSOqrPqcj66MA=
X-Gm-Gg: Acq92OE4+9C0hUfzfu9P/DVTiuy2MRwup4bzaaWMlhm8IREpLvOqt0AgToPpydTo3as
	FtIHsm29RK3Lai26ZxrmDkjM5LrA9ZpxR4hCmZEXewU/uSVKmVdR1RzwJjJ0brko853y04anEwg
	5FsCvBGARz709sr0OGmA9zF7sWpsoX/EYYgfr70qnsxkGyDJc4Qb+XAL4a+mM6g097kCAZH249t
	Rg9CGfWAi6ivU7D
X-Received: by 2002:a05:651c:144a:b0:38e:9ece:61e9 with SMTP id 38308e7fff4ca-396d0a8d574mr58205081fa.25.1781024841080;
        Tue, 09 Jun 2026 10:07:21 -0700 (PDT)
X-Received: by 2002:a05:651c:144a:b0:38e:9ece:61e9 with SMTP id
 38308e7fff4ca-396d0a8d574mr58204951fa.25.1781024840619; Tue, 09 Jun 2026
 10:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260609120443.71864-1-lance.yang@linux.dev>
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 11:08:06 -0600
X-Gm-Features: AVVi8Cf4zemLZuGzBpR9Dm5BCGoUQA767CVoQ7qOSxm5ogaIAKml6TqTGlRtVGE
Message-ID: <CAA1CXcAmW_9VFjZ05QKj7wh1R0Razxeh+AegtJV7--LHVgVVNw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE accounting
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lupA9-sYi7FYNxHz-EkTc51_IzkDpE3-3MIUXLGA25E_1781024841
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A06D1C0013
X-Rspam-User: 
X-Stat-Signature: tpcyq498ztwmkhg9gh1z564yxphxxzg3
X-Rspamd-Server: rspam08
X-HE-Tag: 1781024848-22599
X-HE-Meta: U2FsdGVkX19VVbd2V8wmXlemJrmmXsFk1ZasYDef4FBA+8KYNM+ThRkN+8HJQN7qyz41hIAlCbl0CwPapAkFag7TK2BXFrgyGC0aXXVj7Qj7antWRo/WVlEHyHrKWaNmKhchtZkMo2uOBXl2f6Vw2+gzDvSz2JVKN7Kgt98Xj2nSDnRo2JkVxVj2Ohpyp8iD0TuAaagfYWl8Vpcm0Zp14LpNmO1PoKYsyvYx+NhhBMXJxnkZQY6YZC2Y3pFTve+M0BkxWWmNPJOlm0+ttl6bhrDGRGHy0DKZm7vC357o1a26Ly1AMTiv6stlHyGseqABpZvorphe7yuOWKb0bk8G+NuAJNLIpQR0sVCzRb+sGGBZjVDi4nbH1s830j7UFoKU9N/mloZZGVXxrMYUK1CAdJ8Cqrw6kbx3Hb3dk0W+Lz+4WouP63cnzDq/5E0xHh4puO+kxcpsptargEEdOWaElPIIDFt83m8XcVSmPxxTu042wLOPtcmxo4HWDGBaULYHrpSOj9LvppmSZVlnL9P68wMnftrYPHbJMLz7Wb8xjVaZNyVh8REUMJRphw1kxncjE8DsDtR/58zbQ5qALzSkBFWLsBcMOCPy6bcglmkdsEFIq671QkDezxXxa7k8dhaZjepUVX72F/V+MNZTL+TAZsyWgn13oOiFGFs+2n+mAz5pqra7VylJZbjTFPmPih4Zd5IDTJhngef4LrQAnWsSUB90EYj8aDn6U/htmfiEJjnBvjPaDwoAAIBvONlayrkrAsXeXi18tgSwgBNPHb5fRDWP19iUZH2834GSnarVWbnCIoAfs+YVEGYKWHZPRXZOYJOY4HXaepAffrZG6WdO86V4OcSAohC69isYzBWhhUZXLywpykq8xk9OxkK8cdKAITVRua++HJfehtIhUQMUfm2YcKsWHUykj4RlRYqvq/6T2Ul3o5Ji4/qY7rwa/qphZVQ6J/8EV92TdMswBBG
 wdmbNyBk
 5rflYs5Ks6Lw53Sxey1FyGUenl6qJNvXfMVSv22qMpNMsC2sqFnL2HWC2x320lr/GiRVPw7piAvxSLohoWj868McHKJdoAmmIC8I7FJ9EF3IvzXBKBbCgjoCl+IpKmF0KkWBcELkyIQQoLUVwn41F6wTHaIaP314Xca9U8t78qEOuAHR5Ypc01CmFngIk9UykFiMpdpcXmaOJrTbTsn6j4wxGNC0RHiMFTxD+jj+4eC7iiVfcMAF17oxLf3oEU1qqFlkQbgAHGs/tiK+Xhnc1xly4rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 6:05=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
> From: Lance Yang <lance.yang@linux.dev>
>
> mthp_collapse() uses mthp_present_ptes to decide whether a range has
> enough occupied PTEs to try collapse. Swap PTEs accepted by
> collapse_scan_pmd() are counted in unmapped, but are not represented in
> mthp_present_ptes.
>
> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> then checks the PMD-order candidate using the bitmap.
>
> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> handle swap PTEs up to max_ptes_swap.
>
> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> through max_ptes_swap, while lower-order mTHP collapse does not currently
> support non-present PTEs. Keep non-present PTEs out of the lower-order
> eligibility check.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.

Thanks for sending the fixup :)

Acked-by: Nico Pache <npache@redhat.com>

>
> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpB=
kqAZ=3Ds+RHsTUaow@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redh=
at.com/
>
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b12187709f6d..617bca76db49 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_st=
ruct *mm,
>                 nr_occupied_ptes =3D bitmap_weight_from(cc->mthp_present_=
ptes, offset,
>                                                       offset + nr_ptes);
>
> +               /*
> +                * Swap PTEs accepted during the scan are counted in @unm=
apped,
> +                * not in the present-PTE bitmap. Account them for the PM=
D-order
> +                * candidate.
> +                */
> +               if (is_pmd_order(order))
> +                       nr_occupied_ptes +=3D unmapped;
> +
>                 if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
>                         enum scan_result ret;
>
> --
> 2.49.0
>


