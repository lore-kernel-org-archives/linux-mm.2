Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B156DCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8BD8E0019; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680A48E0018; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356F98E0018; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD0C8E0018
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D60091DF560
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:54 +0000 (UTC)
X-FDA: 83891595228.10.17D662E
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF94680009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KL+s+rf0;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPM/RQw3qfB6SHnbP6cmmYEVv3tF2K8hF5e6CKHShmM=;
	b=JAPKxvNIp2XBa8ww1jxI23ifcNmHRrYbWuAZKkTcx94LNinMnCq2wLl+57ZUgjOOHoWqhQ
	PiCzviLA/jndU7ZHp4qzD9hPLAJPkd2qWFCTHQTvcTN2AmKTWvGzuE523kPrn3mYpxtcL5
	CiC6hYrhlRYgjsRfjweMj6X7q0/VibE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943653; a=rsa-sha256;
	cv=none;
	b=ughetRIR394D2wJ8EaZJQdlU1JOBDtDAqOL054pBe5aWaRQvMvj56FBfwh3Y73Ip9ddXEk
	/Mm0CzT16k9shdk0ojVIql7BZAUKRMMFlZedWk1Bx7ih67EXroIvpWuD1aqd0x/Sff80Du
	L2I0RwwD0Z0BAG9NUQZz1zZHjKoIxRs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KL+s+rf0;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55f6017004dso4283660e87.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943651; x=1758548451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPM/RQw3qfB6SHnbP6cmmYEVv3tF2K8hF5e6CKHShmM=;
        b=KL+s+rf09FeVUSe7OwxCXW8bvIvaWomYtdbWtnUzrt7w2hA+zm/LMtoYo0EjSE1f+e
         72kpWfyvtFnnAEAllX93Nc/KFqtfeat83yaVRX2tkQqsVpNZEhaGqgPfYJCD/tRrFnw5
         KFKttcU49Grz1bGOfptP1ArbhzsMDPPYP59JkaXg2shXiIpEKKkUsZ7H7+q6VSRlvUJU
         hHTQi9AeJBA+JKIGo5up0EDNIza85B7BzHpNuV+LpRqzWRhOK0OZN1t3xXA+ir1kvWIO
         lDwIcBsBzfHMrh/9AGz0ADAtzBxNf95clgZ+YmhPzmgrb9EvBg2pSZnmO11JT/WqftR0
         bqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943651; x=1758548451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPM/RQw3qfB6SHnbP6cmmYEVv3tF2K8hF5e6CKHShmM=;
        b=ApT6WLAfxc6uhL7/c9keARao9a/zBx3NRMfV8GgIUhqbZ2Yw1kKdrX0YwjyKOTy3tT
         zIcVDj3nIazTwWbe3C82a0EGkzl9pmP1F19mBHA3Fgc5I1e5Bw8f/q2oKhTeSUX4A9f/
         mQ3ZoN1Ol+mJh4fKy4Zgi2ZnCKI70sjCdf/OySpEIo0OUEb0a1TeoFpfgRS3f36g2Ljt
         Cy3+CT9JnyCKjtKalKxjXdmbSJKvPLMC9ZC7yDKfYl4Q9IlAEGtcSBOGQMAjTkPf4o8Z
         EEJiWCvBJE/L40tfRfn9AKgm18ivbDDvKbLSEjnlxjoDmqXxmycllPhJZEtBGVdST7z2
         nM+Q==
X-Gm-Message-State: AOJu0YyaBXxwVG+sY+jDwvS8dDer/7FysPBY6KTTHzpT2jR8/lom9KqK
	ZDX8/jFFIrvMRgbnmjLPTTgamvwhqvDhR0r0vuNWHKjChlWLZJbvjEFlv23E1A==
X-Gm-Gg: ASbGncuB25N1ckiIYS+SMmdW8FFXRmdsaMNVKEpvuc+k/5p+xWDiBDi/1imIrslpQsw
	UtzXEuA1ZOJJZq8xosr1//bot/xBICIlWpwmwtL3xlOjyPP37ix+a1s935VFwbOotQ/AE9FEnti
	xWcEQGNVwkO+Ze8DoCFDS5PmfWcmtuGL4Al6i2IW6v7TM2SnQwkuOmCnb58wv1WCl0a1hQkp+Hp
	wYxrLFDhLWYC78ach3aQ1uzUl4cgeB/E00D39oLv7dFqlLbE8CUEd1lDP7de+kcA1g+zftTsj8V
	F6yjLOJHpx4gc4SnRNFxNVhs16mt3YDKQ6g+m0javbnjsLJSANyyJ20KMq5TAXoyAD7iDPef8ZN
	2vVtHnKVYBQmuvTbW5oDdVJaBeJY=
X-Google-Smtp-Source: AGHT+IHWeAiSGD+Y8L07HJ5oJgNmCTN7ELdgooFHDZo/26SY4EvrD6cS7mv9RdmLYMUc1s119miMrg==
X-Received: by 2002:a05:6512:3c9e:b0:55f:6f1b:24f3 with SMTP id 2adb3069b0e04-57049f1a38bmr3720025e87.15.1757943651044;
        Mon, 15 Sep 2025 06:40:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:50 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 09/10] mm: Skip might_alloc() warnings when PF_MEMALLOC is set
Date: Mon, 15 Sep 2025 15:40:39 +0200
Message-ID: <20250915134041.151462-10-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF94680009
X-Stat-Signature: fdmrx67ias656r7sg8fibi3poer3q1c6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757943652-84603
X-HE-Meta: U2FsdGVkX18R8z7YWfqwUYYFBCvxVwH50dCHZ/19tvRPt8BN4IDa+JAJRx1k+TXSGHKgYe1Lr0EUdxv/ngU/gIK4rYpQayIqptgydQMkdlPluVgKwfvCJHUSHf+OVnl1v8ySOjpdSdfkzTycYzS0KnFQpZr8nDsb+6g9u/8F4uqLx4Ux/L9rrz6KvCpQGRemUWRGQi39tSTMDmf58+1gLBaUDxYYdiJyxW2htAvIyV7dbnEFReoZxB8CDBJqvh9dsbHW6eD1s4QZgXhtaY6uHXQ9hfR1AWFYQ5+44X167fKm5Q3pqjyhXJQjzmaaX9zIJy3DF8IgLgKeZbZ9YIH4d6mh78bRfS5ZOSeYKRr5uoqExDIb9vv+6uTJCw8AYEkywwgzO+gqYQJIMlfT4b12YyEW7VlIg7kpKzeVgrx0mCo2ZqXLVyP707vaKtfQbWLR5smUr0idws1e2nDR0oeFplXmv3pSaphLIEjymeHaN9Aj+fSLFv0bcYmOEX5RmaHC9jP09tcPBAyHGvp5ZFZDxGVxf3SNez4ayPoWakUWC2XrmvkBYp767HMl4BQERKSsdemYxqihufPxnrxC/JYvVyjyIJQampgXKFEF8LubMzzeH63So7sLzsi+rnKd7rcly3GGBNGNr67hnDvqYOmKHI0GflqCtz/6l2/VRTWBILXJqAmBGmmLicFK+bv/z4l1vLnLM20LnNwC1vmTEZUnQKdNuTdkuRnFlCbUdgK7zUkyO6MYLjTmHQvp/jycuYTEq5P1RRKnFBQgBJdvJUre7fvukhBJ5cvOAMo9seIplna07ZHuYLN7SvD6sI5LSwF3oPUhvlPuS41yxIgqcSf573y5hP3hv17RoMdpvws++j7q/Hz3X2O1eetRFFPCIclO1slY+6PUH84nSly4c+gT1lK08z/yECWvXG9uloi7zqUBDwzsg24QKcJJDj16SpsjmVLxYEFxDuugQYcZBy/
 cuYBJPXF
 0JP3DryT0vnn8hSjxmY/bSpYiH86hEOVsoYyzNT8MeXK+9x8h8xgoQ316DgWf9k4Y1tLUaGDuFaneaDRXFDbtwGJFVw1DIk4VXr+hH1YWZ0gVlGRoPjWw8AWmdPQrkn9RSoUVyT37AwixB6CLhoLEQHny58wMlt4rAzd9inRMC+kbcYe7a2c2EgXB3j57viWNCyddD2TTqMzdbYKgWY+E5/aWlKcKCKTsbnpKWK5DsmjLc5XN9ZqXaIh1ELYO6cFkz+MPhibercaXAtutkdjHmGpW/2ug70x0uu7ao6pVYxidNbbX1w5r6G5YFIVfE28BnCD8PV8uC2o7g/nbW4sbB0je1WKeYHCz9FBs2yAoglFgpYXcZ8MyvbCo+xfiwRVBJRsgX0MjogbRndGCjOhOKmLRDhwR51rAaBJiNAiUXCPW7yt3g9q5GML2mofmggrZeXC6c52zS6QpcCDCybfAvso2t5Idk5eaZLc8YBafxm28OXWE0XcPo4mjGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

might_alloc() catches invalid blocking allocations in contexts
where sleeping is not allowed.

However when PF_MEMALLOC is set, the page allocator already skips
reclaim and other blocking paths. In such cases, a blocking gfp_mask
does not actually lead to blocking, so triggering might_alloc() splats
is misleading.

Adjust might_alloc() to skip warnings when the current task has
PF_MEMALLOC set, matching the allocator's actual blocking behaviour.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/sched/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 2201da0afecc..dc2d3cab32ef 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -318,7 +318,8 @@ static inline void might_alloc(gfp_t gfp_mask)
 	fs_reclaim_acquire(gfp_mask);
 	fs_reclaim_release(gfp_mask);
 
-	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask) &&
+		!(current->flags & PF_MEMALLOC));
 }
 
 /**
-- 
2.47.3


