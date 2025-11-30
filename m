Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B55CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 13:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0146B0008; Sun, 30 Nov 2025 08:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180546B000A; Sun, 30 Nov 2025 08:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FBF6B000C; Sun, 30 Nov 2025 08:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA1666B0008
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 08:07:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EFB7160CE3
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 13:07:08 +0000 (UTC)
X-FDA: 84167298936.07.FAC2B5D
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8B21180019
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 13:07:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2uN4UcH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764508026; a=rsa-sha256;
	cv=none;
	b=jXe/W5neBauCOkspLnN9fHmUfRv2IMQ7VAu+qXA5flEsddZy1J7ff0C52DQvWLYR6nbXnk
	YRA9B4mga0EIweKec02kwLWiL2n770f1GXZ9BOvHF7+dk5ysXhj6uI5RKVfmPj/jxTQVyz
	7NIJL0ZjMGUqNEigcrdjGK4u4qGVOiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2uN4UcH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764508026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BT4Rq7P4A3WhyG68wBlMG6ufg9ZGrBHjt76GqgBqzDA=;
	b=o9MXSMqvvBJpSAwcfLZkqaOvSWMptqaKBoyGqqxTwgZlBVKML2mGQhXVDEccAskvWtPh39
	rYhiTJUHsPO+U7fbWR92RH+PuOQJDgpS2eJSBCt9r6vsa8QR87EpIK9A492NVvR5dfv04Q
	h5uFhQTsb0jI2LH8xUYtKPdI2sPhhmg=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-640f88b8613so2271830d50.2
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 05:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764508026; x=1765112826; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BT4Rq7P4A3WhyG68wBlMG6ufg9ZGrBHjt76GqgBqzDA=;
        b=S2uN4UcHvO18slhtrGKoCNAzlcP38tddQYP4/bwkYAdWVfyb+NjhMDrRG+BKVRMTS6
         QKm6zIa/3ZffMDetloIXuupy/OZ0VapsI0Te1DrDHTFiifE8zzCDZ/ahAjKQpQrZ+nga
         FytS0bfgHyTUB0UIS2n830R9AWuXi4v8A5VuiHdz9HqSQfAe3D/WFazaLHvI9+p7So3I
         dCrH8iReO6djxiYzXVHKa1GYD9pjvajdinJ4jGJaOWzhhVJ4s7mVpuV+1yn8WTYtppfU
         ne9LCF8W7Kd5aOuo1WtqJkoyW9DUZpayA/3GC8nQonl7xDfZsqYYvfepwkXC77txHRP7
         mItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764508026; x=1765112826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BT4Rq7P4A3WhyG68wBlMG6ufg9ZGrBHjt76GqgBqzDA=;
        b=OqDk5f0UyifnU0V8Qe/AARhC93Pc8N6wXY+NleYmZ7zExOb8RVCR3Hv5bGEoYe74Tx
         IGrEf81Iipt8fY/ohiJX74F1NU0l2unZz61h6ux6v3KYka1grs2S+N1cD8yTkUBfMdsB
         J4on8GFm2AR+w1nogbQvIl8SeHSXsbZpG2wLOSIAYtS8ksHK1JwsXZMVW7UqOGaF2iG/
         EZ6rR7uykilUbOZBHuI2E489LwgdhbRsgr9X+ed4n1LIo38EysvkPURXeYcp/1kSqiga
         SG+EIAgy0XxJXNT+rERqYIc96UKZfLeaSwHRMFVWLdc7VaxTFP+YDSAxt/ZZTD41wssz
         h+/g==
X-Forwarded-Encrypted: i=1; AJvYcCVsxfv0NsNl0dr8EWM+FIAt/VXgc0te5RvZF73Q2bnurDfUj2OWUb1bdprcHhP/KgsXG5rEEnhpOg==@kvack.org
X-Gm-Message-State: AOJu0Yxr27HrOzgkuXeA4THPdJ0HP2jsioTjy2uaSXwm3E0zdSn3WJrS
	1a7MILqIFNDzIobFwLFDECd+CvSFlRBvv0a7/Ofo73znR38+C1tHRIuknwlvqezfOFe2NQAu0UW
	Km4ekPoaJQgB9rzASUhvMPIqMG6ttVxY=
X-Gm-Gg: ASbGncuLljY0RmjNeczsrnMnbthMuiPO3jMvp9RVYdkXP46UzAnZciDPIdPtv2CnFSo
	jTB9j5Zss7nkkK/XpW4tfNbnwkhTQd8eGUFcDSJJUjAce2WKzLmW7g7jt+94hgHoyLoRgTOpWFu
	kzmxtWiZcIX1tlkQ32DhxvSYBcudeQQUEl3HksXNzcav4jdWwal6WLWdJRsuVRTeX9EwNm+r70u
	3fo1jKpTJ+K7xmTgi23St5xvm0CaDHjZeIdnwiRMJhcXk5f+A0JlL/WY/e4ifc4nLs8hxF/
X-Google-Smtp-Source: AGHT+IHe4gpW2rnysS8Axkwa9KFfNd5Fu71oRNIKhnWe9BfoTt6LNW6knSwpzboU35F4JllhsGWATsqb7Va8p6z+raU=
X-Received: by 2002:a05:690e:10ce:b0:63f:b545:9972 with SMTP id
 956f58d0204a3-64302a4b44bmr19684711d50.26.1764508025721; Sun, 30 Nov 2025
 05:07:05 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org> <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
 <e52bf30d-e63b-44ed-9808-ee3e612e0ba1@kernel.org>
In-Reply-To: <e52bf30d-e63b-44ed-9808-ee3e612e0ba1@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 30 Nov 2025 21:06:29 +0800
X-Gm-Features: AWmQ_bmlDYm6Hdx_mMDkDofr-6TD5bKPAmPyTccM1lbk9VM2QxtXVjgWMf1ZI9A
Message-ID: <CALOAHbCy_-5FbF9TJvnCdR8+_u3G60-uPxhbSmJzKEn=DR5Adw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8B21180019
X-Stat-Signature: 3yg9dpw99degdhxz99nu6jhyqdp4q63p
X-Rspam-User: 
X-HE-Tag: 1764508026-637461
X-HE-Meta: U2FsdGVkX19qvKyxYRuMcUKrotjNV/UD9MwiwYOND+2xjzgXE6UyaNrliSz2uh62+lITwlfwKqr1skfvMxxMH7XGHCXDQ/OM5Z7dQx8h+amOWNaXdj9/YSzSbhaO7OsUxr+OEQrz9xHULFAIGKToiTJn50QCSpoGLCHizjkkI4MnZdzNQeyELeNQy+Of/fV/Q8raRREBJXdUzTe7DYX90xbaUYmeBSNE+v5QdVztFwFvRIihVC+M90e05lDWHIQtUT6au1cCQz6glLUA4C+oVGRT+qmfMz6lPmuYoXNpmqzfzMugX77m4VDj18Bf+8QtUPWzv4ZsB9PYwHZ0LE1lUd7noBdFPFnv1ChbHD0ZmFzxwq/okEcMWVe7M9xWHOHVbmuk9fjbsqwFAcEgPcOLS23zPiy20dD7WCaawRNONCJO26wcl2yMDI5tTordJnUmmZSD3cJrSBzU2T933aKKJiY8HCkLs8sDnbR2UvZqJkxD0w6zgZS05C9zKr9CQCns1BB73ADwykbjdiwn558lGCB/inJi87V8WT3aRdavWNhqsEcf+QNAMesRMIEV+mAbKI/oeZm6Nf1tcWMdpjf2dNQfSZvmq9l3R2XNQe48EirZYeFIR60m2x7/IegUcehtLVZS7gdwJNqcTcieyW3yDWc4/VKnda7SGxMmlaVucnAwi5QqPj9bWxkfCpjiXstOlyW60HVMpsxIMzPqCU9YJz0Y+NoeJa9R5orQ0a3xaZEltDUTb8QyyFWb4skV3NuHOL+1FBKxeG7Yu0yf55skMjqbSxEZ76Uq5UKbmMep205fg9K7+M5X1TlMwsRRXxvwVSz6F6aCfdyUorPDH3wket/3inYtQjyhofBhe4QPlbdkomkmCISF6DB2PaQe69b+2F5Pei+32/N6bdNsQ4UQN3poKCXWR3EUbHZTBUcijK3KdA5xrTa3ESORFuc+uks9oOZyzj30qQiObwoSXtG
 UVttjjeZ
 ih+PPruftY3fsRstxICLru9xDqIG2MDs034TQUzAS/Z3REYxOarh7LyA4INY9zIy1RM5Jl8cUCvxmjQt/fyEyi9ncxGdcP17qepACckVl9CvYq95Y8+XBi3sBeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:39=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 11/28/25 03:53, Yafang Shao wrote:
> > On Thu, Nov 27, 2025 at 7:48=E2=80=AFPM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
>
> Lorenzo commented on the upstream topic, let me mostly comment on the
> other parts:
> >>> Attaching st_ops to task_struct or to mm_struct is a can of worms.
> >>> With cgroup-bpf we went through painful bugs with lifetime
> >>> of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
> >>> problems are behind us. With st_ops in mm_struct it will be more
> >>> painful. I'd rather not go that route.
> >>
> >> That's valuable information, thanks. I would have hoped that per-MM
> >> policies would be easier.
> >
> > The per-MM approach has a performance advantage over per-MEMCG
> > policies. This is because it accesses the policy hook directly via
> >
> >    vma->vm_mm->bpf_mm->policy_hook()
> >
> > whereas the per-MEMCG method requires a more expensive lookup:
> >
> >    memcg =3D get_mem_cgroup_from_mm(vma->vm_mm);
> >    memcg->bpf_memcg->policy_hook();
> > > This lookup could be a concern in a critical path. However, this
> > performance issue in the per-MEMCG mode can be mitigated. For
> > instance, when a task is added to a new memcg, we can cache the hook
> > pointer:
> >
> >    task->mm->bpf_mm->policy_hook =3D memcg->bpf_memcg->policy_hook
> >
> > Ultimately, we might still introduce a mm_struct:bpf_mm field to
> > provide an efficient interface.
>
> Right, caching is what I would have proposed. I would expect some
> headakes with lifetime, but probably nothing unsolvable.
>
>
> >> Sounds like cgroup-bpf has sorted
> >> out most of the mess.
> >
> > No, the attach-based cgroup-bpf has proven to be ... a "can of worms"
> > in practice ...
> >   (I welcome corrections from the BPF maintainers if my assessment is
> > inaccurate.)
>
> I don't know what's right or wrong here, as Alexei said the "mm_struct"
> based one would be a can of worms and that the the cgroup-based one
> apparently solved these issues ("All these problems are behind us."),
> that's why I asked for some clarifications. :)
>
> [...]
>
> >>
> >> Some of what Yafang might want to achieve could maybe at this point be
> >> maybe achieved through the prctl(PR_SET_THP_DISABLE) support, includin=
g
> >> extensions we recently added [1].
> >>
> >> Systemd support still seems to be in the works [2] for some of that.
> >>
> >>
> >> [1] https://lwn.net/Articles/1032014/
> >> [2] https://github.com/systemd/systemd/pull/39085
> >
> > Thank you for sharing this.
> > However, BPF-THP is already deployed across our server fleet and both
> > our users and my boss are satisfied with it. As such, we are not
> > considering a switch. The current solution also offers us a valuable
> > opportunity to experiment with additional policies in production.
>
> Just to emphasize: we usually don't add two mechanisms to achieve the
> very same end goal. There really must be something delivering more value
> for us to accept something more complex. Focusing on solving a solved
> problem is not good.
>
> If some company went with a downstream-only approach they might be stuck
> having to maintain that forever.
>
> That's why other companies prefer upstream-first :)

The upstream kernel process is often too slow for our users' needs and
frequently results in the rejection of our submissions.
Therefore, we maintain a set of local features that, despite being
rejected upstream, are critical for delivering user benefits.

>
>
> Having that said, the original reason why I agreed that having bpf for
> THP can be valuable is that I see a lot more value for rapid prototyping
> and policies once you can actually control on a per-VMA basis (using vma
> size, flags, anon-vma names etc) where specific folio orders could be
> valuable, and where not.

agreed.

> But also, possibly where we would want to waste
> memory and where not.

This is a challenge we have also encountered since enabling THP  for
production services. We are continuing to develop our BPF-THP system
to make it more automated.

>
> As we are speaking I have a customer running into issues [1] with
> virtio-balloon discarding pages in a VM and khugepaged undoing part of
> that work in the hypervisor. The workaround of telling khugepaged to not
> waste memory in all of the system really feels suboptimal when we know
> that it's only the VM memory of such VMs (with balloon deflation
> enabled) where we would not want to waste memory but still use THPs.
>
> [1] https://issues.redhat.com/browse/RHEL-121177

This is an excellent analysis=E2=80=94thank you for sharing it.

I don't have a better solution than your current approach of setting
max_ptes_none to 0. However, I believe this situation serves as a
compelling example for why we should implement a per-process control
for `/sys/kernel/mm/transparent_hugepage/` parameters, such as
`khugepaged/max_ptes_none`. This direction also aligns perfectly with
our roadmap for evolving the BPF-THP system on our production servers.

--=20
Regards
Yafang

