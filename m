Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC38CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BC16B0005; Mon, 18 May 2026 14:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822EA6B0088; Mon, 18 May 2026 14:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711176B008C; Mon, 18 May 2026 14:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA516B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:15:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDABA120A53
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:15:21 +0000 (UTC)
X-FDA: 84781342842.20.FD75B5A
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEEEC8000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:15:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKbULjL+;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1wmMbcFrpofA4vgLByx647zKSABWtCNtkMoNw+NiJ8=;
	b=iNTpsl+hYMEKZMGXgUz7p8mK9X4GZpOZA5M08aCAkDafixcDA2Bcf2aJ86T0S4c4BXGhJ6
	uQsivQXVxz0etpOK4i+oMtC2uYmO7GqV1up2GrV5GB4W2MJfVPXmVf6xdooFbCKgDhYL7i
	IQMSXHgj5PmS9fzilcRSH31Oz5RSNiA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WKbULjL+;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779128120; a=rsa-sha256;
	cv=pass;
	b=PdX/1IY1GI2XQyjfRSrjc8lsDM9ZDfQV4Nb1cavImWcRuL5CCQs9aTXNLcdFRzt9YK45jc
	EKZnf19SHPMixYIYQfAB5olPG6yXfs6LUQhqjLEL8pjwnO9pi9omunRM1ZOZa55qpMGdDk
	CWWstrN8hRP3UEHrruihhLZ1O7qebtM=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67e24b8ef55so4461722a12.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:15:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779128118; cv=none;
        d=google.com; s=arc-20240605;
        b=ZcmZePwa41gRYLVjoNajBXLyYPUMBSizE44jx89W7mnpogQ/xiZxt79jAfDa+JDy5Z
         yMI3voE2+p8JP/N0U/WwKd9RZYThJvXGmRtaTXps4t8gSo9qfVRo6SnO9VziYALaK0RQ
         yv1ET8yhTm0ZsWvRM6OoBzxL3neXTr+MuIqf/lLM8200mKjI90+qpDjHuElIQy4ewKAB
         qpMg9YIaa7vVI8rADtAQKPPuYjXudPC0RdWENmGzoDGucwEw2m+2Lj0XqKRUq4KyEVZI
         wGcWAl48mBnuT+Yo0hr3Sw33uIMuEIVPnGbSsFCV9VbkOfY5GK4Au5ALKcK6je3DvLfx
         oqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M1wmMbcFrpofA4vgLByx647zKSABWtCNtkMoNw+NiJ8=;
        fh=1F0nB4QtrcC5nkfxwB6vV1ydk8MvhB5LhZCf5gDOyqk=;
        b=SaFXJeoI8Sr3BtU8OEr+2u3iPutEiL9xd+nG6rd/PANVmYBw2TltKj4vxpzEPnw5RR
         bFzwC1pvTuA4bR8u3d3OFFnTY1cHd61ET+8AeAw60exMDSdBd+Yr/6bWLlMaIBamq/Iv
         xuSAgj3LyGP1u+WHiwFAYqGzLXbD8a+/Aba5TlCzqgoxXd/N3L06FVMpklTktZsX3aNv
         wPUDV6ZknRqL77c87WQ46VvXm7ojVyhwtptY3A+46G8VESo8NTc+EQ6gY2GJS9LMI15a
         avZdmcgtc3B5N9GsyGMBOGY6YB4117sddLZDd7W9UfYAwFcb40ScLBFyDSfFw4S6W6Rr
         zuAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779128118; x=1779732918; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1wmMbcFrpofA4vgLByx647zKSABWtCNtkMoNw+NiJ8=;
        b=WKbULjL+uJS6YG7wxmuzVntMtTHE2iGv9tYyrgBSZqGaZyQ7w/1Ur2JrFJxFUcht2q
         G8pUg4I0jBs7651Y6qK49tEZW8eXPfbRLrbqaWuxzOKNx8C8xjHY7oUC7a7PH5qZ4aPY
         0gwQV2vYWb1cwndbMa7nB2WkD5AfUg9n4aqkxEurqrq/4EsKHoguLixSZ75yVnzoS0LL
         7gWTyKcaRp7Bp7VSL7EkufHm/6SKtQaTrizs+2eM7GXVR28gs2Q4sNPEQYy74ZCoFRRd
         QqWNOecM0P0LtWz6iKgsKQVDbAf8bwNnR6nbuZwXzS6ZZeIaSlJC1rI8hxqXMrQSKili
         W9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779128118; x=1779732918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M1wmMbcFrpofA4vgLByx647zKSABWtCNtkMoNw+NiJ8=;
        b=pVKM5wXHiiJ7pGrQtj1RCIvd82cbmnRjamRLtKqnhI3tTRzuwJ/QDJOY0cj9kvtvsr
         dDEEOV1Sort0GtH+ua7iQGyDWsiRNKmAcCd05dj7f0jcGCZK7jdIcUELG73XFYOEr5Hy
         +g2u1vvLhhL9wSXDO2N01Dy46vto0S6anrADyu1uNGGg5QDw1aq6wEd/c+PDu1eofQn9
         82e8ecuMKYe2+VZQKAY9x5xy10HeamToXvSpTGenHQMNHIKPMx1DSGyePTYQy3Nkc5XG
         yqRMRB0BfaGhXBmcvcm0jUA59tAo+TzkH9+5tUaAcKercOKsapM2vWV+MBx00LqspsY1
         zCXA==
X-Forwarded-Encrypted: i=1; AFNElJ8O5pX2mSRZE4ZLOZaVjK5M6mK6p3DdEHW3aVDNfRDex4gdsbUVkQtMlmBoZeARuRNnjts1pslfHg==@kvack.org
X-Gm-Message-State: AOJu0YyBaU8hffBXbZfQmh2fNjfCx49E4GBDgNPLWeTa5+VCLWOXgKsc
	Vcd7YpAINdYnIM8QBtcl2OUCWYqZkybYhpyri5nSoNsm1Yu7y9CCNh/GSNgeUYgjRZ1+0I8VFMs
	YQrbjIqRI+RSI7zyEWgCp0n1XGgmg55M=
X-Gm-Gg: Acq92OGE3Q2XScQd8YYHI5HmZrSsQvtRLwA/BXyy02V2G0qsN8yx7eat8JwfJD4ZfA/
	J0w8we/7oN3xZstsrv4Zmj+OIb8D8K2Jb+3xDbYTR2p519R4W1ksxG+E5+1ZSJ/TkTls5gqOZ20
	6oNEJr9P149H4fp6q3FNndFqW0r+aeVaFenGJEIVN5IQ/6OZiurCnup8aw+N416P/Vypn+gtRWZ
	1tE7xUM8caE7T6VOy7vsfuz8IzUJK7dCy27bdaOdWOx8Vxnf9zLvrZW/h2NvXDE/NCPjVRgAjrU
	RbhOX7gc/h5Jtzngd7bknFV/23JO3hpRObV35y/1VKctpYbZJLM=
X-Received: by 2002:a05:6402:4589:b0:66f:8fbc:c73e with SMTP id
 4fb4d7f45d1cf-683bc5b8f3emr7684286a12.9.1779128118128; Mon, 18 May 2026
 11:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <3f4567fc.f496.19e3b2b297b.Coremail.23020251154299@stu.xmu.edu.cn>
In-Reply-To: <3f4567fc.f496.19e3b2b297b.Coremail.23020251154299@stu.xmu.edu.cn>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 19 May 2026 02:14:41 +0800
X-Gm-Features: AVHnY4JHoWxK6v16uLtT_OkK8acXtftWVLpBAXhOTjv3-TsHAelpZGafBq-MPZI
Message-ID: <CAMgjq7AD2ivdgD_kRx+0+w0M=Fvz5dXepw84_Ui_q7=97B4Ofw@mail.gmail.com>
Subject: Re: [REGRESSION] mm: MADV_PAGEOUT THP/no-swap refault takes ~1.7x
 longer on v6.19 than v6.12
To: Chengfeng Lin <23020251154299@stu.xmu.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Chris Li <chrisl@kernel.org>, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yjouir1sd9p8uyo4qzux5ysdc93oy116
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CEEEC8000A
X-Rspam-User: 
X-HE-Tag: 1779128119-224191
X-HE-Meta: U2FsdGVkX1+W7c+GIzlOxbsvz8hTWTTOcLWUGXptMx67zGE5Z4yeYXTNDuDhizhtTOVK1ERnwfzhdGUYnIbnFEjJLoCHJ/4RrjdL4FocGpMNH77fkHyrCh/20xEjU+ns01foFRaWF8qNQ552eqe6hf3E5XdzBf7p3fBWwvG8lOLjT9OufDQax55GY+41ZSCKR4iSXZ+wjENYCdi9aKI3P8mJrcj/l3a7IYFd4Y3VV38xcueQVr8fV0sfsf/yiAID1LJnkKPAfXVDYWQOrWTT7+4gDzCyUkOgsdNy34AMT+HlSRR0etuQr2VeZaMWJFiLSVVmlO9LvpnTYAXYFWJhAK/7BkGq3P43vgk2mrNuMHXoPqeK21QVNdjCrM9LKCRZQUljOM/SLJVyqm6DzpBAlVz+717KYZcnA8ICCFQvrpM4SLIXAh95qtWEm/0P9yiQ1eYT9KZqVUcdef+SYidJoqSNdl5JKqKmV4zUF7Xit6TZSpzrDMl64NH9+1/T4jDg6uz1zA7JbY3IwTg0ZuigJtCZBMbpc4tlGjhxxLsB28v/3RUHw78RF9rfB6gynkGvyVWSixRIZZ8SBLX9xFiogok8whD5HsA44fSALv8ze9LYfOnt3mpq9Z6qdqKNHWAQJ0JEdU/TT33s/PQMrPZ26qSEu4UaTjPp7pKYjQuboVQ2YjD0OLMmjNNx+pFvmOJ0svNpcbEwHAc8IZtMBCxqQ0IQBKuWwxoH7VgVW/9+pOJtTX7hm6s+jpVdp0SRdPEBi+ThZS7wG9zs5iBYWSLsU3XM10FE531Ij/IDbsntWlzfxJaTbCO8ILUubu/aVAvM79yEQLkg0txVkQjEY0WNob6lFaUUqoZxSoQId/Sw0WEd83WrZgVrMF6/7ekIXiiqsywfqnp1zRp7qDF/dWB5lH/iR5gOGZPoT54LAVJSm76vT6bk6K55V6qWY468qVL+weJAZZsvSBsuwAAD6tx
 QnGBO/d5
 QYlNF4Kxq6KPd/iLxOPV4uEp25dXS/l6X85CQt7Mldj4Rxnly0e0rGLgjf8+eaKGnQMLRoD5L6hTSk/01MdaDf0EeyFh5U9htkY1B46YShkG7FvGfKS5U97uIzlPmC/OyN1ANnZjA68III8cU7wDOSh42ACkPcAHYohbf6y5HZfRx1s9o4keB+Xbl5MuWVIJY2TaXBh5GyfXtHgYEaDOnyT7TRV84rH4H+cUlch9YwHjVu7Y9k9tOKrjCq2dhjAXaCUfnGxPg8zjU9oQU2z+OcRnnKV/TgaPFW0z6XQ0bvJyLuyVdISCgePMpZt2Jfb/nrpZ/i75D+nqRow3Hd0un/SPYVH4VR728jlRBYNSfLtIRTycXg6j2AvXRKJszUnrO6gI++iJeNeSDDuBomi/PGPpWuX8Pqr3YAru2Qxfm1jJXA1CwOAvQc7UNRfRcmG11u9qUS1bMW0TQQDUuGeVK6aiWPiA6pyeBI9xWH4RqCOqcB8t+2HBhcwNzBZ5ZzVnkaJ+wLf0a/rV113c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 9:09=E2=80=AFPM Chengfeng Lin
<23020251154299@stu.xmu.edu.cn> wrote:
>
> Hi,
>
> I would like to report a userspace-visible performance regression in a
> MADV_PAGEOUT workload.

Hi Chengfeng,

Thanks for the report. Very interesting, but it looks a bit confusing.
You are doing PAGEOUT of anon pages without swap setup, so nothing is
actually being pageouted?

> The workload is intentionally narrow:
>
>   - map 16 MiB anonymous memory
>   - use the default THP policy
>   - run in a guest with no configured swap
>   - call madvise(MADV_PAGEOUT)
>   - refault/write-touch the mapping
>
> This is not meant as a generic madvise() or generic MADV_PAGEOUT
> regression report. The signal is currently scoped to the THP + no-swap +
> refault/write-touch workflow above.
>
> The current public evidence bundle is here:
>
>   https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/e1=
3469b/madvise-pageout-thp-noswap-refault
>
> The standalone workload source is here:
>
>   https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/e1=
3469b/madvise-pageout-thp-noswap-refault/workload
>
> The formal experiment profile is here:
>
>   https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/e1=
3469b/madvise-pageout-thp-noswap-refault/experiments
>
> The formal timing runs compare v6.12.77 and v6.19.9 with similar kernel
> configuration, using QEMU direct boot. The formal performance runs were
> clean timing runs with coverage disabled. Coverage was collected
> separately and is not used for the timing numbers below.
>
> Lab environment:
>
>   host label: lcf
>   host kernel: Linux 6.14.0-37-generic x86_64
>   QEMU: qemu-system-x86_64 8.2.2
>   container/cgroup CPU set: 0,2,4,6,8,10,12,14
>   container/cgroup memory limit: 16106127360 bytes
>   guest memory: QEMU_MEM_MB=3D14336
>   guest CPUs: QEMU_SMP=3D1/2/4
>   repetitions: 9
>   version order: interleaved
>   performance coverage_enabled: false
>
> Primary result, cycle_ns_per_page, lower is better:

What is cycle_ns_per_page? The name is ambiguous. "cycle" reads like
CPU cycles but the value doesn't match. Or you mean iteration? Can you
make this cleaner?

>   CPU   v6.12.77   v6.19.9   old-lower-vs-new   v6.19/v6.12
>     1     1900.3    3304.7        42.5%             1.74x
>     2     2107.7    3583.2        41.2%             1.70x
>     4     2154.2    3690.9        41.6%             1.71x
>
> MADV_PAGEOUT syscall/reclaim-side segment, advise_ns_per_page, lower is
> better:
>
>   CPU   v6.12.77   v6.19.9   old-lower-vs-new   v6.19/v6.12
>     1     1713.2    2922.7        41.4%             1.71x
>     2     1924.7    3162.9        39.1%             1.64x
>     4     1953.1    3284.2        40.5%             1.68x
>
> The current mechanism interpretation is that the timing difference is in
> the MADV_PAGEOUT/reclaim part, not primarily in the later refault touch.

Right, with no swap configured, the post-advise should not be faulting
at all I think? It will just split the pages IIUC, however, that might
cause more TLB pressure. But this split-on-alloc-failure path itself
wasn't changed from 6.12 to 6.18. If there is no swap, we can skip the
split though, and maybe make folio_alloc_swap fail a bit faster.
Skipping the split seems more meaningful and could significantly speed
up this specific test, if this is necessary.

> The path evidence points at the no-swap reclaim/swap-allocation-failure
> chain:
>
>   madvise(MADV_PAGEOUT)
>     -> reclaim_pages()
>     -> shrink_folio_list()
>     -> folio_alloc_swap()
>     -> swap allocation failure path

What you posted, include that repo, seems only has end to end timing.
It would be much more
useful if you collect a perf or ftrace breakdown something like:
https://lore.kernel.org/all/CAMgjq7BfO=3DdNYep4z1aS7nUAJU3bktR17gYAufx=3Dkk=
Ludq4dAQ@mail.gmail.com/

Or like this:
https://lore.kernel.org/all/20260422003412.11678-1-xueyuan.chen21@gmail.com=
/

