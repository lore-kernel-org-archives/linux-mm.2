Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101C8CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B63F6B0092; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667CF6B0093; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508586B0095; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082456B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:47:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 418E81C5756
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:52 +0000 (UTC)
X-FDA: 84911003184.05.5D182FA
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id E47411A0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ABlGrpEp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215270;
	b=fNjdetBifR2y3feWjhlR03WfYFqqPHEHoszxnI8koYfdsiN+/wt3YncYHmGx1NkLZgIqta
	L/44MLe6P/tQspSjun/lRDwL/WdpCymlVJyrCy+CQk9vdK3hWKOfWzox5nxCSjRJC2otTz
	J0oi5N6ka2WdDgpBjDdPP86wVBnuSeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+GJOHW7bUhTRibZxxrx+5BAKKENWwY9HUVzNzwGEiY=;
	b=JSTNCaxTH8aRZ5csg+BFqKsxHxMXpQlXUhkfowSchcqVTgDDIVjnvRFjtfEXU/cGTVu1Ue
	HfB5o/i94ZKTKvMCfwMSi/3R91flSrBJXFuZrpVMP5TvVgegggm8ResqpkVTxYGhwpIrMh
	oAcglSiDVjPWOV6Jfgq5zhn66wsnLk4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ABlGrpEp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-399f5e574b0so7980561fa.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782215268; x=1782820068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+GJOHW7bUhTRibZxxrx+5BAKKENWwY9HUVzNzwGEiY=;
        b=ABlGrpEpoAzOvfnqfnXUCzfMoxbfSE8LLwxxAdOHtXD3Z0UwtuFcY4QYkeCPxBcCGY
         +udi6ljQvUW1yRl3CyPyHF+OqPAjMG9y5V8EV3MuAIGpijVAI7wEd/WxBQiJWJBR+vHW
         yixowBIF89ltqNd3pZsyoOM/XtJ52JvufjzLRr0L8zAFAnDL6WNw3viuZuganua4Ystj
         z9aNr0GZUCysOGw9gqptoitJWgQVadX3EAUyzBAWOqRYpcvdo5eTa1OweLcIztJJpFMe
         p/jBu693Rjudm2WAfKOLXp2seVEiI53kj/BJTJVYpeQVDdsHAdFza1V/mr7mg4NGANXe
         Z6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215268; x=1782820068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w+GJOHW7bUhTRibZxxrx+5BAKKENWwY9HUVzNzwGEiY=;
        b=Gc25/x1Eqn6XqkiyjhT/e+99F5aEuLg84HohGWhdIEfvRFPL6PJqzEVmgmczsjBeln
         agqXqa4D4O4Nybk84Srp7qmrnRyLnHq+QpJOc2lfwQvEziTLlYr7SHo1NuVLl+WDFMdM
         1JiAlfDHK3DZW0JZKB1PjgjtDWeafsuIqW12TovFqQ5OyPE5l2YslIBm6G5C+v0nCBa6
         dZIG65xZNIlht8c4hT5drUW4yUUxum2tQcNfN61GaU0NkNFryRamw1ljFVmBbNeqfLTJ
         4+oIZuei/oHto71mOc+HfmGStrP0oSSXiD1KgXtjE3uj7ym4kxhd9BOsiDNNTynoF7ZL
         3JcA==
X-Forwarded-Encrypted: i=1; AFNElJ/Rv27Q56s0teIene/hXm8RWFfnn9sjelEuB1jipiZwbK/RSYOSqvrut3nq2d1Y3QbeQ6SiAc2x6w==@kvack.org
X-Gm-Message-State: AOJu0YzkYaPzlSKJEzMgwb/0pl00A3fIuWz7YBa4egd3CSM6MrqRHD8S
	bWr9YqsWevQrDR3sgy356CHjJAVu928BmLyOt6BJsanJPtYZprMmvevA
X-Gm-Gg: AfdE7ckLxiZGV0Yl9v9/cihNjcybmJ0PagNpT2wqnD6z/oxHjI+3enngv9JERIxXLyL
	7D+ccKQTueBjR+iyQjhK89s7K7zp56XZ/Dtpt5eG4U6OD9kSOpEG4L8rxwFcJEWQ0BtbHCzk1+j
	XOzwhx5QFtcWm9VMvtYYPRI2uV+68OUb2+B/nThTJ1/ZkEdE1qmJs8LxN7xapEdUzfIH9yVDkuQ
	r6CrUcr21pIqm115Tmn1RPFUaKKr1DALYCB8/XfPNcyXjmxcgCtkBH8YxDOn9huGPYmqb69GvLd
	++VkVADxUnPPPgVkz00D9ZQAXTt6D1IqIJZO6j8zqAmgHE4Yd4e5ycU8+X2wYbEK9Wi76KQiWGU
	QTMpy2ecIB9Hm16XMICkUGEDgjDVpzrSN3VoOlFLtrUMEntzARVVNoAxNsixjQ15P7+mvpOjKGW
	0Sw76zELD8rhh3s2jNIgOuQLUCv1tib7GsWu8qq6jAn8AgDA8EXQWF+kkZURNbF8262Lp0R0hWI
	RJD/kdBxVc=
X-Received: by 2002:a05:6512:3087:b0:5aa:6395:9a00 with SMTP id 2adb3069b0e04-5ae3e5242cdmr709671e87.45.1782215267913;
        Tue, 23 Jun 2026 04:47:47 -0700 (PDT)
Received: from g.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69555981sm712083e87.34.2026.06.23.04.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:47:47 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 1/2] mm/kasan: remove redundant initialization for kasan_flag_write_only
Date: Tue, 23 Jun 2026 14:47:42 +0300
Message-Id: <20260623114743.4565-2-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260623114743.4565-1-igorpetindev@gmail.com>
References: <20260623114743.4565-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E47411A0009
X-Rspam-User: 
X-Stat-Signature: d6g1ci73j9gcj5wg3efy8wpfr7uws4hj
X-HE-Tag: 1782215269-726184
X-HE-Meta: U2FsdGVkX1+hB64+uF3jzBc9P6FbLEDFDVpm6h2ixZSomVlSk8lZd0tf+LKVazTyjoqurzOEaNzA4siOYRcau+o3CiwzEQUKCZ1RmvOiaIt1QNxwo+umiqGn0J13W16Az7i4+s/6bougYy5uVCGXMPUD00uFaUPX4Cdjy7sPwyjbsXBo1fMBipiF6FS52v4b74KbEwV3vcQvtiSdO2mT4mvRhTMUkIiaHsPrQqLz4kgLuxKwO7NSf4EhzT/FQrl72HWIkGKU9Fe9zkGsvWYrPkv1KSnDV0a7CxJ8aNboqoZk40VwJoGVQqhE3sOXqBRUNoI1KGa63YfTC+QZQhM/Vn/yoWDp349MM7lTFtgiGa8k1+OndNc3UsGCeCdxi7vrZPlrS/tUf4iF2PhN0cfNvXvyZzIn0In1Ra/qyudrBzk1EQJnNNpl27kZnRNF6Wyu168cTbqRQt/TefrDq3eire0E1kegW2KBu9Vcc/H9NAjVg6XgL1vbG+mILoCoUtMz9PxwoqIEd+naVoXAxsitwDwp/8lnERwu+rgF7Y52ufYOkauAJMxu7w/8Cc1RpFYGDQplxI/gHJqjntcfJMPosxAfnRosJEA+EC2lMm/yJXOPYNtkmjkDbEcKSiduTUR07N1GwTT4olN8spj9xMt9WDK8jtbRO+kwMXZTq8yPB/sIb3kXMOSda1HmWowPmOgeAOwu2cCltfY2ruggVumAvNH02qZKepECqNc9MNETtbZ3lA/uVzK4FShoX7PmCS72UmGcZBKyMGo1bObZKXCaomFiIEU1GMS6FHcSnqGh8SKuRPwXdzmtVVUzQ43CksFweLFLJrdNMwU/gzmQMm7koT1kLICj9ml//Pq71LrarRZ7nBxg9F/SVk2l74frNOMN2axuAXSrI1zxD8PNkNGBs4Wty9Y0VeclPrTzTgL0/2jx4gze8bAdNwDhx9sFSPbdeeQcgr8OAifyFPdinjh
 y5TmLbOh
 /bkmWUlEwlMHPiZ2QyZbEmrymbgl8h1/AglB2cRM3JnTQmN46NpZGBAm0NfQRpY6rLrjdq0Vz3I2qSinilUet3kgmOTC28eqbXjmIjcQ23gOVZCB988N9Yyqgq3bEJVo/cAcHjPfvs0QRH9MfEnoFdKqUCobV/6ePG7jiGaVu0MnvTzr0zFLXBVNw+o43dT/SiMn2LwZ7hF7dP0yXlShbG9+VIhC+s9veqPHKHwsSs05qAHmtXCgDkGRaRo5ZvfBXF+8FB2qcnvz7phfLoheD14eCnQl0G9G+EVnksPmKUoc37j4DzPm1nm7wClENnUold1SvpGhbMODoJ1WEl2u3rpk6BXen3C81EZo2bDS7ylgxsrZfe+EoDGFtHP6cNmZdqA5nKVMW7hiwIqX9FZAg1yxh27F1/ddb6V/CGjvfZuUJY8+D9edcf1ODOX5vGOyT17XY8RLZtIFKCgMf37K+PMYP2umhFI+jNmUoLQchHo4joy2hoNvHEYbkBq0dRhwQXBIWxYt7c+rcy0kIEf9hS7dsusLZiKXkP9OVRT32rFhFqxZFtRvdbqLxo+eAxD22PCTeMW8BrbE65Tk8JRkVtL3W+JVJngj+YVECfhL3Syxbsd8toLln6WJTTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static variable 'kasan_flag_write_only' is implicitly initialized
to false. Remove the explicit initialization to follow the Linux
kernel coding style.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/kasan/hw_tags.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index cbef5e450954..a848eb2f9910 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -61,7 +61,7 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
 /* Whether to check write accesses only. */
-static bool kasan_flag_write_only = false;
+static bool kasan_flag_write_only;
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
-- 
2.34.1


