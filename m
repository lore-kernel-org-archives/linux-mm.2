Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F610C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 03:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F886B00A9; Mon, 29 Jun 2026 23:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF2D6B00AA; Mon, 29 Jun 2026 23:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15426B00AC; Mon, 29 Jun 2026 23:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 999026B00A9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:52:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F22BAC1B41
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:52:32 +0000 (UTC)
X-FDA: 84935206944.15.AB2AF2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7437E1A0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:52:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQscV47n;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782791551;
	b=k7ibw9nMd5WvbxnZuqboVImbPLBB3ZWp5vvuMENQihYZ5EwDaQtAO9v32jBlbNFDsq2dlN
	zerw6EMXVAHicakEkbXXON01FKHIO+oXD5QaAxJcJydza+dKWdLJas3Y9hI/LbqglmZ/q5
	gZQO5P3Qykk481S1i6Uj+6J8joUug0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782791551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oWQGO6JAGeGVOvqhfdihogE5K82vJ74Pirejh7VlOVk=;
	b=smnWojhmMrXfIfzY/5GJlqC5MotwtI6VtJ4p+d1fLj6Gs72iYP/DDEludLhJxb91l/n9wv
	OE65dhPqch9j/iz+yHfqoQvELSPRbmv5iCUGkVvzE1xcZVgx0NWjqtDj3nAffvMHjafiqN
	P2BznITOAik5SYu6hoKlLFR6Hgd4ZjA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQscV47n;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E84D560008;
	Tue, 30 Jun 2026 03:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CB1F000E9;
	Tue, 30 Jun 2026 03:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782791550;
	bh=oWQGO6JAGeGVOvqhfdihogE5K82vJ74Pirejh7VlOVk=;
	h=From:To:Cc:Subject:Date;
	b=BQscV47nr6fwdYaNNmhl0m94aO6hG1wDTviAy8/A28ojaC/br9mLIo6ifH9zaXntd
	 sRq5nbTZQUJnxrBjnWd69s2L9mMytrsXomveu8oJ7EGI50EhiTfcugqeOf/7yPm+YL
	 kP6ZeD31uorveDYQfb/POcnWvqXttsvsjbs5temCSPbjXhsD7ThZxvPkQDjyKnxO1a
	 vGVdtQgBmweOL9aYPnXhmOPEh7ZZK3uvfsshU1mgRfghhzj2BdgIy/RkPz72yjYjrN
	 JYH8oPyv5qoHwCYK5glCAS+HxMUnhcUo8DAVbDzFq5PDWgZ8Zt/GVyj+kYVxLk0O0b
	 mGS4wq/S/VNwg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: validate ranges in damon_set_regions()
Date: Mon, 29 Jun 2026 20:52:19 -0700
Message-ID: <20260630035221.146458-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hmrqewkkrdgmde8a1z4zd89ykxftw1ap
X-Rspamd-Queue-Id: 7437E1A0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782791551-102518
X-HE-Meta: U2FsdGVkX1+WsE+UC0+GRsJ+37BXfmI4zyMm0Ino8sHQH0ScmNRm7A4fervEdP9B3ArKus0LkUBBDYS/ehSR+14OOlRrxJ9aa6UyA9/QETAK16ccUqnqxC0ha9WtGD/7LtMGVU6sPQxNi1TiAFIgnTZu+KdIbmVEk6Kkwojc+cyQCMq7sJ4JkJ765DwOUXNEDVnUsFJnfMWMI2Sj6RDyxh9gn4RxsHK0tyiI+k8YfndZX6WdpCepCq9UeYNRkqVVqFjknM2rWC+yZR54aEI8CyiJ2XE6Gy173x5DRMZ628MXtLdk0hxUoiTOrYcBmlVtbC6SFSrMsrbcMCp/eWcNA0Va45lpSfWdZZE606B2BWYrKBwSb8Ys5cGCqMALZy/DRHv9Ilu937ieeJqUZAm+vImmLMoQzeKZguVhsFBgU36l314V+sd+tJ0Js2vJ/cBGA1qns/HXzS41M0IBycQkJ3AgQbqpCgXls57C4ZMB1qjH7mLc7AXCgt3Ss1tA71KvtZ1Yenlpp0YY0uZ13cC96dQqs/GFW0KiLfGhXgrxf/ac30FJ8Y3e6Doq9OXd9LqF/iPsAFKvlsMSbN87FRU3DjjG1wrRcBxQxW9Uy2tC8VRw9mi/iLKTY1MkWTUEafbApspSJ30f50aisN2GeI0ZE7nplZFFIQh0sLaX8Sz26VyJhcExJYu3B958ImhebKYDa+bZqXz70H57wy0VvzC+xfDMMfIAWIDhwmuRVnJFCtbFf7DpHDuULrLvYs5LCKYxNfVlrU/BpWa3LlcbQwphNdDyTSoe0ujb/OsgkzIN4MtOvqZCwT6CH6NdfzpYxg+NuU65lEcOij+CzQ0cDot+3tlr5LdvUsElOU+p8TvvOk9HyN0JfyU5TmE9s2Fqd9O/njzvbCVH1WIoJlxXRiEd+VBABgIKG1RA8h4CnSSm57H9cZ53kV4o0oikjoFEzkhmI7dvkH3IPOrCTAe0i58
 hxlazha7
 ruMPt+VJVjXuN3uDv7ixFB5hCe7pCwEjzLwA713lmQVSsB+ISaqcVdbCoy+Mi8gvUzB4q/oTQI2SdTwm+Prs1VGiR05rq5RaCcOMT1COv6Isr+lhRoRWs2Z171TmoPv4d0WcSz0TIbokCXWSuhaiSRCK/9tWYcqGzEuJYHaoMV/uXNC+xqIIGfT63LFQMhGHXENokA9o2splMRUpva7t4eHBMCxCh96g21Un2AnqGJYgvP+5TH5c65bIud2PQwl6nMAOji1VU2G5p2vlvIGR0M1PxeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core logic assumes zero length regions don't exist.  However, a
few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
and divide-by-zero from damon_merge_two_regions().

For example, the WANR_ONCE() can be triggered like below.

    # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
    # CONFIG_DAMON_DEBUG_SANITY=y
    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/targets/0/regions/0/start
    # echo 0 > contexts/0/targets/0/regions/0/end
    # echo commit > state
    # dmesg
    [....]
    [   73.705780] ------------[ cut here ]------------
    [   73.707552] start 0 >= end 0
    [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
    [...]

All DAMON API callers eventually use damon_set_regions() to setup the
regions.  Add the validation logic in the function.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260628165447.86217-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260628005723.28549-1-sj@kernel.org
- Use ALIGN() for end address.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260627170057.1867-1-sj@kernel.org
- Fixup the commit message for how the fix is made.
- Do the validation with min_region_sz-aligned addresses.

FYI, this fix cannot be applied as is to the commit that introduced this
class of bugs, because damon_set_regions() was introduced after the bug.
I considered making three fixes for each caller to make the backporting
on the old kernels easy.  However, the first LTS kernel having the bug
is 6.1.y, which has damon_set_regions() and all the callers are using
it.  So porting this to necessary stable kernels should be easy enough.

 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 027250e43c66f..3dd2750c2ef20 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,12 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	unsigned int i;
 	int err;
 
+	for (i = 0; i < nr_ranges; i++) {
+		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
+				ALIGN(ranges[i].end, min_region_sz))
+			return -EINVAL;
+	}
+
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
 		for (i = 0; i < nr_ranges; i++) {

base-commit: e861a804dfa410dde21e8d2d20179df9c66edd8d
-- 
2.47.3

