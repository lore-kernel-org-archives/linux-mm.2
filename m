Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796D8CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 06:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAD78E0002; Sun, 28 Sep 2025 02:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BA38E0001; Sun, 28 Sep 2025 02:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581818E0002; Sun, 28 Sep 2025 02:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45F478E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:47:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4842BC1EF
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 06:47:17 +0000 (UTC)
X-FDA: 83937727314.10.097D7F7
Received: from www3141.sakura.ne.jp (www3141.sakura.ne.jp [49.212.207.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id DEE61120004
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 06:47:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redadmin.org header.s=20231208space header.b=G5FUZBjF;
	spf=pass (imf29.hostedemail.com: domain of weibu@redadmin.org designates 49.212.207.181 as permitted sender) smtp.mailfrom=weibu@redadmin.org;
	arc=pass ("redadmin.org:s=20231208space:i=1");
	dmarc=pass (policy=none) header.from=redadmin.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759042036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t6ustQj7Xfe3HKiERNgrVHhh1pz2uVuazT2CqYYtX+I=;
	b=JWQ5caxX+jtyJTpAhwGysLCVO4lqyNBKkPpIXwKt0EiKvL0m2aFXQ3pG24KzvnhMxS2U+W
	GsHRloKvvDr4qlnZq4YfXWTW6Jc/keNjao1g7PIILiLujr5z/duesadIQQr7fQv0pk6apA
	mPl0oCauNrCRhlXWpZMr1XC8ztygFyI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=redadmin.org header.s=20231208space header.b=G5FUZBjF;
	spf=pass (imf29.hostedemail.com: domain of weibu@redadmin.org designates 49.212.207.181 as permitted sender) smtp.mailfrom=weibu@redadmin.org;
	arc=pass ("redadmin.org:s=20231208space:i=1");
	dmarc=pass (policy=none) header.from=redadmin.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759042036; a=rsa-sha256;
	cv=pass;
	b=Y2LgxLTx2E8BtBlZuhFptKF4RMshGT4vVC4o4akVLiTpZC8AlU7+lAR8G6T1fVk9K+riiM
	Q4UYFkUynXsXA9VnFhD4/jR5gEcACa8jqsBNrZR2P8y+9NQ7ugDcE52Kdn2CbkTbDLgVcT
	s1oC3UQkTmkenZVblvkRjcnLwcqyb+8=
Received: from www.redadmin.org (ag129037.ppp.asahi-net.or.jp [157.107.129.37])
	(authenticated bits=0)
	by www3141.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58S6kw0D051679
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 28 Sep 2025 15:46:58 +0900 (JST)
	(envelope-from weibu@redadmin.org)
Received: from localhost (localhost [127.0.0.1])
	by www.redadmin.org (Postfix) with ESMTP id EA234109EFD83;
	Sun, 28 Sep 2025 15:46:57 +0900 (JST)
X-Virus-Scanned: amavis at redadmin.org
Received: from www.redadmin.org ([127.0.0.1])
 by localhost (redadmin.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id SgMd9GkpPodp; Sun, 28 Sep 2025 15:46:53 +0900 (JST)
Received: by www.redadmin.org (Postfix, from userid 1000)
	id 7E3BC109F2881; Sun, 28 Sep 2025 15:46:53 +0900 (JST)
ARC-Seal: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space; t=1759042013;
	cv=none; b=j+K2CKhOHrESoUHYiYOGxBoYd5j9Ey0b6TSHGOxPbSiDseNnNGvgsXvcfWta2V+MU1Agxf+CPR7Uhi+35UPwn+JFaE+fsnU8LoWnkw6vR7YREyEKo0GK8tMeSdMuxgXO53Z1jwL/tWOb29VErxX0nrrIru5g8denNRxDV2eXnZk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space;
	t=1759042013; c=relaxed/relaxed;
	bh=t6ustQj7Xfe3HKiERNgrVHhh1pz2uVuazT2CqYYtX+I=;
	h=DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding; b=HMt32kzNplHxRIZjrssxUZ4FLxqJNmv/Zxj87Y/1ubBx/yWTTGSsij6tm2TCUjyrkSreUm8oIzzBduDm2lR/NU6Ax06vX5BLfBFTkz8D3+RektbLNRRGwQnM16ADFqO0JWlqJQSg0l8mcDzqEemXh+pymgcw+Y9FaWl0Hm7+Jq8=
ARC-Authentication-Results: i=1; www.redadmin.org
DKIM-Filter: OpenDKIM Filter v2.11.0 www.redadmin.org 7E3BC109F2881
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redadmin.org;
	s=20231208space; t=1759042013;
	bh=t6ustQj7Xfe3HKiERNgrVHhh1pz2uVuazT2CqYYtX+I=;
	h=From:To:Cc:Subject:Date:From;
	b=G5FUZBjF1himgrUO+Abz5dIhQRc4vg2jEbeUDp7PUr7P124LRQKP9/cvRKq2gTzYD
	 omm6HWFpg90h5Rzy8H6iN6l3ASPQBU0vN69rVdTHFM43IfqsEV2IpYkpz1wlLjXZ8q
	 bYVsJ7nlNChytAX04H5zYyeONUVWQOsXUrnY2U3o=
From: Akiyoshi Kurita <weibu@redadmin.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Akiyoshi Kurita <weibu@redadmin.org>
Subject: [PATCH] docs: admin-guide/mm/damon: Correct typo "directores"
Date: Sun, 28 Sep 2025 15:46:51 +0900
Message-ID: <20250928064651.281325-1-weibu@redadmin.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DEE61120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: frc1mb4q5uqtfgw8qpedqwarerbnxeih
X-HE-Tag: 1759042034-132110
X-HE-Meta: U2FsdGVkX1/uMrqhsmYQOqdd2SR83hb00rLgrx/TVGLrliFPKfurCHi3dANlHOUKb6FrR7o/9iJBV2keZJw9ZAKmyPr2vRw99p/U+x1qDcWC4e3OmqogJmqY4f+7iN5slk0LxiKmJEZY+Sy04W1C2Nl+yxAUg/1knXBLhoGSdBoZJPZ9zfIwdnZTRVaZMroQUKVwWy4TeyzGf6KwFTVs9aT52nMhWUja021BJDhZyXuiZ2Bw8r6duqCl16hbPhzkhZ9d5SsLW40cxG5lyEYcOfEANEV0TjjxPOiq4itOYGCdQ98v5xuQWw/r6kNxsMT0RjTq1Lv4DZGjKHp5jM4nXEcXc9RtzSQpt/QKib0w6ZfPIHVYSUHBIBvz2CI6kNVSfvwj3j4wNkGNgPbc4EJGLYEbcW/grERi0Q3SHbCkvVKgK/iRHW+19+zV7GAm0X5ULZ+QgtoguNmGNNfP6MTcdqivpmvh/aPhP3rMg2qKCPwyzngMnxU+GdJT9Wpjl7byNUsNpiJhdMSGS6bbxpSRPhfIom+4MBuI5pPvL8s/V6JgfWZHYC0+A8o7vRvfN6xmKj6Lkg+TxD7GaQVZ81k9qAs14iM7knX2hI3kOwzNVopFhrbb1/gFwO4hYVbNGIzjQkPsBXGSXZL0pt81ySWbZGo6shA9413e7+zMDQeaNkLV5a+E8tbqgxr/lddAip6q//KMQy3oz5z38MpLGWozLRU9bDjiz0Zus0qxOgdMPihcmxx5FGKagWmGvnd4cdhlpPZ1BeahMxuRozk6v1QmqvkCu23m8jTBfcnn3COPdm9IR6rJW5qoadyxRRToUcG615rVKjIdYDRY+uybh1WOJMgtCvPgoSFwqpPxKyTchBqXM+YmJ4xay3oMApH8xM7FacxuUb0PKlS+5T2lqITfPi8wWlIBaSBU4osovCvynA9aSlGyw6hlYp8vZ/HzYmbCyc6sXL84bw7WF8T5Kkr
 MHn22u9/
 B+R7IIFILcl9Dp8x2t636mU0MkQUk0uLfZ9lqAN2c8VfoZKLyt+w4peFNhCaC5FKFxRzOG4fWLKlsCGbWW/Dkxoqsh/96emaJoVh5w+DlsnyMTECzME3jMb0qGM0T5qu7cijBmsO91ATDC1Aa4SL2H3spjhHZ9HxDvytRHmQlN5TnPehKqBnAHSiCGnfM9cFBHAH5tAlL0oheYY/Bl7lpQCEYibLbL9tE+rqKxbR3bEUCEiq9UTR3i6rBT+yFL3TNvJcCj/Rn+vJSJCpyLInCQJ+AcGKVUbGeP5RfIvZLqYUOqGxNJ1Yr4G+9PV7UACj/LWGmL03H4lTJeGqdnvsT/MMgDI3ISaScXyQR+vZwISVX6eisLb8mpoI97rHa5HJXVoNJI2VAItNyZKhKNlOmQ+EcWwbzZ4GM4JEK47e0Un64R4CaRaMcyiYhzKTWHkovq/U2WLViBm0ZSE5yJ5JWmftsD4fe8XtXLzPJVWR2F6rLuRuqC1lhyA6YCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.015384, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The word "directores" is a typo in usage.rst. Correct it to
"directories" to improve documentation clarity.

Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/a=
dmin-guide/mm/damon/usage.rst
index ff3a2dda1f02..5cd42d428c89 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -357,7 +357,7 @@ The directory for the :ref:`quotas <damon_design_damos_=
quotas>` of the given
 DAMON-based operation scheme.
=20
 Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directores (``weights`=
` and
+``reset_interval_ms``, ``effective_bytes``) and two directories (``weights=
`` and
 ``goals``) exist.
=20
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, a=
nd
--=20
2.47.3


