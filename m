Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3A6C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FA26B0092; Fri,  7 Aug 2026 07:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457246B0093; Fri,  7 Aug 2026 07:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9846B0095; Fri,  7 Aug 2026 07:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 066256B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:36:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86F58A038E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:36:59 +0000 (UTC)
X-FDA: 85074271758.07.6A5805A
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf29.hostedemail.com (Postfix) with ESMTP id 91951120002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:36:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w RFTL0r";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G9yXMvl1;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIkdUEAwCGtCQWq2Mp8sW0xlTg8F6TBRnofJ/Fu60Hg=;
	b=xDlfC+QLnNpUx+UMXC6//yRdaGjSqJpTAtXCbDu+jhGg3CMPRbS3ZqpRQifQ10CCfbDf93
	zzTCXKxe+3OpyYWnJU0i4w2/nUPvbPaDD2zfRVU9Ug9bkwTIs1l1a1bTxoNGRJrI+OZGEe
	LVfaXX+4vN0Hq4Zy4R8KD0NWbBU83ew=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w RFTL0r";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G9yXMvl1;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102617;
	b=qZigZ/oo+eBFIYNfNBJMoRwChQ4PyRhrRoSImhUgUVJFA3z6YfsNSed05mjP1KalR9lhDQ
	3qL9KVaP/qZQnlGa9ZbpuDSfSX7fCEK+xv/nO3CaBWL+N5IO3QRw/Y2J54JBPASoYlLKwg
	qEu6HUGQZJO4xask27vF8pvDfPi0xG0=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 638D47A004F;
	Fri,  7 Aug 2026 07:36:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 07 Aug 2026 07:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102616; x=
	1786189016; bh=cIkdUEAwCGtCQWq2Mp8sW0xlTg8F6TBRnofJ/Fu60Hg=; b=w
	RFTL0rLMg4rHvQy8CWUQTbL2oYxVyCUHhwNRnLoht0C1AO7XQk4knl4UYUOTs895
	NCaUt70pAyVx+AO9jT5WzXPHmBKxdZb2sx7CXeQSi7GqWcI+YnnkPymz3gpbQDLT
	OazpJFPIGINitOehdRW1p3xiXQd/mS7FZy3qvn20cPF0HHPNqA6s6aA6xgIPgU9m
	7IxncNPZlHIsQyImxY12xKFEXo7zWbuOMUJYl+2T2brGgubvIz4v1EzI7P/kWezA
	eHkKpVBOeiMl8+6TC3dPxxA++4egmUWSIaWSev9uQJGjL+pvjE0wZ+ONNNNNIRTK
	TbVVCiK8ZI/l5RKEhH5zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102616; x=1786189016; bh=c
	IkdUEAwCGtCQWq2Mp8sW0xlTg8F6TBRnofJ/Fu60Hg=; b=G9yXMvl15P/EqLODP
	h29CXXo6hMefBq7R0Vhm+RJpa0l0UNQVFna/dDXhn5vjylMS83MJYk5he0uAeZkg
	4XAq97piv/yjBwsIpUUHJItcCi6CSuJBilQzlqmjAM4M5uLLSdzAfxsLoqy+yEsQ
	y8inpySpQnxI5aH4/eZjPxDrXyc5W/tFlxIlWWQcrt9cDpWiEL1DQBi8zQCGVanb
	NjjlKhVlpyqy0M8+CBBzWMWos1l3uAq/KnmDkIgRPRtmWkvyvxEPNaBk7i5EpaZO
	mFtF0q7A5z9vDMXvQeEDNsPoLLbmhFbDo/0NtsTrMV9kBQfflflRWQQoFSDMTUjQ
	9BaXA==
X-ME-Sender: <xms:V8N1avJ_IoKeh4t6Fp221pkLeK8qUHyykUbThRIaQ8xq_ie_LoHkwg>
    <xme:V8N1anEt5gQwsvNVKGwdIyc1FyNyblhbZpF2vHUugyDYZdCJXOTvv3h_p4TXthnyL
    57vSiJ5ELj02e2rBeKZQJ-fgHbflEb7uMpNMajx1GfoyKFt-4290HsA>
X-ME-Received: <xmr:V8N1agMfvg1fiaT-XGns7E6_fK9CNVbM-Us6kLi48-53IvvaGUx7sI06rA0>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQAb
    k5JRNRlEKLgml6X7jbsTp0jsLf6g6Zd60MuoeVfy+Ysl9o2kZSA454ZGpdH/QaN/g9nDo7
    Lp0E+Yj9TpHDuTjBVlhsxP8CZiKBTsCPvulUuJTHqivMavkWvjquz4yvRe86vfQpe23O4r
    1YFtj5pDmVh+VEGw3bu3Yog3PVDXHZzc3fvQQ6UPbSlg3BvA2YgbQnlcHDtOWt4B3F4Fla
    HuGj+NlZ8rQdbbE1TBNrzJDV2TzID8bIeJ1Pbxpd+JvxADuRnrA77ZhfcLIvYV2PfbMZyC
    QoVrNtpUIdiF3f1AWD8fIQLDdou5dNdL02HdxcWEF/EHF6S93onH74yVe8xQ
X-ME-Proxy: <xmx:V8N1ah_3b0wo6y6lfe0vtOmnrmrQnPQwdIUhhR7GnNLhrZr5JWcJJA>
    <xmx:V8N1at5kDqUUbu_3q5mhFBgGdvnvHOFkCHuMxuG12h7PC4kMAgdwKA>
    <xmx:V8N1amV4sbW9zjC2OlXTO_xC2Ta6RfiQfKLINFbt0-tWgFlh-SF1Ag>
    <xmx:V8N1ajInyLGwSk0Ktgnrhw7UslU2aNXwHefb4Gsp5ornqnwIim9lSw>
    <xmx:WMN1asM_sngPdlkaKHy-zptFAfLysXjpkIDZROomQzcoYaIuhhWLvD8j>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:36:55 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v2 02/17] selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Fri,  7 Aug 2026 12:36:32 +0100
Message-ID: <20260807113647.3744609-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91951120002
X-Stat-Signature: 849kogki9b7ha6sniyxe4dpura487gfa
X-Rspam-User: 
X-HE-Tag: 1786102617-964451
X-HE-Meta: U2FsdGVkX1/337oIBktTw6Zl8dc1BVtreTaBW2p+vPRjcmREMS9VvFCe/L/G5BQ0+Jn1k4xwXU2V4bPNiHX9+6nyzrCdwFEe6682ZyDdHIL3ZG8lb9MPF09Rl4W6GjT4I8/CdLQv/qLyxpjUCzIsjyuQNy4wM7Xwnoc5ZE0zHpyTx/sm8edKssPeMj6bqB7GtdLKpLcHTJ2DGEm/0GxXyZiH0eVPXu39RpdTRwW/KYi6nPzENgyZhswBg72g7G1q0wBWfDWvX53ooSTU4cv/gSIzcFB0QNAmHHJUr2urEEp408dDTd5Xr1TQYmTw+uSlcXDjTtl3vJlnHEh/XphA9nKO7tc8p2EVGF/gXpK0PrVA+BlZjPMKHC+XkhjSJyyc0UOBk7JTobf56H97gPasBFmk0mRD5a2KiUFwB/AbsGHIGht7llJp36A80HzNb0ZFxP+mPTM3zUAJWEMSht4q6pBZ/SauJg6SQMpq21r3uUsU1KJIpS0gVoKvBzbkyT0ZUqTCi6npm+09+1mtg8fLSnAYRKXYpI2MDNvb0+zbqVI0kiLiUSm6bWhuR3Bl67c3f3RCzi0CM/1uR9F1Sa9NrxHyDPaIbjpQLoIBUO5D+8f402kpUA5J822XCHzl8kKec4L5c5mMpVvw+kqF+5E4jE1s4L6YdGGhUqQBkKGmE0ckbjScnUcU4IZl66HzYHUZ0VhWK5fCLuKij3YO0S22v5Y77XusHAakYsyRdx+jH3ZliMlE14Zc8nby6SrG63MUWaI5LTUYlBI6ds8bGJ39zvpb9Beyq0ks4EBw3+BNUto7sAD7qU1XN0S39atYoRVrsyr/f0vLsWnCrb5mA4vGlsN2plpEKpVvh8GE+8D9+fQTIHMT3sTWKISGtf6Wf+XXTU1zKYc0I9cpckEnDk4rui5iM+3hKWa56FOa//ugti3dScF66l5CGwZB+PK1hOudVi/eVX5ge1eQsRF/Yjq
 qw2Lqh4+
 GZXhypyR/nmWsl4BNh2Cm52ORg9R09HZpOtX/KE8cJIuPRkFgufqkc0/BkeRZkFwBRTrx8EoA7XdAh7JBNqVzXMbnkioOIa87nWiSfrstSvSc0+CEeRKOzjzgpGdv1emU3qzJzcv7U21YBjt4uArfiy5qqWWIZAx770O+CHg8zSuzwRbC8LFy32oIgx/EAI38Z5WtzMuSxhqfHVnE09SOcvCJe+MK3zGR9HLWQSGpHT/mqflUmX5XP+l1/OJVdWpvYBjltwh7YNiaSByfmjU2VNp/Hu5N/CNkUQMIamtv6dQBdPxaV6n+gySL/l3RaT0X5dvdTluqldH3ABEMqciYfKU+oC3meCdPHsRjNJtv/DL8mtjORs2Zni/PWc9AontKkqqlrL4pVPl+xAfqmKJs+B5bTF8eqalQ52rP8nQ+sCZV6Lt+T80JVVFLUaCkvGHFSi/KMQBW7Psqr7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full asks for four of them: 8M at a 2M PMD,
but 2G at a 512M PMD -- arm64 with 64K base pages.

Three seconds is thin at that size rather than generous.  Across 80 runs of
collapse_full on arm64 with 64K pages the wait was half a second in 73 of
them, with a tail to two seconds, and the case has timed out in a full
matrix run, reporting a failure for a collapse that was still going.

Keep three seconds as the floor and add a second per 128M to collapse.  A
2M PMD is unchanged.  A 512M PMD gets 19 seconds, which is headroom over
the observed tail rather than a measured requirement.  The budget bounds
how long a real failure takes to report, not how long a passing case
waits: wait_for_scan() returns as soon as the collapse turns up.

arm64/64K: khugepaged all:anon 21 pass/1 fail -> 22 pass/0 fail.  x86-64 is
unchanged.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 51fc1f04d0a0..0f828bfee31f 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -602,8 +602,10 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
+	/* Three seconds as a floor, plus a second per 128M to collapse */
+	const unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout = 6 + 2 * (bytes / (128UL << 20));
 	int full_scans;
-	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
-- 
2.54.0


