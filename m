Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6250410F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB4F6B008C; Sat, 28 Mar 2026 15:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2756B0095; Sat, 28 Mar 2026 15:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8506B0096; Sat, 28 Mar 2026 15:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC2916B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:09:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52D221A01DE
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:09:49 +0000 (UTC)
X-FDA: 84596411298.22.ABC41A1
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6285AC0004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:09:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aosbYqic;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774724987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfhzOsZFyHHFXU4xG0s+niXh0pPUFPC5R/oCQiT8O+8=;
	b=up79jGblOmRYBjLNndpo6icXHxn3TDUKeNyFbh2KHzuGdbPHWr2rqfPmKm5rMhY99HH3GV
	h93HNMGauR2sOJUZgVwT1Vsa1mbroddh8ycBBMoedikuGg7OyyIBE33K7x7a1eoJduoHS1
	3B9rMSTWwiqEVpw62pEe4Oe4TUB2YlE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774724987; a=rsa-sha256;
	cv=pass;
	b=M22atU1e6w3g/FUaAmaAw4cBeSetJg3TlUwQ/0XZgiuhgbMNznqj6aNnfT4/e+MGs+2tDR
	+MRE3KCygvJQHFzxgyA+JdlLkfuO4jLqfHjERYUtqRYFSK68j97sIWuJkiCyDGJcKCdmNl
	4CPUvxvsV/Z65c2S7YuZieNlpjTn08Q=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aosbYqic;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50b6c45781aso500411cf.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774724986; cv=none;
        d=google.com; s=arc-20240605;
        b=Bh2T7smhFosjbuhS5KIvpoQtlGM371kzFil+ARkpQhs9eBwUgx5YFESRly40SwlXiI
         qMXqy+0tO9X92wSkHQ9eLcqXf0RTbnDIM6kzen+HybrFxkLUtv9noqt5u/FZZusZ0P3/
         mF9BFljNri+U6sSYGTGc6v0vMGncpI0qFCo7o8qWAaT7mM1VuFiFQ9Q+vQHVrVKyrx2U
         v7f2pzMkgkirlu9gWjZ7flq0kRSbfu8V1BlReWYglmiRH3uRiCn1wUPMkqICPXuhzX2x
         dszj8rIqXiCQfbC6/BjDRLtsudPQJ0ZSj9Bs6BF8JQOEsuMZwKDBJVkek6tVnfENZpIY
         csGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YfhzOsZFyHHFXU4xG0s+niXh0pPUFPC5R/oCQiT8O+8=;
        fh=ux3BI9jklNh5mSYyKKXIxz9wCsdpI4i50hDSU3mQbSs=;
        b=lT3jiDHwlFX6xG19gwGHBZKK2tncNHF8bqnm80pIsmIVbXqNGafrjaDmfv7lPHwryA
         sNOfefbJbXgkitZoW+BlFRX9sLGvWVsSUraGZvu1Xz9bpn3qUWFeMy9qY/LXCaaD++Me
         /BC6vm4oaNLXcYNDAzDfklx3mEzvYxEw4XsmApVEOMf4MgQ77tHeSyRxs3CUXmtKnCs5
         jQIe0VxEcFPh/7GwowwjZ0OKarcv7/5vwyzAY4uiuS3+RIM1EissbWL1+bnxRcxNkuue
         bLX+7x7cD22pPjTk5gZX6SLaGa8xlDY35XJeAVZQCX2xmXDUb+ZiCr4QmKA62EtN1ye9
         XBLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774724986; x=1775329786; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfhzOsZFyHHFXU4xG0s+niXh0pPUFPC5R/oCQiT8O+8=;
        b=aosbYqicD66A1cPjbOWWGxN+H1IqRYDNLFxq9jSjJMO0e65XVKho/FK9b1fQQoMwmD
         MurX+SNjcJkX1IubM71XkDxvqS7eI2TBtAkta5hnojQI0+pu7hFoH6uMohb1fu7qrxGY
         6bGB/7Bo8HdWOzXe9baHhnlQkMdKG/gg3UyDMB5GcZzrVO0t13HDLG1Np78kyBGsUvrE
         6njHZWV7z71EVNKfxeFIXk+9YVgvBkN8Wo1XKohdpuRjQphwaQ+DL7GWim24zEXvziXV
         ZQpBECBqJferpnfqDqlL8jmGU3T/ri2ievSRqEM9Duz7HX6rb7l3OrGgx9wJDAO/m3/0
         rXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774724986; x=1775329786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YfhzOsZFyHHFXU4xG0s+niXh0pPUFPC5R/oCQiT8O+8=;
        b=Z8949Q2lzj2L+1EFcq66PSQ8ofzPlX8QoYM+9Jqa43V2zCrPxdHo8/WXAE7HKUB3l8
         ubWaiyiaD92UJw8i2OWoex9v4t76XAanPSrOw/wlRbT+BipkQ6UREGyiYibE1miyVmeD
         KGXjv/HqDyLCeHaY3/2zKAshWzKX3vzNqYNq+L0bU8ExziugMY46v4rhuMY/oDOLrcuV
         hjU1CzOm25d2Yl74IBtsCheXVfuYboXv/clAyDJ/urFdlC57j1VNYESRXM+pzIPAdAyq
         xQbDqzCgGbXykPwEBykMI7lb68GxXXeTwG0PNT8s7WvdIvjRMbd7yR3rzk98Cxf77vte
         7w6A==
X-Forwarded-Encrypted: i=1; AJvYcCWQHboYddsmgLo8DnFNhqK3sgAt0zWHsmf/ZKXx2FvainwzVpkL3T57JestKVZiLpAuSojaX+5W8Q==@kvack.org
X-Gm-Message-State: AOJu0YycofayzL6xSuq71xFGqBesPL4EVO/D2ovjwVB6HD/+0HwlargF
	m6lX8joC6sp4fdkqLnuU5M415L2beojxTVqHpoA8JdDgwJunUelNyDLH1WdIL0wpoL4sMt9wuDI
	pQZPRmXxW0dQPisi5lIqz/atc+NZVB9nGK+cr/Ab+
X-Gm-Gg: ATEYQzxu9cVjRzLuci37DwXvU46JX9A6FQVxp2YZ5HjfxgJlQSdgUGdh7Zg5rDo/QwI
	quti68iAHuYQQSYk4brpj4PlA0LyrpX6Bz2n0QFoWjbyZqleN5kLykP958pg7LxCYNJ0k5OYlZh
	sTS9kTTCz9Yx/nc2tBoXYHtewq1ANFvtMgd+IJhM7QdRw4D68cveB8VpvZvqVHaRPpqrQfoIRnh
	iyOfWBdh1ro+9eoA9Gnxw6AeDnvFCETTlQ47XFXVLTrVN+DSzsg+e2e1rtI3z3uMsJ/Xvu/u1g/
	cyAc/A==
X-Received: by 2002:a05:622a:1c11:b0:50b:bddf:14ee with SMTP id
 d75a77b69052e-50bbddf3d81mr3919091cf.16.1774724986055; Sat, 28 Mar 2026
 12:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <f3fa8eb4634ccb2e78209f570cc1a769a02ce93e.1774029655.git.ljs@kernel.org>
In-Reply-To: <f3fa8eb4634ccb2e78209f570cc1a769a02ce93e.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:09:35 -0700
X-Gm-Features: AQROBzBl9su1vAQBYpP244bM3XgFItdlR0kp8FIyCIhbs5-COOzgNctF8sx1cQc
Message-ID: <CAJuCfpF0bm1zqW+aX8fevfZaqWe96s=XVrPe-i=F-PCUNC+6mw@mail.gmail.com>
Subject: Re: [PATCH v3 06/13] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6285AC0004
X-Stat-Signature: xcqso79eizbfm371nfnp6i9bj1ok6cz7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774724987-199360
X-HE-Meta: U2FsdGVkX18I78uikZ+btRo6d5y7sUXV+hEbevZY20NDd2DrmLqS6nk+5jv8tDjbtQ397TCuFsTF+L/Nz6Mb2F1PBauusYKvnPuChRRsEorMltccTToxroA7yo9XIMJaGyC2BGd69VVmC57PZFe/n3iGbj59LkWCuGnoJuWlJ5wbvrx5aeAEKAoPyd3p4om1Ll+HLmpucLEhaeB8SplaX8jncYYjt6oSl4V+ZY7PW6XhnW6aCzVA/t6HrzCMFH1oEfj4IdCHXn9wHc8R+FuekUSWR1qfsHaDW0BfbuPkpBigJV+XxlwRbFYfJk01uXfqMmRa7HdPHcU/hBYQ6ObP+kgFRg4kYtW8vaZEijnbB7i/xqSE2doXcPDcqTdk/wXRH0ZQD+A3Ls9KxNxfK5PsNBT7WNyMy3JScAxDZVWjXgjMS8qAQhOICClhYmUifn9i6a+syRAyqr266XbnKp/lhE1f5kC6H4KbatbY5wQmTSkZgEuVAPoad9i2KPRx54QzuUzomQrWKGy87vs4FwbBZYQ+LkylF1ezpVcuPjRLWOtrqrot4+dSPJH7FL+CGceNFhToMNi0WoPNIRkHZlwJYR4fbIl86NrNNQ1LFND5snQ3zhEGJQ64zQvo3IoUogHHuGaZK8c7xuC2jJN2S7WnG7B1xva2toYntT/hjaOoxNSgAgB6slRMQb6iEqyvsalITlU+zejt1BEjcnOM0PY6JveJNUcV8XtLWNg2UIsOyS3qYu3cXIOYBCufXfhSNK/qBT0aEfpt44vP8PZzEl71mkWw0MNgUtLoRBO8HAJ0SgrHKjK31zWkInMkk1JVfnGv1/kqrd6YHq5iF2wkwKku7sahFXj/KqKEixtiWyamn2CTBbEVQ2OSxmTJrEeTdcjL4g3D2isGvbPktLm9og77vDNYaZKhWMZ1+hvqknWCom5r3jsljJ127U9NbPQkOoZMe+9H/wg1OoMB32dGIsg
 EcobmTsm
 SV7tc04VgBKaISAOVrBkP3g+OelSOS4YAWGTL02Kbmm9jeT48fCQ7Ku0yxBynfAXFenPj2hFAXX43mVsBkS1kHaWVmVTU1Bt30tYOL0X4PTARVz8TuAO0NIShGQeTrpI3Hf6x8HMo6AGpAdol6pl1x5leqygJnl0ZMVbaGf/TClXsHZqUtp1XMol0EmjrK1nsvmHhpKXKNqmApAcXLMmgqkMIy7OejTreK1Ts5bEorw5+llUq3Rx+OE/MpF83x0gResO69c/UC0ZoFBoQV2Dya8PwW3ncSvsRQqBbtdM1oJr9QyKPptvqiCs0q+tTTxqzuDligaJMHYN043yXUS3wF+zhkz3tkW4UqGu5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> This has been around since the beginnings of the THP implementation.  I
> think we can safely assume that, if we have a THP folio, it will have a
> head page.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b9d9acfef147..4add863cd18f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2375,7 +2375,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>                 folio =3D page_folio(page);
>                 folio_remove_rmap_pmd(folio, page, vma);
>                 WARN_ON_ONCE(folio_mapcount(folio) < 0);
> -               VM_BUG_ON_PAGE(!PageHead(page), page);
>         } else if (pmd_is_valid_softleaf(orig_pmd)) {
>                 const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
>
> --
> 2.53.0
>

