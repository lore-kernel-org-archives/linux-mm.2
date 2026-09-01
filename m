Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC0AC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386B16B00F4; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8CE6B00FC; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A546B00F8; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9B096B00F4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BDD3C02F2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
X-FDA: 85163927184.16.A833C84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A57C440006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTzo9hnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvjVwrKDCl81hZl3Hucl+fQ31jeH/l1NQNbBR2m3K00=;
	b=cNV0yOZxQIAUpzL9qa7g62iBO1+9qnNFTbphsCGyM0qC5ZemtlA6sL0uZU2pZvrim7eEOI
	dyud92C4MBkdN1jYS6B1lzK5nBW536uFVoT/0FqJ19nmDHo680smCKRRvDpAlLEoR52S2Y
	Uzzjaz+d19GSyoey0d9rH18Gm72nFj8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTzo9hnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237270;
	b=qfPAqcBXDhhiA/5+H+w+zG/F1wrZjVGptLowRdwU0MBiVD04dI5ADSKiZg0YpyGtQHh/x5
	VGtHivGHtr6bCWRXKLTjg8h2xEmLR/yDm/I3l73wm5jeanWuh1DGSh1IYVzGAuYHYp5WL9
	+BuW5gJFjguW8Yj3HwoZbQayoB112HA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49024601DE;
	Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6351F00A3D;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237270;
	bh=gvjVwrKDCl81hZl3Hucl+fQ31jeH/l1NQNbBR2m3K00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTzo9hnSZ3LgHhEjR/PRg6krOJ0vnAKee+e91eXZjd1+zgBolao1R45AAXvM+Bpin
	 N2a+8cVZ7DwGdJTdWrWbQqpzYQI06ql/o3ciZ7B/A41HolKNlGLhjAWzEyQGlyDr7C
	 EefPQGp8Od9xiLkLdPuLPex3wFS6oB0kZ1ylUWIJAWlePD1vX2mp76YxM1vjuOwNTD
	 wtspAgxa+ExZiOnsd9Fsa0sfX8/6xR/Hoj5ALpVenKEfIi15oWKxgX9dcgQ9s6THYR
	 LgkxI4AVJK0U1KW9fvrM9MX2XTn78bEptvlJ1kqdWsHJCqS6kzXfEpfN0sZt4BcSty
	 MUw/2DeW4gnog==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Mon, 31 Aug 2026 21:34:09 -0700
Message-ID: <20260901043417.2165-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rgwds5u7kqamopbsgagahn7i3ofnstyn
X-Rspamd-Queue-Id: A57C440006
X-HE-Tag: 1788237270-314437
X-HE-Meta: U2FsdGVkX18x/2N0vQwPCfElj8bon4lSYckIYd560MvqB4UqY6II7HELd7rRPlPZaEcYSKg3Xakpn752Mx2UUtSZgDjW5Dlsp+Q9J/IIhRxIBsXaYzW54lFwvUSFwC/gzMhVPy5ihBd3gF/H2zdCzezjVOFITlIFRyzpiwnNIR0gcF8n39q3FSufyuA+NQGb9AiIUQm5Eohgcj1iWRbDgdKZgKIiWfPqIgDo6OdLwohLu44Ta4PFZ1tC8uZ08VF3hh+W9ebzjbE76Bfm5vvx1+oIp4VXLhog1xqNderehk5uyfPrNzV9Y1ikfgxcdTPnZCcm41cuXgZSEp57k7K9AQeAyPfyUR1JOLt/ej195u/hjzqDY8Jc5U9h6elKKfx7woJhHDax/48X9wDphhSrJq36uUrsGF5gaBsEMZwm0xApeQVj7x16esGYl0WXB07zCTeI79uZY8kxRMZN7r25gaU1g+I5U5r21feL5WC2jGGuzR9Dz9xr3iORt3vOa1VDpw39fBjm78xDkxhxSHzpzsLzX8G7SkCgiw+IY2nfJEW06t5dAASBwIla8p5iYqJbPwb1ri0XtGsDgXLumuNhxok6hGHkXErT/rN6E/CgMaDBIM1bgDpJUFMZx7NF/vtSN0yYIg5bXvgV1NmShRGviE6VyCzjAhkYmYWfP2fgyj+oDvKunecdOnTaqajvL0CSa2nzaD8LobYiXbMDgsEpekrVZZ27OVmw6g+VfBVdEXHDy7+zxCGu4+mUPecYtjGnW05Ndbdg7hBlR6HElvnQraRpTqkdlekqwssLWQlX+eM29C8Knl/9vFfepisITW6TXrpFO7mfkzmC4C8r5DiE/yd0xfOvlB4ujzYJeHkhYvalPH7D9gmiS5chgDAod2aE0LDAhW2Zu1vw2F1u1vfS3vd6migGWUib5yqutkKJD553eP3TBp54plMiMQxjFqUjScdHdF7CprSN0W38AmS
 yUkA+IUD
 bL6NmNjzt+Ba4ZJGhB/xZ2C8rXaOb6RSsSsQM/I2XzMVXeNvG2LEztxe9G6r2ZJnNSmLifS7iYyxmzhmSuJZXjlzwOuP534X6RVGIuxkhwtKelcHF4/PdXdqH6chYpuQjj9TQ55X457Jo1zHii1S1MWcDfvKPMtSsIPlh4+GkhQAN+58ErUrTNga3GsHI/HHEEGe+/6o8T04AQRAcKOyM5neRPPO3BHjP9F56tKO08c/TNdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides the files for setting DAMON probe preps.
But the underlying code is not really passing the user-set values to
DAMON core.  Pass those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1ecf194f71ddb..494387a9906c0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2176,6 +2176,23 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_preps(struct damon_probe *probe,
+		struct damon_sysfs_preps *sys_preps)
+{
+	int i;
+
+	for (i = 0; i < sys_preps->nr; i++) {
+		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
+		struct damon_prep *prep;
+
+		prep = damon_new_prep(sys_prep->action);
+		if (!prep)
+			return -ENOMEM;
+		damon_add_prep(probe, prep);
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_filters(struct damon_probe *probe,
 		struct damon_sysfs_filters *sys_filters)
 {
@@ -2211,7 +2228,15 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 		struct damon_sysfs_probe *sys_probe)
 {
 	struct damon_sysfs_filters *sys_filters;
+	struct damon_sysfs_preps *sys_preps;
+	int err;
 
+	sys_preps = sys_probe->preps;
+	if (sys_preps) {
+		err = damon_sysfs_set_preps(probe, sys_preps);
+		if (err)
+			return err;
+	}
 	sys_filters = sys_probe->filters;
 	if (!sys_filters)
 		return 0;
-- 
2.47.3

