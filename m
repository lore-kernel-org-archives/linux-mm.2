Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F279606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=e0+1Bdpk
Received: by kanga.kvack.org (Postfix)
	id 93AE96B05BA; Fri, 20 Nov 2026 12:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA6D6B05BB; Fri, 20 Nov 2026 12:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA1D6B05BC; Fri, 20 Nov 2026 12:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 531C06B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:51:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3CA5A0136
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:51:02 +0000 (UTC)
X-FDA: 85456238364.25.878EF0D
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76EB9C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:51:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=e0+1Bdpk;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795197060;
	b=5QzewxdUxrhrni8ucf3hu8Fu7U+zWMKToBsy0qPkx/WjXPvnQnTu2+skmDRMbJ+Kk2F+YK
	f0PKYZMe1kY+B+oybvLY5EXMkv3XGTLIw8ThCsRgsatay0D2o0yoFr+z3c99kvaXA1FZI9
	ArfcVHOMiagCinTyCslCoKrA/PtmVFs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795197060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DipSljPk/gQluW89D0glgdMIVdUQm+YSJmTIvt1HTjM=;
	b=p0Li4Y/ivrkDrVUDAZgfzaCdpMpwK7zo+F8VUFSbZQC/5qZYO65CO5DQHYY+8n/PTmJ0xO
	4pmJNlr5l91hK3rqSsjiL1VB5iKgXhippHhPi+d2SHbfPkznaQW1GbLnGuO0b3EMF9GTRG
	c/mZ5uW3k9nDgbUNJGtvTCDyXsrPjjM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=e0+1Bdpk;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795197060; x=1826733060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DipSljPk/gQluW89D0glgdMIVdUQm+YSJmTIvt1HTjM=;
  b=e0+1Bdpk+xgUbmGVsE+i3mKVMrdGc8NgaobZeI+KEZVgK2/dDwMo16dB
   kVDmLtRq0X6DlLQHOT5RviArzsXah2saGacNAwk/8mEk3AhX7KzDE4TNg
   /jS+IkbuKH+gwjRg7Z4zk836Vg2vTVAm8KfRt4ov/DLWrZXgOWp85BLPM
   DNSZfcOCCbXnZ8cVld1mXTAFub2+US588ePbMUnypMVvygGXF5JJXoVb+
   ZD9x1HwS5eyHVR79+tLug8mcKYlIknUrznLbkJzacRQ+TNUdvzuceILLt
   KqvqWMbGIoBk/WXOETLn9VhY90LdowKpaCNJp1Z7Gcgc7XZpfekj/6WQH
   A==;
X-CSE-ConnectionGUID: utKHMAkDR7ilWWev9EyxSw==
X-CSE-MsgGUID: Acm2LsZLQN29gS7KlBtfQQ==
X-IronPort-AV: E=Sophos;i="6.27,223,1787011200"; 
   d="scan'208";a="34627976"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:50:57 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:31812]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.86:2525] with esmtp (Farcaster)
 id c5d25898-83e4-45fb-8bf3-a6a1885d150f; Fri, 20 Nov 2026 17:50:56 +0000 (UTC)
X-Farcaster-Flow-ID: c5d25898-83e4-45fb-8bf3-a6a1885d150f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Fri, 20 Nov 2026 17:50:56 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Fri, 20 Nov 2026
 17:50:55 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
	<linux-mm@kvack.org>, Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina
	<jikos@kernel.org>, Luis Chamberalin <mcgrof@kernel.org>
Subject: [PATCH 6.18.y 1/2] mm/execmem: handle potential allocation errors in the maple tree
Date: Fri, 20 Nov 2026 17:49:18 +0000
Message-ID: <20261120174919.3789837-2-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261120174919.3789837-1-gyokhan@amazon.de>
References: <20261120174919.3789837-1-gyokhan@amazon.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: t99jg5tbo3ekkyx1fsnz1z63tga9bk3g
X-Rspam-User:
X-Rspamd-Queue-Id: 76EB9C0007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795197060-652445
X-HE-Meta: U2FsdGVkX19qKoEegYA3U+rf5wInbaYEPuxG94azog3fp1P6I2CqbpwGoMGUWIZzzXVqGY5xt/YiYovdpaod9m8zliA80KwfN9WszZ28Mp2TPFaXvYFFCqIE4Le0Lk8rrNQIWibjLwrVllHhuV/TDaxe81x1rS7SuRKpISzZJVjgeXaD4PA4OmdA92VeWgFzFq7cI0wcPR84gEE3hhenpaYlmmq5rEIQfgS+wodwDnCn9SF8bwq7ToMvXQTetZwH+/hhDALDkJAtACdtryBUGnGLsrg0N2Vo99zrq18Vn1vHLX/A+3hjMNhSJ5CvdJ5q+E+Vsw/rnQV/yRtXt1jIOEKxwjhAu1ZBgE0MIWNc9JJUiBRbh7gp+W3KbfC/dVw70zetQSHA/qSYAFg417wYR1voL8wT1sOjUfPg/JO94grz4jAHhr+xyhurmsIQFCzl46L6G5jL70Nt6XeyCtgaEvwmvAaTZ4NAD0zoWcsW6XUjIViSB4h72ht/TMNAuXjEczOE7w8RuwN4dC2BokrgPTaVtAr2CdokeUlXGZjXcQEsUHCso3lVagVeOcH1QFh6r5RuX2IS//0XCx7FovJhIyuuH8trm8tN+cPq///OuiFUgMJkblkucq2QI83mamybw4HNV5kboLUnAnmYACrdquug9z9JLzxXAUpsHiFDq2UDYzQavq+Sfv7ykgnL/rKtrfCqEB6/b/qrfeJAzteuvKiZCrL4KVvUsNKuJoEmtE1BtygAM2fkj4EWzABU3dBHcy/tBOq+22Na9wOe7YowiEdnkPC05QvPjeAe/1M7E99WSBHz06KFml9qf2S+kBJQHD2drrcmWdIuvHbewLlCf2yMo7UmAxukDug8hflOIR3OuetyjjZRhPkK6krGlvy6EMkmEx9JEsTahWcuDR1cslCletgWJegXIsQAKpfjmtx8D6p7NT+oh2k7NjyqOG/jXYgqIiizKyWWCe790DB
 /LAV1rO3
 hH38sBiO3XdUi6W2h3ridAr172sLanwtIlwsir5pqIHMks/0cPt86SgO1mnquAo5xFF+2iUspkMWSgV7NQjgDZi8JSTBPX5dHHTh+2mrUkMftj8JN8RYWXqD5zkgBly1Q6eoiU1BOVJGoJysLU/mYuOc54D3ulp4w8B71tKCyLTLVpHHMDwEUHQ1MJ5IHn8QF1QCHIBjnL2F2cvZ8ZC/oxH2TD6Shfu0Z30fEgz2YdgyH5zHEyMV/OKAorqzk2PjPybQUxWOTa66RnmEJh3v322VQS/k9P7c13llrsgjqesQji7FK5n6KmKevX/fjOepcN0DDpm7kVEuJosWCF5vKf2LL0HgzXzSdMBOr7VqyAILMzdl8vWSmBlA9ks3UijfmRYUukSqXX1u/IyBD1UXKEq7lfDeH6I7XgGhj9gNGpcpQYDLbMOoX214hbyI0rMqBu+4ElD/Cr5AeDv2guoz7AzkDb7t1e/GQTy129aBNFF4PUMkjrUIjnP3LMDwOA+GSq/BAQReJiWyDck+HEC/00ThV+brfwEwR34NTuCi7XURR/QHpLH41zxRYhx6hAzFqCTVE70+zWgL1XahAsYGt3Dc8G/iE6xbsv0mN8S5XGlWO+EJZj7L7mi0XeNltdKwvXOUH0bJegkeWXWIbK1hjBH+QtZjYyzX1uazWnD2LHSf1rOjX2rKQoC6XFeq8XjdV5o8RwJxpJNhImmsJebmXGWKpTDwDk+Y2zM2JbBEHRDzRPzV9xvV/9zTXlrR7ZWtB75/HEb6ZO2Er6dbhci5KvCsnYabS2mme298/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

commit d80773cedde2eb66e5702d383b5eff0190e7693d upstream.

execmem_cache_clean() and execmem_cache_alloc_locked() ignore potential
allocation failures in mas_store_gfp().

While in practice they are unlikely to happen, it's better to handle those
errors and ensure the integrity of the ROX cache.

Preallocate the maple tree nodes for the stores that must not fail and
order the maple tree updates so that there won't be any failures once a
tree has been modified.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-2-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
[ 6.18: 6.18.y still restores the direct map with execmem_set_direct_map_valid()
  in execmem_cache_clean() because 4c4b2ed5b783 ("mm/execmem: use
  VM_FLUSH_RESET_PERMS for ROX cache allocations") is absent. Keep that call
  and move it after the new mas_preallocate() check, so a preallocation
  failure leaves the chunk in the cache unchanged. ]
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---
 mm/execmem.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 9560441e57ab..cce6a2ac66b4 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -172,8 +172,16 @@ static void execmem_cache_clean(struct work_struct *work)
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			struct vm_struct *vm = find_vm_area(area);
 
+			/*
+			 * Preallocate to ensure mas_store does not fail
+			 * If there is no memory for the tree update, bail out,
+			 * next execmem_free() might be more lucky
+			 */
+			if (mas_preallocate(&mas, NULL, GFP_KERNEL))
+				break;
+
 			execmem_set_direct_map_valid(vm, true);
-			mas_store_gfp(&mas, NULL, GFP_KERNEL);
+			mas_store_prealloc(&mas, NULL);
 			vfree(area);
 		}
 	}
@@ -243,30 +251,34 @@ static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size
 	addr = mas_free.index;
 	last = mas_free.last;
 
+	mas_set_range(&mas_free, addr, addr + size - 1);
+	if (mas_preallocate(&mas_free, NULL, GFP_KERNEL))
+		return NULL;
+
 	/* insert allocated size to busy_areas at range [addr, addr + size) */
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		return NULL;
+		goto err_destroy_mas_free;
 
-	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas_free, NULL);
 	if (area_size > size) {
-		void *ptr = (void *)(addr + size);
-
 		/*
 		 * re-insert remaining free size to free_areas at range
 		 * [addr + size, last]
+		 * the range matches an existing entry, so this cannot allocate
 		 */
+		ptr = (void *)(addr + size);
 		mas_set_range(&mas_free, addr + size, last);
-		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
-		if (err) {
-			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			return NULL;
-		}
+		mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 	}
 	ptr = (void *)addr;
 
 	return ptr;
+
+err_destroy_mas_free:
+	mas_destroy(&mas_free);
+	return NULL;
 }
 
 static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
-- 
2.50.1


