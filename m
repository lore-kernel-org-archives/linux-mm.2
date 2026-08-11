Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34312C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9FF6B008A; Mon, 10 Aug 2026 20:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8916F6B008C; Mon, 10 Aug 2026 20:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7B06B0092; Mon, 10 Aug 2026 20:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F8D6B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:34:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C62BF1602F3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:34:54 +0000 (UTC)
X-FDA: 85087118508.17.C0D8AF2
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 120E3100002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:34:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFsn6eiw;
	spf=pass (imf14.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786408493;
	b=ACnEETAaTZk1OoWkjS97URa58A0XB6zWzEvVaMiBsPZbvusnw8xAlP7HXKWnSep6GHIE44
	HJPeUBVb3cocq1tsqi51eCZF6f1cGpaDU8L+GJkCIUg4ifyuYo7DvuD18MdwpcfcodGpuI
	lmtCjReNxj0e3ywjCgUbgE5luCN4GoI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFsn6eiw;
	spf=pass (imf14.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786408493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=URkZ355jHdCeqetheq29n9Ljo1mTGVBq1KKLvNaar8Q=;
	b=2lCDhw+DPcFMqGIOsFq6gZ4OPNV0W7HyT4C7tRQz4zIE3jJaA29ka/rGhNM8VB5sFmfj2/
	o9ZGbfWHPwEUWdP+hiSJor4KXqvIOTQZZhtnHct7C8UShAccXReVlADvJDqRRdU+PtgW8t
	tdKAHV87b3nmaFpTTUTp4ICaur9Waz0=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so3210212a91.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786408492; x=1787013292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=URkZ355jHdCeqetheq29n9Ljo1mTGVBq1KKLvNaar8Q=;
        b=IFsn6eiweN7TLm0EXGBz37BbSB85q2Ml76hsX35qvA6Hyv621RxhPmQavUuRdqA7Ig
         Xvk8Yu4kNblMYWCECDoIAO7dcTppnhF8ZXijf0rEJaw1g9yTGOUOKfDHj/8wchlpTInE
         p4uFctlx7OMiRa6i/XZ/0d5v4XHxHskRyVc9j66TlQe93qBE95+iBOIQ+qCIOM4NRzcW
         bxPmIcp7o/mUA/bJ9OlGzfBp82CUGo8Ogw4JXKYYH0qJorFQXvcW6RGxVXFmVWgh1Osa
         AGzseN71YTn2TTGFguqBV5uTlHJBRp0POqEPizYCFxhCT4SfY4qt2EuMo+iJsYIulL/Z
         04CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786408492; x=1787013292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=URkZ355jHdCeqetheq29n9Ljo1mTGVBq1KKLvNaar8Q=;
        b=kI3b2WdKv9uKIiHccWG4GXi+VDGWNMYUHgL30d/xWtEZizi6qjn3bbMInyGS2qKIRt
         0kPO/tHh0V1mGyTiABXofriEPM0tUonT2lzraJy5sGsbPXoZRzFaWgItsseb+LRiwyU1
         SkCwb+LinLZTLZECc5UTGLnNTw33ANWMXO+jFV49++VJmo13tTZZG0pAWSv4f6Gpy/Wr
         KnRhfuRnVSA5n+LCJIdJIZZiDo7RAzCdvtYX5SMfVwDx9uWd9c3BfzutrNMrwc7lIBeR
         +zh7DFgFtYYlfPfW/brpQn7lInqNxSymJe6EATfDFydXly3SpEioA88osQLEv7Z6jkxp
         B53Q==
X-Forwarded-Encrypted: i=1; AHgh+RpgNhyT5yG+QbZcL+ZYiBhS6r7i53ZCF6i48Uv7QY1UfScaZqhtXHgS/G6IVtIzCNTi2I9v3hmZxg==@kvack.org
X-Gm-Message-State: AOJu0YzJksNjwmdWqNYWGbzrwLQ+IGAjpc7x2Jdrxu7fVvzHpUmcY6Dl
	dtddKCx7QksWjEg/o5bAYtakLY/EAScop3P/q+ix+YEJX4lLrYsvRP7e
X-Gm-Gg: AR+sD11ags+7T/TYdqeYn9U6saQKkto2NoPXT6pcoKcv3EZc7gYZZyVTcGWuhvwx1R5
	UJIG/iQWT5kJiyPSo6PQANRO6CTG2t7wu3zcSbtq+VbMk8L/+fS1pSgSWEVLi6ZUKo40tBLV6c8
	CuWKOcXhpAsEQCsVTJV8NKfVwNlminIQ240mPZFfU0jJcXde1uv9WX1K1OZwcMWGAQbuDEabgcc
	Db6bt8I6LZzhhME9f2cDr1G3hU/TGKsupppRYO8p2F09gjop4BUGrCCAgxRlbbOv0u8xW/TYonQ
	ezCiiTpQaHHZjVU3OxBELSjIe5r+E7skFqlCkfBxmjcmimbh77w/+o/Zt1hxQtXn7QXAZGeYXpa
	WvF/U1icUD0R1UDURwHuXFJ+vY8CcfL4a7bx8kKvUj8uAPH2esR4qHQwZKpbHN6+6gRMeryfbl2
	2RcC5XtR0VjTX6poReWf9QbLjna1a32Y0Sr+pJxBBgGkFOyptDrSYqAxT4wItwRTSd0LK7MgDPe
	3jZL0NdfHU0GZvLIWI9+qsGsupXffuO4yAzVJYcZOtxjzWG224XdzhYLP/q
X-Received: by 2002:a17:90b:17c3:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-392cc9375a4mr5415826a91.4.1786408491724;
        Mon, 10 Aug 2026 17:34:51 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d526c9e1sm1284329a91.17.2026.08.10.17.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 17:34:50 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] mm/cma: fix stray newline in auto-generated CMA area name
Date: Mon, 10 Aug 2026 18:34:41 -0600
Message-ID: <20260811003441.63725-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 120E3100002
X-Stat-Signature: bkqsxi69e6xppsqdo4a79dzr73d56cyb
X-Rspam-User: 
X-HE-Tag: 1786408492-534890
X-HE-Meta: U2FsdGVkX18EnZY6COBC59SQI0tgnzgJc9xn3kDXzff8A/tBvDiysBi7kTUvNgRrB4w6+WhhSN/LasUxSE0aWHew1hawdX68pS7gpGeBSit31mzN6reeC0DkIZLG9w+S/DWYxkTpahst5zIR6WpM9Fnxb8mt1hELRE65y3AfwyF1fEFwepdP4Lvo3ltYYf2mmENitmWNJpHFuNcFlBINfiNudmQh1SZhCO9YI3cdBiPk5rMQ00YRyJkhdELGIPvGsQVgjq+EZLinQFSx7gxjp4j17KuWpSSWYOdHrEV7GI71mLu8Q6OypGIxFQg0a6Rerm6/7Q2jx+Vws+Zi9EyQtIpoc4e6n0v+QQTSWRK1B2GTFkiRQEiq2zHJgPwNTX7FV8b7SlIwk2ieY3u8pfLTr7hfUKVaUKSyE5yOkhyUp+46rcyj6PLHM1elEfIu6BrW5NvaVtNK+BRWiA9shU8cxOHFfSOBKRuHBvC1teqhGRpPfDA1kpP8kQrONwfHD2Y1CHfH3lB3yaeqYtLAQyBvgh9VqqX7+CGKu/wSN3JH+xsCprINQCzqvT4lCMKlRU6P7nAkLB+tRyUXnj1aj4x3keSIJw2ullkFuKg6f12K8v7Lyndlh52t+oiWJTnTSdwuCmM0DiZsPJ18Lb6eLDABZkTjWd9+e3MEunYwBzY1xttmvjSEx2WIg7Wtnjlr7aJbtcJJ3m+QkRNU4vI7vhSBP2roaWidvtMn5EGbbBWAbJc+nhBTHgW5eR/zATLsDHVzHW/vznTaCt01nSDtZAFhnRaEHxnodxMDbWEMxQtu+j9AVMDPoijVk9uhpi/V9nxLJSTaArsi1VpNzfNeRvJYpolGNnd60axBJ7QWYHi9N2Ej7WlgCOHDoN1uJS2H/T2crqAmGdWV5ylF/TcY7MY5/Glit8mLaHCtmcPSK/tnpI+n9Qa8/AJ3q6qc0Y39DAffz0P+5fv/LRGh4zpRaQz
 n2tHT4Gg
 5HpFjiIYkvWrWaCZmsy06CyC9zz9zp2RWREtsRJ2uQCn1xDzRu4xLQnWCeb37RfD9Y4UVAavHFmgM6dhMevbN/q2TZ0XPVJyP/t/p8wY5BpdW/THBlYHzn/fk3K6l8JIaiTAY+cJG5KvG7LfO9WilEss0vr9p2xf8niYY92pvmXicmujdAkFB04Spbg6CF08wSynpOoLZIAPcVJdMJn3ffx+VW7f/c/otZZrlVe7zgbP5afJqn1Z9di/vyGnimqlxLUp3AN1HsybnTeC7fGfJIKZ8uMFo3EdngYM3VWS/OC9FRz5WtOi8Z3KuwQQ1wYMhzb7oggJ2KbRyEmeKlE4bTeo8NzRy3amgn9mmH1ObdZcuFaqW1GwsjscrUkGYuLkGagylsfuQ3+Rndbs8vI2E9Ki5MkzyAywxJw5N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When no explicit name is provided, cma_new_area() falls back to
generating one via snprintf(), but the format string contains an
embedded newline: "cma%d\n". This name is used as-is for the area's
sysfs entry (cma_sysfs.c) and debugfs directory (cma_debug.c), so
every auto-named CMA area ends up with a newline embedded in its
sysfs/debugfs name.

Drop the stray newline and the extra space after the size argument.

Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..092cbb8f27ec 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -240,7 +240,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
 	if (name)
 		strscpy(cma->name, name);
 	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
 
 	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
-- 
2.55.0


