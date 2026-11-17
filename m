Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F125F606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bcgaae2p
Received: by kanga.kvack.org (Postfix)
	id 09F7A6B05C2; Tue, 17 Nov 2026 05:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076426B05C3; Tue, 17 Nov 2026 05:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEC96B05C4; Tue, 17 Nov 2026 05:06:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6DBF6B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:06:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A3831C3AB8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:06:45 +0000 (UTC)
X-FDA: 85444181970.13.8390C00
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9304440003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:06:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bcgaae2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=danjwade95@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3ahOovwjDlDqMNZ2Yyn08XyrzZ+sm+Yb+nsv1sSKI48=;
	b=VQql1VzzkYxg+gdXYxIJgUuRhrezNNnfo80fgfti0BifCMdH+yNtw9La4ZgpoqbylkbHbE
	Kkf7oi6xB/EEWivxBOJw8lg1wyV3EgqG/ZuDWyrae2Ap1nbJ01VtZ7baFBnqYTQO1NMYXP
	YaY7x70GD3gGNbVlibAZIf3e8FkmioY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bcgaae2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=danjwade95@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910003;
	b=2PIctXNM95QJVxeZjAHQOq0FEuNkpj1rQCsh76Q/s0ArR907p3+kMOpkV5ah9FLsRD86KO
	hfUMO/gxLIvylrtq/I+NMLJEbXPK3EOt4pExwib1eE3xUMa/0rqAR9lT1ORhxFbrQocrjD
	eyRo6gLQrgV+XIRKbBfLVzNquhFqIC0=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b2382bf051so2508659b3a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794910002; x=1795514802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3ahOovwjDlDqMNZ2Yyn08XyrzZ+sm+Yb+nsv1sSKI48=;
        b=bcgaae2prCUIFzeppM5tNuqEOPrrRfEXHAiE3uSqw0RWoaONpNFT8AzX23yiGQ6Iz1
         CNOFGeyJ0OBjpM438h2+5E+QDn1Ge2eqvTYwuuFD4gwo0Fa2XcXwPwM25uHGJX9z+tq6
         zvuGD3HdavucUOMrpaI7t4qbyxEtEPNv+bm1eRQml1H1716gqoXMIXX6bvz7iKuByPDh
         FY4pRXW9immu39MJ1fuUGUr8d1DzWOPdUxvV86yASv0Fl++i64Ghyf9v2pGUNO+RDH+a
         sR+cqDUT7bnvQwCpPQ/NSAj9W0XzCUPnu5nbReDJSXfXuHSar7Gtd+iA0JeJlo6ex/SV
         OfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910002; x=1795514802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3ahOovwjDlDqMNZ2Yyn08XyrzZ+sm+Yb+nsv1sSKI48=;
        b=EjiSnCFisKJWyLS6RIg3OzpVE/zJoxkFZVZtTvg6aJGM7nhs5G3g53giTY2L0BKPmv
         R7Nh4JU8rYse+938VRNtrdFdl8m5P1iHvthgU+n5Ay56/PXJAPekx0lFQeHMYjkYkihm
         FKHeTL6Nz9trg3m/G4wwcBpdN8D9od4vfg1rNdLVX7bCBxjE2c+CagLQtjAq0C82RrUH
         RcPcxqZiyZkZbZX/PB5QdXtof/Ng/n3XXxD2trBuu7SposbBiVKAzPomrPyiwnVAmYrs
         Adu+BZ6X8BGr4yO9G+QEZ0DDbepELJ/jwefF3NuOT8UpERUqfEIKNLsaZ5UJksJ8BC0C
         vlfg==
X-Forwarded-Encrypted: i=1; AL+hErEDaBDId4rIVpJLC3cJDP+NxAhNxCyf24Jv8t7pFPjy4hpg1kylptIh730qOWVbZlsFkBRU4V+ucg==@kvack.org
X-Gm-Message-State: APuU4Z8qN5JEV5vyyGLu7+VixV+PRcOqE2eHl1k8K5bD9UYIYFErHIru
	8Mltx62Nf5342zUGDmFe+DcJHSkATI5MIiTwq5hrmODMVyOxVGtgBQlL
X-Gm-Gg: AYBFou2H0TKIRd9+ZKyXPhzP9ONoTBrW2K9l3J5bBk9TbLX4bC1VxsxI7lgXIc4LMO4
	PY7c3X4OIBK6jEKbcwJnWdcLs5I8WNPOwwVI8j4aufxRQtFGR+BsI1/oZ3iIwvAFJ7ag+80E2rG
	yJp4GMdqGGEwZYr2UrBSker4hdVIJavqbPf8rRaScpBOPj+FVBw9ftm6OpwqBYpLNpvGTtM0xbr
	9ZRNx4X8iWNa0IlwOnss7H1Yxjx69bBI9BlSpLHhxOZE7E58IQVZ9AzitncnP0GHqRxZXyb8meC
	3jJwEP/IGl934ngYAzukR1ur1knN+lFA4rqqqE62tJYLcgg1FinwYXq8Yeddgg5hW+Oga49fPee
	Q+MCp4XV2Pj9cAXYoKmie5BS7Y+lod7/lt+Z6sIZ2VZ7DYhpuoD6FU0FoV1phW6UOnF7PBfDZJI
	rR4dGE9+pQ00tG2CQuL72MFEtxC1Z8RlHWK0yK13nqln1wPbM7Vu2pth8x0NVXa8jtmSYNDWo8F
	zRh7eUX6NQpcwnooYZlrwZ5CAiOnou6prJJ6PK7887TQEzibkjhcdg44KLTb7YbXlbrey4OvpuM
	SmKZ2k/AaS3Qsdjtkbtl+wq+wKWRuAYhXSprHzTRP3D50UwRc9gntn3heCanhjdgLhoMyZxbhG2
	HvYeLphsxwawT1r3x6f4RtiM7UxHN4ExuOb0musIVG6wmjI9jw14vhtOsyiVfXngOv/Y0WQB5hz
	NNY8aeMeuL9gZVkt51F6mW4OZWAYwmfNuc0575C7JUZX5ylTbly+4GeIc/QeBXG38KJfjonNTs8
	zZT6cShXsZJtr2rvUcp/Y6mpsKe3Y4VeVCsHQlH1bKXtB1Bf8+wLDSpWNn1juaZ
X-Received: by 2002:a05:6a00:13aa:b0:897:d037:f3ef with SMTP id d2e1a72fcca58-8beb7d1cd51mr11380228b3a.30.1794910002249;
        Tue, 17 Nov 2026 02:06:42 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1d6207fsm5213337b3a.32.2026.11.17.02.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:06:41 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/memory: mark unshare copies dirty to fix MADV_FREE data loss
Date: Tue, 17 Nov 2026 20:36:22 +1030
Message-Id: <20261117100622.807-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9304440003
X-Stat-Signature: amnwy4ydms39kj8oe94n3dipasi6yz5x
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794910003-318805
X-HE-Meta: U2FsdGVkX1+BwvKZujdyrcP8a1ZM8YqGPyrF0ZNMclg1r30aSR7cX821n2MFJwYZ0WUf+WFIXqWN7z6L4I0QOsWYeFRumOIfkiUfT9vWFsK9+WoyEnNpioZ9QJcUoZM5Jkv82ZdIrZuyme68ejrZ+zlCis+0pZgqWyWEjocEfNLnmP3viPnjMTrWFhHSwRWPV/I/6ynvVKGW2paoYhHp8SsamsX3whtvxnalU90zJ8P+/o5rDoZwnyJlxcmhP6p33CrpPFtCaYAQ5ojekQDK73/kevRxTDjLIWGMVK08RJ1mUbVs5ls4EnnsC6+AxwnYEdnq8gTceX2phSAgabSxbkm/cgugJThV4hQXDamA8H6+Hr1QKSpr3sxTV07nN/PNCIKINWF941brMfSrVf7ckut0lVeX/PWAg9sOz1P/T8skpPA/5rJEvFeL9HF8955Jetd5VOtzkpLQsk4C0tzGXFIXqdjmb4mSdplAXb53RjwDz/dJyfRilK6d4YeQjzTBkWL4p4QJIpl7rmAOr6aFL+sGdIuZYyi6kvbtzvy2+fAKpopcTskrj7pytzxCmeIbqlUInBDxNnBXUeGwahUGuIuZyIt0MLHmMJzPN0EEIz5Da0+jdI1alFDATYdyLmAPhSuDlq/7qG5C1MPuSdqIkUbYjiOZ3ez88iAyJc4hN19YYR+HoZWv+3iYTP4N3LTGTNdhtAK3EOPNwqw/h5+2IV/TfKYJSrHzHqWLdM+2iMqXTRTH6DMVsq1kFfjCoPORLWdqJdC+yW7owMNWPJZGPRYz3W9YIduABYJY1ExjPxeAwqAmkG5+VBQQmw07iWhw3HIVmRPcYAmHvIlbDtW1knIqdUbimZF+mpVHyU3H1koa8/NbknGBYl1gKBdQWujBM/HTnII/AVivUFvcnqtm1STs3cjnc2f/SKR1VcgURRs+oKGtozKnw4VMzIYhz+LG9eUDWmyAFcvHX9iJwS/
 avzy+slt
 MsZl1WMMK+S5Rp7tZGVWYzSyawNMNZx3GEYevf7OtRNjBVIEMfgyLoRu5BX/XCgesdjZ0VHp2PIfx+3KlcY59QOb28iHwNOx0+wWPGKbRNMBKpex/IdHplkbEKu5Cr5yApOs0XgpoieWJsodMQVmcb62n0/8BGfNn2ToT2l9WV2yhNJb3/QiXT1++9rxATGuVeHdO5w2+RjWv/QkvfLZ9TLIMzRAsWfrGynFy2qiSlawBpo/h/+E/6Zg9d2xdRbPELRvAkmA7JOl2fEuU+R7rOSB10EUtHlCqdGqVjPTxu1nkutW6PZKzLgjom12QFlXZBPv/RuxwR0g9EkQPTOzhuvyNAtTQW4B04EMZATj3RKR0q1YvkY++i4rnWpvwLsmG73pQeq3QNqgzrJpV9qGsvvW2lk63WtrVoqTbMEYgfWLSlx0kuRBE1qMKeYB4bcVbUyLzcKVVFugFh1dl9AfHp26eUUv50pxPE16n3+UewTuo2PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wp_page_copy() only calls pte_mkdirty() for write faults, so the copy it
makes for FAULT_FLAG_UNSHARE comes out clean. Nothing marks the folio
dirty either and there is no swap entry.

Unshare faults come from R/O GUP pins, like process_vm_readv() on a page
shared with a child. If the process forks after the pin is gone,
MADV_FREE in one of them marks the folio lazyfree and reclaim frees it.
The other process then reads zeroes.

Mark the copy's PTE dirty. pte_mkdirty() also sets soft-dirty on x86, so
take soft-dirty from the old PTE in both directions.

Side effect: smaps and numa_maps count an unshare copy as Private_Dirty
or Shared_Dirty rather than _Clean.

Fixes: c89357e27f20 ("mm: support GUP-triggered unsharing of anonymous pages")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
v2: set the PTE dirty instead of the folio, as David suggested. No atomic,
and the dirty bit then also survives in the other mappings.
v1: https://lore.kernel.org/all/20261116111245.28871-1-danjwade95@gmail.com/

Tested on mainline b3dfbde62cf1, x86-64 with KASAN and PROVE_LOCKING, as
uid 65534. The test gives an unshare copy to a child, has the parent
MADV_FREE it and a control page it alone maps, then waits for reclaim.
Without the patch all 4096 bytes come back wrong in the child; with it the
child's page is intact and the control page is still discarded. Same on
v6.12.117.

 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..113b305854d5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4130,8 +4130,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		if (unlikely(unshare)) {
+			entry = pte_mkdirty(entry);
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
+			else
+				entry = pte_clear_soft_dirty(entry);
 			if (pte_uffd(vmf->orig_pte)) {
 				entry = pte_mkuffd(entry);
 				if (userfaultfd_rwp(vma))

