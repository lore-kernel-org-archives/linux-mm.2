Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 662FFEC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929786B0088; Mon, 23 Mar 2026 05:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA7E6B0089; Mon, 23 Mar 2026 05:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0716B008A; Mon, 23 Mar 2026 05:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 708E76B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:43:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 198DE1EB7C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:43:37 +0000 (UTC)
X-FDA: 84576840474.11.360F5C9
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CDBC140005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:43:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eMlTzsX4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym4pkkY92K3/0r9PfgVLK1H3UUTu6ye1dXSd2uLPJZc=;
	b=4kV1UwXWJBLKpCze4pMMtJCTrTTco7s6FCDHcVVqB4HZkFxp4qxTb53cWwF5nsiyTNJY2m
	FQO+c3VnxmiIveEVe8kuQG+/s3setblKPLj8XUv4Xd3i7/r4fj5wMvcsAoqxnqJhC2Wf2n
	E0oN+/ZogxLuhyYexJvl25tRy16pyP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eMlTzsX4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774259015; a=rsa-sha256;
	cv=none;
	b=4jWrlDFm8s1APl1eV36BRricmCiJ3T4Nf9XHq6sdzPR7MIsuNGtZ8A2Vm9xqGeRBxLJAyk
	W0OYEFehBK4JUebuOMj02py17VQvK/13cW4W3wSIrODeoediaBQFtUv/QDVV3KB4IkZY5S
	GFEp+OzYUBn67e3DXCk5L3pB/Of8rwg=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso4975812d50.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774259014; x=1774863814; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ym4pkkY92K3/0r9PfgVLK1H3UUTu6ye1dXSd2uLPJZc=;
        b=eMlTzsX4g8aIrf6VvAzZfcjdTtH/5TxzFsJc7T+eQU41vSFT2SzYQE3iZuafqkozCV
         EpAWvamtOdC2EIk9zAn9bA6iYhDYiKLUYyUnqYU83LIj6dPFQ7xR+zf6EmJZzdGe/NS2
         Okb6HSSEAfeCFRfb+GG5lgPugQbQaEs4e0tRutVMW7eb00bAUElgJv17LPmlZQnfkspZ
         rjR5VuhzZQMdGShP0Zgei+rUIz71j9oJBRgMgUlr/lC2PeuHAXLDqOnQgSuYL+NuBR0M
         GCIxjGS5brsovNLKLx76Fmdl5+FmphDNQQE8OxOGUTVXPdAb+RVGTM8U2r2/rmYYJgbX
         pmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774259014; x=1774863814;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ym4pkkY92K3/0r9PfgVLK1H3UUTu6ye1dXSd2uLPJZc=;
        b=OP0oWMWcvb+W9XCYUh3NBtSR6bUgYNp3BNXCkQ1NovyMteTX7VvGryco/sFkbw3r1H
         76xGi3ls1zOpmTFU2sukUSpuCHbHC9BsGMwFRAj+S3o8mF658XkBv6e6Qi2S7QSEnOT1
         l+3tMEvvNjsbKW6v6FAHYeijtbniy3fCEnTwS9lovSH8ZFrjMGjm3rYDBJpKO/KWVE9k
         InA60pOkNSKYJtVxnTYrO0tV0CFF/XHc7vk+fnTUeEeq6eMgZowjfpxvq6m+46t3+qw8
         mUOKsbNI34s3K0HUwD/rgam1GtO9ndq5hxi8jWk0LBk6jNZysnfm/3IBN8/+9/LfexXK
         FfWw==
X-Forwarded-Encrypted: i=1; AJvYcCWq5BnadRmZrtYlYXhEfQUrXBrNzDRblGPLAwn6/1A7TpcylLFdgbx2Wf0vfnG6cbbgnz7OFWLtsw==@kvack.org
X-Gm-Message-State: AOJu0YxhQTpwkU7W+5a+hyT9xlOxzCdSMLbGAgNx27pPOwLHS+Iw9NpK
	8rGPp5GxYMmFERw7Sekfh9G6+aUPnXH0THI0cyJhiga8Lwumutt7yHmN2JCozVEKow==
X-Gm-Gg: ATEYQzzWC7aEuZG8Mmy4UcKPC/vOvhu8Q8ICPm31b4P+QBfztT7SPqujB+Mjh+ZkVz8
	OUoDZIzanSAN2avDp+5OdQ3iJPvC5hhDISjuC0BbSGh0LJTiPWWb0sNNl5dGjf4SNBVj4NIq1BS
	FQfD1ivTnfhaZRZmfWmZqkZvb3DUZagwt826kscp51UojjE6SIhDjRFC5N1bnKmwMtMeFRoB3ff
	eA3M5BKezuPZfRrmGWMVVajajLoEJ9iLU9hkqKha+1luV3EdgEJaMFV+YFEqwOr8Vxa7My+nMzT
	07EhWXArzd2AO8q0Ja/tmylejwMVsgSXYLS/bj7Jp7RFu2cEIeRA685ogC1N3bMcipBq0H6NLWj
	UKloA4jpTQg3xH4cuwu6W6jyOB6373V3rKNrkz3vqDPzJXijIrp1FW4MwSo+fsANWXymZa5APcr
	AodLWh7kJVcpbhXNsy32RF0QDiNpfw9ComohP8m/YIxAN2oCfjixVKy2Mx0bAf4LFBrctIOBHKG
	YB3Aoc9HKk=
X-Received: by 2002:a05:690e:e23:b0:64e:a30f:e67e with SMTP id 956f58d0204a3-64eaa833f62mr8891182d50.67.1774259013998;
        Mon, 23 Mar 2026 02:43:33 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabe9fda4sm5926373d50.16.2026.03.23.02.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:43:33 -0700 (PDT)
Date: Mon, 23 Mar 2026 02:43:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
    Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
    Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
    Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 6.12.y 4/4] mm/shmem, swap: avoid redundant Xarray lookup
 during swapin
In-Reply-To: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
Message-ID: <ebffe1a4-f575-8a38-2584-70cbfeda6913@google.com>
References: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CDBC140005
X-Stat-Signature: x5h6tie43jz75n3h8ara958y59egt3im
X-Rspam-User: 
X-HE-Tag: 1774259015-727771
X-HE-Meta: U2FsdGVkX18EYpSKpWt4Jw3Ha+4h+hphJq32bulKEAj83GaTM5ma+NU0QtrbdVYQ9tj8J/A2/6VWfYFsxq0h9QjstrvdsowlgE2nAntC5ZkdwBYMX0Vo5RjnWuTks6BDmoI8KRh9aEKkzZxj8Er+YPwvjMc9gGM/v5XR8mYfuf/dNmOalpqSDwQqskLbBs7/Ul9QMPU+XOAz3auGvXo8estRoxpHgiSS/BZ1ZhWyyFvwNbiVvWoejYbgPdLICIDjJvgd2+uhVVdbhoh1TsXjYxJA/NKbF19ek5h1jOS27zFRdOlASHdpsdSBuvuMTS9fKZXuDABUiWyStznAx5p5FtdssAwEDDLi32qA7+D0SwwpksNTO/o5WI+HmXFA8G1/Kq0uKTSXxi51b2Z9DhgBXjUZJHiHvj2F0kK0Xf4g0W7nKuofWPsAp6dcCTuTTBEbSWeoE2BfpaDOAQgPOA9NMsr8e3o9U5ECcICYLrWF3zpuobZoEOBT6NeZ6N4VU0IM0SQEyHSBzoj2pai5HLia9Vsf6Pg2ZQJYWusGATn+RAec1zcU1d7hoElNQLeXvZhkt0RQenMbW/hLVbsO8hh1kBE6LBhaR0r5npeRqaUTUEwLUqqyAtkQXPEHpv7sLMYSDx3fPQWDOHhZkYiPIIklqqixteA0tMKC5YtMiKsp2bA1KXVhx9yqwhJwrvA49Nbfc3jLqOv/vwFrOLecAfj9BSw4Mnpf5H3/+tvw85f+uyuhSuLEcPAg1R9wo+JS/kl2QtKmtZ8OUChYouMUg+WBurDzqAou6YnbhlZg9on4DoapWQGp/KTFGjjOF/mRAK4aAv8osj1FeuWciomKXB+Rwl3p46zwUJE8lEjLybYsbWAskgZtzhUtZGP29OUi90+d+n4G+hxD78kJ2d+vrOIG5G+WxHuW0CTbfP1mJdTifMhnNUJNemaxgOcKI/2156e3U+frEEHVcinRhrE27xg
 67LgU+3u
 vjCFN5FM6e7e2Qiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit 0cfc0e7e3d062b93e9eec6828de000981cdfb152 upstream.

Currently shmem calls xa_get_order to get the swap radix entry order,
requiring a full tree walk.  This can be easily combined with the swap
entry value checking (shmem_confirm_swap) to avoid the duplicated lookup
and abort early if the entry is gone already.  Which should improve the
performance.

Link: https://lkml.kernel.org/r/20250728075306.12704-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250728075306.12704-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Stable-dep-of: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
[ hughd: removed series cover letter and skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1b95e8e7d68d..c92af39eebdd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -499,15 +499,27 @@ static int shmem_replace_entry(struct address_space *mapping,
 
 /*
  * Sometimes, before we decide whether to proceed or to fail, we must check
- * that an entry was not already brought back from swap by a racing thread.
+ * that an entry was not already brought back or split by a racing thread.
  *
  * Checking folio is not enough: by the time a swapcache folio is locked, it
  * might be reused, and again be swapcache, using the same swap as before.
+ * Returns the swap entry's order if it still presents, else returns -1.
  */
-static bool shmem_confirm_swap(struct address_space *mapping,
-			       pgoff_t index, swp_entry_t swap)
+static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
+			      swp_entry_t swap)
 {
-	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
+	XA_STATE(xas, &mapping->i_pages, index);
+	int ret = -1;
+	void *entry;
+
+	rcu_read_lock();
+	do {
+		entry = xas_load(&xas);
+		if (entry == swp_to_radix_entry(swap))
+			ret = xas_get_order(&xas);
+	} while (xas_retry(&xas, entry));
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -2155,16 +2167,20 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		return -EIO;
 
 	si = get_swap_device(swap);
-	if (!si) {
-		if (!shmem_confirm_swap(mapping, index, swap))
+	order = shmem_confirm_swap(mapping, index, swap);
+	if (unlikely(!si)) {
+		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
+	if (unlikely(order < 0)) {
+		put_swap_device(si);
+		return -EEXIST;
+	}
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
-	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
 
 		/* Or update major stats only when swapin succeeds?? */
@@ -2241,7 +2257,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0 ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
@@ -2284,7 +2300,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	*foliop = folio;
 	return 0;
 failed:
-	if (!shmem_confirm_swap(mapping, index, swap))
+	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);

