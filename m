Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB19F417F3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E9A6B0088; Mon,  9 Mar 2026 11:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200136B008A; Mon,  9 Mar 2026 11:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C8D6B008C; Mon,  9 Mar 2026 11:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 029466B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:19:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCD161A01CD
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:14 +0000 (UTC)
X-FDA: 84526883028.16.1DF356C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 56CCA4000F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1HYB2V0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=13W3+3LFMinj6FPLvnxSJnn9lYgENZeNMmdBWOMyKC0=;
	b=ahPtDwUW3TDTE1S+/tViPs2kWH9a19jnI2wwGtuNRt6XesS/uST1Nyzg6KZZlBRW6D0FSu
	fbvyb5lUDp+OhDfWxJ/TA6zMcc4QL6xIuyOSMLOBkoKpP3dBp7KVx3dp+j44CzohXonkkG
	EJioCGRNkOmaOuCizXxIvXL6ByiVpDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069553; a=rsa-sha256;
	cv=none;
	b=0P0oWmMxIgupLX/x2JSDbnvkEwq+cb1yVcEO/w6QNurvSTm6tqDGlMaKTyNMLgnxsvnyi/
	SghAHXcyIZTLQ0oXRy6zVJWKlzZzNVPyFjiR5iO2h6o3BluIzj5VFJKRoh48NFIlVj9cAF
	kCwtPhQNJVTjcjnAPFhqxeoS2WnqnpQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1HYB2V0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D639460054;
	Mon,  9 Mar 2026 15:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9EC2BC86;
	Mon,  9 Mar 2026 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069552;
	bh=U/h2huN/IK33EUYYoVbeCNOLTX65WGNBH1yEJmt4qPQ=;
	h=From:To:Cc:Subject:Date:From;
	b=l1HYB2V04oJ/S42Zu9JUsjv5Owzl7dWIJVg9XjlpPgIAXwhiZ81EH5q+dmoG8nVzW
	 xKsIZQ0B9wi04tzX/z93YqUCHDJyEHEwxG4VlhASvbttYe7KGDuSCXkCLxBOhnpJY5
	 nYGMxzAJSQYtcmc82vcKd8/t+YmFKoNv+3huhkBL7y2Psz1c6sncJwBqMSLrJbdDxw
	 d7KraB89RTyGWDDFgnObhpEIBcPuRjdrpSHqBWlf3lqg1I4xb5kZ1dXqVEVCaClf/y
	 YCZDuxk4gPWFoBjI5H/fFusUYLrVRRL0VEiQCJ5LAMe9ThZsh5l2H8AzQ83CNCDS+d
	 gQvEe4ITMwnGQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 0/4] mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c
Date: Mon,  9 Mar 2026 16:18:57 +0100
Message-ID: <20260309151901.123947-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 56CCA4000F
X-Stat-Signature: pd1pbkemphzjkdkhwn4mcfbfzyoi3awd
X-Rspam-User: 
X-HE-Tag: 1773069553-685174
X-HE-Meta: U2FsdGVkX18u9Ms8TJAO2aK4CQ1IBKzQqsnVE4L+kAlICy92JD58jZs06irgHXQxQYvkGDKk9yPYiLxmFt/R4EbiVP9rAl1inwm6yLYQAQL53ynIePeu6Yt9t5FUS8YRfVJt8yO0bxPgau6ZbtaoQq6xxD5AccjhONc8pgci80sk+ze3P7wSCTdy0VVYfHjxeOyNuXWvQQ+9VW6JvbX53Dho+nIA8I0dzeSTRLf2oCYl9NGymyUYZ5PdViH6zzqrfD9a3FGckCTFCVhORaw8EfwLUpFmXtD4dOa7zq7DdnOcUPTfhSMUOTqfVyWxUGiy62LAh0kUnjeIAwK/JCmaZO6YaccXhmJuN+mX2FY2IjwBhINTBGKPJ7pgmQwHM3RG73nDAPov3FiKDTR9pgIceVfeGm3c/mUMsURwjiUrZ+gl5gcUYXJ0+1d/kz3SCfM1zD919K+eQwyLxNhD9V6aVNtBb16DeCHTs/8DhCSMI8ylaOodMTaA5ZzLUkMlufKebvsMK/+kH22Gx4v45wwP5j+Ja8YtXpJ+iWxseSHTnupY0oMXAUWBx27bnxsAFpFsxR/EXpRkP5pK8/VRd8V9MBxdaDBugy8+nZyZJgpCxVq7I9D8QCP1g1hv6bZ+25fZ77VPSy4ZWtYgKO5190oVhR2/I8Mbq78cm7eibpkLnkhO+otM3R7Xf1BKDb/imGdvICxZ9dZGkU4gvpf4x/ntVwrRAEEFk3wvseVP/k+PfilCmDiCIZVLsFFobyK1NlLy3Zvaw1I4eGH6WBVX06DXBUYvf/68kQWxfyMeVAocYMPHoc/tX5yJV500X3c6Yv+gveDYMZWrCVzhFzD/+kaObupYqNhCKnnjERQgC+qOVBKrr5fd4tIbQvYndFF/fTpag2VjfQjVlGrZSgEdoskv3EjlJxSRMoZXXPos0RwOPVsVpEM/tX+UKQv+c5kAAFJRz51v0CZRWWJ2DbEe1ou
 G1qEm01j
 laUo5UUizMTIh4/4Ivt6HvLWDJJ5/zWioSjbpdYI0UsWpnKiRFU4u9U+UE3qqnQ/FtEAy89Ft3TY1poIXu7A0CGU54jNIaDw8lCmr8fN0tL6kgWJJpSv2Hr4QJ79dJ2HtYr1k30TxtdWx7HHxC+sj/zg5ApVavm3dPA/RxsptiM4qk1yJ0YH+m1+eTMqc+jHpygGq5NXgg3kdE96mjqqVqVGBMgvCpvFc6Xvf1DJ/WBNb0yXPeaK+vl08LH751vWdJxKp+5HLEjo88EFj/S3Pnn0kkBRcsgMjwqCQaxXNRYmLVRdo9z51SOwuzH0uHSEZ6k+0m/IMFjW7TfgcIN/hlRSmNUEcOk7XUWUoAJOknGVPPstGFXzxEm911vKopIHRi+2/dF6JT/brWs2EckY8dQhGA5klFzs09eR34jayDXI+A8FEESvuhxAUm6ECPZUzR2X6M27C35eH6HTotZ2vMxpoi2s9WL71swaIKXflbUoQdvDigsjuSrForJZ74dKDqsOea8N9TyoNf/sS6f6hDmZ2mnZQaSkq8W3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is
not compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
inclusion from KVM code.

Cross-compiled heavily.

v1 -> v2:
* Fixup VMA test in patch #2
* Actually CC all people listed below on all patches.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>

David Hildenbrand (Arm) (4):
  mm: move vma_kernel_pagesize() from hugetlb to mm.h
  mm: move vma_mmu_pagesize() from hugetlb to vma.c
  KVM: remove hugetlb.h inclusion
  KVM: PPC: remove hugetlb.h inclusion

 arch/powerpc/kvm/book3s_hv.c       |  1 -
 include/linux/hugetlb.h            | 14 --------------
 include/linux/mm.h                 | 22 ++++++++++++++++++++++
 mm/hugetlb.c                       | 28 ----------------------------
 mm/vma.c                           | 21 +++++++++++++++++++++
 tools/testing/vma/include/custom.h |  5 +++++
 virt/kvm/kvm_main.c                |  1 -
 7 files changed, 48 insertions(+), 44 deletions(-)


base-commit: f75825cdfc4c5477cffcfd2cafa4e5ce5aa67f13
-- 
2.43.0


