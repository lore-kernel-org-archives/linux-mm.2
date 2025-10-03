Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B629CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900248E000D; Fri,  3 Oct 2025 16:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7B18E000A; Fri,  3 Oct 2025 16:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751A28E000D; Fri,  3 Oct 2025 16:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6175C8E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:39:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E6BE1DFE00
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:39:01 +0000 (UTC)
X-FDA: 83957967282.06.E3196E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79321180006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M4+iEoqp;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759523939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGTQvNtlIndbmepXlW7iLqaMMeuN2TLp2FDhPJruxAE=;
	b=5vRiWyETmaDcDfkT76xQ8nL3HAsTQZg9Mgg7D046+x+ZsdK/KPoV5+UVf9krjlmXp4iuyT
	VJbVhUm2YiRVF2cjwo5Bfo2zch7SI3guMhgtAjWtL2GZ7fQ9gMZzIOgpaUEXJfn5JTaiPT
	mu5EfbsKPwE2fqUt2S2WmwPDhZ79zbQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M4+iEoqp;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759523939; a=rsa-sha256;
	cv=none;
	b=P9Qyn/4gAQeJ3VvqvxfUqloevFv5OuFmmmG4x2n4CC8jN556A94AQds4Gl+rO3is2btgGg
	ROza3I59ykVEjNbVOrdVx72r8WZVGkYpabfwNusK5N5DGMgLOJgQhQLvlJ2GtDyvCh8Us/
	WKbVRgm+q705hPZC/pDDimNGITIrErw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F5604912A;
	Fri,  3 Oct 2025 20:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4037FC4CEF5;
	Fri,  3 Oct 2025 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523938;
	bh=ZzB74e8fLVOerMDvAZBDXxkrkPTdnq0MummdffmxbJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4+iEoqpATZKahzganyMTsVKl1kJ/wiQ8Px8RLzYdqh37tRpnjf8uOl3qaMEL7pXh
	 x6Omcw0vWP61pTvKgdbVG4UQgRqnNy63jcSGLu95EnAnANKV/y3oezHWVN0XVtlnDn
	 vsni74areUTyOWzbC4zHIDP0PSdxtqmpx45wohX2Hq3tW5fknR4t0/snPQ1jgktqKs
	 kFbhSneQRpzrwMXrOqys6faN4d65Ai/1HsxjyGMC7Qjc30QeOzNT2U/IxEK7PYpRK1
	 hWiAPQk+/4yVV/43rRDfVYP5fmu9cbh5rI8HJSeyg0i48Z+MVm/jABJDTBkU9IMMKx
	 5OPN0qtXCQ7ZA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
Date: Fri,  3 Oct 2025 13:38:51 -0700
Message-Id: <20251003203851.43128-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003203851.43128-1-sj@kernel.org>
References: <20251003203851.43128-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79321180006
X-Stat-Signature: wkxyb3heni9f1gqoi1o1ethw48rphy88
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759523939-324158
X-HE-Meta: U2FsdGVkX19iMfPaigZDF7ZHHsA7mUk/wvQw0zaj+O37L90575JNn5lMQS2geLiLZtPY+tkuaSBOVimENyUMihAy8+tStOBy2ixAOvWWjkCgQ8swevR0tpqn2k1SXdP+0qJspw8v9qD2FE5sgjcpn2azUS/5Em5r+wAPnzM+poo8yQIvjhWM8JxgBW1sA/gmS6xThwIWGaaYtSKcoJDRgxGudELBiwjZSTGZdx0eZUq4oSiQW/a6dLy4qiO9WUWliPwreEBzxl03tO63GFtFP/MrQQ69NwDkl//PIeKJaYNQHtfXGtO16hseG3ltFc6HFwG6EpVPF4Wi+QVikkyFw8SdEeoh/7I+ObKOtuY5oy++t+o9yXV7Yly/NtzJI7k1394NqV3zdNuIaA7pn9+4D2/Pz0B7e0yeA432MWhOBXtkNLh04FWUaQO5r7alm2OnvpysFLT3d4gtwMgtq4vGyah+4OciThN/Yz93I+imW51UNdPxsqHZvFtqNkZBGB/PriARIEPuAVw7fatgKckb1NsIhDjpGbw56Fv5Tz4FaLmgYoBpxOrN6aUKgZwM4ekxndXrScInYb9P2aEqSVuxFN1RYn3Q7+Ybe4yVOkfNMwVc2nb0VsKO2PRXVrOhRIyeD0TuJHvEcOfdfSs0VVtx7ff5FPjSuEhlWz5XhjIXN/PJ9vQRAO6Jxf64UI8LlfwsP3sF4afBO+GXxUvxuUG/sPrfhRnPZz9HwZ2buDEWCZ3zrBnn0awGHnHwiOqO0jM+N3fs7dcVPBtDfxY8pEiXFk8xfKfCMuj4jZx1VQtCNIdN/ubBs56UNvmjstnvq27+L4dghZ+/Ut/a1AO8vbVk3wTExzaNPZNB2bmY6bmo4E21KXiBWNsY90rMzn1PE2w/47yP2Ao9t5QlwTakaU9Exu7lb5Vd5AjcrmiXFw0YUYzOkqnDXo9hkDGTfaSJqoa+6GlwgX8CkDUPIpia+1d
 H9hD6Hh7
 hpu9tSGg6IVqHJ5kalvn0dOVBRLOo8D048AwRUO9BSNOFnodKNrb0TMn9ExkDcBHqjWr6nF7ezvRYb74DPTZbQTF/qqwFmQ29quimcaG/L4vN/d6Gb4apnVaFzCTJ2+c/OoAYAYyysv0xFVFZD1WFFPCfnKZqyRP3c6ZLPuCMneg40lDUeF8H4MNyp+PEgOfHMGy+fp7VNcIyWYBwzd9vZYXuRaXlAXt1DPR3xn6PHO6qd2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The change from commit 796c2c23e14e ("zswap: replace RB tree with
xarray") is not reflected on the document.  Update the document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/zswap.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index 283d77217c6f..2464425c783d 100644
--- a/Documentation/admin-guide/mm/zswap.rst
+++ b/Documentation/admin-guide/mm/zswap.rst
@@ -59,11 +59,11 @@ returned by the allocation routine and that handle must be mapped before being
 accessed.  The compressed memory pool grows on demand and shrinks as compressed
 pages are freed.  The pool is not preallocated.
 
-When a swap page is passed from swapout to zswap, zswap maintains a mapping
-of the swap entry, a combination of the swap type and swap offset, to the
-zsmalloc handle that references that compressed swap page.  This mapping is
-achieved with a red-black tree per swap type.  The swap offset is the search
-key for the tree nodes.
+When a swap page is passed from swapout to zswap, zswap maintains a mapping of
+the swap entry, a combination of the swap type and swap offset, to the zsmalloc
+handle that references that compressed swap page.  This mapping is achieved
+with an xarray per swap type.  The swap offset is the search key for the xarray
+nodes.
 
 During a page fault on a PTE that is a swap entry, the swapin code calls the
 zswap load function to decompress the page into the page allocated by the page
-- 
2.39.5

