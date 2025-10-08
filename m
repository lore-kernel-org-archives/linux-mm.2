Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B1DCCD183
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662498E0015; Wed,  8 Oct 2025 08:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9118E0002; Wed,  8 Oct 2025 08:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2908E0015; Wed,  8 Oct 2025 08:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA5F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:07:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C64721404EA
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:07:20 +0000 (UTC)
X-FDA: 83974821840.13.33E8875
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 022FB4001A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:07:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XIXT4a+Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759925239; a=rsa-sha256;
	cv=none;
	b=U0vM2IxXi2en6RyATogw40vg/5Nn/4uxUStIgOhP/K1VvdN8x8JNdfSKdN9PSsPeVKF2rh
	aQW0sRgvq3la4o30xP5G3EmWFs1w2TzPXVhiSB1ksPc9DUbpT4rqbOkUFRuVUJ4cU5BfOL
	CkifjW0J9JHvQ4+AseMvUaZ31PM4IK0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XIXT4a+Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759925239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnTtsbSmHH4T9zX0iyH6U/3gYlbL4q2Uw39tvDIL9jc=;
	b=HCsfkZWo2B5UjnZ93/jR+8NyG5PgfNiEQd2/Uk7jG5e5Cs2u2zDqsH1+td8QREgl55wzwu
	XXTYoNtWjQxss7fOehKVkfHdLWmvEvnzRwF9O2A5iivPoSc6QDhUYTKVOKdYcTceWmZO6O
	Qx5hkRaQIc6QbspdrJDshyxJ86rX4QM=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7900f7f4ba9so71186946d6.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 05:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759925238; x=1760530038; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EnTtsbSmHH4T9zX0iyH6U/3gYlbL4q2Uw39tvDIL9jc=;
        b=XIXT4a+ZGUpRgFDyjEvNW6TlSz7xfuEB+CYDeTA8IlPoQGtnW8JREL88VBUbMB8RvD
         15MGrkOECw4QcO4MY4JArHzJCg7yJZ+AKtsz0ZZPpOwvk3R2smZoQWv2EYitj6EE7MaI
         FJz5N1Jk0qO7V5hbYtuC/ZcBkkw9Z7aMZj3gKpq42Wrf70ZdeLuHc8N2IHUdhl7aPNOC
         jhzLTum68pFCCf+nqBf+T3wM7vmFzVMPXZQ+LlvoBhT7jbrO58n2S6ztrZVhpcRhg3+W
         pVyF3fxuPWQzkDrvpk1lM0ONMTVAXtg2hZ1w90ubHL+g5vw51a1ULt1Z3iHXfDYVr53+
         2mEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759925238; x=1760530038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnTtsbSmHH4T9zX0iyH6U/3gYlbL4q2Uw39tvDIL9jc=;
        b=akLjT0eSjklCjNZLhX0ghfVezwZX1yHBhIawANW+MXncCrxHFUEKbAlbHkEqxIyAju
         UMOOohwE/HOtstGNpSDTu9skyYxBzrE6eZ8pSyi/ZeSwJ6RaGzWtkxd3KjjQESBvu3Ip
         lzXNxATxTu8xsw4hFFdA6mFcus4RI9/3WPg90gkmZjDFhKmzfKQZTF4F/81aOdLjyKnc
         6dg7VIwyE2CzSS6yz1ncEhQD7L2oGtummefqvkGaEzrhspWyp1yhcUCzb8/vZVyq+g0k
         7TupzUzXGHubTyJCZy7bIHtGpawf319iw3TeTe+lITMa63+3EAxtLSfxB4i2/PDf88J6
         dxIw==
X-Forwarded-Encrypted: i=1; AJvYcCV939CvUgnOyl2PY7oreIk3MMFPT1FqLJpxaB9tochGpyroJo/kX9ezPrVosPGc5eaJlS0iy53Axg==@kvack.org
X-Gm-Message-State: AOJu0YycAYJX+MWMwryhq4B/0Cu/7w49jRdf4f/PWOLxeTESmJrymM2q
	XoOb92xUz82E2mtrYQ+0BRB1vmcUVebF9BqtGbwLlpB26lwtuOgJ0DRS1TIj98LQwxERdGWOm09
	zsyJ8+BnjI/kYCZac62E1eXS5IcktsC0=
X-Gm-Gg: ASbGncv/XRc2GQjtID6av50SxKlKvOZpoB3ekG6vYxXtjKHaFy7krUVMX6SGGY2pVmx
	wMCKfu5d8p/zY6tq0peWq1bUXXeypSLaAy0lZOVpnSsuVHg17f2FTdvR40E/i/mJjmCd8IWpvq/
	WjOeMthwtSRLJM9fD4N54IzoZElI+ouhHH+aUFDKqFGFays+eTNeDPyH4nvGHJ0a7Syq2hFz95y
	1g93FgGIIquTfKLUplCGtdRLWXFca7z3dNdjVQCvNiqFVjdjefqFSoGBPMSAOfznjejJOF5yws=
X-Google-Smtp-Source: AGHT+IEVKGmMv/tkSbd+O4UvvaCrDeP7UI1yITjpMQ8N+fjVNf2S7Zm9vVDrsesEpPbKlJ3VI/molVYwtOHeWvkfcWQ=
X-Received: by 2002:ad4:5948:0:b0:820:a83:eaff with SMTP id
 6a1803df08f44-87b2ef7fab7mr37825166d6.64.1759925237890; Wed, 08 Oct 2025
 05:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com> <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
In-Reply-To: <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 20:06:40 +0800
X-Gm-Features: AS18NWBIxlsXVNTBzBqe9RKDEHMGwyRZXw76KJBRlynko-9PYAcMYCTd07kAK4o
Message-ID: <CALOAHbCS0WvUSsK_rbtU8LTLuz_eynVEa1ULyYmyRcMW_hfZWg@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mhqqom6bg59ssnbftan48u7ewknxnr4i
X-Rspamd-Queue-Id: 022FB4001A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759925238-141758
X-HE-Meta: U2FsdGVkX19sl639GSpZXZWGoTm4obs3GwbMSo3G9Ey52TrCHJ3SDNHgk+R9pJO3S+B32xKNvt60eoxC5cgrmNqCm8L0XN8qh7h8ddUw47gzBEA7sVWkMzf+tyZZz6M7GSRMd00T2l81gX2ETbCWbyxPJuwxvjS0MQ5NyAIaTp9oe2xnsnLMXNBprR0IMpKNNdh9ix1rbKrN9ILrKZFD9RWCWtpcCKjnlJWZI7ErLPeO3jdDbNcQXaaf/10FiWeRtMHJUL0mLYSvMWf4hA4PUoQHSs6kAJw3q+uEa06YnDKuauBlxbDgk192e5Rt5e5laB5cIFLhQZxFJ4XDbmCliJOSRFlamQAOpzJ+XbyT3eyBDPOygb/4p+3bHBL5RDwpOLoXNSMJo3cmodOhtjOZCVzuf6Wy9QHmDlS9GlBzfRM+9PKffo3UfSFOWBDG0vBZFo38HI1lW7SQ43IXF5TtGWHLktFQQBXeT1FHxi5j/titFoACRuc802Sz2NTCfgBm+WRvXCVaALl4N5xr6tumV6I+2cOowpAdZjsdYgdXNOpwxn2AIxL1S67kWSh9x7tmFX9BBBuLgK2EZ+B/DpjaFr+MnJgp1Uvh/4UpWd6Sg1njXU2XoReW6JqXM4xuulfyxNpVJX4TtMUzaa+71IXDwcc77COsYpNQnhpXJ/3X9hb89rFXC6v8tfM0bufBtrJXhrHuqTjKtW+lwrLYn8wcBB2syVzVEddp5aIcTXeoMlj+gZzAycTzajXVrrxdWrfAkMmzadxr/Y8ElgFAuYnYxhJklOmz/pvRzKCH/yv5AKobt5FQ239ChigPVvHFZzglLzivKB6rCLRNHRmdHr3uWYfVvqA5wnYCHS9z1fKnk9z4GOqLPYtiYNaGlFdCEFtz5wyuSd5rWyvMR4Dnx/TnkAO88+gR0LMcGzI2L9yQ6BO+IYCmllem0PoyBNP/RdpmMVpuU43DeTqskdiItoE
 iA/4Q0Ab
 fpeNBrrZmy7trHyRVmDxONncfQNxr7EedbyFsG5YStS199jD+esYfP1pSqmOU1Ng1ToNwu9ZaJtr7tNnsXO7u7Ax+b5+1bU8AECk69cEIbrCAql9ZxDAwRaXeHLP52SJctHDyX/MMZy2d/HMIVmqBAtp6ldNtj/jSoN/OndrqazgNjyd8+IBTC12SXi0w60VS6Y0qS0di18tZETBrmD1MgaEsmtqjFql2pEyfwwSbJbtMT/8jfVOIOT0lJCkMt1g651gZsrKI1q8VnFHiiMFyfcPZmEcQpzAMrC3eB6tXPYT5n7Z5t+0GYlox3MEZnbLLdclRU60iHsJNWF4Q0XMKtRW/05RNDIhTKjU+PfDs2ENke9c+fdQ5uyJle/Q08pxhWEa5LaTWEM2EbV7/b1Xtni33Hrmcp8FBs4rN66Z8kvKRYqg2FULSZU+0jUDjLf2BTFDHPqONc0G8OiHvxKIYQbNsUc1GqLk71KJzbqi7ec5MHUo4XVzkXHOUPgvuuKiW52bw06t9yWEwPRz+ScWyzI/2Gs7SyKYTxnpzZOecZSaVL8/5RCDLGdfSTHwST6D06+CPwHZBMBSELIm2F78fkkTly5ntXxochaUJDr06UbHJ23I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 7:27=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
>
> > On Wed, Oct 8, 2025 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 08.10.25 10:18, Yafang Shao wrote:
> >>> On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@redha=
t.com> wrote:
> >>>>
> >>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
> >>>>> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> >>>>>>
> >>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> >>>>>> +                                     enum tva_type type,
> >>>>>> +                                     unsigned long orders)
> >>>>>> +{
> >>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >>>>>> +       int bpf_order;
> >>>>>> +
> >>>>>> +       /* No BPF program is attached */
> >>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >>>>>> +                     &transparent_hugepage_flags))
> >>>>>> +               return orders;
> >>>>>> +
> >>>>>> +       rcu_read_lock();
> >>>>>> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get=
_order);
> >>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >>>>>> +               goto out;
> >>>>>> +
> >>>>>> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> >>>>>> +       orders &=3D BIT(bpf_order);
> >>>>>> +
> >>>>>> +out:
> >>>>>> +       rcu_read_unlock();
> >>>>>> +       return orders;
> >>>>>> +}
> >>>>>
> >>>>> I thought I explained it earlier.
> >>>>> Nack to a single global prog approach.
> >>>>
> >>>> I agree. We should have the option to either specify a policy global=
ly,
> >>>> or more refined for cgroups/processes.
> >>>>
> >>>> It's an interesting question if a program would ever want to ship it=
s
> >>>> own policy: I can see use cases for that.
> >>>>
> >>>> So I agree that we should make it more flexible right from the start=
.
> >>>
> >>> To achieve per-process granularity, the struct-ops must be embedded
> >>> within the mm_struct as follows:
> >>>
> >>> +#ifdef CONFIG_BPF_MM
> >>> +struct bpf_mm_ops {
> >>> +#ifdef CONFIG_BPF_THP
> >>> +       struct bpf_thp_ops bpf_thp;
> >>> +#endif
> >>> +};
> >>> +#endif
> >>> +
> >>>   /*
> >>>    * Opaque type representing current mm_struct flag state. Must be a=
ccessed via
> >>>    * mm_flags_xxx() helper functions.
> >>> @@ -1268,6 +1281,10 @@ struct mm_struct {
> >>>   #ifdef CONFIG_MM_ID
> >>>                  mm_id_t mm_id;
> >>>   #endif /* CONFIG_MM_ID */
> >>> +
> >>> +#ifdef CONFIG_BPF_MM
> >>> +               struct bpf_mm_ops bpf_mm;
> >>> +#endif
> >>>          } __randomize_layout;
> >>>
> >>> We should be aware that this will involve extensive changes in mm/.
> >>
> >> That's what we do on linux-mm :)
> >>
> >> It would be great to use Alexei's feedback/experience to come up with
> >> something that is flexible for various use cases.
> >
> > I'm still not entirely convinced that allowing individual processes or
> > cgroups to run independent progs is a valid use case. However, since
> > we have a consensus that this is the right direction, I will proceed
> > with this approach.
> >
> >>
> >> So I think this is likely the right direction.
> >>
> >> It would be great to evaluate which scenarios we could unlock with thi=
s
> >> (global vs. per-process vs. per-cgroup) approach, and how
> >> extensive/involved the changes will be.
> >
> > 1. Global Approach
> >    - Pros:
> >      Simple;
> >      Can manage different THP policies for different cgroups or process=
es.
> >   - Cons:
> >      Does not allow individual processes to run their own BPF programs.
> >
> > 2. Per-Process Approach
> >     - Pros:
> >       Enables each process to run its own BPF program.
> >     - Cons:
> >       Introduces significant complexity, as it requires handling the
> > BPF program's lifecycle (creation, destruction, inheritance) within
> > every mm_struct.
> >
> > 3. Per-Cgroup Approach
> >     - Pros:
> >        Allows individual cgroups to run their own BPF programs.
> >        Less complex than the per-process model, as it can leverage the
> > existing cgroup operations structure.
> >     - Cons:
> >        Creates a dependency on the cgroup subsystem.
> >        might not be easy to control at the per-process level.
>
> Another issue is that how and who to deal with hierarchical cgroup, where=
 one
> cgroup is a parent of another. Should bpf program to do that or mm code
> to do that?

The cgroup subsystem handles this propagation automatically. When a
BPF program is attached to a cgroup via cgroup_bpf_attach(), it's
automatically inherited by all descendant cgroups.

Note: struct-ops programs aren't supported by cgroup_bpf_attach(),
requiring us to build new attachment mechanisms for cgroup-based
struct-ops.

> I remember hierarchical cgroup is the main reason THP control
> at cgroup level is rejected. If we do per-cgroup bpf control, wouldn't we
> get the same rejection from cgroup folks?

Right, it was rejected by the cgroup maintainers [0]

[0]. https://lore.kernel.org/linux-mm/20241030150851.GB706616@cmpxchg.org/

--=20
Regards
Yafang

