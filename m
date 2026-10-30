Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F93606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CyowhQHe
Received: by kanga.kvack.org (Postfix)
	id 0DA1A6B05B1; Fri, 30 Oct 2026 18:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089FA6B05B2; Fri, 30 Oct 2026 18:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBCB6B05B3; Fri, 30 Oct 2026 18:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9366B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:14:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25252408C3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:14:06 +0000 (UTC)
X-FDA: 85380696492.20.6013CC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 94C9E40006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:14:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyowhQHe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793398444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v96p8NzzJuOeaoy5WFJozQBW1mtjfbl/LCeCCkWteFs=;
	b=Upd+ZaVhECFXVuoWiIEwuauuS9lqFjS/c1TdsoVeEMoj40rqzQEZeWdGaTKBy38maIpn6C
	/PGS6OTnhg2iV6zt/Uz4T8E+Lz2RoJxrbxWGYrien6A2E4teOLEmN0sBHx/iXkMtiHPaoR
	WYZb+N4dMnfBS1CYJiVAO4qOpc481H4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyowhQHe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793398444;
	b=j+sr74pqadV0SBBe6HiHBDLyMH75uomzhwU9z7gt0LojUZ7ocC3i1FBDxHvr6ucB2Gd6wX
	Pxl/cVz2NJKKwQz0DmN8Sq6T3wdF7PQOWj5K45X5fZepCgnxghBV26N2adR0priHOoZaAY
	ewGIrGQTLQ1XPdTpUXjfFHS1shMwolU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2259B60233;
	Fri, 30 Oct 2026 22:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDEC1F000C1;
	Fri, 30 Oct 2026 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793398443;
	bh=v96p8NzzJuOeaoy5WFJozQBW1mtjfbl/LCeCCkWteFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyowhQHe5fz4QAIGy6UHWgpltzIXUiXysdD2zazgsYDuqVolAp8VEcVMJNz1JVKba
	 G3UhLW+RCtqEVyWmzcpxKNJwBgwccXe2sihbaeDYMA7MjdbidCftV/5OoZc76BSbyb
	 y2iRRlafgM01L2L8TsLcZ56b49Qnl0dGDvVzz+KIcD2TPd5kTknhkyKP75XIgelBs6
	 Fp9fcLeWhbVYWlosxpMyDGz97/a4U+3Hhw0XpDpqnAGg8jqm0JaHA8hAYuvjezZHq6
	 FF3Mq19qpYc7s91TQiVW+hQiNY4LNp8eRD91TALZiTojpOSKiyxuWG2YDqR8yAkJYi
	 BEPTYBmwV53nw==
From: Sasha Levin <sashal@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org
Subject: [PATCH linux-next] riscv/mm: fix up the mm-fixes merge of free_pmd_table()
Date: Fri, 30 Oct 2026 18:14:01 -0400
Message-ID: <20261030221401.155797-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <as0D2sHzh_UnNF5L@sirena.org.uk>
References: <as0D2sHzh_UnNF5L@sirena.org.uk>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94C9E40006
X-Stat-Signature: 6ygu8dgw5men6etwb9kdzs6rahx5ot93
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793398444-10811
X-HE-Meta: U2FsdGVkX1+6EL75Qp/dxGaK2sjoGnoPWaG8ahkSHOk3JHQpkkFGsiDUrjcOgcIBvdRR2KZQGX5B62RBDO/GMH0iPVHokGLnrDRXFOyg0S4vtQUukW/EJHDEMZqf32PBn5C4aTeJd7Tvr1+tHkb+JuZ+YpSHy7xV840x8zg+S5RCvYjhPA6Oi3/ObIAaTNi93MqkZsEQmtOhJ3EoMCq1uqHyFsmZEiSUGhaEUjnzTYNS28hEX2GlIAna6qmbQopYobv9/JHdly6bXBV+Fl0IBUAlRDUmZU/80e2BdNr5wzIkiKzsuUtq/KVoJxd4236Tzc3Z3ev3NtKxGZbz5B4HgKnH2MURjRPzc8UZOfTwrbVX9aFFjR2SHjzhIebfEmMo0skPo5tM6AxNWUwYP87VrPxGKjMkAhgptsSIkYyGGrmZJdqge/2ja7nPTCdmS2iZNUUcSqRSPJ0IlK64w6MoOZ5CuJHRG4tCRBu9lNx7pmy3E3XGyrd28iCQu+dQy5VBmKaEOr3kgQvX4nvjiPOxckbZWqrLF88lon7rT75/LiclzkqswY65FfS7aTni5pv8HwnxHf7QskW+S0Q33GHX7lC+MlgbSZVB//hxLw9yp6OqI5AUj/KCaYYFTR7ZsO/CYtpJn+j4gRBPQjYnEdjdFwcuv8eBo2UqhggZMN2VypuKj+TfMnrTk+wU8LvKsKYpN+8PfAKzg850a0bthvTsyvfGLREFvKG8sqN0lDL4eSO0mGy6jMV/2jhmaHud6Db9Ta4Fjfq2iK5VF3seYwW9dvsCnV6A0O5pZgdDzaXc3rIyECWVb2a9hQIR5or4087U16jtgygrAaVbwfxvCE77juP7M6XDJwm38XVlsdqwzpon+y9t40yorLb0XmmNNvA13FVqWlUpfSfoGDC35JqILoVGO2skB03IJpW/lJtKxJKTHEO50MX4WHbERSOP+znI0QCvvIO0VWy82JmcTj/
 W/osZWIx
 /mQLTylEQV48MxNme0vXZNzA1Vu/bzKbizVczin4kGUzgcYgXrBrkJfcbzmACvT8hS9nlqRAERMCdwHPEmGi1dWTd8tRvR93HMrR7MN0EeRf7ZMuBCXXud6RaOlhHL4RjSA0Nvi6BJ+lduMBLFMjh45YsLY80ZrTNWMsd9YlbIQUDlpjz4rbwRIGs6PIAlnSm/c9Vtj6y0zNj8Fh4cpfbjQ73OM6XMt48gyEj2myuF9lz5nXOo0aCE+Xa+mQenZlZt9sQ+f64h+7x336nWS9raRE+pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The mm-fixes merge reuses an older resolution of the conflict in
remove_pud_mapping() and keeps the free_pmd_table() call that passes
is_vmemmap. Commit f998a21c2ba5 ("riscv/mm: fix hotplug page-table
destructor handling") in mm-fixes removed that argument, so a riscv
build with CONFIG_MEMORY_HOTPLUG fails:

  arch/riscv/mm/init.c:1657:35: error: too many arguments to function call, expected 2, have 3

Drop the argument to match the mm-fixes version of the call.

Fixes: f383866da287 ("Merge branch 'for-next-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Mark, this applies on top of next-20261030 and is meant to be folded into
the mm-fixes merge resolution. Next/merge.log says it was resolved using
a previous resolution, I think the one from the risc-v/mm conflict on
2026-10-12, which had the same problem (next-20261012 has it too).

Build tested with clang: riscv defconfig plus MEMORY_HOTPLUG and
MEMORY_HOTREMOVE, W=1 build of arch/riscv/mm/ (also mm/memory_hotplug.o and
mm/sparse-vmemmap.o), and plain defconfig.

 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 2400537a01215..e822fce0af4b0 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1654,7 +1654,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled())
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 

base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
-- 
2.53.0


