Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D73BCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 09:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967DB8E0011; Tue,  7 Oct 2025 05:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F158E0005; Tue,  7 Oct 2025 05:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BAE8E0011; Tue,  7 Oct 2025 05:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788908E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:05:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0920211AF38
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:05:49 +0000 (UTC)
X-FDA: 83970735618.11.885BC72
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DEF2C0008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:05:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmmO8cHf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759827946; a=rsa-sha256;
	cv=none;
	b=opn2vBG2hQZ8mxZKdybByIUlztFc5Ux6yeVOsIkPw7VRy8r5KMCm0nuv9I/VMEAvw9uVSW
	XCOG9XRCePKNTQ1HdS25ODG7QHQ13pBFcWvvBBTXrykwNfQKvsAG0JFgcTcuu4+V/kasg5
	7/7sFoGVVm2d6v0desmMRAnr2t5LtcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmmO8cHf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759827946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxkYIe5lCPbXvt5LEAWJhmf35lUqskMAv390SOAEtUw=;
	b=pBHrng1qt7qX/ww43DM25tyrZ/e8WCZeVYba9r6Ill/tz2fyk703q0RUrG/HZ9u37fs1hu
	IdULLfalpJHGhp9Kl8zISsucCSQ/04bzJLn/evJwfE61jPoWvF6SlKFWTrLvwednXbcRLQ
	WcCI+HvRG/abaAdrOR8xwcOQ/wiU2mU=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-796fe71deecso57999776d6.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759827945; x=1760432745; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxkYIe5lCPbXvt5LEAWJhmf35lUqskMAv390SOAEtUw=;
        b=AmmO8cHfp4/hF/gjgT5KE4+avDjGq6dHIXn89VoNMgNVpM0fJVwScAJPb0QwwOUeg5
         0E7CA91W0+sHlFMkGqx1xm+aq69aiTKOca7rFL+/sg5RlWApBvn4x9d809aApQr52hcK
         5mdfTVq0Ondw0Y+x8+MkS4qNBmQMD7kjkOR/kFT1C11vpBjAh8SXmh1zoVy9hpin/NxW
         S8w2Xi/Qg9WTHYtrg78IR4zS8JFC+O9nwjVDq7t8uSunctc9ONcp4xIXeAR/Z2nboCdx
         +QjG6rYgITUhhtzH7dVCttrNgHtDMPyTXYntXohdsHtaUOX9n38j/qyDtjPb+pq9nxp7
         NEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759827945; x=1760432745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxkYIe5lCPbXvt5LEAWJhmf35lUqskMAv390SOAEtUw=;
        b=IH9818WHs+hCHNkMtgEAT28eM1B7JzeMCB1vvl4RcAyIE9UW5t/pP7dC/4KzFR9uND
         G1/JvDJqqfIrmjrdfOTYcu172GOxpoBFRYVFFg2vLHiZvVBSBnp7ulbIbnO290DIJNgx
         O/5ZTaP7zoKCHcPyPjb8RWCqTMQn5tBrEKOdyEKFZYCfTbqiHHYgsAJkZUci+E30gLyl
         PHLXY/bYRoS2hElKq+Yqsi86MUSVz9n50rwQHWCkVYPJA/VaHUhtAPi8xt8RcuXrYjau
         2CKxRPGAsqjH7KassxX2yb3xUcnXaF8i4j74krJyvsgT3Mq5K5jdiuWHVQlPstAiJMXW
         DjEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0cD5ZTDb2pi/AOuuk5KP43YRxJNV0EMsRbu2tFl9NmurJL6FIPJg7newzeNqRKVKE92Ysy/nQyQ==@kvack.org
X-Gm-Message-State: AOJu0YxhWUIpBQM/bNj0wy/SE1dcZ5cYd7MwehpiKtJ2+lPHAQxlkgTp
	yE6brfOVsuH9KL6HqNU0uCJ4t4alFXVOcDq3PCVQnHQPso0jxn3MQ65Ot4lk4NYbdtkd4Hyhg77
	T6DZeLx6K5KMJMN28AxFwVvk3Tfp4iJo=
X-Gm-Gg: ASbGncvnPLvdaxGp/1KW7M4ohIBjcyycK0LHHymfYgIe7y+FeBONUU9473VP5Xv0d4+
	EXES5nNCR8uY2lVM6xscaGP7cPf/MGjdsknBElWCsDz0C1W15tFQeDmyy6SR+LlLzlCH19ewrPM
	p2jHeRctAzobKs/Gta0zUb+2Y4XPUGkhVgFIIeqmEfNS+X/laIVMIVcjcebMmY2+dlniu2YQAXx
	pJFvMU8gpWgaTG/SlphgrxeAXDWu5fj08aI9H76IsiOvgQl26x/hvOr0G0aGQ==
X-Google-Smtp-Source: AGHT+IGTSensva01uwyL1nNEvPr5059D7N0uaBb6xfNhSuXkh0+a6Mjpi5hSZUB/CGpt8XTeEb3Ofa98l86qjtZh1Ag=
X-Received: by 2002:a05:6214:ccd:b0:856:d1d4:d127 with SMTP id
 6a1803df08f44-879dc77bd7emr193257366d6.4.1759827945115; Tue, 07 Oct 2025
 02:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-8-laoar.shao@gmail.com>
 <CAEf4BzaGRDiW3fRt3i+7vvRB+oQszKjaLWVMSU6JrfmXHsJ45w@mail.gmail.com>
In-Reply-To: <CAEf4BzaGRDiW3fRt3i+7vvRB+oQszKjaLWVMSU6JrfmXHsJ45w@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Oct 2025 17:05:07 +0800
X-Gm-Features: AS18NWAVWP6POrSHevBgT5yY56gEiBpWAjVVmPfMtRV7VvEgPMFL-SAZ0sgTI4U
Message-ID: <CALOAHbD5OM+_iUg3DXw+BqYU+PFae6DcQGnE1CrLoKmb9OV9Ug@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 07/11] bpf: mark vma->vm_mm as __safe_trusted_or_null
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	rdunlap@infradead.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2DEF2C0008
X-Stat-Signature: g5i1ia441e9ex36qkdzc8d4osnw511sw
X-HE-Tag: 1759827946-600322
X-HE-Meta: U2FsdGVkX1+Ad1YjkL/hngcUSSdyqwXWDUEyJzgEoijL/vz9ywAaHHMyt6KwkkCFnx0TZrwCutClfnI1j/BLIBkNsvZcXyxajihWKpKnrgMujdBxDeIpzbReSqOZ57EcbC/1otI/S8EdRQv6e/fUr3VH6RWX/Tbc2NTVEQyLRdIV2oYZ4mL8eSiZ4IH7g4ohZxqS9bkjfA98Sp1/irD4yfuc2KQBhpEiYcHUvI0HHfg3tH/L7KnikROpN27KODIImwRbGqq0DepvO7SKjvSat9dkEVVEzp8zlgNptctcNCvcG3ddpVXlp7hj1Yc2zDyvJlui2/oEiK2nsdN8Rk5/ecxdb3LUorDTDmeqadNvGkKFcD89fpbeO12kc/tPqhTLMWygv7aCCDtEhknEAv9fKo8IVRXWe/f5LYHHeC+u+qUr76NJTVNfsGNF2hvEJoEyighTgYztCdh8Qm0ArXiKydvrRKjR16xTmMJ9NhhsSb32Sq1aY1fVIbb9wD0jiVjhpCa1txGiviriu0tA0qSPjU/zP3EyS/5tkZCLDdfsXIkw6oVBjxjMFkDSWHM4WXvcz74cmuBqb0fr39AbD89Wjukansk8CMqsHbuz3I4oKGpnOidSdO987FweafntyhVqBcCI1v1BgRI/nInXHbVc7yHn0NX1bsdUXp9FFV+rKMPDFwPTI2ZsTe8ml7RQqaYs/52vgFTlvpXcYaJpLKtiA8VTcqOZPcs4VLqB6gUUCVEs8HJRzNzXs9uStS66xauE+IsUfGm/sRH4B2w0nWM1gIcNGC9cljar7emkDOgGyUJbM8sEQC9Lk2Nd+2QpnyOATiKlY3OCGCcfXZBVfFRPbrtJ8yaZOztkvfeHWXVs8h5W7tZTNjAdcVnulHW8BmCbXioV9YKG1GPnEYKnrh8VuYEAPotGOyAfH4fz6od+mbfZu8/R3M22HgZSTp44ZEh5187eeXUpLzTbmExBkxb
 UCAz75lV
 UfHjWyzUVrExkaoRtr5blfnyQvUVg79AXXsXxiP9ZdhTybbf8Qk9bRZU0wMkt6nhRQVEa8fi4sBzqZoOMIGKDi3P8lYeWmwA9zo+9gj+vQd8CxVj151Qc1auJsI8OeoK3Hloy8mZDzgQ9hWMZ8giA4pV9QXz64sttAYhr8eaktxAUiwWCWpb7Q+IvfDDEpV6iAljZEgN0gwdWH1KGQa99YKv0WipOHEK9rho+Hu4bD7buuPpN77qv7mq1yNg/pL1U2BGFWLJUzXO+WiqVdv1t5HPROENXQKUqQ180H/rxD9wO09pCXBki2cAe2oC/fLhl2vCmN2dgWaHHxM5neJxHQjpPP5UITNzx000ACHTEfuqzBfu66gVmCkDe271+ilTOrr4XenTcfxBNjdJnslSeVflNJbbZRvlC2uUs+FEZyxYmnrYQA8GMClp8Cqi/NqKfz6qKd1aJd6J3vDSuVpWfOUgQrxgGJ1oZom2YpuwJpRoZOgH8IGkpaOAPhkpdGLj7WRzKZt5Vxgz5Ynddr+Qd9hnnrgWO11V5CYubQVa63zmmYGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 5:07=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Sep 29, 2025 at 11:00=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> >
> > The vma->vm_mm might be NULL and it can be accessed outside of RCU. Thu=
s,
> > we can mark it as trusted_or_null. With this change, BPF helpers can sa=
fely
> > access vma->vm_mm to retrieve the associated mm_struct from the VMA.
> > Then we can make policy decision from the VMA.
> >
> > The "trusted" annotation enables direct access to vma->vm_mm within kfu=
ncs
> > marked with KF_TRUSTED_ARGS or KF_RCU, such as bpf_task_get_cgroup1() a=
nd
> > bpf_task_under_cgroup(). Conversely, "null" enforcement requires all
> > callsites using vma->vm_mm to perform NULL checks.
> >
> > The lsm selftest must be modified because it directly accesses vma->vm_=
mm
> > without a NULL pointer check; otherwise it will break due to this
> > change.
> >
> > For the VMA based THP policy, the use case is as follows,
> >
> >   @mm =3D @vma->vm_mm; // vm_area_struct::vm_mm is trusted or null
> >   if (!@mm)
> >       return;
> >   bpf_rcu_read_lock(); // rcu lock must be held to dereference the owne=
r
> >   @owner =3D @mm->owner; // mm_struct::owner is rcu trusted or null
> >   if (!@owner)
> >     goto out;
> >   @cgroup1 =3D bpf_task_get_cgroup1(@owner, MEMCG_HIERARCHY_ID);
> >
> >   /* make the decision based on the @cgroup1 attribute */
> >
> >   bpf_cgroup_release(@cgroup1); // release the associated cgroup
> > out:
> >   bpf_rcu_read_unlock();
> >
> > PSI memory information can be obtained from the associated cgroup to in=
form
> > policy decisions. Since upstream PSI support is currently limited to cg=
roup
> > v2, the following example demonstrates cgroup v2 implementation:
> >
> >   @owner =3D @mm->owner;
> >   if (@owner) {
> >       // @ancestor_cgid is user-configured
> >       @ancestor =3D bpf_cgroup_from_id(@ancestor_cgid);
> >       if (bpf_task_under_cgroup(@owner, @ancestor)) {
> >           @psi_group =3D @ancestor->psi;
> >
> >           /* Extract PSI metrics from @psi_group and
> >            * implement policy logic based on the values
> >            */
> >
> >       }
> >   }
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > ---
> >  kernel/bpf/verifier.c                   | 5 +++++
> >  tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> >
>
> Hey Yafang,
>
> This looks like a generally useful change, so I think it would be best
> if you can send it as a stand-alone patch to bpf-next to land it
> sooner.

Sure. I will do it.

>
> Also, am I imagining this, or did you have similar change for the
> vm_file field as well? Any reasons to not mark vm_file as trusted as
> well?

Marking vm_file as trusted will directly support our follow-up work on
file-backed THP policies, where we need to apply different policies to
different files in production. I will include this change in the same
stand-alone patch. Thanks for the suggestion.

--=20
Regards
Yafang

