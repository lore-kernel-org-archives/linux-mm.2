Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10D8606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=natalenko.name header.i=@natalenko.name header.a=rsa-sha256 header.s=dkim-20170712 header.b=RQrvySj1
Received: by kanga.kvack.org (Postfix)
	id 0C5A06B05B5; Wed, 18 Nov 2026 06:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076F66B05B6; Wed, 18 Nov 2026 06:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE6C6B05B7; Wed, 18 Nov 2026 06:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C702E6B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:26:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C3771206D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:26:16 +0000 (UTC)
X-FDA: 85448011152.26.888A71B
Received: from prime.voidband.net (prime.voidband.net [199.247.17.104])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8AED140007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:26:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=RQrvySj1;
	dmarc=pass (policy=reject) header.from=natalenko.name;
	spf=pass (imf23.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795001175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1bUC3FF0uL5+gLdMvKTQBHgL5FzwCrsgHjlZq/9lfQM=;
	b=bizLSuLG38/ZbJ8FVQZSGRHZ9qtQGqLJTtZXjU2MK2yToW1rx0isOgwsto3V2iQc+XgfJA
	+i3NwGFMO403W41Fhq4jtjvUo6oH/eWyfRgnZnmq2zNjNa4KMtrMPx3ety1wlwGpIQfhdU
	ZRf1Fl2lnZjndzB75GkDjce6UJUWwh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795001175;
	b=mPKHxWq5XSgXxKAN1Ksml6geJiHwcfh6r43oR60YEI2yFKIwPnPKPln0232+VJ9ZizKeL2
	aJufKIIlG+DzrXUoHMJ5l5rO6dEO4K4P3urIVHrnLn+wwHxNMhdj8N+8k0raholf2c7eRE
	1FzxwRjnWLvhwSCdmcA97XV/S5jqWwA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=RQrvySj1;
	dmarc=pass (policy=reject) header.from=natalenko.name;
	spf=pass (imf23.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name
Received: from spock.kanapka.home.arpa (unknown [IPv6:2a03:a900:1010:3280:c109:c893:2bc1:6f68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by prime.voidband.net (Postfix) with ESMTPSA id 77A4A635B040;
	Wed, 18 Nov 2026 12:26:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
	s=dkim-20170712; t=1795001171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1bUC3FF0uL5+gLdMvKTQBHgL5FzwCrsgHjlZq/9lfQM=;
	b=RQrvySj1SCSuefZOh1iPvmOgevGs73R0IfXPg+8DT7TWsEQNrGv/Rlo8ACx+XW8FKWyeIU
	vj/hUD+7AGtuUTyoPvqY2yzP5d2h3dPOli4GZReJtsXak6apIPLiocGQvzWglxGVt/lnFx
	5CeI76J4Fl9OuP5FlP0wGkfMpsPrcXw=
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-mm@kvack.org
Cc: Rafael Aquini <aquini@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH] mm/swapfile: really fix integer overflow in swap_show() and swapon()
Date: Wed, 18 Nov 2026 12:26:10 +0100
Message-ID: <20261118112610.122799-1-oleksandr@natalenko.name>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ms-reactions: disallow
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8AED140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: igeib6nwebxuuu1911o93fo6a4ren6af
X-Rspam-User: 
X-HE-Tag: 1795001174-598113
X-HE-Meta: U2FsdGVkX1+m4UgR4pCgIIjuV+IZsQoPfR8gY/g/N6t4TPSRU4z+L5bko9gI+Z+QHWWEQ/CWxxudPKBl2tc8pcPUvLTfVEIobNehY4VgY6hoNesqUMciRj1YlnsM9rI+WZr0tvD9C6dWqWryNKW3wmx40fN0Y3qMqqDklP2Po7Bzpq/eQb2rOJV9MBsRR6I6PJRxQOsotJ1wSJzeg1B8/IRaIKQu5CTF2X5cYAYZDo8+yX9nXS8jSBqf36PddIZ3ITZtecIwaM92/nT+EdnWObszfcqyoF7g/ejpAjceP1ZggShXX2MFNPAHQCRI6odZSkQCFeFIvivHS5VmTCaLvyJOR6O3Qq1Dxdw+QmRG/1WlnGYSntdVOivHCCo76f4+Ah2wXsNUAqEhCi6haA3FUV2LDAK6fPkqBr6j0T1Yd8KbsxWDx4Kr66G/PR5Vb8WlThVJCZW0L5MM1vja++NKHiWft4N9Itk9UCOYv8AunEuNVavrBZeNzLTiPFhEe7eGdjiLhSPR1v4HeAoD8Zo6jYrxgHPOl/lGBkpFf0nAMqczuzeupZ1cB7lTwN6zYLjmMfvSPDCVCQbUdhjmzcZJ197M7m+y2ZWAhQmlOCCc/cpAXCcgpurFTAqiwwIG5K2DadvptSECZ+3b5s0y+u/d2W/WCqFLuagP1iOu5hj8smjHj1HGKRGHJEGRc8M6D8SobjqJg8H822xsMZOj7sQxEgkGBguWidKnOXxdSATM1n9HeZyz9Ba6YqHEFDMuwq27DyXoOHd0vC8WWDOxFDo+6lvTlboSpm3r7DauED6RNFNcLlGd9UlIN6SUGW64UGDtvhM+yf3z2ygwGwSb3n7XY5NSxn/bSYdnJgNDm79URroQlA0z8iJATfIIvI9UIJ+Q0M+LibKd6NO8lNdbZHjxF2Kg1MKKh/hOjaDPpp6o+tFqreG5Jh6pBOMIhTad83MutqK0w/wF0InaBOQx1kX
 pqoC52bN
 jK6+Ff1RdNLcJW9YcMlCVJAE3o1RoIetoJB4Fn9UR/ZNxgo3SjJkNxW4R5ZR80sxytBc52W4aMhRYBaetDEUcYShaDC0qZzCBPXskk2Oq4ete62pRZyPk6PLnHl8eCqL11yAzToPOYJDGveP/CwYcziVkv8G7XCfgwgzVXTQBPTb2UO8YuWPtgFW7WtZHy5blPKFntOeDWKnT6vKx4tqrY69OW9c+/1fmL69OALNTBjpqwnnOv+bwrHmSr95vkiRQf0oNmuQPEIsdsT6jNVqpk7pjqUjNFjLdHhnU30Xw0IjmYxpVqzq5Q12XwnV1v4Y9WY727tyJAvl2hrNPvVO3fJLyc7inI3Ohm5Ka6yjF3H5A1Px73N8vr0TCvzdx//ZbPBkUyhEIRFb0+HLZWB+4z/zvE37vxXAFSeBu96BcI6adrk0kmOCOx+oYLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One of the enterprise customers uses 6 TiB of swap, and the values
reported in /proc/swaps as well as in dmesg are still not correct.

Cast si->pages to long explicitly so that the bitshift in K() doesn't
truncate the value to 32 bits.

Also do the same in swapon() for the same reason.

Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show()")
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 626f3e9afc01e..3eadddc49a9d4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3450,7 +3450,7 @@ static int swap_show(struct seq_file *swap, void *v)
 		return 0;
 	}
 
-	bytes = K(si->pages);
+	bytes = K((unsigned long)si->pages);
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
@@ -3959,8 +3959,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
-		K(si->pages), name->name, si->prio, nr_extents,
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+		K((unsigned long)si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(si->flags & SWP_DISCARDABLE) ? "D" : "",
-- 
2.56.1


