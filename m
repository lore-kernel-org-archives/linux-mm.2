Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC61606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KosHCLT5
Received: by kanga.kvack.org (Postfix)
	id 834126B05C1; Wed, 28 Oct 2026 10:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE196B05C3; Wed, 28 Oct 2026 10:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EAF6B05C4; Wed, 28 Oct 2026 10:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432946B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:14:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 487FB120C90
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:41 +0000 (UTC)
X-FDA: 85372230762.15.7A8B309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8A1040006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KosHCLT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnCdwdKLIRu22zpmh++d3j4s9fK6gxqvvFFUcjcNhTE=;
	b=q4DhhI8jjyouYmRdcN5g/o6gRcOVn8h/1dHRoSfnUFlW2kTg7o+QIA7A4aAS+4PWxLRD90
	dmROCWXxv7vR0kwz0z3qpYV+cEUtArAomtCSL5q9GPr4HEVYWRQU21mpcNILkwHVnS1utL
	LNd+WlSRDB0+Ro6o3EK+V/yl6tm9+ZQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KosHCLT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196879;
	b=8bOsWxSjX3V+kaGA6bKjW/ziBFxXQF3UkoNI2DsLqwtk7z9vK8g6AhG5WTysC5ADvbyBS6
	ca9w8hb4iKIntmhgT0JRLMNsvyzKAzOPXOatEFMFJQgssT/1fUwU79Fa5oMQED6wJJFQPj
	tJ+hjNHnv9bgi2DpS4pBkBvSXXduPhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17384600C8;
	Wed, 28 Oct 2026 14:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932B51F01829;
	Wed, 28 Oct 2026 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196878;
	bh=cnCdwdKLIRu22zpmh++d3j4s9fK6gxqvvFFUcjcNhTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KosHCLT5ErruhKe9FgBcT2mZujTeztnBTMNCB4vnxJIjLTsYHk8+JPnZiaqT8/cSf
	 9DySpe1g1xW4cGc9NhHvflNowtkA0HOExbqWV0bpUZI3s+HWCFsHbnFaX7weUtGy8k
	 dve+RBKTVpjWkwYqA4aPjfYfF/0Zcjkp5Nwo40xN7cO3a8P6v1MbqbckdCNYD1Jm66
	 ZZgOhU0/P00hwbxR6D1pnxghjYjBWvDjmluZQlj/GMrfD8/PbOLN57vX1zeIJhpTzw
	 ArLeOD+R57Pth+QWnwIFqwCRzEDEIiVn77tWjria5tRl8ZeGfIvULj3sQ98yopmquh
	 T2iDSA6YJ97EQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Wed, 28 Oct 2026 07:14:29 -0700
Message-ID: <20261028141430.161175-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141430.161175-1-sj@kernel.org>
References: <20261028141430.161175-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8A1040006
X-Stat-Signature: gofpung4w3kzz6tqeke1dzs53tew4w51
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793196879-752029
X-HE-Meta: U2FsdGVkX1/P4DE7vlkYh2eT6sflq6cLduvjibCv7RiG216g6/YyDS5Nv2Dj1QFTLssk1mN6DPdfkZXt8+td7eMWJ+U27eobgFnlYTyxxRBlmxGAY7mNBfGJZ8p9MsMJl+YO5MQuvZYv9fOn0lroMd3mdSaJ08r/h3dzy/Mp/ebKyEpukM3XeI+b196yljQrICz1hVmacxvAepKBNHH4zuFTqtexrKD/tx5DKyLuqFOJHX1k2JO5bhvrLBRfLToUGn3D4tvTPKo9fgQxBEtQRKToarw4bX3k8/P5lWbjv88KuuAB4qBN8EM+OmtKnfdU4g5XWRfTFMrCEnG7G4V2ZH9whFOv+qclsOndQnyaD4fJ5M0vxT3D6ERsGve1ITDlgVLqPcTQ4jF9vr9W0h6y/W3nrlEnqUiIDYvs4Tg01ssYhiyKc70UBDYviotHCoV3P510azMCmJhVG5+nZzyJgH3ddyFcAS2ko0rbflfFNN8NhP/jCmN8hBXTkKxxBIAJF5oJQ4CIp0Al8o/eRY5ph5qO0i5Zg6/jZQDCt/nkk8Hi/KbPvCS/HMPF8dXjBKZ5a8ZLhR3z+7GQU0IhW+7H2PI/U0EEcBpDM3ML93nwtlAf0peF0D/YyjCvRbufbXuZMM/+T7as3XfKv2ri+gvpXlAmXgTVIc7gsax3q80CXuWiRHvLYsN4z/i+n005t5UjR8L8IcNZkXvaPPRrrOc3fj8XKmXvMQqpIXKH8T8qDM2FfYYGt/WGNqtFrUJnkkiVath8oLTn2UTN412v6X3Zsh053MCZ2ABowYpVRq2cFM3itd9wbfQpctPOO8OnKAMl998Tgu4Por//jGYqDicrQOyYx78fGTAB5ZZRNNzzA0VO4sMGjNXB2EuOVSGjdhTGU5R9U0Ebq9YT8b+QVcx1GpkydITudWJdmnh5T4wrtSzAdgbd8DxzHsw7SOpRpbesaa7JkbdSSzS9kikPo9q
 39G5OdwY
 ztyOx6mhNrw7bi4hWZF63OPTutODFrIuSG44C/lLTTV8rCcxUx5v/gjIRZpaC/WMGv/Xobj+br4kHkVhGc2o9ynA0sVHAkily0s5pX26ZBDHhJ26tx9smxR8Hg4MsEDWmHk9cRSlSYr1fNiRa6bSPfnLb03aoFzeQrNuYIkJDqD5Bzi1D1ExgGi5lqzyN6PVMzJvfO4/feuAMLRymgZ9UwOlI/MyjX9UGBw98IuS3Jq8ZpWFBL5jJY013cpsbDc0bf32FJzet1t6OiuxEfIBZ1OufZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d95fda1054a00..f830b873d05fc 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1433,6 +1433,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

