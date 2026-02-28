Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A435FEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 18:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474316B0005; Sat, 28 Feb 2026 13:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421B26B0088; Sat, 28 Feb 2026 13:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6476B0089; Sat, 28 Feb 2026 13:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 193C46B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:35:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA300C1365
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:35:08 +0000 (UTC)
X-FDA: 84494717496.04.F0155DB
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id E54F940005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:35:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICVcDpR1;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772303706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pK9wiah23qgHAv4Kx8TPXRd5JFBPMCMdFOoBwjuK77E=;
	b=cJqWexsF1+Hh9yr3fsIi+g3BtFOJq3HSDB/R1qq33/fdZ5ruQSSX/M0C24/wj4YV1/4q5u
	nOOmAt8kIvYnFBEDG6fc7nLI+6j+oNKH274hlt6QCAe1jICZ5HkuUvnuvaKYQaH8eZ1E27
	fSobFQj5c8eroBXQB4JKI9B7IqWKMPE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICVcDpR1;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772303706; a=rsa-sha256;
	cv=pass;
	b=W+5B9Om8/z6M5WgsqR8feL5T19PEEXGJ9a3QcAEn1G819s3ZvnVPleEp1oagk2JXl//Z3w
	k5x75vH5p0DbZLO9+0zWpHqRFqlfZ1uDa4v7FqvC9HC0PA4p0SaLjYPhcm6QUfgI/oEQI9
	CvBM0gpKOUBPj4mpGOorv43Iw+k4vm0=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899c97c5addso40894906d6.3
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 10:35:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772303706; cv=none;
        d=google.com; s=arc-20240605;
        b=XnxX0Vxtfp8EtaOlv0Jt6Se2SshwhZWBIxm0MI7NZTkUh8TRiG1J1E3ZYzoJbPlzdl
         RkJxHVFA1Pz1KV4AN1eYH2e9sxAVIsS1VrDwh/A5lVB0YfkGReRjLykOmAGxWAfL5gxm
         xbFNjBEfjrJQQR/a8Lwpc7xTrEYajr1QfmjYgIitVUGo/6QMpYnfKGOEjITR9VfBl5Iy
         Z8FVg3zJYrDy1vMfuk85ZYlkjtrcjrqWdqEOUHOqOQOkIlzbwOyiDTBaJsV9tAGITXj7
         TApfApfB+JQa5zU60G1f7C7uho6TViWLYHkS2UeoFLTZiVQJLYnQEeDFdvAKkKEYAzcj
         ATyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pK9wiah23qgHAv4Kx8TPXRd5JFBPMCMdFOoBwjuK77E=;
        fh=s4hU7C3jBQDeNZNSJVQplIx36f+fOCAZoW8xZizFrEQ=;
        b=M/JZjrn0+VKC+6BoLN0O4HYgpd2NsMZX64jz4fP49EpEXejTmnDI/FrpwE+5NjGboT
         xZ3IqIBhgRuowbXWNXSLXBivqmzmxiFKuma9VI7IzDdZ4z2ofdDi6OKTcMjskDRdjEEJ
         67DSkzek3YXvfTjab4lRK8pcjca7IbMLB04A2fvVeJuOnj5ujW1bwma2W/vAcUeK2Ul6
         xq7T2S/NA0gqEgE9ZCIbnR2aZaW1JIyklQXh47evcpNtd0X4o9hJBdymBQBsy6uCy8I+
         QqU5w413AgRwSxKV1hH/+pULJPjmhhLTgtY8jQmrxIG9EofjlVxNB/wHJ3AEtGroNPKX
         /qOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772303706; x=1772908506; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pK9wiah23qgHAv4Kx8TPXRd5JFBPMCMdFOoBwjuK77E=;
        b=ICVcDpR10SfWoD5Jf92RKVgJZNzMWMSPu5pQBajc9Dl7Q3O28p/gpo2clxcxnUX8Ed
         Dfh779BV1KJqQlv/wBZCkJqo/klsysVKGzxLzg7+Rd+1BAwEFBzb6+AUGiX+ZlCgQEWm
         anmYmd/k/XyMa6BXMFhPb5E4ZkHx9mChqSfs9C6v1/VR+N5A2+0lLjcvKlMtundrcsxf
         nle08NZ1NlDbDDr6KoP0kDjy6CvOh3s8reJrhQxfYAu6S6DFnqWbTjOxA41C9FJYhhXu
         2DRfoPol0s6UMCpNX9Fz6sasVjNRtmo2nr5dC3Rf2BIffcgrUfC8XVauCMpbQk+pBOtl
         ssWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772303706; x=1772908506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pK9wiah23qgHAv4Kx8TPXRd5JFBPMCMdFOoBwjuK77E=;
        b=DKn2mn9jVgJrQ5ls69LFBJZwEm28L2DLU+RFu1Sexvm/VZfUN33t9rbgIU/S00839k
         mfS9kpB0sfKuGZmNIT5NS4x4Y5nXn53Dt5UMUCOnl0ev7XWjYG6W8PYwebwntWNMp/m5
         vp4WpBC6rXectm9jqNP0MLsgKBH6z3s9yCMWiIymYvZTTA6K5iiHCFkB3T5G7QFpXIdz
         ACIRYtxoWldajLqrIxU7XU/YX/WpzsX4UL9KLMEW2RMyivAP2YWrRE2ctakalm7Eo7nF
         AJzQ27U8GvsAq6ZS/r+l8LCqiKzSjJZiaBA9a+Duqq3PyoLNyaNp2QxUrqCzl0R4fG7c
         j76Q==
X-Forwarded-Encrypted: i=1; AJvYcCVCcwOsjXZ9RjFssf3amGDDLx5Yxzpa+kY8hxXFdW2eWYBZiqNOH4KZRVoA0Qp3jcfqdgy0w9aANg==@kvack.org
X-Gm-Message-State: AOJu0YwfOaXn6VREO/ZvGepCrl7KBRMlHD5C/FJ1cHvXFeN8qVHj3BL6
	GSwGiuUbhNNEkgE13+9yZcvORxhqvHUzJkGbedwWDUjLqN5rPIXXusZFgk/rQq7Io3yiF8hiNXS
	J9dDTKenEV1GSwW8SfvrnzW2wRrXzFq0=
X-Gm-Gg: ATEYQzwfLHOwMvc5trmfg+RCilgTY9bzV48sKxdOrOrh0H8xCY3cAd4EVyaQVOFHdL+
	R9wHQsgxs1hUl4shD7P40NP5q5+i9/6i2d6O8fJOum5sY+oNqpZq0LdxZiOJKxPYl0EgDeKcn36
	zKrrSn7s/WWfyac/Imjbj1+BDYP6gzpmJuL2h4+OuOz0kwWR68EKK/Niw/7qC/EFNhnJM/EkeDa
	KEiCfMlwSxk4toS7oi/cG5JVnET8WqDqrXK8mal49EAdzrIQQh8xOPm/Ke6i5pW7bTfD4avR2wK
	BJWeMg==
X-Received: by 2002:ad4:5b89:0:b0:895:bc65:4b0a with SMTP id
 6a1803df08f44-899d1e551acmr103848076d6.43.1772303705791; Sat, 28 Feb 2026
 10:35:05 -0800 (PST)
MIME-Version: 1.0
References: <20260228140540.1774748-1-dev.jain@arm.com>
In-Reply-To: <20260228140540.1774748-1-dev.jain@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 1 Mar 2026 07:34:54 +1300
X-Gm-Features: AaiRm53HWgcBAqvWacgL1U1GNVb8r_xrtGpUGBn8MzuOKMgyQ_b0KAmobvUxysM
Message-ID: <CAGsJ_4ynq76B+qJmtJayB44eRehviCbhBNKu0sdU1NcdiSDVJw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: fix incorrect pte restoration for lazyfree folios
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pbcoqednsh6hi77qa91nw8fwkc7mjp4i
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E54F940005
X-HE-Tag: 1772303706-89213
X-HE-Meta: U2FsdGVkX18gYM5SmY2o2myE2G2Wa0zh/ZheneKM+AjKXa/s0L6U9O3/CSQm7ALc2aguz4ddF/cVIpXW9TWLFRVKPph9cXpgLnqrCn7tNFR3mjhfryQxlzSFqlpzBwVTnQbeBHjkGm1vDKxHh6F5LJzhzH4LDIVt1e7nIp8E0XrOb71NOpiKmPR0LNy5UcchBslCmK3nJRy45MogPeftSyEFr9edCw7NbGX0XQQ/scnP+OIRTChQmuL2RWXRpmwH1qBBrQj6xA2j/w95T8VOSRcJ19Ssb8iAKdRFfSgzqk/BQKZ/Lb2wStlwhqZgHiBv0PTSTA2lMEIHGMbDkr5KVxe+CUS8dP5y3lDHf8Thqk+naAwHbpgRf11L1c0EE2WsPx45w2KGHwHFFFLmHLBg+8rFfK1E7nmFJIbOYwPKdMOVBZyUfBH9pl08BwX6DpRoPXtHLdXyN41aln+pALvDP9GLRr6sGm/DkRO+zwepVfYfjTQNCEFoZiU1kEDmXwdDrVdXhZ2UU2yBticstog2fh+Mayiu6PYeyA1eEUvs5emNqu6Z1R0Vs4Dz4tYEpJ2vX2ET/zn1yvieE+U9zsyljQBSXmemLF91qmBnfTfatqoJI8xca/ec/QtUaoIUB0iHtwlraVtEP6KXCZBxBUwc6+5cjODRrk2XaLqVA5XtDZ/ZgffKOBrAPzNOrOMbrtP32qq00Sq4ockr0isw9XzBw9fhBtZvdyAD6Sw0rBMsXoNz6Uy0mH7Py3/aAs8f6tOBUmAflXuZ5N1X9l3bkdM/iw9vukAyG62X/a/oGs9C6bn9sqrBI3+NxaOtQ1PYz3u92fIzrKgqqcKnM7WTJYdcCW77OvxvlRNppjbiehkckpmTc9//JH+jpjiF58c6Orm9a3xg/Ig8FliqiNfOins4kO0vT9aj12q1n6oaYmwOLVEbWdZYMaKNrWFnx6Re94qpy5r7QWLtk/3Iu9XZZWS
 lohdJRjU
 mT5Qb5mAW1MkzWbt3lztB/pdoRv32QPP1F1c5ssRAH7DhcqzkQ1k+rtsMKmUAjLAktm+nPjD+C702xOKaME3f1eYU6y4bcpDrNVpjBNFcMLzyP6dJtdbI1LyuSt6Lho91gDZmZU8HABJLL67qO480WCnmkznP0sYXGCuSKp/2hX+r5fuJMox8tYD95V0mzObR0E6qOziMidhheC2qmc5Dhbn5Mdk5EPZcxJzNPMv6T7jQPUlkE1eelIPxcE25ekmoPSCG2k8yefZiqdPBZ0HLb/WmYz1BfmuQo1g9y73mYrCwTDh0fcJ+5m58IxpdMNIxYL2gXorPDIL1W61QrYezrRlleb3QDhYtEIcCh02vriRJCLK4CP/uvCN5yeEWutiEHjinSFQzzVj1J0c+YKuazf/GHF49sX5+/t0vRbyLNqKqxMMQICJjyR1dNfaix6+G7LbM99shk814+zchxDxOtRe5yBkEZehRce5+fKpxaoQsPoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 3:06=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
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
> v1->v2:
>  - Just respect the writable bit instead of hacking in a pte_wrprotect() =
in
>    failure path
>  - Also handle soft-dirty bit
>
> Based on mm-unstable (df9c51269a5e).
>
>  mm/rmap.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e4..fb64829913052 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1955,7 +1955,17 @@ static inline unsigned int folio_unmap_pte_batch(s=
truct folio *folio,
>         if (userfaultfd_wp(vma))
>                 return 1;
>
> -       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> +       if (!folio_test_anon(folio))
> +               return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> +
> +       /*
> +        * For anon folios, if unmap fails, we need to restore the ptes.
> +        * To avoid accidentally upgrading write permissions for ptes tha=
t
> +        * were not originally writable, and to avoid losing the soft-dir=
ty
> +        * bit, use the appropriate FPB flags.
> +        */
> +       return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
> +                                    FPB_RESPECT_WRITE | FPB_RESPECT_SOFT=
_DIRTY);

Do we really need to differentiate between file and anon?
I=E2=80=99d rather just return unconditionally by removing the
if (!folio_test_anon(folio)) check above.

If we do want to keep two branches, why not use a flag variant instead?

flag =3D 0;

/* for anon folios .... */
if (folio_test_anon(folio))
               flag =3D FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY;
return folio_pte_batch_flags(...., flag);

>  }

Thanks
Barry

