Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3326C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668DB6B0099; Thu, 24 Sep 2026 01:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC266B009B; Thu, 24 Sep 2026 01:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D316B009D; Thu, 24 Sep 2026 01:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 149026B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A202C4020E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:50 +0000 (UTC)
X-FDA: 85247455860.23.1BBB702
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7FB418000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Map4q1no;
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wn6QDxHqBbYWS3z1Tne4Sz7nvQnXp50VSfbuxELhNfY=;
	b=rOQbn/27lsS16V6qjZWLBzca6FFcQap65R5BOwkBSr0cIRDQXVWOolajfBNGBTdEoKTkjm
	7jR2pzorympyGvYixW3Fu6ULGVxOS57l2ATwA/Oz0pesi/SH0MasDVAYv/TlvylHnZz7A4
	u+oZ+I8oLTlDt1XisX/6yYACcXv6Q0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226049;
	b=tYtTSd8AXbeY92XHEtYPc/u+BFORe2s0j9fTIFRR+laAj0P8HYpf2DRRy9PMvJo7YeU5Zs
	tE0BjEVwI8g/61HXe3PnOSl3upt77cdCP+63CCdDvDO8rqjQFnWgUcEVMKmz2C6kNOzI3t
	IFYHAaQ3vzZjoTuWlsRrwMbRuMv/Vbw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Map4q1no;
	spf=pass (imf06.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2C251476;
	Wed, 23 Sep 2026 22:00:43 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C034F3F86C;
	Wed, 23 Sep 2026 22:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226047; bh=EBDy9kiw0ETUnAFTA1nwc+a5WpGr3AW/5ybohYQb77I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Map4q1noY0JZiQg7ztyHbCyb1VVRiWXb3iObj+Jv7GRIRqudDYzFyY2KII51sgmAN
	 g20uQxA6AwB+YZCD7D4HOIdsj6OvV644C5IpYIiFpG/hL+j2xeq7Vz08nqaRVACKUT
	 jkSnuOUmBJZa7Jsf5TZV91aoPhsVSa3FjiH3X5FA=
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
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND 5/9] selftests/mm: mremap_test: fail on data corruption
Date: Thu, 24 Sep 2026 10:30:05 +0530
Message-ID: <20260924050009.19974-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1y8goifx5nxfemge4hwjxkzyp5mpx3qc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7FB418000C
X-HE-Tag: 1790226048-348433
X-HE-Meta: U2FsdGVkX19LwzE98lSjN2InuGbt2CYIdqPAJa1vUBYNpw6513Z4jqVM6fBnQ1o6UmeAYtVN06KzFeCa31PL0eV2bft6rB+5ADta0oFEB0zehvvBwb34BqXjmVL/vJAXUFumHb0hpw+HmkjsVaG6t5ihh65My9WlRyCa6nrA/+mf3Rd3a+ABTdU6DZTpFGh4xnfy9WEV/m3FV/nHaXL+zk61YsGznb9uE7xzXz8cTMo+3xwwg06i2khh8xXVy8AkowH1njkGeky0F7Lvn0gf2kjKCjbrK6D2TwIGylksS0bN72M3ZdlYgkArOvPqZplfCuSV3CUJxsFABdZNcNcdPrj9/5ya+cd/mVZ/tjI9/IBoaeU9HF8KhM0FyA99zt8dV0f1BygmOnXWAtFaJBr+7M3LZKSsEJgR1rzy4ezh4y0nfdc3WO9XdHK8NYuh4TAEHyoY/sGTFw4216m38EWWCtfXzoZYFzVLO2y09aRD5vxKslpBmdE9EvQGNLU5eOpUKBPimfVc6fxd+lhGN9f/FomthsoKg0Kf6nKWwP3x3ntpOwBIgZeNTYon1Nq/vmjV+wvrlOOIeh/8tygt6fasBl+XljkCTzCksQgiUPG2raiY4jfzPBwWXpVZbs52AvhVTGZ862ZNvjU0JDZ7Pzbsv6nat8ZK2BuqJev1gkjVNZljHvvfDK7MFxajIjgBqDuqnCXiVyi+90dZ1rGP9M9RTMAxuCW2hyElxJVhklHcRWrpzRMIhKT1DuuxSuWVoGUeWvZkHiMmfqpDxhTG9Y3vEGIS6yMrufGcAS9LJNufroE6jug1B9882pEcwk+jC3BB/52zC90LjSfnVlZrcM42MyBKjdVhu2oTH+MpsDTeQdv7AQqQRosG9XKsZXVU56sCD7byslN+ueUDMGhqX1bkuFEpVbnYF3/HVIcdcuU9QY86BoGdTzBQsQhu0BKc2pXsMXrW0TcP9bg5DLLDw/t
 ZKljWKWD
 UsIlLaDCQrpPKxtxfuffIPrGEHRtSndHOthyFgqVQCCLGsIig4zm0erypNSg/u3Ak/gfmJ7icNq8LM4uBHvFUHepWM00BR4zlMQfpX8fMBbBq+2e6mDf6jc6nkEmkgfKtsO2WtKr/EYOkEgc/4wim0cchM2xhBIonHTUAEa2ymOYURZoeyBQW+6bIBCzd2EWQJziQKPkdXGi3yyyf4a+ejvjHbdPwTR8WPhgwcmKvBYbxWYRXuAg2jxcOKcTtGk9cXQwuQQqmMhngVgpiOOCzuPzzezkTNm50pNpYpO0FK9tNx9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mremap_move_multiple_vmas_split(), if data is corrupted
after mremap, the control jumps to cleanup without marking
the test as failed.

Set success to false before moving to cleanup.

Fixes: 7d6597dfef11 ("tools/testing/selftests: explicitly test split multi VMA mremap move")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 869df22d46db..3b42c4f2473c 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -691,6 +691,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 			if (chr != buf[j]) {
 				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
 					       i, j, chr, buf[j]);
+				success = false;
 				goto out_unmap;
 			}
 		}
-- 
2.53.0


