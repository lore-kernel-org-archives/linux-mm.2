Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2625CCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 04:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362F36B02F4; Sat,  9 May 2026 00:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313B16B02F5; Sat,  9 May 2026 00:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229EF6B02F6; Sat,  9 May 2026 00:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 121556B02F4
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:12:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91EE01404D0
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:12:02 +0000 (UTC)
X-FDA: 84746558484.14.9FC32BE
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id D27F840004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:12:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lC7o57FC;
	spf=pass (imf12.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778299920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Sp+Q7ee1eENxPzf7LGRQoNX+LKiJXsCWlT3X04kYP94=;
	b=KVOUzDpPSd0ZZLf3Erd9VDiqjYWZeE+9P3un6eyLBGad+cNMqjun8YCFAri7exzLAnCA3A
	U4mFonqltZ5SftSi2NAFWaCJr5Hx1ZjpCFKCkSUJxtv0YhYs35TD7fgY7M2aMlnYlBTKKe
	qAV4UMBoxf1BR8os1kOtud1MpI8M2T8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lC7o57FC;
	spf=pass (imf12.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778299920; a=rsa-sha256;
	cv=none;
	b=ggiToK2mDuGYrorOjXQb6EKScU+gtSV+BbsY+RG9yHPlFhVdZrGUuAlPSuaRVWe2xqWlcg
	hZsFgEGtDXMdKDCMuWnFXhS38L6+fw3ScqwwKvzrw2skRKaFyPlycO0rLi/wfQTl1FZAlX
	8wZE6uP/74p/vaAPCpvCfsEqgbR8HF4=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b9ea536877so17498825ad.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 21:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778299919; x=1778904719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sp+Q7ee1eENxPzf7LGRQoNX+LKiJXsCWlT3X04kYP94=;
        b=lC7o57FCWt4KbC5FNUywjJ3d2AUIpqZ7+6Y3dpmc8Ccaa1O5oUq/3HFWE0u3HeBWDS
         RJD64GBaFQ/VdDAbn0NJSi4weuU3BCqG4UcchyZ2UigrTBH/WqXI0Qi91QINjE4183RJ
         TC2JwnVIqahjvWv2G9hlcK/Eejwx1LuedWUSl/UioCIc2BM7VxKl8VKLWbCKwUy+8Pls
         z8EynrnC3MM+ErdN/Y/a67/dWsQuuUsy8YuYdX4dFO+4xCsfNbVRShi+DJz9glMC6xvX
         0A3JaIkhd7AhsD3q1qajPoI1ygliO7cRI7e9Ykv07W0XByYlx8z0+03PafDuFUnOgW2v
         G40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778299919; x=1778904719;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sp+Q7ee1eENxPzf7LGRQoNX+LKiJXsCWlT3X04kYP94=;
        b=ZA5PzCfcLGWuaMqfMMXB0MewqdIwgLC+MDzcA5TrmWsQLVC8hsGOLbMX6bLiPWAt7n
         Qo6O61UzbdZXUvFJKCyD54xyTiXC2sJXYOdgKT/lsRJvVHFqJRcosAj/7cFJLzDNq4QB
         eH5ZgeJszU0Qv/DrvK93VNtCfg4mdrgVJYMA1fXTyI6K9KiMLCKlMS/MEqLe5cVQj4jE
         pRZcUdfnF2ql35ySANqoZqcdV56AIbeKVsB18EAXmuA5THjPBzvwBhGTqwJk80J7VUmY
         zokm7mEhgyL0PkqooMdDyzsomKnK9QV1XBg2VMlxyTn0/6lxJW6aJ2ULSKcGsTOm7RrB
         UpVw==
X-Forwarded-Encrypted: i=1; AFNElJ841pLWO2V9+TMYphuRJbzyyLakccSMxd2M0rpdFfqtej7fmqDJX4fb/RTR1JLzn2ZuR9gpkI8e1Q==@kvack.org
X-Gm-Message-State: AOJu0YyG0Jl+0+AcKcCOV/D4y0P+BfZesnKNq0h+hBQN8/nxXzTQOgPt
	XcdKq8SMl5H6S1QqIVFwyeghDTkdl4nHXL8l5Rj8M/GQZwKul2/kY3vG
X-Gm-Gg: Acq92OFxymxpeTHSHRlQTQSXqFM0gTl2CdcT3ClaNpd5b7ct08zlIhE9S5ash6fADv8
	KYBwk2lxU5xLf1m1Xnxus6a4Fc7BFAeB7Ing/ggImYgeSeDJ3Az99sFKuZqRMQoAQKmSryuMlJ5
	pfyZ1u0t7qGybQFx9IR0m+V+G2vflCwBtMQP3v9+rdVPSCvYKFhDjCrqdipkvp6Zn0kCyDKG2mt
	zOPEHAJC05pkLJcHZDVr2KD3yvNmF+Cu9+diwu74+ypccxd8SR8kKkHCFK0mRSkt6/QDKA3Zu+H
	hVVhEzBg/Q9TJ3WHmWZui5Ju7pkhIk+6EgzjaenAKcSSrpeQCZvBGFsumHRnlFWcetNQZXFhd6t
	hLHa1WHly8CnyH1Zhz3YNpHTKRnBWWLWLdjAmG7JRcYs1CygpPOwYSlwQHwqsRsN3cfPv6OIF48
	fhz5zjINKlHtqpRDk1LI7+0eGnXMWX3pGc8JjPVke0B4pt5kfwEPPTsIJ+1LXDQ+f7
X-Received: by 2002:a17:903:22ca:b0:2b0:ac1e:9730 with SMTP id d9443c01a7336-2babd4a527fmr87600795ad.14.1778299919456;
        Fri, 08 May 2026 21:11:59 -0700 (PDT)
Received: from localhost.localdomain ([2409:40c1:2143:d26d:e122:a514:932b:de1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e36c65sm38318875ad.40.2026.05.08.21.11.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 21:11:58 -0700 (PDT)
From: Jill Ravaliya <jillravaliya@gmail.com>
To: akpm@linux-foundation.org
Cc: Jill Ravaliya <jillravaliya@gmail.com>,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
Date: Sat,  9 May 2026 09:41:43 +0530
Message-ID: <20260509041149.33932-1-jillravaliya@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 558xh35csg7ypgfimhnjkryzwxj4guod
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D27F840004
X-Rspam-User: 
X-HE-Tag: 1778299920-105357
X-HE-Meta: U2FsdGVkX18gScWEdOU8o0NXvl6NILjieArBnMmQlwOzLoPqtfyTRX5ujDYRVrwAXrQ2Etx18QVR1KijiqyNc6OCLx95dPrEGZLuAIiJK9nteNZqWtXk/03suQ8jzmhXz8Qh8n2v2/Crk6a2wKVtIzCIc0VhfABd8esiVUCssjqJcX38pYw5TsE2aCu64kLhKFxP7Q6hyUZfTHWpcKpW/EK/vB0ALAKLkAlEcbLKa2k/tzoTZaeHcldrPQQ5XkNkSKF3C25niu6xD/RfkrkmcEF8pEtAzUwwsWbFw8UizwcNNKZOBNO+jOpdWrgMzUWHfRN8WWCyl8ATlsYyE5ZWj/yXoxtmSX3vHApEhqneDeAPm1tzDMLaRHXKahfYpamwp4BM9E+phLLoUMayIB/6utOWoWeNU1NsdnAWGdiCOwbz7hwfSCLysGhPfWFl8cv46rT4YXwjX0lWHjpHhkTNlw4bYINJlekv2aJT43Vor43Z7o1SH5mgMFczpJXuzZqULXCEeKkAKfnk/Eog9igRBPyOs2KGaQvO+06spitD7lEw09tpgJelUfYanOOVtecpHuuPma2lsJsBX5aBz17TVI6+KR9uWp/JrBWFEOJS9nXyakefQ8R0jrUaoT4glz9qEBCgNcaGIEUX3MK2bBUut0PZT2ygtjIdnqdgZq0uo7zMmy3o2YtuKIKr1iSDbagd+CviLX1NDl8GfAgGOn756Zw7NldhMsTmERhcZXKlluiwTDpugkAYbxK/si2/wPyU3cCXHKuR6oLri3MJbTYJSIzsfI+XaD8qXTKiNcvcCksHS2I0TMaXK0diwWwwZ0rHvuRlA8nKsAUGoTt9joOmP6YPpRrpZ11yzEScoUuVFKKqLWEmzcQE/k5Y/RK4btygzq+s4zMSbaIySqu6jnM7pwHFdq+TilIUZCksD9yw9e4KPmwbbKoo+IAbVgJudVYi9xB+mhaGW9haa/Keaxb
 VXrWwZDJ
 NvDd/4S3akYUyZz3b3+lCZZxWUaH5MqPvkphCIOe1wY03DjxupPRG/7oFt7GQmQMRBKWWCSjaf6hjG973Z1MI+DTdZMO7/jRkteDwUzgaUQo13RXHbPh8KcpFCMCe+N5e3UCLqmmrzzSk+rnYLtw9mjE5vCb8SZQEJV/IvlRKTYanKX/yV4bnl6nvHibM/OFF7IYrfIfH4q7o6lbF1BlfLnBC/xAt3+83A1vPoHco3BPE1oAjStkrvAhGoesE13kE/EvZTE3QR8ALZegNbVBsIqM0Ms3Jvr0TqEBTOh10bh4pSbtQeYfoJ/y+mUp99+v8EI6PIer15q2X8HrBrm1iOuFI5KxiqDst3FbrXw0nAGRFqttd1c8X/IcnXqv4mM1Jkts94q6xxWz8cp21IiinomFLkoAs22azPGLk3H4O/vgNfSJ3AENnF6UMVmqQEfURTUEcveqdNv9yWfnm4Xn8rG1e5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the pointer to the AI review and for taking
the time to respond.

The review identified several real issues I missed:
- vunmap_range() called with equal start/end when
  PAGE_ALIGN(size) == alloced_size (confirmed by syzbot)
- No handling for huge page allocations
- Missing vm_reset_perms() for VM_FLUSH_RESET_PERMS areas
- Lockless modification of vm->nr_pages races with
  /proc/vmallocinfo readers
- vm->size left unmodified after shrink

Uladzislau pointed me to Shivam Kalra's v12 series which
correctly addresses all of these cases. I am withdrawing
my patches in favor of his work and studying his series
to understand the full complexity of a correct fix.

Jill Ravaliya

