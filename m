Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44089CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18CE6B011A; Mon, 11 May 2026 12:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2856B011C; Mon, 11 May 2026 12:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891AC6B011F; Mon, 11 May 2026 12:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 736056B011A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A33F1201C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:54 +0000 (UTC)
X-FDA: 84755683068.18.168C3BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9D8A120005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NORjY/Q3";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5hZ2ccxW/tRptbdwqnfjppjmEUHYvfgti5WHj1vI8w=;
	b=YoOJCxZIxyMR06+b9XkCR+YS+dM7YUGHaOeEBe4QLxC2FMlUHMaPjUpaIYsk+6Fidwu51L
	5zugiksHnbAr7/5DCNTmpebYbUWFRlC3vfzHIVyNqTQxvXBiBVtBcX3oW0f9D0XYrQLN1Q
	ONWiv93MTvWfJNHWZY4MNe65Gp9tfjw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NORjY/Q3";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517172; a=rsa-sha256;
	cv=none;
	b=aNpzTBFTlx1B3b//8vztbnO5C0r6ftZyAZ2GiO98+EDlDKOk2/bvILyViqwzUflYVPhWWk
	NvSDn83zSKdylBZAXQxq7imv9zdUelJE0Dm3eo86pIGjzevw/4rXaG71NyEGYjWL449Er2
	kLgSUBxiMFHSxsb2jWHR8LfN8igFZ8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 135AF600CB;
	Mon, 11 May 2026 16:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EFCC2BCC9;
	Mon, 11 May 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517171;
	bh=oVx6caxujs0GJm4PzOdNxdItHvCSRDnJxA7+su/xLqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NORjY/Q3jZtVtWoKKLRQSytsUZMG+fZhPSKqMQZfxmzwgTDZj78TcAmXNYsmeZkCF
	 Q83S80IsISqzjkewq6Ym6dKdnaoJR6fLThQrJj+MfEar5Dye2fgLxYgfKVxrGXnz+R
	 ctTYWKe0Sha2ssJRMWbRFS0/K0Ob49+jk2L2SsQUvuWHftNc1fEjFh5kGxTXG158cY
	 qT/yZilUN0qIunR0cPbI84P9HtOe59sEswxejzkn5SR6MT67EoC+cBLJURbxlMksMj
	 t+aSeMyf4qvmvbOLtabGeHdrnfrtD3hq2Qr+sFYMqZ2MVqc+WBjm5Uiu+Ft9qV3Z7c
	 4FsmWCHSCHb5g==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 37/55] selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:21 +0300
Message-ID: <20260511162840.375890-38-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: atxydy6um7dr3zugjjre9g5hejwc9jsc
X-Rspamd-Queue-Id: 9D8A120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517172-439114
X-HE-Meta: U2FsdGVkX1/uh/Cianc8wxx9P0itgC+2oxe937/KP7l2zPpN9mnTPGDNqZJcbPR469EDS7byB00ehXEvZ/4/dg5/lkYkw1EDB2ej0kfGdVNcFksbGit/lmSJwtIPaDvj0cdaqyHmwNUQDL2nUyi6zceuPIGJ/vPdCY0pBNMrBxxeEfEWtpHK27lKH4oPhqKBWVz34Ulqp4tKB/MmgGNBq0ldSdDyX8J/wgyBEd8l9lgiydLraPQQ0pOkiNaoXoM8+IkMfteMUsFk3XNHnohAfc1H/NSK9L31f/+K5Fb5u8IOjxUzpw0hVsP/3K7+Oo+1pn/H6aI61ruuYdJDzeIOmougSiIopvxy69C8jRYeEw9tVaHtTMP3Ae3miuRyfnbQUPVkt8XZ8heZqMHuXM47T3KBYkWMbb6td4nfphJyqGLqJEkVAzS3vB4fIpjOPcZicRYvAOh8Dl8yZvoJaiHJZUcVA1xi8TPRmK4/a81vVTxw/yQXeJI8L0GRB2Sh82ujqKSBJwfN+e67Z051m6j0o+pOpSxsUNpwgeSDu42cfpJcq0ck2nVAxhgJDGDEuWKWadvxiN164ftgmdebxtfeGsVtuLmbMdvkxHy7LQMh1vdsu8FKq8oVPKoiOru8gEkP+skWrc2EijY5rE9c2BcJQvvUI1q0lluKeYgVFjsi0Lx/6V7vpe1sT/O0krN1QR4Q7rRMBYx7/rHssfjFWQPKieC2jmDoQPpTOJoSaNA/JBqdcTKmGvt1h40kdfO8LtNjHdxUieJ7MKCq0eFOuKGMTz6anSxzCWnvglSIyD5hVV1jMOh8H9oHH8U+5ND0vjF6j+KycVLbBqv8fgY6fWYlDasYZK0scgQ5r9VwRALfkS6TkqGxo85oaCidPyKGStzA4IhZg0Cx5wE0kJlHwGgs9HiiFET8TDWoEyPXtcWbaHSaiAMqNG/+ihE8Nssg8Bhybo421sH9BgpBalvnmQD
 ena3uJr5
 1fjgd+WsRV9ZDAAqVp+DII7X/2L1OYNaBlmr+kvAhhckW5EA1XtPcBTlWYFYZX7EzPZ8DMDJJTlNxHXTLD7WHQvxDKsk7nUEBjzLr7ay2dqoNbuSvg/9eR6k+/mInGVNejDzUXF8N5ze9X0eUPG7Ayy2mn/bYl5U6hfCJP96Ky7lB5htuYKpcpjkA1UO5UxF04WFI8eN0FKzOw59eytRFlbUwsjr40cLKfG5koL5IZQr6apJbVjr4fDOWVk1sQzjeZXrebU2Tm9eBbhQK8vTEuEgQ5zDVT0raKaFhRNBsVfRkjfNqmx7m5s8p1C3b3WQrLre/lXKaFkxxIVQYmw5cdG3EMFTenF91lNqmAemyBR4K26w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_fault_after_madv test skips testing if there are no free huge
pages prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index c718dd065d53..2dc158054f66 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -54,7 +54,6 @@ void *madv(void *unused)
 
 int main(void)
 {
-	unsigned long free_hugepages;
 	pthread_t thread1, thread2;
 	/*
 	 * On kernel 6.4, we are able to reproduce the problem with ~1000
@@ -78,11 +77,8 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages != 1) {
-		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
-	}
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough HugeTLB pages\n");
 
 	while (max--) {
 		huge_ptr = mmap(NULL, huge_page_size, PROT_READ | PROT_WRITE,
-- 
2.53.0


