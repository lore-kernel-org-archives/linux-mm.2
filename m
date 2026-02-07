Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC96EE6B76
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B8B6B0089; Sat,  7 Feb 2026 03:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72D66B0098; Sat,  7 Feb 2026 03:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74DA6B0099; Sat,  7 Feb 2026 03:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A76686B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:16:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FE9FC1AC7
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:34 +0000 (UTC)
X-FDA: 84416953908.17.C8CD20A
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 973FE4000D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="chSW/3Cx";
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
	b=18VG/QZfzJOsXYpWgNhBJjkH2I3qIwYYAKCp0WhtS09F+LfWx9Pctj56r9/RiHpW5u+pyh
	Owuak2vWoPztXdPiDGhH/ljlvuMxjseqOXFp2myDdsJM6VPu/DtZCfeJn8soSn82B609Uo
	02kWIVsq28aoabNp51msQxPHXmnfIZc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="chSW/3Cx";
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452192; a=rsa-sha256;
	cv=none;
	b=d2S91Yv0tW6/flUs10V6RCrfuNrIuNqAPK/EgxlyMkCiq4XlGsgKVFKVNgwfHt5VhCMnn9
	KYXAHKd5CjG0NEtAvS5WMHBAXEbwhsbQe7CoEaKryG3qHwx5U/pNLJPJ5OS1duR5xe6kbz
	zhQBPt0jy86NSOX2SkvwUR++/fqLCvw=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35621aa8c7fso41286a91.2
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452191; x=1771056991; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
        b=chSW/3Cx2qCzutRl4yUT2ZC2ZU4oX6tlrXXpQJbgN7Gyc0wrVFTHjBa2o5VWqqgE/5
         QERBCdnBdhjqHc2KPMdBwqrjWXHx0qDcF1OiDLNKVZ+SvDLyyHx6/siWOMYeUY85b32r
         jPGFPS+Eb15OmJZu60bbOs339MQDbqbUAID88MsJZhBzXzNy9ZEbJmioNlDpE4Sn0t5B
         4c2YjgQrRycAeI1eqLnnvq55TxwMEUCe/6k/0x7UbsNABJMcCaQbCT9DKgqF/y9v9/gm
         AcixuOt3PUaPv1fAjkreBFeHeb5kwzbfmooE1u1cCUzaKENT3eUKPqVhvsDratAxgEt9
         ovSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452191; x=1771056991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
        b=lSHxXH99dcH8SlctWRGMTZ0VtQs+QCkAIAz6ykqdhsaCAtDgS1vLoI+Zcx735MxBHU
         5WOhfiwXvkKrEWuwupctYxxKJXR8C68o3PG1UCzwct8xht1/Q9e5qW26+vFg8LjH7/Z7
         4ZwQXwXNkaCcVepgr6sDSbgSZJNpghGtN+b+daE7mQq8153kvuGs6piM1rwmYfhCh5br
         DXVfKufWZORiMxnb+CR5fOx/ra7RMpn7jRQUULqJWg3fS4VmLuAgNvcyrIq5aB6wGCWw
         fzihH8hfgci4J7SiaTCW/4q52noO5/L0GX0Re6wPVRmrMH3Zv8gipREqE6zFHdZKyLlo
         +8xA==
X-Forwarded-Encrypted: i=1; AJvYcCVv6riSXq6bCzDBG/FdajXut7PdonNav1tICwXr5rJF5YrpAfukQz6IDDh00Hbs4lnP/t5GuQ8ChA==@kvack.org
X-Gm-Message-State: AOJu0YzlKoJhKb1HOPmeA1HP5mqn0wxQmM1oIwjAhuZ0ZonpfVg1EjP3
	4KV70JrNUXM8GLzf6lo2MFbxFPC+MV1kgbKx3g6AE6XucvMHtEKefpEo
X-Gm-Gg: AZuq6aK3Sx+AG5eNg4AjRmwAXWbotnUJjXE+a+FUx65cUO3dcNtxKKL00q6kKnrmFfE
	cf/Dh52E2taD1cQd4SbtbTlIn+7zLVu/RsxNdPqBpgyTd6A0/l0BCVsOKo/1rH036CMDbGVOMj4
	D3jwUQqlz3taetjBwhPPdnHrv1YZQhnYmz94XKflygmEzjBFlMOZX/TCc4pyB9kz88Egq4wzgXx
	K6/T/akVpqQbukCLcI9rPdfXnWADG3AuoW/7ip2RFYbhNxlIsPdpCaqj3zaJE2hcw7VQ+HqSlr6
	re6LIJNnE2NMRopki+rrET5OSvuPoVnmUD+S04Wh8DX8yH0/3SKTFoyTDH7OYAG11no1ze2f2Y5
	Os/+JmB5ME7P+37PBxtv/C1Skh/047XYfBxQe66Qzw4fJv7NTUqzf+4hbROFKBCRbGcMmYPdTOt
	+YjJV+SK2pxlJfJPi6Fka5VV0=
X-Received: by 2002:a17:90b:38ce:b0:340:25f0:a9b with SMTP id 98e67ed59e1d1-354b3e6441dmr4597928a91.33.1770452191364;
        Sat, 07 Feb 2026 00:16:31 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:16:30 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v7 0/5] Improve khugepaged scan logic
Date: Sat,  7 Feb 2026 16:16:08 +0800
Message-ID: <20260207081613.588598-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 91p4dq5rw6iczfatgg4bjit6kaarwkwn
X-Rspamd-Queue-Id: 973FE4000D
X-Rspam-User: 
X-HE-Tag: 1770452192-512229
X-HE-Meta: U2FsdGVkX18BNEAUuSGRGaqD0Q1YTrL3jf1FlZ3zQIT5ktyGejzCdAOzNdnyZTIdBMeXUK8B93h5/u0ML8ED2I9A2HoHf2JsjWIL7Cz3Z1whbggBMZmPIsVQC6nT0NU1UIz6XgxUSbh2B59UHzCqGxy3nU/ZLgINzkWSPvgyeQxAKJ+0OMdME1L1NLgLFO5NpvkxR4y+zWDki2yrdCznVzB/q3cLFS42BO765yQaM3A8ACLG+6xasB6IYmfCy0SO09xLJj7paO7W6AdgaKQTOCnEpj6XI6Jkk5W1EZPbHLf0MLIEsE397SS52AUqBVWSpYxvGvTKPcjPyUMnHc6o1JxSDoVUoL+v9DrEIX+oEFVDIZjz1fAD5ua/JurOTuRtNnquK2Sze9JY8/Zu1bRD6skZnBovTWMRKN3NzAj/boxaDMyeRq2722HaN/zfrUGyxWW65xXd71rWPt04sN3Zdu5a6j3BClvjmHY4CvXfDW+2UWPBoZAblKZglOAvlJUF0RRsqc4G/OBeEJTcBVxdvO/wVtZwyngnOwvs6uPfZSXGZ7PYeVPguLoqHqU/N7AAUTzugcr+YwWJVlr1nTEgW9Z3wWP4qJL6Kfz7c0tohdvXe4cX1MNcQGytxaQhjRj67G9SnRI7uRZ6QpnIIzXmafA8xWKbomqB9vFCYyE5MJYcPObVWgJitoKLQjIyOQ5loOlSZnMGLQWszwKxVNe9PxsWTX6Y2YiTSj6BAfmKN9EOTxsD4D+f2K7ugVEdCyxcJTqUMF+95bO/g276zyGO0IiGzo+k6y+1v7aXMRrJ6CBXBjnnDgX5lG2IbxH8QQCDg1aIThZWuFahBwgrAot7vl6yEyc3T+TlxK3tWjZqBWTQ49jWeqm7XrcA7BzEdOPFi2d9lk/n4dAIl/dJsNqV4yFEROE42xt1xhQJ3SlGO/Og/rR+VLmdVymUtk1/CR1THmk3BSiW3NwK6hBxtK9
 kZXlhAng
 ztZuRUHI3QlJfNPyEwgWWeQZqXZiZq+xT6jEVuFknGeVOgn0cZQmmgS0WO1X9NlfbOSWkmKvovR/3GDEfcWPWWXnlsfzg6WU3jSbgFj+aDMepKkfy8XYWapdI1fY21ambCRfj/SOLDFroKV2H4ZWW266+F3G4ieLpjEZAmLE0Ps5CvQDBuL02PLaIaN6jH1ZyLfTvZT58MAwEA/ot0UdwjPPm4fzRBw6wZMOkHSY8IgdSg9+ySOI9mta4HTFnt2b1mt0HNnUiGm6T1INlZq14PhnnbryaQwlUMR7BWYV49wuhzdJNqM01xOrXFcZiS7t/JL4IUAXH77/elAfvKBFeqZJv5scE5mY+RYwd+rfr+pGMaHekBRBl7jLATsZYggpi3Y+6hAodNgIz3h7HYIjdjvIK62AVVwWRK4MmS40dCRGJ8M+ARSfIuHUWe4b6ZCZBpM5R4qLmAK3pM5cy3GtLebm0O0pvQqiwaiCE4RuklzMn7y9d7lTivUaOrKUaKj44u9fkXfIuFHIF0d6IY5CAkh9qAUUhwaUJKC9LtnbAHWKnQhMowDkl5Li+spm3zeXAkoP8iv5oiwUczBvsK0NGRtZ7MC7/EZ+CPnS7oX7iO3tpvV0jIFgkcdUogynXq/uTJ8X6SkojIre5kco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Hi all,

This series is improve the khugepaged scan logic, reduce CPU consumption,
prioritize scanning task that access memory frequently.

The following data is traced by bpftrace[1] on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan by
khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
@scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
@scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
total progress size: 674 MB
Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged has below phenomenon: the khugepaged list is scanned in a
FIFO manner, as long as the task is not destroyed,
1. the task no longer has memory that can be collapsed into hugepage,
   continues scan it always.
2. the task at the front of the khugepaged scan list is cold, they are
   still scanned first.
3. everyone scan at intervals of khugepaged_scan_sleep_millisecs
   (default 10s). If we always scan the above two cases first, the valid
   scan will have to wait for a long time.

For the first case, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it.

For the second case, if the user has explicitly informed us via
MADV_FREE that these folios will be freed, just skip it only.

The below is some performance test results.

kernbench results (testing on x86_64 machine):

                     baseline w/o patches   test w/ patches
Amean     user-32    18522.51 (   0.00%)    18333.64 *   1.02%*
Amean     syst-32     1137.96 (   0.00%)     1113.79 *   2.12%*
Amean     elsp-32      666.04 (   0.00%)      659.44 *   0.99%*
BAmean-95 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-95 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-95 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)
BAmean-99 user-32    18520.01 (   0.00%)    18323.57 (   1.06%)
BAmean-99 syst-32     1137.68 (   0.00%)     1110.50 (   2.39%)
BAmean-99 elsp-32      665.92 (   0.00%)      659.06 (   1.03%)

Create three task[2]: hot1 -> cold -> hot2. After all three task are
created, each allocate memory 128MB. the hot1/hot2 task continuously
access 128 MB memory, while the cold task only accesses its memory
briefly andthen call madvise(MADV_FREE). Here are the performance test
results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

This series is based on mm-new.

Thank you very much for your comments and discussions.


V6 -> V7:
- Use "*cur_progress += 1" at the beginning of the loop in anon case.
- Always "cur_progress" equal to HPAGE_PMD_NR in file case.
- Some cleaning, and pickup Acked-by and Reviewed-by.

V5 -> V6:
- Simplify hpage_collapse_scan_file() [3] and hpage_collapse_scan_pmd().
- Skip lazy-free folios in the khugepaged only [4].
- pickup Reviewed-by.

V4 -> V5:
- Patch #3 are squashed to Patch #2
- File patch utilize "xas->xa_index" to fix issue.
- folio_is_lazyfree() to folio_test_lazyfree()
- Just skip lazyfree folio simply.
- Again test kernbench in the performance mode to improve stability.
- pickup Acked-by and Reviewed-by.

V3 -> V4:
- Rebase on mm-new.
- Make Patch #2 cleaner
- Fix the lazyfree folio continue to be collapsed when skipped ahead.

V2 -> V3:
- Refine scan progress number, add folio_is_lazyfree helper
- Fix warnings at SCAN_PTE_MAPPED_HUGEPAGE.
- For MADV_FREE, we will skip the lazy-free folios instead.
- For MADV_COLD, remove it.
- Used hpage_collapse_test_exit_or_disable() instead of vma = NULL.
- pickup Reviewed-by.

V1 -> V2:
- Rename full to full_scan_finished, pickup Acked-by.
- Just skip SCAN_PMD_MAPPED/NO_PTE_TABLE memory, not remove mm.
- Set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE to just skip, not move mm.
- Again test performance at the v6.19-rc2.

V6 : https://lore.kernel.org/linux-mm/20260201122554.1470071-1-vernon2gm@gmail.com
V5 : https://lore.kernel.org/linux-mm/20260123082232.16413-1-vernon2gm@gmail.com
V4 : https://lore.kernel.org/linux-mm/20260111121909.8410-1-yanglincheng@kylinos.cn
V3 : https://lore.kernel.org/linux-mm/20260104054112.4541-1-yanglincheng@kylinos.cn
V2 : https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn
V1 : https://lore.kernel.org/linux-mm/20251215090419.174418-1-yanglincheng@kylinos.cn

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c
[3] https://lore.kernel.org/linux-mm/4c35391e-a944-4e62-9103-4a1c4961f62a@arm.com
[4] https://lore.kernel.org/linux-mm/CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com

Vernon Yang (5):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: refine scan progress number
  mm: add folio_test_lazyfree helper
  mm: khugepaged: skip lazy-free folios
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/linux/page-flags.h         |  5 +++
 include/trace/events/huge_memory.h | 26 ++++++++++++++
 mm/khugepaged.c                    | 57 +++++++++++++++++++++++-------
 mm/rmap.c                          |  2 +-
 mm/vmscan.c                        |  5 ++-
 5 files changed, 79 insertions(+), 16 deletions(-)


base-commit: a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5
--
2.51.0


