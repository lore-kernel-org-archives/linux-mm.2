Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D70CCA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 02:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEFC8E0008; Wed,  3 Sep 2025 22:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F558E0001; Wed,  3 Sep 2025 22:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DC98E0008; Wed,  3 Sep 2025 22:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4658E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:45:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0B18BC5BF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:45:22 +0000 (UTC)
X-FDA: 83850026484.03.DF0FBE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 99D0B40006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:45:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OYKK/IYS";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756953920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPxCu9vKoeVGljjV+zdc6Z80QMxQJE+zOXw3nyK4sH4=;
	b=0G/kSnQj1/RCSwG+7uE8C2hxyywrUYc9wE0vacdZf4I0yvfNtHVB8o9ml8QPnTKLI1a5qd
	s+NvFqyp0Uw2hARxr21aaf1jUyQ5iWS/t42aZoI2U4KFZAsFZk2Z5zvzSp7N4gOLifpuxd
	E1Zmvx1I2qmhhwampk7F9+Z4glRTAMA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OYKK/IYS";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756953920; a=rsa-sha256;
	cv=none;
	b=t6Mdyf0I4oFVauaotI24Cc72jFgmjcUVSNpQS9asfeW7+D/Wo30dkCad6ehJQt+wE/JKhq
	m/4J4bt4FcHEJXuLv1zIQJcv0LKNUcu3gZHKNlwqKPVkb4CDqnyl27KIWDuqYSVZKgo0CH
	zaR07p9SKX8HkgyQUVWoWUTsy22uSDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756953919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vPxCu9vKoeVGljjV+zdc6Z80QMxQJE+zOXw3nyK4sH4=;
	b=OYKK/IYS9ervobvLRVuQuYdFhr3Tw6IU+rZMr1GEl2JLPYXRr1il+X223BfqvnTqWG4tDW
	s3c8zkT98N5X+QJWk2C12NLnueO2nhlhgw7LakljjtZhK9LSLLeWFlaHic+Nb7C5tIwTNz
	ZCHP54ZsRh/BeA41zXeihDxK5tMteqk=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-KMe9HFEcMkmxjP9cftimFw-1; Wed, 03 Sep 2025 22:45:16 -0400
X-MC-Unique: KMe9HFEcMkmxjP9cftimFw-1
X-Mimecast-MFC-AGG-ID: KMe9HFEcMkmxjP9cftimFw_1756953916
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7238c2008b8so9456937b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 19:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756953916; x=1757558716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPxCu9vKoeVGljjV+zdc6Z80QMxQJE+zOXw3nyK4sH4=;
        b=ur1GVnI52N8gOJb4eoBhRUkoRPGPcqqTmGmR5pV2E5HcIvHYRNfN7VVVQT/d/ApW1L
         Osi39L2Tf6whHxTKbqp+6Ptfowc3XkvCohINSua3yS4DOtLMD4jhQpj+E/GglVWNFRI7
         EDt/3lLmBYachrpE3fwV2JveQf7wkeiogpseEAtfKdC8PCFEECVTnvnH4omPz3EsglHx
         sMS7DVrfnT4kC2e539fZ5p3sFmVL4wG/CVJFBfNnHiZA1TYneuGV7J1hMtiCs2Of/s52
         pFbbrudVp3OUn8pVREzukYyBjmMuVRipMueNxG+ynvKkcs6fdseOlbTaTSu+jMUA1Qhk
         rKJA==
X-Forwarded-Encrypted: i=1; AJvYcCXxb4Y2cfgTJ96oSrQNwz0OM6npTcR1UHoFeC1sSCqmsurFQA8nZAWhdTmHTVo5cQ2HLs/mObm4qg==@kvack.org
X-Gm-Message-State: AOJu0Yxs4JilfjWjUgFhH6MEBr+j1zszyVSKTdBcr154AK5oQ8XOY1/+
	kkkEncDTZlWU2Xh3j/CX+JlVwwOx8UohiWUKYgVciEEz3XhGSiN2ucBmC4C5S+I5/N73w5gqJaq
	btsD4W6GZi+1nsnKbb9VaMNzgb4FC/hClMUgTOLmbpRS31/KPtpv51E4SqlKb0Z6Iz13lUS89to
	KK8qk93bBX6hkrjPWvmtdlg5Azo88=
X-Gm-Gg: ASbGncuARkhpAT8WsDUssd9QodNk/jF8iIHBwY/PRfjZxv3LScguWeKBRZiXZgN+O9Z
	/bAAHrjp+JePQ5dRP/+c6DKNqHbtMAoGBzEWgxrWMeXZvzzpFvPKmU2OjehTr7lH+D3tqOLZlvK
	Dks3uKmzo7nAIbBgrAfnESh20BjnSywolnAnw=
X-Received: by 2002:a05:690e:2505:10b0:604:3ec3:621f with SMTP id 956f58d0204a3-6043ec3697fmr1929429d50.11.1756953915875;
        Wed, 03 Sep 2025 19:45:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGX0I7zxt7UAjC+8zhaIcnRAoNKfZBZRVzfF1SdLbX7NsNViAzDXLJ8goQlVtnL8b6l8mfbAHDzM/108cubFk=
X-Received: by 2002:a05:690e:2505:10b0:604:3ec3:621f with SMTP id
 956f58d0204a3-6043ec3697fmr1929398d50.11.1756953915472; Wed, 03 Sep 2025
 19:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com> <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local> <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
In-Reply-To: <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 3 Sep 2025 20:44:49 -0600
X-Gm-Features: Ac12FXzRQLYo9kZFI3Qk7n_u81yp4P3AXqlGuLWUAY0EAnPSUHNRv8g5odcdF08
Message-ID: <CAA1CXcBVR=L5_6x5FGeR693AB_YqEF=4KAX7_2fRgGNa1j1j9A@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XlNEFRRf05uf3kU5nShIh09f_PX4o2FsYzsEWhc6kGc_1756953916
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99D0B40006
X-Stat-Signature: 5orh51acsc4nwkn6zuz75jezhjchmtsk
X-Rspam-User: 
X-HE-Tag: 1756953920-447316
X-HE-Meta: U2FsdGVkX1/0v76jOo9jdSjM3bgPimow5T9oOJiXBhoEVeJQhy/p/7y3F6wJF2uNJbtz0c7zBYzNRBxCtQbAv6MgHm5jKzUNIiAwOQCz1w5EWMZeGZ5m1ehAA9IU421qpCQq487NpkbViCZv3whJ3MhVo5Y9JVwjaSZHp4XL0SiyyDXyFcztj9NjtHOQTy30VcHxDpiAIC43DseCBoHpbEV1VVHGtxG6FfCxRZK8iXXi9U4CHZtZcRYEdQhx1T33v2XNkbcME66rfKekQVt0X95ofYWc+euol4WaQAM5zu/13wAGpJQDtH7vI4gzxR3ZbywGAbxMmJyxiTEdOBeNgErzejbtN0wocnPQbhSZGIaSl7Kqeww/mYLQenlAov0aEgiHK7CiIgwj07l5GH/mLHTYs/5B4V7FnO194l6VqfIuyfl4J1k2BN0DApX16Tr01EuJPpimt4HqECtUiIc/x4RvLdjCk2S/2tZNdwFnn6npv60CcPbC0HG9ZjdijLgrb/eXQ7Y4IrV6y4QMZwCC8lr8HxZ01deS/oldtdHNr5YqAKc8dAW0l+bgbecG1Czw3nG+X5JXsldD2nEVWiXnBBoqHyjkCPn8kFjSVxAG7p5PIgU450wmOnXPxptVLuiydHzbGvJ7RCJ/3tXH0mtOyATTCBbKeqL9ivcT4nkPJD/DVU9LZ2tFNrd6AMKUIEBcRXlSdV+1OLwJQ8X46blC8hc4Rp/vne0/8yMx+qvKU77H+ZrNc5pKAWidc9Y9mNY2ysTSwCWXzNgThMl1BhgKUyfdfoZyEWMdsydSnVvMVsgxR6RQHruY1fF+Trv3T3WkoRt67tS+2LQMHLnKQzgbf2SvimVVvMd5XNBRGDpkGokuy3YPjIEg+iGWPWLHfhbmvGJ+gfFJyQ+4bS+km10VQ0MYC+OmpmeQqb9toWqNnTnTRPNFm4m2sohZaDjmwqOkGMpgJqP66xzsnw3lAUA
 IAOyexVk
 flmg79IFFVUD3sTtgdAwtSgH6X7m2og+ph64R5Gj8Q8OKtCOIlCB+I6sUeKyxMn3qz6SB/Rivl+vD/XVdqZP9a9FUFYA6JuUIOEiJ4tCXWFpjnjKv/1NMBRaKcLm6nXoxbm6rYzkXVN666hKLWG8GPUBiZ7Fnjbe7B6w46mYBNW5pw0QA+qYyz6nnlxYF7auQv3gRehG59mxaxFUCwfD5WRmUxeS3xbkfXcZ9Dgru/5bwyPKRHW1aLuS4NR+k37hAzJJpyGf6/C+f58kF35wsA3riwdSOOcCEe3FLXneozvm5fNUBdRQnjq5GK2J8JHha/ekg4Zfhd0s+DYxYTde84oOl+t77mJh2Eizj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:55=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 21, 2025 at 10:46:18AM -0600, Nico Pache wrote:
> > > > > > Thanks and I"ll have a look, but this series is unmergeable wit=
h a broken
> > > > > > default in
> > > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_no=
ne_ratio
> > > > > > sorry.
> > > > > >
> > > > > > We need to have a new tunable as far as I can tell. I also find=
 the use of
> > > > > > this PMD-specific value as an arbitrary way of expressing a rat=
io pretty
> > > > > > gross.
> > > > > The first thing that comes to mind is that we can pin max_ptes_no=
ne to
> > > > > 255 if it exceeds 255. It's worth noting that the issue occurs on=
ly
> > > > > for adjacently enabled mTHP sizes.
> > >
> > > No! Presumably the default of 511 (for PMDs with 512 entries) is set =
for a
> > > reason, arbitrarily changing this to suit a specific case seems crazy=
 no?
> > We wouldn't be changing it for PMD collapse, just for the new
> > behavior. At 511, no mTHP collapses would ever occur anyways, unless
> > you have 2MB disabled and other mTHP sizes enabled. Technically at 511
> > only the highest enabled order always gets collapsed.
> >
> > Ive also argued in the past that 511 is a terrible default for
> > anything other than thp.enabled=3Dalways, but that's a whole other can
> > of worms we dont need to discuss now.
> >
> > with this cap of 255, the PMD scan/collapse would work as intended,
> > then in mTHP collapses we would never introduce this undesired
> > behavior. We've discussed before that this would be a hard problem to
> > solve without introducing some expensive way of tracking what has
> > already been through a collapse, and that doesnt even consider what
> > happens if things change or are unmapped, and rescanning that section
> > would be helpful. So having a strictly enforced limit of 255 actually
> > seems like a good idea to me, as it completely avoids the undesired
> > behavior and does not require the admins to be aware of such an issue.
> >
> > Another thought similar to what (IIRC) Dev has mentioned before, if we
> > have max_ptes_none > 255 then we only consider collapses to the
> > largest enabled order, that way no creep to the largest enabled order
> > would occur in the first place, and we would get there straight away.
> >
> > To me one of these two solutions seem sane in the context of what we
> > are dealing with.
> > >
> > > > >
> > > > > ie)
> > > > > if order!=3DHPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
> > > > >       temp_max_ptes_none =3D 255;
> > > > Oh and my second point, introducing a new tunable to control mTHP
> > > > collapse may become exceedingly complex from a tuning and code
> > > > management standpoint.
> > >
> > > Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per=
 PMD) /
> > > PMD) 'except please don't set to the usual default when using mTHP' a=
nd it's
> > > currently default-broken.
> > >
> > > I'm really not sure how that is simpler than a seprate tunable that c=
an be
> > > expressed as a ratio (e.g. percentage) that actually makes some kind =
of sense?
> > I agree that the current tunable wasn't designed for this, but we
> > tried to come up with something that leverages the tunable we have to
> > avoid new tunables and added complexity.
> > >
> > > And we can make anything workable from a code management point of vie=
w by
> > > refactoring/developing appropriately.
> > What happens if max_ptes_none =3D 0 and the ratio is 50% - 1 pte
> > (ideally the max number)? seems like we would be saying we want no new
> > none pages, but also to allow new none pages. To me that seems equally
> > broken and more confusing than just taking a scale of the current
> > number (now with a cap).
> >
> >
>
> The one thing we absolutely cannot have is a default that causes this
> 'creeping' behaviour. This feels like shipping something that is broken a=
nd
> alluding to it in the documentation.
Ok I've put a lot of thought and time into this and came up with a solution=
.

Here is what I currently have tested and would like to proposing:

- Expand bitmap to HPAGE_PMD_NR (512)*, this increases the accuracy of
the max_pte_none handling, and removes a lot of inaccuracies caused by
the compression into 128 bits that was being done. This also makes the
code a lot easier to understand.

- When attempting mTHP level collapses cap max_ptes_none to 255 to
prevent the creep issue

Ive tested this and found this performs better than my previous
version, allows for more granular control via max_ptes_none, and
prevents the creep issue without any admin knowledge needed.

I think this is a good middle ground between completely disabling the
fine tune control, and doing a better job at mitigating
misconfiguration.

**Baolin actually also expands the bitmap to 512 in his khugepaged
collapse file mTHP support patchset

Does this sound reasonable to you?

-- Nico
>
> I spoke to David off-list and he gave some insight into this and perhaps
> some reasonable means of avoiding an additional tunable.
>
> I don't want to rehash what he said as I think it's more productive for h=
im
> to reply when he has time but broadly I think how we handle this needs
> careful consideration.
>
> To me it's clear that some sense of ratio is just immediately very very
> confusing, but then again this interface is already confusing, as with mu=
ch
> of THP.
>
> Anyway I'll let David respond here so we don't loop around before he has =
a
> chance to add his input.
>
> Cheers, Lorenzo
>


