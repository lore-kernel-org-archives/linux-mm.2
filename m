Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4735FC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF32A6B0747; Fri, 14 Aug 2026 21:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB2F6B0749; Fri, 14 Aug 2026 21:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE16F6B074A; Fri, 14 Aug 2026 21:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9129C6B0747
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 095171402BD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:12 +0000 (UTC)
X-FDA: 85101846144.13.D6ADC07
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A8AC40003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Z gG47Ts";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=EOH9+raa;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759150;
	b=P0hayUfYTqc8eDSBCrYUzOJseM7le8jJ0O3kBrkp+iOojYZ+nzS9Udja4AforZ1K1hP/V9
	nojEVlJsH0kUH76uKPrPnR8XBrWsuGEWvR94Ct/hPhc/HSvgtSzPjBhkkYuS0GmidWCl2f
	SQ8rUIAuaq8yT+a9kFPK8gMtB6oxLvk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Z gG47Ts";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=EOH9+raa;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zex4bQI/K2jisTXcoQfqqVox+onfSYGfs1VVhpIHxHY=;
	b=anPSUE6Pr1FE1stOCT8YX/sluV6why5CpsWjthXQEaozNRyk/xD3KHQ93urbby6g0Pyvhg
	6IH0rERSeVTy1Tp6EKU8lrvaRrUv50/SKFzfcmImBoax0YKnj1WTlPiiR37iXqWmqRwTtY
	JohNDbfsQVifeU8YOWCJD6E0+sD0+ag=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9617F14000DB;
	Fri, 14 Aug 2026 21:59:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 14 Aug 2026 21:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759149; x=
	1786845549; bh=zex4bQI/K2jisTXcoQfqqVox+onfSYGfs1VVhpIHxHY=; b=Z
	gG47TsUXDc74J69BdsHiaAZ20D9iw7bshmUv1PeRXCFvYTNzdErF8Ps8KU+XK1ct
	qLY/zKY70LAQCU8YnvxCZzMaCO7wI4DyqiZYNfzm6D2yOQ/+tF1Wm9NPoyRoVZWc
	TERtXHpx/6wnE/S6A84QIerMPR4g47FL1SKYl8BE65Zn7cvlRWyOLlLaNsf9AC3K
	0pno4FyKRKyrHLjfexndPrF7HKYHUSfTkRcXu6Pfn753ecWpiOsrgbmPZaBly/mF
	03sXxGMhoy2Jlirnm7TS3y4hEtcGbDSOo3lt7ikRaEKj213yNAXEQMRx4FmdrX6F
	VnsCJUp1SyGp7x6mJRpLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759149; x=1786845549; bh=z
	ex4bQI/K2jisTXcoQfqqVox+onfSYGfs1VVhpIHxHY=; b=EOH9+raail+Gpppe3
	MTz5no349gPpJZHFYC02c+VJXQQlye/7oZHMjWtxwrTgyVJnhc4sQ5bAc3ESM5e0
	QxHWeT7xjmLnXk0dxtWCKGQb+TgGirMOT7Pih/UXQleMRLYAdyKMwDUegknPtJeb
	QP0tRMARucpNNOysGSRswuVN5zDxqgo6l4v6HiYP7rxqKOkJhixPKgg29Ao7Hrce
	B6bog9SZNzkLlJnrw7Vjtznr1Q35tA3AGyyAONl7Kvedb4FQzbtz4hkv+sIBhbwf
	cnpkT2pASLFbOcs6F9a3TJ3E+IGZ7TjLNF0Fpn8AnfSVFpE76QmkSqOCbCVP2bMb
	twauA==
X-ME-Sender: <xms:7Md_as2mStMxPg65qSKJFpOMRm-PtK_PB8J1T3HXJGV_DOhyu1KgjQ>
    <xme:7Md_arB6y2HOkqicze7GCE2eF-mp84FZBUKB-4C_o74yYbA9_li0ztBGScaJ4zljw
    6CzhQGvuRG2bMm9ZF1sN9_tRz8w0DpmK_zDJITzMV5lx9ktn1ZtABg>
X-ME-Received: <xmr:7Md_atac2nbYPOnql3I-MvKZIRziGRWPEZF5qbEqLTygkNE1y8IJ8SNnAcg>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1Ucq
    SUpY4/UrUyKSVyvxdWdkzRcAxLXEajvkyHarmVKmBKmPh2QSdP0hn98URAdd5ulxcsE/oG
    HExvPs8wbd4/c1OD0GCTIQk37WW10K4nncE94L1KpyMGnmEpXO+avOn6/IhVBaxW9RvQIk
    /IEopIoH4a7oK/nS/pMUtNzIIK2N6EUUROvpKfw2YEamJAq1mzV1j85eudJuXLlCj1ymCl
    DfwOdwHrJDFbVLGOJX9Pbb/kjXnvRCmFZ0bK8vCEtFQTadr9Mdf2cu+dpzUjrEqRyPJWN5
    9kzVnnSKnSddmpbT6pvKRYBGeu90PJNZYVPIn+RtVt6DI1aCGz7rLsIxrSwA
X-ME-Proxy: <xmx:7Md_avYbIZ_tcTk791L9dCnJVB6dp6y2GJRsuDlBretg9eCNLBuTVQ>
    <xmx:7Md_amk-yGmxJaUnPN8QOBhwhHViq8ogEFcXbzK1OLFOPQkGRg-EiQ>
    <xmx:7Md_apT6aYiGB2yGN_W64WyfArJbxfbOsxLlxhtzN-wynyTFd_2s3w>
    <xmx:7Md_ajXPofTL4n0xHrKp79wH_R3Qctniveb46GcpAHKk_l2SIiV5zA>
    <xmx:7cd_avUNW6SHB1b65HYKyaCKTDcUi4N0ibrPhvjEtFGnHAxieyKALhWV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:07 -0400 (EDT)
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
Subject: [PATCH v4 01/19] selftests/mm: raise the khugepaged test-case cap
Date: Sat, 15 Aug 2026 02:58:43 +0100
Message-ID: <20260815015901.1236937-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A8AC40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1yfbwgtm37tmaaaxuicrnongfb8bk543
X-HE-Tag: 1786759149-383840
X-HE-Meta: U2FsdGVkX19CjJWxOOAvP5AkP+VTXgdJ7gad0cdPluCU5fwkvBNMUVeNGFobdck61hvsLWwu3lioUpeHDdrYMjU9Y5kMhAbBmhwMMkFESoZKPdL8PFKzholtumNBBaHsY/rMDpTIpvVbigthTOOuqd4ODhBch0asbLZ7wz5px6uDuT2K50LEIrbFtd6ikKxqWkWQcZa3AlZR7bRb9b5eZq81y+XPTYXbhxs782MrVgAq2p40LMPdv8UTFQjdhcERJh6H5xA/XBzizuOV2/nTqnGOIZPTFhgPrFMWIsSP8TuMbw7M3KhFSDQMtUINYVhfXH2u2Ny5l0MVpAutV3Bpzzs41l8VvY6TpAxN29Nwme0tVuSNukCmxyreFtJIXfwXn6EGY7MzF6fL2zIMaq6+Nhna7z377MifeZE5VApmas4/fKZpAR5mgz4u89e94vCTOm7Jt5cXYQSP6SdmVE4Cxhk8h4/JLCSXbeu5yeNDlW51HCWDi0fOKB5en23Y1l9VdjNDVKTl1f4WYbYcdrYiHm5ewWm6mIlG3H65ZgW2YMtoq34AQcFUKGvVPlURkGKAeTsUupIIQ1DLFuB0cRxs66krnDthQeT5a4X5aIGkQQCOyPKQ1+iya+5OxLinEd3ZIoZkmlNZ+EhJkWOnQHo0sgOSoHwKR3FbJFWigPhNaHCSgD/CTxcEIgOBPyh5JZcqrRRy6yBS1iCknuX09UyYcjZ2IKkF7ARGY5PbRHuu5uinRCEqjzyWIRG0Cqyi6XCgRtSOAXU2WScyLiuaMUHO5k6U25ZE9B+1GNPPT66GP49Z99zM3rWKsRU2MzeoHqHUFvfXHCyUY+Fxrk3M9aUI9bX6dMRWmxiyNu8d6xvKyfkYILqU4E3/iOw2pjymfeJlnRM0GG0OwoXYyGPanPwH96tTxeqDEQK23x8wKdFH4BJKEld1h8VVLoTBqScE4bqIdbLhwOr9NqFzjm9mtTr
 GbhO4dQZ
 d8WkfsFZh0ST46Tc5da7qp7uQmOOSbifSFQlrDNrxQ+Fdu3XldPIf9KkDRHie3p67BYJ5siytBFE+4pBneU5OBFbk2KQ32Rr9XFb/FK/nLPrk5NRgtxsMBWJ3NnPauInnM2USpQJ798MdXscvtQZTnCvD3cFhaCTwr9mYZkbxWc4sKme85RE5lO0IpHKIqyLAQjV61aNdcPWN8tihDKuEMk8Ug/978jj+5dzmYJa+/GK4SYNJN11LBR6T80XO8Nql5rTPdX7VaekjTxkct7f/elVtUBIVpJLeyJkbNYveO6YWJhtHABjDdbl+ClVoGDNPHhhNI+Jzxa5NzCLnYqDSwQE2GyemdBzkl/sf0VyxW59z+OXTRfAX05Grx6F7y0dJLIQm4u4xJlNq+MhlYL0qwkLHTssVtTCGVVVeH/8TtziAg/9f/prUH8rrEHYSOzBi3kwOYqvXkiAxkMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

TEST() ends the run with "MAX_TEST_CASES is too small" when the table
fills, and the table holds 64.  A full invocation already registers 63, so
the next case added anywhere aborts the whole suite before a single test
runs.

Raise the cap to 256.  The table is a static array of small structs, so the
room costs nothing worth counting.

Assisted-by: Claude-Code:claude-opus-5
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index d3a53673e1f9..6cfec2b940ac 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1290,7 +1290,7 @@ struct test_case {
 	test_fn fn;
 };
 
-#define MAX_TEST_CASES 64
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
-- 
2.54.0


