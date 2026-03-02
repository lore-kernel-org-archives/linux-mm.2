Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82A4E9B357
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367816B0005; Mon,  2 Mar 2026 05:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3490B6B0089; Mon,  2 Mar 2026 05:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2553D6B008A; Mon,  2 Mar 2026 05:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 109D66B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:29:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76E728CD01
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:29:40 +0000 (UTC)
X-FDA: 84500751720.20.A5CF707
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A537140007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:29:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BktTLO7I;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772447378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/njpkbtZVt3Kl+KjZ5piSQhFiqZBY8slUODGXpsT5Y=;
	b=0FuJNdGLacCOHmH5g9GjQ8T1bR5nL1Nuhv6xI52nRXT+rO6zwMD6g3u++bs3EYzAYPI0IJ
	3URXa2AwQllIgqSC8XoINJb+apTiNms4uv9AEj4gzOKJ4GwV9EwLNLM4nUsuBkytDd31e+
	qk2IO86XCykO/jHDW6AuTtpVIDmP2U0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772447378; a=rsa-sha256;
	cv=pass;
	b=Bw45xM0ha15gTxFD6AOkBPuxReemJM4tlT6VHyeRt4OsPr9oq/fgllLSbtrRr2SGMjU4xF
	3HKohy76KYKIJzb89y4PpR6i8Uu6AZGqAAvLs0ylK/zl/GnQLGkBMXU3/p2NPc+we69TYC
	4c10GQueSyLX1WtDo6C8QxmY6nHLOUg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BktTLO7I;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb3825b0fbso414600285a.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 02:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772447378; cv=none;
        d=google.com; s=arc-20240605;
        b=UIAxz3zhtiNWvNwEM+ALGQlejm7FfJVow45sl3RzqqnMLc3Zb+muiePZjm6XmERSIR
         AXnvg3nuK5zVZEYtaVjJdjZHX88JSDvVhh8fENS76t5voOK3b0YD8JawS7HIHD37ntmo
         LJLpjCA+NtD/nxJLytovXdIYqTexbrKVETzPETBcgkisuPPE/J6hHdx+c/oCjAcm2Jze
         iRBxCgPhuZTCRWXa1oNw2GtiXVrn+j7uqhqzn9DZeo2jnb8Ae6AAtbuaB9Ee6vtWvbS0
         WdKkfqH3sorC1CH0Podtwyd+xu2FvvKyIToumasQzfUfBbPtRhIWSymMD6hlSNqJ/ayU
         oJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h/njpkbtZVt3Kl+KjZ5piSQhFiqZBY8slUODGXpsT5Y=;
        fh=l9kA02ELNhaAeYPKjKSipP6P1sA9jGiNUfy6bn/fc+M=;
        b=QPeOhGeGREXLPOrfnPD7j/HeSMJbdOMpvF6ZhBxGIxfiDWA4ux0ANYQ97J6rjbQHM/
         eyWUS15twSQCjchbO38BFZLUAuCWhCcHh03Q8Agb/B2eie3li4kRM5bt9b7bdzuOD1It
         sxHWHYIBq/2L+g/QlMTsSSCwDlcVZ4Zu9RlajrvmI/xXcXVfSTGQ4JJktpYUdT1rsT37
         LG6vRew+BhpVfEnltn7gs1UUmRjtORJDftLQeEolhe441ixA1giChtKJeOELSceFJwUs
         VaQsyQ9OLrnqiorpoHKviUHxCF1UA5U2lJan66zvaCNqsVWzkQi9YLKJ6RRcTytB+RiH
         gL/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772447378; x=1773052178; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/njpkbtZVt3Kl+KjZ5piSQhFiqZBY8slUODGXpsT5Y=;
        b=BktTLO7Ijr6SoR7aa84dxL4c1a06xvqavP5vR2Uwlzvftm7nsYvE+A+h5+14gCiY3I
         EclduQTbZlQnrMY1sCMCWbSACWQWvvaA7qdVqjG+882WQ9LOXCcwVjD3J+wqV6q5voRR
         t8xcyG2uSctUEdUGQn7ERSowDE79b95VRzVxipW6lAot62JAACmZoTNsre289AOXjRFY
         E549Hk7+xjiuzE9vY5DAJwVCLQmsxJARxKt7ghMVA0LTaZJCjyqBsu82YGEMsAv7d96G
         eghlvsghoWZjpkAFEhRRVIQ1So0Fjd5izIBR6ByAqvlXXDae7odCfJ5K40XaDZKXQw1Q
         Mq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772447378; x=1773052178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h/njpkbtZVt3Kl+KjZ5piSQhFiqZBY8slUODGXpsT5Y=;
        b=GdB6pKVYRvi8dHAVFfZdG94RKb06w6ukAjw6+cnn0QKxQPc7Ln/p7bU1MBQ7Q8vvtM
         LzvSrQOk70qRjBzBIkMs7zYgm2Msp/gd+A9C214MnwNxn1uW4LZFxEXvnDOGmBMmv9dE
         Rv7u34XG+Bhk3e1sxZ6+paVlTTdzM1vpatxYrSi/L/ZsBZKYSfLAZqM5QpRSGwAJTTGl
         rpI/jtSEHclHK3WZKN25ogAzow/gyQxHwr2OsSmbBFTUMz3Xx1xYkyQriymmmP1qeaOG
         PtiHu3SRdYlIK1Bv9i2bzlCxgkgtyp4Ei/71g7+MOzy7S+pAqhBGlwukbPqwnUF06slM
         zBtg==
X-Forwarded-Encrypted: i=1; AJvYcCV1mohLkCEU++k+jebHP1w25c9wdTK/J1dx8q6Z17Z7L5/DK1I6Xl21f3qBY+Uw2olDNpRUWkAF3A==@kvack.org
X-Gm-Message-State: AOJu0Yx39r6TXPNrUdbO3W+/eOI7ywNFtL6xfT8E05Jquxggc/DDs6M1
	j8FXOlO/vyzzkxf5ZJSrQy6K/QL3HE6a6QT71y+BCygDZX0rqSVvIHaPNsr7Nu0tSndy6sXkp5X
	cZwNdlxVZ5pZ/tYG2uuY71mbfdsCvjprA0h/eg5+04e+MSa4OluFez0sd
X-Gm-Gg: ATEYQzyNOWr0ys22aN8+CjXe4qV2IE6RHka+4mPFJ32QCWahQgC5dx8kUkRj7SbaZ6L
	c+TDI4Hh1F4Pa0TFBiJE88Ef9lEGyXIB2itEd5EodTYHvCVJA8a2402khzW12q96pE1z0LA/xXa
	RrPKtCt6HefhGIfYeqp1JlPh3XkhjylknMKgul/UVEIrdoQENPPfFLeNJsckwWYCvPABt4dzXJ3
	3eP/T0APp8+NjDdkXqgXIKAnlx7sqJZ+P5fvfsiJaxFBzpNPTZepgzem8SArfN22wRRFccQXUZk
	jT9mzxDDS6wjarKUhHBKcKNdLbw62cG9SjoYhQ==
X-Received: by 2002:a05:620a:450e:b0:8c6:b14e:6569 with SMTP id
 af79cd13be357-8cbc8e3099bmr1545558085a.79.1772447377161; Mon, 02 Mar 2026
 02:29:37 -0800 (PST)
MIME-Version: 1.0
References: <2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com>
In-Reply-To: <2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 2 Mar 2026 11:29:00 +0100
X-Gm-Features: AaiRm53DRbj7sPLIop0CBXc5s2h5N9WBGDepItjpg99dPeJvb65reF4OaqPzMX8
Message-ID: <CAG_fn=U5weotUtW+TKmX_WRvRSaH+UiqdeDx-4foxVKK_kLNYw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/kasan: Fix double free for kasan pXds
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qizco15yhh7uzdyurrsrybkm4n1jsi4o
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A537140007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772447378-112313
X-HE-Meta: U2FsdGVkX181/AqQOTFY0I/WqlvRxXHFxa4/P4kUARJZLxt0UcUM3GW/Yms0aY97iWxvbGYfhkP/2XKeE0ieHDNm6jDldN4yGPC9ekHGKtnG/exWBow33tg1o/2AO2/th94wbHEFG8mI46HfRArtE5r0LM4pEprGQxr5PpEzc41j5ujiS3Yoh/SZpfZbusk5KhfQdUv4KXNRhTJ4QOyeEDFSDdUS9aMBt7nNBN2svDwnMy2XFHykC7CTADnAn6HKhMP4Zk810T2tqYGkD+QgZPusHCTUaGZeFbgD3/RCq+v6/0scWeYd+J+B9Z5sSSuhkS8USbPfHmYDRWRJcBkEy+/f6nYiXHeMU0Udpg+8VJdEhN27xwfjsOHtaIF9WHLi749DrxToKEI23jSDuvWMr73svjizoTFC1Jf3yQIrRMgBv2BN5OZ0i//J8vJAeG2dOBM2oOIjN01k9eStNAhGcR4aLbjP0r7NKbbQ9IfOOYGzbCz+lcJwtctvNXil+jHoRcmg6R7phQQXJdCsYJxfgm6D4p5HfJO4Lxah7mZQ/XMP0IS527hcHxlvlK0kF+8ROWJP7ILhquXhTmY1jlMjVNKbpgsl9lclZZJt4CHNwcyfXmRbJPx+tKvDHDB5oTycDD7vwUM5X+/UArXulu57Pwc+swT+08niI2cB1KMNfqIET+TWUKQn3OhutRz4ouMPEBFvioG2rf3r8zt/Ob7SoBjSD9yeNKyXXmtw6CMT46APwXc5mNpTSVWWa/ZQtWCZixjmFCtbd1G7VQOvgCd3VPMvjABBtQGnxMw6PkzCGskVElbDdC+3oM2r8WJMU04VvZwhmEbKCbywTOTCtJoWAVoECNogCKJdK5GUf70PCd4yX/KsigdbU9ua7cOfvH/ZwOjcpLLt57vnWSzkLM1VdKXortbubulDhQFVyZxrLk+Jyjem/PKyOhKXXY2O+3cy8HLl2QLWlbqGH/ip9Da
 jRXzPoaU
 wU5sqrbEpIt5lcDCX9kdmkJzlMJnNJPzQowSuEQk8ngVgOCbvEUxoJQAXC4DPHYhz2ZawQYQPCpSf5o+NshVVwTVNfMObvh4cRQiusw3hdvSff3pHWHnLNpb1ZoYlwJL1+d3BGcgAUraHoiZNwemyl48MMxUfiUBEWK9SeiQwJRcyOLaYg4feWC0OLEIMoctqRtW+hvP0DZjRR3e4bs44elm2zeBdukTx3bvcylNiSDPU9Zn+js7JJPp0lCmvS/d1JzHHG8h8iEwiauPKuUN/oUzK+YcONE6sKk63jhALk3QgjndLnuu2IRdkcUaqulMTZCz4KBSpoPKRhhDzKa28+IoMgOHt9iGD8q6Y+mXSN6gwx5495SrpQvHhZjzIqzcs7hJA1kfSvfEdf1h+kCVlUO1jnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 2:23=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> kasan_free_pxd() assumes the page table is always struct page aligned.
> But that's not always the case for all architectures. E.g. In case of
> powerpc with 64K pagesize, PUD table (of size 4096) comes from slab
> cache named pgtable-2^9. Hence instead of page_to_virt(pxd_page()) let's
> just directly pass the start of the pxd table which is passed as the 1st
> argument.
>
> This fixes the below double free kasan issue seen with PMEM:
>
> radix-mmu: Mapped 0x0000047d10000000-0x0000047f90000000 with 2.00 MiB pag=
es
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: double-free in kasan_remove_zero_shadow+0x9c4/0xa20
> Free of addr c0000003c38e0000 by task ndctl/2164
>
> CPU: 34 UID: 0 PID: 2164 Comm: ndctl Not tainted 6.19.0-rc1-00048-gea1013=
c15392 #157 VOLUNTARY
> Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:I=
BM,FW1060.00 (NH1060_012) hv:phyp pSeries
> Call Trace:
>  dump_stack_lvl+0x88/0xc4 (unreliable)
>  print_report+0x214/0x63c
>  kasan_report_invalid_free+0xe4/0x110
>  check_slab_allocation+0x100/0x150
>  kmem_cache_free+0x128/0x6e0
>  kasan_remove_zero_shadow+0x9c4/0xa20
>  memunmap_pages+0x2b8/0x5c0
>  devm_action_release+0x54/0x70
>  release_nodes+0xc8/0x1a0
>  devres_release_all+0xe0/0x140
>  device_unbind_cleanup+0x30/0x120
>  device_release_driver_internal+0x3e4/0x450
>  unbind_store+0xfc/0x110
>  drv_attr_store+0x78/0xb0
>  sysfs_kf_write+0x114/0x140
>  kernfs_fop_write_iter+0x264/0x3f0
>  vfs_write+0x3bc/0x7d0
>  ksys_write+0xa4/0x190
>  system_call_exception+0x190/0x480
>  system_call_vectored_common+0x15c/0x2ec
> ---- interrupt: 3000 at 0x7fff93b3d3f4
> NIP:  00007fff93b3d3f4 LR: 00007fff93b3d3f4 CTR: 0000000000000000
> REGS: c0000003f1b07e80 TRAP: 3000   Not tainted  (6.19.0-rc1-00048-gea101=
3c15392)
> MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 48888208=
  XER: 00000000
> <...>
> NIP [00007fff93b3d3f4] 0x7fff93b3d3f4
> LR [00007fff93b3d3f4] 0x7fff93b3d3f4
> ---- interrupt: 3000
>
>  The buggy address belongs to the object at c0000003c38e0000
>   which belongs to the cache pgtable-2^9 of size 4096
>  The buggy address is located 0 bytes inside of
>   4096-byte region [c0000003c38e0000, c0000003c38e1000)
>
>  The buggy address belongs to the physical page:
>  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3c3=
8c
>  head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>  memcg:c0000003bfd63e01
>  flags: 0x63ffff800000040(head|node=3D6|zone=3D0|lastcpupid=3D0x7ffff)
>  page_type: f5(slab)
>  raw: 063ffff800000040 c000000140058980 5deadbeef0000122 0000000000000000
>  raw: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e01
>  head: 063ffff800000040 c000000140058980 5deadbeef0000122 000000000000000=
0
>  head: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e0=
1
>  head: 063ffff800000002 c00c000000f0e301 00000000ffffffff 00000000fffffff=
f
>  head: ffffffffffffffff 0000000000000000 00000000ffffffff 000000000000000=
4
>  page dumped because: kasan: bad access detected
>
> [  138.953636] [   T2164] Memory state around the buggy address:
> [  138.953643] [   T2164]  c0000003c38dff00: fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc fc
> [  138.953652] [   T2164]  c0000003c38dff80: fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc fc
> [  138.953661] [   T2164] >c0000003c38e0000: fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc fc
> [  138.953669] [   T2164]                    ^
> [  138.953675] [   T2164]  c0000003c38e0080: fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc fc
> [  138.953684] [   T2164]  c0000003c38e0100: fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc fc
> [  138.953692] [   T2164] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> [  138.953701] [   T2164] Disabling lock debugging due to kernel taint
>
> Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work =
with KASAN")
> Cc: stable@vger.kernel.org
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

