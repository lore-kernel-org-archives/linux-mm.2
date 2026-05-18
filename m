Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8F3CD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013E46B0005; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD596B0092; Mon, 18 May 2026 14:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D078A6B0005; Mon, 18 May 2026 14:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8CB16B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62E5C1A0A05
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:48 +0000 (UTC)
X-FDA: 84781349016.12.B05FB94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 757E3C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqCNxRdq;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjVD0ucHn1y8G8CTD2iDtcUL7eTA7oU8+6CsRFNX2O8=;
	b=LiFbMy2m5l6j9kPWCza9d3NFL4rXVeHt4tHJB4zk2FC0ogLw3M5Mz9YmpTWn9+43cPKkJy
	oXeWk+mYhIFmMN+gI5uFl890V5oBVEeu3fGzn12v8zsE2E+F7gXYlVYXwPZjYhFSvTpAKH
	ucYqoTNBhFGBhLl1b9vbi5W3lXMF+sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128266; a=rsa-sha256;
	cv=none;
	b=TrVfM5zLAMeov3UEMuAH3UWy+GrD0EpD2Yu+XQXYjjGGm+joUeHxhDkv0vRI4tTl9WSJvn
	/2MkIqh0sHss9VmznwMeaesYIJosEUAw+MzLx8nTSqlpDGaWNxTKE+SvO86X9ZK7k8okqs
	aEBerlH6XWO6lY3dMILB8cyhQ/F9PBs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqCNxRdq;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EADCA601E6;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 968D9C2BCC6;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=uPaUXRhcKqK9gTwZzqyg3dsJT+ESOmLgskDTFq08dN4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iqCNxRdqLxB4wvgj9cMjt8jNzLW7SuPq6eCfmjflUK1BOhqh2ryUyskaTt7nXGE5z
	 qkhBIAxHYOp00DQQ0Iu8eScWkeEMgUgYLjbFaBIGVCrBOOuwEMMGS2vh5Pko7Z7BRa
	 F7Ytfby7tDmjA3g3Ibq9tiQ3yvIGBH14hN85AR8kgTT/i4rrlXchzBnJU6p+iAHc2y
	 fkV19X+sYc3Hh4564uiTJ/CVCx2LL5WAVW4lCpMdOZF7nq+cbRZZzEOMS07dV23ny8
	 lGbgKMuvy9GIc9yNQFSOsrBmDWRy8lT0nPUP765Ac12Zg39eJk1Wl0f6aaMdi6C14p
	 SSMH2vwK0qclQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87296CD4F4A;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 11:17:33 -0700
Subject: [PATCH RFC 1/5] mm: selftests: Inline check_bytes() function into
 caller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-port-hugetlb-selftests-v1-1-d64ba3a785fe@google.com>
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=1508;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ojhFIsSt5J/Ln9Qe8lS4lDGB7t2xMx2nI91/0IgGnFg=;
 b=aCFGbDzyqxAT6wHgkBwWRA+y1A982R53xn0sOG+7hlA8GCoWXFQxD8QyELbiTEhSynpWciYyf
 8NJ5sYUzWfbAuyRupSfrHOzNUScKBzd0pxj9IFOKrSOl1MraP43NkT/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 757E3C0002
X-Rspam-User: 
X-Stat-Signature: phi51gk3j5ojoyfuardpc9niigp5377r
X-HE-Tag: 1779128266-619357
X-HE-Meta: U2FsdGVkX18nHzHMXLo10mt9M/WDmXtJtR4HDTmYi2cnqeamRFfGUGJgYAGtSEo9/Y8T8kQIvCyYwP6dgz2P5OVfnS3ncfdAgyvYfeU6wdbg9alBqeBuQ450Fxn3D5OGk9ztZjIpcHAKsfS89s18E4bHUQzvy/VRGuNJfJvbG2cKq4T596eb1GwHTxAUvm3KD5OdWeuAOYBpUVTjkL8sTmFePtyG8LmFb1Z2KoTWge8F4IKJqD/+oOdWQ7hVB1/IJLu21OG+db4UJ3qAoF/n9K6kwWBFefjb0GvNmJPGQU8szkiG0zL7avBIGIR3ZZYMqfrHs99LDDad8V3HTBlqwxsSCXIXYnAK4SFTfH+M97fNLwGJgwSTy1bSXIAKEgh0XJh+jiIzNKB1ZcKtwG84lU1rTlF62brVi0YPJlC1fCb0JFIVWOeLg/R57DfxJiMBEVEe6KvnyF6MZM5ToN9FlcqcsNIaMfjY55Xqj+ADUQEob+YrSCRefdZg0X48S6mfQDQDv+reb5zCMiguGPZ+/NpU1bVTnBhae5FUd4zVXJNrZEemrXl95QAzPViGgufnjcsJuKjVZ235Bm3A3ptuCUj/xgTCIdIY4ceu03l2aWE6EnyJ1s+9lYh/WRxgzwGsKJbIS3DbAE0uKjraDWQo6X8Vw8PjMu7ufQqqdsuPLMLcavcdtlRcvly5CZ8t/NA7re2hjUQ5TYhrLT3+/SqK8SnACDPobEYOh/B1talOpIjfKiaaexMgKXJ6s9vaXLo5i0zPldMYbBsEQgKW+wTCA3C7StJE1bP84oihd710IwoV4w42ZRljeNv2SVaoVaYFnf3CN5fbdkiF1m9Qvcjrc5ocCgH7TD5a6zwI/uaLOYWx61AwMg2tjXcZ76acXaGJgozPwyfZTP47WJ6xmyatKMzJ5c6E0a06YrJBJ5GhTbzzyVlhI/Hwm608vPvqJst2CjlthE4KHccXEz9sRUt
 rayfZsr5
 NBNTrPW4totKZe2piZsnQUp8aL7zUbbRoY6J+ZOk8nzC+nmpCW1kjJOhB1t2WxRyhbhL8+YdKTQ4TVAaEtXJ2IzGb26OU68GYfz7zRvJPwPx567ZFRYtmDuKapEBQjq8AUx/UhrEuMaB36oZboJappsMPCSmIKBrXSXFFnf5wy4N3xpa2dRuo94RVHnB/BDf6NLQ2YpTkyucjFKh+fQSIDz4bigcfvHMFcL4nYahEL44eK5oP/aZCEOAkl5AQT9xOROSc2sUmcOi4sz/9Du3+75XCTW337SHgqi2KZ6O8ywWjhfhC3ukl5I3qaJXIQgTA1gaityI0J+YMttvcwSPqZQA8vsuXjKjSHPdMuWXqW3IBSC61jR5ZqtLmm9FEqseqVXq4l2hOyqrAawwd14org3kxFgQ1zzdgg7K3tzX5s4vyv16hNc+LEVfxhTlbBNKFn5qoMwYOsWetgjxoxqY2rPwJQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Inline the check_bytes() function to prepare for using the kselftest
harness, where TH_LOG() relies on the variable _metadata being present in
the caller.

Instead of passing _metadata to a helper function like check_bytes(), call
TH_LOG() directly.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/mm/hugepage-mmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index d543419de0407..8c246070572f9 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -20,11 +20,6 @@
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-static void check_bytes(char *addr)
-{
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-}
-
 static void write_bytes(char *addr)
 {
 	unsigned long i;
@@ -37,7 +32,7 @@ static int read_bytes(char *addr)
 {
 	unsigned long i;
 
-	check_bytes(addr);
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 	for (i = 0; i < LENGTH; i++)
 		if (*(addr + i) != (char)i) {
 			ksft_print_msg("Error: Mismatch at %lu\n", i);
@@ -65,7 +60,7 @@ int main(void)
 	}
 
 	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 	write_bytes(addr);
 	ret = read_bytes(addr);
 

-- 
2.54.0.563.g4f69b47b94-goog



