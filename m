Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAB4606A32F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=THi1KgCx
Received: by kanga.kvack.org (Postfix)
	id 5ED4E6B05D2; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D906B05D3; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C496B05D5; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E95D6B05D2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6105B80841
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:13 +0000 (UTC)
X-FDA: 85438492986.18.37EE5C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8F0D100005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THi1KgCx;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	b=EUOXd95E03qUEuWB0AMNzsZ+DQZDWr+cu8kV+WpF1tzGQrGaAqtySTau8OG6YvwmqoNq4Y
	u1sTNhdQnbU4I/8mo86pwryJkbyly0WxO9FlvB8hrrIxABYVgnzt5W9KSVqQrUQrG06lTg
	dSzueSgwK0jz629bd3E8mYfeS0C2Zvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774551;
	b=shEyHE2DJTumf5VHS7ic+/qokU88pZ0/Vk69aduHWOHH8B/+8NHG+6kRrii1qgvtJETJXZ
	z60FV4iU1gIkwEzp1hWb84+9l3HUk5p6CVzmkRAwBX3MXWtDte9pWMt7BJtXkBMRE4RuiC
	2UVygPwVettzWDFxPJJjhNdVRRjVd7A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THi1KgCx;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AD7E43D4D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6596A1F000CC;
	Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774551;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THi1KgCxCL/tbIRUz7DgsnAjLwtHt5wNvzgJivwOw4fEf/fZM7GH4glNvoLqmzslG
	 jKxqeLUpLt4kFsM4nGAncRTmC61p1JP5hbdlG6CzfS32sL+5jbU5zewNXDAfw6oVQc
	 Vclh/Pii1rNz7JCCg+gmQWVT5swKWKdvtA3sq8qEJhgXsW+XuVGNZfLpdVf0cymrg8
	 hWzlNFpoN2vEocHRbokZjJ+XGcFLF8YYDetJ2BWi1WrILp4AtA93fb57B0YHq+bjvD
	 sMiNcLQBk4pBvp0nD8srpKbpE5oI/LMHmKnSY9uVU1826Sl2Nip4cITi8ibu8/QWbb
	 9X8B94TlhuGFg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 27/27] Docs/ABI/damon: update for user_report report support
Date: Sun, 15 Nov 2026 12:28:45 -0800
Message-ID: <20261115202849.99134-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C8F0D100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qqicf9yxig545dx94gnmoim33ueicwa5
X-Rspam-User: 
X-HE-Tag: 1794774551-865989
X-HE-Meta: U2FsdGVkX19M77ReBK3rKhxLK4hMFYAoGAF0E4BU1oQ/pHlCzPQKnSCah4n11FT1r68vnjCdJjprbrVbise4X0994rwA2EQevJF7TmfiijHJK7a1yP3S3Wx5BXZU/9fdsjlpBya4jrP2TuPeQe6ZxOoaEOPqCYxm5qMRKucKmmkYx691RRbsX3h8frxhE5xM4IlS1jKiKQTme1Is89a8QJbg/XMEopOASw/IAZGFgWddGnA2swC7A96Em0e9KEbf9EQJdhLpzmuQCZ9XZoC3CJxookaXdNiXd4r2Uh1FG0l+ZijDSvW8mstV9Ywe1AiJWaqrtA3/PAzCMJV8eP+HnJeWRlqv/QUiQAHmcT/8S/3gSdyfiTnhjO48+SoWedrERouKVn7CtyAk/W9mCspatrjWoHZyIhSDpldMCwGAJSB5D0tmCo6gmx4wIVJAiAZL0Hn4+0RTyL3p5JWj0HCprOF+DelMXocQlwDiEqK4UAuLVnkerKGWg19V519T3/eP0mIVaVGeiygPBF1re1hwOjLwT5iwIUZnaOMTiGuqnHUy8fW2ICHNtEG/LB3H07pmfKk8fPryOM3Xu2crfhb9y0n9/c6kmDKLpJtgt3o6kjhl/WHOZcK0E/uVv7XvmMox9u29QLb+8LtKMYkHfsDF28bkqP9UAxXZjsHDeK9JBKR2itK1uCIoYjtTN2Tryi26IYOvkOqKelhrwWDPZDwusLrUK2AZB+lRvNXA7AkFO78W8QOcc3HcUWgbD7625cnUybqh7LCogyKCNfAbDHOnFLJIVZGM5gF3uid7qBTQyxxc9BbbN3waU+Qf1nWYCnXjb/8idA1HpZiuKFhVfjOS/6RmJMZzHcZVNWGRn6ePlC2cNP5+Owu7+jcaO16mdxEslXKc5tZExyTK4PUJjsvZS4MG3RWqjR5auU3itwY5KyRQtjbgNFAvIOJQQ8wPNAhvYlw09q7ZzwQXWTDp6jx
 hiag93EH
 ViO0K6T1fCDQlFCFwOCqkkVo9udpNLQJJcN1eFsYohutc4ctFmB3SoEa0N9zDkLQaFfA5WdH5amLXtZzT5HFQ9iYzkMCniJFdcF0q2wvXbSk4c5/8O1R68Sm9DQ71FpSrHW+HrNyANkc6DIqnRhqb6JyUx1ELCDSBaAx8zR/IaMtrbk2UBlwzD46YLnJpp4XruIo21pfeL9ICukTQfn3Ad2066R3GuBjHeWcOFZATkFVDoUFRYVY/V3lhpBUpptmHbjt/iTknUkjZ4EtJkOMiOGUsqtJ2qeyWOlHlbNe9W8S7+fSjnkMYuulF07laqCj5O9N/3vNBVmhNsF+BumaY4Vkn8+MO1gHDG+97
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e558dd4212f2c..41a4ce49fbd35 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -722,3 +722,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	A file for requesting actions including enablement and
 		disablement of the producer.  Refer to
 		Documentation/admin-guide/mm/damon/usage.rst for more details.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_start
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the start address of the report to manually generate and
+		submit, depending on the type of the report producer.  Note
+		that the start address is inclusive.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_end
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the end address of the report to manually generate and submit,
+		depending on the type of the report producer.  Note that the
+		end address is exclusive.
-- 
2.47.3

