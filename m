Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67ED1606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dq13XRyt
Received: by kanga.kvack.org (Postfix)
	id 902F76B00EF; Sun, 22 Nov 2026 08:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C056B05B0; Sun, 22 Nov 2026 08:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78ACF6B05B1; Sun, 22 Nov 2026 08:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 532AF6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:50:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D66741606AE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:49:59 +0000 (UTC)
X-FDA: 85462888518.05.099EAFB
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 141F1120003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:49:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dq13XRyt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795355398;
	b=Hnv/Wdp9/BXwplgzwo1pPh8ybOJ6GPdwmkwM8MvHQmkbhGcYox+kAJTbUMAjwENsS+0ey9
	HC5TEuYF1mbgdxxDMeuC63b+Z+1WB+ShSVQf9F0kpnmRuBgVnt3DcMgSee351bbw2Mgl0h
	CBNeZyXS4YU5d1m5cRER1HixFVEfhuc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795355398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3i5MWPEyN/CFOvI6c1AJaNV17PHJ0xdzS2s59Cs1Zeo=;
	b=rHXpf4PUS4jGCYCDs+fq46ZgmFkvU3Q5bh2mvRZdRK6wqdyY+mu+KJD/udWs9exbKVALSi
	oacBRATZRJOeIq5XNtNFbQRsCwkfE6p5SSJCrAlqsCfY/QEuzRFV34buQOu0wVpeKdJYAj
	AGE4kQRksaeK+Z4qC6kaLZeL38XR99I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dq13XRyt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33fb4680717so6846124eec.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795355397; x=1795960197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3i5MWPEyN/CFOvI6c1AJaNV17PHJ0xdzS2s59Cs1Zeo=;
        b=Dq13XRytQ3T7V4qxwSAeULlZ+PyXllWq4Z2o0R9n0l0g9Y/7klAUbyn6anBRlBog0w
         HIakXYWWGLgiAVlgTlUI9LdTkCd9tQi9LQKodUp5+8dq7sB7Hl4oz5yJGpkuyJkzzVKZ
         hEO63ADLxLWbsuna/L4JZU7pAjGr3U5M9WPNOv0pLYhbiLF0chM6YRueGd6DX9Q1O+25
         BSNY2XqIKC4TtmdUlkNu8o5PGh5r+KE1UvkCOXDPzW8Y2JYPQ3AlTpvq5mz3m5OMYVrt
         P85YIlOmbTLVyntDFzICkaUeD4ZhqdTX35T4hP6vBBcy8NTNb7YPRZfyuZsuyjfcuOoZ
         /bQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795355397; x=1795960197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3i5MWPEyN/CFOvI6c1AJaNV17PHJ0xdzS2s59Cs1Zeo=;
        b=VruVihn5hGY9pwjyA9qK143/GInrE5PeyPelkyO+cJm0DWUlMnVjrgA9bhws3Z8h1Q
         +05IGNXJZQbqzA/IVarvZ1BpT7aEGMB4AsV0bV9AfLDQa++hlwut5LKSh9/1cJL0qR/D
         kINwslBw4PswI0RfuxQwJur8LuMlhGdBVs/JRBY3tz4BKfBSnoIdZ4pQ5vdbkZLzCF9L
         VrXVwp27Dkea+6wSKDSvuaioliPNR2INeti4fo6E7uJ+UHFmuYfNmkiu2t4mREJDNhm3
         ZL2n7LLG3O55iR7A7bddhrC0h0XOJW27PSKeoFxG37Vo2ghPkCshjOr24RtiP85ppy2i
         DgEA==
X-Forwarded-Encrypted: i=1; AL+hErFnB5vVhVyHQ6jwqMcpUF7tDLpsPO4vEKrzndkcChW6QLEjGVazkzSHz9G/AzcMXDCoYNh3FUQcuA==@kvack.org
X-Gm-Message-State: APuU4Z+7yrx7q43F5rC5oaWn7zVwLxVQnoyVl0+R3G0wJoLSZRoJIobm
	oIWFUu8o6W9fyWvHw6i0S7Zn7TmdjGMdrSmipv/qeXwzcTjKUnPo1eXj
X-Gm-Gg: AZFdTZd8HIQKRkxIqQdv0jc+FynDtoeUtQDHfQ+vd4Ih2e9rklStDYb0uGlIteNa8P9
	LMFM/gJkakFjk448w27b7rOh+AXbuD1bHDNMvh5wHh+Xq8B09ioItuSQbAl95YiDYYapPyIsd4R
	MdzNicvrT/V3T5nUTHFMPOeMy39eBzvNJUh2EJ5+c5EMV91XCiMVAWp9OST7tSLCkpDMQ8SwaIm
	J0grUXSpjPqTDYIzoJkv8ViGZkRkyGSAaweAim77zuq02ayPAX4yGW9/MIeg1wViS8AEkEylDza
	99ygpLJk/L1QNQ/JjkJkr38sLHKZEOWFSGKcedlYwLx7TFxdRhQPFNwe0V9Nm+nPhCAeQx60joy
	P9CAJ+qX+itXFw36DevFDiyYMXjhsB8avFfIuBxcavYHOIyhGUAQasXnZBr3UxBiswuHogpoJSu
	A2FP652AbNmacxuH/CCULSPl5McnwtbqCyUxLcwhU7P/Np21W69V++Ulr1Amy0e+oXMzpjvlWYM
	r9iLwF2iDp9H1PMterCd8ULnxy6j8IhVGUsMNXemB+H5kZx0hH1inqroU/cVwlb44nz/z24pi4x
	62pmqTM/zBbY7XkFcbmrTO+r+vjnO5Jsg2fKikv3HliKhzDl6andHTt/y3B9Mpgk8zlU
X-Received: by 2002:a05:693c:4094:b0:384:ce59:5e1a with SMTP id 5a478bee46e88-3856ef457cfmr11343027eec.16.1795355396721;
        Sun, 22 Nov 2026 05:49:56 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55682d301sm20925807c88.10.2026.11.22.05.49.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:49:56 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/27] mm/damon/core: implement data attribute report queue
Date: Sun, 22 Nov 2026 21:49:13 +0800
Message-ID: <20261122134939.76758-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-3-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-3-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r9uwxh7tnk5i88ic9tdqee8bg1iqh9ag
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 141F1120003
X-HE-Tag: 1795355397-826164
X-HE-Meta: U2FsdGVkX19o46zLjwgnec/JBGc4IypcDHwu5riL8CNG3SBpALNz6G+iYiv8KfjlyBAkgPTugLWsJ97SZ1mFFB5WzLQKyAxf0/YKGNT1rwpJS6Czmg1h5/irhgmo0up7k/ODblAhMFU3SXWgpPbpjc+BsEaAaxkgNsuNY5WjuYA0piLqgp6AjwfpuOpm3xUrUx1aULs8BFLLkUf8bIvKDpAApqXRKZeNgmcSYHOBchhIkZvqGwuGij8b+LkzoznnnzpxEC+0PvdyOtkezjSDWjsD/eRTnOQJgc0l0p+qjqqq+LhRIlct6Pv/ZGoqWg8NKNQmJnZxC0nPPjMpq4eAj04eTZ7ipyelDK1y1X1hwe36OyTbb++GAzeUU151tMGliX+6qy4uiEUajGkARXBw0E96O7MuGswWFnrxtHNLnflp4MD9w2A/f/0ldalFquGODuJxzzEZM//RdDUhLx4YgnT3uZEy5PhGmOO0FXD2tfCbvqzd5a9XdJzi84w2GmNLVR2bXzAsnQP+ccvvKd6GY9C71bbJ1nlFykNeW58+8fTheh7I/bLvb0nLwzA3HwJx+UDaupHKCdKM7w/8aOaAvWdf8BbtDUxHO/DKpUgoYf0V4y853XtF92wzcWuIgHb9VkzJMFqWC2K68ZzgArqlGh8wW2Sc/T3BP2JSzlzcS7ai6DGEbiuwEkoPa5sya3N+w83VQ3cKY6xuk0aj3OHYj5q+jwkvGcnR/GO/PNrliqfGDGYZ1qPykwLEL+z5rjVWeomUe0pj64vT/9O+hpPZWp7dc0vfRo2e4r0UAKaRZ3SGqsNIb/B6Ta/MywapqExP6bu5ksWW1zWi6zi+SaETFrAFTEi5OJ8qRIDhNtitxbgwIIUtX1r0MdytCOHOUnT41955sZVhgzpvjmMcrMgaFYI6XQaMiRA3y2JuJf93ILtg6Qgl8R4VnptwY0ZUw3SQOz5bW/BcA0vXzFiADN+
 ITKptJZx
 w48Wit3vwH+8It17qvsbAXUeCoQeQCtfhLowk9NPnqUFw2L8pd8MJ9dt7/FJeM9DYoSWOchIaUqNqdNgDzzsV06CCZidY2NF1rKBDGgQVB0IydO32JNVg8kIrZzZdGYexptbTDu9kgtjdHOcT/RjCgDHCNboZh3GUlSbeY5Dh3QvbXjqqZ2Cszb8JnvlVunJncsG2jry/h1SuH7GcYZefCaO1yAyRxdhZx5qt5N/T6tBXs+M4RCzg9bCvKiJgBSjkEg2TwijeMPfE6DaWiP204QJSTQDlnpAjFh5t98QFShTEIYWvRqR25dwDUirlIKJ+a7W19DRGJ/JVGbUUKYLT/sFzzQz57QPXmD+DRpvFbYFYTX5+shI6bpFLJMBaSi8aQsff9d3OCR1G4O9YZeGhqRRby1uvtvowddLQslCRpYhvO5IsRdQioS8mo9nZ/8KugGilU4+i+tpF0oXsjh4987f9ebtiFbizwiBlZBPLr9kIlTjngXAWE++uNEkXUA5IbPtFTpUQ9lhik9nkp5jDb/6c/l3smiVst8NiPjv5nxhcQbZjhiv4pEZjsu0t4kzXVXPIhJK2IZLlQYowE/52Nsdao7yXYGv7CC1B2RcH7/zqutoRfV6NmKWMbqapR//XaQUm+QzPZxcCq1wR85W4aoUGuKCtvcG4FSRPjB0+PoVyt8Y8PXBpz9D5Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:46 -0800 SJ Park <sj@kernel.org> wrote:

> Implement DAMON core internal data structure for queuing received
> data attribute reports.  Initialize the queue for up to 1,000 reports,
> inside the DAMON init routine.  Destroy damon_region_cache and reset the
> pointer for the queue setup failures.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

