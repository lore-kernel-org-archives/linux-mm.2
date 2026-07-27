Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7700C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9866B0093; Mon, 27 Jul 2026 05:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63D26B0095; Mon, 27 Jul 2026 05:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B796D6B0096; Mon, 27 Jul 2026 05:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 983AD6B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:52:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F1EF1C0C6B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:50 +0000 (UTC)
X-FDA: 85034092500.06.2C40DC9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68EFE40007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ocvFyGsL;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ofUGVJlLWxcXU34wDp5PR2noulXYxzV/aOVHUSP7z8=;
	b=sEZSweF1ZUjK2cvK8NzA13zaYF1NOULxqF9jti67Uy6FJvI5UCNt5RB8Mwcy0amhwdFp1D
	HcvGXGgLeFC1Kfk+1fxrS4aRk4AXevkaiJJ2z8RwhupzfbcuPRFqsLy0FB1NusQiQ8UWYv
	x60leML4/WYNoMeJvz3vFIDhhmTPGRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145968;
	b=kLaU4Vd7xrSNmScO/6LVjsy8V5AKHxiPa/UxLnTOW5/0+xe+cZNllsu+LCfSQVdzZFkhcx
	xVs3RsNx1SEwkTpbnttHQqZiHSblPO/zStybgqgCmE+bMZoNa92urbGVRl6vAsjV2183eC
	0q0hmpergyXwMwU2nmo/aaXWyFX7sdE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ocvFyGsL;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5566914BF;
	Mon, 27 Jul 2026 02:52:43 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA8363F66F;
	Mon, 27 Jul 2026 02:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145967; bh=5jwfmfxf7oRAwU0+Iu55SZwsCJdmgyHH7m7BYSAM9vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocvFyGsL/iYFJZW86XCVW5NmMRSO3LjImkEsyF0c/20YRcroF9OFB3xoBvjxWcvA6
	 m7EArpjMqQDQWw5x+DhjJxkNqIReUHRWQ0v01pNQHE6lD73l4Fdi1JZr8pYi0+w0r/
	 2COkDVdtZsgOXk+SsC3nUDO4eYUfL2MG/WPh0g0Y=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 2/5] selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Mon, 27 Jul 2026 10:52:18 +0100
Message-ID: <20260727095225.372655-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095225.372655-1-usama.anjum@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c8ejp59ygknhpki3qof6fi4odid937hc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68EFE40007
X-HE-Tag: 1785145968-946805
X-HE-Meta: U2FsdGVkX1+O1ZBAHpIfl16i1xyYSFTYGJP3wxuZ9Q2IvMqSDCr0HFKiGRDP6L+NA1TMeJ4lSvCaDfejs/a4DMQ6PZ0TcxORrGPrzNyhRn4pdOFI9stFEf4flWc+U/5oxxjQDhAug12l8JZW8X9y6uZ2kaC+e+gigBtH059meDWiE/jmduwWOYwWyxMpLVRuuPOg+lBvfsUURgP5v7qMp+fIyPrAnpvffE4XO1qHoJODDeCO1xMcICapbDMlZdobiHK2fOevPD7C4pis+txp8pHPQiC418wy+EqoAdat1ze+R6ckhFsAUOAsvUg0LrXu1DZZ1+u30EXWWndqzzIHunpGfX7PNTXhx+aTwB8aKUWcfbFOuUjfybBvtvsCdeUCKq7ImJmkuhHRjLVmEVZXIjNlvB88Ns6yvGbs4vq0gb2LwM2v7YZFV8PPsNAsxC6n8VFcJ77NKp/20Sutqe1+Uth3KDzhlsuKq6biLdVYWnehX/ycqFDwIwViXhuUnmzVSglbOoyZ17nIK9P+8kAW/9XE7JInNDEGZSWUd9rgKz+mP6d9E6WKrf5dQ42dlH6VkvkMllHYqQNn0lvLKAdgeQavCm5Be1Y1ybHvJL2+Z8vPv3I5lXqmCGUq+8vYVsZKRTxPGPklbodp62jXFOvL6fokcG5BjXzI792xK/YT6yzC08rKo86VDXsb6kOsw8oU7lrZplTSpcs0EP/iSWUsMM4vR6n4J6UXNurC/zm+/1lk/0+oEX/n11SuOOYdQha5qblCfePNw2xBRpJlo4FpHDPDEDpomaEYAxe6itDmGaunwFi0r/G8NIC4G33ceMYPKyqZt7xVWxDnghOvRWsROzUrQVd5tcoMRo7/P/VUN+QDQQnlAHVvfzZfB4p4KvVkWsYQi9FKJ0KR+6f7FsGS/R7ACLVIzeo3rly+qof+hbFl7dcVhcbX4GZ2NaPzAfCyP87/fJ+y+J4o87GkDlq
 7OMh5+TZ
 xt3mNmVLzbe+fHL2mSh2m1ZUwgh6T+tSby4mwFK9aC87lETnocYlx+jgSMqf285RaMTgdJP/IjtsDvQRDOWiXibANGDPX86hCm4oXY6yLHEYcnB9XTt0G4I5oEGyPxQwd+SDIKGQ0tre8K+QnzJmkhR1h+CFmCTfzeBteWSXkHjnD/un+TmqweX5hszD9SbvPyPuD9v+roFKhFQAD9wMjdjWeJ9iSJzm7lLwRybr8cL48K4WaIVOt4THrGWzyjQFySxTWKOxcdIkPwJfJufhQnYzNS8QJDAZk+fNTYpay9Z568fHD65IrmZ2O+jYFR1xulgqFs/l1PnrXH9M1fPuESjC4GR5HZ3RFZW7fkLRQFWeZwFOMhK08oHY1rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hole_punch case verifies that guard regions survive MADV_REMOVE and
that the backing range is punched out.  MADV_REMOVE delegates the hole
punch to the backing filesystem, which may reject the operation with
EOPNOTSUPP.

That result means the test cannot establish the state whose guard
semantics it intends to validate.  Treating the missing filesystem
capability as a guard-region failure creates a false regression.

Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
Preserve the assertion for all other errors so failures on supported
configurations remain visible.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/guard-regions.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b21df3040b1c7..5c8ec3ca75d7d 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
 {
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	int i, ret;
 
 	if (variant->backing == ANON_BACKED)
 		SKIP(return, "Truncation test specific to file-backed");
@@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
 	}
 
 	/* Now hole punch the guarded region. */
-	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
-			  MADV_REMOVE), 0);
+	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
+	if (ret == -1 && errno == EOPNOTSUPP) {
+		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+		SKIP(return, "MADV_REMOVE not supported by filesystem");
+	}
+	ASSERT_EQ(ret, 0);
 
 	/* Ensure guard regions remain. */
 	for (i = 0; i < 10; i++) {
-- 
2.47.3


