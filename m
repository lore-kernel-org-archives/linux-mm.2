Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCB1606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=V+h2ShV3
Received: by kanga.kvack.org (Postfix)
	id A59676B05B3; Sun, 22 Nov 2026 22:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30F36B05B4; Sun, 22 Nov 2026 22:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923266B05B5; Sun, 22 Nov 2026 22:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64DFD6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:10:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBDEB1A0605
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:10:58 +0000 (UTC)
X-FDA: 85464906996.01.1D4D529
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B3BD1C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:10:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=V+h2ShV3;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf18.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403456;
	b=D6kSsz0d4ggqaCIW/C/KmQVmODatAVRESz/g0F6cegfHRHzy07IPmutykHndyV5F2tlCnB
	pQcKdnNU7p7bhpAXcgBf8Y4x6sKH7cEvGxrCV2G59bPfNh7cS7PDnAFwec8CV+hZ6xgurb
	aTyuQQK3SHaYD8qBtMopF9bBJ2dkrbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oNfCshgfylwcbv5xC9TWUsVsDyDxPcrICrC9vT/UFVQ=;
	b=8gTnj0ieCPnK8ym/OBVjRMgbupiQnpY9JaVbtT5raVbYmP9oB7kFFHgU1X4siV7rUnJZYD
	erPdUb67eWH9lZWXI3gqtGt3Sv95Wr+PXqGW+I+xgVLJgoh4fE4k46ilJ8bWGYT0Fa9Vsl
	KREmzFmOgt4rnoqoiNBVZk1Ix+4GncQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=V+h2ShV3;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf18.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795403358;
	bh=oNfCshgfylwcbv5xC9TWUsVsDyDxPcrICrC9vT/UFVQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=V+h2ShV36q7W84wvDn5DE9l7+VNJFpAcIwzbLn/qbNVafCAvu2CeSHyCL8XjdJ7aq
	 935Y9QkCNxv5hg4/H6kaNoTNA/OxnXPwliIovTtd2WsSDJdjwMCtMATIZVNG3UlSm1
	 hCRoOFIRNlb6HvLppob1oJTsx6E4PEgr1ABW4abw=
X-QQ-mid: zesmtpsz2t1795403352t73ab4d9c
X-QQ-Originating-IP: oyGw9ttpeTpeqils+8yDH5/B7JsCcA7IMaplBy638c0=
Received: from PECI3347 ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 23 Nov 2026 11:09:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 919220475888949696
EX-QQ-RecipientCnt: 18
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2] Docs/mm: fix stale split page table lock references
Date: Mon, 23 Nov 2026 11:09:03 +0800
Message-ID: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NQwqDYuuf0Vm4GWWMoU8nE0ViSDHLnMF7/FXCGhrm+gPELchMmmoHfD9
	tzxoKhNcyQPUQgg+W2uW9/JHPYy1Upibc9mT/8pqJx351VLiQgHfIMhakDgzMVqxnlmm4XU
	e2SloN3dsEdLUN3KJOLhNA8mLuFqNrTcgQopt/n9J97/q3hQzIjBHsvBA5sShRKjWZEzATO
	wZvTv0Okine7qjRYJ8yabqhGZYvRv/K21cevVpaA2L8tZNps0jSwgdKpoh/FtOtMwyp2GmS
	FkyqvW9Nlo+PeT3iA3xQgQdN9jgI1vSQ0n9Whu+71geeITDA+oWu4VvGjzfem/gzSptZ5Fx
	3l47uwHvuY2nMYuxU2w1PKWo3RxRQRpuqrwYtex/Hp/zJFpyLU6lIOYbkEWPF9n2UciBtvY
	qTTfWkTF90WKlRHDmLeXe5wkvw8IhZkeUceSWYKVp3nlCkgDlq2nqwazAdEFRC5iaXWZevY
	48FdXfau9FaEnYy32fZOrmIE7mLuz8vucICR8p8Ij+mLwB5jyhXCuC4gx8AF0M4O1SL+9Hl
	Ob+rJmXKW3iUpOwWu1WdUYd0vKo4bzYNrWnobqZi8sqfpPv5SptITjwb+D5yIv6x2FDMSeZ
	CNRyVxxJMQzW/3lfx1J9vhvWbSNyKyduuqszVcKS5uZh0mcdaGNf0ivK4K7yVvZ3Obge1Wc
	zz7/xLgv4kVoFENcC9+l0j+GOhgMLpf2b5AlSRO9+WQV6xafQqxF4ycn4EwdohmzNzR+gIr
	PNTyboV/CEz1NYuQN/UnLicCt/IbhBjeg0hb98gsOmHXfVvpSYG1X1vE/SMIMUVePpoE630
	ksjjX37NX0IV4kzay2EvUSwl/i2AgKUI47E9V19VKml2PNlkXsFlsiYTCs+8DhdEXVspjpD
	5YZkVvpWMPTWDvwpGf8BhEh4vGlWfIOSEO60CO4X7BC030U1tFT5cYG8IUm74E3dZRY+sVu
	k9u6FnFOyPtztnzYos0bvZnCk2XG2iozAADoFGpp1qOO/QTSKfLAowLWo74UDzHEgIn7j9j
	txsXzjaz70FrzejX1vyrtnKE2URLM=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7B3BD1C0004
X-Stat-Signature: sdqiwssc9qqq3wfstyshpu5ask9kwwe6
X-HE-Tag: 1795403454-704827
X-HE-Meta: U2FsdGVkX19BNkUQ89h0v9XZo5jdgMxHuOsTzpL9govUibVAHK9Z2OmiEPhIuxJcFjzTQKcWZrwIbPs/UjgVM7z9ICd8aB6FDbrGATGZjRXNujoykmJr/G+wN158Djm8xm947PJGIVFmUaWTB2ZVQXyt74xLOz2JO5HlJqg0X/CF5EDQmdSw7oYyyApn6he4V+x2gpmlHmSczTGF8fjosJ6UXYYZu0arMdEO68QoI/bRjlf0DYBMEgPuqQ3WoIg+az9oQenh9S4VS/SujWVkhqKByDswDa8b0lvdbYYGn9rgroKxat0O0qFvB8AucYadjIEUiUYQHOzgYbz7DsTtcHOpldFtoM7yLqoZG11+FK3Dd30s1omd2ztfnojicOx5rIVkCXA9+bc9lsEAEo9y/aNMPaedxLtQqGttAKPjma0yPe7r/2tyNu5gRnA2Ev7TbTISJZRz2ZF5ts2O/wQ4i0a4U21XlW3zZYUcMMi6rudrvDjSR/58j6uyP/PDFTNeX08JDyXrsfcPBoDjVXJf97uvhzFAE0+ZxWTbxh1t7AtVOzcXMlQXnzbrh3VAGuA5ypZCNorYigxbkW5OKFDxMn8Pxb5bP06ezDNAxLrsyYg4oJRz30sgydH+CzL/racvAB9vvDxPBkdV3SWjWfQKvq+oRqrfG7V7bWxGiB99Dn4fId63m0y/0oV50N9CNNfJDD3hYd7Xyv0MEIcYVFrHXS1QjnEQClKQgedd8VBeZi3q5RLlrNvmdCkChVtsTho4Nosq7qXI2GDX19MDERr6AnFke6UKLZWJmPeEHUANJUqCEzG+lF+JrdKqz834cEne+iLHHJshbmWzOHLlGo56ZHxlZfT8iN+SjtH0GHRV8xyxu5rb/bF8A10pVF6CIwhbbzb661k9Jp9clk0MLUTgjtUKdkHpkBoRUJL2KQI7uy1/c0ayPrpeoLvcwtJN5AeiAJxDAFL7E+tFMRXCR1m
 jSuGFiWa
 aWYV8ifjvZPGAv3VBy5DLvF3Huv23P56dZqHzZ8GLO7v2QM2X1jS60JYI/GVHRuHIAls1AVNPbVI1IWzIXSnOLfOFsA8wJwqCabF0/HSVNjVS1ARh6MGaywZLAx8MrQpsRdmv86vsjxdnl5eaW7loUF/P8y+X/rhK+84koTCLNCfiagAB79QDGM7hcPvwhUP/QN1sKiSi4ZRLHmDS4PsLt//LbLxhaygmzoTVFHdlNY4WYnYE3vCnAachk+Wx4lZ///GmAa4IaTS53Naf808Y1lgA4bUQFe1zpUxEtdBf1Yk7Tcha5FzssSm1Gsb6Hf3lviDCHqFj3esVTZwZ+USe8Neqwx9WJVTMxwGiVBrc3dcgvskYm+zHn9ZHwdRYMb5RoBp7Q7tLDJVPEXESxQsKCEbXXC4TnyqmBMwf0x3shu/boJG/ETBduazPSKUPQqgEzqbZqwv78J4AlYvgp3iK8bPSaaieGorn8ksC/dqoG4pufp7DLxVnvZCAD+yaFRhQig7IDrvhi6o/MvtjpxFGyzq+eR00da6jrc1/tIDOKjb+NKGvQqWlXtB6gpkrNBYCITT+aUcOSdciiFlGIFLL3NrwFkPZo76+tOQLqnG/nKJ9iNlLvAfVuTodsvpYSlpD36+0gAuz4J0e0AGZIW+OmCeHpkGg0jlDw19Qc3GGwYV/40efsUoHlQglXjurunHHZlxEPJsCtThbAFZP7OBt2v7p9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
Documentation/mm files still refer to the old names.

Update both references.  Point readers to mm/Kconfig for the dependencies
instead of restating information that can become stale.

Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
Changes in v2:
 - Point to mm/Kconfig instead of restating SPLIT_PTE_PTLOCKS dependencies,
   as suggested by David.

 Documentation/mm/process_addrs.rst         | 2 +-
 Documentation/mm/split_page_table_lock.rst | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 04b649818cc1..0b6355e6d1d5 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -659,7 +659,7 @@ acquired in :c:func:`!__p4d_alloc`, :c:func:`!__pud_alloc` and
    references the :c:member:`!mm->page_table_lock`.
 
 Allocating a PTE will either use the :c:member:`!mm->page_table_lock` or, if
-:c:macro:`!USE_SPLIT_PMD_PTLOCKS` is defined, a lock embedded in the PMD
+:c:macro:`!CONFIG_SPLIT_PMD_PTLOCKS` is enabled, a lock embedded in the PMD
 physical page metadata in the form of a :c:struct:`!struct ptdesc`, acquired by
 :c:func:`!pmd_ptdesc` called from :c:func:`!pmd_lock` and ultimately
 :c:func:`!__pte_alloc`.
diff --git a/Documentation/mm/split_page_table_lock.rst b/Documentation/mm/split_page_table_lock.rst
index cc3cd46abd1b..52c992b6bcfa 100644
--- a/Documentation/mm/split_page_table_lock.rst
+++ b/Documentation/mm/split_page_table_lock.rst
@@ -37,8 +37,8 @@ There are helpers to lock/unlock a table and other accessor functions:
  - pmd_lockptr()
 	returns pointer to PMD table lock;
 
-Split page table lock for PTE tables is enabled compile-time if
-CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
+Split page table lock for PTE tables is enabled at compile time when
+CONFIG_SPLIT_PTE_PTLOCKS is enabled; see mm/Kconfig for its dependencies.
 If split lock is disabled, all tables are guarded by mm->page_table_lock.
 
 Split page table lock for PMD tables is enabled, if it's enabled for PTE
-- 
2.50.1


