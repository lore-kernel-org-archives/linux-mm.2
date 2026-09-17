Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95AEC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6406B0092; Thu, 17 Sep 2026 07:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CE76B0093; Thu, 17 Sep 2026 07:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166516B0095; Thu, 17 Sep 2026 07:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9FEB6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D6A91202FF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:16 +0000 (UTC)
X-FDA: 85223010432.20.2064A44
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE9EC4000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vLyp94ye;
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/RrF7kA/fgEOFKSC3c0R9J7Kn9uYszrhArRbaGcg8U=;
	b=A9kCXS529Iyh/qfNExwi6ezQiUQrYJUhYv/GtRz98Zw/8L8hoJVILyiZ1CB8l5GTuNxTUn
	NlG+T15amEdtcNkpsUeJthIl8LUhsSp7gtBjBmVYEDYBPwP2ho/wnsd9QwisHCRYUgNQVS
	csB2fgY3BKuTZAQlHfObW6VbhR7THu0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644014;
	b=m+BciSRg3WyFQbsvoNtAUAhGV+TgHURUgfCCS7J3t7oFSzMbdRpwt23Ij3AYuUE6UiBeqJ
	cSV4J1boD3ac+AuF/nfKZfCm4LzPqJbjfcHmdTF7wurIrONHSCdwD8rdAzryzJORgF/jit
	euoCvF8r2ksqgSTV+DcLGrAK5AvZYwg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vLyp94ye;
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65F831476;
	Thu, 17 Sep 2026 04:20:10 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A50083F7B4;
	Thu, 17 Sep 2026 04:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644014; bh=byGcsqmsm/N1R0xTXpl1j3TGY+DHgMvLIEITNN4nqJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLyp94yeeWRiax05Jl2DCRO+aVPo4bXcyooHB/YmYsA1x71FVXfir4KWrbWqcHtGl
	 69pX8o/9GAKgj5jbZTYX85Q0ef1OkoFgALL65zR6hMtAdE5/fxi3NpB7iRE501hvTc
	 75WW2W5b6BMau6Fr0QYukjfhClAdHkyTt/xhoDf4=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 2/9] selftests/mm: mremap_test: skip test when userfaultfd is unavailable
Date: Thu, 17 Sep 2026 16:49:44 +0530
Message-ID: <20260917111951.188266-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ru4zgkmgdeaqxxkxcpfws8j4to6der9y
X-Rspamd-Queue-Id: AE9EC4000D
X-HE-Tag: 1789644014-538727
X-HE-Meta: U2FsdGVkX1+DmiyfZUKXYlcKPsKp9gG6JGGf5zGVJjYPRJOFbmw3yWXjOmyJRzfDx5QijVIKLgCpw+Q3iDConLTDQSo6HNyVGPMU/qooXXoByvraDKfeudbrJaQryuMd9J9fIMuJtzx1cw9vMMePCcNn8J5OaPdvjXE1dPb1fLtPGQBO4mNzNgVJRZdEE/b71qPXNpmZrWLQhx/DQBOBokUzKHf+nenHTAmwKDxFZLV3eNcH87XGzsCf7onHg2ZOolboVgjpjjG5E3PVkQ28im4oiJ1DC7WmzwjuBFLKKM8Ev321QIutjADH8R+HNE4SvuFbntwziMgJKnEyfkQqnbpFWJ5xC1/4FzWFzX1dXY2c0claNRMsVreIfTYOTTYJZagCfoTtwHP9SbKuBlCpU0sWoCSU1SJ45YEDvt7kR1E5qsKAQDdCw2R+9W4cCTmkqKUHP7dSrxxhACnXv/+jeJqnvjd6yoXt5E+Am4DO/n5S7OEOH0RBqSLy4KrqzQpe9nH72WAYwOz859G1okl64bad73AbYv/d8rW4BJB4v/wxP9ZctRI9AAN49I+KbBnmb4yAVBltu8rb8iNVhoEIDj8xYkLQWt6eUDDZRW6o6xAk5jG6IKfGqJcY8vhA2t6zBA5HLOgJ4Ps9auoAUDDhqZyhfPMNtePzIJoiuRhVAv009NcgaYd8/YMMYp1UWFQgfALaSXNQaKLE2J12fIqp4hRNWnh8hrtRoZZ74WMthSqnHb+BGV4QuXN/RVUMkiRN55mTk6pcpFqtFrYigZlA4fBhxFjMb0Qn07+HPy6xJWf0gJl2/f6ogLJIl7QsxIS38rHqWfjnDUTAm3uktNeWs9rwiu3dx56GzSUe3VW8lFDaE63Lo/mF7e8Wt5p8pG4BGYHHk0jYAnSgKxuGaa8jWDBxMmwkZ5pUGXV4Qqpx2zZVrAgbl4L74EyRmJjXA+/sWh/KBPlCLpFUETj/X8k
 UQ+UPZ+T
 s08lLVLevUE6xwgzO/o8kX3NnCrqEKWiXDATYu7vR54ZR9cGEcqNFr1IYwriQLFpmIrmW9LAstLVGldy5kmZq4C3EpgRl9RLlvepdJ6IBdW/1ExQpVWE1X7b9FekVbCzTFbE9bAgtEIF05eR3KhYsbJtTmuJS6ImQx8uzdtEcwSbFWOx2PCoxPUIoe8zhJdjiZ4o/FqA2A8PUNX6FBPGjhKhwLuDKDIyQeRv9Him3Puk+UfOZ1gNNUOGuOk1cPtmUiPFb2T5JDQIQinrQ/ts/3EOrMDJsJNjCKxlicXG/fw9jf1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
defined by the architecture headers, for example when the kernel is
built without CONFIG_USERFAULTFD. The test currently skips for EPERM
when the caller lacks permission to use userfaultfd but treats
ENOSYS as a failure.

Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
test when userfaultfd syscall is not implemented.

Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 5532d3151ed0..a5813a5e8f5b 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -721,7 +721,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	if (uffd == -1) {
 		err = errno;
 		ksft_perror("userfaultfd");
-		if (err == EPERM) {
+		if (err == EPERM || err == ENOSYS) {
 			ksft_test_result_skip("%s - missing uffd\n", test_name);
 			return;
 		}
-- 
2.53.0


