Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31984D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C7A6B009D; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CF36B009E; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2745C6B009F; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19F826B009D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF473D20A1
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
X-FDA: 84345856308.26.C2449F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 010ED40011
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fWz+F1u2;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+Hve0e24KOPJ5BZ+cLRySKfgtdWaOexcLSMFLWEpjU=;
	b=n9tKIBj72QTzv5iaUIE5xHsJP7DPn7X8a9fOJq7ZcxqaEYq+9TEcE1Tbn2fP3zRyjDy5nK
	e6yPPoyzJDXt+kYZaJHtlpamq8dq8ZPzN8S1bWR8A87QTY5Ud+A2NAK2vWcWuXk7A2Lp4p
	nw6YsmVvJiSEsQEPv5bHy3n0hYs4108=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fWz+F1u2;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759393; a=rsa-sha256;
	cv=none;
	b=JlsOw5jj0oZjxOq32epsEKFbqlgmOB2chWLhSjd3qzuyMFENTZIqstSSPCf6d9El6fZ3Gg
	nPYDSr/3bVNXEdG5srGgFnnfwFfPmR4IyWFXT4yVb/bZLtYVp9B7Il7XRbsCedsaNexeVk
	ddHdIV4kATw2X4/rYnUX6kxP/GBoPfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 156AE4376C;
	Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF20C19423;
	Sun, 18 Jan 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759391;
	bh=83IuoEFZc740QLG5aKQwcz8CHpKwZZ8E6QMpPE52AHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWz+F1u2EZ9yGEw3rOBKhxt5QQtmFKsc3wwyz5sy4hP1KAsBNR9Sm/3l+es57SZJ8
	 1YXKlPu02whCdxvVeJTqyJBLKNZYHS7jDfwCQIRCWItCKrbHn6XIp+rlfStnSGEhgv
	 kt0Jro1/f3e+3xdh05vBDp1tpLUF6/8b/AlM0rsSHrvUF/e5H708cVhSRiuwQmCPGt
	 ttEl49dq4FxIgNVXutmlwFMbukr3l6gpV5j906Ot9HyXixjYFXhNGzEwFMrCVZ5bHt
	 hduyjVpjCRY4qwWk7fvBWcXLYxiOXOS4wH4RWdwuBVswxPNlTfRyTxgob1rGJexsB2
	 JjEuCFXgguSvw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 1/8] Docs/mm/damon/index: simplify the intro
Date: Sun, 18 Jan 2026 10:02:52 -0800
Message-ID: <20260118180305.70023-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n93ihfygzu5xcsxsja1q1u594r7yr5n1
X-Rspamd-Queue-Id: 010ED40011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768759392-965546
X-HE-Meta: U2FsdGVkX1//anitTI4zSuW0V927kqi0szim0zzmc3q6jUJhQgG+lNJaHpd+g4Oyj1dR07Ek9BZQNKlYREWTRjtLTxS4c0axfwQYO1o+Jm9yYYGDg9ARdiAmAG1vVC3G6MxFoa31W8aSDSMRuqvfGPv3dhGIcEOxrdvqGmu5cnuYCSB4xi49bmsqmo64KWV84YJAQdFORJXTbIcJ3bMf8aNm3OgsI1YnrkNZaqSMvSSwz9Zcmit1KuEfdZIjgrxrJ+8oHZoB4jbP0tTy5yYKWIaRPnsayGA/N3e4ivpt76kgQ/xWPueIjGdngyR8PlH5/eKiNgFpjYOiO1Eot+hDgj0nZNMgut1u0lJwZqbRqEGdmSrVbECtQ5bbmDqjh1ucYcPz1GjzQrPmpKkMIFAOIu2qKpb9zfdm9KhilA0NlDmGrl+zm4PX2eiP54iuIRbikDXagV77dEeSe/JP9/Z75tefF1xpz8WcdvWx7yeT3H3G7ukx3D26itLdeU5JGWwXuYYrwqVRJi+X6A7mhOmBoa3p9ydPZnxPpxpw/Yu62ieqUnpRLt9lLBq3FBJ3j4gt0o9SKT690/Sqe8hmnNynkSNYsZML3RVxgG81AGJkyjrxmAjM7iTNFmpfgeeN0qDy/Y5kE+ii7UkgClZ8wcLXwfEu+HDgACqZBBODMGuRNgGgpqWEtE2QGSgGr6iFHBmamDBb4H/RDk1WJRIBfB0QjdPbfdbpEqLStASqR+D019/ZVV8uNTcPA+gqzGnzT0QseNzGAfTBlyYqhbLCgp/4GnNFCRdg6GyHMdb7zqyZmAw5vvwKF4hbIAv8NGQJoJhaqV1p97ctndEOljLFxr6LFX1jKmB/OKChVjNd56Fn8X7WCCQlsIiDK5DGLsdthGozTDbNm7N1nwJeN6BlKCvSe7cbCXWld6bytkVXvFV1RGfqrHJWTevGrn40h6fsH4JLHTY4ko8RVK/YFwYjIh+
 S7eRKb93
 7dbe4zY9y+X9zwxSzUSvFWPhBFAjzRVLqtldA6Zz1eIjhPG4k+Yva/7FqgrwbtUijIBLa+RYz04hCKXJMuHAT/wFvMUqemOUdOzttL7Oma+W7U65mXGuSRdJtzDq3yxgPxwPxZgNIU/iqkrQcszIt4IXBQPTkid4xuPXLefYi1tTYXDjqg+Z2hKNsGFzetL8V5fdwDontNVviY+vpATo2OJRsJs1i0gweiTXBYAwStYxw05lLwhhfgyuviFh5MCNyYja89k66OqYHv6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The intro is a bit verbose and redundant.  Simplify it by replacing
details with more links to the design docs, and refining the design
points list.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/index.rst | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/index.rst
index 31c1fa955b3d..82f6c5eea49a 100644
--- a/Documentation/mm/damon/index.rst
+++ b/Documentation/mm/damon/index.rst
@@ -4,28 +4,15 @@
 DAMON: Data Access MONitoring and Access-aware System Operations
 ================================================================
 
-DAMON is a Linux kernel subsystem that provides a framework for data access
-monitoring and the monitoring results based system operations.  The core
-monitoring :ref:`mechanisms <damon_design_monitoring>` of DAMON make it
-
- - *accurate* (the monitoring output is useful enough for DRAM level memory
-   management; It might not appropriate for CPU Cache levels, though),
- - *light-weight* (the monitoring overhead is low enough to be applied online),
-   and
- - *scalable* (the upper-bound of the overhead is in constant range regardless
-   of the size of target workloads).
-
-Using this framework, therefore, the kernel can operate system in an
-access-aware fashion.  Because the features are also exposed to the :doc:`user
-space </admin-guide/mm/damon/index>`, users who have special information about
-their workloads can write personalized applications for better understanding
-and optimizations of their workloads and systems.
-
-For easier development of such systems, DAMON provides a feature called
-:ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
-to the monitoring.  Using the feature, DAMON users in both kernel and :doc:`user
-spaces </admin-guide/mm/damon/index>` can do access-aware system operations
-with no code but simple configurations.
+DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
+<damon_design_monitoring>` and :ref:`access-aware system operations
+<damon_design_damos>`.  It is designed for being
+
+ - *accurate* (for DRAM level memory management),
+ - *light-weight* (for production online usages),
+ - *scalable* (in terms of memory size),
+ - *tunable* (for flexible usages), and
+ - *autoamted* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
-- 
2.47.3

