Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CABC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890836B00A3; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8437A6B00A5; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D356B00A6; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8556B00A3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C11964023C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
X-FDA: 85036864836.23.7CD1472
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4008B40003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcpp4QfN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASGSrOhiTqeMR2TBi/rXvzMlAFD79/gguOPL/F3Ka3c=;
	b=4qI2xERe1mu372zTEGujUTEMeOuE+M/pKpwt8QMYIlBID2iNC5UrGM3kE5YbJj5ccl6xAt
	AiAjbnXpl1xcYVxcHlcffF6wDelXzjLkKzbIyFmsGemvVW34lk3N1m7+dUcfGp3rmaPPdB
	wlP4D+bqh43spXxF/L6puR1sIHyfa1Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcpp4QfN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211977;
	b=J+96zHJQHDkT44f7C/UzG5sFWkbwqiqMj9P0jVMQXUOMqlfZf97Jb/5mWm9eTzTpqzVStn
	VZ4+MQXSTIbiJoFVb/pCarpCA321vKEYSL3rVuGGpTEqixhj/TtaMOMa7kfq4B29ZRz0Em
	TRRiBELsgOUiFxKwaSz3CErmayKIxRw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0D7460A6D;
	Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7D41F00ACA;
	Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211976;
	bh=ASGSrOhiTqeMR2TBi/rXvzMlAFD79/gguOPL/F3Ka3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcpp4QfNtxihZYAleE21Z3Ri3KIkrvTcvgY8y9aHzD0MSPySn4epb62Nx0mHkydav
	 Xslw8Z4GhYwxQyHlAElP9bYx6/bR9Q8oc5scIwqXo+Yk7rstTqrUDtykRnCGnyld+T
	 Elwa7AKysvWyhX4kUVdyVMnfNFnW0mk7URKm6vGCzMexSWdv1XD0JAzKmke+bdvfQU
	 rxfNx/+BxRV7l2kBt/guaO/bG6uhESzsNEPsteMM25EFiqIa8qLBDzGVVQ1kKZREwI
	 UWwZmyNadizHkFKUT3d0t8BT3C9aXxuRuKSCw2MbY0dyiVOeguEd26fuD60MvFGx5r
	 UnmfTfyBly98Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Mon, 27 Jul 2026 21:12:34 -0700
Message-ID: <20260728041242.187380-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4008B40003
X-Rspam-User: 
X-Stat-Signature: b4irmzbzcwghufxxc59mzqsh8n35dzmb
X-HE-Tag: 1785211977-980358
X-HE-Meta: U2FsdGVkX1+K9oFRxxd36QdC/Cr7bkZA1UwhmZ3md6cEqQXyDTRRiXdss0Z0f0bRkjUtDr97TtyuV3hBrvyDhuxduNb+ybycL2xQAP74qPRQVdZeUOQeId3hvJ4dM++TSmCvFGruNH3jikGDCgmFjXttBiutZqkmk4QKClXKXbtMc9Y9V2WnQlXXNSiz7Biov2o8cIQ7KI56OEJEl2wmTEHFBMl8SJy4WGjSsC7eeidDKYLvFNpujpMYgyoOx7d7HYdd0xGZEJB6o0jm0ZsLBWypce+mKze3ikYYjz48xWAybz+9npUdy4vKnqZMza8grw7MOrjAygteMqz6KjwlLKy9FLfebCHBpU76FfVE69FlTyxfgnHy2jdvjVyDaIIWLvNuEbHZdZgXrxLr05JiqCvs7Iks8/hXbr4DZ2RNpfg5FbquNztQzNaZi9TCoTnI9M2evjMtV16h7kw+SvVESSq0pcn6NXIJvgKSSBkp5MqncUrEYd9XZL7RH7JcOZuWQboXAOhtXIOtlpwM6hZaJgasgm/prhX8JWiRd7UCWISFnaxmqWoEdvUT51jQUWAWgszyc1kT6a4cXY/9KAjrYppW3iHugm17+bnLUEPOXcGnHRHF+MII6XRD7Zb0w70Jb7RawBtZAupoSQwybAvE+oPlsqNvALFwLcHAZpIbAvIrwsKdEwpt15ZmSRJyZmBPP+DDhYEbFWxacNcNCylDhILqZbQzXFzOZRJOCjy0xLthh9pvbCCXltCwDR1I+lEoDkWOA5DeHhdtV6JjVXYhYKyqkAoGSpYM1ClCWs6LvH0lDketW6F4zEBGEAxG66FkqvHMStyNf93GrSVkh2Y5zfGeEhPK8p+xRxprjhHrjdmtwpIBxRY/Ad1zvh6Sgu2aL/6gK76lj74tL7UWr7gQ2jjUwvKnUG612xPpUALgDCUUt46I5kBkoGPQ7f0mi5fqQm2CIu3YN+p5rpVUWId
 p5IN6XtF
 GbTubvIkXNGu73sQg1uZJ663KwGY0Z1nxx/8CRqDAbFhMTQ3PoeHf8Uzz4Lf26jj3Jo6LKcaCuX0/Tbobiiu7EupdohS+0fJ63qb5aVuuzy/H6cq3vMrEQeFjJbv9tYjk79JDAeNtZC6QYN60THCdLZDVrSIPVF+h51W1YOMsL/CzRLhIjUcl2IcsdUZpwx0lLRJfn9OX6Uhvw4sZMYT3XHkkxhf8putfAZA8xvrSMJWCXR8=
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
index c0130843223d7..d02f5f8ceae5b 100644
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

