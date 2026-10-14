Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6887FCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 05:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066C86B008A; Wed, 14 Oct 2026 01:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32E36B0092; Wed, 14 Oct 2026 01:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22386B008C; Wed, 14 Oct 2026 01:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42326B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:23:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40F07160445
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:47 +0000 (UTC)
X-FDA: 85320089694.29.83CD40F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E1F71C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:23:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzpPgRZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791955425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SdSYpehsphW4ohcRgZ6kkg4WkXWb7YZZ4YKMZgeJFUc=;
	b=Xy2RLURLFHCioldCQpsoaT/RO1DalUIHF3cP915jGrbjwsBzYmpArF03B1Iugu+HLD2/tZ
	4/Gys3zjJPt+296L4lU4Ph84qfgnnpVpFEQidXeTNdWINhwcPcr5RslQR+/x9O1Phjfbr/
	Tyo6lOxVwa3FDeU+e9U1D7pzyua/BdY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzpPgRZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791955425;
	b=tCFWUN3EgKZIPoIFdmfeIygmcn/s5oNzqKf+RYtCGfDr4DyIHUKiOEdgy3XpMVKHNKpZMM
	1/kS6h/qsyGazhISLXw7uFeXt9luuxh14dQ/3JzAwhCsNjORUc2/Slt9IksdySZPJYFtsy
	f+dtHcs+ZDkeMgeGv4Cf0LBhTnQqwPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C620B404F9;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40BB1F000FF;
	Wed, 14 Oct 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791955424;
	bh=SdSYpehsphW4ohcRgZ6kkg4WkXWb7YZZ4YKMZgeJFUc=;
	h=From:To:Cc:Subject:Date;
	b=HzpPgRZW7EyAIbsLd5GKX0VblZsKb+zJCeaRAKypkv55Evn8jSkn5B8p8tvMMPCm2
	 xijzFZB2nYUOGatSBxl83G3DFQTgROkz4XPHhlcd53XCnLhOPoQSe3lsMl3UIHGqRH
	 2ZvJZeV68clhF4aR3d8Bf+jQjTHmh/QyjoUXBhUoj5Vi3SQq9O6JWQBWA05/qcz5bH
	 UEYeQpJ498tvF8RNUuwUyPFuynOakjljBwcHxWBE8XxkC7jaZdHqWlgEDFW5Y6kAWF
	 96LbKMxnTjB2444qTiNG/IP3UVAw3pIGY19tFhb/pY6yKMkjHByQ7heIdqK6dPpiZZ
	 Jm5+7g/w98v7w==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v7 0/2] mm/slab, ipc: kmem_buckets kernel-doc and msg_msg accounting fixes
Date: Tue, 13 Oct 2026 22:23:41 -0700
Message-ID: <20261014052338.nothing.279-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; i=kees@kernel.org; h=from:subject:message-id; bh=FiVZUxotLv/zfGLKYRPLznaaXPZGHAbqigwRAF3TMZc=; b=owGbwMvMwCVmps19z/KJym7G02pJDFnnBe/t3nuKReGOt/wEt9naXak37qq3HI+ODmi7oReuV aiRdlSqo5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCLzyhkZ3t612Gb3y0vhvGLA 1/iXB8P7TM30HgSt8Rc/dmXnGsbrvgz//dzn6TWkHb2UE33h4A7N65/m50X8+XztvE6mTl1ZUv4 XFgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tgt3me7h6nun3xeyobwmg3tsycbpxqun
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E1F71C0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791955425-444246
X-HE-Meta: U2FsdGVkX1+XIqxX4eKlg5gvM5/KK797HoFIia+DthPAEwO8UEhZd9hrAhi5ptOr7ae/k8wUFQOe3uo1vSENuInhj1+J9nMbQB58idjdQcr3VpzeQ2qJ4mHMTeuIpejTJ4ESYotkBzQbIzVelxiDksYUC+BuXPUwyYjkM0Q6qqQAKoYYe8kL1TqcOgpz8o01yyiaSj0M7TIhoRNrciyzWOGtibs2YWaS5X/sm0dmksQy0t408etbiomH2OH286afOpmLz7aBeqZyVQ3nrhI/a2C4Gn3WnnqXg3tvowSjt9nCj0Y8hqmLizb9quLAjaDNlB2j9YFIZOgldC2Kc25IqsnvR4BpTYszX4Wx8BeAO6UYP2Gc5K7pJ5udRN4h8PscT7lerqJJCx4hPPP7Uxq2RIwh11lYYZK64n3Qf88jY5pEVRuCuWvKd9xqUytlM1MbdOmzTfANjFDvgnZX4X44IOqijN6eoEf7dygVakyXNiTAOJamdu07/xhyy3nzg74JGOqnjv/VcMcXAa0bQfhi2NY/A29G4NQwSgP/gdgGpQuSlGUqb91UFmi0NohoVgxaYoURPOza1wiRi1ZHEgNXJreWsKC+dOKiJgytuevqPIL0uGueTVTLWMXf/rPy0p89ZcOD+PxDRXCefB/f/tH0ZYJAQ3rPE1l1E3cRk3bTRPHAdVMTm2W/a/xF7qnFHth/y0HboNDsoSD1J9scTHtNkJDlX4fSQ8jT37imHDRoSez2xGx3G03OysR+fQ0KoiQ25hK2FmELCCIdPOAXc4RNzL8SpIKQ2VV3hg1bHA2jXdTQUrhLj9YvHVO65WPwdCsz+MzgODfIweTa4NFdLqUtXVVNBuqkS0Ij+kTsaIJQEyOd9Yw6h+uLwIhalTHBBXXP9BAZUyGZZUytudoSkkWh4Yq07t5ZFzbG3/DsgKVmT34chloVWDNlcJaRlIhNbfAxtebYLTLyyYSuVDdKOcj
 nKkOYosI
 wavBCxwAd2l1/mnaLug1yo8iz2og0HTXjYjhcu6wSbVHgkUJnW/a472IV7+Mu6BV28AC4JTx4uUp8ZCNlkMk7wxUOHqXZiO13+PnK2o0TCZR7XZ0uJYUzErGqdbOEVcAUwZb6ped53RYRFuNzuPG3CMe4CUBc+nRP+biTds7zBk1GKxS6s2ebEOxqzslFfabO/QZByR3ZFd4m//rI1d0L97pHE9NVuFA9SNwE0U4PAgI04EbnYq2fR4CJ5q5Z+GBf4ERnujDQpPgdyJpAW6F+UR6rouUgQjHfvY2l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

As Vlastimil suggested[1], these are the first two patches of v6, split
out for 7.4. The rest of the skb buckets series will come back for 7.5.

2/2 now keeps SLAB_ACCOUNT on the msg_msg bucket caches and allocates
with GFP_KERNEL_ACCOUNT as well, so a msg_msg is charged with
CONFIG_SLAB_BUCKETS either way.

Thanks!

-Kees

 v7:
 - split v6's 1/8 and 2/8 out for 7.4; 3/8 to 8/8 will return for 7.5
   (Vlastimil)
 - 2/2: keep SLAB_ACCOUNT in kmem_buckets_create(), and add Cc: stable
   (Vlastimil, Andrew, Harry)
 v6: https://lore.kernel.org/all/20261006092030.got.500-kees@kernel.org/
 v5: https://lore.kernel.org/all/20261002231120.late.500-kees@kernel.org/
 v4: https://lore.kernel.org/all/20260921075811.too.775-kees@kernel.org/
 v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/

[1] https://lore.kernel.org/all/be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org/

Kees Cook (2):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again

 ipc/msgutil.c    | 3 ++-
 mm/slab_common.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.55.0


