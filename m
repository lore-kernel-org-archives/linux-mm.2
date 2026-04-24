Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29DEFE5215
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FD06B0092; Fri, 24 Apr 2026 07:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA8E6B0093; Fri, 24 Apr 2026 07:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC9A6B0095; Fri, 24 Apr 2026 07:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D15DD6B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:58:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67B7C1C0055
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:58:48 +0000 (UTC)
X-FDA: 84693302736.24.4853E6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81C34100002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:58:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GWOFHpwv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031926; a=rsa-sha256;
	cv=none;
	b=Ax5+owpgJlhUgtt5/mSC1FoJJhuDd2L3j2LqCngDjyqf43kIZhzBpwZUU2p9fZ/QL5D0Zg
	SQyisJQEzyWoJ5KH/L/S/8ia7UnrXY8Z/y3j5HAK8tgUtKO/Ve+7bQv8KUqlDPU8mPYrz1
	00YoJpa8uoqa+LSqRDa6zRt+z3p67z4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GWOFHpwv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6J1bdbrO3whFUmvbmPkuH+PX1bOOwWaRPRg3azIVs0=;
	b=5rHQVks53oDdoLqO1M4B7nRkl/oOrc6Hx+O4cUpygx1Ohm6uGkLCqW3mVeGKgOxvURSHUy
	JeCgdWjIVwNA4bcqTyyRbcPbdrDsrLeKVP2Spm9kO0DkkQQxIkH1dBC1x2LqUhlYb4qA4I
	eU0mYB7DzTmBibR3ASOSRDLG18OZgVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B95D560141
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27971C2BCB5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777031925;
	bh=qUWpbeGWY5pmTrjxKOWxbcrhPHIb64xlMuj6qLR2BKo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GWOFHpwvzj5YrUmiU1m6js6svImAu8FnmuLz+Ej55RkMPizO3Hpfh/O7OBBHh+EPf
	 mhgEg9ZZlikljzvioUPQ+lbpwLqcMuZgVIEjnSStuDKxzCfZQCCL3ikUVHK0vrrPjF
	 etIgRGq2NxY+4aSsKvOk1B64Lw2I7C9nQul0iX5DcSlIwmkLFhBO+o17LSAYRNpl1i
	 urwWjpCLh50ubesIAmdS8PnMagbdr+s/w+pQMcLwS+lF0KA/KkDlo96xbuakdu6LaQ
	 gaCxjlMoLAGuZkiIIi0AMqhTY/p0OYUmVsyJf/q5ZHAG+ols6IFvMoYJITKBLsgzNE
	 sdlBWkFZ+AhHA==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a151012558so83701226d6.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:58:45 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx7YkbgfS1yoTESHSyOBjLwWwMmEGyfKg271KXDTi/+HF/s08x/
	u28OoXr7km/M3W7dx2d+Kv40E9p0PB3M/kmCEEai2yzp+csOjoYBZKR6vmbYmImXYUiUO9kCIpG
	u8rEAdnT5xRwlVPOlOfePfq6Kpj4kCko=
X-Received: by 2002:a05:6214:e63:b0:8a1:6529:5ac2 with SMTP id
 6a1803df08f44-8b02803ee1cmr499537176d6.13.1777031924017; Fri, 24 Apr 2026
 04:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com> <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Apr 2026 19:58:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com>
X-Gm-Features: AQROBzDKrkQmeYLKtF0fUTsuLU83SUb5JH243QpJbmFRxLovShO_UYKpggM0Mso
Message-ID: <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: rtwrys67fd8ydmuer55ind4hmpt3wknm
X-Rspam-User: 
X-Rspamd-Queue-Id: 81C34100002
X-HE-Tag: 1777031926-249016
X-HE-Meta: U2FsdGVkX19Z6G45M4yFiaZyVsY6lw0P2bUXGlQS7ZEn9Dwh5OeNI27kLt5U2XOBuM85pz6Zy4yTmhqBfVSFEdHknO2PedyyVxv4msOimzgVyoAyjcemP0BRh3KXEsVM0X2r4WvXI2l20ul6LRlwH8gakWOjOjIGlaRekstGWTLB3litZmb9QnsmqKbnbd2D4wZz6x8uEKbcCmqLYG8Va0ZN8wv2s+7R89KNYh/ygOXntDW4bdEAS5+wCxwyrmLEyVUF5Gtd76QSsw9VQEyEx+h4XxKbRvGK76c6GFmJGRMLeaY3jT31VisU4r+6KHPF8vSKo8VVtUkqmm2fH+uWVTFyLlsRSlfHh6Do5/ZlieGV8PMCgRnr0W7Wp6tCjdl2Iq/mzO6hE89zdTbYIFjnCHbSjZrljNdVCW8PdFDb7jZDn1yOv993fVc84CWoeMk9xUwgk1pxkqXhN/zDoTUywmXkd4f63iFisf/XbWNrS8dqd+QDc8wHursyRyMcvLH5gMstiIYRj4PGgPdYx297ZPvrkl0lZanry9JVMzaW5FlK09m9WhQZJKggYXeumb7tgP3pE3ucXt9Gj9d7CfZbGzhisdE++HPHomDJfJkveED5ZomhRDo4kQmowWbLzoicUzq1uCGKRU6TbQe1WWfsVn+4OljkXgv/YcQnJYMgv2tv+cuLA9OL4r/zafRh/75ZwHz48qQ9X2fxWukYGY4IxkvmmOsBBgjKVIBUAilymK1KWDEUofOzn/R8m2D1ycpqZj0lzWOYO64F1TxNh+PYzCNeA9cLbG4XQI/oKHcG98FjqmnJY0qZxXhhBXsfV1Jh2jXrPuHQsRmBBzgCs+N2UzBsqgzWzZuYcfETnlKBVLqfowpk7hW/kAcrAUFD6pvjyJjqb1nWP/RNNEKRVGvXyF5GgNuxMjaJBNGafNmTshqXEAOmpV14eoAnglow0WO1a38wXWXcPc5PzXvB/jd
 Bp3mndhx
 p/N+flYA/o9ZUrTkJo2Id5HuZfOLfYrhLgE1ah8QuYzAwA/NFqOjt/sfCXdS7d9UWt+ovBUoz+dEP6DP8nnfjTqwZ87XmAEwWRs7dbXeb2QkDS/rZ3qC+K76rTQ8WOjAYNQDjsNHdF5ATtca+oZhxpEjyNsS5uNSeAF50xAibMU6oDMW/nzpP8TlCddQ/v3IKfvUPMKo0CViPUM7NCeD3ewTEDfGILAr1YVeMmAYQTv4zW8tEG5Cd+P7efToVte7dELAii6tT38ezpj3KeoKOG3z431L+1YZt1hh6/QDCEDbUE6cQrkna7gcVVPrrH/peCgiX8k5u6/t1RfOsMaEYUM9lZDmlaBRY1B/sj39NsnAPrGU8md/I9RVunlJcctWHySqQDdhaT4Xc3tQGJ3jQMH8Y3nc/aMc9IEUG86b9RH5sZCbCGKnvnXHZ53Zh/hNprX8YcLENnV6jlKdO4khazhFox4BISKbLxyqKzGd5AiVEoaKjXaWSZXPFjbf2xWHT2717FGm0xNw5rWAN7QUZVBMnAtL/BEaDz3Yp7bh69c52GsIUto8LfSUM58OwXjVrdRG573444HLiUL7KH7eRajwhZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 6:32=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Apr 24, 2026 at 1:43=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > This series cleans up and slightly improves MGLRU's reclaim loop and
> > dirty writeback handling. As a result, we can see an up to ~30% increas=
e
> > in some workloads like MongoDB with YCSB and a huge decrease in file
> > refault, no swap involved. Other common benchmarks have no regression,
> > and LOC is reduced, with less unexpected OOM, too.
> >
> > Some of the problems were found in our production environment, and
> > others were mostly exposed while stress testing during the development
> > of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> > the code base and fixes several performance issues, preparing for
> > further work.
> >
> > MGLRU's reclaim loop is a bit complex, and hence these problems are
> > somehow related to each other. The aging, scan number calculation, and
> > reclaim loop are coupled together, and the dirty folio handling logic i=
s
> > quite different, making the reclaim loop hard to follow and the dirty
> > flush ineffective.
> >
> > This series slightly cleans up and improves these issues using a scan
> > budget by calculating the number of folios to scan at the beginning of
> > the loop, and decouples aging from the reclaim calculation helpers.
> > Then, move the dirty flush logic inside the reclaim loop so it can kick
> > in more effectively. These issues are somehow related, and this series
> > handles them and improves MGLRU reclaim in many ways.
> >
> > Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> > and a 128G memory machine using NVME as storage.
> >
> > MongoDB
> > =3D=3D=3D=3D=3D=3D=3D
> > Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000=
,
> > threads:32), which does 95% read and 5% update to generate mixed read
> > and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, an=
d
> > the WiredTiger cache size is set to 4.5G, using NVME as storage.
> >
> > Not using SWAP.
> >
> > Before:
> > Throughput(ops/sec): 62485.02962831822
> > AverageLatency(us): 500.9746963330107
> > pgpgin 159347462
> > pgpgout 5413332
> > workingset_refault_anon 0
> > workingset_refault_file 34522071
> >
> > After:
> > Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> > AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> > pgpgin 111093923                       (-30.3%, lower is better)
> > pgpgout 5437456
> > workingset_refault_anon 0
> > workingset_refault_file 19566366       (-43.3%, lower is better)
> >
> > We can see a significant performance improvement after this series.
> > The test is done on NVME and the performance gap would be even larger
> > for slow devices, such as HDD or network storage. We observed over
> > 100% gain for some workloads with slow IO.
> >
> > Chrome & Node.js [3]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with =
2
> > nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> > workers:
> >
> > Before:
> > Total requests:            79915
> > Per-worker 95% CI (mean):  [1233.9, 1263.5]
> > Per-worker stdev:          59.2
> > Jain's fairness:           0.997795 (1.0 =3D perfectly fair)
> > Latency:
> > Bucket     Count      Pct    Cumul
> > [0,1)s     26859   33.61%   33.61%
> > [1,2)s      7818    9.78%   43.39%
> > [2,4)s      5532    6.92%   50.31%
> > [4,8)s     39706   49.69%  100.00%
> >
> > After:
> > Total requests:            81382
> > Per-worker 95% CI (mean):  [1241.9, 1301.3]
> > Per-worker stdev:          118.8
> > Jain's fairness:           0.991480 (1.0 =3D perfectly fair)
> > Latency:
> > Bucket     Count      Pct    Cumul
> > [0,1)s     26696   32.80%   32.80%
> > [1,2)s      8745   10.75%   43.55%
> > [2,4)s      6865    8.44%   51.98%
> > [4,8)s     39076   48.02%  100.00%
> >
> > Reclaim is still fair and effective, total requests number seems
> > slightly better.
> >
> > OOM issue with aging and throttling
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > For the throttling OOM issue, it can be easily reproduced using dd and
> > cgroup limit as demonstrated in patch 14, and fixed by this series.
> >
> > The aging OOM is a bit tricky, a specific reproducer can be used to
> > simulate what we encountered in production environment [4]:
> > Spawns multiple workers that keep reading the given file using mmap,
> > and pauses for 120ms after one file read batch. It also spawns another
> > set of workers that keep allocating and freeing a given size of
> > anonymous memory. The total memory size exceeds the memory limit
> > (eg. 14G anon + 8G file, which is 22G vs a 16G memcg limit).
> >
> > - MGLRU disabled:
> >   Finished 128 iterations.
> >
> > - MGLRU enabled:
> >   OOM with following info after about ~10-20 iterations:
> >     [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=3D0xcc0=
(GFP_KERNEL), order=3D0, oom_score_adj=3D0
> >     [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt =
24460
> >     [   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
> >     [   62.640823] Memory cgroup stats for /demo:
> >     [   62.641017] anon 10604879872
> >     [   62.641941] file 6574858240
> >
> >   OOM occurs despite there being still evictable file folios.
> >
> > - MGLRU enabled after this series:
> >   Finished 128 iterations.
> >
> > Worth noting there is another OOM related issue reported in V1 of
> > this series, which is tested and looking OK now [5].
> >
> > MySQL:
> > =3D=3D=3D=3D=3D=3D
> >
> > Testing with innodb_buffer_pool_size=3D26106127360, in a 2G memcg, usin=
g
> > ZRAM as swap and test command:
> >
> > sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=3Dsb \
> >   --tables=3D48 --table-size=3D2000000 --threads=3D48 --time=3D600 run
> >
> > Before:            17260.781429 tps
> > After this series: 17266.842857 tps
> >
> > MySQL is anon folios heavy, involves writeback and file and still
> > looking good. Seems only noise level changes, no regression.
> >
> > FIO:
> > =3D=3D=3D=3D
> > Testing with the following command, where /mnt/ramdisk is a
> > 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> > 6 test run each:
> >
> > fio --directory=3D/mnt/ramdisk --filename_format=3D'test.$jobnum.img' \
> >   --name=3Dcached --numjobs=3D16 --size=3D3072M --buffered=3D1 --ioengi=
ne=3Dmmap \
> >   --rw=3Drandread --norandommap --time_based \
> >   --ramp_time=3D1m --runtime=3D5m --group_reporting
> >
> > Before:            9196.481429 MB/s
> > After this series: 9256.105000 MB/s
> >
> > Also seem only noise level changes and no regression or slightly better=
.
> >
> > Build kernel:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> > using make -j96 and defconfig, measuring system time, 12 test run each.
> >
> > Before:            2589.63s
> > After this series: 2543.58s
> >
> > Also seem only noise level changes, no regression or very slightly bett=
er.
> >
> > Android:
> > =3D=3D=3D=3D=3D=3D=3D=3D
> > Xinyu reported a performance gain on Android, too, with this series. Th=
e
> > test consisted of cold-starting multiple applications sequentially unde=
r
> > moderate system load. [6]
> >
> > Before:
> > Launch Time Summary (all apps, all runs)
> >   Mean 868.0ms
> >   P50 888.0ms
> >   P90 1274.2ms
> >   P95 1399.0ms
> >
> > After:
> > Launch Time Summary (all apps, all runs)
> >   Mean 850.5ms (-2.07%)
> >   P50 861.5ms  (-3.04%)
> >   P90 1179.0ms (-8.05%)
> >   P95 1228.0ms (-12.2%)
> >
> > Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75s=
u38w=3DHD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
> > Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/wo=
rkloadb [2]
> > Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@googl=
e.com/ [3]
> > Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-=
mix-pressure [4]
> > Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]
> > Link: https://lore.kernel.org/linux-mm/20260417025123.2971253-1-wxy2009=
nrrr@163.com/ [6]
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> Hi Kairui,
>
> I haven't identified the exact commit, but this patchset seems to
> make MGLRU's swappiness behavior more erratic.
>
> In mainline, MGLRU does not show as strong an effect as the
> active/inactive LRU, but it still behaves roughly linearly: higher
> swappiness leads to more swap activity and fewer file refaults.
>
> With this patchset, however, the behavior becomes non-monotonic as
> swappiness increases. I observed clear up-and-down fluctuations.
>
> I reproduced this by running a kernel build in a memcg limited to
> 1GB, with swappiness set to 35, 70, 105, 140, and 175.
>
> this is mainline using MGLRU:
>
> *** Executing round 1 ***
> set swappiness to 35
>
> real 1m49.247s
> user 25m30.484s
> sys 3m37.203s
> pswpin: 933731
> pswpout: 3365968
> pgpgin: 5649320
> pgpgout: 13786572
> swpout_zero: 794960
> swpin_zero: 10594
> refault_file: 354998
> refault_anon: 944323
>
> *** Executing round 2 ***
> set swappiness to 70
>
> real 1m49.313s
> user 25m31.643s
> sys 3m40.661s
> pswpin: 1049052
> pswpout: 3565887
> pgpgin: 5694288
> pgpgout: 14582200
> swpout_zero: 840947
> swpin_zero: 12029
> refault_file: 242973
> refault_anon: 1061033
>
> *** Executing round 3 ***
> set swappiness to 105
>
> real 1m48.611s
> user 25m32.198s
> sys 3m37.210s
> pswpin: 981095
> pswpout: 3396069
> pgpgin: 5283940
> pgpgout: 13898988
> swpout_zero: 795932
> swpin_zero: 11249
> refault_file: 202432
> refault_anon: 992295
>
> *** Executing round 4 ***
> set swappiness to 140
>
> real 1m49.398s
> user 25m35.650s
> sys 3m50.656s
> pswpin: 1222881
> pswpout: 3935186
> pgpgin: 6165024
> pgpgout: 16056664
> swpout_zero: 913808
> swpin_zero: 13251
> refault_file: 191564
> refault_anon: 1236083
>
> *** Executing round 5 ***
> set swappiness to 175
>
> real 1m49.513s
> user 25m35.442s
> sys 3m55.869s
> pswpin: 1343139
> pswpout: 4256014
> pgpgin: 6557152
> pgpgout: 17341452
> swpout_zero: 998107
> swpin_zero: 15692
> refault_file: 175795
> refault_anon: 1358782
>
> this is mm-new using MGLRU:
>
> *** Executing round 1 ***
> set swappiness to 35
>
> real 1m51.804s
> user 25m38.070s
> sys 4m16.301s
> pswpin: 1587728
> pswpout: 4932011
> pgpgin: 8788688
> pgpgout: 20062761
> swpout_zero: 1129975
> swpin_zero: 17944
> refault_file: 487923
> refault_anon: 1605670
>
> *** Executing round 2 ***
> set swappiness to 70
>
> real 1m51.503s
> user 25m37.581s
> sys 4m18.161s
> pswpin: 1743890
> pswpout: 5214587
> pgpgin: 8676728
> pgpgout: 21178716
> swpout_zero: 1185453
> swpin_zero: 20016
> refault_file: 317993
> refault_anon: 1763904
>
> *** Executing round 3 ***
> set swappiness to 105
>
> real 1m51.154s
> user 25m37.956s
> sys 4m15.017s
> pswpin: 1687517
> pswpout: 5073825
> pgpgin: 8173036
> pgpgout: 20608932
> swpout_zero: 1161806
> swpin_zero: 20069
> refault_file: 249769
> refault_anon: 1707538
>
> *** Executing round 4 ***
> set swappiness to 140
>
> real 1m50.732s
> user 25m37.686s
> sys 4m16.066s
> pswpin: 1671678
> pswpout: 5118895
> pgpgin: 7929960
> pgpgout: 20790468
> swpout_zero: 1171029
> swpin_zero: 19596
> refault_file: 193421
> refault_anon: 1691228
>
> *** Executing round 5 ***
> set swappiness to 175
>
> real 1m49.518s
> user 25m37.653s
> sys 4m12.619s
> pswpin: 1506888
> pswpout: 4789793
> pgpgin: 7270448
> pgpgout: 19479188
> swpout_zero: 1119251
> swpin_zero: 16699
> refault_file: 187304
> refault_anon: 1523585
>
> The final one is classic active/inactive LRU:
>
> *** Executing round 1 ***
> set swappiness to 35
>
> real 1m50.038s
> user 25m21.911s
> sys 3m42.798s
> pswpin: 476994
> pswpout: 2258185
> pgpgin: 5247280
> pgpgout: 9354640
> swpout_zero: 684759
> swpin_zero: 6387
> refault_file: 750021
> refault_anon: 483334
>
> *** Executing round 2 ***
> set swappiness to 70
>
> real 1m48.781s
> user 25m25.682s
> sys 3m37.854s
> pswpin: 515470
> pswpout: 2306901
> pgpgin: 4265500
> pgpgout: 9547436
> swpout_zero: 706437
> swpin_zero: 6960
> refault_file: 459740
> refault_anon: 522381
>
> *** Executing round 3 ***
> set swappiness to 105
>
> real 1m48.233s
> user 25m26.623s
> sys 3m38.843s
> pswpin: 519540
> pswpout: 2343897
> pgpgin: 3628788
> pgpgout: 9696500
> swpout_zero: 743576
> swpin_zero: 7782
> refault_file: 303701
> refault_anon: 527273
>
> *** Executing round 4 ***
> set swappiness to 140
>
> real 1m48.800s
> user 25m32.067s
> sys 3m50.751s
> pswpin: 605537
> pswpout: 2615227
> pgpgin: 3470540
> pgpgout: 10776312
> swpout_zero: 825446
> swpin_zero: 9055
> refault_file: 173236
> refault_anon: 614544
>
> *** Executing round 5 ***
> set swappiness to 175
>
> real 1m52.356s
> user 25m29.727s
> sys 3m55.664s
> pswpin: 698228
> pswpout: 2908292
> pgpgin: 3602884
> pgpgout: 11945332
> swpout_zero: 912127
> swpin_zero: 10298
> refault_file: 117625
> refault_anon: 708478
>
>
> The build script is available here if you want to have a try:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/diff/too=
ls/mm/build-kernel-with-increasing-swappiness.sh?h=3Dzram-async-gc&id=3Dd47=
888e9
>
> I am also debugging this. One possibility is that placing
> dirty pages in the youngest generation may have affected
> lruvec_evictable_size()?

I reverted the six commits below, but swappiness behavior is still
very unusual on mm-new.

4ce85c040e0a mm/vmscan: unify writeback reclaim statistic and throttling
f80a81552f50 mm/vmscan: remove sc->unqueued_dirty
9381a541a759 mm/vmscan: remove sc->file_taken
f2e2a7ae7660 mm/mglru: remove no longer used reclaim argument for
folio protection
b052c4a752a5 mm/mglru: simplify and improve dirty writeback handling
831409284da1 mm/mglru: use the common routine for dirty/writeback reactivat=
ion

After reverting patch 9-14:

*** Executing round 1 ***
set swappiness to 35

real 2m6.982s
user 24m59.930s
sys 9m1.374s
pswpin: 1973368
pswpout: 4792167
pgpgin: 12471516
pgpgout: 19490361
swpout_zero: 992543
swpin_zero: 48166
refault_file: 1002114
refault_anon: 2021486

*** Executing round 2 ***
set swappiness to 70

real 1m56.011s
user 25m24.954s
sys 5m31.730s
pswpin: 1788750
pswpout: 4869145
pgpgin: 9745888
pgpgout: 19799848
swpout_zero: 1009680
swpin_zero: 35920
refault_file: 540060
refault_anon: 1824622

*** Executing round 3 ***
set swappiness to 105

real 1m52.184s
user 25m29.605s
sys 5m19.031s
pswpin: 1894596
pswpout: 5220326
pgpgin: 9844536
pgpgout: 21251668
swpout_zero: 1107839
swpin_zero: 33253
refault_file: 453966
refault_anon: 1927801

*** Executing round 4 ***
set swappiness to 140

real 1m56.725s
user 25m26.667s
sys 6m7.878s
pswpin: 2366033
pswpout: 5584223
pgpgin: 11962872
pgpgout: 22660564
swpout_zero: 1167419
swpin_zero: 56513
refault_file: 442744
refault_anon: 2422500

*** Executing round 5 ***
set swappiness to 175

real 2m16.219s
user 24m32.728s
sys 12m26.124s
pswpin: 1990093
pswpout: 4568372
pgpgin: 13571748
pgpgout: 18604592
swpout_zero: 977963
swpin_zero: 52072
refault_file: 1289471
refault_anon: 2042117

So it is likely caused by an earlier commit than the six above.
I need to get some sleep.

Could this be because get_nr_to_scan() was moved out of the loop by
[PATCH v6 04/14] mm/mglru: restructure the reclaim loop,
while in mainline it is re-evaluated in each iteration?

Will take a look tomorrow or the day after.

Thanks
Barry

