Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F77860A2626
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pX/q/ggI
Received: by kanga.kvack.org (Postfix)
	id 32A816B05DA; Thu, 19 Nov 2026 10:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB036B0653; Thu, 19 Nov 2026 10:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A786B0651; Thu, 19 Nov 2026 10:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D593C6B068B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C6EA80B67
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:10 +0000 (UTC)
X-FDA: 85452259620.06.5A51B35
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 778B140015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="pX/q/ggI";
	spf=none (imf07.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102328;
	b=bw4C73fIkzDnGvBhNqFi3qIR9pOCBwrp4V0TUfQGQKDigxgMMWEomgNXisz4B/vxPGwqMs
	U9I5Af9X8NZ9YKhLVZ6fqvQ28K1dIIHYcUSdxzQuMDXw74bX7KXWnkihykzc2OeLaXblh8
	Agguq+kOyFhnHbWMgKjDZ8fS9jdqSXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xWH9QkVlNL/69pXekrjPtbhvYWgn6Pj/OKz9wdAdLA=;
	b=nRID5MUSp7ed1ttbFElsba19ej8Ga3tnvR4unQdgUtyXmVa2iqojXylJ+c3j4av9pRaWR2
	9bozMbR7W72NA86S/g+R42/SCUCTbOY4kyTlUYkaQs9e3qFQ0iYRFH6PdeTixmX8hRuHy1
	ghFwORhr2kWnp2q97IFuQDWc63yUtR4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="pX/q/ggI";
	spf=none (imf07.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb68c197c7so34167855e9.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102327; x=1795707127; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5xWH9QkVlNL/69pXekrjPtbhvYWgn6Pj/OKz9wdAdLA=;
        b=pX/q/ggI/saEA1pM3PKqq4mScq8cJxOZAM9J+MBtAoTXy/j3eogREcd6eK2HnZMlCD
         oWPtFEA3h5fWQmswkD1AY11yz1XW0AuYr50Ac8yHW69ok9XXlke3yh9VSuZEUULMsxZP
         COhSWtl5CM6UonEyUuwriW/oChbqxjVD0ECV4CyhhzySGGLVkARh7kPVRXYYJ5jdoJYf
         kHE7+K9wrQpt5qsbK2qDe+OIEZ7zY3UgHliLW0/hCA6nYwOhGvlMRVM1vUlXcpMOxhg7
         cGVcNpr9/7Abo1/hi+LxWSTfeRiDE5lHx9aSrNP8PEKkANvOz/oBhW7+cgC1DKNAapT/
         k0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102327; x=1795707127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5xWH9QkVlNL/69pXekrjPtbhvYWgn6Pj/OKz9wdAdLA=;
        b=jnRWf9hUdiaycQK2Hj3RYYLuaBLhAQlL5dRPAkaEbPq6QpqetXwZv3RIeKb+QFPXyu
         HUxQUDpWdF8g+Mip/fsKMSe63tIwXfu+TFX8SpEm1XMERjvIR6wKNIJwcG2H1d3KYGQz
         U34GLH3gG8G931xQ/EyQLO9RNAthwS8m2Om2fVKqfW1vb4CJQJrWDyXUDLHYYFZ2OIqZ
         Cwd4gKAilKuEA9czwY34hugjpnTr+22y47NOrn9zhOReQ+Av2oUe7vpAmQIoWQE8tHlx
         j12GaU0LyO/T8ZOaNU4G800weRCJ9Md93ZE3Ag3gczECP1hBYJzf2YQcKSOV7p6/TIWs
         W/7g==
X-Forwarded-Encrypted: i=1; AL+hErEz7dX9kKBrsPk2P7S3h7aaeVX3vCKX47/Ss4TQtNmBZoTevtirZRkh1uI8c7yH4PoegAKNZtHhOQ==@kvack.org
X-Gm-Message-State: APuU4Z9y5oRm9vV8np3s2fGVXR0w9FXk+Oa+ROkNStz/vX0VwaOC2gqG
	SAb7544neYrkQkk0kJ8VvuKKyYxJOE/+zd15WL1jBpgLOa8kECtIZ0v46zilqkWLgw8=
X-Gm-Gg: AYBFou145qcORiWqAPMPkcx01MzTbN5L1xJDYUjPSnUNRmvD8R2WH60Q0gTF23Eb1R7
	Ft9NL7+n2E+CbU0d4Oaz+owlGAe7oOAER+bZMyGIsj7zgSRhqN93aIRW5Pn5dGBvAgZIXCUWYmd
	8VXnC3e0dFtVAeWWPPR5L4bZ8F8bvyl6R+hrycdN2EaLK5utqsoiDe7m04lKR1W/e7XiUnUZBmT
	inQ65ZzyZJ/FKGd6IvTvmJ7lnZ7K1bXe8GlrQNevCNMXeUM9+hMIKN98BY9BkuMexzUYAXsUBpR
	TLYbHe5NEyme0JlrZRAJlF9hno9jE+koUhpE/fNbDv3d0ph2GHvtq/2Ecs/LF8Z3ooeacK4mPCY
	Pw0EVVldvECZ+rSxj/49ez6WOYjosdjv+ATXW9iUnvdZwOKn0PMKLAgQccUK7GXKtOb1iL4eHjk
	++/BmO+jyJfEXyT/SqT/5wC/+BW8Q/S1EFM0ocD/5XhFEfXX0benATNkFnFnZzYiaWcHDD0sMqN
	JGE8qFHgejA4YqLegZdJiLTk/wlV4u8B1Zd2sx49kxTlDL0CcyW0fApcDA3IZyDovQ1pfks4vnO
	J7/t3NWXdKWGTM0yYgp3RPkVgxI2cME=
X-Received: by 2002:a05:600c:5395:b0:4a0:1fb9:2f51 with SMTP id 5b1f17b1804b1-4bb7da14af8mr129074685e9.14.1795102327018;
        Thu, 19 Nov 2026 07:32:07 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:06 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 04/10] mm/slub: use stack_depot_fetch_into() for owner tracking
Date: Thu, 19 Nov 2026 15:31:37 +0000
Message-ID: <20261119153143.4099483-5-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 778B140015
X-Rspam-User:
X-Stat-Signature: 6eckyqps697k7dncug4h367e1kpqxuy8
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102328-297076
X-HE-Meta: U2FsdGVkX18tr+EGYsu/A+YQ4pFJzVjwIci7zJCYjAwHrBT2y3ceur2VGKqilb2AUqR6xjK131No5wRmWwndafsUkURr3QkzFqKX2etOc4/V5J4CtGP9KZHm7p+UX3KqH4lk7EMV4dSfI3ygh8rta/vHZU0cEJ++JMiBQp3CxnHL1tf+P/om/49Q2TDRZuuVU/ziwcHit5EQD9L204/dXMhdxKIhMuSjMDyZ46c2dvkC7wZCbVU5dXukfVhx3L4L8f7lE9XVbBzczmYG7jeByerDU7jPgQfwOInTlqaA7S3VhvoirQybXWFweu3DEvVawjBkdkZ0KFyYWE61JZr8KpECmObH0SmOojvojd898ZIvPYaaumhds/pG2NX2x5rfqabvBpsyrJjBPflFDlpMemaCyBi3uSH+WQxYLjs0ZyTvpwur7I58Z9xJVZpwd2mb2q8h5iG/lFiKPFBbpHxzPKINHE3ctgzdt1/1P/BNJwNLFn6gp23bbcBtxx1JpZ7Cg7HIUuNMkrO3UkSYDyKml5GMK/CmYeK30gC3M7YvLyMtCf0I6/xNscF24gtiE4sAwklhAVb++nX9kLU+JLwsF6Nbl61ktoR5nKDnBaRurCVbIz/o1AnAB/sv9IqgMSOhObIxWYzdYdeXcOxbgY4A1LRkkAPivJ/ILmT36Jn03VjVdmT3kqlLTfNGwbY5EGj6gCSlu1OHwKUpZpwlO2uYWunKK1KUJFJB3JYwgPKTGnTWayOHCSwDW/Bhvli47Rq4j8dVcHEIfxnSz2r5i6rlYA7Lhfj+KBXerPzvC+/oxhpqB/9+tlq/jxii97B5XlYkXGp6NrcIHx1FvPOP/1SWp4bgwT13ObhrGCKb3fLbwhzEqigFxnDkiR5AdIplzTXMy7MDsMH5FXcCdllXDgSqYg0HrPiFvuhxmE+UYxL7rpL0Skt91L9Sysd0PdBKRyZdD4QP6LKQgfKpneIOd7+
 uv4CX8Gr
 1NxMaEAarJ70E2KJO1LmsyrJ6LMyPVZdd1+l1OAJIySgTCBlINMU2WlA1uRZVsiDMaH1bks1V5Kt59hwHyn/WeR9D3OOEfNPJumz85ShNtFIaTQJoIFcVr2PN4qWX4PfLq4XGPrq33SBHnf7FoW0nHRRuEQ8y/NO+A66Iw4mdgT4kWp7WSbe78sSoVonFnAWp22gRTBQovvXBHcwmgUca181kvREE496KIusliTfHpI6OnLuhgGoHcTf4b72HVv5E7tx+MdXX7F5iV517AINgi/DfUFJxnMuQB90kOttLrBaSEsQr4fz9GwkLIvabyWT/99B7q2lSXhY4XzX9HzIS3awEbB2fkzetUoQOSHucocDsABHFfGDgPhx4lb3dxcLAo6ccgTzG1oZSPS3wXtBcq6ukbwf9JZwd0LVUeWmXTAg0QL4BRmcd/w2oA4SXB8Nz0/FyUEGTv0t6dOiTL2Yu0lVIKideZWbHoUUFOizp0LXH5IkSCcTjviafLxiBOCoysuy+IVpXCuNHQvMN4DRnVxbCSaEciYR7CtOzaPGANrksX0BMmsM/JGAAjqLmJfgAsFNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

SLUB owner tracking stores allocation and free stacks as persistent stack
depot handles. Compressed frames must be decompressed before use, so
__kmem_obj_info() and the alloc_traces and free_traces debugfs files
cannot use stack_depot_fetch().

Use stack_depot_fetch_into() with TRACK_ADDRS_COUNT-sized local arrays.
This matches the save-side limit. Keep the existing KS_ADDRS_COUNT copy
limit and debugfs formatting unchanged. Continue
to copy or print no frames when the fetch returns zero.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/slub.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5c33d1247060..2c4ab16c0fbb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8335,12 +8335,12 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 #ifdef CONFIG_STACKDEPOT
 	{
 		depot_stack_handle_t handle;
-		unsigned long *entries;
+		unsigned long entries[TRACK_ADDRS_COUNT];
 		unsigned int nr_entries;
 
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_stack[i] = (void *)entries[i];
 		}
@@ -8348,7 +8348,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 		trackp = get_track(s, objp, TRACK_FREE);
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_free_stack[i] = (void *)entries[i];
 		}
@@ -10038,12 +10038,14 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_STACKDEPOT
 		{
 			depot_stack_handle_t handle;
-			unsigned long *entries;
+			unsigned long entries[TRACK_ADDRS_COUNT];
 			unsigned int nr_entries, j;
 
 			handle = READ_ONCE(l->handle);
 			if (handle) {
-				nr_entries = stack_depot_fetch(handle, &entries);
+				nr_entries =
+					stack_depot_fetch_into(handle, entries,
+							       ARRAY_SIZE(entries));
 				seq_puts(seq, "\n");
 				for (j = 0; j < nr_entries; j++)
 					seq_printf(seq, "        %pS\n", (void *)entries[j]);
-- 
2.43.0


