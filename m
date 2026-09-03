Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98DAC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36776B00BD; Thu,  3 Sep 2026 05:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6AF6B00BE; Thu,  3 Sep 2026 05:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923E86B00BF; Thu,  3 Sep 2026 05:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6649C6B00BD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:21:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C365A1C21B2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:21:45 +0000 (UTC)
X-FDA: 85171908570.12.D6879BB
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC85614000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:21:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXREQmOh;
	spf=pass (imf23.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1xcDUaTTj5abc2i73BnSXpGTrXupdBhxRIF/WgrImfs=;
	b=a4eEhb2SiTGgG77rRvX4J9zb4eeQk4m93Bh4DI/eZ/q1sSLZlaEeASBZGZkOatn6d81q30
	cMV1GK30dk8luUVNXbHFd0IkSopeH2flPx/vAu5ZXFQwp4ov0J17ePHz0rZbxNkHBOKgym
	KJca6jzAeEMJusAWJxnvRuRYnlE2mMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427304;
	b=UDR7VKTBPU9t5ad+dFSuDEVvmivP/bgwHsagYWGLE1rGNEqLEWUUA967X+p/ZGh4879Ot3
	q3z+JPZoEmKJmGmpfF0x5lzVgofyW8ToIHemvvipfzpAk7dtw5pDqNs8tpsQgwgSZPQLES
	jFkPxUQHZ8NDNdCjhymk5Xm0Vh2ntag=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXREQmOh;
	spf=pass (imf23.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NM7IygWzUo8F4bSYp/zmXdPd2UURJlijaDZmCMsb++U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788427302; v=1; x=1789032102;
 b=xXREQmOh6gaPzBSOSCCpEAM40Rg/w9cFj4cU+4VAPuUTVLLJ2eX4851NG6Zzh5im/qxP3JOs
 kPZbNJCOVfH8U+JUADV7WZfgkdv7VnvX07az/CB0RQRieceNwI45bp+sZXdY9UL0olmQ9xgXYhQ
 bsv8LdKRI1L8wyNEc+RAhJ94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 997dcd35b942ce68;
	Thu, 03 Sep 2026 09:21:41 +0000
X-Mizu-Trace-ID: 997dcd35b942ce68
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/page_owner: preserve original free_pid/free_tgid during folio migration
Date: Thu,  3 Sep 2026 17:21:26 +0800
Message-ID: <20260903092126.24685-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 89ncbtu7oii5cx6h6ptmmpz5o4cef13n
X-Rspamd-Queue-Id: AC85614000E
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788427303-626539
X-HE-Meta: U2FsdGVkX19BcGsf3D71k6TDn6IOA7X7qSBWRhtsG5PQ88fypxjFNUePdGOAdX+FzVid369iYM7tpolMuFppx4c6SZMSf2kLgDUb1QcQ6F5E+e1W1Wn+HEkS2kUtjyhOtlqNpXwpgQSA0ZlkMGT2YpoqngftLHLiyggnok5/Qx+QB/Xr6Qhw4cjWzykji4+fGeKimtdv7Z4DV4PKbtMHyiSQH9L2benpQ9+vED9A5PNda3b/O7hPkUZJ9n0fM+C9VDBe5mfsNHfcSmxXTh45TN/SZeVm6MQGth90PbbMMQ3x75QK3wbd4WQQTWiEUrnMwoDEaRTxGDcsJBGDyegPGIPJEhjO5isc/lzsyioBcN6YcJwYcuXuAy6N+EKrYmJZNthMXrjx6kc2yz4g4VbCvIp74JfpKPOfMchyt1y7AzKiiuaqF4JqVSeMbD9H7zC9Yz9MV/Fq3Cbndr8q18LKd0roG0sDphHrGLstI5LCV3SVPQmbiq4WnqmQHW6vLS/ohoSZvCRAOI3RtS55EzuZaY6RJ9GZU54uGuXK6IZK2ylJ7JU2tWKMrxC6fZ9BaRgdNt7gVS8/eA/qcb0kXLGeMmOqujh4Tkos1ppvdwhZjorqR4oX+BEcMaBpYmCkEqDE0asFpZTzcgNYv4mp0ZomJWFlTy0jAE4wOFv6sBW9tlA+rwyBSmUgPNBI3PIfji7RixmhOT4oSUiBVA5NPXMo8imVLSm6/ZnitxPZukWrVKqhfyvCR7xfLPoRAMGHtt2ykzl9gcZZKmnz+i0kqGlHBP/mOynNquYqj2IjwxDtYT9lgFQnat9SkFrQfyfncht0vD0URdv3Y6uwu6ADoTOz47osO8t3C3Nf1Nq+zE30Gmx9Q0/yNF77dpBMqO7N4+Z8j1foc5rSigHnJDuZUTAYttLPme64TgHCHNRX0ZJskzZ/M8RmaE3WCm6SVQjpuJIMKNTJbxiePMI7K3oSPd7
 NkX1XzQu
 s3vCMUZvi7mdsny8oSkZmmNeQXpG8ZHwYLlGXh6MNXw4x94XmLSKt1bLRxFgFpR54eJKEgWCrdObkMf1yGwCdHb/qiMYDqof8E1CFt4exWKihbQLnMgUsk8juckz+Pl+GOPbe1WnGcsfHADpczqEGL53WvN3WpTT8Uz0lGRKCt6j+0/fCHvM4yklm013OMnEPoFuAgCBtaLHtcPGo96UOJilo88rNnm8x+5yOJHiPHueCn2eOrz5IttEq9iCXSt9RKv0fadw09EJBr2N3LVUFe9EDxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

__update_page_owner_free_handle() accepts pid and tgid, but ignores
them, always storing current->pid and current->tgid.

__folio_copy_owner() forwards the original free pid/tgid during folio
migration, yet these values were overwritten by the migrating task.

Store the passed-in pid/tgid so the migrated folio keeps the original
free attribution.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/page_owner.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 3fc37d9b908e..cfc31c92d765 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -307,8 +307,8 @@ static inline void __update_page_owner_free_handle(struct page *page,
 			page_owner->free_handle = handle;
 		}
 		page_owner->free_ts_nsec = free_ts_nsec;
-		page_owner->free_pid = current->pid;
-		page_owner->free_tgid = current->tgid;
+		page_owner->free_pid = pid;
+		page_owner->free_tgid = tgid;
 	}
 	rcu_read_unlock();
 }
-- 
2.54.0


