Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD33606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mjH9b6uf
Received: by kanga.kvack.org (Postfix)
	id 38E8C6B05B3; Thu, 29 Oct 2026 06:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3187F6B05B4; Thu, 29 Oct 2026 06:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFD86B05B5; Thu, 29 Oct 2026 06:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9FCA6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:18:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80108120310
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:48 +0000 (UTC)
X-FDA: 85375265136.22.081FDE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1CA6140008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjH9b6uf;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793269126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBpB5rqMwqaO0EiguVkBI+vJ38Q+R+hHBLQGHSLh6Io=;
	b=6KdCjorC2d39+/ah0pegKdONin1iMCBuW9nXR6G/kGBPoph3N8Q5vqIO5H9+nlvOPo09nf
	FyMdfFcqKB7XR4bfsjqlFbBliQWZnUe9R81/cAYPyvArABpo3rPHghtqMlpvCE/ki9CSot
	OiQlOyy6NwxF4zwPJet024Kt2Wsfzlc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjH9b6uf;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793269126;
	b=CoXuOQmsrg4XyU/+lUGLfcR18e0ZsKQ3U3F0/lQkEbkthqlt7loQQsrK0Fd5H4OvWBUZpn
	4iokgtcWs0kEtPkPU6r0MSFg9ejt2kVeIcj+Qct67aIf63Dzb4CMxPdxvdRLcFHvjBIzos
	xuS39UasGA8pYq1OMhbaNZHwJgfagNQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D3043F8D;
	Thu, 29 Oct 2026 10:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5275C1F01828;
	Thu, 29 Oct 2026 10:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793269126;
	bh=xBpB5rqMwqaO0EiguVkBI+vJ38Q+R+hHBLQGHSLh6Io=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mjH9b6ufQ0uFKdPmq2bt3uv53CEse22aWsgSGvW0075uoTXX8hxJoXpO67N855U9H
	 BBTD4zayPyW0W8Cy+vHaZJgzEz6sLHK9kiuSKnwBTpdr9ONtLXpC9yBHXrbrynDzHW
	 wggNJAF2pDgRD//fEt397LEDRpDQsuhOqUIJJBKGWXiL0khRSoW33GjxELcpHRZ5u8
	 Q7ApB9GtBMe3vFYB2uutEzEWI/aM7RH9lxkCOYuOu3VmQnjqhclH9Gz7ydWwuwpN0t
	 AALQfkdt9earHQHN8sbQrNCvQD42YzZ6qHwhgB4Fw4wOz0b9I38zRPcwuAh1yDpIyk
	 SWDG12pDuFP3w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 29 Oct 2026 12:18:37 +0200
Subject: [PATCH 1/2] mm/cma: accept memory of multi-range CMA areas
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
In-Reply-To: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1CA6140008
X-Stat-Signature: nfb3wsp5qr5e7auz8py3nhrpej4ff4oe
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793269126-195831
X-HE-Meta: U2FsdGVkX188lAEVSQQuZwzmk8Zbr6oEDAZxpOrKBWxWuKwc11qx46xqTDk6/3tCGw1HsgcLhGRcVxpTN786rdDl2yAoz6f4aFHum6tfCvnOnnjqV0lx8jnQqG24IQGuH/LBQWivkeQKCzHlelTFXgaecHusHEwFlk2fCbI0wjgusyDn2ddfaKvsDYIcrCnO3pqcMYDu5RBB2ucLTMDf33V3gjeDvftfeHbKdYxS20OZgscDf2TqX/w+xAkkjpCagcjcXII/FTu1y5b1LAsjUwcUgfUEOBaY86VgWiXrk8vWMQ1odmG2wdqcoJG0Sm79EpA9OSF59R/kE/ashwsls0pJxcME9zfqTe7/B4YpH+dDvrWh44/OIz41QPLugB3kIctn0iTTuL9yGFGGL8U50QpYb8SnbKYH5erX0UjvdpFkMJ1LH+yl4eqFSS3jIpFt51Ys8pixCOUmqD4hlM993xPLAnjZIOh1+mw56KHmODSPkIcZ9JA0i5tLaKk9sDYpAQYoOazYBdKis2D+j4rFvQeY274bL7PbvAiV/Hx418UBRauP4AB3GA8fq5GMaeI0bxCdxY29MhK5QB1fuMODgUawjjdTzV9WS/u6/LpQvMP2tYkYxDbe9DdfF13wUzQkkV44CrwL92YbcVcfKYYRdWBk+gwszWvLNPmPl7e/KgsNBdTpuXETKEc6Eq+RkP2IMkFlqCj2NoAEQ/iRaAo/GSD+YBZCBwfBNVQqcnhBlFcfI9CCgvKxpSAoe0Tz2FIspTiYORretb3XYetZKy6TIfjQUtOLKP7e2uYfn5ELXJV6eeKpUDDGPvlFHi0ohVQp3BLiQd61TyJ6e/f0MNfhG/UuFYu5bERdBG3swpECC6MAz5olQa8Da6wJDa6lFJ+zHXSvtXjJgNsXEMFcSDa5hFPOw6FOs7AjkB8En0o22gy4ATYb6qG42CEihUTWh+4zxUeqIhFdM6XdNSnjyKc
 Hd3ihAkR
 FYt5RhQ9Oxkg+18nvTYiIVBN9zudZHxY/RS0dbLUnbLwRX4Pydqhi0SOhD17bBmmNlcNzwaTHZ9+ojer1jVZeCqk0cs2M0nL8mdAqv0Vfy7iTHpv8NTnOQi2+CeYpkiKu09LkL4lsSltceSMbBPZJe7g0YOix2njO29EVcBWFeDxjxHu/G6NxyNnGsmacfFwDwdGucJ6oc/VqiSI4iX/A/ZmxUMgnbfnxp1t0Ml4oJ8FVsJYip8BenE3Odg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On systems with unaccepted memory, memblock allocations accept the
allocated range, but when cma_declare_contiguous_multi() uses open coded
allocation of multiple ranges, it reserves them with memblock_reserve()
and they are never accepted.

These pages are released to the buddy allocator by cma_activate_area()
with __free_pages() that does not check for unaccepted memory, so the
first access to such a page in a TDX or SEV-SNP guest is fatal.

Accept the memory of each range when it is reserved.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261da..0035efb1130a5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 			break;
 		}
 
+		accept_memory(mlp->base, size);
+
 		pr_debug("created region %d: %016llx - %016llx\n",
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];

-- 
2.53.0


