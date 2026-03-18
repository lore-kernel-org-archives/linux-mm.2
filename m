Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51ABB10854C9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6447C6B033F; Wed, 18 Mar 2026 17:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F58D6B0340; Wed, 18 Mar 2026 17:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B5F6B0341; Wed, 18 Mar 2026 17:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 414AC6B033F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:50:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF340160143
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:50:05 +0000 (UTC)
X-FDA: 84560527170.18.BAD894F
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5D30120003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:50:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=P3LP2R+C;
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773870604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9jwp39IT0m7ca3TWbCgZnTUx5QN4wqMGTxV1PauNuS4=;
	b=iJb6GgEYWSyJBQn8Kj3IZAeZMsMZH+L/R1JPASMzHCxC2aQW4M9/kR3uefDLFViC1ieaTb
	E3A8WfvPrZAzFTQe/fGi1e6dXBl6FlwbAnOwwmvVNfoOkeaeP92OMZXI6HB7mxlVNSqMaQ
	ByN8Sun1rVtx61/KfLTbTnTnRbA74Dk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773870604; a=rsa-sha256;
	cv=pass;
	b=HoJdti4oss35yClLdAgf3XCnEGzxH/2/zpjH+9DsGwZoXxDpw6tWQg0R3ctfGJau/KXp9h
	kTS0e9t630NeVhB7or7GLdMGadbIQLKFV8JcgG0l4qjSzSWuwLvtLvcxE3ROuoLDqnBPpl
	M8AziI17T5lJ4GUNFE+KkfKzn6v82g4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=P3LP2R+C;
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773870584; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=HrJwqVY5dwgyq045PYiPDEOoZOHbORtlX1PYH0rUqi9kDIAPMDqbHwaI1tKrFs+CV5/WfKwdR+uqxsueBeukg5W4JR7Lmpxe01kbQpePTVsQd+ziHoTfGRodI270VlJA4UUukgAAP/IjNzyNhfOTMyX/dUTeGChjkGp/hBFu05E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773870584; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9jwp39IT0m7ca3TWbCgZnTUx5QN4wqMGTxV1PauNuS4=; 
	b=FfhKJDq/IaXY/ecz2idVjrHhnwpQCQTE0zbCqsRtEr8OAF07GJjV1aXMtf3Y+5T8Tc8s7IA4eEm5b+E4E5ZVwLdtwiF+Rt4a7vVdg/xoZi2vKPt0VtEmuPvxzHS7nRdTkSciJF6ePHfmBAwa4WdX94/ejo5n5UB09Xmd8u+wwMY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773870584;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=9jwp39IT0m7ca3TWbCgZnTUx5QN4wqMGTxV1PauNuS4=;
	b=P3LP2R+Co4T2iUGaFs4ThwDzAV736wCwhycmy1FwrQ2b5xkh+1qPf33PZfTq36mC
	Q7a8cXaj4/L/Vo+tkDb1IJ+9iU0FvSLKKK0ELDmRVNWKq8Cvh2XYfBHAGDgHYLJrBLv
	JQ5G//CuEaWcMnlSAr9Ply0zWDgMkTzC8Vj6Dr/U=
Received: by mx.zoho.eu with SMTPS id 1773870581029691.3995812871057;
	Wed, 18 Mar 2026 22:49:41 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: reset nr_dests on allocation failure in damos_commit_dests()
Date: Wed, 18 Mar 2026 21:49:39 +0000
Message-Id: <20260318214939.36100-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5D30120003
X-Stat-Signature: xuzpd3igak5xgoprxxedui4mpwxoxdow
X-Rspam-User: 
X-HE-Tag: 1773870603-428163
X-HE-Meta: U2FsdGVkX18tF+V6PB4ng/GtDfiCwGswEzNQa5iB3lDKLpB/8bIBoDnBtVEY6nC7H6w5zFjdqouKwz1aHysPex6/K9EpCghKw273Cz/IYntM8RBCn5HwkCqnqu3Vgy9kUn9jZpRv8LVULplMBDf9Ra0fiqLJhKg+OiUakNXtVd2QRi98IwL6t5+TUqFlv3+f5jJ1oM52K722XxcpnfubWgaUzc7ezZ6OsRsRN5NejvtQl9aowI00/E4GnpoKYoxGRDNI52W9t96/ztXtYI1mpBh3NnuCCynl9SBjEBkBlpXNJswYrZP2cEAJ4YUd9HojqiHRqaiVPPIPKAiycZl/NP1AJ9SGD+yXTE83IBtp1RjK2HyOKZUrLRwhwzUaer2BznMBb7H+Z23fjrz5BlSm1/OhqfNJzxhPKkDu7BXaXQ+cS3AyTMraVd3c9irCvkiFZNlORduwA8l84Lu6mgMT7mzu/XGK4A8HgtBYBXOpjpwJkG4WYEhWRVIQRslyyBb/Pe7sM1xQ0cOmdYdjjoDXU10khzBXkSjoJQCZsUO+QiLwAV/A2Wo/O70WHPHTxCQ3HnkS4jeuZj6Vai6iWNp5YxZflxYLfNJmSJIvvS7JfPELmP4Igkro7dTCWmXdu7l2G4ro8wDwg5KADEpZ2sGBDHdhBGUhpjfs/k53BYGekZ7lKmOprLZVV4PRpQHTP0ermLOENkDsKKoJPb7NqcJGzn7USTG7VEqsRZSJP7L0xqldefQ6fwZVV1H3yJwkAKcPGsjZbhS9wnZ5gBtUxk/bluLjFaA4DXLpAcRq81BAL0jSw9p4hcIGhxs0eIu6m4JpT2Cv8qyPMG3jL2ubLfFnwukZkXlXbYVTf7nCgKBGy9IAoSLws+lbuMI6qUSuMy7iF4+mEXVXa7giTpKGCk7x5HUy9YB2x/TypefygsbNEIBA0M6FXgC/dGb3xWqV3J7NjB4A1PVJMZ048TUIanU
 ncdBUB9e
 3+ILrtYqiGluPuU1PfWEJX8D67hiG5m24YvQjShKXpjWM8HkeORAV6+8KSxhMxgktGzvRN3sIkETWSjpleHnRsRJuGCoQuRcRo4FGnyI+f9Z8Oa0GKt9ULwWh9gRXQqGl67peIyF1jLvHXMsXy8dwwfrbvPEIMSXoBc2rEl13H1NXgkKeJPWOg4aKtrrdhRXP9xdWSwRuSH2oI7aKu27P7tBo6uZw2cOSV9vDfNmVvOqah8i0wEXd0A8dBkWnGdSZ4R2gQn9/+cAKUK9A5G4Ss6rM7Vh43rRMuEPo+LAIXcaVdguN3jiKnaYd/M5wMs0TPiE+fL7D5Sp2FVVSth9tNYw9XF43/WmveFzUAC1bmbZToz29/DKKoxX9VpBuq6CBtNv8C0YrngXU9uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_dests() frees the old node_id_arr and weight_arr before
reallocating.  If kmalloc_array() fails, the function returns -ENOMEM but
leaves dst->nr_dests at its previous value.  A subsequent call with the
same nr_dests will skip the reallocation (the sizes match), and the loop
at the end will dereference the now-NULL array pointers.

Fix this by resetting dst->nr_dests to 0 immediately after freeing the
old arrays, so any later call always enters the reallocation path.

Fixes: cbc4eea4ffb5 ("mm/damon/core: commit damos->migrate_dests")
Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7f74982535ac..e233eb84a2d5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1060,6 +1060,7 @@ static int damos_commit_dests(struct damos_migrate_dests *dst,
 	if (dst->nr_dests != src->nr_dests) {
 		kfree(dst->node_id_arr);
 		kfree(dst->weight_arr);
+		dst->nr_dests = 0;
 
 		dst->node_id_arr = kmalloc_array(src->nr_dests,
 			sizeof(*dst->node_id_arr), GFP_KERNEL);
-- 
2.34.1


