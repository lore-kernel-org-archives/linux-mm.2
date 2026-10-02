Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E007CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCBE6B0092; Thu,  1 Oct 2026 21:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4836B0093; Thu,  1 Oct 2026 21:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA546B0095; Thu,  1 Oct 2026 21:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8C16B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:25:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BA87A05C4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:39 +0000 (UTC)
X-FDA: 85275943998.24.C8C4D71
Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77DDBC0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/l28dwI";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/wpQqWeiDW/7/8YluMY2ot+oHgvGw2IfDVHY3jOKXA=;
	b=WTm1/x0ykQpYqujh4fjm6Q8enuVpdqFhceS7jryHSbxL6VMTig6RRLjCoPi6+sdEdq3zCZ
	8GGxo17iXNyjT2aOjIuc58aRBDGWC0brlUd2OoHp59sYC0h7gZmtmrGs4D4akaa1dAByK2
	W3n2HV7zXUIQrolwysnNx4Dt67CFAN0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/l28dwI";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790904337;
	b=fRUN1jq5/mA3nST8e/hV8v9gXwAybsmXNhEHIKQyNQamqdT+3P5pTHOiVs91XV0tws1ifc
	BQUd6E1UxRFX+zyUtzqWLSp4esGQ80CP1JLEDmZRX6kUEdAtsgsB9v3N+w7J0Z3ikeD3Aa
	Zgl7i15F/WFDxKvimCnuKPHWZmRubwU=
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34cde269e1bso1779689eec.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 18:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790904336; x=1791509136; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7/wpQqWeiDW/7/8YluMY2ot+oHgvGw2IfDVHY3jOKXA=;
        b=Y/l28dwIYAYnvTEVEgHzEyU5ImfvdWCqF/R53a562L3VXhWMyUB6HYuT+X4Qsv3NCf
         wm3rFqYKE7iBu2LnsBXsR6g/zDk8vtPHHpv4JikE2AZ8C84vepEHYp+/NYZJtdgHNU2X
         Yv9DiOo7mItj8HM3IIvnbjHBLTZ4TsKySt4j5x+d/bq1MJ/APZxVwAfjYazjeKKOZbfc
         28/mR8DoURh2WFLWg+BLhV2K1giSViE4BGGRYWXOepOggQ7jgP+tBIbGEHjv59COmXHR
         usQeceOp5DGvA2FTBsLL1Nm26L1scsIlT4VzL+hykCK9zQbp3BuAND2FHvFLRam1c09o
         9w0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790904336; x=1791509136;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7/wpQqWeiDW/7/8YluMY2ot+oHgvGw2IfDVHY3jOKXA=;
        b=el8txWAUdfEbLLTF6lAbXHYRbc0F/+DZLJu1njEp8+VRVeEdAXX4twTUhlmIUxYmgi
         GbdPh6qspuwHg/IgqlAEfKy23ijOA+Jj9/L0Z7ceEtoSgH19vCt9/hi9WkdgW5n9Z+Vu
         2DTncDHiPRs3G4rmmeyNGAOAyX22FRhTjzel6Lk4SORZRG3k6MNNjsFT1ENZTuhvyH/z
         /TR/ZlVxdk1O/ogWxn6lzyl8H64+c7jN51xB3qV7ubuXWdkdX6r6Zgeo7m2AsIpVl6dT
         go/jUaYV+0+T263YHBryCrg9ffG0owHmk0MOJKWxfSURn5qdJ4yIBh8SpKK7sNIMCcmR
         pUgQ==
X-Gm-Message-State: AFq9FYIiKkcI7lNU/zwY0ez66gdVZ2NGkVUb27KqBrDoJAkE8pzSxepm
	o5yTKs53RkisG60h5ndFUzQG++DalcVJX+9QTtMKXe8k2spH90SvRfF3
X-Gm-Gg: AYBFou2ASSU8g+X2bpcIbyFdyaXu+MXMBK0EIq4SPNhGqUIdflESUEV+hpjCbMH2R1B
	8cQN+F/Fq9Zsw/v+9ondu8X66ljrpzuaoGx2y4wHv0H1JQOgkiqwXJXBDk5bIQNo6YkB/gzlR2c
	r66Tm2X41wMsdcQXsnJYDYWGUKuH6ZJ30y474uD9Sxnm1NtjTvaTS32eK+IPeYmid5O82ZkpsaN
	uoe9CvKtbtcaHIYA6gHRSJM4o3htWhgutlRFDuXCXNrF5LKh8PPYzr76aepRwAR9EXT0TJgS2bT
	4iAcuodHVTusu2Z37se2oDaRRkottJQi/8Rc4l3j1zmtYASGNx3hK1fJcWcJaCdpCGw7dUgo/xI
	J4z+FhYuC88IufyUpeLUkzH2B9jz0wJpI4EkrNj0QbIfPqdltr2ikpu8bnlxtFTJ5rtfC5FEpGc
	LTWuGTkcT+WCRbeVqwW3DyxovCiDXhy7ivAdFU/gqS09/UIM110L9XGa8kAMlnBi7TlRwDSlYBR
	jvW3A==
X-Received: by 2002:a05:7301:f87:b0:34a:c4e6:27c with SMTP id 5a478bee46e88-34f150bf365mr1102272eec.18.1790904336197;
        Thu, 01 Oct 2026 18:25:36 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f984e4sm1837223eec.17.2026.10.01.18.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 18:25:35 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 09:25:27 +0800
Subject: [PATCH v2 2/2] mm/migrate: raise the do_pages_stat() chunk to 512
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-bug-mm-move-pages-stat-batch-v2-2-f73b5d20519f@gmail.com>
References: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
In-Reply-To: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: fcjcjqyn7nmjpo168co96hm8f3gfq57c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77DDBC0006
X-HE-Tag: 1790904337-110253
X-HE-Meta: U2FsdGVkX18zbIdHyxHX6gprnQx62YjVQuRgGNRfrb5jsAo9ZJhJ2h0Ud5fi2eWPvgomaxS8tntLWTkk97FQIkRxucEYhk7+RlxpF4O0k2qvWFBJQl3Ca0ao3NmO04eQBBvdCgxdbipRqu67beCKrrw9Okh8pkogD9BuLE1Al8I36+t5oiOgGvG4joy/RpqUFyhV/3ha1c4fcS/n0qBdE4QSQsWqV8/HNs2mHou6Yf1/rHY0EY0EJGF6uuun7TOUKr1RXAKyucu/cZ50Nh8En+mkrYCyidqn984aI/GAKnNVwMcdfsNgCOuqXwzCjNPvL7vN7jqd608yBiLy59rGgDOB6jFkPF1e/B2I3o4dU7MPk7cBrcYdbobAOs6HO1phKya8YWc4vX6MWqnZdLLC+/wHRw/YotGhGVBwRjxhydvfUEpmrWdRrSLGK6D3NR6t3ghmQnd64dKAza03NmA3+VnYCu/gwJWO6H7Pg6Qjf8sKjpmECIu7e4DBPJWz8ywb4+rswAKNgza9g04ff8ah6+macSVCS19qkn99Pfvz2rcgybY6aM8qkYD+VDioSXwD+LhYEoLHIQ0u4LGllhv2+ggcOWrY+yC4Q9WwTqFN/AdFQnnuo8EOTmTpBZRZc5wFtIe5CkxWaH11BDBd4/ENNpQp47RSejgxBEyNNfAdJs567lTWtPKtlt2VSTMNCMxsnYL9VvpVqhnMWDnu0v1ebyOIeYjmzfD0iraZ01I3pRDDrJCq+6fAD1psdfDt11cDyXNbZNRLq6cbNKb2GBb2Se99r/s+3QdeJMqcxBJNfki6XG6ebcjPiGb7FSX14WXZtglV+SYLT/efXJ3CzKtSbdG6Bu0ED32oi+N2Qn7wLfEzfOCFYAHzwB0TE5m0iLdbnj6WF0awge1Cz7QvhGrSzC6dbSVW0RGkLpJIa3ha6fyacPxT2S5G+zk+Dk0G3Er9/u6Y1pap41f0MAQvE3K
 KLQs1OHf
 9AuLwr1Bo8yLuHY1cqII8jwoOqWhQuOtbGog/+2bvwmw2dGVd5Y0j6NHQ6/mHByCM1uCz2tj6ZWgsLW98t7QVoD+uM8aeZnvVDOuzFraSWmZYThVYkBjas4BnXaDBM90BHYEBY+09SIe3pjnAoivF3vLhF7BCEtUg12VTcXCmPn+qvx105hKBuZj78UN1m1h7eiqbh5GcA1bIfBeN5z6Ev6DVb4Tsv3kqiYFtp9Wu1Ym2kYk4Al9BcQOAdbUA5bggu6z9xrOBMabvoF2E5GXUh2N74Pmd4dJcXqRg9WY0tBAKY3cuUwzP890h/LkntlkoNzdMNNf1Wv8jmUzacCymtsYh1zsKrbN+J5FPgq7lEU21vwVA90nKlgnosTFUUUAiCBVhI7wnKaxUfJWCIbMKxWhovf4k9NEFkgko67U08hT2olZO0bWQTJ2kA77fxHxOPzS7bDaUDsJWV92l+qxR0HQTWGAEsdjjtBu9avYxLlm7AqcImKu01EDJaMlgdCu5z6Gzam1v7GEu701UQFrz52/CIRfjGWkxd1dGgtp3DYxNV4SXkg6gnRX/4JccXEaoC+5Smsv3t/bpc+PjzxlGUwaHhSdgBEFSwF28
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_pages_stat() copies the addresses in and the status out in chunks of
16 on the stack, and do_pages_stat_array() walks each chunk on its own.
With runs of consecutive pages walked in one go, the walk setup paid
every 16 pages now dominates the cost.

Raise the chunk to 512 pages, the number of pages a PTE table maps with
4K pages on x86-64, and allocate the two arrays rather than keeping
6 KiB on the stack. A failed allocation returns -ENOMEM, which
move_pages() already documents.

On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated 4 GiB
buffer, per page and by chunk size:

                16        64        256       512       1024
  4K pages      31.9 ns   15.0 ns   11.8 ns   11.2 ns   10.9 ns
  THP           23.1 ns   6.6 ns    2.5 ns    1.8 ns    1.6 ns

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/migrate.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f4d8bfb9b7b4a..9c77b5e5cf1d5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2656,10 +2656,20 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 			 const void __user * __user *pages,
 			 int __user *status)
 {
-#define DO_PAGES_STAT_CHUNK_NR 16UL
-	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
-	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
+#define DO_PAGES_STAT_CHUNK_NR 512UL
+	const void __user **chunk_pages;
 	unsigned long chunk_offset = 0;
+	int *chunk_status;
+
+	chunk_pages = kmalloc_array(DO_PAGES_STAT_CHUNK_NR,
+				    sizeof(*chunk_pages), GFP_KERNEL);
+	chunk_status = kmalloc_array(DO_PAGES_STAT_CHUNK_NR,
+				     sizeof(*chunk_status), GFP_KERNEL);
+	if (!chunk_pages || !chunk_status) {
+		kfree(chunk_pages);
+		kfree(chunk_status);
+		return -ENOMEM;
+	}
 
 	while (nr_pages) {
 		unsigned long chunk_nr = min(nr_pages, DO_PAGES_STAT_CHUNK_NR);
@@ -2683,6 +2693,8 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
+	kfree(chunk_pages);
+	kfree(chunk_status);
 	return nr_pages ? -EFAULT : 0;
 }
 

-- 
2.43.0


