Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D410CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A21A6B00B4; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B846B00B9; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A3F6B00C3; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02C886B00B4
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:01:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 969CFB9B1A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:27 +0000 (UTC)
X-FDA: 83821641414.02.2BA4FF4
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id D2AA180017
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hZm1JoVU;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756278086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=enJcgMaOiH6GmxE9MnhUXDRmIGHUOGYVGK0wsDGH3co=;
	b=Jw2iMp79v0YM64lFdY6UzUeosrHeg0+SySj3LBOdLtIvFLR3zSWuUxDifFUH8pHsC7vAzG
	JbmkdbITVBK8XHclSH+3NjJbIf363PKOP8bj2B81C9rE2QCvimHEdX+1DvdaRHGDCFv9MZ
	EqKRmEcvzBfRs2went3FWoohlj8RU/c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hZm1JoVU;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756278086; a=rsa-sha256;
	cv=none;
	b=vhNBnQSFf+ZwF9Z4cdhNJaiEpfR8pOQdexK1XL/ItHkgoaHwL2Y1fAJYjaVd0LlZV6jNQi
	ac4/lup2Gw+vXbyb1NnDX3gxG3xqTCw21eFIAxukzTA/FIGal2J+dhrPzk1fK+TVb4rCj3
	nkF7DLY5giGWxIlZcL7fKHzuskIdxuo=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb72d51dcso888007366b.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756278084; x=1756882884; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enJcgMaOiH6GmxE9MnhUXDRmIGHUOGYVGK0wsDGH3co=;
        b=hZm1JoVU7FMcdSFDhQmws7uizITKnXSlnWecMLtJyj8P0+wMf96bOMM1tqIQYFoYxI
         OF6X2YRmZS1UbfcCAyjuIWWju4cYGYLY7EnGQ30+WThQYP3fAN2vPBOzRc5ylyVDfmjE
         41jUvVb/IubV07nsXy3BZPA9lAVkAME+glHZuZrIRAJEf/iT/Mz/FGAHu7ZukDw8z9Jy
         bR15GhJPFdnMNeOk2FyKYr6zLQP5NngcOh55hCZUDLcslLvW9qfTAkTNHmyeQ3S37GY7
         +oCfd19/YTxdlOScVqUEWQzkHp293ljCnSzTUa1n22jqoubvL4nRwGIv7pM5SLTjkiMe
         eXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756278084; x=1756882884;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enJcgMaOiH6GmxE9MnhUXDRmIGHUOGYVGK0wsDGH3co=;
        b=EuH8PU6yy3aL3nhRl1U13Vl6m9eBgooXy57wGPK5QxRyqbhq2dZfSaEvQk0DB5QRNp
         giJ4hhVH4ib58UOUKeO0zL9P3ARKRKyDWDq3p8IzLzICXUiKKQ0VE0DD1fiPZ+GxlTq9
         E6lBg10TH8OtYC5Jzst6bACNXoGvDx8ryBkfKR/RJvB1H1BZe4m1dKo53ANZ9jSREFLd
         7gsnmevRZThihGnrrDDSRdIZiBoDpHZVdkgFifr54dTXV3LAzXdQZCmqumfwN5SS2iW0
         aUn+xsOVO7Z9M+CnXt60wmJgnK6Z8BQPu41BVjVaQkbT7W6wiInoa+jH7bK5hky8ViME
         7sdQ==
X-Gm-Message-State: AOJu0Yy+kDohI3maJgU7fBs6B5FeM+cFDfkAmITtFB49fSwCWV/wWvAy
	jTPW9O9guFaWuSpB4deTgUhNk67tL8duGjMfC+ePdBEQu+hmtbvT6mqu
X-Gm-Gg: ASbGncsQODBapqZFCddtiCUWShEFhqtoLHULfMJQZvAw4k9Mnc7VnX7jIbC6PJBrwyc
	VHjAoRKoysGie8YRSGNPvk8IlUh7HGZwK9CEfhEhZ3zWNqDkrJr+UQQcPj+IBpZFkbciyajQjkp
	qZ/jhrD4FH6CN92M4A1EIXYgvr0vt1wyyu7FVQXf2IijC61dvXLj9L0sggFkNZdmmXCZEnArWhK
	TWLyyD3ejbYwoF8WqBfP5rjmt+CyGxq2PalmBg+WOyTm9tVNLO6rzTdfdwiBciOxPJfiqGgyLJR
	+H12jP0a6mvJ8irVvza/Q+i6p5jUdAvepuOhyfGL2Yp7Hq3AWt7X/dI44qSPh6ROctkmLy2T9KG
	hRiQOh34fhnEakZDTCTtzGBxtslypH7QRBJOT
X-Google-Smtp-Source: AGHT+IGwcIoPeSP1xPvGEh2ypa3NqeACPOPBwAflvSfKPocg6TVG/Ftu+hLRsMqzSTWXac08nezfUg==
X-Received: by 2002:a17:907:e98b:b0:afe:677e:a61d with SMTP id a640c23a62f3a-afe677eaeddmr946072066b.6.1756278084121;
        Wed, 27 Aug 2025 00:01:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe90c8f85fsm462746966b.8.2025.08.27.00.01.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 00:01:23 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 0/2] mm/pageblock: improve readability of some pageblock handling
Date: Wed, 27 Aug 2025 07:01:03 +0000
Message-Id: <20250827070105.16864-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: D2AA180017
X-Rspam-User: 
X-Stat-Signature: m8czk3rdducmt3buki98y5wxdo93qxca
X-Rspamd-Server: rspam09
X-HE-Tag: 1756278085-486341
X-HE-Meta: U2FsdGVkX19zeCDE1HtcQ4s3NVF97fV17dJhCoLZRvu3JWfAH+BWFQzZMHnn8r/Ekoiw82K5mzj1Rn58BSuYOpI1Kgr8Ld/RAGD7F6/xarwHlme4l8gb1p2d5cXORDlQmO5R4Vosx1iSj//MrR9qkM53ipykDmoj8TQwQYNx/3LNfIhNmdew3Y65pwxqd/QDNRHy/1VNscmM3AsdCAkQwFmj/ht5wZvb3mN13CDUXzrx0g5sbgpqFpIAiEVck5hO49V6uauS378afUp9NHktzHhBUVPXGgl/QgnmPUbRUkbsQBRdH9pUlGwPDDuePIpnpEFz5Gy9xNOvcVWYgJaznE7pmZ6C+AVgW3z/yb+mXHr5CzH6kTonk6KTGEskNX9dz43tLzd9Ayf+WHVEE+SAaT7iLodK1vIaW6vFd7Sq5QVD32hDU84kI7lUPc3egavnx6gZQhsE7Qri6DVTs1yq3ERv3JxNpIb8eUt5Q+7dAdnFskPLU5dNwyt/EmX7lH1IIDcFF3WOz4sGg72uuRoSc43P3GtQ801vyzVmxDf/UE/oklv3kmAiLglq9mVM+mvZFFnuKABJfo9GikImiDQNuEiLwsH1e3pHwaEPh2yiRspRWcI48kP9lgcsfk+qtKTNmSDu2Im9h8wRUANOKoNwhUVHm999wjLE454SoDANP4W4nsSZeOAAEP4RoGVO2yjqFfLvdRTPnJIZfv3O2jmVfOakPGUprt0e4tgFqHKO3ZVTVSHF5GbUPdo1TZGrbanVGe1wPNA1zMHsAoz7xEfGBThDuTs8l55evj1jwzG+6HG6TeeQoMjOBVD86APULj5t7cLqo4KZl/qlyv6d9zlQLSy91yjM6GQ0haZezsG6NwEPT/5CraOppy4hfj2t+iTHkEh6FgpOV2ir3Wf8afJv3fxDvK8YsUX8E6GluprrbD3g9Q98yIi9fzPpAIm6r1oZFEgtt05pZM8idQdiWLD
 Il1hAQN4
 9ogKi4lYlDbDzF+YkdXCesn54Gvk0Da5PSKPptSAqEXNTq8d5OJLmxjyukYFOqV993RvNxlOOrGsbA9fZocpZCSo233bqk9qbMfEjBR4O/3Umt4XVGVUfjPSCKYPoSKThpWsj4mGN9A3WgwU9Wpbfsb6WFEoQlBI3LTj3fa3ssGntU3OPUE0gOQ/MqAXD4Mde1B1FC3i4b8qKF0p59n3Aqdz/FfVoCJEQGdn7hHZqoQzExkD1frBI7WnfTzYocO04boqFjv7jm3od9T8DVuQXy7pmjVx3BYG7b04h/zyA0riEdiQJgkJlwWqhlOVGTd1cSvxpG5Ts6nCboiXNALaAhdK5D4t9JsDiD0bBedqXmlliRLEZkMz4jds49AsAmJdHZZrvCIZGqKZYGwIdCOxYrbQBJooV3J3nTIfCkR0ECRo4XDJjKiX1hAFrsQiwHx1doFKgTyhHza6eY8Rh3mVCR/g5iNTKX60uXDLJ9aNEZ+ib55dHDpUJ8ilw/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During code reading, found two possible points to improve the readability of
pageblock handling.

Patch 1: isolate bit is standalone and there are dedicated helpers. Instead of
check the bit directly, we could use the helper to do it.

Patch 2: remove PB_migratetype_bits and PB_migrate_end to reduce magical
computation.

v2->v3:
    fix the definition of MIGRATETYPE_MASK, thanks ziy

v1->v2:
    remove PB_migratetype_bits and PB_migrate_end

Wei Yang (2):
  mm/page_alloc: use xxx_pageblock_isolate() for better reading
  mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end

 include/linux/pageblock-flags.h | 12 +++++-------
 mm/page_alloc.c                 | 11 +++++------
 2 files changed, 10 insertions(+), 13 deletions(-)

-- 
2.34.1


