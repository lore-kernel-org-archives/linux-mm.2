Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A816CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FE46B0095; Fri,  1 May 2026 13:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B379E6B0096; Fri,  1 May 2026 13:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE536B0098; Fri,  1 May 2026 13:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90A0A6B0095
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2301B86E70
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:42 +0000 (UTC)
X-FDA: 84719543244.08.9657508
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 437DE1A000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KHWgkHrE;
	spf=pass (imf19.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV7zz3IVCgqM4rAO8VDBmG5qW5sfO3INZmQIYnfF9qQ=;
	b=3RCa+Z1Ay/t4Tebt4IJRcv1m1k4EzhEZiKauVjbeCuHfHTsv1lY0kPost+ksPkA42V/AjS
	6cwpOOv2Bq9ES9aouZg2+86e1OLGWK7pfMM2z11XeOKMVyqsbdwE1IdXgLrsfrNKyUj6Wz
	cDY+cFQxG9/iorNh/fevaA6CCBPn4MQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KHWgkHrE;
	spf=pass (imf19.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656700; a=rsa-sha256;
	cv=none;
	b=Y/gSoXlhVDA9uRfrHFenVhnPHJuQ/HCswLsX5n28DzIVlyQiXIwqCIMW5f+yO5bcRiYzsN
	ZdP1JA8bLYJDov4w/4CDa0QwP2enjMQv9zQXoR8MEZehzzE+5YZamJ6JARvmSDPtldu4QS
	PzWE9NEpUIZ66bPMdbxKW8n9mNKKemY=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3650453fb28so276956a91.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656699; x=1778261499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KV7zz3IVCgqM4rAO8VDBmG5qW5sfO3INZmQIYnfF9qQ=;
        b=KHWgkHrEoY8TKDuBJymPMiTXrAHLMdvfqu0RtSJUAHiQra+mmnDsQ57qFSJmDkPGip
         tHZnL/THwm1EhNkm0tBNJsALYk2HSOdf6wqC79W4I3gBSWg5WazljO72LfFjl0gG/SfR
         DmxsbNdJfxfZsdJ+m99qmzB/IpOpmBlaQ3pUg45qnmYv0B49MZtQyptS6/WSnjOSpZ24
         KyEyVamL1Z3Kq9S4t0Jiyqh66Wz00VqQ+eRwkRuTLANhG4mZtsIhNrmnB1NQVi+jLV1A
         8EnAXMAUHeuVr8lz0dGUdk92gr1oIVlTuY6N2q+rb4WqxlKCH2ko+0We8F3kxygDpOeu
         FI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656699; x=1778261499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KV7zz3IVCgqM4rAO8VDBmG5qW5sfO3INZmQIYnfF9qQ=;
        b=ej9cImB/HAjKj7EBy+z+hR6Bxzoh3SafP96cow1KyliByYLtwDbz3cxf33au0j5Mih
         lEW/yWJxjWjKGEmO7GHX1ukzCnuyGHBRiQcRZb2sflH/C2sD0dOZ3M2mb5w5KIdZVdVN
         zb5ipdd+YiU665DLf3HBjb5bzON/JDj+hWv+jLbpBnMnXGSrlhPMxnMfcHasiq0GOzrF
         FlqOMkfCMcPMgWc01RMfsy/fYupwROfHaqEu+e2j8iOQapq8PEx7NoCW2I5UCZBPDID0
         B4kctKE6Y085C0crZelDLYxNiUL+bRR78uxDPhtXuyNgJ2uWuIpz1SHnD/fL9iNxPM8o
         579w==
X-Forwarded-Encrypted: i=1; AFNElJ/H3CC6RDpbH0uifOwv7T902mhujWR4Ix1NHm7c14ptqMyY1McgdpgNVL9yYmANFSgD2f2f/OPWOg==@kvack.org
X-Gm-Message-State: AOJu0YxRYzVt7lcPicTGHQ/5H+VDIZeM0xNtrMKBA8Gnv3ctAYq3vpXD
	B7RFFAgENAGv8ilvmrkVFyG5UeRWGJh42+74ljCIgNwAFNkVA29Qqcl0
X-Gm-Gg: AeBDievrOcgMUEfZfhB4v3Zi+Bemwk/DperQ02AkswzaWhf0rTQLDQxwnXQo+0rTaQJ
	jNOnvdtvC9inQfWnWwFEgYsXpHkmVnoVC6CmnmeXnBW1+U5BpH1JTF69x4ocOzFY+DF7SgD+Qkg
	jqrXtFQTHezK79aCeCr66hAotmXp+CqJsEuWYsVa4E7T3NmI2gHFWXl1n9/DZq52asliE4/yP6e
	hG1R0/RCfCYLALr9CWuU9dcE0Zgu3y6NoBFzDe1fnwAUv89vBUiC95s5yhGd5UfdZhlVNLCceZY
	Ua4zxCmuZCKWGYt793PVx83kzPsYFBeezh3L7xH5JCYpEoRWXg1dU6f6sLAdEMh/K8/etJE4GE7
	p8pYTfIo8juNE7BssIaP2nzo2aXgouB1lHZVoxT96p3cau8w0Sdyv1AwCwuX8RBnwjyAnpsD3B3
	3v7QfpR+gpQbkqfC6I2XWv+NQqOVXA1wr3sISCNQ==
X-Received: by 2002:a17:90b:1d44:b0:35b:e4d8:e21d with SMTP id 98e67ed59e1d1-3650cdd4a78mr173094a91.2.1777656699024;
        Fri, 01 May 2026 10:31:39 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:38 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] liveupdate: validate restored LUO file set metadata
Date: Sat,  2 May 2026 01:30:52 +0800
Message-ID: <20260501173053.73116-5-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kzob8ptwcy455u7wiq3kz6nhwkmm73q9
X-Rspamd-Queue-Id: 437DE1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777656699-796425
X-HE-Meta: U2FsdGVkX187WCgi1rP0PfYRDOZPIaG26qVLAb19WyNoco7aQ9gU6z98EUVozz5X7mwGuVyVvyI0iWlQjZX/UAEwoTccwUVsLozbTUJeR0jw85CfUvrieuRPoelP5Oas9dXhTOC9JxhnB7XZTNYNN97kReQPgiwqLeXR68n4lN6oRALwEk7apVNF8Jmc+yKsmhTkTovKoa4JvvXjVNJnEVGCcukScmkpqc5438K3QbRtS7A7DHMOufgv3XoYEvLvGZB16f4lIYa+7LJHFKObUwm+fM/3VlU1olAAUc5IP5cTRgLh4zqN66MwOZY2kiIMIri0+0u6l1Sjtkiz/CEzGAzKpeHW11I+SEyzpXxndsiC8AKCwmtM8j4MOYy/4Y4KHbF7nB0Ve1EHiwCoaB83TByzChYoQ71wPNuav3Hiq0TbixeNNeaIZsiC4LidXWwXUUZ02gX7j5N7Tz8EP3lSUvY7Tdz3i3bG4l7NQ65T1S2L0ephfhesFGsf9OFBtZbyjac9qQydJz7IrZ1qAAXym9FsuU3cEo6FwojT2hqUyy2jjBciaUFcKRLhuGrykQ2CTU6S5CyIkwFbgnr/1ufuJ7I5gdFrrcTiKIqYbVouXNqSeATOYEXjnvi4OkhplQOkKvTKVzhKN16hV6iOx+W34i1JLZE4SInd5gzY3LVUzKMyh/BTWWnYjzHvf+KCChEmPYb4v5wUEJC3y+baAQcRQmqMwk9feJJt7gdMwioig3ZzhetkBfdr/cys3Oji6EjiV5VVZqp5wgLoEAhD4E1PxeQA7httQ5uIdeHRTZr5QMYJ5PbRQ7JdovGp0b23qnAO9pm6azHKe2iq2mu7eOexQ8bGVaMKJVY2jBqBcuDQpFlQelB0mCcYuEALmJ7HQz/TSLMYkoUcGasEl0hr4PZ94VXBdPS1afAhtbk3JRB9dd546qQDdAXzHjMt/QvY3azV4MxPjb/OrB9YastQJz+
 dNc1lU6m
 wK9FgL8YNZhpyQnZIk3Vxxv+gWu0r0IBIF8MxhuUTk41LfgE8IPCtcd3KPfa4isgztHTtlJlXgcEI2DiYufHYnzDngBOSdABOp2X7NK40r+rLkiU6CHFzNFemOd+O+s1de/yI9UFCkRdZDmbnr4lx5O+2n9FaVWM35YiNGIHR0i3wlAT30H6CUTS546tcoJd50+LwFev9NzUmCnnnGLZNfQCVtoujaRpdd1QI0LDxJuZSM3BanU2k+wDFbOGFLevEYACwn4BhdfOzraeestsBq7hGgG6el1QyyYGFNhmH65KkhHPJQaT+RTAexh14h8urfOYLrxuHimIFw5dAsyaQ8ifMlmQ71URsthryKpw84zDgXJF/GMriWyiBv6np2K+EQTy3dZDBpB9742H9LzmEdc0lWpeFguLMi2X5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The restored session metadata provides the LUO file set address and count.
LUO maps that address with phys_to_virt() and uses the restored count to
walk the serialized file array.

Reject invalid empty file set metadata, reject counts above LUO_FILE_MAX,
and check that the physical range is KHO-preserved before mapping it.

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a0a419085e28..cde43d822f8f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -783,11 +783,21 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	struct luo_file_ser *file_ser;
 	u64 i;
 
-	if (!file_set_ser->files) {
-		WARN_ON(file_set_ser->count);
+	if (!file_set_ser->count) {
+		if (file_set_ser->files)
+			return -EINVAL;
 		return 0;
 	}
 
+	if (file_set_ser->count > LUO_FILE_MAX)
+		return -EINVAL;
+
+	if (!file_set_ser->files)
+		return -EINVAL;
+
+	if (!kho_is_preserved(file_set_ser->files, LUO_FILE_PGCNT))
+		return -EINVAL;
+
 	file_set->count = file_set_ser->count;
 	file_set->files = phys_to_virt(file_set_ser->files);
 
-- 
2.53.0


