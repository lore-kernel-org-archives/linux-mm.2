Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C042FC87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 02:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B6D6B00D9; Sun, 10 Aug 2025 22:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3036B00DA; Sun, 10 Aug 2025 22:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8A26B00DB; Sun, 10 Aug 2025 22:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7216B00D9
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 22:41:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFD5B82920
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:41:04 +0000 (UTC)
X-FDA: 83762924448.07.5AB57C9
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id E87C2A0002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:41:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gqjvhfU3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754880063; a=rsa-sha256;
	cv=none;
	b=AQR3PIoWi4+i7HS70AGFOt2hyQuuJO4Zu0IjkrjDbTib0aUIlESoS+ADzTRigh5h4YJje0
	JUwlSdoAbqaVALqMnc8QpzPQTWhU+/XBt3QYFNSSIdpfaBJrN1klgzWBD+jtC6CmjU+qMs
	LVF1Sl3pDG9h9bB4bOtVQVDxkhRAj2E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gqjvhfU3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754880062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEPO79lcAqliTFFVAgSx9X04AvKfXDh6E7nn3ae49xc=;
	b=eeM/AMj51T8tsyQxKiKoY+KiMzdjXYRN/iufeDNUn/BVlM6P+bU2MxoVfyZSL7RY2GFVzi
	aIFildTK3g+vFFiuZ2plwaARfAT612B/MbsInz7BGp9kqd7GhbCsZl8PDmbK04FdSLaWw2
	FvC7M8BPWLGD6aPKyqGGxh1xaB31lPc=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5394a7aae5dso647807e0c.1
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 19:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754880062; x=1755484862; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEPO79lcAqliTFFVAgSx9X04AvKfXDh6E7nn3ae49xc=;
        b=gqjvhfU3bLJk5FetbEq77WwYKhPd/PbS+BDV3sH05qSoDjIx+K1I0phUOe8LdpaSfD
         jTRhl3Ik8WXvi0tOgaHNlTVdmoCue4ttxYmA1FCEl2/42/boYFhcmYdm5HDQSIaEN1Sx
         YP8iMPcFXdib8B6+sZgszWN9X7O0ry8YZNYOQEgl7DezGhtXsb+VTSNVM94rikqSsyNJ
         0CmTbf738xehr1FHMXxXwRqrl71iFGqm+1yFpAQ0rmMMnNE2UQJsPH4KxmNqeE0OcPA+
         wmPUogWgcyr+beilfaBcui4ycZpHu2z0SHlq1W10B2vps8mkPB6aGs1PolaywfXAd/r+
         nq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754880062; x=1755484862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEPO79lcAqliTFFVAgSx9X04AvKfXDh6E7nn3ae49xc=;
        b=PRZbc/EdM7cevt/MXk78sPsbhPDZEebGJ1q/SIu++Ka8VFOZNBvewi78dt2Ot2ZmA/
         +UncTc15eCYL2XWb/bIQwD20WyUzVY6MZMDj+j/ZS1IxE/82htDBmyozj8rb4CspO2WV
         UcTjpqeCXOeaVXpYLCIJXPk6KzqdeNz0XBJLFWf//mXWcXQPe1xgNWDT1AdZ1xiNmepX
         ej1HKqIx9bmTNCjYbjA5Nhj9leFAHQkjype3FXgjP2umy7IbxtUynlMlL0ltuthE5HmG
         BYBrZvflGr8UAYeeAdN/47hRXN2Rf3hYGBLCUmhSAjRatTC5WViTxGnPmFKfaUvsy75p
         O/CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNqrGdgs7LN0kvH0vlm8Nr8iDTyHFLA+mDcZlttuygpguGX8t1uS/CHW3gkgA1ECHfzaoLAa8vMA==@kvack.org
X-Gm-Message-State: AOJu0Yw8D3R4tZDoc6wB4Md1aNM8A93RAJxVMM61uIRKsUwQXbyLmd59
	y+W94HrusmFz4ZHCIt2qFKzTJlbu5uVokKoacte6jRDz42lwGMhgbNQEcSR4jjLskItsPwDRFQV
	0fFFGzsjJwWL35Vr/HGRDVXo6+XZwk+c=
X-Gm-Gg: ASbGnctojvrDvNgva1ACiwo440Hq5xnzoq7HrZKKsNhN/rZUN3646eDaCd/YFbFLLjK
	3/CmHcZQ1U/6vV2mHF/FTLCtcZQGPX73crD9Vj6Dp2JA8ZQPxc7fQlUtkMmOmjNSs68fcupMRBZ
	bsZaAeJcOfE2QWeblvBwdPmFd14AUYPhuWdyHPAtjcQnd+IUrVFr6wbf3GEh0llbc0g87ARI3PB
	oxGiMo=
X-Google-Smtp-Source: AGHT+IG9M12oTQKXjakVvm7O5EdRoYMgP2LrdwPJngQsDTIg4mJl6/p9kPCNEkiFHHbjllCvovPLKhqLUYDr9ffqJEs=
X-Received: by 2002:a05:6122:134c:b0:539:1142:21a1 with SMTP id
 71dfb90a1353d-53a4ac10d5amr3628046e0c.0.1754880061889; Sun, 10 Aug 2025
 19:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 11 Aug 2025 10:40:50 +0800
X-Gm-Features: Ac12FXxh4BM1Q0JSTNoPZLQDxlAY6NtAXyQ0P5zZ1A7rFzDEZOlSUIymDp7nKis
Message-ID: <CAGsJ_4zuEcgg7U0yCMu6ayKqRPACtvuzUsC9vUxBk2PgMzaf_Q@mail.gmail.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hwyxwyucn6yd4583wj7xgos8or85xdc6
X-Rspam-User: 
X-Rspamd-Queue-Id: E87C2A0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754880062-219859
X-HE-Meta: U2FsdGVkX18VjNWuiKVFTD5D+lKMQXlBrrGbH7LKRxpJcWXsas+9qwTJRBbLYWgDaT01inddHcBfPJVuIVascjNVODw6w6jSa+Tx4ZBdoQfP6MfN0ZyI8mS69oo6EcpsVU9pjVjbL3q/yZzq1xxEqqgI50Z07RVn0gr/S57xJcTg0eSwoyOkAsRmBtrJ7UISOG9CNPSuY+fItDCDGIOuyNLlp2WuAqLDgHiQoaBvfUFPLjpe8vQfzQshbJVauEDUizi127oW/8YedbQ2VTLkit5RbGJma0np4ESLgF9+VtYz15tlwlQrLiuJvbuJUGmDsEvgGjtGg95xQjWn/NKkGZLVuZgdxPAa4jzN8aa3RdHcZt7bgpO0z2xzrQTXb26WN1ExJxW/kMx9w+XDSEeJVw5VyIg/gIDlrtD4wUxNrVcloiTBAaO4N8jAZw0C0IcttzN9azlcFd8V7bDvJAhpggTGMCgDh2ieNWGpJxw4qmWx39KoA5YHV3HNX5Q7fRo6S71l/Nu9KTJi3FA4ToSpQrAtQRq9ogW2bGUJ3NruuM69QrILYXvAFvzIz9Uz8zwbPA/oVWA0d583DPg1/bQtKIatsXGdanU1BVw63kITR28r2NUPJEJOKOcs9EGzqkGNkyDOHNUtiKfV69vBwSBYlLtMyDOPiPgGy5nTbJQgrOkhum6LtLQzIbKcROg21sUS7LiYaHR6FyqXfCV6BrPP4dnvKkZ5sAlH9X6BZSrc6L7H4Dtp6FyF8uHlpi7Mq98DsPCM+Aweb/7y3LGe/dlnpXKHBU89xYwDH3VZ1u9vbfKh1zvbrRGd2xmV3gn9GlSgkfED+USlHmhUsPZzvByqBoxcXXA5Egs8LJGkneqgQMlle0gFM+MMPhd5QAItO9nA7uSctcWbNggfQlZUlyuPAxcDhxWuqOdQbTGemHUAtUug4KqWVcM5Ze6ZrBI2iBIp0m4j4RFvJ81VdW0i8sX
 NShzbhjC
 2fKtxX5qkWVI0UWL4Z1lT/tp06be014pOtQCcsO/0BkPhdnobvlYFETmD2olY7/V/ACWzL5kq2J0fu547NDEwWW8jjWrhfBEBX2HBvWk/ASswh7gltnuJTdtUa0LyhhbcY8iLq3cLSrM7jiE5WMDZrniGxxZDYb7nwGvX2dALP+oRX+kMMjQXmnL7rYIgVXD9ksGfRts4RhhLSJ2q6gsBSuSC9Tx/oC7oOz32G3BBGqAvPwUWhXGo+ntYlM176deqQQD176RtqlyvauN0ChUQREEEBX1Z1XwupGBqes57EooF9YoffDqrGDLB7EibdwWWM625Ol8q8SUf2T5Lpq9sjRnlMtFULEAjyfUKFY1CnHT7ajD3YBP65aVxkDpLvc1voK8K/Quw4Yw1QIkUOatVqy+naPCvM6gSC9bKknbEEwClWDQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 2:59=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> It was discovered in the attached report that commit f822a9a81a31 ("mm:
> optimize mremap() by PTE batching") introduced a significant performance
> regression on a number of metrics on x86-64, most notably
> stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression i=
n
> number of mremap() calls per second.
>
> I was able to reproduce this locally on an intel x86-64 raptor lake syste=
m,
> noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
> 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
> 2,131 or 2.6%) - a 43.3% regression.
>
> During testing I was able to determine that there was no meaningful
> difference in efforts to optimise the folio_pte_batch() operation, nor
> checking folio_test_large().
>
> This is within expectation, as a regression this large is likely to
> indicate we are accessing memory that is not yet in a cache line (and
> perhaps may even cause a main memory fetch).
>
> The expectation by those discussing this from the start was that
> vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be t=
he
> culprit due to having to retrieve memory from the vmemmap (which mremap()
> page table moves does not otherwise do, meaning this is inevitably cold
> memory).

If vm_normal_folio() is so expensive, does that mean it negates the
benefits that commit f822a9a81a31 (=E2=80=9Cmm: optimize mremap() by PTE
batching=E2=80=9D) was originally intended to achieve through PTE batching?

>
> I was able to definitively determine that this theory is indeed correct a=
nd
> the cause of the issue.
>
> The solution is to restore part of an approach previously discarded on
> review, that is to invoke pte_batch_hint() which explicitly determines,
> through reference to the PTE alone (thus no vmemmap lookup), what the PTE
> batch size may be.
>
> On platforms other than arm64 this is currently hardcoded to return 1, so
> this naturally resolves the issue for x86-64, and for arm64 introduces
> little to no overhead as the pte cache line will be hot.
>
> With this patch applied, we move from 81,503 realloc calls/sec to
> 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
> accounting for the variance in the original result, this is broadly
> restoring performance to its prior state.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.co=
m
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/mremap.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 677a4d744df9..9afa8cd524f5 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -179,6 +179,10 @@ static int mremap_folio_pte_batch(struct vm_area_str=
uct *vma, unsigned long addr
>         if (max_nr =3D=3D 1)
>                 return 1;
>
> +       /* Avoid expensive folio lookup if we stand no chance of benefit.=
 */
> +       if (pte_batch_hint(ptep, pte) =3D=3D 1)
> +               return 1;
> +
>         folio =3D vm_normal_folio(vma, addr, pte);
>         if (!folio || !folio_test_large(folio))
>                 return 1;
> --
> 2.50.1

Thanks
Barry

