Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D0FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B588E0036; Fri, 17 Oct 2025 16:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6918E0006; Fri, 17 Oct 2025 16:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4119F8E0036; Fri, 17 Oct 2025 16:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 271318E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE3521197B0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:46 +0000 (UTC)
X-FDA: 84008704332.25.7A9EDAB
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E7E840013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TzyIFFvj;
	spf=pass (imf11.hostedemail.com: domain of 3O6PyaAsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3O6PyaAsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEyR0XL/MWXdmch8mXs3I8lfirsundW2Xy7Ox9OKFCE=;
	b=znJRNlYaY0y4m87tuaQgtbbk47/3phgFU8FSyukZvy6HEB7/mWj5p5zab6u+E06DC14sIh
	n1vuNnQWQr4Kv+3rr+xByvxFgjyxzc7SQODP7EbcFnSr6PILpXQqkSh5GrlwgW9GyEUEQk
	1M39zA3fBkfdSacKCPUUWcAbg2ck9kc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TzyIFFvj;
	spf=pass (imf11.hostedemail.com: domain of 3O6PyaAsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3O6PyaAsKCJo46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731965; a=rsa-sha256;
	cv=none;
	b=AtIO3cDWQQGji3Vd4oEpcAu5mUdfA4KUZ2SEbt7z4MclPwEjT+dInz8x0+sgatYYCT+xYH
	JpZGUgZcmeWaxSnY3a5MgYcproMzra+jIuAaUSHF3b0/F8DahfgSbinqQcqUbDp+kViv49
	ywDM0pgWplkHSWOyZwEntrSRKgZwDrA=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befbbaso2806079a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731964; x=1761336764; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEyR0XL/MWXdmch8mXs3I8lfirsundW2Xy7Ox9OKFCE=;
        b=TzyIFFvjZ79t1u15XjcepY16EjUNA7yLfo1AXsaZJtsYy9JiS8XhlJxOeQvwnrIUZg
         1/fQUDQXrpz+L+T8NvJLKP/gRbKyIo1HA6xzEtZ9KV5i47FS0C9mddiKDqSBMb8u48F9
         Avac2FVjPRlxCLs0iZhLw5OTnBki607Sd2X86Br1+0KeCJmwoYPbJB0Dl9kgr6PL/hyx
         SijB31yShYEbnwsLGf46UHt9XEVIweWdFa/XQBnO7wcY9aMvIf126y0+NhhuS86tBavz
         vEZeX+0Jo+nS4uC6GnNcZ8+GqWP94C5Uyts1fDJWPRFWzxCgxnVX5yKsj8qXEUEt65zT
         rxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731964; x=1761336764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEyR0XL/MWXdmch8mXs3I8lfirsundW2Xy7Ox9OKFCE=;
        b=b1VtAs4HvkrnornKj4qHC3VIcXgIWziVSeTISo6yODDOeqvbBpUuOo+J0P/y02CZp6
         qxgqgZi+SsRAPxJzX3eC4FoO5DtrANjLWCZkHXSTm5C6Tc6kap62uRwQm+oREcC0U49r
         1f+sJkwc+dQ/dYmHsB1c3ldLUP55jl6AQGSk4SUkHSv0KsHzzlkgwpqGV0+VNN7X5mtY
         1R4qBw6xNpfJPDr+zsvLbrscwQCQtbnK0dFKnt+/viTHEs+UMe00143sxDvCybOILR90
         dPbNnZwe1EI1ZYwmMLvWJl+8tmFtCYptjoQKAnU8YmN/CX8G79ZK8DN1KV49h4TlRkT2
         AmHg==
X-Forwarded-Encrypted: i=1; AJvYcCXGVju4bGDeczUfQpw7mbCgcLV/G+QEoehPyEtnCi54tRoWcyGT6edr+2cijt9WZH20+OBK/2TVkg==@kvack.org
X-Gm-Message-State: AOJu0YxroWoMGQCyAbdi9bX/HqafWUBpKQurBVS/r+A+T1FDl1STF98m
	Ug3tSMK9EP2qL2YAP3L8POxyTUopAQJ9NlB49pcCSSsk0Z4EOBNackiSAT4InADI4QOO4p76Qn0
	90VWp4fhLpNsIoyo/j0Y5lkEbyA==
X-Google-Smtp-Source: AGHT+IHrQmqbYBW8ZTel8gzz7v5OWEpv6AM6jQheWufRBYe3rBXgy4tqsdy8Q9e/A/F95BhCIEThHHdEEQUejvT3gA==
X-Received: from pjbqx13.prod.google.com ([2002:a17:90b:3e4d:b0:32d:e4c6:7410])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f10:b0:32d:17ce:49de with SMTP id 98e67ed59e1d1-33bcf85130bmr6655444a91.4.1760731963857;
 Fri, 17 Oct 2025 13:12:43 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:50 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <02aad35b728f4918e62dc6eb1d1d5546487b099e.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 09/37] KVM: guest_memfd: Skip LRU for guest_memfd folios
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4tu8te8b3j13dukpj55dtd57q8eucjew
X-Rspamd-Queue-Id: 1E7E840013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760731964-91386
X-HE-Meta: U2FsdGVkX18V1sxVzBFVYBj0un5iB0YHzYWjhD4Z8ltx1GnZSJe1TAigimVYirBM3i2MqgXgLnsBJLBMNM1EJtdRGuvIsuHAWXadwtpCAGcYex1fHCyrvS4vOI+ENVNIRMuikNzzS0fsiKWOnEqLZqKtw7RC+TMWBX0ByYB/AKHhVHQwxQ3IKFNTDFe/MaWdrHa8sYcJ8kIkeTLQ8z+2SSEygVV3V83PVrIQjLzKNDBl8teqa5wXAUJbLJ103myYY1NJJqqp5ZtkwKRn28XuiEhUZvsuRDIaZTrifNYg9oeg8CTz926XFgpm11JzFVSpIe+ywJctsUB2P0hy6AGPI/8XwAuoQCRB9U8R+iA4NDybRQYeQ0A8gcON94DZ1D8xVvWWK1VGJCpSr9bycptMkYawfNi2SWqxJDAkosWxZdNFGziL6DRnxYQWbkyb6eDUwExIGPJsaLBXri808xeVp5Y8RFRIFzaUW3Y705F03eClg0fx6oF36SMcv/t3IXGjyoHnaoM6YIMiSVM1yVtTuAO0SrHFNM/d9RbcGQJVx8WQzJ45uEMUNcXatn0MkuGLnlFmu8GQoB3gGd8+PRARGR4/0zLfFDfxlEuJfG/r1/3/ifXhoIkx4yJvImbTEZ93bsWKU7vjElFWiHL1Utoyz36Z36HS0+HEdHn49pBk6mNblPsfxCCZ+T41hue0zhRfFQzEpEtJqGmtr1LRS8PddEVszd4PdusIgcPhNu7k7oukUg3nKZMMdyMv7tVbco52MpLAufy6Do7An1rKqL0fu8YCHayoLR0FO/QesKlVLvyypy7jvohrAQIT/aW74DcnjtavNcvjqcqrFjyFdjn/CDlkRAkZ44CfuYVFifamWGjZvg8ROKbV8Ob+PJywITzadiUaRL+0E+wdtJXvbxQ4TnHyXfbxEYDlOQELB9U58sjP+iyYKHC0JTj6QBwczuzV9e6CJbUdei7P8vleqrF
 WSmR4EiE
 i2W3FqnpSLqLi7jT8aYei7MxHAqf3JpiishMNF8wbDuZN/LaxEYlkHk2D3QlQyWOrCt65FD0fKWfKqOElHbGivHmVVYIvwUSABtxrsW+RSFQrVxeeLH+Ru1mwgkZKek7h7fOLtZF6ARIiXLqU+JhUh061LPwWp9XRVLgsjBc+8Rc0Q/m3tVsnBffmtNMshm/UXudn6yc6DKOUBHYKwvYJEXfVOE2LGZKhum8Nopt/O+CA/9s26Ng/tR0E9ciAueP0qrQXO/Y9Mo/MwDQaeCzJT4XlzOejYDWF5cRlwACp9faoF9iG26p1KbyqUkLU41aHWEQ3toOsLaPed4rnjEFSXBbGqcj1x/gkBivW/8gx+KWjLknuendcSx2nLgQzuzBfd6wTW5mbpG1rPSkjF8soziRV3ut1IzGaGdkLFwAaLBkLNSH3GIbX+u5n57vJizIj8MhHq52tMuvEiPrp4/Thg22Ga9Pr9Q4dbEyew3Okm/NtwuWGGr478uYeuUZmRH5DHto9AolfleXWjsO2RVHVZLw3i6l7EWnuwmyBs25mKsf8IYaSwNJUKiC6tukFGhGh/ZwWvRa9dY9yzBTw7QD5Uru8KRtL3tWcYXsQLgmOZa0ORoBx+GUKG1KeyRwfYKcW0E5PHsaWmE5twfqO9VJeprdJv8Si/aWMDGR9iyl6+wXhY+oCxUonsiqGrguY1WcrJt6BmUTELkn+Fp8cjioYtfyy1ZiAQHQRYX2aO089ljMG3eg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

filemap_add_folio(), called from filemap_grab_folio(), adds folios to
an LRU list. This is unnecessary for guest_memfd, which does not
participate in swapping.

In addition, the LRU list takes a reference count on the folio. With
shared-to-private memory conversions for KVM guests dependent on folio
refcounts, this extra reference can cause conversions to fail due to
unexpected refcounts.

Rework kvm_gmem_get_folio() to manually allocate and insert the folio
into the page cache without placing it on the LRU. This is done by
calling __filemap_add_folio() directly.

The folio is then marked unevictable to avoid participation in
swapping. The ->free_folio() handler is modified to unset the
unevictable flag when the folio is released from guest_memfd.

This change ensures that LRU lists no longer take refcounts on
guest_memfd folios, significantly reducing the chance of elevated
refcounts during conversion.

To facilitate this, __filemap_add_folio is exported for KVM's use.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 mm/filemap.c           |  1 +
 mm/memcontrol.c        |  2 ++
 virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 03f223be575ca..60c7c95bbd7e6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -954,6 +954,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 	return xas_error(&xas);
 }
 ALLOW_ERROR_INJECTION(__filemap_add_folio, ERRNO);
+EXPORT_SYMBOL_FOR_MODULES(__filemap_add_folio, "kvm");
 
 int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 				pgoff_t index, gfp_t gfp)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a942..fe8629414d0a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4721,6 +4721,7 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 
 	return ret;
 }
+EXPORT_SYMBOL_FOR_MODULES(__mem_cgroup_charge, "kvm");
 
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
@@ -4893,6 +4894,7 @@ void __mem_cgroup_uncharge(struct folio *folio)
 	uncharge_folio(folio, &ug);
 	uncharge_batch(&ug);
 }
+EXPORT_SYMBOL_FOR_MODULES(__mem_cgroup_uncharge, "kvm");
 
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2a9e9220a48aa..dab2b3ce78bc8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -148,6 +148,41 @@ static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
 #endif
 }
 
+static struct folio *__kvm_gmem_get_folio(struct address_space *mapping,
+					  pgoff_t index,
+					  struct mempolicy *policy)
+{
+	const gfp_t gfp = mapping_gfp_mask(mapping);
+	struct folio *folio;
+	int err;
+
+	folio = filemap_lock_folio(mapping, index);
+	if (!IS_ERR(folio))
+		return folio;
+
+	folio = filemap_alloc_folio(gfp, 0, policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	err = mem_cgroup_charge(folio, NULL, gfp);
+	if (err)
+		goto err_put;
+
+	__folio_set_locked(folio);
+
+	err = __filemap_add_folio(mapping, folio, index, gfp, NULL);
+	if (err) {
+		__folio_clear_locked(folio);
+		goto err_put;
+	}
+
+	return folio;
+
+err_put:
+	folio_put(folio);
+	return ERR_PTR(err);
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -160,6 +195,7 @@ static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
 	/* TODO: Support huge pages. */
+	struct address_space *mapping = inode->i_mapping;
 	struct mempolicy *policy;
 	struct folio *folio;
 
@@ -167,16 +203,17 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = filemap_lock_folio(inode->i_mapping, index);
+	folio = filemap_lock_folio(mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
-	mpol_cond_put(policy);
 
+	do {
+		folio = __kvm_gmem_get_folio(mapping, index, policy);
+	} while (IS_ERR(folio) && PTR_ERR(folio) == -EEXIST);
+
+	mpol_cond_put(policy);
 	return folio;
 }
 
@@ -588,24 +625,21 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	return MF_DELAYED;
 }
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 static void kvm_gmem_free_folio(struct folio *folio)
 {
-	struct page *page = folio_page(folio, 0);
-	kvm_pfn_t pfn = page_to_pfn(page);
-	int order = folio_order(folio);
+	folio_clear_unevictable(folio);
 
-	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
-}
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
+	kvm_arch_gmem_invalidate(folio_pfn(folio),
+				 folio_pfn(folio) + folio_nr_pages(folio));
 #endif
+}
 
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
-#endif
 };
 
 static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-- 
2.51.0.858.gf9c4a03a3a-goog


