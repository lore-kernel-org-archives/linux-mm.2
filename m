Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6981C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 17:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15ECD6B009B; Mon,  4 Aug 2025 13:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1100C6B009D; Mon,  4 Aug 2025 13:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40A26B00A5; Mon,  4 Aug 2025 13:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD76B6B009B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:24:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63E465B796
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:51 +0000 (UTC)
X-FDA: 83739749982.19.8E07FE8
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8196BA0009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IXqcHP4/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754328289; a=rsa-sha256;
	cv=none;
	b=rTtsBLnXV6d+VA6SKz1WjdLprUaJXc/uvGW8GslR65cBTM7TmdKCtT5REMNpKtVjD7XgaZ
	1/nTDnbzC67bAmMtR0HkNx6Uxzl5bQryXdM9aEokAYzO4ua/gZxqOaTts0mpB+DYtnTVz4
	nHtMGPJwPPXmRbfRzBmy0ZvSI3qQE0A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IXqcHP4/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754328289;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PHVh+bW0oX3+8yP14fW/aJudQEbUBGW3A6TL5UtPTPQ=;
	b=hbQ3yKY+K7IPCz6mhfO7e3G2CD4x/sjv1jvWbLCnLfntOTcjFm2Fr2nqfX443ToR4Oe6Rt
	s4YbPlgIifZDfuufySrB5OU+5TGRJumZF0VCkqjR0LsSjOpmHuF0KWq+Hjy8XHeEjGM6CO
	K3Mwtgh9PFFUAZ/IQhmrvQuu2Yt8/Mo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76b36e6b9ddso3859222b3a.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754328288; x=1754933088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PHVh+bW0oX3+8yP14fW/aJudQEbUBGW3A6TL5UtPTPQ=;
        b=IXqcHP4/ecZFYrRVaVUWVncseqn16nVz3WQ+1R3bXGscZyZRCVSbqE2RyZ5Ykbdqex
         8ffR6onHV9lBrgRn4MhMpKk+x8dNONAVDw5IUGoWNpag8ZAn2tm3RlEfXjKh2/dP4FyL
         oZ7x7P1hdmN/763jj3X6JkosBMEHLidoxCqtWOFMomTbAsfiOSnKDzqLOkN/upmzl46i
         FO2xvzvhfs6IHZrGe9Qi4DgQIEJBBV4Wjufiezn4abTjgsXHeZc//PBryxdFX7CZp4xH
         rGEBbJ4iNH0HT8uymyk7fIso1p8V/L/7xYP3NgyBeg5N1q2J3DzqJD7ZtQLOcMsUW7pe
         s+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754328288; x=1754933088;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHVh+bW0oX3+8yP14fW/aJudQEbUBGW3A6TL5UtPTPQ=;
        b=wTh86DknZjl5vq0yAaYDYKSEghbbB3WEDC/HeWZTNshFX/t/mn+exlIgX6Uv1FPTRm
         OXUW+Lrsw9CLey1s9WB2Evme+4cgOP1HDQMVsjqRnzS+qT7epGVwKg1QTFx8OgIkZ76p
         Rom2z7qNvMFRDeCaxJJwoO0dkH6VWBi+msvaGFSjJiFhvRY68890NNZxZmbZMgTtzn59
         aSVDsmJSj8SftniYQ0iIL81DGF/r02IPPrSl7C12cKAtK4KKJfvEMv7dy2qcdKNX7P7U
         tRjR2G6w/Bl6vtxaW/qPmzFrpBo1XhlzT9e07wgL1k5nufIFkbZZjpG5OJ0XK92WDQsa
         oTnA==
X-Gm-Message-State: AOJu0YxaQb0NFXqKhLqXv+KuF5fYssRKOnJSh4VEtDRo8WzkqcQQjTv5
	d0XvAeXuyXlYcfg4s3POmKcLkR2kQAgPO9O+E0ZGI6wFOKQXvMgDnLEOBxj+0YhlOqw=
X-Gm-Gg: ASbGncsCrrNXrQCwJyMD5azcWkzgMqyLFtFg7jUMy1SJfw3WA/PD1P3nPUdvnX4fZfc
	/YN71OM3m2DeKr0ukRTMcaOv/M75bGIJixFZlb6fYNrjxM7BZYBiBXABc71IriWmTRy/cbePlSX
	j2HS3+TRuibYJkyzjqvlcGLg5WI5JHRAWN1MtPW8Qceww9kWLcCGPyJysqRCJNBsVfcqdVCTbty
	1BQEbw2tTU6GZ9IJuJz+jdpHcxg5+mpFoDkF2Oeg/OBaDj5ElFrhbo3IqgoFQaKF8YXTkTdvK3D
	F1nMqSZAavfrpqgvtqmkv3d0kLUYGWpiA+uq3d04rNXECLt+wEaOjKDisGWKQBuX5i9kmrbBWoh
	2nL4Hiq7paWdxitokv6X8czpWWHk6k+i92H8DGQ==
X-Google-Smtp-Source: AGHT+IHSC7TNTjwpqx44F8YGDvODHfInTOBsE13N4kab2tXYxlMKJ6P5FKRoHxc8idI1nYgb7Ht+Sg==
X-Received: by 2002:a05:6300:218a:b0:233:b51a:8597 with SMTP id adf61e73a8af0-23df9127c29mr17231404637.35.1754328287752;
        Mon, 04 Aug 2025 10:24:47 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bfcb26905sm4194530b3a.123.2025.08.04.10.24.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Aug 2025 10:24:46 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 0/2] mm, swap: improve cluster scan strategy
Date: Tue,  5 Aug 2025 01:24:37 +0800
Message-ID: <20250804172439.2331-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8196BA0009
X-Stat-Signature: hgr5hy5mgictmr9b8fb5gkqx1id1a5hg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754328289-396741
X-HE-Meta: U2FsdGVkX1/wgJFNMH3KS9EKwXz9mplevHFYCnoDjEGgt7D0I0ZXz/MvnAv6myoOQ7djBywXgRZG9VbYlnvDlLc2zPaCkz1p5LNvqA19XF6SCRF94v2wEHRIAfYdmUzcea4m4N2dQNtj8uKjh7y/alEYjIPrGxj4gUvCY3A8eh45VJo3qvJjo8aPwHBVfCRXHqJXyP/YcqzMAobBrDbWm548mSqy5H59CGunY3Gn9ybOKSu0V7getzGYY3NoIYab4PqcyQ0KMGIfKANJGYA83NWQb6gokJicMfdsSh7Fz4rfnXcXLrrrmUVbhORAFDuD1hNBZczJshB5I4phrfb5ugttgpNilqyOkYT1r4vvcDKs5OxWroL2Yxh8DxRDffnvLC1ML0CDUskDUd2wTKpaytMj+k5FDPxQZG7ouvUn+H7SuJHCX97A5myVrqjA9ZTlJiVr//dOhCIhJAuNM9O4vXLnc0jEFlwRJNkxGQuQH/hVu5X6EK2Z27aD3bciOVEZKZWbvhhF3ReAfRAjR8GFWQ9hoCfkOfsW44buc3VSUiNNFotdYn5qHaw655UtWbcQes+vNEh6X8SbV623QIGEWIF5GFr6r64VikIr1trxRSzC/snReh3d0Cx0okDSy5PY4C4HDQOLCq4TOa6kL69s5nguVjXMvnuEXZliZGbPp43u/fwusapJD/XcfTGVa26fvEUmXBinn1qu2oxo7wGNQ7BZ0p0aixkjQzHXVy8z9Ts9E306T05Ohz9UBE26siY4v1eI6+xkOZXjD0M8JgERwpS/hGqncDY3i7UVsMG9uGfCHcJ3IENXwfsRewo19ndGjhVgowtPI/qd1vgrnzd1HFhE9UBuEqcqaOYSZzhKyc2W7wImbxQGqGSXG5zHey2OXu0szcT+7cY9tab6vDl+iSm7j1ijIHAy1zIXU2noAxayo3QZKXk7PvAYwO0YQZ+xskIQMMQAmuf4zL7e3fu
 Oh8MyoLw
 H3EbQdABOZ3EL8iRcTFOlnXbY2sIaXljhTdWVX9LMzIRH1a59b/1K4XXsnXWUkfPpclFYC13Hbvou0TndT3F7E1rsPtKISF8iOU0cG2+JEbOr/nU3z0a8RVbZrHW5kqOSPH1r8QDRLZGyYbSV7S1LZMnvMUMAtjzAWbtPoGVaN41B6hmfx67jy6sjTec6eN7ZJTHvke3G3uYn8a/dNQ3A+OMsFY4y0802niK8RtbxIIBW8TIyTi8Pf2IXgHKA/QtqQX4TPtsSAYoJZeSA893OcYHxnsbDcACGwtDXFnfTrg7WcD6gYAVJT3ru+Lzkxxt3DMXeu4pHY6tl78YVF3uWrMnV6h9l+GGxloiaQmVs5b2V4/mG7vUcMEgo5oG92x1SvWPurJNxvk4gy+dDHfqf/k8BDbaofhWogx4o4Jk4yKsIDtmMLUHjCjBsdEmK9PkycuNX8ckfDk25JLdZFi5NhmAWZj4m/rE/JDvnVrPTD1aYU21kKkFAAF1NXEKKKs87pEuCqTC1psfz5XlTKcAnYH2Mr8PYDJoNDsBc9c1/HiOP3E72F1xslrXWcdkqSiwa21uV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This series improves the large allocation performance and reduces
the failure rate. Some design of the cluster alloactor was later
found to be improvable after thorough testing.

For example, build kernel test with make -j96 and 10G ZRAM with 64kB
mTHP enabled shows better performance and a lower failure rate:

Before: sys time: 10230.22s  64kB/swpout: 1793044  64kB/swpout_fallback: 17653
After:  sys time: 5538.3s    64kB/swpout: 1813133  64kB/swpout_fallback: 0

System time is cut in half, and the failure rate drops to zero. Larger
allocations in a hybrid workload also showed a major improvement:

512kB swap failure rate:
Before: swpout:11971  swpout_fallback:2218
After:  swpout:14606  swpout_fallback:4

2M swap failure rate:
Before: swpout:12     swpout_fallback:1578
After:  swpout:1253   swpout_fallback:15

Kairui Song (2):
  mm, swap: don't scan every fragment cluster
  mm, swap: prefer nonfull over free clusters

 include/linux/swap.h |  1 -
 mm/swapfile.c        | 68 +++++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 33 deletions(-)

-- 
2.50.1


