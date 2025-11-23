Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC74ACFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828D96B008A; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6211D6B0099; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7726B0092; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02BFA6B008A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8BE2160179
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:49 +0000 (UTC)
X-FDA: 84142745778.22.0F79EEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 215F31C0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GDRk/cn/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXIrqjw1RbZh9mM5rX7YXg46J4nnw4+UUqj3L7fdYI8=;
	b=f3UQVqbH4IAVbe9cx3cu7Oi0CUvJda3BOO+5Jdb/sg+S/Bej8qx2v4sCol+hSvNmM0Fkeq
	oWlErdZZdvh8fbWMQu0F3gIbFF8s21CY/K/0kcTNJDK17k1nq/uWj6M3H/7zXXQ1HuWtCb
	b4TGPxAusooolxsNN94dI1dzN465pQQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GDRk/cn/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923428; a=rsa-sha256;
	cv=none;
	b=xB9kiQdPb4W+RU2jpzucBGIjH4luYukf6Yg0kGbFXTlfLA+Nlr9/bFOQkQ77s1E6Mjza8l
	dybM/7rwqSWwGmgVG/ozbh9+zXKy5yU+ZYnykzcqQ2ZT27M+NK7VIUkd0HDFyIn3bCCCom
	ysmO5E8phah8qOvToqqdGz3vqoJ7rq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5318B440DF;
	Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61D8C19421;
	Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923427;
	bh=iXEcDN8E6cxYy3isQfAsdFaACSzfCgupWIVQKmv8ny4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDRk/cn/AEJQHJM38Tao7V9q2kGxm1ykxzMdjMBo54eYpg72gExF2HFdDNUPwdHgN
	 wI02Rr2O7iYuV8vOhM1K4McnURJ9R89ykquKUPEO1JWyiqqsqjt6YLiS6g/3J/pP9Y
	 noY4ltkqc5TWabMoj9UQPRKkzjyBGw7E7qcioIccd0m+fEMymoonFze+t/Kn2HuCGK
	 M6lVuwXRhmteHw8B1K+ueIjL5wgFBEQIXlcy9afA5pw+zefV+qYquw6bBovJ7ZN2LS
	 9NpJhnmd8SXc+mtaQEXW95AHxGqcrXYzQque2fZJXXbKrKEybK0rDGJ+pPKLHQUq3X
	 VjFIbbEFgRUyg==
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
Subject: [RFC PATCH 09/12] Docs/mm/damon/design: update for max_nr_snapshots
Date: Sun, 23 Nov 2025 10:43:23 -0800
Message-ID: <20251123184329.85287-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 215F31C0007
X-Stat-Signature: zw9zi9o6qrdacpnajgo46sbgzqfgp51r
X-Rspam-User: 
X-HE-Tag: 1763923427-747950
X-HE-Meta: U2FsdGVkX1/SNDv3LWxgQ9+XzQqK595192s6ES0sLKjmr/LoQQmSJP2IkiJQHOQUzvOkc3Q23HdNlOnJo4oefsz3KzOICz3utzVT44aDdMNO9N/6sqvXKuc08NCFgDgwn2tpH4rkh7KAjNvmZArjRYiWXyyZnTOxiQaMVgG8RMSHwN4hJo/j6zZqoCClZ2/M3QGAriIeey5fOOT1GeH8+dCqAl46zWbLMAGQk0KrZ7PH0y7AX0RaF/3UGR1ofJ8UyPPCk0VwjP/sT1WByzc92pYwmrsauZnFK5iRmBqhVyE/rixa1nHfo3/S6euA02irhpHZdPkhQ4LIIYO6g35v5O2BnoTr9OXc9ZCJEgiZlwQotOOBsnSvvxoN4S9VVU/tjtuhzeQ1UASURtgSc6fEQgNMAFZrLmneH/6mfBY17SsK/yMr92pATGCsd/iWLBP84GAtzG/WiF/RfOqdOhzQceKuq6x0VYw43rhZ0VJr2MH8Y4sfxGtA0ZkRIGaO+PrvyZUK+iP/vRUYcRSCq2xCGNVSAIeit1/gR0Mev2lodL+mnDpK5rNbyQ+WFzm8lcPqUO4PgwKuGeLZrr7p9atmksOitaY+J2B+o3wBUI4y7obgmINe0uUyNbNpgZREq2mr3KxpnJZIZcg1mmjDLnLpH/wX71gQmBRyEsGMeLSvjvr/S4JmFDosQN8UZ3NCH0CwmsChuDjWhuTMhNfb0jaHpRameuSETLW8KPTb+76+PbDOO5UPgzbbPkBrChKTa1WBUhYpEGXHvFLexpNtaJQggCm8CYNVziBh4btl+3K8x7Ka7BaHAjcSjXaPoVPNCYvo80g/yoLCaZLwmpBgJqEuru9bib6jZirHJ2fahggPE4Nftsbkyk7T7QlEL74yfYZ7wWooM/xJ/Ieg/6FhKxS3J9N8D+mVbwMiNaMkQ3It/62Sg70pS8LiKoWknyHemQMTFlEkwasSH1N4DOjobo7
 7P1C+nyS
 IJoJJ6Cco2hprpZOR4N5PLCrfkdkphKlLibEAmtj/OD8lZVJV9RjSCV6Cc4HfNNWKa/FUwnwxnGP/5/Hs5wqfC1S3vpOV9FdDa4xY2wvEfNWx4DGrNVLU7pvJj7nKEq1nUmTZxCSJ2bB/AYPn3KCwFIB+46wtSBZZgnS0yV0996A5UC7qL6Dj+crlzGxYSKJzssmWy5QzF/hIcf6B4Dk0vF+cRJqwZFbs7VjSqYqRon3GAXMu0jIsKgk+SZHug3usR0h83Yi+fjpDp0bSX37zaxKH5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added snapshot level DAMOS
deactivation feature, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 5cc7b7d662be..7fd819b8bbf7 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -720,6 +720,7 @@ scheme's execution.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
 - ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
   be applied.
+- ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
 the region is eligible to apply the scheme's :ref:`action
@@ -741,6 +742,10 @@ to exclude anonymous pages and the region has only anonymous pages, or if the
 action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
+Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
+non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
+scheme is deactivated.
+
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
 documentation.
-- 
2.47.3

