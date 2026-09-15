Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C118EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809406B009F; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C7E6B00A0; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597496B00A2; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 238866B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9740D40444
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:12 +0000 (UTC)
X-FDA: 85216241544.12.6D1F971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E988C10000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgUT09d5;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482851;
	b=ag5tGrQ8FBE6MHHYJU4KPFTr5OQ/a0L6sA0Zg5NyVbxGnVIfHf7wBPt24p+DG4sfUzHZ2h
	6O9LTwf51Xh2ATnNQLSa8uceYaw2RkvA0xOVYC8Mv786JJCmcUnm9e6iayoAnCbPBHx1kQ
	f7b/vL8/PnvxZeq9aFBwbRko6v7aLj0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgUT09d5;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	b=bo7iDjaqb6X88/gGCelma4T9x1ILgdWliPo8KThhUgwLCo/oMJ9jjMJtbEahQLm8Der2+6
	LxoCHd4HxH+/opQojNXvx6jUrDG9q9aziu3ep1xJ4Eel16TeFp99e38ECFoep/7JtSD32A
	yfuwqB0rVBNRqKxrTAwnHjI4Icn/gCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 440B2403F8;
	Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949BC1F0089A;
	Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482850;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgUT09d5ds6pCIoWo2JOBAnd3tlvDqG/n0pWkNgSbNxYbSis7mFqOPRrGiZu2UEDM
	 inijRcU+3TOX2jwVNzZIJ6tn9vp3ldP4lgtMiW0QYRrKY36hfP3vsfpPVUFgcM3Lbs
	 oVhf57TvQ+jVFTriGybHMkr68tQ5bkYaH0EhGdCLOjqGuRPOgYYMDXcOI5JsL44PRX
	 7j/9KIz+xSXCVb77UtSQw2BeR31cUmVXDYv19kVJFh0s2Edt4yrk7glfBymvU4SJjB
	 oVLbS4SwReREByD1KNgehWo67kB7Qf8tEZWFO6Z1cPEMUWRaFMdT4KJJdxQcxZowKw
	 uJEpLCUUNq6lA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] Docs/admin-guide/mm/damon/usage: update for hugepage_size
Date: Tue, 15 Sep 2026 07:33:56 -0700
Message-ID: <20260915143359.91472-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E988C10000C
X-Rspam-User: 
X-Stat-Signature: 9whgy6we3hga5yoatjb9k9hq5u8ocowm
X-HE-Tag: 1789482850-850010
X-HE-Meta: U2FsdGVkX1+FLLBwa+jZMbk4GNlnKdLQfgRhNh3B8R6U2M/GYQ1mGgsrA1kqE9b5zPU5ypjlwDODuQ3uP7sG7A6i8XNiYWR7M8C1P4e3YdIlik6SM9xdIZ5XpHO0Ny0cOcrP67/aZHI3cnuBv1+wMJhoAE/DnjjT+5AHog8vQbHB50N8dnk3TcB2ktpNzybOj1LBfcjkeyoWkoY2IKlf+V0/ixgoDCA2A5WeO4+lXpDyZEvF15cVt2zqgdG6lnwh+E0baIeQMFW2X5W8Zm0n/YrXUeebLxpfNa2DaTa8gtfwLZU3k11Luldj5dYe7fbZBboZ4AYA11tmOKCwbTk20DSCf+fGDgoTAAqwQdTAKbDWyGkbS73xBJfD8PDjtNk+ujGaZ0suXZXTs9raaOlmicTyujKXLV0g451TmT//y1FEkIm2nwf9ktMcZFsZtAEfMFCM4diOgpb5kmYYtnCcYWpZSW28WmDw0J5X20DenpFYxTuYCuanRQxOWePXqDIkJBwWEJtClKOOvoW/Vf8qZW75fdDaYyBH3VX59p22MYy/WzBtGRT2Ah+GaK38LolyY4lbTYNsrW67NWjctTNhKgwMjvaIvQk/D2XNKGwOKBrzXekQFCioIThPbv0iLOruiDcY6FY6GhY+sy/bxyrnpHUC9zeD+e+EW9YsN708Ypjp62/S5paeDVbREVc7ecwX5wp0fGhHWoex8/Kz9eEnPRKEwes210oYRkVPpKhc5CYLj3SFZD7FrMPFDrjTY30NgjlymU0oVEC/v7UwEVoNaKLwpACMbtUkE2UG8f6oXE/7ugm8GHqsUtGrJ+oqaDg2BdiX8ZPZwjKho+UW+cwFTkJQvyU64bNazWXqENU4KEhIXtVMxT9HQfGbFOdxmKQQbQ7W9vcBnF1uVK9grqiaz72bEdUUFFNFc4k/cIHxaUQruM+En6PFFVY/RumCKr1YxcWq6CdBn/HcgpYFbIk
 3JVpvrIS
 dk21DmJ6Nowex8T6P68Ew8rdoapKZjFZgw/SUIt/XtGcX2oWNIa0Lyc4D7K4p0rpipoccy2ImMnZKWctQu/+ZYfJh0POnTuGBcrWneX+HajgjbrycXER2CeCFEZMovg6dX700qKpvy7nIlY5Kqgb0dirNvWW2qNOYoubEsz1X/NrxnsMD2IMVv9tKwEft4Ddn1sUrWSvc8kkomQEji1q/yryjqju5htISyR0jqihewz2H6agQcmFJC/kZ+F+fJFeEuq8YqHNPlNk0qJjBf66i2Ohj2cTyBUGnXpPxsKUNgCmh8ejecUxfV+usnHQoxI865dbrA6s15m/3v3jXoJ85AX3K9ECC1K/+2W7FWtlR2avNxBmung0N2OyQqfHCt7NzqFqn2Bs85iA2KCxotf9EsEdW5Si0BDI1SDnXGKwb3EZnSqVM5ngzx+UTXr9Z7OtUau9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added hugepage_size data
attribute filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d3e37400367bd..6b80bce5d678d 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -308,6 +308,8 @@ Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
+``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
-- 
2.47.3

