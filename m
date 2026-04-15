Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C70CF9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64186B009B; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14346B009D; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F9F6B009E; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 797F16B009B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 404DA13A6E6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:02 +0000 (UTC)
X-FDA: 84659036364.08.DD10904
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8AA9E180004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X11PWJG3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEGo5DtmWWGdgvsVdHEg/7lChf+E1z9sjR7zEbplfEQ=;
	b=qOK5PZYVe4WgRQaIIeRdfrH8y8UOoXC63PvWfLWPXqUUiFQ2Hermq9W1/Z6YU/giAkt20z
	pUOddJHRdGJdRGhnBmtB2kZpJ+v7i/mMVaeCZp9ZAbwyTxX3UqgUJo3ZxXgeEm8ZK0g5Ga
	HrdBHQV0XWxQLisUMYUsFS/vixZu/6c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X11PWJG3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216060; a=rsa-sha256;
	cv=none;
	b=6VjfonaYn9vu5NTOcPJPJNATZOoZpLqkyD41iumZIplvOKABtN9nH+2T+PpDEEajUPq46Z
	c49VWf5jp3lh5Dvu5c5LFiMhnorvOHi2Tf4jYO2UIhyPZDcwJVZvTWcVVCXY2qV/FchlHs
	1+l/GHqcJkds6sz1ZPuBOwoDgLrdALc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E8651600AE;
	Wed, 15 Apr 2026 01:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8B3C2BCB3;
	Wed, 15 Apr 2026 01:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216059;
	bh=DstdtJTxjDChhGDlgpo8hhIle9ABxcUjhKJsfY7hfhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X11PWJG3DoyCdwo0kmy8K1QumXjfCBzqpVmpQ8z6UHj45Tx7uZkXnsrlkqQKR/fpA
	 vKiVuxnMUpslv9P9F/VaHo89XVjAcCJHnRVB/HXTBK/9HWJS3d9Dm5+HDAAdmhNr1g
	 VfNO3aEC/3GsPS5oLDVCsgAlUtoh2uHmj1jx2z1OAsc7GYNrqyT5WJJwCxrfW562mC
	 ETt0+5MXhtpvii2faQu/fIRzhfpdyen8YqDfgMf8667O3sqp4a4/oHRnaG0R4Qw8vX
	 uh11VIHnV/wRdEgo5OI83UclPt3xpe2ysGbpDHLX/iXFt/jUoiJbi0BbSSdNbTHb9A
	 TDnP20D5ppmFg==
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
Subject: [RFC PATCH 7/7] Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring
Date: Tue, 14 Apr 2026 18:20:35 -0700
Message-ID: <20260415012048.76508-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b33ns9zpw93j16zuebppwedtp9koamwd
X-Rspamd-Queue-Id: 8AA9E180004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776216060-833361
X-HE-Meta: U2FsdGVkX1/y0V/0v/is2YfQFv70vc+fcHkI4EE+eqFUp5E5bizH7Qx0K+YEZYKhkcIPD17Z9009K8Byvn+JRjg4nc80+yh1ws0m5wPONOAXSbBgPAneP3BcObtGBxqXeLGTJgrg5s3LpTeIkymU1R/L+Ei0qxir+2c63NhDyMLRS7RXvO4dZe+/IKnXY7ef+SzAJPYBwj8nYdY5HqGKem3otp3/+5OrQamYZwOfXxU4kVOEWfcW2ZOS0BwvP1CJ7HMRiKORjozn9PbrS5zpljrjUhxoZlGg4Sb6r09ma3glNPncd76Vg3Z0I4Mf7IODWY15tSLptAsSeqfyJQK2g8O6DKwYp7lMZd9WMH9+Hyiuw7WLxD8DqnMXqZUVxXETuMm/u4XIHw8dn9zNdIJIWNTh0423TZ4xdgDMPONgmycVH08hPs+8ADvcqEoWxrrZhkS5EyOhBfCyaJ/szdNj9iPBeVlksjxYpC7/m/odvP8e/7FGZ84WBXxH1ZjZkxioVfgI9ZoIZ6V66DMMrpRh2C5IYzLyS/uyUt33EU2mRrVuZb1jSDaR+eZXpvNUVLBIJU9PjPy+yzc3tSWkQj2fWKnB6XB3I9uwh6IRvZgMKBFA+YVHW30bEGJK/4KGNUpDKl2VhG/T901newNwGmi5t+e0Uqc0icRM5pdaFBdoMQOFOkDGXCLurJp3ANg2a4p07wWQBKNtg/z8Z3Nf0nYGjKTByrwxl1jP9NTt/43vD4rluD5Z/dLLGO+sNAdc1BZFEeQs1z25GlAxZcBNkNpCBQeWZC+kU4WVdTY/VrVKEAdOhZvKWQc+fAyssIYygAFufcwmjjcu2A3t8yPBrXreQ9ZxWPbZbrNsrCWHxUIEuIBfOtX8P1ZLrsMU+4wvlRPIRKLQLAMw7gHRKgLTBGS3SvaesgHz2z9RJsLV+pfvd78swwXDKEtNXMNWJS22i5oBHVz/U01GsIbaBdj6HE9
 r0WYZaA+
 Vjp1LT5N6iU8KB4Cyo9viQmMjqiQCLi3pfFfCFqXZG8NUGzeVaVW37bZ4TZUTGKcpeZFEhR5ULuv0TG7fuUQz9kCyJw1dcO0yiq9CeKCyXKWqyCqOgQSyqgQF5JswxIJaW8kC9G8Sif9xjAcWiWSss3Sl+3n7yxcyTaFmG8V/DhAhqP7gZ/qO7HQzFI7mSOcHdB+fzqrH75WK7tLrRRXLJ5+HHoFSdPkZRcBpKaBoDHUAeKzpLyDG0v/qmwbbGUX5XW+x+PUojzP0DQZP2z8SqQ1Cfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_LRU_SORT usage document for the changed default monitoring
target region selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 25e2f042a383f..796b0a028555d 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -246,7 +246,8 @@ monitor_region_start
 Start of target memory region in physical address.
 
 The start physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire phyiscal memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -254,7 +255,8 @@ monitor_region_end
 End of target memory region in physical address.
 
 The end physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
-- 
2.47.3

