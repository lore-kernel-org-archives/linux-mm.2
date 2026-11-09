Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AE5606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OPUUchvX
Received: by kanga.kvack.org (Postfix)
	id CFBD36B05B5; Sun,  8 Nov 2026 23:28:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB486B05B7; Sun,  8 Nov 2026 23:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE94B6B05B8; Sun,  8 Nov 2026 23:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 877416B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:28:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BAAD160586
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:28:54 +0000 (UTC)
X-FDA: 85414300188.19.91917BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A6A7140005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:28:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OPUUchvX;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794198532;
	b=mSEgIv8Y/v9pOG699daEjneRkAfTtgvf+KnMtNkG70RT2vwm33TtEXR2wDYKa549VTZ8O7
	b3uIoc4kBQ7vo0Q88ijVA7FadFF+84SAk+2l9VppR5Ou4cLUioqqFd5UlvgH1PINUiZrlS
	msuE6Th1RsXMyBmRIqG4U4EvTbtvWDM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OPUUchvX;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794198532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiUcCzz6eRwbUbbG4pYyGQ2qW/jd88V1nW8iaclZzQk=;
	b=rpNOlD9i0r6pfez5OIKLemE0+hjY4eJVExPt5yzuaQ85GIBAnInj+pdBwAac9PU7u7fK69
	rCw2Rzl1CgvvfHSV8Zy+KBH+v9ECHjH3U7VndFqZaiSHI6tVB0m37yCTefZb+Z9GcZWeTd
	MfaUkB9Z1NQXEZzwrAsB+GTjjoCzlsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 371E64017C;
	Mon,  9 Nov 2026 04:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529EC1F0089F;
	Mon,  9 Nov 2026 04:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794198531;
	bh=FiUcCzz6eRwbUbbG4pYyGQ2qW/jd88V1nW8iaclZzQk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OPUUchvXcqcg6udQdlvlPeSph4r8aU2+2h4HR8XyzRuZ/eKrMZHZfbOdvKwV7k+86
	 IcDKpcF256QyOZ0wHoSH0TKevcbwSM+sE2tI//+lGGIfvXG2grY5nOy9xIK5gG8rsF
	 ebk4yf4QP4sRcHLdKwW/IR1CO71muJK8RfYRrnRk=
Date: Sun, 8 Nov 2026 20:28:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com>
Cc: bsegall@google.com, david@kernel.org, dietmar.eggemann@arm.com,
 juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com,
 liam@infradead.org, linux-bluetooth@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 luiz.dentz@gmail.com, marcel@holtmann.org, mgorman@suse.de,
 mhocko@suse.com, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, rppt@kernel.org, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [syzbot] [mm?] [bluetooth?] BUG: unable to handle kernel NULL
 pointer dereference in __refill_objects_node
Message-Id: <20261108202849.2e5c40a630e66dd39334a915@linux-foundation.org>
In-Reply-To: <6af144ed.f50b2b3a.2c0de7.0010.GAE@google.com>
References: <6af144ed.f50b2b3a.2c0de7.0010.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aiyhwwxets5gfqu7mgha98zepwazaadt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A6A7140005
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794198532-533139
X-HE-Meta: U2FsdGVkX19Mu8Xy7T5R1uWb7qr9WKgY79/T6VuzjdsMOWWpE83HHT2KcsXfbJXhtZh6mpufj1kPLtyJd6cb9Ltp5ergAi9hZ31av8eqsBBnJLJCf31/Wnlw9kSVwMq8zgmDHprIcpD7PTKHXgTZ2hvmklf3+zR2dVFi3q3sj6bJ6tRg0KZOwnC2a+Bd8dzLoSxr13240UqpCCNk27k4OSbOKaEN4Bh2C4tofG18shxyikDWLzMEWCMX0e0Zsl/SR9tgtl7GNWtuBMQOJuSBS+Uh7U7jSHWu1XgehXkA3zG23VbGTRUUjiZ+8XUDHgBOlVrHBzB9BuGFnarJVXkPTQx4Zi9zirXDJsmKSJfovb6YFZX7+xLWp7CeG9IDYluyOGteNNtaYYWLNQuFp2gIojzTyCppcsr1mXKAeO338NsKBFhYVlCMLaWWyXMdOOgGmLKfiqgzA60MS0IdK7TgwL2tpL33jn5udB9FXiXsPZQwd9lB19JWbVRcdLBaSO052cRqmW+r2UffFP7bPoKkNjO2aKyMXZUmgMF4DR3RB31ej2zoV00H24U3R3bApXtCNXkKRGHnEaMPapcd2KdsuUND1QjMyvx6gl8J9anLyM9WAciNK0zDg5EksQu4hdrllJV0W8xTj65vIXg9NhXnrRgVqssNox2or8GAz1YTDTr2QBE+Yna42HNGnhzqPRFhoSeZZIni/F7QncmgaiDTU/hKNGYww37PrRNZfj+4etkaaAdYE1+pmtbDO04QsV2yVIjxBrNdYYTMGVv4o0L/bTE+914CVCH9LsyVMef8RTkcxteNEbv5lgXDuC0XUCGWs5Q4VcQPxHd6MrPp2HNDVzkdOXoWF/ft3krfXVGHFmirRvy+HqTXdzPW1+uPeptoG3JrrfAn/4+nfrt46emYLPu3pmnSkuLIP8SQSp46j3CtAi/YCyj8c6qSe2hTQBe7FQueUn13chqUCcudalV
 86Vb+pmg
 nY4/rUK9IcXbDQqr0x26l8YIVpisoE+8KIsVZXSQo/EpOmfGX7BcQfgMWkm39VeBLkmTVb77ngSvecFSLAVMCjRCcM+UzqId0Xj56mH3y7uaz7u9oWLWfB9/y1bJbeI9fiMgeepv1yiy3E9tZ4Ptgb1oADDm3vk+p+4knrxPoNiZzUp8/B3bbJoKfhD9i2VBkTQLtFfR6khwEvS2R8vSRcaRLxkIWlIfk0nlhvyA1Ly3BH6BHJ1WQyletO7Mc+Y2zW1DR7Z/40rQi6jC63JpQEk+MDBeef/oQloe9/KLYHy49SdVG1paEr6ayHH4sCHcatXEdgHUbD/RHEaTY8BImON7aaGl3aNEP8Bc5SuirFyQgTIZG1DYtijqcZih0Zs5iC/VC3RPQQT2k9gGaA+adYmo5TMMwjRX/rHFgIcToUsgY5Ay0ZfH7evEClZUR6lmGf7/rfKSXqVu/MLLqnuO3PaWgX9Hz0CL5YZoSnygTw765ntvmYqvuWWDpdxItLGkw1d3AY4GR4w9+r/Wzy7Zdr46K7nZgxMKhwKj/dt5rNXurh5Y0swLSDpYYxxMaaHeg210TI5NqHi6hBAF5+Lq4rDGjbzSm/c9JDLoR6gsqNC88pqIqFF92fnBSRc3BPqAhsy2zu1CGui8DZOJJmFAqkbUIW5HKGybwGuRgKwXTgZ2fMelbecY6Py248YcwqG9THbPBzdz211T4CadKZipcUf6tSkdkIj6WxSFdWiZAk2ESsM9FbeGYAAZv4FHWW/DQWVa61hTuFobsaFU4zpIezQeJ5JpdW2YC/q9w8nl0508Ae3pUk4H+C0NGM/eYLtpdveZZ16LgVRixdBuXOzFnB5JFOG+zPAX6JKA4+03cuY5DYFlG+IOPAqxQoid7hFt6dx+CaC+DNVsmJCFiYFvD1X6FfruHNlcE/dFjzVo/sifXedj/rJRxKv/Nti7v1G9PfwtuOuVa3NHii06sIe4eEkesqApN
 BpKejKd/
 4cW3WJY6hTCx6+VTxi7uCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 19:58:37 -0800 syzbot <syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com> wrote:

> syzbot found the following issue on:
> 
> HEAD commit:    58c1eb84e977 arm64: sdei: Preserve the interrupted context..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=12d1d369580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a58b6b4d667e7a61
> dashboard link: https://syzkaller.appspot.com/bug?extid=73e34786d639a8eb1324
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1255c1a1580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b1ec47537e12/disk-58c1eb84.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3bca0c2b1169/vmlinux-58c1eb84.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0a7c49594d5a/Image-58c1eb84.gz.xz
> 
> AI-generated root cause summary:
> In mm/slub.c, __refill_objects_node() replenishes percpu sheaves by detaching a
> freelist from a partial slab via get_freelist_nofreeze() and iterating through
> the freelist pointers in a while (count && refilled < max) loop. Because the
> loop condition only checks count and refilled rather than validating that object
> is non-NULL, a prematurely terminated or corrupted freelist (where fewer objects
> are linked in slab->freelist than the expected count = slab->objects -
> slab->inuse) causes object to become NULL before count reaches zero. On the
> subsequent iteration, get_freepointer() dereferences NULL + s->offset (offset
> 0x400 for kmalloc-2k), resulting in an immediate kernel NULL pointer dereference
> crash at address 0x0000000000000400.
> 
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=73e34786d639a8eb1324

Thanks.

: This looks like a bad syzkaller test, not a Bluetooth bug. The
: reproducer runs as root, opens the active PCI device's resource0
: (mode 0600), and maps its register space writable. It then places
: syscall arguments inside that mapping. On this GCE VM,
: 0000:00:02.0 is the NVMe controller; its BAR contains live control
: registers and queue doorbells.
: 
: Both crash logs show NVMe completion ID and generation-counter
: errors immediately before the SLUB fault. During minimization, the
: same program produced crashes in several unrelated kernel paths,
: including runs without the Bluetooth operation. This points to
: disruption of the active NVMe device and subsequent corruption,
: rather than a demonstrated SLUB or Bluetooth defect.
: 
: The logs do not show the precise MMIO access or establish how the
: freelist was damaged. Please rerun with the resource0 mapping
: removed and the read buffer in ordinary memory. If the SLUB fault
: persists without the NVMe errors, we can investigate it as a
: separate kernel bug.


