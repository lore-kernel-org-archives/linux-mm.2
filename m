Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A79CEC0480
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F3C6B00A5; Tue,  3 Mar 2026 04:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25DB6B00B3; Tue,  3 Mar 2026 04:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31D86B00B4; Tue,  3 Mar 2026 04:57:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A09196B00A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:57:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BE97B6D44
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:57:55 +0000 (UTC)
X-FDA: 84504300510.01.C19F033
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C595160002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:57:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RlJdvGoU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772531873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49WYO/+rOA9t0KP6hhBgqGHCLldhbvILeVUrY/aiLgM=;
	b=NtU2Rswo719lS06lA9itJ9CeIQWrvBWmHVg8tozN1jSsDkJtiYcNo/OPF06A5IoDOPDx9Z
	wMevI2Su1fsM/pEM8ZC1d0sBHhAPyZ75/5vpik7jrdsUQc5qIqsjq0fSlphhuhToM4vPC8
	E1mXR3sF3vh2pFs0Aj1L4W+VJGEoKVo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772531873; a=rsa-sha256;
	cv=pass;
	b=7Pym6g59AdeuYRrtkdsdjSzRR4vuTueLEqN/jWLw0AURVlpAloE7ZWACaXvnjSAPT5yHso
	oGfXpdOG3Rg/s9urytytNxSrGr1K76t6E4/WeEy1XL0kV89dcvjH5ULN71UFC/nQ7Tq3cv
	58Yvb5rEHMNI9LvCb6HhEMQ7hbuf4MA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RlJdvGoU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb39647a70so516853885a.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:57:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772531872; cv=none;
        d=google.com; s=arc-20240605;
        b=L+m3OIgVkwIjZgse54bpD3bjSat6nAECqIu9utQ3elyQyyU/rQFlGq7XJH98PKqA16
         tGWz03kBah8Prl7rf5MAPQQvBJ7BFnoNdpVbVf4tpeP+ZeMpviHMJZJmI3LigZK6nFE+
         AMh2IK1fsNf+lJEkdRK8Mp8OqcdjiM6811zaZpBm8yi6PUBYAM10+dXV0D1Bc6EttPDq
         GfaNVlJyJc5NwHrvFT7hkzt9eulEL2iXBV13m6dFyxZ33gPma0XpWmPKVUAp+7PAwGb9
         5L0y/oKDn19aSbSGLjwNuB8xf2eGVpmLEvv65wuJZwBNQLzZhegg5ktC7tmXhKJzZQmw
         4ClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=49WYO/+rOA9t0KP6hhBgqGHCLldhbvILeVUrY/aiLgM=;
        fh=L/YC38dfU1sTFtXkcdIkJWb6kU2SuhRmYYwXhsULhi8=;
        b=gR657lTEuIMJNQTHxvHau/tFoCHeBD2KwGPsbY2a492hICORU3jxsimdRqUqvXXDc3
         qGsq9nUIz0uMGGMLPr+8TGUjvndVh7U7McFemjvjOcc6MFSUMdk3BWe4dw5VD/qTsKVD
         z2c3b61Z51pA2KVoEAahNX+9QGS7BYu93Yr/PZF36piA0/vdRHIWFm06ZLP+nilcWs96
         +Db9JwQS2eoTPpkuyDAUXYQtnagvtgyTmsxKC/C284aUP5uGP+wBjVuYLOQAyoWZWykr
         bpZWb9a/6zJyRRLu/clMvLpAH1zk+3DX7GOfcbzmuA3HYK17Xp2C5Lrd/K1Wjvtqfy9f
         MWMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772531872; x=1773136672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49WYO/+rOA9t0KP6hhBgqGHCLldhbvILeVUrY/aiLgM=;
        b=RlJdvGoUaLkcDz6MHQctt72c7zGCXrSyJf/mpSG5OjjBDgMw7ZphQY3WdNYqjCFiaZ
         rfOSsZ8HJa3mTEYUSFtD1XfUxcwk+xBihBcy1b96tU7VrzVk/KM5mamVUr7hTDI7jUr2
         ukPWPrJIntGz11Eq10nubAoZ6Ytllfjd3HPpPjHj1OqhQlSPxjLYxCB/uET0HHTflj64
         pYmJPgOoscJyh88iL5JH+lC+iwqUEPSBPgfXGRGV+Ykg1mWOeBlHQW3lBZePLRfA4EiT
         uwJxthF3QjuZi+NhOT7Zw/YvAYg0DRA0uvbdrld0ZMvOny0rVNDwfSWKm1fQFtK8w6QC
         NoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772531872; x=1773136672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=49WYO/+rOA9t0KP6hhBgqGHCLldhbvILeVUrY/aiLgM=;
        b=I/pKHwEYlCSH8U9YQCSfyBLXnazfYlAqTKV5ixP4SHouBKZ6lprT+y0CK/yBflc53w
         WV6eoLwY1Ws6Tv1tjlqtYjrWceTdQE4Qs/iwQGNSblxdUku4DVaoxi1jkTtupOAXajho
         Bu+NKEslLM/7jLQ/zDppx8T7f0nBxIyVxsgvdfkLRCfipyjrCjQS++1+1dHbzFIzxcTQ
         N45NrwmGEglNx549EyYOG94VWZEoSGNmulG5G3OvQW37rQq3dUFk/ybgpeN+H7ZTlZMA
         nptW3dg5qFpKUaQYan+MfmN4yBjCXUVa8MLnuJhutDhpW9OulY7jjZyFKLRvAw/8B8RJ
         imcA==
X-Forwarded-Encrypted: i=1; AJvYcCXOrLm8+W7d15MdsD6PPo9+i+sg6dnR/KFsZhiw1zHhY98t7pj/POzJ/sNwkKe70gExVk5pEcqReA==@kvack.org
X-Gm-Message-State: AOJu0YwYoA1Qm8yU7KIhwwHNviyQZAFvcvIB0ooNq8C7huuldv7lEwqd
	OHxOj6P/zaas5wDVrhTvKdDoUYDLI3+vW0yj2tkli+U5D/t9X7NNlxwKeM8la+4P2n0AZAh/seu
	IAVh3nC8n7I1SyU2CZdx+j+YfWcQimuY=
X-Gm-Gg: ATEYQzyWTNIcWzoAzMg76StvIW6AHtz+mP/iWZjOqG6GMFes/8pa1GalLwAzJLXhydl
	Xf1XI6xNpQp0qn0XO/0QkmRS9mDbvS7YiIQPl3ghF2FTFtyG1tuPda0p/wnwQxYF8rLHLBlfjRy
	TPlZIw+X7h0nKZ17/IWo5joZ9Id4PWKQiTlBRADJ2GjVyPrRpJoJeD5uG/BPwR6koqGtQeuMUEU
	wqmhU6eHNmzslUcR4S1+PHfwRRqjV+b71lK1ZjrQRJl+qJ981o9cxLtTWbRNzgWgqZBHuutAik0
	qk9U1w==
X-Received: by 2002:a05:620a:4623:b0:8cb:4289:6c30 with SMTP id
 af79cd13be357-8cbc8e3945dmr2014799285a.76.1772531872061; Tue, 03 Mar 2026
 01:57:52 -0800 (PST)
MIME-Version: 1.0
References: <20260303061528.2429162-1-dev.jain@arm.com>
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 3 Mar 2026 17:57:39 +0800
X-Gm-Features: AaiRm52yeeWcUN3OO5cDxOPYhF0kXv9YLMxuAiwr81lLVowx5-vojheOhHdb-9k
Message-ID: <CAGsJ_4xwi9jS=Ee5Ba7vO1KnN4U5S1HHodsaLf0gndYFz-nroQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree folios
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7khe13t1ck3zbe14rkzy8rencty6y4ow
X-Rspamd-Queue-Id: 4C595160002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772531873-659773
X-HE-Meta: U2FsdGVkX183evGAVcVwuUEdc3LYhdpaMK4Pel371K+mGUdQgHVgqmVJIS0XuMGX4NyCYFjFAGF9/L4Hr+E/x5FCdsZBy9vzyWMKwaz2nzikz1QdP1TKCs0exxgmzuJcdGElobYXf+UC01sOmf9rctRj0uwIBNnJ7vT4sM0vihxVpKCcMjXDAY+LuOOD30VnbB/Gp9chOqRHQv1E+sIdKbLT6eGRg7NqN1Tr4zXrVh+OqAHrGQlB2tL2Hl62HiGPrddA1zkA3PUmMmxsTYPpGx1An19kuN3wcmh8GhId6EirTnEEw8R5jFOUGH9JHmDLo7vr0gDK+d4WMFtgjY4XIJgoo31bJBbxJvwa/WA+/1fclKdSYFxg4XsvOrf6+vwU2fcmcJn1/mk5EUX7IR4Zcqg9MVhBeUu7dquH1NfH5U01r5ZFuan/eLa5CV2f1Cz62okZrDYxN/9D0Blr35CwiGwiBPGnct1+UpdSAA+50faF9vE+25o8uXDJ7o+hU7ALrUQ6j8Vr0lO8873gt0w/KrJjxbpzHxwv7R2UYyflyt0/cUsTV7CWzjLAM98VH7XFBnc6mBoD6TyhwM8qclSJktvWG53zb3Q0VzK51z85w0a+tlXVuZ0ONxiptkCq42M2OxwtFeWH9yIa254qd1zePmjy7pMOktnRmuCwWRaQ15/AaLFlHlOTraImNbXNeJwHMIBF4KUxyfQtfCWWgS2M9ZnWbtzXfFFReeuu0LIXoqHkA3yRwo7Ec0l7x3UnSZJFA/Qcn1C0E7/bOrEhdDBPMMMDupSwouF2Tk0JGZou0LPHtQiuUSmid+90IVwaTgzGcITVo/ZNRJVg9hWUpDonjJXzR/59t3qwhRRnl6aTJ1Zdzsf2LRBG90YrRCmGJ2b9zjeRfe+UXEBJtbPm08lF69gadJ1qAdYJ3CbESFvTWnBZwYPFNoAxbpMevaVrezoBzamrTgZwW6YS7qglvsg
 Snpaha7T
 R7nO6dnR98JxHPmU2by0IWXp+pfELc0az6r7mBiqeaykSrlkLGNtnooHnstEYvou2UwOdStVTObPWcvau2a79LkulM2plmV3SX+YP5ckh6KymeXFBL7bxVhA+7Z2PnrcBQoC7qGybsDqZusrmCd3AM4StCAS+pkVdi5kTtVFSPhvuMkq+XxXLYtYLZ5ZB+nq5MwCmoHvouUzfchnGi7/aB8B2sLQzqICpa1LdgjqsHaBUBe5404Fm1KBbVwUN8/iiXjpqBB4pYOIQe6cM2hZaLgK2yIy7FdvPmIi2IL4QGcNuMqpj2i+8blt1pPJC9wMf1gnFsdn95z+NFCo8v4QH07YQ0Rf243NbPF1liYmBwB49K8L2jB2BAgEA6v4qOCKW49MLNKSQtDC56cag/fVLAKaBJMskhC3Xr2xeIools4v1+MvfpcKTt3i1FGvcf4FPfHZ+FNi51093KZzxmtbEJ/Nwm0xoEOqcl7Z3kVt5M4Zhbxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 2:15=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
> If the batch has a mix of writable and non-writable bits, we may end up
> setting the entire batch writable. Fix this by respecting writable bit
> during batching.
> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
> lost, preserve it on pte restoration by respecting the bit during batchin=
g,
> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>
> I was able to write the below reproducer and crash the kernel.
> Explanation of reproducer (set 64K mTHP to always):
>
> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK=
.
> fork() - parent points to the folio with 8 writable ptes and 8 non-writab=
le
> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
> the folio as lazyfree. Write to the memory to dirty the pte, eventually
> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
> restoration path, and the kernel will crash with the following trace:
>
> [   21.134473] kernel BUG at mm/page_table_check.c:118!
> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   21.135917] Modules linked in:
> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0=
.0-rc1-00116-g018018a17770 #1028 PREEMPT
> [   21.136858] Hardware name: linux,dummy-virt (DT)
> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYP=
E=3D--)
> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
> [   21.137607] lr : page_table_check_set+0x134/0x2a8
> [   21.137885] sp : ffff80008a3b3340
> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55=
e03d000
> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 000000000=
0000001
> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55=
f217f30
> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e00=
0040000
> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000=
000ffff
> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 000000000=
0000020
> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55=
c079ee0
> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004=
000ffff
> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 000000000=
0000002
> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c=
08228c0
> [   21.141991] Call trace:
> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
> [   21.142766]  contpte_set_ptes+0xe8/0x140
> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
> [   21.143177]  rmap_walk_anon+0x100/0x250
> [   21.143315]  try_to_unmap+0xa0/0xc8
> [   21.143441]  shrink_folio_list+0x59c/0x18a8
> [   21.143759]  shrink_lruvec+0x664/0xbf0
> [   21.144043]  shrink_node+0x218/0x878
> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
> [   21.145056]  reclaim_store+0x3c/0x60
> [   21.145216]  dev_attr_store+0x20/0x40
> [   21.145585]  sysfs_kf_write+0x84/0xa8
> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
> [   21.145994]  vfs_write+0x2b8/0x368
> [   21.146119]  ksys_write+0x70/0x110
> [   21.146240]  __arm64_sys_write+0x24/0x38
> [   21.146380]  invoke_syscall+0x50/0x120
> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
> [   21.146679]  do_el0_svc+0x28/0x40
> [   21.146798]  el0_svc+0x34/0x110
> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
> [   21.147074]  el0t_64_sync+0x198/0x1a0
> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
> [   21.147440] ---[ end trace 0000000000000000 ]---
>
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/wait.h>
> #include <sched.h>
> #include <fcntl.h>
>
> void write_to_reclaim() {
>     const char *path =3D "/sys/devices/system/node/node0/reclaim";
>     const char *value =3D "409600000000";
>     int fd =3D open(path, O_WRONLY);
>     if (fd =3D=3D -1) {
>         perror("open");
>         exit(EXIT_FAILURE);
>     }
>
>     if (write(fd, value, sizeof("409600000000") - 1) =3D=3D -1) {
>         perror("write");
>         close(fd);
>         exit(EXIT_FAILURE);
>     }
>
>     printf("Successfully wrote %s to %s\n", value, path);
>     close(fd);
> }
>
> int main()
> {
>         char *ptr =3D mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PR=
OT_WRITE,
>                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if ((unsigned long)ptr !=3D (1UL << 30)) {
>                 perror("mmap");
>                 return 1;
>         }
>
>         /* a 64K folio gets faulted in */
>         memset(ptr, 0, 1UL << 16);
>
>         /* 32K half will not be shared into child */
>         if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
>                 perror("madvise madv dontfork");
>                 return 1;
>         }
>
>         pid_t pid =3D fork();
>
>         if (pid < 0) {
>                 perror("fork");
>                 return 1;
>         } else if (pid =3D=3D 0) {
>                 sleep(15);
>         } else {
>                 /* merge VMAs. now first half of the 16 ptes are writable=
, the other half not. */
>                 if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
>                         perror("madvise madv fork");
>                         return 1;
>                 }
>                 if (madvise(ptr, (1UL << 16), MADV_FREE)) {
>                         perror("madvise madv free");
>                         return 1;
>                 }
>
>                 /* dirty the large folio */
>                 (*ptr) +=3D 10;
>
>                 write_to_reclaim();
>                 // sleep(10);
>                 waitpid(pid, NULL, 0);
>
>         }
> }
>
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios=
 during reclamation")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

