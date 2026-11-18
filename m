Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E14606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AarKLyam
Received: by kanga.kvack.org (Postfix)
	id 358A06B00EF; Wed, 18 Nov 2026 05:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309AC6B05B0; Wed, 18 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F95F6B05B1; Wed, 18 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0EDC6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:03:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E82EAA06D5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:03:09 +0000 (UTC)
X-FDA: 85447801698.22.66A2D12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EF10340005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:03:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AarKLyam;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996188;
	b=W0YYGc0V7XGcvyDN7tn6eW4Jr2xrmRTU4/sOwrFl3OCJSWhAQNHUGVhzIATh8uamh5NJ+C
	J/iMvRWisc0LR1qIKX8g9/ijQ8FA7eWZC0H8X6Msk85I8I8DIuxryimkD7PtM6xm5ZYgqR
	7E3lBuBc+1XmGX78ENDbC2HmnKLoY2E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AarKLyam;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z0El5ud21hvo9zkOQkpb06wEE6/0ipRpI83CeEG4nzE=;
	b=V3BIljfhd7Oc56XeePw4S4zG0Fj/OkAkFlOASyGbqqoyukiApA5NwkF1K6Dgc8/Df4xE08
	WIwtFGuFmoOE8vY+pLpWUsfCXw2ABZ+7NTIU5sIvFi7Rwx6OzgQIkSK3TabGqPifhK2qKz
	wFSkT8ZEPirxOITMAkDndJLT3MBJHpo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDB2041E58;
	Wed, 18 Nov 2026 10:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3631F000C4;
	Wed, 18 Nov 2026 10:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794996186;
	bh=Z0El5ud21hvo9zkOQkpb06wEE6/0ipRpI83CeEG4nzE=;
	h=From:Date:Subject:To:Cc;
	b=AarKLyamz6h/SnGWiV/CtG5grW3wHr33Xq8qhuemIbmwM3uNzUUzdkxUiiwOIQqsq
	 LklnrdydfIr+01eZOkMXVUDBFxMOfLBEyhpdBacHcdVy3TX3jNGmCO/Ah7rdoM6K5t
	 lFygxMM0JrJWVzXvkDoKsQ9z4SWmrhtDUhI+JCznZD1yuWHR5LwF/EKxMDE5/Lm++k
	 +luS4FZeqk9DkWGVf8JTzR0Fv188xVcr3RfbWH1fAUMjtYFOdgfCo58KvvOsU5TAYG
	 6hOK74Wxv0WjBUujadXoj6fhVGQh9128hpwjKafVukssWaPWP4EBwY0clZwx1butO9
	 Uk5if/PsqyaCQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 11:03:00 +0100
Subject: [PATCH] mm/userfaultfd: reject DAX mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
X-B4-Tracking: v=1; b=H4sIANN3/WoC/yXMQQqAIBCF4avErBMcFyZdJSJKx5oWFVohRHfPa
 vnB/94FkQJThLq4INDJkdclA8sC7NQvIwl22aCk0ohohOtTd3jvhPSDstqhlaaCnG+BPKfvqml
 /x2OYye7vHu77ATZX1sxsAAAA
X-Change-ID: 20261118-dax_uffd-0fb2c6d1c087
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, Jingyi Sun <1045704958@qq.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1948; i=david@kernel.org;
 h=from:subject:message-id; bh=L99WB27VpnqQcZGVfFWLDDBDfUeAgBjYMyJA4p7jg7M=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+ll/7bbC447R6+s+7cn12UyVdvQq+zXkZk+fCJ/c48
 VRtC8v/jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACay2JqR4aJ9BcOWxXPP782b
 pj9N7mqg//VTBvkz3h0XuG5z+YZWfwjDP1PPDcfPK+nbFjdUOxouuXmiXMhiosXtPDFL0arE/aG
 aXAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: EF10340005
X-Stat-Signature: gsi4p4mm16hbnu6am9j6bbha9gwkboop
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794996187-9524
X-HE-Meta: U2FsdGVkX19XZ5GeE59I9JNc4J3fUESYLZZedz108C5N1od2aYzMQbkMR2NuS04mMxx2EK7KFx3SOzdHucxdv1F7qWFxeSEKV/T2vwr90LjPm2awsJPV1Di9EirsoF+LbbeQ9UbSGPRHWgqfn6/6jL3LCyALSH6OTemTGI/MLKXRJx0YahLbQaVzhZHBfWDGVcH77+nwHiYxPYoxhLEG8v0SCL5XCpHN+SF5iHmrZI1Zj1+JPsuomu5Q8JfY3jeF2Z3dvFSmQxBVRFwk2DfOC8/wv5I6K10tQOZUsbv8jAvJAGt2yjCAOzvJQmpwndDg6QlTonwVaxeDwj/Zf4SPnshuRzm794eBwQiOSvC1GC3ZO8Y9NHClyVG4bg3cPH3ZM5VNPpuhpUPXOMW6kONVo6T2uPniKAAIUIBpsbFQFTtObepPY8mHZkklMnNfWjDnqI1v6ZSWFsXlMX3juRVbPd9S+u42uSEqiCb4gBc2onEojUN64aDJsU3cGunuwTTSI3ijnVVLZftjgd1QhEVEHwwnH7RE6L/pyhbu1OGbrsSNICNh4g4puth5I8zPwcI2RKYchPgh3zVND9r1gvoQquRuBpMaDjAxl3FfcII4pQL1PN8TFNAtneqipsPMAcei8GXQOcA2DdnEQtgPdsiw/aQtZN3wdjVwROXcgkTA3cykWU1dpyXJr9iOafBgfxXBB7TzlW31W3aPDqU+73hwd7rSTPYw4D/hRh7MJHPyHPFp4DbUArYUt2ao+6m23gIivP24aJr3CvBYqdltYE5eIe0qTj2hS97cryrc5m6LLCp9mkxleWbEFrVsZJefqKJZBe7Zsw/oXmW48FW72ct+lzF5xcG2W8xDiQOsmTpUY9eswIAJ2QChXiNizi7RbCMd5VMthMVnUw99zta71q2qmQU7bvrjpIkmv+LkuEp32nNegRlJQiUFgiZVTSM89sfl0hMZWs+3XxAIP91VTCP
 ZBGoojgk
 LtgDxA8ixYBpG/1Rt+D2tMqqHbTFaadPSpTl01hJuo5Fmkwj4ZAVsE76ayikwyWLr9k+07q/gOfp19RtW6/yFvXOGg3GDv7oOGa+Ntj1/tZZNgVTc+kkQKJ5/GqtacZt+8OnypdD5O7LzO+STyeQrpZ7l3ArP3hpYiC2rRAhlIityFHWdBiBQXyBlJ365bXlZv2VDC+cJaYt+CLZxHk6il8LjAmDOAbiEJXDi1SK8xXRU7NtdeT3/CbJnmce9Zv2SaR5EZIZ0t55j4K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
write-protection, but the DAX fault paths have never fully supported it.

DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which
treats any non-empty PTE, including uffd-wp markers, as an existing mapping.
A read fault on an uffd-wp marker therefore returns VM_FAULT_NOPAGE without
replacing the marker, causing the fault to repeat indefinitely.

PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX write-fault
path can make it writable without clearing its uffd-wp bit, breaking async
write tracking.

Device DAX mappings requiring huge-page alignment and cannot serve PTE
faults after UFFDIO_WRITEPROTECT has split their huge mappings.

So let's just disallow DAX mappings in vma_can_userfault() entirely,
making UFFDIO_REGISTER fail with EINVAL.

Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
Reported-by: Chris Mason <mason@kernel.org>
Reported-by: Jingyi Sun <1045704958@qq.com>
Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 169f681f9849b..6656233d5dcc7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2131,6 +2131,9 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	/* Only mm-backed memory can have its faults handled by userspace. */
 	if (!vma_is_mm_backed(vma))
 		return false;
+	/* DAX fault handlers do not support uffd-wp. */
+	if (vma_is_dax(vma))
+		return false;
 	/* Core mm may discard droppable memory at any time. */
 	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;

---

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

change-id: 20261118-dax_uffd-0fb2c6d1c087

--

Cheers,

David


