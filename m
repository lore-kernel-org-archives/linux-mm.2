Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A08C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7F16B017C; Mon, 17 Aug 2026 18:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FFE6B0631; Mon, 17 Aug 2026 18:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6656B0896; Mon, 17 Aug 2026 18:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 457486B017C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:52:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5DF01A09C1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:52:45 +0000 (UTC)
X-FDA: 85112262690.04.B41FE4E
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0ADD91C0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:52:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRPDPBhK;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787007164;
	b=Em5GVf206/9MnNzVT64hsPcRtlSbpYpcWMPStBXL+T7tFhzfbmrNreq5r/TeQzdv+1GLl+
	+43+OGurJJR+24xMHl4tFR0088wGPqVWOAYFkYypb/7fwjVuDa9+8KVkEp9IKVdarO7tna
	wXgHeU6WvM/egGu+G/wI9rxbCETEgX0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRPDPBhK;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787007164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtyM9ChhNajLECDRQkLysp4YJahh5EZOIx4/gXaBviw=;
	b=GG0/rWbhIGfkJ2mMaQ+AzIlpafmvMPgoOSEKNCt7mwn5+Kuq1gJKuSGbuVMi2meuujHV+f
	2PdqIWZVV6mV7ARNNS7YuT7VrerW9n0IBfnn8nqBoBhc77rV8MJhTRxaREb4uqzWhiRPTA
	d5yqh0eRr81G1z8XoHwnCz45dOELmPo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4998590d392so41794945e9.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:52:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787007162; cv=none;
        d=google.com; s=arc-20260327;
        b=J25XvdIbz82K7TUVblGtG6/bgb48dd6WF26EN2BRlnPVZFBeXvwM6ySzWjmIGqz/zq
         pebYhchQ9LQDA+RdUUnIwsEcE7Yz2sO9y0ypaLnWdH6Lz5n6tLkMCm0vHGaVnZ+kjJxv
         8Np1Oqug0J/d9EO/aEpwHl3VkLtJmJBuif8fPiAwcaSrluA1Xj9AxuBgi7wrwZArMYcB
         P1VwAJ7xSBXPXW0CPb7uSc8K5TxWIk427b/xLxsP+ni7UDuSIAFPPtJGi6Vui/mM/C/i
         Pa9JEX604FgJ7Z0MW8dBgv91dwh+Zb5qtUrU5zOYFE9OSOnAfPmwmk7D3ahBV8R9L59O
         yC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CtyM9ChhNajLECDRQkLysp4YJahh5EZOIx4/gXaBviw=;
        fh=XlFWfkXJPWEm1W9/993pgouldn07Lclv2ycZN91QZPM=;
        b=kWQFYIBvUVD/AKJuLccqiTvZBxkhNJKosnrd7rKyHQqwWXuprOoBefSUv6SX+gYv2V
         S8Rw2rnPITrBHfWUX8vFDJExLG3KTmdcak5JvrNOi7/0sM16yyXZ7qGzfAJieANTUT0i
         WynJPJ3qu4kleclMDxp+1AnRbJ+ZnCpKQgEP6SgST49n0QNGUmrlyo1nZSuj06of+kl1
         QnOxozqDFovTkPyZ0e9UKOggWu9X2rpvQsJYwJBhfOgEsJAXrDpMMN2DHmd0YS+R86CD
         MPF9YzvPIETPvPcblzYCLz4llcOcsHFPwtR8QED55hyk8u/Fb6Mei+ivLWLN8nXjaWAq
         MreA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787007162; x=1787611962; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CtyM9ChhNajLECDRQkLysp4YJahh5EZOIx4/gXaBviw=;
        b=RRPDPBhKGp2xp2hbFRHsxK0iYITDq8RqiJ0g63u+tG3KsUtomBV59eGd/JamBunQ+V
         y5+4IjNPG4X6xZfFrhxkAS2rQM5U/+SiYYEcPdy6XnUicGBM5DbMOOenEam2UYibwJaV
         7WCKxamVgSPPTnkl3AtG0HjABTd0z1b54U/Rx0iMSGdRlQDwET/RTfwbUAP2NuqewAIK
         MupdhZ5E2YMj57QZ61FIjKmcDsq5Ihz8+IOC1aRktbfAYNFE/HTpdnJRR8ftkSlhqI7p
         vPTgHpdJGzs+R0x/E+MSybfXfUZuyLH8cXKgQtoYBPIUydMAfm+4rxMpJ8vfyZkAU8LD
         D0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787007162; x=1787611962;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CtyM9ChhNajLECDRQkLysp4YJahh5EZOIx4/gXaBviw=;
        b=rMjzDxDpFrnmYtqMKPQLPa5ICF8PMAFMjPnpJTp0XPDPpTCn1VruKum0W+VwSiNLPq
         FBcQyu63L1nkzVN15WjwCoynON6ssv9GDaiCTLgzeQc5Q+QDoTUjzGwB3f9MXOuU0bae
         OC6B78cG6h/CgzYtKuRYCp44iQ1PXgNuYRmeMwktqCDHtg4ENZK9w9XNoBK8b3cGKDNq
         onnH2buTLEHK4Bsdg7oeV9baaFw/3GdFs2cAdfjPwFTEfcFK3yZmNgsV2tsVFA5zYa5k
         k3shgsnMBOR2mnDpyoo2h+rFsG6ZER4eVWWJLKkqtw6S+BWs348qXnXgTRcZYHxF4RH/
         kt2g==
X-Forwarded-Encrypted: i=1; AHgh+Ro4kve2X5JECo2swZ+XngpBq/RZEiYMYMU5oVLmb0h0epPo4SSKNqOCqB+bYt2SFSkyqmQBLd4vlA==@kvack.org
X-Gm-Message-State: AOJu0YyUqOB5OFHQDhhKrDbfa9qjblwZP/r95XtTU27g93NL8M3f1xmU
	KcmW5juVsBzPTLk6AOhE+/yzMyL/M7PylfASbnxv7SRAXuWrvU29DhUXBq/sQ7TOAp8NvhN4MwU
	v/vFF1rSjRkW+bNGGU5i+FKOJFP2P4I0=
X-Gm-Gg: AR+sD138cvHO08GZLdehep6VNitrXt7xbjnZg1XUtBYgHM8F+mqYf0hNqhI/1vxH12e
	8YhPswAbS8cQQjEmpy59XczNqPiP2Ac3P7hv+iAjPCH4tNLqJjhCJJwTVvI6lYsd3g9OvK1MLjZ
	m/ntcFkHKNnXBo8jGACgOJoqa4tLyzrc/92wK5Ru3WfniBRUyX1tK5UPhQhi8vQN1juvFtuYFu/
	gCERjINhFfUq+HCSSM+CEJMW9z1YqFVwTDmz54DqkyXlB3dW3DJzT/f7VKCR4fSh3fn3jdg0Vo8
	UAqJ0irrgUo/RmmhMS+D69M8QMXPKo4A6CnTDB01L2nWvaCscI0eZonDhENEEq/czcI0szFdbJl
	H
X-Received: by 2002:a05:600c:4745:b0:499:9eb7:4558 with SMTP id
 5b1f17b1804b1-4999fb6d4e4mr53342085e9.10.1787007162121; Mon, 17 Aug 2026
 15:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-1-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-1-4a625ccabdae@debian.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 17 Aug 2026 15:52:30 -0700
X-Gm-Features: AcwNN1URHam_DS1kATXaSsUvkh9LR2M8T3ghDzeWp1Gr0Ypp_nOOMfeaxJsYDFU
Message-ID: <CAKEwX=PnuV1RoAV2ghNH8JgQfDGskfRpGdRA_K9zP1C54YLPiA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm, swap: ratelimit bad swap entry reports
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0ADD91C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y5io6a7txi8x4zqxrgafgkk5r1dzegj1
X-HE-Tag: 1787007163-291522
X-HE-Meta: U2FsdGVkX1/JWpDSJPoN3rO4iBXzDzXaArUTGz1HPYcki7mwsM05FJvOxbskRTvWES0btz3Le9wwoUeR5zUISgNexKBW+kunfL9o7uLN+1HtheWmVgora0B6j7jdKJ9Ja4+hChLpEmPZBsSkux4m3EvO86nYMN4loikd4/AWaFz33lJ1iCUnn3EyvcRuncFjbwSE2kBO7UFTgrS4W2bdGhn+8w2dQ5SCWxe4DF6JiXv7jniYZ0da6WoXofPtlxyS4aQfE5HihnfWanWgC4zp477sDpoo1eiFb7IFlzVwS75bcMKmhO9aFHtlAWMvaaQo0lovLYJ6gOOn4h+0ua0ITUrlkb+jMV4voR72bVOBDHFOdqMwZAEKOeMSpaESS6tY7VVTvbAY0Sh1KVpBHS3tEG3zmeKGLWEaD1dmZxAMexqQW2ksHkB/Cc6X90aFS/jtSJ66XGD+fNWtBirsG1VBr8cDJMjP3OfjEGi2PRFrVLK983Cbbo3mWeHsuKOKE51hpUjguwCjG/MawyEm1h2DGuGxs0bDrNr30x4hgwgHNqmrzflWX0mvogAVNVeBcY5MRJGE2hCfLeg8qA3fFxqO9YXFzloW4F456uMbMMX9PhbnPKhR/r7JJgtXYcG+QXhpHEdSG/wSK/XT9E+LJOXq7Oc026a5uXaNzUvzDNw1d2K3oelGdfcxllWi+F0UEou/mn0JPglvRoGMeoRJOeVUw69IrTp6jq2O20OBlwD63RpKUzqyzCzx/hMgGpyE5D4oYGsP5w5vkxaOH5n0piEnKjZd/0yikW5I2ZmwkZXdxkSB8SVLUgkMyUD2qtph45PNdbOF3fCnXG888gPol599WjC43uX9UvfnPocUN8YcCLX6E4WeaBoW83AYiRNkOglusbsWU2CvOdW/yRz7nK+W/q5WPJ4ZOo21Xaou9Rr4zYQBqX/lvvhq++OFhordF0DQMVdts0VusGRg0FVnRb8
 2GJttZKD
 mUiI4JIkY+K3wu3IcUVZF3mrpw1sQ+F4RNO5I+G+RJB7nO63O0uIoAtR9qX/N5JKY3/dzFaft7ml0Kmk5UrIRue98E1MNLhrmZVroV6dqj3803xLgnq6i4ijMPkbOtT30v4FpZ6SNfp7H7G0kKs38VfAYdW8yFc2xjl7+h6YZFSwRS7v6fGdt1JrUJgkHO4nhe4CqtVnngTrcMVCDkRn+nou36he4Z4zmqjtyVrcjvFp4TSDD0n2T+QJCbKcLuqF2Br/s+WBdUXEZsA9OBfcK+k2fyUu/ooIlIQwqQRtYdafFqRcWfIwe0m1R77agIfxcQzm9CPyJMPpYsFBNEpptryGpwzDhDoK2Uc1Wq7lKGzquXlc6C9ttfK6FpqNYy8JRw4ZR1Lre9OejT5pD7DxCfgk+pOQEawBhctV8EuQq4e56Zd5RaXgOu9yZvWvdWSnGxccihrm3HXFB1TXV6TBbAn6prcVeADjQDYzJaYNZHJT7hzU06x98cJXaSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 3:03=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
>
> swap_dup_entry_direct() prints the same message from the fork path, once
> per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
> does not.
>
> Rate limit all three prints.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

