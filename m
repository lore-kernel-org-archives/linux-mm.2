Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE8DC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703D96B008C; Sat, 26 Sep 2026 05:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB496B0092; Sat, 26 Sep 2026 05:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA406B0093; Sat, 26 Sep 2026 05:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23EE46B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:24:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AA8FA088F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:24:54 +0000 (UTC)
X-FDA: 85255378908.21.5A14432
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf19.hostedemail.com (Postfix) with ESMTP id 045A91A0006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:24:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X7R4bFHk;
	spf=pass (imf19.hostedemail.com: domain of 3Y4-3agkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3Y4-3agkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z4j7omQNB+TmgxmIXBVcLYQY7ezzfW8m8OBFfXrJ8Kk=;
	b=pujnRRKJENsfVxc5b9Ueh+JkKH2ODRAn1/ASPkiVcpJbc7cfGOCSp5iAHtm8a3P/loQZYo
	N35q/biBC0xc9ulba7KNq59cKb8RCYTpO9mwo0tWvWr1SjjrI2QnQmz8+ELq7R+HPKL41s
	eppWmfwjp2SzUTtYHncJFfM6PF2vhnw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X7R4bFHk;
	spf=pass (imf19.hostedemail.com: domain of 3Y4-3agkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3Y4-3agkKCLwvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414693;
	b=kx+egqzztK0jRWhzOR1zQvZypx8ezgd16evqYv0wJRVzPuxvcWZRjOA05g1jhkeuTom4KR
	160NgDQ3ekdk6ADHgiZOm5o1aJiJqYlUV3fe10lnl0dkVKqP76jmdYpsMGJQwpVkCT3xnV
	HLusXbJuprzqmiCyXljuH2lOX8xbUUg=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2cad6a0fb0so61746366b.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790414691; x=1791019491; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z4j7omQNB+TmgxmIXBVcLYQY7ezzfW8m8OBFfXrJ8Kk=;
        b=X7R4bFHkSUQLzWQcq+jgwbfb9sw+HSTIOid2A2Yyf1EEeZlFXggsi7/SL5QdfZCM8k
         Fiui8/bzcJHCGiyXd/DsMvrUGZAw8G3bAjdqqKmobHv9twFmLRhzrp7ry4dM7tXhQPs7
         Hj3fAUE660zuQ8PquGmaGVx6FmoXuT5vScjA6FoC1quuvVjVyqmbmjJkch++GMCrDAmF
         F2VVHH5euWsLediPG9U0VhVsFd71SyQa8MnlidSHkEKNgI95xm1eFPBalcYM9mSmUpq4
         U6rQKHO5Cl/9ER+/rYSppsklOJQ6W5pDMNHVf9ICeaSRD+q1rBq2aApFGr9YSUnGBHHH
         eoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790414691; x=1791019491;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z4j7omQNB+TmgxmIXBVcLYQY7ezzfW8m8OBFfXrJ8Kk=;
        b=SDJ8SUatS2LjdDB72Du0peNyHxno20GhdZs5te6CB/TtufBs69F0jOg2HSkWyIjpVp
         lgS2jNi4Z/lHt3l5Hqt3Z8PtZUdlaJ4uEkS1U/4FI8LNVzh6IE9tn5Il8Yg0qv8wYCtB
         /8kw5oz5yWS12LgEg+Ij6eFXmi76dg/+n1sgwfYxMuojTVG33FrVjLkJACcnK1qDfkNa
         WmeoU7Kw5jv8iFxRkq3WFOkxZR9XIA0TBy+/ewnGGjtKYpgaBNEJz3jjCLwM0VldYRvk
         1pMCv162y+5PtIsTghy8ZRZmkS6nxjy4p41DbSQjsbyjKPC0r/2Xu/y20dO597KUeW7d
         Kokg==
X-Forwarded-Encrypted: i=1; AKwUvByftayQPiI5Ub5QVSalsgZw7CyFLIJ/JMdkjPVT/m5kTfhHqtXnEsmuWr5soC/UOa33rlwMelXaGg==@kvack.org
X-Gm-Message-State: AFuF++kmnFqeV0sWO9gCxu8mhuUXd7s64QpLfBbDJmXfXbKw2FmjJiVj
	OdLn8+OV0m4V3wPaMhCF2KY3AY8iQQMzYsmZME/K4sMLBg3/BMt0x3DVYd3NYHV1Bqp8IrbTF12
	b1MYsu+2IeoobpzPuKw==
X-Received: from ejv16.prod.google.com ([2002:a17:906:3090:b0:c2d:beff:b397])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6c17:b0:c29:f5d8:9c71 with SMTP id a640c23a62f3a-c2ac223e35emr724660966b.32.1790414691194;
 Sat, 26 Sep 2026 02:24:51 -0700 (PDT)
Date: Sat, 26 Sep 2026 09:24:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260926092448.4090401-1-tarunsahu@google.com>
Subject: [PATCH v3 1/2] memblock: drop for_each_memblock_type() and open code
 its users
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 045A91A0006
X-Stat-Signature: ftq8qdac7gpqs7kapttuw96isiugisi6
X-HE-Tag: 1790414692-877822
X-HE-Meta: U2FsdGVkX18D4hrR2heHys/uK2HVHRoeXlOcCQjjRUMyVHFOHloNr1j5W2GN4f3UKJZuAJklIWrFm6jNWeqYFRk5tc/a9x/+EGNcg+3nZrYuYKqawoNse6+9QMuMPxb5e/hGcSWgH0PuGu+NUHlEdSNhP2O/ZCqG+o5NEtsL+zX6AdQLivbtvEE9aqohvng+bFU4XSkql1+7OAby3IF6lLAT2x3+4JGuEXXq+G6rThmkOX4pmgxUOnDqHbgkYah+7Z8bJvCzgaHSzKBJxYZk/TUHVAV+4vGl5/InUaV+F5b23jm1qJqqRFP+7dBmWiEInmvoYYIa5tB+VJUqI9mZtHNj9WT1EOFqRJQ2FKeaFa/TN6xNZ7Mlwqi3bPkq1dal76N+94WBjztREJ452n73/qk9i6WOxXUC2oPR8RaedBTrQPdCmKbOcLAcADClg+zKWIXiFPpjdLgNTGfKsg5IK/7jbf6FR8FVxuYQA3yDO9J4IA8Bv85dpzF98x6brTDsRsbz9RmLdsEA3eeR3xuY+++zYlq8LKL/ls5SZBw6nJns8zFC8vip3/NkK/uwU8dytwV9uoRls9VqSsPR/Le86IPsNvbBO4bNWkXPmgG1VcgvMMQkjnU7EGUQVg8QghmvzRaToKPhLEVAmJBAPRmvqJciK4gJ/SS5urUx5v3ESndPvIr5WKJU1C3YLjTtL4AKfZKs6JYxzlxJE0Kq6JNvOYKuTZlDJgruqy0H9MZBX2aXqe/5ZjAhW6TcTJa9ufEFhVPDQZMbd/TDqA3gjxG8DH50RaPTsXyzBH0YfqCBXMBr/rY6X34pqza8N/OSNTOyRyisy5RUvZ+M7IdSOxI45nQZD5N0Cp0HpY/X2HOVneXo2VA8KsxGyQcuMQK249PPUsAmXFVm/RqxYN0cTvct4Vi+e0Zk3LB/CHp0MO90+LTpNiHI4EfO/K2OXtwLQEn3UyIVQNAKmWxvIhvqqSa
 68GSrjC3
 /+gXLHBnNWi2ogWFqbrtzFUCvF/xfOCumj2NCPv7DUBWKJvi22gbI+tzefkkqcL2Ma36QtaWsjpmQd54LPkNUEgZssUD7UXQfkEYdEqj2H7oh7h9Rm9gvoP7uKU4HpN/BawCulLH59e6GCxIEEqiTDvF/iZjc2lU571PBLttfKUgd0uzzKZjxBazJxbLdnfFkx12iRaD5IW9nipmsHTSusRemBpqyrRaNOGzjweFBzsv8e+CL5X2bktJPzdx8eUMzLsgbG344BLhqGdHTd7xfOeBL7g6rRRo3ngXEYVfXyv6jGnKtnCe4AlMFQOtkpc0cpdCzrDoy8D1uZzrNLKG98TVcoJobnKjgLWuo8bLABMcG28DhOpwxQbk9jDpWIrIIQRKBa9sba7VO2DTT/YYPvQeuiaLD4kiaczg3JloNpU1lijFtahXBZHzEkPl3SfJA+SENJ8ZbdxWWIECPTJvoH5IaIfm8l6tnspxWEFGZhgAWTPd0kCybD+NbVTcWUGBmkZEDPswW0sTKxCzwHp45pqCoqax5NGE+2luhuX9k5Ywkgeh51rEeRb5d8pYZu+AHCu/lUoh9dZTLTb97ciaGlQSuj0hDjTfIye0q4aGrBcY4+Tuytqj3uVny7pgltbA1qy773qVK/JcMUPT0/05c2hC1vXYdoEjfefGoPVEsfic0c8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

for_each_memblock_type() always starts the iteration at index 0 and its
body is a trivial 'for' loop, so it hides very little. It also gets in
the way of iterating from an arbitrary index, which the next patch
needs.

Remove the macro and open code its three users: memblock_add_range(),
memblock_isolate_range() and memblock_dump(). While at it, move the
region pointer into the loop body scope.

No functional change.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
v2 -> v3:
- Move declaration of 'rgn' into loop body scope in memblock_add_range(),
  memblock_isolate_range(), and memblock_dump()
- Add Reviewed-by: Pratyush Yadav <pratyush@kernel.org>.

 mm/memblock.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f5aaa38cfa31..59dda7d085f3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -155,11 +155,6 @@ struct memblock_type physmem = {
  */
 static __refdata struct memblock_type *memblock_memory = &memblock.memory;
 
-#define for_each_memblock_type(i, memblock_type, rgn)			\
-	for (i = 0, rgn = &memblock_type->regions[0];			\
-	     i < memblock_type->cnt;					\
-	     i++, rgn = &memblock_type->regions[i])
-
 #define memblock_dbg(fmt, ...)						\
 	do {								\
 		if (memblock_debug)					\
@@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	phys_addr_t obase = base;
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int idx, nr_new, start_rgn = -1, end_rgn;
-	struct memblock_region *rgn;
 
 	if (!size)
 		return 0;
@@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	base = obase;
 	nr_new = 0;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 {
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int idx;
-	struct memblock_region *rgn;
 
 	*start_rgn = *end_rgn = 0;
 
@@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
 	phys_addr_t base, end, size;
 	enum memblock_flags flags;
 	int idx;
-	struct memblock_region *rgn;
 
 	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		char nid_buf[32] = "";
 
 		base = rgn->base;

base-commit: 1f18d740165163910df64d3063e1ad31648bc5e0
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


