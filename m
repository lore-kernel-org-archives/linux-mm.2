Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93DADF45A12
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39C46B0089; Fri, 10 Apr 2026 19:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAFE6B008A; Fri, 10 Apr 2026 19:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00DA6B0092; Fri, 10 Apr 2026 19:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA2A6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:14:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38E5714028A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:14:32 +0000 (UTC)
X-FDA: 84644202384.10.935BE9A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7CC0AA0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:14:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IB8QdOiV;
	spf=pass (imf25.hostedemail.com: domain of adriangarciacasado42@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=adriangarciacasado42@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IB8QdOiV;
	spf=pass (imf25.hostedemail.com: domain of adriangarciacasado42@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=adriangarciacasado42@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775862870; a=rsa-sha256;
	cv=none;
	b=h8ASQY9Q5sDSpldCqFxzHczdSdsKoeD1lG1yhqrBpJPZZPq+4of9Kn/0u7QKbwxS4HNVk4
	RqmvI52lXAyh4EBf0N+rUjn4dHQ1aFSwlqSvLPnE6C0IB/GfaoSko97tVn2Lv3QQR5pZ8h
	llbGK5L2yycRkx7skrvLD6InzJSx3xk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775862870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QkSzhx4T5UppzPUxsq1ow8P6mxw7Nwf60UEUxtk5Ai8=;
	b=WZxSVf6wnbLxZRGH28O+t4PPGyex6SLc0wk3d4MKHiAUmyhEI4vyRQynQ4O4PTdzu5KzpT
	7RVXsmZtNDO8kG26qxuEP/XS1+o2A3xiNitFDe0Y3dkJMEvjU7VQ8WDpQX92RnFwRjpWhm
	PC+ZYuiMFa8KxhGoH9wlbdvLa7tf56E=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4887f49ec5aso30701775e9.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775862869; x=1776467669; darn=kvack.org;
        h=subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkSzhx4T5UppzPUxsq1ow8P6mxw7Nwf60UEUxtk5Ai8=;
        b=IB8QdOiV/Qior3q3HDzAtOOjX3z+NgXqoVSnc7B6wDhH3XSh8XeZHj3aL/mDBYONoh
         ys1G+1CXL52obrTwSGiKOovFfSp0uMIgMqXK1zEDagyrNFKp3+xQTJxRJGPo/gtj66yi
         0ncF85koHtLY/OHvq9U4ZBh60p/JscQRaKD8sHXPI+a7NSrRxaOxVcJ6VRbd+gEdslOc
         g2GjrsbCgsRRPYsec+hrdV54OD8G3y9vOmq2jWWCdDH4dfCPV4llnBQG8L1Nn7Co/Yhj
         0W4MfdmHzhjyhuH4lFHSeftzkGn1EQvYlfBIYUGzvJkvEe/MBLn2ue1cRCuQ0UmhMzaE
         sqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775862869; x=1776467669;
        h=subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QkSzhx4T5UppzPUxsq1ow8P6mxw7Nwf60UEUxtk5Ai8=;
        b=sd9LYePBu0Kx0KVlq7BGmi98d5kJy300JiSK/NL+pJqtIC1xs+QK75kzZXZnPvPdN0
         9W4gZcUREofzRMrwuLd4/0VtQ3Esk+vJQJx0E0O03aVz/xnTACy/XsItKdT6iKRSbSa6
         8p0jK84yhKsDjqtspLduG0tv67oQxS24x/vkEioEEgqhKAcozCbxX8Liu+ENPlhkKKz8
         JexEh6s4WNSlGnrlT3lf7ygkMQoyMlwAnel0b5r47KZEYIcn0EwySByxfLMf6LSPTbe6
         O+f94FLlHIz1YoA4xc57MnMtvuZQnWliNl22fVokv6foK5oK0Cv2cBbAAoAarZfoJI1l
         ShEg==
X-Forwarded-Encrypted: i=1; AJvYcCV+98vm49N6NsjLtTsv7fx0m8duVvQEsrIJ3dpczsy++paG4VZi2dsIwc70rNu8zA8plhqIEfdzGA==@kvack.org
X-Gm-Message-State: AOJu0Yz9yD0QPDIZR0LA8CK8MvCQOW0n0wu53HbRW1XRHjrDn1jAnfHM
	ObkuAxQjAJ0QdQQ4yLiXirE+qaAmwxv5t2aVyglfrVaB2YvRxvc+VE4q
X-Gm-Gg: AeBDiev2zpHPvw6nYbj+n7Ys4tAsdNjJJzD5liX9T5JaDw1y13Aa2mtzEua51cWYNan
	ZwTxURoBjyqmXRdlsrZ3CzvKyppkEUf1vpeOE2oYrLLV1IV3fh0b4GHuBmPupit2uSgFyRINLbd
	bP0A819GJBieFAMtujDfq2XXH6Cn+2LNYO1T1ScB3krt5HYeCm//HBmjmhXWG9yqO652pqM3+0H
	rZG/KjxDa5WE4qKb/UVgm8jfuQF/zm5/hgD2eHAHcNHqbPkiZbqEKlM/GdxZHvsaHVGO7i2ibZo
	SNAPy3RyEZQe4BTMpb9nocZsmoiifrgmVFjGb1vwZgpgOZbo3mGIyAUqAiVZogD68+yjFB3MS99
	YHg4lcWHZm+LI5emlg2mHT6O5p502QXNt6+cO7+d7Gi4WmfakBiWM8ZOyJqLdzZu/grL8n91Es8
	3ZrQqQ1NqSoIwS5+4HY3nDvpS09JEMmabFm0w=
X-Received: by 2002:a05:600c:1987:b0:485:5ba3:37d8 with SMTP id 5b1f17b1804b1-488d67bf736mr60572355e9.5.1775862868677;
        Fri, 10 Apr 2026 16:14:28 -0700 (PDT)
Received: from reporte.txt ([31.221.247.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de3499sm10197674f8f.1.2026.04.10.16.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 16:14:28 -0700 (PDT)
Message-ID: <69d98454.5d0a0220.2786dd.98a9@mx.google.com>
Date: Fri, 10 Apr 2026 16:14:28 -0700 (PDT)
From: "Adrian Garcia Casado" <adriangarciacasado42@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slub: Revert "mm: Aggressive slab merging heuristics"
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CC0AA0005
X-Stat-Signature: 6dys4imwb8f377qd61mgxocozn516fws
X-Rspam-User: 
X-HE-Tag: 1775862870-936260
X-HE-Meta: U2FsdGVkX1+svEXk3iBdw4qe6eleB7DBhCMZtu3wMlYfXZ7jAYBlfSDHOZ37hl+jvOwBQMmJ+siu7NOvn2TAqLO7SDjGdH7VyQ8kCQDPycNGH5SuPW8pvCg5uMXa5u1g9e8v0jtkkQ3V0fi0Dtx1B2q0z24F+NLeZeQ3YYra72EoZP6fiduDGu99sM4CGvWlLp0Tz0tkC2pPP1pT+TAMUpZO5kWrzEyF7rK8c3HswKbtRogpdtYQlufnPFpfB4MsdouKkCZ09+6iqgldU8+aZvyNkfuOsPiF+FRJjwPauV8XMtaaHPNjdHP4e8BsKbPxeAvGNgfbnjtq34UVBXm7iOUV3e52mre1VrKFuNVL50lVHOsq6VjNCLTPnqU21sILFR3KBUmm/I3mf+0x890wk2guFCleyyKAXHFbLnNe9dCkZ3QgH68csBq8P7IulLNSuz4yn4B0Z2vZGT2/80hKW3ueMY8o8qqe8yERWilMZ5Mx1OXTQhOWa3OlWDraqmKEO1BYmOIIznuOKFcefMpJSQXaG7H9IHm8mAGGrvuUJ11twT2hRnRkj9CiJyvquK9CNuH4cSiTZq31rXPcjOL7gnoH4Lp3jrmup28WCBLEq3f4d53TSQWejzsOlxEHPYETPIpuHcHLs8xt5uqkIqm7cd90YdICPDePORIGI6dJSKKI9fwDtWFul9nvMm4jievJU6EqCzLTd4AsolLHQbZ72GgW80I29hd+EVO3Bl1rKF4RwfwaFwTb7+CXBWj01b87FbccuvVzgY8sqy0vpCFYtMrrbfmb/OSnVYROHavSeor15PN8Tl6cqXkUvNf4cWLHrUluJDbySIF3bW+ythi2QUdsZ6BdszeqSjF1UcQ8VDSFEwWj90Q9mhJkscfV7p/H7bPC1+SSdDbf3w4Gtvlka0H8+FIf0UZaLxy6UBpPEh0D83glQok/obblsBccd67kVaBMVlrhuiV49Y9NcQV
 6riHuFBO
 WZWN7HdgOqde1wAIY4zUViZ3FQD8Fxhxmh5rc71T9Sn8XsVRq8DV0NPeFrzlV2gp2w0T3Y7/Duv94VbfS8m2ZcgPItt7EaAG9RhKhQ5Kp8vTj+2NaUR/6hMEX3H8TzeO3mNDfO4YKOAWy64H5CAlXNf1aaHwAr9BeC7rrBfFFL/S/NWXR6wU+SG49zDVeyaOx/W75RUrq77JpwjmtXjB6sK5NyaS/CK06Y8IdcW7jxW4kuJY3srppAoqyzXSDMEnoap+xlbystsjjv26lODMiCN8poQs31gQ2qFPhkISzsNSHHpXMaxAcVpvldXnlwanRdqZUpy/Q/96i2jGBV0KziZV+yFK0kS8SIDaZJfRVw56CH+nJFSSjaSWFDemwr5dGktRPenZTaqfbdFqIdkINKX3U9iOd6Vo0fS0tc5DAqxxAJ3qXy6PQ8uiOM2jYZ38jmkGmiOCRgkxvxT55ncfqdGR7vkhTpP8vFP8YkzPcP+OSRIYawhPw7Ap9JAbDsL3pm+4D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 18:45:22 -0700, Linus Torvalds wrote:
> The so-called "AI optimizations" for SLUB merging are completely broken.
> They ignore hardware cache-line alignment requirements on x86_64, leading
> to silent memory corruption and eventual kernel panics under heavy load.

I can confirm this revert saves the system from the SLUB corruption introduced by the AI-generated patch. 

Applied cleanly on top of v7.0-rc7. Compiled and running on Fedora (x86_64). 
I have stress-tested the memory allocator with heavy gaming workloads (Euro Truck Simulator 2 via Wine 11 / fsync) which previously triggered the out-of-bounds writes and stuttering. 

The system is now rock solid. No kernel panics, no memory corruption, and frametimes are perfectly stable. The Antigravity slop is gone.

Ready for the final 7.0 release tomorrow.

Tested-by: Adrian Garcia Casado <adriangarciacasado42@gmail.com>


