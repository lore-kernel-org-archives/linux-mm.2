Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B40810ED660
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CE16B0095; Fri, 27 Mar 2026 08:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554576B0096; Fri, 27 Mar 2026 08:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491206B0098; Fri, 27 Mar 2026 08:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A2F6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:10:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA82B8D972
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:10:15 +0000 (UTC)
X-FDA: 84591725190.27.C8201FA
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id E41961C000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:10:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQoDcGme;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774613413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5V/1Wbu9XfRyN3Day1/4i0275Wd9nGLuW+cphxmC8E=;
	b=wk2+pyviaT2QvAYD3p82XQ5gci/ype4VXYgYKFLmX/yj9ElLOQOPFtCFtJ7FqQvZxiejhi
	hxt8GOFJqwENX4txkAbq05yXOFo+gTrrKiGyU84Ola/610RCaIoDzceLCcPeU4WbieROeA
	nPZuBEUGnJQzNQ3y+yYoSvbiMHb53Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774613414; a=rsa-sha256;
	cv=none;
	b=Jr/4tthYnVHgis2qK57+5jKVRpfY0dUmNeayfSiY0P9SZCF1NlUkNjhAH+608xZMKjc3Kx
	oFgPe3NdC7C48NPPfRVZLihkKW9MDwzTGNZ6Ywx3j1z9H1a5QJgwNtQyIYEdk9mrQZhsmY
	UmXNAChnQaY8OkrdqES+KwEhGtEOoxQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQoDcGme;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c763c294cccso1413963a12.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774613413; x=1775218213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5V/1Wbu9XfRyN3Day1/4i0275Wd9nGLuW+cphxmC8E=;
        b=eQoDcGmeGSk6XV+DGL8/CKdmps8lK05BbwIlODhYrrXF2b+xxi9jV9zOlDZ/Y8TSeF
         uGE+H+5D6p6hVbAWjtJOlATxPah+Ja9+/Wb66bk5ECoNza8oA0buoWZ7gJvy63WoOXmt
         xPZ5uwPc5uToi8ttPBIdlvdwp7BihUvtLCw7mFVepVobW0wZuU7SSMM0VZ9RgJCY+sK7
         Dd8fmaHTrglg8bSjukzThMqA1miR0qpuSHBT67vYfL2XnbIiCXVWFDFr10Sq4XNfaJwT
         5hXGpJqTBbQRI+cz9Qrm340vK2j5KmG0vIZdxYCtYLFv3571xxoeOIh7Vtr8TF9cJCdW
         RhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774613413; x=1775218213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P5V/1Wbu9XfRyN3Day1/4i0275Wd9nGLuW+cphxmC8E=;
        b=PPzkZ+zTVYkJBUn9ljmYY/u3uM/bcNT00Fx3N/86SetodLr3B+effhxJzQwYUw/9ST
         HOIk5oQ4afjCekePhdfA3Fsnc0v0a8fChAXzwnvQ6Z7ZwGoB/y9A/2QutAVB5AWAZ+Y7
         j0wiJsoLjyARM4eJ5OujptejB5YsfYkIf/7byQMdkQIXsdzdUy+3hXjepVWT9/ionbrW
         /XMgMZB8sikiatZRn2BOBkzAsUK6UPCTC+Lj+yQX7cUg8tc3xBzh756VBcvGpwchqn+D
         O+Hd3nNmBJM7jstS1jEggAn5x0nAHVklNQk5IOGdex9TuTXtxDnu2Wa8/t4sZij5m0+s
         wKxA==
X-Forwarded-Encrypted: i=1; AJvYcCXVnEwD5yinfUlVwYIyF+Sirw1h/RqA0VvtYDWR7RXtizUVgpmAkzKRNxGDNBBfPRHZYlusvjIlIQ==@kvack.org
X-Gm-Message-State: AOJu0YxD8Mg7Ro4ghHvChWx3oxMXxv/VucfH8djtL9ienMkWxBjkaV65
	piGHguriOQ8WHHENqkO73U7Agl53ZiUeImEeJgqihDLQhXR0Oy1l/Gf7
X-Gm-Gg: ATEYQzzRT4T/rsqu6G2GBfVFeOHA9WyNQ5SrhH0hHFiCdWEBD13vSA4X7F3vs4qbdG+
	qurwDVXzEiSgwup0RkPMiFRkAFnu9DEDUcxkzm/op0+PDkL5qkDYuss2HiP/GzOQhsV/tDy7NKU
	p2qWZUSyBItgBdlfEItEqLdlmFkTCmeK2Wy4rR8yY1BmgJxF2tc+8SBN0wY9nNFJdCMos08HFiS
	cxkJJ5gzL0wzUPnifzPWhZlow4P3T1Gnxj2z600+gI4e4G7NObrrsI1kMtBxDb19TLmCvYBOtmT
	0gnPi9eO26w2+GUMXxK8U+YnZ1rgsKpmcQocyfIUH5/gf2p82zn5EuTbkfrrtlD8PLH5ekcO4u4
	f1D8Q+hOd0EuufrikUcJ1kIBbia3qWEDlCqCfm5335FJK+YtjU5PkItTR5uFbAYgXIrgYox/nnB
	pkufAMpSOTYfmo91GCSVbYUP3okqIovxpE/RjnlAjf4Hb2RVVobJ0=
X-Received: by 2002:a17:902:f607:b0:2b0:6829:9414 with SMTP id d9443c01a7336-2b0cdbe9dddmr27888725ad.8.1774613412558;
        Fri, 27 Mar 2026 05:10:12 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc786b7fsm80852155ad.20.2026.03.27.05.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 05:10:12 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 20:10:08 +0800
Message-ID: <20260327121009.38374-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327064517.68131-1-aethernet65535@gmail.com>
References: <20260327064517.68131-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E41961C000E
X-Stat-Signature: m56f56ybrpbs7oq8t1yjwh9wgdzsrmg5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774613413-561985
X-HE-Meta: U2FsdGVkX1/6ZtEqsOfIrX4yM2tDMFQiPNwjfrOS/7gj1FPPgGzRUfMbV88Ow1G8jB33Md498Sm/5eVoZW/A08od9GYXpgdWoHRqJCK6bL/jyx7Q6pm6Gyrdy5XwmmndnH4SULhTLb/6obJ83YXjLIMf/E92UUy82jW8YI5ssTB3djAQbxWXlEu58dkbFZwMXFK4zx5Q6mf8s4SRKDTX+XRchZk5U5YVsUANcwsFUxy6K6uYnMXfYX7geC7yQqM9UHanuTjPCQS2MzEtrug91HscXnWaCYSqQrIuC+LFCWG7OxL6+znaFuJeMQkowmStmU8T8FYbCictjzw9OZzPuDjeTCAHDSeZPghAQliahG8QO/ARmLKgOZlNfdJJzv5zzo62rk2Q+xaZG0XcmvjhCS8O1aOCjmtnKrFGGqlwuqTRB49l/NNuf+92ezP9cFsPZKzmXMOF8n+87tS9ud+visUg5XEUtxDsYiFfwecfEVzvbk0YT2ArgZKeDD2YwBNvksbRJxyqblKkLOE45IlEWboNZX7uwU5EhNdsG+4/Ef6eL0FZqlGhZ3fUzgw2Ik4eEajsC3HucZ8bTeMY79pwFblXACZ59wdFStGPF4SQn3pWxYfQiG9MpUMWY48NKaCpIZPLTVa3LNkWl35XVgmVJgA54m5JHbt4erzvE9QYoylr+Dqpad7ERrP4KIBdjPjVqumbNsoePQDLkJDOo/PColsU3SN3DrMWK0v0Bw8O9YqH38EYwwHPfpGfmBqsNjzEhxChBcHthlTK8mU496IbnmtunwtjynztaZNabh9OnJXhN0urYlu1zJ5v2tHWWygYdQ41EZEpriEzoZvyX7fwi6YWoP+9GddjC8awI4dY6E75iWfxHi5AF4BDWLuILXDGk4WOcFEpWDE8IdMyvETz4OqsV+dLSlgGMPYzAARJLOfJCIk6TxxFa0P+1Ek6zRVt+ITD6eiikBf98aUXSAN
 fO0GsND3
 SjMbV4OMGtq8v9wFQ8ZyEuTIYJh0/AppbacX/bwOdWRpYTZIw6WGSSsKf8pU9CC9KOJmqVAoOpn5IstGM7Sxviej+gmu+9IjCKwuLJ9IShg3lOB4I8VSVvXJpy8JQY1BB7CSPhUI9vcediWQORgsP7DvmsMquW+BOSW80MftYPv8E71QNm6H4iuv7fRgAA6SEtnZ2QSmoHR/3c5jOqTH2uAUg/+mWFK/7kSUBBsssNtc6hVfQ1oRp/xvXk7BJwiKXMas7jDGjuBoOee9zc2EeEKy8H1m8KulDk1ykscFou6eMugcV5rJzm7yb20lsNSeSzIYew84GdCAcQXWIEKqyc0nYoL3Ncy7Zhw0SA+WSn4DGp5a5v2D5sTfW4zfVpSjdZPVY4evS7HathuE8243EKgAOmWJemnNQFuk+ydOWHfyi1kL7Nz75/hqCsR8kGvz29HrJ8M3fvfxM8jM+9tqAlbH9UCrHm0bOXCrFvkQpuJvAOjoP1aSB5vB9TKDXJT5f/dZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Regarding the kdamond termination, I have an idea:
Should we avoid terminating kdamond just because of invalid parameters
from user input (e.g., non-power-of-2 'min_region_sz' or 'addr_unit')?

Since a terminated kdamond cannot be easily restarted currently (if it
is not terminated by 'echo N > enabled'), we should probably try to
reduce the probability of such unexpected exits caused by user input.

I'm thinking of validating these parameters early in damon_commit_ctx().
If they are invalid, we could reset 'dst->maybe_corrupted' to 'false'
and return -EINVAL.

This way, since no actual modifications to 'dst' were made before the
check, we can safely clear the 'maybe_corrupted' flag. User will then
receive the error but kdamond should be able to keep running with its
existing configuration instead of exiting.

Does this approach make sense to you?

Best regards,
Rui Yan

