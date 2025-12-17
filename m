Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727F2D64077
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 06:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D106B0089; Wed, 17 Dec 2025 01:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26DD6B008A; Wed, 17 Dec 2025 01:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29726B008C; Wed, 17 Dec 2025 01:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B390F6B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:05:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C05EC08EE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:05:20 +0000 (UTC)
X-FDA: 84227925600.08.8ED4290
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5252D40013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:05:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALUBOEId;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765951518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzkiM50k6ZG3sgfx0RYbWFnfc88JekT6DSlmQNXvWhM=;
	b=AkWuv55+jPB2C3E3J6195BY3C04uo/hFrqgoj5C0YWm8GSZIT8dQM/+qt5RMeNMKE9+u02
	tyoj7/7R9wj1/Yt+Y7xlCEAPWcu5grHBVzaH8p9qOBjimb7KzwkmaRhLJRSv3TUcRzKVDf
	9y9nG/ias0HDcZ/SxhGxHYTYzuPcRa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765951518; a=rsa-sha256;
	cv=none;
	b=cSaWsbKDuj0+IoOJ5P6v6nJFNzHuZXc6wPIMnAJpaOQQdaMZyfff19c3tbMemKrSkpGOFU
	d/O4/bMw7SxgtKCz4AZufr3v4g1ImnrP3gvXi2thME0XaAV7JaoQXlrlTfkcvHbgW96e3r
	byKmkqUlARPAxjHLRsKfpmGn6LLobr8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALUBOEId;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-647a3bca834so8036437a12.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765951517; x=1766556317; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzkiM50k6ZG3sgfx0RYbWFnfc88JekT6DSlmQNXvWhM=;
        b=ALUBOEIdZxOkkarfqpwu8Pk3pIBvYPD6nvg5I3x/9aKvlvMXxHIyOGKurR/NQJ3E4f
         duOmlZDdNrUwiF5B1+mn7ZkY8U0knqElJlHQxJgCWIdV7r1rwNCkzKFaR2IO9uOw61ra
         Wyn7EbsOriT7Q3s7wab0i+zG9bWKrev9DyoQv/5rS9W+LXw1GOL2jTm8CeTjgL+HGnji
         VRufKCwPSngzqSSc8XZfvhTGn5V6HR9nYGj0U5AorgbLU2sTzqUv2iI9IxwsbYk7xDiH
         roh3sB+eyQugW8IO8fWenbS2ZPq9kX6uLpt8rW1HKqnu+j9iSswpDWs+MaYrn2atVPxP
         01dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765951517; x=1766556317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tzkiM50k6ZG3sgfx0RYbWFnfc88JekT6DSlmQNXvWhM=;
        b=bK6w9DsTtanz/aD/zSeGDlZdCTo5tANfWpWiZCEMmF0fFVFnVrCJd1IGgH+5dCdjGE
         pJ0Ke7n7pZHloGpmIFOQs+ff3UuD6sMCqjZtd0IkZWmSFk5DbfoqcJhv5vc/duxJiOVU
         v0rqfurpXGGSVehMTnndkOA6+/EzMH3HJW34qf8njwUL/L+7SZSbF0YqcmcjU0cApcyP
         LOwIFvc5sD85rfKkOBwCdXdFpR4UXpQ618jXn5XntuKGwtpNMlyDQO/vngFXDgciikWd
         1qP1W14SY0/JnZX3K+fEEEwuPiSAnJddyL5ZpxenNiTzvR3wLh03qvwOvZ66TGXCiHkA
         03Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVOybNEIYxOdsRzj3pbCcuQ172HgWR7gKjSe9GAhWamu+icqn15lvt63qxzEOnu23bYq6dG95YTzw==@kvack.org
X-Gm-Message-State: AOJu0YwwWkbrMoK1za+xOadcf7Rd0fOJOyPTgciOIsuca+WsTFOCsr9c
	5EZRffLQ+xp08Fy26+vdtlGYv4AHNLFhF2K2blzFsCKu5wP7vWhL3JoN6LPsB32f8RdtN+B9EQ2
	Q3LPyDmgriUnrDBGjKZ3qrfQY88SaF8E=
X-Gm-Gg: AY/fxX6a396k0YA2rGR6fvg1Rx8W4AkcpUDnp2YpFrUN1y8iPv7UuUjQncrM9+wocCt
	pCd0U9BkEZkwpt9mI2c4zkZ6V6Xec8mH7/7tbUtcQmwYAaOJgoDrcu13AZi6g7xIe0woSwKGmY3
	8Urg1YVhAc7VFQPt+rV2OgQwZKBqDQm+wU//K5sVX6SA29PU377G0noRmRELGcoRaJFX+jeMBD3
	j1y810o/FjyPEjCXBAAAn5z+n30A4gBa1fcmJDGcaQzhrQt8KsNxHDmEeC0lXj5G100ZG9zFdmr
	gxDlMbRv4v5XFaiBkFuE/FZIRew=
X-Google-Smtp-Source: AGHT+IGHT9jCKXeBNS5EMB6lGm5IgemUGXvguhOQ+9dd3Xx5808DPEiM6GtOUMiv99PRSR6+0hWZ/EweVhzpHMtch1M=
X-Received: by 2002:a05:6402:42c8:b0:647:a127:7c1e with SMTP id
 4fb4d7f45d1cf-6499b1fa9demr16612807a12.20.1765951516383; Tue, 16 Dec 2025
 22:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20251216200727.2360228-1-bijan311@gmail.com> <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
In-Reply-To: <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 17 Dec 2025 14:04:39 +0800
X-Gm-Features: AQt7F2rt9hYgbWGNlc1IQV9TncnI_OOEsGhWX4JltYOTG7dWvmbkitMkRSii6D0
Message-ID: <CAMgjq7C+SsrtLjL-c7yiHh6sLi5Nxi4Rhuar2OoyU8WA4YrANA@mail.gmail.com>
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in folio_expected_ref_count()
To: Zi Yan <ziy@nvidia.com>
Cc: Bijan Tabatabai <bijan311@gmail.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shivankg@amd.com, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m6owddjstahmjqfn6s51pfipft76i111
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5252D40013
X-Rspam-User: 
X-HE-Tag: 1765951518-226548
X-HE-Meta: U2FsdGVkX1+cdbcb7IxH6mbQwuvY3jHZQ8Daj3JlnIVP7FW3w2zhvk3VCTHz+VUarQIKz0eLgTOHIjoQ9AtKydF7zS20afUbMQLpd2r2vdFk074x92KNEA5BwlybTbG7GMERO4bCwPL5bsGlRo/Ce9Hym2NQBiv8iiAIXuuqW0eZbIDMrVbgxHY6G0uqUSxW96nRjZ1kGb+CsEtpMeSItBR9JhrZ9zA5d1hA+gjTLddMtqNz9OegQRxrM5GDYBT1tJzGSLp5M04LH6WjLrjLVmtadES0Mfd2+5SsDyd/bOTp2NJalMGx6IThYBldFzrKxBPIF+hJ8/R6uX98IERy3FOyGfyoQJQo7ttdleeYh4UpdlhG7EnJtZH43pmzSPTl0WyeO0W+Ef9FM+brfFBkX2fYLtX6EUzgF+AzyzOo30Ije96sP8TJ3tVJfi//1rVvDmA9Y5A8GqhHQJqX+Wr7bpB8XiHlkpKpmIsLT6YXY/FOWCH2Xu3tnko9guXq8FHRj3UUj5n3F7VjjukP+IN/VfnyaDB4hJE1vWe4O+v3d3nyU0TZbZV+cxdBerm2Ly5CPIz4nJB5Druf8Ne+vDITcbiQ2TN39sQTFQdVsGIDfRj/MA9Cm3ML8G811zgfJhwt3nlRFIvXC144cRZeO0wpjPVEQDFxdVnHi0vlwIRfE3vJMjbo2Mv/5p1H/yOVkNc09gyYv4ojA7DysNJob8zzIYdaev0axYElLfLZZXrUMlCKBwSyPuADhWrWtOSY67+L+iLuf2rSc0HZkCeCLDCeSzfyn4rF7iMQ/6ByQvT5i0sFigP7tdUYHXYu8d8v5xV8H2SA2tMxYH92XrKTFb+hNzRg4VtSSIeR1j2C35zJJ7i1dBMFegsZenqoyqJnCKE0SY8oXjI91In2B09vMg84r5/cvTB/FHiKFlZxRjGeVWKPrgTYnbY6hbljG/ost1WNlTwfXGMSoTI0tbmOti1
 l89bg7Qr
 hWVS54BA5HIiVkS+TqKidmgZvj7LNMxO/0hcNxoopSqWrWgHdfPGfRaw6VJa87A6InptqiRWM9C5Ap6jAJ3yU4r9VOVm6Yws+5dJt0N7bOqs85sN2oKy245yz/57Bk80Mb6c+C9CcrDUWPj44uJVmicYnpiwr8Y4QqX900RRGSHwSwPb036xuCC/1kkpcToxpR89+BfSCGQGd+nigAIs8SavzKSR5VQ5RnYVE7V0V3aeZg6avXa0qt6UVDCn/G4zS29RQ7yrK70+j+hOzvJ+Y3zkHLXtXZ9SCEx4s5OLV/fROEGcOSAgX86m6+aUt/eGxCcKIZ/CFldpZW3ApktoQar48jQ+Bj6YvFDzrqG2DJoAiYjRfdqXRWYopG+Znx5OeGRvin2/yE79Agij8OuPg7dNEbVCt+KOBUhbJpl1RFY82aEdEEPNotLgreIDAkPQ7e+uhiuQoeWk1GVMw6jwPTV2pfQ3iMUjs+Hm7aNh3ZZhAeAyJdsEVKB4Xph2dqnpQ91QtfD13GojwEIyvTl8/eOacHTMA4BbOLgaqnqIxvaR92Io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 8:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 16 Dec 2025, at 19:07, David Hildenbrand (Red Hat) wrote:
>
> > On 12/16/25 21:07, Bijan Tabatabai wrote:
> >> Currently, folio_expected_ref_count() only adds references for the swa=
p
> >> cache if the folio is anonymous. However, according to the comment abo=
ve
> >> the definition of PG_swapcache in enum pageflags, shmem folios can als=
o
> >> have PG_swapcache set. This patch makes sure references for the swap
> >> cache are added if folio_test_swapcache(folio) is true.
> >>
> >> This issue was found when trying to hot-unplug memory in a QEMU/KVM
> >> virtual machine. When initiating hot-unplug when most of the guest
> >> memory is allocated, hot-unplug hangs partway through removal due to
> >> migration failures. The following message would be printed several
> >> times, and would be printed again about every five seconds:
> >>
> >> [   49.641309] migrating pfn b12f25 failed ret:7
> >> [   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 in=
dex:0x7f404d925 pfn:0xb12f25
> >> [   49.641311] aops:swap_aops
> >> [   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|r=
eclaim|swapbacked|node=3D0|zone=3D3)
> >> [   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8=
 0000000000000000
> >> [   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff=
 0000000000000000
> >> [   49.641315] page dumped because: migration failure
> >>
> >> When debugging this, I found that these migration failures were due to
> >> __migrate_folio() returning -EAGAIN for a small set of folios because
> >> the expected reference count it calculates via folio_expected_ref_coun=
t()
> >> is one less than the actual reference count of the folios. Furthermore=
,
> >> all of the affected folios were not anonymous, but had the PG_swapcach=
e
> >> flag set, inspiring this patch. After applying this patch, the memory
> >> hot-unplug behaves as expected.
> >>
> >> I tested this on a machine running Ubuntu 24.04 with kernel version
> >> 6.8.0-90-generic and 64GB of memory. The guest VM is managed by libvir=
t
> >> and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the
> >> mm-unstable branch as a Dec 16, 2025 was also tested and behaves the
> >> same) and 48GB of memory. The libvirt XML definition for the VM can be
> >> found at [1]. CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in
> >> the guest kernel so the hot-pluggable memory is automatically onlined.
> >>
> >> Below are the steps to reproduce this behavior:
> >>
> >> 1) Define and start and virtual machine
> >>    host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml fr=
om [1]
> >>    host$ virsh -c qemu:///system start test_vm
> >>
> >> 2) Setup swap in the guest
> >>    guest$ sudo fallocate -l 32G /swapfile
> >>    guest$ sudo chmod 0600 /swapfile
> >>    guest$ sudo mkswap /swapfile
> >>    guest$ sudo swapon /swapfile
> >>
> >> 3) Use alloc_data [2] to allocate most of the remaining guest memory
> >>    guest$ ./alloc_data 45
> >>
> >> 4) In a separate guest terminal, monitor the amount of used memory
> >>    guest$ watch -n1 free -h
> >>
> >> 5) When alloc_data has finished allocating, initiate the memory
> >> hot-unplug using the provided xml file [3]
> >>    host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --=
live
> >>
> >> After initiating the memory hot-unplug, you should see the amount of
> >> available memory in the guest decrease, and the amount of used swap da=
ta
> >> increase. If everything works as expected, when all of the memory is
> >> unplugged, there should be around 8.5-9GB of data in swap. If the
> >> unplugging is unsuccessful, the amount of used swap data will settle
> >> below that. If that happens, you should be able to see log messages in
> >> dmesg similar to the one posted above.
> >>
> >> [1] https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml
> >> [2] https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c
> >> [3] https://github.com/BijanT/linux_patch_files/blob/main/remove.xml
> >>
> >> Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference=
 count calculation")
> >> Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
> >> ---
> >>
> >> I am not very familiar with the memory hot-(un)plug or swapping code, =
so
> >> I am not 100% certain if this patch actually solves the root of the
> >> problem. I believe the issue is from shmem folios, in which case I bel=
ieve
> >> this patch is correct. However, I couldn't think of an easy way to con=
firm
> >> that the affected folios were from shmem. I guess it could be possible=
 that
> >> the root cause could be from some bug where some anonymous pages do no=
t
> >> return true to folio_test_anon(). I don't think that's the case, but
> >> figured the MM maintainers would have a better idea of what's going on=
.
>
> I am not sure about if shmem in swapcache causes the issue, since
> the above setup does not involve shmem. +Baolin and Hugh for some insight=
.
>
> But David also mentioned that in __read_swap_cache_async() there is a cha=
nce
> that anon folio in swapcache can have anon flag not set yet. +Chris and K=
airui
> for more analysis.

Yeah, that's possible, a typical case is swap readahead will alloc and
add folios into swap cache, but won't add it to anon/shmem mapping.
Anon/shmem will use the folio in swapcache upon page fault, and make
it anon/shmem folio by then.

This change looks good to me too, thanks for Ccing me.

