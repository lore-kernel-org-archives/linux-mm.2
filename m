Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E6ACA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320CC9000DB; Wed, 13 Aug 2025 18:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1E7900088; Wed, 13 Aug 2025 18:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7D89000DB; Wed, 13 Aug 2025 18:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C830900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:02:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0330160480
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:02:14 +0000 (UTC)
X-FDA: 83773108188.01.95DD13A
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id C878AC0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:02:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zw8ODeTA;
	spf=pass (imf28.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755122532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iFht3nsk7YqplusUetBQqE6oe6XCHDupWqucsOT0ug=;
	b=0rFDWCcNnGosLndxCNDux52Qphkm9dAqd8fQ5f/4zBCYEOekuS8yVmKXiPfg2fCLb5oGnb
	GEoT9hFRiRjs7F11EWvjyj58xkWbE7unTXN2y6oT3qNC4utjzlvx/tfcawo385W28rzA8M
	uw3sgtFSDd/sgoOSAPfFiE51P/zSX58=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zw8ODeTA;
	spf=pass (imf28.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755122532; a=rsa-sha256;
	cv=none;
	b=ZvOzJ1dO7v8Lz1KNynNxWtV6PLE10O2pIB1v0s8PtJeVJFqnJh6GRJw9mcKFI+zL7+wPSG
	wCpBBkyfQQ/zQ4I3/BzmM4msPpQNRx9lAoVXAJ+T530zfuZXB80TNZvXnu1hUEWA7WDtlH
	8HIgHQQ33S8YR/NFLrioI5PBpak5NWs=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso1619a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755122531; x=1755727331; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iFht3nsk7YqplusUetBQqE6oe6XCHDupWqucsOT0ug=;
        b=Zw8ODeTAhzjiT9NzOOmgeN7qvhNi6EoUzxf/2P7ibee9PcJE37FDpOnED7lChKd8vy
         gT4nTdGV60N6K2dqCCpXM+FuPD3KuUE7nisapT37mcKzN0E03FFZWX1/EnhgnT3LkJNg
         70RJAZ80mTmJZLOro2zBNYr0zxVNO61cfKN3QDXsUQ9pRz8IoYTWuNIJuqJJXD01g5KW
         xkWt3Qk0l8Tj2HvwrDZ8PkuPE+RtkeiSuXNg1yrdlXb9km+pLBNisj0LEca65JQDtpci
         cjMGsX3NsiXaP+6XXsGFRBibQihdl698rsYCywyiZJGUtpy0C0tfD6o0Q80qyBCPe8Np
         vH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755122531; x=1755727331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4iFht3nsk7YqplusUetBQqE6oe6XCHDupWqucsOT0ug=;
        b=Dycpne5FyuWiGsaRj2XZKSusU90oE3ASWiGrsJmdMv+ClHO2k1ZVHeBWIKcVapq/0h
         lgLTcstQIBZZf6sOsIrO999pKSQ3nQYdfOhk35VXMQCuFvTVCol+8n/dJKj/Am+QLF5G
         ceLuKxLsQuJSTBwR4FwhEW93D2sTH867SzEpcsWtIDEziFK8xcvc5IP7mHfUUKk1X3mH
         5mb5+YZIgtx7qjXYR1uQfFD49ATv9RH8vTdgSyTO6rvWMZ7X6oR4vxvwBKGXEu4vK/Di
         7YcJnYLABcSGqjOSFdOKbI4p/NfvIdVvfY9eaGRXJu0jux8J+kANRnwzdvukbCpVg+Rr
         L+ug==
X-Forwarded-Encrypted: i=1; AJvYcCUcJ2pxiEARoVCBpXm9QSUYPmQ6vy0C+/tAXc2lwt2ObTjJ6roCVCeA09V6VXASSeaqKJVahlfvPA==@kvack.org
X-Gm-Message-State: AOJu0Yz0E56d0LcdQCKdDF3cmYgPSw+FY96uemcLj8C0+KIcrlLBmt9y
	Nj9+9DGXBCpyaCdy5tUHEFquhC5iwIXBTnXaA/2ioFWn6Nc+0ZqHGcHVBxYyssRpO7pZKZvdfsv
	NPv+FW0AylQtOzBUxTdRQDn1QNVkdD50Cq6R01ze5
X-Gm-Gg: ASbGnctWE104086vRgQehzCKlYWLj3htPK7wMbK37rCOBEayF2hGwq0B6c5EGnbe0Zl
	9g0yX1sZew+HeGbBmIWeR8F0hL0GNJMV4v9TRdNn9QpHPL5Xyu4gzut1brDgoznc7fBaAofe4v8
	CfDXV7GexusHi7fevpM4Fhfze8eTjBFrePhbumRLwlQT+6xCYvr/DBnncelS4Mm+W9UT2/QGGew
	VdQcVSA4W8pkM6r5ZMVPqzujEbZnAADeSJCrw==
X-Google-Smtp-Source: AGHT+IHiiPh9Xm8Mns7CYO0SfUCu3wLhGRYYIogqYiDQBdF8hepQOLiPJ2i3M2KIFfkMDguGUksaJNIUBLHQn6XDs6Q=
X-Received: by 2002:a05:6402:a0cc:b0:618:4ac1:e6a3 with SMTP id
 4fb4d7f45d1cf-6188c50b31amr28635a12.4.1755122531025; Wed, 13 Aug 2025
 15:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com> <20250813144737.c3f388313fe13ff44856daf5@linux-foundation.org>
In-Reply-To: <20250813144737.c3f388313fe13ff44856daf5@linux-foundation.org>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 13 Aug 2025 15:01:59 -0700
X-Gm-Features: Ac12FXzh-EyQzOywYOpNxT8MGqhZDgFNX3c76zzozstwuOwDhPlgDUJ8kAYaIKM
Message-ID: <CA+EESO4rMS5ot_wJfWVT+7rDKYgk187xnZJ3NNZsFgUXCbG1yQ@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 91ojeihf7e9x8rrxpf6qzd7ib5mj83g1
X-Rspam-User: 
X-Rspamd-Queue-Id: C878AC0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755122532-704746
X-HE-Meta: U2FsdGVkX1/lsMgKxNj99yBMO9M5VeKORaEsx9O5HcPj1QJFlyrxXdjLoEBYTAwll1SoYGgsOsukZ1Ia+eiJANArG7w7+kU+UTGpyswGMTBnBNv0v36hgRGyhaWe1mKc1yX3VQmG+LUDNzP9gN7L3X5JH5GogMYZTsHlEVGbkk8p3Th7jkBWp27TvzMVbiUIAQw0u4S/UkbXYAtIhxAxBZQROnDJtWUiteIXKuQuJjKubbxc6TIq0zYT/nfFVWwZDAYPyc8plmH765XN9vl1mu8oEMyF4g+J51Yr63APkLIbT6Pc+NrN5bC8jdbpuR6vn7lgR2+CCiKL0VRM8+Mv1lOL4B0BTUaiLs8oRhsxrsapCQigg3oIT5u+ZMOGAzneedneMYiKj+aEloLXIuFUUrLTSZZs4LLg4/QyiWFqh0kl6zAc4VfsIBjFhufr12l7o/cReKc3rCgyWdxMQ2TmRWEioRMtaSMdgT56r0GJJ4NRpvaTBB98YXNvvEJRIolgIu2sm4l8k0Q+kJkdeAUp7wdE0+vUD9WWWdSmXVnbpPGguHnaBVm+UqQLHn9l2NIeOc+A4q4Wava6I6RQGk6szMYf7xGbAvAjv9TVxtj+5m/GCYP8gz2z1fqWT2TlBRnkW8MPmBVLw4yHgBOyzfqPCYrgxhQOAFk0V2TDkxzee4/rKsm9gQMR/NW+2LjvxCbKqdpScgkZbexdGplMqMXtdFm9WXtZmMqAJzZ9FK2808ZBXqtMzhpvgvAqlyLMqvKjO5x0omYHaq3ht+4yx/WQi5JPxGmqolXHLI+hssPPF+ZqbzNMfodGCkbr42Tf0FHabM2SADjBqUnkRYlYoWu27XNDXCI3clbF54mExpbIfEk9mIV8QnqeV60BtvNIxX21MnxSGIwZOMyRF+DN93rXU7o0hYbTwcby/FJZYQ7kMV7tsQu6jijCQ+W5zWuQGpZqdsz16o5kYfxRBFIhtSE
 Q1KOSgLr
 95J6krKhqKJoqrTDj4E3ci3JqxXut5Vikv+gNRTaTB/V8PbTxXJuscC/lzZrK5xNgUUEF8qf9foqvgH81Bxtc+UxT3XfYxKL2TwS7zb/NmWYzUwtxnYwNwtTafW88HpRzXjU9P32ts8Qm27UC2z3pbmiT3P6aio+CuSVaTzfjPBe3Y5LJ1vfPB4sTU0T9O3/Kl+U/YV5bdJG8O3mnT0yCVILhkuRxVoFzA4FfLCbEEnvDriZcvnLrv9o/BXlvzUnEHtllhOTPfGjkN5zDxSdVYole8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 2:47=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 13 Aug 2025 12:30:24 -0700 Lokesh Gidra <lokeshgidra@google.com> =
wrote:
>
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > When the GC intensive benchmark, which was used to gather the above
> > numbers, is run on cuttlefish (qemu android instance on x86_64), the
> > completion time of the benchmark went down from ~45mins to ~20mins.
> >
> > Furthermore, system_server, one of the most performance critical system
> > processes on android, saw over 50% reduction in GC compaction time on a=
n
> > arm64 android device.
>
> Were these inefficiencies a regression relative to an earlier kernel?
No, these inefficiencies existed since MOVE ioctl came into existence.
IOW, the patch is improving performance, rather than fixing a
regression.

