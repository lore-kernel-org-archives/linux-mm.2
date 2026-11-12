Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34A9606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PYh2l7zK
Received: by kanga.kvack.org (Postfix)
	id 0E78C6B05B1; Thu, 12 Nov 2026 05:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098E06B05B2; Thu, 12 Nov 2026 05:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9666B05B3; Thu, 12 Nov 2026 05:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF8936B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:35:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE0F6C0527
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:35:19 +0000 (UTC)
X-FDA: 85426109958.09.EAB2987
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3C4F180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:35:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PYh2l7zK;
	spf=pass (imf16.hostedemail.com: domain of elenchist.dev@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=elenchist.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoymvwdfMBFoMyXW+9QTB+Y4rJogi+4Hn0MI83a+cw0=;
	b=iN58/hzJcPmv+ToZm1v/GU9rhFAd2tD+CGy8nfT1ypsLR2Ieq7jWHVVx5qKJcPGljy7oEL
	DrrZ2QahOgYgWw2Re+84QPQ6Hrbx8YOQHt2SjxZZquIHxiTy/y2v79LqmDtNA6C4dZDMG3
	H31EiabOfFnwOn9jjCUHBb2Bqt6ULzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479718;
	b=Z41TUuf7hdJYO2yI+Y++rEEdgv7uqzdUBt5eMdPwVsOD28oeUgr9Zcxkx+saLhbzzGGvx0
	4MnLmq6g0o15jmBaodWo4j9a4cVs1hYZ0+K/dmcKTwAHFPsX7BYzXMYlrJIRK497syJgih
	pAP9ltSnIApFoymVvc6t5eA7dDTQoIc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PYh2l7zK;
	spf=pass (imf16.hostedemail.com: domain of elenchist.dev@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=elenchist.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b179528d56so1114639a91.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794479717; x=1795084517; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WoymvwdfMBFoMyXW+9QTB+Y4rJogi+4Hn0MI83a+cw0=;
        b=PYh2l7zKI7wz/m+SbAl0HthhQdZz1ZZUrz+mmqik4bVlR9I3C3XENgurWgdEhGpksV
         roh5sAFVd94viXaG4igT+xqn6CnB+Zyq5YkVLnQBSi1AxXhYBNFhN878j6ySY5FyumEu
         C1di0GLdEacvn5HSkXzhDxtRt7vDTMNLkW9Cg5U+kE73WlxhgW6NhVS3rjObyK/SY1Q9
         QM8Wxv9bRKIf61O0mspPNpPR5cCaqolf5OP2wASuZdq3l41PTxoVtYvRi93uiXqLHntL
         i8GS3r9rh2jOCG3MN9Y//18VM0NVVsU6KkcShFPRoFZaKHSwNj1DaB0jzC4gNx5saaMl
         w37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794479717; x=1795084517;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WoymvwdfMBFoMyXW+9QTB+Y4rJogi+4Hn0MI83a+cw0=;
        b=GTq98mf40cTQd03BYtwGD+ZQLxty8MBqWHvPjEMPu3lu7wfWDdTR8Dn1Xqj/YS2ebN
         +NRCOPhOTFpshBRrzhKwG0dW+YiBvXZ+OCPPR5Gz+YBNTjjEhU353I/dKPVc9+wMUe/x
         3wo6rb4Kp3ppKioW4ORIha2emg+/gqxNxnH1DNvftvty12Av3kzsothw9uw1QnJu7ORZ
         gCBNs/jRj/q4PlDTm/Cl4OKkPJTMQwgRESTvYLFO2VS/0KQE7IGqVeim/JqNwN/wZ5nG
         qtW9RsUR1nbMImqAIuCUigCy4STkC0zvjlQAzBK3VJPy3zUcAmWzmx/uToJ+586poQcS
         oZQA==
X-Forwarded-Encrypted: i=1; AL+hErGcOQ5aGzHuSDhgovbExBejvq+64GimVljrEcgYHHZ/QSpOdXyyZOGTLDAMH5rgZISZxRWXUXGsIQ==@kvack.org
X-Gm-Message-State: APuU4Z9WMr+2Y4St+jWhQ23DxRK1dIobqOAL/Vm7yYClQ/98tmSeCtJv
	fVxWR+MVU2vbfkuiSe2g826HcAZ+0y6IwQO+AJNLf6lw4vD+hxgciOkE
X-Gm-Gg: AYBFou3vOsV7QSXqpeLkLixugETLn+UFYfxY6T65ZzEYFMZHAEEU7CdREc2DKoD2cW7
	j/gK6+ank/4TiAvEk11LVGh+9EwK/OJD3RCtHLhXOdBP+cjaHLTxFG0NvIlMJ0YoAK4kreroewD
	A89Ru0Rj+GTsOR2hugtWRa9+eEmvV5NOQrG3X30v92+qNcQGc6R6BJ9iiyybLrb295Zhg7TU/SW
	87UZZhe/FrIU/7gth2ddUHmhfOiI28J+/5yRINMU+XFcXt+ZwVvaRjVcQFaQ413I2NQCJON1yyg
	64FipH8R0JP1FDSogljvvthEvSwDEf6J8xbwMQc+JpHtfeTEJx1l4EHj22McnOog9FC/kfsdgef
	9/fGzaoJ3FerKYj01MO/o/8teSKsUOPZjM6j8+TDLuE9Tn8FjRB6rKqmrLPvWcyVdIa7sYLP0Kv
	9po4tvCkpit12UZPE8a2edMcmSQ72ojV36KWdhqz+qiNNeIELkdEEXXnEL7kSNhKV46abPV9q9o
	xhkPLh5bxz4Im6MAxXh5HdWnXpmT3vF6w7CSVBU6bGGirKMVOGvZFXjk3826JZoM3WqwXtEukxB
	XB3Dx1OaCz2re/CjvNyaaHj+P9ftgLiN7lhg0xGTOp7wmxnVpkUizshg/Md6GtN0FaCw+oFs91M
	jO4x8+A==
X-Received: by 2002:a17:90b:4c4c:b0:3b0:e2a9:3466 with SMTP id 98e67ed59e1d1-3b182eebe65mr4740116a91.16.1794479716567;
        Thu, 12 Nov 2026 02:35:16 -0800 (PST)
Received: from smtpclient.apple (fs98a57cc9.tkyc008.ap.nuro.jp. [152.165.124.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce49d6sm4207584a91.4.2026.11.12.02.35.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2026 02:35:16 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
From: elenchist <elenchist.dev@gmail.com>
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>
Date: Thu, 12 Nov 2026 19:34:53 +0900
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Zhan Xusheng <zhanxusheng1024@gmail.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kernel-team@meta.com,
 regressions@lists.linux.dev,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fozmtp1wotp9m1jie653cmkmg6fp1o7j
X-Rspamd-Queue-Id: E3C4F180003
X-Rspam-User: 
X-HE-Tag: 1794479717-992617
X-HE-Meta: U2FsdGVkX1/Kt9siLBD4afsf7Y3sgYo+hrv+RxVks5uwDQ2xbD0Z+UZjpSakPW30xPAAw7xijeaCFW7w0awBOMS026G1fL6TU77U8XdMhDf1I6ggEdAAv8zfD7Z6oQQcgQDx8dhizgFekwBSuSooKQbf7TXjFWrHfy9x8eBlXe/YyDkuRK+Fb0X42DGeoDqcpK2NpY5AuQUqq9LPnoJPx2PJPIFyWYgeTIdYid/3HqF5zk4dfN3kb0QCTjZUElW5CZZNqsl6DVlGSeha7bcXFNsoO4MZgAEHXm3VFRG/XjDOoqHsqnpIwtvRSz+5j9x5DmcID/P3Ze43qVeyanA9aAWAexdsueckn+XjXA+BUvarUMOrS6py9cSIT/aPbOOzf45HgAYRT2P2IBdsXLvOiwOeqJdGHV4vjXuT9tYmWzW4TnwzxdydaFZhnmleipbC64Oxr6Mvyy8r5lzcw6gX8yWtaUp3n7gAG6qfP9gIcz1TtZQvMsmv+TO9hOV/OxGQRspzXCjI9DkqACVbv5D+1svCKe/PCzEQF/Kp32QfyoGVeVbpBbXxOrTG/raJYj8AisXNod4wte5IyDpnd0+POWKiw/6X56xNDbYUo6T72mfA5Ztr6EEyGguD1p/u2zAV9IOEO1k6DgQ4J20KvvG9IqGwI4e9gnzlaDkxq/j9v9E/oizEXmHhf7qkdywEOpEmAAYvc0BglfQ+W3w4MZfc6OrPdIHozwUz9DZbX1Y1vPZVygljAc3/WuAP+Lkjn6XTzvq5nHa5/TcR4Ox7QZUsWWVA7S07B+iHm1CQ0ApxX2c68gJL1+MeJbi/TSfQXUddpqrSp4tGV123zFxnjUUfOKaGigq7+ppJZmPj7ujoo9ljYUpD+rLE2n/pB+jSOcnMBhZiFhr3+GXtjC353WnJclnHWtpF/UlzlynbWtAZ6xsQfP34TqhQbp2BpUzDUZ1/4nLyKey5STEibjI7VG6
 amfo08Yf
 OK7TDG529pMU5KDK5cPSEqmVhMZxT9Nb6aZReoBgUOOcURafljul29/a0/mVmYDWUVE8JjLZauRj3aRCj4sp7Tgxg5R8WFqy8/Fw7k08OQrINAszThDpSNZM7H0tN/zBkafGxJ+6gbKUhoY6usUOtlUGilwgCbMrbCaGCFQKMxvbDXz9GMLW/7gtA0LBULeZJdprBGdn1tLgFjbDSacUpbnMbmvJ22megeb77X4+rpYR03DTVr/lUQPQv6xAoWdg63UsZMMK7/GOa9nimCEsDkru7axfM4IHcU6VVwL6fq1LxADquSpN2GFUnL8IT723CvBSjPtQOEPbfxCyzBdw8VsWkzdYfhhGKfp1tQIJ4Q/MSbymtYesaaMwQvOXctexBsKpqaXbb0UQeVHiQRyXLb3SN/K/hzv7SZF5s3/jgDaVgApqcuXDLRGXfQJN0i/I58xxPOFg5D481eNmjq6eQGgKR2UEHTkiF3xraVGmPbDS7xjA1ZThy1ilTOfNwqF6DCYmu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 12:41:37AM -0800, Chris Down wrote:
> memory.events showed oom_kill 2 in three runs. In one of them the =
first
> process hadn't submitted the read yet when it was killed. The slow =
read
> just makes the window easier to hit.

It doesn't need AIO at all.  A plain memcg OOM hits it most of the
time: the victim only spends 10-20ms in exit_mmap(), and if the
allocating task fails a charge again in that window, a second (and
sometimes a third) task gets killed.

Reproducer: memory.max=3D400M, no swap.  A holds 150M, B 100M, C 50M, =
and
T grows by 10M every 0.3s.  Only A should be killed.

---8<--- overkill.c
/* A holds 150M, B 100M, C 50M; T grows by 10M every 0.3s up to 200M.
 * Run inside a memcg with memory.max=3D400M. Only A should be killed. =
*/
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static char *volatile sink;	/* keep the stores */

static void hold(size_t mb)
{
	sink =3D malloc(mb << 20);
	memset(sink, 1, mb << 20);
}

int main(void)
{
	const char *name[] =3D { "A", "B", "C", "T" };
	size_t mb[] =3D { 150, 100, 50, 0 };
	pid_t pid[4];

	for (int i =3D 0; i < 4; i++) {
		pid[i] =3D fork();
		if (pid[i])
			continue;
		if (mb[i]) {
			hold(mb[i]);
		} else {
			sleep(3);
			for (int j =3D 0; j < 20; j++, usleep(300000))
				hold(10);
		}
		pause();
	}
	sleep(10);
	for (int i =3D 0; i < 4; i++) {
		int st, dead =3D waitpid(pid[i], &st, WNOHANG) =3D=3D =
pid[i];

		printf("%s %s=C2=A5n", name[i],
		       dead && WIFSIGNALED(st) ? "killed" : "alive");
		if (!dead) {
			kill(pid[i], SIGKILL);
			waitpid(pid[i], NULL, 0);
		}
	}
	return 0;
}
---8<--- run.sh
#!/bin/sh
# cgroup v2, no swap, as root: gcc -O2 -o overkill overkill.c; ./run.sh
CG=3D/sys/fs/cgroup/overkill
mkdir $CG && echo 400M > $CG/memory.max || exit 1
sh -c "echo =C2=A5$=C2=A5$ > $CG/cgroup.procs && exec ./overkill"
grep '^oom_kill ' $CG/memory.events
rmdir $CG
---8<---

Over-kill (oom_kill >=3D 2) per 20 runs, ThinkPad X1 Carbon Gen3
(i5-5200U, 8 GB), x86_64.  "4a" is the same layout driven from a
systemd-run scope with Python tasks; "C" is the program above:

  kernel                                      4a      C
  6.8.0-149-generic (Ubuntu)                  0/20    -
  7.0.0-42-generic (Ubuntu)                  19/20   19/20
  v7.4-rc1                                   20/20    -
  v7.4-rc1 + this patch                       0/20    0/20 *
  v7.0 + 60f21a264930 + this patch            2/20    0/20

  * an earlier, longer version of the same program

v2 has the same code as v1, which is what I tested (identical tree
after git am).  On v7.0 the patch also needs CSS_TASK_ITER_WITH_DEAD
from 60f21a264930 ("cgroup, sched_ext: Include exiting tasks in cgroup
iter"); only its cgroup hunks apply there, so that's what I used.  The
2/20 left on that kernel look like a separate issue that mainline has
already fixed.  On v7.0, MGLRU's page table walk in T's reclaim can
hold an mm_users reference on A's mm (get_next_mm() used
mmget_not_zero() until d14514c66cb9 "mm/vmscan: prevent MGLRU reclaim
from pinning address space" in v7.1-rc1).  A's own mmput() is then
not the last one, so A finishes exiting and drops out of the scan
right away, and exit_mmap() runs later from mmput_async() in a
kworker.  The next OOM picks B.  I traced 2 such over-kills in 40
runs; with MGLRU page table walks turned off (lru_gen/enabled =3D
0x0005) I got 0/40.  So a 7.0.y backport probably wants d14514c66cb9
as well; it applies to v7.0 and v6.19 as is.  I haven't built v7.0
with all three.

Zhan's series [1] is a different problem (thread groups migrated after
their leader exited); v7.4-rc1 with it still gave 20/20 here.  The two
patches change the same css_task_iter_start() line, so they will
conflict.

Tested-by: elenchist <elenchist.dev@gmail.com>

Adding the regressions list: a72f73c4dd9b is in v7.0 and was also
backported to 6.19.9.

#regzbot introduced: a72f73c4dd9b
#regzbot title: memcg OOM kills more tasks while the first victim exits
#regzbot fix: mm: memcontrol: Don't lose track of exiting OOM victims

I used an AI coding assistant (Claude Code) to build the kernels, run
the tests, analyse the traces and draft this mail; I have checked the
results and the text.

[1] =
https://lore.kernel.org/linux-mm/20261027144016.2582880-1-zhanxusheng1024@=
gmail.com/


