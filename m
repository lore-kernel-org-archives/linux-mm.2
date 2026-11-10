Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7EB560A260C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mgnNhX6s
Received: by kanga.kvack.org (Postfix)
	id 7F82D6B05B4; Tue, 10 Nov 2026 00:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E59A6B05B5; Tue, 10 Nov 2026 00:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622836B05B6; Tue, 10 Nov 2026 00:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E13C6B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:33:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A282E1207C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:38 +0000 (UTC)
X-FDA: 85418092116.24.6ABB925
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0B07100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mgnNhX6s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3r6zyaggKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3r6zyaggKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aTCuC7RxULyLFaQmhjTRJuy/HHzKYm+TG7fBCWbd50=;
	b=PKFrUJcEIuDYjyPHmEwg5xZNcHZ7C073MOKHE15GJum1jbORgTQ0Tyj9QkgJIDhxHKqNn8
	YKOeDD4AX3qJ1PSdBtVO24NjZjFKB1sp5+8u4WeEovYjj+S1s/rlNOICkxkWfI402SIk6l
	y16hDVV4OcG8vm0R38u6eSDkSd0+J4I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mgnNhX6s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3r6zyaggKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3r6zyaggKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288817;
	b=Tqp5KgL8LXPBmQAVLyCjLH6pO6y/vW1SoCbpkZ6iTbrQzc+5kPBq2alJclkVFVQllkFCzX
	fy/EfcY4i/gsSijmhu7bGpEDcRMafE407FyFe/zXE3reG62NT94F2sHrHsMRiUijuS7a2u
	0v7yePY2SS4Gthb0W1NfNMw+nrsAipg=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd61bdc8683so869474a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794288816; x=1794893616; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2aTCuC7RxULyLFaQmhjTRJuy/HHzKYm+TG7fBCWbd50=;
        b=mgnNhX6sFhr65mGjucc9e7g1GZ+/KqHDQkbIZDRzivji5Tr+NA++0XJTMJGYnFd6Ao
         zNlb/uV1rAA+W892Fw6yW4cU2bnr2eqyi3grnfc6eIFmjMwY266EMS1NNa3aVIaO9goo
         zgrPcvX1lg6mgSUzXU35+tJP7ISuvGYbkoaCFRQ8ssvtgt89j9PWjsojSQoo5Tgb/Egk
         zOUkn/std1vcppa1A6VnMffsNoAVl7nWv/WNfSIAkgActDx+hD13YZSzMid3LjKi5r61
         FZD2BHP0oFof4oysFpJ5z0fs6gyOdWiKVrV9GlwoV6WgqIz0EpwBUnqIfN/PsailJdWO
         txlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288816; x=1794893616;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2aTCuC7RxULyLFaQmhjTRJuy/HHzKYm+TG7fBCWbd50=;
        b=mSTryV/onUsDdxxWKmimVlyg0caKnmfDLIJc5RFVIoiWoP76xQnCz/6oRdePjmVVAx
         VH89lldWZnsh/SN7+EaRKfpaZT8staASg//fAml2Xpt6otPqGq96/F7UecPJABxDTfoT
         h3ORNC7cbbw8xMT4M3VwII0JHRajkZxpjAohzJQ6W+IwRyXzbpOPGTX2sFaGqeHRNk6+
         uBrAN7EVVWKPVAmzedELpgVDqkdCdlzJZg+jru78gsUzGJQMTA1Yuenx6hDWNCzjKJDn
         XfCKFOnADAFwezlfMGz+Jo1lJ+jtP8Ugm+IndDguw6jTwBkWIrOROMxmeV7keM9tmPzv
         ILlg==
X-Forwarded-Encrypted: i=1; AL+hErHGzulJ1LIL86ZbsJkPf98kIHYzcgv3bahNbkX1KidB8/2eItN3E8nMz4r0cD/itOm4X452aMqmAA==@kvack.org
X-Gm-Message-State: APuU4Z86aA1jNMv7ct+BShUykx0IZjd2+f9UCX/1CXiHtEQ5ibn2OLgl
	3EHaiViTWhmNl7Xsa46X6XV/ulYmVexV3yKpuaFrexWEEDV0yNOEXWPDO4ZgwGfuLq6VrNXpSe5
	7WcNn5elaxCVOng==
X-Received: from pjvd7.prod.google.com ([2002:a17:90a:d987:b0:3b0:9c59:c0e2])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4cce:b0:3ab:884b:659e with SMTP id 98e67ed59e1d1-3b166ca2897mr1546981a91.9.1794288815526;
 Mon, 09 Nov 2026 21:33:35 -0800 (PST)
Date: Tue, 10 Nov 2026 05:33:29 +0000
In-Reply-To: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110053331.2708996-2-jiaqiyan@google.com>
Subject: [PATCH v7 1/3] mm/page_alloc: free_prepared_contig_range() takes fpi_t
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, vbabka@kernel.org
Cc: osalvador@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0B07100005
X-Stat-Signature: 1mkixyotah593gst5j4idcmbj1m7rmh3
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794288816-837381
X-HE-Meta: U2FsdGVkX18Un/9uzEypIo1FCiYQ3dBO32SABRjEDc/R/EC6Sl1jtprGGQm9GEYrFJU0AiyF0lFtcLr2sVXxSGVBcXqgsyQmkx0M71H1T3wqEwtWd+XyrM5C9E+IS0iQnH59q74hmZu7n0atm+VDhWcGV7bzN7CnUjNAcwpytd5V5tB46wovWf61BO/lGBwYx5j1NUJmROCEPFxWgNph3BehkkJm8ebiYx2HcYT0K7s+BkqsPL1rAD2ArClCHzZshPTCI2+E6U35/qQlM5Q5Q+1lG5Rzy19kwWnyv+sEvGrVFa3OXaxi65zhnBW917hhU9KpdaE5JmOzz50P++nqu5Flk1DBylKsvmfOq6yyNvJ8KBXJkAsom1C24v7PW+jUBSer3IkMGS7hHYqxiZf2zyvrQO5+MJWHjkF0/sZ/oEZN+CpFNSoBS+VAFd/yQ6ZVym25+vcUTrTFPrZ+by2yFs+bDZW4o9L2znivkg9JtxDqYv1ZT2nv4WCuu3am9/8D/mwv7TRXIRDj7gF4DffRX+dm0B9nEMgAQe0ubZWrJ4LLcnxEJ+Y7uZry1yQQNH4UXg6VCaT7ZEoRgdQyrGufu0q7IMMZ4j/Jhw2Np7vshcxPmnvdd2gBucz7NI72lo5W07LvfmXXf8EvBX9S+04T/Xzql9S2jdc0XzaswDdKKfJaZgionNkhRkBJSNPRBqiEJLDcXGrsgoakR23AMn3PBNx2MUSplNOimtCZ9CqUgXeCD1H/+RLAA6WdAtG4QMFij4lWEX2hWco025MMLmgSCLc6n9WLCAddE3V0HOHy12B+jiX6t4BYbyUbhxdVR1z/jUZTc3gavG/ss+hE7dFZ8f3y+uAvPAXlLndSeJRXsHBZW581zfxYMMxMZ+Rbw1JzetFncL27GFUVGlqTNy8uBSn7vVa4Kj/bc78+WNCeILiXHG7BHZz+3Hl7BDWVcYlQFcEYmUqxkx+zEWd7EEu
 aSJAImvw
 Plhrz1TMLtQAXaeudKKY7AFVZ4gxksghsWud6YEbOsEdwiTeRZB002Oq4v6pgWsUcrCsdj6I4Bkg9wJh1eEQHdaBcY47L0KA6X2CznLMaqlDiTWFB/Nxhb2LQpvmciGzApWlcbwBQTPh3ZviPCz3AkmQoevuW1zOApFk4ySISYqbA6qzoYZ5DMlbuXeDQ1/7qJSTkdfLWF4OMvmhsu6+o9X0OEURZfWyrm4ghXRSDa81qx8v29lr9+BanHLbK5Giuk5S959w6myEQ5y34S2y0FN0dLNQ0+MPPp2PoShczEbAuH2wKgZDuVizxpDtgzfHHcpCC+t27XUMRYRpJ0l7qWHD6cU+XVRLdWo/4H2yiKuMVnnmYpV8ZRR+1B1q/RtvhiV/2/1O/c+foxm3rxyt3g090I3ZgPB5sHVDHN4KlzlKne1bZTml3CsHkKYy+ArNFbKXBOLohleyCQlosguVIzeO7GWJxNNU/4TS5p8AHIyTec4jvtezPdeIztClxIVWGquQ/WTBetmve7k1KvsgHeKMK+KVxD2eeuugYsFXXmIWXQ4V2hVriZjbh4xttDt108eHzQkjeJgLBrldkDdOAYt3wpUtKOQTG3ZeXDar0AVu+qfGgFJpdYuMuMQC5USmtUgoWVCMKNxcthd0M7brOE2A5qAMEu+vSjMvHqOT8q9KAezIYINrtw5ROzf1FLcMkNZvfOqH+fxMH+hWybSk3reRgjmWmcFhtIFb3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A future commit introducing free_has_hwpoisoned() to be called within
__free_pages_prepare() will need to pass specific fpi_t flags when
freeing a contiguous range of pages. Currently,
free_prepared_contig_range() hardcodes the FPI_PREPARED flag and
does not accept any caller-provided flags.

Refactor free_prepared_contig_range() to accept an fpi_t argument.
It bitwise ORs the new argument with FPI_PREPARED when calling
into __free_frozen_pages(). Update all current invocation sites
in __free_contig_range_common() to pass FPI_NONE.

This is a preparatory commit with no functional changes.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 15ff5c1feef4..93dc29480ba1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7043,7 +7043,7 @@ void __init page_alloc_sysctl_init(void)
 }
 
 static void free_prepared_contig_range(struct page *page,
-		unsigned long nr_pages)
+		unsigned long nr_pages, fpi_t fpi_flags)
 {
 	unsigned long pfn = page_to_pfn(page);
 
@@ -7060,7 +7060,7 @@ static void free_prepared_contig_range(struct page *page,
 		 * Free the chunk as a single block. Our caller has already
 		 * called free_pages_prepare() for each order-0 page.
 		 */
-		__free_frozen_pages(page, order, FPI_PREPARED);
+		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
 
 		pfn += 1UL << order;
 		page += 1UL << order;
@@ -7097,14 +7097,14 @@ static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages
 
 		if (!can_free) {
 			if (start) {
-				free_prepared_contig_range(start, i - nr_start);
+				free_prepared_contig_range(start, i - nr_start, FPI_NONE);
 				start = NULL;
 			}
 			continue;
 		}
 
 		if (start && memdesc_section(&page->flags) != start_sec) {
-			free_prepared_contig_range(start, i - nr_start);
+			free_prepared_contig_range(start, i - nr_start, FPI_NONE);
 			start = page;
 			nr_start = i;
 			start_sec = memdesc_section(&page->flags);
@@ -7116,7 +7116,7 @@ static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages
 	}
 
 	if (start)
-		free_prepared_contig_range(start, nr_pages - nr_start);
+		free_prepared_contig_range(start, nr_pages - nr_start, FPI_NONE);
 }
 
 /**
-- 
2.56.0.506.g506a7eabc5-goog


