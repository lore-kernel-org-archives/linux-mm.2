Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4735ACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCD08E000F; Mon, 13 Oct 2025 05:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D3E8E0007; Mon, 13 Oct 2025 05:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76BCC8E000F; Mon, 13 Oct 2025 05:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 631A88E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:33:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D1A3B8341
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:33:18 +0000 (UTC)
X-FDA: 83992577676.07.0E6FFEC
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 57611140002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:33:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KfyP4H0/";
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
	b=bPdA19bgpjYIfBPjGJ6BOJFCVdcXtJnhkQjmxnGQhppSNRKV7Oh7gb+jFPLZTh18GOlIpl
	0BC9syq3S6WgV/T79DlLqVMnrIHjNlndOpWByLSBeSmpdYruOFyuNX3uTbfZ6XTC4KkrM/
	ooX+mOkCKnoKhQS9Qo2mkjSp8vgfO24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760347996; a=rsa-sha256;
	cv=none;
	b=k+zZK3ZKyGcXbf0L3BIJ2MCv+h5QFb/teThtQ8esVez8R3PVIgq+olVM7WkwOiYMoRhUxE
	Xoi5Q3kMHLPq+lc3ZwdJ45bej5kkwnZwFqAzCQAlMwpsdBAHtMS82yTVmIQy19mT6kazaX
	l7C/1uuzziz++KNodVhMv9FfESdWPM4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KfyP4H0/";
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b6093f8f71dso2376696a12.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760347995; x=1760952795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
        b=KfyP4H0/MqDK0dmQDh9aGvnrFloU+NQHF3X/tRU41TtR0BH7wiUSjONkIR5mfrLjlY
         5qSCEYWgOz4rrIKNyde6tEdMRg4PhY5WMwBsdBQURA4SY2XlzeLV3PwQ2XKOXVaPNoWT
         qsxDJKMddojESBdYhZ9c0o+mHe/Q2jvNGqSIL3115pfjurPEpdg/voCLAAuPKSPHcEaT
         rouXxVOXioD8S0bqbcws5a+ZgSTVXVjzSmYwjbD6KVLINOdjoksKKP6g96Y+g7sNJQpD
         ICo4BepPhLKaV06Licxkt/UBOIuKu7VVuuikLV7ExrE8vOfHnpCPZKpeaBZlfMt2NLe3
         GWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760347995; x=1760952795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
        b=JBw8sjAEUYFsHhqMTeZDexUXGWfI5K3UlJZscICD7CQ6gBVCsD/5SURscJlR2GrUei
         VmbgA0UBLe91x4vHcTWyuMjvoz66rt0i/AyAzmDegxHdICRjXDISKCp3jl/44gXIwKVF
         PQ3e7PZAwM+5KYQr3M+HgDmGRwD7bHepE1LpGZd/Q4dQacvvoh9KVgbOucr88pgkquuD
         m1sS46nYI9uGBp8QgCGUGVfrWXQw+Dd27iJFVnmwgxEdnXnvWeNnZYntYJ//jK19GccP
         o2T6o6lSvEScvPtZ52v9PielVjIMAsO/NFRDQl4Gne80ffRDvCLEbaf10Fsskj+DNXnR
         RX6Q==
X-Gm-Message-State: AOJu0Yy6yTYK3lAMa+sS3z2NPIklI3rVeUXcQMiVcDbOY0ofnx51zJu3
	wvYxdxRD43ak7v1y/pyIT4YcgXHvkhKtFuPblt2Odnsz9lACZnS+QnC2
X-Gm-Gg: ASbGncuzclIzRBnIJFvOrdhUNeT5heQgP8vU9dCXZQxL6uOPq5MKv6qXCmEXXFNVhJd
	knHWjibEz+KtU19ZUiUotzVRdyVDx8M+qxq/QcQnBNtHAm6yM03AIA1WbpOm7sDxtWhFD+lo9Q1
	XcVlL14uH7UsbT5XHD2KR9JrbYLO+ycNMXF+e7TQJfX5TZ2TnES/FVjG5IfaS/YoEvHquM1TOcH
	4X3R3yOtzk/eK77iAWdwswtDq9dbNQr+FLCGyYSd2Sisp9s1ri2MXp7B4IBGmnadnJmIgla2HCc
	Jl+Mzsn2bWVCknkNP3R8Hdm2gbpKK/dPtr6Zo8TVnuWO8rFaVsfmxzBF1jxfXTo8ni8FHjEs/ZV
	8+QpVKoKbEIvsSKDOrp6QZ5dSMjaLIt+9ylEIoo9+JeSSPvRCYO79/liBpVTY+PxeuCE22EIQHT
	CY+BcsPmxGeVkR21V7+71TgQ==
X-Google-Smtp-Source: AGHT+IH0wNeCmi6Nm3mbhxY1jYdf0pHFrePpYJ0QMmFlRk4paq72BgVsKzjHY7I++yEULkVs3KhVbg==
X-Received: by 2002:a17:903:9cb:b0:266:702a:616b with SMTP id d9443c01a7336-290273799bdmr251401225ad.18.1760347995071;
        Mon, 13 Oct 2025 02:33:15 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:abb9:ca1f:244b:3697])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f93b71sm128568755ad.114.2025.10.13.02.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 02:33:14 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: =muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
Date: Mon, 13 Oct 2025 15:03:08 +0530
Message-ID: <20251013093308.4412-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: k56igefgecm38z349oyoq547iyncimmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 57611140002
X-HE-Tag: 1760347996-703313
X-HE-Meta: U2FsdGVkX1+rVjx/uE+JxNMgSZA/YwqnTm0zRpglSRZdn/kLlWeHMIp4896KV0PFhvxlL6wqc48F5QGaH29ZXGWL1ZSfwEjDoZMBWS3UX5+VgcmXYvO+dANE2uSZQRSwh7j/ByImj1DtotslFEVFuwLrr4BjDY0aqKaVd/LbH2iTPFV0pmG8TuwOQjfLRKotopU5yYlbjHVPoKRA1y9eL8G0lPngWso+4n8jLodeAE079v6/vwFgEjdfZ3RqnqAwLx1heoxC3R85mi/jLjdos+yrt759Fvb+/pNHUrMy4LLL3TbJf10lggLS/TWja59l7z8Kerr144wzqjBUAu7GLlnc+F4ToOGicIYDlrgKzur6zLuedSaXYjmWklnB+aLeZHqwcI/rhoLQY2ABylx6YjhFE9QKZw1mQoGAtCafVYbhHFxo074anACbRhZsGhxQnaB6MCKPyrRFz/Loq+0yJ0L5H1ZDXkZzBCDG7CK5slsAkG02Ab1Heu1ryGtYekTnlRtnvGnbcG0+KAl6XfKnKSfwjABGbtr/JYUIavzJMbHMGeJnQpxw+UA1xExhhqhpGmNeN5SNtc+eGYdpb1rjqp+HN9jkMT6TEWpC0XjBHOfD14rmunRfsxD3N2D/Fidlwn/o8ePObLBIyVBX4s9MAmh4+vFIDZ45AMjuPRIScv5N0nFTH7w5z65zH5xRnG1srp83lRhyOdi9nXLsFcFfFk/ZiR5zU9aWR/qs3ag9hF5sND62ARLH2bzZKfgeo/Q8wDYJ6/6iq64bFFGcXrVl2G9UOzuhd0RS6lRxqkFkWcchOUHkerDZxpshngj25j9ViFSzNxsmyTluEiN0Ki+aLIcKY7VRtiAfSdQ60bNIKfSq2Ugg2Np5ggk3VXba5aQ54EkNnafQLOFP5YVIypXRJUwwHDDyJISSjxU6Y3P+ZQOCmQcw3zA3mK+txLII3/Q4g82vOQM82iwV1jpK/zC
 GylHp1XD
 C66WTK3E51QzMixHb5fiS+MXS9jsh8uTJd/4tIjDZQhjkt6X8uy5hHF3Sb8ZOEuLqoGyblco+xisw/W8Wxd++uvVnXOZHEDGLeh3ozpMb4yL/4CPMGhJN6Pqa0o3+rBMahxa2UCaGi3ZOyfLzcsdtbEpb/N9QmXaJ0MUysrNdIdQH/1C433Bwe9L6zsx9VmCkd5CRfVZvhKi/tY1tMOYOywVYcdcNsMceGq6xSGSUl8CHn2Dv9yzzPlxL5KGxMpYp5eAq9TttcP8p9FowbJ2sjVUuou6n69UHdAsseXy+dbIHkXNEuCQ5S+0Rk7cRG9kpO2rBN98GCSrTbZG4GRys4UVQbILEAfv8yZCVc+rRCD1jnciBNJYrYBbbdRoxpjupG1iW5alf4feiUexn2yib97okoL6u2NrtaXe5qqMgoVRB4akU/nkRiPRX52/ZC4v31D1lrsukTQHnv3VLdk6YjVCsQBjdwP8WbUvpKNFMgFF2npT3UETWwaobWz9klwVvZbskGN2nC+K26FI/TP8DOnOrFPKFLgRsOKnFXl4/I+Q8tLyq708aMtXaTvDHnVo4j5IC42KYgYMv+d4DPrY7ZgoKdLtS6RKZRwe2bqBCnICTboKJDXQh4Ei14hiA4NU4O7Zn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

That makes a lot of sense - moving the assertions after the early return 
checks is cleaner since the locks are only needed when actual unsharing 
work happens.

Should I send a v5 with your suggested change?

Thanks,
Deepanshu

