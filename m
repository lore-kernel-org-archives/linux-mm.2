Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7284C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 16:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BEB6B0088; Sat, 26 Sep 2026 12:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C3D6B008A; Sat, 26 Sep 2026 12:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C256B008C; Sat, 26 Sep 2026 12:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31C956B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:02:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A561D1C3810
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:02:31 +0000 (UTC)
X-FDA: 85256380902.17.13F855B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C28814000D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:02:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYHApItN;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790438549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYsPa3ZkL4yz8PlqPdoc7ZdbfBh/s71jk6phvT+rCKY=;
	b=PL2C1/G4p1QOAzG6HCCPGgZDc5IS4Bzpp7qRyjEbx6PEeDOHH4rp6LCYv5dToR/bYjB8FC
	EE4P+WzrBG2geLiPBqNYFMrT1d99+1dHe9XtBxqlaDWFrEIK8xoTutZg4Lbm912D/AONor
	LA9hiTYcszE6/NPDMdzNuBxgxlQ+kds=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYHApItN;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790438549;
	b=0Fj2u+s89K0tI4krNsPsqryl6S1OWqqcz6FXtTRSR0gi6v2W/JjTHuHhMOE1B4kuRh7DqJ
	OIJbrDuFpLRatrag7Dt02Q80SYDaXOFMVMfYIH+a97errlUqPs/52t2uJdD78oqvUCW4vH
	NZmzRfY5/IFj18DegtZlPItHTAV1AC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790438548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYsPa3ZkL4yz8PlqPdoc7ZdbfBh/s71jk6phvT+rCKY=;
	b=XYHApItNHS/EDL8HNIp1Ho6iQ4UCNAcznL/1GvcLx06VUfmvGY7okivYO9LUC5l71ee5q2
	io1J4eg85X5hBiSYMt3gkG4tSkHIP8Zku1x6RgAAPNwW4ZR/GbstD0ifM9unZln+Qn7/bY
	7Iqbdj6+b/cIGXXmIYdBg7AGU5Nk7d0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-nHocsf2VMNqRP_hhe6P7_g-1; Sat, 26 Sep 2026 12:02:27 -0400
X-MC-Unique: nHocsf2VMNqRP_hhe6P7_g-1
X-Mimecast-MFC-AGG-ID: nHocsf2VMNqRP_hhe6P7_g_1790438547
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-532c2cac078so29239601cf.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790438547; x=1791043347;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sYsPa3ZkL4yz8PlqPdoc7ZdbfBh/s71jk6phvT+rCKY=;
        b=H1epmOXxinZa4gkS684BuwNFqekds7L54USQXS+GJ+RtQFMu/UVnVWdNCAO0PAMels
         3IVfTp6A74KAA5FKBwwu4zARCFd9640hbjOGYrW1AqvEGFT7A4eaEAm7saYjojEajyKH
         1gv4e085b92rAhE95WjuMne3DzXXqMDnW2ePRyAeqgcNSun0jZPOJs/cB2d6Oz+zQhDH
         mF3Zb12WjcvID39bDYpitG4ZwLn6gP2jsN9kFx7SQntd1AjDmMr0fYM64lN/v4eyXJ1a
         qtJdf7bfNO0fzoKFr9YR+KiHMJ0x29gqs2XPZEfyVFY0WlJg7uPENwmItIHIE8aNCfdh
         3EIg==
X-Forwarded-Encrypted: i=1; AKwUvBzeogAXOiQK8wVJ6mnyULlja2/QHFiYopfYvENX1SP1IZ2D3wkfIHu4z41pW9tZ7tqq+C+F3hxdlw==@kvack.org
X-Gm-Message-State: AFuF++kokjgtLBtGWEuijCHXLk6nRAGx/EQ9jRlMmxulUKzjnHRSt670
	V1bIQ8iQsjwENEWmOVis93z7Q7cGm4Ml6QOwynh9RsWFbz5Z1NzdWjUC6st0zgegbCCgvI3+mWw
	MsfTKHdBiUXB3/9aG9kzX2Q110MWUFSaSqUkce+sRxYBTRUqcwI+8
X-Gm-Gg: AYBFou2XCqCZxSKVp7+e7oOh67P0z9XhMbF0CdoPOxyOyNZ2iWSbQcPA1qmvNBerVLl
	OAnsztFruPUItUkVR03CTA+Gfy0qQ+2/h6rFWSH4dDzbZgdXA7fFJ6unuOlaiw7QvNyytlKo3cl
	DJT50zHCk2V/aBxsyRjBrPY7wyEr/3EnyMPL5NeycPOoxrJybm8zwkn4U+8nZY4KFRJAbvZFof2
	V59kkcczGK6Q3S3TQRZSYURuyGXd8C2RkBSxg/GbXeRRw99IoPjIkAVygfFVCmiyBAiEiDq07a0
	kCsHs6uYQcgzJ5P2XRRgZZYsDhK9HaxorPPhrnZF4zVzw1vjzciMyHPaGKA0WTUydEkvpS7qKlJ
	X34A=
X-Received: by 2002:a05:622a:15c4:b0:530:178a:9dd8 with SMTP id d75a77b69052e-5330b556ae7mr109262151cf.8.1790438546507;
        Sat, 26 Sep 2026 09:02:26 -0700 (PDT)
X-Received: by 2002:a05:622a:15c4:b0:530:178a:9dd8 with SMTP id d75a77b69052e-5330b556ae7mr109259531cf.8.1790438543973;
        Sat, 26 Sep 2026 09:02:23 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-533222585a1sm20528971cf.11.2026.09.26.09.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2026 09:02:23 -0700 (PDT)
Message-ID: <1a511636-7a55-4c98-a0b3-1ea0c301d749@redhat.com>
Date: Sat, 26 Sep 2026 12:02:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: hunting memory corruption bug in 6.18.x
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ed6_mZQpxAFMnWuFHtmXKKwFzIXeGYPukczWrun_dgY_1790438547
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C28814000D
X-Rspam-User: 
X-Stat-Signature: zqaxpkrhk5sm96buyoj5gk143u3j1d49
X-HE-Tag: 1790438548-712453
X-HE-Meta: U2FsdGVkX1/qvJ61nckh8Y6gR378ztJClmP6ExLFUYRsTGxMj8M/TPD9EV8RBeYGS4MsFT8pHgRcPA9i2UvTXZ+2dNShG+DsEhlet/fm4Y7ziT9NWWKJCAQki6sC6Q/SMosnUJrB3leEYzAhuHNNHxb9uibvYUk7SCPZR5AfEsjdLoIhMDI1dr2d53MqQwN5L1pLpvkpDAZErSd7OfxN8a7Cyc1APWeDSgGn+0y+awmVXyYcvIPVBKlbGVhb/hEuy1NfBIxBMa49GTFI7zZlhkoAPjnkiDGSnz1PWZZWyieCiS7jfvA3EEjPbUSutgJbGUdiPgL4izU9VjnO5HQQuCAMb5M4YwP76mU+L2soewFfawHvuLqMPB+pFNuVStFQdMhZkjgW2gtF8+Bh3F02PpId8dIYEH9ORolLGPHI6ddJ0N2TIfHBxXMWuP0FGIckoaS2Gh6zm6U9t8FxuKUPGAJp87C5NgkAMKvPcqb1r+NHVQXguN3PDoLDyDjnSaGuwfVU/EQtbSH7PbfmhjXE2o9DPEHJ4fhrlO7FJI6YHEoEsAYwLMeLplGXm/4M86V0NIDqGdRUy0ViBKt+katWHu+Bw+vFShKvI/PW8ysSg2GYEhMZKxgFlUuK22K6blJrzFhdN5iAq+CgVf1+5cgQ+4sKMyV0676SVRcOaTR9EDQmeJpwWPaIloCaKkeCJWkQd6YXRDlaffWzF6vx8fl4B9giEhktmlyb+iWW3hEPdJVCZtq3dkS+MEHnaCbi+u7ug5qJWjpOOZ2igVb8qgWnKkziyLFqySYKsdn/TsELxxW44JvMPdeqgdPk/NmN2H9J9X3u3tXIYLfx+PGBEXf0hRU5zIry14hCdKwYLES01+zgAH1r/oTanrk+hxDh31K5MtX0/zzkqd/BZV36KTwjBuIpmkIfiRSnaOkaK3kLZbYNdBvZd9ecoThZ6zv/ZEb7ueKSSYUZpFkXkTzJUXA
 rgu/EQ2r
 o3RmqU6clSSYbwciRF7VjRdeM48RkBc5TpMGSJuKapQRcKD+KPPRz4G4HUy9aUNoQPmmh4X1bm8YWfUu9dddeARNdMHYI5bwcTqxHGsyQK3i2knZOkArKROS1q3KU22vzYB85dvY3ZBwv8X6+HviSNvGlFqCmLUtQSGifOHBrIpTv8gXwX1uIPH1pnViTOF1G2b6/gZDpC5TD3puSA13GY7vIoms71nUrsjc3Pfn0d9cJFy76UcGs0LBPdMVUdAxsbVpMNPS6k1F+AWF7Hx1IsADBKYEtf3y77qJ9ZIkOIw6TsUSw0lPfeoX1SSdlTklgBgvA7q1nxr3CPZFiyhPTfBVeHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 4:48 AM, Nikola Ciprich wrote:
> Hi,
> 
> I've been hunting a weird memory corruption bug for the last few weeks,
> without success so far, so I'd like to report it and kindly ask for help.
> 
> We first hit it after a live VM migration between two KVM hosts:
> suddenly some dynamic libraries in the host appeared to be corrupted:
> 
> Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine.h: 548: elf_machine_rela_relative: Assertion `ELFW(R_TYPE) (reloc->r_info) == R_X86_64_RELATIVE' failed!
> 
> (Later we also hit this with libcrypto.so.3 etc.) The files on disk
> were OK; the problem seemed to exist only in RAM.
> 
> I'm fairly sure this is not hardware related: there were no ECC errors,
> and we have since hit this (and similar issues, more on that below) on
> multiple machines.
> 
> The problems started after we moved from 5.15.x to 6.18.x kernels.

How long does it take to reproduce? Can you reliably distinguish good
from bad?

I know that Lorenzo jumped in and gave some good suggestions already,
but in case you still find yourself without any further options you
could consider if bisection is feasible: start with manual bisection
to identify the first bad kernel between v5.15 and v6.18 and then the
first bad -rc. You could go to git bisect from here, but it may take
several weeks depending on how long it takes to reproduce.

Another option is to try latest Linus tree to see if the issue is there.
If it's not there then it might have been fixed, in this case you could
bisect for the fix (if feasible, of course).

> 
> Since then I've spent a lot of time trying to reproduce it on a lab
> cluster, and we were able to trigger some corruption after days of
> migrating VMs back and forth. At first I suspected the Intel ice driver,
> for which I found similar reports, but we saw new problems even after
> backporting fixes (and also with Mellanox cards).
> 
> So far we've hit three different kinds of problems, which may or may
> not be related:
> 
> - .so library corruption right after VM migration
> - VM crashes (or process crashes inside VMs), possibly related to
>    migration (those always happened during migration)
> - host crashes due to kernel structure corruption (these happened
>    without any VM migration)
> 
> We first hit these problems with 6.18.31; the last crash I saw was
> with 6.18.44.
> 
> All affected machines use AMD EPYC CPUs and act as KVM hosts; the OS
> is AlmaLinux 9.
> 
> I suspect two subsystems that have seen a lot of changes:
> 
> - transparent hugepages
> - NUMA balancing
> 
> (but those are just my guesses)
> 
> As a safety measure, we've disabled THP and NUMA balancing on all hosts.
> 
> I'm aware this is still a very vague report with a lot of guessing,
> but my question is: has anybody hit similar problems with 6.18 or
> newer kernels?
> 
> I see a lot of patches in every stable release, but simply trying
> newer kernels doesn't seem efficient here. Deploying them is also
> risky, since the hosts have to be emptied by migrating VMs off them
> before reboot, and that migration itself may trigger more crashes.
> None of the released or queued fixes for 6.18 seem to be directly
> related.
> 
> I tried running my migration tests on hosts with KASAN enabled, and
> also with SLUB debugging, but was never able to reproduce the problem
> with those enabled (without them, I was able to hit issues within
> days).
> 
> I'll start another round of migration tests in the lab, now with
> 6.18.54-rc1, but I still thought it would be good to report this and
> ask here.
> 
> last but not least, here's kdump from last crash (this was not related
> to any VM migration, but is very similar to another few crashes
> we got):
> 
> [1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
> [1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
> [1924553.456934] Tainted: [E]=UNSIGNED_MODULE
> [1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
> [1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
> [1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
> d5 e1 7c 00 4c 39 6b 10 74
> [1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
> [1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
> [1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
> [1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
> [1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
> [1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
> [1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
> [1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
> [1924553.627022] PKRU: 55555554
> [1924553.633869] Call Trace:
> [1924553.640353]  <TASK>
> [1924553.646369]  d_lookup+0x27/0x50
> [1924553.653366]  lookup_dcache+0x1f/0x80
> [1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
> [1924553.668589]  ? preempt_schedule_common+0x2c/0x70
> [1924553.676837]  filename_create+0xc4/0x160
> [1924553.684209]  do_mkdirat+0x5a/0x190
> [1924553.691050]  __x64_sys_mkdir+0x42/0x60
> [1924553.698163]  do_syscall_64+0x64/0xbf0
> [1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [1924553.713533] RIP: 0033:0x7ff8754ff08b
> [1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
> bd 0f 00 f7 d8 64 89 01 48
> [1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> [1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
> [1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
> [1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
> [1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
> [1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
> [1924553.810819]  </TASK>
> 
> I'll be very very gratefull for any hints here..
> 
> with best regards
> 
> nikola ciprich
> 
> PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
> so I hope I won't offend anyone.


