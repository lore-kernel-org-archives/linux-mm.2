Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D14FFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7216B008A; Tue, 28 Apr 2026 07:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787746B008C; Tue, 28 Apr 2026 07:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5676B0092; Tue, 28 Apr 2026 07:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A11B6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:20:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BC7C1A0585
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:20:41 +0000 (UTC)
X-FDA: 84707721882.24.F2505E2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A6C1C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:20:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ouFfKrgt;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777375239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZRrlNftEWSaYkPlYuyXhwwlyx7ubbXUhvki06OMnS0=;
	b=KAeHqXwmMDMjAS4ZESBoyeyQFoTnRhLs2hFB4LZXajeyCubw+X0G3VJd5bptpfg2fHYnyG
	42Jo2SkBst4HOYbhdiAFzGkwbx73TgerGL+i87tqLGEj+BwETa+vyW/Jwfr40TxaSWWhSs
	2gM2ussbxsW0qhfgW6BXDVciQADg93w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ouFfKrgt;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777375239; a=rsa-sha256;
	cv=none;
	b=ho4povXSouT6hOd9bXG+bx9ULhbHlfe4a34AwA/sqqvnv25Xx5T9xNadxy3+UM5/kjOXpb
	QZt6zrZanWzTk2wFE3s04CYwNMzoZdfZPunqp3aFq10ugaAZ2+OpGnp0/rU/0lORHYxd61
	JSBqC+YwR2487+jGxBVtqoVXRkH2jzE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777375236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZRrlNftEWSaYkPlYuyXhwwlyx7ubbXUhvki06OMnS0=;
	b=ouFfKrgt/mJqUG5kM3lCytRYJiFU1dwYzJobXtg/Bm5vhjQnLD8Gq0EKE4L1LJ0bOgU+u6
	O37+6087Dyg8tyYOC+FHSwuGIrtG9YbBCGuvp0KgLCkdsVlmAuhWovFj4T9CADc4y+eOy0
	v+frVy954rFZDXsCOy7HwrWa7R87LSU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2] mm: memcontrol: fix rcu unbalance in
 get_non_dying_memcg_end()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260428103108.45719-1-qi.zheng@linux.dev>
Date: Tue, 28 Apr 2026 19:19:55 +0800
Cc: akpm@linux-foundation.org,
 hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 yosry@kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <794DD00D-D6A1-469D-89D9-66FA972D0661@linux.dev>
References: <20260428103108.45719-1-qi.zheng@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gtndn9ygxebmdit3d7fpkxmsmxh9b3dr
X-Rspamd-Queue-Id: 4A6C1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777375239-393665
X-HE-Meta: U2FsdGVkX1/IYuVVmR4NCj2pOXDo+EkEquHrEGAe9JjyX/heeatsRCHtJ+IVdhkAl33bktTFngw1p9j1C8cCr1dRB0PJwzUrfZ3uMiyEWMW23nv4Nz7JzcPowsw4iGo1c20+3Zc/bz/nLYZMBihO4Z8ifXGUK8CMkTAz588Ovz+Hv5fLYPAdk1x1pE0BnXcNXzK/3mbgU88nSqwHZaB1RQN69tEFF1ZrXg2ouoTN3TdpV2lFUeBiGIKl9lAVnAdc7s6MKlnyz4wkvVDSUZ2Rxsyx/MIb/J6aWIrTNQeFDv4eB2xfNaQLigTkTV4rR8R7BdSMCskAX7iti2lGw5ACSreV7nUTpikJ7dfwLEnHDyMD/QNoojgDxtDIY5nTnk6ySHNp95VazGjc3lcgyLEvzP3U/449fAlt48R8OsF/xIH5BBK942jBnQM0VIObJvHmWei8546BXczXPpTVGl5Z/tLTXR3r3YNtWRf/XiJkti9F7gRNncigiL3wBXlEyX0jEvCpjgHAAbRzOKjQlsgNl7DPRKr6FbPKQbCMRE8oC/r4hI/nI0sZrwN5Zs1h18sn03sAtvKYye17CLj56VVKth3aeCfggOlJFt0A12pE2Gxk33BwYfPN7dgHqgLzFNOZCRMC73oFg9ZRjIbnH9flnEPR791A09xgaa2URbCM/6BVVVdi9MOTZc0Dk0/5X6M2cLQP4efHDKoT+C7rXHMJQ6bgPgssyH09p/EWHWzjJws0vXU/PYAq8DBFIXjtLbgss6fMMm19yAto7rjVXbRYRWRuZAAjbhK+RKFMCKyrmvYkdW4TjwVFxWvne2B8+bbeVnJ3S+50Q4E7IxI5GSIHklFZb7MqmHHNp8B5NK5aTPQH9tODAFGVOdXyvN+mAbP8GkPWl+VKi2xgPb/EKEF13Fvz3U7ap5bameyK8B1dp7ygLw+kojLasZx0+pe6mV9ZpV8/y7DFNK37TAsVI+0
 IWRKSyvC
 3pkSwm4d2hmgmWg6B2+EwPNLO9NIDPSGE66LDNTAVWxybdJNn1h3PsDsv8Osv+PeaA+kiWPBL6tg9v36cT+3A2LTIyEML7oXcudpPGegZtBCeLtXggixiBKQgjW7FdXc+0Fh+ci1AL0FexO7oqYVXBXOrdrtPRgA2YHyRMG+KvASP2NBOc8bTLKOWKWdvLUahwExXy1NyfLAet2d7tIXB3hzl4+bSfpML9iNjSex108FxXq5rcNQYJIvtSybFJYtBHePOau/hW+2yV7Rgi/U2TDnwj73pMC2xILWGJ+AilYf8vQa9iUJgDoAgFZ9fKcXRcixVssI2TBVTIjykUtDrSGzQrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 18:31, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() =
both
> evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
> determine whether to acquire or release the RCU read lock.
>=20
> However, the result of cgroup_subsys_on_dfl() can change dynamically =
at
> runtime due to cgroup hierarchy rebinding (e.g., when the memory
> controller is moved between cgroup v1 and v2 hierarchies). This can =
cause
> the following warning:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> 7.0.0-next-20260420+ #83 Tainted: G        W
> -------------------------------------
> memcg-repro/270 is trying to release lock (rcu_read_lock) at:
> [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
> but there are no more locks to release!
>=20
> other info that might help us debug this:
> 1 lock held by memcg-repro/270:
>  #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: =
do_user_addr_fault+0x285/0x880
>=20
> stack backtrace:
> CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: G        W           =
7.0.0-next-20260420+ #
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 =
04/01/2014
> Call Trace:
>  <TASK>
>  ? rcu_read_unlock+0x17/0x60
>  dump_stack_lvl+0x77/0xb0
>  print_unlock_imbalance_bug+0xe0/0xf0
>  ? rcu_read_unlock+0x17/0x60
>  lock_release+0x21d/0x2a0
>  rcu_read_unlock+0x1c/0x60
>  do_pte_missing+0x233/0xb40
>  __handle_mm_fault+0x80e/0xcd0
>  handle_mm_fault+0x146/0x310
>  do_user_addr_fault+0x303/0x880
>  exc_page_fault+0x9b/0x270
>  asm_exc_page_fault+0x26/0x30
> RIP: 0033:0x5590e4eb41ea
> Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 66 0f 69 e2 66 0f 6f =
d0 66 0f 69 d4 66 0f 61 0
> RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
> RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 00007f73c474d44d
> RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 000000000000000f
> RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 00007f73c483a680
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 00007f73c4869020
>  </TASK>
> ------------[ cut here ]------------
>=20
> Fix this by explicitly tracking the RCU lock state, ensuring that
> rcu_read_unlock() in get_non_dying_memcg_end() is strictly paired with
> the lock acquisition, regardless of any runtime rebinding events.
>=20
> Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting =
non-hierarchical stats")
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


