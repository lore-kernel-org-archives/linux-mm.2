Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7864C531F9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 06:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D036B007B; Sat, 25 Jul 2026 02:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD8E6B0088; Sat, 25 Jul 2026 02:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC706B008A; Sat, 25 Jul 2026 02:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3A406B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:52:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 183D2160289
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:52:19 +0000 (UTC)
X-FDA: 85026379998.29.45E252E
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 24F42180003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:52:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="sc8QU/lw";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784962337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIF0vEGsWnBmK1bShF4wFVQGIRm6ShQk7Zylhg6SGHk=;
	b=k9YTcm72k6waB8eNVmRPiupCndJyVAS7FjnxLrp15awkqf2MC6xEKIV+TcDJ3q66vZVK2C
	iRZWFYoi4SsG6NNWPXQlAi6OOcRdWAmJkwAnY8QpTND4IeTW60ifxxiXSaj3NZ3Axar/eZ
	BqjpvD5bj7dWt5W4wqbM5oJk+vJLeV8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="sc8QU/lw";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784962337;
	b=eTnwtM1cv1xy80sjcr572cObpp4KWg+XwuML2J3m1359haiAJxW1oK8LDU8XYRT/R3BIhP
	0YZQOOJZQBW8jqSJY2l3FhIH4eAnpi90t13+gB4qkoDSF4jnLuNaIK+WhOyuP46Z6rOiVo
	/hMUuzfIHweyYZVzDnNrt7fYQyohjdk=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so78571cf.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:52:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784962336; cv=none;
        d=google.com; s=arc-20260327;
        b=VP+7PTSUbzo86CzzTe8pUWvKHjg5vWuhXFoAXEAGp496cpf3Yx9T6yucFWIU9lOHrG
         9Pj4K3BkP4TLbDfhHWmmPCC5MP16FNqN9qH9WRCIVkZjrafsLoKrSwQKnZrC7uhH/ve2
         tnnw8RQ2khkuR01s0Eh04M0oKtBwpUXvDLA2unTrxd2dcQVzZZiUV6Ufp34WEeO9z3ho
         UXtm7tH550QdcPef82zwc9oEpQQ2wIsX6LlpnFMrZbtKcNMYy44rJIZh84t+pWvYZJG8
         CMsvoS+gXsO+XcAQYla/V+kBKaJYN4aZu3iipDIz7bV1HL9SoiwjegKJBgkKDRSgKSoG
         MJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QIF0vEGsWnBmK1bShF4wFVQGIRm6ShQk7Zylhg6SGHk=;
        fh=IzpgHfTZpbY7d1dhG8ypeo9jeBVh5ywn1KhHOm/qkjE=;
        b=LXGY1GLLEUZrREfDl5Edgb1FE+1xBVBP5Te7BMp1PsF01dHCh0huvBdbH3iglJScfu
         P3E5BCmiPNxavKXWrVT6G80weU+Wd3GUu9UQ/mhVHI7fhffiniJ8HZK7mvvrcswrms8X
         dM7js/nZBD/5DwLHvL7Nq0zIqEN9XT04ZT+Fe4DbmcgfHoGMPbgmYzMZqMxNHmcDlj9p
         dcgub9YDlk1BuT4rn0cBpJJelmReUQ11dCRm8vlTU16kk3CUf1zrbI3SavPCZdD75o5K
         BTGiSr3iINB/NR60OcTwVs4ukGXA9GMAbdw7O5ATddadQ4alPqxrj10tD1WADqijxCkz
         KThg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784962336; x=1785567136; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QIF0vEGsWnBmK1bShF4wFVQGIRm6ShQk7Zylhg6SGHk=;
        b=sc8QU/lwD8EIrbvR1EdCS9I10++ND/iCetD0Lt5TGcIpD/IrrCRsjRt+NzsaqZ9uzJ
         CKVGaQ47wqwQvcvBOu1dYHmrTKZGF497qLsZnoVWNnafPbb7DprkDPsX3FjZdSq+Zwbf
         eRpw91x9zU2VNbVcZV5J7p9YbeoJsggMZ9a9b03e6daTUy+jglPOHYveNMKU39wdfZct
         rstjbNTm1IYhMqBmVPOl9xAG8p3RO8HBACj8p9jT7+3tlETK8+MMHHhSKBupZRhA+wI2
         aS88Qi7bdonFegD1IM/xcxhiB6P00bV+bR5wBQcciCHHuWbag5XyGT14UKNjR+pU3OQb
         BBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784962336; x=1785567136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIF0vEGsWnBmK1bShF4wFVQGIRm6ShQk7Zylhg6SGHk=;
        b=TCQQY60kISGPqYYfP5cat0m0femWXpCtSHGVkzOCuhJYvu9+HXU7RNhRToZ9ptI/k3
         SkN7oz1Di6Y9jjw+RZBfAKKzWZ2UpX3Si7rQ1GLOCxW4DvdxbIJUfqDuoqI9/kLLdQud
         ZMwxyYdn2DkpdKbZOX/KO0PKDiTP3gjAkacDT1AL30Wjcymn4lYC+zO1VpbzZVYqst8Q
         Jg/Vjld8zQN5waMCHwOjbofbc/ND6SSPJM2BrU9dzfTD+RtQC8CoL8nhketdJNTX/hGQ
         NE6V12k2cbY4aPPHMq1GuNULvpeWBcNb+IZ7TcUziYuNp8N/QCbgV3T9iwEmzaZdooL3
         cNDA==
X-Forwarded-Encrypted: i=1; AHgh+RrFKqd9st9AIbmSpTlyqZ8rkq07DRoH1sOl9EAsLyXI1nh5vUdncGukzfKCMec/f/iJzP0PNyOuCA==@kvack.org
X-Gm-Message-State: AOJu0Yz46KmKLAMdWTQPsimlBtljHjmzhnjUzI/A7mwZoHFiPib8dMbw
	zelbkIEzGMUqKqmtaV3MxhslinfO/JPNVFnTvdGUxj6mhFW1iRcUxCxccR1VyveLyJJC0tZPvwl
	UBkxrMKcoPmAU2pcLFdGVBGH4PLJr7dnxNm0xMlf+
X-Gm-Gg: AR+sD10t1LIA+BDpUadZb35RU+vs9B04xy64lqkr8dXOCSdBJ/1Z/lEnzNPSH7ua5Bw
	y6CtqKWmkJopp3/5UcAaeKqqAB4uTBpzOSTElX8BH8LsYG7JFizuwnsnqUdQZ5l4rTicbbvf9xY
	jSCoTjBkDQo8XhnBI/3ZXy4JWzThFcVlg3q5mK2XKfPRUNvmmWIYAP8c/LB+igUwvUqCOWd6QnH
	C0VT1tS9yCSG1kc7YugjsB4XQhPebp+2f2OuvuCcotvMuEUbYmrghikFGjl13YuXqNPh4vQR7W9
	Venm0O37wVnnnl15G0VbvG/QtDGvABjfFImvMpqXqGybIYCsPw6b9/VEfxCGLaja/XS2jlpx0CX
	mbw==
X-Received: by 2002:ac8:7dcf:0:b0:528:3186:5781 with SMTP id
 d75a77b69052e-529a5f158a7mr10123461cf.6.1784962335627; Fri, 24 Jul 2026
 23:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com> <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
In-Reply-To: <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 24 Jul 2026 23:52:02 -0700
X-Gm-Features: AUfX_mw0SEUss1LFz5gqx-DsCg_k7yOPx4gE_RgrRvqjbHDY08nngfDv8gyR54s
Message-ID: <CACw3F52Q+GBUYbR4yD_n45wPbvSQ+uf5E99_3tBk+D2XGeJ1TA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: William Roche <william.roche@oracle.com>, "David Hildenbrand (Arm)" <david@kernel.org>, linmiaohe@huawei.com, 
	ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 24F42180003
X-Rspamd-Server: rspam01
X-Stat-Signature: 53ubzogqmbpohery5du59ewpqihdjrid
X-HE-Tag: 1784962337-715290
X-HE-Meta: U2FsdGVkX1/PzdVYWM9QExu1+ja8oHLMK/Qh2V4eIyKIB7l7IorQeiaidXlgab33lvcxNql4EHxFTj+rutrK14ZlbbCNvJ+38lT9YpkFcwRmBqOZlIYnClJYRpjS/2kFedm36N+HWU5JDYj5s4Fx9cAQAGpMgq7BXe9GN6Qy7D0+EPNKLGgN46ocAbM81ERunGs4Hku9K93X6LnUBlv0NWWfo6F0GDZxb6DrMtDbAcB08XVVOaRGkMFZ0rNMQRdOLyk6UvskAE5LnAyO4RBtys1LDUzA9ka6WXCUTDu4P+suJ2qfS+eZXmjdS5aPLWqPsmhY+lYr/FTmNto7kPvHr97wxeVi3ey3BrC43IXWpVz49KRzZGRidoR8vDfF/Gxy6n/TZGXIcPHoDe8jcj808EJsKliM+CbMTgC83yzAyD0TU+6DMHYhwC00UQVj8w56XniAMV1uTlje0v5IHWlThxpbRYY2h9dUJlrGYgm2ZooWvm01uMHCB89UtFer16YFOKorsdzh/ZUuq6KTsh0Tiw33+kIlrxIqwYGaHF18NK6CIovLh48d4sm5L+gcULubuZAKST1puMOHr8yJVzSFGKV7rsoXSz8/snVavEDER3XjrMfq8rsptSzEa0Ai5vQe4I2WONeYQDshS96fIuI8q8MYrKohEWydlGhm9Hni27Hu8NlxD5DA72RyZFk/6g4jYsQ7uSphcSNFo2xV1yeQ//ObguPhCwvPyTn14QZ6o+P657ylOMVM6zaKqXVK0HUqdRD82+aCbQBpBuj5TOgqZbFIaW852Ncbm1IzK5RJbqFrM7GE5VYkPSdVjhSbeQGPH2jGsupeivCww5Gf/uZN8D6zCEtiJEDn7Bvk8G02aviM02MOrwChkjUecDVvGSpbUIH9fCyyGJnBwPPOvxE920F9xMnTbamU8ymbpPQbGnKvjZarqhCUNGYCVpAy63721TOONEol/+JwghhgOv2
 WZWL+QCl
 VrOipDFaKTQ/1oYwh+WHOyIAPm8IJA1YwpVXi3weppWJkAH2R40Crv5dgfwfZRjIL61Sm3YbyXx2tSDZkgIlvcdEhCskcezmu2aqIWgL+vyTg5+8BMon0jqqoaY0c5mQ4kR5Kjqu7EeTSOwL+SEHWCupXvzt+/RgV6ZzpXJ2wsJHcxK8Xyoxzxrz3sK/UrwcbrsyFfLdcPxydKB4BLgIkwWgnDi3Lt2Cr4LX+WSWs+zEx5anUZyhYZqdAyFgZWqoRxALf7kr7g9PZl4rX7uA/iKtOmSdNpFfjKCXjAjbSr/AFL/rfvwwjgqBVCzKPOglWgOUw49PLs3fNhEVaPTepkeXSQlbQnygX2GDr/xCue2UuTrvFRCXSwY7MzWbSbD3lJTrC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 1:27=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/17/26 15:06, William Roche wrote:
> > On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
> >> On 7/5/26 20:07, Jiaqi Yan wrote:
> >>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
> >>> folio becomes non-HugeTLB and is released to buddy allocator
> >>> as a high-order folio, e.g. a folio that contains 262144 pages
> >>> if the folio was a 1G HugeTLB hugepage.
> >>>
> >>> This is problematic if the HugeTLB hugepage contained HWPoison
> >>> subpages. In that case, since buddy allocator does not check
> >>> HWPoison for non-zero-order folio, the raw HWPoison page can
> >>> be given out with its buddy page and be re-used by either
> >>> kernel or userspace.
> >>
> >> I still don't like the complexity of this, in particular, as we have d=
ifferent
> >> mechanisms in the page allocator already to try handling this,
> >>
> >> We also do have cases where we set the hwpoison bit, while a page is j=
ust about
> >> to get allocated from the buddy. So before we take it off the buddy, w=
e might
> >> just hand out the page.
> >>
> >> check_new_pages() seems to check for PageHWPoison() and make us not ha=
nd out
> >> such pages. It's guarded by "check_pages" but it seems to do exactly w=
hat we are
> >> looking for, now?
> >
> >
> > Just adding a comment about this aspect:
> > The check_new_pages() mechanism used by the __rmqueue functions should
> > filter these pages out, but this has been disabled by default in 2023
> > with:
> > [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> > https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > So it would need to be enabled back, taking some of the performance hit=
.
> > (and I personally think that it has to be done)
>
> Would it truly fix the issue, or rather there would still be a race windo=
w
> left where we check that there's no hwpoison flag in the re-enabled check=
,
> and only then someone sets it?
>
> Also, can the hardware actually detect a problem with a page that nobody
> accesses? I guess if yes, it's only in some corner cases.

Certain CPU's memory controller supports patrol scrubbing; most the
cases it corrects the correctable errors, and in some cases it signals
uncorrectable error, which could belong to free or allocated page(s).

>
> So I'm wary about penalizing the allocator paths again. If the page is in
> the buddy allocator, shouldn't it be isolated away as part of setting the
> hwpoison? I thought we already did that? So assuming we don't just leave

Yes - if is_free_buddy_page(p), memory_failure() will
take_page_off_buddy(p) after get_hwpoison_page().

> hwpoison pages in the buddy and this is only about some small race window
> where it's being taken away from the buddy? Then the extra check would on=
ly
> make a small window smaller, but is it worth it?

I agree that if we re-enable check_new_pages(), the window will be
smaller; because check_new_pages() can just check HWPoison bit and
don't need to wait for get_hwpoison_page() and take_page_off_buddy().

Worth it? Maybe not. There is still a window between handing out the
page and marking the page HWPoison. For example, when
ghes_do_memory_failure() handles memory error (typically on ARM64), it
either asks current to run memory_failure() when it exits kernel and
returns to userspace, or just queues memory_failure() to some cpu's
kworker thread. check_new_pages() may not even see __PG_HWPOISON if it
is racing against them.

That being said, my patch also won't help the issue above. My point is
if check_new_pages() is expensive but still can't work 100%, maybe not
workth it.

>
> >    A note about the related project:
> > This patch is an addition to the "mm: memfd/hugetlb: introduce
> > memfd-based userspace MFR policy"
> > project -- recycling the impacted hugetlb pages.
> >
> > I do think that "memfd-based userspace MFR policy" is a valuable
> > enhancement, and if the impacted large page can be more easily recycled
> > enabling check_new_pages() it's even better !
> >
> > HTH.
>

