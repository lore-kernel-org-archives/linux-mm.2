Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E93EDEBEF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E326B0089; Tue,  3 Mar 2026 15:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC0A6B008A; Tue,  3 Mar 2026 15:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794006B0092; Tue,  3 Mar 2026 15:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD376B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:30:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED8F314032D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:30:21 +0000 (UTC)
X-FDA: 84505894242.16.8CFC0B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9937C1C0015
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:30:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAM1OSNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772569819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6X5E3EA0BxvtH6LFoW8x8XP8ftPAQ67t8wjpluEB3c=;
	b=lqUwJFK+IPWqyZth333iPpG8XzRiObEy3o/siaWeoldDQ99vtglTkowtM+EF1k2kDxXrfs
	x5Ukv5DNaA8zPX+FvM4yIit37e95gg3L3gyMBGsziJYBcTGEOOxJ3pfYvAmQhp026A8nyg
	szZwMLxFmdeOzoV8ML+DxWiODyGZZVw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAM1OSNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772569819; a=rsa-sha256;
	cv=none;
	b=yRCSjxcHc1kOuKJ9IXLr/BqtXJgqwrlCGo1ZkGbii6cHxL1wmm7GE3m1zeVds/Y18B3sU4
	lkBai4NyS2NnNtGLXEGU8lmh7MHSGHNHy7CFgiFauiylpH2cR5dlB6WsTEBvGi4ir4tigp
	CdD7eKL5fRJQc9YrhE+nC5S45ibDDR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772569818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6X5E3EA0BxvtH6LFoW8x8XP8ftPAQ67t8wjpluEB3c=;
	b=MAM1OSNiEHJINDetFJzJb3TiU/vkDbnWWcEhyAanRedvOHVy7miHqv3h/NWCDJdQjO5brI
	5finWLDrQIoaKk4EeC/gfyND29uzGAdj/4emUmVFj+20UQAUnUtA8JrLePBqTtJOrjpGR7
	dg3vGtBmkLxTLHBJH24ll38e9N1DIZM=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-4XFsWU9VOYOWHky0G6bxHQ-1; Tue, 03 Mar 2026 15:30:17 -0500
X-MC-Unique: 4XFsWU9VOYOWHky0G6bxHQ-1
X-Mimecast-MFC-AGG-ID: 4XFsWU9VOYOWHky0G6bxHQ_1772569817
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-794c39ea759so109547717b3.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 12:30:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772569817; x=1773174617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z6X5E3EA0BxvtH6LFoW8x8XP8ftPAQ67t8wjpluEB3c=;
        b=tuWrvuL60Xmu2C8cW3i4Udrc6EL381LxxSZ1Jy81vnej5s+BwEc3PaLdSr0ckKMT9o
         I0EyZVj9dNFGnpmSFodKMfasZKSFxsumI8qoeXYJ9gtQG4O7ADZBxCeU6FY4ITI7fD1J
         bg7qZ0qjDtCsSShntBkWn8Hd85MNra4/GzdhiqAujqzcIBR7zdkgA8cko3tjgwlIlHVq
         Ke0xEiuoYH80zRD1QhCARjAec0DxQXaEz/93UwAFZ8CGy1ZjJF5kkWds2vrCnCaj0s4s
         n7iGmauBdNcUx7lzlfHRJgNAUr9uuZ4+0TpO6K5XRpy7oP6mrGJm3nHCyWPgZ7F9pIJl
         ZLXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgHH3tF1ctD6fPhPtHgmY9G2C51bexIg3BsGu702Cq54t7LpT1jUYi46Yj0ZFQaE5tcrhwpBQa/A==@kvack.org
X-Gm-Message-State: AOJu0YzCLF4fP+hq99N378dCRfuv9iKtcxttdE9Omh8NYx86I2JDIvUH
	QRcBr5JRxwRetIRZUOo1WcQ/OLsi1CNCD291VEOCMdBplLPIMTg8oL7IUVWEKpQqzzySLb9cuzx
	8QXJFFP3iZqaI174Ph8sYpdEqUG6bGqklUBLuFhEMzxno6ZcYtZhV3P1+aESAaGngcmwi6QyHJX
	98GqD7dysMR6t5J4CAZey/2cv1Fk0=
X-Gm-Gg: ATEYQzxzWXZ1lsHCKs6BmGuphxgr3v3atX4tk6JopniNBGC3KJmj3qh3jpxlTUMMDDU
	tKd250weXNg6T4V9fyL+qGH/n8nZaeYlBuTOGQNhxeyBArvHXSN+OUrf239ybcrcIbymdQh8285
	lO+gs6nGgHQhzGJ/Uy2qzyU+n/+pq3yni77vTDE03wCOj7gkX8MxSBmB7PF0P4hsjAEk4zLQ2Xd
	WJd
X-Received: by 2002:a05:690e:bcf:b0:64a:db39:f010 with SMTP id 956f58d0204a3-64cc1f34d1dmr14893871d50.0.1772569816861;
        Tue, 03 Mar 2026 12:30:16 -0800 (PST)
X-Received: by 2002:a05:690e:bcf:b0:64a:db39:f010 with SMTP id
 956f58d0204a3-64cc1f34d1dmr14893811d50.0.1772569816232; Tue, 03 Mar 2026
 12:30:16 -0800 (PST)
MIME-Version: 1.0
References: <20260226012929.169479-1-npache@redhat.com> <20260226012929.169479-4-npache@redhat.com>
 <25723c0f-c702-44ad-93e9-1056313680cd@kernel.org> <CAA1CXcDYc0=_=BiFDJXQ6KwjZZB6TYwykW_c8ZhocfEZw=MXbA@mail.gmail.com>
 <0421d482-a2b0-420c-b83f-1cc057d6662a@kernel.org>
In-Reply-To: <0421d482-a2b0-420c-b83f-1cc057d6662a@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 3 Mar 2026 13:29:47 -0700
X-Gm-Features: AaiRm52wsoZnP7uPLaOh2G5LImV-hzDx9TaDGRG6Fh4Po-vgQKPJJrvFAeGABZw
Message-ID: <CAA1CXcC5nW+ytJGFUf_s-Ve_AxLCB7Xhj8askdELdOVdTkcvyQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
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
X-Mimecast-MFC-PROC-ID: z1j7Cl-3ZjMITIOVUIY1OoyE5sgWpza07A03uDFNI4I_1772569817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9937C1C0015
X-Stat-Signature: kx8dtxpi1wygj9d8ra4emsyksnwnh1yd
X-Rspam-User: 
X-HE-Tag: 1772569819-40445
X-HE-Meta: U2FsdGVkX1/fRaGwU2QWwPdZweu1/GX8gjROVLv+bVWglRnfE35DoPvd+CyAepS5C0BtM4EoDpAsg/Ca6az3Dbkda16BCb2cEE7TAMClNvgrIqLqj1vnqWMCxIkdoEKGBN81eEt+JMStuecDrtvmTy599wv5ViaIpWGxUPJl1CuwHb5lcqrbWXgPXOt8HB+8zXchS5bFrGciy6U5565MzY2peOlaLxaX8dwKc7dTww9/9POczlVfBYFiOjTfQerbgAGySeM/A29SB9Wk3tEvtLGXyvYkITqAAkkHck5+FgKwMgDKnJinGaFLfKJpNUuDVoa1/N0RJAr0Awl9XK4RHd+X1ny5qJh7eaOp6milAaAH6Q9ihagXrFUsqv3Mu9JvZDLIGwCbrPLJB76PcX2PBe+Dzh4zDBpyXEuoFv0yeZuUCdaWBDhqj72055nLKunzaLdckD7qs4YE3Ddsq/YkXcpQXLfJhARTYReUHcYuSNf5xg7jdZgCG8oyWmJdJ8aYHVRvf8ujyzV6cQ3yzdkOm+dxjBSgq4Q11ssK0iBwWCLxqi4C9/WPp0kPcdJj7hikr0B2ldSgjfLG425G84NuedfeODE/jQmSMtVxknQZxrAArYspH7lSINcjG1NSOtYRVD+RVvW7v5btKqeA+TDF+i40POlDdEFkEoJtSIzMd/daQ/AwWEpLrwF/Kwlpd7UfIgvC9PUX1aiiv2u3MlkS1PUO3JIB7ZiRjeA7MZqtgtXJcJBHz1bMeaPqOt/8MwIlH8TghvL0a5Barqo08splK2zosWrJmAX+LQ5M+BvrT0tW+Q/0tBLseqwMKTnAsD9SnPh249CFO6xaiZoULbNMcqTVb+QppeoP0LoPCwcqmWqyBXADatufDN4d7uxeAYEhrwc6pQUOTfJf5QHMU9LaJt6fKRDdy2g3ukldw3TLzEWkt9edhM9O3MvyBvFtn4YDlXQktjBKCnB53DUJQk6
 rUMXMPd3
 3FHt+RVTDAYfR5cAKfxX8SB2TX1M08YHNda+Img4lJLQ70p5z5bd6Ki4SSx/hi06AKj0e8szLrBOQ1LcDf68I/aZfXrvjDLquZbBmldmHzJHwIN4fsw3ZYvsH341pel+vfBqWZZ7SPWWTy7yYvzz/NsuL1lZpPpEi5ZVba3y6NPp02Y9FDGOildH9IrTFg1qSuR29Ew2o0jYXFcerSTciN/VsngAWQ63NLGG00qtRpuOKwWcoba/sIiZ/V7PxS4Z5GGxGvrUzQskVGI1XfcZm+9stbK8Q7y6nbZJs3X5HfVBcpiY0W9kvx73yqihwRa3Nx7etOLJJ1dXBQdNffnVa/S3+iBExRKeh2shUHyNFimO067GPaSYvpuZ7mKpp3ivU9SmoRlSFtfAiOA9Imri6eqo6a0x9LYPqTuWdt7sqGaYxcqvhVv01i+2/3u2JysmGJQBnRtbH9WHyCLDGHJ+ngYhcBPqHzPZQ/3jy+w9zCUaGOWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 1:53=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 21:17, Nico Pache wrote:
> > On Thu, Feb 26, 2026 at 2:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/26/26 02:29, Nico Pache wrote:
> >>> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> >>> signify the limit of the max_ptes_* values. Add a define for this to
> >>> increase code readability and reuse.
> >>>
> >>> Acked-by: Pedro Falcato <pfalcato@suse.de>
> >>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Nico Pache <npache@redhat.com>
> >>> ---
> >>>  mm/khugepaged.c | 9 +++++----
> >>>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 2ef4b972470b..4615f34911d1 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
> >>>   *
> >>>   * Note that these are only respected if collapse was initiated by k=
hugepaged.
> >>>   */
> >>> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
> >>
> >> I'd call it "KHUGEPAGED_MAX_PTES_LIMIT", because it's khugepaged
> >> specific (no madvise) and matches the parameters.
> >
> > Ok before changing that, note that this is also leveraged in the mTHP
> > set. It's technically used for madvise collapse because when it's not
> > khugepaged we set max_ptes_none=3D 511.
>
> It's more about disabling that parameter, right?

Yeah, we conditionally set `max_ptes_none =3D ..._MAX_PTES_LIMIT` for
the case where no pte limit should be enforced.

-- Nico

>
> --
> Cheers,
>
> David
>


