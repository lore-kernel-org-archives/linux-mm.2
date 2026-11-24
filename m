Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AFE606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PO4kNv6Z
Received: by kanga.kvack.org (Postfix)
	id A7BC96B07C9; Tue, 24 Nov 2026 11:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54686B07CB; Tue, 24 Nov 2026 11:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969BD6B07CC; Tue, 24 Nov 2026 11:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF3C6B07C9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:55:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0857480BC7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:55:21 +0000 (UTC)
X-FDA: 85470613242.17.11135AD
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F27440018
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:55:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PO4kNv6Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3dcEFawoKCG4VfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3dcEFawoKCG4VfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539319;
	b=jWD6WovuJhtYrLlxN40joq/D1t7ji6ReSxXmF0SItjg42HT1HWYG3U/y27erT2by16lfDZ
	HemZlnG70R4A9FDU0x03bYoMQa19b4Vg2918XTneAYQLC6C7wAyTKylkzurNyoEwGtDX2z
	z0fDoLTKNfxNvAsFPp2Aeze9jYR6IeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZloecugQSPG+AdwTqsdlH4NBljJ9G+FtiQW0vi3A98=;
	b=RvNH9pFFq05MKYtRjDVYoGrNUVM68wO/t1FiiegP+si2EznavEaCRMLOAdbGIG2H/FfVT6
	9VFmPE9og0LUuWqmYBadex+3z/r86QwJacpAzVJrhvKM3XWtb0b+YxIHJ3bO1IEbM3k1Pq
	XHJJ47BzRk0exffPlD5OFAu+AAnTPko=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PO4kNv6Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3dcEFawoKCG4VfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3dcEFawoKCG4VfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2f0381f07a0so49756505ad.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795539318; x=1796144118; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xZloecugQSPG+AdwTqsdlH4NBljJ9G+FtiQW0vi3A98=;
        b=PO4kNv6ZqIZ2fc4S7O6WpAYXlirp6XMSAUt3DaruiXU7xmqjiDY6nsMisk2SvFb0Or
         f+LElJVBDm2yiUqNnTNB/S5jy0OGQpGJrsglSLDdActZKvBm4/qgCJ6M+JolEW9cAzgb
         W0xWYRhP+e8O6r0xiG47ZxtG28VoVPSgxYgJ/eos3DHN3cO6iDDumYqadRilY6d+05kp
         W3l0uk0aMx2ljDLyYIo0VniHPoiSlRUqOQs6xjQ18hOZsQyMu2+XJNZePvlFZNrAzfQL
         t9FV2hsLZMDSPEG43BXNCTE3B8EfJxmbEU0VKuRbYDG0Pgfk6qCYqbkWvNKIY6If8WOs
         0k6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795539318; x=1796144118;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xZloecugQSPG+AdwTqsdlH4NBljJ9G+FtiQW0vi3A98=;
        b=FO0Sg5qYvBHk7soKBAYt51qUjK6bOs3fYccUMZrgUMK55nGTN+iXWlefBZAEU0+6r/
         BCUhGutd7eHif637wCzAyiBuak08E6RLPNaYjKy7s5jS6GRzyEBvSInB9mxCztpGtpRt
         FmJ6VZf63T6tw+FCTXLCDC3/kiWDhHstUJ1VbzRU9ZKZ0KjWZPzTaCZRqDM+14Z0NXVF
         gWYoAqr7Z/r7GbOX3FGIrXBRMKteXeUvR38GEnYK/D78d0LMJFgISfXWPVgKaw73nrqC
         GU3zwnlmAUVwTwS9hJ4Vo2oms86Ii3/dGK971qE6TkWy6x1GnUyvVoCCqF8IVHMzOFEl
         HtRA==
X-Forwarded-Encrypted: i=1; AL+hErH+/kxviGo9uLul24ABPfQPLx7tRMd+exEYs720BMtaVfDJo/Y8plkF0i8TBoQRErDRILlz2zA62Q==@kvack.org
X-Gm-Message-State: APuU4Z9VAeLgh/My+zRnfH2/vbBG1gVbt2aoFeOF9M+c5+76pUZbqxqq
	Wa1CYpQCUg6TVqq4O+vdVDaVQffMRAwCtYUAKkgjqJZtdetsT5REl8ko0VisPPpEkUMFglRjUcj
	x010Tg/FrscOxdDPVjAigWw==
X-Received: from plri16.prod.google.com ([2002:a17:903:32d0:b0:2ed:de1d:fc13])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ec8b:b0:2ed:662:e485 with SMTP id d9443c01a7336-2f03efa420fmr100600525ad.2.1795539317356;
 Tue, 24 Nov 2026 08:55:17 -0800 (PST)
Date: Tue, 24 Nov 2026 16:55:15 +0000
In-Reply-To: <sashiko-outbox-228635@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-228635@kernel.org>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261124165516.1182390-1-jthoughton@google.com>
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not pre-HVOed
From: James Houghton <jthoughton@google.com>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, david@kernel.org, 
	fvdl@google.com, jthoughton@google.com, linu.cherian@arm.com, 
	linux-mm@kvack.org, mark.rutland@arm.com, muchun.song@linux.dev, 
	nikos.nikoleris@arm.com, osalvador@suse.de, rientjes@google.com, 
	ryan.roberts@arm.com, sashiko-reviews@lists.linux.dev, sunnanyong@huawei.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F27440018
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: akhwdfbcamdnqmohpzi7e6w36fmbjpjj
X-HE-Tag: 1795539318-546255
X-HE-Meta: U2FsdGVkX1+CQ5MMGhNuVrZ72s2ajs7EhN4Il7GmVSkF8cXZOr6COMCjPqGs4BRLw4zjGrST4Xj8VNFp7s+M06ozrvEQ1cw7BkYWSiU3mcEDxJhWH/rXZeNncAx+WFlIBej5pNHex7MIuD++eqOfihALmXCn2+IcipM4t2uflvlUhf89camao51Wkh7IPvgctyaUf+66f1s0Cg8AcZnVzVOK618lxPwZN+JTANDMGKpQ8ep3r5/CI80bF160wvb8zL4o2Ah5PUP93cmKraFX+kuk6qSoJpwJPBqKg/gM9s307Tp6yq5W5yVoogh0K9NrsDpTxdk3GGt+3t3hBjUP5ZuzF4n3praAB7A5r+nJxL/RmmJGOxSQkM0gQcbwoatm4ZacSjgOIEtJ1fSOjNEpAfPBu8Y8PD12dbEbOiqk1S4l8e2+VwaEzq9PcWbUck4nx6dFd5KAKf8hj789YaRYt96GEjAnUuXGQaZQJeVOh4IzRfDMXWsoQB2ifSQnbG8DzZYXXnzVzPCexygywFse+G/0i1apNXLwt6IR060beKzaDcelmHTY2x4SNC0jDS1aCNyAm51nq4DA2TgR5/VrucZTqQcLJkzZIoReCNfDmKGKe6r5bpZDRgyuEBgfyn+YkCtwuqJ6GO3kOpUzecbeOATmNlX0MMUuZyNA7FjD1BibhABP3n47oWvo8kj9yvdmFR69sLBpB2rmlt022iX3qz6l+WPdrRitB/sIzAAp6Jm3p8io2TGlCtEw0t/kE2iFjN3vLJd7iFLnfhzWt/ilCpFQq2AROveG068Zt/Js5N2BVXGaocD4e6FEvskK0skfM3gcusI0C9bz+nG7Ub1Cr2vlCI5HOzg7LVvNIAHBwwb/JluFQMGypAaZVPjpTpuSo8Mtkvi1DNCwHHbXbUbK6tlld0TcVfF3qGDTWdkzs6/+ff19suZmERgPT3dBRijvBKwULC1xvDBBF1GTfWw
 BcKFwS3l
 rIhD9aQAS9YJ1oQaiUrn8ZgUvLBVrK4F6HWbOVmG99emAbwG+w0BvHPJ2knHsdzzysenFUAxt2HIsS5VHIB5Jfq4WcIkxwrhB6JR08qOPW0t+ISue/XyEJwLyk3Giz39mNgmkIWZfhn9MKamkhmChzeU23xTVrzdIN6tSRaKmAWhFvtq25RnkO7Ie5EsBWzS2tQl6vNX/9JUsZZA5lcbUWZ4JION6K88p39Z+qtmtytcRwB5Gk4IH0jmzeYjEKejGM0cjNCkHlLQIlOwEBbuDoGGAjUAsl/yx0IoHEbsrQ414eOKDtLszz0VfamZK9oqBd+L4y8HHdUTQ6E5SUWeUnx7WuY/b3bh++50zoXKAr1xX8ZyiRZlGblVmqT6iRwsVHrqUgD07YxZC4sDemlQF+WtK0m+yocZu/uNO7NJKwzdSRQbpKCWN3oOIytALYBPQYJTbR0vp5HJYfiYkEXSXEeZTdLZRmBkFkGHm1eBWmObEiXauqgbZtHbxONNNZn4jzHC1csVR4chuIzbt73kSglDAsZst1TqJSzPpYi/ZociVpK8t+LzhZ9KBgotChuNqUwsPQuAf/iQlie/zmiTZRX9qUfjJF3TOBimdsVI17DBojNFLQfyE7U8ERWzC3gloxtoqvDFXjN5EPu7Y/asDU6c99DV0g+m4vF/qOUDQwPAnNm9xKjxNyrXaO8mpX4f04RsuRi8MIb6/mtXgDb3kIRvsm+OaIzsOnMkeyGh7/CkKpYiG5VohSrzzKOjPBDlBGyUARccTGQc8+8oNZhoOH6B9yAWhr4InmaYvzLX53MJdFouLiE9lLTlh9V659Ydt3K5ujtgVjnyDQ6aibeb1ss5kVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/hugetlb: avoidable TLB flushes in
>   hugetlb_vmemmap_optimize_folios()
> --
>
> commit 5763c0ece0fd843280e0e8e1b6561cb66598d64b
> Author: James Houghton <jthoughton@google.com>
>
> hugetlb: Optimize bootmem folios that were not pre-HVOed
>
> This commit restores calling hugetlb_vmemmap_optimize_folios() in
> prep_and_add_bootmem_folios() so that architectures disabling
> section-based vmemmap optimization can still optimize bootmem folios
> once HVO support is determined.
>
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 72839e98f998e..8756c0206922a 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3325,6 +3325,17 @@ static void __init prep_and_add_bootmem_folios(s=
truct hstate *h,
> >       unsigned long flags;
> >       struct folio *folio, *tmp_f;
> >
> > +     /*
> > +      * Bootmem folios are normally pre-HVOed through the section-base=
d
> > +      * vmemmap optimization. However, an architecture that can only
> > +      * determine whether it supports HVO after bootmem allocation dis=
ables
> > +      * the section-based optimization (see
> > +      * section_vmemmap_optimization_disable()), in which case the fol=
ios
> > +      * were not pre-HVOed and must be optimized now. Pre-HVOed folios=
 are
> > +      * skipped.
> > +      */
> > +     hugetlb_vmemmap_optimize_folios(h, folio_list);
> > +
> >       list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> >               /* Subdivide locks to achieve better parallel performance=
 */
> >               spin_lock_irqsave(&hugetlb_lock, flags);
>
> [Severity: Medium]
> Does calling hugetlb_vmemmap_optimize_folios() here cause avoidable
> vmemmap_remap_rwsem contention and two global flush_tlb_all() broadcasts
> per NUMA node when all folios on folio_list were already pre-HVOed (or
> when HVO is disabled)?
>
> When 629d87ed65ef ("mm/hugetlb: drop boot-time HVO handling for gigantic
> folios") removed the call from prep_and_add_bootmem_folios(), it also
> removed the nr_to_optimize tracking and early return from
> hugetlb_vmemmap_optimize_folios().  On architectures where
> gather_bootmem_prealloc_node() already marks every bootmem folio with
> folio_set_hugetlb_vmemmap_optimized(), each node worker in
> hugetlb_bootmem_struct_page_init() now serializes on
> down_write(&vmemmap_remap_rwsem), walks folio_list twice, and runs two
> unconditional flush_tlb_all() shootdowns without modifying any page
> tables.
>
> Restoring the early return in hugetlb_vmemmap_optimize_folios() when no
> folios on folio_list satisfy vmemmap_should_optimize_folio() would avoid
> the extra walk and TLB flushes.

It is questionable if this needs fixing, but ok, I've applied the following=
 diff
to v4. It essentially puts back the early return path that was removed from
[1].

[1] https://lore.kernel.org/linux-mm/20261120100856.16929-6-songmuchun@byte=
dance.com/

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 8ec80f450123..df145776aa6b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -610,6 +610,7 @@ static int hugetlb_vmemmap_pteify_folio(const struct hs=
tate *h, struct folio *fo
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *f=
olio_list)
 {
 	struct folio *folio;
+	unsigned long nr_to_optimize =3D 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags =3D VMEMMAP_DEFER_TLB_FLUSH;
=20
@@ -618,7 +619,14 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h,=
 struct list_head *folio_l
=20
 	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret =3D hugetlb_vmemmap_pteify_folio(h, folio, flags);
+		int ret;
+
+		if (!vmemmap_should_optimize_folio(h, folio))
+			continue;
+
+		nr_to_optimize++;
+
+		ret =3D hugetlb_vmemmap_pteify_folio(h, folio, flags);
=20
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
@@ -630,6 +638,11 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h,=
 struct list_head *folio_l
 			break;
 	}
=20
+	if (!nr_to_optimize) {
+		up_write(&vmemmap_remap_rwsem);
+		return;
+	}
+
 	flush_tlb_all();
 	downgrade_write(&vmemmap_remap_rwsem);

