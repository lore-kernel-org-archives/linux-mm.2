Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06035CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEE76B009E; Mon, 28 Sep 2026 13:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0796B009F; Mon, 28 Sep 2026 13:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB046B00A0; Mon, 28 Sep 2026 13:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEA576B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:19:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDA4EA60B2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:48 +0000 (UTC)
X-FDA: 85263833256.12.EFF656C
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2CC11C0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=CDGOvWh7;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="F +kilLu";
	spf=pass (imf21.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdE71mM25VCXqu1oQr1q/lSe+WnVe7LtQ1kxizjLL0g=;
	b=2xpnq/GIvHn0Cwj8aD3rkVWIZq6YYC8PgPiPFpiU5hK5yDD9MR+xXSY8GmQfXcadKDlkVd
	uDxcP0U6uIgRksSPM9S3IIgShUR9uSboEtRRUGmxHUS7PLQ2MSEgpIIR0jKeQexfR0/ice
	F+JJs7OMGwNmfixji9jsutgG4ddW5sc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615986;
	b=Isl0bIKIYvZI+/Oc3HPmoqRu42jzHQjzLLWP/iKjXcLxTgK2y441Qkb7qPxsSLnQnBCKrS
	DWpM4xqZaKyhd3IESqdofbf/pccZoClVS/l2yirwaP3teNX/FeDaCz6VugRFpS3u9c5luM
	4DwgTxOR0d9dIpGvFVH2/9Rmsaoqi00=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=CDGOvWh7;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="F +kilLu";
	spf=pass (imf21.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 5B41C13804C2;
	Mon, 28 Sep 2026 13:19:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 28 Sep 2026 13:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790615986;
	 x=1790623186; bh=ZdE71mM25VCXqu1oQr1q/lSe+WnVe7LtQ1kxizjLL0g=; b=
	CDGOvWh7GLzuqGPgICFmEVYOunq3Lwqz3/uGv8TsUOBSNdmdEAQS9UetGJrdYXGf
	r4x+U54zwuXwcsyxdqC7mwXEF3HsPw76HLvHI3eguRZ+Uh3i1zBTetTGyH90Fgmn
	nly1PIr+pFXsSo9JJ0Idq3+S/+xFlItWkxb90glvftMh29KjSOfd/N7nlv87pZrl
	ZlDgYsIKi16pbPRz6jZtd6jWqYXFrvijaonkOhRnq2gqlOvJJpmfnIDPwMOlQxXC
	4JAmYANZiRJUCUSyZ/Q6ZFo6agHdKRcVWxEeDSu6stZ6qcGAnk/ag7rvGNJTw69d
	aAWJJoY2Ner/x5EE056z7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790615986; x=
	1790623186; bh=ZdE71mM25VCXqu1oQr1q/lSe+WnVe7LtQ1kxizjLL0g=; b=F
	+kilLu89q7lo0Knbawu298hW/M72taC5Uu1xRlQiiz1LYqRj5dZ3JYbTEGnHCK9t
	TiYFL18kFvNuFqXrIy7uS53DzNM/v8WN91lw778mQdW9Dw3bHpRFl5jNlvkD7ddI
	qSKmI8+wYBuB7WqDWB2IsHxCILuoYwRrF0qRuP8CvAjvK9szvwg+HY3wXF+ur8EV
	yf2Ygk5FsRE+PHuolp5qLybLsdgAj6CL3CPXINlMbXJBaTCXUh9pZVsOqUQEN6Te
	c10tbzhgGrRwIpNEMZtMXefcAsKeDVMaAkvf67hkrNuSoED7brzYOsQq8cO8WZGd
	cdmA4tlccsix5Yc29EiRg==
X-ME-Sender: <xms:saG6al4RA8P-iRyBpg7fqMamAwDe5xCvw7K2Y6rueUoSwKvW_PLOfg>
    <xme:saG6amU3coUJ1KyKus8GUBhKYpLmIOmTChpQqfR7L_GLamepQ7oUKCVRZfg7uvmLn
    reThErzo0dYYjiffe3plYLYqW2lESrEWEG1FE32nJFBT5oph6lr5Q>
X-ME-Received: <xmr:saG6aoswVbQKqQjAunKpAUxBtxWkMXXXGXAvdEn8NMsPKLKrX_nX8liHCU4drTVH>
X-ME-Proxy-Cause: dmFkZTE/22e7clbyNdHwn0HCBx+H3lsiFyo6QkPV6dpSn20/QyCOxtHNd7QTmx6b7eJ6RH
    b7MD0YK3xmhVFW7pHJl/jJiaLCtzwYaWJ6VBcJNMtYB/lM8rXCQqoyXJAKc1Q+3NTJHLRu
    Q+616RIwRjK3mn/tprgeZTxr9VaE0UGr12rr0RgYUziHPYN8WsIu22gnQm98Dq7NFgLEYb
    bOn/3mv6ye0r5zsmXTZhHlWNyOVRZl7FwJjAmuaSy3Z2MGyz8Xby78ZPjGLjvAF+o1XCsp
    YM5+7QijkJtemWRQaETyS2I23TsNHUOR4KF7C0sS19NgtEnCYopA0Qb1idGIqDD/y3bAh+
    OHLwLtIJSLc/HOMY8QogeCoydM5JvLEFLPDaOGSGQBEzsBv3+nx4wyYe5ZtEBmSCjAMlk0
    jcFbl5cikzUyIIexea7pVa39IIorHJLOLvBi4dEzqEfi7hU48MzxRUPIO8Ode++2Wyw5gt
    qOu+//xqHUlsWRJSas7npOvuAMuETFBHcwv6GfDpGNJq3i1/DPns37HnxKpHVU7GRs5Aam
    L7eFdiKB4qfGL5vgwdmChG28DUFegZzTH9Xve3YvGv+SEKdQCa0xDbSiD0Wp89DS8aAKHX
    nKuM6qjT0b9SsDP2OzvaTGw+Jioc14hPxrpXcfV2fd1aiyVYVy+VaP05uWDA
X-ME-Proxy: <xmx:saG6anI8VIH0tVnGUymLbaJg5eSCor4mEPI47WQn_GkdHwZB3tBqHg>
    <xmx:saG6ajPOzsPCBfcvMeyGah-EkpaRv0DBoblmEk7A_m1D9yjVdL-hPg>
    <xmx:saG6ak1TssK1p75zcGnHYhyAzENKocbVvB12dGtL3-LrVy6RzdAUBQ>
    <xmx:saG6ar8351bSodNRdpV4Jvf4LwutDeR3A8HSyDIgYN91Z-BYtvrEvw>
    <xmx:sqG6amliZyllfm7YAY0wi1Fyilk0-7B3JdLDHjRtTRXG_3etj1B7-2dX>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:19:31 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:53 +0200
Subject: [PATCH v3 05/12] dm crypt: Allocate key material from the secret
 pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-5-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: cqweqttojbeuu1pk16wscyo94t5hn7mb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2CC11C0009
X-HE-Tag: 1790615986-856451
X-HE-Meta: U2FsdGVkX1/Bt9ArdwtlA37c9DLO3gXqwHl43waVPGQe/upeJQ5GAUk+YmmrQ4T+WTPMMg4LYyu9hLCvWFf9lvgCfuw6kt3jKW8RYyy82WHWFIRpg39ECnLfVWIB+0v0mxjriGtN5q+F2CHvtyl2eZAT9Vm8R0DaiOSgT4AY59nCEGMG2BRm8LTAcQrtGwhWWA/qSEPat2tmvoTvIFrNh32VWnMPSdJv4TUw8X9chpCNYQGcp8o+kp+zmkuxPu07brC9Swm0hEJdn+Tb9Cyv4tLvA5m1Va2W8agnkqq5P+JccQorH12ySev+WlZqC77hkEYBOG6emMNibtAWngaLExwWM02ant7Rt3dy2OEfZAWwqjBTK7FL5Yvuk7zbCLmkCJDk65vkVPZI+IVF9J9l5CWwNjuFD1xgTXwjR11/FMgr2/CGO+dtQgG7X6R37IQOGZx1meO5t4xbo1o1J49/QMCtDhgG1DcKS7RZZhGUJNn/sUidA8NzZ4wbZeL8FqyLi66pbwWffNjJM8VI67eW59GBElV2SzD4XzOtRIkbN9TksLRvSrTCvUGKahEWWurMFRZPgtZ4/2eevinRdtzpu2dlaHYZE5EMMpmID8HLj/aw7eAmjfhmZJ/RmbQ1NrLcwcPntUG1+A1Woql6kJwXRJMi0LaMmurUZptDKyojSAg7CDBbF1QZOkDuEgzYHq8+CfgFgS5jmeUsQ9yXvpiGLcWPP2ZW3ZmjnDTuMFcBd3mvAYsV1KUxVv2UAbbwwTkRYdlXDyem2h5dH1zBGUrf21GhAF/b+RXFFBD+NN4Zg1fP1Yaiw5IwD1xix5U+VF/VB2N/sFEalA6AxNh0jAieaZenvZtc8y4hVqXXmWA7+GVexZAFUSqegqZzHlBjxf7ifgzMyGHJw3m6+GVilpSKrnoUZblktQTwJdwrUWNqJmOS3LDeEiig9OSrRR5EXcQazhd1SMBhIOi2iICFle8
 24iRiNGJ
 uxdv/jkGh0ZfSKZlPd1Gdxe837Zkd+WLb9W9a+n/9HHHxKufRV8bvKk03zlwlUtyR7gC/Jr0AcZeu6OwQIWVKpRRkvD8bI2ucAh8KdpW0hKzNaQiOTX8J4xemkAkNndMNFrqIWWFXGzSY479fORtzII+CJ1/HmT+FFtSmVCHSEm1lUFE9s5L4K8axkQ7G9v2kVTI1tTw5mS4nJQbDe7hcSfC5B7Um0SMzzYu6ZveUwwpWy7AgwZeD+FjdMvGpTBRSfzKO2nZtnnBKBP6rVA1OQzLyGIn9A1idB6RqhnfYgBqOoLZwEPm/vLix1RqoTXKiAw0X19nuIXuwxlz5iNlGQ3dX2SXr71z24IO0VLtNGn2DUW1WRfg6WmlQmV9jcc7askixb9il/txMyjy1UTgfJq+huuGEcQXd8c3k5WZW2f+kQOFFa0XeeVrGH76Dwfult7GRfvSSwZ/WG5OpSn7cfuxk65gpqxhC6oZYiWUnsqYRXijjfA0krFRrFb2XjB2/SBupGA9feLjt7mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dm-crypt keeps the volume key, the IV mode seeds and, when a keyring key
is used, the key description in memory for as long as the target exists.
If the system crashes, they are left in memory and will end up in a
crash dump.

Allocate every buffer that holds key material from the new secret pool,
whose backing pages are marked by crash_memaction for the kdump kernel
to wipe. The volume key is a flexible array at the end of struct
crypt_config, so the whole struct moves into the pool with it.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 drivers/md/dm-crypt.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8e838530faab..c386b4824629 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -29,6 +29,7 @@
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <linux/rbtree.h>
+#include <linux/secret_pool.h>
 #include <linux/ctype.h>
 #include <asm/page.h>
 #include <linux/unaligned.h>
@@ -486,7 +487,7 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return 0;
 	}
 
-	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
+	lmk->seed = secret_pool_zalloc(LMK_SEED_SIZE, GFP_KERNEL);
 	if (!lmk->seed) {
 		ti->error = "Error kmallocing seed storage in LMK";
 		return -ENOMEM;
@@ -603,8 +604,8 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
-	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
+	tcw->iv_seed = secret_pool_zalloc(cc->iv_size, GFP_KERNEL);
+	tcw->whitening = secret_pool_zalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
 	if (!tcw->iv_seed || !tcw->whitening) {
 		crypt_iv_tcw_dtr(cc);
 		ti->error = "Error allocating seed storage in TCW";
@@ -771,7 +772,7 @@ static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int r;
 
-	elephant->key = kmalloc_obj(*elephant->key);
+	elephant->key = secret_pool_alloc_obj(*elephant->key);
 	if (!elephant->key)
 		return -ENOMEM;
 
@@ -2484,6 +2485,7 @@ static int set_key_trusted(struct crypt_config *cc, struct key *key)
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
 	char *new_key_string, *key_desc;
+	size_t key_string_size;
 	int ret;
 	struct key_type *type;
 	struct key *key;
@@ -2521,9 +2523,11 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 		return -EINVAL;
 	}
 
-	new_key_string = kstrdup(key_string, GFP_KERNEL);
+	key_string_size = strlen(key_string) + 1;
+	new_key_string = secret_pool_alloc(key_string_size, GFP_KERNEL);
 	if (!new_key_string)
 		return -ENOMEM;
+	memcpy(new_key_string, key_string, key_string_size);
 
 	key = request_key(type, key_desc + 1, NULL);
 	if (IS_ERR(key)) {
@@ -2851,7 +2855,8 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 		cc->key_mac_size = crypto_ahash_digestsize(mac);
 	crypto_free_ahash(mac);
 
-	cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
+	cc->authenc_key = secret_pool_alloc(crypt_authenckey_size(cc),
+					    GFP_KERNEL);
 	if (!cc->authenc_key)
 		return -ENOMEM;
 
@@ -3201,7 +3206,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	cc = kzalloc_flex(*cc, key, key_size);
+	cc = secret_pool_zalloc_flex(*cc, key, key_size);
 	if (!cc) {
 		ti->error = "Cannot allocate encryption context";
 		return -ENOMEM;

-- 
2.55.0


