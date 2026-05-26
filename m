Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB05CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EC86B0095; Mon, 25 May 2026 22:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F19C6B0099; Mon, 25 May 2026 22:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B92F6B009B; Mon, 25 May 2026 22:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2F886B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:28:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 840B6C01AF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:06 +0000 (UTC)
X-FDA: 84807986172.05.D345EDD
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE02C80002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=enBGl5pU;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYXZ6C8EqKm0mvgEIiCf843XZTeR4+aUZQZ+oO/GKNg=;
	b=nSvmGoQsmCTAh1QC5/vkq4oBhnRu9kM4EeMUfGXUz08BYzX7yV72DVCwUauVkOCQLRlgkm
	2/KqTZsZgSp7DmlbbaMU19E7QTrVbtK8v9e1X9P6aFkK6o308cQAFbstfPTe8eIonU0qh4
	FJtFPsgyzlSlNGtvk71+tuYYqbE78tA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=enBGl5pU;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762484; a=rsa-sha256;
	cv=none;
	b=ui8zqscaz7GB/oPwjvFI92JK+t3sdbXrNRQM0oTrYC3siKJGXK73P224vZAE2J6yOi7s6a
	pj0ZDajriArCMv2yM86xAnxiV5lkngodRB0Pd/WM9k2hocJ9rvryz+CsET1YmrMY4gXA89
	oJQm3jPLZz0PxT7XCHROS6rk4Cgig6A=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so8364440b3a.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 19:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779762483; x=1780367283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYXZ6C8EqKm0mvgEIiCf843XZTeR4+aUZQZ+oO/GKNg=;
        b=enBGl5pU4v20jCtVfeM/Pb+B8uwW4XnO8/eF0pnlOjwPr9xfwAzxP3+58oh6iN33Gw
         q3g9Tydpt84+qvvUekKLWb2NAztF/5bsxa/0eRgApKNMOOEfo7WoX+ypUG7Dt5pzm+HZ
         J3hM6x9ybSqzzS6zJ0/gJPFF19O38jtvpP5NU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779762483; x=1780367283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CYXZ6C8EqKm0mvgEIiCf843XZTeR4+aUZQZ+oO/GKNg=;
        b=KnPp3bsuMZC8MUNpoasHXBPAaiUfmcuv9nSv7eq8G2902KKToI/BZZXZiCFYAquor+
         WgiNt5c8p0Rpf96zOBLzRJ5MXCZAuk56DXZ0IEK2qZHxGTbFQ2DJz/ut2v3GY6FiHNM5
         AdM2VnE9S+lBq0hW9xraaCid/Ul3wB+nnxkFiRieqcUEQDbDLJAZyRQyKLwEEZIZtukN
         6x19Wydv2wguurxC0FrOeiGDF+/kejnJUlqMzsSHAvVB5vNNCBPrq+ZPSR93N3Bv7krs
         7MR9yr1zenhFeJBoesc9FRhZ9JsigHYYS/twCHfIEEtYzJiqrNAwAqRHPm+RBSTtLZYB
         8gcA==
X-Forwarded-Encrypted: i=1; AFNElJ/aTTVkV5EHh+wvE2Ac/77IE34kTkoKIXksmL57w1WvdxLiIYXeuq7/crFKrRCEOMvQghOZjTmoUw==@kvack.org
X-Gm-Message-State: AOJu0YwFXHWYu/AZo+4Ippn8OvMRd3Ah1ojn8Zjm/dFewgI23ljwsxzZ
	qC5Jt9uOrRwdeSD2b3eW+eFX7bE0ZEqYj4rUmdS0Vxn2beO48wgJxUW1/FYL6axoWA==
X-Gm-Gg: Acq92OFdwL4KG7GxVH4BP1hw8amhV8n0RyUp2uRyEdLeTT8JtWej7Z4dq5wFENxdwmW
	CUSzNhO+kwQdy09BreNY9lT3x8zGoLToKhsymG0TRL+tH6vHeJuWwIXhTWBem1VepILwV0riW+B
	M6WInASGiaulMhq3EI9VqIG9JRUEsYt8gPQ+tF/Ow931DqfW7Iuw7rtwXp4WniQgoiRFxy5hYNs
	rj+XtiXa3ovmy3rEH8KEgiHQ70Z88bfE0mZy5FvHiQbZtNtsgoDUVB95I3BrVrN5yUvcynaeCue
	cTJVfvf0lKD5272xbFMHe/waeuzADGopq92RhTmGoW3Qdm+BWWruqbqZaNb/qrk0BOft39rFBl+
	BB9caB27rKzXbKS6DsYIMrO7YdaHJZdtPpWURJZzAr96dMF4fLngF+gcN551tnElP+DOn3/nXWZ
	A3pEREeRKqb68r3DaNdZw1dxNJGDeSIIT1Gtc3BQzYq293sjIZeIlD/cO3Ms88+z7RJfvUJ7b4E
	fG/hEkrEe3KHw==
X-Received: by 2002:a05:6a00:a228:b0:823:1c5f:1c43 with SMTP id d2e1a72fcca58-8415f37d473mr16926406b3a.36.1779762483514;
        Mon, 25 May 2026 19:28:03 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:890b:1e07:dd0a:52d0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164af0506sm10796944b3a.16.2026.05.25.19.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 19:28:03 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 2/2] zram: clear trailing bytes of compressed writeback pages
Date: Tue, 26 May 2026 11:27:17 +0900
Message-ID: <20260526022754.2377730-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
In-Reply-To: <20260526022754.2377730-1-senozhatsky@chromium.org>
References: <20260526022754.2377730-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rg557cwqochbsn5jw14cx66nmkcp55hq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE02C80002
X-Rspam-User: 
X-HE-Tag: 1779762484-101898
X-HE-Meta: U2FsdGVkX1/lkPYWoBvIYX2JL3qidmINTONXIPY8QulhRfL3m52Si7ZzWoRfR9OYPhwnDVkl9scJqVfQ3GZxNvSgJ3P+zPjBPSGJkEu+3Nf/nKeZr6YZ4wAc2aXjuU9mOkXNtPpFE7oupSys58R+gj1vMYEjsKv8f77H2sWyt7ZSjR86u/4WF7tMs0eZO1VVQniOqh39xJ2aV2ePwhqT3iP+H9xwSTdTYxGQqyBavwnlhUK963n5HHfY2KSwqMGHmun2zNjAHaDf/vfTzaaQjO8LVRcvwgQCzJAdxJFhcCuAG+b4g0+M/A6fATTMlcMCEHyBOLHcsFD7oOQnK7Soy2lHzIwZwdufIxQf+nI/T7Y8q+BU3w+77jvlY1T2ihr+QtWOjPbnTTkdTRS/JRhe/+M4QVw6qgnkpcPTPBjLgd1zWh/1kGL4D+N7RFmeXiMQBuYHJ3T0Va5TRqn6tS+lfB552Vq79oHhQNn7TB1rRHbkpMxksx20+dNBse0ZQxIAIjy4m4dxG0u790CjiJ5XgoiWC9VKSH77nFU/LyF9BqTFVzlYc3B1jUKZ6ENtAr0fsRFvZDb+89Q9fiuUQfJBwTsluW21MRXEKzxGQn5ZDKJcaLUJ9H3EDJZID3XaY7YhAMXqaWeNt1ZTIrjQ5avxkprUZJo+FRYIRv22ZPerXPRw9nGXRl7xnTCV3wDpTebvYjhjNCrqCMZegXVZnxeLZt0YuPHlWEk6RB9zV9P7/arHFcONSED1KnkILAFxqMiv8C8xqYFctk28aJ5gO0gD2OU8/mrhQ7SIoqkcW8UjqQUKtgBdAf6t9Gw+Ttl2TszCegs9sbQ40IZEiy96v3ylF+uwjiffO5DQO71pbDexaFdmem0MhcSzgEVyEK6elZo7+3XrAa4Nc6Gx3NsaZp2UEOyhXFnLi7VPY1NTsQcX+tLfe8/kZFvXYMZ8oCYYRuZWrUWfBq2reJTumnuv/qE
 5Wz6NE4C
 OGBfQtiL/38MSh8ZEjvNH96B/8v1RrNkUCIU2rCOLbP/ihqjJEu7Ic5WPMkgVBt2tO99cIrTd9VyhfTxa25ptr6BKsevIYmG7DU06Yk4nFOs8rYj8Qie9zayQAdOTn0MkD2RRA1UbPuOKdxFNrcb0Nxo9svawwyOrQJnbl/aZIcCrd+M1t9U9tyxmnq7NBhdLzRmvalui3uvTsEitR7c+CjVflmkJnE1WZ0ufu3+/2L3EWXL9jgCKOuwg9fRzCCchVQULXqpWIPxUZh2B1kymlU+v8/Wz+T0BbMDvzSOLXt9ZYNc64QTi2pWtrbNuEW+8U7cIhrI1UrXGXsWxNCdLF1ZYV56zaJY+Fp8Qk/xmvNASwYfdmIB6PCHjFniUcipS2qLUXlaG+haC2+iLzmsaQTR6MyZ+eQfTGIHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compressed writeback is available writtenback pages
contain "garbage" in PAGE_SIZE - obj_size trailing bytes.
That "garbage" is, basically, whatever data that page held
before we got it for writeback.  To get advantage of it an
attacker needs to be able to read from active backing swap
device, which is already catastrophic.  Still, just in case,
zero out those trailing bytes before writeback to a backing
device so that we only store swap-ed out data there.

Fixes: d38fab605c66 ("zram: introduce compressed data writeback")
Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 602abfe23797..7917fc7a2a29 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2134,6 +2134,8 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
+	memzero_page(page, size, PAGE_SIZE - size);
+
 	return 0;
 }
 #endif
-- 
2.54.0.746.g67dd491aae-goog


