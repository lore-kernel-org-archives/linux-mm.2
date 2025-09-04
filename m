Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDF9CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE93A8E0015; Thu,  4 Sep 2025 12:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC06C8E0010; Thu,  4 Sep 2025 12:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDC68E0015; Thu,  4 Sep 2025 12:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7688E0010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:36:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F13E856C9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:36:56 +0000 (UTC)
X-FDA: 83852122032.21.F1ED60F
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 53FAA10000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:36:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CVyzNL69;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757003814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7904c62jqnr+Z9vpb9OeNuICRFS6lbka6nmTNqOdF0k=;
	b=Mbz5WiCizmSkcflZx+tY4O/YHuR0hRsHYDd6NML34EV0Qi01UhrOOIvitGj+oKDwg+fkYo
	C67ZXAbGNPkQMmsFTHbCLn1ttfaG8rc4+E/+tRdXKP0QqYNTaqss8J0lrP6cTPtKF3Oz0e
	CC8zFmIPLwTtETPspaVIT5njIkKtfTQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CVyzNL69;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757003814; a=rsa-sha256;
	cv=none;
	b=aOQevbZFO6y8yO6RZdCAbPE+yFP2RiC/Kgz3ehJ19b7oOeEz9UxiNUASyNQfJFtN19y2Z6
	rD8AofmOTXStBZncUL3afmmVz60/x5DHx+mAS/KnO03YCGhbZMHwYZWYwSs9N8b9ub4qAq
	NpdgBzHxaPoaoMpESNTX7Ao9FlSkLGE=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b793d21so1951087a12.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757003813; x=1757608613; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7904c62jqnr+Z9vpb9OeNuICRFS6lbka6nmTNqOdF0k=;
        b=CVyzNL696v/JVz5A6Q2kgmkr4b8uC5CqflrKa1LvzWZ1j63ZLHH6A4tnjx37NMvehs
         ylE579lCNjeM47Bwsr8CIsK1GXVeZOddxWVGgbzP9vUctQEkAAl+4DaK7jXL6NLlqDLv
         TrR95nGHmHVr4x0QvUyC6ynKkHqA4782ubwFaGKhTU9qol0t/RG87rX+q3+lCFwjMnnI
         f/5Y03sKT2drzTF1WxxD9yeAjwphE3doFa4JnJeO0DlJoed2HmbXm7R1262rvYyJ7697
         hHoAuLHZPov42pA3d4R1uiuBkKWIX2LTyktEpBZHcNIoKKFjpQb5ZuYOQo7yoy0hkBtI
         WnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003813; x=1757608613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7904c62jqnr+Z9vpb9OeNuICRFS6lbka6nmTNqOdF0k=;
        b=PIwY4tODW07ETKHUdQBXWM9wVhXtLaGWrzMdnvjpo3CCHVCoCPJ0GRjovgtr9B1XAx
         bm2qbuLpw3RKF1iiGGygjbWhFciyiHBPJhCZX3gaZa7vD7TonxTnX9MRv7B2VQxW54c6
         HWcs57e7zBiEFa0KxTvXCToEfuB/yZ9IXXElG4CMjvc2Lsubap7pDMk+tZYP3SY20res
         eEXbandHyTm84XA5rXUcscqwoAA1nRqxsnLDmA+0/RdrLGO0zvXMD6G1YAXoXMSLTn3H
         Dq/v0rFAMbT4KZUkXXQS721YS7kZr9wkl5UKhLqQvm50Wqs29VifSOi6zjbxigJ3dMu8
         o+xA==
X-Gm-Message-State: AOJu0YzXOX+uM297203TQkGXo6JR6ZVDbJ8W7yoWVruMVxOZYDZjq0ds
	S4NpEpSTSzluSso3AH/ec3G2v7i9OeNF2kgkiu1wUAa+/pyx1j/xq+KsQ9EuULoLE7NQjsyJJ78
	VcwVIZ+DHlm1ElXh3fga59hG8pTrRvQ8=
X-Gm-Gg: ASbGncvxyIacJ0wdphuQKNmc5FW21PsNobtVVXnq6zVx977OYG/7olAvhawxrWh8bbt
	e0A8XInIoFJ1/eNBL3jpL8XRdYvI1F6MG0DqTDXsLjJeRddUX5XrhMXfSRFKKdNuRBgMQBqLeT0
	+/ah/CMRV9nMUihge2tTShuS+Gm5dUZuT8IuvPVkf3XAlV9JVwJc+wTrxtOc8+zLGwjVMl6n6Xr
	qsfZV+kSiyow3g5ExVeoA==
X-Google-Smtp-Source: AGHT+IEA2UeIAkXr+e/tdWh3HGDsg++x/c5BndXwl04n0fDAlOHFSLcblpbp/pDol4/9hV6KP6nc7aCS9TcBGJams98=
X-Received: by 2002:a05:6402:504b:b0:618:aed3:38a with SMTP id
 4fb4d7f45d1cf-61d26ebbf9fmr16584771a12.31.1757003812505; Thu, 04 Sep 2025
 09:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <CACePvbWG85YJFpLDoFnz05tX2trUJFTzyuELMGYSYr5ye_hQ6w@mail.gmail.com>
In-Reply-To: <CACePvbWG85YJFpLDoFnz05tX2trUJFTzyuELMGYSYr5ye_hQ6w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 5 Sep 2025 00:36:15 +0800
X-Gm-Features: Ac12FXxXIyA7Ak57QaP00eHzQFWcLDAWH7ZbkJmCacJCM3GF4SOIsmmFYuv5ftA
Message-ID: <CAMgjq7Bv99OHvbEiDcEMVYS5bRdSgSu75a8YUEQ+3roLiOo=ug@mail.gmail.com>
Subject: Re: [PATCH 0/9] mm, swap: introduce swap table as swap cache (phase I)
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53FAA10000F
X-Stat-Signature: je11g4yegyb9jfwzab1oxxd6jtuectzi
X-Rspam-User: 
X-HE-Tag: 1757003814-136088
X-HE-Meta: U2FsdGVkX19unP5jYqCSjrc67yvv3+1qXCTeYTjt0T/zCj9vIYDb1QdsetVkoTwsjwo5OjG6KZvBCQRlp5dB9DFjqIQqIhRiSNGlyDOT4p93xuULWOcWLsr6pJ/m/LGYeBti6/eUBhnBRE4fIRDo00Ys1PdChzS2jsEnlsRvYsMAw3shzNO9eGNYzajbEHa2BPhvQAXCxTJkDFg4Mk5GdD+HuBgdMHrZwMHdag5ADhnD4AS/z2Q9wH+BEzWhIN8TuxfCpScQk/U/sG6P8cZ1zOzhM7oKE2HRL2B0ik9j2vEYrUKeYEIf7l5BY9rUUhbv/otO1CBH9Yt65uwgqAsGtc6KGX19EkaFqA5oXF75fo/BbZRtXC21mN7+IY1JBxcTWuI4krZGubeYyGjmYHqh73xQY0DtytCE9GNAOrnoUrGQna8WE48iywSO4XHn2TAeEOk571Wl2DXu8YPg8ERlBUHNq51cvCDlYgkSMv/JuK8T46Smg12v1UjP1ig7u+iCdVm+fg9VabO+HAhAFUWz7I+AMM9ZSmMsnu5G9m+FKwen16u5H5lHCoOx/0wDyZnm8OFudAZefT+RhKtlI9PpjLbPLQ8EVfppfrxq3SSlkXOLMy5OCs9PWN7AHM6avxnahDjV6VlaLRzuYKUK8Q0UzrlK5Pux8nlyY1y6KQIOnUgdpbe4eidU0JU2rJ0aVerxlfoTTdbsIw30arK2OPOGmGnjiTjRFC7aWerMz9Av+h0+Lg88+MpnZl4O7xdv2S4h03WTx8HB4rfZvqVGyeXbhmDMf81dpOHlhmohBGGlcWlq2FDUsTfJVOZbvm3RnqlcxNT/suA5hxm+nNURDcEp7xGeXgzXlq8envY3nSyStGHAQmruibVSfy6a50h3q2UXWGH25oAdAvBCRNn3nnmvgOvfZ6P2HOtEdwAwRkeXx3XBVdwJp+3PuPGLmvpIs69Za39uQQFd+VE7LuyuMeF
 6/L/eYDh
 FqMDVkgnhZoFgJB8tT0QBKMZKtHTbu2e63EpIg1ZVe6XRonRjKUzNnPNerrut80JWvohFsA7lDEROjbkI+oEbZunA61O/in0VQl1x2mdBykAyFQ+QQmSrLxH7/lbHB12oBk+DBQIaJzcsvAkKJlVY5ZCAYDrSwCUxie0+DkVJbqQH8VU9YiA964KiNx04za3EjBWaHismpJDnKy7wrQSWGN0Mlp+Y6SeBzscuDj/aQcaDKviRexNUgOY58sUWOOWShL2gCDYhkQQyJPxeCJeeu3D8AK6QC6qB3kpOx6S5tieUjIYlPFt+L/wECKPRtm75HVgGRIH4QeJ7aLIC9FKNncgaMOV/642nKic7sTAxL5Eza7sDBe1m4F7vPpjqKo7gkZOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 2:57=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> I give one pass of review on your series already. I Ack a portion of
> it. I expect some clarification or update on the rest.
>
> I especially want to double check the swap cache atomic set a range of
> swap entries to folio.
> I want to make sure this bug does not happen to swap table:
> https://lore.kernel.org/linux-mm/5bee194c-9cd3-47e7-919b-9f352441f855@ker=
nel.dk/
>
> I just double checked, the swap table should be fine in this regard.
> The bug is triggered by memory allocation failure in the middle of
> insert folio. Swap tables already populated the table when the swap
> entry is allocated and handed out to the caller. We don't do memory
> allocation when inserting folio into swap cache, which is a good
> thing. We should not have that bug.
>
> I also want some extra pair of eyes on those subtle behavior change
> patches, I expect you to split them out in the next version.
> I will need to go through the split out subtle patch one more time as
> well. This pass I only catch the behavior change, haven't got a chance
> to reason those behavior changes patches are indeed fine. If you can
> defer those split out patches, that will save me some time to reason
> them on the next round. Your call.

Thanks a lot for the review and raising concern about robustness of phase 1=
.

I just added more atomic runtime checks and ran another few days of
stress and performance tests. So far I don't think there is a race or
bug in the code, as I have been testing the longer series for months.
But with more checks, we are still a lot faster than before, and much
less error prone. So it seems very reasonable and acceptable to have
them as this is a quite important part, even for a long term.

That will surely help catch any potential new or historical issue.

V2 would have a few more patches splitted from old ones so it should
be cleaner. The code should be basically still the same though. Some
parts like the whole new infrastructure are really hard to split though
as they are supposed to work as a whole.

>
> Oh, I also want to write a design document for the swap table idea. I
> will send it your way to incorporate into your next version of the
> series.
>
> Thanks for the great work! I am very excited about this.

Later phases will also be exciting where we start to trim down the LOC
and long existing issues, with net gains :)

