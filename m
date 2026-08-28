Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A756BC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12ED6B008A; Fri, 28 Aug 2026 13:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4756B0092; Fri, 28 Aug 2026 13:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8676A6B0095; Fri, 28 Aug 2026 13:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58FE96B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:14:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE733804D1
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:14:20 +0000 (UTC)
X-FDA: 85151326680.16.9EB8D65
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id EEDC4160003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:14:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cybzf/5l";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787937258;
	b=swzyxZL9kN1LXrWS9bFoA1oj0pbbB1vdnbM5zC5UYZNdoElVNI7JuGqTYOTMfOKvoAawXs
	AXtlQhdYg1isbkETWob3vMXE88Z3287UysMZI572u99ABWiEOeZUMrXr9LVs+FC3Sqf4Wp
	dyJDLGZIs6dxgQgtw7sly8ylDfcT5CU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cybzf/5l";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787937258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
	b=NwZpdHVdbeS0c0qhImeyvaUMz/19s2nNKosgMDQikO/KIBmVtx9rJUlsAY8/3BScyPG69x
	qNmtKI7ACmFlQabgNhv30HsqH75UgHhGNE5j+XXHp/2iRcGh7wjM0RB17TnTxMh4GnQlAO
	Wp5D2I/NTTZq/TKyi2cQkxoXXLl+O5Q=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49954b88fffso9203945e9.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:14:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787937257; cv=none;
        d=google.com; s=arc-20260327;
        b=TQG5kLs33QZEQ4pcpAEHH1rvK7pjxIAzmZMaPFvlw7PsSTd2sFY0qebaepH42YcQRK
         24AyD34EyNWCq/vBU/2hsmCS+84HPeF0Xxg9lRDxfsHUgEJUVu3rArsFd/oyY9g43Va1
         QyY2XRqLxp5qlnSqvEjhDqngNYUAqbUvqe6Iq/D+ymHTlXSJQBZ4oYC7vvHnYFDvFPbR
         r5ogT6iusNa3xFknYJcJON6g8NUJHSUNPB0V86xEWAIJgFmD2EcAMJzPH1A/vIvQEmbp
         lWgePDgIVsi+H27j3VwEoUXlUd45g9tAokjofuAlJBTaW4hqnvqjkIHjJf4HZJuGjHMV
         hfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        fh=7wYnO+yUyh6gfxXEvC7bsN5mPXD1nMC4MtWhX3Hoa4A=;
        b=dRJffzDx8wptbLJ6OXYMtlT4wkWMpPM1jxfL0PZZEsUUb5pHpqwAxPN3jh76foGLJ5
         H37gEy1f7ZkLiKxiu0gEXFxyqN1+b5OHhEsN3bnD6a6qPQvY5iTAsD/IaDNZKrRXtSKy
         q2aNnwDGiBA1QQZUpAdbUhaZKujdKkxOzt/tSSu1b43ygC49JKuIg3KgpJNMFNFAHUME
         EeqiGoazabAmge1coEIE39nX5HVg8pz7L+653lLqnuCntrmzU9lEPYa8Dtl++31UuEux
         eHI/lmCDZB+2F0h9hB7+3xwgrp9IH7aBMss+HzHM850MTA8vxvBo56+cha7sLeS6HZj9
         ZXYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787937257; x=1788542057; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        b=cybzf/5l17A13JOnnMlD9OpeGmPV4QL/TPN8rMDHj0bYHBa+QIPAy0VL8heqVCUSDn
         6V6Or9V8bFeRB3e2PKWFcSu7c6W6K9GJ5o6jBjRyvgES05Tb9ZG6EzV3Hd/eq9rekZXr
         uO334Vg6/wOiOlJDeLgzSHCYXJfjLsVRfELluRmgZx1KRmFuX1yd3Qh1iu5iOFY8aEVy
         UFRe6kEA+k6JS7aUR3H047WvRKH3WXmi+3NbfWpfiEEQ0FQ2DlGcvwVrZ/WkqIEDQ2Ap
         zJSHlSL3HOcuGIvSpaO98Bjok7stVF3TYsHa2aE2reAdSNN30rjSxoFNSJ78lHJ6b+fc
         xbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787937257; x=1788542057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fLW8KjG+1iJkxaiPEbmpBvUr0x4Qil1Zdzs/J2jlauI=;
        b=GkKSzfnmusHAzNI4GeJjuqy3ix7k5L4pXp4Stsoc32Nk6aAo51R3j5BM2GTs/aePJt
         TYFV5huVi7lIjIvAw3JeH46UwkpYmTjd41XOrIpRqwN/kHucjDgX/52I3vUyOzX8VPcj
         ojnKJDjAYm/M9H09ffSpoNn9BegDGBHMXh0tSghJYFfic8NA95jLXHsW1gq8hZX/J703
         BTnWYvrzNzPGq9NI8ZOuC5Qi6XQR1MHMbg145yf7U5JV41uZlVHVx0kVhgVbLDiNppni
         AW3wh3KJOKK77BgQBXRFDFxwgxX6FC/eqxUD8fqVnb1ey05wUn6bGvMQp1OUGr2spg/9
         /QIA==
X-Forwarded-Encrypted: i=1; AHgh+RqBrsvPdrb5oud9+9Iz3HN1iPPOYtb2GmTd17ZAjdy5OS1gAZU5/gd1a5pc7wSlh6iXXJe6cdCZRQ==@kvack.org
X-Gm-Message-State: AFuF++nJ8sOhJPLvf0/8DTI1BoFS30MHz9RXGMvRoAmUX7OyqE2oT+Bp
	aakFC5f6jX6vAG14VLlHlsmVD2qPuhsA8VkOglUyJUmCgmaGcWBAL5d6jgXlBNLJsmLyhHCyi0x
	Y1OTApGx0bvQAc60qmarXgxkXPlwslzk=
X-Gm-Gg: AR+sD12ObE35coiH4SojUDFJKvxwN/+c2xgYlKonj4VLc0r/RaZZZ6XDl/X4N9OS7ft
	xX1TdcP22+1QW1whcYzbkxBZCjX/a/vNtLHB0QR8k+pBhXzT1uSNfRCb2uNY2LglbAI7B3WGPnN
	cnzWRpexElNfzX2Cd8b+c7LvFr7DFfwYInUrECNFdJfW6Cx5VcmeD+Z+scYoFTVWr4f8CJ6Vx7J
	SRtyQEjXrtFyyF+iKEIJOg3P+wvSBTS2b3wdz8f3urZjF+yjX0Bc8EUiRqNkNXDLR6sqESZMUvK
	k8kL1oT+Lq9nFd9Fi88pF7bKLj3CCSOGPAHePacGiiornfD+CD50GE93CcxaDyELQzUnZZVDdVH
	6
X-Received: by 2002:a5d:5f91:0:b0:482:fbb0:a262 with SMTP id
 ffacd0b85a97d-482fbb0a404mr7651916f8f.20.1787937257283; Fri, 28 Aug 2026
 10:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260825153238.2695446-1-nphamcs@gmail.com> <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
In-Reply-To: <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 28 Aug 2026 10:14:05 -0700
X-Gm-Features: AcwNN1VqRctLWtrJqo_bsUXm3dQvc_4Ji-SS_KiORUhzWLUsKtjvYyQhD1-JmPo
Message-ID: <CAKEwX=NdnBM7cqbO3rSsUB7JFZK6DBxNMFbpGWgLh5m6M7yRXw@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEDC4160003
X-Stat-Signature: 1zea3jkbu55oz64jixb69xkkt5ddinsg
X-Rspam-User: 
X-HE-Tag: 1787937258-472042
X-HE-Meta: U2FsdGVkX1+xH0IBrjNwlcvo91sv5MM2QBlCr8nFqmp4X6t0fbv8GbfQMu63Ju39GZbwiKDFJRd3Oj4hFAlcU4/c5tQpcHKOLeMG/UYrPla5m0jZLUoS7T6efYnyCOUcEpYbE2PUt+oBSEzkkpIJHgrNc2/BsRCQLkZMWve8xL9mVM56Z+/DBOCtvYqStT0qYXQ6cxwMAtd+NhI5ncv4maC1cJp5EfMHOF6UH9g7InV4USIQoFnDZ+4d95EfrZ8kkNIYEpCQbwSb53M3N+1Xl6OuFjZvOiFJvGtF4YkRZcshZc2peu3HDq3Gx6cgbcrxbNOC8JqUiNed50KTFNKBVpN58cVmK9/V5WrGMP6VLInukso6a5VM1z0u4hsCrsnu0uwOfYIBSRxPlA9xm6IEnAOL+OLzGXzur2oCM+cXYEQG20n8mkIajJelPmWMtcrEhRv1QPvo1Ns1D9+HGidpLRJnRnZa7xhhpPih+FFmb7ty5XbmZo5M/rwpZnJ4P+aiH7xVrKXZDPqvSTEGd6kIBEB3QaW2XR3cSVlRkCvYjG9rACkCGLnD1GCOfyIfCfBJQtSbhIox+pBxUTg0ysIWQL7ReL1dUn8VupsmOcV5mucSmoSOk9AEFJMEb/47t/ovZQR7tPzEMDeYlCgdxIMxt1qO2oizd0U8wWn/ujtOYN9rJCsyfrjL91rs7fCPF15lMfn0l8YlaRbNaqyzT/uv5LCZUusMgtkh3y2nfausUM2liwj39pDmRSEO/pzJlsLE8soWF9CMXh8NWrLLjOUY7Co0O9jzVvhtILp2oXnvB86ieIAyHErxzZZLul7A5TkQP8Gm+K5NKk+2J5tOxKT1O3eulDP/DIa3HIek8yi/XE7OAuR1xW/rVGS9FTPMCQ3/W3ooz5vNDtjbgxOGvnWuncH2AwI+dyObTmYikfAJ3zmE8ubp+LYoAOEZWzjSoCReA7w0xC5Qu38pC2/Xvwr
 KVz4yEFN
 xHmcWY8krVcHYcDt0/OzvWe4bnLhiPVU7z53N1LbAm1EKfKgiUbFZc6h9fzovs3CRbEhbklYhPw6PWCfajoZz+DvgKjB7jeQLIhXz5KhAsQ5GQMY9Kxtr+vu7QCYKyjS+6TO6Swua523s+IHmIV9WqpxTzTqoozXhPdmjV2Igl0nmlmwa04YVYPmGcsg2URnlZ5JEITaRlqM3j8m9Gv9w9EScyVS6tJqFIN860kwSrqRzcVVA73e6LHYkFI0L7DC9LrcSf7VY0uDUK+jvlYlSpycJ/tl6vVDCm81XXplcXtPECagbyrVn7wwkD5IfO1yje0CGU1iOhsIYaWLbhSMbtpiK0EdMUT5dalz22AuH9iegyCuPxwbwUep3scTXE3JRAFMpZCsoeqghR1gzh4jemA/zT+nZOa1Tl5oV8tHmhR5Lsb3l93XQAgm0LOGOWnKiUqXcZ/2o02qfF0pGS2258uiRM9cbnHoQ8vP6nOPPw0Z451iIvKKgqHDb/b+PeKJERrSa/ZSGV5ZYuLoGHWsFMNNH7Scn0H3adeLL2hZhMJAMObw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 8:07=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 25 Aug 2026 08:32:26 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> > Currently, when an anon page is swapped out, a slot in a backing swap
> > device is allocated and stored in the page table entries that refer to
> > the original page. This slot is also used as the "key" to find the
> > swapped out content, as well as the index to swap data structures, such
> > as the swap cache, or the swap cgroup mapping. Tying a swap entry to it=
s
> > backing slot in this way is performant and efficient when swap is purel=
y
> > just disk space, and swapoff is rare.
> >
> > However, the advent of many swap optimizations has exposed major
> > drawbacks of this design. The first problem is that we occupy a physica=
l
> > slot in the swap space, even for pages that are NEVER expected to hit
> > the disk: pages compressed and stored in the zswap pool, zero-filled
> > pages, or pages rejected by both of these optimizations when zswap
> > writeback is disabled. This is arguably the central shortcoming of
> > zswap:
>
> Thanks.
>
> I asked Gemini for a tl;dr and was told
>
> : Introduce Virtual Swap Space (vswap) to decouple swap entry management
> : from physical disk slots by using dynamically allocated virtual
> : clusters that back swap entries on demand via zswap, zero-filled pages,
> : or physical disk.  Eliminate wasted storage space, remove the need for
> : static swapfile provisioning, and enable in-memory swap features on
> : diskless systems without degrading performance.
>
> I'll take no action at this time - let's see what the other swap
> developers make of this.

Hi Andrew!

Thanks for taking a look. I'm also waiting for review from fellow swappers =
:)

>
> Sashiko was talkative, as usual:
>         https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs@g=
mail.com

I've been going through the sashiko review on every iterations!
Hopefully the list will keep getting smaller and smaller.

There are a couple of false positives, as per usual (the first issue
for e.g was intended behavior, at the point of that patch at least).

That said:

>
> There are a few pre-existing things in among this, They look legit to
> me, from a quick read.  SWAP_USAGE_OFFLIST_BIT should use
> BITS_PER_TYPE(atomic_long_t)?

I think that might be pre-existing. Maybe we just have not seen users
who used 4TB+ swapfile yet?

Might be worth just putting in a quick fix independent of this patch
series just in case.

Let me see if I can quickly whip sth up :)

