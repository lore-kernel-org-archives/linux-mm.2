Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAEEC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201626B0095; Mon, 10 Aug 2026 14:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8D26B0096; Mon, 10 Aug 2026 14:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEAC6B0098; Mon, 10 Aug 2026 14:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C86826B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:57:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 532D112028F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:57:47 +0000 (UTC)
X-FDA: 85086268974.23.CDEF42E
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72E2AA0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:57:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MkL8Cr0b;
	spf=pass (imf15.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786388265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srMva8ELPlGiijDY3h4l4HTa6KEy7A4N7csv16dIv1c=;
	b=VkPB1s1oHP7j+x6L7U6izoxqz+ZxxeflzNFL7p1byYiwUaxxht1RsRJwrkAb5VxUfjbNj3
	F3D6M46UZ9qAQ8onkU2d6kpE0nZ9fDOu8/5hhXRQyvvK55h+OdgSl1gNK5axXjEvlNlxKp
	noYlQt4K747k0XW1UalkcCxxGzU98JI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786388265;
	b=5QzHGMoFe9vq50CmK20VqpVmdGYkzoM2K0ACPME/vYHu8qZW6LrKZy2AIZUFJQxY6HkxkO
	GHOER+DUSpFKoiJxJXdCfGwTyConwgMwTypAIpqAWI6AUFQl0NslEzDb1YJt1Yqd1f+8gu
	Q4NPdBfK5kT9gNEJ6yL7BbYgfkwJ8Tk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MkL8Cr0b;
	spf=pass (imf15.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cacef7d299so19875ad.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786388264; x=1786993064; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=srMva8ELPlGiijDY3h4l4HTa6KEy7A4N7csv16dIv1c=;
        b=MkL8Cr0b2v97SCAzYTwGU7fuDc+m4jCWvg4m5h+kZhYCQJj0zPKp7AlwaODZHpqHt0
         Wso6LmQEFEGsbbjjTwnlLkT+s0+WSML8ah+cf60dJjpOYFyuIVBxNA6A5ERm5mQoRbAi
         RgsDRgY/FUZJH5JunyQToCG03SgeMtVVyD/aFW86udHP0E3meSh3prmtSu76vC6pmVvf
         EDMuLCyumNHxYYN9ZpLvX6g/HTv8pogGBd8haMFJiIpexbDhljf0aYGZE2lwPGZvXNcf
         N5oVsdIYnOBfvMGKdrMMB261PZAXS9resq7jfZRyH9HJ9zvHwabGUcCB+FwrFTxoHf0r
         Dj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786388264; x=1786993064;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=srMva8ELPlGiijDY3h4l4HTa6KEy7A4N7csv16dIv1c=;
        b=MoBGAbFr+xTke896tFTb78oU4iqo48EEcFwnfqr0LBmt+kDhsjJXB3RrC2bDnRqB+a
         cMQyGwnqHdUZpUfCQ4pMxEKRKpSIlBusHsLQ8EaQV6sm91XsYELMqT8roHpaYkPNv//5
         7rWInNZKm4HKnWwYXHshxrFT1qv5UYcB8Rxg3TMZlnPc7wF64MA4tY0J1hQI9Oik3mKb
         vXz8GFkJsVeuCpAeZ2P3TUFDVDniCrvmTCbt1IoSggtU8FJleM0F0wh+NgyO6Ass8fJx
         LAh5tmBO3QpxtQPor5vIVA6QzYwsP8YB/Vfe1Yy8DnTHDqqUmFSpnJIYM4oFG0Ou+3s1
         hNCQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPkjgYZSCEs9c8E3ggvDmAyIFp6tw18+4g49h/83ITg7FddZc5HKr43a9sCMwFZQr1Yqya8AgS0g==@kvack.org
X-Gm-Message-State: AOJu0YzK4s+9bSOUPMVmaJcULnR8FnLBVgik3VEk9o5acySzbZSGrcbe
	VDIOzsffd06dADLXBE9MGM2Ta86KJPAjzje6gBzOV9WvXa+2THZCDdIb8EC9jeYftA==
X-Gm-Gg: AR+sD12S939rf+SnWxeAm08XZ7JypZsCGtagS+FBiQhNj6WNroRY8h/wYVqbtA53672
	H1kNHXURCBPqzCSH191iwtNvfJ7wNwUc6TYLSc4igUP7Z4b1Od6DAfs8j71M4ipbZ/aYd0MW64d
	s7X+hHF2kzL+WanLayeUoOJr2ZyaExMKnJwrWbBBczQiKlE2E/CHL8SXA05sJNEXp2FIRCV7O6F
	A2+QpCiKr3Seap8B3HEbyN5tOnvgj68LpMrh6QLzNiGDPHWbKrEegYNDL07yyUUueKluh0pr/B3
	vp2b0fNb3n9DJessI7VSMmYVqj/Rc3CmcUHvV/jT6/n+pXDK2JrtrPIl2z+46FuHgpqLfgv45tm
	ilTi6YzgG9Kw5pLgc/HxnjfAMiim/k2IbFKCcGubX2Huaj7NISq5cSaNCwJhjdyaOeg68n+6vEQ
	txrnqfF4pQjuQFEnq7NOoT5b/GODoSLlsTyGmpFnaeA6WvUtR0ShYcCqV9LdOzzTgpE3E4srRiU
	htkQ6Tf98hp1wWYOccWnaRQNT0Q6+2UDUXKS1pTpEx3xLnL7GchkBIPPCbBSUgmoScm6Ewm6+kp
	GhZ0tzH08Vl1lERiNA==
X-Received: by 2002:a17:902:d081:b0:2d1:1d3d:97c3 with SMTP id d9443c01a7336-2d31088e36bmr1036735ad.13.1786388263842;
        Mon, 10 Aug 2026 11:57:43 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d4050827sm647419a91.2.2026.08.10.11.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:57:43 -0700 (PDT)
Date: Mon, 10 Aug 2026 18:57:38 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anofIoz-0V1imXKk@google.com>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-3-surenb@google.com>
 <anoZL76y3WGXMArB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anoZL76y3WGXMArB@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72E2AA0003
X-Rspam-User: 
X-Stat-Signature: k1cgpfmh1fypeddr8n5mgs7oipuobk15
X-HE-Tag: 1786388265-485262
X-HE-Meta: U2FsdGVkX1//KesEP1S4xydlNoGT+ILzb8KMB8b+sL6Uy4io9v0mlHTvz+gLx02DhKQ0p53Y4GwuIE5S8e7tTbOMMi9MaqFuJ+8VzDhB8dFlwep5+PwyQvvgJCHMGGrIOJAYI1SpaDQMVALvqRUHzOXouCfKf655EC2zZB3QF2eS73YN2MLicR05GTrdkjQNXBlASNTRAiJQ9m8GRrvg9qvI1jf1VsLsFb8j0b2LXKjWXQiTNCeeOXnB7ohc6vZWUAFskU3d4ihposN3YlsW1c7rfY4TKqZ2dUhGaJ43AvmQ6l6YTDSNfm3N0p+/J646MqQ/4QkVxMp++W3Tz9qRGtSOiLdzem+5SXOo/WEFM4Q7uBvGDqPwEp4moz4jZsrqGG+yJvwc4n09MPK31nF31ZYDPEZTfiKPqVP/pE4UCFJZ7/eofBi0meNC3lv/LChjXOLYb/YRgpMhPiVKR07+GwpvC/RZqpTlOb1mgdinEnkNtmIGN6Jpuhazipy+hbZYRkxkTXW44nAWq/PMmC0mU2ugSGvMd/9NvoQMGOtUVkWAYBC2Gt+XLL1Ut47xhAae0httjmnUcCFM6taMmz+O9OtkfGLEafpGWgZFg/XXnhKD+c0eV3V7EeQ1eV92dmvWCaeCR58wyBl2vPptHwJl1/72T59pMdh/7m6FeZZoHELqKF8lB/OrAT+bOKRc9HogbkkQRMhBRDMZ8+nHmAQlpKojUrWWwp2h4d5wKcQ/VOQ0DDvlG89aquGQ5zsaLjN+04QROrs1TAV1nu+t0ZurGYK7FoTJKNIRb0HEpiQt+FKt7rIhpTEArlYk/JY6FKRjDVb0KWuvh2eCpUY1weddfAlfnXD+rFN8UKjc53a8vu//aO6alTKpR1YvqL5Ptv3cE9ie4epWtJwM9bLvpDhiFNuTjG9ZsDzQWlNUnxIr7P9Mj7JcJZIn0dakIw6LBnGQhu/g4WQ3i2EpmkB3YGm
 xpI95D8v
 EzrAsg0h68oHgLAzs4/jMcaYVoDhAk9EkgIk4pdDkQq4t/ouiM/KtbE4u9SJpb+6lZ9It2WS+S11eX9eeuOswWu1rHntnvml/gID9bnrsu7gMgk+r4CQ5sYwX2dJJdh1k6zIpG64K+OvUZm4NXl69cMINeyDYB0c2EYsLLIwJIWO4y2DLN3rYC5f67k43fB4aFSXzzvtMpq/7QFmeuv3qUnD63iRPU1ak+/dwjHhXg6UygvsVSs34tVyLQJgK/Rl9TTEN/WOyGGIcFlcIWjAd1CGiDFwUndT3ee4Y56KnJUgqy56bJTY0ojMFkEAELHaljidGT7U6JN8DQPLgyTvFLZUy0KtnjC9M53CQtcIgSokSOauMHD5FwXsfhIjqLKjiS8vm86AF2i26IDwjEQ5l2c8OIKrG0jZe9ea9FHIwDpefctrvKE3/BC7HzIUZKD94axshF7ottt+gKWtwKGGpG2KjWYoMNx/WvP3lqhl4iGOyGPyqvN5DF7D1zaN13W2sMvjQK5L85ubZkkzq/H3zQxSGZep/Iiwfj5bote09sZ3UTer4lSwxZGa97n1++3c+kXzfB6z0tZoO8F/XFFLYTz4DmE1kFerJlFkxrMFUQkanBLbmXXsV+rxwO24dTiccTW0TXuK14fw6SkI2H5n28iuL2KhOeB/93Zq2pZaj20FJlsMI9s6kxpU9GGWN4kWU+ZoXkyvZUrYXFe88tKNtANLwMi3OHUNXZRNYW2fEKgyG3/G/w5m1ucSiH2PzZ99Fpr0ar6hAKAcN3qrlEvZM9MWDNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 06:32:15PM +0000, Carlos Llamas wrote:
> On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > it and mmap_read_trylock().
> > 
> > Long Version:
> > 
> > == Background ==
> > 
> > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > support for the per-VMA lock, but left mmap_read_trylock() as a
> > fallback.
> > 
> > This was presumably because the per-VMA locking can fail for several
> > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > to mmap_read_trylock().
> > 
> > == Problem ==
> > 
> > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > essentially already a non-blocking trylock. The main reason it fails
> > is also the reason mmap_read_trylock() fails: something is holding
> > mmap_write_lock().
> > 
> > The only remedy for a collision with mmap_write_lock() is to wait,
> > which this code can not do. So the "fallback" after
> > lock_vma_under_rcu() failure is not really a fallback: it is really
> > likely to just be retrying in vain. That retry in an of itself isn't
> > horrible. But it adds complexity.
> > 
> > == Solution ==
> > 
> > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > will not persistently fail. Rely on it alone and simplify the code.
> > The removal of the fallback does not affect NOMMU case because binder
> > driver depends on CONFIG_MMU.
> > 
> > Full disclosure: I originally tried to do this with
> > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > trylock semantics. Claude caught this in a review and suggested the
> > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > I guess.
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hjønnevåg <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---

FWIW, I think we should just simply do the following:

---
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index e4488ad86a65..b0b618c1d1da 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	struct vm_area_struct *vma;
 	struct page *page_to_free;
 	unsigned long page_addr;
-	int mm_locked = 0;
 	size_t index;
 
 	if (!mmget_not_zero(mm))
@@ -1153,13 +1152,8 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
 	/* attempt per-vma lock first */
 	vma = lock_vma_under_rcu(mm, page_addr);
-	if (!vma) {
-		/* fall back to mmap_lock */
-		if (!mmap_read_trylock(mm))
-			goto err_mmap_read_lock_failed;
-		mm_locked = 1;
-		vma = vma_lookup(mm, page_addr);
-	}
+	if (!vma)
+		goto err_vma_lock_failed;
 
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;
@@ -1191,10 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	}
 
 	mutex_unlock(&alloc->mutex);
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 	mmput_async(mm);
 	binder_free_page(page_to_free);
 
@@ -1203,11 +1194,8 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 err_invalid_vma:
 	mutex_unlock(&alloc->mutex);
 err_get_alloc_mutex_failed:
-	if (mm_locked)
-		mmap_read_unlock(mm);
-	else
-		vma_end_read(vma);
-err_mmap_read_lock_failed:
+	vma_end_read(vma);
+err_vma_lock_failed:
 	mmput_async(mm);
 err_mmget:
 	return LRU_SKIP;

