Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C07D111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 20:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8736B0007; Sun, 30 Nov 2025 15:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0126B0008; Sun, 30 Nov 2025 15:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC2A6B000A; Sun, 30 Nov 2025 15:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E43C6B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:44:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEDEC5D4E4
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:44:34 +0000 (UTC)
X-FDA: 84168451668.11.C3320EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 70339180013
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:44:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWa1ff2m;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764535472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10Cdt34RCx935w4umu4sSDL1avAInz+1CdF2bZgGu6M=;
	b=fv+MXT/9trIudEsrH7F/ZsxdLqleddmGjtJS2pJYIgMSf6emW8YGvFB5g7hjTNSqKXV7+d
	cm3AC92QtuLTp7o9MyqMhKIGm67Z9Y/eer1ii/1XHGZO6mT0v8iMeW1sAQcQ986CqnHfyN
	PJlJyXqSK8NCf+ljwTQyEDtIOenbRAc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWa1ff2m;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764535472; a=rsa-sha256;
	cv=none;
	b=0MDQqUWETrVX39Z+2ZlclqdVoFocUy8MQoilQr9hwrlpM0HR5+Bn7T+yiiMAIz3fcefFob
	wZGfYGe5fac4Z3x/qZgMXBEW0YOqd7yzUK7Z4UWNUStIDC9zOJhEv7Bq5Bbr0mjizfUM7P
	vyDrHHyEY3L0gGpErK5iVySnQ0Xk8Mc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 420F1441F1
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FADEC113D0
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764535471;
	bh=10Cdt34RCx935w4umu4sSDL1avAInz+1CdF2bZgGu6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BWa1ff2mBVJ4ElH2wgUU2QUq945AWnZV+fGZG5QnlY4YwB6P5+w+phxzeWeo0G1aL
	 JirWC5Jz/gkgTlnLGcMTpJEWMMoo/wpqtEaCTH9v+IXLxQUhqBGBa14Bzqn8WT60BX
	 ZitfFqnC9Wp4MTo2KWxirlXNPR9HyJWmAi+F3rDQpxxLH7d2gkNpEpbyBk9ad7zTxr
	 97fqj05gk/qtPM3/fFDSfN7jdXAWpsABg2VDfFyOYNq1b6qybViR+RxEhFmplGnmyB
	 b6CMKn5g0A+KXcq7flTuZS+D9zBxpHM915FQUGBYnkuUkYVjK2hUFy3r+yPGqCJXyk
	 tTXrEivdU/i4Q==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-786943affbaso23130477b3.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 12:44:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWqTYV5OH3JZQzHUsx30t2iE8iCX++P2xCDf16+uJgxsykcrLl+WsgDBsiIJ3kycbwsqHV3lr9e7w==@kvack.org
X-Gm-Message-State: AOJu0YxTnCBa4zeue4AxsdA30YX5XLZAeFiHStL/IRAkq4ZMP7N4qNYM
	kUY5LYjhHgTLnbKxKDWZMBUIBNtIDZOQ6lE2u+CTYoa0/cffLX1Z2OMBhERdTMgNVnuwZXuIoZn
	hTjCXZhQXqoslJSPD2zZFNloDsU9VAROOHK8dZMKWXQ==
X-Google-Smtp-Source: AGHT+IExQ1AJAY7f4dN+Xk02ncFxir6zbdLyjYYpQBva9zYNDSKSUibUyNy4if+53Ez2svcwcs5wB7kEQOEjSzjM/I4=
X-Received: by 2002:a05:690c:81:b0:788:c21:b05c with SMTP id
 00721157ae682-78ab6fc6e40mr180821677b3.63.1764535470463; Sun, 30 Nov 2025
 12:44:30 -0800 (PST)
MIME-Version: 1.0
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
 <CACePvbUK6uSDtz0QkBq-eqzQ_Hi9+t1gthGGt+ok7xdZtO1V8Q@mail.gmail.com> <20251129101820.3dd08b93b92fb2fd58159400@linux-foundation.org>
In-Reply-To: <20251129101820.3dd08b93b92fb2fd58159400@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 1 Dec 2025 00:44:19 +0400
X-Gmail-Original-Message-ID: <CACePvbUfCFEqeh_Xa1D2Eh9US69_ENjCGYCKq4yGzZsyUnx00g@mail.gmail.com>
X-Gm-Features: AWmQ_bllixhFCPl1U1P18L2vmi0WIH3n7TKKxSGRCV4IyaaHJQUy9dLvNW4goLU
Message-ID: <CACePvbUfCFEqeh_Xa1D2Eh9US69_ENjCGYCKq4yGzZsyUnx00g@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 70339180013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8sgd8y4tdkjfpsz95p7y45zhkunetx46
X-HE-Tag: 1764535472-63899
X-HE-Meta: U2FsdGVkX1+4Mv6yiD9eyc28caxrVW+ZP1XsvXkGaxOqtrLk0nZzTpElBBpRJMnVocqcsBZ3uZBI266vbnQ0d1kop4K6TCYRzLfC3+T5TQCE8jXjlPqzU6bgiq/VVn0sB0Rtz4RlaQIm9t1wen5J+cX8TGy6wHDY3a0pOvMaWdBBTd2ciz1xxAyQWYHBAArrhiDcAaU78k+7D5DJVBT4Uk1CnaS89zp82NXRUWPqysXS+CtdH7LWQxB0l+c+D974PR08By5ALdSg8m/oddJ/XV3r58d/4NXTJ7gw1qVx7nPxATEmHJGEsHzFY61qSLwns5cnvGgryB5lGFzDCSc1rCHpCpfA8hzzNKsa3G6MUhWPEfL6HPTQk1QK9C7Q5TZM7LPG9PUPhw3fdNooLjh9LYWzdiLxR3BdeXXj3fIhZ9LGWYTC9i3V4Cu/dqiBQ1p26HOq5Vud6M2o/ci/k6WU7LVr88fbMLK9wQTi2nQbX5E/UuUlRSjfu1AUR0MKPHxWIu9PqTB4a2UOTYW4oynsyzNdl3zRzRzz6wrkBYdUcCym0GqPmeE+b03TmURIoEanpz92YdV3wzT+TM7vc8xKVMw08Ld+4NAVDNEGu8n3Lbzw9s6sLwCJBWVsDbCaPcKKOapgv/UqWfgJFCU+BHm5WJG2Gv/4k056D7VDId72M04GehsEF6aujOE8AXZZJExYkEsHXaGfFD11aA1T3I1fkwnu8l9m1amaAqhtVXbzsqiZX1kjiA5/dmNo7yB4Or9S/HX1HX2LsSyInONoz+2+A5j3y0oOCYGZy2OdQ64tIeVd13AR1RpFmUkfog4zA4tRdOK9LuBxnYneb3f4n0mI9M3eSau7M6IjhJUa1GFsBiMPOF9WPS9SVv6Ee/dg+vLfOJEIn9s28YZ+uu++EueGfYXedJHl4HBlQK03FYUNS8fCgq0wFb0B8KY6FJ2QkYOWQuK9ROhbPepeQg7imNT
 QzmIWQWt
 w7VK/ZN+2oofQro+UJOCwOanBHixEvBdC7OiC1cLLcCQ7bWyNRt3qJ7lFPa2C6wutYfr3NLVXPEi9wzQ8uToLyK2hNXEcBZy5GGcK814TsM6fiQKg5Q7qpx1ThVRTKWzimaKjiFbK7unzG2kuEypxApggHdphS7QKrX4x90sjk3U+6ND7jWzhHGpvIGtU+n+Ii8/dsg9ILbVV+GWMsYXqrCvHID9IMpYXAHaaoyRcyaU+5ShVDX0Ox5m31RSNJZG9bw7iEHRfDayRqzndr8wlqfLpyjyB0HAo+c5Tuw4n8DKd0yhaiVjt58JBUCZelzT21Nav3QDMriYgX3AYusL5BmB9lVkw3rAksiYXmARoiKb6+7QVjlj1h8g2+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 10:18=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sat, 29 Nov 2025 21:07:40 +0400 Chris Li <chrisl@kernel.org> wrote:
>
> > Can you add this swap table phase II series to mm-unstable for more
> > exposure? The patch series has gone through V3, overall looks OK, but
> > I have not finished reviewing them all yet. I will keep you posted
> > when the series is fully reviewed.
>
> Not on the eve of the merge window!

Sorry I didn't realize we are at the eve of the merge window already.
Time flies.

> Please refresh, retest and resend shortly before -rc1 is released.

Will do.

Chris

