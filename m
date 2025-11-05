Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F286CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 04:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8B98E0008; Tue,  4 Nov 2025 23:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF7D8E0002; Tue,  4 Nov 2025 23:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5BC8E0008; Tue,  4 Nov 2025 23:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8F18E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:30:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FEC0160184
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:49 +0000 (UTC)
X-FDA: 84075277818.16.113AFFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1264A10000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KEt3F2G/";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762317047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igRXUB44k8RgyLhjiU+I7yMd0HD+u/6WMUZ+KkVbWNU=;
	b=zDKySpwBBTJkyAPUDx7uWCc8J1pCTJiZuLYLGlw0XqJvHG0q99944WPhJf96JeTj7c2JT+
	yO2WS1FjAiBdouPTjd5aQbA6RloFapDtNO3dsmh0Gj5DBkc9/4Lgp7ML3cDtzVo2T3c/hG
	tvCWtA1hPffVvd0iLGKHspYQaZCJ+6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762317047; a=rsa-sha256;
	cv=none;
	b=KiDN2S+1ywI2urGKSHe3juns0TlNBncEHC9EWo4KCtXO8GZxo/aJ/XxJ9ByjqeCkApMTGx
	edCnzrk0hUJS83RD97EN/sc9DdKw5+u/ouhYiONZwstvuOs5kWbg1fFd3MZG8m4lCYMeTy
	2gAYMDCJpeKFmTccd9Kl/kXjAQhOsWw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KEt3F2G/";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0037F418DD
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D2BC116B1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762317045;
	bh=Z5+iLkNxhwcyGcvXemSB62Hf6H2F3Xk4ORxYo6lESnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KEt3F2G/mypNW57zrhuk1rCl59eUfO+6miYpPsCfzlEEEz+w7LPj+bcDs5OxTvBrh
	 iekloDgHKcf3UKBMQXclxXQ9FUeL/ft/SQSbIWHwQAHWm8Svdxtj1xvSSZMf7xg0QI
	 wlAkbt1q8vVFd6lk6IrFNGGcBVvAB2YagdhcOSEUSqhD/nz0U15m++TExm+iEGzYPz
	 tbPokJtFQXH9cfPAjH+sXsXqQvyIiLApIvxF6TeUAeLLDHgviuMgMphE2FPzXu8Rdx
	 kXXFZguH6M5BF59CXXEUGYOr4zznp9vDbty8asNLthMTWg7xPt7GclUiZZzGDXAc+u
	 JCJqX4vI52KPA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78488cdc20aso80260467b3.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 20:30:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXO1+tDQ9HkEaDuorcFowftGmpIka+RHMo1OFzZ1cfOgzARgw7Iwi/giCJ1KdoZ0dGhhALvQWkgag==@kvack.org
X-Gm-Message-State: AOJu0YxoAG0ckbX9el19iovKDzPpehf+0HYJyoJrC+NNwDnGJxNRFJ2F
	OxNycf61mVBObO1YU7z6csuLpzfFB67kC0wQoDNEuYG1V1qB0UtjUhixjd7ioE0FO0yZMZw3lPI
	Ys+js0Lv/aqiZGiRWw/6bTNgqwx1qIrMXdXyKMOAqFw==
X-Google-Smtp-Source: AGHT+IHjemH17wHd9rPFc3L/t1fInrq9n+OST9E/VRc9aTFDN1BNCcfeFWBkhIreQTlb7iGtHcmLPEP/HbYhMj3MMpk=
X-Received: by 2002:a05:690c:6804:b0:786:9971:e5fa with SMTP id
 00721157ae682-786a418d440mr19275517b3.37.1762317045227; Tue, 04 Nov 2025
 20:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-3-youngjun.park@lge.com>
In-Reply-To: <20251031065011.40863-3-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 20:30:34 -0800
X-Gmail-Original-Message-ID: <CACePvbVwtxPEdC19sP0oV755BQ_ih233JQO2eLbuV1uFSS-T-Q@mail.gmail.com>
X-Gm-Features: AWmQ_blGKRtZP3mR1-wNgRQbArJPGCk9H8lk9bfKXCExSfQd-MBpEpQ0ae9aVW4
Message-ID: <CACePvbVwtxPEdC19sP0oV755BQ_ih233JQO2eLbuV1uFSS-T-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap
 is rotational
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: igjgw1rf75hk18huietztczsckfcnymi
X-Rspam-User: 
X-Rspamd-Queue-Id: 1264A10000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762317046-230030
X-HE-Meta: U2FsdGVkX1+3m8EK15op5xMpWpwE4QSOUV8cA2qw2VTxKkx/DGnLanzEDw4tN5fqvbcr67Kl0DZ2iwWMPFgpFTEbEaU561IV/6oRDzPp/mTgchJ+B2CLapAvTZbkfoa/Qiste1z/1OFE7dzoAs38vPmVIRtgj1w3+IuSSFYJxS2GObNQqAc08vnd5ke/I/tWerkoHbPd/xX3KEc4s7yd7x06llNz5SNxvjRv/nIXCTYO4a39uZXRfh4dXL1AJEYYUm4iUgw/rDgA40XauFMG6WQsD0ZMfxMV5Q9LK3hYMP3u8jpTEzxVKpyO22EeIuQMTKrgpX0pm9+3217HMsBWu//lOg9SSTjZqVHIolusMqaO2vCF8+8R75STqQu+rbTj0kSR+8ig5qLMRuWlkLoNwsf8uScVlZv9ybv+0ecDbS4mmFeY9DEAeJjB/wZGndqhQeo9ik3HMLcLEPaR+fFuGmJrZwHMXS1kUjqz4zxO6gp6GULJb5HcFzOqSrPO+YLZeH7m7+0qaZ031hRjCYSOVN1rpeL3eHnddocITSMD7SwwJZk7Fq/pTEK/LW4pJX5ekNPhTSMnXM4KwCQBoZBtvUnA6GAfnCFy60+2vCyiI7nyvQKPE/wmcT+TM931ZE28giSibZFY0WBZxpQ+GpWRHyKW/wfxHdJ6AttvcySiV1Irh4m06Vp07OZV46hd6PjLYN3DVanD1TfpxqohiU0MxS2RBFeyJc5mbmgks/MJEznhIsCNwBXZJWqzteOlJmrxcMYT4D9/A2y7hSJSoue2v3f4H7Y+Fh4c2LOpTvtQU4xBMgrpONFtK2m2eI2IFbTokSrbqXn/n0mI/PesubZcGVQvFYUaxdW3X9Y5+9dPhF24snI+C+LHcKp/ecTl0dLPjoVPM7yKWDfQA4JGKWrWv5P45iB0PeI+fZzxP46NT5cFHIk/rXDyvTQRa0H0EWWE7HahtK7hJi84GoIaSEu
 N6mCVXwZ
 +Gyq03uByAPD5LSRA64E+CoVqIqDTwXAGV2PME90TC4AvFTPdDR7mL33aemDJhApykYIGW6O4aYILv0N3d03T5SshLlb1XGMDW3zZVG4CRLnpr1KhfLkQtaKpKY6BwcDRQAKEWSlF7V2CVrc4vf+ySsvgqrMQqNK2SlD6lxSuV2QQEUfRXvzHjTy2MmXrP4tzhWZpCpVx0qW7jbRb5QAUIaqdnWyCJUM+XY7RLTdlmbwPl0p0p7LeWGu3Oj/1yXK3eIzQLwBN25+3aq2oF2O9s8mAcxWuJCWSMNt/cjUJ/rpBRqfRCRaTNxk4pxNlzAQ7XCM1At54oG1OlnR1ERLol4DJXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> The current non rotational check is unreliable
> as the device's rotational status can be changed by a user via sysfs.
>
> Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
> to ensure the nr_rotate_swap count remains consistent.
> Plus, it is easy to read and simple.
>
> Fixes: 81a0298bdfab ("mm, swap: don't use VMA based swap readahead if HDD=
 is used as swap")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ed2c8e4edb71..b7cde8ef6742 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         if (p->flags & SWP_CONTINUED)
>                 free_swap_count_continuations(p);
>
> -       if (!p->bdev || !bdev_nonrot(p->bdev))
> +       if (!(p->flags & SWP_SOLIDSTATE))
>                 atomic_dec(&nr_rotate_swap);
>
>         mutex_lock(&swapon_mutex);
> --
> 2.34.1
>

