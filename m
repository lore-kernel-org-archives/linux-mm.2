Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33614606BA72
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VfgQ4f4Y
Received: by kanga.kvack.org (Postfix)
	id F1CF06B0662; Mon,  2 Nov 2026 10:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF18C6B0663; Mon,  2 Nov 2026 10:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E576B0664; Mon,  2 Nov 2026 10:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4DE26B0662
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:38:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DDC7C0179
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:03 +0000 (UTC)
X-FDA: 85390584846.23.50E7443
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD236140004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfgQ4f4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HQ5iEJDd3H6McsliLZtnU2nxiMLxTdJWIHt/2r3Xqjg=;
	b=UKw+YfcGQVMTw3QmiKUL08/0DZ7KSZnzCUAhuWVrdnpODXhwh3y5LFVVOUAFv3EuSISDZe
	Xd+X9lPDLN6dvdjPZG8d/QtRCXXc00m+r6pg0SKlGdQ5mHsB4an4saw1Q0rHQ4+2iJZFKs
	dO6ssRfV4I23xk8FQYHPHNv2DYahxTQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfgQ4f4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633881;
	b=wxdaOTN9YJup24JokbqZVOSvu9l3TuQMoG02pOoqbSws5pQOBR1qyL46nty5RZGBw/Gh4l
	WY0M76nLeTLFI34pSfO9AMmNHhDkftLYpuD5gyLeBH+utpanLy4WxWQXD9Vz/huPcfPl21
	wjB3DWEQsiz2zAs2ZqKMCh5Tl6SmqZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E37B60C08;
	Mon,  2 Nov 2026 15:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9EE1F00A18;
	Mon,  2 Nov 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633881;
	bh=HQ5iEJDd3H6McsliLZtnU2nxiMLxTdJWIHt/2r3Xqjg=;
	h=From:To:Cc:Subject:Date;
	b=VfgQ4f4YF8xUMeOwRSjd+ce9pq6NJIOWViRmrMp8Jml3Oa7TP8RqCe3Il4g8VUOMw
	 NIhvAY/UTIowFzMfc0PZIrkpZdnoBpFzLBqYMj6kg/z6uQuM6+yrMfleheyliZMbdm
	 lBTxwXJm8w/B+qV+j4TThUFnxe8zpQ2CCVcHdsg4gVIZ5pFpzlyH8dKeOKo98SJxeF
	 p1L1Cpf5lFXA1nUdrojIb9g6+1xwOxeRkpZeLvT3vE1YVgQRDvpOm9roa/ZwNq49/t
	 /LCpSQH4KcrVWgY8OHnqR23p73R3lUDY801WsAsTcNvBvO5J1oLXwSh+Z7DRd1bBBM
	 UcK1ofvR63KJA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 0/2] mm/damon/core: iterate over installed probes instead of DAMON_MAX_PROBES
Date: Mon,  2 Nov 2026 07:37:50 -0800
Message-ID: <20261102153753.97769-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD236140004
X-Stat-Signature: md4guschiouanuto4ghjxbk6rqw9zkrm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633881-421384
X-HE-Meta: U2FsdGVkX199zRvEf/wUh3PeKDt6ln/xe62WTcZ5neuP2wS1Kovjm77KgTGqBueOrDwC9W/fVf10sUUsoI9RAJHD1rFa8n99VfyZ1qbmtPUvORQHUInGiO2YLuwXIRWnweUBBXOizpaoNPbjfteGACmwTe4WQ/EsHQ0Hv6A/MHlcKQRgKQst0XZ7uQnm9nVEk+54exZvJl8V6HGlJ83pFdJ5JuChZhIDff1JYOeuBp0LRleCfBoFfPyzaJ02tz5b/UHR0I7SbIObakdMrejl6BJkW5Uek9mclpFU6jYPagOS51whCI3IE5gzjTqHZ2mP8d8P/UYJoFFmVFsAmzFy0XubpCj2NChAqOxhXT+aLbhYZSAlnlLFQxLNkbCSqiZXo2fOmrsfa2UmsW1TDaoe27kR4a88xwCGiWfM7DiC1DZsxg2h3Ls0UgsbYUcApE4lb2rJOVaOjCbLWbog+4/UHUPB4q0mz1JuAQonDLVo8rcB9y5x2DNBNY8v+sIA/VkXF0e9C8wyqSFJuCF3and3Ip+dxVqURXseBd5in9dIMMHGGAN3U/3sUseTIecceCz0KsSy39Td9UkJTS6uOd7nnmIEKJ3/PVgKf9xsjv1ca0aSvfD1dRYyJdXXeF7aphZLOeNfcZCxD08hAoqe1ructz/uXsDC8mdHgZoUVDFXSeCrKUrepg069zhb5TwbtqhRirmBaUBIkllek7UNPGbx/HOntSZz9qUKZddgl8A06dAgeghY+t7v20Nic3rGjhhigP+rzFhRPfdy3ONUGmSR+fhZRaBXXL/jqUJ6HEcfhZdr+9Zzta7ys6OXOMf2/AQjOGk0cZF7MqSJJYAblYOegAX2gbN2qVOTugjgDyraFTJt5sMIgysSeR3k6MSX6r0kn7UWCl+rP2hwZf9KdWSyBWS2u6RU5WF+4ZXwxZlpnSnWt6URI9oaquFN6K6TPNsdrP2CH7vOTwSeE9WbJ2V
 jZdfBNhW
 5YUtAAVliOMGgvcoSzce1MpyqJdmjXhMbsFgF+gqxawAlb03xifkVRg2YsCbVDbffhgnkwrAy+7+wwKBZtVBU67e3bpKTJoFRxjeV/9n7y4d5G4HlsDdiUGPycRlrGy5YW6bT+khyOCbCFNQM2eEyP/gEfCd/dBvNPSc+SrfvJ6nTL+OR14+92IHdQupv0eiFp5JmAVkMpThqttuvaG9l1il0TQirFg/gPRJJp/Bha9D92bPjH15KIu3BBH3UwAW2gqs0KrYhVs2aoMT6IWw0EsT1naOGVneELo8c6QkkuAltXzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Suhaas Joshi <suhaas@s-joshi.in>

There were two "todo: " items of the same nature in mm/damon/core.c.
Both of these suggested that we should iterate over only installed
probes while updating (last_)probe_hits[] during merging/splitting
regions, instead of iterating over the entire array, which may have
empty/unused indices.

So this patch series does exactly that. It replaces the for-loop over
[0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list
of the context.

Reviewer note.

These patches are based off mm-new. They pass all KUnit tests related to
damon. I have boot tested (but nothing beyond) on qemu-x86_64. Please do
let me know if I should do any specific tests and link the logs here.

The series has been tested with mm-new fetched on Oct 14, 2026.

Changes from v4
- v4: https://lore.kernel.org/20261015135533.18761-1-suhaas@s-joshi.in
- Collect R-b: from SJ.
- Remove/separate messages in cover letter that not suitable for commit
  message.
- Wrap cover letter for 75 columns length.
- Rebase to latest mm-new.

Changes v3 -> v4:
1. In some places, kunit_skip() was being called before freeing
   resources.  This is correctly ordered now.
2. In some places, regions were not being freed. In v4, they are being
   freed.
Link to v3: https://lore.kernel.org/damon/20261012145636.168436-1-suhaas@s-joshi.in/T/#t

Changes v2 -> v3:
1. In test functions, new probe and context allocations happen after
   target, region etc have been allocated. Further, target is added to
   the context.  These 2 changes help in reducing allocation code and
   improving simplicity and readability of the patches. This change is
   true for both patches.  (on SJ suggestion)
2. Earlier, if a function's argument list required multiple lines, I was
   aligning these lines to the opening paranthesis of the function. In
   v3, these begin after 2 tab spaces. (On SJ suggestion)
3. damon_test_last_region_quota_reset() uses the older version of
   damos_skip_charged_region().  Make it use the new version.
Link to v2: https://lore.kernel.org/damon/20261008151944.113714-1-suhaas@s-joshi.in/

Changes v1 -> v2:
1. simplified commit message of patch 1 (on Liew's suggestion)
2. wrapped all lines at 80 characters (on SJ's suggestion)
3. added comments for new argument in function (on SJ's suggestion)
4. added damon_ctx_destroy() in r2 failure case in
   damon_test_merge_two() (on SJ/Sashiko/Liew suggestion)
Link to v1: https://lore.kernel.org/damon/20261007154851.45368-1-suhaas@s-joshi.in/

SJ Park (1):
  mm/damon/core: copy only installed probe in damon_split_region_at()

Suhaas Joshi (1):
  mm/damon/core: use only installed probe in damon_merge_two_regions()

 mm/damon/core.c             | 57 +++++++++++++++----------
 mm/damon/tests/core-kunit.h | 84 +++++++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 35 deletions(-)


base-commit: 79e2e91bd5a4b213cf40819c2711a9364b2c0f86
-- 
2.47.3

