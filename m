Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B1E606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SCplhdpN
Received: by kanga.kvack.org (Postfix)
	id 137526B05CA; Fri, 13 Nov 2026 16:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F7A6B05CB; Fri, 13 Nov 2026 16:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024B66B05CC; Fri, 13 Nov 2026 16:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D143D6B05CA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D2F380188
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:02 +0000 (UTC)
X-FDA: 85431431484.12.AAE5796
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9527B14000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCplhdpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXNdUwNGb/5NMrJMkhrM5V8CwKIF1k5k6UpTYIeOn6o=;
	b=MzTQTciLqjqZotLLMawvtMqCX+XqKA+0k4wRpGcQpM+T6boICTKFChxAfVS6GLcU110ybv
	FlJcrDl22NocfqA2NiiTif8PYYzrEidkyENioZoZzBRBaxeAg0VNGXIdFgBS2UTMYj+Kxp
	R8yE6yUduKK/2dMXMq/bBHTAvyeLxFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606420;
	b=2/oIei0hXQ8UFP0sqnjA+v9bocjhMOJbf7xIhALTkuALroHVedFdC1gpSplHqb81wgk813
	uJKXve38+epORuObpIHrUUHz1mEUOFppE5SpJ8VY1jFMc/CSJdEJHAIubG6F9o3dhg89Q5
	tX8C28LBH9LUGV79VW2hHFd8dfDYU00=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCplhdpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC70645AF7;
	Fri, 13 Nov 2026 21:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAB91F000C5;
	Fri, 13 Nov 2026 21:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606419;
	bh=UXNdUwNGb/5NMrJMkhrM5V8CwKIF1k5k6UpTYIeOn6o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SCplhdpN4SOxZ7lUzltMf7KGoLgtjvpAng+X/qXAId63abfV2pfvo9oDBpoS3mNpm
	 g001QPNOHNEN6bf+OquYCFLy9Ex3eqnBUhe2JzWVVcGKhkHb+zC3KJ4epRDWTA48xL
	 JH3eJjf13w4dsuqpSocWNjX6M6MA+at3RVG7LwbRKW3h8QsfaD9zOYAuW/mqX54Sy+
	 wwi/qnriXRk2N9TCDRMdz0n0jaF5dAzVxXvc13X3xzI8hh9zYxEA3M0C0uDAOfHuwJ
	 n/x3AaxRQoKGytn8Pz5TMiB7h6vR12KmvOoI4bkUjSPWjyk9zmHGxhqswj6lRygI43
	 qTZYBR34aab8Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:26 +0000
Subject: [PATCH v2 08/13] mm/migrate_device: fix ksmd oops on a migrated
 KSM page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1690; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ks+7trH82YDke8ot4RopKlEtAXwBOms2oow2pqcZBhg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/ycPfflvzghXu7N29bfjrmzzCBvqm/Eor7vB5TFV
 6dFX0pO6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEDm5jZJjAtMLnm/L8E9G3
 RUqTchXLOi+ciSw2YXXpUcn/66WVFcTIcHPJEd6YD6u2uMtMMbr+repY11ddzTqFQssljb/ZFtV
 c5AMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 8eyqh7a4xtbkcss577nujmjrkshmae9z
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9527B14000D
X-HE-Tag: 1794606420-131423
X-HE-Meta: U2FsdGVkX18c14QCbFJZzRTOmrgRWFCcxLdipylxShreCHxCSGEFGvJdOpghRuMzMp57WW336eHuzkucnL8A+LXh5U5rBL3Uit/R9re8jm1kPDlKFh7YiKzdlW9rfITgwNLT6vqGDlxP2hHYwMNVoJLLbpfPBbBTWGgtDTKpmERARZG3njaL1MFGHQr46fTTpPXw5/ZMemsf9XAH3kM1C72YTUhyGj9Qq0By6gKmJp7dzPPpuMO+USMQFzMFSRgxZH9Lfzh5UFwMrZ5leu3WZ0YFJu6FFS8VqQIlJOOfUxozYATWTaM/lN5OdJqLzu4upIb3vtVPuVMGsVNwje6UrNmyPZh0pAFOv5D/maqyodqgfgu6w+ATvFhN054EokcgD3DlFg2DvKS3OkBq5XbvZPKMfN48xX7Wu79hbdIoKzwueLfbOZm/4139HSXv2bbMhYs/LP0wTpn71n4WXEC9joYG+ql2HR3d5OgulyvagWdD7KfL5rx2Pzvggj7B48rJvnZ5KUnDVW+Wc0nejRmV8ZWUCw+2OTri4wazl+WdwxTJwc+NA+QKwG1nOYwPAqTtccrnSgweKEuAQFciuZZhmfNVX61fTR6qox01rHie/Hwf6xUUE1bnT5wkrYGCxbpvffQuKDVvtdQEfx6ECQqcK6oIHOSgCMF/JdeLXFAQYqOmEQ3ZAm1jHEaHIq14V6wa73AfbrTUgNszYKYcH6IaITZQqmZ78yk8grCHNxy84b9Wjel0AmV1blcnXCsXje4QrB+SW8J8R0E+8OGRMewec1TKrSDKj6F3I4KI5tN7fznuBtZ1cHpHEkYogW3trsVp62PZeTnuJ3Zxad7PJxs1SJ3GhSpXPOrsKdkRwuT/G5EBHYO2XPoHmtt3yqnnKtKVjrq7kOq+jqyX0c9cEPqBPXnasg4EQdFgpoMuPqYbl3AGAXoJLAworVRkqtJ1440C0WImVdVWMZXjSRaOzqs
 ek2qwHP8
 ybFYFfWCCj73YswXC8CpZaZjH42MP5jrL7/Y8GteU0jHrOLLJNIG6U1vx3xogCVXTXrBnXXrOhZmsOPXs+5mvnQlDJ5oTrlMk1PVRtiXS3KKk34qgR1YYS+bj3vPU4AEOgaGUuUoI+Or4+LUOSw5GWif/ssMoLOeGHnvcfYOanWjQmjl9GcseeJ1q46TBTIPSfqVsYLqzX2NnErGJf7KUDVsxwUsntgmYHxj+FiHh0p/gEzeMDUPKYB84cbAyXw1YcuwDE7JZOCUTw3b8OMj379mEnX7EcYUnWU1oQ8ExNu9oCBcyEM2vIGwJY+R/kRTI0laPKCz2BoYb350nubRwPTHHWtv7OWQ9Uyi5oK6LBaNQR7YP0+bTEl2uQJYBows35OoQQSFyO6TdTDi1Mgw5FTc+GuWetky4znuFJIqdrCex9ttvA3xS0466Xo/TIbowBftZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

After a KSM page is migrated to device private memory, ksmd can oops,
and KSM then stops until reboot. A process that maps the page can also
loop in page faults when it next accesses the page.

The problem arises because KSM doesn't know not to try to look at device
private memory that does not exist in the direct map.

In addition, ksmd skips all device pages when it scans, so it drops its
rmap of a KSM page which was migrated to device private or device
coherent memory.

Disallow migrating a KSM page to either by explicitly testing for this
in __migrate_device_pages().

Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: tweak commit message, comment, also refuse device coherent ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 45e571dbfb4c..141d60d27e90 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1207,6 +1207,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
 		if (folio_is_device_private(newfolio) ||
 		    folio_is_device_coherent(newfolio)) {
+			/* KSM does not scan or track device pages. */
+			if (folio_test_ksm(folio)) {
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				goto next;
+			}
 			if (mapping) {
 				/*
 				 * For now only support anonymous memory migrating to

-- 
2.56.0


