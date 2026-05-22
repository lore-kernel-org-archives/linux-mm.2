Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B7CCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACB96B00B8; Fri, 22 May 2026 12:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884536B00BB; Fri, 22 May 2026 12:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A5D6B00BF; Fri, 22 May 2026 12:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67DE56B00B8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:11:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BF121C0306
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:11:15 +0000 (UTC)
X-FDA: 84795545310.28.CE5C7FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF293180011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:11:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QqqHBVg4;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzxgIsKBLy9Uo/RJ5aMTM+y5Ci98qZZTufyvn4tb+6I=;
	b=QvfcQ6RiTeRyqrg2CIAVTOUgcdduZ8j7qFcQI2jWEn+nZhbTazRIkF6MMCvq0b8CoeWHFz
	orCSCNpk1ffAZnDh3EQMN4G3ttR8eTB+VKaS1ioVAXt45qKlQwF0EcuG7CD+U1iVkpRrE4
	CyuwmCuGaSXz8y+AP3DsGwbzIRymMLk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QqqHBVg4;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466273; a=rsa-sha256;
	cv=none;
	b=1JqtOlbl9peRbNmtCt0iRgpOrlwNCQ7zmabIYVDaYoCxQzYAhTIh+AV6m9n/7/LiRXZhRR
	kc/ZFQKEMEIQ15z3CcqXfo2M7G22uivQf/56zaqKO+CY2R6u1eNYy0Ogg2XwzgJAChhKdh
	5wrFalf3dlsTZ9lih3+08YIftovWIe4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779466272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzxgIsKBLy9Uo/RJ5aMTM+y5Ci98qZZTufyvn4tb+6I=;
	b=QqqHBVg4pVGiR9Z9KYqT2Vpt16xqd1VAOfwumfxDO/PA6+2MLL3aiASxH6+GkzGICM9uI1
	NCT6AQWHfNWENPpwvQNLVJGNR5qAbkAEEH1EuUKaDV/x19+JGcHAZHJZY3wJvwrOm9RxKT
	5frnNFXEAIOq88z7H0rQKn+RwsAe/Zc=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-l-ON7QLWPDSSh-KqgnKXmw-1; Fri, 22 May 2026 12:11:09 -0400
X-MC-Unique: l-ON7QLWPDSSh-KqgnKXmw-1
X-Mimecast-MFC-AGG-ID: l-ON7QLWPDSSh-KqgnKXmw_1779466269
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-651c15e69d7so1347908d50.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 09:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779466269; x=1780071069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IzxgIsKBLy9Uo/RJ5aMTM+y5Ci98qZZTufyvn4tb+6I=;
        b=BVfsWcU6SUVYfRDzQcMzeWXKYZmCK0WShWu7lEnKkdKjrLDfj6Ds+4gCqebTLVZChA
         g4fSGjqckFemyLbI+vemCB7rdZCcZLDKDgMYiRLX/3RK/IrjHt41VZ0uEJ3rLcRebDUD
         lfj9AfZNPm8/S040UkYMNNwO2RXEiMwus2rUrIozyVFA9cHRXLP8MX/+X1lGER3hk6o5
         LHdCRdOYzMiS7Ed14Vazv1L2K6mLWY8n/oXFaFrguO/MCLVoXoz/PaLu4fSoz/E1FjIz
         F16Oxf6jOITigB94IdZXNKgTwsXnnft9DCDzzaY28vbtE4HoIXzygo+9pk6sWsp77Fe/
         zgmA==
X-Forwarded-Encrypted: i=1; AFNElJ/ygPH46n1FDS65G93oRUchJcjaLRFxHP5T+6I1L4aBi7FWn9cJzUORUWTHwefyfxwvPg8bA9SNNg==@kvack.org
X-Gm-Message-State: AOJu0Yx3iqL63p3Y25fyTMkzmk+yWZHB/5QelIUZBjFoEf4hvevssp8S
	/0zaKYTbYIfTBmkENu+M0bTnZHbxwA8THXHI9InyNvf1Pnh+Id25/3r48l704karLtcdCfDUqdd
	1Ct3pFHQSQKxDJ1x3zxVUYaUA5WLyiDv2yJd2GneChRmmostc/WkgYONpEvp16eioFK0pSiACDa
	eWlzjIPMSFzLAcDr8AZollvO95A0o=
X-Gm-Gg: Acq92OEjSIrDpnjBaC1yB8ZUTVlX84yq3wp+eKIHnpv04TsXfX3RLgtYzwQLPLXuKRO
	F+gzmZ5cfsED5rQkLS4TYgDC+AVXb2AvSZT5pwsxRK3s+IJJFUymWxH/2J+xds5IZbldvR3xCnp
	kzRei8fgwItV+NJ4AcmZT9Gbw+phPEs8waaNcTpSKwuZzQV6dRrhXU4qhJN+snGaN4ArZpoIyTs
	MvIwA==
X-Received: by 2002:a53:c049:0:20b0:65e:b05:7679 with SMTP id 956f58d0204a3-65ec9631f73mr3544860d50.3.1779466268933;
        Fri, 22 May 2026 09:11:08 -0700 (PDT)
X-Received: by 2002:a53:c049:0:20b0:65e:b05:7679 with SMTP id
 956f58d0204a3-65ec9631f73mr3544806d50.3.1779466268532; Fri, 22 May 2026
 09:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
In-Reply-To: <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Fri, 22 May 2026 10:11:38 -0600
X-Gm-Features: AVHnY4Kw4pwY2uJsQhaEmVi-b5AxtiG-JxHuFGdnogUOlR8F2xU-TlkRWivxYiQ
Message-ID: <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rxPZQg9eOdB0sx8YXusslOQQb6eok0S2ogPiRBvgb5c_1779466269
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8gomqgjg6f6w4w4mqzf6ghywqsaiijsf
X-Rspamd-Queue-Id: DF293180011
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779466272-961677
X-HE-Meta: U2FsdGVkX18FmQ+2+9O3TvkxMIzQSn4A2Q2vHsOd2IlE1I+RY7FIvq5KdAvM3uBBRdeBIN7nel8Zr7dHKo4+GKRVa3HbqO6FU0lNTYxy6+Uov8H+3LLg8tWqQu1nT/uOEBjYJfpoSXR90JOVupMr7ZccizafyawvjJQChNlZ6KVejqhmtb1htR8Qr9Hv7mVJrb14T4jYorVzmYc1AbahNZSxrqxW0lAugIm/kKyHYqucrBYV1BM7dnWHAT3e0GSALr2WuLfEF0OFF9S5+Pl1IXuVNr4WTTDW24vGVhlgygkIKiQyx7GYRNTHyKV2Yh8OT89fF+bNBeFt85/zSC6DtPW3C625IEWrvdZfdFSosJW7yiPYk0O7Nrts+lwxFfNCsnP/czNQgw7dIqi/tMa9G5mNIZB3utVbzPbUdyl8pF8IB6phVlzfVpiSok9Tzw9exFtHBadtGvkKLrdRcEPghKzs48olO9Eh649lls+18W9y0x0d7SdDDc02vcixitybNW+86sjql7ZAIwuZFMu6DwfkY3jS40Naq9k1nq/UqEK7CSWnO9Ja4zACaTuCzfyNDNvdRPCjVIoy+L0MtGWFZM6jbrtH+ty/qiVNBtpglPXsB6x3sI5Sj53w2pywoPnRToymHwqPnvy8SeNJjPqNnqIoiJf9xTxI+SnJoCMEVBh/2fLPtV5fZ/nfCQ/zjAfIJYWpQG3B8MtullKkaNcnsTnkjEIkLFSqmTN6WEG6knzD4ipmwjMsTXy1lpZ1PW7CUoh/kq+RtuLnMj+NdpS2B/dreU8tdBpAH1dYEV5qG/EHTTQ3UA81vBOAXmoN7KKA47ZmhvQMyDdi5tHyctZ/CUPANlGSM7HVumZuYbfPL2sf08lIyqtl9lbN/TympjnSeF3RNxjIAx3vxL44Bdks5nMPKUMbvZ9taOHoAZvAITFv50FaGkZxCbklfvJH7OrmtdR4VdylldlpiHuQtp0
 TJ02dLUz
 SY/Z2ABy8nx/qOT2jCCn9eVTUYd3jkJ+YRy0+Kh7YtXTEGOzj3+W/1FhWI9Hz/YT9CrvAXRbcCfbTga504LDYVzG43yNQKYk2XDTaqBfP9I6t6eILRPpELouFFs5HRUZWUWhGvDGsRC/XW5EGJp+/2wIujJRsamfOfAgvzYSKahLFasls+3gk/AlotFHSpJnNhMd9q30evDZR2OGej/AQMEzB/So6UZ8wd7oqZEl7wdz//hO6HFRE3L7imNCFhsO+u+/4PULu9H6p6bpFPhUFzy5T/rQ3gIWArq2X2FN5VFBb4B9jXwU+3g3RlyDZVJf92RwdrKpg7uiQO+J9icBbACtKCMkdn8Ltg7CZYQ66GQL72MMgZT4jlRLnFcKOQdKAKLY8XTAw4qdsqV1HYQhvaW9VWmvltudcFtWz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 9:13=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 5/22/26 17:07, Nico Pache wrote:
> > On Fri, May 22, 2026 at 8:59=E2=80=AFAM Nico Pache <npache@redhat.com> =
wrote:
> >>  include/trace/events/huge_memory.h         |  34 +-
> >>  mm/huge_memory.c                           |  11 +
> >>  mm/khugepaged.c                            | 634 ++++++++++++++++----=
-
> >>  5 files changed, 584 insertions(+), 172 deletions(-)
> >>
> >>
> >> base-commit: 6c8cb505a5634594b3ea159fd1c71bce2acf3346
> >
> > Whoops I manually changed the coverletter subject to reflect that this
> > in on mm-hotfixes-unstable but never updated the others...
>
> But why? That branch is for hotfixes that would go to the current 7.1-rcX
> series. mm-unstable would be the correct one for this, AFAICT.

Sorry this was a misunderstanding. The goal here was to base this off
the closest base commit behind where my v17 already lies in the tree.

That just happened to be the hotfixes tree (previously it was
mm-unstable, but that seems the have moved).

Sorry...
-- Nico

>
> > Hopefully that is ok. Just a small mistake. Base commit is referenced h=
ere.
> >
> > -- Nico
> >
> >
> >> --
> >> 2.54.0
> >>
> >
>


