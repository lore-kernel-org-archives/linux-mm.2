Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C6610F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4044D6B0005; Wed,  1 Apr 2026 12:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5A66B0088; Wed,  1 Apr 2026 12:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBB46B0089; Wed,  1 Apr 2026 12:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CBE46B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:26:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEF381604A0
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:26:44 +0000 (UTC)
X-FDA: 84610515528.19.90BD480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 338D4120007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:26:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TbN3B/3y";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775060803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pa8ekVSRUbQdhoDYNGFZzw/tXiYVE1rOjM9+/MCgYZE=;
	b=pJgGDhcDqDdZELRwmFrfBPAxu9xOqa7+bb6+VCbPqfg7qtUK+duv0fm6SZYQ3lo9mBwwzw
	PvNytXZWscEHS8EPxTqykCoTM7v2ISAm5aC4RF60WqGS1vkbG/uSpGW4xCPprOPEJwhzn5
	hYmlhCk2hde+vFt0f8AKHEx42lTBWs8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TbN3B/3y";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775060803; a=rsa-sha256;
	cv=none;
	b=x1snOfPtuJdtp+Mb1yPTeHduxi2ISJko1CqY6xfQGFRZqw435vx+Bcg/1Ij6y0CJzFtcQ4
	fcRfZMSr7eT1SRizQj8Z/QFnWADhvdJWID9KE4nsEzAGz5sQ5lKU9fbFsxiJpKFAo1Rxil
	RSPerBiTYQmECFM0IBE1cFlCJqv02kM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 902B860120
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203FDC4CEF7;
	Wed,  1 Apr 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775060802;
	bh=UfYUZlFWRjzYif75WPtqwBzu4paaT9yYRTVyHk/Y778=;
	h=From:To:Cc:Subject:Date:From;
	b=TbN3B/3yiOahkkPLsC89z1Ytnwx8CxDMY8EfS6lANVhai8YUC0t53qhU8XpDmvkE6
	 I+6JzZ/t69YLeA4q2OidESocZY7EJVpVocCyj7C1+rMuapQJwcQ3h4LnU9KraGO0Pg
	 k3B8jWRJnKY8JnebryiOJLjZGJC3d4KpBLek0IUw8p36rg83IS2d/jRtLLYPkhohfL
	 v00JyYA0rpcjibsQdLJPHOGhDP+zUDRwTSQCHZocjlF/Om/tbx2g5ZHYHcz3wPK2kO
	 dXEDtFUH3OFI0LOPbVToT2f1s19Di45zAefsrpSUFIIN9njGY4Vg5LnvuC0zePp1ey
	 kMrsxDiVzik0w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] MAINTAINERS: add sashiko as the first DAMON reviewer
Date: Wed,  1 Apr 2026 09:26:36 -0700
Message-ID: <20260401162637.68506-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 338D4120007
X-Stat-Signature: b8dh8qhenei961addu87sozgbsho8zug
X-Rspam-User: 
X-HE-Tag: 1775060803-708378
X-HE-Meta: U2FsdGVkX1+autmhsN4g6eDXAhI1O/m+5PYANQ8q+FDvMIXFuNQ7Yw0YprQrktClxnR2updj4WColsPqI85/ecb4QEk8kK0b2u9YaVa5VqQ76PA0BCRDKT0gdDEKhahxFyuzeex15IetKCxuNzWtKLu7viE7mLqBxjaUBmPMvp/IZFxH1+moHkbGPX98zCJzGPY2EhxFdX/n7FC4XegJF61+RMfgZ8SsYRQkPkLXqqqzfqH3wTVoHZOmpZwgJyg5XdgfEoeWyoPlBkVge+JD5FtBP9juRG1b/4SbyOyAjcgCS5m82eaHQ8C1pzBMNcv5oR9EwZxWWJ/KuQuQo4P3OoF2bc26bthlBsjKxhUafSmpi0SeKDndiCbSu1pI75/7W0yMAurIp+LlX9vn4aV8EUTn1064l2Rzjx5N1NYwj1dsyeqax4t+GKlwmzKNbU/5yTjqwiImTFB86YIwsdFokhaHyRv7LCr0zyhGhFi1qO7sRdlaHPW8353tea3jwShECalGEKK9M4KtEmQ0zHWbbu0udxuauY76zf3g2/6XkuZALfgeYnNk0GyWXd+Yn0tlVHfTHAZt23PZAYpZ4sCXTi9ivsgm96yyt6/HiOpHNXGf47J6Lbzc4mlvtnI8QkeHReKq8lxZiRR5wC/q/vXAEUiO6M+oRExgEZEq2E0uXtm3GGUiaC5DbEVrb41MH0jibAXKtp7vZXtAmFVdzBRnvjS5+L94BuTrPXQvOPKIdbCdj5icRwMJMABdTZM7XctMmh/CDbqhsts2Gy2NthJDZgHwS5pupVvJfguf0c4dfexjUM5aguoPCTiUHdk+QrBOcxuDb5IOaOwpAw9Fvuoz/x8q8joppXfMfoUeMpo0fYV36/yLwLCq7byI2womV+y/19B7vHNXStutrTWWAH/o+1EF6xCz33fymAiRfaDOPexMu1JWNlMiiOri+K3L3Bi5vjydoWd61YQGlSWPHQp
 I9cvrWar
 JV3b8uyOFhrIrCP8BOPXecxY6pEdhs7mhHt8sFO1aXPxpgbCdfhTnV+4CDf6vn+oieoT6fTPpFFqoFppNDY1FXATcttPl/DH0fczChEgJ1c2r/LjdMjNOUsFfTaicCvyQshTAs/y7TeSQ+WoTUqVRELxuL87sFXSt4DM9C1PC1ypJd8AgSnK0Rmx7evpUNltyqv1DhaZrzSsiG0fZtsQLAW4s5UcwuIAYXW5vKfgxb/QdcdVz6+bGTHbn4BmXOSdgEqE8Z05c6O1l3WKGW3AQFhBSVATD3RDutoQKE/88IW6YEgvnXdM496gla3MYjdcGWcIlLusd69bhtQ32Or9s57pgkSxPsgqbKGAkwJBZ+3KasTAF0QzUninhAtT39Z6Q7iNu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko did arguably good jobs at reviewing DAMON patches, for multiple
cases.  "Today" is the greatest day to give sashiko a credit and the
responsibility.  Add sashiko to MAINTAINERS file as a DAMON reviewer.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16874c32e288..42aeaa858531 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7041,6 +7041,7 @@ F:	drivers/platform/x86/dasharo-acpi.c
 
 DAMON
 M:	SeongJae Park <sj@kernel.org>
+R:	sashiko.dev
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained

base-commit: 36cdacaadf95f0245cfcb76c0b0cb7e6706b05ea
-- 
2.47.3

