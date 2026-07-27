Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CBF7C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DAC6B00A6; Mon, 27 Jul 2026 08:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E8C6B00A7; Mon, 27 Jul 2026 08:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423F96B00AA; Mon, 27 Jul 2026 08:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F10C6B00A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:35:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7858406DC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:31 +0000 (UTC)
X-FDA: 85034502462.10.22CA036
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A204180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gqkni5Km;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
	b=TkAMqwGxBkxWIjbGUdsoybMXlp9/Aup/M62Lfnr2DzCJaSukgXU1QU+hC//tsNeelt3PXj
	RtTsw3xrXUEz7txZJ7dod46fcTVFEz/H+VmMdfbfz+Zvuw5AiABIvOWXItWmohgOjAufOZ
	TUuYvwbDtKjTsHlN5PJNvk7aEGb/MXQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gqkni5Km;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155730;
	b=qZU+l/jZ5y0+HrcEaPhQM2PpaceFk0fBaT+yeshyrE0okBv9DI+NPHek8AcLCcwYzm1ON4
	PXgBp3zqsMRBCUJqLf3OToFTGE5/ULu3hCOkJiZXMuiZhGrwlIMmoa7qTkTCruH92Hnkbq
	eQ/DbEtnMHex+aOskBDOwEZDXal7QpY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155722; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
 b=Gqkni5Kmv3trTt7ZkyZ87gi/oyZxYrHbp0W/5WSl4V8qY0b6geJIIyIpdPAwtz7vlXZ2nX
 FQ8E2o4qFMdlBnTd+LVgpyQZMB0/Qe3Pe5wMjq8uNWOZJQAUQvBFtTASU6dMPWpTlgwpQc
 MrGWxvNP0brHys1lflfAc9Z+OQntQKG3ezic3oNOaT7AGMd1iVoknbSzCsgoiKvJnBTyTF
 CwxY1yBbfeSNEZnh+7XbdnwSR//iDUEeMZYDw07ezbdlVEktI8RTbXmHcZeA2aKwZDa4Hc
 DI8HUX2o+/aJLbwWOhZezBChiM+LlPsGXMEyUlpAXShOD32ooUGrmRoJqOdK9w==
Subject: [PATCH v8 1/9] mm: fix stale ZONE_DEVICE refcount comment
Message-Id: <20260727123429.5673-2-lizhe.67@bytedance.com>
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a675088+7374c2+kvack.org+lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:21 +0800
Mime-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A204180008
X-Rspam-User: 
X-Stat-Signature: r5wwjubapwcbedxkxag5wm17xqekhurj
X-HE-Tag: 1785155727-888506
X-HE-Meta: U2FsdGVkX1/OznImqe77S1VKkgKRN5GZ09+8zi+gtZEF0SkklNtBy5V/uP54zuWteNoxYJ3k9fy93AG64cKYja9gWaRe5gh0gKLT5BVsbeHEwoisNVkWDpg0J2dD/+QvAOCXbD2B9SjZUPxZqJNDMzYpMK5OqJq17cR1JV69IF5FDo+gmDFXF7kC7FtD6+mtq6ITHDFOpfkZkKFtP1JF2Yw1MZbdJUBT5/ah/QstJSCqVoEgm/d+UeMkpHXupV3HIQjToXJ79kJM5eoDMAeIC4tOBnUD0WPnADGIYHG4XOEEktogYgqTRLEzluKfiosy27OPSEO945Wtw+2MbbSqoGvNOmajSrjUtj06PRHYObLKrD7NUQapt9HmPqSx/t5zCSNrPWzjf27suXBiVEfnMYRBaWZ/qllQcUXPSVUq/l9XI1EigLcgGInCDIOXSqzRVAMQ/xcHsEB4kxhvuaK9P6eMN5PoZhPiuwjORGpXnKRIZ6h3i4DeHVQTB+GfbQi1CLUAhR2gCVtFt9dPVi31XToPzs5ReYXRT7W76SSa2HMksgbC8F9g3/wS5u/SNJSo7Ib+fvv/25r0Eqa29IRH1da4PqByDl3w1hd3hEeCbr2OA4PqDDK6bkLnBsuSE2vtOkyvx2JzppckNT4LiQOuAFaDWoJFQkvRQqvkUSLJhlKYoaTZhsM/co3gq2cEVyndfgfsI7CYLJgDlQaWMVYXd7VRcXz9o+c6tAvxCYIK3phlY7fYB951fnSS7t7ZA3nM/31o4EaoGpmCzQA4vXkxlYJKKJtxOMimFb7UGaEoyFvQuz8QhnmPdnjvID9gFifpypYMw3tpuo0VqCvLdh0aX53a4v75qlzm8edCilSZ1ALzhBbYMxKNHIlT1v4ZlnfRlCKrCnBsHqN2GakCmJfpii5JzQS0JRMMm45FhXaKR501N1w/Jmu8zNh3wO66DrOTg80F7UbyjVZxp0bW+IT
 d6d+UJeH
 BYkTnJ55ZlJ9awOFSGhK4TOZAMdVtjbfT9R9oFdgKwOIqpElPX2UiJKZaNGEGPfI6Q8CzKRDGwnBl5q0uJBAg/e9aURjupK459Pb4Q8NzYOMSA+c4WTrZxWVnF/9sgGtrCWEPabLZ+GsPHYg08j6yPLbpmXTXS+7IxP7nual0d7MAbLVmrfwiwHjL+NWdR/64+mqSSkd6aIoeT7XBMuu/APmiIP5ujppxsi82pA6s++oJKxCXJl686fWy9H5ejiPrOMbGHx538an4ZAI4f7A+MgjJ3zynDPwPwHVGK2vJigKGoENGW5RNHF/uEMfjpmupO2JfTRnp4zucqni6GurLYkRqFqurSJoA2N/qhJaO3Nb7s5DCXu5xBmhx06ZEY1U+HAg+paXSzE7X7+UL/CDE3DliuxRQ0qT8fwgWL0SgcSCHvY14R3Ah2ZWmihqb2w3i7KWWGWoH7eMR9vOMhkuH+NdfIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..95808ab5cfdb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1030,13 +1030,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page->zone_device_data = NULL;
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

