Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F335BC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57ED76B0098; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F1F6B0099; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A90D6B009B; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155336B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78B37160266
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:17 +0000 (UTC)
X-FDA: 85156769754.16.577C857
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F4D1C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=AkxPNICP;
	spf=pass (imf10.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.216.41 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDQFaZkSZClgPI6vQ9uvEW8golFAoyljS7GedCtCSvM=;
	b=BpOSN5iwHzKToVgQr2zZZscYIFCaSuhro37FbNctrZpW66jNt/+WgJU1MrhjzeEEApgMY6
	DkaFD9vK6mm28qKkbrQfvx3+svMP7muopF2PFECnjE89T+4DrFHuUeM0O9MlYckxySGlRa
	XoXn6YtkwQnMuemhR4PCRjwEInGMVHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066855;
	b=OiRJaaDuWArEth2qeX8C1+jHXqnc9xVbhqzj5LCJ7aFLsfYUCCehNYJHWASsoD7fDEu1X6
	oB8hWpvJS3/7eOkvun252bzYL0I3GnJhGRZqmmu2PpSE1rNbuid7ICJTdVL/0v1HxedrSz
	HiEDCchMZknryAvWemJKXakPJdro8rM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=AkxPNICP;
	spf=pass (imf10.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.216.41 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-398b1e63c49so577300a91.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066854; x=1788671654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nDQFaZkSZClgPI6vQ9uvEW8golFAoyljS7GedCtCSvM=;
        b=AkxPNICPY/ySin4ceh7ViXUpOuAaDbX0t+uVvbNUOwhFltNEaSawpl53agF5UqaQIn
         HQhNPkMMlUBu0dbFKBHnY2k5cLgV/RyQphfYUDvXaT99lzkC6lNdXC/MNvkrWrzao/vB
         l1Te0C8SufXQTkjSVMbZXOfCuFCSeIfyS276eVwhzNg6hNCBw7EruJBgYeyf04olHz5n
         YdXtIOm2IaY9e6/0l3wQnmIOihE2pgfdHNg0JseAI/wFd5GPD3Fv6TUIdYSdv2iPE+W0
         eIc6W5ZZmnDYacAFHtW8rPJCtcbZnjoDLKVMhg9JOpq4dBNecOiqI0RgDAyzRwagmhoZ
         V9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066854; x=1788671654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nDQFaZkSZClgPI6vQ9uvEW8golFAoyljS7GedCtCSvM=;
        b=gT1HmET4xvlquZ3svPd4Y4QBpuiMEOP1iu2Cyp4lUUEYTVbRUyJncLICsutIaMdN4E
         IwD+wuENWnkq+NErF3Z6cWf8QJYLUKtFCMeAo4dnMB3tahOQ1AJls3IdlVw/4oANxxKs
         nQI0DxMb/wu9PMpmtQ5kvmTjj3/2WvgBUWSh+5jgNXIhRpbxwTrJ2Hw3850aTUuLYVUt
         kCmAJMNnd4jkjDSLpB4XFdVPaFT1DILhgXNucfTfnJ/CX56i67oIm4Zo0hBJVlcehEp0
         xlx69QaiSpu9fsDsL9EfXsVq9xmF2D9xZyfMeAL1uzX10/k+lZhCTyeHsGCC79iIO7tX
         fQJA==
X-Forwarded-Encrypted: i=1; AKwUvBzjlXlXyKdjd1ldD/w3e3SARpo/pVMCLe/efmIvim8Ri+ZWvfoba6Z8ZpRq0Y74lEIPAcUHcrjnUQ==@kvack.org
X-Gm-Message-State: AFuF++kNQ/fzwPyPJMPwnVgvm69duR0nq99CobXqdzt8Atco92WET0yh
	e6VUG1Z0i+ywHbb08TBMtR1Q3iH27P6adlLJ5FLbY1ihKW298vretMhFP1hWGkJAVmA=
X-Gm-Gg: AYBFou3u342SW3t8/v/70fdgRgGEXfYXbZth6mZ3VQQkilvJ7m9wG+1zcjvpmPQk3T+
	a0FPRiXVhuw6TDolseEBCoRvsc2q+m2UPMylbiigbjWFICxYAUFL2uJ1IBeEg0yyXm3NNL4cw/l
	PkUW1SoNOJZGsGJXvjFQ+km9yaVWvzeuOSaDArhWmQ9F+w+Wgg4cymURZ5z03b3fFfBBPvRPqcy
	74rTcb78kJGQBc7fTwXDF22saPmOXHcg3JK5ik+7DxuOysgomudG9CeNPlDHNTPf2GpibARo4fr
	OrBtoYWcLHwz95HewlxF6qgRlspG1zm/yHRpAlfZdPdb0CAj9f5S+XoQSg47WFYoVliQM/yGWx/
	xRU9fQw+1l/34gATQL+eR03oHOz6Of4jGSmYKsY4ZEMYQ8mSxR0eZt/ls35oSXvLNMzxhJZbGbq
	LWfTK842nDUJ37eFmbuUJ8knQyn3MiuVLXPjExJAgzMRwrS1k9w6/nSBYVaMcRGWBPc/TFt+stj
	Oy2AwLm3NxaDRsFQ+aIFJrXVpp0hy5r5h8=
X-Received: by 2002:a17:90b:53ce:b0:398:c0a2:8f8e with SMTP id 98e67ed59e1d1-398da8b6e92mr295447a91.26.1788066854435;
        Sat, 29 Aug 2026 22:14:14 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:14 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 5/6] mm/damon/sysfs: support aging_flush
Date: Sat, 29 Aug 2026 22:14:06 -0700
Message-ID: <20260830051407.50008-6-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: <20260830051407.50008-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n4fnf1fpt5jku9n63wqq3n7miq1j6bxr
X-Rspamd-Queue-Id: 9F4D1C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788066855-198518
X-HE-Meta: U2FsdGVkX1/SwV+pX+tMgUA6RURPLU6fmTGATcoEJKEssKhtHmv5ClEJffUG/dwsMkqEKDpl6SlnRZzI/4JXVIPxsA3ZPMPk+vcJh6aGWy3wuqzHLPCdw1GrcY78xDhuXjtyYqaL9KFD8Dr761QOMzmISsgmNao8VjqdV/LSGEHRq3fv+TvxBtGCFw2mipjc3xVudi/ILzivDWGh0/AzcdOH0EqHz4GryApgFBfiKCpvGEkoqmn10HBHGLYX1EXa0KYe0+erbF4ARTtCTLMtEwROADlIRhEwdXqFoJ2Twqc3jPohDAGcIgy78ueYuCnPndXtU9LHmWMv9Ri/Du4cb+tTlngnYS+nvFybCp88SgMmlvQIOUGxPt8H2DCFRelZBiET20kqG/X4O36ez3CFuSuYDjFswzCZ3Pud6rKHVOb514w15EBlbVKCdxu9vsElTcK4buKRk6Na9pdjrsOj7iH8kBWZsdfPz83k58Gk3+CeQrHBEholzXKKJdOv518ECVcIAETUEBZgL6ABJTsAzL029fZ/m+5gcQE4HSG0bS0pjId9fW0iKKBBh/ARQfDBMjnJUODbs/icsZofUuReGRSClc043q3+D+Y9rPaydik95ysdAYyncjzSh2r5Zt/xFRa+5znjO7peRnRyOs7u3jc9T8DIR373HE4paOOSAARMAqFLbknOF/rStRwcKc+62HxECHvGo4nDrR8p0GOmca31WucAr02zNQd70El4iU5boKCrJQsT2Mw1Hj8STIWfOSxRpbZVL+gWsZLrlguzBNqMpDuE/EAQBx4uoSf1ZxvD9OHfWvp6aWXKHM2WYk1Bt6zqLuXA+wwitoWd9gQ/jZnLuqbfMifntZJmu3TKHPqwcQio9xUzygS1PoZXtqh9ETNdxluxZd7e9lpwFc5ey7mvOL135avlfo4ghjEhKyiITV83sgvyoVPslcrJAYDkiLRbqsVwzc8a1bMVSbb
 Vs4Xkjt1
 PmAW+AYQnRwkPyuwOE9Kwl2aKqQyHfEqOgNCkOwmw8ksqMsoq85K4420j4y34xxObh6YR0tQup8bgM8EEzx+/DilSpsx+u74cyxT/N9yjEQuc4/SNhUjpRf77z4CW4qL5KdatMFO6NFx+QKGQJ7OW1JnFNMiCMCXD0+sbH+uV4NBgqUqPAr0SyygPlu5YstTmw2lhB5mRUPoL/diXVq93z2ykXo6BeXdmVeYCh0y3KEmo0qNfK3XvYAfcnaLmGqmSX/r1doCIJxoLrO0m/CcOfzJ8cErOpmxmxtkwqRDDiWdkRabYk3m+yzNyPGcclP57bZqKB4TbO/S+tqR5Rtp12BANSfkgB1lVQwpv1dpDC8zvRJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose the aging_flush monitoring context option via a DAMON sysfs
context file of the same name, next to addr_unit.  Accepts boolean
strings (kstrtobool); defaults to N (current behavior).

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/sysfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b2..c8bc9cfbe4cf 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1403,6 +1403,7 @@ struct damon_sysfs_context {
 	struct kobject kobj;
 	enum damon_ops_id ops_id;
 	unsigned long addr_unit;
+	bool aging_flush;
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
@@ -1618,6 +1619,29 @@ static ssize_t pause_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
+static ssize_t aging_flush_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+
+	return sysfs_emit(buf, "%c\n", context->aging_flush ? 'Y' : 'N');
+}
+
+static ssize_t aging_flush_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+	bool input_aging_flush;
+	int err = kstrtobool(buf, &input_aging_flush);
+
+	if (err)
+		return err;
+
+	context->aging_flush = input_aging_flush;
+	return count;
+}
 
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
@@ -1636,11 +1660,15 @@ static struct kobj_attribute damon_sysfs_context_addr_unit_attr =
 static struct kobj_attribute damon_sysfs_context_pause_attr =
 		__ATTR_RW_MODE(pause, 0600);
 
+static struct kobj_attribute damon_sysfs_context_aging_flush_attr =
+		__ATTR_RW_MODE(aging_flush, 0600);
+
 static struct attribute *damon_sysfs_context_attrs[] = {
 	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
 	&damon_sysfs_context_addr_unit_attr.attr,
 	&damon_sysfs_context_pause_attr.attr,
+	&damon_sysfs_context_aging_flush_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
@@ -2102,6 +2130,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	if (err)
 		return err;
 	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
+	ctx->aging_flush = READ_ONCE(sys_ctx->aging_flush);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
-- 
2.54.0


