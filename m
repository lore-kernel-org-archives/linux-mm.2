Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2CCC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC63D6B08D2; Tue, 18 Aug 2026 03:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C764C6B08D5; Tue, 18 Aug 2026 03:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17196B08D7; Tue, 18 Aug 2026 03:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 743E46B08D2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07B561A0B62
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:12 +0000 (UTC)
X-FDA: 85113503664.19.385DA8C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3399A18000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I301Fkod;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
	b=B605m1CFOGIueG5Rz8WsY+Od5Wl2yGpwLFFtSUQ/rb2HkJMYPMZ7Fc6i3e6sgqaa09Xm39
	6sNW0DFT+Mad+HkFTqaZqFALblX14MJdkXnANlEsbK4vLL+YeagRtQHuQly/93Ce2bGIYi
	BN6UG+USw/IXB/wOLyqNN2lfGDfZnq0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I301Fkod;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036710;
	b=LzYW/xjR++dv3OxyUVcHAqnxt+ISjFyVGpb4NtmBS77XhuwzrC0We5svQ7LPjkOHT3lCl5
	dxvj4pPLwSGZqiGFTDSCfmE1mT5ByopNnYYwf/4LEobMpe66x7O5R749koamg8fDV1BWGO
	DErJpP33HS/XXE0OqH8XJNBH+NqJ1M0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4996c452e95so3826355e9.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036709; x=1787641509; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=I301Fkod9NrBmDiaTHzuEpm2cnAlVIGQWy0fYFLdA0zMrqynGcWnnUw+k2h/hdsS5W
         Jbc/j3y5zBo+qCBtgp/dlpaUGmsgzLc9ioRNq6hk8kL3aGCiyYLQn87Ku/E224K89hfC
         ZXGdpf316oOAt6esNsMjq6bm/pp+xFFblAvxiGP9SyM/GWVgNTuViBrFKj3UI7mx+HMU
         TMbBn5DvpPEfCZCkOmk55vsFQchiycOLKOkE9dWWQLGWAMKXwXpycMm7l6runIwM6wWT
         SOaJNuwLwOt8Y8o2MByi2LHtdWWRqOq/3YL6Uv9KjPHcxJC/qi/1rZMhalE8QsMQQQfy
         TnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036709; x=1787641509;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=oIki/WhzMOUcnhQWiq2FkdtV+5K3diyba7MoDneSnIftFQdUBXdMq5Pxq1HWdCp5gU
         5JZDG3Ez5A5/q9Ussun++LqkIgRLmRACTXI3438vAbXZTAIzNOYeD9lfX18KmLX7cUSN
         zuQJ/uP5L+G+uvmktFLRJQW6KbnwKg2gsG5lhJskrRimcAs/M7+IGOeFsVpl3xTbSc1K
         84zDMhcxlA3jDXX9vwfmmmTnk0nYRlgw/qWnS0c4UtBpMY7nBy2hHTg9KpXYTDR51uhg
         YWTC0iudrbmQIIS3Bgse5uIsh/HrQCf4+SPi5qjWZMfWnrsvZsCnC5nf0YQLTCZUww0v
         BXJA==
X-Forwarded-Encrypted: i=1; AHgh+RpprY4uOronwfWHyQ8gUlbbB7KjgKSrt0zoWCNKukSUzAk4ggBqrz7NeSVJ4iT5kw9wniBdLGv1zA==@kvack.org
X-Gm-Message-State: AOJu0Yw0Gxs3ugn9XU6kc5TvpAFhHPC477F9Cu9/VcuFGXUIZYVJC0mf
	89Jy8Qbsy8ztaMQjpgJ0spGg5R5UuLKxXRPCU4eFxu17L9E05niCVhK9
X-Gm-Gg: AR+sD11S7ZrkzWxBf2eN6+Is3FWamnh64dG2dg6yjzH+VJ6JOWmqk8TZmigrIjcjthR
	MQqPpGpqoqoqivl/Ab2y2TqF8oxkiJtlh0CRxPQ/nTW5AJR5xiwORkaqL+tGPJS7MAHjWjn+MpE
	thyQ2pjPLQVY7MXH9G8HCFVKdHPtetkurUZtPJlK3PP4H7fWWU0q75t1O/0qYMEv562PF6zs1jZ
	dIkdOPX+6v0b1jhLlpEFVTiVkct9OaLnsXzlUakOJY9Dq43nuxcNltPWfgnIuYhE7OFCjIS4wFg
	oYLA0oGx4Jho7Nn5SpZcg0Tt/N2dyrVo1l8LHKksYnjkJCM1lt/f3MGCuYfyAWGW85A5Yc9pX5D
	7P036X+XS/6HIPeHsbXoVR7k2ka+7EP1YEVtEq1i7UVaQMhEpuPGsR/+WvBBfMa819tK3BvpeDT
	B/xbjur4ValBC57mNWeTx2Fq4cLnb4lsT6LGmRyJjUVK1mOZehws/vt5dCHutBANIxs49Sv8uy9
	r1fSi/GNOJdQkE6UzxmEA1TZzT/xVZ2pqyFkvy31PAGIiws1Qo8yCh7GhLmF3xkLWC/SC541HJO
	gfcbgsqv9GMKeAyPAYEikz28XP4RxfSgq8FgK/WS+fr2AA==
X-Received: by 2002:a05:600c:1f91:b0:499:59da:12b9 with SMTP id 5b1f17b1804b1-499878cf8famr209718415e9.0.1787036708705;
        Tue, 18 Aug 2026 00:05:08 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:08 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 3/7] docs/zh_CN: update DAMON index translation
Date: Tue, 18 Aug 2026 07:03:45 +0000
Message-ID: <20260818070358.455768-4-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3399A18000C
X-Stat-Signature: 7tcisrychahbbkceesetnb7a6tknkok3
X-Rspam-User: 
X-HE-Tag: 1787036710-280221
X-HE-Meta: U2FsdGVkX1/ix3RswMY547lUEkuIAXqMo/i9xyXD1oK4c90t3npM5y+ToUuDd3BC5P2wVrlb1xsZoHMYaFZmZsPDvYfVM2PVgXuRrN7maJM0U4Pe29QQc1HbWHzglWvK43OMBYWgbngjJUQJAn49xF/Nsoanagd7eqHO4ClNIqlkb81phpqoXPdbuPElns1WGwDBd0QP24NQF90QknuqiJGrcRXrsU1P69bSMjVp4vffJlnmRRDaUn8C7o0w4GgKzX+t4ZaYjdpk7Kz9+220Uqeu6wSbGY5JxdrSpQYOvge0AGkC3aIMk0ufUmwIyOGIQDwDYgGyWDj0pX76oEMR48j5e3RpOHWVuWyBRj97kRDVy+SxA2+iF77m6oCt/XnlnJnrMo4WY/RashnR0i6Nmclthy8JplA11tUB6rWmbDy/3ZQxDtEN0sj8Bty8v0/G3TH2YXYl2MFWIB6ICfOpIvB9VF5vR8veDWqd3J90WFcsrPGX/rwxtYgdJVT8ob7Rg61/Hct4Qvb21wq3336QL3FSxRREMa+VCr4qMH4OPgy1S9UzMhCcX2QofUQcX/R2tjlZ9aHc/qzBZIW6Mk4U0lwQgSXMqQMZHNiiB5UJc/PRQKLtVS1iIK0Dizktlmqm0IIyDMd5cRuhuHrElHH8cf276/urJEXDcnaVcfhZrR0pOsSALyF71xMSOq08olrHwiPqgdjwne5DVMW6uiG7boBBf5xKn5O/Nec6CkFhd9NuQgCekKj+uC/i9FDpBnJNd6CrS7aYIXJF7IBNUbhTD21stgEifP7GW/7fy3Yf87YiCw4o4pWsTpdqeg3yHxnCHZ55NUC3QhD9lapS/a1Gmd8323Kw05OeKvG4wXL3jug7ZbzUPuMzqlTIiTviBxEoIvZ0CX6r3dMy1wK/cNEErqqsZ83/rbiK2kFC4AYhovNOp/N6OgfTG2skoQQruV/64+CM9FxeKPKIhWeA1/J
 gyJSb8Lo
 45E+QHFIm101RbtIm39uMv5GWeH7ugApUd3u335LEL6bimDKAM5GfdQwoi6DAstlEhrivONeTSPM9sqcu4mCEUDlqq5yxMWCLZ2k6675tW+sQr84CcdFr+EkggyE8J/sjzjNmORs5tn8u3x6qzn2iQkS/qLdaHA11QkVsI0bjLygEAUydBduKwZ3Gs5GWzajEK4UxrBqZa08NwF8bRUzYJGaJfvtTJaVDAtIWkbfIEl4K0gu9j0X7/3ArcI1VnvNHouNd03AnRhA1jWlpBXUGimd/SzxK9RjjRLSNkTkrinjtPmYV8BBvJxuSDAehUm3f4MU8PPsJrkgL5IZfKIJIMWQ/JPO3cOEbL1GJsgl4bH4cn8HI318T6JH73s6MCuh9sdl1e3e+IrowAS60B+HVgEuq4rtcjwlNt+IB3hyBbTYLl8KV8dT2JKCXTJk0HG/MXar8WGwisMpNT4z7pcOfjgPeOUJsfyxKfVsxBAeG1EsCR/lIPN2K/YGJ8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/index.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/index.rst          | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
index 6f8676a50b38..77bbfa7c25dc 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
@@ -9,12 +9,12 @@
 
 :校译:
 
-============
-监测数据访问
-============
+========================================
+DAMON：数据访问监测和访问感知系统操作
+========================================
 
-:doc:`DAMON </mm/damon/index>` 允许轻量级的数据访问监测。使用DAMON，
-用户可以分析他们系统的内存访问模式，并优化它们。
+:doc:`DAMON <../../../mm/damon/index>` 是一个 Linux 内核子系统，用于高效的
+数据访问监测和访问感知系统操作。
 
 .. toctree::
    :maxdepth: 2
@@ -23,7 +23,4 @@
    usage
    reclaim
    lru_sort
-
-
-
-
+   stat
-- 
2.43.0


