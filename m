Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28A2606D810
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVp1FVJ+
Received: by kanga.kvack.org (Postfix)
	id B34856B05B2; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A346B05B3; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC036B05B5; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 707F26B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED3681A057D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:00:53 +0000 (UTC)
X-FDA: 85395027186.05.B100495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D14D3180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:00:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVp1FVJ+;
	spf=pass (imf16.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793739651;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9oswV/x8AC97gVAw4TBoRfYdc+Ee5b9SxqFobWwGr0c=;
	b=xEh84BCBngXVr3qMiSxJmOBYeSsp4ft16RJcYAG/xiPibTFFqLK5l6sQeyj7rbUm67Ptxu
	yhPjreWrBzy81dSuMnCkSPZ4NEStRHmZKKkl0iLX+1dvbnjqhVTHFyTlaLNP1/gQcXBDLo
	HB5ebyEmUpiBBS6ZhBMnljrtSFQPjB0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVp1FVJ+;
	spf=pass (imf16.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793739651;
	b=cnEv5YCS0fkd59nkfZ6N7j1vfWaxTNz+MSabMtyrtsta2K8ZsRL7pW0PRnLB0yEBW77G6+
	4bM8T/Aw01EBp8TkOhkaP1poxO1IoT52bWCIh25KuDWgbdUOWbVC0o1+TbYdmYRRM/Eu3K
	KYIIAPk7J8C3YpPMOZJhzjSnsgXLqFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0401943E5F;
	Tue,  3 Nov 2026 21:00:51 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793739650;
	b=l+GMeip7AzakIpGW9XRgXcJmFcwzdPNQHux2TlWf03ZfaKikTYJfptquNkYLfcmRDVM5
	 nQcQ1i+YOweDLGagMcWyj6DVy1zJ/AGzIEdX1/tL07hJ2IqS2p89JEbTq7rtMurhvFbx+
	 Gw3ctFovcD+TYGbnHo7Nl4wGtRkgeqNByPUQ1v3aQB3sKCFPlOCwmfhP6s94nQS56ymFP
	 wLIVj+5JJ9txX6S7QEczty5Cm4FSRQy4vfeDabLSjHQp9F7tSc2oAvmSDsxtkDS5ttrn5
	 VDNXTJk3Y+Kcj6lKXGsRacTwTQMZT7wbLS+mMnPjDHU1Id5L4t8SZZW/qiEG+iWtdQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793739650;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=9oswV/x8AC97gVAw4TBoRfYdc+Ee5b9SxqFobWwGr0c=;
	b=oxR9pCeuW/GqFz1nprBHU6hF0AVP7qqUV5ciiSjbN7Ee7ErXm4we3QT9wZv2qauKE9lg
	 J9qFZ1XATWTecy/l0V8Mh5xM/9DQDAoIS9u7tvb/z00ulzu9yfxBAlbvWj29Xb8jlBcZC
	 MMwajCcaQ9tDA/2gM5EVeoD94RRSUlXrR4QQlqqxsbOXDvjtVxh5tY3yzxwR28D9DwI37
	 TDFsXdZHTQSNFqweGH/1RfmRxFFReN/LzVLY15c0vwyISIPHYSbhnJuZUSOk3FjW9suIu
	 1V0e/DyBQ28ifo5+MFoxhKw8utEK0p0rhIsHRikwmxHSeMbjH4Wwp2irt+dhEVyN0Hw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EEC311F00919;
	Tue,  3 Nov 2026 21:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793739650;
	bh=9oswV/x8AC97gVAw4TBoRfYdc+Ee5b9SxqFobWwGr0c=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=eVp1FVJ+Q+U60/uo1p9l0XhIVu5tglyLz1hnR9ZRI0mlrnLn97HsE4Ryqlh0XtxOy
	 pVNEog5k0+bMURcQJpk7zU5NWfTqre35n9jFfPuqtOo8NavQOs/cLAweXHnId5U82v
	 NMI7lqB7mjS6Let/hQOqdO7VXyhewE/PllCjZ1sdTDCp4IJw/J7/9gpzQAddnRbejS
	 9iY70cKRV06to/ygawjDgRJiL22aKTDjcP6lr6+CsRk1i2vly2E991Ub573xcEIF0+
	 kV5O1DEr8wZm2ARGxo+dFPl+RF49xtOYTok4D8Iu4zP/pJ4KDaZuNtP/1rMJloF/sn
	 IG15SFCge70wA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4AD1546B1D;
	Tue,  3 Nov 2026 21:00:49 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Subject: [PATCH v2 0/2] mm/hugetlb: clear the hugetlb flag before leaking a
 hwpoisoned folio
Date: Tue, 03 Nov 2026 16:00:48 -0500
Message-Id: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNSw6CMBRFt0I69pl++MUR+zAMaHnSp0hJS1FD2
 LuAC3B4knPPXVhATxjYJVmYx5kCuWEDeUqYsc3QIVC7MZNc5oLLEmzscOo12NfoKLgBemweoMt
 WpanKRSoU27ajxxu9j+61/nGI+o5m2mO7YSlMzn+O41ns3r+PWYCAojCY5ZzLTKrKuD4+NTVnb
 COr13X9AjoMILHPAAAA
X-Change-ID: 20261028-hugetlb-hwpoison-leak-b8d344361413
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
 Zi Yan <ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, 
 Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793739649; l=1890;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=Pt9krYX8CsGOTLKtcfpUYXNuinBo/7tPW4KlvXKyiEA=;
 b=02MqQBVkEqAHUZSGVcKHoKLwHhvp4MXoLv73o/U6clby1qlWMLDJX7szSHzPoTqqIJrGoAfBq
 CFQP0xoTxDpAE+YMJFHC0wllKhbMVCv/tSdEtxCu8bk2Xkz7dRP9VIg
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
X-Stat-Signature: dz3yd1zpzm6qwq3ydktjaf7ckncz5yp3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D14D3180003
X-HE-Tag: 1793739651-538064
X-HE-Meta: U2FsdGVkX1/g3AUjlxU6B/S0RXmcqe7nm21qaxzLjXJDwkT1dwHsT9fkUBYmm+hgUi8wp+eTyC0fujsRCZEnR9uQ1fxdQdC9eEhPq+dQdfq6N+HW4mG4H+7uo6Vqwx8o6imXZUfmLhnjNm3eHVXbmWdgNX6HqN7XHrGiE4QH74dL8lj+r/7RyIKQja0Wpeoq5INVCeut0xJAgXBzo6ZixwatLKMxydhUdItxCnAUiTk+RG1DKbZ+M2PQPslH0Q5g90TcZk5Emj4qKjnee5p5WBwJWiqgLxvuYOIxNucEf7IIGUjCWf/VL7bW0FfzMDqUhGKlqY7zyG7Ld6uHe3Ura4JZoDnBpmeAK0sXur+EOtN9Tr0ywLxJYhWdygi1a9fAFZQ8PyF4oqIa3SpBoFH6tEYP2gfsWU2h3O0+/NhFfcXQlDKvH6zEh0RyfLPLDhTS425vjj3haDc83udDrmGPBn5zkLSpjxVqJUTOujMINZxqGaeXpjcTxL1bZs5IvsNPcOWaKgVLjtE6UJD9L5d6kpU4vLLtAIe7mNTPeyt9NJiLOhfX8huuYu6DgzqadDg+cTo1XefHIMji8yIzP5QLkpvv2+PonnBbmEeKZFZ2oKwombEbAsh/u7luiPLaK0naKibTZu2EETd9BbnnwsneJK3JHjCanVCKHlqTCcfgyT3/w7TOywZFp2yyfBHSk3tHuyGxvD9Cf4UFgjIZlRA4O+XsGTOP82nDHgW8AHTy0BwsXFh1uYsDAXqA97z/u6cnk4iy2EUR5/DKjhSZ/7ga4bKAXGwFNiBYNvcRDbK1u6RkK3WKA2GF/vefEDdyRctgiDqHfUzzoyg2yD/seiaJT4EICj6nSYZ1+ALo/ERxfeM/Uv1YoiSAyHYd/VPnk3WIRuos2+0fXwHmFvcNm8MbD8ZM2N9+grCZdvwkp5JF4U9MymcNmPd3JlK6YjrYCiS7NuNHU5TX6P+x377GL9L
 /12hMm1d
 7D1nCJaN1UvoCMdSF7WFr84Mb501WlGnwzpZMSzVACq3sNgS4bgrIwEbz5qp7leX23jR0dJYvXNMw6gS7WawsVrUc5npzpyFY5gzdWi1Gr85lRKbokCJaVpd5Et8xre/S0EMWpH0tvCNMgsAizaAeWHwY+sQMZfcevazFj0FGjLsOEkaW5au5YPP1a06eGxUudqYq78Gydxc6P8Bz69HFpqekdiICOzwi1DRO/PGNp3zifBpt/RHmgERJMbJAOkKLDcRbEpyxvJI8vexpjgcnOZgFSbvdIHIXlelE9yIAn2HkHdf1Fe9oTSbSFOfZdksaPC4DbUfnzp+c3MF4tB3XjluTC2cGhh+hXU1GOKaLh/LKsXwAJgiwHSDRs7AAdbO5Q/jN/Lwu4QixFW/pYBJ87bFo+aLK80r7VTfz0QEk9evV32/C4scJXbJpfhnUTQMszfnX0sZ10+SjwIzpvo12y3ljHxR7k17uozKhY29TDFcTXxB5XKVee0fYpwClieXw1tmRF4nrTc0ROjeThyDTEHsMLiH0eQZDfg+42JttSGaKyuqwRsFGa0nxmTw33qdvReK3q1bOjtlguzzhUNftsL7CclBnsq6CQmGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If memory_failure() can't save the raw error page of a hugetlb folio,
the folio is marked raw_hwp_unreliable and leaked once it's freed.  With
hugetlb_free_vmemmap=on it's leaked while it's still a hugetlb folio,
and dissolving it then loops forever, e.g., when offlining its memory
block.  Patch 2 leaks it only after the hugetlb flag is cleared, as
without vmemmap optimization.

Miaohe pointed out that unpoison_memory() then doesn't see a hugetlb
folio anymore and unpoisons it.  That already happens without vmemmap
optimization, so patch 1 fixes it on its own and goes first.

Patch 2 lets a raw_hwp_unreliable folio reach the add_hugetlb_folio()
rollback when restoring its vmemmap fails, as
dissolve_free_hugetlb_folio() already does.  It relies on Kaitao's
"mm/hugetlb: preserve persistent flags when returning folios to the
pool" [1] (in mm-new) to keep the flag there.

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/hugeoffline.c

[1] https://lore.kernel.org/all/20261102024910.31486-3-kaitao.cheng@linux.dev/

Changes in v2:
- New patch 1 so unpoison_memory() refuses the leaked folio (Miaohe).
- Patch 2: same code, added Fixes: bd225530a4c7 and fixed the commit
  message (offlining still retries until a signal).
- Rebased on mm-new.
- Link to v1: https://lore.kernel.org/all/20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu/

---
Mani Tofigh (2):
      mm/memory-failure: don't unpoison a leaked raw_hwp_unreliable folio
      mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio

 mm/hugetlb.c        | 15 ++++++++-------
 mm/memory-failure.c |  9 +++++++++
 2 files changed, 17 insertions(+), 7 deletions(-)
---
base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
change-id: 20261028-hugetlb-hwpoison-leak-b8d344361413

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



