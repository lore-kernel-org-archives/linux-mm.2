Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DA1F9B5F5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510566B0099; Wed, 22 Apr 2026 05:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1136B009B; Wed, 22 Apr 2026 05:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFC56B009D; Wed, 22 Apr 2026 05:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5556B0099
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:49:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C03921413FC
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:49:21 +0000 (UTC)
X-FDA: 84685718922.06.35C2A51
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFDAC40007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:49:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UDnGi4OC;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776851359; a=rsa-sha256;
	cv=pass;
	b=wtAOVKU2CVHJsLChQU78RJ4wBk1xOoU9ym/Ek5jjaO0ahatdua3ZSCCoxU9OQA1wF0cskD
	ihOBIu0MpBP2gABxoUzCXvagmydrGrFcszhu9Hsv4cmJLC6IEfZM3bNoqHVyZCwkbfT2RS
	DblHpaOcuvWvrMGWS3cBbQ2g/3I8New=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UDnGi4OC;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776851359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnEJCn9qcdEo9A9u8FFKwfmqRTtu4QMr0EYD5zgIlGI=;
	b=7wLlGO7r7Y1n4vEzXzE9knu1K7fr5hukxWq+v2cUbNieg5TD97zvQuPHMz9BFGqjeXQUka
	oUUs+n5k6qanLi2QGszNMusv4rBInruiZ6OsJTkZdqCJpcgqHVCnrZJTfVQwYo/kdNFvYG
	KjLhSzKMonIGalJJkl/HdZ5jdvsV3QY=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-79a74765703so48895987b3.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776851359; cv=none;
        d=google.com; s=arc-20240605;
        b=SxE3TPycfmjRG/aM6Stad/LN1seow91V2VAbTjp8ORH8o0adLBKaiZXB9Rt124ImpK
         FPu3Z+GEIRnydcH6Hm/b+2VxLnpv2FaNq1egrRdTuQ/x+cliVChs+3N4XgtDPeX/eUqu
         AiZV+vD7oadcLqBrPPoM7taXb3lIfgPouSUViPHXE92zzUNEUW+bXgUmBsJX9n58NioD
         5tK1vCFaUlJiW4sBKDufL94OYGM4ac2WN4hB/zOcjvnI4ZUBKxSkMD/mYR5AgpnJ9W4x
         03LugPeVujNYuIrsGKSEUfbjjJ7PUJsJaIQa9yd9OH+UtXc7TICTg0vbU2Q0ZZFm+ieZ
         RoLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mnEJCn9qcdEo9A9u8FFKwfmqRTtu4QMr0EYD5zgIlGI=;
        fh=sVmzYMyQNjI2hAUfB+K/lBTm2/mx5cZd3WvvZE1mFl4=;
        b=gF2nXO2woamUF81gZxuxNJ84DJmiCIusm73/bkXBsuxsmp7T128R7Z9KO4weUKDYT8
         5vsPgs1axEIk1bd6HpLFXLJayBIXMGFA3Tdj75B1XqAw8OSdzIZGyOB4G03dPv3nJGu1
         iiz7zySV8nAjX4PthndQpCkrLhJvHW+a6ymGTSIplXJV2KbDHyNj9gQkBFuVV3CiRlte
         f+Jz+Fas9M6g8Rku3gktgmPb8wths/W/O8WXJ8qhce/RSp0PEY8hdeYigEkMpZs2L4oj
         rxoUelhyQB/jN2sITdzZyYJRe+7uSHH/g8E/VGE9LXOudVxlQ0lvfXg9OnNcZV1+U+K3
         IuNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776851359; x=1777456159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnEJCn9qcdEo9A9u8FFKwfmqRTtu4QMr0EYD5zgIlGI=;
        b=UDnGi4OCmfNnnMUKB5aB93f8ESYb3B52KEyXm/9p8gcvFY58wXnX0v8NOuH6JAsijF
         MVu0eVrvvEH8qXOFMK2adnvD/8F75IqFDUClIBtyqDUzBEJA8CelKO6dO4a4/Z2q+Acd
         z5EPLu7Y1w9tSwLh+LkkIzXD7EaWR2cM48rrrTxj+uWY2HjJadpJAz6uH5PsP0SdxGPE
         x8udjLoM27gxTzxpVBm6NVbcbZzVVnqHU/b99MblePYE1gtkhbE/gw+3WVAfQsHq0cNj
         4Q2uMvZIcHDAlOwFydVHMVGf8AOKrY3ugsEbU3DY0zkGlf7DzlrmNMrufkc8uAYV7z3q
         p63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776851359; x=1777456159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mnEJCn9qcdEo9A9u8FFKwfmqRTtu4QMr0EYD5zgIlGI=;
        b=HjmUQANVN014SVHt3arQCwGc3W+fu09O/mhMzV38RNkNN88h/78RxGu1jNrZxq9s8u
         YazrK5TS6CEKB+bOQeLAb4dEFYBLDNN0n8ksvc3jygpQp5y6fIlpNSgLYCx9I1dYfksi
         VvPJ+iay2u+/j9FtWa0XYFuYH3WHA8NZwMIJL24splOiBAMPAYLPxqIf2ROels4wSQnU
         V0FJkCT4P3zDgHmkHAnZ4ESPcoMlIFbl1l/Tx58VkV31oy95695/CwgWMH9ZnBNU3BCc
         lTFSon78Cv5Z3/P6VqgxGAu8/3Hjw/l+/URjJJbcSlY02y0xzDO629ls1009UbrNjkr3
         Jzpw==
X-Forwarded-Encrypted: i=1; AFNElJ8O8N5R5AaLD66k7JvkcdY5+sIWvhpKNCbof3yyIWZXs8j89hlUY92h3f530YFQBl6gdetRJ0SUKg==@kvack.org
X-Gm-Message-State: AOJu0YynULkAwV6jf4+u5R3aHayqhp5Epj5B6xk1q0D4G3togAXe+WAy
	p6GxPJD4K1icSqNeC+mnMJXvUMM4Y59vph42T4qf06mumMOJxJHcxQjel5vyFzQOCJrHflX1RDb
	/mqoWZo+n2caMRzTGSRldGLBZVfGZK2+D3g==
X-Gm-Gg: AeBDietesLoPckhdQ43YYj+FEWsxD73uHzRepRYxCo8FpnsXhD46xinbH5AOqhlf8lM
	cBqdG3Ae2ioEaEtIo2nx1EXUcKfwypZRSpSrfVM44Xmm873JDRnTnG9pJ7MvwNmlDfNFlusLxvq
	sCW9IPvXbIfEoQinyNMUwkCMUT+5ksEYwc/vP0DJ/MOpvTjD+S4KcuyB+/AHr40jDhzn3JrOklk
	h+lgj3+xFi12MheRQ51sWfaE/HLbmObjc0CReGwwMsNQKLe/nqzWABppYwXA5rLkl+frsCBLWVx
	txieGhYXLzuxDlM=
X-Received: by 2002:a05:690c:c4f9:b0:7b2:dad2:5e0d with SMTP id
 00721157ae682-7b9ecfe760cmr213516377b3.33.1776851358719; Wed, 22 Apr 2026
 02:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260421230220.4122996-1-ekffu200098@gmail.com> <BFB1F124-B599-4832-A9DA-F4931999BAF9@linux.dev>
In-Reply-To: <BFB1F124-B599-4832-A9DA-F4931999BAF9@linux.dev>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 22 Apr 2026 18:49:07 +0900
X-Gm-Features: AQROBzCaZ7Z9Mk91yEqKyDj0Oo6UjkyRQyunFf6C6oUiWpmI3UgnYhfbqW7jaik
Message-ID: <CABFDxME9-zh_NUJUfygAgWBBd=y51As=-JjUKyGCBLU=MSTCcQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/hugetlb_cma: round up per_node before logging it
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BFDAC40007
X-Stat-Signature: ou4rmr4qxk5d7tzrj7t47e1411cijkcy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776851359-415586
X-HE-Meta: U2FsdGVkX18VHYMYYaosUAXn+CPuHXDBYss66r6OxouFJZh61QWbkCDL8a+CkJHMCWrsKjAUOp2Kewn4JjhVSqgcLBPBH+aDW68aUM9VnFGxkTdEzjTE/yGaEljlDyEdBVR6Mjxv/TBOnTPyW+RgkQcERya+Ypzr8oQhEyFyXxNEsgdonInxUrUDqZvRpjcLr3HV0Q4LYzJ6kNXWCgupiLuKi4pbQwBLLbFFMJ6xJLDplv2ODRGDHUYJNXrn/7SRwdqNMJKKDxrBU9CjR1Oc/LBzKsKsLGR1fp6Dd4kqEem7vsqQL8DT1avszNhe2KuhMHvkmd+fc6qdMITDP1fevE44oNYVYqgWb1XdbZjfyWygAJnctEmsqVZ2sAkuaWHi3pUO5O2k0mA3qK49rwLAR5wG4Slk9PvitVVivBHe4YaJZzm3o4udzUT8V7nJ4rvBPJ3GYV1NHUJ19stF8cvswxaNuFSUwpnK1oG+2uLjEQFlf8rrYpdkaWTRJ4+zrIIe7WQzltHR/zPJYvOxDV3YTcPP/8yleR6QdNmsOKzd6XsUimtAQPKcsWiKZ/WniKDwL36ZdPb3uBUp2XxE4T0/8lm2zy+egED/kPPlZDOJjiPk2BKRfQxp+hMF1WpN6yUIEnpz2pMEcARVcdKgMkZdUhQz8nJTcjhk/lnTrmOeVQl1PCc4uQGVOUdzMlWarSU5Mx1WnJ26xHeNbS4A57Agtwmtic9Bd3/wJj4DJjSpJ7P0nhMTQ8/KRdto2MP8r8FGYTGFfIw/8KIGFF4JqOcpzN40ZwZkB/Q72h+5PYIc6ARkDK/1mepOCaaQdr0LYdrqYtd0ka5LBG3UEEHRP3aD1kzeRBrlR4bVDAFk6zFFS18d/MR4hUs9hT2nE+DS/MV5LrfHa9doDl8edcghs4QGrKgr96kOEt04xTeEbK6y1s7WDt4Sw5z6vm2yon/CtebvoAzGBQ/2F+BnkxOm6/a
 iqU5PlxA
 gzoBi75Xt5H08RwvatsElaS4iLIjrygceGhZE9kil4ggfZ5y8IChiK3VyysgPFPmU+/dIszogAzTZmmhDMV6RMDrKqlC5P5jVS5FqQ4MtlaaugJ4q6FJXZv0uU/5kvg8VVJUSxrcmkRMbo4bmDIxGNBtLHC6u6sKYcPJ4+V/mu8r/cRY2kpahKGiIvjKKVrmeWiK6JJgsxy8PqYawUUeTsUzSoxaw5naHWmhXMTzMZeKj2nrs47y3AukGRk/uNn5rmT8VlnMdhUBjjE8oKyuVI5wMncq+UNEWMx12Xsu6NURe/+CICdbS0Ky3WGkCKR+fBQLj8KOtkZ22xbjz1jfmpAEvMWzElWZG+XqMT1iKtz8CnHfsJjg0U/+U9m6L8VHdGhf9yyxQRB90Lv40oPltiIkBIuE6f7QAIlYwYJPBSIRgwktiq6iHeLjOj+E3IL5h3E+o7fMljRGkediy/UatrYUWr8tXfBf+E09km+RJoQyLAyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Apr 22, 2026 at 3:21=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Apr 22, 2026, at 07:02, Sang-Heon Jeon <ekffu200098@gmail.com> wrote=
:
> >
> > When the user requests a total hugetlb CMA size without per-node
> > specification, hugetlb_cma_reserve() computes per_node from
> > hugetlb_cma_size and the number of nodes that have memory
> >
> >        per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
> >                                nodes_weight(hugetlb_bootmem_nodes));
> >
> > The reservation loop later computes
> >
> >        size =3D round_up(min(per_node, hugetlb_cma_size - reserved),
> >                          PAGE_SIZE << order);
> >
> > So the actually reserved per_node size is multiple of (PAGE_SIZE <<
> > order), but the logged per_node is not rounded up, so it may be smaller
> > than the actual reserved size.
> >
> > For example, as the existing comment describes, if a 3 GB area is
> > requested on a machine with 4 NUMA nodes that have memory, 1 GB is
> > allocated on the first three nodes, but the printed log is
> >
> >        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node
> >
> > Round per_node up to (PAGE_SIZE << order) before logging so that the
> > printed log always matches the actual reserved size. No functional chan=
ge
> > to the actual reservation size, as the following case analysis shows
> >
> > 1. remaining (hugetlb_cma_size - reserved) >=3D rounded per_node
> > - AS-IS: min() picks unrounded per_node;
> >    round_up() returns rounded per_node
> > - TO-BE: min() picks rounded per_node;
> >    round_up() returns rounded per_node (no-op)
> > 2. remaining < unrounded per_node
> > - AS-IS: min() picks remaining;
> >    round_up() returns round_up(remaining)
> > - TO-BE: min() picks remaining;
> >    round_up() returns round_up(remaining)
> > 3. unrounded per_node <=3D remaining < rounded per_node
> > - AS-IS: min() picks unrounded per_node;
> >    round_up() returns rounded per_node
> > - TO-BE: min() picks remaining;
> >    round_up() returns round_up(remaining) equals rounded per_node
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > Hello,
> >
> > While looking into boot information, I found a minor issue.
> > I am sending this patch as an RFC because of the two additional
> > questions below (one directly related, the other indirectly related)
> >
> > 1. This patch only fixes the log output, not the reservation result its=
elf.
> > Do I need to add Fixes tag on this case? (i.e., Does this patch need ba=
ckporting?)
> > If so, I'll add below commit.
> >
> >  Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepa=
ges using cma") # 5.7
>
> Yes, it is recommended to add a Fixes tag. The rule of thumb in the kerne=
l
> community is that if a patch fixes an issue (even a cosmetic one like a l=
og
> message), it should have a Fixes tag for proper traceability.
>
> However, please note that having a Fixes: tag **does not automatically me=
an
> it will be backported** to stable trees. Backporting usually requires an
> explicit `Cc: <stable@vger.kernel.org>` tag, which is reserved for functi=
onal
> bugs, crashes, or incorrect logic. Since this patch only corrects a log m=
essage,
> I would not recommend adding the `Cc: stable` tag unless you believe this
> misleading log has severe consequences (e.g., breaking userspace scripts =
that
> parse it).

Thank you for the detailed explanation. Until now I had understood
`Cc: stable` tag as the explicit backport request and `Fixes` as an
implicit one. Your clarification is very helpful.

I also agree with your opinion that this patch is not appropriate for
the `Cc: stable` tag. I will add the `Fixes` tag only to the next
patch.

> > 2. When node_specific_cma_alloc is true, the reservation loop can break
> > out early due to round_up() before all specified nodes are reserved.
> > Is this intentional or a bug?
> >
> > For example, with hugetlb_cma=3D0:1300M,1:1300M,2:1300M and (PAGE_SIZE
> > << order) is 1GB
>
> To me, this is a strange configuration. While the documentation doesn't
> explicitly forbid this type of allocation, it doesn't clearly state wheth=
er
> it's supported either. So I am curious why you have such configuration?

This is an example scenario to describe the situation below. So, it is
not a real configuration from the real world.

> If we say that upward alignment is allowed=E2=80=94for example, allocatin=
g 2GB
> when a user requests 1300MB=E2=80=94you=E2=80=99ll notice the code explic=
itly fails to
> support configurations smaller than 1GB (where no upward alignment occurs=
).
> These two alignment requirements are contradictory.
>
> Personally, I=E2=80=99m inclined to view this as undefined behavior. If w=
e=E2=80=99re going
> to fix this, I think it is better to restrict user input to strictly foll=
ow
> huge-page alignment. This should also help simplify our processing logic.
> Let me know if anyone sees a downside to this approach!
>

Thanks for the detailed description. I think your suggestion is very reason=
able.
TBH, I'm not as familiar with hugetlb as you are, but I'd be happy to
work on this with your guidance.

> >
> >  hugetlb_cma_size_in_node[0..2] =3D 1300MB
> >  hugetlb_cma_size =3D 3900MB
> >
> > Actual reserved size is rounded up from 1300MB to 2GB
> >
> >  iter 1 (node 0): reserved: 2GB, 2GB < 3900MB, continue
> >  iter 2 (node 1): reserved: 4GB, 4GB >=3D 3900MB, break
> >
> > As a result, node 2 was specified but no CMA area is reserved. If this =
is
> > unintended, I would be happy to send a follow-up patch to fix it.
> >
> > If I misunderstood anything, please feel free to let me know.
> >
> > Best Regards,
> > Sang-Heon Jeon
> > ---
> > mm/hugetlb_cma.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index f83ae4998990..4a92a9e38500 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -204,6 +204,7 @@ void __init hugetlb_cma_reserve(void)
> > */
> >               per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
> >               nodes_weight(hugetlb_bootmem_nodes));
> > +             per_node =3D round_up(per_node, PAGE_SIZE << order)
>
> Missing semicolon at the end of this statement. I'm not sure if you
> actually tested this patch?

Oops, It's my mistake. I tested with QEMU and I'll attach test result
to the next patch

> Muchun,
> Thanks.
>
> >               pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per =
node\n",
> >                       hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
> >       }
> > --
> > 2.43.0
> >
>

Best Regards,
Sang-Heon Jeon

