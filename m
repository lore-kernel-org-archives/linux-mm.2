Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B08C60A2618
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oggoNVE6
Received: by kanga.kvack.org (Postfix)
	id 7C60E6B05B9; Mon,  2 Nov 2026 05:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E496B05BA; Mon,  2 Nov 2026 05:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5A66B05BB; Mon,  2 Nov 2026 05:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2906B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4549980BF0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:12 +0000 (UTC)
X-FDA: 85389741024.08.4D136B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C04C2000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oggoNVE6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLJl7tHYyqsVSgJSXnHYKfYb9YBDkTE3x4o0OFxJB80=;
	b=xDGxqgJRkgs3kU1YWVEYTaf/iMshRc+8kSNCuT+6CY2xB0BYghhtu4PVyuBuiI94PVAyEV
	L3PXTSMdHo+UCvE1RdQamxt5A+e3KKVdY6spo5Kc3RWOruyHg0uf8Y9DXnXXs4951fsTR8
	LNeL5ynN71rMy2lPne49DXas6vfapkE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oggoNVE6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613790;
	b=CVqkHq63Z/CCAnAprji5O6/K26bEhq+iuHZgR8jeODX21fDY0pyLWW5fpgWqv06Ch7g0L+
	czZpFI88H0bizcjHtNl7fPvmMZBe9aFIaMpAulha7R+UlBXx2c4SVgo9luU00E3iIuzt68
	E+X+rpkEgTlSvzbqKe3JhS2QHe2K9Gk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFD091595;
	Mon,  2 Nov 2026 02:03:06 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF27A3F59E;
	Mon,  2 Nov 2026 02:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613789; bh=Ttm1dj3xog/EvYXD/stjuLByL8Zq1uoI6O1kDGbtgtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oggoNVE6OH8ZVyjaORu56ojOIc7H2HalRvRCwF1lc/mszQIGr54aqpVWoafQK7Q64
	 qCbGMlcvoXcAhVVF5ag1kfEl4NmFfFErsUZQlDIO9q8ykht5ySflRmZ4I0n9Iuuy8T
	 q1YnX9BvChetLyjCE3qCAuRqhDQt40UM2pogpwOw=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
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
Subject: [PATCH RESEND v2 05/12] selftests/mm: mremap_test: skip test when userfaultfd is unavailable
Date: Mon,  2 Nov 2026 15:32:04 +0530
Message-ID: <20261102100211.141831-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C04C2000F
X-Rspam-User: 
X-Stat-Signature: 1q41f3expdjj1ucaj5tz84wrya3p15gu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793613790-861053
X-HE-Meta: U2FsdGVkX1/Y769Bsvu60PzFebNkE9PpbAu68WjWxhGshFre6Sf768/dlfTSIsSYux0dLURqvFZVsYoTF/Y5hrtRm6pfu/DiGqW6YzbCIPGcOhW5i4kQUclAUMAlEFIxXO25+ypdTTKE52OTol1wDyuIxQLlI5BBghujO7o7e5tX+6ELoW2zr3/uF0ey03fGZfm4tK6DoBUs4BRczlGj0qevsYE7o3xRZApWO1SOJTrw/ReVSHUTrD3P8zX22SFo5uuUMJ2cc1U7Tn0GYSM+3lh+gOwFz8sRJbkWBpIn9yKexFu7YlY8QUPfX/Jalv3UeG6rg00oEcs+dcyOplWj5fzXkquFu7CCZR264F1DzRazOtPtOBkZXIsRT57hp23tNvFLK5P8od8LHX9dar9mYildCMTT6g8rZKTSidp9gR0v5Yef7lJePR3uAjWgqsp4F3QysgM4Ms4ISAB5CE1wSITCxJbSc5SHoxN/It0CKcfMTVJoXnK1xWLzBCMccHyDZ9MCTp9HNwD5+35Ovoe6ykX4jjZulhnO29GX+MnJUkpcBSffnHIHwAYodKiPmBmnToMID3rl3fCoDGOfCjcLc802J7KZINYuCFfMTK/L9U16H2TCps+K3p6pACsQLEc0Z170oKgjoj9tNglnrsnkSn16zVSmg5kZ3ZqvXI+O2NJQ9EG+/678g7YasuXAu8FWB2dm+8mw2uAOumTQ+G/T30z7OuBx58bJsJruyH6uSPS5FcB/vEGda6J74FI9eXo9HbZsgr+9wUOSqD/tSZVpXjyzv8VIdaN2eJh4R/DIecAG42Od8wPhUZIVOj6I53ZHaA6pZG23HIWiUgwhdiGq/aKTHWraB1XDTY+s8xTev3fFDW1fUBGLsQIV/8Amq5i540Sfh7jqhqRjCr0egYtBfkJdxRbSgf2u7deYPlSzu58iH1q62D774iUpTuf/+yOa1hJzFmWk8vQMlfjvtIH
 J/bhaaUy
 YGfZuRK01rcrAMZhWIlK697Ss5jjSi8luIwNKvfU1p2oyS8PIADP0PpPStzTWWWuXVEbPAMDAPRxhVDoiJaFcS3CA/l0Cu+fUaIKgd5AhrHUziyDZAp+FvY12x1rfLF/a0XOsv8q09/f6ORXwD1mPWhcgwZpJnXOKMW3g7/jR9muCahO6usyauUlz7+guWf5aI/8DqrWv65giJsdVia5cnxDQ3JnC8ldoGbFR5VQHCSolk/NaFNStr4p7jHdN91rsVIlt6nI7EiSmJIoP1wwJW9r1LmP8zX75GIdbuk6DYfiejYKqJDEWDAxU+9TWZOCaTeBk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
defined by the architecture headers, for example when the kernel is
built without CONFIG_USERFAULTFD. The test currently skips for EPERM
when the caller lacks permission to use userfaultfd but treats
ENOSYS as a failure.

Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
test when userfaultfd syscall is not implemented.

Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 453606b3154e..5b3ab12c2207 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -711,7 +711,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
 	if (uffd == -1) {
-		if (errno == EPERM) {
+		if (errno == EPERM || errno == ENOSYS) {
 			ksft_test_result_skip("%s - missing uffd\n", test_name);
 			return;
 		}
-- 
2.53.0


