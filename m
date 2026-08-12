Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBE8C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B656B00ED; Wed, 12 Aug 2026 09:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33466B00F0; Wed, 12 Aug 2026 09:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD43F6B00F2; Wed, 12 Aug 2026 09:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 987436B00ED
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A7B916035F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:22 +0000 (UTC)
X-FDA: 85092683844.18.C93B402
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3283CC0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h WR6F65";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WBxWWHuT;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541000;
	b=ltOGMOsFpt6KUgytLfgELKgyhlihSlY+IPaEVOp8c6BdjtuEG+eLYePJl/0cOhc2oBBF7F
	rNyaGYT4Q55SUugl6ZlIk2rNTOImbxO3cjw/nFkNz+NCtnx5QUqSQoTCDs8xdUlFqJN7x7
	CdjFnF8l0MSyraXUD6Q4J4fqXrWIIho=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h WR6F65";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WBxWWHuT;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DF6XlsE3dfRr0xz9ihNAdyd1y2VRfqNvU66IRArOZEQ=;
	b=eZOZmczrNT0lPLAaxlma9K0B76f/X9EZj3eQoW05uRAV2x+PuvN8HXcsTQG8a0O1xY4LHI
	BssYGWV50QNSMhoYj3ZOc3LYpGdTEmK5j/TCn5JKURjbJNYyQQIHuvDDQUVqyStQBXkGaO
	WhsPSTcTD7l2Bp6ejUWK0p25W3KnbNo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1042F7A00D8;
	Wed, 12 Aug 2026 09:23:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 09:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786540998; x=
	1786627398; bh=DF6XlsE3dfRr0xz9ihNAdyd1y2VRfqNvU66IRArOZEQ=; b=h
	WR6F651wjr7kxuKTtzxDR0x9diJvksCsJp8s6NJEtgTnAxeA5FCMl0hhZ6kAvvxr
	gTainIu9jqgofPJKLylovUYHVEQZAdQfXrKCcyo36cWA8dDexeOx4kBRJ6CPwdgh
	30G/hgL811VYz97ehy1oxWNjMlhEEgVJvlBs0udJZyPGu88vjJIGfi2sgqS/Ha2z
	U7WTXrFaOpiUGf6foEV03P0U2mT4IwxSxiZZCdcvVkgjiyLsLfQa3f00rsApdI13
	QEIHQ3OLXWsQY6PKquk7ZQDMot7jLHOJ6w++JKee5Sazzbh/AmFwqcq5Zqb8ZE6s
	ByPDZidU3a8AtZ+mlbfdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786540998; x=1786627398; bh=D
	F6XlsE3dfRr0xz9ihNAdyd1y2VRfqNvU66IRArOZEQ=; b=WBxWWHuT6MDoSl//n
	MJYbu/wzrDKD0JkzyGIqXAPcL/VtLdp02tydbvPq5iUiU5g0BCR9IJ7EqHkK64hl
	g3NTH0macTaCkGjfaI3UEkfVOF+OgO4Xs1KYPsl+Cm5uQTTeq3E8Xp7PA8otJQqr
	3hg7zsTSa7MkiWpU1cxuEf2fnescopubdtpqkx6RIV7i2T69xp/Jn3/fxZDAN8hL
	zjWmNWNS0QCM3GLA2/1IM6nENYFLuaZV3jqM3FAgA1UQ0+WaV7HdH3uz/oZ8fEUL
	N0u6HHQTygdH57XsT5LVvc1h/TAFRkERiRq3ko1Xu13q1zdbq6oCioZstDPTbZV+
	dTLzw==
X-ME-Sender: <xms:xnN8alNvZ8C2Z7r_88B-55yuKlgj1JZri_dGl0NyFZCGsqO8UaVrwQ>
    <xme:xnN8ar4_vUIGzHZUI7pDhDQ9wvGmdmWVUGdMl0AkohN34VFna_VnsAVZXtWzErX84
    acmQS92HtCd4eV_UaV4r5o1aY45hnzBSNelT9ghSIEc3GLpC9IZH_Y>
X-ME-Received: <xmr:xnN8aswXvkFbn4FEcjGtvejP0-369wDtkdU1s2s5DsIqpEcg6tcBv62Cfn8>
X-ME-Proxy-Cause: dmFkZTFzqtrNoSTXX2MRzKyN6p8XXqdjDSX08KYyJpXp82eYC1ae2GegaTOhbDzreYT/K0
    OAsc1zsfjWszwuQXvOMxV3FM9x50+HqAsA48u5Kq52QtHo+TJJPCEG+EOeKn5Il8AepNuY
    amkSO7LHncjzMJKy/SPUs50UUrTlzGP0ayf7b+h/q5NreZMQSrrfXSzcd6tsdBCg4Hhmbc
    7COQKDHpqWJD3HpoJ7/Bw0J3tcRV9tZIkmRGQ4nZ/O76iTBc+eN6GYtayu9aLLTJal0DNN
    hI5LqlugC7KhSFwlZIIFqKKnJB7XY7vZnEBEdRJ8Mvpq9sE5OflKN5J+H3ujbniJsnhlYI
    xji+6SmTFIQHxOuLmkmDVGavg0RuSKJZF7XoXVbUudqM9qjcQTvodLsb6C8iCX1SNL3Pkr
    qTC/Gfpp7WJRpjVUw/htERWzSW6ctrDxWN5OIVKdPBe6rx8N/aiFz6c3DafXPMeq8VXFAi
    6HVJlDqdRrV1tnvNqxl55teaK4UWpOdAfeUZk48tdS1rF6SAsYdUiF+wPN5/GM2xKWXzP2
    t7JYdbF+su8Sh0O5pXCYqk8pSorwSfj/04N2pbZTnhDX9EacJQuHhurJ3mQzqThkw/jYu9
    y4zbK892IeTWKp8C8x/yjYr8qVLaPz1JQ0vN7l8zE0Ssb5TNjrJeYffjqKuQ
X-ME-Proxy: <xmx:xnN8arR6PRGZRpXgSxEZKXRwqip2jYCGY4rmwH9MmSaP6iD3pDY8oQ>
    <xmx:xnN8ak9JI5hg36g_OKUAiJtwnvc7kGUnK3JaJRFh9g-Vo7HXwDuYpg>
    <xmx:xnN8aoJCAJEvV18qaUTOl9HHXNzlufYSK3cgu2vkrTJtcEFAXjr3nQ>
    <xmx:xnN8aotDplR0S-hVAhF1erIdmB_It2LVyTJOKU45vlpb_UtkutnfdA>
    <xmx:xnN8atsajQjH75xlROuggnLnMLv4AY-lqqEgYTxoX3gr6BfD9LlPbYvm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:18 -0400 (EDT)
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
Subject: [PATCH v3 04/18] selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Wed, 12 Aug 2026 14:22:50 +0100
Message-ID: <20260812132304.199287-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3283CC0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: af3t7wawnce6tjtni7srtbefyxqg6by6
X-HE-Tag: 1786541000-846160
X-HE-Meta: U2FsdGVkX1+xOYpdS2HxnkkpC3Clo44jLfY3pzgXMN1wcpdYgXBmrjWXBjK6ghXWfolraS5aQNetBd05wfrzH+IUZG5odrJDhej9bpOOxxaOeLEb09PTI6SBc4fhvztBleMqzPFatM2gzg+yDDwak0mZW89yxdeUK1tCSuvumU9B9hYHFWiEb5ZsnJ3N583q/O6MqSkyC1NJH0+skd03OmHxfLnjXNFgDCOeh8K/ATLfQFL8YEdzHgHwehDpzHzpMVubeHdtURDrQObvvxZDJrBMjlVWqmuySgNOMZ2n1ZKxGtxixfTU32leo0AdZDBUCADVwaBmpJiJ9Zw+P67UIqYJ9YTA3Pj/clvKPG9t3OHe4vWGhdq3VzMjbFby1x2MP2yki51JHGqYYCHG9arWZ3M/huI4r8Hbwv4RWPAEFodKV/bkHcxvLJZoLvhQwjcvuMeylSm/oJRy7hzJ8xM2I48+VHjRZeVUAwGuQaxyVALo/fkEF3GPeg39JW39wAgK9Ha/DNFqkOCLxrzUpRE/Qgiwlp3ESK/CzyMkSjyUFwXuVgM28EsZx3HR4SCXSD+rmuBLoMoPkhHThK5Fvtrwbt6/H1Fwdkyfs8DN/XgpRx+cbEzhgkVPSP2z7YZLhnCBVMoi6341rlHIG+hv9G0CsqQ2VANOaEshAr4A0b/MtH/Zo40Rk3nqTDQpuxBRzWjpGp0mHdMeBhzTd1GKkocmMirJqVak8wGw0BhFbFBJCvuQj5wE3YQNdzfM64IhujkRycAmj3oqEjwaiWN2X9ge+sJylYyjZx6lVLjQHOxYNnHg7+KK+f8Gr4ul+x3qJE17anfUM0DfgLkrz1CVL1B8s4Uyh94QhLXPXfdo3zIPvZpxbkElTTmLaq2wr+mAHT7CVTz8Z31uW96VY5Sb2YitclLsuiJS4drctJBgdSm1EF+/oIhkfzanEQgq1GhF0NXiw+kSCtc0T0N8e28xd14
 Kym1i6e7
 08uComlg+RcJtBcMdSgZAege3hSzelhUUQoVvG1oe0smeKmdvlEJXizZ7MW2Djk2rQ4hl2OEE6TFGnBcNGtzFdiNWOZ4CFVGGPP8d2ShJPC2yh+FD8HffAAjNSgm2bynXLhicWFoWw8NNlU2fY4V7ETKR0Tf1lnszR/0l0O3ELMSuQLyPZ8S+Iv0akV/cWqeIekKV94f3Z/LMc36rpFAhaFF6BP4+pp4MdAScCrOgfQlC4wImBd7h7hEBMCfLAETWEl748qbdhNYuSrsiVmPdXOBRtH75X9XpWxtDqj0+SKWqf4X1+qjOdXy2seIkxhtCrP+9tFzqZ69zE4h2682V6bX3xVUw7Mbvb6Ut87qS84Z9CWf9QvFUVOo+u5cdkIStt3ZRYciSEFUQrRQFLA8WjmQe8lEBqfpeXWwl5rMUa0lrx+CHqQRqVvKDKPZ8WRuIE6ORbVy60NHbxSnXNtR85tia1KQIUq+bVz2sCRkfuHYasDE7HNmISqCNiiKosJYal9Aa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, which sits below
the PMD order where a PMD is 512M -- arm64 with 64K base pages.  A
PMD-sized page cache folio is then impossible, so MADV_COLLAPSE answers
-EINVAL and khugepaged passes over the range.  The shmem cases ask for one
anyway, so four of them fail and the run bails out in the middle.

The cap is one global, so it rules out every file mapping, not just shmem:
shmem_huge_global_enabled() drops the PMD order from what it allows, and
file_thp_enabled() refuses a regular file whose mapping cannot hold a PMD
folio.  Skip both mem types when the PMD order has no per-order
shmem_enabled control, which is the readable form of the cap: that control
is created for the orders in THP_ORDERS_ALL_FILE_DEFAULT.  A run left with
nothing to collapse into skips outright.

Anonymous collapse is unaffected: its orders are not capped this way.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 31 +++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a5ada78d90ee..c049ac997def 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1391,6 +1391,37 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which
+	 * xas_split_alloc() puts below the PMD order on arm64 with 64K pages.
+	 * A PMD-sized page cache folio is then impossible, so the kernel
+	 * refuses these collapses by design and there is nothing to test.
+	 *
+	 * The cap is one global, so it rules out every file mapping, not just
+	 * shmem: shmem_huge_global_enabled() drops the PMD order from what it
+	 * allows, and file_thp_enabled() refuses a regular file whose mapping
+	 * cannot hold a PMD folio.
+	 *
+	 * The per-order shmem_enabled control below is what makes the cap
+	 * readable: it is created for the orders in THP_ORDERS_ALL_FILE_DEFAULT,
+	 * which is the cap and nothing else, so whether the PMD order has one
+	 * answers for a regular file as much as for shmem.
+	 */
+	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("Nothing left to collapse into\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
-- 
2.54.0


