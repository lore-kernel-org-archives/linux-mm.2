Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9402DC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EB06B00A4; Mon, 14 Sep 2026 10:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F376B00A6; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BB36B00A4; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1A0F6B00A4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D450A0102
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:02 +0000 (UTC)
X-FDA: 85212640044.12.0697006
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D60F1C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDWJPo6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	b=PVgX0v5ZAdAMcs/xJiB1+4m0RjnLgOTr0UVTsmvYEMG1Zb624/qprkIP1q4KV2TC6U1Mt4
	+wV3CKK71tuL8PYvCg9QTB/gIOUt/iCDEelTgUDQ8pUbna06nZg28TpVvK3T+Be6MCjrSV
	SRrocVwknvZtLLtKY5q3r/eUDqRWqvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397100;
	b=sWMw09Jg4hLdxWWm2HfuZpuev4WmaeJlK5sXRUWZn4LvyVJZh2KLYBKr4XhWn270eZ0Kct
	7WPjp8x6Cj3MP5JoYhTuK1+givhU4MfvOaAVaWwYjcPdbkTtAgvWHkueCfmiCxA5aklcKa
	WpgzN9nQ6Qk0GEuhvcT/7uleUMKi1sk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDWJPo6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE22B43ADF;
	Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A2C1F000FF;
	Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397099;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDWJPo6CioTXC0L1xlPNk0vVexQrbXgzSvuSlsaet6SV0LsY8ktyIn0l7ijI24HpZ
	 0oKlGzJXMdhBqZlZL2zGfFdPn+A9D3PZMqH0DEC0OVuhe8yPIrMQuJ3U79BZbzeLG3
	 w+idBuTZTD4NKvStaRs8O4eFliDKlNrtpZT9YHYqMAvFkrP4Z8kwyCI2gab8/m5n0L
	 l9oS/cYSP4eZRqo8aTOzcyXc1x0DFpwIZ7D80fArIsJhHZgkdYO6LJolsYo0LeBWbK
	 GH5I3ZTyy9mOCG5pcv0+uLo+ThQ7A2FrvstGz6y3hIJXDT6c3Fof4ivhbfqBDRPLPE
	 9SD3UgnHcTWJA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 8/8] Docs/ABI/damon: update for hugepage_size probe filter
Date: Mon, 14 Sep 2026 07:44:45 -0700
Message-ID: <20260914144448.93732-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9D60F1C0005
X-Stat-Signature: 1ww5upwjd1bgamnk4nt7uoun376cfewo
X-HE-Tag: 1789397100-731652
X-HE-Meta: U2FsdGVkX18E6LNKRQloggyPOwcxylICzJbbbCMzbz1CCG5idMZwHRC1+13b2I72c0Z95WI7DLWflEw033vSNMhKrsQCZuqYQ9CdTViCS7xkybkLaU8e5kyDXR/7Yh+P6HCJgGgEIp/xhG8icuIANcvYByCary1wgLeqBfVQ+IG52mPza4lGuhwH6XOZYxtRPubgmPD71FJU+I5fUZOJNAJXMBYjsxokyWbuuQZG2f5PRZJbE9t5TISa+Zbw+7eqPRvpVBOT81vzr6ax1Sfb9CfZ5ujbdGFxJALd92Hxo7zDnr6/tnT0a3xeuK9SBbDpdyMGaQAR7TcglRw8WCBRm4WrdONV+LIxIKkjzh2pWkS5SagfwT3gMuESg/7xvKi16UiqxVoSNN1E+xQN9Rszm2sjTvX9RDZsA0OXPtfwFdY6gY80zUIZvLAuJbb97IQAtcKHCBx3B4I+WmTVVw/O0d0qO01qmskNNK8dufwdrUt8HVYl7Qm7I7DrIpDYriZupNpdazXdD4cfC/0UpKOBlxZfvNQnuXhVpmOYVqmzilL5uPu0w9sqG7hBwW7HvmgXYBwsw4jt9shSs50qelqJibirbqyMv5bYZ+Wz9oB31nXxCHQUf+LbitwbjVudzz9WFGJMfaO0iqiy/tXCREZ/oEiItLSRdq3LN7k1gnl7qnprFGmK9DJHDuYFJpEOiK5E+snsFPvJ8nlFzHM54yOKA3MdagUHjmM3WSVeWrcyhO701SWgd6jaez3B3Qx9/ZRW9KZ4Li8oRojVEi+U6S4SL+N3oNsZ5jgvkS/1t0okX/NpHDrKgRLhvDgcFJ/05DoduqsL6+jnnP7J7UlDI3FVxwcXXxYyIE39/QtSG+IKA0RxX5YF09XC6KoFCRKWzbcoaBfcfw6mZU6+WtHqb4hndZEU9UcJuq15b8GJt0hQz115yQtkxneTnPsxS2dga3dN2yli6uCoxVVmXg77lIw
 r653mW82
 AbIp0DkZa3GkMZplYnJy0sLejWUTHvXeul+aCKvnWek7aT9d/vkcnPVnyVWDDd/YOGr4nxqceR9UJ1RUcq8DK1wGoBzodCd3Lx+p033UgiE9BX6IP+ebhBR0QgMd3hEp54yquTEWQGfJkzoBkUWtmViu1w4hRM8xrobvIMqEIvs761ssG6qfof5xbOjnXT6Iv2qR8cNk5vVZzTHD556/mX88EJOd3kpjhDmnVeRF3gT3o4hTw4flrbQanVIdB/WHtK9Z2mBFhj1uwWtYMuyFur1/5DYr0hL72pAaGv2bEnVTzOizt4LsFn9UJsFTxCHb7PybM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the newly added hugepage_size data attribute probe filter, two new
sysfs files are added for the size range.  Update DAMON ABI document for
the new files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ad21f58f3c912..55df688ea596f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -206,6 +206,20 @@ Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/min
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the minimum size of the
+		huge page of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/max
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the maximum size of the
+		huge page of the interest.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

