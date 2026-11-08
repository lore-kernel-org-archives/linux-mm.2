Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D623606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoOEDJem
Received: by kanga.kvack.org (Postfix)
	id 0CC216B05B8; Sun,  8 Nov 2026 04:04:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057806B05B9; Sun,  8 Nov 2026 04:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60196B05BA; Sun,  8 Nov 2026 04:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCF5F6B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46CF0A803A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:31 +0000 (UTC)
X-FDA: 85411365942.05.8ECFEC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 912D8100007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoOEDJem;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128669;
	b=4yA7HrrVpm7QjCIBpJ51ggvorFOuHUEX0OL8rzvH0y5/PWeU5yemQ4APlk+IjIVOsl08vj
	GY540+pjvhLXA/xSbEf9umyre90jNgZK3+d5yDSAHVUjlkuSaUxh/Skt0VRxekwetPN4R8
	axrVZpZ9yWS+fdGBufW0dhSoQv/Y95I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dwK/9jxJNdgEEjIHynAy9/D/UKIq5KAErG5vvcQ3cg=;
	b=S7k1AQwJFSIi0OCku/+CVmL+Q/rjysyRtUsmpxi7EsDbwFCfub5KsDC+Ty1O06NKXUfZpg
	gEhQjBpK6/3wwxiNmo/H577Mvt+WWYdGRmZ8+GDrec2k9etG9iQiR2acsDKWZjxliSBg4e
	UVtGlNg0nId6WpttgK0Xj+tQ4kRoixk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoOEDJem;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E660244040;
	Sun,  8 Nov 2026 09:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D31F0089F;
	Sun,  8 Nov 2026 09:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128668;
	bh=7dwK/9jxJNdgEEjIHynAy9/D/UKIq5KAErG5vvcQ3cg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eoOEDJem9eyTIF62K6Ym6dt1bY2Cexl7poso3szLa7Cz6TrYDCpvEg1wOIUqQhwTT
	 x+7mmKMIUQswknzccH0pajd9c2/02vMRodg4qY4uP7yoTgETugHKSYBmuTVWHe/zu6
	 /krJJBun3ayu/cvyOdXAb5RVdERWNn2PnoIFHe2ML8A9m7yWOsOK+wAYQxcJORJk7k
	 9YIfWQ+hjdU/wGAKqNfqNZvDN6nBEsZN8B26/yWzKbmf4GHv7KuCpasDICKWvZN/AB
	 cWInBO/aNdk218ix8+t3qNrG33A1pjwy96tIni5vXiet3kWRSvTur57SF5tDJoeyAw
	 JwKaV9Xl8Vjsw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:33 +0200
Subject: [PATCH 02/14] s390/sclp_config: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-2-3e7c90eb6676@kernel.org>
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
X-Rspamd-Queue-Id: 912D8100007
X-Rspamd-Server: rspam12
X-Stat-Signature: ykab3qwy7xdhwb7uarujmtu83azmoo8d
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128669-85253
X-HE-Meta: U2FsdGVkX1/r98GusJR101v2f4RezWYb4z6et/hiFEWp8E32c5xdza+QVwSxV4PhJE5cfUJWMDAdCM9ZjOGiLIpe06PO9Tb06eoTgeXcR3mXjwnPPumxD5xu7lUe3QSZTLJdYXu7+1N77dZzzhlb3CAEAKDS/SKcYn35oGcnodLZh3coyUtziXEUNFkQKHhR8yLatLMPGMeQk/3A00PLdf4s93fikkaMgAv9YwM4rZpNMYepmZI110l2qLHHKojrcIda+zLQq4faUVsRTM+ZtuH/WvoGt6dTamXuuh547Sxm7UDVopxGV1xObEmHbR2F1KV27JWD54aSImVSyxrY3pcztcrLTkabODKX243D7Q8QhzFB3vY2mWfHQq+ghaua7HewNwekttJ9adwLvW2HVNxC3Y9aFU42tkfCWzpP8H7pP/dnL5HqfzvrwM6OmgVhK/uepviI84DlkB2UAq1TWYN5RY/Ux18L3MRoGMdDBSDQwqo98rx9aGjSNGI0bzy84sl0sonTCWori/tVM1pS6XSdXC5qu3YeutDCEtHGZec6UTLytswygq7Q15ZbA0WOQJJJ3k+I+aIbxltZmIFRdmIdvNFKM71vD0OLwzHPRKhQiJuuVF1mgo+fqKQcCghe5m11jDmEIGmsOLKakTVFl4bILaAoQdeGsROWpuC7F80P2v+QbwJVH2+Sl5qU7Ln7MOJoOjGRaUIa+WwqKlyVVRwqOWBpAYg3d4qZKvh2eFr52Ew1F6OF170t22Ymx5sGgrgmsXOgG9isIw4az2TZHx4JlMP7O3c9xv5sKEfJFcc+/EQIkn1/ajqQPnIb/HJewp/96DA6Ex0SL9LaTCu5OlaEihPHeBorqzUDGY6is4cWP/y8FGbtX1loSIraq6DLUPEWumEtjYPKJNK9aLjU0D7DP6R0clyC330ajHGxTG/I5iVfOncCpGFU0fw9DJgzk4q0Aqg/z3dOjlupQda
 y9UhKvUv
 AEzlkQmYjsxKInbqFvUl0LGCxbTmJUyCRRHyaEhYyzpInUyhna2WdxsjhJJQpmcW3wbLmCg/19+ACjOViCaL5mAdeM1ach+CJUGGeEQlcmN+I6pRRIvpJXPgif4YwaTNGw+8MZDAaM82gaBqeVf3nWkJlLkQmxO/7ioS5gQQABRV+fNAycvwo0a24pxBf1ydk7vOfLSPE+UY2ofOA8zrJUR1m+lLwnqrFQDZFYbVRp9gFdPuVU9TjSkVbs5V7AUc6EBGhdUM4enhjmfx6Ztt2P3X+wxTQpRlN02k5Y54RYNEQalVRloT5xY+O7YhYlw1W710gDQLTE2ehpqMsTGr8VSEvL1SfGtrnDeM5Hh/OcwAspN03KYCWYMYMi+EQWU4P8q4qoRnen2eik69xQRj99k181g7VIx4oIW5+lNnLErm9eNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ofb_send_req() allocates the SCCB used to send an
"Open For Business" event notification to the SCLP.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

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
 drivers/s390/char/sclp_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index 8c77e8c44fc23..16617a679366d 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -93,7 +93,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 
 	if (len > OFB_DATA_MAX)
 		return -EINVAL;
-	sccb = (struct sclp_ofb_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	/* Setup SCCB for Control-Program Identification */
@@ -119,7 +119,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 		rc = -EIO;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 

-- 
2.53.0


