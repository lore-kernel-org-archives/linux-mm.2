Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DFB105D99A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F9D6B0093; Tue,  7 Apr 2026 22:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5303F6B0095; Tue,  7 Apr 2026 22:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CA86B0096; Tue,  7 Apr 2026 22:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 325C96B0093
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7A915BD2F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:47 +0000 (UTC)
X-FDA: 84633863454.05.149D502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F611C0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E98cltUu;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HN0l6djgGnxQKYZLRmuwI5LGHmsPUnRvQWhcZHUodA=;
	b=1h3DCB4DMQiKExZ1UuCJ1p7FjUXYX9pz2dWDftdKjEP/1Is80Elz0QQoEpC6WjEXWDu1cC
	KNX8dPH36qy6XeWz9uSp36KPWU9ZgMRXmzd/VtRa+sSSHtljdPfcAjt7ubJ5V8k8CM0BcS
	RG8U6qvlVlmOpOwM5f3oBS8LO8+IiDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E98cltUu;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616706; a=rsa-sha256;
	cv=none;
	b=vS39sTtWvEbeUs+5Kew1ekedlGwR+kE/7CIcrIiRXzPmW8fyIpJSfJhrj6db8NFFpONjLb
	Ex5icyWE1sYIxE5Bw7FK33xYS2Dy5+C1L4ArsaF034ZTbXbgmEAyLwkE3sujoLTRZXDrQu
	nI5kVBeA3lb4/lj3fUDgbuapPZy1th8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE7DC6013C;
	Wed,  8 Apr 2026 02:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D8C19421;
	Wed,  8 Apr 2026 02:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616705;
	bh=HLCqPTjcCmdnanlT8SVpYIjINZxqvkrrFi6ei5+WS7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E98cltUu5pz4jFx/09mSwR9dZ3lbqdssVOpqPjSPh9hhfM8JVF4YU+v01kkNe5m0H
	 M0RZ2LNiEuLFM69/fPap3dkuh2UBPmIRHtnr+CBeOiAFjrpGGv0oL3Xhr/FrzVKUT+
	 91SFi6HW5MU80MqN6PC15ebGS4uBiGtfv3eSIjPApij0yY3mF0grfx6pFmmBryGNDX
	 T4dg3i6bfttSbwFHZTbPPIXkwMYYxc67fZY9aFx5k7ksURsZp6MEHkTE6CFq65amCg
	 aiuuBvwfHF0QXa0S1PqSec3wkI9cH1pU6AY+Nn90uFLsSYE1BRNiXXttGTcot4Fmbx
	 dkSeaxzsotkdg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 4/8] mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
Date: Wed,  8 Apr 2026 10:51:11 +0800
Message-Id: <20260408025115.27368-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fbzp678b68fproqzyibbxr9w6b1o5ese
X-Rspamd-Queue-Id: 3F611C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775616706-869240
X-HE-Meta: U2FsdGVkX19nJbLPA83fkO63/4+GZTGBGHuI/DiGGLwFhFQyPNB9e96YaF7rPG0GiB1Q61m9jMC+7UFGlloPui8Ommqha5SuEZ0iWemCHCiJyQY88Tc41DAlMahX3NgxkgoZ0zMNtMr2G/OSCw7OY2uYxsqmm8OP/RIGEtGJim0DlZzyAHuyAaOwlIh64DA5VMBpAKTtQuLLvNnjEbGRSi7SQs26LUvTC1TaA25EMv3SMtuX29asjBKQjYncfzaujknv5GbyDlzWIHEGmJLsMNCXleXkVWGC+bbR/iGUFyZ2dDPQEzzYJjA+rzSitnZ7t2nboz0qP48mW3MUSJp5mp1BIbyyWgKBTTf+8/Mu9xpAvKTcYr84f7mJx92gRUUWfbIofp8CcDUBFp3I4aNQwF5m/shn796tMXHigPgQda+zNsQEAAMyr7D3UlifIoHPvAjHtQGL3gQkJ6KC24AcQElDptH29q8fpQCzQaTfUHVACjS72Nt+3Thgbv6uAKbjPNAteUTt90fef/U8w+har5vkesB1l4NVgAlwykhQykLZHhuTTGBHm9pWnVxu550eZNy83GigvmLSsG724cCa3vL5dNGJadBaCBkq23Mqaxpy7JgDACVRKL6H3wOC7RW5SiQqhZBZ2XDRiE7PFp8opgMiBnMOJd5YXp8Gpm1qqVeLzqMa3Ag+vyfVVIRD7oRZsj5UnTK19bxHLh3VMZzF1/ll+kyX1nMLmA7Fx/u16VGj+g1S0qg/r6zhzDKyO6Uac/qv0Kx2TXRTJIz37S4Rw+BmSHQlGZ37boEqdFLUImalTLkbVz5s6S/qVroFwg9s+gtvCjuL2EAHUN+DFJcJhGsbxh95HNUxxuyogEwNUFeX3/Qpf/fqp8NFOWkrEOFfewbIOT+LA12M5E8Z954iuRZOPA1Dq+dCC0y/aOQp5aXND8ZSmwLzZz9zpqBoR2jeHBHEwQfycXPQ6OxjaqD
 MZFh/34l
 3/Cdz/IJNzO+0zR+p62Oz83zVZyn8Mgg66pdnKgfjG4EXAEBb3Z2qSwzx4SH/jfpIa46cbLXuynDfASCRRxUmqgxH1p0T+ulTNXvo3D/C924snEiehY2XEBra6wGHVY4T/y/URRbfxJZYubJgfMBHuXWafnzgbBOwuF8ds+5hXmT4McqbPbGroAGH3Z/gUaAsu21qgmxNyu0N6HoUClimnk2pwcX1p0FktOSnAESc4Z4Q6zwFqMs6lgrMkCFvymB59vUbsgzE9Uf/QEv7c9a6/sh9vk1ltEHlSrXZVfPlkciBw0zZuKU0f9LEbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer
need to iterate over pages one by one, which would otherwise lead to
zigzag page table mappings.

The code is now unified with the PAGE_SHIFT case by simply
calling vmap_small_pages_range_noflush().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5bf072297536..eba436386929 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -689,27 +689,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	WARN_ON(page_shift < PAGE_SHIFT);
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages, PAGE_SHIFT);
-
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
-		if (err)
-			return err;
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;
 
-		addr += 1UL << page_shift;
-	}
-
-	return 0;
+	return vmap_small_pages_range_noflush(addr, end, prot, pages,
+			min(page_shift, PMD_SHIFT));
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-- 
2.39.3 (Apple Git-146)


