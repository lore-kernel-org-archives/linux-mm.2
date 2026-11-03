Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B0A606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipTdl5kK
Received: by kanga.kvack.org (Postfix)
	id 6DF3D6B05B8; Mon,  2 Nov 2026 19:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FF06B05B9; Mon,  2 Nov 2026 19:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558416B05BA; Mon,  2 Nov 2026 19:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36E466B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DF9A14027B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:54 +0000 (UTC)
X-FDA: 85392000708.01.F86862D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D16C720002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipTdl5kK;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jLh+kpsC+u5aQYQiS3dDnOCEe0oaZ2yOrv+7RYFpbc=;
	b=2CZ2Mac5ni1eTPAqP68i1/b0acvxpyY+ClfvR1pU7kmPiuyhjwLk1vn+Gewg199BwTIhkQ
	OIxcsx5/GAb+1NyQ8GY3o7F32akcsUAI3giHqgRv8opz43+tafbAsAHw7PSOjyDjkxfV/H
	SSmZBfKK/WEpV7VjhemuZbekciVmjmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667592;
	b=mv2i7GGHZeczIxi/3f5H96tupd4uGpskw5NGkYQhmPFrhrV/Uew9FDks0xfeJDyOuXh1vs
	d/IyKigBqDMKbWH/W9dOXtIkNCCayqfpSuQNW1ViodCjPdCXnkkG3/OBWVth64OkRlD87c
	YLnQbSqTQyuOjzYlse6YHHUYfaIhraY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipTdl5kK;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1769443F67;
	Tue,  3 Nov 2026 00:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E161F0093A;
	Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667592;
	bh=0jLh+kpsC+u5aQYQiS3dDnOCEe0oaZ2yOrv+7RYFpbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipTdl5kKhCfP7SX3k7MeP8+CdBr96NVy9euQ7+2RvQHPRvRtjpnDQ/GpY3Y+5Ao+I
	 tln0MTWMcVnjkWzzw/1iqHZdSz9b1LE3XK6wsGV1UuRQbladcQRXMXM008z7VYdhey
	 eaHUgBx50G3agLmZ6Iyl9K7xmKaec8ST41TSz0/qMzOoM8cRRk1xHzNGjnHSwKaUWm
	 /JLZ1xh3nhjfPPhBBQVLdpvdCPTHdSP0uUmfKr5AaAIMdmODrX/21sWq2SytfSJ0qe
	 OMzWRC6L/JUpAJI3bRTwBwa2esgacwR5C1FTI6HYhO8scdxKIF5ydFbeT9gi3lMG4r
	 RZAJDXmcFTqmw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 7/8] Docs/mm/damon/maintainer-profile: fix subject-verb agreement
Date: Mon,  2 Nov 2026 16:59:37 -0800
Message-ID: <20261103005940.91432-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8mxe85qcuzwi4xj7pmrupt3akgrmzhbk
X-Rspamd-Queue-Id: D16C720002
X-Rspam-User: 
X-HE-Tag: 1793667593-984109
X-HE-Meta: U2FsdGVkX1+5jFa2FXPeHKySvtiiSFHDPzATC9AiDP4qKj9Dd3x9G7t1OV1jWiHpQiWDmjtI9YIhEUlpHZhleMU6l3lF8nnZf6fKUqQusZE+yuGV0vOq2AZwjj6agOL6NgSCOTpKjW5krowbPuzPhR/myAIV0RjNsqBR9SFiM7qPY94JGmu2gR7p+TVvf2wOQJRmNLDwwOXY2PdpD4Jpa6vtnwz7EAsPUtYzpYp4xXCcChv9tVsMPMpuGBFaFDHXq8ekrwodZVpgjfpnmnHOq618fAfk9BM9JD88C/jAgwSml3rDRcrwQrfwW1bp95QpfAGfib/VAtFBzdxrmBmZX5p+hBYZi+ryFsCwe73/MhLU0TGHcilTiriaqR6wBnMPcsdN0pzFBnSSxhxTDDUR/LhSGvau2SNiZWhbPC9cSgunmMjhFwykYGirbwMAlZYM52KpobUj3kSKmQqL1qomiuhR4SxLjJhmNH/hhxilON3GPNdZxKdSkkM194xF2cbD6i9J5XMCjOZcIPt0ecTee5uq4ituLrCM5R0GVrI+aUNrN/KLe4ZLXIXbnp4Au7Mhn4v+fRHfcxAc4iYT/9cZbS3Ez+bLl0sWvRImjVKFzbQciHO6wvDrPdWRrUiTuC0GwahGDl10ECuAi9TxDUecsVKwxzvrTkmqBuAW85N1Fl0VIGj+d3fwu1vwrpIJUd4iLaBPKpFH6y4NJJmeC5jra6up1Y8Eeh/mHyrgYLXr0YUdqHBZbFVx/fvyBnTnuqRbS60belf90qRG/PcWdke7LQg6/KCgRp6oKOTPjiEKBj13Gvs7NzQBgwTw3uREbz0DUC3SmGftfprkfdlPBk6peziTvDT6m5A5No+R54VebTmDwf42exYCEQS+dWSfCbgUqsyQeJhZdAhmwRCLkXjdNbv/IRfBj+HeZxr/2cwjQi3UerRvGb997RQL6IcoHk867lf4DHc1RSNoYf5+NtA
 /YS82XZk
 LJyMeRilfnLcz/vbpbY3SFoKodbrvow5rR6iQF/ivjmUEpwQgN8CD2VJFREBHmMXKZ8QN+xICvS0qifMLkTLTwi6n7/vCHh1SmrQZbjJfAW9vaiw0e6mU75kd6hRDwx0oC9FLWeNUh60x48u3fdpsFTORn6kozNR6B1bAVQUwsC2qDYoI4OiYNfjhuyOyngzSrgaA4h9xt8aJdWlTVx7lRbbuXx35+JmuQaVi5lxeDYOnMpntmZqObDTIUZGBf+1pKfd07UqJXnJmLc5OTXJyrN6mNKRCmCfp3gj1YqesgkFMdif9l9D6qrfX330IaStOn/RMWX52sfj4rP1C/1FudZTGx6GAVyz+yQLcJ2Wj58OJH6MhJa3j8g4IgasfUcOu/tgRZUwNBXjW1AN5PFDEiiOyb5JxEKxU2/p7e8qvpYBwlpbSjIuNB3nZE6RYFfW5lo24DB9s/tsCa0/AQXhDXPn+EF7bE+2vlOOL20iJWDOdtZ1u8QZCfUO79g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

"The DAMON maintainer usually work" should be "works".

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index a7c1352339378..c482690320249 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -63,7 +63,7 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer usually work in a flexible way, except early morning in PT
+The DAMON maintainer usually works in a flexible way, except early morning in PT
 (Pacific Time).  The response to patches will occasionally be slow.  Do not
 hesitate to send a ping if you have not heard back within a week of sending a
 patch.
-- 
2.47.3

