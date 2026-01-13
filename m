Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0C0D0C84D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9786B0005; Tue, 13 Jan 2026 05:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B770D6B0089; Tue, 13 Jan 2026 05:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DEA6B008A; Tue, 13 Jan 2026 05:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 903236B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:49:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EE7A57A27
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:49:43 +0000 (UTC)
X-FDA: 84326619846.12.6F18A3A
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37E0C40003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:49:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uJp3bfIz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of smostafa@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768301381; a=rsa-sha256;
	cv=pass;
	b=jNkR4tX5mHQWT/hMeW47twBPLk6GCKBnBCPdi0EiRDl2v+cCAuu38HDQ91qfO+4gLwrDbR
	fb+BHRr81jLKRYWIDDw9Aq2hy1CphwgAob+pjm91ydQmhKWpwU/OSxlbeGLpHYjcHm/vaW
	R50NATYwtKo0vhuXr7hGb1/Z/zQRvwU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uJp3bfIz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of smostafa@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768301381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXG4CU5YmzAtAnNGeTeZPJtWkZL9OvdDelesvzB7oWk=;
	b=KB27TrVD8F0N9eb+SSs58V0TH2fFfQjINc1pHpVZxM59u/EvOUkJCo5CGkpSSTcnGZNM4k
	K+Fbgem/GwmPXO2Pk8WiyknE2LgcztSq10on+CmpJow24jtJfb+qDbONWcol5G5mmo9cIa
	SyFxnWP3VMS9l1zEbeoghpl0TukQD8E=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee243b98caso348021cf.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:49:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768301380; cv=none;
        d=google.com; s=arc-20240605;
        b=dZAY/Q9A471bc4NjbM2au3uuHan3ROwMbG2NDB2CVh7J17NNNauS4dh3sQE27Rmq40
         M+ABrgrbT1NkXhPOy7ki0RuYclEMS1KvQ+MSRGLvvcG9lMkprhGS+B/PfsiGtZlu7Hod
         ZoauVjo/TxQPThZKR7k8/XWHAbuCuD2YEif4DNiEV0xL3VFWWQcLaQmrf6q/stxw0pOe
         Hl5UdpSnjZ8e5wD9z6JW0aVmT+pg9HLDe1gtORQbnGFHVDPK7bgl9AbfwzAUiko9Mp6s
         NbV7np0bFTrimTegFZD6PIVQ8wY3rls0zFHXTb8RcqdKxflOF7exoItXU5Bj4uzcKkq+
         dK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NXG4CU5YmzAtAnNGeTeZPJtWkZL9OvdDelesvzB7oWk=;
        fh=QX+X/eCz4xGTPgMkVsYgTU/xPFDyc2J8DKxHa9lyYP8=;
        b=ekhRjnrk7wO++YEAkYALSIJ0ytg6jenM84I5gyNfNsSIRKDJzUXYpPDRnLs75pRoNY
         ce31mqolUz4+qqi676OQw8lyb2jMvkvuBZUi7CCGLJBiHvKry1dMJcNT6xty3ORv11bm
         9XGiJT8T653y9yeXYNX7Cy+m4jbZgPKPGFivdagmRI2PNSDu4DKwntVBEkoHiQLQO0xP
         MHQONe4MHbHYZN6YR6MHTjUCnK4BdDXanrOQwkypQmCLRV554Azx3XWhCO3FdK8c4wcI
         WNtEw104Y0VUT2xtYcNkzlFN92v0Sfhsx1mpBWh98Du6dR/cUoNAAdzP6U2LhBZSQJER
         nPvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768301380; x=1768906180; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXG4CU5YmzAtAnNGeTeZPJtWkZL9OvdDelesvzB7oWk=;
        b=uJp3bfIzBf5vJ2HvrIezjZJSLi2z82f7LVji+7QT7YSS+lQmDbJqTq6RqT4HiLorNt
         MutFOtN/TcXy+Dx1p0SNDETpx7F27r1bVwxX1SQvDeXHGu9q2aLXgXLamDp8AU/72BCf
         ZfRdyODv3pjLZnurgnpV3bx1yNPxRBKIhWpp4nlbMmKDnyBA6TLwWexEDd0mZWmBcx5d
         Um6lbFuH3xmSUqDMV3oTQGooD8iJdAlXaGJgp5JW2ksr2x+LPOedF/ouVUy24YI2U8th
         y/x4NSwQ4oCSGfRuI/lVPvYCW0HGQW8NQtKtcIgtvgd9gYf/wYPTQ7dDyZaC/0CvURro
         M8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768301380; x=1768906180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NXG4CU5YmzAtAnNGeTeZPJtWkZL9OvdDelesvzB7oWk=;
        b=jvDM62UVIY6ZLBXqNGQ/3YB2yzV3xuKxgecSb/Wb+ywot8Stb6fJ+eWZ77Xnno987Q
         cBLGoqF0zQxtoIh5OnRyqdfNHqE+uXsnw50WrMSe4YvjMV8OalJbr5vKRjkP6csHLxVK
         1ZWY+NvMmZm2zRKOpFdL8TqFxduIYljAMmtRpm11PXPbgMpGioKgVKuoxRMRtHCBfsKB
         K/RPRgTXPgcPxWFlbsRa5+KZNNDXvftrp15T7GX41N9Order6hfKRoBfTw2c6pEPiHbP
         4U0gQOGqtAg3MtxXR6CcMsJG3dNgTyV9vWf9ucgqh5ou4kSztNxWfVw38DqQSDbLkhK2
         O6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD9JnzG3tTrfOBZWrJ0I9jcjudZTjPOQKYpSvoiBdcmDcuJF+TN1aBzI04/z8Fa3A0F98ll8F2hQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+eCGPf43sFoMe7nq50Hf3t/2UVk1DRRfbmaAVkyBx6d0bKnCa
	140/V67ubRSkxr+CfT8ozASlTtTURWj3Tb8AWwrvSXuuduINoW4lZHIt16ziC7wfC8j1oyJWAXz
	KLKJJklmxHYny4UqYfu+U5Cj/YuJvvbP7DZzSfK9M
X-Gm-Gg: AY/fxX7HKm6PqAqo21lzNgC7wT1RqGI7KzPQ3V1/YNAfvWGCRUWy4VJCH2uRvXPW4sO
	aAz9erNYOuocsmUPQbwvts0DnTyxQTEzKMoau4hO42S1pTjw2ZILpihIUqqHnmGpkaeB9cy3h5a
	t3qH/pgGkE9+3sINNS/bGLKtH36J5Yc45woxbL6Q1JFGN5hqNI1izQjq1nrr/pODXsTl2N6wtkr
	EQbDM/o9e+QxElqBOS/p6ABM/S+zqJvP2L9WR/fCSbosJHVyK5JGCe9MmQLsUy1fRx1Wa2j/nqU
	xoTIqQGNabCyKSrsI+Wxh0d9lg==
X-Received: by 2002:a05:622a:3cd:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-5013af6d173mr7683061cf.3.1768301379920; Tue, 13 Jan 2026
 02:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca> <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca> <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca> <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org> <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
 <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org>
In-Reply-To: <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 13 Jan 2026 10:49:28 +0000
X-Gm-Features: AZwV_QgAlplyLPfi6S3PJ1zgKNxfE-mAUtCQBPaWTfjdB1wsPcBjVXKJ3tx22Ws
Message-ID: <CAFgf54ovfnTHmMuZGk73SEEKsP3k-_exR1wqUE4W9tLYKv_iDw@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 37E0C40003
X-Rspamd-Server: rspam06
X-Stat-Signature: b9bsoc9o94xy1cxoueubthcckm6cxwnr
X-Rspam-User: 
X-HE-Tag: 1768301381-734755
X-HE-Meta: U2FsdGVkX18pXWMzu3+u55P+cWGExfbWcbTrdF5+RXlDUHNmPQVrrlNAi1Wxj60xfZpv2NvDRjknxGxRLb0CtoxZS4uuyHcBzR//NhraNxuGBrR2G/u5xX871U64yKxJigjCAykPynKrYgNqQD3iA1TY1re6jYBcWBQ9WCHk0OR1rzjY5aM+fixukwteNWf8lJsM0f0H3aBMJqWiCyjWcRbAy7CzBwXMqcQIRtDORYphLg2WzBXC3s/1tdwk2na6qBtgWIEAv1CDwkGn7xvqDtZH7+KBLy9UAds5+toe5M8HQeTKpec9825ZEB7HaBaDXQXZ+K1dFExrbDs5WJHm1GFdA8WJwxYiyH0cssyakD4F3QJnek52KIzdXOfE8p9qsx0NMRM480JyiYMJfzE7INvqFyYO5dCOrc3CEfCMCng4qAubx/c0avvaMFtbEa6RX0rvRsf7T+ckbsUouYd39kwxmFQAXS+DNE9LZJt+yI3Zguqpm9ofONcqE4rFZ+VrGTShhxbF57GRD6xiV6qK6HNxTxGRXfmY0UMZ4F2yzrwjbDMU89T4Uq2ucNAwCtHehrOOXvxS1Doo3VGSBmn9IsRxEP+a8HTwSWDf8KzUK6CDem5QNdiAXrAX/pbeLMkj/tegvs/5fofkErlSGJvRLfK0FERkS2wpjs0JUP3DRRBFkDRBbPpI/9qplvhcKlqZyuclYtx+lldA/cku5wWmGUgzp5Q0qvs0Z1Eo4uCxnRrnZHmp+kweNa5x35HJsGMT8q4ImLbV7mA/srtLX+93xLYiLR6PeujiNSSI5M8K05jeFPkYjWOzZjzORqN+4p3Dw6sAqX4EodPd2d17x50kYppr7YCXsfRHN6rMrybUteWFnHRCxfBdkgu+Bq9hNXcYwh6TGKRjjI9rdha0b76fckahE6h/LIS5bZt8fr/dswWufZMJKIzghNt+Uib2Nb9LdEGaeNEmA1/+puYa/ee
 9UocTmzW
 UYjdrQOw11ORe26vC8e64oIykMuLTYik3cOowgSLPBSKKd87Yp6c+oeb3F+m0FDfgYv1Xes+Vt6lDJNpDNMOTKLfMvqgEMUTuOIfE2UtvPUEBiYoW6S3XqmryvZh9DFvPz6RcHj7Dvv04D4+5XYqPUq5pyLoOB4mh5oWy7eT6Z87Quro/SICQOgFLA8Kz41DU662+6t7IF1GG313ksRg+kA5FgHYawsOOexYm6bCCLTc841Kyc4DZhzjQxqO3yBKbIiOYFnA1pg3h/hf21cjsIH7fs1IXaZ8AA52vox/Fv7/J7MdDV5/4WtpI6j5PN0p+iufa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 10:31=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/13/26 11:22, Mostafa Saleh wrote:
> > On Mon, Jan 12, 2026 at 7:12=E2=80=AFPM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> >>
> >> On 1/12/26 15:58, Mostafa Saleh wrote:
> >>> On Mon, Jan 12, 2026 at 1:52=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca=
> wrote:
> >>>>
> >>>> On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> >>>>> But I don=E2=80=99t see why not. from the documentation:
> >>>>> /**
> >>>>>    * pfn_valid - check if there is a valid memory map entry for a P=
FN
> >>>>>    * @pfn: the page frame number to check
> >>>>>    *
> >>>>>    * Check if there is a valid memory map entry aka struct page for=
 the @pfn.
> >>>>>    * Note, that availability of the memory map entry does not imply=
 that
> >>>>>    * there is actual usable memory at that @pfn. The struct page ma=
y
> >>>>>    * represent a hole or an unusable page frame.
> >>>>> =E2=80=A6
> >>>>>
> >>>>> That means that struct page exists, which is all what we need here.
> >>>>
> >>>> A struct page that has never been initialize shouldn't ever be read.=
 I
> >>>> don't know how that relates to page_ext, but are you really sure tha=
t
> >>>> is all you need?
> >>>>
> >>>
> >>> AFAIU, if pfn_valid() returns true, it means the struct page is valid=
,
> >>> and lookup_page_ext() will check that a valid page_ext exists for thi=
s
> >>> entry.
> >>
> >> Not always. Offline memory blocks have a memory map but no page ext. W=
e
> >> allocate the page ext at memory onlining time.
> >>
> >> Also, I'm not sure about ZONE_DEVICE memory, very likely we never
> >> allocate a page_ext for them?
> >>
> >> I'd assume both cases are not relevant for your use case, though.
> >>
> >
> >  From my understanding, in that case, page_ext_get() will return NULL.
> >
> > So, as long as struct page exists, page_ext_get won't misbehave.
> >
> > I am not sure about offline memory, but MMIO can be used. We use
> > pfn_valid() before getting the struct page that we pass to page_ext.
> > Would that be OK?
> It's tricky. If you look at lookup_page_ext(), it relies on extracting
> the pfn+nid from the "struct page".
>
> If the "struct page" is uninitialized (e.g., offline memory) that cannot
> possibly work, as it could just give you random garbage.
>
> (note that there are two implementations of lookup_page_ext(), both
> extracting the PFN but only one extracting the NID).
>

I see, thanks for the clarification.

I see that pfn_to_online_page() exits, which seems to handle online
memory and ZONE_DEVICE. Would that be a suitable alternative?

Would you have a problem if we added a new function in page_ext
"page_ext_from_phys()" as Jason suggested?

Thanks,
Mostafa


Thanks,
Mostafa

> --
> Cheers
>
> David
>

