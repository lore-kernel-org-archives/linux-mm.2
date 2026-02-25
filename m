Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4315FD45F6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2F86B0088; Wed, 25 Feb 2026 16:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DC16B0089; Wed, 25 Feb 2026 16:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C4B6B008A; Wed, 25 Feb 2026 16:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD03B6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:49:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5544E5A8DC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:49:12 +0000 (UTC)
X-FDA: 84484320144.27.1C94027
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50AD7A0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:49:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="MOB0+Zc/";
	spf=pass (imf15.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772056150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXoXmRfzjD1O7tQISGhzwm/i4H3twNPVpoSuRz/6bJ0=;
	b=Q9Bq/4tKSbNBbJwwynciKBZOxbPvEfKUVsBxkth3ShLcnhvatC//xGURMu7U1OHQdmibss
	ki954Vx2A6xr3dzjiIJbKZ9J+U3r6V9GAFSSDopO00XXWpDRqH3ksM2DT8lUny+eQYaPSO
	BvmQ4t7Mk9SXOtnmVN+lARPj6VZ6xD4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="MOB0+Zc/";
	spf=pass (imf15.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772056150; a=rsa-sha256;
	cv=pass;
	b=BvCQgaYBj7vLu9ODe9wW7rHSHh8u8XtzmTcZRi6Q6RLjvNx/aMF3CVyO9BnAbViVLtKn0x
	8pKWmOQfqG3tfJVpLLfJOI6kOfq4yu6KHoTk+Kjxu4CK6HpMaZx/5jWB6b5BGMUuzhmOFz
	DC+ivGoJ3WkbsiNHC0bH5mRcztLKl80=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-124a60cc9a1so3219c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:49:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772056149; cv=none;
        d=google.com; s=arc-20240605;
        b=DpDe1uh5lPBYw0l2Kdw8xy/Tyxc2Kux9l/PXwJzJ9Y5EhZOhOMY6TaOAvvHMQJ/94h
         G97955PtSWUnq2f0sg9cOYkm8oCZGrmrld7daw+Xq4APkhXoQvYmJn86yglFm/3xmxb/
         T93i2kokO27QZ495hcE5bXGoLVpfd4kStWqYlOQcJUVdJsU8SM/Xt0uStLljfzeeRzKc
         XYgJTkgp0StyIkLBJ1f1GU0DyiJTCHTE2CvsqhtkWSZKiEQGME9U7naRK8wrt2/sUcuN
         08+iULMHWtwmG460cLXbbEVE4vnLOC0HPw8m/BpSTo5AwJcYO+5socUWDBFOUMkfWEtb
         vd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HXoXmRfzjD1O7tQISGhzwm/i4H3twNPVpoSuRz/6bJ0=;
        fh=APnHueapwxS+iwGSqesuKEFiVtFCoQQQ/oERLAMvHhM=;
        b=haXpuye7eemrkFfAA09t26Y9dwK5IjAXiIHT7jpozJ8Hlg4D3TAGhnajMb9BqLK/gi
         +kLnVDzq+CUZ/om0kri66qM2nMm84bnBS61WAl6F7V0izDydceTRuk8Qwv58CuTp0bU6
         nyoLSZ75xLsM1ahjjCnGG7yDSMqJ7oDZJi730F/HCbw1Np9+I6N+Ra5kl5t+4WHnl+om
         4e7fjSNGORbwnEnE+6lZbGK6ZeTMO3gjl/0kt72mx3oD3qAGqDfWdTsYUBOa0utEtdaG
         YUc78z4bLxcF91D1ySOLK6vAi6mJiiqVnzUW6sn9sWhBWNlI6UNtidLzU3ASY2mZKsHx
         /zyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772056149; x=1772660949; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXoXmRfzjD1O7tQISGhzwm/i4H3twNPVpoSuRz/6bJ0=;
        b=MOB0+Zc/hRpvs9XBTne5npJA+W1RSJEDFfPTtJXkt7a9Mgx7TmTHVD7O7LvCL4+akv
         /hoEjYIfb/fnh7oU2RjbUB5MZH/4AEWQgY4HR2zxrtFMT2ml8CyQ5j810xVkQD5hf+rq
         V1B6TWn6leAWwz19qX2TTaDWZrjWcshra9BFtuPGgDq9bYFZgulOlaXfpoCh7WPLQL1P
         UPbJCul1xxD6dS8wKz/4qfN5ZbajMdIXFTNxpJrT4yOvIbJhsHXVO+7RBaXQ9KWalTv+
         XXRoavUU85mlnjde+LOpiv2gBqYsbpPM4AgSmmh4ESssB0ap7QO9cAZY2VQP7u63A8gS
         sPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772056149; x=1772660949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXoXmRfzjD1O7tQISGhzwm/i4H3twNPVpoSuRz/6bJ0=;
        b=ZVD4JpjUYxnuGm11DzEBbO9RcR7V687SFhIY3nQsNbNC5EIRPY8wtetjqMnUWyL26C
         hznQjzBIue9/ZE0plTWc2WzxD2kUtibPM+UqdMrDQhEp1wlM0sgNQWElX3cc8A90QPMa
         Hc3TgdrbXpacFUw2zcMj3HHYAE3GW6hsnIrpc4rAUTNo2F6Y5tk/J02KD/e7Nv/PeVXY
         Z6tnf0fMj8dyNG9ZQikoXZZNG4bJnUEKu522zlEkYbiSkQB3gbL164JKCKjxPMxPwv1Q
         SCqMc6BwmjZJ+pkAl6Dj04wCdXThxalzBKP9j7pkwY6S/iVNLTfrGp+hX2yHYXrvZC6Z
         t6Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXvImITmgDwMPIPgB3dSzvS8tZScT4Okc7iijJRm+gNQrm7qNldDnB/FeJSnGZXS926KV2Kff7dfA==@kvack.org
X-Gm-Message-State: AOJu0YyEx/x5wLya0B4dnkKCLiGoZfj5J87sUXEEEjCkNZXrCcS2fgQm
	WZMEnu3xd/KcRn0gcrGy7k2e2cXjso0R0+WHAoyP0Mcjgc7jo+rKEkL6Lz0zeiDBMtbacpgGm76
	ybhK6+BfBsfsMqRtDJYZQJJZ6QjKxkEsbkyHllsyj
X-Gm-Gg: ATEYQzyvEd23ftyC2qKhXp3HdQ1q3GBfTmavIoUzTvd5R/R0QAEpxaAbCNlZ/2hLTDU
	LYKN3VWMhkxvRjq5eF3vb5uB1e5c6UUm4hJUO8/WR7RXt0djCCEbRqjLuRi3qjl34QO/nb+PZ2z
	NzUc9JcbvnfhVoChlMNV2xku1pHV4/QNgQqcb5NwNJJenWgTFz2NhBRxBi/ZcGYeT7b9kfW7iW+
	gEJ/2VciTmzaLk6iR+8Baqk7of2d7LnDumpfGmwuZCr4Zov1wwOed50pqT4Oa++rcMqp1iZco3f
	jeU9gG+k
X-Received: by 2002:a05:7022:12b:b0:120:5719:624e with SMTP id
 a92af1059eb24-127899a14cfmr15007c88.21.1772056148334; Wed, 25 Feb 2026
 13:49:08 -0800 (PST)
MIME-Version: 1.0
References: <20260225162319.315281-1-willy@infradead.org> <20260225162319.315281-4-willy@infradead.org>
In-Reply-To: <20260225162319.315281-4-willy@infradead.org>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 25 Feb 2026 13:48:32 -0800
X-Gm-Features: AaiRm530P1YSzLEa51H-zQeBl-pzcUCulY2BBR17FOdOE6KBI6RXiSrNhAIYtmY
Message-ID: <CAJHvVcgoCE_LSfQFk4W6mtFLeUrdc4JuvJr=5vv4mCsV5YFepw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fqswdso3g58kyu8btrbip1eohe5pa445
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 50AD7A0007
X-HE-Tag: 1772056150-248428
X-HE-Meta: U2FsdGVkX191/zxw3r5UsdNpWU+2tKHG6HG6KZPdPd+UpX570x1OFevuxm4Jl68Pg7aqCWwEeLC6rQqdBs81pcUNwMXax3sDk6Hx6jahXrCDxakeGFIO3e9pTRwNbY0U4puB3Nw+0hcbegG3MLQNhrdDrKXunMbWItY7ACkx5UxRtsyszO8aYruew6WoReB2nA0XDFCNRnZzrNyaN4BBYAwjsM9YSdFfs6YDC4SK+DKs/ga27wPzlamkcPmV8smxRjouQs9NyM9ywJT97zaAmWRlgv/P4fuMbBW36c7sL68RzvOodbwGx9ty97mHVnH6Itbo1/D4cxMxwfa6dVn4zcXKtkr2VQ9m10+QmlBOerTNCuay48TAyZzt4/rYnxHfPCKX9bgs47wSvpFDymsbMBYWKBcgG4WYH/vt77BeWda4TnAJdELL3D/7NAWd4Gk//qML7HPikhWDdGEGnaDFFkU4y4L+pZvMrUrzNpxUAP4OAKwGrMrUn/DMtDiFu37owWIIutkgWNFfGQcMTbu4KQQiLrJsg340GoL0KX9DEbdaiUgbSZQbEllO8eqNcY2iQGFIdEnIwlgUgESK0CWK49cRdip6gFc/qpgvTzYIszU4Kd6j0dyDT5zccOH8PbJR8PPLyTiJR9jlo49hTVHYCke6XApvVw7jhXeWKR/Vw9vyDC3Zg70pnwyl0ku8TWq/dTFf1xfB8W1n7DaF2DyI7CW1Pk2fIKRtrWakrCI2TTvb330MbVx1NfKnCk4yiZpdu9H/xEBp4keZbehUuBHjgeD2FVbped8bm0hFPR473g/s1ia5gYhKaW1k32HfWsg7aWtTyY9dfEiuQ0GI061oE/K1V9Xu7IF3H96S9UMYKr/8/w+bQx9g60cJ8zpb0yySTEKVZumqXM+XHOvcGcutg6+U1KG2YSIZDQzPa+YFrynZCfnRRa2ZgAKddfDat6Lsb//v2u8U0+SqzhVF/t/
 a2QaYK4H
 9W7oXNiHzWnvzN6tgilVc1gvmRKOEP/+9dINjaidtbhWHk+Utvbq9S3r6O8WA5U6IRByMrV0QHbLmE9B6LujXMgVTSwuLDFg26e9A2Rvb3A0wjsfVWrhcUXk1gVu30ci+b011qC6BHNsXeUtvsHBjYxM6hYRSXS5mv6uSwPvuwLC5nnXjwmHZjt5xFxZD17XzsMqYDCvL8vYq9Otd1A7OapWPvO++uiI+sDFpAzhdQudKpTVi8/KYfcJbKC//A4h6oSKUbHP94hHPJUUjQnhLD63X6gfKcVHOetbgOrwMCchfbFaxGgDt55i0Q/ZDXC6nZqL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:23=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Commit f0c92726e89f removed the accounting of page tables to memcgs.
> Reintroduce it.
>
> Fixes: f0c92726e89f (ptdesc: remove references to folios from __pagetable=
_ctor() and pagetable_dtor())
> Reported-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h       | 15 +++++++++++++--
>  include/linux/mm_types.h |  6 +++---
>  2 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5be3d8a8f806..34bc6f00ed7b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3519,21 +3519,32 @@ static inline unsigned long ptdesc_nr_pages(const=
 struct ptdesc *ptdesc)
>         return compound_nr(ptdesc_page(ptdesc));
>  }
>
> +static inline struct mem_cgroup *pagetable_memcg(const struct ptdesc *pt=
desc)
> +{
> +#ifdef CONFIG_MEMCG
> +       return ptdesc->pt_memcg;

I think this is buggy and we need to decode the "real" pointer from memcg_d=
ata?

I applied this series (cleanly) on top of torvalds/master
(7dff99b354601dd01829e1511711846e04340a69) and when I boot I get:

[    3.315420] BUG: kernel NULL pointer dereference, address: 0000000000000=
4e8
[    3.316955] #PF: supervisor read access in kernel mode
[    3.318100] #PF: error_code(0x0000) - not-present page
[    3.319302] PGD 0 P4D 0
[    3.319877] Oops: Oops: 0000 [#1] SMP NOPTI
[    3.320829] CPU: 2 UID: 0 PID: 157 Comm: systemd Not tainted
7.0.0-smp-DEV #2 PREEMPTLAZY
[    3.322665] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.17.0-debian-1.17.0-1 04/01/2014
[    3.324772] RIP: 0010:memcg_stat_mod+0x2c/0x90
[    3.325784] Code: 40 d6 0f 1f 44 00 00 55 41 56 53 48 89 cb 89 d5
48 85 ff 74 3d 66 90 48 63 86 c0 19 00 00 4c 8b b4 c7 90 08 00 00 49
83 c6 48 <49> 8b be a0 04 00 00 48 39 f7 75 2d 48 63 d3 8f
[    3.329919] RSP: 0018:ffff9b62c0817de0 EFLAGS: 00010206
[    3.331110] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00000000000=
00001
[    3.332718] RDX: 0000000000000025 RSI: ffff98d33fffdcc0 RDI: ffff98cc08b=
8d142
[    3.334322] RBP: 0000000000000025 R08: 0000000000007fff R09: ffffffff990=
79980
[    3.335917] R10: 0000000000017ffd R11: 00000000ffff7fff R12: ffff98cc031=
0c138
[    3.337522] R13: 00007ffc318c77d8 R14: 0000000000000048 R15: ffff98cc009=
e2280
[    3.339118] FS:  00007f2fffd3d400(0000) GS:ffff98d385556000(0000)
knlGS:0000000000000000
[    3.340915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.342208] CR2: 00000000000004e8 CR3: 00000001089ad000 CR4: 00000000003=
50ef0
[    3.343804] Call Trace:
[    3.344383]  <TASK>
[    3.344872]  pgd_alloc+0x5d/0x1d0
[    3.345643]  mm_init+0x1df/0x3b0
[    3.346395]  alloc_bprm+0x10b/0x1c0
[    3.347231]  do_execveat_common+0x9b/0x300
[    3.348162]  __x64_sys_execve+0x41/0x60
[    3.349020]  do_syscall_64+0xe0/0x8a0
[    3.349860]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    3.351009] RIP: 0033:0x7f30004f423b
[    3.351831] Code: 0f 1e fa 48 8b 05 85 1d 10 00 48 8b 10 e9 0d 00
00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa b8 3b 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c5 1a 10 08
[    3.356028] RSP: 002b:00007f2fff657e68 EFLAGS: 00000202 ORIG_RAX:
000000000000003b
[    3.357707] RAX: ffffffffffffffda RBX: 00007ffc318c6b90 RCX: 00007f30004=
f423b
[    3.359321] RDX: 00007ffc318c77d8 RSI: 00007ffc318c6e80 RDI: 00007ffc318=
c6e60
[    3.360894] RBP: 00007f2fff657ff0 R08: 00007ffc318c68c0 R09: 00000000000=
00000
[    3.362483] R10: 0000000000000008 R11: 0000000000000202 R12: 00007ffc318=
c68c0
[    3.364061] R13: 0000000000000040 R14: 0000000000000001 R15: 00007f2fff6=
57f20
[    3.365657]  </TASK>
[    3.366177] Modules linked in: xhci_pci xhci_hcd virtio_net
net_failover failover virtio_blk virtio_balloon uhci_hcd ohci_pci
ohci_hcd evdev ehci_pci ehci_hcd 9pnet_virtio 9p 9pnet netfs
[    3.369780] CR2: 00000000000004e8
[    3.370543] ---[ end trace 0000000000000000 ]---
[    3.371578] RIP: 0010:memcg_stat_mod+0x2c/0x90
[    3.372584] Code: 40 d6 0f 1f 44 00 00 55 41 56 53 48 89 cb 89 d5
48 85 ff 74 3d 66 90 48 63 86 c0 19 00 00 4c 8b b4 c7 90 08 00 00 49
83 c6 48 <49> 8b be a0 04 00 00 48 39 f7 75 2d 48 63 d3 8f
[    3.376675] RSP: 0018:ffff9b62c0817de0 EFLAGS: 00010206
[    3.377838] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00000000000=
00001
[    3.379437] RDX: 0000000000000025 RSI: ffff98d33fffdcc0 RDI: ffff98cc08b=
8d142
[    3.380994] RBP: 0000000000000025 R08: 0000000000007fff R09: ffffffff990=
79980
[    3.382586] R10: 0000000000017ffd R11: 00000000ffff7fff R12: ffff98cc031=
0c138
[    3.384188] R13: 00007ffc318c77d8 R14: 0000000000000048 R15: ffff98cc009=
e2280
[    3.385761] FS:  00007f2fffd3d400(0000) GS:ffff98d385556000(0000)
knlGS:0000000000000000
[    3.387554] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.388836] CR2: 00000000000004e8 CR3: 00000001089ad000 CR4: 00000000003=
50ef0
[    3.390449] Kernel panic - not syncing: Fatal exception
[    3.391806] Kernel Offset: 0x16200000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    3.394178] Rebooting in 10 seconds..

> +#else
> +       return NULL;
> +#endif
> +}
> +
>  static inline void __pagetable_ctor(struct ptdesc *ptdesc)
>  {
>         pg_data_t *pgdat =3D NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> +       struct mem_cgroup *memcg =3D pagetable_memcg(ptdesc);
>
>         __SetPageTable(ptdesc_page(ptdesc));
> -       mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc))=
;
> +       memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc=
));
>  }
>
>  static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  {
>         pg_data_t *pgdat =3D NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> +       struct mem_cgroup *memcg =3D pagetable_memcg(ptdesc);
>
>         ptlock_free(ptdesc);
>         __ClearPageTable(ptdesc_page(ptdesc));
> -       mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc)=
);
> +       memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdes=
c));

Re: the RCU read lock discussion, I spotted that too. I'm also not
100% clear on whether or not it's required. folio_memcg says:

"For a kmem folio a caller should hold an rcu read lock to protect
memcg associated with a kmem folio from being released."

But on the other hand get_mem_cgroup_from_folio seems to think it's
fine to unconditionally call folio_memcg without an RCU read lock, it
seems to think we only need one whilst acquiring a reference, and once
we have that we can unlock. (Not that that helps us greatly, I don't
think we want ptdecs to hold a reference for their entire lifetime.)


>  }
>
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3cc8ae722886..e9b1da04938a 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -564,7 +564,7 @@ FOLIO_MATCH(compound_head, _head_3);
>   * @ptl:              Lock for the page table.
>   * @__page_type:      Same as page->page_type. Unused for page tables.
>   * @__page_refcount:  Same as page refcount.
> - * @pt_memcg_data:    Memcg data. Tracked for page tables here.
> + * @pt_memcg:         Memcg that this page table belongs to.
>   *
>   * This struct overlays struct page for now. Do not modify without a goo=
d
>   * understanding of the issues.
> @@ -602,7 +602,7 @@ struct ptdesc {
>         unsigned int __page_type;
>         atomic_t __page_refcount;
>  #ifdef CONFIG_MEMCG
> -       unsigned long pt_memcg_data;
> +       struct mem_cgroup *pt_memcg;


>  #endif
>  };
>
> @@ -617,7 +617,7 @@ TABLE_MATCH(rcu_head, pt_rcu_head);
>  TABLE_MATCH(page_type, __page_type);
>  TABLE_MATCH(_refcount, __page_refcount);
>  #ifdef CONFIG_MEMCG
> -TABLE_MATCH(memcg_data, pt_memcg_data);
> +TABLE_MATCH(memcg_data, pt_memcg);
>  #endif
>  #undef TABLE_MATCH
>  static_assert(sizeof(struct ptdesc) <=3D sizeof(struct page));
> --
> 2.47.3
>

