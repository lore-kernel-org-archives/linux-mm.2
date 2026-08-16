Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27079C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E216B087F; Sun, 16 Aug 2026 18:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7F76B0881; Sun, 16 Aug 2026 18:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488566B0882; Sun, 16 Aug 2026 18:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 170FC6B087F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F18B4042E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:10 +0000 (UTC)
X-FDA: 85108619820.24.0536E89
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id B561540005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P fcUTVD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jWnfKufM;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c6dedl3WgtUFb9jPAe2ESc5CIX86porar5KZcsrzYc=;
	b=RFtDEZ4nqrSmSBGEjyq8ZSWnqLpnulN1O0hBmeTzPYkyBx9HoZn6nv3rW5Hb+tkRgI33HE
	e5c2ucXod8anYdSqRNHxIuc5OXKt9fN8Q1isIUv3KQiPPLhdGBnLJpOhgoeEof1v2c8MMt
	aKexcKK/DYzAx3Do60melzHTrpArm/4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920428;
	b=U7H+JeFTWFMsSqdDu9Ag75TWLJrwN61xXVo2RHSIDL/XEw7uUM/W5H9GSsHObxLwzfqOVj
	bCKtxU/DiBpsBVrWKhl/mGYPujIjUeV7G7GHOFilquGtut1M+1FM37ocrSlKOMcDT/jkZl
	q5dESSGaTkuj4/na8dtcXbSHmYOaxSM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P fcUTVD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jWnfKufM;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 4E99CEC0235;
	Sun, 16 Aug 2026 18:47:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sun, 16 Aug 2026 18:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920428; x=
	1787006828; bh=1c6dedl3WgtUFb9jPAe2ESc5CIX86porar5KZcsrzYc=; b=P
	fcUTVDQ49jpV/be6XprUQPnuAOC57eVsBvEsEnAEKcY0dsk0NQFcmbVG0sbmdIZl
	vs8ID/LUhIWEV5y8c6X/pgtS0sR7AGXUaW7g3jR82v35F9itQhU2cyzyFf63iY4z
	GpW10+8BfZ6Grc84rLt4NcRphubImU6GCxhiyWrahqU0kH/hWzYfvd5yPZgCaDYZ
	zV1DeXVITKswJ+W1gn5IllQkVfR9EMmDWDKtmZNN58dDhgmIR3B120MvB1qUu+pr
	d8/SK/JeQCewCxxSWx5sqi+yal7QaWawnuxZi4XIQw8q0a56HC8WNOvNxjtrL4Sh
	Mnz5o5fcRpSPwEROnfOdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920428; x=1787006828; bh=1
	c6dedl3WgtUFb9jPAe2ESc5CIX86porar5KZcsrzYc=; b=jWnfKufMiTHYpTqhy
	8/7x3lxyBFDw/VOiuKQk1ibqBd5vJdZMzpNHMlWhyile4+KrhO5OPk+vSxr1DEol
	W/LQjamfvEHNoqnOZU/iUFRaAbNz6eH8z/Z1jh+9+sfJZHTTcHGwgrr8AFz4sppl
	WR6rYXRNFh1pCQbFUVrCOizz0Q4Ij3CFVTWC13w+IJSTqPRMRNWLInF3Bam8Y/Q+
	cR+FAuNbMdkwERhB2FY62z2GKSew9MT9dmKrFD1BZwCLKONxWAsshRa8uyR9NNO9
	ioKXO+lmu8ZP6GjZjsWkeDRu+x0jROQtHTb0BFWHub8HBgga11qL3AYmcD5ex3VX
	6Nf0A==
X-ME-Sender: <xms:6z2Cap8GW3CABI26Vwl45FSXCm2NfRYG1U55xWufEtJWWoviVl34-w>
    <xme:6z2CajDhu2UfXQ_m8PIr5vA47qPlwnuJ6SXS0IJxm8ezkKImKTM6u5HAnp02tyBXu
    INPC3Fri0H1rK5CNiQkvGkYnBMVcUcY1KEECUzU9V0RL2IgVDXcKZtm>
X-ME-Received: <xmr:6z2CajH5XbJG6aNaCODbOUE3T9ka0pQMBf8xMQgHQc_vLEy4E1ry4iiaezU>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFteH
    4aM8NKpVy6af3VJibLjmcthP+/7Eaj5TPpEQ+vEDAUYIkWdK+ywgMPzRIUnik9fpR7cN7f
    bjkwqvsizU8qA3PCDS7V7krH7+iKXYe5Hg1M4iBEcouwPVEwlyarcK46RRrbYWTslsvg3b
    8BxETdBe/8+AXH8UuDZEwRoTeZ6Sk9Nqx/4bSAJ0WAYgoUD2lbzIpPDnAGEFI5TsE7Rnc/
    otYH6+OJNrWmpfIFm9pxbzF5fJxzly2qMTts1jVR1CnQc2+liXZQT+8k/3HwwuwlfNmq53
    zldbTxNq/mPU+OrhxsdMvQQUI8vVOO98rzAuQrbTusleoWDxxkj+W6cyhFJw
X-ME-Proxy: <xmx:6z2CaqACnnRJsWgfUhIL6TWOlfK7344uX8ynxyQYM64ZAPnmfU5pBw>
    <xmx:6z2CakcfhMhNLqlLhqmmKbI5nFs1P7TOx0qbppgCu1Ss8T-FfKOHtA>
    <xmx:6z2CapI50IsVDcA0mA55Yd2yq9EnOFBuY0F7PEz8CqPEKNH1skDwCA>
    <xmx:6z2CatsDwqb3v-50XhzQwHwSOy5KC8eOx0aar_NnxMzVfWkwUKmCfw>
    <xmx:7D2Caowi01NFb0kYUsv8Ju5-mdElUju1wWPGnrRBf1Q11NyuAsFo1RzQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:07 -0400 (EDT)
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
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 26/57] mm/collapse: give collapse_single_pmd() the range to work on
Date: Sun, 16 Aug 2026 23:45:38 +0100
Message-ID: <20260816224609.308019-27-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qdokad3ex8isw4ugrgzkgm1heejpc56d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B561540005
X-HE-Tag: 1786920428-328341
X-HE-Meta: U2FsdGVkX1+TCU7/7M9LR4+AKULlkoQahvJik091onVRZGpBhqTJgWF63tt1MihF4VOUZGdRCfhIZ2HLpf1zlmQdYbE+OehefG4HjuQAgYWnn6uzt0BLANwk+MiRgDO9z60gOz4Hrlk8DIQg4YKlmG1Nh9q06PnHanEIq4Rski6aw/IejP2O7r+Ti2HlAkkqvpxMlhW/KI5bZEKyQqpJkNA3JtXi6Ey1K+l8R+gAl+0RvOZ+S23O1RVxbIZ456TGj8C3gwKSXxAmnfpwHnHsOaXL6Ia77Z4dB8F4gc92ua1pAWfYEjm4ace2OGb8n9R8x0C+vyrBnPfn9MQcjfIDYPszyrfNAVsWdUk5La3lKMgSB6Ztsj+wnIxVVM9iFOvoEZ1IWRRu7SJPQOYpEvd7TJIH/KtULkuSKJJcaZA/UP8c+vI3eTjlvZ/pK3DtvFxTbaczvdnbDpuXK/SnYch9Km+90g9LY8v0iKEOz1MNQ7SBeyg46G07T0hEuVcp6sKV+Z6uzVH5dDMZYclGcMO9AGVXYIpZUj68GBkrSxlTUQ+4XA9TJ6oHvHPwiZw4UlkdE/EmA7lTVnvA0qjXV0LRZvnnO5Lz2TvY5zM2pfM0eXn1USqQ+sUawVUtQhxJsSkz/G+P8soEz++XQx3hZnL9UiyMdlTlmcAdRAM9kZzokT9KN+mP8iPF25oq6CAHJ8EP/ORrJVft1tllgzxZlv+yNXy6i8GZr1fP2p9bl9xlOWjx1tmFyNnwZfqDwwxa4xHUAq5Kh7AhJg2MGpXqv4nLDUvmI3jvpmkMcEf/qpK7BoAE1FfV/8b+mbbldET8jMCHuR2zHO9XLjFAIbkw2zl+iDUPjG76p/j4yyxZ9Lzf4JQbBAMFlvlvrzRttltWvMRpbaMlMBq5BjBTKkrhrPbW9+B63BA3+7K+blqcRO3CxvfLRryTbD6c2JT1virSdp0pxKpGro3D1BYMC4zWZWL
 UytKsP+L
 8A622av2X/lEBSxq4PAynwy8iYbbBiTTs42tFOARzfNe63s9IugSvkGWEuEa9ioD/bb2arsb3KQdP1dMCZM/w2PJWA6gIAPZa2uo16cWsM5H26/mCOsHfXmEkFSyUs1jjYDycwdxAoULJf/0DroK5w3KhA+/7fSsmY5v7SuLEirbsVrjOR/LbAR9uzlj097o4nEsKHTXtBg8jMSS8r7OAnAVZtwHO0A9kOfurBYp+mBl/NUSwJmRPNuxHYcgp6jc0+V/qZmJ+9RMbCA+bc5BkGBBtd+qbmDR83iOs4FrjhJv82mm6bgia1TQndRSdfeCTzhXq68dO/R4hk9ZtrLaRhZm591qUoDgzyP4br6LV7PSJ5gnX1KY4JP+2t9lqJ0okTkcRxLdQfMR0/GJ5wa6EFh/klNMzNsFjHVfIuPYgbEtb4HJylrxo2F/zYgaSSYET1sNDc1kqRQTWPFKUw8T+0BsISCkkZ/gAZYzBvrctQ09efUg8DISerqxzag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() derives the end of its range from its start: one
PMD, always.  Both of its callers already know the range they mean.

Take the end as an argument and pass it to the scan and the collapse,
both of which already accept a partial table.  Both callers pass what the
function computed for itself.

Preparation for scanning a VMA that holds less than a whole table.

No functional change intended.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0662d08f7c60..d1e031ed3e6f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2738,8 +2738,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
  * the results.
  */
 static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+		unsigned long end, struct vm_area_struct *vma,
+		bool *lock_dropped, struct collapse_control *cc)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	bool triggered_wb = false;
@@ -2750,8 +2750,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	mmap_assert_locked(mm);
 
 	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_anon_pmd(vma, addr, addr + HPAGE_PMD_SIZE,
-						cc);
+		result = collapse_scan_anon_pmd(vma, addr, end, cc);
 		if (!cc->select_orders)
 			goto end;
 
@@ -2759,7 +2758,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		mmap_read_unlock(mm);
 		*lock_dropped = true;
 
-		result = collapse_anon_pmd(mm, addr, addr + HPAGE_PMD_SIZE, cc);
+		result = collapse_anon_pmd(mm, addr, end, cc);
 		goto end;
 	}
 
@@ -2872,6 +2871,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 				  hend);
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
+						      khugepaged_scan.address +
+						      HPAGE_PMD_SIZE,
 						      vma, &lock_dropped, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
@@ -3211,7 +3212,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 
-		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
+		result = collapse_single_pmd(addr, addr + HPAGE_PMD_SIZE, vma,
+					     &mmap_unlocked, cc);
 
 		switch (result) {
 		case SCAN_SUCCEED:
-- 
2.54.0


