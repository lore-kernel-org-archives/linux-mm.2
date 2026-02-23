Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB202EEC287
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 21:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1326B008A; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982786B0093; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9106B008A; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61F1D6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 034ADC0900
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:49 +0000 (UTC)
X-FDA: 84477033900.24.C81D475
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf23.hostedemail.com (Postfix) with ESMTP id 370E3140005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=B2O+We8Q;
	spf=pass (imf23.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771882668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn1eVPmUTQjmVmfZXESvM+rhWqpDOYbvQsk2y4pTMKo=;
	b=M+miJcZdGK8ltPqyQl4zBZAh/WCdDuGC2tEYvne79yhAsK2K0pBjovpwox73oDSFBDMFr/
	JAo4/sJj3wwoZSPoAHl5KvG7UgK4gegyHvmy+sgxptAfOoEuszjpG7nnOyk/SYq0k6GFA1
	4+MM5pgY6vNP2FjCtzDRa8nBOpy1bI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=B2O+We8Q;
	spf=pass (imf23.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771882668; a=rsa-sha256;
	cv=none;
	b=KJy+XXkjYXishmOx5lfYQ04fY78TtqFkCEtRuDdMwF0PcZ4H+w87++FNmHqcilfK1RU7qJ
	zEQzPy7AKe6e90GYpB7edyBACRgwOqs9G+uRfU+oRfSzQXYnAMXEmkM1olL34VfOe8EEKQ
	SVwEoHiSgs4PvIRS5GTJXeXXkDOiZnQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1771882665;
	bh=MYpqUxMpYwkhOju+gnYcw1HvuKIFM971ic1B7jd/Brw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B2O+We8QVKlqiwrYw1bgfyEGqJ3qyfEPJj6t6ORYSOU4opLdaD4SmhZzbeUd1bXTb
	 PKhx3eHWL/P9cZedfnY6wTvmg13gqacE2zrpXvzNYlRAV+1AB/pvEVYRUsC+1jMDD2
	 PpKPMZ9rW2xRULSw87FSAuBhPcyxfvFRXiBD6qT4=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 23 Feb 2026 22:37:43 +0100
Subject: [PATCH 1/2] mm/slab: create sysfs attribute through default_groups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260223-sysfs-const-slub-v1-1-ff86ffc26fff@weissschuh.net>
References: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
In-Reply-To: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
To: Vlastimil Babka <vbabka@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771882664; l=1444;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=MYpqUxMpYwkhOju+gnYcw1HvuKIFM971ic1B7jd/Brw=;
 b=2eAT+dOKGjcpux56nH0MXkeFoQtqbS2Y00d00OObMhUZobtW3Q17HQO1d+0UoK6pohgLM3RAL
 xEwsxVXTZVuC8J+T90hT6NavcrMaO9vogEZZm4Iu3QQNfwZb4gITgPB
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Queue-Id: 370E3140005
X-Rspamd-Server: rspam02
X-Stat-Signature: udw13kb4p4jbkuyqx8ox8hkame658sep
X-HE-Tag: 1771882667-173625
X-HE-Meta: U2FsdGVkX1/oam8X4879XX0F13HZPTjksHX2/HxhlBaCPTlgv/tNkpCaTbISHZHTHo8ejzV0GZrflbatLzF0CX0fuL5eFEhGNJwRhWxNsREf2sfRGUaKKv1NHbIxbJcMDrUQ6sdtKW9wgFxPb16MwYUFt2JSHdlabTPeWFNfnzRRix/kKaP/CDWc+u9OdIGXr00/TQ2h0/IqQnq192qWSR2KRuxCHRa+erpJpTOBPlTVN1Wfm1PlYIk+eH55nGAoVPlPHXrVBpMZLetFvIElNubBceG/zywDZYed1FwzrEwU/+OiwQLB9umOYcXb3OKA1liJBrYYjcEk5WQsm+k8J7y5WLQJEZKVZccCOZDmYyaRsdL5/+6/RI3Ee5d6WXNAr/Hq+FQiEoqI4MML09gWT7bD84YJnH32R2BXP2qYf6aD2c47dndqtd7x1XEcYvjPaDHYc61rYnCLgoVd9OWmWMxTj8fSYez7WbsRNmzAJKo+E9+Zjx45E0huyxlHeF32e04t86OPfyAa1QnP60lLIHM8MGm5W+SLMvB8ERKT8afLe7b3hyYzAXjOYLMffdDTC4ewMVodIjHDNWC6XAu9AWhicQmFrnrFnC6bzz21LivhT8zrSAbPg8hFnQ7W/rN1fowyL4wzmcqCwHDuf7WSv4bvqUtvYhbO+uR4+uHzJ8Al7M0XRC2kQ3YZANLgi+xSuSSz9BH/c48bk8c2BjFeIPZ/QEtMczQXTSlbLG5DVMTyh6PcGjqhf1Vzdk6VcfyBG2zDgOjRvZC/Il5ZWJTTlEuKZT+e9HpGukSKP89/KY3qT8FELUdfo0r+s8/HGYi+k6PFuiqd6QZfmEufcW9AqsMA7ofvoxPOS3I/F2A5BJmKMTpj6U4/1hfj7eAo8VSxURmjQzCDr+GmIeXDuVYQhj2Z/AFTIMdFiBD6SKIPP1fjL09nin/M8rCFca8uyau/bWJj3AAG8qrRPprl8TV
 Z43rwBF2
 nJ0bTCGq4WsOZWeuxIa3DlapDVK+cEESgFwJJVrz55X9+vtuP/D/jbQBWWbw50GFXXGXeWwYPbSwWi5fGkWaCNk9RKWgYnV2e8k22KnPqqaI3qSrRilPZECsCiY8Z6T7JcQf7qUidwAaohB9SiQXdPZ1q9UQXPONXNw+8Tc1k7Xbtuf0wuSNgm7qqPVpUTEimR85XnoOtVWqENtqg1ytYnfPBj+XYql6Ta3PG+/kHB0QKFo796aa0Dv3l5bCwDkWb8lxYycTMmGUV55UeHfITZMOo9oL0e6K0hJHfkHX6x9ApcRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The driver core can automatically create custom type attributes.
This makes the code and error-handling shorter.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 mm/slub.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 862642c165ed..a48ea23b1728 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9317,9 +9317,7 @@ static struct attribute *slab_attrs[] = {
 	NULL
 };
 
-static const struct attribute_group slab_attr_group = {
-	.attrs = slab_attrs,
-};
+ATTRIBUTE_GROUPS(slab);
 
 static ssize_t slab_attr_show(struct kobject *kobj,
 				struct attribute *attr,
@@ -9366,6 +9364,7 @@ static const struct sysfs_ops slab_sysfs_ops = {
 static const struct kobj_type slab_ktype = {
 	.sysfs_ops = &slab_sysfs_ops,
 	.release = kmem_cache_release,
+	.default_groups = slab_groups,
 };
 
 static struct kset *slab_kset;
@@ -9453,10 +9452,6 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	if (err)
 		goto out;
 
-	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err)
-		goto out_del_kobj;
-
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
@@ -9465,9 +9460,6 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	if (!unmergeable)
 		kfree(name);
 	return err;
-out_del_kobj:
-	kobject_del(&s->kobj);
-	goto out;
 }
 
 void sysfs_slab_unlink(struct kmem_cache *s)

-- 
2.53.0


