Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D965CCD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8AA6B00D8; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C796B6B00D7; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69076B00DA; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 897D76B00D7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B1A01C01FE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:03 +0000 (UTC)
X-FDA: 84886108566.14.CBC6A9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A3E502000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPvn8Uii;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zqOErsRkzq/3LxD3DfZ11Lqil1gbzd/2T/9oVVoavc=;
	b=tqJiATuTdE0+NXYtJSgkWavUnLAgN8s2BLA1iYNsG0qQuKm84E6IpDZqovrL3B32JImLhd
	u+6Vx6V/vcJmvvdhd7LlQc3KvbYlLPQtQKnDdb4JwL+X1wsZaISkXBphrZZHxyJ2a+iGDc
	rFKcHtgn+MtiJq073cJ8giQPgDnbzwI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPvn8Uii;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622541;
	b=HpKCv8Dofiw2RdTApq6T2PArom/9+aKkeMuUcVotH22dJdlgQStXUNXS3jA+9QmaauahHh
	8x2CowINTyBt/aQN2WN6IJncV79jhUQsY8IpaCNeuOhtMkWa9Uy1y+nr4Fm01+O7Hqmhvf
	FXFp+gm785NwMofeUCRriTu+H+gNtnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0406840BDB;
	Tue, 16 Jun 2026 15:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7041F000E9;
	Tue, 16 Jun 2026 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622539;
	bh=3zqOErsRkzq/3LxD3DfZ11Lqil1gbzd/2T/9oVVoavc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPvn8UiizKIj/OWCEgR8H1mhbgGp+l68N3YuiCAev7YJWay2aU9tVTKg/MhjQhmbQ
	 d/Nn20RcW4dLnZpEpVQJmUHkEIl4ftmbts2+U3X9/p7ZCZBAIr8KqLsYGgglOfkgPF
	 B5MCNggh70wcPXt67jIACfKHHm2xJXZmoR5svit8Iwq6ccJGMK8lgXqEoPci2CYDzD
	 iLDKGMBZR5Joej2Q0Cnn4lmsl3Mjy7SHjD3GFOpmxXFGxBemJxyjpw/7rIpega2F3R
	 tRZ7nNO4ZsBKNuk8cplBmpS5adJapXVdP8hq4VqZ3UoZutSEfIzcC353YfKv52XJ0u
	 WtHIWFu0LN20Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/9] mm/damon/sysfs: kobject_del() region dirs
Date: Tue, 16 Jun 2026 08:08:36 -0700
Message-ID: <20260616150844.88305-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A3E502000C
X-Stat-Signature: dyq9knrfu1jkaq3ge1j3kcaojxrokzhg
X-Rspam-User: 
X-HE-Tag: 1781622541-508760
X-HE-Meta: U2FsdGVkX1/bzi2Up++L4AFyyJF1P2dG4BKXWlkY/Bv8470CMjl4uB545H1hYJxDSTxgW+9YboGNzWHjWd+ZwQM1r63zYPzlutD6R3kyf3j8iBKdEbaDHwJ+U2cP6Fi0jmpLwRNlGKXtnfOY6zlhZRoSprReLtw1BVEpv956Q/RX1/IQNwoKG1Iie6o8q8s2CEdhU9EjsQXjlNW/Po9UDPBQWjV3piveUMQiAOfr/8FZCA8ovs+UQxtNljEZdBdb3EEXfCDMIXB3Ivvs5tTxYxphGrrvUdgjSVP4qY5UnLWYC/XBeV4eYae1M5hP4Ivkt027FkgnPsc/niAId+cEvuV/SiF0fD6Y3/2St8Mtk6r3kSvxwwJp8lsvJhAdiCDhtZyNcmEEhpkLFpCAZqGV8kgtcPJJ2OX5OgYtnM8ZoZ0wx8kEKkgQ77a15+wlvz0tcpdQ6BzI1HkXoPz7EkMR8J9NO5VAyjsj0MrdtDg/MNsZ0F7Z5MJ+VVDePoQTCxe0H6lamhNUyNIgze7sn3kGdOZ02XJUznvBVlxVolUrXLwv6j3ItBeh4bbI9IaEA79HMZHOx5QBCfqAqLZkoLF/Pyb0yYMS0J5L5K+f0OxhffIfLQbgaeAjbw3k+4oC4isKsf++SPCX3JcF3A8JDFn9JAWVdg9phaPGNW4N3dZmX2egngzurR47Bb5Z4dlz61Db30K3JeZd8eyXrc1xtloDYA4I/iGE5n+ODbAyfw6QDJ0N3ZsH7fbaDEh0IHYWrwIVKoomEnEZfe0e1EPKdWQFCXAHmwd74kE81/aNQWWAUQhUI0sNjjUoDCGPKOnG8peZ97m6Pl/7p8iiW12MMna/EtK1/vdCgQAOVz4ZhEKtvdfaWaNiLwsnrvND92MVh25TPiyLnTAKyF3kjpX6z2GNvoMuXVxbY6XRVGXzKdd6lO/654WoY0aYkiJOaxdO4mRGvmCR7u8FSKt3Ny+g+up
 RfyH0ft+
 htGu57EbHOF3CF6uSR9rUlWOK+F/NaKO2E4R3BS3EI9iXe8K4WWZzyLFHCUWXFTSn4axGlnPLWkO3b4j/Ysb9pu4gsr6CDXqXdTFP7y0Ct6onbbWcqPpOf/h8SH23ebpMaWr/+s1YCTloLAOQWgp8KbxXR3KEwhHt+8KKiUilN+ePILmDqv39lYntayV6R94WGNqHrVIlQe3288is1UNJxA68LD9TXs1bli1yNX7jETJIu6EJNQ/SLVo3B3thBF1mjCRX7Q1Sng2DX/ruM2otNk0juQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for region directories by adding kobject_del() calls.

Fixes: 2031b14ea757 ("mm/damon/sysfs: support the physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d93f7919c3ca1..f72e1e37df9d8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -107,8 +107,10 @@ static void damon_sysfs_regions_rm_dirs(struct damon_sysfs_regions *regions)
 	struct damon_sysfs_region **regions_arr = regions->regions_arr;
 	int i;
 
-	for (i = 0; i < regions->nr; i++)
+	for (i = 0; i < regions->nr; i++) {
+		kobject_del(&regions_arr[i]->kobj);
 		kobject_put(&regions_arr[i]->kobj);
+	}
 	regions->nr = 0;
 	kfree(regions_arr);
 	regions->regions_arr = NULL;
-- 
2.47.3

