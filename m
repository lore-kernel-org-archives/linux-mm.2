Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBE5EE6B6B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC8D6B0089; Fri,  6 Feb 2026 18:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A656B0092; Fri,  6 Feb 2026 18:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966926B0093; Fri,  6 Feb 2026 18:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 837C16B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:56:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27EAD1390C4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:56:28 +0000 (UTC)
X-FDA: 84415693656.14.09F3812
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 49AE440006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:56:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Adox9fiT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770422186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMvWXl+16besIoFxtupa8KqKhPGPXd3D6bW5GUBT3Eo=;
	b=ipIIJvUUv20L1TTjtHpzB8/LgMqp6BaxU67+x8TLuImAf9rFmzWtgbk6oZKOl+a+REFlNI
	9eu3Mee36VwnvjQfDPbtS85woUKU7vw/xOZXllxMDYvE4YqDQW8QQHgUUSTVIIqcz2oeqN
	3b8lgVwy76oUT0fBxAuhr4bzCUStov0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770422186; a=rsa-sha256;
	cv=none;
	b=3q5lIHpf9xV576O363j1ljk+s9Gl9Om3Tbl6GMogUzJXCukL+sqnjAMMsmS8Ig/p7IGNEb
	3JI/iolXd4vGJi8zh79DrSuvqMQTeb2jrkWVy8yx8UX1ZG/H0yFw4yDBZdhNus91lBiRqv
	sFUn/Ik0RKA1td4vSf/H7KET1yd0oMw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Adox9fiT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4362d18bb65so773961f8f.2
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 15:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770422184; x=1771026984; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yMvWXl+16besIoFxtupa8KqKhPGPXd3D6bW5GUBT3Eo=;
        b=Adox9fiT63SROTdWdroOl0+BdqotBRjvO8SbV3B6mIMj7zTn3xe8ANiK2DBVqKtAcW
         e1ATW9FO0z966gOAWoyST55uVmW6a+Q2Sos5MHZuHhJ/pJC2WPhYLlUZGSmdqdXFKcw4
         tA3XM6G7SfjI3T/eL2Ivy5EFi1AvajH7uSvDUs4P2j0rbMf9W2O8F962nCAKDIbdgHII
         1sTajYdt+iedy9E1UgwbNAunO3LC3XBA/F1+o0PpmkNoHhQuZvno2F8XjuhtbowwqpYG
         lKdAUoxJwAA1aeysHSqRD+CEcjm7udaTHINulwJALJn6Jt1HWeEdDTaHQ0eegsDxwfba
         mO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770422184; x=1771026984;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMvWXl+16besIoFxtupa8KqKhPGPXd3D6bW5GUBT3Eo=;
        b=wedivodmM8/Qxu7Z45OZNz2Y8ieQF1nOWNHAQzpJeLZ/d0GLVM/INZYH3tPlduKyaO
         vlbyxK40ZKKnWqt9sGYIoma38WD7frY68af2nu5jk4ET7OQB8Jnz5gWAzAKJeuM8keQh
         +G/S0rmaJJIAICwTTWp7stmFXZB7U9HVGxVrBlzlUbvxBcWEqX4zwJkeGITBlx+boxAp
         Wjj5VRctLNsROtpj4sFfy5wkIJTSrXSFI9irccJVvUAZI48/OnjGjf0jMKZPnDDOTsOo
         7f4zd+VrRYKUEnJs4GMNxjruDqZFO4yOdeALfpNcPm2yI7j6MU65ud2SFWIj/dwqVCVd
         +79A==
X-Forwarded-Encrypted: i=1; AJvYcCWakSbAasUcZt1sfz1dcSXLzs3hSaYkoxLS3fJuxiHiixxf1jZ2nzlnuU4c1lLFPxa9JpLfY1hiGA==@kvack.org
X-Gm-Message-State: AOJu0YwKJu/SLxcgv5E8XN9tBG1EGB3/tAoEuxmtRsXe7PZYfDOAnUhK
	p3qL5+SmS2H2o/imNg1kssom6xwCHG5fEqBA9sgIi4v9OyXOdoPyKc1k
X-Gm-Gg: AZuq6aK8WAJSXN7Fjq1LO2PcH8ywlkLKRszgke1x6GtHSSijUg5KBO9Klsy95MO2aFQ
	51nqSVMXh2nV3fNpq7hmAV2x2FJzTOWt9sn9XfJvbX8PCMg1Fn4BP2BBgZUKFNb1BF+cDI3jVgd
	n/x+FbqKYJKTQqdPpY9lQlJkb6CygEQdOUo8rHavAJL/S94vRdExQEncdg5QdIlsVFTBfD4FkL+
	y2pqAq3rLxv+keqRsXFr1Ib4Agn2Y1ZiiyCKrC9yWkusl3Tg0Bq27Ii1q/tPbyT4TjnTY6Zmp87
	Y0agMPGga8xAFXlrnL42cmAEmb68KelGmHYCDUGHFGr0TrTx25jfjKUbOyIGbRN2SV7ysI/fDaN
	3lUPi1tDrU8XeK62Vsxc0S6prlNNj5rqR+sPYmrw0h+r829cbjBwsahzZP/PHCJnKzx96dRzBww
	fgp6dLV7RDMnrlNuZkKWHsP9ULw6Wbj4ZoMw==
X-Received: by 2002:a05:6000:2304:b0:436:cea:6165 with SMTP id ffacd0b85a97d-4362904b70dmr5665598f8f.6.1770422184414;
        Fri, 06 Feb 2026 15:56:24 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43629754c62sm8306435f8f.38.2026.02.06.15.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 15:56:23 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Fri,  6 Feb 2026 20:56:21 -0300
Message-ID: <aYZ2fM39jyoOF247@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260206143430.021026873@redhat.com>
References: <20260206143430.021026873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49AE440006
X-Stat-Signature: hfodwnd4axshy59gqs1z9u9dk5f1jwig
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770422186-579588
X-HE-Meta: U2FsdGVkX18OIREFNmKpE6gA1+AqjcBthS/w7PyZkBG7WW758mfpk8z1ovps+cTra9Eblmt0lWVI4FBu+75DMslC1+E4IIiC1W8t6pt4QXnX/UtE63B6/5XyyrGyrRYFjXvc5x71tsK7FEXuiQJlPn6yzWJkGEidKV1YPpNWQwyiG01UPH9ANPphMN+y8Jw7rN0/iXHQyHDh3e6wwMJZQl9R5gyhlk29x5HTG4wwkH/9IG2Dp2nqW/i3+e2zR3o7lozcBv5YviMFQvmz0Q0LjYhgXPOYQuqEfj0k+rgThiU6ANrqXtO3NGsDKHaBwPsk8aQpPmhMGkQ3uR354wwmoJhaKdM+Locd77RiQTHNBcWO+6ABFq5zxqmW9JaGMGvrhcHEKnj2zvTqemoAZ6Er8QWgUik8F1MpUNfjwyxoqq8lKitdfUKb+1crFXn4dSBudmqkls+x8C7wWay03/hW5+SAJkzYJIvbYZcECk5OLbds0AInhV9QpWORb/yQFGQ41lSkh0XAhKJoKi4Hs2yiJnSb0hnwjkYYH7wZwnL1KhxWgGSOS+h4RytcYpkAzFpp02dxjVNVWsT+J//TJZ0+srJij/pBGaUQB/2Z5DspbH5y2EsZ6oZY1KIvQss4EeDUocIzhuTMX4uRuhdtd47VVnM5jaNIH+ahRxk/78jO4At6qkSyN6POiIOrhvjPiSek2HjNK3K6x1VVkpkhtpgMMHhDtG8i726lRfiDKf0nsnFw61h/xDLGPUy8Gl4OXRCFe8D+nkUC4eFrO0YpPSy0tZP8JRWg2dJZ4Jj6GRd6UV4yi4dnYAy5x0ddHiDWRSD8ZMVQe1caZFnzKhTU4LppRe36CjuepWf32k3qlWKdWD1yv8oxY4bZBC8EsmgGpdjSCqRIk71GiairaPGZ5B93PKC6GVpJrf7TNFtoIwYQo5xz/ZafRrF6kv4FkDhFcMoH4uqUCNkTxHkdjMzHRyC
 rVOI65em
 awBHDSE5lrElPL2i7vmN+Gl5iS0BySs4U0008sgEuv7uJPFVsZv1cX0X8YCMStnIZ2ZmgVquM9sd5u4jF8iKVsU+19B8lncN9r9dxUBVb67FQ0Pd5NI/DnZL1P1Wc+DW1DDyC4SqLwDvdgrndOovpOcxaEzrJKC1QBlPl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:34:30AM -0300, Marcelo Tosatti wrote:
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.
> 
> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 

Marcelo, thanks for finishing this series!

> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If PREEMPT_RT=n this interfaces just wraps the current

Are we enabling it by default in PREEMPT_RT=y? If not,

If CONFIG_QPW=n or qpw=0 this interfaces just wraps the current

> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will

Same here

If CONFIG_QPW=y and qpw=1, queue_percpu_work_on(cpu,...) will

> lock that cpu's per-cpu structure and perform work on it locally. 
> This is possible because on functions that can be used for performing
> remote work on remote per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the per_cpu spinlock() for the cpu passed as parameter.
> 
> RFC->v1:
> 
> - Introduce CONFIG_QPW and qpw= kernel boot option to enable 
>   remote spinlocking and execution even on !CONFIG_PREEMPT_RT
>   kernels (Leonardo Bras).
> - Move buffer_head draining to separate workqueue (Marcelo Tosatti).
> - Convert mlock per-CPU page lists to QPW (Marcelo Tosatti).
> - Drop memcontrol convertion (as isolated CPUs are not targets
>   of queue_work_on anymore).
> - Rebase SLUB against Vlastimil's slab/next.
> - Add basic document for QPW (Waiman Long).

A document was a nice touch :)

> 
> 
> The following testcase triggers lru_add_drain_all on an isolated CPU
> (that does sys_write to a file before entering its realtime 
> loop).
> 
> /* 
>  * Simulates a low latency loop program that is interrupted
>  * due to lru_add_drain_all. To trigger lru_add_drain_all, run:
>  *
>  * blockdev --flushbufs /dev/sdX
>  *
>  */ 
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <stdlib.h>
> #include <stdarg.h>
> #include <pthread.h>
> #include <sched.h>
> #include <unistd.h>
> 
> int cpu;
> 
> static void *run(void *arg)
> {
> 	pthread_t current_thread;
> 	cpu_set_t cpuset;
> 	int ret, nrloops;
> 	struct sched_param sched_p;
> 	pid_t pid;
> 	int fd;
> 	char buf[] = "xxxxxxxxxxx";
> 
> 	CPU_ZERO(&cpuset);
> 	CPU_SET(cpu, &cpuset);
> 
> 	current_thread = pthread_self();    
> 	ret = pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
> 	if (ret) {
> 		perror("pthread_setaffinity_np failed\n");
> 		exit(0);
> 	}
> 
> 	memset(&sched_p, 0, sizeof(struct sched_param));
> 	sched_p.sched_priority = 1;
> 	pid = gettid();
> 	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
> 	if (ret) {
> 		perror("sched_setscheduler");
> 		exit(0);
> 	}
> 
> 	fd = open("/tmp/tmpfile", O_RDWR|O_CREAT|O_TRUNC);
> 	if (fd == -1) {
> 		perror("open");
> 		exit(0);
> 	}
> 
> 	ret = write(fd, buf, sizeof(buf));
> 	if (ret == -1) {
> 		perror("write");
> 		exit(0);
> 	}
> 
> 	do { 
> 		nrloops = nrloops+2;
> 		nrloops--;
> 	} while (1);
> }
> 
> int main(int argc, char *argv[])
> {
>         int fd, ret;
> 	pthread_t thread;
> 	long val;
> 	char *endptr, *str;
> 	struct sched_param sched_p;
> 	pid_t pid;
> 
> 	if (argc != 2) {
> 		printf("usage: %s cpu-nr\n", argv[0]);
> 		printf("where CPU number is the CPU to pin thread to\n");
> 		exit(0);
> 	}
> 	str = argv[1];
> 	cpu = strtol(str, &endptr, 10);
> 	if (cpu < 0) {
> 		printf("strtol returns %d\n", cpu);
> 		exit(0);
> 	}
> 	printf("cpunr=%d\n", cpu);
> 
> 	memset(&sched_p, 0, sizeof(struct sched_param));
> 	sched_p.sched_priority = 1;
> 	pid = getpid();
> 	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
> 	if (ret) {
> 		perror("sched_setscheduler");
> 		exit(0);
> 	}
> 
> 	pthread_create(&thread, NULL, run, NULL);
> 
> 	sleep(5000);
> 
> 	pthread_join(thread, NULL);
> }
> 
> 

Also, having the reproducer in the cover letter was a great idea!

Thanks!
Leo

