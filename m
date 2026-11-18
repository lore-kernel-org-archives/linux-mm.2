Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E70D606A887
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqjxlCxp
Received: by kanga.kvack.org (Postfix)
	id E07916B05B5; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90E06B05BD; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58B86B05BE; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF116B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:26:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 108AD1C3EC9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:22 +0000 (UTC)
X-FDA: 85446348204.23.A5D2A04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 17CBC40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqjxlCxp;
	spf=pass (imf12.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794961580;
	b=qbqP1+2sytzEBm3j+MKe8gbPUKzs7rdWWwIZW+Np8vTVYAW9VoWMOO1WVlbVBeynV6YDdD
	y3PX5R797HfKxWJ8rspMq/+RNVTu557/CiSDT+niDUcfKLrlXJDiSsCifIThjXBFLUCqux
	3DlF6ZYZHUfDASAV1XdCoOcRZ9GeIM4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqjxlCxp;
	spf=pass (imf12.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961580;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=POG4N7NZx0xTfkdaPV48K+5iER2B3mTTIQQu0p3MJIs=;
	b=68yfVPza2xHLs6nI6rrAyaTIwA84PqeDldHx1I1j28GU4sH2Rhqe3/CCEzurGHkdqbKJ06
	aI3cVWJ5aTtM4IZJ0nUUTNe0DND6al/lB/rzd0C2L+l6AAQl/NnR4+SmH6zan/55LIWIGh
	jho+SqzDtov8ORZ+ZYkGb/7wy91SzbI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6B1561EAC;
	Wed, 18 Nov 2026 00:26:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794961579;
	b=kXFO0wwDX4IlPs+9/E/DY5GoYBWboLbsvClxEmq8QgJu0s3ppCIFe1LCMZda0ujpiJgo
	 p1Gkm5cSw+wjUBO+l901WB7s0y+bnIZhE6PL7VSQcSyfePrE9K7+9hRsAYdSx38je73qY
	 OphZlddEJQfgqBLnCEK6DdHqEPiEKmRrD3KkAfp/2Gki8Jd8PcPGWMNNkvODSYTPU9GsJ
	 TocrvahpwMh1aDCYWinQqUCNAL36ZLV35Nms9oTBIjvw/dKeviNQmknuz+R3+PuSNETiQ
	 gevZBRMVaYf9crXQl81uzQck2A90WuJKvO+FmXWKrgc+T6OR6IjwNfdH8y+YEHVCG+w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794961579;
	h=DKIM-Signature:Received:From:Date:Subject:To:Cc:Message-Id:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=POG4N7NZx0xTfkdaPV48K+5iER2B3mTTIQQu0p3MJIs=;
	b=Ys0k8b1CYTk5xnb4/dybBmAXNeHO/H/Enb5TMYaDY8pUk4Wlc2wVjJNTPIXDFVEVA8wQ
	 Htoxg7NgCoL09TpBcG8jbnqsFos7zmBa7rfHn/zkoX9I3DbolcrTogcLgAv1h983g7OS9
	 OxnNABYMUZmOIx1HTOHz9uYi7x+odgPATKSRVpPUBRM78QO6bhGBvl+sXMv130a5Z35f7
	 1Uag9ymNOvEi7ZLfU/iByLB3i/ybH0U1M0fZ8VOy5Nk+6/igPs/Ny6mPBZq0acyrzUnXK
	 o3WtFAWmnQ7ZO3odnwEyW6GiIWlucCDr0EfE7Bx2zA53BDcDtsXgLfUpynVf/JtkbQA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 374DC1F000C4;
	Wed, 18 Nov 2026 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961579;
	bh=POG4N7NZx0xTfkdaPV48K+5iER2B3mTTIQQu0p3MJIs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=oqjxlCxpyooAK82M6CuoOH2yyI0rdiX8aY+BHgvES9ob6462P6mDmeQCZ72gA0UNI
	 L0veyU3zrrQnihHPEvJBCJNqDhRTogBg4l1/fRAODI2GYWtkmbcEUQabwkNyueUjT0
	 9gIyb4Es/wK3U7uGfijm/7Lw3X9KCPNe4GSVRR8lo2so1OD9arkZdqNn8D3spW20ae
	 5NNCobvQ9+gF2vBmFZElFQqM7+V0T21FDQMtrfThbnewZfEM0bV8dPx3ekB/DRF97S
	 PaNjKrr+f1bgHimSwD+Sl+R4PMSX2fIRytcYUDtmiTPHaRAJd2W5ypiHCwW62tuk6H
	 DB7C445Of2MlQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B70014AB76;
	Wed, 18 Nov 2026 00:26:17 +0000 (UTC)
From: Matthew Salsamendi via B4 Relay <devnull+matthewsalsamendi.gmail.com@kernel.org>
Date: Tue, 17 Nov 2026 16:26:17 -0800
Subject: [PATCH v2 0/2] fs/proc: fix PAGEMAP_SCAN walk_end after a buffer
 refill
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, matthewsalsamendi@gmail.com, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 linux-fsdevel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-kselftest@vger.kernel.org
Message-Id: <20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com>
X-Mailer: b4 0.16.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794961577; l=815;
 i=matthewsalsamendi@gmail.com; s=b4-kernel-20261117;
 h=from:subject:message-id;
 bh=oowHUtsthVeLQJxBrgRcG222FtO1F1EoKnj3be3MVlU=;
 b=vOdiQvji9DzMpw5/AWv0JtWMBH9LLUYwG0GKe+mhCGAYOG5BguFAO8nhkwu3xBM9Ewb4x3hvD
 qvAWl7sQ2c9A1VbcbIQHPqoqxRFnVe+7OeJICM2ig8hE1sLI2iczHR2
X-Developer-Key: i=matthewsalsamendi@gmail.com; a=ed25519;
 pk=K4Lg4pTU46IL2CPz2Nb/u30nsnWJ38MlR2/Co4n0tto=
X-Endpoint-Received: by B4 Relay for
 matthewsalsamendi@gmail.com/b4-kernel-20261117 with auth_id=1555
X-Original-From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Reply-To: matthewsalsamendi@gmail.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17CBC40006
X-Stat-Signature: sujfq3n3jkhtigkxhiruesnxwqkf94ya
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794961579-988225
X-HE-Meta: U2FsdGVkX1/C5/IlnyM04TS5Rk9IhQEkT11RMd/SdJ70q3C0lH+TaPn+8LgGywBWNnzhClmjlwEMuhRwhfU2fsU0hf3Zmm/FRKx48mY7gtJ6k5qIV+RZZ5YKMVYpacOUgp4748cu0qlAw+AKKDmTCR2NM2yV3ybMmWAJWg7ntUS5AHW0G4LqRi6umVoYZFV/MYN0MUiHL539q1X9UKffd9UbqgvxSYE2LpozgfUXnkvAHUjAXga1aZAEknnMzdIAeOVxyLmD6PaZMcz0pErLAfBY0R1Vdcxy1BSTXvQ4V2pJEgzvuVPJUVFT4om/padm9SVgp4z+kCb5Bsfq0unI4gfbUz48pndqJ5ULoFmpDcvf0pm6wRU8zsppLWm0LBGVqQzmxgPQJAulo6XwPSixux1seew51KvU6vHintc27qJ8ptwMcF8zX8gmukIWmnJ11g07mvywUYnlxfVtcfkuHaHNuWUkWVVqGXlOZuDodKvGZIogl+gI1OgdaJBc4kQyv8sqzrGcBn8Tu702X1g83jrCtKH24tgSZeWreTq03l4/PJVEtJC2heM2BpCVDVdepGA+P3T9yKOEKlig4G2/D99T/Q9VIBOwhW7Y73kDT3g/ekUCxLQhP0kOT72vftz+PY2lVidIXe4kPm3cXQ4yKVSpfjUE5qRM59ACctLSr1oHqNii69V89gAQqt7pCYw1q4pxhlFaPmuegWhlXEsG+4c6pCrxlu+YLhCIVruwkgAMd+7ooY833fZ3ku7/iPsmW5IXGlFScrTAA15t+LISbBrPb6GF4OYKl16wLhbV+mJRW+5Yv4Lrlef8iv3k2zKjhla7pqAUDb4ZBni7YoxtHe8OyZUDiGxhHDxFNymnPXz9afyZCO/UK1TU2iml24pgb68GGcmF1Ez83TdNcMJX3BpFgfqeO6wJBL90ZtAlVb3Xusn8Etw5OZBFzz1vyt61TO2r8VLGjO+bPy4iUGT
 sC0NAUui
 QwGTvqD1lb+NQkuSJ/PM45DEV/mNwqJeZU7WS/KystZIFd5VrAuAhFx1fVQq7d2tv5NnXtU1xXXnSqy0qerufogBUdhjUosPco1h7prEL0Bp5aU4pq3j3cSpzEy2tswSY7UK2lHBIqNbQKEFwSMjInjBmW9gRRRddOXQcxZYi+oPOteIhLZ8puzZhkNd62tDt4r4m7kklWmYzdy8os7kp7rF5RujunMvzICWaQ+dvmjIjF7YegtokCUpSaUY1q3PmdQYjx7BRiG2cX+6Li295AxfDS+8G9wUUHhnaPh5iW9G+phSMUB95CekJyP1MtBLhSHQiz1cBPTsuUtjojxVJ39fwuLmH0O46e0Rfk0YHP82FyDrRbTSUQB2ERSpKuKBOgFbTDVEo5u9zEiFuVgt3b/rWQn+mMmLpekh0qqML0PVY34KM8Z//HVpFDKfmS8Xw4cB4lRzbe+He0eKVKPSr3EsmFCqb2Vr+OVRUz+PNr3oni1Y+t57HEB5cHiAqt/sZZW0iA/xW7Q6FFflR+xnQbM1GB2I++UG40vPBimVqFFXNpWxledVSZ/f8nf4E/DgurY4NE++8+ipsoS4vO1ytvdSO0wou9KXfNZz15CqLiyF5L0KRVWaHVw6z9OagUyeYQ+3bUAhTlO48mlGMz9BSJQazkphm4sUs5PAPBRvuQEFjILU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hey all,

Thanks for the feedback. I agree with the proposed change to the patch.
Apologies for the delayed reply.

You'll find the updated patch and the requested selftest below.

On x86-64, the refill test fails on the unpatched kernel and the
HugeTLB retry test fails on v1. All 121 tests pass on v2.

Matt

v1: https://lore.kernel.org/linux-mm/CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com/

Matthew Salsamendi (2):
  fs/proc/task_mmu: reset walk_end before each pagemap walk
  selftests/mm: cover PAGEMAP_SCAN refill and HugeTLB retry

 fs/proc/task_mmu.c                         |  1 +
 tools/testing/selftests/mm/pagemap_ioctl.c | 61 +++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb



