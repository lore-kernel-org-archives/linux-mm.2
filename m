Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5828AD6E2AD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A955D6B0093; Thu, 18 Dec 2025 10:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42A86B0095; Thu, 18 Dec 2025 10:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917C56B009B; Thu, 18 Dec 2025 10:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CBD26B0093
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:58:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17D9016025C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:00 +0000 (UTC)
X-FDA: 84233047920.20.D629EDE
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74A451C000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:57:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GT68UD4X;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2oiypo8dpeBkdndpT2cWTlc28Jh3eCPkCjXq1HsH22A=;
	b=7L9PN8WixvyVDVxibBIYvFFX7UaXuFgdE+xRU+/VcJU5EgvylgHuPFEfpQcrUMfCzdKIfp
	rEtIvHMw1kyrTiMLScL6y94+sJhfIGPwSV2p0VVAVAh2VkKarViz3uhl4vYeMTiOXrZDO3
	Any86n3U56w1ZgmfTPfes84fvSViN54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766073478; a=rsa-sha256;
	cv=none;
	b=Tmz92z2bUDI+8J+SaOHBEyJ8atN6ojV8IAdAQliw7QMGOffgdjiO/IBnPbl0ZbD0KJyNFt
	uEHpSTyoOK2NgbmdHg9LlGDWmUqOJhS20XprMuKgJUGAooJP9ow8HZXblQszQNKQkPqoBy
	VHTQHFLNYrRW81irwkK1AEbRt4tSraA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GT68UD4X;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64472ea7d18so634538d50.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766073477; x=1766678277; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2oiypo8dpeBkdndpT2cWTlc28Jh3eCPkCjXq1HsH22A=;
        b=GT68UD4XjEXMiFyeNFt2F3imqHiFS/vJGDAQ06QzgN1sBf2x3LoY7+3punhQfPvFmM
         IZ39IYJg+MvPzEJ5Q+YN6ipZmkbgKYzJvgYtHPL1FTpV+UwPKmpI8tfJ8dxBjFoAUE0K
         nYf/FuqXCR+vRgXfH5Ed1sah4NtdwPAyijYK2S2yqG4faA4ocFxGmtYILQ0xkaOqO5qJ
         ImsOH29c6OIXweQeeQjY2Qr9Egq4sBFz4qnjMA9Vfa87i2WcoCcaSrGzkz1mE1nkJe8R
         AmuFQpV98kNhZjZCzdG30j3cqXIHP7ysVcfZkjSCzQqkrCKuCSACy7BTXL6qvg9dh3U9
         hyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073477; x=1766678277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2oiypo8dpeBkdndpT2cWTlc28Jh3eCPkCjXq1HsH22A=;
        b=GUbY6TRemTpGK4ZLBIQKveP7PAbT7qwQZWS05BzOZ6kdBSIr29mZTPgrEYKPW+qcWM
         O5XOjkaBu7HEon7JhrLL0/5eP+mNdZSA7R4RiHtBdz7DZCRD+710PgZ0zXQszA7MYfIx
         LDVDXowjTUfbIhzCwDk6/JGclSlPlTf8QIcbvbQ6voJcOGlFoppztObtq2FwAMWVvIyT
         DbvRNOL/QsZKMkksBg52YwamRoh+ipDtDOUArnuu50omkrupkGBJjK0rBXclUZ+QNPsT
         Do5DEwwUnSoCS8z481wQcXiaQquVM0lUzW/MZ/mO2VhB2bHqEUFPLRpNFcI2JsWlQZWD
         BCcw==
X-Forwarded-Encrypted: i=1; AJvYcCVF/CoCFGDC33ItBcg8EYRvoO419Z9Grs4wUuRmlvIzNA+useRkmAGSXkdxYJ4Kfl8Ec2F9YO+zTw==@kvack.org
X-Gm-Message-State: AOJu0Yz+0YjS5afY/TbqIWHeG/hmp+gK9G9NLuLGjpmEL6APMdOBMztK
	8K1qDIpvLF7FGeQ96Ft4ppX2KvNO0U1rx+Ck5FyxhhmnYaX1grpPS/w4hi1bwk8FFNM=
X-Gm-Gg: AY/fxX7LTTslKYKAd/uziF1sJcOa3mLaTRu2ntroG/SWb3HdldhWpbBMuls9nkO7WwV
	qLVUwZNoWB3kNB1ur0N0NJQmbBRlJamR5rGt6T1egz4ux7iL308dArJ1pxQrOO4HHfppse4RW6X
	vXXFcO4iY7wR18kWLK+u3An0IbKa+ZxUzVCvN8mpVzLwxV7I4iIgzVtfkWcSOy1TLrcRRkP33/7
	m6+jkBUpzBNLcUww0rF/ikkGJ1yc9x3atQYE0srHEN6erUWXhnGK4fT0lbmlTMTH/jGNNQ9IAmH
	jCKP7yf1Z/faTiKG6guyFfAwfK7eiMK4fLaCQ1fRYdPpbbP3EOYdwfhAUfs5whRfa/8Z2JfMQ72
	HRPjyt3DgZ/bEmcvhqzWbkBZNIhnRUzm2u+ovbYYWvKaMTvUoYf5rQcsI02aeyswBLByEpSTH6R
	tkkNk/AbCWnIEvUwvZUUz1tBHWq1eZ9oyHVgMZNxGZNFCfESiuHrLKbk1d3UOmHkCqV/1LPFD/m
	Rh+UyMX15rNdQgk+1F+TnxAZ9tLBWyMclX17w==
X-Google-Smtp-Source: AGHT+IFaXYKuK/o0seYGysCGZslKaAXs8Fo4Uc83ADSlGAU0k2LMTIhpIrTp2Em3aaNMRjw8OZtwJw==
X-Received: by 2002:a05:690e:1384:b0:645:561a:4c68 with SMTP id 956f58d0204a3-645561a6017mr15590217d50.66.1766073477343;
        Thu, 18 Dec 2025 07:57:57 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f52bb2sm9348467b3.16.2025.12.18.07.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:57:56 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	skhawaja@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	akpm@linux-foundation.org,
	kees@kernel.org,
	davidgow@google.com,
	pmladek@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nicolas.frattaroli@collabora.com,
	linux-doc@vger.kernel.org,
	tamird@gmail.com,
	raemoar63@gmail.com,
	graf@amazon.com
Subject: [PATCH v2 0/5] list private v2 & luo flb v9
Date: Thu, 18 Dec 2025 10:57:47 -0500
Message-ID: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x4d9zgj7yw3f5c7fpsj9xn4bodgasm7z
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74A451C000E
X-Rspam-User: 
X-HE-Tag: 1766073478-339042
X-HE-Meta: U2FsdGVkX1+TTw9EaeWc8nl2Nlkm1VRx0T79Gid735VHejJJcCen1n/u83iPiGioVdmTzmf6f8xGjBqzHO6M5H5YG1D3yB3XIv+ri8HnyFTkBbuci2wOV9ZEbLy6LMFrudR0a6au0D6kXlyXstGAJnpFpemXVbXEZjCVZgnCZLnIRdRjw8lfaHsac5+l2E0SQNu+Uy22aWg8sNaxCu/p/JgTZ+KYOV9voAha/XDCxAFcFydmnAvhqsFfw1wIOGw3H7lHpy1xocQf5TvFFpq4+x0CqEEp/UQM9oU+brF6YfuA0F01lSFGXydr5vQyEneDjy6BB6DqnLpiZg/9SuFVsEktk0huAwTtXSX/azgRyC07zWikv3ArcWwU9AGXRZPOAMW9cIDfmKogh5ngZSt2DWIKgIN71WFXAgN3MjhJVVW9ZZoHUZxY/pbvR+vQU2bNF4YjtMghbxR7ByghRmyiinsr3jJvFtDmY8f/U8M76+b2/ICFcAIk50lE9Badu0dJrLvy2zY48/sj5YfvZVh6I338n9x/5ITJGXAjas8GEJgYit8CR7O1wQNwBBvafBaU8tuwlzkagPXouzA/xc95A3a5R1kmk5N6rUvXU1/Oycps+WgbOc17JiFgxEnA39XHLFi2g9BKOVU0RGyrOQxP3D6cTfCi6yaImusbodHiikv7A9+X2QOnDfty1Lugjgf8mRS8IV1Jf8yU/Balh6RB0lnXudXqJOuZhUMrhlFpeRmUH0NnRod2+P1FfYAugIo4JhqRfr3jO0Sxh9kG0F0pqWIX6mbA6q+j/uEqBZFigJhMC2vlkPRUrKjo+Pfih9l/tyiFL8q3oDHB6US68FlvM44/mPbL1GAlC3CrLkHyoHwt0eoUf628u95T1WomXKeGSNXUppW68+Gx//0piJPXAmU5PY2XL2g7R2gtq9ve87KJXwvl2U9IiO2AJ90LfgYc5/LltAn29TpA/uDvX6y
 18Hkfmhi
 TuZzYt8r1uY6qZqYDPfpGBQ4yPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series includes two separate workstreams. This is because FLB
should be applied on top of list_private, as it uses some of its
interfaces.

1. List private v2 (first 3 patches) Previous version:
https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@soleen.com
For details, please read the cover letter from the previous submission.

v2 Changelog:
- Added a Reviewed-by from David Gow.

2. LUO FLB v9 (last 2 patches) Previous version:
https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@soleen.com

v9 Changelog:
- Addressed suggestions from David Matlack and Pratyush Yadav: added
  booleans to track if an object was retrieved and/or finished.
- Modified the patches to use the list_private interfaces.

Pasha Tatashin (5):
  list: add primitives for private list manipulations
  list: add kunit test for private list primitives
  liveupdate: luo_file: Use private list
  liveupdate: luo_flb: Introduce File-Lifecycle-Bound global state
  tests/liveupdate: Add in-kernel liveupdate test

 Documentation/core-api/list.rst       |   9 +
 Documentation/core-api/liveupdate.rst |  11 +
 MAINTAINERS                           |   1 +
 include/linux/kho/abi/luo.h           |  81 ++++
 include/linux/list_private.h          | 256 ++++++++++
 include/linux/liveupdate.h            | 147 ++++++
 kernel/liveupdate/Makefile            |   1 +
 kernel/liveupdate/luo_core.c          |   7 +-
 kernel/liveupdate/luo_file.c          |  39 +-
 kernel/liveupdate/luo_flb.c           | 654 ++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h      |  22 +-
 lib/Kconfig.debug                     |  37 ++
 lib/tests/Makefile                    |   2 +
 lib/tests/list-private-test.c         |  76 +++
 lib/tests/liveupdate.c                | 158 +++++++
 15 files changed, 1487 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/list_private.h
 create mode 100644 kernel/liveupdate/luo_flb.c
 create mode 100644 lib/tests/list-private-test.c
 create mode 100644 lib/tests/liveupdate.c


base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
-- 
2.52.0.313.g674ac2bdf7-goog


