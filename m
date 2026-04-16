Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0F3F8D765
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4AB6B009B; Thu, 16 Apr 2026 14:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8952F6B009D; Thu, 16 Apr 2026 14:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784516B009E; Thu, 16 Apr 2026 14:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67F516B009B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:25:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8D71A09B7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:25:58 +0000 (UTC)
X-FDA: 84665247996.08.80B2F89
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 019EBC000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:25:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RMu2Zoa9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of asd142513@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=asd142513@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776363957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zNrNs2rsm3TLwHVeFFv1A8L+IYDUEet/xrOpEzJaAw=;
	b=1iVq/VyOdJGM9e1ZqFZwN3Coy43pyIadxhaOZv5QSTh0Zios0fUONAO0vaGcHRqF/sQcvL
	j3grme/mhBFOczSNg4nQV5blmpdghXogVlravUYAGojYVGDRdsDPSk2ZydcEAyp+aM9kK/
	z27B2NNbydR5mXfxBcuf0kwPMjt4Gy0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776363957; a=rsa-sha256;
	cv=pass;
	b=7m50VqNHJOsP86GlrJjqVtXQOc2rdeB0hX82jFlXnmBza6hGYrkDscCHn38QaqVB8DAR7S
	91HN+1xOuvfMwYUGdwGvT7jHTMrXCRKXE73WwRH4/g2jtAYZ/p7wVHgbiPyc+zgBgZdXP+
	q0+cNoSl8nwSsjzj4YN/UKhJatagcJY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RMu2Zoa9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of asd142513@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=asd142513@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so35128847b3.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:25:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776363956; cv=none;
        d=google.com; s=arc-20240605;
        b=S1fVonOSB46kUUQTy4QYbLB2zLDYMbyqLhibIBXUQ2yLUZofhrrykTQfjMoCWMLLPC
         0VDlPGOQFc+mbAv7i4NDTBIwx7I6XgqhgFNFX3F6VI5WMJAKc1elBnMWmMXG5vQECS4z
         k2FHDaU/m7/8Zi6JWJu4cq2gE43vF+X6uS3H+UtuBzovlkZmG64ksHG+BLg8CU4qlMuj
         kRU40xpe1O7X0d8T8l39GA4dpX064SER+VSwLv40vkM6BuBakpMEStXonoJmaTGg9zGa
         G6RR+MjPaioJX9cFSo4ECZCzsgBKVGUo5Hc/TBdijNONqBvnFyKBGkI7Xuj3x3900c97
         xygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0zNrNs2rsm3TLwHVeFFv1A8L+IYDUEet/xrOpEzJaAw=;
        fh=etD4Odj/eVqmA0j0W4BoH70sXIGrNekzpzrH0bZyzNE=;
        b=Xx1VgZnly8+JbTitUVLnoAFj2NQoo5KwrEv9CCU/0X7IrPLfoa6xWlkl5/hIRdSmuW
         nfxUqo40IjWLHsBE7KKzM2YwqE7/S7k7dIsxBJfJYmWKs9okCxgfEXKWQlbC98QOgZYa
         8jH+WQOfDW5RM2xDH2DDjqElrLE+dL7TJVy6HIJkZ7pzIOOzAn2ofneCi0kUxnWWH0D2
         /KoYRYkKpxrC03eZ6uSMCP4l0ezb5bN1ojGSSQOVhPCYGYRykgWFbDSPbW0G7RHM7UIN
         KMltYpyUcN5T8HVDFzHyYXxklgcb3fuMHdTHQ2fxhakgHMuwrDSo1OFkduuxxqBjqPEW
         8C9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776363956; x=1776968756; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zNrNs2rsm3TLwHVeFFv1A8L+IYDUEet/xrOpEzJaAw=;
        b=RMu2Zoa9lcmUiLOyJYRxLvsIx2+qif/EhCJoXGav1Tu3wSGcnSuRY46PIxVzLNanhN
         udiYfsZYBsWrYvAFeY6dgbmdEehRb5XB6o9Y7g+c1tdM3OF1D6EhRe8YVgYD04C+70Ms
         V52A1vUKOHUZPWuMy5bP8eyJzF9/9qZr3yuC0LxiPfPUTpfT8SG7hBHz78zdchgoHYT4
         OKsR+c0/PAPnRMXUwq2Wqi8uOSQSqy2Eis7TMUagv2Hd1c5r7TJsOOzspauLGMnFqpfP
         anLm65pS51uODXv5oEQSkqyP0c+3jm/5m9aucyjnVYM4lsocT8W0mmZ37XHfohjbtVX5
         Xv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776363956; x=1776968756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0zNrNs2rsm3TLwHVeFFv1A8L+IYDUEet/xrOpEzJaAw=;
        b=YuFLH8JxEflNwNjn4D5VLkmORutXUrkj2i4JNBfuQpo7CxYaPJbmuIggjA7LtfcEUz
         XWrtKxM1pn44b8iwXaHeBKawrbDtKrL96tZCj09CpbKLupghq1pTHoJxsicb2Xndab4u
         xBh4YDKg1FaG4KXUys/vwNXl2Ey8QunJ9UKRaUGv0J4R03d41rx8o+EjTIWnoUpvMMuz
         vv9rhb1FLzR0IVAfZAZax/q8b5meW2CssFk3rKHdHmmPqDj81vmLnL7LqrJGdWK5FZMY
         dEUEw5QPDBDCdoGxtsAh08uixg3kYeGDZgATEqjM2Yn2MABId/KG773WI9uIdRvyyloo
         E7VA==
X-Forwarded-Encrypted: i=1; AFNElJ8Wyc04CqasQS1fKj/VdtuJ+RT0TyHfrJ4YWw89Q/krJ1xb7Kny2GVA74NARkyzdYq46G6oforDUw==@kvack.org
X-Gm-Message-State: AOJu0Yzcvf0IDpBTtYuAdsha6dOovjL1Yv5scn3fEPGX/EkAaoXdpNvq
	cPssAwaEOHMZBBDA+VvwlPbr/9dnb3CabB0LDuhxc8LnMcJ3YXHLN+5J4yCnUgtPavSKoIIlpN1
	nGO+7QypR27wVXuvxJrKrsXswNYW7TsI=
X-Gm-Gg: AeBDietWM7W/EiNW5TQGDLB3d4FtUFXgdQYIRw8138n4jHwJE7UE85RTjJjdNcwyfZj
	tl0WsneMHKdnyTb3112VejmH7Z1/h1iI/1jDfZDfdIC6DBD4PPRccF9jwYEeZPOIx/iiJOloBb4
	wCbfLsAThPRpo1KiiV6t5rnaRd2ai7YLuJ030g9bJZ5IkI08sWNFNhoCeuhpxrvigNM1fhIZyzG
	mXeI3aJp8HlDPsHfEf9ZQmuc02yEkKiJQkawVOJXiHFkclX1oe7xYZdZ5DLwaGHdCneqhUGk3am
	t2jOmPGGe3EBR20=
X-Received: by 2002:a05:690c:c510:b0:7a1:a97:c144 with SMTP id
 00721157ae682-7b9e19ec1e3mr2145997b3.5.1776363955836; Thu, 16 Apr 2026
 11:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260416102558.575210-1-ekffu200098@gmail.com>
 <aeDz3UAB54v2K8Hz@kernel.org> <CABFDxMGYBkZpAeH8zbZsQA3giN9v8dyHPq=TCZf2EZbppMT24w@mail.gmail.com>
In-Reply-To: <CABFDxMGYBkZpAeH8zbZsQA3giN9v8dyHPq=TCZf2EZbppMT24w@mail.gmail.com>
From: Donghyeon Lee <asd142513@gmail.com>
Date: Fri, 17 Apr 2026 03:25:44 +0900
X-Gm-Features: AQROBzDau9fWOc63LZAOQVLe0g97SloPeGjFhAONK_K412V4faEq7uOBDj0GSSY
Message-ID: <CAFPTC5e1OLpHa3HqwhtSPjS_PTQz+iG=ovM2cZ=VnOZ_5z7oxg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, djbw@kernel.org, 
	mingo@kernel.org, linux-mm@kvack.org, Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 019EBC000D
X-Rspamd-Server: rspam07
X-Stat-Signature: jebmjwo7mc9zwy99bkq1xsam5ej5gbto
X-Rspam-User: 
X-HE-Tag: 1776363956-875756
X-HE-Meta: U2FsdGVkX18s419wyrDisUrJNc6OuAX7KEuaBrXDWrBV2l8Gq0cgliqX3UMV8nwWLyph6MnY0Q1c35cnPdoHavUkK8zRC1urVR7Typ3NA/YwhLi189OQzpBrWS3Z/fLe/NcsbzYmkfzMKcPuSxgU/6uUpR3/JrgtTwHnG2+VlQ3nAdmuCJE1tSc4zqy2nXY3hnYhyKMd8rN1S/MsGqJwf0CXLNRn3nl66LgqMlMqo0zpwlokRNEjwVFPxHco6pdSMBr7BvX/3d8SdeDXuq/08gvjy8yyz+BjD0/aU/npbmgJX2jJ3LxwjrI6CjPIJdV9Fa25wakHY0tSmYiI3+F8vnj94ohj/qvgFT//1FRicLSLFbFZy1PrEoEcszZKK9WVi84miyors4WwvZlHMNi3ClPGDGfMDJs4PclljPQkP4BgrM6NsXGhxrSdMX6JyiV6u7bMMAyzLvqaw26E7se9Bh+Zxwl3mBGso8ntgO9dQP6tW8NJ4cBPSkvhJr00l0uVpIZeQfncq35YANjXuBTT3+BosQy477KaSCBNPvHwEKJx7ijdK3thDTFs7OUsPhfTc80VYSs4Ue8B+62ii+RgPcKLPoLkn9Ze4+ARihoBRHIoA8OHEFS5+H2b8S0/biD3uCMg6ikdHOdkl+9xIql0KhL+dMSaUtyjfTrjwbuN4sd14954lhddVedUF6bzP1bWg9Fp+vaKlPI8c6oZ0tseqCC/MAftGOdjyaiCYgRz4M6uXyf0Cs2F1RqW1ehD3RWLRQqLsZD7TypCLB0KV5L2JKxUMz5h0bPJ6o/QfTBaEO4qrCR9iS8l7bHLCnztOcQ/hzcwaNIex/Njk3HMXubwnyU7dMRc5Kw2D0iZ4n1TRAst4o+hNRc3mpuO816LhnTKCnjzSGZzP9m2k+ojt5BTJ3Yp1wxPJc0koBH6LdJbNfOiwpOGJ+jQaMQAF8cvLA3sSwR5AawKkVXWYseq5fX
 gXMyKGvG
 0BE9f2kfUFdP6m9otvVNkUJyrfcgcJ62o2giuiYCnz6Z9/9OUe7xj1tmp9+n5RtrffCS/+8sUTFHGR47MSF9/G8h3e4jzNfd1ogsHfDjSnBhYY24onQhhvZ8b00xhEbRdbjuDBDHq65aiLBZ0gJxf6krYB05g4PJLhCn9veOlroRH44e3njgii7p9gqKZPznuZrcVu7zbFsRTFwnGppOR281wffF5cZiIBzl0bUBZnHz2zGzaaiY20xzHa4J0zNLogYYZEIBTwZTr314TOCokyUCOaw4n1uH92DeV4/2KFJ86GqFzJ8aGHR66iAMiBfnUTrIhKWJfo4+qpVhzE0chHsmMk+fY5O7mi0JM+iTw2auLTBapqpKhYc2tHRXjdFjL0OjI2qgrXMnwoZueeLoK8jx+GVfo+QksY6B7IiMDVqiOz+gBnyeqO11ypL+6MUSTl8aj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Please note that this message was written with the help of machine
translation.

Below are the QEMU-based before/after test results for the patch.

The test scenarios were as follows:

1. Test with the unpatched kernel.
   Assign 128MB to NUMA node0 and 2GB to node1, then split each
   physical node into 5 uniform fake nodes.

   Since node0 does not have enough memory to be split into 5 parts,
   this case is expected to fail.

2. The reverse of case 1.
   Assign 2GB to node0 and 128MB to node1, and again attempt to split
   both into 5 parts.

   node1 is expected to fail the 5-way split, but since its fake node
   IDs start from 5, slightly fewer than the intended 10 nodes will be
   created.

3. Test with the patched kernel under the same setup as case 2.

   Since node1 fails the 5-way split, NUMA emulation is expected to be
   disabled.

- TEST 1 ----------------------------------------------------------------

qemu-system-x86_64 \
        -drive file=3Ddisk.qcow2,if=3Dvirtio,index=3D0,media=3Ddisk,format=
=3Dqcow2 \
        -bios /usr/share/ovmf/x64/OVMF.4m.fd -nographic -s \
        -machine hmat=3Don \
        -m 2176M,slots=3D2,maxmem=3D4G \
        -object memory-backend-ram,size=3D128M,id=3Dm0 \
        -object memory-backend-ram,size=3D2G,id=3Dm1 \
        -numa node,nodeid=3D0,memdev=3Dm0 \
        -numa node,nodeid=3D1,memdev=3Dm1 \
        -smp 2,sockets=3D2,maxcpus=3D2 \
        -numa cpu,node-id=3D0,socket-id=3D0 \
        -numa cpu,node-id=3D1,socket-id=3D1

~ # cat /proc/cmdline
\bzImage console=3DttyS0 root=3D/dev/vda2 rw nokaslr norandmaps numa=3Dfake=
=3D5U

~ # ls -d /sys/devices/system/node/node*
/sys/devices/system/node/node0  /sys/devices/system/node/node1

~ # cat /sys/devices/system/node/node?/meminfo | grep MemTotal
Node 0 MemTotal:          83024 kB
Node 1 MemTotal:        1992536 kB

~ # dmesg | grep failing
[    0.037511] numa_emulation: phys: 0 only got 4 of 5 nodes, failing

-------------------------------------------------------------------------

As expected, the NUMA nodes were not split.


- TEST 2 ----------------------------------------------------------------

qemu-system-x86_64 \
        -drive file=3Ddisk.qcow2,if=3Dvirtio,index=3D0,media=3Ddisk,format=
=3Dqcow2 \
        -bios /usr/share/ovmf/x64/OVMF.4m.fd -nographic -s \
        -machine hmat=3Don \
        -m 2176M,slots=3D2,maxmem=3D4G \
        -object memory-backend-ram,size=3D2G,id=3Dm0 \
        -object memory-backend-ram,size=3D128M,id=3Dm1 \
        -numa node,nodeid=3D0,memdev=3Dm0 \
        -numa node,nodeid=3D1,memdev=3Dm1 \
        -smp 2,sockets=3D2,maxcpus=3D2 \
        -numa cpu,node-id=3D0,socket-id=3D0 \
        -numa cpu,node-id=3D1,socket-id=3D1

~ # cat /proc/cmdline
\bzImage console=3DttyS0 root=3D/dev/vda2 rw nokaslr norandmaps numa=3Dfake=
=3D5U

~ # ls -d /sys/devices/system/node/node*
/sys/devices/system/node/node0  /sys/devices/system/node/node4
/sys/devices/system/node/node1  /sys/devices/system/node/node5
/sys/devices/system/node/node2  /sys/devices/system/node/node6
/sys/devices/system/node/node3  /sys/devices/system/node/node7

~ # cat /sys/devices/system/node/node?/meminfo | grep MemTotal
Node 0 MemTotal:         371796 kB
Node 1 MemTotal:         419824 kB
Node 2 MemTotal:         419824 kB
Node 3 MemTotal:         417776 kB
Node 4 MemTotal:         323564 kB
Node 5 MemTotal:          30496 kB
Node 6 MemTotal:          32752 kB
Node 7 MemTotal:          59432 kB

-------------------------------------------------------------------------

As expected, although node1 failed the 5-way split, the overall
emulation did not fail. Instead, it resulted in a partial/incomplete
split.


- TEST 3 ----------------------------------------------------------------

qemu-system-x86_64 \
        -drive file=3Ddisk.qcow2,if=3Dvirtio,index=3D0,media=3Ddisk,format=
=3Dqcow2 \
        -bios /usr/share/ovmf/x64/OVMF.4m.fd -nographic -s \
        -machine hmat=3Don \
        -m 2176M,slots=3D2,maxmem=3D4G \
        -object memory-backend-ram,size=3D2G,id=3Dm0 \
        -object memory-backend-ram,size=3D128M,id=3Dm1 \
        -numa node,nodeid=3D0,memdev=3Dm0 \
        -numa node,nodeid=3D1,memdev=3Dm1 \
        -smp 2,sockets=3D2,maxcpus=3D2 \
        -numa cpu,node-id=3D0,socket-id=3D0 \
        -numa cpu,node-id=3D1,socket-id=3D1

~ # cat /proc/cmdline
\bzImage console=3DttyS0 root=3D/dev/vda2 rw nokaslr norandmaps numa=3Dfake=
=3D5U

~ # ls -d /sys/devices/system/node/node*
/sys/devices/system/node/node0  /sys/devices/system/node/node1

~ # cat /sys/devices/system/node/node?/meminfo | grep MemTotal
Node 0 MemTotal:        1952844 kB
Node 1 MemTotal:         122712 kB

~ # dmesg | grep failing
[    0.036879] numa_emulation: phys: 1 only got 8 of 5 nodes, failing

-------------------------------------------------------------------------

With the patch applied, the emulation now fails as intended.

The log message is still from before the logging fix, so it prints the
odd message saying it "only got 8 of 5 nodes" before failing :)

Best Regards,
Donghyeon Lee

2026=EB=85=84 4=EC=9B=94 17=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 12:26, =
Sang-Heon Jeon <ekffu200098@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1=
:
>
> On Thu, Apr 16, 2026 at 11:36=E2=80=AFPM Mike Rapoport <rppt@kernel.org> =
wrote:
> >
> > On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> > > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > > returns the next absolute node ID, not the number of nodes created.
> > >
> > > The existing under-allocation detection logic compares next absolute =
node
> > > ID (ret) and request count (n), which only works when nid starts at 0=
.
> > >
> > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, nod=
e
> > > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created=
 from
> > > node 0 and split_nodes_size_interleave_uniform() returns 8. For node =
1,
> > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > > under-allocation will not be detected.
> > >
> > > Fix under-allocation detection logic to compare the number of actuall=
y
> > > created nodes (ret - nid) against the request count (n).
> > >
> > > Also, fix the outdated comment to match the actual return value.
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split cap=
ability") # 4.19
> > > ---
> > >  mm/numa_emulation.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > > index 703c8fa05048..c1d0a76aef64 100644
> > > --- a/mm/numa_emulation.c
> > > +++ b/mm/numa_emulation.c
> > > @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u=
64 hole, int nr_nodes)
> > >   * Sets up fake nodes of `size' interleaved over physical nodes rang=
ing from
> > >   * `addr' to `max_addr'.
> > >   *
> > > - * Returns zero on success or negative on error.
> > > + * Returns absolute node ID on success or negative on error.
> > >   */
> > >  static int __init split_nodes_size_interleave_uniform(struct numa_me=
minfo *ei,
> > >                                             struct numa_meminfo *pi,
> > > @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *n=
uma_meminfo, int numa_dist_cnt)
> > >                                       n, &pi.blk[0], nid);
> > >                       if (ret < 0)
> > >                               break;
> > > -                     if (ret < n) {
> > > +                     if (ret - nid < n) {
> > >                               pr_info("%s: phys: %d only got %d of %l=
d nodes, failing\n",
> > >                                               __func__, i, ret, n);
> >
> > The error message also should be updated, now it prints the last node I=
D
> > rather than number of created nodes. I think it's worse creating a
> > temporary variable for ret - nid to make the code clearer.
>
> Is "worse" a typo of "worth"?
>
> And thanks for catching. I totally agree that the error message needs
> to be updated.
>
> > I'd also recommend running qemu without and with your patch and verifyi=
ng
> > it works as intended.
>
> In the next version, I'll try to include qemu based test results.
>
> > >                               ret =3D -1;
> > > --
> > > 2.43.0
> > >
> >
> > --
> > Sincerely yours,
> > Mike.
>
> Best Regards,
> Sang-Heon Jeon

