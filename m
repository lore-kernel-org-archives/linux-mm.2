Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCE9CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA388E000A; Wed, 10 Sep 2025 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1ED8E0001; Wed, 10 Sep 2025 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7518E000A; Wed, 10 Sep 2025 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79AA88E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:49:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B8C81A0396
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:49:07 +0000 (UTC)
X-FDA: 83875437534.30.2C695EE
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 491301C000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:49:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ILOjOgjH;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757558945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OZoiAx3D14NUhogiseSPH9gCaOHyrKTxNV9KPmuGJk=;
	b=Tz//brSVuYxEjZoAhO0ka6lH1WZRQJKe9rn9XdFl8NndBKljaVdpefjbtm0TvTV7rrlfcS
	TK+10bmJIvlI+K9qFR3UweajGkXBATHbKgsoPifZj2bbnpA+Xe4sIjvTGKSkLWvtQmpboJ
	UHiAgKvEKmgfitkhwgQS+XwJvHctfk0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ILOjOgjH;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757558945; a=rsa-sha256;
	cv=none;
	b=cww4S/fIhBUfgP2fh0NXaBshd3dnLcbXdin1uPnUeJGBHdK+WjF5Apyi/dy7LfasRp4xkv
	AuVwboGadCCWQRW5ez76NQbanfVXRmWc42o51v/wNhqtBSQrG7CQlZ0Nwf9DPusg2Uzk3t
	mwJ7Ow2RjSGWH/26EiEpUjR4f0bTctk=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-627b85e4c0fso421033a12.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757558944; x=1758163744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OZoiAx3D14NUhogiseSPH9gCaOHyrKTxNV9KPmuGJk=;
        b=ILOjOgjHPxMe9biVIaWj6yl1+wf2keKp5GBWBeM4fld7IOaF1R8NiYAcQFw48u25/0
         b1PLbqX6ECwbeCR9Tzl1sqwGBqJ7deqkFqjocGmW52VJYLndRpNKdUfjtfhEyFddd8Bb
         2Qwcz+s7Wg+YbWdx7xsUNkprJ/2p7TbDGV/w6SKvPTQuWUEaPCX+OdiZC7UNQh8LLnQ2
         gAAacqLEi2RZUHoTxNCVqx9Go0tpulIc0QQJoIjLeu4lnR1fGV9TKrsaRcwAgi918COc
         UKoMZz3nKyYKP8vNvuW9ge6Ef307bWC0d5TmjKu3SToMYZ2t/9lurAjKOTqkOvtnumSX
         d/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757558944; x=1758163744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OZoiAx3D14NUhogiseSPH9gCaOHyrKTxNV9KPmuGJk=;
        b=QzYNnQmF7c1XFd3v/txaiP8rMfkvxVNcggTPl/q8kWo9NIOnRAhzxgQtoA+5D4wFAo
         Aeu3TXRwRv+BNqodKQH0WmLWn3CyKOJfFz3zN1LBhMwZkwdUSgZ6L7cLUHL8T1m3OpSz
         KRFC/6vGHK43w5R8Ha/Tv3IBqXICS/wRBc4VapP6LoUvRv7koN9V+7IwN2LqqbBRnZap
         VXbbiarBFUTKb3UC0xBf05HUUjcIKA5u8iC9oLoDg85SePFIYVOZg2K3Qunjn06FX9yf
         NgJ5BBaV2MzkKY0m+pxPpp+Ocp8aHmHg6OV7lqe+Iym4wBDYtUIS/lbhXBUYBB0Clltd
         crvw==
X-Gm-Message-State: AOJu0Yykrbr9egdsPSZ0njePtUrVc547WLhicH/aF92tALB9q8OFlcDs
	ULnV17y1tgaWypJEr7+VxS8karIxO1VQwcCgMbhICQ5vxyzIN8uGDpdDvRvEJCOvbnN5gKLo++w
	YNZ81fwGtsriFPLQWTKRPlyVvBDaGA8Y=
X-Gm-Gg: ASbGncsLvz0GI7OqpDc7Ut9AwP10nQChlvEOWFq8zgCtcri4SBfGPNG7VMMFltaOD2R
	un1pTBVnaKfr2LKM+dfxLDRIthWAntqr07vmdiJ4QzG+jmPXHEEhEsR4Ci0le0EPFCSg2NNhVf1
	OoaosCt7ZV6uCElG/W0tN8WuznpsD5Ay7dtE/aV/KKsYnkggT0RmvPWwbUI5gpMDykX6k8karPw
	scJYSB2LsY=
X-Google-Smtp-Source: AGHT+IEYHmvG/jugLq7AgXA4mg/ZW7DuKWF7PgpBRp/DjnIiezoiI7BVOiKnT/2u6xwHYZ46AUuUh+pceBX2k8UFMyc=
X-Received: by 2002:a50:f605:0:b0:61c:c9f0:643b with SMTP id
 4fb4d7f45d1cf-62e7532be3bmr1184638a12.0.1757558943455; Wed, 10 Sep 2025
 19:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com> <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
In-Reply-To: <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 11 Sep 2025 10:48:26 +0800
X-Gm-Features: AS18NWC5UawFwugDPvNI2uWDDImGqhex1CbdEPqHScQ40krGyxpQdpVNzqIYko8
Message-ID: <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 491301C000B
X-Stat-Signature: n1eytqkya38i9miw1mz1d77bfkkmbbog
X-HE-Tag: 1757558945-809805
X-HE-Meta: U2FsdGVkX19kP8nE0eVM926B91Xz9XAMfVj+y6R8UK0gQZi/ngKniHOhNYkiPsKvrScaln+6cmK1EgE8AT0lyuBYl2ri8x2DpB5c+idPavKDCewrX4uwrpZ/RVa22ZVAIG+wh3Kythisy1tOGwuEBtzEnj73JG2Tx4VtJhUmlowZ+j4xoCy+uzlUz4yIHS/+pDtpUDwPOE2uSvtpHP5xxRLNJa0pmWBkLFguZYwTzjwtK4Q6pZhuOoNdN7GpcgkC97jLxxOX4qf0E79utwmE1+3pbo1bIIDHxAyt9ARl4+cliYLM8OAQMN0fYgcMsRlh/6bLWh2030CKj39xti1p4JiX7trU09twLO5TFQ+TdHK+AvnyXgIaaEctWONmUpXFs2DcW6t67wGriTnNtlN2RXHqgnuxh45dX/KVIiPkm3HEFmLVdLVZZ1k3tDqOwoLV8mu8BpWxfe0neZCu8m9W0IJyBlE55+m0g+k9WYRXNEc2WLanqzjHrNuzr6R4nb6+B31ijMRpg2jadMzl9/pSpgnYJGbA4PW5eMbbkIONEqLgWlzDTRGLGCtAwKbVOcWevRUYP58h4L2t1A5K0SI635vikworlcopudkuxweUgrGr9Mmmx9mlHOsUyO7jpzpIsCHfZVjCg4dEQqAKutiCOT0bNZnLKHfWs8wM0Lm9HOyZr1zXgpfxNIOtzN51H8MOVTaK0CUEI/oSN7Gni4HHSHV49WNprb45v3GFU85q4FADNpQ7skg8XIzTMMvJ+m1RqNh5Z25j1tIvVk71cMj4M1WgGFkiNAPvgQY0eDGhvLVJnpTujXMWf/RDvtF8/uJ+RzceBgqQki1qhgvLfcUKs2/+YURy1fxNTO1s5r18GaPmb68xqNd1xNV8G/4ctpdujxiX14Fd7ybGr4hRpDA28RMy/F5/DNB09hLZdurlNl6nZ4eqycvLkf+vQpA9cF6cx508gooRyXdkTp+zH0W
 zogs/GXT
 gmS1BENdTm1K2x9WrheYL3SaoDg4AaWcIJVRxw/DjEH/kK6w2D6YSasVbxXplmekUlsJIhN5cD99ZxCWGj4ayvzbuMwWBm7Tlhmk07StSQv+2S45USV+v7kauMSvookJUuXx2nGgBnGu8QWlQ1nVpWyQQWLLC0fSRBR1kt6sYMRBjZUcIgmHBNG7o5Dga1itGfeOvDz0DcGaUVV1bPkLQg8y75UQQfn6Y33jRGDpt8xpRaIQyuglrdu0dRgOElM+xForayNBfkXJ5JVRN0kQHXAoQYT/AnaLw9TeWGnDaILMczUcD1P83C1Fjugf2cdbfp0A5z5M5qQlJqXDQF1ZDG7+cz3e/3OBRqv/AJIhPqAVHFhGd+nW27VRJ8uxvxc2Z5KSwv9htVPhrBe8eS5ke+mt7H83tPz1ileSPIIZAhmAuxePhYyeUkAc/ZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:34=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
> On Thu, Sep 11, 2025 at 10:27=E2=80=AFAM Lance Yang <lance.yang@linux.dev=
> wrote:
> >
> > Hi Kairui,
> >
> > I'm hitting a build error with allnoconfig:
> >
> > In file included from mm/shmem.c:44:
> > mm/swap.h: In function =E2=80=98folio_index=E2=80=99:
> > mm/swap.h:462:24: error: implicit declaration of function
> > =E2=80=98swp_offset=E2=80=99; did you mean =E2=80=98pmd_offset=E2=80=99=
?
> > [-Wimplicit-function-declaration]
> > 462 | return swp_offset(folio->swap);
> >
> > It looks like a header might be missing in mm/swap.h. Please let me kno=
w
> > if you need any more information.
>
> Confirmed that just adding #include <linux/swapops.h> into mm/swap.h fixe=
s it.
>
> diff --git a/mm/swap.h b/mm/swap.h
> index ad339547ee8c..271e8c560fcc 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -3,6 +3,7 @@
>  #define _MM_SWAP_H
>
>  #include <linux/atomic.h> /* for atomic_long_t */
> +#include <linux/swapops.h>
>  struct mempolicy;
>  struct swap_iocb;
>
> Cheers,
> Lance
>

Hi Lance,

You are testing V2 not V3 right? The build error is in V2 and I can
confirm that. But In V3 I've added "ifdef CONFIG_SWAP" for the
swp_offset usage in swap.h. I've just tested allnoconfig and it
works fine on aarch64 and x86_64.

V2: https://lore.kernel.org/linux-mm/20250905191357.78298-12-ryncsn@gmail.c=
om/

