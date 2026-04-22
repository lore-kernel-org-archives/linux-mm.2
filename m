Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FE5F9EDE8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB546B0093; Wed, 22 Apr 2026 10:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CDF6B0095; Wed, 22 Apr 2026 10:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE88C6B0098; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C10626B0093
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:35:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CF54B5A69
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:11 +0000 (UTC)
X-FDA: 84686439222.10.C3BB8F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1DF214000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:35:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pomsCqr1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDCNvIrftSVdm3I6wvPeIvr7edsmuv4Jfgice6PerE4=;
	b=1KKTIBevqbfSFwfdGxAwTGaKCkeSLYDk6pEqFp1YiTTRZXz368YncdF/QUr1rijZTZHzEw
	sMoE2SCuweQ+QBqksDDDZNRZPfFQz176TbNzvwF6u/kVTlsSZWfNGgDL11yUxDZMg3wGg+
	6De+6fev3LvrHPemFJ1Y+gVcgFs09qc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pomsCqr1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868510; a=rsa-sha256;
	cv=none;
	b=Seo2fpNk/AErSe9/Bz0XDnHDqOP9DPo1rhbfuQh3nX6nZrXPNXzP9YXSz3IPxroqizY7lq
	aZA/Cwvivj/hrBSaaNmaEFfsdLpwt+HPmX6lF7rCK+/lgGnKaBdj2IfQSWQxbfpEhdA8Nw
	RZBhiqdej7wQcIyrrXqEX/a23/oZass=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAB4643C01;
	Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767A6C2BCB4;
	Wed, 22 Apr 2026 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868508;
	bh=phPSB3hsN5vcta7v48KcUcyjcHZo8DALfnPrjPsZe8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pomsCqr1yF5C/tYG71y0u5knBxZDPNu8jOtVIz8EULIbQ/BnIhYMFquAqfIrBrsmc
	 uiSK8toywvsJI50TlUAzEtP7y0pAzGCHCmUGtSPbT9TMpiimgZoeE/XQeXFfXM4ZvM
	 ndVypsrEmtwcqpdA9QHaU98HU4WcWzvFwmot2DDK/S1NFfB/VYi1eKrE3vcQDI2AF4
	 W6ebe39N0NmhMT07OvfcPrLMVDL85n0ArqhBszKLldyuDEr6RqdppAwphxSA8isIrW
	 gu8YiLT7b4/1+I68ihHiTS4wBxvnWppLdQC3TBU1vmQoAUA28ofVWRGR/+WdH7f5Xn
	 koRpV4sM6CnGQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Junxi Qian <qjx1298677004@gmail.com>
Subject: [RFC PATCH 2/2] mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
Date: Wed, 22 Apr 2026 07:35:01 -0700
Message-ID: <20260422143503.71357-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422143503.71357-1-sj@kernel.org>
References: <20260422143503.71357-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1DF214000E
X-Stat-Signature: 9eogx3ospxk9cc9taipm6uck6p6j6qbu
X-HE-Tag: 1776868509-36615
X-HE-Meta: U2FsdGVkX19/czMbbXvldAeh6MrOL6c3p3KkpcvRwhdPGxbz7rInrmnNi/iSpqrNUm5VjNUhOu0NAnndcYyMdlz2YAv8cOzZADJT6kMf+k8Og6PQ7kMSvJEi41TAzDyjevaj1vvE+h2SsvHH+JuepvjTiFEvdtCVjKmoJxOvjlzi+tm6PeboaAWEelkI389P8r0c0fCgTR2HsuiQDm+gcrMK+l7UUshVV5SOBAdZOix3BSJzQeTtIeWcMDShcY3xqqcwkJUQkexLznbB2tWQG3xLJVB4RiZMkhs82AJI+fdGnzaeshaxEeYqaSRJVLweOp0zYXCUVBNW8zwwyQhUjQpjtX+AIdIRsnMwL+6zMQ2WkdeW+9ezB3yPqlODaWCh/J1ThP6EMXPGEJ/h9sOl9SER7uvaYz/pAiSdEHncd6vB7pv/T3Fs8mX5AWrdqtmOIGtPdNpR0FRbs4FzViZA2LYufPvxl9+b+W89kLMTyTHunoIG14xP7/So1Hzmz6akL3qCdpTg0jn5xjDu1jhXSr6HuBEi6X+g5s3wvQJjtXVfjRLKIPZcKJv79tRz1wysLhNAJsdfOL8U+f//YkN+3f84ypqmcY+UgBfcKebm9bbS64ul95ixR9Os4/Y6sFa8TPUGMT/krl/bzeDhedZk1wdTw1JgB3VUaR0licpX7Xhxiax2PGutd/NwmEkZ+mB4whTJtjUOLssEfk2DOsdhZjYzFj2BywfyvFrFd6kyU22I3l1MGI1BpQnHpCBwCYoNRLdStVjFA4fVzEpWsz9ws8NMEHIGt35uw3Fd6DYm3tsIycHUKFPVLun09Dw3GfZ6WgI3RjqJ8v7CMDc7k4FFtu4bPuwmMu5Afe5ZnIB3yhNXyFLnrYLWKLC3ZW9zA6bMrSC0miAwWZb37FsolTvxFoczSTfynTJG1qbFccnsgXcoGDwhovloOS9DuVKm3DvgMTXCFY73HEQGICL0KcM
 0rLJMAdy
 1AqxBvT7wKhNwnUuFyed08TL7rPGYXXPGhkeQ69SG8o1kSdpSR9VOiXS/BLi/arNmLnG1ln5Ta8tkgJvvDyX+zo4LRS8Dji3UGMW4UTQ3dtSlJjGJPx/sMlwYpaU5B4iatOFlpJGjX3QPsGBREFfeQwF4Dna3M/wwC+6uebesmVZTj4LGwMTnLPqIK585BsCIEzTcGdH+pEo6giWnluyIx+RywRqDksj7RadJSdHAgPZ++jMccWx/a65P+/4q85xL9LNYtG92LARsX/v3Se4Shb9AE8uldD2hizcjeiDc/u7u7rJP/pQiuZNMkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_quot_goal->path can be read and written by users, via DAMON
sysfs memcg_path file.  It can also be indirectly read, for the
parameters {on,off}line committing to DAMON.  The reads for parameters
committing are protected by damon_sysfs_lock to avoid the sysfs files
being destroyed while any of the parameters are being read.  But the
user-driven direct reads and writes are not protected by any lock, while
the write is deallocating the path-pointing buffer. As a result, the
readers could read the already freed buffer (user-after-free).  Note
that the user-reads don't race when the same open file is used by the
writer, due to kernfs's open file locking.  Nonetheless, doing the reads
and writes with separate open files would be common.  Fix it by
protecting both the user-direct reads and writes with damon_sysfs_lock.

Fixes: c41e253a411e ("mm/damon/sysfs-schemes: implement path file under quota goal directory")
Cc: <stable@vger.kernel.org> # 6.19.x
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8d32a20531d49..245d63808411a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1197,8 +1197,13 @@ static ssize_t path_show(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t path_store(struct kobject *kobj,
@@ -1213,8 +1218,13 @@ static ssize_t path_store(struct kobject *kobj,
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(goal->path);
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 
-- 
2.47.3

