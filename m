Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35585606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gvl0aLAQ
Received: by kanga.kvack.org (Postfix)
	id EF1D16B05B6; Mon,  2 Nov 2026 05:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9356B05B8; Mon,  2 Nov 2026 05:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF726B05C8; Mon,  2 Nov 2026 05:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1BA06B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:25:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55C59A8AC5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:25:51 +0000 (UTC)
X-FDA: 85389798102.15.6D9936C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95FC440006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:25:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gvl0aLAQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793615149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Cc3tw4XUQRsg/newZjc7/GNlV33CEjPbr6NtBb7HM8M=;
	b=lPqkti9IKFlidQeRU8i7nc0ItNec26CYVnCQxO6SmDDJ8ZHT3moCBUez4eAc6kt/ScQE7T
	Y4Poy1BT+yDAc5Jq/8hpCzWiyWo08Rr0Y4eiDzyd5gHgGdZCnBbRdqcmEFy0wqpnNDolgr
	hdei9E4F5+ZboRyR7+1+rA7nQ/4Yo14=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gvl0aLAQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793615149;
	b=ejK9nQNjXLd+5EVOxS/Ns5m+iGLnmFFx3lS6mNcrN7bBL7qSYxAEvE2H4iphjKNHr4qBla
	wsG0ZpXnAEsc5+isCwxlATJY0pszXmnGBpEv7ptVHFOPZA9He9C0exNAH4SRN4wXmZ2gp5
	a7rEzLGoz9e4tClawsXvjYFxshCojCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14A9E60DD8;
	Mon,  2 Nov 2026 10:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B881F00919;
	Mon,  2 Nov 2026 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793615148;
	bh=Cc3tw4XUQRsg/newZjc7/GNlV33CEjPbr6NtBb7HM8M=;
	h=From:Date:Subject:To:Cc;
	b=Gvl0aLAQ/4pOp2zftBjhUVRTGuv40qRv06GquPhWfiwYvlE+VgwkJutocmwAgB1Jo
	 TUd49ygwX1LdEPBGmcoaHhByc+8bjVnz4sRgm2FjjgC42aevaR63JGxkLMRwMe+gq0
	 mdkIwJPJ9muW/1Dvna8hKAFFIicV45iCkjnuUrArj4vA620S7ZSrqbCW3NuZayKjHH
	 CevnUG7VsIXIoeHgMZ12pEmkDBTwWKsC1MlwC482hLtRFNx6GkuzNyedtdON0CSp2t
	 4+PkQ7+END0pR2NNeZImx3wyEkB6n+n7lv30tS/x/fBc+t0da/O+yHskbzyLfarV8D
	 yZ8UE8WqqgzMw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 02 Nov 2026 10:25:20 +0000
Subject: [PATCH] mm/vma: read anon_vma carefully in validate_mm()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwMj3bTMCt2yxJzMlMSS1PjcXN0kc0tjgxQTQ2MLiyQloK6ColSgErC
 J0bG1tQCfp37bYQAAAA==
X-Change-ID: 20261102-fix-validate_mm-b7930d41388b
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, ljs@kernel.org, 
 syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com, 
 Songsen Yang <yangsongsen@insta360.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3013; i=ljs@kernel.org;
 h=from:subject:message-id; bh=u2wqNUH9bK5PpvJk2Lz+CSIl7Jc0/KdJZkkyUZ4hQ8c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJepCqFLwvTtmD+c3+S8x/j/1v+31k8N27LlHOpi5elT
 +y0iJxQ3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJfGVl+M3SkaRz4XOEzb6u
 xM5QoVzVLa9DXzTlZolzX+Xwtfe8tYrhf9CfrnDJyNa1F33Pn2ac+Pq9jdaURYtcU5rOnG48/Cm
 8iBEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 95FC440006
X-Stat-Signature: 1pp5995ch3sthzf3xz9a6phytxrqughi
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793615149-893830
X-HE-Meta: U2FsdGVkX1+H2ozO0iNN/kuFfBdkjIKtgnaNJ5qhpvK1/JPy2EcwOIAouiff3ee74BWpESNMJH9KGoFy6pXghH/ZJuJ/YVZHZN7Iist89C300WPHfRng53VCH1uMBnwLGrWOJSULkZKfsu8+KOxdDJD46SwychJuO1c8JO+QcuRGVJSLlc+MXHSYa//YtQfApDwohippDNeqGs9qR1Z1oJAVWwdMyBMuCpH6DQR9fOcWKtB+Au+BZHT/BNrIbkSrUOqkkhh6TjLodzX5jAjj8+mMkzuscV+CodD1cx2WzJpRHxn8U+TD2MP3KTw9BUPmWrtYdiZc8ZboRdBRTnz5qGsr97A9BfegxmBGgNgwMk1oQiPDVrm3GWQedTgnyWJ6rvAxQpIAt7jWnkfn35Hf1RE2ZV+Arhlms9RAPGF2ZNPPwic3kRUc4GljEo+AwuBuW++qw8BxZtDzst81m3SA1xlsDK7LIdoX+Sj2OM/9CpiVwBMIW+DcP0Lalqk00hbTz2JHqAWUaPV1lRgl69igiAwIiLPqFoqOrA2HfVvD4G78VTwIp9mQMfCuEkE0atY1wsQ/5XahKKLIBJ3alnJlQ6PQm3cIMyfWMRs3tStxoPR0v1dRkrZVorezJ2hWrJl/vjcH4byDepSr7BM8qe+lMGl2y1fsAHNdifEVz9gY7fbR5LXp01RCouOZAHtrjaFjeNtKigDEaAUaATmYyhuhVT6CNgp2iF1QETpgxnl3c2/If3ApHh3dZEVG97Hg3RIpWYUCV81pfaUuZ1iI8lbjvZmoHZu4yFEzwlQQzQxPcex9x5/06sKjsLCNxQ/oogsvOyQXy1Xg5SQ6SpPLKfOihR3JZK7Z1U9xicXZxAByBPz0HX6x7KmBW56MWvwG2FV/rZxGCK7glM5xjLU/BprZL/lgixy6ovBaNTWtRUQk59JLpUf8SHUuaRk9ra6zB49w0n3vFAwKPD42+SmMipG
 2+hpHYIP
 Gg5u+DUMSxT5+bdvRmXLmE1qCaOz+m3TjL7P5j8veGNy4VrRnHSoxeszMqwB0FIOQx9VlBe8fZW4Sq9G6XL4iVxC+Vw8A6kFgsF+iffsd7Q+Xb058dHxcbmkYWD7KQyF0OEhvVCfYQjHes6WiRLi6b4wTomiK6plz5q2D98ommL3nwyvi/Cp19/2YiT3ptzhQ9xPMkJcOoZm9YgtrbpFL9kwUYnFvMo6tLDpx3WC9IY8OneCQT4XudiFUME2x2mV2pxwOilY205OxNY9XPPWY4vEszJWaBZVG4KaMnAqsh7nR9ZTXI2rtfNdB7jtT4w2GZwU3K5A4bam+4Cldmvn6/+h4UsHYa2AxPEolRAAQ+l/JAALxlzxZPqr5IOaNhKW7BLi2iHtkxStCX6tgU8DcmDjsjKx2SXCvrmRnLKjtnRwjeI5XiqyEEIBk76accENCMjhagKbLkZP+yCMEuOYNny9ulc0jshIGTzWKzh+CoyPNX/efGiBWhqeRNy84le9pBj2iRu+1gmeLRLBAh5e+vUBAEqbjTHNa7eVw8Szb1qNl+bKMjuSIRak7zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence
KCSAN") rather clumsily converted the read of vma->anon_vma into a
vma_has_anon_rmap() without accounting for the separation between
assignment of anon_vma and later use of it.

vma_has_anon_rmap() is intended as an optimistic check, so doesn't need to
protect against a torn read in vma->anon_vma. The caller is expected to
take care of this themselves if they then in fact access the field.

validate_mm() does indeed then reference the field, so resolve the issue
via READ_ONCE(), and simplify the code by separating this into a new
function validate_mm_anon_rmap().

Finally, add a vma_assert_stabilised() to make it clear the required state
of the VMA.

Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
Reported-by: Songsen Yang <yangsongsen@insta360.com>
Closes: https://lore.kernel.org/all/20261102074414.10902-1-yangsongsen@insta360.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index d416ba58eb4c..9f02f19a7845 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -669,6 +669,28 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
+#ifdef CONFIG_DEBUG_VM_RB
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
+	struct anon_vma_chain *avc;
+
+	vma_assert_stabilised(vma);
+
+	if (!anon_vma)
+		return;
+
+	anon_vma_lock_read(anon_vma);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_verify(avc);
+	anon_vma_unlock_read(anon_vma);
+}
+#else
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+}
+#endif
+
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -678,10 +700,6 @@ void validate_mm(struct mm_struct *mm)
 
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
-#ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
-		struct anon_vma_chain *avc;
-#endif
 		unsigned long vmi_start, vmi_end;
 		bool warn = 0;
 
@@ -702,14 +720,8 @@ void validate_mm(struct mm_struct *mm)
 			vma_iter_dump_tree(&vmi);
 		}
 
-#ifdef CONFIG_DEBUG_VM_RB
-		if (vma_has_anon_rmap(vma)) {
-			anon_vma_lock_read(anon_vma);
-			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-				anon_rmap_tree_verify(avc);
-			anon_vma_unlock_read(anon_vma);
-		}
-#endif
+		validate_mm_anon_rmap(vma);
+
 		/* Check for a infinite loop */
 		if (++i > mm->map_count + 10) {
 			i = -1;

---
base-commit: b61fa14ce6bcbba2cb9a96feea31b760226d6b43
change-id: 20261102-fix-validate_mm-b7930d41388b

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


