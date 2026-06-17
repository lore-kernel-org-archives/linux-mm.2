Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A78CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8906E6B00A3; Wed, 17 Jun 2026 10:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840DF6B00A4; Wed, 17 Jun 2026 10:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F566B00A5; Wed, 17 Jun 2026 10:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A86A6B00A3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF3A51A049F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:46 +0000 (UTC)
X-FDA: 84889686252.09.779C830
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 232BC140012
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTSK+CWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaF8UdvZVDDussggfwjRLGsPjlTiPuwSrEK65nFYR9w=;
	b=hcJm1tdGcQFtWI0Ttlet0YUBm2M7FLwsjuROahg0fQrSsbBpYJnKL9woSU2nEVNzWyxteu
	OH4TWprEyyeRPcaHD7wrM8xmOmvIW2sJa+7d1aIRipV40K7FwW0cKnWP8T2HJSxnJ92y+C
	jIky9LAOs5E0FxRBDi651HxvG4RvIaE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTSK+CWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707725;
	b=v16WYC+beWTfy3pHL4awYMYaL4dvtaY2H9SQK12h9CMCu+M32uZsfpohhCeesYiA9fpDJf
	OzSWGLlW/2Y53d8J4VSjSA+oiiIz6BdflpqkiwW18iVubqsqHBBX1Kw/3+icjHeV3SLrHb
	+ZYcaynIM+iTQ3ogCaJUvIR1/AxWjR4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73164417EA;
	Wed, 17 Jun 2026 14:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0B41F00A3D;
	Wed, 17 Jun 2026 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707724;
	bh=CaF8UdvZVDDussggfwjRLGsPjlTiPuwSrEK65nFYR9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTSK+CWWyy07fQAd79Drqssx8EIz0d1umquuzvD0ZbX8Scsa+HOIG0PyZWxPcJnOp
	 YIrJZFgZSdwLv3THjsKukFxPyF7a0dDVukj1UTz8zG3dAuqxBVmOimH2rH1JWydV06
	 VZJD69fV6T7CBSfscjR1ClWWhXsxi4q7IQa0DkOyb6syaZe02+TAWtA1M2FjKZHX2H
	 UeZUe6NjuIpfz6GOCv8jMkDi1iVDG8uQWtmi1RTcx/tDdXpUndGiAFCc+/UV7H+WQ2
	 dCEdxRubeJnecn7xCBAMuWJoALKti7qqPQkLz3mC5zY7cXfzqd+CeftszHLhCwimUL
	 ln7eIPlXC776Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/11] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Wed, 17 Jun 2026 07:48:01 -0700
Message-ID: <20260617144807.91441-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 232BC140012
X-Rspam-User: 
X-Stat-Signature: pj1y9h3jum7tu5dmwxcj3wf1dc7ncwkh
X-Rspamd-Server: rspam09
X-HE-Tag: 1781707724-107027
X-HE-Meta: U2FsdGVkX1/lRp3xG+3WETE0rX+OlI3PF6QL1UFWS3Z1bv4xO9S6Q1/4Si5j9bXTInlrHdBwY4s7nN7N4cnF4tHPzEMB3ptDdH+DtonLaS8MM6hiHGeJpYSVPEdN11Y57RVP8+dmK9n7Dalb5RPntg6LjGycO6ibsRNgR3nAJbEVJEFbMixLGaiefPhVgnnrGHCq9CzD1bE+0wQNIUljscec3oslDT8W8f8AlAeAFz4KbaRFCAgr5644QJ04VTV9exbsPRsPLV/2FpN2iZGVPDZYPUFlBMaST+wd2L9+dgl4RlDmK6i7OHJcv7yh7mFKtPjoZXG8G2lZA768jXQSmG08k+uc903eO65qTkuqGgpBYLJe1wMN8aPfXXS7BxU1wsoSnMlmabDPshmzB2siOzOnMA30As2VZtZtwT5z5Re/vM363HrjnXmjB7+DUYD4SUXhimq/HaiRBS7gSoMrJDyRp7MXsIDDntH3EP+kHSm8gnfJsm1EgR694KDN+39fOwgSbfL5mo/lX5VSUHcyfeLKkbokZOuYw7vnjci3VIGKp7+AO/VikGK/WfQ8ki94Tfofyrz7Mgzgd1jphJiDrkGiBdHcT2fp8o+f5AgNr7X1yzgRdO91ZaXfvK6KcmtKEr8RQAITcWULjFGitNc/sLIQD6p8jcTAZjCwQc68KXMk04LT475Tj5kYq4vDVLq7bbFaHUhW5+U04TmxBHxtfDRUV9w6b8Y12Nqn8bSO+sGogJpwi1H9PtguOo+R2X2Z+t/WXYj2ZfqwO8MCtHlN+Y9PFmSQuuYUScHLuO8omNIPotb9BjwPfUOh98Xce5Ac/RzmOBhWvt942xKDpREY+rb7vkgnx7ynFRJmCUdpCbL4vjgb9OnVAokxrBtVX+it9ycmXlmKTEe1BmPVOrQj6hUyTrN83iV1XdGjcgWy+erwonY4+hL9Aou3+eme/IpK9CsGDhjs1xLmIYn6Tf5
 g6UOSSVE
 tJtVImL7PVMu7R1ixAGPXAHi3RkD7ld+6r/bz401MRqN20WlHq6ZVcpd+Yus6lu2lzUJ5HhPTW2i1GByb0hdt0C5/pctousnAWL/3GFDbWps64BIMK8tY5usB3a+cAw3N0cBHBdhjGgYYrgVaUr2zmqyad3MIhlKN6HhmSKK2p16WsieFA5DKe7Mo4kiK+bFaBibISQvPRUVIK/s0tcJiLhuIXb+Nc0AT5s8ON85mGSrTkHygMMJkn+g8muChEIRkj4QpxpRD/TkCr9VhwbmfULKBgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 573a40c679be3..0c0c9637b594e 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2145,8 +2145,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;
-- 
2.47.3

