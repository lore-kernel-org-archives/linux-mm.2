Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD9DD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B607D6B0005; Mon, 15 Dec 2025 22:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E9D6B0089; Mon, 15 Dec 2025 22:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF056B008A; Mon, 15 Dec 2025 22:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89E296B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:03:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22FAF16043C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:03:33 +0000 (UTC)
X-FDA: 84223838706.02.3B154B3
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id C3FF14000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:03:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765854211; a=rsa-sha256;
	cv=none;
	b=EYrW8eexFiCBRI1tRBL5TPIcccr3bv7VFS2r93vt5sSfzvyce2NnPJ49/BWsUkZ6nvvfk3
	MYZqtoS0wc+uVLtIH6P0B77lqRgbubtlOxYw1zXSO27f2kpVpa0mkw1KlbyLJdXrzC2tNJ
	P3TjUcXv/1LxQx1SEUTBAaLFjBpf+Hc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765854211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=0n+yNWCg3MVEOuI8Q2W4hDqwML4ROKKAU8NKKKpe86I=;
	b=m4K/zPNJ6hCjl4F0lvwLalAC72z7Z35EgtdDOEuHYnP5CVX19aTr095Mv9DhCWTJD/ySXp
	bLa23ONQU8e3BDPbgnLyvU5BW9H25i7ExsflK7r6R/hsCyul+F0z+NorQeNb0u7AZbZZ3d
	SzCqHfAkTzUX0uMET/cjHMucyOzyhNA=
X-AuditID: a67dfc5b-c45ff70000001609-3d-6940cbfe996a
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [PATCH v2 0/1] finalize removing the page pool members in struct page
Date: Tue, 16 Dec 2025 12:03:13 +0900
Message-Id: <20251216030314.29728-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTYRyHe885O+e4HB7WxZNFwUSCIrtg8BfCRIJeIksoogtdRp7ayhub
	mobFzNnM0tQSTVcppnlLY9rcxlbmvaQ0LZmUt3UxKjW1LHNkLvHbAw+/59OPJaUjlBerjIgW
	VBHyMBktpsQj7oUb/rYHKjfZuj1BX11JQ8XvOLg/aBLBdOUwAfpyI4If028ZmLW1IJhsaqXh
	a+MEgqLCKRL0HVoKflb/IcFsGUbwJfcBDR9bHAxUGIJhoOQTBVZdHQmO6200pGlnSLBNjzJw
	yVQ6F67RMNBpTBfBzT/FJNRpBhnotuhp6K+cFcGnhjQKnuWVUfA9u4mEgfRAaClYDlPt3xA0
	VdcRMHXtNg1vblkIeGR7w8CNrgIa3msHEHQ1OijIdqbQkJ+YjmDm91xyNOOHCPKb+5lAX5xo
	t9O48dsYiWvLegnck5tJYfvj5wQ25/UxuMAQg2tK1+FUexeJDeVXaGyYyGLwux4rjdtyZyhs
	HvLHZtMkgdOSRumQZYfF20KFMGWsoNoYcEKsuHe5mYzKEMcVtb5AGpTLpCI3luf8eEerRrTA
	SUYn5WKaW8vb7dOki5dywXyV8TVKRWKW5EYZ3vrkF+0SS7g9fEp5DuFiivPhM7VF/8cSbivf
	raum56Nr+IqH9aRrzHOFLD+WnIPmxQr+aamdykCLC9CiciRVRsSGy5Vhfr6K+AhlnO/JyHAD
	mjtByQXnEROa6NzXgDgWydwleHa7UiqSx6rjwxsQz5KypZIUe4BSKgmVx58XVJHHVTFhgroB
	rWQpmadky9S5UCl3Wh4tnBWEKEG1YAnWzUuDspynNJ+PJ1z08aq9mjTuPYReVc32JfToD8mW
	Z+3q/bDJuqzt1vpowwEPfYj/7qo72/fJi0I6ysx+v86s0mVH6oymRLegZNvDYwaPXRmraz7u
	7/Bor7Bo9+4oDre2HdYpmk9oulnsfdS7/uXdL3/HSoZFyf79aOd4sfqF09tBHAySUWqFfPM6
	UqWW/wN8heHSAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRW0iTYRyHe7+zo8WXSX3ZRTCQTpQJFf9ISrqot+h0E4E3OfRDl5vKlrZ1
	oJWiNnK5DmQ5wZppHlLZapviVDYzTcSYh9ZhakYlZTN0eVyZFt098PB7bn4cGd5DRXKKtLOi
	Ok2ulDESSnJsT/bW311xiu19NhrMdTUMVM9ooWLYScNszRcCzFV2BMHZdywsuNoRTLa9YOCb
	ZwKB5cEUCeaeHAp+1s2R0ND4BcHXoicMfGofYaHaehSGyj9T0JTnIGHkRgcDBTnzJLhmAyxc
	dT5eDNv0LHhKOml4ZTfScHvuEQkO/TALvY1mBgZrFmj47C6goPN+JQU/7rSRMGSMg/bS1TDV
	NYagrc5BwNT1Egb67zUS8MzVz8ItbykDH3OGEHg9IxTcCeUzUHzFiGB+ZjEZKAzSUPx8kI2L
	xld8PgZ7xsZJ/LTyDYEHikwU9jW/JHDDfT+LS62Z2PZ4Mzb4vCS2Vl1jsHXiJovfDzQxuKNo
	nsINH3bjBuckgQuyA8yJ1fGS2CRRqcgS1dF7EyQpZbnPyYxCidbyohvpURFrQGGcwO8Qsu0h
	aokZfoPg882SSxzBHxVq7X3IgCQcyQdYoallmlkSq/hjQn7VXWKJKT5KMOVY/o6l/E6hN6+O
	+RddL1TXt5KFiCtFy6pQhCItSyVXKHdu06Sm6NIU2m2J6SorWry5/FLI5ETB3oNuxHNItlyK
	F/Ypwml5lkanciOBI2UR0nzfXkW4NEmuOy+q00+rM5Wixo3WcZRsjfTwKTEhnE+WnxVTRTFD
	VP+3BBcWqUcQe9nyMFYf6dDHGafPnQRDrT/prX3U63LZOiuPl2U8SVYl+VX7Y9SOmC5t7MmQ
	bmP3mUn/gVtbci2H5oLNgW7dwyNlTafiv3MX3/v9z1Yi24VNbr2pIi8st7znw4rlM2OOXd7E
	X856nkDKtfQ4/Xo0qrWF121svTQ9mluSIqM0KfKYzaRaI/8DjxHjcOICAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: C3FF14000A
X-Rspamd-Server: rspam03
X-Stat-Signature: eqmjdwu3o1e4eanzrkpcoetmj8joas3p
X-Rspam-User: 
X-HE-Tag: 1765854208-837302
X-HE-Meta: U2FsdGVkX18RNByIYPw9GjI7efhj9gepPNCRYnFkUvj5xl8vmMJt9atrjKBoIMzsM6WWL6e4bmYeFElAs8ri8ACThYu62aCEGsFn+XaVTjo/D9jXvgfXcW+HTArxFAmkI/UT5iSsUORM/CXaE+aQhEP1Z1gz5E3CIzN7mHFciSlNJQDYMCqZ7v06hINdtcWH48Mwx1DyfBDHVfr77Zn6rQbWmKpfgFbQoZF3C3CWRbQ191mYhwV9Oxwm2nfiNvWPA/mav0us/THipTI7fjTIkHqrqDP2wXulbVzk9KWUT/uxbp3cddpls5PkZowrsoNucQTWBGaHzV6CS7fCUFivrotkoaF7X0RUtzvIBolnll3ec46YGXGSC8v7WwHdpp8wXvjyCJCrgSFS0mgAaYdl7HMitUPuqijbFELU6UpAmQjZHj0j1LvortLh5bssPmpY1HAzTMbAepXQcpeT1jeSRIKF97OsGwXfWFDLc7Cn4K1Jk6JbyQkZyeYSKEldhZ5FHOVVyvDWah+555477Tb8cTSA04up53xwh2VtJhHCrPSjJKshxTnGkqWIWOv9gruYhhL5snM+6WG0oC4ArsGMqNV7opByYWkB5eX6g3jQDDmJi6GkRUDC+G4M99PfZeWlB5TU9WQ2MJ3El7n9Ya6mzqXW7UNdRnZFZ6bPSEjC31j0cR07B805HtfRI/6OA8tLvA5B3hqntoKXHDP+LdKcnJd5ujTB4WzHFqb7yo+CD8XroZEAaURzky6Qqors77Dd8vnEDiDygKO8/sT7iUh1gI/p4eapXan6K6onn6dq76b5Ge53uaii8LMXpT4sjonafwhDwpxmantMNE7KPyhhFlMaHhvL9HB16YuA6jePgQMCWwUaShFsaGyUnCZb2vyuaHjRAPmlmIdzDdh3KyqPEIY9DaMKHVtefLmWMAW0V/6G810mcIAZXjNESAKMJ3O0q+wfuGFF7XfnZ2N0rw7
 n4fAD+q3
 SdJQsv7ntpL7ADBRO9QC5wCl3+5NmsLE8UAI9Tg9kSnTaTnPzf8jpudXcZmAsNySQ9ZDa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since this patch requires to use newly introduced APIs in net tree, I've
been waiting for those to be ready in mm tree.  Now that mm tree has
been rebased so as to include the APIs, this patch can be merged to mm
tree.

This patch has been carried out in a separate thread so far for the
reviews [1]:

 [1] https://lore.kernel.org/all/20251119012709.35895-1-byungchul@sk.com/
---
Changes from v1:
	1. Drop the finalizing patch removing the pp fields of struct
	   page since I found that there is still code accessing a pp
	   field via struct page.  I will retry the finalizing patch
	   after resolving the issue.
---
Byungchul Park (1):
  mm: introduce a new page type for page pool in page type

 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          | 15 +++++++++--
 mm/page_alloc.c                               | 11 +++++---
 net/core/netmem_priv.h                        | 20 +++++---------
 net/core/page_pool.c                          | 18 +++++++++++--
 7 files changed, 53 insertions(+), 46 deletions(-)


base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86
-- 
2.17.1


