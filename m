Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16693CAC5BC
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3534B8E0007; Sat, 27 Sep 2025 22:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC658E0001; Sat, 27 Sep 2025 22:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB938E0007; Sat, 27 Sep 2025 22:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDB68E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:36:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7A37C090F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:36:12 +0000 (UTC)
X-FDA: 83937094584.11.C004091
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA086C000C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:36:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UyfbxVuE;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759026970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gaDCzK/mppvE+TbZ3WPtXIvdSdoczZCrzHaCPLwFrU=;
	b=Mz959uZ7oGujJStJ034o/yfxB89OM0JmryFfbdASL7aT8UwZ6q/K6HliXkTPv/b80M7+rZ
	uHCRDmQf9gOKWFindbd8IdCHwkI7G5+32Aqpx2E61BUDZ7mmDtZ5SKv8dliLDx/wq8wJT2
	ckz5fImKj0PPS9v+nKHPkBDJ2DM9/pM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UyfbxVuE;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759026970; a=rsa-sha256;
	cv=none;
	b=AElrl4/RbJ1CAGReJAnnpPwQ3gjD20zwaMfdKfFm7T/KpA2IJQcOKF9oHSUGxk7xWng4hU
	vUMxcyyE2hvv9KB/D5PUVMsR9TGZSkS8sXg6G3eizzioiKixbBHZ8t+piaLJ1WOMREWcAv
	p2k1r4Nk7t4TdZjC4HQufH852Wl8yx8=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-795773ac2a2so29732926d6.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759026970; x=1759631770; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gaDCzK/mppvE+TbZ3WPtXIvdSdoczZCrzHaCPLwFrU=;
        b=UyfbxVuEKjJTAD06euUhKD4YQsTaswRFNHR1xPAn+XGlNXdGehIxlZQ//HQZWF27Xx
         iu01ik42hou5o7cBIw5SRxqmjedwa13FnFUgvDQp47C3VZqardQPoRoNXhZXXLDjzaS4
         t9rINm1HEFxog/SiMlrrrIjMoyYXbFNPwJ+BfYl8s6pr599md5KBh2MUdcICEkicBIbm
         FAPAJiRvFGFPp6renpb3OPHgF5AmkNMZjE9ZPDr3BhkHw5stjWWIX+Lf0UNuy4p4G8oj
         cF3f7vBuOkVQNjOh8xnULGf39aK8x5UMakm8aSV6VRJbeoeVwzV6Jw/XOWSX/6JkYdzJ
         XoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759026970; x=1759631770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gaDCzK/mppvE+TbZ3WPtXIvdSdoczZCrzHaCPLwFrU=;
        b=KuA5RWN0Cw7by8JFkxrNSQZc5SFE1CdeDXqb6ZvgJzYTJN0F2IVJ1IZaW4gTRh1185
         mrclqkvo4OYz2msvpCQjcxKt9qKNdWNl8RjAw9YC8MlviEUlx2aq5a7IYr+fyxiq+ZnQ
         +6HIZm8II2rKZdu7oYxZmGCQSS1N95H1JBql5/mmyRUyGY+5a7ybYVzDkFnHlPaR48ze
         SOm5K7tGecv/WYKvqJgBEswWoO8SFF25ZIjKRivKJXkAQgjapCUij1UZvgzaZ+DhbiX4
         auolhX0UC7SHXPImnvTKoHz0fX+bbY1Ge+jLVRMdELisxkm52qjloqpYB5UDg2E1equo
         RoIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/uOzOG/v0OOsH2JWD2tafxBc0MxD4J3cdFIUD0A2P8sJhNt63/tRy4PIQNMbYQlUvJdo3P+yKqw==@kvack.org
X-Gm-Message-State: AOJu0YxTM1+gZnl0gIhEFwIIQb23exchBvQGwWdaQhMd+nJGBw2xUFVA
	akPT+jx/iJpy07zPb7tJx3YGCUK+E3BBmhGVevrPK+dUtrhbhzPTG93Kg0cFF1YwwpuXhKEu35x
	LaXhMqla06491mA20AKmFdnYxHiTi+70=
X-Gm-Gg: ASbGncvJnEHwudJdoS2Q+Vg18LOwz52ig6wdQzsxhlWf4gR1ZqIRIs8pf1Cey9ULWQB
	6BsTmegb9Kml/yXz1bnhaRC2vovErVZPJ5Po/U24beZTvMAR5fQhxHdMGE5AAQDE2bj8BwPiIPf
	cdq8JDtzCYQDRvSiLZ5ZjbCExauSYc8Q5IRQxRGK+FCR6gBPprXlTW2bnSURRTy+KFDFEXdVjC0
	In7xCw/wlcDOjOlqklMCACpkAlmvoBd2mvg7nBpyjF9Kqx8Qa8=
X-Google-Smtp-Source: AGHT+IEzrIRNkapYZtuzG9WFj/jlawGAcqNjlZSzbgOX3dCv7E2T+yBJS3MoM5SUVq717wHU1xry8WXSW8zEZoWw0ng=
X-Received: by 2002:a05:6214:d09:b0:82d:f77f:28c3 with SMTP id
 6a1803df08f44-82df77f34ebmr78705576d6.30.1759026969739; Sat, 27 Sep 2025
 19:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250926093343.1000-1-laoar.shao@gmail.com> <20250926093343.1000-3-laoar.shao@gmail.com>
 <146b95bd-e0f0-4e6b-a9fa-5a8f11355268@gmail.com>
In-Reply-To: <146b95bd-e0f0-4e6b-a9fa-5a8f11355268@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 28 Sep 2025 10:35:33 +0800
X-Gm-Features: AS18NWBmL8y2V1x6RK8Hi5Yh_Mzxczyqhv8V1kW5X07v9F-7y38eCcLmLbTOSok
Message-ID: <CALOAHbAGPZX+V4CBRyGhHtQ2mVFJWD4CUX+9Fujp-JAiK426Xg@mail.gmail.com>
Subject: Re: [PATCH v8 mm-new 02/12] mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yang Shi <shy828301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DA086C000C
X-Stat-Signature: rwppxsn1o4z3p68p73ig9fz6rtxi83z7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759026970-339729
X-HE-Meta: U2FsdGVkX1/P7hbZTiYqa0T3iIqvEulqktVFCvO7zMPJE8q8SAVVDnEiCEjEE5aV5QTaKdTJ78zmy+x7xeNMPTWBe0Dy6tKB++x6gCxPrkbxOZX2VB4jRilOHOfq6NLEjGNfBfuvFahb0MphfkNAShJmfO01bhmBCwZYtF/4L299OhtStzKPVZy+pO2GSZ9Dra7fkhLMS9gXGCOTSvubbWHxoEplWdgSukCCyJk1KBuVhsDewIE2DQ037NhL80iTWk0qJbWaRaFe2uvwARURPklS8BVPV8wFI1oLb9tweCq6+BB/qr21OStCN6vnr/jb9T89LqeQBi8SU7irXTjqo8DGuszki0cNW7Aw8sgBVYaWCZAJ1KGP5JTY95T+1p4/HuyV3wJmOovOr0RrBHJ7xGtQ8pRHFnPapRblI0Y6GbAAZjvAdrwojFDuNTCY0EebpgGIHAwIaaeODeplMhyORYVINwnVxmfcIJMEDhbfddAkmw9AE2FkN2jQ/8MmuuqnKWZ0LaJ69zf3j2WQi/Qt34s7sOgHPeJQVOfc6vNWhzu+Bty24FqzeF3vkRPOW/2Nh9imbo/gK/NXGUxYpFM2HxEGxAVGltT7wALNUJrXZ883O09AZW+IvHNNSKIVwUHBRb+LjJsmzzqNgbekp0ULDoyTE5daGAPqeJcmVQLGQT1xnfwejTt2QcTJqGZUFUVUkJDQL0DDL88os0ExuSKndiJ5wNCMo84R3gNh7aYWeV6DpXJo9DvFQrCrvmSBYLyGFh6DDNJFxRDUqCMatZLO9c75pLfMlxWxI0uypaYoxKRq8iJnuqoGK+YOPhN2t0qzif/4G8HM84BIsK/a1Quj57BXYMBUc580WcVFYIYL+pNrgzMkLZolqQwHjjd18cKIKcUA8CQ0NlA8ljvsIDfBZHwr6lrlem1LKfX2/sIacD1KHkpR1zQGPYJoawYy2XWtpuwIQjSLyk74TOQmqWt
 hQIB6pGq
 8Iw524W0aUs5R4chCvgFANaQiGvHPIzzrvzN7puzavYGVK6Oe+5cedxJ/KBvUvnpZLxAuvEGdmhr23KkStlUIHf2vV3D0lwiI06zHdIEghereIdGuVTITtXU2PQ/ZArRd6gYV2QlsHKT9ESp63PTbh6FU1S1WiXeiZDuQUF6iP5PCHeBaii+m+qmm5LyNXV6RJen6+WDcZ4Jsb3zgOAL+m/7up7QOz5bZLY3Qe4b9GVpgDRITkYI6Njuf1VBfUh+fOUpsu+/wOkkDHWcZBWpvgruqC+2Md0P5J25Y9LHSBdMc9ViPwFN4J7qcjwplgrpWpw7ueNliV0KUK7EdtYmtikNE73dNlUEMqQ85Nt2ZbqZg2yCAuUeIDzXN6n3VX1jAIxIkl1AtPX509zXGpXL/kRTWc9T6DhbO3RQcrNKT82y3w8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 10:50=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 26/09/2025 10:33, Yafang Shao wrote:
> > The khugepaged_enter_vma() function requires handling in two specific
> > scenarios:
> > 1. New VMA creation
> >   When a new VMA is created, if vma->vm_mm is not present in
> >   khugepaged_mm_slot, it must be added. In this case,
> >   khugepaged_enter_vma() is called after vma->vm_flags have been set,
> >   allowing direct use of the VMA's flags.
> > 2. VMA flag modification
> >   When vma->vm_flags are modified (particularly when VM_HUGEPAGE is set=
),
> >   the system must recheck whether to add vma->vm_mm to khugepaged_mm_sl=
ot.
> >   Currently, khugepaged_enter_vma() is called before the flag update, s=
o
> >   the call must be relocated to occur after vma->vm_flags have been set=
.
> >
> > Additionally, khugepaged_enter_vma() is invoked in other contexts, such=
 as
> > during VMA merging. However, these calls are unnecessary because the
> > existing VMA already ensures that vma->vm_mm is registered in
> > khugepaged_mm_slot. While removing these redundant calls represents a
> > potential optimization, that change should be addressed separately.
> > Because VMA merging only occurs when the vm_flags of both VMAs are
> > identical (excluding special flags like VM_SOFTDIRTY), we can safely us=
e
> > target->vm_flags instead.
> >
>
> The patch looks good to me, but if we are sure that khugepaged_enter_vma
> is not needed in VMA merging case,

Calling khugepaged_enter_vma() is unnecessary during VMA merging
because it's already handled: for non-anonymous VMAs, it's called upon
creation, and for anonymous VMAs, it's handled at page fault.

> we should remove it in this patch itself.

I'd prefer to handle this cleanup separately. The goal is to keep the
THP changes minimal, even though I've already made significant
modifications ;-)

> If the reason we are removing what flags are being considered when callin=
g
> khugepaged_enter_vma in VMA merging case is because the calls are unneces=
sary,

Actually, the rationale is that the flags can be removed because:

 Because VMA merging only occurs when the vm_flags of both VMAs are
 identical (excluding special flags like VM_SOFTDIRTY), we can safely use
 target->vm_flags instead.

I will update the commit log to clarify this point.

> then we should just remove the calls and not modify them
> (if its safe and functionally correct :))


--=20
Regards
Yafang

