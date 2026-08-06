Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17754C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BE46B007B; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5156B0093; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FA36B008A; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 418E96B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4589A21A9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:19 +0000 (UTC)
X-FDA: 85072241478.21.C04B252
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15B041C0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhNgyyDz;
	spf=pass (imf18.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786054278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALqdWlhOmobFYoiIgybtTERTMEIMR50Vcx9ZTHxD4mw=;
	b=EIU3CsGQqNytQHqZ8zwM8/IeeeNHOkqyLyyPSmIpGKOSKdHb6koK2Iu2FR/QJ/E5svFsHr
	8RZUD4vMAvBjWD5/ENHxnLXaQk4E2Qce+mMt6QDYQFLOiE7ouRhss3MPbS7lQ26vGve6gh
	FX7AYoGjox0kE9dUodn448jEau2ol2s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhNgyyDz;
	spf=pass (imf18.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786054278;
	b=PfeKwuSddnpxaxJkBcCsuDYJbjNh1e50F7Xfhs9fAeZBVYF9D8UXYMUQ0H06c0b9mUL9au
	bOepgwuaCRxleKNzMP/7LaYiqWNTPWd6W/NpywLRQtqdw3UixEHRpTUPvqRDmWVAkDIGEr
	zX+/HqbGnQVpe5x08xdLVdqBs0fQTqE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50D30600B0;
	Thu,  6 Aug 2026 22:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42BD1F00A3A;
	Thu,  6 Aug 2026 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786054277;
	bh=ALqdWlhOmobFYoiIgybtTERTMEIMR50Vcx9ZTHxD4mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhNgyyDzAnz16w2KjkGXFqJ4NevnTu0Hme24rsaD8WC6ilSlc7KfMrTNPwi1PAfRf
	 +5J+DbDttRI1C/Wy10u4XJFBRaVjum5vHND1qr4OhfWsIJ5Dy7vRADyTYiPaFxXyJe
	 hXo+slcmLXW4iLh/Jx7ahVIvtZ0OnbFcYjyITzt1d6Jc0/w5FIv7nCzUDtvbkgN7MD
	 2IujzTQpT1++BOithsvZdn3HMd3/4eKN2xdpQeT70iMTwqfgCGt1BXK6rRtpB1vNvX
	 +2g1tBY0QOaWU3K7uJd1d2wj60dcwPmVkyqu3WXyua5YYgZAxMW3W28OzOrZcQb4f5
	 gP+6TCoz1LNNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] mm: make mempool_alloc_from_pool() return bool
Date: Thu,  6 Aug 2026 15:10:29 -0700
Message-ID: <20260806221031.79050-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806221031.79050-1-ebiggers@kernel.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5n7w8cjmfi5imwfuun4qcmu6ogf4p34o
X-Rspamd-Queue-Id: 15B041C0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786054277-167052
X-HE-Meta: U2FsdGVkX185GEjtTrZJYPu9+Nh+fNPBWqWRBx8shGqY/9RhtM8UCMaE+Kf3tCkwmqj9E9sKpIONZDu1Ecm+n3XhZiGPhDN2PkhACI8sPS7t+zYsJKV/wUBgDLZ+rA1GwtNNMeUYChA4j2Tb3Kla5SjB+mZer8lFdh7ctlkMguTFSddD+dyC8MFqMSQuVKSGAZKV0Jym5XPI0QGwmcKh5kYbkpxyLQwxp9f8Fm+4u/cV9nBQ0XgQ8XrEhpL+GWFEkf8Ce2Vsx2oTAojFq+URR7u3v4g12yspr9WfUFDIkP8QHWbVFjtU4zWlUOUk2LM4y8mb4SOU6ANbJ0tstbfhnWqin5plF4Tz2bkt6de4EjlhQJKJhf9JuXrx2kd2Y5rNVr6NQ2npE6fdjiA8y7tQ9W6/Skd7AJBGFz1hqkfIrtIRxCWz2EQcZmBq8k2j3bjSFuu8o2MsKRnLFamSGqi0FSWZf3Uaeuk/28UnzCmU0MuX/fThc5NegL37FsbynWhcc49yHlPiGsqicOq+RfXm87UlIIDOM71ceNYCdSTZBu7zSSuehTY6O3e3iULjzwXmUIQY217MazovGQW68UDlVx8aC3U7xt5HevXssT42gozxClNdW848jeTp0vY/Eh7pHQ6oxphsQRed1rF1B8hETUhPNerNyd+K7icJqH/4wlGTVYJgx8PHOGTuOylPfBbEP7GRjdlyKs9Gsty0Q7OThs6Jvs7+g6q9pFzcD029TaRRJmXoySp105UiyGd7FyqR5sExGLfWGSPIRbw/bt0f1HdiCelKrD02qFN7k/Uo8HWC0rRTkZbxByicxgEZy1UGPaH577eFpGU3Zi82h0RQa+l3EsWQ4cOFh/lusF1zp27vEXSHuwyg2+cGjjND4yB1VmVijTd7hN+28WBumDiBIZmQ3SnYwctI/7lXHHvPsXAZ9oQpjWnvP/nMIncBhS2kytHVPlBpjKrkrkQtJj4
 pvNsRfSi
 5J7Q/cXTnKihTGS1IKaXINgIqDdMlqnmGfLODOa50tYsSg8hP/9Lk8fukU7DUO9frOo5lhU5sMpN48BVZumzbDHlVUiDGeXgnIaKbnJy3mRj6mr629PAgzVopdTff9RTRvSOHJ4NeQcehNMv4MLHL4Zqc0wob6Ig2I0HB2arnv2zy3VLZvzhAkWeq/2YtfIbVWcsbi2G+erCu5MDYj2eY9jt5v5AhPHbMYtgsalMk6rdvIXHrPXsw0MBquufCLqcL2qzSMibhIQZPwuKR8gzN3AAAxcFHn3EooWVsgacm3Nb/QsEyqRRsk1Lg36PBflsR3jyO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mempool_alloc_from_pool() is intentionally all-or-nothing, so make it
return a bool rather than the number of elements allocated.

Then make mempool_alloc_bulk() return right away if
mempool_alloc_from_pool() succeeds, rather than jumping back to the
retry_alloc label to allocate nothing and then returning.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 mm/mempool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 473a029fa31f..d454bc9f39e9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -409,7 +409,7 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
-static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
+static bool mempool_alloc_from_pool(struct mempool *pool, void **elems,
 		unsigned int count, unsigned int allocated,
 		gfp_t gfp_mask)
 {
@@ -432,7 +432,7 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 	 */
 	for (i = 0; i < count; i++)
 		kmemleak_update_trace(elems[i]);
-	return allocated;
+	return true;
 
 fail:
 	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
@@ -454,7 +454,7 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 
-	return allocated;
+	return false;
 }
 
 /*
@@ -519,8 +519,8 @@ int mempool_alloc_bulk_noprof(struct mempool *pool, void **elems,
 	return 0;
 
 use_pool:
-	allocated = mempool_alloc_from_pool(pool, elems, count, allocated,
-			gfp_temp);
+	if (mempool_alloc_from_pool(pool, elems, count, allocated, gfp_temp))
+		return 0;
 	gfp_temp = gfp_mask;
 	goto repeat_alloc;
 }
-- 
2.55.0


