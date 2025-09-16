Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA2ACAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2121B8E0005; Mon, 15 Sep 2025 22:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2DB8E0001; Mon, 15 Sep 2025 22:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8E68E0005; Mon, 15 Sep 2025 22:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F02E38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:21:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0C1E1407BA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:21:46 +0000 (UTC)
X-FDA: 83893512612.03.333EFAC
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id E322A100009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:21:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IEfD72aY;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757989305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xX3fr/WuQNiabPxcBLd8/BQm5Vptb58LpB7WQPRtiGI=;
	b=kDoNemJYcddkBXVRrGjiUD/a6je5vgi/RlwNBO17U74Fbzw7wVBe0L6Pg0tNVcAW5oy+Ky
	jfn2wUxuquA51sWSw3hqQmQ2N/vt1GWzWHUZ4tVCjr1BIAGrR4mfXYy4+31ekgSbbzmlcl
	GcY1/BENpE2pS1BLbRyEEAK/WuHdZcs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IEfD72aY;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757989305; a=rsa-sha256;
	cv=none;
	b=EVTaciau6aUsfD5HiaUJ+LwGaYgsuz3l+Xz2NmBBR/EEjztaaF8SsOkI1AIw9UhFIHITZi
	ujoWyw8iRUIQYSMt9YLzCgnKCEgcfGCPOYuDhYIH69G9d+0YZMy0FBEHwGVaYslC1AEDy7
	YpiEes/xzAhaUoyPnqDiWmR7X6Rmhoc=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-772481b2329so5215730b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757989304; x=1758594104; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xX3fr/WuQNiabPxcBLd8/BQm5Vptb58LpB7WQPRtiGI=;
        b=IEfD72aYtdOsbVmBqHTsgXBSh1NWIDQt0wL+CRawDJpSm7EouXyw79jlBq0ERlYx8g
         JlV3tpibXDEbwp6xGTA+lMS4w/PqeNMCBSVLnkn5BtWeIt6R0ESv7Z/0OfrK2JxyV7ZF
         AoUsrw8mygwijtrRmpH1nWg3kKrK8vgwd/wWy/bXBz4tRWmqV+6BHAia8S9c3/HZze+r
         YbTJt6ayuanlEV28V+94EoLzFsVhX9IXksTC4EaFbUxh0LfgTuzup1H+3GmYY5sdrZLb
         XRAQoNjoqeiDXtoc15UEMcP26jUuioaDwiCDj9u9bi+XOdBnxcNoRBGl5nfYdwUyI+dh
         wFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757989304; x=1758594104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xX3fr/WuQNiabPxcBLd8/BQm5Vptb58LpB7WQPRtiGI=;
        b=T+m8w+QTJqFahlNWl50uWQqq0y3FqYFYFi6R/frfHr/OZVcKsiNjmK3UI8IOPtwlYX
         spfnSA0IYgIQu57jurN/RZ8T04myaernxWcjqkYcZBP310vYW/C+v4dBBPhwhh+MYlgS
         jKyXkSnURtCfRnIfc9Dx5nhBA9ASIU01obXGebyBaFGNKCPGeCY7ewYvwha31MFnNBKm
         X2xiKgWeDbyiMXnjvlRWG86CpC1QFQVlMK9/CitNJeiNmgk8JRg9o67aW4lIaDSoaBmA
         U8AnGuVxmm5geffSNOwjILg/LK8/YPKZaPoUEzdozGnFv/CFOsrErsxzYJNYeWfJ7mE3
         rQPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl+NropPvQ3/6sh6WeUqIRMrSVglYSmPEELX4xpzGllHFkEra161UbGe3B2qw2464+h1X4e4rWMg==@kvack.org
X-Gm-Message-State: AOJu0Yxw/JP/BwsQv20+d1oxPEvV2kQ8pg1vAWO7qrZVaM/UBVPLxxfm
	do0G6p61KRHtBcEwQdW5guTSfJmOxMSRIvtmiPA+HpcX3rED8jJwC/9u
X-Gm-Gg: ASbGncsBwJhJTbN//Y2OZuOdnq8oVDeMF3uTWIbNsnX2/qQVam6giN+jNLRpOggoXmp
	oDOzHoKyxC+AVbOzIANR6oI/Aumio36gSzrgNezeM8s/3sgAoaaoc5Q/4noBQ8hCKvx5kUEn6lN
	/f28cSUJOOankHaf7S2AgIe62CpDxpGqxDrIbXQ8Zh1vOBYX1tswmSbVOuNGqbvbjTEQj/5n1xN
	A+9N7u5ek6+buwQsIVMbouysWeS5ide0A1ECzI6RfPQymxIo9NgmUrr8kK71zTZnfVlww21Jjqm
	rx1MQQTvyeoRaoouU57m53wqq4oVLaja2dkCyVDOJW0BtjZnNOt1Wa8Of3XjY1Sh1nH8Zgnwps5
	neWVxtd9JrHm2iz8KQfCvasjkjW2IEquLlRxnvNQHb3GNf4bUI9o+1hdeJR2xqvs=
X-Google-Smtp-Source: AGHT+IFl+gbjr4gFVXeMzo3rGVhrYRIL/xECJJeVCPQ0DdA1aYJEJmoCpFjso/oSl6iVCXG5g9ZOnQ==
X-Received: by 2002:a05:6a00:180b:b0:776:4eba:de33 with SMTP id d2e1a72fcca58-7764ebae064mr12607469b3a.14.1757989303734;
        Mon, 15 Sep 2025 19:21:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607a47601sm14429232b3a.28.2025.09.15.19.21.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Sep 2025 19:21:43 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Date: Mon, 15 Sep 2025 19:21:40 -0700
Message-Id: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5eozrbexoqbpf4ibg6zbahsp4my4pt3u
X-Rspam-User: 
X-Rspamd-Queue-Id: E322A100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757989304-385058
X-HE-Meta: U2FsdGVkX18+Mq4JSz4+9Z6v27HbeJo+QLBx+wnoiKQuO8RlyebNxc1Dw1AFnSY6RuXYP2Ta259Aeo7vJFUny/9GyMKUjNy0fkvosiDN3vt0A7vwn8N3QSd5v4fu7/zz9K5fugq/XEmxqI1pRHhh4I1udMBwBbJmFzkESTGRnXYvH/intsPkT72/o/ilbA9x/SxCxmGiugpt4mMMpYa+p0BGrLpgQN7VC70R7tdBmHBnINvL0050FgJn5wU0pJ5T/EW0EQVTWUdvv5s1EPD8FRXQLp9f5J3XVjlmNv+2MWoagG+K+v+RAmsUuqfzhUDhhxy6CmMn3BoR72w0da+Vr00W+F3Y2NkAL4UBtzY8PlRUcJFYG6ylFKh4KsUDQ4SnACSOwq/siYU7z7GK0jvqR1LiawjGXZzqIHmNurN+cKtpSelmmNNRkxtTtPN0do3Icidpc1/lF1jToaoC5N4HCD3Ujp3GZrVj3o3LSb+l9h9EjHe6P0j1Wh33Dso6b4NIcoXLv8PGvAfT3R+79Qiqao2E5Qmc4zFSNR1Ccsvw2LJzypRS6U+5wkyyJQ51rULSCcvu0ntp4ot6L5s0ZYAZjf6HRfw27gcNaX/P6n6djCjyG1FUt+CynrZmCFx+UcVqJiwvVr8gh9SM2aM/BY6FJWjK7kdvMj+hIKDvgmdgoy7YaP4zufc+viMd7Mc6QP0pgUPue2erFjpuSBlWuoW1eqQ4ER0Dw/P4KAMhS3An7XRfB9uqeq+1QHUvv+majuuOm7S2WHPEEIL32PiGNhfxFf3XjnpQ1eZmY1mSL1p04hV20IqL01L7XdK63XzSt+6dt4KaGLF3rcahR/ADE5AZf0yo4HuNcOAy+xHlCLA2rCdB+AvTYsx874P47JTapupomvggAAR+MGOiphPhVQHWf7+UwpVQBSE3yAD+C8AghqJrgIP+QoQGU5dk6ORqQiGf9XEgfoTOpcKpRYGIXiR
 pi57JPL9
 TYAxDXO2wxWQtbziClCCmil17RIpNjHT+b9Edt06OX13DvDEjWbVX7s8NA9dy1rOv2A5eMJRv1UJx1XfmlcFw73EwsBljOkb692H/g/4H8FVcTL/4oAmA8caYrMo/iPvOpNWU+s8jtz4UcoGUk5CYRKXar81WxRcD6DTpptC5/WV6T1O7NnplY69nR7sMHu2aj3CTgwbdCfpiwAqyXPokYz5tiXi10c2j6XXcDefnrX3+Yqkpypvb25OEEFqORgwRaNj5i5xqVrZLQOW5Hyuxa+mJ+R+QT6Q+RFJZ6bwBkE/lC5OjgbZ7UDE8UAuoMzTHzJ3stghX267yzFbzDGlCU4ooYIX9BH4dmE/ppj3zJIMoOim3ENV3dZrC3DtESd2YQ6LQsSaBX0zSX1duwmqtNewgtv2gcC8uYL8GnAvrMgPj02nzJO5vJuj5uTYzOVFxFi7L9qi2N1/2T6TixHsFW4rPhHOiaiG1q10kVexRmVuCMM8e/A/xmCcBAc4WwFjqeHYkg29eok8aRBezW02ojDQq7GBB56DCSDOlSa5jC9yuPH+zhrLkTcb8NgK3cFPj+MeM/6T6XoO0bmgJhjphjPafPjV0beN906ZG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Disallow kprobes in ___slab_alloc() to prevent reentrance:
kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
kprobe -> bpf -> kmalloc_nolock().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/slub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index c995f3bec69d..922d47b10c2f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -45,7 +45,7 @@
 #include <kunit/test-bug.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
-
+#include <linux/kprobes.h>
 #include <linux/debugfs.h>
 #include <trace/events/kmem.h>
 
@@ -4697,6 +4697,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	goto load_freelist;
 }
+NOKPROBE_SYMBOL(___slab_alloc);
 
 /*
  * A wrapper for ___slab_alloc() for contexts where preemption is not yet
-- 
2.47.3


