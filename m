Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87977CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E47A6B009B; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DDD6B009D; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7A16B009E; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2C66B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FA5FA015B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:35 +0000 (UTC)
X-FDA: 84893382630.10.1057073
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDC10A0012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HK9ZrErr;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795732;
	b=GqUxYH65lpiXAUUS8y2Hh/KAraDVlkLm/bKHno8dcXYYBLFectRuy9CP3skTSUcDtzr1pF
	jUAXX28U4/nuV5MVv/lPxzSF9R5Ia97eQXh3kFeEdvPtcdIKViD9EgziiJPZrHjdfzT/I2
	o+5Q64+eAEKzgBIohYe+nseZhuGfU2s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HK9ZrErr;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYOzMyZwHARxR0NZjcHLGHg4Al6n3ZFtJVQObKKPsUw=;
	b=ZenjiSITg8kkCR4zWqdapbBogxrdFK0WGbtBdbAw2x1erA6IazcF+ELoEeAaDFYUEs4DnQ
	VETHEejsZPwfVYZtwlxSKMiQSEc2l+XnYti3ggBgHeUf6PTj2CHKU3WJuOM4XG1Zqc/hmI
	aT0MLA7uIMD4IVLc6ofdWpA1w1E6bMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F68E6012A;
	Thu, 18 Jun 2026 15:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30B11F00A3D;
	Thu, 18 Jun 2026 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795732;
	bh=AYOzMyZwHARxR0NZjcHLGHg4Al6n3ZFtJVQObKKPsUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HK9ZrErrT/G95PukbMmY9I40KAE9YhFy3SmSqjosNPeVV2aV0AkD03Jgs7TOMMfZq
	 n/tbanT6cTPQsFXcukot33O/Oj4S8PCSNWnsO3Q4DiqKUjySk6MMkWkD4IPxuOqnpD
	 i1zAMudAtaqZvqEywGXUnC7lC3dr3rzv2PaoC2U17ulAqHJzGkAXEVzb3D3UKLgcJP
	 FAOf4f30h4xKXQfLH5Xnud+AjFDIk87Gc/7CZZWMpcQmAgQWLMGxsJKXpiUgzZbYMn
	 k9uUcaymjMkUWdt9cbqeKAhJeQQcfEBi9cdDNZG5Vdvt9/34wKztKESNfzq+B1verL
	 UUZ8B8/n3awbQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/11] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Thu, 18 Jun 2026 08:15:07 -0700
Message-ID: <20260618151517.5366-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3puykw156pnwcuuedojcoe1nz36pxwn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDC10A0012
X-HE-Tag: 1781795732-134790
X-HE-Meta: U2FsdGVkX18Z2KbGX+pCjxr7bEwlfF/EemCXCzX4cyKXxAQRc3ApNJr/INg5JTS2/BxCPb9CkrEiLMO9hS6BD7voMvymxeZoP+YZE5D357k9sxAgE6lXIake4SrFctKwDNQ5e9uw0v11hkPcw2bh6plzQub9MY+r075xRLvDIweHzqucQocWiPRCTnGUuNCjN37hB8QxdgzoiuCporj4kcd+eEoouHhqydN+XOxMmtD6lDXeIyXx/rDKbzD7fjpagCcC94YhrwSiW+1rj/9MSgqjSoxYKYk4M38L8G5up9BU2skq+5k+pg4hGEeReGOMWqXy/aYmEbBM+aDdGRo4gRBHfylb2uueSx2NKfemgm5cxpfsRL1D4mY2anzEWg67PY0VJjrYAAzkyJZp41OfhB79TKKpknZJF5Eayf1ekdpJDvKKbrHaeADNe6+iD7OfvKa5ejKQgi8+i2KP7M+0DoMNa/cTp5G2N+L/6Y2z9FWTWZyJ8opKC+yxAGZXn8MVFcC3Rc/U3QXljpI5PlgL8DbvYeJtwHg1EbUMWPjMpGUhkA1II6ftC1FBj6eZe85ei+Yy3hq+9OEL+X7L2uWV8N+Zp5PkfN5HNnoyURDwWt2TomFVggf3jR+TfLda7PEew5IPUj3nk3GWUA76WJpQ2Zj9639fvFw4mBiSjOd5ou+TRV2b4wUGXOS7M+2tl8K5XVeY5WXahJyPq7on/wD99XPHINKUGxLQQyHGHSUVv6o089lNH1AwvIeuwkW2nPL7XRFSQrjLe72GzDjpRoacYRalnTgFGMe4i8i0d9yi6pD8a53vINi8J4APg+LsjGoW8hvwIFol3+xNVhJe6kh98fPu42IbMVfuMpcDPhYRwNw3w8ouVnJhlIiDTVW/me3XdZIxunqIi7lB/Y9OviTyxTgGKtgHFyd3pzm4t3cXhtnL5dLdb7A8ahtuV/XsFpZ+yH/VYJJFGcYkOHFNIcB
 iL+5bYwS
 2F4tUCFuN3+/vWE21Wc57PJ2ALsQWT9Wr4nr16wHFp3kPYrUz9EcPkppOn9gIvucW/0P8mnsh9nW9P3mbeAXtJHmi1ZOszZRhkuyEdvTMddfOTTTVVyzshf65Oean21eBo+yMznIjO4d9XIuW54YYMlVAJa6Blp8MdApoUc5FtwS28OE7tRldyFzqMOD8cJrzNYOb8AgMDv7HQRh7zXrDzoQ7WXO8W7xP/BOPXfWX+nLN8sQZrhyL5pJZJ4rpPf1j7nOn8m6qY/6YdJ9ry90gSirYBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme directories by adding kobject_del() calls.

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0134111c3c1ff..13f5fae01800b 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2683,6 +2683,7 @@ void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes)
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -2724,13 +2725,15 @@ static int damon_sysfs_schemes_add_dirs(struct damon_sysfs_schemes *schemes,
 			goto out;
 		err = damon_sysfs_scheme_add_dirs(scheme);
 		if (err)
-			goto out;
+			goto del_out;
 
 		schemes_arr[i] = scheme;
 		schemes->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&scheme->kobj);
 out:
 	damon_sysfs_schemes_rm_dirs(schemes);
 	kobject_put(&scheme->kobj);
-- 
2.47.3

