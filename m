Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815D9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GjUlXU4T
Received: by kanga.kvack.org (Postfix)
	id 9B9176B0869; Tue, 24 Nov 2026 16:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9916B6B086B; Tue, 24 Nov 2026 16:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6E76B086C; Tue, 24 Nov 2026 16:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE706B0869
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:34:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E094DA0BC6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:34:29 +0000 (UTC)
X-FDA: 85471316658.27.2A9DCB8
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D0B7180006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:34:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GjUlXU4T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795556068;
	b=yLX8Y2JcX/49zax3Jot+m7DrQnWrzk4KeJg8SIeBDYHVkvQCtloO08RJSjxfUVRyMRJU/p
	eVvvRTYMv2oUfbVfXlEHnHznDezvz77zKbNYvdFKrFxxXociP0qk9I+iEaMsRe6zl7nVpo
	Bl42Wg9zKDTCFtll/7Ih0kd1KHWKKRY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795556068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
	b=KGws1KfhqbDsqpPPJ5lyNHRTduRoYDJbNggPJ9e9i1ikSVl4xH+pawcpvW21fZs7rYXYK4
	1kmBI8D6XqDwc1YsZHtNIZMlbYbhOzKiY9xHfB1PO4qQ5s2XF6HpV+i/3LE1dn3hQW8oT7
	Z61rSZ8o1H6IpzQK/3vBEW18xwRgq9s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GjUlXU4T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of heyheyco@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=heyheyco@gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-386c71feeeaso1214946eec.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795556067; x=1796160867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
        b=GjUlXU4Tte5mV8JIBEUk0nomdgXyHLgbMnfzlMmpYGxrbYPdjdifRet5YXvklhdEUg
         Ca/zRhqgJes+JIgacSZacgEcAqKhCOoQfADHJ6k2FsIN1mc1h/H0f6xfuie5XaqLB9OI
         JH7rODb16V5vVzcaQNoCe+3zXSfo66Eetn2s0VBamZwJXSXtBk79oow/zN7FXt+2AZLR
         8yFjhUkhlupW6IlDFf/PdOtR+63QZ1syMmDMlhECeKXY6IGw3p8ViPSkhYN+eldhp4pE
         fHs2ZV7s+wIXvr+gTyFwV1wt50JzcgVuXEEjiPs+CrwUbN7pdaGNTUNm3w5G3PjJFDU0
         6F4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795556067; x=1796160867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O9lMyeWaR2AVa49Y0bfc4zD6I2/RGDgVBYEZU7qaCoU=;
        b=njjuSZyF/MOotE319O5VQWyukhqnWCZRhBOvSUj2tm62UgvgF/669J83xulpq7Jyvq
         3/aCRAQ31uGIiMTHbI8N/S9wrtkj3aeWK8FhAqW3GjRFh0/rFd8sg/Wsso0a+HCxZ/Jm
         asbgHiYlGslf41ACnfpDxh9JXD83AkYSOdZP9/OYJuBJ0+VeTNORSXApNZHJgn/bp1A1
         R05ngxFmoTDUWjbEQ9X0cLwhJq3qozAhbK972FGVe9I8TR1KP7wpEgNGTAHFHh2cmbJY
         hf/tQ0u60vSJnpFW+evAS+Y01vJfISNq0tiJ4jdfhZCKYCvTvkxarN6T13+Ug4ZPtbSd
         xV+g==
X-Forwarded-Encrypted: i=1; AL+hErEV9Vx9gJj+A/eegsNWzgqeXeB//4QPSCs552HMGfxfbx2AyEnNGnckCi8QPoDDlICIiyvklAF4XQ==@kvack.org
X-Gm-Message-State: APuU4Z/s/RfUmWElZLPB/b1wzPD2L4A1Iy2/BEYwoECMsU4WNgKbTQyI
	5MHC8KspHXDtWzzX0keY6VwOIr0gZNDFN0kRc/tXWWO04O74oECSpXfF
X-Gm-Gg: AZFdTZdOrorAGYpTP4EHBe7wO0BHfnykPofT6FkUkPLXUobfKCd6qFoIq97oy96mXMI
	ytv78G8bOddisDVjyjoC8p3W17Eos3mJj4r8LKaJmufjBsOC7RLFYCQm2EPL7ChtVFkzIxLPXg1
	6EVWFnWoV8leN88kmUpkBkN1cU1Lx2EJyc3XOz+7MhZEibw+K6xrclRs4ahQv8tXv3Wiw+Z6hbJ
	4Z+GW6obZGFiDuXrNL/Z4WJb4KJIJ2oyrC49YIfyLYNatNEg4fqtW1TyDZ/GDrgVbR5SxM0ckWZ
	bXT83d18lkgl++4rkORJ67nXLILPVSPGT1DbKivLdjdN4hNzOya+vXeR4taeA2fXP0lSKSXIXHg
	fp3t+KxVMqZ7I/rzb/sNQeIMRtL8O8y/7HBe1R7wojHvOR9VIYlwGyonVz2VAURT7/E5Fb0ZhbA
	rTqu1Gqg3uqScD9KcQmHAb4FGVwQluqprpINCId5FfLuLJ+SCNczkQc2s5IGe6ekKJ5qYkdrqla
	+dYKESDFLMs+mvTqbvliZ34xvYok1l6zVWTOhKytFRuq2GHXHBu1uPYR0Hdwvdm78ZquJHsfFNa
	POyU8dG0Td+NFtbFhhI9EP3sengfC8f0CmKosEB+QfYKYmNLV1epFb6K/V7f4FCrFV64P7W9r/K
	gOff1uczmqJVX
X-Received: by 2002:a05:7300:e91e:b0:384:2780:8757 with SMTP id 5a478bee46e88-38570a3e793mr18231095eec.22.1795556066685;
        Tue, 24 Nov 2026 13:34:26 -0800 (PST)
Received: from dev-oss-0.tail8d7c7c.ts.net (c-73-70-201-200.hsd1.ca.comcast.net. [73.70.201.200])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e7f59sm49448857eec.6.2026.11.24.13.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 13:34:26 -0800 (PST)
From: Qian Xiao <heyheyco@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Qian Xiao <heyheyco@gmail.com>
Subject: [PATCH] xarray: fix index jumping backwards in xas_find_marked()
Date: Tue, 24 Nov 2026 13:34:24 -0800
Message-ID: <20261124213424.2224554-1-heyheyco@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 2D0B7180006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mby759bmgkikhd6o6r7bbiemexi4zocr
X-HE-Tag: 1795556068-379038
X-HE-Meta: U2FsdGVkX1//PSAj/MXnJsho5Q1GQIyQUsD1RSxGSHDJy8u7zqQLLV8dvmECkO6mYQlxT+u/XtG4bDRW2NC4WRtXHIFgyJGQ9KCTSDpEjn4czPLKw6Yto8X6TSfFuLHri9ED8XuJ+wtRVpyr519NsJzHxrA5ofKuq/efeuO8ZvkQQF1ImEQhzcQyoM8PxBX7dCoRIYpVky6iku2fIlUD1yP687Jlgd2D5VIggRxiZrtgnFQEMhM7lG3j2B4R8ZMF02eVJvldk5MqHDXxfUYziPolvOzny/D9f4jeHFkIoufvtR39Tye7R0RSRgx9uAoPWclTGHGTrB9s7Xyf9KYR0s2Cncg014UzF9tD9niusDCEezhjKXmjeN/tgOM2Xts+i+/Vb/NJV2jmy3mWjv5E51Q6VovgV1cdqaQ9B9wvT/ULfVbR7VZwqfHyYDbOiIwlm/XXmQSUh8QVDIw6w618oMlz1sUYxkt+XtMN03O1GKqsjX+AAsKJA3DaFS10p1yDB6p/dE/p5e442cutfWoIuz+4bJdnPGiBy2F3r1HjQ9OwStP1qthaNRjRJi3sBXx234kSw78EbIM21MWcS6CekxSg503+LdSgpQlHNrpPiA5l1e0x79NNgir61x5Ohrd+akquWEpjp5M17g84nKA7U9v6n8tbs/jpzLDNDfWt1D6kfcwJ1wppAEwHH7k5JFx9UuAMX4kps/2JagIbcCo5MnL5U3t6PsyVCIs57QnP/eEgowI+KqKZ/Stn9ubAcMcCsNKAxqoFFBFd7kwBwxAwfj+99LIPz7IQHnDzuvyY24KueSso7UKPLOh3U4vXDSMB2SrysdZ2ARrlo15NoQBUhorlOipmKxmwBQBfx/x9RNYdO7Q5qDN3WDDxg+MGLtGVPF2ctsnaU0rZYAqG+i9e4rA3J+ceVwnoLFw5qWqfw/sCFEoRiIiBjZ0hEM9e4icv0rwVb0taeaRUpSyJkbM
 HNsh1VKE
 EsgtPSGMP34/zaY2SkTAfqbvXe+dyapNJkilDYa7L1XKsIJDuf2vxCRY3259c20iZuyLwjshcc6IVqNAlwaqL5HlxW44vk55qpguZ6wRwun2z0fc+5V2erpwlq8c5CD/I7sxTeocklfUCj2o4HGAaeYZVcDtE2viYGr0ioDR0OvuWevyMZA2PVqC/7j25XdmZnJDa/APSTyw4XDoa2thvfb/S8cJIMX6+31HLT5/fM0lHDm9X1zg+RR129894O6fdV6qh/fIXSdDqD9oABSNK3OSJbyM7fjYGSa7y6j8Gt3mN4TnbtpO22ZKzvXEr6dAkJREEA2D0i1TG8omkrZxliIF5AEM3AYxv91l2M6DvmA+r7S7dnsP7Lckinb9AIW8TDauRqa1f5gNzQUMUEB1s02vMe1GxwU7odTGCwZHhrCJQ1ZvVg8pxm+MMJJLJ92QQ7x2uo+D6+1TH7ms8sbgmxMJ8gtbOzhQxvJNuESX6SaYrYlUyhGKU5xCoccl4xEuscBGJ+2jXFTD4idSPDlpy7sOq4hobtm9CZ3RYgb4h3bUg6pfTelcG/G8iyZCDd0vAx/P+L/I6DNIy7Jy2Vl3wt8qZehTn3FRKiDUpE1/wuhSQT3uar8XYYnttjv/erhWLC6/KeLe7I36NEISIVZyeb0foFTFVp1ZlVqNK2E5kNnFj3QQqxkQ+/iWrTCjGo0XC57UK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_find() keeps xa_index when a lookup starts inside a multi-index
entry stored in a non-leaf node, and aligns xa_offset with that index
before advancing. xas_find_marked() still does neither.

Walking from a sibling slot to the canonical slot calls
xas_move_index(), so a start index such as 127 becomes 0. After the
cursor has been walked, xa_offset can also stay on the canonical slot
while xa_index is inside a later slot of the same entry. The next
xas_find_marked() then recomputes xa_index from the stale offset. If
the entry is split, the call returns a marked entry below the index
already reached. xas_find() returns the following entry in the same
situation.

Resolve the sibling without moving xa_index. Before advancing a cursor
that has already been walked, set xa_offset from xa_index the same way
xas_find() does. Keep skipping sibling entries at the return site.

The userspace XArray test suite passed. The kernel was not built.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qian Xiao <heyheyco@gmail.com>
---
 lib/test_xarray.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |  12 ++++--
 2 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 615f7730a5bd..ddc392d42d29 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1316,6 +1316,109 @@ static noinline void check_multi_find_4(struct xarray *xa)
 #endif
 }
 
+static noinline void check_multi_find_marked_nonleaf(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	unsigned int order = XA_CHUNK_SHIFT + 1;
+	unsigned long next = 1UL << order;
+	unsigned long start = next - 1;
+	XA_STATE(xas, xa, start);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* Multi-index entry in two slots of a non-leaf node, both marked. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	xa_set_mark(xa, next, XA_MARK_0);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Split the multi-index entry after a lookup begins inside it. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	xa_set_mark(xa, next, XA_MARK_0);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), order, GFP_KERNEL);
+	if (xas_error(&split)) {
+		XA_BUG_ON(xa, true);
+		goto out;
+	}
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), order);
+	for (i = 0; i < next; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != xa_mk_index(next));
+	XA_BUG_ON(xa, xas.xa_index != next);
+
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+
+	/* Nothing marked past the index already walked. */
+	xa_store_order(xa, 0, order, xa_mk_index(0), GFP_KERNEL);
+	xa_set_mark(xa, 0, XA_MARK_0);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, start);
+	rcu_read_lock();
+	entry = xas_load(&xas);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != start);
+	rcu_read_unlock();
+
+	xas_set(&split, 0);
+	xas_split_alloc(&split, xa_mk_index(0), order, GFP_KERNEL);
+	if (xas_error(&split)) {
+		XA_BUG_ON(xa, true);
+		goto out;
+	}
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), order);
+	for (i = 0; i < next; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find_marked(&xas, ULONG_MAX, XA_MARK_0);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+out:
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1440,6 +1543,7 @@ static noinline void check_find(struct xarray *xa)
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
 	check_multi_find_4(xa);
+	check_multi_find_marked_nonleaf(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 48f440d114e1..4d943791a7b4 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1495,6 +1495,14 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 		xas->xa_offset = xas->xa_index >> xas->xa_node->shift;
 	}
 
+	if (advance &&
+	    xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
+	}
+
 	while (xas->xa_index <= max) {
 		if (unlikely(xas->xa_offset == XA_CHUNK_SIZE)) {
 			xas->xa_offset = xas->xa_node->offset + 1;
@@ -1507,10 +1515,8 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
 
 		if (!advance) {
 			entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
-			if (xa_is_sibling(entry)) {
+			if (xa_is_sibling(entry))
 				xas->xa_offset = xa_to_sibling(entry);
-				xas_move_index(xas, xas->xa_offset);
-			}
 		}
 
 		offset = xas_find_chunk(xas, advance, mark);
-- 
2.53.0


