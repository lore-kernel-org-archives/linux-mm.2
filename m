Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36F6C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E6C6B00BC; Wed,  5 Aug 2026 21:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1237E6B00BF; Wed,  5 Aug 2026 21:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014676B00C0; Wed,  5 Aug 2026 21:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930B86B00BC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A349A40623
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:44 +0000 (UTC)
X-FDA: 85069069848.07.B936765
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8029140007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZF0XqgaC;
	spf=pass (imf26.hostedemail.com: domain of 3id9zagcKCHIZoUiSQiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3id9zagcKCHIZoUiSQiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vmtnxr/CFlJueuSd4faqGngHGq0KEMm5ZYo1LjMLsQA=;
	b=VEb26y5PQogryQKK3Q5dtQPvUdyT6RD3n0ptArD26KqpSJfmDf04z2YutfosGnMldALZT7
	lNF2gvd0ktgEtUhnfIVbzYDgM7CfUYARAumszSB3QXgqIO8xPlMEnZfX9ppDuKtEXD0dZx
	RpUGVeTd01V3O2phPlH+D1LRr1PmU0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978762;
	b=uWqpZc10R9NhkAWB/bSFgE9kRvh23IbWWcbgXYaIoBSpPCYvJfu3Js9COy0fbX4HCPagAL
	U+3PPrGoR54SsnALUKNLtVaMQyMnZyMha9ZWQxcEm9iE0VQGcThibPbyob6I5WaoYZ4rUf
	nu7jP0674QAbKbdhMrHgakfM4I7SCv8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZF0XqgaC;
	spf=pass (imf26.hostedemail.com: domain of 3id9zagcKCHIZoUiSQiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3id9zagcKCHIZoUiSQiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so2257946a91.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978762; x=1786583562; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vmtnxr/CFlJueuSd4faqGngHGq0KEMm5ZYo1LjMLsQA=;
        b=ZF0XqgaCTFkxgsHjnNbiJrsLvSMNlVYFn6dypaKysS6Xms6sOpsQC+KHAgUI5P1mRS
         ADpM2W/PYCOYtz0yR1IoyQM7tE7vJ0UOTC03ZE1RVPAGgVpRoEenhVXKmqV62hfpOqp+
         BhcMXHdyHCZ47BOX/Q5wnkvjGpoLMjvJ62nw2HbjVmLTowIYjQ6paX+vQG5Lz+3dAiZp
         6AoBtVTCW6f5ENW66hJoQjdAnUPdyfWbHUakN868S7G9+0kR/iDmtD35chs0MPhVhVKn
         RDnO+9wLG60jayevv6YjQky8sw9Mjrg4fnQpyCe9singDdIOpgZ+w8fQBdXnZFytpdB4
         R/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978762; x=1786583562;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vmtnxr/CFlJueuSd4faqGngHGq0KEMm5ZYo1LjMLsQA=;
        b=IO0HMKi7kZypXF+iJQeZO2xQMebpLodS6Qr65D1EfuHHP/GMAIRAQGgqEYXZzxd9At
         weAEww1DzKjyylpjd6OwpihT98iuOw97/EO2e3L/hCm5NerVvMYfc9qBuhOIXMMAx26R
         k4xZqCEQBszhmmp40Na3maqRaWmgnjUgQrGPNeY3E2/1Ih62tN2hjz9jP1t9X0CTk/v0
         JrPppiqsFX9YX678nDezisV32WW+XlC6KhvLiEzUV4/t7dSk5LDxCfo0GxflhPKubzNu
         jqXrQPpjBTUT3uCi/TTNb1cvXM3t1Flpi/W/dW9SK91CrSlelRRVfrZqHUdr5bmDIleM
         uFXw==
X-Forwarded-Encrypted: i=1; AHgh+Rqx1vLDR8wIOPzcq6fRU1sZAwjzlHYsD00iclwgf366XLvaAczgMbNRQeH/wMUm3gfeli5IHwMpfA==@kvack.org
X-Gm-Message-State: AOJu0Yzyb/QFbOgWzfE0y2FDAflh7+V0QiplGUpkJ9gK3IdL2zxhYhQy
	NN1ANG++0BRxgg76On1DQkrUbtHYw0GY7Nh2ucJBZrOYkLDcQlLNH43ecIx52W+Yq7enjLFGtsm
	KbVqn+gRoTg==
X-Received: from dybde36.prod.google.com ([2002:a05:7300:ae24:b0:311:4e0a:d4e1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3847:b0:38e:b400:a860
 with SMTP id 98e67ed59e1d1-3903c5a7285mr9799538a91.13.1785978761582; Wed, 05
 Aug 2026 18:12:41 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:11 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-11-jyescas@google.com>
Subject: [RFC PATCH v2 10/16] mm: Set the selected zone in gfp_t flags
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8029140007
X-Stat-Signature: df4r7g86gq7mjopu5k67szq3gfq4fusb
X-Rspam-User: 
X-HE-Tag: 1785978762-12543
X-HE-Meta: U2FsdGVkX18Z4uRTcg0QsCQJndSEvEAORX15GsQpq9N5YFqRqc/KFHAgK8e+pQWj9sE1G3T8MhkLU3TKYk/ZN73r+ck+vTtsEXUXlOxcNS/Ayn86V6VQDxFWekj1IjkwtdeDURed4in+lNJ0V3StkeyY4m0ztlAA0YaWwQJ//hR+mAVa3wAfWxSU07VnB4OIe57uHhWquuCyEdV3UKh77mJWuzO0JhqyWURvVlWJioE//sujtO9fKciPr17EoUvcMQtQeB0ssJufKTt7xJpk4/CejkUASPmao4DJ1clvfapWTrHKg0YJFhfI5eeiYGimzJ+u1Gd2KJqYNEDGuo8AV+PnClmWN/H3vMdNe4yN01Vqa4NSPOzL6/KryedKR386XgBGp0dt8nSWKBTA76/IRhZGzE6xiYsrPrwSzG9e320vatW9MwOPmJcIFGakn6Z6bUgvq58iyGsm/x9/ESFfKXx1D37FZCtnGra4VPy8zi4rx4y6Xm/KXc/maNPjtRMDdd2dWqbE4ta4lMpwtEo/MRUy/SjSgSU6QC9RnkQvBy/xUn3g5U50IqnaE0foy5qvIGqmnbsxnvaKjRyP0wPxIdkemU9QkkqzaOFILkhu8mO18jmTiRSLqd/nfW8Bwd3GfzAUKpD+a50tI7P8GzAY1AKUpMkQOdLqu1s6XlkbuHWgpG3+N4MEGM9TEq0IAx4F1arTxx+f7LydGi1x9J0XCMQ4X/KFdpkBiWa5RXPBiW2C5PqhtdxoJDIMoBDaNISxLM1XdeMiimakRb66RfJMlgODJ/opdNJ++FjKvjhBILNpnb2TKQIE1Zq+JshmJhoou+Kj3A02L+TRz7MIfVwc/8YaTV9Fu1KITzsCtHnFvbdGjzyD4uo7Ik0EarOM53UmAcG6r8OLAtF+JaMM8s3FYhuRidSCoJustYGhDEKq/T7falfO+xtI5BLW4TZ1zQ5sLtDMboezWc06FwndfwB
 JOL/wg/h
 9qAPupCYqeCQRGfgIz/aDw3BVYIXWrnvjVMEXvCquOcsVmUsh7lFcbMI93d6/YAniQoVaBDpzL0DxHXqYsvnWri/WELa0MThkx98XVN8ygdtCI76EE+csmRGTnDuqPT7pPvu/R7izxXh0Qc43LTJfXwcl7dU7BMsL4zswpz9E32ip/usQFU6WQ8t5ONYTVS/H/vAUUOFaleI5agh8YEMa9sueFs/7uGqWWtqeTFtl+Yi5nTAWANJhWAAYv0aXXYTPDpwz8HqCHI+15ZBkzmdmpDjmMMT4+Qe3RzZ1iLGN/Yd8HIA7Yx6NQ4rULWfyvpercnCk34gL5RzdcaBqj8AvdvLUvxX1CX42fbyRy7dkqMdUBGXsZyKh/bPweTHFjmogQ49lJCfjLx2lv5iIFXJJ1FJF7gHXxYfMp4dSjHCLvYTdkLozL0zaZpSQH/L5E8Z5WGdqIaZWKClNt3Et0ebEIwix9hlIRaR1q1AQnSz23f2Oo/dl7h53BIEXAQEqwLww3tYKg3cDr9JRuxN+RgTSUyu64GmbOdnY4gyM2F+NKV6xx+VqwkTsv6P+Dxc8HaxJtBCNf5A72t5aN5+Ceby8h0WT9DxbjAJvXiAW61B5WfHVi6Srowo/tTF9yMGsalNMKovkYHyJzTNAzSDUrhhJi4iWfJI5MBqjHQyBL0jBRn2TCNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change sets the selected zone in gfp_t flags.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Use static for the set_zone_to_alloc_from function.

 mm/page_alloc_hogger.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 9b1eaf3814e1..0e9ac43e9868 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,6 +127,34 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+static inline void set_zone_to_alloc_from(int zone_idx, gfp_t *flags_ptr)
+{
+	switch (zone_idx) {
+#ifdef CONFIG_ZONE_DMA
+	case ZONE_DMA:
+		*flags_ptr |= __GFP_DMA;
+		break;
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	case ZONE_DMA32:
+		*flags_ptr |= __GFP_DMA32;
+		break;
+#endif
+#ifdef CONFIG_HIGHMEM
+	case ZONE_HIGHMEM:
+		*flags_ptr |= __GFP_HIGHMEM;
+		break;
+#endif
+	case ZONE_MOVABLE:
+		*flags_ptr |= __GFP_MOVABLE;
+		break;
+	case ZONE_NORMAL:
+	default:
+		*flags_ptr |= 0;
+		break;
+	}
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -135,8 +163,10 @@ static struct kmem_cache *page_alloc_cache;
 static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
+	struct req_alloc *req = file->private_data;
 	unsigned long nr_pages_allocs;
 	unsigned long *allocs_ids;
+	gfp_t flags = 0;
 	int ret;
 
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
@@ -148,6 +178,8 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	if (!allocs_ids)
 		return -ENOMEM;
 
+	set_zone_to_alloc_from(req->zone_idx, &flags);
+
 	kfree(allocs_ids);
 
 	return cnt;
-- 
2.55.0.629.g250fe7f194-goog


