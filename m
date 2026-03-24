Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDE4E9A762
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1681F6B0088; Tue, 24 Mar 2026 06:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A176B0089; Tue, 24 Mar 2026 06:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EFE6B008C; Tue, 24 Mar 2026 06:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E53B66B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:30:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C316924A1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:30:38 +0000 (UTC)
X-FDA: 84580587756.29.E66D338
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8EB9C140013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:30:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jTcynRN4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774348236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Oa+u6y8eLEz6vbLwjoYLGwTRtUUIqE6g6T4ZU5Sn/hU=;
	b=dWm+kh1AweIVagw7xA81/JIr9/1ukFbFzy3h4nZ91p2AhMI4OF/9VYjuUqyV9xBKMPm2Uw
	UssZnN4cKUQOEr7EnW4ExIlDfhA069kGRh9qfmHGhvEUtCzbukh9Q5jQ02B0a6v/bkKK9F
	J5TZVRVGAuNe4S2FVzH7iC8JVQ3sqas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774348236; a=rsa-sha256;
	cv=none;
	b=oE0Zm5W/0eVRJIhyUU8XhSHyR+EnZ9FXLTS15IL1E5ZYQGLQuQd3G1BiVA6j4Pd7FQxPor
	cqOAVq+Uwx+BwJg3OlqXNJVW60COaNENv/tvv+4Pm1Jru3w3ed6CakvVIf8TbzmQFIO7Q4
	+RBczLCx+dY9IvDSj6g7xda7AoUOEIM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jTcynRN4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43b3e2c4e48so296866f8f.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774348235; x=1774953035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oa+u6y8eLEz6vbLwjoYLGwTRtUUIqE6g6T4ZU5Sn/hU=;
        b=jTcynRN4E43UA/f6ECQptmr88AEjXDnIJKIcWGM/H3NBHeVlyJPiRhrKBnz7Ch25KM
         fjIM29DisLJXdJ/hx7xzW7xnFAUTHIlJoTwo2nb5+tasqKpAeVt6W0XrORXhhbXDpU6i
         IOaQgkP3PsmWUvelbeiP3pu9SeOlnP3wtlOYf+FZBHNPO00dh3M8zBArVJa7pZkmyUYP
         qYcWIAhdnftZN0Y2ZG4nsiblHCs2nxZQI+2JE9QJWDtQXl0A2T6+Jw5RVZ868DXNOWc2
         WwjkvciQ6c31hF1siWF/ST2RDAIRgcdzNcSaTNODNPx4NVKMPWMuIe0NPW+H2q15zNyQ
         RdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348235; x=1774953035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa+u6y8eLEz6vbLwjoYLGwTRtUUIqE6g6T4ZU5Sn/hU=;
        b=pWt9xKnsEsjJ/R46quoil7HXdN+xESfI0v8olu1nwv0vR7slWiLlXhKn6+zHuryIVK
         9Xkf43AoV665DH/h+pGOaJ2K7h6d5ETlPC7lO8ToTDrOOjq1hWZZ9iej6w2iz3TbZzMo
         bL587ZWNOjcam+HRST/YlAy/K5+BW0ToVlnb1h/vrp22hTHOcRyqbDPjTJerkZs7LQxl
         O+eKG4R5IBZyr7aahhhLJS9BCxKeKNyHykSSZLsVqKq1jnK+mVtGcF8rhCq7sQa6Fbqy
         mbidJg6ZFuMgUrbOwjw4O8FuYhhWHcyGRCUll0ljuU+9HIpalyDMRwse2LJ2ud6OZ2dZ
         diRg==
X-Forwarded-Encrypted: i=1; AJvYcCX5kI96LnzbIZwLIPh+ltalLwdx9bV2njtWbFuXGf9Y+Zw8TkAccfHToBUsXbRzVSSajNfU+uKE4Q==@kvack.org
X-Gm-Message-State: AOJu0YyLD2p3yQc/Ftz9Woni87gbDR7C7B4w99QB7emsPF7JqJeCeMMU
	EV+/k/W5aLPITlDRcxecxO75GO7LvSIakJl4n52+sgSgTVF9MSytasOb
X-Gm-Gg: ATEYQzwv/Lb7Ws6gpEavtbTda78Vnswyu97+1FOKN0gs4VsnVz+Q5h7NHo783JNIhlW
	hIbWl8oTFzc89hjWKBVKwaFrsIIw7MoU/yrzAIsksj+NwI5qNXoCMwpXGnzJMNmHX5PMtVDH1eN
	y/NN7FbSwx7UeecciPDYNotDsd9sJCcxROgTYJ7BZbmeJ6SmNkuJQvSMY6kXYXEQHHeSHGHzPPP
	Vt0Kj5oCdCNTAS6XOcFVBjmKL/dTCIva5aaQT/CUejt5OUTqOmb9bLcaz9VScEDuA6KP8Zy+S1a
	4ZQdF42p/f3NN3G++WZW5x0IMHBdy5PU8C0+3hGzbSNp477+MSp10QUK1UKDEX9ehkqQmPqU41E
	TLwc/kFoi52HhSoJrH7LvZTU5qLhb4Vh/LD0d0PvTZWHgY1hEiXxJNnzre7L1lyuQQ93qroBnDJ
	naU9PCS5Bo1acHhCiVJpavPY7BdbYxcx2LgJjYo7YjjdUoMai3OmtYObxYyqjKED8uJGjAB/xVW
	8GIc9S6OVisQfMPJ5V6JF6Sza1VqsqIg5Fu8jvZel191+TcellU
X-Received: by 2002:a5d:59a9:0:b0:43b:4489:d45a with SMTP id ffacd0b85a97d-43b6426f19emr11672052f8f.6.1774348234595;
        Tue, 24 Mar 2026 03:30:34 -0700 (PDT)
Received: from fedora ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae016sm35641412f8f.4.2026.03.24.03.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 03:30:34 -0700 (PDT)
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Subject: [PATCH] mm: mmap: add missing space after comma in vma_expand_up macro
Date: Tue, 24 Mar 2026 14:29:11 +0400
Message-ID: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EB9C140013
X-Stat-Signature: swi3of5fj785innfwynfpixzokj4c1m1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774348236-237975
X-HE-Meta: U2FsdGVkX1/8AjZ8m+65wKgy7MoRsuo+A6cvse0Ha+bL5HXTdqn5+05vzzp7hYb9fclXPgoiOuSCkkPndrPqi9HGyzE2XXQMLRvVUYjwQLo/ryW9STjmU6nBsZnRFFFV8/7BL0FUV8+OY7q/e7CxAn6pblmkuxxgCGia50TiOlzHmkSQV5scoFosbEzdiJN5tG3b6OkIlRMCUJA/4qxa8sgdelHlhETtA8je20WmKy6FddTThonEkaxP7BxgDGtwVyyr7Ohf66M7ll8vdjncBwuLrAEAcL7vgnWvKQVvVYDK4y5jEo2wPByrCQIS0hqRMP/72T84boZvxExb4BijzJ1/X9nUp0AOfKWmux70LV/L1frL4rssh8BHBuvfIMGlSWLjx7JBum20k8/wfNV9IF6r2L4rK4hEh68sSF1wlPlx9fl4TDCiM+RKDgQ/aFdpuWqDr5OtoC60xSxFCtxRa+CuXT68rhOQmAy26ZH5BLp1Q9865wqHunzzizkpKU4vQT7hjPQfdnrdOLC7sENXrGGzEBw19DFtxmQ6G79kE/fERRJ2gFdttCfXP0zQFJEwgcF6nqx9FqlhMZ15rvGxvFEj/OrEgyVAt5xeZjXzulzFNByeoYnUhSaKmeU8mLzEjoC7tVrJ4WIflrWL6qStwJISYZcBowBNwXqDEGGxinfaFGkv1MHlGxiztRqxsH6/55qjf0HAAA1rBr1jU2tTm9BezNvKJt8QOQLGIFZUk6peNDJEOPSsEDSR1sbjzrYVzWQbEJXhjZLbkVCUAMylLsjPdlmYSqCR/DUx77FZIi8R6jchpqf/tXyEKhd4/Zd0dW4tGj4kithseIRdSHi2UszqotKAERW/7N+mTvH8A0oHgCu55qodPy4ciEf6Zjjic7dGeI2QQqZ8DZGewVQzCPdCC+aukMVoXGg/WBkHbl43dH+JOk9KWmkdRtzH30yRdSYBmmKMOO6GSAANLwj
 u18yf3z0
 KbawgUbYtjl66HOZasGt/tp/UoMSZ45qrYLaijvrMnYV73qjMTNfw3MW6CCJJQztTCia58JbKeHR2A9Hkz6fwl29eCq+dubhxw2j2Q82uqB3sxxm6qX+OUCli2GXW1owLrzQHaSQKrE5bZ8BWASC/865yqU7mjoDvFbUYsGXoWHrETVL/1fCHpKtJucYb3AHv+1FJrZeBTHO9JPtY5sEZIJepKZM1GHImj6U7sm4MrwP0pucvCd0+fB3gYZh+IHXkgxN0j6eeOLl3L8lqD+XElhRkVHV2lpbaLIKKjB4i2v/xRHCzWwpsbTYpN7SlQk3MUKAPcXTQcOyuAm5QFrJOUZ08RHozppN0bD+eZdxuifPPQXsq3eH2SXevGoRW4WCyOHPJffHK6Y+u1alg9W3pFod9VUfQUF3IddPoXTOlYr5e8otaDMgf2MEhia0oso6d4jSih5rGeszZvf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix minor style inconsistency in macro parameter list to match
kernel coding style.

No functional change.

Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
---
 mm/mmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 843160946aa5..37414e4ea362 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1001,12 +1001,12 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
 
 #if defined(CONFIG_STACK_GROWSUP)
 
-#define vma_expand_up(vma,addr) expand_upwards(vma, addr)
+#define vma_expand_up(vma, addr) expand_upwards(vma, addr)
 #define vma_expand_down(vma, addr) (-EFAULT)
 
 #else
 
-#define vma_expand_up(vma,addr) (-EFAULT)
+#define vma_expand_up(vma, addr) (-EFAULT)
 #define vma_expand_down(vma, addr) expand_downwards(vma, addr)
 
 #endif
-- 
2.52.0


