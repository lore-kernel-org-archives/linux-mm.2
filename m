Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10301CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242EB6B0005; Fri, 12 Jun 2026 07:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD076B0088; Fri, 12 Jun 2026 07:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2D86B008C; Fri, 12 Jun 2026 07:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30FD6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:21:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 801338D606
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:21:17 +0000 (UTC)
X-FDA: 84871019394.24.324F178
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB34F140010
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:21:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FYPAsJ35;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781263275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9FlJSoQ1PrMv3NoMGU38Y/z2migVxYwYPcZc0DtbZI=;
	b=ezp4U5moQNp4E/WlLdN1agCv2fV3AEut2Rd6lVmC8WibrTfGpQ3xNFTVkQjKbPqPvBxtR2
	KNM3PNVCPeOUiGz9BxsZPDi0KUENCNwZFO/CoEiObK76M/8RYkFatTpF+vqKKwbAI0qy7k
	U22EBqbspgvyP6k5TUXx1zIPqzd6jUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781263275;
	b=c3blPwEHBeLKO71Ngl2SbwqDHqYYB0vYvO7Kwo3I3WwF2ZNbTYBA5MdLYs/vnLLqM7H0Vn
	l/wUm8T5hTEFo+i1h+IZEeiepJzjGfGxDIpbdu5g9io1mlzAqCXCz5Tmr/DvBZS7iYs//H
	p6Xt+XJ+GrcxLiYV6R+LONbNf0XU+Oo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FYPAsJ35;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781263274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9FlJSoQ1PrMv3NoMGU38Y/z2migVxYwYPcZc0DtbZI=;
	b=FYPAsJ35VVzLRQfNBEBVKa6sLYo6TO2yPWUxb3RexhxygsmTcmkRw+xkkj0b4+b35zKgV5
	xOZer9B1vgdJQ0q/+IH4P/d81tBixVOEhfM1igU8qTfWeFMQKKxuyagDgE4d0W87sbRhDO
	lK1E4kOXIJn94KmRBUs26ApZpWzZXsU=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-398i-0KKOUm9t97l3i76Rg-1; Fri, 12 Jun 2026 07:21:13 -0400
X-MC-Unique: 398i-0KKOUm9t97l3i76Rg-1
X-Mimecast-MFC-AGG-ID: 398i-0KKOUm9t97l3i76Rg_1781263272
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6603cfb9d71so1250807d50.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263272; x=1781868072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+9FlJSoQ1PrMv3NoMGU38Y/z2migVxYwYPcZc0DtbZI=;
        b=shF/M+mv0fa6X1lkPEEXA4M2jBQenrxzdnevYK+DPAua70u/NC8WjSRYXis1IlF2jM
         qIq5keSAKLYbzqdVYAOttwQAmm2M14xy018kQDKxfUR4luQvCk908k7TFv6D0vnha17m
         ufMJMjtAejDwLFKAgbkqSNkYbEyfnfiDQjM+E/+shtx4FO59M9uUOxSADnkXFiH3VeE1
         W5gcV1CVRUfeAQYWuFzmTebYhDO2lEizAQqnBBNZLSpelJBANQ307gjw2mzsDxGxP1lb
         nA43sCjI1DD7DnZ11CE2xUWy5HYazTym67mim2lPiUYdfObGZja9LGcZUKLfE2gIAWBe
         y86A==
X-Gm-Message-State: AOJu0Yx6YWsXlZbWcOztcILSiEhh+oSXJ80KDjFTqkAVh3q5+NV4Sx1/
	qoyKYVIUlw/XUiqmaeavCYTlRX+UeemkA133SYKbW/0UMlfKMwL7LowJ1VekBN1YOQKFZ156MSU
	S25Tp0xfzEwjVeNBuzCUDpWYheE+feCohmB4nxQjzEwU+dSKXl/ah3ATtLoRxjcD0WQuBrgrv5G
	2LIjF3Bl35locfRNPoRek94f6txl8=
X-Gm-Gg: Acq92OF2WRtxsfC/W3s5Se4Ey2Cr74g4o+fNJcm3T+bw5mo/XUfDb+6QzfUj2PA/I/E
	24MHyVz8qzOmc4nvo2I3bUGANTZzoRwSZu4oXLIzct9YBugb8zwjC7V+OVFqD4J3X8Qjyza1lvT
	D0wJHwiMuvY6+p2hI8yLLePhqjY44dvHPejvTF+iI3lCXjlYnoWrkKE8Y9VbItoTm0OoTJq1TDU
	mN4
X-Received: by 2002:a05:690e:e86:b0:660:7a4f:9fe2 with SMTP id 956f58d0204a3-66278468075mr1653903d50.57.1781263272483;
        Fri, 12 Jun 2026 04:21:12 -0700 (PDT)
X-Received: by 2002:a05:690e:e86:b0:660:7a4f:9fe2 with SMTP id
 956f58d0204a3-66278468075mr1653865d50.57.1781263272001; Fri, 12 Jun 2026
 04:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com> <7e7cbc60-e9c7-4a63-9d4b-4e8fcad7bfc0@kernel.org>
In-Reply-To: <7e7cbc60-e9c7-4a63-9d4b-4e8fcad7bfc0@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Jun 2026 05:22:01 -0600
X-Gm-Features: AVVi8CdNLha-RR1qN40JSwbbQIn5r6XpUlj26RldKCxPkjYT8VOZtB96P7x2nAw
Message-ID: <CAA1CXcDmE3G2K-V0VrzWy=xHUjOwnMcXDJjY+hBV1hxBZUGh+g@mail.gmail.com>
Subject: Re: [Bug Report] Elevated PMD nr_anon after running selftests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M-K3G0e6qNgZHbojpoCZ_CWKgdfwJSEyJW5cz5wpVmk_1781263272
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB34F140010
X-Stat-Signature: iugorzzqe4p1ma11g6a5aw5yj8x9e9ju
X-HE-Tag: 1781263274-39658
X-HE-Meta: U2FsdGVkX1/98woirKKwz2NPyKRBJ9flBgS6xUuASo0lXLyIXAw3MYfl+C0L/c+QVPRWi9YlK24xK461uCvhBUrbINcsgvYkoDONacdmp67f5GoCpI0sM3mDn2KjJxlz6E8Su2wlvD5bOS4FHAAIoCMFf5WXmhiy9454TIh2ngrDo44VIGtUbRbEPK6awN+sO3KYE2lPTyj4MyL/jqH3gC7s5d62oDlW6SfhWDAEDE9gsK9rT72vl/8mZapvg4KmYOojqHh8HMnP9LLWyZbB2/4o9NupW1HtkxJC8KgE/IqtYf2/AcNUABJcd9n+N5xq13EeFXmUn+o4uIXjOz1X8yLuxDaAjnEGYmQ8ZX4KRFk5THybGufDb/8wOAkKddjytLk7WF+gKMtfbwznKEILdk35oalepEctWWsprLQjJdfaJYexghs5u/Nb60/PvEuHkyE5tTr7US4fukT0bVKLdMBXJmqH7MC4j1Ok9/pUFnBBTUimETbj8KvErOreIb29+2RA+gsYcMZ28sDyp7uI9H4iJxmmRMh6cEs6fqhGClDnMfU3TOz9R7KUjBTyvONbYxA9mXWnzrpgbxTcubP0BazTXiRhFNF0jm6cghGSqR8NcRwe58wrdLpJmL8NTodibLQ8YNbPBP/hsi1fKehMO4cd9OK+Mk587Cyn9c22MCUZd98MLc4T5KEWmfN4lx+8FF9luBMgCg+ppdIVh9nMSCEHxA5TtEfAD1/rN5Fl0DGXiEPiLp/d+jzo4ayaJgcMPwdKjpvFUInM5y8s7g3+BKoDZW519EopFTL82qICUViYdAh7qQC7lmgSg2xcu2CqTep7RC4kJgyxvSxvYQ8qZi5fJeyDcliWnHsbbGSo3GXBT1wRXtyVU9cyJx8ab4Q6dTHzYzPcNVrO5EMGfn0Tzb+q6GmnRxRKy8/V7l5fbVNksKHRMS0miEzpi+2CirDujrkn5W/bXibuze+jKKC
 d2OkDQb0
 6xVNPFLKAqBtleX22uwlTuizZDrU9kt/zoN8hft5Z9uTXz3t8EMlwozZmwJAJhT77S5JMoz3DNuRfPPVR4MXexezzwz5ytwTMtNZrnplMDYXqjxT3Pi1k++VQwE+wnS4pLCdjZnzjGTCuleFjhhB4McYkGD7vYC8Xqd1fEhcUXofQrK7B4VFb7Z1FowVok0YXxCKkm5FQ3O4DE+nzpEnr0NSGgiyhQoAQN0SIZhjusLy4cOJxvlcxyMFJx8CD4soo6Se/uCgluhaR/8zze/13IXFryP1TgCrhzBY0EDx+S90XgHsXSY3uyjrIsJT4vjN3n0bkgxVMQXM8Uj3jFUZpMCD/7BL4fNNeCNcnpbklzSGeFNj2gKyv/K8jyFEOf415dQfSyfD6Qf1VsPh+xZdsPMzjp0ijyjbjy2RdU6yziLbqCZPI5yUU0rJkwe12miDsD3rX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:09=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/11/26 17:58, Nico Pache wrote:
> > Hi,
> >
> > While testing my mTHP code I noticed that mm selftests caused an accoun=
ting error in
> > /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon
> >
> > At first I thought I might have caused a regression, but when retesting=
 with 7.1-rc5 (without my code), the issue was still present.
> >
> > This issue occurs in two mm selftests:
> > 1) hmm test
> > 2) migration - private_anon_htlb test
> >
> > I spoke to David about this and he suggested the following diff which s=
eems to have solved both issues.
> >
> > David would you like to send a formal patch or patches?
> >
> > Cheers,
> > -- Nico
> >
> > Diff for (1)
> >
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 053842d45cb1..683a77dd679d 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
> >         mem_cgroup_uncharge(folio);
> >
> >         if (folio_test_anon(folio)) {
> > +               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1=
);
> >                 for (i =3D 0; i < nr; i++)
> >                         __ClearPageAnonExclusive(folio_page(folio, i));
> >         }
>
> Wasn't there another issue with hugetlb?
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8a64291ab5b4..0aec894266f2 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_spa=
ce
> *mapping,
>                 /* No turning back from here */
>                 newfolio->index =3D folio->index;
>                 newfolio->mapping =3D folio->mapping;
> -               if (folio_test_anon(folio) && folio_test_large(folio))
> +               if (folio_test_anon(folio) && folio_test_large(folio) &&
> +                   !folio_test_hugetlb(folio))
>                         mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_AN=
ON, 1);
>                 if (folio_test_swapbacked(folio))
>                         __folio_set_swapbacked(newfolio);
> @@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_spa=
ce
> *mapping,
>          */
>         newfolio->index =3D folio->index;
>         newfolio->mapping =3D folio->mapping;
> -       if (folio_test_anon(folio) && folio_test_large(folio))
> +       if (folio_test_anon(folio) && folio_test_large(folio) &&
> +           !folio_test_hugetlb(folio))
>                 mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
>         folio_ref_add(newfolio, nr); /* add cache reference */
>         if (folio_test_swapbacked(folio))
>
>
> Yeah, if you have some capacity, please send patches (and figure out Fixe=
s:) :)

Yeah ill spend some time next week trying to understand why these are
happening and produce patches :)

>
>
> --
> Cheers,
>
> David
>


