Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E4EE6FE51
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 22:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339076B0005; Tue, 23 Dec 2025 17:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E64D6B0089; Tue, 23 Dec 2025 17:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F32E6B008A; Tue, 23 Dec 2025 17:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0749F6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:46:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA0CA89988
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:46:58 +0000 (UTC)
X-FDA: 84252222516.21.62A9222
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB5A21C000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:46:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N8QyS/cS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766530016; a=rsa-sha256;
	cv=none;
	b=QUw4h3FeeaK0KPpORiA9zqs48G0SAvq4ZbnCpVnY71fxEiBvHzQy3gFvjYAnwV61H/+NF+
	bYwKjO5+tnxNOn2Q3CZ9dcQ4z2XkrPQ+A+enNJAeHRoO7hNT+FlgYn4bdxdPkSPA8xq3bN
	32LgDawRPLUBsaMuv2Lz35QFSaDz8hs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N8QyS/cS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766530016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpF5UP60/rzsZuLf+m+o+nRJR8ZnOkcpQuR13iDk7RY=;
	b=Mvc5jIK4hxbw/ICW3XT/q9q46lLumO2A+O91cWJLLFOombnZ1MRfOjCaO3AAPJOO6b/dAT
	C4JSPZqFKzgtWCPto1tRZJ9pyxXuyls3mPxa5L7DQAZvrwdFrXbm1PskQcvowXlGSNNzTs
	K0eyZHiwU6Lqpy9Ad3WJpncaIEF1Mvo=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a2b99d8c5so40218716d6.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766530016; x=1767134816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpF5UP60/rzsZuLf+m+o+nRJR8ZnOkcpQuR13iDk7RY=;
        b=N8QyS/cSSzlYGj58n6ywA85P6eipQLE2yoAJVZrO/2KgzQNI+5CP2lWelBRjwJakQl
         kqzUyLAen3pPzjicSc8HkmVAjhHhUwO+aR6UgvviKhHIMXOXwjjvZe0fas/Ji4crgdTB
         cmfGwNjrsuU3J+JOOIyFWsBWMkt/CGFPrW+q/SRvGrz19SnJ/elOb1NcnmqD0jupmE6I
         I8ulNpfgVmvgBfFfBJGybdUqdKvujq3RHu2FUVTD9d8jsVonY+/KZ5d3u0ArhoQI1CX+
         wIR8cmLTJn1VYqetZ4sDRjoIvcVf8yGQVl2aqKgtcGw/nthC1Rn8IyX8TPBMGODefqHO
         YqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766530016; x=1767134816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zpF5UP60/rzsZuLf+m+o+nRJR8ZnOkcpQuR13iDk7RY=;
        b=pSdePFHJKKSer6VJkvahUMgJpeNSGXGrXut1zCn/PQOVHi2QS2ORtvVLW3fWYJKsxK
         lZkcIRaOHwRqnpLPkvHah60r2Wlef5K27i1Eqa8Sqzk3C7sp6Ec/4c9w5S0SAO5BDN8X
         xkzl29P2t/F4qFcY295Z85mfOEszhv99tSIyOloXZ5PyAOGPsf6fqMXwi5AGG2tlPKJj
         qSdNQp4bKVBCuIV6ksIiwYrsfVUq9EZK1C9HdojVyl9xjG7+T9t+nhyB+g56uSCEsOq9
         F6YyVy0+CA9Jw7yPhukoMDzo0pA9M+E1RWosXKNfKwoDSJQCEyJjyx9kEQqRIMO25Dq6
         lPzA==
X-Forwarded-Encrypted: i=1; AJvYcCXFmp0lLH/nW8NWORkVgO+TC338AvwWFdK48QzOpFZ833F4zWEn8E8AfwoG8iG1/r7n1FiXYO0RTg==@kvack.org
X-Gm-Message-State: AOJu0YxZXCb4nl7btwdEC+BOmGzfSd1fGaXJci0Pa9rh19V7LI4ydz9N
	KFV4Mry/xHW2SDQKdilkUMQsKq8pXavrgDVXe3B7GU6ymKNtynNVPX8KJtdPgy3cWjsDlJMQmNR
	IOOjws8/5rl/Tu7ZtX9vNeSXva80ZkGo=
X-Gm-Gg: AY/fxX4Xyze/Xe9QVl2N9ng9STd1RwbSwMtJbTb09gfpuw3oPgqLFUYaK7ZrPXXh9yb
	HnKmuZI59aBl0RqrLqn97p+mhwaUZI3f/GSDwYfb8WTascR6Fh+b8qQuRbRyacTfDu4Q+4Ss6Bl
	A+h7/gz63hMgCSuPzOhuATCOCIrhVdBhSp8qrbNb73vd5cjG2aPMi4mVEc47HZrMFx+M38eJTHe
	Km37ozsiDRCQaLdJzX6FO0n/MmA8rd5V8yk+K2LhgqNeDhMmW22sdLououer1+T5dcRMg==
X-Google-Smtp-Source: AGHT+IE938wNEPaLZPltBzdnAMsfztao26G/+Iic5HapTSkvMaU6IBZ1rUfupGogiF0ZOIc5PKvZCRFAe0EiDMuvhco=
X-Received: by 2002:ad4:5c68:0:b0:87c:2360:d404 with SMTP id
 6a1803df08f44-88d81278b01mr272517186d6.7.1766530015663; Tue, 23 Dec 2025
 14:46:55 -0800 (PST)
MIME-Version: 1.0
References: <6949370f.050a0220.1b4e0c.0038.GAE@google.com>
In-Reply-To: <6949370f.050a0220.1b4e0c.0038.GAE@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 24 Dec 2025 11:46:44 +1300
X-Gm-Features: AQt7F2qilzp3GLkZFHYyCCu7gukfo6SnbVeg6EJzZG1zTeLzCjcD_xzeRleg49A
Message-ID: <CAGsJ_4w3FQXS4YvRjfjRQrzjjVT3Z7WtvQLJdy76k-yBZ2es6A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
To: syzbot <syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, chrisl@kernel.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5A21C000F
X-Rspamd-Server: rspam10
X-Stat-Signature: he4e9gymj4k5akkqi4dnmcngym4mxmd3
X-HE-Tag: 1766530016-652130
X-HE-Meta: U2FsdGVkX19mbY7CSPtFdadcKuk3oPfpNzTwTuNOI9P0MGwrsClOF0gu1eYbjUGIHp7++gwzFiNn+iU03TqzBegcxtsAp2fRO2dB3B/+cooI3hxv9ukAKx3T3iJQBKOCktdEzr3fcWMM0bd2/ZXqtlNaql4IEzK85n/1AFKaSsNFKCcoyp5ZjngTF2Ll4yyQXGi0725mYQEAIl+cO48JYMCjZpWwf0Y18/iG6KGsITsFlMrd9AT02MKvFiD0495bM4gkorEJnvYZmkeO+mHA7BlObBu6QDN44DPigqgzJPNYTk6FADJsDRilgZFNOn7ikIGoYjcgkWA1hqbl4G9PE8IBi3rvMZZ6ChmHT3lqOww6FId1XPXdhD/ANNbOQgMSxc/tB9wInlCw/90nGreb9kw/exqlon+njRtGjQU279NmXk0deMLCvAT0qwt4k+8/H1+SGocAwCZrmx/6RtgGSuC8C+EEptVadgK9hW1fqZf//EyDF5fs0NvBFAKHcBVckE6JD5VrmkhWJthmvj0LrxywKKh6slgYA+ZmlNfQ3TCxWlOLrZxVhcdTAUnp0YADfGfVqa7O1m6OxoBXWSDJuSkm8orOrBoU2RWMJrz3rAbTY2g/RtJmpsFv/pgpDVNQGDRKaibJxOjIkK80Ca/Afd9wkzwRvNL7pET1tP5whwstrmXDs+8vEbhSX1kvial15pa9XsrRZQlLC8p/pl/Vb6qdfg38X/AJrimoYkT/n9F47D6eIO1XaXZjlkJcox/MBUbbpzWww6H1oyxVKCtTDDd1tJLoPiKNJajndkRPvuhyrXEGOym6TpX1KxQkB0IVD5mJWPBPcoLQRLvowGlDrl/s+Yu6YPED4gvte4Rv9ON60SrVPTccYUqekh1X2YWN8aQAKx60F/3KWmflIddSDDQdRb1oXOfrDPdodPEUHgPe79CthyZ8krSmRUrYLkEjiPqA584X9o9zvHsdD2A
 Pn8TTf2W
 uWxsj8cbjyNDSU8CsNp3d+YIZpje2//4KgdJiW77Vz1h80AT22lQyJTpB57ZNJXDXJ7k8UyP83nkybTzWS7tKBc5bInKSLi4DdW4+vVyA4fWnteizwWXZ9myHJgyn3eXCQNIJdG72eoVuJpL2c0O33aESR0mmdPoNWRXShohncrE1LeokUG80aAfDcpsf/hw9PCLUiqaTdH9P9mT5t7Ioj4h8eYhnSFNDlJ6PRh/lR7/1SUdb5x05KpYQN+WtfYnJhTHpyk3N1hG1NkEhhR0BIW+MzUYPkFRAII05kEU1wp9mOZPOsCgR26TheoB+SSJDndbSe0ksspKPuJLV+lHYPb5D21M6fRaTOiIHxI9PjQSpyFbYIhq1M7WAAZ0cNzgOaIBLVzAo0GG5tMEgy8MtiE7jH+bwMlxAFdZbiMeOZAjDziM2D/tWTgL7CXylsux1sWO49gtScr5XLp8Nlk2tGYYIVLGsSjMtFlKR5eBjgRNtcmtxXQaAKT4evwutwFNjkKIGUIsU0FgDrJrTF7Bh1nIUT9FWreuIuHiN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Uninit was created at:
>  __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
>  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
>  folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
>  shmem_alloc_folio mm/shmem.c:1890 [inline]
>  shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
>  shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
>  shmem_get_folio mm/shmem.c:2662 [inline]
>  shmem_symlink+0x562/0xad0 mm/shmem.c:4129
>  vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
>  do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541

+Hugh and Baolin.

This happens in the shmem symlink path, where newly allocated
folios are not cleared for some reason. As a result,
is_folio_zero_filled() ends up reading uninitialized data.

Clearing newly allocated folios in shmem_get_folio_gfp() would
fix the issue, but it may not be the proper solution. We will
need Hugh and Baolin=E2=80=99s guidance to recommend an appropriate fix.

>  __do_sys_symlinkat fs/namei.c:5562 [inline]
>  __se_sys_symlinkat fs/namei.c:5559 [inline]
>  __ia32_sys_symlinkat+0xf5/0x180 fs/namei.c:5559
>  ia32_sys_call+0x385e/0x4340 arch/x86/include/generated/asm/syscalls_32.h=
:305
>  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
>  __do_fast_syscall_32+0x15a/0x330 arch/x86/entry/syscall_32.c:307
>  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:332
>  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> CPU: 0 UID: 0 PID: 7862 Comm: syz.2.517 Tainted: G             L      syz=
kaller #0 PREEMPT(none)
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/25/2025
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Thanks
Barry

