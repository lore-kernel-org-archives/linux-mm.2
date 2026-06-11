Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16858CD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDA76B0093; Thu, 11 Jun 2026 10:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E166B0095; Thu, 11 Jun 2026 10:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C846B0096; Thu, 11 Jun 2026 10:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7A56B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:34:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE52312069A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:34:53 +0000 (UTC)
X-FDA: 84867878466.16.BCC343F
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9F57E14000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:34:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UN0b9iYs;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781188491;
	b=Bec6WuEeUcJXJQk6MAZeaN4lrKThPlWMIKUU1/k0LmiEvgNv2YugGhwPzX+jLope4yE2GF
	n02H53v8lgBsYgPvKeYHR/hsBKnuexkPPsu6bFd6eu7Ybdb65n4YL+0QBbXq0B+VOo5q45
	6Kjf+OnvC0TkbLIYzzO8zMC9x6/J/AQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UN0b9iYs;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781188491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ut/DfUchADgor0Cp2q/aAjkhxcFZIOC7eymWGcDYKdE=;
	b=Ff5zR8RPjcRLOfQiiLszf01XtlkerVkEmhu2wgtKW5EAWOSIFoRkxm6aex8Y0ZwD/JTKdm
	hNFs9LjkxLAUJoYwo/xSf9LFwzZTaIX+0ZhnfZ09QNErHvByKKfI1SMwN8hl2Kpl8KqfCE
	ywlcMmaBDS9uYWkHSBVXdXRsCAXEcX8=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45f3cf907ceso4262219f8f.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:34:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781188490; cv=none;
        d=google.com; s=arc-20240605;
        b=Lm7q6f5+FwUKvMl0t1YcTbGkQ6zMyLYVXXioeHnfrRJUmQ4mDURN3nULzQD3qkE5iR
         gC54yJ5lXtGEyiFotvJv8Wqj8pBaqTmX8LItjadCJjbcYAm1A5y21h1/g3iztfupRl3P
         M8FRtFdzs+C9oT5cUusb+hEMuHgadPo8Z84k2c5NUFUCKn7PMRBQevOh+Tj8ujTJr8mi
         BT2DNUyCSutwvcSK1GFujEyOkm23cz6SskBzbTjLtj9gTS9d6gzjyIWLnt/5285uXjBq
         RqD3TfTAIGcPwx4r9W2Kv+d1qjAASbjwdKFTy5D3hzvXVtWFRkiUSfjOb3ZFsK8r0cqW
         NfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ut/DfUchADgor0Cp2q/aAjkhxcFZIOC7eymWGcDYKdE=;
        fh=RDfHejHNbFC6XJu4yLIL3AIPp+F/GREtKEVHq0eOa+I=;
        b=XjP/mwZe+dlFxjE0DMT7otnmQSL+G/Vtw7Dz8tW8gMuxIoSiRw9iNSn8VAycm+IGt1
         U6zJiARD9tFTuAfrmCRG2xKfyMgVuymcYAD+8N5iamUo4svV0f9iw2PsOQu/c5w+3SAT
         xf0xWPHMWwb/aew8c7J1HhhBRtK8GtUgr0Chfg92WISKhPsAbnl+KIRUjkgeiKIWV/4P
         GQHKGfBCO2ecSFU+Zw3jy6lOpvzmgUKpEnQn6jCgwHGIplWtaWRujw8vUWQA+bjf8rNk
         dRza3rONXtGZOd8V4qTnhW9rhdwkDMeyItRTpchYv6o6psDXDRvpjrIj2psiNwShzVFI
         QgQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188490; x=1781793290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ut/DfUchADgor0Cp2q/aAjkhxcFZIOC7eymWGcDYKdE=;
        b=UN0b9iYsG5dKoeKv18JG0eVPfSPsKhEs0+lIwTf+MuN+Rxqv8X6GELb10Ao/NgoG0i
         u0jNuFAf8AhPwm8iDY763MYujVs70QJnd9R/UriS7tqQp2nfQ+HSJwOrl3trVc4a+mU4
         DCjw1ZdoQWI3GL+Z5aGix3nP4X48N85QafdPOc3QsA5DYXrSvwlUYpf2pmXs/+HAT54D
         PCriTv/jkOwPNCBzPYTmuFQUmVhUR3MdErWQV8sMWYvNto0+MUUF+2Ytt3rCO7GJf/CB
         kvylTqCwUBxcY8ZX76ZVSzi7mITvfPOJpGLTOD+PDP+5yB/xV9PspnSThuXx9j/RLlQU
         iiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188490; x=1781793290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ut/DfUchADgor0Cp2q/aAjkhxcFZIOC7eymWGcDYKdE=;
        b=IuZQKuORn+VjnsRIfwvQyg4ji78RpjuwSx8Jfyuz22Y2iglUXH7gN7vw9sqPtV4E7X
         yayexj0VuHnQZAPjSqtv4WP07IDgBob7Zke/2ImCcZY6e68zJtFM33jhOgvPcyzL++Mb
         kbxpbscc/kbig4glZR0+c/1/mQoASYBvRLKXU63bZnJnVLpES0TLfwTv9mHHVWRfBq0I
         rGtYMB9eAK10SMcAPERNKkV21ynBCASHsEmDNkzK7S0s4fqIWJacmJNocAYLubzZoIN2
         zAyB7VNPsLMcG7zxYo06G8dUN5UdNNuXR9GJaENWsntroPCcMgyJIwMkBwXaFKYhr8Db
         tymQ==
X-Gm-Message-State: AOJu0YxJIkSgQIzo6zj5uq84j99xGmfISu5Rvfg4lAATxJVxxR0Fw4iQ
	maya5Vkgqgx79/1cC1VxIW3IH9DGYVjcESvUf6FvKmrPQ7SJ9m9iUt/0EnDXy9LnPgzeGb0uceh
	bl9Q5S2KdqYzMJOH+7YOO5Cl2PehkpBQ=
X-Gm-Gg: Acq92OEp59P1vYgaaXgcRCrU+XK8wwRrV8HnhJMlP46dXdyGcwIxZER71o6ERyQHrYv
	RuMcnZHaEl5u4Lbosjt409Ez+LRSW3pRUhMRO/Qpf1c5pfn1ou4/zBs1nVr7Ua9YFTkmsG7kSYz
	CmKghBNaOVICIb+zhzfanRBFEEGbHegKTGKwoCSMbRsbj8CS768BRgkDoAUBm/iUuh5c9QcGoVO
	m6M2kWrqqP34lHVrpClTRhcYcH2tVLD/DMHpxF6zmIEttneBrfAn06+KWjLeOlOfT5CeZTVm2Sh
	EjzQKVhSdONqnQdcW5zd99tcf3W8uAsP0JNnij3mhXxi7H6AJnAKKgxiko7xNLOPqA==
X-Received: by 2002:a05:6000:4601:b0:460:1223:a044 with SMTP id
 ffacd0b85a97d-460673e4332mr4735791f8f.0.1781188490040; Thu, 11 Jun 2026
 07:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
In-Reply-To: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 11 Jun 2026 07:34:38 -0700
X-Gm-Features: AVVi8Cc67aBqHzlDAuJ0qAbJB0jvuy-UkqEt02YoWxrCpURlNsgxYvsvLcCS2fI
Message-ID: <CAKEwX=OvF=8TAgsA1iV35Si4ABMnFNa=XUp8JCz6fQM5z+4x3g@mail.gmail.com>
Subject: Re: [PATCH v2] include/linux/swap.h: Remove unused leftovers
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F57E14000A
X-Rspam-User: 
X-Stat-Signature: jrb8uc1fw1knb17asemyhha15k6aesqf
X-HE-Tag: 1781188491-606584
X-HE-Meta: U2FsdGVkX1+tYQVnDSxHknxjwO7aywJX6q47hW+tkXoGHlSugcnWFjs5zIvN3lcMWpp8Snu+GRHTpNgbmXGPETJZ89YImS7a1bKRwVLMqicRRDVAw+WkfLp1XghabJGrSLKXSINKhoo3fAlqtKFUvbf6RLrLY9UPgdqrbPT64APDfYy43uxY9ZmQWUwNZ/NtcLqo3QVJNtslXBjiyyn9ZSpE5oBFPV+P4B6Q9vzC+ajlFGfSUx09J7xn4IRMHnJnNqi8i7uXxusAwovnCEe994SajwtQyPHYNlJHnFSpq65bFgg/avEcG0Qjyvl9J//dnod48jOdRhJ+zI3i7GqfpqP3t0VLDDMthrEz6PKPFeTdr3T+XPtgLJK/jqMldK4TMncDmvJD7q8ACyxL13W68kxJLeObTYWb49Yg4L0kFwyvLDJNusEUGEMJd0Ut0/918kHc1PBquXxJnIwCuGHT+x2pVjUwwqy/3bynhcGvxCoEpzmiovwC0tCxN8B3sDbhCHwAbttSEIK43iO4sIGRM5Iyy95Yh3Rklekg+WmenlgbAiUHCAJQa3At+t5tUBoQQgxDJRhFCeSpVfTZv/yDL/o1zctadtX1ldRuzlH5zuGeA1brg7jr/YuucLUkhGkB+z7oKhSruRM5PrywVoU7qlGTOFySr7HI3I/5QLbMfUobr4MiKXUnOxVUbEprY45/VugwDEBZ2hk0tcoLdGCBfRaas2cffYxIRWFuAIKpvvYzjEIzKjaL1GCCxjVm+yllTVr7L84V6m+NQn91AD00CfICFbiAZ1U86nTnn6WK9hVCiYhFHoJ9ptKupkzxwXcuqjqYcVjXyCUPj5X6UJwfBq4CKpyiNlhKnL6nXu5IvCwJR8WZPjkQXNtuf+VfFvue4aPRPLHVhKC/sMOJY/rvm8KrPpS+OsB87X+DHKobaJmRkeAr9g7aTI8lNmaQt4mrHTlU+LBUW5FDrbnbflA
 aiSVYD/i
 ba7f9GWWYmv78ZjLkaNVMtncf740SiOukQ71CjIVAzchrEdcbTZJ/7y/q84mFHHndxRCptI2xdtXe6oi1fCWg/9FBVduVs8ix6z2v/bXNzkUKjcDO3aVe7mxIxUrV1CF9k4ZZui7/s79jo36I9ODXu9+pWtKAF0rxnYLDlLK3t3spMubLhKJ9gVyQMN1gZVOxXWNa6KZUdHK8FXzc7EjUeMc9xY7Y6e/OdonHsY1Pazbvd9qLxoI26nTuZsG2HFnNAMVEfNYvZGj/fgKjpTM3apGzc7mXiN3kORkeCMs4Bhp/fNBgjqNg/ZWzgsGJ9vdZ6gZyoHWQDiUiON2/jCUu7ixZ6E9WCYwhyB6dH/nNdbU2xuaD+VquEcz1e00fmJx8Z2G/sLx3xrw+MJ4IxQrDcx1LCtXkzbC7DmXCkJKlG29020PhSv3rcXg6IzUhZIT+338ESYTSwIGw1Ii4VIPk2me3SkALyRLbL0GJ5qcb3Y1a3Pn9Wbil6BOXs3BK+qvMQv1MyRflzgm1VUxqQjeQTkBt+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:09=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> This removed unused leftovers, most of them are forward structure
> declarations. Also removes SWAP_BATCH macro which isn't used any
> where in the code.
>
> Found these during manual code review.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

