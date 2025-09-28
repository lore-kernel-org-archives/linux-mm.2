Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C152CCAC5BD
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246A18E0003; Sat, 27 Sep 2025 22:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D468E0001; Sat, 27 Sep 2025 22:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159D88E0003; Sat, 27 Sep 2025 22:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 032218E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:22:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88FC544224
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:22:16 +0000 (UTC)
X-FDA: 83937059472.05.F9958C1
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id B408840003
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:22:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/aZzLzU";
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759026134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDD4e48s5XfMjI/dpKcLLXxzREK+rG19jnnaqnwWIvw=;
	b=rSmldGjkI1+h6YBnYnD6MTCVRal3ChIb7Ra1ihIsHCSsccRPS9SuP/Yzm4Wi7Rsh4LnXPf
	uEucC/DOqhzk7/0VMm1D0i3SxcPGivZwPw5oUVLPPyVZf4N09Cx27XezfkBDKDwVTCkdrN
	8YDu8SLVmL18PX4lM6sEuzZ8Du2D6Is=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/aZzLzU";
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759026134; a=rsa-sha256;
	cv=none;
	b=5HuaYhZ6hJhZoen/VnaYB+LJylv9KbB6BYyMEKj1DXz1M+h1CjhRDgVwtEEVHwGQyEXJH+
	LgvJqmG9Sm5HT/psXUbXRwNNK9gYnR5Oz+cmhdsMHbpxxtoBwYwXa/crW15CEmec8O3ZiI
	PfbofXTgI9aE4Sazw6CD/prwActrGDg=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7ea50f94045so42492276d6.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759026134; x=1759630934; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDD4e48s5XfMjI/dpKcLLXxzREK+rG19jnnaqnwWIvw=;
        b=M/aZzLzU8k4FBgmS7QG93yo8FYIsMDNgopWk05pNFVl4UGqzKY4lsHEdG0sD0coqgY
         gEISSuIHxBKNclQ48iOnz6iEWcyOHaUYtU1goKkR8mAYRUhFkuRe5iLeSMd4hUzg5yHs
         8Wyvvde/t7vb97+Vz61PMUUWNgD4GIb3kzukTwoV8y+vnWTorMUAJFKzQmk+LmRXvBkQ
         Dbe/OI9JVPUnoFLhhnlWnKK2xzc3xHzLgJWKYacXdbzbJ6X58Rn5JBwTlJQxSnLor/Qe
         9cQa7r2bEGjMjzjQTmnep8oqx0ce/6nf4iVHNKQBwZGjXfeT9dVNlJZHmZfd04b5uFxX
         6WSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759026134; x=1759630934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rDD4e48s5XfMjI/dpKcLLXxzREK+rG19jnnaqnwWIvw=;
        b=lliHJD3thAgtg6SUh5MPG2JSyJ57W9LM9Xbk/ZjwDzBp80syeSMRB4CfKBqH4jUfSD
         j3W52Mq3ygCfkmbEJNEFxTUyuF3+PAh8pXUvoFiPkE31Q7A2ZsBaxLBH+N71GMY4l9BJ
         QjAXz56enLrWADInFHZRMmbfILM7o+4MMXZvhtcbS6uvjZH586AEEudKyIAxfTVR4FHa
         VreTmitRbmHa/ZWCSEfI2F10jwZZJotuKso7QxMhK04JlNmAeLsEseSP5Tmg9V34/XoR
         U+5KxvNI4fvfYo8iZvQutfyq/ES9uPiQ7/vWgo6+H285fIzpMcA7/Hhz1Q78MjcZwKE/
         4UoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlwwl4QtGe9/uST8+kHrnuuPV2uQh/o//9xeAUAQgxCYrE2morS5S8uhiXQ36pQNrNRizJMHvs0Q==@kvack.org
X-Gm-Message-State: AOJu0Yz2Lmix5QwUbheplcTAS23cAmRguEwy36LZym/LmDCIqen3OsuG
	2BBdDsSonjB+t4/6Sedss/renUIgNRC8N5gfGesCv2vz25r2mWAjSMOfR+UgVYCES4L4YdSbltO
	q3ryPwuWR9z5zpVEZmr/HW4x2vWrTtso=
X-Gm-Gg: ASbGncstFjG8XNfdqIep1Bv8v7S2uVtZM54N6vlroaHC83cEkjRjgkjt1NAsqK+2MNi
	yIJU1lQgbGz0QKsPJGM9h01tvPh5PkdshP1cVRM3fUrrOPAEGfV9CKaQm+821h0HJzGZlS8Bzge
	KGD4nX/El/wZ6VXpNSlYVAkuWPaCzu6UZvSeTWNWwkRyrrYiysDPShUYIsRotuNmZW76zGcRU6A
	S1HpLlYWW+AbwlygM3RDtEdAZ9WbH6btVHiFEdz
X-Google-Smtp-Source: AGHT+IFyNx87WkucEh4IUe144Snnrs8UIvE2HHg9WmEgjBihbVbfffswex+Qoi5vAf0JBbS7kN+nkcwu/mGzgjpLhIk=
X-Received: by 2002:a05:6214:518a:b0:78d:4452:754d with SMTP id
 6a1803df08f44-800f448ed2amr147929456d6.13.1759026133538; Sat, 27 Sep 2025
 19:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250926093343.1000-1-laoar.shao@gmail.com> <20250926093343.1000-2-laoar.shao@gmail.com>
 <34a9440f-b0c4-4f76-a2ac-f88b54c2242e@gmail.com>
In-Reply-To: <34a9440f-b0c4-4f76-a2ac-f88b54c2242e@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 28 Sep 2025 10:21:37 +0800
X-Gm-Features: AS18NWCHyMM-LHN0Py29bv_E4OCzemb4p3lZQK86XhDW5EVePduz12uMvfCrD14
Message-ID: <CALOAHbD8tup+4DbQ6tMzDxk=XkhW1t6B2L8+k8nP-1wg2zoXqA@mail.gmail.com>
Subject: Re: [PATCH v8 mm-new 01/12] mm: thp: remove disabled task from khugepaged_mm_slot
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jh4ax86e4iybguwzqhgepcrsbgocczar
X-Rspam-User: 
X-Rspamd-Queue-Id: B408840003
X-Rspamd-Server: rspam04
X-HE-Tag: 1759026134-792839
X-HE-Meta: U2FsdGVkX19b2HjTfti5UgWbmI0fsPuKB8YD7tYVcvoN/y0w6PjD6QXEnDPXGeOeTIxiyC2stOSDEwOhrQaXsHuIKsWBPQlBFEA6gocHJCldXbzsqcSWU1K5A9T/UQrYyourSB3iZGHQ0l23i9BI4FTQbZynEF58pJzJ0UD74B+bBQ+2sHLDwpyuqqW8L7LK4D4Dc9KKKHRQxi9v21qGmViISqJvURUaTdejgh0gspAigS6VIjXGqTp0m10TwpUlLIsVh/h5BDeg/fk1Y/jZL8ERZZxbRb9RbhZVv5ICKWYqwwoPYkHY3g3gkhEYaaTNoeD4FygaYWqRNB9ZUheizpFtvpkwYzsA/uAndIJBTR+Imx3+6VycytPCfVR4duZaul7I0RZWZgTSoyjjoKp2zooXzloNRFkglbgxn4R2MTEz9pDZe4ifi6TESrFdNx6AspLefG5q4nIqvh9X2CDDwhNFi/idGGSa6+1evJ1kElkc1oALgymUMM2706AwXyk2bkXoK/0wTdVZxivlUGslq73QkBI+gXsiCPJZpv9k/yu7hQiMcWvRL4wI7QbkDx/urDAlE7eFTR1CqJSyu7PD52uWRX2CsXAsKsb25Jab/hJTM70TZBmfCZ9XrEnHQ+PfWtszWMCVPewT6O9VqK4jZF54iNpX+qcKkuxLIK3IicaNfWEtLAH5n2xoUDsQ2g+mkKgi2zb7YDV1HaRJP6OP5+vFtLgCD7cvJdidYpYC8myrKe89/jJvCgvYmZaqhzWkYjm74STpwvkYwSl7koX3FRbakHL/9U1iVOLAluhaTlgJBmGoZAJqcwdhzLSR/Cw/zva/vqT8F8iqm7fdBuhkQvZM+67IQbxJtWRPzkG/HkI+qjXcC2YZb5Xh9vs334/iDtHfdH0Lbcr5cD3sQE35Dv/sOvQJYbuCZdqdyVSk7PW3t/PRNAnSXyxZP1YYgfCwpS1wE8UNzipMlZ7agKl
 3JrnfcYO
 sd+GJJh1kdamxx79w5ZdGADdZM46Y3m8Ie82vDGzc623fhMHEQF8HfAFBRqYXCqPIc8GJKUUMZOqaUpc+Lpq2STc+R5bU+eVdmwmDGmirgzW8c6lIpsgU1sybbwRLAVgcwx+uZ1QLSkHB2KyqnraaLdDAgWsc5HBpvmYHq8UrRSsqnz6ccUfG2IeaXnviyLNAM6nbCRsJ3T3wzhTeVE2l+FUZR/oVxbf4de7w+HDgov1s8MmORO0Ogi/b6STHbbEP++6riGgLIRz2dHKAX1CSz6rrZ29deA9HEteCCW9j5lPGYPjBT7JCLh9KczzBiL3pl1KbqTqgfK9jOSFFUUU3Nr6+je5WLTnbZkvwDvc3HfTexwFxgMbfYbTwDFPtQ70daMwolmmjsmktf3GYZfbU8GtIR8yCa/+6cpIMDdSM4hE9AXf9lk0F/qX2ptnPb9RdCKWL+LzKNr3ymtFzkhYq1q+OpVm2QdBhYZujkSvQwX96WI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 10:11=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 26/09/2025 10:33, Yafang Shao wrote:
> > Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it =
from
> > the khugepaged_mm_slot to stop khugepaged from processing it.
> >
> > After this change, the following semantic relationship always holds:
> >
> >   MMF_VM_HUGEPAGE is set     =3D=3D task is in khugepaged mm_slot
> >   MMF_VM_HUGEPAGE is not set =3D=3D task is not in khugepaged mm_slot
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Lance Yang <lance.yang@linux.dev>
> > ---
> >  include/linux/khugepaged.h |  4 ++++
> >  kernel/sys.c               |  7 ++++--
> >  mm/khugepaged.c            | 49 ++++++++++++++++++++------------------
> >  3 files changed, 35 insertions(+), 25 deletions(-)
> >
>
>
> Hi Yafang,
>
> Thanks for the patch! Sorry wasnt able to review the previous revisions.
>
> I think it would be good to separate this patch out of the series?

right. This commit is independent of this series. I will send it seperately=
.

> It would make the review of this series shorter and this patch can be mer=
ged independently.
>
> In the commit message, we also need to write explicitly that when prctl
> PR_SET_THP_DISABLE is cleared, the mm is added back for khugepaged to con=
sider.

ack.

>
> Could you also mention in the commit message why the BUG was turned into =
WARN?
>

I believe we should replace VM_BUG_ON_MM() with VM_WARN_ON_MM() [0]. A
warning is sufficient for debugging in this context.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/deprecated.rst#n32

--=20
Regards
Yafang

