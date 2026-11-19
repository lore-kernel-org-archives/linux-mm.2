Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD29160A380B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sTlx/SvA
Received: by kanga.kvack.org (Postfix)
	id 6AB9C6B0657; Thu, 19 Nov 2026 10:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CA16B068B; Thu, 19 Nov 2026 10:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5726A6B068C; Thu, 19 Nov 2026 10:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9A96B0657
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ECC31A0B62
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:11 +0000 (UTC)
X-FDA: 85452259662.29.1451552
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3AB31A0013
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="sTlx/SvA";
	spf=none (imf19.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102329;
	b=VSOSlV83X0QlrwSay100CWM6opoge8ufhSrtKYdTfMLx29W74t/aXqVwLgof7/rDdAUmTn
	LjHKJwAW4ag7Uzb1Q40IvnPww+z+XSaIKW6oROZviic09GQJT6Z2/bj0gAvF5Ym4Y9uIeU
	6qr1ziPGTmL48hLvhAm4eJTXIx9cwFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
	b=aSLZLW+RwJo0HwIfkIEpmJ1wMuA13vzQ1sfg8HJ51A4XiAPsh+u9Y1mlgL2GfhrtiQ6dRd
	zTAKoRKsDY9br0WJ616A60l0XTOAMQkXi9/Ph0A4c6ozflpnV9QJVFra63EcXircf9snO2
	9eQ0uzARxfDIb51chgety9H/VeISMrQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="sTlx/SvA";
	spf=none (imf19.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.54) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-49d64a88222so674075f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102328; x=1795707128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
        b=sTlx/SvAaTblqvhlDVSfg4MZil+rDY5u7hPZlzZAOT9dwq2t5XikibJSxg7FH7M+Nk
         3f2mVcZ8OssIWtK9vGuH1NPgPMJDHy6R7Ay3WR3mAG+C3RNkzcMpyPCo7UMAat8SSRaS
         S4bpHCC6ZDKn/jQ9fWh9qKfSRt8Nsjl6JcRujkcvBhf3Zu3kwpQloaA9U+Os8J5bmT15
         4eh/O2VZquRMskECa3y9ai1if4W/vfczz6gUfNDgrJWSPrAhDP6Pf+YU8/+L6xOJBZzU
         2AI5IgwjgtBuJJZYBn/sbmWm5uzqTmvDgi58ObGaCWTfaBq3bgoZKe9L1cRReLPEbKJ8
         v0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102328; x=1795707128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
        b=HLlH8B1PiJbIO3krOEhsTUSCydhCPqYV8hJkNo1X8+tBaVZ4/kzKeHndH6PCCEJXHQ
         JaK5P8PaPVTO1dG0QKvcyQvVrgVezjBPtxkuV5kGF204sZfq6Mi19/cRKxxvqpCg9hzR
         9BsZNcK9lVxSt9v4wgW9UCenULJykwRPLWB9B970xM1Vz+9XNQk0zKX2SgFHVDc8PWpW
         9kjtZ/9U713RqNDGD3SPf67j1LYXpmpg0lkhjAyQnaGxXB85U8dBFa+HMxOkY9qC3Ilt
         drlxBY29e36YShD44qMEyb9fPbGR1RLXotEmE457d7HepFebRCwNLnphetS7V5ovcJ0a
         4p9g==
X-Forwarded-Encrypted: i=1; AL+hErFQwP6nqYX7g6iqOyknJAL1J0/OveIeI+wJbkzNFOHw/hxDMjfCJfxQifQ6WzxHxY2y1an/Elr0pg==@kvack.org
X-Gm-Message-State: APuU4Z/n98tXjdmwK0MfRuxSHpNpomjbbix0WO9niffx6OQ+yNYUU1IE
	oZdtWplIprBFWjp3ZL2uiuLHtEWSABCki4F0l8edsjks2CR/LsLAXscy2IdNmET4wp4=
X-Gm-Gg: AZFdTZfgAe4Hhd5UyvVu9Mv1ni5cgEEaBCh3yGtypmhIMQI5lWgQ1TOUrMusQqetxEZ
	9I2aK66gtDcMeEDJ9JJcV5hxYso9E7WR5LtkdkNtrcTmrYjcVK/70YO9QjUMgYIpffe3H0rGKRF
	UOwBvq5avC7XFkJy8lS2hkG/+x3N4QZY+5hddwzERTeQa8pE7zOaKbw0GBY8TQ7W25G3mAiaFdK
	BUZTCQ0WZCl6OGJFJOCwooBgg8crzXvKLRR/pgFnGDISAJ3QrUPnJjd/LzSnt2cbcAXlXkcB8Nb
	xLoFQz501qZi7Lj06cZC1pX0aZ1LaEMDNMlvEovrMqHySRodVg9xkXvSm2y7HcDFKJhCTv8XUxW
	vxnwZtQh76LDxbeTu0t/8vNbAJuXLgwZCiv3VzU2dKYjvx7zSfHlbUjFMeCFrk1L6280JpQXY0R
	Vk/SPinwf4tXFihpSCy4HF3+fcIkt4W0j90U5b0QldsCo7rjLUSNZdcBkrDB10/cmLyOm4aAsLt
	6L1RwGTNwAV26I9j6zh2B+fUBOilCJIgD7DI9BU+AU3Q3UGMefJC0s+5gmx+oEtD6pZ4Kt7web2
	qz5xDlQv7mPMsiWR34gxl4DxcbyUzrM=
X-Received: by 2002:a05:6000:1841:b0:48e:60a7:e0bd with SMTP id ffacd0b85a97d-4aa54114f41mr3885700f8f.17.1795102328375;
        Thu, 19 Nov 2026 07:32:08 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:07 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 05/10] drm/locking: print deadlock backtraces with stack_depot_snprint()
Date: Thu, 19 Nov 2026 15:31:38 +0000
Message-ID: <20261119153143.4099483-6-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3AB31A0013
X-Rspam-User:
X-Stat-Signature: ojzr81reqw9dpm8k99hjxghmffjxkexf
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102329-915350
X-HE-Meta: U2FsdGVkX196VXflQ8499eT1yAOo8Lp3FTUmMMhlcHUUK4XzTAZxE9bADXId987aqwyljbMv6ZQ0l3uyaari+xzQqz57+OM8lmwbXBhodjpvbelGC6y3Bhu4qDz+VAzmycPUjKUQg3qOTOD4X4Vcu1cXfJzQN/KwsLHW/9Ro4lXdQ8gvK7NwQAbruZXdWD6q9MWBKiLbrIwshsNJXjc0kPxaVD50vZyIPj7mgBS6o+hWyUU68vKinEQ7iPi04K22LyZSXQ4w658YSred7AeCjROVYd4+rqiwPEZBlz175sBzoMxS+0Nbk1m64gPcBhQuv3+YfJ0D3VUVCnrgSodO75rTSyO1neGLuVG1JkmNnDGXloj708obIpvWcHQkggTnshanM/J/VAw18c3Ya0v1T40ZJPW6OTF4T632H+ighU0U6W255JW0xODCCsDKdUuFy93gb8ScR47Hxlug2PYUO4m5qNMWkvsMYXSEmeA/gHEB36lB3jmFxRFHMlGQ2HOb3tQl0W6R1k4hoX8cCzGDJf6se3ukKxDNqQQFbhgYweHeHdBaHRa7AUfWSUDqlzez/lYe9lN1+YtQuIHsDAUNedtm/8uhsMGTZPasFCxqnm9QC8zXHmPorDyrEMQ9QdWOHgoMQau3qu7l6MN+D2Fhe3Uw9mDpOgPoYErdMjIe+z0hy9pJfmeaHSEALsn64LNMDoolkint33DNH12ogoZMPOrrhUr2CH8D1vMj3U4GSbjLUyR8XIhy97177KUuKP98HI/LG36d+c1kwd6m5M4uMeSfZKK8iJ4v9gbBZp0nhZAM3WIIugzKLVk/7MmqjSh52qgcQQVLnx5lNOMGqvq9eKEBy6Wjkj5LCoKutzdL0rmV/p4fItLyYdyGMxUqmW22KQqCmaFk29zmJ0Pa2DnlqDgHd6KfmdIufQAIO4NBZsL0wRnbO0pvnSt8DsqtUhVik7zk3OQEVZDcRbz5L5h
 qpwNtIpM
 TKkoRBnW2Nz2iOby3EqQ8uL6/O/MUJheJSmlhGHsV+LqS6oDJwwyAY7l03lgmtfhpI3nlb+Z378izApjKW0QtOg1xm3j3LtszzYudH31R1BWgP+AZZB+VnG+BozEaMRncWpNf+bHEb2G7zuL8FJXl9ionzPYCSRMV27q9T/KdvYyjuHLxEMvsFSpZYwtHslEHvo3/w5piWi683hdOrZeX3s9CTDthwfjF7PZkRGbuVWpn67of5CYfXremLUdLgfXRkodv6uMkMLSYBjQXEGYzsmQwyZQVtpnA+wTYIrTJ5dk8m+gitDYJ2rzblew/F5WhcA6oEu/CKb1ZLsfnK0RziYfe7ZtSeYYuFbP+LhLMUGN+b+4IqG4biMrgiHi+yPIPCxWpN//weYuOGbRq22oH4YmyWReQwQzmRRjeEBw3Bh6JHUlVQpWMDpDKBxdlxvEeXWr3YNrgvss9xJq/r2qkxw59QPS87ksd1RStld+wQaHpa4QktxhSG+vEX5etRsyw5zwClH597JOlSNwtY4A16vJ6eVgq2/Tzm4XJXHIsjgNax30/aJDcgOPAMB+TuyoVAYAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

When a modeset lock acquisition returns -EDEADLK, DRM saves the call chain
and prints it if the caller later attempts another lock or drops its locks
without first calling drm_modeset_backoff(). This diagnostic currently
fetches the saved stack through stack_depot_fetch().

Later patches compress the frames of persistent stack depot records and
remove stack_depot_fetch(), which cannot return a pointer to them.
Use stack_depot_snprint() to format the stack. Keep the PAGE_SIZE
buffer and leave the warning text, existing indentation, and backtrace
unchanged.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index e14814c30d8c..f48b02379b71 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -94,16 +94,13 @@ static noinline depot_stack_handle_t __drm_stack_depot_save(void)
 static void __drm_stack_depot_print(depot_stack_handle_t stack_depot)
 {
 	struct drm_printer p = drm_dbg_printer(NULL, DRM_UT_KMS, "drm_modeset_lock");
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char *buf;
 
 	buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
 	if (!buf)
 		return;
 
-	nr_entries = stack_depot_fetch(stack_depot, &entries);
-	stack_trace_snprint(buf, PAGE_SIZE, entries, nr_entries, 2);
+	stack_depot_snprint(stack_depot, buf, PAGE_SIZE, 2);
 
 	drm_printf(&p, "attempting to lock a contended lock without backoff:\n%s", buf);
 
-- 
2.43.0


