Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51836F588CC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861666B0089; Mon, 20 Apr 2026 09:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838A26B0092; Mon, 20 Apr 2026 09:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E5E6B0093; Mon, 20 Apr 2026 09:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 633496B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:51:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C65FB140A67
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:51:01 +0000 (UTC)
X-FDA: 84679070322.24.0DAB0D8
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4B12180002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:50:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MD4zIDsB;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776693059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3b50RraaIawnD22hSCvT5knVr9IuRnQ6UaMDxGPXyek=;
	b=JVq7ZO3dYZ4It8V/0XWU0Oh8HTwibj/5XX7HHsIvGPqXXbiEyfHMYCWnYuiLMr4pxvp7io
	99CvVBhed5rRdwWYt3hhRtoJoZr0oCx7xBPtAb05dkRQFX2C6kOeuB8NNQ+MWrFUi3wS8e
	xJEdbji3GLjg5CReyc+yR+jReUjSNKI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MD4zIDsB;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776693059; a=rsa-sha256;
	cv=pass;
	b=5ucSOSh0MvklFZfDP0/Lyspllz+3L5EKmrUsg0iBjHZ88IqOoNBVVXOJslJMXc7vgsQ34z
	2eUZe9/tOdnFRaB26mYATMp5dBueE5OgHvsu7wgN9PoNJQPpk4DyubmQwntPsg9LNsIMVC
	s3Y9azDH3r2Gz011X9xU7h8E+EhYh+Y=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7947cf097c1so25320017b3.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:50:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776693059; cv=none;
        d=google.com; s=arc-20240605;
        b=kNsketFpENLdpXnpl4aSR5Xa7FiHX+yPAy/hU1onsHFUG7KI9Ffmzu6icvkci6YRfl
         hwpz1b3MgbJeVatSBOOJyIsrU0HEtoQJOP9ON4vwOyKf34ZBkspa4jy6GjOelUFcXm+D
         pxDd3sJ/WieiiJu7G/mROhYlrG2fu0MheHeABnTliniO2DDcWL3j1oQTmYTYA491Da2S
         VaAPM4IeJaTDEAWNpGXfjW3Q2O1FPOHa9LDNmfmQgsTtQQYjRhE2Et1MmARYypp/KH7R
         dcQSnvjRh1AWqm63edD8yvjQx5RPX37SB520HE/U57pY/D5rayERt9wJGivaPKY4qnMf
         yC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3b50RraaIawnD22hSCvT5knVr9IuRnQ6UaMDxGPXyek=;
        fh=PIqsozfJWJYjbxWOF3HadlMvidU/X5SsYzkxmwgozbY=;
        b=CQPT6/sN5s+ZNkI1rDu5OCUjmjdxbPE7XAFBMyUdz6yvyZyieII8ItrpQo8b4fsrRJ
         rca+90hORz7Mvxz13anKKRUf4dquuHZi/T2vc9GH1y+fB2xE+LuqNRZlobSYNTKK9wak
         F/28L/EnD8Ouw3/F3F3Bt62W9nLwgUNEbgSbNKIeem5IBHf9iced9X2uZBi+8KMuABb4
         IML7Kpwjz2ExMJRKhRY79TuhbOgn0ubrrBQCJmVHfJjz9a54zZYDYp0TmBmNejQ5zGFw
         XxRvxt+gr4zan02A1Qkl4FMuTl6AgbxfsjHRlhAu4AiQdTYPC6vq4vekj21cUvSlOtM2
         RDKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776693059; x=1777297859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3b50RraaIawnD22hSCvT5knVr9IuRnQ6UaMDxGPXyek=;
        b=MD4zIDsBdt8lr4ee3+N3tk+OcQplFii3cOZyv6hMm+7lR/cjjWHh8AoabdaoTCOIbZ
         HZX3eURFx+WIApS/B7qPkNsu/mCCIkFfRC4kweRjXcwRXOQhToordt7QX38rV3HZhUrH
         Z92eKRyXsPxLIvCxtQaoxC0zupGRbVTMc2+PXxkCE/491porvxwKkcFcxihcq85o9YcF
         fJQ02OCcvw3qlrY7JdwuT89YXdb391ZECVLmelqgdxD6E5jPdtvSAuSyA9cwL3ypmpxF
         Jt4Rp49XU8ZO3Dg5o6lHCFtcQ8gH+o83Du6C+siyz/+eOsA4WkPcBUxsyq92Re+hSJhB
         GwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776693059; x=1777297859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3b50RraaIawnD22hSCvT5knVr9IuRnQ6UaMDxGPXyek=;
        b=QCLsqz6Eqm5IjlHXx8wTE6e/SdEm96HcXcVZu5W+CliyjJGIWuF9WrbgE0IhM8kqxX
         jw8a4IFX4+dWwekFPJd0t576jg2LR5unSFUvD1ZiyIv4/aBKyYCQHuFvxs3jWlS5bWUI
         vU7EWMZGYWy4B+Dtpj7oWjWiWr56vmux18YCqc8rBo8hEYYNJDqH/NAWeLpU7RVrGKPF
         jqnE3rfs2JgYkXmxKL1O+8lpWvc1QO9ugBgxajiOe5eaq+eFqAurfz3JLAwBfXuXUwBp
         p1V03d7MKgKdAM0XKJWNCHV2Q3G57lwCxh8P8kLAEtw6/u3uhqdXsTesVgjjo/Z9GSbT
         9GsA==
X-Forwarded-Encrypted: i=1; AFNElJ9pSrXdFOA4MpzdXk3xe4XF/Sfx4orhVfA2eTbFCCdNElngQqgeE2UuAxvh8YpT+MXEbWRhjQATqg==@kvack.org
X-Gm-Message-State: AOJu0YwLblF8YGtuv3KVlZtoxFBdoXRFbdtgTyR8MahRirvWFGk0IZkm
	Bj1QiCdDZBxSyWXTYqB7RamAL/SjSpK7p3a7TdLVu0cGn9tjaO98RkvW3N4lFUQEwZoTFjuFYcx
	PXphTAUVFqsVpK+0mjpEXLelzYmp+iDuoR7O8
X-Gm-Gg: AeBDievzaPlD2Nbl7DtoNyl7g4SjT5a2T15CNI88BnVvWho/OdUnx7WECiUPUN9UTii
	HL42wskmpTXSmfbkaoF2kFsvfxaALCjab5HKV1o7lxGEQ2XGkyC6jHvlBXuKJR0ayrqglVRuYil
	svvuMl4Tey2uCNB6NyLu86oZ0NDmGcGnekI6zFdaU9KM0jmmh1ZcmK3kKhGbkJCYGztthGXBKDz
	8hpXZD7ZNa3jr1t9vbf7I9/6CFMqkHv9hCW2cAFLrUssLNhk+J+lX8FqbbPHZ1UepwQi7a+tWqC
	dhyHi04sOUtCnHg=
X-Received: by 2002:a05:690c:6e86:b0:7b2:64f4:a2dc with SMTP id
 00721157ae682-7b9eceb27f8mr130209557b3.9.1776693058738; Mon, 20 Apr 2026
 06:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260417135805.1758378-1-ekffu200098@gmail.com> <aeXIKM9BeRmaCZ_d@kernel.org>
In-Reply-To: <aeXIKM9BeRmaCZ_d@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 20 Apr 2026 22:50:47 +0900
X-Gm-Features: AQROBzBqgOURdNojQ-ObGzT9XJLcM5lAqMXI8V9Rsu3KZtGlmAEOrcBadIlLkfs
Message-ID: <CABFDxMGvGU6Vaq-AX9NXatHA9fTRDfB4yiHZBEQoJf4wsz-XqA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: snixxzdkb7dk4qpw5t6j5t6nf9qgfbmm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4B12180002
X-HE-Tag: 1776693059-910855
X-HE-Meta: U2FsdGVkX1+3Iwb4wVBpuTUOcmm3gW14QAJKQ49uxwVHR6vO9Nbj+TnBUKTsij1WO6zwfLJozValyQOdsQVtSOJb0qfUVbldWppEZ3VMDQ/ezxc0mTLRcrvBPI6FLU6DC046GZvMotno6J6cc6bDgKpwM/WE0RZ1gIair+uWmN65fgphBlLdRmUBIGGew0Re2nckRlFBV57KbIwYgZliwaFEPhHIHHIVbk54RW9R6yha7A00v1mKZ/m5PTLJfHg57nft72PJFa9Cdp9jslPMQEaOdEH69tSPgRu84XuX2zxZqXFG3h7BRlVc4tNNh2niR938zh3Tyiz1Un2At7J3xeHj6U1mu9yPt/pj+pn3OaaCjuvYFgGOYKTJG72yB6uDOTtFxwwzIhkvyRqMiVCRDCX8b0U0wBqavMpRsLnK3hYUCNwYvTbatz0E/tAnxPD4ReMaA8sGDKy9f1zXYCy2/aNCcW+jC1zQuoonGDhMPqKJt3JtxwHaSZBB9q8ZeQlQlqQboB62wwzRMClJLzzXmgmMNhNOaxMmUxyp8DJVlUd3M0lzhfAptmPMsJMxfw1ZAqyGFSkFGssbTJFAfM6/xiSHgVZ8yjbKd69ehdNqyUQICS8GGDbyjWv9NZWzNV4gR2b/7GPnZ33GXHY3/K80OZT2GtfZFA6NluHxsv4855wPn4FKnsoEOQHnV7VGafCDQ3HXhsBMo0Nj4F9Aix8zfS65LlijnlaVXY8slfADZDjriKnNKe50IxUtQQsMoKxLQ4zNI0B7/TEMigCA6Kq98UN61WUljUVCVjMnDNh7pWByKcHcUmAIcl4b8Q0aH/8BVMZaFDALDlflg7NHRWA23qeFmItWuu93d+N0r35XQp0+l3xGYwLhaJwMv8hUU0HuhSrgrQhQXD9Y78wZh3aycEOlWZiIKXLLslUeLuGEnMtGZ/LdSbhTgMKlUK6qrjNHr3iP3vNePwQ1A3J86Ex
 oO2TCCDa
 jEddANlh24hzcFU+BvbZ3YEFeSYRk+yGI3JZz/sTjlAlM0MWo50w9BR1aqQLVnZVM9vFWiTVuaeA8uG9AhwNtetsFh2Q5qcN8IPM/DK3gU80RlElgd1AsWJ7feTkuooOxbBLa1E2eA8cW0rkwLjb76xR9AyCRGiJXzq4X79A/QadlMUtg773PU+SUZfTh64umP858Rw053lmmoKYnIMmN0jXHkdxm3FtwnzSnPeDUJlOiVm4jZ5yRmDuZM8IQslPzoKjhZEYPPD4m5V7AJu7zzT9ZHDbtKB+rSSa4LlVrOlZzcIrKGHfwoYV8e3UpCi1zN9mlOjK1/GL6uGiHkX1ASLmKIqYzQT6xO1sGmKuupJuGs4xBrv6o1vnO3PVKrChV5xN2iOuVc4Z41Ss06TnlE+bEkG89MhRKs6wlA2lZMO/Cc+7RQT9G5mCvbKrGZiPIczXk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Mon, Apr 20, 2026 at 3:31=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > returns the next absolute node ID, not the number of nodes created.
> >
> > The existing under-allocation detection logic compares next absolute no=
de
> > ID (ret) and request count (n), which only works when nid starts at 0.
> >
> > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created f=
rom
> > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > fake node nid starts at 8, but only 4 fake nodes are created due to
> > current FAKE_NODE_MIN_SIZE being 32MB, and
> > split_nodes_size_interleave_uniform() returns 12. By existing
> > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
>
> In this example it would be 11, won't it?
> I'll update when applying.

I think 12 is correct because there is a difference between the
attached QEMU test log and the scenario which is described in the
commit message. This is because I missed the reserved memory (~140KB)
for ACPI table.

1) Previous attached QEMU test scenario

QEMU command line :
    qemu-system-x86_64 \
    ...
    -m 2176M \
    -object memory-backend-ram,id=3Dmem0,size=3D2G \
    -object memory-backend-ram,id=3Dmem1,size=3D128M \
    -numa node,nodeid=3D0,cpus=3D0-1,memdev=3Dmem0 \
    -numa node,nodeid=3D1,cpus=3D2-3,memdev=3Dmem1 \

log :
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff]
System RAM
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x00000000000a0000-0x00000000000effff]
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
device reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000087fdcfff]
System RAM
[    0.000000] BIOS-e820: [mem 0x0000000087fdd000-0x0000000087ffffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x0000000088000000-0x00000000feffbfff]
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x00000000ff000000-0x00000000fffbffff]
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x0000000100000000-0x000000fcffffffff]
[    0.000000] BIOS-e820: [mem 0x000000fd00000000-0x000000ffffffffff]
device reserved

...

[    0.001919] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.001921] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0x7fffffff]
[    0.001922] ACPI: SRAT: Node 1 PXM 1 [mem 0x80000000-0x87ffffff]

...

[    0.001930] Fake node size 15MB too small, increasing to 32MB
[    0.001930] Faking node 8 at [mem
0x0000000080000000-0x0000000081ffffff] (32MB)
[    0.001931] Faking node 9 at [mem
0x0000000082000000-0x0000000083ffffff] (32MB)
[    0.001931] Faking node 10 at [mem
0x0000000084000000-0x0000000087fdcfff] (63MB)

So actual node 1 usable memory is [0x80000000-0x87fdcfff] (~127.86MB)
That's why uniformly splitted memory count is 3 for node 1

2) Commit message scenario (Log is newly attached)

QEMU command line :
     ...
     -m 2228480K \
    -object memory-backend-ram,id=3Dmem0,size=3D2G \
    -object memory-backend-ram,id=3Dmem1,size=3D131328K \ # 128MB + 256KB f=
or margin
    -numa node,nodeid=3D0,cpus=3D0-1,memdev=3Dmem0 \
    -numa node,nodeid=3D1,cpus=3D2-3,memdev=3Dmem1 \

log:
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff]
System RAM
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x00000000000a0000-0x00000000000effff]
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
device reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008801cfff]
System RAM
[    0.000000] BIOS-e820: [mem 0x000000008801d000-0x000000008803ffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x0000000088040000-0x00000000feffbfff]
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x00000000ff000000-0x00000000fffbffff]
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff]
device reserved
[    0.000000] BIOS-e820: [gap 0x0000000100000000-0x000000fcffffffff]
[    0.000000] BIOS-e820: [mem 0x000000fd00000000-0x000000ffffffffff]
device reserved

...

[    0.001870] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.001871] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0x7fffffff]
[    0.001872] ACPI: SRAT: Node 1 PXM 1 [mem 0x80000000-0x8803ffff]

...

[    0.001888] Fake node size 16MB too small, increasing to 32MB
[    0.001888] Faking node 8 at [mem
0x0000000080000000-0x0000000081ffffff] (32MB)
[    0.001888] Faking node 9 at [mem
0x0000000082000000-0x0000000083ffffff] (32MB)
[    0.001889] Faking node 10 at [mem
0x0000000084000000-0x0000000085ffffff] (32MB)
[    0.001889] Faking node 11 at [mem
0x0000000086000000-0x000000008801cfff] (32MB) # (~32.11MB)

So actual node 1 usable memory is [0x80000000-0x8801cfff] (~128.11MB)
And Node 1 is successfully uniformly splitted into 4 fake nodes.

Sorry for causing confusion due to the wrong example.

> > under-allocation will not be detected.
> >
> > Fix under-allocation detection logic to compare the number of actually
> > created nodes (ret - nid) against the request count (n). Also skip
> > under-allocation detection logic for memoryless physical nodes where no
> > fake nodes are created.
> >
> > Also, fix the outdated comment to match the actual return value.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capab=
ility") # 4.19
>
> ...
>
> > @@ -416,9 +416,18 @@ void __init numa_emulation(struct numa_meminfo *nu=
ma_meminfo, int numa_dist_cnt)
> >                                       n, &pi.blk[0], nid);
> >                       if (ret < 0)
> >                               break;
> > -                     if (ret < n) {
> > +
> > +                     /*
> > +                      * If no memory was found for this physical node,
> > +                      * skip the under-allocation check.
>
> checkpatch complains about trailing white space here.
> I'll fix it up when applying.

Oops, I missed it. Thank you for pointing it out!

> > +                      */
> > +                     if (ret =3D=3D nid)
> > +                             continue;
> > +
> > +                     nr_created =3D ret - nid;
> > +                     if (nr_created < n) {
> >                               pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> > -                                             __func__, i, ret, n);
> > +                                             __func__, i, nr_created, =
n);
> >                               ret =3D -1;
> >                               break;
> >                       }
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

I really appreciate your detailed review :)

Best Regards,
Sang-Heon Jeon

