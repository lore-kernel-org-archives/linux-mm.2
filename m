Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D252606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1Nz+8cR
Received: by kanga.kvack.org (Postfix)
	id 3E5876B05D6; Thu, 19 Nov 2026 03:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F456B05D7; Thu, 19 Nov 2026 03:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5976B05D8; Thu, 19 Nov 2026 03:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03E266B05D6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:52:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 860A414098E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:38 +0000 (UTC)
X-FDA: 85451252796.11.6811374
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1DEB180009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1Nz+8cR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795078356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IPndn90TrWiuxkQkUrYep5mzt6mXRFlXBfoASzSRQGU=;
	b=bq37H4yPLp3Wgotr5p8sgjtTlwosxQ6wFYvoa8qjXWY4o0CfJ/qA6TiXLTzTZAOEXV0qda
	XFP5wLtKcHEjyATIsAH5MEF7uSghviYK1nSlHKRCYf3G088GMaj2GTdjROaTnylTqY0EXk
	DvfyRn+ljkeu9B42COYdlUrEDfMYzEY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1Nz+8cR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795078356;
	b=3uNw4jfJbabBCepld+BvgNJykUNYpFVdO0LMP4kkAUJ6o5yxHgl9CAIhTfMRIAIzDahBDY
	yUicF9JezEAPLYHUl5vX2AU1TZs6xeM3vigoATk8VzTmXpKIehn0Y9oVsPZnblGj3LWw6t
	tEnf88kx4qXaxYLnrRni9QhrEu94fII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1E7247817;
	Thu, 19 Nov 2026 08:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE001F000C4;
	Thu, 19 Nov 2026 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078355;
	bh=IPndn90TrWiuxkQkUrYep5mzt6mXRFlXBfoASzSRQGU=;
	h=From:Subject:Date:To:Cc;
	b=j1Nz+8cR0jTce7Lp+aDCmO2fQowwUJsL1pf8Qlim9IPCU5cSF9GJDtXCEhrOFoGx2
	 j1QZyZsXieQmfRHnwmre7bjUH7/mRoJWdXGYPmuzoqjhjHQ8IAw+g+NuVicE2HsgsB
	 MarSJWRIFV4o2pte5enKAV5QrizPpKEtCcykq1M/0xJzL/o7pa/5q0UfOKHnBEf9hT
	 aSExsypAUGBR7OTzqNq/MTVjl8laEYCAtfG8gQldsH2vBoHIUgpCUDGqUOHhVJDxXw
	 XWNtIvzvxLXYauMlcTju6j4Pd4tVD3f1FC6xCWgGn4ExBG+beaCsHId1qfl/r+ADwa
	 g5MYsDz4abbTA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/3] alloc_tag: two fixes and one cleanup
Date: Thu, 19 Nov 2026 09:52:19 +0100
Message-Id: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXM0QqCQBAF0F8Z7rMLzoZa+ysRsU2zOiEauxaB+
 O9SPZ6Xs6JoNi0ItCLr24rNEwJxRZAhTr06uyMQfO1bZj65OI6zXJfYu6Y7+DZxEjk2qAjPrMk
 +v+t8+bu8bg+V5Rtg23ZSZGd0bQAAAA==
X-Change-ID: 20261119-alloc_tag-57326f1fcc85
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=david@kernel.org;
 h=from:subject:message-id; bh=pTjq0ySpnKkGB96QfwvsYQaekk2YVWDvbC/xe0dtpSY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+7TjhMY9nipNo7srX+5Ov2c6RiDDZepnxXTnjF+20/
 272P6KVOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIgivD/3LRO8tiHh63iFpa
 efzgHrGD6Qc/KWn6v3vsW1grnVt37hwjQ9euXI8qntVm5sfbdpZvbn+UXH+7InVl2zQHP6fPk6e
 JMQEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: jqgke8to7nu4tfjmigoj17gphcufkgsd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1DEB180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795078356-198287
X-HE-Meta: U2FsdGVkX1922NW+43lJ/GFc0dh7IMiAmmTECLZ/Ts1O2AMTrNaRh1AeID6InzKdCzjYrokwTXVIPT9Fm5AJwVQI3DjxB+OfmoyC+ajmhDMUi+DwoBpN2sPOsAJ0EWdwCvLLOF+YLEx+SiKHNE2Qj0qwkUo5l7raS66nA54awgBSBHUfObI4bvKZtEOb8qtKDJQx0L30WwzpI71GuNWz/T5eGGeWxUAqL+BEVnw88SQHxB4qOWW4b9DpxxKDh7q/sAN4bfFw5A5YbK9L7s38WBzhZolmPZUyufr1q0LuVgwgKZtZs+rnmfhYHyhK85gaJb3JJGXvfYj2QFj9bghq2C2tKlqdVz4dSFbb/mw7YGoVMX2WHxQg5O5DhakFNFHH6tAWpJmqXPrk6uJ1nqw5lKc1Segb00Al1iOrVlGPZZQiemWJ4NFHq/cI5iVZMnQtE5AGxwqjd4zgG8O1+J//uWc54+/SF+Gam7ceN+xGFhYpcO8iepcqVDzTsCX4k3+TJUMxd7+2UKuJAxGR8sHWAA4y+F8OEzxVK6PRNrl9frdagQoxM5+ROvz4Dh19dQhgA8huUQNPF64Dg2xh/IhiFDu6NoIhnh3pptVPYsjktKu9Wd1SJeN32/yD02/Sz5ndZOiQ84yTwsVYgwr4aFQdPogvIkox1ZPNGDNU+7xXzvr7hns1XeZJrpwkNm2Gb0t9riR054wRAB07wez6E41lFhB99uAwhTbMgcI2FvH7k8Nd2m0bjjf/mwmx5KxydVRhxYlKtApR5PsWSFHSu/P9Tcmg6EXI0scMRu4hMwThyHnufSsmN1srwds8flMSd3fXoSDZ+NM2aR5ILDu29hBqT1sfs6whNxlaSDOItDJvaE7GZtWHNqB9Hof6AyR1miJ6TqDY3dAAWcmjmxfltEdGh77LxbZsj/30hdQu/pBDdZxLSB4MSYW7fvCGRbjNvIR07vmWeffJKgOHC9/tJcv
 L8t3PP9s
 vB+ELKkkX8FIcnGf5UnLNuEwfn6p2kziYCYrXZ3j358IhJ9orqc3sMEyV3i0ib1Oi6KnCFlOwF1SoY/9Ix+6+ePlZYvH8MFggPfIrkJv2aHFCMqeOEd5Wt0GHjcqFPgpdN/HcRfJ44PR/KC8U97BL1b2lXkEg3PLE4fnmxDVdyNB84bk1pqaxsfPfGvFYxnoyiupK7v6yS0QcJAfFXv2t6ak6yC56+1gD+3BRy/pIFn2/BcII2aQJCxt8sewyTVap3b4ReDI31WTx2nqZwRIfg1pAG0KnmhZ6r0VyX/MIRmy+1lgO57o/IbzZ6fiE4wj1kp5g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

two fixes (one for alloc_tag as triggered by slab, one for mempool) and
one related cleanup to make things consistent.

Quickly reproduced and tested the warnings in a x86-64 VM.

This should go through Andrew's tree. No need to rush, it can wait until
the next merge window.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Chris Mason (1):
      mempool: fix missing alloc tagging in mempool_resize()

David Hildenbrand (Arm) (2):
      alloc_tag: handle a NULL tag in alloc_tag_set_inaccurate()
      mempool: account the element array to the caller

 include/linux/alloc_tag.h |  3 ++-
 include/linux/mempool.h   |  7 +++----
 mm/mempool.c              | 23 ++++++++++++-----------
 mm/page_alloc.c           |  3 +--
 4 files changed, 18 insertions(+), 18 deletions(-)
---
base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
change-id: 20261119-alloc_tag-57326f1fcc85

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


