Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5162C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A58A6B00A3; Thu,  7 Aug 2025 03:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7571F6B00AA; Thu,  7 Aug 2025 03:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DA36B00AC; Thu,  7 Aug 2025 03:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 519B76B00A3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20645BB9B1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:23 +0000 (UTC)
X-FDA: 83749208886.25.3D3C1F9
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 418F8140008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d12g3xXv;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVukRiidJtnbsHfjBQsGQf+AgMjYijGPFu00oV3qGko=;
	b=iT5ZA/HmVXYXNkgGzhQ+xTka107dbiY/AAB+h/XlOzafe0SjPUqXTTOIO+tgkkl+hY8m4l
	8UOHBuS/TWHFywCV4n73ehiooqbFU7mJEHOVBY+RxJXMolF9AKgvsQn6g/Jt3mqb/unyTJ
	Elh1bMrTr+s8O8dZ+/pw6tb/sFk4UgM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d12g3xXv;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553501; a=rsa-sha256;
	cv=none;
	b=j13iWJazNYOodGmjg12Rg/P6JoRiKQKaXy2JzZ5Wr5MLNNEyDeuQ4RGM1DvVrG6y+j17hb
	u+vGsraxhysG6jS2pwqlOzJLzjkHhTBmQ98TVQEMwP1SH9rCSLl4i9s/C3nsoA4IDp80qM
	FgKzsjSoGmRePlIApZBj6I+XfBr7QvA=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55b87e13a85so743476e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553500; x=1755158300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVukRiidJtnbsHfjBQsGQf+AgMjYijGPFu00oV3qGko=;
        b=d12g3xXvVV4O59mhhYNq8xU0JFN6pv3W51HAEe+Of6Z1SZZW1/d7n2r8gFpqAV2ZFT
         qRKL1Of4QHnKh2CBwFqGYr1ay9RI5jbc0KFnBIKNLpCzuv44ltX724HTZHwYKoIzTw7E
         HgTS9NXnLoTk98GZN6eY7ms+n4Eo1zwXbMtNU11LRjPpAXUewhbn2ekhEY5jxPNQI53p
         kUtA2hWJ3KMnJuRZonVodd7naXwW5dapgZG1iQApcwFN/lTGTvi6XkrA6t52Wo0JY8Wi
         CraPXy6z2ZL4urne6dMqJieQbXv97iA8ayWwSH6qTFjDPB7ifdTeQViPEmZKS7+TTRkW
         mF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553500; x=1755158300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVukRiidJtnbsHfjBQsGQf+AgMjYijGPFu00oV3qGko=;
        b=a9qq+//eTcMzRmvUXWHUSe76ZWFTTICBVdxGLJtO/arvs0UlDq0UxrZA/R4/U6pu54
         ssd33xYJVAc3BoAg3yioW1tM0PbyA4gEu8wrgtbKFvh2RSfMO8BeXsKFmcOcN+Gomel4
         itqYZ/XP7pAHvWEsQ2E+FC/NHXme9/bmO4zeasAbyJbOAOR7ftpC9cqMyTvC+wz+ivby
         KJqjN/CrQebNCU3gp4vRS4F8j/RsLWkXei553kwnVEnQrKFonw2SMmc/M0/PdVPn+vRG
         mxL7Buv8tyiQWAt0+6JjGciwYsyY9LUBR5IZw7fkgXSAH74vqHqperBfr6iFfjBMC7ed
         A2bw==
X-Gm-Message-State: AOJu0Yz3WmUDttLCDlKkwXITyYRglloGPF5LXLr6qSpSlTLG2drmDtrR
	msGuqOoSuanpB48ZUElcTkg4UwtPkcw6mO7iCxa05n9YmHGTwOYzvnzbaeCJbA==
X-Gm-Gg: ASbGncu+T/B0gnE9lxzDTpU+qOY0jFL+mgJg3f9mmn26bJsUstL7uCOYtmehruH9mb9
	iRlJkdti0a1t/uQob/3G+CcQpN47UKlZcqxOstCV79jaiRT9D24X5873xLAy7BDka1lkO/gBEuJ
	5Oeo9fby/u6B/PXU6znmbthCPak4qDjs9efMrDFTQx9kxziZxR/CtrkQFWPBPLxi0QDN4CvwjQL
	1lsMOlxZyG6x55dJENVjJ3QjMRZp2iJRrFGJOi1Ae7CCT5tsnyA1nguXkuoBp7ij1tMxNuaKESX
	/GUht/kZ0czYzBgrAFh2WO+rBd7LHi+/XgVxmXha0XvDLeuZy38rsv/yqmCmUHGeVLYVDurfb4r
	0kZHNZXBzzijW6YyOlw==
X-Google-Smtp-Source: AGHT+IHOkzVtTGSJTwNmbg3z+KP8NHPcTU/o7KzFNOnpCVXQwOy0R5xTlB2QHMbSZDCe++0b21e2tg==
X-Received: by 2002:a05:6512:3b07:b0:55a:4c3a:b11e with SMTP id 2adb3069b0e04-55caf5d7b8amr1802321e87.30.1754553499405;
        Thu, 07 Aug 2025 00:58:19 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:18 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 8/8] mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is set
Date: Thu,  7 Aug 2025 09:58:10 +0200
Message-Id: <20250807075810.358714-9-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fjc1n68qt9amxh4s1i3qwdzm4owowa4x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 418F8140008
X-Rspam-User: 
X-HE-Tag: 1754553500-505038
X-HE-Meta: U2FsdGVkX1/piv0smIkP8DRKbzphAVexCd/gMaeIAYLT/Q4cCYLhXQrD3SENPHiTjdfXCvPul9y0MI/pBB0Pvd993TdzVSm04vBOduyFeng/cnUX0Oe1odCIMf/bS+xZsOst2i/3GnzNwQPpDnJIXBUcgBY0/IAJuaPyNZs+NyQ9M37DLbdHr/1BSmdXIAJQ75yYcTOY436ivztyBUTv2+z2h9tglHTcdVQ7LQYNh1g5fRQ5YZBuzAjAij07pfinE/SiyDTQVdT4o39KN0Nn5Dqdf9x90NKZBexJYRuoQEh/nbuhd2EuHzWBP/sC193bBk4LzRQlIBcsEX3aMHZgyndIUaJsE9YkQTe8M+o+1AKf7xnzEk+x28cUgw7TMyL3fWLc/3STws6+cpvNosl9ZrZ5RkgP/Da/Em0xrEDeyo4msxPkABi4hm9m3Eiw3WlQp6RzF0+i5JTQlZM4QW6sl04rZk80JzFR8b8kc9FawiMoUkwrRx+4niU/C4+sr4O8ROkmvjE5VMEa+GdlPgScdvi4lw7YmLYaFxMnxnVuGF1VVFDJ+k7WPKg+P9QYFhxqXLRXMYDJkyNCWLHh4l6hgNjE047aUHcVBu60n4W1JY7tMY0HARa388J/FOBBPNss5oxa++A90ftlxJcmZsgYEYzZP+H9XfnOG07fSrQAbwI2QF+X36AG5uTyOcqSuz0hrWFzX9jziZqIaiO52nnRC31TxzYr2o5rPlrNfqmMar3B1sdkugLu0D6FHX89Fhwf5IqehjKVfzSP/JDmsFRoaphRD1aADQur+dXX/K4v3AjUDPhby37Kk0JJPiwQH14la5mM1DoH4yF9m4klMeyOL5z1eC/GDFSoDSwEvr7nNKsVmyO3RJaQOtNtVq1gQsaFcp3+llS69hSOg7Etr/SZE4HkWGoJ8Gp5aXMg7Lp8cWDe8hL8Z0aBQ7q0uOxS5ZdPnU5xl7n3Dw5HzJWjIZy
 todPk0Yi
 88n6In4D7b8tllDZjMNt9IZzg9WarbSSAWsOQqOki2wwwM0EqWf+rz4cDF/MSx4F24tzj5F5KEuPbkumtMudL9CPBBK2E4+kgl8pXpEEgBNMVfQ7VA2tOrUEiK87CiAWTeKNEZuW9OmHvGNkeR7lMyU5Jw7wW4g6ytkpEbcBqymf2S9daAQYEjDXqz8YYk2SRsT+Mx1Kzprg/NblcKzUGM/A5ephwRPlKUKjmS72mv5mDs59IZD/4rcxpisBG9nRK/QDtxSDeGDRBf0FDIeZ+wOa/z+HqYO6CAr7wl6VlUpZ+6DdwP25Zp3l0pUHDVxJEVzJ9TxqxMp9CAzYE4fGOzpu1DbTXJg0fz7hYoC4hy5rpH1GOGooN2BGuDhS3UrpmjGLr9VEpC+YP3JwRTQlKE4Zj+7J+pTyKxQBTz6W0fVNzxudFcCc9xS31nn343259JOYz9EE4xGi7x9lFj1UtzzdxvMVU6PS7usvFG42E+9hppq+yRKhklW/sbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory allocator already avoids reclaim when PF_MEMALLOC is set.
Clear __GFP_DIRECT_RECLAIM explicitly to suppress might_alloc() warnings
to make more correct behavior.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/sched/mm.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 2201da0afecc..8332fc09f8ac 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -246,12 +246,14 @@ static inline bool in_vfork(struct task_struct *tsk)
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
  * PF_MEMALLOC_PIN  implies !GFP_MOVABLE
+ * PF_MEMALLOC      implies !__GFP_DIRECT_RECLAIM
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
 	unsigned int pflags = READ_ONCE(current->flags);
 
-	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_PIN))) {
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS |
+			PF_MEMALLOC_PIN | PF_MEMALLOC))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -263,6 +265,9 @@ static inline gfp_t current_gfp_context(gfp_t flags)
 
 		if (pflags & PF_MEMALLOC_PIN)
 			flags &= ~__GFP_MOVABLE;
+
+		if (pflags & PF_MEMALLOC)
+			flags &= ~__GFP_DIRECT_RECLAIM;
 	}
 	return flags;
 }
-- 
2.39.5


