Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FEBCC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3306B0099; Tue, 13 Oct 2026 05:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D456B009D; Tue, 13 Oct 2026 05:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099B66B009E; Tue, 13 Oct 2026 05:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D68496B0099
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:46:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C5CBC03D8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:33 +0000 (UTC)
X-FDA: 85317123066.08.69E910A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AAE1160007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Zzu6nG7s;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogyHpv3GDFejRccrmEx7QwtXi6po+XYV++it5WhtEjY=;
	b=OMUD4EW1pdsBelQXOO4fcaqKxl5z+46fKGLw280Vk0F7mdCUxS222bqHFyCz/yA3tOT2S4
	cN6FwulDuCevX78mzfMrIpyl9jQpzt6vXowpS/SB+Tt9vGXNTJBy22G4eWXSVB/3JnZLRF
	TR2gZ60DjWsjFYQ8+DKcEd8ViV7bLDI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Zzu6nG7s;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884791;
	b=FN2mNDad9CoLDsHKapY+RsFzr+Zu0LqoK0rfVk0aKwAWKFpncWv93/c/oiMTEvl5SRxgph
	p89gZ4mDS2XlKfMs01qJyZL97MD1G5iMULBTN3cKRhiENAXkD84MFxnpg9dTYeSIsnaCiq
	ZQBo9svD9tpNUoSQJRMb728Thv4GcVk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4638F2934;
	Tue, 13 Oct 2026 02:46:27 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04E983F7B4;
	Tue, 13 Oct 2026 02:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791884790; bh=Rk5F+YgXDtLeCJh1Tw15hbS1luettNZ6/VQSYJ/YyaA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Zzu6nG7sEEU3wq7e8YLpxUuKNz7L/c63u5rqI106GFvaosyQWRcwezEQXe1K3q/vI
	 YGEBPaYtRtcvlW+7g6rjOedPJrEFHKniD55pmEOIoxlPuc06nTV003DfmQfgIaRXIo
	 F5iCF6UIdMYcGWNbd9sCPj8Dcjbi1F8SL7zacVUs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 13 Oct 2026 10:46:06 +0100
Subject: [PATCH v6 3/3] kselftest: mm: introduce size_to_shift() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-fix_hpage_macro-v6-3-2c52d0484de3@arm.com>
References: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
In-Reply-To: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1845; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Rk5F+YgXDtLeCJh1Tw15hbS1luettNZ6/VQSYJ/YyaA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqzf3mXDurSPW14xWa1Yg53Yew0NcF722uPAkgr
 fWCFRdvgNaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCas395gAKCRBt1cPRWsUx
 M1FQC/4vx32QNecL5GVdpG4R/rcnuylGSMdFDpzHdGPZbebIYCcuYvdcrQUx8rcVf9DbuIlzuHB
 SVP38VmBOdkOstbS8JU5NcxKDuiH/zCGVt1Gmuypzt2hhfA0iXhWOCnAn1uu0fzQdF6vDP1tbof
 8QpZNGWPeL7vYLPw0vLZV9YuW/NY5+bBbK4xtKwSofXcFOI7oVrJD2s7ctsPjiqsyLbfdxezzv4
 znpkhv6JwYHCfWrN47/rB24a8bEG1eBCoeH8WdCl1AYH6f/YxdY6OD9292CysqK3URfbVR4WkQu
 wYGcjFDCY3goQ+cJ5nxwP5kM+C5KZ/Xmn3Y/f/X+i/3mxb2EGdG0PQjMpKcZyUK80GnMDV61cLd
 xObOA20X0QRx/ieiaVlB9qn0w34wEjRCY/pKY91cC/ew21cG3FrNAlgTDzO9terWydXot3ex/fE
 4Tpjsk4XUw0T96DCX2C2OgS+9p1w1RY/Kz1tCcxeFuHuMtYeuxTx7OqyLm3f9PVzoLpyE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7AAE1160007
X-Stat-Signature: c6ng9y5d4qmgdrdtfe7e5thmosc8txyo
X-HE-Tag: 1791884791-107592
X-HE-Meta: U2FsdGVkX1+1zBDgYFF2BOE5W2RTlLjefcUdodNOqF4TxCls5gEO0X+jDjm9IlGid4MNX2fbkaNokPjm9yrJ1nSOuc+32fjEtItFdNSVxKhNMuYg5TDIxb0Pa+ZJoHT5U5M43ZqswTpHINgTCJIKB2A/470O1rrELuY0z1j6yrwTb7s22mKuzRfE1wu5t024XhmdOGGwz1iTNCH4/XlTRtImUrcVgtcc7b0S86x/lFjYdeVOeYV5BwwYhZBHDO9oOPwupDIzXzely6zqw9vC+IPxuQPLhe5cfPAXHIMlOG6fLR49wOwGQny3J/zZ3nHm3GpDJNVek/zcN+31YNkBtB9Brdc9/59WmyoOvuJ+X3LhKqANTPHoYmNEhcLlWqbNeEVR+/Fha0drZN0WwRQaLdIZ10QDbCVi6dERvzVjHUWb3KBlZalEzGlR0uVIATABirGyrs2yszG6kq+057NEtbJB1WGfUyeOdzOhiUjHaKZGfCeTZ60Zi3Wei11PM+EPM1SfZT3UqQm7gUeU7oxgtSyQSmyMGZnfLVbvfSfpM7UBwgKG9weVS+Y8EzPcV4TUq+fuWQKNl/aHZkW7mRtU8cJHaKCI1gB8EFySpN4/F/5+OirJHkX11Y/wEFXYfRJHkPes1FQdJ44B2CIwavFsbcQkr8FjvggUQgbxbNKUo1tiFKDkuNEUjv6puAVwqZKciSf56HzNBZrd6A470SlRRMBgp0ZCpzF/fxqPnyWVdTHTXubMJrnWxfT8HdDy/jXeg9kAGZj1n8uYYfWoH7SSEpcq0OlqglfNsepmti4cSkb8GjI/97NPkIoQ0KnWHfSEomfsRIKrU7bmxf9/H2Dr6xxCx7xCO0Lv13Eh1G1O090yPQ7YogADBCgSoFCZefW06IImO68qzYUKON+j9/lt4EXhdsOzfNRCAoFKMqOOPqYwUDAgEkrfDLtjRwFgb7TwrlhG58avw48GJ4eh+uc
 8h/sinkT
 rCA2uojumekKSOFXif1TiDFao2MBx6h+/NHGumiTZ3uBl7WgP5QUzCkTuI+j+/uJV1a6kepTkQZW6aqB5MUF7TAAkhn6BiFgJ0mIZ+/9PfcgxF92/yeUKPMpkeOzQvYXo+nbpNPt4c/+9Jbysh1icj5PiIOz6OdwnwfTWDaDeBOumQrwydx468c5/fpCKbiwlVUgJkIyFG6W85vWBUGn/amnxnht5zoPV3/lPsGY36VeU+A+CADqp5LmmcmyUCsi5tFHq2+vmO5DdYruDC1KRkAOu+rAc2NB/hxh3Blz2hUGCYVKG+wUa0JYgQNws2Y/O6sdwuPQQHDgs6iM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c |  2 +-
 tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index efd99298be135..7175ac8bfdaa3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,7 +194,7 @@ uint64_t pmd_pshift(void)
 	if (__pmd_psize != -1ull)
 		__pmd_psize = pmd_psize();
 
-	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ff51c61636505..67ff4bba5707a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -159,6 +159,18 @@ static inline int sz2ord(size_t size, size_t pagesize)
 	return __builtin_ctzll(size / pagesize);
 }
 
+static inline uint64_t size_to_shift(uint64_t size)
+{
+	/*
+	 * The function returns the corresponding shift only when the size
+	 * is a power of two; otherwise, it returns 0.
+	 */
+	if (!size || (size & (size - 1)))
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 

-- 
2.43.0


