Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9426CD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A116B0092; Fri, 29 May 2026 21:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB566B0095; Fri, 29 May 2026 21:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0786B0096; Fri, 29 May 2026 21:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA796B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:19:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FB661402DE
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:19:03 +0000 (UTC)
X-FDA: 84822327366.19.3832EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF62920006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:19:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/OACeMT";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780103941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zavFXgPgtkfujBTAMgZU+Bxfz/sYALE+9GnT1He9zF4=;
	b=SwiJ0rr5chXSng8tJJdL0AvuI4Bj04PhG2te1j/TN5YqIT5/TPddMLTWTj+ojDxCd+muBp
	ZPm6l3Hex1/XvaywCJySa69Le6UCeScUKyc9iV6oDUlgn/pFPVEcOGtRWUfD5ppn417kaa
	hrRwVRLRtJXoNGlpq9ErNafwJnOSvrs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/OACeMT";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780103941; a=rsa-sha256;
	cv=none;
	b=x7lzCiBFeh87yfzpqxf28Dvg/lboVjp41evIzH61YeD/CRKWUXwmQNV5LeaKLJm6zd0O7s
	Fa0cPXN6KD22f2y3GBvTZV1oecSdnWp8LXsEOLudxU8d1JpOQokRw70SLoos7tLQy9yvS3
	ht5dJThRxMOhCosOf8lj6Tnw1k6MWgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ADBA60103;
	Sat, 30 May 2026 01:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689EB1F00893;
	Sat, 30 May 2026 01:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780103940;
	bh=zavFXgPgtkfujBTAMgZU+Bxfz/sYALE+9GnT1He9zF4=;
	h=From:To:Cc:Subject:Date;
	b=f/OACeMTdRDSkdOYCNN/dpJFMolB8lHP5PzJyszLkICvTNrhL215pqHed5se0ti0N
	 XkGlfcsa0JDhBcbUP0wh5amh0tL1iO12hdmbgF8KWbKmwaDZvs2WcZJ1iR8svT0iAV
	 g+qhMf5Wbnap8XqGefKuJsEthBXDWu4/pUg299i06q2u/J5dObFvpcXAVUK+dTpC8C
	 BVXDSc4wzZMEXJsp0gDUjmsBgsHl3/jV9HQ7ai2+ZRIlCiFcuerCQlMWak0+L3Y/w8
	 KGtr05YfHUvdMpmi0t465rak3QnwF+NIWcOtKUOaLBOWIlxF9u8LH4dAaLLGr5pihf
	 sCDaXwXc4nRhA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] MAINTAINERS: add ABI documents for mm
Date: Fri, 29 May 2026 18:18:51 -0700
Message-ID: <20260530011852.90663-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zjiyaqpfnfnywk947zi5d7oa5tj1wjid
X-Rspamd-Queue-Id: CF62920006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780103941-11400
X-HE-Meta: U2FsdGVkX1+mVEx2K8O8xx0fmv3J2/KBOcxPVIGROZM5DcEcg2z0MFAxBv6h5yHfiB3lyl7JsBRULSqf98YpEC5/6DY3nklIYpORI3AQmdcu5ae747qlMxu7fWDir0+V5Sq7D2RhqHHS3BY4BhEgZWj5V9hyqPOaX0oIIjrhtBcE0Zj07UZKk93P66L/ruvgaB8zEEJxELbbQELW0YvZ/Q2/I8mMlTK4O701lqbtL6SPGzbDx+UyGtJhoVTl3T4MdZX9FJgg3XoY60b4961DkO+m7E6qW/OK/JG8QcsSIfF35SAfVSbNSMdt1pK8ipkwQjSAkhtPayKVw98BNnoGHsuJ7OR7T8mnjfhpnj2pL+WwNOfcVn+g+NBKW5cYXmZ0l0sRfUqZ+0Cz+HGtYMgiUT5+pXGyziEHEJgIlxgCYhcKLi45dTt5PKklYcsrymbQxqUbENsw0KtLQlbcwvm/n4hR0/+Bze4FRqS1BI7RZQi7M2WVuGF5wwPTv9wegldsfrZxQWmK1CHKp64HmIPWuIEMbXqtPuDqVq4Ri2lMdjIpYDz7rZiX4BIp31vqkujFAxtJh5QbjQHnA4eyhrBfq6wMT2D0+GXUTqUvuFEqgldqYbrOdQSPSF0MIebD3K+6eZ2LWCtHrl/bz+YkrLYOX/K1q+0abJ2EL7RQ2bFSHpt4y/AnV7G/HcXJPlg7WRhRN4iB3WAhFcJ87BpSDWdxNt24ESj/T2cy1qwOB1/47JYrVQdXTKIRCygBxdbCl72rXw0Phf3qMnOHf121VqXvnFxY6K8N9UKtjH/k6JqSU/LNy8jJiGFMgrfEPsPmP0xwG1mPKvcbtwVuweVskC0wjmHLkRw6ziANG1zQcaYCdTw7WYYPV48yQ7+kdAYlFA23gTCq/yQFVw99xl1y1rhK6dBLP28JwO1h7JTDe7fJ6K3GXqL1uhsBM6zpIVyPitZ939qMSD1GsMDiGWIW/zi
 3BjI2G5h
 80Zq0p1Kba3lNOK5+oiHv8pldmYm5BIm742RCHc4+B4hZfx9/4iY89kd4Yy0xIwm5wDxtQjIbAUkBMFYU1/WqfETjUsrP0ukGwjbwLpwzx+gI6BIpFPr/ZlOPScQJ9RoBJiuOdqUQwDXyGzDzM2di+6Kg3h87DQZc01ShVrauh5xW8I1TQ80pgnN7OyaGNUgJIwgAqjAy0BfUc0/uaIQLzb0IgXBGU9Y4u9Yg9cKwxn+7e/UViDcXoEvstvlZ2ykhgvzR0jD8KSIcjFK6/m6D/O51bgAo88ayKUjjI2o2SaI/Cw9hJtb04mmuubY24cZJmLIOTiIgaFNWjrrzt7fWcj7puNYQUW/VwzRf+BJo+nC2EDVswVlKVMSvAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few mm subsystem entries in MAINTAINERS are missing their ABI
documents.  Add those.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
1. I found no better place for mm, mm-cma, mm-memory-tiers, and mm-numa,
   so put those on the 'MM - MISC' section.  This is an RFC mainly
   because I want to know if it concerns someone.
2. Also, Cc-ing only 'MM - MISC' M:aintainers and R:eviewers to avoid
   too many recipients.  It becomes ~50 recipients if I add all
   M:aintainers and R:eviewers.

 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e119182a8911d..a31f6f207afd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16854,6 +16854,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
 F:	Documentation/admin-guide/mm/ksm.rst
 F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
@@ -16876,6 +16877,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
@@ -16918,6 +16921,10 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
+F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/cma.h
@@ -17041,6 +17048,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
@@ -17068,6 +17076,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h

base-commit: fdaad90bb73cbc2dad3a72c3bdbdfc05a12b3a85
-- 
2.47.3

