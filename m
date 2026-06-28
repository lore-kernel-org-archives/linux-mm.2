Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F833C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B33F6B00A4; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463206B00A5; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EF86B00A7; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D90F6B00A5
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74BF21404B0
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
X-FDA: 84930693498.26.2B503B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC01840005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jw+6fece;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684087;
	b=4HFHPVXiey8ki8BnvnEXdp2dROS6YVCDcAWIHltiAA2UnSsJO0QeaTowpL7/FAS6cNBor6
	HbQNLgLoiGdQEggG0VXlSdcQN5+G9g+j9ANjrs5ZmrlN8rkI5T7qBhwwoXyqEDpu2WS+DI
	89yRsJpUdwU7jZQENHMRDIFDHD6lV6U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+pjXniz5l+DZFZ2966T8l+kNK7vBr6GhD9WdjD8DN0=;
	b=uX6l6cmMDk/jn+X4+VBVX32h/X0ki9z6ZTU740BK7534tj2vLwM6TzwgVRapujM7Cukml/
	bCnB6Jz0Rr3EedDLkT3xKJbqZEVuR7/UulYYYWoUwwzLBTbScPVjMM6mV5GMs3p51+K9V0
	9BqkO7uzwsJs8t51QTKHSkrRnR4DxpU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jw+6fece;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E968600AF;
	Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066BB1F00AC4;
	Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684087;
	bh=W+pjXniz5l+DZFZ2966T8l+kNK7vBr6GhD9WdjD8DN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw+6fecewll4uo6ixbSS6RkYQ9bZBwzVt/+bYC6XImXkbcSEoB3JL4YSSMj2ZAtYp
	 bvL0UMqy+Xcy+SBSMuILBkba++Ki129enoePrcGAxAvcZkPiV3xkWUmlBd2S6Pyrql
	 2ZFjaVePg4+YUOQoOc7kLyyY/PtgMRgjbFVxmo/ksMaysMcHJjAqGW9yjEvWnSIC13
	 aUFpUvbiKlcFthRYpI4prcQ3vCnO1JELTsulfXnbBRnEzcqXgGU223a935i2WqKE5b
	 qa08dROb9GhH+Gw4fioo13klEc9sXJxB/H4onGjDcUNTQDHiNtApYVITufgXZGXDvp
	 zb78odzYuF2cA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/11] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Sun, 28 Jun 2026 15:01:14 -0700
Message-ID: <20260628220121.97360-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC01840005
X-Rspam-User: 
X-Stat-Signature: ihe8y9zyykkf8pgabmmxxw395gmq96fi
X-HE-Tag: 1782684087-731669
X-HE-Meta: U2FsdGVkX19o3EkaERwqVvO/UCdElR8bESwo/4ONyiFOTmBQa4G0E6eTwQp/8wrRHw8N7yJlABp1yh/wdx0KB9r484ed03PYyy4+66bz0AcYRUFCWR76n5vUkm9ckJnLrx7ko916AKF9qZ1UyVVf2CwKO90wiQjhnsnPftf67aAyBgKiSeiL/UaQRDBsMsEg1W4e0F5ysB3U/ujJKnUxsReaFO/omRtOy5n3IQzNEjpvpcrO1fzly5bJEKHIFxJTUrKNAQRb1H3AOqsKIR15ny9rVx7WdC40xZt8pzEoBavi5Hg5ZQ68cUDpvDTWIqIY3YwlFcWapekLJ2nxcUdBBAYg53FZ03b8r36PHR779ymzku7HNef2rEhaPqmIht6RrdvS6CZp470EbSUEchhkNGjgadvbuBexu6mk9ZkJ2JaobvLXAjs8Hogni2+unk0oe3aABJy01Y6rV9xfwZpGeLGgU/TPSucteAmDc6hamr8kqFO3lXlfsmncWckvZWXuBJ+ftfiFKoDqsh1lF0B8qhNGm4MBXYM84A0sbp730L0xtSPBVEPcKzgpiQ9UY8EyltLYbTLnRgjojw7Nm6VNwLqLkzUf6rCUjUAkNQ0NbnG7bpxmmSir+VEetQEqXelB/XshmDOJt6p/KYwpek02eGs+6JWQlHnjgxGW3nmKTgm0qg9Vub72or52R7v1jIvzIwwG7vPXU+SxR9l/qpuYLrAVm8k6+92acBPfEJPltNosjPlIq8952uKw3ujMcwroVW5LEDCoZ9mjQYgle1sJAIvk053eKlfXxsulnt+/QZ8Js+8Qk/hbTLRcIDKFyErGfGBU07jhH5dvu6ryCwy+l4Eb1ihhP18hR5N3JpXRMo40SRJ0v0ZnHuXjXPUXRwaIqsww4SlBYX5OO15cgpS2wt6GILyobeS6fXUFbMz4e4vDiIpWKP96p81uRC1+YB7W1xR6yQlj0a/5vcQFyEm
 6LxNETyZ
 UGiJSrRoVXi8Sqj95RFjWAUHIND1pG5z9264MbJTO9q9cW/962eNT1emCqV3wzCZJtCmcGSW6jf+s+RAWqbNel8KiUkqN997QbKwaVjEUfEObPgs0bezMO/j4f8HwhrPBqr/1e1404gi5EJ7e+c+sqNLg+1+fj7Vn0RfQfVn8MKmaR1mR6bnQhrXCPs0g2990qY+emmdovWYLIvg/bBubnaQGPNXRKud8cXo3lsefXGhbkQ8IKS1n6n7b6TQ2OVEcG51B70Dd9KkiW927vFiTizOecQ==
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
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 9eb28fe77b5b0..e955fb916a7e2 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -912,8 +912,10 @@ static void damon_sysfs_scheme_filters_rm_dirs(
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

