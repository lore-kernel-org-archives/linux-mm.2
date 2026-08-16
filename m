Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542D1C5DF70
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52336B0885; Sun, 16 Aug 2026 18:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D316B0887; Sun, 16 Aug 2026 18:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DB16B0888; Sun, 16 Aug 2026 18:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF3B6B0885
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2C761A060E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:15 +0000 (UTC)
X-FDA: 85108620030.20.C713769
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17C65120004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N zmo2MU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cPw1clLh;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4o+UQoQZuN2LWwiMtMQO8gOWSU/QLCCuxZH7iTS8uU=;
	b=AtSsCwCa972Mv+vn6Qj6hoJTN7RcHCATWUH8Hvzth6q2vr7xlddjw8sLGxl0rzXq/BKmjt
	7Lgs7GRrtv0X3fLHEiaKE3LZQ8aLjIe8HpFfjhK+XdU4RN//nQy7P6Rd13eWBJhUPM7PEa
	L2PMGijijuphYCUZ3R7JvzxTCfqz9uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920434;
	b=HzyMJ7K/Z9zQlZJDpz0JQqjJxysOhqeda4GrYo8elKjoEAOrkmAUFIWfvtD8hNyEHHMJzJ
	xabZcOYTs3bQnHHF30AbeTJoqjixF9cs6EA34DC+kcmuDG0J6QCxTGuDmROh8413SdUkVO
	j+oR71N1QtAxaHE2g60fD2DBUscyUKY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N zmo2MU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cPw1clLh;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id A1C33EC0241;
	Sun, 16 Aug 2026 18:47:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920433; x=
	1787006833; bh=v4o+UQoQZuN2LWwiMtMQO8gOWSU/QLCCuxZH7iTS8uU=; b=N
	zmo2MU9TZwrrFRAZ6xGNylCaGbUonvBeA/xtuSMYioyuvFDLHSIkGp9ynrpX/LNk
	7cKrZXTFjSkDIQvlM/IKGNuMy42XDNj73hPmv79SntLIxYKwCg2sGRUpHEq1BUSq
	HaurKhr1NuNDOKleEDWdn4tS+8Lpksv31G0u2S0+rkxPM9TDwRneDQWVxVF8iRna
	Rq/4eS2CPbjoAaerlyjGFwP4QOUjUvqmhbd5ANkGUC85hZd4PW4ddcInBU9LeAQX
	LjLMy5fgedqxFG6hWYHZXbV8W/FiM+xQvgUXY17mYC7WD/CLqgnPOuBtNXVveFUU
	bbBAAhxd9NBZ59MvVDClw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920433; x=1787006833; bh=v
	4o+UQoQZuN2LWwiMtMQO8gOWSU/QLCCuxZH7iTS8uU=; b=cPw1clLhWCFCWDCZS
	eKIgUsyQawxGxJvSYFl3N6kirdJFd0ho8m3Eqa6wrgy+YA6Hp4nGh0FvyoicjECL
	YpmeWK3qAeMfnCbxdNUgJaBBljXKMVawJztxRg09Sqj/zdVCSRTJ52w8mzfYy2dM
	9xjh9Bbne/DfZCp0LPW2uMQtmSR5CXuQZn1yiVI52TywqYBt5KNHM4XBK+4wcDW1
	Zt0wV7Xn3DOhcEfanGyDNG3DREcPIuSkU2bSob4PN7ICfYMzmlDIU6bX6QxYjZTT
	/LWQ6eue81Dn3kfxq1NHvLs2Yu6CrEESW0ezOKfRn2Iu6/w540Zkw6g6RgZdBMX3
	KVisQ==
X-ME-Sender: <xms:8T2CasT8iy7zqMjUTD8h3KzaPjgKOGCPyWj0nq0r-3yyFuLnVpyxuQ>
    <xme:8T2CavHs1V3iunHwsXuV8cTt05rkwJq0fQuMQsCcYgaIHHarBtOt2Wm43rGpEyMbY
    p_Wt6zv7xB6u21UzNoZyLU0jf6N_YPeGSvocGkk1m9HC6H1aDwW9JBW>
X-ME-Received: <xmr:8T2Cal5g8O9yNxhrPLYdV-g8VrgwcpxhtycuV6qL1K1P-mQpS-khjQFbUig>
X-ME-Proxy-Cause: dmFkZTEDk+RLLWMQ2xmtz+SLrRm4SAAyqR0dcBO/jFiSra6UqVmtacLBiFsIEc4u4O0k4e
    TprFkQPKvch8mvItdBrQvHbw0cB+L9AXDq7j8E1YHObaRHu/NhSSUGMahPtwIv/D6P/2Ck
    /ZmAzcEVmv8/4SK/QQlss/OdD6ZYE8aT6ou3Os4qcrsJTku67URPEU5YsnAJoGYWAjn3Up
    7SKj7HM1m+Bk9heCO7PBXLylkVDNPLNBQlGmsET8D8iA96BjDQqliz/FRaUJqsbc23hZYK
    6FfmpWMzIACF8l0zIVIJGtLfQU4v7CVbie56C+ilpPey1dPs7ANiSUKA9aUYDcXfVHEKt5
    QL+mvNaMseb/Ht1UO0WB56E3iZGzyAOebwIkEOYKQzzqtStumThDKCMbnt+pabPBUCi6C4
    i1X8mX281nuQJE+kMOftIZFvYGyVcJ4EZfk7iq3IwS7NuqcYuxw+BjUBjNWCnYNXKe3ykr
    ajmbjgA95dA0JtaZDAeNOemV3+7uqoirAmx5+CghSeFHgxZC/NzlROWzFMZZ9a7SEjVKov
    CsevLGiDtRPJplVpKu9iUjOIQlaE4smjKTqMP5JqBu7Rj0/yeqEqWcLhYu98GV1a7O039C
    yStEXlYF+K1jnN4lvNCMC8uN6vMTMzcxa2dkpBw+3kVFpSgx8l0seglGw0jw
X-ME-Proxy: <xmx:8T2CasleIljLbczwsgJmWXki19zmR_jslomsxAgPmA-a4jvXUw-3Rw>
    <xmx:8T2CarwyeBa3U0l3ZTusASOq92-AXEzl_l7FafO3yB-5GXOsuaKzlQ>
    <xmx:8T2CamOgE2xu3Sm9QRcsycaDvCGDJi-oV-oqtHDOVHddfkMVTjojAA>
    <xmx:8T2CatiQgLhSzz9d3pvfgf9SDe_1F7H9iE6M5NpzNQB0dlmpJ4qxVA>
    <xmx:8T2Cau3k2QpKg3ruNjpKXblqS2EXS-KfIjm6TdGH_q9ulZ0T3hWxB2-A>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:13 -0400 (EDT)
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
Subject: [RFC PATCH 29/57] mm/collapse: move what a collapse is judged on into collapse.c
Date: Sun, 16 Aug 2026 23:45:41 +0100
Message-ID: <20260816224609.308019-30-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xxqobup7n93p6e4mr5yj3giwgzkqceun
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17C65120004
X-HE-Tag: 1786920433-161028
X-HE-Meta: U2FsdGVkX18fBX1s+2KhdhxE/fByxVZIHJ0f8mSAjV6hz2SYoxPk59jwMD/HNGKK7AWv+hXmmHE2KylMFtGQxVjJ5wwHBY+Uu4igslwUXqge2iA+I64YeZXCislpFDo5KKbsoZJJjNbB1CL3Vp8Hu89kAU6E5mX/BtfH65e7c79HjFH34YFDMrTSQtvvAvvS2w5mDGZ+2dVyC8e1DkdgMfNTtmWjqZru3FCvCT2VotlO1vw+Rc8n5TnOtu6m3H224iLTeCcHxQcHWsCZJY0849TdrkY+SVlgD0jH1bxy+zAsZMOhy105Kj1WThqGl3TvYFV+2brhxROqXNnCPJBe1nuzV4k66ZGYASVyAaz9pRBHVSMSvq5j07EUN/+CqFZMEqYBXWw3+J8HCgFdkksuVACEJsbtDVhCSxPuXFcziZ20ROytRiK1670yQyBoYmkOwyEairLgQZdsMZUMvEeK29C3V912bcMh26vAzreQXiNTbTKJobi4HbwpoPT7O9mxWMRSi7wNvEFDQ+kFfxzD73VxWISOixhxg+lcWpC0Y331WowNl6GsOb173sQyGvSGvjoWsdxmbAKw579lUujH5StK1VR5mqJ9WGnijLAjkwc/HgJZL7dkuVd5N/7FOOCPyfpwi8XUibxdlXAE+lryxSSVXFXq8AiJji8KYl9puBe0ksFf2GuRMPipCJEHCxXGQ2PHhxLFV2rSzP8bY/pi8OGdVimIxN9yz62ImaDiIkayyjf2m6hvG5NaXIh+KIjHtsIBDtRzeRc7XcBg1qRpXtbBiDs4yo3aFCQ7lNLvNGunlsXsTcmo3nj+4t9AlfRFMArgoKTuo47TTd79Qo1sncoasf0lKc2PLqpM/ZgdRfawIWPOCTpzbfW6/0+zi3hgenjRlNAoqkIUc1vawgc5VCv1+bDbTHjp+q2+7wSZPYtvpAMCzOX5Ts/X/Hl7MLEhtiutYc25TSluXiYpb9U
 c9ri6PUx
 VADuz2M4b7dkJqIXN3J6BuVD26Il69SBSZRc+AsvzMxdZpX+VchZt3/YtJ/FMfr/sswSX0Wxqk8rqLDKVzibWhJRAODl6rQ6IsLn/+ooayoAbAGYGFxe9KoyMYcXjJMmc5IxFEiatah24Nr8TVwuzLdkPK8uEwzdnloRKIE2I4sr96Q5vYWt3hpoh0D6Y6DQxs+3owwXPVE8v3prdJNJQ/VGmgQ+VqCFJZQwxy1a1MNu85eMA4S6oeq3pHltE7pD0k6GWkMf6kFizkBqMT+Mm0Jj/9av/A225IMesHW15CVgXtUtiIgE9aCm7YUT4ZeJ7IugqYjxRt45PM4Z2ykQoolgF1FvrB0wuHi9luTr9CRguV1btrRi1H8/xshmKhDCSnByib8wGD7dHyjpaoEmofaggSGhQ1GJcowz1rGgpRYJRTP5ZrEdtpsiZrLA8QVQvGiW95Ii6fOXZ9Fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse.c had to call back into khugepaged.c for nine things: the PMD
state checks, the orders a VMA allows, the per-order limits, the NUMA
heuristics and the window alignment.  The engine therefore depended on
the daemon, which is backwards -- khugepaged is one caller of a collapse,
not the place a collapse lives.

Move them across.  max_order_from_offset() and collapse_max_ptes_shared()
have no caller left outside collapse.c and land static; the rest stay
exported while khugepaged.c's file paths still ask for them.

KHUGEPAGED_MAX_PTES_LIMIT goes to collapse.h with them, being both the
ceiling the tunables accept and the value they read as "no limit".

Every function body is byte for byte what it was, and the dependency now
points one way.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 187 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/collapse.h   |  11 +--
 mm/khugepaged.c | 189 ------------------------------------------------
 3 files changed, 191 insertions(+), 196 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index df3760e3918b..43a4b771bbe1 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -113,6 +113,193 @@
 	min(COLLAPSE_BATCH_BYTES >> (PAGE_SHIFT + COLLAPSE_MIN_MTHP_ORDER), \
 	    COLLAPSE_TABLE_WINDOWS)
 
+static inline enum scan_result check_pmd_state(pmd_t *pmd)
+{
+	pmd_t pmde = pmdp_get_lockless(pmd);
+
+	if (pmd_none(pmde))
+		return SCAN_NO_PTE_TABLE;
+
+	/*
+	 * The folio may be under migration when khugepaged is trying to
+	 * collapse it. Migration success or failure will eventually end
+	 * up with a present PMD mapping a folio again.
+	 */
+	if (pmd_is_migration_entry(pmde))
+		return SCAN_PMD_MAPPED;
+	if (!pmd_present(pmde))
+		return SCAN_NO_PTE_TABLE;
+	if (pmd_trans_huge(pmde))
+		return SCAN_PMD_MAPPED;
+	if (pmd_bad(pmde))
+		return SCAN_NO_PTE_TABLE;
+	return SCAN_SUCCEED;
+}
+
+enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+		unsigned long address, pmd_t **pmd)
+{
+	*pmd = mm_find_pmd(mm, address);
+	if (!*pmd)
+		return SCAN_NO_PTE_TABLE;
+
+	return check_pmd_state(*pmd);
+}
+
+/*
+ * Check what orders are possible based on the vma and collapse type.
+ * This is used to determine if mTHP collapse is a viable option.
+ */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	unsigned long orders;
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+}
+
+/* Return the highest naturally aligned order that fits at @offset within a PMD. */
+static unsigned int max_order_from_offset(unsigned int offset)
+{
+	if (offset == 0)
+		return HPAGE_PMD_ORDER;
+
+	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
+}
+
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs or PTEs mapping
+ * the shared zeropage for the given collapse operation.
+ * @cc: The collapse control struct
+ * @vma: The vma to check for userfaultfd
+ * @order: The folio order being collapsed to
+ *
+ * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
+ */
+unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma, unsigned int order)
+{
+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
+
+	if (vma && userfaultfd_armed(vma))
+		return 0;
+	/* The limit as given, at the PMD order and wherever it is not capped */
+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
+		return max_ptes_none;
+	/*
+	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * scale the maximum number of PTEs to the order of the collapse.
+	 */
+	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+		return (1 << order) - 1;
+	/*
+	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * emit a warning and return 0.
+	 */
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
+		     KHUGEPAGED_MAX_PTES_LIMIT);
+	return 0;
+}
+
+/**
+ * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
+ * anonymous pages for the given collapse operation.
+ * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
+ *
+ * Return: Maximum number of PTEs that map shared anonymous pages for the
+ * collapse operation
+ */
+static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
+		unsigned int order)
+{
+	/*
+	 * A sub-PMD window held to the strict rule takes no shared page at all:
+	 * an mTHP is not worth the CoW-breaking.
+	 */
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
+		return 0;
+	return cc->policy.max_ptes_shared;
+}
+
+/**
+ * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
+ * maximum allowed non-present pagecache entries for the given collapse operation.
+ * @cc: The collapse control struct
+ * @order: The folio order being collapsed to
+ *
+ * Return: Maximum number of non-present PTEs or the maximum allowed non-present
+ * pagecache entries for the collapse operation.
+ */
+unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+		unsigned int order)
+{
+	/*
+	 * A sub-PMD window held to the strict rule takes nothing non-present:
+	 * reading pages back to build an mTHP is not worth the latency.
+	 */
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
+		return 0;
+	return cc->policy.max_ptes_swap;
+}
+
+bool collapse_scan_abort(int nid, struct collapse_control *cc)
+{
+	int i;
+
+	/*
+	 * If node_reclaim_mode is disabled, then no extra effort is made to
+	 * allocate memory locally.
+	 */
+	if (!node_reclaim_enabled())
+		return false;
+
+	/* If there is a count for this node already, it must be acceptable */
+	if (cc->node_load[nid])
+		return false;
+
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		if (!cc->node_load[i])
+			continue;
+		if (node_distance(nid, i) > node_reclaim_distance)
+			return true;
+	}
+	return false;
+}
+
+#ifdef CONFIG_NUMA
+int collapse_find_target_node(struct collapse_control *cc)
+{
+	int nid, target_node = 0, max_value = 0;
+
+	/* find first node with max normal pages hit */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		if (cc->node_load[nid] > max_value) {
+			max_value = cc->node_load[nid];
+			target_node = nid;
+		}
+
+	for_each_online_node(nid) {
+		if (max_value == cc->node_load[nid])
+			node_set(nid, cc->alloc_nmask);
+	}
+
+	return target_node;
+}
+#else
+int collapse_find_target_node(struct collapse_control *cc)
+{
+	return 0;
+}
+#endif
 /*
  * The saved-PTE pool spans a whole table.  The byte cap bounds what a round
  * holds, but not what one candidate does: a sub-PMD order goes up to
diff --git a/mm/collapse.h b/mm/collapse.h
index 50a9d59bbf03..2fdb6418653a 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -7,6 +7,9 @@
 #include <linux/pgtable.h>
 #include <linux/types.h>
 
+/* Ceiling the max_ptes_* tunables accept, and the value meaning "no limit" */
+#define KHUGEPAGED_MAX_PTES_LIMIT	(HPAGE_PMD_NR - 1)
+
 /* The smallest order a collapse will build, and so the finest window it cuts */
 #define COLLAPSE_MIN_MTHP_ORDER		2
 
@@ -194,22 +197,16 @@ enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
 int collapse_control_init(struct collapse_control *cc);
 void collapse_control_release(struct collapse_control *cc);
 
-/*
- * Defined in khugepaged.c, which still uses them itself.
- * TODO: move each into collapse.c once its last khugepaged.c user is gone.
- */
 unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags);
+enum scan_result check_pmd_state(pmd_t *pmd);
 enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 		unsigned long address, pmd_t **pmd);
 int collapse_find_target_node(struct collapse_control *cc);
 bool collapse_scan_abort(int nid, struct collapse_control *cc);
-unsigned int max_order_from_offset(unsigned int offset);
 unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order);
 unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order);
-unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
-		unsigned int order);
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6203473f4953..26c0e961ac9f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -57,7 +57,6 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -296,84 +295,6 @@ struct attribute_group khugepaged_attr_group = {
 };
 #endif /* CONFIG_SYSFS */
 
-/**
- * collapse_max_ptes_none - Calculate maximum allowed empty PTEs or PTEs mapping
- * the shared zeropage for the given collapse operation.
- * @cc: The collapse control struct
- * @vma: The vma to check for userfaultfd
- * @order: The folio order being collapsed to
- *
- * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
- */
-unsigned int collapse_max_ptes_none(struct collapse_control *cc,
-		struct vm_area_struct *vma, unsigned int order)
-{
-	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
-
-	if (vma && userfaultfd_armed(vma))
-		return 0;
-	/* The limit as given, at the PMD order and wherever it is not capped */
-	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
-		return max_ptes_none;
-	/*
-	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
-	 * scale the maximum number of PTEs to the order of the collapse.
-	 */
-	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
-		return (1 << order) - 1;
-	/*
-	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
-	 * emit a warning and return 0.
-	 */
-	if (max_ptes_none)
-		pr_warn_once("mTHP collapse does not support max_ptes_none"
-		     " values other than 0 or %u, defaulting to 0.\n",
-		     KHUGEPAGED_MAX_PTES_LIMIT);
-	return 0;
-}
-
-/**
- * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
- * anonymous pages for the given collapse operation.
- * @cc: The collapse control struct
- * @order: The folio order being collapsed to
- *
- * Return: Maximum number of PTEs that map shared anonymous pages for the
- * collapse operation
- */
-unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
-		unsigned int order)
-{
-	/*
-	 * A sub-PMD window held to the strict rule takes no shared page at all:
-	 * an mTHP is not worth the CoW-breaking.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_shared;
-}
-
-/**
- * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
- * maximum allowed non-present pagecache entries for the given collapse operation.
- * @cc: The collapse control struct
- * @order: The folio order being collapsed to
- *
- * Return: Maximum number of non-present PTEs or the maximum allowed non-present
- * pagecache entries for the collapse operation.
- */
-unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
-		unsigned int order)
-{
-	/*
-	 * A sub-PMD window held to the strict rule takes nothing non-present:
-	 * reading pages back to build an mTHP is not worth the latency.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_swap;
-}
-
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -483,24 +404,6 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/*
- * Check what orders are possible based on the vma and collapse type.
- * This is used to determine if mTHP collapse is a viable option.
- */
-unsigned long collapse_possible_orders(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	unsigned long orders;
-
-	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
-	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
-		orders = THP_ORDERS_ALL_ANON;
-	else
-		orders = BIT(HPAGE_PMD_ORDER);
-
-	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
-}
-
 static bool collapse_possible(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
@@ -559,30 +462,6 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-bool collapse_scan_abort(int nid, struct collapse_control *cc)
-{
-	int i;
-
-	/*
-	 * If node_reclaim_mode is disabled, then no extra effort is made to
-	 * allocate memory locally.
-	 */
-	if (!node_reclaim_enabled())
-		return false;
-
-	/* If there is a count for this node already, it must be acceptable */
-	if (cc->node_load[nid])
-		return false;
-
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		if (!cc->node_load[i])
-			continue;
-		if (node_distance(nid, i) > node_reclaim_distance)
-			return true;
-	}
-	return false;
-}
-
 #define khugepaged_defrag()					\
 	(transparent_hugepage_flags &				\
 	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
@@ -623,32 +502,6 @@ static void collapse_policy_forced(struct collapse_policy *p)
 	p->tva_type = TVA_FORCED_COLLAPSE;
 }
 
-#ifdef CONFIG_NUMA
-int collapse_find_target_node(struct collapse_control *cc)
-{
-	int nid, target_node = 0, max_value = 0;
-
-	/* find first node with max normal pages hit */
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
-		if (cc->node_load[nid] > max_value) {
-			max_value = cc->node_load[nid];
-			target_node = nid;
-		}
-
-	for_each_online_node(nid) {
-		if (max_value == cc->node_load[nid])
-			node_set(nid, cc->alloc_nmask);
-	}
-
-	return target_node;
-}
-#else
-int collapse_find_target_node(struct collapse_control *cc)
-{
-	return 0;
-}
-#endif
-
 /*
  * If mmap_lock temporarily dropped, revalidate vma
  * after taking the mmap_lock again.
@@ -692,39 +545,6 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	return SCAN_SUCCEED;
 }
 
-static inline enum scan_result check_pmd_state(pmd_t *pmd)
-{
-	pmd_t pmde = pmdp_get_lockless(pmd);
-
-	if (pmd_none(pmde))
-		return SCAN_NO_PTE_TABLE;
-
-	/*
-	 * The folio may be under migration when khugepaged is trying to
-	 * collapse it. Migration success or failure will eventually end
-	 * up with a present PMD mapping a folio again.
-	 */
-	if (pmd_is_migration_entry(pmde))
-		return SCAN_PMD_MAPPED;
-	if (!pmd_present(pmde))
-		return SCAN_NO_PTE_TABLE;
-	if (pmd_trans_huge(pmde))
-		return SCAN_PMD_MAPPED;
-	if (pmd_bad(pmde))
-		return SCAN_NO_PTE_TABLE;
-	return SCAN_SUCCEED;
-}
-
-enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
-		unsigned long address, pmd_t **pmd)
-{
-	*pmd = mm_find_pmd(mm, address);
-	if (!*pmd)
-		return SCAN_NO_PTE_TABLE;
-
-	return check_pmd_state(*pmd);
-}
-
 static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
 		enum mthp_stat_item mthp_event)
 {
@@ -770,15 +590,6 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
-/* Return the highest naturally aligned order that fits at @offset within a PMD. */
-unsigned int max_order_from_offset(unsigned int offset)
-{
-	if (offset == 0)
-		return HPAGE_PMD_ORDER;
-
-	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
-}
-
 static void collect_mm_slot(struct mm_slot *slot)
 {
 	struct mm_struct *mm = slot->mm;
-- 
2.54.0


