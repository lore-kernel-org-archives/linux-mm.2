Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E3E606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kf+SNUl0
Received: by kanga.kvack.org (Postfix)
	id 6E7F06B08DB; Thu, 22 Oct 2026 04:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6723B6B08DD; Thu, 22 Oct 2026 04:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512236B08DF; Thu, 22 Oct 2026 04:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2770E6B08DB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:47:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86DD7140722
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:47:46 +0000 (UTC)
X-FDA: 85349634132.04.AA4265C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 893C6100002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:47:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kf+SNUl0;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KhNbGiKqMdAzgzs/EnRYikYSYyFDYoWRp8GQTlZbP8=;
	b=kMSvViG1AJfcxy+3tPh7eJicbzwENkrKA5rQ3a8fWMco1E8GbHwo7faX1BCKMrboMaij6L
	5jULCXNjiUBmKNT0uUlygchYY6g5PEFeeMRp36355oUEtrZxIVJydq5VT8Z+CHR/GDV+YG
	sX3LSnAO+EO5oozjDwZT+j3FYnkfHxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658864;
	b=A6D6tUFgGRXh/QeScR1Sg6EumiWdqgvbd0Uw60LwVCEgjsBDGBRoM0aQmsIJrbpF54w0R5
	mGtPNO1WOvsvRfKBIyWdZXiBdnwQ2YfUbZHckhnXsYwZ+YkLuclh49mBbP5ZZ8Wimzgmd6
	NEaSzMzosN4/9Wm/u9c2Ducl4Gf1mKg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kf+SNUl0;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1F5944788
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20EF1F000C8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792658862;
	bh=0KhNbGiKqMdAzgzs/EnRYikYSYyFDYoWRp8GQTlZbP8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kf+SNUl0IYrzEyHlJOp2Tsxdcz4Z3jerFxsf7Tbyxnq95JVlJuNSCrco93/c1U0+v
	 dpeoUSNPK159BkKPrb63P8YOndvCiipdl8vRPm8i1+9e214sYUM7atDL6+QmplAHCb
	 XsUP4p5e0BRGgjTZupqA3+9h607WUtFTJemd6Z9USjRsHxX08ykxDB48NgwHt/Xsc1
	 NO4ASc3h/G/j94YeqU5fLVxucKCNcUnp390iXitDa9DyfvDOiuEnpO/X8FHpM2OuL9
	 h30gYjj6WOZC9yBPdWE/tljQg6m0Eo+3fVvVGt7a4TuLhdMY9jNLueGu5J435AANuR
	 Fup4aKQDk+e5w==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f20b304c0so187777885a.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:47:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxaBr1HHK8gr0IWG5CjLXHJ/O0reoh0OAhF9wkMfb6ni8+R07g7h/yKD6eQAsKDXp7gQMD6cj0Gjg==@kvack.org
X-Gm-Message-State: AFq9FYJJS/Xsggf3fmHN3MtESSaLFuKOde4bnrVcfc3Guu/lZBC3cx2U
	ZqaTVxu1YD0BSEfB0gp7wwt8sX2mj8uzcEz+NdU1CkoC/gVmLE4Ms9YPi1fukXdpruor5PR7+Ee
	E/FMhMAimk7acm3MNvcZKEudCTIj6UFI=
X-Received: by 2002:a05:620a:1a15:b0:93f:192b:513c with SMTP id
 af79cd13be357-93f57f5c444mr887910885a.62.1792658862135; Thu, 22 Oct 2026
 01:47:42 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
In-Reply-To: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 22 Oct 2026 16:47:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yBqZVfrpbXsBJDHhitsHZEGWJhZsHG+uKC+QDxZp42HA@mail.gmail.com>
X-Gm-Features: AclHuK8XLVqPGA1mX7YdC2w83sO4AOeusxNOJ8q432NXaa2xo-Ms6397XexgORQ
Message-ID: <CAGsJ_4yBqZVfrpbXsBJDHhitsHZEGWJhZsHG+uKC+QDxZp42HA@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm/vmscan: refactor shrink_folio_list()
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 893C6100002
X-Stat-Signature: k5597bneprk1hye77kay71553e4xktzu
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792658864-223346
X-HE-Meta: U2FsdGVkX1/eFeyI3ErGq791jSKHqVlG+66j9ELkmnMC98351FnCJs2Q30i2EaBc+ogFuuy81Zc9063ZMw0/2QPQH8YaIkM6jCfsjCA1zIDZKp7z/sFXZDT64Mk+PBkXYgItru5AFdxOFlfdzWKmt0xy3Ny5//7e3u1N71CDAz12h9fRhGuU/fgCncIkltkifEWsElUF1LqQJvqHtf+EwXVsUdm+9IMarBuWJnL+LIYCrBe1NXh3Uxy59TV6hZ22i2yWex6S1eYD7qWfx6mutZDOfjcyT0kQvscO3GPy7uKZF+pndppA0XDVKbkVnO0qNR8EnerQ6AvA8bSL8zY7c7V8OPzKDIEdKbfM/TEJ9e3GG69gV85Fjmd6Cq2A+xQG3w2he21lmM0gvp+QaEpBHHm7M8oEBI3TYxwncAZuEwWV2xLwXaAWZMcpm8qardppp44ax6A/NWci5WtqHEyKKCB5xIBTo9ppDTVNymPFCR+BLp+8n/RDW8qPHbT/3kxyW0RKFoCG8YXpK3jC4ikL+saTKgKNpOJAwMNr08Lm98YRb6OCKvmQ4dwYQCrX1atW6356y7PmguweTb+GlG2bWg/4qqcDW3V5YMHkPWnnR7nkmFM9jx3D5AujZNez2MJBtbTANtKq/wYk3dLB7Mpp5YIvm61exm+adSibN+NGLHPMuBYdtINlsxSf3VBeqa9WXExGyExHkDqAc6MbnmiyVOkW7yOjvr8rqpLCtCv/NG07JeZyfhQ8qbhbA7tMOTFAxKwaXi/756yf6KkRDZWcz2BXVLVepJjkgXF+4bg2fT41LV9uiNENBktrQhesM1Ai+c4Ruc3WGOSdibkGTq04laTFY2aCng2/iCzZjB7eMQj2OJ7xP6Fs6ups/exg1PiC28QwaIUcFcHDD3rjGb3aqQSNOHOe3DOiOvvt7JzozVjBmdp4TDrloyRYdM4oALeZZJVYMN8ORVBsNF+/sth
 dawQYu1p
 yAxHakbYN0+FpgjBqEbuzRiWi3LrBM5+2Kzw/vk80A3he4DKzpqqo4/A4GD4vcQyQPsiFf+DuG6+b4g2bNCovAFiOyYx/ksW8WmUpCpFJQY3Vag/zrNrQuQIOEGn1RZpy1hZT4rpopEKrJB4sfV5Alz/+4Lrv0m5WVw9nMC1uPe3lsno+SQ5inHr8VVUqHQIWTVhTYKAYxeSfd1tjKBlgdIO0DR4D5AW3vJvB8OcHtUw6TbcVCXptjdrJjVWP39gjAJaakAuKtg7ydJNreLO2v48W8hBOh+v6hA5p9f44nQEUyT1sErhPGnX1p2jbGT/BN7oBg69HDeBqYIygTGviOAIMFTClH0TSz9SDKd6ZGyqNBaZE2rcYxShrQ/ypfCukQPYOWlGyz+yqCPBWzlfQbjko8I7uvo8jKIeiAjeJ59l6/EA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Sep 20, 2026 at 10:25=E2=80=AFPM Zhang Peng <zippermonkey@icloud.co=
m> wrote:
>
> shrink_folio_list() has grown into a very long function whose body mixes
> several independent concerns: folio activation, the pageout() dispatch
> state machine, the unmap step, and the final freeing path.  The control
> flow between them is expressed entirely through a chain of goto labels
> (activate_locked, activate_locked_split, keep_locked, keep), which makes
> it hard to see which decision each block actually reaches.
>
> This series extracts four self-contained blocks into helpers, without
> changing behaviour:
>
>   Patch 1: the activation block at activate_locked, into
>            folio_activate_locked().
>   Patch 2: the freeing path (buffer release, lazyfree, __remove_mapping,
>            folio_batch drain), into folio_try_reclaim_free().
>   Patch 3: the pageout() dispatch state machine, into
>            folio_try_pageout().
>   Patch 4: the TTU setup and try_to_unmap() block, into
>            folio_try_unmap().
>
> Rather than returning a boolean, the extracted helpers return an explicit
> result enum, so the reclaim decisions the caller has to make - activate,
> keep, or reclaimed - stay visible at the call site instead of being
> buried in the helper.  Where a folio may be returned either locked or
> unlocked, the result also records which, so the caller does not have to
> infer the lock state from an invisible internal decision.
>
> This is preparation for batching the dirty TLB flush before pageout,
> which needs to call the pageout path from a second place.  That change
> will be posted separately once this cleanup has landed [1].
>
> No functional change intended.
>
> [1] https://lore.kernel.org/all/CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm=
02OF8nEBUQ@mail.gmail.com/
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---

Hi Peng,

As suggested, I think it would be better to include patch 5
("[PATCH v5 5/5] mm/vmscan: flush TLB for every 31 folios
evictions")[1] in the same series as patches 1=E2=80=934, since
patches 1=E2=80=934 don't really stand on their own without patch 5.

The whole series is a really good idea.
Looking forward to the next version.

[1] https://lore.kernel.org/linux-mm/20260720-batch-tlb-flush-v5-5-db943a0d=
0d6b@icloud.com/

Best Regards
Barry

