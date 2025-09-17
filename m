Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E7ECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8FB8E0067; Wed, 17 Sep 2025 13:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90D28E0002; Wed, 17 Sep 2025 13:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD518E0067; Wed, 17 Sep 2025 13:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA34A8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C8A7160635
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:43 +0000 (UTC)
X-FDA: 83899457166.28.3AD2970
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E57E62000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kS1MQwyX;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SV63/ilReAX92FTIhCs/PydSy+8AOlw+EtW3gi5rMQ0=;
	b=bSFvSqR+HXKlSXurt9LlqtHI0P56RGwZkJsrS2Hk3u0pzsRBBvpLuOxXKql2R0/V45FeXo
	o98IQrRMpWaeFTNPs+GhIMXWYFbNk/GvJMJvL8AVy8gdC5o7G1LEpqAZAzRzPMm2+F80CZ
	6R/UNkgJouJb62HRo7ddfRwr5J/5vr4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kS1MQwyX;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758130842; a=rsa-sha256;
	cv=none;
	b=KuUerqGIyXkl407yK2+Zi2GYp08hJPbaSwpe66TKHmeL12HxDAsrJfZcRGPmC3d65pi9/L
	yuwU2IID3HKC02/xWdzU3zWUikFUhiBcCl/xjvpwggcOK+EpqbfUlHaTpCKAQwlbZYGOJL
	zTS9M/+kv91r0Pa1LrALrMCUwEm9Pm0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 211486023C;
	Wed, 17 Sep 2025 17:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D8AC4CEE7;
	Wed, 17 Sep 2025 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758130840;
	bh=jOruTg3z11MGvKG41cspL9TY7zrdRzOtbVcIJxlzOvE=;
	h=From:To:Cc:Subject:Date:From;
	b=kS1MQwyXK7ySaTIUsclw5N1elKou9v0wFY5bhhXUVm1Ppb+EMluIWv5yDaqpDvGlT
	 /9LbI/nX0xndD+WNdENmR/l5Y+gPjyyESTsaItA/5EVRpcsUfrKv5XtxBiyaukEERO
	 InKwMtgCmTeJGlM3ExTuc5QRvEa95Bc+qmhOGdmMicogyLGKlW9gvdOGDG/seW2yLK
	 bJ3Xn5D6S9b9FPUpDxD9YohNab25q5l0hHAJwgmfEwcGJdwmSlwkHvt6SNO5ODGrjx
	 MgIQoRHBpgLTe885aJf8G/+8WDdjkRjfmPSX4uBU7YEQa9QNhZ22RXJqoY8aTREM5y
	 HmZKP7Ifjgs7w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] kho: add support for preserving vmalloc allocations
Date: Wed, 17 Sep 2025 20:40:29 +0300
Message-ID: <20250917174033.3810435-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7bmijx6dofihdrju5e3abmuxgz7qas1
X-Rspam-User: 
X-Rspamd-Queue-Id: E57E62000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758130841-331432
X-HE-Meta: U2FsdGVkX1+7TL9OT/vhNAAAPolLzBjdB5pe5hBkt22fshRCngQf/yixYjXx9reZEiUYVvHGHXc/Ul6QxxNa16qV4MMfp38irs35/Ylzf+vHA9tAJ40KHKtJ9tKDpyPqPk8jAzM1Fo7Sl4AypAyLBSpjzKc58CqwuQ3dJ+/JffXwcMvAxTQjcAzeZYfUQqcXq8AQcOynDVrdHUrcVNKMWYbjLOfj4jVGwog2QTSb/ToeSAOIMxx4rLroFL9ItFFhrYDdAHrujpr5Vg2on/04D+SrBJQXLmmZQuAz0zsRoGyz6oTu77q70nlTrUf3UAGWERtSrOi97gA5UmIyQuenocZwG2rUEuxfocV76Hhe0+Fuet2Xt1mxClR9qdIjPdVrDNxRyd7rATciVYPPkc6TJ6vrv61nDl3wGiMEtJqDVGC5TTBwQtP6SHmV9/oTayQro9lbTIp+fpnALFka8ly2fPMs/Xd/gkJcN+V7/p4XrNxrizCqR3BZO0SRmi00ecQA+n0Y+JOiJNH3hocwQpcQRvUIO7/uEiG5zGQWup1GNZW43O29dKkARzjzUYcgLSuK0eGLvw0ZkRpYYGQrPjvAGQ7ieJZnm89PlOha4XnLOFoDk7+dj6+bxw+XRfmovpkQU2q/TZf56RAbvk8LSlShEa2jjOgTIFRk94El3cP/TcoceCRl7BfHLbsNnFPkmcAmp7ZtD6Ftcx7pmhVrn0pcaK2YgRcjdN3owozMID7lxjdgIMCnpIANSeQ9K35k8lJjFmhzPMH2dPLoTzA+M/0KVosQaoaSH0niB8rrVZXNcpICKrsD7szpUF5XQ6SDgvqd9C3yvUUlUksf8sGn71IthxrSsRBp4re3I83KhHo0dcYo6Du6I7XP2x3DmI34PCTENy1Lr1Otbx53LfclwkQvSlcAuPf8eqCHsBhZw8XOu/jf6Zi1hS4doj98iDCehJb3/TxjzZYZFknj2dz9kpI
 tq6kpvUy
 e0O5oPfKG7VDjfIz5hmRca8IO2oCnQX9TcCu/pLiw69MGhwDUYsBDaVuUhadRTVWzXRPql6uB6fj2aaN12d9QNOI4GbRsazurfSbNUCE5F57dHaIFrh8yQ2Y5qTT0zDKiRhB4xXXP6adsOtIWAz7LU1h2ZsWW1yh3yIbAPSqHyGTNBGEVY7/xdd5+RyPlVnlcYdNFyGnaCFrr/V2ET51AVKJMfxXsd5SEc1k9Ut2i4dk2TSb3IeGD7ZWXJgfMgCTARN0asgTisqCNCa0jS2eunhU6YaSj45TAsCju
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v4 changes:
* rebase on mm-stable
* use 'struct kho_vmalloc' as preservation metadata instead of storing it in the first chunk
* separate KHO flags from VM_ flags
* unreserve vmalloc pages on error
* add checks for under- and overflow of preserved metadata

v3: https://lore.kernel.org/all/20250908103528.2179934-1-rppt@kernel.org
* rebase on mm-unstable

v2: https://lore.kernel.org/all/20250905131302.3595582-1-rppt@kernel.org
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  kho: check if kho is finalized in __kho_preserve_order()
  kho: replace kho_preserve_phys() with kho_preserve_pages()
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  26 ++-
 kernel/kexec_handover.c        | 324 ++++++++++++++++++++++++++++-----
 lib/test_kho.c                 |  41 +++--
 mm/memblock.c                  |   4 +-
 4 files changed, 337 insertions(+), 58 deletions(-)


base-commit: 103e90626d3a4032d22e8b09ff14600e71cda59c
--
2.50.1

