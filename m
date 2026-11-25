Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F3E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZphkbqi
Received: by kanga.kvack.org (Postfix)
	id 153EB6B0A3A; Wed, 25 Nov 2026 09:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1038D6B0A3C; Wed, 25 Nov 2026 09:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C676B0A3D; Wed, 25 Nov 2026 09:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C42016B0A3A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:34:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FD4280ED2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:34:23 +0000 (UTC)
X-FDA: 85473886806.07.11DFA45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C951C0009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:34:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZphkbqi;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617261;
	b=5ZGonooA/CxwGMWK80slfAmM4ebFJ3uGU4fuS0y4a++B5YP5StZMDpUgcTQWKkK0TxPc1w
	/oTItwQbBVFDiuJu6Ivt6RUcnpAY//FbLIRJ+9TiA95bahXEmPh1aJKF2jLpVzhVzrkt4R
	Vy4/B1BznLwjzqvlXGjuoXjZs0iEw8o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDpwSW0SovqJTr4+b7sAFvQMCYEa/KOX5wGtNTlNmww=;
	b=d7fcbj92Up5akAJNaLs9zPjKM4YKhrrNM4c0NQRgySUOep9sMq1jrBrVdaGgCHlLGmzLWV
	wxA+sIGS4uX8RsX4+kigruoVaahGr00Lqi2K33GoVUjDZTxrdw/TGnzn7QBqT0WM9I2Z12
	7Opi/aInfoGDoKUiX5e/fNz7ugyEzfM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZphkbqi;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D7126022A;
	Wed, 25 Nov 2026 14:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B81F000C4;
	Wed, 25 Nov 2026 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617260;
	bh=TDpwSW0SovqJTr4+b7sAFvQMCYEa/KOX5wGtNTlNmww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QZphkbqiQviPmNnHK1XBwvI30DAEm0/8tLHArq5YTm0KtU7md/n0gWJtBiwvL2BKb
	 BIx1iUOCnI0AGiATutnE5AJQvvcG3/uaHG93wdAdJ+VAVRRUKEvVgrRMaYJJqDU9Ze
	 6C3Qsv2Pq2KVgIWICNnzxjPFYoAKF+X/RZKORPStr/q2+Ml3FR1PeEE/VnUdqK1xyo
	 BckPlgm+BtMRmdg7rIBa75A/xZhAl4PBJUApDNqz4DGNo7X7/IkesEszGoIogunx20
	 oO1VUoMIZ1HaEsykxT6wF4ipCZS/vICC7alvgV4/jNsUYQxxgcsPHAshXgz02Cpa8I
	 cgkn4n+H6CKzA==
Date: Wed, 25 Nov 2026 14:34:15 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, 
	David Hildenbrand <david@kernel.org>, Eliav Farber <farbere@amazon.com>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm/memory]  f8eca7ec1b:
 xfstests.generic.437.fail
Message-ID: <awbxo7VZyrECnFtj@gremlin>
References: <202611252134.37a9cb7e-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202611252134.37a9cb7e-lkp@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C951C0009
X-Rspam-User:
X-Stat-Signature: hqew7b8gqbmf5mkintaxgy75fkgfcy5d
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795617261-734299
X-HE-Meta: U2FsdGVkX1/7b1j0Owb5p6oeaSabGlK/f6H+KXKdY30xnEFeAce8ds0Zimpidw85tGncDM2nOF6IQClUMgEBr0469dInXPCIFF7EjPz7Qd+1Qjbc/nVFRppWZF+shcT8OTXF9GYojTtxnDAV+9/BTCkcZ8EGr3wtRUBzzJadkU7dh1b2ZfnBtWBooqCpb81dmrthycB54yszoDWfSnuknDrZyaEURL69aKsL7JrhSHWtBKN3+Ff/T1QQ+CIuNLQe41UAmLHgkpK79Y/3G3ibKN7qEpGQx3NCkfdeqIUwN07RL+l4pBmJ59hEpT5WNCBs49H8X0NBzQApIJZDHLziEND+tzObCjc1jkuRMfB7dGcLyZe3Rp0hJZDAg1JTJmFn3iHS7GfsgDMSAcvawzYSgUqLbD+JvSbmAddB/Fh9q02ZyCNNLK3DyC+s7IHGH/hbxYZT5ZHk4QKpb2J30tI9pQ+0SqJ7H4GwZzsiv8gen0kqv1YKhcVALkjfdKmoiTLL59S0KWZvrRaGJJTHqw6fY8VT3E7nv3fko+MlKjb59cTahG+z+1F7pB1Y0nH1kOdVEzdE+SyxtRAZqK998dFyIF/Pxc+tb0nRwlwdkBrdPZOCam9kcE+ZJzTOitYJZmSE/f8bl5OnewI5Wj80xr/SmHqcxW+Loy9agd2CukWg4OBoBi40VXVi41ishq3nLd4fuo40vuUWNQ1WaYCHktLhznmElg7ZJBPsQYuyb02aG0zbUnoQaQGpvxBinex9qdy7NvSlViK29AJSLL+GOyusbz72n1fLO2oiLdtdlZmWCIR42ShUY3BbbWBzAHofbGCTZWDvW6Sh4lVunYsUQVTljI88DySZOg3M0/5hQMSn3WqKcSEYwM4RCIMtMyYb0/Y5jd3cNr+xzBBnL4i1jVcpQwLuhOEQy1BRem9dc40pDX/YkdMSEWE6Fa2OBt2AdvsH+80GidR7ENqUkcEO6he
 nHaZ+dgG
 z0fNlRnuJ0B+ektHyWfupM/NHbH8kB1ORoIWmWlWOU8+Wv/wGEqT2X2lMe8Qlo0Mxlskj8CESo22xy4R2DC3GIyzczurat3QuJWHwlZeKTJ7+LofRbbwYh2Pm5CV4oaU4VtndsMWQFGgr/L+m8leify35zE2nmWRhf5cQngwmpr9kK9oxdKsIrlJk4yqBkR8kRVDapk1Un2tfABgi87qhiRqzoQcSH8GR1V4sIfDOaONY5nBLFQl3zybhbufF/Yen2RAdxR1tPB5ISYhqmmRoBltBy7w8XYMyBTRfr8tcd+xq0/ZTsbNnJA53czbc5qO7DBd/mmgmICPrk0Oxik1q1OhKkvBmUATubSqRNKMzLMW/biGKPDyIgedFCyExH6OerEdrBUGeVaWo685dj7ptmpC+EDGUgPaIyw0ACCbCy9JngeKzo8AyR1rFhVvdxKYeVS1cZa5MbaYKEaPcMTtI7mpGHhyvxjfnFS/cv0jdpdkEzVcEUDeDnpzgV1s7qad3SkaEs3EF9t6bzEX9BpNJubexCIKk/avEb8pwhWtNlzZKwsZji9UQp/gFxYkuJh4aIPPdkEp35zYVmdfHZFUFAmTcL1QeLKkp5reh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 09:47:05PM +0800, kernel test robot wrote:
>
>
> Hello,
>
> kernel test robot noticed "xfstests.generic.437.fail" on:
>
> commit: f8eca7ec1b368557613cc727abadc82546c1f46a ("mm/memory: do not report OOM if insert_pfn() races a huge fault") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>
> [test failed on linux-next/master 3dd8c790a7b7027abdd568e36db5e82ffaea7c77]
>
> in testcase: xfstests
> version: xfstests-x86_64-d07dca72-1_20261110
> with following parameters:
>
> 	bp1_memmap: 4G!8G
> 	bp2_memmap: 4G!10G
> 	bp3_memmap: 4G!16G
> 	bp4_memmap: 4G!22G
> 	nr_pmem: 4
> 	fs: ext4
> 	test: generic-dax

Ack let me fix this, I need to have this return -EBUSY not -EFAULT, meant to do
this sooner but got so tied up with other fixes ugh.

>
>
> config: x86_64-rhel-9.4-func
> compiler: gcc-14
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202611252134.37a9cb7e-lkp@intel.com
>
>
> 2026-11-25 00:16:54 cd /lkp/benchmarks/xfstests
> 2026-11-25 00:16:54 export TEST_DIR=/fs/pmem0
> 2026-11-25 00:16:54 export TEST_DEV=/dev/pmem0
> 2026-11-25 00:16:54 export FSTYP=ext4
> 2026-11-25 00:16:54 export SCRATCH_MNT=/fs/scratch
> 2026-11-25 00:16:54 mkdir /fs/scratch -p
> 2026-11-25 00:16:54 export SCRATCH_DEV=/dev/pmem3
> 2026-11-25 00:16:54 export LOGWRITES_DEV=/dev/pmem1
> 2026-11-25 00:16:54 export LOGWRITES_DEV=/dev/pmem1
> 2026-11-25 00:16:54 export MOUNT_OPTIONS="-o dax"
> 2026-11-25 00:16:54 sed "s:^:generic/:" /lkp/benchmarks/xfstests/tests/generic-dax
> 2026-11-25 00:16:54 ./check -E tests/exclude/ext4 generic/413 generic/428 generic/437 generic/452 generic/462 generic/470 generic/503 generic/605 generic/606 generic/607 generic/608
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 lkp-skl-d01 7.4.0-rc3+ #1 SMP PREEMPT Wed Nov 25 07:55:29 CST 2026
> MKFS_OPTIONS  -- -F /dev/pmem3
> MOUNT_OPTIONS -- -o dax /dev/pmem3 /fs/scratch
>
> generic/413         4s
> generic/428         1s
> generic/437        - output mismatch (see /lkp/benchmarks/xfstests/results//generic/437.out.bad)
>     --- /lkp/benchmarks/xfstests/tests/generic/437.out	2026-11-10 14:32:16.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//generic/437.out.bad	2026-11-25 00:17:00.840164485 +0000
>     @@ -1,2 +1,3 @@
>      QA output created by 437
>     +/lkp/benchmarks/xfstests/tests/generic/437: line 22:  5709 Bus error               $here/src/t_mmap_cow_race $TEST_DIR/testfile
>      Silence is golden
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/437.out /lkp/benchmarks/xfstests/results//generic/437.out.bad'  to see the entire diff)
> generic/452         1s
> generic/462         1s
> generic/470        [not run] xfs_io log_writes  support is missing
> generic/503         5s
> generic/605         5s
> generic/606         1s
> generic/607         3s
> generic/608         1s
> Ran: generic/413 generic/428 generic/437 generic/452 generic/462 generic/470 generic/503 generic/605 generic/606 generic/607 generic/608 Not run: generic/470
> Failures: generic/437
> Failed 1 of 11 tests
>
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20261125/202611252134.37a9cb7e-lkp@intel.com
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>

--
Cheers, Lorenzo

