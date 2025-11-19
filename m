Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EA8CF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211D96B008A; Wed, 19 Nov 2025 02:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9586B0092; Wed, 19 Nov 2025 02:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF7E6B0098; Wed, 19 Nov 2025 02:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3F186B008A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:08:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C12E4E078
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:08:42 +0000 (UTC)
X-FDA: 84126478884.29.B304029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F251C000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:08:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iMIwg63S;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763536121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OT8RPAavCkT2WqLsrZBc6vmPexyjV2P1GxsV18FOWNw=;
	b=KyT5xwTS+Z5ZnZlGsbf5m/ypaOXwr5AJLL3/bf/lr5qUdPoDig12IUpGz+UFULpIwOtGwi
	f5DD0KCDo+ls577LUhONkKCekw5YM+tVrXxSkVeqxRSAqsbIQy7Bg7iTNoa5TUGGRLy48/
	KND8kHcVTvVQ+bJowPd+mGhRIObyBK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763536121; a=rsa-sha256;
	cv=none;
	b=ouDzOkeMTsWnnjvQtagtCA3lakZnzoH/aQdhbxe19Kk708DkEe7RyIaUlAkJtW+veBPsIe
	YB2v1I+37RIfCQvR0H0w0eqP5WnDPk/Adyz/SqPB8Ygl/eU6i+wa1OlC2tg2ZuprVnw6MU
	G5D8HULVktJMFrSQZ48IqlPvUHEJAPQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iMIwg63S;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46D3E407E0;
	Wed, 19 Nov 2025 07:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA803C2BCB6;
	Wed, 19 Nov 2025 07:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763536120;
	bh=nZBf4m29jUm8uJrYvwBSu0Ab3KRKwWBPjgjsugL5QiY=;
	h=Date:From:To:Cc:Subject:From;
	b=iMIwg63Sdq8bPS8Q/rBBN/9ewQwWzqzfV9NdmJXgIf7dO5mSXmxQhfMV6zKNvuMEn
	 D2WWXb8pP2Dvq6U9us/Uul4X9lSzdNQlN5I5pIxvvaZhapYplAAv0ibgXAhMzfjlU7
	 oTRO0QpvUaDPQ9wV7634+zyPq1x13I/1JIuGZGVnALDOi/5qsEOh8LBfF4ln/n09p1
	 6MvRWiNYPevmI5ITNmqDIk3zlc/wmgwsYzGtzLuC6X9tQde5RJpEOfmC3Lx6BhRZZ7
	 KcNnv3IwUyZrMHS2wZ1c13ybi9sDtcbZRc1rXCCFhHrSxlCL9JFbYT4HrjPAPYM9vP
	 cD6Lg061R8P0g==
Date: Wed, 19 Nov 2025 09:08:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: fix memblock_estimated_nr_free_pages() for
 soft-reserved memory
Message-ID: <aR1s8Y4wP1E6-dRR@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F251C000B
X-Stat-Signature: 7wmfo839unyz9ci54qukzygt84dzhg3h
X-Rspam-User: 
X-HE-Tag: 1763536121-126365
X-HE-Meta: U2FsdGVkX180kSusgVJJ1DYmtXXLoZjur8ymW72Pz6NXR0F5we9Lrtj8yDoNVBQGeDCgZerrEwlvQOc/Pu2l+UF30HwNj/+7hk/OakkRqaHlZL0Yw/Kbopo/8CtJsZCOgGzmTzASHrD9LzZwhIJ76oElSXxGXsT6m7PZoREwOOCZ1wBoFbKCymd8zgpOi2usa55vmIytrY4bBKwXN/U0Bf1z0YyqFEEH3609oP6q/OV8L1mUgCEE8nkcWIXMCo3eYMmGN2hrq0f4pw3jDM7t/zeE2hFirhqCU2P7P1+MZiyRajJjuXc/2jwIIUrwQDXdNA+ROF8HI+fs6GyLsHIIIvc1fg7oU++99/dH+X65zbZwuh0D+JmON3D0qGUJwvLIVvDJt3UMDXPteAMp5nicYoMCRLzPgQZGZapyJq9Hm524C/MnIWvSR7K6P7i3wXRejngY2iEhaSPyBiPIywEVxTwly8djGnt4KzkbXnTzThf7/6AnmKZIP0CHNuLyOoBO1kP0KZQI0WGAUpkAmu+7mXNab3tkjZTn2wtheqcWbFTdH/5pN9Qq5Zhyva6x/3wzFH9hVxTWvzEIAaBnO5esMvrdh6NuqOrD+8OXri3ZEoRH/XBzUPA8se7iYn3QAeZcyFkcoPgCwPOpRGdHosnduqCPM2j7LhD5kSW4q+tcVjlAi4lf0cgRZR+r1wWLaEmfxdrP/uP6913SMcr59lJAH5q8Ojit/OUJ+zmy0bRgiLy/QgEQUbFUG1UtTE/M6QTXCN4/vNa96avhLd9bIYPv6nqJyhQavqdlYDwVygb3wKVhBJ6al9NjJ+uTTX7u1OWn8KAQwHkhTW0pFJi+NKbIsxJPuS1P6tdWu+N/kWsZzPqnuIoMZdFPUKeCLOMnYoXIh1EtzZ+D967d8EQeqTeFGzZlNpM3CJfQ1+evzBMAqmcHQeQmM9qTVfvaWGcfnEl2dpLSNxjolAEhJDCDOTA
 luPytPK5
 8ZxUBLMoq7jDvdUds0oBtDgJv0PBUO5hSx1zCVBU/y9xo+AfnbC6eXBuqimUhtUJAhdm6F5ynXuKmo40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock fixes-2025-11-19

for you to fetch changes up to c42af83c59b65d01c0f7a074e450bbbb43b22f0d:

  memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory (2025-11-11 18:15:35 +0200)

----------------------------------------------------------------
memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory

The "soft-reserved" memory regions (EFI_MEMORY_SP) are added to the
memblock.reserved, but not to the memblock.memory. It causes
memblock_estimated_nr_free_pages() to return a value smaller value than
expected, or if it underflows, an extremely large value.

Calculate the number of estimated free pages using
memblock_reserved_kern_size() instead of memblock_reserved_size() to fix
the issue.

----------------------------------------------------------------
Akinobu Mita (1):
      memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory

 mm/memblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

