Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424FE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fffz/3+h
Received: by kanga.kvack.org (Postfix)
	id 7930B6B05B5; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A866B05B7; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6339B6B05B8; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43D926B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2B9FC0C56
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:12:00 +0000 (UTC)
X-FDA: 85372224000.17.E44CFB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0810C140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fffz/3+h";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHxSttUyt/DDMdmQXBY+0M0nVJfrKzZZx/1K6D8VwE8=;
	b=I5RR74iG6d/qAVkoZ/X1u0bfcE4HXnuSq8M9HaSU/n+MnnaHXNsu/nz8hBI53D+BCNos9u
	jjEtvsY957Et/DS/lhviVtGMdiKtWwUrXSw0dXk+8IrPCB5CGClvYPKFHvJ4RgIpFb6NQV
	Wdu5A/qRHtn1FRbmiEIZGdIAonItZDw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196719;
	b=ZkAycWicPpU2d7CZxxae1xSWmhU41MsyS0S0fTRoFPnxsPMz3FkPEZy9mALQ8TF7tm/34J
	DnRcBphg2nGTz1RXEd3AoIF3TA8Pc1ozaQTBCAiID8J3/8YUfl1G7dloihfzP4mK1SLUZA
	HOs43II3/pU7JX92bLFcn9hZ4hQRj/4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fffz/3+h";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FD9E41078;
	Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A20E1F031E7;
	Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196718;
	bh=BHxSttUyt/DDMdmQXBY+0M0nVJfrKzZZx/1K6D8VwE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fffz/3+hlpCka620g9LmphQzhp3kkMlWlle0p5Vl5pIcRUoj0KLcOv9O18184MaP0
	 PQad/5mASfBS6X44wPxAQevH8dvPtHrrXn+1JwcFACn392mxeR+Hr0Ic8guGIHS9lh
	 sfo0TSIBeUpKhmzKL05HnRBa7bAY9327nl+7CYFmPnAtSOFAXp8gmdLoksXRXqewnf
	 1yE5a9nyDaLSSWyOynxOs2C0zaK1Z/RalUFq2A71K0tIb04czNNX0/12NsXASDHM5I
	 b5NyLlvuCerC83s8C/JIz+dpjDkhlSiS5PgBb92NmrpCY7SXXSaA2rK8q8Ds0gmFDs
	 nQejANlh9GRlQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Wed, 28 Oct 2026 07:11:49 -0700
Message-ID: <20261028141150.160711-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141150.160711-1-sj@kernel.org>
References: <20261028141150.160711-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0810C140002
X-Stat-Signature: 63beoex4zm34579sjjwcmjeduqk1rb1n
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793196718-339170
X-HE-Meta: U2FsdGVkX1/8fM8UnRFFQJnhjf8qMTPrEPASxCM5h4brm9W/KeW6oYIYRRc5MfBb142LQlb3ObzngJ2/TYtV3HGyQ5bMpmpOMaqkLaGNgwaSR5xiN8vFGWlV9taLNDKNvpkP4JEz/VGh7umxsPQrMWH9yKXn1xY7eJwtkini8u7HzwiYKYCts1vmniN9qLfXfzSfR8e8U9QWjynEbaQZrsV86iiOOft5ztUYeM1sA9RK1GKOFrAGx5g/imfwOSwqazRtO44pO3kIV6YYA6HPVUEy9wyQn3Wiwur8Aa/imDmpknZPpyo1mF8gYlx06BLTvcnwuD6fgTA960QZoVLiYXq9H6ljpjWWXEvc33CNxovYM9XJV1mCCNnQNNIKbRN4OV9nvqzZHIr1Xf3uksXabc3vSCXVh0MJ7OWnXWRPRAduScnp3PMmhmaoFRWScd97o6nVwsaCG8Sj6/N++UvPJ1JAc/D5xwbI8QVH6Tm5y9V7St8CnG7sjMvByzAvwtK/Roec0I7AHxt4C9w54fYn9HRGzsT55dT9WRrgQDBOIDrcN8QChHgMqoVC+SPIj5jCFYC59Xa1WE0BbBvAWdo5mwFlOBy+uyKi6LaynRwNevP/isYzFUnk3ZsYS23w+JGIaeyOA3iK4WWB60Zbgl3NJNH/Oaaq+/vffGBDjEXiqjhg+HbFeF+XblkEsL6XSlG/hDDI4hid3RIoGnAIqF2BVh0jKp9iBW/VJSJ4LkjcUOcbDISXe+KMmIz94cFAr3zIQ0kjA4Uxm27WkznK2oNLEfItEin9p2kPGt2EEP55SCVKu1+xJ/VSPNf0CUBjLK5bbO6ltG15aGswTSixkhV/q/186PB92Cng4m3eX1OWq7QEbTANO3YF9O9ljLGNy0vfbC/QtkLeHSKoSlb+b0EpqEA0ZTkoNWEnrnw8cBAlii21KWRd0FdRtWsFVitVLwWSygGIZ7wGFwHvBfIDvhi
 BJa7G0Mz
 9Om9VqCNqq+9a1aS0QOT1V0Qitg+FA7PWzIvbk16In98FodJKILpbbBNBsCsilvIonUHXXzkqHSSubqEchE8OXDQ4bmvYiWKaW8XSm8sY46ePd4elj8Y/lF/0h/sHguX+TLrrruEQU9kKgjk91aC9p9XXtWAqNr4eeShU5Q7SxmBWRfIPUoelR2BuQo+MFugzPz/YG+2v3HBGeShEmj0NlrzGbet8gZ06zBw/aT0wuwWoZGBqtJcncz+2/ghbVXdu/nhqdTbZoK7m7AyYA9ccWDxptg==
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
index 107a28557afe2..6ae35f55764d5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1486,6 +1486,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

