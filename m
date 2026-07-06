Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87177C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540636B00C8; Mon,  6 Jul 2026 11:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517846B00C9; Mon,  6 Jul 2026 11:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DFB6B00CB; Mon,  6 Jul 2026 11:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3998D6B00C8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98523167144
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:23 +0000 (UTC)
X-FDA: 84958773606.04.6340C60
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9385140006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPrV07dn;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352661;
	b=8Eea3KY+7ulDHQiV5jXQei0ldUw58pXDtd7E+COyNyKKopmvMpdcUZmgM4Ts654I7dZQ0w
	kMiu+xaBZovaFPwDwSZdUGXeQ8tgkOJ/DLPxGRIklHgsPARUoTmkV9t+c3MQJY+Osvjd37
	Kuy3QM/xusUxgNsXmbkh9a6djn2ctiI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPrV07dn;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3gTJIa0gE7A3vgzzgGCw1m6fPp1oaPfkLUEvDWQZVdM=;
	b=ZaXec9nU76KZ5cs3qc+70iDqYaIOTOYKHDC20dEHQDRzXXqJ1M/WMmTfv0OO4VwgPDAHXI
	d//tAwZald6XoxHgzDHQUR5bYQKSJ7Y3qhFiFt57JLzhQV6q/91L5sGTgxi9EdLMPqSjHF
	vtyJTOf15m06I1D2+WMKZ7h1Rvx+Fxg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3gTJIa0gE7A3vgzzgGCw1m6fPp1oaPfkLUEvDWQZVdM=;
	b=UPrV07dnd9x3y6cBYawAwdnIqvNV3EO1pmTKYbkzLaqo7F47bxiMbae4J55ObHQpW+uFZ8
	KQYx14cO+xR0FqMtar1+lz6fxEIl+SeCM7kXvbQiG/6UD6e8KGIau1jzLeigCkFzzLDbrI
	7BuoOUiuGLAfxMzgCFP/1NwJVqNjAHM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-ruGJw-zKP4GvEj00QaJ1EQ-1; Mon,
 06 Jul 2026 11:44:16 -0400
X-MC-Unique: ruGJw-zKP4GvEj00QaJ1EQ-1
X-Mimecast-MFC-AGG-ID: ruGJw-zKP4GvEj00QaJ1EQ_1783352648
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E8411800868;
	Mon,  6 Jul 2026 15:44:07 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EDFF195604C;
	Mon,  6 Jul 2026 15:43:56 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 0/8] mm/khugepaged: several cleanups
Date: Mon,  6 Jul 2026 09:44:47 -0600
Message-ID: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ipHzxP9LVlqpw3wsz1tbMjznM4b9TYONHP0d4-228YY_1783352648
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9385140006
X-Stat-Signature: ixzxkm4dihfztomptmjgzepr39c37efz
X-HE-Tag: 1783352661-315829
X-HE-Meta: U2FsdGVkX1+1hGahkBXq7LLyvESQxYE3wX6JmPpmYng1kV3+9tpmG/SThW2pSoFJ6ZbTUtHkntWzX+uk8JaT5uaTbIdaIjju+4E+2Qp5clB/AQSUbOyCoJp5BSsWfZuQrUBvLXsMqv4DmUpY9DGHlL6Mjhn4IaCl5Ra9JfN0ko6wZ4g+wfgdyhjZedos9V/Xxc+s/5/qrR7DPNgc6chUGkCn+JxDwbyzkxFfvROej5qqAuRGOlNciyzRQcswADkqXQZYUaGUs5ybet13yjg8XJ8qGdFVzg2tX/EJuP8sIvLP6KVX34w8bHdXQMKzLrPNkEGi0xW69hBSxQVNykYwxQBJg4ROqKCQren3ju7tRSF7Sq8T+cVmWQCOuva7iVv1NrV163Rng9XBJCpToqlinx25xPNrpPCRgX8EPneSjcBPL8SjIDwlnG+7qaE2GX3/bqcrmoE310mag8D2JGJcLHx2ifT3VKMaj+9oNyGs/71j7fCnNgj023qNAf0LG8Wc0RhtKrlX7/R2HoQSi+0kVt4v7yrAktxVYV0X4S+QV+WslzdyjMy9smKgrPr8W5wLGIQfTDXkPD4ThkvybtdkDLB/dUg9e96y2w1c9y6sbL6I5VVtZoHhHYbNoPQxGaXhOWX6N7DYPYRhDSLp2eg6wiwmUGdVmxpANRp3XT6GbuU5gkyQvbreemzZEDp3UVL2sW2OSolVsRtfMB1O2Xn8asyxZqwKOx/5dC9cEd2RcL4bcs30dXdXMY7r2Mg/v2Qk2wx8JnVUr0zZp+eviSfcQkjnfw4jtgcNoijL1AGfOVz1xQkKEqXoPtl9+xmxKZWZPp3/n2dFNd/HrdB59zKLObIZ4O/jIiL8uPYVyhMINPCLHKOrcSeoquxaYuQySXMyHHzTmKMboINoxjdU+DzRjtzA68KvZgYbYoCp2ME3I24XXWjza/AtZ5I9CfJQQ+v+opvrGgqpvgIKPUgP7dZ
 Blz4y+Sy
 ppJGXRJHfiyZDsdQXR9C9DJUwKZjkJi76ipH2J3T2jd2d63VK+a6INwXY4DDWVxrr9yRyH2W9SIiZpiwZy0HneXIEmCxW2FjpD1eiJAOj0MM3Bdn4yCMP6H7zaa4iMzRLtjtLgAZccRwRrnX/9jACdVMx66GeGj7O6yJPaJHJ7GJ68GA6Hso2t9oFqkeC0h1bVlJUae+HQ98Zghdie2xIpShGufXqxZ1zltWEMaroneT0yaATCQwhcNEMmrQRr+hUR7vKNjlxBTikVFm+tYvX9ocz8qd2SJva8IS9xeVeyCEtDDA+kh2kgAHmlEm9XMR+YU5apzWknKTFuyMI11TVGPYUyBZ+BrPqjzxQwray5Y6P4IM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes stem from a number of reviews during my khugepaged
mTHP support series [1]. Some of these are minor code cleanups, issues or
reviews that we decided to deferred to a followup series, or in the case
of the more major patch of the series, changes [2] Lance Yang attempted
while my series was in-flight and we decided to wait till later to try.

The first 3 patches introduce helper functions to increase code reuse and
readability. This includes a per-scan state clearing function, extracting
the young page check into a helper, and a count_collapse_event() function
to reduce a repetative pattern used across mTHP collapse.

The 4th patch was the byproduct of me throwing Claude at all the
comments in khugepaged verifying and looking for any outdated info.

The 5th patch is based on Lance Yang's commit series [2] trying to extract
the PTE state checking into a helper function. This required a bit of
rewriting due to differences after mTHP collapse was introduced. I also
took into account the changes requested during his patches review cycle.

The remaining 3 patches were review points during my mTHP series that we
agreed can be deferred to a later series.

Thank you to those whos reviews and work I leveraged to achieve these
cleanups.

[1] - https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/

Nico Pache (8):
  mm/khugepaged: refactor per-scan state clearing into
    collapse_control_init_scan()
  mm/khugepaged: extract young page check into collapse_is_young()
    helper
  mm/khugepaged: introduce a count_collapse_event() helper
  mm/khugepaged: fix outdated comments
  mm/khugepaged: Refactor the PTE state checks into a helper
  mm/khugepaged: unmap pte before releasing vma write lock
  mm/khugepaged: clarify a comment regarding max_ptes_none check
  mm: Documentation: clarify where the mTHP stats live

 Documentation/admin-guide/mm/transhuge.rst |   6 +-
 mm/khugepaged.c                            | 400 +++++++++++----------
 2 files changed, 216 insertions(+), 190 deletions(-)


base-commit: d148260a31fddf6d59cc0ea4980bd78ebe301a91
-- 
2.54.0


