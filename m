Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54CB606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XdlukMeq
Received: by kanga.kvack.org (Postfix)
	id 6703C6B05B6; Thu, 26 Nov 2026 16:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620916B05B7; Thu, 26 Nov 2026 16:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FBA6B05B8; Thu, 26 Nov 2026 16:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28C3D6B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:06:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A14DD4011A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:33 +0000 (UTC)
X-FDA: 85478503866.17.4D8790E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11F34C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XdlukMeq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727192;
	b=srm6JumvvkoJi+vexLJawtmrjigBaKREg3ThYBs4O9iWow8a++KXATTTsONZVhDeJqWA+h
	QK0dOWMaCYH7/3Kk5u7f71QONb3e+mpKHdO4SSONXjKS8UJrwV5yPS+uKFVsQHG01zWEaM
	ERvv+Ov83jypkYYKlOphQP4v5uZpdjc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUbztBrsqn4RHPvpcYlZWejTXQHREOkSwYN78+WQ4Lg=;
	b=7e8ZI+J5maaheLc6NRLaaLs0t88TN0iEGI3+4ZO7CIms2Tl2pGj8jdIw2jjXVyDn/sqZIc
	uV6Z80uWn7X5oCzpMXoDctlTfZWhyVai5Z+8nhbmuwcssZ3IPEYc40s6pVnrdgiLyk3ADa
	cZcfRhrWrKQRs7khDsY08UtjbSyxKkY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XdlukMeq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C1174521A;
	Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED801F00896;
	Thu, 26 Nov 2026 21:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727191;
	bh=yUbztBrsqn4RHPvpcYlZWejTXQHREOkSwYN78+WQ4Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdlukMeq7xpgGHc27DpOm8kgjaGNYgkfnQpZ8FjwdJgWlJrW1PWW1u/sFOLrHqEvp
	 /CNhy0h/iBmCV/kO8ZarL2EN6e1En00c1b1Nnvf/QFBGipPnDmDZP62eg8GBVWR4xn
	 c6YyErTzTF9TDPw3RsKqewV4rcxNsSv+iY1obcL64PoL5QWQGp+64SG17DMtZSUq12
	 tTLRHgUcR+zcjYFGYX1A5cypHtmTEMstHiGZUBW3WjWu22qkYe0ewZ4N5eRc0D1X58
	 8yhXTLbIv+e6tZrrpAmWy60ihx6Kl47KnH6lfXxxBvpXwUXkrJcrFLhoyQOpbuORth
	 bxbKZU4kguDBw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] mm/damon/sysfs: use damon_sysfs_cmd_names in state_show()
Date: Thu, 26 Nov 2026 13:06:16 -0800
Message-ID: <20261126210619.97634-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126210619.97634-1-sj@kernel.org>
References: <20261126210619.97634-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11F34C0004
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3pbkibdek6kphmx5o4gisj6dmb7sqaj5
X-HE-Tag: 1795727191-750541
X-HE-Meta: U2FsdGVkX197pI3ZlP0TWbfk7+9xOoLSMEuJtrrtoiAo+ghfHXBi6r6czdpugQ0Z6Yhi0lyGOJRGVpU3o4zH/lij8jRrfOH9gnS/PV9RFDtAcVcoYD4Phrh5QeEEZvDWdUfH3+tGNJqXJrJap13r3ocnEx8qPBrqXgjgcu0B+EPXFrjNJlmWUz4SvjGaf2iA7WiMq7dKSYVUZ1GGwWrp6D437YEQpLSNqzJWIJ6W/kewfalW8MpXi8H/viYCdUf+4QwxMd8auu9V2ek5TwR/DaodQicWjYN7UNRcjUtLTuJTzIfxftCESgOy4OZ2AeMEFbQUiQfZKPLYWtOKw8eqR3htOgSfYclV8xp9zr+jtJ+rI0z4U2W5oAldKs4oZLMRz0JcrdXJsLPuFMhmNxGdvQ7Z7lJmFIPjl5TVhZOJliR5kxC5bB2dL8jkxu+Ytpj8eYO9G+pXPWO3IEytPPg+ljB5pA8bisVZV6/S7x19NpTiv5CGDPkLIUeKHOSLY8m2K/pIi5Tad3lfVGKntMo9TMX0c2JRw7fmRexJhd2TSwSgOjNqKjIE7LCtUeP20zlP927jkLi87N1GY/1fvVGXI5tbz8TaSABRoe3edpA3dqgLTDK6C0DCBMaFN/C0dEH4h7Ql/6USc370UtkjkRUKKKtrauEE0Ixaevy9le5HrPWOvK3H97e69V7D2/5/aivPN3vCb9MjrM16QETjyEBfZuY03fqf6t3p+rkNabZtSgDNxms8TJEatVLcXplK/2RFTZ8an5nncsdBE7Xm6UL1NI1J74QnNBMR1dj25K8Y/U4GLPy9M92lK2WokIFN2ECl7gEUI/C87jtKW5m5E+7gwewgBEOOM50/9QjGH9sAeLnZqoau2KdmbkljWZfmQyayqNFOLXt+dR5+pEmXa7nBtMOeH6le1J3+DXuOZtko+KqRxYcl7oFGcbfAmgBbi0h7Y5iMmQwDSW+xwwa0AIa
 lWWgTsUu
 52IWhTsFIlYifVM92hQR+Z8eaJx+F9MJzdrOxYdhOggSs+236EGXAR2Z5tl/8lwqvZLDa8DnlJXsY6+pyT7Z2v+lLqTvUKsL/GMp1IVE8LrroLEg7aP3joqI7Jr7gqmPS4mYTt3mu6Eu26MptBee3nF62XTiXx6BPvhuhnjMz30m7VII+MSDVt9b2JSfEuSbtP572j1BvqSdq9oVqhbS+caAJ3Dbmte0eQB0SiPVzTejcsfB+SGN66tO7T0xVLgY2ZzX5FD2OXm9wkLa7yhRlFl8aNRnKK0VhpTIwncH/fX4keQKcfIas+gr5vhHgygIhSLlA2EDmtMmZYy5Wc7NrRFxn7JjLo901vMO9eZnq6yTKriaMzhcZvXjGVuxAWCsffWnKZlpiPaMRiA4ugi+rJ9otJ7o1XK7z1tdxv0KL7I5+qOPDC+Bu3D6dZXx36Hqv/7ebtID6GRSvC5dalsoL1PXbSY73S+Fds93FOcj+cKoCh0dOm0vJoxIUw+4ebLN1m0TnR4mEcjsoj5GZfTFZCSziO5rzJUul1jPU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update kdamond state file read handling function to use
damon_sysfs_cmd_names instead of damon_sysfs_cmd_strs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e0ddf4ed5dbb3..5a91a1c3e4389 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2309,6 +2309,8 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			struct damon_sysfs_kdamond, kobj);
 	struct damon_ctx *ctx;
 	bool running = false;
+	enum damon_sysfs_cmd cmd;
+	int i;
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
@@ -2319,9 +2321,15 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	mutex_unlock(&damon_sysfs_lock);
 
-	return sysfs_emit(buf, "%s\n", running ?
-			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
-			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
+	cmd = running ? DAMON_SYSFS_CMD_ON : DAMON_SYSFS_CMD_OFF;
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_cmd_names); i++) {
+		const struct damon_sysfs_cmd_name *cmd_name;
+
+		cmd_name = &damon_sysfs_cmd_names[i];
+		if (cmd_name->cmd == cmd)
+			return sysfs_emit(buf, "%s\n", cmd_name->name);
+	}
+	return -EINVAL;
 }
 
 static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
-- 
2.47.3

