Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD708C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2576B0101; Tue, 14 Jul 2026 11:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A056B0103; Tue, 14 Jul 2026 11:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F946B0104; Tue, 14 Jul 2026 11:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7BD6B0101
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB38F40444
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:31 +0000 (UTC)
X-FDA: 84987731262.22.0ED2DA8
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf31.hostedemail.com (Postfix) with ESMTP id 08DC420007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdkD8rLD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3kFJWagcKCOceRYRWbQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3kFJWagcKCOceRYRWbQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcpQuk6vjGQSe9CsOI/pxanFsfOSXhryIEYWt4/hbIA=;
	b=csxd+G9FVHdBQdrkOywXSg8cSAzORjN0EfWvtlWhMP5SXEqkgcIyBCgovzwy08x8Rni3mz
	r/IBn/9663wJDkPgNA1m+4+ZfYlwiZyWBsiQ6T4XSEsHQEfyiBUs30kFGnwWBH+5rkWy5Q
	jWswk7y1gBwTgTp6qW+NE8EDa4CBIBk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdkD8rLD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3kFJWagcKCOceRYRWbQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3kFJWagcKCOceRYRWbQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042130;
	b=hwjkQDarkygveuPTwx1PY7b19O92NfWyadk2LWmD/l11fJH7VTo/zpjKMKwj/IjlplS+9q
	lOnpZ18EpnwZr3Hw0htIaNyjBiIDlgyIObVL/KUYbr4ebE3igzgXfO+kM9BGCZKErK9kx4
	umowuFYtmMYee76tdE1GuuyD/e0Mu+E=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-848662cd2a1so1240244b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042129; x=1784646929; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JcpQuk6vjGQSe9CsOI/pxanFsfOSXhryIEYWt4/hbIA=;
        b=sdkD8rLD4TebyH+scnHUGtr+tGTLbfdK5Hl4eBPbjUTBR55jtIPrmAUc6gx9A4qKpG
         5vkSwFPtH0ihr2pjgsnPr+8CE58YWPRSvKVNlzfm6IJEKXsXO44NbFi+ckFzfIA/Icqu
         A6bB8EwbSx7UndMa3pNDpz+RD4psHb6pcvBlil6H6wVs2MKt7M7nvgP4DqhpVz69uhv5
         G/B1aXAUMjwNNoAZuUdZFOav/oP+X8adHAmvm06+MKYgEFc7yEq+zItt3xRPIYRowD17
         oc7SF9klxHqpiOhTB6m/gBsaLwiK/1t8leeOMK84qAQ3zqhGL0EKEO0jMMy0S3D+NU1d
         q4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042129; x=1784646929;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JcpQuk6vjGQSe9CsOI/pxanFsfOSXhryIEYWt4/hbIA=;
        b=QuIrhXcnIFZOMbSQ9PnuK7Df3VOFnONBsD8GGna0ei6ITQgEEVy72zU5NNIV9zqGDj
         58947wmHDQ5Bh/YMAde2aQ5wNWQnqLTxaN6jppkz1Ywc2P3JUuJQ773mLcN/ml6a72RO
         nSQHL6o6EgUtj2pgQnfhtXWk/cLkrbeO/RPRCiCaeZuwP4qR7VmknT73/t9e/W55hzmP
         Ufc1cC3NZyVgLIVXuaUTjtCPdh5ldPZdgULMlp6CUUWPnj4e+OpKUT3XU2Q6UnvjAC6U
         Oi3z3NOQiLV4Ybe69VVQzTDUN+TaIhO/xfnnMEt/0mKgtPeACGwLAhZPQkKOKArpS217
         T0jw==
X-Forwarded-Encrypted: i=1; AHgh+Rqb89I0+zDOZRABCo5nvlNHLLoD/LNs+4hSNEQhGKsH/EDuQi33qq46hw4yMYyR+S9lX9bMYvR0bw==@kvack.org
X-Gm-Message-State: AOJu0Yx/2GvgxKErBhM9/F/iy25AbDtx5Mex6juKLSsU6S4eNOMMPBHG
	g7wUj/0pse55RwWqpNhUJ8cuWN1p6GvduJHqSNcb90B2+H12vQKrM/9aOH4Mm59uMlhWZHjBLSu
	d9ISmOfhvtQ==
X-Received: from pfx27.prod.google.com ([2002:a05:6a00:a45b:b0:848:5415:1869])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:bd8a:b0:848:70e7:f053
 with SMTP id d2e1a72fcca58-8488980f75dmr11709317b3a.54.1784042128707; Tue, 14
 Jul 2026 08:15:28 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:03 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-19-vipinsh@google.com>
Subject: [PATCH v5 18/20] vfio: selftests: Expose iommu_modes to tests
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 08DC420007
X-Stat-Signature: ycg8pm7t6jxw63p43fa5zmab66nirrx5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784042129-17463
X-HE-Meta: U2FsdGVkX1/P53m716tTtWwTPGh0LItLosO6cfc9TVwMIobLr7nVI2THttU6QhKHJYxrpF+p6qeaR0/igfFwdMpUv8b2QnW8HsXgmcK0h2YcRzboHYf3zq5QGfzu+4Cc6OLphAxcV4EDmzsGaN7JWwvFeUl6TQWL82WOFXTaYu2eVdFhZdVbDysQ7gactuwC20MgFQ/wxGwz8y4HJeMS+MHsrQB5y5166R2UGOoPvjCrVpQT2gKB1pYWXGJsMbEekXZYfsDtt3eraqpUdYLgXd6UUuavFvEcKy0lGTOIo6pL6I4BTFBVmUnEnk6y2jxwZVM7OYWTz8cktz9aGZAHFQ6+slGvMK4siFjRpwktwr5F5jN1lRkDGSptma2YBby29bqkqlmMMiJKcbOzcuy7r45b67T6ri3AfZLidwAJxahDiMwbYTRl9J1QR/RQ51ai4SxILBWB2QX0iQ01yefJdMHa6go+r3aURR9oufdHGHZHM/GYwmCaxnUK3kZA4PZXKRi/je9XqzBBu7jNq1HsB7XGpNkeuxdkQjuF+e2Rn4xJBZ1jqnk6P/NRP8LyL+3zok7ufdlGZDhg3DbQ0aNjUiTqMObhC5+8Y9enfpUdIo14kIetyj7bHiVapX+dWFxfndjzoaNkERDX6BFC5Kb2zWgjFuhF9d+EWRgwJOCqZUIGqY71/QKajYrlhSeaHGoMkQdtW4Yo43d2gQoNHgCmXuPEeA+w8DlDGvqUXUShMSKQMMwLhcjNj6fEY8QcDTATgLh8qlMac6oLmRASH9gSbUbzGVGeROCG+mUqQpXtuEvPAgf3WP2mXSQtDyCJNqlZ/d7zSmgMdKI8P6QQB1DIV7HVcXSenWpvAOT6tQBmvp1DnbQ3Q159e4T9cPZjUsRAEWPrSbN90QXoR91tIRWfl7thiTNqmeF3/8sHYAjJzzfL+nkcbjbMBJ8wd11PZ0R8wnret/Ehr4c6ji1tylB
 0/qoc8Z5
 bc5Erh52BfkK1cOryntOuipd235yBgn1fVfQBWsHpC1PrWAnzxEkBha+ioXii1hD8fLxUwnFZlEd1BZtFnVIMBmi4KnFWlo8u5KaxpDfyFTcumUHtyJDAe6lfELMuRLjQa5hu3AH/6FaFmrV7pw/XJs79u0dvn4fC933Aazb77lnCYVWoCT9sfu7scy8esCa2Bq9zC0Q6qossZLCZjBWkDoeVX0vQIoRgHSFevQs2DDgZrofC1i9+oQG/IVvngFCiHXVg81GidlbqWDpt8gwWOvSVKRncEdnaPdqZcRODGmWVEEA8Uwrxsaj/Nkm5IWFcDUKpupPmXRYpPaCEMsnn7sTLlFgW1pUUlNB+LUJqcXHAvBK/QSezBJ9MAN1e0sPbuhDFbrNJaN77m7afxqpKCN4XYnZSu9WMNC2UKlqVt3fj89ERohFIPOorJpyHxg6Qx3YfzjcDvPiZzgygwwFjQzZ5wyLnivtEMicYgiptJXuETz+P0NCH27lGVCtkgtKiOxpiiP74dVxsfC3lTKt+jM7AESCsuKeOmFOfcuny4Co6mtSDc6rotHG155U6BbaV44Zbv0FJItvf/kVZS7ShGCj/3qxGCi8ItqACUWehie0pFr2vfrZ2fG3KYOoH3bUcgygdmSIrWu0N0WQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Expose the list of iommu_modes to enable tests that want to iterate
through all possible iommu modes.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/lib/include/libvfio/iommu.h | 2 ++
 tools/testing/selftests/vfio/lib/iommu.c                 | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index e9a3386a4719..4b9cbe262159 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -15,6 +15,8 @@ struct iommu_mode {
 	unsigned long iommu_type;
 };
 
+extern const struct iommu_mode iommu_modes[];
+extern const int nr_iommu_modes;
 extern const char *default_iommu_mode;
 
 struct dma_region {
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 035dac069d60..95a494f829d2 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -23,7 +23,7 @@
 const char *default_iommu_mode = MODE_IOMMUFD;
 
 /* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct iommu_mode iommu_modes[] = {
+const struct iommu_mode iommu_modes[] = {
 	{
 		.name = MODE_VFIO_TYPE1_IOMMU,
 		.container_path = "/dev/vfio/vfio",
@@ -49,6 +49,8 @@ static const struct iommu_mode iommu_modes[] = {
 	},
 };
 
+const int nr_iommu_modes = ARRAY_SIZE(iommu_modes);
+
 static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 {
 	int i;
-- 
2.55.0.795.g602f6c329a-goog


