Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249B1CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8458E0048; Mon, 25 Aug 2025 11:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FC58E0038; Mon, 25 Aug 2025 11:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EB68E0048; Mon, 25 Aug 2025 11:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3505E8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:50:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6A3A1374F2
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:50:24 +0000 (UTC)
X-FDA: 83815716768.19.284E872
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 936AD10000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:50:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T1rSEDD2;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756137022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tG5Uvy34G4VaYtOQbgDhW0x2Sm05LcSeBkUrIRO1wFc=;
	b=7QXJQFQ4lLhIj+Y3WG1ovym0WMLZQgbNy6PVLQLAD6qbproTkhTVnKwIwB+MlfdrOAu+TW
	MBy3JGeQbuvQyaVl1DBgHC74oLAIrK95hnbIyURKE5VNdgOyVlaTNy1a0tU32fqlVh8dHb
	xrrmmcfqPM4lP2mMD9B9PPlJ1QgEvOA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T1rSEDD2;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756137022; a=rsa-sha256;
	cv=none;
	b=KGIrqpDgkmeum8Q7wNwXJLKICrJNQhZwY8lQHbbG/ucyOGaxM4u9iIlvrR4rDFs46foXOQ
	eXSEFUKFsXmSNjvvptFBKvjbEr1lfGUMW4DYYuMMozbNUEhV80N3Genvuu+K5P6HoFmc5V
	Qig2E6S3jlEX9TUYJdTbzyi11bQ4YxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756137021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tG5Uvy34G4VaYtOQbgDhW0x2Sm05LcSeBkUrIRO1wFc=;
	b=T1rSEDD2Ll+IjH9TWgV82DtdWM1Jc8fOolhL4DNNWiM1RX6Q+90F4+pVrtdnjK+qBB6la9
	rAxP2AF3Zd96z3HDN7yoTtZwH0tTz1zFGghMINluShS3CbXca0ZZ2fZJPUJqtKxBySIqkT
	9Aa8jM9uy+YvUNBNDOCjCJGweVNoBvA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-f1oDvlmyMRChtHF7ZfY9HA-1; Mon, 25 Aug 2025 11:50:20 -0400
X-MC-Unique: f1oDvlmyMRChtHF7ZfY9HA-1
X-Mimecast-MFC-AGG-ID: f1oDvlmyMRChtHF7ZfY9HA_1756137019
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso32686955e9.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756137019; x=1756741819;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tG5Uvy34G4VaYtOQbgDhW0x2Sm05LcSeBkUrIRO1wFc=;
        b=MqYPQWoc78bfwPpsgAPYDEHml0qKo6IMlGem8BN4xkaEPdZSRDU+OS22Zd6RpZ9dwN
         tOqgp2zvCCrl4CCJ+8gkp7jNQ1q+8uBE2jJhwKkUtmhDcrZEq5xkxgMuQJhEq1Gh3BEy
         /XKfAnB+iaajd+DdXIPDFzv3azY9Cbf+rFRtXx6pZwvpNJdYXx2RPcTH247DmVeye1Kt
         +dEqTXI4D4sQVSZblB2iErMcltiVX4Ps6mipStjpTrEcS13Jgx2mS2Y+3zzN/y+i3gyT
         j5c7qZ/kL3pZDvqyyT+9DzqKXWAtzu1qO8N/ik5L4oug9DQwAuM7wnl7SulI1uuTuK09
         aorg==
X-Forwarded-Encrypted: i=1; AJvYcCWrWp3FGuWAWiMNdOPWl5E9LyP0rCj9647tYdlO4zVLKxLy6+QoLXSaab9j0Fxy8B3cBsxtGlFB6g==@kvack.org
X-Gm-Message-State: AOJu0YxfoUFFm39JguRcD2AbkeWPYZrgHYncXPGkzXkrUt3YpB86ttlU
	Rd+d1Usmw16Lsf/UG7VAYn15UubGwNXrUudqa2Y6NdD4Xa/kIq8pZiK96E2C8fjajJKiHX3LsFw
	aub9+wbuhnN9Tngs+oeUHzpNVkicKZqw30NStZFamrpHUCQaV9hwdbW+eiJkp
X-Gm-Gg: ASbGncsDRTA2rHC/rnas140YRp7mFhKs5w0gAUF1122zwcpEF/EisdoFMB51xo37Kn9
	vkneXd4Ih2tYY75WpwJutAreNTiNtJDER+Zdf2ASzTqZCIo91WVpqjunQM1v3Or40wMbNcHaI1X
	6zcCM/4MuS9rvOazCmaRhNRqw4UXBiJLXIXAxhH20Ols9ZeXYI2Tc7dDBMgWP0sMgV6z4WpP3cE
	d71Dw+eZq4x0bOPg8JQTobRWhui8HVXBsDFaWJlTenXEV2ireW9LeT4aFrMS/WzzgHrsofo7VHx
	VR1SEBcTYxxtaRt04bYgfDlsc5FDgqD8zQuXgKbw+f4SUjWT9a7wxoqbASSQFFwctiSePTWb6zr
	qM044BvEKj6sTmC87HMtrQbs80fvU9h6XUhUiK3SRwB6tLFsyiuAx/UCcy+NcIh3P5lc=
X-Received: by 2002:a05:600c:3b94:b0:458:bfb1:1fb6 with SMTP id 5b1f17b1804b1-45b6456ee5amr14386625e9.2.1756137018610;
        Mon, 25 Aug 2025 08:50:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/tYtGlE8gporVUpEQFO1l4MEMVCgBY55Ie7yU5UBA536VeRKs/B7bAtuoKWu/URLTceBmFg==
X-Received: by 2002:a05:600c:3b94:b0:458:bfb1:1fb6 with SMTP id 5b1f17b1804b1-45b6456ee5amr14386225e9.2.1756137018123;
        Mon, 25 Aug 2025 08:50:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5759274asm114311135e9.23.2025.08.25.08.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 08:50:17 -0700 (PDT)
Message-ID: <04adff83-3771-4a51-95bc-cc11bb169e35@redhat.com>
Date: Mon, 25 Aug 2025 17:50:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in copy_process
To: syzbot <syzbot+69c74d38464686431506@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com,
 dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
 rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@suse.cz, vincent.guittot@linaro.org, vschneid@redhat.com
References: <68abd1c8.050a0220.37038e.0083.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68abd1c8.050a0220.37038e.0083.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: XjUiqOqJcspZcrcdLyntC5-bSS2zJuX9ybOQqPGo2nw_1756137019
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 936AD10000F
X-Rspam-User: 
X-Stat-Signature: sgi7qupyd5p4eidt6fchje4r15kqcxfz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756137022-79968
X-HE-Meta: U2FsdGVkX19cLBy7TxREVC+2HDtNrohd0V4IrWY29pMR6xsiAGnt3/faGvLxVlZFXLZcNmPl3SsieXFbpLMCcuBQ2SZNarcjjPP1C3s6TCnkGMJT9EWllGIb91Qx7iHvzRhD5YBjWvS41KYO6Q6E+uDpbAnszTmq49MHzoWrtwJzhtix4COHU6m71Dlbhj4RDQdhQ2NSfUe84/1cvfRXDYi4nR5otLTpCtW6CJHRYU9i08aiOVnzysNB8Q4nHZ3RrO2AHiR45P4jK6YLg8FJwF2JLVCdx5c+9WaINX/p0C6HWSx9emmNhBzQ5lWBD6Quy7fQQRL7NfBpR43n7uArl+wXOVg2qF+za69zxxc8QCoPVxtOdgWbfVe1+wgbpW3/NW4MclkZoYthlryKGWBHnBVEe8mNkA0H77WtsCCN5j0/OEQeCOrWTCqE+kumijA24VcVUbk3lMEFxdcl4yecMFmB7ce5n0zFbvHRHNt3XRbvlsMfx/NLVTIrUnDFfd/j/du+e/0YDazsF0vSFWlc0alccEf2Xt+OQFEeMwT/mW4uPvZfjS5dYMEQxpxk+bYwrqwKhq61oBMQ042qn8A7YLactNR0VcFqMxBafLjx66+owYhmlmSLesT1kePf9Ips7b+feDS56jDVYfUUErgp7p6znKHbwnx7lChoYcAev9vv3B23cctAkaab3aJQKHjXKXmhMEghYVqcYSoUtxtxUY2oSlNqOO3VsG+i2Z75Qsl1pn6CzN3ZWW8P46kMmjzNbF+RGX3H5RkcXIvmrfKaQECqVRJ1F4oQQgxsARwA0oOiOJT4tPQBgB3hkFumIQmzhnhe0tpGn3S7u98Pfro9h2bEaKDdSs1nfXP3QKRUngL/+vM/w5A0JQb7oEcIZ/hMsKvm46hxUkaqorPJtDFIfMzyZU5yUuSdfTK84iM0iGCv/+iWGPyXsh8GovXdQyVy6xfJPUcu/I9NAfklKgH
 hRH2RGD4
 zCG+uDgTO846fQJ3mtl3VnUeZ7Yhq9Sos5RLaNLrFTCGaQfxkMQAo8izvo/R4O9tReD3c5Ougx6ChGr722/25wN6EssAPK7dEff0xEixNMSJ6FHvvcGwkxqm709pPGvUEN58I7ZTGxUyo1iiQgIhlU6FPcPZmzAA2fm7gLZeYMz2zZwpKAgASBEFlPxqimyeQjpak8rluX/eDNP2uHYB1J6f2JUfJGiQ1zcq5rsC3wVGoVJXfWOQ1sWG1u0yybAdNO7psiFfC0vEpkiyw9j2F2oGxB+ATI59UyXEbtUQrDbzOhUVkmFCZK+Dm3vXAu4P+g/Y8EX3Mz1DXqBbi70bx6pt0c+NK2LUzxYYkdqelu1iH7Hz5O+pFVIPGlI0H6RUPbUcpWtpqfCW5bC41+0Qh5TmzlRwpYZ3vrpIRAxv52lJ6zctAvhB81iVSeEexBamk291sMxlaMUh6lBy6a9lYZpLuytaGND/ffJ16Q9B8gPeKz24eh21OPl+FvMLquz+NRP9n8eNHhSmxWxifc5snhx518Ibl2IqmEOHmQLggdhpjidKcCHSYzrqq1Ps5CiAjGqUtIAVY3VBcf8mf8sYnq+HS0rtvho0I6l4VOEea6ZTESjGvJBpNrRc/VKmBHtOlSQIzIs7vssXXkAV9sr9xrh+GOdVZW9TRaZtTOT/sS3K6KmEOE/1RlwrvYw2d5haY7mu7rgdYJk1N2S4k3hl0mF36n2gNClGH2idhOzsiHXicugtke4t1LzcPwijYnfirBOBfkRD8LXN6FEh70z311CKzOubmkC/oAOC8IA9D2woseaAIcF3iiafJ+0sDJHfk3A9lcKPAxTMm2i2C5oYO5RoUXWcXYkolFTEYQqTtLiBXYemPqYX6N1abN9A6K2on2AlqZO73ZH3EUbIhFgPuA2yNQeDYvRuJnvabZo9wzrSNhxBQxj6UVpMdZxu4+9TXF5IlsDukvntNvN/erNYggc2lKOlW
 bJMcvkvv
 1Ur+V+VJw3xVlfU8Kq6hGKQE5Gi8yDbkvcgGl/5FiJfU+OjyB++At3cwTZwHxPZRdVAn+OEnBWRFE0aQfgFitHj1GkaBgMAQCWDDN9jrqwsg7o6TStMPv4mn/nj/gi854RUAlprMzqvTYETV0ZgH/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 05:00, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    41cd3fd15263 Merge tag 'pci-v6.17-fixes-2' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d8b3bc580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fecbb496f75d3d61
> dashboard link: https://syzkaller.appspot.com/bug?extid=69c74d38464686431506
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ea83f558e101/disk-41cd3fd1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a35b75cdd97b/vmlinux-41cd3fd1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/37d76e9636c2/bzImage-41cd3fd1.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+69c74d38464686431506@syzkaller.appspotmail.com
> 
> oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0-1,oom_memcg=/syz1,task_memcg=/syz1,task=syz.1.3237,pid=23388,uid=0
> Memory cgroup out of memory: Killed process 23388 (syz.1.3237) total-vm:101828kB, anon-rss:940kB, file-rss:21532kB, shmem-rss:0kB, UID:0 pgtables:116kB oom_score_adj:1000

Here we are killing 23388 (syz.1.3237)

> ------------[ cut here ]------------
> pvqspinlock: lock 0xffff88803512c0c0 has corrupted value 0x0!
> WARNING: CPU: 0 PID: 23388 at kernel/locking/qspinlock_paravirt.h:504 __pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
> Modules linked in:
> CPU: 0 UID: 0 PID: 23388 Comm: syz.1.3237 Tainted: G     U              syzkaller #0 PREEMPT(full)

And here we are still in the process ...

> Tainted: [U]=USER
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:__pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
> Code: 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 67 41 8b 55 00 4c 89 ee 48 c7 c7 00 81 ad 8b e8 fa aa e6 f5 90 <0f> 0b 90 90 e9 64 ff ff ff 90 0f 0b 48 89 df 4c 89 04 24 e8 71 15
> RSP: 0018:ffffc9000e9c79c8 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff88803512c0c0 RCX: ffffffff817a02c8
> RDX: ffff88802fa9bc00 RSI: ffffffff817a02d5 RDI: 0000000000000001
> RBP: ffff88803512c0c8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 00000000000d4550 R12: ffff88803512c0d0
> R13: ffff88803512c0c0 R14: 00000000003d0f00 R15: ffff88802ab43c00
> FS:  0000555568154500(0000) GS:ffff8881246c4000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f86cc8e86ec CR3: 0000000060c0e000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   __raw_callee_save___pv_queued_spin_unlock_slowpath+0x15/0x30
>   .slowpath+0x9/0x18
>   pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:562 [inline]
>   queued_spin_unlock arch/x86/include/asm/qspinlock.h:57 [inline]
>   do_raw_spin_unlock+0x172/0x230 kernel/locking/spinlock_debug.c:142
>   __raw_spin_unlock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_unlock+0x1e/0x50 kernel/locking/spinlock.c:186
>   spin_unlock include/linux/spinlock.h:391 [inline]

... busy during clone.

I assume that it is 23388 calling clone() and not getting cloned (it 
should not get scheduled yet).

So likely, the OOM is shooting something down that kernel_clone() still 
depends on ... maybe?



-- 
Cheers

David / dhildenb


