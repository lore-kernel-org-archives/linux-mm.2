Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1656C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0921A6B009B; Wed,  9 Sep 2026 06:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A2F6B009D; Wed,  9 Sep 2026 06:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4316B009E; Wed,  9 Sep 2026 06:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C77C06B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:25:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 410C5120170
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:25:14 +0000 (UTC)
X-FDA: 85193841348.29.A20471D
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7255FA0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:25:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PJNOmqlG;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
	b=liXpfmB3KBKA1XfoZuWh5C58G5SKEVeREh88MfHnUkPRwZU0YqsyWxhCBiqq7JBv265FX1
	4Rg90TNsQ8oyKCeaG0rhcALz84CQvqgQltVjoLnuO4JEpMVpLCyJYenEMbreN59rdKL/+I
	izgNwlnOQ21Pm85H89INBymklRt/0E4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PJNOmqlG;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949512;
	b=PfBHfGnM9aCti8FZO/qf+nyXFvGSc6eaBaiC5eGTIatJv47CSX9hJhm0R+PhgcAuGyfTLX
	kzzi2UbDzTDB4c9Dk4lC91d7vZUEtGF+gp9Mz3TX2Q4usyf9UdSCBJiOxJB17uHrOMXTam
	h9l41j/OzpciqyGx9dNIO1GV7vZWV+A=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8664769db58so36389207b3.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949511; x=1789554311; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
        b=PJNOmqlGvuxRqqmbmCmqvHYaoAvKY2K2cIgTB/iRF0KxsON+0Y/YxZlDbqbSw2IE9H
         oTsEhDGLiXD4CgBH4/yyX0cIOuqw/QGpdsH/BlyHzUQ0fmhi4skxHdYHgm4sCPPltjdD
         qfNsSknzMBNYwM27Q/oAfML8fa/KzYU59C9NVMRRcHuB8stLmaHWXenh/wu+VgS+gjIK
         xy9s9WxVLPrDnKKg7XpglTCnhvQ7mGI87spzyMC9zndxYFHKih09JBExKLtzqLm6cJYs
         QNlVuBxqCEacTsQ8OIoUaeOGveQXX61sn8XeaZ7Ce+j9xmp2UBL418SSeFEFvMhNh+88
         FlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949511; x=1789554311;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tbn1aAX73v4jfLOAScY/xk2YxlfOe4UtWahA1Ug2y2k=;
        b=tDSrJY6gINiPFTWJ4EGjxs3Nn/Jd/d1eb9OweStTk3ccd37R9bfUJVorUYFVeCftPG
         V54H6tw+0mNee4kOdGHdqDNHALbjDjYQVJu53HfrNGPnytng9j/CqktDHNXcWjVO2Dck
         e4k/prQwoV1tImsinIndHbLetF/RuMhW02A0QeYgUF8JTX2vHLYdL2/cKe5oUKLIvqLd
         tMEnT2Czsedz5FpWHRwqWH9u0AiBt2PYsd+hP7gKxRmNS1ENNQsNShUEdV2XDLoy/2Ra
         FDLqWcHfTX4dJ7US76r3TthbdFKfU7w1vmH7l+VdVfDWhN+DYCJ0Q06zmEg2FfyNWxIF
         ueCg==
X-Forwarded-Encrypted: i=1; AKwUvBwco9v5U2ABtH9Lh/vH0V2MJ5biknAP5rLQLsB6LIGDgQtDGmA05a8XwtrVmTPhgIBDMEFpKPaJOQ==@kvack.org
X-Gm-Message-State: AFuF++nVL+KozOr2vmts5pDqAAhohKmIyyA5AiEL0IzW1wGu8u3aJush
	reRGJF73N184La8YBr9CsDvKNBxORNcU++r6x41QAoBKwT8IzgN3yzAFpZ3jlUsQZw==
X-Gm-Gg: AYBFou0g+5KKOCAxCJt/qCUaIyonxkGZVBZr4riqGC40G0COpKUUYy9hcbmg4Iee8Kx
	IqhYwAoYdqY79SHgAbPjc+TpKlOLQkAtlbfJqyPdfrQadpy3MLIJCHTYGMG4h5o/ZV766TxL9ao
	Dm6zUzkMBAQ9MOcbEOsDX/anteTfk60S64vY2XdygoAycaXzD9lQ+FmcwbOsNMPiGKhDdQ6w92/
	WAjkQRgY77SMNmhhbnQQfC8rLhoMd4ixo+ff1Agbj4dfkb4ti/D1zUo3AllC1IyFv+jf27KG28k
	fVXyW55I3o3Okr/UfxWPXZ8gFmkJj9EM7e6O4/fiMTPtLVPjh9VMR26LFYc2wdWlQOkFBUIFwwh
	m6yaBfylaEkqqT0/DzPuaPLFn+TFW5XsjZfiI0wWeaJzm2YQ546wAQQLwpgaRFq9EJfZqGffZ9N
	7eePERBg3gR6/I5+tDkoDvAwIzvZOVSqsQj43VximNHrQo8nuP2EPSg9yayV3VrwdHg+00izplu
	rQ2EbrTrhuEfmnDBUacjEalYkkZg/2KLPorKyovDCjyUAHLhh0hNheqbW68kJp1bDql7w==
X-Received: by 2002:a05:690c:62c4:b0:870:96e4:6716 with SMTP id 00721157ae682-87127b36981mr130530337b3.28.1788949510969;
        Wed, 09 Sep 2026 03:25:10 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87149315162sm107287417b3.12.2026.09.09.03.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:25:09 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:25:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 21/26] block/fbatch: no lru_add_drain_all() in
 invalidate_bdev()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <0debd9f6-0ff8-31b0-4830-3a81ba56754a@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7255FA0009
X-Stat-Signature: g8hrc6kc38jxq76zy9jhsxyxeufhz6jt
X-Rspam-User: 
X-HE-Tag: 1788949512-896122
X-HE-Meta: U2FsdGVkX1+CF+ZJlVhVL6G+dT2Vog+otmxFypa2jss5lNcGmjZwiTXFNUD8Zw5bGmJcXfqwvdmIYfBy5dKm0CpAGEPcnfB0dzUv2h6isEK5n8ZqqPZEHs5b7x1yJXu2kITIlBh4+6Pp/C225BkhCfgfOPf1HsRNAiiauNpKUuol5ALDX8epl7AEisAgpTaIy65hexyQ8HxOBkC0zvOGKRZgdi65q80mQ1A4Q1KPHPVzZfEFusBqBLsYDXD+N6OE6EFy57xrT3p+v9l7McbxnwM3b5lv0Ezgq1UzPmS7c1gvUzIfJyn/eouGkWwy6yInzl8WTK8ddN+Yrbqd2YRT6vuS4t9YtmDMGOHZSb1xCwuDmp6ry73oQATb/Pue10SWY6eDya/sp7aaV8nKAWDROB83lAPrG9bYJwMoA/oZJKFoj4l2DH0hTmQurbzYI4zq7bNzbOn8vSR4pfJ8ex5pCht7wFWHsnSZiV0dXtS5J3oVhERY3CKQJtXQd1JWAMq7ZLhcYw7Kqk3iZHEUy+xcvWb9a6hn2Dr+nPpOtUVACcX4G5cI+hDfXIF774XxzNROh74GI2DViBcO4iXN9mkQb+tTtAV0yilibVVY/QGu5k54zqMeCgrv2W9OqMogF2OACq5Adeuowr8rD2OzZqHTfJXnxfWHmDz3zT+QHxUZJWf0yYoX1Sn71voaq/gzYmCh1o+yIlOv4xq5rXex7Z5x+5eiNcc2/MjpRafLQTDzqv8COZ3ge1nuNstNCnZ1dt1jfNw3Nk2oj8yBfQ1VR36NxZFo4Pb5UZVSrThICnqEV8NFIc1nsUmSPcatxXqotg1Y4H/gPrGlEOr0ZQfppbqj/GzK9qlzSpTpQH1EhkguygPMNFMJhnhP38VuUop0rLq2+KRSUJquqqAvas+2CU1CsZDq1BlkEK1iFGygcXws/YLmL6IK2/7jBvIGgrg3EXu+uqyr+rLv171oy3U6NUR
 vSBWEINp
 BQ3ExnC+nLHpkntH9mmqDEZTgTYyMorQRiVkh56fWXmcfZYx2SkecFuPMWLic5p3Lb3P3a0YViEWSgCaR7XvkMKpmU1ZDHFkHG/OWshMVyr5IbDOOARRZZxt011NsXRACDNxrOvMBWonJfdJE96ZssE3mkRfCTVdPMBzdlsQMjHMsc7zxD85yTAL4FW6CXkaAZWTiZgzZTdGDZzPdjqIFH/hxVS7z5H3pwvR6p4aCajsJK5ceniu8kXhwmcvYg3w8myJqlQNViv9OvDL4B8gkofbqEJoyPD7zljHrBlKT0YZSVrqeUQurKPYN1A3lX62PW32W7gh/Vh3rl3zFMwO3twbxF+wGyGflpsD83Oc6aNB+f9rUGG5AgxpkOrqrFtzTJYCh12jan/5xTetpCYhcWAfNZ3gUxncwAZuU/szxx5Arhb8/IeGxLlJOaxApNm1BixEb1G9XyXU5XTovcXUyXiOTL8iJqrC3cO9u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

invalidate_bdev() has no good reason to lru_add_drain_all(), now that the
per-cpu fbatch references are gone; but keep doing invalidate_bh_lrus().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 block/bdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..853545b29b7f 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -97,7 +97,6 @@ void invalidate_bdev(struct block_device *bdev)
 
 	if (mapping->nrpages) {
 		invalidate_bh_lrus();
-		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
 	}
 }
-- 
2.51.0


