Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258B8CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504E78E0012; Wed,  8 Oct 2025 04:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD368E0002; Wed,  8 Oct 2025 04:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3FE8E0012; Wed,  8 Oct 2025 04:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAEA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:19:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69A7A877E2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:19:16 +0000 (UTC)
X-FDA: 83974247112.27.EDC1830
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89E02140007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:19:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XzWKAtbr;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759911554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujkQmW6plJLZBDQO/36IgQfW49HabBHClJLGnLpua0c=;
	b=2g3TVxx9+iASIK24KXI8ChCWfPH0cmaoPm5fINpti7bLOlfzWs4CirzcEQ6YbeZkh4iQqI
	i7OpEtU/6ollSQgABCKRzRXujt+WZMklOCTLpo/BGsYuNYtSoph/ack1BSU1tH/UDB4dbL
	6xsSGo7jXHD2Tztkvhr9cnEWZFtKYXo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XzWKAtbr;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759911554; a=rsa-sha256;
	cv=none;
	b=KqX4BqmS0rco2fL8jX9mSkBGtnUkET90laCaLFK9L0tnjOnTfnob/cQd7M/18JCLNqQo+z
	hlVkiZ5ua38/c78Aygg8UNG8KLdBIFL2lavCghAvfKgRatcIP0t/0GofKG5UIs3C2HXa6C
	x8ucOVNSQHxT81ZvEbVR/EvvS/sGTys=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-79390b83c7dso58553486d6.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759911553; x=1760516353; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujkQmW6plJLZBDQO/36IgQfW49HabBHClJLGnLpua0c=;
        b=XzWKAtbr3mb/z/XHR8ux1WMaE2nE5cL4XM7w1Mhm7gg1LLjHVgo8IxnML7kmcBA8t/
         x2eCMmy7TwNdsXVIximvj5e/c0BOKJkRqWaVVykEutNnnoao3hMV5g+zqoZ4EfvtkpeI
         gzO9roEX10T0QGyl2jO39JSLtLeU1OfjhCtaQ9tLVh7DWhtX6xYN9AcWYAiWWgJveoIW
         ezDBSnZ5/pL5++LzftTRK0EGWTGRwROIsxu2cLkk1AEPdDXySf1Hk7m4NMRK745G+C6j
         ppmDub3/dU/GC4kMcWNYL66vU3e0TjVC+xROzDSl/ZCYEkfHoJHQvuLMG3444mX+/CVQ
         5VoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759911553; x=1760516353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujkQmW6plJLZBDQO/36IgQfW49HabBHClJLGnLpua0c=;
        b=fM4WI8akvbaiNoMFF6sTzgvfovVnXDDU4j6dmo/3qj2tbN5JqamqNNgRVYGoxSRddN
         ZnfkI5d5wvTlA9tI0f9ydoy54MB0tEA/qNawxXmEUDE95aAJj5MUcpuPBgyQ7bAqN/Tc
         4bQ16MyJM+fjaIj0ucpTZcMuhm0vyii2MsTLcMyLp+OyPyfBBES9AVuWUtSlFZL3WCSv
         j6oerZGexzJp9N6ESCyth9cGZVNGFTr/q6phsn6JF+egUFgM29FaTZ4AwtvkbTKlhxFw
         9lkQB/5H5TUG66xL1QY7ArQCKTES4JTJqT1hiyfn7DdQBilQrvc+VVf8efrFk9topjoq
         SO7w==
X-Forwarded-Encrypted: i=1; AJvYcCUEtmCLJYCqtF/sIjU4qKlQf5trXs8sFhvTnUq4R+cgATqz/FJdOWQ9JApV/QneZb5raARDdt1Rgw==@kvack.org
X-Gm-Message-State: AOJu0YzQ80enYqa5bl2qSdE9cit1m+yrdEWtBWrsgUj4l6DXRmDHlmw2
	+u4lhzys/aQpnsBmGZLlj0eh9fiDCklq3Li+RHJ0CtiqvmBTU1uFruuIeJ+PjGH9PqxjS3VCQlF
	2zfFoRfQvX2tODY0L9GYPmCFcpoYeUts=
X-Gm-Gg: ASbGncu9AOHTl5McskML/uNd9BfyT9Twkcrdpc6/aWwiRGLY74VTbF5bAyxRcsMRrKH
	BcMrzjjh1ojsxck3gd5fV3bow6w1Mgf03A6Ple/f0/XIADHe+pTHD2nOivhecCXZybBEMTG0uXd
	bt9FeG0whFRbAIxrozXgjCrbA2q77s1j+tLvsHGHZrhU9IS2ZXNGcmFtn71MCiEkYVITNtAwF5y
	q31cJet7uqFAtwf77okdt8JlyPwOFqoJtHyiPy7R0YpYzbcEinJRzncu2uHtG7F/Lvnxs+Mg9E=
X-Google-Smtp-Source: AGHT+IHZGUO4OF/QfunpmTKIRKSgOuGmZNfsONzgXodv17mKF+pXVLfT+JBj8J2eFByzmTADYXWLJpPNEeD4YOKOEG0=
X-Received: by 2002:a05:6214:408:b0:78e:49a0:2ba4 with SMTP id
 6a1803df08f44-87b2ef9480bmr33207836d6.58.1759911553333; Wed, 08 Oct 2025
 01:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com> <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
In-Reply-To: <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 16:18:37 +0800
X-Gm-Features: AS18NWBqVaYKWhKnTCEHPPwnoyf7n1_vwGYnsczH0QG6uK9Ydgy_AQN3Vgm1uv0
Message-ID: <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rjyhb7d96pwy79fpm9mxp78s7xfkjcne
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89E02140007
X-HE-Tag: 1759911554-902454
X-HE-Meta: U2FsdGVkX1+wdO0M/qmahCI8rCpdIupARlHaM7gWdpJviM+Bis2RkFjB21bi0UEZEwy2W+KOyu85pCExOZ/44f2cPGLeDRVlj8vradZiXC7e8C2M9wL0ewM6m5oYxnLXrvAHIugIGjHWX16jrUpYbor3qbmJ7cigW3PGLd+SfFod/NzRCYxct5xczK3eY/KGkUj/Fdx33QgJ/JplbJLKGINXKYcciP7hLxJXDodsYfU3mrI4FtII2VwOTN5sTAZO6pKTLTpaHrTpvvC+1N6CuhSnvBCcB2C1T4ZCKCU7LSxVURIysqhOzQwSozlQCh+kGzuz9+oojTQu0nKjQN3P7/uA0NVq6gMAUqS7quRTO8bHBY5m1j2sBJjykNVzy/q7V7Dnhq/hOfWGHX/wFIxYzw+nlYAKaaS4umzoNqzevM7+Awr5V3lQld1+AxAnNvKhUEoPSAFEiYLcMGewETR5W3G3wBxVHdfa4SNnvpZo0BRdbSapYrvC3no5LlL64Uap2nuKJup9psZExbVtVgQfRAp7QUXlyJYMx60duGjldsrlSypE6ysy7h2vJL3Ksoj0XcGpiic1eiMe3MWTItUK07UCSdRXz0H9ja1HbZu2yPo8VFkza71eoKCx4lTVHTt6heIc1g2nbBEUpllVHkjKheGhg/LiEIJe+PpBAeQj4BRZJuOLU4Acr7vueu9sn0FQOySi3D/falitDYWt3oYqPyLZJu3Oy1Pt3lLBleDJ1gB+OpVMMn4OJZZIDtba2g3dzI10f3oOB+Ml4mqV8G4mP98+96wLzyI/bp9Ox/Wb7y15oMbblwIP06jzOuKtljit+F9ZD8lsPm6W00JyrAjv/0ZmpcCE/mBHe6ooDccnvdNV1RMKMRbTKCbzrllzNSJB6e1sdjCloCwq7E8d3fow69E12eZmzmMz+Iq0cBfOHgwDsDVdOvwwzXF5IEFIg6VTVaqDFjF9xGKhVqHkyB/
 14A3BWZB
 t14G+T25eaUmTLTJEDf8VgdoCofO6QIppfqqt3kOtl8Xjx4ihlU93r6nJcox68osxqnlRaLcRF8+cbOWa0i+wGUBWslJZL3MVCREjFrcHIY2UmBXW102Ylj0PmYI243wLJpoeWILqjrDhsg5xqWScJZeNuA4fEaeCWR0sZVml1fyDs+EDa0L1zalmdW8yU8FeiQTS8IV2qahce/qsFpSNrRUXGc3RcxNAnbZwsEmnWnUn8qddH4vnOuQOtcuOxhnYqMjCwk2FKFEMocMH+midNlrHMILTZ+hwdBYT6CZbYhOt7nL/Ht5Ka2SzJR2ePDysB+g3FGEaj9V3RlVutDxmZGgT5Mlx7UPxC3jvL4/h7rBclDLlTTrTBR9lghYcEeum7Uo/H4LDh46WzbFaNNh5eoYDrKv4ElbaRVvkHxDmEof1jQW9iNdu2LmthE9/QiUTLFwoAl6nEvsUsOlVDHAyn2Qu4XqNzRxW26RJMiP7mCTVejdHvYwz+x+1H4rY/cLBmVSy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 03.10.25 04:18, Alexei Starovoitov wrote:
> > On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> >>
> >> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> >> +                                     enum tva_type type,
> >> +                                     unsigned long orders)
> >> +{
> >> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >> +       int bpf_order;
> >> +
> >> +       /* No BPF program is attached */
> >> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >> +                     &transparent_hugepage_flags))
> >> +               return orders;
> >> +
> >> +       rcu_read_lock();
> >> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_ord=
er);
> >> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >> +               goto out;
> >> +
> >> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> >> +       orders &=3D BIT(bpf_order);
> >> +
> >> +out:
> >> +       rcu_read_unlock();
> >> +       return orders;
> >> +}
> >
> > I thought I explained it earlier.
> > Nack to a single global prog approach.
>
> I agree. We should have the option to either specify a policy globally,
> or more refined for cgroups/processes.
>
> It's an interesting question if a program would ever want to ship its
> own policy: I can see use cases for that.
>
> So I agree that we should make it more flexible right from the start.

To achieve per-process granularity, the struct-ops must be embedded
within the mm_struct as follows:

+#ifdef CONFIG_BPF_MM
+struct bpf_mm_ops {
+#ifdef CONFIG_BPF_THP
+       struct bpf_thp_ops bpf_thp;
+#endif
+};
+#endif
+
 /*
  * Opaque type representing current mm_struct flag state. Must be accessed=
 via
  * mm_flags_xxx() helper functions.
@@ -1268,6 +1281,10 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
                mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+
+#ifdef CONFIG_BPF_MM
+               struct bpf_mm_ops bpf_mm;
+#endif
        } __randomize_layout;

We should be aware that this will involve extensive changes in mm/. If
we're aligned on this direction, I'll start working on the patches.

--=20
Regards
Yafang

