Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCFDD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE246B0306; Mon, 19 Jan 2026 18:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DAF6B032B; Mon, 19 Jan 2026 18:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AC76B032D; Mon, 19 Jan 2026 18:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9FDD6B0306
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABD7F1AEBA0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:56 +0000 (UTC)
X-FDA: 84350242872.28.48BD773
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1965C180005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIW4fuGu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863835; a=rsa-sha256;
	cv=none;
	b=xuEZy5/gO0pZ4yrCf1ywkDhy/+m6HTL3zMo5tOdQN6Lubxl7yY5WKei0fHsaVd93Z/PGDo
	BXXjpgjODJJrAuemp47BcUy6h3FnWL/fpxgjpGUt+jdS7/wctzh8InI1ZkycEaUJfuJu0x
	Z4vPteVt+IprqqjJLOSH2xWXDhvD790=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIW4fuGu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0PZsdKyWYnYNA53sTkL74r4LhKT8UMg6WKjB0J3+cU=;
	b=HcxEUH7z0ANlqobsmYw/Tps0Z8+T0vD8/CU69rdptEHX2+RZR+L0OCyai/ystbzP+G0XVm
	1kLMo1oRCH+ajMFLmcEXYNuhhfYrb+7e7shwUCLWO5fgMbv3fUCQmXuu8RzRbF0sq0VXPu
	PNcDukYiLcyhWb6AIsxuA0dEnNeVl9Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A38F460155;
	Mon, 19 Jan 2026 23:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09B1C19423;
	Mon, 19 Jan 2026 23:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863834;
	bh=kH1VyttzME5xFeeFdR/qAHeXrLO5pFzDG/LyJb7V0HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIW4fuGu6Fvm5fTOSiPeFfrt4FFXeyafRlE/6kmfcrtG7aEdsGaWbIX8IeNn0sRPI
	 D1gHKWfPif0n1VW7nAJDk74228u1Cqx673N4Z9fsSSg05aYrMD2ZIUbz9hY/4oO7bM
	 VL4FmwdTOM8cvcKd/7ean9yDQe6QSyh5qIrWAMD4tSL/fBAfsAXe2BxwiO8AyPSWlw
	 Sd014FoSAVVq/hPIOFEXgyp+hyyWVjl/iMDU9M1xyvBBnP83HdnmLnVyHuaoHkldUy
	 jj+CCjjMAKeHDv2/xjWGDVT/h7E+d6KiWNokqEor3Ae83lM+IA1yIRczDY3yZDzAwQ
	 eP3Gi+2s8wxjg==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 19/24] mm/vmscan: drop inclusion of balloon_compaction.h
Date: Tue, 20 Jan 2026 00:01:27 +0100
Message-ID: <20260119230133.3551867-20-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1965C180005
X-Stat-Signature: oe1dkcgbrwb56a3bzokdypd4tzbsbyxh
X-Rspam-User: 
X-HE-Tag: 1768863834-126050
X-HE-Meta: U2FsdGVkX1/0IB2AhpEFt7zPVniv1wEboRZ3YjGt9gUVo8s7G4pXW+Zk/GdqMKc8zIMHvzz9EWGSYi2n4ZXltuAWz8qjRcLGq9dua8TzFeAuPLovBeyTB9Lzp/npOawDp1i6OpN1CzORdDA/yUIzXSV7eukd7130NJ5B766wfRthRcYc2wLLPB74llRWcoXoL43twQ5u6L5YECBZmYyeKY+cyY+75UnPc2l41olQE75SdfQV45AZEynlgJ2NG7EFufX1+rqFDipS/oGNboSb1Ny5xZEM0aF+duRGg0yvmtKAiMrF5M7BbmzU92L30Mug8RCTByCUbx4CHnZZeKTSlxKejOhe26KSUNiGgcMHjEuuvwlocBulQtdX/lbtgEVPHEsMNxWbX9uiHK46nFOXTFi6X+IeAXrZ9NKRRUC0Hunh7mcZ9MvtHaaRs6M0A3NQNj6IQX5dN97h2c254py6ZIAoJePVdCB8EyaiSTfG430n6mvgq1c8Y5fRFVm609iKZ3+qH0ZTdo98qoSTtkOMwFJVeByMpB7DwgmnD444ACEX3mWGYtcj+fdUhe5j8GSXff/VwwRksm49f4bssNZuu7snf2RDviWPR2kCJRKdMVeQDnOh/re+UJzPe5MhTl4m4wI+EnI4hMDaQX+tzH5eaC8i0WdstZwmPTVCk4LgvOYHboellOhzS+ucdhC6H9yqRXgzAqeCOvWnXP/cEPMMvVONmdIiZasd8nnWNQqad1HAPAe2hWt2XzkoF8BjwU71G1ZyNG3RXNkiFMATWUNNkmhMMbK8I+ujxp1ZGHFyG/5E+8BSfwesndhKC027xsbHYg/DoijRXbmVyZqOvsLth3PHTPH143fbYv8wmPPVocb7YVKiaMZILAt4NMBR6CSvQSXRoNnIG9vBUkt3fSiZu9aeD0Qc0hM1WGyR97jAJIuKFS4bfktRr86YsdvVLxKRRurD9KIYwhKvkp0f8wb
 qftarnnT
 YrPCXxGK0uIqe0H+HSY1PrwsEh4/VYlilOrRpnpNzxuGZ1fruoBORV24ghIrrWoiJTnqo7oHQ7cm3KJkapO+u+U3ppLG7yn4WC05pGltyDqfvc6imGRuIrlU1j582H0RZc1njEfYhYy9RjhioxnqCEjAQGDvs+z6YcYhDf7qmva0LGNzhgJRVfj/VtHlnmQWs7XmaUDkylnJz7mbWye35STJpFjct4aTt1QcJnQMybhKtETrW+YbspCR7yDGLWBApmJAldjynlCPgB0dAp83/lrL/d3cyV6gWvJPN1Gn2GvmHfNm9Hth2iWGB5nF3TaIK4ZYwXbP29iireMq2O0/hMWLr09VHugJlItGmRfiF+5GPnsA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
feature"), the include was required because of isolated_balloon_page().

It's no longer required, so let's remove it.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/vmscan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a0e3f51de749e..cd9f9a779e89b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -63,7 +63,6 @@
 #include <asm/div64.h>
 
 #include <linux/swapops.h>
-#include <linux/balloon_compaction.h>
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
-- 
2.52.0


