Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CDFBC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE4E6B008C; Fri, 28 Aug 2026 15:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF046B0096; Fri, 28 Aug 2026 15:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D5E6B0098; Fri, 28 Aug 2026 15:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06E0D6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:14:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73022C052E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:14:37 +0000 (UTC)
X-FDA: 85151629794.20.E8B36EB
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id A51D2140013
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:14:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fiyx9SHk;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787944475;
	b=U58MwaXUVASff5yIGljyTs/AuFMP9kC+j12lWg/ONKgCd10JcB1hu13Nz+chor5ZrItWi5
	J+m+rYr2Sk17FxiWI5k82e3KxQF9a2ZD1ntc/8Y4gjaNlLszjG6x3zpGg8cXvoYAzA1WHy
	T7J+/VHubSKH8KOiuTzmuHmPadrxO6Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fiyx9SHk;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787944475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jpwie+QQslO3AtQo1vwzAm2YZpOmk97PIG4zVXiE+Dc=;
	b=vzeQCHXJ0BCjBh/g47zGIvVKGONhP4SiAeFlQ4dg6RUL2ezCsZnbVXsL9JvoitWL6SWyDG
	6RJ5lUXX18PeYaYxXf1ViBQdds3SJ7jDo8DIVCH6hv2u/zG6Pg3W9dhLPbpu6ABEnW+S/l
	sjVv/jHAVcnO7cz3TaSq4Bl19Dd8OJY=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-46556b9e02cso1207978fac.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787944474; x=1788549274; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jpwie+QQslO3AtQo1vwzAm2YZpOmk97PIG4zVXiE+Dc=;
        b=Fiyx9SHkMG9OVC3n+kjv53HZkI5AWBsl2rZYpzXHHWMsGKR/37WzR5mxrTNLZv1JDN
         YvntNm+OLnvgWdXEbynWjFlp9iPgAZ+WljXuVoyemVlErh0iQT4nyoB6SFs3wWKfdur+
         q21sBlGsWQDbCkhwZy9m9toni1JZUM+7N6yLIkqrUQA9Cnbn700B7G+ZcvpLzNRnC5T7
         65PibyKdDOqE5JA6585a/1TlZlYXLH/Hvr6NTm8wO9935ra0Wa0GZRsHaG/2Wt7XnqMA
         H7k0ABGLk5GYjUwX7QW587n9Pcb1UXMwYSeTwri0H4OxKBtQWbM7PWTeUGd6RBtlGtKN
         eyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787944474; x=1788549274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jpwie+QQslO3AtQo1vwzAm2YZpOmk97PIG4zVXiE+Dc=;
        b=ZX6nyTMC/odCTIQa/Cxeu6Q+wXGQKgeegWl2Q9G4+0OA7IE+nFpIJLu8rog05wjwlh
         Ydmayg3epZ4J7100rTJyj/4UpPoRXvv+CvNc2nfz+M/1eqVgja1fJh8RBkLOx/qFPWJW
         H3JBmj1map8KMzgLNcfBsHjnxCsWPQ2KBb84/Naozpl0EF+4WcT3/JXESNnAuYdQ1nXg
         d1+w1NaQWNuavcuhYgYO22MlxAWSjnGqJdUs+rPiywdwPFZXk7GmeADrVnpY+eoYA+e8
         mycINfIYlJZHtp35WVdYrVueJfQzmlOIfQXmWU3wIp+Z5wuzPGTE+YgucKdXWcNjcfo9
         /kMQ==
X-Forwarded-Encrypted: i=1; AHgh+RpkINJ1qbPz/oxONRrlLc8ZnZHj0cAleXonUM3ctpCuej2AV+65HFdSat1smrQYrrcDkExVebY96Q==@kvack.org
X-Gm-Message-State: AFuF++l2UQwdFJN1IBe9xk6Ql/eWtxo1nW4noYY8eoYciT2xttpdPqKQ
	P/xIm95NPD6HtkoRgNPfclhQ6AJ/VVhk7QTzA/35qI3M1c8YhhPPJFZS
X-Gm-Gg: AR+sD10r0wLF/TU9+tQxHVd32iU24cPKEQ3dx7bpZXQy1H+eW9u1+RLcjQsRcjKPi8u
	zB6u5fLk4i02OwFHh/ykTo55BEuefgcawGykW32PfFDgJacrZP3YLl1uYGwBgIzPL1b593jnq0u
	aBMfE60M6hzHlnp6bnEEDUqdWB+HZyXAj9nqftau64kgkHkLNVjwnvxXiYitg8jcf0v8T0EyEHB
	7FDGRSZNUvt+v1WR75EUk6wOxriRhrvP+ovm6oYcFyQyGOMI1vIH+WKHARZo7tipWdIY03F7d9v
	KiaPsivIN/PHfAZiXwMKuPjChkoIVbJKCp/TF9SVrbDh+Is7EzoaAo2q+35AGofiaZijwJUCO9q
	41/zuXJurvskC7IaqflBacG6Ifdwp3o+KrNnme6LI987C2Wp1Hi4gPa51nfmHqacLyyBoPMV8/3
	ve1mCjkKp7HKXnHkno11Wpkqd4z8sVr0qW5xhAynQW6EMnCN5JlYchVuj5xuvQwBpb04C+APNFI
	vM/aP3CFQI=
X-Received: by 2002:a05:6820:f00b:b0:6b1:d085:d9a9 with SMTP id 006d021491bc7-6b2fcdd0d6cmr1760722eaf.0.1787944474457;
        Fri, 28 Aug 2026 12:14:34 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1ce359f82sm2363780eaf.14.2026.08.28.12.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 12:14:34 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	joshua.hahnjy@gmail.com,
	gourry@gourry.net,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count
Date: Fri, 28 Aug 2026 12:14:33 -0700
Message-ID: <20260828191433.3304458-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A51D2140013
X-Stat-Signature: u3kjyk8wc66qn55gwk71dqx6183spneq
X-Rspam-User: 
X-HE-Tag: 1787944475-848231
X-HE-Meta: U2FsdGVkX19Ty2KXPoXR+8QgPzcFawvtbHEIo1N8ceZ3+nRDiU+U8pf3erKpAXHEpqjf7yz2qGTzi7rCsqbKzGYUZ8qqzXqkqN/pjMXhM82CqVpxuZlNiDUc6HgilTIOoNdJU9t+2JrJyuDxjP/PTtRogAi30xhQlkpp4HQ9EbrYdVQ/XR4aAhPnCyRFt5SgZPO1c8fVizuiUtCVjaRM118Nh3ve5jYZmKxmG7wZKdTER4BrO3o8ZHgIhDH9bNY1QvKWYsNhHUn5bZhh7jSGQqGmozRJoi51ASPmpHvbEuaj86bUZU/rIQ5A7o6xq7UIez1/9bMqN9i08p7Zv2RPiD5x2/wBmu4QdZVl3WW+784FlDfp6iMsuuEAvS1R7kwvXq+8UCwnsbjp++awAk/JIF+v1zXb7TUpogZCJc8nlqC/Ifadocag3a4Pgyp5MPbNoYNjJNRTMCRsvdhB4NoxsmYpuKCFRoFpPn0O9sbW1uwYTNzmNDafIpadmYxlI3ttWOpRy6LeUJXBawDKVWb0OvHSscZXKSlUMLaJVyQT7tdVz8Zg118/5+mL2KVBNFF4MPjB0T0/j3pwLp+lKz16TTK6Lj1dv/S7dVXAXAg4XGpK257rPjQEo5Y+08F5jSvogDmPBk2DM9WmhFQmskSmloZ/bV94Qolv+PR9THQfKtnXs2UFaJl+dk9NiCIPCPgfDIBMzirPNpAX5OY1OoB657wWOf2eTIlf9fJH9spVBzbDNntZJIU/oyKthvDrDNEarceUeyjIun7dGOKO6kTEkYOoBffXIMp4eXyxRNDaGxOrpYyIGJFlTw6CM8jhSMzmdFt0/GD4qh1/1EnT8ezJrPOP+f7UOYkdM/MW9TGf9KMhb5bzU/uW0uY/nF3h0jISzY0MSCimxLg1Z8vuSjRIM08prW5da7YIuf2i93Ca6TOi5QSLgh5goAlWTKqFWrD5jYc3gJgGFvwxv7uQEKM
 OIaZDhkc
 llIms3cW0iPTk0BCeSe4urZm4FKY4Qoe2APnP8tkrnpt1v47MeG2l8j1KeNDLXORIxE0kEor+BcPWZsMgTc8KmvmqIV1cb8HE5vYB4F467dggAJjs2FetGGI2ZUYWuIDolOAyWVhVEabmS7RkfQMeNXIxEsXt41AcOG7EBXjOCOUijn2NOttMsnx7/2CFXn9b/6LuQ2GXNmQBVjcJQsC9euSlwZCZJW7V4aGVWCAQAJoj8oNuoBA7w+IjHatT92wnndKIaIkb0bp9/951aDUariISOv47lf7xTkrr/79p6/3mVuGg0GhhqQyL9+HP6nG2wzl5ZC/1BVeK4LfaRvQvkbdrsG44ViZvmn7gHnb30v48ttrDk6CW0TtWzZUpTqhLaD7yU3HsKummRKPwC/9p+5vbfl7iJ5CRT2OxJtkn3ob37sHKY2c1IKmSENGQPGUE9UaD2O0dh5EV0Sq58WIfpJDw2G/chP2J46TKkHvMskrIEGl1vhR6RAr8JY6sGmglZ37oIP55YvwRI1Rrk7Pfj5k5Ozw2/Gebvnm4TPw34IC1rtdF15L6sjvCGjEPy9bzMuBY7BeagLSWlajUq+WkjRc89EqWnztJTL1y0g5uFjTau5Awit7/uoIiLi81xIdGULL3IozV/Oeek6m7OwZVM3pYS03EAfyLixyyYLLM31wxmObc9vkjS1LC49gS3tlR9yxizqWA2Rf4fpMM09+hZZrHCbdvBW1/zv8U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SWAP_USAGE_OFFLIST_BIT is embedded in the si->inuse_pages usage counter,
and is meant to sit above any value that counter can reach. However, it
is defined from BITS_PER_TYPE(atomic_t), so it is bit 30. On a system
with 4 KiB pages the flag collides with the usage count once that count
reaches 4 TiB.

swap_usage_in_pages() masks bit 30 out, so whenever the real count has
that bit set, every caller of it reads 4 TiB low:

* /proc/swaps understates Used by 4 TiB.

* A raw count of exactly 2^30 masks to zero, so try_to_unuse() takes its
  "if (!swap_usage_in_pages(si)) goto success;" early exit and swapoff
  tears the device down while pages are still swapped out. Nothing in
  the rest of swapoff aborts the teardown, so those pages are lost.

Independently of swapoff, the collision also corrupts the counter and
the plist. On a device in normal use, a free that leaves bit 30 set in
the count makes swap_usage_sub() see the flag where there is only count,
and call add_to_avail_list(). It clears the bit with
fetch_and(~SWAP_USAGE_OFFLIST_BIT), leaving the stored count 4 TiB below
the real one, and calls plist_add() on a device that is already listed,
tripping the WARN_ON(!plist_node_empty(node)) in plist_add() and linking
the node a second time.

Change the definition of SWAP_USAGE_OFFLIST_BIT to be based on
atomic_long_t instead. Note that the usage counter field itself is of
this same type, so it is still a valid bit.

Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs%40gmail.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53bf01d5f7f1..601979b97f95 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -156,7 +156,7 @@ static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
  * This bit will be set if the device is not on the plist and not
  * usable, will be cleared if the device is on the plist.
  */
-#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
+#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2))
 #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
 static long swap_usage_in_pages(struct swap_info_struct *si)
 {

base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
-- 
2.53.0-Meta


