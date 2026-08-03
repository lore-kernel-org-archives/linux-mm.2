Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92663C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3CC6B00B7; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084226B00B8; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4736B00BB; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC5176B00B8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2B4912061C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:46:55 +0000 (UTC)
X-FDA: 85059327990.11.DE3640B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id E98CD180003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:46:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=szNVJU3Q;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AC19/2AL/KFMxTlMrBvCFujzA0iALQPona/ztJtl5ZQ=;
	b=KywC9Tim1wOUOrcqZSdHu5leHktFaspKmsm8Rf8KriqbSntj/DyA3m8s+djIx+1yXDAo+g
	BHm7CJM9wTEfWjJemo6dFc8eDDH8IqFC54xXVYAs+p17HKVu8o/1FPuG0l3db5EGCVHV2v
	PBQCOieAayVGpZZNJbFmNOVYGtXQPzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746814;
	b=BX4aR8uQvmXp2eOL3T/YH6ZEvWHd29bWbeThW5J7LSG2QLrY4KWrze6kvWHFs/G2CU/dVy
	alD/+GFthag7WQPPQBSKZqM3WzQyGcLNGwbDQrRUU76f38a7xfRxuczeHNV4D/txu9NXoG
	kT06IkRIv1EkI4JQJqqTu1hj1Z6eZn4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=szNVJU3Q;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785746812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AC19/2AL/KFMxTlMrBvCFujzA0iALQPona/ztJtl5ZQ=;
	b=szNVJU3QmtDyEiMQMQPbCFW2OpBay1hlcPikRZJKDTVoWDkUaKgqr1sgMs6bzUvJQzx27S
	A/70YGaMtlmLPQp+dAuDALr5iOx6w9ROqKR5BmoeoJex+Xp8IigyPwKz8ymi04vWC2MGPs
	7HhtB+Plqzeq/eRtviwGWDCWCukucQk=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 0/3] make unused huge shrinker memcg aware
Date: Mon,  3 Aug 2026 16:46:32 +0800
Message-ID: <cover.1785746588.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E98CD180003
X-Stat-Signature: iwn5i6ocrefcw1msdtcropt8ut6eazwg
X-Rspam-User: 
X-HE-Tag: 1785746813-333813
X-HE-Meta: U2FsdGVkX1+rl1Xuu/mUHFG41MQTgE6J3C5wx4wUAUrtlfdj0jp3UwV461+wIx/9gZ4dg+5lqs9geziYHzYKuBX5OuWriluGBHU3QRGnpaJUN1ke5SRuv1r+tBGDzn3vsFD1I/uG1EsDDLsUzKIPKX5Hi2rW+EDiZsCQJv6mQLcccS3mljTeitfhnoblbi2Bbb0kzR4cgVXdeWsbJGpDcfFBAo8NslOHCz8Yot7WuBXKSZNehoe1f5ro0eRypr5dCJDkSd5PYBHnVrvyUW3FXm6fIMgRB4gLPFzDS6htW1cKDDKM9srGIbMCAKhNauiqNg+DMeTIYs8GDvARdmloTJBsP2mmjjkLeU8sMsxLF6LKdTi9MBYVlgU0FZbFdSwwaGSld0ZmsW7YdHyNVNI49tBp19Gi22q8I8AOurByyNY3EIxapWKCc1cRyAsx+r9tx8LI6BsxdpzwdUFqrgUjfMKr4DBLh4dxudbrgGy2tPCx1q6e7Odf6eg0q6Ws9HMZzvDE0dKR+Uli3LxVjoxliQLKHT7ujHJ4eIdKhHNEXxj3zAEeFxoPCQq7hir1GuLVNSEG2AYwtL81eb+gRgRx4s3qKjXn8S1thQFvKaJIAyCx8Qzjz2Vo0cN2iFKM0OIVjJifk8dtR09irYaH7FPsRWvm1esbLLsnxxrUuJCea+M2aEyZPEtIR6hOyWU9/zgpTPN5FfIzFrrvIqVq8p4tgXoLLOQEpQDjrpoj3B7ksOs8Nsubm8cL+lYCEpSoEwH9c8LbnL2Gsl5fNJgcLb5n1fFyVQRk/yXZ0ubKmcBtg+e/fQOJuCklioz5hWegIutvB9M+2rZxDrCjbWbBPTeMNX1yVDak4LxKT4HF5KeQkzkQGo+Dglbr9LK/kBDgv2uD/JC2gbLsweq8WyzZs6jTNWQZd7rCDOUInuDD6YcKZx5/snS8xioduEXSv1N3jLSJHsWZ5kC+imS7uNzKTDG
 GDGoX3iW
 xpdlwqWf44BTsaT2xR2IkwuGguDqkf1pOeDe0rulpDEOcGbkckqyC06l0SxQB4BueqyB5Za4qNUXm6eFPlem+9b5d6LMODw4hn2fdcWHDosdEtOxxQAd9nsv6UanX6b2XJrw9AwtRQM9lLaoGihc1+w9xnRTSgj1Mn6cctWMuDvua5A47bdfId6Y2/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v3:
 - add a fix patch to fix missed removal of super_fs_objects_eligible()
 - move the original shrinklist addition logic after all checks are completed,
   and split it into a separate patch. (suggested by Baolin)
 - simplify the shmem_unused_huge_requeue() (suggested by Baolin)
 - keep the move_back label in shmem_unused_huge_shrink() (suggested by Baolin)
 - rebase onto the next-20260731

Changes in v2:
 - temporarily add the dependent patch from Usama to the series for review
   convenience
 - remove shrinklist_scan and shrinklist_isolated from struct shmem_inode_info,
   and re-implement the logic by resuing the same info->shrinklist
   (suggested by Baolin)
 - add more comments (suggested by Andrew)
 - fix missing initialization of info->shrinklist_memcg (pointed by sashiko)
 - rebase onto the next-20260717

Qi Zheng (3):
  fs: fix missed removal of super_fs_objects_eligible()
  mm: shmem: move unused huge shrinklist queuing past the truncation
    check
  mm: shmem: make unused huge shrinker memcg aware

 fs/super.c               |  18 +-
 include/linux/shmem_fs.h |  12 +-
 mm/shmem.c               | 361 +++++++++++++++++++++++++++++----------
 3 files changed, 283 insertions(+), 108 deletions(-)

-- 
2.54.0


