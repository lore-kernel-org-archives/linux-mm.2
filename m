Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B730E9A049
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98626B0089; Wed, 18 Feb 2026 08:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42A26B008A; Wed, 18 Feb 2026 08:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D536B008C; Wed, 18 Feb 2026 08:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84E056B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDB96C04AE
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:07 +0000 (UTC)
X-FDA: 84457600374.18.A5E6A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3F1B8000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W67mlTCK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njqxrMZbrsuV9V0JqvXQPGztJhPNpcsX6uZ34v8Qeso=;
	b=zlSdvvlYtYD2BKtg0TIiLGVdpvtnX5/32Yf8K78yxUV7CmLtjBXeq5qcKtRGFI5E66/2Ug
	gbnol0YhLalKctW2O+eJ0c1HbKx0+pFh8Re6FJ1iIslzHzUBIy+BPJBSy++1TJ0JULnk+Q
	x/z5Dn3FpLqoB3JH/d3Q2Kz4jQZ8UBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419966; a=rsa-sha256;
	cv=none;
	b=valj0O/g8tNFNqKa7c+QVb9MQYwxAoql69rgrjflAgU7TNA1PZN64SCF8/eGQ58tWUVlTL
	ivS4AbYF858y/UXjLbJpmx8oZlecI1+TjEPVDnZBci71y48yruONSXY8VrQfeMTKbGawBI
	nT2slGLJAc6/RSJ5GxaRAbfP0PW/LkE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W67mlTCK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45323600AE;
	Wed, 18 Feb 2026 13:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81365C19421;
	Wed, 18 Feb 2026 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419965;
	bh=6hsTAe3F6SFDAEMSoXMlTVM/m77RYjqo0PE8OHxHQF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W67mlTCKp72Zw4n9T5Y138as/HTEXsStwujszIVALFiBNltq9AwOHYT6/DcHNLQjc
	 jeWoLrMgBBn+Y5PrP5CA2OHhb7Ff9nGjlQR9EtfrTacIJpQKbAn7Wax9h6t7taifxa
	 8on73z29A63mz8hvQQCkQVHGe6Ng32rZT7kaIb8Qe9sp6Erh7DmMsGJc1IYNZAZMvZ
	 HuQuWT/hS60Q6fHg9dbFnAJpL1/xX236ed4Q+/h/i3eKp/IZDW2LK61LCXyfEf5Q+R
	 tJ9dLzHYB5Xxc/7iV+bi6Fi5XDYMkoNdn93MiZ81dYjd+f8BDqQaq/awbvIa/2Fvx4
	 QPQAdiw++AR/Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>
Subject: [PATCH 5.10.y 1/7] mm/hugetlb: fix skipping of unsharing of pmd page tables
Date: Wed, 18 Feb 2026 14:05:46 +0100
Message-ID: <20260218130552.55727-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3F1B8000D
X-Stat-Signature: 9e44gcrchsj37eoyowjuu7u6xxsqr5is
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771419965-917314
X-HE-Meta: U2FsdGVkX1/5gaC5f8CrA+OHEm1T2yfC048UfezSLwB32se4yjIbfHHh1t7vpOL7RXq+mNSNiNqdq/gWBtXDkMnRGvnKPmibVp1AwGmmFqKg3i+fCzTB0ezM7DiaG8dQtPmfxtxHSq/KqN/ZvgVDMDbcR1UwLa8mJPycKEXVKMgnl92ZnH6S0KL4+2uRE8Qkn7TD2M80miqZUh2V3JGPXtTScTKUL6s+Bj0simnEFpgW8Lrp7ljf3sEhgjXw1maIgO5Nl5yYe9QMD7266UIJMWh3pQa7oarDofhPU1/07svubFaj6enR2GV4fQKk7xXm5e3z1OmrH2fA6/sh/n0pYVOJXc67CTaLaDPuPOK/KXMG1bkMhlxjCqfYqe87dQWj9tVrhDM+7HB76CFEFNUnD8ABPJYdOmb2B7/duWVNLPzt4rQEw/FZ3Vl7HB4F9wZ3ESZasYCDnrq399Q/hFu5ZiivwaMXFwk+ASlCGW89/aRi2M3PXJLDuSQ0BSh2yY6Pe7Ei+qMwKPGWooaaRkUFnQTOlNE5W6/CDclcBjv5k/AykumVhtHGra5UhraVuoDjCn7Y1Slz9yFZOi3L1oyjwsz2e666XvAMHBqjFUZ6BMU4TTpPyjlQ7ommf5dEC17Wy7DtT3R96S9Q46PClj5LGBetz6+UtmjsZrYbV038AkJ1f753jWpx1sLq7CK8HVDLbbtYEL5GBrgFETIR0NINZwarlHtYl5gTTAkr7p8icF40RYjGzRSUXemDGWD1SRK1GUuu9Qj7gaHmq9hF4A7zue3VSr/d2zMijkT0sgW56Z6roDgtxD9uE69EmDQRlW27eE6546KUSHce05k0kRrtFGdIPYESLFbyMj8UB+ENAZ1neh0TS3YdDPMiwTMQSIcn01joYf3upnYzXJyRufgc72ceqi0alNpycT6d/BaTGSTM15+mOlwHmbvZTPKCGZi89C1AYaVoqvrPFINBS5C
 Mrce9OOJ
 TCN4yQHmSePlikaPfgJ+tgdMLgJBiF2ImXvfabTf3DvKz2q/f7Y2EyR5VepTnTaX7GWcMDN3g/7iYXczQwdO6hD7mN5HTVfkKxPY9YWqXe/LeGFVEC9kixU6wJEZjgNKiAOLYU6HFeX7GKe6AWWCvuOjZsfE5wWuqbnQCJ9tPAsHz9xuB9XMdw4J3MELXgCpmTmiY/BuhHb+SKzBSpi9qAW8zxH3dwLgmpFNF9IYaDKtchX0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the 5.10 backport of commit b30c14cd6102 ("hugetlb: unshare some PMDs
when splitting VMAs") we seemed to have missed that huge_pmd_unshare()
still adjusts the address itself.

For this reason, commit 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all
pmds for hugetlbfs when register wp") explicitly handled this case by
passing a temporary variable instead.

Fix it in 5.10 by doing the same thing.

Fixes: f1082f5f3d02 ("hugetlb: unshare some PMDs when splitting VMAs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8efe35ea0baa..99a71943c1f6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5787,11 +5787,14 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	}
 	for (address = start; address < end; address += PUD_SIZE) {
+		unsigned long tmp = address;
+
 		ptep = huge_pte_offset(mm, address, sz);
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(mm, vma, &address, ptep);
+		/* We don't want 'address' to be changed */
+		huge_pmd_unshare(mm, vma, &tmp, ptep);
 		spin_unlock(ptl);
 	}
 	flush_hugetlb_tlb_range(vma, start, end);
-- 
2.43.0


