Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC52CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 18:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207E28E002E; Thu, 28 Aug 2025 14:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0368E000F; Thu, 28 Aug 2025 14:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7318E002E; Thu, 28 Aug 2025 14:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5DC98E000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:06:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B3171A0326
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:06:01 +0000 (UTC)
X-FDA: 83826944922.29.5A649E7
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 823438000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:05:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRRYUcjO;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756404359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1wcerDY9ZxMErqt5APhVLmL7gKLDhYWEmpEHHKGi0g=;
	b=oBJisAbiCR/FS8TzMJz+RTn8VocJ9hUik7UA7zx3RUHK5G7bvkRa2ORsryDvr4UQk3Cn3t
	ZD3S1EkIC/SKWW+eoRrOEWpYRyCS/HEwrPjcDbz3kKm8X/f2oNwALwS5sQpzw5alTVu/1P
	Ol3PNAa7O4atrEEyRgi5XemF7EOuuXw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRRYUcjO;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756404359; a=rsa-sha256;
	cv=none;
	b=umngc6dTsEPBGKT9on/3IfP+V8U93wtpXfOr0hrMlqgdfMsNEXLhgQDTW9EQUiHgaSg9wN
	Va6RXpx54GR+9LrqxGRkdU7fMC2GDBUtAd8IML0v6ht7LfbtlyeHmCU5PXzDcRtso7jRGQ
	KurBP6nXHQteQ5bSdb+duqEygP7YZyI=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-336a766a711so6337751fa.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756404358; x=1757009158; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1wcerDY9ZxMErqt5APhVLmL7gKLDhYWEmpEHHKGi0g=;
        b=MRRYUcjOgqBu7D45yEt2/Y7x8vH6vmiror/yWXOtsuzOFyov8nvRK4XrDuouvYNG+Y
         JczP100P8MjrpooNCV29j8EWy7EzhwT2ABzIQtfizeEGn5OLKa4F/eLmTx2+e+vYqFjE
         QaDuivqLXfkptveYTLP9rZGKsATQoShNPPXjd5ouhdxBE4uIY9mAuU8Pz/XkZ78PXC9t
         FwdS8A72Uu6vArr3wwjUjaXXANtCd8yNR0GNIFDcCyqjgDVJ526/lWwatftznu4xaDVr
         2SQ2HEcMEgH3bZ9TiYc6j+6aVh04or+DzwPPU1GfJI5LAiXRLzWgY15aRRySYzcuiSKf
         Ieag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756404358; x=1757009158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1wcerDY9ZxMErqt5APhVLmL7gKLDhYWEmpEHHKGi0g=;
        b=t3oMoxMTgTE8vDp9xhiRloRPls9IRMCR5v6Z/F2wmYokO/M8gT59rFWwszykdKLmCP
         wiI/5Rr7Rqs0LqfFHZeiKHJoVYGAaSe7xZab091ucn8GSOVK+MdW/7bJ7VUs+MeatSGR
         7+CAYaET1Z+5GrcztN2APCYNo0xbu64+oCW4cGA7Hxvwq6Yp3gXqQBNjfG6FwoULDS+c
         gsBl/CwkNZ8xL7kFRBQllsX7SmoeCw6zWIeU+jV/eMDYA/wNEPBLbQjQfA6aeDFIraIf
         QBnIMcwWW1bSDVYfrP1iOFw6e0Lodx3az8o4z0BXV0oldaA9mVFvQGq6F9g9xceo3YGF
         1Avw==
X-Forwarded-Encrypted: i=1; AJvYcCVvmPSJ4w0YivJ7kuUsTFAB6pIN40809rkriPEYeMO5eoXdHG0OsTG1CJOhOC/tR+2IoRxxqUho0Q==@kvack.org
X-Gm-Message-State: AOJu0YxFCsgbuIF46Q4PW1R3GdDC2Svqjbt8X2B7XWNSvgHrjSjYjsQj
	SoK+KXWgfN1Fjzu/vVVK3vAT/hsi3jZL4LOXK+UHTHat/sniQ5ZcxqsB7jZ+A/g4/Jg6DkYsifu
	hk2Itdf1PgiTM/+zIFb4kjL4xUmBMg14=
X-Gm-Gg: ASbGncst8CnCMyg7zK6o5sg6GHAfVcLLCFGWfzuR7AebvjrJLDnkXuXKxn98MF6BPDP
	OcF8y5fhUesxDdxyik4Ab+fmVo1VR+4Z8ox7QUjlv0RvkE/4t//fPbKiK93CKDV+M7N7hC7T4u/
	NuW7C3QnVhKCY3S2JhhFJ/By9+LLRcmTzQaCbqFhjL9HXWmrCSSKncLTi5qCl8C9dqkjQTBCRfP
	xUaVsPy
X-Google-Smtp-Source: AGHT+IGB6TrFNT4SQJTwC8ZhmYP+oI3RCBH1w0gudce3W73CXC0aZ0kpMuhoSB7evC/LMmmDi5YOkrTutjtvnvf6RJ8=
X-Received: by 2002:a05:651c:20cc:20b0:32b:78ce:be8e with SMTP id
 38308e7fff4ca-33650faa9c1mr49163651fa.32.1756404357298; Thu, 28 Aug 2025
 11:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com> <c12b9236-903f-4a8f-aa9e-fd4d9ca1bffd@linux.alibaba.com>
In-Reply-To: <c12b9236-903f-4a8f-aa9e-fd4d9ca1bffd@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 29 Aug 2025 02:05:19 +0800
X-Gm-Features: Ac12FXyG4DY_-h7AMdrWx7jUmFgnl0-nMz4w3-tUx0Uy-hQLA-KPFCjc3BR-vIo
Message-ID: <CAMgjq7CRWeozoMbkJV43B+06UjakJw6bc0Wn1=2ai=E70=WE3Q@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 823438000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bo3qnnmktx7g1j93qr3n9ayzsmgoixjz
X-HE-Tag: 1756404359-520735
X-HE-Meta: U2FsdGVkX1/lTAahn198Xv0Ll5gzUKHLYnfkJCu2RxuAyLYPSA1uoZmZ41X06fZPgmpcfLFy5KU6b555Q2q6XEkgnDY0mJpGC3VBLE6wS6gcqu8KbVbTqS61cU0reEVh/pR1dDiOgSRZsmSb3GoWzmWNbt3IIffiGMHVcuvBK8Np16qI8mIPgh4IvCqKZ0ue6C+BO9TWJ7niwoHSUJUJ1OuZqwNYTBNJRSasJVM5DYbK1l/AGCpwwRIe69AfCnPfOSw3k69wBFNc8mz9JYijvD5ecv+/aWbylUlq+Jv/4Q0GIBTKedri5MpVG7nBdFDPrGi6fuz7MYR2ylmqc5RSsAiAF+S1kcak3QEPpItKaCKnpPURxefmHMiXhaJ8F+2Z2xazpN/B2qi6sv+IWns132UdosoW0FmjO9jy19LpQIMFPbKukvax62E3RUJnPwTvsvfOf/s2QJShqAYn/Iki1jOiOrouISIfan3XIUhMXRFahwGNDpf/RJgp5Ak76C9lYB+f5+odPGDd19SynNX8SvIG1s4cpXNNgoXPZptpuQEwUOzV0f8NdsGplBYQA0Tz0ZBNC4dKkAH8FanH1vBaOisijwIpCsAO5fRTVXuWwYeQo2PJZ+bmfJOVJIiD3KTThiZ1lghBdQCSAq73FkBgO+pi1/b/Stxq3iyTqD4lememhxbh1iCrzrxCKXGVAVXa9+aWCTDbQdXk3UxIhSYIqjy8PvlZpBaaLNvWuP8nXB/ekv62dHu3+CtSsSPe7gM+cTU4d1Ni6POJFS/ecb22YP11L/sDyyWb5dDRV3EUIV5nAIeYcyViAB18rtRTls9kyLAzzLm2544bkI4k+WF+cHVU/HzQ7JMns/zrUxtXVRQBDWmbpHMsd0a53tOJuyIuRf0XbEJeNBekIiAewHxEeHf3HvYKhXHYoWu46F8IOD68g8xWMAAeNNh7cfZ57vySLv71DcmInfzO25ppBH+
 JD/0K2Lx
 DbkEWkow1sRGaVwbcVPLvOsKKG/rWDiTGh8ckpW8qZmE706gbcX/kcHvq+GfIE6VeZtW7SbZmEwcoTOm2UvdljyhJKgftHoA5fWhi+F9tKuQzmbiYfyfegTPI03wqDQmRt9xkB8zeViUTL+kIxC5KqLAVWuU8kMVwBTHXOCD8paK41mVzWRCIplKKsCvowZmL2lKEYJWRewlr3Dcsd9cN5oixSnJnlv2J++IoPMlPsug9wjFtTXGEbkqnASWJC+Dua5CbXnWyp7WwsoxucgMFYIrcUSdzxZILjSIewzCfPSFyt+1CXOUoErwoTDqPgyTggBdQxPBJ34TbyDoBj5+Mort1C4qkewFZLWTlsx7+pCiULbAHHszAwirSGk23aE8CAY78NMuMPxKwKJo37KpBPjO00wBcXK7sUC+vI21s05MoITU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:41=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/8/27 22:35, Kairui Song wrote:
> > On Wed, Aug 27, 2025 at 4:21=E2=80=AFPM Chris Li <chrisl@kernel.org> wr=
ote:
> >>
> >> On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com=
> wrote:
> >>
> >>> diff --git a/mm/shmem.c b/mm/shmem.c
> >>> index e9d0d2784cd5..b4d39f2a1e0a 100644
> >>> --- a/mm/shmem.c
> >>> +++ b/mm/shmem.c
> >>> @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *ino=
de, pgoff_t index,
> >>>                          count_vm_event(PGMAJFAULT);
> >>>                          count_memcg_event_mm(fault_mm, PGMAJFAULT);
> >>>                  }
> >>> -       } else {
> >>> -               swap_update_readahead(folio, NULL, 0);
> >>
> >> Also this update readahead move to later might have a similar problem.
> >> All the bail out in the move will lose the readahead status update.
> >>
> >> The readahead deed is already done. Missing the status update seems
> >> incorrect.
> >
> > Thanks for the detailed review.
> >
> > The only change I wanted here is that swap readahead update should be
> > done after checking the folio still corresponds to the swap entry
> > triggering the swapin. That should have slight to none effect compared
> > to before considering the extremely tiny time window. We are only
> > following the convention more strictly.
> >
> > In theory it might even help to reduce false updates: if the folio no
> > longer corresponds to the swap entry, we are hitting an unrelated
> > folio, doing a readahead update will either mislead vma readahead's
> > address hint, or could clean up the readahead flag of an unrelated
> > folio without actually using it. If the folio does get hit in the
> > future, due to the missing readahead flag, the statistic will go
> > wrong.
>
> Yes, that=E2=80=99s what I thought as well.
>
> By the way, can we do it right all at once in patch 1 (I mean the shmem
> changes)?

Hi Baolin,

Yeah it's OK to do so but it's kind of a very slight behaviour change.
Currently patch 1 has zero behaviour change, so maybe just leave it in
this patch where we sanitize all swap cache conventions all at once.

