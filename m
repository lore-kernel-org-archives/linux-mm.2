Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C27606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sCHHOD9q
Received: by kanga.kvack.org (Postfix)
	id 4AAB46B05B6; Thu,  5 Nov 2026 19:06:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B8C6B05B7; Thu,  5 Nov 2026 19:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD726B05B8; Thu,  5 Nov 2026 19:06:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAC8D6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:06:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 535681A07A2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:06:30 +0000 (UTC)
X-FDA: 85402752540.25.98F37D0
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A230160002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:06:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sCHHOD9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793923588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGV77BihF2IMnnJ08pah5/5VC5NI2jJ0Ipk5DME+BkA=;
	b=JciaIUByBrOfyALaH3jRcb0/f3CWYvZaKdTGzrwYGnLL704PceUEs/ujMtbGtW/CVzM/9j
	eC0Z+t3YQsA9oM8sLlzh/l0php+G22QWNbDeEinkyVJWZXv1qIQ6zVm6WQqxzcgnanUdEF
	ICyQwv/pCGI4gskMbg6WXQRUMEZO7L0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sCHHOD9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793923588;
	b=mfgnnzs87vkaC3DVpRl2Ccyg+gjgz7IyoxDCS98ozvB/cxs1qNewXUq0vMcAkGFCVRswLt
	F8ltxK+GJ0kQRqF79RYyDYW/3NVk1sNYeuJsbK/7QcOiMsfNqy0PWFInZluwgxDVhtq8wm
	0uvWGlo/sjSixmYDD7OkC61JY5fLErs=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4923176309dso63555f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793923587; cv=none;
        d=google.com; s=arc-20260327;
        b=rKlZ0c1RuZDNKAmiY4oG8fGtMujrVT3jPZRu+OSZ8dTLT+DnT/ql6kSb4Zkjzz1vAN
         r48jrruFHWw3sNop4Yns+yIj1wgSchd2ryzBPEAWc1ls6TfjqySCjaHCutLz7CFRO1/u
         cPaBNI5X22srWQFNw+zTXqaqTacChv1rArr8zGU931rslPs2ItxVp7w0oHyVUebGZSlZ
         G6ttcd0W5454mu6wCqzNaOkqucbdxZi7fHoqezLG3aKB/5AXh0xwhhO+uPUP0wHzND7q
         YpTKjsPW4YYX6pZHmWMH23YHAXH2AMOTbk4jFNYjOW7tmWm25VTkGblZoqfOm4nhrvNU
         MYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wGV77BihF2IMnnJ08pah5/5VC5NI2jJ0Ipk5DME+BkA=;
        fh=QM4d2bcRwPGjeihn+OxkI8wLz5y/NglAzojEYGJgH7E=;
        b=KHCyKuK9yz/hzxDAiFOHttyGlXAqaCnckpyAorP/a+dRqcMSUCNLe5Ngjab7HPKm1k
         5OxD6iZsBxW8jYftPnPDBb62oB5ImF0QATU+oDR7IJo9F+jNhnXgS8BMMy6718ZVmvse
         8TJaDr3QXGQz5Ykb0EVpR158dgepb2to4skKVaGHjXned+Ms3PDSk7nUFZ/SmCADBGd/
         yucdl/yzqGfTmMQ6+QK+d0EbFP8EY6v3G0Kkn7OOszT9xxba4vLAboWySAaNSH7CUxCu
         8gZR/i3pUhGbeTawGbVM4p/vRtCU27F6L9fHufTUw34hgq4C9pHP0NlqIG80I66FOR5u
         yv9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793923587; x=1794528387; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wGV77BihF2IMnnJ08pah5/5VC5NI2jJ0Ipk5DME+BkA=;
        b=sCHHOD9qAjOzFRIDXUyne2X6NIYm+twS6v1kPRdjIHr4blqe8iGtNVXc6uup3ZGBkK
         CskqS0hI1PEl34XqQ6gIofzVPTMngtIrbgOlfh2W3llwLNsFXex4OwKOuB+ZHRUkKQqK
         pocf2kE0ENeL1xlwTe6LvfMyDzFRhGyDxd07IJ+4W26STA5v659qZz29tjGfkI9Ojfcm
         eFx9CQLoU1Hgao08sOtY4YJ3fuhsmvbm8yK16QQ0u8ZpsAJbugVjA1uEH8XPsZHDwaTe
         vyO7H2k3qOfWmDt8r9ILWDZekzdSV+y+QztZuOCqqMJVyBnH4gHYJ54LvlfSKkLa1itZ
         /NgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793923587; x=1794528387;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wGV77BihF2IMnnJ08pah5/5VC5NI2jJ0Ipk5DME+BkA=;
        b=z1YkG4MG2JxOymVianOLD0vsjlEWGdb88AsLzg9+L0eyo28JCEM/WvGR6MsP+9u32l
         OwYPBJl5N8Nk7Euwag6glekFF8bPr+Wp2HSYDEamuT9c58kxRWBo1KOto7kqbEz0H8hS
         N6vGsyabh4H4yXkImS9qX+W0GxEuDgWizVfjGJRg3gRMgIYgCGuRVGv3xyubF8rLzf7y
         asOnamkaeXHbBLUV9h792//Csj4byKnF1dHGB7FZ0RgbCiPe7hxzg87ZQEhC6WJtof9N
         yOFEnkhW2go24Ut+/Ron8Y2Cy3ol7+8iZ4UKrptuEyTqxgFY+CjsJvp8UIgdpkLNv/To
         nsug==
X-Forwarded-Encrypted: i=1; AKwUvBzVViPEtPoHXcY7gU8MO/3fofmWakmJofXV8MXO3sWDAHKZaZcP4Fmj3fxYp7W1svoTlyVYfwgdLA==@kvack.org
X-Gm-Message-State: APuU4Z+kAy2oUefFR5Um1+wGall4oXKH8frs8/DHMDzRc9ABfiDZSvsM
	YH4JtbNVhCl8WoCInuaZFLc7bgLL/Ktc0uTHT3xMLEoUsEQvx1szVP8sFXR/hVNkIOBycsnSgkR
	FOQVrHZxXzhhvgKQeMMa3bQrHqIM7g9w=
X-Gm-Gg: AYBFou1QiYtmxJyPRd/KfpC8rYBIHnF5+2h+CesqzeWv1XsjysmsmlEzyTw+dwvZs4y
	0uFTqjGBjfgLGYPQJtVO+a01Ij8xGne/82gYFrwsZXlxTh5BTdylNEFBROg5l+JOtxd6Ds3Judw
	9uDZJNQTug7a2dwErAjtyE2XffJH91U0GxCWFWI+S6k3+2XljM5oyCMUpSyKA5gCprLCGwZEK2Z
	ANMcp1zO7mp14EFwIhV6xctIkYcdX9nH2PnT0p+x2NfKJIUBOAxtaJEiTCmDlkj08CAkW9bLT0N
	5EDT1VMkAbyeTOQD82CuSg/aVhqGkNL/mAFhwaLM+DBU1Gb57avR12/1ziMRKpWnkLul7IGdVkX
	XvE0Ybz0P/pHIP6lCb9BoaI/KOcyuHtM+8qktXYfaTpptop5cRUryesSh7YCVqT8BfrOz03PaQ6
	z7HhzVeNMJVkhdb8oyRk8JPDbLVD1/cCwtz6u2U2s=
X-Received: by 2002:a05:6000:2405:b0:48e:20ed:d5e7 with SMTP id
 ffacd0b85a97d-49275a2671bmr2095986f8f.34.1793923586804; Thu, 05 Nov 2026
 16:06:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-4-joannelkoong@gmail.com> <a16f1f8e-d3b6-4145-890b-51ce3c0a7f03@linux.dev>
 <aux1p4WFx8SPTYOf@thinkstation>
In-Reply-To: <aux1p4WFx8SPTYOf@thinkstation>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 16:06:15 -0800
X-Gm-Features: AclHuK-o04cYXDzL0E3qtXV-kFT-SXK8az8_V3XZDWIEb3JcTtctnGuB2aRW8yM
Message-ID: <CAJnrk1Y14iYhc7WJ_f_-q+XKXnbn4Nodvb_kQvRvjRJq6yPEog@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for
 underused splits
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, baohua@kernel.org, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A230160002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: g643gbfumyfnc9k9sohc61tz7s65pg4t
X-HE-Tag: 1793923588-980381
X-HE-Meta: U2FsdGVkX18c4Sei85G/cdXCdj+9/JoS9Mr4WE0i/PEFLyzF2q9mMQndFmK2LtjTW0XcGUgu3upB6C4wt8Z4UrW90EiB3TIbuRntdTZBqNrGLq6JHaZG9iZhnBMRDEeraO/eK5bZj1DRteSTccmpUi0c2JIy8yuUnk2zUygMUYUqLw6AfYsHss/hBVEpL7/+awtxBnuD3gZqtHs0zWniiBApOGFyepgNhl7DmfEtQxHWNQmKqoPWfmzweJbWxz4qWDTbbh7Pq8YQ/ITtN7DqrWu9dDOJNIgBuaSATnsf4bWp5SoQ5N8f9I0yV15eKs7ecXiAWBtykBwDvvRtJsYdZAQ/tiAg46MAQjhlpabTb+sp8w5/emXW3y7hSwKNfQcNZIikUDOFUBSss0tGHlZ6lNU7eBoT0t7M7q50x91LPScFEhpoYnko1MBeWTjZAZ5eTze9Nn9/UXHqKw6101+KHLfRjt5YWjQ2cnFhjE4YqLlF89ZwYUiT+m6tE6FQLlmdUR6qBg+7yPHyvbawBZ1XUkJ/41q6KPHIj2cwGSaNldtWLa1FIhsTJU99Zta0oNc9TCMwdCnvQ6Vn7JrYON10dnTcqWNQQUq+hNwdCu5LMqoV/djYl5iB41lkzMTExhB8S01QI5cpVRblxhvZpmDFDjFyW/37aI+LdGTThSRRQtL//z3qLYL8ENkDKXQ/rFVgFx9w7wIEHCSCDzgOW7lOl7euLdDtzdXvSovWdh8Mc7LI/u0gDD+PADRr3DaQq4/J8F3B6lvOqD4TKC8EjuW5TgDWS0bp/zGRlvmwIQUG28XnZcXgPfMCaPWEC2SKfkX+56SPmcyrHq3hXmITz16Y7BNTDngHp45z2yUjqx79ZryFoRUAmNv3If5b0ClrVCHhCwdiRXcHkC5Y6nNvauucLsDJNsIfIyl9XXrHEui5phfJ7JN6BAkW2PKoIU7OwmVrGX2Jyruzjv26SRH9PdZ
 DCuAfcFD
 mN/bPnurtAAWrG7chSvTWGe60MdIVdsxnzwqDDUIJwRPEHpONCn6+jZf0cobDGx0e9y7O+fGB3fkr3rYWm+d1bkcedw2EC25D1uFnoFSG2WoyELDCE68kHYKv7q/cCjqJiQcHF6ho81k1n9biWjmywJZcj8e5WRFktwVef5EFTPxGLRWjgZI4wXAxyN0d2ZFRArdwsrAOU6Qn5miigbbwT5VBufVZgX6QyeP8PsR8pneLURukRX5xVyIAqyMndzNTswhlRJpGyG6ZGDDL46jicMoUUXmtAHHSc4hexax/gMxzFHoo5BI8shNsDqkROpg/09zo0GWpIEl9B71YOJJSSA5WyOulFyJ4n1fojNFdAGmoloV+gBavH2PtppmkB0KaFsabdYEvAWjQl1DW1bzQkon5bS3nas+j9XMfX12UJJz07JDPc8VvQGpB2KiUdwaEQYsWVcx1O3GG1P8QGiS9ZRNvzztwH4LDMkFX5NsnznebyxLVoNwRWH0dQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 4:26=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wro=
te:
>
> On Tue, Nov 03, 2026 at 10:20:43PM +0000, Usama Arif wrote:
> >
> >
> > On 03/11/2026 21:20, Joanne Koong wrote:
> > > thp_underused_split_page counts every folio that the deferred split
> > > shrinker splits for being underused. Today that is only ever a
> > > PMD-sized folio, but a later patch queues anonymous mTHP folios for
> > > underused splitting too, at which point this counter would start
> > > counting mTHP splits as well.
> > >
> > > thp_underused_split_page could then end up larger than thp_split_page=
,
> > > and there would be no per-order count of underused splits. That doesn=
't
> > > match how the other THP split stats work. In /proc/vmstat,
> > > thp_split_page and thp_deferred_split_page only count PMD-sized folio=
s.
> > > Splits of every size, PMD included, are counted per order in the spli=
t
> > > and split_deferred stats under hugepages-<size>/stats/.
> > >
> > > Do the same for underused splits. Only count PMD-sized folios in
> > > thp_underused_split_page, and add a per-order split_underused stat th=
at
> > > counts underused splits of every size. The folio's order has to be re=
ad
> > > before splitting it, since the folio is no longer large once the spli=
t
> > > succeeds.
> > >
> > > There is no functional change to thp_underused_split_page yet, as onl=
y
> > > PMD-sized folios are split for being underused today.
> > >
> > > Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  Documentation/admin-guide/mm/transhuge.rst |  6 ++++++
> > >  include/linux/huge_mm.h                    |  1 +
> > >  mm/huge_memory.c                           | 10 ++++++++--
> > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentati=
on/admin-guide/mm/transhuge.rst
> > > index b187d618452f..6f2d92a2a556 100644
> > > --- a/Documentation/admin-guide/mm/transhuge.rst
> > > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > > @@ -719,6 +719,12 @@ split_deferred
> > >          it would free up some memory. Pages on split queue are going=
 to
> > >          be split under memory pressure, if splitting is possible.
> > >
> >
> > In this same commit, would you mind also doing s/THP/PMD mapped THP/ in
> > thp_underused_split_page section in /proc/vmstat section?
>
> PMD-size, not PMD-mapped. But yes, it would be nice to update.
>
> With that updated, feel free to use my
>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>

I will make this update for v5. Thanks for reviewing this series,
Usama and Kiryl.
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

