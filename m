Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211F7CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9988E0003; Thu, 28 Aug 2025 02:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A11A8E0001; Thu, 28 Aug 2025 02:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDE18E0003; Thu, 28 Aug 2025 02:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F24FC8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:09:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0D055C0B8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:09:36 +0000 (UTC)
X-FDA: 83825139552.26.8C51868
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2046F40016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:09:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l+/PgthA";
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756361375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irThEuCN+CJAqgmTRs026MQyU4oy4M2XOA9xvrhaZ+8=;
	b=IL8HrGzfa+PBF0grM151CT/P9HCAvmWyURyAw4v7twHiPq8rSdIhIPGTk/SxHi4CrfRyzI
	M436SJr7DPDrDSHq8dkZugLrLXNmHAw27ahcJIZoQbHukCra8P9xdQH2/xvUqEbgmsjjr5
	Hm36biYJ6u4GtqvC0+CKrtFiupQE3Ac=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l+/PgthA";
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756361375; a=rsa-sha256;
	cv=none;
	b=JVwafWeiFZQ7j+TSecTwTARCbLVa3DcmSKLxz0wDvpcgLc2Ml94eetS8P/BznLOA12C7V/
	c18n/27TVrUv5z1VjWQpcjAYq+2X21L5hy+TqTejAObvyCN+7QGWGt6/bdRvAsXsJv2ecM
	QG+eIxNN5rhA1clhK3FDjlBZavVIEKc=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70ddadde292so6336826d6.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756361374; x=1756966174; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irThEuCN+CJAqgmTRs026MQyU4oy4M2XOA9xvrhaZ+8=;
        b=l+/PgthA6Zi0DPnjlWR+AKMtxMfXce2wYTMgSows+o3kqsnPVsHBMqWNGNjB/b4CwB
         r6pnq7zo0OUwgYGiBliKjh3VTAv6Ui074yhAERJCuJOYBQjkzagKxwFBUJkbNuA9HxIT
         7NxgNS8aPliufH/1iVrNQaplu3EiK4uLXEwkdXQH4nL/lSF0ynvmVXBPIyRUPMV/HVkt
         5EBYP+htyBVuIRHFUtDt96BCdg5BA1sJ9TaPX/lkotOtJlc2zkHEcDmnkF0gbi94LWOG
         HT0IZQX/RT9HVhOj6wdnPTx+QIppjxobAuevm8bv99MPid3+XZxzTH9j45oJ15LhkZ1L
         /gTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756361374; x=1756966174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irThEuCN+CJAqgmTRs026MQyU4oy4M2XOA9xvrhaZ+8=;
        b=vWV9LSQhm/9lzzMPlp+Jt49AAhR0csGZcd9OMdxA5qbWf4I9mQagCRMkMSyLmXjzGQ
         PehYUkPqbOJXcyElYS2DDe+JOK+MAscN5J7I63xY8qQr0fTneJZi1klk3IxmPDQ7at/p
         TJswseX32agg1BnX7IzqhyrJuRP8Q2kyv0Wkp9p6tfZGVjFnyDuKQev9x6hCNCM4PJhL
         ysSsKwMbB/SbRSeNvjpmzCLhUWSkKHgqK/K379AQJ4ZPIzy77JP+PqOW75dD0LUmK9CD
         7pl1SBhbqtPfkA+J7HA7DBM8fFG0jSIo7LriLc5mpkANbQwVH0+wm5mmkn6FphIykFTj
         HgVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpEjACEjr8PYB8UGx8YQedQvkhVse/ci0aDSFp3Hz7j/RmRbWSItlHXwEnGhI5scp+SFnwzyCA4g==@kvack.org
X-Gm-Message-State: AOJu0YxqOiFaRMkpjMa8n5evG1e7fkwbGWuZNwUl232+5qbrgbTUjd90
	wuqZPd0eAwSNV8g+H3Rk5qNN4Ot6C4oWPTLc/r2HhBqt00xI0gyjdKFUTcml9O+4qwYqh73sZOs
	qi1nTaF/RPqUxr3k1TzWSdZFEkZcKg8E=
X-Gm-Gg: ASbGncvv0tbcjgxggbwfOQ6UKw67ogF0LWKzcwVr+c0b5d4zqi54VXs7qn7lWhX2tXf
	km9FBtddtAeDCESvXCg8gg97r6Os11zH2s0040khSLMfy8RSbu5LkxdyXoYIKKG23TwlxEubB71
	lXDiX4PETOYW+crdwE6HrnYBK/jHWkJLM9Y0XDArahh/+WWDASTufj9wv47uNpFtmx38iK8t19m
	AcrV58hKUtGb4CyJT4/lDeiXUY1+5ET7nbkZZA=
X-Google-Smtp-Source: AGHT+IEcc1wPCV34Pnn1u/ZsU4Rb1aY5zTIXLY6XmNlFFcithgRKC2hL9mmp5Due2o1Ite+lHeZgHeo0cfSWEsXPL9A=
X-Received: by 2002:a05:6214:3005:b0:70d:cecb:17db with SMTP id
 6a1803df08f44-70dcecb19c9mr100573286d6.63.1756361373826; Wed, 27 Aug 2025
 23:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-11-laoar.shao@gmail.com>
 <6934188d-12a5-4225-aaa9-828878d8dba2@lucifer.local>
In-Reply-To: <6934188d-12a5-4225-aaa9-828878d8dba2@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:08:57 +0800
X-Gm-Features: Ac12FXxzyoO7MGOQ-T37czdAMJrKQyvMPOFtYB1ymhcClovTUHLiAKI7h86q2_U
Message-ID: <CALOAHbCys+iz_8fwsPPZjqp+Y4+KMRbizPsjApX+v1JVGTy3oA@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 10/10] MAINTAINERS: add entry for BPF-based THP adjustment
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h9kqrnwi73wg5srgkck83czx4bujswsu
X-Rspam-User: 
X-Rspamd-Queue-Id: 2046F40016
X-Rspamd-Server: rspam01
X-HE-Tag: 1756361374-302902
X-HE-Meta: U2FsdGVkX195qwoeB1xMzCoWyMOPI8z+gVkoXG6PimGCSo0R+DV+6bUv/p3hea2gX44N6cLDK4Rj6keq1rapCw6wtDfZiqzoI821UrHZBn/eNUkBDt49dblCBUv55clErNmcArhPfWEF6pQx/KaPwAy7x9atVPVjrdU8qjkUgjX/gyZv+0scojN2Pc5hX/n+8mz1HnmSaiPnoKO6734NdysATd8melCdGERl1prrDq7Q15hRTrbvr6z4Bu5BSvKhEw6Svrf/5YxWh13zcPjiY5ToZs53JG+kdnufpjvjbQifjd6bQXZtVUKBX+6FiRqCslXwn+4ITH+2ondvq2e2YXvFKh8vrzdx+WQyZIt8j+VK/9E/g0NhMPxeCv1qxSr8FFInBbZlREyI+2aJK0SN+KIWmiHkK57V3eFXnR4gcIGKFXPX3dXMZ1O0fAIemGTCKIwA5buIcO0IPYfKSiBzmef33GGEI7vIjUczH7JY2dUreACczUWXs0GJOw0Z3CXVNLtrj7tmpoMg2c1Z5gpRWpMzHu9mLXsRfnMHRGTiD/IYXzD6sqaiBeo57OKPd6rErFeRUcI+VZlZhDrqoD4CZPUWyovHhBncUS/45lXmkwt/oJEYoNzl2U4LylsuJeS4+EW+gHo4NeGGp0d2BNM25mPY1VeQMwaOEL5eEWUVWl6V9WEUH8ML12sH3hPrhUX9o7yO00cHB8B8tC4J6F5r/4XYEGnQpats8a+vylofOe1aVX2ZqbCOcYDgG0wLXNyoTR3SzDMksZKKrjY+bu7HUL5mp742Nr1Pzb9bBPhu2ByBOmP93WJ96fzCWr2L5EoO8++FQo1f8DFWJh5IEIyM/BI6kT64hl6vTMHZYbIlEOouM6bDbWhAGmbya4iFwdUWReLAwQpuog/Hq3lBDUkoZdq60F2kdYlyJIJ+b9qx6QzUPOMtbI5KkIB/FEGS1DN3LGZ29I9oMKqlFG9wPsw
 OO3afE+A
 m06Qu7HcIK72Aana/xQagtZvgAZMhbY24rY7H4O/F7hNVyEzOAp5tZsbLHR8nRnA9PZ2b3QzwsjRr2HymaiKkBilcnyRMwl84T2RVW1xPwf1eI94fjEUycRMd7nNK/odYFG3xNdxRk5R2XBIG3I6A4bDa5u6ZCX9qAjLeL+PJT05C6KEkcYSeHa9IZb6O2vC6FzVBSR2n4pXAamPLQt+8QhP4ctWi5zLYfycbFFJpFJ04cGBLCQi4D4WuXoIDs6Am2yVqmPU4ox4jgerJJT6Ku8z2xUsiUuGY/AzcIUt1HLdRIQEPcECwNtarl3SVI8hHI6d6bGrwmGyjf156yIYfWr9OolZePLAvmRZrHAF7rtp+UYsxpzi6h2rUXJWQxy3wcSCorwaXWn/fOzPkUR58wolTb17PFhuG0f+7Hkk5qFvH0SbUI5h4XO/VaDF9ZctZgBrKdyt//1RvdnwIJkE4RJB9HURrPV4TmWNb13O3o2R2imzCMtvKRh6poDu76ZX1tJwDTrTFOuWU63E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:47=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:48PM +0800, Yafang Shao wrote:
> > Add maintainership entry for the experimental BPF-driven THP adjustment
> > feature. This experimental component may be removed in future releases.
> > I will help with maintenance tasks for this feature during its developm=
ent
> > lifecycle.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  MAINTAINERS | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 390829ae9803..71d0f7c58ce8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16239,6 +16239,7 @@ F:    Documentation/admin-guide/mm/transhuge.rs=
t
> >  F:   include/linux/huge_mm.h
> >  F:   include/linux/khugepaged.h
> >  F:   include/trace/events/huge_memory.h
> > +F:   mm/bpf_thp.c
> >  F:   mm/huge_memory.c
> >  F:   mm/khugepaged.c
> >  F:   mm/mm_slot.h
> > @@ -16246,6 +16247,15 @@ F:   tools/testing/selftests/mm/khugepaged.c
> >  F:   tools/testing/selftests/mm/split_huge_page_test.c
> >  F:   tools/testing/selftests/mm/transhuge-stress.c
> >
> > +MEMORY MANAGEMENT - THP WITH BPF SUPPORT
> > +M:   Yafang Shao <laoar.shao@gmail.com>
> > +L:   bpf@vger.kernel.org
> > +L:   linux-mm@kvack.org
> > +S:   Maintained
> > +F:   mm/bpf_thp.c
> > +F:   tools/testing/selftests/bpf/prog_tests/thp_adjust.c
> > +F:   tools/testing/selftests/bpf/progs/test_thp_adjust*
> > +
>
> Sorry but I don't agree with a separate section for this.
>
> This should form part of the THP section only, I don't think it's warrant=
ed to
> do elsewise.

I initially added it as a separate entry to ensure that
bpf@vger.kernel.org would be CCed. However, I discovered that any file
containing =E2=80=9Cbpf=E2=80=9D will automatically CC that list. Therefore=
, it=E2=80=99s fine
to include this under the THP entry instead.


--=20
Regards
Yafang

