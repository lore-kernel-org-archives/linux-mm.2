Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D3E606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=b1EyUMTW
Received: by kanga.kvack.org (Postfix)
	id 724166B05B4; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBC56B05B5; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA806B05B6; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3086B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46A2D12099A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:24 +0000 (UTC)
X-FDA: 85401230208.21.A5577CB
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B06E120007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=b1EyUMTW;
	spf=pass (imf29.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vCe+YvOLNC00uvVy4B8RABr8/xly33k3RT4+B7Gg3U=;
	b=IaG5lldt+M2Nr1TyQMWczonWMpsWKGQbsBx0JcB6xjv2LiuFiyeglE5ImvIlTtfSGxENoN
	/9WilTA9zWeJJpJAjt85wxGZ89UAVx5z3tNWuLFxvzceNRxKgMzZ8itqJm0TkOxJMhF++C
	xO1d/os91wxIOuy2pCAC5hhPxz46F7s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=b1EyUMTW;
	spf=pass (imf29.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887342;
	b=0C/r12hsAy2tRSCg8BdnXd4n4kOk6r9rdEe4ebu+HbH5kpAFgguYo8NVdKuLwE/1kOAv/7
	Cvhg6gFeQ97xhUyLGo9ZUrqGONAy5BtmQ8DzRL4s10Xwgk7Wja0K5fh9+WFeUl+1CFqd3M
	0zfOGxkH/Ae9ya7F+4gxcIkLaNSshqc=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6798eb0d190so1589318d50.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887341; x=1794492141; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6vCe+YvOLNC00uvVy4B8RABr8/xly33k3RT4+B7Gg3U=;
        b=b1EyUMTWrmKvvBZ6RBzJScwsoWa6nHvh5ceInSNvfSRNQPpLp+oeiEestweHrRjuqe
         HliphTSjeS8b+BVQbrWGiGYhP2onZaXm0XXsMzKgjF6McIYj34R1PXlT7RdhWR1EV7Do
         3rWqutJLX5u4imu2BMwfljQzhsWB2R8mLdcMGTV8uuKDnjsnHUfmhR9qEfxm3UL/uFyk
         n2KmdNPk8JLU8BeIir7eicHXqqbyrUg6tPm7HSem67a30akwhEvOVJf5dBlOj/imxJLd
         tu0DQVTRs9YVZGfGsK2afJ6+PPqnop3mFQwA2QY9Wh1HFrtvpmpl/ealEqJ6DjNAaY4P
         whWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887341; x=1794492141;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6vCe+YvOLNC00uvVy4B8RABr8/xly33k3RT4+B7Gg3U=;
        b=zcxpZ4yklKXhAigOxSCneN0f8rijeo70+fsGGXoG3QcOuVhiIq1TNnvfpaakweODe/
         KY2oN/lTh59Rn+l3Ejz0Jp6eHIpJVmYLN/80Cy5lANxuKFbt5xnucqZ0A8LQOeSZQFHU
         dNqYosHBIe7nwOMSHjAls5U0HIr4kNv5sZGPyZc5dhlJRXJ323BJj/Wkoq3IZfF7gHQ3
         RuGgtcD0TmefNgnGJk6WjCy/2ymb6M5wcvWzJSOkjf9aMu0cPuJVFkMUO9ZG4NxmtuvM
         LvtKRHEvFyqnsSlQDcZ6gDCL5An2TD7kNiN7lKMMZBJYecNLxFNhlQb7aKA5PucbhPKJ
         FESA==
X-Forwarded-Encrypted: i=1; AKwUvBwOkLoS6pGtsQe2ve966bp9yE9rTv7iCFy2QnNKqbz5CbDqtg8nobjVdXO8x+2jXM2j6tGDGKt91g==@kvack.org
X-Gm-Message-State: APuU4Z9502I99U7TFeHZ8LLMxGBywasETjLX3e3jvIN4KwrTiYJq/Jga
	rwhJY0ghJk554ur1ckKGAlAyYBTdk7LJF4Kr6BvCg5BBK4DamS7Jx7OQaVfV1IG2dGg=
X-Gm-Gg: AYBFou2bGBNXJfQFkNwjprgHAGC0CPI/CST4UqhoXTXLpESiPXZZGLvt+ASAH4KPw7W
	4QRR+nmLsDZUvdf4P6gKdyzBLkQg2qktxHdVB/q6kn2/PwLRwj/lYgar7x4DDHc3Jr375ImPlcg
	FBCWgviJUf5AjvISq2uVoy2xkwmcf9+yewf8GC10NBxitwcH+041B3BxcryRz1FdP971HRHH44I
	4WlKVgwdYWRPcys9AuwSCNh0BIllElyx9abf/YeXqUN+ALdpj8gUL3HH3/SAbse7zzp2NTGrQCJ
	iCHgMfN+7Jj3V5EdQsuORiZuBe95NC/5eonvtKBohZ6UFKC9WqBdENwNdIsGgsy4oOZ7nMzDjmo
	GBMgTi0b6M8+bYuzn+v1ZeRnClzqCryFqKbmQsniv3IOW2oJk9CivI6hm3ysJ75DijgVHJ3oHBx
	7GqaL7QJPdIvNXJiSh+xZWqlUfIyG3pykw1La/VvMb1I3LR2WhgOJD1q0MEbXD8L6A32I8+C3ri
	QrnUIDZpDBLonyxMHbwmo24uZqrmRJGomXWokzBKvFkJF2yR34HPsZNwTE+0EjQhppccDn2GxSl
	1lmVZ3oJfvwwLN2Id8aQDS8uRJqm531JMZHh1WqBbPu9jw==
X-Received: by 2002:a05:690e:4411:b0:67b:31a:9b69 with SMTP id 956f58d0204a3-67ba4fb5888mr10595212d50.28.1793887340950;
        Thu, 05 Nov 2026 06:02:20 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee2b660esm3517872d50.21.2026.11.05.06.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:20 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 05 Nov 2026 14:02:05 +0000
Subject: [PATCH v3 3/5] mm/mremap: reaccount on unmap failure only if
 accounted
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-b4-mremap-pre-split-v3-3-f8789de76849@toxicpanda.com>
References: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
In-Reply-To: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=1326;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=W6CD3vsOvus17hxWRir0s1kYEc2onKkv1qr5upBZnK8=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QH1thsAKv1RNB7jeTB/Fkjyi+pttbDXMZD5/3AL3qSSRz5P3lByzgUsPFDszppLOzw9qacmfip4
 VlhqKXBFGCgc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: xrt3nji8o8ip4zqoise591x81w679ahe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0B06E120007
X-HE-Tag: 1793887341-185326
X-HE-Meta: U2FsdGVkX18bus1XUkEnUtWLcpSVljRUgSKdXq0f2qZJ3pZj2NbDiDxff/tEObw15iXYJKK2pWpJOqK/bmhMxLyxZqbqjC9geVmN9EotV8fUS1I2Ci80li0xQm8xlOUefFjqHq6XFB5p+GMtLY/7Q3lV4y9YLok0NnqCe6kd+8AhURhssLQ5IEaVY3A6137Of1XH1VPQ81bF2V4w3fGoa+tQRTHloJ9wu1Xv5/P80Mw/PPH8wgVa92ZCh4y+TSmcz4eoVTrGp5va7Rg/D+189XX560GHfPJBaLmXWYwAR/d8evllb+H+J4Rb8O+4F/b+M5YRP2d3BIAt8xSa2cUKDwp9baQYQPkp9n+G+9X7MqJXqyVlMUYIQGQo43SOj+Gjbr6zsJXpO0w9eUWR5+kKsCydU360S2mZWAYX91JPhq20WuhEzOPVjRfyNZMh0hwaqYdg7Lh6ZhX4JeBY7EInr8LNgw16XRig0Ix6Zcflvtkm4NTLeu6V484eQd5XmnAO9rejL0j7hesZ6w7UfoTefscnGo1VHDQZLjPJ/E5UsZfs/e3lq/iGsyVUIcT1+jCUJx3j+ynodHhgs900xQGlbJAIz/yLdnv6wMCcamfpOmca4cRmG9k1jMj4ZaWE9HqzOvzwAQLB9Tm+LBkheVvPq2HFvMmv8s2QbBhalrADjNfHBynWPXnQw2rygcFopnYoqsj4uPiEhllT0LjwNsC4n+nGDlMHCZujVeFQ8ItmcwOYTfob6JSdpUPw2FBZ4fC9jtc+CDAEZ1+GJq3/9TuYnL1FgbNRpm9Y0jRikMcKWHm0JCh68Dl2n3sHH8jY1QTuEmtE4hfbTlqp4vWxzxH4r6/JIB1z6BKTbl4z7WAjwN+wfFh11JcLAwKZ7xcj0CnkXt+9T6eNWFXrFnI4kssXjOGEbJdlHmleTSDPPRH6CGBWvItS+D20ni9PwRSDkxewSxjpSKTKWaW6DXXFLH1
 7MQw9q7E
 exU8KnWoI/Gjng7jfzVY2NXiZzNPWvwzH0bXlrlj6Y/Q9UQO77klg+wk/fGph21NHwm+KOHymzlpPlRlQDiVMHJwF4mTFCU8AIP/anbTq7s20PC8kNjmSAvOIMg1uYh9khdwI1zrTCqqNeOPa9e02pehSKI3L1epvXBpi4qrKUB9Q6HddzoeeRG/QNEgZ6NEZldh5jQNqudk9xRwN6WXRkKY+a/9Bj2vTn2vvZU8n7Vd2p0Uaee4kfuSJJMGpG/PKg0Q3DZJ/loPR4+Pn+v63LICzaNjbGghOygZZ/Zlf0ISuP2n2BcTK10WkBfYcbQU1FX6xgA9cG7KF+NMtPT/p2Owh5gfCgCa2WT2Cq6X2erAyTbNJTlE6rAKfMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the unmap of the source range fails at the end of an mremap() move,
the length of the range is charged to vm_committed_as even if the VMA was
never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. Nothing
ever uncharges these pages, so each such failure permanently inflates the
committed memory count.

This was reproduced with fault injection: each failure on a shmem mapping
left Committed_AS higher by the size of the moved range after everything
was unmapped.

Fix by charging the range again only when accountable_move is set.

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 5926ecdb31e9..71c9f335bea8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1246,7 +1246,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		vm_acct_memory(len >> PAGE_SHIFT);
+		if (accountable_move)
+			vm_acct_memory(len >> PAGE_SHIFT);
 		return;
 	}
 

-- 
2.55.0


