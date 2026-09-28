Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17233CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150C56B00A9; Mon, 28 Sep 2026 13:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102CF6B00AA; Mon, 28 Sep 2026 13:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EAF6B00AB; Mon, 28 Sep 2026 13:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3C616B00A9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:21:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5149040266
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:21:32 +0000 (UTC)
X-FDA: 85263837624.30.0B54F28
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C5C340008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:21:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=KaZlWMLm;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d cbF+wy";
	spf=pass (imf12.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53EGbVlBCmuFO/yPGaufkagD24x0y+PKNHNL/qinRMo=;
	b=2zO2YmuoSp9mHq4VvLQ50iXDZRwvHzQ/VJ8Zeo4eDos7WyhXAWMR7qw7wMhFA92cDkY2jM
	0/FjIw+HgzF83rbjxtthlEhvT+Yo6a/nZtkCoy+QFan+Cq9M/AYmBOYthNaPy8Y+E4nt3f
	amSxfqHYqa00Y0BN2QnOPZWV5PZwQBE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=KaZlWMLm;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d cbF+wy";
	spf=pass (imf12.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616090;
	b=b4JZFIOGuq5IawUmqRjBnWNns7DaS1AJVAKKfNJhf3hZN9B9vC0Tmdh9k3it4cIUGHPeqj
	L6jUegUfBptIyesnSNE1H9rjy8bhcNlRzx4aMq5D/cE5KruBu/JhOQPiduhAoIB/Wn2C8F
	O+ZfSsCtWaYPJ2+L9yd8wRdS2pNTaKc=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id B330D1380021;
	Mon, 28 Sep 2026 13:21:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 13:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616089;
	 x=1790623289; bh=53EGbVlBCmuFO/yPGaufkagD24x0y+PKNHNL/qinRMo=; b=
	KaZlWMLmtvRq2GeQrDQaqKaxYnEHoQjh5LSeMxcYhf3GCNNRPEu9cY0Ir2XBK7RJ
	JVbvETgTonrJ8uG1FJh0sfjReLo5OBOKkFNLs2YLZQ4c1QQeIMWSdm+0EmM6ySuo
	O5p3yRupqREp8EXfTd2Kp5kYmgS1GyiQDoylj+WVxJj7vNnB+vo3r3DQ5YRLBCty
	DbEMMnEUpVJyBOUa1ZkhZhTb2PyPnldDX3TMn1w/cp+FReq5aNImdY/n6ulGu3Dk
	uXPh4+ndTpVVPzsJWzdjZI6onVhqrS06M6VIQlkJ90okQJAGhOqmuvCjcQwv+hft
	4JWAeabHnuDXuHEidheMzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616089; x=
	1790623289; bh=53EGbVlBCmuFO/yPGaufkagD24x0y+PKNHNL/qinRMo=; b=d
	cbF+wyvCLIU7MFxc0k/maGQv0JOz7etFVBshyNhAvaShG64yyzlp15DozydFDWvJ
	oWB0J/puyiRbPj8OZjia5/gmDRAjBfedW8qqXNyN+LBbHKJwMgfa3r4njouEfric
	NGeYM80TRvklD08K7HDQ3FG7HhfBNys0763UOylIljc5wnvaQ3x3DAs74RPZVxX3
	IqFb4Wbfzj/ce5rqonBT+w12nVufrZqrrTch6fwqiIGOfB25BPDQhzgllfLcHAbE
	GDsLYTZ+ACRgs4Vk5M4uv78aaEct0YGGvewt4/EU/l2AZNZjwr3i4ciUvEEI1Pve
	kgKyp+WFp3vAsMGRQAEyg==
X-ME-Sender: <xms:GaK6agME_RUqisuTZaZ8sblvuXWJKUD2UcrSysV3P_vOv8SP4L5R7Q>
    <xme:GaK6atFD7JhlkoBcU_eCVfpSYrZsTvmWmiMNZI_haZmQ75ER7JfSWTksd5BnQzszT
    eMb-nR5kYeYODRnDOU_60tQ5hpLmazJlalZrMJMpbxT9uWkbv4ciZA>
X-ME-Received: <xmr:GaK6akBVgAmZH-kz65nORHPTKkwNmr5ULsLU48UIFOxLeoeoTn8D0mQz1XMGL7QU>
X-ME-Proxy-Cause: dmFkZTFVchM+bTT1PKuZ7CN10fxXJIikNoVdUVFHA1eqyKMgAAVr8P6ONf1Qg916JwGLA/
    UIAM5uyklkVrDRDmXBCinnisDlXug/Uvz0CnXEuy4xZlY+Q3iKI5V68dUZbqn8FCfsIN95
    6KfV8L2bBYYMAysjIpjjTtDvr59SlVXR0rT3rsZ8OOWBdCzi2fs/qRsgGZhcNemn8sEAcR
    7gOuIxy/+2FBe7o4KglohLGCDym2m4zsXZ2bZO1r7mHjauIXUwmWu2ruzm3DMO6W6IP24K
    Wr2E/Zfjs4QhZp1KylseoV5Uqh0JkwjuRMQihg5e/hXKn9gV8Cjo7+1dG47k97NaaXBvC7
    wjkPY0MykASYaurO98ZHxrl0KcaeBJvFcHGkCls8dJmp8N9EgVIVZBPmju1Jaa0vGc/g26
    ElcZ1+93OK72UscCr1gvESBIDBc/k5GRgmMs4aRi/NhqRPA8qigxm7a8c5v3VBEdkBWELG
    Hl6Rl3Lo1/OLIPFbcTXUFqhvrftb5lPDDoAdzIZMIihMRVJ0BtE9OAIHN0k5JRPQYUtB50
    uEN906KhBV3w26s4nR9FTs32IRL8sBtDCGDtj9NdKWa5JOndRzoGCYTcFpYRBBavwhOH46
    wGLX+aVoqY6v4MsvVkdjVwPbLIC3TqWJI7dmZiEeUCpOJ3rjOknfBh2dkXoQ
X-ME-Proxy: <xmx:GaK6aulxxt4X4suH6T5nGB8VEVZ8YMgNoWHDGwVXSUcJ9TaynJqzww>
    <xmx:GaK6asuLAHs1Qq0aqQZTzF_SawsJGPZ16q1y5_5W7BEMkyBB17X5hQ>
    <xmx:GaK6amV5Hm_CHmZCMDi3seeCJTpRkbIp5yN-e3h9dmvlFppKG0TVlw>
    <xmx:GaK6amiXj9XCynaX0y4fkOxEbZKWYJzObo4FgQFDu0HZ-nOYgPrLgQ>
    <xmx:GaK6ats1-IsvrHI78yAph7SKA-W3bmPkQ5IoFPgfEo_-gkU3Kei-02qk>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:21:08 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:58 +0200
Subject: [PATCH v3 10/12] mm/madvise: Add MADV_CRASH_SECRET,
 MADV_CRASH_CACHE and MADV_CRASH_RESET
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-10-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C5C340008
X-Stat-Signature: 8xdwbprg7q551ckccy1od9go9bon7wh1
X-Rspam-User: 
X-HE-Tag: 1790616090-894182
X-HE-Meta: U2FsdGVkX1/wFE8ZXx5MZAP1DAZJh1n7vTOQX28ew9ToESw493trac+zK7pc+egHBQVR3EofOdBSu350yvnaNJMSSRVKUOkRnQpnQok9v+nQ/QQqHYEIRf/Edfe0IbjJYsqs39tr19lmGvpg+MyoT8NfwzmwiR2bg5CDF6OD/VyAbpr9C2s2OfmGY5YAMs0elgltg8oo8+D5SiWrUluw5QuaEXxYhpUeQrDmp46qbEe5LBl9ceDsqk10aDC3w7mWhWMKGvf5ndLt7Fdq+36OBbJ7MvF29jyR4zPVN30tk9XrlJ44TfSv32RNr65io+fzFm0ySWDRvFsF//uPto0MAo8P22y2Uo3FNPgEnAE+e6UUobq5vJPiWucDPIrdK/jXPAsyHhQ7BWWYkRQAZB8Fq+oGWs2tcggdVVQpXPKtIv6F1VFwZECYieMA7Y2WnKFjMXzUc0z6l+QvQolttY8NwZcLg0vL4lx5iGlXgDL5rSm1trvcnwZI97ubR5jMo5pf35FKPzhUImHlHaF5AYHzZPr/jZmokP4xpjxh5Q6Vu3xut+8ahT48vDQYkH4VzX81MMaLVQbSmE3ROA04rbtYVbLfHZQfXzUsmRY2t9fLe1yBxzXCdGqiFtC1xaMuta1zfrRxiWTxa+nmt2uZAmqqMif1BLStmfONLen6jlYiscj+bDo6mg/vnUlDDqktxdbbefWLccoXliPKKSkhgX40S1ztqHYZTgXIccTeao/C3Fv5X1isaTkEYpT3pJA1V0rSnw57sRe5EMOMln2CPxU7P+ox+dNMvT8EB4s9dnEIJpHsSKYLujgUiz4wsQcS7RMO7QVyjHT58/KtcniDhCcbqeLeeZyvtertVptaBhkMe4/2aBi2s+JJ2oIFYlsESFmuk5Y68pLEhTx9ohpVCEc5r65U6ZfkKuM0rLgQcmOHLa3HaiS+oHqg8DTMKtQ6bP5mQWOJyEQTgqOn98aCk/i
 y/H9FTTu
 sUuRrJ/0IIYHBpPoycay47FSLwggdOSTHKVGpPj0bt83DYPWGWPYAjSpzhHtfCECXZpV9dkY66iSvkyGeppNiidu83Wv09SJN5NfxP1kxi02yblqyVtwoZaKGALF0wW3pp9EXfxDEam9QHptJ2H3F39lhCxiVWfsgKPErpg2ah2rjGnxlm+pH7VJY5jsaAeD9ehaFk5EhSNHaJUyFLd+QN2eyNirz+RI5SjlkTllrcCfafnO3sVxTSx69Exi//ltmMDEfVC6xSaZMrgN9aeYQUHUarGTSHOUCsGhmX7aFR//bMaiiF2+Ps8oCF6Z5gmCpp5oPSUhV9Xdc68s9g9CrI1SmoPu3uBsMnxzKJoVVioFa4AG22Jb3HBgO7qTA4dCtr8ncN9bOpXGGX0kQa0sG5mCYkPL/eZ23pT3Lz+an7U/W710e+bVxpfe+4c7Ouhp69inPZA8EmWljxcOcosQCKXSnI0PvEQn6RaOlacsn4HczSF8IkTvbxAQhA0QVrMTebsDRj7w2EnbOv2msYoxJjw0u+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These flags allow userspace to indicate memory pages to a kdump kernel
that contain sensitive secrets or unimportant cache data. This allows
the kdump kernel to e.g. wipe secrets before dumping, or to skip caches
while dumping.

The feature is similar to MADV_DONTDUMP but for the kdump kernel. In
contrast to MADV_DONTDUMP, it specifies the contents of the page, not
what should be done with it. This is to account for some flexibility
between the host userspace registering the marks, and the kdump
userspace processing them.

The flags set here are matched against a mask given through the
crash_memaction= cmdline param. Only when the param is present and the
mask matches, a VMA flag ("cm") is set. The kdump kernel later receives
a single bitmap describing all marked ranges matching the mask.

When madvise'd, marked ranges are registered in the bitmap right away.
These registrations are then kept up to date by code in rmap.
Marks are transparent to swap etc.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 include/uapi/asm-generic/mman-common.h |   4 +
 mm/madvise.c                           | 132 +++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+)

diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index ef1c27fa3c57..b00caec7c130 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -79,6 +79,10 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_CRASH_SECRET 26		/* holds secrets, tell the kdump kernel */
+#define MADV_CRASH_CACHE 27		/* holds nothing worth dumping */
+#define MADV_CRASH_RESET 28		/* undo MADV_CRASH_SECRET and MADV_CRASH_CACHE */
+
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 00b1be655a8b..37f08334e95a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -13,6 +13,8 @@
 #include <linux/page-isolation.h>
 #include <linux/page_idle.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/crash_memaction.h>
+#include <linux/rmap.h>
 #include <linux/hugetlb.h>
 #include <linux/falloc.h>
 #include <linux/fadvise.h>
@@ -1173,6 +1175,98 @@ static long madvise_populate(struct madvise_behavior *madv_behavior)
 	return 0;
 }
 
+#ifdef CONFIG_CRASH_MEMACTION
+static void madvise_crash_mark_pfns(struct mm_walk *walk, unsigned long pfn,
+		unsigned long nr_pages)
+{
+	bool mark = *(bool *)walk->private;
+
+	/* Acting on the zero page would reach every other mapping of it. */
+	if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn) || !pfn_valid(pfn))
+		return;
+
+	if (mark)
+		crash_mark_pages(pfn_to_page(pfn), nr_pages, walk->vma);
+	else
+		crash_memaction_unmark_pfns(pfn, nr_pages);
+}
+
+static int crash_mark_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
+{
+	pte_t *start_pte, *pte;
+	spinlock_t *ptl;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmdval = *pmd;
+
+		if (pmd_present(pmdval))
+			madvise_crash_mark_pfns(walk,
+				pmd_pfn(pmdval) + ((addr & ~PMD_MASK) >> PAGE_SHIFT),
+				(end - addr) >> PAGE_SHIFT);
+		spin_unlock(ptl);
+		return 0;
+	}
+
+	start_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		pte_t ptent = ptep_get(pte);
+
+		if (pte_present(ptent))
+			madvise_crash_mark_pfns(walk, pte_pfn(ptent), 1);
+	}
+
+	pte_unmap_unlock(start_pte, ptl);
+	cond_resched();
+	return 0;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+static int crash_mark_hugetlb_entry(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct hstate *h = hstate_vma(walk->vma);
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(walk->mm, addr, pte);
+	if (pte_present(entry))
+		madvise_crash_mark_pfns(walk,
+			pte_pfn(entry) + ((addr & ~hmask) >> PAGE_SHIFT),
+			(end - addr) >> PAGE_SHIFT);
+	spin_unlock(ptl);
+
+	return 0;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
+static const struct mm_walk_ops crash_mark_walk_ops = {
+	.pmd_entry	= crash_mark_pmd_entry,
+#ifdef CONFIG_HUGETLB_PAGE
+	.hugetlb_entry	= crash_mark_hugetlb_entry,
+#endif
+	.walk_lock	= PGWALK_WRLOCK,
+};
+
+static int madvise_crash_mark_existing(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, bool mark)
+{
+	if (!static_branch_unlikely(&crash_memaction_active))
+		return 0;
+
+	return walk_page_range_vma(vma, start, end, &crash_mark_walk_ops,
+				   &mark);
+}
+#endif /* CONFIG_CRASH_MEMACTION */
+
 /*
  * Application wants to free up the pages and associated backing store.
  * This is effectively punching a hole into the middle of a file.
@@ -1585,6 +1679,26 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	case MADV_DONTDUMP:
 		new_flags |= VM_DONTDUMP;
 		break;
+#ifdef CONFIG_CRASH_MEMACTION
+	case MADV_CRASH_SECRET:
+		if (!vma_is_anonymous(vma) && !vma_is_shmem(vma) &&
+		    !vma_is_hugetlb(vma))
+			return -EINVAL;
+		if (crash_memaction_types() & CRASH_MEMACTION_SECRET)
+			new_flags |= VM_CRASH_MARK;
+		break;
+	case MADV_CRASH_CACHE:
+		if (!vma_is_anonymous(vma) && !vma_is_shmem(vma) &&
+		    !vma_is_hugetlb(vma))
+			return -EINVAL;
+		if (crash_memaction_types() & CRASH_MEMACTION_CACHE)
+			new_flags |= VM_CRASH_MARK;
+		break;
+	case MADV_CRASH_RESET:
+		/* Unmarking stays allowed whatever the VMA has become since. */
+		new_flags &= ~VM_CRASH_MARK;
+		break;
+#endif
 	case MADV_DODUMP:
 		/* Non-persistent memory cannot be dumped. */
 		if (!vma_is_persistent(vma))
@@ -1614,6 +1728,19 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	/* This is a write operation.*/
 	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_MMAP_WRITE_LOCK);
 
+#ifdef CONFIG_CRASH_MEMACTION
+	/* The rmap hooks only see the flag as folios arrive, so walk the rest. */
+	if ((new_flags ^ vma->vm_flags) & VM_CRASH_MARK) {
+		error = madvise_update_vma(new_flags, madv_behavior);
+		if (!error)
+			error = madvise_crash_mark_existing(
+					madv_behavior->vma, range->start,
+					range->end,
+					!!(new_flags & VM_CRASH_MARK));
+		goto out;
+	}
+#endif
+
 	error = madvise_update_vma(new_flags, madv_behavior);
 out:
 	/*
@@ -1732,6 +1859,11 @@ madvise_behavior_valid(int behavior)
 	case MADV_KEEPONFORK:
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
+#ifdef CONFIG_CRASH_MEMACTION
+	case MADV_CRASH_SECRET:
+	case MADV_CRASH_CACHE:
+	case MADV_CRASH_RESET:
+#endif
 #ifdef CONFIG_MEMORY_FAILURE
 	case MADV_SOFT_OFFLINE:
 	case MADV_HWPOISON:

-- 
2.55.0


