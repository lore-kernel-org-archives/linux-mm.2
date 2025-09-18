Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C71CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02968E00D0; Thu, 18 Sep 2025 04:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA928E0093; Thu, 18 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC94C8E00D0; Thu, 18 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B84EA8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:35:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62E8411ACF1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:35:29 +0000 (UTC)
X-FDA: 83901711978.05.40CB93F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE2D7A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:35:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcCmJamk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IGc7mj+M;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcCmJamk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IGc7mj+M;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyfKm7+KRwxWY7q1wLxikoVQmo7RrjoViu/XFLBPfkw=;
	b=jaTghWbVfJ7KWEO3q8qwXjKqNOp8cJJbxy6VsL0IsajbpN+25nQoZ8YXhd1oA3dO3fWvVU
	lnnk+ZDw3RoMxRt6531NjEN9m21YWXgPAuz+3CLFpScCl/j434Q3A0JW+qbu/Z8Us1ELI/
	uoAVowb5bPjVOGyDnjvNFshdc0w2TFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184527; a=rsa-sha256;
	cv=none;
	b=kSoJgDLIVpSI3FhuW0vQ0x+mhL6sEe+JFISrtpPBCXUHZ8UkipuGcm3e6D0IzpK5+7dnMw
	ybdkBB1s4Su31CZnUP8S5YewdQhVFKcy1wiQLkJtnUXLpFNzfv5ikQ98tYs1okvCfxJ4nB
	PfnTaCcOxvltFhfyCr2cmCPJkMNcF5A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcCmJamk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IGc7mj+M;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcCmJamk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IGc7mj+M;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 156F51F7EE;
	Thu, 18 Sep 2025 08:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758184525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TyfKm7+KRwxWY7q1wLxikoVQmo7RrjoViu/XFLBPfkw=;
	b=xcCmJamklPRXTlqjpvNkqmzHDn0P+8B15HvR4DuV0oGguEUuooR+qUH62lcYTB/sWV2DHX
	/WuhZk60eWKGiz0C+8L+fGfSre9hB5oTBT0M4GwAHzFH4BJyzy0n/v5UfwEzxlIK8Ubaen
	Z2/EzuuTEoKEOycV1NIdWwxEQPFwoOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758184525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TyfKm7+KRwxWY7q1wLxikoVQmo7RrjoViu/XFLBPfkw=;
	b=IGc7mj+M6WOhnyPgrh6zYOi9+dkZp2/TDGhthtFfNojMYkH3lJ/VpdWZw71ymzpiD9qFNg
	v/BaBHi2+Sz8EIDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758184525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TyfKm7+KRwxWY7q1wLxikoVQmo7RrjoViu/XFLBPfkw=;
	b=xcCmJamklPRXTlqjpvNkqmzHDn0P+8B15HvR4DuV0oGguEUuooR+qUH62lcYTB/sWV2DHX
	/WuhZk60eWKGiz0C+8L+fGfSre9hB5oTBT0M4GwAHzFH4BJyzy0n/v5UfwEzxlIK8Ubaen
	Z2/EzuuTEoKEOycV1NIdWwxEQPFwoOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758184525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TyfKm7+KRwxWY7q1wLxikoVQmo7RrjoViu/XFLBPfkw=;
	b=IGc7mj+M6WOhnyPgrh6zYOi9+dkZp2/TDGhthtFfNojMYkH3lJ/VpdWZw71ymzpiD9qFNg
	v/BaBHi2+Sz8EIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB7FD13A39;
	Thu, 18 Sep 2025 08:35:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jVJbNEzEy2hDRwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 18 Sep 2025 08:35:24 +0000
Message-ID: <867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
Date: Thu, 18 Sep 2025 10:35:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in copy_process
Content-Language: en-US
To: syzbot <syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com,
 david@redhat.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com,
 kees@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
 rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vincent.guittot@linaro.org, vschneid@redhat.com,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE2D7A000D
X-Stat-Signature: o7axwdo9jgjjf6imjd56xahfjmpncqma
X-Rspam-User: 
X-HE-Tag: 1758184526-575813
X-HE-Meta: U2FsdGVkX1/U/z78mVbiTpwNbSDfjkh4v5OsDTTaHOWQMkmkIByB3+5CMFDWqzw1S5tj1fdeKxb3b9Qr5fgC3O2H6HVdLWJ9RTaYeYDn9vP+98D+bGJFlwS44IQABeaKCw7CyqMpnuu17i9yb+mAMT4xHvgXC6fgXi52aa/Bd7vrKYZTewNi8aZZ0UmTYCnopx4IyI8UF8NoAW+D2B2HypCj8/9oINgohb0Mhx39r8hqAfvDYH2Lt2YsFtVJ4FAx7XGW+lf9aOgMhuxQgHMa5GhfIDduUqwHIt6eoS6e4XdgiZhJcOGKYrPISCjFPWH0MH0doHBY7qmkFAYcDYvfOc2kh69PqO09BQ3nBTevkK+xvynIIXHMm6NzpfH82RehtuYdkBRcfeacAwy2oZhvjD2RbO/im0Qj62bc5t+CXNVLjWM1oMRgRU7oFzFybn9k5vnTB0ufjC1dHo3GSDueqVoytAxVWvGUBsMOaccUv4WbI88Al1yaGvNo1thQbHuFF9YkyWTAoMNJB0lw+BrHBaNlvXdDV1ZpAYOKxubW6G75MNXH5qcO4uL2snI1URSFj36pntcV0OUxUj1rxtigYqe4x0jv1RuiNT9gh+LGhsfVWfWP1l/wGBm2+45KWLqwpsvKfArAxNThKdtG1XQUwkbIsUDXQCGVDe2ziSdZkcqux2Ke4IgfvuE3w0E8k3+OlOwLQ7T92AeIbAK6XhRGVR0+ze8sj/bYjJwjq7n/47LWCrogeSuMHNUwu9zQ9vildx0Wb9G+bFOx7TXrWgnIeA7ULuwI+7VsvUjXdPhMF4eQcPelcVn3iI8TplXABIzbICBampzLX2+LEzzoFkfKy7Zf8lQHpTM0CJ3Qur7yweYilu504Hmk1CVKkIuVw3oxz88yvJkWtrHksulVF0n36PfTze/01MzgFyCV6sOVhBR9CBbl/flnhEdg/XTQuaM/Rp+y/m9OMN3JfMWhh0Q
 6Un54NHf
 YeBH5CHRve/MoTkwVuNF0Au58zpfNzwheD758EuVmBE0whXvcpUtu0e0ELXbVZqotpa6jdU8YaJStrtjwlWtOW+aeBjwtLyVWFcJWOY/3GrMYKfsSohS3Y/lX7Vr0l4MZ4cvPJ5UBz5MLxyAGfVLGsstdM/pHbHLfHgJd9r8ueYjDoHafxhcFYylLj2KPAp1RCGtdBDUBZB52oG9sF9aqKkGYwwXPHtLj/2PIrSIJUPIR+RnaRcDfWCByKEwh4pJsetFuCkQZFMjTrH6H7lzwW9CVRgJM0SdBU5nVEIbxcIrkv72dLQBNO7k+FtZEiaAMxsuqs+l0vWgWe2gTx9B0aSww491v7sQqZBR+q2hsJaRPHR0QPe4XxNHUnCVPsWTd6fBXTdiMcgyCj+Kd13RH8+V0jPN42oigs/+DXui+hznkN0Vlj6ThLfW6xkKMliFWFJHGmwO0FZdYd+6s1NUN0M4KhwrS7eOZBKBTIBfuz+r+zHxLp3C3sf1cs1/5XgDGFsm7+Ms2nuKnFJOF9xE0uSI79RVAIs/oSAAIPemx6HA5xwJ5BjFUlznEVaFFyhVeR4bi20avnGcG2hA/TwJVvXVoxnMxjH25jolfH8dHTFstlx1wLFaKSXDKK2m8xd0i6rrfVaQG4cykawTfmW0fa7KHNH/g35cmB+xok7er5LNRCDZllqq79daV74t3wWLEMw+QMlpZorG9/5dFmkPCvcFumPNNN/ursdVnf+N94IKaeXjWRsAOMOrv09yv2GizreMnZ9EFtjISMlRA3C1SXgwSqg+R5nYNokf9LyC8pZHUK2HSp5BRKopcVd9tgzHXtqBRoCM2DPfZzlqJPd3h0ojj3keJyKazPD12kIaKEZLgDA8plNX+SAK2mANvZxtN7ZrCrLIm/2xCgmlcjuD9dE4cfWPq27Vt3q/pwJGLetAiyoCVsNWglkSvT3otrKJFmdP60LTwLlrhhhafIMs/6lJFldhk
 xYlo5B0B
 MfnJwS2kMQvJH2g8sYa9Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 22:40, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    6edf2885ebeb Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=16d14c7c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b6789b42526d72
> dashboard link: https://syzkaller.appspot.com/bug?extid=80cb3cc5c14fad191a10
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179d9f62580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d14c7c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c72239eb6d76/disk-6edf2885.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b67e9820b2be/vmlinux-6edf2885.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0c4ab7e562f6/Image-6edf2885.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com
> 
> =====================================
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.1.48/6865 is trying to release lock (&sighand->siglock) at:
> [<ffff8000803b8634>] spin_unlock include/linux/spinlock.h:391 [inline]
> [<ffff8000803b8634>] copy_process+0x22d4/0x31ec kernel/fork.c:2432

bad_fork_core_free:
        sched_core_free(p);
        spin_unlock(&current->sighand->siglock); <- here

Sebastian, I think it's your 7c4f75a21f63 ("futex: Allow automatic
allocation of process wide futex hash") adding a "goto bad_fork_core_free;"
from a place that doesn't yet have current->sighand->siglock locked?

> but there are no more locks to release!
> 
> other info that might help us debug this:
> 1 lock held by syz.1.48/6865:
>  #0: ffff80008fa00450 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: copy_process+0x2228/0x31ec kernel/fork.c:2274
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 6865 Comm: syz.1.48 Not tainted syzkaller #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  print_unlock_imbalance_bug+0xf4/0xfc kernel/locking/lockdep.c:5298
>  __lock_release kernel/locking/lockdep.c:-1 [inline]
>  lock_release+0x244/0x39c kernel/locking/lockdep.c:5889
>  __raw_spin_unlock include/linux/spinlock_api_smp.h:141 [inline]
>  _raw_spin_unlock+0x24/0x78 kernel/locking/spinlock.c:186
>  spin_unlock include/linux/spinlock.h:391 [inline]
>  copy_process+0x22d4/0x31ec kernel/fork.c:2432
>  kernel_clone+0x1d8/0x84c kernel/fork.c:2605
>  __do_sys_clone kernel/fork.c:2748 [inline]
>  __se_sys_clone kernel/fork.c:2716 [inline]
>  __arm64_sys_clone+0x144/0x1a0 kernel/fork.c:2716
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.


