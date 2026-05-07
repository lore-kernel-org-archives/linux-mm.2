Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591EFCD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 07:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E416B0088; Thu,  7 May 2026 03:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEF36B008A; Thu,  7 May 2026 03:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADE56B008C; Thu,  7 May 2026 03:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1CB6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:06:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1412DC19D0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:09 +0000 (UTC)
X-FDA: 84739739658.02.0D9DBE0
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 472A2A000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YkWqRsq+;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778137567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZpxYnGiHGEuaf9nPrBPtOYorQFvh157G8iKvHie2maQ=;
	b=0roIBQeYaO9LS7H5usVYu8Fp7j6AV0dGSY+j1Gt24d7Ef4O0IomSdQ08yPRr4BlBkjUBYY
	EGoy4VusMMbwkAMwFt2ROuUvUbo32niCkHRihO2Z3if0pW0ZvR5rVkIBs3tTwLIg+nFkJe
	GYC7cajOgwbs75FXat1D20R+ms5nQT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778137567; a=rsa-sha256;
	cv=none;
	b=tNinDm6hg3B/qwZptRR+xE2xppgMPPamDJvLY6GepEGeTA4h9pBTWq6vf9qTPBq4M3qxKN
	wZi7sn0W9tD2VzUVV4lBmo5/rTjMOrWrVsNKAc2aHyRN6xkD2ZgXpo4miIx6YuBy9ZL7Wa
	HyfVsKk3gTBHzjwDKxRTzk+aVcZiTaM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YkWqRsq+;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c7ffe8eeaf2so208494a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 00:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778137566; x=1778742366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpxYnGiHGEuaf9nPrBPtOYorQFvh157G8iKvHie2maQ=;
        b=YkWqRsq+yWsZkaU3e8WIaw1qkZAb07z66BaUjIHXCQNRo8EKG8CjCx/KyJ9u+DzhJF
         FDa6ggzT733q7Uv86qhdpc0ES53vbt7nRz+eCZLqC39rJ++rHNKlgMRo9Fay7NqHrv7n
         MLuU9EuAjUJVnpgMQOXUhnkmz7Z+AX6v7Xypcst0RdqyfCkRU0B3SEcsQwkY/xBl0UUH
         YW870xTtLlw+OG60GyOKmhKHFhghe4M58v4JDB7TlRj7UfYNOdbQ29jyVu6KA0pXX+Mc
         wnP02NVCp/cwPTCijTYxU6Wu+bGXwEM41Bs0+a12KsxyqwF72q+5/vFFpbOXh/MwKN6I
         ILQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778137566; x=1778742366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZpxYnGiHGEuaf9nPrBPtOYorQFvh157G8iKvHie2maQ=;
        b=Npha3JU3teKRqTcFACGhiMwDxOgqFQFDk5zEhvvutm9FjKudWBU2+SZgVAptlINYF5
         fD7dJXdqPlSyISPlywFm23KXBnowsucxXIEBVrcHdkf7mgeVSP3h53yb7w8hVeh0kqGM
         esS6aTUSQ7LM7sKuiUHAV91upPAt/AkQU0wfeSWDDNyYR6wIRcQAaqT+q03fwZ3wo0Qx
         OU1miu+jakIZZiHlcF21d/we6LRj3ZnPi33ij+iKkomWuBkMyVhk39PRZ22mMPDXcEev
         NP639kcCMyGj6stsM2btvwxw9smJZ2bBLowiAgHhMr3DuREEpjLggFIuoRhBUbKMmM0L
         yHaw==
X-Forwarded-Encrypted: i=1; AFNElJ+OrkO0yKAegYh6sGF5KDDtXLCQ89fvOj/+3g5tP9mya3JBJnq7QxReII8TP5O37/idFk+gAk9x+w==@kvack.org
X-Gm-Message-State: AOJu0YwIe0EhVFiuWY23Qh9+KGB109aF/nScCE5wEKmdn3otGKZiX08/
	lUwl3uKr/lRZ/Cchvf9VNrUTSK4ecpHQBfsEWwWZ8/d16Hz5nE4ra8MK
X-Gm-Gg: AeBDietYcYRfAc3g0B7DzkPKYkDC0Dsuw9vK0tEMIypVt/Xyrd0+NsYo/T1g4u85wPT
	F4rGwNDvJKD8FFYr5ljaeKaUKoAf88Tzs94G444yaEhQNlEq2vZi7HukGOW6P/FQS61W1EyZEaI
	2ZlW6yIQb26LmVV2p53StnTUGjiJR020L6XqypmXu2eh1wF71R+nVqWIiUgI/LL0BnRPCZn/Vjp
	M4LTrlOjM2Xr9pyI9sQm6Ry00gt3xOT8oK8jUqfFo1n4xFp9UNy7iNdZPx8WfpTMrDmbhyDjXkp
	xgLKku1+TbI2weCxfm0hoM4fLCKJtvEUsk9Ha/sZ7XSL6F2bCW2nsiDMkUFxGHlU2PEMRAtYZnS
	+5KPHA/3mO0T8syYZWowEVczzzGGHTkSUMA1GNa6rNLd3B4KLIW+P/jDSsrRYVDgigNl3HfO87C
	8zq5MA/oh42wUbMj1SWQp3R1uheqsTU1VEtEiCC7PPVWGs9ZFf
X-Received: by 2002:a05:6a21:99a9:b0:39b:dea7:5626 with SMTP id adf61e73a8af0-3aa5ab7170amr7433224637.35.1778137566009;
        Thu, 07 May 2026 00:06:06 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c825379099bsm1200164a12.14.2026.05.07.00.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 00:06:05 -0700 (PDT)
From: Chen Wandun <chenwandun1@gmail.com>
X-Google-Original-From: Chen Wandun <chenwandun@lixiang.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org,
	zokeefe@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/2] mm/khugepaged: fix sub-PMD MADV_COLLAPSE range handling
Date: Thu,  7 May 2026 15:05:56 +0800
Message-ID: <20260507070558.3064142-1-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 472A2A000D
X-Rspam-User: 
X-Stat-Signature: 445k1gzfjo4q79r51fdcdn7cs7ue9nre
X-HE-Tag: 1778137567-697363
X-HE-Meta: U2FsdGVkX18fSZswOWFbWQqIkEnxcjKske1BWr+pLpWCW9Z7xN9jzfPiqUphigyXEnMDpyF/qjfSOpV+tZZNF5+XZ0Eg3BtJxNX2sdp9Pz2LQCcbETk0VnjNyjT8jxGehzYTCppck++8hvAAKVLj7vH7x7WTHyOz2BDV5r00aWSzVMWnLs6jHCti6Za7OZ7CREMdP9lWGi4AwB6VVzUX1uN6S2sAawnoGrnaO+zX30qt9bxD9e4zUXXwy6s2MCduF4VnwkEDgN5hv17t+6TVUE1P+amNNM5/9NrpGGAhcacKRZGSmHRqsxDpIWX8h7WeaEaJfXv+yRxiavonTqrB9jb44QvXmcgTQibP4KFRZoKypdwrpQg351PxAXoYR0xPdGVQcLHo2AJpfc7cFUOXnR9pX5vlhznYK1M8vZYPC2GziMuZghAUsSRhJ/eeZCFxocgbTcLWLVPziBw9qgp4JYGn4O1JwGj2shZVhyUio2Rdg5g4EHyXG4DTZUDbRGiABzs6HCDF3GeAyGBQYWHAkUoAYm0SAHIpmIRIfMb/1ttFZWvU7WMJXt4q3q3H4tmZlr8BxoQou1eKuxy+UngZ6cOIstIunBOX7qktojwk/rZyBYoeAV9nuyHecl9u+0HBPCre678pjwbIayEShuj+5lY83paCL8hfEFnGqdKqjj6ZYrFVbAM1YhXmcWnt0Sty/jEipAqP7j4bm9rhN4GqB/iEBX2rsBzUErahga2ksW8dfMKhSkRCVOpG2ZYLbspYR20sgHrbo98/AFjaB6fLDj/0GVmV53NuHsbIJD6FP98NSFTMATpvVN1Wfplmuz+KLmjMUdpxe0xXbadbfEEwf4AVqksO+XYU6a5HYhtARzyoCCBnSyUkoEgrFCSvZaw6dZGN+Au2VKsn+TgTmj+VAax9uadBnNwZdykyM7bw89i2NmynOK6b7RGyTq3+kb76ptl+qoCDfUrWpziDwEq
 ldyx/AUa
 uRks40VLMJpDSk92KQIyMWQHnFdslDqXOJxN3ouRLG5qqSYZkHPAnVMYrqAgEACew6wv64Gs2p/t2545PZ8Eii2ztS/4EEPUOENHQIWxI4iDqzqP276qv+rSx9WXNqG3Mt35s3bqoq/wqS8INTPv0IeIpJHUR2QLh5MjT17ALE1TEU2KAkINCnFGo4w+MYMeMcCkhTWdyAKZ5+T1nogz3zN6YDvtzRUjQ9pX8aznohOTvCL2FJsW/h9R5zUGV6I8X2K1q7b8Y12YjanjVpES4TYMhF/FrsEsq+Dx8elHe4Owj6HHZkXaiFq11RVHcL9TBQ7eNDHYHtrPcpf4T9ZYLmyjcMt0TbKrFklkFiF+UDUfoA61Z7zK0EpzX9jxCxx5haPY/aO0VK3NfwDK5n/eeeFpcnVkQ2E+JuI6he8CIbgLUNErXu/LGgWCmSL/PffCIMG0CEBpJp2DpNfl65NcqvnmNpOGYkUJIODeF3pllUJq0iow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_collapse() computes a THP-aligned window from the caller's range:

  hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
  hend   =  end   &  HPAGE_PMD_MASK                    /* round down */

When the caller's range is smaller than one PMD (2 MiB) and/or not
PMD-aligned, hstart can end up greater than hend.  In that case the
collapsing loop is correctly skipped, but the return value was computed
as ((hend - hstart) >> HPAGE_PMD_SHIFT): with hstart > hend the
subtraction wraps unsigned, producing a huge value, the comparison
"thps != 0" fires, and -EINVAL is returned instead of 0.

A concrete example:

  /* both cover less than one THP; both should return 0 */
  madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);             /* OK, returns 0 */
  madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE); /* returns -EINVAL */

The fix moves the hstart/hend calculation before kmalloc_obj() and
returns 0 early when hstart >= hend.  This also avoids the kmalloc,
mmgrab(), and lru_add_drain_all() calls for ranges that trivially
contain no PMD window.  The same effect could be achieved by only
guarding the final return expression, but early-return keeps the
no-op path free of the allocator and drain overhead.

Patch 1 fixes the kernel bug.
Patch 2 adds a selftest with two cases covering the hstart == hend
(aligned, was already correct) and hstart > hend (unaligned, was
broken) scenarios.

Chen Wandun (2):
  mm/khugepaged: fix spurious -EINVAL from sub-PMD MADV_COLLAPSE range
  selftests/mm: add MADV_COLLAPSE sub-PMD range tests

 mm/khugepaged.c                               |   9 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_madv_collapse.sh        |   4 +
 .../selftests/mm/madv_collapse_range.c        | 141 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 6 files changed, 159 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_madv_collapse.sh
 create mode 100644 tools/testing/selftests/mm/madv_collapse_range.c

-- 
2.43.0


