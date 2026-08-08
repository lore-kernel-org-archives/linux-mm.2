Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EE4C5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 18:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97816B00D0; Sat,  8 Aug 2026 14:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58236B00D1; Sat,  8 Aug 2026 14:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E4A6B00D2; Sat,  8 Aug 2026 14:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8853E6B00D0
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 14:15:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D8DEA03BD
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:15:30 +0000 (UTC)
X-FDA: 85078904820.08.7D48341
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2635740008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:15:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MRa0pQvJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786212928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+wJ8bVcUJEbsMrEGmkSWgGwBt2Gl8OH9WwW3mg1/w8=;
	b=0yHQ6uU5J8j7qGOJdmJJLYFp17nfVymxixtP4LmOhJS62MbXXR+P7qK5q9chAJ9Rd5YmM0
	TOlVSLq3+IL7n69zIZEWwHpu90u9w1q3/e9s4gldE2UUWthZD+giLiNrDmOj1viWUqliqD
	mu42EtbLIwBb7YyGwCEv8YB+5d4/tp4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MRa0pQvJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786212928;
	b=8XGJ2VzMZiY9FV2sgHpTED/mJIQOdcIlc40v/AAbjFq07hKrtGuTwSQbwn75vRYIu9Viey
	eFLFNe/ddotrqx32QUgAo5xKJtLUxwKXUvikMAn7Dou4mJJB6w9+UFFdsyUwwxMgXa6r8u
	XCOUlESlaDjTCFOYPgy81lzeXvFfvvg=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2074710751so75248166b.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 11:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786212927; cv=none;
        d=google.com; s=arc-20260327;
        b=aSInSmFh3eOHs3JqMIrTu9b6rofy54AgUHXmEUmDV9VuQ5Q1B+FgtCUOygpm9wNDfK
         jKl14Y9k2XWNh63nmtHuT9JoqX+U9NIHQ+zubu/s2lAveuogICeQeT1aFZieMDg40b0x
         ExBpNWyLdJyGqiU1Fpqw2mPs47fkORMnpWZQAiVgjaVTH8v20hgbr8xrrNOwy1oGHmKX
         QDhOVPxP2AJhL/HVmx+acZyJyedYMvbhpHzdHpCuqxtA1Cm3nk8eBPCZ3hAq3KTLbDOY
         z5R1mc9edntdVgk89Sw4pqeKHbnN0IpUHkC5xLdlNyYDNw8TWYhiBd8N2E1mnKT+2z5s
         W+lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A+wJ8bVcUJEbsMrEGmkSWgGwBt2Gl8OH9WwW3mg1/w8=;
        fh=3eK/jkbZOoHc15VoUJwOGUryFf50diLm6hH5FkYkqeM=;
        b=EXU1422UOeoejXHNdQKWvNuUg6jlWFe5ec7htavzocRnnA4ykLFe/Vh9wdHBrfAf0D
         gkvQFzKsnMTDp0LoHJUuXuTyTJTlnpXQDk6LWAE6mDDqiq/Opyo4ZEVB0nLRCqzjyjpU
         WPC74EiaYDl0KdmQ5I2qOhSKPOUo/O/wXZxSsTvrCI8g3kI/wWaaCznnJ9bsiuoqT20r
         TC/3pE2MQpTbr88K6PIINjCUpuMgMbuuyKICvu1ScNItPY+ZVrdFr3+K51kIKKWINno9
         1D8vd9Pa31/ARt6cUtrUk7zPLD1IBobNB+05RQM4rTbroHNhfZq+glzgNDKS2ZcPRvLY
         ZXaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786212927; x=1786817727; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A+wJ8bVcUJEbsMrEGmkSWgGwBt2Gl8OH9WwW3mg1/w8=;
        b=MRa0pQvJD3BakyFlm21QsARn3kfsfBONwuIF+ufHJbmyLoylR2ypnhrQflCQdH/7oS
         BURWZn3GcUt04zLoSsEh41O3SX2xFlfQiXj7bgawYigg3L6F0i67/hul42EiL9OyIQH5
         1UGvQsxXM6iiqpLDvSug/TmfvWrt/RRo6DNoM5ne6AH9wNBILpeqSyF270oazNABpHos
         4/3d+2/qN/wCgPxtrzZNQ05Pb2UVqr8ligso1IfBr3OX4zBNpzxCxOfDsiKAkcDfW1nN
         eqCBH1u0RGPe83Fy87r+pLLq6UY8mZ/T3VqkKLT+IyCCeU2rOV924bkzLKEI1e8HI7I0
         vGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786212927; x=1786817727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A+wJ8bVcUJEbsMrEGmkSWgGwBt2Gl8OH9WwW3mg1/w8=;
        b=X7g+Y8qZCIkiFVbOSGshjggducCzeAoOcfEiNPSiKuwokm2JPgnwdRo+MB+kTbgHcG
         G083EXUz9iC/2i8ZEQJIvratP2D1MteohU+HayYIcgkzwuZIIQz+JXtNm1FuB+TZ1YUy
         SFJx6AaXz4hjzlj3TvOkat1fvlkSvFSowGzfLbNc1LT8LqxDqHgxiLgL5/heHA8gduRa
         wA4W/0LqkXk7e36d/+d902WWogY4jhQ0z79+NJ1tXdV/iqyxOCzUJAL+p47ABJ5RB2iu
         qbgDylp/bkB9bzmac3FXwztU4Wc4GKbqurxdJkqICi+Zft7vTJnsPkUIDIu3r5HXo1q+
         a+4Q==
X-Gm-Message-State: AOJu0Yz59Vl/xWQX+YSYTslv/IuyQ6wDl4ZYczyyi4hAd7hK1ARbzBCu
	hN+a9ddf2DAXikDcQ57m1U4Q2fZ+jp3B+LaYl7i4RT8/GDmYKdrHDop+7bl4HDc5Ll3ckgGZVT2
	1zbrWptkwuiztC5cr4KtnFQDFuskMBHs=
X-Gm-Gg: AR+sD10dlEruSr9e9PFKPAHkOc9+UymZyRNhWcvM/UJxwrznhlrJNG19ElvLoN7seta
	iyGkypGdwYuuceVyVT4BKTqak4wuU1MPyE9ccuaJdGHH/YikSUC0jket8FKaK6EeFvvtX9ZI7JJ
	eDZz7Y6I+7WkJM2FWMq0iLy7cKxLnz1O6yas+zB1uQBDCtC/NIYegbUO9itOaQdjNINB9e3OD2D
	m8y4H6Msddp5KLQIyAm/GfOLWLtBT04fq+7S0KTD3Q561JSrJ7SLLS3XNYCdv7B2qT5H5V+8jLu
	B1bx+I6AaqJoe4DdWE7ecNXPwkWq0BmTUpo3k1CTP5ppcU1wnSdohgSX6VjTrmy1t66oxfC/CGv
	fug==
X-Received: by 2002:a17:907:3e08:b0:c1c:3b06:ed03 with SMTP id
 a640c23a62f3a-c2039c74c1amr1657059566b.23.1786212926301; Sat, 08 Aug 2026
 11:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-2-689939a7ccc3@tencent.com> <DKJRCHRR9H73.X5JV4PU1MF7X@nvidia.com>
In-Reply-To: <DKJRCHRR9H73.X5JV4PU1MF7X@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 9 Aug 2026 02:14:49 +0800
X-Gm-Features: AUfX_mzw_R6CRhSXmsDjFbidF02FRs-ke190XFHf5m35DJP8clSzr1RCPLisxfY
Message-ID: <CAMgjq7AWE0nvoSqBvyU3id9BxLb1NRXcyPV_0yV6t_OTZ04V4g@mail.gmail.com>
Subject: Re: [PATCH RFC 02/13] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: peunmmggk6gps16h3t3ubbnp8b3yqgx8
X-Rspamd-Queue-Id: 2635740008
X-HE-Tag: 1786212928-397976
X-HE-Meta: U2FsdGVkX18hv+6JrNWh7elzDaUcEvRGm4+pIJ0xQRQgAzKlDFbQx38JRGiKJ+kHwt4g6Hmv6K8P1GSWsBDqCn6iy+IyhNSOqmUyWQBuVPFTO+AN+sWukv6EOUYZndLIZ4FH5lLOlQJCvLb4AxDojltNlYRvomDiWEXQ2KrqOf94GiqTs9ez8V1/JmuZfLLuxK6STlH/Jogwyu88KIq7q01UMLSlmKvZubiJ9VC70sWnosceus+VYlGHop9uHR/fvpMJCkwpjhjX1ZGajvQwMKf0ExnIPfMG94PswTBiyE9B6Jwt44E3YZjkZ8WDYh2/J/ecgx8lqYvC8/xV5Lr6+ngIywiy207SOEopCBqI3ACU/nX7zc0OD9kgd8A8bBAy/n4cRlxxiIUR49Dg+IAWVhyFjwYfIv7OiC8YZVWfu27Npr/NQNTvb+6P3gprNjim3U/EF0px/qDJ8R5ydN7eqV0uiAo6dO7OOW0zU8ySJlx519N3utavUwMqSc6PeHqG5MZcjF+WSrlqye5ozzYXhYSBYmotILJM0l3yf/oVLc/intxQRdq5KXH/BDRsA0GLzwjY0NBJMTNAHWoovtPjjWMJMeZVdV2VGzfwq9yRLg+v4e7NBLwiABfPmMGCOICouq35cMexFAVxiC3Vw/xy6F7KQBqVal7Ec77eRAAgd/TvYAaSFeyJZbuvTHg4GZ4YQdni73n0eUo1Gwy56uwULWudqQhyMQmT+jQ0BGBpL/Xx4/157wjKfJ14r7o17fFKtmIJM7CNnrU93ACxnTgi5DIOGBV4fPt4gTRayjsnqvggMpvdFdHYwB2uUHr+fiG2xhLJeb4CoZ5PtT69pf+8Nws/MYUI2EOobfuffpAFka0tJ70fYWjDFeixmrGUcKJua0S/09dj5f3e3Rx27bUDK03/jhYs/Xf8EifOt9U3c2LWFyh4uydHVPUQyROzG2tJ3lBjQksIE5aSbq3tukL
 tZaxq6Vx
 up6y9JnH3qeXtqW6nXOSCtkKIxTLw7RKqEYlD2yOezsnp8MCAYJoZRKh5YELZKu2pmDTgLM96JXwNmue7URuGg/mZxLJp9EGoI9wBRPNUjZhbiY+q5PE23COENYxr8ib9mXoFu0Fy1ahkRb+QkXspBMqQ/SYMVJr7skLkHmeAsnDT/cGwu7vnjVsIodMkA7/GbOWqv5hPQpeJHmqT5vVE0h7DwerQR4wD3qqygYw9qBRowNxn5NSLOeTAmGvgwovaut0erCAiM8qn4CMA+hK1ZF+GER/1nf/yfe5XJjXB5Q+qQIsu4PXFh7kvoN6jWUVhuQ8jS08Mo/D5MKC9CmHqfzWsZMdpuUfajAMtE2nHsQoiJ4lLdF08UhD6RyitgeKVHkGuK8CNK6XAQ1oQb/7eQSG+oBQuWw49P4dVdVM/W4WyPFGv98r7y3Fsvj8fy9vMtgHgwZAf/9/aBoIf76NxUlJdPyRqafraCjTazZsMDFCDw0QF9riEe3FLiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 9, 2026 at 2:02=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > A folio in the swap cache cannot be split if it has a mapping (shmem).
> > The split code only checks for this in __folio_freeze_and_split_unmappe=
d,
> > after the folio ref has been frozen and the NR_SHMEM_THPS/NR_FILE_THPS
> > counters have been decremented, and returns -EINVAL without unfreezing
> > the folio or restoring the counters. That error path is fragile: if it
> > is ever taken, the folio is left frozen and stuck, the counters are
> > skewed, and the VM_WARN_ON_ONCE_FOLIO would fire for a state that is
> > actually legitimate.
> >
> > Check for this case up front in folio_check_splittable and return
> > -EINVAL before any state is modified. Under DEBUG_VM, the existing
> > "Tried to split an unsplittable folio" warning in __folio_split
> > reports the rejection.
>
> Should we return -EBUSY instead? -EINVAL means the caller should not
> split a swapcache shmem with a mapping and the caller needs to avoid
> that. The Fixes tag tells me a caller can split a swapcache shmem with a
> mapping, so with -EINVAL, we will want to add checks at callers to avoid
> it from happening.
>

I can drop the Fixes tags. I meant that there is already some
defensive code that trying to catch it and return -EINVAL, however,
that defensive code itself is flawed. If this situation occurs due to
a bug or future misuse, the flawed code will causes the folio to get
stuck in a frozen state. The defensive code should at least not make
things worse.

Fortunately I think no one needs to split a hybrid shmem swap cache
folio, returning -EINVAL here may help catch any potential future
misuse.

