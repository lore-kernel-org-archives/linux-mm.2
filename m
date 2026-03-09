Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F84AF41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7213C6B0092; Mon,  9 Mar 2026 11:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2636B0093; Mon,  9 Mar 2026 11:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630776B0095; Mon,  9 Mar 2026 11:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56F956B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:19:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 163391C126
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:36 +0000 (UTC)
X-FDA: 84526883952.01.2263D92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B885C0010
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8TGSaQ0;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfcQPKW0OITtqsF6mlfleo6MJjHr9NFl0AaTRWZ2Fvs=;
	b=G0EP8FzW2ciS/tsICVLslIQKbTPnYDqHBVJrj5xKoSF8avoPlMpkfwgWuBYVdorDOKnyv/
	CVSW5Afkz9FFRawpd+aV4jl71WUAnP8TRDkSXUajyqcBF2q1WQoSAqdsbDPTw7kOvDpy2D
	UJ0j8O/H/Qp4bGX6jbn7audU5tGPbro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069574; a=rsa-sha256;
	cv=none;
	b=r3fuIC9wTBenALt+UMd/SYx1aRdx5/9g9u3OgEmcsBBrtVzYiD1mcgJwf0wp3qCQJCO33M
	0ZLv8Tin0t9cy3496vyHJQ5UzkmQvTaS69nQPHgI/+A5WSRTyrnRJXoH1o+c6uLlNIFn1u
	gk7Ni9z4yv+xAw9d2COAbR2NA2/VEzo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U8TGSaQ0;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9191343997;
	Mon,  9 Mar 2026 15:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70011C4CEF7;
	Mon,  9 Mar 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069573;
	bh=1Tpg8dpXogI43ldKvRVlXnwzZdDW6L9YkP34QCbqGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8TGSaQ09iR0FrKwfQh/wBeA8JtXPa5xh1Ijd5GD24HH22yWtc+WRIYBBREe/zHoX
	 mim+0F4xyogg6j27YYr6oJKdiXjqBE929wUafl3JTo8XBlu9GK0F3BawY08nMnNnN5
	 +dZqqJk/DQlH12qhxFlRweFgExjYT5kIvUesROaZ4jsW99zDPzXaNBzmbx0Z9pzSya
	 FVcCIb3miryqet2ggbFgd0dGu1BmqGwHdYr/EJT5KzwbLnzwxP6bklbZHFaXUh5xdO
	 wano4BfHvih62oU0ZcLBupR6QdJQT1Qvl6hD0050OGIcjN1HThoOUCGOUqmWope7ZF
	 BXIeXML+1yMnA==
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
Subject: [PATCH v2 3/4] KVM: remove hugetlb.h inclusion
Date: Mon,  9 Mar 2026 16:19:00 +0100
Message-ID: <20260309151901.123947-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: o1oso7x6axcht1c6dxy6qoqm553cmpyh
X-Rspamd-Queue-Id: 6B885C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773069574-169119
X-HE-Meta: U2FsdGVkX19/NlJWFmYwTQdGJKfBH8qyA9Z9fCH7xEwRJVHvP4awpCUo+mPozJyM+CoLTcySdiK4LpSI81rSUilviy1gj80FUqDOzDZpWLfFvr+a2/ruHn5+xFF5//9MtQR4C/3+n2ofuJq0b6xD0Ei3VfUimjsFQbJ3YMa3d4bXjFEBN44J4LfciO3dBVW5ak9tBi0CyAwZxL36reMyCodWk2EikDu/+iqUgWpwjlixBLTATkImYijltU5lB+emgO57YEg8W2a35Q+qQvycgJH7qirOdqwSW/s+2Dm8KUvmsMUcFEOiqyFllEgSvhZjKIcrmvz4lqEJeFNvmdRBMZW1/0dPrVq29/I9vyW0AlP+KUGK29wkbh11XE5QkfVA4Jz1oJjL5rGt51Z4xG6cjB4fkcjEcBgQGkFXxzDJs1470ajr9cncl1YJILChtJnV6gonIzZdL4Ip6FEKFJZ+YSEjtoGghlE9J87MBhsXnKzvGiO0Xr9BsDreAGWubS7m9HMtccSybiFD3UsOAttcY6o8HnAk2fg1lbZAHZzpTRALoh38jUMuai0fe0Lg/mDGW4e3guZ6i7jLnl1A+egDD+tKYy7uM/rBFuY1+BL7m7aOxDhgVPV9D4aNSSGh3ks42PrXOZcgTmiu7k1syN5nJpnteIN/03ua4GzPjKC/0R3Sn1QgWMLvt6OMMql2jhM4En2FChj7AauFzRfEe5sk88QeZp46kGfd+EI2OjujJ3SiwsL0iYGGpcpHL0o0dRikPS+2X1/CcWZ1QdJhzq3CIDwkwyxu25dHWH/ZhVqSuXKIEpOeYy4Vyf7EeVxewaGv01/yhqUpUBBHDPsS/b5hEHd7iQpWJGNke5pN7JqmXnaBuI4YvWHgsXV7sAIYn9brst+Gbwpp0SsPrWFqBPDDZvM7Y5TK1i+mNBYgqAmVosBekNcVyNw9FmZ8dEFHBo7AYWe+xMaudIYdjEMJTwF
 MdLHP6fB
 7U97cfqsOASOhXB5LrDB82L9t8/XnXTGxNN2GxErDOciDZyXELLUT2okkj/MnkMdFoLfeZD5IVIC6xhI5zI0AQVF10EGIZa5ZTvxx+zd4G8/4PowKeSdbf9P/9EiasAxNB4BJQS5lBW3XuvQ/dl/XJJCqHLhCHeZQJtOG+pN4HZW7HAyBqkQrO2IZC9eKjBUiBKkYilada4IYoNTSnQZ8sEAkvSj3e0K+ueMaCzmUQ5C1mLviMCnIT1170X8/5SqWBDveRHUce8X1UeYzRo7ltcCOJ+NVNYjGNTLJIgxaEZoAKKw=
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
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22f8a672e1fd..58059648b881 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -41,7 +41,6 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
-- 
2.43.0


