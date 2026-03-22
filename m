Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5479D58CA3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0C16B0089; Sun, 22 Mar 2026 17:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498616B008A; Sun, 22 Mar 2026 17:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5EA6B008C; Sun, 22 Mar 2026 17:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEFF6B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:36:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD3CD1E81A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:45 +0000 (UTC)
X-FDA: 84575008770.30.3C070C2
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A0A81C0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=WprjqEfD;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Ka7Gj1ODMKls9HnubsAnQ4TlPWBOmVvJtfpyNbAIeM=;
	b=KVEJPI3WSa5eBaa1KEAJgKziMlb85GIx2u4eYf67/0rQMT5unesYMtO4cG6JSBbTagV1tO
	OSrhkQ2ypn5esy6Q84WutFa8hLplyyyavpSk+kqrs6ks3dZlHBZop1ENB/f9j5bMpQL/LS
	4njfCsRPw6flvEGHaWJU6Y01hVCY38Q=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=WprjqEfD;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215404; a=rsa-sha256;
	cv=pass;
	b=SA7C3AkIKsVKD7r/R8Q82G4WuStPsomMnftvg7D2loyaiSIGzf1VLeVJy0T5VYPgYyBY9S
	/3OYgmxw7XZULdLtl7wi0IpJ2ud9iPdwU/ZGuACmKZ3v9fud2q+IfZuk0JLMqgYXfUmjiK
	XMIiUnGt4KhLVPZz2a40pqFDcQEBHrU=
ARC-Seal: i=1; a=rsa-sha256; t=1774215394; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Frq4MVq7LewBDUo+utAfMV0FgkPK1sLpq+nb7tWCAcywFSOXD29P9tTvj2cA+t9LJBu6/ea4WZQu141rD433vkO68B+/Vs3eCs4vaiq9Gu/3fGd1vYdjPUY8Lj8J6h8xzctU/5okDhsge3WXGD7DtL3W22pVJsPVKYPjErGU2bw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215394; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6Ka7Gj1ODMKls9HnubsAnQ4TlPWBOmVvJtfpyNbAIeM=; 
	b=EJHFZSbBVsbObuL3m5DE6CuGc9UMcL2DHBvolZQpIGHO7ipNRNIThat2/F43jI2Hev2L8E0jNL1dvXoSv90hd7Je2tp+3k72f8JxcvLK2ezXV7Qjg8seY/ixRsMzjYQ/YjD9cyfscJy2GWNsNY8WsA6rGzuVAzJnla3Dxcuaupw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215394;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=6Ka7Gj1ODMKls9HnubsAnQ4TlPWBOmVvJtfpyNbAIeM=;
	b=WprjqEfDgLNmcUIbPhoGnlrQacL7kTG8GU72fybfi0cQCdYBQKb/eFT+isJ28Wr1
	w9+bu7hv1SPgD/VZTRqfvrWiawba1j+gaJYn10ZnAN8YPs8huqUKW3ZF/Jl5ZfOJxuF
	6CoGhU8YgWdb8fhQicKlkBG5I/I3OigT1FqZtV54=
Received: by mx.zoho.eu with SMTPS id 1774215392336839.8254076143065;
	Sun, 22 Mar 2026 22:36:32 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2 0/2] mm/damon/core: Performance optimizations for the kdamond hot path
Date: Sun, 22 Mar 2026 21:36:29 +0000
Message-Id: <20260322213631.259212-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A0A81C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: 9r569fc7h18xfxdwto4xzg7ncsdr3wfx
X-HE-Tag: 1774215403-438945
X-HE-Meta: U2FsdGVkX19GYPpAbpYFiZ/lQbI28p042hwwfoyL5+fjrF5U/cUaMHWj0TxmFzlGeSBQEhln2MgLmdaqTDvwKp/d8tzDvlRe+r1cTtE9PyXBAhs0MxW4LLajtSh24UaC3+HKj3xXMLSyR6bX/+BoqEob/JMAIXUyDpIaxhI1fsSJ2CLRYHLGTU2jI7KyQvLw0i5maboDDHOsDGRDjxbSeKfFhCrRLC7GnjdT+c9F8SG4y2x3MZvQqZbX3l7OxWCdjkgPUC6057lYvohAfzn8cHuymZH5RKrQcdtUgBPwz4dNz4QWhbvWC2Zwp8jC+B29AVjO+YJkuamVL1CVNNXxtIDeMJAbi79GXzg6bFHoETCt84JdvHOF04EzYgQax3vRRkVq0PAWtBA8N7+x2C8eyPeCmuyQyDA3NuSJJjt47n4qR5mQhtNgfd1SvIxFfWefKK520KBhUuQE/OiwH2EBs7NgFLA8lIxVPBDoxCDe2BJQHLFedpupYTWac2GjjrTy0vh38TPXUGuR7dUci4YUXhEyqjF43NMAuuI617CKsWjdsoOFRFgIHA0HIZWujBHf3v7xah21q6vmLh0ClkFWD/Ubd36HjkhTEcpyj/BAg8MJ1udHPzXROSmP5K9GtRC/hZtjc8cE++SFA383DFXO5nnw/fbP8wID0/yCpmntXX1Y9ZfzMZ8E43NiSx+M1y7jbXHNRVkK4nuShaH2/NwF+k39aqfMDLAP0eIY7alpgwiny/qdlP1mk2hvKRyxd71b+ecaTW0q8XKCjxXWw+zHbku2peJvs5jxCyZZTTw5ps9rpg3T9tqSdwiAqhoiLjkZqcZh4FSQ+VVjOv2ysU/kNdxs/nn8+MQNTdNVCD9F4fQaK7ZDbpkoaLqcsc+GhSDp/bEMFVsuVh2ChszgCiCMuPlOZ7t0rm+nVev1SIj3Gb3dHCehVXqSHDb+yky+35Td2UoHR4W5RqYwOS8Ax3K
 IyHv2cay
 HyEp1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This patch series provides two performance optimizations for the DAMON
core, specifically targeting the hot paths in kdamond.

The first patch optimizes kdamond_apply_schemes() by inverting the loop
order. By iterating over schemes first and regions second, we can
evaluate scheme-level invariants (like activation status and quotas)
once per scheme rather than for every single region. This significantly
reduces CPU overhead when multiple schemes are present or when quotas
are reached.

The second patch eliminates a hardware integer division in
damon_max_nr_accesses() by using the pre-cached aggr_samples value.
Since this function is called once per region per sampling interval,
removing the division provides a measurable reduction in CPU cycles
spent in the access rate update path.

Changes from v1:
- Use min_t(unsigned long, ...) in damon_max_nr_accesses() to satisfy
  checkpatch warnings and improve readability.

Josh Law (2):
  mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme
    and region loops
  mm/damon/core: eliminate hot-path integer division in
    damon_max_nr_accesses()

 include/linux/damon.h |  3 +-
 mm/damon/core.c       | 68 ++++++++++++++++++-------------------------
 2 files changed, 29 insertions(+), 42 deletions(-)

-- 
2.43.0

