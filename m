Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE603CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5D96B00AF; Tue, 12 May 2026 10:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDEC6B00B2; Tue, 12 May 2026 10:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B726B00B4; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE52D6B00AF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B73FBC1E65
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:09 +0000 (UTC)
X-FDA: 84759020178.09.927B2DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23E1740009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXMh6v4S;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVGsZUmpVNnp6YcA+t4pltECkCun3vsA1DGfs3+B6yQ=;
	b=qdxBrU0xAU8dRYZ/xTBeweqCzsM/m3WRkqdjFU1ENCuxv8JTUAQMu7PdvWjpPXeZSbET/P
	sJLZSkesjinhuCflv7n7tiKfqFcgNcQyi6RrSsoJ5atwhLf6CVSfVoq3gqNwsXx4qu2mM7
	vQw7ALCta2sVh6dk7zheuDePiYbUa6I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXMh6v4S;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596628; a=rsa-sha256;
	cv=none;
	b=P8cG81IxghDnD2EhducV9/1MLNLQDYDvBvwARb7hz1JQvWRo2SbD1Xk2Fee+6oOALGLILO
	uChPkLERqbPeE4maDWtnf6v5POuLiQnswKgnYw0IZMVepA2wmDmoOcn21btKjd2dU0QRJe
	lXEA01U8SbvE/pOs2z2vDauDm4bIKpw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC9A244AA1;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA9C2BCF5;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596627;
	bh=cFvp8t6ODEV3JdI3/2xCA29FAtQcg5JdAkWzfAP5fUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXMh6v4S8blyPmQhNSi/jVQnYSmsr/nWTHGVyngriybW3PN7mRYtehiv6Fg/rGNKj
	 HsMtgcAqJu1TmNgoFc4cQNvVZP/PNKBkQzgZvWtHbbjtc2aH25/NmIhYeUguOCeuUM
	 V41/BnERJWQTmiIGjkD9rmkVpEPbgdCtW3kOQtUFMhfpvbS/cy5IH7X6dPM7vtOum1
	 xN5glbUR+s4DTK7GQR692b6wCz6zklxGq2sNmwb4li1OcsP1pryObrhOoLVeYX8SZr
	 SvJyijxVUDo/J3MXa0gY6W8zvwOULqFnB/bba7+cDrZ1ewoxg2lzOpqhgClZO/OuZN
	 7gahZmp1+tAcA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 26/28] mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Tue, 12 May 2026 07:36:41 -0700
Message-ID: <20260512143645.113201-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23E1740009
X-Stat-Signature: o8pgb3uiguam8pcqxnhg31e6pao98oji
X-HE-Tag: 1778596627-83662
X-HE-Meta: U2FsdGVkX19L998MReITlU8CRnXU3ZkrrUBA6DbdXmHvqIR7kysXo6IfwbopyO5kltqdv1HFBT5KsmIsXHgkMlkDczsPQ69Wvl/zVCeX91gy+nTuz3DtlevrkPWJpgP/C06E/i0++csgHYCDRxUiFR4s1NwUuYLTuVUpZ0D9kppaVynsGF2jAzvCjKeDM3yw9lbILBcr8O3ozCXPJU6QaVzcMxPdngcw/5oU6LMZAIs3n4pjUoABitoz7tXb+A9eA6u+a+7WwDnfWWPf6M90KQCU8x0oJGLVSfXhQkhkOI5Vy+XG4gYo0ureaPZ9TFO0biwbj7+7lbx770yjcp53vdf9weeewKzc7qmZel7RP0jOk8gd6uLeIQ7AK2Uim+nb+rWOhTbykPfXjbQNbfXnjxb9Vl+NQM185Mzy/qr0mUbA0mRvwAueQYxeszGGGP74txWboGjkHfflMBi8Sr3pZgXi4jeeMADDslu3v9Ox29KrAgq7BvOyg9R2HUgu8O5NJ3J5PuMSaCP/lKh27XdsTbgkfI+cwSiAXWNHm8cefOJbcXOWNy+Ju7smzym6FNKhlJs5ZqSVSXprRiWhuhzYL7Xf0EfamzVI/sf8flmkIE6tFR+a2u3Y3wIuY1lxVhbgmlCCWWrBShMDH/tCPlVm/1doF7llsz0ZCLJTbb3SK9u9RpRUErubqwcYxOY+SRo9LljG/8Z5n77tyeEQb0eASYgyY28PxnK1fG2grlaU48iUFS3EJRRqd0lR7jrLy2LOQ69wgmZTHvYFzumucb0frZV3BXTH/0kKS9pf2WtrPnltaincrQfFqWNtqFd67GtvoSh4gMGAiGTWDAzUNty7YDQKnawn6/nPa3DcMFPSIZ6E3QH7+yXHsR9cpqpv/tpbrD8HC1E/MnOrhgoUMRWzrzr4I4AydZ6zz7y51fVforlVLMAQ18Apts75bcCgpJuUgp2SZaz7mLaRqZq2gST
 p0pNhYXx
 TFwBb5vbDrWV8tG1q5+jofVcFP2ExqjVJvJ5O86uALykmCAAFkbe9ZhGyHx51aYO0vIS32cS+vgUTaDtgLA3cjZtBEhbU59J56sodYbhm6oBFoK56ljGaRBemOdpdjayrIzYCT/Z7eVG91zYhprEoyyW+1lZTDk0OUDZmq9knXBFwVb6pCn9H92BATny0IFVBh+ERMOxIu7+w9tbUCw/hyl7WGdxCE4SO2k5uTA6sl+sWo7xiIcibLEMlMSdWnzSOyqXBtpiID3vKLVlFP6mli9stMUERJ2I2+Gd1WrrwGwsTdex2smwNWu11rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Find and set the memcg_id for damon_filter from the user-passed memory
cgroup path when updating the DAMON input parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/sysfs.c      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3dec0947b93f0..6935cc3ea00ab 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1004,6 +1004,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ef751898a3c06..89568f463e556 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -143,7 +143,7 @@ static void damon_free_filter(struct damon_filter *f)
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2b68e1a7de451..0b7b0ef345cc8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1927,6 +1927,17 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 					sys_filter->allow);
 			if (!filter)
 				return -ENOMEM;
+			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+				int err;
+
+				err = damon_sysfs_memcg_path_to_id(
+						sys_filter->path,
+						&filter->memcg_id);
+				if (err) {
+					damon_destroy_filter(filter);
+					return err;
+				}
+			}
 			damon_add_filter(c, filter);
 		}
 	}
-- 
2.47.3

