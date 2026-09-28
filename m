Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 366D7CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EDF6B00AD; Mon, 28 Sep 2026 13:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31D46B00AE; Mon, 28 Sep 2026 13:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD27C6B00AF; Mon, 28 Sep 2026 13:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEE6F6B00AD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4081BC0299
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:00 +0000 (UTC)
X-FDA: 85263889200.05.4457E1E
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8131840005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ue/mZHah";
	spf=pass (imf12.hostedemail.com: domain of 35Ka6aggKCHkpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=35Ka6aggKCHkpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/9CJBbG35x+y3Ddsn+TP4ZxkCLdkVf/5InNQKQpJMA=;
	b=I+D5Or8qYq5diovGC+7S5E8icbEfA5niPe3zD2ea83gIGcMVrC16Z7HBQNSCtyOMyugDe7
	64htMYOL3Ke5gbgyCCTjr754dBkLOnLJnS9lChyrHuNXavcsfq758x3PB2O4k9FgzPmifS
	he+mS5/Rr/INIuoTk6CtFHhiGs2yCqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ue/mZHah";
	spf=pass (imf12.hostedemail.com: domain of 35Ka6aggKCHkpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=35Ka6aggKCHkpjlpqXcXdlldib.Zljifkru-jjhsXZh.lod@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617318;
	b=BtUFyOWicVz627TT4J1wHk0YNoj4qZl9T2S92vPwge4Gr8xzWv7wj4WufXESHAaw9HuA4u
	M0Es3tn44C1LzwOYblxMpvjbm+cwyelJAmBh75SC+Dbq/ezy9q+S2gahx4YMRd24FYBPLu
	+lZ7gMT8AXbz4aGqJA7KDxsjCGJVbIA=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f3c0d896so1680275f8f.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617317; x=1791222117; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+/9CJBbG35x+y3Ddsn+TP4ZxkCLdkVf/5InNQKQpJMA=;
        b=Ue/mZHahHSpunZ+szYCgUHddLgyxOBQCxdqijnxSGln7+lcgHvcROoQovVFz7MtupI
         KsI5dmMLKbFIFauMPl+1toYqCyR8TEy68kLUJhSYCp8OB6U5RZcX+6WG4SUfVCy0rmAj
         Ya+PhaRVqnTbnOkU/pE1my0ncLQp07It69BXWQKj6WUG6Xi6jw8r7JMBkaTnAXKSLmu6
         S2FHQKrDwY26r8Qg4e1iojQf0EpcJoVUqR2w8awKSEjuKJexWRU7NOmM44m57qB/R16w
         Y/kuqkNIY+ZBsNTrK57dTr/xI2ClG/EU3OhojNeAzBqyzKrrOX+3H3rb8REg11nIZD7L
         nByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617317; x=1791222117;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+/9CJBbG35x+y3Ddsn+TP4ZxkCLdkVf/5InNQKQpJMA=;
        b=1hSTm1UpzsxabsMryO2lOUUTSXdgn28wVEsVtR63o3ctyIJxcAILQ34jTmPFett+au
         r13tlB8CzhbctsbTAePDf+O2s9p3oacVzxRTbxlX6wEKNObWUq6J3epJEmv5ekOc5mgo
         LYoRpV271hUJKg2IkNONtxwe3SqjNNZB+c9pkqu0tHURKM/LJgarcpYfwiOqx7sXh7ep
         guIZqd6hu3IoPtGM4ER/u4CT3dkNTS4Y5RBr4wKLCXMRFth6glnAC/pii5sPVRUAzELQ
         TIrFvsjB2SJBJgaOfWKumoODv0Njfr/bYA7zQjpAIMSQdi03o0Vx+Ddc8DixL34pG/z2
         NdNw==
X-Forwarded-Encrypted: i=1; AKwUvBz//MT0vgFHL3v79+bpL//RAvmAmvamnp9X3ksm6lj/o2gH9auO50HKifiuuLhfNbYx4rAtzn5I1Q==@kvack.org
X-Gm-Message-State: AFq9FYIchjERCjwq2xCRkzGWVZmJR5xz99padjJKlZHQaeyM0+G1KDNi
	iPmxk0xhmofPTrn3Cbk/NTO8MmuRQGG6Mx1uBnW4G8GC+rwTKA/DUVdeDGqo5PNGFXkwzudsnsl
	fcQWw5SaqW9H4hQ==
X-Received: from wrck15.prod.google.com ([2002:a5d:524f:0:b0:489:bd7b:5942])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2010:b0:488:7803:c1ef with SMTP id ffacd0b85a97d-4887db496acmr19692502f8f.48.1790617316679;
 Mon, 28 Sep 2026 10:41:56 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:15 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-9-smostafa@google.com>
Subject: [RFC PATCH 08/15] mm: kmemleak: Don't assume the kernel stack size
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8131840005
X-Rspam-User: 
X-Stat-Signature: g55qy4ed7myehzgifbhp9pnuqytqkme8
X-HE-Tag: 1790617318-773274
X-HE-Meta: U2FsdGVkX19qa257sho2CjCxdxjC8KrVkUoBpXp9RjkctAhFHMXqZTac5g8v8dIGfaJDGxvZtiqD+DHXbALFuUaFIZIxT7TVpTchV+qdJHoJq8n6Xf9P+yJs8dBre8VeQ1nk5eVwBN/z1CRZYn77LKOZ+M0AeQTgMDTr2wOGque8OsnvwBQE175gBvHHVFFursz9eH7pQY2WU7+C4XL2NJfyJE1oQoOJO3RHRadf0p2j7NNTAifsA/7raWP0c6c5s8y0VqXGEmkn+kVBgEDiUgU+hhzFFN7mmTXkYCeIGpQ0FfLy1sejOy4plrkCa2pck3Nnbvp9kH4s5MQDrTGluCZsUdDjjzRWGwqX1PR1oev8dzd7UJaFvbv6ixZRfFfg6Wo4o9rgDVCR0ZWu8frZDEEduaZUxDtDpYWsCm9NfoqmBR5cz7A0QKfMTA1oy6AIQg8kHYfRHMvp7MNvR4w00Ejc/m5Q71/j/h2OsPcRdMKGe8COSo6RYub+K1OrbUwk818UKhuNvKGXvC9UshwSjDQYukL5GXKalXp4yA5UaFsHwnEKxr4eaW6I/phOr76AGEa6RDmQoQdkfTcLfdy46Voqbvv/TsHQr2Vw3CBa1cXEjfyKJy/BVPQmCF1+XAzQioII0AVC2RV8Y3eu2tTtbj+vWcXBEXWngLL1qG8I37kDIVysGxqJ2CfVRFWechaeiJ2PmlIykufGdQI3Bri2iytPeQPUKh7N+3/ROrqOhDMUFUG1aUt01JiR1PlETr1uS429FldCz7gaL4AXQb7FnKi0fqggAdVO1oX/fAk2+8LBueB6dUR7rQG0YfEF3GF3ieYFKBaDGF8O8qQXxzV/Rmree5YlzHEW3d81oeR05Ug+wDdBLtnvEu209kWVNlSFmxTNovpZ2kCCswpq/hjw3o3osakgCeYIU4yE906KG11ylkJ7cPAjEBG7X7SdXxLYsLFkOBuZMKqhY5vSFSW
 l1SexGnl
 DbBwHmbCJ8OWaUzG0Hg4JjzGSXWDBKkZrt8m3Yh8LZCTwx68mACkcPouF3kISrQpNkYCQJrOpXzIhCJiPdzbcLqQM1Z7SJohzpIvPEBnoCCWUAQqY+v3bdsO0rKchyV6dIlqGhz0F6GrFbKVWu0wkoAgQSAtG/VGGBpHUeSBHb0G8z/lOFPB3hQmlhaG/wnvVNgLGFtYDJzDlvYgCKuCsxpg+ujUHz0eo9VBrx/kWVTS/+cycxVpRGZUgPkxBrLo8Em542xQO7ab0no2yCnShx4rAybkjSxk1cqqD4ffQrYAWXL7MMdAKPpsybtVE62h8zr9uiUUb76b2MV/ZScMFGhxRjuj0wOgORuFDNemUlHIKxue87fYOrnkXaLYvqaWbVVwQW/vMyGd02fi/QnJeoaaBE4Y5loIMkXUQXsrCmdnPStXfNymGOpJ+ZOjH9U0WmieUXzi+txI3aSvX7RQbZUxwVmPYMqXro0nv8pn6GO25ZU48StXCNQjSI2Ss+3adN+rDHjLNhh3Lox0fthyS/s72OOWOZn3Nfg2LOOHantt9xQ3UZUDwM6g2buqtMZ3RQ0azeoCG+6FMoyYvBQcJks50qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak_scan_task_stacks() assumes that the kernel stack size is
THREAD_SIZE.
The allocated kernel stack size may not be THREAD_SIZE anymore, rely
on the newly introduced helpers task_stack_{low, high}()

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8fa409a4f9fb..72e2c628a20b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1749,7 +1749,7 @@ static void kmemleak_scan_task_stacks(void)
 			void *stack = try_get_task_stack(p);
 
 			if (stack) {
-				stop = scan_block(stack, stack + THREAD_SIZE, NULL);
+				stop = scan_block(task_stack_low(p), task_stack_high(p), NULL);
 				put_task_stack(p);
 			}
 			put_task_struct(p);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


