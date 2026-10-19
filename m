Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CF2CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6986B01A4; Mon, 19 Oct 2026 07:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658846B01A6; Mon, 19 Oct 2026 07:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E5A6B01A7; Mon, 19 Oct 2026 07:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1FD6B01A4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:31:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6D831206CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:06 +0000 (UTC)
X-FDA: 85339159332.10.02EE99A
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 49DFC140002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jbTZpGmS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409465;
	b=NvDrtIlSR019c8mqZJ0UsmQmSbsZPxvipWGoBUgBCjRh2D6ZcATKTpLeKFtuaEOl114Msk
	yTTIBREA613yc4ojgzDfb6DYFWwTVfrsisa/uzeG+uLzp81Wp08hjbVCuo3/PhP3VlEikU
	ctwQw1SBtVGy5HI/Bv8rVzL8TMHQ208=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jbTZpGmS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DI7kK83J4MCMLzyHSrOcI7YxD9ZT6Sivdf3ckBQTOXY=;
	b=X45tJfHSvLva6ZxAsKadUF94xHWgaFZYkOUL8yGx5wlR88RR/iVB7h40leSnMWLbyQB72U
	kG5ySdORFhtqL5LFjHl0xlcIZvmUGeQKYyHfSHNc7dA9SQW3aKPIt2beYS2fHx0bmPJjPt
	sv7J2ufUTKnBdjOTBY4mS4A+2T/TeVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792409456; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=DI7kK83J4MCMLzyHSrOcI7YxD9ZT6Sivdf3ckBQTOXY=;
 b=jbTZpGmSuB6PI8K8hQBxeU8k774coYmL/rjNCthoQXbTJ7cIXrapP0UNLTw1ukigqNQxAW
 +Cg1dysJHhTz79AqnRzDsedIGxRnL/sJoh1vgwr1l9s//R8n32GXIDjS3xwwDoyUv5nCqk
 IeIVW8aed1n1FVxkAfcxJOacyUuimPCHUxuQXXp316yNwJARElHDV++xQmGITInAp4R7PA
 1VAsCMVYVI/6pblvC9/VqZ/62UImgYPydpyFv4yb+fFkORjQlPV7SWCvMVapkXufuEC9Lz
 QwIUUVKm30wjfF8C0eSD981r6H55YUV2MsVqZWC/ieZO+CfB3EmMJJhROf03Og==
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26ad5ff6e+1e9dbe+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <peterx@redhat.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261019113034.97690-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH V2 0/3] mm/hugetlb: fix mremap bugs
Date: Mon, 19 Oct 2026 19:30:31 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 49DFC140002
X-Stat-Signature: 3pystf9xg5q36gxousg4hxqnuzdpwsgx
X-HE-Tag: 1792409463-117204
X-HE-Meta: U2FsdGVkX1/A6yOFYVSp3kRME601f7E3G8V0v8F8gSlOBBEu62EOaJskSll26M0tN729l0GFWc46rDSaJ6WUxsyAbqpKXGYzv9JGPhOUT0nJfwEITtUfV9g4tgFdiJUjbtRfAZlsT/OLn4he4clZsoJsywAKngj8pDlXRJG0/yVKc1t2rcTqFTT5KFDnYOSf3ttdg5Kbrlh+oHH/lEsn35tkSDe/j02BBGt6Rr3q6TuoHngZ+wbjRNwj04qmU9EvEIcUIeCiJKGLYQkpAw+h38qD3joWDw02CVGbhkkbQFxtmzGwsLf2548jspc+Zr9zT+0nmXQnxCOiPNd9vGaLuzf9dFi25GE8QihH4Q4fQv8VXLdL/GtN3Pk6SpqX4WtTCcJKTr8izBb9EG8oxaFlYin7QXKfPLFOqcs9jc+cotZPxBc/AnGPXJM1GihIq7pM4tcvuB+0c2yBYlZrHD4TJxiBrYC9P8kNqGwD/HSsJZ2GQx6/gdGDQTu0YOvd5aims8vmtLZmgajcCjbU470iQeCoSLTOswTHT7fhndIVxHd4BGF9FEdAUkl4SjfHOMP8cms+isgyrJdINJfRJG2vvP3PK1qlpr2sLxuYgjgSQp7Vqlrs+EWBR3Isp050t4I2jeSJ4dUy7Y8G4ADFXYvfgtzg7aWjN0WQogVS3JbljlOjW1oEdiShebii60e+JYTF90CUhs5xq4zzToWQvbpqFd8qOUsk34/ecLin71RLSfnpxgIv8H+fYXbrrWu9MQepNZAM+aYDxzH45+wIh8h3euGyRf54m5saMMZWO2ueEHCEbh2Asjt16WtkmqYdmago7PF5w3MRNd8/jX/5LTGZ9NI1ReW88iI7zMpHQrv+ixvzwGfl57eTLV96Ty5/EPG0OaTmAyjTy0BxxdoBpRvsxxll/7+qmBfsT1bwF04jiLhgGNci3FP0mScVd3nu1UBSyZZTCCr+zXIF52UECoP
 bLIAk5kJ
 OOvuLICmcGfNM+uI/Tsec4GTVCiN1yFzYIf5eRMTDhX1xCV1PZuExhMfsPUmzHQ5xJlh2owooQwET2GFa1EmmZrAx8hFwJDQeaWjhkAWtuzqy34635eImFQIsVjRqLgz6Z/aJwkAE3dDOGgs4P5qoFISFCeTaLScz1VEdrVhspglnJ5HX161WIXWrF12CKMybRtL1POOHiV5cltKrbUkZBACGZ73G1a6S+NPRA+HpgfBL3nuNIOVl5rSX8qFF3FG1Z1pd8xVNUGzxKgQk4VsGDgxRUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a few hugetlb mremap bugs.

Patch 1 fixes the return type of move_hugetlb_page_tables(), so large
hugetlb moves cannot be truncated when reported back to the generic
mremap code.

Patch 2 disables hugetlb PMD sharing for UFFD missing mode, because
UFFDIO_POISON can install PTE markers that must not become shared PMD
page-table state.

Patch 3 fixes the recursive i_mmap_rwsem deadlock in the hugetlb mremap
path by avoiding the destination PMD sharing allocation path while the
mapping lock is already held for write.

David Hildenbrand (Arm) (1):
  mm/hugetlb: disable PMD sharing for UFFD missing mode

Li Zhe (2):
  mm/hugetlb: fix mremap move length truncation
  mm/hugetlb: fix mremap deadlock when PMD sharing is possible

 include/linux/hugetlb.h       | 18 +++++------
 include/linux/userfaultfd_k.h | 13 +++++---
 mm/hugetlb.c                  | 56 ++++++++++++++++++++++++++---------
 3 files changed, 60 insertions(+), 27 deletions(-)

---
v1: https://lore.kernel.org/all/20260930064308.58159-1-lizhe.67@bytedance.com/

ChangeLogs:

v1->v2:
- Add a fix for the newly discovered move_hugetlb_page_tables()
  return type issue.
- Disable hugetlb PMD sharing for UFFD missing mode.
- Rework the mremap deadlock fix to zap the source range and let the
  destination fault path populate or share the PMD lazily, as suggested
  by David.
    	
-- 
2.20.1

