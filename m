Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F61FFD45E5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4F96B0088; Wed, 25 Feb 2026 14:58:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758626B0089; Wed, 25 Feb 2026 14:58:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6309E6B008A; Wed, 25 Feb 2026 14:58:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D49A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:58:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 151BFBA1AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:58:39 +0000 (UTC)
X-FDA: 84484041558.10.0F5AE36
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0116216000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:58:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VW1ydRJX;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772049517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyourlDdj2Tljzk6rLtG6gEQuh1sMzPbchn9jIwrybE=;
	b=S/0jSmqJXryxYPWfMcI3RgiML+ckZmss+/F7eUTugtTEcuJBX+Fefbtrg/sQz5gE6UwEJu
	ypnva96eHafYS7N8UbG8Tnjj+0kK3v1XX27/QBudPI/xfvkeIvWSE43OFd8f5kKhMWoP/g
	9I+x09dUYRcuBdWq5DwbVUzECni4614=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VW1ydRJX;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772049517; a=rsa-sha256;
	cv=pass;
	b=3WIugkEQrRwV4j2BBsjO+m4nVAuPWDapgxjrzOrP01SZ1KdYy/iiS69u0cLf7yodLs3vsX
	EWDECQeTFcuCie++z8Y61fLi1/lSW5qg1moUTCKjcIBY8KY4P/tgdpIqZszJsdqBDKbxdS
	7f6Q0mnt5DtxiYKVBA/v7Xd5azTtf8Q=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65bf302471dso160999a12.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:58:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772049515; cv=none;
        d=google.com; s=arc-20240605;
        b=doYfQi3yBYPjnN7e8ZCnhl8iyQCJb9TOTWeK2n2YgZc3Lv3jkdBexqrZe9pUSffZ+S
         BwSE1Du2BktyYp28NZGJkCQN7D/emYAg2miCaboOsBvQhinNNs0XZVKFtUV/6Yg9f21Y
         wZMCRPcsUhVL9lkja3YrWjVQAE7vme0e/wiy3R6fSpk51+78UJVs5a6g/I2qSbwQp3E1
         YHt5mqJXCyj9kAxABsMuT5Y1IR/LXPlJ8u+yO0BOlF8YFSDfrgsEN6MPTgaFsTgnKvHu
         n68G+hEtjGwsnMve6AJhAFvOIHMNVSa+8mW9dVlmBDgsu+4+y4iHVaqa+wodYqJs1nS8
         bN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GyourlDdj2Tljzk6rLtG6gEQuh1sMzPbchn9jIwrybE=;
        fh=Ugini5t922DObjyjDlT/R8t/KhuVvk4BMYvjsCHhJPs=;
        b=Tv3/tmg3FilPZsKea906P8/C5W8vH+7KTdGrj9RKgSsorUPnjhF7SDpp1fR17Nugz2
         WN2og6IuwyVW6y2K5uKiLWPj7HCS6nW40axPVO/GLw7GoBCWajGuFUyYgV5o3dVyZ7xy
         4icaNUDiURqVkUDaWW7xdmVOwURa4qwUw+pDHy4IWqhP5gWqrkGHd05NrZbPs9GCoNZS
         BI4iODBYfGl4kf1Xf0Uocicn+Zb7EcK5eZ9mICgbEk/lh3z2d4R+WuOcRyRlAxT+coQ9
         OYVlA0lXSaOu4m1VSKuIVZxOhT7PVJdJtVUZ+ivTV+Ub4UNHNcLNMT/CskEZPTa2DZrz
         +Ylw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049515; x=1772654315; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyourlDdj2Tljzk6rLtG6gEQuh1sMzPbchn9jIwrybE=;
        b=VW1ydRJX15ewQry67AXkuRc2P1FkfPF0Uw6i7YJuUaRcnG08I4OOp9DRGi7g5MH5Gj
         /KXeuIuDi6WqsueVZeoELsnDx2e9jN2QoouSw96Rr+8GRCKaP2djhjX/RycCyCf/RvNq
         0AI0f7qHTiESRstLpXiByaZap3QK+KNykgdBivqItVxjy9Gv4C2TI/4Tp9flBMh1tFm0
         t9H50N60S5A8qisb/l1oM7FEERdiNmC9Q4a71uDMhbARY6omin0btV0/i2q7dz8U4asA
         u89yNUB5wUrVml9+l1v7mHcG8TdXp4Myo6BpaibhaaUfmfDBKjf9rTsSmlJ4lD2g2kxF
         M0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049515; x=1772654315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GyourlDdj2Tljzk6rLtG6gEQuh1sMzPbchn9jIwrybE=;
        b=Ir4PTrwbXrfpt3x6m/L+XEBM0qK+oKkVeL2TeR9mMEizZBYuIoOQ8zZJj5PFibssaX
         0BK/j8Hxt4T2QItKvFsb2hqMZZUe/JFmJpH1KfxK23abfOBWtJ8+OjAswi0B7/1jmpUy
         NX8tME9D+7fyH02+27nSnc5ehCH4PO/WqhYNa62P0STctLXUhfVhlhvYOLQnur4nMd4J
         O4wvRy3tUfEdTD6gW6B82d7eogs4g2DPrzX5TchVH/GHN4SM/fyCUnjclUZHoBonDr11
         mdq4fqIpABbjEhrjkFS2ZakhIcOgbb1iRPvchwc4rqcmeSGuCddEjyGe1Rcyh4TUo2iR
         Y1Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWqE7ozI8EdruBTuNUTt4TaTKEuNIE3KsDTdnd3h0hhV4NJpLzaDJ4mf23Mp/8QsRNQqn3mB4/CsA==@kvack.org
X-Gm-Message-State: AOJu0YzdoPmr38H7bAXR82Zc03/RNzEESCv9QnqlLoijminRE7jOWbZH
	NkFZRoFO4qjq0fzI9qbez8EgUAVpnwh2wG4drUkEb/ct8eto14M7whL9e+3HsC+CL7OtcOcXUCw
	keAjFmGM9VNPdW4QBV2ZsLHtwlAPhPq5qgnzBOmwo
X-Gm-Gg: ATEYQzyQRYFs0fdZLBsGY95ANAUOQUG4f2a/RKqjiRx5XxOi2mt2w5lNL8nXmRmLEXf
	yL4QrAzOhDAsZ939DDfMpixHH3fWKoGGIwfiDGDOTHNSa1hpO9CPGtI3fXWnzHo9BfVCpP0FPYp
	oBn5K6YxOYokAW8k3gR0I+B2LudQWVrjt0lRujFEhaxX+ggppLnWMnyO5p8coB0rRRXzATczT9d
	1UixuK4uN31wM0NuY6DLS3+sd3OMilGz3KD94GJ0Zu2jSpONOuEwH+pXpE8md1EuGoiaUh5VntA
	2gYNF8Nh+loh3gnxUUs/jNpiqLNWyZrxKaWOT7keeSMbVcUIJBy9g+VuL5I+Kwx/BarNNg==
X-Received: by 2002:a17:906:209c:b0:b87:1590:d528 with SMTP id
 a640c23a62f3a-b9081b6d72cmr674923766b.40.1772049514649; Wed, 25 Feb 2026
 11:58:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com> <67a62716952c806c2a512e98bcac1f5224ada324.1770854662.git.ackerleytng@google.com>
In-Reply-To: <67a62716952c806c2a512e98bcac1f5224ada324.1770854662.git.ackerleytng@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Feb 2026 11:57:58 -0800
X-Gm-Features: AaiRm52wU6KkL251Z2G8sJq02VAiPYyNCCNpcDmsxM2CKPU8i6iZmZDmernmq44
Message-ID: <CADrL8HVSqhdUAQ=OPicZSPnaCXQMTweZ0rqvXp_86p_xnZ1Bbw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 3/7] mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	kalyazin@amazon.com, mhocko@kernel.org, michael.roth@amd.com, 
	muchun.song@linux.dev, osalvador@suse.de, pasha.tatashin@soleen.com, 
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
	seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
	vannapurve@google.com, yan.y.zhao@intel.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0116216000F
X-Stat-Signature: x8mwqju5cwr65hkfqj3z363ruowhocai
X-Rspam-User: 
X-HE-Tag: 1772049516-955846
X-HE-Meta: U2FsdGVkX1+OuS0hlDc1mG4QscKmCtsMOZF4p3QbgxZTqWiDCYj55G6YonYWe3R0BfbNrbST2u4CA4kgJy7n4ng5PmJ/jUSGbdbKKTw1dlfLdoiDqDv4scMPWMfcVQ2JR4wbNaXrKONcAiN5VBQhZV9XKBq5zBKVt9M8oL77dFeaaw01x+cqg33CFHaLQcDuos7hwHdtC2geDMMdx02Z8FA8WTEvWUEZnOBnK9y0Vyv85F60pA32g74sHZd7TTepE2tuAoWkSgppPcz+0+iRlLzHPWE4ClSecT7IAEO3Rh6ulbsk+NdXqGcalu8UlJqxr7suN5mG68b3ZrOS8d/Fq2QTzuwOq8T1KeUSqTe/tkAF7jtjfUsKPyIDHKhSx7IwByUHYs3sJLBjGa1eWsyRBaQlVSVCg7IN1bSyi2H+Ph6sxczKaBBC3xQi4Grh+UmTGYo2XIuWsKZwqoiLSMlU6NHJH7lQlXR0iw975YFnhHGvDozusRfpHAgyhwQg3pkHut+DNdYRhAAu0k2Ujf45afYsgE4XRNtpj6ep+EJCRJH3q2YepGJ5xV5o4LdrY/Cv2O7EcrX2aRLVpN5HkrgdRT0/goF+u+Pjp12+YCYEtg0CBplAHmPEM4afJP8AqW1LYpfk3FtQWqXY19OfSf0RTM/k0KXPPSXq/x+wrYn+Xm+2fBCbCcDPR1uoEnfBNHUI2eVl6yVx9rOZTGob9/GdXurDCfVCx+BFD1rGGa3ZO4srfRFEoQbOOuc7jf2S7hhhqnbtw7P3SbP9pawEjuP5lKdzNW8N3+10dWhx30tRKqFxWZsPD7YHj+noN+i2cqxO26uqvo+TerA9M49fERFioEyssurDNFjXEa4PWZN2KGwn0VdN6XfIZap73TZAnbQHpVVl4LniL8T9M2xCMlE54+Zrhh1T/wr9AoW73Wpnml58L6etXc4EVJK4W6Y1sbLqJCH8juc7jiB8l+3Ghod
 P47P2BtS
 zbwnU1glqfA2sds4Fj2+yqtR9dpfcp01Ipdu6+o+XR5xSrKkq0jcapWeHukpRKP1XTGAs033uoJyXQVkZ9pkVv+OFker61nUkh4Vp2p4gI6WQljFws5q/KE5yph6e7dIRGzlu5HaUTawvGFxM+9HEliLJzNW1QjqqbctltoEmVewoSicl7/eAfkoC8mi0fApTkGsOvdMBzcqBKlKxVT861y9EMPtTztLSMGPHlJ/RSuIDqXlon0XbJVMvML25AUyrp/j7q0JIgQ8E8UjwS5dHeG50KyoM1x1AWAZIV5HetGv24Ac/hWsyPPH+bF7KeinCqHrTmMfUHX6OV8FHsMKBIcEmY22r+lU6KTKEf0DXPILaJlWpnEjjpENkK0+lzflie7/ec7aR+Dm2FFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 4:37=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Move memory policy interpretation out of dequeue_hugetlb_folio_vma() and
> into alloc_hugetlb_folio() to separate reading and interpretation of memo=
ry
> policy from actual allocation.
>
> Also rename dequeue_hugetlb_folio_vma() to
> dequeue_hugetlb_folio_with_mpol() to remove association with vma and to
> align with alloc_buddy_hugetlb_folio_with_mpol().
>
> This will later allow memory policy to be interpreted outside of the
> process of allocating a hugetlb folio entirely. This opens doors for othe=
r
> callers of the HugeTLB folio allocation function, such as guest_memfd,
> where memory may not always be mapped and hence may not have an associate=
d
> vma.
>
> No functional change intended.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: James Houghton <jthoughton@google.com>

