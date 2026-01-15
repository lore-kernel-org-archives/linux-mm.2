Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD94D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4A06B00B3; Thu, 15 Jan 2026 04:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8FE6B00B5; Thu, 15 Jan 2026 04:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF636B00B6; Thu, 15 Jan 2026 04:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF3056B00B3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8787E8AB0E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:30 +0000 (UTC)
X-FDA: 84333657660.24.C970B8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E8D7380004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYTnHiFW;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDArjlos7kWXyg0CRwz2zGueO6kO8dJSOVHUuCYOmOk=;
	b=VtB8GaxBGzdNtOSgj+suGtL+qrE724pmVuXda6p5wn4RytJtf54B2T1xHDsdMnflvVze6w
	61HubU1V1DdOKb+vtmA+unTsUalRIDTofsoUcpWwYwgzTb022gv+18+0ZenOR8XYy4sr5e
	l4RELVSTfpSqOs+tQw9b0eVuXtDPwLg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYTnHiFW;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468949; a=rsa-sha256;
	cv=none;
	b=I8Oh/RZt9ytelKS5bLyIGFxOht9Cbd0boF3/tJZL+pfxr2BRlZqzKx4c1CENRRKUotT6Vm
	9FpVAmhpqkgndV1hm4zKLf+dxtTK2m1wy28g+3aKUQkJKMGbG9EEc6Eh7Vs9SGYScFAQfT
	fncNn9xMYc3blpb1/eRDv55KNmqzsMo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A812601B8;
	Thu, 15 Jan 2026 09:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FE0C19421;
	Thu, 15 Jan 2026 09:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468948;
	bh=xIjT/yGPbzWdy9CPPKodSOcwDaIkDPisOU81OKu1Nkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYTnHiFW7YPOe2J6Fze71iGPPpPxEwmxWfzUTk14RKrKFn43bosoW++6osAwhU5wA
	 q1rDiNffO1rJz6FGY3F2Ky5wp0qW7xYClI601zpW0HycKpBc/SJkGGvDucxJk25GoG
	 wMpJF3z8qZQC1e6zOMpasbtacWBOTpKXfutSC2ewiyGEUStYFrt1GnXGT8w57OD0K1
	 wmPV95kTvJ3GGM4fs7FU7MYFZ5+73R5SCqaFY8Mkp6QpcLMpKFy2KrC5v3U4UJ8L8B
	 ScLVUp/VAdCHnagkQF7bLWsOzfl8QWFhD94a+zVmyPP33NRDslhtn6lO/g0hK+i2Up
	 VO8uFwXwKrqgA==
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
Subject: [PATCH v2 18/23] mm/vmscan: drop inclusion of balloon_compaction.h
Date: Thu, 15 Jan 2026 10:20:08 +0100
Message-ID: <20260115092015.3928975-19-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q8syjbsm4g15wi6t1qqp9ypxndw6n84e
X-Rspamd-Queue-Id: E8D7380004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768468948-328992
X-HE-Meta: U2FsdGVkX1/WDq6VZ3yAdHD2jpEuMnUns+PMg+6bnWgzAvsGrNuZs5p96Gz3rj5XOtBZP37ZL/+ubjtEtWrtTWDv4nm1ojBbnBfliKzsIK2XUbDxDJB0wTfSHTWUV9O6CrMTFGWwgQbaGYLJlK9nS1uyBg9LCSFdn1A6AYJky70aabsXU2ePMjvXrhFAmkoniawIrww+5oetvWhWSgUSv0hkWymp675mYSqyo77d1+8dxA/aE8s5Mv/Ugfjb3glXyUxE3rfHjKQsDvq45d6e79wzVKcTWwxQz/kfOmaDHvR04inawNGhm621THEb/qfJ1lwvq1Txk3GSo64k7Olzf/VkhXpvF5yx4W8dVN8CiOjnshqCZzoNTf0a55onbS/QGKsjBrjlD+sdpo+KkWVLEIc0S4ZM0dFYQ5dNVyZa+JdLqoIW7wG97dgq3saMh5b2ySfxMQ+eyUMG2l732u/1wbUwWqoD+kuoSrZ4fJKNFM66sqdoeBkiuZIlkKHqP4SSAmvNHI1Pqlf1geXf3r7iMUuZZuaNdcD91+mK7adqB+gwdxUUK7v21vxTbXyw+KYxGiV1/csjAimvSC1dA4ryzR1uednTNXoT5dJ3QvoZ9dbCZULVBC9/nEyVEJJpha4KbJwAapnucHFYxYlDhh1fdDMEe01MBTP1xuBM7jQfUdPfHZs/Bkj6ppAebWxX7wwD/vN/hDTn8lD7q1Jl/9jnxJqXpQWkYdQ8dfZ4FM83bdNX8u9Mmo/NZml5uYY5KJMuilp3KZAw97NvM/o7+zPbfhl9z2k/vype3IJtiyMGVznT4/cCTQuhIR4CHBT9Ga2DJ8qbdKSiaTd0OHO/k0C24NVjIMd8WLGEhrXQDM3oSMtddSJhKJZgyG4atXXGSKCBKkzFQ7uS+vg6aMXGGV5CsM3CPy6wz68KSrSaL6o0JQO0skN8hZoD1VNJWkCirjJaNHRN0qXyUqU863lJU6F
 /DCxsm3H
 8xoq8hPXz5Fgb27eZOghNif9Jt6iybG4svisfZZYNntSPvrbDP/EGh1XXHQW8cW5zg/s0dkzX64NljxngYd0CeGzkNJ9qdf6VQ3zNPFjhIaLP+BhSvVwONnsTok3FmP85eL+N6vG4oi+iRHdLANpQfAR7VsNw/q4jgvn63z4uvuP6y4O9PZku5a/UL5QnFuj8DbFBD4+0Agf0dmiqC/Ghsk3nNPqcFJGZU75aavLRhefRxjmSMdk40LsoZ34xNOrj+/KrArdiNPSIo5e0ZAttBJNlDvSvVtzvNohQFYjlmImN0j4RqS+anLRGzkuKdjuABRmFBCQM7SQ97nbo+bEOIXENykVWu19qSiUi
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


