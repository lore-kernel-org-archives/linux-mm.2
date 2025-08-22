Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B18BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9448E007F; Fri, 22 Aug 2025 04:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799218E0056; Fri, 22 Aug 2025 04:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6619E8E007F; Fri, 22 Aug 2025 04:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5AB8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0CEABABB1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:45 +0000 (UTC)
X-FDA: 83803704810.20.C77770B
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EC8AA0008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=GVWIKBh9;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smE/l1GS13xRmLWEHir/MzMKvQbH8PWMTIKdWA6AVTQ=;
	b=rp07SnhFFXIM9GhZt4dV1uVsYoTNUl9pjHutCRLvMGx1CnGyp9LBl7CtOxsph/8agY5gNN
	CPQEV4fbQDSCYwAFTLWA01dlIrI8rcLylpTpe3XFyBAwOcDkx8K3DEOTSIPXDEiak/QJVu
	Act8UhYKdb2JibwFFADZv2slMxGQ1MM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=GVWIKBh9;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851024; a=rsa-sha256;
	cv=none;
	b=ivp/LvKs4FMYwV4mfTz3M+8efCC9OvCaJJDmWpHRmhPwZ8hYrFOdNKVrTcKaJcmyHVN0QZ
	VC88ZYboE7Hvt3Q+Nq5U4EOyg3WByvvjD6VaG1OE4u9878973PO82DyKaKP4usFoMZFKTr
	7h1WNrQ7bCAILEtCftkl5XtCIz7hAtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755851022;
	bh=W0DS7D8x6Zf79SrfKNqQDnRrrEJR/lLnafAee6VW+oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVWIKBh9ihlMBX5Fn+YlBNuJbGSi8GqX9eRPFApnpkkwsiIvyQRMnZLuT10QU66yX
	 vqg7B2BgPm+cyE4eXy1PKKXWGyxmwD1Jg2uT6JiVg4cvkb3AvnDH+90yOJf+TQfMpX
	 pnc8q5YXa89TwcxOk+JqIcVrRDTAdwT3giy+dCsRslgj5wpEDWrWQ1RZvYzhwYLqV5
	 DV8SWsbzu23eM+BaEzNIYOqkmLiX906nxOwrqtiyEhb75zu26rOrHhtnQkBkgCpGMG
	 0rsvyJHdo7r/+c/tl6aglEfkOKWJaD9KHd8XWbVZNuMYxuScnQrJc8al21Ed3IY3II
	 QNf+g+gTUTYsg==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2AA9717E05F0;
	Fri, 22 Aug 2025 10:23:38 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 8/8] selftests/mm: pkey-helpers: Remove duplicate __maybe_unused
Date: Fri, 22 Aug 2025 13:21:05 +0500
Message-ID: <20250822082145.4145617-9-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EC8AA0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eujzjqekdjuqnty1jqp31bpt7h73qgmd
X-HE-Tag: 1755851024-948092
X-HE-Meta: U2FsdGVkX1+AUSWzvHnvp9gkugcJq83aDB/gjIRSuE5GbbBtK5G5kt7Lg0RJqlcaZoRlCEdmhVpJHPxdjGFwRSm786n56zvsKNX2lUcghugLC2QfDYJigeYVlOQfbyzy85dPueEh30LQEYMrKxOTzzw16kBaUTBe1hcNALA3PfbTQMZyxrRFRGk7y3+zHiLeKUchQFhUI0/V+JlrOh/j4ffUVEHp3nDkTOyzko+QyUpG2sXv4LjICusMcwNqf7Gd64DQYFfGFNTs6iYCSG3bFDYYc10vNbJcm3647It0cfMlhArAqbFXIep474wSpcEaHSEgWjLs5DCz8B90hwODl4io4AMZIqmceC06b5CsN1no9jl7y0RCqbUIHfeMh7gliD98UejlWLUBpM01UCYNU5PIAiAQ/Cfgg9M58shABlcI8PqOJ2Pcu5BhxfiVbXA9FgpeSMubFPJN8Lviri6OB+kTX6r7GEUdxR2zXeAFoJ03thuyc2QQdtcCqmVs7Q8JuS96MJl0Vpd9mjIWQL+nZHFGDjt/nV19dk09tcD6AzNoLKkbqhOoPrp56itOEWIn0kyuNg0FJSYizYHS3kAul4AK3cMDmoTrQBrt+hb8ohWyEJw3ClcNZkC6yj892lOmFT0YFcPGeiG8B3YeNgzN0ZYhxEr750uFq/+p23utdfAPMvC+EhukIhuUCDaDVS4atH6gtdDF1EviOHnf0JZso1D0C0RFBobJkCFbblAg2UVKAU42x6d63qbCa/p/FSkHiQxe6rohqh9AV+M4QiWSV/zuwKX0lqb+6HJXqnaB28Z3LEEaUAtKTLoRivdhAfeqa+kqtgYCvTeA5s+J6zpW2nSuUM3DA4ozmMZ9efOgMUez4n07TpapNkY3ivrJQRHnyCkrZq7Nt01KvDgQKd2nPpWWr4Jzl4p7DqPo3oQbDp092Oe7GouwA9oO/R4mf8W7D+H2h8AwAYRiqY7d5XY
 c7S72FBW
 Gqz5/Lj96NpcKhCPFmb6QqUif9GgSQuii6cD830pmNwg1kts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__maybe_unused is now defined in the kselftest.h. Remove from this file
as its not required.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v2:
- Introduced in v2
---
 tools/testing/selftests/mm/pkey-helpers.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index ea404f80e6cb9..fa15f006fa68c 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,9 +84,6 @@ extern void abort_hooks(void);
 #ifndef noinline
 # define noinline __attribute__((noinline))
 #endif
-#ifndef __maybe_unused
-# define __maybe_unused __attribute__((__unused__))
-#endif
 
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
-- 
2.47.2


