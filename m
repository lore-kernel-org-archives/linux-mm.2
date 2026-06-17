Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C715FCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5CC16B00A2; Wed, 17 Jun 2026 10:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D9B6B00A3; Wed, 17 Jun 2026 10:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEBF6B00A4; Wed, 17 Jun 2026 10:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0AB56B00A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 190AB8DE3B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:45 +0000 (UTC)
X-FDA: 84889686210.03.174E80D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 652AFA0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOTuBBHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsGS+HxEzDkHzhjYAPG09eB03bpLenO2Lknga+uqbAs=;
	b=OxtxNXwAKbLhahGqbIpBjjI8Y2dLdSj+NT8oJIB7PNTEHQmHEndR2ABDGHdm1dcSuRa+B9
	MCbfmvoJLC2xbvRsf3u3b/A3IfGoqSPhXx/hY7aNNlwEuf1spXBH2cFYxCN0fKFiZho7/S
	hApOleo5DtFAXDTFN27WrnGjRa1mXPo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOTuBBHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707723;
	b=LbpOWDBJF6C54x0Gui10OBP/tdH2w5LJE4njNaWI4GVLHdWU/m482Mzz3S14JKG5MmqaNV
	V0sz8wE41juoMpJEADjYqmfE6e74hf9chE3/MIj650qGJpNDUvqnOovnoXSLd99ImYgb6v
	JrQiRubdWxXBCp/Iu7eqhCu3yTGLHWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AABB54416B;
	Wed, 17 Jun 2026 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66841F000E9;
	Wed, 17 Jun 2026 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707722;
	bh=AsGS+HxEzDkHzhjYAPG09eB03bpLenO2Lknga+uqbAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOTuBBHcg7Eti+iec8DTFhmVDja0Nd0xAbNiiVXffYZZTH209O/K1Gk1vnCEphP9M
	 9uPUQIX5zInGml/zaPsKlf0B6HfI/Kuoj6Sb1DMH5AM8FEDjqaj19RSSdzyIEonwAg
	 XOkb2YY3KTK6B/ZSni5tCz+iFk45Iif4OlnA3BbS6dEk5OlORKzumo/GOQWq99x3kx
	 TadvDW2B0tF/0kK/Iyl95+iDxBIHE0dk4T/mmdEnS5kOWO8beiCAk8Nau/hiis+e+Y
	 hqvNvY3rf5UywoHLihgr4rg1YXnHxcvlLBgyUUeY2npS63nVo3had6Gbso5AZhW4/y
	 7l9cYTMQpgTkQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 8 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/11] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Wed, 17 Jun 2026 07:48:00 -0700
Message-ID: <20260617144807.91441-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dwk1yq173qanozh63hf1dps49nq5trh4
X-Rspamd-Queue-Id: 652AFA0005
X-HE-Tag: 1781707723-221353
X-HE-Meta: U2FsdGVkX19l9knBCAOJ7l2DT6PqcpvHRFj9zX5xU/goj93+jfdDc0ol7oCVIJaIOkuRV0f6oabNWunkNcjLvLTbEnF8RaWYB3SbpG9+Y8F0BrehIDXukMa/Tm+iD/eQevClDbEel/moetXsX5Ei6iL+pOeFT5agCELK8MUZTSIJQz1mmAQXzKDy95l5Pd9ARAfGap9+XPUJi3ZKTL86I7zmUvF5J41+IbfEWFI5HEAKyP5nKLawkJVVSsd1spWK7cugWPT7zWTzG0A1hUwT26mUsbbMZbKyQDbbD8bnIcb5TAnMv4VF2jaj/HxmtlVlvPtiaRGDldQAqQuzLV4kTAvF/zyJLBmQLYFEuUg5ovUFZlyVJ3SLwZHA4oh90dB455Q0FbSUNk/lNNtnm6y3gKmLRgl0tisGsqxO3e4VFppvYGcLHyNxmrektNuGr+BBpyYYuFhbPlo0am9VJOpSboQ5+8DrryD5+PurCugu8NnWfw+uXbHD1JEk+vDXVgv/s6mc2n7WHbHLksZnVVcQFPQQZlJgw6iIJ4+vrF6t7fEN3GU9l65qHcH8ggC6Cv01WDZ+gSh0yjEfWjERKKS+hP+56bHQfpyKgiafFUWfVslAM75kZy6Xo2IsyiXcD2TNc13FcHBZ5mu0HUg1PRA0lfNhXOFS8LWvUJIgGIpdD6AqRUmIa9ZZVRIqk/6q74uuoXH6DQRMzpUR6s3gCRmiz37taStD1GxqD+a0IrJRes884Fn8+lpw59BPjAjjlGQRhedYSJKz7LXgyeD1iSAmq36uXW9TWS9w9fPU8KA+yFaCzehd9kZDxtkxytP5mo3JvXieF6ZhimoqhQt7JTUaosuKs/x7pe+jfR9V/KWPTg38ki1kdV7ajjUBDX7Y+l+gckjo+XDQe0wdj+R4ryG/BCRpvub7ytB7dwVCqr+hef+T6uULitQLAkjnFK4LDS/rKH9lpP8Xwb2BmnQv2BU
 mrdgI2xN
 DHjrnpsYjIQ04fg/z8By4GJpusQFFSNMBJkRNNwp1rGMe8zmB5xdvEGr5+qRFgc/jkjTbRXgfxNEL70kPVOH/qAON3qKnp4hYGcnZpAESw1dNrNxeEU5LgqGhhoX4BsS1SG2JJDIIrO2Pz513KYDC+xjUQQHjabzT4Ym9YgQJG3f6/1J3VWS71Nq/yL3tkXCSrLVXGniiYodLp/zgPZcCB+DEt6r1zy5VGKbdhOaFk4VXqwJZ2okqGH0xE4K62nt+6qYJ/ujZqCXIyjw94td9MnK0yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index db6226c05b023..573a40c679be3 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1465,8 +1465,10 @@ static void damos_sysfs_quota_goals_rm_dirs(
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;
-- 
2.47.3

