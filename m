Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53920C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90DA6B0749; Fri, 14 Aug 2026 21:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8416B074B; Fri, 14 Aug 2026 21:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B656B074C; Fri, 14 Aug 2026 21:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6864E6B0749
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A1211402BD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:13 +0000 (UTC)
X-FDA: 85101846186.17.EDBD08A
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1E24140002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J LIYuLm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=N6vI9+9M;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0UVYTdnMDN95QCW3MAbNL5JjNdjlhisIs8DxT1bDN8=;
	b=Bxd1wr0E+9baiZcgpfUc9QJGLRjKBnmRzHL332XyaW7+VyYbiBg3egvsTBTlgCaST7jB/y
	0wV7v6OAYgaQk46YLU6RQ5oe8cdPr1JPLkNPebTbNtPkmKpw8OPuzIclxmKr7vht8zjR4d
	HV1YEEVaddMrJmqkchmjyIHlpafUEuc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J LIYuLm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=N6vI9+9M;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759151;
	b=gLNJHbNvbJ25Nbxz2CkFml4x2m4/VkuErdkuHwBwn7tsjCapfuFBEGLx//a1TxpLz/CMMl
	IJIiD3LwGUhPRHNOKlSY9b3E8M6QwA1vBPL662gKQD6strc+dGi+CyZmTP9Dg1J0Wwmtfi
	ejkdt2rsqfbj3jvT4sphzxMiqXBAbRk=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 53490EC021C;
	Fri, 14 Aug 2026 21:59:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 14 Aug 2026 21:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759151; x=
	1786845551; bh=l0UVYTdnMDN95QCW3MAbNL5JjNdjlhisIs8DxT1bDN8=; b=J
	LIYuLmtVX/3gOR7fmDqT1M0k1GthK/F/Fix3+ncbRus2ugay0vTmnRW+rCbwkraB
	pU/Ah7OCaoIqpbdMIIwH7zkh1h5RwG6hB9LIr/pv5HQXPEqEB9ueL0lcGiawuvQk
	l6zW15OxEHGdhdlu0H4VyJS6F0LsD0P25e07OkZA+x1yUqODzzkshRYPfwjnaqod
	RO601aJg8/a73W+vmpeZIYVBJ73op1mO3QyK2tPwDBzudBCsdKDtJ110Jo4ikna6
	T5j5eI52U8Dtupe9XMgZT5U2YXaD5+VYGk2xeyPhoMKwQhfLN6em4nQPGdPYCvVE
	Pv6G9gDVlfmuSd1ADICrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759151; x=1786845551; bh=l
	0UVYTdnMDN95QCW3MAbNL5JjNdjlhisIs8DxT1bDN8=; b=N6vI9+9MbYO6PRqKI
	5txNJZ4S7SFvk39vJFz2bBzr3S50NXDCtnaHHVyIQhrYH0tDeVvucUwpTjl6YCbp
	1LuvLhwMK4OePf053V0E03QMD5z6wqu5PXa9Ji40p3UUc2425Z56uqdnywIpYhE8
	Exv3W3wn2PdC9Rfh64ZgF5/ja8KF5zsAr7DtG8p3SfcIHvaC9//5OGhHitpDbPnK
	4gHecnzKYNCvN6UwdlKU7MVoi/6a7BS6ai0k5WVp33VZt99N85q9L4v9xw/ms1P4
	s/uFfUIxBnI4KRGsNAqYlO8HKrzT0C0gQayv4Jnp2vTrOyeIzrZBEV12bVYw3GSA
	jUCDQ==
X-ME-Sender: <xms:78d_ap-kxa62hpd5hQm1cXlXMe056Xn-eLHfFLzBUm1n4yMyh3LhYg>
    <xme:78d_aho5zG4k8DZEC48Rc8wqcpRJe99b2E08C2j-0HvCXUyrBAtKX13Bo83wFt7Ub
    T7oBlhrbihxHaBngwywPZf_IIPY1Opsywvjx5yPl2WmGodXuuISeQ>
X-ME-Received: <xmr:78d_avjr9iA-Trqt4RefBYy83Xev-ITyvfzqUAFy0Ke_u4XBpiriyppvUY4>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1UAV
    t1ky7+JLBWzuoA0+1UuhthaJDKx/AJ5gC5tRaHE4ASCIDqAo/+HMX4IhequuAa5CReNL6l
    FT6eWS0bgjZ/1y3XwbN5wvPtBBvj9u4Dat0nWRZ+88AiEQvZ0/CGMji3azaLAD5AkwGcsE
    PTycNDqzNLkIUshyvcVXUQlB9T4rQcf6mNQ5fDbD078evTC0lHYGW2tTZzGYM/PJK6M5yT
    68VA2q4x0WRNvSONYwIxcRfoeCilJAQT4wbLtdhaTwUZ9/c7I6vSuCLJwFvgcUaSuy6EMa
    15VpSFvVzkjxYHqqIP+jKjpfyh5Ltfrd2M2n3X7quhkTKwbGW+8liDZabGpg
X-ME-Proxy: <xmx:78d_anBZn-tvLZ2ohygm3dQYh9ERk0j9mEWOq886CbhilYUbNc2JPQ>
    <xmx:78d_alsHPN-EhtQ5EiCGG5fy7qLmq-xuaDT4_5MWKMVFC8VO89nqRQ>
    <xmx:78d_ap71V6ykKg7FNSXPNcW6lPLiPO5SsHqUTkO12PKa0AnVjg9N4Q>
    <xmx:78d_aneuuCn90vj2HALWKpitt6sygsditTpB7BkQotk7PrP6roEbSQ>
    <xmx:78d_auecmpPdqteajCjaytn1mX_HON41OK3eypo2zW4uZD9t8RxXfdde>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:10 -0400 (EDT)
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
Subject: [PATCH v4 02/19] selftests/mm: skip collapse_compound_extreme() where the PMD is too large
Date: Sat, 15 Aug 2026 02:58:44 +0100
Message-ID: <20260815015901.1236937-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1E24140002
X-Stat-Signature: k38btgdqgnutwbbd6c6kange66wqn6ux
X-Rspam-User: 
X-HE-Tag: 1786759151-417555
X-HE-Meta: U2FsdGVkX18Ttz9mJUgJCnjyfF8LAi6sHM3G50+Lyuq0r6vnM73Ij04gM3f02qVO+gL3/qvCjygemDztgh+xjIDUGv64RK0UUaLeCNZG4HGqzCGyCOnNzs1+5epwbcejRuRLaCN9k7rYW2ZcZKms/eyCQvv8QjgVAb8zPl4SUj9etjQ8oDZWJxiam5n2R3mWiSzQEm1cyxofTb3++DWtD7Gdf2wRztt0NqfJjzyphtajuh0l8hTQt2H2j9QkBQvUUfFnGSG+wybR6zd8j+0CJq7X8+DxaB+eztLA2DdHQ+j+37seLyaRiz1iau1qWNPQE7bXxya7njdB1uMoPmqVuow/P/BUE0mGVl9qpcwsAAg6k9fiqrYFz+HOonJ0qUXm8uhFqREPPKG+K9Tb30+jJGRa7p9WVNiqgDURcdn+sWfmq34O0kczDe9cYjxXp58K7eyPVTfKkppSAE+2ilSqNBHSt1xIS8K/zO4EWwADdve7mhIQYzw5XQxO/fVSGTCnIkqEscDN0B8I+6TxXOArNap4JL5xRuOv/Obs9TasRJ90qDFeXbxScpI7SVW1HZPWIUCDcHAEh+gPd+l+B5papNX4PmDGr0zbzMEoz6jfIQt1nv3at8o62bTfqH8QBXJwj5An3qYu/RKKOBikVDxFV224/ZG3H09sA/iPi1t37UxJ0PW83QxsOBImIcP5BqWHvJguzFkUES9B/9KpaA7866GkbKfZ7Gb95Ggs5GjMnScaMmOn6LWjjvXzuti2Eke/NvobdN0g2OWK+p2PErbh2awtTh3dkRMjYKq4oX1nA1sibS4hG87Gm1Fbd+dlyHGBlPkIlvpnkBjQ1LnMaSShpgdYMTeqvV5WCCe9m82GF3e8wpAwhHx6vz3jvQ6YzzS+SS3CJCBpeQCnDawSym/aTqdFM4vbv8HmTHNcBlXa8+WGixi0/jdB72iL5z9zpUJrxKPX9R4ZgLbqxRqhGZq
 KSdaorwR
 hXF2FZ8OR5CZez8xlSBP2T/iI6V9hYKHQ29oCgvFdt1zyYhAU+EhyxlYHNEC7OB3/N51f6vO5/YDTPLN0yW8KzPhGhdOZKbt6D3dACCVOFUZGgzUGdjmIE/DpJzM24aFezjWV26RxJ6n7qZHZAkokozzGtSCTBzwKFCOwSZqt4YYCWhjTDH2/5R0tcz9uZ5shnJCnnWQFg01nIppFS26rmhWrFaVTYSgaLzo7T7fBKMyXDUcrDGoQ5jBKY76SW3ZtmBXTlSPOVica59GgBULL48nW4qotg0HLaDfADVbFEaL4FMXFKTe5FxhzoTfUjrDE0l5TciEYtmmFe1MhMGg9muLBVgmImjSNXAQP+jwOud9MqD1O2d/a3yj69pntCKc4heepbR7v5gIJgIFNB/YncqqFooFxju3md9nSomhTebXDie43Ib9Qw1CLRWSpPTcL5F0Br1AmzHRhVV1hUJrVwQ+iXv7ANBuf7iCIJV1c3QYovcsBVwteSwRRna0hFqZpZHm1QyIqMLzkypg49WdFT7sfivinruePB2+cTDyAdm7WS40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
64K base pages -- makes each of those an order-13 allocation, which the
allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Assisted-by: Claude-Code:claude-opus-5
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 6cfec2b940ac..dd924edd8557 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -940,6 +940,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
+	/*
+	 * The test needs hpage_pmd_nr PMD-order allocations, which is likely to
+	 * fail for large PMD sizes.  Skip if the PMD size is over 32M.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-- 
2.54.0


