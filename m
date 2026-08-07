Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B51C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913596B0088; Fri,  7 Aug 2026 07:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB376B0092; Fri,  7 Aug 2026 07:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7306B0088; Fri,  7 Aug 2026 07:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5834C6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:36:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C26FE403B2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:36:56 +0000 (UTC)
X-FDA: 85074271632.24.FB9BBFD
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8107100009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:36:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o HsHlbc";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="FK1/zSah";
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+ra4YCar9dQSq6xe2qyml8d0zrOh7Pky3vMj7voUQ8=;
	b=y2HDYSpVEqU0ngRtimJrlkDItfniUCUm/SSOM6afFKP/xHzEXv1RddBfqgvjcAdI4nogBw
	SWcco4UafUXhbprUWaJrQTo/oA/OY/GLYQIZVQjwsTOrQdreTxVqhML6UCLeC+ZKUPeV4X
	OOndsCBaJbwRgANf+jtIK8YqGfkzrkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102614;
	b=y6AfcdeqgsrR7IfcQHVl/7VpCfwpa4seqm30AHU7rukXS9Y4PYC1323jZUoxy1Oj5I2vW6
	0ofbnbyjezhA5vqa+aQj7pWGls7R/12AEk41jrWL+bw6E2dktfPNbwqurKpEt44iK+Xgk0
	aRqGhb1hRwQFiTJ+K1pckGmTSho6jEM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o HsHlbc";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="FK1/zSah";
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id A4FE21D0008B;
	Fri,  7 Aug 2026 07:36:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 07 Aug 2026 07:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102613; x=
	1786189013; bh=d+ra4YCar9dQSq6xe2qyml8d0zrOh7Pky3vMj7voUQ8=; b=o
	HsHlbcPm4TPT5V2t2qeaIXKgumuPdLRSljW5ZyuFUeNMRRNiJ5TRNC+51iDmTJZv
	myUE7guHJp5bakjQZ0gkjsmJukt5wBAPA5DD5rc4WRjXP+s1320hrkhkjf37FZSV
	o3TIFp2CMr9A/0F7rALfI4KaP9qqgVoLCHDttTN/8BmFQ8nI/jXr1q06O4NMeYEl
	BAAk2vC6iI+Dv4y8bGcw2tUytncyjzAjEOvMGVLLw+hjIQKjE6pkQvK0WamFhy4w
	znfg9A3E3khUQLKrWgV7qcnK+izqGIwb4oP9kiftchu9bi9e3W8rHLAmP3bHh+Ci
	Gylxcjd9HGhHdWiuwZxeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102613; x=1786189013; bh=d
	+ra4YCar9dQSq6xe2qyml8d0zrOh7Pky3vMj7voUQ8=; b=FK1/zSahaOB/v1MOw
	9AdAbCYB1I9xNiJmn25A9Je6ahiyNkuDaXpOLta9nl6sidp+t2eQblEwZX8YymV5
	fRciC8/FLsCQ0nlD5njxttrcFATJZh5p40DuigFktcRJNkBS04c7mjNzk8fxjrMf
	EGUDJ7DW8xNftDl3z9ejZbI0wxThaTGMfSIiyYNPWEs0i216b6/C9iD2+aP9siSv
	PzdfhNy5dCrbPttPVDNHcUeH3KYKsVry6wQXwskN/8bZslo3+Zu9YXwY4F7liIww
	dXfL4Cu9Gy4i3yFjSlnUuCk1bpRyJifg0iegWF6YLjuH+cEjUOeDlyPCa8PqDxql
	AIQ2Q==
X-ME-Sender: <xms:VcN1avW4nGEYBrixT58_BKhy7hYa5pDkn6ieAFFUEiY3hQ5WH9ZWJQ>
    <xme:VcN1argl7SP9FX0gLIwoxrgS37x8G7r4JbD5k4McWUYGYJfAdjsFp5OIkGL9LsMhi
    3tA_ln03RvADj5cF_nQ-zfBftW4g9qJsNl1Lwmlt81wTrgljIvn6CiB>
X-ME-Received: <xmr:VcN1aj6fOfpto0vSXSzze2sO665xaqrWd1UrTjcAqUMpUzoCBCk2Q6Fq7Lg>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQad
    Lkl9l51BZdRN70Hk63ufcfU6wqwALAhmqOWouzSC7gOij5TvqfnKy6ADG69lfLUgh0lpiZ
    kAUMRLbDr7XMEEcGo44022nvTc8uJNyhrilK5mNWJO3DsLD2SyRs7E7w7dGrX0w6ovYG6B
    wSdpqjibCk8XQNAn03/7eeAntRw7Jwdq3BxVqzuXY/1OJugBvTCFsmhWssqxoMw/1yXSUs
    dGRfegmLUWJRDkapVnaicCMpKihTv6gkRRtJStRI6Lxcfxfvo6ULDeXqPAprLZku+PYE6A
    ojgmJhnV9GF9r7CxueRcqT2zEmqwX7MIi7lOCAc0ZCKaDOxqgp5Uizip9y1g
X-ME-Proxy: <xmx:VcN1aj6SnlLxK-Xdmx-HlJDzLgIQPJ718KekgMo7hvBeaBOxIjDZRA>
    <xmx:VcN1ahFL2AiSBtFDqDODch_D_gsDSukyFPPlygPyolexJZUivgghsw>
    <xmx:VcN1ahxOfgiCN_K7kpiHr0ITn_UcJH8nKsWVjSN2vARLZQdnBvvDKg>
    <xmx:VcN1ah2QtbGIYF7dPDC5p0v2PTlHOE3uMUJ0m6WC1U-BeVKIzgWwXw>
    <xmx:VcN1ap3ShQiupWUDpUYFHH4RahAM2h1EqYVugX3ZoU1hEqhXVCsJPUEG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:36:53 -0400 (EDT)
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
Subject: [PATCH v2 01/17] selftests/mm: skip collapse_compound_extreme where the PMD is too large
Date: Fri,  7 Aug 2026 12:36:31 +0100
Message-ID: <20260807113647.3744609-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8107100009
X-Rspam-User: 
X-Stat-Signature: 4kg3zp75kwbx4yu1wibcgof1x33ic1a3
X-HE-Tag: 1786102614-684138
X-HE-Meta: U2FsdGVkX19eKwGLaE37sNyG5ESe6VwD/byWGPfGUR4Aw9a98UhEku8PtVD81SRzS6BttvXA2bP+Fn998cke9JmuD1x4vp+iRpXQDcM4gfbNbMaxMagNDSA2tD8PGEZp0A34rIP4SzdunDFEqu1y4ciWSpq+8j3cPwv2Ta/0CLbPzZezZZ4ulIWNzc+DzKLyrEH+EdQvbgzs1MatIInzcdM5TcDRV7Y9sJzjXAUj1zdV3JM0tYYrK0eftoGBsq3yB91S3iAX0dOBKc8gXhbA40v1DwmVG/agm2dzpMupFruGHU3aB7vBy/DN1Xwrl2BKMDioMHmNPRXX289R3hGvl0Q8ZjOLqsBNhp3D8fs9Mhwl22yUK93+hlD392Ep2ihXg7iNeEsAcpln8iAApKix9n2LvZgcFUDE4DAJaajdhOZFis8HGPdXxv/e/QBVea2B7jeaNMUk15e1oAPgXO/+808u53BTraUoax8nw3bDLh+/fYwl0xnSjanVBJGwX5AJ8WmvtZ1yhjg1tbQb/Zc8SukwHQMScFPxwgjMPu0G3zb0tpAXxdSWcvHE3YfvEIz2hSsZ9T28fWLge/K9ZMX2CFyAbKgrU9S89DSYFsefV9QQN8QIBpLRbG+bENJed9mh/VLiazrSLRdKtzBtd0ni5qBEconURre4XZDpbd1HLpMgXwHgMb6UoHcm+qYdxNBuWvUefkeJXnptz3r+70wYx2/F2ROMsl3lZzo2wMCycwYN5qOsejRa87tYSEiXV/aPkA8O0EeQxsh+9gjpzmySal4RK7ixKYIJc0k47xyLBQ5fH9SJp83lm+og77fsZupF3uwQQeTiU2hdMAsR71AHLAbdu4m4yAya7DqEIyGQhXtM2MTwz6nm9/Cr/z2+IGnWJ6vFgm1/VsQAFos4silwxi+QExIAz0YjuWm+x80qVFdF1IPQ0qmi3a+DZicJs3+72QPSaI+2qVxPMov5YRv
 sZGb9Hab
 wZkn/5BeBQwKEMMO2g64Znz+PBNZyAcNnqLULGOjcPIZ23ChzMQ552SFutlozs2E2oKWuWQgxeb8jQw/WUHFtzRB6+IorliNCK2m5XQROI5JqErOghSYlYJpnN5/ZHy20DXQ0V6Cozuo8RBm85XypFiP5BaKaOLwjfcIdFGNqGlcIvur5L7vqqzeARNCcT1845vxrcVMRW90kI/6+Ue4kSMsblA4Y/HIu5Kd2wScgKOjKWsGCofDi9ErdZhqbNB2K62MVFOzgBaECjeBo8tvKRbNAWECKZwqA6eIYYFsKQD9UK/eW9W4srnPWE1uQm5IhNeWGkwAoDQEVAwVMNlqy0TsWSx7xELRAfV7SKyoezkKhs4hTHpw/01013s0Hpsp1bULwclUTqHmdepu8KbIfzkx1/R1v89D1a7Ir3jHOM0XLoIewu5zNGTo3EAZ0hCPj2G5OTFPJAYtP0TDNn+9ObKGD1VOJ+I+LtANbR/syCaoUeAR7+bgRXqAybA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_compound_extreme builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K), but a 512M PMD -- arm64
with 64K base pages -- makes each of those an order-13 allocation, which
the allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 9a90ff5f484e..51fc1f04d0a0 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1007,6 +1007,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
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


