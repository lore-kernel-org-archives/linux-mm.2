Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098B606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AP+OQPlv
Received: by kanga.kvack.org (Postfix)
	id 2D0EA6B05B6; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8826B05B7; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF626B05B8; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2C606B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:11:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94F158012E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:07 +0000 (UTC)
X-FDA: 85441320174.13.98B26DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 009854000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AP+OQPlv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AP+OQPlv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841866;
	b=o4yXDj8pB+eYYLY5slaAMW0cZ+SQoYAE8j+P0TpGiSdEneJ0P/5lWkj7L2Yg3wgQNeADAT
	il5BUYI1eF7J2aETjgi3JDdvZ3UhPfcSsgarv6vFyDoUorOQ3DdXE1Bd3l18foQe2nt2rZ
	Ag7023KaY+XRLtSUMhQsBBkDLsxht64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7mWcfXvCYIw89d+NBnSrfBHxcVlNxUCtusz5wZcedUk=;
	b=Ghhh2W+rgNpc7f6zx1Fpv+9iNOE+IQ/om3qG/xws9uTPCKPjtAjSVcBFJTcnflW6kjcgvt
	bKmlksml1z5UuwWFCQsbUi4hDPDKdaLLTbmNPJRC8CUYbNdvAnjWHSPRQU6/Lwo6EGupc7
	pwzSrHSj+u+fFzAVeI6EyiYnGdbJAbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4ADF42AE2;
	Mon, 16 Nov 2026 15:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855711F000C5;
	Mon, 16 Nov 2026 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841864;
	bh=7mWcfXvCYIw89d+NBnSrfBHxcVlNxUCtusz5wZcedUk=;
	h=From:To:Cc:Subject:Date;
	b=AP+OQPlv2wvV1qeCtUx/znTHrgoKV+f0KbfrsZZGcfLYckkSwJ6t74XWV4AtDHgh3
	 srjoKg6jamqK3ieGfmSx0T1w8XiaqCKkFMi4ZU0Ixt6yM7mzSz/Evof9O3/VpOAWWl
	 vehR6Tlp+j2pO6dwG7QCf6PbXutOr+PW0I85sAg4rWVR+JXl/loLJQCZXIqIj9Mj+3
	 FO5UVRMJmCGj+O7L0fxKeLhAImFPzbDmY0lNSPYv8PR1Izz9eVjJAmHDv01dqF8NNG
	 H2dlqYCcDXAVCUkk1Mumy7T1cRFQy5Q9FKjhBgUBEb3WS6gfaSHKrgjPWyJyRbIy0t
	 DktBVCQ2WH/mw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: add paddr kunit and replace weird "same to" uses in design doc
Date: Mon, 16 Nov 2026 07:10:50 -0800
Message-ID: <20261116151057.81692-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y15eq7pr9ddi7rju38k7z3js4exyshha
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Queue-Id: 009854000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1794841865-783999
X-HE-Meta: U2FsdGVkX19tpJ+IXPjamA4MVsrQYkQhmhf3EKUNyvlbg9EYW4DTqmAmGrS/G2vy+7y5Z/PDw/U/KoHoDz9Yg8paP85NyHE2ArJ1MnxL470Xq2UPN5Ja3x3OcoW+GipK1md+eaDHChu+ts3FyPvnW1wI3Gs1Jf8lovJkQ/7N+knuEnvpFdr/wzcN77C3sIEqj4ovIcAZhFx0DrsMTJQl6y+IC2SSxnA1FrMnFQkV07l0/lmpCqMyDp4fsvO+VSA38G/ams/kxXa3L8sWr23t25DbM/sriRiLc9poAOGyyTGVBwtm7EaKJJcmV6E32hpIqG6BvEfU3Ply8kTvnhNalHLWW4/NTdwwvC1AR81NL7xa0nFZFoH+nnQbTH8l9Ht+ZZr2BoCmz3iDzxXMspLpKMQnwa0wzOlsms+X24myyRb4ZZGrrSoAOivIXMdvL+bnoteArGEcOAanlClXtpNnVcMRqw0sZy6APuIWsvNGoqSvUZPjSbUQA51qqtgoZp51XdZZXZgnp6wh71mXTOP8UpC6cMP8tkdIQkVWrJVh8rUzQlNw0Z6vKXFb1/MMUCm4Wp1jTHMy71I+jczDJ+Fn2vRhnDTTIfwOwNhJmBfib7332EizRyEXPGa14fTBYgQGEfRt9dhy4vL/uCu+TAefc45U6IM8E0IVktP4k+2w8H6bSfqEfUqy6mFOFll+wil0ZfnC5iYQ2cuLvA9Eq2ZnRcdYH+u1uQ/WyAoAe+D23E/BlnrNUNC543YaRZtVmRkC5+F6vZ8jD7+AcKxjruC6BkL19WeE3pZRl9rHa8Iahkxizu+9VUMruZR2Wsj4l3V+ppwjuxbNBPDiu8Dau7/8OaV4BkutBaVq7aWbozPNCfMAD/d9QtmqjiL4sSHiAsdh3WZDbik3dFUsXQOy8kZQolshlIZpGwbYVrwWz3gI0n60ovm5QdWhBJONbFQcDIauKiFarbj32mAk4OWDq++
 ckPrR4Pt
 +DcVr8zTr+OJuExLDT7z8vgvWc/gFQAFc2vgJZ//X5KNe1UBkQwIwyHTkgrapdVKGr/fSQRFOefjuaIw60rQUYw71P0R2kUQLB37oYQb9UMaGBrjbsxf8adIyRs3SUmHBYJeoANuv48XQXR/cBL06GmeqFt2kqzQMnsvFypAFmsxGGzVUG9c2+4kvaCxJtGog2a9pg5j1Zl9e5Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add kunit tests for physical address space DAMON operation set, via
patch 1 from Avelin Noir.  Use idiomatic "same as" instead of weird
"same to" in design doc, via patch 2 from Enze Li.

This is a batched reposting of DAMON patches for mm.git merge request.
Refer to changelog in each patch for their real changelog.

Aveline Noir (1):
  mm/damon/paddr: add KUnit tests for addr_unit conversion

Enze Li (1):
  Docs/mm/damon/design: replace "same to" with "same as"

 Documentation/mm/damon/design.rst | 14 ++++----
 mm/damon/Kconfig                  | 12 +++++++
 mm/damon/paddr.c                  |  2 ++
 mm/damon/tests/.kunitconfig       |  4 +++
 mm/damon/tests/paddr-kunit.h      | 55 +++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 7 deletions(-)
 create mode 100644 mm/damon/tests/paddr-kunit.h


base-commit: 4789d52076c67ff1ce4c66fe7ee17718a48b3bec
-- 
2.47.3

