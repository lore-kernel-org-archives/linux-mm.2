Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C424ACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343316B008C; Tue, 29 Sep 2026 06:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AE16B0095; Tue, 29 Sep 2026 06:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196CC6B0099; Tue, 29 Sep 2026 06:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D27F26B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:33:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FD8316049D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:57 +0000 (UTC)
X-FDA: 85266439314.16.45CA781
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42CA240002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tlFw+y61;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790678035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ln36BO7euiOW7S7QGq0ft/jo3GWzY6sSEw72jSlBCqI=;
	b=BN+bRICS94GCyVqGW7K4sBa31UdthQA39gttuq1kQ9mIb9mB/OJINqhlbMWxiOv11M4/B6
	DxvEmzzYQYra/9DRnV88hmm/VGMbjkycP8+pShjzn2xcKt5LKJr3DTLYDw/+RrNrsY4esW
	Geudg23pVaquZIY7i9QtgDV0ZxiSDYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790678035;
	b=hTbnlUKCwiBQ81LUzYGKxj/jla2Pnmev9aZ3DHY1aCoSa+jQJYRbyCQXK5HsYtV7DoeJxr
	V21sUxQWpz8/nahKRjf2LW8qrJp1VU5RughxFW2Qq0QHU01PkniN+8TPH3M2x0CL70YDh7
	zwFKLSh55DkzDU/pamiHDIi0kqDRIE8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tlFw+y61;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1227C1655;
	Tue, 29 Sep 2026 03:33:51 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5005B3F86F;
	Tue, 29 Sep 2026 03:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790678034; bh=mkwLp2NfxwMWmC70wWGt04V85mSXhHKHK1Y+m2eeVRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tlFw+y61iB5s+8IQHPmtgcMO8cXR2JAbgxLSD9hLvzBRQXXZBcRz9YkolBxDPjOGd
	 0iFF1XAHLk1/0VgkIRn78mzYrs3FzsAtShaUk6DIPTLGBjai5V3W3KvaF2O5jcwo8B
	 vz6Lmkpo3yBJczPUAWsn/ehsppwqxfCqxKx4rUJk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 29 Sep 2026 11:33:19 +0100
Subject: [PATCH v4 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-fix_khugepagd_fail-v4-2-2169c18f2576@arm.com>
References: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
In-Reply-To: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2567; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=mkwLp2NfxwMWmC70wWGt04V85mSXhHKHK1Y+m2eeVRM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqu5QHwdcomYjcL3H3i/yKEaWu0SMT6mIQm9r75
 H1OgyULYUKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaruUBwAKCRBt1cPRWsUx
 MwiPDADadp7fe4eoEUnDXlsYxQ1/AtQhQDRC5ZGZJYNjHhvwQdp6NJs/6vXIfbzBhHzJRAHf9Ae
 Xdlk3gmJBZPy0WloFUm+2v8qJ1r9F91z2TgbA9mE+g5u9fYvM8DTz8G0UXVszhkF8FGGYtiPKvq
 th1Pl+kaDMrOnW+4kqipK8mikudxXEpKhFBW0OJt5uq86ZuS0q3WUhE+9yUMm823jteeFAh/nwx
 eFe1cyXYgVL4AbR4j9yx/4yM5+YGKe28OI6g5718xntqO/2QAUpYF0vast/BBV8iyUF/5GpZ5aR
 FwT82graQE8bq3bFbrARYwC1FvHr+N1+UCDXcgB67zGx+N02kQdJ5NVxpft6Ro14IwVi1uJb+AL
 uMwSaikb4bZAVuANRcWRJfd9DVIKZqw+4muff4BGWTC2NSRJbnIAfikPEqT6tQeEdIHqC7AgriF
 eiSe3+x9ZLuwfFPow8wxf1x+ewzHbZ+1JA/bjqjqpN80QSHaCKlGqO09p4dfjY3K4tcRY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: joor7sk3tbm1cw6rx6x4ca8yft5j535q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42CA240002
X-HE-Tag: 1790678035-909895
X-HE-Meta: U2FsdGVkX1+JCT0KgmAW+c2a9i9Fx7Yu5BGhVnU5Av5IvuqIkWI5JKq16PGV3lvscXURpa7PuWxaL9+I27kJMSidK6tysCXGMTZGMOO11IMUQBCqjGNDg1E97pJLKlHsKhPhSKxqLlMvQxaJSGbX5Y4GUhWzHSxRJCes17AJuKKXbI3/JQ1QNkl0AvjagAM5CvHGFvbReYd0HV2jbxt++M00a7GqkEXf5l5KpS3PaKQCECgQazYrNFiKSNHPMQo5UmUjO7Ph2zAv9AU1SNHHU1A3CHB4tMDAiPOo59AF6qoDxXN5x5jYpDX+l/AuAW7mEIfceq1gzujq61LFpXttpePubouMB/xbDq6wIUsdgyupIU+dkPviZjdFQ3CQEQgr+PDKTZzOtqZWSXYFEVcs1s8CMqvB55Bt5CO+/QQTNjHLDG/o8FBfrhQFBysQf0I++q5tn0v+p7RDno5hJrVWskZ+NWKye1gIEMf/AMe4qEfzyyxKMXf1TDRvSdN5gcdtOHg23KmkIrqJPS9FUuDVcSeokeZgxKSkK+GwYh7WZ4NUY5ghtV5tjPzGtRzGq+fDnU6y+Jzi4w2ZNh6aZiESOIPUuESTxAzCQ/346TIBiwI7VimAbaUaaa0TaV3HtfbOywQA6nU9ZbmZzXYXrGPC//7yGoqlVuwUthO5wRCodZ04xgQjHA6oShVosjElN3fDB9WOLGU8LFJExtNrdRQeALrQ5CTngiHW86LIdtSKJnT6G4P53a/RNIPCYxzqbXfccvVMquuMwGP/kLJFyPioeRX3lbCZqQd6Hqm4A6fvxGZBDtsUgXZae72HyT+2H4EmlM3EtQbVayzra71AdWjw6+eWkkR4uu1zCIFA5/2CWq/Y+My+IJSh06lsejSunUCLf3CUiqOiU5Xu66pD2Lo10MHr8bM9wPPtwNlewI9YLeyb2sdrHjFwhbd46mr3N+eRl2YtUpgYL+OIFGHl+1E
 C3O/ZhoX
 ZBovg+5C5bzcmf3S1LKEZ+l0Wwjyftf4QNpJwgzPkTqQ3CaPz1xZ16cu4Jys1IamFvT3E/76sBkJQqlWqX/Nf+ITOOxOjqHQp+M9/+O3mdNDBAre4xaNh0TUSZ/dbc9xarwDeEjbZguu03xHAAtG2lsVvYgtACGhJY87oEWS0t+3XQMMMWIfOlrq5k1CqdxaiuEHHLi/O68PHLvHRAQIjZHtO6BSoe9lIU6jgfyuzWqTRHx4dLZUL/gj1lk1kgFa/hp0uEzja2I2AgwNdUxc7fKyGnz5Q/CX1HtUKGlJnBPMxZHdHhTs8nJ8FCnNRWrK9YuZg+8dcf0UJwpiWphIHjrdBwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  // while running ./khugepaged -s 2

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

This failure was observed on NVIDIA Spark with 16KB page.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 2aa7c9197158..4e888b7bf310 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,16 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		usleep(TICK);
 	}
 
+	/*
+	 * The file and shmem tests rely on refaults to install PMD mappings
+	 * after collapse. MADV_NOHUGEPAGE would prevent those mappings.
+	 *
+	 * Apply MADV_NOHUGEPAGE only to anonymous VMAs to prevent khugepaged
+	 * from unexpectedly collapsing pages during the test.
+	 */
+	if (is_anon(ops))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 

-- 
2.43.0


