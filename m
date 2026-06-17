Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD9FCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0EF6B00A5; Wed, 17 Jun 2026 10:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051306B00A6; Wed, 17 Jun 2026 10:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82FF6B00A7; Wed, 17 Jun 2026 10:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4C776B00A5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A3C88DE60
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:49 +0000 (UTC)
X-FDA: 84889686378.28.403C348
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78DE314000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0RujzvK;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apeCKq9Hxx5icDF/JvpCpTO4zm17bsS1r78YB3ZGzD8=;
	b=X3EhkMYpUhfzvqdU1nqwlHh/NIXON8XSetH/yJsDHt+HwW6NV0wSKGXuowisPxkxacieTC
	wN5J6NR2UbYLH321ZqkuAjReBo0zlR8k9uHizWXRRecjOChKsSErwpgg6VuqaZthrcpz86
	Zk2rfY6P0JGKP5at9+RNwN4wWdaNsGU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0RujzvK;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707727;
	b=swwyfwCS+0+24jv99Msa8sGlYZTZQew2JtqwI6v7dA7Kbzkj3C69C91BFLOnCxtoj1yImX
	4m2vpGyKzkUBFZ/KGj2sM5on5Xm6xV4ihi6qcCLeFH32kfidwD9Kc+gpNeJX0jQ2/QXlU8
	38PoDvX0beHu3vg1Yk6WMbjXmvPqoFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1570B60137;
	Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9E11F00A3A;
	Wed, 17 Jun 2026 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707726;
	bh=apeCKq9Hxx5icDF/JvpCpTO4zm17bsS1r78YB3ZGzD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0RujzvKdowxiou2k5I7rDAbBol8LTn/gsflatroNfF4spTvvLI9+Xq21bydJ6894
	 n0mhMH1+yEp8xOxBtcF+hbScJiJCl/8qfHvuRxXruFbT2nkVOhn6EqFmJFOxGLJI2q
	 61QEXsZM4TAEc3WIsoz1D3i+C/qOvmhcVYrHheaHqF8R45fDfkRcqefguLn+kQBGWi
	 KuBZaWuNL3GvDEoHbj6PelLI+4W/IOAKUKyUgQ1C9pUiXdBq8PqrWwzi1FiNVRKtor
	 2DZmvAh75VbIB8T4tNZqWaBpKu+z/DldRKjs9FdIUX0dYLP1fOFH8AYbCYv0PRht1Z
	 mI2fHcS6Lo3Ew==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 09/11] mm/damon/sysfs: kobject_del() probe filter dirs
Date: Wed, 17 Jun 2026 07:48:03 -0700
Message-ID: <20260617144807.91441-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78DE314000A
X-Stat-Signature: e3nwto6prgwmcweecag1qk3yfanynf5k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781707727-863156
X-HE-Meta: U2FsdGVkX1/38spx1/jsasQePrOhIFyiD7EmstpWqBDu/W9HpfyyHf4c2lF6YMWyKKz025GJDdw2oKOP2Kgsr3lZer9Zl6gW2UUWeJQ5b/aZSc9CtgQ5hNQJKyHZM38HT5uo75fikM2QWMz2/yGJv2iwx9KMcLHuLG2E3DUDAmlNjnAxPvMt74aTFhleeDXRpcgKPOojItBoPSC5O0jy8d45H8+kdldgNlEIVkM2kAs5Kszj2X6llGMD40HFqpjBD3KMbVTcZsPdHqWqNkikQqKm/Rob6rYDO/DzimDivopUNU04K/teMACLAP5BV/TdEwzax3VYifOR0n8JEH6seYxqYkSlW9cmjrou3dKKxffgCMND0BDw9lJY354LEz5VyyUqB/M/QR5iq3l9e9Rohm7xnNzaFdDzaufBMhNsz8SKQOBCNXvaFly2ahyAwf640aNnPMg8yMOEOeEai4cTmjqddtBKpTJni8Lo/dBy2PMj1hO1wL7lPadSQluMVYmVG4IBg42PUWC7dYIo80iTy40pyZY8fkxStZxeBUfK5pvd3kJI4o0n/lm741KOPqRpteZHhM1pcoMi4fIZ1wKWgih7L4b2UtOC8OLDS1hTuU3knCuJKEYIp+IZn5j8/BbKjNDROTySCMz6iAKOloStLLxSmTVKwQ3Dx7JWXy2HE4a0kn7JA0IrQ9SQ/7GMMMWK8sJysweKiPCQy5lJSfcWVITFkxLLMA15XmFPpwHCghPP+dVzGuG/OxbjC0NGFz8YyWVKW9r2N+V4GW5ZLbR0uGBwWdeZlWnNCKbK9MjjS9GnqkKxkhmsCTER8knXdPD7+aVIe8HslYpbZJdJh7T6U/R+ULd5mITaIENJCDDb608WBfzzX0V3HboIwmgRx92YYM5bFse74aWea4xSnOl3tTJLTwUWAhwkw37s9yVEij4Txgg2xokhUDxw+vbUTKq13rCGOml/51W6NvR6rZ3
 /QITTKg/
 TSavCg9nlGc/G7IUxhd58w93qf3v8DTeIRtoP/zB1aJE3QlrEC+DqxQtU1x/dDi1q8OALc4LH+a0waezESTydrdTw9um0H38ueq5K+Vkxh1LnVQfmLXugiyDI9KlS7dKAy0XCkQJicGXzbzdpoCxU4hN5wsckIWtTJJhCCoPAiUUmr4N1nxX0NDBVT/vd4xT9eEItfMdGBnrYIzycVdSQVntGayxex28SvyX4X0+hzc2fnNdAiRu68LpekT04d2iIkeHb5pInrkuh096Snp+3sQVYTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe filter directories by adding
kobject_del() calls.

Fixes: 82e66aef7714 ("mm/damon/sysfs: implement filter dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5ca45654cdd39..36a0e82601697 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -962,8 +962,10 @@ static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
 	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
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

