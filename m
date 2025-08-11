Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58830CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 23:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA178E00A6; Mon, 11 Aug 2025 19:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1F28E0045; Mon, 11 Aug 2025 19:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7C68E00A6; Mon, 11 Aug 2025 19:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B793A8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:15:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25021135323
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:15:16 +0000 (UTC)
X-FDA: 83766034632.24.5527C27
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49A14180007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:15:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GcP2N/BT";
	spf=pass (imf16.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754954114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WTkp5HBq7+cYLzP9grKqIkwbrTAXkZVfrq7VgOeO6Y=;
	b=nCGN8KZpoDAT6GMPTXqZIQRnf84KTWnxPKVMDyAdaYxglndcwNIfBQfwH07SLkFIxRTiJk
	Somg+KUs5fMfN54EVwq4UUUAQHkCZmvcAd6YOgKDipOzdhq3+lByTMzUHS3QLzhM3H426k
	s+GuKAXNnCIEyqcFjZiFxgXFM1HeWTQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GcP2N/BT";
	spf=pass (imf16.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754954114; a=rsa-sha256;
	cv=none;
	b=lpseVOslr0SctzdUM1htFxJupk5lfU+XndgzU9C+gqTUmoHqWfp0iCnd3C8RBCY7K/SyvU
	kkcsNj/4FuNRKjGIuQ3K3V1JjszcaqIBFGqBQWdx3Fynvj+aWeY7hpkGy27CpBf8xkPYd2
	erPf8wLBT7EPWFJHKlURFUQbLfeR6cE=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76b77a97a04so4408557b3a.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754954113; x=1755558913; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WTkp5HBq7+cYLzP9grKqIkwbrTAXkZVfrq7VgOeO6Y=;
        b=GcP2N/BT+/S0EoMtV2wEUMvJ3iZM4ehZqZmvqd/sTeS2uLvEO6CqlqNhshsrL2UqcX
         yDV9g700j3y9pT4W/JPQflZ/ozMZNav5OZKZou+bkSVRcUdDuatcVLhx78Nh71QUufNj
         9f2QUdutCHTOLcZ/VzkcBe0VsHCItbnX5YW3zu1ZN2v9ynkdFFRoUE5Yeee9/o8hzCjU
         ZoI4IWHdGEVimbkkiZ0gAPHxZM7zWtDqqsg57QA5I7AYUQ80cNUXMeInbhKCVKh6oQC/
         PLRQ73B1qlB9qJr6f3BJ2YInW4Qw67beVGtIA/igGLheGu+uze0kF77P1J/tmGJemuUJ
         EG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754954113; x=1755558913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WTkp5HBq7+cYLzP9grKqIkwbrTAXkZVfrq7VgOeO6Y=;
        b=SLo2K423uOMT2xRILa+XHjhEi/4q6hAcIJOcT2tEgFTciV3Ts9RUeG16vN8mBQ6g0N
         2pNPpva/8xsIfw7GZNqPpW6H8GttN+muq7YlyB7JLWq4rQ2itJ7Tg5kR14ZXDLlIslhw
         DFv/oDliiOWJRdjwbjnhYpvMcZrZfA4Iyr6Dc4JLpYG5h30K0bjiC8LUS15ihh+8hTZS
         /NyCykWJxxCL97p1CDAyqKFFG0AXQDt6ewX3bzbeJnO+0hGYFe6TFMpa0TiR1ImkhKFB
         GjDYiuW/WCa+2uy6iLF0D0+hlp0Hvtzp8Wn8DjP6+a/LvoF800T8jd/6pHi/HqcyoDy9
         Zxlw==
X-Forwarded-Encrypted: i=1; AJvYcCX0OH7hyNXjJO1DaP1c51VuzOQjaH7eE2gl3kXBNc4jBi7kuxW6NZ+AG/Sb72aHAd6ppRGhMTnSEw==@kvack.org
X-Gm-Message-State: AOJu0YxRy0fiRVJS4th3kqXEuyl9plVv9qpdxA5pdF5l27GXLkyuJuPk
	OOD/XbWuL1GSVUxr6wiH0GX4kaLagZfmiUdUMbnePRvg6WJURdzWyLWKdPQCWkkZDy7nu67n7W2
	sL2KLdlCL8BTRGjrHRh49n1TBqXC4XDc=
X-Gm-Gg: ASbGncuALMlyJ7t6wSF3oJNznHPgf49ijVyDJyJK37PcXFR1LTd1hv96Plx2n+U56+g
	SFUMwWyRgKyeRC5n22GppFougXa2sxdTR88/ha8QAdMm9q2xGstaPPduObEbMwFA5gU0JIFm5E2
	/jvpxGqirRMxI8IIr4mwf3/oz+4K8aij0cQ0qq1vnc5vU+LFbcmD+PW66e4BPOXNoH95qrfuT0m
	Jge/+7vdGrH4YxtzSvEchs=
X-Google-Smtp-Source: AGHT+IHr1K/yJjlq6Ye1Sy8M8F+wQq/Rw7tGlOYrfGgCsGUOTDbj0Iu2trznQNcP3D2ebbnUU2V5lVrfGLyj6GAmXLg=
X-Received: by 2002:a05:6a20:3944:b0:23f:fbb1:c21b with SMTP id
 adf61e73a8af0-24055046d01mr24530175637.17.1754954113102; Mon, 11 Aug 2025
 16:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250808152850.2580887-1-surenb@google.com> <20250808152850.2580887-4-surenb@google.com>
In-Reply-To: <20250808152850.2580887-4-surenb@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 11 Aug 2025 16:14:58 -0700
X-Gm-Features: Ac12FXwQt_eww5uvpy4ERMVpxcDuQGrIx4kEQc7H4eeLVmpPLimhRUNjaij0L4k
Message-ID: <CAEf4BzaRgFid5WDsNGOzE=ysc6jPcSAmB0MwRHYdtSbm-vLrWQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, david@redhat.com, vbabka@suse.cz, 
	peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org, 
	josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net, 
	willy@infradead.org, osalvador@suse.de, andrii@kernel.org, 
	ryan.roberts@arm.com, christophe.leroy@csgroup.eu, tjmercier@google.com, 
	kaleshsingh@google.com, aha310510@gmail.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 49A14180007
X-Rspamd-Server: rspam06
X-Stat-Signature: sy17yqtooohdj9j97afqwjopu9r58kse
X-HE-Tag: 1754954114-43059
X-HE-Meta: U2FsdGVkX1/GiX7Jnos9GvQ3lPaswG/P3lielTZlflpwhR9I5XW3YVIw+vc97PRJZQuoIDw+G6ml3lsI6NSdzhVCPLegLXHiXiqqQqPiqlMRHPTNJ3CDeGrr7jFZqIUCEvhTpvCt2nre2WfKatXHLPMpx/AasVWpjbUvdKPnikbZCkRiTcKmtwPDTfsc3dSSAkUoiwtxPEC2stlj6MCtAgkBTMZuGBtbD5wi3Icm2+wbWL+XznRceCNx5YJlx1pwVeg5DuH/OvoaQtMGZbn5FsaKnYxjA3LIu6cZEy1d4546euE0yHeSeI/D5ttN8z736t4tFnTn4BuzKDyQ2rpwjumZR0ZWiZ6+LpOZpoN0nZa4mM30NMgG6SdAL2Mpky+yvpPNwupfDsEDFvBx3wB+GKHYHeXUSrG5jnLV3lN3zY0FAPlaZcl4NJ7PdhNxLXCgI5QIqlJdEteMBY6bXeIwK4iac64g6dAfMTxXizCJuj21slgyr5J/2KbBjKptUFcgPJJV6TH2uTMkaDoBmPxcmIM1eprSvJYr8zEFxa8SRSQzgR2duRcDjqyZaXs+qgMH+mwjFf+9caDOr/ZPZCtbEPF0tL+jw44NMwDy6bCrqLJE3nGKgAyfrfRCpD2Dg2G0Cjgipz3xm3hXitSHi5DRNz4glkFgxGDWGZJWbYt4zSS4IaolyvbxMmyb1pzva0EdYwuaENAoY6XrxW9fP8rsSJ2nbwolibWXzU4Bl4u/JPUr7Y5jYwcWPjGb9SLXBAFq6npeYeytx6/2fUZs7XOrYXlYVriDS9P4ZCM7VC+9iOjtd/Z7JrBs6tAzhTcSg4Ku9yq+FRL3FTSbvLCizh6mvs/SyM47f48vS+n6JCl3wNHaaSXIDA4s+WDqFTEsAKA7dfSxRpf1qZuuVtMmLninq3ETHU/NCWelyW3PvKOFqtimUFJ44OAxS70zI8lNY61Kx7KGX2tvwBJDUJwFLiT
 RWSvaGod
 vK6CcC/ZFXpxBeUXETxDJ0qQ49leRBQLr2MkssXsL+0jFssQHpd8YAjwQ9V/xjxEBkrtCTNtS5b5T49Pa1ZCmFV+moF7Sd0ClPIzJXr0BLXV6S1yWmiL9BCl8kF1LlQw5lekxUiW4XojCmViBq4t9iwfkyes3unqTtJWidpZCwBemMgd6vROdMOqFHigvQD3vbRMPBbGD9JAZvXW6IkJsECZFhcdcka+NkMqpzAQ387v7P1KESWNMP/Yf0eJiAKYBoBaOTPEMH688vCMnOuxoRAVDovqClVQV2TSYmbNPF5OLHlqwduK46vcCl57INy//gIdNnVD7bIkddyRcSCpWwWB6UUPzE6hv9MTjvI5O6wRZa9YKpJudaTztNl9omGRCvxm3Jp6J5p+F9WIx+89Rb5J+SKPttVnTIuT9i3lKh3PzSh4/K9i9VDA0slRIvoaWb3mrd9FaikEzeJKbK9mcI/X4ouBiJXUil0Ap3QIxUWSHPiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 8:29=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> Utilize per-vma locks to stabilize vma after lookup without taking
> mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> contended, we fall back to mmap_lock but take it only momentarily
> to lock the vma and release the mmap_lock. In a very unlikely case
> of vm_refcnt overflow, this fall back path will fail and ioctl is
> done under mmap_lock protection.
>
> This change is designed to reduce mmap_lock contention and prevent
> PROCMAP_QUERY ioctl calls from blocking address space updates.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: SeongJae Park <sj@kernel.org>
> ---
>  fs/proc/task_mmu.c | 103 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 85 insertions(+), 18 deletions(-)
>

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>


[...]

