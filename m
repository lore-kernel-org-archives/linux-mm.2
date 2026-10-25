Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161D1606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwfF9bpF
Received: by kanga.kvack.org (Postfix)
	id 3F6846B05C8; Sun, 25 Oct 2026 13:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEE66B05C9; Sun, 25 Oct 2026 13:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4836B05CA; Sun, 25 Oct 2026 13:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4216B05C8
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:47:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95DD4140562
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:47:57 +0000 (UTC)
X-FDA: 85361881794.23.15F285A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0218B40005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:47:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwfF9bpF;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umoLJmKZTlAf2lH0+QaiNGrYZlN8I8eaFHN45iIXEqE=;
	b=c97bKBvw4iyuLmr4Lie9RSN2m1bQwPUvNAw+SDKCns4ytcsVO6i2VmnN++uiPjKhHlDwbO
	S2/m3haZCrihit1sdV1ozISthc4KH85wFDwZid+9i5npu95K0hI1TakYAM1i0iDNSWebAh
	sY//k0wC/y3FwqwdqLGjaQ0Xm7GeZ78=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwfF9bpF;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950476;
	b=VIdM+AiO+/EGN+IEluhbLdW6mHXhGcaSgRxVw63dUcIYjr7BlPU1PL6FD237um4SNa+jYO
	a6QgsO3xXjd+FsroV9WO7nQdBkUXm87Z/jDc3MBWuZypj2SIkRHP+PO+/4TPYL50yqWdt/
	IBnzNr5S2KbrqrUlQ5djHkAyRv8Q47o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81636600AA;
	Sun, 25 Oct 2026 17:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076971F01825;
	Sun, 25 Oct 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792950475;
	bh=umoLJmKZTlAf2lH0+QaiNGrYZlN8I8eaFHN45iIXEqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwfF9bpF4oRYrf7S8breNvRCiE8XkSYmqI1+/LvQkoxystZZh0MvwQtj6Vk/nIonf
	 I6th8/DcipruVViu8UHTwLAXW3xnDiHsL366t7jvLnaKIlrAUcEHblTAorINeIoryG
	 s1KMtV28iqJ9WRhBmg50gEixPnMhIhl924uAx2fDRUyi9Tyq4qE5IyL1AqFV84Cz8X
	 gWsdQ5EGjixn1svyOHna+qhsq9qFPiPlINt+1dkttT7fyfG3fErWhqrisjBdPB/w6w
	 BI62ym0X6bNV2PZzEOCBYvLnw2xQfqU7UmKksyIa6RfW4O6frlip5qKGBgdQYDC+27
	 K61RhAXvh3obw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.18.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:47:47 -0700
Message-ID: <20261025174748.165405-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025172712.164385-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0218B40005
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bbppzrxog3g4iub4dg4odsciazsjmf1h
X-HE-Tag: 1792950475-321355
X-HE-Meta: U2FsdGVkX1/iVjuI8nv8ZEWDYQUiJ4flPwkEF11IlekqI2R+mMnwJN0l/+lT2LVDzXTU8bxQbHi0ArvW9aYs7BwsqJNgHT3ufdkrPhc+NOXGI7jp2qDT6gGgb47PIEh63VnCQkEUr7t1krzPHqpQCcX/KXw+UwOVOH9OwTbkMr7J9aVayHVy3xUsLmd2akVuii6fGYg/bdIpDzpQanRxLfx2vaKPAWn1QWc9DjKQI9lWnr6BJItgy7c8QklCTBiFABbPLL33bqfGyGLVtxRvy5rVtWn5CVE46GoD96laQlNwTKCeVw4Wm3shFfS0aZnbj5/Fwi0eycImkUdKNFKn7Skw9kn1VxBPidV9KO3uEEKETTGcXjl9wDipD3SjtUlUYlEHcUBl9vUTsQDE3dVneJ3Hr5k9d9nvZ9vZBMxJ7WixgJT0BGA33RBBGHjJ85vw7TTMAGJP/khudIwvATSmPY1uI5gG1Om1DuCLyEB3NpD8kSPZw5nxkJmw7owIslH4BFvQVN5JCtvbLr10iEwGwgHhSfyw3kTQTCuSCQ+6K4P+1yObYl9eIdqUQBnH4cJ14U2befwsgRhY6naShLWwLBA2E6J4dkA0NeEqfpyF2Ux5PxAxh1C/Oi4932mW7mZpPovHy9vYtfX03iERjoRcFRUG5zPMhF+u0Uo8QXCT/kEjg0XICoTuzppZcKQWR3vCbYj6GzLQgf/KFpXP1AadHKXxvR+DvCLHU8YT6jYm1miIqV6eWxcaaaQO/DEms2IhQ/diYN5Ox1aTd67SJzFeRM71GJCcH15gBL1MtOm0VsZocVzfPvT516lnhuUdCHQq4BDrftFbglurOwJmPg9eThj5tWoulxN4jS59CslvsXmd+uhGq9zvJhyOPrcfg/eMH9Ins9gymM8KCVgrp2pb3z1QlU7II0dZA0Fj1ehZ9xqNVmA3Pjz+c3t1/M1jFcBLxuNwa545KdltSKla8jO
 8Nk3GQy8
 1TfpVCWeeulCpxfIe8QZUII2UJe3XWV6KToJOA9dlM7jG07996lFvfpnHWxhcDgbw453FPREBvzNcy64u3dy1BJz9sn6Dbdh0bajqNitj1mZDOnC+5rDxTh8u8ubhEoYyXYoo8MJoLdY/6kkb3HZpxCgKXly9H5VOzd5Reb+qRNSOMPImhCKeuRxI6Y54nDep3cKjINVADeTYoQ63XUE2floIQ27ZCs+mpkGNHIA1JsWfyxJ4KUtDCaFF+o+3nV841TNYHf70JtdKDzHk1K9TJDC1mC+M9kN7gXHLohG4cDPsg53LFDxfrKybxWHjL5z84MMjgYGXk7BJp/gXkazHtMfrdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 10:27:10 -0700 SJ Park <sj@kernel.org> wrote:

> Patch series "mm/damon: move zero damos quota target_value handling to the
> core layer".
> 
> Having zero DAMOS quota target value can cause division by zero.  DAMON
> API callers are checking the target value parameters to avoid that.  It is
> easy to make mistakes in some of the multiple API callers.  Move that to
> the core layer.
> 
> Patch 1 adds the corner case handling into the core layer DAMON parameters
> validation logic.  Patches 2 and 3 remove no more needed DAMON API callers
> side handling of the corner case in DAMON_LRU_SORT and DMON_SAMPLIE_MTIER,
> respectively.
> 
> This patch (of 3):
> 
> If a DAMOS scheme has a damos_quota_goal of zero target_value,
> damos_quota_goal() could trigger division-by-zero error.  Hence each DAMON
> API callers should do the zero target_value validation.  It is easy to
> make mistakes.  Actually such bugs in DAMON_LRU_SORT and
> DAMON_SAMPLE_MTIER were found and fixed [1].
> 
> It is better to handle the corner case only once in the core layer,
> instead of multiple places in all DAMON API callers.  One straightforward
> option is using an alternative denominator for the corner case in the
> damos_quota_goal().  However, the zero target_value is meaningless.  In
> this case, the quota goal is always evaluated as achieved or
> over-achieved.  The quota will only keep being reduced.
> 
> Simply avoid using zero target_value by adding a check in the core layer
> DAMOS quota goal parameters validation/commit path,
> damos_commit_quota_goal().  Update it to return an error in the case.
> Also update its caller to propagate the error.
> 
> Notes for stable kernel porting.  The upstream commit doesn't have
> Fixes: and therefore not ported to stable kernels.  It turned out it
> fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> goals user input to DAMOS") which was merged into v6.8.  The user impact
> is a race condition that can result in divide-by-zero.  Hence backport.
> Reproducing the issue requires sysfs write permission, certain DAMON ABI
> usages that are supposed to be uncommon, and a rare race timing, though.
> The issue was discovered [2] by Sashiko as a part [3] of its bug report.
> 
> [2] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
> [3] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

On v6.18, DAMON sysfs interface calls damon_commit_ctx() for validation
purpose, for parameters commit but initial DAMON start.  Hence this patch fixes
the issue in parmeters commit but initial DAMON start.  I will post a new
version to cover the start case.


Thanks,
SJ

[...]

