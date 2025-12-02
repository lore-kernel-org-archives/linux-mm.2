Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA996CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 09:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF226B0005; Tue,  2 Dec 2025 04:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6726B0023; Tue,  2 Dec 2025 04:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3136B0024; Tue,  2 Dec 2025 04:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF1F6B0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:00:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 944D212DB7
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:00:24 +0000 (UTC)
X-FDA: 84173934768.05.021F002
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf17.hostedemail.com (Postfix) with ESMTP id A516640014
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:00:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yf7TmXzn;
	spf=pass (imf17.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764666022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDtCgcKoqebXyo+jxENam+HXtRH1ghw4HvSFLZRxozg=;
	b=hYvwCSDFE3uRqYdtjOygCEPPVErRwuNDOIFdOkZpmiIk8/tFg8F4H8LVSWkfu10+H7qPY+
	kfnWg+0yk8M593jk8+q/sYSAPbiA5lGTpq8bm8ucCI+QScPx709Lg7hRyG/BktuBB7DOlr
	IMrY9iAjL39EX/SaWMfkCKlF220TYtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764666022; a=rsa-sha256;
	cv=none;
	b=wLSBH36onzf8+kKPoz59aZYC0scUSDBEsyJC9QlxqwOfuGmM9wcd7VCeAx9pugaa7XdDXj
	HyLB7a4AJ2tIiIGqsUHadPzcDSRHel98oX0cW1zi53lFTw3QmL9NLcx64BoxmhzsOFERBX
	jldDTvRt8o5RPJFSbmEVzNHEOXIcpoA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yf7TmXzn;
	spf=pass (imf17.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso8063372b3a.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 01:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764666021; x=1765270821; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDtCgcKoqebXyo+jxENam+HXtRH1ghw4HvSFLZRxozg=;
        b=Yf7TmXznZMl74KqQjNWJR/UgkPd4wz5mG8Ioo13+OmdOWS2+4BhmoaZJIg1Y4vQ1MO
         Nu8jw/C4OmxgjA1ouLWwJhJ8FWvhjydCgZ4odLTROZyUbbfLApToH+OgqffholGf3Pu2
         9Aj0xC06djhJzSEf6O6IdGlYzWFXDg89mp5XCIE1szDnxmCY6Yn3GNZxwFLgNCZZcpFb
         6PlAcTw5VsRMZaY9j3S0bXcryLyT0TUDdImWFW4cEzcCEx59wtB8cA0S336ap5lICn6r
         nMkT089hjxoF5og8E1XupWcL/WimBpAedzZc14IAsx0dRi8uHdYEVBbBWL4loR347yC3
         JDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764666021; x=1765270821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDtCgcKoqebXyo+jxENam+HXtRH1ghw4HvSFLZRxozg=;
        b=MIZdj1kshp19UxrBNGpAXx/YCYBy1niVZpe7jTqtQXzHN3E224WCMTSXkh4YhOcskl
         CGRLQb1csrKpOs0BRx46rCMNYz4tajXXBd5LncEVPefCXjRXVPoTtj5rnqUdvNAufNi5
         Glin8nHek0QBtAg7Cc/oMHTkcyVisC65BVcRLJO4TZ9Z5/uQFi4l5tkDvuojwZUqaUqJ
         LcAerRosWlhuc/UUhpbxEB4C1fPrx3UN9ZDC5IlF4Yybhe39iS4FtemwqGzn4O+NUvrS
         AqiIV3AemNL3lFlPTOS0o4tJYO3TZGIkFSvnUrs/KAXC882EDz87+DqWYmBiSzjbuk1l
         WfGg==
X-Forwarded-Encrypted: i=1; AJvYcCWKiwHvxZM5IVsKV+/AO6x3ZKb2m8EvscGRE2YOZxHNFR89G6UHGHasBXUMXCFIJS6q735pWn9gTw==@kvack.org
X-Gm-Message-State: AOJu0YzAB9FZedYi+Kiyi/sa26B/a6PID6TAvqOgSDXRm7OK8mfbE1rN
	mnLycBLgFrFx7rLlkuDXdGGn/5NA4N4qDtUrVho3bBzHQsnh8RGRdd83DT0Jx6vmtXV+TPqT
X-Gm-Gg: ASbGnctruM45BtZAViQFnFoGC+At2MdDTBArqvJPxMWK4qCXf/oo8Wn100YEnxLjxt7
	ZHkPdYsC6gbmHrQSFJE92qqm1LLutyuheHInEli9FonBDjrx4sO2ws8ZIAzlOh8hegdBPYOo9Y9
	NkRkZOUWNi64iC8ZYweqhY+seMN4n6CC5a6oGAszRSkxTWeid4BRYtPa+cQs0Mu0QG9+gw+rPKL
	nTwv4ZgSYktEQmvNrGVlVKPtLIiLk4jPmo/G1AMS1mdES+PV0GWWwh6kuz4iTsinQJKdTSnhpF2
	KyxvHWFMw9HnoU4uIzuLavrxX3CWBDsB3FAe8oXdld9F60FjftC+uWQSXLK1EihjCkCpy1ZCfE4
	ILRuY6D4Fd6vVm8CDcB9O4RW+baWXlCTbkiYlBZvVtKYmbFB9UCE+ee9GTdpGn4JzblfaJWS1+Q
	XJ7YCQ
X-Google-Smtp-Source: AGHT+IGBTBGTbAUOxAz4LdYDBbQj7h1lJpYS6bSIIDqI1Q6AFazDjtAmDH/mUQRFh29VnLmHXujLxA==
X-Received: by 2002:a05:6a20:548d:b0:35d:3523:c90d with SMTP id adf61e73a8af0-3637d8d6789mr32627334637.0.1764666021403;
        Tue, 02 Dec 2025 01:00:21 -0800 (PST)
Received: from fedora ([183.241.171.104])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150b68367sm16385575b3a.12.2025.12.02.01.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 01:00:21 -0800 (PST)
Date: Tue, 2 Dec 2025 17:00:08 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: slub: add barn_get_full_sheaf() and refine empty-main sheaf
 replacement
Message-ID: <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A516640014
X-Stat-Signature: 6tgt4rxg9ammxrq7wpax8pop435zk66n
X-Rspam-User: 
X-HE-Tag: 1764666022-915254
X-HE-Meta: U2FsdGVkX19C/+xPSxoO3lC9yke623I1cgmWQCipJ44lmh2cWEzGjEQuEOmWD7XA1QC+UUjNAgZM3PtbU1zeGO6aB7cQygA5F3rxMO9tUc742IdQt4tV2+5PocJ00HiR9SBYy0cIHhH6PBkHjKK+XsR5d9fuSugTWDSkXozuhYE4Ehcf4hHWJYXmcRtVXBFVi0tOrmAxQmEuMaPB5HoRWxnqZF82SrMhViqfVApwjAAhvtrwtBElAVvlJosnESc/u+hEr5PnzJSPF6zm9e309i1OlacRH2XkFlMMkipCaLeAjv8dfa++3ZUpS0g7CN7lI2BbgbdbonVUC5Pad8co/bW+2tULSCUDFdhOg2zxHD2F39HL2zNRt9UDN8aPvlILJYyL0DmMgSbk0aeQerABUyvoKglsU/Yj8R1U13tjOsSIydPoMwNPjZMvWxBIOQjIyhwxfGoWlmPcsgH066B3rb59u7p76daHL9VJm/Ixq0hsOWq2OOLR7IiD8Gm5S58WaHEzQIAgC/ouQPwTFDllgpgknx8PYK9qneMeaePWxrJQ512gDq/cNQTa4K4nIG+hpcGIJj6cJt0XLDNEDIq1pR40ANbZd+q6jUXvPa1IYZ7+1ezV3Hbu7RFUHekYzAWbJYpnNuqvhM7bSrOLP+GJkIb4cO2WEavsDu0+wadxBMw+EIfZt9SpNTrBCjGJz6xa2lI79yZuMQvg0A5tPgS7/hA2KaIIoNzzMHl2upy3skgjpyPLfcwXrejRV33hSrb3YQhNgvyawviUDW+DL7gsXzlNqfZSNpzzC+KxD7dBm0lYFTg99290mpj+YDXGwd/JF9eo5N5lQRA1gZ+UqFWxxo9/+oMv+wDxMvkdahjI681OTVg3AGEfVqMPsa17P2IiUmYi5ra32PfCfZ1nR4LiRH5WKp305EmcmuEDkTOlCcakRFEXAsISXOYyvo2jwA3oLYuWwTuL5Mid9tW7L8b
 8itC+EbR
 EqKSCIhUIy6/bpXdYZ7Ku8bl+32UXX4jmWB+LqMPT0HWvHWAtVX8Iy6u+5n/3zK0m1cso1s8lepAKxR/qb5C8zF7+cWtrAz/3FIW446K+AoGb1u3G9Q7kYhFgJQ1nNMDcJ2IHPcNDO0gAnEjnGZtMGHIJSkcpcex2sJ2HEO2x9PhRHgb202Bnr8sWYA1BXKba7mzOJxW2Xr5Q/DXPnNpSpvt9D2FINWF1VuwPXK7GTMUFgFG/eXnRcKKpXhY3uTiQ8zGizA6RKEWzRbB/d7zwkxBjPOc0vs2dfz52Px8N+FdGCNQX0lPc/6qOkTLQt335PVaqbZingAG3157lAFtjB8NSVnm8+xpg7Jyu903uub+TajB1/vRzjn/zcy6hXhKFkUe8Gr1udnj/mLRKNfkDTgaamQd9zXmjtbRyjMZt0S4RgbC2RiyNXrTGKf8WUb+EC34/leGcAr15QfGz/uoAc/ofwXdvQ9zNWKWay0fpzwcb59gJOsEFuebKnAnoBlRwDvNiMOEuNmAwtdloyn7AmvL+XSmBqCdvUW6k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


