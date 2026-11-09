Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2530E606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tm0+83a/
Received: by kanga.kvack.org (Postfix)
	id 371C36B00EF; Mon,  9 Nov 2026 04:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323456B05B2; Mon,  9 Nov 2026 04:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211D86B05B3; Mon,  9 Nov 2026 04:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E162C6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:09:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78985A817F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:09:01 +0000 (UTC)
X-FDA: 85415006082.23.422B6AE
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6604A000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:08:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="tm0+83a/";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pKCMQsA5DnpTSt9KpKYbpxlYWXML1e9U0EpHZz4hA90=;
	b=McieQ2S3Cc/zV9Q1hw++Nt8IUWjUe1wQPW0FFOsqVTLEK9nPgTXLD7Q63ErK+VnfvJrXZi
	heFI9lXQ2JKgqg7h82RTudxClMYtQAn3nLqjoZsMs2mHAFjdi9oivSdyIPbGyy3S12B6gt
	fmnEAwD/6SvqSNsQP5X2KfwbPOI7I2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215339;
	b=4qrhFgeTiuE0kU+Blh4m3emeXMY8u6HNJpiQfrdbWAf8PcbF58pZofaiM6XBA6OtR7Dh7c
	gxd5XdXxTqMdaZvEV+WDntJrlPe+MRHEGUn4gVKY1L8+ziZcrlKK8UV/e9zRUm5lgqp+gN
	dZo4odrPNUhQW0yr1TZeot/jJ15i4ao=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="tm0+83a/";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd3310348d2so288485a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794215338; x=1794820138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pKCMQsA5DnpTSt9KpKYbpxlYWXML1e9U0EpHZz4hA90=;
        b=tm0+83a/VL6Jw/MfJgb4RljFe3JFJUCp0uU+IJ8p9ui+dkj+hqjSxvVr4R0elz6r8T
         tnTCvHYbg2hDiOCEXBjW4Sy5hFiQTsUuP6adH/K7M/RZ2PmCwUM4CppZhh8/KwpgLvy9
         zuiDDFdBCGDfiF5R3uLMHHIAT6UIMF/eM2qXXfBu+eR2RnZsvyfH781aHD+0GQ1EdycA
         pTgr3ip0hHerogtGw2sToptTehv3uQSWtMlUWSioqqtj04rW+nTB8W6Rpuup+pMju9jE
         AorDr0Sd6/XBqZxMHk/jW5snAou5g6OqnnbAtLytAz62uS0whZAzWIbgcTpUukuPeWKI
         fGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794215338; x=1794820138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pKCMQsA5DnpTSt9KpKYbpxlYWXML1e9U0EpHZz4hA90=;
        b=M/AaWsea2JkSZfE713amTAcg05anXsyV0wHEsSZjW7gsbvf1BeJj+1hwZXeK+naLom
         PrOhBO8dxZbii6rKLZ7RlOnkWy9WkxOzIDf8CAm3+bLvQs5H94jQCx4lD/BDoCkZBgvY
         z7oWkQVrJXzLHw5aN38eh/B856+HTwn+eAZWDXPGqldsJbXWnLjVUgvRTZ/4NBGW6DA/
         NKpD8BmD8UcaNul7bVZCgl/ros1Z95/vubxD1qKV1uMtUuozpsJlCBctXufug1NTY1PC
         YbLjixdP9J7wXF1iqHt5/xUEFQGQEynViAYVrH83yS/rndSbqIg86o6jtzU5bGYq9zMY
         Pszg==
X-Forwarded-Encrypted: i=1; AL+hErE1EoHg8bJsNAWoEUa+2JBiMjqcO9Mr7csI2JvRttK5F8AaKwOdkOSh9F5UK6GP19EEPxXUlqxF8A==@kvack.org
X-Gm-Message-State: APuU4Z8OqI29rEFQoPAP/1Pz0BJGeUI2pUgaRBpP3biute0p2nY0Wj+d
	AoQBGIgxhtVDmTAclOU22nWapYWo/1RkDyvHgGi4vmkx+DhSSM5HuDj1
X-Gm-Gg: AYBFou0ygFKY057GjNzcMdCQ0y/H7jDxeOq7ALYrlSWcYDdvTVOr+h8bgqQyRRO5KEa
	ER6MDttR/Y0/+QYGYO6HuKYARNtfY/NUw4m2KGE48bvBsx5UgUK1qrXcRVudtphZibvCJnkgLU7
	oEeX2vIXjKb4f2XvmaWMb+EKxoWTedcd/h6KdNG/NppUwfW7oPY3gcOfHVdPVV6eeviMqFeWo9p
	6D3nqjtrRnGmuzy0WyGqDpdlQX26al54eECX6tWzoue6NOzVoO4uyGfPxLVHDGMIokk4SUdNeAt
	CCWQLu7sERmOqldTjNLTRQVcEmnOXoogkHXzAT9SNcz1h7m8DF3/boNIgxCfQybQk83v1C4espm
	Ty8sNa5xlnpIAU//i4uaadom8jGmk36beQtrVbAa6BSlFDU0NPFbucSrYZMAWgpQjcIrsxg7Lyo
	/kb7qAuhYpGYYjvvfhbYtPr3F1CPymmHdK+hMofoCnVT4OsHJ9QWiNIhG0SjCNYiCWdjY0C7vIp
	sLASpqvVHns3sa9weTGpoiLMs+OwsBY+epeP1AGasxfD8iza2rrJCVGRXtaHOvZmqj+uJ8gzLog
	ZCRC2SKHOKYrKXD6w5EEnlSJ+xI6oBhc6PRxobgnfS47rbgPxD3TJ8dYtWdwyNA=
X-Received: by 2002:a17:90b:1e47:b0:3ac:a6a5:5757 with SMTP id 98e67ed59e1d1-3b12d3fc296mr2297733a91.11.1794215338255;
        Mon, 09 Nov 2026 01:08:58 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b12790befasm6031438a91.13.2026.11.09.01.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:08:56 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org,
	fengwei.yin@intel.com
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/migrate: fix mlock state loss when migrating PTE-mapped large folios
Date: Mon,  9 Nov 2026 17:08:46 +0800
Message-ID: <20261109090846.1068409-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6604A000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: swn3t9jz5iu63j76yajkd68nixyeree5
X-Rspam-User: 
X-HE-Tag: 1794215339-587173
X-HE-Meta: U2FsdGVkX1/W6sPtszVzu/UsVa5gu1P5LBSb215YZkE4+zv7BAV9kkW4gofMuWaZr9xGEGKpfOTKdRzi99maEvSKPJe45dyJC1Vpv8L/LJMhzwedoI0bM7n5twB+XzQJ2z5dI4GXurBUwLHrk5EYDbz+s0tkJyWqg3e9wq6ITswzlOaFnS3WgWD5QOxPY7ExeNKJBaqREY6GCtUT5yyPdY9JiVAotei32FGH8D+FVMri2qwoNo8hXEorL3sN4s5dwS5wsTeKXeqfi9VIdhdAvp1adLwA4dQ4OnTvHZuv8ZOi1pfKZcuLLQk586Y4FMd8VPQEM7akvbUmNNWbDM9qvxTfr2DSt/xCs7tSvbpnaoWWyiy6Mno2CSZ8ldEbyAfvj2fBiNduda0K3pkNbRLkAIhBYHFWB1oVLVzBAVUJyO/14Yu1QY5KO9u6/IxLxa2itJayExKsnwsiG7VKMSvTcN8fXqEl5fz06gqYbMkC9uXwxZLNox0bbzUV4g/llEUIPClFhXA49ur+AFN4xVVeUgA9He01NcqebIcHt2naa4spTprFM41OoSK0GPYEB95YbuvfNHV/eBBVWU8AojNdqwjA8YKQTSVHlTc1SwxdzSlPst3v27rdLN5JndP+G2E8W20CB8X7gETUfrPBgLoQ/VgXC6l+c5P22Y67tI2h9juXRaWXbWm8Ik3pgTCDVk3EkUI/dVniv/yry16XwzAQXLgnNkSxwiBvV8/j7iHGvIJfCUjvAjIiwFX+N3tN0zyhLXrpHUihJR/Ki3V0ueCb7qe0d3kE69M5RGmQNUW3adCIfCGkYUIujhEGgiLN2q8DCLHvl1M8rkFvCVBQYx6xykhOPQZd0WSEuTdDfS9+SBhnwd4J7SvEiwVp8FaFcOiI7WNbDBunwH0puHDKDQJiFKGjSoGE0O86lg+Q5OFeEIVhIpGp7ft0WL9ketU2b3rECUfTJIjaACkaVrHdYf0
 +Oclg2t3
 lYVqOifhe1RwCSxtDGnxr27OpnJmkGSOx1H9wmGip1ESYW0zYhKvmBEwZLBD9uAhcljKVQSyAccMtzG+rMjOUEGNSn8JojQysHF+QYTo6jlMbOX+eRNGyGVBF7asvuinzIpVH6f0wRcvlxbnKx/5zeSfIYRGw2M8J5vocbqUOzdF+LU8WwUkw3ncZdBeYB5vMaHJUXwdc3nI2VY9Wc6sWGUmous4TVnAjWawDR6IjxeR4/obMghqfVe/YIf4lOczog+ay4V49C9Q64wco6mG5xmM671Q9j6ikDIs7gSk6yFb7bmwD5MV2JiIwTqi1tWtMQNF9oldpUfje9IiIDC0NAz5s9CfaCKIPo0jaPEMemhxYeIKyzl5apyEF7ubcZTf2OpaViDX7oHsZNeAIYTI/tuYCOYxQ6DNVuFwLjmzVoL4PtMNCsAdp1BSZjTkxv8pX/SQ3s+w5dbpNBjbveGH5JOWo5MAJfb2oTAlR5VLB/KE4RFbkmoOfJI2LTlfUNjQb/XZGUbBE5rzg/T86iqKgjrrGsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

try_to_migrate() clears PG_mlocked when unmapping the source folio.
For PTE-mapped large folios, remove_migration_pte() restores one PTE at
a time, but the rmap helpers only restore mlock for full-folio mappings.
This leaves the destination PTE-mapped large folio without PG_mlocked.

Restore mlock once all PTEs of the destination folio are restored under
a single page table lock.

Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/migrate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 94033c222e04..140e291d4587 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
 {
 	struct rmap_walk_arg *rmap_walk_arg = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	unsigned long nr_ptes = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
@@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
 			else
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+
+			nr_ptes++;
 		}
-		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
+		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
+			if (folio_test_large(folio) &&
+			    nr_ptes == folio_nr_pages(folio) &&
+			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
+				mlock_vma_folio(folio, vma);
 			mlock_drain_local();
+		}
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
-- 
2.43.0


