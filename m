Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14E1F3C9A9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3D06B0093; Wed, 25 Feb 2026 02:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D926B0095; Wed, 25 Feb 2026 02:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7506B0096; Wed, 25 Feb 2026 02:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6546C6B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 267DCB8D35
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:51 +0000 (UTC)
X-FDA: 84482131902.12.393B5E8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57D251C000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tSv3skA+;
	spf=pass (imf21.hostedemail.com: domain of 3z6KeaQsKCOIEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3z6KeaQsKCOIEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVs0Hnm474cWoV833GLo9MNmWlUj207hFkSykyvopd4=;
	b=Y13e11EFE6Xi+WOFuWNth7QJMS8pUZxEUTZqWMOG79NmKTmgm7dxqPtwmyrutffX1TFJ4U
	Pcw7xW78ymuaLZhx7mWvbOoFMxvAHx2KSOgS0S9/X4MLMiwpTERplA+Uw5u2wRoMX3RfsI
	cZkDPMA4+DRSrET6d5AvKSAsonS5U6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004049; a=rsa-sha256;
	cv=none;
	b=v1VJqeDCKde5EXCONzjHj/41bH/rLs07lsHI3uk8zvwJ3w3DWQDjXSyTKqYP7VnrkAxjpW
	HKbNzO1FqxgZSQRTF0wAHYEvsqh56JhqxjvnCMtCzfeNVNTf1NPpi31SUxykVgZO69A/PN
	bXH8oMEWBMNbQbmpKOeG5OQndv6AlBY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tSv3skA+;
	spf=pass (imf21.hostedemail.com: domain of 3z6KeaQsKCOIEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3z6KeaQsKCOIEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso1816022a91.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004048; x=1772608848; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OVs0Hnm474cWoV833GLo9MNmWlUj207hFkSykyvopd4=;
        b=tSv3skA+XyruWif3xoI5k6pAhCIfmMEwS84zMcPAHiuhXsP6EllRGefUU6PT0rMKZV
         fdA0Ooa17xWOnnmZLbcs3hm02qqZSiKJTYWwiWcRyc0CL4BQqPp4xSeoL8h7vOVsK7lQ
         SYAS6DxZp/UYFTRwEhSDObSg9OuxBAegtCNR2UFkYsMzBGPQjtVK3KdaM0zVUXq2+foV
         Efe+ujVIUXjuySGX84VUx7tG+YMtpB7yAakIkq87tELmQBYCoGSHT/hDx7nYp6ZRLQqS
         TaQ4AM+H4umcGSrXWGDJIRDDwXOmuweBWyS6V0YCDSkq59EywzxNOH82OW3bXdbzJWNb
         mTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004048; x=1772608848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OVs0Hnm474cWoV833GLo9MNmWlUj207hFkSykyvopd4=;
        b=wpYUjBz8m2PCEk3Flt3v5/TynXnOtqntsGcGG+6QO/vhWWPz1g9RdLXA7gRIT0B2tX
         7pWu01o4r5M6NYlViGnwSb0oN/YISKbcQtnPFWuXJ3T4/fiacfGxnTCCvOy8Eu5Nz+Ke
         20qTjQSiNHmVF+EYw2iaWlAv4MtHb9W1JzeMoWNHWyIAR6ZMLNuXC3edNFme6CvIbtmO
         rnw82h6v8L2kCUSM83tlSPQTDtw9O4/nXc2l9DG6K6qGjzyupDDkwKU3QAH9aiarNlKz
         pxjZSmHinKtaJQYMD9lTUuC+uJUxTn4paiNx3tEqS55n9nxZu4cXnzK2TY//Nw1+dgF6
         Mw/g==
X-Forwarded-Encrypted: i=1; AJvYcCWiTDBSVWDL9vz6My8R4uE5wBIADXuqYnnd0oM6uLbIALHFo/VB8/UMJZidy4a9a7sTHMi0vKKZcQ==@kvack.org
X-Gm-Message-State: AOJu0Ywr1Bhzs/uU4yo7UNUJMLxv6ez10F19iWoCXo3mpek7p23obYp1
	49Y2usE5YljgH8czSkHCgVgAPwENjUQFucnvDvA2LqSlKJhf/C4XoeGIlOISajv0r/psv5JD5QM
	/oyaISnrS/JzP79BGNNo6zwdBCg==
X-Received: from pjbcx18.prod.google.com ([2002:a17:90a:fd92:b0:34c:64ab:be12])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4987:b0:349:7f0a:381b with SMTP id 98e67ed59e1d1-358ae7f824amr12058965a91.8.1772004047924;
 Tue, 24 Feb 2026 23:20:47 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:37 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=2942;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8mavK4GAEJyfzQeJv7/hD42p9ioK1z0FeEYGJdf10ss=; b=n5HyVsPKnVDH4PevFzPZC0SURMs/a4aw01ly03D56U81pYoGm3xjhy0a96R2oMYy/oWparMvX
 0N/vWJdxHi/DhAl1wJaJFq98Amz6oOt1OmvqMUx13/SxRSVR8WBVXyz
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com>
Subject: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: fwdq9opacyd94ijw6kqj333w3kgyyyah
X-Rspamd-Queue-Id: 57D251C000B
X-Rspam-User: 
X-HE-Tag: 1772004049-577275
X-HE-Meta: U2FsdGVkX1/nsYbo8lzx0oWIs0zY1SWEK5lFz5oVehvBnC2mYa3rs0A6WV4IIwih9LrWrtdsTiSxjWTHnBzhh6uiqp+8arcqpqaBqrMeEgtfwhw8xpvJ33ksS+na+L2Lbosf+y3/NcB6r+gmATsY/UppefROXRlxDmRCgKAUA27OJ9ikyQYOxxOiSqZV5COLf9oPr9pP2Ic0rTFs6Y7EWkT7ia7vHXzBijYET9sw9mKJ4qkYKz/m0xxhFmyjsobRWK6CnuVgRNsG7sqFBlSGO1zn1k27elW5V9g1H0kipiBhlSwEGWGhdqtrZWgmso5Tfh+qW13jefRpFDBx+HmHVkfk0Bkx/4vVPXXLOnGJlBrbPP/Ep0vkWo0g4pdceFimsQObGZ+C9/7akkmtsuTQMFhjUyfTTIf7uwhQH3a5T5sXyb+psiSSTTsu50DMxmmbcCLN0+eHzTNSvFyGUOsYf9tnVac0rrucv2wbvIjI4DVYfVZir58U45JIS1QantU4pqvWNA+rutRqybLP2pQAv2aPIdj3l37ZsMk+H8DXLmNkEtIjfkwbEVXBfnUiGdhm2Zya8giV8yHd8RXkvs0kKmWRZhIrYf6+FwRH5Z83HuLcs8fhUqfPAPUDO9AfTe93hmZEA9YOYEcuk89dlOhdPuTfbXNa6YfLFY3L2oKGFFXMEXMKGxoHxFAzhPa0LeDLDsps0XYXc5YOJ04JKS3XzaKI/gK67vCFf3F6yjMdlFsNWIA/IquknBpae5t4H6BFCUOA8+m1Tb5kGhqh5DY8rdlQ1EtE9ePMNiFJH5bFVR+ax7zMsDGgLs7gXlR9aReJUyZSUvB8gVlPmxZmWCuR3zrgIPcwC7t/X35lQiIaQQVi5Vti+ETuAbDKSos6Qtum4xGoJQWeVLDDVm8sKH2EiDv6f7MRlcqca1KQ8j399NP2rusTnXAftl4JO3QG7TqNEnZFGFg8yS4bPYqQjr+
 MN55amyR
 OdSp72mfAn1htp2zqtKIVgSQUhRjJkD90rdXnK8vKkqkdNo7RO74Nzj7+vDaykEVpWz1OB7GvbCzvi0OoOp3ggcNjMeOyCn72GcOLGVv6bj7bjJPviPa13QQr6rQAc8mpbbmIxneOWNy37JE7MtlNLcL7Km1iddak2EklwcnABHA3c91TdBKXvMOvSQwBbBx/7zEQghY/A2gcb69Q3y/5XV7GstU1NPnFOBooGTIlk/YPXGXC5qLSmdgGehE2pxRKjzVgRaZi8UzwhEnv6Ss2E7FaO5I6sphmcbTHJ/p+7w4wYUSnYNXCxiNjJU5l40eCYRzOXmuId1ObxqRiMBTflHdwQvAJcUbHbtRiQIKGM3xBpk6kvA7qmQd1laFCaEn83z5ZoGNLkcH6oNKjdN7t5RoBPchJ1Fu6ZdoAyD+A5+xGBgS5nyh4GSCqfMBK51y6698CvmZDIygstkJaEa0vCUN3w50bQEBe8r1yGoyZ39A5UHe9h6LyQjMeStzIp8O4UN6QgshnBHXSZAFDoOqq+l+G2Lbk2S4BHZfTN0qunUHTKreHjGEPQW6xAgrFHOAn/UthVL5tzS+NiD/UqnwqrVqWZAuXvX/PHA9MnyRQfPTVjtT1Y+tGnaQde+N7K3fOAMxENhYyeEjrG52Nr+KF+wLTqJJL7rvrVgLpM4VrLwplnzzB5nZ0FV3gzIOOJA3UPyXjxHslFl00Kf6kSOY5i/eElw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
adds complexity for the reader. Since guest_memfd doesn't meaningfully use
any of the other FGP flags, undo that complexity by directly calling
filemap_alloc_folio().

Directly calling filemap_alloc_folio() also allows the order of 0 to be
explicitly specified, which is the only order guest_memfd supports. This is
easier to understand, and removes the chance of anything else being able to
unintentionally influence allocated folio size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 51 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2df27b6443115..2488d7b8f2b0d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -107,6 +107,39 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
+static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+{
+	/* TODO: Support huge pages. */
+	struct mempolicy *policy;
+	struct folio *folio;
+	gfp_t gfp;
+	int ret;
+
+	/*
+	 * Fast-path: See if folio is already present in mapping to avoid
+	 * policy_lookup.
+	 */
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (!IS_ERR(folio))
+		return folio;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
+	folio = filemap_alloc_folio(gfp, 0, policy);
+	mpol_cond_put(policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	ret = filemap_add_folio(inode->i_mapping, folio, index, gfp);
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -118,23 +151,11 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
-	/* TODO: Support huge pages. */
-	struct mempolicy *policy;
 	struct folio *folio;
 
-	/*
-	 * Fast-path: See if folio is already present in mapping to avoid
-	 * policy_lookup.
-	 */
-	folio = filemap_lock_folio(inode->i_mapping, index);
-	if (!IS_ERR(folio))
-		return folio;
-
-	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
-	mpol_cond_put(policy);
+	do {
+		folio = __kvm_gmem_get_folio(inode, index);
+	} while (PTR_ERR(folio) == -EEXIST);
 
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing

-- 
2.53.0.414.gf7e9f6c205-goog


