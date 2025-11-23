Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8C7CFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EF16B002E; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314556B0062; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB056B0030; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF41D6B0032
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9243212EB8C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
X-FDA: 84142745694.11.2D2911B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10978100004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HR3R4cUb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2yJ8CIPOcfWx7JWN81g56fRHUOpWBBV0aEH2lNBhu0=;
	b=o4c4iUHVE2CDp8Y9k+Y0/9heDrec250NeFWsfzKmk7e6ZBuAmruNkBBgucFTzh1GN07dJt
	AvtQ67OyHeqb+Wa22kY8j4tJ/BreHOl/vu0xD2Npmczth4A4TO+Uha4hSjNlK5OnSGO/It
	uO8CW8c8qjWPnwjfZX0z5Siut5kZsqs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HR3R4cUb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923426; a=rsa-sha256;
	cv=none;
	b=TIEacL0NV/moStZzHH6kH3aPBfScS4qURoUQ9KR+FCte+Lrwxqi3gNu0E8CQtF5X2LbtbF
	QpIxKaCMSYpqqV/3PkUIy8b4nGyRPfNT1unSzKbvhh58MzKoW86ipjWJS3dGFLZ/D+Ai55
	EAfE+U1F/Nl+TSpaT+Ih97thME5UCB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C7DE60199;
	Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E96C19423;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923425;
	bh=vPTC/eKfLkll500maYdRrQDlL8kK86gyaCZ9jL7BWDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HR3R4cUbNLbqybOvOYXzWLHXNxghlfQSspgN2RSov7tFY3h3ydIypBfGfHpCLCDan
	 BwObokJtrIAbpDkOYRJFcS3647LBAJo251CSuQlPJ4vGxyOWNSdqetvDp29u1W8n21
	 2kzWyb5F0DjMPOz7ARkx+zG5taQlFN7qpD0SmAVIzJ1ptNJJKLGKYlt6FAkX0O3aq2
	 0sZEC0PsOqPXe5nSdplFJF/D03+uh7F+3BrcVvF/F6Zq+QBa43YqoG8QZyGoBaXySu
	 yifZRO9RXWvt9RlApJcwNya65xh6c85RyVnYEHI1XfSAyFnVLnN0rY8FWTjyNxVWCS
	 1UkyHpR/Z4vRg==
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
Subject: [RFC PATCH 03/12] Docs/mm/damon/design: update for nr_snapshots damos stat
Date: Sun, 23 Nov 2025 10:43:17 -0800
Message-ID: <20251123184329.85287-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10978100004
X-Stat-Signature: b1ejw6uxihaqsgwapicq63g51z7dj9zt
X-Rspam-User: 
X-HE-Tag: 1763923425-315306
X-HE-Meta: U2FsdGVkX1/uxkNWUrnD517ZkGgOIassJ9+bqeGCR9jx3jMmGmNAyvP13so6FXJ2EMszWP5tRvSrQgoXccS2vAsSkIWoyjhfuf9YXcTqePGJAmtWscoNwqSiVamUzNbkgo6tgijfFz80EbAJ3HRwjxMZxfzLl4iTJK7ovcRBOK6RwryrYUl4ZZ/Pw9ZMVZCYAjsXegv6cVVfdjgZ7OnvSa5Rj5S5qzaw+XYE7IOxUyTOhmzKqLbh1S/gJjab5PK4lHs4s9lWeXgbKl1zp8lUpR19bcixEF0pxHyOcX2CAVlLbwJfOL9uD8dojlHW16osKhlKNNZTcvd2G+3LlvaSSMJv//hoX7yqiOs4Whipuz902N/JGUVYKWmWo7wSdUQNslqkh64yfCtGkS2rKlvyWI+gnmy/a5F8Z3r2VGHIFWG9ZvzDcZhHrG+T2sHUQUENkkJjUvszQgDc1/JCE8QxFXYm/VdzBeTDYdYbMYfF+H00SR6W3IxePRaMuXe+eAoX7pipMYBduVlRiGPIhtRjY6EF/GiNUpEfbOFSeLshjKdLVnkjichlB6XHCs4bxR9z9tMo272qm5zr6mmif9nXQrsyIqkbcN15vQff6GniYyVUT/ty4o8HaWYMKq7RzWuA5KXsxut1lygmwcmQ/SRbz7ngABC1glcqw+iyEThXLbK2FZj4RfmYXtLbwMdX+l8UudiPfvolC/t99LIFSEy69jgzjkOVPa5bnmTr494PvLQSNbUdhXQLYnLL33ezbY/5uYDa+EBCc/2M49krB+6gBA25OJgDx9ukvXWZL8O2MfXXoCFvaq/eEzCwqJBI7QkQQivkDDmn+RpzSxg01z11p6Ky8yJ+lBiRedgTuhlRqJskcWvzgrXBPDQKjZBPJPdauyeO+x5ZItqXFik477ltcmGCrNxuj3UqerhvZ3hZ/V2VwWGhQ2YbC1ZYi2P3gd9ZyIg91WBByD5ucKx8ZPv
 tEH9OkMT
 UAH9uEMBqV4tB/duVV+zLC1O6i3cqaZ1GvOnRnaEyWsepuwfstsgVJzuqw8V717nyUlJZCbOnfe5YY/Z/Norsp2DpNDDRS0grb7wpDisCtvx3bhc9jBZsb48uniBus6+l1kIU06Oyy4s44ZdLLo1YUcfgrHJ3hjbK+eDBFkVNx2hnbxGwDD5kG58KWablR/sHEq9p4QjV3J5/jJPG03FoB2X6+t3p3h+cptV/vRtws/dc/gZ0qhC32haM1GyuO0u2AJtbO6mryutq0VGjpBSyr6n0pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos stat,
nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2d8d8ca1e0a3..5cc7b7d662be 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -718,6 +718,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
+  be applied.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
 the region is eligible to apply the scheme's :ref:`action
-- 
2.47.3

