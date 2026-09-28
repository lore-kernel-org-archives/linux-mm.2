Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8473C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BA46B008A; Mon, 28 Sep 2026 02:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D006B008C; Mon, 28 Sep 2026 02:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B5B6B0092; Mon, 28 Sep 2026 02:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 919A26B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:28:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94BF8140B41
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:28:50 +0000 (UTC)
X-FDA: 85262192820.30.ECAD292
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0F1380005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:28:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sHmZQBf+;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790576928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlTeCabh7BYu07oJry0uYVnPTkXCqqBZzgHeANLiL5M=;
	b=wBj+/04SJ1dvNNEVsxOIu9MY9ytA3srQI00zhCsxXJPt8sV+9+p0zsg9YXEdizq3mGK5j9
	YTSyqb8Uv6l5sloMItcPy6g+tBB7MVUoI2WY6IIomyErso2k2D6KUag3r/QyTxrgoaAbVm
	NS23KF8gLI2LimN5SmBCNyNCnG/XqOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790576928;
	b=TbHcwRUCDFY09oL4Px+xObW4ROKnoyAqQpUjiDSoJfOedwXFIB0app3fGdSI0VbxpQt2cx
	5HIIyOJLbnjwhGHtGWVNKFWHPi5R3LrQN5v8vKbhuy81cZdlP2jUFeJJ1VcCvrt9Re532+
	shtG1CXVcaFyoM3M7e+vRqnZgnrEG44=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sHmZQBf+;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f635552aso2056063f8f.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790576927; x=1791181727; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mlTeCabh7BYu07oJry0uYVnPTkXCqqBZzgHeANLiL5M=;
        b=sHmZQBf+RFzowYWn63QupXBaKB1ryo8pHKq5Izq+w/6Kc7mV+SFizWCdiPmwhL7Yoc
         ExBhRGCmvE8ptDW9J2a/wWqq+JmgdSjfv9YpVv/RMADujvWBy5R82DFpvMY1VF19TRfO
         UqFwZ12U+qZ55dmIJ77cyIBLUKhB+WRxzPDPqU8PIRRAzpqaNVplKwtYEThc/9dc31LP
         mdUSONUF+8tO4PG0nmguSerc5IFaXvgrzXnyeIpWJxIU2mDjwhNHDXQxIbb1WyHpmKmz
         42kp+EPISmH1PMKl8jMA8ZzT53nW4RQxBgHHJ8ATcbHkSILHudJP2+HpFsfBLtKvkKmg
         IkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576927; x=1791181727;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mlTeCabh7BYu07oJry0uYVnPTkXCqqBZzgHeANLiL5M=;
        b=s/GP+pARA8+OLNPxTVgbD1jj84wyfzG7Yojgx6eXoeYGvRmnAlqqCvCHhv0wZP91GF
         LiFCymzajkopcK0SIFGVux0ynxn2oZukJHdERcVulOKZtletQuj3sAAq3y4Q8vyJSy33
         D5PSkCX7x2mvRbVBExzLrb7P32ruhOBv5FTP95nDCIInpQHUsjynwE+ESPpr0K2wPS5M
         bkwQL6LZ1k6HDjh7vUxBTTkIin8xy2T2NEU0668rwZewIQBTFDgD0+XjmwZdiO0eEokf
         6+Qgl82BIgQwPgSHodqWWemTU5m3iQpMCUUMGkZzABEpFgOgvRKxjKh28fXCnXoVMnhG
         Vvhg==
X-Forwarded-Encrypted: i=1; AKwUvByDGD3/R7rtyXNzK/M9eApdr8fbJrZbbJsA3c1tF+ioub45YuWXW5HoQPawymu+9EzkyX2KJ8huNA==@kvack.org
X-Gm-Message-State: AFq9FYLaTMTDqblIa1HOs4ysfZ0g+uCGRJK5FrE980mOtBzSKDj396hh
	qK31yuaF20Oc50A9NwE2Hp7R81M8M+yxKwTWUKMP62n4cNEFKu7/3g1n
X-Gm-Gg: AYBFou28yNq3v5+akc3pe9y5EYECkst9bwpLPoc1+BOC4BEYVbBaEqatDNmHgIqnjwX
	/R8gXSYtCUiPpQhl3S+b0wsT64Zw6LQF5vOK2uRxJ11EfNcv5PXAwxifJq2hqe7hQdi6JRsPuiR
	aoqXkmnjLKzWTG167+nyLp+7/kQZ9qvjwQLL0pvDjTOFQqqAc9z0xVocbgkxBhES5Xx/Ax6dwgW
	86YajT6PP5Nb5UDVp/iCcQwn560OAPW2fidEHr5Sa0zZoxhJShYJqv4b65Em9C0/ggKoZSyHUzF
	kqjTVpf3V3H/eIvS4hPDOA3HDg6Eu1vUvzM7x4lKRIB0HQkb5Am1J5PuChT0UDKSaR8KD8peR0q
	WHoLb9k+VTHt71/BjNtScCujENAwHulMJBq+mpONL9WUjgylBAbx0CWzdGp3jZayzCTHBKiMXoO
	td1+WMZ4jfLHMr+b9iJAyro4sIhhoN8sRxyJko5s+BN6qBaLPcn8rsojLfq2ToZSy7ExefI9W6O
	x8bs1u92MaQyZZZgoIvqAkvKIN2qoMZAlBpLRAZyaSmITqZJEXzPIGLPDi+pvWzC3RnDCfEAY4c
	c6tV33rT+JC+GnhcSAUNu9CPLqiRkb/C9WxHXab6JKfhUHFSuwSSWlURbLoFH59QSQX0a3SuW4u
	h7+k=
X-Received: by 2002:a05:6000:4908:b0:487:2805:6834 with SMTP id ffacd0b85a97d-48872ac763amr22046956f8f.42.1790576927074;
        Sun, 27 Sep 2026 23:28:47 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-acba-a601-4494-3582-465b-0eab.310.pool.telefonica.de. [2a02:3100:acba:a601:4494:3582:465b:eab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a64ef3asm25338956f8f.30.2026.09.27.23.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:28:46 -0700 (PDT)
Date: Mon, 28 Sep 2026 08:28:43 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Zhao Li <enderaoelyther@gmail.com>, 
	Jinmeng Zhou <zhoujinmeng@bytedance.com>, Alex Shi <alexs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm: hugetlb: Fix subpool usage leak on allocation
 failure
Message-ID: <aroH94a5F4Mzuqgd@gmail.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916-hugetlb-subpool-always-track-used-v3-3-38aae9b5ccdd@google.com>
 <20260927170426.2467-1-kmehltretter@gmail.com>
 <CAEvNRgHQLifmcD1NO6cd7EVcCiQb6gJgNUo4HkFhZAvzuwMq0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgHQLifmcD1NO6cd7EVcCiQb6gJgNUo4HkFhZAvzuwMq0w@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 3x87c46w6nxgsz7mr159c7rfm7at7jwj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C0F1380005
X-HE-Tag: 1790576928-607212
X-HE-Meta: U2FsdGVkX1+t2cmv1Bmvsfm+cYupH2BgEP1ugUOGDlg0ENQeDmBOikVzxwoMQQ4l4gu6oo3n/t2UXKlW93eUhzxD/C67MEYknHYn3s9muP0mkA63tX8L2upfeucBb7+6JuTN3pe3GpY86XN9U4qTARAA7mPKD8FvXBoiVAMmDQ034Ge0c0LfGOMzwJX1djeUzHibUdp2WnLxKx4cn0hz0nsKXtBqtYp4CUuK3AHrcP0k/COuuUKt/uSzZ+T4jK3FH8slFM0w1woUYimuGAGBJ5nIpk2fI6Scwr20zC90sL3+MuWHA0vqruBSNLGO0r6RfvAEbmnkWy2iMKR/AndUI6tcBAJFNYJjOUv5ScQ24aG62/R8UJRRw2yVR9ZWuUGXynUQZS1qM51dV/ROEdYKYDeup09GXME5YCzawa2UICHdngGWVOcPLYTNbKw9OcpZdXhiC96dqu5e9ZF76EwFaLl+QSaHPzhgD/Xy7d6iFw4/tM82TQM5b6Tz1zViBgzlvnuQsaFXcblkwzzTJv/gjoes+1IqnQD/CYEaJKFnDMp4HSu4rDLB34sI/DFGYrhY24ZgyuJ9rWkomWuaDfYpXzodFJVD14u/XD1fFa0JrS8w37b3xjggP+hk3TspyvV4NZOpq7OhGaA7oMOXPaM5fAZ4UEBFrQeHuE8jZ39dbZW0v0N034T58Y6dLgVw1IErnmCiuXZHHA9fGa71slOWs3gTw1CfCz5vVetlJwgU13ln2S//Fz5uniPRB2+xwvUuGbLiZwLQvrHi4RpMO7VlHxsW4Tog+sQLe6C/d+hrm/YIWHAlVKc4X5y5opTvgQxHy6cCZSVOOby0NP16845QyoTEjzpQ/9vMbMLmy832TXtqv6LoII4twaVaGoWDvUzoDCo5hS/uRHlMD4blCLqvcbxS+p3vR2L/ui2AY6/smLGCGJiKcdOVsaL9J7KcZFyADiLT6CwWA1qobsdh6uv
 gZh6khjH
 Bqf1JO2X+QIl5JEjZmLM8fLGm2gco3q6EaOpS3sr6FaOEw7765wNlvA01LkJ81dtxgirZngZbMJ6tAzWD5GpJGU8iBc9A1s/BBfLecWpQLvFml6lRXPQpO2apm/PA2FXvhWnpCRi88La8TzYwuHltqXMXPLNydukRAAIPsVGjy0JFjCwkX+8kjqX1M06qkyI+pxmoBK8uCzY+tWe00lII5ndkVAddlfFj8nL0bKq7ihJzeFJ9H2K0D7TW+zEUzgXW+w6EH8sHbU6M6A4b4KylJJO0jMNWJY8BBws+N9vHvrdWkHTWHYT01ruV4NFAUrYwBhA8T42GuFcb2O9z+2TY0avIVDyU8rFxJAzuipTZua9e2GNK5xS25kPvi0S3kZI0mOYDPSUyTCVmioNpMSmF36jp0oQTPv7n92rmGsV5SKK1ZMPL7Ge8WB8fKpjPcL3NpD7kDTyWbyjSN1cLP4yIAjZW100kgqSRfZwYCnF0Q+Zq9znADe5HhBYvLOMrw4KeX5J3co4DVs6+33eENiPFcLLRHZyQzR9UJAHNHMu3Zwf46IBJodMilGg9L2/DN8BBd5SW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 10:19:08PM +0100, Ackerley Tng wrote:
> == Questions for Karl
> 
> (Independent of the "Path forward for 7.3/7.4")
> 
> 1. Does squashing patch [4/4] of this series into [2/4] [3/4] resolve
>    any of what you found?
> 2. Does patch [1/4] introduce new issues, or does it just not fully fix
>    all the issues? At this point I think we have so many bugs, it's more
>    about fixing bugs progressively (not regressing) than finding a
>    complete fix.
> 3. Would it be ok if you integrate your findings across your two replies
>    on [2/4] and [3/4]? They're similar yet slightly different so it's
>    kind of confusing. If you have reproducers, it would help to share
>    them! :)
> 

1. Squashing the unchanged patches does not fix it. Full v3 already includes
4/4, and both controlled tests still fail:

  Path                     Cleanup       After files / after unmount
  -----------------------  ------------  ---------------------------
  hugetlb_reserve_pages()  +2, -ENOMEM   2 / ULONG_MAX-1
  alloc_hugetlb_folio()    +1, -ENOMEM   3 / ULONG_MAX

Both should end at 4 / 0. I got the same result with one and four vCPUs.

Patch 4 fixes the later region_add() failure path, where the global
reservations have already been acquired. These two failures happen earlier,
after global accounting or folio allocation has failed, so 4/4 does not
cover them.

2. The exact v3 patch 1 does introduce regressions as an intermediate
commit. It starts tracking used_hpages on min_size-only mounts, but the old
failure paths do not undo the new charge. In the ordinary tests, with or
without the two queued fixes below it:

  - after the SIGBUS test with no files, HugePages_Rsvd is 0 instead of 2;
  - after the failed mmap and unmount, it is 3 instead of 0.

This does not mean always tracking used_hpages is wrong, but 1/4 is not safe
on its own. A reworked series on top of Zhao's and Jinmeng's fixes will need
new testing.

3. In both races, hugepage_subpool_get_pages() first changes the local
subpool state. The later global charge or folio allocation fails. Another
operation then releases capacity and a separate mount consumes it before
rollback. Rollback restores the local minimum, but its positive global
correction fails with -ENOMEM and the error is ignored.

I put the exact test hooks, both userspace controllers, QEMU helpers and
validators in this test-only commit:

  https://github.com/kmehltretter82/linux/commit/3ed79d756dc3845b9af9dc1dec3daa8cb141a500

I support merging Zhao's max-only fix and Jinmeng's combined min/max fix
now. They are useful, narrower improvements and do not try to cover these
min-only races.

Karl

