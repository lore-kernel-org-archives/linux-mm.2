Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C00D2ECF4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97576B02EC; Mon, 19 Jan 2026 17:07:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F666B02EE; Mon, 19 Jan 2026 17:07:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AE66B02F0; Mon, 19 Jan 2026 17:07:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 982026B02EC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:07:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BF851602B5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:16 +0000 (UTC)
X-FDA: 84350100072.16.CACFC0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B224D40003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOhwtFAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768860434; a=rsa-sha256;
	cv=none;
	b=K1dYuQ1lktP7Lyn4DZaYe8OHV6SzZRepCmrdw4tokqkf6NICveh0TuOJHt+UC9CbOqHhk3
	IpBXu6Jm/C18O9wIuYM441+s272UDB8IJnaCnLPFKTpcfBS0Q9o9kSa3PpmDeBwtqG93ja
	j7V/i75IJW/K2j/Mk/qciwZPW3v+WSk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOhwtFAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768860434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ufBhmdN5EXr/F7HFeVmA+925c4ZDH+xqv0jcUl2qSI4=;
	b=sxM/aTv6QLt0P08oeew+ve3+2v6CV/NtoA0rJLiMSzFwZdtQxwKt9AmIRukKtJalwpDspB
	GzNFHhxT5MSh6QY+eUYQb+ymNfKVzRD5dZ4FvOdA0cv2ySI9HjqycbR5gDLhw/6XVFBrmR
	CTEWs0OaAP4iPqcR3Tco8pafhTcC/Lc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE6242DE0;
	Mon, 19 Jan 2026 22:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD485C116C6;
	Mon, 19 Jan 2026 22:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768860433;
	bh=ffwUQ2dX0j1vnxo5x3DL7cxif+25Tjw6PTCwljgcdm8=;
	h=From:To:Cc:Subject:Date:From;
	b=GOhwtFAVEByAuyqu4Ph6mSogb5CgpRDYq970xpH7qzM/gCFJiJkDcSe/P94Kn1N+2
	 8JrAunOHx7lFx7U5tOlDYGK2kreaAZmm00mHhb/aIk7FCIhBPIxMK4d7QoUIsQNYgm
	 yIVfDVlnZArecwu7MlGsXhSbespkyQSsID7MUSnuF6DR93D2du6glQNpxCuPdnSIMj
	 qEAxK1WNCcVWFkMIexp+nXwo3bmfyKSRhVGDOghuCnB9rhBW9ahU9TMLlOusMVz2uC
	 Ce482pBKQzbAExqvK+nwfNFswtmYVzI2DW/Q+8Zlx6sAGhnudF2GNY4beucubiSPls
	 2uHWOVDJEPQ+Q==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH v1 0/2] mm: move pte table reclaim code to memory.c
Date: Mon, 19 Jan 2026 23:07:06 +0100
Message-ID: <20260119220708.3438514-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xcr6979gm69ae9msbh4bdg4yyyq9ggfx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B224D40003
X-HE-Tag: 1768860434-748098
X-HE-Meta: U2FsdGVkX1/aAwqRxkUuH2aTVQD29/+QKGP0qthsyIgv0FZIHV9FcLwb2UkjN7h5GCLUNM2uWkkFwzEO2NxUK5XoOF8UEoCisNNPA/tOP2ycjLwy8S5EahemzSgrGDTAuByItofQZRODUdOuggEZDbqWKkdP8C3PMg+qq/FQ9LgKHeIk9XuOcTPx6nP/z86tLo9xdor2G6BaTeYj+ArWvXUCLRiHH6Kr3k2XPueG0fL78wTKVNtVSlpWcsOpaWIMlYGWgMUOY+WUZgn7iXUA7KS8aaJN1nBOALtvgEL49k7C3BogMMpuU3yzrNnGOSdd/trdigBimcxU+q4+ht9AYvsWWaDJHOQO9SZB86Ivh/LhG2BUyCI9H53uBvdtlQs5SNbGi/KIYBf6LmyBWRPMEjqPxmcJLPB9B/jY0w9GN+yIntrSGkQAxeRUqUISDnczvVnDif9OpIsCdi/zgL+HW/3CXug9zd8DtXTzgGDxmYbF+VEEP3VOY2Fcyhcxwa6cTSlcgXowKXQY6JXEBdJ3ZrB3lfuVMkybOdK/fXpcN4qMNrtbKErbLCweSXr/n+MTcvX5DszNzoXaC7frIrFZ9Hv6aBYYDLG2KmQHh6vQI/OBnI0AdoKfOn2aTsMryeO5mUBm2nHXCHQU50uTvj2VcD5g77F6fl5nj47HcLZOI9wcv6RLviAphkWZYQ/8nCPZo9kOCeStpEx7Lruw5wPY2p6IiXryy/B0AMZRZnvDD2eSIZma1l/+MLjzbZdGg2o2jCcckGD1R2tEDSxcB0gHhFqeljjZhwwIWxYkaUE8xCDbbeuy0FLg61xSFVQ3CjlVY5ETnoXwKHMgCkzmdotW8VUpSxrAOALUKXH0duk4gvqJU019585NICcYlrpJ28h4QzBM1v4PLUosfTbQ4DDgpa2ATeQP4AfblsOAnfVOe7/rEXKyCWEJXMr2zcjIhjvRUF3BUPDjvav0qDyKYau
 Ulp5F89g
 1qwxoKOKjHhDOHf7/urwC0wGxD/N7qQ0gGQgzMRkRveGIEPNpZ0U0bh719mzGPqQyTDfziBa3VsgV83XaPid4ssIYkvfeL7BIiyotXZYs5qEz+oa9QS597PyxFq+CyunptMiSn9t6VnZbmUD7A8wB816Sf5KeAAYxhWXkc44dSG3KCVaRGzKS4bDCaKfEUGx6fx+EpJ7mnrD5thqSK022uJjWlYeudqSHvYMnekLhXVrWCpVCGrFFQ7OzzZO+e2e9GIxksNMhsI7Z58S0wwDURNuvil86JX/AAnk9IZUxjL1s6MiwDMfVpGBkS6i3ATblnqleoJG/1IVVzkC8uS1yvAeek38+G7dRYF8NH6ItbXX3iXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some cleanups for PT table reclaim code, triggered by a false-positive
warning we might start to see soon after we unlocked pt-reclaim on
architectures besides x86-64.

Cross compiled on plenty of architectures, tested on x86-64 with
a simple test case that allocates plenty of page tables in a sparse
memory area to see if they will get reclaimed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>

David Hildenbrand (Red Hat) (2):
  mm: move pte table reclaim code to memory.c
  mm/memory: handle non-split locks correctly in zap_empty_pte_table()

 MAINTAINERS     |  1 -
 mm/Makefile     |  1 -
 mm/internal.h   | 18 -------------
 mm/memory.c     | 70 ++++++++++++++++++++++++++++++++++++++++++-----
 mm/pt_reclaim.c | 72 -------------------------------------------------
 5 files changed, 64 insertions(+), 98 deletions(-)
 delete mode 100644 mm/pt_reclaim.c


base-commit: ac1303686c1e823c9c88b20c5f8587629ad94a11
-- 
2.52.0


