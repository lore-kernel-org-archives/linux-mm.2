Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF54CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B023F8E000A; Sat, 27 Sep 2025 22:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC298E0001; Sat, 27 Sep 2025 22:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B2D8E000A; Sat, 27 Sep 2025 22:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 823A98E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:59:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26C6944165
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:59:30 +0000 (UTC)
X-FDA: 83937153300.26.E89F0E0
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3044B180008
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:59:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GAcdXho+;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759028368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbYlG8kir9C4NWsQtGw4HVo4aLYIvyfCcEM9DUL4BGE=;
	b=AkPrRfscu4lT4IgIz5md3FasIAe2b6sha3Hay0Qx4UjvzMnIMcLuN4Igk5X6wY2mJULNa/
	XpM4B0Cxp8FuysDkIaTrEuzlZYnAMJBN9MxzlOPXhr4xdx5wICqN6qMn6RxQ1xCxYE5dAO
	/SU/iM4wik4jCrxmaDqyf2k+ZmNZo28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759028368; a=rsa-sha256;
	cv=none;
	b=JeZg0DJG7ypLZabED6iqTw/oeX4tTM1KqdvsVHQ5ip/0ly+XPFE6/cA6UdUdLemczgYHNL
	WqSqLXZqclzm5Qsxdc2xaPsGzYdDxEw7vhDigBu/xHokzmj16/a3m06B6CXbWVrfhG1d/B
	SSenDHJmFwmFBsE7ngna7rOLl+ENtEw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GAcdXho+;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-78ed682e9d3so28461226d6.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759028367; x=1759633167; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbYlG8kir9C4NWsQtGw4HVo4aLYIvyfCcEM9DUL4BGE=;
        b=GAcdXho+XtB3Kd3HcN+oU3FfrXzcFGF72Dzy7SUsrYr0o0HDTlXtGLCo6zenpj+8LI
         TG7LIwyre5GKWWwbLlb+z8gZgzf7+DnC21htrP12CaOp4gLWN0MZytBVLjHWkkVBKs0O
         YyD2eENnOk7JZnWfn+iHMOESK7dKzQDK3m2ScdUY0xvHAJkiq7QdWACLGbDa3M+Mbkt7
         ETq5iaKsg8dwhwOf7SaU98lDuC0fADMK7sM68hAWp1YgoG3jaQ2zSu3WZKCB+SCyZTnQ
         J8UONWcTHWGydnNRPzabjIhkHY9cMMPRAEXe+gGlpmCFtJnZvQi24QGSjpmE5O7Xec45
         uxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759028367; x=1759633167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RbYlG8kir9C4NWsQtGw4HVo4aLYIvyfCcEM9DUL4BGE=;
        b=CKOEQtE3m/IxOn1nmiQxSkjgPBelzrRzWckzRaJqPp5pBpCPyWIXmhYlhqJsh/vYDn
         K0m6NDZlAvHvbz9THbQ0Mqvj0nRJOofKO3uN438B7b1Wm8us0Xn1uKqswQJGtctbAVlT
         sWBdviq3w2MLdE3u7+nFS3ACM0SqaJxly7u7/dOI260v2bDJsBAHkdSbOZhql1y0ti7N
         1o8f7lC/BKJ1xqKnbhIieRMYwilQlet6AJ2ZaQgZPXQhjm3DZtCacpvFfc0+Z28z/lIY
         yASW3w0YS/JKbQHCzvY9Jg6YAASM+VaYnbGHz0klnP+ejstL+R38iWvVf+0B4gk6DTMb
         qpvg==
X-Forwarded-Encrypted: i=1; AJvYcCUycwWS1KEV9uBhBudBMzilQ8FpLsIoB58tWrogxBEAzpTMO92Nzhi21x8F/4igKtZcmJhemFLtDg==@kvack.org
X-Gm-Message-State: AOJu0Yyv5f6zKvMdrt5VE3mkbl6rR4JoqnDm0UQdaquS08P4n1A1y7bY
	L3OcCRP9YAXVY1pkxk37ynxMl/nr30buchqvaCe42lpXGlXZ62JQsH2riG7Ip7zSk5MgLkqyCXL
	yWwUeIT4qv/056Am6PY0KsuUADoFfYTEy5jBiO3E=
X-Gm-Gg: ASbGnctXYkfEUM0pVnBQoCMV2GNzjQHWJuSZrSo1LQ2Mk0Y3A/Cf96xPpxatH2LDlm5
	WYzHsIrcsvhdiOGBSnOd0oQUw92QnA5uMPk8ljYi9vhGWlLuPIApBFl2SfwiMoUUYIbpzqGWQqc
	SkY71JS05riQ1EhPIzAtGc/yooZcuccIBEeD0YM/ztkYerzXtuVaJ8Hr4oB3gjNKmLBqQpwRYLo
	mT0nxaPtWofaQiE+ccRvZN19dikSB3fbl3S9Jj1
X-Google-Smtp-Source: AGHT+IFdRnFXl3N8Jp4Haml4M1RRKvlW3m2kzWVSMSBoU9EF1uuyEHWcCvydfgCbA9/kyPP0cUmHnjEU6SbmvUelvBA=
X-Received: by 2002:a05:6214:4001:b0:70d:6de2:50c0 with SMTP id
 6a1803df08f44-7fc43a4e9e0mr153355586d6.61.1759028367220; Sat, 27 Sep 2025
 19:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250926093343.1000-1-laoar.shao@gmail.com> <20250926093343.1000-7-laoar.shao@gmail.com>
 <035a8839-c786-45b6-8458-87ac1c48f3bc@gmail.com>
In-Reply-To: <035a8839-c786-45b6-8458-87ac1c48f3bc@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 28 Sep 2025 10:58:51 +0800
X-Gm-Features: AS18NWAAfWsnD0j5sPrJc3hEg82Xq_xZbRib5fRTmJ2-Yy1bnBsvdtfvitUBea8
Message-ID: <CALOAHbApB53XJBvkomsbRcvAFr8rzUajjB1vJDL92b+9cYgHgw@mail.gmail.com>
Subject: Re: [PATCH v8 mm-new 06/12] mm: thp: enable THP allocation
 exclusively through khugepaged
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
X-Stat-Signature: 6qhjqmhjjser9wig9m3g59zntceup96i
X-Rspamd-Queue-Id: 3044B180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759028368-247613
X-HE-Meta: U2FsdGVkX1+TAtOTFI41XgX7yv5MrY5+CoMTgeI2tg4fHBYwTx8s2uheOphywYHgtch4Pjx4tIJBI/cSD5x5nT+Jjx8Xviw2SIkvcpUBK3DvmzzVDenSi5UG/tB8Um/CcHD4mtG8nB/5ymITSWLdD0CuJ7jtwtTsY+QRF2kU2El44kysOV29UxCBuuXSeNs8IuTB0cXWLFYQ9hmxl2tjkjNASudMPHHqzDo+EX1QPJmOyELYiheQk5jqB4nNxLKa2P/znxJsx72GJ+m+YDrKclj5wjO2wlTbrO88sdHbXQZXV1QH8TPRBoRWP/mK34z59XfcdUJySjg8sGPM1UM+JVYMR1K5+ldZk3oHXOhel3NjKfRdVS660MsK68njVKv7AxjNPuC7U8fkLpKjX/egHk0c62Uo0/DuYGsZ5ry5yqsIYfXNDrTuZkIvO114aQii4Ou90RH0n7kAYokUdRXl4YFrpriNEc6dzMDdMfFtv538vmaJ4Kk5QIVZ9JNQKcTpmZpFuX+TqHj+nVrgLZlDJPjE/nIenSoFY/6exfSvA+/479L2/dFdng+LeSL2XNy2k53EoDSrYN8hvaEw34jHCudOn0kYqIfwycM1SviL4s1LmG4AZSe5nR9fT5vNexhUJyU/nncN15jr8+tmriPmWRl+sMzj25iHwhQBlNIKRtFJFzoOAG8i8MaDuqIbq9EHetCmR/NatxaXf9Ma783/vtQgDoO3VXJr/lORQKsADHXhDL2RweVtTBazc6AnX2JqEhOeQoE1d32bVHnNRwCJDvNXmLMYbQoP5gxa5x1Vvm8sQ2BI2/aJPjOJ6WgXGVTQkJzzE4D8qkZ5hivAk3mLxcMMJnuldoXNCLEWtgichWt4mIuBa6GpiqWrShtLRdodeCSEnvM+HErO/ic4qHvs/kThbPuI7asb1VCVaQ3WsThap/WzDplcYVVFlekZBq+UL7eNGXTuY6fW/73WdV7
 /DvaOUX1
 fQR/wnv0UvmYBFSfGbYce1aTsHGzL4M1Z83KeLz7SQpd9vpTwY5qG8qbzgcmS1wr7tiXVyUWp09DQV/rFE93r9rCY7TDJHB4WZURywAyCgFzZC/KwX1iVtghiPA5Q6sd2prXVaJBdEu28iVQJyfpfFzHRvyZeJBvIf9gf5+0z8UJ6l85EDkp/MPyIVH9r/qDT4vswzn4dR5i78Ts+q/i0pvFzhEvgelHLfxQSLRgBVNBIn1gRtdk+n78t2wUnnuZbGrAaUFiMKqYauI6T8Z9oAOnGCve8ePWIvaTKvJD7Tj1kqRJmDrPMTNcNFZGdAIqhGBOapg6z13zj6Sct3Ju24fxrBF8QkoRNv1VTZ4jMAopjIsWIKYSZxoszBzQ2axm+BNgD5zNT/P5BLg8wZpmUAZ/i7zMifTkRuX1s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 11:27=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 26/09/2025 10:33, Yafang Shao wrote:
> > khugepaged_enter_vma() ultimately invokes any attached BPF function wit=
h
> > the TVA_KHUGEPAGED flag set when determining whether or not to enable
> > khugepaged THP for a freshly faulted in VMA.
> >
> > Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
> > invoked by create_huge_pmd() and only when we have already checked to
> > see if an allowable TVA_PAGEFAULT order is specified.
> >
> > Since we might want to disallow THP on fault-in but allow it via
> > khugepaged, we move things around so we always attempt to enter
> > khugepaged upon fault.
> >
> > This change is safe because:
> > - the checks for thp_vma_allowable_order(TVA_KHUGEPAGED) and
> >   thp_vma_allowable_order(TVA_PAGEFAULT) are functionally equivalent
>
> hmm I dont think this is the case. __thp_vma_allowable_orders
> deals with TVA_PAGEFAULT (in_pf) differently from TVA_KHUGEPAGED.

Since this change only applies when vma_is_anonymous(vma) is true, we
can safely focus the logic in __thp_vma_allowable_orders() on
anonymous VMAs. For such VMAs, the TVA_KHUGEPAGED check is strictly
more restrictive than the TVA_PAGEFAULT check. Specifically:

- If __thp_vma_allowable_orders(TVA_PAGEFAULT) returns 0 (disallowed),
then __thp_vma_allowable_orders(TVA_KHUGEPAGED) will also return 0.
- Even if the page fault check returns a set of orders, the khugepaged
check may still return 0.

Thus, this change is safe. I'll clarify this in the commit log. Please
correct me if I'm missing something.

--=20
Regards
Yafang

