Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4732DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918658E0007; Wed,  3 Sep 2025 10:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF138E0001; Wed,  3 Sep 2025 10:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CC58E0007; Wed,  3 Sep 2025 10:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 721348E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:18:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4742814072E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:18:47 +0000 (UTC)
X-FDA: 83848145094.16.BF58CF2
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 51A2240002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:18:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bKxdjpoS;
	spf=pass (imf04.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756909125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1tH95Juuh1rXl0JBiJjZ+pvaXEYbkUC7vChoclECFQ=;
	b=ir6nIXPR9QFQJ+aSnMcdALVQacvkhyt27GtBj9iv4DyYLr/CZlXWx7YpprcUMRgodDgzTM
	MNezLS1LFJgSX9V3ARXrHrNt9wFhnM9nIo4YApv0ZVfDtekPG/tpqGOmtY9JwPP/FtnPYv
	V5i2ihob8iMox7tLbpoWsal4O9ki/mQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bKxdjpoS;
	spf=pass (imf04.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756909125; a=rsa-sha256;
	cv=none;
	b=fVwXj21QOHCYYGZBK6ltgeGE2epQcBHeoG+SzusKWym/hjA0ZfpfDTuuKualbfYOZh86nB
	v1nevFrCprva0Eo2m8RW3BUjflzSD5HkIbuPSnTIKjq78oCQ4Q67El6iQ29JULjgDdMzxG
	PtBbu1U8/QeNGIrpNjihN7/GRJaREKE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso11077235e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 07:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756909124; x=1757513924; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1tH95Juuh1rXl0JBiJjZ+pvaXEYbkUC7vChoclECFQ=;
        b=bKxdjpoS6P8GpntdhJ2oW3MxBcPTLAJgAngr1P1cLOlgXrMh8WysCZ77UJ9jD67yhL
         RWwTfgtOFMgB6Ac+L3YyPmebPlX3RH24P11JbbTEfGC7O9EGyw7Afs1pB5ZpF/PUWwTB
         VqJN1+LiMuQ4Ua+5Yyw+IQu56k60JRNyC9i+TorIyRq2vHlcgCmgeEszvs1z9IIKgYxQ
         DttB01J7pIXVIDHmSAgjyxpnvf6gmNcbzeoZh8E+nDwNxcBW5iQeyhMF7v+5KUVpBZsV
         UVnboPR6E3RcMSRh43qiIosxrQCveXosD69HPmLgH2igHcMGtV0282yTyLsiSaIxEbbX
         VXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756909124; x=1757513924;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1tH95Juuh1rXl0JBiJjZ+pvaXEYbkUC7vChoclECFQ=;
        b=wsr32YfnOpKtDnH0wNQvrK8ygild4MflTJewfaliSGR5yNH4rmLSC3JCrzJS48gXbN
         rRaS8dMXuVsneQYGTusAi2NXmx8RaSAS8Vmo30hiqRmyuSVMICaaR/CVQhq1WYbsmt1C
         TtLwTiW25qRMDzErH/txZ3WdU+nGNfI5rmOQ7eZ1STgXC8NZ6pNbstWR/hGDlI4lxs9I
         XZ9kjvbs6gLD9zgWs03AV6fbAoS72+KVup9ITSLb77a14dBycKkpvPypsh1oCWCWgcg7
         vRJjxuViPUX/TxW8sCDjMJaQKo1xyvfWAWL3uRtExg4Iue0fuLulqXK0nq0aCxUsntD1
         RmOA==
X-Forwarded-Encrypted: i=1; AJvYcCWprX0r0Od7JYgOvjDENRpSN7GdgFaF79Q1vmqImQ5CI89qutVfe4wcZp4MzhzjCGM6r0ybO2dTGQ==@kvack.org
X-Gm-Message-State: AOJu0YwBIWdoXbSUeTVqFpOjDGPUqGmIBJuaSexireiAV2y0p94P7eBv
	LxYu9rrmCNYX3tJOu577WLcdmyvXsTAdGeVGsi2AEkTnfoliyYc0lrED
X-Gm-Gg: ASbGncsMCpgz1WyJNK1/L3rbfxWB5GQXGlARBPjaajq81+4oHpBeHQVh3LvABT4pdV9
	neOczf63ZoKeaSUD6HUPatH96mo7kE7F1XpMJOYZ4RiFBVSx0Pg/nyHDAv/v9WQrwCdNITDXo1L
	gZDgE4LSxYfeaUDaHZJCVU8xVAgephv5W9zIo2oVMUpqkbyAGdRr0xexWhy/nyFf2DM0D8DTXgk
	2mRbSaXFDGNumtZAuw85cRKq7cigpbcamtc3SU6e03KDfn+ufa1KZe/+oI8zTMicB4Bcqo0KyUZ
	Ab1AORSg68hzV4/G0wouXqT6U3jsOceIjMAArTRckVBvGt6XNVld8w9YDe2EVUg9XEqbn4xP9Yd
	4iPw/ROHxsF0Z2sTwpw6LRApGlSAj2LztasLKfw==
X-Google-Smtp-Source: AGHT+IGxeY1z+y0/N2JQWJRsW96745IalLmq/FAayUobFdSig7XcZQ3JpsZDzaXf8TTCBRgdaspBrQ==
X-Received: by 2002:a05:600c:c105:b0:45b:9c79:6612 with SMTP id 5b1f17b1804b1-45b9c796832mr35338115e9.1.1756909123431;
        Wed, 03 Sep 2025 07:18:43 -0700 (PDT)
Received: from smtpclient.apple ([132.68.46.23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d701622b92sm12542740f8f.58.2025.09.03.07.18.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Sep 2025 07:18:42 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
Date: Wed, 3 Sep 2025 17:18:29 +0300
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Rik van Riel <riel@surriel.com>,
 the arch/x86 maintainers <x86@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 peterz@infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 zhengqi.arch@bytedance.com,
 thomas.lendacky@amd.com,
 kernel-team@meta.com,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 jackmanb@google.com,
 mhklinux@outlook.com,
 andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com,
 Ingo Molnar <mingo@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>,
 baolu.lu@intel.com,
 david.guckian@intel.com,
 damian.muszynski@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <920DC212-880C-4688-A577-2589CABEED75@gmail.com>
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
 <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
To: Jann Horn <jannh@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Stat-Signature: 51x49unpmmbwd8kyxrab3rfxdmijpia7
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A2240002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756909125-651527
X-HE-Meta: U2FsdGVkX18lRrJrvp0y3O0yoVpe0h9u8vwvYhPkjKMZOQFgqfyxemI4Mk8Cc9rumAaSeoT1ziAFID8XCK/SrzU7X3Pfabb3JqqLmnCph7vnnanyPPoz+771yYLnkESIiktC5/Dxjl1DoH83Up/bfZc76pveDMUghlpgPV1SFoxSujigNmK3sgbGcSkdhZBL3OqsNZ8FjTqNKPegi3vBYqHFO2j2Pwb+Nz/cv4PHEkcytJs19YGS2AYNogDN5yWI1B6WoY5aIcnsulHY7pskkE1TqOdf9PZn5Ucpt5SvnPMMLbVUZSX8d9hq+MVmvyKyRS/5E/UDcilOGwQs+Np1CiE0ayvPGJzp5o0j4P94bnv7JefyA2Jt7KFhgvxnvWO4D0/d8Fnl5pek+CV6mDpcKWqN7bqmieMEQoT01iL+1ysZxPMmfCivLhttgPBrGJavr6d7dvjZEQxcl183BRErY68kySX5BgMWEjW6AK8jQW0sZHB3OHUZjN7KTz6OOkb1GnpneBJmf08Ar4eszkgVhBrCrc9z3zu67yGzBMN8uCzBZ3L7Q3zcIhUjtkDs8J9E/r4EDyE1v0itlH8xBwCXD3tkqlLA9yiyOHoy8wILEcpSL/AIh3tZqzR+3HyL9tM1sY+f7NL9iVwjTorxu2Dgrmop7QRdIfyVg9RtdbTLzz6YGRPG1A24J7L8fpXne4rxea+RsFaJUuDt7xM2y7Vnoq7BJG7UR6EbBEi6xnmggkUPqaoPhF2NTwopfY0PuubZrVRIL607lcQoaZ2csIkAaiCbf5aECclVOCW5GeYLqGIJyKcjHU5CBV9k4O5jf1ShX9YS9A9aWqL1QRKJ99KDYxDjgqmvlb7TWd7Nt+oQppdvz+JdAI5mphPQWzmTVO+8FHRhgjQ6KDHf2anpgob/fcxAF+1g7A9Cb9x+7EswR/FxETkDqqTPci7slpXplYVOwQiU7DPjNoS/IBDWcyf
 yQDdjOrh
 d7xKHvxrXUxziAmJwaf6I1EIKc5/yyst9G6XLQ3cS5WpG1kwaDzFkGOipQsajqrYjRLblfpLvHWef+tSx4FR3WOLBmjbXK90DlBzV7Cu9W+BhmIpkWOVsCaTkJCBhuPEvd2PK+29ZUDYAeV6hb7bYMEDNShJ3e0xNOubAxQxJ+tSgZgnoucvu3N+rDUqHuFuDFBQUBKVjitd7Glw3vV1Aq/BanUtIGj67OWIpRP8l0J8Nsx2chOzBNgSs35oaUdLCN2QGoiH3UHvlxpNyGAqt0hEUQRqFxrtwzwdZAs3xIQlakH0uyqk1HbeuDrm0n1bUiMFQct4fyp2V3S4xlJbsO/1H0zrAM5J4Y7W/eQdOQFTQho1nI43g+GTC8RME4eu+LWnEY3z2M5DBgKXOOZhSCXPgw9lu3HyFqsjR5k1y7iDJvHFlKa+qh4mIAVjG80S3q7DmC+JwZTeOH4Oo+4kvWdGT4fPg+2dLiIOidU4gZWgf7NxBy4U9KqMCA1DU5ztgteFqG2gDuMofIWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I just noticed few things need clarification

> On 2 Sep 2025, at 19:05, Jann Horn <jannh@google.com> wrote:
>=20
> On Tue, Sep 2, 2025 at 5:44=E2=80=AFPM Giovanni Cabiddu
> <giovanni.cabiddu@intel.com> wrote:
>>=20

[snip]

>> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>> index 39f80111e6f1..e66c7662c254 100644
>> --- a/arch/x86/mm/tlb.c
>> +++ b/arch/x86/mm/tlb.c
>> @@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, =
unsigned long start,
>>=20
>>        put_flush_tlb_info();
>>        put_cpu();
>> -       mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
>> +       mmu_notifier_arch_invalidate_secondary_tlbs(mm, info->start, =
info->end);
>> }
>=20
> I don't see why the IOMMU flush should be broadened just because the
> CPU flush got broadened.

Agreed (as Rik also indicated now)

>=20
> On x86, IOMMU flushes happen from arch_tlbbatch_add_pending() and
> flush_tlb_mm_range(); the IOMMU folks might know better, but as far as
> I know, there is nothing that elides IOMMU flushes depending on the
> state of X86-internal flush generation tracking or such.
>=20
> To me this looks like a change that is correct but makes it easier to
> hit IOMMU flushing issues in other places.

This change is not correct. Do not reference info after calling
put_flush_tlb_info().

>=20
> Are you encountering these issues on an Intel system or an AMD system?

I would note that on AMD IOMMUs there is some masking functionality
that allows to make large yet selective flushes.

This means both that we should not force IOMMU flush range to be large
just because we decided to do so for the CPU (as you correctly said)
and that there might be an unrelated bug, like in the mask computation.


