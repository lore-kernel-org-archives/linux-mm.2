Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7F8CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423DE6B00A0; Wed, 17 Jun 2026 10:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3110E6B00A1; Wed, 17 Jun 2026 10:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F4A6B00A2; Wed, 17 Jun 2026 10:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECE9E6B00A0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72C6AC1FFE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:42 +0000 (UTC)
X-FDA: 84889686084.17.EB3B0AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8059100010
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aC0czx2A;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tsHNLiRHrT2fupCfklpoPqgBkd/OIiPYVnZdcCqxSw=;
	b=Nl99Uq9FyevsswJhTZo92OHv3kJdTnHUQeEnqfzC9vnZRjHUJYoU4hZikEHrQyFnjokCgk
	PiRalTKN0097FXSozS0SX1AjWZ2XEpEt2Cayu00eFeqauvhUToc5Hu4iSwXR4+Mw1L89Ly
	iJ/8lATk9j8J98v2NCJy3lSYzp/D414=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aC0czx2A;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707720;
	b=WjywV9ismV3P/jd4AqZZDwzN8JoHiPUV8BF7EHQ2ae52ngL6QTmCIuY4eNAQCpefWCdqSH
	UJHH6YUUkBMSZiVwme5g+dEAuf0RpZH8NHtSzxDkvtlUBcvox9aWrnkZr5IZUxEwVM4d4z
	cDV/hyhTxbdEMcRZVA3+NZ0ApYjPsLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60A3B600AA;
	Wed, 17 Jun 2026 14:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03C81F00A3A;
	Wed, 17 Jun 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707720;
	bh=5tsHNLiRHrT2fupCfklpoPqgBkd/OIiPYVnZdcCqxSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aC0czx2A3MwkvRVQ7VpYXqVxqoI8ifrDMm+sVwCpSzdvI2FdtYshbvNU1RwPKccuF
	 /EE3964iMLCQ8ssThuyN2kAQB4fDSNd5Yf5GfIAqiDRpZKMo8vekE2Ld0ObhoE7yNM
	 5ZHEA85xNdoaqTuHhCz1q0vfpSZuYPihSwF6DcGJZdzya9C/x5S56XnrKpenW4SmSY
	 R9+eBv2TFDhBKZEVzzqsqa0ozWpxBR/BUO04hlBluxDRAJIuLRFiIzDNrlm3FXcKtn
	 gP2S42GBO3Ba/RUiG69k16UOfmUuQXJZpfroQcSGYw45ol9fyF02IwOYBIhBiC5913
	 qpYh2OaTWzwiw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/11] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Wed, 17 Jun 2026 07:47:59 -0700
Message-ID: <20260617144807.91441-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8059100010
X-Stat-Signature: 4pcfeqto5zawwpkgwgm8obgk16naiseg
X-Rspam-User: 
X-HE-Tag: 1781707720-142985
X-HE-Meta: U2FsdGVkX188alRVBhjnJ3bdIZ31dmMiYwajmkTPp0ugMuMueR8sqnXLbEW57bux/Il8dQcz5XzQ8EEWdq39tzaKM2kskC3EwtFKRS8GJBUAKSdHI2I9RdUF4Lv3q5rwM++ijBfyOFvk8c5Ci+8ajf4fOPs4WdgRAM8lsgdsdonEnEgYSlWBiFGOz6LazLC5uAbjufQdhDyJK7yU1nZX5dGo6tQfCBRT5KpH65KvtFvybFhqvUNpKQR9Fq0hLelSAgfdnfoZze/1XfrlusQNtUE0XSkhVFULtjL6pXQN3qTp39AoUsd+eHpVJyCn9+QgNhcL/fIJ6MkYkh9BOlYG273uyByzUlwgNximKiYjR00HCFrmgSrjR1H0Ta2QPXckGMwJdzFa+KQspIIxJNdW6zzsfZ3HDj0l9f7LEa1BqjYyTSjo3Df5N00Q8hU2C2rogjlL0iM3mkI+X5wCCJsqJrRSGkadgKr/e4vwJbE4EYKuZfamJW6JFzWJWyT6QHcOt4CU9FqEK6cNiq1SxgRlbhnmA0errta/blCPCmrgaUFmlJUBiRErPUNcZTCX7YU9VwQP0Ijc2o2ihkm0qBgP9zHIftAcKe6nFt/8N+DHA+hGbwKbQvNwHDl1KoaoBljcJFYe9+XuUB0NWpeIvGXfca1EetFsZ+jOdXV3NC5plvGyGQyy1fDT5CBVf+czrltx0UZGQtsVe5CKYNIqU8sE5FANcSHvJoEE/Y0cf8Ym/YyAa3VUyHM+N1f8E1RNNMId8njaOO6hD1Ly9p+EwhQUdCxN7nKadihhs6+QPppv5ZSr+vfwrSQqiKQxYyXyuOwPUM7g5obtpKglBjIpIFB/oDZAXRLVpX3rzFXBuyslpZmHsXy5GEf1BYnMgVSDm9pFU2s+pKuXQ5KOlaFNnjbiBGSzCulacxFEj3qWA5MuTznTMZe0A8c11GyUgDP8tIAFsjK0PJJELhhHrQTtHwA
 zI7ab3/i
 ZGo3TyNletkdz5WeEeVU4qlpE2AVtkCfIM886Gg4HQU7n7FgAwJCys13t3nk5JASsITD0q4Tno855yDp+5zx2ixTFDHeliBiSL2Npg3l+ap+rg2YG6sTmhPcA5nsoRKC/6rOSATndb/2r+WVsQsgCZYcY/gzNhatLiRPDPGAvyaGqVeGrfG50AJpKI4akzpaQXc7hRGiUKbbzwfpv+NksyurXBc4Dna2ZYiH19/Vx8eQUNdbiq44rJsPsrQ5++IhejsgpyStZzfR3u1k3ql66l/1+Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme filter directories by adding kobject_del()
calls.

Fixes: 472e2b70eda6 ("mm/damon/sysfs-schemes: connect filter directory and filters directory")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 604b77a47a463..db6226c05b023 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -914,8 +914,10 @@ static void damon_sysfs_scheme_filters_rm_dirs(
 	struct damon_sysfs_scheme_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

