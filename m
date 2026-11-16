Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE417606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=HiKRQAgo
Received: by kanga.kvack.org (Postfix)
	id 6056B6B05B5; Mon, 16 Nov 2026 03:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD166B05B6; Mon, 16 Nov 2026 03:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3346B05B7; Mon, 16 Nov 2026 03:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 267386B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B261D120568
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:21 +0000 (UTC)
X-FDA: 85440269922.27.3F6A966
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id BC66D20003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=HiKRQAgo;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgVoS+4faU3bxp5jftE1mXkf/VtghCyzl7UmbElyWsY=;
	b=bQGjlAc99IbyJ5sGPX/gSS/fB3usNUkmf9mCpb9rSKhntorJW0b5FEVX7GE+dOWX+Hu1D0
	+/1iahBYc+xcAgNy19tYOMlfmIR4An6CQwiJkpkzRCb8LETCrJo2ncdeOyYRojmbmz/ttL
	BQEQdvjAL1f/XYrWUY7/vKuEVH5NUh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816860;
	b=wxYoO3qPC51XE9XwEWt0hPXFs91CG1Nh0lVOiv7g7mlkIqeTDoio9xKZZuOF6h8ExPmYMT
	4OiB/hfdCJmbaq6nNwSM5WWlwjExqX/mSRXWKNHncqDupXM4bDTuCVyu/bRem7bAM1fvdt
	cjcbWScvebihZ1d0C0Y5tonRiiYy9SE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=HiKRQAgo;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-497614c95f0so1394943f8f.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816858; x=1795421658; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rgVoS+4faU3bxp5jftE1mXkf/VtghCyzl7UmbElyWsY=;
        b=HiKRQAgoSOjTYL/3roJaChS0TlbIzKCJNY6natTzMDTXAond25tJeKCsokPDgvHz7R
         +QS2KHg6TJs7HRV9dpEEBE4JFQkI+lDER7Tr6DSlqbxb0Cr5opVkkbyUo/CvWN0EZI9d
         tLekGwLUtsgyBL2H8Ay8c3MMUniE26CRQuAlMK9qe5sjK8B3sKYZXye+UDEdft90ftZ5
         m9y6Ij+DgyGmHLKIS6rJXhrCshRI01V8gHfMZ4brM+8aaiqs3nCGErXKu5Xlcn6QpYFi
         A8eGJqkFRGCQ9VaWJWLnycWqKuy2cMlafTOw3OSmU3XjO3VzZZ51pp24KBwEJapwh6+k
         Z8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816858; x=1795421658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rgVoS+4faU3bxp5jftE1mXkf/VtghCyzl7UmbElyWsY=;
        b=rwixQB0UG48wnYNWuSWKLfJxbQ6HqHms7jEYk6bP9Jm9o/3JAns16SZ64lPuQ8HF/j
         JlfqGxmQqkTtbpihvtqoMBjlFNnZmbXMQEgYNsSlgoHXDOR8FB1VS3SO+U5gxx5UiARh
         YjwH95MK20FtiJCPTdHWjEpwfNWseqlIg6cGs/8t2OWm9G1hg/GsAMXUMHyUPmR0+IFh
         LngNKgG+LE21W5mzAJnQCCPwhqvG54zRgnlmKFcnxSbD9aXqaND6Rlr+63Tj501XVtgx
         ukg5bnNGYvXpkJ76PpQObnzuj3yPE0XmXWtSiiZ3nZ8Q32XhDrpFS7/lvs3b7inR0+CX
         ViUA==
X-Forwarded-Encrypted: i=1; AL+hErFKTfh5No3w5LuVISXly8+5VRWnAriZ5S/fDGsjgo2qZwCZsEq+dd/HmGM0Axxj5UbRjkiIjARU0g==@kvack.org
X-Gm-Message-State: APuU4Z/HUbWQRlGICBnPqPK0AWBboM/UtqM3i0xwyDkMWRCVbCPpM2lx
	2xnEn+QLV2MoBthUjxpD8LR0hLP5kFWCSKstbq5+2R0dM8ROwElasv2ck03yjGOeWiY=
X-Gm-Gg: AYBFou3uugJFBipbfknRXuoi8pkca4O9yzs35bF4wjxUKJSdxfvOQCzFBssDRjP1Nmj
	/hnlCaQ9kTx/HL65uU2jbcMZPfY+xEqIbrzhRIC75YNpFVXBDf08Cdpn9wqg9mweTpHzi+1f8rw
	+gnjYkMIX/aHwLR55ZnC42MwjANAp7joxer5EXkdCAf+ysZ7I5yWtkT32iofi76watHjBP4rbmp
	IkYCFp2fSKBQ9D2EELhWZ/JxawHLdjsEkyk0Lhbb8A/d6RAGIjUP8CAofysdxmnEvQ9Duu9R3ZG
	FLWuovWGCuue1qyIn/uKhyMvpyzGvZgATGdQzwsMD6SZZHkgBbbd70Kx0a+5j/Xo5sDwGVlbeAt
	JCX0O9QZki9DVvJzXMd9v55imRkQ+I5DxbaqK7pshwqGEgABEDhZHLwoRRJO2Fzr8xawfmxoS7b
	rUW6B5KeHzOYuGvgZK8+7Uy5Z5LOtf7S4S8FERDMclnPi8tdR5cqv1pmePvf9uGrWJ0oKT6m/A/
	vJQDSgVI7TYktf9+6zzVpEzS44k+YhFcE+zW0Xxf8R4c+IpkSx8llVqYc2alZFZvbaGnwpBqxos
	HKscK/HHYSXBq/1coU0ajW3kqbjkzJFTT79Y4QPKoEDhS+SpIABs0o4E27Jsblq64PBAmIk5VuN
	tEErJcB/xKKwmQYVxDG+TZ4rEmujs
X-Received: by 2002:a5d:64e4:0:b0:487:6f2:1a4c with SMTP id ffacd0b85a97d-49c7381b46cmr23102640f8f.25.1794816858364;
        Mon, 16 Nov 2026 00:14:18 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:18 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 4/5] mm/mglru: avoid redundant rotations of young memcgs
Date: Mon, 16 Nov 2026 09:14:02 +0100
Message-ID: <20261116081403.216452-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116081403.216452-1-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC66D20003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: aqjfh3k4yumfqk17bnbi68igeam8zw7x
X-Rspam-User: 
X-HE-Tag: 1794816859-579819
X-HE-Meta: U2FsdGVkX184gZRzzDF0CfncGDeNOGrjFK9q4dNB5vivo5iEIUA63CN1pXE9Ij4xU4fvuCDcM+tkxqeXP9ZCdaMy1pHRJMOjhnkddVRfnY6TTNP6v9d7iB8apA1rxwYWqR+fa1IRPCiLIkjQXKv9Y2vWl/4aZNXqNLPIeSpOaKFxyJetrKWuHAC54tmnnnkYwrvLLlC1/ITs4qewezLPWKdeZ21ZVnE2cCa86F+U95O38wHEgkURYEOZ+bhx/zJhWeUOW08sN0IY0bIGfJqOvbY4PpfT41pD+6e48pjReDSuVizy8cgoXrAXn8WNLfnqPug7uslqF7uH6CzZQGlZ5/uF0Ck4iHU0uVTQNnXa+EM9ofnfLlSI38iuKGcsMhlxrSwbiCIoRSlJ1j/CNVwH2cmZDlnLTVAScjax4CBh/oCm3P856TTuHycVCFBnZ2zNONq5CZ1qlABRvqDe2jSCzRK5W/fXah1VRFhWGmr5K6O7Zb+ndeBk8ep1J5fg7acQnrENQn5YugmxN6RkuIhWyeaO9JwhjmBMa6yEHU73S7FTKAE+qQbFHdQ+ul+CThwbo33/WA7j3GgPPSSouXqwTOfThHMdFv8YVm03Y2AUGU8X2y1KNTCJSwza9zUN5Kgia+j0T3EYQ5QCyR2t+0Oo9YvZPgllN1aEn7RtiSsKTNqGB80iWEMhxOx4wTTe3aUw4JwovJg5kSuncUVtJIIS8Hb3K6uZenpfKQ5iyt6sR/6CNGSa+UncPPzkvtDcYy/UJGYBZ7eef0+HzfXG7Ac8uCrGU/UxnK8W7bpUiCh5iFNOUNFJmw++62E5UGYw23usJ2fWR6It3GKeLB/o6WCZJyr5tyfgeXGai2sQIPuS8WyE+MlXM86hWIh5D8RBa/1PpaV1i2xmRmaOayHE1BKJQse2e4pBLsZJ98y/FDWj3qYiv/ZjjPUAwdutvAoNcMA7JQF2k9HN2HK043Kr0rc
 o9unGY2r
 qxIovgyl/ckORA39wSjRXP4SaisoY1W3gBsNov2Q+TxyvQ0fOyVeKVEcysJPizkvL/zkIRhV8rDJiw6wrKD3f43XbECIMfKmCtPFeYZ+ALoepe7UEz9yy2N43Zhjo0AT7kNf73CpI4mFuruRN3HenGAmxTG/qOQZif+QokxYiJdXIhTsyCEJMiYl8iNPgPIjuzG/FRJ+Q5hj6DwD2IDBnzPfrs2L18WUzSItGl2DlicnEVs3JF0el8JBmpPn8D3+T56Ftug0iRLgSk9pmF7O8+I8KOI0u/YmgdHht/3dYmQW2+Kkw8fqlfQeutxjeizWXS31RyI2Bm6K4snk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Concurrent reclaimers can request promotion after another reclaimer
has already moved a memcg into the young generation.  Requeueing it
into a random bin again adds list mutations without advancing the
old-generation scan.

Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
default segment of the current young generation.

In my micro benchmark, this increases the request rate by 36% and
reduces the average duration of each write request by 27%.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7cfaeca9a605..6b7c9f118e18 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4472,7 +4472,6 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	int seg;
 	int old, new;
 	unsigned long flags;
-	int bin = get_random_u32_below(MEMCG_NR_BINS);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	spin_lock_irqsave(&pgdat->memcg_lru.lock, flags);
@@ -4490,11 +4489,19 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	else
 		VM_WARN_ON_ONCE(true);
 
+	if (op == MEMCG_LRU_YOUNG && old == new && lruvec->lrugen.seg == seg)
+		/*
+		 * This memcg is already in the young generation and
+		 * reshuffling it again cannot help the scan of the
+		 * old generation.
+		 */
+		goto unlock;
+
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
 	lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
-	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin);
+	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, get_random_u32_below(MEMCG_NR_BINS));
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4502,6 +4509,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
+unlock:
 	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
-- 
2.53.0


