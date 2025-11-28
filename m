Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59DDECFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C756B002B; Fri, 28 Nov 2025 03:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD296B0032; Fri, 28 Nov 2025 03:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2C06B0088; Fri, 28 Nov 2025 03:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 904B16B002B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 290B913AAB0
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:34:59 +0000 (UTC)
X-FDA: 84159355518.26.675AA4E
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf09.hostedemail.com (Postfix) with ESMTP id 278DF14000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:34:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1RHhpYt;
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764318897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcsAFCCa9GxdbsC7nbqzyboHNxVecrKcAkICyMYCwCc=;
	b=xoTzolWOnRsZ3BwaZvunv0gLqTVF5xHsklxDsQK74n/OdSYDSxIELE9Nvo2bER/653F/BC
	U/SwIlTmhvoctraSVoKYG2M56Mi9UfhjHBHsu3rkUK9ux/AFyenM09148WF5gBNKdby0bC
	K9rvkVEdm8UbNTJDtPFgWg5TS//PAII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764318897; a=rsa-sha256;
	cv=none;
	b=KiZLUq2BM+4b4ggbo4QEgTMk7crLuJ9hy92OaIK3m2F5goyOaDBSJ0iYnKcP4L0kuFu+Tc
	0lGgTfQMndaOaqIe4VSPutA7Z2sfYlDdQ46J5WvqFmQX4yUiNumfb4++2Wkp32/9liMslJ
	mq/TC2q+As+UjITOGNzoGhhK7SH1szA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1RHhpYt;
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7ba49f92362so981564b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 00:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318896; x=1764923696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EcsAFCCa9GxdbsC7nbqzyboHNxVecrKcAkICyMYCwCc=;
        b=X1RHhpYtogW+sIpzerVPY5qnyhrpQmY2Zxq85e6a2FI9gVcaiOxkwk9nP1mgGgWyyk
         7hJYTGuFG/Yzyj4GfKnq1CGr9cbZphGKY31GyGqZJTvKFvBOJXNOT5sob/c3NRevlI8Z
         evUdQn2nDSNATeVbZ9sUMnUPaLuMbJ5UrFSaaLQLARA+7bCbQiDtRXecjTkifZjTxD5D
         kjzzU7SSiS3zraEw4ZD6pvhfZ7YC0Ce/lKPWqF/GOr11eFb0Bsbtryq8jbbVd63b6XJ1
         u+yRG7l1+YFiYV7XAQZWmZhpzeJ8OgGkA4rok9GofY1zXJcc17fXzvWccUxOo9AGjq1m
         gB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318896; x=1764923696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EcsAFCCa9GxdbsC7nbqzyboHNxVecrKcAkICyMYCwCc=;
        b=E2YrJ/qqKs4wwbB7bbBJN33gQnBPEYnUrEgECYH/K/Se/1pj/yexGJKDjCAANLqg6P
         M5WbuXXRphUe8gnKLeNpKGUwMHJZHCQWbTiyl8KvDsaa/LaFtC6PiXY38my7lKRNGPEv
         Nuu655MQlTRJZqykV7dtZcakZHWxzn5n2poyCtejavrM08aKk7/KQxCOZxPyhaKnwBbp
         cuDbQM60xllCuXRnFtiwW0Ku3BwgJKRKpq5D0usJ1D0wc/aJ8/ORatMGQMJysFXj+/Rz
         EJFYTgma/j5S9dThWEw58g5MEJHRKFn9qfTVdi4uUvpSCDMRVlvYT2E56IAgKXEL0AUD
         c/QA==
X-Forwarded-Encrypted: i=1; AJvYcCU23xtShpy7KeZwoZyKcZmFYw9OY9/iw6XOZQStLR+tQ1RvlGpQLjFFFL45d+VRJffOy+zxL55BcA==@kvack.org
X-Gm-Message-State: AOJu0YwRp5T1MNjgPLxi9m9H+CPLYlB31JsDdVdIESmChVIumGRKJTxy
	yTsflQoQl5+wFzexOUnK47sMZEymFEXGhlLUZEHczuJq06Z4MgpRn3yj
X-Gm-Gg: ASbGncu0U/O7BU0rECRydul0geXAwFtnB/QY3s+q2AWNP302E7iIb0JAiMSudOl4ASd
	JfvbFCw1tA+NDQVuoHEYt8Pu6kN4pQJM1acrM+yVJQ2k6Dgl2GpIkLbO5bJsGBQSqHH4axKwVk6
	0RNTS7clnHLtvB5GieDRJFzsFwQG65mnxm5HacmpBo7X3gzfw8CTC6GtuWruna/PyuxQSJ7QmIg
	7EFjGEvmlG9A8JTZol26sQkWJhLvFi16meJTlabkY7bjKaWJz0PAvirvRB/InX3qD8DK4vqnEtt
	vxKkyuIGXAr7F9Ec+BjL15GrkXQohhR0WP68vq1+yWZtbtNL7Mi76KZsUoDhhfD3YKc+Z2a4IRG
	/VFY7uDCVuuCcnBbGjSzKPFgpZiZE+3pxUkBiyV6p+jDp4wwXIdwqiwt6Z+K+LWuFjQt4AVfzlp
	fMT3ZyQsMiYOHwl3b1wUfvQgqwkPJOvutfBLcIMg==
X-Google-Smtp-Source: AGHT+IGRIPgW31QNxEa1y3QHEFEwr1+DOKPgxdKbMUF3k6w8jeb8A1O513i3CRlAvbEbmM2UpuitFg==
X-Received: by 2002:a05:6a00:1a12:b0:7ae:b13f:37c2 with SMTP id d2e1a72fcca58-7c41fbaf481mr29101007b3a.10.1764318895849;
        Fri, 28 Nov 2025 00:34:55 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:658f:a299:f849:cfdb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6c47sm4202371b3a.18.2025.11.28.00.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:34:55 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: lorenzo.stoakes@oracle.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Fri, 28 Nov 2025 16:34:37 +0800
Message-ID: <20251128083437.1106507-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <f3dc34f1-0579-412e-89a6-20e36ec67a7f@lucifer.local>
References: <f3dc34f1-0579-412e-89a6-20e36ec67a7f@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 278DF14000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: shkw1z3ry45xiq6mwic4rsexgy7jumu3
X-HE-Tag: 1764318896-844100
X-HE-Meta: U2FsdGVkX1/DzL300ae95gocmCX4Wn+9wyiJvXkQOsh8L/bjgYHzRxCM4V4OXU3WwXUS2fGagI9+VCGubcxiNU3p/BIJ3MMTzQ17RHHXSAX4EcdW1AFoXTq0F/gMgCk0+PFeZLkUemtsX6ojfW1ASSXify/YDOqYGPV0lZGd2Ej7ZbFBm9ZIVSEuDLm6HvhpV7wXbcIHa6esPJ/2T8zv3wr49peyEl46JVzn8/M71YHf5stqFMd83eZ6zu7DRw10yzvuCcaHFBdTzGt38gb+XvtF3IBUqHGaU8ApH5szOkFQ3WIFUKcW0ru9p2qWyZZspmXsBuHUyohjzZiPoGJ7mknK4EgotO7W8zqPxxJmEMdC4vKc3Qh8+L21peOYXg7IXzRqbiabkyy4FLiyOYppid4tTaJ5AYBhdN7pqCgT511pkyBrrBFA+gGpFYtEq1rLCtGEO/KDwew3tuquvLX8ElZ+pDf/ugTsLE6sUO2kQmUiMcBlgoOkKRAW5hBhnj8sWCQOzE/8NGh4Xha8Maxcv1geIoVbIpDE0mVr/Bl7gwl7f/mBJ0ZmG+JwlRYD8d4MMbms/3wbcmbEiwJiPTIDzPCuylvxxiQ0Bsdlo+v7jgbE6EP37/z7ZS5ALR2Wm3o3ZXljW4sRbk0Xm1LWedd8RzdULrUYLJqcVTHnJRDLSw9hjgXSWpFVvH571LZ1BoqAGEVr1xknotX4Y+o8wGZi4AIJr/Ddx2Rn/a2UGsKsfJn3/s3OhWi9WYTeLdmpHVwOsu6sVf+oM/4JP2RYpgUF6fCa5WWkuYTziPSdikQ7rauFn9C2ZM6LrxlgGTRpy7xlK055yFJWqyKU3xiEivJ8+aUEycpqliGGPVhMJdccp+uUxJAtRw5pu6z0iPJ2gVfrXV776QsV6IDwQJHVUtqSogUQN6jggBMJojM6KBZLBrpO37nqyaFGnbl1Rx/3YjJLPoU0w9lJ0JNSdkfF/is
 QsqmfSYb
 NNqlEW76uHKGxzrCs5nGPcLq+EJBpl1vHSxlfCmfhA+0vURacsDcdZ8VmpFlwZDVeOXdV9sVEvKvGCbIOGArF7589+3ilgrRd9wIwmXFtJuRaiAZX1mo3izBFQjSMKWiawt8N6XLUpedwrkU2RZxOjyUX2Bkc/oswxzQi7CqbWrl6cABhr6w7Ah4+IiLfSUmb8UhbXUa/YKcGjFT57/CFKVFThsfPFqhwSrObO+VaiGS6HJKLrGh2HL9XGDVfGTHOtXsnE9wlMUtm73w19cKOXeey3DAZj8nOSxfLpFPmquVGCeE3TN8WF4CbRMa7PQSvYeoB3el0qGICbIP5ARwLhP8sFa9ka4uy/+H0yVbNPptybKd4qZs0Ka+QIa6Gy2LcGoY+hPLaeke36kO4/SSfA5I0quwa1EqXZhb9XkbDg3CtOjA7r+tRMUZkK1u8qmLRurE3F7qMaR8KYSNk+m+B5L0HN/vvTI7lz2fzs2ljzl9Hyh4dp9+4qMwwMTFsUeHW5J9OnxupgJckQro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000196, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Just a general plea :) could we please try not to send larger series like
> this so late.
>
> We're at the last day before the merge window, this is better sent during
> 6.19-rc1 or if now as an RFC.
>
> Thanks, Lorenzo

Hi Lorenzo,

Thank you for your feedback and sorry for the late submission. You're
right - this series should have been sent earlier. Apologize for not
following the proper submission timing guidelines. I'll make sure to
follow the community norms and submit similar work well in advance in
the future.

Thanks again for your patience and guidance.

