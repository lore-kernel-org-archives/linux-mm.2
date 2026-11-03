Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A1A60A262A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=RTkml5qE
Received: by kanga.kvack.org (Postfix)
	id 4E0E96B05B8; Tue,  3 Nov 2026 06:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A416B05B9; Tue,  3 Nov 2026 06:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331E16B05BA; Tue,  3 Nov 2026 06:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23166B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D8C2A7EC9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:25 +0000 (UTC)
X-FDA: 85393607250.07.D8D02B4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id E5CBC20005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RTkml5qE;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf31.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bwrQXRz1nV2S/H83UR+VWVa5zJUqJhABatAjcFjujw=;
	b=TwjmbFMZKQpGsfWejwUPOTFiu6dEqi1RmaZ+ctB3qg+dZs73c6Z6pyrhK1B4AAfyeYuQ3y
	5u/cFAFalNboPLOYGEqYwJipljBConVlVD1pq0bIhARtvyZaCEz7JAOzF+PGVRxEu0UvDt
	G0NdahyId7Ghxojg237AkSQbtuVMFTE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RTkml5qE;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf31.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705843;
	b=NgLb7vKWmeTFhhFHK3SkbcaKnl81fszsf2/5adCniXmk69rppbCxogwFeSsJA1ASvu2RGD
	d0KDcRtM8ZpvaJJ6ZBeBOLBm3u9kZVunDhQiwKY8amqpoju8VFl+EVqtzSyZGunkEAEtal
	SJlJcEDT7C+31uR9irlb+7MwHCVkip8=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so30573915e9.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705842; x=1794310642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0bwrQXRz1nV2S/H83UR+VWVa5zJUqJhABatAjcFjujw=;
        b=RTkml5qEcq15eKww71t0BYCyCzfto6zODWE+b49UzhL0xrCtMtc4CZ98jP9rUntl/Y
         dmZVb3PYjsl2GRKPIdbhMG2DmZXXDED7RaSKuxUfsf7/hSkqxtByD9dP7DDSlUtc7yYq
         4wbauvze7FviyqQbVzF0ipzRE8OwOVMGlM35VApBQrVmygxgUxsnz9ScAQC/zA+5ifT1
         Mtyfq3vyLtUvsGCvJ1rGnqwEwX6qGWk1Y3swp6PFI9c/IvmzEeKy19LHJW23D0YYUIiO
         cElOAMY9u+bJUgJw3P4eVlbqd0ZhYwTvbHHgR+ULnZjJuOAYgfF575PaJ0KKg611jLia
         kkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705842; x=1794310642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0bwrQXRz1nV2S/H83UR+VWVa5zJUqJhABatAjcFjujw=;
        b=18ZlNnUn19NeXATCqhQ4RFVLVRiLKadRd5V/4UTWOscekkGEJEnKswnCVxAf5sQqId
         b4GUrlLqqOA9usxpm45mRLtzUrpZGjj3wHO3nThRLvQwPhnkOYBaDIJQSi160uuclmuN
         FW7lDsc8aJNwXLAn30U9lvrbfUgb6KYv5dK9QeUe/InijYpqnLBh2xvo6TyDQFccn4pC
         DrWUhMQVUnUW3o2ff+brpcA4yw/ikSZ7Ks6+zPdOxxmZsNipsIt/yN/yaoAqY/qiLcEt
         euqqg2vpzFz4vR0602P3Ijx8tE3QJDpqUuEfWwrsGvK7X4WHf0u/+nw2KvdjqGILpzZW
         lKNA==
X-Forwarded-Encrypted: i=1; AKwUvByTkGK+OkG5WldXQYmIXVLu5SM9DYuBOPKcj3Br+objjGN2F14e/9+exKbw1SXbCdScPjC0qas36Q==@kvack.org
X-Gm-Message-State: APuU4Z9P3Vn3NDm5fG92v4HJfPQONQn47XImxgY6vpEeWc4z4Wkcdnqj
	QrZzGjjMK7BFeebzj6/DPnmNt0j2pATlgDpipKUu/8XNObQRu57VC/hNbnDNX4ZB0H0=
X-Gm-Gg: AYBFou1FCR2n8abOVFEkRoRPgVJCs/LG288xKhhHyPwOYOC4XbTPqaoVxCsGVvtaopK
	xPaJIdxLVnzhiTyGidYPU8fy8A9Ks9Q5HsnErSr+K+PMy/ZI1qTU9Ef7a6P9rGKnh1sxF4GPzFq
	k6NrfUwuYY7SrwWOsUaxYH2gO3vFD3eVSohwLRGg9gP6BrRqFNADzhckLuJpUmbUDCQ63sWODW+
	5KnixHv6kpk0GjAUleT1UmWs+np63IbKwjsZIpfrkAGcPGZVFOjBAO9GsBgWWVZ7gl9McmMApjQ
	DppIXQUwvfrXcAyIhBua/kD4W3n7DkChw3bBcogATt8OqfSCXxKtimVOj8Ai9CHjD3k07E26WWQ
	YfdFQQIihR1O/vVP4MpUVzTa+cWEKfIK6pc9zNVXIqJxWVF+qm09e+yh6MhY1vvJ8fsbqSdxu8x
	8W3UWFlS0GLSIt/k3d2tMsT/FwnyeBlhB5V1lOqqirMRWynJg0a/vafjD7PvxsXEaRyZTq2re+r
	g+JNh96HNGUldGi/9oCXzi9O2Og3RrbdGYKFLkpLZZB3qv1UqAf751UFqsU9r1Z3dC3RbX27Dz5
	WnoHkYYdIq7/MiWa5b7OnR1PnFgOINpcji9yu+GjkUej2PX6FEqVU9KvfSkHNlzhL5X/79oCzE7
	iKWnc+HEINv9IsoVP53AyI2vRC8A9WA==
X-Received: by 2002:a05:600c:a00d:b0:4a1:83f0:7c91 with SMTP id 5b1f17b1804b1-4ac185bc336mr278107635e9.18.1793705842252;
        Tue, 03 Nov 2026 03:37:22 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:21 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
Date: Tue,  3 Nov 2026 12:37:06 +0100
Message-ID: <20261103113711.1832834-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103113711.1832834-1-max.kellermann@ionos.com>
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5CBC20005
X-Stat-Signature: krraqn8d4fb1hkqrmduq4mxth78ohiz5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793705844-108381
X-HE-Meta: U2FsdGVkX1895b78EFLm/HvciooZgG/L3mypGYBFP8MjN4GVZYDV+hEXwKvrjv/ycD8rwRwfCMHXPTxZSFBc/kAxJX9m2z9LzAzZsfzuaCdtzeDuP9QYC34optiOhsAU2dHpXACB278R75GKGhsMUPfyffbFvcu8j5UZUdFLwejSEQnArUoNqwOdjLtODX8ZjtHWnrivN+Nnh/rcaCBbXrtk8aPYKvJ3//CkJpFDViNSY9Hn2pD/eiaw8Y835MToHXFi4HS/PY4r8yIYqnRnDu9piJ7fUB44WdAwIDjCXjdFB1C9dZej72WrLlcXLQ6u9nvG6gxR+wRdc5Z0hq+d+WV7PeOiyQ9aqdQ2wDOW6D6tU7cPn0J3k2avGvHgIh+5datv5M/A+v2wrHQ1kpKiBrOs1DtIS+2pjLIHbdPO9i29BkPL5YJM/XT75r/aFZp5/Ux+URKZRB4Wv84ciDiVbfdgiIJC1Bt2IE9qSmUYuMhODtxN1mT1m+kCz3yF/eXrvKrqfIWgyaAKVl+b6ishiotMU+WBv6gxVSONwr/eLcH/1bvIKIO6vzqm+N7nCIuN/vEVB24Zlkva1dSPyAF5VOeRvqABqOt1Y+ckCmjvcWaFueLQFwoADjg7NHPpDwOMvT14a+1nNm7WlLvCSAM3ETwnkb2LIBb2q61UyANqnQQtiJKwiGZrhEWhe8/TUK3YN4KhHUfyJ2ewXMIPJoUX4DWOhPximO8oS2d9d6rmzuxkz6YpUf7xoaIFo4yXfxJXJ4v4julMrfwkkAlbHgGW0s5O6GsxnqH+5qRiWn4hPH8PQpvCRTOh0HXxLNoTsLD11tx9zSznzv6wgMK8XtWJAdEPDWswY8lEPROw/mo8Mv84BGkVqEQzm6y79JJNpK78DLije5N8mOx1HqKCHqFZtIncTDhd6dHnO1VPQGWfF1EkGXtRRt3B7qXYdJWW6u7JG5qd0Uk76VxPJO4kLaI
 FT0mH4+Z
 e17k/AFf7t39YanHxo/QJq+kJBh5SaalVGmX40NVQWVsUfO9RD4NxfVTLaeDZWuxy8Wdkaf+dpWZfHAn54P4GRl6c9KQLdPwe2r1z0AMcfWh0TNJB/e1WaA3j3mRi+b+PeDsOqFjwHEcoe8xRLojKRiT3qpPvyhkrq9v+EPIB7/Mp0DvjMaoTrVYgnOl3JhMQHYDE4i6E0qFSRk9gND4vXla6fOJAjgnxQHvIHW63yGdNvexc7X3D4I6Qj0K3sD1G2773l/sUJtnIcz8+rmTUCaeVc3dc8mCqjqI8q1WkTFa74FCv25sczh51XFQ8WAB3fCdpaCXLHjcan6czRsgqhsSqqFEdRI8/QqwYRgMbxjRjYvMRL4BiPgjZBnIHmdH5VQJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move some code from hlist_nulls_add_tail_rcu() to the new function
hlist_nulls_add_behind_rcu() for callers that already know the last
node of an `hlist_nulls` list, to allow constant-time appends.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/rculist_nulls.h | 36 +++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index a97c3bcb1656..054e477dd093 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		WRITE_ONCE(first->pprev, &n->next);
 }
 
+/**
+ * hlist_nulls_add_behind_rcu - append after the last list entry
+ * @n: the new element to add to the hash list.
+ * @last: the last element in the list.
+ *
+ * Adds the specified element after @last while permitting racing RCU
+ * traversals.  @last must be the last list entry, with its next
+ * pointer holding the terminating nulls marker.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_behind_rcu(struct hlist_nulls_node *n,
+					      struct hlist_nulls_node *last)
+{
+	WRITE_ONCE(n->next, last->next);
+	WRITE_ONCE(n->pprev, &last->next);
+	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
+}
+
 /**
  * hlist_nulls_add_tail_rcu
  * @n: the element to add to the hash list.
@@ -143,13 +170,10 @@ static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
 	for (i = h->first; !is_a_nulls(i); i = i->next)
 		last = i;
 
-	if (last) {
-		WRITE_ONCE(n->next, last->next);
-		WRITE_ONCE(n->pprev, &last->next);
-		rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
-	} else {
+	if (last)
+		hlist_nulls_add_behind_rcu(n, last);
+	else
 		hlist_nulls_add_head_rcu(n, h);
-	}
 }
 
 /* after that hlist_nulls_del will work */
-- 
2.53.0


