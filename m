Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697521099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32B36B00C1; Fri, 20 Mar 2026 14:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09526B00C2; Fri, 20 Mar 2026 14:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C200D6B00C4; Fri, 20 Mar 2026 14:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB1F26B00C1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DA5213A6F0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:06 +0000 (UTC)
X-FDA: 84567225372.12.4D1F25F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64609C0016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vp8rY01q;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQ2YnQMA6wtBbvgp5H2nJ1CiWiYyL/la/rWZzKdK7uk=;
	b=jj8JMIA6xfHYrjZ2IyDOC2DG8t0d3T32c7g+tv62GDiphJUN4t0PoromQATOvUXInrZ2EA
	+Z0J1HLOJnygXxJZxDQFuAGiEHtrwdJR0GzQ63dIwNaWoy2if2WC+edcYJt9Xrcy3+ENgr
	MqYSF4ASlOvE++YesSKlreOa/9oBa08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030084; a=rsa-sha256;
	cv=none;
	b=NAPcRSosFOvH43kedFOFV1gjaWv4ccoxha/y5SiwfhJstoSBFwqBvQCZh/YBmVBX6MpogN
	Ctubjge+3Yxq7XlI0UrctDuPvc5qxMY8zSYCwasooy9dISFj+E+HZQbZQh1Kj3lvX5C887
	BzhVJ3W5G/TrVAUxKDukS1dZoxNbtHE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vp8rY01q;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 906FD4331F;
	Fri, 20 Mar 2026 18:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39CC4CEF7;
	Fri, 20 Mar 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030083;
	bh=0+GlSeGdSvEbk7Xvpg9UTnriV57myN66M3z+ejCspIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp8rY01q/ADSly9S0oZzHX9BeisKfH4/tXjVnxU6oSlnyETElhWI4MAIn2oFAxBtK
	 3n/01WJKOMzJLND+lCSDid55KjRqtwUuWL44FDJMzY4X+gPle1iMnbzxgnKlnBosG+
	 zBMYyALSVtEn89licpz9JV0B9CWXMb4EpH9BrcP9MQmOoC2t2R6XbnKDn/+gE+7xXI
	 iPTeMSGmptRwIkHk84I40eP33uNagvXsq9keqkUJjNnuTnXDbXkg0fFVBRNsryz6ln
	 Vgv79ct3xAvnqRtINcB/p1GDstXhoTwAm2Ts9nu2m4d+Y+oTgwxuk7fqs6N7Guqp6J
	 +hlAN3cI9s/zw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/13] mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
Date: Fri, 20 Mar 2026 18:07:28 +0000
Message-ID: <b677592596274fa3fd701890497948e4b0e07cec.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fgassgge4x9bat4pf1dxck1766pyycdu
X-Rspamd-Queue-Id: 64609C0016
X-Rspamd-Server: rspam03
X-HE-Tag: 1774030084-757726
X-HE-Meta: U2FsdGVkX196owvq/T8r0FAPe/jQuF3NmEHp5hSOKCKBGhNjE9YEqumGQzPcMUAV9P3Tn75Jj2Eicke7K3NPHoDV82xf+FS4ywQYqy7lsaxGBG9r4u640WpoF0b+EpoFiNYbLE/Z2Nienb+Kqqds6c8lJsWiVdzd/neb37vigLTk8YM2DLXGPdHSEoF9/QxuMGRQR3VB3kQIPEqhCd/uBwBbQ/AZyg0QMXD/EV5MKi11wfeoPERXwozI9W1LHibMfWsEks+uSIJoIWLCd/iHYdTk+r5rXta7KjJbdGN/j6AXNxwmD1d/WU3///QQjCEP7wnmNM2UNB8Gbazw+hZiU+UQjTKALfhMMbRNcmfAim8R2hlVZROo1y4GKP0/3/ELD3bIAReHj9vNTTR7mJ8h7OTZtkeihru7Kw2FaK+qYEd3WX9rf/ozdO8l9wRElzG4sLEet0E817mHxLDLYHTs0S2B9CSQDfQ03DICSKTEHeF+if5ztgYsdLpv8bxx0SNmpszHRKGX+NfPdooF2Ql49ts7O3TkMv6H172KXPxgPkmTdr8l4D+kkEZK7yRsFvR7qk20reMcZ7LkrvEaAqcTY+GEIxH4GD5fBAwzuluQNOWenaReZnT5LhY6n9P3q/CwnHgUjNRD2RA4Vc5HE4XmWnO5WA76fMNdk5qn9+o4W3j5ZNpNQumWdhhmlU29gfDw0IMkci+FDi7Yy+INPv+rXxCUNj/ZGB3hD9oZodv/tFDNO9jpUxqxzLtdGBa1bTp/O+caGpEWuVNDz4yzYu4jQPmsthWcYMnGt4peuDsCSgf98YKfC0MY4v1qQwWPGIG4VKI9sWnf12VGy/4PWP+HLBaKH9gDY9cYpQ//QkBW+6lCGeGwIytr8QgDlAOtqIOzZFou+SK0zzWuI/HoE6Fh8/6KcLABkaHYnQWbRxYf0UhLzijyzUJ0ZUwz+2IBIW7hiRwxlJXHzNr7Oa461qG
 Ea44Zlo5
 EgjwfhGDO0dEFK3ia04moBObc0m6g6V7P1ECr7AjTQwAA9sokWhDUSnayXF24OcgeLLcIEy1HPgel++zCKr8Di5pn5NcTZ/L3jeNhpneidhJ9Sd5dfXvTDTL4wJRGpESiA+9YuNbgdIjk+l9QSCfy8SEwMDjH/9y9KufXF9XaQPZM4K/1KYE5WBIk0Yr3SVWpw0IcKgXnrSM6Ev0h1PyqniN4rM6OEwpHF8myM1k2FinAEQadTS+0zS6DWsXm3VL9VojO4wZBecofmQ+xhzFgWcQ/Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separate pmd_is_valid_softleaf() into separate components, then use the
pmd_is_valid_softleaf() predicate to implement pmd_to_softleaf_folio().

This returns the folio associated with a softleaf entry at PMD level. It
expects this to be valid for a PMD entry.

If CONFIG_DEBUG_VM is set, then assert on this being an invalid entry, and
either way return NULL in this case.

This lays the ground for further refactorings.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/leafops.h | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index dd4130b7cb7f..65957283fa9f 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -603,7 +603,20 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
 }
 
 /**
- * pmd_is_valid_softleaf() - Is this PMD entry a valid leaf entry?
+ * softleaf_is_valid_pmd_entry() - Is the specified softleaf entry obtained from
+ * a PMD one that we support at PMD level?
+ * @entry: Entry to check.
+ * Returns: true if the softleaf entry is valid at PMD, otherwise false.
+ */
+static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
+{
+	/* Only device private, migration entries valid for PMD. */
+	return softleaf_is_device_private(entry) ||
+		softleaf_is_migration(entry);
+}
+
+/**
+ * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
  * PMD leaf entries are valid only if they are device private or migration
@@ -616,9 +629,27 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
-	/* Only device private, migration entries valid for PMD. */
-	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+	return softleaf_is_valid_pmd_entry(entry);
+}
+
+/**
+ * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * @pmd: PMD entry.
+ *
+ * The PMD entry is expected to be a valid PMD softleaf entry.
+ *
+ * Returns: the folio the softleaf entry references if this is a valid softleaf
+ * entry, otherwise NULL.
+ */
+static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+{
+	const softleaf_t entry = softleaf_from_pmd(pmd);
+
+	if (!softleaf_is_valid_pmd_entry(entry)) {
+		VM_WARN_ON_ONCE(true);
+		return NULL;
+	}
+	return softleaf_to_folio(entry);
 }
 
 #endif  /* CONFIG_MMU */
-- 
2.53.0


