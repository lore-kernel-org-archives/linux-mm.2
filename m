Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F47CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEFD6B00A6; Mon, 18 May 2026 19:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EC96B00A5; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA656B00A3; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 814B76B00A0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22447C3436
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
X-FDA: 84782164614.12.7159326
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86BB540005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJ+RRDi6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Exn9eDcOjVzqUvSiy20OrE4uwVyBbJlWb3MBX7UN5OQ=;
	b=UMo1DX30gOYuhmmKjmtCAba6+n95PASt6gQvS2RcW4doZEY2xl1kx8bZy3G7D89BSbtley
	p6PCgDK5QWTLWN0Tz5SbIavrOLT8hdg4SJ0iKBvk3Mr21IOvUNda6y/b1rJU3tdmnLg9Yw
	LOIeDzBMm+bMNH/De+mRFxAx+XADbEY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJ+RRDi6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147685; a=rsa-sha256;
	cv=none;
	b=dw6BnfrQ+QqjowcsWVgR6mk/YSaXrRmDnWB/RQCUPaW64OEhaIgZ8KQ30imqIRAsxVSo91
	P7LdJ8MDAmJmfZxy8U+v9arsN/Zlm8PDoxwHLFNiyK8j6G88d6zteXzAteNZtsox50c3J+
	P0TEtumGctL6jREO+ADgCri6aAwvHmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 753EF444EE;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F4CC2BCB8;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147684;
	bh=Kv/gTWHqRbjarAkUDYzqDqtowKyfqdWveUKMXCNryl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ+RRDi6YBmsa/4T6O0oOaztaI8BRoed5K2kxdEX9GjQoU0x/rODNv/eujhCdwa4S
	 b2y59gcw76olyuSLgZ27kWlEJBODOr+CpyXHordESuJH84aCwzwDHNB6Cnjt2SFDJo
	 j3Pk2ZqKMLZygNozt/DuGwFJDD+CtamF1mY4z2nZOf2RpvOihG95q22gjotx2zHbu5
	 YSEC/jarx5GJBNIIbHicVbilG/hmAkriybKNOBGUPEDg0JQIyElNWx34RrdPHnBqgq
	 Md40eGcrwVGzVJgp3o+vozedcZC+jQIMOaZ01kT9BmHd3vfZwHqGL2tsv8jvwQ6fJX
	 UCJN8PwdS5L4g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/28] mm/damon/core: introduce struct damon_probe
Date: Mon, 18 May 2026 16:40:49 -0700
Message-ID: <20260518234119.97569-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86BB540005
X-Stat-Signature: 1kgdhkf4oc4t3cdwa979zi54dacau1fj
X-HE-Tag: 1779147685-184660
X-HE-Meta: U2FsdGVkX1/LL6VrowDykBYsfjESqbElTJKkFbTykZuo7ds/F1xnYEwKTbMyJDbfqY9kEXd25KqEksqCyOd/CUyuu+wzE5xrS2Rl3YGf0LNTV2wDBX7pJd5Xa36cFyIAJXDMmil/KS/NvQzG7lhebWHWVvyRvMOS6aoB8F+iPyZqlWiE8zMiAZHJo6RPU5ny6dCXVTfzdcYiWyv7agRFLX9XF4o65ktdq6MorxJOz0bXbAmqccceE2pD6ZHmY9gHCd8lBja+sl+md4cdBGFde2ILA9DRfYTBGLuEXfSh7jHuUSzbV/kVtyJSBUkRO22z1ICpltIEK5B1qzrxVeWMebZ1YQBmXxwSHLug2uh1XlR8Smj3ASbsfJeoWAxeYC+pK3UFfXXgI5Uqt7023051Jy2/sPxBSl9NsRA6MfM6G8lqJZ0EM75hfgztU0s86Sp7fFZy5kH/rqHGvGwHUHTmaMg4jlk7V2Lp//R49dK/tlgGGMjBNY9hrNxQ30MujzuKBpn1UXqXvAjb7iBDtWRXFcZbHuB3JEmfrgLQQjk4MAdMqxkRaXIh6Hfj0qc7lyvRozvWg3EKw8VV+QVJIICCumHr61S4UiCwHoBpN1YUIoaLbXxkPZi2k1zqGoXFBv3mWQGxGV+RwHrHM+UMeMmTa9JwDKZypx4PeOxlVHrDHnN9vcjdsJCwkuvRYAuzdtStRVEB6px3EeUQ9gP8MzGlpyG1KuTIgHoWBPs2Q8jUasg9LGLjhY+lTT9yo5SndIyy4z9ascTH0DFqeIwXEVQAwsJ9mIJSgYfZLnyLyQ8Ica3lTxbaoXLM83PUxcmy4/sxgDsp7OhiMmXMKJpvUgpnwt0phzZLrEB73zGNxhErU8YHmnw1Oa+LnwUFZC0jCPvDqBEBjCfVAhgw7phGWB41juEQXxxbAhWDFIRN89oL/1U2lW7R+tziFK7JlFoWN8E2RlEn9E8i/Uyw4JCueDs
 Mo4e5oXm
 ul1d+xL2B21f/r4iEizIDbis68mxMu2FnCiYw/OoB6Bt5uRZnFG86A62dQwRErpQDjUDoPvFtVjNm5TvciV2H7Sz3jjmGv/S0mJfUzHDLC+u6Q+0f5fDDSe/egQTktDlaV7pcog19T78lU0/heJBuKDFrFiAW9o/QSPwAA3hSKPYIH09vdUDRAVWnpi3s7ToIKBm7NrPNaQZTbTfcAi9TB9l7Cb3NwvGszIxLmZYhYoErTHFa1u9veGNcN80pbq0eVmwOuKZjUIvuELIwJsgJfAVEhhCXCflD/fkFSTBW/ntNDJPRBgPSL+aNAH+cjlAbDCu+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4d4f031bcb453..4794931fa2ea3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -730,6 +730,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

