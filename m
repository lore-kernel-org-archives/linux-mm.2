Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A1E60A2610
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=EwAV3QUP
Received: by kanga.kvack.org (Postfix)
	id C95C26B0312; Mon, 19 Oct 2026 13:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F576B0313; Mon, 19 Oct 2026 13:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F1A6B0314; Mon, 19 Oct 2026 13:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FECA6B0312
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:23:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FA431207CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:54 +0000 (UTC)
X-FDA: 85340048388.16.F2906F8
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5E5E3100006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EwAV3QUP;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
	b=0KYl2OrJUaL9RkFhqqUsMt6wUAYxqiQoMG3QGfUd7XboA5bug6w0MD2wxhM+WNukdfE++l
	h+QDXn6cv7BZdOhlhA5J2RSqDCv9rK6bg1FoTZIB+dsDIMSJfarS84uQdtyEn8fsa1gU3n
	M3m4iNF4OHrqq2OnuVf9/dezKti1WSo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EwAV3QUP;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430632;
	b=FGocFDFNgbfNAhMyN54mNLsvEhBU/fP6htk/ob3rDSyo4RVJ00bndCRHSYBH3IyCNbxruv
	IcoV57oDKn6jLtkN5dtCp7C1oCOYCzXW+fqJByT0eoW858giWt0katt6nK/iBMPKc92Q60
	ML0RMf0uLDxu3KmXRxjmMHfOWCVX/YE=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93cbc3ab2fdso109400885a.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430631; x=1793035431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
        b=EwAV3QUPjUwapq1ZJwiPyAtVRu5CyD8S2gRZw/JoXuxil+lg1qo73jTjXbVGEIwZu5
         N6Y8cCZMX5IpjurHIh4qdY+Ej4d7XFJ7iNDegkyFlOdY5qGjt+//RVFt5kmI4m730oGe
         80obTmPDBaGFqrT73HjD1m6+yxhvy0aPIYw6RFWdumgpJB4omYtPwGyIC0MZ70mLScV/
         WuyPmNh8RfIIf23wJ0/2rs6Ialpw7mVl7n1HMEAsIrL1C34wJiulg4CHbGoAG1/TllaX
         xunCX+mKyxvONF77u44ncK9cdC75tLCYalcBbiGlR4+HcwJBmz0fFPPVClM3Hv+H+3eh
         PgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430631; x=1793035431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
        b=BioW5obyMoPgOTks2h3vuhu1QM6B+0utqxWRarlevqq/AaoS1EHuxAQK3aThNZSIRk
         R60uwPbv3+FIVf0DEEZGmVGUZ4Mh4UHhbPj7rzHpCCr9mAEU4M8jd/xGPCzYy+Bj/9Ia
         /aL9IlcNoErDEgsrG7nXHWRd0g7dTqlrZkFJlnxlXn0jl1Oj/2WeyonySlxGZnitD4rj
         4VRsM5IzXmMG7m0VVbTRiEE3zRMYk69VIazkoYrCnoMnq0z7ZgZm55vb94houxUSBUOJ
         v2QXrs2kKXYb9VpJwoDiiOU/jz2BOjuEQ3kaj3xUEmUYmYQYmr/uTH3UwEqE2FMYUbYb
         nONQ==
X-Gm-Message-State: AFq9FYLTxEya7IEym0HVAwMIgJDWgpKLLTh4Ha1B2TyeYi30GndFjH0T
	eaNE7NoNDJmhuo9wGIpmX6rTRdI2kD4ugt0KrWSvW99h1CpYn9oAldNtlcuE99gYbbfXOqNG6n/
	sW2Qf3/g=
X-Gm-Gg: AYBFou3CNM7o4BRazd8U/Ibw7I7vTqb+5grbdCzoJhLE+IHcO8ZWNCjO03MwJxK9OjT
	1d1vtVlmjdsOOc9oLnvPaNGMohSlOY/CLlLn+rj71+af6ButJh9w7lAQ3Ruu9eJjb0SOvQRYydD
	XuTBUigmWHS+NZ8v0lR2fF1AvkxfbTlcgtIuNYEsIDamRn2OQmBfbvI2p1Xb/jCHafk9qKBCZvx
	8CpEYtp90UCZMOSIPBImDPhbOlVwP48vXV1WvCdg4TEVR9piyKjLoIwYPwngudBXf4Qcybog2lF
	if1El6GFu39WMJFSDbZtX5qwLBdHNDmFkCxUsKKbKE8KwOrJH9ZRwL07bgD1T7WQoLyXHIINDFF
	480sSzRlCyxSxkIWJrLCvV5bT4SdeGdFpyEiTgSnlyvIUS/PxqgLniK2HN4FJChqzvZ41cxE+E4
	Dt6IFpEoY5jn5OYg9qPvme8bVqmAYg7x5J/72hLay2IJP13AsdYJgWOoI3QT0Rr0X+zdcH01MBE
	n5bYNevI2K2Bh7xJBQws6nLtZfARhDRzD+85MKvhX7SN+uL+idTw+W9PDL9
X-Received: by 2002:a05:620a:1b82:b0:93f:a63:15f8 with SMTP id af79cd13be357-93f29b7fb31mr1250130185a.8.1792430631371;
        Mon, 19 Oct 2026 10:23:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:51 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Mon, 19 Oct 2026 13:23:41 -0400
Message-ID: <20261019172346.3344005-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019172346.3344005-1-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E5E3100006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j46zwii448e57wb1e3k5d8s5sdqmkwku
X-HE-Tag: 1792430632-605765
X-HE-Meta: U2FsdGVkX19nTBpSAgzhsoegbzBB7MDNUAYkI0RIAw2sBfGE/qIerdXBFYaaWDB6LB7n3GDEam8YiwrZ74CHX577YS8UxQ9R/Z/iga0SLMm2eLw8TCtgD64QtUMjpLcTm28yWHh3fJ3Y3QfB+P700G2LKMIn1UYa9H+bdI14u0A8lGWPTCg5cDEjfoeZwqaEe+tFV6kPakqqGkBKMIvGtkZK16q55Q6V5w3N6i1EBqXKFVJV4nBSvcq//dXCxf2K1o/50ZuNe7e46PVN36xjG5G5p/E6vRGPbQt0TJvbRhPDLqZB/Vp8Tyluk5g49IkdmsL2MC4WmRTI3Ij/Bv6MrvVXL0kZeYvLT20/uOptGg0ysi7Kdn2sUyKuDNwpTKQXLARmL0OP1FHbFI/vBc5DK5JF30CCCUzK9ceQMTUkorWq9QYE9wDwOLK7orvmwN7GmSp2/PFQWHgI0CFcaWXx83wtXvnAr5SpdRhKB7laZ45bmJ98jgsl2paPk0PpsfaPty+7qimz/Oh8YJ84A2V6Ziuof5k96ERjlErbJj7FhNopt91Qz7at7t2K+QX97mSVJTCNWnH67sFPGexBci/s+6x+w6X3W9s/UbuwfZ/LnQGuIno7Bp9D1HOtQDU4kDw4QiEs51urqWx81hoyYVBp+LRHM3gEKj23bJIyruSqubBIGz9YDdH+xUCJesIajE9tGNnT6nmRVClTSxILRnkC3ERLE1OxcpEDR/xBQLYI6ZQ+6wIr3+WAfB0Uy9woZBVljoVbvbydrauyuyIt7mv2LLT45k9ltaO+BIGDOcTL8a3XYWDnXO8AxOc82ttM48oNHtPRxa/8nayFmmRoCf2sxGWIGnMj4q4e5r++CHM6QCIVniLvz3gNzbwYcwMtdRUadeQ3p3UnJuFZXUAUL/z098cemjtsQxvqmYVDIlalFrF3yl565XRHhUHC+xjfBRJj0PHIzB5lloF2z2i78sU
 kq+B0UPu
 oiqEZD0FoXFk7rBQ3GsPTqptTAQVOWnd5SBGRqqCkXZuTTZCERUpTr4j1qjyIVig9ilfj08Mjh3qX7C4NDuq8c06w17krGVNXyJG9grlOcn0YqNX1i4AOPyqTsc1KH/V/xFNsanEQ5bgIURscYg8qBcxCW02Ux1zcgV7cmT5+rTmbBLTlO6F3k/WxSA9SLRvVup4lbkggmYk8mZFLOI2qTLUVRrROEvZ2pdMVuRcFW5tyli4U7sfChjrZQZQVkPREpbXAy8JdpuEhDyMi4TsWMlpyFuV33cgA7FVPE9HMVPHOC5hNyBcxRJKgojG8dYH1SBC2+0DaB3TpehFic4ksNr5BKa1AM4En8RN3AlkAW018+VeXTxWKDKABvSAwD8s7Uo+P3M0YQCvg1Lo0708gACfpOlGzvTbwE9ryiCFSVEmcck0bb3ceZxeWCj+KMfczZUZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2daf358269ae7..c7125f6693574 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4404,7 +4404,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4412,7 +4412,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.53.0-Meta


