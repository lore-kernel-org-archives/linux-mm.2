Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 085FCF483F5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF0E6B0005; Mon, 23 Mar 2026 16:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FDF6B0088; Mon, 23 Mar 2026 16:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6466B008A; Mon, 23 Mar 2026 16:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A696B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:20:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE08F13C1DB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:20:39 +0000 (UTC)
X-FDA: 84578445798.27.C852364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1088C100012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:20:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3tjUud9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8uRZ25llE+eCrAFxpGSnSN73humFMIdQVcRxYCI+p5o=;
	b=yMoGVBRa4X6t0bFv8R8pThQOIyVa/FYRg7Jfka64eG34mGPDIT2pCAFqJksfnTTZXfqRtL
	aB2kp8wAgHHvRyUbudsgFzxZZk6Ez+cvY7frXYCn1X1RnTRrEM37O1bYnMnUj1DtqXZKOL
	x48Fgz5ozg6UxMiiImODvQpc5lPs+cs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774297238; a=rsa-sha256;
	cv=none;
	b=zNWJe9osSWtPe0W4QSXhnm6KHuzwp3COCBNyBGShPX4hZv9Vobc3vo1YxS4ulRLAVsnZ9I
	X3WOyCF68zFtjWfKVke8+tOG4dL3Bk6c/U2KLe9pOea9tqJoKLA4nVupqRyzhkL46vrsol
	ngxxaxhdQND+Q2APFXyCiMqHDOK99Vo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3tjUud9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1628C443D8;
	Mon, 23 Mar 2026 20:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A27FC4CEF7;
	Mon, 23 Mar 2026 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774297236;
	bh=ZLHOz0Vhge18irIpqyrf1TiEfpaeI3B97dPXYKcSdrA=;
	h=From:Date:Subject:To:Cc:From;
	b=m3tjUud9rFQPQaZyJRAY9SpAB1DNiJyc+UcwiuLzB5h0bY7pWHYTYSvTH943RsHEO
	 6e5Pi39Rrzpwf1yLjJdW5h+d9YsESPw4H4N2I/VwEwP7wlqIKKYg3w6Ri/Mi2tigFw
	 8KEBNgavyP22XjykBTcUyoumFbUZM5qmvpcGQRASgiRkoucX3jVgvhUPgnqbIbb99D
	 gfxNlCrmVoav1OeK7xP4IbeLmB/iHgFXlSXwbY7MfEcqOoXZOPjdVymGoRowRRJltB
	 CcFIdqirNL0d+XC3hvXe1nEIV59llQ5nvAfPKp/FOewg5vixNtfoEk0EBW7KHtgmbl
	 SAIyJxcnZYLVA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 23 Mar 2026 21:20:18 +0100
Subject: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIGgwWkC/x2MWwqAIBAArxL7nVBuL7pKRGittVAqChVEd0/6n
 IGZByIFpgh99kCgkyM7m6DMM5g3ZVcSvCQGWcimQInCuH131+SNPZSfDN9CK90iYl01nYLU+UB
 J/89hfN8PJTkTEWMAAAA=
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
 Alex Williamson <alex@shazbot.org>, Max Boone <mboone@akamai.com>, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 1088C100012
X-Stat-Signature: cx8e333rw113cgj8wo5h5hozjx37ines
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774297237-223722
X-HE-Meta: U2FsdGVkX1+ohlyvJm8RmkZ01q5J3uauKAVXajwzhDUwdaH7hRvTdYn+ehaLPGSFOlbhWEK0gDu8GJRWlLUE9WvHuEiT7iAY9VcVNHqhJ5ar6idJ5M3J7yS617Lv6YHdf9K3wq73r6GwgIqzNERHRzNCj3ad/3Dcd10bucBzWMEKWCVNfVrMde1l/g8jIREWdQ5EANrnOt16HnBKFzNkTXm7vsn7w70LEoWnkgb0VfxW8hyMsJ3vHdu7r4U0hG/tcZexKbQ9+uhLKgo0ZsOVJ0gxpjuDJ0bLsPBdkkZok+yFaW4eQOtvxl23e5+XUkZ+E11iyGifI1o9ZK0h7vri0ddfmZaQwPQ1+7EVQASwYTgxpQJJV7TEqIQfmMLEzIsX+6xezugChAZJJ35E0Zod32LtIAt1pz9Wa73U12mO9Kxcn0wjJ3zci/EU85jb+PaE2/U20aci8NjNEpie+hDOgV2IVV9JBvZB0AyZ2x+5Wsgty8LNRTVhRSAsz6Xmc4PnOKgkaEfVx2yKG8KmXMzDbhTdYU4DVayh+NACnifB+mTAfw1lYvIECxZtGeWkBCprh3uvEszehrnlj2pYlkRNr8ENze1KIQDthHd9Kaa1iDjreCXLsu6BLq9M4wvXpeJ2HV0xEnJNb1aJ5+LHj/OiCQMLmePYZPRCn/oETTDUnb+pAlWHpiYl7JMpFxHJxYNZk7Socn8qNyQ08hAFtqBMtGUV2IdlGL4SGU/Oj3ScQKrmBEzmaHNOytzhRr18ms2nFMTT36+CZnM5tht0o7gCbZc+JRg+lH2euLe1MKf0kQ8SZipY/M0HFKtiZ0NQCJ0O71UasFkTGLUdEl+5sWmZN57O1Zz3tEB0AsjRWsX5GZ99gHz9I0INckW9U6BOjKJCTYZCyVgPINK0XgDSAoa0sFOVb2ae/Tuhmm3WfCw8HWw54hZvZ9njwgWkQZhjVzTQY4XFHehhc0ui7qQIMAg
 YBrNL+Fe
 omGJXC6DZJ2yLB7mzDwQQfC3U8TWmij+M2Wl3LAx34imvd2BCWHVX5xA8XEdOIxu/orrY0uITbYoqxnX6USbwKf4Y+aiL1gwqHTpMBbvX1EdVJXpQ/k6KjC5sClda83dCy1m/Ij9AjX+zXwLgl6pEw9YOa0D6E63tXgyh61NE3WcyZRH3/wnUEE43M9sNrZsmNIOMT7FBGsCNCDvvu8BjVx5YYEq0syseYM5kKBBMyWjHecXwh4Bk5ASbHve+B4kVqsEq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_pfnmap_start() suffers from two problems:

(1) We are not re-fetching the pmd/pud after taking the PTL

Therefore, we are not properly stabilizing what the lock lock actually
protects. If there is concurrent zapping, we would indicate to the
caller that we found an entry, however, that entry might already have
been invalidated, or contain a different PFN after taking the lock.

Properly use pmdp_get() / pudp_get() after taking the lock.

(2) pmd_leaf() / pud_leaf() are not well defined on non-present entries

pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.

There is no real guarantee that pmd_leaf()/pud_leaf() returns something
reasonable on non-present entries. Most architectures indeed either
perform a present check or make it work by smart use of flags.

However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
do that.

Let's check pmd_present()/pud_present() before assuming "the is a
present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
table handling code that traverses user page tables does.

Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
(1) is likely more relevant than (2). It is questionable how often (1)
would actually trigger, but let's CC stable to be sure.

This was found by code inspection.

Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Gave it a quick test in a VM with MM selftests etc, but I am not sure if
I actually trigger the follow_pfnmap machinery.
---
 mm/memory.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 219b9bf6cae0..2921d35c50ae 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6868,11 +6868,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 
 	pudp = pud_offset(p4dp, address);
 	pud = pudp_get(pudp);
-	if (pud_none(pud))
+	if (!pud_present(pud))
 		goto out;
 	if (pud_leaf(pud)) {
 		lock = pud_lock(mm, pudp);
-		if (!unlikely(pud_leaf(pud))) {
+		pud = pudp_get(pudp);
+
+		if (unlikely(!pud_present(pud))) {
+			spin_unlock(lock);
+			goto out;
+		} else if (unlikely(!pud_leaf(pud))) {
 			spin_unlock(lock);
 			goto retry;
 		}
@@ -6884,9 +6889,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 
 	pmdp = pmd_offset(pudp, address);
 	pmd = pmdp_get_lockless(pmdp);
+	if (!pmd_present(pmd))
+		goto out;
 	if (pmd_leaf(pmd)) {
 		lock = pmd_lock(mm, pmdp);
-		if (!unlikely(pmd_leaf(pmd))) {
+		pmd = pmdp_get(pmdp);
+
+		if (unlikely(!pmd_present(pmd))) {
+			spin_unlock(lock);
+			goto out;
+		} else if (unlikely(!pmd_leaf(pmd))) {
 			spin_unlock(lock);
 			goto retry;
 		}

---
base-commit: 3f4f1faa33544d0bd724e32980b6f211c3a9bc7b
change-id: 20260323-follow_pfnmap_fix-bab73335468a

Best regards,
-- 
David Hildenbrand (Arm) <david@kernel.org>


