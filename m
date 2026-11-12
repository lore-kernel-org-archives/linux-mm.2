Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A12606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vh8JImBl
Received: by kanga.kvack.org (Postfix)
	id E82996B05F2; Thu, 12 Nov 2026 17:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E333D6B05F3; Thu, 12 Nov 2026 17:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFAF46B05F4; Thu, 12 Nov 2026 17:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA01B6B05F2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82FA7121C71
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:22 +0000 (UTC)
X-FDA: 85427858964.19.42D0161
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2215A000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vh8JImBl;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mz5C+hrA4fTk82DSD6cW8Q3erNJ0g6GuLKJqSpAAgFk=;
	b=cuKY8hswY0om9f39LSA2rGaNGF93enQUSAo5AD1ACNLMdKuYvQ69EPAUL+QOTUwEKNpYTo
	7jptHOM9u3bwFhQWLd3UGGZXZwSqenaAMFfhGbq5+QBNJ4bBHQJAo53oXmlI/xoDtYKOiJ
	Xv/lh0H6PGBhsE7697bvi3YkkZTVe0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521360;
	b=SKa2U3h0VuW/mzLIabIB8wHATCbIZ6XL9LYt6Q2eTjuv75FoocoIjkUy/SJkGQAbb2uKfU
	sLflGF1BwJISIrMxD+ACUP7vmZ3TeE4W90S2fRxe6mWhreLn2HRiGy9CIQp0O+Y1DlwdwO
	vUONVpG+t6nZV8MvR4RghmGKxPNnHkU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vh8JImBl;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 844AE62488;
	Thu, 12 Nov 2026 22:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C291F000C4;
	Thu, 12 Nov 2026 22:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521359;
	bh=mz5C+hrA4fTk82DSD6cW8Q3erNJ0g6GuLKJqSpAAgFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vh8JImBlAcjOnz8y7pU8IDWYsh0VqCsMcBMwSe6HbE3/KNMIikgL9fSTP4JOHSZjr
	 71AQirUlRVwjDEcPjEKvKy9nxX5cE2CSgQsjHHZ++J82aM5osTEASy3SwFAVHIi2Al
	 yK6o/209hYacaP0a+i2FCwwTThsYUdQ/iynhfX32OjA7OCxEPQWfl93b5EpcAD7H1T
	 0zOvz0wOrpQ7IFR5/pJeNizPRh9TSkWWwGRcndpgqlf66JpmGI8bbE9R3IRWqoioJL
	 EOsibmII5FAk1frAhSF+hWqu5i5pT6ygxfDHbptiJMSPIkUBz2ZQaHcyldEHV2Njon
	 vuPSfjHEXQyyQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:08:57 +0100
Subject: [PATCH 1/5] mm: do not call vm_ops->access with FOLL_ANON
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-access_shite-v1-1-988a5c470db2@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
In-Reply-To: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Willy Tarreau <w@1wt.eu>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>, 
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1357; i=david@kernel.org;
 h=from:subject:message-id; bh=Gbkm7xA4sog0FLarlHe8xi7ovZnljYEXfiAf17aaLzU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+Wfy7c+rgyoVXNq89/TK8dlY/s/mZo9w5kz1fSCm0e
 jXN1/W51lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEtpxh+MMrP+llbnSkpuHW
 xxzz3s7a7tR48FFV/F0Ofb40GdtAoxMM/yOtmW7crbi/7Oi3Se18k46HyTZ+UGSacP7+okuzf3k
 JBrICAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o7penakpi85kzo9ecyuafih4si5xjpix
X-Rspamd-Queue-Id: C2215A000A
X-Rspam-User: 
X-HE-Tag: 1794521360-814820
X-HE-Meta: U2FsdGVkX18hheamRpXyCuKmY6MC5qbo2uI5QNbb0w9KAYKYZCcth/D/tPmr5FC0VbunvOnkuK59qnVSqBvYsi74rYFPk/l6iJsWt1DE2+cfHApT0k6d1WPJSrXipiwVKwJ2hMUbYXOVFDJHPy3sj/5iu/3DShaY9N/jxQNM49MCnLQ4c2eIHetznW2jxUlYatXq4PRverH6eRsBE4czJpztHt2u3zW4u/OG2GxpkmgQh1JIc8ribqwT2GhfBHHWzM8Mu7qtwYSuBHZqGEnsEvrvP/Lp8XFqj+SxJwedxrPwBrBSsQ+/HJ+79faFM8dT+xsc6TbjNBOMFqkJOpztsPFH1O9VDgkT+vh/jhxw+2X7E93/4ftd4h0BELhgSZs0Pkyp6MX0eCPiHbsd3NMojT6KMfe8AZyt3d9lDejgyO7hqkEgVGsfhhh3qpkBiyboDQoQ5PbLnN0cjfZgo5fXCI6XSjKwh0Dae2Wxoapm92VxRs6TGmVIQo2ahqFH8rxotaxKeCas9jcFVClJyOUvkDCqSBkykxF6lVb/otNwZRfWajEwVD41n1p62k+l0HsozXjFF08Q5Nr3/d0cg51ByB6kvl3dWvM5pCZaJLv1Itx05wV32p82A4cwWpc/NBS1PJR115hLi2kwz4akPpfcPXN3Tg//ZMN2j20pbaWKPkliZ37GhKYmN7ZsSyDudFCixSbCeIjtCYhtPfYOmfbDppf2e2e81J46xdcsYv/OxeTS3wvVYsrDJS2/9AycP+O+xEV3FE0miBO2JjD7FfZVrRL7nHqbVpRqt93aJs/7dSyGolVtudvBzgXHR2Ylho3GmBHb3geR09ifgWc3BZ6GIz9/lslBZ0/ermM7fr6kjIPgtHHNhZ1sa2h255ExmHmSoPlNT/5EZLdbL3rD8hL1jbG3lMkO/Q69Gx2/Ty11HZK+gwBiEAUgFUF0nIy3NwS0zfjRi06TBGVzj4QkH7U
 A4QLpSvm
 nz+s5S7ytpge/1eTmgnBh/4B7eT3ruAvsnxAjghARJcnbuF6Am9Z9WWu3IWyfAO2k7tPPfs+FwLyB4XKVGLqyGZj2rH6+sYPCN7FNPrPHy162D6Awckf3seGR19HAiK+db95B4wFhhvjx5pFAOYsARFuBBVEFwhRnqc775V4iPnYznbVuVHWf83nkNnMICp5N8/elXXGx33BoHP2zqhe21vPnVyoPEmaooGwuHH936OA880ORYpeMJNEYEogIRUQGGbcLSCU9pzn2q7daseP5IDvfBTDVJSp1j1sPSHimV27OSa4l8dlTxKaaQVuJgqAyxJRhIe75nyQcF70E+sA/rTOH916YJuWociNEYxXb054fAq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Reading /proc/<pid>/cmdline or /proc/<pid>/environ can block in a device
driver, or read device memory, if the virtual addresses point at a device
mapping.

Ever since commit 7f7ccc2ccc2e ("proc: do not access cmdline nor environ
from file-backed areas") we use FOLL_ANON to only read from anonymous
memory. While GUP properly handles FOLL_ANON, __access_remote_vm()
will fall back on GUP errors to vma->vm_ops->access() without similarly
considering the flag.

Fix it by not calling vm_ops->access if FOLL_ANON was specified, to
truly limit it to anonymous memory only.

Fixes: 7f7ccc2ccc2e ("proc: do not access cmdline nor environ from file-backed areas")
Signed-off-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
[ david: simplify description; slightly rework implementation ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 1a0ec09c56fd7..d4370c1b331c9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7398,6 +7398,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 				continue;
 			}
 
+			if (gup_flags & FOLL_ANON)
+				break;
+
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.

-- 
2.43.0


