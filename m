Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421D2FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF246B00D4; Tue, 28 Apr 2026 16:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F926B00D5; Tue, 28 Apr 2026 16:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5CC6B00D6; Tue, 28 Apr 2026 16:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8921F6B00D4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 461381B9785
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:31 +0000 (UTC)
X-FDA: 84709147782.10.A742196
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C29D180011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsyGB1L+;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1liFTyal4bSjbOvk5FshkJIBykh5rg/CLceE50C1rM=;
	b=xvSsDcJ0+cdWM+oBgfKRFYeqGG/C9dAlsFK2JB2egKY1nNxEyMp2yWWiUEryTgnHcYmqOP
	Z6gecjWlQD5LfidkrHVHsTWvz+8BeTQah70BIKtWFeYnbJLXH8iWXzVcP8BJ4v+vy0pum/
	+o0l2eGo0i5oOeGy5ecjLHYQ+bdPeO8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsyGB1L+;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409189; a=rsa-sha256;
	cv=none;
	b=8DE++MyqIAYQPCtcDb3ztsIWEzJrPvxyRmQPLfjjg9E3VcPKqIMbQHbiySD1KXc3xTbHl2
	a298KCNMbyDNUCMhTjIRcMh08UbAFIJDzWis5F5OVgDsKK0CbqnvizPkByu7v3kYbj3c37
	KYEadIs8SWHELMfoqZlp92QjirjXhJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE4F240A57;
	Tue, 28 Apr 2026 20:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DEAC2BCAF;
	Tue, 28 Apr 2026 20:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409188;
	bh=a9ftjtHwEJ6B9K8hvRWelWOu2y5v4+ZMDsKskwzolFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsyGB1L+2irCrH9CMlOrIHyvURQXKBlWBwbZ5sU8dOaMwU5IKmOlS1ll+gFZmc7bx
	 B14cXS5sleTQCEX2kd2tGAzu6RgHb9/LpiqlCv8sf0RUAZEqsJ9pZ5jFU3uqU3F7ar
	 dg3xv5/lO54wbneplHMrptRrlNcKil+QiU/hbdxVUr3PnV7crdSOEjO7FvHAuGv9Ue
	 QW0ZD81BwB9wOvv5sD3NzHJSgHJs/EngSwh2jatzDNIqyMFW2sQhpZukwm80lnSRIA
	 l7aPl+0OOB3Y0Ee1QseaN4GePbYlodZsf3kiL+SmisFOYHN8CRJGH7O7GPogW6+F6S
	 156VBlD89XymA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 33/54] selftests/mm: gup_test: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:19 +0300
Message-ID: <20260428204240.1924129-34-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfw6mfpfxgg3mkms5o8ojefjp83ag9sb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C29D180011
X-Rspam-User: 
X-HE-Tag: 1777409189-809649
X-HE-Meta: U2FsdGVkX1/n99y0LmTZqp0frXWjOdY81+opM69Cg8IjpLizqbpB/bwkd2dSemRI+FziSDLntHa88qRJKH5p0pNojGxDfS80KeZ/OEgyyv1PDebve+4rfa5MynFSTfPf/MUgXXUWkq3dC8tZy7X9g8pJz3X+rfzM2Ixg8uJOTsZc/SuE/9n6aKkciz7Wc23FXr6bgP1VG1xfk9JPu1CDY9D5V/SkXaipDJeTyjyButIg4HnAs8VpknPB5uAni2NjAa6Ce/dCE1yUylYTB5MXZ3kGIR0V28kg6RRtn6OYM5lz+JNZIQvc6hP1IhewNMzX2i0L6QYcrclV6Vsvlk553JGFTIDpvISzW6M48H+CFGGKnx5SNal621ebO/0+pP1OpxvaV/kyHHluK2i3qVEUcUUrN+0PMa+KLcZZnK45pO/hbr00z+Xw1NRSN4fI+ywi9cWVf3+ipC0Eqec/AnZKk4ss54Nz8qlm4QxDNqJ+I2TO2poo+VRis7bwBb83y0NiXSOd26i+ih2HUsZuNZIiGeO8/F2L5iVKHe29TVYPHl5C5+l0peK5ayLe+0KT5vemTGWJOEFu4kY3f7hMXqzs/ToWlGR5GASz0Y0rLSfVZ6vDdW7qCgYtspF5XZYDdtwX9Zsk6L7nKCBF7wObTkugFGbCm5tie4tFYc4RkeKJpjBBNDjY/sfF4vknWVZKdhUNF+O/urhkZG4d9k0yjkQTT/YUwd10krb79jsr3YgSpR0nAwBj1LrouBdKxavzc+RAbIfdCRCfAdi3IyzMnCDdQS7IrKZ0HkOpvjAVZepaZDmW1AfZefSOAdAfvO3MtOncL2NpNwM8w3DseOPwtvahOjUj9SM1NSJviq1qNK1gC/kQ9SvtSO+Lg3j6jajlSAOqzLfhjhRzcqT5Xfl45GkLqtugarWH4nvEC6ZAI8phN6KppPi5rMwVtJKOTrzTZZBiYueLnK+frfU2oMW4yY0
 NXJbTzQr
 xfFccEegVCQsGe59WmWUi0N5DaD7UQNty95rn0X+297Wyu9RHQFTPlMFxjsLXaBIt9KZGFMTmwcIeqUsmfifk+yHHH8Cb2PU0XDnkxuFh2YiHBt8euVzfrOLt07wGvELlaxPV529NVLP/msK2P+tWKnaRdyWLqMOBgw1squ3jlh7zBR3oKBXYo5TIL6JFCJcLgrTW5GVD+WHc57ehBlVJCcAMawHaVfyqFfGRWv+q0iulX/LxrICvXnPuGILzcB8UunptuvR1uTYGU4rrQZACiFp7uRz/9n9K1YHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

gup_test fails to run HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the
original settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index fb8f9ae49efa..ddd239a69881 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -14,6 +14,7 @@
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
@@ -94,6 +95,7 @@ int main(int argc, char **argv)
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
 	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
+	bool hugetlb = false;
 	pthread_t *tid;
 	char *p;
 
@@ -168,6 +170,7 @@ int main(int argc, char **argv)
 			break;
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+			hugetlb = true;
 			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
@@ -199,6 +202,15 @@ int main(int argc, char **argv)
 	}
 
 	ksft_print_header();
+
+	if (hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		size = (size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(size / hp_size))
+			ksft_exit_skip("Not enough huge pages\n");
+	}
+
 	ksft_set_plan(nthreads);
 
 	filed = open(file, O_RDWR|O_CREAT, 0664);
-- 
2.53.0


