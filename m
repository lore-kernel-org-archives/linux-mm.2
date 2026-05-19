Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CAE1CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 17:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256A96B0005; Tue, 19 May 2026 13:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207176B0088; Tue, 19 May 2026 13:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEBF6B008A; Tue, 19 May 2026 13:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC6D96B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:42:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52237C2A17
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:42:35 +0000 (UTC)
X-FDA: 84784889070.14.47EAD41
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDFBF40011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:42:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fRwiLolX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779212553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ibr8sHhzNAPZbLsPpxl6vK9XCU/Qn7i5IuLzHPKyPnk=;
	b=2MLAaTWzg1JP49Cmb6K75aA0s4HrW+C7DECTDUdZxLeq/JsOELmjxfNB/Jzg848GRshFe3
	ey6xBqAjygz+tksSwuyQxbHt0gI+GTMEXzJrmOOh8OubZr9lz8YV7G1JPC1gJ/bQy7p3rf
	Yt1HGGkC+bCBuvYAB8OgVknSttkRqdQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779212553; a=rsa-sha256;
	cv=pass;
	b=DNGv3IIr8gTQrQGvnrF5bduxcyFD1HPRjGytgpi/R8k85zdo73deqUBcDJMCBEZLQRLPNr
	A+7UvMMPLUFNU+G8l6PlG5ZMwFIJaGqpsCnzbmGoFpKQOf0v9Iz42pdci2QhsTwLgt64yD
	zM14aZ8tySlYVOwg5Y/c6bb90joCYLo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fRwiLolX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d864c23bdso7881cf.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 10:42:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779212551; cv=none;
        d=google.com; s=arc-20240605;
        b=Q+5CWWcVTxdvyGVbe82th7PeXtgr0CU47tDZT/lNmOk2EVRHYwI698feSkJ3YwVzlU
         ass3IJumi5vMFEWg+lwpWJcrR/Nk+sEoAKpwDpfaolqsgZynf8QM5CWDQgDdkKS5qIz+
         3ZWK8C4eoZ+puviVY8kOZZkKgeIHRHg8MzHE3QoTKKuIsLrC4UBWWUzTsmWVdevxwlk7
         nqU2ffiLFkmKHAVmCYCM5zBigeWa8riSJrhYu0enOApJ/xAqwvdCp2YdnTR3xYK3se/s
         v73+xVdUcubXdejdE6nLHB87OHMxU//2921p01Z/fpHX+V+anUh5yf4U5/FePdw8dJdv
         GHCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ibr8sHhzNAPZbLsPpxl6vK9XCU/Qn7i5IuLzHPKyPnk=;
        fh=qQ+Tvmabl+/KXNUGESfDKxfTxsdvu652l02AyQURElk=;
        b=J0lFfGWP/UEAE/0LlQtNDTe5QrHaaPXBIFDbvwRRgb9jEtFNTW8iVuBhm0MVcmjBX7
         pfZEVV/0FX4thScGuRnmH/Tb3T8cLmD9YNFTTd84AS8Hw0+Q8+bG6hFV/KMPrVgcPfBX
         yfG6aDM045ynsu+/MAzT0f1UkFLuEJwKUA71pY2NN2dH5vi1H3vYmMmwvEmZmx8d2BIj
         9fEFn933fWXezZBBpf0gJlfzslB5RXK5NFsUiz69cFS4b4IT6Pdk9qRdKRf/pm6QLx0Y
         nQJZCbjMjaAdivRfqjxkGNkQo49Br9mm8FOPXBtqHZXgPk940mttmOYg61wP7S2IKoSu
         ocnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779212551; x=1779817351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ibr8sHhzNAPZbLsPpxl6vK9XCU/Qn7i5IuLzHPKyPnk=;
        b=fRwiLolX+0RBrLpM0rdH/rba981xyLyXpZ1GT1zADckA3hjzLnhIroL097j/W991hQ
         wlWBgtYdzPtrb8o6LkmdkDu+i9jMZVmk6NMYaf4q07Auf7e1RjFyji/le3Vm78L0CoYH
         qFSmOTziPUH+zqhj5lXAAtwgAepzXgIobeZbOQvAZXsoCmMXWycVl6n9U9eM/FtsDjoz
         I6gn03cSA6XFOCg21RUQQwdvlAMfpCTWZ3QDv78bMPsvQyqOMzM2Hq5NCC6AixwEUrrO
         xd5i8Byy/OsghFIaZqYUGbJB8PUueATl/PPoqlObM9yPyX9jRt6K1T2fNdfvTRNb4Ax/
         NvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779212551; x=1779817351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ibr8sHhzNAPZbLsPpxl6vK9XCU/Qn7i5IuLzHPKyPnk=;
        b=oldnCPBy+4MMiBKB8H7d4IjJEuPF0tekpJEGZe/UyzxWigxZyEZqgPKystuEwzv0MC
         9sFnJmBW+vcDwYOiD4R6ipzyj9N3337+fnSQKbrQcsRN1sJj5ZZBoPwKjvt46IMCIwtG
         r3jyWrHTLfTS7IDbq1q21QLArlMoomsmKa3FwoEBHuXbCWyglyK/7xajc8b+U0P9Uph3
         D9cNWA8MGuJfZE0WWFkXKega1IK9CJLH+4Ywf3hf0vLlatt6U5dbFqk6boeC/VhrLEeE
         vbbSbHRe2l944rYefGey7jH+zXFN1bfatPxxKut+hfWgbgCmeixm+75+UDmbEiZLO+Q8
         ijJA==
X-Forwarded-Encrypted: i=1; AFNElJ+RbSI4mbs58P8InOGlRJ5dOZadpdJS9h+xM5Ay47H1WS6AVKr8xKGBlCP8JaoeoH9SsN5XmksXJg==@kvack.org
X-Gm-Message-State: AOJu0Ywy5DVz/3qCQKz9TE5G8CIQq4STSxQvLeFiykEBlZ8eo16MsXys
	Stkyb+Zn0yv6b8q1+XG2DoAzW4CwRZgWW6iSC+g3ysqxub6ldyWCtqDSKooS8haLYV2uY34GWlZ
	fWVQJV9AqXzLVKLPOkGIM5MUWf8c3qeQfzRJotbnZ
X-Gm-Gg: Acq92OHBV0XIlLpZP6KKbt3Na3lPbF3xfr9alorYofa9cDKJnzoFffWX4USwCjp9hp2
	4TCO6ICcgxgCAimInUmr+0RIwaD4ODSjNOYTYiZcqmY5/QVBoIj+UIt9ztAwEBfFpFBgXGJKPkh
	ImM8NPgZFG01EKwPyrWOWNyxXN4fMTyUBOEvhnimkaGeukGj9K+/fi/N8CKezgtX9CYnpx+fuD/
	C9J6xDI/bP3eA4QBT5ZCTT59BNgjATg/Lo+dYBo39C9xe4kwtgtVE/2mrhmQxi545jZqfX3mbEW
	0E8jiRRWUyvy1tXS/NgtKjuaokza7VcONa6UA915EuyPULPg
X-Received: by 2002:a05:622a:114b:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-5167b6769a7mr35729821cf.13.1779212549416; Tue, 19 May 2026
 10:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
 <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
 <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev> <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
 <c627136d-8060-4e2d-8473-0fe322ce1e6c@linux.dev>
In-Reply-To: <c627136d-8060-4e2d-8473-0fe322ce1e6c@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 19 May 2026 10:42:16 -0700
X-Gm-Features: AVHnY4IHz15Qzp2z0CXmgE43_nXXjSpuX6OMXtTKiskuKxfrIuqn8YV7pgOnRcs
Message-ID: <CAJuCfpFn0Oefewvjp1jBhCOgxxwhHFy_RK08DwQywOjYcfr2pw@mail.gmail.com>
Subject: Re: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDFBF40011
X-Stat-Signature: b3pgdqa5sxa6c7fdxyyrqq8xqriqzdam
X-Rspam-User: 
X-HE-Tag: 1779212552-221759
X-HE-Meta: U2FsdGVkX1/XXkpH4EheyFaK+gP+U1W23NxGaea+W7mBP6fvD+vGDi8SmeT2zvynfKYeRSCzWa1YDvSSoj/iETb9Eq4Pfsn+xy8RVt15xfJHLmosqmDccKxy+TjGI6lVZwxU2eoi68ZO4bs8/MAVrzscWk3X4GUeiXOC3h/CQMtJrFmHB0QABHgvAdJMs/jpagsiCXoIgJYvWH46FSK3r7VtqqIRg8WFUps4+T23lhAWeJxznwopG0iaaM9mdCMTh2j8+MCBuM4OP+bhHkLzPpxZP05L+YgDC+NqNab/QVcWCrH39YdCYxbp8uV8TiBCj5jEMimceJaNG+e3nL+7xQqsKPECgiIb64VlI4WhOMutFOTXE+fo8wyy6Yd1J4h99ZNrOeqbOcE/g2Ayk4rVHrSmOoourCdME0Sp+E/PDfvBog6b/g4ugukq4Lq61SorDGbig90yz7Anc+zITk+f9oKiRJtlHl3rxO3qD23uuRs/Y6Ktv75BP36MnJjBdC5nCQrVysGcT6j+6xHjJexsbAfPeN+N8Kgoiur+bW9YS38koEl9ssIbSO3VYhear8y1smJD+4oE0Uwp3hz0FPgLh/Z5KkCl4k3+H84EHwBg2WgZ26LfDkJ0LFnPCZRC9k9SX/LEELTQOLlhKFLoIiWxdZwdYQDl86irfVYVBNe4+uHav1oPF4grdLSURxXV7Ox79eM4dA+upwuqH+jHxuG2EzXcJxAII2vfMY00XTvXT6kwkHcbCO/aEP/FsZfAbc6L98bEzO78MMqzLdwdnzqA1r4fyp37tNOqWATCZehutMiCwlotLtMbXRIge2aTiDnMHyjrgxOe5J74F1IcpsdNgdVkgsXp1juVLeakaKR3gQV2eKa88nkTPcMA9qIOEqrryr2re1omMleZBkj8UEXHbJA8aY0BzOVU69w/Pj4BX5CXl3HMZahlcJTqd9PO1zrkRpt0Z5LCR3F0gNKtJ4K
 /9kZ19/S
 oZUhCskNRJj3L7SvXDHdmaVChEY6bp5sNHt0DRPfgijDE9I2FggOIe83nU55+srdaI3qnnpWDUoNCiASUa8QFFo447vMW7UXvjqCmeIydXci58bV6x/25CgpLCGSGBpjTB6GRwBYTFIpXYmbnNKg79hJmtA2yOH5Mv4cnGhrzlpd+XDaujJp3WF9CMxLpfhovcnM+Ao8Rla1NQ1gYcU07kw1/OMJts1CxhywXZlQFwSVtdjP8xF1JmXJeGeuGa3BC0KBMkn5ggZwuCOZTz7+1SM+lSg+vLt8wjKD/pWqYbmEZgB6TBXwNhmbaRY78KXCFnWNryDd4R0FXOmJrY4lCyQoZEaF54kjElQcQb42zSSRHcL8Mwnjr1k0AUWyuzdPq9F3ULrAt5+Twwm98ixr4mYMr5uFgn91MCU7i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 7:53=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> Thanks for the follow-up.
>
>
> On 2026/5/19 07:41, Abhishek Bapat wrote:
> > On Wed, May 13, 2026 at 9:38=E2=80=AFPM Hao Ge<hao.ge@linux.dev>  wrote=
:
> >> Hi Suren and Abhishek
> >>
> >>
> >> Thanks for the patch! A couple of minor comments below.
> >>
> >>
> >> On 2026/5/5 07:36, Abhishek Bapat wrote:
> >>> From: Suren Baghdasaryan<surenb@google.com>
> >>>
> >>> Add the following ioctl commands for /proc/allocinfo file:
> >>>
> >>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
> >>> to check whether the file content has changed specifically due to mod=
ule
> >>> load/unload. Every time a module is loaded / unloaded, the returned
> >>> value will be different. By comparing the identifier value at the
> >>> beginning and at the end of the content retrieval operation, users ca=
n
> >>> validate retrieved information for consistency.
> >>>
> >>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. Thi=
s
> >>> is the position of a record in /proc/allocinfo.
> >>>
> >>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> >>> one. If no records were previously retrieved, returns the first
> >>> record.
> >>>
> >>> Signed-off-by: Suren Baghdasaryan<surenb@google.com>
> >>> Signed-off-by: Abhishek Bapat<abhishekbapat@google.com>
> >>> ---
> >>>    .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >>>    include/linux/codetag.h                       |   1 +
> >>>    include/uapi/linux/alloc_tag.h                |  54 ++++++
> >>>    lib/alloc_tag.c                               | 178 ++++++++++++++=
+++-
> >>>    lib/codetag.c                                 |  11 ++
> >>>    5 files changed, 244 insertions(+), 2 deletions(-)
> >>>    create mode 100644 include/uapi/linux/alloc_tag.h
> >>>
> >>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Doc=
umentation/userspace-api/ioctl/ioctl-number.rst
> >>> index 331223761fff..84f6808a8578 100644
> >>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                       =
                      Comments
> >>>                                                                      =
     <mailto:luzmaximilian@gmail.com>
> >>>    0xA5  20-2F  linux/surface_aggregator/dtx.h                       =
     Microsoft Surface DTX driver
> >>>                                                                      =
     <mailto:luzmaximilian@gmail.com>
> >>> +0xA6  00-0F  uapi/linux/alloc_tag.h                                 =
   Memory allocation profiling
> >>> +<mailto:surenb@google.com>
> >>>    0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >>>    0xAB  00-1F  linux/nbd.h
> >>>    0xAC  00-1F  linux/raw.h
> >>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> >>> index 8ea2a5f7c98a..2bcd4e7c809e 100644
> >>> --- a/include/linux/codetag.h
> >>> +++ b/include/linux/codetag.h
> >>> @@ -76,6 +76,7 @@ struct codetag_iterator {
> >>>
> >>>    void codetag_lock_module_list(struct codetag_type *cttype, bool lo=
ck);
> >>>    bool codetag_trylock_module_list(struct codetag_type *cttype);
> >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *c=
ttype);
> >>>    struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> >>>
> >>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/allo=
c_tag.h
> >>> new file mode 100644
> >>> index 000000000000..e9a5b55fcc7a
> >>> --- /dev/null
> >>> +++ b/include/uapi/linux/alloc_tag.h
> >>> @@ -0,0 +1,54 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >>> +/*
> >>> + *  include/linux/alloc_tag.h
> >>> + */
> >>> +
> >>> +#ifndef _UAPI_ALLOC_TAG_H
> >>> +#define _UAPI_ALLOC_TAG_H
> >>> +
> >>> +#include <linux/types.h>
> >>> +
> >>> +#define ALLOCINFO_STR_SIZE   64
> >>> +
> >>> +struct allocinfo_content_id {
> >>> +     __u64 id;
> >>> +};
> >>> +
> >>> +struct allocinfo_tag {
> >>> +     /* Longer names are trimmed */
> >>> +     char modname[ALLOCINFO_STR_SIZE];
> >>> +     char function[ALLOCINFO_STR_SIZE];
> >>> +     char filename[ALLOCINFO_STR_SIZE];
> >>> +     __u64 lineno;
> >>> +};
> >>> +
> >>> +struct allocinfo_counter {
> >>> +     __u64 bytes;
> >>> +     __u64 calls;
> >>> +     __u8 accurate;
> >>> +     __u8 pad[7]; /* Add alignment to not break the 32-bit compatibl=
e interface */
> >>> +};
> >>> +
> >>> +struct allocinfo_tag_data {
> >>> +     struct allocinfo_tag tag;
> >>> +     struct allocinfo_counter counter;
> >>> +};
> >>> +
> >>> +struct allocinfo_get_at {
> >>> +     __u64 pos;      /* input */
> >>> +     struct allocinfo_tag_data data;
> >>> +};
> >>> +
> >>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
> >>> +#define _ALLOCINFO_IOC_GET_AT                1
> >>> +#define _ALLOCINFO_IOC_GET_NEXT              2
> >>> +
> >>> +#define ALLOCINFO_IOC_BASE           0xA6
> >>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOC=
INFO_IOC_CONTENT_ID,     \
> >>> +                                          struct allocinfo_content_i=
d)
> >>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _ALLO=
CINFO_IOC_GET_AT,        \
> >>> +                                           struct allocinfo_get_at)
> >>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE=
, _ALLOCINFO_IOC_GET_NEXT,       \
> >>> +                                          struct allocinfo_tag_data)
> >>> +
> >>> +#endif /* _UAPI_ALLOC_TAG_H */
> >>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>> index ed1bdcf1f8ab..5c24d2f954d4 100644
> >>> --- a/lib/alloc_tag.c
> >>> +++ b/lib/alloc_tag.c
> >>> @@ -14,6 +14,7 @@
> >>>    #include <linux/string_choices.h>
> >>>    #include <linux/vmalloc.h>
> >>>    #include <linux/kmemleak.h>
> >>> +#include <uapi/linux/alloc_tag.h>
> >>>
> >>>    #define ALLOCINFO_FILE_NAME         "allocinfo"
> >>>    #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct allo=
c_tag))
> >>> @@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
> >>>    struct allocinfo_private {
> >>>        struct codetag_iterator iter;
> >>>        bool print_header;
> >>> +     /* ioctl uses a separate iterator not to interfere with reads *=
/
> >>> +     struct codetag_iterator ioctl_iter;
> >>> +     bool positioned; /* seq_open_private() sets to 0 */
> >>>    };
> >>>
> >>>    static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> >>> @@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_se=
q_op =3D {
> >>>        .show   =3D allocinfo_show,
> >>>    };
> >>>
> >>> +static int allocinfo_open(struct inode *inode, struct file *file)
> >>> +{
> >>> +     return seq_open_private(file, &allocinfo_seq_op,
> >>> +                             sizeof(struct allocinfo_private));
> >>> +}
> >>> +
> >>> +static int allocinfo_release(struct inode *inode, struct file *file)
> >>> +{
> >>> +     return seq_release_private(inode, file);
> >>> +}
> >>> +
> >>> +static const char *allocinfo_str(const char *str)
> >>> +{
> >>> +     size_t len =3D strlen(str);
> >>> +
> >>> +     /* Keep an extra space for the trailing NULL. */
> >>> +     if (len >=3D ALLOCINFO_STR_SIZE)
> >>> +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> >>> +     return str;
> >>> +}
> >>> +
> >>> +/* Copy a string and trim from the beginning if it's too long */
> >>> +static void allocinfo_copy_str(char *dest, const char *src)
> >>> +{
> >>> +     strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> >>> +}
> >>> +
> >>> +static void allocinfo_to_params(struct codetag *ct,
> >>> +                             struct allocinfo_tag_data *data)
> >>> +{
> >>> +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> >>> +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> >>> +
> >>> +     if (ct->modname)
> >>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
> >>> +     else
> >>> +             data->tag.modname[0] =3D '\0';
> >> Minor nit about allocinfo_to_params():
> >>
> >> When modname is NULL (built-in kernel code), the current code sets it
> >>
> >> to an empty string:
> >>
> >>       if (ct->modname)
> >>
> >>           allocinfo_copy_str(data->tag.modname, ct->modname);
> >>
> >>       else
> >>
> >>           data->tag.modname[0] =3D '\0';
> >>
> >> This is of course workable in userspace by checking for an empty
> >>
> >> string, but I was wondering if it would be cleaner to use "vmlinux"
> >>
> >> as a default:
> >>
> >> else
> >>
> >>             allocinfo_copy_str(data->tag.modname, "vmlinux");
> >>
> >>
> >> For some context, in our memory analysis workflow we often group
> >>
> >> allocations by module to get a quick overview of where memory goes,
> >>
> >> for example:
> >>
> >> vmlinux:    2.1 GB    (kernel core)
> >>
> >> nvidia:     1.2 GB    (GPU driver)
> >>
> >> iwlwifi:    800 MB    (WiFi driver)
> >>
> >> ext4:       500 MB    (filesystem)
> >>
> >> Having a consistent identifier for kernel built-in allocations would
> >>
> >> avoid each userspace tool needing to handle the empty string as a
> >>
> >> special case. Totally fine if this is intentional though.
> >>
> > Thanks for bringing this up, I can certainly make this change.
> > However, the information is not currently exposed this way through
> > /proc/allocinfo. /proc/allocinfo does not categorize kernel non-module
> > allocations as vmlinux, so there will a delta between how IOCTL and
> > /proc/allocinfo behave. Suren, could you comment on whether this
> > recommendation is fine by you?
> >
> Right, /proc/allocinfo indeed doesn't categorize them as vmlinux currentl=
y.
>
> It's just that in practice we often group allocations by module, so
> having "vmlinux" as a default
>
> would be convenient. Let's wait for Suren's input.

Hi Folks,
I would prefer to keep it empty because vmlinux is not really a module
and hardcoding this name also seems suboptimal (in case it ever
changes). Empty string also aligns with how we output /proc/allocinfo
data. If the symbol is in the kernel itself, we do not display the
module name at all. So, all in all, unless there is a strong reason
against it, I think we should keep it empty.

>
> >>> +     allocinfo_copy_str(data->tag.function, ct->function);
> >>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
> >>> +     data->tag.lineno =3D ct->lineno;
> >>> +     data->counter.bytes =3D counter.bytes;
> >>> +     data->counter.calls =3D counter.calls;
> >>> +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> >>> +}
> >>> +
> >>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void _=
_user *arg)
> >>> +{
> >>> +     struct allocinfo_content_id params;
> >>> +
> >>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>> +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> >>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> >>> +             return -EFAULT;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *a=
rg)
> >>> +{
> >>> +     struct allocinfo_private *priv;
> >>> +     struct codetag *ct;
> >>> +     __u64 pos;
> >>> +     struct allocinfo_get_at params =3D {0};
> >>> +
> >>> +     if (copy_from_user(&params, arg, sizeof(params)))
> >>> +             return -EFAULT;
> >>> +
> >>> +     priv =3D (struct allocinfo_private *)m->private;
> >>> +     pos =3D params.pos;
> >>> +
> >>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>> +
> >>> +     /* Find the codetag */
> >>> +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> >>> +     while (ct && pos--)
> >>> +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> >> I noticed that codetag_next_ct(&priv->ioctl_iter) and
> >>
> >> priv->positioned are accessed without serialization in the ioctl
> >>
> >> path. Concurrent ioctl calls on the same fd could race on these
> >>
> >> fields. Just something I spotted while reading the code.
> >>
> >>
> >> Thanks
> >>
> >> Best Regards
> >>
> >> Hao
> >>
> > I believe this should be prevented by `codetag_lock_module_list`; am I
> > wrong in my understanding?
>
> Thanks for the explanation! codetag_lock_module_list is designed to
> protect the module list from concurrent load/unload, which it does
>
> correctly. However, it doesn't cover the race between concurrent ioctl
> calls on the same fd, since it acquires cttype->mod_lock via
>
> down_read() and rwsem read locks allow multiple readers to proceed
> concurrently:
>
> Thread A: ALLOCINFO_IOC_GET_AT
>
> down_read(&cttype->mod_lock)              // read lock acquired
>
> priv->ioctl_iter =3D codetag_get_ct_iter(...)
>
> ct =3D codetag_next_ct(&priv->ioctl_iter)
>
> priv->positioned =3D true;
>
> Thread B: ALLOCINFO_IOC_GET_NEXT            // concurrent ioctl on same f=
d
>
> down_read(&cttype->mod_lock)              // read locks don't exclude
> each other
>
> if (!priv->positioned) {                  // sees partial state from
> Thread A
>
> priv->ioctl_iter =3D ...                // overwrites Thread A's iterator
>
> }
>
> ct =3D codetag_next_ct(&priv->ioctl_iter)   // corrupted iterator
>
> priv->ioctl_iter and priv->positioned are per-fd state with no
> serialization in the ioctl path.

Yep, you are right. codetag_lock_module_list() is not enough here to
protect from such races. I guess allocinfo_private would need another
lock.
Thanks,
Suren.


>
> Just something I spotted.
>
> Thanks
>
> Best Regards
>
> Hao
>
> >>> +     if (ct) {
> >>> +             allocinfo_to_params(ct, &params.data);
> >>> +             priv->positioned =3D true;
> >>> +     }
> >>> +
> >>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>> +
> >>> +     if (!ct)
> >>> +             return -ENOENT;
> >>> +
> >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> >>> +             return -EFAULT;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user =
*arg)
> >>> +{
> >>> +     struct allocinfo_private *priv;
> >>> +     struct codetag *ct;
> >>> +     struct allocinfo_tag_data params =3D {0};
> >>> +     int ret =3D 0;
> >>> +
> >>> +     priv =3D (struct allocinfo_private *)m->private;
> >>> +
> >>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>> +
> >>> +     if (!priv->positioned) {
> >>> +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_ctty=
pe);
> >>> +             priv->positioned =3D true;
> >>> +     }
> >>> +
> >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> >>> +     if (ct)
> >>> +             allocinfo_to_params(ct, &params);
> >>> +
> >>> +     if (!ct) {
> >>> +             priv->positioned =3D false;
> >>> +             ret =3D -ENOENT;
> >>> +     }
> >>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>> +
> >>> +     if (ret =3D=3D 0) {
> >>> +             if (copy_to_user(arg, &params, sizeof(params)))
> >>> +                     return -EFAULT;
> >>> +     }
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> >>> +                         unsigned long __arg)
> >>> +{
> >>> +     void __user *arg =3D (void __user *)__arg;
> >>> +     int ret;
> >>> +
> >>> +     switch (cmd) {
> >>> +     case ALLOCINFO_IOC_CONTENT_ID:
> >>> +             ret =3D allocinfo_ioctl_get_content_id(file->private_da=
ta, arg);
> >>> +             break;
> >>> +     case ALLOCINFO_IOC_GET_AT:
> >>> +             ret =3D allocinfo_ioctl_get_at(file->private_data, arg)=
;
> >>> +             break;
> >>> +     case ALLOCINFO_IOC_GET_NEXT:
> >>> +             ret =3D allocinfo_ioctl_get_next(file->private_data, ar=
g);
> >>> +             break;
> >>> +     default:
> >>> +             ret =3D -ENOIOCTLCMD;
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +#ifdef CONFIG_COMPAT
> >>> +static long allocinfo_compat_ioctl(struct file *file, unsigned int c=
md,
> >>> +                                unsigned long arg)
> >>> +{
> >>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg=
));
> >>> +}
> >>> +#endif
> >>> +
> >>> +static const struct proc_ops allocinfo_proc_ops =3D {
> >>> +     .proc_open              =3D allocinfo_open,
> >>> +     .proc_read_iter         =3D seq_read_iter,
> >>> +     .proc_lseek             =3D seq_lseek,
> >>> +     .proc_release           =3D allocinfo_release,
> >>> +     .proc_ioctl             =3D allocinfo_ioctl,
> >>> +#ifdef CONFIG_COMPAT
> >>> +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> >>> +#endif
> >>> +
> >>> +};
> >>> +
> >>>    size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t coun=
t, bool can_sleep)
> >>>    {
> >>>        struct codetag_iterator iter;
> >>> @@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
> >>>                return 0;
> >>>        }
> >>>
> >>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &=
allocinfo_seq_op,
> >>> -                                  sizeof(struct allocinfo_private), =
NULL)) {
> >>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_pr=
oc_ops)) {
> >>>                pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NA=
ME);
> >>>                shutdown_mem_profiling(false);
> >>>                return -ENOMEM;
> >>> diff --git a/lib/codetag.c b/lib/codetag.c
> >>> index 304667897ad4..93aa30991563 100644
> >>> --- a/lib/codetag.c
> >>> +++ b/lib/codetag.c
> >>> @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_ty=
pe *cttype)
> >>>        return down_read_trylock(&cttype->mod_lock) !=3D 0;
> >>>    }
> >>>
> >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> >>> +{
> >>> +     lockdep_assert_held(&cttype->mod_lock);
> >>> +
> >>> +     /*
> >>> +      * next_mod_seq is updated on every load, so can be used to ide=
ntify
> >>> +      * content changes.
> >>> +      */
> >>> +     return cttype->next_mod_seq;
> >>> +}
> >>> +
> >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *c=
ttype)
> >>>    {
> >>>        struct codetag_iterator iter =3D {
> > Note, I will be following up with a v2 patchset with your feedback
> > included. Please bring up any other points you'd want to clarify so
> > that I can include all the changes in the v2 patchset. Thanks for
> > reviewing!
>

