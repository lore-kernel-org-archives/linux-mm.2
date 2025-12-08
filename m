Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622C0D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F496B00B2; Mon,  8 Dec 2025 01:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A180B6B00B3; Mon,  8 Dec 2025 01:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9560D6B00B4; Mon,  8 Dec 2025 01:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 727406B00B2
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BFAD52F59
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:50 +0000 (UTC)
X-FDA: 84195330660.22.E20E46F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B4F921A001D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MiIlJ+UI;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0Wtxzbvg9xFM04USQWfyqFRNJGJepbClF7RYbXTEys=;
	b=TafvJcAKadtFd+C+7dQ3gbgJDmj7i3/d0DTEV1yIhPDc7xb6VKyHA4G14VJzSA2KVxreLI
	ys7cw/PteYwj6ny4GMgyXQiHxuvHCAIXMXMftmrfc77M4UAE3esEzmbUmtB/rWHBLjp6yE
	yVu/BPrN4MzbbgdTf6peisxP7Bn1FGY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MiIlJ+UI;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175448; a=rsa-sha256;
	cv=none;
	b=uuHbZ+U5kXLl4pXIfV2WgoWFezJuQfGI2fl3sR2LARSifLUeNLQbu4KdqJQhgowRLC25Uw
	bFO2ixuTz0mm2tnOpDMj3W3SOTCRQiGnVgDkktERJZmh86l+epSA3awqy4/TgB0lXAAm4U
	PcyKoe6Rjqf7ZuP1MxyvPwpjynfOkVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E81D9444AB;
	Mon,  8 Dec 2025 06:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F421C116B1;
	Mon,  8 Dec 2025 06:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175447;
	bh=7LPwC6Tdvp2/F8X1UVIxGeo9+bnDQ2Da295YW1KdEhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiIlJ+UIhaWDtXpVtWGyfXhcGkfyDG2je19PMonZ1FJur8CzHYiCsCW7W+Xz/Cs7X
	 f0ApIzkuEp6CBnrLykZlYX1TO6xtB0Q2qb02e8WQP+kCSn5RPcThXAWAriKYeu+VEM
	 hnWYsawXlfplP9ofPhSyiuOVPeVEEwnWGWPe1Hg54CxxzOOAxTRsA56PE/AUlObxjI
	 30MyNHFDj3mBswCevCm36eEGQA7rmEDvN4GP28hORUJDMs9ltF+lvxGtPiDAVSPtq2
	 6Q+fMHbT1daCzHKPwvNtSOZTSeBHpyUEzIKZmpUh2wKwFU+IAW1LW4jwd1r9nLW9db
	 rLZwHbnPPr+EA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 37/37] Docs/mm/damon/design: document write access sample filter type
Date: Sun,  7 Dec 2025 22:29:41 -0800
Message-ID: <20251208062943.68824-38-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4u57ekmcwnhjihkdhndbbz81s94niet
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4F921A001D
X-HE-Tag: 1765175448-896923
X-HE-Meta: U2FsdGVkX1+YYsJ2n5KoQt/DQLkw+zZAnfq3BKtb5cddO8Kk28C+a0CmjAslc5KpPqvcKntwZnDxt3EqPBeVxfUUeQ+WYb+cBjfiRHrMhEN1JRgFQ7J2G11thbWw4arOXe+XdMAzFnhSCf+G40wrrxddYh8nQz7MdbqqVPjaN3lxbA1NDD1CrTj2L/w1916heqCBGF+OSXhv7NRPDq7yuNJeYZ8w3+72nnco2tqDGMG+GCnLX0vbjhEKZrA42mVuNjovW/HmW/eSWpe8sFQjBirEeJDhHUK2EeSB/OolO4zSwEjJHEguvXYe0VBlExofEYE0EM4YcJ4nB+sX2k9nx2BeaI0wy5XE8FFAcw+gls7/X9dhBf8ec/qJ5KqvYR+EKqH4f7OnopaHeCj6e7d+c48pGIIBp+6x7yqZAj40476ss2EVa2Yo/5AYKyIG22jZgQpKpCqqNThomOalckhE1vW7LbE2X76nyFPP2FmhqLh8rK8STwEH4WZyhosFUOj9yzOff+vCL4Wpo6VJfI2WTyVeHpr3IN+7B+qBOWMY8FTWs+rpheC1CZ/WSenb/fWuGPnNiwEoM787ljPSM1HMnMxoRl3goRIi8rFSA1HVrKBDA2XLJAtn22Ej2imK7H11SPWMW5AQrZDKUnM6itsKiCqk/AnKa+zRy8DyS3loWfB1holHTSwCNYs3Jc2aJMMlVi6NVSQz7PlOe9Ue+n8MG2ncDMzDjN3zzExxu0crKV7GaisZDBgpjyRixunjrYEIuwJTcntwfZGWVpPiFaW8Z+Xy4Xj1nt3s8L5F6WfF4IXPn+lrKgs8aIDiDq9XiATCTdOVXCIB9RRB+rYhLr5F3Z4bbLTr4i/mc/JRVmDUXPtVlXZBKVcgP/Es9xgt1GvXA+EDA0hpn1PC3XCrU+byGoWX69jiXp7bIdETi3VjehMFNWjnKHTJuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the write access sample results
filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 4c6d83263a7b..b194bf4a6519 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -148,7 +148,7 @@ the page protection in a way similar to that of NUMA balancing hinting faults.
 Then the page fault handler reports the faults happend by the installed page
 protection to DAMON core layer.  Compared to the accessed-bit based one, this
 approach gives more information to DAMON, such as the access-generated
-CPU/threads.
+CPU/threads and whether it was for writing or reading.
 
 ``paddr`` uses :ref:`accessed-bit based check
 <damon_design_pte_accessed_bit_access_check>` by default, and users can change
@@ -317,6 +317,8 @@ Below ``type`` of access sampling results filter are currently supported.
 - threads
     - Whether the sampled access was generated by a thread that having a thread
       (task) id that exist in a given array of ids.
+- write
+    - Whether the sampled access was for writing.
 
 
 .. _damon_design_age_tracking:
-- 
2.47.3

