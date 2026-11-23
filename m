Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6445A606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C4+AgJXM
Received: by kanga.kvack.org (Postfix)
	id 8B19B6B05B6; Mon, 23 Nov 2026 07:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867C96B05BA; Mon, 23 Nov 2026 07:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7784E6B05BB; Mon, 23 Nov 2026 07:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0F86B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:00:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0140A80849
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:00:27 +0000 (UTC)
X-FDA: 85466241336.05.752AD91
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 230C712000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:00:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C4+AgJXM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435226;
	b=IHp6sSDzI2BSUruXGnceRLJEWjDnllvt4Cxd98o6eYJ394ye4mOL2f+T6gXy1grk/8cONW
	X1PZcRgpMcD1JH5RKmHtpuAmpb+udMzfEX5ngHKHqux29YyUMJmDTq6OCa0usme98XZa/u
	E0cW5pIqKk4gjuTXwx0YgBBVFCDdzEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxKnM1ul0ML8veBKEiR6EKGxVNt9YLRjn30MmZJovvU=;
	b=JQ3zxJlxhbTTp15G1y4nMyYsP01iLrnPrp7W0Nfa8WYIJKE/twNJIxafqk9aZ1Wg3FmcWx
	XdRqNGgahfrZWP5avEyOGJQ6LqLyf8PYJnaSDZLOQ16kPC++WOMpGwzhOFBTwTYsiFiDxr
	lMh4f0AoJd9/Muq9hylyuCnprfo66cY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C4+AgJXM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-380b40312e2so7749936eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435225; x=1796040025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WxKnM1ul0ML8veBKEiR6EKGxVNt9YLRjn30MmZJovvU=;
        b=C4+AgJXMT4NIdcezK0O6iRwS62Y7GXOZ2vl8lz8S0QPO+SNxv2F09Zww2DXV4YOOKp
         FqOmBB9zxltmTejmrBiLY9NafpJ+0kFbtMOlnoSeU0IM8S9t99eHbfUUIjp1I1LKh3zC
         jpBw1Ut/H7paYP64+SFqZAsqHbisAOuvvxaxdSj5/vKJ7H/3CFLE8BvSwyIyqrGXDpgp
         Uum59bgQneAywRfCkusK3CoIkyYSI1Zyy5V0GEkl+JP6YIS3KpdX3+xkRRP5wFGUVVV/
         BQ4TYKPUSSb6+OJKbiXZbBHsVkx6c0ejn6Dw57zkHajcmn9qbFXNDSuzXAjJWJTCcrkJ
         iVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435225; x=1796040025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WxKnM1ul0ML8veBKEiR6EKGxVNt9YLRjn30MmZJovvU=;
        b=Jp7HEXk5tFCZmZ00JS6ZrYehy6RhHPh2KCmVW279p+zX8tkfMaFL5RdalEJSAnWi9S
         85+fZ4otO3eQGzebcf+D6Ld02LhLua1d5U1MR9NfT107yF3fPsRh1Du3GFWHaleDNRRh
         CDPGh62Os8EjeKNzEjJOMy/3I7BIxdQKBmLJ9+pni5YDv9YOPVggiavcpB0GvRnUNWKm
         gai51Wac3Q3RwNgE2diL/u1aEDPViojr2xIelRt7wf/DhICRVx+06w08W9hcWBUbZARH
         UTeRbt7eZmZ+NuqeNdfrn5rbg924asZkihsQC5Ua6wLNiFwWslsv5ecfbfS7ruOnaFYL
         9WlQ==
X-Forwarded-Encrypted: i=1; AL+hErFW6ZdsmNP2lsLv6gATPh/SGWh+aUxjX3nJGWotAvqaI7zk/7xKCwCqvViqQZkIope0091+iZV+0w==@kvack.org
X-Gm-Message-State: APuU4Z8rYlj4C5lLNfwMO7YBavjxheQ8Ka0VTBqCprDx4CaPBe2AnWdl
	V3gHZN9JDwSxuAhRzXepa6cCLAKV/sXQeQhYwHjjlwHZdT+1/Fw3NUB7
X-Gm-Gg: AZFdTZc5xoTHgNROFSVT6Tsou6KAbN1hWaL5Ovg4P6wYdAReWQjjDz0+Mj0gmkeb2sT
	n4JGaEaMZn4bqhWIcjztUyPi85yg6gYkpGWKDqmCfmXAjwlo/YKrLoyOFSdr9wofEOprz3rb8eT
	1TdXkWAVn2pWzXGYx0Bb6wiysthpe+CqG6JNiEHhRFy1AAY0OEZfxeMdoCEBywIlonNMIm2CNqZ
	aUGgwh7YXsTY4rcZQ0XdVY3QjSWUWl/D1b/R5metgq9/f9ZVkBbbt9Z1LzFoNnaR4Ugx+Dyho5v
	HobaEQdTzxLD9SXxOwfehQyzr44MbulUCiiG+8QAXsFTWyQ8i2MzD8aYmYdqBN7rO+wjQCqXJyx
	t4H2jaes5tda5gi4U/7drNvHa3cjtFmWz7p9CW0E9mum+YvvBfRitrqsyG9F8MG1xHpgm97cvaJ
	hztOWFyPFV37FseRJz3HE9fyWU8lfpj4N28Lefd9CGksYP/WJ3wychSXId8+zeHpDDBlj33ZOPr
	Xdf+bVFnVvkd5Cq5BX9SlmSXc5BJ3n5aGrxQocVgdOxKflvS+y2zRYDdHcqN+eckUV31wZylRXM
	IK3YkjJhududb7cErkdK3Hm3JMOWQne5eG+rDKVwIjXYugwtdHDveQDOnpM7LAbMymEZ
X-Received: by 2002:a05:693c:87d2:10b0:386:b5a8:1c5b with SMTP id 5a478bee46e88-386b5a82496mr1759903eec.18.1795435224684;
        Mon, 23 Nov 2026 04:00:24 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38577214c2dsm34869289eec.17.2026.11.23.04.00.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:00:24 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: sashiko-bot@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Mon, 23 Nov 2026 20:00:02 +0800
Message-ID: <20261123120009.9120-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121211922.131352-1-sj@kernel.org>
References: <sashiko-outbox-227387@kernel.org> <20261121211922.131352-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87pnobqccstdr17nup38eowcrc5e9t87
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 230C712000E
X-HE-Tag: 1795435225-470990
X-HE-Meta: U2FsdGVkX1+Qj4DXXfTc/BYlVZ+QLjFx6yA8Qi+7zs1wk6N+kTDng3fYjbOldvLZkQxnCfDMw0iUsbanajdKyUN8dkFl//HU1cENeABDi5vHoHKNNGo68TyFqKhwKBBHT/ba6U5+W62f1Rukb83+UbUuVLdXhxGKd4E0/9Lyn/b1h9GlC12nh3CZjPiMeLEYYBACXVYokf5CHcG37Tq2ER2Ar5fT0b3fdo+47V4BDfw0z+DsDeS+q3IWYjbhT0Ckisg7FwHJrj/vrFPsDvybRTqBME6a2AzpbzhrCZA8R8LjTOMI4yq9FFvvDgoGLuCb4C6jb6XqxQwutt048HJPWx9rQR8WDRpiM19XpNZM8AE97qHCloekvUgPgLvmUfLc6LJPrqWoJ8z/A87QEdyye8SanyAzpNqz8c0wL0T7G+HTotVcDHdTw+A07Yl5MfYRklWIDk8eVZSEkywaKiIoTW+uuqyIUrjiJ5AluQXmGacJz5l5Ga0CTvyPcsxBH2qWWFmlP1MYx3/pByIaxIQvsU9ZJr1616VbsGzr9M7I9mi7YeaDmWIBYZbcxm2C5si7j13xPlXJGDszQV4iwnB+IN8qAqyyrikRHV4clLCLEfrO0l/L92Rj2+s6y+M9qRek/sE75ZAfwW0zFGeoViMsHJo/Os7rfxkGc0EepRKRlReC+1FM9RPjnbJkELntFruk40C+H2j/+i6MtQC0gkhRHc5m6b/GzWom74YzwFuqqi4l/vcNRSFepGVJ32ZSfM40KTFfVoua7+MhQf0rA0Ncw1mNOk+y37oiSIG/Hx9jUxL3t79TTQohPUc5ug6+g+R3MlJahLA1Dzm7TP29RS1tmGewBP3MDA9FjCtSYosZpVzOsexTH5FxCAd5VFbZnKZIlaNTChgkQU/NsePu2KmZq8r3ITIfoh3zvlgRlZ2rERYUxzBEu8z9VoPCXbjQWCoY1byVpyaspaIpYWt8PlZ
 BhTJQF03
 KU7vavXIqBWg7V3Ui60PVNugIG0QwvyjeDB1o8RGgtPGwxCSJNAISCcRRz2nYkeJC9P18pFF+Udht3b7CFEa32mqaVO14xXBQHs59vzCGPjfwD9+HFFrvVbHXJNvTnHrI4hz9eIBnP6Ky6lAW140LQCW32dvuJX+WruInfPPyMOAI4mtE0/0pmpY9ejhIdCjdRN+E9MZ4NCD38hsGFpBRuJZOHeOz81Aed/Vw34l80tvwhb9rEYI7Ah4rX02A/lM838+rGyhix7Vo3ZdlmKMmh171diOkaaWMBRdVKtMf9LePTSlCJS/1PLTEOMfGwYEJRB67/bHy1qYqxLzNgbIQAdGbJoOx/o3XoVLkXsylmGKRfGuJ0qoPY+JzMO0qaeboZSRcBn5D6rQBU2IDfpjI/pmvgx7p3KIvfQLn0fvaskY6zIDmbpHoRB32bQ7SB3XlldRx4oGfrNxz/JCZrDurwkEmi/XqEn5+/Z58l+0DLEYqIhhHSEOj7PRlzSrtEY9P3Ai/r60xySvuxsaO0HAp8PZZI9AHGE5eoIVoLeylrDEFozRdL3R6Z33iZlwH0Xjd8Ok3wsEoI5e2P3xfLBJdiGYgvu+Eds/3IlIRYAbtNAnS8Q1zhvfXEpBBxXlHeCWdM2GJtmqRKkn2kQW0yMXiQ87UHb5dqBfVywKAjmz7fFXWZ/115JhKqCA41tKHp4yaZybIXDGmDULbtQUq3rkH6o1zj+26M+35RojpSSBeIGMOR6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:19:20 -0800 SJ Park <sj@kernel.org> wrote:

> +               addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
> +               addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);

Hi SJ,

With addr_unit=4096 both endpoints round down to the same core address.
Could you fold in the change below so the lookup covers [start, start+1)?

I tested this in an x86-64 KVM guest on 7d1a16abe4cc with the series
applied and the report timestamp taken under the queue lock. I monitored
one core address unit. With the conversion above, a report starting at
the sampled address gave 0/0/0 hits across three snapshots, twice.
An enclosing report gave 5/5/5. With end set to start + 1, the two
left-edge runs both gave 5/5/5. Reports ending at the sampled address
or starting one unit later gave 0/0/0.

The addr_unit=1 end-to-end test also passed. All six report-queue KUnit
tests passed on UML, including the timestamp interleaving case.

For the series with both changes applied on this base:

Tested-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 00865cbf01fd1..e276b91c54f22 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -160,7 +160,7 @@
 		break;
 	case DAMON_FILTER_TYPE_REPORT_MADE:
 		addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
-		addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);
+		addr_range.end = addr_range.start + 1;
 		matched = damon_report_exist(filter->report_type, &addr_range,
 				jiffies -
 				usecs_to_jiffies(ctx->attrs.sample_interval));

