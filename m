Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F16606D83D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SYAFCRmR
Received: by kanga.kvack.org (Postfix)
	id E375B6B05B4; Mon,  9 Nov 2026 07:32:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EBB6B05CF; Mon,  9 Nov 2026 07:32:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6C36B05D0; Mon,  9 Nov 2026 07:32:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1F116B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41EA7A0667
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:41 +0000 (UTC)
X-FDA: 85415519322.01.0B2FF2B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D9A6120008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SYAFCRmR;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmOohr0y2TE4TjPI/p+yd2G4mqQXEGFY5JLNeNktYvw=;
	b=nEdjfsNLjNZsD5zAdqgmEhlHFArU33gXiO4Q7RGIJDtI05Rql5gTODKyxFHBv9Mc+KeiCQ
	jPccbv5QXuXFrb6ZzK9ISJxODqvtohEs8lvNKmn6O2rxKyO0+2RK64uYwGEFhXq+7mkYko
	BFXRtxLDkeUV0xEwwFCEkkXQWVOKn3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227559;
	b=Gwoe1MbgjZdo/f00N6MQvBh367Qe2mORLawE8f0aAHJF13r5esSQeUjQoUM6U8dMkUeHE1
	2iiLB6cta0PnSlXIv12hGc9PHtTiWpNJYV2lIZmwsIesEYCp9Jk/LeGwPK1Y5Xpn6wrNsD
	lN8PUvCkKJf8F5PfaT3X8IS6eQsv6ek=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SYAFCRmR;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B23B1758;
	Mon,  9 Nov 2026 04:32:35 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 781543F632;
	Mon,  9 Nov 2026 04:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227558; bh=kDQ/Cw8E4K7AyiySq43gJAAEkO7wMAGzc4Mi72irbQg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SYAFCRmRZF5av8uUEMW1VHc8giB65KCiDRWB5ILYfuIy2ICAtkg2hoGijXazVkSD/
	 0Dc1ll3Hnjcu1N/vrb2bh7egicr/wbGHESqmL9eXQ2T1cn4VpsSWo820SSeIdOw+vs
	 6xpFVIvhJvDoCAOpXq4epLsJ2s/CNjmtCBhsVRCQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:26 +0000
Subject: [PATCH v3 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=951; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=kDQ/Cw8E4K7AyiySq43gJAAEkO7wMAGzc4Mi72irbQg=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1drpWHASPRHYNJhjTpYT6414cQr+xJVq4uI
 5/OzAJYSKCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XQAKCRBt1cPRWsUx
 My6NC/4j+nQd/JxG2RfLWlUTYv7VYPCiN2mrXzJocDJRsKJMzD5BIUlz59oDWHU7PjBP78w+pu5
 O3nkLGAW3+zpjXTDZpYoAbqCrqJzxppQ0hrf2aQG94xy3ssee4/dNgf6G08BZAlSsR6/ojqg+1w
 TuVwjl6L719P1qemy84J+45X2ee2cPUYt/ok5WRn9t/XvLYTshm2se9xh3DEaRGMtwgBR3XDscx
 ORY2qI0F6NIe7p9kz9+/B9iuKUWl65NE+Z+ekNu5tntJwAzHAkcNpMG0PssXp/a+gJSxqLWQO8t
 HsdrTn6JgMlv2KpMygKxvCd0Z/4Tfd6yMtuInIQcny1E+YwmeX71kyQgSb+iJ2A3zomE56N6err
 7Dl35rVwofyUfN0lCalqDeBE2eCfXH0BfunbGCYtTBhyNrGkRBUlgGgXX6FOlPg0rW/GO1wqOCE
 M8LiXDff8G6bUS53SAsfPbi4t/Rkk7107qpgy44pZn+7V7jjj3i03X9FwUbW18GQwIf8o=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam06
X-Stat-Signature: j3reknu94deo4carqr8hubiaiaorfkru
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6D9A6120008
X-Rspam-User: 
X-HE-Tag: 1794227559-45408
X-HE-Meta: U2FsdGVkX1/L5BdtnLKqW7WTw0jtHC2JUMk7aZmwhaAcctiqJDaL/9jOJUlvxJgiC2/PaPua0kp2B5aYxnt1c1A6UtKi5yd87m7ln3v7Rdlv7GYjAFx6dLnXwFW7nu7Cr0HQD4FoJTlRVCXdE1wc4Fgm/UeV7C9KBhWbAFKQtIEu3SJyRXoqjyDEcLzasm3Ts/JsxLc/sqS3p0KXfww95jHqqYwCI5G59Pj/wERkfaGO0/UZmwbU6AXySwFRzgjs5tIw6+g5j05rbs5Ud0m55PE7jmORobhVdnXqtkEx3KZzaYL2PYH9xOh77n14vsd2rQbb25YmnnVxN5P2iHTnBdOCHEIDpKdda6nChd+3KM3D3gCytiFwcz23roRAtnQKuFhGEcTXJR/VhjksQxLH7WXUwl2GmG8cXZ5Qn0ZzSwL0sLZejW0qaRko39Ol733IV8+ljOeVqP7tBBaRY9RbqiLU86vlUe3mXzYMVZxaEdtOSxpPCWYcRyUEIHQMIBfJbywr5wjVrhsaO5fPINbXqvn3a3hqH6UR46E3Si/RxUs4SpiHifFNiNWahsY9TzNjc0qSAwoNBQ+ABBUdAFwgdgE44ufBJWfTBFACt52hfJs9ivRL73VLyTgLcslY8bd3v8SVoVKfNjSP0ur7sGqzVJqnSk09KEyfNjG8zMzjQrLoWJLygLBi6CyeMfChMjfS9FD72VOdPPYEjrCSJdvT/y1/6DrzaGF/9J4usX5Z3Z/iQAJF2OQxtoa+Y2x6SPzkd7POVJ9XgVms0vCdWPR7crZOa86QiVbwhAv6MdWMkVpYyjfk8TBNV7tVFbqM61LdByxF5oSa2dbwa6O9pTOCHUKOuBZSdN39klFUWq6QEIdYMkphr1NLgy+J2n+QSV+WvGMhA0oET40FePHDgTIIMujAyaAuC4tLNpmDRyBXJ6I99gwagFbRSyPwd6NUSEtB3H+TomYrgZ0JkFLqyGj
 /MXaQif6
 8SDxCE4T71ryY+rVJnjNkM4q+vHaB9M0XL7lUUVjkA2Noq5LmSPEwF1iG2k0B5j75qQPbM8eyiYLmnm8KmXS3pLyRsMZiIO8D8xocBtKKBohKlFYfTSpAk1xqsriaHFXaDYozkqYQWXQNihlJlEdL475VgC8SOh7QNk3GwzH5DTseGEL2dtrXQNKnRMtl+wUZ06XV1GUbDsqEeE6aTsDQ1rudZldYahPOPbviCXuDvWU3GzJfjJHsk23M774wnEWnRvXsdzbv1AAuaewcd5SyNTvavVjDNb7GTyOVeulEJ3372c/QSUUXbLEAGpov76GoNmpFd3BiSt41CmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Clarify a reason to check pte/pmd in gup_fast_pte_range().

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b246..7f9348c633d58 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2881,6 +2881,14 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		if (!folio)
 			goto pte_unmap;
 
+		/*
+		 * Recheck the PTE after grabbing the folio to detect concurrent
+		 * unmapping or protection changes such as by KSM.
+		 *
+		 * Also, recheck the PMD: THP collpase can detach the PTE table
+		 * while its entries remain unchaged. Checking the PTE alone
+		 * would not dtect that we are walking a detached page table.
+		 */
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
 		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
 			gup_put_folio(folio, 1, flags);

-- 
2.43.0


