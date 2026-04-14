Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2265F9D0FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E7A6B0092; Tue, 14 Apr 2026 19:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E80F6B0093; Tue, 14 Apr 2026 19:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088426B0095; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF67E6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9490E13A1F7
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:26 +0000 (UTC)
X-FDA: 84658830732.14.F7D4DE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E844F4000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H3R5nb/L";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776211165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=1aPzCaJE5hoJERejVvTe0dwAKbGZXoEYL5d23szSLP4HkmpJeWZpGVDVzE1ADrjkCnq89P
	rp1NAnAIm1TnGnz8zJZ4Mut/84h1i7ZYG2pjViFwXom+Kra0ewrbwKd2zw08/CLF3hueJF
	tmKLn7mZQENWYLXjRq9lyrKMeZruf/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776211165; a=rsa-sha256;
	cv=none;
	b=LItt3SsHAnpKKwyGanhtNpZH9LrmH2mQ/Q5iVUz3aX5xYhWGVGW4RS+inxUDhIG6EJDyeu
	93Ceg488aSYUHAMpeD4bby7TA03JCN+2AIlM5NqCEq+P20TQqrQPvKKG+dRJLzHp12ntSh
	zceraN2n5Fc2F6rCV5qBPkz1YD484W4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H3R5nb/L";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 174734453E;
	Tue, 14 Apr 2026 23:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EFAC2BCB5;
	Tue, 14 Apr 2026 23:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776211164;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3R5nb/LjForXo1hg9/adfUnX1uTLjvOLP3aU91OCaP/Ui0zSo99XMAuRsQVQRQoR
	 W/TuwCOM27bvC3Q1PuQ7GFX1WOA7cJBn+1IsS7tSdyvIrQhxThdiZN1nQFdH97ooRZ
	 4EEC+sQOfAGCF+c29eYHfuf1zSwU8l2dAXxQa3tV+FPHjAa+7aMhcb/MGU2ZaFQV/K
	 5+aJ68VP8Mb2H1Fsu9WVbNwbiF4HTrCNNFhG7bQtAH4JpekEMVxCWDfOJPRQOjt7mP
	 3KWGZOIR2DFEOtuiAR1/7N9zHHkHSHdGPmV67kRFWM/wnLVVBotKY6HArgFfw/u5aT
	 4Zi1XGmk8ZnlQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Tue, 14 Apr 2026 16:59:11 -0700
Message-ID: <20260414235912.98174-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414235912.98174-1-sj@kernel.org>
References: <20260414235912.98174-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: p96r1npma4wprtmc9e9nenuouamxeru4
X-Rspamd-Queue-Id: E844F4000D
X-Rspam-User: 
X-HE-Tag: 1776211164-397280
X-HE-Meta: U2FsdGVkX1/QCSTrK3NgvxHX1LD5VLdZD+GtF79nViEBd00sh21dgZeIuxS+QRJa7dncIDmjOW6e+l32mg2bcaM0F+6uqfdIB2NXtZt1ldJAmxgdKCTLvot34URQxvyFbuTKNZVuw0TDR3n685n8pv9FjDWvNwggvYKaZv/EOhiFnwqiq5GWcuXX4t4xHJchzXywHXaHjJRpDbJia5ptZLpkQhSyAYuediDPZG1XNcXnu6j9GydBVPhNfvnyTLVoza1wkb+Hvv98AZukyPNGuMhR1CXY8hjESGFrwRzcZUcvDeCrYEtGpFelPzYBSdqkN3iTOpx/DOVDMO5FIpVP49GjXbv+wpijDM9BySy/eQzkqikLUDnwFy33kCxTCfGq4MYAJoftgRDYQRlewF9xBJB2qklkDGm0mxWiRFj1hd8JViJ2ie6A2BFh1Q/SQcoSDNHAPN9gvRS0qBL5xAaFu8xWuLyM9HJHZfFZoF2mooDWTAhvUTjmLF5nBWel46NF7VcgqIXYZzpv9UfFQsO38LdI0c8cqjAF89Vt/M9ciyxt1K2itr8Ok0NMDBWEdeKKQe0Kh06xIfWZw5VT0PcxG1d7XhDr4KyvcvVuWT0e6h+2lMZ4x2QHIQvxMnpOMtLhjGbPNEHe+zAFXKg4+XCRv6izC9x1JuIUA+gZ0G9joC2YqEsjoi2VHI084TBkVrRQngjYXFww+fWpTeG+bIOvGIOayNx7HgDWQrjsUA77ienhhZ83oPrLbr5mHTYt+f6vUVayth1jngjVD/ttED/n+m2NNj2hgsGprhxtUmY+FXvZ3BNQe7XJcS2EpzLoL34zNxTCfCNo70aGMQ9p4QeRXJTPHNK39EDwzehf/Bt+z7RbcpZzbqDFbWhuyv5MQ4re/INmiDNGlj8FiFKHH+UbYyc6jt6XkTrEBRs9eKV0WJwCK4dF34CPp/cv+kYW9baoN3dHlaL1EXNaO5qjh3d
 31HAclSz
 cD+/0fgN/ie9M/f62BGpgtJslsiyr3mLJith9iMs7jIL5pXoGEQaWA3Ci3HQQdSFUagO3DBQW9NNgtXrrsA9zSy1N8n6hb25Nq7ZgpyFizpaVkvzWGHVhHXu7JF0tH0aOiCSU2sNdXXKdW7/3mNFCKd5c+ejA6futVTv72xdjzvkwYIcz5G58pAWaHVgiVFQq/esM7O93Nei33tj6w+6hTaSBBWyWqnqfnUrBMwfXbOK5ky+lg3EIuRVIwK2vBmjL/A8pyfbWvDi1qkmQ9DYPAO8KtH2Tq//g4Cea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_STAT usage document for newly added kdamond_pid parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index c4b14daeb2dd6..46c5dd96aa2ed 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -89,3 +89,10 @@ percentiles of the idle time values via this read-only parameter.  Reading the
 parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_STAT is enabled, this becomes the PID of the worker thread.  Else, -1.
-- 
2.47.3

