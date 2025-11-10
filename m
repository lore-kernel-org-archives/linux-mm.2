Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B48CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCC18E0030; Mon, 10 Nov 2025 12:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094758E0003; Mon, 10 Nov 2025 12:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECA28E0030; Mon, 10 Nov 2025 12:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB80C8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:33:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AFE1140226
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:33:01 +0000 (UTC)
X-FDA: 84095392962.24.FA23037
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC8E312000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:32:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HNN8nRgt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762795979; a=rsa-sha256;
	cv=none;
	b=tOxE3HXUcPbYPPu9ZfZk9ZkQ0xYWPRpu1Auawr3qyVR2gqnh3MbUgLS3uJ4uApldhLu5nV
	b/MkgdpF7BiHL4HKqNJWQLc/FsNmzbWP1nNke1pwLKXkXBXe2OF/BPB9t+pDRMgcswu17t
	vTySid6HRzOOLEAeJOd+8hyGnjgU9vs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HNN8nRgt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762795979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auNNYNeszcnW8UxlPsUXlu6HqCk9VFPDDrt3cDy7QDk=;
	b=2/rwGAONPC6Ku45iFgzcFcBHaufTTUiUGOjg5I2pomqzPpws/6YOuurMjTg8pkJLw9NeII
	PUsUbjocRWSnBnxqi8di2wRbq7qcDsbfKnrZJrEdJAbQeuXi7SojXqZgeX8mMgGp2j+/Om
	OO8myzGNDp3nXNICsEccXJVnQ2i3s5Q=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88249766055so20047506d6.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762795979; x=1763400779; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auNNYNeszcnW8UxlPsUXlu6HqCk9VFPDDrt3cDy7QDk=;
        b=HNN8nRgtFKrGo2Iz6YGNmoDvbGprJdgsHZ5ceAOSXAqMikUlPZ3iu4CKiyf3SYjG7X
         u4DyrR0+XUUUX6L4XNTpgosIKhrbRrxiGW4ll0Gi9ocOG7u9Su/6inznqkTYdRStpLMB
         2tEiUcrC/ERYz9PMhN3WPMTpb4oHSJ5CRfOzux7i9ZuK3bBFSd4Kmp0yBvMtwHW9ttJ2
         q57GKzPejwAUZqBjjbZ1laY7pzRhigNWgjweaaB9lXkYLYQT9a4OtqniMHQYVfzywuSv
         AxIrFSkhSgtFvC0TrNVMVHd6LAK25lfWOmN4jDZHjYelOVt0gldlIosJEz+Sut8YQ3Mu
         yzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762795979; x=1763400779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=auNNYNeszcnW8UxlPsUXlu6HqCk9VFPDDrt3cDy7QDk=;
        b=avnZC/NLiONN4HwGsiTtVkhbVEodBm7ZHgtSAU5QUTWVbD70d5qCvlXn6n3zHZr0lN
         EWyWuS25PhGs99IZ267r8yK+4QzNt4WcOUs4qhFzMBcbKAVfBYM49WfJ0gKidkPSqld3
         +CL3O7Dd0+ZLgNJ1sO9CQiya6w4d0MaHsfJsY11uICR83vBNUQeukgtHuJOGeG0DSfp7
         R+mmfmM2TW1PJQq/46kDPn+rxAUyixQCnPzkhymXM4kyG4khMD9LRX9vMaWOlOUWQ+ci
         bWELv34EUugrft5Ngjio6zcB9qK7l8PcPbMgquyowieL9jaAU0ozCisSSDqVV4pPQoYT
         6zsw==
X-Forwarded-Encrypted: i=1; AJvYcCU9dktu9P1i/C7Qn4OfC5krhFw3XnTvmdYNBzSFKP1wqpx8JfgfxhVpUYVhF/RRua4SR5E6K9gwBw==@kvack.org
X-Gm-Message-State: AOJu0Yzbo+8hx2Kl3jfBq2Z0i8slPhR62Bw/qEUsfWbUIyYSfgvTXNg9
	hGS2/TJHk0SdH52JzxshQulDeSN7CK3vERILgeGtf4vDY1XZqfcGc9xgZ9TdzuvbB4PtzMjVi+5
	rxQo/0D0Qy4bF1rABg+8mxuPGUPzH6Tf64XOp4/+N
X-Gm-Gg: ASbGnctgPrHQaNopcpp/+iWm4oVQ6tgZJRuyVL594pSLOuDf3N8sJL/G3F9LhAXvKMR
	isuBTjUwOm/JTD9BLrtQZ5G+QKOXOQgPXmvXkfhABKOhUrvsg6tid3P+mzi1vnasRJ/CahvKFew
	bWMSTkuHL2HFWm+9PYlz9tIh5zDUE6LJUeQH0nas47+tZu+/6b2qWaCYBFhjJGYAsKuOonXh3WR
	CUKrr380kr5X+ae3/iibtefj949qkX55azP8fSaiIoZ3oNKBGDUUPlXbAim7Shh5Qb6/edsf0tB
	cA4YDcS06EdetZ8=
X-Google-Smtp-Source: AGHT+IHeuRC7ChrdFjjxvcWC3ajdMKHJ+Azj7LDyTH5BCluSFj1o6p4ZSWP6EGrRrokOPiEV3z2rvlDUhI4wexrXKNM=
X-Received: by 2002:a0c:e00a:0:b0:882:4660:3724 with SMTP id
 6a1803df08f44-88246605291mr69808466d6.63.1762795978283; Mon, 10 Nov 2025
 09:32:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <fbce40a59b0a22a5735cb6e9b95c5a45a34b23cb.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <fbce40a59b0a22a5735cb6e9b95c5a45a34b23cb.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 10 Nov 2025 18:32:21 +0100
X-Gm-Features: AWmQ_bmUvxxbg_c-XB1Dy80QL57feg4coPRIZHNTl9ervff8Rzi8S1pGrWY59Fo
Message-ID: <CAG_fn=Wj9rB0jHKT3QKjZsPYce1JFcb1e72QBOBP52Ybs3_qgQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/18] kasan: Unpoison pcpu chunks with base address tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org, stable@vger.kernel.org, 
	Baoquan He <bhe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC8E312000F
X-Stat-Signature: juhoauq9whg5zneza1ixfyurfyc651pw
X-HE-Tag: 1762795979-967489
X-HE-Meta: U2FsdGVkX1/0HsrlZcwDhGxqIna5B2Z+ZyKggYSZNl71+2IXBkI6QQdG5iTyBSrbYFiOJr04sq36/iP4KKa2524OPvN0XlWjY4yeJrnq+2vBy7U1gwJYr58dijS/9+dqNPHENxcoSwEw1vbOU2w31YqjJwpgzXCgb9jJ4qK1hyo6+L1c3TdJrv8ZDT7NI5yNnnmMMjx/K8yTNJyzLe4lfTXI1JlYZjifgaD75ZnjAwz//uAHb+CQbIbLQbKRdBovh7YYs4cBZJwUYs2JbjdJhJQCqGbxZPfJcK1HWy4fYTc8BjKUumqK2KTRyWe7oUlnbvq6BhEy73w+PLqUlA991rZQKj9xEdvKFgb/oxKLPP/OdH6lVvbasUswxYBA8qdzojQYXc++khg69scIB0IOI8HVjxe47SlH98ExrOysVOH1rJoI6TSpDuvNYkB4ZmbZr4INv72CYJOOL1j1rzSgPXb3Z9oFEemEomtM4qQ2YFS0C2zVn0620c/Valf3HMRw3vvwAVXftUdMjHCkhHLskWrEtF+5hP3yo3PllbjvPxN1Jv99xwT4kBVVTQoe5c0umoMfBtZl8PmTf4ZCt7KXkVz3DLAsZmG1VIj+qVpDzMefXMLc4oivr5xn/GiEE3wydBY7e4q7m/DqRVtmGC9fc9iWdBtSYj/cH6T8y8im0DwpJALv4/3FHUpcy0mgNBNULeqr72hvqJXCedPQ4Goi17VSLfra4RVJRikjc7oI1vtoCDjeeSWL/X8cJXCAJ1hMcxSo3Xzu9+PcN23FthhzxtY1LK4f9HOqE9V2F7/oCnqGv4Yv3/NuMLpcY3vMA0K+eP+5vSLhXcGtHB0CnEpvXBnRI0u7mb8Oy6woCnxgXZeLOFJJG9Fsjqx6Y0T/CihLnCQnko2ltm/uYUAWiL4lc4sT3WYSr9cBzWxLNzbppBVNM6ncCR0geJ81JZLl/rnum9BoiItNzutPPzzTAUb
 oyYJCbLB
 wvAc9TLCKZTsdafarS39oAOstJZERXdP40Mxmz6qCbgIQLbzY9yHEvJ09AF/2wtvGJKhy8GZ1ujsKwxYDIuK+0s8mIKa2ncBz1HaPbD/xukDTAv8elDhy3pJX1exzQOQIL2nxoLVcxiSifOq10M6j+A1KuFwrhQJM7E7ZQEsAV+uWYYrZScYPy4P1F/rH1Q1syfPOVEyifrQhbqba7KbIVa7aH+43jj198mWzuAG0a+xugCgr+q3IChCXL7vvbt6vQpNvDdyNAsbiuZqn19XW6zUkMLP9cvHon5mT9v4VBIzorjAaRQQ5TDFBYiyzY9ERgF6+WKMwRGG1zBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 8:05=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> The problem presented here is related to NUMA systems and tag-based
> KASAN modes - software and hardware ones. It can be explained in the
> following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Refactor code by moving it into a helper in preparation for the actual
> fix.

The code in the helper function:

> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +       int area;
> +
> +       for (area =3D 0 ; area < nr_vms ; area++) {
> +               kasan_poison(vms[area]->addr, vms[area]->size,
> +                            arch_kasan_get_tag(vms[area]->addr), false);
> +       }
> +}

is different from what was originally called:

> -       for (area =3D 0; area < nr_vms; area++)
> -               vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->add=
r,
> -                               vms[area]->size, KASAN_VMALLOC_PROT_NORMA=
L);
> +       kasan_unpoison_vmap_areas(vms, nr_vms);

, so the patch description is a bit misleading.

Please also ensure you fix the errors reported by kbuild test robot.

