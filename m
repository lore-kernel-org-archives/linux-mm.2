Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74527606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=mSQMNIms
Received: by kanga.kvack.org (Postfix)
	id 7BA756B05B4; Thu, 19 Nov 2026 02:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7900D6B05B7; Thu, 19 Nov 2026 02:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6146B05B8; Thu, 19 Nov 2026 02:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343A66B05B4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:51:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 828B3140962
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:51:26 +0000 (UTC)
X-FDA: 85451098572.15.CE725BF
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9FE53120003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:51:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=mSQMNIms;
	spf=pass (imf29.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795074684;
	b=LlyCmAda0P/MvOR4Ux/LiBAHMmSGalaCWmVmg48el0haIk84CSTgtWbK41sJHBw9xcuhy9
	77FBLBl//mZYd10EzqG79XmEDMgBBlqcPzRXz1Gmu3/p1qWqfTejxU6NA3o7saBoMgVFpM
	ZuZMl0QcsMoiQzx30Pn3vabI52VeB6g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795074684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ba+Nnv4ioOHEAc+i4gjL1aVglKq6uZ57iPLZC0JP+/0=;
	b=rHtVuF/yMe4NBXJPHZr9QPz130Ya8qTpg33OooA1ah5YVY2TpSeWW1RAwAhiudGxQhy193
	5xH32IEMm+TVl7l/twHaZL5QbzIDNEXF4k2gsfdOwYe+Qe6Yg5reU6SjvNQv3wd+YUmxmo
	0aBQ2dXG8tjICfHCzFudBCg/FScgb58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=mSQMNIms;
	spf=pass (imf29.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795074578;
	bh=Ba+Nnv4ioOHEAc+i4gjL1aVglKq6uZ57iPLZC0JP+/0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=mSQMNIms6b2a847Jv0CgJNJV6Yl+BsggwHWjh9g2APDz6npLJmeQTsJjoBAl8zBU9
	 6xlhSRnv4OXGNVqp4Rjxep8LZXJJtV7C4cr3+MsaSsBBmZVkxxPZ9Ow0BOQKbOlRIJ
	 /KjHyZtvBlohbGVHlBemOYJe/2lyZpuolJq54c3w=
X-QQ-mid: esmtpsz20t1795074573t21a8dba9
X-QQ-Originating-IP: g/JHC0RTM9WfBbnsRPMGVVkJ0qD18o0qUXMwBFz46jY=
Received: from PECI3347 ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 19 Nov 2026 15:49:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6967146943735712994
EX-QQ-RecipientCnt: 18
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH] Docs/mm: fix stale split page table lock references
Date: Thu, 19 Nov 2026 15:48:53 +0800
Message-ID: <32FBD023F945BCCE+20261119074854.252609-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: Nm3/xtCLAPd0xZhFJxT4TR8Of5LS6XRU+SWytWF0VPwHy0CRNWSnWjEq
	HPuOb0jJ1eoBS3FIktmCpB4jDKfHE2srNMVBv15Y4SPnblH+aIraKCSn5VZzTwjgzMT5LJL
	YNn3D7FzNqb683PGEgbvGX60E3DQKGht7YBYZHob6wMQ6XIEiJ6KdIe8GAaO+j2FaT/tqvv
	dKvHDZzERZRleXgfS6dsEXMMUsaDW5vSStUkMVepJdPRlgmLAIadon5h3+JDxV1bNf20ZDO
	Vv9XAsAhoTclQobIhqtTfzd1iNVRqBBp5eiBjrIN9frb36Q9jN2r4FsNHhDJ9NmK0qo7q8/
	Wo3slUYCmdm+/rJp7spJeh+b6jAfTqbX+igRqepyJzo2C6CbTlXIm15JZiNPS+M+Vq/itlA
	FTlIeHU04U5MGa3X4qQlU/26dP0lFAgTpb+u4MezS2urW3Jy9Njk5T1lnXeAjhaGkAH0NaI
	/dSQgXKz8zfatRE/p+NCwOOp1Z8JPChowq7wMwtI18uUF7IbRTzltu+xFEz9NDofiv6ZFVL
	kjlnlT8UPljb4AkneEbzFxYubOhsvA21jwUPm4prKY7QgQFogLCiPydjnIJXM27OXXXODjD
	l5WeB1/i29eB5aS2nkkhhfPTfRhi5FGLJ/EaL3EahbDsqSA+q48IFDW6ZmFp6RkUMYQecgZ
	C0l44RrahBkrx6sCKTm/FWIHboL5Dm+kmr+mN6m6ByX89gXsk41O5/sqE9Cy6rWwFOQJ4+E
	/m/NtSZ4KsMhZgWbrqzf+mLDWvCG8ySx0280oZHJRi6EudFCa+r5M6B06vnpUvLdGfhIf1t
	MkZmgh/uDZSIpN6AmpJTnST1CfqHsySP+0Hp9r30GBWsW10YYBN6aPJcBYN/Dx31BGxPhCS
	NnQf7NJGP5jizgPdMYrnC5/diZXERBj8qa5ETSXMHWAiXtfbVQLvERd/5qZwbf9P1UcOpw7
	sGYlXJ6p53aWVodL1ROrvtoYDHUV90Xb63GkR7VbdA7O6UypohLTb7ah14DbD/Sk9oEPfQb
	KbGAPOkPa0ECegsGSeHat3Wn1qy01oz/3UxvbxnuoLWhVkKQ/uiJR6T8w7hMAtBqn1CjqZ0
	De5PVNbA3THHxIs1MdOzYnRvuyIgiC2ygzG3IiTukM4n+COanQXcKI+ClUR6jRywUn1ZG68
	1Kef
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FE53120003
X-Rspam-User:
X-Stat-Signature: meqa9nfh5dmind35p6k3pifu8wi5qcwo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795074682-641481
X-HE-Meta: U2FsdGVkX19g9OMz2thXPSCgVfQ2SfymUXJ4jbdaEBkql1wULniFeTuWLZs66ckJuXTRHDmmKHt1ONxxqpsO9r76QZqdCP6xAo/mO9jWUaMS2s/ZC4SQM76AjLIoC79OxW+U64S1wZJj/GoQ47EVetB9leHK9xwXCnfz9c2En+7E8FJnfMnepHWSEv7WIomH4lJzbVG4XPWTWAKbQo3rKuOEhPg+BrDaKZhZbn1aagVkJzP4bL8Hv4ifRGijUIyBn3pYroLHtHAhODdX0h1NZVmPL4sKFy2AOTzvFgrzbRijSpX940WBGqg+ZcZG2zBEJKwdZost6m0Pz//O++IWr6OzPTIT5U1c0QuGnV8M/VAUhqXKyA70HRqIxiWKJXD2L8vAcrx45S0DOCt/fKKYD2v0LdkLj6s3tQL6jTEuphtAJajFhoi2fJO5jRJMQxEOIPqplf4oucCbo2yw4irTAuJBF7EGmWZTdysQfNAqRZ/RL89ILp4rDCV+Rt5wJM9F6dS1EqwAMOrF6jAwv7exyfTZPh6cwLJck890HIHDdblEBaEQvQYBhuv5Skmpr5w5kJtYKYsWJwR1yJ9tIwLH8Zkf8dT/+UPo8MZXbeHwIht0J6VkePeXALhn9Odt9PhNwRqE2OXl5P0gJJVFm0j697m9CnJz6m/U0+dQxVfgUlgj9ulmieO0PcMDP2mCqFfpWyWSleRIchWv2AFQoloYL5HttqrkDHtRxk8rwAes9cQmFzq1/Htf9fXVjM/cZFtb3KgAF4THvHY5DRX8XeVQjonCNn6xgTRlls8xOguXi7EkKGbHQP2PmApLTp6jDHXd7rS+4O5xgMayvfDRa/dFAuh6XEu34XT74VA6NPhnq8DvyzFFweUXKrSINRNpa13dv9sAhP5F3SugX/zXHjnYr9peQ37tdRUkOvkzI+GCWDLsYYWjDHV3GJDENHi3OGfwdYuXSJx7EYO250gQ23S
 yBRMDUlD
 5ocEKImzmdEIY/8+TCHNU1+rW+YptNLH5/AN868q/vxS9sSJMKgQGT68vx63Y4/sjGVG8dpmn52oEk7PvJNzcRNPDtKN1NMLdKPa70fQbVul2Ai9xV8MgeztZlhLm+LjiYxcfSCA57XrkhyIwWbDC/cOj0ev4nKzj0qX5aw+slIeC7bS7NB8Ga2ZhHcFkI0BzqBRzMoUR6l3FWyApFlQbrmIyP7IOupsqds8dybo4/r0StU9mGQcfsrbODZfWN6TYKtkugTySVs5S3qHkWLPv4u+JdaL4X2CxUAB7W/QKX/bPLXiTBcNUp3WMMH/+eQLQK91qnXwz82EqKoAg5GB+C4siAGdUCkUrwt39nZkmq8DX8P1krpDwh/YrySdauNp+eQrXDc7dw2ine6npl2nLUEMKFL5VSVzGc5FyxSQ8Xf7hp5NCt9z/ZfGQxTzSwWhpJ7U8V90Vt1PiLBR+GND2KxMjhjjm8yeWeqLMPrBpIflamvzr3ln7XZCKCnsWcplOJbyfjIQ8npD4A5+ZOdCybYXJXsQ1gQEmktJQWot3hKupjFqtf5vjdAk/ChW94h9YkIAxAWhG63VjANOYVF1BgBu6/Kb4XTZHtxxL4TYJD/VHsBI=
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

Update both references.

Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
 Documentation/mm/process_addrs.rst         | 2 +-
 Documentation/mm/split_page_table_lock.rst | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index cc3cd46abd1b..ce7908bebce9 100644
--- a/Documentation/mm/split_page_table_lock.rst
+++ b/Documentation/mm/split_page_table_lock.rst
@@ -37,9 +37,11 @@ There are helpers to lock/unlock a table and other accessor functions:
  - pmd_lockptr()
 	returns pointer to PMD table lock;
 
-Split page table lock for PTE tables is enabled compile-time if
-CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
-If split lock is disabled, all tables are guarded by mm->page_table_lock.
+Split page table lock for PTE tables is enabled at compile time when
+CONFIG_SPLIT_PTE_PTLOCKS is enabled.  This option requires CONFIG_MMU and
+CONFIG_SMP, with CONFIG_NR_CPUS set to at least 4 (see mm/Kconfig for
+architecture-specific restrictions).  If split lock is disabled, all
+tables are guarded by mm->page_table_lock.
 
 Split page table lock for PMD tables is enabled, if it's enabled for PTE
 tables and the architecture supports it (see below).
-- 
2.50.1


