Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D2A0CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B226B00C1; Wed, 13 May 2026 09:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED4A6B00C3; Wed, 13 May 2026 09:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001656B00C4; Wed, 13 May 2026 09:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E390A6B00C1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A65CC120B75
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:43 +0000 (UTC)
X-FDA: 84762428646.23.89C4E82
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9E77C000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gjF24aaj;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thKeB2NiafjiEdbVk8XkvNjvthrX3e0E5pBtn2l+Jas=;
	b=uMsS0XEtlHlEFMq5gBkRyCjp9Tu7iFUYwzX/4y2J7XTd68LCydRDpjxgRJnc5wR18e9+Jv
	iUBBqBZQ2MMFeR7DN6Za6ApCg+JgWnIiSaAzNcdo/miZgnj/gLm5AKmqoKB/tx7Wfy6FQr
	ocMJ2Wef+BIKyzKpZi/rdwPO2qX2Yvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677781; a=rsa-sha256;
	cv=none;
	b=JAOS7tEjPnzRmTt5lWUW00C3qnOzSJDRLyOc/pxBiCM5ac6M7c281ntR/0g6Jat6e9rwkD
	+tKf+8jcv7/x4YJ9c/Ib2xykwLsEJ9+wnPtehhFTAxuRZAKGZiZjFdfuYLpA8iXig3Yvyp
	gkm8bdVG2cUBsFHeDYDa63SKMHh28n8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gjF24aaj;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ba21d32776so45325905ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677781; x=1779282581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thKeB2NiafjiEdbVk8XkvNjvthrX3e0E5pBtn2l+Jas=;
        b=gjF24aaj77aatSoAt0j00Teblwu0edoCwsCP6QjTCQ/5jQqfqJ/eHNjxdtlYXkutD8
         efOW0D2LIT+XGdh0ydzCxrJqMG3y62S+A0YaoddRZqFGbfNshm/WyFtqiRinQbb8+Gdg
         po5oPCmEf3EQ+THzykxg9ifF+SV+mAoQEh23mkjYwrTaCbSMQwt+sEPLfTEKycSDJUuM
         8tsXyVqnlIaXrBmp/SVdf3xacCBRDlVmRbaX8TTd2x/vLKChdEfvp7EVfIZvZoJa+3wE
         DKrrCvO3lHIJZ130T1npU/9rIWk3MDzAsBtk56kN177FwMIsYe2DK++jc2OVe3Iiaxkp
         UeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677781; x=1779282581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=thKeB2NiafjiEdbVk8XkvNjvthrX3e0E5pBtn2l+Jas=;
        b=haUgk90xDluEaee/T175+DfFKg6vO3NjpzB1VfP53xATZ9OBpt2D+u4KFMSnYYmBsf
         VATkMp+qK9BQAbQ6IqKx6TjwFkBaYsQEiq+V6daBLI3FKN7lpEQ4IgVahWc2mLFtHhfw
         UrMoEa74diT3RZpqEOR9UjF41otLs7phey9NLL26QvC6xLPEuLPrM41X2JHXm2ejCe3U
         tg6fPf8MOWsZLYv5cOkYOyix4xXBlqgfRer3oqguacLTkXxrZwogYWWlBWJH9FxwW9lq
         KCv1EoxiTegYv33G/yq/opPBBGLUJavdBZ4FQd5h9852tZdu/l8RrLgiiJ5RJH/bad2O
         nKdQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JelDidV8xA8PUq215KSqUD74gijDNhEPHYG6pE0pVAWR0CksEXw9L9YRD+YhCuyd0IT/pPlqKgQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3Jn3dffvR6uFZVqPz6TOmzZYo1Ce3b/6PZcqPAd3QVgxRyQdU
	CTEEPXJQNt+Lu0DlvBwyqML6uzLItSOWVxyFPw7C1eKcUTfC8SDFSdfHB367QJDsTx4=
X-Gm-Gg: Acq92OF6itk8QVltShOtBemfhsoR0X5cfjTFjna/H3phC7/gfyAxqTqKv2SPnQ9UHis
	y4rWiLhBNA3gqveAUvvklV5F75knNR614fMiIwpg7Z96VJNgM+0BhVnTMVmCHSrgcCtyq6A3VOc
	qNXaGRL18GohhXNVtCyQu8mVEJTv6vZZDpsF0ybWdHdfgFHZZpPntD76CEDKxx5y972RgBHDvUk
	JCE2RlIYJakNiRLFzwf8FWztCEFbDMZ56PqYC4Sb1HChyftwzseWW7qJAaOBSjNJptnMBe8WgfJ
	8/CJFHiATbfhZsBTzMoUvpC0YMntl2sqe2NLv9iows++2mH0w185auqMg0taII2I9p0gSexaHSj
	9ssyQJ1BqOrDlN0bxZH3yMDpMo/dqzHcL58hsBuT5tp0Ihguswl39oQfUV5Ii8qoz4oCHP3XY8n
	UFtmdGRrGjaapFtWklBYg1atZs50Lt4GMXcB3JeTcEmuftDjIaGpO2NP13WPI=
X-Received: by 2002:a17:903:2ace:b0:2bc:7486:21cf with SMTP id d9443c01a7336-2bd276e6d61mr36673085ad.36.1778677780397;
        Wed, 13 May 2026 06:09:40 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:40 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 23/69] mm/sparse-vmemmap: track compound page order in struct mem_section
Date: Wed, 13 May 2026 21:04:51 +0800
Message-ID: <20260513130542.35604-24-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9E77C000A
X-Rspam-User: 
X-Stat-Signature: bu7oncxse3a5f51zuheik6s3mz6uqe8c
X-HE-Tag: 1778677781-235918
X-HE-Meta: U2FsdGVkX1880/00HEr+DdkeXNckZNxNaUc+ZaEkiEzlbFkZLY8x8Kyz2qy1pSq2xkIO2BaUvDOC+T856xQmtgiIn1ITz+8uTFGeJPg3je4RD9BxAWHJZ8RytfA8BsvmKeC5wPDqnVqGtOCc/v7M/AUiMv54ZylhO1fHnU42eK3i44rg4LX0H4QfQ3e21oHNzb5bvA3SC7dv518DxQtJa4seTVpVkdqfuZA/7wGWBm/0Y94FYMPp6Kr8nGUL8/LVJVFbekfNtrHLwWxtsum7Dm6M4XywwJOsEVg8bCnxZ6KVZk68dPINLj5zcAZe732gZUZTSmD4NtJORxxJhiQMVURuxZtP7v9FABLp9vsFt8M3d3JuVxkKKpU9Jp/Lvyb8OrbKfuGR27sAkS4q86FKq3pDzb9U6NEKUVcTyx/Ygcdb/sqFJKXAL+ETrHVDU1jtLUwvIMGYZoNlDw/Trr6BjluhyFkaAPIn27m0BgLLtNS5H9hXMtpDtmz+SPuwNme8Z7+FTOnGbd/j59ITIA9O7mCHfYLZ/ZiFzXz3BnKNL1AAeY2338DbRaLLomXY/J5+Mxlw6jSICnfli68XsSemXUbRef6akOCyDQ9Wnuvoc0lDMzdxyWR2cNDE1DLuutVtqmZ9yle0bl65pE61uB/MhMCuNcBD32IVxDvG56QcNqGF8ShW8n80Ax+Go5oOUvOcil6HlIwIAw8Lb2dRZCNtcOSgExuMCdjochuIS5lS+v3aRmBD9K/t/qC3LQfAgWPLshL1WjSLYm7YNZymP5+F1nJ1hZPFqwRKZwVEQ4tZG4qQ+VSMyaWSrvcnTxEExVpg/+t9sn9Ic9oL3plLyRYil5x29g01N2cb8iMJXcxPL6RQvAg4aLX4Ryw0EBEvfyeZtrW9JzQpRNB3hfBqG3r+dQ38qV/5/342/A2v0Q3bxb25PVKit7VIHzbsnYY5NoyNJ55+fQ01z5jeYstMq+y
 7faXlfRy
 yXooktbyqgtysjC5ScrGurlq5ivm/o5uh1PkBqEs5PWYxTLx+YjSvEIS0cApTh7YTSzoKWMHYgIKUg4S3Od6Rlt1gETU6/Umb9GrOo7PRsFDeVwP/7Jn63PolQP4SRWoIpmrQe4VgV8uWvokcj5iF8oVvn6pUi3pCy/q4dYrdqrexnm/h09hUvaNh8/LJ1f5X04G7u5iGWAQ6ne7qwbPgCsA47I4XTJ7JlRZKoL5OoXYfzv812fqFqqYMxGbP2OvRnPUIyxJyzVwe9ewKCytqDpOoNoT7iedN6QjSc72W1Un32Lxm2OXPCEYzoQZ0QRKjHxDZ+B+OvzuF4x+59KKHRo5s2OJqX/dmENIlNFWPHF1SjMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and DAX both rely on vmemmap optimization, but sparsemem does
not record what compound page order a section is populated with.

As a result, code that needs this information has to open-code
separate handling across users of vmemmap optimization.  It also
prevents other memory management code, such as struct page
initialization, from skipping initialization of shared vmemmap pages
when needed.

Track the compound page order in struct mem_section and provide small
helpers to access it.  A compound page larger than a section naturally
carries the same order across all covered sections.

This is a preparatory change for consolidating vmemmap optimization
handling and for letting later code make initialization decisions
based on the section's compound page order.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ae0271eaec05..6f112e6f42bb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2028,6 +2028,14 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	/*
+	 * The order of compound pages in this section. Typically, the section
+	 * holds compound pages of this order; a larger compound page will span
+	 * multiple sections.
+	 */
+	unsigned int order;
+#endif
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -2224,6 +2232,17 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 	*pfn = (*pfn & PAGE_SECTION_MASK) + (bit * PAGES_PER_SUBSECTION);
 	return true;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+	VM_WARN_ON(section->order && order && section->order != order);
+	section->order = order;
+}
+
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
@@ -2234,6 +2253,15 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 {
 	return true;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
 #endif
 
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-- 
2.54.0


