Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26084F417F3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B4E6B0093; Mon,  9 Mar 2026 11:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811DD6B0095; Mon,  9 Mar 2026 11:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC4B6B0096; Mon,  9 Mar 2026 11:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E67C6B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:19:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E05D8A53D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:42 +0000 (UTC)
X-FDA: 84526884204.01.E9D4E29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 964BB1C0014
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5ADz3X4;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UE9tiiF179fknKTCh62gfe1AP0ZR587kZVIsQ/0ru2Y=;
	b=w94UMfCGjkPxR3FfCiRDgc9H9JMM9X2ZpPwCsMi8tBf26JBzXDIWAPSIjlnw026j3VO/YR
	XXL2wZu31gGrcvGMMlMAMlcS5FlruFUfSlCVpzWpJ+2UP1uqR0/jFQQ4+7bWhRR8Kl5tZ5
	1bWjMrP2rh0YoQTM9RzmJTByuAItJQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069580; a=rsa-sha256;
	cv=none;
	b=qdfSqJ7+fe4G24zkrVLsUuOPqrvHBrnQWkhgwc7SIg279jOIO0oX/J/+0BsFCPpW25Xqtn
	x9kqRoJJYh4eC3bkhXaBDJKArLHeElkHa1AIcJbig+UYfUlhREwiCa0LsSkidIz5cXFr5Q
	GSwWO79/7eKyHFGI9Tye5RGPNUmQkhc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5ADz3X4;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0488F60122;
	Mon,  9 Mar 2026 15:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68A3C2BC86;
	Mon,  9 Mar 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069579;
	bh=q/OK9MenvejDughLrSZOznakkVUTLmx28+Vi6bUHGJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5ADz3X4fdfGQ+QEhi4NobrQcvdh+sIqHuN1lR9eH1IXLKh4ehimkDrH425UOshs6
	 cvqoazVhrxU+UDeYiyGlmsmBOHdE/Gqhy1joKiUvwHgZOeKu3MIbzsRI3rNSFZ0pOp
	 0X985TzMHB6ViaeHWx2+Stsi4ao7uIV1Fx09Hz3kQCklf53GBAm6F+oQIcmqY05hR6
	 w7rzTfbsry5MDrFfNLgFpeT0QH0ZSWVceRoG9a1pDHeUkO2cUruTyZ7lxIAA3UuZ7U
	 cNb2r8U+cFd3WnW1Tn+i6azBCX+almkPPgh4gl4k0F7UXbmkov6JCACpkkg5tOQtHp
	 v9hC3syVh165g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 4/4] KVM: PPC: remove hugetlb.h inclusion
Date: Mon,  9 Mar 2026 16:19:01 +0100
Message-ID: <20260309151901.123947-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 964BB1C0014
X-Stat-Signature: fceopu5td87spey9ndthbz45gob6zhjk
X-HE-Tag: 1773069580-743977
X-HE-Meta: U2FsdGVkX1/npCVfoy9XmZ8zSV+cms+06GcVlFQEUuPvcvQVwDNUFsO6NlUorDWfJarh9oZKVpB2ii63hsAMNTUBlNd2Sn1wcMW0Ox0kHXi179PGthltDqrIDhaxEpWr+aKg+EQkLL8VE2MBYSMCwDX+3vY/p0Mq/7S5Iy7GHoNe566A0vQdNLTyfr3BII5pR3Xa/NpH3lz/1OqSHK9GsM4UrRT+Ed7GBk6xozdq/xbSsfOYug4WHBwq47UzhQnphK05KG4vC24F9uL7s16cng8lcm6u8+E1kUZc/ItW7u6Lyx0U1rUIeA7mIKcr3YdbE4mnQbuJ1ook8orPgPBZ8KHndSlwuPHbVRV//XyPgI1g+UagoEoJrKd/aEiZML0ohsBrabwQUQp0Cmd0Z9ag3DQ8nyhjXobkTrESVpauxHoNnvzt5LkZXy4NbksBaQtC2pe6Hq1XYK/ahQBwAf81ZaLhNQhVu8iLxGwPpxqDHEpI61j9Y4rX5zr3NV1tUjdGUgl+OY8gGtE6kGxvbiZsSZr+gMeD2hTsd4IFxR+mK4jLxzLz0lkSpMgaXMWpHmtiNFa2dDI7qn6mVLnHVzBwz4z/pGxDqg4mcUlKojdwNoDflqppa8aKlDOCIDvjw01LvpTU0HXDglky+OR+4sVBZwbHWBCdzE3FJ/lPmUykFX+WQaAuxOWqU2tbpXNsuxNUzqRcrfcpbI4W0pjDLxr7BKiR33TXi/4D31cetH/kUr7KxGqMwf3j0zjlmlS2Nr0MxZCo4OwSL06bsJkgJUS8YLTmhIcuAxvepFP5AO4HK1ZBjXZGh/2vIra8oH4KT5yDaqI2QLn2prvVSR0jOl2MDrA14BOm8bg6Ce6CNBD30uMx3CkMDiPW+6p1fjmwi0bSl0Tp4RcXQQv7dB4XL1/9y/0mqTY75insPRCVPOROTNsMGq3o84EjeeSTokpixvNp9TBIrW80CiJCbsAM8eT
 E2yc906a
 i8dYIUb2WYXR2OcAckbpglfn+2/boyeuhPGgqj4ZsqtsCMMrdZ0uA9K9c3Gfvwm8/LzELIIp65GUqIiG10gZhMdKSYfDjsAtcRY0fkhNQU8aBtHk45R9jOThA+WVoCyoFUXnJVhOFB2LcAl6Ta6YK/8bWUHRReGbhGn2g3mmzu9C2jplnxZrt8TRzNytEBt/9KueZcA2FswlGryQ5Gbg9A8lS1GWHpipGdhY2pmCCf/LB02x2cZQ/GM0K2Y8RM2Twtq7YiCPdtwp/e0yYWcfelRiGSxPD7UbzUaQOxp/UBDnpXek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
to mm.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 08e5816fdd61..61dbeea317f3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -36,7 +36,6 @@
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/hugetlb.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/module.h>
-- 
2.43.0


