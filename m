Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8823C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6956B009B; Wed, 23 Sep 2026 11:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D8A6B009D; Wed, 23 Sep 2026 11:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B8E6B009E; Wed, 23 Sep 2026 11:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1E586B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:30:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8A241C344C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:30:07 +0000 (UTC)
X-FDA: 85245412854.10.91EF1F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6AB5180003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:30:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hw7PCCi5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNwdPkLd7Vui40PrCqaPZiVO9PtF/6M7uw/0y6QyiqM=;
	b=25uo+SSDlvZI4eQtwnchdzuChYHLDs8IP+/ucAMKayJ8m/7oKADMgTyS7WNj2cwyZveyzL
	6d2WnMDnYflsaFCtu0oTqsQMOF1V63OGfINFGf8WM49Jp8dEThvgHUoJQm/Lu7i2yTeWcV
	NNRDrBCSQBxQWbsFYaLUNf2/JIykGAk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hw7PCCi5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790177406;
	b=zTS9DMiPyXYekpK4Nlfl1RgXPetP8/bPZ7tSQzNlm7Qyb7hgqI91n+i4tmd970ZAD0oTCK
	/Y6+89+eUHjhrcRu1WRgrYZZWZ8u1aKkLPooMiV0n7fc8/pyyedVV/VcM13XJ9gmKOpvkk
	zhjeb94w8Zhucc/SBKx/IcqcwWRwAEM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7073D1713;
	Wed, 23 Sep 2026 08:30:01 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E96CD3F86F;
	Wed, 23 Sep 2026 08:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790177405; bh=ooA7gnlKxc89gO2WIVt8hrp3HEKHzLvwfAey+X1/t9M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hw7PCCi5jHR812P5EOIWZclw4ZxjUSX7JLRYhLtXpc4HxN+39wQ2emq3aKdgcXiCz
	 OT6hV4qavToaDNJ+zoSQwVL6ajNpche0PPLo29kcABl2/fOrzs1rVcHWiW5AteDIrh
	 2i/Ce240ZJuWHuYQ3pBFOjzB9p6EnFf0JDjPtyF0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 23 Sep 2026 16:29:52 +0100
Subject: [PATCH v3 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
In-Reply-To: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
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
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2212; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ooA7gnlKxc89gO2WIVt8hrp3HEKHzLvwfAey+X1/t9M=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqs/Bypoq9vTrEQVXeB9sf2lJpalwQjYUcNreLF
 vOel/96l82JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarPwcgAKCRBt1cPRWsUx
 Mx3nC/9rvmyHURuLkgtUmXfMQosa4eCGa9HReNKzlD+EjOD7f/wjyIWVpohxdVXx/vLpw/ulWB9
 iHZFGNZdtIxoDjqOymdosbkanMfOpGHaZxIKADZRZtt2TwN4r4qGnrZvdohg87UciEO4RpgvRon
 TTu7Bv/Q5XVSsgFXGn9Nz5LWZAKpc/Q2Ebb1zQMXIJ9UqWEXUUotizO2NxxNoAikI6lL+aEQEYV
 mOaVNYvlzlw1FgNrSBsxvAD8npp6X/HXAz+EwGj+9imiQJh8ib/LJG3vFi9caum2sqZjR2ep9RL
 39LIF2Z5h22jz+UIDxp+pzBOjumlsyrw6CJWXSb8jjn6wFRLul3baiVTWVlx01hvJRoaSBKVFBH
 tglhp2rHCHSOjezEqGVEzqbH1xobmjrJ/GvbXM34NyjJr0CA3+11u2iCZrJupelN6kRxeqQoIza
 fJx/uf6yBk6sgKGG85huRI64p7jO3i8mbpcUEkuqpbscOk+PyibHYtDTqs77i4+s8J98U=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ett9t16fqt8kprmaxttm4gcdb3ki5cpr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6AB5180003
X-HE-Tag: 1790177405-242123
X-HE-Meta: U2FsdGVkX1+AsO6ReBS/rDttaNQg+5e33V7CMMmndNfPvY83w2aNzpG8H6phMrpPm4e0IUEUhPvZl8Hap9gk66M3nUYF+4Kqd8wv6ln1OTAFnvwZ7neSM4AS4l93ab/FuV67Al+jnPSQ1O5kmi9wS4urAt2a6O99xBq23Tsa9nFABGhNvvhefKiWazz0pNU6cQaaC7IjlBCKwkc+lWb/sWudTizwTs4y8P3X0B5hsfYRh9DVE2LR7VQy+3WPqLy71/gATTA9Jr2hBT/gwnTADMrr1qONCOQXdHVDHFhuOPBbCZMcCSt/lkw168Ty0+muiHpn9CC35wnQfO4H57TmLWbUgHMDEnv3OWtRPEMjIXxIl7r2O0abGMAp0ur88Olg6/2G9z5+P+r3YKR4EdjUjBxT8wQHfjRPnxoy9IPwfUg2FmCMER1nv6JVhIbt1wkX+ZxfCfImedp0m+Lfwqzjzh2SgWelZDpvIfLmV7U2D3j40MBlWaTKccJR9ycYEOxT6xGKtSqhi4d8UvBAVqKhGB4My0feAenes6aEN5uZFas9MojXQvQIqPlX0SGQarRnWpiyNeUNt2TIVYIWoYKcc6pMa4+zDIw/eGGe3hqZyIy6oRskTfxC/ehUEqeyUp9MkEOHv6j5sInRZc8EirqJjqoA3ByUM3cqZfr8JR/ubD2jmyg4AewU99B6HirKVDNPI4GAG4B36ONPA34mvTYo1rpbF39xth2fet0T77kB80IQvf16koIVF6ETGsv6BGbL6Rrtk1hbSU7zmUwcGUfyaoIG3I+1H8mT5aDSdOQ1U9Hb02outaw42YKVFmJC0Za8pn2hL/mpi1sbwrsj5dlqbyYRMPSw9RWHuNHvEXMCcTBsXoY0lydlscCzN2nTAikqjOq4v/2BgPrWGfoNZFXGM1OgiympmYY9Dd8gYyfk2MdGSfQnZs2clYbYkifsYfSrmkTze8d/Eln0FZB0UUY
 PHY0ZX2y
 4wk/m8gyTZhQ9qRvJEaRathVZMeuItLlKvQ3kO22YadQwCkiM6xeAL1rL72nr48oUPTa3DqZimFWxSRkhcrnCE+viZv5vUNQjwp/Ri/X4b9vhpltGMUA9BV5UZ2QwaWtDp36AgLnE5seIwlX1wcejqqhmdpQfGCvyL8SvHNZm15WBqzKiHMEdY2JB8E2eLUSEOUSbMx2CZ+IDjm/IpIi9uwIkup/aUBwhObSV6vvcMiwkJd8aDUPIebCwN2dJTehWI1HlQifq3vJS5G69HjRJKPatKw==
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

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 2aa7c9197158..b0cb02bf1a73 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		usleep(TICK);
 	}
 
+	if (is_anon(ops))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 

-- 
2.43.0


