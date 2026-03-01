Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42955FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8D26B008A; Sat, 28 Feb 2026 20:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7136B0092; Sat, 28 Feb 2026 20:44:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD836B0093; Sat, 28 Feb 2026 20:44:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9092F6B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:44:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3515A5893F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:34 +0000 (UTC)
X-FDA: 84495799668.25.61E9A3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A4F62C0007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IKUT8L/F";
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZVf2E4nRJnvbvCIJU7Jh3QNOF5lqJJ7wT+KX+XmJtOg=;
	b=i5r0RHEJqBWbFnG4M2bX7Nnmz/NIzP5sBEtGk0lUmn6ZYnxhYPcpzKzooZ290Ps9M3unL+
	/S/9SCrQH9pbukUsO8kH85dNRr9PvOUxZvhBQK6nWB5mnHjlPJduhXjzHDV8ZNk+j5WZxv
	a3F0sSjc6NBIVxEbGSRRJbBN4rs+Q98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329472; a=rsa-sha256;
	cv=none;
	b=jBXa1HV/Sd9Tyxnf3jQfjGgtDKhV8xAjCVjdVdrehrksl1oL7nFJ405dfRuusE+fWsY1sl
	VjhjoD7q7OKwlT/Up5zqM9kbCK6n2g3qSXh42kHecVT4GhCm2SKy8Xin207KfibRnjcyOw
	StxzXtxlkadtGoXrDphTFVNK526tE24=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IKUT8L/F";
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A9466013A;
	Sun,  1 Mar 2026 01:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F140C19421;
	Sun,  1 Mar 2026 01:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329471;
	bh=OKmzZFzyCAf20fXK+5ls4iExh4RiW5P4WUKUTWuBAk4=;
	h=From:To:Cc:Subject:Date:From;
	b=IKUT8L/FfJ1o4aCg8zKFZhuaGGjKeC0PhEUSLBDo76kAR7yA1jnE1CovIXvFqebij
	 u0ocq5boeIMTtVuzJd+7erG1sALkaJQ0tDBRD0rWs7AfORh8omSB8hpAH3tAVnsfDK
	 XzrVY39XtLlLd4bNyo2OP1uuh5PG/jU44eqgYXAo+QryOe+KfNlUYBJpemnRYRdORC
	 r/CWOR03vq3SqbIQvcA6B41bwyf8aiS5bnDXuk0u5utBLXPY8C743pUilDgoaUY33f
	 88dsktIO5mY7BvLS/iYAexIFe6BDQyMtdDQXL9yYYdaaEvjeTYiqODM7lHlmRl1QRs
	 HM5cF7AeltuUA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	williamt@cadence.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Chris Zankel <chris@zankel.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/highmem: fix __kmap_to_page() build error" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:44:29 -0500
Message-ID: <20260301014430.1706774-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4F62C0007
X-Stat-Signature: 5gouuu74kgce6y3cj6jhhnw8usfnnwfu
X-Rspam-User: 
X-HE-Tag: 1772329472-919590
X-HE-Meta: U2FsdGVkX1/Xx5YPYpeLZxweEpTsMl4sl+QP+I4fZlKAe50B4lOtTwdFXdh/tsc5ATM8tJJvBNS4CS03TtHDLy56ZDj5OAM/tcD/l5dpEgiyb9KyZoqoyGirls8MhcWtjsO3NC2yyQBQq2VbDSb2KCAYNoQzOeNKsXbHFvE3ZE95wiLOuEBDHl66CAuKVjHiWbDuoic17jUHWPL3EkEIz450thqTnPEva2xnGmKD6AKrmy2mxccSYBjcOchlDSP0wFS5wevRGQ2l+xL6FEIG8tNU928kmZiYdIaY6jX32k31Bgn0syGUVl6NtGGC44N1MKz2xA2lkDz6winW/w5jPUx4T5d3+l+4l9vC3g/VZTkIO+G4dB1Y//LHRJIMMVjuDDazF8tA8LyKMZgpjyUjstwjDxEPgoEzzKI9O7tX65K4Uw6XtuKa+5xavAu4g22j/lqa73APQifxoNHUrqzyiPpcVASbu9vEbkXpRqXBZZUp5id3A5RRlqNpG81mMETDcEuw3gSIkuXmU5efy7sfv3XfnWqVfAITsG119wIsxnhNX3tVwF68WdLZ6bJKvnG3VY9qJBVVolwgsmnC3Rl4yNy7CJ0oIsv1O5ejdAmmSxNmDRVgaIO6dAaLSymZ0zRRDrxeOO1Fc8lEfbPCOCSYXvIMj2pykvyI9bb7rEq3H8N3WLAKeo6NMT6G/vPaJO/7Ec1XzbwqlpQ14RO2+nm396rFanH12L6VjveIRSP6DWMhfhCyococKhakmLnbFIISeqxxN3e/iq9nbOL9be6In18//3J6QKLIfJkrBCspyS/uoxpJNQLe6CFyQH86SXk1PyzcypWZxkPu//zxH0sObcGk0UZ9qER6bETmw4mRO+97AhHpinMLyzpIGrqXjlNzuX/3w+V/sTnyJsp7evVb/7BTidT4cDeFJ3KhCZJ4qk2oEcxrbmNtnLUeEByH8k5BVFHfstcFMHsa3SqoRss
 +qhKyMdK
 ac56VfRHw8aS7oJLL/C66LdgXNMkhU9M4IK+h9wriWfIEKtYt2EbPSackyT+4Ti+3xx5h9vZr+rhZ+aBKZcAoIUvjjLHVfIHK1I67G21QkmgyzrBYI3O2X6WW44HmhEmsFMV3D3X0mk67pUcQz0HV+CCMSZJ9tCmFt2vABNLmXfNaNn0uvvZvd/1xa5GtIpy8NrmU3LkYlEZPECYu0gyya02+XCmdGovjycYcdJEaR/70UWMGOeu8h6YcdljkZ0EnRHkMN13+VzUmvmHB4nKjHukncTjCCT9F0mgxmVvXEwxwxme0Yn++mJ3w/UG+gYbBPFs/OB8wqbrifN/neiQJKXBzJhBZGP0iw+V7Z6t518jEKtodwNbh87qa7eQ0XuUOGGvOvzwjOJeyz20LZuaFRMzll7S9YHHSt1dt3fjKKmRwl8VULdpdAMiDGcjxiaVFXJr2BOIM2NNzbqQsYvzoj/K/gVp8qQHgkcl14O7PMfYS4E2Nz+0+gL6TDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 94350fe6cad77b46c3dcb8c96543bef7647efbc0 Mon Sep 17 00:00:00 2001
From: William Tambe <williamt@cadence.com>
Date: Thu, 11 Dec 2025 12:38:19 -0800
Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error

This changes fixes following build error which is a miss from ef6e06b2ef87
("highmem: fix kmap_to_page() for kmap_local_page() addresses").

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

(akpm: affects xtensa only)

Link: https://lkml.kernel.org/r/SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com
Fixes: ef6e06b2ef87 ("highmem: fix kmap_to_page() for kmap_local_page() addresses")
Signed-off-by: William Tambe <williamt@cadence.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/highmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d49..a33e411839517 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i = 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval = kctrl->pteval[i];
 
 			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 			if (base_addr == base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
 
-- 
2.51.0





