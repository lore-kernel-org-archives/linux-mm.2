Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D14CD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 03:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E855D6B008A; Wed,  6 May 2026 23:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E296C6B008C; Wed,  6 May 2026 23:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7CC6B0092; Wed,  6 May 2026 23:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD3A56B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 23:35:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BB6414039B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:35:24 +0000 (UTC)
X-FDA: 84739208568.10.7C3FB03
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 668A340005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:35:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MtsZ17l/";
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778124922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsoDCCOTvCGKVlqoF36XX5WM89UtK6Mekm3tMCaOG0Y=;
	b=P4n+DxY+NiLovzoh/2PHHDaXaOfzFWoFher/4XF1m0gyM00RKhgB6IjCYnGFKG6Eb2KguX
	XqCHaP3JJTMAWAD5P8memYrRDn8tkmrsn0Vlyc7xE63+3I1f3oGAYqgMSLOMaD6bd2yId0
	Bz4O7GHGg5IKASEBCX7c4vOxxk+3Dlk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MtsZ17l/";
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778124922; a=rsa-sha256;
	cv=pass;
	b=hPvOFp4ywjSqVzkjQFCt9xdOYrKRjeiA+5zyMbJFxIegqNKPWB4DUwWaT7XnToVgEgQJyo
	inyxdmOanUlcyBg3bLdoXjS5Qc07X6idVaPBmP+tNhoAGgqIj6g63Jp0KYZVk1s1r24SnW
	noyowzz7neJfxGeTsPaJXg6fYmzz4Z4=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7bd5dde63dbso2758797b3.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 20:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778124921; cv=none;
        d=google.com; s=arc-20240605;
        b=eVaVgB19a9mjvODjslD5302jaPnyTmDeejQu7IRMtbjX65j4ImVfFvWsAPJs8tLl1A
         xKUr9XclqUu5imfOyo678HqPC7lmGSCgi16CIQU9kGf8AsyyH4oxZCQekClvjPbQpwZg
         rJ+hRNgqZxYSenBICzwXErpKCD7/cIZZcI/vf1qF6mcMceBLAC4lzcZisLzMrPiFTAnf
         jDboRdrk152jyqhclqbb54v4MIbhVWRa1jZxeO6TLbzIQW4jJBE8QrrL54m2J87C9vtw
         0C96puEaMQq9KRl1GMty/qPgMZnblBtkOUBsPyWHWwgWZ7a4dr6n2pM4b9RZwbm9XCcz
         VejQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WsoDCCOTvCGKVlqoF36XX5WM89UtK6Mekm3tMCaOG0Y=;
        fh=7WIhdVv1I6MR3BxnkZFsgHMEBOJ1ZmtELLdgkgLw9W0=;
        b=jqilAX9WtGtuImkN5+jWoQir3a8YgSqHa8iuG7CLJNwjrjZ81eMbuKxHpWYRm6dUGt
         WPJIxzQsVut3RoStzr3YtIbc2sh6S7gKFBaG57rKYjDSpF8P1B9kbyxGpOcSxBA/QJ5O
         6yLDFZycu0+aJeZchoJ68Jhr3yy1wDWzLrzEa1B7G1i+V3/VD5Ukh+uEvElPKPJrgxQa
         GuJnrRI1WcvjCdBf5W642nl3gfxu/ckcDxOdJlpg5qHs4ZXU8ZuaMugMStt4b9aEjros
         nT4PJ92VN5pGnadoTRYVrZvkk/doStMju+rAdnAWzXn0SAiJluOLrcVUVH72hOmgJrAa
         hVPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778124921; x=1778729721; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsoDCCOTvCGKVlqoF36XX5WM89UtK6Mekm3tMCaOG0Y=;
        b=MtsZ17l/NdN5d/1OLIb6SsJfGiCL6feptm1doRWzndqtHiXrhSEtpGhkZcEZY/uYa1
         NkKok0yp40csC23hLndhSoBS1aI8GvedIDJEdcrDTrJWrt3urGpfaXx4YKMbsfAFgq7p
         y7+4TKJWwtrKvC2/krJ68Io1LsDQs0Z+y5AiczHJJ7CW28dAX8iArinZBgYkAQDW7r/+
         O4jn+uvQsHr88MVnnO6PXqybEwiF6wvME+JbMaLCRe59C9lJbQw0JiFNHy4h8VeA88GZ
         tZQ8nQyFkcUhE6/LVe5h0MVLjxP/xaderWAjxAm9LyZEB9g9ysz8x6D5wFgZg2D4xR2b
         FO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778124921; x=1778729721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WsoDCCOTvCGKVlqoF36XX5WM89UtK6Mekm3tMCaOG0Y=;
        b=XYC7leoGveKY5aqQ/TG5rwcxEVrZoz7S5Q20nnGj1r+qWRxPdzVfaLmXjaIIJVVpY3
         EY1K2C8+heh7D3g+diJoA3Xkjx0Zrb67O7rjLQQn12j5qEM2LLR6tDzly1zYmEhos/Hz
         ShuM3ypDm6VgN6aSAeh2HnmoEaIcIumJUL66OzTSt/KW/lUMNBinV7USbEYF2sRnbEWH
         Vn3b8uYiZkSob3B1+vuiFwqlWWMJlu7k//fa2N2xPAt2zkI0u5kIARkCcynsbeYvzSr/
         /W3PIb7w1viKXMQdCsisjige6VXKHWkzwm3A0D4Pdasvxc0N71WzKOyuaqfJMEwZA7o6
         bTNg==
X-Forwarded-Encrypted: i=1; AFNElJ92UZI28KA5oDP/e5nzA2uT6PoD2K4lgQfiY9WmTypi3glUxF423GGCOZUMNt58tClhRkAyeckLkQ==@kvack.org
X-Gm-Message-State: AOJu0YypLqjISD4lFu5DSCcLgQu2QJGV4QWRTqKeL3mLjnUBuRl7Eyhz
	mJrmByYz79HSsG/caOn8eMLi4pkdE9lAvH8FEI4TES7BwPaM10XSmbNBm3P+5UubO4X9miJX7QR
	ZxDLjzPhIHEqDR+YzfuXDrLUp3t5/UiM=
X-Gm-Gg: AeBDievR7uQsVzhi+rkmkeib3mY9/EXhR2EZ3eOpeYCtj6RWdAx86JHxwqfVpNN9rz8
	TzbyV/GgWVfYQF89O56cUvq5vsnZHY4WckiVfNKyxxck0p7OB/8rxE8eSvfqcPAUtMRQcF8ng1h
	02lk70uOpXYo3ocvfelSN5v4Mqtusy7NYXUPR5rY7paemhP/SDp8DzQTpWm335B4CIHZEgvfl4/
	BEen2czIlfgb/rzFLHDrr3Vp4tVjCTzJYbepxBJtD7WS04SakvTs4n12l1Gat/lZNfKtNmbFHrk
	N8e6q9NDLBrmiAfFDSzvvkVR8zFbH2Rd/QiFhPCmLxifasmENvw=
X-Received: by 2002:a05:690c:360a:b0:7ba:ee75:f115 with SMTP id
 00721157ae682-7bdf5d8d6eamr75144787b3.4.1778124921401; Wed, 06 May 2026
 20:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-1-vernon2gm@gmail.com>
In-Reply-To: <20260503165024.1526680-1-vernon2gm@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 7 May 2026 11:34:45 +0800
X-Gm-Features: AVHnY4LDeDA3KXnwe-H_2b98P4hejFpflhbuT3yJizJRa8ybxM-qzZLe9Z0VQ9o
Message-ID: <CALOAHbBx6GuZjj9_EdrAPCsiLJekAiqOVsWQ0muNJh18Nxaqtg@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP
 more transparent
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 668A340005
X-Stat-Signature: 9fqjuhifpeisdttjtjo6prp9dbiest8t
X-HE-Tag: 1778124922-843874
X-HE-Meta: U2FsdGVkX1/FvLCTD3KSL5Z0nivwdAouF8lP2GtiCdcct/F2TDqLoB3S2mVIdamNt3g6/BkdFNGR1jGwHr2ZNLk4DHO4UJEgSQJ82IyRJGxzCBnyqy5kbZoTukEefPgHxXNCsPfAsBCXbLKbAWKZHpTOdk3ZUxKE/7pmRiWkica4fS2mk4QrGybavTlSNeQLrNA73nCYDjb7edq6c62V+UszG7V5vUjCmOP+cXW/an0uUYhzV1NETY0worml9k2D6Hwppn+1g9AAw/pUTQylwNtu/oM8qVb6UNGQG+0qJ7gWvZQYI1gF0n/Vl6J56qLtLJCM0xY0bFQ5hA5lsrG3teyuccPR3eMWeFBllsTiHRuknMCwHh4KIGwvM0ZiFgPlvWOFWyArdjdW9z72BtKDK0hlqcMa//QTUaAcdvjsK+K5B+jai+GQcuaGZWAeutVhBq26C2GwJ1ef7MdDXX0jRjHx/G/9oydzEvaT+aTGRTebWL5iHsuR0d1i4WBVDWcwXOW08D5C7fiQYbYgPBAb5XnG9tMHSJOVGnvFtHwc/y8YywAlL/cM6ERslJR4AQlC2DFhSOSno5/FB8FGyGXADNQRxxPihpuIgqfx9LJJbu9QLPTCy1aQfQsbzCKungwB8LhqUJ1pmhFtBG5lkSyQahlBchtnchAKGppXuHAwYXP9VN+ITMTUaJPqNRSiN4fJ4VMJpmeJUJWV/fOvLDuYl/1l/1AT7VJQK2oK7Lol258yEfP6drp5Nba2/49wyHNcSh6F+vncVODS9Zk4bFxKqemAy6UJY5kl1ODmMafrlUqKzzPrNHmCOvWp+xmQpVjq1VFBgJR049rP+1mgC4rX2GLJF03BBQA/KIoZS+e8NpPf45ccCDcd6gyCeN0yUtNi6m/7J7DUTnWLWDm439NuDBXFQzVvj5zfn1WG2ls8SACQ2zXgrMHG64WINJPi9DE6r0mY7zaOR4Pstk1bf6+
 zixa5xBE
 dUdxT6mVZY6quS6A/6+gyGfur0XHHGFb8+YI/y1R4f6qBaSjbuy9b5ilh4cmkbhM2dniCN9814JlufmQpJfOjYyigZC+mH6ejnE3MAmN0f+Rw8oFAWjd1nl3rLmCZ9rUoGRybTZTLhjaA4+zFa1NhX2lr3y49sJOBe4dWH+62Oopk55HE4L2+EFDWNmkZotT4E2TYvfajsqhN5P4bW8U4ADq/7rB1y1gQ5mXR5bjUskWQcmYH0ok8enyi5Qto+RzU4Ay0qFaC7GONzhXikufVwQ2Tys6ybPQMvfwjv6wuytW+9exl7qgJyFY8lsOtGdmQFPpORckiFjqqV8pUwiDyMgY09XeScg3HUBcUDN6wMaj3CZeX+VgSlV98sBXW2ZocK6H46d80RQ9Z+4bwY0GzVghb7WGCYubRxDZdjjCFmmuqV/cGEBnpkqI+oKjdoHShxfzvouWiZ/+JMlcQvXVN9MXm2mqoWv6Hkpnu8bd4R7XoANfDZ3dwnxZfDV63qWFGl3V60uC65flqFyf3P6c/C1TGoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 12:52=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Hi all,
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> As is well known, a system can simultaneously run multiple different
> scenarios. However, THP is not beneficial in every scenario =E2=80=94 it =
is only
> most suitable for memory-intensive applications that are not sensitive
> to tail latency. For example, Redis, which is sensitive to tail latency,
> is not suitable for THP. But in practice, due to Redis issues, the
> entire THP functionality is often turned off, preventing other scenarios
> from benefiting from it.
>
> There are also some embedded scenarios (e.g. Android) that directly use
> 2MB THP, where the granularity is too large. Therefore, we introduced
> mTHP in v6.8, which supports multiple-size THP. In practice, however, we
> still globally fix a single mTHP size and are unable to automatically
> select different mTHP sizes based on different scenarios.
>
> After testing, it was found that
>
> - When the system has a lot of free memory, it is normal for Redis to
>   use mTHP. performance degradation in Redis only occurs when the system
>   is under high memory pressure.
> - Additionally, when a large number of small-memory processes use mTHP,
>   memory waste is prone to occur, and performance degradation may also
>   happen during fast memory allocation/release.
>
> Previously, "Cgroup-based THP control"[1] was proposed, but it had the
> following issues.
>
> - It breaks the cgroup hierarchy property.
> - Add new THP knobs, making sysadmin's job more complex
>
> Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
> following issues.
>
> - It didn't address the issue on the per-process mode.
> - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
>   the same objective, there is no need to add two mechanisms for the
>   same purpose.
> - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once

Hello,

The primary hurdles preventing BPF-THP from being upstreamed are:

- Uncertainty regarding the stable API

  It remains unclear whether the following API is sufficient for
  BPF-THP requirements:

  unsigned long
  bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
                                            unsigned long orders)
  {
      return orders;
  }

- Ongoing integration of cgroups and struct-ops

  Work is still in progress to integrate cgroup support with
struct_ops (see also
https://lore.kernel.org/linux-mm/87cy439x8a.fsf@linux.dev/).
We should wait for this infrastructure to land before introducing
new cgroup-based struct_ops.

>   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dying
>   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
>   implementation.
> - The test cases are too simplistic, lacking eBPF cases similar to real
>   workloads such as sched_ext.
>
> If I miss some thing, please let me know. Thanks!

BTW, it would be better to include the original authors in the CC
list, especially since their work is cited in your commit message. ;)

--
Regards

Yafang

