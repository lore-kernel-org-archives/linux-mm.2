Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A262BCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509786B008A; Thu,  8 Oct 2026 08:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E15D6B008C; Thu,  8 Oct 2026 08:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7716B0092; Thu,  8 Oct 2026 08:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 114936B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:24:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CA59A77F5
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:24:20 +0000 (UTC)
X-FDA: 85299376680.04.4326871
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF8ED40006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:24:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IjTl1Efi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791462257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdN/ld/AbgWnU+J2IJ+8WIKRUkA1oNzEzQLUAiamey4=;
	b=FKkRbsBm3tk3pKOdsVGo2YY+4swu16pwqkkBJnrN/YNvSQw60DKPi0iZzXXhf/Vf8MmEVf
	Ug2G3Sh7kkYJSvgtVd9juUz2bwjWt6KSunS8X5C62lu+ImeaFRvIUXFMBxW/Pe4blbC1hv
	6eZQbdtU2/xjF4D62qSp7jIBCZ5Asy8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IjTl1Efi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791462257;
	b=3kXy/9757YE20ZyiOqxCj0Ts4sgxR7iyZWVzcIhi+ZrYLqeOLddFmksqrptq+rQOvxoeBU
	5hKVV14nUPZOmzaTOMod49mI5pqjeQOdXI1nv53VC6UiGPkf2ggAaXA0raYXiadUvZ6EXR
	a4vCKEyd5t2AY1KNQoSsvjSOYyaFcTs=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6afb0d2a586so5546074a12.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 05:24:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791462256; cv=none;
        d=google.com; s=arc-20260327;
        b=LL9KSdT4t+TiGqkJArjH4oANosNg1HJO+QXYMbLv5eNnPeXUVQ++otbMu0VP3jfhP3
         FLcDIIpsB67zFsk19hOnxCJ/vf6hEzDolt2cHbSSF6UzzbdaJ+cLZtPvMr9eKPONredn
         umMw9eAntHwQ7Maojiy1g+herYbdudp+S6/hvsMTZ+z7PSGGE/3m+OIqTo5WFQluMV5Q
         ughgOMsc8Z/7ePW8OGgzs1S4CmQrLgHqea8uhrUU6icgWKOSkVektoltC8ZWVR+nETEk
         UDEC9p8lEXkto81DLrrdmjZM8BRhmHn3CwlPOx3ECOCnTnGUqDvPAuf+VDs19lv/FIE1
         i+gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TdN/ld/AbgWnU+J2IJ+8WIKRUkA1oNzEzQLUAiamey4=;
        fh=Qb0VRbN03jyek54EH2O5QfsGxb+7w77zDodoajdIzQw=;
        b=K7dGJJ89eZfBt7qgB/h6485m99f9faB/FO2yi74FI70sf4YoJwb1CxafjCtYavcdoA
         zSRx+bFqGYO6E2doEjd7DVJRZibBChzhNygb3Ul+CmaoBtMAtf75r/Lexz7pnv4o9Z6X
         4qCDcxF7VqUizeMCio2hsIdKBzy8EXse2U9lJlqRv82FIyqJj0C29UqU4WEcydo3mzOx
         MyCM57Y1i58f3JXiFrm8oNr39x2eGzqKccfslUfJAtxs1emDF/MmHqUyE4LCxifE83DU
         2NwPuuSe2MGupRYc1egyqSDQzCIphHSRVZarpBAi85G8FVgYa5VMBzAZS9xtlmtodyRg
         MM4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791462256; x=1792067056; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TdN/ld/AbgWnU+J2IJ+8WIKRUkA1oNzEzQLUAiamey4=;
        b=IjTl1EfiVo9sHlXMlsVY0+SciRz/Jy/EnbCitNErKgSZsrb3Y2/oFdMHKLi1mvOE76
         sIwzrEuYVW9z5okITxICxocwq+Y3e5N7s/kUpp6Zim3PU5J/qh9fRhWIGlKQTbicNTC7
         6bDW7pJFmCTh3WMUr/J0UziYKWAEJClDabqoX5XTgLQ3nDpu12QY1tw9qd5vM0qQVyC5
         9jQuh1x+jdRD4TRq8XjP0IkKAUZMCEy9+9wfbah8FD8HVjiQmSvQvrxzcJ2IFS0TYKGC
         kAKHqXq+vr4HDolEwSWfuWa4rhiWnDUJZnvZ1tJDkvSrSUp6fieAjVXmgy4eB1H1F8Ba
         B+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791462256; x=1792067056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TdN/ld/AbgWnU+J2IJ+8WIKRUkA1oNzEzQLUAiamey4=;
        b=izTZiwBF8atO+6IMlLSluzJ+iwB/rPlE3LpGClyAbomNr5qJ8uyeb6ZGYKuzaY9Z0J
         ltedxTH6pxJN+7vk9mfcQinMvCGplNvtxw91NHe2j3XF7SqGYscHRepHOeJzBabAqaE1
         qWha+eb3DApcPjdE/Ns1zHj8GibqUzihLybfbgGR9cHaHWl3O0BE7oyBeULQCGyuF7Al
         x87KN3vt02Z4IWdeyB7sQFZ7Tm+CR4ZCIyTwuvXRL1PJzB52nAnc7lhm6OJWpERdrjVC
         GTIjslnQyTvGp/EHUiPcnG/nfa0zWKfYcBIAuzjOE/LSLiCS8lXYIJZ0qSVZtwZC3BAe
         1udw==
X-Forwarded-Encrypted: i=1; AKwUvBz5yLDk19NIIROBaUXG1ESCn565s0C87kGGEafT3KyZ5V9sSKd1zFD7IgF5rKkWWyqQqIa+cu/Uxg==@kvack.org
X-Gm-Message-State: AFq9FYJU0C4oZLsoVwSpv4p0Qs/UfDooGr2PO6eOJR57tyShnZUrzwV/
	2Lm0egY8xeYgfrwg1lEQVoaHkyPoWJj3Dr8hUs+tJH8rIA74i1l9BwVIog99iPSG5E2D9Nar7o1
	SaMWyfSAp9e/iznc8Tef/qBvnmIIVMWA=
X-Gm-Gg: AYBFou2SVfn6b98iKAK4XGuS/5d7KXXfbUDuZ0xLgtJ6LnOY2bHob4331MfAvNtudGP
	M7sqHU7VoBphvgLRNpN+TieXnULGDx7ryLITL6pDgcA85jWPfWf5apbUgY7v7IqociAvsiBq9vH
	vXs1VBU+rRm1QlYJI8yVeHQ7XaMQ+BZ383T04d/Q4TaPUNILhxl57iUk6yxgmepWeotSMB1n9Ga
	/057AMSW6jfEmq6IB5N/jh2NHRJjcTqo6iKLIVOJw96a7G98oDb5rH2I1z1LiiybrHSEc/cZsWS
	VAV/mtx4cvbutEJnoot/SzYqbZe7akuZ8Qp6jPBYVBgYF86Z4xqJwkF5NeoccxBZ5MjECfelr1j
	b5UlpOI5sgZI=
X-Received: by 2002:a17:907:961e:b0:c2a:34fe:ea4d with SMTP id
 a640c23a62f3a-c317c0b85e3mr488492566b.25.1791462256420; Thu, 08 Oct 2026
 05:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <20261003054216.9155-1-baohua@kernel.org> <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
 <asd-8uoATmpH9YN9@KASONG-MC4> <CAMgjq7DR6h6GTKASQo_fHx1hyzw_zJZ1OHP-dzy3RDcTcZJUxQ@mail.gmail.com>
In-Reply-To: <CAMgjq7DR6h6GTKASQo_fHx1hyzw_zJZ1OHP-dzy3RDcTcZJUxQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 8 Oct 2026 14:23:38 +0200
X-Gm-Features: AclHuK8Id2jr9EJXBc0FHR6OjcQEMM_YAEkuORNyeyWf63B2XBeG9-XWpowGFyo
Message-ID: <CAMgjq7AOhDkuZZnWrGDguMvNtarZ7s0Ouzs1xYi2O4AkPEPbTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during
 retrying missed rotated folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu.xie@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	chenridong@xiaomi.com, Yu Zhao <yuzhao@google.com>, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF8ED40006
X-Rspam-User: 
X-Stat-Signature: nwgaapx3knahe6mijy4yqdq9gu7ccuob
X-HE-Tag: 1791462257-436512
X-HE-Meta: U2FsdGVkX1+/7wfIMwZ+tC90o6LjdVVAt5OeXA1suPsan3xuG+9TeOrPqQh6UWopDba4CuwORt3khQ4SkyRouesyRDazvfy/nx9b4FvhCS4hjTqCzkB2F3RH/E/CmZCz3798BSdDzgs/F+OZDBRet1jEiQTvoHspA5GA9/FEGMJ4OO7Mm3J3ZtC1AaembNWawWQ/QIOxpMZy9HbTa0/IuJrbtN6dMI4D5QQivnTLawWkA3Lke8/5q8REzMH1lKQky/Wq5cUXKlcIVycloXwFEh39QiHTHn1N3IewRjM8/1KbBWfDDeo7+P2r/KDEFedIvGDNJH/QI4SdHSIJvlV5pixZ7YFX9vaMXtX9PdwXgAdNphR2xVLucc2EbcPg7FFcz8tHEW4/ThcoUGpkgm31JMHK/MdASKIG7JZCMjf1WqhCUHmMXmRGcwU0ojZyNfU8pd7UQo5GJEw9MGn7mW0KgHT7YGSwfvVEZnNLZsdNS0u0SRHaxgTUoT4OEIJSUttLQbecWYnRUX6asN9AzibgtYuxpON57ggXmetYPiKxJqNrRHVyfQNhsgaU7GNrRbSb6w0JpY6bzVyz7gj7TzoRdhtafJOTjpYdRc9uJ6NWI1s2KyBAm9HUwuIqBNsHi/fhv2hpnEqarNOjHpjmICB0SHKWuiu6hNSZm4N5MUMFHdq9Dpvxby4vaXUNJ49/5gFClIpqxFZrzafkry+xcJ3sNGl+Gy+TZpMZoMO9YAjJg8Rt3jiSZoRxec0O1Ld6CW6/qY+gbVg1zFBbde+BKRM1Dj18CzsVZuk6nuaT6Ad3dAZTOrplcA9eYG4Px0l2a6UU89XSUNWWnJuNnhhs+/N2HE7ehYe68fCfdrOGYp7vUxtuFpYumo+aGJiZtCg2AdSy+qwt+PrKrhwZJQTTbqlz4GYmoO9b5yKNC+63ZZ2Ga8MFOVb3Yo3ecfTNhZJQrpWHw2Kcg2G5fniXS2+Cpfq
 xCtMtF/6
 OEiU2iOkLfeger0DHIqbzczKEaQDWJwCfADLYMLQehBU15FZzPC+srmRFqaYKIbca2GLqGK5za0hwHNS6tYA3oKQieHh93hotRRgTAUJFMytTb3gyy1VrWrbmV4uR0KpAIVtOzRkyCzUH9OyRJwBKTgpT4dSAlfRT9GLv1OcotvFHVeNtgW82oP6b7BOtekAwxVeB3gMxr/7wEjDr6/Z25qBBByAYKlT6YdOktBT03PvEbxmVU6MhAyLoEHNejRN1G9TCr1BqFOA275rgL6bQuyNhQoxyJkXTtl5s6ZLNO6eUFIKfC2mUzJ+eIRLz4gksqFkb0uiVFEdd/l+lzUUrIdlX42/Mb3LbcJL9pyvNw5aT5DmAPtCTQYG19WVUi1/l+vL+zSgxNF7bcKCRFODKvnvQyWYPTWgS17jmRWG99QA9RqusTi0lT5TpjFLGcGtwyVZ2Bd06gwtRuPEYTE6q6UJZpNvXe6s19sTN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 1:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Thu, Oct 8, 2026 at 1:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> > It definatly helps, check this one:
> > https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-4-cbd4546a5bd9@te=
ncent.com/
> >
> > folio_inc_lru_refs and variants will promote the folios in a consistent=
 way.
> > See "First access only defers eviction from the oldest gen" part, I bel=
ieve
> > that is the issue you worries about?
> >
> > BTW promote then to newest gen directly does over protect them, I've se=
e
> > regression with that.
> >
> > >
> > > Perhaps at least for anonymous pages, if the referenced flag is set, =
we
> > > should return FOLIOREF_KEEP to give it another scan chance.
> >
> > No I think we really shouldn't do that, it will over protect single use=
d
> > folios. Promoting them to second newest gen or second oldest gen seems
> > a good idea and similiar to CLRU, and this is the behavior of MGLRU-FG.
>
> Oh I also mean that protecting them by lookaround / walking, and not
> at eviction seems better? As the rmap here have higher overhead and
> can see stall hotness info.

I also found this seems to work much better too on top of MGLRU-FG v3:
Will send a V4 later, the tricky part here is that oldest gen could be
very short so it should cover second oldest gen as well. And swap
readaheads are mostly unreferenced.

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index e651f60cb914..7fb9c7e85732 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -311,6 +311,13 @@ static inline int folio_lru_gen(const struct folio *fo=
lio)
        return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }

+static inline bool lru_gen_is_old(unsigned long max_seq, int gen)
+{
+       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
+       /* see the comment on MIN_NR_GENS */
+       return gen =3D=3D lru_gen_from_seq(max_seq) || gen =3D=3D
lru_gen_from_seq(max_seq - 1);
+}
+
 static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
                struct folio *folio, int old_gen, int new_gen)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5892be56b617..8514182b92b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1011,7 +1011,7 @@ void folio_inc_lru_refs(struct folio *folio,
unsigned int flags)
                            flags & (LRU_REF_EXEC | LRU_REF_FORCE))
                                gen =3D max_gen;
                        /* First access only defers eviction from the
oldest gen */
-                       else if (old_gen =3D=3D min_gen)
+                       else if (lru_gen_is_old(max_seq, gen))
                                gen =3D (old_gen + 1) % MAX_NR_GENS;
                        refs =3D min(refs, LRU_REFS_PROTECTED);
                } else if (refs > LRU_REFS_MAX) {
@@ -1132,7 +1132,7 @@ static int folio_inc_lru_refs_walk(struct folio
*folio, struct lruvec *lruvec,
                        if (refs > LRU_REFS_REFERENCED ||
is_exec_file_folio(folio, vma_flags))
                                *new_gen =3D max_gen;
                        /* First access only defers eviction from the
oldest gen */
-                       else if (old_gen =3D=3D min_gen)
+                       else if (lru_gen_is_old(max_seq, gen))
                                *new_gen =3D (old_gen + 1) % MAX_NR_GENS;
                        else
                                *new_gen =3D old_gen;

