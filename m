Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6A4CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F228E0003; Thu,  6 Nov 2025 15:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3270D8E0002; Thu,  6 Nov 2025 15:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23CB88E0003; Thu,  6 Nov 2025 15:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B6C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:33:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96509140206
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:33:14 +0000 (UTC)
X-FDA: 84081331908.27.69F91DB
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB39540011
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:33:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E9fnR7Du;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762461192; a=rsa-sha256;
	cv=none;
	b=48Dsk1pw2Jb7jupNnYPWJzXfXxyFhuRRoXnL9BRrzB8VbUtABERvOPgbGQqgFWdkM+drsO
	IR/WYD4lu5NzyxkyJ5dk3GDRfaYFyeT3M4nQDf4rbp1bV/xjCIfRBrT8CrPSkPEOi6HlwG
	C1oIEAre3OzagTMTa9nnkTn6YpvTC/Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E9fnR7Du;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762461192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xL+ExJHey77vkVnS/nFKD2Q80J+5rEXtAD2VwaDjjF0=;
	b=4sghu/bFAJDKeZTgEmRB3ae4cLF2I8VRN7xdgdjikJ3+gJfVNHtF827d+IWynAWgGAotnh
	9gFdJ4+H9vOPEJML7y5jVu0yBmiL0231VQBRd9dndUkxNJ0Jpg5L7GN5J/P3nGdctLxAfr
	RtMYArnXxskTEoRZmIUl2SyPxWi4W1Y=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640f0f82da9so76322a12.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 12:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762461191; x=1763065991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xL+ExJHey77vkVnS/nFKD2Q80J+5rEXtAD2VwaDjjF0=;
        b=E9fnR7DuukZuxHmcQVdi0Be+W6xQPnU5Zvs57X5LmGmcZuqYFatuXzZzVIxq+XGuWi
         hKWAbZEZMARXslSJ/AbVYSfEL8t6Lyl6ytvWRA0F9YFlviLGvY9CmGU7+npQIN4Us4/r
         1prdKhOwZkW3UDKs1KORdN1rNRpG5Y9UNS4mZ32X3c7wgTanl0MOwS0gYqgWpna08Ndt
         6wLdQetn5UWNev+sXkDzwVyEdxP3heuGrDuxQLlqStsDff/boV8LmbXwJZ5Hd8RJK8/n
         DlkyXI4y3WFPWPJzqiiHuihhKgKZ0m6eEGkMJ/ZydfvUVtp+V22GEG7IM3FLtn8Rf8mS
         tQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762461191; x=1763065991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xL+ExJHey77vkVnS/nFKD2Q80J+5rEXtAD2VwaDjjF0=;
        b=pLxc2nF7F24rplb1oy779epmaNiGZZpyop9WE4glLsJj0y+DMp80r6OA6z9Lb+mDWH
         wAg+lZHUW3RRDywye7C1VcbCNyFpVqlGujjYeeAsu8iRrbqsBMJ0r7tbazPEwfHHT+9K
         WLQNnK3bsVq5vrT3PQK3ika0auIblf1dCYitNiShy7+t71ICFci5mCnv/J5XLyLWrCUx
         lqUvRbvKTgCrxU3e1N5SQpe/ZSPSkOJVjpmLlJ3nGgHeWy9YbjGGKipXRwoJoG+3im0s
         gphWbPHFg8OnLAKapdw3X+CU03TlDdFMa52a2lxy1gV8N5ui+D9ejFFR9EhjpSR07Clk
         G1JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKBa8GvEnfhf3yuW52DqhYM88gUHEV9tpwPFZIuksuw5FjPzzldZ/tE0BndHtbDtB/fWhQt0ruaw==@kvack.org
X-Gm-Message-State: AOJu0Yy6CtKUeWpoawR2U2Wl4G+jnU1cuPhCOuMNatBBGOuy0HjTYSHg
	09LY9+1DpPongU6XNh95B97f7Q+wmkumg0DDIqAVUggcz/r0Qia/FGNr8fNBx2R44/aFxSpzy/D
	uOgwPd8RUvw0AFvgTba+3SJwSCcKtLxo=
X-Gm-Gg: ASbGnct042N/BQS9WDWxg0Q7AiLVKTeh2ffz2PvwQ4Gj1gNtPO7ZpDKVWtWaZ0oUzCW
	nvaOyRKbFMyqsF/UMyrNqV3/mGZzhjBIFV2UKxVLwS9mIZXHCBLqxclU1Eh9AJYYkQceYhtCHHR
	JpmsxqjNK21wvSY+vE37lokjf5Hgt5B38UmM5QkmbNiuvxwqX/Tjqa758nCsvSWpk0yuXtGmtb/
	6G1yX5ZV97Qx4ZQ+Qhp4qdmpnR6bbZj3f0FYYjNbDA8D6aW79rzFyKWWOZTvW2J6VZWuQE=
X-Google-Smtp-Source: AGHT+IETH7TgDjX9EmzND1gh9/bOqYrGX4023/EKkF9DvOk4qobTQ/4/v6JxHRNK5zF87+RCoQSIQaroXmmA31SkP4I=
X-Received: by 2002:a05:6402:1446:b0:640:947e:70b7 with SMTP id
 4fb4d7f45d1cf-6413f059a21mr880436a12.3.1762461190669; Thu, 06 Nov 2025
 12:33:10 -0800 (PST)
MIME-Version: 1.0
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
In-Reply-To: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 6 Nov 2025 12:32:58 -0800
X-Gm-Features: AWmQ_bnPi8eKWYWNRrzziK5Z4e3l9q9ff39Nc1Vl19617h5U67D-CZcDH7VdLSo
Message-ID: <CAHbLzkqvXsFfziYU6A_LXfF2UQHkmNHqyT05P+dTav3mi4b0hA@mail.gmail.com>
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, zokeefe@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB39540011
X-Stat-Signature: 3gwphfgrkwbrzgcqur9b9a7tnm5cj3xu
X-Rspam-User: 
X-HE-Tag: 1762461192-714679
X-HE-Meta: U2FsdGVkX1/IESlyuTZ4zNqbuu6b05P2tPecr6bFv5RUL7JENBX/hj1AUHlss0IWZz9GdS8rSYDroo+lXVxJK1qCArWFOCbZRJ7Y2sdfFVGtbcpwB1jSwRGwLFuDvzu4nOiF8KbQY8wjdtGhp0UrqqS77Fq70hlKv2GJgWJZMuBVj4eyKnwJxHroRIFP0nUiv+vwWMandYLl8gyzAGXl22gTlQXczGOashy24SfHAtd86hfaWaytbrh0lr6lauXbeZLhS+cCOn55pIHRyGFMFm54+8Ud5tRby0Zgm7umZ4ShiuNN4/5YAbfj1UwSmDQipwKlQvTzpXv4i9b5KnKbf1jZnZJ3drNoc9OVWryiOzUlZBAqMr1NHyBl8tJQ4e8Rx7wMq1ITa4c+WVAfo+QNZ116tvWS04TORxzfurOY9v6LtyucwexTqkRNggV/O+gL8uAF/F40aAIchr9Yf/qq0SvpDjpehTrp5WhKgfsyPj26TpX5t3sml/VqgB5fYmKj7XMCc4vY5E40GN/TRCtG0eO0/7QE68M1RgdmdmiKHoXAos4x+UaoPyinqLvV0oa8wJZcuB4pCJVWzHpZ6a5pou8Br5XiufwqWaDc9tZHFtP2063IUkljiWgtlkI63WFq8AF8oEGEF+XP2fdcHgmQAVamo4NKkpa6Nrgy6Ygs4aLvO/bQzWOsZ8plaTKCmsZWVj1BN7iA7ZAiMGOdY3FDcuOhL3N0igUb7xYx2NJYRNEWb6li6I3pwzPKgsuRD6qWw0rrG9JOoTts05STan0HFy7xsYcVVUm7v+6TxsS2OEzXTADEsUhzt5PcGXou8f1k//0kI9iTn+9Phcne3KEIKamIKD/a1aP0gqcwB0NrOyXQFSfiafn5RIdT0th4SJUJ2E74/dQtim0OenC5QxZy6OcGG4O05n/lNQuolBVFfIwUo9hr+lMDr991gAZ1thXK711lEX6YcKudqcTWWmG
 oeTO8qUa
 eGalL1M0yfHE8zeF3QI82A72pdGvrEoT4Sq6LQjqsQBFYf3CwcusGOEwBBn4eVdE+zpZyRCVC15fa/wvmijiBzNOX/Nj1eKjvqG84AiGyk2kiTlgU0e4yNUvW8OxHL5fg2HYVwvrYJboRAAS0Bv6FPiUiiBcS+x+X8/a78jRZM+8u8nxaeJXDksq2MmJRxwI1vlA6FFGQMBHjAI5iRYhL3+ShRTazNFr5Vp/Qs3vv//Zeo+SqRU0Sx1NsrPlCvIpd4QOA/dRW0Sk/LelYNDzAMCj9UgxVatQIm4zdEVnOeIkPZ5G13VirZ6S5MUx0uzbWywB1mubitnr+m2hNdxxvd0/6c39/Zn3uivcHw2NBlv+z1oQwPT2zfRxNrQcscY89cXIN4GPw9iKJUSb2KGtV259j8Mxo5TM+mnRnjatNcUDGGy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 7:16=E2=80=AFAM Garg, Shivank <shivankg@amd.com> wro=
te:
>
> Hi All,
>
> I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pag=
es
> when CONFIG_READ_ONLY_THP_FOR_FS=3Dy is enabled, and would like to discus=
s the
> current behavior and improvements.
>
> Problem:
> When attempting to collapse read-only file-backed TEXT sections into THPs
> using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the page=
s
> are marked dirty.
> madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and err=
no =3D -22
>
> Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madv=
ise
> attempt triggers filemap_flush() which initiates async writeback of the d=
irty folios.
>
> Root Cause:
> The failure occurs in mm/khugepaged.c:collapse_file():
> } else if (folio_test_dirty(folio)) {
>     /*
>      * khugepaged only works on read-only fd,
>      * so this page is dirty because it hasn't
>      * been flushed since first write. There
>      * won't be new dirty pages.
>      *
>      * Trigger async flush here and hope the
>      * writeback is done when khugepaged
>      * revisits this page.
>      */
>     xas_unlock_irq(&xas);
>     filemap_flush(mapping);
>     result =3D SCAN_FAIL;
>     goto xa_unlocked;
> }
>
> Why the text pages are dirty?

I'm not sure how you did the test, but if you ran the program right
after it was built, it may be possible the background writeback has
not kicked in yet, then MAD_COLLAPSE saw some dirty folios. This is
how your reproducer works at least. This is why filemap_flush() was
added in the first place. Please see commit
75f360696ce9d8ec8b253452b23b3e24c0689b4b.

> It initially seemed unusual for a read-only text section to be marked as =
dirty, but
> this was actually confirmed by /proc/pid/smaps.
>
> 55bc90200000-55bc91200000 r-xp 00400000 07:00 133                        =
/mnt/xfs-mnt/large_binary_thp
> Size:              16384 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Rss:                 256 kB
> Pss:                 256 kB
> Pss_Dirty:           256 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:       256 kB
>
> /proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty page=
s in r-xp mappings.

smaps shows private dirty if either the PTE is dirty or the folio is
dirty. For this case, I don't expect the PTE is dirty.

> This may be due to dynamic linker and relocations that occurred during pr=
ogram loading.
>
> Reproduction using XFS/EXT4:
>
> 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load T=
EXT segment is
>    2MB-aligned and sized to a multiple of 2MB.
>   Type           Offset   VirtAddr           PhysAddr           FileSiz  =
MemSiz   Flg Align
> LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0=
x1000000 R E 0x200000
>
> 2. Create and mount the XFS/EXT4 fs:
>    dd if=3D/dev/zero of=3D/tmp/xfs-test.img bs=3D1M count=3D1024
>    losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
>    mkfs.xfs -f /dev/loop0
>    mkdir -p /mnt/xfs-mnt
>    mount /dev/loop0 /mnt/xfs-mnt
> 3. Copy the binaries to /mnt/xfs-mnt and execute.
> 4. Returns -EINVAL on first run, then run successfully on subsequent run.=
 (100% reproducible)
> 5. To reproduce again; reboot/kexec and repeat from step 2.
>
> Workaround:
> 1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
>         int fd =3D open("/proc/self/exe", O_RDONLY);
>         if (fd >=3D 0) {
>                 fsync(fd);
>                 close(fd);
>         }
>         // Now madvise(MADV_COLLAPSE) succeeds
> 2. Alternatively, retrying madvise_collapse on EINVAL failure also work.
>
> Problems with Current Behavior:
> 1. Confusing Error Code: The syscall returns EINVAL which typically indic=
ates invalid arguments
>    rather than a transient condition that could succeed on retry.

Yeah, I agree the return value is confusing. -EAGAIN may be better as
suggested by others.

>
> 2. Non-Transparent Handling: Users are unaware they need to flush dirty p=
ages manually. Current
>    madvise_collapse assumes the caller is khugepaged (as per code snippet=
 comment) which will revisit
>    the page. However, when called via madvise(MADV_COLLAPSE), the userspa=
ce program typically don't
>    retry, making the async flush ineffective. Should we differentiate bet=
ween madvise and khugepaged
>    behavior for MADV_COLLAPSE?

Maybe MADV_COLLAPSE can have some retry logic?

Thanks,
Yang

>
> Would appreciate thoughts on the best approach to address this issue.
>
> Thanks,
> Shivank
>

