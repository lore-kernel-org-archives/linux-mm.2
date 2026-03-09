Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FB5EA854A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82C86B0088; Sun,  8 Mar 2026 23:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FFA6B0089; Sun,  8 Mar 2026 23:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BE66B008A; Sun,  8 Mar 2026 23:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E73F6B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:15:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E76671C959
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:15:11 +0000 (UTC)
X-FDA: 84525058422.27.FBEB79A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 203AA180006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:15:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IfBV6qEH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773026110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SZSiPj1NVyhvizWhUUC0wPEd9YxwtDfmbckRRyPoO0c=;
	b=34LGLRsntexsFnDw6ME3Z4MjVk3MCSbGb8fP+QwPWrGOWKR4V5nP9coR7ELjRECZ7FjZh4
	Drs40zfQFBaQ/faCZdW3xoQHvELWuGsgAd1/OC95Pn1gKVPnOi39yaQ4UiEdfJ/R57DGeQ
	BolDpoTMpKkdRjOKW0/qPi0sGs00Fm4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773026110; a=rsa-sha256;
	cv=pass;
	b=U3MJc1Vi0/Wmjl/W/ulv+DtnqzSgu8PbPyZdniCsucBfWvBJxhs7xV0HTuBsY/oD3NGZ7/
	QGwkzybaF2LJhvhfk0d8PYqr2yuN1mIEp+jecS0qNQLEzQhzgS6YffKQTiqriXZPhAkAF6
	MhF1yVlO02VTpwTe8rF88xn5moXJVDw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IfBV6qEH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c73bbdc01b7so20453a12.2
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 20:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773026109; cv=none;
        d=google.com; s=arc-20240605;
        b=i8rIGrOSn5EaqSYQQtu3fdSV1Qp5tDW5Tnhld9PnXCHDvLe0vRTB3XHorqSJbffJs7
         vope/s7vuBll6esnb1+DA68NF3eS4UVfn0hKvFha27wFujIXR8BtlInvoEhW2LSiJs7l
         NoYGlsfNmY1lIwk4Cf7NNejfATE0TgCoFkzCqar+nkFsQG63N78a3uASLkYr/0UIXbCp
         /S9b7tWsYJspWPV+GvOC3tE4chw0mesLwAyUAmRICGljPozyIxp4L2PnQydXfv/covW1
         byYco052Pg862n/VpT9tYaNAVKMCGolmhe8kH6XcnU6GgrV83/7eUMPFHq02kIB7H21w
         wCIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=SZSiPj1NVyhvizWhUUC0wPEd9YxwtDfmbckRRyPoO0c=;
        fh=TwTGnHTQZLvDJJp5uZIepTM6bLBGHig1lEITCj/3Isc=;
        b=dCEp2XbpD0YROiIwELkj5Zml4iRDAiyVw2kM4uB2qFDlz/6fUC90i2wWJSxTIESr28
         SlpUmMC7fAY1AtDDh6fVmqaJtMh4SEeUU0ggmbzM3UkoUJQ9VqJ6Y1gbVDDEOdTxklim
         flCuaTDz9UTK7ksgbksBH+7VqUB8SvVJlJ6O3XhG/23b2SF1wC3ueoZhb9Fw3wLqdbgM
         Z3ivvV67vHEVIlkuSM9fN++g+/5gDHFwpXRVzvXGcmbgFVYs9W9cKXj0fgMDKXnFcJYj
         SQqmz307NUDVUFx8XAZr6n5mYsCGm1lB6DDKwKgdHEs55vgzkoQCWYDoFt2gUWhrE5dQ
         MUZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773026109; x=1773630909; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SZSiPj1NVyhvizWhUUC0wPEd9YxwtDfmbckRRyPoO0c=;
        b=IfBV6qEHzQKiZ7rTTypZ1NQ96dkha5hguaHwjPaxaHy3pYRlYtjZTtPz+98qM3v5Zp
         TPTtJRKp+iZB7QS4KXN5TB9c4Ztm7p7iO84DzJstM80H4JHnho7PDghoV/YvDYuBzApp
         OwUiZCNFz36FgUc/FFlOBsd5yvYvhgS0niY+DMNhOMThnIVdzY2PjUtHAn1pSYhgsVLe
         CXqsDJaIvV1idsCMXPHbKabWnqJVA6AgwSYKxeEPu7n6SChQJmZfCJ7iwbDEQwhazzZp
         1y7pw+LO78PZ6DJXF9l1+T9/IlMYCK1g9SjhpecxKsnL5MFTXZQwBQsvXaydXxEvKD8z
         pSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773026109; x=1773630909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZSiPj1NVyhvizWhUUC0wPEd9YxwtDfmbckRRyPoO0c=;
        b=kdc4fQd5Rf5hb0uIikU+CmJkGYPDwhevT18Ld3Bax6QNPNbMfuhUp/ZT7EW8dx1Dgb
         X+HpbaUhJ8OKPbN6tuRlQXS3vTous2seTyH3yNMXBZMrcfp++LdYeMlJzHqWvn+mxThg
         cH7HWbV/U5sbaYg8rWJ8OVJiUm4qZQnXGW9hmELbEq8dMqOqo6go9ohyrrUEagPyifgG
         zffCXj14+PAIowNvXclMPm+dBvoWrSXHevwuwg0+4FnbhVLkgMoNQ1FZvFMEJzoRatr9
         Hp/VGfPqd2WmJzwb+kHPn9o9TGCboOdZ1e/RhSKyvW4M+d0xOZ++MHZTEK8Nac7cGVMF
         8Ktg==
X-Gm-Message-State: AOJu0YwRmlJ5jidUtmb+6yx1jp1Qzh6Uzl3xFMafqCcSd/d4UHsbbOjn
	BHxbiIJHI+FRnPWY1BKbYIk813Tw0e22VWzmLrBu3y6w8Bi94LBfKvtn5MWfswSo/fhuno158wk
	YQ71OG6xulzHmqwRiPjV5mjM7ra36Rco=
X-Gm-Gg: ATEYQzyFFD/QEJi8OYOCImm7kazxdQQQ6dhoh1+JwL9ktjkkuFojNlh1Ky3pITA+vCJ
	For6b06zpvz4luZPAyXelF89wG4C57b5o4T30lbordloc90JqVuANBktpZ3fUco7GTcr3Mp/Fic
	lnpn6gvea5sFip0Yr9Q/HKMM1xAut04H3kXW/nNlLUVdU/AztMTMsFjaoHtMend+tMJRChxyZYg
	cs8qHCi1CISk9PchbOh87zpA5uSD/pQOayGS3sU70FlFWQg8D5jmtLoVIIN1Uyl0H3Upo8uDOk0
	Pwau+n8=
X-Received: by 2002:a05:6300:492:b0:398:7d6e:27f1 with SMTP id
 adf61e73a8af0-3987d6e4e98mr3093477637.9.1773026108783; Sun, 08 Mar 2026
 20:15:08 -0700 (PDT)
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Mon, 9 Mar 2026 11:14:58 +0800
X-Gm-Features: AaiRm52UI71Zsv1DyyQfuTtqar8_kcar-WvI_WLGIKWrKj10BzZgSbMrapZjPpE
Message-ID: <CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C0gFxC6xGOG0ZLHgPmnA@mail.gmail.com>
Subject: [BUG] WARNING in alloc_slab_obj_exts triggered by __d_alloc
To: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: tipp7xyqqb8ggy9gpwj1gqzsijiqqrxu
X-Rspamd-Queue-Id: 203AA180006
X-Rspamd-Server: rspam03
X-HE-Tag: 1773026109-713573
X-HE-Meta: U2FsdGVkX1/t3IR3GDmsAff/DZq6Ru+T5OMZZA6D94RKAdiIEbFay51mTYk/BOwDJidnFDOdA3IuV4ra6RJdBC+WUB4RwN6WZTuZndEN+ge1fzsemrV3GtgabBkrvz6lsh+gVSkm16eKz9lbQzvgFuSlbZH43T9f7/2LQbO5XG7rc64dvWIKdB74LDTjSOUKPSrAdI/kQBQu5wYdNcF6N10nvTtOYESmTyFR/zxJXc2GF5E2xQOOzI8yqtzICBIE84jGoE14QVVDd8ihfQJwI0yonk+DCYhqhUN0N47/yojzw7PSyJ4zB5An8zbh0gPhKAIqaZZzx+BO3OdtUFPu9qk/YpTXOIFyb4pf1ry4wZzWjpOz8KYv/mOJGsbGop+cK1GrTwUc/ICP6A6emsLHrDn2BFn4zOgMIf5zlcKWFNubJm0qb907XJzjN8NrcHK+g+F4aqy5cjyAAJpaqeeHDuMF5nxE+RnpU0GOIxM0uE6kSfLW0HJC6M/3zlIz99AQZPXvzcq6ls6YXq+wM/ytJp/wKYKQ/ASVtKP7JkasGJbCiwjzkMT8U2p1NSppcOqoDzw92R/vBvXEd0ts9PtCMy71Kac58KUA5D2p2wnZHf3bK/feLKoybg0pbnvnKpN3zqXYUP8j/7Hr2Z7034RVmA4ATG2tM0JYNxfj7082qzZWBRw4+MiOtObawqL+zeNByPCdotlmUeL28ahOrxFkKpGp/RAV1uB2SyEYEjPGuojOEm9DPIDudoKlNSeF9MxwiPugX6Uku2608KEuQpoy1EMCl9cNPEv/nq5fbAyMGjZOjCAWl8o417jC4hB/i3ojNeDF9dUyxKLUux83oJa9qLqFHkICNX85V+4ufCOrn4R2esFOdVv/jIRtt2A57KNZA73gu+NmVsNAAMbvyUTGyMm7tqiZfUHy7/h1w8slGEwFpcfYqxAa+ZYmkocUFVAELNqgJBSvneJyNo0D2h9
 IuDhUC/U
 Ym0lus9TgcAGh3X+oyajcSVqQwOUNQxa7tb601Sru1ihnQjgzpa+uD/yPR8gTTU3nnW+hieqF79qJFBuKphmQ2xWy4mTvVBL/Izul5zKZJiz0jrWx5lX2TNvgvqUTxzRwkzBxT5KyjGWutfgKeBcZnmPHrQRcyXnlStKmqCVQildG3zJys0YNQnkiHs/V0Txh1DmZYXG99s+hKSHqAUmPwTsup5vRLkXxN8vJRHNlMv+5Qf0WJLLaSJUsF5SMj5vyKUYSOQHkHP7RNqPgo8ZhJS0Gkq/Dhig0Fu4P3gOIvLWs5OaZUm++Pmf2iay7Ye9fjVYP63pDkdT8ftdrf9aiFOBmWK90tOWrob9PTd6VQ946bPgDj4h+M763loYmmjRfoY2kvzBCIiMv0HWIR+FGd18wnh3LWAEUtJ6P6ZgFjqFR+eegPcgP8GYThwNLCg8owxhc1eyd+s4n6Zo4Y5OCvSuBpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I encountered a WARNING in alloc_slab_obj_exts() while running a
syzkaller-generated reproducer on Linux 7.0-rc2.

The warning is triggered during dentry allocation (__d_alloc) after
mounting a crafted ext4 filesystem image.

Kernel
git tree: torvalds/linux
commit=EF=BC=9A 0031c06807cfa8aa51a759ff8aa09e1aa48149af
kernel version:Linux 7.0.0-rc2-00057-g0031c06807cf
hardware: QEMU Ubuntu 24.10

I was able to reproduce this issue reliably using the attached
reproducer.

Reproducer=EF=BC=9A
C reproducer: https://pastebin.com/raw/eHjm2Aw6
console output: https://pastebin.com/raw/FQAhquTy
kernel config: pastebin.com/raw/CnHdTQNm

The warning originates from:

mm/slub.c:2189

Call trace:

WARNING: mm/slub.c:2189 at alloc_slab_obj_exts+0x132/0x180
CPU: 0 UID: 0 PID: 699 Comm: syz.0.118

Call Trace:
 <TASK>
 __memcg_slab_post_alloc_hook+0x130/0x460 mm/memcontrol.c:3234
 memcg_slab_post_alloc_hook mm/slub.c:2464 [inline]
 slab_post_alloc_hook.constprop.0+0x9c/0xf0 mm/slub.c:4526
 slab_alloc_node.constprop.0+0xaa/0x160 mm/slub.c:4844
 __do_kmalloc_node mm/slub.c:5237 [inline]
 __kmalloc_noprof+0x82/0x200 mm/slub.c:5250
 kmalloc_noprof include/linux/slab.h:954 [inline]
 __d_alloc+0x235/0x2f0 fs/dcache.c:1757
 d_alloc_pseudo+0x1d/0x70 fs/dcache.c:1871
 alloc_path_pseudo fs/file_table.c:364 [inline]
 alloc_file_pseudo+0x64/0x140 fs/file_table.c:380
 __shmem_file_setup+0x136/0x270 mm/shmem.c:5863
 memfd_alloc_file+0x81/0x240 mm/memfd.c:471
 __do_sys_memfd_create mm/memfd.c:522 [inline]
 __se_sys_memfd_create mm/memfd.c:505 [inline]
 __x64_sys_memfd_create+0x205/0x440 mm/memfd.c:505
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x11d/0x5a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

The issue happens after mounting an ext4 filesystem image via a loop
device created from a compressed image in the reproducer.

Relevant kernel messages:

EXT4-fs (loop0): mounted filesystem
00000000-0000-0000-0000-000000000000 r/w without journal.
EXT4-fs (loop3): Delayed block allocation failed for inode 18 at
logical offset 768 with max blocks 2 with error 28
EXT4-fs (loop3): This should not happen!! Data will be lost

The WARNING occurs in alloc_slab_obj_exts(), which is related to slab
object extension allocation.

This may indicate a slab metadata inconsistency triggered by the
filesystem state.

Please let me know if additional debugging information would help.

Thanks.
Zw Tang

