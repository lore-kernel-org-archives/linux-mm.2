Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6FACD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37C96B00A5; Fri, 22 May 2026 10:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE97F6B00A6; Fri, 22 May 2026 10:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9899B6B00A7; Fri, 22 May 2026 10:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84E006B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:23:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B31B1C17CC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:46 +0000 (UTC)
X-FDA: 84795274452.16.AC57E14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8904F4000F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbkvlrx+;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNUnwd0Z1xsF+oZJGcRcFicg2hDM3WcwB/9gZhQZ+wk=;
	b=NvEbbVR2QyltLPCBsvKGpnsfFJSUqhnkCi6mePmga1x44I0T3AUVERc+MvHAQPAg2iM4Zl
	77jwobc/JOm/sI56SYkz1jn15Hkwi38WT3U7QwG2IacdZhyc9liT8sPZirIEYga6/t8Pqj
	DhhUEtNI7/ctX7wFjKP0guYvWAz8JPY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbkvlrx+;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459824; a=rsa-sha256;
	cv=none;
	b=dnqGgsqGaYxoihCrRRfM1NYAaYn0EchUsjt918B/3XN3ZC9B9hYXj92bx6S5qkIpfLbE50
	L7zAB6CWRCdR8zQiYJ1fAgtp6TBwtLQzLZgkbpMYT4CoZyTKc7dUrWtZohOpDy9K7KFmZC
	dgyJj1zIEzPOdbeRWaExupJmHq5GW2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC97F44560;
	Fri, 22 May 2026 14:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8712E1F00A3E;
	Fri, 22 May 2026 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779459823;
	bh=vNUnwd0Z1xsF+oZJGcRcFicg2hDM3WcwB/9gZhQZ+wk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hbkvlrx+xq2crqJZLJ8xlwsNZcEtQ7vIF/I3PYTemtAs3R1Gquyl5NdzyrbocQTo6
	 eRX4jdQdt+fcIVAm8Ibaqi/wHJ43w1bYBgmKv88TV4yuUx9qGLwrZyFLEV8xtcVmab
	 XPcxZRpfYTaASTlNmAPEmxzNLy7aE2ZPbyldH/zgp3OQZM1pYJfle5FokVDdtHAQmY
	 5XD7UBP3RQ3EDaKEPmSZLlIMtrgHCmJuZE/8dI2LVzDE0SZnCBY+icVKORIIjitSP9
	 raJ2RchT6+8RL0HizNZlLwm7g9WAGnr43dDRIqg01EmgqIpdbKpJVu6FM8ioJv4VdB
	 2Oo4ZYAAYqZ9Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 22 May 2026 16:23:21 +0200
Subject: [PATCH v3 2/2] mm, slab: simplify returning slab in
 __refill_objects_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1282; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=5xU7bvNWPz0EcVzac20UtCjNot5RIW9j5Mp9rjIj3Ow=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQJpD19dNRAbVL2OX3jTvaMuGjjO1XlVuaXut63X89ne
 5IiIn2rk9GfhYGRg8FSTJGlevcJR9GZyh7TPHw/wgxiZQKZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkCGjhEDF6cATHWIKPtvVp09K3OqG7SO6R+pzfKMbD+2/0YmF3t9/PbIdbcVbn9Xzpz+VXXlj+e
 Lj3P80d18PEQ8VVH45Am5d9e6VDtXzRT4Z3jlzQ4hl+LuqWm8rStM01MakjgPH1yy8mDnHGumuF
 n9FZt3LNXgf9h3Se1RNNddsf/NxzVj7Z5z10Zx3gqt3eK5qrkxUuOJepf70X+6hS2Xrx9+9zjm2
 /uQvKN7X6r1z3yw3ld3j5Fi/frzaz0euMx1sNn9wUuBnVHN1lYp4ZKOR+liMz97A9d/Yiv7ay5K
 mNwTilrHOyubUWOWRUHGHqeAR1zTa3Ucn22o+5Kmfc5V5fwXR++MVTtuntuhtLL6osfsSRXbdDW
 /vN8PAA==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8904F4000F
X-Stat-Signature: ndpqfjrsk87atjdhzmzsfc3okf8pke6h
X-HE-Tag: 1779459824-756368
X-HE-Meta: U2FsdGVkX18O+5t4KFx9y9WPM91/D0WTZSXBy7voiH0oDJ0wiDo3F0GNDVB2efM5qWhuHFfgtDxoAQPMg1AqNoUenA8+iNkRR0dYhKspDX/jv/Wzsq0GXDGg6WrrqaM5EYUAmIVqNloEsTCEFEk9fUf5Y2D/Lf8hqHDEcabsRTOzviUme7w9VBKegwo9ZCHqcaDfYG+yAy0WgNNPy+FkOul35kM54N6Ow2fBOzsr3ejbvWAadrIVcqanYk7rZFujY/GNQKGfEau0urOcwLAOKgGic00vdk59HPF8zkRSZcyqaShGaTAirHgj/7qrQR9VurC/ezmLntiNU+VkxVxc5hnP6Dynj9BcaGkG46wkQZslww/aniawhtLhZ0P4YaF1ANN82n2eEAxtuv9Qepy4m+CWYR/oZJJ6jWTxwepS0LT20po/gBUDHJAbKmsDu0GRSQ51Hr7TQh6sDiH7Wbu/V3zEgyzr3NQmR3/UHz/oY5YOjURj4Up4lv9zGvKrnO/OKMS7abtr9Ou/nZM8f0Z6LUz/2c5G+kvmF3fvR0He5FDj2GI0pEpSycKPn4d5V94THU6IbhM7J+cm9eBy8cJynNUh1qzUyiy235llmIiHFSznFgMjF8e/wVzBHXDqnq8zo7NFdRDIgYjtyup69phLduVuT+C8MPO4CxFbCaWeFOkt+XnAhH6G06In/UKDs1qWn3boDT864Tz1wt5qlZ46eBwhxRiZ79uJMazg7xLA74V+f4TiBe8Q+3M2tNUepcbz7NuEY/qXdpHKBVn6mrxraXXPhbR5N+87FQjRDEWkzsKzlKrKqIloPFOS1wv9TpEaXZYxoo0oiXuZJJGhGrE1AbO1x5bH6lWBgT46WFz3voZEBD5o7tglV9IXrbOfz400hXeccE+OGjbhGD+N5tGpJb0lVQysyXWhOWK+eYTWPtpVZqzaS5/oI1IMPGGNou4vDCmrm3nzo0Y5zSW6jFR
 s5XdRILQ
 kl19TFBIKKahQUKrspCCSfzw6ML/14fBPMJRDdGsm2Y+2h2zAUt5kR7wJFfxyk9haAA5LvD8rqQG6DUA2peNMmVr3hPtukzSbFv+KXkiNEWlYHKxvcdmqvpMQ8oDI0mR/HM6zKYmu+Imm5RSTi9uviKMdHA5HR6oaaWRW8KGsvlrPN7bZrHcbWG8qFzD8htCeqy7r+W95FOFmLSy676kuNf/5lsHKYNfJS9I8pnJtcYq3snxNbNMZpDdMdg+9CMuGOccRvi8ssdBRSgmFN0yjDNJJavJC1nr585vd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we return slabs to the partial list because we didn't fully refill
from them, we observe the min_partial limit when the returned slab is
empty, and discard it when over the limit. But it's unlikely for the
limit to be reached while we were refilling, and the worst outcome is to
have temporarily more free slabs on the list than necessary. So just
drop that code and simplify the function.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5816fcfc7a90..074d57c0390b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7196,21 +7196,11 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
-			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
-				continue;
-
 			list_del(&slab->slab_list);
 			add_partial(n, slab, ADD_TO_TAIL);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
-
-		/* any slabs left are completely free and for discard */
-		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
-
-			list_del(&slab->slab_list);
-			discard_slab(s, slab);
-		}
 	}
 
 	return refilled;

-- 
2.54.0


