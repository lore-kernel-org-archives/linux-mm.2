Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7924EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F276B0095; Mon,  2 Mar 2026 14:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6066B0096; Mon,  2 Mar 2026 14:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7911F6B0098; Mon,  2 Mar 2026 14:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0706B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 203381A0287
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:19 +0000 (UTC)
X-FDA: 84502172118.28.337C255
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B7F140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eZhPDW8n;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SxQ/eLtCsKDNFbOz1QdWcfhbyrBVWfPJbSjku1OsMI=;
	b=Z5AdETb4VjLSiCPPy5PFFAnT42EWxUHqoOzfMRgYfeinAIV9YmDK5UiJb9TK5WQBsp3DRY
	r/U4KOPgXYDR26TJ+DONoYXT548XTOdqHcvw2raEKGT/OYqQo3WIfciejsV7CW116Cl0tV
	LTeucLXVWrkAIuKZmBQeEk3ja7Cvhvk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eZhPDW8n;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481197; a=rsa-sha256;
	cv=none;
	b=MOfLCL9o2E3wSZbk5gymJ4X7UcSGqIvOoD6n5TlTgjKj6Jh95Rj7GFax/dGFv+PseLAZrq
	tAYBivC9vlo43XD8OAhOFVRZmIgQeQcO3vArH6OgzFwHJ4HZM6bIb4GCgJqtvG9bLW0lWC
	rF58gq7BNiJUN3oj+dgavy3qqGQUTv4=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb3e0093e3so469028385a.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481196; x=1773085996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SxQ/eLtCsKDNFbOz1QdWcfhbyrBVWfPJbSjku1OsMI=;
        b=eZhPDW8nKysl5er5C0iDxnpgGPivNtCmJTrFlbQ2hmQN0uir1OQ34wlOWQ+aDXZgJL
         U4vrLaHT/obRty/zZlV3DHuDCipHfMinek0pyp8fSZ4HJvHbk7TTxKhlee9BAhrlvGjQ
         XxdBw6dGBuKDjRLSyIJecL3IhI7tFlYQlxsVJ/Ib12d1X1jP+Qrnn/KQmZGUBj4jgybk
         6whvvT4edbZJGeWUMxWMWp0Vw+HmbRwcE54deqXltFxvy2b106fcTQgZ0TuqmTLBUyEs
         vjyXWEEIk4MJ3T1a7ytJDEzBJaPEY2fUGdYohBiaJkBX8/sNV7V818xqKNxeTMc0tC4q
         DLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481196; x=1773085996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9SxQ/eLtCsKDNFbOz1QdWcfhbyrBVWfPJbSjku1OsMI=;
        b=ApHpyZNabcoyJ/ybD/bgVMtZycU4HrNzYNgXO4ndoHaLjy8NobOSlF/UwzE0fkiJKz
         k/8DKn0koo7SHYF3juwp055FnpZkvX2urBVdxroNKAql/0VqadAO0C6WfopwSR3AZyQO
         bCul3HyD5ImnKGde5/K7Wja1L2QK9nHI2NTVa+HUzH1giOh/48tSWKARWy02iVPtVmzr
         zs0TQ3wFMzPX0HrE2SJKK1HwtEzkcaBvhob6Z9qrhP7ACg/nG4aENVc51SUj9tNy7Gzv
         zVtqZRvkhGTlZyq3DY/2kEgE4V+aIYfku2rmDywXB6TeAATelNtVquZaDFVVLFgWugRG
         NK8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX7Jn+FFxbumonJYBTlVLrqCsDu2e7uAkt5KqNQRZAfHl0wTE5OOxmBpBLZsJoG6nq4nUQhL8sKuQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl5BKIAyE2XH1asI5sVpXokfgNV6SMN8vLvXUlhu1YmhuG8ZiJ
	qitoLV2+LpD+7eqoZGWbfA3QfIUw6JRH5U3Sv81jIF9ij+8rzwVTV7hWG4p+6JqUSKg=
X-Gm-Gg: ATEYQzwCm13pyDd+wdoKtN9zEYhim16880dk9VbdWYv35F7+hzHFt+iFGswHEM8L7Kz
	Kp0wMkX9MY2EZC14ZffRy6Mhx3xaJbp4mYiueqOeWs4SiYE17dTlppddGsYWd6QIqfDU/9eMfB+
	it8TPOmvpYal3q8YIvi1xJCKi7o5QtprPaXBaV3x9UPEO5aXtnW9+pQbuVs2DCet+HzJKj7P1fO
	m8c07QcgRHrzNcU9DQ+tSu/VyPdDlDgtQ+pv6FEyf9S/BDIfsSbNUQZ8jKIao3qZc9gfvDmnBaK
	KQhKBd9WD58r0J4mim5U3i+yz0WlTXS+sCZl4ldxz9USC+248YLITpHjSo6ZWgR+/z5NvQYxaXn
	3XueQemBdW+zT+k3Hj3A+cS+JFIXfqADheByNkR9vilpqs0OrJJaMQlodzdJd7K91kunUdiooHp
	jvlskE5hP0omFS0mDfkkYsTA==
X-Received: by 2002:a05:620a:400f:b0:8c6:ff02:d825 with SMTP id af79cd13be357-8cbc8e03048mr1741310485a.48.1772481196370;
        Mon, 02 Mar 2026 11:53:16 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6535b4sm1217544685a.9.2026.03.02.11.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:15 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mm: memcontrol: split out __obj_cgroup_charge()
Date: Mon,  2 Mar 2026 14:50:16 -0500
Message-ID: <20260302195305.620713-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B7F140008
X-Stat-Signature: xwburkorw91aenw4gx3ciq41m78jc5b1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772481197-874052
X-HE-Meta: U2FsdGVkX1+zONEWxQOLelTwNiCGkFG0oj0nV9UQudChLK/EOEaAqAUQiu6jLT9AST8mVsuySZzkyRvgMzHsFaPVrwA3YPPXY3eMJl+b7I8V31l6wi1sMe5kE8ueo8trqR38fF6rbELBz5vDXAQqMC/DCBcCc+T+WsXe93mbozAl2TtP4k9ZzNpdNQRA7bRObP+NWV/8VZRnataG+tdh74JKoCV6ODtLk8gVorhuHEh/1gIrWHZOJfgdjipVppWK1PXk1AFteXYIT7FEIs6wsQNrbebyMe7fWC94KhfjcL7xNhR41wVg6eHYdjddn+bqLyQ5oZ5Cl0UkdgGlNWE0g3/ARfbNMqFk5ZTtqVE0z6Zsbm0GAUhDv+NeLAexx7qOO1sUhanqbDS0jHU9qA6cw6MUcebmGwl6uAS3oZhDT12p9GnzDZ37W+kbJQ3pTR3zJVXjO1vLTK0RjHI4mPjnP6e3uVA1fP4EI6zn4VG5DU8lra1/5JmQSphXhsDhHzK17bATyDdEn/wBwzW+ghckLr2YWXUZqPRlKLudgjIOC6YUqja4dd4lEYvGfKvzwK5ob2r6Y4sHLhVDWZpdpAU/xLHcv27BYM6GFVsxeVv2ZCG9+H2RvWLDeBuMvImAE0UvkyH/t4z4VYwieFpdR0n57PJAj8A0fcrb76TxqGoGriLtSNA+2L9EaGNiSp5JRlhuPYqs5i5kXuUQ4OyTFwAnTS46FbyNjZP5tkpIohSdU3G9yGhaAWlAb4ztIUY7vzI9vtoqorpu01gra8mpIJxu/S2YKO00CHZFXn3JrZoLXxcJGu99iVHfdb+b849A/mkKNp96I8sF70jda0NsHRIUNUQKfWx8MxeiICL2agRbaL1BvtUszwS0rVHUCJAoaqq8NKVo8ofpzcSq5crA676J1wPkJZYeAj+9bksUKyQuiLyrhCbnOO8desQvAFIMPeRRbuTkQMOmhk+y7SxFhNM
 NUXKXOei
 LsW8ogkNDZd2YiX9jcK7ua8NsmA8xSKc6S+FgKHDMD1c4rTqy7hvIgSiBL1vrMp7DL4ri9CucrB7rKtylw0Z/bBZYyIbO0AapiWhFVNsO3xhM4S9iuCzNB/f9ixAfHq9r6hyzO+4R87e6SxZwnJueHzR/5ROBKi9fMeUOObMqjsOtbVoB23/jf2rJpDVjaeO/J3iGAPjKdF178z2dlp1SGsTcbaoX23MjEeEM8Liinhx4zv7r905dsLRh/tTPtklJnkDZVaIlQf17qTjOAnwXSA73OgUB/Vq/PQY8c/qoVTEgVZxBjYw8szwp6jr8JJ4IWLp7cBxulImQA2HlBScguthijilZ38ak6dgdzJEi2O7rTPdb9XDkd+4J2sn68E/jL3vy5NZpvTYPYq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the page charge and remainder calculation into its own
function. It will make the slab stat refactor easier to follow.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d0a77fedb00..32c09b4d520f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3414,10 +3414,24 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
+static int __obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp,
+			       size_t size, size_t *remainder)
+{
+	size_t charge_size;
+	int ret;
+
+	charge_size = PAGE_ALIGN(size);
+	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	if (!ret)
+		*remainder = charge_size - size;
+
+	return ret;
+}
+
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	size_t charge_size, remainder;
+	size_t remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3446,10 +3460,7 @@ static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t
 	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
 	 * race.
 	 */
-	charge_size = PAGE_ALIGN(size);
-	remainder = charge_size - size;
-
-	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
 	if (!ret && (remainder || pgdat))
 		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
 
-- 
2.53.0


