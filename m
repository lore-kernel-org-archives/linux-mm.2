Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86CE7C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2756B0092; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BB06B0093; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0676B0095; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F17B6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D522CA5D1F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:22:44 +0000 (UTC)
X-FDA: 85224982248.01.2AA9B2F
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43E8F18000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:22:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iUg5q8Qr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3UYSsagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3UYSsagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iUg5q8Qr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3UYSsagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3UYSsagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789690963;
	b=TRWJwQzEsTB7g/vFaYdrsrNmE7a4/GHZfOCnY3NtwjgjPEqkAVQBgodwl+bm7xPDctSlhn
	tWFeYC+D7lyV58FDbkVd1moD2Te5m9byRJrYHXqv7xvfN9QEhkQHZ/88/LI+DWTHWAJxMH
	mLnRnNlBK07oIg7pX5Fc1X0iE5jk7Dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yxuYFkClNtObVJTirGhxvNI3z/6AMlB4AtngbQawpYk=;
	b=KPmKrOq6RWQ4RYLflbY9CQM5uAsHftNEX2790XR91tZx+yp6oOS7kbYtBnLtcpyDkXE2Qt
	GAb12d7vn91J+pM9M0cFPUNKtI/jY7SVTkn0ff8k5xKFc7B3lrl2Y7SUs+Oldciy9HmPJc
	BWI0QnAJkOk3ld9kNxBhdz6iyXby/oo=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a18e266026so150228a12.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789690962; x=1790295762; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yxuYFkClNtObVJTirGhxvNI3z/6AMlB4AtngbQawpYk=;
        b=iUg5q8QretHzlCOL6PCuMhJAB/Hp0eRN6cGukq49Rowqyku7mW2taxxD8AlQzCgQng
         3NlYwLB/alm8zjzEQoCU4A6vJkoih8V5ugn7j4vA8IGPR5qkTLR7sqPzAq7nwwGepdZ8
         wWlzR+zmqeXMQxAnDvXWiHEuxhVgnEXuSLEFO+m2gvEyNv9EzFSg9N8MJqJwKnMZFAuj
         hhn0ZxmRQ3746EwJ8txnTduxdBAZ7AJlVXJJyXvNSeENA8wEqiv7u8KYBS5iVtlQIht1
         JL/14RjfyjvAYN+OhFp50VUzHp8JSyY1f5r80Q44v8JrGZtUogYDjMOZ8OW6b0n5uN64
         omng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690962; x=1790295762;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yxuYFkClNtObVJTirGhxvNI3z/6AMlB4AtngbQawpYk=;
        b=ibemsLEvLuDVhVv06bfmHWIlQqz1JSzkPOVTawogGYXfV9lppY6L6hh9tZl4/tjMQ0
         YKLWl1LS2PR2MfrNrUscd0u74vkjUhMyOmmUbToolfQDBqdvRiCBEob4GbZD8ooKFYCo
         s3d0/4M/31CYvfRgZQzU8z4rvmmgNcssYS/RM068NLnHwqim0c2YTS5poDr1/6eKJVAD
         EngEwQITkUlIyafjmymVCdEupakHkWydAi80HRc7pyniAYOFsMpx/1PmBEBWrWVkI95Z
         prVx24+oI2xOGZurReFUbLNnlIRR3aLj4020ORo+FCLFlxP5Q0GCmCUm2P8O84cudqr/
         GKyg==
X-Forwarded-Encrypted: i=1; AKwUvBye98dhVSMeOR4IYrbjFDsTpoUeqVJVvKY1sTTxgPHJvEZlRvGNHgfDHzokGrm3NnIJPDgFBIVoDA==@kvack.org
X-Gm-Message-State: AFuF++lq5+vssM0g3ST9YQDYo8KI3ziVPjeHlH67zwZJJVXBCH+xS6NU
	A+6XaHP7QihfUZCnVKiYRbY6TB0B79/D/m3a31FbQsETTlcUIRl4ObUOi5PqziryWM2/dWx1c3r
	h2KswSw+v2O0mUlqM1w==
X-Received: from ejsg22.prod.google.com ([2002:a17:906:69d6:b0:c29:ece4:d406])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f87:b0:c26:19e3:e98e with SMTP id a640c23a62f3a-c2a1582bdfbmr81796266b.46.1789690961563;
 Thu, 17 Sep 2026 17:22:41 -0700 (PDT)
Date: Fri, 18 Sep 2026 00:22:38 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918002239.4024231-1-tarunsahu@google.com>
Subject: [PATCH v2 1/2] memblock: drop for_each_memblock_type() and open code
 its users
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 43E8F18000B
X-Stat-Signature: hn3xcg77f8m3k1g7n3kirb5tc9xsq3sr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789690963-545924
X-HE-Meta: U2FsdGVkX18bKENEh5u+Je+o2UBwHiwSgfb3LHTV3FXW8boxjY9qleyGRaxPnJ78A4yv7S8d/65370O09LAlcDhPJMjoN3rcXLsRYFlJzx9Rmfe4utXjXBrxucFLnm3gDvLFPtr2feql+KI7C/9BWUbD3bs0PCnwRFf6S6q474wl8WzSCgYbzBXvQcCI5Jwv5kba9BrCG2mWUZmK3+VcVY29hEUEhVusf6/dy4oQY8ZUJ79H/E9x99JqRzS7wXuSSzsl7vpcM+a9HDlySFbW0b4xlj1GkYkPhdgl6w8Y7H52ZlhPLeWdkBJnrLcsb1GBlbSktxApTfJqw8MABJnQzwgrClMR2CfSel0fJrxO1SqDxTLILqpskPteQGyS4fUHbJq9qZt3rtFWi+dGdoruP1OP4pxzldj8uApcbuLDZbJgJbOzXTJabiZeMqEsEJqwVw/Qbay6G1HpSgfECqff/hZN7v/Yc98DRVYor3yKiPImiYXRDpumxo+Rt+TKbJB+TpwO65eP5XuREfa1KY1m37yGMxIG+jrTHgHWAwb8Vp5KBA4Iqz55c7nfqIdn6RAPWoJrTro5spylAS9DlzEweXvTyDkzotVjo6ReVLXaXxTJR8IRvTCVOCy80Qwdl61irCbmKgyLUn7ffcEkl/irzHYuyQrTWYy3Uub6DatDk7uahQoeWfVDes+Pss3IAJCAJNLiqJa6Yl8mJzQxgdhOkg2R6fGQVua/kTV+c0noJmHBFfiMXEukPeoIqKl1jqu1xPXRe/pWFVH0/HoCSTH7rWCrvgWVXi1vzu7JtM1giMw+iB0zYCJKsZHC/AS3kULyy/Mc1QbUYzO6IPjypDYp3/5td6Rjfu7JK6ydpEABLC1YKUIwV/HhWFVA91R70h56HudX3+7Shfk4fHaVid3Ur1YFuPcDNqLouBXc5iTmVi4NhFaxDpS9gH5OB2Ip0uHed1eI8TJArTS5fUPCoXS
 wXKYsUQN
 Mo18Hp1vZq3WxEYeRIhG/tLNGrgvcINFGyZRnjJF65XHAVkkBq4h8gzkN0cl6ZURYmGlMsg+G0twrSwV6sJ/aGanm7BtPe7Z5LbV9MbSEo6y61ocvv2ZgPryfMmlCoZeuSa3fB4k1xhaEErgXQUaSISq0gVB4xULt4oCK3WrjNOvIX+mXK+aLPlJBcVbflQRv94nAMoOcvdwwpBcdSnHPWjCKGI0sI7o29yKZjNwIYalrBtUhgraqRMFesyd4J3L4ETBRVAm1Xw2JRtvh0s0pjCWPI0TLfzuTqEw8QzRFyxDewKmb+yKWDJq0fqzhoDTkFJl2vir3tbp69a6JGEEqiHNeELm83LJgmIQPm/ZIrjyk2EdA1m1U+RTBRo1gJIZf9Tr/TNsbHXMybfs8dM7iNv7K4a/gpe7tqmeZMP6aTf3R2zJI176P9irkgb7sn9AiXzwfimQxrmzqeEjMeG5vjHmB/c+Orbau7X/Ec48dAJhrN1zbHiJ40lh5XyIdA5uOrMkfXZz2IgeHC+ij1HZ0Cl6QU8mi+ir412u/YXRGhmonBoDdsZxZRnxxtPoHZCIZkbSFnwKVLwIVdZI+0WGRt49pEVGVhMAXqekrqa774OouoKYQOW7R/b+mSbacQYNXrq+aF6OquyHoJ8JP9KvTXvHrPw==
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

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 mm/memblock.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..5aae75d34dec 100644
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
@@ -651,7 +646,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	base = obase;
 	nr_new = 0;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -827,7 +823,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -2198,7 +2195,8 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
 
 	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		rgn = &type->regions[idx];
 		char nid_buf[32] = "";
 
 		base = rgn->base;
-- 
2.55.0.1082.g2b9226bbc0-goog


