Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2E4606A33A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ablm3vX+
Received: by kanga.kvack.org (Postfix)
	id 6C66A6B05BE; Sun,  8 Nov 2026 04:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670A66B05BF; Sun,  8 Nov 2026 04:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560156B05C0; Sun,  8 Nov 2026 04:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 238556B05BE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F3CBC030D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:43 +0000 (UTC)
X-FDA: 85411366446.14.73B8545
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E3CFE20009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ablm3vX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4f6ZdnIE0tPvvGmmjPRNkhj5X7OVxmpaKFCvrKiayoM=;
	b=BDq0S0iqw4VS3GR7LJUJ5pSy+czcI6soWiTzZkFZud5BNyiHQN0VdKGr1SS2/eV0YUPfHl
	YX3nBRflzz62B9rLHY74FYPSEL9MruJOyMuS6tgJbsxPatLEho/QLsmR2z3B+RVRs2cKxx
	+SJH1dE1lbBl8SiNXxFFzguOWhjmako=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128682;
	b=0V7jW5nXQvvWTryktJrukYO8fv/l4r5T5Dbu1AqF2madUI2AraZLzZMda5B7xYcsMZI0Hz
	3bjimOpPmJ7KOF9UX0lDxjPty45ni4ZXEHdnpcmjy88wK5qTbyPZ6RHMd6QkbOiU9Ci484
	pH/rODwUxTkCuyyGVgS4x0d5eDK0k7o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ablm3vX+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 831996149B;
	Sun,  8 Nov 2026 09:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56641F008A1;
	Sun,  8 Nov 2026 09:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128681;
	bh=4f6ZdnIE0tPvvGmmjPRNkhj5X7OVxmpaKFCvrKiayoM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ablm3vX+NierNMFKJlQnSgrrXdlcLZ/0EOELMb7grOAnXKnbLgKyV2Z5bz8+t00ru
	 S4p81ww0Ffl8rd1nRqX6sJq4L522LGRlpAdK9elkJmejFAkaRBxlbXca/S+j/TTt/K
	 pQqSKoysv4nOOBO69MRGjkPdNqI/zB5ACiu9CsAA8TQaRCEw0vDTQvr7z0OeDSwzXC
	 JlKWsyBRmiKy+qhYh+hko05LGTyvzRbhWNdTD1YAUux1WcoNUMys5cpfmq6fiaBeWy
	 KIYZrT2NVxmBBmc69rei4gbFGwoc6sOdQetOZKqK81OLLJououNu/Uo5YPFC/A7eLw
	 /9mQdts7Fh23A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:37 +0200
Subject: [PATCH 06/14] s390/sclp_tty: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-6-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: jkti33yiiz66j71xew6mgomube8dw8fw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3CFE20009
X-HE-Tag: 1794128681-86161
X-HE-Meta: U2FsdGVkX18Jt4v2iP2RAO3M3U1HkOoLyagj+wFAmyd5T75AlhKJPEFD/o59tosR4kq3hoF/LJI2Z5PioxatgyLP04doTQgDQnN/oD3gpAiyP/6Y3t0/wM2kBCynBnIwX41Rz/JrSEYFobljwcrjhHKqfH6m5zptHfCuk6dEypdOPEK7rV+s5I/XmCFEe2V/5yFw3xnsR/ug1R/xhXzysGP3/tYkX+VXRTTihlaO/6Wm9z2VXlRQPFn4SnlX4YnZjnQ4hcrjG4Gq4WSyF79d9DK/b2hIZCJl3iJVZ25/IYtH2r3WbWFB/tifRG9oRxY+FJ53nj0Q4QK36AhBEvbCTtNDVpm/GyzZeIuJ2Za4oWJpUfzmPVAhqW4jYIDv+ZH+rJ6hRoLdvTRW1+XupxDSTZqqkORNW+d5F/syLWDrx4pOmkRL3D7SN3uGL5byuKMW/tFWk46z3fZjqZJbUlgyl8IwVyDjtuyyTUfn+WIwuwNu+o/fm/KANohs8nsRE8GPYAzRYjFhBILZFq2IL5bAwVpgigLPBHLUlm8SOaHhLyHqJe9cIobYqtiMg4TCdGOwQRa9MValyemBTWMLjvFRumIvrFm5Ob17aOlegRLJNH14PQPHbmFmQQTYxBr5kWVl/bhyEZXLS/CSLPrf9tFdceWWUGRb0/Jmz+mXho+BJXBZKczQHxdFry48SdD8sSEpd/ndfUrr+TwmQKERngLGKhUg5LnREd85Kf7lxMCa+1gTPSHdtTE4BaD1dHvwJ5bTL68d9P46pDbqlXwoYt0nPF9RffVEyI+fEwmhg04g9ENEWUGuZjTnX5D+NxyyShbVmUbg8amYEPpL8zirRFSqvDF6oAGb+EOrUyTrmF+WGMqCCG/q0YoLaOpQVHPScmciFZCAM3hoNQdHESmIDDtBSTOxO8HSYAGR8TmhzS65Umw3H88eb/QLX9zNjNjdsv8vLtmFeAZvjTklHzQn2S/
 ofUH4q6U
 i90JdNdL9PIW5/jxy7bSqWX8yFxZvTB7dtyyJn4AARnRt+v99PGGKru7Lu6Ipp23yN1hTV3GtZOJ4DhVK0fBiHT7PjcHeR7ipDZb1pfgcF8bWWOJ9wtP7Xuejs5P/97I8LV5QZITPZjYGUvp7h32tHedRBtQ6iO6Ug7rRCjEVl9grPE1KtL5BtrEq/I29jPz9lyVqgS6uAKMy1IWLepvUFb9ilK3sO9lbHi3rgIUzo6yjpO5JTUYGfSU1bqNNAyc+8m1lANSrsOlksc7sivh8DaaGVZ2dQnv9xTbwgBGsbh8Kvy5Pfo0Wu93A7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_tty_init() allocates the SCCBs that are used as the output buffers
of the SCLP line mode terminal.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_tty.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 0a92d08830e7c..e36739bd27328 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kmod.h>
+#include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
@@ -497,7 +498,7 @@ static void __init __sclp_tty_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_tty_pages) {
 		list_del(page);
-		free_page((unsigned long)page);
+		kfree(page);
 	}
 }
 
@@ -525,7 +526,7 @@ sclp_tty_init(void)
 	}
 	/* Allocate pages for output buffering */
 	for (i = 0; i < MAX_KMEM_PAGES; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (page == NULL) {
 			__sclp_tty_free_pages();
 			tty_driver_kref_put(driver);

-- 
2.53.0


