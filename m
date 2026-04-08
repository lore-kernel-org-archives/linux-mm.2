Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E32810F9953
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B9A6B0089; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF856B008A; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8716B008C; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83AA16B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24FACC0A9A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:42 +0000 (UTC)
X-FDA: 84635818764.17.FBFEDB7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15473160013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dSVEcEoS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775663260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WQBQpmhO7K+JMC5pO21nDiBudOMp6NAQQ2jDhZLgte8=;
	b=Z/rPHj0kWdCeUK029LfZN2gA05phSoen4ADpbCvBBGOC8PyAER8M8RNuIsPTsD4XIhYJwe
	/G/R0vmT2BGddtO+FkQg0uWKsVfsd4kLTfToW/N4R1Xw31tYJ8OCIVKHq+jBpUSqN5p4wM
	DpEOZhztVOXBLnaoolMwjjjJFfirMww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775663260; a=rsa-sha256;
	cv=none;
	b=sdNoKKrrFFyaP4BtZjPezd9KeLC/YYJDZqlyYR8uwjzbvJHQj8igrGktvAmfCYJpR+g+ac
	J2DkZ0WVofBBXmR07ttCpjqrJnfE3U13QxtF4t5nH8Qyfsr/K4GNr7KBNzxqxToJRDgMgV
	a9E43PXBfuxF9DuCXcpmnNZdD3EVU18=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dSVEcEoS;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WQBQpmhO7K+JMC5pO21nDiBudOMp6NAQQ2jDhZLgte8=; b=dSVEcEoS8p6QTo+xy94ju+Qawi
	PJErsOo3PJUalqQGUNXd0n83zV0tqzvaLojM35OgHgZ9XzUEyTrqZlKygNblrm186SGKhhoxUsAlZ
	sUrDJZK3OiOzaQKyKVq6hlCADXx7s/UF41ec9g1JJyfOYDqLiZKaYFiYLqyU9yWqkvC7d83CirmMT
	+tHSrQW16uAjWOmRP5oPWmzvkvOQAPa/l3+2Fp2glsmQTrwovJ4xT5TShwJdK7BS4rA+Gm9DVXdmD
	Uv1MgaI1nEK2kFayaDCwVJN3r+RHrG1DtnjVpmY9UtelsvysreuazckrJSCvJWktKNs8O2hqtN4DC
	PeNnipbg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAV7l-008Wdv-0C;
	Wed, 08 Apr 2026 15:47:25 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/2] mm: huge_memory: clean up defrag sysfs with shared
 data tables
Date: Wed, 08 Apr 2026 08:46:59 -0700
Message-Id: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHN41mkC/23NSwrDIBSF4a3IHcei5jHIqPsooWi8mttBDGpCS
 3DvxXTa4YGf75yQMBImGNkJEQ9KFFYYmWoYzItePXKyMDJQQg2iVYLnZXtadFF73nfCzZ2TTrc
 WGgZbREfvC3tMv51288I5V6EWC6Uc4ud6O2Tt/sKH5IIP2sjeCqsGNHeLhvR6C9HDVEr5Av96O
 CW3AAAA
X-Change-ID: 20260320-thp_defrag-540fc4f1fa3d
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1451; i=leitao@debian.org;
 h=from:subject:message-id; bh=ORU6TEMuXSX3gagyRoSqYOuhy7BGhkP/KFoWhinuBco=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1niIlESg6fWs0gSoTm/P8RGRLGG25TN6LPR/t
 vS9X4EUD0KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadZ4iAAKCRA1o5Of/Hh3
 bYLQEACetudlSIF7MfyrhfJbDvQvmBuzC6e39WlDdqt6c6ZswIF5L9ZLisjupWui436LVvrgWLt
 6W95zLXcrJYDb2XMQXbH4B/VFmDyK1VwGlqk7f7NybBg6wi+CRHZOIarsPNhd7vofKLbl/Ck7a5
 KtDNzQ3Jm4uofs5jLwvgUSMQwFAglSLumwp06dBLvnHJdTscbBQ4Utg7o1trwNxd8D3jj22PejA
 Wmh4MiIOrdXEi3ZLysfvqAHxVH4MNZwg8AMW1hA0ztfer3wtdbTls5bQtNUP+KN7K0a8Edh8EO5
 bBrT1rd2wNad7UricvrPcjQmgBvRx+OkkcQw949w7ydCjMhBiX3Kb7QDAPn30/A7749YS3P/6S0
 KVV+GKGYLl7VRfxdQ3PWUoI1mhQuACCaxnMFfVI1k3jCn+RtTuLmb3KvnHfX3FDqRSbtWZRCNOt
 JNwPYZKJDhBihvkGEjLfflCkcfuj9W5cuFHBwJOPqwgoTY6o7Q/iQ9IpkX/N0U0tNHY/FPZz01P
 oo+FYvhrWv8E+e+sMAivUtGbQo6z0KxDUZKPSpx262euW03JycQhNOCiWwL00lbcsi/k9HKb83x
 UzL1OLr5ntZ/wEnEC63+uPhv63B0X+7+FrUQWhrGPaF9HQyoSW1C4H36e2NLNp5BliwoXdzi+fO
 h6MP9cGQnmyvvAA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 15473160013
X-Stat-Signature: 6p48two7egndn41t8e1wtu4gmatknxtc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775663259-239381
X-HE-Meta: U2FsdGVkX1+U/WFF44SHT852jYGIVb8bTfjZgTsytzAG+/XvWAmu7fVB155MB+Cy/FiJwGDBl4ilj55ZZhGzVkvhEWlAoYli8zLNhheZbCFdIHqndkIHNBZG8YBIEAtfcNSlszlNoujvJ3sD4XXIjC50zibpI6sFiOvxdJ2pXqna4UPDBpL4PSWYgXxvT1IFWR6aFHUn8E8YFNmvCLZC2m3hZNd7wpng0n2J0lDkmew8p4U/fTWzbIHDxoz6M6Nctd26VCs5p5RR8quW7jlbbeGA71lTPqEUQTPe4Q3V0GxbIQAc7S9pOCIW7QQ4oHuEWxhYQ9Rx/nCeUB5lMLccjFHPBiCKoL3BorV7asKxAdlAX5VhZF6C84jS1NzSdViq2/Fw+E1gkGO3ccP+NJpuedDiH/u+0nnF406MOB0hh0vRapYxe0d/PextNjQDkaVqRYzTWqbZMljp3rpAZcmNrXLtBis3hIVeoYXACqy8Q7e7kQNNfuuuybBEs8LAYj5a2ddbR73E0dlh4WnVAgYW116Pv5aRkQQHldQnfGKcgRi7mcVFfNLdG0r+gaxXiMgsSG7evfyH52ZdKeKkV421J38vmYdC37TaK2wv0PXiRysIPWNzEHKB0Hrx4ezJJ8gB5peb4+8ITtH7b14JO5Sv6G+Rhm46LlSk6p3/RoN6dXASRhUh1L6cf87PHJFweJBUd8sa6rRzrg8u+FHbxOhjdsE37LEjLURA5xqKj+0E5Moiy1ebiShTL1uVDIEGFEeJT72ArWwrxrbYmvOLLex68is1iFzobcvmycEdxX5HXO6nIrYtoKmCOKr8SepuT2XmOhuqFEswAN1MutKL9+EW4Cto7r/5ULbLr7Tj5jxKDUP2xGX8QlOSS3abhNebiD3B0hweWxgRAvKQULL/ZSQleEWUv5BYzEs+gdX3t27oehydo0I0zsNFFeLGQC/H2ZsvEP1maizp5S35UDhUHDw
 P7NaUjfH
 tkIOcTC4WG1k2eatQ7vErvYHBoY3DXbIR83UlK2nLfAg3KW4e7qNXL9hktQk3l5WFiblItekzxUPLqm4Mr4ZAX+68mDu2n3tgjhVJjErQzEYuqO/z3l0x+Sjw3DLaYxeT5J4VgV1CZfhJC0n1OX7o4wT09Lip8kEShUrWf0gWkMnnG89QbW2u/z6wHRU2CDbzJ6VXBk+wOGqJ6f80XF3zOLZ0LqfG31qY6Fltd/BaRDCQC8rX4ZEjJjN5soaEmZSl/aRVQkpFA4uqA8WYwxPb5RyyJRaq1Xae+/SA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor defrag_store() and defrag_show() to use shared data tables
instead of duplicated if/else chains.

Patch 1 introduces an enum defrag_mode, a defrag_mode_strings[] table,
and a defrag_flags[] mapping array, then rewrites defrag_store() to use
sysfs_match_string() with a loop over defrag_flags[].

Patch 2 refactors defrag_show() to use the same arrays, replacing its
hardcoded if/else chain of test_bit() calls and string literals.

This follows the same pattern applied to anon_enabled_store() in commit
522dfb4ba71f ("mm: huge_memory: refactor anon_enabled_store() with
change_anon_orders()").

Breno Leitao (2):
  mm: huge_memory: use sysfs_match_string() in defrag_store()
  mm: huge_memory: refactor defrag_show() to use defrag_flags[]

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Do not be too verbose on enum defrag_mode (David Hildenbrand)
- Link to v1: https://patch.msgid.link/20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org

---
Breno Leitao (2):
      mm: huge_memory: use sysfs_match_string() in defrag_store()
      mm: huge_memory: refactor defrag_show() to use defrag_flags[]

 mm/huge_memory.c | 98 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 42 deletions(-)
---
base-commit: f3e6330d7fe42b204af05a2dbc68b379e0ad179e
change-id: 20260320-thp_defrag-540fc4f1fa3d

Best regards,
--  
Breno Leitao <leitao@debian.org>


