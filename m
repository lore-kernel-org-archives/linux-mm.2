Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26299C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C13A6B009E; Tue,  8 Sep 2026 09:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972F66B009F; Tue,  8 Sep 2026 09:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839CA6B00A0; Tue,  8 Sep 2026 09:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC2B6B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3F0D80689
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:02 +0000 (UTC)
X-FDA: 85190637924.21.8FBCF71
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1EB8140008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OStIy4si;
	spf=pass (imf17.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpzGXcywvBcmoPFLpe0sjmmkxn8qreN3FEfttSNZISw=;
	b=j7kWk5dyu2KV708hJmFsSyZMGIgl8M8wi/JPdQxIKtNDpiZ4xE5T1+wX5Ji2WOnRgrFEmw
	A12oeLzd1KfYTyCX+2aAPXTnZkxNMJyHiJ16RQYJJbg6oUS8vMlb9/XoQAmxX2OFiGqSW4
	HNLWwul4aRPZwDCCWNPs+2t5r9ldS1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873241;
	b=Ih/56MZDOL4Ip/QksVDCtv2BVhQm6+yhNnkCw/2qbyxOMTnQXXNo6rmzlj/m92FtJxBWUW
	fp7bFF+eNhpvZ3VVCF9Sa0D7dgkXwFpBs3sa7X0YqRi9UAwxZGKNPTPXAHI1VLM6ucP2eZ
	3NPHk8WrNqT6mJIvUWIjoOb6e5FiKQo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OStIy4si;
	spf=pass (imf17.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso618542866b.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873240; x=1789478040; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qpzGXcywvBcmoPFLpe0sjmmkxn8qreN3FEfttSNZISw=;
        b=OStIy4sidJJ4g2WK0I23VrBh1oJHDchILRW86sxBTUWKFinJpRTpxnS+Rw5CfrD5On
         ka4qv1JbKwmXL5kAfdASQl06riuG4P5zHxr6IRsHUJ+NXJEv+pVtAsF13TixkxI43heS
         8VBagE9MX1gozohwsJW1n65eOPRKj+U6PouBez+OKTf8DIwDQMennslxouLWZF7+wjg5
         4Ywfyb7F4Q+ehS/Yc5rvZJfAvkTGHgPjiHR4bWQmmrzfWgYzdkzBWTYEeiBSMz3e12UJ
         CyNFXxx3Nhx3yuNTWfEDlsYt1JRRQp8TXBiFsNYMwXkk2E93lgZ49MMqvl+NqLH9bVBa
         +51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873240; x=1789478040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qpzGXcywvBcmoPFLpe0sjmmkxn8qreN3FEfttSNZISw=;
        b=kILozuFGLhL5BiacTN5htNEffCud6cnbCDsoKVddMBoGCi0z4WVo39t87W+ePayleX
         6MmrM0g6LY4MfLeJTHXF5r23fE4q0Cl4Pr5Mi1cst89dR4/Fy8eC0iOoIxLC8TM+kIjQ
         mKYUDb2itsAUujHkBcylvDUePlGy4ngecDjoAhkecSljRMcN7ZWWd/nabtiMxIVHywtR
         AHQEmx/pBtUNqSI79zPmTQpUT1d/29j2thaKPniv5QbOa00q7ibccIMgCzcMizkz7LvL
         Xq9ItA8rwl7sTC/4oh4HSTnNJiQxO8ax+GNNpy2OYm0tH1JR7fS8py7QiqazggfNVmjn
         3+XA==
X-Gm-Message-State: AFuF++l0j++XEiWnnK9nPjNCHfe4hmZPwOhuWTA1YxIEWZc8ciCI48BC
	NI9cVVEsnUxN002Nl3uIS8PMevUHMU3ozHpvBa68Zc8iqIC9hUtrgkEWO5/PjHJu
X-Gm-Gg: AYBFou2z9T3jxW5udwTHWRwjxM8DS6AM2i3slixHk8yNImHXm2XH+wou/PcJ+SHWUc6
	mq3RGkrqJaBPS9XNLPPcEurEFpsnuelMGeoMeSPj5jcwMsYTP8pPhuoA12PgX8SjspBVoCglWUT
	stqMGd4CH28i+byunlJx2Vbr9gaEAy9Q/kyrgAq8ApQRcB20DFunZtIDtSLSnFkBPlBQdtxQNsr
	vRXVs0lUOSnu6rFZ4XyfiWN2CGaGDMHAKoOjab+pBkl6pRegjMozZStftAZrYP2WnXGh8ifzl25
	WTO5wdl96tFOEQyhPpKUsSP0H2JWq2BO4WxQsjg5Ap2lfXQwe/rDZj80pQPRA3a3F874OWmgWsr
	UI5TiARQlUTyLpbI7dQuIDNtHE0+8/S/dS6cINllBqklqQO6PWSq0VB4NvN8lj5opIkRkcbdaOD
	bbF7IR4STRRGLt8EPp2FAn13xTsH00EXS8ElXbmHqJyHtTiL3oRA==
X-Received: by 2002:a17:906:c116:b0:c26:19de:9add with SMTP id a640c23a62f3a-c2619dea99emr1021645266b.28.1788873239627;
        Tue, 08 Sep 2026 06:13:59 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:59 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:40 +0100
Subject: [PATCH RFC v2 07/11] drm/locking: preserve deadlock diagnostics
 for trie-backed stacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-7-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EB8140008
X-Stat-Signature: jerprehzzqsrszatjicehcrjig3hs6wk
X-Rspam-User: 
X-HE-Tag: 1788873240-176286
X-HE-Meta: U2FsdGVkX18Lje+3VKJIU6OIZaDahrgiPkq7UvwJ4s2eB9ALzU9JUQ/28aUmG0akbkicQGEmU6rQ66nZY6+ze1vszmHmTsF7euW3GHz2AOpbnl/rG5ldzr42avRucqrm12GRLecImkJouWeO7tRTLBaRMT+ivvmvPBGCL9n36UbkxPia9GCRsN/aA7A4NVisB3dGkcmVePawsjY83BiQtlrFKOTr0MOWwoOrVt9FYdrapy4nZB/O8VYPzd19KULzo6un0kDfZXctA3PszBu8BZGUguJNM+j3U83b3yKxqjqlbPMlWp39gvTj0KpjJBSkBJLGscdR4qZMl2l57KzJ7nw0oxcVEiK/ItfZEReEfXOE0i7txmqoVA2Qz9bUeImFxPIXn/W8o8LsN9LBsvTLEykqaTK8KauI7jfEQky6tjUgYn/Yn1BDJ3FVbLphgQwV+EbmcrReDlu18gECrjbeD1ZIrnE+O5jBg6AaWaRqrpRR+cQBUcrNGA04Fn4/DilWXuA+Z6Or3CsdeFcXSSHIMBYD6/w8cu9tixri0AWni79xZpV0ljZWAiWL2u+9AJgJHegJzDgRoEiGMqkNJoII1B3YJFdVYB3hSiG9WykQ+W0NCJtUxHCOYZ/T4wVRilD6CgHnYD2qFkbDgye12mZtSaduc1n5hiryMYNwiZdr3cjOg03HnPBsg/l+e14675F2KcBuQF6HVr7Ljmu4fMHCzAvBnVVy1Bj2GDgrlAx1qc1+tlVwmOaSTrLvX+OLShQni5Ojvfe1tjEdVlgcdr5Aur8g22+Im38YqOGUJJ0StMkMCHhCvSl+Ff+H94jcGW49U2dJTk20jdWKmFgXusIaI4mah7hlsctU0lwtcm9B2aobLAEBkX6d+s1m7vWL0/sz1u4YfGrS2YLlKnJFe6Fi8sXYipw7og3AwRPHlaBHu8GLtGjFpgbkqFSSMZS2+7LZmWETpe5e4XYpTOq5R00
 +jENbf51
 xLY2ALBCOk3RC4L6gQAFAUk9dGVB+Ft2hng9pceO0bHCJ6E3VlK94m5E8jkxkllEijrhtcZztU8n3NPTHmTmI63ZKYxjkqWd61fYuXCKpq/5oh5e6m8aJKHv3Uf3+HuYZaG33Ed97N6zWm8HrCnP8yt/N0zC/p/0q6QH1sIVYGQGCjILaihvm6XCk7V6fSmCFRoNWjizDYWPMwpmZVmdtPnqFih76c5CMCQrryJPGTe+iu9OHJ3NxIzxF1j5ziZJFIYxaOKqj18Q8LK2ytO9Nk3ReKe0452zjA9cB5gcqtIWfKviYsemYSu4yUL4IQMNP1aDSLit9JI5+6Qpe1MwGnLEFtsIWRkhhtN9p/J+dVav4fU1rahZ7J83v+T+z1tAFTAVJSj2GhUWC09nxJcypcXeCzgKo0UFIKgtKT3L6OmUSkdyPBbWShZoWylnjycTmv/0sEeVjYfXVwU4lcKvhShe4b6pEw3QqyZCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

When a modeset lock acquisition returns -EDEADLK, DRM saves the call chain
and prints it if the caller later attempts another lock or drops its locks
without first calling drm_modeset_backoff(). This diagnostic currently
fetches the saved stack through stack_depot_fetch().

A later patch allows persistent stack depot saves to return trie-backed
handles, while stack_depot_fetch() remains limited to hash-backed records.
Use stack_depot_snprint() to format either backend. Keep the PAGE_SIZE
buffer and leave the warning text, existing indentation, and backtrace
unchanged.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
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
Git-155)


