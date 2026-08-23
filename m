Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E9DC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 04:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22506B009B; Sun, 23 Aug 2026 00:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD8D6B009D; Sun, 23 Aug 2026 00:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0726B009F; Sun, 23 Aug 2026 00:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB2AD6B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 00:41:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3846F8010F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:58 +0000 (UTC)
X-FDA: 85131286716.02.A0FE5B3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 92AF940003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qL+mRUkN;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787460116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3FC+5LkKgW9DQ6XDvWK2qzYuWUPRLe6fZlHSmj1ibl8=;
	b=bjO5asMICRj0lcb6re76RmtY9HuVsJMGPDueesr7V8kQpn5j706r0kyG3v//z4/vhXasYN
	CoA6TfPwwklo48WEgM3QdQbaltI36EzvBJG14KiKxzglF2MFgm2sVANb9uD5ODt0lbtMZt
	rr/RPNZN4r1pHPWyxQvRS0w7uekkRJE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qL+mRUkN;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787460116;
	b=hPvRjOmok3efopzGilDtOoqEtA4/XdkueOMG13MgDZ1eTI6L6riLyUQ5CE6yzuwguf1CJQ
	ni9Bc5Uyg9FzhatgEC4EfjBBL5qhay4qYs8ytzi6BhgJwDblVKnjgYWYs5F87/HK7kuVju
	FstITOdt3s8xt/iLPL5rrj/cDJyeiq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3F
	C+5LkKgW9DQ6XDvWK2qzYuWUPRLe6fZlHSmj1ibl8=; b=qL+mRUkNDLvr7KtHYi
	n0sAUNTwpYcnIol/vpWCQeF6zl++LFa/zsyDxJbGCx8wZZiYc4dj/OOJ84hSA3bd
	+xgRLvEUJwe4SqHOHWzKlnak5SiHSEHj9yJ8WuKsomd4+riktNxYOIVqSs1TOA0f
	WOuQpNhrmGm1HwUceIoc3r6Yo=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAXH8z4eYpqyqI1Qw--.15058S2;
	Sun, 23 Aug 2026 12:41:30 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: mike.kravetz@oracle.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2 0/2] mm/hugetlb: dissolve gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:50 +0800
Message-ID: <20260823044118.1097121-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXH8z4eYpqyqI1Qw--.15058S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw4xCrykZFy5uw4DKw1rZwb_yoW8Ww4DpF
	WUWFs0grZ0qa4Ikrs3JrWxGr98JrZ5A34Uta4fJw1DZFZxAasrKryvqF40gayYywn3GF4Y
	vFs0g39xWa18ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjuWLUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Bza02qKefydrgAA37
X-Rspam-User: 
X-Stat-Signature: j38fen6tnff1iq6yj35cmnris4o3fwqm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92AF940003
X-HE-Tag: 1787460115-987316
X-HE-Meta: U2FsdGVkX1+c2H6HGuKMNu1dnDenjTCT1J5dpaSyIIxyrdc75ddYoezq8TKci0Vt4meejZ0ddxJFaUxO64Ex75AW4dv5jZc8HflgwT5JULXroJZ0v4rctZ1TYJcm69NtZbfXkXaKgMdo83qw7EhfAO3EqYi7x7I4Qelj0+xSQJFGXp3NwYY17zbi8STui7kVLhQuq1gnWTzSuE5CJptF7tgEf2NqMdMDWRQAi/49TTxkjJqywQ8OumkjTgI8uOa2B2j59yn5H2w2a4RWWIIILq7cZ8akK6Fbvr/XV2Smz2xnGiFIJ5eKaUXSCt8w82W2jB/WoKh1soCAZROP+B6VViSv8Q3cYE0C2crYZbx/ag7rBaRVi+ay9NNB18S4dMTg4M1lkg0vdopf7aOkYy4KHbkW0oF4lQIJcJcQqOBpmR6tmyXQTdLOi3SiT5pflJP6FlWyNUG/opjWY+++O5cv6G9MbEGmW0xuVPyNTE/h7f7jGnZ8nS4pATobKNyGx3E/DGjl7hAuzgSD/+ccwL5t9dvTuiNMbLV4/3oVJeBb6mLpSjdOb/zmIJFrD/dK3OxKti6kmlh3tkfGSsdGgVhzNqlYINxQqIYM6S5AySRds1aCZyAlYr+Nl85yVgydofFxbBoD3Q04QGtCKinSPMPkSeh9nVvcZMamnAVoFs3HWjpzIYlU/LhYH4vMrStaXwgD5Xu4x3I8COnHPYEQlaPb1zprNhrhpEz5BodslDexmg+VFjkbxbM7ANFdA5AR8P82r7fjQt4H/pkiWb0ib32uEvcSdVLkoWhrFKGT/133LkN1rUakzS1w+I0xtNZUMOP93keO3MLAibkHBn0ZWvq3OEudCDqdYGXbotBhdIWEvtcyTa9lh8r/vQsEng4q94EMi19uVtkcqCXZbzLS8hsvujrbOgtqodMUBUspGETjXf4OxGo1i2im7ED20JEGKIeX9KumeJUvWYbyeumUi7z
 WF5wWKqr
 WjUS6XiPWbqR+xHOAmxf/wSd2M9qf8gq4d+/RPlt9J3wSNuJWNwK5Q9FnRdJqcfAAc5kb5nN0z23TekwSo8MbmcixrbkZPXp/5BODAeaYlx1mgbGXmyNpIkRCN6ZTKsdCDQwIZjIYM++dWo5glbiIf1LKgMdKSZ+jUcniIrOL3pZjrNox2wGk7rN7ObsbCaLdf9VVzljp2fztFia9hNypF2M+IzYp/2bWPxVwpptmONlKNYVtloq8cn4JQAhV5GYiHqLb73+GUbEMhlCItwOEhqVWQDRZvA8m1CwfIcjQaLeAAT5C6RAAmvdaYu0zoywIEawae7/ByMq6vOy2VbYzceiKWmqChGssLNMD3t2Jz2a5bpJW+tGpKFor6V+5sZSPJkwX4hiVZbHs1hkMr6M4FWHorzn3IWocG7vqmaTUimzPxiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

v2 of the dissolve fix. It now carries the cleanup David asked for as a
separate patch, and is split so the minimal bug fix can go to -stable on
its own.

  1/2 - mm/hugetlb: do not dissolve gigantic pages without runtime support
        dissolve_free_hugetlb_folio() doesn't check
        hstate_is_gigantic_no_runtime(h); the helpers bail for such
        hstates, so dissolving leaves the folio on the free list and the
        add_hugetlb_folio() rollback on vmemmap restore failure corrupts
        that list. Bail out before touching the accounting. (Fixes,
        -stable candidate.)

  2/2 - mm/hugetlb: warn instead of silently bailing gigantic pages
        without runtime support
        Per David's review: turn the silent bail in
        remove_hugetlb_folio()/__update_and_free_hugetlb_folio() into a
        VM_WARN_ON_ONCE. All callers already filter
        gigantic_no_runtime upstream. (no Fixes, -next only.)

Changes in v2 (vs the single v1 patch):
  - Split into [1/2] bug fix and [2/2] cleanup so the fix stays minimal
    for -stable and the diagnostic cleanup is -next only.
  - [2/2] is new, per David's review ("VM_WARN_ON() instead of handling
    it silently").
  - [1/2] differs from v1 only by a comment reword.

Link: https://lore.kernel.org/r/20260817162039.1511838-1-xialonglong2025@163.com
Link: https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@163.com

Longlong Xia (2):
  mm/hugetlb: do not dissolve gigantic pages without runtime support
  mm/hugetlb: warn instead of silently bailing gigantic pages without
    runtime support

 mm/hugetlb.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

-- 
2.43.0


