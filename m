Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC667104C007
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F356B008A; Wed, 11 Mar 2026 06:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10636B008C; Wed, 11 Mar 2026 06:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9026B0092; Wed, 11 Mar 2026 06:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D41C6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:49:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2818A1404F0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:49:12 +0000 (UTC)
X-FDA: 84533460144.12.79E9DC1
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id 470B11C0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:49:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cGT8nIFQ;
	spf=pass (imf18.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773226150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icJ5IiXPMSMLmdnRhvkeTHga2mUYWqcZGNxqizcbQDw=;
	b=vjUVkoQEZD25bo9EDlnaN4Jan3Kx3oLe9Ypx6iGsl72Y4/+HAVLOJ+VpfBLYt2QnFmbmRE
	WaxovdzycexxhAVQSdOwC5+9AEd2oTmpXS67hxmMEAbYPtVcE+4IXKDNNHevWjDxlM9yJa
	VximjwMmZYXdXVO3xuPv5VSRT9e7CRY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cGT8nIFQ;
	spf=pass (imf18.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773226150; a=rsa-sha256;
	cv=none;
	b=crY6xhkKUpricddBMdDea2V98icqpEO2ye4BRVhggqE/qmc9wma43dczey2jVGFEW3nCbo
	obmOXOhbiW0BJ+JlVOvoC3IwE9Z4xegPYm/BPsAe6ICeP75wTl7Uy/tjfKilcgptiQfjNs
	tsrATbRVT/XS8JX1JTdgb103sZO2VJA=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so43100805e9.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773226149; x=1773830949; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icJ5IiXPMSMLmdnRhvkeTHga2mUYWqcZGNxqizcbQDw=;
        b=cGT8nIFQMgA3YTsy3ph7PZuQc5eezWCJnyMX4Tx+D6wQCxVzO+HHrxIHfHdz85IUbB
         V5M/aKuzI5S6awA4pWnyaonWzkSsIV7DUKMwFGUxbY0JnaF7kihE0rDS6nLDtuB8hXBk
         1wr7xuwB0ZmZRoVR2xXJpBoFIN8G26spfPixlBbexm8NzKlLeuTWIa2V47Gn6iQwG+cY
         idl1jPbtyjIlpgk8XBbm0rcE58NseOLXqNAHeNgtjP04b2XmxWq/LF3O7uQNfYDPVKrI
         f/HzgKETd9WnrwzYlcSOD4tJs8L9dz0kttBK0E1ZNwfsdpowdcUTUoTpzLLeFttNyudk
         ox4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773226149; x=1773830949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=icJ5IiXPMSMLmdnRhvkeTHga2mUYWqcZGNxqizcbQDw=;
        b=vZ1uvaAIQloC/mu07BO9wjDq2Fya2XxjMRQJc9rwMgHSFC84rlRiTVZV3NJmFrX6lg
         INZwNyAgLoFer1M1v52YknlaDbPPjET5sFYwG+FWQ9IQL/StNAO8OWhW8Qjo7jyyQ5Vn
         Pxx/N0yWNLax/DYhVeyS5ymZpkYF5aaJDXPGzQcD+d+MSvhc8kmF2rqv2agAAZKvU2bM
         A/jhJwjUVW0/enaLeTYDz/qMQmVYVJK7HVJEkSsd72MylzFGNxKr2SnSazPqpFBgtFnW
         DKLtW9LpWDeb0WM5IHxHQp2bZwVosj5SMx/1xictsUBeKhITTpz+BTFkBfV9jcRj4CO6
         Zq2A==
X-Forwarded-Encrypted: i=1; AJvYcCX5rKMmbrypH/kRI4wIszGo19jF/okvfnPdiQfC2ZUveVzJHgItiOyd1n5UllzGq42hICLVhLZR0A==@kvack.org
X-Gm-Message-State: AOJu0YxHaE/2ziCZmiySaR9tUPSeG6bO1zWduS5e5V3GYt+IsWfdHzHg
	rWv0TEnk//5xvMQgoOAZJmxs9ZLlItqMg05u01j8vlidjd7UWREAG19H
X-Gm-Gg: ATEYQzzQ0TmbE4VtP1hMzfDF0he06qCKalLySAx4a00NdxfZZC22GEvwqFrVG4io62p
	LwP9USJNtiKniCpoBMirvYATDjU6EBJYmD2Aa3524/O578ErjazTy7DqjA3JNll68cKdCXUjY4r
	F6vR3iOlhAvM8PbBemmt97+JUMfpOBc4GWg2DIWA7Bd4pR9t8m76KU8JjN2I20HNRfcU1mUvb1c
	pjEeV7GaunpAi8+PwQE6ZHJdLQR1q8E5UbUIWv6G8VI7QtFPaS2SBDg+og5luZGuGz8zEU9VDr/
	1kgXBATr1I4Jc59nAcDeUM6djBhNcoCl56EgV43wYpWGUJXFCtzFr/ruW7OLrLHVcIHi5RC0XjM
	7EN6+zbupauC89e5Aao1Qc/KnU7+WCq/j1Gge1NoJ0K1A4+iGYVg4MVYqYFy8xgNICbQ600BCIk
	+fZUQyxgsLYLTtI7nMF4RD2gu7LXjmIkJsQoA8+PZE0Gj109W2Zg==
X-Received: by 2002:a05:600c:a4b:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-4854b0a71f3mr37638525e9.3.1773226148617;
        Wed, 11 Mar 2026 03:49:08 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0febd2sm15459265e9.32.2026.03.11.03.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 03:49:07 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	chao@kernel.org,
	jaegeuk@kernel.org,
	jannh@google.com,
	linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	pfalcato@suse.de,
	sj1557.seo@samsung.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Date: Wed, 11 Mar 2026 18:48:55 +0800
Message-Id: <20260311104855.102050-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jigankj1uco7b1szbynxkecwh6exq65e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 470B11C0011
X-HE-Tag: 1773226150-596304
X-HE-Meta: U2FsdGVkX1+4OUreLn3s8SZg54O7ZwIlENVUg/K843bBzkN7de88aREtc4KlcSv9uNeh60tiEgsne74wbTIsnnPcGqwIVEL2FtP/zUh24hYrmRVdwEfaFjP2Zc0q0yzdOCDbIPDUKcnl7Hdpk2CE7A93Zthr0V0yMu4l3EWWkRYnuuIFcNUOQEabyJ+SdgUl4/VzDzb6CQEbcnO6SHuqso9jBtEWP+OtdGlbcStgkbRrpPYwxJPnSJEoezFZ+B1IGudAZrvcryWRHCPKUPmPbEzvAt8SHLn2JdLP8jb7FWtzENjBS6BIXbiPD/bLbx9OsAXWEkRBHWLEDs4iUFulOYEauq3oI8OhiMo5rIgKp+ufPbTs6BRO4/1sNUMVf60HWBtempYMIjBu6LtN+NioMotAmPVe5rosweRC0fMTN4h8k2Xm2Xwjigtzp2es7lUwed3slPfnrrzNZWdnGhbz59J4HSL/p0/lwuDHzG22O6RLezdUGPAGUhNUpUKbNPDao5J4jjnJohxk/SwXC2elCZvM3cKHy1mA2AzYDYismy7kj9zhFgEKe3j4iCdp1ACHZi+cbpwI1KHU6NCu0NdJiUsL9NodTsDajgwPLsMoz8vvLgkMzScgpCh+0DowVathe9MsJwndzy3fNvs4nTUyeW4AqiD5m8L8I3B/09K+LmaUmQdtObTSkKSmFOvvrIyufzlPzLMdDWaC9ACsI0bDZetVWFyrZvCJjMgSvmmlLuEIo7skhYU8mYG8DMZtwxBOcZEia10e4ph1Dv92eQSBaRZe0zRwY4TTDluA5ql6W6GhoiN18ZKLt5WgWXYWPiSZR77oOS1iigdSNgrTaDoEfPn541o+rAOTgxfUqC5aqRASOobPOeRFOZUUHxliY8Naj1RrHMrDt6KjGmeSnZ+r04hmgDmcaY+YOwgq6SZ/QQzSFwEUFsvxRGzox4pwvX8trMz2v4Vdi+CEEDtY/cB
 ZH4gjcFn
 1h+dSK4s0GvHi7in/ONBPLzkzPeZAOBUzanqslSy1JhTeV5kcL6epMQFgwSg/+8zRqNsg7Tc+adDGwPG90moBcQB8icdJJ+1o7lH/FrzsOE7jZErd3u++4kzy6mFFbEK2vpYkuK/iiKjS3ALIwwKPgeNVOxQx6DuEe3rCeEwXTUhYw7n+Rd+In5t+1/+WwBWZePwMovWG/OeAgCmcdFPtsgfuNT1drzLkLYcArVjKcGJUiqM+k6P0XCdhOgjpkJARLl7RH9aw1L9WoLVSZKbatLowx6e310l0vvneJdAM+WlYNe3IXqiU0OpZds3DJQw7LA+wPJGgRz+KX5exnYnEEZ5azLgcePii3kBiB3++vdANsSLetLbUVmKNOsBEQ2Gwa7QLpMXIOx3J/Nc5cSx/7knWSL4SOvGoPtVy/L65nWluhYWvY82s4pmDzBK2m9+VVto3C13GWa9rHc0xkUFswHMtKlbo3md4NBkSPfSLuJ3OzFXaDdmTo03tv09xYyT8cZw1e0c5BuYE4ie94cFY58rUEIDZdT5lXPdUl7UsLmXxqpGW9yvzqxzh+OemCPvG7mqXUIqPg5YYFnuQSlitkaQMiEWfU9iphriOnpzojLFgCNNCCtraBOzNrSrEdI9jj595sM8rOTHeULsnilTLs9SX+rBF21hF45BQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..73b2cfd0e123 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	if (s->flags & SLAB_KMALLOC)
 		mark_obj_codetag_empty(sheaf);
 
+	WARN_ON(sheaf->size > 0);
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);
@@ -2828,6 +2829,7 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	return 0;
 }
 
+static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf);
 
 static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 {
@@ -2837,6 +2839,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 		return NULL;
 
 	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -4623,6 +4626,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			 * we must be very low on memory so don't bother
 			 * with the barn
 			 */
+			sheaf_flush_unused(s, empty);
 			free_empty_sheaf(s, empty);
 		}
 	} else {

