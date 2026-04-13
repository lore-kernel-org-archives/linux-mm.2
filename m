Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEF1E93808
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 01:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12106B0089; Sun, 12 Apr 2026 21:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3826B008A; Sun, 12 Apr 2026 21:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1D76B0092; Sun, 12 Apr 2026 21:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADA546B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 21:38:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B97E8C43B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:38:55 +0000 (UTC)
X-FDA: 84651823830.01.9517FC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0300A100002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:38:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MwI2+FSc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776044333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/LczZPV43VeCs6q1pNCwBA1d/W1p8xMLArqty6Nu4c=;
	b=7X9g/FSYTuCTXkisbI2C31lY+QXdK87lQ2cZY6dcu97SYuTQv0RzGW5WL8x1Z0bxZXlBBT
	bi5f7Spj6rqNkVtW56Hasr5ecKirSBbseBbdy60Eb/xu0Ne1oTx3kcUHfVGJNpxc8kwGKh
	P+xl+CAfnNvMV1w9kWuIfP1RYLmlksQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776044333; a=rsa-sha256;
	cv=none;
	b=q8E518oVTXwGELCRZcB+aCxdyds5a7fT+os/cM81oFEcS7fyQ9gncvGU49c1xYbSeecT+M
	T0uDgk5/LmWZKAEvTg3IjLRPdgeV45NYGfKaqdtUvHf0oKV8sFaFpibScG9NFjmsCcancd
	91LGdFTdl7UEvpYGLaMDzohs+tqC3Yc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MwI2+FSc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776044332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/LczZPV43VeCs6q1pNCwBA1d/W1p8xMLArqty6Nu4c=;
	b=MwI2+FScWekLMA72L/KN3PUrP1U0loOHPyDhCbyFGG4OvsM5RD7+eDzidiUBurHGH7D/TI
	WSigbJ+rqY6/a4n2UnREGQ9J/a+eKDPKxv9EIG6XUH/4dP03I/SOC7WHuf5cejWzXPtde8
	GWxiCTtJI7PlFWrBTfVIMrZkWCHSO9I=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-VXBAAjqKM0uaCGyGcy02bw-1; Sun, 12 Apr 2026 21:38:51 -0400
X-MC-Unique: VXBAAjqKM0uaCGyGcy02bw-1
X-Mimecast-MFC-AGG-ID: VXBAAjqKM0uaCGyGcy02bw_1776044330
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7b3635ae134so6085217b3.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776044330; x=1776649130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U/LczZPV43VeCs6q1pNCwBA1d/W1p8xMLArqty6Nu4c=;
        b=E3lQXkDVLcDrwUrRsliEQ4zyaI7ehHtzxmXIdbHenFS7tyOBXd5b4sA2NYO9ZJnw7b
         z9WoqJJ0xY3btpdwO9YFz9Yf5ZL8OGcar2kr/xnucwIs3BR/pQRcmvXkqRo1+zH4z4yR
         3z9KQi3Xxt/Kng5hIO04y3q3fOBCGma472kbmKXBaUke2c19QbXEvp6PusbBcAr1wJOH
         EMYw3RPbX/QLgwd8wAeEsPhvbwtcHANkHGrQhXtOiRNj4E8thF91Y1fJqmrGwLDDvl/4
         IEY4xqJl8RR6v8uq8umZtsPdIrNp/oq/M+psg8A07oHi3QaSVCzUeq4xEYe/T9Ym7/NV
         kfrw==
X-Forwarded-Encrypted: i=1; AFNElJ+CYJ6z15n1fyAeufzxGWshYf2EUZ4uv+P+8R9UQwAt74AZ9w07ITQdlBjh9fY5D8mvkN8aZIHlbg==@kvack.org
X-Gm-Message-State: AOJu0YwcYKjM+H8Iv0ExoDQiegHPU63QNiNlvWc2leGt8iRU2JWlmu02
	blHYZgBtoPLyDu8alDEeaJLoCc7J1e56tkqxCCyXFlwMyKSvXcpEdvXF18I5vER+RwvxfL/WNdz
	YC53alsHCOh7EcKjs7N6ROyY/AgPUBTJGwrPq9hdJuZ3emXja5nOWa8d48dqHEgWjvSLzWkOMDN
	ozVbfI7gHuoa2a3/kc4LZmFU0YRRs=
X-Gm-Gg: AeBDiesXHujmyAf9daF5SsSkLRTgNdRabJk3T7MjKXGenxd5j0f9PaIkxrYLHhh94tx
	+BBwC5D+rYy6QUSEN4PkYcrZaNkvEpMibFMT0mpMO9kXFz1mIo1I+NY8pxQEROq/Mx0eAks3ayc
	DmB6TRssI/Ywr6SbipwN7pVPASrnnA7k9be+EG0KEkdao0nTEfCERkEF+jwOlyzBW8MDoFtEloO
	Wg6/g/Q
X-Received: by 2002:a05:690c:6987:b0:7b3:edc7:9b8f with SMTP id 00721157ae682-7b3edc7b61cmr1319657b3.0.1776044330382;
        Sun, 12 Apr 2026 18:38:50 -0700 (PDT)
X-Received: by 2002:a05:690c:6987:b0:7b3:edc7:9b8f with SMTP id
 00721157ae682-7b3edc7b61cmr1318877b3.0.1776044329838; Sun, 12 Apr 2026
 18:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260226031741.230674-1-npache@redhat.com> <20260226032445.233437-1-npache@redhat.com>
 <94290ad5-f63d-4fa7-a898-dcfe6cd9998b@kernel.org>
In-Reply-To: <94290ad5-f63d-4fa7-a898-dcfe6cd9998b@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Sun, 12 Apr 2026 19:38:41 -0600
X-Gm-Features: AQROBzArl5XlylTlxjRxCzhfJiWfRtUhtNUooNt0wkSwTm8sXKprqqkTO6ix5Ns
Message-ID: <CAA1CXcDnz_7+16sDVbGJ2ZZPWxs7ta_Z0YU6x1dUe7yiSJ3OKg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v15 06/13] mm/khugepaged: skip collapsing mTHP
 to smaller orders
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NzzAQFcgEDOuiQYQrfVjMA3vElS8en8XFEWHEA7oJc0_1776044330
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0300A100002
X-Stat-Signature: zdhk45knu475a9sib5q4a4963anpnyz3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776044332-128279
X-HE-Meta: U2FsdGVkX185FrsDeBSnz31Mqv06cMgn7UC5fyvwpSE6CifI23l6bw5VoymkA9n1aQzfizpqaphWkredWX3OxVtb/QQjxyMr5e51hzgzS8McoW+Dyumc+Tu3MK5h3xh6rBag6t5cKdPkfRGD8L4+/mmLtEKaybl4T1fIP3velR70IBydTeeu7gNedmVQHx9yNgXmkN8q+Yx+tJaov5dZ4cxI1t3BZuStzUfc+a85dCvsZz1DPAGuhJ62m51FbhmVYu0JsTd1Q3bWzzuEI22HEwZKtKoExVQBBVBFPUUlIVUmq+06VJ7zNmLYzaM2za9SpFHDOWAjcxTCyhXd49PR7L6nGrVVOoC8ctU/gNgEMh3dI6gFCf1WticytH4u02NwX7fSTaCPITAAYd3DFWx/q8bBY+dY+0ZrNceAAtiQNtBZBsg2vGAVGC3IKUTyzyVHIc8iicD/JiOa6bL8u0o1WWxDdpaPg/CpM14RsKR5SXTPp6BuUg9dRF8HvZlp8xjN7kVz2hlfs0fBaCPy8TskpZGvv2ZU9fAm1rH50JfeDxxPMmFi2uT6wJBGOWuxbNudTKGRQsS+kDkSad1PgU9OWbLPDfEhaKzfdUkgULg2fEOE/SA1FytZ2pD//Fm2jrwpizhmuI4I7lsw1L6eFSWwJhw9O7F5FLFiZFhNZxKKom0pK7HB4Jmnh+pj7RiZXyTJX1evM7K3XPtNNssa7Eqonh5CSkd4Dpj0g2XEPbl6+UCBLliuq8GvNuSaCCDea99sjy1XpZShZbaXyVv7c7MMq1dE3TtojXw4iy1zlEgJaJy3SoW2loFpKDYPUFz8ZJ2otPSYUAF5nyJCtWYx6MFoeVND52EWdOtZV9Y2AeX9NhvoHQoZ5ECJSNTDGxCoBPjthHzhrwMWHCGJBMAw+d27vEbXy/BE0QhJT66B+vlgSylusd5ko4DAKjCsxcnFjy7oyeNcSE1IGIJhwZJVW1v
 FVPzeQII
 a0u+0M5GjJIEyZs+M4MOIlw35llE5gwRwIxICPCTrljd+WHKqV4KQB6SGeNRSfCvGguJmz1C+31V6miWntwuzLEp1WVUvUq9dAQHp/GU6uANOBk8pFtisEfjKCTLdt8XXJyVJMX8Ijbv2iaMHzai89HK1T596O5FDIp7GE+gH8Zpm7nwmM83o6XLuJem/vTJlnLp4w0qWnvkPhKftj0xXinFpJUM1XcRCZprUKvWOfClSYw0+0XFcQhY5gzz4q0j06WBxI6Lh+Wr+vpyK5+bGcRjQMbAttqezIE93qXwp2H18vPH3fqvr89uiscnFhhaA+YA1DqkKRAfE8PAPKkLIeQXqXuYwq1PX7IXEJEbEJVgtlZn2rsiB4fZh+hwxidxCXHZWCyDG7vWaEcXzXkC/EgDdVddZKJ1hCZKdhnq8po1+f8+1qQcR8yELo961C2OFovwnkUxcjAMEJ9CeXpnXn+xQId04EZFWuUiof4BC42dtevMPim1GG/4Zn+myjUmX/bMaR9yAEy8staB9Ot5JpfeM9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 3:00=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 04:24, Nico Pache wrote:
> > khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
> > some pages being unmapped. Skip these cases until we have a way to chec=
k
> > if its ok to collapse to a smaller mTHP size (like in the case of a
> > partially mapped folio).
> >
> > This patch is inspired by Dev Jain's work on khugepaged mTHP support [1=
].
> >
> > [1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.c=
om/
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fb3ba8fe5a6c..c739f26dd61e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -638,6 +638,14 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >                               goto out;
> >                       }
> >               }
> > +             /*
> > +              * TODO: In some cases of partially-mapped folios, we'd a=
ctually
> > +              * want to collapse.
> > +              */
> > +             if (!is_pmd_order(order) && folio_order(folio) >=3D order=
) {
> > +                     result =3D SCAN_PTE_MAPPED_HUGEPAGE;
> > +                     goto out;
> > +             }
> >
> >               if (folio_test_large(folio)) {
> >                       struct folio *f;
>
> Why aren't we doing the same in hpage_collapse_scan_pmd() ?

We can't do this in the scan phase because we are not yet aware of the
order we want to collapse to.

The scan phase builds the bitmap (if mthp sizes are enabled). I tried
to think if there were any similar checks we could perform; the only
one that came to mind is whether the current folio size exceeds the
highest enabled folio size. Is that worth checking?

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


