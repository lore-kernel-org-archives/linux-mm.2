Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0DBC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC366B0089; Mon,  4 Aug 2025 04:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3D06B008C; Mon,  4 Aug 2025 04:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9336B0092; Mon,  4 Aug 2025 04:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4F86B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:19:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D39EB140ECC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:19:50 +0000 (UTC)
X-FDA: 83738376540.06.AA4FFE2
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id EEE1E2000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:19:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWaV253k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754295589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QakOYCzjeUgf946LIgVNMTZzQUr0zFeiIPDv/wMCjDg=;
	b=tQqO0mMwKoKWkiSWwTQi6uj6b9B7lzjc0doJ0VrJFKartNSgcD3OsAQFmpPyJ++UHilGNn
	C36s7QPXpB6fYximOFp0rL4wNj8Jf8zNB+XsZU1LoGCb/aVGMQv6xiKxaSOSYwvUhcZWu1
	nF1/cNaAWaiQzxB7z5eXUACKoVKc9f8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754295589; a=rsa-sha256;
	cv=none;
	b=ilpKefloJpaTKFchYssvWb7snNvOQPOx2gIZCOCgkcVc5n1hbSkmc4a/tmdsCtpmXBmWF2
	/oIwcdZO0XKmq44NK+qI0yIY0ICh4e8FTOa2Soe0xdZE/kjzu12B3C3BK4CIvD2BN9/tpP
	QKe7Et+Ij8KBA5DkQOGhMQ1KAIBcsyY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWaV253k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4fe2e89d055so1617695137.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754295588; x=1754900388; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QakOYCzjeUgf946LIgVNMTZzQUr0zFeiIPDv/wMCjDg=;
        b=VWaV253ksGBtwYaPPKJaEyyJglxdfboVIj12swk8ixTw+CYPz8iI5dcmppWiawtxHK
         SUs90EMn/ccjSyGU3RX5qFr7GOwaK9uSEhNzz/xaGwOWLD9CKBbqQtGPg6oh/GH33osn
         sBk2n9kbjAOk9UTasgO0RwazIOnXOZGIZ+t0I9Cl1asKfkc4B9OnNOV2NSPvCCNN/lIT
         k35FKRTJLE8TrfthZDUoSp5t6qKTwfLkqR6xf/9Nbws1fahIYBeCbBC05YcnslYmD9N4
         luSzPKNbNi/rUUL3e767Q290+hV2scGqomkaVN7aS0FukQFvk48sRDH3hNaTpjCF/bSv
         sLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295588; x=1754900388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QakOYCzjeUgf946LIgVNMTZzQUr0zFeiIPDv/wMCjDg=;
        b=pgkSY0/mXcf0tf7MWWA0rxi8yfmj90ugYp6ALSSJ2z6s5Mh25EdyKu0S9zE49Hup9C
         lgVdebGkapgQ/agDx0SEuvUKinqMmAk/5qx3o6G0R8wAa1sBbpC5YEOkNg8TWyfgdzim
         U6pkTZMpQUDW1kD6YoSWfTYY5R6+eOa0YrAtDVTXU6oeFLC3y2sWsTWQnYazZNi6zdHV
         qc1XVNEsZDd0i8CXRNZiNNFZ64uFmJeAOzPO2a99KnnAdOKvyMYnM8wSV6V98UzSosDQ
         NIGlvtOqicXJqtEz3cFGmgUhLAXOmjVO3dBhsI0KD9TlnBHU76bTXUC/77Amunl5quuD
         906A==
X-Forwarded-Encrypted: i=1; AJvYcCVJBr3vPu9/ngrAjcU36KB9x0PHp90b0HC7jH5it/9HNnNSNCzFumCpDLcLJOy/S+2FnGPwWIOWZA==@kvack.org
X-Gm-Message-State: AOJu0YyuH6YJcKi/DkgQWhW4JtCxfY1BeGcK8S0fR0F4enlzgdrr9VcK
	w+FQSePKAuU8FVy9x8d9kiItHXIYtWvpajPgDiGz247fIdkPcqtfcFS1d0YISfNLVazgIHtKcMv
	USoTNji/328pODPie07rJt9mCvyZgI9E=
X-Gm-Gg: ASbGnctsvbBa7I1e10Fdol45DPIWQS7zWHrWEZFoDcM++EpXFp08Cle/WO3ON04dcRu
	wH2kIinIWY+RCVNjYAneVdkba55tqRXuosiLQ4IuakuSvYGrDA66pPTSXJbJhZ0plIS3kSlB7YF
	rJxdtwVCGh3dBfEOvA7Ko5v/zxW8QKU04hih8cUiufhubYd84IgCxOBXMfYw1xlNoKjP34Ze0++
	ITSElI=
X-Google-Smtp-Source: AGHT+IFEShGMSYTemW41INtMwdf/oTeKCho1ekLh+r1ejDjZNmNvZ7x04++HhEfI2mR2LR/hSKCgAf2ysUV1MylhyPY=
X-Received: by 2002:a05:6102:6488:10b0:4fa:3547:2d38 with SMTP id
 ada2fe7eead31-4fc100d5721mr4901505137.10.1754295587845; Mon, 04 Aug 2025
 01:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <aJAFrYfyzGpbm+0m@ly-workstation>
In-Reply-To: <aJAFrYfyzGpbm+0m@ly-workstation>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 4 Aug 2025 20:19:36 +1200
X-Gm-Features: Ac12FXzEE9AUMv26jhr9UED1IgeO8i-lkO_9knp8t8Sgm8GYpJ8xqHeutSYDfEM
Message-ID: <CAGsJ_4zsj2c8J7XxUeW-95pYb11uSjas3FbJv1F3-x7bbtPYnA@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dhqkdqnyweqci6qwmsndhyjtyujkeouc
X-Rspamd-Queue-Id: EEE1E2000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754295588-220165
X-HE-Meta: U2FsdGVkX1+7QJ9ZBK4gdwDVSfD1BTwN/ki9NoBPJipJMgS7u5mlQy7jn6S+E4Fw8x8QFlqr946zfswdwznPInIG8Bq50D7Q1YVPTl9LDpfwtgT5s0gM8Rd+8ZoYjqlR4/M0WgOF1KLj8drrxnih+zdDSUNG92606t9t+SBel6EA1iSlsVa2Ze0Hd1vw+VUPpx2NRwyJz+kWESBCqsR9qTTzhxS2/dON2KI9ie7fobZ+n1lcJ3XLlmLRR/EarbIVffotb01sQgCJvVYH9FW7E+GtT+XWu49Ssdj0bkMeD1Uh1ZiNF4BfB/pqdggWs9C/LT48hMXuyzfQpchd2sQ7BpHAYaibmoIIXTeQnLrsnkM/YoJ8asSv7RKef807dbJBHxuk757Cuesn79V0BCXiCYVqvz3iaVZ2ctdkYrpip4fucMNFGUkM8Ht+rTuFD1b0RSeei61SOvSqRO92ZMrTpq5kfPTYKMALvW29BeMpJgpDUGtWWQRy7B/Hu3iOvoHkh351zCO63ACWUgRpNe/Z8BolkMaN7noFIQXi7t2UWx6WcU+ETbBM/ncZNhT+ovdaioj4PgaFBXyFXupo2Ip4FURxsKtbXP3IrEtC1UN8n7M262yRnnuhMBxf1NCxvBp5apTWlarcaJBsg64uyUFNviDc0WPjvjD1SCk2T5pmn/k5I/phDFrZAaJglq/x6CAmQHH64zz6EYlV63+17l5ak6a5GUdhC47eKXAnSs9E0/Mt7cm90zHRN2wmkR7fkyyuf0dAdQV+uK0/scCwJvbN4Ws0w8p4CvxUjz7OSP6P5y7n7EdckZuPzxcCV872fz1lMkR1eez1WXFBIarAFy9QQpOKhI/WZ2hGE4OK2lK7YPAFejIFKBQVFGidH2vkVcTejRw2BDDS4Tx1hB2EnqnXk2SZMBibA1gYTYBE1Ozgsd3/NwStq5oT9FBTjDkq18GKRa9W45aYUmFH5VuoZyX
 WHcmKfNe
 594AKT/ixXYPponVct3M0v9PD0ViPuxjcxV0xnoNGImBritLWywsB6+bCylcfCVrSwbn6sVW7p4+Lq1yOCGUlHhmBs9C5gZWP7EnoD/n83z99U36G3XExLrmDLU9mCMpzY2HUQ9dR0+2sCFyJF1aBfwjEija7c95RiYAsPGESsy1v8neDgZLtNbMnUxTHgpDY9yBw16wTNxLc3oykXNx7t1AFBbFf0QEeLjnoJ0Erptzvq0lYamGVxuATuz7B9wtvYJAI6zrYgKgmZ/Y7Y9S41RI3cP+tNQwq9yKEKFi74BPZJDf2U7BEMZnduGm8wn2X7IEZrdhHNcXFmf21Ec68D0QQGFc4eVOlG1TOckLk/kyiMA+6qWhXDpuILpnpYLzrq9K/iau2MKGSnE432zUpX372lC5EDO33amkunwb+BDl2OB4kCrsYV1hDuodZraTqxntcspC71BVCqT9m37F2ZluWJeNHRuWVV09uXKuo4qtH3Ng4uK7D2rwz+TT40RrUMgOLoyQ5pPYKYoXy1Hyjb6D80A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 12:58=E2=80=AFPM Lai, Yi <yi1.lai@linux.intel.com> w=
rote:
>
> Hi Barry Song,
>
> Greetings!
>
> I used Syzkaller and found that there is general protection fault in __pt=
e_offset_map_lock in linux-next next-20250801.
>
> After bisection and the first bad commit is:
> "
> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> "
>
> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock/repro.c
> Syzkaller repro syscall steps:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock/repro.prog
> Syzkaller report:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock/repro.report
> Kconfig(make olddefconfig):
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte=
_offset_map_lock/kconfig_origin
[...]
>
> If you don't need the following environment to reproduce the problem or i=
f you
> already have one reproduced environment, please ignore the following info=
rmation.
>
> How to reproduce:
> git clone https://gitlab.com/xupengfe/repro_vm_env.git
> cd repro_vm_env
> tar -xvf repro_vm_env.tar.gz
> cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v=
7.1.0
>   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65=
 v6.2-rc5 kernel
>   // You could change the bzImage_xxx as you want
>   // Maybe you need to remove line "-drive if=3Dpflash,format=3Draw,reado=
nly=3Don,file=3D./OVMF_CODE.fd \" for different qemu version
> You could use below command to log in, there is no password for root.
> ssh -p 10023 root@localhost
>
> After login vm(virtual machine) successfully, you could transfer reproduc=
ed
> binary to the vm by below way, and reproduce the problem in vm:
> gcc -pthread -o repro repro.c
> scp -P 10023 repro root@localhost:/root/
>
> Get the bzImage for target kernel:
> Please use target kconfig and copy it to kernel_src/.config
> make olddefconfig
> make -jx bzImage           //x should equal or less than cpu num your pc =
has
>
> Fill the bzImage file into above start3.sh to load the target kernel in v=
m.
>

I can boot successfully with your bzImage for the 6.2 kernel.
However, when I use your `kconfig_origin` to build a new kernel from
the 0801 Linux-next source, the system fails to boot.

Warning: unable to open an initial console.
check access for rdinit=3D/init failed: -2, ignoring
input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input2
List of all partitions:
No filesystem could mount root, tried:

Kernel panic - not syncing: VFS: Unable to mount root fs on "/dev/sda"
or unknown-block(0,0)
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted
6.16.0-next-20250801-gb9ddaa95fd28 #1 PREEMPT(none)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 vpanic+0x2a1/0x2b0
 panic+0x55/0x60
 mount_root_generic+0x2c6/0x2e0
 ? __pfx_kernel_init+0x10/0x10
 prepare_namespace+0x49/0x260
 ? __pfx_kernel_init+0x10/0x10
 kernel_init+0x15/0x1a0
 ret_from_fork+0x68/0xd0
 ? __pfx_kernel_init+0x10/0x10
 ret_from_fork_asm+0x19/0x30
 </TASK>
Kernel Offset: 0x21600000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on
"/dev/sda" or unknown-block(0,0) ]---

Is there anything missing from the reproducer guide?
initrd/ramdisk?

Thanks
Barry

