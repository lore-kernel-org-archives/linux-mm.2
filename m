Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23792C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235C56B0092; Mon,  3 Aug 2026 03:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214066B0093; Mon,  3 Aug 2026 03:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B056B0095; Mon,  3 Aug 2026 03:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5E66B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:11:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91B4F4062C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:11:20 +0000 (UTC)
X-FDA: 85059087120.07.BB9FA4C
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F0D140007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:11:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e2PdTZLH;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
	b=Q5R7/AFbDQg6lwmbdYvQ0kJU2fTrI2riCwY3nvE+HGaQpV6+15tsSF7AVkYeCQS8MvoSpc
	JTeRtpQSFglNRT4BkJz0eIaOe/atUrFycXkpoxtW16jt543MZWllOikgqaK+sggVSNzVQe
	jymOHK44xYzdqcJKZzOe8yUDMUtDEJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741079;
	b=4CgOrRB2nKpTbxF8nqWndY5//OKqRIeCinPsQkQkaZuDzuMCXgIyjiTk9G43YgVaXhVNYU
	qprmTwPr3qNhS0hY45Z5+SIWEEewnzZG1qQs3jccOc+dIqrrlkT6J8dlxs/5TioVUUUumZ
	OxGJTQugbAWEkmtvyrVDyxoCSIsjPV8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e2PdTZLH;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741071; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
 b=e2PdTZLHPSo4lhkRRzMlcM1fzB6NXcH7MQlhE5P5aJ9Xbn/lvF2GOhuD8uwPOQhPli+jIb
 c+Bg/EALcOFDEv0AbcdZptSJQz1+lFib89Hq5CbIqLMC8/IlGKkYpr7WQqsGcbFdlmfMfS
 BhJOEyJRbJ3MBI3ZRQX21USJFRQ+23rsKK9MnWWKGq9PGKsMbk1uRoEt37ltvYyqVOuuMA
 8jMP8DtIXxeJttmfRBvjpaAlSEoheCu/4wOsyAUThnSlanHGA8XhgE+2qxi2yAT4Z08xdi
 d06j9lfKmJnEBt4D/S7PomLr1TV/ictq9zin3kgQmDdTGbt7Pztsv+iUSeAFIQ==
Subject: [PATCH v9 3/8] mm: add a set_page_section_from_pfn() helper
Date: Mon,  3 Aug 2026 15:09:24 +0800
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a703f0d+7e0630+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260803070929.86075-4-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F0D140007
X-Stat-Signature: poybeo8wjddrb83btoqgfasrqj5wcocd
X-HE-Tag: 1785741078-384797
X-HE-Meta: U2FsdGVkX18i9aXeD2B19POwYiwRgO3UV31XL0KLtzBWWIyV4X32TG7fUp3fSSxmFh0XMdMyqnXOtCfEcW67yeQG3UyBWl9iNHCA1Wu3kY8W+/Q/ykVhhwLI+Al6iQzu1efpqEezKuB6KnaKtUoFR2BY1G9nOYh3D/eNqa3eNpMdb9hxSEJaQ+RHeN/+DGguhblgJsv9zGM72Jf0ud8ckFVP7Mf36lwd5gPVIxQn15+YjKvvkkcuuDraCc6CFNHsef6zXaXaIydSrX6B9D3VSwlxd/sYXq4W6gPCQ7CJ9H1D6jhl4CSuEOjtrxvoU/5MtwMG9W2W6/GBKTNI0c8uzhaCbSVgtvg+KPRfRH4pv/Qrd8KGYI0o6oYPvmu2zMq30YX4iqqB5EJWBAjjbBB+ZweUDnoMATlHtUlKmL15OIm+0/43pkMqJko850/HR83JIIDAhMr2xHcO72lK6WcA6cuL+xPAFVNIC7kUsNq1oEMibKOixXAhkbl8VwFWDKPvxMZ6qboMqnR5LOJU4+ht0q1WR4y9vU3wKRT5ncGf7l5GnU9yp93/7Ql5kOdfNsblb9Ka+KkicZQmjFGvE/IkL8QplDsXd8c9S4YNqtpqQOFGd7ftE2x7mhzAZYwkCW6j9ySoQEx8+4pEdlv0p2bpM04qS+7Ey/oZ+6+BEak3nl78aeL/jN2yByjWKl+YkuNjVFP97eh6n4OlORL5XT06DLcGUIYlbOtNgmBXOasFWh2sD77yA8ayozdMFVuicTAAQUj03BiHyT3InBtSYw8Qqp+f3CSyOr7yMDRgieRhTxFWEtNpnFnnsAsg6TgDikH9SK/if7y6MSgS/SAVLRfd/Vzt5D28XrwPO9C/ieV6PEBJFsDQYjCnmAf6X6voYtIiX5wDTPbkb0yL8HD5MBLiCDULPbNg2phY0Md5aS3IK/TfYPabErOsbid3OFzdKQ+qxJIaKmY1Tn2MtJE3GE/
 FB0nH5ln
 dgZvOqAO/B2xIdlGOJbdwK8KLbMDI/8Hk9Wv0h+FA9I+efa3Xdo3PR+3OMmrUqRX78QCVhPU1DhzC6Wu3edshrwy+rPv5iJZdJ6yYhdhSPykWE6Z8qzP0PwYZv1Trrf7KJ5w6YrNyCUQyPYVA1f51vvhk8a4Ap4+eNNibkLVIZEhr/tzJaH4vcxw/g+XlHOKB9zvd2ibveUnco27OnWQO8KNf6YIFJs6lmUrQEmPKo8kWV9vw3rdOFrd1PSJ1VPg+eOMzoLOyYP+G2kwxkBY+5//hoA9dolc2DTrRtxMTIO5nArysFu2QGL6bkdKuabH35JtyF4NRgYvOSsuxq/ngY5GLK6u/D+WTcF+6+ENGELzQql40eTKfNTBJqCTypijEDAvclZL6zz2otWKQ36AiwzQtgIKvkIzokazOqw0WIWCZ4tMvAoV+4JzzuZtbLbx2Gl3Z6HXNYuiMU6JgTDDQp6KJ9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place. When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags. Otherwise keep it as a
no-op so callers can use one helper without open-coding
SECTION_IN_PAGE_FLAGS.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/mm.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..43343bfce493 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2541,11 +2541,22 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return 0;
@@ -2768,9 +2779,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
-#endif
+	set_page_section_from_pfn(page, pfn);
 }
 
 /**
-- 
2.20.1

