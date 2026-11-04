Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441C3606EE93
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GDFpf3YA
Received: by kanga.kvack.org (Postfix)
	id 5CFC16B05B9; Wed,  4 Nov 2026 11:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5804D6B05BA; Wed,  4 Nov 2026 11:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495CA6B05BB; Wed,  4 Nov 2026 11:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 233F76B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:37:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66F1840114
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:37:25 +0000 (UTC)
X-FDA: 85397992050.02.4C09053
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF40320003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:37:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GDFpf3YA;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOH9xJas8+AahnE/juo87CvpZQxHzo4/Iy//5/OPJsU=;
	b=QICiXyItG/xLtHCFsoAKhRhhtlCUZ5hFEsQthFv5W+EsdBJZGeqAw9PCYxyh6C5FdpzxZ+
	8B0M41VGvf/A+cMzYzBgILQXrKfqUKwdB7D1kb7AP5HznTy2v3kdQM2hF9DuiAdF1kHZlx
	cl9bcmIvCMtoA7en9Ui58Zazc/tpukQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793810243;
	b=qGRh9a8tFMD1EZ+uIrKKx1yP1/BRxtSRbRd7uOWaxX42rxUa1skaahxHpYf0Kd1gOXhOHb
	ZGeBe7zVKmu646lubaGyAqLRwe2KdaTVb5gyFfUnoeRQRxzJEx+RWeL3pvIjHOZ17G5gS5
	edNRQe6U5E1lJhyHHpayvYHHeXNNXZQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GDFpf3YA;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so7890875e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:37:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793810242; cv=none;
        d=google.com; s=arc-20260327;
        b=d3jENt3EBy5kdkReH+hqQb46DRGfpttO6fH3nORpaq4nEuvaszuyJU6B4iOWUfQbfj
         4ZgttD6D9b4lBoLEcO1nNBcDtAA2qGvbkrNoUwwOaPGqc3WDGkO5CD7EHCBFgvO+pMzH
         6fpCuXwodwlCIyrHIydYAPLnPd/g3PKMbhqyjBkoxBQgILnUMUAey1NMs84Qhj2W7KCC
         sFZZqQDGsOqI597HGxWpCgVIfwDF99bYOz+VfHUwmLp6WME81VPMc2YKi0CWZh/+8Mcw
         UGB0CW4qTlMnlV0HTpFKRL4fynkXpZR9qaONDyz7xwdeXHsBj75AM4a+EiZfWFU7iFXs
         7PSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kOH9xJas8+AahnE/juo87CvpZQxHzo4/Iy//5/OPJsU=;
        fh=KzM5OLLOx16Xlm3RuNqoRIhIfIaVM7kEZmYhn/AhuU8=;
        b=FCg8Cxgv2hX+x8yHuooXsHgVCMyq/5CHy8cAXlDzdPrX5XsEKmjrmT5f5mCPP0rbB3
         PHTWXFJ5Gr/iJu0zdWmSnc6V6POtwFeDhRlS/RGo5wHdW4tpC1YRkzkVKRXgySi2E0SQ
         p9DSaR9qke3J03CskhqgAbq3BoxqxDQtXZbiuzLAQ02TscvGNH0M8QUupFSR6bLGOqCU
         XXh+y2LVyE3uIay53B5tDX0OiBgBZWSdPbePDwRr0fV7nBP0QRU9HPKAi3GCYs+4m3iH
         1UOe99a4kn6rWTCfkL3/ItV7d4zG/qC1+shZnjtoQV+Ql5JDgg0zc8tmNWznnj/aVFXC
         /B9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810242; x=1794415042; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kOH9xJas8+AahnE/juo87CvpZQxHzo4/Iy//5/OPJsU=;
        b=GDFpf3YA88wHpowGys2FkB5GcxtqIJXoGtI7UJiXJDLEArdRwpFvAMfT8razocf+Ut
         eDQfGrU4Uj+6G0DC+UhMUizlNes0eMvqmkxq13FsuXpsbkM8s+nLeoCCGFT72h3L5h4Q
         d0opiJ75DXFU1g65h0hBXS6Ovr8jRvLPHyiCz7sr3KxeLtpObXlHb3IlifCduNFbgySB
         G2OdrPdqYxq/mMbZItJC65qamNc3Mb15a1BEBLYJPLb8iZKWQDJaGRkobTGbN30jCrxL
         1W7xncTKdyvwXDewEtKx35auoM7y5oa25O9j0nepFs33CdSTo855hkdJplC8VS30goS+
         uzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810242; x=1794415042;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOH9xJas8+AahnE/juo87CvpZQxHzo4/Iy//5/OPJsU=;
        b=xAvduiScp2h658VX0Fl9nYOOxhceQ27dgn+QbzkqdUhTTwPQ9zCvGCOJuvdutTVeU1
         b6NqWZ2QtyGeVtaWztiAQiTI1vNUgu1D8nfHR/u/MaxX8UAEKhLQAa4/h2Q2uprtI6Dd
         FNhLGBooSkZnrKdm3YQzA0PV2MTdUj0K2XFz0MH7fAvMELSuk4qAivwyxoFjtToAeNFZ
         lr9eQsY3D30FWFT0vilBqSuZvrqjBR7CN6iieswqtPzRXNiCsEsIJYov2ShIT7MUIwSs
         AMiYg4qiVq53R8vy16piNgN6LvduboWxg/gWGFKRtESnOo0br2MkfO1t66yrWUOWEVTD
         07Mw==
X-Gm-Message-State: APuU4Z8SYReRIkV+A3Hac6e9S/gTGDctwfTiePXi/LRhI2KD5+VKRtnA
	HMxLgXTbNvjs9SayL+MAEGg8pkpFKu2DIZDxLwFOi02NuxpQaasBKAWzLcWhnukzd21C9lzNt7g
	oMOpQaM3nUJT9oJl1SANMp+Qnb9iSN8M=
X-Gm-Gg: AYBFou3Tlj8oNLDIMHm4ZOJSbDYg3qytOXjpFgaaWw4qcpPhPMZJqFfQgoc3BrsX3l1
	Y9cy1XZ8p4CD9B5biQcFOdkpd1SkNiEQqobaAd8zSG0GAHC+yNGZ9zU4NiYmsGwQSNOppUQjjnm
	4DIwRl7zSE7BJOK4U+hy6JMres9ded90XqsGcN0J69Y/KtCXNGG3J7YPm5qRC6xm97UwDtN+g6U
	qmnCrqY8/AeJpMvSpyy3bpDmS6dcFIvQyIFXNc+wmjzGKhoo3uWH3xdRWU5Tge6l3i+EuTmnRB3
	elVlJHHfFilPt5BB+AIhEcWDVwv6KLP0hwBBHabz4qWdTb046D92lsz+2SKV+K5BpDSts/tzEdb
	5XEytwe0BvI9Njv6oBrN7RSewPfRp1/ZOGOAPKCxqzeMAbdDt7tZ9ky70wiL6FvT/r5HVAehj2Q
	BmbsMLaNj605YkGJDwmcXGNFIHbmC5JbJS0kWKtLZuFp3bYHqF4vLLNIzP3E8YUBArKaxijZTGY
	g==
X-Received: by 2002:a05:600c:4454:b0:4a5:1cf1:b7bd with SMTP id
 5b1f17b1804b1-4ac1794032cmr383478795e9.16.1793810242092; Wed, 04 Nov 2026
 08:37:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com> <20261104-swap-hibernation-slots-v4-1-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-1-0ba9393609e1@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 09:37:10 -0700
X-Gm-Features: AclHuK-ITyynx-LQrFm_lWP_ZygTvkXkWXKJmodVXCRLU9qFllIRAK9LXJR_isA
Message-ID: <CAKEwX=NyfTtr_6uM1cVcpQB=1tOFtcWb4Vdya=VD0v7XCSE2ug@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm, swap: only allow swapped-out slots into the
 swap cache
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: j54mzbhxufruxp7khhowsj3m974zzy6r
X-Rspamd-Queue-Id: AF40320003
X-Rspam-User: 
X-HE-Tag: 1793810244-793719
X-HE-Meta: U2FsdGVkX1+NkYZrN+9URZg2T4Py4raHjbhri1vo8ohyewIMeQCmR3FDPKxYMWYXPkgAOYJAf82qtRqFgFR0cL0ZTATTkNfL6EL6l5R7dl1ahkRSBkdEdFWR+kmVfd9o21RwEdd9awU/HQfZicMCPqCgOezZAr+8bIAlJNqx9IcMbfdGDfNG/h11WI67MsfSM8h8B19kyGa1XgHkLf83CQJQaoYOa1/xe1UtntgsygsWtHVouafFvmXO4XfcrtpQ+fwQ9gy6ZoSvch8xZMPNtbYbYomDGoyDGZHwf/C8+lhtCewRby9a1dawx67EXEPwoNTxi9wqSKyF32n/qFb1K/fXnyurW7Xic+UHndTHANohYVcm+jjLXwxdma3WWRzFltP579lcaANvVvPsuTPHuBtjuXF2sv8Yx1t0ugaWIO7o7G3I+zJEMyAdPazKpsBzXM7L+9528ePqAScXdbcu016fOfFiSAOKYtLV9zS3PVGrdY3Etrt+VsyOQmn8SGYn2Xe98nYKWCkioXbXxbyfqgyRpVR37/ftmE/+pmQsS3Hn9txw+4OkZWmQL0zWYheTtbfiCpvJ8uAg79FqHEL997x1+bbuEOZ+uAlXVD0zBMLpJUYgA4odq8LENM4GlkZULTVoSyUVoFlO+MxRhP8W3ZYbWwoLhKYJvRNzLYIJt8hCIouNVcPf6mhXmpQLoB7C5d0XNMDm8PDs18j/AHNBqm7HycF38YkAkEqPAsYkw8nAP8AhLohpVsfmWbI44iELbDULzQnEMc5nlWxk/h5gHp43zpZ8j+OG9Ia9DHwvl60gHrw86Mo7luvE6fhdvA895VPJhloaXVcQ6VTkFAidsOE11Y+mnMLDCeU9aDTkBgm2h9Xl/C/5nPDa0sbn4OvytSd5Vp/8utwWqsFz6cHQbx0+8InmSq5/+T9p1f3EiXyg70p8upFejPCY4BNWZ042x92f0lcqlDQeSH7NyYp
 MkXX9jcQ
 kmDohFq4b79yWQD6E9wZZn/CBWV3M7xMvXA+tXfTC+ntZsGrazyIGyUoTfnl4gexb0QL7PI05hW7v9tko24jojkn73vuv8vLpl+CAV8bn4VBROjU0ZjZ1nxWNmQ+c10AmlPXnvOOOye+tahPDkAr/7VSJ3BTsjaaoNYgSfXVacUVaO2Pa9KtIu9K8MIgEqhvrVdpnLD6IVKNDyPTpCqBeg9ufcW/uInwDf/Hdm+aWJMgXReQ7BUwalogUZiMENDvSdKqGN+K5CLnA3Cm8TC72KN6QkSIxhhXu8ZbG66QzJhP+Np4YjMiUlVTnxUMzsN7VASpNG+E06A2AhU3pn3e1KYISpsO1tPC2kX5GTvAwpqbtJBW9EVMoTp3vVbUXiSGMGKnBvm+M13sjSe/cOoZk1ymMpctwqX2w9y8JcPO1WJv28p/u9onukWDpio/quhZVtg8paAt1QHkZ8/w3kzqTgOtRSJjC4Dv3mjqbwT54Ca6ApYFDOhkJ5Ey0MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:25=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Youngjun Park <youngjun.park@lge.com>
>
> __swap_cache_add_check() turns away folio entries and slots with no count
> and lets everything else in.  That is safe only when the caller owns the
> slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
> window of offsets around the faulting entry, so it can land on any slot.
>
> A bad slot gets in.  The check reads the count with __swp_tb_get_count(),
> which shifts the count bits out without looking at the type, and
> SWP_TB_BAD has all of them set, so the slot reads as SWP_TB_COUNT_MAX.
> Readahead then allocates a folio and reads the offset off the device for =
a
> slot nothing will ever swap in, and the folio entry that replaces it drop=
s
> the bad marker.
>
> Readahead used to be guarded by swap_entry_swapped(), which goes through
> swp_tb_get_count() and gets -EINVAL for a bad slot.  That call went away
> when the swap cache checks moved into __swap_cache_add_check(), and the
> raw accessor there does not do the same type test.
>
> Require a shadow entry instead.  A slot dropped from the swap cache alway=
s
> gets one, empty if there is no workingset value.  The type test runs firs=
t,
> so the count is only read off a countable entry, and the check as a whole
> runs before the folio allocation in __swap_cache_alloc().
>
> The large folio walk in the same function does the same raw reads.  A bad
> slot cannot be in its range, but the range is not pinned, so a slot freed
> and then taken by hibernation still trips the countable assertion there.
> Give the walk the same shadow test, the folio check folds into it.
>
> Reproduced with a badpages list written into the swap header by hand.
> Readahead took over four bad slots before this patch and none after.  It
> needs a crafted header, so a normal setup will not hit it.
>
> Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation i=
n swap cache directly")
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM!
Reviewed-by: Nhat Pham <nphamcs@gmail.com>

