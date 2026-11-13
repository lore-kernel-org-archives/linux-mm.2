Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96B3606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XBDkP1ME
Received: by kanga.kvack.org (Postfix)
	id A39A76B05B9; Fri, 13 Nov 2026 16:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A110D6B05BA; Fri, 13 Nov 2026 16:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DCD6B05BB; Fri, 13 Nov 2026 16:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5B26B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:05:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1DACC015B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:05:00 +0000 (UTC)
X-FDA: 85431325560.10.2775421
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E737C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:04:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBDkP1ME;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794603899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1ER8KpZ3zfRFsc0jAuE6Pv7xhdhSa8bJ/BY3j/U6NO0=;
	b=xlOXToYEyirKLjrFs/QkqdTwb6rkhkcOMX+vMx0ZsCOh0xhsREjpIGNDIPrHGJT0mNVQSm
	5Zoak6r5wIt7iEnpsTuQuQ3ZJACw0DcWu6MJ6X+us8nPW6WGg/o+nuAfTmMjiFNqfgRgMt
	OJICZKdT+a4YBOVO2vS8eMdvFxEAbNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794603899;
	b=jqLPzZeyU7SJCF37moap9UMpc0PwnKco7QJYt0uvJstyezkDfNy8ro0o1ZVz0odc1nX09i
	9EvKo+Ls7fegsqa54YReDVxK8GfELabeLTgsGUdtHQUIEvfXgtVB2YOiv/H1fw2grxj/xz
	/IxADsnf+QKB1MtXHy0I4nVhhFrBMDo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBDkP1ME;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C95F760D03;
	Fri, 13 Nov 2026 21:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE21F000C4;
	Fri, 13 Nov 2026 21:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794603897;
	bh=1ER8KpZ3zfRFsc0jAuE6Pv7xhdhSa8bJ/BY3j/U6NO0=;
	h=From:Date:Subject:To:Cc;
	b=XBDkP1MEYjEMGPCiPmFni2Ws0WRv4aL3OTjNO+w9UPvmGu3mzeiYhRQTgvPU1N5Ev
	 WA4d2hotLdiO5VF0t3MnFFJvphAgOW98+piK5A+4gmOygY3s4Y9xD3ZEipC4yhHiW6
	 wifW6CuA4bs01ifCUkSQc+VFLckm+nmsBVJC40SP3Wb5pYGXRKjv3SSZSCNVZEL+7h
	 LzH5FlT1p8yBdLx9YdQetNOkI4mXGsUbfRFYsYHVB42fFy1YNYm616jr90CqWVrv5B
	 HB4o/T2Dbm09kOwGm1ZN3/mAJEinmVexTAVx1gdUhbIboA85h2OUY59SQqm7FpDkuJ
	 cBi1c7kytoqWA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:04:45 +0000
Subject: [PATCH v2] mm/madvise: zap markers from guard regions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NQQ6CMBAAv0J6do27URFP/sNwWOgWNpLWtIAaw
 t+tvMDjzGFmMUmiSjLXYjFRZk0afAbaFabt2XcCajMbOtAZEQmsJh6G8ILJOQvdxNGC+jRmCXy
 i6ohUsS0bkwvPKE7fW/1eZ+41jSF+ttmMP/tfd0ZAaFp3aZCZS5LbQ6KXYR9iZ+p1Xb+8kMwdx
 wAAAA==
X-Change-ID: 20261112-disallow-uffd-guard-install-a5294129ad7b
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, ljs@kernel.org, 
 Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5253; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ood4PU4Ndo2QhkvUaqc8rbDLFfrVqELevFrBKP9tELw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+Vxfezvg0d+LfR989XbMj/8rY+k7wXj/j6WOriLDW4
 //PLD97sqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATea/KyDCJ+eCbM6zllktM
 mRe/TTuTKn+TbXZY8/amri/OD+78/3+L4b/3VQXmLHEhlowZvikJQRt62XlYyv4n9pzenvfr7Id
 X1swA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E737C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fdsj5dudhoxhczhrqm1wwp3eekidydgi
X-Rspam-User: 
X-HE-Tag: 1794603899-699586
X-HE-Meta: U2FsdGVkX19fTqA8CO3XNz8RZa8iueKQW4OvrV/ijuKDSrqrhT79oYknqAUAUixZGq1nFS+5SXifaB2H675etYycE9y0nULAcpEWV9jSlArTo5QqhhSDYHtZddfHtbYd530Tna/P+fBBeCS2kGkOkyfY1VoTMPu0Sxq2gf4gdpnFKddVDe3AFlUr0v4nIWDMz9CaBcck538Sg4gYegIuvX94GucUdii//U0qOsnKfC2ghqIbWbP7Dmv/+IShc9+iaNf14PRmwNzqHHUz4sCIyf3AcVyb3bLDx/gOwatrVoPUCVa/ez3bADsetglGNJZ6/0WPzibESVwnFYtwADCan9TdJcv8S0EcWWTC//TivmrnSHz0ICarVWEYGBgVIlpPkSGSMhLFvJd8MlcVvrp2Iz8tbB+i9YEbq5LIZKIZ3F62dTpxRt+qAENxYbDx1izuDXeACUu3pD4SbJxFVDiNH03mWJ7ctgdbk5J8WrnuplCriphcUOpr7po710PeHgsqV50OMf7mTS4IwwLt/cpvqdw1r0LQGrmvsn+4Oldfj/5oICMCqq6HFziHxGVw/yPBmJqvWw8B55PxGp5RlR66b7l2jlWF1zy5rJ9EWpQyX0NO39kCSw2QbQojZ7cXMgwalRfe4PqxhxDFd2j8Gp7JlCsocYjw3KPtF7s1pKb1HoWYWjNjpQaNfPNkFghNlgbEwCPqF4t9k8QbutRR7r30+mrHwwkpDukybrD90oYxJq0VmWpIY5FRAebroVcNLIlka6v/m0KWhvYDCPrbzACC1PonaIc6LJAEDNHdnW2qdNcECSK8MhiCpQboPHBs1GZpGVErsijEooFWl+hEr9RwrH5UGp4uFdPADg/OzP8C6k+azZ+hbdZ2ZDpkHeGUQpg4DLwfeY8dnc3qL+TITu4igcbhb9eMj0HKATdLhU6EcaF5bOSIOHf9R8XoICBsyQn7kzTsM2pzEAmzEj/3GBy
 YpeWC8CL
 82tsxoaqTBHOdzldGGgLzTogmN0oI7OxY8PWy69ypG1pREEUTrIHMPyxTW/zEjz3tKSa0P4cd1sixrW+qMq3vtVr/ZTXSIs4j81mDZNLQPfZQA55GQ9/rvtFWs5JI6mv2bbQq9iHC9o9bHcUu4KRmnrHyzs9DMhepG+7OehawjcAGCD9eMvxbkZxisyvfrbnVCJy4PTT/F3C4+U/cds47LrPxIGaXHkQBjEHDbcOsVpCvJo8Q1SsfsB3K1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In order to establish guard regions, guard markers are installed in the
page tables of a mapped VMA.

However, problems arise when one tries to combine this with registering a
VMA for userfaultfd, as such operations may themselves need to install page
table markers such as uffd-wp.

When the installation is attempted the guard marker prevents these markers
being applied, which can lead to unexpected results (especially if the
guard regions are later removed.)

This is especially problematic because guard region installation causes the
regions to be zapped first, meaning that the removal of userfaultfd-tracked
ranges will not be logged in this case.

Additionally, the uffd-wp page table marker will be propagated regardless
for file-backed mappings as the zap being performed does not clear these
markers.

This is problematic, as it can cause repeated failure to install guard
markers resulting in an infinite loop.

Therefore, update guard region installation to invoke the zap with the
ZAP_FLAG_DROP_MARKER flag applied.

Both before and after this change, uffd remove events will not trigger on
guard region installation, nor will write protect state be propagated after
guard region removal.

This makes sense as conceptually, guard regions mark a part of a VMA as
effectively unmapped at the page table level, and removing the markers is
like mapping the VMA again, over which operation uffd markers would in any
case be lost.

A survey of open source users indicates nobody is relying on installing
guard regions in uffd-armed VMAs. Software including glibc, android,
tcmalloc and CRIU were checked.

This change means that any already established guard regions are removed on
zap. These will be overwritten with the newly installed guard markers on
success.

However, if this fails for some reason (fatal signal likely the only
reasonable cause), guard regions may remain removed, and concurrent faults
may succeed in the interim in the range.

Since the installation failing guarantees nothing about the range being
installed into, and since success overwrites with guard markers, this isn't
an issue.

Since MADV_DONTNEED does something similar, abstract the zapping to
zap_range() and call it from both places.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
Reported-by: Tal Zussman <tz2294@columbia.edu>
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Updated to just zap everything as per David + Tal.

v1:
https://lore.kernel.org/r/20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org
---
 mm/madvise.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 0214efd2a014..4f7728583207 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 	return 0;
 }
 
+static void zap_range(struct madvise_behavior *madv_behavior,
+		      zap_flags_t flags)
+{
+	const struct madvise_behavior_range *range = &madv_behavior->range;
+	struct zap_details details = {
+		.reclaim_pt = true,
+		.zap_flags = flags,
+	};
+
+	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
+			      range->start, range->end - range->start, &details);
+}
+
 /*
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
@@ -872,13 +885,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
 
 {
-	struct madvise_behavior_range *range = &madv_behavior->range;
-	struct zap_details details = {
-		.reclaim_pt = true,
-	};
-
-	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
-			      range->start, range->end - range->start, &details);
+	zap_range(madv_behavior, 0);
 	return 0;
 }
 
@@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 
 		/*
 		 * OK some of the range have non-guard pages mapped, zap
-		 * them. This leaves existing guard pages in place.
+		 * them. This also drops any PTE markers in the range,
+		 * including existing guard markers, which we reinstall on
+		 * the next attempt.
 		 */
-		zap_vma_range(vma, range->start, range->end - range->start);
+		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
 	}
 
 	/*
@@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
+	case MADV_GUARD_INSTALL:
 		return true;
 	default:
 		return false;

---
base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
change-id: 20261112-disallow-uffd-guard-install-a5294129ad7b

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


