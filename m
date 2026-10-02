Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72C7CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E446B008A; Fri,  2 Oct 2026 14:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EE36B008C; Fri,  2 Oct 2026 14:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60046B0092; Fri,  2 Oct 2026 14:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6796B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:01:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E5BA14079F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:01:42 +0000 (UTC)
X-FDA: 85278454044.13.EC60E97
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58D4340003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:01:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZyM+f/AL";
	spf=pass (imf27.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790964100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+4EbiFBNnqYgSb/qkcxogR3PLMkymIv1+oGaFz8J9Q=;
	b=cpXjfBWw6jZtyEAZGhkIU5P2X2CoFWdQAQmhFVc32PS6o6F4sGmDz/WZA1CHTxDe7ldVr6
	fAAEWa2nhFkZSq3FqBc1lcjwhxu7pUe4y62FQjHlmXrd7X3TfQYcFVBmhbFXkR/VBTQLY8
	7S0VYOramT5ncVRMzEGLVKw17cb4aFo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790964100;
	b=7NuPk7qC0q5C9/ggMgIEpNEgMr8t08GRPtZt2srMUglpfV+cYp7f2Np3D7sV2op8HmfId8
	sUxXqZa9anYzEo3ZgOiJWY0SYvwy87IG7UYuYl5G5+SQ+YSGmcoECvPzUf8CjfMdRpqa1c
	Rt0oQP5vbMCzhZ2ZJP4KnSwYsneYdGQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZyM+f/AL";
	spf=pass (imf27.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e20bb4583so33175666b.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 11:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790964099; cv=none;
        d=google.com; s=arc-20260327;
        b=q34sdGLFuzf0epAXqwlnU8Fnwm7qgNsNsTfAih+X63axuoMPSidtgyy1Bm9DuGtC4B
         to3Gdb/LPgpoOu5Qsngs/zVLKiubNAiQzfvNBAtFwI05oDEVe8M5SxxdWWxab5KdQZmK
         4Ay74KeD6JLRPUbGHoGL5bo2uuGcsCR9rjIQT21aUQ1ExyFWj2ZAcmVuS3Kt04c4dYTD
         lKsj4q9QquXtzwUFK3nNA4w/jXQOSmy27LwmGKIx6CTbe5/mAan3+ybyICjd1MIY/MaV
         mU31KoExjFl/jaHIAU3pSecV2omop029ULsZ18pwaDjer1KUSVpL0Vb45i8DyqnpmTPH
         dLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G+4EbiFBNnqYgSb/qkcxogR3PLMkymIv1+oGaFz8J9Q=;
        fh=jgWn73aSQIvhkp2mDV6ENDmNlDS3/uChiPo/WOu0Aj4=;
        b=Q94KLysu8FQMyF29sTYl3cwt6mk+50VV15KuZZ7TJp3IZTkQkl3mwwB2PRs36HNPex
         4zmmwuGm2C3DpD7D0Q8HW27Tjja1icPeKhGRtiMzNwWyMRUTd+ISXegkahDisGhNFS3z
         8BmunIZoBrtHt37k2sEst04xvU7NlxGb85z0emaRMGUcsh1Ue0u7ohcKgSrTQtYnKJIf
         B4ue2fKQnt5f7SQU2bjZuH/57+qpHnXvInaTHdvdSyM9QK+4GQEs5L9uPmJJffcTzYKy
         V2sHBvkRMezCOGePC9sQYRkkhclGe9mIa2GBVJOGvKGqDi1D3St1mc/LuGgv/4wovAWG
         9zRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790964099; x=1791568899; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G+4EbiFBNnqYgSb/qkcxogR3PLMkymIv1+oGaFz8J9Q=;
        b=ZyM+f/ALSx5qKvzQWxs28mbhaqUVMBNbXZBLuHKUmkdeLSoNTZ/2gJo/SftIo7Ri+l
         26wcU/cuvnlOBwQ1WHIC/fWYK93BL243i4SCosLAeEkl+wlwv6GfhdoHY6pfrGqh4BaN
         BBc0q47Cx4ZlEZ9Xn8yFQ719nsyxEFqSWMHmuUCuPl0Qrf+I/yK6WvDvexY/GGeVGMl9
         Yc18JOAMjt29ncLjywla0+IH8AmFCYhx6iWv1SIw/6zCYkxzMOJ5lEaQOwHXJj7ni5iJ
         2QcfjwI2iPEkgoRnVwjrmKgI5RaYHMyAHWBoHw1XFtjlE0JMgXbqeo8FM283PXAhIKOP
         i3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790964099; x=1791568899;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G+4EbiFBNnqYgSb/qkcxogR3PLMkymIv1+oGaFz8J9Q=;
        b=KitCDMgx7x+Gs1GJ9ftkpHDdCc8hhHgTr85dzjwzDT3UeDfHfT3vw6fm/KT7AD8UqZ
         +R1vk942Y07n+5REJ1CMXluu/7rRW7tVPsvT3ClaMEhlToosN3lx9G8ILQIpKLX9nZjK
         YykLqXmsISXzz/pWGOCCout8yYhuUPd+PQUlcLajwqSsr9kF4+RGbfS4FF4+YSWdIJwQ
         7dBVcOpee3m2EUi1ENyef0Es8s7W1rjGTK58fr7G+y8Galp8tL4MBb08SZfMsu48hf8S
         BMYuKqsrr8AbZEcyVRLmOOtb3Y9gZsSOSbtppEnfPX3vlVBTPXaoC/V8GA+3jHNgQ/dX
         pHtg==
X-Gm-Message-State: AFq9FYIJjFGvFkGFAxoDoVMAYvEPgNPvWIqptzZLXCm9It/0VtSP1wQ9
	eFzTLTtCpx7eKEUzHS/aYd8lYAkzVL+9XCM+hu8F/yPzgTJrnL8iGL1PCOIZhbvWOHBo7KFxe/n
	dXw5gM7KuVu/14GH5WlyWi4JcAjiOh6c=
X-Gm-Gg: AYBFou0jL/S84Yf01NBs4rpSJvE/jSkMNwRFVJ6sCmtri5yQHJ3YOmflWQWf6TIMGxs
	ZRrwHqcPoeJ6eTE6Xrnbb1kp7uKoJBX2GfSo0bSxMNDCaSkm/xwIgtgProuhTC8M0DpvJn2jwhv
	HcyVXBz4qSYmd3XQ7JGhRN7uJJhmAa5T8i4FdhdjyReIvijQ+tbSWBHfciCH4gDGXERHqxBevbR
	SZsQ+MGfoFKKsSL1vU/3hli333sxVw4LFoVO2bJxKiMJh7Du05T6SELk8HbVwxZ8kokckKZI1MF
	+f4JS9nA9hk6FlOZ5PdmmQnPV9odOmMG90K1H9NuzpahTRa7rZtzy7hAcowda0f3yos=
X-Received: by 2002:a05:6402:4543:b0:6ac:765e:def2 with SMTP id
 4fb4d7f45d1cf-6af9e37a328mr2000619a12.41.1790964098443; Fri, 02 Oct 2026
 11:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F>
In-Reply-To: <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 2 Oct 2026 21:01:27 +0300
X-Gm-Features: AclHuK-vl5tAzwgoppMvS5Z9IRnATx9Ht1qOfMIeFmMbuIVN4mgOaojwbtQXzeo
Message-ID: <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
Subject: Re: Poor memory bandwidth performance between NUMA nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58D4340003
X-Stat-Signature: imyfu4uhiaey1b4k9g3ckfsfun35e1yf
X-HE-Tag: 1790964100-988425
X-HE-Meta: U2FsdGVkX19UztvgY6pCKnYxD27z6D4dz8c1Uwc+2zV3GjDD9uUU831PJt5ZpLqkMpV8tnZQxj7GzQHgkmpxTtSXrNR5aNc7fQDYXo6GKxpCS3lVgFjfqFyRGY5zWf3diEG3diZzBV8FxPy/lRTwQar6iBDiB9Qn9bpGeb1MSdOCEMckxujqy+TqcAsssxMfAAKU/aGRvNQl7qYFLccdfBX7IFdY2wkxg+uRgDwMmSkz1xni+6Tf2QVIyEmB+WgvTc0U2Dd5Imarb46TjnK9csb9gW/BXczwJMCJsw2sBsX3IJwKQRMOZ30i0tcEGURv77/zr+bmtq+41OeelrUZYBKCKw+BeVGDeCKb31YTg1L0WEx+RvhfIEoxp7phVFzRx0E+u3IC+tepeO7y8UfuAXoXYZHKwwoW6vJfjm4h+xsJMAiU7iYyQ4fCRusSh4Ywup+lWCFDEh3FR6ldDrb/gWYlpQJic4S2CzbVFGTB3VI97OJ701dQ4mfI5NDvsSM0C33DWgIEU2ZxGET1SQ4xH/Fga4OVcC37Cru9Od516eM3AD3HfIjh/iWoHsFisPl0o5nWGyAQcyMtqN7FQrC/6Rt45InKf3p5jlL7W+DgKPqyV5wZKNsUCeOVWs2H4j12SEUX2K9MDeX9y51tgBxYuXL/tA1b9SNNbIRxltiZbfnlUuhmT0Z1JseS7mzLsKbnmrcGpCQ3H5mkldMcBIQuMTLdb0VAc520Pos0+dnK/oSaXenztLMzYzPImemFu1D4hpWurlImkUX+UcOsU1TRANbz5KQRNZ9fufKpett8GyBYXk1ZXRWYinc5zZqA9qOwrD3tDwDT23Am4X6a1+V+vCt2/3ZpuHVGIiwEVkMaW4O0r0rGB1RrCpdpCXfOK23yybwcGolqx8PWoaauzm6KktGFa3iPwzncUnt3SymDB5FXTocNY1DnuP/uMuR1brSEb9zLNVwBMA60egR0pnB
 MGOhZak+
 cM6yTxs4muQIA1Htr1lNo7KiCmi000nFvGS6SRjgFPNBwBtLd8ZZ7ZA2UBkyDG7fDJF3lJ2Uup4r4oC5q/Aa8ASvW8gVfECNuTD6JZsltcQxQqRIhMvnJ2wzV9elox3XB8+Kg1E4C/juQGpa3lt8c7N8UIX+T6GGXvUEMZZwO1hC8DoJbAQKhQbVd9CPQFtXUWLHZ0Jo8u3W/ZQ8HUT5tB+iP+Ril7tuoprthgYyJhtJMdmfh7dJqOkaCUsbD9AbeubxBzqBFz+DILtZzR1CVxdcCn+7zuKKcPslDYqrBXokooT9iOXaix0UXKC7Kz6WPfYJXu4y3go9MKvkhxlHuW4D0Very8Ucn6mal3jILYfiFLR6kIFswx/jX4h5ssYefhChHEmzu8e0br/8Avv0mBDpkRhv5kRJvtQfOrWQCFZYj+3/bHaN+bsRAbVJ4fZM7jTumvJgDeV5kQcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  - Optane has like a 3x worse write bandwidth performance than read,
>   so expect it to be significantly slower.

Single Optane DIMM (1st generation Apache Pass) has sequential write
bandwidth ~2 GB/s
But each of two namespaces is interleaved with 6 DIMMs.
So I would expect sequential write bandwidth per namespace ~10+ GB/s,
6 times faster vs observed 1.4 GB/s.

Lastly I migrated (by migratepages command) Valkey pages between DRAM
NUMA nodes 0 & 1, and got the same 1.5 GB/s with the same profiling.

Anton

=D0=BF=D1=82, 2 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 20:47, Greg=
ory Price <gourry@gourry.net>:
>
> On Fri, Oct 02, 2026 at 07:16:12PM +0300, Anton Gavriliuk wrote:
> > Hello
> >
> > There is Fedora Server 44 (up to date) on HPE DL380g10 socket server
> > with Optane PMEM DIMMs configured as system RAM for simulating CXL
> > type3 memory expanders,
> >
>
> Couple things:
>  - if possible trying onlining the PMEM in ZONE_MOVABLE.  This may
>    help avoid kernel data landing in PMEM which would be very bad.
>
>    If page pinning is required, then this will likely not work as
>    ZONE_MOVABLE pages cannot be pinned.
>
>  - Optane has like a 3x worse write bandwidth performance than read,
>    so expect it to be significantly slower.
>
>  - the stack below would suggest it's likely the folio lock.  You may
>    want to check whether the folios are being pinned and you're just
>    hitting a wall because of the temporary pins or some other contention
>    on the folio itself.
>
> >
> > 48280162400 lost: 0/0 drop:
> > Overhead  Shared Object                      Symbol
> >   49.82%  [kernel]                           [k] migrate_folio_unmap
> >
> > migrate_folio_unmap  /proc/kcore [Percent: local period]
> >   99.52 =E2=94=82       lock
>
>

