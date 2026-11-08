Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE7E606D811
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3LnY97A
Received: by kanga.kvack.org (Postfix)
	id B8AED6B05B2; Sun,  8 Nov 2026 03:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED0C6B05BA; Sun,  8 Nov 2026 03:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC206B05BB; Sun,  8 Nov 2026 03:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF956B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01C2440343
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:20 +0000 (UTC)
X-FDA: 85411327722.05.7371AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5082A180005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3LnY97A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0/h2A5rwxJVNDSipV463VVDQJBhqLVmF0Nxvl0ClsM=;
	b=3y402iZsWpYNbpVoiiF29Jj6u54dtdmtxzjAtfiiEGBf+uoqFY6BofB4bQz2BbSJ0VsHZb
	Vorc1BiKVCe5OZRofJn7iAql3lnNucL4HN9bvB6QvZbLfcyHAzAfssc0BTwhAR8rQ2CrWv
	tAJ1/Tk9xreALW9vweWyeHj5x5nMR+w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3LnY97A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127759;
	b=MSS2JmtS8tMy2y0AF8KSQZ2pQypm2Pj9CtCE6N+y2bTwWARnS7zV7moyANTHOMb2HJ9Ycr
	rCSN8b+0dbfI+3JlntB61sMUZhK+9I6CfDZ5DtCXg13quOKe7ejlAtGJfevxFFjmrhi2In
	MAfEU2/JYUARngcOnXtLOxK992M1liE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4252614B7;
	Sun,  8 Nov 2026 08:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB541F0089F;
	Sun,  8 Nov 2026 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127758;
	bh=H0/h2A5rwxJVNDSipV463VVDQJBhqLVmF0Nxvl0ClsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L3LnY97A1SL8QgstjBbwFfQ0TcuCvOVWGbAi+Pvhq73TMaxhAzAZTxGr34Hw4XIc+
	 80VpQzH0GrADK+Fecfhpg01a6PP1Nu8xD0RZOuPDS98IRWNWYyy6hSlKq/RNdG0SfR
	 VLy46A96daD9K8EDQqVdOUFqHVEi7B6tUhIbpcAwQOWs1foo1cUu0loUG5IasH3MJE
	 5G6PhjCSkAUB2O7XwQ9zKDKQypic1YVwkNcmzK1TUXIggJen2dQRGf03syqSRn921/
	 nohv5C68eyceCV/EmZu+mkWF0f7YVGKwPbUIQBoQN96+8toclCnpdStMRjq8MeXud1
	 mrLVHbQ56XRdQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:49:01 +0200
Subject: [PATCH 4/5] s390/uvdevice: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-char-ready-v1-4-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5082A180005
X-Stat-Signature: ejf361wg7qdesitajd9d7t6qczoo5oc5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127759-274902
X-HE-Meta: U2FsdGVkX1/lSYPgg7X5qd6eAqLmshYB6J5y+CHbucceRZrIwNFihC2TSRdRItyp16dVWg59D74/aYZ7xqR+pQGWoI/mSR05fzJWkG5z4EuGBUs/ER2NELimbvDiGYZSh5yIxBzmo88ABvkffE63DF3MuA2FR8UnGRbAznFvQh8rjaIzqQRGUrLRruOzw9ifyaitMP7vA/vyawaDmuj5kWgGc3xf2ScpHAt+Ens86ssp8Cxfo1v/yhkRutefofXhMyqVoVzjAg1J7RjlgjZ28bJut5EmIbh6BjlRsas2jpxr5T75aRpx3wkxY9mVoNxhBPcajmQm7Z5gKdN6T+gOMjZXojLY8DN2li+Uu55uVBAHgpb75aJR2IYvTewEF1MH01SKd+kAMbkS5ZR+yGcL9/BmyHtm038MmPtuVMDyXaKKIpcw+QtS9HqDf2Hl5twu6q7qvQ9a7OMAT/skfycBU+pVBTR/tefL93VcvYZQQQ2AsAhkTN7bR1m5qyAcJod66BA1ekBdxLpiXTLqSgQzezLoLnkQmaAlhby0GLOvfiKg4cSCZ892znMMstdXY0GFQNGRiravFchH4gRSnY5eLJTs9hQYe8Un+4KlmhQVTtg5n3YNwO8YcwHjOi9kTynpO2dO+0Kgn90W/ZuS9+mYDjbLFKRMYVy+GjS9FSgBsmILvSxm7ZEvVYnhh4UMO2a9TKVWnenD2MvGpGItIGX+rMDnPYIj6yr4KFLuQoNxiMPP+bLG6N6arHiP8Zo2maeEB7id7xKI0+Ea7pVIJBVGzTgSIeqTNzur3gRiBumQnTfddo4FP0KZmh6ULhOcd+cNiuxZn8QWva5JHVO+16aHL29CawGaJx549hu5tKEnF/hCz7gzL9FhqqciL62UuzbL3Jsao4aD3Owfc0PiIxc6y8BEfCIcev61N7FtuS5IMIdAncpPLAuqQ87gYXXz73q8Z4XqlZkL0AzimXE5vmA
 1eoPKXzk
 Da5sCzMurqQ9aXwGO30qh9ce75OIU7kn+lUAiyVShlHbSHkNwzN2oyq/odcEQj8VEN4enoatwmotmSWsdzM6JZq5SCNcGt7/tdirB1P6SXmkwrojO9Mad+6RtFHWezCAKQFlAjCTMyjb2LQHpdvWbKadn1VJEw2n8hFIjnRhmzkw9JX7HUZEj/o5HPMGX3IwatM6BW9DM9nyq78KBhSJjKCYAt2E+da8kTdXJ6dEIv190V7P6K5jvkEPLani3OSf3j4ZVNdFrvxe7qSfuPK/qYTiHo0NrceXmOP4BtP4OjrrgnrNeYtzxNg6Cffm4wCvAafDL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

uvio_list_secrets() allocates the buffer that receives the list of
secrets returned by the Ultravisor.

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
 drivers/s390/char/uvdevice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 4d274a2ee84dd..5375cbef2810c 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -371,13 +371,13 @@ static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
 	    uv_ioctl->argument_len % UVIO_LIST_SECRETS_LEN != 0)
 		return -EINVAL;
 
-	zpage = (void *)get_zeroed_page(GFP_KERNEL);
+	zpage = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!zpage)
 		return -ENOMEM;
 
 	rc = uvio_get_list(zpage, uv_ioctl);
 
-	free_page((unsigned long)zpage);
+	kfree(zpage);
 	return rc;
 }
 

-- 
2.53.0


