Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B491EB3631
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6B96B008A; Mon,  2 Mar 2026 14:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF246B0092; Mon,  2 Mar 2026 14:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03276B0093; Mon,  2 Mar 2026 14:53:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC8A36B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B9E91C1D9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:13 +0000 (UTC)
X-FDA: 84502171866.09.E9EA072
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80B8CC000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BJt+cYIQ;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LXxELu9ePidewYBeVAy1Rzm8gqGexmW1c2vV9vPcBjI=;
	b=YuJSNFGijHE9ePA07cN3ytXDB08PcHVYzFlfdlrwQ/TFxaW1QYQdQWWJbaVuqCxkZA2tuf
	Gu2e8Pdig8X72eE+i2WrjjO8tVYvedMdfuE60IuC/1Gm5wgu7txdrLByfKsL9w4Mh0b5V+
	+XEucN+eBxz76kAWPaSrG1DfTTn/hQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481191; a=rsa-sha256;
	cv=none;
	b=5U20Ca6ozKhSOlOozeX6kCu2ic0LGhcPpYpc50QAjqoRXoF6Clv04ycDBGBQwmbbp4jlhn
	jV4YV2X+Y34i0Yt+a7HmZLRCMVvZV8/fcHLOHDsl1mP3h2T+uPNd7Ugyr8yGHtqxu3IanM
	e2e4/mtCOyEiVRdPfw+Oh7pqnJGZcu4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BJt+cYIQ;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb4acdacb2so640795285a.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481190; x=1773085990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXxELu9ePidewYBeVAy1Rzm8gqGexmW1c2vV9vPcBjI=;
        b=BJt+cYIQlcBR8rdZqFED4zZnv6njDkbJVnJZWUIni0Et5EPt/wvlBd86xyRXd9H57U
         kYqXMCV0dTLMoGX2RDi27Jvep+MU9LyFZe7KpSC4nNvHoRULX8wz59HcYwA9mK9rnPRn
         h0jmC2SUyWAjrNR+HyHhhG1lKzNDqrzelGksn2fKYGpADzSvsrSh7oc7z9oQ2JjdKd03
         mBgnufVaqV9Oe0TQh/bAeAdHDSdS/MQ4kkfb5yk2TuS2YoY10/COUC+RPRU5EecWBTq4
         A1sBCEJImKGMl5PfTNfsdV5/iQhy4VMFUy9w2p2xym9qW9JLRJh/eP/AMq1+ovniONQI
         PWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481190; x=1773085990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXxELu9ePidewYBeVAy1Rzm8gqGexmW1c2vV9vPcBjI=;
        b=T7PgEKXPJampyhSCptUwM8FcQO3rLRulu5FbwRlNbToh81CU/0yWv3t5zEGZpXbU2L
         RR+/CZsuHnKKbCnP+wRYmyhxhlJJE7ppfUuaWztF7oA9b7ycFRTpRWBBPMN4rjwCaVp/
         SzD66y5FojW/6xWZkwliKlMSIvwIJMIvZz/WxlUsmVHaH3M51ugo8antStsKbfbb70AD
         ErUzUFswfWl9+w/gACvpVJ0z4AhGlv83OlcHTzffzfhJqXnEkm/Jx76+ZDCQnncgTOAi
         vPFyKeJW4aI+Tm8bGxXY0CbRwfsItWAzC7ZQL1d1xuMz9Xr8l+8f6Yk2n9aica9TK7iX
         DvDA==
X-Forwarded-Encrypted: i=1; AJvYcCVTtAAD4UN7KfjnckIy/EzohVlD6ek7/jBaN2/pEbSvOeOBuaHwpqINU4/zq598PgX8FpE+6BnIiQ==@kvack.org
X-Gm-Message-State: AOJu0Ywqfvm4kT6BOmoyYcAsfZ7NqF4yVB2Qp4Cbfm4CmJz0JER+0cle
	73W4u/TR0CsrVV4DuJNDWaWqeURGphj6E1XlPruRClgGK4kwpI1LFHsGxyzxpq/b6FY=
X-Gm-Gg: ATEYQzwB9L2kcMLACcoqOCutCI/M6mxEQ3Ynqj4fSFNxiAy+J9dILJ3aqg1r01FuPQ3
	PEonD5SGl7EsuyT54hNni9AGnoA/pkdkSLMw2nltImiLgyKXtBZbXsT2+/QX7rDW9iAiXYmGvbQ
	rVDnHdITqOC97Q7ufUQeHD12uml3hXM1UEND38v0cYH0rMFrUYL3EDA0eOPBNjlIShIKKmiaQ2z
	dmaKtf66l4YfmyUfFc/Hlvts13grNz4x1i7425wVPt6GVuzHWrndJWQ9xpDEkwIsbtCMcWNgTbu
	YaQZ6uoKnKcb/5BpjywzIrnx6Z/Yt9XA5uKHCesglBhYk9xKGBLaa0sj2OGia1dZiW/sg3651oU
	E1evutkxsh2w9lGj/ubtp/p/MmV7zmJpzO7O05by93r9NsK9V0hJAPxWl/eSJSvpKWTzxEl5wqi
	cTnc6HbcZHE6SyviNYh50BkA==
X-Received: by 2002:a05:620a:3714:b0:8c9:ea27:dbdb with SMTP id af79cd13be357-8cbc8e0380bmr1839034685a.57.1772481190443;
        Mon, 02 Mar 2026 11:53:10 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf673060sm1210821185a.14.2026.03.02.11.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:09 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5]: memcg: obj stock and slab stat caching cleanups
Date: Mon,  2 Mar 2026 14:50:13 -0500
Message-ID: <20260302195305.620713-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1h8qaiw6ieme5ciotm4pg5t4xrqe3kgt
X-Rspam-User: 
X-Rspamd-Queue-Id: 80B8CC000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772481191-423334
X-HE-Meta: U2FsdGVkX19dwusJ4g50M+2ImiEkm0B4LJjrPxvBSkDV0FSpiYZELlfb1pwe74UhL+N+MSv3vVkAlEMsLww8BR/RBgOJzroXmKJtaP8KFupiH+Cy1aZZ5s3n8HysgSMCZpI3mB+u1PIINBy2dRkKxU38i1kM4m60qIJjbzAAaGLnUesQM78mDDeltaZRAqtvNnVd+q7rrDTHK9vNX3GUIGm5p6wHsnXWffLz+wQK1ecDisMnLxfXl1ZvWpD0l5mynywy7wehYN5dLvRB+Crw/MIxmlAuE04ySZOA9yxwICe6Vu3Foj+lDpT0QFuJITK0kvsIQ34F93ud/yHKYdsyRR6dXtGm8JH317BZIr3oSUIw3YUNb1mBH3TG4VI5nJ9LYemCe4G3Ul/KlIjumn8k5diXKNWEgswo8BomoMollFjkKPhC7MT4sO1vM4IPKfqUZgxtppKI52zvA9zC6kjUUu/J7+pHgM7BxAIChCkyosmCjjgZU51+fzKmD0vi6w2CASzFGr1I3Gvd10IllrqQ+Nl9fcfg+bQHLzhzQ++5sJy0b6EjXQzA8aMF3otkr5sIzGm2cp2jKSnTWo3McMQqtea9MTXR+yWdfs+GGNRparmqvk1dw+kzTu4IjgCPp7WhHY6vK+0Y0GRI0N9ZOoJbpXjqPWiXMLJssM6KEDvB3PRnRG9qs5Ll188fOy4/QCxdSgB8lfdd77bG8YVdRxALMIz8HGhuDnQzFNA3SudTNr+bP8tlL2crkKUEnlTXM/W22Zj/Hm9zJO0rFzvj2RgAqUFGpSWtMMhIadsMedaaGQX0oQQ8uCyTwK3rTrVEu6pWW3ms561C8IyG0/rMEi+noMScXVmQ4gVZTJpESTDWKuHY4IEwJDNrMGsbu+oovw7Gx/QZHQlQxHUSxKJkdVBwEV6JZOKix+svPWYAGbtpTMqtY0TWjhIEuc3ul8FO2H5c0ZtHoPSezL0tuWRDNje
 4KpVAlY7
 qFdvvhZ/dvmyjnd0SP2sMd6m0GIni+vHShqxpe+Oxf8klPGmmMC8gkhKG59uicA2RdXYmEeuieRneyCWfr7xhpzWVkz58L35/vfp4f4/+p+10uZDBEnDm23Dz9B4QG/W0n63nUefMM0ehQddAWaG+7R/vMFNXrLtNOrwaZ8uowmmPfSxraa3Fe/t+HvdQfHexRH/Up3YGu7aw717LANxdIygAipH2c7S05zmTQoYlnGZMan+bXm7rpS58hAqimLo9JFyVjV5JQBsVB737J1TC939aYLF29+B4p4o9apCDE/yC4BJ3gA1Gg7O1eeQi4wa4lGpAQqL+6xTRUkhKMiSwnIFjCwteL9i8VwBojm6VYlOv8BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up to `[PATCH] memcg: fix slab accounting in
refill_obj_stock() trylock path`. The way the slab stat cache and the
objcg charge cache interact appears a bit too fragile. This series
factors those paths apart as much as practical.

Based on today's mm-new.

 mm/memcontrol.c | 146 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 96 insertions(+), 50 deletions(-)


