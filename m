Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74B9CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524A88E0015; Mon, 15 Sep 2025 12:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC968E0008; Mon, 15 Sep 2025 12:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439958E0015; Mon, 15 Sep 2025 12:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 318838E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:51:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC049140711
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:51:31 +0000 (UTC)
X-FDA: 83892075582.17.8FC4116
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8F6B140012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:51:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W66XhLs3;
	spf=pass (imf26.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.171 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WKzLzikogNH32wmrUmUUjepaN9aH5XtDkSaOMnQ89g=;
	b=pDDq3mJHxT3nfxqFaFAVCEkRa/Loa8PpMdI0F1MMbUw/ihJoEGarIAllGdtUj/IMSb8W6P
	c1ASy5c5OWPOAXw+12wI6OlgJNp8qqmB7/uWtwkf9/PUqq72Raerx/KazAwO7bilLMUXFK
	zbQy0GOoalSNq/om6XmguChQosNlE48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757955090; a=rsa-sha256;
	cv=none;
	b=nRR+E03JenC/wuWGHQM40zjfxj8ZO76B8PLNJSzPp8voZgm5xOXkM7EtiC6VOFrP7SPIN2
	KkbTLVp9i9wlmw7GUsbHLuihR5ZTyCub20t4fvZCUjv9/XhqnZ5b9IlOh0vuCDt8CW0cIw
	0v8IH45chIBdduw1RhK+QBuGJpKjUDI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W66XhLs3;
	spf=pass (imf26.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.171 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-424077143d9so685ab.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757955089; x=1758559889; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1WKzLzikogNH32wmrUmUUjepaN9aH5XtDkSaOMnQ89g=;
        b=W66XhLs3i8FDd0YMfU9tJljTMbQVdaWxggYDiam0V387bOYbROuZa18q4ewM0wH5O7
         urFsO+ZOzb8141EM5S2v+Ir/uTKAKMlA4mzu6ecW+nxBJM94qfKTEexbQ0QiiCPOGDkI
         KkKVtGm5FNIM8h6kwu9yu7YL+0i23TVaX7ICN586omJMcyXzep2w43yWCj3POhy3JCHl
         bQIJ2KT53WR3N5zTAprm9BX5Ukr11J2qQLzotdbn90TFkcLkFOhaCxKU38eJc+VTrpPu
         fVDe4Ldn+weg+j554y2w221S9hnEbaJeuasUx7v5rMxancV/3fkTaSnI1GO9V67AxqE1
         eAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757955089; x=1758559889;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WKzLzikogNH32wmrUmUUjepaN9aH5XtDkSaOMnQ89g=;
        b=IDf8U0/G2zcaOPAvzX1Z+7Uixm7Xye26PFqxEc9WdRMVFVF9Y1HTfNn5Xsq4htmRce
         9BALkrxO/dhl/V6jGzyhJzpuAcSULjha+0MKQt/fFbhqeF/F3aH6XVPQ7o/zSBr6o2k1
         roq2gsoCid6eAPln9+CRxr+vp8NTJ2gCiJoXOYzHD8Nsc5F8V0zekajde5zDbYhdGCBU
         3spObTqvHHMGr6llyqoYbf1XACo/lbIz9qLnwsFeWC/uqbO5y5OesqG6fl3m9tVKybs3
         0SybrCyXAAsTHI6MkEcPNI8DjD/tWQDScTodNKIBFiRdVcxGSpEQWdcoOALalayIgPE0
         x4ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVj9cU0B2j/hWJCDqtzenj8DBMIPK4yTSo5HmBgOYs3QncuLqwcNcilsizQP1UY7wRsqyAVv3WBmw==@kvack.org
X-Gm-Message-State: AOJu0Yz+U/glPH0KJwkzopXlCg0WT88spDB+xjDxFZWYUyKKiAOVgbeC
	5oaXvpJL5t42xAUCKj+mF1Jug4m0CqRA0j5A7bAt9JWs/UdUcMqPCFmBZEA68qC+6NCBFycAoih
	mom2YwLmdN39l0pPk4tVGWZoq375Gg/qoqdi7RBbH
X-Gm-Gg: ASbGncs4b84R+MCz7zEb74ZE+tbywFCAWev8X59oxCrNW27PG65sTdciMKzpuFIxn2S
	+tFLbHhh4aGlaj7H7qodfOzkCaLS6pIOSGUeRur044C0HdN/iVy8sIPKB4sHEOV/KoejMpeySOQ
	8Oj747LmZFCr7g9CO8If+EkEPY5bXm+V9P8cF5ZhPBO+PAzAq0pKibo2ZmYLBcYMiB6w8C8xdfq
	4NrvaxVG6nO176E7C8W1Cw0ka2cPTNaQmm8wd1izED9p5X5Vrx2tOFQLg==
X-Google-Smtp-Source: AGHT+IGYZhPQ7aaQfY82+/f7fuogDWYxeFZ/njIEyFDDoBbZH0LDkwMmu/QB3vxG1xvwbImrFrx85GmycWUmxXD6xf8=
X-Received: by 2002:a05:6e02:144c:b0:3f6:6806:ab6d with SMTP id
 e9e14a558f8ab-423b29a07d7mr10276305ab.13.1757955088513; Mon, 15 Sep 2025
 09:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh> <63CFCF33-B334-446F-B6AE-EADB24A9F8CD@nvidia.com>
In-Reply-To: <63CFCF33-B334-446F-B6AE-EADB24A9F8CD@nvidia.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Mon, 15 Sep 2025 09:51:16 -0700
X-Gm-Features: AS18NWARX-2vUoN7zOqg5BtUxNfMaZv7wXbIjpCBhxdh461bPLWdHFfVGw0JB-o
Message-ID: <CAAa6QmT-x4MmpMRigx_T3kwn2MTApotz1sr_RKze-k94kXwiOA@mail.gmail.com>
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
To: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000095e04a063ed9d0f4"
X-Rspamd-Queue-Id: E8F6B140012
X-Stat-Signature: xjjaugt5nbj89ibhqj585n1usrfw4bnm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757955089-985341
X-HE-Meta: U2FsdGVkX18BG0F7ASRVeJRgbY39isL4MIl6it24xF6PZoMJWpGlROLgV/wF5fmz/+fD+ksaIejheoVqIHv5mfqT57Kjyn1rbI4yPoTNeFlxcyc1NGMr1uVAVFw7Was6a/3UWxXoVOjXbj3Tml0PBEkVfc3HwLu8kffxn6+Tx602+EpQ7zSSA1J1f5M1jMSeJa0yi/o9ofKRMFEXWXTVXzRI7oywRairdui5JCzd/qH0YNR1xYCmdkUo3vTbvO287B/Efp6b1KlA2Z+ISiYhNjPXYy6mFQ8mx5yiYgRVZfmja894pkt/X58vXLwvCokto+NcWuMEnaqXLQf13ge7lF00FyLNVdmld0QhrhIhIv1Riiqa3vj8rLYBZ6qk/P5mZ83QGLA4/pyg5ZMHyFnsutpkCRAf0YjEfxPPPo2u+Q+wjtNpaixgXZRQ4rS5RAW2EMyi1UjA9gtws9StP/iBtJDIEKdAqmnETMARTKplY4g9XEsirODwdgQFzO7YBBTK8HssGZu2yifZ1+8ETe61uvVN9wG65MNMG1wGl3eaZ1jjk/bbBxvA7zQecKd7p0r3wk0rGEHkf3GqJmMsSevozx1zcX9ahM35ZkU0YX3e6i48mutCsZfi/Izk7DbCEEn3RV7G/bKN8eaP1O8owHn8PACTdaCXyHUpYVAVhgn/NI6m+RyvTnhRbUXBIJxTTnz4qnjEJsGK0oqPQd5GecFCR3yJ59ok2KqJZ4zeDE1YXAaDRDPQwBpnQbUL7iwZVlqsu23vAII554wsIq7TBWYQmaheyw2wn+y/ZBOTD9vFKuprIxCgOGtZwCxHnYWXH1eWGAqiCQUdSaiOzv0pF+65mQY3wRJWerS+IrBTV1mPWy8rVMcWt7s8m/XQ5uLeuyUX1QBuwrlPqaS6sjKVEQhlOCo9kdHZdiF+GM2GkHLrO0atWioF+f2uBNyXk2zxXHZdM6/hxiicCrKsNXEBMoU
 n73Gfci7
 8KWXQH5ssVIfQ/cdpYAx4zHGcgwlDXVGm3bEhqORR6yQNNbnOOBBxjuy4t/K2vw1QBxztl28n88CJywfH5ngNay44E3LwpYsmJHF3yekaiBxyzj+zh7LFr7xgXZflA+K4PumJOl2Y3uIYSEpjzwXadLYMo0HVhwpeXn8828i2h3ynnBf/8zpJHQ3f2WP/lg4NZhnjegJTFi8Tmu8Qe1QCqtdak1Mq6Z+vll1nR/ICd6NGOGQuBXUsKjqP8iomvILjzNuQHBJ2QdcEMpa1xO2GlIta0X2XtqDepdxshUc7j2P+qa42z/wBBlJucN0JbdJCN8TQyNdMLJRIK132uZ4fMcN3sb0+qzdfLtVnXRUeHLUY/lKpwVrRz7NZoMT5XdQSFYb6nr9RpZvODhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000095e04a063ed9d0f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 8:35=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:

> On 15 Sep 2025, at 9:52, Kiryl Shutsemau wrote:
>
> > From: Kiryl Shutsemau <kas@kernel.org>
> >
> > MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> > PMD page table is installed or not.
> >
> > Consider following example:
> >
> >       p =3D mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> >                MAP_SHARED, fd, 0);
> >       err =3D madvise(p, 2UL << 20, MADV_COLLAPSE);
> >
> > fd is a populated tmpfs file.
> >
> > The result depends on the address that the kernel returns on mmap().
> > If it is located in an existing PMD table, the madvise() will succeed.
> > However, if the table does not exist, it will fail with -EINVAL.
> >
> > This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL whe=
n
> > a page table is missing, which causes collapse_pte_mapped_thp() to fail=
.
> >
> > SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> > collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> > tables as needed.
>
> Why does collapse code want to know the difference between SCAN_PMD_NULL
> and
> SCAN_PMD_NONE? Both seems to be treated as =E2=80=9Cnothing here, install=
 a PMD
> leaf=E2=80=9D. One difference is that madvise_collapse() will continue
> on SCAN_PMD_NULL but bail out on SCAN_PMD_NONE.
>
> I wonder if we could have SCAN_PMD_NULL_OR_NONE instead.
>
> Zach, since you added both, can you share some insight? Thanks.
>
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >
> > v2:
> >  - Modify set_huge_pmd() instead of introducing install_huge_pmd();
> >
> > ---
> >  mm/khugepaged.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
>
> The changes look good to me. Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Best Regards,
> Yan, Zi


Thanks Zi. Hugh had also looped me into this. Travelling today but will
respond tomorrow. Generally though, this is a behavioural cleanup I=E2=80=
=99d had
been meaning to do for a while, but didn=E2=80=99t realize it=E2=80=99d be =
so
straightforward. Thank you,
Kiryl

>
>

--00000000000095e04a063ed9d0f4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote gmail_quote_container"><d=
iv dir=3D"ltr" class=3D"gmail_attr">On Mon, Sep 15, 2025 at 8:35=E2=80=AFAM=
 Zi Yan &lt;<a href=3D"mailto:ziy@nvidia.com">ziy@nvidia.com</a>&gt; wrote:=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left-width:1px;border-left-style:solid;padding-left:1ex;border-le=
ft-color:rgb(204,204,204)">On 15 Sep 2025, at 9:52, Kiryl Shutsemau wrote:<=
br>
<br>
&gt; From: Kiryl Shutsemau &lt;<a href=3D"mailto:kas@kernel.org" target=3D"=
_blank">kas@kernel.org</a>&gt;<br>
&gt;<br>
&gt; MADV_COLLAPSE on a file mapping behaves inconsistently depending on if=
<br>
&gt; PMD page table is installed or not.<br>
&gt;<br>
&gt; Consider following example:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D mmap(NULL, 2UL &lt;&lt; 20, PROT_READ =
| PROT_WRITE,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MAP_SHARED, fd,=
 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D madvise(p, 2UL &lt;&lt; 20, MADV_COL=
LAPSE);<br>
&gt;<br>
&gt; fd is a populated tmpfs file.<br>
&gt;<br>
&gt; The result depends on the address that the kernel returns on mmap().<b=
r>
&gt; If it is located in an existing PMD table, the madvise() will succeed.=
<br>
&gt; However, if the table does not exist, it will fail with -EINVAL.<br>
&gt;<br>
&gt; This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL wh=
en<br>
&gt; a page table is missing, which causes collapse_pte_mapped_thp() to fai=
l.<br>
&gt;<br>
&gt; SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in<br>
&gt; collapse_pte_mapped_thp(): install the PMD leaf entry and allocate pag=
e<br>
&gt; tables as needed.<br>
<br>
Why does collapse code want to know the difference between SCAN_PMD_NULL an=
d<br>
SCAN_PMD_NONE? Both seems to be treated as =E2=80=9Cnothing here, install a=
 PMD<br>
leaf=E2=80=9D. One difference is that madvise_collapse() will continue<br>
on SCAN_PMD_NULL but bail out on SCAN_PMD_NONE.<br>
<br>
I wonder if we could have SCAN_PMD_NULL_OR_NONE instead.<br>
<br>
Zach, since you added both, can you share some insight? Thanks.<br>
<br>
&gt;<br>
&gt; Signed-off-by: Kiryl Shutsemau &lt;<a href=3D"mailto:kas@kernel.org" t=
arget=3D"_blank">kas@kernel.org</a>&gt;<br>
&gt; ---<br>
&gt;<br>
&gt; v2:<br>
&gt;=C2=A0 - Modify set_huge_pmd() instead of introducing install_huge_pmd(=
);<br>
&gt;<br>
&gt; ---<br>
&gt;=C2=A0 mm/khugepaged.c | 20 +++++++++++++++++++-<br>
&gt;=C2=A0 1 file changed, 19 insertions(+), 1 deletion(-)<br>
&gt;<br>
<br>
The changes look good to me. Reviewed-by: Zi Yan &lt;<a href=3D"mailto:ziy@=
nvidia.com" target=3D"_blank">ziy@nvidia.com</a>&gt;<br>
<br>
Best Regards,<br>
Yan, Zi</blockquote><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks Zi=
. Hugh had also looped me into this. Travelling today but will respond tomo=
rrow. Generally though, this is a behavioural cleanup I=E2=80=99d had been =
meaning to do for a while, but didn=E2=80=99t realize it=E2=80=99d be so st=
raightforward. Thank you,=C2=A0<div><span style=3D"font-size:16px;font-styl=
e:normal;font-weight:400;letter-spacing:normal;text-indent:0px;text-transfo=
rm:none;white-space:normal;word-spacing:0px;text-decoration:none;float:none=
;display:inline!important;background-color:rgba(0,0,0,0);border-color:rgb(0=
,0,0) rgb(0,0,0) rgb(0,0,0) rgb(204,204,204);color:rgb(0,0,0)">Kiryl</span>=
</div></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-style:solid;padding-left:1ex;border-=
left-color:rgb(204,204,204)" dir=3D"auto"><br>
</blockquote></div></div>

--00000000000095e04a063ed9d0f4--

