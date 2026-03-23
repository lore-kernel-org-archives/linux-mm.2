Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D230EC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F105A6B0005; Mon, 23 Mar 2026 05:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1A06B0088; Mon, 23 Mar 2026 05:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB02B6B0089; Mon, 23 Mar 2026 05:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA3576B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:34:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84C8E13BF1D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:34:25 +0000 (UTC)
X-FDA: 84576817290.15.BE4D90F
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id BBC7F12000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:34:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r32RT0px;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774258463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xrbBa9k+6NQgbzxqVXDiC8SMy7s/AaHJ4RIJGGI5is=;
	b=F94Dph+Fx3oseALmXLXR3Rx5k8XT+i3XNgA32M/1lwWSVX0spj75AiFR3rzsyeH495DmEk
	uKgMBEIPOCDsZHfOCMqxcGV9g3q+K30t56eGD/E6gQ2gvQrFyB7mQI+WG1Fzwkf2a4g8cm
	gxedXF5k8JEjaaDfZZ9AE9o2dDMOW0I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r32RT0px;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774258463; a=rsa-sha256;
	cv=none;
	b=cLcOr6mSRmXXcwmi2FcfZcsjteARE8n9z5M5WS3sn44I1tpi5Yozdm+SbPIHXly0x8ITaw
	g+59sHOTkkzTrgXl3i7Yh/n+gp5lHqO9U9Ljpk43LIztJI+eKHTnMll1nYfOdLiL1rSqe2
	x6qWgl7Ix9tXqL7kuHx96QWzd1rZH+Q=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79a60975dc5so38459737b3.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774258463; x=1774863263; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0xrbBa9k+6NQgbzxqVXDiC8SMy7s/AaHJ4RIJGGI5is=;
        b=r32RT0pxCvcgzgrNq3XDCzgmWDd1ZXWBQyJOClbm7ksKnf00Z6EeLQe8OIT+nC2STA
         mQyEopl82qmJu0rkhOIwnKysBKBBptcwbcVr2pYi4auQ+suOSAyb1txTvTEjnzS+sWos
         0A1SyLC5xe18W3/CO+tojJwqKWQAEkc/Utlvbotlai12Dtgz//C1F+fmMKh6m7vdT5rw
         Yge4MgNc2X4sIzVUxXHfKaMuKHn391jI6y8Wf4J3wqbyXMRHM1VTonEPqxsEdLl8Zy8p
         +o1ZnOBINQqISnK46E64uAp6GRXVcbXNByvTE3ONyJ5fYVfZFa8CDvCdhg2xZ/pPL3gh
         vqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774258463; x=1774863263;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0xrbBa9k+6NQgbzxqVXDiC8SMy7s/AaHJ4RIJGGI5is=;
        b=VRYWiLkDeGc4EzglylOvoDr3bVx3PT7le5O+WSjivWyRxdwiihTg4QmCrSmF4zgyID
         fbbQgFEIXD4bGtGTAgVLQhu6QrVYLERqUUyStML4dPMqzeR2itEl4qUNVa4ZeaaxA9RT
         mUBMuFd00Vovgx6enOAMAPCaYLsWQlWl2ZzV5sulr8tNMTT3aYDfWfztaKrfb0jl6ek9
         b1epHeyVeQeW2S9jy+akhgt1QPMHhHKzV9Kguo54ryqyQ4AipCNW3yG+QuaE0rs47vl3
         iVky1+yYchP6gy4L/qgtzLCC/oaPlUWcb90YjCJvgMQMuVcXJLsa1NRBZwPWr45q03ze
         By6w==
X-Forwarded-Encrypted: i=1; AJvYcCWKeY1kzpQf/iZObSV1XNGKmW4PY93W5tQj+8nVb7Gw8jsgI6Qq0FVXs2wsdL3t9N4/sLZ3u14Wtg==@kvack.org
X-Gm-Message-State: AOJu0YzwBDMkL83twy53Endimtu5amNONGdflOXRR6FwDn7Ge4ca3t6J
	zwnNAIQFKMXTD50x4jMyblSRNdRzWEXWWVNMBvCjWPFyTiXidjcA8y+xrgBMTxqjBA==
X-Gm-Gg: ATEYQzwctSfjSvZGkeR++7NrY9kn+P2v0Ucw3PbXE4mxDSTc+BzaQjnUQ6qxOQA5/F1
	+UIAsyvQNSk1YTzz6Z5+Zu5BUB5hVi0nJmFy2/66gxu/gGZfwLJO5JLcj50ejys8CsrnKWwYZ2T
	j2VT+yHbJUkhHxl8U4y2T3xvxEqpNqWVZxPAsML9Gw4XJjzEZNJNMz3TKcIBZqE/i+uri39K7gx
	NUCoGgnZKCYpLLNWJZ8ahYN1/GOYeEu0MLmx2tLnnyJAL/A8EWJ0QWU+CugWN5HB+qi9L6w7yQH
	h4NjKt/ac0B7/BAXhtyVB7y3yLjVnde4Um9EkDTCJGKV664l2LJAaZz+GAm071EdRL6utXS+VrP
	fksfs+1pd6BM7rRyvcnCQgR0e2ftjw6pbGHwo/qxn6qrUPVeRf0vO9jkDPYDPjLvB6wl5Ljsokn
	y5YFwjHLUw4+QpvuEWUe2BPdO7YRXWs88Z3bgNv0sKnro0vLeFkZI1zZbUrJj6urAGktNIDxDX8
	rVjYJVXggs=
X-Received: by 2002:a05:690c:1e:b0:79a:b5fd:793f with SMTP id 00721157ae682-79ab5fd9654mr27807827b3.3.1774258462367;
        Mon, 23 Mar 2026 02:34:22 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a903e0b8csm54549467b3.12.2026.03.23.02.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:34:21 -0700 (PDT)
Date: Mon, 23 Mar 2026 02:34:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
    Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
    Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
    Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 6.12.y 1/4] mm: shmem: fix potential data corruption during
 shmem swapin
In-Reply-To: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
Message-ID: <0e918493-29b1-de47-9fca-b1fa93156d63@google.com>
References: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 86embfj8ia4j7ec9z8geb8hynye3wfmx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BBC7F12000F
X-HE-Tag: 1774258463-344681
X-HE-Meta: U2FsdGVkX19gzsqaTZ9GOW795LywiIHseA5xqroUHwIN9LUd/NoBgro9JVYY53PLZn1CRX7lAHSH4uEiG9tgUvXrDUtAzGRc+bgrn2Uk2ehvPlJVdXLzG/5cvweSg/lxm9wHyL2Y0oJNqndqlGeN9qZmsZZHtD+08U0Q2JWY1dJpk1andWOoZ2pMj7/pt4d+9wzl3qFV9b0EMtPNXkmk0Wr90TLY5hxi4kPX4HpFQYKDPG5Xn+VcJLZZjfEcgw5XMb4l297SMaih0/KmLMIbbIWFxbV7vOOMSuQ1GsB1kt5qZR++ofCY8w988u3d0EZk4I8yB2cIrEwUPnq4sfO/37Dbv83+Dz1ICWuX9V81zhrVRbSXBrwe6tP/vcvpULoSW6m72l0v2DEXQh74qLVrIrHmG3/efdztFZDqz3TelRQyG9UqdWFPspoKN4TVfvUcbKF9XMXUtg8ldR2lDPscX1G19Bou+iHimb4jzpwR9DAjk6jO+AkYQDji7OwU4BvqXmxe/HpToZzjU1CnVPyJ+H9Ajpsos17ZoRxAdFxEkAm5+thCcb9OskhFnK0G+1gDDEvwLODFix3z2Md0gsNqeZg6XIybGJZ7O5B1hooizDNznKsLAEvfdHDocCyqCPi6Hin+6ZmfHcX7aVD8/kOtcilqY4sdMGnKlpJ/w2/kGxb2QWRYsOiZlZ2QXYUkogHO2f/qhEkTLZyNhWbdrGuni+JS72kRmtLOvlNr8JIpqjTzRsvMVEMx4VJNLqCie3uZJR+ZIhb+Ja6jYYgDbWzBTYfhIhUzNYOpNn37rtFAUr1SDvqmL7VRMmX/iANhHN8ZkuadaCW6FL9w0hNe3+FE/NyTEU2ke3rWKtO8YbSNmAoL2KNsaCYwMsIerplJCXclii5SeJlqbAc0WkAfNjMaQfRrXoSvjBlxRYjfGGS1/dr3gs/CbANONDYx2Hq2D1E3eiG7wtPfN6UMYb+ER9o
 DDhVX0Bm
 Oooej07OfG2Fp5W3L1qoE7DyKuh82Nrj1K8lI1/9Y+OLKqj5wWCEk47K3Sg5JK1SpqeEg6of8/qR7QesC2ZvXPBJN9cBObTIs87gs/o0o4sYsMb/ykRGu1S6SXLAlxw/P8mFXKI5hpBKXPm5RaJlFdaYJnYu08t0Y0nYGUMjGBDnPbkAPX6Bj/7V8BsU6HEshiWPsHAu5KE6AW2/786J8sXMrxUEiASaK/g2Pr8/i0/hsdo/CloD62R+z+QMI1a9XINIhpodCYEsZhReQgk9E/MQRe8CyFGk+9IagN9p1BD3uxU4aCmktr8JqAbSb51wMBC62g7lALspr4fRWkL1U1EeYtmhQJ6FVPTD3Ke4liD9C99JyqEilBD4yOMrK9Psr7hfp/WbEjS/zY4pv8E0kAY3vya+xfFCyo8e5JVOmYvnpK2dEgP4iVCcbrkNvfmeUh866wpyCzGNmKnAcRZMvIG/6ga8qY/fhxhBIaWh1coA/hMhj2HPNNQZKmi/EccAFCTEvd0r35c/sFytVyfn3C8R+8BeVZk5zkHdVg5vqz8vJ5K+UETNpmz+qgL39P5P7xcNnIKfTASOAY6bD2G41V/lrnOpL6D5jWfxyvQN3U2k8lz6C2WywFaSajfkQ5ZSEvSdVpQstWKE1wH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 058313515d5aab10d0a01dd634f92ed4a4e71d4c upstream.

Alex and Kairui reported some issues (system hang or data corruption) when
swapping out or swapping in large shmem folios.  This is especially easy
to reproduce when the tmpfs is mount with the 'huge=within_size'
parameter.  Thanks to Kairui's reproducer, the issue can be easily
replicated.

The root cause of the problem is that swap readahead may asynchronously
swap in order 0 folios into the swap cache, while the shmem mapping can
still store large swap entries.  Then an order 0 folio is inserted into
the shmem mapping without splitting the large swap entry, which overwrites
the original large swap entry, leading to data corruption.

When getting a folio from the swap cache, we should split the large swap
entry stored in the shmem mapping if the orders do not match, to fix this
issue.

Link: https://lkml.kernel.org/r/2fe47c557e74e9df5fe2437ccdc6c9115fa1bf70.1740476943.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Reported-by: Kairui Song <ryncsn@gmail.com>
Closes: https://lore.kernel.org/all/1738717785.im3r5g2vxc.none@localhost/
Tested-by: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5e8184821fac..9105c732f341 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2132,7 +2132,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
-	int error, nr_pages;
+	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2151,8 +2151,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
+	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
-		int split_order;
 
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
@@ -2189,13 +2189,37 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			error = -ENOMEM;
 			goto failed;
 		}
+	} else if (order != folio_order(folio)) {
+		/*
+		 * Swap readahead may swap in order 0 folios into swapcache
+		 * asynchronously, while the shmem mapping can still stores
+		 * large swap entries. In such cases, we should split the
+		 * large swap entry to prevent possible data corruption.
+		 */
+		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		if (split_order < 0) {
+			error = split_order;
+			goto failed;
+		}
+
+		/*
+		 * If the large swap entry has already been split, it is
+		 * necessary to recalculate the new swap entry based on
+		 * the old order alignment.
+		 */
+		if (split_order > 0) {
+			pgoff_t offset = index - round_down(index, 1 << split_order);
+
+			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+		}
 	}
 
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
 	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap)) {
+	    !shmem_confirm_swap(mapping, index, swap) ||
+	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
 		error = -EEXIST;
 		goto unlock;
 	}

