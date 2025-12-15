Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5410D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108246B0012; Mon, 15 Dec 2025 07:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0806B0026; Mon, 15 Dec 2025 07:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38BC6B0028; Mon, 15 Dec 2025 07:19:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1C906B0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:19:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 856EDC017A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:19:22 +0000 (UTC)
X-FDA: 84221610564.04.9F656E8
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44A494000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:19:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSBnitjs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765801159; a=rsa-sha256;
	cv=none;
	b=ncbbGwpP0gUHgprV3misnA2WFiHtA97wMK9VLd0kNJQ7otV6XlL0iSCUgaor9MOBePfWjw
	TXN3D0cZk/MYm9LjDCv1Gc0R8zfDed6IXSbTmSiatjQwfuEpIW9lrCNBELi5CYo/myQnFA
	uzv3Jqb/h1ja2J/FBJgEnbS/WfAKlSI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSBnitjs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765801159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DQ/PnGxbStCcwIYhrJfwbp2Aj0FhrklR/ahQcSV2tI=;
	b=7zW+hsuhxen6dloZMXSy+aZia+AFVLVdOjMsJzjVKIF6a4DERDqlXTmNTjPk8J6YFJeUi4
	C5mQT2G5soM4ZcaOPd3YouaEKMvoSwBbQWzw0dcDQeeEYbjdSHqtqTbTTxy8yuoBRRCCBV
	hiHB6BZPMhsfotN+K0ozlpzknx7j9QM=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5945510fd7aso2917490e87.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765801157; x=1766405957; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5DQ/PnGxbStCcwIYhrJfwbp2Aj0FhrklR/ahQcSV2tI=;
        b=dSBnitjsgBdFC9bP8JNhky0E1Cp22pvSZOwYA3cleolDTI2V+yBTHJcGXFynDJ2yOo
         5fGgEFNWDdccB0ADJCaLrlBO0CykgVioi32IL0pTgjcjLBLyK+gCElsfrQTHBpp1PoGJ
         r0Pi7+ilWcxzXS1A8zpYXgUbBJxXhMt2L24G+CrdLVaMvEQ7aGMuG8U8tvhCqbGDkbKR
         tVGuYL2Lu7Gz0+9U0GIOo26mdGlFcLCLtMEMYmUNPVrO7vWghZKTGFCJRBVyJQLYQZhV
         TC7Rb/Q3h6gSjI2JxKFIz/d7MPiFIB0ihYQR+60I+O0yCO5BgHTyCbtNViVtwuvPW+yZ
         sQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765801157; x=1766405957;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DQ/PnGxbStCcwIYhrJfwbp2Aj0FhrklR/ahQcSV2tI=;
        b=XaRpAilVnAl6OYxHm9r3jEUrTJEnq7veB0MEjeSoFa4sQSFpzPs6/MKYLcwC+vJ2GV
         azEyPBWwUWcaLY9UHwns6pIDI8yrk733HRh4562FYsVRnEYGF1Cect42Zd6hT7jBhClK
         Gmp6vJKrth8h5+xw5u6KhsdcGmSYaUdinqaGxkKiwEmTm+RxBY33lq1M8EO85u+ZFDbh
         PiQ9h/8778lXM1ZIHVrJ1Gc4asFoUQpqJA28SLKaVrxy7wYqnqYOE3OP+A/DrtBl9eaH
         Wy6Qqe3p8S4i0dmOthI5jSEbvvlDzqM/oLckiKEOnWX4RpXgcfNfycOUwBW8Dz4Wd6kL
         jfzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkbQUT+XvCQKtKbghWdce80pa9SFxBwbwzg3MHCVDfOnRceEowz95f4MOBy/+UiBsiHj7+VxGUBg==@kvack.org
X-Gm-Message-State: AOJu0Yz48DeGO8wZKlmvS1PK7zE1wYUkaNSVIAbK/SPpUc0IYxg59Twr
	O1OK7fcGolhNrRFxMlvWnzTz/0QqhTdpSe6jOVmQpaFBPsQkgZlY4LCv
X-Gm-Gg: AY/fxX6a2gk32HRVKGurietIOE0MKYWMTn/W/DuKtTTLrnnnzqgMHu/7SyWwMWClVGP
	4NgNjltBzU6XrNvGbqI+BPnWwLh81DRTKcCbnWbnU0rOu1y1MSx6MRlg2m3Hc3/DdDM11k2v3UI
	G505hKYBPY5CTWSEJ1QrPUcPypMPAxZyV1iXPLh17LDzg2bvsI/SAA6utypg5qpW1qGQW5ZGd+l
	MNwvJSwbbTrWosKwrB9hrMUyavHsL6GcAs49gsbYTaBqOrwLsZtbFrSAspH4etGR1A9oN2JGS7g
	z/limicl7+EOoW6OsSG5jRVTZcdlYr82QzVmWzdNhiwzxNZ9leiL839qSW5zCR1V4a33ER3BsHn
	fFs0DEGXI3m3c6pM0f2EPc8APJgrvwak2nFE7rsn109MpjEkIpsGc
X-Google-Smtp-Source: AGHT+IEx3f7F0pp7G3Uq1MB+gF3kfP+h8eNH1x2k5KU7kc5pZdIm7D0Wrn0li1+jr4lroH/QE0J7jw==
X-Received: by 2002:a05:6512:1088:b0:594:1c7c:7d31 with SMTP id 2adb3069b0e04-598faa42bbcmr3457206e87.12.1765801156902;
        Mon, 15 Dec 2025 04:19:16 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-598f2f952d1sm5430589e87.65.2025.12.15.04.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 04:19:16 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 15 Dec 2025 13:19:14 +0100
To: kernel test robot <oliver.sang@intel.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  9c47753167:
 stress-ng.bigheap.realloc_calls_per_sec 21.3% regression
Message-ID: <aT_8woTbtklin3Bh@milan>
References: <202512121138.986f6a6b-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202512121138.986f6a6b-lkp@intel.com>
X-Rspamd-Queue-Id: 44A494000D
X-Rspamd-Server: rspam03
X-Stat-Signature: o7bsyxx1r65soxazowfeu1onf9a8cwww
X-Rspam-User: 
X-HE-Tag: 1765801159-596292
X-HE-Meta: U2FsdGVkX18ryJLNmkDB0RibzrOfeRitdkO1fOczdIcuNvCtGiTILS5qASyW5qQl/unpORfhYFguQtpJuwjUONWZpR6zzL+jgZ5kT8vDf38I/8e+CHx7mNOmkDxExWfgA/G4GobIAZMaSFFnmqlGfCHjYiCMUll1oAfaIgdPE/wSNalFQb/lRBrSEHZoa2PxKUesQPKGGuxXUYgDenv2qIdsyoP+1Gc43b0RrWUaqo6UbnBCw0DHv6XISXGHrm7sqHLagYPHyGblDbMY+NXlX5PhBEeQHeae2aBRC25D4QBV9ZFcLHVHH0JirPvJiI6HuLiBv5CutswQzDIdneCDRrUnAoFl8lLRC4OSMTdKAWCs6q0qg01lee7p/4mGSQyXjE2Lx/vaN65Z1v1SG7MKbuoaHHTuPyI2osc/xeRKcrH4ttRe/aXGZjRt+YCZs/nGypaOEolzXHn2URjkPCKTxcFdyKPYkF9IqhLqjTxFWCwcYsgE14xkt6aedcvf05l7k/dKPLqJ+Zki44cqzGkRlMlvyqJb/v4YC4L+ObOdyKw0wfiNrKQime7SBDDoHBazrY2eWLXoKFu16VUACJP0nVU01k51buOhh1W6Cwvur4dD5BhlSgHw5y+Y+Vsf0FLVhs2GwaeawWMXthsFPIOGH+TTmgDfJOPMz3hlbi3h3AGouYXPuskdf80ycePyBtvU+BtziZ/aDzAqzaCYTQuwcQgu15zBICN9HEDQ8WFMYJecrbAXonIY60IQKeekmIdE/TEyEIKS10VgpQgMYcon2cYOw3OfZhkikyc62MJUK/fjGFXUZGV/AZHnNdIfa1zNTGq1Ay3dn1qxvSzx5dSoPfkdqmwvgeAHDT6LladhiYU2xCPJ8jzlH5VpjtmgQgIQpvXf5hFycnmsTHEM+Ha4sFV5prOIA7TvWMMJI3VjcR0HdfX7BLMojOgKTf5lN03I+8PUDkMpgxv7VFP6Mlv
 lQQ/RZOO
 P4yqJeiROaEs0S48OUpU1XyCkgzIGmM97y+/6xgyIXUHxJj9ZoLTyV9nIXi+l6SROSwdJps3WRxLSFuJDjHR/mIj5A16eqqN4LWjmf7sInitRASWtOKuWbQa4UlJv+FOhk+bcS1OP7fnwHiBRRBJqObfJzHEoRoe4J1Nh3Pg/RMJnQmGQTuVBL8QkEiMNq1jeJIa7ZUwjExmARvGymbT18xlm0a/9QMj66DogSFD8YThOBzqXokUUKRJM2EEiGqQi0BUKhdJ97ZiCIxPMF3s8Ry2XEEuZtbzkS7O6go4fwG+Yn5kmi+eqZRM4HHykml4Uri2UtDbAov8A/5ZWqmVliK6UekusQpXn38p4cF1IDYyU5oDrKH5J0O8ojZxIxxPVBuZ2hSj/bIIh6P6hN78NuyuWPnUyVaFzcTKhh6IaV0lL3U55QkMsZACIFFrZ5R+Ltsmmq969LOnYluB/Yp5uzZioBXOBIEsmVCz8hFpPhgkFOsFZdYLrLeow6gOCgD+NzQ/+0nXajYe5t1J8fm6Puc0O/Dd9+xCtOczsoCOsf7cR10+M/Jp4CnbSO+1yqSM6tFxRBxW+OCZdTOFUiR1FoKIEkwkosm9J5e5oD4iSmSHAxLcxMdPaVMxXbcXDq9i1lVaziI4t18FgTFFt93LCWLzS1kDGagEahs6py2D5GWRplXrU92jqu+19J7aDen63RDE44s6lIdQuEMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 11:27:27AM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 21.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
> 
> 
> commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: defer freeing partly initialized vm_struct")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
> [still regression on linux-next/master 008d3547aae5bc86fac3eda317489169c3fda112]
> 
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: bigheap
> 	cpufreq_governor: performance
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251212/202512121138.986f6a6b-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s
> 
> commit: 
>   86e968d8ca ("mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()")
>   9c47753167 ("mm/vmalloc: defer freeing partly initialized vm_struct")
> 
> 86e968d8ca6dc823 9c47753167a6a585d0305663c69 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>     209109 ±  5%     -14.1%     179718 ±  6%  numa-meminfo.node0.PageTables
>    1278595 ±  7%     -10.4%    1145748 ±  2%  sched_debug.cpu.max_idle_balance_cost.max
>      33.90            -3.6%      32.67        turbostat.RAMWatt
>  3.885e+08           -10.9%  3.463e+08        numa-numastat.node0.local_node
>  3.886e+08           -10.8%  3.466e+08        numa-numastat.node0.numa_hit
>  3.881e+08           -10.9%   3.46e+08        numa-numastat.node1.local_node
>  3.883e+08           -10.9%  3.461e+08        numa-numastat.node1.numa_hit
>  3.886e+08           -10.8%  3.466e+08        numa-vmstat.node0.numa_hit
>  3.885e+08           -10.9%  3.463e+08        numa-vmstat.node0.numa_local
>  3.883e+08           -10.9%  3.461e+08        numa-vmstat.node1.numa_hit
>  3.881e+08           -10.9%   3.46e+08        numa-vmstat.node1.numa_local
>   48320196           -10.9%   43072080        stress-ng.bigheap.ops
>     785159            -9.8%     708390        stress-ng.bigheap.ops_per_sec
>     879805           -21.3%     692805        stress-ng.bigheap.realloc_calls_per_sec
>      72414            -3.3%      70043        stress-ng.time.involuntary_context_switches
>  7.735e+08           -10.9%  6.895e+08        stress-ng.time.minor_page_faults
>      15385            -1.0%      15224        stress-ng.time.system_time
>     236.00           -10.5%     211.19 ±  2%  stress-ng.time.user_time
>       0.32 ±  4%     +95.1%       0.63 ± 12%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>      16.96 ± 41%   +5031.1%     870.26 ± 40%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.32 ±  4%     +95.1%       0.63 ± 12%  perf-sched.total_sch_delay.average.ms
>      16.96 ± 41%   +5031.1%     870.26 ± 40%  perf-sched.total_sch_delay.max.ms
>       4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.total_wait_and_delay.max.ms
>       4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.total_wait_time.max.ms
>       4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>   29568942            -2.9%   28712561        proc-vmstat.nr_active_anon
>   28797015            -2.8%   27991137        proc-vmstat.nr_anon_pages
>      99294            -3.7%      95669        proc-vmstat.nr_page_table_pages
>   29568950            -2.9%   28712562        proc-vmstat.nr_zone_active_anon
>   7.77e+08           -10.9%  6.927e+08        proc-vmstat.numa_hit
>  7.766e+08           -10.9%  6.923e+08        proc-vmstat.numa_local
>  7.785e+08           -10.8%  6.941e+08        proc-vmstat.pgalloc_normal
>  7.739e+08           -10.8%  6.899e+08        proc-vmstat.pgfault
>  7.756e+08           -10.6%  6.931e+08        proc-vmstat.pgfree
>       7.68            -3.8%       7.39        perf-stat.i.MPKI
>  2.811e+10            -4.9%  2.672e+10        perf-stat.i.branch-instructions
>       0.06            -0.0        0.05        perf-stat.i.branch-miss-rate%
>   15424402           -14.3%   13220241        perf-stat.i.branch-misses
>      80.75            -2.3       78.42        perf-stat.i.cache-miss-rate%
>  1.037e+09           -11.0%  9.233e+08        perf-stat.i.cache-misses
>  1.217e+09           -10.6%  1.088e+09        perf-stat.i.cache-references
>       2817 ±  2%      -2.8%       2739        perf-stat.i.context-switches
>       7.16            +5.1%       7.53        perf-stat.i.cpi
>       1846 ±  5%     +30.6%       2410 ±  5%  perf-stat.i.cycles-between-cache-misses
>  1.298e+11            -5.9%  1.222e+11        perf-stat.i.instructions
>       0.14            -5.2%       0.13        perf-stat.i.ipc
>     103.98            -9.7%      93.94        perf-stat.i.metric.K/sec
>   13534286           -11.0%   12040965        perf-stat.i.minor-faults
>   13534286           -11.0%   12040965        perf-stat.i.page-faults
>       7.64            -5.3%       7.23        perf-stat.overall.MPKI
>       0.05            -0.0        0.05        perf-stat.overall.branch-miss-rate%
>       7.20            +5.3%       7.58        perf-stat.overall.cpi
>     942.28           +11.2%       1047        perf-stat.overall.cycles-between-cache-misses
>       0.14            -5.0%       0.13        perf-stat.overall.ipc
>  2.678e+10            -4.1%  2.569e+10        perf-stat.ps.branch-instructions
>   14559650           -13.3%   12627015        perf-stat.ps.branch-misses
>  9.434e+08           -10.0%  8.491e+08        perf-stat.ps.cache-misses
>  1.112e+09            -9.5%  1.006e+09        perf-stat.ps.cache-references
>  1.235e+11            -4.9%  1.174e+11        perf-stat.ps.instructions
>   12270397           -10.0%   11048367        perf-stat.ps.minor-faults
>   12270398           -10.0%   11048367        perf-stat.ps.page-faults
>  7.755e+12            -5.9%    7.3e+12        perf-stat.total.instructions
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>      42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>      41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
>      41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>      41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
>      41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
>      41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
>      41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
>      41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
>      41.65            -5.1       36.60        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache
>      41.63            -5.1       36.58        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
>      41.65            -5.1       36.60        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
>      41.46 ±  2%      -5.0       36.41        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
>      40.84 ±  2%      -4.9       35.90        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu
>       3.89 ±  4%      -2.4        1.53 ±  8%  perf-profile.calltrace.cycles-pp.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       3.84 ±  4%      -2.4        1.49 ±  8%  perf-profile.calltrace.cycles-pp.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
>       3.82 ±  4%      -2.3        1.47 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo
>       3.74 ±  4%      -2.3        1.43 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo
>       3.10 ±  2%      -0.6        2.45 ±  2%  perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
>       1.90            -0.4        1.52        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
>       1.84            -0.4        1.48        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
>       1.80            -0.4        1.44        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
>       1.70            -0.4        1.36        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
>       1.43 ±  6%      -0.3        1.12 ±  2%  perf-profile.calltrace.cycles-pp.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
>       1.26 ±  4%      -0.3        0.98 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault
>       1.21            -0.3        0.95        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
>       1.16 ±  8%      -0.3        0.90 ±  5%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
>       1.17            -0.3        0.92        perf-profile.calltrace.cycles-pp.clear_page_erms.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
>      44.15 ±  2%      +7.5       51.61 ±  2%  perf-profile.calltrace.cycles-pp.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
>      44.32 ±  2%      +7.5       51.79 ±  2%  perf-profile.calltrace.cycles-pp.sysinfo
>      44.30 ±  2%      +7.5       51.77 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
>      44.30 ±  2%      +7.5       51.77 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.sysinfo
>      44.28 ±  2%      +7.5       51.75 ±  2%  perf-profile.calltrace.cycles-pp.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
>      40.25 ±  2%      +9.8       50.06 ±  2%  perf-profile.calltrace.cycles-pp.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      40.24 ±  2%      +9.8       50.06 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
>      40.08 ±  2%      +9.8       49.92 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo
>      44.76 ±  2%      -6.0       38.80 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
>      44.44 ±  2%      -5.9       38.56 ±  4%  perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
>      42.85            -5.2       37.62        perf-profile.children.cycles-pp.__munmap
>      42.85            -5.2       37.62        perf-profile.children.cycles-pp.__vm_munmap
>      42.85            -5.2       37.62        perf-profile.children.cycles-pp.__x64_sys_munmap
>      42.88            -5.2       37.65        perf-profile.children.cycles-pp.do_vmi_align_munmap
>      42.88            -5.2       37.65        perf-profile.children.cycles-pp.vms_clear_ptes
>      42.88            -5.2       37.65        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
>      42.86            -5.2       37.64        perf-profile.children.cycles-pp.do_vmi_munmap
>      42.62            -5.2       37.40        perf-profile.children.cycles-pp.folios_put_refs
>      42.60            -5.2       37.40        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
>      42.60            -5.2       37.40        perf-profile.children.cycles-pp.free_pages_and_swap_cache
>      41.93            -5.1       36.84        perf-profile.children.cycles-pp.__page_cache_release
>      41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.unmap_page_range
>      41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.unmap_vmas
>      41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.zap_pmd_range
>      41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.zap_pte_range
>      41.51 ±  2%      -5.1       36.45        perf-profile.children.cycles-pp.tlb_flush_mmu
>       3.89 ±  4%      -2.4        1.53 ±  8%  perf-profile.children.cycles-pp.si_meminfo
>       3.84 ±  4%      -2.4        1.49 ±  8%  perf-profile.children.cycles-pp.nr_blockdev_pages
>       3.11 ±  2%      -0.6        2.46 ±  2%  perf-profile.children.cycles-pp.alloc_anon_folio
>       1.90            -0.4        1.52        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
>       1.89            -0.4        1.52        perf-profile.children.cycles-pp.alloc_pages_mpol
>       1.84            -0.4        1.48        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
>       1.73            -0.3        1.39        perf-profile.children.cycles-pp.get_page_from_freelist
>       0.56 ± 72%      -0.3        0.22 ±108%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
>       1.45 ±  6%      -0.3        1.14 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map_lock
>       1.22            -0.3        0.96        perf-profile.children.cycles-pp.prep_new_page
>       1.16 ±  7%      -0.3        0.90 ±  5%  perf-profile.children.cycles-pp.__mem_cgroup_charge
>       1.19            -0.3        0.93        perf-profile.children.cycles-pp.clear_page_erms
>       0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.handle_internal_command
>       0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.main
>       0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.run_builtin
>       0.44 ± 10%      -0.1        0.35 ±  6%  perf-profile.children.cycles-pp.free_unref_folios
>       0.25 ±  9%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.record__mmap_read_evlist
>       0.40 ± 11%      -0.1        0.31 ±  6%  perf-profile.children.cycles-pp.free_frozen_page_commit
>       0.24 ±  8%      -0.1        0.16 ±  4%  perf-profile.children.cycles-pp.perf_mmap__push
>       0.38 ± 13%      -0.1        0.30 ±  7%  perf-profile.children.cycles-pp.free_pcppages_bulk
>       0.55            -0.1        0.48        perf-profile.children.cycles-pp.sync_regs
>       0.48 ±  4%      -0.1        0.42 ±  2%  perf-profile.children.cycles-pp.native_irq_return_iret
>       0.37 ±  4%      -0.1        0.31 ±  3%  perf-profile.children.cycles-pp.rmqueue
>       0.35 ±  4%      -0.1        0.30 ±  3%  perf-profile.children.cycles-pp.rmqueue_pcplist
>       0.19 ±  6%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.record__pushfn
>       0.18 ±  7%      -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.ksys_write
>       0.17 ±  5%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.vfs_write
>       0.28 ±  5%      -0.0        0.24 ±  3%  perf-profile.children.cycles-pp.__rmqueue_pcplist
>       0.31            -0.0        0.27        perf-profile.children.cycles-pp.lru_add
>       0.16 ±  5%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.shmem_file_write_iter
>       0.24 ±  6%      -0.0        0.20 ±  5%  perf-profile.children.cycles-pp.rmqueue_bulk
>       0.16 ±  4%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.generic_perform_write
>       0.24 ±  2%      -0.0        0.20        perf-profile.children.cycles-pp.lru_gen_add_folio
>       0.21            -0.0        0.18        perf-profile.children.cycles-pp.lru_gen_del_folio
>       0.25 ±  2%      -0.0        0.22        perf-profile.children.cycles-pp.zap_present_ptes
>       0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.lock_vma_under_rcu
>       0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.__mod_node_page_state
>       0.13            -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.__perf_sw_event
>       0.06 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.___pte_offset_map
>       0.09 ±  5%      -0.0        0.08        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
>       0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.vma_merge_extend
>       0.11 ±  3%      -0.0        0.10        perf-profile.children.cycles-pp.__free_one_page
>       0.07            -0.0        0.06        perf-profile.children.cycles-pp.error_entry
>       0.06            -0.0        0.05        perf-profile.children.cycles-pp.__mod_zone_page_state
>       0.11            -0.0        0.10        perf-profile.children.cycles-pp.___perf_sw_event
>       0.10 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.sched_tick
>       0.21 ±  3%      +0.0        0.24 ±  5%  perf-profile.children.cycles-pp.update_process_times
>       0.22 ±  3%      +0.0        0.26 ±  7%  perf-profile.children.cycles-pp.tick_nohz_handler
>       0.30 ±  4%      +0.0        0.34 ±  6%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
>       0.29 ±  4%      +0.0        0.33 ±  6%  perf-profile.children.cycles-pp.hrtimer_interrupt
>       0.39 ±  2%      +0.0        0.43 ±  2%  perf-profile.children.cycles-pp.mremap
>       0.31 ±  4%      +0.0        0.36 ±  5%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
>       0.34 ±  3%      +0.0        0.39 ±  5%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
>       0.28 ±  3%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.__do_sys_mremap
>       0.28 ±  2%      +0.1        0.34 ±  3%  perf-profile.children.cycles-pp.do_mremap
>       0.11 ±  4%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.expand_vma
>       0.00            +0.1        0.08        perf-profile.children.cycles-pp.__vm_enough_memory
>       0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.vrm_calc_charge
>       0.04 ±141%      +0.1        0.13 ± 16%  perf-profile.children.cycles-pp.add_callchain_ip
>       0.04 ±142%      +0.1        0.14 ± 17%  perf-profile.children.cycles-pp.thread__resolve_callchain_sample
>       0.04 ±142%      +0.1        0.17 ± 15%  perf-profile.children.cycles-pp.__thread__resolve_callchain
>       0.04 ±142%      +0.1        0.18 ± 15%  perf-profile.children.cycles-pp.sample__for_each_callchain_node
>       0.05 ±141%      +0.1        0.18 ± 14%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
>       0.05 ±141%      +0.1        0.19 ± 14%  perf-profile.children.cycles-pp.perf_session__deliver_event
>       0.05 ±141%      +0.1        0.20 ± 14%  perf-profile.children.cycles-pp.__ordered_events__flush
>       0.05 ±141%      +0.1        0.20 ± 33%  perf-profile.children.cycles-pp.perf_session__process_events
>       0.05 ±141%      +0.1        0.20 ± 33%  perf-profile.children.cycles-pp.record__finish_output
>      88.59            +1.5       90.13        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
>      45.34 ±  2%      +7.2       52.54 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
>      44.15 ±  2%      +7.5       51.61 ±  2%  perf-profile.children.cycles-pp.do_sysinfo
>      44.33 ±  2%      +7.5       51.80 ±  2%  perf-profile.children.cycles-pp.sysinfo
>      44.28 ±  2%      +7.5       51.75 ±  2%  perf-profile.children.cycles-pp.__do_sys_sysinfo
>      40.25 ±  2%      +9.8       50.07 ±  2%  perf-profile.children.cycles-pp.si_swapinfo
>       0.55 ± 74%      -0.3        0.22 ±107%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
>       1.50 ±  4%      -0.3        1.17        perf-profile.self.cycles-pp._raw_spin_lock
>       1.18            -0.3        0.92        perf-profile.self.cycles-pp.clear_page_erms
>       2.01            -0.2        1.86 ±  3%  perf-profile.self.cycles-pp.stress_bigheap_child
>       0.55            -0.1        0.48        perf-profile.self.cycles-pp.sync_regs
>       0.48 ±  4%      -0.1        0.42 ±  2%  perf-profile.self.cycles-pp.native_irq_return_iret
>       0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.get_page_from_freelist
>       0.14 ±  8%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.do_anonymous_page
>       0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.rmqueue_bulk
>       0.14            -0.0        0.12        perf-profile.self.cycles-pp.lru_gen_del_folio
>       0.11 ±  3%      -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__handle_mm_fault
>       0.15 ±  2%      -0.0        0.13        perf-profile.self.cycles-pp.lru_gen_add_folio
>       0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.zap_present_ptes
>       0.12 ±  4%      -0.0        0.11        perf-profile.self.cycles-pp.__mod_node_page_state
>       0.07 ±  6%      -0.0        0.06        perf-profile.self.cycles-pp.lock_vma_under_rcu
>       0.10            -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__free_one_page
>       0.11 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.folios_put_refs
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp.___perf_sw_event
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp.do_user_addr_fault
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp.lru_add
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_walk
>       0.08            -0.0        0.07        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
>       0.06            -0.0        0.05        perf-profile.self.cycles-pp.handle_mm_fault
>       0.06            -0.0        0.05        perf-profile.self.cycles-pp.page_counter_uncharge
>       0.00            +0.1        0.08        perf-profile.self.cycles-pp.__vm_enough_memory
>      88.36            +1.5       89.85        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
Could you please test below patch and confirm if it solves regression:

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..118de1a8348c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3746,6 +3746,15 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	return nr_allocated;
 }
 
+static void
+__vm_area_cleanup(struct vm_struct *area)
+{
+	if (area->pages)
+		vfree(area->addr);
+	else
+		free_vm_area(area);
+}
+
 static LLIST_HEAD(pending_vm_area_cleanup);
 static void cleanup_vm_area_work(struct work_struct *work)
 {
@@ -3756,12 +3765,8 @@ static void cleanup_vm_area_work(struct work_struct *work)
 	if (!head)
 		return;
 
-	llist_for_each_entry_safe(area, tmp, head, llnode) {
-		if (!area->pages)
-			free_vm_area(area);
-		else
-			vfree(area->addr);
-	}
+	llist_for_each_entry_safe(area, tmp, head, llnode)
+		__vm_area_cleanup(area);
 }
 
 /*
@@ -3769,8 +3774,11 @@ static void cleanup_vm_area_work(struct work_struct *work)
  * of partially initialized vm_struct in error paths.
  */
 static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
-static void defer_vm_area_cleanup(struct vm_struct *area)
+static void vm_area_cleanup(struct vm_struct *area, bool can_block)
 {
+	if (can_block)
+		return __vm_area_cleanup(area);
+
 	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
 		schedule_work(&cleanup_vm_area);
 }
@@ -3915,7 +3923,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return area->addr;
 
 fail:
-	defer_vm_area_cleanup(area);
+	vm_area_cleanup(area, gfpflags_allow_blocking(gfp_mask));
 	return NULL;
 }
<snip>


--
Uladzislau Rezki

