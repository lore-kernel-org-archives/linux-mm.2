Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601AAC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1F06B0098; Wed, 26 Aug 2026 12:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761936B0099; Wed, 26 Aug 2026 12:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650FC6B009B; Wed, 26 Aug 2026 12:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 389B76B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0AA11C05EC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:11 +0000 (UTC)
X-FDA: 85143935142.16.E2C6C81
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf05.hostedemail.com (Postfix) with ESMTP id B433E100004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b i+kc7S";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=H4drzaP7;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv2FLl1ikHMiScnydjr4vJ1LmDfldI8n6iuNGCnTKZw=;
	b=A+bE/wbnEoIlRfdmTtmqCllfndtkslYvniQKbalEn8wDIqW/48i/YmMymPGDTGw8nRylmo
	n4Amx065VO61C0OZs5tzt19av4DcdjUKhO3ylM/yXT2wEHoNNqIW7AGC/fIH6vsfiZzhPv
	aCWt0rrjrmkCrbf8QW2OEpWWkpVKdBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761269;
	b=UGX/VKMQoFCSz0MPryX023auGXLbSNNb9PKJBqVinduIl6auRnbp6rxCjiSLsltElCIZDb
	92Mjnmw9taZsodquSYdDUkzoEhxS/xI/MYwMYz0HFbSzy+4Hvb5F+Pui7ReEWDgZz80YWe
	DjGDdylKemIHvY+dKY5JVQDss3RejtY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b i+kc7S";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=H4drzaP7;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 30B081400197;
	Wed, 26 Aug 2026 12:21:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 26 Aug 2026 12:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787761269; x=
	1787847669; bh=Bv2FLl1ikHMiScnydjr4vJ1LmDfldI8n6iuNGCnTKZw=; b=b
	i+kc7S0ld/EJOGlID7nHa2apNgtC69ZYY4g3eOsBEQl5Ce7G/p+BG70IJxyccwER
	xIxYoj/GeOzAQ/QwNGH/A8Up7QN1YoXXZTpR1hho1ZGyVF/jDN1mUjWshGPY7Afb
	foBsbqmBenqWmJvnug5fGv/ZXenhtW/j/vldCSqq8Ybsv97Nqk/HUibjrwrpUhCu
	byo9JSmgzenmZW8NOmI5GwHZB3uP6wc8+Bp8XsLhtgNLME08Wu2ry24uLqMqjOL3
	cOqfp36UHTWya5mNoJTswJ9Ah9Lguj4T/9MKcZL7iGM8Bi6XnBQnRU1PUPyURFpm
	i+XbOv9AE+Cb06F3AfuwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787761269; x=1787847669; bh=B
	v2FLl1ikHMiScnydjr4vJ1LmDfldI8n6iuNGCnTKZw=; b=H4drzaP7J4XHlzvKC
	2h/dA0kWrlACAxqOyCDE5FwFYfxKRCivUfdy8c4skJCxNvsGKSxNFGYEK0AxU2xv
	x191DX0yjQDTfg+WjxR3d2lnHvz87miO++1WcsadjLzKfyJ45qA0rpjpoLDpKQSK
	d5F4IfqjBWHJcNyMmGE/0Yjsvk4S0LOff0UhUVgioZ/iBgso23ERHivlTHMmbzTM
	O7YOBG+Yhaws0DUsh9rK3HG9RD5xBLJakLrRaYRqnFjsHRGTMK6i+xlAgFFZF6dA
	LdrOdmHnGd34esDwjvi4rTnZdmdZCJaOfjd28Iopbr+DYRckSQ2vuuBDI8abSGtd
	n5I2Q==
X-ME-Sender: <xms:dBKPal7H1olP2_Gqhn2UH1s6rv8obdoEc86GuvYXsYGmLMeL8ufWrA>
    <xme:dBKPau0Vfj-sMLpxFGSW7MIe6R31mG09j5QWYJ4bzqLfyeG2PsdQU3qo8jdkSz8gw
    aiMNE5PdpxIkNIIVQSsKxpUZefXYmc79eTcp5D2a9SV7Cl7PRDEW5A>
X-ME-Received: <xmr:dBKPaingv89MNTLj5awaCDVmX1_KnwL_NzO2HdV-dUA5h2cppm32IykPwbQ>
X-ME-Proxy-Cause: dmFkZTGBpY7kNoX77sZdPDdL91xDvRNv92b/+8WOYmCGA6aQH9Q102aXniwcYcn+2R3bEj
    uCi/l1igqxgbq+7uoWVnSfVnmmWrLGz8UPAjIXOdULdKf7WqwDtIartGLCCo68+ug+tCv7
    Ph9+mj9AZr2Dj3uoVsu8zcjpqcESEL6Qo+qhix3q57KDkOugB1EyJGuvn3/JCvR9j1Dad7
    o+mC30PVOUmdi3WxO4xeazK74tOpUh5phSdSI4XIlRDA8FYZNVwP9p7PMSP1kYV7SphUR1
    NVW71rOnvC5bor+jWHffeUW4ibVwJbIPbYc8TjXE3UYxed4i2ZOZ49wwSEox1MjCbLFsSu
    YPKLkIkQUnFzSfmoRy09Yk+6QAiQBNOL3kgRmFbcNEP+pkMk0/HwajWkkbMvDEzbG7ih8j
    9VmjLPs0GHvU90MMBTO4IgmRP25L9euMYxF42Qnlcb5IJB4Yj4FWrmjvmydrOhYwH4txfP
    N0sGRbfkIRMlAotV03Pf6h+qHYq5kx1wkP9qeFqLirkNozh7KFRsFG0POuQgSn7ocDa1Tr
    TmxNd75KRYhV/7XI82QPUB5FHfaJr/hNTvoz7JcqS8jlcKPr2c1v9a5pAB6LVmnBUD8ljB
    fRa/pR5DZ0LmzlPvoYi11c5SXpBp1O9ry12oYVB9BFPnFUKCOwYend85kwgw
X-ME-Proxy: <xmx:dBKPakggiS7Gn5F5p9eYQauGaQnk5Vgu3a4O3IQxeIhvCJxmP091tg>
    <xmx:dBKPanQhg0Kom7A4zV0NXiVbfFF4g2eYoyOrw2RpRj6rAXxfgIkt3A>
    <xmx:dBKPahgS_C1KAEZCP3e_-StlPxcng4O78xp4py2uC2-BZHPL7QqL_Q>
    <xmx:dBKParhjVNU9I2uSccGsCJ4JLXu9I0C_VM_YmV2l5w-E7wgxtadjxw>
    <xmx:dRKPas2A7RQCxvHf1KcXejxmQ7gw1pk4PRb9bbbj6P3quHoQxDVJgXee>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:08 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Wed, 26 Aug 2026 17:20:57 +0100
Message-ID: <20260826162101.1314941-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162101.1314941-1-kirill@shutemov.name>
References: <20260826162101.1314941-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B433E100004
X-Stat-Signature: msc6yrnbthefkyqefzd8k3ngfppoe4ak
X-Rspam-User: 
X-HE-Tag: 1787761269-468427
X-HE-Meta: U2FsdGVkX181mcssT6QrnEOsdepy/ZUVl0mOSfcs7eqMeZBopBmdvO+syky8TkBBTrjPrjjPmo54dEdRDDQVxHecGr+fi2hvjt9AjrrQk5jellSNA4rpCtvd5FoPNnfxp7Qj+N9MW8bU0OBlnTUad6v220h8D1wTh7ZAkzqQr394pcl7cGD53Wfl6d8KRJGCOQ94ZqAmcnK0FByBQpjBCFfh/3DUt/MssD5EArT4YdkrQ2MTNybM7XUz3WrAJBzpq+5iV7ujh8jTMEuo6girdruiWij70K1KsAUlCIPjbVsnD6PgI51eG+9CuqlR/XePGY9ji6h87v3q0NuIEji1P05u93NCCuaWwhMpBLh2GiAQsGwL8IMCYNjdSzLRK27O3Opi9f1IQdWJtjh/rRMQQsSLliMqxM75V1s+ED+H2Z299mN7VD3Jyt2ZTzhVFGQ/hrtEK39c3MLUaiYdM2AB0ZDSUYqWfG+FFy/YaxgKGfhuCFvUgwLyVPMKhzFG71vI1KMtDGJfFPMi7U/qOtwjk87tIuXjxsz7B0MVaszXw4hxxvd/SRukKNZoqWQKfqDnqYlbLcrSd+YH8OwQ0hT4A7H5Eq8UMMOzfLVEskrA5Lv2D8PyZQOygJTCP/+3HQA9VfLoZuZgXfhCDUVZXW5iIlSqY6Lnj7k50rqrp5gF7NkG4QGQnklVjB9ttC5oqE3nDZMHZkAU404P6JDjFinJfmJDJ98dDyKy6Kw7r+YEiIB1+nz69D890TO+LIAieCvOETzuzF8vmLg/s9Wzkj7+sbVB3NAFzFU/MJA4/cG5P5616zQow6PU5fO1JdAWOKsrNQPPZ3M5cPwfbjSUqSKG86gaOoQarxe2QmMrV2fu1qMPXew58iLCKVVvI+ZlpAhDr44bA4VMM1tbtu7/E/GZNxAKp04vcOZ7HxlTfYq7pmfMkfuoVLeCaSwmjFkdBnp4mvIzL+/znXwsbQbEciE
 Tr+Q3oVC
 SZpv0J6sqKVuyfslZtz5Q/yHtGbfeHmz8SSpbrSacmL71qdnLag2uj7FkH7NbFKnBbeZJn7nR3C8dhw1l4sJa8zHFl/Orbn8bVejLHfhXJ5U6so0RiVsgq2tQpx6pb+fZKvzaWoASg7196wPQmFsH1sJlVzkG/t6oioa0sXDp2Uf3ShrlvuAArfJcUxq6fah3XuDxBFY9/FdfZc8QXutgKzWr43lRUWnNWuLg6Awck4zGCI4GLm7rbIFqf0rMJMI1WTe3jWWxhwOXIiL+N0+cqVPJKBraBMpoxH+yADpVR1eYv8eFqF6Ez5dMsiSwTNjBf57usgr76G17vklJ7UOqL7DtZlcSZHGze6AAR1HffwNDrJw50PeGNXwwDs63VRjZBi86MQ9iFTp+kqf8fQRWLto6p9k6WBsOy+BnEXI0ehKMNKcwZYt/KkynJ50QiRzD8QQ4NIEzi1xPkeLPcmTQWEMyMZaWFL8X6RPKPfmiQDRqofXwY3M2s/7hXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put(): clear
PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
the folio off the queue.

The folio_put() race is the most common case for !folio_try_get(), but
it is not the only option. Another scenario is folio_ref_freeze().

A zero refcount in such cases does not mean the folio is going away.  It
means "don't touch me" and current deferred_split_isolate() doesn't
respect it. It can lead to unqueueing folios from the deferred list for
no reason:

    CPU 0                            CPU 1
    ---------------------------      ------------------------------
    freeze a mapped folio            deferred_split_scan()
      folio_ref_freeze()               folio_try_get() fails
                                       folio_clear_partially_mapped()
                                       NR_ANON_PARTIALLY_MAPPED--
                                       folio off the queue
    give up, put it back
      folio_ref_unfreeze()

The folio is still partially mapped, but it is no longer a split candidate.
Nothing queues it again until part of it is unmapped once more.

Skip the folio instead: whoever freezes the folio, owns it and owner is
responsible for its fate. It also covers the folio_put() case:
__folio_put() unqueues the folio via folio_unqueue_deferred_split().

Reported-by: Lance Yang <lance.yang@linux.dev>
Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..6281ed993243 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
 
-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
+	if (!folio_try_get(folio))
+		return LRU_SKIP;
 
-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
 }
 
-- 
2.54.0


