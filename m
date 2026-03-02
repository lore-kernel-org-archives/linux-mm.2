Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FA8EB363C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03FB6B0135; Mon,  2 Mar 2026 17:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B17A6B0137; Mon,  2 Mar 2026 17:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDC26B0138; Mon,  2 Mar 2026 17:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 799CE6B0135
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:20:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20E45160369
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:20:50 +0000 (UTC)
X-FDA: 84502543860.30.425E7E2
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5179F140009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:20:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zyKK0xdT;
	spf=pass (imf26.hostedemail.com: domain of 3Pg2maQ4KCEUqvykhuypjohykznvvnsl.jvtspu14-ttr2hjr.vyn@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3Pg2maQ4KCEUqvykhuypjohykznvvnsl.jvtspu14-ttr2hjr.vyn@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772490048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AFiFXZXtC1y0sH5xj9p2pt2KSm8pmrA6Rl7Jb2isOw=;
	b=nXWSIztPhSQTFbSlzyREqIJ+y8VkYU7M/xdVBqGLqqtz4eDB9+GohLcZaWavOMp4utmRBS
	zsryaO6vhby5AfrvD8zMNTBT2/5VuoKhAiHwko4HGiSWSsSwOl8eIftFn1qDhGjNyx661d
	QGex0kC+efC120F/s99DLPs8lQW7hzQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zyKK0xdT;
	spf=pass (imf26.hostedemail.com: domain of 3Pg2maQ4KCEUqvykhuypjohykznvvnsl.jvtspu14-ttr2hjr.vyn@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3Pg2maQ4KCEUqvykhuypjohykznvvnsl.jvtspu14-ttr2hjr.vyn@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772490048; a=rsa-sha256;
	cv=none;
	b=hJNBVsMY3MhWRv8lweYJmL1Z+g+BjZikeDdZQTAwaGrvlJecpCKWrfmStZCXJ5ilpYeFvq
	NFX4pvykPnFjUtOuHaDJOjf0EcTvc5ibp0gNI0RdgklmDulfsGY5h1ngOQX0iPd2qqVpaY
	OaoVVdriYcwiN8hu5cajObQRbAVHm8g=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2be232ef3d3so67075eec.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 14:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772490047; x=1773094847; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5AFiFXZXtC1y0sH5xj9p2pt2KSm8pmrA6Rl7Jb2isOw=;
        b=zyKK0xdTXp8y5g/6GQi3xHuOb2wzUSOOURfFyPjFdnZPSs0ZJ2xLSTn3PDrW/R37SB
         3cyt0eWPdJO1g+6f1GjJ6BUrNX9ckao7wboJPD7OmVScjDAV90FbTtjefrxYiW2rmm1z
         Mb3MFh++oX44j6auuD/kKHgyh8abGF8wx/gsEOVSAsJoRxt0xDOS9c0i8wDcDxc/QjgA
         dyoVG0PGIqaiCQdvhN5CYb2E+vokg+4I9iXfzTqPgZQ/oDfvUsZO2cKdZ/92o8L7jXKT
         vmOR0L6jMoGYWAL6aof/3tYwf8w0t2Ol9lk17BHi61kAlQQCVuw2sNoG7OJvV357yaOS
         tXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772490047; x=1773094847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AFiFXZXtC1y0sH5xj9p2pt2KSm8pmrA6Rl7Jb2isOw=;
        b=paslumka5bTkIDdfH2rMeQ2vijrzoApDA89HANlqIBeplSIxjko246dmk4fyWmewo1
         gpt9VyRjDjjG36DAUclklN2ekWYLgOWdtbYbTbbKgKHoVnHz2YyYFOf6/Fg8zOTUYsTq
         GbMw8h5iIfC5H2sB4AH92EeaHeOPXO6Clq34eAxw4jh/rxOgGudDHvifvFpjX9df8RRa
         rjurWknYNvZBnMF2LNwyspNqEAgE24xU3wfFduRwKBwubJuUCntoEBEY1CxBmh0tOi4y
         /jyJP47cgZm3XaqDgGwp8K+HVFE/hgBHb/eI9wJGwP9agkyiBNruSY0U0G+Igtd19DGF
         HzHg==
X-Forwarded-Encrypted: i=1; AJvYcCVEQckNPxV4JTnHeJ6AHnApYo9X0C9dbjEfebr9eOGfRad/4FRmuuj2eJR5USxibnQef2qwAJGuhw==@kvack.org
X-Gm-Message-State: AOJu0YzUHtP6j0HgforBqQx2BbLjVvlVF03xpvPA1JM+AzfmjeJ2gcXL
	NxpPVw76nYpGZnDkM55hvQ/1Nqi3icW8qga6OTNCJCm3ig9e7AJc1kBacBu/xMoeELMS7/kkmN/
	suUzN/Y6ozxJI1h3YqeLDOa0gLnAUhEDRhSgjJQ==
X-Received: from dybcr37.prod.google.com ([2002:a05:7300:aca5:b0:2ba:6ffb:dc6e])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:72d0:b0:2b7:32a6:82d1 with SMTP id 5a478bee46e88-2bde1b574e2mr5884765eec.13.1772490046646;
 Mon, 02 Mar 2026 14:20:46 -0800 (PST)
Date: Mon,  2 Mar 2026 22:20:43 +0000
In-Reply-To: <ebf0c9fd-9c45-4aa2-8cd7-fe8d5956ce52@t-8ch.de>
Mime-Version: 1.0
References: <ebf0c9fd-9c45-4aa2-8cd7-fe8d5956ce52@t-8ch.de>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302222043.2432413-1-jordanrichards@google.com>
Subject: Re: [PATCH v2 1/2] tools/nolibc: add ftruncate()
From: Jordan Richards <jordanrichards@google.com>
To: linux@weissschuh.net
Cc: dmatlack@google.com, jasonmiu@google.com, jordanrichards@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	rppt@kernel.org, shuah@kernel.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5179F140009
X-Rspamd-Server: rspam08
X-Stat-Signature: wd63hq5ozq1dbgp63m3bessy1efqyzd1
X-HE-Tag: 1772490048-252457
X-HE-Meta: U2FsdGVkX18MH5emJIsQ/EL6LE66wRdFDl7EDaa4WUuMrbNMfqpToQRP5Y7ok7K4cDW0Dml8NziEZxpoNooYUC90YslWw8qaocKTMqeQtEWxuPm+j8BoFeAoWBuhrCOrtiS56di4rb0pEWh27rcGksFUFVQOzJ7xaEzNKUdwih1SmwtdlGBkh79wA5foa9nLVv0qW7HiMjDTUYZWf9C+mg9rtC9dhbt7bOjZZrHmTNBxys/E4mGthlv6AthnGmGAVyQLS3sWDdvjYgJUEWcRlYOMFj1wuT4BRNuk+J+oyGkhey61lbZKK2eCyCszaJpDrrH+bhb4jUmxeM5nsRjYzlJTKUq6Z4+eZZed3/gXzPFgVaU0jqtdMozImrKP5KGv12e+lzXo9g6RiGO0sYMZvShb0kfj1PLqlj7MWOAmeuMmpTXbqPz5OzAxtinzUsg8klLtD5kDQ1iHOvVfCWBQEuylftH1t7SpQ2kEpxp34VzDDvBGM9emTze87X65rAhlAsvkmhnq7sZ6QEirw0TrW231ICFOju4fnEHl/TQqgS1xjcW2KCb8rnwnxFmObvwP6da/8jcYHTSpVQ3XQVN1Mp/j27J4IyCNJxn6GFXpF4BgVTunckoJJkL44+/PDBs8VRN4/s6EDCSjopZB/G05G9aI1Nih0ZFQNRGolUu8ELw2cZuVwBhprxm2M3h1AVqjaoGYUzsn8/Sx/8347ujAd5ocA+vVAnM4uB483px3tfAerd121FBdX/xQifsqOGSW4w91ee0/M4Ln8ev9J2PJShuB/qa+HdkQWrp2J5t6BaZYC7e1j8Y1n3SR1HXhJbi5slcNbMv87C25AN8vzS52t2lRYXvKTM2cuToriAszMxLFqbZzx6ziEeKpgWMtqzxExfYnshCnoNjqozgJm1PVuOIUM8oBfiGR0vnR+NZyWcDSC6r6sdveMaqLk1LtyOHI+Qe+Xb+X808ev/WyqXv
 ZkzhFs/B
 cUIi7ZUA5Zv3m0mTQbethQSeNgy7jzhGW6SS7orjCqrwvjOtaU1AEIr6LCLqyo58lWNwl1tmZ+Dj8EsaPVcB6WnLdWOv27FIz+7+th0QcPa2KahGXvO5gBuQttWp9Lmg3R8uiNzuVyCinX7vit/Y0H7C1XuA05FyObcF5wDWCvT2tT1bFlwmWYUQO6WAXaAHy3W56fCsFkZLoFq3qhA9UVqFX7wLccciLK9s53OLKb+M4dJKPcpe9bWBl43Egm4ED4ha126W3bxO3NIpVAsOt/UVFugZYeUPdtqijWRhXg6nZQ//ihuYJVuL0WsPN8kqhRr80R41QwfyabVbDNs/Esyjtd2jN4xyPNhAcRSkLLvXdY3U/gHG2lny+WRbGtTL3V/MP3xNr1X8Hquq5Q76Uk7TD57Oqo8RfsUOSvIopcY/mOyJRsMw9dQ5DF/sAWEF8G0k8yhM0Ld0EDJfmyAqa3txjJJqG3H2Dyl/7w6gnnaMFI2l7wXWII9eD2JjTtsIKHJ0hSnj1dlk+AeKNS8VzldM8p4YUNubI+1QXZ3Nt4ijT2khHPDbiNHkHMlPV5o/uxscbP6bwBgpItp9DUwPGnZxMZHX8toHVJwL3Uu/l3cDVB7AjvyTtX0Rn67jUWW1F2t2Ps2NWRzUKv107zVslK/mU3NcPdlzpjNZ0EGtVRiLuOFYmMoZ4RmPsuhUAMzHLYYBPhYv50hu9Bdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

> (please Cc nolibc maintainers on nolibc changes, I only saw this by
> chance)

Will do, sorry about that.

> off_t is now always 64bit on nolibc. On 32-bit architectures however
> __NR_ftruncate only takes a 32bit value, leading to the wrong kind of
> truncation. Use __NR_ftruncate64 instead where available.

Good call. On some archs (arm, mips, ppc) register pairs need to start
in an even register. I assume adding a flag like:

  #define ARCH_ALIGN_REGISTER_PAIR 1

in "nolibc/arch-xxx.h" is appropriate?

> Please also add a simple test to
> tools/testing/selftests/nolibc/nolibc-test.c

Will include in the next version.

Thanks for the review,
Jordan

