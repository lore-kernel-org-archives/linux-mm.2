Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613E5606A33B
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P7eG6bSb
Received: by kanga.kvack.org (Postfix)
	id 931956B05C0; Sun,  8 Nov 2026 04:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC446B05C1; Sun,  8 Nov 2026 04:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D4C6B05C2; Sun,  8 Nov 2026 04:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33BC56B05C0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2C72120446
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:46 +0000 (UTC)
X-FDA: 85411366572.04.9F950D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BA16120006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P7eG6bSb;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128685;
	b=3EGLtN3Keyc4UOOIh6Am5JMqr5h5t8iItBt2qKmbsChU/mPBr7AKO04ebqvWJ/p4RXDFLg
	+StHWsmxChokRpKPkjeQGoPPwwe4Np+Xda++SZQo4ufrsus9hUIuyoQvCwubIt+lQVXMVI
	HgJ2vPmpqZgKww/u4zWMoJZdiVATHk8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P7eG6bSb;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BEDb75+KlXwKKqBsbU7KIos10JSO/7hJB/UiWOZTvA=;
	b=A7ROgKu2q2/H46cU1FQsht33DFdv1JtiNYWM0+/78rFb3bkc5VIQUqxkn+Xo15ekk0L3U0
	hByC4gA6tZjwFdR1voiaW0znZg92lSmaeBHwO7cGeJDMfYblEHxg60pIk/9ryZrC/1+JLu
	ovVib6HrNLsfAgBGQ5gWrhDt2ywoyNE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CCF261435;
	Sun,  8 Nov 2026 09:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC59D1F008A2;
	Sun,  8 Nov 2026 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128684;
	bh=2BEDb75+KlXwKKqBsbU7KIos10JSO/7hJB/UiWOZTvA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P7eG6bSb7y3UfUsVSVuy7wbuk3wUu8ykJI+w9P/X78rMEwqlKslu7MOiHe3pX1yeJ
	 CIxCZQGi/A45U3SHNMlvkhVgXSoUi2/E3EQARpsCPPfMowmZ2gk1qu3UGWGibPzxYE
	 2/7dGqmz+PSMycPnvTLWhH3ja3vFKP50rZo+B3OT/ER7NZxLSjZzGszn+NgUMbBCBI
	 oikudTn7nn1p0up4YQObbpBtXsyXkkvAcYTh4I42FHxq46iYg0Zcg2wqjcOSe+StD+
	 B94SYXDPIrC3FxiDlh5ilKCqOflZQoTAv1JRligdSXxPTUaDP2tBKpCzCXjS4Zrl1b
	 9o7Zu8H75MUMw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:38 +0200
Subject: [PATCH 07/14] s390/sclp: Replace __get_free_page() with kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-7-3e7c90eb6676@kernel.org>
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
X-Stat-Signature: u561knedrxt41otmsttspmnesupc7qt6
X-Rspamd-Queue-Id: 0BA16120006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128684-460396
X-HE-Meta: U2FsdGVkX1/XUpLscBaKJ0zCd9hrIDnONQJ28Zv8X9qKZDMzZc0O84jo72v38ICN2H0QoZb5rxqM4sozK/UFyV4MdOGcnZN7b3m+KRH+qbSwv+V11fd7LHkQ2BrUDWTa4ZqU1yn2zFRMuei9XeOgEaOjK1bfNuAisqgFexDEERXK/OXHF/C/Zzjkx4GvcA5wZpT2+b7xZAHAyiXeBEerZJqY7DUdRX494qMxgXmzI0AgLQ53vAdxARGBdoDkyIaZWNljLn/zwLNkd5fXdyyMJ7u589letMwFeo5jLcnrLxJpirZscsyYDCAAMjkQTAAtskOrr/wX4Q7CZeoMltpRiQxHe6fxdDkbKFPy6BdRG7xYGsiN5YuK/lwEkBEW4Gkwa7adEpU846egusibnbwcGNQU6ncKat7LjVjEjvnkaHqPHMqV7/QyS42LfGAU0xiaB7G6PutNaVPC9ok8DEufUIaSoPtkEG2Xjd0EFJI2LRi0B6rT4vvoKYaOTahIzwaYfVJdxVVYnSOmEB5RQqbw1HWI5azpL2R2i8qZY6X878noPJm2poS2MBKp8pGyU2sD1v+IvMybQCpvD1fP6cGwRTFqbF3rK49qFvaM5NiENwaC4Ghhd60/nPxEV4PBKGeavTKHcY60cD8sOUhjvTKGnJ/BeGEZhVeDBwX5mG4UcqhnpBKStUWHm+hRlCESLtjH/hYdEHU2my22nrDTBMpK2GHFPwY3IAz8Loymlgq54LeRt2O9LABXjmzZT5+GAfOSbC5HjKxtRHWM4pwdKiRLqxebdYzg9b4HaDVj5ptAPaSGQ/sLgZfEuS3bMcy/CyUgtx5fq0EU85lIjuNjd69TaTjRiBBmFe6Aa4Gp7u64FB5G0zkHd6V5MGUPRw1CXTdCfqM7BXEeU/XJN/kOE3p1xVqWyk978eH/VUnkWvYok1edPHjWQUbRbwnVeIXp4V0VEn9AeWN5B5fIu6GrJHC
 wKuIZI2C
 HvRdcLRi7xsH7IJqUYof4pEOPw6YiY5NQPUvKk39xYngVdxbHyI1r2Bt2he6HLow8OxOC9c7pk2q2C2acEdgb17jqUq39+g87C5lFK+VnXyePs0QhOGGPRGdI4heZC+7PuJjChpk9yx8o+Z2W2VH9wSTIbqvU/qTy8mH7+JCNtWsMSAVOte0iHe3tECLsyxKwReEo5H0/pi5/EetdzWFOdB5mh3PMEbQXrdocKrYq0x51II4oR1w0CfjWQLDAz7tBInpP4+gxgKo/OzZljPdN0b2EO4w+FxFv+sGqZANj4qRImqEEnG20MviWIn/2NWJlIQ/P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_init() allocates the SCCBs used for reading SCLP events and for
the SCLP init mask request.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 98e334724a627..bfbac6dfa053d 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -20,6 +20,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include <asm/irq.h>
 #include <asm/debug.h>
@@ -1268,8 +1269,8 @@ int sclp_init(void)
 	if (sclp_init_state != sclp_init_state_uninitialized)
 		goto fail_unlock;
 	sclp_init_state = sclp_init_state_initializing;
-	sclp_read_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
-	sclp_init_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
+	sclp_read_sccb = kmalloc(PAGE_SIZE, GFP_ATOMIC | GFP_DMA);
+	sclp_init_sccb = kmalloc(PAGE_SIZE, GFP_ATOMIC | GFP_DMA);
 	BUG_ON(!sclp_read_sccb || !sclp_init_sccb);
 	/* Set up variables */
 	list_add(&sclp_state_change_event.list, &sclp_reg_list);
@@ -1302,8 +1303,8 @@ int sclp_init(void)
 fail_init_state_uninitialized:
 	list_del(&sclp_state_change_event.list);
 	sclp_init_state = sclp_init_state_uninitialized;
-	free_page((unsigned long) sclp_read_sccb);
-	free_page((unsigned long) sclp_init_sccb);
+	kfree(sclp_read_sccb);
+	kfree(sclp_init_sccb);
 fail_unlock:
 	spin_unlock_irqrestore(&sclp_lock, flags);
 	return rc;

-- 
2.53.0


