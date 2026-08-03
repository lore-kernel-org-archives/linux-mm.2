Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3E6C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FB66B0088; Mon,  3 Aug 2026 03:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4075D6B008A; Mon,  3 Aug 2026 03:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E666B0092; Mon,  3 Aug 2026 03:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146306B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:10:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F3BD80602
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:10:38 +0000 (UTC)
X-FDA: 85059085356.21.21CF36C
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id B16A340013
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:10:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YJY1YFBt;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
	b=MvK9SGnEiA04bIi4Dzyew6fbZeFpwgHYtzuq1cInyjerI3G+fZ2gXTVwM05hfXR2KhTnw5
	M4W6WwXiBmjZ7O0rqPVTm8XUaRMIFxYEaUCudb1/iMJtrzMg2Iqjdu+8IPOvcTUcpiU4bG
	JoT0tJo3KaTGtFGAsCG/lTGqcTgBHbw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YJY1YFBt;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741035;
	b=5d0BsmW6C+JVY24P+YKt591r+tPYFGn4X8uwqAzAIuOuixGA9MJEvAERopfFmPAIh9M4fq
	rID7f9M3qZOlvTmhgHCRB2ZoRSQMKbRcuNBe6bx56ZTRSF3Oz6Kc/nv1aE1blx8p7RszVa
	SmFZ9OTRS0z7IqDOewm00PKAQJS6IEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741028; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
 b=YJY1YFBtKW3JqwlCO7YC3pvnJHu+z2RM2/E7X/VL7QG/Q+ttFCGS252H6SnH7gQIShIgNS
 Msa4UKKrHGDfPGZo5Uuz1mgsPcw9pVhEG5r5azn9tlAnZA3nO0Y110nzdWJ0gcmUjO0dfr
 WPGN8uzC17mZZCuXIKysrjKw0SFQLea5dbSyiHyWcTIrRc1oDKH5SPkFYvq10zD4mlM1WF
 AsIt1EXLBFwEJCY6dBYjxCy1v/e0T5FKtRzU2czayeutDJQFfAl97wtbWslmvK47P6eYYN
 RkpVC/vgxmMy3QQGsA8r1Y16qQVF6ANpMYhnpkfEBWi46HPOpvh9wBOe4mo/CQ==
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
Subject: [PATCH v9 1/8] mm: fix stale ZONE_DEVICE refcount comment
Message-Id: <20260803070929.86075-2-lizhe.67@bytedance.com>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:22 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a703ee3+34caa6+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: B16A340013
X-Rspam-User: 
X-Stat-Signature: gzft1k66mxdo374jfspnf4orwtrg9bj9
X-Rspamd-Server: rspam04
X-HE-Tag: 1785741034-305859
X-HE-Meta: U2FsdGVkX18Jp1L31AtKIESKAtqX+gpDiinpZ+omq8EZKzfTaF/a+cAz80sK9CEME8HV+jgE7ayW5m/4rw5RIWvKq+pkidFCUqftCSFg8VyvP0HusjfGThxhOKgCh6zVthhFXAMeiet/glGbdF+2/QZ27RpjloqQh7rfLTzOI8tOLI78PhINIC78NqN9UUJqQm7XRp5nZH58X7SMecflMEvbPK9ZPZlH5+YkGuSKVsFHIxD2zKkSv1PQd3CW8Hd7Pkps3UiCY1VDm4FF/vZ01DbCc81X20n5tdSU6aXXKJKAhGW2/oThLhzj26TvFalBS2XGiP69zYsMwl018nthCtnUD+oyKiHLV0MZ0vOLrz/1bSASkadY6ILroNSl+vxLoBv2Um/z3gZm1t4XwKwBFG47Q3Vp62Ps5rb7uE533lU2eqfM9TAjGH5SlJroVSmY2RW2A6fTlfDBxz7YJq3eLFhZL62LWMIlmWmzxwGIXae6aEiJ48XgFQMBKeILnz9SBrU+u90lmCCPoM21Oec2+hkgTzzxri2yBxSa9AuoZlQv9/xBC7TNBDYKUmIJpBK/IX9dhKRnlN7LUeFICla8JQY4Ph/RQTNIm2rUpylbOANOf7gn+az/zBcCkviP5wE3nxT1/q7Ha+Rzkeyz6hriaaCFrqw338GNO3r7koYPRz+dCfC+I3hby8D64nAc3ohqH6AtSVa3QCnoZ1l6zj2ut5hq6ewImaulLlkOmf9p9cC0P5486N6jBuKjB78sN1EKXtNSBlErIzr88x7mMFipmbtA+EaUmHwanuKfCD6mgOD23Mr+n6LSJLCWrNGs9/cl3829UXBBso2PfqRucoq0nn6TfxLnJdSM/W4PB7Np7MnVv0g2MxlCerTDVnA6PCHciDVFP0+fQtgN/kdYKccBv9Rp/G7Z9k0jv43rAW/i2Rppa3SCtRJHqpzjyl6Hd75pKYJjXwRFObQ5hSQM1pC
 o59rSGST
 eRFl7D8Uc1Gbb08j4sw3KOfDaTcwlNm5aP3ZcHxSH0aSnkp80z6Wj8buUG7Aaj5n6KMnprWRO1hag1KQcIcUekhbvXB395k7onugmQRiG0ww8T5wDcFYbEOn45ldKl7mVSOBCZkmt0w3wsvLQ3JpFBEa4uraiEKy9qBCMyZ9gnxSDabIOPJn1IY1yyIHyOcALFHM2JS1kgDiQZwSdJ2df2shmyRH/x5BLaWIKqIKNbmRGmVA3j0gmwdokbtarZt+nvV11oNkIKYGxCWAk6dK4Ew/JRQ9qV7AbRnU+gDkyAn9sKNMbPdOWXlTnHZDp7NeJ6FQ9ZtN/mhekCGf1eB1gRXpDkOVzyz5e1ME7Pwkmc2DBRzc2SmTLcC0/TqWbLTkVvNeaeWG/0Uji/7UQEio4lSplykm6EDqt85YlBuUkhSyyiKAj411LqLdlmiBM0GP4IQVgB8qQCDiQOujUY80GnHwN0Q==
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

