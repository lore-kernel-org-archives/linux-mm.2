Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6BCE81BBE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76E06B0005; Mon,  9 Feb 2026 08:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A247C6B0088; Mon,  9 Feb 2026 08:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906476B0089; Mon,  9 Feb 2026 08:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2566B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:07:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E5ED16016F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:07:02 +0000 (UTC)
X-FDA: 84424943484.29.2F518CB
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F5D118000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:07:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KIvpWnhJ;
	spf=pass (imf16.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770642420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWW2dvpLSF4DVyfBqWuCpyd4sQ2XDuJUQdmIqKmHiRU=;
	b=x1wjSuhGzOICVUGHfnQ8jv3ZGt2jv3/VXyGh0bZhyK2uhYKN1b4ozOrPqkoi1RxJeEUyuM
	W6vmJW6lj5YegYdk5RLtDHtFN6WH6XCbLGnvWkXPB2PAxsuoEjEltHfM3NStOzmPVvw7BO
	5g7X2lQJyVgekEQtk1O18QMewRJVlVU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KIvpWnhJ;
	spf=pass (imf16.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770642420; a=rsa-sha256;
	cv=pass;
	b=p/y0s8WIxRxOoLL96f5PMm2iVLNsDIEr603aqS3AK0wmfESrh4rnFRjgR6LnGW69VDegS1
	5rYeTgj0MeJQYgJ5iXGgADmAOaVlf6XD47G9Q43dlxyCV00qnWU+kZlfIKCLhUWZLLCn+V
	FEZiQpBaQTELDy5oG0ndPCugN8PX4BU=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ad62a294bso1944000d50.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 05:07:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770642419; cv=none;
        d=google.com; s=arc-20240605;
        b=lDSz7QvFVmpfSFDT+VenGbjvPq4kdk4ggzVyJkYwRhWpn0+wY5VNs3azT2fzTQM563
         6uVwocjlvAaNfzcuyfNHdCuQGmKPnHRuYIoS2i4wzW76mkgp2WUAuNGOSpokWzOSG3hY
         EGC9oZh6M57w2KJjUdV4vaIhr6XfiAouZsEMFmiHmVbAKiBiVvUFvWibnAqVxks5nYAX
         GQhbwRwuokzYpMV5wt02IQSs0g4teY8dAI1yutz7w43dKKyt1Y7xhuZp8aWRiCVQKlRl
         CA/AV+PCY3srUt1bE81wQus2/jih8YMfYhOS3fKuKHd+mYumLQhdTZnbnRyia4QzOlXj
         RDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HWW2dvpLSF4DVyfBqWuCpyd4sQ2XDuJUQdmIqKmHiRU=;
        fh=lfiCJPlW3ScS0NPVYe6qv8r76KBXLEJ0jxnL8kmSFKM=;
        b=cG/T3igcMXSGYdpGmFFU/bLEwiumsrXfGQFqXvo0nb4ruxjL5Rdjq36FNvrBSQ7uQ7
         q9Kr1F3ylSMlACpKRbKMJsMeoC1xBZJzF7KSAefODeGmfhPgDUlGJjfpC98ukEPgY6Ih
         wji54sfvQe3U62NGU8HUn0H4bh1juVO1H0wzwgG3mhVltIE62Jv38qNt1P9VNbl7aFUQ
         54MLRVBH0SQ3rIc6n5HxURtH5ksHjf8H9r6C7r79KoaLH2uJCz460XdonFfBr7t+N9aW
         8ciokV4iBmsx64IjE7P1xa7ClIvSwcccenZ6dkvkaZ09ReCi8VaxKQxQo6M36U5zIzN8
         NPHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770642419; x=1771247219; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWW2dvpLSF4DVyfBqWuCpyd4sQ2XDuJUQdmIqKmHiRU=;
        b=KIvpWnhJXBgYdEfDpILdtrbiQn9YFLW5g4qVfucQxcvaUTkjhjHqUf7tJChXmysaQw
         5mVMp1nBqKyLzZ+G7X9TVKQ5KmRWZ3ev3JinKHYJwdJU0c6q4EV+Sfileybc9EF6Ewci
         j9qsovvlM/V5NwqYfSgUfHXdTbZywspeuJchpYp5qQVLwNApmL21nYO87xiYidRd2ADo
         4JtoS5Fdp7gcdpFld1JKgT6iy4k7I/EbdUOiLjbcatx0+rG4f/QMpuJyvbbBFoT9xHcO
         A4KPp/HSGyxie9A2UfQEqonDuCMam45+fp74DJIB7QtESucDEzfhpt7NELJDAI0Tarm5
         pjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770642419; x=1771247219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HWW2dvpLSF4DVyfBqWuCpyd4sQ2XDuJUQdmIqKmHiRU=;
        b=GJqP8nNk9efmgQ0ju+VuUZkf/IEsqBi2dPYQ/kiHzsua5SFjym4ovmZnbEd4Dz5R5d
         BO8HRIeAKGpJZCVge7xaNJF/oqjADjelqhabkwhuabmeKY5pq1M7HKUEq+P2Nacn0Zd8
         i1lKYqnMDpNYvOf/8k6S5XfEwxIhn8FGoJmT8umczEK5K7+wbLRPVt0Cn0ZMVOH2GOsH
         egx9zcgFPqSDgYHXw6k5XDD66ZU4ibY0PiDkjS0nnAW67cMWFgGypB0ON3r5QaRKgeCr
         YtHHLJbJMFA7DHHEu13kcpDgxM1AHd8Mw2JY+H+qv14ghegMlv0o5q270CFgnLxhyWU1
         bhHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA9YstmhF7yw/2vlm8PPg51tep3Q/AIDl3cd5LEV0TIm8AjDdFWBqyyI0g78OktZyLw1MVGJ8Utw==@kvack.org
X-Gm-Message-State: AOJu0Yw2fr+EPnhN0/v1Z8wSmlwEAa1DNx955Drb9sM0Q2/hd/ytCSjT
	p1uETTXTs3JXI9RklK3Kro+5BHYxaKQepZLfypSVPxrtzPRcb9JJbAXQDp+lGMfG75LeJnVBAwV
	w935y+xs1GCCorEP7Xdgzk9MUr5H38OA=
X-Gm-Gg: AZuq6aJn0VJrKEFbjFqu1MfN3cMzSlWiCdY4l68YhKY9r+oTIg29vKGc6yFvlWN4CrB
	/jJkQhpLg67ifnxdcNO+/B9jF3hD4Txrj84lNqSGt1rY1AcG5NRYL4oVTEtBtb8gS/UvXVL/9VN
	RUsk1qad2oWFALMx9TclsqNfYQSPDEKd8XVm8YM6ULFi4Ls7YOsEn2Zm4zNe8oFdGkOGNYZmHYC
	byJwC390gq8OxPHkO3tyy85lVkDBs/EteJD31ImO4+/hHyZCWLEKoWxJNf91QxZ3m66lrq2ef65
	1XG5iJn3fDqfRiXJO5dms3U1Vh8ks7AnPyMoIQhJAGgmqJyzp/nx6d+1nF3n4E0x5aXWHQU=
X-Received: by 2002:a05:690e:4106:b0:64a:db3a:f846 with SMTP id
 956f58d0204a3-64adb3af9c3mr4460457d50.85.1770642419041; Mon, 09 Feb 2026
 05:06:59 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
In-Reply-To: <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 9 Feb 2026 18:36:47 +0530
X-Gm-Features: AZwV_QjiKYGdWwPkUnVtXKZwmEjXVmwqYV1pe963qiJF8xJEq7WmyxztRDhej7k
Message-ID: <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, pbonzini@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F5D118000D
X-Stat-Signature: 1fwms7hu4j66tpm7caou44yj987snh4a
X-Rspam-User: 
X-HE-Tag: 1770642420-117063
X-HE-Meta: U2FsdGVkX19y0qVIi/42sUEOPnnU4zi/qx/eQzw87bMI1jxMHUbZnBrYQAP/yLEMLPCqIBmDVXIqMlrTzTxCEJePnWUNGFenCdOCVzwK8VyFDAsYQueBfyA6jbR9j3XeX5kMlYnjgWVd8vhWKRwKwjcyAXirO6spQVBWRR5x0KtiLg5DF35y2FL5lAzU/z8dM+iYqzkEyq3PLLF+SPVetauMV5jlyYr8AXDopsTtQnxnFylb26amZAfdYYCbvYT5H2ypk+YMd1BYmdLjia6b3O5wBLsTGdcoHNkoksvNz4RoRNEgpjF2B9sroKhtiRkd1Km9da2lsFYuBVoQgDH9jnBpgsiBmvNvCQdTCOq2xL8NcSxr15HpasGgRnDWu72IrSAKy5q+/N+Is1+cPDwzkUBMmW3+FD4v08dCl23S2FVJPinUeHn86zXpoHs0eWUjq7sdX/gywCoUz9q5fhf4690Yjs6qOJYW1qFPV3A3WJzRWmRhri3wH/S2Wu9R4iwfYVIdMNKhsN9kp4vNjEXT01hW2iuMV6sAuVsek4y/ipC/tXM3an9EmUuxTfegGXvr2geh0XyHMW8pOaJaUoYB3hjGkEn0TBJg36SXCY2Z63bX7pWV6LhSuqf6zWYNLN8XZ25jSfMWe5p9wEHyTESRvb6oP+6ASN0bBQy+maxB/pDTd3xdG0B6hFYOqtoj2x2CCVClCHPMy1om4ngNZmJSl0ozNLmnw/2qyDF/uQFPoQr5hw074K+kuzrRLvEhXm9RnKM3RUAtRDEG8ygiprQ7p5tmv8XiDzaBvoA7ogA4GSPp9bBW2HVUkY1Xpd4JPf1uifY0p+4dhYv73midf9XuxVTGddQSsuwqodjcgkOP1azr3EDaiaGntwzOCWxa4/+Hy6CaAV4S0e/TsRkF0ooJGREFT9ZsywrImBBgTr1bGS0PFrBw2rDs7GJS4u/TEfB0Vj+4tcK28BM1Jt/eIda
 Wsl6SDXs
 luhE87+NIpJgqZ3RIjXET9Sej+j1SIVTTP5Yqh5mQivUJIC+WWjCQSUi8vV/xj0rSbON43USFu0oa8Pw1ngXAbIPhuSbVB/0ddpnkAuzy1FgiY+UAo6vk/W3OW5GOaO5Tffk8bChTNP5oEZ67+rS7kcNdm4LdVmGmIwylhMzWa+URgJZvnS3YcyMYRW91PK1uZUHOBXMebj4HiouKYjv2AA33uiggBrqzSc+Y08H9w2b/UuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 4:12=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> > Maybe introduce a AS_NO_READ_ONLY_THP_FOR_FS, which we can just easily
> > rip out along with CONFIG_READ_ONLY_THP_FOR_FS later?
>
> On second thought, why do we pass the
>
>         !inode_is_open_for_write(inode)
>
> in file_thp_enabled()?
>
> Isn't that the main problem for these memfd things?
>
> Maybe a get_write_access() is missing somewhere?
>

Hi David,

Thanks for the suggestion. I looked into the get_write_access() path.

Both guest_memfd and secretmem use alloc_file_pseudo() which skips
calling get_write_access(), so i_writecount stays 0. That's why
file_thp_enabled() sees them as read-only files.

We could add get_write_access() after alloc_file_pseudo() in both, but
I think that would be a hack rather than a proper fix:

- i_writecount has a specific semantic: tracking how many fds have the
file open for writing. We'd be bumping it just to influence
file_thp_enabled() behavior.

- It doesn't express the actual intent. The real issue is that
CONFIG_READ_ONLY_THP_FOR_FS was never meant for pseudo-filesystem
backed files.

I think the AS_NO_READ_ONLY_THP_FOR_FS flag you suggested earlier is
the cleaner approach. It is explicit, has no side effects, and is easy
to rip out when CONFIG_READ_ONLY_THP_FOR_FS goes away.

Here is the diff:

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..23f559fc1a4c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,6 +211,7 @@ enum mapping_flags {
        AS_KERNEL_FILE =3D 10,    /* mapping for a fake kernel file that sh=
ouldn't
                                   account usage to user cgroups */
        AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */
+       AS_NO_READ_ONLY_THP_FOR_FS =3D 12,
        /* Bits 16-25 are used for FOLIO_ORDER */
        AS_FOLIO_ORDER_BITS =3D 5,
        AS_FOLIO_ORDER_MIN =3D 16,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..4bdda92ce01e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct
vm_area_struct *vma)

        inode =3D file_inode(vma->vm_file);

+       if (test_bit(AS_NO_READ_ONLY_THP_FOR_FS, &inode->i_mapping->flags))
+               return false;
+
        return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }

diff --git a/mm/secretmem.c b/mm/secretmem.c
index edf111e0a1bb..56d93a74f5fc 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -205,7 +205,8 @@ static struct file *secretmem_file_create(unsigned
long flags)

        mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
        mapping_set_unevictable(inode->i_mapping);
+       set_bit(AS_NO_READ_ONLY_THP_FOR_FS, &inode->i_mapping->flags);

        inode->i_op =3D &secretmem_iops;
        inode->i_mapping->a_ops =3D &secretmem_aops;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..b93a324c81bd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -597,6 +597,7 @@ static int __kvm_gmem_create(struct kvm *kvm,
loff_t size, u64 flags)
        inode->i_size =3D size;
        mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
        mapping_set_inaccessible(inode->i_mapping);
+       set_bit(AS_NO_READ_ONLY_THP_FOR_FS, &inode->i_mapping->flags);
        /* Unmovable mappings are supposed to be marked unevictable as well=
. */
        WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));

Please let me know if this looks good and I will send a formal v2.

Thanks,
Deepanshu

