Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B65606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WQyNdvng
Received: by kanga.kvack.org (Postfix)
	id 580766B05D8; Fri, 13 Nov 2026 13:57:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9576B05D9; Fri, 13 Nov 2026 13:57:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382B76B05DA; Fri, 13 Nov 2026 13:57:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03D906B05D8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BF261201D0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:15 +0000 (UTC)
X-FDA: 85431003630.17.15DCE26
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3AE5A0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=WQyNdvng
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596233;
	b=Y4gmU1DR7RWZq/wE8xSAQKXhfFEMmaqvfxRHXghL94MYFenwFqbnOTZON1OKfRAmhq+CvL
	D8MLjh3nFZYnlkJyxpeiKOsI2zzRlkGAYErSsCkjw5VKZkOSQ7mEWV9c07teco1i1BELyp
	wx3h7570YEfZjEEAw78V42nyA3EuTyI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=WQyNdvng;
	spf=none (imf15.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.49) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvCJCDZ1w+NnQ3WWtAE5fKPBEjh4gdc9x1Sa5mH/xTw=;
	b=WPTgxxMqFLTxOnYLwwp0yfPZ6lg4NhSTaqsUnc2OuYOeDTB42AIto2Jrzsr4YUjrf7NVDZ
	n/uVsScD1i1VSKq41P/HlM2JRwtZUuab2pVfUsQAPAngZXPWFkN2gGaCp11euzx83y4teF
	gXHfp/FXy6z+3gDhUWlyoojNLahCKG8=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so672287f8f.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596232; x=1795201032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TvCJCDZ1w+NnQ3WWtAE5fKPBEjh4gdc9x1Sa5mH/xTw=;
        b=WQyNdvngky4tdSvoqSQrCrRZhm1L3iS8yWTtCdOA528DSCEJiwO9N3wRCmH+E82SCJ
         DIDqKGcYAhRiT9K78XRBygO7KBMCFgHA0pWcr4ZKK3ACdub5pCLBzU2BRPWso2vH1ZNu
         CzIZ+SjpzRij15bb5uAsTuUhREsij+OK018wr7Fyf8c65GcMIMRVdBth7BUFzE6RFCwu
         VjFJGYhu+hNb6U3jqEsGrjE+yYMIL6GFuVN1ZzHBZ3xWySpvOjwTcWXqAzBHcDdjOEKQ
         W95ZwS2v5IGbjR48qWNCukB3oghGlnkkAXkRCdPmxyDaRwaotym35RrccBYKAIJVLfEz
         nZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596232; x=1795201032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TvCJCDZ1w+NnQ3WWtAE5fKPBEjh4gdc9x1Sa5mH/xTw=;
        b=ovgpqZeLhJ8/Vn8wrXlCdznbdoYJWm4DzeypGsxK258fjN7D2v0dRdjZWPzmkotZVg
         H5DaV6CJpKbehu0zzJaqKweC6bbF5v3nPZkgKd8mqIBbiESwtrQ7t1jcF3Lhw1wi3IS8
         zVtgo2d5WRnizSeWQloE42ir/oaC1EYoJfeZYmMp6w3mgeJMZcqi8cKt9eah2hPgKyXg
         WV0aZZGToChIiE5BSpuPleerHi8RBJ1E1hb37cre4vkK6B45d+jG0SZoD0TA5eXUhRoz
         mH1pl/UAAPOjdHMo3qz5kMqoL/CJj1RNfUL3+RM3/Dix1CZbS1wtzxdQglrjIGQSOMJl
         U4xg==
X-Forwarded-Encrypted: i=1; AL+hErHZdshQTA/Yy1IUKExTe51HGBaJ98uAT22um4DDjgN8NECSxk96QZe6BvxOicdtU2Uo81WZOgUnjQ==@kvack.org
X-Gm-Message-State: APuU4Z9kum8jD9gSJmT9jZx9oqwv0iSGBRrF97Inc7XTK6ywVWvO2Wt9
	FPolxRH5XZRXHWDkzwj/6fOJp+3MZMhTCw2nDstDCLP+YFtGan6CTyeMYn7vVAGKAH4=
X-Gm-Gg: AYBFou22S/Mzs4JHDyVR+RU4Teu90/TkF7WtVPQh5RIXsVhbltDp5wlonsJh3YGwSRD
	jS1iCrUq+zEB5bwgGRJkEGuu/YKUgVko5XSmVpKn72aLelxZTm3sYk7EPurORHthJTPeNsqYFN3
	drqrkKQXfCXmVnR8YmUuGyzTouYRqq5txs8NecvUqSVqFs8e69i1iZuemeNqHbwqTwnwSKUA5DQ
	BSFS22zMvzDI2McnZkO4HoJRSdHciZ4Tss9iqlFGsomSw15D6YMaW3JhLHp8BgxfG7t9rcGVirc
	wn3xlYz6/G8OAbk+neBjU/MXhoA7RHNmTY3Nq/XAxdCOJRnVz4H4WisOYL2v4dRoV9xLWByFTzn
	xiTl4lmN/RlLExHgZl7icc6DQL/CqvJLq4RV7nBDamnZeWxdGFQ4ngA+iPtdpRDtwTTvghBOIzu
	4KXZx4pcS7kGx81AGzoA7lolOaLDfbdZqhp0uDMP1TB8F9jP7/LH1UCNg2dBMUgQmfnnEH1Hicw
	lBdvbNrHoFd+VIulX3knGunRRDJwJna3DCFNWu9KGJr2FNTf92zu0UcMb2ea/gH1sZ9wJps5QGn
	XQcuAbzLehQeolf3peTmFtzvMB1MMg==
X-Received: by 2002:a05:6000:228a:b0:48e:3647:c35d with SMTP id ffacd0b85a97d-49c7381ade0mr8401708f8f.21.1794596232455;
        Fri, 13 Nov 2026 10:57:12 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:11 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 04/10] mm/slub: use stack_depot_fetch_into() for owner tracking
Date: Fri, 13 Nov 2026 18:56:56 +0000
Message-ID: <20261113185702.1332171-5-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ynzyubp73dhgytfyn3xf9iq9pdu545fr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3AE5A0005
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596233-426960
X-HE-Meta: U2FsdGVkX19NKsims80lwfXdaMMpZrRuzz+JebWaYFSx1DFga88nXmDtkLdEhPzJjvqy+/xIP9uvwKnQ9Wh5ebXBSw5UqCRFL6UtVfEy7Yi7tjjJGXD+3tsQYK212jahA/Ngu3aJo6whi7DXUBhIul6ntEW+QtscBun4Ty536cDv2Sf/qQ5Um7TGXSHKhs+G9A9dSeplApsOT2YOhG+74ok4i2IXccKvX+rhqy394Fw3I/Hjn4lQjtpZdqqPlTuZ6PRrFt2XHsakrcHn5FF0ZLMnYm9C6gXPiiL480XCnRLxO2z+OmMqJtTJUmuRmgZOL09VJgdfeOqrxntAoZGfjpo962eXRbzYZMtq9C9vtQwf5gyW2rxVZFdVcjjVDlDwuhNX6biy1cMMystU2eq3hj809b+sf8m84MXwXr0Li9LRD4GR6yEqfsenpQRB7iAe07+oHcZR+6GbzGvXaHCoNL7cNBZilEZCDhzWv7Vpm1nYagwh/4n0YaGm28NCjF6e+axJoOo95PUreavn1PfpXatYzYc59S/DsPtp/oLO3sgJiu+vQpbjD2V2PP/auqHD5DIqoiv2VygN9qBvmFLF1/FT8O8eztEZrckp5HLHZNkz8eSy85wa+yyHtOZgx1WI9Kiio/sUjMUBhvCc0q3mK+6UtjLKbjaI9SYvqnM0npAdRiRc32lg7ppNqfgnkc/JHlx7tGSG1SzJJWHs1Sni/Ze+1aBoeGY+SFcmsxNAAXsplmKtClLzD/RUEAwUDluzfEKbXIaDxlqL98UBNFt4hiQydR2ln8I6DXcGVSLu/LvFqahYYH61WIxLBqcp60aFuZHVU1E/cisplhbWftY/wlvGh2DTEg+uG/h66KWr2WfgjghuKngtFG4UM33N7MypxDTiEbqwcxf8T28kKo4RqAkMYzkEuCt0+AHUAqMdPD4YsUfmXBrwiFQbh1/fqaV/K9fnRXv11rvojm7yIsP
 yC3eOro+
 clsB5/PPVKpLeLkcEh4QcJctKQUCJWwyWUp1+g26dj6lZgDBACu9FPO/0yr5QL22vIkqAGoGfWMYxBdqBDjCl89qcvQT7Ez9UoBIr8GrRm0pzeaTuKivBtCx7w5nqbn3hMDPQrAZAqVWGdI3tz98zSkFqjHdfBJDefFqoywOoB8hV9NbO8ONOO6eUu9Q6eUlOZjwVUoZEc+qSX4qtGgPue+fRYDMguW/zWPHP/uldcvZIF2j+RwWrIlACji7WktIp49AJAjbHIiPQZGAaqnp5wJ0yJ7k+s4uPpfsxEGx3Hw8iFKPDG2HVXpJ8VgU59Cuu5GRa3PUEU6/QCdIPRbpwB+EVyHgzJz+4tqzAt27EaPsWHBitfc+S2sfn3/ZwVCIuRJ2zT9Ci47gb+ns0aOd621fOz2cXp+hLzHk7fDBwvQOnk6ytMS9u1BUohM4jCZMn1pZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

SLUB owner tracking stores allocation and free stacks as persistent stack
depot handles. Compressed frames must be decompressed before use, so
__kmem_obj_info() and the alloc_traces and free_traces debugfs files
cannot use stack_depot_fetch().

Use stack_depot_fetch_into() with TRACK_ADDRS_COUNT-sized local arrays.
This matches the save-side limit. Keep the existing KS_ADDRS_COUNT copy
limit and debugfs formatting unchanged. Continue
to copy or print no frames when the fetch returns zero.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/slub.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index cd671b934719..32e6597a5c03 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8328,12 +8328,12 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 #ifdef CONFIG_STACKDEPOT
 	{
 		depot_stack_handle_t handle;
-		unsigned long *entries;
+		unsigned long entries[TRACK_ADDRS_COUNT];
 		unsigned int nr_entries;
 
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_stack[i] = (void *)entries[i];
 		}
@@ -8341,7 +8341,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 		trackp = get_track(s, objp, TRACK_FREE);
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_free_stack[i] = (void *)entries[i];
 		}
@@ -10031,12 +10031,14 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_STACKDEPOT
 		{
 			depot_stack_handle_t handle;
-			unsigned long *entries;
+			unsigned long entries[TRACK_ADDRS_COUNT];
 			unsigned int nr_entries, j;
 
 			handle = READ_ONCE(l->handle);
 			if (handle) {
-				nr_entries = stack_depot_fetch(handle, &entries);
+				nr_entries =
+					stack_depot_fetch_into(handle, entries,
+							       ARRAY_SIZE(entries));
 				seq_puts(seq, "\n");
 				for (j = 0; j < nr_entries; j++)
 					seq_printf(seq, "        %pS\n", (void *)entries[j]);
-- 
2.43.0


