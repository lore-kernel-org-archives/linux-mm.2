Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2715AC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A07B6B009D; Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0787F6B009F; Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E813A6B00A0; Sun,  2 Aug 2026 15:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5D26B009D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0441A40553
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:20 +0000 (UTC)
X-FDA: 85057378602.08.3ECE958
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F61C120004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b qON588";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=hE8VvX7+;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xebinTgPoV/REKfvrBQ0nYwvMKhYoD/4B/S862zW6w=;
	b=TdxaoVdn3g73BNkx259wokEupt4o7xQ7sgqOItNd2KqJDrUBqKcSWmsmScZKFHQrk20YAu
	oGGuJ3YD3SGV9qdeWx5RzwkgAPuZio/IfcIjgmPTWv+Xd4O7nWPEGidt4w4z/LXVpKmUhD
	+5tD1bqjSz4+NAfXAS6sBWgnQykcx8Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b qON588";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=hE8VvX7+;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700399;
	b=QDLFdkTrTEaAwVa/PhmZEdwMgjY5YOOAGVvuK+qooo2MU6OEM/ykgEThdlR0xM/JQ0zGXP
	rCuJwELwB+LWOkTEwULBERdAV18oQUIuYPzmNAOmgeTLsUhYcOBiHBOOlEu6sC9FECg3c9
	Qv19fYiGcgn8k9fWq54vglgm5PF0Uzg=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id B1C69EC009A;
	Sun,  2 Aug 2026 15:53:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 02 Aug 2026 15:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700398; x=
	1785786798; bh=6xebinTgPoV/REKfvrBQ0nYwvMKhYoD/4B/S862zW6w=; b=b
	qON5889okXS8B1oWXPaDR8qp+/n5teUB2zsyksoLxyqoYewTu1ztJjQNfZlnmEuL
	m1xL2ZvhoRdixkCDocemXyVc0XqVo7pBGtxibKQE7NbXKZ1K3kWf3Y/tgnIXK1PP
	tjHuUAsh3NFyiCHQ6qiEZzLE6Gy0jW5XE4Nt0S+ETtWS1gSa1zQmAVYfDyl4ypNJ
	lPWDziMWZneU3JIDQ43EmUDNHBPlfIFOE7YfJ/+09KSL99Z4tIvqaiAohISXFreb
	VwSSRpAqJ0Me0z98SZDxQV0CQP3CRLO50kz3/SYOTGQF/ywTYeinQ4kcVFw+79MV
	K5MlXvjO99sWOJHeGxOqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700398; x=1785786798; bh=6
	xebinTgPoV/REKfvrBQ0nYwvMKhYoD/4B/S862zW6w=; b=hE8VvX7+zKm4CDLIy
	t7tRCnXrDMfIeObKHuUH/IhinMtuAv99EJqQexlcfzBnPqrfBQeoOzs9eAppC1iA
	hfAEb4IJntTrBrTkaDyH5K0PQ9wKRImh0dxLtJwkXfanA2rPg/OsYmqtThEhf65I
	zk74HJX2dsTVv7eJHUIJH/oMGSGGCyxHn5JRbxnBcnzeJ5fw418MYVR7HdEErjb4
	G6ZHVX8TtJsLT5V6ApPURJncyT31kxsBXnyspFQJjPJEELvnXrxYaG3S4FjnSc9+
	bhY+HwEsFsnQo3ErpvgXswvvB51UoSSobLNhLbv4kpfaBdq/gyzbD43LOt3FrSx3
	hhCRw==
X-ME-Sender: <xms:LqBvahGlzspf5ju2IeXqY2KKtzWiNDuOoxoonRfQCiPqHHMjpOusDg>
    <xme:LqBvag02sZbYuc_K0ajsPj13DJZ2mEry26Kc3ZoSkEhC3-ribd2i6p5GJfKy0C3JK
    n-1cGEzwS0en3rDdDHcF_rb91OJqW2p9bpo4pMme7Na91IBG4kjdg>
X-ME-Received: <xmr:LqBvagFPJcBl1FDBTJf1G8il8zvkfVbxjfOt5h3kLnKG72TQgDDkJY285oM>
X-ME-Proxy-Cause: dmFkZTGeN1xI4bt1iclSzDFip0Bk/XaIhvbS/8i3JSTXfor37WXDF+RcNWPPd9pfiJK8Zw
    2BrRRh4rnHFGERiD1jpqkpu4TBSJEj+dkjcrMZ9PB457VyyAOaPr9tioF0eAgQ73LLdMGf
    ZnUc9d7R5xpl56ih9w8zQdF1AdPa5yFqJeaq79y1FNmaYwVg1fW3ZavvRb02VDPCTYSs5n
    EKi2mK0TcmJbPEDbjm1vybeof8AWtEC76nwVjuGNoLmfYq44vTWlCkOqLjX+gcHHM4Q7iT
    SPI3JBSpkIfgjo/e1nwt56byN8xWT3gnCcQMRcCsWQ2AE9kBILBwP01Qmf1NZFO2elKCT3
    V5Arm3Bh+UsFV8y9PS9UPHiLgvZro7zrpchUVgZEU5FRJZjfxrFJ14Bw/Qv2jtwqIdSkfi
    gvYyr7fENXm5B3vCTZS+UKdbhNWKrdW9LM5SC75XCXLj5IlwDB0ne4onZl2G8UCpFqpLpb
    TCzHqQqshfIgGbJOzFWns+sDWv98eKqOFQjuI0wqxeerYwpp5cupmK6wYoDxn686kqIX+X
    KPfziR/xF7gzZIYMjNdbekv2d9+QKyMejmWv2smFLNMWjMiP/GMQrKzSqLSPgZfNrQs6L2
    Q5n0Zg+rfsTR61F4b+w2mB6W+KYCgdrgGji/OGSvYfiSa4n9qryCLyr/TqVg
X-ME-Proxy: <xmx:LqBvapxQNiOZElmKUkNmm1jmgZqbQeIvUVYmzlKtbyYpTGqrXa3muQ>
    <xmx:LqBvavm9GjedUXF1rb90Y7R9UpMyADLDyo-0QSL-EHI-NXwaRyAVsw>
    <xmx:LqBvagDw1KIQZDp5ZDBBOpgB2Z8fKhcNJEIvz46_tJBQ8gbPAEkwVw>
    <xmx:LqBvaqKoAdwuT9sEc85-piA3Zax3iV2LZlG93UKzTTKvLBf7FGywyw>
    <xmx:LqBvakjE7aA3_jLKUPvcI8FvQVTBA0QifIIH0xFeJ5Unok66AzF7uRjZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:17 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 09/16] selftests/mm: skip khugepaged swap tests when no swap is configured
Date: Sun,  2 Aug 2026 20:52:41 +0100
Message-ID: <20260802195254.1937477-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F61C120004
X-Stat-Signature: ou44pwiou43jhbc1an5nny9rrhgecfuy
X-HE-Tag: 1785700398-486342
X-HE-Meta: U2FsdGVkX1/QdTcE3nj7MCJ8cnF3imSIuVF6oQYzA9BalSGHmHc/RHa1YJouiDgXYZ+zroSEXZJLBZyapLDKNEQKUjRwY4NvSK4yrIoQ0aKEPnu3qI7Yq7FasG73Q5AY5akMa1w7Rs7Mh1JBafCNhfO7nEgILBn7WrYyDToqabY0w6OT9LVNeUudikPG6WgYCo5XMbXUqwOvxr1tPkWpeQsQSn0dNBs5CYKHnuNgFZvlLlM7+q8KTo0ivLKyVa04a2p2BN2NxTL3H860+g8TNVyxYqC2nGyqiw0C2/oh2mWZ6n9kGSCWf44ngVT3hQR0LTlR4TIbOHb+JlnmebJ70n588/a8ephrFIL2gZxf6yZXnJSj6W7+JWT5jscz4sRsf/LA4Aa5nkxDO7xmgpnZwi+TQ7Qjvx0RUUKWgAl9GOtetFjhz+xQTy1805OlpWx7Ichwf0btvT6Wt58y/8EwEJ58GHw+ZDur2J6kWdK8flWI3r5cdLe8y2j85YEafrAjHpJY60kp1pWzJFsG+ZCrPovK9V5/JweOpaTBziVhzsV+mmIKlWSKOsCmK4WUYgcdf0xxMutJKR8nAnW986jM0f1jJDDRGk8YD/A54YBBfqnS7dAWtpPRt16msWjgoh2vitF1eGU89H2nDk8C6kR9I/A8m1hhS0nOT5KGO4Aj1OA5VS4kIaJC+Lov3NjSxwLRhnTDcHRlaAkD3bu4bgGpkyc9/JJqv0KhTr5Ff61wWKypBcUJsrMxCr6fwH3T7ZGE3gZQJtvBNW0xi2BK/T0FF4thjf+W82Ss34V3KKFaH5MDDynUx22M+knlf4kUAkqhu78AWDD0HLY+n377aIuGhzkRMz7q1tpJslBPEI1bZU82a3gH1ZC4YKtvhju7zCNr25FD7pZjmeGJVbShNYAvt8iq0b2D2HmykbdZ2qUEOVgyKsQDyHVWy+UOqdlARdwpiBbEZBLry1pu22IxliE
 6wfiv8nM
 GK27bxi/4gO4mYLUUnK1bmJuYhATcZCyJSeCghZgJKDl+6M9IlqzzQB925+Byds2nThQ6DHveatWCNi7s21hMCs0hIjT5vf4iDn14AFlIvI5CyWEW3na1tWVT1YeqYXdkKTgqp7SMgewxW2tj/x/n93wU7RxOsbNVPFpUAr2Bku4Wzec6StCyYhGqxhhc+WXXSeVSGiZMJr4zNuU/NRBDWKD2uwguIO5S/PMMibGJiJr8yyGKNQj+a9NrXkYjBxd9dTmcJYMQnm8mxAJg1bFGLVG7SPtpX9V6if5ofrHsCbU0+pd/Gn1pJIZH7X87ZvJTj8lR4fVWdWetLOXQlLrvv1NLSNx4uH57FepyoO1U6BNqIoUZSjVtAmMJfTa8CUXwB4lisqdvG4bMaUi3n9rgPjSMOIHbGo1My8A/vF2U3B0vqVmm3RIdb/B5+XeK8UMUF9oKQzKMHy75Ypw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_swapin_single_pte and collapse_max_ptes_swap swap pages out with
MADV_PAGEOUT and then require them to be swapped. With no swap area
configured MADV_PAGEOUT is a no-op, so check_swap() finds nothing and the
tests report a failure that only reflects the environment, not khugepaged.

Skip both when /proc/swaps shows no swap area, so a missing swap device
yields a SKIP rather than a spurious failure. A real swap-out failure with
swap present still fails as before.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index b43e060b4118..b074b005b62f 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -181,6 +181,21 @@ static void get_finfo(const char *dir)
 	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
 }
 
+static bool has_swap(void)
+{
+	FILE *fp = fopen("/proc/swaps", "r");
+	char line[MAX_LINE_LENGTH];
+	bool ret = false;
+
+	if (!fp)
+		return false;
+	/* First line is the header; any following line is a swap area. */
+	if (fgets(line, sizeof(line), fp) && fgets(line, sizeof(line), fp))
+		ret = true;
+	fclose(fp);
+	return ret;
+}
+
 static bool check_swap(void *addr, unsigned long size)
 {
 	bool swap = false;
@@ -739,6 +754,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	void *p;
 
 	p = ops->setup_area(1);
+	if (!has_swap()) {
+		skip("Skip (no swap configured)");
+		goto out;
+	}
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout one page...");
@@ -765,6 +784,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	void *p;
 
 	p = ops->setup_area(1);
+	if (!has_swap()) {
+		skip("Skip (no swap configured)");
+		goto out;
+	}
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-- 
2.54.0


