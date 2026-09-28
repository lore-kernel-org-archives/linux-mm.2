Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357FBCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF496B00A0; Mon, 28 Sep 2026 13:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370D76B00A1; Mon, 28 Sep 2026 13:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238006B00A2; Mon, 28 Sep 2026 13:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034116B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:20:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB1C21602A8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:20:07 +0000 (UTC)
X-FDA: 85263834054.28.AB9FB2B
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id A144720008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:20:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=pG9rJP3C;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o tTvXp/";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxkdii9Ix7VQo4OS5s53AyOtwZsAqIdchYLS+D7XBiA=;
	b=NEwzsJYDlcQG3jUCApGe/DdE4VtmvQJmWzt6TX9V2cYlCCpiJW3Q/3jj/N+dpH/c0gOUOB
	zUztiDFCg6JUHwG/hbn70KzjzYBKrqnCGz+PxsmcIY843rsvTT18lh0PVP/YqosvMlxZ4U
	1W/BwrCtSEvAuDAJcGwdeM/TbI9fCfQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=pG9rJP3C;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o tTvXp/";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616005;
	b=c4RMABhFrPDwOGcyfebYvcfkp7T/PNVr+FHVF7gsqh8tGhKjvAOc0se0j6sEXk1T3oLZD+
	dSsgF6K9kfkNleQpaJLS21WjnE8tfLvl9UuklgLpthoq5hsmPWL2vey4deUPT6eOeekL0w
	8YqKimGlXNUfrbFrTDod8v2BfIJrQA0=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 1D7F2138050F;
	Mon, 28 Sep 2026 13:20:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 28 Sep 2026 13:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616005;
	 x=1790623205; bh=vxkdii9Ix7VQo4OS5s53AyOtwZsAqIdchYLS+D7XBiA=; b=
	pG9rJP3CoV3aXiT7wA6mzdqxQqmkzT7NTyjBjONOARIJelIMyKwdLznkkRoa+Yse
	sZTWvdAvwXkK5CYFVSVtZf+p/wcVWS/uEliMy6yNeSO4lLFcgRAUTkrd8BFkhQPi
	/t0MqzM3GdhIuAEQDlKGEmLCOqKCi+QO645Ojno3fGAfDhHZKH3ZmidS7NMTXMKy
	IW7G1zzAGtriVCG9nvZx7u0x1fJTB4FEuugh+cjdYjjUWOvG4mPbAlb6DQOz0gDt
	xAGwKiXnhesunA8zf662WJVv8uCqRzSfe3tuNcBcQZ6EkAULjA8DUuWq6Eh00v0U
	nD2o+js/r2jXJpVEkAFgcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616005; x=
	1790623205; bh=vxkdii9Ix7VQo4OS5s53AyOtwZsAqIdchYLS+D7XBiA=; b=o
	tTvXp/PC9AMJdNTCJXnAQ5GNkj4ePWloawyqrk60GzmEkdMINzhEN3HNlysRj9pF
	KLkK+F1m2FeQsZMHtgFVQAfKPrWu4UQeXx5LWL4vanSM2taUh01f1M2Cmqg+q1li
	VdVfbgjtJ0vkSFwxMu9fb6pFwXatcbmf5Y8znHFQdAOtOdnOvpnpdx4pcCt0j/Z2
	+yVuI/BgJDJybauMgktVm2QCbAYGMf64EJMayQcvNLNOcN8Fdq5fYWvw5w1vZNzf
	7cXGlJaz5WxlljAscF2k8fOg+N0I6DBuZuk5Hco38BsP9U7hrKnazOh2kYoT1DLV
	/IUCPm6N9hx4Q/QZEn2Ug==
X-ME-Sender: <xms:xKG6arU-NFZAUfVOSAzA7XUgD5lRZPtRFGW-7wnS1jouhjjE9chVvw>
    <xme:xKG6anCvUp4CGAEq_uMSAE14Ayn4L6fh_2NK_Raiq_HrHbH6uwqxn-2Yq0nPvBpzf
    Ir0guJvZ8JMGakcB4WOim-5Hzw-FFfCotwGLQz9nSvHyhKCfrQBbk4>
X-ME-Received: <xmr:xKG6ajov5itGvlrpOIUWU0S3H2Fd6IIsAEea0FFVdkAlJBWFJ4HPbGUuczxbIHfl>
X-ME-Proxy-Cause: dmFkZTE/22e7clbyNdHwn0HCBx+H3lsiFyo6QkPV6dpSn20/QyCOxtHNd7QTmx6b7eJ6RH
    b7MD0YK3xmhVFW7pHJl/jJiaLCtzwYaWJ6VBcJNMtYB/lM8rXCQqoyXJAKc1Q+3NTJHLRu
    Q+616RIwRjK3mn/tprgeZTxr9VaE0UGr12rr0RgYUziHPYN8WsIu22gnQm98Dq7NFgLEYb
    bOn/3mv6ye0r5zsmXTZhHlWNyOVRZl7FwJjAmuaSy3Z2MGyz8Xby78ZPjGLjvAF+o1XCsp
    YM5+7QijkJtemWRQaETyS2I23TsNHUOR4KF7C0sS19NgtEnCYopA0Qb1idGIqDD/y3bAYa
    uYGsTDtUPqVICbQ41pUlOjImyF2mYxv7H7gXJYfr+UUv6rve/u4aNMTBiDT8EwdXsk9Mx2
    TXQmTq1D7W7WpUpu8G+qst/ms9fDu//AR5HSo2XpBx/CwCnd8+mWeB21rTZjXb5LIE/uRa
    QrHQ3n9NKfOfq44WCCaHP+Bx+f13ffxua18Crb1sbm6QoQgc5rOgtZKAnWd6u/PMAqYt7H
    AMpT0cbBjxy6q1k4Zqo9kWKY6YhgCARYSauXvd43jgaGpXW4PkYONpj0EunNZHFanC+HCT
    S92pn8bzcE29X+u1falzlomjIS3saU7TcTttaYKC/oXAb3tYP8+RWOwIeqKA
X-ME-Proxy: <xmx:xKG6avXmNToMkzrPAVdGb1C9RDHakOzTvBWakh4jtiDxxyzr8gMj5A>
    <xmx:xKG6avoZ2gXUh_oqH0bmQUC7JHgdTPfdG-5lyjnU5cRaRmhSsso_Ig>
    <xmx:xKG6aghhCnUwCnQXjXjqzm14anG5jLvOmuDua_FSpsZlSsK4emYYIA>
    <xmx:xKG6al4SHzW0IpZ6a4D737SKcPYf7P-hagcFXB1laCZk-31ETaFqjg>
    <xmx:xaG6alArW58l36_-BMc7T96Cu8HyG9HAQSyWQhmfP9l37WNBz8SyPlkG>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:19:46 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:54 +0200
Subject: [PATCH v3 06/12] crypto: api - Allocate tfms from the secret pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-6-e511e9ee2329@jaseg.de>
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
X-Stat-Signature: p8tgxnhbpwu16iq38q5siu4465mp6xbi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A144720008
X-HE-Tag: 1790616005-964630
X-HE-Meta: U2FsdGVkX1+aV2U1y1v+JIMrt6FVtMfeCaozkmg/OoFRw8XRZ52IM41Y00BqLKizF1w6WqlYuyxxLel8xA+TudWH5o6mPyfj+7imMJnSeJ2FSC+vR+6NMW0xa9lCIdsstqHyz6tBHdbjUtoE9pFWI0pXfmwWlIU5uG40QUj5IhGCWByTOw/00CoeYm1ix34y1Hg4g5IPmEC1LaugONps1srdim4sbefZSLYwtv9xIlQn+NZzO8NeSCNiv1lDWhnGR4jV2M3+UW1fdpynrIgc7rGc5EsAL6GQV1Hhf2V8dwf+GkNLlrDRFkN3IuH8ZjqZ3YunCiexUMAjZgYaWYXEbiyfDjoJXXVikuWoM2qkDJ1tcvEIa+a7Vvbuns+tRh1HvRret1lAY5/kxq68jshOzSgAm46NLc/ilhq+jxisCYu6SrG6qpNu4eC9pF1sx7PDxjpWdnmo60dtkH+mZfRPh9/D/ASmAlnfJj0HWJ1I6dgCIuDxoHvglzIPqTB5CmThptXceBSpVcfvwjLeMKqHJfq8TF+jG8PJMWQs1CukjOytS4Lcl7gvSH+nzszZicmzLHKlcECkMIU71XDnT0hPfOWtywCUsjCGpDTnE5Otqj5dBPazfKeG/S7PfXwhtlvfXgSVyTjmFH8aG2FCUx43f0n1JF6cYJTxmb33BPpdUbyvt6/IiCjwOV9SuaiaxStCiwndn66VkAbdUbuN66izTekDz52u5Dsq19Jpd/Tw4CQoQvlynHhcqOXsKO7LZyvoyu6/aqfkjkpLYa14+0ndTrSD3VHXMxwU/xTSwF1MUltX8Mo1PJiY5dRiYAU/Q+5eYybZb7OqoLzMr3koUA1Kb32JEetJ7EJDiCitXdTzI8530Yn2DkyFacmpokxQgvU1Evce5iE6WTPX5nbGd1SfocpmuZc1afDte4HlVwZV8HsRFU0UFJMpn6T9vkd6Gh1IW4BrUJWJcKQ9UUjK9tE
 m1IcdwJ2
 7vIEOo4Z1SNDxjERUbw5XRnxmDZ766PXh0EonmEq7ax1qPLDx80YF9wVAsNU94gV+yeej+o9ktX3zkTSoWQrox17sbqgUE25HkAyGhXVK2yFSqVhC/10dMF+y19Id8gK2+0BpXXvtJew7t/gEOyg2+FDr1JFu/ttBBnMHCh2liErco0yhAxci4oSMjIoEcB0BmETGcby7lIrTXwbdYrLrYJJSj+R4VbecT3sz07QDNHwWQ/enGBv1zo14VeqDmcMV6dWhSf1W0MkgOAinuPZBQ/fWm+/jQZEouIw3J+snLxor85P01rZuCri72uzlugH0wwK3SfSvHMUIBOJ4CgK8KBv/j7COxpiA9OTpCsFlI1I4NbY4leVEmMhDDf2WPAhMR45X8Yy5eG2EF+rs6awWpHBx4qcDoh1qUJQWiH/newno5O9rFSXByd7ptFgBqFmyzqPjqaIEJVc9nZ70PlaWlXXiDRl8Sc0Fs2vnsTuMailGXYZsz9iNR6QYNhl4CPixBqkG35QQNRAifgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A tfm's context holds the expanded key schedule, which a crash dump
would capture.

Allocate tfms from the secret pool, so that their backing pages are
marked by crash_memaction for the kdump kernel to wipe.
The context is a flexible array at the end of struct crypto_tfm and the
frontend's private data sits in front of the struct, so the whole
allocation moves into the pool.

Allocation cost increases by a bucket lookup in crash_memaction. Freeing
is unchanged.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 crypto/api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 24227582cfcf..eba310f128dc 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/sched/signal.h>
+#include <linux/secret_pool.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/completion.h>
@@ -413,7 +414,7 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	int err = -ENOMEM;
 
 	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
-	tfm = kzalloc(tfm_size, GFP_KERNEL);
+	tfm = secret_pool_zalloc(tfm_size, GFP_KERNEL);
 	if (tfm == NULL)
 		goto out_err;
 
@@ -428,7 +429,7 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	crypto_exit_ops(tfm);
 	if (err == -EAGAIN)
 		crypto_shoot_alg(alg);
-	kfree(tfm);
+	kfree_sensitive(tfm);
 out_err:
 	tfm = ERR_PTR(err);
 out:
@@ -502,7 +503,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	int err;
 
 	size = frontend->tfmsize + sizeof(*tfm) + frontend->extsize(alg);
-	mem = kzalloc_node(size, GFP_KERNEL, node);
+	mem = secret_pool_zalloc_node(size, GFP_KERNEL, node);
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
@@ -525,7 +526,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 out_free_tfm:
 	if (err == -EAGAIN)
 		crypto_shoot_alg(alg);
-	kfree(mem);
+	kfree_sensitive(mem);
 	mem = ERR_PTR(err);
 out:
 	return mem;

-- 
2.55.0


