Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B30D10987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A256B0125; Fri, 20 Mar 2026 12:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531AB6B0127; Fri, 20 Mar 2026 12:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EF76B0128; Fri, 20 Mar 2026 12:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32B926B0125
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:36:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBDED1602BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:16 +0000 (UTC)
X-FDA: 84566993952.09.5F4FF22
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF3EB1C0019
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=XWOS+2BX;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=;
	b=O6amGJ6a7HtsMIoXe9l5gZgmqlTxlVitJAJmeZEQ1s1MyKiR4g5+o+Gi4IGwkhglHrFiy1
	2pTbpa+ZIgnwUKMuJ2hlcAiFcRvL/FKpm/dB7eNOBbzKntwbJ3qotVFe0QLeWI7u5pXegw
	jyNpTubu9JdT5DQdjYWJZqzJt9Vk7Z4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024575; a=rsa-sha256;
	cv=pass;
	b=52Tv6GFm9kTwGzcZi6n1OKQG7mhq29IAfffXCIiamUN0hYJ44gp84L0iRlmY2FeMBVcN72
	/l8WMdQsWg5UDleB9jMBUFj3ZV30QNnVY2Ncl3THCme0eSrKgU1LLqYVy+IfEHz+exwlOd
	1IF2b1V4NSjPSnhhKgVPRDcx2vIbe4E=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=XWOS+2BX;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774024565; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=fbWEpYSnPQTKtwmxLGF8DiucdelmuuJUj9/4VuCbp+XgAewF4l+1KCKx8Fkzv67o8Ls8PTpkl+9z2CAXKZGm1TAoYBA3N8M8wHT+0RZUcXZR057gnHceIDQPGFL9qVdsja79K47phyi4xWEzAn5d5oxH41liILMxCkpScjDqh3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024565; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=; 
	b=Q2yYD6NbDrV08oAoO5q/ZU7Dfusf9m7lEJVhMZZ1xji9eC29XTJjQJfMAGaGEWcpeO5khPUxAsvSUnBZ+S/L2LcTip3c1W/DVmhGcOOqOMucd6suqFkr5fHOzsp6S2jy2YfSXwq9lfitGHNvNcD0NjUeyje/fFA389pukhH0pCI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024565;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=ZOAuFTk2fYZ7Opzh+m6bCHOI9jrLB+RqVBg8xOebPgo=;
	b=XWOS+2BXKdlYAbPn9t42aq7nKVQnYSzg/WNvGmRcVR50uBMfSETecgYHhS0XdSN6
	80u4Ki2v/rnDLWAfENyt73PNk+yOi41535uTwU78G+HpMfkZ7SPF0B6MzofZu3DGI/S
	Ur2DmBgXu9eWcivL358u1yZOF621JYGDkormrTOo=
Received: by mx.zoho.eu with SMTPS id 1774024562740540.8427781838304;
	Fri, 20 Mar 2026 17:36:02 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Fri, 20 Mar 2026 16:35:59 +0000
Message-Id: <20260320163559.178101-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320163559.178101-1-objecting@objecting.org>
References: <20260320163559.178101-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: bbuxdpgjbi3833mz7epec3xw8ude9xqg
X-Rspam-User: 
X-Rspamd-Queue-Id: EF3EB1C0019
X-Rspamd-Server: rspam12
X-HE-Tag: 1774024574-208283
X-HE-Meta: U2FsdGVkX1/YZ0vFuW6Mapmx+iiUAZE1g5JAe5bK0VRzNlrWkmdvNs/ca+fMVqvEYkw419fbMuYVlmHrX4KrR10tVVmp7QRQT8UMGhHnn+ihYgEEQQOxMREpOEAnmBcCfuag+MAhGweKMq8ZXGxLjkcEtFWdebc73/KQb9f7cUJHuSDkOF9lDIAp+qBmBN0awUgsJr9CdLcE1wkzKx3aC8WXb2hrudbo+R4jgFEKLB48o+H93lPasa3klOgrB6M71pOhGPx0ABEcLltpwLwoq0MaD5rhNMnDPUPnprw+shkjqMHP1Dy6JK7WwVuPk5lNDq3qnAU/6xd16YqufkoQY1pXosiZCRR3k4zYFoyfAK2Xlt7UA0484hQTM8ifVhfd4fHzv4CcKksrFK9+LQLoxrOa5oznJ2eEhTelAsJRg3MLWe2hB+B4P+uz5aDLUHmXp7gjhCi22HUEEilO4m1akGit7PS980oLkk54yc2pi8NBUakoJ2R5paK6sjoDiwyYub2pyc4y8fS35ilsgIFEqkueQo1ehE5oHXn8FgIeVQRoY2Oqv9zT7jHXgRExbrdoteXmJ8y3yyV+ALnt6bJrhiWmj389GvPIRC4HYTPremY7lCdymIKIj58Wqr8DrJNE3962rMv73W+LpsbVXP1Azdvj/IWxSBKdZduVcpNUdOMkZ6IHDqC00azYVqzzaRILdTX6IGS956N6jOgc6S5OC6mFn0tUbWMOFxplrbl4A1gUwHsLvIdiabi+3VkVnKm3ugocIMaSqsCi5EsoJBzhSCz48gS2Z8iyyLFJi4GS8toqec7cr3XhUj9GeHYyW/NqY1A8H3aFvPAopxWn28xR0/yBVgtMyYbRdpZVtFw82Homymts8BFGzPT1n7QE2kQdx3VF4eaeloxzYFY7Q0ty8uwa2E+z17sMwYCbTiKJC5QnaFP4yXcvxokkuAfgFzJYbUR57zAc0pbbLkpi4Rt
 u/d65k/Z
 SOAFuFnXXq1kZDR5RQ/IuJReTVs/OoKHfOd8w4HVnHhbU+xcYOPsLYKCZenVDeV2ILJidcIWE+1k5H6LPqpU48iLUqvOYlnSQ4MS/3RmImAf533R6d+7sjVRsq/jK5j3k3PLAjjJThY4OLsaC1Wk5bEn7PJga/HtJKyWndw+iGGNFFnvuQQrhJRV+XQ33KlVGc0wKpEx7WmI2THzX5HHghTrlm+mBz6R1VxIWv5lhemCW10aM0bhaI+x4RuOKUz/G5trR7doIwxe3P5UpDZCL3VSgwq0FnT2z1fQi30YOtMcuikNMorcIg64PE4UQyEQPIC7NMTJSaJI7+u2pvl7dc4ByxBeFhA0Wm5JGFKppD2tBiYYOO+6qFbeMXPh5q7+U4ZnADsF7HmiwC4A6lADh/FcCr0Vvhte1F0wGVeu5xy2SNbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking
contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
running, these functions dereference contexts_arr[0] and cause a NULL
pointer dereference.  Add the missing check.

Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ddc30586c0e6..6a44a2f3d8fc 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }
-- 
2.34.1


