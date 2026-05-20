Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BEA5CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DC76B00A8; Wed, 20 May 2026 19:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED676B00A9; Wed, 20 May 2026 19:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AF16B00AA; Wed, 20 May 2026 19:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33E2A6B00A8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:38:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6E571C0F76
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:38:13 +0000 (UTC)
X-FDA: 84789414066.18.4E077E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B408B4000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:38:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWykK1jJ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779320291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XojcX+cBNMxauV3CDSL9gXTCmD6yueQSzdQP2DbJ+E=;
	b=F+VSaJ1ti3jUBtKrZqO/SmT9+9RPdeW/tVEiqIrBRm90k1js8CwwdiI3zX8JPtKBLr6+zg
	mXqdR1pJqykk8k0ur6l0JdOxw0FL6QVzJXG+v6li4T4yAaabN619KFZmDghvEfUVm8i7Dq
	+/9sNLqvDjC+/W8biuEsjzmfUHc8kk4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWykK1jJ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779320291; a=rsa-sha256;
	cv=none;
	b=gTKI6d9wSTuDMOuR8CWa42UQwwyvBlG8Zm5uScjsbHJgNN/30uiv/fNEhp/2yl+LIn+10C
	E3m+tpYVMNfPCBBsROvF4l0kaQ0w/yvwc+OVkxLia6F9w0eK1SOOM0iFR7rA9bzjHA57OS
	3HGtgDf8bJwNQsZaeKjZRUSuWlEEgwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FFD6601E8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD38D1F00A3D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779320290;
	bh=+XojcX+cBNMxauV3CDSL9gXTCmD6yueQSzdQP2DbJ+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mWykK1jJ4M1Y0t1X4E200qRw3WucF2APHRoJg6V2GzmeM8J67Rp7qms4fjy8aUiHA
	 mi1CuV2NNRyTBUdpu0DS2U/poDmgZ5bUjCz346Jr17eSUS8rtWYmnrs/XoIM22VPWQ
	 LBHwLD3FNTiRXdNQOult0hvNiZsGwPEZhaedB+3xG8zfW32UeI7mBuYTfColqen05V
	 5sbz39iZci3r6cYK5iGqKWGDFjvFsuK10PTf28l+a/KETrjrsBrCy45dNKOIyb0Slz
	 20jr5Z56iThLCKE9GsJ45F+Q48gvBMnA1kMM5K+tZdcIVXJNiZmHGh/kc3z+Cso4vh
	 v6IxapDe1cKTw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51306c9f2a8so64643141cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 16:38:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9HvQObwBQ6yMNBS/qptDAfNeZx4sVwv5AfcBLA1fVV8hmYOAd+iYJP52EIc19qMrwDwzW6yrcmww==@kvack.org
X-Gm-Message-State: AOJu0YyM1oaPzh5T6fteSYQVeZE+2vK9Us41nZKZfmVBBIQsFKRy7xw4
	ir4eBqQMPMCKHif4iDPmm73QOt4UamMpZtriKolonsswMcrDJz0Mhl2XQr4J0l9bc2vCkGbl/AF
	4wSVmS5xFG7QVAOSx0ezrFEb03xW5WQo=
X-Received: by 2002:a05:622a:17c7:b0:50d:b0f9:1a66 with SMTP id
 d75a77b69052e-516c55ce180mr9639641cf.42.1779320290158; Wed, 20 May 2026
 16:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org> <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org> <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
In-Reply-To: <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 21 May 2026 07:37:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
X-Gm-Features: AVHnY4LEan2jPUL-UnPeql1qwutuRGUCiZMo1ZXEi3On484A8O-Avt_P3lSUuSE
Message-ID: <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B408B4000D
X-Stat-Signature: 9cpycdnqq4i8mimyb8xw1twzis6soy48
X-HE-Tag: 1779320291-966046
X-HE-Meta: U2FsdGVkX1/o/GP6oRlK9ZqgriMzfinY0IggilS0rUbin9OhIIkI5sljfIdWwwRXggMQbqbXCDRhoY8rhWQ7zfVNWvHuNiayore30fQLRFrp8TIeIuowPeh+Vx1640TWoOWRQqVnajaIXBStydDYAk0zV6I1umJhzMZx8j4IxuuSJF7e2YvAgBqBJuT8nX9LZimX6suM1VgQW2UKfSnZKUBChEZFDCCrhIc5YUJEO/9j0behJ7biG/99dZHRnDlM8YZ5NJwmnRfYBiutSF6x1kThCJj956X49KRePhH4KMz3EUiGZJ/9V7TD2dIJVtQSmg4H/9Fqgh26amDg/fBnLVwVMvA82UWsh3/oQvkCdiIBjCW9B41UgRZY3uNlMI/g6uOAwNtqazBPtqR2fjKUEdksG9N5gOqJ9ihaaICIzNGeNvcio21YWdq9ZGTSBGEiN7aYVJwddLZwJelmYnBGktTCF/kuaYigHjQEn1KPI73oEeK7XZZmxD/3FPUEeNt5MLGjJ7Jt4vXmOHhAw13oSirnIysVLOhFB6nftF5MhO1okN0P9bByWYqZ8UqpQusX29SDXoXEEyXonu9sAnqpI9ffDwgiylUIiUPuBYcZY6jmjU/f6Cf19Mw/rRNC0kIX1903ofRzfoiDKANWyFdu9UfiBvludf6GWmdAiZGMUYXwWg6owG+mAPf+2Qlx/riwlBPCsXrFKbwpYzWHjQiCBqYWV8jW6l9iOcYEFHbCMDxUxor5zbWs99qAq6mRgYSGmztXiMXc0jj6WFE1fkpQAM0MxgGJUeJvFiteml9SBq+mcgo9sdVrPjzMN6D0bPcYQVWmSrvcw20RlHSGxG19FXNY4ypoNARSb5NVu8n3BSmfBQ0CJEidnE4387QeGvyCy2hWLZq9K/erO+I85G5KwJIb8FBXXWZ0ZqrIm+viesOemx3DDP5m4tvkf0qPGzA0+7docGIaF1CiB2CQ4Hn
 dI6JMZbO
 dUJDJCBQw0jcOVUfI1Ir9pwC7bIfzgee7lJxpoji3J738UKRs4rK9q5c/rl8mvRxdZgi1Gj0dm4RJoduVmNKxMSKvmzMNaP7hIkoBYefAHO2ESw6BNqjS9cqDdUbrpHrtYNVYjzatNzg9EFc+8MOsYu5vKXbuEFWyTTKRd9pr4vQOvi8c72l7E+z6N4YG1xz5Me3keEC8f3e5f/GP6sZPcvFbP1ehBVDNPPd5+jMebzjBJh+/U7WcJ1383RzcHX22dQgy1H1LRqGQ+27E08HH9pkZYt9jp08MyT0tVIRiCp2/ezcgPs6dBDxd//6mKwOHl1VihSv6OAQeAtmaz5hOEIoyNPxPP2hd9dRwA8AVk6SCap7iRgi6AUuwq6NiGLBgI0U9ikZ0Pgv1xKdCa/6qISaQEdx2A8NDI49cbcpHTnYMDXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 5:35=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/20/26 23:15, Matthew Wilcox wrote:
> > On Thu, May 21, 2026 at 05:14:20AM +0800, Barry Song wrote:
> >> My understanding is that we should not blame applications here. This i=
s 2026:
> >> there are basically only two kinds of applications =E2=80=94 single-th=
readed and
> >> multi-threaded =E2=80=94 and single-threaded applications are nearly e=
xtinct.
> >
> > all of the applications i run are either single threaded or don't fork.
> > what multithreaded applications call fork?
>
> Traditionally the problem was random libraries using fork+execve to launc=
h other
> programs ... instead of using alternatives like posix_spwan (some use cas=
es
> require more work done before execve and cannot yet switch to that). I'd =
hope
> that that is less of a problem on Android.
>
> I assume Android zygote might be multi threaded? Maybe sshd as well? Syst=
emd?
> But I'd be surprised if there are really performance implications.

I am trying to answer the question above:

1. zygote, multi-threaded on my phone using Android13.
/ # ls /proc/`pidof zygote64`/task/
1359  22728  22729  22730  22731  22732

/proc/1359/task # cat 22728/comm
Jit thread pool
/proc/1359/task # cat 22730/comm
ReferenceQueueD
/proc/1359/task # cat 22731/comm
FinalizerDaemon
/proc/1359/task # cat 22732/comm
FinalizerWatchd
/proc/1359/task # cat 1359/comm
main

But on another phone of mine running Android 16, zygote64 is
single-threaded.
Not sure if it is due to the Android team making some changes
related to threads from Android 13 to Android 16.

2. sshd, multi-processes instead of multi-threads:
$ ps aux | grep sshd
root        1192  0.0  0.0  15444  9032 ?        Ss   09:42   0:00
sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        2465  0.0  0.0  17164 10760 ?        Ss   09:42   0:00
sshd: barry [priv]
barry       2632  0.0  0.0  17164  7852 ?        S    09:42   0:00
sshd: barry@pts/0
root        3305  2.5  0.0  17164 10772 ?        Ss   09:44   0:00
sshd: barry [priv]
barry       3406  0.0  0.0  17164  7940 ?        S    09:44   0:00
sshd: barry@pts/1

3. systemd, also multi-processes

$ ps ax | grep systemd
    350 ?        S<s    0:00 /lib/systemd/systemd-journald
    387 ?        Ss     0:00 /lib/systemd/systemd-udevd
    666 ?        Ss     0:00 /lib/systemd/systemd-oomd
    667 ?        Ss     0:00 /lib/systemd/systemd-resolved
    728 ?        Ss     0:00 @dbus-daemon --system --address=3Dsystemd:
--nofork --nopidfile --systemd-activation --syslog-only
    751 ?        Ss     0:00 /lib/systemd/systemd-logind
    753 ?        Ssl    0:00 /usr/sbin/thermald --systemd
--dbus-enable --adaptive
   1350 ?        Ss     0:00 /lib/systemd/systemd --user
   1428 ?        Ss     0:00 /usr/bin/dbus-daemon --session
--address=3Dsystemd: --nofork --nopidfile --systemd-activation
--syslog-only
   1900 ?        Ssl    0:00 /usr/libexec/gnome-session-binary
--systemd-service --session=3Dubuntu
   2141 ?        Ssl    0:00 /lib/systemd/systemd-timesyncd

>
> Not sure about webbroswers .... I think most of them switched to fork ser=
vers,
> where I would assume fork servers would be single-threaded.

On my phone, Chrome is multi-process, but its parent process
chrome_zygote (10774) is single-threaded:

 ps -A | grep chrome
u0_i15        9883 10774 321066464 119452 do_epoll_wait     0 S
com.android.chrome:sandboxed_process0:org.chromium.content.app.SandboxedPro=
cessService0:15
u0_a142      10164  1359 35110548 277640 do_epoll_wait      0 S
com.android.chrome
u0_a278      10724  1359 9779864 104988 do_epoll_wait       0 S
com.google.android.apps.chromecast.app
u0_a142      10774  1359 32803908 64076 do_sys_poll         0 S
com.android.chrome_zygote
u0_a142      11173  1359 34208592 142192 do_epoll_wait      0 S
com.android.chrome:privileged_process0

/proc/10774/task # ls
10774

>
> So, yeah, getting a clear understanding how this ends up being a problem =
on
> Android would be great.

I guess the real issue is that in the Android market, there
are so many applications that are out of our control=EF=BC=9F

Here are some trace examples from Nanzhe:

iQIYI plugin
vma reader thread:
PbMisc-0, pid=3D27183, tgid=3D26444

vma writer thread:
i.video:plugin1, pid=3D27298, tgid=3D26444
writer blocked: 440394938 ns (440 ms)

reader stack:
vma_start_read
lock_vma_under_rcu
do_page_fault
do_translation_fault
do_mem_abort
el0_da
el0t_64_sync_handler
el0t_64_sync

writer stack:
__vma_start_write
dup_mmap
copy_mm
copy_process
kernel_clone
__arm64_sys_clone
invoke_syscall
el0_svc_common
do_el0_svc
el0_svc


Baidu Tieba
vma reader thread:
elastic_pms_pro, pid=3D7731, tgid=3D7575

vma writer thread:
com.baidu.tieba, pid=3D8005, tgid=3D7575
writer blocked: 514975545 ns(515 ms)

reader stack:
vma_start_read
lock_vma_under_rcu
do_page_fault
do_translation_fault
do_mem_abort
el0_da
el0t_64_sync_handler
el0t_64_sync

writer stack:
__vma_start_write
dup_mmap
copy_mm
copy_process
kernel_clone
__arm64_sys_clone
invoke_syscall
el0_svc_common
do_el0_svc
el0_svc

Thanks
Barry

