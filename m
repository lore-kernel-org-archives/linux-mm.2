Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EDF606A32A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAUL4jLs
Received: by kanga.kvack.org (Postfix)
	id D76C06B05B5; Sun,  8 Nov 2026 04:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27756B05B6; Sun,  8 Nov 2026 04:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7F06B05B7; Sun,  8 Nov 2026 04:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97AD06B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A48DA8040
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:28 +0000 (UTC)
X-FDA: 85411365816.17.2992976
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 824A4C0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAUL4jLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9YVpcaGori2puyE5zAanYRUnygFfhB6f+1WzEAuvFk=;
	b=2G9ya0NLFiCpp3PL3J1YYFZ2uOYj/n1xwOfsgF9IEbUhgIPH5lnqm+geMWwF7DIOxlwh9L
	0OAhPhz+47wky7jpCTZZdPBvO/wxNc6qp032n+H4utJj0On/09THo58TguFMNjCzNgobzE
	BDVZPHAH00QGonK6RCf6A7pegf8gzmU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAUL4jLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128666;
	b=NfbHi2G5gQMH5fSeRBf8OzIxE273Ty8h3wYI23oujoyMkVc6COriVkpu4y3yBunEG2nbBC
	sCmz4rHAxPLVXVogii/vKoaMAJdlRarfxPgTlghEhT+F4zJMfaFjilN1GeWf5K3wcj0Ki7
	5qY0SSLkWgoEd4YDt5fc4PujG/fMUvU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D033242A41;
	Sun,  8 Nov 2026 09:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E171F008A1;
	Sun,  8 Nov 2026 09:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128665;
	bh=x9YVpcaGori2puyE5zAanYRUnygFfhB6f+1WzEAuvFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fAUL4jLscGLJ+tf6SpxzrgIbn+5a29yaeqztlM8AlIqW6u3j1rjfchRY8kQepjSWJ
	 2Jz9llxOvprkl7wswvMtVdRakDmlw+02k9Yh1htoFrluOBplERvtElvqighxFFpIi/
	 qSydWg5GwTOrsbE22DcNB12KM3XQTgxT29w4FvcALD4d8GsJ+ZPLcwdtXMP5yM+XzQ
	 QkE4G1RrGU1lFfaMvK/76XBDultGVMbE8E+XGM7OsVmAATAQHSTLZvFdLS7q/Q2NbI
	 P1H3Z71resEmAMWp2+1+pYu7wHvRSTZ+m6KS0z71oC5xPbzG87oDBj/WAKqIUqUWj1
	 rt5XjFypzC/Yw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:32 +0200
Subject: [PATCH 01/14] s390/sclp_vt220: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-1-3e7c90eb6676@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 824A4C0006
X-Stat-Signature: k4bhqj34xmfzin14wikmo3goe79ttr5x
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128666-633163
X-HE-Meta: U2FsdGVkX18e6n8vMnnmmxRMwJwHUONkrkq7CqxgwkNLgBePluAwl0B6LXBNeYfTEtK8uwIQMuoceG9exNcOfTucpy0YUee7RYocH1JrP5ycMBmEj2M8G32Z+fCzbXq4Y3631O+n4yXqupR5GpH/fZzcdGQ3Ejqo8C4UiiZdXVRSuFRpxBBfB+gu3yc29TOCvt0hDOyT2SXr02Oqtj/GIYNxRRYRUKkwZDH6jrKwktpWD883btOwT3h1FA+tHNKsxxCKFIHs+ALKmZw8gQ5VQN3cExpjxg3fJv5PPDVaCB6AZP/D14mhEZBZvAsRqa3xJXVgQQstRvGhYkc5bvM82V2fjUNcEqiEkT6+FMiJ7XkqblBOlcXxJcMCqlkp3a3p9P+ZWo1wXk2jOSAwN79EXEPS+0nXKlKXNtT/iZdoN29+dBoDGG0ceRByva2Tx2SqUjeBt21tFwUTT8ipdfPPTqGQ4XuQJXlIW6QzqY2f81NnyqdVxc6nxIu6dImNzPM/fn5+L/emtoZKYrl2/GY7eAuwGyfuidP8Se0MpuJoI4xwLBDVrH2tlskke8GUb4RZGidsA9QPCMZk3gKELzjMegvl3K2ZdllBu/+4KJwNHz2V8CYFCmG66Yqu+2G1EhAHQvmZoO5+CFjMM+05McB/MDk2v+hTISaysVkKbkgPXarTHBWCDQBlZ3k1BVz0A7kTZ1erc1UkS0gavE7y3GHdiJBjPL34bdOSOqrFnU2siSGvja0bNvutfyiaoxr9AgWnieGLlekpOUpZpO05M5KU9530AIDkO6qTm8RVj7/qN/0S/QJda8ulVjTHcdvIQg4YDHxzVok5+4uGvXJ4+RX3emKuQTKkaQNN0UO7II92BdWx/GjHO2K6eBTieZ5z5nmJnVC0M4BifmFaGOFFjj+lBOYkG+K9hjkV7JWNxzv9wHaAj717vqPMLsXKMIUMyOiuAQXQD43GWY4KOmKVA6M
 jF62tr0f
 0jrX6c43RBACTPVKjPUqYoytcfmBQe8n/6avIH6fyEzAPfYB37wY2ECKl98JYoOEA6FEdcZCiUnseRgx5qHs6+bNd9VK+ML6hF6sFIPZFU2RYrd9unp4IB7FsiaAWODlFdgEDsIrwJyVjj+XnfqZG8rUVl66u182WzpjVKNQHO6YOQ51b77BnsoLE5vuVTu2sY7efjTzyYQaJbLHwk/TEf5aaF7H1Xt93O2Ywns7pBKDvJp5Z1+s7q8TacHnOksyFNiGHHME1h9+gNfICfFLy68AVehQJmTwlEU+5831EL7UGkH7mpZ48AtiJAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__sclp_vt220_init() allocates the SCCBs that are used as the output
buffers of the VT220 console driver.

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
 drivers/s390/char/sclp_vt220.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index b95af0974624d..e79467c07d244 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -715,7 +715,7 @@ static void __init __sclp_vt220_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_vt220_empty) {
 		list_del(page);
-		free_page((unsigned long) page);
+		kfree(page);
 	}
 }
 
@@ -750,7 +750,7 @@ static int __init __sclp_vt220_init(int num_pages)
 	/* Allocate pages for output buffering */
 	rc = -ENOMEM;
 	for (i = 0; i < num_pages; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!page)
 			goto out;
 		list_add_tail(page, &sclp_vt220_empty);

-- 
2.53.0


