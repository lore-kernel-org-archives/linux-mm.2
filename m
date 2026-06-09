Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961AECD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0092B6B0005; Tue,  9 Jun 2026 09:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBDA6B0088; Tue,  9 Jun 2026 09:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38CE6B008C; Tue,  9 Jun 2026 09:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3E736B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:10:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B4391A0558
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:10:43 +0000 (UTC)
X-FDA: 84860408766.17.817DB11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDCAC10000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:10:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wd5yLZUs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781010641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LMA1Mj5siZjIXHpWRkHKBcjplzx3m0vC8wUsZ6Q6Gmk=;
	b=tzOOjGypwM4EdDd/RerA9VLPalgiD00y5C6wFV3kvXZ3p6BnQ4CHa1MYwrE3P3+etzYlKm
	74V9eBP2RNIa3gkOBSt20e20QYHTWdHRAQwn8MNSfh38bqVZkv1pjokAsdOStlD6g1/RDG
	Sw7FTfzgachjGD/5kyAFFLDFUv7zPhc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wd5yLZUs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781010641;
	b=IrqqCIcvZGwnPus/AoIg75HZ1HUWG47O7DYzUL2o3GZ4w9zCa3kHGvyGHbHYMAuhcWA5ho
	d8L+Xk1lIMAw5KSfRoX+kOUW0JnUKx0g2qs8IZpTwqzlvLRKoj7o4CzTqPkJ3O5f/UJ5lV
	GB7cWHZQ2nVRpk8CZ9TRKCXZAhfJ9ng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E0BD601FD;
	Tue,  9 Jun 2026 13:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0529A1F00893;
	Tue,  9 Jun 2026 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781010641;
	bh=LMA1Mj5siZjIXHpWRkHKBcjplzx3m0vC8wUsZ6Q6Gmk=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Wd5yLZUsgN7k9BHoV3PALVY0jy1GGgloveMwHjJtIoLE8gKpxH5nlKgmpjP7ERSfn
	 zkQ8P2j2ZQmCUa7jtKgaWwW8+BCS36djOByW1gYsrQxfpXmXIzOpu8gaWG56JMdK6w
	 aFFTpVNns1jAw5HBT9oDB51gFMaVmp6UxS1q0i4d5pjNg+uASX/g9lepkrMmfu6Kls
	 +dI3Yu5faxv6UUTxhS5M/MZu2Ixtz3QCD3n3NaEUGyDChCvkhfltuYRqpps8kkqtnz
	 r3ohm4QkB/6EDWyDyByvESwqFR+ReMcln9m6M+JafWfaoNrXk5+mksqveppSMCzceO
	 BvF+oenMygsag==
Message-ID: <728f9f81-f16d-487f-a289-c53a0186d436@kernel.org>
Date: Tue, 9 Jun 2026 22:10:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] BUG: soft lockup in kfree_rcu_monitor
To: Longxing Li <coregee2000@gmail.com>, syzkaller@googlegroups.com,
 vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <CAHPqNmy9uoc=UnbTEwz1Ecnt7pZVRw-1Hor906OdDE3N4J4cug@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAHPqNmy9uoc=UnbTEwz1Ecnt7pZVRw-1Hor906OdDE3N4J4cug@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ECnNl5OGeIXNJtHHcN0J7YJR"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CDCAC10000F
X-Stat-Signature: ctdypz1wnb36empyf7b17yauiuzb1dp6
X-HE-Tag: 1781010641-957544
X-HE-Meta: U2FsdGVkX18pagPF3FosHXvOsB0glb0mCnUtzsVIkGBR16Rwcjin5X6GraOT8X0yyyUoczJ2YRf9QGeGLp3/yDO8QnxlpzwEx+k3gV4Z1kUuqLDICUz6gFzfQhroq0I5+Cu+CYQ24P3Hp7EdCasEL76CamEBP4eD8qzAO1v79hVci3NSLomwyRsx/UoX4Q9L4ryVUKMmIMS5C2+ME3YwA44QSqkkplLiqwG+PPEMQrk6cjOTj7DP61BthwHNkO3xfmDEUhBrelfol2FW1pxsg0fpxKTLAhGPhF8gEdcTKUxxA/CZawqOZP/jVvhGqAjAte4RLCYsNUKTztql7AakoiT1JEATvrrt97Cf/1d1mem5+rdOW3LG68ZWwyJpDBp+UQmn9zZ9+0cM4CJFH3tcKB+aLHp8LzQ7Q1gzFeTu3eCJTOfWLr1jwl5DYKRKPsw9ZTAirNP3hUHhvnzx62nT4gt76zuuFfDWzpshsBg5/kkroHMz2nSjMik+GNqQR4HZT+dUlk+EB8nT+NdNI6hJaACNU8FGZ0CJVwT29C9kMbX6o3HTyAIImJZubUbvMmfQpDg7ys44GSVpLTfCg0yQUlvCAG93TKL1DYOir3bafpVCLKzxA0ZaKcPSf4DCs8I2Cd7wVoehZXfm3lZXxi1bFXkUmDjoZkKB/yPJ1g62W5UcsXGSpAvhdYbWrSfw12rbyAVH6eplWdyjk+nVc13LdRaDUUHzmxyZoqKT1Mou6Pb5VZdh6s8D2P1VhkEoys13uKeHc0CUWpMP0HS2wawyhkMBA6LnpQNtIN53pDo/b6qnMO62t/vVYBzhz7T4C/hLn7jDoSLQS8coFWzaqiShupwQ0SFzRb0q2KQsg2H1V3IgBUHfRY/i1roFhZ0f8ZUSHcUUPBFr6kg6HYOIVSVYO4y+h+8egcZavy9IQ+KrT8X+SSODztoR1+o9aihxFDfVxaixBqnQcsk7MVKv7MJ
 e7yfg3l9
 UD7ZpYVqDR6lCvIDWEGI2uywZA/rNGVjznAUMKeKweBs5cUEwTR2Hwkn9opVwa7b93KK7a2o8q/T7uDek1gLjXczXcbFIhVzolkMnudDrXe+znTmVqwkDOOFDU+sHQ2crx+B5l9io+CAhcebXttM2R7O/lGv5y1UNIrawKr1IMWvpqArlt6a0QX7K+oBdv4I1m6QgLF2lv2xIGRwB4Vsw8XGSlmMNBTZzvVcmxM4rxKU7WzkWIoUifIanE0mhICMEdlSLCEWOXnTRXJ4zoLQehDQB8fEdoDeDbW0mbbA3cCVNjsgAidNLe7KG+i0V8pwAYhIfWERXB2aGr2JzlUfnHL0fgu5mYIwZbfRRXGWWONfkFYNJsLYQLfKz3B89W1h+n6fTL78iAygjzQVyihKk1YMI4l/okST7NGVqG/WOfLx6G5hyJ4/SRJGn6/ijTKjKjrALBHgLbXlGfk0Fo+jOIa9EFdB4jHXadCHDoW0MetrMeQRczStOUM995WaeCa/ePBxLbllj9PKnv8GX3Y8hrG0aNrSWszGtu1jGKVJDxXViMxSVPCpk8zjB/JP0mPanvHltMnWDW/qGLNa5SjJ384ET0OYOnu4log6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ECnNl5OGeIXNJtHHcN0J7YJR
Content-Type: multipart/mixed; boundary="------------Mp7j5m0wDGdS2WX7qsXw3WZx";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Longxing Li <coregee2000@gmail.com>, syzkaller@googlegroups.com,
 vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <728f9f81-f16d-487f-a289-c53a0186d436@kernel.org>
Subject: Re: [Kernel Bug] BUG: soft lockup in kfree_rcu_monitor
References: <CAHPqNmy9uoc=UnbTEwz1Ecnt7pZVRw-1Hor906OdDE3N4J4cug@mail.gmail.com>
In-Reply-To: <CAHPqNmy9uoc=UnbTEwz1Ecnt7pZVRw-1Hor906OdDE3N4J4cug@mail.gmail.com>

--------------Mp7j5m0wDGdS2WX7qsXw3WZx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 6/9/26 8:46 PM, Longxing Li wrote:
> Dear Linux kernel developers and maintainers,

Hi Longxing,

> We would like to report a new kernel bug found by our tool. BUG: soft
> lockup in kfree_rcu_monitor. Details are as follows.
>
> Kernel commit: v7.0.6
> Kernel config: see attachment
> report: see attachment
> C repro and Syz repro: see attachment
>=20
> We are currently analyzing the root cause. We will provide further
> updates in this thread as soon as we have more information.
>=20
> Best regards,
> Longxing Li

Thanks for reporting the lockup.

In repro.report.txt:
> watchdog: BUG: soft lockup - CPU#0 stuck for 155s! [kworker/u4:4:68]
> Modules linked in:
> irq event stamp: 301450
> hardirqs last  enabled at (301449): [<ffffffff8b7e2918>] __raw_spin_unl=
ock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
> hardirqs last  enabled at (301449): [<ffffffff8b7e2918>] _raw_spin_unlo=
ck_irqrestore+0x58/0x70 kernel/locking/spinlock.c:194
> hardirqs last disabled at (301450): [<ffffffff8b7b288f>] sysvec_apic_ti=
mer_interrupt+0xf/0xc0 arch/x86/kernel/apic/apic.c:1056
> softirqs last  enabled at (297862): [<ffffffff86641c3f>] rcu_lock_relea=
se include/linux/rcupdate.h:322 [inline]
> softirqs last  enabled at (297862): [<ffffffff86641c3f>] rcu_read_unloc=
k_bh include/linux/rcupdate.h:921 [inline]
> softirqs last  enabled at (297862): [<ffffffff86641c3f>] mod_peer_timer=
+0x16f/0x2c0 drivers/net/wireguard/timers.c:38
> softirqs last disabled at (297856): [<ffffffff86641ae8>] local_bh_disab=
le include/linux/bottom_half.h:20 [inline]
> softirqs last disabled at (297856): [<ffffffff86641ae8>] rcu_read_lock_=
bh include/linux/rcupdate.h:903 [inline]
> softirqs last disabled at (297856): [<ffffffff86641ae8>] mod_peer_timer=
+0x18/0x2c0 drivers/net/wireguard/timers.c:34
> CPU: 0 UID: 0 PID: 68 Comm: kworker/u4:4 Not tainted 7.0.6 #1 PREEMPT(f=
ull)=20
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04=
/01/2014
> Workqueue: kvfree_rcu_reclaim kfree_rcu_monitor
> RIP: 0010:__rcu_read_unlock+0x10e/0x660 kernel/rcu/tree_plugin.h:443
> Code: 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83=
 c0 03 38 d0 7c 08 84 d2 0f 85 e4 01 00 00 8b 83 c4 04 00 00 <3d> ff ff f=
f 3f 0f 87 b8 01 00 00 5b 5d 41 5c 41 5d 41 5e c3 cc cc
> RSP: 0018:ffffc90000bf76d8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ffff88801f2d4b80 RCX: ffffc90000bf76c4
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88801f2d5044
> RBP: ffff88801f2d4b80 R08: ffffffff916123aa R09: ffffc90000bf7ad0
> R10: 00000000000129e8 R11: 00000000000a7f57 R12: ffff88801f2d4b80
> R13: ffffc90000bf7778 R14: ffffc90000bf7ad8 R15: ffffc90000bf77ac
> FS:  0000000000000000(0000) GS:ffff888097781000(0000) knlGS:00000000000=
00000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f763b9aee00 CR3: 000000000e398000 CR4: 0000000000752ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  rcu_read_unlock include/linux/rcupdate.h:883 [inline]
>  class_rcu_destructor include/linux/rcupdate.h:1193 [inline]
>  unwind_next_frame+0x3bb/0x20c0 arch/x86/kernel/unwind_orc.c:495
>  arch_stack_walk+0x86/0xf0 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x24/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x61/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2685 [inline]
>  slab_free_freelist_hook mm/slub.c:2714 [inline]
>  slab_free_bulk mm/slub.c:6206 [inline]
>  kmem_cache_free_bulk mm/slub.c:7010 [inline]
>  kmem_cache_free_bulk+0x348/0x6b0 mm/slub.c:6989
>  kfree_bulk include/linux/slab.h:823 [inline]
>  kvfree_rcu_bulk+0x179/0x190 mm/slab_common.c:1502

Hmm, I'm not convinced that this is a bug in kvfree_rcu...

It's probably 1) there is a cycle in the slab freelist due to double
free (unlikely, the config has DEBUG_OBJECTS_RCU_HEAD and KASAN), or
2) it is not an infinite loop and it is just that there are so manydebug
configs so that freeing about about 500 objects takes quite long...

But we don't have enough data to conclude.

Could you please measure how long does kvfree_rcu_bulk() take per
object?

e.g.) by measuring statistics of
(time spent in kvfree_rcu_bulk()) / bnode->nr_records

>  kvfree_rcu_drain_ready mm/slab_common.c:1704 [inline]
>  kfree_rcu_monitor+0x180/0x2a0 mm/slab_common.c:1777
>  process_one_work+0x9de/0x1c60 kernel/workqueue.c:3288
>  process_scheduled_works kernel/workqueue.c:3371 [inline]
>  worker_thread+0x693/0xeb0 kernel/workqueue.c:3452
>  kthread+0x38d/0x4a0 kernel/kthread.c:436
>  ret_from_fork+0x942/0xe50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?=
usp=3Ddrive_link
>=20
> https://drive.google.com/file/d/1Rqp_YWdi2uAcO7O8plg5k0NWxulZzoVu/view?=
usp=3Ddrive_link
>=20
> https://drive.google.com/file/d/1nByyr16htns6Fy46FecT2lNzlogiK6e2/view?=
usp=3Ddrive_link
>=20
> https://drive.google.com/file/d/1tJn4jOqAoXxROTevNlotQOefVn1FqS3t/view?=
usp=3Ddrive_link

--=20
Cheers,
Harry / Hyeonggon

--------------Mp7j5m0wDGdS2WX7qsXw3WZx--

--------------ECnNl5OGeIXNJtHHcN0J7YJR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaigQxQAKCRCGXBN6rc5S
1u/+AQCicRYs6MXKBfTR9X0L5LP1w829gj/iBmZkFVT5CQqfigD+IkVFqmEv76VO
oGkrTtgJGG1XhHKs9w99oPgKwSTQxAs=
=g0fG
-----END PGP SIGNATURE-----

--------------ECnNl5OGeIXNJtHHcN0J7YJR--

