Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC3EE7E0BC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA406B0005; Mon,  9 Feb 2026 11:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BCF6B0088; Mon,  9 Feb 2026 11:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D602E6B0089; Mon,  9 Feb 2026 11:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE3566B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:56:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DC8FB6DA3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:56:25 +0000 (UTC)
X-FDA: 84425521530.03.DC4ECA6
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A2302000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:56:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNoZAGsK;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770656183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gE/GnxbaquR/Jky0u1nc/LFQnx0zYTsDuMfOKy0HSo=;
	b=yU66yl/7HOu/nmXuJbucgqKwPlG15xmYKiD0uEDMQL2/y8+hTRoOonG6hHnBK5xYFqw6TD
	oLwldueB9D3A9NNlCsacP3s1zPHnDCozwuaU4qy6GZx294eGAPPXiU+kOEEygwC6pGQoM7
	S51svlwyZu3OG0pVs2WhFiKTT5XofPc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNoZAGsK;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770656183; a=rsa-sha256;
	cv=pass;
	b=qdW5lppZG15goJjN4saC2YRss3ELmRbg81orI/0OuaCvGFGgn/Wqz7VKxkIXJdvLwBCP4B
	YQpH1a1TSmPy0EnYggpgGhu22x9pLMmNYumBINQZdssLzcQTqw2o2pRCdKGJX4tQXFIap3
	yvwdmNc2R4Sl0d1+8o7Ewn89P/6lD2g=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-501488a12cbso56341811cf.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 08:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770656182; cv=none;
        d=google.com; s=arc-20240605;
        b=AyConJOV1iZIb5E5zwngl9EjDDmlmZClTmxpjqoLvccgSSKJvwlyjYeD42e4mvozf7
         xnxOwDF+nhalcckcDiMSN1UFSotpm5PbrtHL5ngj/ZoN4H7Xk7QekQ/ggowKn38IODBU
         FS2g2OpgfWsd7nDEJ8lC5MaEur5q12CwaNeMaEVhwdESoEndMtROMNS4nA/2FdPgY3ue
         jWs8jfYecLI/VVmZau/1kfwx8gvFwErSXYUCiS0xnrGtNMbIB3QvtZh6J2MKZWvCQ5e5
         2O+BRl81aDuuGrUBMaGTjaQpOfLLXAoqLMw9KGrA5AG5dJIihkNi9ZLyp1E45Lmo0xO+
         rVUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9gE/GnxbaquR/Jky0u1nc/LFQnx0zYTsDuMfOKy0HSo=;
        fh=1kosLxhiddin7y8t87Z4Z7zwNzypi/NUwLVMMEDm+bc=;
        b=gTO+4jw22UKV+86P3UoUeEj95URRgU8eHZ/0UqTYxIdrhdKmQT9qMUEgCdwBTnlMQE
         drxqcbncR8c+MpGdpFPfGPxH6sIPU2N+ymGWgBJG1xHSdwlCu3pN898iN6Hi7k7zV3qO
         0MYctWwLNilGhfSY/bb7HH1v70c0fw9ZkQV1Y/+NeE9KjHgmq7ABR6DAsbIidJYshec7
         TJs7nllLoWsIPWKxgwqQI/fIspEUjqaL2O1tfpb7mu/lSWbhXgqIx/U6Wtu5M6TWy31T
         s6edEmUzmJbUT6KDVW7JmmBvMGXkMpw3zKbIvnYUlmVz+yGS4JHyKc9YqwFSa1lW8LHC
         5GVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770656182; x=1771260982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gE/GnxbaquR/Jky0u1nc/LFQnx0zYTsDuMfOKy0HSo=;
        b=MNoZAGsKmvYECll8RLLY5/dDXj/aGjZU7mIzOKZfptbp3ZeuANNW1j4E340eQtbALM
         sNA1cBCuFqwcOXLnPZ7lid0V7RhFu3oNUUvdm/JkozLSgqqNJy94QUelZFA/XaBW1p7J
         tF7YUqEjHa9xwt4E9L97gasy1iuByOLT6MEVBifpj4zU6T0OmH5nu0vGJutHEnn9cRyD
         LLfgdcZlpZXGXzjbZagEVc0p8lcfO2VAMBgaJF8v+7Hv19jSfc7DFyhyvqntUuXSpeMG
         mqCXwf2+WYliObi1Ur8gqwDVMycLuIgi5UEUgrohChQZrkjWxllDix73mm1z1gXVhNV6
         jwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770656182; x=1771260982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9gE/GnxbaquR/Jky0u1nc/LFQnx0zYTsDuMfOKy0HSo=;
        b=ectYthl7DG9H3I0GEuo48OeoZMW/ygHPLPtQ2BWmt8+lF4I1HJoA+HeUT8fV7FBZMN
         EuLCOqRPT4D3Gz2sPnJ3/jLrDYnCCert6Xr1ExZI+i0lf5rUdNFAljEUSpQWYy6/kSKi
         o4ixCEUfvxHCAZVOjvO4IZfF7A7O3JYTAsPBxvIQHedag16lrDIgVhO72SumcjrTgosJ
         FHEjfcRztlYW90R712cYjOR9w15uWjHngsY2neztB5wk12sZUmkPIIZFqE7sr/x+Cz3+
         IdbcRFFQBbYDTWBN5LCWv25ZVAT/v59JUvxZzCSix0NNyJk8EeWdkXeONgTTInHsjVxp
         h0lA==
X-Forwarded-Encrypted: i=1; AJvYcCUo0NJiF0D1H/hjU/WYmIuxvChbu19vmj476j/W2EjVNexKgdZ8wo1hFrU3dWgWf/Ai5aypyquh4w==@kvack.org
X-Gm-Message-State: AOJu0Yyg7oi6sg+ZEf3VNQ+fiG75jWxdz8xbypI2xYriQq1vSq8MpvAv
	VdYQwNotUbXYCOTt+JgWVZAxtPWSbmj3QvIBw924kkR2wUwCceHsS8P4amHiREenor18qf6o6h+
	vdA4/nsRhOOZ8Nd89cBhHeAH9Ho4OTQw=
X-Gm-Gg: AZuq6aLJPIkGDdxGUspdGW4AEKyKR8Vhz7vs02tFDtKm0IHsATKJOQ7FhX+NLSGwMZF
	mYa7WKkweHZ+7HoZzz/0Fy6zv5WY58IpJe80BE5R4pMKIzS69jb0bW8zN49B+rY3c7qHi54UXG5
	5mSB0YlhL/AL7fOev4ySx0RY34Ne+J6GKhHmyNXLtHEXY1HjiWRi7rRTUXgr7RHojvGgZfP+dPZ
	e4PUOvpw22GYYuu8gnehBHV0XlVtrVGSvtpOdaP1x5pANNcOabAvB4ktMpkipujXUh34l4aSBxg
	7Ho2
X-Received: by 2002:a05:622a:24f:b0:501:453e:bb34 with SMTP id
 d75a77b69052e-50639995bf6mr139450531cf.63.1770656182247; Mon, 09 Feb 2026
 08:56:22 -0800 (PST)
MIME-Version: 1.0
References: <6989f0f2.a00a0220.34fa92.0047.GAE@google.com>
In-Reply-To: <6989f0f2.a00a0220.34fa92.0047.GAE@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 9 Feb 2026 08:56:11 -0800
X-Gm-Features: AZwV_Qh99pe2lEvylN_7wH92Hz38dScLErHXd7OQR-VvW36k9zihYCjtVb-hPDQ
Message-ID: <CAJnrk1bfZH=rJm3_7=0_JHN810akMTJsYkDsVs_fd1CSjjm3QQ@mail.gmail.com>
Subject: Re: [syzbot] [fs?] [mm?] possible deadlock in writeout_period
To: syzbot <syzbot+d38b792a5cbd941006fc@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A2302000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 9wojkhehdyfgo5cpuau7qcuj46gzaiz7
X-HE-Tag: 1770656183-955861
X-HE-Meta: U2FsdGVkX1+jjQvfvgnOGXyLLEFgDKEKgNeOY/q9vKMH8ibmJfbPSTb9mqMYHLGXV6oo4hhYK0a73uXP70feQJ2sbUstUvHk1BRuHQha7bF09tDYU39O/fcDsztImcFt3uoxOniSH9qPToSv9rluV1xT5YxI3q19xf6QX7Zw0pyi9PTYdil6XyHg46XaDe7u3fbF2ON6yB8OAKB1nqWd5TxNHoSJhFazp6vPLyz/ATf7NeSc7CL/8Cvr9JnqzkcDp4SwphN6ILn0krRXSFz0XuPsfU7R/XWY5ejXRjFN6Gl9eYbhHBfv8v28ukAUwpv9rxzzpASkNLyX/0QVYsk+EhcNImT93MFGa8IpsYrce29eiujM1nhxv2ayYBtHoTb0d7k8TncKilC6hes6fRcAN1IKhzGXgLTwqI0jX5X+AcjhnW0yN74Wzw1+Df3B6oWAXW11R3ocVU9TGnN18GNUbPdvoESMmcApralVKtkcej5yT4qosJL10nAxyWX4qnA/ImNTr2/FHzxg1+4ie0t9uvLwzVdSQu/uTIvcZJRHtQMiosmV9Ms4XeTEu8W6+PNluWD/ko2X5T1ZWosj2qH7LoocO+ztVdQON4uPpSLsq/sckzoEK7NCMaAe4ppuUR7fGLvOfhS4vGedQjj5YlU4wte4/wjqNA2EEmU0/MOp4VyMsS0VT4agi/zdRDt8hxoxaS/DhFl1LCrcBTgixxkxHDvm1AkCU1uiOih1ARv14spLbdX4dOP1kFA90BaQEKl4EJqUBf8AS+PNZWTOouFwJEDMQW6lLypHyXMR4NsLJAkXKp9LQuEYrz3ToZP1EN6HiXHEIzaL0NZ+YetqFJ3AO3g2Uk26cAA2sTOEHJy+9JsgnfWB3xSt16SurHguVqfPAtRL2c48EfpQhnDSDQ0/KcnlBHVQ566PCXPj2obZ7QFjvv94IvBgJNSk/LSe3+0zXYm1bxdDUNBeAwfnU9x
 9Ec/OZ8T
 m9baIZpv1co0BvKRtUb3CaxqXSoqkkHTC0erCeernEmYir/ccPjfpLHMZMoqLv9D58dNayiCLZBXjw24YHtKty7366/4La2Ps775xk1akNsmcHKig8sVdIivbYnjCleEO3skWqhQtZeyorAkfG+/iLZlUYHie+XkU0nWjbBcJAIxCrDi46gFszEBvttMWkC5Ffww0/37kOz54owQFUGhv6ZWMaGZ0SJtczJAGCFT79LnBwV3Ujx9zOy2ivdLEmyT615HpRAyAnb9pPRuAQhiwGdzq3TS0k+FN39S9gflmROyMiVV9R9ZZECr2c4Ob/kAaVOmQmSFL1DQ77Q7clyMK4+XMkeD5igAjSIpPCUa/6+pF07yZkGsD0kfKNSgTmk2RqPPJnYkBuLvX4zCxwo2oUjHPgHJBQrYP6aH0ZbyGgAQ4YVzwsZQ7LxsSMxPRJ5vf+KEceKM2DJXIgj7l9vswFZ/tEVSms/8aNqan8q4mcBit97hw2WVVr5P5x/vzMrGmiHZCin8ASjEFsYExF8r9peWHKGjHtJC7UAa2zrbc70I/S3z1JJgL0IN12YLlTcdQhhD73UQLjMxqs+ubJQPRM9j6TGmF+ExlYcVTmrJGVOqAui1wXXKyG12/OsKaXEnWOoG9MB/Egi8DZcBAH6q21kjklR75v4GPtE0LYgUq6ByUPoKqHGOFPzD7j8cdFdRhATpUdBVQEYWin7YSHxPCDTzhI1ZYszvmIrTrIwBTsSbr57evCCaTRy/AtLhPwiAuZAWJdJHRvgUMJKp6Obf9KjpPqM0/XhGRL3+TR9QqMFcVRw4vkA0uN+QmzJ2dY8U6Rv2zW6CoNki63Jx1CZLGiv4WRRinSHmRHnTS93W9gDISAQAc/ib18y3d6vzf2Hly+IcMJU/NC0Y8Jdf3ahtl0UHWwgn5o1WbJSWyWX4FmzfKCdF2m2RvqGktaHV8ncZHxlQXbyS6EtMRKaL6hmcyCcptWeMD
 6iM3i1eF
 8YiiFNVS3zbeEuoGGpO2vcKK1w3TQhEE6WpnqWXmZ2506mld2+NHG6CjlyGHbz+QVmDJqOZ6G7Us1d+97hJj8CCGuQYCksUtfApfHluefwV6o5R7V7LnjXSFPG3wbX1M+tH1J0xIgSPt+WVhnDn/bUlj2kHsJwWNpyyq+u2ssjOhF3pJfMCwyThKx+KSw0QVKUJjnsbe7axYgVqByp83/0MKXdpXv3D5Aamusm1hp6xmlEjAiun/L7ihdAjlXq15JKB6vjAK9Hk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 6:37=E2=80=AFAM syzbot
<syzbot+d38b792a5cbd941006fc@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    59e4d31a0470 Merge branches 'for-next/core' and 'for-next=
/..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14454b2258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8a8594efdc14f=
07a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd38b792a5cbd941=
006fc
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/746a1d5c4188/dis=
k-59e4d31a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2eefade79f10/vmlinu=
x-59e4d31a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/140624ef24ed/I=
mage-59e4d31a.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+d38b792a5cbd941006fc@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible irq lock inversion dependency detected
> syzkaller #0 Not tainted
> --------------------------------------------------------
> syz-executor/6572 just changed the state of lock:
> ffff800097626150 (&p->sequence){+.-.}-{0:0}, at: writeout_period+0x94/0x1=
1c mm/page-writeback.c:615
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&xa->xa_lock#10){-.-.}-{3:3}
>
>
> and interrupts could create inverse lock ordering between them.
>
>
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&p->sequence);
>                                local_irq_disable();
>                                lock(&xa->xa_lock#10);
>                                lock(&p->sequence);
>   <Interrupt>
>     lock(&xa->xa_lock#10);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz-executor/6572:
>  #0: ffff800097bd7c40 ((&dom->period_timer)){+.-.}-{0:0}, at: lockdep_cop=
y_map include/linux/lockdep.h:41 [inline]
>  #0: ffff800097bd7c40 ((&dom->period_timer)){+.-.}-{0:0}, at: call_timer_=
fn+0xd4/0x814 kernel/time/timer.c:1738
>
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&xa->xa_lock#10){-.-.}-{3:3} {
>     IN-HARDIRQ-W at:
>                       lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5=
868
>                       __raw_spin_lock_irqsave include/linux/spinlock_api_=
smp.h:110 [inline]
>                       _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spi=
nlock.c:162
>                       __folio_end_writeback+0x10c/0x6f8 mm/page-writeback=
.c:2990
>                       folio_end_writeback_no_dropbehind+0xd0/0x204 mm/fil=
emap.c:1661
>                       folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
>                       end_buffer_async_write+0x20c/0x350 fs/buffer.c:419
>                       end_bio_bh_io_sync+0xb0/0x184 fs/buffer.c:2776
>                       bio_endio+0x8d4/0x910 block/bio.c:1675
>                       blk_complete_request block/blk-mq.c:908 [inline]
>                       blk_mq_end_request_batch+0x49c/0x105c block/blk-mq.=
c:1202
>                       nvme_complete_batch drivers/nvme/host/nvme.h:802 [i=
nline]
>                       nvme_pci_complete_batch drivers/nvme/host/pci.c:134=
8 [inline]
>                       nvme_irq+0x1ec/0x240 drivers/nvme/host/pci.c:1450
>                       __handle_irq_event_percpu+0x20c/0x8e4 kernel/irq/ha=
ndle.c:211
>                       handle_irq_event_percpu kernel/irq/handle.c:248 [in=
line]
>                       handle_irq_event+0x9c/0x1d0 kernel/irq/handle.c:265
>                       handle_fasteoi_irq+0x328/0x8d8 kernel/irq/chip.c:76=
4
>                       generic_handle_irq_desc include/linux/irqdesc.h:172=
 [inline]
>                       handle_irq_desc kernel/irq/irqdesc.c:669 [inline]
>                       generic_handle_domain_irq+0xe0/0x140 kernel/irq/irq=
desc.c:725
>                       __gic_handle_irq drivers/irqchip/irq-gic-v3.c:825 [=
inline]
>                       __gic_handle_irq_from_irqson drivers/irqchip/irq-gi=
c-v3.c:876 [inline]
>                       gic_handle_irq+0x6c/0x18c drivers/irqchip/irq-gic-v=
3.c:920
>                       call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry=
.S:891
>                       do_interrupt_handler+0xd4/0x138 arch/arm64/kernel/e=
ntry-common.c:135
>                       __el1_irq arch/arm64/kernel/entry-common.c:497 [inl=
ine]
>                       el1_interrupt+0x3c/0x60 arch/arm64/kernel/entry-com=
mon.c:510
>                       el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/ent=
ry-common.c:515
>                       el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                       __daif_local_irq_restore arch/arm64/include/asm/irq=
flags.h:175 [inline]
>                       arch_local_irq_restore arch/arm64/include/asm/irqfl=
ags.h:195 [inline]
>                       kasan_quarantine_put+0xbc/0x1c8 mm/kasan/quarantine=
.c:234
>                       __kasan_slab_free+0x8c/0xa4 mm/kasan/common.c:295
>                       kasan_slab_free include/linux/kasan.h:235 [inline]
>                       slab_free_hook mm/slub.c:2540 [inline]
>                       slab_free_after_rcu_debug+0x120/0x2f8 mm/slub.c:672=
9
>                       rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>                       rcu_core+0x848/0x1774 kernel/rcu/tree.c:2857
>                       rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2874
>                       handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>                       run_ksoftirqd+0x70/0xc0 kernel/softirq.c:1063
>                       smpboot_thread_fn+0x4d8/0x9cc kernel/smpboot.c:160
>                       kthread+0x5fc/0x75c kernel/kthread.c:463
>                       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:8=
44
>     IN-SOFTIRQ-W at:
>                       lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5=
868
>                       __raw_spin_lock_irqsave include/linux/spinlock_api_=
smp.h:110 [inline]
>                       _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spi=
nlock.c:162
>                       __folio_end_writeback+0x10c/0x6f8 mm/page-writeback=
.c:2990
>                       folio_end_writeback_no_dropbehind+0xd0/0x204 mm/fil=
emap.c:1661
>                       folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
>                       end_buffer_async_write+0x20c/0x350 fs/buffer.c:419
>                       end_bio_bh_io_sync+0xb0/0x184 fs/buffer.c:2776
>                       bio_endio+0x8d4/0x910 block/bio.c:1675
>                       blk_complete_request block/blk-mq.c:908 [inline]
>                       blk_mq_end_request_batch+0x49c/0x105c block/blk-mq.=
c:1202
>                       nvme_complete_batch drivers/nvme/host/nvme.h:802 [i=
nline]
>                       nvme_pci_complete_batch drivers/nvme/host/pci.c:134=
8 [inline]
>                       nvme_irq+0x1ec/0x240 drivers/nvme/host/pci.c:1450
>                       __handle_irq_event_percpu+0x20c/0x8e4 kernel/irq/ha=
ndle.c:211
>                       handle_irq_event_percpu kernel/irq/handle.c:248 [in=
line]
>                       handle_irq_event+0x9c/0x1d0 kernel/irq/handle.c:265
>                       handle_fasteoi_irq+0x328/0x8d8 kernel/irq/chip.c:76=
4
>                       generic_handle_irq_desc include/linux/irqdesc.h:172=
 [inline]
>                       handle_irq_desc kernel/irq/irqdesc.c:669 [inline]
>                       generic_handle_domain_irq+0xe0/0x140 kernel/irq/irq=
desc.c:725
>                       __gic_handle_irq drivers/irqchip/irq-gic-v3.c:825 [=
inline]
>                       __gic_handle_irq_from_irqson drivers/irqchip/irq-gi=
c-v3.c:876 [inline]
>                       gic_handle_irq+0x6c/0x18c drivers/irqchip/irq-gic-v=
3.c:920
>                       call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry=
.S:891
>                       do_interrupt_handler+0xd4/0x138 arch/arm64/kernel/e=
ntry-common.c:135
>                       __el1_irq arch/arm64/kernel/entry-common.c:497 [inl=
ine]
>                       el1_interrupt+0x3c/0x60 arch/arm64/kernel/entry-com=
mon.c:510
>                       el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/ent=
ry-common.c:515
>                       el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                       __daif_local_irq_restore arch/arm64/include/asm/irq=
flags.h:175 [inline]
>                       arch_local_irq_restore arch/arm64/include/asm/irqfl=
ags.h:195 [inline]
>                       kasan_quarantine_put+0xbc/0x1c8 mm/kasan/quarantine=
.c:234
>                       __kasan_slab_free+0x8c/0xa4 mm/kasan/common.c:295
>                       kasan_slab_free include/linux/kasan.h:235 [inline]
>                       slab_free_hook mm/slub.c:2540 [inline]
>                       slab_free_after_rcu_debug+0x120/0x2f8 mm/slub.c:672=
9
>                       rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>                       rcu_core+0x848/0x1774 kernel/rcu/tree.c:2857
>                       rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2874
>                       handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>                       run_ksoftirqd+0x70/0xc0 kernel/softirq.c:1063
>                       smpboot_thread_fn+0x4d8/0x9cc kernel/smpboot.c:160
>                       kthread+0x5fc/0x75c kernel/kthread.c:463
>                       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:8=
44
>     INITIAL USE at:
>                      lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:58=
68
>                      __raw_spin_lock_irq include/linux/spinlock_api_smp.h=
:119 [inline]
>                      _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock=
.c:170
>                      spin_lock_irq include/linux/spinlock.h:376 [inline]
>                      shmem_add_to_page_cache+0x564/0xa24 mm/shmem.c:904
>                      shmem_alloc_and_add_folio+0x758/0x10c4 mm/shmem.c:19=
58
>                      shmem_get_folio_gfp+0x4d4/0x159c mm/shmem.c:2556
>                      shmem_read_folio_gfp+0x8c/0xf0 mm/shmem.c:5970
>                      drm_gem_get_pages+0x1cc/0x7c0 drivers/gpu/drm/drm_ge=
m.c:654
>                      drm_gem_shmem_get_pages_locked+0x1d4/0x364 drivers/g=
pu/drm/drm_gem_shmem_helper.c:240
>                      drm_gem_shmem_pin_locked+0x1f8/0x410 drivers/gpu/drm=
/drm_gem_shmem_helper.c:301
>                      drm_gem_shmem_vmap_locked+0x3cc/0x658 drivers/gpu/dr=
m/drm_gem_shmem_helper.c:405
>                      drm_gem_shmem_object_vmap+0x28/0x38 include/drm/drm_=
gem_shmem_helper.h:245
>                      drm_gem_vmap_locked drivers/gpu/drm/drm_gem.c:1273 [=
inline]
>                      drm_gem_vmap+0x104/0x1d8 drivers/gpu/drm/drm_gem.c:1=
315
>                      drm_client_buffer_vmap+0x68/0xb0 drivers/gpu/drm/drm=
_client.c:355
>                      drm_fbdev_shmem_driver_fbdev_probe+0x1f4/0x700 drive=
rs/gpu/drm/drm_fbdev_shmem.c:159
>                      drm_fb_helper_single_fb_probe drivers/gpu/drm/drm_fb=
_helper.c:1562 [inline]
>                      __drm_fb_helper_initial_config_and_unlock+0x108c/0x1=
728 drivers/gpu/drm/drm_fb_helper.c:1741
>                      drm_fb_helper_initial_config+0x3c/0x58 drivers/gpu/d=
rm/drm_fb_helper.c:1828
>                      drm_fbdev_client_hotplug+0x154/0x22c drivers/gpu/drm=
/clients/drm_fbdev_client.c:66
>                      drm_client_register+0x13c/0x1d4 drivers/gpu/drm/drm_=
client.c:143
>                      drm_fbdev_client_setup+0x194/0x3d0 drivers/gpu/drm/c=
lients/drm_fbdev_client.c:168
>                      drm_client_setup+0x114/0x228 drivers/gpu/drm/clients=
/drm_client_setup.c:46
>                      vkms_create+0x370/0x420 drivers/gpu/drm/vkms/vkms_dr=
v.c:211
>                      vkms_init+0x64/0x9c drivers/gpu/drm/vkms/vkms_drv.c:=
239
>                      do_one_initcall+0x248/0x9b4 init/main.c:1378
>                      do_initcall_level+0x128/0x1c4 init/main.c:1440
>                      do_initcalls+0x70/0xd0 init/main.c:1456
>                      do_basic_setup+0x78/0x8c init/main.c:1475
>                      kernel_init_freeable+0x268/0x39c init/main.c:1688
>                      kernel_init+0x24/0x1dc init/main.c:1578
>                      ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:84=
4
>   }
>   ... key      at: [<ffff80009764a620>] xa_init_flags.__key+0x0/0x20
>   ... acquired at:
>    seqcount_lockdep_reader_access include/linux/seqlock.h:72 [inline]
>    fprop_fraction_percpu+0xf0/0x270 lib/flex_proportions.c:155
>    __fprop_add_percpu_max+0x130/0x1f4 lib/flex_proportions.c:186
>    wb_domain_writeout_add mm/page-writeback.c:562 [inline]
>    __wb_writeout_add+0xbc/0x27c mm/page-writeback.c:586
>    __folio_end_writeback+0x380/0x6f8 mm/page-writeback.c:2997
>    folio_end_writeback_no_dropbehind+0xd0/0x204 mm/filemap.c:1661
>    folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
>    iomap_finish_folio_write+0x1c0/0x2a4 fs/iomap/buffered-io.c:1713
>    fuse_writepage_finish fs/fuse/file.c:1903 [inline]
>    fuse_writepage_end+0x238/0x454 fs/fuse/file.c:2003
>    fuse_request_end+0x898/0xc10 fs/fuse/dev.c:507
>    fuse_dev_end_requests fs/fuse/dev.c:2415 [inline]
>    fuse_abort_conn+0xe88/0x10a0 fs/fuse/dev.c:2513
>    fuse_dev_release+0x430/0x4c8 fs/fuse/dev.c:2556
>    __fput+0x340/0x75c fs/file_table.c:468
>    fput_close_sync+0x100/0x264 fs/file_table.c:573
>    __do_sys_close fs/open.c:1573 [inline]
>    __se_sys_close fs/open.c:1558 [inline]
>    __arm64_sys_close+0x7c/0x118 fs/open.c:1558
>    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>    invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>    el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
>    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>    el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
>    el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
>    el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>
> -> (&p->sequence){+.-.}-{0:0} {
>    HARDIRQ-ON-W at:
>                     lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:586=
8
>                     do_write_seqcount_begin_nested include/linux/seqlock.=
h:477 [inline]
>                     do_write_seqcount_begin include/linux/seqlock.h:503 [=
inline]
>                     fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:7=
4
>                     writeout_period+0x94/0x11c mm/page-writeback.c:615
>                     call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
>                     expire_timers kernel/time/timer.c:1799 [inline]
>                     __run_timers kernel/time/timer.c:2373 [inline]
>                     __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
>                     run_timer_base kernel/time/timer.c:2394 [inline]
>                     run_timer_softirq+0x11c/0x194 kernel/time/timer.c:240=
5
>                     handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>                     __do_softirq+0x14/0x20 kernel/softirq.c:656
>                     ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
>                     call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S=
:891
>                     do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.=
c:73
>                     invoke_softirq kernel/softirq.c:503 [inline]
>                     __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
>                     irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
>                     __el1_irq arch/arm64/kernel/entry-common.c:498 [inlin=
e]
>                     el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-commo=
n.c:510
>                     el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry=
-common.c:515
>                     el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                     __daif_local_irq_enable arch/arm64/include/asm/irqfla=
gs.h:26 [inline]
>                     arch_local_irq_enable arch/arm64/include/asm/irqflags=
.h:48 [inline]
>                     preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7=
189
>                     raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry=
/common.c:173
>                     irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
>                     exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry=
-common.c:58
>                     __el1_irq arch/arm64/kernel/entry-common.c:500 [inlin=
e]
>                     el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-commo=
n.c:510
>                     el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry=
-common.c:515
>                     el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                     __daif_local_irq_restore arch/arm64/include/asm/irqfl=
ags.h:175 [inline]
>                     arch_local_irq_restore arch/arm64/include/asm/irqflag=
s.h:195 [inline]
>                     class_irqsave_destructor include/linux/irqflags.h:266=
 [inline]
>                     __free_object+0x514/0x720 lib/debugobjects.c:524
>                     free_object lib/debugobjects.c:532 [inline]
>                     debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
>                     destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [i=
nline]
>                     hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2=
178
>                     common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:13=
52
>                     __do_sys_clock_nanosleep kernel/time/posix-timers.c:1=
398 [inline]
>                     __se_sys_clock_nanosleep kernel/time/posix-timers.c:1=
375 [inline]
>                     __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/p=
osix-timers.c:1375
>                     __invoke_syscall arch/arm64/kernel/syscall.c:35 [inli=
ne]
>                     invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c=
:49
>                     el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c=
:132
>                     do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>                     el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:7=
24
>                     el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/ent=
ry-common.c:743
>                     el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:59=
6
>    IN-SOFTIRQ-W at:
>                     lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:586=
8
>                     do_write_seqcount_begin_nested include/linux/seqlock.=
h:477 [inline]
>                     do_write_seqcount_begin include/linux/seqlock.h:503 [=
inline]
>                     fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:7=
4
>                     writeout_period+0x94/0x11c mm/page-writeback.c:615
>                     call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
>                     expire_timers kernel/time/timer.c:1799 [inline]
>                     __run_timers kernel/time/timer.c:2373 [inline]
>                     __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
>                     run_timer_base kernel/time/timer.c:2394 [inline]
>                     run_timer_softirq+0x11c/0x194 kernel/time/timer.c:240=
5
>                     handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>                     __do_softirq+0x14/0x20 kernel/softirq.c:656
>                     ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
>                     call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S=
:891
>                     do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.=
c:73
>                     invoke_softirq kernel/softirq.c:503 [inline]
>                     __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
>                     irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
>                     __el1_irq arch/arm64/kernel/entry-common.c:498 [inlin=
e]
>                     el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-commo=
n.c:510
>                     el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry=
-common.c:515
>                     el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                     __daif_local_irq_enable arch/arm64/include/asm/irqfla=
gs.h:26 [inline]
>                     arch_local_irq_enable arch/arm64/include/asm/irqflags=
.h:48 [inline]
>                     preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7=
189
>                     raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry=
/common.c:173
>                     irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
>                     exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry=
-common.c:58
>                     __el1_irq arch/arm64/kernel/entry-common.c:500 [inlin=
e]
>                     el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-commo=
n.c:510
>                     el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry=
-common.c:515
>                     el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>                     __daif_local_irq_restore arch/arm64/include/asm/irqfl=
ags.h:175 [inline]
>                     arch_local_irq_restore arch/arm64/include/asm/irqflag=
s.h:195 [inline]
>                     class_irqsave_destructor include/linux/irqflags.h:266=
 [inline]
>                     __free_object+0x514/0x720 lib/debugobjects.c:524
>                     free_object lib/debugobjects.c:532 [inline]
>                     debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
>                     destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [i=
nline]
>                     hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2=
178
>                     common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:13=
52
>                     __do_sys_clock_nanosleep kernel/time/posix-timers.c:1=
398 [inline]
>                     __se_sys_clock_nanosleep kernel/time/posix-timers.c:1=
375 [inline]
>                     __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/p=
osix-timers.c:1375
>                     __invoke_syscall arch/arm64/kernel/syscall.c:35 [inli=
ne]
>                     invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c=
:49
>                     el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c=
:132
>                     do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>                     el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:7=
24
>                     el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/ent=
ry-common.c:743
>                     el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:59=
6
>    INITIAL READ USE at:
>                         lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c=
:5868
>                         seqcount_lockdep_reader_access include/linux/seql=
ock.h:72 [inline]
>                         fprop_fraction_percpu+0xac/0x270 lib/flex_proport=
ions.c:155
>                         __wb_calc_thresh+0xfc/0x3b0 mm/page-writeback.c:9=
13
>                         wb_bg_dirty_limits mm/page-writeback.c:2130 [inli=
ne]
>                         domain_over_bg_thresh+0xb8/0x1f0 mm/page-writebac=
k.c:2144
>                         wb_over_bg_thresh+0xf8/0x17c mm/page-writeback.c:=
2165
>                         wb_check_background_flush fs/fs-writeback.c:2278 =
[inline]
>                         wb_do_writeback fs/fs-writeback.c:2376 [inline]
>                         wb_workfn+0xa30/0xdc0 fs/fs-writeback.c:2403
>                         process_one_work+0x7c0/0x1558 kernel/workqueue.c:=
3257
>                         process_scheduled_works kernel/workqueue.c:3340 [=
inline]
>                         worker_thread+0x958/0xed8 kernel/workqueue.c:3421
>                         kthread+0x5fc/0x75c kernel/kthread.c:463
>                         ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S=
:844
>  }
>  ... key      at: [<ffff800097b9a340>] fprop_global_init.__key.1+0x0/0x20
>  ... acquired at:
>    mark_lock+0x170/0x1d0 kernel/locking/lockdep.c:4753
>    mark_usage kernel/locking/lockdep.c:4662 [inline]
>    __lock_acquire+0x9a0/0x30a4 kernel/locking/lockdep.c:5191
>    lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
>    do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
>    do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
>    fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
>    writeout_period+0x94/0x11c mm/page-writeback.c:615
>    call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
>    expire_timers kernel/time/timer.c:1799 [inline]
>    __run_timers kernel/time/timer.c:2373 [inline]
>    __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
>    run_timer_base kernel/time/timer.c:2394 [inline]
>    run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
>    handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>    __do_softirq+0x14/0x20 kernel/softirq.c:656
>    ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
>    call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
>    do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
>    invoke_softirq kernel/softirq.c:503 [inline]
>    __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
>    irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
>    __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
>    el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
>    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
>    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>    __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline]
>    arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline]
>    preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189
>    raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
>    irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
>    exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
>    __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
>    el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
>    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
>    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>    __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline=
]
>    arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
>    class_irqsave_destructor include/linux/irqflags.h:266 [inline]
>    __free_object+0x514/0x720 lib/debugobjects.c:524
>    free_object lib/debugobjects.c:532 [inline]
>    debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
>    destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
>    hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
>    common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
>    __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
>    __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
>    __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:137=
5
>    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>    invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>    el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
>    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>    el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
>    el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
>    el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6572 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/03/2025
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  print_irq_inversion_bug+0x1f8/0x1fc kernel/locking/lockdep.c:4125
>  mark_lock_irq+0x3b4/0x47c kernel/locking/lockdep.c:-1
>  mark_lock+0x170/0x1d0 kernel/locking/lockdep.c:4753
>  mark_usage kernel/locking/lockdep.c:4662 [inline]
>  __lock_acquire+0x9a0/0x30a4 kernel/locking/lockdep.c:5191
>  lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
>  do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
>  do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
>  fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
>  writeout_period+0x94/0x11c mm/page-writeback.c:615
>  call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
>  expire_timers kernel/time/timer.c:1799 [inline]
>  __run_timers kernel/time/timer.c:2373 [inline]
>  __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
>  run_timer_base kernel/time/timer.c:2394 [inline]
>  run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
>  handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
>  __do_softirq+0x14/0x20 kernel/softirq.c:656
>  ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
>  call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
>  do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
>  invoke_softirq kernel/softirq.c:503 [inline]
>  __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
>  irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
>  __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
>  el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
>  el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
>  el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>  __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P=
)
>  arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
>  preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189 (P)
>  raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
>  irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
>  exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
>  __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
>  el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
>  el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
>  el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
>  __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline] =
(P)
>  arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline] (P=
)
>  class_irqsave_destructor include/linux/irqflags.h:266 [inline] (P)
>  __free_object+0x514/0x720 lib/debugobjects.c:524 (P)
>  free_object lib/debugobjects.c:532 [inline]
>  debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
>  destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
>  hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
>  common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
>  __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
>  __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
>  __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:1375
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title

#syz fix: flex_proportions: make fprop_new_period() hardirq safe

This was fixed by Jan a few weeks ago (commit dd9e2f5b38f1f in the
linux-next tree) [1]. I think Jan's fix just hasn't been
pulled into the arm64 tree yet [2].

Thanks,
Joanne

[1] https://lore.kernel.org/all/20260121112729.24463-2-jack@suse.cz/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?qt=
=3Dauthor&q=3DJan+Kara

>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>

