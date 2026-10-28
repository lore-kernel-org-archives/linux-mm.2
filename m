Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACFA606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GudBJxJE
Received: by kanga.kvack.org (Postfix)
	id 617036B05C8; Wed, 28 Oct 2026 10:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579276B05C9; Wed, 28 Oct 2026 10:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468706B05CA; Wed, 28 Oct 2026 10:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18E576B05C8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9873B40C9C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:35 +0000 (UTC)
X-FDA: 85372238070.04.71141BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF41B4000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GudBJxJE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793197054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUbseAYEE+G1IqK7aQUzVK/2OJ86R8Gy/7HvczyR3XM=;
	b=GIZljIO4WPlo63ZuNHSGFy65UsRqkTPzz+JOu1sp2fkv13DX0c+Cgeih1BKilhHKEDrAT4
	wGR7jVjdZrel3obwrDRmVyEQ8XcLgMv1gZoQkDqaTDOhpQptxjtrv78LQ+0MkrLMMqdVAw
	Lg3mAt02wA4F7Nensfi+rudX9amRpGk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GudBJxJE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793197054;
	b=WmoC9CrePLkocrZgn3CWwaBDW3+4RivA6hVW8wyhq6mUK2O7MVBhNDyguGvU+JYtrDqq6Y
	KzcTK+qOwQ9vZKZdJnJbvyUULDLCp0xjSl9ZDI6Pc6esY1moOAk+oeELJNA+09GWP+8RSW
	XUZF2BLibSEvDgnkDrF4HUGVtNq5G54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5119C43ED7;
	Wed, 28 Oct 2026 14:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C701F01829;
	Wed, 28 Oct 2026 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793197053;
	bh=DUbseAYEE+G1IqK7aQUzVK/2OJ86R8Gy/7HvczyR3XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GudBJxJECT18SsAT7M5dBTcs011v5Nlen5Ty1iKBKpiR177AhkKzX8MCtFWXuCfHa
	 GttY9KcyJEYQdYiPlxXb8nDjqzHNjouwLRnhbkdnpJd3Ez8xLHvSXDpAmFiNkHMaPo
	 Zq9aiUoyQCjODugW1XuRXFS2E3JVMi2yxx+UoTbcc2NzqzHWLy+YtfpQMRpkkiOD5d
	 aJhqYyUMnYZJ0yAioyn54BRknp6YF8cuPNOk+7Wb3DX7JZOLvNOo76Dwra+4deTQyF
	 sJCc04eJjEuBvEsVFehq3fkuLa1RvXGj6GNI1IJph2H7MhPMGezkeZiy82ly9F7/ph
	 RuLQDHd3TDlfQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Wed, 28 Oct 2026 07:17:22 -0700
Message-ID: <20261028141723.161776-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141723.161776-1-sj@kernel.org>
References: <20261028141723.161776-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF41B4000D
X-Stat-Signature: ugzrx5ehtktrb8u66zykhoxecoc3nhmc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793197053-950838
X-HE-Meta: U2FsdGVkX1/TD4dOl26v8h31rzxD9O9i4eD3HQk7jRIxTW1YyQJ8/PdYA+qmzfzqDk2ELnFtEQ41ZH5LRclG265+Txv5cUUsstfcCh7r52srJlBPTpu4yqYfyD7+EGG33EAWSBFCxJGVA/2UeEonpKt7JZ8KKqgIY7BQqlW1iFQyt0pNHfugQlsKMYoaq9JiSv3MccqXltX/o+ryxpGKcKJ2jPEYiDOPKguCBiCdLIeL7AFSFxKIrKNVIzoglVq5M2Xu3i8LcoAqR4nEi3A96Db1EOWozn5pXx/sPW33ykEClUFwfXcn6/GXJdRMdu37F3S6CHSEo4FH+a9fBbA+XBeMSfYPbUYwiByCDcX0dyKJhfuvVh28W++LAiy5LjQ0WN25W/K6IxhwwildHmWbLuCWYzxLH7pjKz/UIWH9chOy2gk0QBDqN53df2w/9p7jgej4Trk/h2LMbe5kx62HWlLEaHV/xk+Wu1se/uzKgTZ/u6ULmh94Cu+ZcIyJoKqfDt+WS8cMwWwZW5LAwEaONRY8Lf4G44tRBOKTNqmp1vNw3921Faqs0EMYDDbLWSWZI1Y1D6STdY9PuLHlELZg1R7V01PcacwVdu3u+J1tvccqnzdkznhrhwNS1myWMq3o+J+8D7qBBy0Jn0nJenEkzBM9+D0IwirByuCVdIIyup5fdgkzewBuDj1wNe/4DxSjTs74MPJ0rvn3BU79l7Q1/eLWcLQtE/M+T0KSFI7q49/1aY4ysGFVWitlW+13g56mnWBjMncx5TextzRpn2dGne5MuLVcSFDIVFzv5luZG4F6QBrc7l/7KOLf7yVPVyPN4YWRNA6VJI72FgWx35sjteuTh83FLTNaB8xp1ucPvk9jLBlzbuy4xaLuxTwpHbKo5SReBl5ywEaE5zPC2VUohXVGCjoOZOc/En4fb3LBO3FEqZ+VyxmOYSYKtlhPNduguZUP6NUdcb75Urqmszg
 kWN++KVf
 gVzsO58mR9Wck/AUUD0Ew/hnBF0IsGJl0xuysziQ+V5KDI45gwzD4zWYWqpQ99Z4amOlYH8kPsy1FSLP/TL66Jd4MtCBwkQzKfBotJ0L0BxcFDSdiay9wyPW77y4YxBDeFfyenM8sQt3G+ZnMDS6AmIVLvfvyGVfX7IznqcpBfuu/YUDottxMwqJLdS2t3wr2vEfu4tXnADgwha+zsfp4hCMI4dU2xglpVFsQHsLkYrNrd4hlBt7d/ESVA5ETYAlX3/brFLhhg3ZlPTmmaxVQli0MoQ==
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
index 4b28bb9ba0a24..b9b80d58e5bd6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2515,6 +2515,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

