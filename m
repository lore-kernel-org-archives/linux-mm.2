Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3782ACCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160CE6B012E; Mon, 19 Oct 2026 01:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137446B0130; Mon, 19 Oct 2026 01:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D736B0131; Mon, 19 Oct 2026 01:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55B86B012E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5557DA820F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:34 +0000 (UTC)
X-FDA: 85338286068.25.0FA6D45
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf30.hostedemail.com (Postfix) with ESMTP id 476B880005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HOww4fgF;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388672;
	b=BUdO20YoFgU255X3u9SE1fZ4V4vi5l6AfePOgpS0Lxd9jFVUED6iEQIyoyAiS/NJW7m6Mb
	0tTYqTH1wE7cohdIBWsn24XnsXtsJQgGUDFhRD125KrdHcDtt+ZTnITcqpaz0lkwFVi06s
	BvVhpUFAo4M2R61BzS3ZmrKvHMlbd0c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HOww4fgF;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6ZqACnwDVOYevq4rqpa5/GtWYY8/UtRNGkYuP5pwxA=;
	b=DLnH9m5ibi5hTTX9oZ0bTvMBoRW94XJ0NrosSBPmYaOafDB6J3BUd2Ry1NLfGakV+WIWF4
	tsujG5Tj5E7uLaiWsgsEN5hmbIlWMkTqIZFj6Qccm99poYcUHOfGlomTXg+KcnjAOfCYjP
	RcAU1zmoEGqIX0l3zymWY8hKWTyurDg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NgIDSiBf+W9hFun6Xtj0W0UuOklbtmBkmOYHyjYvVA0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388669; v=1; x=1792993469;
 b=HOww4fgFjV71Hz7vsm2uGaKVLDEyT4i59txhBK7XXLFycSg+wlY58DA94D/PHxKKnnkySoBL
 vwpBIicBxftFZdtzPMBsdQcXx9epQFKEND/TmOlWiuMgxgc3YoYQQrh99e/y6FXkX6BaZJ3ZPC8
 nLtYWKqTbJbLOz5GtkJGTfSg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 30a8a1b7f0517040;
	Mon, 19 Oct 2026 05:44:29 +0000
X-Mizu-Trace-ID: 30a8a1b7f0517040
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] mm/kmsan: undo the shadow mapping when the origin mapping fails
Date: Mon, 19 Oct 2026 13:45:26 +0800
Message-Id: <20261019054531.87652-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019054531.87652-1-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 476B880005
X-Stat-Signature: u9jj5dwgneuj5hkwepifj4s3mkzkf39e
X-Rspam-User: 
X-HE-Tag: 1792388672-253217
X-HE-Meta: U2FsdGVkX1/OGFDbD19pFxXAXkqF27hTLrBIJzpek2tOP29/oMoXvtSrqAHJwADUqaIRiv7o7Zq09VPUEVOoMVFKcU0ie8zV7nPfk3bPdJgrqTxdTDy5A5jMkniVH1/Fa5zuTwFrokRRUAdp1JEldz0YRkDjrju0/+Gv2f6pAre8ZsS5LDV/QqtNUFiR7s3WVjst661WlxxgM9iTdbdXtuL5OKHZMwUqLohafGavuLfkKnUQ58UQ+CQ+0tToBjICuKnO/egYu3SGLS5uwCSwHPeLuLWAsOEtCvUmLg3v8iZnsDQv8CPQaNlHA2lpdYfXXSikS8z1SvIMSIcToWe1qd23eE4lv7e99Xst860y3wc1wLw7YLoZZ6WwRy4lpEqjuB+K120sxqv9ChfG6MhOabjfoaMvV+SSpqxlrtKAeUaqA1sgV172a0P88uUphwoWEtTV/h/j3+drCwjjceqFcAXcif8b5/489wFOAh/T3zhu5+BQgURoh4/3okZDD/Lbv1OwBBpBPzuLbk/jaVUztNbWCUovjQsqlRjuRKB28j49GoZWLG29wi9AEsHTDQDEDHiSGUmIMoSKwGpYSyEXuPuOiSw8ugjAqpvQwTrcBBNes/1rPZM5XMw2cZdRE9V3yV5z3G2Dt2Mpc6cuDPowRSFZvroMKYfMZyDm7N+gzbOdas5qnK9mPuzU6TK1VOWrQpzkJLyrFREkuZevWNOQ27JYtgTF3IGH1i3eaNSxC2+x1rfGY3VDQyp2EqeCdp81emVEofxnT0nJj6fJ59FqfV+k8sLQK+ZqkHBTY4n3hI4c0xyETcYZ/vet5bqDUJBqCsiB9cuzq+/2I2M4eQnr76+HRjfl7Stq3LQtDMGpEJrXlC1msZt2EJ+1Lv4dn/KEIdK/j9yJ2KSZJDn2mlnLjWLrUw0OdsZMALiGsi0L768lY8EJfidosZ7PH43+rRHjU70bbUOk+tK6iWMwAVJ
 /jCNnoap
 sczs0BxxVEJEsszCxKmYtqf0Q5XtXysn/A+oO5HZKRBcxNF6tr9RS+L+PMhMdXPlb+7Ev3shlOZOPnfJKGzJSwucidFQHsdmlahY/jG2VOVUj90fw5Ih15lFK+Z9r2BTgyoydoOg4JfoV4hNoZIkgcYgXGiit0TONaE1UjZacjRWuG/b6VzFKIsyBwl0Ho3f7Bwmit7Z4B6N+VIYDsHInApqrnBX8miQ2FyCYFpmSeRzoFbe0UH2+woMkI1yj5FabUu+aFQGsFoN5HSzvGkXYOYg+nzp5cmbM9GvQ0siyFPU0oCb3i0Ztl08ejNb93S7lsEXLNSA7VxR9yLH5ujjFsp1IRdD3n4sG2b9X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
the origin pages. If the second mapping fails, the first one is left
mapped, and the callers do not roll it back. The next vmap of the
same metadata range hits the stale PTEs again and BUG()s on the huge
mapping path, or gets -EBUSY with a WARN_ON() on the small page one.

Undo the shadow mapping on that error path, the same way
kmsan_ioremap_page_range() cleans up after a partial failure.
__vunmap_range_noflush() only clears the PTEs; nothing has touched
the shadow mapping, so no TLB flush is needed.

Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
Cc: stable@vger.kernel.org
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/shadow.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..2166086d3dc3 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 					    o_pages, page_shift);
 	kmsan_leave_runtime();
 	if (mapped) {
+		/* Undo the shadow mapping set up above. */
+		kmsan_enter_runtime();
+		__vunmap_range_noflush(shadow_start, shadow_end);
+		kmsan_leave_runtime();
 		err = mapped;
 		goto ret;
 	}
-- 
2.25.1


