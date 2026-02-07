Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DF2EE6B7F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC346B0089; Sat,  7 Feb 2026 03:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389B96B0092; Sat,  7 Feb 2026 03:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E5E6B0093; Sat,  7 Feb 2026 03:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11A016B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:12:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD1C689C68
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:25 +0000 (UTC)
X-FDA: 84416943450.17.1246036
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8E5840002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI1pGetP;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770451944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
	b=izocM6O7lHFkDQbxZ6IVwPFZn3Owls9ZJsJUpOoGMEarzvOQtcy86XOdT4SQI2aJAn5mQX
	ymASUdVCU0y6S1nzKbJWMxVAaVhOPxQC+WiJNF+PcKNQINLh16LBog6jHKG2JrtM9mLUDQ
	/vyJUZb9hf4oNJgy57Xce8bhjW66Aqk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WI1pGetP;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770451944; a=rsa-sha256;
	cv=none;
	b=wRi+nvSfCD6Dcd9JBx7GqKSI/eIkK3KC2aB/mUcEby/G5tECZXnDZ1R2tyIGmKxFvRvU8E
	dhMCuIqUgLk5NCjAnRdYfoOm3ffXX17WSERBgEK0YYGCi+lJ1x+qsJoZxFUVBC5ucNybw/
	oEk1miCsUhcwq7c8pB0/x7Qn7Y0votE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82458495219so96258b3a.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770451943; x=1771056743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
        b=WI1pGetPxAMi3RdyqXEMApx98a2B9HKXM+S1Gu4z+wwxmdg/T73Tr1AbjY3menwIlW
         KXbO8qSWPk3XnWP/tw6ZlHbeUoeBa5WswjiiqXCe1Ef/K8nKGFD3izJRxGkmjJri2Zey
         PtqrTsBBET4k56F5KRFbuJKmtIxrE51huiHCJ3H+NCSlJRUuJ1nVuRXJngxpEImaqZyt
         MCDpucongRdQcCr/11OBFe0IDs5fXMNaO5TurBjP7HJ4YLgYBk6A7DkjfTHEUc9jzDcz
         c4NuWc6NylHww1ojO/fl5/rue2diX7mPe3ouALHvtAs+kdvkUs6UAHxF+AqvFnHQpeO0
         dRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770451943; x=1771056743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av016yHVQTZQvLAEB6lorvBQy4JiwiUlhJeSthydisA=;
        b=TIZ+L7G/wNW5LbKpJm6c8uXYux6ufrX3Ium1vtlS6wgAjB6IADh4AWd2niBNh7ZIet
         00mT4THWctawaCUxedvg5dsqJQ733+6/K8rfYD3byVkk6ggaYuAuC1krkrk/MNfN1AX4
         oWTIYUFHtkGkDPAhwLJszkSP76R5VzZd0PFHgmjn/6ly6gLP/7+6CiX0dkNm0Gl6OrQQ
         XzI+NTNY9iJg+gx2laDLqXVLecZ3SLs3vILRwJLhaLk8UbYB9Che3fR78Gzv47wcwoYP
         nPndWUQQtxvyy99Y9aQpEWdUatlJnQeQ0lB6h2CTcnmIMNt1T9PdwrSGW/cE/+lBFP6E
         J+vw==
X-Forwarded-Encrypted: i=1; AJvYcCXx5F5IvcOqDsc0N9P5FeuPu8dWKYt4llQHPKiH7jiz3YyuCOOINjkHjxckjlWocob9PHreefjVIQ==@kvack.org
X-Gm-Message-State: AOJu0YyRCCUIb63HOHLTPsEN2f22RgzrM+XOWlDMKiTj3O2ummBaF7+y
	47ewayw5vyviQ05FcCH/UNLl8TUHEk/5TbKcAzxuF4BPSFKzqvSywpoy
X-Gm-Gg: AZuq6aLagaSenA0MCf0jKtU2sFS6cXe1JltsUQ5ZlX9pKYiX7tFIZBVqbTq8UHTIA9w
	jKgPufOwLA6TD6xONp7bxpBYFDIKvbBlYbAvjZv0AJGa1Ai7BhkEbi2lkro1y87lYEaFV/eDyO+
	xnBBR0Fkl0NS5LfUBhzaY/r8o3bih7wBOtmd1MndViBDVqDEukTBpMN5551v3nR1f4r7qMTezzl
	GuzDBgDdRN5ZXBEdFl9A+QOz9i03HOwYExmSTCwWOPsJgD+3csjfCqNL+EM19HxDAuq78TjLF0g
	E9sneaiWBHrNc3EvKmXdsU5aUpTURFB7YLEBdzxJ72G4skkACBon8QETPaI5k/S9NVS2EHs+S4v
	7StitdiQEPolXReSsHZyEAzlicDHQ85nnN2fVT+ile1hkH+qwpdrlI3tDeCJVmaEfozSMbv4mtm
	Pz5Lh0tnRWLdzXpzLiQCLBg6LLdsef5yP1wg==
X-Received: by 2002:a05:6a00:a885:b0:81f:9907:e503 with SMTP id d2e1a72fcca58-82441622de5mr4634623b3a.16.1770451942562;
        Sat, 07 Feb 2026 00:12:22 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm3951466b3a.16.2026.02.07.00.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:12:21 -0800 (PST)
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
Date: Sat,  7 Feb 2026 16:11:39 +0800
Message-ID: <20260207081144.588545-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 91p4dq5rw6iczfatgg4bjit6kaarwkwn
X-Rspam-User: 
X-Rspamd-Queue-Id: E8E5840002
X-HE-Tag: 1770451943-707022
X-HE-Meta: U2FsdGVkX1+htX2TARwf5mfWo6+LoDhNeCNDilSfTmYwM9YHvF5XTFWgsbS+8rCTwkbSIvZ0nxB/ZDM2ktBlCIiDXG5UtrdmaJudroM6MCSBe90Kemw6xXucLIWJiMl0NnjXvCmSdtOR4NyMlSqMSiVzBzguTBdxvHfEt6WzZyi7Da4hJZMed9Yx2W7t/1h6bgMAREguqPZVOEJAdevJLz8lDT9zcrz4FsUBKzlQgst1sLbIGZs4iRj7s3PtOr2QxJXAD5dijwjRHdu5StVmio6ODUgo0ijXCgA7ewCyqgxfAnkUzLzjWAOPbCw6kP+HolAlSQXttVn1OX5ewGkHp+znxmnNVUZ57AmEihM1MO4Z/NB/GlJxSkV/uhCweeRsCfn1gWFuAinkf4ezfqvyXXoGS2gCCg9uurhrG0tfSMSBI/odlnVRCe//V6YQ7joZQ1JAFrh9x+gm2O2iW9QsZ63OWhWXggwtXFXWbnoOCvwummB9AAe/vzkZ5Smu5yOLrA6lG4Xbul2k7N+fs8vi3ZFtJFEh5/Y3DdUk5kNNIv6AvnR9IqSOVCPSee4DpE31wfa/+Y7Y8K9F/MdTpnRIL6to6C/BHK2QUOuLWPoB++cqGby6yu11SZsw7FOyd3GmWPFCBqrRBAROdAU5CD//QibqLLuQJwtpBjSqRIjNHEu7Yt4Bw1LaNZvzAR6xYtvtr9oiBKNtIUy43ZgM/E7boAAEL/kWEQIA9o4ZPccnv6AXBJB6pbo6RSShBIN/64fasuDtK6enezD+I4xgttGeiitetwp44j/8dWyRJ7+BJY1E50TTbxE9v7HQl4Hy7OFrKh83loa+BrjnB86GyB0ACE0oTsPBit+lBD8bcq9KALRMoCyHB+TDaxWijZUFNz+oWuXnMHSVbojbu9mR8OFeLBPY/gzUADHCfGrg+JV4ugVGidtudiJYuW6DxUOEQMm7HqtLrG5/q4NQ9JDdQZx
 2Hsdj7aY
 WtqDb3HcI5DhFi6lFMzwD6bkCHSjFY7xAu416RUjTy/IRrWtB+RBx7EXRi9ALOc9nEDFuG+py/NRLf0mBy9b7A7R6BF7aXLqK62TpxImKIPG0pL2hDaRChENRixYBJ7JpZnNlIDzFNN7Xfe/qsNAb70fCtaMPn3o10gHc8fbmuNjh8fblnPGcXxZE3itT9VCZysVKW4EydVh3r9XSUM7SEwiwOhkMB2dpTKWoAg6i6RvMPABrwZ78K8bo+ZbpqpGQtzNlYesRhwNXdB+PKCf5cSsdBn8M0nBTJSFP1OZnUkq+pN6U8Ht7lihLJu//It9P+o927mI7jiqpPwECKZCQWayoZnSVjL4/MuCgwX16UShe4G41mCKqlrjW+YLsO48LKpXXVvOy0KJisljNJV10iiadJWNnnLzm+PQaucu/qkeTFmuC5RWAReHcpQVLRAyofAx08H4QT9f5oJg5WHXUw3SDsfO9eMOuUrWj6LLceF78bD5JF0wg+jOlNFRA4nKT6jFhF+yfC3YffpMI5G4Hu44LkOQ8V6dXs1BjP5E8v7UfVb81HptoUgvmTYmWnuFKsVRBr18kjklDMbzXg6raPUwfG5xZnTNJrCAPwUoY+1XITyHWnOc8upNrGlNGRq7Ut95z9jlfMuT7LrnsWVnBunyvfUGnI5hkBDHi4k1wOfKAR7NsmeXWCzExwPpnLWqyz4dwoFMSUjq9JbI=
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


