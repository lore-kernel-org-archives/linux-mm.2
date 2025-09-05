Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1BECA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 23:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A858E0006; Fri,  5 Sep 2025 19:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B728E0001; Fri,  5 Sep 2025 19:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9408E0006; Fri,  5 Sep 2025 19:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80BE28E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:58:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3B7485D59
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:58:17 +0000 (UTC)
X-FDA: 83856863034.15.E279B05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0101914000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:58:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/2tIAu6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757116696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXHsSLKRdEz/0gzt3BLA8jLGOAHyduS5LK9Kzbr6hrQ=;
	b=rrvi5ICz0sdyQSQUa94AtCko2Xg1h9NXs+vakplAhtGP2DqNX/lygjMKZa4izrh8b8kdoG
	6STc1YD5J7gN11OVcXzFOyfbzp/EkG6+GWbfBaIfiuG/YDKcn+jdxT5MOEyZaDfFkM0bqm
	+2FmXt0vkVVO09u8QG8cTNRvgCsSjk4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/2tIAu6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757116696; a=rsa-sha256;
	cv=none;
	b=z9MCL33WF/0HXBCFGhBjzRElyuz+9W0TenSiLIHcc604vSl6i2gn+vygiVOa3PshisPoPU
	kDJzVoG5n2Ih7bxvbUjkBFExjNFg+EahcnGiGH7xaSQRCdaBBzexcCVIU6MX7wYRxd8ZJG
	lRmb5tIi5pSwLsY9/1JdHsj2Bu+hiyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AAA7045037
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4EBC4CEF9
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757116694;
	bh=xB5ldmJy/DKXYeTMwYcDhf1eR32/RPQBu7v5T1o/n7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m/2tIAu6bl0xHutiFPSbyYbcwRX5gXZlX1sh2+38LVJVYW6P6a+4JuRYz6227h9b3
	 BAMEJjX3r5Wh8e69KKyxt2GFO9GfR4XriwhuEiqPyd8f17I30YKJfSUQWR8CztT4ZK
	 h6PDG/SLY/Db1cxC1kFix7Kp/m7bOuJjuaweddSG9o3L3gKCicA/cTAPu7R4tYBaXg
	 M7fYegu5aorXe0vzygwBHlownqHf6Or4ue5vTusiJAIrOKttr6gQtyvfIUjY6gGD8e
	 a8UduOfutdoZd7ngvECIhSW0tqL8W+chvAeljUQdoS9EZSpfoOSvSh3xplQhcZ6NY5
	 ml6isXoJHs82Q==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so28695e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 16:58:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YxCLc8Ll/IN/mmqokaGj/NKMC0CcxQwJKfL1fzGVEYy3bgZM/8c
	57cPWhdnan+RtndErZ2jBvBGP6ifsQ5ZELWsRv/m59AJqu2nhDMmP5/rOqI484dFwXPMgNi1i58
	cZbGV4RzBF7sLUBAUwxYGqT15p7pd4Dl65JsKnITP
X-Google-Smtp-Source: AGHT+IHCcH4kCuVMxmKbBqGME1oVT80rXJRAfI0UrcAzfpUu4NxvH2ftBru08vDxTQGrCxVYHM9hISQJY85M2TQRNns=
X-Received: by 2002:a05:600c:a408:b0:45b:7d8f:4bd4 with SMTP id
 5b1f17b1804b1-45dddad7944mr480225e9.4.1757116693112; Fri, 05 Sep 2025
 16:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-2-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-2-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 16:58:00 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMsGGtOuPpDwFKq0sNhX7HKbQWWK31uWpqeqW-RGTo-0A@mail.gmail.com>
X-Gm-Features: Ac12FXzUSSTKBB1nYWslF_7FFwdhOBxjZwGBNQCXiV0WHLUStmYdDSFHfZgnMRw
Message-ID: <CAF8kJuMsGGtOuPpDwFKq0sNhX7HKbQWWK31uWpqeqW-RGTo-0A@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
To: Kairui Song <kasong@tencent.com>
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
X-Rspamd-Queue-Id: 0101914000A
X-Stat-Signature: mo8wion8gdqkqn4hwk1mk87aa9seioq3
X-Rspam-User: 
X-HE-Tag: 1757116695-483218
X-HE-Meta: U2FsdGVkX1+n9HW6FvRiAL0AYYCU7+1nfQhZJGLZ5FuBjXOrOU+gXZKdq2LjsBmFZA83G/X+7LJ6GrNEFdJXRk/RGZ3Xbh4XYtleOs/4l/fPw91IheRkJP5vHRlamguCMACGJgUcuoj259t9m9dSoibtI3mqpcDohoj0ZJfwf1wh7dS3vxZJ0P+h3QyByhlxcMZqKjlYe81eShGV53wWaJCaG9qaf36IyFT2RgCzfMQ1oLOCqemdCfwDWxTvakeJmJj5x6UXHRlQtI7fqnGWLdzzUr6e8Tthb18SmfZYvWcst7hi7h+Yg82MLXszY1nhDcrY97HhEq+UBV5ryMx4LeKuuN28CJFA8MXYwpdepnmRygQHGwfqFCKyHZBIXjMefdyYyh/6kb5NRoxDhYT2Dw98TcR7ZUCkmJOXBrT621ZbGrQM9IpHAr+V99BBdm34TlkDdQwIJQKrLsE4XVaiNIQe/1BfhOqjQacF/mzQ8/R2WKIzwbMN768S2VUFV88MN7yRCjQ8Dk+wXoO+fx6JBYjILYfjDs5Nm/ODCtHMQ7pRDwUZBwaC1O1RBQwi7nlnYR+mRmGqcYTAV+6TEeCg3jLJdTU9lwRycnpH44uKYzRruT6+bNpGcgAFllB0LO/r20sIMwo5p1Hq8bDoDftTS7syysK1O3rGmdu6fMvic4Kz1r4HoKSJmCNK5KlTJCNnwzSBHW4KCmerpKkphkf3YupwRMtMqBE+56Cgyw/hF88RvhLQ9ITYCMpyqcTe3CrP+mt2gHtp7925Xr7MJHOBayAvrz0UJAbWtfuNAmWx6n6oAk1yZOGPGkjg+O9unonDopYheIy/7tyNGRRWHi+4NiVNekAhHmzwt3B3cgUyqqy8KyhNGs6v12Fkok5MjrQxmkT6gzCBwXEGMN0rmwJGAcZBBfxpn0rYpGera92bKDajFAVnlj4K14Ls3JsdNc5hjIUUIaH7OqZUTGpwLQO
 7oXnQJMa
 XxyST5PhCYEg1AeRAbNhIpREms6HIOx4cjdJfCZ3T8yH689MrqonSHauLKwtUTGXxAZcv6O08JgYlt8kRqroY83Kbtwr7JKnrB91prB/wvp3GEmBFlHUOc9SBvClTS7/7SKRhcR5VitOsXFfY2Ghp2hR+pylJFvBOEb00DdcUcmvWPF6MCwLB+L2ksmT8J/RyiVRKt/y3AtZz0To6RsoUDh5/sO942wjAcmID7MGwW1yaF0ytq+UEzM0RO8Y2Al9yWK45EPt6Pz3UPon4Si/qFZ2kcEeO3mqybx2vU9zdllVhheyavWChN6PlvWvOc3IhvK7kFOsH2GyrfziUL5o6yE0pjO7XG85vOFMgwPy44VRN83g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> From: Chris Li <chrisl@kernel.org>
>
> Swap table is the new swap cache.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
>  MAINTAINERS                     |  1 +
>  2 files changed, 73 insertions(+)
>  create mode 100644 Documentation/mm/swap-table.rst
>
> diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-tabl=
e.rst
> new file mode 100644
> index 000000000000..929cd91aa984
> --- /dev/null
> +++ b/Documentation/mm/swap-table.rst
> @@ -0,0 +1,72 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Swap Table
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Swap table implements swap cache as a per-cluster swap cache value array=
.
> +
> +Swap Entry
> +----------
> +
> +A swap entry contains the information required to serve the anonymous pa=
ge
> +fault.
> +
> +Swap entry is encoded as two parts: swap type and swap offset.
> +
> +The swap type indicates which swap device to use.
> +The swap offset is the offset of the swap file to read the page data fro=
m.
> +
> +Swap Cache
> +----------
> +
> +Swap cache is a map to look up folios using swap entry as the key. The r=
esult
> +value can have three possible types depending on which stage of this swa=
p entry
> +was in.
> +
> +1. NULL: This swap entry is not used.
> +
> +2. folio: A folio has been allocated and bound to this swap entry. This =
is
> +   the transient state of swap out or swap in. The folio data can be in
> +   the folio or swap file, or both.
> +
> +3. shadow: The shadow contains the working set information of the swap

I just noticed a typo here, should be "swapped out page"

> +   outed folio. This is the normal state for a swap outed page.

Same here. "swap outed page" -> "swapped out page"

Chris

