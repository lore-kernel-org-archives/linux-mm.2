Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6297CEF48CD
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 05:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FED6B0005; Fri, 13 Feb 2026 00:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D686B0089; Fri, 13 Feb 2026 00:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CB56B008A; Fri, 13 Feb 2026 00:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A20BA6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:02:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22412160356
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:02:57 +0000 (UTC)
X-FDA: 84438238794.24.7977A46
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 288E74000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:02:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YOvGkg9h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770958975; a=rsa-sha256;
	cv=pass;
	b=iCIpVcQXBtHUmTnsBTd+8MwmpqOrXoQyZo7FA5IV6Y6rP4Q8Wb8dSwhlSx5Z0illdkUA0z
	Pxvia19m8+5vSXcByBdJadJszvMyWqr42dz1bL2tTcAZ2JBfQ63FH88iDYyyN4Z0TfpE3t
	Mn8empkDgbORI5/MXKEFFIpSf/paDr8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YOvGkg9h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770958975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzTrR5QIf3HHCZSoE+Hx4yJ+fNxWdvc8XotTFgpWDso=;
	b=ayCm32fR30hWa8w269y0kwhRKAUE/8HeAOgwdh2aWAD9d/5Ve340yQXk2cWmWbeXQ0VDvS
	i4Djn9ZNNw53PY70/YKQmSOPW9IQvR1AUnPpRoaDTLwgNC0KCunhwUlfzBRUJqGh00aSW1
	tB9s2qVaABTkTexO6E8Huq7vT7oq52E=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649e97f1e1eso464795d50.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:02:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770958974; cv=none;
        d=google.com; s=arc-20240605;
        b=JIGHGYd9JcICYOJMsIY7dXBeWwQgkrDUA7JPRjdYsz6MlQtXxD6TmmOaHZnyqIlc8v
         qqoXwPjkaj4xwhHor8ymwHe53YKL5lHz0UT7L8Ex0nlcSwLO3uQmOydANzgSfqAHK+6u
         0ABNAqpBA7IrvCx0G46lZtc5OVYE038pIJAZjRzXTDxLxQ54z/5Bm/jLxHTI0s5lXITT
         m81HZ0ker0M/fF63lsbT1GQ+p6KWbCMkZ7jDFmP37S6G+nn78tdl42hGrSHfdWx2Z8N9
         NRZK1vxIwdQboU3ui4LFKg+oINHtgp/2PgjpMtqLhqcAv7uGDTgLx205kRAa62rwCCwX
         2Elg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CzTrR5QIf3HHCZSoE+Hx4yJ+fNxWdvc8XotTFgpWDso=;
        fh=pboWKH+eFTSEf8l3zs5D5/kWc6cq2SKu0v9294pyIqY=;
        b=XejBeLENsvyjdH7KcRq4L/mVT+Y5UzSqTv6WLpj7rrTqehhsUpoH0rGG3RobGU6J49
         4SrpwYobm8Tw7nXMN3rzJzUOEAR91uyuc8cSf8NU5wLKHfNPb+gr77zRvZFPyWYiDdMm
         5EDs9oCjvPBN1Is4GyGw+6fIOuFbFnnvEyYJtSqbUvCuIptqX4jaLL+JZP5ulIGtwFIZ
         aty4u9mpMmvgQPtukrIb59imotc0LPmZAXHFFD92jkhMeElZ06CT8XfW3nxtGOHyUqb9
         C8NK4R+T0vAMxOPXnpySvMfH4IO+1c7hwb3QW0GLdXhbwm6bGtpDxuPPHtUshv3tkAHG
         5KTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770958974; x=1771563774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzTrR5QIf3HHCZSoE+Hx4yJ+fNxWdvc8XotTFgpWDso=;
        b=YOvGkg9hTIcglD9bJVEAAJYeM95hQxH+o/mzX92HHHY/oFVxIQcxwgLCmYKmkTyQJH
         gCXj/yi2A4LoxgHoT/6KOFham9mJP045mxsTlAXmlB/5ZDckeQufq/hv8yQsl94kI2M4
         HFARht2HGwoon2Bv/OhPHfTDNM95lTiAeTt08hW4YDFNVagKG0r160JhTfYTlhfgkgbN
         cReY8La6HubvKDn5kvi6791vDimXLaDdB7j7jEwry8atEhgojrgtkKhX3jr2nrfUOVLI
         ei8M2qiCoUIo0mHK+dthTEMtremOJnhi7mt2nB5Q34Wbkz+Aru8Fb900CRbVd1SPwI4x
         DIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770958974; x=1771563774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CzTrR5QIf3HHCZSoE+Hx4yJ+fNxWdvc8XotTFgpWDso=;
        b=RKqQ32XyDgL2tx9pcx6gALqzilVi1ivmeSMbcwd+CzX7WU8QR6XtxVNR3Xeeu2/MAV
         ddP1Cnq3l/7icm47bcwLYRMTm+7h9iTImA6IWwo1DUo9mnnWFGwOioydavmsAaWP6jlk
         0a1fOtSNhaiw+ieXUPYbnjyUsdDQrPjJ3ltwF23j59qYmAfV7FHAmgX8fwTNfu6yje2l
         NbGB6/CZoAV+bZiXUPW2w/eLiRl8a683QVqmuW+HoMZIH3DTN7vzHeX60vmuGD+X7rx0
         AYt9c6AUHVHCHOrwMOTQb5bX7L+jx6bEpcvJzZt3U+j8VZt1MYKw0M/iZt2Y+3B+jAWW
         IlHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy6DfIgeIdsOpx3yeTdHKPvlWxX509Nc3V0yakz1RK8tLyZK9jCewhKwgC1WcnuoQrra3Y3V6XCw==@kvack.org
X-Gm-Message-State: AOJu0Yyn0bAUp0SxuEH0ULzH1yJ4vzAgFCt74ngHYlLnIJq8L9fmmfUZ
	8yy1swKvW3Herz6yJGnYiDmex8yQf42+oecXDTlnN251jNiJZfYJ0XVX52wga81U2sbufsEZjpL
	iLAHdiGj5KjQK2ZuoHsDZc8nEoddG5Tk=
X-Gm-Gg: AZuq6aJhUx9hk8dsXsZgUqiUMlxY8oxLYmP+lVgSbnBMODD1FbkDJ2Ku87sIs+FMj1/
	J+O9GoADu8n6kQfq0mdUgY3+l0aOib4LgpLOOgSAKcAXF9W5/6hOmzVh94gw06zwuIEwgx8Rk0E
	CHEC40meWcHR81p/UuaTmZNyG6r6e/YgVPqTaF8k9avQHGrzV1xmD5qncF2Zk57ob3TYClbrFAA
	pzVf+qTrNnKxW/0sGwq+4D161LkZoR6ZpZcbpIzRUEC/s73z+SFOcJdMbW9W0zmUY99v9AZ/f8A
	1yDld2ilzlnlSq8bU/sfYoAfm9uKwiZhh6SGoYqi+KimB767TIRpChGxSA21tcl/Y04IAlfh
X-Received: by 2002:a05:690e:159b:10b0:646:7c08:62d1 with SMTP id
 956f58d0204a3-64c14dd6bf3mr910096d50.84.1770958974152; Thu, 12 Feb 2026
 21:02:54 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org> <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
 <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org> <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
In-Reply-To: <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 13 Feb 2026 10:32:42 +0530
X-Gm-Features: AZwV_QjxlIeQxFcxV2DdE0m8DRmjYQ3ZnT4V9Y2XbTFJSVh4B9Dr0FBANr8thJ8
Message-ID: <CADhLXY6zzWJnu9ZLH8jThMx=z6JpYmnB_jdxRJe=QVjEMu6WFg@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	Fangrui Song <i@maskray.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 288E74000C
X-Stat-Signature: yjtdo5gq3cqw7at73xq5ifiw5hp8tb96
X-HE-Tag: 1770958974-678315
X-HE-Meta: U2FsdGVkX1/relhLqp2MXdlV70yS3G3UHH5HE4UN6Yc1Pm8YHRpot3D9JBxnUpwYAt9y8f45cejh8QKOCOcWJOKJeT/9Gkrq7Q9fmZ9100Uc5WfcSkl0DAHw5klJ3zoDFrLSpCRj4G9VeCRInSOzRjZ97kwMGUF12Tr5t8IhA+0C8N1B3FAt7g+CaikUnU2dNzuMXJlLTlwop12K9+TO8wIz/byhpuIHpPHtmp9r4FuD/VqIjT9UG7Gr+sKW+K0p85ne0ukZbzvSWkmX6alMe53b77hdfWqWCtwiFpqiS0EtX21VSN5V6dcxyKkdRkwOeJdR2W9/znp2V+eEh3SyXuLEte6K2HHh31nLLLU4PeCNMPTbImfhIFfjqvQAub9RHoOsdvYu36b44xLxvRdWZyBCm0H1UEzfIsGE5xds5+CjO3iNu951yGf+iA8CUyHOOtJ+aco8FDMzEa8E9voRP/O+4Oj33LRn96dCeuH4zZG0sJlYDg1H8gwF94YA9LiUpLJSdSEODbJJojINyMDiyE9xII7dAp4ZO/v6y1Cj9n3Gzj7O5Uv+RRyy6U72mI0WsXAi8wTGI9q8YqQu14vJsmyuuTDKjSPEZRBQTXEyAAZwv9nhYtJT/6pAO2F4j8/EhIPR1GRxMdC9It/VN2PPhF8LU9q3tYuQPFe0joooqstMIhrheWjOVa1oodjwO49CskJvqttUp0Ho2sxz8BGwFfhOo3Ktq5jIA8czEryL+FEmnXm2g4m238aNyPz21BP7CQrSl3N352FdpvUM8zcw8JmDUOh6JOtKNdrxEABxM89FU1o7t71OjJrUkVdY6U1q1qu8/wdXLEj5fH+HMUk57u3F07D+Jm1XTJdC73OPh1Y5JlwAw0HlsveZzBlUruQk1qn/1oQgizNKwOGLySiBAZrMrsg/K12JsNP17ZROh7Ro1b5hQ+EUZMhlep+DOKLQt2uuzpuyh0IBDpPv4Wp
 p3GmV8Di
 plAB7n3xJJcDO9Ux/g47OuGCm2P9TQ4+DM6sN/nnXWyiC+8Op4x1acE67CW1tT5b71EL3CbWTtu9Wuwx7acCccLshZ/ReADCQt3TwrnH1LHP4k69XuzpS+kWNq7kSIBNliIJeSbJypyLWGknTnC9Akqi4gp5qFxDMiFmgmcB+NDP+yWZznA0ZjuhpoUTgeHvhtMY9T7kTsIHUOQoYyy8aavdvjLet0tcs4VeA2MHC29OZoJ9TLQ1wwWNS9rTSZQz2I9JFNexOo3Nx9Bi7Jd/BD82J1eRw0XMvVOjFkP2ygB4VQXWWzp8zjMc8mI3spKq6Yna0vKgFPz7s4uZnsXDCEtICejwuqIU5oU8mWj8fEQK6WXQ2ZIligFu/4SD/16J5owr3snLdraHARZqG7S/zRzZR7bWSB9aKp+C3lOmGfFZiiy1DdAe6gd0Bqvc88iEcUQVxiB/zmcav7v+sR6L53SFuWecSST9IHyQfkxqZOdJ489AbiacyrPKBo6Be7C8If+DNwpGwTy+Jb3hVCmD4Wlv8FdQkaI8OIPOlMlzJkvB+fYZP+V4z/hxgNo9n1FETfIZ3a95TPuV/9ce2/r/0Vlu/afFaQvHzoy8kAYDViC4+7eU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 3:49=E2=80=AFAM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>
> Going to try and summarize the findings/discussions here, copying from a
> few earlier emails. David, you can jump directly to [Question].
>
> > On 2/11/26 16:38, Ackerley Tng wrote:
> >> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> >>
> >>> On 2/11/26 00:00, Ackerley Tng wrote:
> >>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> >>>>
> >>>>
> >>>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will re=
turn
> >>>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs=
 are
> >>>> skipped.
> >>>
> >>> Are you sure? We check for CONFIG_READ_ONLY_THP_FOR_FS before that:
> >>>
> >>
> >> Ah... I was working on a reproducer then I realized 5.15 doesn't have
> >> MADV_COLLAPSE, then I tried to hack in an ioctl to trigger
> >> khugepaged. That turned out to be awkward but it got me to look at
> >> hugepage_vma_check(), and then I went down the rabbit hole to keep
> >> looking for the similar check function throughout the other stable
> >> kernels... and amongst all of that forgot that
> >> CONFIG_READ_ONLY_THP_FOR_FS was unset :(
> >>
> >> You're probably right about VM_EXEC.
> >>
>
> [Bug]
> khugepaged (and MADV_COLLAPSE) will try to collapse secretmem pages with
> MADV_HUGEPAGE applied. There is no crash, but there is a false memory
> failure printout that looks like
>
>     [ 1068.322578] Memory failure: 0x106d96f: recovery action for
> clean unevictable LRU page: Recovered
>
> The correct Fixes tag should be:
>
>     Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibil=
ity")
>
> I was able to reproduce this on 6.12, 6.18 and HEAD
>
> [Stable Backports]
> The first stable version this affects is 6.12.
>
> In 6.12, S_ANON_INODE does not yet exist, so I think in
> file_thp_enabled() we can return false if vma_is_secretmem(vma).
>
> 6.18 needs a fix for both secretmem and guest_memfd.
>
> [Solution]
> For 6.18 and later, David's suggestion of using IS_ANON_FILE() seems to
> work. This affects more filesystems than just secretmem and guest_memfd
> though.
>
> [Question]
> I'm not familiar with the concept of anonymous inodes. What does that
> entail? Why is it suitable in deciding THP eligibility?
>
> [Next Steps]
> I'm going to be traveling over the next few weeks, so perhaps Deepanshu
> can help with the fixup patches for 6.12, 6.18 and HEAD?
>

Hi David,

Thanks Ackerley for the reproducer and analysis. Since Ackerley will be
traveling, I can take this forward.

Here is the approach I am planning:

For HEAD / 6.18:
  - Add IS_ANON_FILE(inode) check in file_thp_enabled() as you suggested
  - Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibilit=
y")
  - Cc: stable@vger.kernel.org

For 6.12 stable backport:
  - IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, so use
    mapping_inaccessible() || secretmem_mapping() in file_thp_enabled()
    instead

