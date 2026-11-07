Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D544F606EEB3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DsK7Pw9l
Received: by kanga.kvack.org (Postfix)
	id F006F6B05B2; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD926B05B3; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6706B05B3; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD9A96B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB36E14018C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
X-FDA: 85406458074.30.661BEE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9FD4D20002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsK7Pw9l;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011815;
	b=sLLS/GBMNKqjTDBlSSGrdl969zj3by8TgO3u7UiGacXjCYjcy2csv/klFAOZsUxDO0wdQQ
	x6frA8lLYYCzOu7EU4E/+VhWjwg71s2+ryTyQO7gUUxgcPL0zBk7CUrMAEV+m7Z632Eu08
	BEjPDJx4qd9ZusJCv/LyT8x443i0+HE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsK7Pw9l;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011815;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNwul7zJGFsHKwWZpPtjRY0cIC8DT7VRwlkbbh/D6mg=;
	b=3M6wNgzYieAkoHTbrTjQkwfjndEeqeNOHbb5cU5HUsN6oCgxyZRw6J81XX2eu98gW0+TJL
	TQBgdX6S5hOq8Nq3+mDAZ86RSo+vL0h3DiQEfYbHh1Ea/f9lfJrBXmJesMg9cRriK3Wm1g
	a5cAkPz2AkQoBDoPi52DlA1qe0Z4oj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24BDE42E02;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011814;
	b=Big+S11Te8xov+xmYlWTXp7PJetY3k1BSWJCbvOIfCUbZqmPMB7HGqOhrSEV9LVrJw/P
	 9hnb0ce22piYHsXM823BeGFKpxJRzSrB3kjNaA3K0e+3+LU+Z7gX4TohF7eD2JTOPEzkm
	 Fp15skEMYQ/2lttfXlx/BNauSrN/vX6nmYMSgB508ijNL8Q4XN3fFLtnyYPYVdvOtleX+
	 VpvYF7FWdJT6jLdAG0/i/DDUMII+hdUTjOQhTW/rNMtqxn/kN3EBXniSctOnHsZL0HmLW
	 HjOcHnIkUFLOvyhydBFDUUZDqx+1+5XP3dxB8MfCncBMO+kxgZrIKF5f7WKxsip5RBA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011814;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LNwul7zJGFsHKwWZpPtjRY0cIC8DT7VRwlkbbh/D6mg=;
	b=jJ5VuJc5bSU9iLHbyLa7m8IeOxwMYTgC0WDx0Hp7GqRfzoQvtwr0d3bKLBO+tM7DILQ0
	 IxRC334GfEc/UzWbybDXAEU8LeexzAnpOZ2bMDIboG43jfIGZEET4FpWgzY1UhLbbeHNo
	 k/jU9jB31L2sDPttu7nIJlWaPOz858Ml4NQw9HEBDvzYgejMBsq29pun+pDPA25ZnWtfS
	 LLS3Eel/edGath6rJv6VNClJXAnnCRPFaq0fnfFg3eiKn7EptnrnVfbgg/XPA0xgHeXgB
	 h6oXRY95vKJWoLbr92CHNul/Ai/bxSlVTOsSXaiafz9/gS8j22ffP6mubAdCN/Qzrgw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 54DA31F0089F;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011814;
	bh=LNwul7zJGFsHKwWZpPtjRY0cIC8DT7VRwlkbbh/D6mg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DsK7Pw9lfCuc6GlTfLe0AW30dYomSQ45g8VkRcyLIlW5ESJDtt9JHYfJsxY5nK3MT
	 0GIgpC/2u1B4O1jh3WhE6zVlBGmkka1ea2Bux6CNz96r6hsEtjUNqmjpUboDw7dnRl
	 qwNxSDP6NMSYET8iYA5UsUiQ1scFHjGp2/6UCHl+jJwKzoBPb16AwECoA8FFlDE2YQ
	 T3piPyAIlhCHUmlvCi9QPDBMi7PA/wmQhUhvEqoHbDiiazSNy8uhxwO2BK6Z8dqxun
	 VdfKr9iHBMS/waqWy0ERnCSPjZYja5rmFi2Tlqi9D9zFLks/oXLkbOxJvIE5/HfcyC
	 rnVneKQfxH1Mg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BD8D44790F;
	Sat,  7 Nov 2026 00:36:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:35 -0800
Subject: [PATCH RFC v3 01/88] KVM: guest_memfd: Split folio allocation and
 insertion in kvm_gmem_get_folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-1-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2189;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=o3ab3dp1L8d6gPAYkDQmoexjLd9lqXL7N+1eNWmNlKs=;
 b=XgrUtCJ/aWRVJB5VTE6gkAa9uuRn419O1xaO9zrTU5VolBTKlyZwWbNUC8vSaC1I22UUI+y/I
 lnN+VrNouelC2/BHQOpFwyUaGjqOIQU9E0vaik0bSRmm2KnM3CY6qQj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sqcpxk9tndprwsg1tywsazhduh1xtq9g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FD4D20002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011815-921557
X-HE-Meta: U2FsdGVkX1/qaLkJhGG4us41+PVHoSzeKNQffVptJsGptTj13K6VN3WmuWvoHCcU6v/cAl40/GWAQIP+nSSPCP2on6BxkzT/m+D3s6pqDazmwclv6D9LuU8w8QijjaWfpXA04kUlLXVgu4KUfIiQ6YEKCiZFDDQVMzePpsOXPIKkkLM7MjvKnZat3aYfAhwfhIngzebEQjd5ulZlhpm3jT5Dpimzu8bNo/yLtJHZoELy0iAy98ArDoL7lu9IUWk2Szch+36AdmPENN7mw3L1qWZWIrWogtBDHz5Es4/8/cCs5xf5rKljuSukLeacGmRV6SxrB6bB5R7nbxS9ujAdlLuOr5ffvVUXmbmRKen/39OpwtL5c9QvIeesOROx3ScUHN/wrbuJNPLWyStGrCl1DYLP41W6vKrRpe9Zs0U6c22U3bJKFhK+KF8EFmJS1H1ru4O3fyCrWqejOTOq/1N+eIDLQSecq71V8xrR/MMzN3WUJJMjwxg1g9pdvr/fJiUByyy5iqY2kyttEU2rbf0sOCBsvW2ThPGhgIN44LEprNPTOdt/SDBh6SnrUGvOkMjeUwr9J1U7haH50k/otcfKC9R0S44sg8i1435ej7ZTdZB+qIh/l4qw7Sgkunb0enl4sSO4xTHbeccBo3unxfmEjn1PYZFs6YYQxV+dHQ4qybAl13692X+0UyK/Nme6SigHQDiYheawiPH5tn66CRvI2ug1phIclwfgxIN4grpRJ4G4lHJLw8z/aA5SKdRimLsDus/Ejcb5ppE8lL3o7xgMgXptK1gi/KRswal5FkjEeOm9Q8QyXpvQPmPvmGnX5AIAtPT0Fcqj+Vw/bNnXyvS3x4lPZiaWSWFfxL16zbBbENgMxhIq+n9fkP8096ZSK4M8RXnKCuaXNPVCaCmobla+AyQR4V+lka5+DXfZFDzuzCOukdieBgNGuy5f1kTyxWzr6BinYQbWQbbQddp/zm7
 h9t6rjOw
 50t9eBKbXHjAAfzTmxlKqe1ECLyoJxP+q+6QXZP/q/Q/vVjq6qH/wYnDjlyfuJjCmlMBrzOch6NOlhCOccO7sfnKTA9aQLEXP2KVBOU+RFI1CFBrKKIkhC0F62rhCqkge6cVTjwN4HaB5GiULDR7QQRtkRDjAVjY5rxwx5axYrsQ7O2GEsW6sZmf7CYz7opgoJy222qJsbQnq6j36/zHnLlpytloqviIWD5fnps5ZJU9kqDLpjkv5Q5idz+OR1bnmgMV41rur9XLSyek6MEehQbVhyg9+DDXe8YxmeN5fhlmmeDuwDBwGKjJ3d2ko38/M/dUe5foLH/FB2lCEDaHexxvgoRhOiLAWLTxDo+bJcXbTC/ILNUpG/Cgjz7VoAI7o4ETGnJxKCwXPWNw9+JecbDyUs66sSs8NwshCFDZPHxhQBOym47wNWtFgh9WEK3SD405J9ICqH0h1tdpz5kJziJPdl2gJZNUhqwCzciYQIi7MMKNTTm9bxKXx8Q3uON1Tyr/JRzHGz+KVWZ9472R7rsN/w6otwKEq44JYLepcgbDYKFGb4ial0Q7d4QRX13bz41VC+NOCigfhZR4wnYPKCjs6QbKnNIIDTFu1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Separate __filemap_get_folio_mpol() call in kvm_gmem_get_folio() into two
distinct steps:

1. Allocating a folio via filemap_alloc_folio() with the NUMA policy.
2. Inserting the allocated folio into the inode filemap.

Handle -EEXIST from filemap_add_folio() by retrying filemap_lock_folio()
safely to manage concurrent insertions.

Decouple folio allocation from filemap insertion to prepare for supporting
other memory providers.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 93f3d29d5751a..f865fa0e46840 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -131,7 +131,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	/* TODO: Support huge pages. */
 	struct mempolicy *policy;
 	struct folio *folio;
+	int r;
 
+retry:
 	/*
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
@@ -141,10 +143,19 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
+	folio = filemap_alloc_folio(mapping_gfp_mask(inode->i_mapping), 0,
+				    policy);
 	mpol_cond_put(policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	r = filemap_add_folio(inode->i_mapping, folio, index, GFP_KERNEL);
+	if (r) {
+		folio_put(folio);
+		if (r == -EEXIST)
+			goto retry;
+		return ERR_PTR(r);
+	}
 
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
@@ -153,7 +164,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * to be updated for anything otherwise (e.g. page-clearing
 	 * operations).
 	 */
-	WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));
+	WARN_ON_ONCE(folio_order(folio));
 
 	return folio;
 }

-- 
2.56.0.455.g6c5a503b38-goog



